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
    FDefaultSoundFileName: string;
    FAverageSize: integer; //평균을 위한 배열 size
    FDivisor: integer; //제수

    FNameFontSize,
    FValueFontSize: integer; //Display font size

    FSelectAlarmValue: integer;//0:not used, 1: original, 2: this
    FSelDisplayInterval: integer;//0: By Event, 1: By Timer
    FDisplayInterval: integer;

    FMinWarnValue: double; //Alarm보다 낮은 레벨
    FMaxWarnValue: double; //Alarm보다 낮은 레벨
    FMinAlarmValue: double;
    FMaxAlarmValue: double;

    FMinWarnColor: Longint; //Warn 발생시 표시색
    FMaxWarnColor: Longint;
    FMinAlarmColor: Longint;
    FMaxAlarmColor: Longint;

    FMinWarnBlink: Boolean; //Warn 발생시 Blink
    FMaxWarnBlink: Boolean;
    FMinAlarmBlink: Boolean;
    FMaxAlarmBlink: Boolean;
    FViewAvgValue: Boolean;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

  published
    property ConfigOptionCollect: TConfigOptionCollect read FConfigOptionCollect write FConfigOptionCollect;

    property ModbusFileName: string read FModbusFileName write FModbusFileName;
    property DefaultSoundFileName: string read FDefaultSoundFileName write FDefaultSoundFileName;
    property AverageSize: integer read FAverageSize write FAverageSize;
    property Divisor: integer read FDivisor write FDivisor;
    property NameFontSize: integer read FNameFontSize write FNameFontSize;
    property ValueFontSize: integer read FValueFontSize write FValueFontSize;
    property SelDisplayInterval: integer read FSelDisplayInterval write FSelDisplayInterval;
    property DisplayInterval: integer read FDisplayInterval write FDisplayInterval;

    property SelectAlarmValue: integer read FSelectAlarmValue write FSelectAlarmValue;
    property MinWarnValue: double read FMinWarnValue write FMinWarnValue;
    property MinAlarmValue: double read FMinAlarmValue write FMinAlarmValue;
    property MaxWarnValue: double read FMaxWarnValue write FMaxWarnValue;
    property MaxAlarmValue: double read FMaxAlarmValue write FMaxAlarmValue;
    property MinWarnColor: Longint read FMinWarnColor write FMinWarnColor;
    property MaxWarnColor: Longint read FMaxWarnColor write FMaxWarnColor;
    property MinAlarmColor: Longint read FMinAlarmColor write FMinAlarmColor;
    property MaxAlarmColor: Longint read FMaxAlarmColor write FMaxAlarmColor;
    property MinWarnBlink: Boolean read FMinWarnBlink write FMinWarnBlink;
    property MaxWarnBlink: Boolean read FMaxWarnBlink write FMaxWarnBlink;
    property MinAlarmBlink: Boolean read FMinAlarmBlink write FMinAlarmBlink;
    property MaxAlarmBlink: Boolean read FMaxAlarmBlink write FMaxAlarmBlink;
    property ViewAvgValue: Boolean read FViewAvgValue write FViewAvgValue;
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
