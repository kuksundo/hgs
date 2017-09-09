unit DataSaveConst;

interface

const
  SAVEINIFILENAME = '.\DataSave.ini';
  SAVEDATA_FIX_SECTION = 'Fix Condition';
  SAVEDATA_PERIOD_SECTION = 'Period Condition';
  SAVEDATA_MEDIA_SECTION = 'Save Media';
  SAVEDATA_DB_SECTION = 'Database';
  SAVEDATA_ETC_SECTION = 'ETC';

type
  TSaveMedia = set of (SM_DB, SM_FILE);
  TFileName_Convetion = (FC_YMD, FC_FIXED);
implementation

end.
 