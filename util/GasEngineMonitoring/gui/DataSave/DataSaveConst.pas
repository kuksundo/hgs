unit DataSaveConst;

interface

const
  SAVEINIFILENAME = '.\EngineTotal_DataSave.ini';
  SAVEDATA_FIX_SECTION = 'Fix Condition';
  SAVEDATA_PERIOD_SECTION = 'Period Condition';
  SAVEDATA_MEDIA_SECTION = 'Save Media';
  SAVEDATA_DB_SECTION = 'Database';
  SAVEDATA_ETC_SECTION = 'ETC';

  SAVEDATA_DATABASE_NAME = 'EngineTotal_Client';
  SAVEDATA_LOGIN_ID = 'Gas_Total_Client';
  SAVEDATA_PASSWD = 'Gas_Total_Client';


  INSERT_FILE_NAME = 'sql\insert_pps_monitor.txt';

type
  TSaveMedia = set of (SM_DB, SM_FILE);
  TFileName_Convetion = (FC_YMD, FC_FIXED);
implementation

end.
 