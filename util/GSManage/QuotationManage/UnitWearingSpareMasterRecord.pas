unit UnitWearingSpareMasterRecord;

interface

uses
  Classes,
  SynCommons,
  mORMot;

Type
  TSQLHimsenWearingSpareMaster = class(TSQLRecord)
  private
    fMSNo, fMSDesc,
    fPartNo, fPartDesc,
    fSectionNo,
    fPlateNo,
    fDrawingNo,
    fUsedAmount,
    fSpareAmount
    : RawUTF8;

    fHRS4000Multiplyno,
    fHRS8000Multiplyno,
    fHRS12000Multiplyno,
    fHRS16000Multiplyno,
    fHRS20000Multiplyno,
    fHRS24000Multiplyno,
    fHRS28000Multiplyno,
    fHRS32000Multiplyno,
    fHRS36000Multiplyno,
    fHRS40000Multiplyno,
    fHRS44000Multiplyno,
    fHRS48000Multiplyno
    : integer;
  public
    FIsUpdate: Boolean;
    property IsUpdate: Boolean read FIsUpdate write FIsUpdate;
  published
    //ParentID = EntryID + StoreID
    property MSNo: RawUTF8 read fMSNo write fMSNo;
    property MSDesc: RawUTF8 read fMSDesc write fMSDesc;
    property PartNo: RawUTF8 read fPartNo write fPartNo;
    property PartDesc: RawUTF8 read fPartDesc write fPartDesc;
    property SectionNo: RawUTF8 read fSectionNo write fSectionNo;
    property PlateNo: RawUTF8 read fPlateNo write fPlateNo;
    property DrawingNo: RawUTF8 read fDrawingNo write fDrawingNo;
    property UsedAmount: RawUTF8 read fUsedAmount write fUsedAmount;
    property SpareAmount: RawUTF8 read fSpareAmount write fSpareAmount;

    property HRS4000Multiplyno: integer read fHRS4000Multiplyno write fHRS4000Multiplyno;
    property HRS8000Multiplyno: integer read fHRS8000Multiplyno write fHRS8000Multiplyno;
    property HRS12000Multiplyno: integer read fHRS12000Multiplyno write fHRS12000Multiplyno;
    property HRS16000Multiplyno: integer read fHRS16000Multiplyno write fHRS16000Multiplyno;
    property HRS20000Multiplyno: integer read fHRS20000Multiplyno write fHRS20000Multiplyno;
    property HRS24000Multiplyno: integer read fHRS24000Multiplyno write fHRS24000Multiplyno;
    property HRS28000Multiplyno: integer read fHRS28000Multiplyno write fHRS28000Multiplyno;
    property HRS32000Multiplyno: integer read fHRS32000Multiplyno write fHRS32000Multiplyno;
    property HRS36000Multiplyno: integer read fHRS36000Multiplyno write fHRS36000Multiplyno;
    property HRS40000Multiplyno: integer read fHRS40000Multiplyno write fHRS40000Multiplyno;
    property HRS44000Multiplyno: integer read fHRS44000Multiplyno write fHRS44000Multiplyno;
    property HRS48000Multiplyno: integer read fHRS48000Multiplyno write fHRS48000Multiplyno;
  end;

  TSQLHimsenWearingSpareRunHour = class(TSQLRecord)
  private
    fPlateNo
    : RawUTF8;

    fRunningHour,
    fMultiplyNo
    : integer;
  public
    FIsUpdate: Boolean;
    property IsUpdate: Boolean read FIsUpdate write FIsUpdate;
  published
    //ParentID = EntryID + StoreID
    property PlateNo: RawUTF8 read fPlateNo write fPlateNo;
    property RunningHour: integer read fRunningHour write fRunningHour;
    property MultiplyNo: integer read fMultiplyNo write fMultiplyNo;
  end;

  TSQLWearingSpareMany = class(TSQLRecordMany)
  private
    fSource: TSQLHimsenWearingSpareMaster;
    fDest: TSQLHimsenWearingSpareRunHour;
  published
    property Source: TSQLHimsenWearingSpareMaster read fSource;
    property Dest: TSQLHimsenWearingSpareRunHour read fDest;
  end;

procedure InitHimsenWearingSpareClient(AExeName: string);
function CreateHimsenWearingSpareMasterModel: TSQLModel;

procedure AddHimsenWaringSpareFromVariant(ADoc: variant);
procedure AddOrUpdateHimsenWaringSpareFromVariant(ADoc: variant);
procedure LoadHimsenWaringSpareFromVariant(AHimsenWaringSpare:TSQLHimsenWearingSpareMaster; ADoc: variant);

var
  g_HimsenWaringSpareDB: TSQLRestClientURI;
  HimsenWaringSpareModel: TSQLModel;

implementation

uses SysUtils, mORMotSQLite3, Forms, VarRecUtils;

procedure InitHimsenWearingSpareClient(AExeName: string);
var
  LStr: string;
begin
  LStr := ChangeFileExt(AExeName,'.sqlite');
  HimsenWaringSpareModel:= CreateHimsenWearingSpareMasterModel;
  g_HimsenWaringSpareDB:= TSQLRestClientDB.Create(HimsenWaringSpareModel, CreateHimsenWearingSpareMasterModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_HimsenWaringSpareDB).Server.CreateMissingTables;
end;

function CreateHimsenWearingSpareMasterModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLHimsenWearingSpareMaster]);
end;

procedure AddHimsenWaringSpareFromVariant(ADoc: variant);
var
  LSQLHimsenWearingSpare: TSQLHimsenWearingSpareMaster;
begin
  LSQLHimsenWearingSpare := TSQLHimsenWearingSpareMaster.Create;
  LSQLHimsenWearingSpare.IsUpdate := False;

  try
    LoadHimsenWaringSpareFromVariant(LSQLHimsenWearingSpare, ADoc);
    AddOrUpdateHimsenWaringSpareFromVariant(LSQLHimsenWearingSpare);
  finally
    FreeAndNil(LSQLHimsenWearingSpare);
  end;
end;

procedure AddOrUpdateHimsenWaringSpareFromVariant(ADoc: variant);
begin

end;

procedure LoadHimsenWaringSpareFromVariant(AHimsenWaringSpare:TSQLHimsenWearingSpareMaster; ADoc: variant);
begin
  if ADoc = null then
    exit;

  AHimsenWaringSpare.MSNo := ADoc.MSNo;
  AHimsenWaringSpare.MSDesc := ADoc.MSDesc;
  AHimsenWaringSpare.PartNo := ADoc.PartNo;
  AHimsenWaringSpare.PartDesc := ADoc.PartDesc;
  AHimsenWaringSpare.SectionNo := ADoc.SectionNo;
  AHimsenWaringSpare.PlateNo := ADoc.PlateNo;
  AHimsenWaringSpare.DrawingNo := ADoc.DrawingNo;
  AHimsenWaringSpare.UsedAmount := ADoc.UsedAmount;
  AHimsenWaringSpare.SpareAmount := ADoc.SpareAmount;
  AHimsenWaringSpare.HRS4000Multiplyno := ADoc.HRS4000Multiplyno;
  AHimsenWaringSpare.HRS8000Multiplyno := ADoc.HRS8000Multiplyno;
  AHimsenWaringSpare.HRS12000Multiplyno := ADoc.HRS12000Multiplyno;
  AHimsenWaringSpare.HRS16000Multiplyno := ADoc.HRS16000Multiplyno;
  AHimsenWaringSpare.HRS20000Multiplyno := ADoc.HRS20000Multiplyno;
  AHimsenWaringSpare.HRS24000Multiplyno := ADoc.HRS24000Multiplyno;
  AHimsenWaringSpare.HRS28000Multiplyno := ADoc.HRS28000Multiplyno;
  AHimsenWaringSpare.HRS32000Multiplyno := ADoc.HRS32000Multiplyno;
  AHimsenWaringSpare.HRS36000Multiplyno := ADoc.HRS36000Multiplyno;
  AHimsenWaringSpare.HRS40000Multiplyno := ADoc.HRS40000Multiplyno;
  AHimsenWaringSpare.HRS44000Multiplyno := ADoc.HRS44000Multiplyno;
  AHimsenWaringSpare.HRS48000Multiplyno := ADoc.HRS48000Multiplyno;
end;

initialization

finalization
  if Assigned(g_HimsenWaringSpareDB) then
    FreeAndNil(g_HimsenWaringSpareDB);

end.
