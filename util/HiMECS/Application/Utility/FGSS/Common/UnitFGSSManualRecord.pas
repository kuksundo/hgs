unit UnitFGSSManualRecord;

interface

uses
  Classes,
  SynCommons,
  mORMot;

type
  TSQLFGSSManual = class(TSQLRecord)
  private
    fManualID: TID;
    fUpdateDate: TTimeLog;
  public
    FIsUpdate: Boolean;
    property IsUpdate: Boolean read FIsUpdate write FIsUpdate;
  published
    property ManualID: TID read fManualID write fManualID;
    property UpdateDate: TTimeLog read fUpdateDate write fUpdateDate;
  end;

  TSQLFGSSManualContents = class(TSQLFGSSManual)
  private
    fSystemName,
    fTitle
    : RawUTF8;
  published
    property SystemName: RawUTF8 read fSystemName write fSystemName;
    property Title: RawUTF8 read fTitle write fTitle;
  end;

  TSQLFGSSManualContentsSpecific = class(TSQLFGSSManualContents)
  private
    fDrawingNo
    : RawUTF8;
    fNumOfPage:integer;
  published
    property SystemName: RawUTF8 read fSystemName write fSystemName;
    property Title: RawUTF8 read fTitle write fTitle;
  end;

procedure InitFGSSManualContentsClient(AFGSSManualContentsDBName: string = '');
function CreateFGSSManualContentsModel: TSQLModel;

var
  g_FGSSManualContentsDB: TSQLRestClientURI;
  FGSSManualContentsModel: TSQLModel;

implementation

uses SysUtils, mORMotSQLite3, Forms, VarRecUtils, Vcl.Dialogs, UnitStringUtil,
  UnitFolderUtil, UnitRttiUtil;

procedure InitFGSSManualContentsClient(AFGSSManualContentsDBName: string = '');
var
  LStr: string;
begin
  if AFGSSManualContentsDBName = '' then
    AFGSSManualContentsDBName := ChangeFileExt(ExtractFilePath(Application.ExeName),'.sqlite');

  LStr := GetSubFolderPath(ExtractFilePath(Application.ExeName), 'db');
  LStr := LStr + AFGSSManualContentsDBName;
  FGSSManualContentsModel:= CreateFGSSManualContentsModel;
  g_FGSSManualContentsDB:= TSQLRestClientDB.Create(FGSSManualContentsModel, CreateFGSSManualContentsModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_FGSSManualContentsDB).Server.CreateMissingTables;
end;

function CreateFGSSManualContentsModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLFGSSManualContents]);
end;

initialization

finalization
  if Assigned(FGSSManualContentsModel) then
    FreeAndNil(FGSSManualContentsModel);

  if Assigned(g_FGSSManualContentsDB) then
    FreeAndNil(g_FGSSManualContentsDB);

end.
