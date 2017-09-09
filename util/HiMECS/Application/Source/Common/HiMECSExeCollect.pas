unit HiMECSExeCollect;

interface

uses classes, SysUtils, BaseConfigCollect;

type
  THiMECSExeCollect = class;
  THiMECSExeItem = class;

  THiMECSExes = class(TpjhBase)
    FExeCollect: THiMECSExeCollect;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

  published
    property ExeCollect: THiMECSExeCollect read FExeCollect write FExeCollect;
  end;

  THiMECSExeItem = class(TCollectionItem)
  private
    FAllowLevel: integer;
    FExeName: string; //(*.exe)
    FFilePath: string;//
  published
    property AllowLevel: integer read FAllowLevel write FAllowLevel;
    property ExeName: string read FExeName write FExeName;
    property FilePath: string read FFilePath write FFilePath;
  end;

  THiMECSExeCollect = class(TCollection)
  private
    function GetItem(Index: Integer): THiMECSExeItem;
    procedure SetItem(Index: Integer; const Value: THiMECSExeItem);
  public
    function  Add: THiMECSExeItem;
    function Insert(Index: Integer): THiMECSExeItem;
    property Items[Index: Integer]: THiMECSExeItem read GetItem  write SetItem; default;
  end;

implementation

function THiMECSExeCollect.Add: THiMECSExeItem;
begin
  Result := THiMECSExeItem(inherited Add);
end;

function THiMECSExeCollect.GetItem(Index: Integer): THiMECSExeItem;
begin
  Result := THiMECSExeItem(inherited Items[Index]);
end;

function THiMECSExeCollect.Insert(Index: Integer): THiMECSExeItem;
begin
  Result := THiMECSExeItem(inherited Insert(Index));
end;

procedure THiMECSExeCollect.SetItem(Index: Integer; const Value: THiMECSExeItem);
begin
  Items[Index].Assign(Value);
end;

{ THiMECSConfig }

constructor THiMECSExes.Create(AOwner: TComponent);
begin
  FExeCollect := THiMECSExeCollect.Create(THiMECSExeItem);

end;

destructor THiMECSExes.Destroy;
begin
  inherited Destroy;
  FExeCollect.Free;
end;

end.
