unit BW_Query_Data_Class;

interface

uses Generics.Collections, System.SysUtils, SynCommons, mORMot, BW_Query_Class;

type
  TBWQryDataClass = class
  public
    FBWQryList: TDictionary<string, TBWQryClass>;
    FInquiryList: TDictionary<integer, TInquiryInfo>;
    FOrderPlanPerProduct: TBWQryCellDataCollect; //제품별 수주 경영계획
    FSalesPlanPerProduct: TBWQryCellDataCollect; //제품별 매출 경영계획
    FProfitPlanPerProduct: TBWQryCellDataCollect;//제품별 손익 경영계획
    FCellDataAllCollect: TBWQryCellDataAllCollect;

    constructor Create;
    destructor Destroy;

    function GetCellDataAll(AQryDataType: string = ''): Boolean;
    function GetBWQryList2CellDataAllCollect2JSON: string;
    procedure GetJSON2DataAllCollect2BWQryList(AJSON: string);
    //ADataType: TBWQryCellDataAllItem.QryDataType =
    //'Column Header', 'Row Header', 'Cell Data', 'All', 'ProfitPlan', 'SalesPlan', 'OrderPlan'
    function GetPlanPerProduct2CellDataAllCollect2JSON(APlanPerProduct:TBWQryCellDataCollect;
      AQryName, ADataType: string): string;
    procedure GetJSON2DataAllCollect2PlanPerProduct(APlanPerProduct:TBWQryCellDataCollect; AJSON: string);
    function GetQueryClass(AQueryName: string): TBWQryClass;
    function GetInquiryPerProdPerGrade: TRawUTF8DynArray; //등급별 제품별 Inquiry 금액
  end;

implementation

{ TBWQryDataClass }

constructor TBWQryDataClass.Create;
begin
  FBWQryList := TDictionary<string, TBWQryClass>.Create;
  FInquiryList := TDictionary<integer, TInquiryInfo>.Create;

  FOrderPlanPerProduct := TBWQryCellDataCollect.Create(TBWQryCellDataItem);
  FSalesPlanPerProduct := TBWQryCellDataCollect.Create(TBWQryCellDataItem);
  FProfitPlanPerProduct := TBWQryCellDataCollect.Create(TBWQryCellDataItem);
  FCellDataAllCollect := TBWQryCellDataAllCollect.Create(TBWQryCellDataAllItem);

  TJSONSerializer.RegisterCollectionForJSON(TBWQryColumnHeaderCollect, TBWQryColumnHeaderItem);
  TJSONSerializer.RegisterCollectionForJSON(TBWQryRowHeaderCollect, TBWQryRowHeaderItem);
  TJSONSerializer.RegisterCollectionForJSON(TBWQryCellDataCollect, TBWQryCellDataItem);
  TJSONSerializer.RegisterCollectionForJSON(TBWQryCellDataAllCollect, TBWQryCellDataAllItem);
end;

destructor TBWQryDataClass.Destroy;
var
  LKey: string;
begin
  FInquiryList.Free;

  for LKey in FBWQryList.Keys do
    TBWQryClass(FBWQryList.Items[LKey]).Free;

  FBWQryList.Free;
  FOrderPlanPerProduct.Free;
  FSalesPlanPerProduct.Free;
  FProfitPlanPerProduct.Free;
  FCellDataAllCollect.Free;
end;

function TBWQryDataClass.GetBWQryList2CellDataAllCollect2JSON: string;
var
  LKey: string;
  LValue: RawUTF8;
  LCollect: TBWQryCellDataAllCollect;
  LItem: TBWQryCellDataAllItem;
begin
  Result := '';
  LCollect := TBWQryCellDataAllCollect.Create(TBWQryCellDataAllItem);
  try
    for LKey in FBWQryList.Keys do
    begin
      LValue := ObjectToJSon(FBWQryList.Items[LKey]);

      LItem := LCollect.Add;
      LItem.ObjectJSON := UTF8ToString(LValue);//TBWQryClass가 Json으로 저장 됨
      LItem.QryName := LKey;
      LItem.QryDataType := 'BWQryList';
    end;

    LValue := ObjectToJson(FOrderPlanPerProduct);
    LItem := LCollect.Add;
    LItem.ObjectJSON := UTF8ToString(LValue);
    LItem.QryName := '';
    LItem.QryDataType := 'OrderPlanPerProduct';

    LValue := ObjectToJson(FSalesPlanPerProduct);
    LItem := LCollect.Add;
    LItem.ObjectJSON := UTF8ToString(LValue);
    LItem.QryName := '';
    LItem.QryDataType := 'SalesPlanPerProduct';

    LValue := ObjectToJson(FProfitPlanPerProduct);
    LItem := LCollect.Add;
    LItem.ObjectJSON := UTF8ToString(LValue);
    LItem.QryName := '';
    LItem.QryDataType := 'ProfitPlanPerProduct';

    Result := Utf8ToString(ObjectToJSon(LCollect));
  finally
    LCollect.Free;
  end;

//  Result := FCellDataAllCollect.Count > 0;
end;

function TBWQryDataClass.GetCellDataAll(AQryDataType: string): Boolean;
var
  LKey: string;
  LValue: RawUTF8;
  LItem: TBWQryCellDataAllItem;
  LResult: TRawUTF8DynArray;

  procedure _GetCellData(_AQryDataType: string);
  begin
    if _AQryDataType = 'All' then
      LValue := ObjectToJSon(FBWQryList.Items[LKey])
    else if _AQryDataType = 'GET_BWQRY_CELL_DATA_ALL' then
      LValue := ObjectToJSon(FBWQryList.Items[LKey].BWQryCellDataCollect)
    else if _AQryDataType = 'GET_BWQRY_COLUMN_HEADER_DATA_ALL' then
      LValue := ObjectToJSon(FBWQryList.Items[LKey].BWQryColumnHeaderCollect)
    else if _AQryDataType = 'GET_BWQRY_ROW_HEADER_DATA_ALL' then
      LValue := ObjectToJSon(FBWQryList.Items[LKey].BWQryRowHeaderCollect);

    LItem := FCellDataAllCollect.Add;
    LItem.ObjectJSON := UTF8ToString(LValue);
    LItem.QryName := LKey;
    LItem.QryDataType := _AQryDataType;
  end;
begin
  Result := False;
  FCellDataAllCollect.Clear;

  for LKey in FBWQryList.Keys do
  begin
    if AQryDataType = '' then
    begin
      _GetCellData('All');
    end
    else
      _GetCellData(AQryDataType);
  end;

  Result := FCellDataAllCollect.Count > 0;
end;

function TBWQryDataClass.GetInquiryPerProdPerGrade: TRawUTF8DynArray;
const
  ExchangeRate4USD = 1080;
var
  LBWQryClass: TBWQryClass;
  LCount: integer;
  LDynArr: TDynArray;
  LValue: RawUTF8;
  i,j: integer;
  LSum : array of array of extended; //박용기계 등급별 누계 금액
  LStr: string;
begin
  LDynArr.Init(TypeInfo(TRawUTF8DynArray),Result,@LCount);

  LBWQryClass := nil;
  LBWQryClass := GetQueryClass('ZKA_ZKSDINM01_D_T_Q201_1');

  if Assigned(LBWQryClass) then
  begin
    SetLength(LSum, 4, 9);
//    FillChar(LSum, Length(LSum), 0);  //에러 남, 원인 모름(초기화는 자동으로 됨)
    try
      for i := 0 to LBWQryClass.BWQryCellDataCollect.Count - 1 do
      begin
        if LBWQryClass.BWQryCellDataCollect.Items[i].CellData = '' then
          continue;

        //박용기계
        if ((LBWQryClass.BWQryCellDataCollect.Items[i].Row >= 1) and (LBWQryClass.BWQryCellDataCollect.Items[i].Row <= 6)) then
        begin
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 5) then
            LSum[0,0] := LSum[0,0] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//A 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 11) then
            LSum[0,1] := LSum[0,1] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//A2 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 17) then
            LSum[0,2] := LSum[0,2] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//B 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 23) then
            LSum[0,3] := LSum[0,3] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//B1 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 29) then
            LSum[0,4] := LSum[0,4] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//C 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 35) then
            LSum[0,5] := LSum[0,5] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//D 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 41) then
            LSum[0,6] := LSum[0,6] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//FO 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 47) then
            LSum[0,7] := LSum[0,7] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//S 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 53) then
            LSum[0,8] := LSum[0,8] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0);//기타 등급 년누계($)
        end
        else//엔진발전
        if ((LBWQryClass.BWQryCellDataCollect.Items[i].Row >= 7) and (LBWQryClass.BWQryCellDataCollect.Items[i].Row <= 12)) then
        begin
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 5) then
            LSum[1,0] := LSum[1,0] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//A 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 11) then
            LSum[1,1] := LSum[1,1] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//A2 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 17) then
            LSum[1,2] := LSum[1,2] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//B 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 23) then
            LSum[1,3] := LSum[1,3] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//B1 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 29) then
            LSum[1,4] := LSum[1,4] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//C 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 35) then
            LSum[1,5] := LSum[1,5] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//D 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 41) then
            LSum[1,6] := LSum[1,6] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//FO 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 47) then
            LSum[1,7] := LSum[1,7] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//S 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 53) then
            LSum[1,8] := LSum[1,8] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0);//기타 등급 년누계($)
        end
        else//산업기계
        if ((LBWQryClass.BWQryCellDataCollect.Items[i].Row >= 13) and (LBWQryClass.BWQryCellDataCollect.Items[i].Row <= 15)) then
        begin
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 5) then
            LSum[2,0] := LSum[2,0] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//A 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 11) then
            LSum[2,1] := LSum[2,1] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//A2 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 17) then
            LSum[2,2] := LSum[2,2] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//B 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 23) then
            LSum[2,3] := LSum[2,3] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//B1 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 29) then
            LSum[2,4] := LSum[2,4] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//C 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 35) then
            LSum[2,5] := LSum[2,5] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//D 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 41) then
            LSum[2,6] := LSum[2,6] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//FO 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 47) then
            LSum[2,7] := LSum[2,7] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//S 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 53) then
            LSum[2,8] := LSum[2,8] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0);//기타 등급 년누계($)
        end
        else//로봇시스템
        if ((LBWQryClass.BWQryCellDataCollect.Items[i].Row >= 16) and (LBWQryClass.BWQryCellDataCollect.Items[i].Row <= 20)) then
        begin
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 5) then
            LSum[3,0] := LSum[3,0] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//A 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 11) then
            LSum[3,1] := LSum[3,1] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//A2 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 17) then
            LSum[3,2] := LSum[3,2] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//B 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 23) then
            LSum[3,3] := LSum[3,3] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//B1 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 29) then
            LSum[3,4] := LSum[3,4] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//C 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 35) then
            LSum[3,5] := LSum[3,5] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//D 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 41) then
            LSum[3,6] := LSum[3,6] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//FO 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 47) then
            LSum[3,7] := LSum[3,7] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//S 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 53) then
            LSum[3,8] := LSum[3,8] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0);//기타 등급 년누계($)
        end
      end;

      for i := Low(LSum) to High(LSum) do
      begin
        for j := Low(LSum[0]) to High(LSum[0]) do
        begin
          LValue := StringToUTF8(FormatFloat(',0', LSum[i,j]/100000000 * ExchangeRate4USD));  //단위 억원
          LDynArr.Add(LValue);
        end;
      end;
    finally
      LSum := nil;
    end;
  end;

//  g_DisplayMessage2FCS(DateTimeToStr(Now) + ' : GetInquiryPerProdPerGrade [ ' + IntToStr(LDynArr.Count) + ' 개 데이터 전송 ]', 2);//dtCommLog
end;

procedure TBWQryDataClass.GetJSON2DataAllCollect2BWQryList(AJSON: string);
var
  LKey: string;
  LUtf8: RawUtf8;
  LBWQryClass: TBWQryClass;
  LValid: Boolean;
  LCollect: TBWQryCellDataAllCollect;
  i: integer;
begin
  if AJSON = '' then
    exit;

  for LKey in FBWQryList.Keys do
    FBWQryList.Items[LKey].Free;

  FBWQryList.Clear;
  LUtf8 := StringToUtf8(AJSON);
  LCollect := TBWQryCellDataAllCollect.Create(TBWQryCellDataAllItem);
  try
    JSONToObject(LCollect, Pointer(LUtf8), LValid);

    for i := 0 to LCollect.Count - 1 do
    begin
      if LCollect.Items[i].QryDataType = 'BWQryList' then
      begin
        LUtf8 := StringToUtf8(LCollect.Items[i].ObjectJSON);
        LBWQryClass := TBWQryClass.Create(nil);
        JSONToObject(LBWQryClass, Pointer(LUtf8), LValid);
        FBWQryList.Add(LBWQryClass.QueryName, LBWQryClass);
      end
      else
      if LCollect.Items[i].QryDataType = 'OrderPlanPerProduct' then
      begin
        FOrderPlanPerProduct.Clear;
        LUtf8 := StringToUtf8(LCollect.Items[i].ObjectJSON);
        JSONToObject(FOrderPlanPerProduct, Pointer(LUtf8), LValid);
      end
      else
      if LCollect.Items[i].QryDataType = 'SalesPlanPerProduct' then
      begin
        FSalesPlanPerProduct.Clear;
        LUtf8 := StringToUtf8(LCollect.Items[i].ObjectJSON);
        JSONToObject(FSalesPlanPerProduct, Pointer(LUtf8), LValid);
      end
      else
      if LCollect.Items[i].QryDataType = 'ProfitPlanPerProduct' then
      begin
        FProfitPlanPerProduct.Clear;
        LUtf8 := StringToUtf8(LCollect.Items[i].ObjectJSON);
        JSONToObject(FProfitPlanPerProduct, Pointer(LUtf8), LValid);
      end;
    end;
  finally
    LCollect.Free;
  end;
end;

procedure TBWQryDataClass.GetJSON2DataAllCollect2PlanPerProduct(
  APlanPerProduct:TBWQryCellDataCollect; AJSON: string);
var
  LUtf8: RawUtf8;
  LValid: Boolean;
  LCollect: TBWQryCellDataAllCollect;
//  i: integer;
begin
  if AJSON = '' then
    exit;

  APlanPerProduct.Clear;
  LUtf8 := StringToUtf8(AJSON);
  LCollect := TBWQryCellDataAllCollect.Create(TBWQryCellDataAllItem);
  try
    JSONToObject(LCollect, Pointer(LUtf8), LValid);

//    for i := 0 to LCollect.Count - 1 do
//    begin
//      if LCollect.Items[i].QryDataType = 'ProfitPlan' then
//      begin
        LUtf8 := StringToUtf8(LCollect.Items[0].ObjectJSON);
        JSONToObject(APlanPerProduct, Pointer(LUtf8), LValid);
//      end;
//    end;
  finally
    LCollect.Free;
  end;
end;

function TBWQryDataClass.GetPlanPerProduct2CellDataAllCollect2JSON(
  APlanPerProduct:TBWQryCellDataCollect; AQryName, ADataType: string): string;
var
  LValue: RawUTF8;
  LCollect: TBWQryCellDataAllCollect;
  LItem: TBWQryCellDataAllItem;
begin
  Result := '';
  LCollect := TBWQryCellDataAllCollect.Create(TBWQryCellDataAllItem);
  try
    LValue := ObjectToJSon(APlanPerProduct);

    LItem := LCollect.Add;
    LItem.ObjectJSON := UTF8ToString(LValue);//APlanPerProduct Json으로 저장 됨
    LItem.QryName := AQryName;
    LItem.QryDataType := ADataType;

    Result := Utf8ToString(ObjectToJSon(LCollect));
  finally
    LCollect.Free;
  end;
end;

function TBWQryDataClass.GetQueryClass(AQueryName: string): TBWQryClass;
var
  LKey: string;
begin
  Result := nil;

  for LKey in FBWQryList.Keys do
  begin
    if LKey = AQueryName then
    begin
      Result := FBWQryList.Items[LKey];
      exit;
    end;
  end;
end;

//initialization
//  TJSONSerializer.RegisterCollectionForJSON(TBWQryCellDataCollect, TBWQryCellDataItem);

end.
