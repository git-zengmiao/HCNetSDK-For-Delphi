{ PasLibVlc FMX RTSP Demo — 海康威视 RTSP 连接演示 }
{$I ..\..\PasLibVlc_3.0.8\source\compiler.inc}
program HikFmxDemo5;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'HikFMX Demo 5 - RTSP via PasLibVlc';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
