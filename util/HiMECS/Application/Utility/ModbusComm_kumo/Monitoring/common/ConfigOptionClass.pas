unit ConfigOptionClass;

interface

uses classes, BaseConfigCollect;

type
  TConfigOptionCollect = class;
  TConfigOptionItem = class;

  TConfigOption = class(TpjhBase)
  private
    FConfigOptionCollect: TConfigOptionCollect;

    FModbusFileName: string;
    FAverageSize: integer;
    FRunningRPM: integer; //Engine Running 을 판단하는 RPM
    FNotRunningRPM: integer; //Engine Running 을 판단하는 RPM
    FUseECUEngineRunningSignal: Boolean; //Engine Running 을 판단하는 RPM
    FRunHour: Int64;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

  published
    property ConfigOptionCollect: TConfigOptionCollect read FConfigOptionCollect write FConfigOptionCollect;

    property ModbusFileName: string read FModbusFileName write FModbusFileName;
    property AverageSize: integer read FAverageSize write FAverageSize;
    property RunningRPM: integer read FRunningRPM write FRunningRPM;
    property NotRunningRPM: integer read FNotRunningRPM write FNotRunningRPM;
    property UseECUEngineRunningSignal: Boolean read FUseECUEngineRunningSignal write FUseECUEngineRunningSignal;
    property RunHour: Int64 read FRunHour write FRunHour;
  end;

  TConfigOptionItem = class(TCollectionItem)
  private
  published
    //property PartName: string read FPartName write FPartName;
  end;

  TConfigOptionCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TConfigOptionItem;
    procedure SetItem(Index: Integer; const Value: TConfigOptionItem);
  public
    function  Add: TConfigOptionItem;
    function Insert(Index: Integer): TConfigOptionItem;
    property Items[Index: Integer]: TConfigOptionItem read GetItem  write SetItem; default;
  end;

implementation

{ TInternalCombustionEngine }

constructor TConfigOption.Create(AOwner: TComponent);
begin
  FConfigOptionCollect := TConfigOptionCollect.Create(TConfigOptionItem);
end;

destructor TConfigOption.Destroy;
begin
  inherited Destroy;
  
  FConfigOptionCollect.Free;
end;

{ TConfigOptionCollect }

function TConfigOptionCollect.Add: TConfigOptionItem;
begin
  Result := TConfigOptionItem(inherited Add);
end;

function TConfigOptionCollect.GetItem(Index: Integer): TConfigOptionItem;
begin
  Result := TConfigOptionItem(inherited Items[Index]);
end;

function TConfigOptionCollect.Insert(Index: Integer): TConfigOptionItem;
begin
  Result := TConfigOptionItem(inherited Insert(Index));
end;

procedure TConfigOptionCollect.SetItem(Index: Integer; const Value: TConfigOptionItem);
begin
  Items[Index].Assign(Value);
end;

end.
