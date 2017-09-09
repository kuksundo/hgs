unit IPC_PMS_Const;

interface

type
  TEventData_PMS = packed record
    InpDataBuf: array[0..1669] of string[20];
    PowerOn: Boolean;
  end;

const
  PMS_EVENT_NAME = 'MONITOR_EVENT_PMS';

implementation

end.
