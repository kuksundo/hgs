unit IPC_LBX_Const;

interface

type
  TEventData_LBX = packed record
    IPAddress: string[16];
    ENGRPM: integer;
    HTTEMP: integer;
    LOTEMP: integer;
    TCRPMA: integer;
    TCRPMB: integer;
    TCINLETTEMP: integer;
    LBXNo: integer;
    PowerOn: Boolean;
  end;

const
  LBX_EVENT_NAME = 'MONITOR_EVENT_LBX';

implementation

end.
