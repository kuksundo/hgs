unit DataSaveConst;

interface

const
  SAVEINIFILENAME = '.\DataSave.ini';
  SAVEDATA_FIX_SECTION = 'Fix Condition';
  SAVEDATA_PERIOD_SECTION = 'Period Condition';
  SAVEDATA_MEDIA_SECTION = 'Save Media';
  SAVEDATA_DB_SECTION = 'Database';
  SAVEDATA_ETC_SECTION = 'ETC';

  INSERT_FILE_NAME = 'sql\insert_pps_monitor.txt';
  MAP_FILE_NAME = '.\BEM500.txt';

type
  TSaveMedia = set of (SM_DB, SM_FILE);
  TFileName_Convetion = (FC_YMD, FC_FIXED);
implementation

end.
 