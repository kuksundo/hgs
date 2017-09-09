unit IPC_dynamo_Const;

interface

type
  TEventData_DYNAMO = packed record
    FPower: double;
    FPowerUnit: string;
    FTorque: double;
    FTorqueUnit: string;
    FRevolution: double;
    FBrgTBTemp: double;
    FBrgMTRTemp: double;
    FWaterInletTemp: double;
    FWaterOutletTemp: double;
    FBody1Press: double;
    FBody2Press: double;
    FInletOpen1: double;
    FInletOpen2: double;
    FOutletOpen1: double;
    FOutletOpen2: double;
    FOilPress: double;
    FWaterSupply: double;
    PowerOn: Boolean;
 end;

const
  DYNAMO_EVENT_NAME = 'MONITOR_EVENT_DYNAMO';

implementation

end.
