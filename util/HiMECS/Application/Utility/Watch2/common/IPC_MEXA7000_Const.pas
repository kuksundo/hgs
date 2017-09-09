unit IPC_MEXA7000_Const;

interface

type
  TEventData_MEXA7000 = packed record
    CO2: string[50];//String 변수는 공유메모리에 사용 불가함
    CO_L: string[50];
    O2: string[50];
    NOx: string[50];
    THC: string[50];
    CH4: string[50];
    non_CH4: string[50];
    CollectedValue: Double;
    PowerOn: Boolean;
  end;

  TEventData_MEXA7000_2 = packed record
    CO2: Double;//String 변수는 공유메모리에 사용 불가함
    CO_L: Double;
    O2: Double;
    NOx: Double;
    THC: Double;
    CH4: Double;
    non_CH4: Double;
    CollectedValue: Double;
    PowerOn: Boolean;
 end;

const
  MEXA7000_EVENT_NAME = 'MONITOR_EVENT_MEXA7000';

implementation

end.
