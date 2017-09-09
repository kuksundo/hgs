unit GeneratorEfficiencyClass;

interface

uses classes, BaseConfigCollect;

type
  TGeneratorEfficiencyCollect = class;
  TGeneratorEfficiencyItem = class;

  TGeneratorEfficiency = class(TpjhBase)
  private
    FGeneratorEfficiencyCollect: TGeneratorEfficiencyCollect;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Clear;
  published
    property GeneratorEfficiencyCollect: TGeneratorEfficiencyCollect read FGeneratorEfficiencyCollect write FGeneratorEfficiencyCollect;
  end;

  TGeneratorEfficiencyItem = class(TCollectionItem)
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


  TGeneratorEfficiencyCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TGeneratorEfficiencyItem;
    procedure SetItem(Index: Integer; const Value: TGeneratorEfficiencyItem);
  public
    function  Add: TGeneratorEfficiencyItem;
    function Insert(Index: Integer): TGeneratorEfficiencyItem;
    property Items[Index: Integer]: TGeneratorEfficiencyItem read GetItem  write SetItem; default;
  end;

implementation

{ TProjectEfficiencyCollect }

function TGeneratorEfficiencyCollect.Add: TGeneratorEfficiencyItem;
begin
  Result := TGeneratorEfficiencyItem(inherited Add);
end;

function TGeneratorEfficiencyCollect.GetItem(Index: Integer): TGeneratorEfficiencyItem;
begin
  Result := TGeneratorEfficiencyItem(inherited Items[Index]);
end;

function TGeneratorEfficiencyCollect.Insert(Index: Integer): TGeneratorEfficiencyItem;
begin
  Result := TGeneratorEfficiencyItem(inherited Insert(Index));
end;

procedure TGeneratorEfficiencyCollect.SetItem(Index: Integer;
  const Value: TGeneratorEfficiencyItem);
begin
  Items[Index].Assign(Value);
end;

{ TProjectEfficiency }

procedure TGeneratorEfficiency.Clear;
begin
;
end;

constructor TGeneratorEfficiency.Create(AOwner: TComponent);
begin
  FGeneratorEfficiencyCollect := TGeneratorEfficiencyCollect.Create(TGeneratorEfficiencyItem);
end;

destructor TGeneratorEfficiency.Destroy;
begin
  inherited Destroy;

  FGeneratorEfficiencyCollect.Free;
end;

end.
