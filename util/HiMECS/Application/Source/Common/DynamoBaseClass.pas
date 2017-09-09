unit DynamoBaseClass;

interface

uses classes, BaseConfigCollect;

type
  TDynamoInfoCollect = class;
  TDynamoInfoItem = class;

  TDynamoInfo = class(TpjhBase)
  private
    FDynamoInfoCollect: TDynamoInfoCollect;

    FDynamoType,
    FSerialNo,
    FMaxPower,
    FMaxSpeed,
    FMaxTorque : string;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Clear;
  published
    property DynamoInfoCollect: TDynamoInfoCollect read FDynamoInfoCollect write FDynamoInfoCollect;

    property DynamoType: string read FDynamoType write FDynamoType;
    property SerialNo: string read FSerialNo write FSerialNo;
    property MaxPower: string read FMaxPower write FMaxPower;
    property MaxSpeed: string read FMaxSpeed write FMaxSpeed;
    property MaxTorque: string read FMaxTorque write FMaxTorque;
  end;

  TDynamoInfoItem = class(TCollectionItem)
  private
    FEngineLoad: integer; //(%)
    FDynamoOutput: double;//(kW)
    FGenEfficiency: double;//
  published
    property EngineLoad: integer read FEngineLoad write FEngineLoad;
    property DynamoOutput: double read FDynamoOutput write FDynamoOutput;
    property GenEfficiency: double read FGenEfficiency write FGenEfficiency;
  end;

  TDynamoInfoCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TDynamoInfoItem;
    procedure SetItem(Index: Integer; const Value: TDynamoInfoItem);
  public
    function  Add: TDynamoInfoItem;
    function Insert(Index: Integer): TDynamoInfoItem;
    property Items[Index: Integer]: TDynamoInfoItem read GetItem  write SetItem; default;
  end;

implementation

{ TProjectInfoCollect }

function TDynamoInfoCollect.Add: TDynamoInfoItem;
begin
  Result := TDynamoInfoItem(inherited Add);
end;

function TDynamoInfoCollect.GetItem(Index: Integer): TDynamoInfoItem;
begin
  Result := TDynamoInfoItem(inherited Items[Index]);
end;

function TDynamoInfoCollect.Insert(Index: Integer): TDynamoInfoItem;
begin
  Result := TDynamoInfoItem(inherited Insert(Index));
end;

procedure TDynamoInfoCollect.SetItem(Index: Integer;
  const Value: TDynamoInfoItem);
begin
  Items[Index].Assign(Value);
end;

{ TProjectInfo }

procedure TDynamoInfo.Clear;
begin
;
end;

constructor TDynamoInfo.Create(AOwner: TComponent);
begin
  FDynamoInfoCollect := TDynamoInfoCollect.Create(TDynamoInfoItem);
end;

destructor TDynamoInfo.Destroy;
begin
  inherited Destroy;

  FDynamoInfoCollect.Free;
end;

end.
