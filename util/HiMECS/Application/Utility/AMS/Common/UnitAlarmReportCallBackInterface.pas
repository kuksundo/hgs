unit UnitAlarmReportCallBackInterface;

interface

uses SynCommons;

type
  IAlarmReportCallBack = interface(IInvokable)
    ['{336BDA1A-4947-4777-B7CD-53066854E7D3}']
    function AlarmConfigChangedPerEngine(UniqueEngine: RawUTF8; SenderUrl: string): Boolean;
  end;

implementation

end.
