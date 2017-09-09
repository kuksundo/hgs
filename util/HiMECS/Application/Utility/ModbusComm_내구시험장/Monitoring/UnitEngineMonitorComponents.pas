unit UnitEngineMonitorComponents;

interface

uses classes, SysUtils, BaseConfigCollect;

type
  TMonitorComponentCollect = class;
  TMonitorComponentItem = class;

  TMonitorComponents = class(TpjhBase)
  private
    FMonitorComponentCollect: TMonitorComponentCollect;

    FECU: string;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

  published
    property MonitorComponentCollect: TMonitorComponentCollect read FMonitorComponentCollect write FMonitorComponentCollect;
  end;

  TMonitorComponentItem = class(TCollectionItem)
  private
  published
    //property SerialNo: string read FSerialNo write FSerialNo;
  end;

  TMonitorComponentCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TMonitorComponentItem;
    procedure SetItem(Index: Integer; const Value: TMonitorComponentItem);
  public
    function  Add: TMonitorComponentItem;
    function Insert(Index: Integer): TMonitorComponentItem;
    property Items[Index: Integer]: TMonitorComponentItem read GetItem  write SetItem; default;
  end;

implementation

constructor TMonitorComponents.Create(AOwner: TComponent);
begin
  FMonitorComponentCollect := TMonitorComponentCollect.Create(TMonitorComponentItem);
end;

destructor TMonitorComponents.Destroy;
begin
  inherited Destroy;
  FMonitorComponentCollect.Free;
end;

{ TMonitorComponentCollect }

function TMonitorComponentCollect.Add: TMonitorComponentItem;
begin
  Result := TMonitorComponentItem(inherited Add);
end;

function TMonitorComponentCollect.GetItem(Index: Integer): TMonitorComponentItem;
begin
  Result := TMonitorComponentItem(inherited Items[Index]);
end;

function TMonitorComponentCollect.Insert(Index: Integer): TMonitorComponentItem;
begin
  Result := TMonitorComponentItem(inherited Insert(Index));
end;

procedure TMonitorComponentCollect.SetItem(Index: Integer; const Value: TMonitorComponentItem);
begin
  Items[Index].Assign(Value);
end;

end.
