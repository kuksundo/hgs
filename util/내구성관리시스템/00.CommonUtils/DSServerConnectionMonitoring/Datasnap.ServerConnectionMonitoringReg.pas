unit Datasnap.ServerConnectionMonitoringReg;

interface

procedure Register;

implementation

uses
  System.Classes,
  Datasnap.ServerConnectionMonitoring,
  DSServerDsnResStrs;

procedure Register;
begin
  RegisterComponents(rsDataSnapServerPage, [TDSServerConnectionMonitor]);
end;

end.
