program HICParameterSet;

uses
  Vcl.Forms,
  UnitSetMatrix in '..\..\Source\Forms\UnitSetMatrix.pas' {SetMatrixForm},
  UnitParamList in '..\..\Source\Forms\UnitParamList.pas' {FormParamList},
  MatrixParameterConst in '..\..\Source\Common\MatrixParameterConst.pas',
  UnitSetScalarValue in '..\..\Source\Forms\UnitSetScalarValue.pas' {SetScalarValueF},
  UnitIPCClientMonitor in '..\CommonFrame\UnitIPCClientMonitor.pas' {FrameClientMonitor: TFrame},
  CommonUtil in '..\ModbusComm_kumo\common\CommonUtil.pas',
  UnitSetMatrixConfig in '..\..\Source\Forms\UnitSetMatrixConfig.pas' {SetMatrixConfigF};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormParamList, FormParamList);
  Application.CreateForm(TSetScalarValueF, SetScalarValueF);
  Application.CreateForm(TSetMatrixConfigF, SetMatrixConfigF);
  Application.Run;
end.
