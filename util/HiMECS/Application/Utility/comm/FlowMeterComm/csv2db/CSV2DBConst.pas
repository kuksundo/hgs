unit CSV2DBConst;

interface

uses messages;

Const
  INIFILENAME = '.\CSV2DB.ini';
  SAVEDATA_DB_SECTION = 'MY SQL DB';
  SAVEDATA_FILE_SECTION = 'FILE';

  WM_DISPLAYPROCESS = WM_USER + 1;

Type
  TFileOption = (FO_FILE, FO_DIRECTORY);

  TMsgType = (SB_PROGRESS,
              SB_RECORDCOUNT,
              SB_NOITEM2,
              SB_MESSAGE,
              SB_LED,
              SB_SIMPLE=100);
  
  TCsv2DBState = (//처음 인자를 반드시 Null 로 잡을것 FSM class에서 0은 없음을 의미 하므로
                  S_NULL,
                  S_BEFORESTART,
                  S_SUSPEND_INSERT,
                  S_INSERTING,
                  S_FINISHED_INSERT,

                  I_RUN,
                  I_SUSPEND,
                  I_STOP,
                  I_NULL,
                  NUMBER_OF_IDS_USED);

const
  pzStringIDs : array[0..Ord(NUMBER_OF_IDS_USED)-1] of string =
                    (
                      '',
                      'Before Start',
                    	'Suspend Insert',
                      'Inserting',
                    	'Insert Finished',
                      'Run',
                    	'Suspend',
                      'Stop',
                    	''
  );

implementation

end.
