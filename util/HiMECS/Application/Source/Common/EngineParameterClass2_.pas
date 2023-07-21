unit EngineParameterClass2;
{
  TEngineParameterItem 추가 시 수정해야 하는 내용 >--
    1) TEngineParameterItemRecord.AssignToParamItem 함수에 내용 추가
    2) TEngineParameterItemRecord.AssignTo 함수에 내용 추가
    3) TEngineParameterItem.AssignTo 함수에 내용 추가
    4) TEngineParameterItem.Assign 함수에 내용 추가
  --<
}
interface

uses classes, System.SysUtils, Generics.Legacy,
  UnitEngineParamConst, JHP.BaseConfigCollect, HiMECSConst, UnitEngineMasterData,
  UnitEngineParamRecord2, UnitMultiStateRecord2, UnitpjhTypes,
  mormot.core.base, mormot.core.data,mormot.core.variants,mormot.rest.sqlite3,
  mormot.orm.core, mormot.core.buffers, mormot.core.rtti;

type
  TEngineParameterCollect = class;
  TEngineParameterItem = class;

  TMatrixCollect = class;
  TMatrixItem = class;

  TMultiStateItem = class(TCollectionItem)
  private
    FTagName,
    FAddress,
    FStateDesc: string;
    FStateValue: integer;
    FStateMeaning: string;
  public
    FEngineParameterItemIndex: integer;
    FJsonOfItems: string;

//    function AssignFromJsonArray(const AJsonArray: string): integer;

    property EngineParameterItemIndex: integer read FEngineParameterItemIndex write FEngineParameterItemIndex default -1;
    property JsonOfItems: string read FJsonOfItems write FJsonOfItems;
  published
    property TagName: string read FTagName write FTagName;
    property Address: string read FAddress write FAddress;
    property StateDesc: string read FStateDesc write FStateDesc;
    property StateValue: integer read FStateValue write FStateValue;
    property StateMeaning: string read FStateMeaning write FStateMeaning;
  end;

//  TMultiStateCollect<TMultiStateItem> = class;
//  TMultiStateItem = class;
  TMultiStateCollect<T: TMultiStateItem> = class(Generics.Legacy.TCollection<T>)
  end;

  PMatrixItemRecord = ^TMatrixItemRecord;
  TMatrixItemRecord = record
    FXAxisIData: TpjhString100;
    FXAxisILength: integer;
    FYAxisIData: TpjhString100;
    FYAxisILength: integer;
    FZAxisIData: TpjhString100;
    FZAxisILength: integer;
    FValueIData: array[0..1000] of integer;
    FValueILength: integer;
    FXAxisFData: TpjhString100;
    FXAxisFLength: integer;
    FYAxisFData: TpjhString100;
    FYAxisFLength: integer;
    FZAxisFData: TpjhString100;
    FZAxisFLength: integer;
    FValueFData: array[0..1000] of single;
    FValueFLength: integer;
  end;

  PEngineParameterItemRecord = ^TEngineParameterItemRecord;
  TEngineParameterItemRecord = record
    FUserLevel: THiMECSUserLevel;
    FAlarmLevel,
    FLevelIndex,
    FNodeIndex,
    FAbsoluteIndex,
    FMaxValue,
    FBlockNo,
    FContact //1: A 접점, 2: B 접점
    : integer;
    FMaxValue_real: double;
    FValue: TpjhString50;
    FMinLimitValue,
    FDefaultValue,
    FMaxLimitValue,
    FProjNo:TpjhString10; //공사번호
    FEngNo: TpjhString10;//엔진순번(1부터 시작)
    FSharedName: TpjhString200;
    FTagName: TpjhString200;
    FDescription: TpjhString200;
    FDescription_Eng,
    FDescription_Kor: TpjhString255;
    FParamNo,
    FAddress: TpjhString10;
    FFCode: TpjhString10;
    FFUnit: TpjhString20;
    FScale: TpjhString10;
    FMinMaxType: TValueType; //mmtInteger, mmtReal
    FAlarm: Boolean;
    FRadixPosition: integer; //Binary data일 경우 32Bit내 Index를 저장함.
    FDisplayUnit: Boolean; //단위 표시 유무
    FDisplayThousandSeperator: Boolean;//1000 단위 구분자(,) 표시 유무
    FDisplayFormat: TpjhString20;

    FSensorType: TSensorType;
    FParameterCatetory: TParameterCategory;
    FParameterType: TParameterType;
    FParameterSource: TParameterSource;
    FDFAlarmKind: TDFAlarmKind; //알람 발생했을 경우 어떤 알람인지 구분함
    FEngineUsage: TEngineUsage;
    FDFCommissioningItem: TDFCommissioningItem;
    FAlarmKind4AVAT2: TAlarmKind4AVAT2;
    FAlarmLimit4AVAT2: TAlarmLimit4AVAT2;
    //==================================================
    FSelectFaultValue: integer;//0:not used, 1: original, 2: this
    FAlarmPriority: TAlarmPriority;//(apCritical, apWarning, apAdvisory, apLog)
    FAlarmEnable: Boolean;

    FMinAlarmEnable: Boolean; //아래 변수들 사용 여부
    FMaxAlarmEnable: Boolean; //
    FMinFaultEnable: Boolean;
    FMaxFaultEnable: Boolean;

    FMinAlarmValue: double; //Fault보다 낮은 레벨
    FMaxAlarmValue: double; //
    FMinFaultValue: double;
    FMaxFaultValue: double;

    FMinAlarmColor: Longint; //Alarm 발생시 표시색
    FMaxAlarmColor: Longint;
    FMinFaultColor: Longint;
    FMaxFaultColor: Longint;

    FMinAlarmBlink: Boolean; //Alarm 발생시 Blink
    FMaxAlarmBlink: Boolean;
    FMinFaultBlink: Boolean;
    FMaxFaultBlink: Boolean;

    FMinAlarmSoundEnable: Boolean; //Sound들 사용 여부
    FMaxAlarmSoundEnable: Boolean;
    FMinFaultSoundEnable: Boolean;
    FMaxFaultSoundEnable: Boolean;

    FMinAlarmSoundFilename: TpjhString100; //Sound File Name
    FMaxAlarmSoundFilename: TpjhString100; //
    FMinFaultSoundFilename: TpjhString100;
    FMaxFaultSoundFilename: TpjhString100;

    FFormulaValueList: TpjhString200; //Item간 계산 식(=''이면 Raw Item)

    //=====================//for Graph (Watch 폼에서
    FIsDisplayTrend: Boolean;
    FIsDisplayXY: Boolean;
    FTrendChannelIndex,
    FTrendAlarmIndex,
    FTrendFaultIndex,
    FTrendYAxisIndex: integer;
    FPlotXValue: double;
    FMinValue: integer;
    FMinValue_Real: real;
    FIsDisplaySimple: Boolean;
    FYAxesMinValue: Double;
    FYAxesSpanValue: Double;
    FUseXYGraphConstant: Boolean;
    FIsDisplayTrendAlarm: Boolean;
    FIsDisplayTrendFault: Boolean;

    FAllowUserLevelWatchList: THiMECSUserLevel; //watch list에서 파일 오픈시 허용 가능한 레벨
    FIsAverageValue: Boolean;//Watch Save시에 평균값 저장 여부
    FFExcelRange: TpjhString100;//엑셀 보고서 위치 정보(Sensor Route에 Drag할떄는 EngParamDBName이 전달 됨)

    //TEngineParameterClass에는 없음, WatchList 파일을 선별적으로 Load할때 쓰임
    //아래 변수를 레코드 맨 마지막에 선언하면 SendCopy 시에 에러 남.(20120706)
    FProjectFileName: TpjhString100;
    //==========Form State
    FFormWidth,
    FFormHeight,
    FFormTop,
    FFormLeft: integer;
    FFormState: TpjhWindowState;

    FMatrixItemIndex,
    FXAxisSize,
    FYAxisSize,
    FZAxisSize: integer;
    FMatrixItemRecord: TMatrixItemRecord;

    FKbdShiftState: TShiftState;//Watch2 Form에 Ctrl 키 누름 상태 보내기 위해 사용 됨
    FParamDragCopyMode: TParamDragCopyMode;//Watch2 Form에 Drag시 Copy Mode 상태 보내기 위해 사용 됨

    FMultiStateItemIndex: integer;
    FMultiStateItemCount: integer;
    FMultiStateValues: array[0..2000] of char;//Json 형식의 Values {"TagName":"","Address":""...}

{    FXAxisIData: TpjhString200;
    FXAxisILength: integer;
    FYAxisIData: TpjhString200;
    FYAxisILength: integer;
    FZAxisIData: TpjhString200;
    FZAxisILength: integer;
    FValueIData: TpjhString200;
    FValueILength: integer;
    FXAxisFData: TpjhString200;
    FXAxisFLength: integer;
    FYAxisFData: TpjhString200;
    FYAxisFLength: integer;
    FZAxisFData: TpjhString200;
    FZAxisFLength: integer;
    FValueFData: TpjhString200;
    FValueFLength: integer;
}
    procedure AssignToParamItem(var AEPItem: TEngineParameterItem);
    procedure AssignToMatrixItem(var AMItem: TMatrixItem);
    procedure AssignTo(var AEPItemRecord:TEngineParameterItemRecord);
    function AssignToMultiStateItem(const AJsonItems: string;
      var AMSCollect: TMultiStateCollect<TMultiStateItem>): integer;
  end;

  //TEngineParameter_DynArray = array of TEngineParameterItemRecord;

  TMatrixCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TMatrixItem;
    procedure SetItem(Index: Integer; const Value: TMatrixItem);
  public
    procedure AddMatrixItem(AMatrixItem: TMatrixItem);
    function  Add: TMatrixItem;
    function Insert(Index: Integer): TMatrixItem;
    property Items[Index: Integer]: TMatrixItem read GetItem  write SetItem; default;
  end;

  TEngineParameter = class(TpjhBase)
  private
    FEngineParameterCollect: TEngineParameterCollect;
    FMatrixCollect: TMatrixCollect;
    FMultiStateCollect: TMultiStateCollect<TMultiStateItem>;
    FFilePath: string;//
    FExeName: string;
    FProjectFileName: string;
    FAllowUserLevelWatchList: THiMECSUserLevel; //watch list에서 파일 오픈시 허용 가능한 레벨
    //==========Form State
    FFormWidth,
    FFormHeight,
    FFormTop,
    FFormLeft: integer;
    FFormState: TpjhWindowState;
    FStayOnTop,
    FSaveWatchForm: Boolean;
    FUseAlphaBlend: Boolean;
    FAlphaValue: integer;
    FTabShow: Boolean;
    FBorderShow: Boolean;
    FFactoryName: string;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function LoadFromJSONFile(AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False): integer; override;
    function SaveToJSONFile(AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False): integer; override;
    function LoadFromJSONArray(AJsonArray: RawUTF8; AIsAdd: Boolean=False): integer;
    function LoadFromJSONArrayOfMultiState(AJsonArray: RawUTF8; AIsAdd: Boolean=False): integer;
    function LoadFromSqliteFile(ADBFileName: string): integer;
    function SaveToSqliteFile(ADBFileName: string; AItemIndex: integer=-1): integer;
    function LoadFromSqliteFile4Secure(ADBFileName: string): integer;
    function SaveToSqliteFile4Secure(ADBFileName: string; AItemIndex: integer=-1): integer;
    procedure AssignEngParamRecFromEngParamItem(AItem: TEngineParameterItem; ARecord: TEngineParamRecord);
    procedure AssignEngParamItemFromEngParamRec(ARecord: TEngineParamRecord; AItem: TEngineParameterItem);

    //EngineParameterItem과 MultiStateItem을 연결하기 위해 동일한 TagName에 대한 각 Item의 Index를 상호 저장함
    procedure SetCollectItemIndex4XRef;
    function GetItemIndex(AEPItem: TEngineParameterItem): integer; overload;
    function GetItemIndex(ATagName: string): integer; overload;
    function GetMultiStateItemCount(ATagName: string): integer;
    function GetMultiStateItemValues2JsonArray(ATagName: string): string;

    function GetMatrixDataIdx(XIdx, YIdx: integer; AMatrixItem: TMatrixItem): integer; overload;
    //Matrix Item의 저장된(Published) 데이터를 내부변수(Public)로 복사함.
    procedure MatrixPublished2Public;
    //Config Parameter(published-파일에 저장되는 변수) 비교
    //같으면 0, 다르면 0보다 큰 숫자;
    function ComparePublishedMatrix(AParam: TEngineParameter): integer;
    //Config Parameter(public) 비교
    //같으면 0, 다르면 0보다 큰 숫자;
    function ComparePublicMatrix(AParam: TEngineParameter): integer;
  published
    property EngineParameterCollect: TEngineParameterCollect read FEngineParameterCollect write FEngineParameterCollect;
    property MatrixCollect: TMatrixCollect read FMatrixCollect write FMatrixCollect;
    property MultiStateCollect: TMultiStateCollect<TMultiStateItem> read FMultiStateCollect write FMultiStateCollect;
    property ExeName: string read FExeName write FExeName;
    property ProjectFileName: string read FProjectFileName write FProjectFileName;
    property FilePath: string read FFilePath write FFilePath;
    property AllowUserLevelWatchList: THiMECSUserLevel read FAllowUserLevelWatchList write FAllowUserLevelWatchList;

    property FormWidth: integer read FFormWidth write FFormWidth;
    property FormHeight: integer read FFormHeight write FFormHeight;
    property FormTop: integer read FFormTop write FFormTop;
    property FormLeft: integer read FFormLeft write FFormLeft;
    property FormState: TpjhWindowState read FFormState write FFormState;
    property UseAlphaBlend: Boolean read FUseAlphaBlend write FUseAlphaBlend;
    property AlphaValue: integer read FAlphaValue write FAlphaValue;
    property TabShow: Boolean read FTabShow write FTabShow;
    property BorderShow: Boolean read FBorderShow write FBorderShow;
    property StayOnTop: Boolean read FStayOnTop write FStayOnTop;
    property SaveWatchForm: Boolean read FSaveWatchForm write FSaveWatchForm;
    property FactoryName: string read FFactoryName  write FFactoryName;
  end;

  //Item 추가시에 Assign에도 추가할 것
  PEngineParameterItem = ^TEngineParameterItem;
  TEngineParameterItem = class(TCollectionItem)
  public
    constructor Create(ACollection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
    procedure AssignTo(var ARecord: TEngineParameterItemRecord);
    function IsMatrixData: Boolean;

{$I EngineParameter.inc}
  end;

  TEngineParameterCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TEngineParameterItem;
    procedure SetItem(Index: Integer; const Value: TEngineParameterItem);
  public
    FEngProjNo: string;
    FEngNo: string;
    FPowerOn: Boolean;

    function AddEngineParameterItem(ASource: TEngineParameterItem): TEngineParameterItem;
    procedure AddEngineParameterCollect(ASource: TEngineParameterCollect);
    function GetUniqueParamSourceName(AIdx: integer): string;
    function GetItemIndexFromAddress(AFCode,AAddress: string): integer;
    function GetItemFromParamNo(AParamNo: string): TEngineParameterItem;

    function  Add: TEngineParameterItem;
    function Insert(Index: Integer): TEngineParameterItem;

    property Items[Index: Integer]: TEngineParameterItem read GetItem  write SetItem; default;
    property EngProjNo: string read FEngProjNo  write FEngProjNo;
    property EngNo: string read FEngNo  write FEngNo;
    property PowerOn: Boolean read FPowerOn  write FPowerOn;
  end;

  PMatrixItem = ^TMatrixItem;
  TMatrixItem = class(TCollectionItem)
  private
    FXAxisIArray: TMatrixIArray;
    FYAxisIArray: TMatrixIArray;
    FZAxisIArray: TMatrixIArray;
    FValueIArray: TMatrixIArray;

    FXAxisFArray: TMatrixFArray;
    FYAxisFArray: TMatrixFArray;
    FZAxisFArray: TMatrixFArray;
    FValueFArray: TMatrixFArray;

    FXAxisICount: integer;
    FYAxisICount: integer;
    FZAxisICount: integer;
    FValueICount: integer;
    FXAxisFCount: integer;
    FYAxisFCount: integer;
    FZAxisFCount: integer;
    FValueFCount: integer;

    FXAxisIData: RawByteString;
    FYAxisIData: RawByteString;
    FZAxisIData: RawByteString;
    FValueIData: RawByteString;
    FXAxisFData: RawByteString;
    FYAxisFData: RawByteString;
    FZAxisFData: RawByteString;
    FValueFData: RawByteString;

    function GetXAxisIArray(AIndex: integer): TMatrixInteger;
    procedure SetXAxisIArray(AIndex: integer; AValue: TMatrixInteger);
    function GetYAxisIArray(AIndex: integer): TMatrixInteger;
    procedure SetYAxisIArray(AIndex: integer; AValue: TMatrixInteger);
    function GetZAxisIArray(AIndex: integer): TMatrixInteger;
    procedure SetZAxisIArray(AIndex: integer; AValue: TMatrixInteger);
    function GetValueIArray(AIndex: integer): TMatrixInteger;
    procedure SetValueIArray(AIndex: integer; AValue: TMatrixInteger);

    function GetXAxisFArray(AIndex: integer): TMatrixFloat;
    procedure SetXAxisFArray(AIndex: integer; AValue: TMatrixFloat);
    function GetYAxisFArray(AIndex: integer): TMatrixFloat;
    procedure SetYAxisFArray(AIndex: integer; AValue: TMatrixFloat);
    function GetZAxisFArray(AIndex: integer): TMatrixFloat;
    procedure SetZAxisFArray(AIndex: integer; AValue: TMatrixFloat);
    function GetValueFArray(AIndex: integer): TMatrixFloat;
    procedure SetValueFArray(AIndex: integer; AValue: TMatrixFloat);

    function GetXAxisIData: RawByteString;
    procedure SetXAxisIData(AValue: RawByteString);
    function GetXAxisILength: integer;
    procedure SetXAxisILength(AValue: integer);
    function GetYAxisIData: RawByteString;
    procedure SetYAxisIData(AValue: RawByteString);
    function GetYAxisILength: integer;
    procedure SetYAxisILength(AValue: integer);
    function GetZAxisIData: RawByteString;
    procedure SetZAxisIData(AValue: RawByteString);
    function GetZAxisILength: integer;
    procedure SetZAxisILength(AValue: integer);
    function GetValueIData: RawByteString;
    procedure SetValueIData(AValue: RawByteString);
    function GetValueILength: integer;
    procedure SetValueILength(AValue: integer);
    function GetXAxisFData: RawByteString;
    procedure SetXAxisFData(AValue: RawByteString);
    function GetXAxisFLength: integer;
    procedure SetXAxisFLength(AValue: integer);
    function GetYAxisFData: RawByteString;
    procedure SetYAxisFData(AValue: RawByteString);
    function GetYAxisFLength: integer;
    procedure SetYAxisFLength(AValue: integer);
    function GetZAxisFData: RawByteString;
    procedure SetZAxisFData(AValue: RawByteString);
    function GetZAxisFLength: integer;
    procedure SetZAxisFLength(AValue: integer);
    function GetValueFData: RawByteString;
    procedure SetValueFData(AValue: RawByteString);
    function GetValueFLength: integer;
    procedure SetValueFLength(AValue: integer);

  public
    procedure Assign(Source: TPersistent); override;
    procedure AssignTo(var ARecord: TEngineParameterItemRecord);

    procedure PublicToPublished(AMatrixItem: TMatrixItem);//내부변수 데이터를 저장 가능 변수로 이동함.
    procedure PublishedToPublic(AMatrixItem: TMatrixItem);//저장된 데이터를 내부 변수로 이동함.

    procedure DynArraySaveToMatrix1Value;
    procedure LoadFromMatrix1ValueToDynArray;

    procedure DynArraySaveToMatrix2Value;
    procedure LoadFromMatrix2ValueToDynArray;

    procedure DynArraySaveToMatrix3Value;
    procedure LoadFromMatrix3ValueToDynArray;

    procedure DynArraySaveToMatrix1fValue;
    procedure LoadFromMatrix1fValueToDynArray;

    procedure DynArraySaveToMatrix2fValue;
    procedure LoadFromMatrix2fValueToDynArray;

    procedure DynArraySaveToMatrix3fValue;
    procedure LoadFromMatrix3fValueToDynArray;

    procedure DynArraySaveToValueIData;
    procedure DynArraySaveToValueFData;

    //저장이 안됨
    property XAxisIArray[AIndex: integer]: TMatrixInteger read GetXAxisIArray write SetXAxisIArray;
    property YAxisIArray[AIndex: integer]: TMatrixInteger read GetYAxisIArray write SetYAxisIArray;
    property ZAxisIArray[AIndex: integer]: TMatrixInteger read GetZAxisIArray write SetZAxisIArray;
    property ValueIArray[AIndex: integer]: TMatrixInteger read GetValueIArray write SetValueIArray;

    property XAxisFArray[AIndex: integer]: TMatrixFloat read GetXAxisFArray write SetXAxisFArray;
    property YAxisFArray[AIndex: integer]: TMatrixFloat read GetYAxisFArray write SetYAxisFArray;
    property ZAxisFArray[AIndex: integer]: TMatrixFloat read GetZAxisFArray write SetZAxisFArray;
    property ValueFArray[AIndex: integer]: TMatrixFloat read GetValueFArray write SetValueFArray;
  published
    //Base64로 저장됨
    property XAxisIData: RawByteString read GetXAxisIData write SetXAxisIData;
    property XAxisILength: integer read GetXAxisILength write SetXAxisILength;
    property YAxisIData: RawByteString read GetYAxisIData write SetYAxisIData;
    property YAxisILength: integer read GetYAxisILength write SetYAxisILength;
    property ZAxisIData: RawByteString read GetZAxisIData write SetZAxisIData;
    property ZAxisILength: integer read GetZAxisILength write SetZAxisILength;
    property ValueIData: RawByteString read GetValueIData write SetValueIData;
    property ValueILength: integer read GetValueILength write SetValueILength;
    property XAxisFData: RawByteString read GetXAxisFData write SetXAxisFData;
    property XAxisFLength: integer read GetXAxisFLength write SetXAxisFLength;
    property YAxisFData: RawByteString read GetYAxisFData write SetYAxisFData;
    property YAxisFLength: integer read GetYAxisFLength write SetYAxisFLength;
    property ZAxisFData: RawByteString read GetZAxisFData write SetZAxisFData;
    property ZAxisFLength: integer read GetZAxisFLength write SetZAxisFLength;
    property ValueFData: RawByteString read GetValueFData write SetValueFData;
    property ValueFLength: integer read GetValueFLength write SetValueFLength;
  end;

implementation

uses UnitRttiUtil2, UnitStringUtil, UnitEncryptedRegInfo2;

{ TEngineParameter }

procedure TEngineParameter.Assign(Source: TPersistent);
var
  i: integer;
begin
//  if Source is TEngineParameter then
//  begin
    if Assigned(EngineParameterCollect) then
    begin
      EngineParameterCollect.Clear;

      for i := 0 to TEngineParameter(Source).EngineParameterCollect.Count - 1 do
        with EngineParameterCollect.Add do
          Assign(TEngineParameter(Source).EngineParameterCollect[i]);
    end;

    if Assigned(MatrixCollect) then
    begin
      MatrixCollect.Clear;

      for i := 0 to TEngineParameter(Source).MatrixCollect.Count - 1 do
        with MatrixCollect.Add do
          Assign(TEngineParameter(Source).MatrixCollect[i]);
    end;

    ExeName := TEngineParameter(Source).ExeName;
    ProjectFileName := TEngineParameter(Source).ProjectFileName;
    FilePath := TEngineParameter(Source).FilePath;
    AllowUserLevelWatchList := TEngineParameter(Source).AllowUserLevelWatchList;

    FormWidth := TEngineParameter(Source).FormWidth;
    FormHeight := TEngineParameter(Source).FormHeight;
    FormTop := TEngineParameter(Source).FormTop;
    FormLeft := TEngineParameter(Source).FormLeft;
    FormState := TEngineParameter(Source).FormState;
//  end
//  else
//    inherited;
end;

constructor TEngineParameter.Create(AOwner: TComponent);
begin
  FEngineParameterCollect := TEngineParameterCollect.Create(TEngineParameterItem);
  FMatrixCollect := TMatrixCollect.Create(TMatrixItem);
  FMultiStateCollect := TMultiStateCollect<TMultiStateItem>.Create;
end;

destructor TEngineParameter.Destroy;
begin
  inherited Destroy;

  FMultiStateCollect.Free;
  FMatrixCollect.Free;
  FEngineParameterCollect.Free;
end;

function TEngineParameter.GetItemIndex(AEPItem: TEngineParameterItem): integer;
var
  i: integer;
begin
  Result := -1;

  for i := 0 to EngineParameterCollect.Count - 1 do
  begin
    if EngineParameterCollect.Items[i].FTagName = AEPItem.FTagName then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function TEngineParameter.GetItemIndex(ATagName: string): integer;
var
  i: integer;
begin
  Result := -1;

  for i := 0 to EngineParameterCollect.Count - 1 do
  begin
    if EngineParameterCollect.Items[i].FTagName = ATagName then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function TEngineParameter.GetMatrixDataIdx(XIdx, YIdx: integer;
  AMatrixItem: TMatrixItem): integer;
begin
  //AMatrixItem.
end;

function TEngineParameter.GetMultiStateItemCount(ATagName: string): integer;
var
  i: integer;
begin
  Result := 0;

  for i := 0 to MultiStateCollect.Count - 1 do
  begin
    if MultiStateCollect.Items[i].TagName = ATagName then
      inc(Result);
  end;
end;

function TEngineParameter.GetMultiStateItemValues2JsonArray(
  ATagName: string): string;
var
  i: integer;
  LDoc: variant;
  LDynUtf8: TRawUTF8DynArray;
  LDynArr: TDynArray;
  LUtf8: RawUTF8;
begin
  Result := '';
  TDocVariant.New(LDoc);
  LDynArr.Init(TypeInfo(TRawUTF8DynArray), LDynUtf8);

  for i := 0 to MultiStateCollect.Count - 1 do
  begin
    if MultiStateCollect.Items[i].TagName = ATagName then
    begin
      LoadRecordPropertyToVariant(TObject(MultiStateCollect.Items[i]), LDoc);
      LUtf8 := LDoc;
      LDynArr.Add(LUtf8);
    end;
  end;

  Result := LDynArr.SaveToJSON();
end;

function TEngineParameter.LoadFromJSONArray(AJsonArray: RawUTF8;
  AIsAdd: Boolean): integer;
var
  LEngineParameterItem: TEngineParameterItem;
  LDocData: TDocVariantData;
  LVar: variant;
  LStr: string;
  i, LRow: integer;
begin
  //AJsonArray = [] 형식의 Engine Parameter List임
  LDocData.InitJSON(AJsonArray);
  try
    if Assigned(EngineParameterCollect) then
    begin
      if not AIsAdd then
        EngineParameterCollect.Clear;

      for i := 0 to LDocData.Count - 1 do
      begin
        LVar := _JSON(LDocData.Value[i]);

        LEngineParameterItem := EngineParameterCollect.Add;
        LoadRecordPropertyFromVariant(LEngineParameterItem, LVar);
        LEngineParameterItem.MultiStateItemIndex := -1;
      end;
    end;
  finally
    Result := LDocData.Count;
  end;
end;

function TEngineParameter.LoadFromJSONArrayOfMultiState(AJsonArray: RawUTF8;
  AIsAdd: Boolean): integer;
var
  LMultiStateItem: TMultiStateItem;
  LDocData: TDocVariantData;
  LVar: variant;
  LStr: string;
  i, LRow: integer;
begin
  //AJsonArray = [] 형식의 Multi State List임
  LDocData.InitJSON(AJsonArray);
  try
    if Assigned(MultiStateCollect) then
    begin
      if not AIsAdd then
        MultiStateCollect.Clear;

      for i := 0 to LDocData.Count - 1 do
      begin
        LVar := _JSON(LDocData.Value[i]);

        LMultiStateItem := MultiStateCollect.Add;
//        LMultiStateItem.JsonOfItems := LVar;
        LoadRecordPropertyFromVariant(LMultiStateItem, LVar);
      end;

      SetCollectItemIndex4XRef;
    end;
  finally
    Result := LDocData.Count;
  end;
end;

function TEngineParameter.LoadFromJSONFile(AFileName, APassPhrase: string;
  AIsEncrypt: Boolean): integer;
begin
  inherited;

  if MatrixCollect.Count > 0 then
    MatrixPublished2Public;

  if MultiStateCollect.Count > 0 then
    SetCollectItemIndex4XRef;
end;

function TEngineParameter.LoadFromSqliteFile(ADBFileName: string): integer;
var
  LEngParamList: RawUtf8;
begin
  Result := -1;

  InitEngineParamClient(ADBFileName);
  LEngParamList := GetEngParamList2JSONArrayFromSensorType;
  LoadFromJSONArray(LEngParamList);
  LEngParamList := GetEngineMultiStateList2JSONArrayFromSqlite;
  LoadFromJSONArrayOfMultiState(LEngParamList);

  Result := 1;
end;

function TEngineParameter.LoadFromSqliteFile4Secure(
  ADBFileName: string): integer;
begin
  InitEngineParamClient(ADBFileName);

  Result := CompareProcessorInfoBetweenReginfo(g_EngineParamDB);

  if Result = 1 then
    Result := LoadFromSqliteFile(ADBFileName);
end;

procedure TEngineParameter.MatrixPublished2Public;
var
  i: integer;
begin
  for i := 0 to MatrixCollect.Count - 1 do
  begin
    MatrixCollect.Items[i].PublishedToPublic(MatrixCollect.Items[i]);
  end;//for
end;

procedure TEngineParameter.AssignEngParamItemFromEngParamRec(
  ARecord: TEngineParamRecord; AItem: TEngineParameterItem);
var
  LDoc: variant;
  LUtf8: RawUTF8;
begin
  TDocVariant.New(LDoc);
  LoadRecordPropertyToVariant(ARecord, LDoc);
  LoadRecordPropertyFromVariant(AItem, LDoc);
end;

procedure TEngineParameter.AssignEngParamRecFromEngParamItem(
  AItem: TEngineParameterItem; ARecord: TEngineParamRecord);
var
  LDoc: variant;
  LUtf8: RawUTF8;
begin
  TDocVariant.New(LDoc);
  LoadRecordPropertyToVariant(AItem, LDoc);
  LoadEngParamRecFromVariant(ARecord, LDoc);
end;

function TEngineParameter.ComparePublicMatrix(
  AParam: TEngineParameter): integer;
var
  i,j: integer;
begin
  Result := 0;

  if MatrixCollect.Count = AParam.MatrixCollect.Count then
  begin
    for i := 0 to MatrixCollect.Count - 1 do
    begin
      //배열 크기 비교
      if High(MatrixCollect.Items[i].FXAxisIArray) =
        High(AParam.FMatrixCollect.Items[i].FXAxisIArray) then
      begin
        for j := 0 to MatrixCollect.Items[i].FXAxisICount - 1 do
        begin//배열 내용 비교
          if MatrixCollect.Items[i].XAxisIArray[j].Value <>
            AParam.FMatrixCollect.Items[i].XAxisIArray[j].Value then
          begin
            Result := 1;
            exit;
          end;
        end//for
      end
      else
      begin
        Result := 100;
        exit;
      end;

      //배열 크기 비교
      if High(MatrixCollect.Items[i].FXAxisFArray) =
        High(AParam.FMatrixCollect.Items[i].FXAxisFArray) then
      begin
        for j := 0 to MatrixCollect.Items[i].FXAxisFCount - 1 do
        begin//배열 내용 비교
          if MatrixCollect.Items[i].XAxisFArray[j].Value <>
            AParam.FMatrixCollect.Items[i].XAxisFArray[j].Value then
          begin
            Result := 2;
            exit;
          end;
        end//for
      end
      else
      begin
        Result := 200;
        exit;
      end;

      //배열 크기 비교
      if High(MatrixCollect.Items[i].FYAxisIArray) =
        High(AParam.FMatrixCollect.Items[i].FYAxisIArray) then
      begin
        for j := 0 to MatrixCollect.Items[i].FYAxisICount - 1 do
        begin//배열 내용 비교
          if MatrixCollect.Items[i].YAxisIArray[j].Value <>
            AParam.FMatrixCollect.Items[i].YAxisIArray[j].Value then
          begin
            Result := 11;
            exit;
          end;
        end//for
      end
      else
      begin
        Result := 110;
        exit;
      end;

      //배열 크기 비교
      if High(MatrixCollect.Items[i].FYAxisFArray) =
        High(AParam.FMatrixCollect.Items[i].FYAxisFArray) then
      begin
        for j := 0 to MatrixCollect.Items[i].FYAxisFCount - 1 do
        begin//배열 내용 비교
          if MatrixCollect.Items[i].YAxisFArray[j].Value <>
            AParam.FMatrixCollect.Items[i].YAxisFArray[j].Value then
          begin
            Result := 12;
            exit;
          end;
        end//for
      end
      else
      begin
        Result := 120;
        exit;
      end;

      //배열 크기 비교
      if High(MatrixCollect.Items[i].FZAxisIArray) =
        High(AParam.FMatrixCollect.Items[i].FZAxisIArray) then
      begin
        for j := 0 to MatrixCollect.Items[i].FZAxisICount - 1 do
        begin//배열 내용 비교
          if MatrixCollect.Items[i].ZAxisIArray[j].Value <>
            AParam.FMatrixCollect.Items[i].ZAxisIArray[j].Value then
          begin
            Result := 21;
            exit;
          end;
        end//for
      end
      else
      begin
        Result := 210;
        exit;
      end;

      //배열 크기 비교
      if High(MatrixCollect.Items[i].FZAxisFArray) =
        High(AParam.FMatrixCollect.Items[i].FZAxisFArray) then
      begin
        for j := 0 to MatrixCollect.Items[i].FZAxisFCount - 1 do
        begin//배열 내용 비교
          if MatrixCollect.Items[i].ZAxisFArray[j].Value <>
            AParam.FMatrixCollect.Items[i].ZAxisFArray[j].Value then
          begin
            Result := 22;
            exit;
          end;
        end//for
      end
      else
      begin
        Result := 220;
        exit;
      end;

      //배열 크기 비교
      if High(MatrixCollect.Items[i].FValueIArray) =
        High(AParam.FMatrixCollect.Items[i].FValueIArray) then
      begin
        for j := 0 to MatrixCollect.Items[i].FValueICount - 1 do
        begin//배열 내용 비교
          if MatrixCollect.Items[i].ValueIArray[j].Value <>
            AParam.FMatrixCollect.Items[i].ValueIArray[j].Value then
          begin
            Result := 31;
            exit;
          end;
        end//for
      end
      else
      begin
        Result := 310;
        exit;
      end;

      //배열 크기 비교
      if High(MatrixCollect.Items[i].FValueFArray) =
        High(AParam.FMatrixCollect.Items[i].FValueFArray) then
      begin
        for j := 0 to MatrixCollect.Items[i].FValueFCount - 1 do
        begin//배열 내용 비교
          if MatrixCollect.Items[i].ValueFArray[j].Value <>
            AParam.FMatrixCollect.Items[i].ValueFArray[j].Value then
          begin
            Result := 32;
            exit;
          end;
        end//for
      end
      else
      begin
        Result := 320;
        exit;
      end;
    end;//for
  end
  else
    Result := 50;
end;

function TEngineParameter.ComparePublishedMatrix(AParam: TEngineParameter): integer;
var
  i: integer;
begin
  Result := 0;

  if MatrixCollect.Count = AParam.MatrixCollect.Count then
  begin
    for i := 0 to MatrixCollect.Count - 1 do
    begin
      if MatrixCollect.Items[i].XAxisIData <> AParam.FMatrixCollect.Items[i].XAxisIData then
      begin
        Result := 1;
        exit;
      end;

      if MatrixCollect.Items[i].XAxisFData <> AParam.FMatrixCollect.Items[i].XAxisFData then
      begin
        Result := 2;
        exit;
      end;

      if MatrixCollect.Items[i].XAxisILength <> AParam.FMatrixCollect.Items[i].XAxisILength then
      begin
        Result := 3;
        exit;
      end;

      if MatrixCollect.Items[i].XAxisFLength <> AParam.FMatrixCollect.Items[i].XAxisFLength then
      begin
        Result := 4;
        exit;
      end;

      if MatrixCollect.Items[i].YAxisIData <> AParam.FMatrixCollect.Items[i].YAxisIData then
      begin
        Result := 11;
        exit;
      end;

      if MatrixCollect.Items[i].YAxisFData <> AParam.FMatrixCollect.Items[i].YAxisFData then
      begin
        Result := 12;
        exit;
      end;

      if MatrixCollect.Items[i].YAxisILength <> AParam.FMatrixCollect.Items[i].YAxisILength then
      begin
        Result := 13;
        exit;
      end;

      if MatrixCollect.Items[i].YAxisFLength <> AParam.FMatrixCollect.Items[i].YAxisFLength then
      begin
        Result := 14;
        exit;
      end;

      if MatrixCollect.Items[i].ZAxisIData <> AParam.FMatrixCollect.Items[i].ZAxisIData then
      begin
        Result := 21;
        exit;
      end;

      if MatrixCollect.Items[i].ZAxisFData <> AParam.FMatrixCollect.Items[i].ZAxisFData then
      begin
        Result := 22;
        exit;
      end;

      if MatrixCollect.Items[i].ZAxisILength <> AParam.FMatrixCollect.Items[i].ZAxisILength then
      begin
        Result := 23;
        exit;
      end;

      if MatrixCollect.Items[i].ZAxisFLength <> AParam.FMatrixCollect.Items[i].ZAxisFLength then
      begin
        Result := 24;
        exit;
      end;

      if MatrixCollect.Items[i].ValueIData <> AParam.FMatrixCollect.Items[i].ValueIData then
      begin
        Result := 31;
        exit;
      end;

      if MatrixCollect.Items[i].ValueFData <> AParam.FMatrixCollect.Items[i].ValueFData then
      begin
        Result := 32;
        exit;
      end;

      if MatrixCollect.Items[i].ValueILength <> AParam.FMatrixCollect.Items[i].ValueILength then
      begin
        Result := 33;
        exit;
      end;

      if MatrixCollect.Items[i].ValueFLength <> AParam.FMatrixCollect.Items[i].ValueFLength then
      begin
        Result := 34;
        exit;
      end;
  end;//for
  end
  else
    Result := 50;
end;

function TEngineParameter.SaveToJSONFile(AFileName, APassPhrase: string;
  AIsEncrypt: Boolean): integer;
begin
  inherited;
end;

function TEngineParameter.SaveToSqliteFile(ADBFileName: string; AItemIndex: integer): integer;
var
  LEngineParamRecord: TEngineParamRecord;
  LEngineParamDB: TRestClientDB;
  LEngineParamModel: TSQLModel;
  LTempUpdate: Boolean;
begin
  LEngineParamModel := nil;
  LEngineParamDB := InitEngineParamClient2(ADBFileName, LEngineParamModel);
  try
    if AItemIndex <> -1 then
    begin
      LEngineParamRecord := GetEngParamRecFromTagNo(EngineParameterCollect.Items[AItemIndex].TagName);

      LTempUpdate := LEngineParamRecord.IsUpdate;

      //아래 함수 결과로 LEngineParamRecord.IsUpdate는 무조건 False가 됨
      AssignEngParamRecFromEngParamItem(EngineParameterCollect.Items[AItemIndex], LEngineParamRecord);
      LEngineParamRecord.IsUpdate := LTempUpdate;
      AddOrUpdatedEngParamRec(LEngineParamRecord);
    end;
  finally
    DestroyEngineParamClient(LEngineParamDB, LEngineParamModel);
  end;
end;

function TEngineParameter.SaveToSqliteFile4Secure(ADBFileName: string;
  AItemIndex: integer): integer;
begin
  Result := SaveToSqliteFile(ADBFileName,AItemIndex);
end;

procedure TEngineParameter.SetCollectItemIndex4XRef;
var
  i, LIdx: integer;
  LMultiStateItem: TMultiStateItem;
  LEngineParameterItem: TEngineParameterItem;
  LStrList: TStringList;
begin
  LStrList := TStringList.Create;
  try
    for i := 0 to MultiStateCollect.Count - 1 do
    begin
      LMultiStateItem := MultiStateCollect.Items[i];

      //MultiStateItem이 없으면 -1이 대입됨
      LIdx := GetItemIndex(LMultiStateItem.TagName);
      LMultiStateItem.EngineParameterItemIndex := LIdx;

      if LIdx <> -1 then
      begin
        if LStrList.IndexOf(LMultiStateItem.TagName) <> -1 then
          continue;

        EngineParameterCollect.Items[LIdx].MultiStateItemIndex := LMultiStateItem.Index;
        EngineParameterCollect.Items[LIdx].MultiStateItemCount := GetMultiStateItemCount(LMultiStateItem.TagName);
        EngineParameterCollect.Items[LIdx].MultiStateValues := GetMultiStateItemValues2JsonArray(LMultiStateItem.TagName);
      end;

      LStrList.Add(LMultiStateItem.TagName);
    end;
  finally
    LStrList.Free;
  end;
end;

{function TEngineParameter.SaveToSqliteFile(ADBFileName: string): integer;
begin

end;

 TEngineParameterCollect }

function TEngineParameterCollect.Add: TEngineParameterItem;
begin
  Result := TEngineParameterItem(inherited Add);
end;

procedure TEngineParameterCollect.AddEngineParameterCollect(
  ASource: TEngineParameterCollect);
var
  i: integer;
begin
  for i := 0 to ASource.Count - 1 do
    AddEngineParameterItem(ASource.Items[i]);
end;

function TEngineParameterCollect.AddEngineParameterItem(
  ASource: TEngineParameterItem): TEngineParameterItem;
var
  LEngineParameterItem: TEngineParameterItem;
begin
  LEngineParameterItem := Add;
  LEngineParameterItem.Assign(ASource);
  Result := LEngineParameterItem;

//  with LEngineParameterItem do
//  begin
//    SharedName := AEngineParameterItem.SharedName;
//    UserLevel := AEngineParameterItem.UserLevel;
//    LevelIndex := AEngineParameterItem.LevelIndex;
//    NodeIndex := AEngineParameterItem.NodeIndex;
//    AbsoluteIndex := AEngineParameterItem.AbsoluteIndex;
//    MaxValue := AEngineParameterItem.MaxValue;
//    BlockNo := AEngineParameterItem.BlockNo;
//    MaxValue_Real := AEngineParameterItem.MaxValue_Real;
//    Contact := AEngineParameterItem.Contact;
//    TagName := AEngineParameterItem.TagName;
//    Description := AEngineParameterItem.Description;
//    Address := AEngineParameterItem.Address;
//    Alarm := AEngineParameterItem.Alarm;
//    FCode := AEngineParameterItem.FCode;
//    FFUnit := AEngineParameterItem.FFUnit;
//    Value := AEngineParameterItem.Value;
//    RadixPosition := AEngineParameterItem.RadixPosition;
//    MinMaxType := AEngineParameterItem.MinMaxType;
//
//    SensorType := AEngineParameterItem.SensorType;
//    ParameterCatetory := AEngineParameterItem.ParameterCatetory;
//    ParameterType := AEngineParameterItem.ParameterType;
//    ParameterSource := AEngineParameterItem.ParameterSource;
//
//    MinAlarmEnable := AEngineParameterItem.MinAlarmEnable;
//    MaxAlarmEnable := AEngineParameterItem.MaxAlarmEnable;
//    MinFaultEnable := AEngineParameterItem.MinFaultEnable;
//    MaxFaultEnable := AEngineParameterItem.MaxFaultEnable;
//    MinAlarmValue := AEngineParameterItem.MinAlarmValue;
//    MinFaultValue := AEngineParameterItem.MinFaultValue;
//    MaxAlarmValue := AEngineParameterItem.MaxAlarmValue;
//    MaxFaultValue := AEngineParameterItem.MaxFaultValue;
//    MinAlarmColor := AEngineParameterItem.MinAlarmColor;
//    MaxAlarmColor := AEngineParameterItem.MaxAlarmColor;
//    MinFaultColor := AEngineParameterItem.MinFaultColor;
//    MaxFaultColor := AEngineParameterItem.MaxFaultColor;
//    MinAlarmBlink := AEngineParameterItem.MinAlarmBlink;
//    MaxAlarmBlink := AEngineParameterItem.MaxAlarmBlink;
//    MinFaultBlink := AEngineParameterItem.MinFaultBlink;
//    MaxFaultBlink := AEngineParameterItem.MaxFaultBlink;
//    MinAlarmSoundEnable := AEngineParameterItem.MinAlarmSoundEnable;
//    MaxAlarmSoundEnable := AEngineParameterItem.MaxAlarmSoundEnable;
//    MinFaultSoundEnable := AEngineParameterItem.MinFaultSoundEnable;
//    MaxFaultSoundEnable := AEngineParameterItem.MaxFaultSoundEnable;
//    MinAlarmSoundFilename := AEngineParameterItem.MinAlarmSoundFilename;
//    MaxAlarmSoundFilename := AEngineParameterItem.MaxAlarmSoundFilename;
//    MinFaultSoundFilename := AEngineParameterItem.MinFaultSoundFilename;
//    MaxFaultSoundFilename := AEngineParameterItem.MaxFaultSoundFilename;
//    FormulaValueList := AEngineParameterItem.FormulaValueList;
//
//    IsDisplayTrend := AEngineParameterItem.IsDisplayTrend;
//    IsDisplayXY := AEngineParameterItem.IsDisplayXY;
//    TrendChannelIndex := AEngineParameterItem.TrendChannelIndex;
//    TrendAlarmIndex := AEngineParameterItem.TrendAlarmIndex;
//    TrendFaultIndex := AEngineParameterItem.TrendFaultIndex;
//    TrendYAxisIndex := AEngineParameterItem.TrendYAxisIndex;
//    PlotXValue := AEngineParameterItem.PlotXValue;
//    MinValue := AEngineParameterItem.MinValue;
//    MinValue_Real := AEngineParameterItem.MinValue_Real;
//    IsDisplaySimple := AEngineParameterItem.IsDisplaySimple;
//    YAxesMinValue := AEngineParameterItem.YAxesMinValue;
//    YAxesSpanValue := AEngineParameterItem.YAxesSpanValue;
//    UseXYGraphConstant := AEngineParameterItem.UseXYGraphConstant;
//    IsDisplayTrendAlarm := AEngineParameterItem.IsDisplayTrendAlarm;
//    IsDisplayTrendFault := AEngineParameterItem.IsDisplayTrendFault;
//
//    IsAverageValue := AEngineParameterItem.IsAverageValue;
//    AlarmLevel := AEngineParameterItem.AlarmLevel;
//    FFExcelRange := AEngineParameterItem.FFExcelRange;
//
//    MatrixItemIndex := AEngineParameterItem.MatrixItemIndex;
//    XAxisSize := AEngineParameterItem.XAxisSize;
//    YAxisSize := AEngineParameterItem.YAxisSize;
//    ZAxisSize := AEngineParameterItem.ZAxisSize;
//  end;
end;

function TEngineParameterCollect.GetItem(Index: Integer): TEngineParameterItem;
begin
  Result := TEngineParameterItem(inherited Items[Index]);
end;

function TEngineParameterCollect.GetItemFromParamNo(
  AParamNo: string): TEngineParameterItem;
var
  i: integer;
begin
  Result := nil;

  for i := 0 to Count - 1 do
  begin
    if Items[i].ParamNo = AParamNo then
    begin
      Result := Items[i];
      exit;
    end;
  end;
end;

function TEngineParameterCollect.GetItemIndexFromAddress(AFCode,AAddress: string): integer;
var
  i: integer;
begin
  Result := -1;

  for i := 0 to Count - 1 do
  begin
    if (Items[i].FFCode = AFCode) and (Items[i].Address = AAddress) then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function TEngineParameterCollect.GetUniqueParamSourceName(
  AIdx: integer): string;
begin
  Result := ParameterSource2String(Items[AIdx].ParameterSource) + '_' +
    Items[AIdx].ProjNo + '_' + Items[AIdx].EngNo;
end;

function TEngineParameterCollect.Insert(Index: Integer): TEngineParameterItem;
begin
  Result := TEngineParameterItem(inherited Insert(Index));
end;

procedure TEngineParameterCollect.SetItem(Index: Integer;
  const Value: TEngineParameterItem);
begin
  Items[Index].Assign(Value);
end;

{ TMatrixCollect }

function TMatrixCollect.Add: TMatrixItem;
begin
  Result := TMatrixItem(inherited Add);
end;

procedure TMatrixCollect.AddMatrixItem(AMatrixItem: TMatrixItem);
begin
  with Add do
  begin
    Assign(AMatrixItem);
  end;//with
end;

function TMatrixCollect.GetItem(
  Index: Integer): TMatrixItem;
begin
  Result := TMatrixItem(inherited Items[Index]);
end;

function TMatrixCollect.Insert(Index: Integer): TMatrixItem;
begin
  Result := TMatrixItem(inherited Insert(Index));
end;

procedure TMatrixCollect.SetItem(Index: Integer;
  const Value: TMatrixItem);
begin
  Items[Index].Assign(Value);
end;

{ TMatrixItem }

procedure TMatrixItem.Assign(Source: TPersistent);
begin
  if Source is TMatrixItem then
  begin
    PublicToPublished(TMatrixItem(Source));

    XAxisIData := TMatrixItem(Source).XAxisIData;
    XAxisILength := TMatrixItem(Source).XAxisILength;
    YAxisIData := TMatrixItem(Source).YAxisIData;
    YAxisILength := TMatrixItem(Source).YAxisILength;
    ZAxisIData := TMatrixItem(Source).ZAxisIData;
    ZAxisILength := TMatrixItem(Source).ZAxisILength;
    ValueIData := TMatrixItem(Source).ValueIData;
    ValueILength := TMatrixItem(Source).ValueILength;
    XAxisFData := TMatrixItem(Source).XAxisFData;
    XAxisFLength := TMatrixItem(Source).XAxisFLength;
    YAxisFData := TMatrixItem(Source).YAxisFData;
    YAxisFLength := TMatrixItem(Source).YAxisFLength;
    ZAxisFData := TMatrixItem(Source).ZAxisFData;
    ZAxisFLength := TMatrixItem(Source).ZAxisFLength;
    ValueFData := TMatrixItem(Source).ValueFData;
    ValueFLength := TMatrixItem(Source).ValueFLength;

    PublishedToPublic(Self);
  end
  else
    inherited;
end;

{ TEngineParameterItem }

procedure TMatrixItem.AssignTo(var ARecord: TEngineParameterItemRecord);
var
  i: integer;
begin
  //DragDrop에 Rawbytestring을 전달할 수 없어 string으로 변환함
//  ARecord.FMatrixItemRecord.FXAxisIData := Ansi7ToString(XAxisIData);
//  ARecord.FMatrixItemRecord.FXAxisILength := XAxisILength;
//  ARecord.FMatrixItemRecord.FYAxisIData := Ansi7ToString(YAxisIData);
//  ARecord.FMatrixItemRecord.FYAxisILength := YAxisILength;
//  ARecord.FMatrixItemRecord.FZAxisIData := Ansi7ToString(ZAxisIData);
//  ARecord.FMatrixItemRecord.FZAxisILength := ZAxisILength;
//
//  if (Length(ValueIData) <> 0) then
//  begin
//    for i := 0 to ValueILength - 1 do
//      ARecord.FMatrixItemRecord.FValueIData[i] := ValueIArray[i].Value;
//  end;
//
//  ARecord.FMatrixItemRecord.FValueILength := ValueILength;
//  ARecord.FMatrixItemRecord.FXAxisFData := Ansi7ToString(XAxisFData);
//  ARecord.FMatrixItemRecord.FXAxisFLength := XAxisFLength;
//  ARecord.FMatrixItemRecord.FYAxisFData := Ansi7ToString(YAxisFData);
//  ARecord.FMatrixItemRecord.FYAxisFLength := YAxisFLength;
//  ARecord.FMatrixItemRecord.FZAxisFData := Ansi7ToString(ZAxisFData);
//  ARecord.FMatrixItemRecord.FZAxisFLength := ZAxisFLength;
//
//  if (Length(ValueFData) <> 0) then
//  begin
//    for i := 0 to ValueFLength - 1 do
//      ARecord.FMatrixItemRecord.FValueFData[i] := ValueFArray[i].Value;
//  end;
//
//  //ARecord.FMatrixItemRecord.FValueFData := Ansi7ToString(ValueFData);
//  ARecord.FMatrixItemRecord.FValueFLength := ValueFLength;
end;

procedure TMatrixItem.DynArraySaveToMatrix1fValue;
var
  LDynArray, LDynArray2: TDynArray;
  LStr: RawByteString;
  i: integer;
begin
  LDynArray.Init(TypeInfo(TMatrixFArray), FXAxisFArray);
  //for i := Low(FXAxisFArray) to High(FXAxisFArray) do
    //LDynArray.Add(FXAxisFArray[i]);

  LStr := LDynArray.SaveTo;
  XAxisFData := BinToBase64(LStr);

  LDynArray2.Init(TypeInfo(TMatrixFArray), FValueFArray);
  //for i := Low(FValueFArray) to High(FValueFArray) do
    //LDynArray2.Add(FValueFArray[i]);

  LStr := LDynArray2.SaveTo;
  ValueFData := BinToBase64(LStr);
end;

procedure TMatrixItem.DynArraySaveToMatrix1Value;
var
  LDynArray, LDynArray2: TDynArray;
  LStr: RawByteString;
  i: integer;
begin
  LDynArray.Init(TypeInfo(TMatrixIArray), FXAxisIArray);
  //FXAxisIArray 배열이 계속 증가하기 때문에 주석처리함
  //for i := Low(FXAxisIArray) to High(FXAxisIArray) do
    //LDynArray.Add(FXAxisIArray[i]);

  LStr := LDynArray.SaveTo;
  XAxisIData := BinToBase64(LStr);

  LDynArray2.Init(TypeInfo(TMatrixIArray), FValueIArray);
  //for i := Low(FValueIArray) to High(FValueIArray) do
    //LDynArray2.Add(FValueIArray[i]);

  LStr := LDynArray2.SaveTo;
  ValueIData := BinToBase64(LStr);
end;

procedure TMatrixItem.DynArraySaveToMatrix2fValue;
var
  LDynArray, LDynArray2, LDynArray3: TDynArray;
  LStr: RawByteString;
  i: integer;
begin
  LDynArray.Init(TypeInfo(TMatrixFArray), FXAxisFArray);
  //for i := Low(FXAxisFArray) to High(FXAxisFArray) do
    //LDynArray.Add(FXAxisFArray[i]);

  LStr := LDynArray.SaveTo;
  XAxisFData := BinToBase64(LStr);

  LDynArray2.Init(TypeInfo(TMatrixFArray), FYAxisFArray);
  //for i := Low(FYAxisFArray) to High(FYAxisFArray) do
    //LDynArray.Add(FYAxisFArray[i]);

  LStr := LDynArray2.SaveTo;
  YAxisFData := BinToBase64(LStr);

  LDynArray3.Init(TypeInfo(TMatrixFArray), FValueFArray);
  //for i := Low(FValueFArray) to High(FValueFArray) do
    //LDynArray2.Add(FValueFArray[i]);

  LStr := LDynArray3.SaveTo;
  ValueFData := BinToBase64(LStr);
end;

procedure TMatrixItem.DynArraySaveToMatrix2Value;
var
  LDynArray, LDynArray2, LDynArray3: TDynArray;
  LStr: RawByteString;
  i: integer;
begin
  LDynArray.Init(TypeInfo(TMatrixIArray), FXAxisIArray);
  //for i := Low(FXAxisIArray) to High(FXAxisIArray) do
    //LDynArray.Add(FXAxisIArray[i]);

  LStr := LDynArray.SaveTo;
  XAxisIData := BinToBase64(LStr);

  LDynArray2.Init(TypeInfo(TMatrixIArray), FYAxisIArray);
  //for i := Low(FYAxisIArray) to High(FYAxisIArray) do
    //LDynArray.Add(FYAxisIArray[i]);

  LStr := LDynArray2.SaveTo;
  YAxisIData := BinToBase64(LStr);

  LDynArray3.Init(TypeInfo(TMatrixIArray), FValueIArray);
  //for i := Low(FValueIArray) to High(FValueIArray) do
    //LDynArray2.Add(FValueIArray[i]);

  LStr := LDynArray3.SaveTo;
  ValueIData := BinToBase64(LStr);
end;

procedure TMatrixItem.DynArraySaveToMatrix3fValue;
var
  LDynArray, LDynArray2, LDynArray3, LDynArray4: TDynArray;
  LStr: RawByteString;
  i: integer;
begin
  LDynArray.Init(TypeInfo(TMatrixFArray), FXAxisFArray);
  //for i := Low(FXAxisFArray) to High(FXAxisFArray) do
    //LDynArray.Add(FXAxisFArray[i]);

  LStr := LDynArray.SaveTo;
  XAxisFData := BinToBase64(LStr);

  LDynArray2.Init(TypeInfo(TMatrixFArray), FYAxisFArray);
  //for i := Low(FYAxisFArray) to High(FYAxisFArray) do
    //LDynArray.Add(FYAxisFArray[i]);

  LStr := LDynArray2.SaveTo;
  YAxisFData := BinToBase64(LStr);

  LDynArray3.Init(TypeInfo(TMatrixFArray), FZAxisFArray);
  //for i := Low(FZAxisFArray) to High(FZAxisFArray) do
    //LDynArray.Add(FZAxisFArray[i]);

  LStr := LDynArray3.SaveTo;
  ZAxisFData := BinToBase64(LStr);

  LDynArray4.Init(TypeInfo(TMatrixFArray), FValueFArray);
  //for i := Low(FValueFArray) to High(FValueFArray) do
    //LDynArray2.Add(FValueFArray[i]);

  LStr := LDynArray4.SaveTo;
  ValueFData := BinToBase64(LStr);
end;

procedure TMatrixItem.DynArraySaveToMatrix3Value;
var
  LDynArray, LDynArray2, LDynArray3, LDynArray4: TDynArray;
  LStr: RawByteString;
  i: integer;
begin
  LDynArray.Init(TypeInfo(TMatrixIArray), FXAxisIArray);
  //for i := Low(FXAxisIArray) to High(FXAxisIArray) do
    //LDynArray.Add(FXAxisIArray[i]);

  LStr := LDynArray.SaveTo;
  XAxisIData := BinToBase64(LStr);

  LDynArray2.Init(TypeInfo(TMatrixIArray), FYAxisIArray);
  //for i := Low(FYAxisIArray) to High(FYAxisIArray) do
    //LDynArray.Add(FYAxisIArray[i]);

  LStr := LDynArray2.SaveTo;
  YAxisIData := BinToBase64(LStr);

  LDynArray3.Init(TypeInfo(TMatrixIArray), FZAxisIArray);
  //for i := Low(FZAxisIArray) to High(FZAxisIArray) do
    //LDynArray.Add(FZAxisIArray[i]);

  LStr := LDynArray3.SaveTo;
  ZAxisIData := BinToBase64(LStr);

  LDynArray4.Init(TypeInfo(TMatrixIArray), FValueIArray);
  //for i := Low(FValueIArray) to High(FValueIArray) do
    //LDynArray2.Add(FValueIArray[i]);

  LStr := LDynArray4.SaveTo;
  ValueIData := BinToBase64(LStr);
end;

procedure TMatrixItem.DynArraySaveToValueFData;
var
  LDynArray2: TDynArray;
  LStr: RawByteString;
begin
  LDynArray2.Init(TypeInfo(TMatrixFArray), FValueFArray);

  LStr := LDynArray2.SaveTo;
  ValueFData := BinToBase64(LStr);
end;

procedure TMatrixItem.DynArraySaveToValueIData;
var
  LDynArray2: TDynArray;
  LStr: RawByteString;
begin
  LDynArray2.Init(TypeInfo(TMatrixIArray), FValueIArray);

  LStr := LDynArray2.SaveTo;
  ValueIData := BinToBase64(LStr);
end;

function TMatrixItem.GetXAxisIArray(AIndex: integer): TMatrixInteger;
begin
  if AIndex <= High(FXAxisIArray) then
    Result :=FXAxisIArray[AIndex];
  //else
    //Result := TMatrix1Param(nil);
end;

function TMatrixItem.GetXAxisFArray(AIndex: integer): TMatrixFloat;
begin
  if AIndex <= High(FXAxisFArray) then
    Result := FXAxisFArray[AIndex];
end;

function TMatrixItem.GetXAxisILength: integer;
begin
  Result := FXAxisICount;
end;

function TMatrixItem.GetXAxisFLength: integer;
begin
  Result := FXAxisFCount;
end;

function TMatrixItem.GetYAxisIArray(AIndex: integer): TMatrixInteger;
begin
  Result := FYAxisIArray[AIndex];
end;

function TMatrixItem.GetYAxisFArray(AIndex: integer): TMatrixFloat;
begin
  if AIndex <= High(FYAxisFArray) then
    Result := FYAxisFArray[AIndex];
end;

function TMatrixItem.GetYAxisILength: integer;
begin
  Result := FYAxisICount;
end;

function TMatrixItem.GetYAxisFLength: integer;
begin
  Result := FYAxisFCount;
end;

function TMatrixItem.GetZAxisIArray(AIndex: integer): TMatrixInteger;
begin
  Result := FZAxisIArray[AIndex];
end;

function TMatrixItem.GetZAxisFArray(AIndex: integer): TMatrixFloat;
begin
  Result := FZAxisFArray[AIndex];
end;

function TMatrixItem.GetZAxisILength: integer;
begin
  Result := FZAxisICount;
end;

function TMatrixItem.GetZAxisFLength: integer;
begin
  Result := FZAxisFCount;
end;

function TMatrixItem.GetValueIArray(AIndex: integer): TMatrixInteger;
begin
  Result := FValueIArray[AIndex];
end;

function TMatrixItem.GetValueFArray(AIndex: integer): TMatrixFloat;
begin
  Result := FValueFArray[AIndex];
end;

function TMatrixItem.GetValueILength: integer;
begin
  Result := FValueICount;
end;

function TMatrixItem.GetValueFLength: integer;
begin
  Result := FValueFCount;
end;

procedure TMatrixItem.SetXAxisIArray(AIndex: integer;
  AValue: TMatrixInteger);
begin
  if AIndex <= High(FXAxisIArray) then
  begin
    FXAxisIArray[AIndex].Value := AValue.Value;
  end;
end;

procedure TMatrixItem.SetXAxisFArray(AIndex: integer;
  AValue: TMatrixFloat);
begin
  if AIndex <= High(FXAxisFArray) then
  begin
    FXAxisFArray[AIndex].Value := AValue.Value;
  end;
end;

procedure TMatrixItem.SetXAxisILength(AValue: integer);
begin
  if FXAxisICount <> AValue then
  begin
    FXAxisICount := AValue;
    SetLength(FXAxisIArray, FXAxisICount);
  end;
end;

procedure TMatrixItem.SetXAxisFLength(AValue: integer);
begin
  if FXAxisFCount <> AValue then
  begin
    FXAxisFCount := AValue;
    SetLength(FXAxisFArray, FXAxisFCount);
  end;
end;

procedure TMatrixItem.SetYAxisIArray(AIndex: integer;
  AValue: TMatrixInteger);
begin
  if AIndex <= High(FYAxisIArray) then
  begin
    FYAxisIArray[AIndex].Value := AValue.Value;
  end;
end;

procedure TMatrixItem.SetYAxisFArray(AIndex: integer;
  AValue: TMatrixFloat);
begin
  if AIndex <= High(FYAxisFArray) then
  begin
    FYAxisFArray[AIndex].Value := AValue.Value;
  end;
end;

procedure TMatrixItem.SetYAxisILength(AValue: integer);
begin
  if FYAxisICount <> AValue then
  begin
    FYAxisICount := AValue;
    SetLength(FYAxisIArray, FYAxisICount);
  end;
end;

procedure TMatrixItem.SetYAxisFLength(AValue: integer);
begin
  if FYAxisFCount <> AValue then
  begin
    FYAxisFCount := AValue;
    SetLength(FYAxisFArray, FYAxisFCount);
  end;
end;

procedure TMatrixItem.SetZAxisIArray(AIndex: integer;
  AValue: TMatrixInteger);
begin
  if AIndex <= High(FZAxisIArray) then
  begin
    FZAxisIArray[AIndex].Value := AValue.Value;
  end;
end;

procedure TMatrixItem.SetZAxisFArray(AIndex: integer;
  AValue: TMatrixFloat);
begin
  if AIndex <= High(FZAxisFArray) then
  begin
    FZAxisFArray[AIndex].Value := AValue.Value;
  end;
end;

procedure TMatrixItem.SetZAxisILength(AValue: integer);
begin
  if FZAxisICount <> AValue then
  begin
    FZAxisICount := AValue;
    SetLength(FZAxisIArray, FZAxisICount);
  end;
end;

procedure TMatrixItem.SetZAxisFLength(AValue: integer);
begin
  if FZAxisFCount <> AValue then
  begin
    FZAxisFCount := AValue;
    SetLength(FZAxisFArray, FZAxisFCount);
  end;
end;

procedure TMatrixItem.SetValueIArray(AIndex: integer;
  AValue: TMatrixInteger);
begin
  if AIndex <= High(FValueIArray) then
  begin
    FValueIArray[AIndex].Value := AValue.Value;
  end;
end;

procedure TMatrixItem.SetValueFArray(AIndex: integer;
  AValue: TMatrixFloat);
begin
  if AIndex <= High(FValueFArray) then
  begin
    FValueFArray[AIndex].Value := AValue.Value;
  end;
end;

procedure TMatrixItem.SetValueILength(AValue: integer);
begin
  if FValueICount <> AValue then
  begin
    FValueICount := AValue;
    SetLength(FValueIArray, FValueICount);
  end;
end;

procedure TMatrixItem.SetValueFLength(AValue: integer);
begin
  if FValueFCount <> AValue then
  begin
    FValueFCount := AValue;
    SetLength(FValueFArray, FValueFCount);
  end;
end;

function TMatrixItem.GetXAxisIData: RawByteString;
begin
  Result := FXAxisIData;
end;

function TMatrixItem.GetXAxisFData: RawByteString;
begin
  Result := FXAxisFData;
end;

function TMatrixItem.GetYAxisIData: RawByteString;
begin
  Result := FYAxisIData;
end;

function TMatrixItem.GetYAxisFData: RawByteString;
begin
  Result := FYAxisFData;
end;

function TMatrixItem.GetZAxisIData: RawByteString;
begin
  Result := FZAxisIData;
end;

function TMatrixItem.GetZAxisFData: RawByteString;
begin
  Result := FZAxisFData;
end;

function TMatrixItem.GetValueIData: RawByteString;
begin
  Result := FValueIData;
end;

function TMatrixItem.GetValueFData: RawByteString;
begin
  Result := FValueFData;
end;

procedure TMatrixItem.LoadFromMatrix1fValueToDynArray;
var
  LDynArray, LDynArray2: TDynArray;
  LStr: RawByteString;
  i: integer;
begin
  LStr := Base64ToBin(XAxisFData);
  LDynArray.Init(TypeInfo(TMatrixFArray), FXAxisFArray);
  LDynArray.LoadFrom(Pointer(LStr));

  LStr := Base64ToBin(ValueFData);
  LDynArray2.Init(TypeInfo(TMatrixFArray), FValueFArray);
  LDynArray2.LoadFrom(Pointer(LStr));
end;

procedure TMatrixItem.LoadFromMatrix1ValueToDynArray;
var
  LDynArray, LDynArray2: TDynArray;
  LStr: RawByteString;
  i: integer;
begin
  LStr := Base64ToBin(XAxisIData);
  LDynArray.Init(TypeInfo(TMatrixIArray), FXAxisIArray);
  LDynArray.LoadFrom(Pointer(LStr));

  LStr := Base64ToBin(ValueIData);
  LDynArray2.Init(TypeInfo(TMatrixIArray), FValueIArray);
  LDynArray2.LoadFrom(Pointer(LStr));
end;

procedure TMatrixItem.LoadFromMatrix2fValueToDynArray;
var
  LDynArray, LDynArray2, LDynArray3: TDynArray;
  LStr: RawByteString;
  i: integer;
begin
  LStr := Base64ToBin(XAxisFData);
  LDynArray.Init(TypeInfo(TMatrixFArray), FXAxisFArray);
  LDynArray.LoadFrom(Pointer(LStr));

  LStr := Base64ToBin(YAxisFData);
  LDynArray2.Init(TypeInfo(TMatrixFArray), FYAxisFArray);
  LDynArray2.LoadFrom(Pointer(LStr));

  LStr := Base64ToBin(ValueFData);
  LDynArray3.Init(TypeInfo(TMatrixFArray), FValueFArray);
  LDynArray3.LoadFrom(Pointer(LStr));
end;

procedure TMatrixItem.LoadFromMatrix2ValueToDynArray;
var
  LDynArray, LDynArray2, LDynArray3: TDynArray;
  LStr: RawByteString;
  i: integer;
begin
  LStr := Base64ToBin(XAxisIData);
  LDynArray.Init(TypeInfo(TMatrixIArray), FXAxisIArray);
  LDynArray.LoadFrom(Pointer(LStr));

  LStr := Base64ToBin(YAxisIData);
  LDynArray2.Init(TypeInfo(TMatrixIArray), FYAxisIArray);
  LDynArray2.LoadFrom(Pointer(LStr));

  LStr := Base64ToBin(ValueIData);
  LDynArray3.Init(TypeInfo(TMatrixIArray), FValueIArray);
  LDynArray3.LoadFrom(Pointer(LStr));
end;

procedure TMatrixItem.LoadFromMatrix3fValueToDynArray;
var
  LDynArray, LDynArray2, LDynArray3, LDynArray4: TDynArray;
  LStr: RawByteString;
  i: integer;
begin
  LStr := Base64ToBin(XAxisFData);
  LDynArray.Init(TypeInfo(TMatrixFArray), FXAxisFArray);
  LDynArray.LoadFrom(Pointer(LStr));

  LStr := Base64ToBin(YAxisFData);
  LDynArray2.Init(TypeInfo(TMatrixFArray), FYAxisFArray);
  LDynArray2.LoadFrom(Pointer(LStr));

  LStr := Base64ToBin(ZAxisFData);
  LDynArray3.Init(TypeInfo(TMatrixFArray), FZAxisFArray);
  LDynArray3.LoadFrom(Pointer(LStr));

  LStr := Base64ToBin(ValueFData);
  LDynArray4.Init(TypeInfo(TMatrixFArray), FValueFArray);
  LDynArray4.LoadFrom(Pointer(LStr));
end;

procedure TMatrixItem.LoadFromMatrix3ValueToDynArray;
var
  LDynArray, LDynArray2, LDynArray3, LDynArray4: TDynArray;
  LStr: RawByteString;
  i: integer;
begin
  LStr := Base64ToBin(XAxisIData);
  LDynArray.Init(TypeInfo(TMatrixIArray), FXAxisIArray);
  LDynArray.LoadFrom(Pointer(LStr));

  LStr := Base64ToBin(YAxisIData);
  LDynArray2.Init(TypeInfo(TMatrixIArray), FYAxisIArray);
  LDynArray2.LoadFrom(Pointer(LStr));

  LStr := Base64ToBin(ZAxisIData);
  LDynArray3.Init(TypeInfo(TMatrixIArray), FZAxisIArray);
  LDynArray3.LoadFrom(Pointer(LStr));

  LStr := Base64ToBin(ValueIData);
  LDynArray4.Init(TypeInfo(TMatrixIArray), FValueIArray);
  LDynArray4.LoadFrom(Pointer(LStr));
end;

procedure TMatrixItem.PublicToPublished(AMatrixItem: TMatrixItem);
begin
  if AMatrixItem.ZAxisFLength > 0 then
    AMatrixItem.DynArraySaveToMatrix3fValue
  else
  if AMatrixItem.ZAxisILength > 0 then
    AMatrixItem.DynArraySaveToMatrix3Value
  else
  if AMatrixItem.YAxisFLength > 0 then
    AMatrixItem.DynArraySaveToMatrix2fValue
  else
  if AMatrixItem.YAxisILength > 0 then
    AMatrixItem.DynArraySaveToMatrix2Value
  else
  if AMatrixItem.XAxisFLength > 0 then
    AMatrixItem.DynArraySaveToMatrix1fValue
  else
  if AMatrixItem.XAxisILength > 0 then
    AMatrixItem.DynArraySaveToMatrix1Value;
end;

procedure TMatrixItem.PublishedToPublic(AMatrixItem: TMatrixItem);
begin
  if ZAxisFLength > 0 then
    LoadFromMatrix3fValueToDynArray
  else
  if ZAxisILength > 0 then
    LoadFromMatrix3ValueToDynArray
  else
  if YAxisFLength > 0 then
    LoadFromMatrix2fValueToDynArray
  else
  if YAxisILength > 0 then
    LoadFromMatrix2ValueToDynArray
  else
  if XAxisFLength > 0 then
    LoadFromMatrix1fValueToDynArray
  else
  if XAxisILength > 0 then
    LoadFromMatrix1ValueToDynArray;
end;

procedure TMatrixItem.SetXAxisIData(AValue: RawByteString);
begin
  FXAxisIData := AValue;
end;

procedure TMatrixItem.SetXAxisFData(AValue: RawByteString);
begin
  FXAxisFData := AValue;
end;

procedure TMatrixItem.SetYAxisIData(AValue: RawByteString);
begin
  FYAxisIData := AValue;
end;

procedure TMatrixItem.SetYAxisFData(AValue: RawByteString);
begin
  FYAxisFData := AValue;
end;

procedure TMatrixItem.SetZAxisIData(AValue: RawByteString);
begin
  FZAxisIData := AValue;
end;

procedure TMatrixItem.SetZAxisFData(AValue: RawByteString);
begin
  FZAxisFData := AValue;
end;

procedure TMatrixItem.SetValueIData(AValue: RawByteString);
begin
  FValueIData := AValue;
end;

procedure TMatrixItem.SetValueFData(AValue: RawByteString);
begin
  FValueFData := AValue;
end;

//TEngineParameterItem

procedure TEngineParameterItem.Assign(Source: TPersistent);
begin
  if Source is TEngineParameterItem then
  begin
      //Parameter 검색할때 속도가 너무 느려서 사용 안함
//    PersistentCopy(Source, TPersistent(Self));
      //대신, ModbusMapConfp_XE5.exe 에서 "Create EPItem.inc file" 메뉴를 통해
      //EPItem.inc 파일을 자동 생성하여 속도 향상 꾀함
{$I AssignEPItem.inc}
  end
  else
    inherited;
end;

procedure TEngineParameterItem.AssignTo(
  var ARecord: TEngineParameterItemRecord);
var
  LDoc: variant;
  LUtf8: RawUTF8;
//  LStr: string;
//  LMultiStateItem: TMultiStateItem;
begin
  TDocVariant.New(LDoc);
  LoadRecordPropertyToVariant(Self, LDoc, True);

  LDoc.MultiStateItemIndex := MultiStateItemIndex;
  LDoc.MultiStateItemCount := MultiStateItemCount;
//  LDoc.MultiStateValues := MultiStateValues;

  LUtf8 := _Json(LDoc);
  TRecordHlpr<TEngineParameterItemRecord>.FromJson(LUtf8,ARecord);

  StrLCopy(ARecord.FMultiStateValues, PChar(MultiStateValues), High(ARecord.FMultiStateValues));
//  LStr := ArrayToString(ARecord.FMultiStateValues);
//  ARecord.AssignToMultiStateItem(LStr, LMultiStateItem);

//  ARecord.FKbdShiftState :=
//  LUtf8 := TRecordHlpr<TEngineParameterItemRecord>.GetFields(ARecord);

//    ARecord.FSharedName := SharedName;
//    ARecord.FUserLevel := UserLevel;
//    ARecord.FLevelIndex := LevelIndex;
//    ARecord.FNodeIndex := NodeIndex;
//    ARecord.FAbsoluteIndex := AbsoluteIndex;
//    ARecord.FMaxValue := MaxValue;
//    ARecord.FBlockNo := BlockNo;
//    ARecord.FMaxValue_Real := MaxValue_Real;
//    ARecord.FContact := Contact;
//    ARecord.FTagName := TagName;
//    ARecord.FDescription := Description;
//    ARecord.FAddress := Address;
//    ARecord.FAlarm := Alarm;
//    ARecord.FFCode := FCode;
//    ARecord.FUnit := FFUnit;
//    ARecord.FValue := Value;
//    ARecord.FProjNo := ProjNo;
//    ARecord.FEngNo := EngNo;
//    ARecord.FMinMaxType := MinMaxType;
//    ARecord.FRadixPosition := RadixPosition;
//    ARecord.FDisplayUnit := DisplayUnit;
//    ARecord.FDisplayThousandSeperator := DisplayThousandSeperator;
//    ARecord.FDisplayFormat := DisplayFormat;
//    ARecord.FProjectFileName := '';
//
//    ARecord.FSensorType := SensorType;
//    ARecord.FParameterCatetory := ParameterCatetory;
//    ARecord.FParameterType := ParameterType;
//    ARecord.FParameterSource := ParameterSource;
//
//    ARecord.FAlarmEnable := AlarmEnable;
//    ARecord.FMinAlarmEnable := MinAlarmEnable;
//    ARecord.FMaxAlarmEnable := MaxAlarmEnable;
//    ARecord.FMinFaultEnable := MinFaultEnable;
//    ARecord.FMaxFaultEnable := MaxFaultEnable;
//    ARecord.FMinAlarmValue := MinAlarmValue;
//    ARecord.FMinFaultValue := MinFaultValue;
//    ARecord.FMaxAlarmValue := MaxAlarmValue;
//    ARecord.FMaxFaultValue := MaxFaultValue;
//    ARecord.FMinAlarmColor := MinAlarmColor;
//    ARecord.FMaxAlarmColor := MaxAlarmColor;
//    ARecord.FMinFaultColor := MinFaultColor;
//    ARecord.FMaxFaultColor := MaxFaultColor;
//    ARecord.FMinAlarmBlink := MinAlarmBlink;
//    ARecord.FMaxAlarmBlink := MaxAlarmBlink;
//    ARecord.FMinFaultBlink := MinFaultBlink;
//    ARecord.FMaxFaultBlink := MaxFaultBlink;
//    ARecord.FMinAlarmSoundEnable := MinAlarmSoundEnable;
//    ARecord.FMaxAlarmSoundEnable := MaxAlarmSoundEnable;
//    ARecord.FMinFaultSoundEnable := MinFaultSoundEnable;
//    ARecord.FMaxFaultSoundEnable := MaxFaultSoundEnable;
//    ARecord.FMinAlarmSoundFilename := MinAlarmSoundFilename;
//    ARecord.FMaxAlarmSoundFilename := MaxAlarmSoundFilename;
//    ARecord.FMinFaultSoundFilename := MinFaultSoundFilename;
//    ARecord.FMaxFaultSoundFilename := MaxFaultSoundFilename;
//    ARecord.FFormulaValueList := FormulaValueList;
//
//    ARecord.FIsDisplayTrend := IsDisplayTrend;
//    ARecord.FIsDisplayXY := IsDisplayXY;
//    ARecord.FTrendChannelIndex := TrendChannelIndex;
//    ARecord.FTrendAlarmIndex := TrendAlarmIndex;
//    ARecord.FTrendFaultIndex := TrendFaultIndex;
//    ARecord.FTrendYAxisIndex := TrendYAxisIndex;
//    ARecord.FPlotXValue := PlotXValue;
//    ARecord.FMinValue := MinValue;
//    ARecord.FMinValue_Real := MinValue_Real;
//    ARecord.FIsDisplaySimple := IsDisplaySimple;
//    ARecord.FYAxesMinValue := YAxesMinValue;
//    ARecord.FYAxesSpanValue := YAxesSpanValue;
//    ARecord.FUseXYGraphConstant := UseXYGraphConstant;
//    ARecord.FIsDisplayTrendAlarm := IsDisplayTrendAlarm;
//    ARecord.FIsDisplayTrendFault := IsDisplayTrendFault;
//
//    ARecord.FIsAverageValue := IsAverageValue;
//    ARecord.FAlarmLevel := AlarmLevel;
//    ARecord.FExcelRange := FFExcelRange;
//
//    ARecord.FMatrixItemIndex := MatrixItemIndex;
//    ARecord.FXAxisSize := XAxisSize;
//    ARecord.FYAxisSize := YAxisSize;
//    ARecord.FZAxisSize := ZAxisSize;
end;

constructor TEngineParameterItem.Create(ACollection: TCollection);
begin
  inherited;

  FMultiStateItemIndex := -1;
end;

function TEngineParameterItem.IsMatrixData: Boolean;
begin
  Result := (ParameterType in TMatrixTypes);
end;

{ TEngineParameterItemRecord }

procedure TEngineParameterItemRecord.AssignTo(
  var AEPItemRecord: TEngineParameterItemRecord);
var
  LDoc: variant;
  LUtf8: RawUTF8;
  LValid: Boolean;
begin
  RecordCopy(AEPItemRecord, Self, TypeInfo(TEngineParameterItemRecord));

  //  TDocVariant.New(LDoc);
//  LoadRecordPropertyToVariant(Self, LDoc, True);
//  LDoc := TRecordHlpr<TEngineParameterItemRecord>.ToVariant(Self);
//  LUtf8 := _Json(LDoc);
//  TRecordHlpr<TEngineParameterItemRecord>.FromJson(LUtf8,AEPItemRecord);

//  AEPItemRecord.FUserLevel := FUserLevel;
//  AEPItemRecord.FAlarmLevel := FAlarmLevel;
//  AEPItemRecord.FLevelIndex := FLevelIndex;
//  AEPItemRecord.FNodeIndex := FNodeIndex;
//  AEPItemRecord.FAbsoluteIndex := FAbsoluteIndex;
//  AEPItemRecord.FMaxValue := FMaxValue;
//  AEPItemRecord.FBlockNo := FBlockNo;
//  AEPItemRecord.FContact := FContact;
//  AEPItemRecord.FMaxValue_Real := FMaxValue_real;
//  AEPItemRecord.FValue := FValue;
//  AEPItemRecord.FProjNo := FProjNo;
//  AEPItemRecord.FEngNo := FEngNo;
//  AEPItemRecord.FSharedName := FSharedName;
//  AEPItemRecord.FTagName := FTagName;
//  AEPItemRecord.FDescription := FDescription;
//  AEPItemRecord.FAddress := FAddress;
//  AEPItemRecord.FFCode := FFCode;
//  AEPItemRecord.FFUnit := FFUnit;
//  AEPItemRecord.FMinMaxType := FMinMaxType; //mmtInteger, mmtReal
//  AEPItemRecord.FAlarm := FAlarm;
//  AEPItemRecord.FRadixPosition := FRadixPosition;
//  AEPItemRecord.FDisplayUnit := FDisplayUnit;
//  AEPItemRecord.FDisplayThousandSeperator := FDisplayThousandSeperator;
//  AEPItemRecord.FDisplayFormat := FDisplayFormat;
//
//  AEPItemRecord.FSensorType := FSensorType;
//  AEPItemRecord.FParameterCatetory := FParameterCatetory;
//  AEPItemRecord.FParameterType := FParameterType;
//  AEPItemRecord.FParameterSource := FParameterSource;
//  AEPItemRecord.FProjectFileName := FProjectFileName;
//  //==================================================
//  //AEPItemRecord FSelectFaultValue: integer;//0:not used, 1: original, 2: this
//
//  AEPItemRecord.FAlarmEnable := FAlarmEnable;
//
//  AEPItemRecord.FMinAlarmEnable := FMinAlarmEnable;
//  AEPItemRecord.FMaxAlarmEnable := FMaxAlarmEnable;
//  AEPItemRecord.FMinFaultEnable := FMinFaultEnable;
//  AEPItemRecord.FMaxFaultEnable := FMaxFaultEnable;
//
//  AEPItemRecord.FMinAlarmValue := FMinAlarmValue;
//  AEPItemRecord.FMaxAlarmValue := FMaxAlarmValue;
//  AEPItemRecord.FMinFaultValue := FMinFaultValue;
//  AEPItemRecord.FMaxFaultValue := FMaxFaultValue;
//
//  AEPItemRecord.FMinAlarmColor := FMinAlarmColor;
//  AEPItemRecord.FMaxAlarmColor := FMaxAlarmColor;
//  AEPItemRecord.FMinFaultColor := FMinFaultColor;
//  AEPItemRecord.FMaxFaultColor := FMaxFaultColor;
//
//  AEPItemRecord.FMinAlarmBlink := FMinAlarmBlink;
//  AEPItemRecord.FMaxAlarmBlink := FMaxAlarmBlink;
//  AEPItemRecord.FMinFaultBlink := FMinFaultBlink;
//  AEPItemRecord.FMaxFaultBlink := FMaxFaultBlink;
//
//  AEPItemRecord.FMinAlarmSoundEnable := FMinAlarmSoundEnable;
//  AEPItemRecord.FMaxAlarmSoundEnable := FMaxAlarmSoundEnable;
//  AEPItemRecord.FMinFaultSoundEnable := FMinFaultSoundEnable;
//  AEPItemRecord.FMaxFaultSoundEnable := FMaxFaultSoundEnable;
//
//  AEPItemRecord.FMinAlarmSoundFilename := FMinAlarmSoundFilename;
//  AEPItemRecord.FMaxAlarmSoundFilename := FMaxAlarmSoundFilename;
//  AEPItemRecord.FMinFaultSoundFilename := FMinFaultSoundFilename;
//  AEPItemRecord.FMaxFaultSoundFilename := FMaxFaultSoundFilename;
//
//  AEPItemRecord.FFormulaValueList := FFormulaValueList;
//
//  //=====================//for Graph (Watch 폼에서
//  AEPItemRecord.FIsDisplayTrend := FIsDisplayTrend;
//  AEPItemRecord.FIsDisplayXY := FIsDisplayXY;
//  AEPItemRecord.FTrendChannelIndex := FTrendChannelIndex;
//  AEPItemRecord.FTrendChannelIndex := FTrendAlarmIndex;
//  AEPItemRecord.FTrendFaultIndex := FTrendFaultIndex;
//  AEPItemRecord.FTrendYAxisIndex := FTrendYAxisIndex;
//  AEPItemRecord.FPlotXValue := FPlotXValue;
//  AEPItemRecord.FMinValue := FMinValue;
//  AEPItemRecord.FMinValue_Real := FMinValue_Real;
//  AEPItemRecord.FIsDisplaySimple := FIsDisplaySimple;
//  AEPItemRecord.FYAxesMinValue := FYAxesMinValue;
//  AEPItemRecord.FYAxesSpanValue := FYAxesSpanValue;
//  AEPItemRecord.FUseXYGraphConstant := FUseXYGraphConstant;
//  AEPItemRecord.FIsDisplayTrendAlarm := FIsDisplayTrendAlarm;
//  AEPItemRecord.FIsDisplayTrendFault := FIsDisplayTrendFault;
//
//  //FAllowUserLevelWatchList: THiMECSUserLevel; //watch list에서 파일 오픈시 허용 가능한 레벨
//  AEPItemRecord.FIsAverageValue := FIsAverageValue;
//  AEPItemRecord.FFExcelRange := FFExcelRange;
//
//  AEPItemRecord.FMatrixItemIndex := FMatrixItemIndex;
//  AEPItemRecord.FXAxisSize := FXAxisSize;
//  AEPItemRecord.FYAxisSize := FYAxisSize;
//  AEPItemRecord.FZAxisSize := FZAxisSize;
//
////  AEPItemRecord.FKbdShiftState := FKbdShiftState;
////  AEPItemRecord.FParamDragCopyMode := FParamDragCopyMode;
end;

procedure TEngineParameterItemRecord.AssignToMatrixItem(
  var AMItem: TMatrixItem);
var
  i: integer;
  LMInteger: TMatrixInteger;
  LMFloat: TMatrixFloat;
begin
//  if FParameterType in TMatrixTypes then
//  begin
//    //string을 Rawbytestring으로 변환함
//    AMItem.XAxisIData := StringToAnsi7(FMatrixItemRecord.FXAxisIData);
//    AMItem.XAxisILength := FMatrixItemRecord.FXAxisILength;
//    AMItem.YAxisIData := StringToAnsi7(FMatrixItemRecord.FYAxisIData);
//    AMItem.YAxisILength := FMatrixItemRecord.FYAxisILength;
//    AMItem.ZAxisIData := StringToAnsi7(FMatrixItemRecord.FZAxisIData);
//    AMItem.ZAxisILength := FMatrixItemRecord.FZAxisILength;
//
//    //AMItem.ValueIArray에 값을 넣기 전에 AMItem.ValueILength 값이 설정 되어야 함.
//    AMItem.ValueILength := FMatrixItemRecord.FValueILength;
//
//    for i := 0 to FMatrixItemRecord.FValueILength - 1 do
//    begin
//      LMInteger.Value := FMatrixItemRecord.FValueIData[i];
//      AMItem.ValueIArray[i] := LMInteger;
//    end;
//
//    AMItem.DynArraySaveToValueIData;
//    //AMItem.ValueIData := StringToAnsi7(LStr);
//
//    AMItem.XAxisFData := StringToAnsi7(FMatrixItemRecord.FXAxisFData);
//    AMItem.XAxisFLength := FMatrixItemRecord.FXAxisFLength;
//    AMItem.YAxisFData := StringToAnsi7(FMatrixItemRecord.FYAxisFData);
//    AMItem.YAxisFLength := FMatrixItemRecord.FYAxisFLength;
//    AMItem.ZAxisFData := StringToAnsi7(FMatrixItemRecord.FZAxisFData);
//    AMItem.ZAxisFLength := FMatrixItemRecord.FZAxisFLength;
//    //AMItem.ValueFData := StringToAnsi7(FMatrixItemRecord.FValueFData);
//    AMItem.ValueFLength := FMatrixItemRecord.FValueFLength;
//
//    for i := 0 to FMatrixItemRecord.FValueFLength - 1 do
//    begin
//      LMFloat.Value := FMatrixItemRecord.FValueFData[i];
//      AMItem.ValueFArray[i] := LMFloat;
//    end;
//
//    AMItem.DynArraySaveToValueFData;
//  end;
//
//  AMItem.PublishedToPublic(AMItem);
end;

function TEngineParameterItemRecord.AssignToMultiStateItem(
  const AJsonItems: string; var AMSCollect: TMultiStateCollect<TMultiStateItem>): integer;
var
  LDocData: TDocVariantData;
  LMSItem: TMultiStateItem;
  LVar: variant;
  LStr: string;
  i: integer;
begin
  //AJsonItems = [] 형식의 Multi state values List임
  LDocData.InitJSON(AJsonItems);
  try
    if Assigned(AMSCollect) then
    begin
      for i := 0 to LDocData.Count - 1 do
      begin
        LMSItem := AMSCollect.Add;
        LVar := _JSON(LDocData.Value[i]);

        LoadRecordPropertyFromVariant(LMSItem, LVar);
      end;
    end;
  finally
    Result := LDocData.Count;
  end;
end;

procedure TEngineParameterItemRecord.AssignToParamItem(
  var AEPItem: TEngineParameterItem);
var
  LDoc: variant;
begin
  TDocVariant.New(LDoc);
  LDoc := TRecordHlpr<TEngineParameterItemRecord>.ToVariant(Self);
  LoadRecordPropertyFromVariant(AEPItem, LDoc, True);

  AEPItem.MultiStateItemIndex := LDoc.FMultiStateItemIndex;
  AEPItem.MultiStateItemCount := LDoc.FMultiStateItemCount;
  AEPItem.MultiStateValues := ArrayToString(Self.FMultiStateValues);

//  AEPItem.UserLevel := FUserLevel;
//  AEPItem.AlarmLevel := FAlarmLevel;
//  AEPItem.LevelIndex := FLevelIndex;
//  AEPItem.NodeIndex := FNodeIndex;
//  AEPItem.AbsoluteIndex := FAbsoluteIndex;
//  AEPItem.MaxValue := FMaxValue;
//  AEPItem.BlockNo := FBlockNo;
//  AEPItem.Contact := FContact;
//  AEPItem.MaxValue_Real := FMaxValue_real;
//  AEPItem.Value := FValue;
//  AEPItem.SharedName := FSharedName;
//  AEPItem.TagName := FTagName;
//  AEPItem.Description := FDescription;
//  AEPItem.Address := FAddress;
//  AEPItem.FCode := FFCode;
//  AEPItem.FUnit := FFUnit;
//  AEPItem.MinMaxType := FMinMaxType; //mmtInteger, mmtReal
//  AEPItem.Alarm := FAlarm;
//  AEPItem.RadixPosition := FRadixPosition;
//  AEPItem.DisplayUnit := FDisplayUnit;
//  AEPItem.DisplayThousandSeperator := FDisplayThousandSeperator;
//  AEPItem.FDisplayFormat := FDisplayFormat;
//  AEPItem.ProjNo := FProjNo;
//  AEPItem.EngNo := FEngNo;
//
//  AEPItem.SensorType := FSensorType;
//  AEPItem.ParameterCatetory := FParameterCatetory;
//  AEPItem.ParameterType := FParameterType;
//  AEPItem.ParameterSource := FParameterSource;
//  //==================================================
//  //AEPItem FSelectFaultValue: integer;//0:not used, 1: original, 2: this
//  AEPItem.AlarmEnable := FAlarmEnable;
//
//  AEPItem.MinAlarmEnable := FMinAlarmEnable;
//  AEPItem.MaxAlarmEnable := FMaxAlarmEnable;
//  AEPItem.MinFaultEnable := FMinFaultEnable;
//  AEPItem.MaxFaultEnable := FMaxFaultEnable;
//
//  AEPItem.MinAlarmValue := FMinAlarmValue;
//  AEPItem.MaxAlarmValue := FMaxAlarmValue;
//  AEPItem.MinFaultValue := FMinFaultValue;
//  AEPItem.MaxFaultValue := FMaxFaultValue;
//
//  AEPItem.MinAlarmColor := FMinAlarmColor;
//  AEPItem.MaxAlarmColor := FMaxAlarmColor;
//  AEPItem.MinFaultColor := FMinFaultColor;
//  AEPItem.MaxFaultColor := FMaxFaultColor;
//
//  AEPItem.MinAlarmBlink := FMinAlarmBlink;
//  AEPItem.MaxAlarmBlink := FMaxAlarmBlink;
//  AEPItem.MinFaultBlink := FMinFaultBlink;
//  AEPItem.MaxFaultBlink := FMaxFaultBlink;
//
//  AEPItem.MinAlarmSoundEnable := FMinAlarmSoundEnable;
//  AEPItem.MaxAlarmSoundEnable := FMaxAlarmSoundEnable;
//  AEPItem.MinFaultSoundEnable := FMinFaultSoundEnable;
//  AEPItem.MaxFaultSoundEnable := FMaxFaultSoundEnable;
//
//  AEPItem.MinAlarmSoundFilename := FMinAlarmSoundFilename;
//  AEPItem.MaxAlarmSoundFilename := FMaxAlarmSoundFilename;
//  AEPItem.MinFaultSoundFilename := FMinFaultSoundFilename;
//  AEPItem.MaxFaultSoundFilename := FMaxFaultSoundFilename;
//
//  AEPItem.FormulaValueList := FFormulaValueList;
//
//  //=====================//for Graph (Watch 폼에서
//  AEPItem.IsDisplayTrend := FIsDisplayTrend;
//  AEPItem.IsDisplayXY := FIsDisplayXY;
//  AEPItem.TrendChannelIndex := FTrendChannelIndex;
//  AEPItem.TrendChannelIndex := FTrendAlarmIndex;
//  AEPItem.TrendFaultIndex := FTrendFaultIndex;
//  AEPItem.TrendYAxisIndex := FTrendYAxisIndex;
//  AEPItem.PlotXValue := FPlotXValue;
//  AEPItem.MinValue := FMinValue;
//  AEPItem.MinValue_Real := FMinValue_Real;
//  AEPItem.IsDisplaySimple := FIsDisplaySimple;
//  AEPItem.YAxesMinValue := FYAxesMinValue;
//  AEPItem.YAxesSpanValue := FYAxesSpanValue;
//  AEPItem.UseXYGraphConstant := FUseXYGraphConstant;
//  AEPItem.IsDisplayTrendAlarm := FIsDisplayTrendAlarm;
//  AEPItem.IsDisplayTrendFault := FIsDisplayTrendFault;
//
//  //FAllowUserLevelWatchList: THiMECSUserLevel; //watch list에서 파일 오픈시 허용 가능한 레벨
//  AEPItem.IsAverageValue := FIsAverageValue;
//  AEPItem.FExcelRange := FFExcelRange;
//
//  AEPItem.MatrixItemIndex := FMatrixItemIndex;
//  AEPItem.XAxisSize := FXAxisSize;
//  AEPItem.YAxisSize := FYAxisSize;
//  AEPItem.ZAxisSize := FZAxisSize;
//  //FProjectFileName;
//  //==========Form State
//  //FFormWidth,
//  //FFormHeight,
//  //FFormTop,
//  //FFormLeft: integer;
//  //FFormState: TpjhWindowState;
//
//  //FMatrixItemRecord: TMatrixItemRecord;
////  FKbdShiftState: TShiftState;
////  FParamDragCopyMode: TParamDragCopyMode;
end;

//function TMultiStateItem.AssignFromJsonArray(const AJsonArray: string): integer;
//var
//  LDocData: TDocVariantData;
//  LVar: variant;
//  LStr: string;
//  i: integer;
//begin
//  //AJsonItems = [] 형식의 Multi state values List임
//  LDocData.InitJSON(AJsonArray);
//  try
//    for i := 0 to LDocData.Count - 1 do
//    begin
//      LVar := _JSON(LDocData.Value[i]);
//
//      LoadRecordPropertyFromVariant(nil, LVar);
//    end;
//  finally
//    Result := LDocData.Count;
//  end;
//end;

end.

