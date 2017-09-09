unit HiMECSOptionsCollect;
{
2013.5.27
- HiMECS Options Data
- HiMECSConfigCollect와 항목이 동일함
}

interface

uses classes, SysUtils, BaseConfigCollect, HiMECSConfigCollect,
  EngineParameterClass, ProjectBaseClass, EngineBaseClass;

type
  THiMECSOptionsCollect = class;
  THiMECSOptionsItem = class;

  THiMECSOptions = class(TpjhBase)
  private
    FHiMECSOptionsCollect: THiMECSOptionsCollect;
    FEngineParameter: TEngineParameter;
    FProjectInfo: TProjectInfo;
    FEngineInfo: TInternalCombustionEngine;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

    procedure Clear;
    procedure AddFromHiMECSConfigCollect(AItemName: string; ASource: THiMECSConfig);
    procedure Add2HiMECSConfigCollect(ADestination: THiMECSConfig; AIndex: integer);

    property EngineParameter: TEngineParameter read FEngineParameter write FEngineParameter;
    property ProjectInfo: TProjectInfo read FProjectInfo write FProjectInfo;
    property EngineInfo: TInternalCombustionEngine read FEngineInfo write FEngineInfo;
  published
    property HiMECSOptionsCollect: THiMECSOptionsCollect read FHiMECSOptionsCollect write FHiMECSOptionsCollect;
  end;

  THiMECSOptionsItem = class(TCollectionItem)
  private
    FProjectItemName: string;
    FMenuFileName,
    FEngineInfoFileName,
    FParamFileName,
    FProjectInfoFileName,
    FUserFileName
    : string;
    FHiMECSFormPath, //Form 관련 bpl이 저장된 경로
    FConfigPath,     //Config 관련 file(.option,menu,form)이 저장된 경로
    FDocPath,        //Document 관련 file이 저장된 경로
    FExesPath,       //외부 실행화일이 저장된 경로
    FBplsPath,       //Bpl 화일이 저장된 경로
    FLogPath         //Log File 저장 경로
    : string;
    FExtAppInMDI : Boolean;
    FUseMonLauncher: Boolean; //true = HiMECS_MON_LAUNCHER.exe를 이용하여 Montor list 로드함
    FEngParamEncrypt: Boolean;//Engine Parameter file Encryption
    FEngParamFileFormat: integer; //0: XML, 1: JSON

    //for Update config
    FUpdateProtocol: integer;//0=HTTP. 1=HTTPS, 2=FTP, 3=Network File
    FFTPHost: string;
    FFTPPort: integer;
    FFTPUserID,
    FFTPPasswd,
    FFTPDirectory, //update할 file이 위치한 폴더
    FServerURL: string;
    FUpdateWhenStart: Boolean;
  public
  published
    property ProjectItemName: string read FProjectItemName write FProjectItemName;
    property MenuFileName: string read FMenuFileName write FMenuFileName;
    property EngineInfoFileName: string read FEngineInfoFileName write FEngineInfoFileName;
    property ParamFileName: string read FParamFileName write FParamFileName;
    property ProjectInfoFileName: string read FProjectInfoFileName write FProjectInfoFileName;
    property UserFileName: string read FUserFileName write FUserFileName;

    property HiMECSFormPath: string read FHiMECSFormPath write FHiMECSFormPath;
    property ConfigPath: string read FConfigPath write FConfigPath;
    property DocPath: string read FDocPath write FDocPath;
    property ExesPath: string read FExesPath write FExesPath;
    property BplsPath: string read FBplsPath write FBplsPath;
    property LogPath: string read FLogPath write FLogPath;
    property ExtAppInMDI: Boolean read FExtAppInMDI write FExtAppInMDI;
    property EngParamEncrypt: Boolean read FEngParamEncrypt write FEngParamEncrypt;
    property EngParamFileFormat: Integer read FEngParamFileFormat write FEngParamFileFormat;

    property FTPHost: string read FFTPHost write FFTPHost;
    property FTPPort: integer read FFTPPort write FFTPPort;
    property FTPUserID: string read FFTPUserID write FFTPUserID;
    property FTPPasswd: string read FFTPPasswd write FFTPPasswd;
    property FTPDirectory: string read FFTPDirectory write FFTPDirectory;
    property ServerURL: string read FServerURL write FServerURL;
    property UpdateProtocol: integer read FUpdateProtocol write FUpdateProtocol;
    property UpdateWhenStart: Boolean read FUpdateWhenStart write FUpdateWhenStart;
  end;

  THiMECSOptionsCollect = class(TCollection)
  private
    function GetItem(Index: Integer): THiMECSOptionsItem;
    procedure SetItem(Index: Integer; const Value: THiMECSOptionsItem);
  public
    function  Add: THiMECSOptionsItem;
    function Insert(Index: Integer): THiMECSOptionsItem;
    property Items[Index: Integer]: THiMECSOptionsItem read GetItem  write SetItem; default;
  end;

implementation

function THiMECSOptionsCollect.Add: THiMECSOptionsItem;
begin
  Result := THiMECSOptionsItem(inherited Add);
end;

function THiMECSOptionsCollect.GetItem(Index: Integer): THiMECSOptionsItem;
begin
  Result := THiMECSOptionsItem(inherited Items[Index]);
end;

function THiMECSOptionsCollect.Insert(Index: Integer): THiMECSOptionsItem;
begin
  Result := THiMECSOptionsItem(inherited Insert(Index));
end;

procedure THiMECSOptionsCollect.SetItem(Index: Integer; const Value: THiMECSOptionsItem);
begin
  Items[Index].Assign(Value);
end;

{ THiMECSOptions }

procedure THiMECSOptions.Add2HiMECSConfigCollect(ADestination: THiMECSConfig;
  AIndex: integer);
begin
  ADestination.MenuFileName := HiMECSOptionsCollect[AIndex].MenuFileName;
  ADestination.EngineInfoFileName := HiMECSOptionsCollect[AIndex].EngineInfoFileName;
  ADestination.ParamFileName := HiMECSOptionsCollect[AIndex].ParamFileName;
  ADestination.ProjectInfoFileName := HiMECSOptionsCollect[AIndex].ProjectInfoFileName;
  ADestination.UserFileName := HiMECSOptionsCollect[AIndex].UserFileName;

  ADestination.HiMECSFormPath := HiMECSOptionsCollect[AIndex].HiMECSFormPath;
  ADestination.ConfigPath := HiMECSOptionsCollect[AIndex].ConfigPath;
  ADestination.DocPath := HiMECSOptionsCollect[AIndex].DocPath;
  ADestination.ExesPath := HiMECSOptionsCollect[AIndex].ExesPath;
  ADestination.BplsPath := HiMECSOptionsCollect[AIndex].BplsPath;
  ADestination.LogPath := HiMECSOptionsCollect[AIndex].LogPath;
  ADestination.ExtAppInMDI := HiMECSOptionsCollect[AIndex].ExtAppInMDI;
  ADestination.EngParamEncrypt := HiMECSOptionsCollect[AIndex].EngParamEncrypt;
  ADestination.EngParamFileFormat := HiMECSOptionsCollect[AIndex].EngParamFileFormat;

  ADestination.FTPHost := HiMECSOptionsCollect[AIndex].FTPHost;
  ADestination.FTPPort := HiMECSOptionsCollect[AIndex].FTPPort;
  ADestination.FTPUserID := HiMECSOptionsCollect[AIndex].FTPUserID;
  ADestination.FTPPasswd := HiMECSOptionsCollect[AIndex].FTPPasswd;
  ADestination.FTPDirectory := HiMECSOptionsCollect[AIndex].FTPDirectory;
  ADestination.ServerURL := HiMECSOptionsCollect[AIndex].ServerURL;
  ADestination.UpdateProtocol := HiMECSOptionsCollect[AIndex].UpdateProtocol;
  ADestination.UpdateWhenStart := HiMECSOptionsCollect[AIndex].UpdateWhenStart;
end;

procedure THiMECSOptions.AddFromHiMECSConfigCollect(AItemName: string;
  ASource: THiMECSConfig);
begin
  with FHiMECSOptionsCollect.Add do
  begin
    ProjectItemName := AItemName;
    MenuFileName := ASource.MenuFileName;
    EngineInfoFileName := ASource.EngineInfoFileName;
    ParamFileName := ASource.ParamFileName;
    ProjectInfoFileName := ASource.ProjectInfoFileName;
    UserFileName := ASource.UserFileName;

    HiMECSFormPath := ASource.HiMECSFormPath;
    ConfigPath := ASource.ConfigPath;
    DocPath := ASource.DocPath;
    ExesPath := ASource.ExesPath;
    BplsPath := ASource.BplsPath;
    LogPath := ASource.LogPath;
    ExtAppInMDI := ASource.ExtAppInMDI;
    EngParamEncrypt := ASource.EngParamEncrypt;
    EngParamFileFormat := ASource.EngParamFileFormat;

    FTPHost := ASource.FTPHost;
    FTPPort := ASource.FTPPort;
    FTPUserID := ASource.FTPUserID;
    FTPPasswd := ASource.FTPPasswd;
    FTPDirectory := ASource.FTPDirectory;
    ServerURL := ASource.ServerURL;
    UpdateProtocol := ASource.UpdateProtocol;
    UpdateWhenStart := ASource.UpdateWhenStart;
  end;
end;

procedure THiMECSOptions.Clear;
begin
  HiMECSOptionsCollect.Clear;
{  MenuFileName := '';
  HiMECSFormPath := '';
  ConfigPath := '';
  DocPath := '';
  ExesPath := ''; }
end;

constructor THiMECSOptions.Create(AOwner: TComponent);
begin
  FHiMECSOptionsCollect := THiMECSOptionsCollect.Create(THiMECSOptionsItem);
end;

destructor THiMECSOptions.Destroy;
begin
  inherited Destroy;
  FHiMECSOptionsCollect.Free;
end;

end.
