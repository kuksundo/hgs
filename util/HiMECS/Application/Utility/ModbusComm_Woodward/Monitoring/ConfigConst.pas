unit ConfigConst;

interface

uses Messages;

type
  TDataType = (dtmA, dtRTD, dtTC, dtDirect, dtDigital, dtKumo);
  
Const
  WM_EVENT_WT1600 = WM_USER + 100;
  WM_EVENT_MEXA7000 = WM_USER + 101;
  WM_EVENT_ECS = WM_USER + 102;
  WM_EVENT_LBX = WM_USER + 103;
  WM_EVENT_MT210 = WM_USER + 104;

  NUMBEROFCYLINDER = 8;

  CONFIG_FILE_EXT = '.option';
  MEXA7000_SHARE_NAME = 'Horiba_MEXA_7000';
  MT210_SHARE_NAME = 'MT210';
  WT1600_SHARE_NAME = '192.168.0.48';
  ECS_SHARE_NAME = 'ModBusCom_kumo';
  LBX_SHARE_NAME = 'Horiba_MEXA_7000';

  COMP_CODE_FILENAME = 'ComponentCode.ini';
  INIFILENAME = 'MEXA7000.ini';
  MEXA7000_SECTION = 'MEXA 7000';

  ENGMONITOR_SECTION = 'Engine Monitor';

  COLOR_ON = $0000FF; //clRed;
  COLOR_OFF = $00FF00;//clLime;
  COLOR_ON2 = $0000FF; //clRed;
  COLOR_OFF2 = $00FF00;//clLime;

  CmmWC = 101.971553;

implementation

end.
