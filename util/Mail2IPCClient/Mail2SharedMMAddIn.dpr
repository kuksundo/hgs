library Mail2SharedMMAddIn;

uses
  ComServ,
  CalContextAddIn_TLB in '..\CalContextMenuAddIn\CalContextAddIn_TLB.pas',
  Mail2SharedMMAddIn_IMPL in 'Mail2SharedMMAddIn_IMPL.pas' {AddInModule: TAddInModule} {CoCalContextAddIn: CoClass},
  HHI_WebService in '..\..\DPMS\CommonUtil\HHI_WebService.pas',
  UnitHHIMessage in '..\..\DPMS\CommonUtil\UnitHHIMessage.pas',
  CommonUtil_Unit in '..\..\DPMS\CommonUtil\CommonUtil_Unit.pas',
  GpSharedMemory in '..\..\..\common\GpDelphiUnit\src\GpSharedMemory.pas',
  CommonData in '..\..\..\..\temp\ipcclient test\CommonData.pas',
  UnitSynLog in '..\..\..\common\UnitSynLog.pas',
  IPC.Events in '..\..\..\common\SharedMemoryTest-master\IPC.Events.pas',
  IPC.SharedMem in '..\..\..\common\SharedMemoryTest-master\IPC.SharedMem.pas',
  SynCommons in '..\..\..\common\mORMot\SynCommons.pas',
  StompClient in '..\..\..\common\delphistompclient-master\StompClient.pas',
  StompTypes in '..\..\..\common\delphistompclient-master\StompTypes.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
