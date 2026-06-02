unit uMain;

{
  海康威视 RTSP FMX Demo 5 — 基于 PasLibVlc
  功能：通过 RTSP 协议连接海康摄像头并实时预览
  核心技术：TFmxPasLibVlcPlayer（继承自 TImage，视频回调渲染到 Bitmap）

  海康 RTSP 地址格式：
    主码流：rtsp://admin:password@IP:554/Streaming/Channels/101
    子码流：rtsp://admin:password@IP:554/Streaming/Channels/102
    第三码流：rtsp://admin:password@IP:554/Streaming/Channels/103

  注意：需要安装 VLC（32位或64位需与Delphi编译目标匹配）
  VLC下载：https://www.videolan.org/vlc/
}

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.StdCtrls, FMX.Edit, FMX.Layouts, FMX.Objects,
  FMX.Controls.Presentation,
  FmxPasLibVlcPlayerUnit, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.ListBox;

type
  TfrmMain = class(TForm)
    // --- 左侧：视频区域 ---
    layVideo: TLayout;

    // --- PasLibVlc 播放器组件 ---
    vlcPlayer: TFmxPasLibVlcPlayer;

    // --- 右侧：操作面板 ---
    layPanel: TLayout;
    lblIP: TLabel;
    edtIP: TEdit;
    lblPort: TLabel;
    edtPort: TEdit;
    lblUser: TLabel;
    edtUser: TEdit;
    lblPass: TLabel;
    edtPass: TEdit;
    lblStream: TLabel;
    cmbStream: TComboBox;
    chkLowLatency: TCheckBox;
    lblVlcPath: TLabel;
    edtVlcPath: TEdit;
    btnBrowseVlc: TButton;
    memStatus: TMemo;

    btnPlay: TButton;
    btnStop: TButton;
    btnSnapshot: TButton;

    // --- 底部：快捷信息 ---
    lblHint: TLabel;

    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnPlayClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnSnapshotClick(Sender: TObject);
    procedure btnBrowseVlcClick(Sender: TObject);
    procedure cmbStreamChange(Sender: TObject);
    procedure chkLowLatencyChange(Sender: TObject);
    procedure vlcPlayerMediaPlayerPlaying(Sender: TObject);
    procedure vlcPlayerMediaPlayerStopped(Sender: TObject);
    procedure vlcPlayerMediaPlayerEncounteredError(Sender: TObject);
    procedure vlcPlayerMediaPlayerBuffering(Sender: TObject; percent: Integer);
    procedure vlcPlayerMediaPlayerVideoSizeChanged(Sender: TObject; width, height, video_w_a32, video_h_a32: Cardinal);
    procedure vlcPlayerMediaPlayerTimeChanged(Sender: TObject; time_ms: Int64);
  private
    FPlaying: Boolean;
    FSnapshotDir: string;

    // 生成海康 RTSP URL
    function BuildRTSPUrl: string;

    // 日志输出
    procedure Log(const AMsg: string);
  public
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses
  {$IFDEF MSWINDOWS}
  Winapi.Windows, Winapi.ShellAPI,
  {$ENDIF}
  System.IOUtils;

{ ============================================================
  RTSP URL 构建
  ============================================================ }

function TfrmMain.BuildRTSPUrl: string;
var
  sIP, sUser, sPass: string;
  nPort: Integer;
  sChannel: string;
begin
  sIP   := Trim(edtIP.Text);
  sUser := Trim(edtUser.Text);
  sPass := Trim(edtPass.Text);
  nPort := StrToIntDef(Trim(edtPort.Text), 554);

  if sIP = '' then Exit('');

  // 海康通道号：101=主码流, 102=子码流, 103=第三码流
  case cmbStream.ItemIndex of
    0: sChannel := '101';
    1: sChannel := '102';
    2: sChannel := '103';
  else
    sChannel := '101';
  end;

  // rtsp://user:pass@ip:port/Streaming/Channels/channel
  if sUser <> '' then
    Result := Format('rtsp://%s:%s@%s:%d/Streaming/Channels/%s',
      [sUser, sPass, sIP, nPort, sChannel])
  else
    Result := Format('rtsp://%s:%d/Streaming/Channels/%s',
      [sIP, nPort, sChannel]);
end;

{ ============================================================
  日志
  ============================================================ }

procedure TfrmMain.Log(const AMsg: string);
begin
  memStatus.Lines.Add(FormatDateTime('hh:nn:ss', Now) + ' ' + AMsg);
  // 自动滚动到底部
  memStatus.GoToTextEnd;
end;

{ ============================================================
  窗体事件
  ============================================================ }

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FPlaying := False;

  // 默认参数
  edtIP.Text    := '192.168.6.120';
  edtPort.Text  := '554';
  edtUser.Text := 'admin';
  edtPass.Text := 'admin12345';
  edtVlcPath.Text := '';

  // 码流下拉
  cmbStream.Items.Add('主码流 (101)');
  cmbStream.Items.Add('子码流 (102)');
  cmbStream.Items.Add('第三码流 (103)');
  cmbStream.ItemIndex := 0;
  chkLowLatency.IsChecked := True;
  Log('低延迟模式已默认开启（取消勾选可切换为标准模式）');

  // 截图目录
  FSnapshotDir := TPath.Combine(TPath.GetDocumentsPath, 'HikSnapshots');
  ForceDirectories(FSnapshotDir);

  // 按钮状态
  btnStop.Enabled     := False;
  btnSnapshot.Enabled := False;

  // VLC 播放器设置
  vlcPlayer.WrapMode := TImageWrapMode.Stretch;
  vlcPlayer.Align    := TAlignLayout.Client;
  vlcPlayer.UseEvents := True;

  Log('就绪。请设置摄像头参数后点击播放。');

  // 显示 VLC 路径提示
  {$IFDEF MSWINDOWS}
  Log('提示：默认使用系统已安装的 VLC。如未安装请下载 https://www.videolan.org/vlc/');
  {$ENDIF}
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // 确保停止播放
  if FPlaying then
    vlcPlayer.Stop(3000);
end;

{ ============================================================
  播放/停止/截图
  ============================================================ }

procedure TfrmMain.btnPlayClick(Sender: TObject);
var
  sUrl, sVlcPath: string;
begin
  sUrl := BuildRTSPUrl;
  if sUrl = '' then
  begin
    ShowMessage('请输入摄像头IP地址');
    Exit;
  end;

  // 如果指定了 VLC 路径，在 Play 前设置（Play 内部会据此加载 libvlc.dll）
  sVlcPath := Trim(edtVlcPath.Text);
  if sVlcPath <> '' then
  begin
    vlcPlayer.VLC.Path := sVlcPath;
    Log('VLC 路径: ' + sVlcPath);
  end;

  Log('准备连接: ' + sUrl);

  // Play() 内部流程:
  // 1. GetVlcInstance → 创建 TPasLibVlc 实例
  // 2. TPasLibVlc.Handle → libvlc_dynamic_dll_init → LoadLibrary('libvlc.dll')
  // 3. libvlc_new → 创建 VLC 引擎
  // 4. libvlc_media_new_location → 创建媒体
  // 5. libvlc_media_player_set_media + play → 开始播放
  // 任何环节失败都会抛异常，由 try-except 捕获
  try
    if chkLowLatency.IsChecked then
    begin
      // === 极限低延迟模式 ===
      // 预期延迟: 300-800ms（理论极限，实际取决于网络和编解码器）
      // 代价: 画面可能偶尔花屏/跳帧，网络差时会卡顿
      vlcPlayer.Play(
        sUrl,
        [
          '--rtsp-tcp',              // TCP传输，防丢包
          '--network-caching=0',     // 零网络缓存（默认1000ms）
          '--live-caching=0',        // 零直播缓存
          '--clock-jitter=0',        // 不容忍时钟抖动
          '--clock-synchro=0',       // 关闭时钟同步
          '--drop-late-frames',      // 丢弃延迟帧
          '--skip-frames',           // 允许跳帧追赶
          '--no-video-filter',       // 跳过所有视频滤镜管线
          '--no-audio-filter',       // 跳过音频滤镜
          '--no-deinterlace',        // 不去隔行
          '--avcodec-fast',          // FFmpeg快速解码（牺牲精度）
          '--avcodec-skiploopfilter=all', // 跳过环路滤波
          '--avcodec-skip-frame=nonref',  // 跳过非参考帧解码
          '--avcodec-threads=4'      // 多线程解码
        ]
      );
      Log('模式: 极限低延迟（网络缓存=0ms）');
    end else
    begin
      // === 标准模式 ===
      // 预期延迟: 1-2秒，画面流畅稳定
      vlcPlayer.Play(
        sUrl,
        [
          '--rtsp-tcp',
          '--network-caching=300'
        ]
      );
      Log('模式: 标准（网络缓存=300ms）');
    end;
    Log('Play() 调用成功，VLC 版本: ' + vlcPlayer.VLC.Version);
  except
    on E: ERangeError do
    begin
      Log('✖ Range Error: ' + E.Message);
      Log('  可能原因: VLC 版本与 PasLibVlc 3.0.8 不兼容');
      Log('  建议安装 VLC 3.0.x（如 3.0.20），避免 4.x');
      Exit;
    end;
    on E: Exception do
    begin
      Log('✖ 异常: ' + E.ClassName + ' - ' + E.Message);
      Log('  常见原因: VLC 未安装 / 位数不匹配 / DLL 路径错误');
      Exit;
    end;
  end;

  FPlaying := True;
  btnPlay.Enabled    := False;
  btnStop.Enabled    := True;
  btnSnapshot.Enabled := False;

  Log('正在连接...');
end;

procedure TfrmMain.btnStopClick(Sender: TObject);
begin
  vlcPlayer.Stop(2000);
  FPlaying := False;
  btnPlay.Enabled    := True;
  btnStop.Enabled    := False;
  btnSnapshot.Enabled := False;
  Log('已停止播放');
end;

procedure TfrmMain.btnSnapshotClick(Sender: TObject);
var
  sFile: string;
begin
  sFile := TPath.Combine(FSnapshotDir,
    Format('snap_%s_%s.%s',
       [FormatDateTime('yyyymmdd_hhnnss', Now),
       StringReplace(edtIP.Text, '.', '_', [rfReplaceAll]),
       vlcPlayer.SnapShotFmt]));
  vlcPlayer.SnapShot(sFile);
  Log('截图已保存: ' + sFile);
end;

{ ============================================================
  VLC 播放器事件
  ============================================================ }

procedure TfrmMain.chkLowLatencyChange(Sender: TObject);
begin
  if FPlaying then
  begin
    Log('提示: 延迟模式需重新点击播放才能生效');
  end
  else if chkLowLatency.IsChecked then
    Log('已选择: 极限低延迟模式（网络缓存=0ms）')
  else
    Log('已选择: 标准模式（网络缓存=300ms）');
end;

procedure TfrmMain.vlcPlayerMediaPlayerPlaying(Sender: TObject);
begin
  Log('▶ 正在播放');
  btnSnapshot.Enabled := True;
end;

procedure TfrmMain.vlcPlayerMediaPlayerStopped(Sender: TObject);
begin
  Log('⏹ 已停止');
  FPlaying := False;
  btnPlay.Enabled    := True;
  btnStop.Enabled    := False;
  btnSnapshot.Enabled := False;
end;

procedure TfrmMain.vlcPlayerMediaPlayerEncounteredError(Sender: TObject);
begin
  Log('✖ 播放错误: ' + vlcPlayer.LastError);
  Log('  状态: ' + vlcPlayer.GetStateName);
  FPlaying := False;
  btnPlay.Enabled    := True;
  btnStop.Enabled    := False;
  btnSnapshot.Enabled := False;
end;

procedure TfrmMain.vlcPlayerMediaPlayerBuffering(Sender: TObject; percent: Integer);
begin
  Log(Format('缓冲中... %d%%', [percent]));
end;

procedure TfrmMain.vlcPlayerMediaPlayerVideoSizeChanged(Sender: TObject; width, height, video_w_a32, video_h_a32: Cardinal);
begin
  Log(Format('视频分辨率: %d x %d (A32: %d x %d)', [width, height, video_w_a32, video_h_a32]));
end;

procedure TfrmMain.vlcPlayerMediaPlayerTimeChanged(Sender: TObject; time_ms: Int64);
begin
  // RTSP 直播流的 time 会持续增长，这里仅作为连接状态的隐式指示
  // 不需要每次都 log（太频繁），仅在第一次时输出
end;

{ ============================================================
  VLC 路径浏览
  ============================================================ }

procedure TfrmMain.btnBrowseVlcClick(Sender: TObject);
var
  dlg: TOpenDialog;
begin
  dlg := TOpenDialog.Create(nil);
  try
    // 默认查找 VLC 安装目录
    {$IFDEF MSWINDOWS}
    dlg.InitialDir := 'C:\Program Files\VideoLAN\VLC';
    {$ENDIF}
    dlg.Filter := 'libvlc.dll|libvlc.dll|所有文件|*.*';
    if dlg.Execute then
    begin
      // 取 DLL 所在目录
      edtVlcPath.Text := ExtractFilePath(dlg.FileName);
      Log('已选择 VLC 路径: ' + edtVlcPath.Text);
    end;
  finally
    dlg.Free;
  end;
end;

{ ============================================================
  码流切换
  ============================================================ }

procedure TfrmMain.cmbStreamChange(Sender: TObject);
var
  sName: string;
begin
  case cmbStream.ItemIndex of
    0: sName := '主码流 (高清，码率大)';
    1: sName := '子码流 (标清，码率小)';
    2: sName := '第三码流 (流畅)';
  else
    sName := '';
  end;
  Log('切换码流: ' + sName);
end;

end.
