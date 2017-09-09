program BuzzerServer;

uses
  Vcl.Forms,
  UnitBuzzerServer in 'UnitBuzzerServer.pas' {BuzzerServerF},
  QLite in 'QLite.pas',
  UnitBuzzerInterface in 'UnitBuzzerInterface.pas',
  UnitLampTest in 'UnitLampTest.pas' {LampTestF},
  UnitFrameCommServer in '..\..\HiMECS\Application\Utility\CommonFrame\UnitFrameCommServer.pas' {FrameCommServer: TFrame},
  getIp in '..\..\PMSOPCRest\common\getIp.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TBuzzerServerF, BuzzerServerF);
  Application.Run;
end.
