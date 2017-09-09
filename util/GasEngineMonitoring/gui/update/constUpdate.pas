unit constUpdate;

interface

uses windows;

const
  PROGRAM_FILE_NAME = 'GasEngineMonitoring.exe';
  INI_FILE = 'Update.ini';
  SERVER_PATH = 'http://10.100.23.115/~Test_Develop/Application/GasEngineMonitoring/';
  UPDATE_STAMP = '0001_pjh';
  UPDATE_FILE_NAME = 'Update.exe';

var
  BytesReadUntilNow : DWord;
  
implementation

end.
