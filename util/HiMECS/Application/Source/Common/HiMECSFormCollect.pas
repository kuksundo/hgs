unit HiMECSFormCollect;

interface

uses classes, SysUtils, BaseConfigCollect;

type
  TCreateChildFromBPL = function : string;
  THiMECSFormCollect = class;
  THiMECSFormItem = class;

  THiMECSForms = class(TpjhBase)
    FPackageCollect: THiMECSFormCollect;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

  published
    property PackageCollect: THiMECSFormCollect read FPackageCollect write FPackageCollect;
  end;

  THiMECSFormItem = class(TCollectionItem)
  private
    FAllowLevel: integer;
    FPackageName: string; //(*.bpl)
    FFilePath: string;//
    FCreateFuncName: string;//
//    FCreatedClassName: string;//MDIChild 폼이 이미 생성 되었는지 여부를 판단하기 위함
  public
    FPackageHandle: HModule;
    FCreateChildFromBPL: array of TCreateChildFromBPL;
    FCreateFuncNameAry: array of string;
  published
    property AllowLevel: integer read FAllowLevel write FAllowLevel;
    property PackageName: string read FPackageName write FPackageName;
    property FilePath: string read FFilePath write FFilePath;
    property CreateFuncName: string read FCreateFuncName write FCreateFuncName;
//    property CreatedClassName: string read FCreatedClassName write FCreatedClassName;
  end;

  THiMECSFormCollect = class(TCollection)
  private
    function GetItem(Index: Integer): THiMECSFormItem;
    procedure SetItem(Index: Integer; const Value: THiMECSFormItem);
  public
    function  Add: THiMECSFormItem;
    function Insert(Index: Integer): THiMECSFormItem;
    property Items[Index: Integer]: THiMECSFormItem read GetItem  write SetItem; default;
  end;

implementation

function THiMECSFormCollect.Add: THiMECSFormItem;
begin
  Result := THiMECSFormItem(inherited Add);
end;

function THiMECSFormCollect.GetItem(Index: Integer): THiMECSFormItem;
begin
  Result := THiMECSFormItem(inherited Items[Index]);
end;

function THiMECSFormCollect.Insert(Index: Integer): THiMECSFormItem;
begin
  Result := THiMECSFormItem(inherited Insert(Index));
end;

procedure THiMECSFormCollect.SetItem(Index: Integer; const Value: THiMECSFormItem);
begin
  Items[Index].Assign(Value);
end;

{ THiMECSConfig }

constructor THiMECSForms.Create(AOwner: TComponent);
begin
  FPackageCollect := THiMECSFormCollect.Create(THiMECSFormItem);

end;

destructor THiMECSForms.Destroy;
begin
  inherited Destroy;
  FPackageCollect.Free;
end;

end.
