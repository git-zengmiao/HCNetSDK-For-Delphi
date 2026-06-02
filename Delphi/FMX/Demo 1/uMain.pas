unit uMain;

{
  海康威视 HCNetSDK FMX Demo 1
  功能：TabControl 框架 + 初始化SDK、登录设备、实时预览、抓图
  布局：TabControl 包含 tabHome（首页）和 tabVideo（视频监控）
  核心技术要点：
    FMX 中只有 TForm (TCommonCustomForm) 有 WindowHandle，其它控件均无原生 HWND。
    解决方案：在 TLayout 所在的区域内，通过 Win32 API 动态创建一个真正的子窗口
    (CreateWindowEx)，将该子窗口的 HWND 作为 hPlayWnd 传给 HCNetSDK，
    并在 TLayout 的 OnResize 中同步更新子窗口的位置和尺寸。
}

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.StdCtrls, FMX.Edit, FMX.Layouts, FMX.Objects,
  FMX.Controls.Presentation,
  FMX.TabControl,
  Winapi.Windows, Winapi.Messages,
  HCNetSDK;

type
  TfrmMain = class(TForm)
    // --- TabControl ---
    tcMain: TTabControl;
    tabHome: TTabItem;
    tabVideo: TTabItem;

    // --- tabHome 首页内容 ---
    recHomeBg: TRectangle;
    lblHomeTitle: TLabel;
    lblHomeDesc: TLabel;
    lblHomeVer: TLabel;
    btnGotoVideo: TButton;

    // --- tabVideo 视频监控内容 ---
    layVideo: TLayout;
    recVideoBackground: TRectangle;
    txtVideoHint: TText;
    layPanel: TLayout;

    lblIP:    TLabel;
    edtIP:    TEdit;
    lblPort:  TLabel;
    edtPort:  TEdit;
    lblUser:  TLabel;
    edtUser:  TEdit;
    lblPass:  TLabel;
    edtPass:  TEdit;
    lblCh:    TLabel;
    edtCh:    TEdit;

    btnInit:    TButton;
    btnPreview: TButton;
    btnCapture: TButton;
    btnStop:    TButton;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure layVideoResize(Sender: TObject);
    procedure tcMainChange(Sender: TObject);

    procedure btnGotoVideoClick(Sender: TObject);
    procedure btnInitClick(Sender: TObject);
    procedure btnPreviewClick(Sender: TObject);
    procedure btnCaptureClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
  private
    // SDK 状态
    FUserID:     LongInt;
    FRealHandle: LongInt;

    // 嵌入在 FMX TLayout 内的原生 Win32 子窗口
    FVideoHWnd: HWND;

    // layVideo 所在的 TabItem（用于切换时显隐子窗口）
    FVideoTabItem: TTabItem;

    // 延迟同步定时器（切换Tab后FMX布局可能未立即完成）
    FSyncTimer: TTimer;
    procedure SyncTimerTimer(Sender: TObject);

    // 创建/销毁/同步 Win32 子窗口
    procedure CreateVideoWindow;
    procedure DestroyVideoWindow;
    procedure SyncVideoWindow;

    // 根据当前 Tab 状态显示/隐藏 Win32 子窗口
    procedure UpdateVideoWindowVisibility;

    // 工具函数
    function FormHWnd: HWND;
    function GetFormScale: Single;  // FMX 逻辑像素 → Win32 物理像素的缩放比
    function GbkToStr(const AAnsi: AnsiString): string;
    procedure ShowSDKError(const APrefix: string);

    // 拦截 Form 的 WM_MOVE 消息
    procedure WMMove(var Message: TWMMove); message WM_MOVE;
  public
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses
  FMX.Platform.Win;  // WindowHandleToPlatform

{ ============================================================
  Win32 子窗口相关
  ============================================================ }

var
  GVideoWndClassRegistered: Boolean = False;

const
  VIDEO_WND_CLASS = 'HikVideoWnd';

procedure EnsureVideoWndClassRegistered;
var
  wc: TWndClass;
begin
  if GVideoWndClassRegistered then Exit;
  FillChar(wc, SizeOf(wc), 0);
  wc.style         := CS_HREDRAW or CS_VREDRAW;
  wc.lpfnWndProc   := @DefWindowProc;
  wc.hInstance     := HInstance;
  wc.hbrBackground := HBRUSH(COLOR_WINDOW + 1);
  wc.lpszClassName := VIDEO_WND_CLASS;
  RegisterClass(wc);
  GVideoWndClassRegistered := True;
end;

{ ============================================================
  TfrmMain
  ============================================================ }

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FUserID     := -1;
  FRealHandle := -1;
  FVideoHWnd  := 0;

  // ★ 视频窗口位于 tabVideo 标签页
  FVideoTabItem := tabVideo;

  // 延迟同步定时器：切换Tab后FMX布局可能未立即完成
  // 100ms后再次同步子窗口位置
  FSyncTimer := TTimer.Create(Self);
  FSyncTimer.Interval := 100;
  FSyncTimer.OnTimer  := SyncTimerTimer;
  FSyncTimer.Enabled  := False;

  // 初始状态按钮可用性
  btnPreview.Enabled := False;
  btnCapture.Enabled := False;
  btnStop.Enabled    := False;

  // 默认显示首页
  tcMain.ActiveTab := tabHome;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  // 停止预览
  if FRealHandle >= 0 then
  begin
    NET_DVR_StopRealPlay(FRealHandle);
    FRealHandle := -1;
  end;

  // 登出
  if FUserID >= 0 then
  begin
    NET_DVR_Logout(FUserID);
    FUserID := -1;
  end;

  // 清理SDK
  NET_DVR_Cleanup();

  // 销毁子窗口
  DestroyVideoWindow;

  // 销毁定时器
  FreeAndNil(FSyncTimer);
end;

// 获取 FMX Form 的真实 Win32 HWND
function TfrmMain.FormHWnd: HWND;
begin
  Result := FmxHandleToHWND(Self.Handle);
end;

// 计算 FMX 逻辑像素 → Win32 物理像素的缩放比
// 原理：对比 Win32 GetClientRect(物理像素) 与 FMX Self.ClientWidth(逻辑像素)
// 100% 缩放 = 1.0，150% = 1.5，200% = 2.0
function TfrmMain.GetFormScale: Single;
var
  FormWinHwnd: HWND;
  cr: TRect;
begin
  Result := 1.0;
  FormWinHwnd := FmxHandleToHWND(Self.Handle);
  if FormWinHwnd = 0 then Exit;
  if GetClientRect(FormWinHwnd, cr) and (Self.ClientWidth > 0) then
    Result := cr.Width / Self.ClientWidth;
end;

// GBK (CP936) AnsiString → Delphi Unicode String
function TfrmMain.GbkToStr(const AAnsi: AnsiString): string;
var
  nLen: Integer;
begin
  if AAnsi = '' then Exit('');
  nLen := MultiByteToWideChar(936, 0, PAnsiChar(AAnsi), -1, nil, 0);
  if nLen <= 0 then Exit(string(AAnsi));
  SetLength(Result, nLen - 1);
  MultiByteToWideChar(936, 0, PAnsiChar(AAnsi), -1, PChar(Result), nLen);
end;

procedure TfrmMain.ShowSDKError(const APrefix: string);
var
  errCode: DWORD;
  errMsg:  AnsiString;
begin
  errCode := NET_DVR_GetLastError();
  errMsg  := AnsiString(NET_DVR_GetErrorMsg(nil));
  ShowMessage(APrefix + #13#10 +
    '错误码: ' + IntToStr(errCode) + #13#10 +
    '错误信息: ' + GbkToStr(errMsg));
end;

{ --- Win32 子窗口管理 --- }

procedure TfrmMain.CreateVideoWindow;
var
  r: TRectF;
  rc: TRect;
  Scale: Single;
begin
  if FVideoHWnd <> 0 then Exit;   // 已创建

  EnsureVideoWndClassRegistered;

  Scale := GetFormScale;

  // layVideo 在 FMX 逻辑坐标中的绝对位置
  r := layVideo.AbsoluteRect;

  // ★ 关键：FMX 逻辑像素 × Scale = Win32 物理像素
  // 在 150% 缩放下，逻辑 680px → 物理 1020px
  rc := Rect(
    Round(r.Left   * Scale),
    Round(r.Top    * Scale),
    Round(r.Right  * Scale),
    Round(r.Bottom * Scale)
  );

  // 在 Form 客户区创建 Win32 子窗口（坐标和尺寸均为物理像素）
  FVideoHWnd := CreateWindowEx(
    0,
    VIDEO_WND_CLASS,
    '',
    WS_CHILD or WS_VISIBLE or WS_CLIPSIBLINGS or WS_CLIPCHILDREN,
    rc.Left, rc.Top,
    rc.Width, rc.Height,
    FormHWnd,    // 父窗口 = FMX Form 的 HWND
    0,
    HInstance,
    nil
  );

  if FVideoHWnd = 0 then
    ShowMessage('创建视频子窗口失败，GetLastError=' + IntToStr(GetLastError))
  else
    // 初始化显隐状态与当前 Tab 一致
    UpdateVideoWindowVisibility;
end;

procedure TfrmMain.DestroyVideoWindow;
begin
  if FVideoHWnd <> 0 then
  begin
    DestroyWindow(FVideoHWnd);
    FVideoHWnd := 0;
  end;
end;

// 将 Win32 子窗口同步到 layVideo 当前位置和尺寸
procedure TfrmMain.SyncVideoWindow;
var
  r: TRectF;
  rc: TRect;
  Scale: Single;
begin
  if FVideoHWnd = 0 then Exit;
  if not Assigned(layVideo) then Exit;

  Scale := GetFormScale;

  // AbsoluteRect 是相对于 FMX Form 客户区的逻辑像素坐标
  r := layVideo.AbsoluteRect;

  // ★ 逻辑像素 × Scale = 物理像素
  rc := Rect(
    Round(r.Left   * Scale),
    Round(r.Top    * Scale),
    Round((r.Left + r.Width)  * Scale),
    Round((r.Top  + r.Height) * Scale)
  );

  SetWindowPos(
    FVideoHWnd, HWND_TOP,
    rc.Left, rc.Top, rc.Width, rc.Height,
    SWP_NOACTIVATE or SWP_NOZORDER
    // 注意：不用 SWP_SHOWWINDOW，显隐由 UpdateVideoWindowVisibility 统一控制
  );
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  SyncVideoWindow;
end;

procedure TfrmMain.layVideoResize(Sender: TObject);
begin
  SyncVideoWindow;
end;

{ --- TabControl 切换处理 --- }

// 延迟同步定时器回调
procedure TfrmMain.SyncTimerTimer(Sender: TObject);
begin
  FSyncTimer.Enabled := False;
  if FVideoHWnd <> 0 then
    SyncVideoWindow;
end;

// TabControl 标签页切换
procedure TfrmMain.tcMainChange(Sender: TObject);
begin
  UpdateVideoWindowVisibility;

  // 切回视频Tab时，延迟100ms再同步一次位置
  // 原因：FMX 布局引擎在Tab切换后可能需要额外的时间来完成重新计算
  if Assigned(FVideoTabItem) and FVideoTabItem.IsSelected then
    FSyncTimer.Enabled := True;
end;

// 根据当前 Tab 状态显示/隐藏 Win32 子窗口
procedure TfrmMain.UpdateVideoWindowVisibility;
begin
  if FVideoHWnd = 0 then Exit;

  if FVideoTabItem.IsSelected then
  begin
    ShowWindow(FVideoHWnd, SW_SHOW);
    SyncVideoWindow;  // 切换回来时立即同步位置
  end
  else
    ShowWindow(FVideoHWnd, SW_HIDE);
end;

{ --- 首页导航 --- }

procedure TfrmMain.btnGotoVideoClick(Sender: TObject);
begin
  tcMain.ActiveTab := tabVideo;
end;

{ --- 响应 Form 移动 --- }

procedure TfrmMain.WMMove(var Message: TWMMove);
begin
  inherited;
  // Form 移动后同步子窗口位置
  SyncVideoWindow;
end;

{ --- SDK 操作 --- }

procedure TfrmMain.btnInitClick(Sender: TObject);
var
  struDevInfo: NET_DVR_DEVICEINFO_V30;
  sIP:   AnsiString;
  sUser: AnsiString;
  sPass: AnsiString;
  nPort: Word;
begin
  // 自动切换到视频Tab
  if tcMain.ActiveTab <> tabVideo then
    tcMain.ActiveTab := tabVideo;

  // 1. 初始化 SDK
  if not NET_DVR_Init() then
  begin
    ShowMessage('SDK初始化失败');
    Exit;
  end;

  // 2. 设置日志
  NET_DVR_SetLogToFile(3, PAnsiChar(AnsiString(ExtractFilePath(ParamStr(0)))), False);

  // 3. 读取界面参数
  sIP   := AnsiString(edtIP.Text);
  nPort := Word(StrToIntDef(edtPort.Text, 8000));
  sUser := AnsiString(edtUser.Text);
  sPass := AnsiString(edtPass.Text);

  // 4. 登录
  FillChar(struDevInfo, SizeOf(struDevInfo), 0);
  FUserID := NET_DVR_Login_V30(
    PAnsiChar(sIP), nPort,
    PAnsiChar(sUser), PAnsiChar(sPass),
    @struDevInfo
  );

  if FUserID < 0 then
  begin
    ShowSDKError('登录设备失败');
    NET_DVR_Cleanup();
    Exit;
  end;

  btnInit.Enabled    := False;
  btnPreview.Enabled := True;
end;

procedure TfrmMain.btnPreviewClick(Sender: TObject);
var
  struPlayInfo: NET_DVR_CLIENTINFO;
begin
  if FUserID < 0 then
  begin
    ShowMessage('请先初始化SDK并登录！');
    Exit;
  end;

  // 自动切换到视频Tab
  if tcMain.ActiveTab <> tabVideo then
    tcMain.ActiveTab := tabVideo;

  // 确保 Win32 子窗口已创建并同步位置
  CreateVideoWindow;
  SyncVideoWindow;

  if FVideoHWnd = 0 then
  begin
    ShowMessage('视频窗口创建失败，无法预览');
    Exit;
  end;

  FillChar(struPlayInfo, SizeOf(struPlayInfo), 0);
  struPlayInfo.lChannel  := StrToIntDef(edtCh.Text, 1);
  struPlayInfo.lLinkMode := 0;   // TCP
  struPlayInfo.hPlayWnd  := FVideoHWnd;   // ← 关键：用 Win32 子窗口的 HWND

  FRealHandle := NET_DVR_RealPlay_V30(FUserID, @struPlayInfo, nil, nil, True);

  if FRealHandle < 0 then
  begin
    ShowSDKError('实时预览失败');
    Exit;
  end;

  btnPreview.Enabled := False;
  btnStop.Enabled    := True;
  btnCapture.Enabled := True;

  ShowMessage('预览成功！');
end;

procedure TfrmMain.btnStopClick(Sender: TObject);
begin
  if FRealHandle >= 0 then
  begin
    NET_DVR_StopRealPlay(FRealHandle);
    FRealHandle := -1;

    // 清空视频区域
    Winapi.Windows.InvalidateRect(FVideoHWnd, nil, True);
  end;

  btnPreview.Enabled := True;
  btnStop.Enabled    := False;
  btnCapture.Enabled := False;
end;

procedure TfrmMain.btnCaptureClick(Sender: TObject);
begin
  if FRealHandle < 0 then
  begin
    ShowMessage('请先开始预览！');
    Exit;
  end;

  if NET_DVR_CapturePicture(FRealHandle, PAnsiChar('D:\hik_capture.bmp')) then
    ShowMessage('抓图成功！' + #13#10 + '保存路径: D:\hik_capture.bmp')
  else
    ShowSDKError('抓图失败');
end;

end.
