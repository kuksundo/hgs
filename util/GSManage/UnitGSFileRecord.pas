unit UnitGSFileRecord;

interface

uses
  Classes,
  System.SysUtils,
  SynCommons,
  mORMot;

type
  TSQLGSFile = class;

  PSQLGSFileRec = ^TSQLGSFileRec;
  TSQLGSFileRec = Packed Record
    fFilename: RawUTF8;
    fGSDocType: integer;//TGSDocType;
    fFileSize: integer;
    fData: RawByteString;
  end;

  TSQLGSFileRecs = array of TSQLGSFileRec;

  TIDList4GSFile = class
    fTaskId  : TID;
    fGSAction,
    fGSDocType: integer;
    fGSFile: TSQLGSFile;
  public
    property GSAction: integer read fGSAction write fGSAction;
  published
    property TaskId: TID read fTaskId write fTaskId;
    property GSDocType: integer read fGSDocType write fGSDocType;
    property GSFile: TSQLGSFile read fGSFile write fGSFile;
  end;

  TSQLGSFile = class(TSQLRecord)
  private
    fTaskID: TID;
    fFiles: TSQLGSFileRecs;
  public
    fIsUpdate: Boolean;
    property IsUpdate: Boolean read fIsUpdate write fIsUpdate;
  published
    property TaskID: TID read fTaskID write fTaskID;
    property Files: TSQLGSFileRecs read fFiles write fFiles;
  end;

procedure InitGSFileClient(AExeName: string = '');
procedure InitGSFileClient2(ADBName: string = '');
function CreateFilesModel: TSQLModel;
procedure DestroyGSFile;

function GetGSFilesFromID(const AID: TID): TSQLGSFile;
function GetGSFiles: TSQLGSFile;
procedure AddOrUpdateGSFiles(ASQLGSFile: TSQLGSFile);
procedure DeleteGSFilesFromID(const AID: TID);

var
  g_FileDB: TSQLRestClientURI;
  FileModel: TSQLModel;

implementation

uses mORMotSQLite3, UnitFolderUtil, Forms;

procedure InitGSFileClient(AExeName: string);
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

procedure InitGSFileClient2(ADBName: string = '');
var
  LStr: string;
begin
  if Assigned(g_FileDB) then
    FreeAndNil(g_FileDB);
  if Assigned(FileModel) then
    FreeAndNil(FileModel);

  if ADBName = '' then
    ADBName := ChangeFileExt(ExtractFilePath(Application.ExeName),'.sqlite');

  LStr := GetSubFolderPath(ExtractFilePath(Application.ExeName), 'db');
  LStr := LStr + ADBName;
  FileModel:= CreateFilesModel;
  g_FileDB:= TSQLRestClientDB.Create(FileModel, CreateFilesModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_FileDB).Server.CreateMissingTables;
end;

function CreateFilesModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLGSFile]);
end;

procedure DestroyGSFile;
begin
  if Assigned(g_FileDB) then
    FreeAndNil(g_FileDB);
  if Assigned(FileModel) then
    FreeAndNil(FileModel);
end;

function GetGSFilesFromID(const AID: TID): TSQLGSFile;
begin
  Result := TSQLGSFile.CreateAndFillPrepare(g_FileDB, 'TaskID = ?', [AID]);
  Result.IsUpdate := Result.FillOne;

  if not Result.IsUpdate then
    Result.fTaskID := AID;
end;

function GetGSFiles: TSQLGSFile;
begin
  Result := TSQLGSFile.CreateAndFillPrepare(g_FileDB, 'TaskID <> ?', [-1]);
  Result.IsUpdate := Result.FillOne;
end;

procedure AddOrUpdateGSFiles(ASQLGSFile: TSQLGSFile);
begin
  if ASQLGSFile.IsUpdate then
  begin
    g_FileDB.Update(ASQLGSFile);
  end
  else
  begin
    g_FileDB.Add(ASQLGSFile, true);
//    ASQLGSFile.TaskID := ASQLGSFile.ID;
//    g_FileDB.Update(ASQLGSFile);
  end;
end;

procedure DeleteGSFilesFromID(const AID: TID);
begin
  g_FileDB.Delete(TSQLGSFile, AID);
end;

initialization

finalization
  DestroyGSFile;

end.
