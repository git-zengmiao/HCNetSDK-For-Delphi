unit uMain;

{
  海康威视 HCNetSDK FMX Demo 1
  功能：初始化SDK、登录设备、实时预览、抓图
  核心技术要点：
    FMX 中只有 TForm (TCommonCustomForm) 有 WindowHandle，其它控件均无原生 HWND。
    解决方案：在 TLayout 所在的区域内，通过 Win32 API 动态创建一个真正的子窗口
    (CreateWindowEx)，将该子窗口的 HWND 作为 hPlayWnd 传给 HCNetSDK，
    并在 TLayout 的 OnResize/OnPainting 中同步更新子窗口的位置和尺寸。
}

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.StdCtrls, FMX.Edit, FMX.Layouts, FMX.Objects,
  FMX.Controls.Presentation,
  Winapi.Windows, Winapi.Messages,
  HCNetSDK;

type
  TfrmMain = class(TForm)
    // --- 左侧：视频容器 ---
    layVideo: TLayout;          // 视频渲染容器（代替 VCL 的 TDBImage）

    // --- 右侧：操作面板 ---
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

    btnInit:    TButton;        // 初始化SDK并登录
    btnPreview: TButton;        // 实时预览
    btnCapture: TButton;        // 抓图
    btnStop:    TButton;        // 停止预览

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure layVideoResize(Sender: TObject);

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

    // 创建/销毁/同步 Win32 子窗口
    procedure CreateVideoWindow;
    procedure DestroyVideoWindow;
    procedure SyncVideoWindow;

    // 工具函数
    function FormHWnd: HWND;
    function GbkToStr(const AAnsi: AnsiString): string;
    procedure ShowSDKError(const APrefix: string);
  public
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses
  FMX.Platform.Win;  // WindowHandleToPlatform, needed for Form HWND

{ ============================================================
  Win32 子窗口相关
  ============================================================ }

// 注册一个最简单的窗口类（DefWindowProc，不处理任何消息）
// 只需注册一次。
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

  // 初始状态按钮可用性
  btnPreview.Enabled := False;
  btnCapture.Enabled := False;
  btnStop.Enabled    := False;
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
end;

// 获取 FMX Form 的真实 Win32 HWND
function TfrmMain.FormHWnd: HWND;
begin
  Result := FmxHandleToHWND(Self.Handle);
end;

// GBK (CP936) AnsiString → Delphi Unicode String
// 用 Win32 MultiByteToWideChar 直接转换，最可靠
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
  // NET_DVR_GetErrorMsg 参数是 PLONG（可选，传 nil 表示用内部最后一个错误码）
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
begin
  if FVideoHWnd <> 0 then Exit;   // 已创建

  EnsureVideoWndClassRegistered;

  // 计算 layVideo 在屏幕上的绝对位置
  r  := layVideo.AbsoluteRect;
  rc := Rect(Round(r.Left), Round(r.Top), Round(r.Right), Round(r.Bottom));

  // 转换为 Form 客户区坐标（FMX 的 AbsoluteRect 已经是客户区坐标）
  FVideoHWnd := CreateWindowEx(
    0,
    VIDEO_WND_CLASS,
    '',
    WS_CHILD or WS_VISIBLE or WS_CLIPSIBLINGS or WS_CLIPCHILDREN,
    rc.Left, rc.Top,
    rc.Width, rc.Height,
    FormHWnd,    // 父窗口 = FMX Form
    0,
    HInstance,
    nil
  );

  if FVideoHWnd = 0 then
    ShowMessage('创建视频子窗口失败，GetLastError=' + IntToStr(GetLastError));
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
  r:  TRectF;
  rc: TRect;
begin
  if FVideoHWnd = 0 then Exit;

  r  := layVideo.AbsoluteRect;
  rc := Rect(Round(r.Left), Round(r.Top), Round(r.Right), Round(r.Bottom));

  SetWindowPos(
    FVideoHWnd, HWND_TOP,
    rc.Left, rc.Top, rc.Width, rc.Height,
    SWP_NOACTIVATE or SWP_SHOWWINDOW
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

{ --- SDK 操作 --- }

procedure TfrmMain.btnInitClick(Sender: TObject);
var
  struDevInfo: NET_DVR_DEVICEINFO_V30;
  sIP:   AnsiString;
  sUser: AnsiString;
  sPass: AnsiString;
  nPort: Word;
begin
  // 1. 初始化 SDK
  if not NET_DVR_Init() then
  begin
    ShowMessage('SDK初始化失败');
    Exit;
  end else
    ShowMessage('SDK初始化成功');


  // 2. 设置日志（可选，便于调试）
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

  ShowMessage('SDK初始化并登录成功！' + #13#10 +
    '设备序列号: ' + GbkToStr(AnsiString(PAnsiChar(@struDevInfo.sSerialNumber[0]))));

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

    // 清空视频区域（发送 WM_PAINT 让子窗口重绘为黑色背景）
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
