library CalContextAddIn;

uses
  ComServ,
  CalContextAddIn_TLB in 'CalContextAddIn_TLB.pas',
  CalContextAddIn_IMPL in 'CalContextAddIn_IMPL.pas' {AddInModule: TAddInModule} {CoCalContextAddIn: CoClass},
  HHI_WebService in '..\..\DPMS\CommonUtil\HHI_WebService.pas',
  UnitHHIMessage in '..\..\DPMS\CommonUtil\UnitHHIMessage.pas',
  CommonUtil_Unit in '..\..\DPMS\CommonUtil\CommonUtil_Unit.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
