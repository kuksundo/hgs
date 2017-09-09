unit S7CommConst;

interface

uses Messages, Graphics, HiMECSConst;

Const
  INIFILENAME = 'EngMonitor_kumo.ini';
  SAVEINIFILENAME = 'SaveData_kumo.ini';
  MODBUS_SECTION = 'S7';
  IPCCLIENTNAME1 = 'ModBusCom_kumo';
  WM_RECEIVENODAVE = WM_USER + 100;

  FILE_SEPERATOR = ',';

Type
  TS7CommBlock = class(TObject)
    FS7Area: TS7Area;
    FS7DBAddress: integer;
    FS7DataType: TS7DataType;
    FS7StartOffset: integer;
    FS7Count: integer;
    FBlockNo: integer;
  end;
  
implementation

end.
 