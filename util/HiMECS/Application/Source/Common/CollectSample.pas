unit CollectSample;

interface

uses classes, BaseConfigCollect;

type
  TEngineParameterCollect = class;
  TEngineParameterItem = class;

  TEngineParameter = class(TpjhBase)
  private
    FEngineParameterCollect: TEngineParameterCollect;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
  published
    property EngineParameterCollect: TEngineParameterCollect read FEngineParameterCollect write FEngineParameterCollect;
  end;

  TEngineParameterItem = class(TCollectionItem)
  private
  published
  end;

  TEngineParameterCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TEngineParameterItem;
    procedure SetItem(Index: Integer; const Value: TEngineParameterItem);
  public
    function  Add: TEngineParameterItem;
    function Insert(Index: Integer): TEngineParameterItem;
    property Items[Index: Integer]: TEngineParameterItem read GetItem  write SetItem; default;
  end;

implementation

{ TEngineParameter }

constructor TEngineParameter.Create(AOwner: TComponent);
begin
  FEngineParameterCollect := TEngineParameterCollect.Create(TEngineParameterItem);
end;

destructor TEngineParameter.Destroy;
begin
  inherited Destroy;
  FEngineParameterCollect.Free;
end;

{ TEngineParameterCollect }

function TEngineParameterCollect.Add: TEngineParameterItem;
begin
  Result := TEngineParameterItem(inherited Add);
end;

function TEngineParameterCollect.GetItem(Index: Integer): TEngineParameterItem;
begin
  Result := TEngineParameterItem(inherited Items[Index]);
end;

function TEngineParameterCollect.Insert(Index: Integer): TEngineParameterItem;
begin
  Result := TEngineParameterItem(inherited Insert(Index));
end;

procedure TEngineParameterCollect.SetItem(Index: Integer;
  const Value: TEngineParameterItem);
begin
  Items[Index].Assign(Value);
end;

end.
