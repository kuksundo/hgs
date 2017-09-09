unit DataSaveAll_Const;

interface

uses messages;

const
  SAVEINIFILENAME = '.\DataSaveAll.ini';
  SAVERUNHOURINIFILENAME = 'RunHour.ini';
  RUNHOUR_SEMAPHORENAME = 'DataSaveAll_RunHour_Sem';
  SAVEDATA_FIX_SECTION = 'Fix Condition';
  SAVEDATA_PERIOD_SECTION = 'Period Condition';
  SAVEDATA_MEDIA_SECTION = 'Save Media';
  SAVEDATA_DB_SECTION = 'Database';
  SAVEDATA_ETC_SECTION = 'ETC';

  SAVEDATA_LOGIN_ID = 'KUMO_ECS_SAVE';
  SAVEDATA_PASSWD = 'KUMO_ECS_SAVE';

  DATASAVE_SECTION = 'Datasave';
  ORACLE_SECTION = 'Oracle';
  MONGODB_SECTION = 'MongoDB';
  PARAM_SECTION = 'Parameter Source';
  ACTIONSAVE_SECTION = 'Action Save';
  ENGMONITOR_SECTION = 'Engine Monitor';
  WM_DB_DISCONNECTED = WM_USER + 100;
  WM_UPDATESTATUS_HiMECS_MDI = WM_USER + 101;

type
  TSaveMedia = set of (SM_DB, SM_FILE);
  TFileName_Convetion = (FC_YMD, FC_FIXED);
  TDBType = (DT_ORACLE, DT_MONGODB);
  TDisplayTarget = (dtSendMemo, dtStatusBar);

implementation

end.
