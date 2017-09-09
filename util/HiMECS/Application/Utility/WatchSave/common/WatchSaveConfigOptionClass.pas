unit WatchSaveConfigOptionClass;

interface

uses classes, BaseConfigCollect, ConfigOptionClass, GpCommandLineParser;

type
  TWatchSaveCommandLineOption = class
    FToDateTime,
    FConfigFileName,
    FWatchListFileName  : string;
    FAutoExecute: Boolean;
  public
    [CLPName('p'), CLPLongName('param'), CLPDescription('param file name')]//, '<path>'
    property WatchListFileName: string read FWatchListFileName write FWatchListFileName;
    [CLPName('c'), CLPLongName('ConfigFile'), CLPDescription('Config File Name')]
    property ConfigFileName: string read FConfigFileName write FConfigFileName;
    [CLPName('a'), CLPLongName('AutoExcute', 'Auto'), CLPDescription('Enable autotest mode.')]
    property AutoExecute: boolean read FAutoExecute write FAutoExecute;
    [CLPLongName('ToDate'), CLPDescription('Set ending date/time', '<dt>')]
    property ToDateTime: string read FToDateTime write FToDateTime;
//    [CLPName('n'), CLPDescription('Set number of days', '<days>'), CLPDefault('100')]
//    property NumDays: integer read FNumDays write FNumDays;
  end;

  TWatchSaveConfigOptionCollect = class;
  TWatchSaveConfigOptionItem = class;

  TWatchSaveConfigOption = class(TConfigOption)
  private
    FConfigOptionCollect: TWatchSaveConfigOptionCollect;

    //FModbusFileName: string; ==> ConfigOptionClass에 정의 됨.
    //FAverageSize: integer; //평균을 위한 배열 size  ==> ConfigOptionClass에 정의 됨.
    FSplitCount: integer; //파일 분리 라인 수

    //FSelDisplayInterval: integer;//0: By Event, 1: By Timer  ==> ConfigOptionClass에 정의 됨.
    //FDisplayInterval: integer;  ==> ConfigOptionClass에 정의 됨.

    FInitialFileIndex: Boolean;//True면 Start 시에 FileIndex를 0으로
    FInitialIndex: integer;
    FIsCsvFileSave: Boolean;
    FFileSaveInterval: integer; //csv file save interval
//    FEngParamEncrypt: Boolean;//Engine Parameter file Encryption
//    FEngParamFileFormat: integer; //0: XML, 1: JSON
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

  published
    property ConfigOptionCollect: TWatchSaveConfigOptionCollect read FConfigOptionCollect write FConfigOptionCollect;

    //property ModbusFileName: string read FModbusFileName write FModbusFileName;
    //property AverageSize: integer read FAverageSize write FAverageSize;
    property SplitCount: integer read FSplitCount write FSplitCount;
    //property SelDisplayInterval: integer read FSelDisplayInterval write FSelDisplayInterval;
    //property DisplayInterval: integer read FDisplayInterval write FDisplayInterval;
    property InitialFileIndex: Boolean read FInitialFileIndex write FInitialFileIndex;
    property InitialIndex: integer read FInitialIndex write FInitialIndex;
    property IsCsvFileSave: Boolean read FIsCsvFileSave write FIsCsvFileSave;
    property FileSaveInterval: integer read FFileSaveInterval write FFileSaveInterval;
  end;

  TWatchSaveConfigOptionItem = class(TCollectionItem)
  private
  published
    //property PartName: string read FPartName write FPartName;
  end;

  TWatchSaveConfigOptionCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TWatchSaveConfigOptionItem;
    procedure SetItem(Index: Integer; const Value: TWatchSaveConfigOptionItem);
  public
    function  Add: TWatchSaveConfigOptionItem;
    function Insert(Index: Integer): TWatchSaveConfigOptionItem;
    property Items[Index: Integer]: TWatchSaveConfigOptionItem read GetItem  write SetItem; default;
  end;

implementation

{ TInternalCombustionEngine }

constructor TWatchSaveConfigOption.Create(AOwner: TComponent);
begin
  FConfigOptionCollect := TWatchSaveConfigOptionCollect.Create(TWatchSaveConfigOptionItem);

  inherited;
end;

destructor TWatchSaveConfigOption.Destroy;
begin
  inherited Destroy;
  
  FConfigOptionCollect.Free;
end;

{ TWatchSaveConfigOptionCollect }

function TWatchSaveConfigOptionCollect.Add: TWatchSaveConfigOptionItem;
begin
  Result := TWatchSaveConfigOptionItem(inherited Add);
end;

function TWatchSaveConfigOptionCollect.GetItem(Index: Integer): TWatchSaveConfigOptionItem;
begin
  Result := TWatchSaveConfigOptionItem(inherited Items[Index]);
end;

function TWatchSaveConfigOptionCollect.Insert(Index: Integer): TWatchSaveConfigOptionItem;
begin
  Result := TWatchSaveConfigOptionItem(inherited Insert(Index));
end;

procedure TWatchSaveConfigOptionCollect.SetItem(Index: Integer; const Value: TWatchSaveConfigOptionItem);
begin
  Items[Index].Assign(Value);
end;

end.
