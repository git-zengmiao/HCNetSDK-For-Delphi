program HikFmxDemo3;

uses
  FMX.Forms,
  uMain in 'uMain.pas' {frmMain},
  HCNetSDK in '..\..\API\HCNetSDK.pas',
  plaympeg4 in '..\..\API\plaympeg4.pas';

{$R *.res}

begin
  Application.Initialize;
  AApplication.CreateForm(TfrmMain, frmMain);
  pplication.Run;
end.
