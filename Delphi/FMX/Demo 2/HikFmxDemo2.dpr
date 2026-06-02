program HikFmxDemo2;

{
  海康威视 FMX Demo 2 — 回调软渲染版
  不依赖 HWND，视频通过 PlayCtrl 解码回调 + TBitmap 渲染到 TImage
}

uses
  System.StartUpCopy,
  Classes, Windows, System.SysUtils,
  FMX.Forms,
  uMain in 'uMain.pas' {frmMain};


//把aPath这个路径动态添加到Path环境变量中
procedure AddSearchPath(aPath: String);
var
  I: Integer;
  StrList: TStringList;
begin
 StrList := TStringList.Create;
  StrList.Delimiter := ';';
  StrList.StrictDelimiter := True;
  StrList.DelimitedText := GetEnvironmentVariable('Path');
  for I := StrList.Count-1 downto 0 do
  begin
    StrList[I] := StrList[I].Trim;
    if StrList[I] = '' then
      StrList.Delete(I);
  end;

  StrList.CaseSensitive := False;
  repeat
    I := StrList.IndexOf(aPath);
    if I <> -1 then
      StrList.Delete(I)
    else
      Break;
  until False;

  StrList.Insert(0, aPath); //提升其优先顺序
  SetEnvironmentVariable('Path', PChar(StrList.DelimitedText));
  StrList.Free;
end;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
