program IMCMsgSvrp;

uses
  Vcl.Forms,
  IMC.Server.Main in 'IMC.Server.Main.pas' {fMain},
  UnitFrameCommServer in '..\..\CommonFrame\UnitFrameCommServer.pas' {FrameCommServer: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
