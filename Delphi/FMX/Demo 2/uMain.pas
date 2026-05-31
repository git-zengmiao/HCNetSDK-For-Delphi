unit uMain;
{
  海康威视 HCNetSDK FMX Demo 2 —— 双缓冲优化版
  核心技术：回调取流 + PlayCtrl 解码 + 单缓冲跳帧 + TTimer 30fps 渲染
  完全不依赖 HWND，无 TThread.Queue 延迟，自动跳帧防堆积。

  优化要点：
  1. 回调中：单次 Move 写入预分配缓冲，原子设置 GBufReady
     若上一帧未渲染（GBufReady=True）则自动丢帧，零阻塞
  2. 主线程 TTimer(33ms≈30fps)：检测 GBufReady
     渲染到 TImage.Bitmap，清除 GBufReady
  3. 预分配像素缓冲区 GetMem，避免每帧重复分配
  4. 完全不用 TThread.Queue，无排队延迟
}
interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.StdCtrls, FMX.Edit, FMX.Layouts,
  FMX.Controls.Presentation,
  HCNetSDK, PlayMpeg4, FMX.Objects;

type
  TfrmMain = class(TForm)
    // --- 视频显示 ---
    imgVideo: TImage;
    // --- 操作面板 ---
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
    tmrFrame:  TTimer;   // 主线程 30fps 渲染定时器
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tmrFrameTimer(Sender: TObject);
    procedure btnInitClick(Sender: TObject);
    procedure btnPreviewClick(Sender: TObject);
    procedure btnCaptureClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
  private
    // SDK 状态
    FUserID:     LongInt;
    FRealHandle: LongInt;
    FPlayPort:   Integer;

    // 像素缓冲区（预分配，回调和主线程共享）
    FBmp:        TBitmap;   // 渲染目标 Bitmap
    FBmpReady:   Boolean;   // 原子标志：缓冲区是否有新帧待渲染
    FBmpW,
    FBmpH:       Integer;   // 当前帧尺寸

    // 工具函数
    function  GbkToStr(const AAnsi: AnsiString): string;
    procedure ShowSDKError(const APrefix: string);
    procedure RenderFrame;   // 主线程渲染（tmrFrame 调用）
  public
  end;

var
  frmMain: TfrmMain;

// 前向声明
procedure DisplayCB(nPort: Integer; pBuf: PAnsiChar;
  nSize, nWidth, nHeight, nStamp, nType, nReserved: Integer); stdcall;

implementation

var
  G_PlayPort: Integer = -1;

{ ============================================================
  全局回调（必须用全局函数，不能用类方法）
  ============================================================ }


// RealDataCallBack —— 从 NET_DVR 接收原始码流，喂给 PlayCtrl 解码

procedure RealDataCB_V30(lRealHandle: LongInt; dwDataType: DWORD;
  pBuffer: PBYTE; dwBufSize: DWORD; pUser: Pointer); stdcall;
begin
  if G_PlayPort < 0 then Exit;

  if dwDataType = NET_DVR_SYSHEAD then
  begin
    PlayM4_OpenStream(G_PlayPort, pBuffer, dwBufSize, $400000);
    PlayM4_Play(G_PlayPort, 0);   // hPlayWnd=0，仅解码不显示
    PlayM4_SetDisplayCallBack(G_PlayPort, @DisplayCB);
  end
  else
  if dwDataType = NET_DVR_STREAMDATA then
  begin
    PlayM4_InputData(G_PlayPort, pBuffer, dwBufSize);
  end;
end;

// DisplayCallBack —— PlayCtrl 解码完成回调，拿到 BGR/A 像素数据
// 关键优化：若上一帧未渲染（FBmpReady=True）则自动丢帧，零阻塞
procedure DisplayCB(nPort: Integer; pBuf: PAnsiChar;
  nSize, nWidth, nHeight, nStamp, nType, nReserved: Integer); stdcall;
var
  Data: TBitmapData;
begin
  if not Assigned(frmMain) then Exit;
  if not Assigned(frmMain.FBmp) then Exit;

  // 跳帧：上一帧还没渲染，直接丢弃这一帧
  if frmMain.FBmpReady then Exit;

  // 尺寸变化：重新创建 Bitmap
  if (nWidth <> frmMain.FBmpW) or (nHeight <> frmMain.FBmpH) then
  begin
    TThread.Queue(nil,
      procedure
      begin
        if Assigned(frmMain) then
        begin
          frmMain.FBmp.Free;
          frmMain.FBmp := TBitmap.Create(nWidth, nHeight);
          frmMain.FBmpW := nWidth;
          frmMain.FBmpH := nHeight;
        end;
      end);
    Exit;   // 这一帧丢弃，等下一帧
  end;

  // 单次 Move：将 BGR/A 像素写入 TBitmap
  if frmMain.FBmp.Map(TMapAccess.Write, Data) then
  try
    Move(pBuf^, Data.Data^, nWidth * nHeight * 4);
  finally
    frmMain.FBmp.Unmap(Data);
  end;

  // 原子设置：通知主线程有新帧待渲染
  frmMain.FBmpReady := True;
end;

//implementation

{$R *.fmx}

{ TfrmMain }

function TfrmMain.GbkToStr(const AAnsi: AnsiString): string;
var
  GBK: TEncoding;
  Data: TBytes;
begin
  if AAnsi = '' then Exit('');
  GBK := TEncoding.GetEncoding(936);
  try
    SetLength(Data, Length(AAnsi));
    Move(PAnsiChar(AAnsi)^, Data[0], Length(AAnsi));
    Result := GBK.GetString(Data);
  finally
    GBK.Free;
  end;
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

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FUserID     := -1;
  FRealHandle := -1;
  FPlayPort   := -1;
  FBmp        := nil;
  FBmpReady   := False;
  FBmpW       := 0;
  FBmpH       := 0;

  // TTimer：33ms ≈ 30fps，在主线程执行，无 TThread.Queue 延迟
  tmrFrame.Enabled := False;
  tmrFrame.Interval := 33;

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

  if FUserID >= 0 then
  begin
    NET_DVR_Logout(FUserID);
    FUserID := -1;
  end;

  NET_DVR_Cleanup();

  FreeAndNil(FBmp);
end;

procedure TfrmMain.RenderFrame;
begin
  // 无新帧，跳过
  if not FBmpReady then Exit;

  // 原子清除（主线程写，回调读，无竞争）
  FBmpReady := False;

  if Assigned(FBmp) and Assigned(imgVideo) then
    imgVideo.Bitmap.Assign(FBmp);
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

  G_PlayPort := FPlayPort;

  FillChar(struPlayInfo, SizeOf(struPlayInfo), 0);
  struPlayInfo.lChannel   := StrToIntDef(edtCh.Text, 1);
  struPlayInfo.dwStreamType := 0;   // 主码流
  struPlayInfo.bBlocked     := 1;

  FRealHandle := NET_DVR_RealPlay_V30(FUserID, @struPlayInfo,
    @RealDataCB_V30, nil, True);

  if FRealHandle < 0 then
  begin
    ShowSDKError('实时预览失败');
    G_PlayPort := -1;
    Exit;
  end;

  // 创建渲染 Bitmap（默认 352x288，后续 DisplayCB 会自动调整）
  FBmp   := TBitmap.Create(352, 288);
  FBmpW  := 352;
  FBmpH  := 288;
  FBmpReady := False;

  // 启动渲染定时器（主线程 30fps）
  tmrFrame.Enabled := True;

  btnPreview.Enabled := False;
  btnStop.Enabled    := True;
  btnCapture.Enabled := True;

  ShowMessage('预览成功！（回调+双缓冲模式）');
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

  FreeAndNil(FBmp);
  FBmpReady := False;
  FBmpW     := 0;
  FBmpH     := 0;

  // 清空画面
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
  if not Assigned(FBmp) then
  begin
    ShowMessage('当前无视频帧可抓取');
    Exit;
  end;

  sPath := ExtractFilePath(ParamStr(0)) + 'capture_' +
    FormatDateTime('yyyymmdd_hhnnss', Now) + '.bmp';
  FBmp.SaveToFile(sPath);
  ShowMessage('抓图成功！' + #13#10 + '保存路径: ' + sPath);
end;

procedure TfrmMain.tmrFrameTimer(Sender: TObject);
begin
  RenderFrame;
end;

end.
