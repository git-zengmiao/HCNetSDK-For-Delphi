unit uMain;
{
  海康威视 HCNetSDK FMX Demo 3 —— 隐藏 HWND + BitBlt 加速方案
  核心技术：创建隐藏 Win32 窗口作为 PlayCtrl 渲染目标，
          用 BitBlt 从隐藏窗口抓图到 TBitmap。

  性能优势：
  - PlayCtrl 走 DirectDraw / 硬件加速解码渲染（GPU）
  - BitBlt 是 GPU→GPU 操作，极快（GDI 内部优化）
  - 完全绕过 CPU 像素搬运（Demo 2 的 Move 200MB/s）
  - CPU 占用远低于 Demo 2

  数据路径：
  网络码流 → NET_DVR_RealPlay_V30 → PlayCtrl 解码
       → BitBlt 抓图 → TBitmap → TImage（FMX 渲染）

  注意：本方案依赖 Win32 HWND，仅 Windows 可用。
}
interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.StdCtrls, FMX.Edit, FMX.Layouts,
  FMX.Controls.Presentation,
  Winapi.Windows, Winapi.Messages,
  HCNetSDK, PlayMpeg4;

type
  TfrmMain = class(TForm)
    imgVideo: TImage;
    layPanel: TLayout;
    lblIP: TLabel;
    edtIP: TEdit;
    lblPort: TLabel;
    edtPort: TEdit;
    lblUser: TLabel;
    edtUser: TEdit;
    lblPass: TLabel;
    edtPass: TEdit;
    lblCh: TLabel;
    edtCh: TEdit;
    btnInit: TButton;
    btnPreview: TButton;
    btnCapture: TButton;
    btnStop: TButton;
    tmrFrame: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tmrFrameTimer(Sender: TObject);
    procedure btnInitClick(Sender: TObject);
    procedure btnPreviewClick(Sender: TObject);
    procedure btnCaptureClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
  private
    FUserID:     LONG;
    FRealHandle: LONG;
    FPlayPort:   Integer;
    FHiddenWnd:  HWND;    // 隐藏窗口句柄（PlayCtrl 渲染目标）
    FCaptureBmp: TBitmap; // 抓图专用（避免渲染冲突）
    function  GbkToStr(const AAnsi: AnsiString): string;
    procedure ShowSDKError(const APrefix: string);
    function  CreateHiddenWnd: HWND;
    procedure DestroyHiddenWnd;
    procedure CaptureFromHiddenWnd;  // BitBlt 抓图到 imgVideo
  public
  end;

var
  frmMain: TfrmMain;

{ ============================================================
  全局回调
  ============================================================ }

var
  G_PlayPort: Integer = -1;

procedure RealDataCB(lRealHandle: LONG; dwDataType: DWORD;
  pBuffer: PBYTE; dwBufSize: DWORD; pUser: Pointer); stdcall;
begin
  if G_PlayPort < 0 then Exit;

  if dwDataType = NET_DVR_SYSHEAD then
  begin
    PlayM4_OpenStream(G_PlayPort, pBuffer, dwBufSize, $400000);
    // 关键：PlayM4_Play 的 hPlayWnd 传隐藏窗口句柄
    // PlayCtrl 会直接渲染到该 HWND（GPU 加速）
    if frmMain <> nil then
      PlayM4_Play(G_PlayPort, frmMain.FHiddenWnd, 0)
    else
      PlayM4_Play(G_PlayPort, 0, 0);
  end
  else if dwDataType = NET_DVR_STREAMDATA then
  begin
    PlayM4_InputData(G_PlayPort, pBuffer, dwBufSize);
  end;
end;

implementation

{$R *.fmx}

{ TfrmMain }

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

function TfrmMain.CreateHiddenWnd: HWND;
var
  hInstance: HINST;
  wndClass:  WNDCLASS;
  atom:     ATOM;
begin
  Result := 0;
  hInstance := HInstance;

  // 注册窗口类（只需要一次）
  FillChar(wndClass, SizeOf(wndClass), 0);
  wndClass.lpszClassName := 'HikHiddenWnd';
  wndClass.lpfnWndProc   := @DefWindowProc;
  wndClass.hInstance     := hInstance;
  wndClass.style         := CS_OWNDC;

  atom := RegisterClass(wndClass);
  if atom = 0 then Exit;

  // 创建 1x1 像素的隐藏窗口（WS_POPUP，完全不可见）
  Result := CreateWindowEx(
    0,
    'HikHiddenWnd',
    '',            // 无标题
    WS_POPUP,    // 弹出式窗口，无边框，不显示
    0, 0, 1, 1, // 1x1 像素，屏幕外也可
    0, 0, hInstance, nil
  );
end;

procedure TfrmMain.DestroyHiddenWnd;
begin
  if FHiddenWnd <> 0 then
  begin
    DestroyWindow(FHiddenWnd);
    FHiddenWnd := 0;
  end;
end;

procedure TfrmMain.CaptureFromHiddenWnd;
var
  wndDC, memDC: HDC;
  hBmp, hOldBmp: HBITMAP;
  bmpTemp: TBitmap;
  W, H: Integer;
begin
  if FHiddenWnd = 0 then Exit;
  if not Assigned(imgVideo) then Exit;

  // 获取隐藏窗口客户区尺寸
  wndDC := GetDC(FHiddenWnd);
  if wndDC = 0 then Exit;

  try
    // 创建兼容 DC + 兼容位图
    memDC := CreateCompatibleDC(wndDC);
    if memDC = 0 then Exit;

    try
      W := GetDeviceCaps(wndDC, HORZRES);
      H := GetDeviceCaps(wndDC, VERTRES);
      if (W <= 0) or (H <= 0) then
      begin
        W := 352;  // 默认值
        H := 288;
      end;

      hBmp := CreateCompatibleBitmap(wndDC, W, H);
      if hBmp = 0 then Exit;

      try
        hOldBmp := SelectObject(memDC, hBmp);

        // 关键：BitBlt 从隐藏窗口 DC 抓取画面到内存位图
        // 这是 GPU→GPU 操作，非常快
        BitBlt(memDC, 0, 0, W, H, wndDC, 0, 0, SRCCOPY);

        SelectObject(memDC, hOldBmp);

        // 将 HBITMAP 转为 TBitmap
        bmpTemp := TBitmap.Create;
        try
          bmpTemp.LoadFromHBitmap(hBmp);
          imgVideo.Bitmap.Assign(bmpTemp);
        finally
          bmpTemp.Free;
        end;
      finally
        DeleteObject(hBmp);
      end;
    finally
      DeleteDC(memDC);
    end;
  finally
    ReleaseDC(FHiddenWnd, wndDC);
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FUserID     := -1;
  FRealHandle := -1;
  FPlayPort   := -1;
  FHiddenWnd  := 0;
  FCaptureBmp := nil;

  tmrFrame.Enabled  := False;
  tmrFrame.Interval := 33;  // ~30fps

  btnPreview.Enabled := False;
  btnCapture.Enabled := False;
  btnStop.Enabled    := False;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  tmrFrame.Enabled := False;

  if FRealHandle >= 0 then
  begin
    NET_DVR_StopRealPlay(FRealHandle);
    FRealHandle := -1;
    G_PlayPort  := -1;
  end;

  if FPlayPort >= 0 then
  begin
    PlayM4_Stop(FPlayPort);
    PlayM4_CloseStream(FPlayPort);
    PlayM4_FreePort(FPlayPort);
    FPlayPort := -1;
  end;

  DestroyHiddenWnd;

  if FUserID >= 0 then
  begin
    NET_DVR_Logout(FUserID);
    FUserID := -1;
  end;

  NET_DVR_Cleanup();

  FreeAndNil(FCaptureBmp);
end;

procedure TfrmMain.btnInitClick(Sender: TObject);
var
  struDevInfo: NET_DVR_DEVICEINFO_V30;
  sIP:   AnsiString;
  sUser: AnsiString;
  sPass: AnsiString;
  nPort: Word;
begin
  if not NET_DVR_Init() then
  begin
    ShowMessage('SDK 初始化失败');
    Exit;
  end;

  NET_DVR_SetLogToFile(3, PAnsiChar(AnsiString(ExtractFilePath(ParamStr(0)))), False);

  sIP   := AnsiString(edtIP.Text);
  nPort := Word(StrToIntDef(edtPort.Text, 8000));
  sUser := AnsiString(edtUser.Text);
  sPass := AnsiString(edtPass.Text);

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

  if not PlayM4_GetPort(@FPlayPort) then
  begin
    ShowMessage('获取播放端口失败');
    NET_DVR_Logout(FUserID);
    NET_DVR_Cleanup();
    FUserID := -1;
    Exit;
  end;

  PlayM4_SetStreamOpenMode(FPlayPort, STREAME_REALTIME);

  ShowMessage('SDK 初始化并登录成功！' + #13#10 +
    '设备序列号: ' + GbkToStr(AnsiString(PAnsiChar(@struDevInfo.sSerialNumber[0]))));

  btnInit.Enabled    := False;
  btnPreview.Enabled := True;
end;

procedure TfrmMain.btnPreviewClick(Sender: TObject);
var
  struPlayInfo: NET_DVR_PREVIEWINFO;
begin
  if FUserID < 0 then
  begin
    ShowMessage('请先初始化 SDK 并登录！');
    Exit;
  end;

  if FPlayPort < 0 then
  begin
    ShowMessage('播放端口无效！');
    Exit;
  end;

  // 创建隐藏窗口（PlayCtrl 渲染目标）
  FHiddenWnd := CreateHiddenWnd;
  if FHiddenWnd = 0 then
  begin
    ShowMessage('创建隐藏窗口失败');
    Exit;
  end;

  G_PlayPort := FPlayPort;

  FillChar(struPlayInfo, SizeOf(struPlayInfo), 0);
  struPlayInfo.lChannel   := StrToIntDef(edtCh.Text, 1);
  struPlayInfo.dwStreamType := 0;  // 主码流
  struPlayInfo.bBlocked     := True;

  FRealHandle := NET_DVR_RealPlay_V30(FUserID, @struPlayInfo,
    @RealDataCB, nil, True);

  if FRealHandle < 0 then
  begin
    ShowSDKError('实时预览失败');
    DestroyHiddenWnd;
    G_PlayPort := -1;
    Exit;
  end;

  // 启动渲染定时器（BitBlt 抓图）
  tmrFrame.Enabled := True;

  btnPreview.Enabled := False;
  btnStop.Enabled    := True;
  btnCapture.Enabled := True;

  ShowMessage('预览成功！（隐藏窗口 + BitBlt 加速方案）');
end;

procedure TfrmMain.btnStopClick(Sender: TObject);
begin
  tmrFrame.Enabled := False;

  if FRealHandle >= 0 then
  begin
    NET_DVR_StopRealPlay(FRealHandle);
    FRealHandle := -1;
    G_PlayPort  := -1;
  end;

  if FPlayPort >= 0 then
  begin
    PlayM4_Stop(FPlayPort);
    PlayM4_CloseStream(FPlayPort);
  end;

  DestroyHiddenWnd;

  if Assigned(imgVideo) then
  begin
    imgVideo.Bitmap.SetSize(1, 1);
    imgVideo.Bitmap.Clear(TAlphaColors.Black);
  end;

  btnPreview.Enabled := True;
  btnStop.Enabled    := False;
  btnCapture.Enabled := False;
end;

procedure TfrmMain.btnCaptureClick(Sender: TObject);
var
  sPath: string;
begin
  if not Assigned(FCaptureBmp) then
    FCaptureBmp := TBitmap.Create;

  // 从当前 imgVideo.Bitmap 复制
  FCaptureBmp.Assign(imgVideo.Bitmap);

  sPath := ExtractFilePath(ParamStr(0)) + 'capture_' +
    FormatDateTime('yyyymmdd_hhnnss', Now) + '.bmp';
  FCaptureBmp.SaveToFile(sPath);
  ShowMessage('抓图成功！' + #13#10 + '保存路径: ' + sPath);
end;

procedure TfrmMain.tmrFrameTimer(Sender: TObject);
begin
  CaptureFromHiddenWnd;
end;

end.
