library Mail2IPCClientAddIn;

uses
  ComServ,
  CalContextAddIn_TLB in '..\CalContextMenuAddIn\CalContextAddIn_TLB.pas',
  Mail2IPCClientAddIn_IMPL in 'Mail2IPCClientAddIn_IMPL.pas' {AddInModule: TAddInModule} {CoCalContextAddIn: CoClass},
  HHI_WebService in '..\..\DPMS\CommonUtil\HHI_WebService.pas',
  UnitHHIMessage in '..\..\DPMS\CommonUtil\UnitHHIMessage.pas',
  CommonUtil_Unit in '..\..\DPMS\CommonUtil\CommonUtil_Unit.pas',
  GpSharedMemory in '..\..\..\common\GpDelphiUnit\src\GpSharedMemory.pas',
  IPCThreadEvent2 in '..\..\..\common\IPCThreadEvent2.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
