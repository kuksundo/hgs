unit GeneratorBaseClass;

interface

uses classes, BaseConfigCollect;

type
  TGeneratorInfoCollect = class;
  TGeneratorInfoItem = class;

  TGeneratorInfo = class(TpjhBase)
  private
    FGeneratorInfoCollect: TGeneratorInfoCollect;

    FGeneratorType,
    FSerialNo,
    FApparentPower, //피상전력 (kVA)
    FActivePower, //유효전력 (W) = kVA * cos
    FReactivePower,//무효전력 (VAR) = kVA * sin
    FPowerFactor,
    FVoltage,
    FFrequency,
    FPoles,
    FSpecificTemp,
    FCurrentRatio,
    FRarm,
    FRfld,
    FRfld_temp : string;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Clear;
  published
    property GeneratorInfoCollect: TGeneratorInfoCollect read FGeneratorInfoCollect write FGeneratorInfoCollect;

    property GeneratorType: string read FGeneratorType write FGeneratorType;
    property SerialNo: string read FSerialNo write FSerialNo;
    property ApparentPower: string read FApparentPower write FApparentPower;
    property ActivePower: string read FActivePower write FActivePower;
    property ReactivePower: string read FReactivePower write FReactivePower;
    property PowerFactor: string read FPowerFactor write FPowerFactor;
    property Voltage: string read FVoltage write FVoltage;
    property Frequency: string read FFrequency write FFrequency;
    property Poles: string read FPoles write FPoles;
    property SpecificTemp: string read FSpecificTemp write FSpecificTemp;
    property CurrentRatio: string read FCurrentRatio write FCurrentRatio;
    property Rarm: string read FRarm write FRarm;
    property Rfld: string read FRfld write FRfld;
    property Rfld_temp: string read FRfld_temp write FRfld_temp;
  end;

  TGeneratorInfoItem = class(TCollectionItem)
  private
    FEngineLoad: integer; //(%)
    FGenOutput: double;//(kW)
    FGenCurrent: double;//(A)
    FExc_Amps: double;//(A)
    FField_Amps: double;//(A)
    FMech_Loss: double;//(kW)
    FCore_Loss: double;//(kW)
    FArm_Copper: double;//(kW)
    FFld_Copper: double;//(kW)
    FStrayLoad: double;//(kW)
    FTotalLoss: double;//(kW)
    FGenInput: double;//(kW)
    FGenEfficiency: double;//
  published
    property EngineLoad: integer read FEngineLoad write FEngineLoad;
    property GenOutput: double read FGenOutput write FGenOutput;
    property GenCurrent: double read FGenCurrent write FGenCurrent;
    property Exc_Amps: double read FExc_Amps write FExc_Amps;
    property Field_Amps: double read FField_Amps write FField_Amps;
    property Mech_Loss: double read FMech_Loss write FMech_Loss;
    property Core_Loss: double read FCore_Loss write FCore_Loss;
    property Arm_Copper: double read FArm_Copper write FArm_Copper;
    property Fld_Copper: double read FFld_Copper write FFld_Copper;
    property StrayLoad: double read FStrayLoad write FStrayLoad;
    property TotalLoss: double read FTotalLoss write FTotalLoss;
    property GenInput: double read FGenInput write FGenInput;
    property GenEfficiency: double read FGenEfficiency write FGenEfficiency;
  end;

  TGeneratorInfoCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TGeneratorInfoItem;
    procedure SetItem(Index: Integer; const Value: TGeneratorInfoItem);
  public
    function  Add: TGeneratorInfoItem;
    function Insert(Index: Integer): TGeneratorInfoItem;
    property Items[Index: Integer]: TGeneratorInfoItem read GetItem  write SetItem; default;
  end;

implementation

{ TProjectInfoCollect }

function TGeneratorInfoCollect.Add: TGeneratorInfoItem;
begin
  Result := TGeneratorInfoItem(inherited Add);
end;

function TGeneratorInfoCollect.GetItem(Index: Integer): TGeneratorInfoItem;
begin
  Result := TGeneratorInfoItem(inherited Items[Index]);
end;

function TGeneratorInfoCollect.Insert(Index: Integer): TGeneratorInfoItem;
begin
  Result := TGeneratorInfoItem(inherited Insert(Index));
end;

procedure TGeneratorInfoCollect.SetItem(Index: Integer;
  const Value: TGeneratorInfoItem);
begin
  Items[Index].Assign(Value);
end;

{ TProjectInfo }

procedure TGeneratorInfo.Clear;
begin
;
end;

constructor TGeneratorInfo.Create(AOwner: TComponent);
begin
  FGeneratorInfoCollect := TGeneratorInfoCollect.Create(TGeneratorInfoItem);
end;

destructor TGeneratorInfo.Destroy;
begin
  inherited Destroy;

  FGeneratorInfoCollect.Free;
end;

end.
