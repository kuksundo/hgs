unit CSV2XlsConst;

interface

uses messages;

Const
  INIFILENAME = '.\CSV2xls.ini';
  SAVEDATA_DB_SECTION = 'MY SQL DB';
  SAVEDATA_FILE_SECTION = 'FILE';
  FILE_EXT = '.csv';
  XLS_FILE_NAME = '.\Daily work report_일지.xls';
  ECU_PATH = '.\CsvFile\';
  WOOD_PATH = '.\WoodFile\';
  GTI_PATH = '.\GtiFile\';

  SE42_CSVIDX = 62;  //Turbo Charger RPM
  TE62_CSVIDX = 22;  //LO Temp Inlet
  TE71_CSVIDX = 55;  //LT Water Temp Inlet
  TE76_CSVIDX = 21;  //HT Water Temp Outlet
  TE51_CSVIDX = 23;  //FO Temp Inlet
  TE21_CSVIDX = 56;  //Charge Temp Inlet
  PT62_CSVIDX = 28;  //LO Press Inlet Eng
  PT63_CSVIDX = 59;  //LO Press Inlet T/C
  PT71_CSVIDX = 57;  //LT Water Press Inlet
  PT75_CSVIDX = 27;  //HT Water Press Inlet
  PT51_CSVIDX = 29;  //FO Press Inlet
  PT21_CSVIDX = 60;  //Charge Air Press
  TE25_1_CSVIDX = 41;//Exh. Gas Temp #1
  TE25_2_CSVIDX = 42;//Exh. Gas Temp #2
  TE25_3_CSVIDX = 43;//Exh. Gas Temp #3
  TE25_4_CSVIDX = 44;//Exh. Gas Temp #4
  TE25_5_CSVIDX = 45;//Exh. Gas Temp #5
  TE25_6_CSVIDX = 46;//Exh. Gas Temp #6
  TE26_1_CSVIDX = 51;//Exh. Gas Temp Inlet T/C(A)
  TE26_2_CSVIDX = 52;//Exh. Gas Temp Inlet T/C(B)
  TE27_CSVIDX = 50;  //Exh. Gas Temp Outlet
  TE69_1_CSVIDX = 74;//Bearing Temp #1  **) #2번은 #1번과 동일하므로 제외
  TE69_3_CSVIDX = 75;//Bearing Temp #3
  TE69_4_CSVIDX = 76;//Bearing Temp #4
  TE69_5_CSVIDX = 77;//Bearing Temp #5
  TE69_6_CSVIDX = 78;//Bearing Temp #6
  TE69_7_CSVIDX = 79;//Bearing Temp #7
  TE69_8_CSVIDX = 80;//Bearing Temp #8
  TE98_1_CSVIDX = 24;//Gen. Winding Temp U
  TE98_2_CSVIDX = 25;//Gen. Winding Temp V
  TE98_3_CSVIDX = 26;//Gen. Winding Temp W
  TE67_1_CSVIDX = 85;//Gen. Bearing Temp

  WM_DISPLAYPROCESS = WM_USER + 1;

Type
  TFileOption = (FO_FILE, FO_DIRECTORY);

  TMsgType = (SB_PROGRESS,
              SB_RECORDCOUNT,
              SB_NOITEM2,
              SB_MESSAGE,
              SB_LED,
              SB_SIMPLE=100);

  TCsv2xlsState = (//처음 인자를 반드시 Null 로 잡을것 FSM class에서 0은 없음을 의미 하므로
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
