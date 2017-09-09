unit PPP_Const;

interface

uses messages;

const
  SAVEINIFILENAME = '.\DataSaveAll.ini';

  DATASAVE_SECTION = 'Datasave';
  ORACLE_SECTION = 'Oracle';
  MONGODB_SECTION = 'MongoDB';
  PARAM_SECTION = 'Parameter Source';

//  WM_DB_DISCONNECTED = WM_USER + 100;
//  WM_UPDATESTATUS_HiMECS_MDI = WM_USER + 101;

type
  TDBType = (DT_ORACLE, DT_MONGODB);

implementation

end.
