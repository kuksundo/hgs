unit AutoRunClass;

interface

uses classes, SysUtils, ExtCtrls, Vcl.Graphics, BaseConfigCollect;

type
  TAutoRunCollect = class;
  TAutoRunItem = class;

  TAutoRunList = class(TpjhBase)
  private
    FAutoRunCollect: TAutoRunCollect;
    //TAdvSmoothTileList(Monitoring List/Communication List) 설정값
    FTileRowNum,
    FTileColNum: integer;
    FLauncherHandle: THandle;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
  published
    property AutoRunCollect: TAutoRunCollect read FAutoRunCollect write FAutoRunCollect;
    property TileRowNum: integer read FTileRowNum write FTileRowNum;
    property TileColNum: integer read FTileColNum write FTileColNum;
    property LauncherHandle: THandle read FLauncherHandle write FLauncherHandle;
  end;

  PAutoRunItem = ^TAutoRunItem;
  TAutoRunItem = class(TCollectionItem)
  private
    FAppTitle,
    FAppPath,
    FAppDesc,
    FAppImage,
    FAppDisableImage,
    FRunParameter: string;
    FIsAutoRun: Boolean;//True = 자동 실행, False = 수동 실행
    FIsRelativePath: Boolean;//True = AppPath가 상대 경로임(HiMECS Bin 기준)
    FAppHandle: integer; //실행창 핸들(Sendmessage시에 사용됨)
    FAppProcessId: THandle;
    FDisableTimerHandle: integer; //표시를 Disable로 만드는 Timer Handle
    FTileIndex: integer;//TileList의 Index
  public
    procedure Assign(Source: TPersistent); override;
    property AppProcessId: THandle read FAppProcessId write FAppProcessId;
  published
    property AppTitle: string read FAppTitle write FAppTitle;
    property AppPath: string read FAppPath write FAppPath;
    property AppDesc: string read FAppDesc write FAppDesc;
    property AppImage: string read FAppImage write FAppImage;
    property AppDisableImage: string read FAppDisableImage write FAppDisableImage;
    property RunParameter: string read FRunParameter write FRunParameter;
    property IsAutoRun: Boolean read FIsAutoRun write FIsAutoRun;
    property IsRelativePath: Boolean read FIsRelativePath write FIsRelativePath;
    property AppHandle: integer read FAppHandle write FAppHandle;
    property DisableTimerHandle: integer read FDisableTimerHandle write FDisableTimerHandle default -1;
    property TileIndex: integer read FTileIndex write FTileIndex;
  end;

  TAutoRunCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TAutoRunItem;
    procedure SetItem(Index: Integer; const Value: TAutoRunItem);
  public
    function  Add: TAutoRunItem;
    function Insert(Index: Integer): TAutoRunItem;
    property Items[Index: Integer]: TAutoRunItem read GetItem  write SetItem; default;
  end;

implementation

constructor TAutoRunList.Create(AOwner: TComponent);
begin
  FAutoRunCollect := TAutoRunCollect.Create(TAutoRunItem);
end;

destructor TAutoRunList.Destroy;
begin
  inherited Destroy;
  FAutoRunCollect.Free;
end;

function TAutoRunCollect.Add: TAutoRunItem;
begin
  Result := TAutoRunItem(inherited Add);
end;

function TAutoRunCollect.GetItem(Index: Integer): TAutoRunItem;
begin
  Result := TAutoRunItem(inherited Items[Index]);
end;

function TAutoRunCollect.Insert(Index: Integer): TAutoRunItem;
begin
  Result := TAutoRunItem(inherited Insert(Index));
end;

procedure TAutoRunCollect.SetItem(Index: Integer; const Value: TAutoRunItem);
begin
  Items[Index].Assign(Value);
end;

{ TAutoRunItem }

procedure TAutoRunItem.Assign(Source: TPersistent);
begin
  if Source is TAutoRunItem then
  begin
    AppTitle := TAutoRunItem(Source).AppTitle;
    AppPath := TAutoRunItem(Source).AppPath;
    AppDesc := TAutoRunItem(Source).AppDesc;
    AppImage := TAutoRunItem(Source).AppImage;
    AppDisableImage := TAutoRunItem(Source).AppDisableImage;
    RunParameter := TAutoRunItem(Source).RunParameter;
    IsAutoRun := TAutoRunItem(Source).IsAutoRun;
    IsRelativePath := TAutoRunItem(Source).IsRelativePath;
    AppHandle := TAutoRunItem(Source).AppHandle;
    DisableTimerHandle := TAutoRunItem(Source).DisableTimerHandle;
    TileIndex := TAutoRunItem(Source).TileIndex;
  end
  else
    inherited;
end;

end.
