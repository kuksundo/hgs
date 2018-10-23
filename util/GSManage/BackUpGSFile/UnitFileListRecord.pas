unit UnitFileListRecord;

interface

uses
  Classes,
  System.SysUtils,
  SynCommons,
  mORMot;

type
  PSQLBackUpFileRec = ^TSQLBackUpFileRec;
  TSQLBackUpFileRec = Packed Record
    fFilename: RawUTF8;
    fIsDir: Boolean;
    fData: RawByteString;
  end;

  TSQLBackUpFileRecs = array of TSQLBackUpFileRec;

  TSQLBackUpDBList = class(TSQLRecord)
  private
    fDBName: RawUTF8;
  public
    fIsUpdate: Boolean;
    property IsUpdate: Boolean read fIsUpdate write fIsUpdate;
  published
    property DBName: RawUTF8 read fDBName write fDBName;
  end;

  TSQLBackUpFile = class(TSQLRecord)
  private
    fTaskID: TID;
    fFiles: TSQLBackUpFileRecs;
  public
    fIsUpdate: Boolean;
    property IsUpdate: Boolean read fIsUpdate write fIsUpdate;
  published
    property TaskID: TID read fTaskID write fTaskID;
    property Files: TSQLBackUpFileRecs read fFiles write fFiles;
  end;

procedure InitBackUpFileClient(AExeName: string = '');
function CreateFilesModel: TSQLModel;
procedure InitBackUpDBListClient(AExeName: string = '');
function CreateDBListModel: TSQLModel;

function GetBackUpFilesFromID(const AID: TID): TSQLBackUpFile;
procedure AddOrUpdateBackUpFiles(ASQLBackUpFile: TSQLBackUpFile);
procedure DeleteBackUpFilesFromID(const AID: TID);

function GetBackUpDBListFromID(const AID: TID): TSQLBackUpDBList;
procedure AddOrUpdateBackUpDBList(ASQLBackUpDBList: TSQLBackUpDBList);
procedure DeleteBackUpDBListFromID(const AID: TID);

var
  g_FileDB,
  g_DBList: TSQLRestClientURI;
  FileModel,
  DBListModel: TSQLModel;

implementation

uses mORMotSQLite3, UnitFolderUtil;

procedure InitBackUpFileClient(AExeName: string);
var
  LStr: string;
begin
  LStr := ChangeFileExt(ExtractFileName(AExeName),'.sqlite');
  LStr := LStr.Replace('.sqlite', '_Files.sqlite');
  AExeName := GetSubFolderPath(ExtractFilePath(AExeName), 'db');
  AExeName := EnsureDirectoryExists(AExeName);
  LStr := AExeName + LStr;
  FileModel := CreateFilesModel;
  g_FileDB:= TSQLRestClientDB.Create(FileModel, CreateFilesModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_FileDB).Server.CreateMissingTables;
end;

function CreateFilesModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLBackUpFile]);
end;

procedure InitBackUpDBListClient(AExeName: string = '');
var
  LStr: string;
begin
  LStr := ChangeFileExt(ExtractFileName(AExeName),'.sqlite');
  LStr := LStr.Replace('.sqlite', '_DBList.sqlite');
  AExeName := GetSubFolderPath(ExtractFilePath(AExeName), 'db');
  AExeName := EnsureDirectoryExists(AExeName);
  LStr := AExeName + LStr;
  DBListModel := CreateDBListModel;
  g_DBList:= TSQLRestClientDB.Create(DBListModel, CreateDBListModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_DBList).Server.CreateMissingTables;
end;

function CreateDBListModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLBackUpDBList]);
end;

function GetBackUpFilesFromID(const AID: TID): TSQLBackUpFile;
begin
  Result := TSQLBackUpFile.CreateAndFillPrepare(g_FileDB, 'TaskID = ?', [AID]);
  Result.IsUpdate := Result.FillOne;

  if not Result.IsUpdate then
    Result.fTaskID := AID;
end;

procedure AddOrUpdateBackUpFiles(ASQLBackUpFile: TSQLBackUpFile);
begin
  if ASQLBackUpFile.IsUpdate then
  begin
    g_FileDB.Update(ASQLBackUpFile);
  end
  else
  begin
    g_FileDB.Add(ASQLBackUpFile, true);
//    ASQLBackUpFile.TaskID := ASQLBackUpFile.ID;
//    g_FileDB.Update(ASQLBackUpFile);
  end;
end;

procedure DeleteBackUpFilesFromID(const AID: TID);
begin
  g_FileDB.Delete(TSQLBackUpFile, AID);
end;

function GetBackUpDBListFromID(const AID: TID): TSQLBackUpDBList;
begin
  Result := TSQLBackUpFile.CreateAndFillPrepare(g_DBList, 'ID = ?', [AID]);
  Result.IsUpdate := Result.FillOne;
end;

procedure AddOrUpdateBackUpDBList(ASQLBackUpDBList: TSQLBackUpDBList);
begin
  if ASQLBackUpDBList.IsUpdate then
  begin
    g_DBList.Update(ASQLBackUpDBList);
  end
  else
  begin
    g_DBList.Add(ASQLBackUpDBList, true);
  end;
end;

procedure DeleteBackUpDBListFromID(const AID: TID);
begin
  g_DBList.Delete(TSQLBackUpDBList, AID);
end;

initialization

finalization
  if Assigned(g_FileDB) then
    FreeAndNil(g_FileDB);
  if Assigned(FileModel) then
    FreeAndNil(FileModel);
  if Assigned(g_DBList) then
    FreeAndNil(g_DBList);
  if Assigned(DBListModel) then
    FreeAndNil(DBListModel);

end.
