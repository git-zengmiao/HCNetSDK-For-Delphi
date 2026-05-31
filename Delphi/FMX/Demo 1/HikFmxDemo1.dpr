program HikFmxDemo1;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {frmMain: TForm},
  HCNetSDK in '..\..\API\HCNetSDK.pas',
  plaympeg4 in '..\..\API\plaympeg4.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
