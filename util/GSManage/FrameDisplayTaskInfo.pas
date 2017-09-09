unit FrameDisplayTaskInfo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ImgList,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, AdvOfficeTabSet, Vcl.StdCtrls, Vcl.ComCtrls,
  AdvGroupBox, AdvOfficeButtons, AeroButtons, JvExControls, JvLabel,
  CurvyControls, System.SyncObjs, DateUtils,
  OtlCommon, OtlComm, OtlTaskControl, OtlContainerObserver, otlTask, OtlParallel,
  mORMot, SynCommons, SynSqlite3Static, VarRecUtils,
  CommonData, UElecDataRecord, TaskForm, FSMClass_Dic, FSMState, Vcl.Menus,
  Vcl.ExtCtrls, UnitMakeReport, UnitTodoList, UnitTodoCollect;

type
  TDisplayTaskF = class(TFrame)
    CurvyPanel1: TCurvyPanel;
    JvLabel2: TJvLabel;
    JvLabel5: TJvLabel;
    JvLabel6: TJvLabel;
    JvLabel1: TJvLabel;
    JvLabel3: TJvLabel;
    PeriodPanel: TCurvyPanel;
    Label4: TLabel;
    rg_period: TAdvOfficeRadioGroup;
    dt_begin: TDateTimePicker;
    dt_end: TDateTimePicker;
    ProductTypeCombo: TComboBox;
    CustomerCombo: TComboBox;
    SubjectEdit: TEdit;
    HullNoEdit: TEdit;
    ShipNameEdit: TEdit;
    TaskTab: TAdvOfficeTabSet;
    grid_Req: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    HullNo: TNxTextColumn;
    ShipName: TNxTextColumn;
    Subject: TNxTextColumn;
    ProdType: TNxTextColumn;
    ReqCustomer: TNxTextColumn;
    Status: TNxTextColumn;
    RecvDate: TNxDateColumn;
    Email: TNxButtonColumn;
    EMailID: TNxTextColumn;
    PONo: TNxTextColumn;
    QtnNo: TNxTextColumn;
    OrderNo: TNxTextColumn;
    CustomerName: TNxTextColumn;
    QtnInputDate: TNxDateColumn;
    OrderInputDate: TNxDateColumn;
    InvoiceInputDate: TNxDateColumn;
    CustomerAddress: TNxMemoColumn;
    imagelist24x24: TImageList;
    ImageList32x32: TImageList;
    ImageList16x16: TImageList;
    PopupMenu1: TPopupMenu;
    ShowTaskID1: TMenuItem;
    ShowEmailID1: TMenuItem;
    N1: TMenuItem;
    DeleteTask1: TMenuItem;
    ShowGSFileID1: TMenuItem;
    JvLabel7: TJvLabel;
    ComboBox1: TComboBox;
    BefAftCB: TComboBox;
    CurWorkCB: TComboBox;
    Panel1: TPanel;
    btn_Search: TAeroButton;
    btn_Close: TAeroButton;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    NextProcess: TNxTextColumn;
    WorkKindCB: TComboBox;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    Invoice1: TMenuItem;
    Invoice2: TMenuItem;
    InvoiceConfirm1: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    InvoiceConfirm2: TMenuItem;
    Invoice3: TMenuItem;
    Invoice4: TMenuItem;
    N10: TMenuItem;
    AeroButton1: TAeroButton;
    JvLabel4: TJvLabel;
    QtnNoEdit: TEdit;
    JvLabel8: TJvLabel;
    OrderNoEdit: TEdit;
    procedure btn_SearchClick(Sender: TObject);
    procedure ComboBox1DropDown(Sender: TObject);
    procedure rg_periodClick(Sender: TObject);
    procedure grid_ReqCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure EmailButtonClick(Sender: TObject);
    procedure ShowTaskID1Click(Sender: TObject);
    procedure ShowEmailID1Click(Sender: TObject);
    procedure DeleteTask1Click(Sender: TObject);
    procedure ShowGSFileID1Click(Sender: TObject);
    procedure CurWorkCBDropDown(Sender: TObject);
    procedure ProductTypeComboDropDown(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure TaskTabChange(Sender: TObject);
    procedure HullNoEditKeyPress(Sender: TObject; var Key: Char);
    procedure ShipNameEditKeyPress(Sender: TObject; var Key: Char);
    procedure SubjectEditKeyPress(Sender: TObject; var Key: Char);
    procedure Invoice4Click(Sender: TObject);
    procedure AeroButton1Click(Sender: TObject);
  private
    procedure ExecuteSearch(Key: Char);

    procedure InitFSM;
    procedure Add2FSM(ASPType:TSalesProcessType=sptNone;
      ACompanyType: TCompanyType=ctNull);
    //TaskTab의 tag에 TSalesProcess값을 지정함
    //마우스로 tab 선택 시 해당 Task만 보이기 위함
    procedure InitTaskTab;

    procedure AddOrUpdateTask(ATask: TSQLGSTask);
    procedure AddOrUpdateCustomer(ACustomer: TSQLCustomer);
    procedure AddOrUpdateSubCon(ASubCon: TSQLSubCon);
    procedure AddOrUpdateMaterial4Project(AMaterial4Project: TSQLMaterial4Project);

    function GetSqlWhereFromQueryDate(AQueryDate: TQueryDateType): string;
    function GetTaskIdFromGrid(ARow: integer): TID;

    procedure DeleteTask(ATaskID: TID);
    procedure DeleteMailsFromTask(ATask: TSQLGSTask);
    procedure DeleteFilesFromTask(ATask: TSQLGSTask);
    procedure DeleteCustomerFromTask(ATask: TSQLGSTask);
    procedure DeleteSubConFromTask(ATask: TSQLGSTask);
    procedure DeleteMaterial4ProjFromTask(ATask: TSQLGSTask);
    procedure DeleteToDoListFromTask(ATask: TSQLGSTask);

    function Get_Doc_SubCon_Invoice_List_Rec: Doc_SubCon_Invoice_List_Rec;

    function Get_Doc_Qtn_Rec(ARow: integer): Doc_Qtn_Rec;
    function Get_Doc_Inv_Rec(ARow: integer): Doc_Invoice_Rec;
    function Get_Doc_ServiceOrder_Rec(ARow: integer): Doc_ServiceOrder_Rec;
    function Get_Doc_Cust_Reg_Rec(ARow: integer): Doc_Cust_Reg_Rec;

    procedure MakeQtn(ARow: integer);
    procedure MakeInvoice(ARow: integer);
    procedure MakeServiceOrder(ARow: integer);
    procedure MakeCustReg(ARow: integer);
  protected
    procedure ShowTaskIDFromGrid;
    procedure ShowEmailIDFromGrid;
  public
    FFSMClass: TFSMClass;
    //메일을 이동시킬 폴더 리스트,
    //HGS Task/Send Folder Name 2 IPC 메뉴에 의해 OL으로 부터 수신함
    FFolderListFromOL: TStringList;
    FToDoCollect: TpjhToDoItemCollection;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function CreateOrGetLoadTask(const ATaskID: integer): TSQLGSTask;
    function GetLoadTask(const ATaskID: integer): TSQLGSTask;
    procedure DisplayTaskInfo2EditForm(const ATaskID: integer); overload;
    procedure DisplayTaskInfo2EditForm(var ATask: TSQLGSTask;
      ASQLEmailMsg: TSQLEmailMsg = nil); overload;
    procedure DisplayTaskInfo2Grid(AFrom,ATo: TDateTime; AQueryDate: TQueryDateType;
      AHullNo, AShipName, ACustomer, AProdType, ASubject: string; ACurWork,
      ABefAft, AWorkKind: integer; AQtnNo, AOrderNo: string);
    procedure LoadTaskVar2Grid(AVar: TSQLGSTask; AGrid: TNextGrid;
      ARow: integer = -1);

    procedure AddFolderListFromOL(AFolder: string);

    procedure ShowTaskFormFromGrid(ARow: integer);
    procedure ShowTaskFormFromData(ARow: integer); overload;
    procedure ShowTaskFormFromData(AIDList: TIDList; ARow: integer); overload;
    procedure ShowEmailListFormFromData(ARow: integer);
    procedure ShowTodoListFormFromData(ARow: integer);
    procedure ShowToDoListFromCollect(AToDoCollect: TpjhToDoItemCollection);
  end;

implementation

uses System.Rtti;

{$R *.dfm}

procedure TDisplayTaskF.SubjectEditKeyPress(Sender: TObject; var Key: Char);
begin
  ExecuteSearch(Key);
end;

function TDisplayTaskF.CreateOrGetLoadTask(const ATaskID: integer): TSQLGSTask;
begin
  if ATaskID = 0 then
  begin
    Result := TSQLGSTask.Create;
    Result.IsUpdate := False;
  end
  else
  begin
    Result:= TSQLGSTask.Create(g_ProjectDB, ATaskID);
    if Result.ID = ATaskID then
    begin
//      Result.FillRewind;
      Result.IsUpdate := True;
    end
    else
    begin
      Result := TSQLGSTask.Create;
      Result.IsUpdate := False;
    end;
  end;
end;

procedure TDisplayTaskF.CurWorkCBDropDown(Sender: TObject);
begin
  SalesProcess2Combo(CurWorkCB);
end;

procedure TDisplayTaskF.LoadTaskVar2Grid(AVar: TSQLGSTask; AGrid: TNextGrid;
  ARow: integer);
var
  LIds: TIDDynArray;
  LSQLEmailMsg: TSQLEmailMsg;
  LSubject: string;
  LStrList: TStringList;
  LFSMState: TFSMState;
begin
  if not Assigned(AVar) then
    exit;

  if ARow = -1 then
  begin
    ARow := AGrid.AddRow;
    AGrid.Row[ARow].Data := TIDList.Create;
    TIDList(AGrid.Row[ARow].Data).TaskId := AVar.ID;
  end;

  AVar.EmailMsg.DestGet(g_ProjectDB, AVar.ID, LIds);
  LSQLEmailMsg:= TSQLEmailMsg.CreateAndFillPrepare(g_ProjectDB, TInt64DynArray(LIds));
  try
    while LSQLEmailMsg.FillOne do
    begin
      if LSQLEmailMsg.ParentID = '' then
      begin
        LSubject := LSQLEmailMsg.Subject;
        break;
      end;
    end;

    with AVar, AGrid do
    begin
      CellByName['HullNo', ARow].AsString := HullNo;
      CellByName['ShipName', ARow].AsString := ShipName;

      if WorkSummary <> '' then
        CellByName['Subject', ARow].AsString := WorkSummary
      else
        CellByName['Subject', ARow].AsString := LSubject;

      CellByName['ProdType', ARow].AsString := ProductType;
      CellByName['PONo', ARow].AsString := PO_No;
      CellByName['QtnNo', ARow].AsString := QTN_No;
      CellByName['OrderNo', ARow].AsString := Order_No;
      CellByName['Status', ARow].AsString := SalesProcess2String(
        TSalesProcess(CurrentWorkStatus));

      if NextWork > 0 then
      begin
        CellByName['NextProcess', ARow].AsString := SalesProcess2String(
          TSalesProcess(NextWork));
      end
      else
      begin
        LFSMState := FFSMClass.GetState(Ord(SalesProcessType));
        if Assigned(LFSMState) then
        begin
          LStrList := TStringList.Create;
          try
            SalesProcess2List(LStrList, LFSMState);
            CellByName['NextProcess', ARow].AsString := SalesProcess2String(
              TSalesProcess(LFSMState.GetOutput(CurrentWorkStatus)));
          finally
            LStrList.Free;
          end;
        end;
      end;

//      CellByName['CustomerName', ARow].AsString := ReqCustomer;
//      CellByName['CustomerAddress', ARow].AsString := CustomerAddress;

      CellByName['QtnInputDate', ARow].AsDateTime := TimeLogToDateTime(QTNInputDate);
      CellByName['OrderInputDate', ARow].AsDateTime := TimeLogToDateTime(OrderInputDate);
      CellByName['RecvDate', ARow].AsDateTime := TimeLogToDateTime(InqRecvDate);
      CellByName['InvoiceInputDate', ARow].AsDateTime := TimeLogToDateTime(InvoiceIssueDate);
      TIDList(Row[ARow].Data).EmailId := LSQLEmailMsg.ID;
    end;
  finally
    FreeAndNil(LSQLEmailMsg);
  end;
end;

procedure TDisplayTaskF.MakeCustReg(ARow: integer);
var
  LRec: Doc_Cust_Reg_Rec;
begin
  LRec := Get_Doc_Cust_Reg_Rec(ARow);
  MakeDocCustomerRegistration(LRec);
end;

procedure TDisplayTaskF.MakeInvoice(ARow: integer);
var
  LRec: Doc_Invoice_Rec;
begin
  LRec := Get_Doc_Inv_Rec(ARow);
  MakeDocInvoice(LRec);
end;

procedure TDisplayTaskF.MakeQtn(ARow: integer);
var
  LRec: Doc_Qtn_Rec;
begin
  LRec := Get_Doc_Qtn_Rec(ARow);
  MakeDocQtn(LRec);
end;

procedure TDisplayTaskF.MakeServiceOrder(ARow: integer);
var
  LRec: Doc_ServiceOrder_Rec;
begin
  LRec := Get_Doc_ServiceOrder_Rec(ARow);
  MakeDocServiceOrder(LRec);
end;

procedure TDisplayTaskF.N4Click(Sender: TObject);
var
  LRec: Doc_SubCon_Invoice_List_Rec;
  LWorksheet: OleVariant;
  LRow: integer;
begin
//  LRec := Get_Doc_SubCon_Invoice_List_Rec;
//  LWorksheet := MakeDocSubConInvoiceList;
//  MakeDocSubConInvoiceList2(LWorkSheet, LRec, LRow);
end;

procedure TDisplayTaskF.ProductTypeComboDropDown(Sender: TObject);
begin
  ElecProductType2Combo(ProductTypeCombo);
end;

procedure TDisplayTaskF.rg_periodClick(Sender: TObject);
begin
  dt_begin.Enabled := False;
  dt_end.Enabled := False;
  case rg_period.ItemIndex of
    0:
      begin
        dt_begin.Date := Now;
        dt_end.Date := Now;
      end;
    1:
      begin
        dt_begin.Date := StartOfTheWeek(Now);
        dt_end.Date := EndOfTheWeek(Now);
      end;
    2:
      begin
        dt_begin.Date := StartOfTheMonth(Now);
        dt_end.Date := EndOfTheMonth(Now);
      end;
    3:
      begin
        dt_begin.Enabled := True;
        dt_end.Enabled := True;
      end;
  end;
end;

function TDisplayTaskF.GetLoadTask(const ATaskID: integer): TSQLGSTask;
begin
  Result := nil;

  if ATaskID > 0 then
  begin
    Result:= TSQLGSTask.Create(g_ProjectDB, ATaskID);
    Result.IsUpdate := True;
  end;
end;

function TDisplayTaskF.GetSqlWhereFromQueryDate(AQueryDate: TQueryDateType): string;
begin
  case AQueryDate of
    qdtInqRecv: Result := 'InqRecvDate >= ? and InqRecvDate <= ? ';
    qdtInvoiceIssue: Result := 'InvoiceIssueDate >= ? and InvoiceIssueDate <= ? ';
    qdtQTNInput: Result := 'QTNInputDate >= ? and QTNInputDate <= ? ';
    qdtOrderInput: Result := 'OrderInputDate >= ? and OrderInputDate <= ? ';
  end;
end;

function TDisplayTaskF.GetTaskIdFromGrid(ARow: integer): TID;
begin
  if Assigned(grid_Req.Row[ARow].Data) then
    Result := TIDList(grid_Req.Row[ARow].Data).fTaskId
  else
    Result := -1;
end;

function TDisplayTaskF.Get_Doc_Cust_Reg_Rec(ARow: integer): Doc_Cust_Reg_Rec;
var
  LTask: TSQLGSTask;
  LIdList: TIDList;
  LCustomer: TSQLCustomer;
begin
  if grid_Req.Row[ARow].Data <> nil then
  begin
    LIdList := TIDList(grid_Req.Row[ARow].Data);

    LTask:= CreateOrGetLoadTask(LIdList.fTaskId);
    try
      LCustomer := GetCustomerFromTask(LTask);

      Result.FCompanyName := LCustomer.CompanyName;
      Result.FCountry := LTask.NationPort;
      Result.FCompanyAddress := LCustomer.CompanyAddress;
      Result.FTelNo := LCustomer.OfficePhone;
      Result.FFaxNo := LCustomer.MobilePhone;
      Result.FEMailAddress := LCustomer.EMail;
    finally
      if Assigned(LTask) then
        FreeAndNil(LTask);
      if Assigned(LCustomer) then
        FreeAndNil(LCustomer);
    end;
  end;
end;

function TDisplayTaskF.Get_Doc_Inv_Rec(ARow: integer): Doc_Invoice_Rec;
var
  LTask: TSQLGSTask;
  LIdList: TIDList;
  LCustomer: TSQLCustomer;
begin
  if grid_Req.Row[ARow].Data <> nil then
  begin
    LIdList := TIDList(grid_Req.Row[ARow].Data);

    LTask:= CreateOrGetLoadTask(LIdList.fTaskId);
    try
      LCustomer := GetCustomerFromTask(LTask);
      Result.FCustomerInfo := LCustomer.CompanyAddress;

      Result.FCustomerInfo := Result.FCustomerInfo.Replace(#13, '');
      Result.FInvNo := LTask.Order_No;
      Result.FHullNo := LTask.HullNo;
      Result.FShipName := LTask.ShipName;
      Result.FSubject := LTask.WorkSummary;
      Result.FPONo := LTask.PO_No;
    finally
      if Assigned(LTask) then
        FreeAndNil(LTask);
      if Assigned(LCustomer) then
        FreeAndNil(LCustomer);
    end;
  end;
end;

function TDisplayTaskF.Get_Doc_Qtn_Rec(ARow: integer): Doc_Qtn_Rec;
var
  LQTN: string;
  LTask: TSQLGSTask;
  LIdList: TIDList;
  LCustomer: TSQLCustomer;
begin
  if grid_Req.Row[ARow].Data <> nil then
  begin
    LIdList := TIDList(grid_Req.Row[ARow].Data);

    LTask:= CreateOrGetLoadTask(LIdList.fTaskId);
    try
      LCustomer := GetCustomerFromTask(LTask);
      Result.FCustomerInfo := LCustomer.CompanyAddress;

      Result.FCustomerInfo := Result.FCustomerInfo.Replace(#13, '');

      LQTN := LTask.QTN_No;
      if LQTN = '' then
        LQTN := LTask.HullNo + '-' + IntToStr(Random(9));

      Result.FQtnNo := LQTN;
      Result.FQtnDate := FormatDateTime('dd.mmm.yyyy', now);
      Result.FHullNo := LTask.HullNo;
      Result.FShipName := LTask.ShipName;
      Result.FSubject := LTask.WorkSummary;
      Result.FPONo := LTask.PO_No;
      Result.FValidateDate := FormatDateTime('mmm.dd.yyyy', now+30);
    finally
      if Assigned(LTask) then
        FreeAndNil(LTask);
      if Assigned(LCustomer) then
        FreeAndNil(LCustomer);
    end;
  end;
end;

function TDisplayTaskF.Get_Doc_ServiceOrder_Rec(ARow: integer): Doc_ServiceOrder_Rec;
var
  LPeriod:string;
  LTask: TSQLGSTask;
  LIdList: TIDList;
  LSQLSubCon: TSQLSubCon;
  LSQLCustomer: TSQLCustomer;
begin
  if grid_Req.Row[ARow].Data <> nil then
  begin
    LIdList := TIDList(grid_Req.Row[ARow].Data);

    LTask:= CreateOrGetLoadTask(LIdList.fTaskId);
    try
      LSQLSubCon := GetSubConFromTask(LTask);
      Result.FSubConName := LSQLSubCon.CompanyName;
      Result.FSubConManager := LSQLSubCon.ManagerName;
      Result.FSubConPhonNo := LSQLSubCon.MobilePhone;
      Result.FSubConEmail := LSQLSubCon.EMail;

      LSQLCustomer:= GetCustomerFromTask(LTask);
      Result.FLocalAgent := LSQLCustomer.AgentInfo;
      Result.FCustomer := LSQLCustomer.CompanyName;

      Result.FHullNo := LTask.HullNo;
      Result.FShipName := LTask.ShipName;
      Result.FSubject := LTask.WorkSummary;
      Result.FPONo2SubCon := LTask.PO_No;
      Result.FOrderDate := FormatDateTime('dd.mmm.yyyy', now);
      Result.FWorkSch := '1.Place : ' + LTask.NationPort;
      LPeriod := FormatDateTime('yyyy.mm.dd',LTask.WorkBeginDate);
      LPeriod := LPeriod + ' ~ ' + FormatDateTime('yyyy.mm.dd',LTask.WorkEndDate);
      Result.FWorkPeriod := LPeriod;
      Result.FWorkSch := Result.FWorkSch + #13#10 + '2.Period : ' + LTask.NationPort;
      Result.FEngineerNo := IntToStr(LTask.SECount);
      Result.FLocalAgent := Result.FLocalAgent.Replace(#13,'');

      Result.FProjCode := LTask.Order_No;
      Result.FNationPort := LTask.NationPort;
      Result.FWorkSummary := LTask.WorkSummary;
      Result.FSubConPrice := LTask.SubConPrice;
    finally
      if Assigned(LTask) then
        FreeAndNil(LTask);

      if Assigned(LSQLSubCon) then
        FreeAndNil(LSQLSubCon);

      if Assigned(LSQLCustomer) then
        FreeAndNil(LSQLCustomer);
    end;
  end;
end;

function TDisplayTaskF.Get_Doc_SubCon_Invoice_List_Rec: Doc_SubCon_Invoice_List_Rec;
begin
//  Result.FProjectCode := OrderNoEdit.Text;
//  Result.FHullNo := HullNoEdit.Text;
////  Result.FClaimNo := OrderNoEdit.Text;
//  Result.FPONo := PONoEdit.Text;
//  Result.FPOIssueDate := FormatDateTime('YYYY.MM.DD',QTNInputPicker.Date);
//  Result.FSubConName := SubCompanyEdit.Text;
//  Result.FWorkFinishDate := FormatDateTime('YYYY.MM.DD',WorkEndPicker.Date);
//  Result.FInvoiceIssueDate := FormatDateTime('YYYY.MM.DD',InvoiceIssuePicker.Date);
end;

procedure TDisplayTaskF.grid_ReqCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
var
  LTask: TSQLGSTask;
begin
  if ARow = -1 then
    Exit;

  ShowTaskFormFromData(ARow);
end;

procedure TDisplayTaskF.HullNoEditKeyPress(Sender: TObject; var Key: Char);
begin
  ExecuteSearch(Key);
end;

procedure TDisplayTaskF.InitFSM;
var Li: TSalesProcessType;
begin
  for Li := sptNone to Pred(sptFinal) do
    Add2FSM(LI);
end;

procedure TDisplayTaskF.InitTaskTab;
var
  i: integer;
  LStr: string;
  LStatus: TSalesProcess;
begin
  for i := 0 to TaskTab.AdvOfficeTabs.Count - 1 do
  begin
    LStr := TaskTab.AdvOfficeTabs[i].Name;
    LStatus := TRttiEnumerationType.GetValue<TSalesProcess>(LStr);
    TaskTab.AdvOfficeTabs[i].Tag := Ord(LStatus);
  end;
end;

procedure TDisplayTaskF.Invoice4Click(Sender: TObject);
begin
  MakeInvoice(grid_Req.SelectedRow);
end;

procedure TDisplayTaskF.DisplayTaskInfo2EditForm(const ATaskID: integer);
var
  LTask: TSQLGSTask;
begin
  LTask:= CreateOrGetLoadTask(ATaskID);
  try
    DisplayTaskInfo2EditForm(LTask);
  finally
    FreeAndNil(LTask);
  end;
end;

procedure TDisplayTaskF.Add2FSM(ASPType: TSalesProcessType;
  ACompanyType: TCompanyType);
var
  LFSMState: TFSMState;
  LNumOfTransaction: integer;
begin
  LNumOfTransaction := 26;

  if ASPType > sptDomesticCustOnlyService then
    LNumOfTransaction := LNumOfTransaction + 6
  else
    LNumOfTransaction := LNumOfTransaction + 1;

  LFSMState := TFSMState.Create(ord(ASPType), LNumOfTransaction);

  with LFSMState do
  begin
    AddTransition(ord(spNone), ord(spQtnReqRecvFromCust));
    AddTransition(ord(spQtnReqRecvFromCust), ord(spQtnReq2SubCon));
    AddTransition(ord(spQtnReq2SubCon), ord(spQtnRecvFromSubCon));
    AddTransition(ord(spQtnRecvFromSubCon), ord(spQtnSend2Cust));
    AddTransition(ord(spQtnSend2Cust), ord(spVslSchedReq2Cust));
    AddTransition(ord(spVslSchedReq2Cust), ord(spSECanAvail2SubCon));
    AddTransition(ord(spSECanAvail2SubCon), ord(spSEAvailRecvFromSubCon));
    AddTransition(ord(spSEAvailRecvFromSubCon), ord(spSECanAttend2Cust));
    AddTransition(ord(spSECanAttend2Cust), ord(spPOReq2Cust));
    AddTransition(ord(spPOReq2Cust), ord(spPORecvFromCust));
    AddTransition(ord(spPORecvFromCust), ord(spSEDispatchReq2SubCon));
    AddTransition(ord(spSEDispatchReq2SubCon), ord(spQtnInput));
    AddTransition(ord(spQtnInput), ord(spQtnApproval));
    AddTransition(ord(spQtnApproval), ord(spOrderInput));
    AddTransition(ord(spOrderInput), ord(spOrderApproval));

    if ASPType > sptDomesticCustOnlyService then
    begin
      //자재가 없으면 아래 생략할 것
      AddTransition(ord(spOrderApproval), ord(spPORCheck4HiPRO));
      AddTransition(ord(spPORCheck4HiPRO), ord(spShipInstruct));//출하지시
      AddTransition(ord(spShipInstruct), ord(spDelivery));
      AddTransition(ord(spDelivery), ord(spAWBRecv));
      AddTransition(ord(spAWBRecv), ord(spAWBSend2Cust));
      AddTransition(ord(spAWBSend2Cust), ord(spSRRecvFromSubCon));
    end
    else
      AddTransition(ord(spOrderApproval), ord(spSRRecvFromSubCon));

    AddTransition(ord(spSRRecvFromSubCon), ord(spSRSend2Cust));
    AddTransition(ord(spSRSend2Cust), ord(spInvoiceRecvFromSubCon));
    AddTransition(ord(spInvoiceRecvFromSubCon), ord(spInvoiceSend2Cust));
    AddTransition(ord(spInvoiceSend2Cust), ord(spInvoiceConfirmFromCust));
    AddTransition(ord(spInvoiceConfirmFromCust), ord(spOrderPriceModify));
    AddTransition(ord(spOrderPriceModify), ord(spModifiedOrderApproval));
    AddTransition(ord(spModifiedOrderApproval), ord(spTaxBillReq2SubCon));
    AddTransition(ord(spTaxBillReq2SubCon), ord(spTaxBillIssue2Cust));
    AddTransition(ord(spTaxBillIssue2Cust), ord(spTaxBillRecvFromSubCon));
    AddTransition(ord(spTaxBillRecvFromSubCon), ord(spTaxBillSend2GeneralAffair));
    AddTransition(ord(spTaxBillSend2GeneralAffair), ord(spSaleReq2GeneralAffair));
  end;

  FFSMClass.AddState(LFSMState);
end;

procedure TDisplayTaskF.AddFolderListFromOL(AFolder: string);
begin
  if FFolderListFromOL.IndexOf(AFolder) = -1  then
  begin
    FFolderListFromOL.Add(AFolder);
    SetCurrentDir(ExtractFilePath(Application.ExeName));

    if FileExists('.\'+FOLDER_LIST_FILE_NAME) then
      DeleteFile('.\'+FOLDER_LIST_FILE_NAME);

    FFolderListFromOL.SaveToFile('.\'+FOLDER_LIST_FILE_NAME);
  end
  else
    ShowMessage('동일한 Folder 이름이 존재함 : ' + AFolder);
end;

procedure TDisplayTaskF.AddOrUpdateCustomer(ACustomer: TSQLCustomer);
begin
  if ACustomer.IsUpdate then
  begin
    g_MasterDB.Update(ACustomer);
//    ShowMessage('Customer Update 완료');
  end
  else
  begin
    g_MasterDB.Add(ACustomer, true);
//    ShowMessage('Customer Add 완료');
  end;
end;

procedure TDisplayTaskF.AddOrUpdateMaterial4Project(
  AMaterial4Project: TSQLMaterial4Project);
begin
  if AMaterial4Project.IsUpdate then
  begin
    g_MasterDB.Update(AMaterial4Project);
//    ShowMessage('자재 Update 완료');
  end
  else
  begin
    g_MasterDB.Add(AMaterial4Project, true);
//    ShowMessage('자재 Add 완료');
  end;
end;

procedure TDisplayTaskF.AddOrUpdateSubCon(ASubCon: TSQLSubCon);
begin
  if ASubCon.IsUpdate then
  begin
    g_MasterDB.Update(ASubCon);
//    ShowMessage('협력사 Update 완료');
  end
  else
  begin
    g_MasterDB.Add(ASubCon, true);
//    ShowMessage('협력사 Add 완료');
  end;
end;

procedure TDisplayTaskF.AddOrUpdateTask(ATask: TSQLGSTask);
begin
  if ATask.IsUpdate then
  begin
    g_ProjectDB.Update(ATask);
    ShowMessage('Task Update 완료');
  end
  else
  begin
    g_ProjectDB.Add(ATask, true);
    ShowMessage('Task Add 완료');
  end;
end;

procedure TDisplayTaskF.AeroButton1Click(Sender: TObject);
begin
  ShowTodoListFormFromData(-1);
end;

procedure TDisplayTaskF.ShowToDoListFromCollect(AToDoCollect: TpjhToDoItemCollection);
begin
  Create_ToDoList_Frm('', AToDoCollect, True,
    InsertOrUpdateToDoList2DB, DeleteToDoListFromDB);
end;

procedure TDisplayTaskF.TaskTabChange(Sender: TObject);
var
  i : Integer;
  LTaskStatus, LStr: String;
begin
  with grid_Req do
  begin
    BeginUpdate;
    try
      LTaskStatus := SalesProcess2String(TSalesProcess(TaskTab.AdvOfficeTabs[TaskTab.ActiveTabIndex].Tag));
      if TaskTab.AdvOfficeTabs[TaskTab.ActiveTabIndex].Caption.Contains('대기') then
      begin
        LStr := 'NextProcess';
      end
      else if TaskTab.AdvOfficeTabs[TaskTab.ActiveTabIndex].Caption.Contains('완료') then
      begin
        LStr := 'Status';
      end;

      for i := 0 to RowCount-1 do
      begin
        if TaskTab.ActiveTabIndex = 0 then
          RowVisible[i] := True
        else
        begin
          if CellByName[LStr,i].AsString = LTaskStatus then
            RowVisible[i] := True
          else
            RowVisible[i] := False;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TDisplayTaskF.btn_SearchClick(Sender: TObject);
var
  LQueryDateType: TQueryDateType;
begin
  if ComboBox1.ItemIndex = -1 then
    LQueryDateType := qdtNull
  else
    LQueryDateType := R_QueryDateType[TQueryDateType(ComboBox1.ItemIndex)].Value;

  DisplayTaskInfo2Grid(dt_Begin.Date, dt_end.Date, LQueryDateType,
    HullNoEdit.Text, ShipNameEdit.Text, CustomerCombo.Text,
    ProductTypeCombo.Text, SubjectEdit.Text, CurWorkCB.ItemIndex,
    BefAftCB.ItemIndex, WorkKindCB.ItemIndex, QtnNoEdit.Text, OrderNoEdit.Text);
end;

procedure TDisplayTaskF.ComboBox1DropDown(Sender: TObject);
begin
  ComboBox1.Clear;
  QueryDateType2Combo(ComboBox1);
end;

constructor TDisplayTaskF.Create(AOwner: TComponent);
begin
  inherited;

  SetCurrentDir(ExtractFilePath(Application.ExeName));
  FFolderListFromOL := TStringList.Create;
  if FileExists('.\'+FOLDER_LIST_FILE_NAME) then
    FFolderListFromOL.LoadFromFile('.\'+FOLDER_LIST_FILE_NAME);
  FFSMClass := TFSMClass.Create(0);
  FToDoCollect := TpjhToDoItemCollection.Create(TpjhTodoItem);
  InitFSM;
  InitTaskTab;
  ComboBox1DropDown(nil);
//  ComboBox1.ItemIndex := 1;
end;

procedure TDisplayTaskF.DeleteCustomerFromTask(ATask: TSQLGSTask);
var
  LSQLCustomer: TSQLCustomer;
begin
  LSQLCustomer := GetCustomerFromTask(ATask);
  try
    g_MasterDB.Delete(TSQLCustomer, LSQLCustomer.ID);
  finally
    FreeAndNil(LSQLCustomer);
  end;
end;

procedure TDisplayTaskF.DeleteFilesFromTask(ATask: TSQLGSTask);
var
  LSQLGSFile: TSQLGSFile;
begin
  LSQLGSFile := GetFilesFromTask(ATask);

  try
    while LSQLGSFile.FillOne do
    begin
      g_FileDB.Delete(TSQLGSFile, LSQLGSFile.ID);
    end;
  finally
    FreeAndNil(LSQLGSFile);
  end;
end;

procedure TDisplayTaskF.DeleteMailsFromTask(ATask: TSQLGSTask);
var
  LIds: TIDDynArray;
  i: integer;
begin
  ATask.EmailMsg.DestGet(g_ProjectDB, ATask.ID, LIds);

  for i := Low(LIds) to High(LIds) do
  begin
    ATask.EmailMsg.ManyDelete(g_ProjectDB, ATask.ID, LIds[i]);
    g_ProjectDB.Delete(TSQLEmailMsg, LIds[i]);
  end;
end;

procedure TDisplayTaskF.DeleteMaterial4ProjFromTask(ATask: TSQLGSTask);
var
  LSQLMaterial4Project: TSQLMaterial4Project;
begin
  LSQLMaterial4Project := GetMaterial4ProjFromTask(ATask);
  try
    g_MasterDB.Delete(TSQLMaterial4Project, LSQLMaterial4Project.ID);
  finally
    FreeAndNil(LSQLMaterial4Project);
  end;
end;

procedure TDisplayTaskF.DeleteSubConFromTask(ATask: TSQLGSTask);
var
  LSQLSubCon: TSQLSubCon;
begin
  LSQLSubCon := GetSubConFromTask(ATask);
  try
    g_MasterDB.Delete(TSQLSubCon, LSQLSubCon.ID);
  finally
    FreeAndNil(LSQLSubCon);
  end;
end;

procedure TDisplayTaskF.DeleteTask(ATaskID: TID);
var
  LTask: TSQLGSTask;
begin
  LTask := GetLoadTask(ATaskID);

  if Assigned(LTask) then
  begin
    DeleteMailsFromTask(LTask);
    DeleteFilesFromTask(LTask);
    DeleteCustomerFromTask(LTask);
    DeleteSubConFromTask(LTask);
    DeleteMaterial4ProjFromTask(LTask);
    DeleteToDoListFromTask(LTask);

    g_ProjectDB.Delete(TSQLGSTask, LTask.ID);
  end;
end;

procedure TDisplayTaskF.DeleteTask1Click(Sender: TObject);
var
  LIdList: TIDList;
begin
  if grid_Req.SelectedRow = -1 then
    exit;

  if grid_Req.Row[grid_Req.SelectedRow].Data <> nil then
  begin
    LIdList := TIDList(grid_Req.Row[grid_Req.SelectedRow].Data);
    DeleteTask(LIdList.TaskId);
    btn_SearchClick(nil);
  end;
end;

procedure TDisplayTaskF.DeleteToDoListFromTask(ATask: TSQLGSTask);
var
  LSQLToDoItem: TSQLToDoItem;
begin
  LSQLToDoItem := GetToDoItemFromTask(ATask);
  try
    LSQLToDoItem.FillRewind;

    while LSQLToDoItem.FillOne do
      g_ProjectDB.Delete(TSQLToDoItem, LSQLToDoItem.ID);
  finally
    FreeAndNil(LSQLToDoItem);
  end;
end;

destructor TDisplayTaskF.Destroy;
begin
  FreeAndNil(FToDoCollect);
  FFolderListFromOL.Free;
  FFSMClass.Destroy;

  inherited;
end;

procedure TDisplayTaskF.DisplayTaskInfo2EditForm(var ATask: TSQLGSTask;
  ASQLEmailMsg: TSQLEmailMsg);
var
  LTaskEditF: TTaskEditF;
  LCustomer: TSQLCustomer;
  LSubCon: TSQLSubCon;
  LMat4Proj: TSQLMaterial4Project;
  LTask, LTask2: TSQLGSTask;
  LFiles: TSQLGSFile;
//  LTaskIds: TIDDynArray;
  i: integer;
  LID: TID;
begin
  LTaskEditF := TTaskEditF.Create(nil);
  try
    with LTaskEditF do
    begin
      LTask := ATask;
      LTaskEditF.FEmailDisplayTask := ATask;
//      LTaskEditF.FTask := ATask;
      LoadTaskVar2Form(LTask, LTaskEditF, FFSMClass);
      LCustomer := GetCustomerFromTask(LTask);
      LoadCustomer2Form(LCustomer, LTaskEditF);
      LSubCon := GetSubConFromTask(LTask);
      LoadSubCon2Form(LSubCon, LTaskEditF);
      LMat4Proj := GetMaterial4ProjFromTask(LTask);
      LoadMaterial4Project2Form(LMat4Proj, LTaskEditF);

      LTaskEditF.SelectMailBtn.Enabled := Assigned(ASQLEmailMsg);
      LTaskEditF.CancelMailSelectBtn.Enabled := Assigned(ASQLEmailMsg);

      if LTaskEditF.ShowModal = mrOK then
      begin
        LoadTaskForm2Var(LTaskEditF, LTask);

        //IPC를 통해서  Email을 수신한 경우
        if Assigned(ASQLEmailMsg) then
        begin
          //대표 메일을 선택한 경우
          if Assigned(LTaskEditF.FTask) then
          begin
            LTask := LTaskEditF.FTask;
          end;

          g_ProjectDB.Add(ASQLEmailMsg, true);

          if not LTask.IsUpdate then
          begin
            LID := g_ProjectDB.Add(LTask, true);
            ShowMessage('Task 및 Email Add 완료');
          end;

          LTask.EmailMsg.ManyAdd(g_ProjectDB, LTask.ID, ASQLEmailMsg.ID, True)
        end
        else
        begin
          AddOrUpdateTask(LTask);
        end;

        if High(LTaskEditF.FSQLGSFiles.Files) >= 0 then
        begin
          g_FileDB.Delete(TSQLGSFile, LTaskEditF.FSQLGSFiles.ID);
          LTaskEditF.FSQLGSFiles.TaskID := LTask.ID;
          g_FileDB.Add(LTaskEditF.FSQLGSFiles, true);
        end
        else
          g_FileDB.Delete(TSQLGSFile, LTaskEditF.FSQLGSFiles.ID);

        LoadTaskForm2Customer(LTaskEditF, LCustomer, LTask.ID);
        LoadTaskForm2SubCon(LTaskEditF, LSubCon, LTask.ID);
        LoadTaskForm2Material4Project(LTaskEditF, LMat4Proj, LTask.ID);

        AddOrUpdateCustomer(LCustomer);
        AddOrUpdateSubCon(LSubCon);
        AddOrUpdateMaterial4Project(LMat4Proj);
      end;
    end;//with
  finally
    //대표 메일을 선택한 경우
//    if Assigned(LTaskEditF.FTask) then
//      ATask := nil;

    FreeAndNil(LCustomer);
    FreeAndNil(LSubCon);
    FreeAndNil(LMat4Proj);

    LTaskEditF.Free;
  end;
end;

procedure TDisplayTaskF.DisplayTaskInfo2Grid(AFrom, ATo: TDateTime; AQueryDate: TQueryDateType;
  AHullNo, AShipName, ACustomer, AProdType, ASubject: string;
  ACurWork, ABefAft, AWorkKind: integer; AQtnNo, AOrderNo: string);
var
  ConstArray: TConstArray;
  LWhere, LStr: string;
  LSQLGSTask: TSQLGSTask;
  LSQLCustomer: TSQLCustomer;
  LFrom, LTo: TTimeLog;
begin
  LWhere := '';
  ConstArray := CreateConstArray([]);
  try
    if AQueryDate <> qdtNull then
    begin
      if AFrom <= ATo then
      begin
        LFrom := TimeLogFromDateTime(AFrom);
        LTo := TimeLogFromDateTime(ATo);

        if AQueryDate <> qdtNull then
        begin
          AddConstArray(ConstArray, [LFrom, LTo]);
          LWhere := GetSqlWhereFromQueryDate(AQueryDate);
        end;
      end;
    end;

    if AHullNo <> '' then
    begin
      AddConstArray(ConstArray, ['%'+AHullNo+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'HullNo LIKE ? ';
    end;

    if AShipName <> '' then
    begin
      AddConstArray(ConstArray, ['%'+AShipName+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + ' ShipName LIKE ? ';
    end;

    if ACustomer <> '' then
    begin
      LSQLCustomer := TSQLCustomer.CreateAndFillPrepare(g_MasterDB,'CompanyName LIKE ?',['%'+ACustomer+'%']);
      LStr := '';
      try
        while LSQLCustomer.FillOne do
        begin
          AddConstArray(ConstArray, [LSQLCustomer.TaskID]);

          if LStr <> '' then
            LStr := LStr + ' or ';

          LStr := LStr + ' ID = ? ';
        end;
      finally
        if LStr <> '' then
        begin
          if LWhere <> '' then
            LWhere := LWhere + ' and ';
          LWhere :=  LWhere + '( ' + LStr + ')';
        end;

        FreeAndNil(LSQLCustomer);
      end;
    end;

    if ASubject <> '' then
    begin
      AddConstArray(ConstArray, ['%'+ASubject+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + ' WorkSummary LIKE ? ';
    end;

    if AProdType <> '' then
    begin
      AddConstArray(ConstArray, [AProdType]);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + ' ProductType = ? ';
    end;

    if ACurWork > 0 then
    begin
      if AWorkKind = 0 then //현재작업
      begin
        AddConstArray(ConstArray, [ACurWork]);
      end
      else if AWorkKind = 1 then
      begin
        AddConstArray(ConstArray, [ACurWork-1]);
      end;

      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + ' CurrentWorkStatus ';

      if (ABefAft = -1) or (ABefAft = 0) then
        LWhere := LWhere + '= ?'
      else
      if ABefAft = 1 then//이전
        LWhere := LWhere + '< ?'
      else
      if ABefAft = 2 then//이후
        LWhere := LWhere + '> ?';
    end;

    if AQtnNo <> '' then
    begin
      AddConstArray(ConstArray, ['%'+AQtnNo+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + ' QTN_No LIKE ? ';
    end;

    if AOrderNo <> '' then
    begin
      AddConstArray(ConstArray, ['%'+AOrderNo+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + ' Order_No LIKE ? ';
    end;

    if LWhere = '' then
    begin
      //완료되지 않은 모든 Task를 보여줌
      ACurWork := Ord(spFinal);
      AddConstArray(ConstArray, [ACurWork]);
      LWhere := 'CurrentWorkStatus <> ?';
//      ShowMessage('조회 조건을 선택하세요.');
//      exit;
    end;

    LSQLGSTask := TSQLGSTask.CreateAndFillPrepare(g_ProjectDB, Lwhere, ConstArray); //ConstArray

    try
      grid_Req.ClearRows;

      while LSQLGSTask.FillOne do
      begin
        grid_Req.BeginUpdate;
        try
          LoadTaskVar2Grid(LSQLGSTask, grid_Req);
        finally
          grid_Req.EndUpdate;
        end;
      end;
    finally
      LSQLGSTask.Free;
    end;
  finally
    FinalizeConstArray(ConstArray);
  end;
end;

procedure TDisplayTaskF.EmailButtonClick(Sender: TObject);
begin
  ShowEmailListFormFromData(grid_Req.SelectedRow);
end;

procedure TDisplayTaskF.ExecuteSearch(Key: Char);
begin
  if Key = Chr(VK_RETURN) then
    btn_SearchClick(nil);
end;

procedure TDisplayTaskF.ShowTaskFormFromData(AIDList: TIDList; ARow: integer);
var
  LTask: TSQLGSTask;
begin
  LTask:= CreateOrGetLoadTask(AIDList.fTaskId);
  try
    DisplayTaskInfo2EditForm(LTask);
    LoadTaskVar2Grid(LTask, grid_Req, ARow);
  finally
    if Assigned(LTask) then
      FreeAndNil(LTask);
  end;
end;

procedure TDisplayTaskF.ShowTaskFormFromData(ARow: integer);
var
  LIdList: TIDList;
begin
  if grid_Req.Row[ARow].Data <> nil then
  begin
    LIdList := TIDList(grid_Req.Row[ARow].Data);
    ShowTaskFormFromData(LIdList,ARow);
  end;
end;

procedure TDisplayTaskF.ShowTaskFormFromGrid(ARow: integer);
var
  LTaskEditF: TTaskEditF;
begin
  LTaskEditF := TTaskEditF.Create(nil);
  try
    with LTaskEditF do
    begin
      LoadGrid2TaskEditForm(grid_Req, ARow, LTaskEditF);

      if LTaskEditF.ShowModal = mrOK then
      begin
        LoadTaskEditForm2Grid(LTaskEditF, grid_Req, ARow);
      end;
    end;
  finally
    LTaskEditF.Free;
  end;
end;

procedure TDisplayTaskF.ShowTaskID1Click(Sender: TObject);
begin
  ShowTaskIDFromGrid;
end;

procedure TDisplayTaskF.ShowTaskIDFromGrid;
var
  LIdList: TIDList;
begin
  if grid_Req.SelectedRow = -1 then
    exit;

  if grid_Req.Row[grid_Req.SelectedRow].Data <> nil then
  begin
    LIdList := TIDList(grid_Req.Row[grid_Req.SelectedRow].Data);
    ShowMessage(IntToStr(LIdList.TaskId));
  end;
end;

procedure TDisplayTaskF.ShowTodoListFormFromData(ARow: integer);
var
  LTask: TSQLGSTask;
  LID : TID;
  i: integer;
begin
  if ARow = -1 then //Grid의 모든 Task에대한 TodoList 가져옴
  begin
    FToDoCollect.Clear;

    for i := 0 to grid_Req.RowCount - 1 do
    begin
      LID := GetTaskIdFromGrid(i);

      if LID = -1 then
        continue;

      LTask := CreateOrGetLoadTask(LID);
      try
        LoadToDoCollectFromTask(LTask, FToDoCollect);
      finally
        FreeAndNil(LTask);
      end;
    end;
  end
  else
  begin
    LID := GetTaskIdFromGrid(i);

    if LID = -1 then
      exit;

    LTask := CreateOrGetLoadTask(LID);
    try
      LoadToDoCollectFromTask(LTask, FToDoCollect);
    finally
      FreeAndNil(LTask);
    end;
  end;

  FToDoCollect.Sort(1);
  ShowToDoListFromCollect(FToDoCollect);
end;

procedure TDisplayTaskF.ShipNameEditKeyPress(Sender: TObject; var Key: Char);
begin
  ExecuteSearch(Key);
end;

procedure TDisplayTaskF.ShowEmailID1Click(Sender: TObject);
begin
  ShowEmailIDFromGrid;
end;

procedure TDisplayTaskF.ShowEmailIDFromGrid;
var
  LIdList: TIDList;
begin
  if grid_Req.SelectedRow = -1 then
    exit;

  if grid_Req.Row[grid_Req.SelectedRow].Data <> nil then
  begin
    LIdList := TIDList(grid_Req.Row[grid_Req.SelectedRow].Data);
    ShowMessage(IntToStr(LIdList.EmailId));
  end;
end;

procedure TDisplayTaskF.ShowEmailListFormFromData(ARow: integer);
var
  LTask: TSQLGSTask;
  LID : TID;
begin
  LID := GetTaskIdFromGrid(ARow);

  if LID = -1 then
    exit;

  LTask := CreateOrGetLoadTask(LID);
  try
    TTaskEditF.ShowEMailListFromTask(LTask);
  finally
    FreeAndNil(LTask);
  end;
end;

procedure TDisplayTaskF.ShowGSFileID1Click(Sender: TObject);
var
  LSQLGSFile: TSQLGSFile;
  LIdList: TIDList;
  LTask: TSQLGSTask;
  LStr: string;
begin
  if grid_Req.SelectedRow = -1 then
    exit;

  if grid_Req.Row[grid_Req.SelectedRow].Data <> nil then
  begin
    LIdList := TIDList(grid_Req.Row[grid_Req.SelectedRow].Data);
    LTask := GetLoadTask(LIdList.TaskId);
    LSQLGSFile := GetFilesFromTask(LTask);
    try
      while LSQLGSFile.FillOne do
      begin
        LStr := 'Task = ' + IntToStr(LTask.ID) + #13#10;
        LStr := LStr + 'GSFile = ' + IntToStr(LSQLGSFile.ID);
      end;
      ShowMessage(LStr);
    finally
      FreeAndNil(LSQLGSFile);
    end;
  end;
end;

end.
