unit IPC_EngineParam_Const;

interface

type
  TEventData_EngineParam = packed record
    FDataCount: integer;
    FData: array[0..1999] of string[20];
    PowerOn: Boolean;
  end;

const
  ENGINEPARAM_EVENT_NAME = 'MONITOR_EVENT_EngineParam';

implementation

end.
