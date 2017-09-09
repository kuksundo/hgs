unit WatchConst2;

interface

uses Messages;

Const
  WM_EVENT_DATA = WM_USER + 100;
  WM_WATCHFORM_CLOSE = WM_USER + 101;
  WM_DESIGNMANAGER_CLOSE = WM_USER + 102;
  WM_UPDATESTATUS_HiMECS_MDI = WM_USER + 103;
{  WM_EVENT_WT1600 = WM_USER + 102;
  WM_EVENT_MEXA7000 = WM_USER + 103;
  WM_EVENT_MT210 = WM_USER + 104;
  WM_EVENT_ECS_KUMO = WM_USER + 105;
  WM_EVENT_LBX = WM_USER + 106;
  WM_EVENT_DYNAMO = WM_USER + 107;
  WM_EVENT_ECS_AVAT = WM_USER + 108;
  WM_EVENT_FLOWMETER = WM_USER + 109;
  WM_EVENT_GASCALC  = WM_USER + 110;
}
  SB_MESSAGE_IDX = 5;

  CONFIG_FILE_EXT = '.config';
  TEMPFILENAME = 'c:\pjhtemp';

  IPCCLIENTNAME1 = 'Gas_Total';
  INIFILENAME = 'Gas_Total.ini';
  MEXA7000_SECTION = 'Gas_Total';
  DESIGNFORM_FILENAME = '_dfc'; //Design Form Config
type
  TPeriodDataType = (pdtAverage, pdtSum, pdtMin, pdtMax, pdtPoint, pdtDiff);

implementation

end.
