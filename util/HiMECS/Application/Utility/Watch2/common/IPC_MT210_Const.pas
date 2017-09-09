unit IPC_MT210_Const;

interface

type
  TEventData_MT210 = packed record
    FUnit: string[10]; //측정 단위
    FState: string[2];//에러 유무
    FData: double;//측정 데이타 갯수
    PowerOn: Boolean;
 end;

const
  MT210_EVENT_NAME = 'MONITOR_EVENT_MT210';

implementation

end.
