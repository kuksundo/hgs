unit ModbusComConst_endurance;

interface

uses Messages;//, Graphics;

Const
  //INIFILENAME = 'EngMonitor_HIC.ini';
  //SAVEINIFILENAME = 'SaveData_HIC.ini';
  MODBUS_SECTION = 'MODBUS';
  WM_RECEIVESTRING = WM_USER + 100;
  WM_MODBUSDATA = WM_USER + 101;
  WM_MODBUSDATA2 = WM_USER + 102;
  WM_RECEIVEBYTE = WM_USER + 103;
  WM_RECEIVEWORD_TCP = WM_USER + 104;
  WM_RECEIVEWORD_TCPWAGO = WM_USER + 105;
  WM_EVENT_WRITECOMM = WM_USER + 106;
  WM_EVENT_MATRIX_COMM = WM_USER + 107;
  WM_EVENT_PARAM_COMM = WM_USER + 108;
  WM_RECEIVEBYTE_WRITE = WM_USER + 109;
  WM_RECEIVEBYTE_CONFIGDATA = WM_USER + 110;
  WM_MATRIXFORMCLOSE = WM_USER + 111;
  WM_SCALARFORMCLOSE = WM_USER + 112;
  WM_EVENT_SCALARVALUE_COMM = WM_USER + 113;

  MODBUS_DATA_RTU_START_HI_IDX = 3;
  MODBUS_DATA_TCPWAGO_START_HI_IDX = 2;
  WM_SAVEDATA = WM_USER + 103;
  MODBUS_DATA_ASCII_START_HI_IDX = 8;
  MODBUS_DATA_ASCII_START_LO_IDX = 10;

  FILE_SEPERATOR = ',';
  //COLOR_ON = clRed;
  //COLOR_OFF = clLime;
  
Type
  TModBusMode = (ASCII_MODE, RTU_MODE, TCP_WAGO_MODE, SIMULATE_MODE, MODBUSTCP_MODE, MODBUSSERIAL_TCP_MODE);
  TCommMode = (CM_DATA_READ, CM_CONFIG_READ, CM_DATA_WRITE, CM_CONFIG_WRITE, CM_CONFIG_WRITE_CONFIRM);

  TModbusTCP_Command = class(TObject)
    FSlaveAddress: integer;
    FFunctionCode: integer;
    FStartAddress: integer;
    FDataCountWord: integer;
    FRepeatCount: integer;//통신 반복 회수: -1이면 무한 반복
    FBufferWord: array of word;//Write할 Data
  end;

const
  COMMMODECOUNT = integer(High(TCommMode))+1;
  R_CommMode : array[0..COMMMODECOUNT-1] of record
    Description : string;
    Value       : TCommMode;
  end = ((Description : 'Data Read';            Value : CM_DATA_READ),
         (Description : 'Config Read';          Value : CM_CONFIG_READ),
         (Description : 'Data Write';           Value : CM_DATA_WRITE),
         (Description : 'Config Write';         Value : CM_CONFIG_WRITE),
         (Description : 'Config Write Confirm'; Value : CM_CONFIG_WRITE_CONFIRM));

  function CommMode2String(ACommMode:TCommMode) : string;

implementation

function CommMode2String(ACommMode:TCommMode) : string;
begin
  Result := R_CommMode[ord(ACommMode)].Description;
end;

end.
 