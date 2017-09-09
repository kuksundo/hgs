unit EngineBaseClass_Old;

interface

uses classes, SysUtils, math, BaseConfigCollect, EngineConst;

type
  TICEngineCollect = class;
  TICEngineItem = class;

  TInternalCombustionEngine = class(TpjhBase)
  private
    FICEngineCollect: TICEngineCollect;

    FBore: integer;  //mm
    FStroke: integer; //mm
    FCylinderCount: integer;
    FRatedSpeed: integer;//RPM
    FRatedPower_Engine: Double; //(kW)
    FRatedPower_Generator: Double; //(kW)
    FFrequency: Double; //(Hz) Only for Genset
    FSFOC: Double; //Specific Fuel Oil Consumption(g/kWh)
    FIVO,  //Intake Valve Open timing
    FIVC,  //Intake Valve Close timing
    FEVO,  //Exhaust Valve Open timing
    FEVC: integer;//Exhaust Valve Close timing

    FFiringOrder: string;
    FCylinderConfiguration: TCylinderConfiguration;
    FFuelType: TFuelType;

    FDimension_A,
    FDimension_B,
    FDimension_C,
    FDimension_D: Double;//m
    FEngineWeight,
    FGenSetWeight: Double;//ton

    FStoichiometricRatio: double;//(kg/kg) 이론 공연비(연료에 따라 다름)
    FLCV: integer;    //저위발열량(Low Caloric Value)

    //====Measured or Calculation Values====
    FBMEP,
    FEngineOutput: Double; //Calculated(kW/h)
    FGeneratorOutput: Double; //Measured(kW/h)
    FFC: double;//Fuel Consumption(kg/h)
    FEfficiency: double;//(%)

{    FTurboCharger,
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
}
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Clear;

    function GetEngineType(AIndex: integer): string;

    procedure Efficiency_Calc;
    procedure BMEP_Calc;
    Procedure EngineLoad_Calc;

  published
    property ICEngineCollect: TICEngineCollect read FICEngineCollect write FICEngineCollect;

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

    property GeneratorOutput: Double read FGeneratorOutput write FGeneratorOutput;

    property StoichiometricRatio: double read FStoichiometricRatio write FStoichiometricRatio;
    property Efficiency: double read FEfficiency write FEfficiency;
    property FC: double read FFC write FFC;
    property LCV: integer read FLCV write FLCV;
  end;

  TICEngineItem = class(TCollectionItem)
  private
    FPartName: string;
    FMaker: string;
    FType: string;
    FSerialNo: string;
  published
    property PartName: string read FPartName write FPartName;
    property Maker: string read FMaker write FMaker;
    property FFType: string read FType write FType;
    property SerialNo: string read FSerialNo write FSerialNo;
  end;

  TICEngineCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TICEngineItem;
    procedure SetItem(Index: Integer; const Value: TICEngineItem);
  public
    function  Add: TICEngineItem;
    function Insert(Index: Integer): TICEngineItem;
    property Items[Index: Integer]: TICEngineItem read GetItem  write SetItem; default;
  end;

  TDieselEngine = class(TInternalCombustionEngine)
  private
  published
  end;

  TGasEngine = class(TInternalCombustionEngine)
  private
    FGasFlow: double;  //Gas Flow(m³/h)
    FGasTemp,
    FGasPress: double;
  public

  published
    property GasFlow: double read FGasFlow write FGasFlow;
    property GasTemp: double read FGasTemp write FGasTemp;
    property GasPress: double read FGasPress write FGasPress;
  end;

  TDFEngine = class(TInternalCombustionEngine)
  private
  published
  end;

  TCREngine = class(TInternalCombustionEngine)
  private
  published
  end;

implementation

{ TInternalCombustionEngine }

procedure TInternalCombustionEngine.BMEP_Calc;
begin
  try
  // (75 * 60 * BHP) / ((Pi/4) * (Bore)2 * Stroke * Cylinder 수 * MCR
  //FBMEP := ((75 * 60 * FOptions.GeneratorOutput * 1000)/
  //          (PiOn4 * Power(FOptions.Bore/100, 2) * FOptions.Stroke/100 *
  //          FOptions.CylinderCount * FOptions.MCR/60))/1.0197;
  //  Button1.Caption := Format('%.2f', [FBMEP]);
    //FBMEP2 := (FEngineOutput * 1.35962) /
    //        (PiOn4 * Power(FOptions.Bore, 2) * FOptions.Stroke *
    //        FOptions.CylinderCount * FOptions.MCR);

    //FBMEP := ((FOptions.GeneratorOutput * 1000)/
    //        (PiOn4 * Power(FOptions.Bore/100, 2) * FOptions.Stroke/100 *
    //        FOptions.CylinderCount * FOptions.MCR/60))/100000;
    //Button2.Caption := Format('%.2f', [FBMEP]);

    //FBMEP := 1200*FEngineOutput/(FOptions.CylinderCount*38.48451)/FOptions.MCR;
    FBMEP := 1200*FEngineOutput/
    (CylinderCount*(PiOn4 * Power(Bore, 2) * Stroke)/1000)/RatedSpeed;
  except on Exception do
  end;
end;

procedure TInternalCombustionEngine.Clear;
begin
  ICEngineCollect.Clear;

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

   GeneratorOutput := 0;

   StoichiometricRatio := 0;
   Efficiency := 0;
   FC := 0;
   LCV := 0;
end;

constructor TInternalCombustionEngine.Create(AOwner: TComponent);
begin
  FICEngineCollect := TICEngineCollect.Create(TICEngineItem);
end;

destructor TInternalCombustionEngine.Destroy;
begin
  inherited Destroy;
  FICEngineCollect.Free;
end;

procedure TInternalCombustionEngine.Efficiency_Calc;
begin
  try
  //if (FOptions.GasFlow <> 0) and (FOptions.GasTemp <> 0) and
  //   (FOptions.GasPress <> 0) and (FOptions.GeneratorOutput <> 0) and
   //  (FOptions.LCV <> 0) then
    //FOptions.Efficiency := (FOptions.GeneratorOutput /
    // ( FOptions.LCV * FOptions.Density * FOptions.GasFlow * FOptions.GasPress /
    //  1013.25 * 273 / (273 + FOptions.GasTemp) ) /3600) * 100;
                      //Mass Flow Gas
    //FOptions.Efficiency := (FOptions.GeneratorOutput /
    // ( FOptions.GasFlow * ( (25+273)/ FOptions.GasTemp * FOptions.GasPress * 0.805) *
    //     FOptions.LCV)/3600) * 100;
    //FOptions.Efficiency := 3600 /
    // ( FOptions.GasFlow * ( (25+273)/ FOptions.GasTemp * FOptions.GasPress * 0.805) *
    //    FOptions.GeneratorOutput * FOptions.LCV) * 100;
    //FOptions.Efficiency := FOptions.GeneratorOutput /
    // (FOptions.FC * FOptions.LCV / 3600) * 100;
    FEfficiency := (3600 * FEngineOutput) / (FC  * LCV) * 100;
  except on Exception do
  end;

end;

procedure TInternalCombustionEngine.EngineLoad_Calc;
begin

end;

function TInternalCombustionEngine.GetEngineType(AIndex: integer): string;
begin
  Result := IntToStr(CylinderCount) + 'H';
  Result := Result + IntToStr(Bore) + '/';
  Result := Result + IntToStr(Stroke);
  Result := Result + FuelType2DispName(FuelType);
  Result := Result + CylinderConfiguration2DispName(CylinderConfiguration);
end;

{ TICEngineCollect }

function TICEngineCollect.Add: TICEngineItem;
begin
  Result := TICEngineItem(inherited Add);
end;

function TICEngineCollect.GetItem(Index: Integer): TICEngineItem;
begin
  Result := TICEngineItem(inherited Items[Index]);
end;

function TICEngineCollect.Insert(Index: Integer): TICEngineItem;
begin
  Result := TICEngineItem(inherited Insert(Index));
end;

procedure TICEngineCollect.SetItem(Index: Integer; const Value: TICEngineItem);
begin
  Items[Index].Assign(Value);
end;

end.
