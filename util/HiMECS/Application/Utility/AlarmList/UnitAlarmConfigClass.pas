unit UnitAlarmConfigClass;

interface
uses classes, SysUtils, BaseConfigCollect;

type
  TAlarmConfigCollect = class;
  TAlarmConfigItem = class;

  TAlarmConfig = class(TpjhBase)
  private
    FAlarmConfigCollect: TAlarmConfigCollect;
    FAlarmDBDriver,
    FAlarmDBFileName: string;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

    procedure Clear;
  published
    property AlarmConfigCollect: TAlarmConfigCollect read FAlarmConfigCollect write FAlarmConfigCollect;
    property AlarmDBDriver: string read FAlarmDBDriver write FAlarmDBDriver;
    property AlarmDBFileName: string read FAlarmDBFileName write FAlarmDBFileName;
  end;

  TAlarmConfigItem = class(TCollectionItem)
  private
  published
  end;

  TAlarmConfigCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TAlarmConfigItem;
    procedure SetItem(Index: Integer; const Value: TAlarmConfigItem);
  public
    function  Add: TAlarmConfigItem;
    function Insert(Index: Integer): TAlarmConfigItem;
    property Items[Index: Integer]: TAlarmConfigItem read GetItem  write SetItem; default;
  end;

implementation

function TAlarmConfigCollect.Add: TAlarmConfigItem;
begin
  Result := TAlarmConfigItem(inherited Add);
end;

function TAlarmConfigCollect.GetItem(Index: Integer): TAlarmConfigItem;
begin
  Result := TAlarmConfigItem(inherited Items[Index]);
end;

function TAlarmConfigCollect.Insert(Index: Integer): TAlarmConfigItem;
begin
  Result := TAlarmConfigItem(inherited Insert(Index));
end;

procedure TAlarmConfigCollect.SetItem(Index: Integer; const Value: TAlarmConfigItem);
begin
  Items[Index].Assign(Value);
end;

{ TAlarmConfig }

procedure TAlarmConfig.Clear;
begin
  AlarmConfigCollect.Clear;
  AlarmDBDriver := '';
  AlarmDBFileName := '';
end;

constructor TAlarmConfig.Create(AOwner: TComponent);
begin
  FAlarmConfigCollect := TAlarmConfigCollect.Create(TAlarmConfigItem);
end;

destructor TAlarmConfig.Destroy;
begin
  inherited Destroy;
  FAlarmConfigCollect.Free;
end;

end.
