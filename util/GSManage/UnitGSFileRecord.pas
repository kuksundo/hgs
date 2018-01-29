unit UnitGSFileRecord;

interface

uses
  Classes,
  System.SysUtils,
  SynCommons,
  mORMot,
  CommonData;

type
  PSQLGSFileRec = ^TSQLGSFileRec;
  TSQLGSFileRec = Packed Record
    fFilename: RawUTF8;
    fGSDocType: TGSDocType;
    fData: RawByteString;
  end;

  TSQLGSFileRecs = array of TSQLGSFileRec;

  TSQLGSFile = class(TSQLRecord)
  private
    fTaskID: TID;
    fFiles: TSQLGSFileRecs;
  published
    property TaskID: TID read fTaskID write fTaskID;
    property Files: TSQLGSFileRecs read fFiles write fFiles;
  end;

procedure InitGSFileClient(AExeName: string = '');
function CreateFilesModel: TSQLModel;

function GetGSFilesFromID(AID: TID): TSQLGSFile;

var
  g_FileDB: TSQLRestClientURI;
  FileModel: TSQLModel;

implementation

uses mORMotSQLite3;

procedure InitGSFileClient(AExeName: string);
var
  LStr: string;
begin
  LStr := ChangeFileExt(AExeName,'.sqlite');
  LStr := LStr.Replace('.sqlite', '_Files.sqlite');
  FileModel := CreateFilesModel;
  g_FileDB:= TSQLRestClientDB.Create(FileModel, CreateFilesModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_FileDB).Server.CreateMissingTables;
end;

function CreateFilesModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLGSFile]);
end;

function GetGSFilesFromID(AID: TID): TSQLGSFile;
begin
  Result := TSQLGSFile.CreateAndFillPrepare(g_FileDB, 'TaskID = ?', [AID]);
end;

initialization

finalization
  if Assigned(g_FileDB) then
    FreeAndNil(g_FileDB);
  if Assigned(FileModel) then
    FreeAndNil(FileModel);

end.
