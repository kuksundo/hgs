unit TCPServerConst;

interface

uses messages;

Const
  INIFILENAME = '.\KUMO_ECS.ini';
  WT1600_SECTION = 'Communication';
  WM_EVENT_ECS = WM_USER + 102;
  //ECS_SHARE_NAME = 'ModBusCom_kumo';

  MAX_ITEM = 10;      //the max items count.
  MAX_ELEMENT = 6;    //the max elements count.
  MAX_LINES = 499;    //the max monitor lines count.
  TIMER_1 = 1;        //used when getting data by update rate.
  TIMER_2 = 2;        //used when getting data by timer.
  MODEL = '760101'; //used when testing instrument model.
  CMaxMonitorCount = 9;
  DISPLAYALLDATACOUNT = 4;

implementation

end.
 