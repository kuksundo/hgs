unit UnitSimulateParamRecord;

interface

uses
  Classes,
  SynCommons,
{$IFDEF USE_DYNAMIC_SQLITE}
  SynSqlite3,
{$ENDIF}
  mORMot, UnitVesselData, UnitHGSCurriculumData;

const
  HGS_SIMULATE_PARAM_DB_NAME = 'HGSSimulateParameter.sqlite';

type
  TSimParamSearchRec = record
    fModelName,
    fProjectName,
    fSystemName,
    fSubSystemName,
    fSubject,
    fDesc
    : RawUTF8;
    fProductType: TShipProductType;
    fCourseLevel: TAcademyCourseLevel;
    fActivityLevel: TAcademyActivityLevel;
    fSeqNo: integer;
    fEnable: Boolean;
  end;

  TSQLSimulateParamRecord = class(TSQLRecord)
  private
    fProductType: TShipProductType;
    fCourseLevel: TAcademyCourseLevel;
    fActivityLevel: TAcademyActivityLevel;
    fModelName,
    fProjectName,
    fSystemName,
    fSubSystemName,
    fSubject,
    fDesc,
    fJsonParamCollect,
    fCSVValues,
    fDFMText,
    fFileDBPath,
    fFileDBName
    : RawUTF8;

    fSeqNo,
    fDelaySecs: integer;
    fFileCount: integer;

    fEnable: Boolean;
    fUpdateDate: TTimeLog;
  public
    FIsUpdate: Boolean;
    property IsUpdate: Boolean read FIsUpdate write FIsUpdate;
  published
    property ProductType: TShipProductType read fProductType write fProductType;
    property CourseLevel: TAcademyCourseLevel read fCourseLevel write fCourseLevel;
    property ActivityLevel: TAcademyActivityLevel read fActivityLevel write fActivityLevel;
    property ModelName: RawUTF8 read fModelName write fModelName;
    property ProjectName: RawUTF8 read fProjectName write fProjectName;
    property SystemName: RawUTF8 read fSystemName write fSystemName;
    property SubSystemName: RawUTF8 read fSubSystemName write fSubSystemName;
    property Subject: RawUTF8 read fSubject write fSubject;
    property Desc: RawUTF8 read fDesc write fDesc;
    property JsonParamCollect: RawUTF8 read fJsonParamCollect write fJsonParamCollect;
    property CSVValues: RawUTF8 read fCSVValues write fCSVValues;
    property DFMText: RawUTF8 read fDFMText write fDFMText;
    property FileDBPath: RawUTF8 read fFileDBPath write fFileDBPath;
    property FileDBName: RawUTF8 read fFileDBName write fFileDBName;
    property SeqNo: integer read fSeqNo write fSeqNo;
    property DelaySecs: integer read fDelaySecs write fDelaySecs;
    property FileCount: integer read fFileCount write fFileCount;
    property Enable: Boolean read fEnable write fEnable;
    property UpdateDate: TTimeLog read fUpdateDate write fUpdateDate;
  end;

procedure InitSimulateParamClient(ASimulateParamDBName: string = '');
function CreateSimulateParamModel: TSQLModel;
procedure DestroySimulateParam;

function GetSimulateParamRecordFromSearchRec(ASimParamSearchRec: TSimParamSearchRec): TSQLSimulateParamRecord;
function GetVariantFromSimulateParamRecord(ASQLSimulateParamRecord:TSQLSimulateParamRecord): variant;
function GetSimulateParamFromSubject(const ASubject: string; ACourseName : string = ''): TSQLSimulateParamRecord;
procedure LoadSimulateParamFromVariant(ASQLSimulateParamRecord: TSQLSimulateParamRecord; ADoc: variant);

procedure AddOrUpdateSimulateParam(ASQLSimulateParamRecord: TSQLSimulateParamRecord);
function AddOrUpdateSimulateParamFromVariant(ADoc: variant; AIsOnlyAdd: Boolean = False): integer;
procedure DeleteSimulateParam(const ASubject: string; ACourseName : string = ''); overload;
procedure DeleteSimulateParam(const ASimParamSearchRec: TSimParamSearchRec); overload;

var
  g_SimulateParamDB: TSQLRestClientURI;
  SimulateParamModel: TSQLModel;

implementation

uses SysUtils, mORMotSQLite3, Forms, VarRecUtils, Vcl.Dialogs, UnitStringUtil,
  UnitFolderUtil, UnitRttiUtil;

procedure InitSimulateParamClient(ASimulateParamDBName: string = '');
var
  LStr: string;
begin
  if ASimulateParamDBName = '' then
    ASimulateParamDBName := ChangeFileExt(ExtractFilePath(Application.ExeName),'.sqlite');

  LStr := GetSubFolderPath(ExtractFilePath(Application.ExeName), 'db');
  LStr := LStr + ASimulateParamDBName;
  SimulateParamModel:= CreateSimulateParamModel;
  g_SimulateParamDB:= TSQLRestClientDB.Create(SimulateParamModel, CreateSimulateParamModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_SimulateParamDB).Server.CreateMissingTables;
end;

function CreateSimulateParamModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLSimulateParamRecord]);
end;

procedure DestroySimulateParam;
begin
  if Assigned(SimulateParamModel) then
    FreeAndNil(SimulateParamModel);

  if Assigned(g_SimulateParamDB) then
    FreeAndNil(g_SimulateParamDB);
end;

function GetSimulateParamRecordFromSearchRec(
  ASimParamSearchRec: TSimParamSearchRec): TSQLSimulateParamRecord;
var
  ConstArray: TConstArray;
  LWhere, LStr: string;
  LFrom, LTo: TTimeLog;
begin
  LWhere := '';
  ConstArray := CreateConstArray([]);
  try
    if ASimParamSearchRec.fProductType <> shptNull then
    begin
      AddConstArray(ConstArray, [Ord(ASimParamSearchRec.fProductType)]);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'ProductType = ? ';
    end;

    if ASimParamSearchRec.fEnable then
    begin
      AddConstArray(ConstArray, [ASimParamSearchRec.fEnable]);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'ModelName = ? ';
    end;

    if ASimParamSearchRec.fModelName <> '' then
    begin
      AddConstArray(ConstArray, [ASimParamSearchRec.fModelName+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'ModelName LIKE ? ';
    end;

    if ASimParamSearchRec.fProjectName <> '' then
    begin
      AddConstArray(ConstArray, ['%'+ASimParamSearchRec.fProjectName+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'ProjectName LIKE ? ';
    end;

    if ASimParamSearchRec.fSystemName <> '' then
    begin
      AddConstArray(ConstArray, [ASimParamSearchRec.fSystemName+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'SystemName LIKE ? ';
    end;

    if ASimParamSearchRec.fSubSystemName <> '' then
    begin
      AddConstArray(ConstArray, [ASimParamSearchRec.fSubSystemName+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'SubSystemName LIKE ? ';
    end;

    if ASimParamSearchRec.fSubject <> '' then
    begin
      AddConstArray(ConstArray, ['%'+ASimParamSearchRec.fSubject+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'Subject LIKE ? ';
    end;

    if ASimParamSearchRec.fDesc <> '' then
    begin
      AddConstArray(ConstArray, ['%'+ASimParamSearchRec.fDesc+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'Desc LIKE ? ';
    end;

    if ASimParamSearchRec.fSeqNo <> 0 then
    begin
      AddConstArray(ConstArray, [Ord(ASimParamSearchRec.fSeqNo)]);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'SeqNo = ? ';
    end;

    if ASimParamSearchRec.fCourseLevel <> aclNull then
    begin
      AddConstArray(ConstArray, [Ord(ASimParamSearchRec.fCourseLevel)]);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'CourseLevel = ? ';
    end;

    if ASimParamSearchRec.fActivityLevel <> aalNull then
    begin
      AddConstArray(ConstArray, [Ord(ASimParamSearchRec.fActivityLevel)]);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'ActivityLevel = ? ';
    end;

    if LWhere = '' then
    begin
      AddConstArray(ConstArray, [-1]);
      LWhere := 'ID <> ? ';
    end;

    Result := TSQLSimulateParamRecord.CreateAndFillPrepare(g_SimulateParamDB, Lwhere, ConstArray);

    if Result.FillOne then
    begin
//      Result.FillRewind;
      Result.IsUpdate := True;
    end;
  finally
    FinalizeConstArray(ConstArray);
  end;
end;

function GetVariantFromSimulateParamRecord(ASQLSimulateParamRecord:TSQLSimulateParamRecord): variant;
begin
  TDocVariant.New(Result);
  LoadRecordPropertyToVariant(ASQLSimulateParamRecord, Result);
end;

function GetSimulateParamFromSubject(const ASubject: string; ACourseName : string = ''): TSQLSimulateParamRecord;
var
  LCurriculumRec: TSimParamSearchRec;
begin
  LCurriculumRec := Default(TSimParamSearchRec);
  LCurriculumRec.fSubject := ASubject;
//  LCurriculumRec.fCourseName := ACourseName;

  Result := GetSimulateParamRecordFromSearchRec(LCurriculumRec);
end;

procedure LoadSimulateParamFromVariant(ASQLSimulateParamRecord: TSQLSimulateParamRecord; ADoc: variant);
begin
  if ADoc = null then
    exit;

  LoadRecordPropertyFromVariant(ASQLSimulateParamRecord, ADoc);
end;

procedure AddOrUpdateSimulateParam(ASQLSimulateParamRecord: TSQLSimulateParamRecord);
begin
  if ASQLSimulateParamRecord.IsUpdate then
  begin
    g_SimulateParamDB.Update(ASQLSimulateParamRecord);
  end
  else
  begin
    g_SimulateParamDB.Add(ASQLSimulateParamRecord, true);
  end;
end;

function AddOrUpdateSimulateParamFromVariant(ADoc: variant; AIsOnlyAdd: Boolean = False): integer;
var
  LSQLSimulateParamRecord: TSQLSimulateParamRecord;
  LIsUpdate: Boolean;
  LSimParamSearchRec: TSimParamSearchRec;
begin
  LSimParamSearchRec := Default(TSimParamSearchRec);
  //Enumeration Type은 Type Name으로 저장됨
  LSimParamSearchRec.fProductType := g_ShipProductType.ToTypeFromEnumString(ADoc.ProductType);
  LSimParamSearchRec.fCourseLevel := g_AcademyCourseLevelDesc.ToTypeFromEnumString(ADoc.CourseLevel);
  LSimParamSearchRec.fActivityLevel := g_AcademyActivityLevelDesc.ToTypeFromEnumString(ADoc.ActivityLevel);
  LSimParamSearchRec.fModelName := ADoc.ModelName;
  LSimParamSearchRec.fProjectName := ADoc.ProjectName;
  LSimParamSearchRec.fSystemName := ADoc.SystemName;
  LSimParamSearchRec.fSubSystemName := ADoc.SubSystemName;
  LSimParamSearchRec.fSubject := ADoc.Subject;
  LSimParamSearchRec.fSeqNo := ADoc.SeqNo;

  LSQLSimulateParamRecord := GetSimulateParamRecordFromSearchRec(LSimParamSearchRec);
  LIsUpdate := LSQLSimulateParamRecord.IsUpdate;
  try
    if AIsOnlyAdd then
    begin
      if not LSQLSimulateParamRecord.IsUpdate then
      begin
        LoadSimulateParamFromVariant(LSQLSimulateParamRecord, ADoc);
        LSQLSimulateParamRecord.IsUpdate := LIsUpdate;

        AddOrUpdateSimulateParam(LSQLSimulateParamRecord);
        Inc(Result);
      end;
    end
    else
    begin
      if LSQLSimulateParamRecord.IsUpdate then
        Inc(Result);

      LoadSimulateParamFromVariant(LSQLSimulateParamRecord, ADoc);
      LSQLSimulateParamRecord.IsUpdate := LIsUpdate;

      AddOrUpdateSimulateParam(LSQLSimulateParamRecord);
    end;
  finally
    FreeAndNil(LSQLSimulateParamRecord);
  end;
end;

procedure DeleteSimulateParam(const ASubject: string; ACourseName : string = '');overload;
var
  LSimulateParamRecord: TSQLSimulateParamRecord;
begin
  LSimulateParamRecord := GetSimulateParamFromSubject(ASubject, ACourseName);
  try
    if LSimulateParamRecord.IsUpdate then
      g_SimulateParamDB.Delete(TSQLSimulateParamRecord, LSimulateParamRecord.ID);
  finally
    LSimulateParamRecord.Free;
  end;
end;

procedure DeleteSimulateParam(const ASimParamSearchRec: TSimParamSearchRec); overload;
var
  LSimulateParamRecord: TSQLSimulateParamRecord;
begin
  LSimulateParamRecord := GetSimulateParamRecordFromSearchRec(ASimParamSearchRec);
  try
    if LSimulateParamRecord.IsUpdate then
    begin
      LSimulateParamRecord.FillRewind;

      while LSimulateParamRecord.FillOne do
        g_SimulateParamDB.Delete(TSQLSimulateParamRecord, LSimulateParamRecord.ID);
    end;
  finally
    LSimulateParamRecord.Free;
  end;
end;

initialization
{$IFDEF USE_DYNAMIC_SQLITE}
  FreeAndNil(sqlite3);
  sqlite3 := TSQLite3LibraryDynamic.Create();
{$ENDIF}

finalization
{$IFDEF USE_DYNAMIC_SQLITE}
  FreeAndNil(sqlite3);
{$ENDIF}
  DestroySimulateParam;

end.
