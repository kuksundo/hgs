unit WT1600Const;

interface

uses messages;

Const
  INIFILENAME = '.\WT1600.ini';
  WT1600_SECTION = 'Communication';
  WM_POWERMETER_ON = WM_USER + 100;
  WM_WT1600DATA = WM_USER + 101;

  WM_WT1600DATA1 = WM_USER + 102;
  WM_WT1600DATA2 = WM_USER + 103;
  WM_WT1600DATA3 = WM_USER + 104;
  WM_WT1600DATA4 = WM_USER + 105;
  WM_WT1600DATA5 = WM_USER + 106;
  WM_WT1600DATA6 = WM_USER + 107;
  WM_WT1600DATA7 = WM_USER + 108;
  WM_WT1600DATA8 = WM_USER + 109;
  WM_WT1600DATA9 = WM_USER + 110;
  WM_UPDATESTATUS_HiMECS_MDI = WM_USER + 111;
  
  MAX_ITEM = 10;      //the max items count.
  MAX_ELEMENT = 6;    //the max elements count.
  MAX_LINES = 499;    //the max monitor lines count.
  TIMER_1 = 1;        //used when getting data by update rate.
  TIMER_2 = 2;        //used when getting data by timer.
  MODEL = '760101'; //used when testing instrument model.
  CMaxMonitorCount = 9;

implementation

end.
 