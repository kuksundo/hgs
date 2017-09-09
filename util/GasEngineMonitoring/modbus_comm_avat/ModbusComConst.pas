unit ModbusComConst;

interface

uses Messages, Graphics;

Const
  INIFILENAME = 'EngMonitor_avat.ini';
  SAVEINIFILENAME = 'SaveData_avat.ini';
  MODBUS_SECTION = 'MODBUS';
  IPCCLIENTNAME1 = 'ModBusCom_Avat';
  IPCCLIENTNAME2 = 'ModBusCom_Avat2';
  WM_RECEIVESTRING = WM_USER + 100;
  WM_MODBUSDATA = WM_USER + 101;
  WM_MODBUSDATA2 = WM_USER + 102;
  WM_RECEIVEBYTE = WM_USER + 103;
  WM_RECEIVEWORD_TCP = WM_USER + 104;
  WM_RECEIVEWORD_TCPWAGO = WM_USER + 105;

  MODBUS_DATA_RTU_START_HI_IDX = 3;
  MODBUS_DATA_TCPWAGO_START_HI_IDX = 2;
  WM_SAVEDATA = WM_USER + 103;
  MODBUS_DATA_ASCII_START_HI_IDX = 8;
  MODBUS_DATA_ASCII_START_LO_IDX = 10;

  FILE_SEPERATOR = ',';
  COLOR_ON = clRed;
  COLOR_OFF = clLime;
  
Type
  TModBusMode = (ASCII_MODE, RTU_MODE, TCP_WAGO_MODE, SIMULATE_MODE, MODBUSTCP_MODE);

  TModbusTCP_Command = class(TObject)
    FFunctionCode: integer;
    FStartAddress: integer;
    FDataCountWord: integer;
    FRepeatCount: integer;//통신 반복 회수: -1이면 무한 반복
    FBufferWord: array of word;//Write할 Data
  end;
  
implementation

end.
 