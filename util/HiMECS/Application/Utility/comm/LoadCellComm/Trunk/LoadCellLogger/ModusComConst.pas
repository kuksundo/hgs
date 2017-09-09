unit ModusComConst;

interface

uses Messages, Graphics;

Const
  INIFILENAME = 'EngMonitor.ini';
  SAVEINIFILENAME = 'SaveData.ini';
  WM_RECEIVESTRING = WM_USER + 100;
  WM_MODBUSDATA = WM_USER + 101;
  WM_RECEIVEBYTE = WM_USER + 102;
  WM_SAVEDATA = WM_USER + 103;
  
  MODBUS_DATA_START_HI_IDX = 8;
  MODBUS_DATA_START_LO_IDX = 10;

  FILE_SEPERATOR = ',';
  COLOR_ON = clRed;
  COLOR_OFF = clLime;
  
Type
  TModBusMode = (ASCII_MODE, RTU_MODE);
  
implementation

end.
 