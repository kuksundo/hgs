program DynamoComm;

uses
  //RunOne,
  Forms,
  UnitDynamoComm in 'UnitDynamoComm.pas' {DynamoCommF},
  UnitDynamoCommConfig in 'UnitDynamoCommConfig.pas' {DynamoConfigF},
  UnitDynamoConfigClass in 'UnitDynamoConfigClass.pas',
  UnitDynamoConst in 'UnitDynamoConst.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDynamoCommF, DynamoCommF);
  Application.Run;
end.
