program Server_Eng;

uses
  Forms,
  ServerFrmMainUnit in 'ServerFrmMainUnit.pas' {ServerFrmMain},
  GlobalUnit in '..\Common\GlobalUnit.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TServerFrmMain, ServerFrmMain);
  Application.Run;
end.
