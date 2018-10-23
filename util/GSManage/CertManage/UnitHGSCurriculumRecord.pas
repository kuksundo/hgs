unit UnitHGSCurriculumRecord;

interface

uses
  Classes,
  SynCommons,
  mORMot, UnitHGSCurriculumData, UnitVesselData;

type
  TCurriculumSearchParamRec = record
    fSubject,
    fCourseName
    : RawUTF8;
    fCourseLevel: TAcademyCourseLevel;
    fActivityLevel: TAcademyActivityLevel;
    fProductType: TShipProductType;
  end;

  TSQLHGSCurriculumRecord = class(TSQLRecord)
  private
    fProductType: TShipProductType;
    fSubject,
    fCourseName,
    fTargetGroup,
    fContents,
    fCourseFileDBPath,
    fCourseFileDBName
    : RawUTF8;

    fCourseLevel: TAcademyCourseLevel;
    fActivityLevel: TAcademyActivityLevel;
    fTrainDays: integer;
    fFileCount: integer;
    fTheoretical,
    fPractical: Boolean;
    fUpdateDate: TTimeLog;
  public
    FIsUpdate: Boolean;
    property IsUpdate: Boolean read FIsUpdate write FIsUpdate;
  published
    property ProductType: TShipProductType read fProductType write fProductType;
    property TargetGroup: RawUTF8 read fTargetGroup write fTargetGroup;
    property Subject: RawUTF8 read fSubject write fSubject;
    property CourseName: RawUTF8 read fCourseName write fCourseName;
    property Contents: RawUTF8 read fContents write fContents;
    property CourseFileDBPath: RawUTF8 read fCourseFileDBPath write fCourseFileDBPath;
    property CourseFileDBName: RawUTF8 read fCourseFileDBName write fCourseFileDBName;
    property CourseLevel: TAcademyCourseLevel read fCourseLevel write fCourseLevel;
    property ActivityLevel: TAcademyActivityLevel read fActivityLevel write fActivityLevel;
    property TrainDays: integer read fTrainDays write fTrainDays;
    property FileCount: integer read fFileCount write fFileCount;
    property Theoretical: Boolean read fTheoretical write fTheoretical;
    property Practical: Boolean read fPractical write fPractical;
    property UpdateDate: TTimeLog read fUpdateDate write fUpdateDate;
  end;

procedure InitHGSCurriculumClient(AHGSCertCurriculumDBName: string = '');
function CreateHGSCurriculumModel: TSQLModel;
procedure DestroyHGSCurriculum;

function GetHGSCurriculumRecordFromSearchRec(ACurriculumSearchParamRec: TCurriculumSearchParamRec): TSQLHGSCurriculumRecord;
function GetVariantFromHGSCurriculumRecord(ASQLHGSCurriculumRecord:TSQLHGSCurriculumRecord): variant;
function GetHGSCurriculumFromSubject(const ASubject: string; ACourseName : string = ''): TSQLHGSCurriculumRecord;

procedure AddOrUpdateHGSCurriculum(ASQLHGSCurriculumRecord: TSQLHGSCurriculumRecord);
procedure DeleteHGSCurriculum(const ASubject: string; ACourseName : string = '');

var
  g_HGSCurriculumDB: TSQLRestClientURI;
  HGSCurriculumModel: TSQLModel;

implementation

uses SysUtils, mORMotSQLite3, Forms, VarRecUtils, Vcl.Dialogs, UnitStringUtil,
  UnitFolderUtil, UnitRttiUtil;

procedure InitHGSCurriculumClient(AHGSCertCurriculumDBName: string = '');
var
  LStr: string;
begin
  if AHGSCertCurriculumDBName = '' then
    AHGSCertCurriculumDBName := ChangeFileExt(ExtractFilePath(Application.ExeName),'.sqlite');

  LStr := GetSubFolderPath(ExtractFilePath(Application.ExeName), 'db');
  LStr := LStr + AHGSCertCurriculumDBName;
  HGSCurriculumModel:= CreateHGSCurriculumModel;
  g_HGSCurriculumDB:= TSQLRestClientDB.Create(HGSCurriculumModel, CreateHGSCurriculumModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_HGSCurriculumDB).Server.CreateMissingTables;
end;

function CreateHGSCurriculumModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLHGSCurriculumRecord]);
end;

procedure DestroyHGSCurriculum;
begin
  if Assigned(HGSCurriculumModel) then
    FreeAndNil(HGSCurriculumModel);

  if Assigned(g_HGSCurriculumDB) then
    FreeAndNil(g_HGSCurriculumDB);
end;

function GetHGSCurriculumRecordFromSearchRec(
  ACurriculumSearchParamRec: TCurriculumSearchParamRec): TSQLHGSCurriculumRecord;
var
  ConstArray: TConstArray;
  LWhere, LStr: string;
  LFrom, LTo: TTimeLog;
begin
  LWhere := '';
  ConstArray := CreateConstArray([]);
  try
    if ACurriculumSearchParamRec.fProductType <> shptNull then
    begin
      AddConstArray(ConstArray, [Ord(ACurriculumSearchParamRec.fProductType)]);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'ProductType = ? ';
    end;

    if ACurriculumSearchParamRec.fSubject <> '' then
    begin
      AddConstArray(ConstArray, ['%'+ACurriculumSearchParamRec.fSubject+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'Subject LIKE ? ';
    end;

    if ACurriculumSearchParamRec.fCourseName <> '' then
    begin
      AddConstArray(ConstArray, ['%'+ACurriculumSearchParamRec.fCourseName+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'CourseName LIKE ? ';
    end;

    if ACurriculumSearchParamRec.fCourseLevel <> aclNull then
    begin
      AddConstArray(ConstArray, [Ord(ACurriculumSearchParamRec.fCourseLevel)]);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'TrainedSubject = ? ';
    end;

    if ACurriculumSearchParamRec.fActivityLevel <> aalNull then
    begin
      AddConstArray(ConstArray, [Ord(ACurriculumSearchParamRec.fActivityLevel)]);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'ActivityLevel = ? ';
    end;

    if LWhere = '' then
    begin
      AddConstArray(ConstArray, [-1]);
      LWhere := 'ID <> ? ';
    end;

    Result := TSQLHGSCurriculumRecord.CreateAndFillPrepare(g_HGSCurriculumDB, Lwhere, ConstArray);

    if Result.FillOne then
    begin
//      Result.FillRewind;
      Result.IsUpdate := True;
    end;
  finally
    FinalizeConstArray(ConstArray);
  end;
end;

function GetVariantFromHGSCurriculumRecord(ASQLHGSCurriculumRecord:TSQLHGSCurriculumRecord): variant;
begin
  TDocVariant.New(Result);
  LoadRecordPropertyToVariant(ASQLHGSCurriculumRecord, Result);
end;

function GetHGSCurriculumFromSubject(const ASubject: string; ACourseName : string = ''): TSQLHGSCurriculumRecord;
var
  LCurriculumRec: TCurriculumSearchParamRec;
begin
  LCurriculumRec := Default(TCurriculumSearchParamRec);
  LCurriculumRec.fSubject := ASubject;
  LCurriculumRec.fCourseName := ACourseName;

  Result := GetHGSCurriculumRecordFromSearchRec(LCurriculumRec);
end;

procedure AddOrUpdateHGSCurriculum(ASQLHGSCurriculumRecord: TSQLHGSCurriculumRecord);
begin
  if ASQLHGSCurriculumRecord.IsUpdate then
  begin
    g_HGSCurriculumDB.Update(ASQLHGSCurriculumRecord);
  end
  else
  begin
    g_HGSCurriculumDB.Add(ASQLHGSCurriculumRecord, true);
  end;
end;

procedure DeleteHGSCurriculum(const ASubject: string; ACourseName : string = '');
var
  LCurriculumRecord: TSQLHGSCurriculumRecord;
begin
  LCurriculumRecord := GetHGSCurriculumFromSubject(ASubject, ACourseName);
  try
    if LCurriculumRecord.IsUpdate then
      g_HGSCurriculumDB.Delete(TSQLHGSCurriculumRecord, LCurriculumRecord.ID);
  finally
    LCurriculumRecord.Free;
  end;
end;

initialization

finalization
  DestroyHGSCurriculum;

end.
