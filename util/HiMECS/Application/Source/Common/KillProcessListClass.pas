unit KillProcessListClass;

interface

uses classes, SysUtils, ExtCtrls, Vcl.Graphics, BaseConfigCollect;

type
  TKillProcessListCollect = class;
  TKillProcessListItem = class;

  TKillProcessList = class(TpjhBase)
  private
    FKillProcessListCollect: TKillProcessListCollect;
    FKillProcListFileName: string;//현재 List FileName을 저장함.
    FKillProcTimerHandle: integer;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

    property KillProcTimerHandle: integer read FKillProcTimerHandle write FKillProcTimerHandle;
  published
    property KillProcessListCollect: TKillProcessListCollect read FKillProcessListCollect write FKillProcessListCollect;
    property KillProcListFileName: string read FKillProcListFileName write FKillProcListFileName;
  end;

  PKillProcessListItem = ^TKillProcessListItem;
  TKillProcessListItem = class(TCollectionItem)
  private
    FProcessName: string;
    FKillEnable: Boolean;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property ProcessName: string read FProcessName write FProcessName;
    property KillEnable: Boolean read FKillEnable write FKillEnable;
  end;

  TKillProcessListCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TKillProcessListItem;
    procedure SetItem(Index: Integer; const Value: TKillProcessListItem);
  public
    function  Add: TKillProcessListItem;
    function Insert(Index: Integer): TKillProcessListItem;
    property Items[Index: Integer]: TKillProcessListItem read GetItem  write SetItem; default;
  end;

implementation

constructor TKillProcessList.Create(AOwner: TComponent);
begin
  FKillProcessListCollect := TKillProcessListCollect.Create(TKillProcessListItem);
end;

destructor TKillProcessList.Destroy;
begin
  inherited Destroy;
  FKillProcessListCollect.Free;
end;

function TKillProcessListCollect.Add: TKillProcessListItem;
begin
  Result := TKillProcessListItem(inherited Add);
end;

function TKillProcessListCollect.GetItem(Index: Integer): TKillProcessListItem;
begin
  Result := TKillProcessListItem(inherited Items[Index]);
end;

function TKillProcessListCollect.Insert(Index: Integer): TKillProcessListItem;
begin
  Result := TKillProcessListItem(inherited Insert(Index));
end;

procedure TKillProcessListCollect.SetItem(Index: Integer; const Value: TKillProcessListItem);
begin
  Items[Index].Assign(Value);
end;

{ TKillProcessListItem }

procedure TKillProcessListItem.Assign(Source: TPersistent);
begin
  if Source is TKillProcessListItem then
  begin
    ProcessName := TKillProcessListItem(Source).ProcessName;
  end
  else
    inherited;
end;

end.
