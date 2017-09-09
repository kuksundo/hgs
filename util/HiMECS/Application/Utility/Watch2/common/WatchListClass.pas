unit WatchListClass;

interface

uses classes, BaseConfigCollect;

type
  TWatchListCollect = class;
  TWatchListItem = class;

  TWatchList = class(TpjhBase)
  private
    FWatchListCollect: TWatchListCollect;

    FFilePath: string;//
    FExeName: string;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

  published
    property WatchListCollect: TWatchListCollect read FWatchListCollect write FWatchListCollect;
    property ExeName: string read FExeName write FExeName;
    property FilePath: string read FFilePath write FFilePath;
  end;

  TWatchListItem = class(TCollectionItem)
  private
    FAllowLevel: integer;
    FTagName: string;
  published
    property AllowLevel: integer read FAllowLevel write FAllowLevel;
    property TagName: string read FTagName write FTagName;
  end;

  TWatchListCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TWatchListItem;
    procedure SetItem(Index: Integer; const Value: TWatchListItem);
  public
    function  Add: TWatchListItem;
    function Insert(Index: Integer): TWatchListItem;
    property Items[Index: Integer]: TWatchListItem read GetItem  write SetItem; default;
  end;

implementation

{ TInternalCombustionEngine }

constructor TWatchList.Create(AOwner: TComponent);
begin
  FWatchListCollect := TWatchListCollect.Create(TWatchListItem);
end;

destructor TWatchList.Destroy;
begin
  inherited Destroy;

  FWatchListCollect.Free;
end;

{ TWatchListCollect }

function TWatchListCollect.Add: TWatchListItem;
begin
  Result := TWatchListItem(inherited Add);
end;

function TWatchListCollect.GetItem(Index: Integer): TWatchListItem;
begin
  Result := TWatchListItem(inherited Items[Index]);
end;

function TWatchListCollect.Insert(Index: Integer): TWatchListItem;
begin
  Result := TWatchListItem(inherited Insert(Index));
end;

procedure TWatchListCollect.SetItem(Index: Integer; const Value: TWatchListItem);
begin
  Items[Index].Assign(Value);
end;

end.
