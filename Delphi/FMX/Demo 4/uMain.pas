unit uMain;

{
  海康威视 RTSP 测试工具 —— FMX Demo 4
  用途：测试海康设备是否支持 RTSP 协议取流
  使用 TMediaPlayer + TMediaPlayerControl（FMX 原生组件）

  海康 RTSP URL 格式：
    主码流：rtsp://admin:密码@IP:554/Streaming/Channels/101
    子码流：rtsp://admin:密码@IP:554/Streaming/Channels/102

  注意：
    - RTSP 默认端口是 554（不是 SDK 的 8000）
    - 部分设备需在 Web 管理界面手动开启 RTSP 功能
    - 通道号 N 对应 URL 中的 N01（主码流）/ N02（子码流）
}

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.StdCtrls, FMX.Edit, FMX.Layouts, FMX.Objects,
  FMX.Media,                 // TMediaPlayer
  FMX.Controls.Presentation, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo,
  FMX.ListBox;

type
  TfrmMain = class(TForm)
    layTop: TLayout;
      lblTitle: TLabel;
      layConfig: TLayout;
        lblIP: TLabel;
        edtIP: TEdit;
        lblPort: TLabel;
        edtPort: TEdit;
        lblUser: TLabel;
        edtUser: TEdit;
      lblPwd: TLabel;
        edtPwd: TEdit;
        lblChannel: TLabel;
        edtChannel: TEdit;
        cmbStream: TComboBox;
        btnTest: TButton;
        btnStop: TButton;
    layVideo: TLayout;
      MediaPlayerControl1: TMediaPlayerControl;
    layStatus: TLayout;
      lblStatus: TLabel;
      lblResolution: TLabel;
      lblFPS: TLabel;
    layLog: TLayout;
      memLog: TMemo;
    MediaPlayer1: TMediaPlayer;
    procedure btnStopClick(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
  private
    FMediaPlayer: TMediaPlayer;
    FURL: string;
    procedure BuildURL;
    procedure Log(const AMsg: string);
    procedure MediaPlayerPlay(Sender: TObject);
    procedure MediaPlayerStop(Sender: TObject);
    procedure MediaPlayerError(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

constructor TfrmMain.Create(AOwner: TComponent);
begin
  inherited;
  Caption := '海康 RTSP 测试工具 —— Demo 4';

  // 初始化默认值（用户提供的参数）
  edtIP.Text       := '192.168.6.120';
  edtPort.Text     := '554';           // RTSP 默认端口（注意：SDK 用 8000）
  edtUser.Text     := 'admin';
  edtPwd.Text      := 'admin12345';
  edtChannel.Text  := '1';

  // 主/子码流选择
  cmbStream.Items.Clear;
  cmbStream.Items.Add('主码流（高清）');
  cmbStream.Items.Add('子码流（流畅）');
  cmbStream.ItemIndex := 0;

  // 创建 TMediaPlayer
  FMediaPlayer := TMediaPlayer.Create(Self);
  FMediaPlayer.Parent := Self;
//  FMediaPlayer.Visible := False;            // 不需要显示，由 MediaPlayerControl 渲染
//  FMediaPlayer.OnPlay  := MediaPlayerPlay;
//  FMediaPlayer.OnStop  := MediaPlayerStop;
//  FMediaPlayer.OnError := MediaPlayerError;

  // 关联 MediaPlayerControl
  MediaPlayerControl1.MediaPlayer := FMediaPlayer;
  MediaPlayerControl1.Align := TAlignLayout.Client;

  lblStatus.Text    := '就绪 —— 点击「测试 RTSP」开始';
  lblResolution.Text := '';
  lblFPS.Text       := '';
end;

destructor TfrmMain.Destroy;
begin
  if Assigned(FMediaPlayer) then
  begin
    FMediaPlayer.Stop;
    FMediaPlayer.Free;
  end;
  inherited;
end;

procedure TfrmMain.BuildURL;
var
  LStreamSuffix: string;
begin
  // 主码流：通道号01  → 101；子码流 → 102
  if cmbStream.ItemIndex = 0 then
    LStreamSuffix := edtChannel.Text + '01'   // 主码流
  else
    LStreamSuffix := edtChannel.Text + '02';  // 子码流

  // 构造 RTSP URL
  // 格式：rtsp://user:password@ip:port/Streaming/Channels/XXX
  FURL := 'rtsp://' +
          edtUser.Text + ':' + edtPwd.Text + '@' +
          edtIP.Text + ':' + edtPort.Text + '/' +
          'Streaming/Channels/' + LStreamSuffix;

  Log('RTSP URL: ' + FURL);
end;

procedure TfrmMain.btnTestClick(Sender: TObject);
begin
  // 停止当前播放
  if Assigned(FMediaPlayer) and (FMediaPlayer.State = TMediaState.Playing) then
    FMediaPlayer.Stop;

  BuildURL;
  lblStatus.Text := '正在连接 RTSP 流...';

  try
   // FMediaPlayer.URL := FURL;
    FMediaPlayer.Play;
    btnTest.Enabled  := False;
    btnStop.Enabled  := True;
    Log('已开始播放，等待回调...');
  except
    on E: Exception do
    begin
      lblStatus.Text := '播放失败：' + E.Message;
      Log('错误：' + E.Message);
      btnTest.Enabled := True;
      btnStop.Enabled := False;
    end;
  end;
end;

procedure TfrmMain.btnStopClick(Sender: TObject);
begin
  if Assigned(FMediaPlayer) then
    FMediaPlayer.Stop;
  lblStatus.Text := '已停止';
  btnTest.Enabled := True;
  btnStop.Enabled := False;
  Log('播放已停止');
end;

procedure TfrmMain.MediaPlayerPlay(Sender: TObject);
begin
  // 播放成功回调（主线程）
  lblStatus.Text := '✅ RTSP 播放成功！设备支持 RTSP 协议';
  Log('✅ 播放成功！');
  btnTest.Enabled := False;
  btnStop.Enabled := True;

  // 尝试获取视频信息
  try
    if FMediaPlayer.Media <> nil then
    begin
//      lblResolution.Text := Format('分辨率：%d × %d',
//        [FMediaPlayer.Media.VideoSize.Width,
//         FMediaPlayer.Media.VideoSize.Height]);
      lblFPS.Text := Format('时长：%.1f 秒', [FMediaPlayer.Media.Duration]);
//      Log(Format('视频信息：%d×%d，时长 %.1f 秒',
//        [FMediaPlayer.Media.VideoSize.Width,
//         FMediaPlayer.Media.VideoSize.Height,
//         FMediaPlayer.Media.Duration]));
    end;
  except
    on E: Exception do
      Log('获取视频信息失败：' + E.Message);
  end;
end;

procedure TfrmMain.MediaPlayerStop(Sender: TObject);
begin
  lblStatus.Text := '播放已停止';
  Log('播放停止回调触发');
end;

procedure TfrmMain.MediaPlayerError(Sender: TObject);
begin
  lblStatus.Text := '❌ RTSP 播放失败（OnError 回调）';
  Log('❌ 播放错误回调触发（设备可能不支持 RTSP 或参数错误）');
  btnTest.Enabled := True;
  btnStop.Enabled := False;
end;

procedure TfrmMain.Log(const AMsg: string);
begin
  memLog.Lines.Add(FormatDateTime('hh:nn:ss', Now) + '  ' + AMsg);
  memLog.SelStart := Length(memLog.Text);
end;

end.
