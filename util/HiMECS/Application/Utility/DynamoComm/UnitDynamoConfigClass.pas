unit UnitDynamoConfigClass;

interface

uses classes, SysUtils, BaseConfigCollect;

type
  TDynamoConfigCollect = class;
  TDynamoConfigItem = class;

  TDynamoConfig = class(TpjhBase)
  private
    FDynamoConfigCollect: TDynamoConfigCollect;
    FMyIP,
    FDestIP,
    FParamFileName: string;
    FMyPort,
    FDestPort: word;

    FQueryInterval: integer;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

    procedure Clear;
  published
    property DynamoConfigCollect: TDynamoConfigCollect read FDynamoConfigCollect write FDynamoConfigCollect;
    property DestIP: string read FDestIP write FDestIP;
    property DestPort: word read FDestPort write FDestPort;
    property MyIP: string read FMyIP write FMyIP;
    property MyPort: word read FMyPort write FMyPort;
    property QueryInterval: integer read FQueryInterval write FQueryInterval;
    property ParamFileName: string read FParamFileName write FParamFileName;
  end;

  TDynamoConfigItem = class(TCollectionItem)
  private
  published
  end;

  TDynamoConfigCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TDynamoConfigItem;
    procedure SetItem(Index: Integer; const Value: TDynamoConfigItem);
  public
    function  Add: TDynamoConfigItem;
    function Insert(Index: Integer): TDynamoConfigItem;
    property Items[Index: Integer]: TDynamoConfigItem read GetItem  write SetItem; default;
  end;

implementation

function TDynamoConfigCollect.Add: TDynamoConfigItem;
begin
  Result := TDynamoConfigItem(inherited Add);
end;

function TDynamoConfigCollect.GetItem(Index: Integer): TDynamoConfigItem;
begin
  Result := TDynamoConfigItem(inherited Items[Index]);
end;

function TDynamoConfigCollect.Insert(Index: Integer): TDynamoConfigItem;
begin
  Result := TDynamoConfigItem(inherited Insert(Index));
end;

procedure TDynamoConfigCollect.SetItem(Index: Integer; const Value: TDynamoConfigItem);
begin
  Items[Index].Assign(Value);
end;

{ TAlarmConfig }

procedure TDynamoConfig.Clear;
begin
  DynamoConfigCollect.Clear;
  DestIP := '';
  DestPort := 0;
  MyIP := '';
  MyPort := 0;
end;

constructor TDynamoConfig.Create(AOwner: TComponent);
begin
  DynamoConfigCollect := TDynamoConfigCollect.Create(TDynamoConfigItem);
end;

destructor TDynamoConfig.Destroy;
begin
  inherited Destroy;
  DynamoConfigCollect.Free;
end;

end.
