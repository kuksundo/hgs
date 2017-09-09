library Mail2CromisIPC;

uses
  ComServ,
  CalContextAddIn_TLB in '..\CalContextMenuAddIn\CalContextAddIn_TLB.pas',
  HHI_WebService in '..\..\DPMS\CommonUtil\HHI_WebService.pas',
  UnitHHIMessage in '..\..\DPMS\CommonUtil\UnitHHIMessage.pas',
  CommonUtil_Unit in '..\..\DPMS\CommonUtil\CommonUtil_Unit.pas',
  GpSharedMemory in '..\..\..\common\GpDelphiUnit\src\GpSharedMemory.pas',
  CommonData in '..\..\GSManage\CommonData.pas',
  UnitSynLog in '..\..\..\common\UnitSynLog.pas',
  IPC.Events in '..\..\..\common\SharedMemoryTest-master\IPC.Events.pas',
  IPC.SharedMem in '..\..\..\common\SharedMemoryTest-master\IPC.SharedMem.pas',
  SynCommons in '..\..\..\common\mORMot\SynCommons.pas',
  StompClient in '..\..\..\common\delphistompclient-master\StompClient.pas',
  StompTypes in '..\..\..\common\delphistompclient-master\StompTypes.pas',
  Mail2CromisIPCAddIn_IMPL in 'Mail2CromisIPCAddIn_IMPL.pas' {AddInModule: TadxCOMAddInModule},
  UnitClientInfoClass in 'UnitClientInfoClass.pas',
  BaseConfigCollect in '..\..\HiMECS\Application\Source\Common\BaseConfigCollect.pas',
  MailCallbackInterface in 'MailCallbackInterface.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
