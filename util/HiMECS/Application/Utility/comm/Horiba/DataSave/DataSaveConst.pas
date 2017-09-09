unit DataSaveConst;

interface

const
  SAVEINIFILENAME = '.\DataSave.ini';
  SAVEDATA_FIX_SECTION = 'Fix Condition';
  SAVEDATA_PERIOD_SECTION = 'Period Condition';
  SAVEDATA_MEDIA_SECTION = 'Save Media';
  SAVEDATA_DB_SECTION = 'Database';
  SAVEDATA_ETC_SECTION = 'ETC';

  SAVEDATA_DATABASE_NAME = 'Horiba_MEXA_7000_Client';
  SAVEDATA_LOGIN_ID = 'Horiba_MEXA_7000_Client';
  SAVEDATA_PASSWD = 'Horiba_MEXA_7000_Client';


  INSERT_FILE_NAME = 'sql\insert_pps_monitor.txt';
  MAP_FILE_NAME = '.\BEM500.txt';

type
  TSaveMedia = set of (SM_DB, SM_FILE);
  TFileName_Convetion = (FC_YMD, FC_FIXED);
implementation

end.
 