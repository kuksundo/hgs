unit BW_Query_Class;

interface

uses classes, SysUtils{$IFDEF FMX}, FMX.ExtCtrls, FMX.Graphics, SynCrossPlatformJSON{$ENDIF}
  {$IFNDEF FMX}, BaseConfigCollect{$ENDIF};

type
  //(년단위(yyyy0101~yyyy1231), 월단위(yyyymm01~yyyymm31), 일단위, 사용자지정)
  TQryParameterType = (qptNone, qptYear, qptMonth, qptDay, qptCustom);
  TQryParameterDir = (qpdNone, qpdBegin, qpdEnd, qpdCustom);

  //수주 총괄 Query 종류(토탈,박용총괄,박용대형,박용중형, 박용선미재,박용환경기계,박용 단품,발전,산업,로봇,GS)
  TOrderTotalType = (otTotal,otShip_Total, otShip_2Stroke, otShip_4Stroke,
    otShip_Poop, otShip_Env, otShip_Part,otPower,otIndustry,otRobot,otGS, otNone);

  TBWQryData2ChartProc = procedure of object;

  TBWQryCollect = class;
  TBWQryItem = class;

  TBWQryColumnHeaderCollect = class;
  TBWQryColumnHeaderItem = class;

  TBWQryRowHeaderCollect = class;
  TBWQryRowHeaderItem = class;

  TBWQryCellDataCollect = class;
  TBWQryCellDataItem = class;

  TBWQryListClass = class(TpjhBase)
  private
    FBWQryCollect: TBWQryCollect;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

    procedure LoadFromTxt(AFileName: string; AClear: Boolean = True);
  published
    property BWQryCollect: TBWQryCollect read FBWQryCollect write FBWQryCollect;
  end;

  TBWQryClass = class(TpjhBase)
  private
    FDescription: string;
    FQueryName: string;
    FQueryText: string;
    FQueryType: integer; //0: 행,열 제목이 있는 경우 1:열 제목은 있으나 행 제목은 데이터인 경우("부문별 수주 상세 내역"에만 해당 됨)
    FQryParamType: TQryParameterType; //Parameter 유형

    FQueryDT: TDateTime;//Query를 수행한 시각

//    FBWQryCollect: TBWQryCollect;
    FBWQryCellDataCollect: TBWQryCellDataCollect;
    FBWQryColumnHeaderCollect: TBWQryColumnHeaderCollect;
    FBWQryRowHeaderCollect: TBWQryRowHeaderCollect;
  public
    FBWQryData2ChartProc: TBWQryData2ChartProc;

    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Clear;
    property QueryDT: TDateTime read FQueryDT write FQueryDT;
  published
    property Description: string read FDescription write FDescription;
    property QueryName: string read FQueryName write FQueryName;
    property QueryText: string read FQueryText write FQueryText;
    property QueryType: integer read FQueryType write FQueryType;
    property QryParamType: TQryParameterType read FQryParamType write FQryParamType;

//    property BWQryCollect: TBWQryCollect read FBWQryCollect write FBWQryCollect;
    property BWQryColumnHeaderCollect: TBWQryColumnHeaderCollect read FBWQryColumnHeaderCollect write FBWQryColumnHeaderCollect;
    property BWQryRowHeaderCollect: TBWQryRowHeaderCollect read FBWQryRowHeaderCollect write FBWQryRowHeaderCollect;
    property BWQryCellDataCollect: TBWQryCellDataCollect read FBWQryCellDataCollect write FBWQryCellDataCollect;
  end;

  TBWQryItem = class(TCollectionItem)
  private
    FDescription: string;
    FQueryName: string;
    FQueryText: string;
    //0: 행,열 제목이 있는 경우 1:열 제목은 있으나 행 제목은 데이터인 경우("부문별 수주 상세 내역"에만 해당 됨)
    //2: 열 제목이 2행 이상인 경우(등급별 Inquiry 현황;ZKA_ZKSDINM01_D_T_Q201_1)
    FQueryType: integer;
    FQryParamType: TQryParameterType; //Parameter 유형
  public
    FBWQryData2ChartProc: TBWQryData2ChartProc;
  published
    property Description: string read FDescription write FDescription;
    property QueryName: string read FQueryName write FQueryName;
    property QueryText: string read FQueryText write FQueryText;
    property QueryType: integer read FQueryType write FQueryType;
    property QryParamType: TQryParameterType read FQryParamType write FQryParamType;
  end;

  TBWQryCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TBWQryItem;
    procedure SetItem(Index: Integer; const Value: TBWQryItem);
  public
    {$IFDEF FMX}function Variant2Collect(AVariant: Variant): boolean;{$ENDIF}
    function  Add: TBWQryItem;
    function Insert(Index: Integer): TBWQryItem;
    property Items[Index: Integer]: TBWQryItem read GetItem  write SetItem; default;
  end;

  TBWQryColumnHeaderItem = class(TCollectionItem)
  private
    FColumnHeaderData: string;
    FColumnHeaderLevel: integer;
  published
    property ColumnHeaderData: string read FColumnHeaderData write FColumnHeaderData;
    property ColumnHeaderLevel: integer read FColumnHeaderLevel write FColumnHeaderLevel;
  end;

  TBWQryColumnHeaderCollect = class(TCollection)
  private
    FFixedColumnCount: integer;

    function GetItem(Index: Integer): TBWQryColumnHeaderItem;
    procedure SetItem(Index: Integer; const Value: TBWQryColumnHeaderItem);
  public
    {$IFDEF FMX}function Variant2Collect(AVariant: Variant): boolean;{$ENDIF}
    function  Add: TBWQryColumnHeaderItem;
    function Insert(Index: Integer): TBWQryColumnHeaderItem;
    property Items[Index: Integer]: TBWQryColumnHeaderItem read GetItem  write SetItem; default;
  published
    property FixedColumnCount: integer read FFixedColumnCount write FFixedColumnCount;
  end;

  TBWQryRowHeaderItem = class(TCollectionItem)
  private
    FRowHeaderData: string;   //Row Header의 Column이 복수개 인 경우를 위해 ';'으로 구분하여 저장 함
//    FSeriesColor: TColor;
  public
//    property SeriesColor: TColor read FSeriesColor write FSeriesColor;
  published
    property RowHeaderData: string read FRowHeaderData write FRowHeaderData;
  end;

  TBWQryRowHeaderCollect = class(TCollection)
  private
    FColCountOfRow: integer;  //Row Header의 Column 갯수 저장

    function GetItem(Index: Integer): TBWQryRowHeaderItem;
    procedure SetItem(Index: Integer; const Value: TBWQryRowHeaderItem);
  public
    {$IFDEF FMX}function Variant2Collect(AVariant: Variant): boolean;{$ENDIF}
    function  Add: TBWQryRowHeaderItem;
    function Insert(Index: Integer): TBWQryRowHeaderItem;
    property Items[Index: Integer]: TBWQryRowHeaderItem read GetItem  write SetItem; default;
  published
    property ColCountOfRow: integer read FColCountOfRow write FColCountOfRow;
  end;

  TBWQryCellDataItem = class(TCollectionItem)
  private
    FCol,
    FRow: integer;
    FCellData,
    FDataName: string;
  published
    property CellData: string read FCellData write FCellData;
//    property DataName: string read FDataName write FDataName; //Qry Name
    property Col: integer read FCol write FCol;
    property Row: integer read FRow write FRow;
  end;

  TBWQryCellDataCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TBWQryCellDataItem;
    procedure SetItem(Index: Integer; const Value: TBWQryCellDataItem);
  public
    FDataChanged: Boolean; //이전 값과 비교하여 변경된 데이터가 존재 하면 True

    {$IFDEF FMX}function Variant2Collect(AVariant: Variant): boolean;{$ENDIF}
    function IsDataChanged(ACol, ARow: integer; ACellData: string): Boolean;
    function  Add: TBWQryCellDataItem;
    function Insert(Index: Integer): TBWQryCellDataItem;
    property Items[Index: Integer]: TBWQryCellDataItem read GetItem  write SetItem; default;
  end;

  TInquiryInfo = class
  private
    FProductCategory,
    FProjectName,
    FShipNo,
    FProductType,
    FContractDate,    //수주예정일
    FDueDate,         //납기
    FCustomerName,
    FCustomerNation,
    FInqNo,
    FInquiryRecvDate,//접수일
    FProductCount,   //대수
    FPrice: string; //예상금액:단위 천$
  public
    FRow: integer;
  published
    property ProductCategory: string read FProductCategory write FProductCategory;
    property ProjectName: string read FProjectName write FProjectName;
    property ShipNo: string read FShipNo write FShipNo;
    property ProductType: string read FProductType write FProductType;
    property ContractDate: string read FContractDate write FContractDate;
    property DueDate: string read FDueDate write FDueDate;
    property CustomerName: string read FCustomerName write FCustomerName;
    property CustomerNation: string read FCustomerNation write FCustomerNation;
    property InqNo: string read FInqNo write FInqNo;
    property InquiryRecvDate: string read FInquiryRecvDate write FInquiryRecvDate;
    property ProductCount: string read FProductCount write FProductCount;
    property Price: string read FPrice write FPrice;
  end;

  TBWQryCellDataAllItem = class(TCollectionItem)
  private
    FQryName: string;
    FObjectJSON: string;
    //'Column Header', 'Row Header', 'Cell Data', 'All', 'ProfitPlan', 'SalesPlan', 'OrderPlan'
    FQryDataType: string;
  published
    property QryName: string read FQryName write FQryName;
    property QryDataType: string read FQryDataType write FQryDataType;
    property ObjectJSON: string read FObjectJSON write FObjectJSON;
  end;

  TBWQryCellDataAllCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TBWQryCellDataAllItem;
    procedure SetItem(Index: Integer; const Value: TBWQryCellDataAllItem);
  public
    {$IFDEF FMX}function Variant2Collect(AVariant: Variant): boolean;{$ENDIF}
    function  Add: TBWQryCellDataAllItem;
    function Insert(Index: Integer): TBWQryCellDataAllItem;
    property Items[Index: Integer]: TBWQryCellDataAllItem read GetItem  write SetItem; default;
  end;

  function strToken(var S: String; Seperator: Char): String;

implementation

function strToken(var S: String; Seperator: Char): String;
var
  I               : Word;
begin
  I:=Pos(Seperator,S);
  if I<>0 then
  begin
    Result:=System.Copy(S,1,I-1);
    System.Delete(S,1,I);
  end else
  begin
    Result:=S;
    S:='';
  end;
end;

{ TBWQryCollect }

function TBWQryCollect.Add: TBWQryItem;
begin
  Result := TBWQryItem(inherited Add);
end;

function TBWQryCollect.GetItem(Index: Integer): TBWQryItem;
begin
  Result := TBWQryItem(inherited Items[Index]);
end;

function TBWQryCollect.Insert(Index: Integer): TBWQryItem;
begin
  Result := TBWQryItem(inherited Insert(Index));
end;

procedure TBWQryCollect.SetItem(Index: Integer; const Value: TBWQryItem);
begin
  Items[Index].Assign(Value);
end;

{$IFDEF FMX}
function TBWQryCollect.Variant2Collect(AVariant: Variant): boolean;
var
  doc: TJSONVariantData;
  LJson: string;
begin
  LJson := ValueToJSON(AVariant);
  doc.Init(LJson);
  Result := doc.ToObject(self);
end;
{$ENDIF}

{ TBWQryClass }

procedure TBWQryClass.Clear;
begin
  BWQryColumnHeaderCollect.Clear;
  BWQryRowHeaderCollect.Clear;
  BWQryCellDataCollect.Clear;
end;

constructor TBWQryClass.Create(AOwner: TComponent);
begin
//  FBWQryCollect := TBWQryCollect.Create(TBWQryItem);
  FBWQryCellDataCollect := TBWQryCellDataCollect.Create(TBWQryCellDataItem);;
  FBWQryColumnHeaderCollect := TBWQryColumnHeaderCollect.Create(TBWQryColumnHeaderItem);;
  FBWQryRowHeaderCollect := TBWQryRowHeaderCollect.Create(TBWQryRowHeaderItem);;
end;

destructor TBWQryClass.Destroy;
begin
  inherited Destroy;

  FBWQryCellDataCollect.Free;
  FBWQryColumnHeaderCollect.Free;
  FBWQryRowHeaderCollect.Free;
//  FBWQryCollect.Free;
end;

{ TBWQryColumnHeaderCollect }

function TBWQryColumnHeaderCollect.Add: TBWQryColumnHeaderItem;
begin
  Result := TBWQryColumnHeaderItem(inherited Add);
end;

function TBWQryColumnHeaderCollect.GetItem(Index: Integer): TBWQryColumnHeaderItem;
begin
  Result := TBWQryColumnHeaderItem(inherited Items[Index]);
end;

function TBWQryColumnHeaderCollect.Insert(Index: Integer): TBWQryColumnHeaderItem;
begin
  Result := TBWQryColumnHeaderItem(inherited Insert(Index));
end;

procedure TBWQryColumnHeaderCollect.SetItem(Index: Integer;
  const Value: TBWQryColumnHeaderItem);
begin
  Items[Index].Assign(Value);
end;

{$IFDEF FMX}
function TBWQryColumnHeaderCollect.Variant2Collect(AVariant: Variant): boolean;
var
  doc: TJSONVariantData;
  LJson: string;
begin
  LJson := ValueToJSON(AVariant);
  doc.Init(LJson);
  Result := doc.ToObject(self);
end;
{$ENDIF}

{ TBWQryRowHeaderCollect }

function TBWQryRowHeaderCollect.Add: TBWQryRowHeaderItem;
begin
  Result := TBWQryRowHeaderItem(inherited Add);
end;

function TBWQryRowHeaderCollect.GetItem(Index: Integer): TBWQryRowHeaderItem;
begin
  Result := TBWQryRowHeaderItem(inherited Items[Index]);
end;

function TBWQryRowHeaderCollect.Insert(Index: Integer): TBWQryRowHeaderItem;
begin
  Result := TBWQryRowHeaderItem(inherited Insert(Index));
end;

procedure TBWQryRowHeaderCollect.SetItem(Index: Integer; const Value: TBWQryRowHeaderItem);
begin
  Items[Index].Assign(Value);
end;

{$IFDEF FMX}
function TBWQryRowHeaderCollect.Variant2Collect(AVariant: Variant): boolean;
var
  doc: TJSONVariantData;
  LJson: string;
begin
  LJson := ValueToJSON(AVariant);
  doc.Init(LJson);
  Result := doc.ToObject(self);
end;
{$ENDIF}

{ TBWQryCellDataCollect }

function TBWQryCellDataCollect.Add: TBWQryCellDataItem;
begin
  Result := TBWQryCellDataItem(inherited Add);
end;

function TBWQryCellDataCollect.GetItem(Index: Integer): TBWQryCellDataItem;
begin
  Result := TBWQryCellDataItem(inherited Items[Index]);
end;

function TBWQryCellDataCollect.Insert(Index: Integer): TBWQryCellDataItem;
begin
  Result := TBWQryCellDataItem(inherited Insert(Index));
end;

function TBWQryCellDataCollect.IsDataChanged(ACol, ARow: integer;
  ACellData: string): Boolean;
var
  i: integer;
begin
  Result := Count = 0;

  for i := 0 to Count - 1 do
  begin
    if (Items[i].Row = ARow) and (Items[i].Col = ACol) then
    begin
      Result := Items[i].CellData <> ACellData;
      break;
    end;
  end;

end;

procedure TBWQryCellDataCollect.SetItem(Index: Integer;
  const Value: TBWQryCellDataItem);
begin
  Items[Index].Assign(Value);
end;

{$IFDEF FMX}
function TBWQryCellDataCollect.Variant2Collect(AVariant: Variant): boolean;
var
  doc: TJSONVariantData;
  LJson: string;
begin
  LJson := ValueToJSON(AVariant);
  doc.Init(LJson);
  Result := doc.ToObject(self);
end;
{$ENDIF}

{ TBWQryListClass }

constructor TBWQryListClass.Create(AOwner: TComponent);
begin
  FBWQryCollect := TBWQryCollect.Create(TBWQryItem);
end;

destructor TBWQryListClass.Destroy;
begin
  FBWQryCollect.Free;

  inherited;
end;

procedure TBWQryListClass.LoadFromTxt(AFileName: string; AClear: Boolean);
var
  LStrList: TStringList;
  LStr: string;
  i: integer;
  LBWQryItem: TBWQryItem;
begin
  if not FileExists(AFileName) then
    exit;

  LStrList := TStringList.Create;
  try
    LStrList.LoadFromFile(AFileName);

    if AClear then
      FBWQryCollect.Clear;

    for i := 0 to LStrList.Count - 1 do
    begin
      LStr := LStrList.Strings[i];
      LBWQryItem := FBWQryCollect.Add;
      LBWQryItem.FDescription := strToken(LStr,';');
      LBWQryItem.FQueryName := strToken(LStr,';');
      LBWQryItem.FQueryText := strToken(LStr,';');
      LBWQryItem.FQueryType := StrToIntDef(strToken(LStr,';'),0);
      LBWQryItem.FQryParamType := TQryParameterType(StrToIntDef(strToken(LStr,';'),0));
    end;
  finally
    LStrList.Free;
  end;
end;

{ TBWQryCellDataAllCollect }

function TBWQryCellDataAllCollect.Add: TBWQryCellDataAllItem;
begin
  Result := TBWQryCellDataAllItem(inherited Add);
end;

function TBWQryCellDataAllCollect.GetItem(
  Index: Integer): TBWQryCellDataAllItem;
begin
  Result := TBWQryCellDataAllItem(inherited Items[Index]);
end;

function TBWQryCellDataAllCollect.Insert(Index: Integer): TBWQryCellDataAllItem;
begin
  Result := TBWQryCellDataAllItem(inherited Insert(Index));
end;

procedure TBWQryCellDataAllCollect.SetItem(Index: Integer;
  const Value: TBWQryCellDataAllItem);
begin
  Items[Index].Assign(Value);
end;

{$IFDEF FMX}
function TBWQryCellDataAllCollect.Variant2Collect(AVariant: Variant): boolean;
var
  doc: TJSONVariantData;
  LJson: string;
begin
  LJson := ValueToJSON(AVariant);
  doc.Init(LJson);
  Result := doc.ToObject(self);
end;
{$ENDIF}

end.
