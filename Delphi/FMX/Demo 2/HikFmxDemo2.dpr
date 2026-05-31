program HikFmxDemo2;

{
  海康威视 FMX Demo 2 — 回调软渲染版
  不依赖 HWND，视频通过 PlayCtrl 解码回调 + TBitmap 渲染到 TImage
}

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
