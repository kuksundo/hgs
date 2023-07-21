unit EngineBaseClass;

interface

uses classes, SysUtils, math, Generics.Legacy, BaseConfigCollect, EngineConst, IPC_MEXA7000_Const,
  UnitEngineMasterData;

type
  TICEngineComponentItem = class(TCollectionItem)
  private
    FMS_NO: string;
    FComponentName: string;
    FMaker: string;
    FType: string;
    FSerialNo: string;

    FDrawingNo: string; //도며번호
    FManualFileName: string; //상대경로 메뉴얼 파일 이름
    FManualPage: string; //Manual 내 Page 번호(E:\pjh\project\common\WindowUtil.pas의 OpenPDF 함수 이용할 것)
  public
    FNxPropertyItem: Pointer;//Component Item이 저장되는 Inspector Property를 저장함
  published
    property MS_NO: string read FMS_NO write FMS_NO;
    property ComponentName: string read FComponentName write FComponentName;
    property Maker: string read FMaker write FMaker;
    property FFType: string read FType write FType;
    property SerialNo: string read FSerialNo write FSerialNo;

    property DrawingNo: string read FDrawingNo write FDrawingNo;
    property ManualFileName: string read FManualFileName write FManualFileName;
    property ManualPage: string read FManualPage write FManualPage;
  end;

  TICEngineComponentCollect<T: TICEngineComponentItem> = class(Generics.Legacy.TCollection<T>)
  end;

  TICEnginePartItem = class(TCollectionItem)
  private
    FMS_NO: string;
    FPartName: string;
    FMaker: string;
    FType: string;
    FSerialNo: string;

    FBank: string; //A or B Bank
    FCylNo: string;//Cylinder No.
    FCycle: string;//Intake or Exhaust
    FSide: string; //Exh Side or Cam Side

    FManualFileName: string; //상대경로 메뉴얼 파일 이름
    FManualPage: string; //Manual 내 Page 번호(E:\pjh\project\common\WindowUtil.pas의 OpenPDF 함수 이용할 것)
    FComponentIndex: integer; //TICEngineComponentCollect의 index : sub item으로 표시하기 위함
  public
    FNxPropertyItem: Pointer;//Part Item이 저장되는 Inspector Property를 저장함
  published
    property MS_NO: string read FMS_NO write FMS_NO;
    property PartName: string read FPartName write FPartName;
    property Maker: string read FMaker write FMaker;
    property FFType: string read FType write FType;
    property SerialNo: string read FSerialNo write FSerialNo;

    property ManualFileName: string read FManualFileName write FManualFileName;
    property ManualPage: string read FManualPage write FManualPage;
    property ComponentIndex: integer read FComponentIndex write FComponentIndex;

    property Bank: string read FBank write FBank;
    property CylNo: string read FCylNo write FCylNo;
    property Cycle: string read FCycle write FCycle;
    property Side: string read FSide write FSide;
  end;

  TICEnginePartCollect<T: TICEnginePartItem> = class(Generics.Legacy.TCollection<T>)
  end;

  IGasEngineInterface = interface ['{29ECCBD5-E904-4482-A68F-1E53540DCFD0}']
    function GetGasFlow: double;
    procedure SetGasFlow(Value: double);
    function GetGasTemp: double;
    procedure SetGasTemp(Value: double);
    function GetGasPress: double;
    procedure SetGasPress(Value: double);

    property GasFlow: double read GetGasFlow write SetGasFlow;
    property GasTemp: double read GetGasTemp write SetGasTemp;
    property GasPress: double read GetGasPress write SetGasPress;
  end;

  TEngineLoadTableItem = class(TCollectionItem)
  private
    FEngineLoad: integer; //(%)
    FEngineOutput: double;//(kW)
    FGenEfficiency: double;//(%/100)
    FGenOutput: double;//(kW)
  published
    property EngineLoad: integer read FEngineLoad write FEngineLoad;
    property EngineOutput: double read FEngineOutput write FEngineOutput;
    property GenEfficiency: double read FGenEfficiency write FGenEfficiency;
    property GenOutput: double read FGenOutput write FGenOutput;
  end;

  TEngineLoadTableCollect<T: TEngineLoadTableItem> = class(Generics.Legacy.TCollection<T>)
  public
    function GetGenEfficiency(ALoad: Double): double;//Get Generator Effiency from table
  end;

  IDieselEngineInterface = interface ['{ABFAD293-8012-4C3D-8C40-A2B8F270D1B6}']
//    function GetGasFlow: double;
//    procedure SetGasFlow(Value: double);
//
//    property GasFlow: double read GetGasFlow write SetGasFlow;
  end;

  TICEngine = class(TpjhBase)
  private
    FICEngineComponentCollect: TICEngineComponentCollect<TICEngineComponentItem>;
    FICEnginePartCollect: TICEnginePartCollect<TICEnginePartItem>;

    //Engine Spec.
    FBore: integer;  //mm
    FStroke: integer; //mm
    FCylinderCount: integer;
    FRatedSpeed: integer;//RPM
    FRatedPower_Engine: Double; //(kW)
    FRatedPower_Generator: Double; //(kW)
    FFrequency: Double; //(Hz) Only for Genset
    FSFOC: Double; //Specific Fuel Oil Consumption(g/kWh)
    FBMEP: Double;
    FIVO,  //Intake Valve Open timing
    FIVC,  //Intake Valve Close timing
    FEVO,  //Exhaust Valve Open timing
    FEVC: integer;//Exhaust Valve Close timing
    //Turbo Charger Count(Air Flow Nozzle sensor 개수가 한개일 경우 공기량 계산시 곱하기 위함)
    FTCCount: integer;

    FProjectNo,//공사번호
    FEngineNo,//호선내 엔진번호
    FTier, //환경 적용 기술
    FFiringOrder: string;
    FCylinderConfiguration: TCylinderConfiguration;
    FFuelType: TFuelType;

    FDimension_A,
    FDimension_B,
    FDimension_C,
    FDimension_D: Double;//m
    FEngineWeight,
    FGenSetWeight: Double;//ton

    FTurboCharger,
    FGovernor,
    FChargeAirCooler,
    FLTWaterPump,
    FHTWaterPump,
    FLOPump,
    FPreLubLOPump,
    FLOCooler,
    FStartingSystem,
    FTurningGear,
    FOMD,
    FFOPump,
    FFOValve,
    FFONozzle,
    FECU: string;

  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Clear;
    function GetEngineType: string;
    procedure SetEngineType(ACount, ABore, AStroke, AFuelType, ACylConf: integer);
    procedure DeleteComponentOrPart(AKind: integer; AIdx: integer);
  published
    property ICEngineComponentCollect: TICEngineComponentCollect<TICEngineComponentItem> read FICEngineComponentCollect write FICEngineComponentCollect;
    property ICEnginePartCollect: TICEnginePartCollect<TICEnginePartItem> read FICEnginePartCollect write FICEnginePartCollect;

    property Bore: integer read FBore write FBore;
    property Stroke: integer read FStroke write FStroke;
    property CylinderCount: integer read FCylinderCount write FCylinderCount;
    property RatedSpeed: integer read FRatedSpeed write FRatedSpeed;
    property RatedPower_Engine: Double read FRatedPower_Engine write FRatedPower_Engine;
    property RatedPower_Generator: Double read FRatedPower_Generator write FRatedPower_Generator;
    property Frequency: Double read FFrequency write FFrequency;

    property BMEP: Double read FBMEP write FBMEP;
    property SFOC: Double read FSFOC write FSFOC;
    property IVO: integer read FIVO write FIVO;
    property IVC: integer read FIVC write FIVC;
    property EVO: integer read FEVO write FEVO;
    property EVC: integer read FEVC write FEVC;

    property CylinderConfiguration: TCylinderConfiguration read FCylinderConfiguration write FCylinderConfiguration;
    property FuelType: TFuelType read FFuelType write FFuelType;
    property FiringOrdder: string read FFiringOrder write FFiringOrder;

    property Dimension_A: Double read FDimension_A write FDimension_A;
    property Dimension_B: Double read FDimension_B write FDimension_B;
    property Dimension_C: Double read FDimension_C write FDimension_C;
    property Dimension_D: Double read FDimension_D write FDimension_D;
    property EngineWeight: Double read FEngineWeight write FEngineWeight;
    property GensetWeight: Double read FGenSetWeight write FGenSetWeight;
    property ProjectNo: string read FProjectNo write FProjectNo;
    property EngineNo: string read FEngineNo write FEngineNo;
    property Tier: string read FTier write FTier;
  end;

//  TDieselEngine = class(TICEngine, IDieselEngineInterface)
//  private
//  published
//  end;
//
//  TGasEngine = class(TICEngine, IGasEngineInterface)
//  private
//    //MEP
//    FGasFlow: double;  //Gas Flow(m³/h)
//    FGasTemp,
//    FGasPress: double;
//  public
//
//  published
//    property GasFlow: double read FGasFlow write FGasFlow;
//    property GasTemp: double read FGasTemp write FGasTemp;
//    property GasPress: double read FGasPress write FGasPress;
//  end;
//
//  TDFEngine = class(TICEngine, IGasEngineInterface, IDieselEngineInterface)
//  private
//  published
//  end;

  TCREngine = class(TICEngine)
  private
  published
  end;

  TEngineMonitoringData = class(TpjhBase)
  private
    FELMCollect: TEngineLoadTableCollect<TEngineLoadTableItem>;
    FFooter: string;
    FHeader: string;  //Engine Type
    FFileName: string;

    FEfficiency: double;
    FLCV: integer;
    FStoichiometricRatio: double;//(kg/kg) 이론 공연비(연료에 따라 다름)

    //=====MEP=====
    FBore: integer;
    FStroke: integer;
    FCylinderCount: integer;
    FMCR: integer;
    FRatedPower: Double; //(kW)
    FGeneratorOutput: Double; //Measured(kW)
    FEngineSpeed: integer; //Measured(rpm)
    FGasFlow: double;  //Gas Flow(m³/h)
    FGasTemp,
    FGasPress: double;
    FDisplacementVolume: double;

    //=====Ambient=====
    FIntakeAirTemp: double;//Intake Air Temp.
    FSVP: double;// Saturation Vapour Press.(kPa)
    FSAP: double;// Scavange Air Pressure(kg/cm²)
    FSAT: double;// Scavange Air Temperature(°C)
    FBP: double;// Barometric Pressure(kPa)

    //=====Governor=====
    FIAH: double;//Intake Air Humidity(%)
    FIAH2: double;// Intake Air Humidity(g/kg)
    FIART: double;// Intecooled Air Ref. Temperature(°C)
    FCWIT: double;// C.W. Inlet Temp.(°C)
    FCWOT: double;// C.W. Outlet Temp.(°C)

    //=====Fuel=====
    FFC: double;//Fuel Consumption(kg/h)
    FUFC: double;// Uncorrected Fuel Consumption(g/kwh)

    //=====Gaseous=====  계측값이 아닌 연료조성비 %임
    FCH4: double;
    FC2H6: double;
    FC3H8: double;
    FC4H10: double;
    FC5H12: double;

    FCarbon: double;
    FHydrogen: double;
    FNitrogen: double;
    FOxygen: double;
    FSulfur: double;
    FUseInputDensity: boolean;
    FDensity: double;
    FViscosity: double;
    FC_residue: double;
    FWater: double;

    //=====NOx 계측값====
    FCO2: Double;
    FCO_L: Double;
    FO2: Double;
    FNOx: Double;
    FTHC: Double;
    FFCH4: Double;
    Fnon_CH4: Double;
    FCollectedValue: Double;

    //=====NOx=====
    FNhtCF: double;  //Nox humidity/temp. Correction Factor
    FDWCFE: double;//Dry/Wet Correction Factor Exhaust:
    FEGF: double; //Exhaust Gas Flow(kg/h)
    FAF1: double; //Air Flow (kg/h)
    FAF2: double; //Air Flow (kg/kwh)
    FAF3: double; //Air Flow (kg/s)
    FAF_Measured: double; //Measured Air Flow (kg/h):MT210
    FUseMT210Data: boolean;
    FRealtimeKnockData: boolean; //Display real time knock data
    FRealtimeMisfireData: boolean; //Display real time misfire data

    //======Etc=====
    FCloseTCPClient: boolean;//Close TCP Client Program when main form is closed;
    //Turbo Charger Count(Air Flow Nozzle sensor 개수가 한개일 경우 공기량 계산시 곱하기 위함)
    FTCCount: integer;

    FExhTempAvg: double;//Average of Exh. Temp.
    FEngineOutput: Double; //Calculated(kW/h)
    FEngineLoad: double; //Current Engine Load(%)
    FGenEfficiency: double; //Generator Efficiency at current Load(%/100)
    FBHP: double; //Brake Horse Power
    FBMEP: double;//Brake Mean Effective Press.
    FBMEP2: double;//Brake Mean Effective Press.
    FBMEP3: double;//Brake Mean Effective Press.(Unit:Pa)
    FWorkJulePerCycle: double;
    FLamda: double; //Lamda Ratio
    FLamda_Calculated: double; //Lamda Ratio by MEXA7000
    FLamda_Measured: double; //Lamda Ratio by MT210
    FLamda_Brettschneider: double; //Lamda(Brettschneider equation) - Normalized Air/Fuel balance
    FAFRatio: double;//Air Fuel Ratio
    FAFRatio_Calculated: double;//Air Fuel Ratio (Calculated by emission data)
    FAFRatio_Measured: double;//Air Fuel Ratio (Measured by MT210)
    FWasteGatePosition: double;//Waste Gate Position
    FThrottlePosition: double;//Throttle Valve Position
    //FBoostPress: double;//Boost Pressure

  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure AddDefautProperties;
    procedure Default_Calc;
    procedure Clear;

    procedure Efficiency_Calc;
    procedure BMEP_Calc;
    Procedure EngineLoad_Calc;
    procedure AFRFromMeasured_Calc;
    procedure SVP_Calc; //Saturation Vapour Pressure(kPa)
    procedure IntakeAirHumidigy_Calc; // Intake Air Humidity
    procedure UFC_Calc; // Uncorrected Fuel Comsumption
    procedure NhtCF_Calc;//NOx humidity/temp. Correction Factor
    procedure DWCFE_Calc(ACO_L, ACO2: double);//Dry/Wet Correction Factor Exhaust
    procedure NoxCorrectionFactor_Calc; //Nox humidity/yemp. Correction Factor
    procedure ExhCorrectionFactor_Calc; //Dry/Wet Correction Factor Exhaust
    procedure FuelComposition_Calc; //연료성분을 기반으로 각 원소별 질량 계산
    procedure ExhGasFlow_Calc(AMEXA7000_2: TEventData_MEXA7000_2); //Exhaust Gas Flow
    procedure AirFlow_Calc(AMEXA7000_2: TEventData_MEXA7000_2); //Air Flow
    procedure Lamda_Calc; //Lamda Ratio
    procedure Brettschneider_Calc; //Lamda Ratio(Brettschneidr equation)
    procedure DisplacementVolume_Calc;
  published
    property Header: string read FHeader write FHeader;
    property FileName: string read FFileName write FFileName;
    property ELMCollect: TEngineLoadTableCollect<TEngineLoadTableItem> read FELMCollect write FELMCollect;
    property Footer: string read FFooter write FFooter;

    property Bore: integer read FBore write FBore;
    property Stroke: integer read FStroke write FStroke;
    property CylinderCount: integer read FCylinderCount write FCylinderCount;
    property MCR: integer read FMCR write FMCR;
    property RatedPower: Double read FRatedPower write FRatedPower;

    property GeneratorOutput: Double read FGeneratorOutput write FGeneratorOutput;
    property EngineSpeed: integer read FEngineSpeed write FEngineSpeed;

    property IntakeAirTemp: double read FIntakeAirTemp write FIntakeAirTemp;
    property SVP: double read FSVP write FSVP;
    property SAP: double read FSAP write FSAP;
    property SAT: double read FSAT write FSAT;
    property BP: double read FBP write FBP;

    property IAH: double read FIAH write FIAH;
    property IAH2: double read FIAH2 write FIAH2;
    property IART: double read FIART write FIART;
    property CWIT: double read FCWIT write FCWIT;
    property CWOT: double read FCWOT write FCWOT;

    property FC: double read FFC write FFC;
    property LCV: integer read FLCV write FLCV;
    property UFC: double read FUFC write FUFC;

    property CH4: double read FCH4 write FCH4;
    property C2H6: double read FC2H6 write FC2H6;
    property C3H8: double read FC3H8 write FC3H8;
    property C4H10: double read FC4H10 write FC4H10;
    property C5H12: double read FC5H12 write FC5H12;

    property Carbon: double read FCarbon write FCarbon;
    property Hydrogen: double read FHydrogen write FHydrogen;
    property Nitrogen: double read FNitrogen write FNitrogen;
    property Oxygen: double read FOxygen write FOxygen;
    property Sulfur: double read FSulfur write FSulfur;
    property Density: double read FDensity write FDensity;
    property UseInputDensity: boolean read FUseInputDensity write FUseInputDensity;
    property Viscosity: double read FViscosity write FViscosity;
    property C_residue: double read FC_residue write FC_residue;
    property Water: double read FWater write FWater;

    property NhtCF: double read FNhtCF write FNhtCF;
    property DWCFE: double read FDWCFE write FDWCFE;
    property EGF: double read FEGF write FEGF;
    property AF1: double read FAF1 write FAF1;
    property AF2: double read FAF2 write FAF2;
    property AF3: double read FAF3 write FAF3;
    property AF_Measured: double read FAF_Measured write FAF_Measured;
    property UseMT210Data: boolean read FUseMT210Data write FUseMT210Data;
    property RealtimeKnockData: boolean read FRealtimeKnockData write FRealtimeKnockData;
    property RealtimeMisfireData: boolean read FRealtimeMisfireData write FRealtimeMisfireData;

    property StoichiometricRatio: double read FStoichiometricRatio write FStoichiometricRatio;
    property Efficiency: double read FEfficiency write FEfficiency;
    property GasFlow: double read FGasFlow write FGasFlow;
    property GasTemp: double read FGasTemp write FGasTemp;
    property GasPress: double read FGasPress write FGasPress;

    property CloseTCPClient: Boolean read FCloseTCPClient write FCloseTCPClient;
    property TCCount: integer read FTCCount write FTCCount;

    property ExhTempAvg: double read FExhTempAvg write FExhTempAvg;           //Average of Exh. Temp.
    property EngineOutput: Double read FEngineOutput write FEngineOutput;         //Calculated(kW/h)
    property EngineLoad: double read FEngineLoad write FEngineLoad;           //Current Engine Load(%)
    property GenEfficiency: double read FGenEfficiency write FGenEfficiency;        //Generator Efficiency at current Load(%/100)
    property BHP: double read FBHP write FBHP;                  //Brake Horse Power
    property BMEP: double read FBMEP write FBMEP;                 //Brake Mean Effective Press.
    property BMEP2: double read FBMEP2 write FBMEP2;                //Brake Mean Effective Press.
    property Lamda: double read FLamda write FLamda;                //Lamda Ratio
    property Lamda_Calculated: double read FLamda_Calculated write FLamda_Calculated;     //Lamda Ratio by MEXA7000
    property Lamda_Measured: double read FLamda_Measured write FLamda_Measured;       //Lamda Ratio by MT210
    property Lamda_Brettschneider: double read FLamda_Brettschneider write FLamda_Brettschneider; //Lamda(Brettschneider equation) - Normalized Air/Fuel balance
    property AFRatio: double read FAFRatio write FAFRatio;              //Air Fuel Ratio
    property AFRatio_Calculated: double read FAFRatio_Calculated write FAFRatio_Calculated;   //Air Fuel Ratio (Calculated by emission data)
    property AFRatio_Measured: double read FAFRatio_Measured write FAFRatio_Measured;     //Air Fuel Ratio (Measured by MT210)
    property WasteGatePosition: double read FWasteGatePosition write FWasteGatePosition;    //Waste Gate Position
    property ThrottlePosition: double read FThrottlePosition write FThrottlePosition;     //Throttle Valve Position
  end;

  TEngineISOConversion = class(TpjhBase)
  private
    //실 계측값
    FEngineLoadPercent: double;
    FEngineSpeed: double;
    FPmax_Avg: double;
    FCAPress: double;
    FTCSpeed: integer;
    FExhGasTempTCInlet: integer;
    FExhGasTempTCOutlet: integer;
    FExhGasTempAvg: integer;
    FBaseDurationGA: double;
    FFuelModeApplied: integer;
    FCATemp: double;
    FAirTempTCInlet: double;

    //ISO 변환 Factor
    FDev_CATemp: integer;
    FDev_AirTempTCInlet: integer;

{$I EngineISO.inc}
    //EngineISO.inc 파일에 published 키워드 선언 되어 있음

    property EngineLoadPercent: double read FEngineLoadPercent write FEngineLoadPercent;
    property EngineSpeed: double read FEngineSpeed write FEngineSpeed;
    property Pmax_Avg: double read FPmax_Avg write FPmax_Avg;
    property CAPress: double read FCAPress write FCAPress;
    property TCSpeed: integer read FTCSpeed write FTCSpeed;
    property ExhGasTempTCInlet: integer read FExhGasTempTCInlet write FExhGasTempTCInlet;
    property ExhGasTempTCOutlet: integer read FExhGasTempTCOutlet write FExhGasTempTCOutlet;
    property ExhGasTempAvg: integer read FExhGasTempAvg write FExhGasTempAvg;
    property BaseDurationGA: double read FBaseDurationGA write FBaseDurationGA;
    property FuelModeApplied: integer read FFuelModeApplied write FFuelModeApplied;
    property CATemp: double read FCATemp write FCATemp;
    property AirTempTCInlet: double read FAirTempTCInlet write FAirTempTCInlet;

    property Dev_CATemp: integer read FDev_CATemp write FDev_CATemp;
    property Dev_AirTempTCInlet: integer read FDev_AirTempTCInlet write FDev_AirTempTCInlet;
  end;

implementation

{ TICEngine }

procedure TICEngine.Clear;
begin
  ICEnginePartCollect.Clear;

   Bore := 0;
   Stroke := 0;
   CylinderCount := 0;
   RatedSpeed := 0;
   RatedPower_Engine := 0;
   RatedPower_Generator := 0;
   SFOC := 0;
   IVO := 0;
   IVC := 0;
   EVO := 0;
   EVC := 0;

   //CylinderConfiguration := ??;
   FiringOrdder := '';

   Dimension_A := 0;
   Dimension_B := 0;
   Dimension_C := 0;
   Dimension_D := 0;
   EngineWeight := 0;
   GenSetWeight := 0;
end;

constructor TICEngine.Create(AOwner: TComponent);
begin
  FICEnginePartCollect := TICEnginePartCollect<TICEnginePartItem>.Create;
  FICEngineComponentCollect := TICEngineComponentCollect<TICEngineComponentItem>.Create;
end;

procedure TICEngine.DeleteComponentOrPart(AKind, AIdx: integer);
begin
  if AKind = 1 then //Component
    ICEngineComponentCollect.Delete(AIdx)
  else
  if AKind = 2 then //Part
    ICEnginePartCollect.Delete(AIdx);
end;

destructor TICEngine.Destroy;
begin
  FICEngineComponentCollect.Free;
  FICEnginePartCollect.Free;

  inherited Destroy;
end;

function TICEngine.GetEngineType: string;
begin
  Result := IntToStr(CylinderCount) + 'H';
  Result := Result + IntToStr(Bore) + '/';
  Result := Result + IntToStr(Stroke);
  Result := Result + FuelType2DispName(FuelType);
  Result := Result + CylinderConfiguration2DispName(CylinderConfiguration);
end;

procedure TICEngine.SetEngineType(ACount, ABore, AStroke, AFuelType, ACylConf: integer);
begin
  CylinderCount := ACount;
  Bore := ABore;
  Stroke := AStroke;
  FuelType := TFuelType(AFuelType);
  CylinderConfiguration := TCylinderConfiguration(ACylConf);
end;

{ TEngineMonitoringData }

procedure TEngineMonitoringData.AddDefautProperties;
begin

end;

procedure TEngineMonitoringData.AFRFromMeasured_Calc;
var
  Ld:double;
begin
  try
    //Ld := Sqrt( (abs(FMT210Data.FData)*FOptions.BP*7.500617*1000000*287)/((FOptions.IntakeAirTemp+273) * 750));
    Ld := Sqrt( (abs(FAF_Measured * FTCCount)* FBP*7.500617*100000/750/287)/(FIntakeAirTemp+273));
  except on Exception do
  end;
end;

//AF1 : Air Flow(kg/h)
//AF2 : Air Specific(kg/kWh)
//AF3 : Air Specific(kg/s)
procedure TEngineMonitoringData.AirFlow_Calc(AMEXA7000_2: TEventData_MEXA7000_2);
begin
  //BMEP_Calc;

  if (AMEXA7000_2.NOx = 0) and (AMEXA7000_2.CO2 = 0) then
  begin
    egf := 0;
//    DisplayMessage('Check Emission input!!!');
    exit;
  end;

  IntakeAirHumidigy_Calc;
  UFC_Calc;
  NhtCF_Calc;
  DWCFE_Calc(FCO_L/10000, FCO2);
  ExhGasFlow_Calc(AMEXA7000_2);

  try
    AF1 := egf - FC;
    AF2 := egf / GeneratorOutput;
    AF3 := AF2/3600;
  except on Exception do
  end;

  //AF1Analog.Value := FEngineMonitoringData.AF1;
  //AF2Analog.Value := FEngineMonitoringData.AF2;
  //AF3Analog.Value := FEngineMonitoringData.AF3;

  Lamda_Calc;
end;

procedure TEngineMonitoringData.BMEP_Calc;
begin
  try
  // (75 * 60 * BHP) / ((Pi/4) * (Bore)2 * Stroke * Cylinder 수 * MCR
  //FBMEP := ((75 * 60 * FEngineMonitoringData.GeneratorOutput * 1000)/
  //          (PiOn4 * Power(FEngineMonitoringData.Bore/100, 2) * FEngineMonitoringData.Stroke/100 *
  //          FEngineMonitoringData.CylinderCount * FEngineMonitoringData.MCR/60))/1.0197;
  //  Button1.Caption := Format('%.2f', [FBMEP]);
    FBMEP2 := (FEngineOutput * 1.35962) /
            (PiOn4 * Power(Bore, 2) * Stroke * CylinderCount * MCR);

    //FBMEP := ((FEngineMonitoringData.GeneratorOutput * 1000)/
    //        (PiOn4 * Power(FEngineMonitoringData.Bore/100, 2) * FEngineMonitoringData.Stroke/100 *
    //        FEngineMonitoringData.CylinderCount * FEngineMonitoringData.MCR/60))/100000;
    //Button2.Caption := Format('%.2f', [FBMEP]);

    //FBMEP := 1200*FEngineOutput/(FEngineMonitoringData.CylinderCount*38.48451)/FEngineMonitoringData.MCR;
    FBMEP := 1200 * FEngineOutput/(CylinderCount*(PiOn4 * Power(Bore, 2) * Stroke)/1000)/ MCR;
//    BMEP.Value := FBMEP;
    FWorkJulePerCycle := (FEngineOutput * 120 * 1000)/FEngineSpeed;
    FBMEP3 := FWorkJulePerCycle/FDisplacementVolume;
  except on Exception do
  end;
end;

procedure TEngineMonitoringData.Brettschneider_Calc;
begin
  //with FMEXA7000Data do
  //  FLamda_Brettschneider := CO2 + (CO_L/20000) + O2 + (NOx/20000) +
end;

procedure TEngineMonitoringData.Clear;
begin
  GeneratorOutput := 0;
  StoichiometricRatio := 0;
  Efficiency := 0;
  FC := 0;
  LCV := 0;
end;

constructor TEngineMonitoringData.Create(AOwner: TComponent);
begin
  FELMCollect := TEngineLoadTableCollect<TEngineLoadTableItem>.Create;
  Default_Calc;
end;

procedure TEngineMonitoringData.Default_Calc;
begin
  DisplacementVolume_Calc;
end;

destructor TEngineMonitoringData.Destroy;
begin
  inherited;

  FELMCollect.Free;
end;

procedure TEngineMonitoringData.DisplacementVolume_Calc;
begin
  FDisplacementVolume :=PiOn4 * Power(Bore, 2) * Stroke * FCylinderCount;
end;

procedure TEngineMonitoringData.DWCFE_Calc(ACO_L, ACO2: double);
var
  LCO,
  LCO2,
  LHtcrat,
  LKw2: double;
begin
  try
    LCO := ACO_L / 10000; //FMEXA7000Data.CO_L/10000;
    LCO2 := ACO2; //FMEXA7000Data.CO2;  //단위가 ppm으로 입력됨, %로 변환
    LHtcrat := Hydrogen * 12.001 / (1.00794 * Carbon);
    LKw2 := (1.608 * IAH2) / (1000 + 1.608 * IAH2);
    DWCFE := 1/(1 + LHtcrat * 0.005 * (LCO + LCO2)) - LKw2;
  except on Exception do
  end;
end;

procedure TEngineMonitoringData.Efficiency_Calc;
begin
  //FEngineMonitoringData.Efficiency := 3600 /
  //  (( FEngineMonitoringData.GasFlow * 0.805 / FEngineMonitoringData.GeneratorOutput ) * 49450) * 100;
try
  //if (FEngineMonitoringData.GasFlow <> 0) and (FEngineMonitoringData.GasTemp <> 0) and
  //   (FEngineMonitoringData.GasPress <> 0) and (FEngineMonitoringData.GeneratorOutput <> 0) and
   //  (FEngineMonitoringData.LCV <> 0) then
    //FEngineMonitoringData.Efficiency := (FEngineMonitoringData.GeneratorOutput /
    // ( FEngineMonitoringData.LCV * FEngineMonitoringData.Density * FEngineMonitoringData.GasFlow * FEngineMonitoringData.GasPress /
    //  1013.25 * 273 / (273 + FEngineMonitoringData.GasTemp) ) /3600) * 100;
                      //Mass Flow Gas
    //FEngineMonitoringData.Efficiency := (FEngineMonitoringData.GeneratorOutput /
    // ( FEngineMonitoringData.GasFlow * ( (25+273)/ FEngineMonitoringData.GasTemp * FEngineMonitoringData.GasPress * 0.805) *
    //     FEngineMonitoringData.LCV)/3600) * 100;
    //FEngineMonitoringData.Efficiency := 3600 /
    // ( FEngineMonitoringData.GasFlow * ( (25+273)/ FEngineMonitoringData.GasTemp * FEngineMonitoringData.GasPress * 0.805) *
    //    FEngineMonitoringData.GeneratorOutput * FEngineMonitoringData.LCV) * 100;
    //FEngineMonitoringData.Efficiency := FEngineMonitoringData.GeneratorOutput /
    // (FEngineMonitoringData.FC * FEngineMonitoringData.LCV / 3600) * 100;
    FEfficiency := (3600 * FEngineOutput) / (FC * LCV) * 100;
//    EfficiencyEdit.Value := FEngineMonitoringData.Efficiency;
  except on Exception do
  end;
end;

//엔진로드 = (계측 kw / 발전기효율) / 정격출력 * 100
procedure TEngineMonitoringData.EngineLoad_Calc;
var
  LEff: double;
begin
  FGenEfficiency := ELMCollect.GetGenEfficiency(GeneratorOutput);

  try
    FEngineOutput := GeneratorOutput / FGenEfficiency;
//    EngineOutput.Value := FEngineOutput;
    FEngineLoad := FEngineOutput / RatedPower * 100 ; //(%)
//    EngLoadAnalog.Value := FEngineLoad;
  except on Exception do ;
  end;
end;

procedure TEngineMonitoringData.ExhCorrectionFactor_Calc;
begin

end;

procedure TEngineMonitoringData.ExhGasFlow_Calc(AMEXA7000_2: TEventData_MEXA7000_2);
var
  now, habs, nue, tau, eta, stoiar, kwexh, kwexh_v,
  o2w, co2w, cow, gexhwc, sefc, factor1 : double;
  factor2, gexhwo, sefo, gexhw, sef, devsef, gairw : double;
  vexhw1, vco, vno, vno2, vhc, vh2o, vco2, tau2 : double;
  vo2, vn2, varx, vso2, vexhw2, vexhd, exhdens, Gap, kexh, vch4 : double;
  exhdens_v: double;
begin
  try
    //--------------------------- Calculation Variables -----------------------------
    now :=  AMEXA7000_2.NOx * DWCFE; //NO Concentration (WET) (ppm)
    habs := IAH2/1000; //Abolute Humidity Kg/㎏)
    nue := 100.0 * habs / (1.0 + habs); //Water Content of Consumption Air (%, m/m)
    tau := o2air * mwo2 / mwair * (100.0 - nue) / 100.0; //Oxygen Content of Wet Combustion Air (%, m/m)
    eta := n2air * mwn2 / mwair * (100.0 - nue) / 100.0; //Nitrogen Content of Wet Combustion Air (%, m/m)
    stoiar := (Carbon / awc + Hydrogen / (4.0 * awh) + Sulfur / aws) * (2.0 * awo / 23.15); //Stoichiometric Air demand for combustion of 1㎏ fuel (㎏/㎏)

    //----------- Iterate Exhdens(Density of Wet Exhaust Gas (㎏/㎥) )-------------
    kwexh := 100. / ( (Hydrogen * mvh2o * awc * AMEXA7000_2.CO2) /
                   (Carbon * mvco2 * 2.0 * awh) + nue * 1.608 + 100.0);
        //See Equation (2-43) of IMO NOx Technical Code

    exhdens_v := 1.2689;

    while exhdens_v <= 1.32 do
    //while exhdens_v <= 2.0 do
    begin
      kwexh_v := kwexh; // Dry/2Wet Correction Factor for the raw Exhaust Gas
      o2w := kwexh_v * AMEXA7000_2.O2;  //O2  Concentration (WET Exhaust) (%, m/m)
      co2w := kwexh_v * AMEXA7000_2.CO2; //CO2 Concentration (WET Exhaust) (%, m/m)
      cow := kwexh_v * AMEXA7000_2.CO_L;  //CO  Concentration (WET Exhaust) (%, m/m)

      gexhwc := (FC * Carbon * exhdens_v * 10000.0)
                       / (awc * (co2w * 10000.0 / mvco2 + cow / mvco +
                       AMEXA7000_2.non_CH4 / mvhc + cwet / awc +
                       AMEXA7000_2.CH4/mvch4) ); // Wet Exhaust Mass Flow based on Carbon Balance (㎏/h)

      sefc := gexhwc/GeneratorOutput; //Specific Wet Exhaust Mass Flow based on Carbon Balance (㎏/kWh)
      factor1 := 10000.0*mwo2*o2w/mvo2 - awo*cow/mvco + awo*now/mvno +
                2.0*awo*no2wet/mvno2 - 3.0*awo*AMEXA7000_2.non_CH4/mvhc -
                2.0*awo*cwet/awc;
      factor2 := Hydrogen*awo/(2.0*awh) + Carbon * 2.0*awo/awc +
                  2.0*Sulfur*awo/aws;
      gexhwo := FC*( (factor1/(1000.0*exhdens_v) + 10.*factor2 - 10*Oxygen)
                               /(10.0*tau - factor1/(1000.0*exhdens_v)) + 1.0);
                             // Wet Exhaust Mass Flow based on Oxygen Balance (㎏/h)
      sefo := gexhwo/GeneratorOutput; //Specific Wet Exhaust Mass Flow based on Oxygen Balance (㎏/kWh)
      gexhw := (gexhwc + gexhwo)/2; // Wet Exhaust Mass Flow based on Carbon and Oxygen Balance (㎏/h)
      sef := (sefo + sefc)/2; //Specific Wet Exhaust Mass Flow based on Carbon and Oxygen Balance (㎏/kWh)

      if sef <> 0 then
        devsef := (sefo - sefc)/sef*100.0; //(%)

      gairw := gexhw - FC; //(㎏/h)
      vexhw1 := gexhw/exhdens_v; //(㎥/h)
      vco := cow*vexhw1/1000000.0; //(㎥/h)
      vno := now*vexhw1/1000000.0; //(㎥/h)
      vno2 := no2wet*vexhw1/1000000.0; //(㎥/h)
      vhc := AMEXA7000_2.THC*vexhw1/1000000.0; //(㎥/h)
      vh2o := ( (gairw*nue*mvh2o)/mwh2o +
              (FC*Hydrogen*mvh2o)/(2.0*awh) )/100.0 - vhc; //(㎥/h)

      // ************** Rectification of calculation for Vco2 volumetric exh. gas composition from dated 2003.02.17 ***************
      //vco2 := ( (gairw*mvair*co2air)/mwair +
      //        (FEngineMonitoringData.FC*FEngineMonitoringData.Carbon*mvco2)/awc)/100.0 -
      //        vco - vhc - (cwet*gexhw/exhdens_v/1000000.0)*(mwo2/awc); //(㎥/h)
      vco2 := co2w * vexhw1 / 100;

      tau2 := (FC/gairw) *
              (Hydrogen*awo/(2.0*awh) +
              Carbon*2.0*awo/awc +
              Sulfur*2.0*awo/aws); //(㎥/h)

      // ************** Rectification of calculation for Vo2 volumetric exh. gas composition  from dated 2003.02.17 ***************
      vo2 := gairw*(tau-tau2)/100.0*(mvo2/mwo2) +
                       (3.0*vhc+vco)/2.0 - (vno+2.0*vno2)/2.0 +
                       (cwet*gexhw/exhdens_v/1000000.0)*(mwo2/awc) +
                       (Oxygen*mvo2*FC)/(mwo2*100.0); //(㎥/h)

      vn2 := (gairw*eta*mvn2/mwn2 +
              FC*Nitrogen*mvn2/mwn2)/100.0 -
              (vno+vno2)/2.0; //(㎥/h)
      varx := (gairw*arair*mvar)/(100.0*mwar); //(㎥/h)
      vso2 := (FC*Sulfur*mvso2)/(100.0*aws); //(㎥/h)
      vch4 := AMEXA7000_2.CH4 * vexhw1 / 1000000;
      vexhw2 := vh2o + vco2 + vo2 + vn2 + vso2 +
                        vco + vno + vno2 + vhc + varx + vch4; //(㎥/h)
      vexhd := vexhw2 - vh2o; //(㎥/h)

      exhdens := gexhw/vexhw2; //Density of Wet Exhaust Gas (㎏/㎥)
      Gap := abs(exhdens - exhdens_v);

      if ( Gap < 0.0000006 ) then
      begin
         kexh := vexhd/vexhw2;
         egf := gexhw; //Exhaust Gas Flow (㎏/h)
      end;

      exhdens_v := exhdens_v + 0.000001;
    end;//while
  except on Exception do ;
  end;

//  if not FEngineMonitoringData.UseInputDensity then
//    FEngineMonitoringData.Density := exhdens;//Density of Wet Exhaust Gas (㎏/㎥)
end;

procedure TEngineMonitoringData.FuelComposition_Calc;
begin
  try
    Hydrogen := awh * (4*CH4 + 6*C2H6 + 8*C3H8 +
                        10*C4H10 + 12*C5H12)/
                        (awch4*CH4 + awc2h6*C2H6 + awc3h8*C3H8 +
                        awc4h10*C4H10 + awc5h12*C5H12) * 100;

    Carbon := awc * (1*CH4 + 2*C2H6 + 3*C3H8 +
                        4*C4H10 + 5*C5H12)/
                        (awch4*CH4 + awc2h6*C2H6 + awc3h8*C3H8 +
                        awc4h10*C4H10 + awc5h12*C5H12) * 100;

    Sulfur := 0;
    Nitrogen := 0;
    Oxygen := 0;
  except on Exception do
  end;
end;

//Intake Air Humidity(g/kg)
procedure TEngineMonitoringData.IntakeAirHumidigy_Calc;
var
  LTScc,
  LPcc,
  LPsc,
  LHsc: double;
begin
  SVP_Calc;

  try
    IAH2 := (6.22 * IAH * SVP) /
                    (BP - SVP * IAH / 100);
    LTScc := SAT + 273.15;
    LPcc := SAP * 0.980665 * 100 + BP;
    LPsc := 1.013 * exp(19.008 - (5325.35 / LTScc));
    LHsc := (6.220 * LPsc * 100)/(LPcc - LPsc);

    if IAH2 > LHsc then
      IAH2 := LHsc;
  except on Exception do
  end;
end;

//공기 과잉율 = 실제 흡입한 공기량 / 완전연소에 필요한 이론 공기량
procedure TEngineMonitoringData.Lamda_Calc;
begin
  try
    FAFRatio_Calculated := AF1 / FC;
//    AirFuelRatioAnalog.Value := FAFRatio_Calculated;
//    AirFuelRatioAnalog.Value := FAFRatio_Calculated;
    FLamda_Calculated := FAFRatio_Calculated/StoichiometricRatio;
//    LamdaAnalog.Value := FLamda_Calculated;
  except on Exception do
  end;
end;

procedure TEngineMonitoringData.NhtCF_Calc;
var
  LTIA,
  LTSC,
  LTSCREF: double;
begin
  LTIA := IntakeAirTemp + 273.15;
  LTSC := SAT + 273.15;
  LTSCREF := IART + 273.15;
  NhtCF := 1/((1 - 0.012 * (IAH2-10.71) - 0.00275 * (LTIA-298) +
              0.00285 * (LTSC-LTSCREF)));
end;

procedure TEngineMonitoringData.NoxCorrectionFactor_Calc;
begin

end;

procedure TEngineMonitoringData.SVP_Calc;
begin
  try
    SVP := (4.856884 + 0.2660089 * IntakeAirTemp +
         0.01688919 * Power(IntakeAirTemp,2) -
         7.477123 * Power(10,-5) * Power(IntakeAirTemp,3) +
         8.10525 * Power(10,-6) * Power(IntakeAirTemp,4) -
         3.115221 * Power(10,-8) * Power(IntakeAirTemp,5)) * (101.32/760);
  except on Exception do
  end;
end;

procedure TEngineMonitoringData.UFC_Calc;
begin
  try
    if GeneratorOutput <> 0 then
      UFC := FC / GeneratorOutput * 1000
    else
    begin
//      DisplayMessage('GeneratorOutput = 0!');
    end;
  except on Exception do
  end;
end;

{ TEngineLoadTableCollect }
//Engine 출력이 ALoad(kW) 일때 발전기 효율 값 반환
function TEngineLoadTableCollect<T>.GetGenEfficiency(ALoad: Double): double;
var
  Li: integer;
  LOutput: double;
begin
  Result := 0.0;

  for Li := 0 to Count - 1 do
  begin
    LOutput := Items[Li].GenOutput;
    if ALoad <= LOutput then
    begin
      Result := Items[Li].GenEfficiency;
      break;
    end;
  end;
end;

end.
