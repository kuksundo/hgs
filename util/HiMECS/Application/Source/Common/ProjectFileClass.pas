unit ProjectFileClass;

interface

uses classes, BaseConfigCollect, HiMECSConst, HiMECSConfigCollect,
  HiMECSMonitorListClass, AutoRunClass;

type
  TProjectFileCollect = class;
  TProjectFileItem = class;

  TProjectFile = class(TpjhBase)
  private
    FProjectFileCollect: TProjectFileCollect;
    FProjectDescript,
    FProjectFileName: string;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Clear;
    procedure Assign(Source: TPersistent); override;
  published
    property ProjectFileCollect: TProjectFileCollect read FProjectFileCollect write FProjectFileCollect;
    property ProjectDescript: string read FProjectDescript write FProjectDescript;
    property ProjectFileName: string read FProjectFileName write FProjectFileName;
  end;

  TProjectFileItem = class(TCollectionItem)
  private
    FProjectItemName,
    FOptionsFileName,
    FUserFileName,
    FRunListFileName, //Auto run program list file(자동 실행되는 통신 프로그램 리스트)
    FMonitorFileName, //Monitoring form list file(Watch List 파일임)
    FProjectItemDescript: string;
    FUserLevel: THiMECSUserLevel;
    FOptionFileEncrypt: Boolean;//Engine Parameter file Encryption
    FRunListFileEncrypt: Boolean;//Run List file Encryption
    FMonitorFileEncrypt: Boolean;//Monitor file Encryption

    FHiMECSConfig: THiMECSConfig;
    FHiMECSMonitor: THiMECSMonitorList;
    FHiMECSAutoRun: TAutoRunList;
  public
    property HiMECSConfig: THiMECSConfig read FHiMECSConfig write FHiMECSConfig;
    property HiMECSMonitor: THiMECSMonitorList read FHiMECSMonitor write FHiMECSMonitor;
    property HiMECSAutoRun: TAutoRunList read FHiMECSAutoRun write FHiMECSAutoRun;

    procedure Assign(Source: TPersistent); override;
  published
    property ProjectItemName: string read FProjectItemName write FProjectItemName;
    property OptionsFileName: string read FOptionsFileName write FOptionsFileName;
    property UserFileName: string read FUserFileName write FUserFileName;
    property RunListFileName: string read FRunListFileName write FRunListFileName;
    property MonitorFileName: string read FMonitorFileName write FMonitorFileName;
    property ProjectItemDescript: string read FProjectItemDescript write FProjectItemDescript;
    property UserLevel: THiMECSUserLevel read FUserLevel write FUserLevel;
    property OptionFileEncrypt: Boolean read FOptionFileEncrypt write FOptionFileEncrypt;
    property RunListFileEncrypt: Boolean read FRunListFileEncrypt write FRunListFileEncrypt;
    property MonitorFileEncrypt: Boolean read FMonitorFileEncrypt write FMonitorFileEncrypt;
  end;

  TProjectFileCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TProjectFileItem;
    procedure SetItem(Index: Integer; const Value: TProjectFileItem);
  public
    function  Add: TProjectFileItem;
    function Insert(Index: Integer): TProjectFileItem;
    property Items[Index: Integer]: TProjectFileItem read GetItem  write SetItem; default;
  end;

implementation

{ TProjectFileCollect }

function TProjectFileCollect.Add: TProjectFileItem;
begin
  Result := TProjectFileItem(inherited Add);
end;

function TProjectFileCollect.GetItem(Index: Integer): TProjectFileItem;
begin
  Result := TProjectFileItem(inherited Items[Index]);
end;

function TProjectFileCollect.Insert(Index: Integer): TProjectFileItem;
begin
  Result := TProjectFileItem(inherited Insert(Index));
end;

procedure TProjectFileCollect.SetItem(Index: Integer;
  const Value: TProjectFileItem);
begin
  Items[Index].Assign(Value);
end;

{ TProjectFile }

procedure TProjectFile.Assign(Source: TPersistent);
var
  i: integer;
begin
  if Source is TProjectFile then
  begin
    if Assigned(ProjectFileCollect) then
    begin
      FProjectFileCollect.Clear;

      for i := 0 to TProjectFile(Source).ProjectFileCollect.Count - 1 do
        with ProjectFileCollect.Add do
          Assign(TProjectFile(Source).ProjectFileCollect[i]);
    end;

    ProjectDescript := TProjectFile(Source).ProjectDescript;
  end
  else
    inherited;
end;

procedure TProjectFile.Clear;
begin
;
end;

constructor TProjectFile.Create(AOwner: TComponent);
begin
  FProjectFileCollect := TProjectFileCollect.Create(TProjectFileItem);
end;

destructor TProjectFile.Destroy;
begin
  inherited Destroy;

  FProjectFileCollect.Free;
end;

{ TProjectFileItem }

procedure TProjectFileItem.Assign(Source: TPersistent);
begin
  if Source is TProjectFileItem then
  begin
    ProjectItemName := TProjectFileItem(Source).ProjectItemName;
    OptionsFileName := TProjectFileItem(Source).OptionsFileName;
    UserFileName := TProjectFileItem(Source).UserFileName;
    RunListFileName := TProjectFileItem(Source).RunListFileName;
    MonitorFileName := TProjectFileItem(Source).MonitorFileName;
    ProjectItemDescript := TProjectFileItem(Source).ProjectItemDescript;
    UserLevel := TProjectFileItem(Source).UserLevel;
    OptionFileEncrypt := TProjectFileItem(Source).OptionFileEncrypt;
    RunListFileEncrypt := TProjectFileItem(Source).RunListFileEncrypt;
    MonitorFileEncrypt := TProjectFileItem(Source).MonitorFileEncrypt;
  end
  else
    inherited;
end;

end.
