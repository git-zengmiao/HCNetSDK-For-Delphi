program RealTimePlayer;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {MainForm},
  uNVR in 'uNVR.pas',
  HCNetSDK in '..\..\API\HCNetSDK.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
