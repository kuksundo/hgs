unit ModbusComConst;

interface

uses Messages, Graphics;

Const
  INIFILENAME = '.\EngMonitor.ini';
  MODBUS_SECTION = 'MODBUS';
  WM_RECEIVESTRING = WM_USER + 100;
  WM_MODBUSDATA = WM_USER + 101;
  WM_MODBUSDATA2 = WM_USER + 102;
  WM_RECEIVEBYTE = WM_USER + 103;
  MODBUS_DATA_RTU_START_HI_IDX = 3;
  MODBUS_DATA_ASCII_START_HI_IDX = 8;
  MODBUS_DATA_ASCII_START_LO_IDX = 10;

  FILE_SEPERATOR = ',';
  COLOR_ON = clYellow;
  COLOR_OFF = clGray;//clLime;
  FONT_COLOR_ON = clBlack;
  FONT_COLOR_OFF = clNavy;

  COLOR_ON2 = clRed;
  COLOR_OFF2 = clGray;
  FONT_COLOR_ON2 = clBlack;
  FONT_COLOR_OFF2 = clNavy;

Type
  TModBusMode = (ASCII_MODE, RTU_MODE);
  
implementation

end.
 