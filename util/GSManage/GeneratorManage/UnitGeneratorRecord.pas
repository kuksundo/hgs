unit UnitGeneratorRecord;

interface

uses
  Classes,
  SynCommons,
  mORMot,
  CommonData,
  UnitVesselMasterRecord, UnitGSFileRecord, UnitRttiUtil;

type
  TSQLGeneratorRecord = class(TSQLVesselBase)
  private
    fProjectNo,
    fProjectName,
    fModelNo,
    fSpecDesc,
    fSerialNo,
    fGenUse,
    fEnclosureType,
    fCoolingSystem,
    fExcitingSystem,
    fStructureOfRotor,
    fCouplingMethod,
    fQuantyPerShip,
    fClassSociety,
    fAmbientTemp,
    fInsulationClass,
    fTemperatureRise,
    fAppliedUnit,
    //Specification
    fGenType,
    fOutputCapacity,
    fRating,
    fPhaseWireConn,
    fVoltage,
    fCurrent,
    fFrequency,
    fPole,
    fSpeed,
    fPowerFactor,
    fGDSquareJule,
    fRotorWeight,
    fTotalWeight,

    //Characteristics
    fTotalEfficiency,
    fVariationOfGenVoltage,
    fExcitingVoltage,
    fExcitingCurrent,
    fMountingMethod,

    //for Bearing
    fBearingType,
    fBearingLocation,
    fBearingSize,
    fBearingOilQuantity,
    fBearingLubSystem,
    fBearingOilGrade,
//    fBearingInletPress,
//    fBearingInletTemp,

    //for Air Cooler
    fACCapacity,
    fACFluid,
    fACQuantity,
    fACInletTemp,
    fACTempRise,
    fACPressDrop,
    fACDryWeight,

    //for Detecting System
    fDSWindingTemp,
    fDSBearingTemp,
    fDSCoolingAirTemp,
    fDSLeakageDetector,

    //Reactance & Time Constant(Calculated Value)
    fX_d,
    fXPrime_d,
    fXSecond_d,
    fTPrime_d,
    fTSecond_d,
    fTa,
    fra,

    //Confirmed Item By Owner
    fLocationOfTerminalBox,
    fCableEntry,
    fSpaceHeater,
    fPaintingColor,
//    fLocationOfAirCoolerFlange,
    fRotatingDirection,
    fAppliedEngine: RawUTF8;

    fProductDate,
    fInstallDate: TTimeLog;
  public
  published
    property ProjectNo: RawUTF8 read fProjectNo write fProjectNo;
    property ProjectName: RawUTF8 read fProjectName write fProjectName;
    property ModelNo: RawUTF8 read fModelNo write fModelNo;
    property SpecDesc: RawUTF8 read fSpecDesc write fSpecDesc;
    property SerialNo: RawUTF8 read fSerialNo write fSerialNo;
    property GenUse: RawUTF8 read fGenUse write fGenUse;
    property EnclosureType: RawUTF8 read fEnclosureType write fEnclosureType;
    property CoolingSystem: RawUTF8 read fCoolingSystem write fCoolingSystem;
    property ExcitingSystem: RawUTF8 read fExcitingSystem write fExcitingSystem;
    property StructureOfRotor: RawUTF8 read fStructureOfRotor write fStructureOfRotor;
    property CouplingMethod: RawUTF8 read fCouplingMethod write fCouplingMethod;
    property QuantyPerShip: RawUTF8 read fQuantyPerShip write fQuantyPerShip;
    property ClassSociety: RawUTF8 read fClassSociety write fClassSociety;
    property AmbientTemp: RawUTF8 read fAmbientTemp write fAmbientTemp;
    property InsulationClass: RawUTF8 read fInsulationClass write fInsulationClass;
    property TemperatureRise: RawUTF8 read fTemperatureRise write fTemperatureRise;
    property AppliedUnit: RawUTF8 read fAppliedUnit write fAppliedUnit;

    property GenType: RawUTF8 read fGenType write fGenType;
    property OutputCapacity: RawUTF8 read fOutputCapacity write fOutputCapacity;
    property Rating: RawUTF8 read fRating write fRating;
    property PhaseWireConn: RawUTF8 read fPhaseWireConn write fPhaseWireConn;
    property Voltage: RawUTF8 read fVoltage write fVoltage;
    property Current: RawUTF8 read fCurrent write fCurrent;
    property Frequency: RawUTF8 read fFrequency write fFrequency;
    property Pole: RawUTF8 read fPole write fPole;
    property Speed: RawUTF8 read fSpeed write fSpeed;
    property PowerFactor: RawUTF8 read fPowerFactor write fPowerFactor;
    property GDSquareJule: RawUTF8 read fGDSquareJule write fGDSquareJule;
    property RotorWeight: RawUTF8 read fRotorWeight write fRotorWeight;
    property TotalWeight: RawUTF8 read fTotalWeight write fTotalWeight;

    property TotalEfficiency: RawUTF8 read fTotalEfficiency write fTotalEfficiency;
    property VariationOfGenVoltage: RawUTF8 read fVariationOfGenVoltage write fVariationOfGenVoltage;
    property ExcitingVoltage: RawUTF8 read fExcitingVoltage write fExcitingVoltage;
    property ExcitingCurrent: RawUTF8 read fExcitingCurrent write fExcitingCurrent;
    property MountingMethod: RawUTF8 read fMountingMethod write fMountingMethod;

    property BearingType: RawUTF8 read fBearingType write fBearingType;
    property BearingLocation: RawUTF8 read fBearingLocation write fBearingLocation;
    property BearingSize: RawUTF8 read fBearingSize write fBearingSize;
    property BearingOilQuantity: RawUTF8 read fBearingOilQuantity write fBearingOilQuantity;
    property BearingLubSystem: RawUTF8 read fBearingLubSystem write fBearingLubSystem;
    property BearingOilGrade: RawUTF8 read fBearingOilGrade write fBearingOilGrade;
//    property BearingInletPress: RawUTF8 read fBearingInletPress write fBearingInletPress;
//    property BearingInletTemp: RawUTF8 read fBearingInletTemp write fBearingInletTemp;

//    property ACCapacity: RawUTF8 read fACCapacity write fACCapacity;
//    property ACFluid: RawUTF8 read fACFluid write fACFluid;
//    property ACQuantity: RawUTF8 read fACQuantity write fACQuantity;
//    property ACInletTemp: RawUTF8 read fACInletTemp write fACInletTemp;
//    property ACTempRise: RawUTF8 read fACTempRise write fACTempRise;
//    property ACPressDrop: RawUTF8 read fACPressDrop write fACPressDrop;
//    property ACDryWeight: RawUTF8 read fACDryWeight write fACDryWeight;

    property DSWindingTemp: RawUTF8 read fDSWindingTemp write fDSWindingTemp;
    property DSBearingTemp: RawUTF8 read fDSBearingTemp write fDSBearingTemp;
//    property DSCoolingAirTemp: RawUTF8 read fDSCoolingAirTemp write fDSCoolingAirTemp;
//    property DSLeakageDetector: RawUTF8 read fDSLeakageDetector write fDSLeakageDetector;

//    property X_d: RawUTF8 read fX_d write fX_d;
//    property XPrime_d: RawUTF8 read fXPrime_d write fXPrime_d;
//    property XSecond_d: RawUTF8 read fXSecond_d write fXSecond_d;
//    property TPrime_d: RawUTF8 read fTPrime_d write fTPrime_d;
//    property TSecond_d: RawUTF8 read fTSecond_d write fTSecond_d;
//    property Ta: RawUTF8 read fTa write fTa;
//    property ra: RawUTF8 read fra write fra;

    property LocationOfTerminalBox: RawUTF8 read fLocationOfTerminalBox write fLocationOfTerminalBox;
    property CableEntry: RawUTF8 read fCableEntry write fCableEntry;
    property SpaceHeater: RawUTF8 read fSpaceHeater write fSpaceHeater;
    property PaintingColor: RawUTF8 read fPaintingColor write fPaintingColor;
//    property LocationOfAirCoolerFlange: RawUTF8 read fLocationOfAirCoolerFlange write fLocationOfAirCoolerFlange;
    property RotatingDirection: RawUTF8 read fRotatingDirection write fRotatingDirection;
    property AppliedEngine: RawUTF8 read fAppliedEngine write fAppliedEngine;

    property ProductDate: TTimeLog read fProductDate write fProductDate;
    property InstallDate: TTimeLog read fInstallDate write fInstallDate;
  end;

function CreateGeneratorModel: TSQLModel;
procedure InitGeneratorClient(AExeName: string);

function GetGeneratorFromTaskID(const ATaskID: TID): TSQLGeneratorRecord;
function GetGeneratorFromHullNo(const AHullNo: string): TSQLGeneratorRecord;
function GetGeneratorFromShipName(const AShipName: string): TSQLGeneratorRecord;
function GetGeneratorFromIMONo(const AIMONo: string): TSQLGeneratorRecord;
function GetGeneratorFromIMONo_SerialNo(const AIMONo, ASerialNo: string): TSQLGeneratorRecord;
function GetGeneratorFromProjNo(const AProjNo: string): TSQLGeneratorRecord;

procedure AddGeneratorFromVariant(ADoc: variant; AIsUpdate: Boolean = False);
procedure LoadGeneratorFromVariant(AGenerator:TSQLGeneratorRecord; ADoc: variant);
function LoadGeneratorFromDB2Variant(const ATaskID: TID; var ADoc: variant): Boolean;
procedure AddOrUpdateGenerator(AGenerator:TSQLGeneratorRecord);

procedure DeleteGeneratorFromIMONo_SerialNo(const AIMONo, ASerialNo: string);

var
  g_GeneratorDB: TSQLRestClientURI;
  GeneratorModel: TSQLModel;

implementation

uses SysUtils, mORMotSQLite3, Forms, VarRecUtils, Vcl.Dialogs,// UnitGeneratorData,
  UnitMSBDData, UnitFolderUtil;

procedure InitGeneratorClient(AExeName: string);
var
  LStr: string;
begin
  LStr := GetSubFolderPath(ExtractFilePath(AExeName), 'db');
  LStr := EnsureDirectoryExists(LStr);
  LStr := LStr + 'GeneratorData.sqlite';
  GeneratorModel:= CreateGeneratorModel;
  g_GeneratorDB:= TSQLRestClientDB.Create(GeneratorModel, CreateGeneratorModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_GeneratorDB).Server.CreateMissingTables;

  InitGSFileClient(ExtractFilePath(AExeName)+'GeneratorData.exe');
end;

function CreateGeneratorModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLGeneratorRecord]);
end;

function GetGeneratorFromTaskID(const ATaskID: TID): TSQLGeneratorRecord;
begin
  Result := TSQLGeneratorRecord.CreateAndFillPrepare(g_GeneratorDB,
    'TaskID = ?', [ATaskID]);
end;

function GetGeneratorFromHullNo(const AHullNo: string): TSQLGeneratorRecord;
begin
  Result := TSQLGeneratorRecord.CreateAndFillPrepare(g_GeneratorDB,
    'HullNo LIKE ?', ['%'+AHullNo+'%']);
end;

function GetGeneratorFromShipName(const AShipName: string): TSQLGeneratorRecord;
begin
  Result := TSQLGeneratorRecord.CreateAndFillPrepare(g_GeneratorDB,
    'ShipName LIKE ?', ['%'+AShipName+'%']);
end;

function GetGeneratorFromIMONo(const AIMONo: string): TSQLGeneratorRecord;
begin
  Result := TSQLGeneratorRecord.CreateAndFillPrepare(g_GeneratorDB,
    'IMONo LIKE ?', ['%'+AIMONo+'%']);
end;

function GetGeneratorFromIMONo_SerialNo(const AIMONo, ASerialNo: string): TSQLGeneratorRecord;
begin
  Result := TSQLGeneratorRecord.CreateAndFillPrepare(g_GeneratorDB,
    'IMONo LIKE ? and SerialNo LIKE ?', ['%'+AIMONo+'%', '%'+ASerialNo+'%']);
end;

function GetGeneratorFromProjNo(const AProjNo: string): TSQLGeneratorRecord;
begin
  Result := TSQLGeneratorRecord.CreateAndFillPrepare(g_GeneratorDB,
    'ProjectNo LIKE ?', ['%'+AProjNo+'%']);
end;

procedure AddGeneratorFromVariant(ADoc: variant; AIsUpdate: Boolean);
var
  LSQLGeneratorRecord: TSQLGeneratorRecord;
begin
//  LSQLGeneratorRecord := GetGeneratorFromTaskID(ADoc.TaskID);
  LSQLGeneratorRecord := GetGeneratorFromProjNo(ADoc.ProjectNo);

  try
    AIsUpdate := LSQLGeneratorRecord.FillOne;
    LoadGeneratorFromVariant(LSQLGeneratorRecord, ADoc);
    LSQLGeneratorRecord.UpdatedDate := TimeLogFromDateTime(now);
    LSQLGeneratorRecord.IsUpdate := AIsUpdate;
    AddOrUpdateGenerator(LSQLGeneratorRecord);
  finally
    FreeAndNil(LSQLGeneratorRecord);
  end;
end;

procedure LoadGeneratorFromVariant(AGenerator:TSQLGeneratorRecord; ADoc: variant);
begin
  if ADoc = null then
    exit;

  LoadRecordPropertyFromVariant(AGenerator, ADoc);
  AGenerator.ProductDate := ADoc.ProductDate;
  AGenerator.InstallDate := ADoc.InstallDate;
//  AGenerator.HullNo := ADoc.HullNo;
//  AGenerator.ShipName := ADoc.ShipName;
//  AGenerator.IMONo := ADoc.IMONo;
//
//  AGenerator.SerialNo := ADoc.SerialNo;
//  AGenerator.GenUse := ADoc.GenUse;
//  AGenerator.EnclosureType := ADoc.EnclosureType;
//  AGenerator.CoolingSystem := ADoc.CoolingSystem;
//  AGenerator.ExcitingSystem := ADoc.ExcitingSystem;
//  AGenerator.StructureOfRotor := ADoc.StructureOfRotor;
//  AGenerator.CouplingMethod := ADoc.CouplingMethod;
//  AGenerator.QuantyPerShip := ADoc.QuantyPerShip;
//  AGenerator.ClassSociety := ADoc.ClassSociety;
//  AGenerator.AmbientTemp := ADoc.AmbientTemp;
//  AGenerator.InsulationClass := ADoc.InsulationClass;
//  AGenerator.TemperatureRise := ADoc.TemperatureRise;
//  AGenerator.AppliedUnit := ADoc.AppliedUnit;
//
//  AGenerator.GenType := ADoc.GenType;
//  AGenerator.OutputCapacity := ADoc.OutputCapacity;
//  AGenerator.Rating := ADoc.Rating;
//  AGenerator.PhaseWireConn := ADoc.PhaseWireConn;
//  AGenerator.Voltage := ADoc.Voltage;
//  AGenerator.Current := ADoc.Current;
//  AGenerator.Frequency := ADoc.Frequency;
//  AGenerator.Pole := ADoc.Pole;
//  AGenerator.Speed := ADoc.Speed;
//  AGenerator.PowerFactor := ADoc.PowerFactor;
//  AGenerator.GDSquareJule := ADoc.GDSquareJule;
//  AGenerator.RotorWeight := ADoc.RotorWeight;
//  AGenerator.TotalWeight := ADoc.TotalWeight;
//
//  AGenerator.TotalEfficiency := ADoc.TotalEfficiency;
//  AGenerator.VariationOfGenVoltage := ADoc.VariationOfGenVoltage;
//  AGenerator.ExcitingVoltage := ADoc.ExcitingVoltage;
//  AGenerator.ExcitingCurrent := ADoc.ExcitingCurrent;
//  AGenerator.MountingMethod := ADoc.MountingMethod;
//
//  AGenerator.BearingType := ADoc.BearingType;
//  AGenerator.BearingLocation := ADoc.BearingLocation;
//  AGenerator.BearingSize := ADoc.BearingSize;
//  AGenerator.BearingOilQuantity := ADoc.BearingOilQuantity;
//  AGenerator.BearingLubSystem := ADoc.BearingLubSystem;
//  AGenerator.BearingOilGrade := ADoc.BearingOilGrade;
//  AGenerator.BearingInletPress := ADoc.BearingInletPress;
//  AGenerator.BearingInletTemp := ADoc.BearingInletTemp;
//
//  AGenerator.ACCapacity := ADoc.ACCapacity;
//  AGenerator.ACFluid := ADoc.ACFluid;
//  AGenerator.ACQuantity := ADoc.ACQuantity;
//  AGenerator.ACInletTemp := ADoc.ACInletTemp;
//  AGenerator.ACTempRise := ADoc.ACTempRise;
//  AGenerator.ACPressDrop := ADoc.ACPressDrop;
//  AGenerator.ACDryWeight := ADoc.ACDryWeight;
//
//  AGenerator.DSWindingTemp := ADoc.DSWindingTemp;
//  AGenerator.DSBearingTemp := ADoc.DSBearingTemp;
//  AGenerator.DSCoolingAirTemp := ADoc.DSCoolingAirTemp;
//  AGenerator.DSLeakageDetector := ADoc.DSLeakageDetector;
//
//  AGenerator.X_d := ADoc.X_d;
//  AGenerator.XPrime_d := ADoc.XPrime_d;
//  AGenerator.XSecond_d := ADoc.XSecond_d;
//  AGenerator.TPrime_d := ADoc.TPrime_d;
//  AGenerator.TSecond_d := ADoc.TSecond_d;
//  AGenerator.Ta := ADoc.Ta;
//  AGenerator.ra := ADoc.ra;
//
//  AGenerator.LocationOfTerminalBox := ADoc.LocationOfTerminalBox;
//  AGenerator.CableEntry := ADoc.CableEntry;
//  AGenerator.SpaceHeater := ADoc.SpaceHeater;
//  AGenerator.PaintingColor := ADoc.PaintingColor;
//  AGenerator.LocationOfAirCoolerFlange := ADoc.LocationOfAirCoolerFlange;
//  AGenerator.RotatingDirection := ADoc.RotatingDirection;
//  AGenerator.AppliedEngine := ADoc.AppliedEngine;
//
//  AGenerator.InstallDate := TimeLogFromDateTime(StrToDate(ADoc.InstallDate));
end;

function LoadGeneratorFromDB2Variant(const ATaskID: TID; var ADoc: variant): Boolean;
var
  LGenerator:TSQLGeneratorRecord;
begin
  if ADoc = null then
    exit;

  LGenerator := GetGeneratorFromTaskID(ATaskID);
  try
    Result := LGenerator.FillOne;
    LoadRecordPropertyToVariant(LGenerator, ADoc);
  finally
    LGenerator.Free;
  end;
end;

procedure AddOrUpdateGenerator(AGenerator:TSQLGeneratorRecord);
begin
  if AGenerator.IsUpdate then
  begin
    g_GeneratorDB.Update(AGenerator);
  end
  else
  begin
    g_GeneratorDB.Add(AGenerator, true);
  end;
end;

{ TSQLGeneratorRecord }

procedure DeleteGeneratorFromIMONo_SerialNo(const AIMONo, ASerialNo: string);
var
  LSQLGeneratorRecord: TSQLGeneratorRecord;
begin
  LSQLGeneratorRecord := GetGeneratorFromIMONo_SerialNo(AIMONo, ASerialNo);
  try
    if LSQLGeneratorRecord.FillOne then
      g_GeneratorDB.Delete(TSQLGeneratorRecord, LSQLGeneratorRecord.ID);
  finally
    FreeAndNil(LSQLGeneratorRecord);
  end;
end;

initialization

finalization
  if Assigned(GeneratorModel) then
    FreeAndNil(GeneratorModel);

  if Assigned(g_GeneratorDB) then
    FreeAndNil(g_GeneratorDB);

end.

