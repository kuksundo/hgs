unit UnitAlarmReportInterface;

interface

uses SynCommons, UnitAlarmConst;

type
  IAlarmReport = interface(IInvokable)
    ['{0254B82D-5BB0-4441-A3D6-FCDFAFBC9763}']
    procedure AddAlarm(AAlarm: RawUTF8);
    function AddAlarmRecord(const AAlarmRecord: TAlarmListRecord): Boolean;
    function ReleaseAlarmRecord(const AAlarmRecord: TAlarmListRecord): Boolean;
  end;

implementation

end.
