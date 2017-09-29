unit UnitMakeReport;

interface

uses Sysutils, Dialogs, Classes, UnitExcelUtil, Syncommons;

const
//  DOC_DIR = 'C:\Users\HGS\Documents\양식\';
//  DOC_DIR = '.\양식\';
  QTN_FILE_2_CUST_KOR = 'QUOTATION-KOR.xls';
  QTN_FILE_2_CUST_ENG = 'QUOTATION-ENG.xls';
  PO_FILE_2_SUBCON_KOR = '';
  PO_FILE_2_SUBCON_ENG = 'Service-Order.xlsx';
  INVOICE_FILE_2_CUST_KOR = 'INVOICE-KOR.xlsx';
  INVOICE_FILE_2_CUST_ENG = 'INVOICE-ENG.xlsx';
  COMMERCIAL_INVOICE_FILE = 'COMMERCIAL-INVOICE-PACKING-LIST.xlsx';
  COMPANY_SELECTION_FILE = '업체선정품의서.xls';
  CONFIRM_COMPLETION_FILE = '공사완료확인서.xls';
  BUDGET_APPROVAL_FILE = '';
  CONTRACT_FILE = '';
  CUSTOMER_REG_ENG = 'Customer_Registration.xlsx';
  SUBCON_INVOICE_LIST_FILE = '외주용역비_인보이스_처리현황.xlsx';

  SALES_MUSTACHE_FILE_NAME = 'Mustache_매출요청메일.htm';
  INVOICE_SEND_MUSTACHE_FILE_NAME = 'Mustache_Invoice송부메일.htm';
  DIRECT_SHIPPING_MUSTACHE_FILE_NAME = 'Mustache_직투입요청메일.htm';
  FOREIGN_REG_MUSTACHE_FILE_NAME = 'Mustache_해외매출_고객사_거래처등록요청메일.htm';
  ELEC_HULLNO_REG_REQ_MUSTACHE_FILE_NAME = 'Mustache_전전_비표준공사_생성_요청메일.htm';
  PO_REQ_MUSTACHE_FILE_NAME = 'Mustache_PO요청메일.htm';
  SHIPPING_MUSTACHE_FILE_NAME = 'Mustache_SHIPPING요청메일.htm';
  FORWARD_FIELDSERVICE_MUSTACHE_FILE_NAME = 'Mustache_FIELDSERVICE전달메일.htm';

  INVOICE_ITEM_SE_CHARGE = 'Service Engineering Charge' + #13#10 + '({{NumOfWorker}} S/E, {{Qty}} WorkDay(s), USD1,190/day)';
  INVOICE_ITEM_TRAVELLING_CHARGE = 'Travelling Charge' + #13#10 + '({{NumOfWorker}} S/E, {{TravellingDays}} Day(s), USD120/hr)';
  INVOICE_ITEM_FLIGHT_FEE = 'Flight Fee' + #13#10 + '(Actual Cost + Admin fee:15%)';
  INVOICE_ITEM_ACCOMMODATION_FEE = 'Accommodation Fee' + #13#10 + '(Actual Cost + Admin fee:15%)';
  INVOICE_ITEM_MATERIAL_CHARGE = 'Material' + #13#10 + '({{Material}})';
  INVOICE_ITEM_TRANSPORTATION_FEE = 'Transportation' + #13#10 + '({{Transportation}})';
  INVOICE_ITEM_MEAL_FEE = 'Meal' + #13#10 + '({{Meal}})';

  COMPANY_SELECTION_CONTENT = '   표제 호선의 작업을 위해 다음과 같이 업체 견적을 접수/검토 후 ';
type
  Doc_Qtn_Rec = record
    FCustomerInfo, FQtnNo, FQtnDate, FHullNo, FShipName,
    FSubject, FProduceType, FPONo, FValidateDate: string;
  end;

  Doc_Invoice_Rec = record
    FCustomerInfo, FInvNo, FInvDate, FHullNo, FShipName,
    FSubject, FProduceType, FPONo: string;
    FInvoiceItemList: TStringList;
  end;

  Doc_Invoice_Item_Rec = record
    FItemType, FNumOfWorker, FQty, FFUnit, FUnitPrice, FTotalPrice: string;
  end;

  Doc_ServiceOrder_Rec = record
    FSubConName, FSubConManager, FSubConPhonNo, FSubConEmail, FHullNo, FShipName,
    FShipOwner, FSubject, FProduceType, FPONo2SubCon, FOrderDate, FWorkSch, FEngineerNo,
    FTechnicanNo, FLocalAgent, FWorkDesc, FProjCode, FCustomer, FWorkPeriod,
    FNationPort, FWorkSummary, FSubConPrice: string;
  end;

  Doc_Cust_Reg_Rec = record
    FCompanyName, FCountry, FTaxID, FCity, FCompanyAddress,
    FTelNo, FFaxNo, FEMailAddress: string;
  end;

  Doc_SubCon_Invoice_List_Rec = record
    FProjectCode, FHullNo, FClaimNo, FPONo, FPOIssueDate,
    FSubConName, FWorkFinishDate, FInvoiceIssueDate: string;
  end;

  Doc_SubCon_Invoice_List_Recs = array of Doc_SubCon_Invoice_List_Rec;

  //ALang: 1 = Eng, 2 = Kor
  procedure MakeDocQtn(AQtnR: Doc_Qtn_Rec; ALang: integer = 1);
  procedure MakeDocPO(ALang: integer=1);
  procedure MakeDocInvoice(AInvR: Doc_Invoice_Rec; ALang: integer=1);
  procedure GetInvoiceItemRec(ADelimitedStr: string;
    var AItem: Doc_Invoice_Item_Rec);
  procedure MakeDocServiceOrder(ASOR: Doc_ServiceOrder_Rec);
  procedure MakeDocCompanySelection(ASOR: Doc_ServiceOrder_Rec);
  procedure MakeDocConfirmComplete(ASOR: Doc_ServiceOrder_Rec);
  procedure MakeDocBudgetApproval;
  procedure MakeDocContract;

  //승선허가서
  procedure MakeDocBoardingPermit;
  procedure MakeDocCustomerRegistration(ACRR: Doc_Cust_Reg_Rec; ALang: integer=1);
  function MakeDocSubConInvoiceList: OleVariant;
  procedure MakeDocSubConInvoiceList2(AWorkSheet: OleVariant;
    ASIL: Doc_SubCon_Invoice_List_Rec; ARow: integer);

var
  DOC_DIR: string;

implementation

uses UnitStringUtil, UnitVariantJsonUtil;

procedure MakeDocQtn(AQtnR: Doc_Qtn_Rec; ALang: integer = 1);
var
  LExcel: OleVariant;
  LWorkBook: OleVariant;
  LRange: OleVariant;
  LWorksheet: OleVariant;
  LFileName: string;
begin
  if ALang = 1 then
    LFileName := QTN_FILE_2_CUST_ENG
  else
    LFileName := QTN_FILE_2_CUST_KOR;

//  LFileName := '"' + DOC_DIR + LFileName + '"';
  LFileName := DOC_DIR + LFileName;

//  ShowMessage(GetCurrentDir);

  if not FileExists(LFileName) then
  begin
    ShowMessage('File(' + LFileName + ')이 존재하지 않습니다');
    exit;
  end;

  LExcel := GetActiveExcelOleObject(True);
  LWorkBook := LExcel.Workbooks.Open(LFileName);
  LExcel.Visible := true;
//  LExcel.ActiveWindow.Zoom := 100;
//  LWorkbook.Sheets['Sheet1'].Activate;
  LWorksheet := LExcel.ActiveSheet;

  LRange := LWorksheet.range['D10'];
  LRange.FormulaR1C1 := AQtnR.FCustomerInfo;
  LRange := LWorksheet.range['AL7'];
  LRange.FormulaR1C1 := AQtnR.FQtnNo;
  LRange := LWorksheet.range['AF9'];
  LRange.FormulaR1C1 := AQtnR.FQtnDate;
  LRange := LWorksheet.range['L19'];
  LRange.FormulaR1C1 := AQtnR.FHullNo;
  LRange := LWorksheet.range['AK19'];
  LRange.FormulaR1C1 := AQtnR.FShipName;
  LRange := LWorksheet.range['L21'];
  LRange.FormulaR1C1 := AQtnR.FSubject;
  LRange := LWorksheet.range['AK21'];
  LRange.FormulaR1C1 := AQtnR.FProduceType;
  LRange := LWorksheet.range['L22'];
  LRange.FormulaR1C1 := AQtnR.FPONo;
  LRange := LWorksheet.range['N32'];
  LRange.FormulaR1C1 := AQtnR.FValidateDate;
end;

procedure MakeDocPO(ALang: integer);
begin

end;

procedure MakeDocInvoice(AInvR: Doc_Invoice_Rec; ALang: integer);
var
  LExcel: OleVariant;
  LWorkBook: OleVariant;
  LRange: OleVariant;
  LWorksheet: OleVariant;
  LFileName, LStr, LRangeStr: string;
  LStrList: TStringList;
  i,j, LRow: integer;
  LDoc : variant;
//  LItem: Doc_Invoice_Item_Rec;
begin
  if ALang = 1 then
    LFileName := INVOICE_FILE_2_CUST_ENG
  else
    LFileName := INVOICE_FILE_2_CUST_KOR;

  LFileName := DOC_DIR + LFileName;

  if not FileExists(LFileName) then
  begin
    ShowMessage('File(' + LFileName + ')이 존재하지 않습니다');
    exit;
  end;

  LExcel := GetActiveExcelOleObject(True);
  LWorkBook := LExcel.Workbooks.Open(LFileName);
  LExcel.Visible := true;
  LWorksheet := LExcel.ActiveSheet;

  LRange := LWorksheet.range['A8'];
  LRange.FormulaR1C1 := AInvR.FCustomerInfo;
  LRange := LWorksheet.range['I5'];
  LRange.FormulaR1C1 := 'Invoice : ' + AInvR.FInvNo;
//  LRange := LWorksheet.range['AF9'];
//  LRange.FormulaR1C1 := AInvR.FInvDate;
  LRange := LWorksheet.range['D21'];
  LRange.FormulaR1C1 := AInvR.FHullNo;
  LRange := LWorksheet.range['K21'];
  LRange.FormulaR1C1 := AInvR.FShipName;
  LRange := LWorksheet.range['D22'];
  LRange.FormulaR1C1 := AInvR.FSubject;
  LRange := LWorksheet.range['K22'];
  LRange.FormulaR1C1 := AInvR.FProduceType;
  LRange := LWorksheet.range['D23'];
  LRange.FormulaR1C1 := AInvR.FPONo;

  if Assigned(AInvR.FInvoiceItemList) then
  begin
    LStrList := TStringList.Create;
    LStrList.StrictDelimiter := True;
    LStrList.Delimiter := ';';
    try
      LRow := 27;
      TDocVariant.New(LDoc);

      for i := 0 to AInvR.FInvoiceItemList.Count - 1 do
      begin
//        LStrList.Text := AInvR.FInvoiceItemList.Strings[i];
//        for j := 0 to LStrList.Count - 1 do
//        begin
        LStr := AInvR.FInvoiceItemList.Strings[i];
        GetInvoiceItem2Var(LStr, LDoc);
        LStr := MakeInvoiceItemFromVar(LDoc);

        if LRow > 27 then
        begin
          LRangeStr := 'A' + IntToStr(LRow-1) + ':M' + IntToStr(LRow-1);
          LRange := LWorksheet.range[LRangeStr];//['A27:M27']
          LRange.Copy;
          LRangeStr := 'A' + IntToStr(LRow) + ':M' + IntToStr(LRow);
          LRange := LWorksheet.range[LRangeStr];//'A28:M28'];
          LRange.Insert;
          LRange := LWorkSheet.Rows[LRow];
          LRange.RowHeight := 25;
        end;

        //No.
        LRangeStr := 'A' + IntToStr(LRow);
        LRange := LWorksheet.range[LRangeStr];
        LRange.FormulaR1C1 := IntToStr(LRow-27+1);
        //Description.
        LRangeStr := 'B' + IntToStr(LRow);
        LRange := LWorksheet.range[LRangeStr];
        LRange.FormulaR1C1 := LStr;
        //Qty.
        LRangeStr := 'H' + IntToStr(LRow);
        LRange := LWorksheet.range[LRangeStr];
        LStr := LDoc.Qty;
        LRange.FormulaR1C1 := LStr;
        //Unit.
        LRangeStr := 'I' + IntToStr(LRow);
        LRange := LWorksheet.range[LRangeStr];
//        LStr := LDoc.FUnit;
        LRange.FormulaR1C1 := 'SET';
        //Unit Price.
        LRangeStr := 'K' + IntToStr(LRow);
        LRange := LWorksheet.range[LRangeStr];
        LStr := LDoc.UnitPrice;
        LRange.FormulaR1C1 := LStr;
        //Unit Price.
        LRangeStr := 'L' + IntToStr(LRow);
        LRange := LWorksheet.range[LRangeStr];
        LStr := LDoc.TotalPrice;
        LRange.FormulaR1C1 := LStr;

        inc(LRow);
//        end;
      end;
    finally
      LStrList.Free;
    end;
  end;
end;

procedure GetInvoiceItemRec(ADelimitedStr: string;
  var AItem: Doc_Invoice_Item_Rec);
begin
  AItem.FItemType := strToken(ADelimitedStr, ';');
  AItem.FNumOfWorker := strToken(ADelimitedStr, ';');
  AItem.FQty := strToken(ADelimitedStr, ';');
  AItem.FFUnit := strToken(ADelimitedStr, ';');
  AItem.FUnitPrice := strToken(ADelimitedStr, ';');
  AItem.FTotalPrice := strToken(ADelimitedStr, ';');
end;

procedure MakeDocServiceOrder(ASOR: Doc_ServiceOrder_Rec);
var
  LExcel: OleVariant;
  LWorkBook: OleVariant;
  LRange: OleVariant;
  LWorksheet: OleVariant;
  LFileName: string;
begin
  LFileName := DOC_DIR + PO_FILE_2_SUBCON_ENG;

  if not FileExists(LFileName) then
  begin
    ShowMessage('File(' + LFileName + ')이 존재하지 않습니다');
    exit;
  end;

  LExcel := GetActiveExcelOleObject(True);
  LWorkBook := LExcel.Workbooks.Open(LFileName);
  LExcel.Visible := true;
  LWorksheet := LExcel.ActiveSheet;

  LRange := LWorksheet.range['E4'];
  LRange.FormulaR1C1 := ASOR.FSubConName;
  LRange := LWorksheet.range['E5'];
  LRange.FormulaR1C1 := ASOR.FSubConManager;
  LRange := LWorksheet.range['E6'];
  LRange.FormulaR1C1 := ASOR.FSubConPhonNo;
  LRange := LWorksheet.range['E7'];
  LRange.FormulaR1C1 := ASOR.FSubConEmail;
  LRange := LWorksheet.range['K8'];
  LRange.FormulaR1C1 := ASOR.FHullNo;
  LRange := LWorksheet.range['K9'];
  LRange.FormulaR1C1 := ASOR.FShipName;
  LRange := LWorksheet.range['E11'];
  LRange.FormulaR1C1 := ASOR.FSubject;
  LRange := LWorksheet.range['K10'];
  LRange.FormulaR1C1 := ASOR.FShipOwner;
  LRange := LWorksheet.range['S8'];
  LRange.FormulaR1C1 := ASOR.FProduceType;
  LRange := LWorksheet.range['S7'];
  LRange.FormulaR1C1 := ASOR.FPONo2SubCon;
  LRange := LWorksheet.range['S6'];
  LRange.FormulaR1C1 := ASOR.FOrderDate;
  LRange := LWorksheet.range['E13'];
  LRange.FormulaR1C1 := ASOR.FWorkSch;
  LRange := LWorksheet.range['X13'];
  LRange.FormulaR1C1 := ASOR.FEngineerNo;
  LRange := LWorksheet.range['S17'];
  LRange.FormulaR1C1 := ASOR.FLocalAgent;
  LRange := LWorksheet.range['E23'];
  LRange.FormulaR1C1 := ASOR.FWorkDesc;
end;

procedure MakeDocCompanySelection(ASOR: Doc_ServiceOrder_Rec);
var
  LExcel: OleVariant;
  LWorkBook: OleVariant;
  LRange: OleVariant;
  LWorksheet: OleVariant;
  LFileName, LStr: string;
begin
  LFileName := DOC_DIR + COMPANY_SELECTION_FILE;

  if not FileExists(LFileName) then
  begin
    ShowMessage('File(' + LFileName + ')이 존재하지 않습니다');
    exit;
  end;

  LExcel := GetActiveExcelOleObject(True);
  LWorkBook := LExcel.Workbooks.Open(LFileName);
  LExcel.Visible := true;
  LWorksheet := LExcel.ActiveSheet;

  LRange := LWorksheet.range['C4'];
  LRange.FormulaR1C1 := FormatDateTime('YYYY.MM.DD', now);
  LRange := LWorksheet.range['C47']; //제목
  LRange.FormulaR1C1 := ASOR.FSubject;
  LRange := LWorksheet.range['A49'];
  LStr := COMPANY_SELECTION_CONTENT + ASOR.FSubConName + '를 선정하여';
  LRange.FormulaR1C1 := LStr;
  LRange := LWorksheet.range['A52'];
  LRange.FormulaR1C1 := '   1. 선정 업체 : ' + ASOR.FSubConName;
  LRange := LWorksheet.range['A59'];
  LStr := '   3. 고객(공사코드) : ' + ASOR.FCustomer + ' ( ' + ASOR.FProjCode + ' ) ';
  LRange.FormulaR1C1 := LStr;
  LRange := LWorksheet.range['A60'];
  LRange.FormulaR1C1 := '   4. 작업 일정(작업장소) : ' + ASOR.FWorkPeriod + ' ( ' + ASOR.FNationPort + ' ) ';
  LRange := LWorksheet.range['A61'];
  LRange.FormulaR1C1 := '   5. 작업 내용 : ' + ASOR.FWorkSummary;
  LRange := LWorksheet.range['A62'];
  LRange.FormulaR1C1 := '   6. 기타 : 작업인원 (' + ASOR.FEngineerNo + '명)';
  LWorksheet := LExcel.WorkSheets.Item['Sheet1'];
  LRange := LWorksheet.range['C4'];
  LRange.FormulaR1C1 := ASOR.FSubConName;
  LRange := LWorksheet.range['H4'];
  LRange.FormulaR1C1 := ASOR.FSubConPrice;
end;

procedure MakeDocConfirmComplete(ASOR: Doc_ServiceOrder_Rec);
var
  LExcel: OleVariant;
  LWorkBook: OleVariant;
  LRange: OleVariant;
  LWorksheet: OleVariant;
  LFileName, LStr: string;
begin
  LFileName := DOC_DIR + CONFIRM_COMPLETION_FILE;

  if not FileExists(LFileName) then
  begin
    ShowMessage('File(' + LFileName + ')이 존재하지 않습니다');
    exit;
  end;

  LExcel := GetActiveExcelOleObject(True);
  LWorkBook := LExcel.Workbooks.Open(LFileName);
  LExcel.Visible := true;
  LWorksheet := LExcel.ActiveSheet;

  LRange := LWorksheet.range['E8'];
  LRange.FormulaR1C1 := ASOR.FWorkSummary;
  LRange := LWorksheet.range['E9'];
  LRange.FormulaR1C1 := ASOR.FSubConName;
  LRange := LWorksheet.range['E10'];
  LRange.FormulaR1C1 := ASOR.FWorkPeriod;
  LRange := LWorksheet.range['A24'];
  LRange.FormulaR1C1 := FormatDateTime('YYYY년 MM월 DD일', now);
end;

procedure MakeDocBudgetApproval;
begin

end;

procedure MakeDocContract;
begin

end;

procedure MakeDocBoardingPermit;
begin

end;

procedure MakeDocCustomerRegistration(ACRR: Doc_Cust_Reg_Rec; ALang: integer);
var
  LExcel: OleVariant;
  LWorkBook: OleVariant;
  LRange: OleVariant;
  LWorksheet: OleVariant;
  LFileName, LStr: string;
begin
  LFileName := DOC_DIR + CUSTOMER_REG_ENG;

  if not FileExists(LFileName) then
  begin
    ShowMessage('File(' + LFileName + ')이 존재하지 않습니다');
    exit;
  end;

  LExcel := GetActiveExcelOleObject(True);
  LWorkBook := LExcel.Workbooks.Open(LFileName);
  LExcel.Visible := true;
  LWorksheet := LExcel.ActiveSheet;

  LRange := LWorksheet.range['F9'];
  LRange.FormulaR1C1 := ACRR.FCompanyName;
  LRange := LWorksheet.range['J9'];
  LRange.FormulaR1C1 := ACRR.FCountry;
  LRange := LWorksheet.range['J11'];
  LRange.FormulaR1C1 := ACRR.FCity;
  LRange := LWorksheet.range['F12'];
  LRange.FormulaR1C1 := ACRR.FCompanyAddress;
  LRange := LWorksheet.range['G13'];
  LRange.FormulaR1C1 := ACRR.FTelNo;
  LRange := LWorksheet.range['J13'];
  LRange.FormulaR1C1 := ACRR.FFaxNo;
  LRange := LWorksheet.range['J14'];
  LRange.FormulaR1C1 := ACRR.FEMailAddress;
end;

function MakeDocSubConInvoiceList: OleVariant;
var
  LExcel: OleVariant;
  LWorkBook: OleVariant;
  LRange: OleVariant;
  LWorksheet: OleVariant;
  LFileName, LStr: string;
begin
  LFileName := DOC_DIR + SUBCON_INVOICE_LIST_FILE;

  if not FileExists(LFileName) then
  begin
    ShowMessage('File(' + LFileName + ')이 존재하지 않습니다');
    exit;
  end;

  LExcel := GetActiveExcelOleObject(True);
  LWorkBook := LExcel.Workbooks.Open(LFileName);
  LExcel.Visible := true;
  LWorksheet := LExcel.ActiveSheet;

  LRange := LWorksheet.range['A1'];
  LRange.FormulaR1C1 := FormatDateTime('YY년 M월', now) + ' 외주 용역비 인보이스 처리 현황';
  LRange := LWorksheet.range['M3'];
  LRange.FormulaR1C1 := FormatDateTime('YYYY.MM.DD', now);
  LRange := LWorksheet.range['A3'];
  LRange.FormulaR1C1 := '[부품기술영업부]';

  Result := LWorkSheet;
end;

procedure MakeDocSubConInvoiceList2(AWorkSheet: OleVariant;
  ASIL: Doc_SubCon_Invoice_List_Rec; ARow: integer);
var
  LRange: OleVariant;
  LWorksheet: OleVariant;
  LStr: OleVariant;
begin
  LStr := IntToStr(ARow);
  LRange := AWorkSheet.range['B'+LStr];
  LRange.FormulaR1C1 := '부품서비스2팀';
  LRange := AWorkSheet.range['C'+LStr];
  LRange.FormulaR1C1 := '박정현';
  LRange := AWorkSheet.range['D'+LStr];
  LRange.FormulaR1C1 := ASIL.FProjectCode;
  LRange := AWorkSheet.range['E'+LStr];
  LRange.FormulaR1C1 := ASIL.FHullNo;
  LRange := AWorkSheet.range['G'+LStr];
  LRange.FormulaR1C1 := ASIL.FPONo;
  LRange := AWorkSheet.range['H'+LStr];
  LRange.FormulaR1C1 := ASIL.FPOIssueDate;
  LRange := AWorkSheet.range['I'+LStr];
  LRange.FormulaR1C1 := ASIL.FSubConName;
  LRange := AWorkSheet.range['J'+LStr];
  LRange.FormulaR1C1 := ASIL.FWorkFinishDate;
  LRange := AWorkSheet.range['K'+LStr];
  LRange.FormulaR1C1 := ASIL.FInvoiceIssueDate;
end;

end.
