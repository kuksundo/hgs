unit UnitCrankIotSensorInterface;

interface

uses SynCommons, UnitAlarmConst;

type
  ICraneSensor = interface(IInvokable)
    ['{23C0BA00-BCCF-43DC-A1CE-FD4947084DA6}']
    function AddCraneXYnLoad(X,Y,Load: string): Boolean;
  end;

implementation

end.
