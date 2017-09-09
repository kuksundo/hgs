unit AutoUpdateClass;

interface

uses classes, SysUtils, ExtCtrls, Vcl.Graphics, BaseConfigCollect;

type
  TAutoUpdateType = (ftpUpdate,httpUpdate,fileUpdate);

  TAutoUpdateCollect = class;
  TAutoUpdateItem = class;

  TAutoUpdateList = class(TpjhBase)
  private
    FAutoUpdateCollect: TAutoUpdateCollect;
    FLogFileName,
    FInfFileName, //HiMECSUpdate.inf
    FURL: string; //'http://10.100.23.115/Update/HiMECS/'
    FProtocol: TAutoUpdateType;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

    function UpdateType2String(AType:TAutoUpdateType): string;
    function String2UpdateType(AType: string): TAutoUpdateType;
  published
    property AutoUpdateCollect: TAutoUpdateCollect read FAutoUpdateCollect write FAutoUpdateCollect;
    property LogFileName: string read FLogFileName write FLogFileName;
    property InfFileName: string read FInfFileName write FInfFileName;
    property URL: string read FURL write FURL;
    property Protocol: TAutoUpdateType read FProtocol write FProtocol;
  end;

  PAutoUpdateItem = ^TAutoUpdateItem;
  TAutoUpdateItem = class(TCollectionItem)
  private
  public
    procedure Assign(Source: TPersistent); override;
  published
  end;

  TAutoUpdateCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TAutoUpdateItem;
    procedure SetItem(Index: Integer; const Value: TAutoUpdateItem);
  public
    function  Add: TAutoUpdateItem;
    function Insert(Index: Integer): TAutoUpdateItem;
    property Items[Index: Integer]: TAutoUpdateItem read GetItem  write SetItem; default;
  end;

implementation

constructor TAutoUpdateList.Create(AOwner: TComponent);
begin
  FAutoUpdateCollect := TAutoUpdateCollect.Create(TAutoUpdateItem);
end;

destructor TAutoUpdateList.Destroy;
begin
  inherited Destroy;
  FAutoUpdateCollect.Free;
end;

function TAutoUpdateList.String2UpdateType(AType: string): TAutoUpdateType;
begin
  if AType = 'ftpUpdate' then
    Result := ftpUpdate
  else if AType = 'httpUpdate' then
    Result := httpUpdate
  else if AType = 'fileUpdate' then
    Result := fileUpdate;
end;

function TAutoUpdateList.UpdateType2String(AType: TAutoUpdateType): string;
begin
  if AType = ftpUpdate then
    Result := 'ftpUpdate'
  else if AType = httpUpdate then
    Result := 'httpUpdate'
  else if AType = fileUpdate then
    Result := 'fileUpdate';
end;

function TAutoUpdateCollect.Add: TAutoUpdateItem;
begin
  Result := TAutoUpdateItem(inherited Add);
end;

function TAutoUpdateCollect.GetItem(Index: Integer): TAutoUpdateItem;
begin
  Result := TAutoUpdateItem(inherited Items[Index]);
end;

function TAutoUpdateCollect.Insert(Index: Integer): TAutoUpdateItem;
begin
  Result := TAutoUpdateItem(inherited Insert(Index));
end;

procedure TAutoUpdateCollect.SetItem(Index: Integer; const Value: TAutoUpdateItem);
begin
  Items[Index].Assign(Value);
end;

{ TAutoUpdateItem }

procedure TAutoUpdateItem.Assign(Source: TPersistent);
begin
  if Source is TAutoUpdateItem then
  begin
  end
  else
    inherited;
end;

end.
