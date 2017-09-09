program IMCMsgClientp;

uses
  Vcl.Forms,
  IMC.Client.Main in 'IMC.Client.Main.pas' {fMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
