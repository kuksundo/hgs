unit IPC_WT1600_Const;

interface

type
  PEventData_WT1600 = ^TEventData_WT1600;
  TEventData_WT1600 = packed record
    IPAddress: string[16];
    URMS1: string[50];
    URMS2: string[50];
    URMS3: string[50];
    IRMS1: string[50];
    IRMS2: string[50];
    IRMS3: string[50];
    PSIGMA: string[50];
    SSIGMA: string[50];
    QSIGMA: string[50];
    RAMDA: string[50];
    URMSAVG: string[50];
    IRMSAVG: string[50];
    FREQUENCY: string[50];
    F1: string[50];
    PowerMeterOn: Boolean;
    PowerMeterNo: integer;
    UniqueEngineName: string[20];
  end;

const
  WT1600_EVENT_NAME = 'MONITOR_EVENT_WT1600';

implementation

end.
