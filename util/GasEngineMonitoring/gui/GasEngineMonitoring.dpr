program GasEngineMonitoring;

uses
  Forms,
  SysUtils,
  Windows,
  unitMain in 'unitMain.pas' {Form1},
  ConfigConst in 'ConfigConst.pas',
  EngMonitorConfig in 'EngMonitorConfig.pas' {EngMonitorConfigF},
  ConfigForm in 'ConfigForm.pas' {ConfigFormF},
  Options in 'Options.pas',
  ConfigUtil in 'ConfigUtil.pas',
  uHTTPs in 'update\uHTTPs.pas',
  constUpdate in 'update\constUpdate.pas',
  about in 'about.pas' {AboutF},
  BGVersion in 'common\BGVersion.pas',
  JvgXMLSerializer_Encrypt in '..\..\HiMECS\Application\Source\Common\JvgXMLSerializer_Encrypt.pas';

{$R *.RES}

//var
//  bStart : Boolean;

begin
  Application.Initialize;

//  bStart := UpdateProgramCheck;

  Application.CreateForm(TForm1, Form1);
  //  if bStart then begin
//    Form1.Close;
//    WinExec(PChar(UPDATE_FILE_NAME + ' ' + IntToStr(Form1.Handle)), SW_SHOW);
//    Application.Terminate;
//  end;
  
  Application.Run;
end.
