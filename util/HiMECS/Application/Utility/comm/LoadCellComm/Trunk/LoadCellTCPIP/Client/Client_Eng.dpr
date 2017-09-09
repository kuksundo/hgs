program Client_Eng;

uses
  Forms,
  ClientFrmMainUnit in 'ClientFrmMainUnit.pas' {ClientFrmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TClientFrmMain, ClientFrmMain);
  Application.Run;
end.
