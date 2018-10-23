unit UnitMonitorUtil;

interface

uses windows, sysutils, Dialogs, MultiMon, Forms;

procedure GetMonitorFromRunningApp(AHandle: THandle);

implementation

procedure GetMonitorFromRunningApp(AHandle: THandle);
var
 LMonitor : TMonitor;
 LMonitorInfo : TMonitorInfoEx;
begin
  ZeroMemory(@LMonitorInfo, SizeOf(LMonitorInfo));
  LMonitorInfo.cbSize := SizeOf(LMonitorInfo);
  LMonitor:=Screen.MonitorFromWindow(AHandle); //pass the handle of the form
  if not GetMonitorInfo(LMonitor.Handle, @LMonitorInfo) then
     RaiseLastOSError;
  ShowMessage(Format('The form is in the monitor Index %d - %s', [LMonitor.MonitorNum, LMonitorInfo.szDevice]));
end;

end.
