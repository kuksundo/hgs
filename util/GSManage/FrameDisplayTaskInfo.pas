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
  Vcl.ExtCtrls, UnitMakeReport, UnitTodoList, UnitTodoCollect, FrmInqManageConfig,
  UnitIniConfigSetting;

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
    GetJsonValues1: TMenuItem;
    JvLabel9: TJvLabel;
    PONoEdit: TEdit;
    DisplayFinalCheck: TCheckBox;
    Button1: TButton;
    Mail1: TMenuItem;
    Create1: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
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
    procedure GetJsonValues1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure N16Click(Sender: TObject);
    procedure grid_ReqKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    procedure ExecuteSearch(Key: Char);

    //TaskTab의 tag에 TSalesProcess값을 지정함
    //마우스로 tab 선택 시 해당 Task만 보이기 위함
    procedure InitTaskTab;
    procedure InputValueClear;

    function GetSqlWhereFromQueryDate(AQueryDate: TQueryDateType): string;
    function GetTaskIdFromGrid(ARow: integer): TID;

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

    procedure ProcessPasteEvent(ATxt: string);
  public
    //메일을 이동시킬 폴더 리스트,
    //HGS Task/Send Folder Name 2 IPC 메뉴에 의해 OL으로 부터 수신함
    FFolderListFromOL: TStringList;
    FToDoCollect: TpjhToDoItemCollection;
    FSettings : TConfigSettings;
    FIniFileName: string;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure LoadConfigFromFile(AFileName: string = '');
    procedure LoadConfig2Form(AForm: TConfigF);
    procedure LoadConfigForm2Object(AForm: TConfigF);
    procedure SetConfig;
    procedure ApplyConfigChanged;
    function GetRecvEmailAddress(AMailType: integer): string;

    function GetTask: TSQLGSTask;
    procedure DisplayTaskInfo2EditForm(const ATaskID: integer); overload;
    procedure DisplayTaskInfo2Grid(AFrom,ATo: TDateTime; AQueryDate: TQueryDateType;
      AHullNo, AShipName, ACustomer, AProdType, ASubject: string; ACurWork,
      ABefAft, AWorkKind: integer; AQtnNo, AOrderNo, APoNo: string);
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

uses System.Rtti, UnitIPCModule, ClipBrd, System.RegularExpressions, UnitGSFileRecord;

{$R *.dfm}

procedure TDisplayTaskF.SubjectEditKeyPress(Sender: TObject; var Key: Char);
begin
  ExecuteSearch(Key);
end;

procedure TDisplayTaskF.CurWorkCBDropDown(Sender: TObject);
begin
  SalesProcess2Combo(CurWorkCB);
end;

procedure TDisplayTaskF.LoadConfig2Form(AForm: TConfigF);
begin
  FSettings.LoadConfig2Form(AForm, FSettings);
end;

procedure TDisplayTaskF.LoadConfigForm2Object(AForm: TConfigF);
begin
  FSettings.LoadConfigForm2Object(AForm, FSettings);
end;

procedure TDisplayTaskF.LoadConfigFromFile(AFileName: string);
begin
  FSettings.Load(AFileName);

  if FSettings.MQServerIP = '' then
    FSettings.MQServerIP := '127.0.0.1';
end;

procedure TDisplayTaskF.LoadTaskVar2Grid(AVar: TSQLGSTask; AGrid: TNextGrid;
  ARow: integer);
var
  LIds: TIDDynArray;
  LSQLEmailMsg: TSQLEmailMsg;
  LSubject: string;
  LStrList: TStringList;
  LFSMState: TFSMState;
  LMailCount: integer;
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
    LMailCount := 0;
    LSubject := '';

    while LSQLEmailMsg.FillOne do
    begin
      if (LSubject = '') and (LSQLEmailMsg.ParentID = '') then
      begin
        LSubject := LSQLEmailMsg.Subject;
//        break;
      end;

      Inc(LMailCount);
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
      CellByName['ReqCustomer', ARow].AsString := ShipOwner;
      CellByName['Status', ARow].AsString := SalesProcess2String(
        TSalesProcess(CurrentWorkStatus));
      CellByName['Email', ARow].AsInteger := LMailCount;

      if NextWork > 0 then
      begin
        CellByName['NextProcess', ARow].AsString := SalesProcess2String(
          TSalesProcess(NextWork));
      end
      else
      begin
        LFSMState := g_FSMClass.GetState(Ord(SalesProcessType));
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

procedure TDisplayTaskF.N11Click(Sender: TObject);
var
  LTask: TSQLGSTask;
begin
  LTask := GetTask;
  try
    SendCmd2IPC4CreateMail(nil, 0, TMenuItem(Sender).Tag, LTask,
      FSettings,
      GetRecvEmailAddress(TMenuItem(Sender).Tag));
  finally
    FreeAndNil(LTask);
  end;
end;

procedure TDisplayTaskF.N12Click(Sender: TObject);
var
  LTask: TSQLGSTask;
begin
  LTask := GetTask;
  try
    SendCmd2IPC4CreateMail(nil, 0, TMenuItem(Sender).Tag, LTask,
      FSettings,
      GetRecvEmailAddress(TMenuItem(Sender).Tag));
  finally
    FreeAndNil(LTask);
  end;
end;

procedure TDisplayTaskF.N13Click(Sender: TObject);
var
  LTask: TSQLGSTask;
begin
  LTask := GetTask;
  try
      SendCmd2IPC4CreateMail(nil, 0, TMenuItem(Sender).Tag, LTask,
      FSettings,
      GetRecvEmailAddress(TMenuItem(Sender).Tag));
  finally
    FreeAndNil(LTask);
  end;
end;

procedure TDisplayTaskF.N14Click(Sender: TObject);
var
  LTask: TSQLGSTask;
begin
  LTask := GetTask;
  try
      SendCmd2IPC4CreateMail(nil, 0, TMenuItem(Sender).Tag, LTask,
      FSettings,
      GetRecvEmailAddress(TMenuItem(Sender).Tag));
  finally
    FreeAndNil(LTask);
  end;
end;

procedure TDisplayTaskF.N15Click(Sender: TObject);
var
  LTask: TSQLGSTask;
begin
  LTask := GetTask;
  try
    SendCmd2IPC4CreateMail(nil, 0, TMenuItem(Sender).Tag, LTask,
      FSettings,
      GetRecvEmailAddress(TMenuItem(Sender).Tag));
  finally
    FreeAndNil(LTask);
  end;
end;

procedure TDisplayTaskF.N16Click(Sender: TObject);
var
  LTask: TSQLGSTask;
begin
  LTask := GetTask;
  try
    SendCmd2IPC4CreateMail(nil, 0, TMenuItem(Sender).Tag, LTask,
      FSettings,
      GetRecvEmailAddress(TMenuItem(Sender).Tag));
  finally
    FreeAndNil(LTask);
  end;
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

procedure TDisplayTaskF.ProcessPasteEvent(ATxt: string);
var
  LStr: string;
  LRegexpr: TRegEx;
  LMatch: TMatch;
  LGroup: TGroup;
begin
  LStr := System.SysUtils.Trim(ATxt);

  LRegexpr := TRegEx.Create(REGEX_HULLNO_PATTERN, [roIgnoreCase]);
  LMatch := LRegexpr.Match(LStr);

  if LMatch.Success then
  begin
    InputValueClear;
    HullNoEdit.Text := LStr;
  end
  else
  begin
    LRegexpr := TRegEx.Create(REGEX_ORDERNO_PATTERN, [roIgnoreCase]);
    LMatch := LRegexpr.Match(LStr);

    if LMatch.Success then
    begin
      InputValueClear;
      OrderNoEdit.Text := LStr;
    end
    else
    begin
      LRegexpr := TRegEx.Create(REGEX_SHIPNAME_PATTERN, [roIgnoreCase]);
      LMatch := LRegexpr.Match(LStr);

      if LMatch.Success then
      begin
        InputValueClear;
        ShipNameEdit.Text := LStr;
      end;
    end;
  end;
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

procedure TDisplayTaskF.GetJsonValues1Click(Sender: TObject);
var
  LTask: TSQLGSTask;
  LUtf8: RawUTF8;
  LDynArr: TDynArray;
  LCount: integer;
  LCustomer: TSQLCustomer;
  LSubCon: TSQLSubCon;
  LMat4Proj: TSQLMaterial4Project;
  LV,LV2,LV3: variant;
begin
  TDocVariant.New(LV);

  LTask := GetTask;
  try
    LUtf8 := LTask.GetJSONValues(true, true, soSelect);
    LV.Task := _JSON(LUtf8);

    LCustomer := GetCustomerFromTask(LTask);
    LUtf8 := LCustomer.GetJSONValues(true, true, soSelect);
    LV.Customer := _JSON(LUtf8);;

    LSubCon := GetSubConFromTask(LTask);
    LUtf8 := LSubCon.GetJSONValues(true, true, soSelect);
    LV.SubCon := _JSON(LUtf8);;

    LMat4Proj := GetMaterial4ProjFromTask(LTask);
    LUtf8 := LMat4Proj.GetJSONValues(true, true, soSelect);
    LV.Mat4Proj := _JSON(LUtf8);

    LUtf8 := VariantSaveJSON(LV);

    TDocVariant.New(LV3);
    LV3 := _JSON(LUtf8);

    TDocVariant.New(LV2);
    LV2 := _JSON(LV3.Task);
//    ShowMessage(LV2.ShipName);
//    Memo1.Text := Utf8ToString(LV3.Task);
  finally
    FreeAndNil(LCustomer);
    FreeAndNil(LSubCon);
    FreeAndNil(LMat4Proj);
    LTask.Free;
  end;
end;

function TDisplayTaskF.GetRecvEmailAddress(AMailType: integer): string;
begin
  case AMailType of
    1: Result := '';//Invoice 송부
    2: Result := FSettings.SalesDirectorEmailAddr;// SALES_DIRECTOR_EMAIL_ADDR;//매출처리요청
    3: Result := FSettings.MaterialInputEmailAddr;// MATERIAL_INPUT_EMAIL_ADDR;//자재직투입요청
    4: Result := FSettings.ForeignInputEmailAddr;// FOREIGN_INPUT_EMAIL_ADDR;//해외고객업체등록
    5: Result := FSettings.ElecHullRegEmailAddr;// ELEC_HULL_REG_EMAIL_ADDR;//전전비표준공사 생성 요청
    6: Result := PO_REQ_EMAIL_ADDR; //PO 요청
    7: Result := FSettings.ShippingReqEmailAddr;// SHIPPING_REQ_EMAIL_ADDR; //출하 요청
    8: Result := FSettings.FieldServiceReqEmailAddr;// FIELDSERVICE_REQ_EMAIL_ADDR; //필드서비스팀 요청
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

function TDisplayTaskF.GetTask: TSQLGSTask;
var
  LTaskID: TID;
begin
  LTaskID := GetTaskIdFromGrid(grid_Req.SelectedRow);
  Result := GetLoadTask(LTaskID);
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

procedure TDisplayTaskF.grid_ReqKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) and ((Key = Ord('V')) or (Key = Ord('v'))  ) then
    ProcessPasteEvent(ClipBoard.AsText);
//    ShowMessage(ClipBoard.AsText);
end;

procedure TDisplayTaskF.HullNoEditKeyPress(Sender: TObject; var Key: Char);
begin
  ExecuteSearch(Key);
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

procedure TDisplayTaskF.InputValueClear;
begin
  HullNoEdit.Text := '';
  ShipNameEdit.Text := '';
  CustomerCombo.Text := '';
  PONoEdit.Text := '';
  QtnNoEdit.Text := '';
  SubjectEdit.Text := '';
  OrderNoEdit.Text := '';
  ComboBox1.ItemIndex := -1;
  ProductTypeCombo.ItemIndex := -1;
  CurWorkCB.ItemIndex := -1;
  BefAftCB.ItemIndex := -1;
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
    TaskForm.DisplayTaskInfo2EditForm(LTask,nil,null);
  finally
    FreeAndNil(LTask);
  end;
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

procedure TDisplayTaskF.AeroButton1Click(Sender: TObject);
begin
  ShowTodoListFormFromData(-1);
end;

procedure TDisplayTaskF.ApplyConfigChanged;
begin
  LoadConfigFromFile;
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
    BefAftCB.ItemIndex, WorkKindCB.ItemIndex, QtnNoEdit.Text, OrderNoEdit.Text,
    PONoEdit.Text);
end;

procedure TDisplayTaskF.Button1Click(Sender: TObject);
begin
  InputValueClear;
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
  DOC_DIR := ExtractFilePath(Application.ExeName) + '양식\';
  FFolderListFromOL := TStringList.Create;
  if FileExists('.\'+FOLDER_LIST_FILE_NAME) then
    FFolderListFromOL.LoadFromFile('.\'+FOLDER_LIST_FILE_NAME);
  FToDoCollect := TpjhToDoItemCollection.Create(TpjhTodoItem);
  InitTaskTab;
  ComboBox1DropDown(nil);
//  ComboBox1.ItemIndex := 1;
  if FIniFileName = '' then
    FIniFileName := ChangeFileExt(Application.ExeName, '.ini');

  FSettings := TConfigSettings.create(FIniFileName);
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

destructor TDisplayTaskF.Destroy;
begin
  FSettings.Free;
  FreeAndNil(FToDoCollect);
  FFolderListFromOL.Free;

  inherited;
end;

procedure TDisplayTaskF.DisplayTaskInfo2Grid(AFrom, ATo: TDateTime; AQueryDate: TQueryDateType;
  AHullNo, AShipName, ACustomer, AProdType, ASubject: string;
  ACurWork, ABefAft, AWorkKind: integer; AQtnNo, AOrderNo, APoNo: string);
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
//      LSQLCustomer := TSQLCustomer.CreateAndFillPrepare(g_MasterDB,'CompanyName LIKE ?',['%'+ACustomer+'%']);
//      LStr := '';
//      try
//        while LSQLCustomer.FillOne do
//        begin
//          AddConstArray(ConstArray, [LSQLCustomer.TaskID]);
//
//          if LStr <> '' then
//            LStr := LStr + ' or ';
//
//          LStr := LStr + ' ID = ? ';
//        end;
//      finally
//        if LStr <> '' then
//        begin
//          if LWhere <> '' then
//            LWhere := LWhere + ' and ';
//          LWhere :=  LWhere + '( ' + LStr + ')';
//        end;
//
//        FreeAndNil(LSQLCustomer);
//      end;
      AddConstArray(ConstArray, ['%'+ACustomer+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + ' ShipOwner LIKE ? ';
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

    if APoNo <> '' then
    begin
      AddConstArray(ConstArray, ['%'+APoNo+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + ' PO_No LIKE ? ';
    end;

    ACurWork := Ord(spFinal);
    //완료되지 않은 모든 Task를 보여줌
    AddConstArray(ConstArray, [ACurWork]);

    if LWhere <> '' then
      LWhere := LWhere + ' and ';

    if not DisplayFinalCheck.Checked then
    begin
      LWhere := LWhere + 'CurrentWorkStatus <> ?';
    end
    else
    begin
      LWhere := LWhere + 'CurrentWorkStatus <= ?';
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
    TaskForm.DisplayTaskInfo2EditForm(LTask,nil,null);
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

procedure TDisplayTaskF.SetConfig;
var
  LConfigF: TConfigF;
  LParamFileName: string;
begin
  LConfigF := TConfigF.Create(Self);

  try
    LParamFileName := FSettings.ParamFileName;
    LoadConfig2Form(LConfigF);

    if LConfigF.ShowModal = mrOK then
    begin
      LoadConfigForm2Object(LConfigF);
      FSettings.Save();

//      FParamFileNameChanged := (LParamFileName <> FSettings.ParamFileName) and
//        (FileExists(FSettings.ParamFileName));
//      ApplyUI;
      ApplyConfigChanged;
    end;
  finally
    LConfigF.Free;
  end;
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
