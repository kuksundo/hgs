unit UnitHGSCertRecord;

interface

uses
  Classes,
  SynCommons,
  mORMot, UnitVesselData, UnitHGSCertData, UnitHGSCurriculumData;

type
  TCertSearchParamRec = record
    fCertNo,
    fTraineeName,
    fCompanyName,
    fTrainedSubject,
    fTrainedCourse,
    fCourseLevel
    : RawUTF8;
    fProductType: TShipProductType;
    fCertType: THGSCertType;
    FFrom, FTo: TDateTime;
    fQueryDate: TCertQueryDateType;

    fReportNo,
    fPlaceOfSurvey,
    fVDRSerialNo,
    fVDRType,
    fClassSociety,
    fOwnerName,
    fShipName,
    fHullNo,
    fIMONo,
    fPICEmail,
    fPICPhone
    : RawUTF8;
    fAPTServiceDate
    : TTimeLog;
  end;

  TSQLHGSCertBasic = class(TSQLRecord)
  private
    fCertNo,
    fPrevCertNo,
    fCompanyName,
    fCompanyCode,
    fCompanyNatoin,
    fOrderNo,
    fSalesAmount,
    fCertFileDBPath,
    fCertFileDBName
    : RawUTF8;

    fFileCount: integer;
    fQRCodeImage: TSQLRawBlob;//Cert 정보를 암호화 하여 저장함
    fIsCryptSerial: Boolean; //시리얼 번호 암호화 여부
    fProductType: TShipProductType;
    fCertType: THGSCertType;

    fUntilValidity,
    fIssueDate,
    fUpdateDate: TTimeLog;
  public
    FIsUpdate: Boolean;
    fNextSerialNo: RawUTF8;
    property IsUpdate: Boolean read FIsUpdate write FIsUpdate;
    property NextSerialNo: RawUTF8 read fNextSerialNo write fNextSerialNo;
  published
    property CertNo: RawUTF8 read fCertNo write fCertNo;
    property PrevCertNo: RawUTF8 read fPrevCertNo write fPrevCertNo;

    property CompanyName: RawUTF8 read fCompanyName write fCompanyName;
    property CompanyCode: RawUTF8 read fCompanyCode write fCompanyCode;
    property CompanyNatoin: RawUTF8 read fCompanyNatoin write fCompanyNatoin;
    property OrderNo: RawUTF8 read fOrderNo write fOrderNo;
    property SalesAmount: RawUTF8 read fSalesAmount write fSalesAmount;
    property CertFileDBPath: RawUTF8 read fCertFileDBPath write fCertFileDBPath;
    property CertFileDBName: RawUTF8 read fCertFileDBName write fCertFileDBName;
    property IsCryptSerial: Boolean read fIsCryptSerial write fIsCryptSerial;
    property ProductType: TShipProductType read fProductType write fProductType;
    property CertType: THGSCertType read fCertType write fCertType;
    property UntilValidity: TTimeLog read fUntilValidity write fUntilValidity;
    property IssueDate: TTimeLog read fIssueDate write fIssueDate;
    property UpdateDate: TTimeLog read fUpdateDate write fUpdateDate;
    property QRCodeImage: TSQLRawBlob read fQRCodeImage write fQRCodeImage;
    property FileCount: integer read fFileCount write fFileCount;
  end;

  TSQLHGSCertRecord = class(TSQLHGSCertBasic)
  private
    //Education
    fTraineeName,
    fTrainedSubject,
    fTrainedCourse
    : RawUTF8;
    fCourseLevel: TAcademyCourseLevel;
    fTrainedBeginDate,
    fTrainedEndDate
    :TTimeLog;

    //APT Service
    fReportNo,
    fPlaceOfSurvey,
    fVDRType,
    fVDRSerialNo,
    fClassSociety,
    fOwnerName,
    fShipName,
    fIMONo,
    fHullNo,
    fPICEmail,
    fPICPhone
    : RawUTF8;
    fAPTServiceDate
    : TTimeLog;
  published
    property TraineeName: RawUTF8 read fTraineeName write fTraineeName;
    property TrainedSubject: RawUTF8 read fTrainedSubject write fTrainedSubject;
    property TrainedCourse: RawUTF8 read fTrainedCourse write fTrainedCourse;
    property CourseLevel: TAcademyCourseLevel read fCourseLevel write fCourseLevel;
    property TrainedBeginDate: TTimeLog read fTrainedBeginDate write fTrainedBeginDate;
    property TrainedEndDate: TTimeLog read fTrainedEndDate write fTrainedEndDate;

    property ReportNo: RawUTF8 read fReportNo write fReportNo;
    property PlaceOfSurvey: RawUTF8 read fPlaceOfSurvey write fPlaceOfSurvey;
    property VDRType: RawUTF8 read fVDRType write fVDRType;
    property VDRSerialNo: RawUTF8 read fVDRSerialNo write fVDRSerialNo;
    property ClassSociety: RawUTF8 read fClassSociety write fClassSociety;
    property OwnerName: RawUTF8 read fOwnerName write fOwnerName;
    property ShipName: RawUTF8 read fShipName write fShipName;
    property IMONo: RawUTF8 read fIMONo write fIMONo;
    property HullNo: RawUTF8 read fHullNo write fHullNo;
    property PICEmail: RawUTF8 read fPICEmail write fPICEmail;
    property PICPhone: RawUTF8 read fPICPhone write fPICPhone;
    property APTServiceDate: TTimeLog read fAPTServiceDate write fAPTServiceDate;
  end;

procedure InitHGSCertClient(AHGSCertDBName: string = '');
function CreateHGSCertModel: TSQLModel;
procedure DestroyHGSCertClient;

function GetDefaultDBName(const ACertNo: string): string;
function GetHGSCertFromCertNo(const ACertNo: string): TSQLHGSCertRecord;
function GetHGSCertFromReportNo(const AReportNo: string): TSQLHGSCertRecord;
function GetHGSCertFromIMONo(const AIMONo: string): TSQLHGSCertRecord;
function GetHGSCertFromHullNo(const AHullNo: string): TSQLHGSCertRecord;
function GetHGSCertFromShipName(const AShipName: string): TSQLHGSCertRecord;
function GetHGSCertFromPlaceOfSurvey(const APlaceOfSurvey: string): TSQLHGSCertRecord;
function GetVariantFromHGSCertRecord(AHGSCertRecord:TSQLHGSCertRecord): variant;
function GetHGSCertRecordFromSearchRec(ACertSearchParamRec: TCertSearchParamRec): TSQLHGSCertRecord;
function CheckIfExistHGSCertNo(const ACertNo: string): Boolean;

procedure AddOrUpdateHGSCert(ASQLHGSCertRecord: TSQLHGSCertRecord);
function AddOrUpdateHGSCertFromVariant(ADoc: variant; AIsOnlyAdd: Boolean = False): integer;
procedure LoadHGSCertFromVariant(ASQLHGSCertRecord: TSQLHGSCertRecord; ADoc: variant);

procedure DeleteHGSCert(const ACertNo: string);

var
  g_HGSCertDB: TSQLRestClientURI;
  HGSCertModel: TSQLModel;

implementation

uses SysUtils, mORMotSQLite3, Forms, VarRecUtils, Vcl.Dialogs, UnitStringUtil,
  UnitFolderUtil, UnitRttiUtil, DateUtils, UnitGSCommonUtil;

procedure InitHGSCertClient(AHGSCertDBName: string = '');
var
  LStr: string;
begin
  if AHGSCertDBName = '' then
    AHGSCertDBName := ChangeFileExt(ExtractFilePath(Application.ExeName),'.sqlite');

  LStr := GetDefaultDBPath;
  LStr := LStr + AHGSCertDBName;
  HGSCertModel:= CreateHGSCertModel;
  g_HGSCertDB:= TSQLRestClientDB.Create(HGSCertModel, CreateHGSCertModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_HGSCertDB).Server.CreateMissingTables;
end;

function CreateHGSCertModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLHGSCertRecord]);
end;

procedure DestroyHGSCertClient;
begin
  if Assigned(HGSCertModel) then
    FreeAndNil(HGSCertModel);

  if Assigned(g_HGSCertDB) then
    FreeAndNil(g_HGSCertDB);
end;

function GetDefaultDBName(const ACertNo: string): string;
begin
  if ACertNo <> '' then
  begin
    Result := StringReplace(ACertNo, '-', '_', [rfReplaceAll, rfIgnoreCase]);
    Result := StringReplace(Result, ' ', '', [rfReplaceAll, rfIgnoreCase]) + '.sqlite';
  end;
end;

function GetHGSCertFromCertNo(const ACertNo: string): TSQLHGSCertRecord;
begin
  if ACertNo = '' then
  begin
    Result := TSQLHGSCertRecord.Create;
    Result.IsUpdate := False;
  end
  else
  begin
    Result := TSQLHGSCertRecord.CreateAndFillPrepare(g_HGSCertDB,
      'CertNo LIKE ?', ['%'+ACertNo+'%']);

    if Result.FillOne then
      Result.IsUpdate := True
    else
      Result.IsUpdate := False;
  end;
end;

function GetHGSCertFromReportNo(const AReportNo: string): TSQLHGSCertRecord;
var
  LCertSearchRec: TCertSearchParamRec;
begin
  LCertSearchRec := Default(TCertSearchParamRec);
  LCertSearchRec.fReportNo := AReportNo;

  Result := GetHGSCertRecordFromSearchRec(LCertSearchRec);
end;

function GetHGSCertFromIMONo(const AIMONo: string): TSQLHGSCertRecord;
var
  LCertSearchRec: TCertSearchParamRec;
begin
  LCertSearchRec := Default(TCertSearchParamRec);
  LCertSearchRec.fIMONo := AIMONo;

  Result := GetHGSCertRecordFromSearchRec(LCertSearchRec);
end;

function GetHGSCertFromHullNo(const AHullNo: string): TSQLHGSCertRecord;
var
  LCertSearchRec: TCertSearchParamRec;
begin
  LCertSearchRec := Default(TCertSearchParamRec);
  LCertSearchRec.fHullNo := AHullNo;

  Result := GetHGSCertRecordFromSearchRec(LCertSearchRec);
end;

function GetHGSCertFromShipName(const AShipName: string): TSQLHGSCertRecord;
var
  LCertSearchRec: TCertSearchParamRec;
begin
  LCertSearchRec := Default(TCertSearchParamRec);
  LCertSearchRec.fShipName := AShipName;

  Result := GetHGSCertRecordFromSearchRec(LCertSearchRec);
end;

function GetHGSCertFromPlaceOfSurvey(const APlaceOfSurvey: string): TSQLHGSCertRecord;
var
  LCertSearchRec: TCertSearchParamRec;
begin
  LCertSearchRec := Default(TCertSearchParamRec);
  LCertSearchRec.fPlaceOfSurvey := APlaceOfSurvey;

  Result := GetHGSCertRecordFromSearchRec(LCertSearchRec);
end;

function CheckIfExistHGSCertNo(const ACertNo: string): Boolean;
var
  LCertSearchRec: TCertSearchParamRec;
  LSQLHGSCertRecord: TSQLHGSCertRecord;
begin
  LCertSearchRec := Default(TCertSearchParamRec);
  LCertSearchRec.fCertNo := ACertNo;
  LSQLHGSCertRecord := GetHGSCertRecordFromSearchRec(LCertSearchRec);

  try
    Result := LSQLHGSCertRecord.IsUpdate;
  finally
    LSQLHGSCertRecord.Free;
  end;
end;

function GetVariantFromHGSCertRecord(AHGSCertRecord:TSQLHGSCertRecord): variant;
begin
  TDocVariant.New(Result);
  LoadRecordPropertyToVariant(AHGSCertRecord, Result);
end;

function GetHGSCertRecordFromSearchRec(ACertSearchParamRec: TCertSearchParamRec): TSQLHGSCertRecord;
var
  ConstArray: TConstArray;
  LWhere, LStr: string;
  LFrom, LTo: TTimeLog;
begin
  LWhere := '';
  ConstArray := CreateConstArray([]);
  try
    if ACertSearchParamRec.fQueryDate <> cqdtNull then
    begin
      if ACertSearchParamRec.FFrom <= ACertSearchParamRec.FTo then
      begin
        LFrom := TimeLogFromDateTime(ACertSearchParamRec.FFrom);
        LTo := TimeLogFromDateTime(ACertSearchParamRec.FTo);

        if ACertSearchParamRec.FQueryDate <> cqdtNull then
        begin
          case ACertSearchParamRec.FQueryDate of
            cqdtTrainedPeriod: LWhere := 'TrainedBeginDate >= ? and TrainedEndDate <= ? ';
            cqdtValidityUntilDate: LWhere := 'UntilValidity = ?  ';
            cqdtCertIssueDate: LWhere := 'IssueDate = ?  ';
            cqdtAPTServiceDate: LWhere := 'APTServiceDate = ?  ';
          end;

          if LWhere <> '' then
            AddConstArray(ConstArray, [LFrom, LTo]);
        end;
      end;
    end;

    if ACertSearchParamRec.fCertNo <> '' then
    begin
      AddConstArray(ConstArray, ['%'+ACertSearchParamRec.fCertNo+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'CertNo LIKE ? ';
    end;

    if ACertSearchParamRec.fTraineeName <> '' then
    begin
      AddConstArray(ConstArray, ['%'+ACertSearchParamRec.fTraineeName+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'TraineeName LIKE ? ';
    end;

    if ACertSearchParamRec.fCompanyName <> '' then
    begin
      AddConstArray(ConstArray, ['%'+ACertSearchParamRec.fCompanyName+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'CompanyName LIKE ? ';
    end;

    if ACertSearchParamRec.fTrainedSubject <> '' then
    begin
      AddConstArray(ConstArray, ['%'+ACertSearchParamRec.fTrainedSubject+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'TrainedSubject LIKE ? ';
    end;

    if ACertSearchParamRec.fTrainedCourse <> '' then
    begin
      AddConstArray(ConstArray, ['%'+ACertSearchParamRec.fTrainedCourse+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'TrainedCourse LIKE ? ';
    end;

    if ACertSearchParamRec.fReportNo <> '' then
    begin
      AddConstArray(ConstArray, ['%'+ACertSearchParamRec.fReportNo+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'ReportNo LIKE ? ';
    end;

    if ACertSearchParamRec.fPlaceOfSurvey <> '' then
    begin
      AddConstArray(ConstArray, ['%'+ACertSearchParamRec.fPlaceOfSurvey+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'PlaceOfSurvey LIKE ? ';
    end;

    if ACertSearchParamRec.fVDRSerialNo <> '' then
    begin
      AddConstArray(ConstArray, ['%'+ACertSearchParamRec.fVDRSerialNo+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'VDRSerialNo LIKE ? ';
    end;

    if ACertSearchParamRec.fClassSociety <> '' then
    begin
      AddConstArray(ConstArray, ['%'+ACertSearchParamRec.fClassSociety+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'ClassSociety LIKE ? ';
    end;

    if ACertSearchParamRec.fOwnerName <> '' then
    begin
      AddConstArray(ConstArray, ['%'+ACertSearchParamRec.fOwnerName+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'OwnerName LIKE ? ';
    end;

    if ACertSearchParamRec.fShipName <> '' then
    begin
      AddConstArray(ConstArray, ['%'+ACertSearchParamRec.fShipName+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'ShipName LIKE ? ';
    end;

    if ACertSearchParamRec.fHullNo <> '' then
    begin
      AddConstArray(ConstArray, ['%'+ACertSearchParamRec.fHullNo+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'HullNo LIKE ? ';
    end;

    if ACertSearchParamRec.fIMONo <> '' then
    begin
      AddConstArray(ConstArray, ['%'+ACertSearchParamRec.fIMONo+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'IMONo LIKE ? ';
    end;

    if ACertSearchParamRec.fPICEmail <> '' then
    begin
      AddConstArray(ConstArray, ['%'+ACertSearchParamRec.fPICEmail+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'PICEmail LIKE ? ';
    end;

    if ACertSearchParamRec.fPICPhone <> '' then
    begin
      AddConstArray(ConstArray, ['%'+ACertSearchParamRec.fPICPhone+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'PICPhone LIKE ? ';
    end;

    if ACertSearchParamRec.fProductType <> shptNull then
    begin
      AddConstArray(ConstArray, [Ord(ACertSearchParamRec.fProductType)]);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'ProductType = ? ';
    end;

    if ACertSearchParamRec.fCertType <> hctNull then
    begin
      AddConstArray(ConstArray, [Ord(ACertSearchParamRec.fCertType)]);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'CertType = ? ';
    end;

    if LWhere = '' then
    begin
      AddConstArray(ConstArray, [-1]);
      LWhere := 'ID <> ? ';
    end;

    Result := TSQLHGSCertRecord.CreateAndFillPrepare(g_HGSCertDB, Lwhere, ConstArray);

    if Result.FillOne then
    begin
//      Result.FillRewind;
      Result.IsUpdate := True;
    end
    else
    begin
      Result := TSQLHGSCertRecord.Create;
      Result.IsUpdate := False;
    end
  finally
    FinalizeConstArray(ConstArray);
  end;
end;

procedure LoadHGSCertFromVariant(ASQLHGSCertRecord: TSQLHGSCertRecord; ADoc: variant);
begin
  if ADoc = null then
    exit;

  LoadRecordPropertyFromVariant(ASQLHGSCertRecord, ADoc);
end;

procedure DeleteHGSCert(const ACertNo: string);
var
  LSQLHGSCertRecord: TSQLHGSCertRecord;
begin
  LSQLHGSCertRecord := GetHGSCertFromCertNo(ACertNo);
  try
    if LSQLHGSCertRecord.IsUpdate then
      g_HGSCertDB.Delete(TSQLHGSCertRecord, LSQLHGSCertRecord.ID);
  finally
    LSQLHGSCertRecord.Free;
  end;
end;

procedure AddOrUpdateHGSCert(ASQLHGSCertRecord: TSQLHGSCertRecord);
begin
  if ASQLHGSCertRecord.IsUpdate then
  begin
    g_HGSCertDB.Update(ASQLHGSCertRecord);
  end
  else
  begin
    g_HGSCertDB.Add(ASQLHGSCertRecord, true);
  end;
end;

function AddOrUpdateHGSCertFromVariant(ADoc: variant; AIsOnlyAdd: Boolean = False): integer;
var
  LSQLHGSCertRecord: TSQLHGSCertRecord;
  LIsUpdate: Boolean;
begin
  LSQLHGSCertRecord := GetHGSCertFromCertNo(ADoc.CertNo);
  LIsUpdate := LSQLHGSCertRecord.IsUpdate;
  try
    if AIsOnlyAdd then
    begin
      if not LSQLHGSCertRecord.IsUpdate then
      begin
        LoadHGSCertFromVariant(LSQLHGSCertRecord, ADoc);
        LSQLHGSCertRecord.IsUpdate := LIsUpdate;

        AddOrUpdateHGSCert(LSQLHGSCertRecord);
        Inc(Result);
      end;
    end
    else
    begin
      if LSQLHGSCertRecord.IsUpdate then
        Inc(Result);

      LoadHGSCertFromVariant(LSQLHGSCertRecord, ADoc);
      LSQLHGSCertRecord.IsUpdate := LIsUpdate;

      AddOrUpdateHGSCert(LSQLHGSCertRecord);
    end;
  finally
    FreeAndNil(LSQLHGSCertRecord);
  end;
end;

initialization

finalization
  DestroyHGSCertClient;

end.
