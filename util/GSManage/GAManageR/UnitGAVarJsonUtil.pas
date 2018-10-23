unit UnitGAVarJsonUtil;

interface

uses System.Classes, Dialogs, System.Rtti,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid,
  Cromis.Comm.Custom, Cromis.Comm.IPC, Cromis.Threading, Cromis.AnyValue,
  CommonData, SynCommons, mORMot, DateUtils, System.SysUtils, UnitGSFileRecord,
  mORMotHttpClient, Winapi.ActiveX, Generics.Collections, UnitBase64Util,
  UnitMustacheUtil, UnitGAMasterRecord;

function MakeEmailHTMLBody(ATask: TSQLGSTask; AMailType: integer;
  ASalesPICSig, ATaskAShippingPICSig, AFieldServicePICSig, AElecHullRegPICSig, AMyNameSig: string): string;
function MakeSalesReqEmailBody(ATask: TSQLGSTask; ASalesPICSig, AMyNameSig: string): string;
function MakeInvoiceEmailBody(ATask: TSQLGSTask): string;
function MakeDirectShippingEmailBody(ATask: TSQLGSTask): string;
function MakeForeignRegEmailBody(ATask: TSQLGSTask): string;
function MakeElecHullRegReqEmailBody(ATask: TSQLGSTask; AElecHullRegPICSig, AMyNameSig: string): string;
function MakePOReqEmailBody(ATask: TSQLGSTask): string;
function MakeShippingReqEmailBody(ATask: TSQLGSTask; AShippingPICSig, AMyNameSig: string): string;
function MakeForwardFieldServiceEmailBody(ATask: TSQLGSTask; AFieldServicePICSig, AMyNameSig: string): string;
function MakeForwardPayCheckSubConEmailBody(ATask: TSQLGSTask; AMyNameSig: string): string;
function MakeSubConQuotationReqEmailBody(ATask: TSQLGSTask; ASubConPICSig, AMyNameSig: string): string;
function MakeForwardSubConPaymentReqEmailBody(ATask: TSQLGSTask; ASubConPaymentPICSig, AMyNameSig: string): string;
function MakeSubConServiceOrderReqEmailBody(ATask: TSQLGSTask; ASubConPICEMailAddr, ASubConPICSig, AMyNameSig: string): string;

function MakeTaskInfoEmailAttached(ATask: TSQLGSTask; var AFileName: string;
  ASubConID: integer = -1): string;
function MakeTaskList2JSONArray(ATask: TSQLGSTask): RawUTF8;
function MakeTaskDetail2JSON(ATask: TSQLGSTask): RawUTF8;
function MakeGSFile2JSON(ASQLGSFile: TSQLGSFile): RawUTF8;
function MakeTaskEmailList2JSON(ATaskID: TID): RawUTF8;
//function MakeTaskEmailContent2JSON(): RawUTF8;
function MakeInvoiceTaskInfo2JSON(ATask: TSQLInvoiceTask; var AFileName: string): string;
function MakeInvoiceItemFromVar(ADoc: variant): string;
procedure AddInvoiceItemFromVar2ItemList(ASrc: variant; var AItemList: TObjectList<TSQLInvoiceItem>);

procedure GetInvoiceItem2Var(ADelimitedStr: string; var ADoc: variant);
function GetTaskInfoAttachedFileName(AVar: variant): string;
function GetInvoiceTaskInfoAttachedFileName(AVar: variant): string;
procedure GetCompanyCodeFromSubConArray(ADoc: variant; var ACompanyCode, ACompanyName: string);
function LoadInvoiceTaskFromVariant(ATask:TSQLInvoiceTask; ADoc: variant): Boolean;
procedure LoadInvoiceItemListFromVariant(ADoc: variant; AItemList: TObjectList<TSQLInvoiceItem>);
procedure LoadSubconInvoiceItemListFromVariant(ADoc: variant; AItemList: TObjectList<TSQLSubConInvoiceItem>);
procedure LoadSubconListFromVariant(ADoc: variant; ASubConList: TObjectList<TSQLSubCon>);

procedure LoadInvoiceItemFromVariant(AItem:TSQLInvoiceItem; ADoc: variant);
procedure LoadInvoiceItemFromVarArray(AItem:TSQLInvoiceItem; ADoc: variant);
procedure LoadSubConInvoiceItemFromVariant(AItem:TSQLSubConInvoiceItem; ADoc: variant);
procedure LoadInvoiceItem2Var(AItem:TSQLInvoiceItem; var ADoc: variant);
procedure LoadSubConInvoiceItems2Variant(ASQLSubConInvoiceItem: TSQLSubConInvoiceItem; var ADoc: Variant);
procedure LoadSubConInvoiceFiles2Variant(ASQLSubConInvoiceFile: TSQLSubConInvoiceFile; var ADoc: Variant);
procedure GetInvoiceItemFromObjList2Var(AItemList: TObjectList<TSQLInvoiceItem>; var ADoc: variant);
procedure LoadInvoiceFileListFromVariantWithSQLInvoiceFile(ADoc: variant; AFileList: TObjectList<TSQLInvoiceFile>);
procedure LoadSubConInvoiceFileListFromVariantWithSQLSubConInvoiceFile(ADoc: variant; AFileList: TObjectList<TSQLSubConInvoiceFile>);
procedure LoadSubConInvoiceFileListFromVariant(ADoc: variant; AFileList: TObjectList<TSQLSubConInvoiceFile>);
procedure LoadInvoiceFileFromVariant(AFile:TSQLInvoiceFile; ADoc: variant);
procedure LoadSubConInvoiceFileFromVariant(AFile:TSQLSubConInvoiceFile; ADoc: variant);
procedure LoadInvoiceFileFromJSON(AFile:TSQLInvoiceFile; AJson: RawUTF8);
procedure LoadSubConInvoiceFileFromJSON(AFile:TSQLSubConInvoiceFile; AJson: RawUTF8);

function MakeMailSubject(ATask: TSQLGSTask; AMailType: integer): string;
function LoadRecordList2VariantFromSQlRecord(ASQLRecord: TSQLRecord): variant;

implementation

uses UnitGAMakeReport, UnitStringUtil, StrUtils, SynMustache, UnitGAServiceData,
  UnitGSTriffData;

function MakeDirectShippingEmailBody(ATask: TSQLGSTask): string;
var
  LDoc: variant;
  LSQLMaterial: TSQLMaterial4Project;
  LJSON: RawUTF8;
  LMustache: TSynMustache;
  LFile: RawByteString;
begin
  TDocVariant.New(LDoc);
  LDoc.OrderNo := ATask.ShipName;

  LSQLMaterial := GetMaterial4ProjFromTask(ATask);
  try
    LDoc.PorNo := LSQLMaterial.PORNo;
  finally
    FreeAndNil(LSQLMaterial);
  end;

  Result := GetMustacheJSONFromFile(LDoc, DOC_DIR + DIRECT_SHIPPING_MUSTACHE_FILE_NAME);
end;

function MakeElecHullRegReqEmailBody(ATask: TSQLGSTask; AElecHullRegPICSig, AMyNameSig: string): string;
var
  LDoc: variant;
  LJSON: RawUTF8;
  LMustache: TSynMustache;
  LFile: RawByteString;
  LSQLCustomer: TSQLCustomer;
begin
  TDocVariant.New(LDoc);
  LDoc.To := AElecHullRegPICSig;
  LDoc.From := AMyNameSig;
  LDoc.HullNo := ATask.HullNo;
  LDoc.Summary := ATask.WorkSummary;
  LDoc.ProductType := ATask.ProductType;

  LSQLCustomer := GetCustomerFromTask(ATask);
  try
    LDoc.CompanyName := LSQLCustomer.CompanyName;
    LDoc.CompanyCode := LSQLCustomer.CompanyCode;
  finally
    FreeAndNil(LSQLCustomer);
  end;

  Result := GetMustacheJSONFromFile(LDoc, DOC_DIR + ELEC_HULLNO_REG_REQ_MUSTACHE_FILE_NAME);
end;

function MakeForeignRegEmailBody(ATask: TSQLGSTask): string;
var
  LDoc: variant;
  LJSON: RawUTF8;
  LMustache: TSynMustache;
  LFile: RawByteString;
begin
  TDocVariant.New(LDoc);
  LDoc.CompanyName := ATask.ShipOwner;

  Result := GetMustacheJSONFromFile(LDoc, DOC_DIR + FOREIGN_REG_MUSTACHE_FILE_NAME);
end;

function MakeEmailHTMLBody(ATask: TSQLGSTask; AMailType: integer;
  ASalesPICSig, ATaskAShippingPICSig, AFieldServicePICSig, AElecHullRegPICSig,
  AMyNameSig: string): string;
begin
  case AMailType of
    1: Result := MakeInvoiceEmailBody(ATask);
    2: Result := MakeSalesReqEmailBody(ATask, ASalesPICSig, AMyNameSig);
    3: Result := MakeDirectShippingEmailBody(ATask);
    4: Result := MakeForeignRegEmailBody(ATask);
    5: Result := MakeElecHullRegReqEmailBody(ATask, AElecHullRegPICSig, AMyNameSig);
    6: Result := MakePOReqEmailBody(ATask);
    7: Result := MakeShippingReqEmailBody(ATask, ATaskAShippingPICSig, AMyNameSig);
    8: Result := MakeForwardFieldServiceEmailBody(ATask, AFieldServicePICSig, AMyNameSig);
//    9: Result := MakeSubConQuotationReqEmailBody(ATask, ASubConPICSig, AMyNameSig);
    10: Result := '[서비스 오더 날인 및 회신 요청] / ' + ATask.HullNo + ', 공사번호: ' + ATask.Order_No;
    11: Result := MakeForwardPayCheckSubConEmailBody(ATask, AMyNameSig);//'[업체 기성 확인 요청] / ' + ATask.HullNo + ', 공사번호: ' + ATask.Order_No;
    12: Result := '[업체 기성 처리 요청] / ' + ATask.HullNo + ', 공사번호: ' + ATask.Order_No;
  end;
end;

function MakeInvoiceEmailBody(ATask: TSQLGSTask): string;
var
  LDoc: variant;
  LSQLCustomer: TSQLCustomer;
begin
  TDocVariant.New(LDoc);
  LDoc.VesselName := ATask.ShipName;
  LDoc.HullNo := ATask.HullNo;
  LDoc.PONO := ATask.PO_No;
  LDoc.Location := ATask.NationPort;

  LSQLCustomer := GetCustomerFromTask(ATask);
  try
    LDoc.Name := LSQLCustomer.ManagerName;
  finally
    FreeAndNil(LSQLCustomer);
  end;

  Result := GetMustacheJSONFromFile(LDoc, DOC_DIR + INVOICE_SEND_MUSTACHE_FILE_NAME);
end;

function MakeMailSubject(ATask: TSQLGSTask; AMailType: integer): string;
begin
  case AMailType of
    1: Result := 'Send Invouice';
    2: Result := '[메출처리 요청 건] ' + ATask.Order_No;
    3: Result := '입고 처리 요청';
    4: Result := '해외매출 고객사 거래처 등록 요청의 건';
    5: Result := '전전 비표준 공사 생성 요청 건 (' + ATask.HullNo + ')';
    6: Result := MakeDirectShippingEmailBody(ATask);
    7: Result := '[출하 요청 건] / ' + ATask.ShippingNo;
    8: Result := '[필드서비스팀 진행 요청] / ' + ATask.HullNo + ', PO: ' + ATask.PO_No;
    9: Result := '[업체 기성 확인 요청] / ' + ATask.HullNo + ', 공사번호: ' + ATask.Order_No;
    10: Result := '[서비스 오더 날인 및 회신 요청] / ' + ATask.HullNo + ', 공사번호: ' + ATask.Order_No;
    11: Result := '[업체 기성 처리 요청] / ' + ATask.HullNo + ', 공사번호: ' + ATask.Order_No;
  end;
end;

function MakePOReqEmailBody(ATask: TSQLGSTask): string;
var
  LDoc: variant;
  LJSON: RawUTF8;
  LMustache: TSynMustache;
  LFile: RawByteString;
  LSQLCustomer: TSQLCustomer;
begin
  TDocVariant.New(LDoc);
  LDoc.HullNo := ATask.HullNo;
  LDoc.Summary := ATask.WorkSummary;
  LDoc.ProductType := ATask.ProductType;

  LSQLCustomer := GetCustomerFromTask(ATask);
  try
    LDoc.CompanyName := LSQLCustomer.CompanyName;
    LDoc.CompanyCode := LSQLCustomer.CompanyCode;
  finally
    FreeAndNil(LSQLCustomer);
  end;

  Result := GetMustacheJSONFromFile(LDoc, DOC_DIR + PO_REQ_MUSTACHE_FILE_NAME);
end;

function MakeSalesReqEmailBody(ATask: TSQLGSTask; ASalesPICSig, AMyNameSig: string): string;
var
  LDoc: variant;
  LSQLCustomer: TSQLCustomer;
  LDate: TDate;
  LPrice: string;
begin
  TDocVariant.New(LDoc);
  LDoc.To := ASalesPICSig;// SALES_MANAGER_SIG;
  LDoc.From := AMyNameSig;//MY_EMAIL_SIG;
  LDoc.OrderNo := ATask.Order_No;
  LPrice := UTF8ToString(ATask.SalesPrice);

  if not ContainsText(LPrice, ',') then
    LPrice := AddThousandSeparator(LPrice,',');

  LDoc.SalesPrice :=
    TRttiEnumerationType.GetName<TCurrencyKind>(TCurrencyKind(ATask.CurrencyKind)) +
     ' ' + LPrice;
  LDoc.ShippingNo := ATask.ShippingNo;

  LDate := TimeLogToDateTime(ATask.SalesReqDate);

  if YearOf(LDate) > 1900 then
    LDoc.SalesReqDate := FormatDateTime('yyyy-mm-dd',LDate)
  else
    LDoc.SalesReqDate := 'NIL';

  LSQLCustomer := GetCustomerFromTask(ATask);
  try
    LDoc.CustName := LSQLCustomer.CompanyName;
    LDoc.CustNo := LSQLCustomer.CompanyCode;
  finally
    FreeAndNil(LSQLCustomer);
  end;

  Result := GetMustacheJSONFromFile(LDoc, DOC_DIR + SALES_MUSTACHE_FILE_NAME);
//  QuotedStrJSON(VariantToUTF8(LDoc), LJSON);
end;

function MakeShippingReqEmailBody(ATask: TSQLGSTask;
  AShippingPICSig, AMyNameSig: string): string;
var
  LDoc: variant;
  LSQLMaterial4Project: TSQLMaterial4Project;
  LDate: TDate;
begin
  TDocVariant.New(LDoc);
  LDoc.To := AShippingPICSig;// SHIPPING_MANAGER_SIG;
  LDoc.From := AMyNameSig;// MY_EMAIL_SIG;
  LDoc.ShippingNo := ATask.ShippingNo; //출하지시번호
  LDoc.OrderNo := ATask.Order_No;//공사지시번호
  LDoc.PONo := ATask.PO_No;
  LDoc.ShipName := ATask.ShipName;

  LSQLMaterial4Project := GetMaterial4ProjFromTask(ATask);
  try
    LDoc.DeliveryAddr := LSQLMaterial4Project.DeliveryAddress;
  finally
    FreeAndNil(LSQLMaterial4Project);
  end;

  Result := GetMustacheJSONFromFile(LDoc, DOC_DIR + SHIPPING_MUSTACHE_FILE_NAME);
end;

function MakeForwardFieldServiceEmailBody(ATask: TSQLGSTask;
  AFieldServicePICSig, AMyNameSig: string): string;
var
  LDoc: variant;
  LSQLCustomer: TSQLCustomer;
  LDate: TDate;
begin
  TDocVariant.New(LDoc);
  LDoc.To := AFieldServicePICSig;// FIELDSERVICE_MANAGER_SIG;
  LDoc.From := AMyNameSig;//MY_EMAIL_SIG;
  LDoc.Summary := ATask.WorkSummary;
  LDoc.WorkDay := FormatDateTime('yyyy-mm-dd', TimeLogToDateTime(ATask.WorkBeginDate));
  LDoc.Port := ATask.NationPort;
  LDoc.WorkOrder := ATask.Order_No;

  if ATask.ID <> 0 then
  begin
    LSQLCustomer := GetCustomerFromTask(ATask);
    try
      LDoc.LocalAgent := LSQLCustomer.AgentInfo;
    finally
      FreeAndNil(LSQLCustomer);
    end;
  end
  else
    LDoc.LocalAgent := ATask.EtcContent;

  Result := GetMustacheJSONFromFile(LDoc, DOC_DIR + FORWARD_FIELDSERVICE_MUSTACHE_FILE_NAME);
end;

function MakeForwardPayCheckSubConEmailBody(ATask: TSQLGSTask; AMyNameSig: string): string;
var
  LDoc: variant;
begin
  TDocVariant.New(LDoc);
  LDoc.To := '영업 담당자님';// SHIPPING_MANAGER_SIG;
  LDoc.From := AMyNameSig;// MY_EMAIL_SIG;
  LDoc.HullNo := ATask.HullNo; //호선번호
  LDoc.OrderNo := ATask.Order_No;//공사지시번호
  LDoc.ShipName := ATask.ShipName;

  Result := GetMustacheJSONFromFile(LDoc, DOC_DIR + PAYCHECK_SUBCON_MUSTACHE_FILE_NAME);
end;

function MakeSubConQuotationReqEmailBody(ATask: TSQLGSTask; ASubConPICSig, AMyNameSig: string): string;
var
  LDoc: variant;
begin
  TDocVariant.New(LDoc);
  LDoc.To := ASubConPICSig;// SHIPPING_MANAGER_SIG;
  LDoc.From := AMyNameSig;// MY_EMAIL_SIG;
  LDoc.HullNo := ATask.HullNo; //호선번호
//  LDoc.OrderNo := ATask.Order_No;//공사지시번호
  LDoc.ShipName := ATask.ShipName;
  LDoc.Port := ATask.NationPort;
  LDoc.WorkDay := DateToStr(ATask.WorkBeginDate) + '~' + DateToStr(ATask.WorkEndDate);
  LDoc.Summary := ATask.WorkSummary;
  LDoc.AgentInfo := LoadAgentInfoFromTask(ATask);

  Result := GetMustacheJSONFromFile(LDoc, DOC_DIR + SUBCON_QUOTATION_REQ_MUSTACHE_FILE_NAME);
end;

function MakeForwardSubConPaymentReqEmailBody(ATask: TSQLGSTask; ASubConPaymentPICSig, AMyNameSig: string): string;
begin

end;

function MakeSubConServiceOrderReqEmailBody(ATask: TSQLGSTask; ASubConPICEMailAddr, ASubConPICSig, AMyNameSig: string): string;
begin

end;

//InqManage의 grid_Req에서 Task를 Drag할때 JSON 파일(*.hgs) 생성하는 함수
//ASubConID : SubCon을 한개만 선택할 때 = -1, 두개 이상일때 = SubConID
//(TaskEditForm의 SubConGrid에서 한개의 협력사만 선택하여 Drag하면 한개의 협력사만 *.hgs파일에 포함됨)
function MakeTaskInfoEmailAttached(ATask: TSQLGSTask; var AFileName: string;
   ASubConID: integer = -1): string;
var
  LUtf8: RawUTF8;
  LDynUtf8, LDynUtf8Item, LDynUtf8File: TRawUTF8DynArray;
  LDynArr, LDynArrItem, LDynArrFile: TDynArray;
  LCount: integer;
  LCustomer: TSQLCustomer;
  LSubCon: TSQLSubCon;
  LMat4Proj: TSQLMaterial4Project;
  LV,LV2,LV3: variant;
  LRaw: RawByteString;
  LSubConList: TObjectList<TSQLSubCon>;
  i: integer;

  procedure GetSubCon2DynArr;
  begin
    LUtf8 := LSubCon.GetJSONValues(true, true, soSelect);
    LDynArr.Add(LUtf8);
    LUtf8 := LSubCon.InvoiceItems;
    LDynArrItem.Add(LUtf8);
    LUtf8 := LSubCon.InvoiceFiles;
    LDynArrFile.Add(LUtf8);
  end;
begin
  TDocVariant.New(LV);
//  TDocVariant.New(LV2);
  LV.TaskJsonDragSign := TASK_JSON_DRAG_SIGNATURE;
  LUtf8 := ATask.GetJSONValues(true, true, soSelect);
  LV.Task := _JSON(LUtf8);

  LCustomer := GetCustomerFromTask(ATask);
  try
    LUtf8 := LCustomer.GetJSONValues(true, true, soSelect);
    LV.Customer := _JSON(LUtf8);

    LDynArr.Init(TypeInfo(TRawUTF8DynArray), LDynUtf8);
    LDynArrItem.Init(TypeInfo(TRawUTF8DynArray), LDynUtf8Item);
    LDynArrFile.Init(TypeInfo(TRawUTF8DynArray), LDynUtf8File);

    if ASubConID = -1 then
    begin
      LSubConList := TObjectList<TSQLSubCon>.Create;
      try
        GetSubConFromTaskIDWithInvoiceItems(ATask.ID, LSubConList);
//        LSubCon.FillRewind;
        for i := 0 to LSubConList.Count - 1 do
        begin
          LSubCon := LSubConList.Items[i];
          GetSubCon2DynArr;
        end;
      finally
        LSubConList.Clear;
        LSubConList.Free;
      end;
    end
    else
    begin
      LSubCon := GetSubConFromTaskIDNSubConIDWithInvoiceItems(ATask.ID, ASubConID);
      try
        if LSubCon.IsUpdate then
          GetSubCon2DynArr;
      finally
        FreeAndNil(LSubCon);
      end;
    end;

    LUtf8 := LDynArr.SaveToJSON;
    LV.SubCon := _JSON(LUtf8);;
    LUtf8 := LDynArrItem.SaveToJSON;
    LV.InvoiveItem := _JSON(LUtf8);;
    LUtf8 := LDynArrFile.SaveToJSON;
    LV.InvoiceFile := _JSON(LUtf8);;

    LMat4Proj := GetMaterial4ProjFromTask(ATask);
    LUtf8 := LMat4Proj.GetJSONValues(true, true, soSelect);
    LV.Mat4Proj := _JSON(LUtf8);

//    LUtf8 := VariantSaveJSON(LV);
    LUtf8 := LV;
//    LRaw := UTF8ToAnsi(LUtf8);
    Result := MakeRawUTF8ToBin64(LUtf8);
//    LRaw := LUtf8;
//    LRaw := SynLZCompress(LRaw);
//    LUtf8 := BinToBase64(LRaw);
//    Result := UTF8ToString(LUtf8);
    AFileName := GetTaskInfoAttachedFileName(LV);
  finally
    FreeAndNil(LCustomer);
    FreeAndNil(LMat4Proj);
  end;
end;

function MakeInvoiceTaskInfo2JSON(ATask: TSQLInvoiceTask; var AFileName: string): string;
var
  LUtf8: RawUTF8;
  LDynUtf8: TRawUTF8DynArray;
  LDynArr: TDynArray;
  LCount, i: integer;
  LInvoiceItem: TSQLInvoiceItem;
  LInvoiceFile: TSQLInvoiceFile;
  LV,LV2,LV3: variant;
  LRaw: RawByteString;
  LResult: Boolean;
begin
  TDocVariant.New(LV);
//  LV.TaskJsonDragSign := TASK_JSON_DRAG_SIGNATURE;
  LV.InvoiceTaskJsonDragSign := INVOICETASK_JSON_DRAG_SIGNATURE;

  LDynArr.Init(TypeInfo(TRawUTF8DynArray), LDynUtf8);
  try
    LUtf8 := ATask.GetJSONValues(true, true, soSelect);
    LV.Task := _JSON(LUtf8);

    LInvoiceItem := GetItemsFromInvoiceTask(ATask);

    while LInvoiceItem.FillOne do
    begin
      LUtf8 := LInvoiceItem.GetJSONValues(true, true, soSelect);
      LDynArr.Add(LUtf8);
    end;

    LUtf8 := LDynArr.SaveToJSON;
    LV.InvoiceItem := _JSON(LUtf8);

    LDynArr.Clear;
    LInvoiceFile := GetFilesFromInvoiceTask(ATask);

    while LInvoiceFile.FillOne do
    begin
//      LUtf8 := LInvoiceFile.GetJSONValues(true, true, soSelect);
//      LDynArr.Add(LUtf8);
      LUtf8 := ObjectToJson(LInvoiceFile);
      LDynArr.Add(LUtf8);
//      LDynArr.SaveTo.Add(LRaw);
    end;

    LUtf8 := LDynArr.SaveToJSON;
    LV.InvoiceFile := _JSON(LUtf8);;
//    LUtf8 := VariantSaveJSON(LV);
    LUtf8 := LV;

//    LDynArr.LoadFromJSON(Pointer(LUtf8));
//    LUtf8 := LDynUtf8[i];
//    LInvoiceFile.DynArray('Files').Clear;
//    JsonToObject(LInvoiceFile, PUtf8Char(LUtf8), LResult);

//    LRaw := UTF8ToAnsi(LUtf8);
    LRaw := LUtf8;
//    ShowMessage(IntToStr(Length(LRaw)));
    LRaw := SynLZCompress(LRaw);
//    ShowMessage(IntToStr(Length(LRaw)));
    LUtf8 := BinToBase64(LRaw);
    Result := UTF8ToString(LUtf8);
    AFileName := GetInvoiceTaskInfoAttachedFileName(LV);
  finally
    FreeAndNil(LInvoiceItem);
    FreeAndNil(LInvoiceFile);
  end;
end;

function MakeTaskList2JSONArray(ATask: TSQLGSTask): RawUTF8;
var
  LDynUtf8: TRawUTF8DynArray;
  LDynArr: TDynArray;
  LUtf8: RawUTF8;
  LSQLEmailMsg: TSQLEmailMsg;
  LIds: TIDDynArray;
  LMailCount: integer;
  LSubject: RawUTF8;
  Lvar: variant;
begin
//  TDocVariant.New(Lvar);
  LDynArr.Init(TypeInfo(TRawUTF8DynArray), LDynUtf8);
  ATask.FillRewind;

  while ATask.FillOne do
  begin
    LUtf8 := ATask.GetJSONValues(true, true, soSelect);

    ATask.EmailMsg.DestGet(g_ProjectDB, ATask.ID, LIds);
    LSQLEmailMsg:= TSQLEmailMsg.CreateAndFillPrepare(g_ProjectDB, TInt64DynArray(LIds));
    try
      LMailCount := 0;
      LSubject := '';

      while LSQLEmailMsg.FillOne do
      begin
        if (LSubject = '') and (LSQLEmailMsg.ParentID = '') then
        begin
          LSubject := LSQLEmailMsg.Subject;
        end;

        Inc(LMailCount);
      end;
    finally
      FreeAndNil(LSQLEmailMsg);
    end;

    Lvar := _JSON(LUtf8);
    Lvar.NumOfEMails := LMailCount;
    Lvar.EmailSubject := LSubject;
    LUtf8 := Lvar;
    LDynArr.Add(LUtf8);
  end;

  Result := LDynArr.SaveToJSON;
end;

function MakeTaskDetail2JSON(ATask: TSQLGSTask): RawUTF8;
var
  LV, LV2: variant;
  LUtf8: RawUTF8;
  LDynUtf8: TRawUTF8DynArray;
  LDynArr: TDynArray;
  LGSFile: TSQLGSFile;
  LCustomer: TSQLCustomer;
  LSubCon: TSQLSubCon;
  LMat4Proj: TSQLMaterial4Project;
  LSubConList: TObjectList<TSQLSubCon>;
  i: integer;
begin
  TDocVariant.New(LV);
  LUtf8 := ATask.GetJSONValues(true, true, soSelect);
  LV.Task := _JSON(LUtf8);
  LGSFile := GetFilesFromTask(ATask);
  LUtf8 := MakeGSFile2JSON(LGSFile);
  LV.GSFile := _JSON(LUtf8);
  LCustomer := GetCustomerFromTask(ATask);
  LUtf8 := LCustomer.GetJSONValues(true, true, soSelect);
  LV.Customer := _JSON(LUtf8);

  LSubConList := TObjectList<TSQLSubCon>.Create;
  try
    LDynArr.Init(TypeInfo(TRawUTF8DynArray), LDynUtf8);
    GetSubConFromTaskIDWithInvoiceItems(ATask.ID, LSubConList);

    for i := 0 to LSubConList.Count - 1 do
    begin
      TDocVariant.New(LV2);
      LSubCon := LSubConList.Items[i];
      LUtf8 := LSubCon.GetJSONValues(true, true, soSelect);
      LV2 := _JSON(LUtf8);
      LV2.InvoiceItems := LSubCon.InvoiceItems;
      LV2.InvoiceFiles := LSubCon.InvoiceFiles;
      LUtf8 := LV2;
      LDynArr.Add(LUtf8);
    end;

    LUtf8 := LDynArr.SaveToJSON;
    LV.SubCon := _JSON(LUtf8);
  finally
    LSubConList.Clear;
    LSubConList.Free;
  end;

  LMat4Proj := GetMaterial4ProjFromTask(ATask);
  LUtf8 := LMat4Proj.GetJSONValues(true, true, soSelect);
  LV.Material := _JSON(LUtf8);
  Result := LV;
end;

function MakeGSFile2JSON(ASQLGSFile: TSQLGSFile): RawUTF8;
var
  LRow: integer;
  LSQLGSFileRec: TSQLGSFileRec;
  LUtf8: RawUTF8;
  LVar: variant;
  LDynUtf8File: TRawUTF8DynArray;
  LDynArrFile: TDynArray;
begin
  LDynArrFile.Init(TypeInfo(TRawUTF8DynArray), LDynUtf8File);

//  if ASQLGSFile.IsUpdate then
//  begin
//    ASQLGSFile.FillRewind;
//    ASQLGSFile.FillOne;
//  end;

//  while ASQLGSFile.FillOne do
//  begin
//    TDocVariant.New(LVar);

    for LRow := Low(ASQLGSFile.Files) to High(ASQLGSFile.Files) do
    begin
      LSQLGSFileRec := ASQLGSFile.Files[LRow];
//      LVar.fFileName := LSQLGSFileRec.fFilename;
//      LVar.fGSDocType := LSQLGSFileRec.fGSDocType;
      LUtf8 := RecordSaveJson(LSQLGSFileRec, TypeInfo(TSQLGSFileRec));
//      LUtf8 := LVar;
      LDynArrFile.Add(LUtf8);
    end;
//  end;

  LVar := _JSON(LDynArrFile.SaveToJSON);
  LUtf8 := LVar;
  Result := '{"TaskID":' + IntToStr(ASQLGSFile.TaskID) + ',"Files":' + LUtf8 + '}';
end;

function MakeTaskEmailList2JSON(ATaskID: TID): RawUTF8;
var
  LSQLGSTask: TSQLGSTask;
  LSQLEmailMsg: TSQLEmailMsg;
  LIds: TIDDynArray;
  LUtf8: RawUTF8;
  LDynUtf8: TRawUTF8DynArray;
  LDynArr: TDynArray;
begin
  LSQLGSTask := GetLoadTask(ATaskID);
  try
    if LSQLGSTask.IsUpdate then
    begin
      LDynArr.Init(TypeInfo(TRawUTF8DynArray), LDynUtf8);
      LSQLGSTask.EmailMsg.DestGet(g_ProjectDB, LSQLGSTask.ID, LIds);
      LSQLEmailMsg:= TSQLEmailMsg.CreateAndFillPrepare(g_ProjectDB, TInt64DynArray(LIds));

      while LSQLEmailMsg.FillOne do
      begin
        LUtf8 := LSQLEmailMsg.GetJSONValues(true, true, soSelect);
        LDynArr.Add(LUtf8);
      end;

      LUtf8 := LDynArr.SaveToJSON;
      Result := LUtf8;
    end;
  finally
    FreeAndNil(LSQLEmailMsg);
    FreeAndNil(LSQLGSTask);
  end;
end;

function MakeInvoiceItemFromVar(ADoc: variant): string;
var
  LInvoiceItemType: TGSInvoiceItemType;
  LItemStr: string;
begin
  LInvoiceItemType := g_GSInvoiceItemType.ToType(UTF8ToString(ADoc.InvoiceItemType));

  case LInvoiceItemType of
    iitWork_Week_N: LItemStr := INVOICE_ITEM_SE_CHARGE_WN;
    iitWork_Week_OT: LItemStr := INVOICE_ITEM_SE_CHARGE_WOT;
    iitWork_Holiday_N: LItemStr := INVOICE_ITEM_SE_CHARGE_HN;
    iitWork_Holiday_OT: LItemStr := INVOICE_ITEM_SE_CHARGE_HOT;
    iitTravellingHours: LItemStr := INVOICE_ITEM_TRAVELLING_CHARGE;
    iitMaterials: LItemStr := INVOICE_ITEM_MATERIAL_CHARGE;
    iitAirFare: LItemStr := INVOICE_ITEM_FLIGHT_FEE;
    iitAccommodation: LItemStr := INVOICE_ITEM_ACCOMMODATION_FEE;
    iitTransportation: LItemStr := INVOICE_ITEM_TRANSPORTATION_FEE;
    iitMeal: LItemStr := INVOICE_ITEM_MEAL_FEE;
  end;

  Result := GetMustacheJSONFromStr(ADoc, LItemStr);
end;

procedure AddInvoiceItemFromVar2ItemList(ASrc: variant; var AItemList: TObjectList<TSQLInvoiceItem>);
var
  LIIT_Src, LIIT_Dest: TGSInvoiceItemType;
  LEKind_Src, LEKind_Dest: TGSEngineerType;
  LItem: TSQLInvoiceItem;
  i, LNumOfWorker, LQty, LUnitPrice, LTotalPrice: integer;
  LIsUpdate: Boolean;
begin
  LIIT_Src := g_GSInvoiceItemType.ToType(UTF8ToString(ASrc.InvoiceItemType));
  LEKind_Src := String2GSEngineerType(ASrc.GSEngineerType);

  for i := 0 to AItemList.Count - 1 do
  begin
    LItem := AItemList.Items[i];
    LIIT_Dest := LItem.InvoiceItemType;
    LEKind_Dest := LItem.GSEngineerType;

    if ((LEKind_Src = gsetNull) or (LEKind_Src = LEKind_Dest)) and (LIIT_Src = LIIT_Dest) and
      (LItem.UnitPrice = ASrc.UnitPrice) then
    begin
      LQty := StrToIntDef(LItem.Qty, 0);
      LUnitPrice := StrToIntDef(LItem.UnitPrice, 0);
      LTotalPrice := StrToIntDef(LItem.TotalPrice, 0);

      if (LIIT_Dest = iitWork_Week_N) or (LIIT_Dest = iitWork_Week_OT) or
         (LIIT_Dest = iitWork_Holiday_N) or (LIIT_Dest = iitWork_Holiday_OT) or
         (LIIT_Dest = iitTravellingHours)then
      begin
        LNumOfWorker := StrToIntDef(LItem.InvoiceItemDesc,1);
        LNumOfWorker := LNumOfWorker + StrToIntDef(ASrc.InvoiceItemDesc,1);
        LItem.InvoiceItemDesc := IntToStr(LNumOfWorker);
      end;

      LQty := LQty + StrToIntDef(ASrc.Qty, 0);
      LTotalPrice := LTotalPrice + (LQty * LUnitPrice);
      LItem.Qty := IntToStr(LQty);
      LItem.TotalPrice := IntToStr(LTotalPrice);
      LIsUpdate := True;
      break;
    end;
  end;

  if not LIsUpdate then
  begin
    LItem := TSQLInvoiceItem.Create;
    LoadInvoiceItemFromVariant(LItem, ASrc);
    AItemList.Add(LItem);
  end;
end;

procedure GetInvoiceItem2Var(ADelimitedStr: string; var ADoc: variant);
begin
  ADoc.UniqueItemID := strToken(ADelimitedStr, ';');
  ADoc.UniqueSubConID := strToken(ADelimitedStr, ';');
  ADoc.ItemID := 0;
  ADoc.TaskID := 0;
  ADoc.InvoiceItemType := strToken(ADelimitedStr, ';');
  ADoc.InvoiceItemDesc := strToken(ADelimitedStr, ';');
//  ADoc.NumOfWorker := strToken(ADelimitedStr, ';');
  ADoc.Qty := strToken(ADelimitedStr, ';');
  ADoc.FUnit := strToken(ADelimitedStr, ';');
  ADoc.UnitPrice := strToken(ADelimitedStr, ';');
  ADoc.ExchangeRate := strToken(ADelimitedStr, ';');
  ADoc.TotalPrice := strToken(ADelimitedStr, ';');
  ADoc.EngineerKind := strToken(ADelimitedStr, ';');
end;

function GetTaskInfoAttachedFileName(AVar: variant): string;
var
  LDocData: TDocVariantData;
  LVar: variant;
  LCompanyName: string;
  i: integer;
begin
  Result := AVar.Task.HullNo + '_' + AVar.Task.ShipName;

  if AVar.Task.Order_No <> '' then
    Result := Result + '(' + AVar.Task.Order_No + ')'
  else
  if AVar.Task.PO_No <> '' then
    Result := Result + '(' + AVar.Task.PO_No + ')';

  //ADoc.SubCon = [] 형식의 배열 임
  LDocData.InitJSON(AVar.SubCon);

  for i := 0 to LDocData.Count - 1 do
  begin
    LVar := _JSON(LDocData.Value[i]);
    LCompanyName := LVar.CompanyName;
    Break;
  end;

  Result := Result + '_' + LCompanyName + '_FromInq';

  Result := StringReplace(Result, '/', '_', [rfReplaceAll]);
  Result := StringReplace(Result, ' ', '_', [rfReplaceAll]) + '.hgs';
end;

function GetInvoiceTaskInfoAttachedFileName(AVar: variant): string;
begin
  Result := AVar.Task.HullNo + '_' + AVar.Task.ShipName;

  if AVar.Task.Order_No <> '' then
    Result := Result + '(' + AVar.Task.Order_No + ')';

  Result := Result + '_' + AVar.Task.SubConCompanyName + '_FromInvoice';

  Result := StringReplace(Result, '/', '_', [rfReplaceAll]);
  Result := StringReplace(Result, ' ', '_', [rfReplaceAll]) + '.hgs';
end;

//AVar : AVar.SubCon : [] 배열 형식임
procedure GetCompanyCodeFromSubConArray(ADoc: variant; var ACompanyCode, ACompanyName: string);
var
  LDocData: TDocVariantData;
  LVar: variant;
  i: integer;
begin
  //ADoc.SubCon = [] 형식의 배열 임
  LDocData.InitJSON(ADoc.SubCon);

  for i := 0 to LDocData.Count - 1 do
  begin
    LVar := _JSON(LDocData.Value[i]);
    ACompanyCode := LVar.CompanyCode;
    ACompanyName := LVar.CompanyName;
    break;
  end;
end;

//InqManage에서 생성한 *.hgs 파일로부터 TSQLInvoiceTask를 추출함
//InvoiveManage에서 생성한 *.hgs 파일로부터 TSQLInvoiceTask를 추출함
//InqManage에서 생성한 *.hgs의 경우 ADoc.SubCon 은 배열 형식으로 저장됨 : [{},{}...]
function LoadInvoiceTaskFromVariant(ATask:TSQLInvoiceTask; ADoc: variant): Boolean;
var
  LSQLCompany: TSQLCompany;
  LDocData: TDocVariantData;
  i: integer;
  LVar: variant;
  LCompanyCode: string;
  LIsFromInvoiceManage: Boolean;
begin
  if ADoc = null then
    exit;

  ATask.HullNo := ADoc.Task.HullNo;
  ATask.ShipName := ADoc.Task.ShipName;
  ATask.Order_No := ADoc.Task.Order_No;
  ATask.PO_No := ADoc.Task.PO_No;
  ATask.WorkSummary := ADoc.Task.WorkSummary;
  ATask.NationPort := ADoc.Task.NationPort;
  ATask.EtcContent := ADoc.Task.EtcContent;
  ATask.ShipOwner := ADoc.Task.ShipOwner;
  ATask.ChargeInPersonId := ADoc.Task.ChargeInPersonId;

  ATask.SEList := ADoc.Task.SEList;

  ATask.InqRecvDate := ADoc.Task.InqRecvDate;
  ATask.InvoiceIssueDate := ADoc.Task.InvoiceIssueDate;
  ATask.AttendScheduled := ADoc.Task.AttendScheduled;
  ATask.WorkBeginDate := ADoc.Task.WorkBeginDate;
  ATask.WorkEndDate := ADoc.Task.WorkEndDate;
  ATask.UniqueTaskID := ADoc.Task.UniqueTaskID;
  ATask.CurrencyKind := String2CurrencyKind(ADoc.Task.CurrencyKind);

  //InvoiceManage.exe에서 만들어진 *.hgs 파일인 경우
  try
    LIsFromInvoiceManage := ADoc.InvoiceTaskJsonDragSign = INVOICETASK_JSON_DRAG_SIGNATURE;
  except
  end;

  if LIsFromInvoiceManage then
  begin
    if ADoc.Task.CustCompanyCode <> '' then
      ATask.CustCompanyCode := ADoc.Task.CustCompanyCode;

    ATask.CustEMail := ADoc.Task.CustEMail;
    ATask.CustCompanyName := ADoc.Task.CustCompanyName;
    ATask.CustMobilePhone := ADoc.Task.CustMobilePhone;
    ATask.CustOfficePhone := ADoc.Task.CustOfficePhone;
    ATask.CustCompanyAddress := ADoc.Task.CustCompanyAddress;
    ATask.CustPosition := ADoc.Task.CustPosition;
    ATask.CustManagerName := ADoc.Task.CustManagerName;
    ATask.CustNation := ADoc.Task.CustNation;
    ATask.CustAgentInfo := ADoc.Task.CustAgentInfo;

    LSQLCompany := GetCompanyFromCode4InvoiceTask(ADoc.Task.SubConCompanyCode);
    if LSQLCompany.IsUpdate  then
    begin
      ATask.SubConCompanyCode := ADoc.Task.SubConCompanyCode;
      ATask.SubConEMail := ADoc.Task.SubConEMail;
      ATask.SubConCompanyName := ADoc.Task.SubConCompanyName;
      ATask.SubConMobilePhone := ADoc.Task.SubConMobilePhone;
      ATask.SubConOfficePhone := ADoc.Task.SubConOfficePhone;
      ATask.SubConCompanyAddress := ADoc.Task.SubConCompanyAddress;
      ATask.SubConPosition := ADoc.Task.SubConPosition;
      ATask.SubConManagerName := ADoc.Task.SubConManagerName;
      ATask.SubConNation := ADoc.Task.SubConNation;
      ATask.SubConInvoiceNo := ADoc.Task.SubConInvoiceNo;
      ATask.UniqueSubConID := ADoc.Task.UniqueSubConID;
    end;
  end
  else
  begin
    if ADoc.Customer.CompanyCode <> '' then
      ATask.CustCompanyCode := ADoc.Customer.CompanyCode;

    ATask.CustEMail := ADoc.Customer.EMail;
    ATask.CustCompanyName := ADoc.Customer.CompanyName;
    ATask.CustMobilePhone := ADoc.Customer.MobilePhone;
    ATask.CustOfficePhone := ADoc.Customer.OfficePhone;
    ATask.CustCompanyAddress := ADoc.Customer.CompanyAddress;
    ATask.CustPosition := ADoc.Customer.Position;
    ATask.CustManagerName := ADoc.Customer.ManagerName;
    ATask.CustNation := ADoc.Customer.Nation;
    ATask.CustAgentInfo := ADoc.Customer.AgentInfo;

    //ADoc.SubCon = [] 형식의 배열 임
    LDocData.InitJSON(ADoc.SubCon);

    for i := 0 to LDocData.Count - 1 do
    begin
      LVar := _JSON(LDocData.Value[i]);
      //복수개의 SubCon일 경우 한개만 추출해야 함
      LSQLCompany := GetCompanyFromCode4InvoiceTask(LVar.CompanyCode);
      if LSQLCompany.IsUpdate then
      begin
        ATask.SubConCompanyCode := LVar.CompanyCode;
        ATask.SubConEMail := LVar.EMail;
        ATask.SubConCompanyName := LVar.CompanyName;
        ATask.SubConMobilePhone := LVar.MobilePhone;
        ATask.SubConOfficePhone := LVar.OfficePhone;
        ATask.SubConCompanyAddress := LVar.CompanyAddress;
        ATask.SubConPosition := LVar.Position;
        ATask.SubConManagerName := LVar.ManagerName;
        ATask.SubConNation := LVar.Nation;
        ATask.SubConInvoiceNo := LVar.ServicePO;
        ATask.UniqueSubConID := LVar.UniqueSubConID;

        Break;
      end;
    end;
  end;

  Result := LIsFromInvoiceManage;
end;

procedure LoadInvoiceItemListFromVariant(ADoc: variant; AItemList: TObjectList<TSQLInvoiceItem>);
var
  LDynUtf8: TRawUTF8DynArray;
  LDynArr: TDynArray;
  LUtf8: RawUTF8;
  i: integer;
  LDoc: variant;
  LItem: TSQLInvoiceItem;
  LTaskID, LItemID: TID;
  LUniqueItemID: RawUTF8;
begin
  if ADoc = null then
    exit;

  LUtf8 := ADoc;
  LDynArr.Init(TypeInfo(TRawUTF8DynArray), LDynUtf8);
  LDynArr.LoadFromJSON(PUTF8Char(LUtf8));

  for i := 0 to LDynArr.Count - 1 do
  begin
//    LItem := TSQLInvoiceItem.Create;
    LDoc := _JSON(LDynUtf8[i]);
    LTaskID := LDoc.TaskID;
    LItemID := LDoc.ItemID;
    LUniqueItemID := LDoc.UniqueItemID;

//    LItem := GetInvoiceItemFromID(LTaskID, LItemID);
    LItem := GetInvoiceItemFromUniqueID(LUniqueItemID);
    LItem.IsUpdate := LItem.FillOne;

    AItemList.Add(LItem);

    LoadInvoiceItemFromVariant(LItem, LDoc);
  end;
end;

procedure LoadSubconInvoiceItemListFromVariant(ADoc: variant; AItemList: TObjectList<TSQLSubconInvoiceItem>);
var
  LDynUtf8: TRawUTF8DynArray;
  LDynArr: TDynArray;
  LUtf8: RawUTF8;
  i: integer;
  LDoc: variant;
  LItem: TSQLSubconInvoiceItem;
//  LTaskID, LItemID: TID;
  LUniqueItemID: RawUTF8;
begin
  if ADoc = null then
    exit;

  AItemList.Clear;
  LUtf8 := ADoc;
  LDynArr.Init(TypeInfo(TRawUTF8DynArray), LDynUtf8);
  LDynArr.LoadFromJSON(PUTF8Char(LUtf8));

  for i := 0 to LDynArr.Count - 1 do
  begin
    LDoc := _JSON(LDynUtf8[i]);
//    LTaskID := LDoc.TaskID;
//    LItemID := LDoc.ItemID;
    LUniqueItemID := LDoc.UniqueItemID;

    LItem := GetSubConInvoiceItemFromUniqueItemID(LUniqueItemID);
    LItem.IsUpdate := LItem.FillOne;

    AItemList.Add(LItem);

    LoadSubConInvoiceItemFromVariant(LItem, LDoc);
  end;
end;

//InqManager에서 생성된 *.hgs에는 TSQLSubCon이 복수개 일수 있으므로 [] 배열로 저장됨
//TaskEditForm의 SubConGrid에서 Drag하여 *.hgs를 생성할 경우 배열이 아니므로 이 함수 사용 못함
//InqManager의 grid_Req에서 Drag하여 *.hgs를 생성할 경우 배열 형태임
procedure LoadSubconListFromVariant(ADoc: variant; ASubConList: TObjectList<TSQLSubCon>);
var
  LDynUtf8: TRawUTF8DynArray;
  LDynArr: TDynArray;
  LUtf8: RawUTF8;
  i: integer;
  LDoc: variant;
  LSubcon: TSQLSubcon;
  LTaskID, LItemID: TID;
  LUniqueSubConID: RawUTF8;
begin
  if ADoc = null then
    exit;

  ASubConList.Clear;
  LUtf8 := ADoc;
  LDynArr.Init(TypeInfo(TRawUTF8DynArray), LDynUtf8);
  LDynArr.LoadFromJSON(PUTF8Char(LUtf8));

  for i := 0 to LDynArr.Count - 1 do
  begin
    LDoc := _JSON(LDynUtf8[i]);

    LSubcon := TSQLSubcon.Create;
    LoadSubConFromVariant2(LSubcon, LDoc);
    ASubConList.Add(LSubcon);
  end;
end;

procedure LoadInvoiceItemFromVariant(AItem:TSQLInvoiceItem; ADoc: variant);
begin
  AItem.UniqueItemID := ADoc.UniqueItemID;
  AItem.UniqueSubConID := ADoc.UniqueSubConID;

  if Pos('{', AItem.UniqueItemID) = 0 then //'{'가 없으면 추가함
    AItem.UniqueItemID := '{' + AItem.UniqueItemID + '}';

  AItem.ItemID := ADoc.ItemID;
  AItem.TaskID := ADoc.TaskID;
  AItem.InvoiceItemDesc := ADoc.InvoiceItemDesc;
  AItem.Qty := ADoc.Qty;
  AItem.fUnit := ADoc.fUnit;
  AItem.UnitPrice := ADoc.UnitPrice;
  AItem.ExchangeRate := ADoc.ExchangeRate;
  AItem.TotalPrice := ADoc.TotalPrice;
  AItem.InvoiceItemType := TGSInvoiceItemType(StrToIntDef(ADoc.InvoiceItemType,0));
  AItem.GSEngineerType := String2GSEngineerType(ADoc.GSEngineerType);
end;

//InvoiceManage에서 생성한 *.hgs의 경우 InvoiveItem이 배열로 저장됨
//ADoc = {Task:.., "InvoiveItem":[{},{}]...}
procedure LoadInvoiceItemFromVarArray(AItem:TSQLInvoiceItem; ADoc: variant);
var
  LDynUtf8: TRawUTF8DynArray;
  LDynArr: TDynArray;
  LUtf8: RawUTF8;
  i: integer;
  LDoc: variant;
  LItem: TSQLInvoiceItem;
begin
  if ADoc = null then
    exit;

  LUtf8 := ADoc.Task.InvoiceItem;
  LDynArr.Init(TypeInfo(TRawUTF8DynArray), LDynUtf8);
  LDynArr.LoadFromJSON(PUTF8Char(LUtf8));

  for i := 0 to LDynArr.Count - 1 do
  begin
    LDoc := _JSON(LDynUtf8[i]);

  end;

  AItem.UniqueItemID := ADoc.UniqueItemID;

  if Pos('{', AItem.UniqueItemID) = 0 then
    Aitem.UniqueItemID := '{' + Aitem.UniqueItemID + '}';  //'{'가 없으면 추가함

  AItem.ItemID := ADoc.ItemID;
  AItem.TaskID := ADoc.TaskID;
  AItem.InvoiceItemDesc := ADoc.InvoiceItemDesc;
  AItem.Qty := ADoc.Qty;
  AItem.fUnit := ADoc.fUnit;
  AItem.UnitPrice := ADoc.UnitPrice;
  AItem.ExchangeRate := ADoc.ExchangeRate;
  AItem.TotalPrice := ADoc.TotalPrice;
  AItem.InvoiceItemType :=  g_GSInvoiceItemType.ToType(UTF8ToString(ADoc.InvoiceItemType));
  AItem.GSEngineerType := String2GSEngineerType(ADoc.GSEngineerType);
end;

procedure LoadSubConInvoiceItemFromVariant(AItem:TSQLSubConInvoiceItem; ADoc: variant);
begin
  AItem.UniqueSubConID := ADoc.UniqueSubConID;

//  if Pos('{', AItem.UniqueSubConID) = 0 then
//    Aitem.UniqueSubConID := '{' + Aitem.UniqueSubConID + '}'; //'{'가 없으면 추가함

  AItem.UniqueItemID := ADoc.UniqueItemID;

  if Pos('{', AItem.UniqueItemID) = 0 then
    Aitem.UniqueItemID := '{' + Aitem.UniqueItemID + '}'; //'{'가 없으면 추가함

  AItem.ItemID := StrToIntDef(ADoc.ItemID,0);
  AItem.TaskID := StrToIntDef(ADoc.TaskID,0);
  AItem.InvoiceItemDesc := ADoc.InvoiceItemDesc;
  AItem.Qty := ADoc.Qty;
  AItem.fUnit := ADoc.fUnit;
  AItem.UnitPrice := ADoc.UnitPrice;
  AItem.ExchangeRate := ADoc.ExchangeRate;
  AItem.TotalPrice := ADoc.TotalPrice;
  AItem.InvoiceItemType := TGSInvoiceItemType(ADoc.InvoiceItemType);
  AItem.GSEngineerType := String2GSEngineerType(ADoc.GSEngineerType);
end;

procedure LoadInvoiceItem2Var(AItem:TSQLInvoiceItem; var ADoc: variant);
begin
  ADoc.UniqueItemID := AItem.UniqueItemID;
  ADoc.ItemID := AItem.ItemID;
  ADoc.TaskID := AItem.TaskID;
  ADoc.InvoiceItemDesc := AItem.InvoiceItemDesc;
  ADoc.Qty := AItem.Qty;
  ADoc.fUnit := AItem.fUnit;
  ADoc.UnitPrice := AItem.UnitPrice;
  ADoc.ExchangeRate := AItem.ExchangeRate;
  ADoc.TotalPrice := AItem.TotalPrice;
  ADoc.InvoiceItemType := g_GSInvoiceItemType.ToString(AItem.InvoiceItemType);
  ADoc.GSEngineerType := GSEngineerType2String(AItem.GSEngineerType);
end;

procedure LoadSubConInvoiceItems2Variant(ASQLSubConInvoiceItem: TSQLSubConInvoiceItem; var ADoc: Variant);
var
  LDynUtf8: TRawUTF8DynArray;
  LDynArr: TDynArray;
  LUtf8: RawUTF8;
begin
  LDynArr.Init(TypeInfo(TRawUTF8DynArray), LDynUtf8);
  ASQLSubConInvoiceItem.FillRewind;

  while ASQLSubConInvoiceItem.FillOne do
  begin
    LUtf8 := ASQLSubConInvoiceItem.GetJSONValues(true, true, soSelect);
//    LUtf8 := ObjectToJson(ASQLSubConInvoiceFile);
    LDynArr.Add(LUtf8);
  end;

  LUtf8 := LDynArr.SaveToJSON;
//  ADoc.InvoiceItem := _JSON(LUtf8);
  ADoc := _JSON(LUtf8);
end;

procedure LoadSubConInvoiceFiles2Variant(ASQLSubConInvoiceFile: TSQLSubConInvoiceFile; var ADoc: Variant);
var
  LDynUtf8: TRawUTF8DynArray;
  LDynArr: TDynArray;
  LUtf8: RawUTF8;
begin
  LDynArr.Init(TypeInfo(TRawUTF8DynArray), LDynUtf8);
  ASQLSubConInvoiceFile.FillRewind;

  while ASQLSubConInvoiceFile.FillOne do
  begin
//    LUtf8 := ASQLSubConInvoiceFile.GetJSONValues(true, true, soSelect);
    LUtf8 := ObjectToJson(ASQLSubConInvoiceFile);
    LDynArr.Add(LUtf8);
  end;

  LUtf8 := LDynArr.SaveToJSON;
//  ADoc.InvoiceFile := _JSON(LUtf8);
  ADoc := _JSON(LUtf8);
end;

procedure GetInvoiceItemFromObjList2Var(AItemList: TObjectList<TSQLInvoiceItem>; var ADoc: variant);
begin

end;

procedure LoadInvoiceFileListFromVariantWithSQLInvoiceFile(ADoc: variant; AFileList: TObjectList<TSQLInvoiceFile>);
var
  LDynUtf8: TRawUTF8DynArray;
  LDynArr: TDynArray;
  LUtf8: RawUTF8;
  i: integer;
  LDoc: variant;
  LFile: TSQLInvoiceFile;
  LTaskID, LItemID: TID;
begin
  if ADoc = null then
    exit;

  LUtf8 := ADoc;
  LDynArr.Init(TypeInfo(TRawUTF8DynArray), LDynUtf8);
  LDynArr.LoadFromJSON(PUTF8Char(LUtf8));

  for i := 0 to LDynArr.Count - 1 do
  begin
//    LFile := TSQLInvoiceFile.Create;
    LDoc := _JSON(LDynUtf8[i]);
    LUtf8 := LDynUtf8[i];
    LTaskID := LDoc.TaskID;
    LItemID := LDoc.ItemID;
    LFile := GetInvoiceFileFromID(LTaskID, LItemID);
    LFile.FillOne;
    AFileList.Add(LFile);

    LoadInvoiceFileFromJSON(LFile, LUtf8);
//    LoadInvoiceFileFromVariant(LFile, LDoc);
  end;
end;

procedure LoadSubConInvoiceFileListFromVariantWithSQLSubConInvoiceFile(ADoc: variant; AFileList: TObjectList<TSQLSubConInvoiceFile>);
var
  LDynUtf8: TRawUTF8DynArray;
  LDynArr: TDynArray;
  LUtf8: RawUTF8;
  i: integer;
  LDoc: variant;
  LFile: TSQLSubConInvoiceFile;
  LItemID: TID;
  LUniqueInvoicFileID: string;
begin
  if ADoc = null then
    exit;

  AFileList.Clear;
  LUtf8 := ADoc;
  LDynArr.Init(TypeInfo(TRawUTF8DynArray), LDynUtf8);
  LDynArr.LoadFromJSON(PUTF8Char(LUtf8));

  for i := 0 to LDynArr.Count - 1 do
  begin
    LDoc := _JSON(LDynUtf8[i]);
    LUtf8 := LDynUtf8[i];
    LUniqueInvoicFileID := LDoc.UniqueInvoiceFileID;
//    LItemID := LDoc.ItemID;
    LFile := GetSubConInvoiceFileFromUniqueInvoiceFileID(LUniqueInvoicFileID);
    LFile.FillOne;
    AFileList.Add(LFile);

    LoadSubConInvoiceFileFromJSON(LFile, LUtf8);
  end;
end;

//ADoc = {"TaskID":4,"ItemID":18,"Files":[{"fFileName":"aaa.pdf", "fGSInvoiveItemType":1, "fData":...}]} Array형식임
procedure LoadSubConInvoiceFileListFromVariant(ADoc: variant; AFileList: TObjectList<TSQLSubConInvoiceFile>);
var
//  LDynUtf8: TRawUTF8DynArray;
//  LDynArr: TDynArray;
//  LUtf8: RawUTF8;
  i: integer;
//  LDoc: variant;
  LSQLSubConInvoiceFile: TSQLSubConInvoiceFile;
begin
  if ADoc = null then
    exit;

  AFileList.Clear;
//  LUtf8 := ADoc.Files;
//  LDynArr.Init(TypeInfo(TRawUTF8DynArray), LDynUtf8);
//  LDynArr.LoadFromJSON(PUTF8Char(LUtf8));

//  for i := 0 to LDynArr.Count - 1 do
//  begin
//    LDoc := _JSON(LDynUtf8[i]);
//    LUtf8 := LDynUtf8[i];

    LSQLSubConInvoiceFile := TSQLSubConInvoiceFile.Create;
    LoadSubConInvoiceFileFromVariant(LSQLSubConInvoiceFile, ADoc);
    AFileList.Add(LSQLSubConInvoiceFile);
//  end;
end;

procedure LoadInvoiceFileFromVariant(AFile:TSQLInvoiceFile; ADoc: variant);
var
  LUtf8 : RawUTF8;
  LRaw, LRaw2: RawByteString;
  LFile: TSQLInvoiceFile;
  LDynArr: TDynArray;
  LResult: Boolean;
begin
  if ADoc = null then
    exit;

//  AFile.TaskID := ADoc.TaskID;
//  AFile.ItemID := ADoc.ItemID;
//  AFile.ItemIndex := ADoc.ItemIndex;

  LUtf8 := ADoc;
//  LFile := TSQLInvoiceFile.Create;
  AFile.DynArray('Files').Clear;
  LUtf8 := JsonToObject(AFile, PUtf8Char(LUtf8), LResult);
//  LFile.Free;

//  AFile.DynArray('Files').Clear;
//  LUtf8 := ADoc.Files;
//  LDynArr.Init(TypeInfo(TSQLInvoiceFileRecs), LFiles);
//  DynArrayLoadJson(LFiles, Pointer(LUtf8), TypeInfo(TSQLInvoiceFileRecs));

//  AFile.DynArray('Files').Copy(LDynArr);
//  .AddArray(LFiles);
//  AFile.DynArray('Files').LoadFromJSON(PUTF8Char(LUTF8));
//  AFile.Files := ADoc.Files;
end;

//ADoc = {"TaskID":4,"ItemID":18,"Files":[{"fFileName":"aaa.pdf", "fGSInvoiveItemType":1, "fData":...}]} Array형식임
procedure LoadSubConInvoiceFileFromVariant(AFile:TSQLSubConInvoiceFile; ADoc: variant);
var
  LUtf8 : RawUTF8;
  LResult: Boolean;
begin
  if ADoc = null then
    exit;

  LUtf8 := ADoc;
  LoadSubConInvoiceFileFromJSON(AFile,LUtf8);
end;

procedure LoadInvoiceFileFromJSON(AFile:TSQLInvoiceFile; AJson: RawUTF8);
var
  LUtf8 : RawUTF8;
  LResult: Boolean;
  LSQLInvoiceFileRec: TSQLInvoiceFileRec;
begin
  AFile.DynArray('Files').Clear;
  LUtf8 := JsonToObject(AFile, PUtf8Char(AJson), LResult);
end;

procedure LoadSubConInvoiceFileFromJSON(AFile:TSQLSubConInvoiceFile; AJson: RawUTF8);
var
  LUtf8 : RawUTF8;
  LResult: Boolean;
begin
  AFile.DynArray('Files').Clear;
  LUtf8 := JsonToObject(AFile, PUtf8Char(AJson), LResult);
end;

function LoadRecordList2VariantFromSQlRecord(ASQLRecord: TSQLRecord): variant;
var
  LUtf8: RawUTF8;
  LDynUtf8: TRawUTF8DynArray;
  LDynArr: TDynArray;
begin
  LDynArr.Init(TypeInfo(TRawUTF8DynArray), LDynUtf8);
  ASQLRecord.FillRewind;

  while ASQLRecord.FillOne do
  begin
    LUtf8 := ASQLRecord.GetJSONValues(true, true, soSelect);
    LDynArr.Add(LUtf8);
  end;

  Result := LDynArr.SaveToJSON;
end;

end.
