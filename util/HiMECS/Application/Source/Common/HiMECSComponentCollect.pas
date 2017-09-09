unit HiMECSComponentCollect;

interface

uses classes, SysUtils, BaseConfigCollect;

type
  THiMECSComponentCollect = class;
  THiMECSComponentItem = class;

  THiMECSComponents = class(TpjhBase)
    FPackageCollect: THiMECSComponentCollect;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

  published
    property PackageCollect: THiMECSComponentCollect read FPackageCollect write FPackageCollect;
  end;

  THiMECSComponentItem = class(TCollectionItem)
  private
    FAllowLevel: integer;
    FPageName: string;//Logic=TpjhStartControl;TpjhStopControl
    FPackageName: string; //(*.bpl)
    FFilePath: string;//
    FCreateFuncName: string;//
  published
    property AllowLevel: integer read FAllowLevel write FAllowLevel;
    property PageName: string read FPageName write FPageName;
    property PackageName: string read FPackageName write FPackageName;
    property FilePath: string read FFilePath write FFilePath;
    property CreateFuncName: string read FCreateFuncName write FCreateFuncName;
  end;

  THiMECSComponentCollect = class(TCollection)
  private
    function GetItem(Index: Integer): THiMECSComponentItem;
    procedure SetItem(Index: Integer; const Value: THiMECSComponentItem);
  public
    function  Add: THiMECSComponentItem;
    function Insert(Index: Integer): THiMECSComponentItem;
    property Items[Index: Integer]: THiMECSComponentItem read GetItem  write SetItem; default;
  end;

implementation

function THiMECSComponentCollect.Add: THiMECSComponentItem;
begin
  Result := THiMECSComponentItem(inherited Add);
end;

function THiMECSComponentCollect.GetItem(Index: Integer): THiMECSComponentItem;
begin
  Result := THiMECSComponentItem(inherited Items[Index]);
end;

function THiMECSComponentCollect.Insert(Index: Integer): THiMECSComponentItem;
begin
  Result := THiMECSComponentItem(inherited Insert(Index));
end;

procedure THiMECSComponentCollect.SetItem(Index: Integer; const Value: THiMECSComponentItem);
begin
  Items[Index].Assign(Value);
end;

{ THiMECSConfig }

constructor THiMECSComponents.Create(AOwner: TComponent);
begin
  FPackageCollect := THiMECSComponentCollect.Create(THiMECSComponentItem);

end;

destructor THiMECSComponents.Destroy;
begin
  inherited Destroy;
  FPackageCollect.Free;
end;

end.
