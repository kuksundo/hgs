unit HiMECSUserClass;

interface

uses classes, BaseConfigCollect, HiMECSConst;

type
  THiMECSUserCollect = class;
  THiMECSUserItem = class;

  THiMECSUser = class(TpjhBase)
  private
    FHiMECSUserCollect: THiMECSUserCollect;
    FUpdateWhenStart: Boolean;
    FAutoUpdateFileName: string;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
  published
    property HiMECSUserCollect: THiMECSUserCollect read FHiMECSUserCollect write FHiMECSUserCollect;
    property UpdateWhenStart: Boolean read FUpdateWhenStart write FUpdateWhenStart;
    property AutoUpdateFileName: string read FAutoUpdateFileName write FAutoUpdateFileName;
  end;

  THiMECSUserItem = class(TCollectionItem)
  private
    FName,
    FSurName,
    FeMail,
    FUserID,
    FPassword,
    FAuthentication,
    FCountry,
    FMenuFileName: string;

    FUserLevel: THiMECSUserLevel;
    FUserCategory: THiMECSUserCategory;

    FRegisterDate,
    FExpirationDate: TDate;

  published
    property Name: string read FName write FName;
    property SurName: string read FSurName write FSurName;
    property eMail: string read FeMail write FeMail;
    property UserID: string read FUserID write FUserID;
    property Password: string read FPassword write FPassword;
    property Authentication: string read FAuthentication write FAuthentication;
    property Country: string read FCountry write FCountry;
    property MenuFileName: string read FMenuFileName write FMenuFileName;

    property UserLevel: THiMECSUserLevel read FUserLevel write FUserLevel;
    property UserCategory: THiMECSUserCategory read FUserCategory write FUserCategory;

    property RegisterDate: TDate read FRegisterDate write FRegisterDate;
    property ExpirationDate: TDate read FExpirationDate write FExpirationDate;
  end;

  THiMECSUserCollect = class(TCollection)
  private
    function GetItem(Index: Integer): THiMECSUserItem;
    procedure SetItem(Index: Integer; const Value: THiMECSUserItem);
  public
    function  Add: THiMECSUserItem;
    function Insert(Index: Integer): THiMECSUserItem;
    property Items[Index: Integer]: THiMECSUserItem read GetItem  write SetItem; default;
  end;

implementation

function THiMECSUserCollect.Add: THiMECSUserItem;
begin
  Result := THiMECSUserItem(inherited Add);
end;

function THiMECSUserCollect.GetItem(Index: Integer): THiMECSUserItem;
begin
  Result := THiMECSUserItem(inherited Items[Index]);
end;

function THiMECSUserCollect.Insert(Index: Integer): THiMECSUserItem;
begin
  Result := THiMECSUserItem(inherited Insert(Index));
end;

procedure THiMECSUserCollect.SetItem(Index: Integer; const Value: THiMECSUserItem);
begin
  Items[Index].Assign(Value);
end;

{ THiMECSConfig }

constructor THiMECSUser.Create(AOwner: TComponent);
begin
  FHiMECSUserCollect := THiMECSUserCollect.Create(THiMECSUserItem);

end;

destructor THiMECSUser.Destroy;
begin
  inherited Destroy;
  FHiMECSUserCollect.Free;
end;

end.
