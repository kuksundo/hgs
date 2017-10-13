unit TaskForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, ShellApi,
  JvExControls, JvLabel, NxColumnClasses, NxColumns, NxScrollControl, ActiveX,
  NxCustomGridControl, NxCustomGrid, NxGrid, AeroButtons, CurvyControls,
  CommonData, UElecDataRecord, Vcl.ImgList, AdvGlowButton, Vcl.ExtCtrls,
  FrmFileSelect, mORMot, SynCommons, UViewMailList, Vcl.Menus, FSMState,
  DragDropFile, Clipbrd,
  DragDrop, DropTarget, UnitMakeReport, DropSource, Vcl.Mask, JvExMask,
  JvToolEdit, JvBaseEdits, FSMClass_Dic, pjhComboBox, UnitTodoCollect, AdvEdit,
  AdvEdBtn;

type
  TTaskEditF = class(TForm)
    HullNoEdit: TEdit;
    ShipNameEdit: TEdit;
    PONoEdit: TEdit;
    QTNNoEdit: TEdit;
    OrderNoEdit: TEdit;
    QTNInputPicker: TDateTimePicker;
    OrderInputPicker: TDateTimePicker;
    InvoiceIssuePicker: TDateTimePicker;
    InqRecvPicker: TDateTimePicker;
    ProductTypeCB: TComboBox;
    JvLabel3: TJvLabel;
    JvLabel4: TJvLabel;
    JvLabel1: TJvLabel;
    JvLabel10: TJvLabel;
    JvLabel5: TJvLabel;
    JvLabel6: TJvLabel;
    JvLabel7: TJvLabel;
    JvLabel8: TJvLabel;
    JvLabel9: TJvLabel;
    JvLabel11: TJvLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    CustomerAddressMemo: TMemo;
    CurvyPanel1: TCurvyPanel;
    JvLabel14: TJvLabel;
    btn_Close: TAeroButton;
    AeroButton1: TAeroButton;
    SelectMailBtn: TAeroButton;
    CancelMailSelectBtn: TAeroButton;
    ImageList16x16: TImageList;
    AeroButton4: TAeroButton;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    Quotation1: TMenuItem;
    PO1: TMenuItem;
    Invoice1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    TabSheet2: TTabSheet;
    JvLabel15: TJvLabel;
    JvLabel16: TJvLabel;
    SubCompanyCodeEdit: TEdit;
    JvLabel17: TJvLabel;
    SubManagerEdit: TEdit;
    SubCompanyAddressMemo: TMemo;
    JvLabel18: TJvLabel;
    JvLabel19: TJvLabel;
    SEEdit: TEdit;
    TabSheet3: TTabSheet;
    JvLabel13: TJvLabel;
    Panel3: TPanel;
    Panel2: TPanel;
    AdvGlowButton6: TAdvGlowButton;
    AdvGlowButton5: TAdvGlowButton;
    fileGrid: TNextGrid;
    NxIncrementColumn3: TNxIncrementColumn;
    FileName: TNxTextColumn;
    FileSize: TNxTextColumn;
    FilePath: TNxTextColumn;
    DocType: TNxTextColumn;
    JvLabel12: TJvLabel;
    TabSheet4: TTabSheet;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    JvLabel20: TJvLabel;
    JvLabel21: TJvLabel;
    CustCompanyCodeEdit: TEdit;
    JvLabel22: TJvLabel;
    CustManagerEdit: TEdit;
    JvLabel23: TJvLabel;
    SubEmailEdit: TEdit;
    JvLabel24: TJvLabel;
    CustEmailEdit: TEdit;
    JvLabel25: TJvLabel;
    PORNoEdit: TEdit;
    JvLabel26: TJvLabel;
    MaterialCodeListMemo: TMemo;
    JvLabel27: TJvLabel;
    DeliveryAddressMemo: TMemo;
    JvLabel28: TJvLabel;
    AWBEdit: TEdit;
    JvLabel29: TJvLabel;
    PORIssuePicker: TDateTimePicker;
    JvLabel2: TJvLabel;
    AttendSchedulePicker: TDateTimePicker;
    JvLabel31: TJvLabel;
    WorkSummaryEdit: TEdit;
    TabSheet5: TTabSheet;
    JvLabel30: TJvLabel;
    NationPortEdit: TEdit;
    JvLabel32: TJvLabel;
    DeliveryCompanyEdit: TEdit;
    JvLabel33: TJvLabel;
    DeliveryChargeEdit: TEdit;
    CustAgentMemo: TMemo;
    JvLabel34: TJvLabel;
    Label1: TLabel;
    JvLabel35: TJvLabel;
    SECountEdit: TEdit;
    JvLabel36: TJvLabel;
    WorkBeginPicker: TDateTimePicker;
    JvLabel37: TJvLabel;
    WorkEndPicker: TDateTimePicker;
    Label2: TLabel;
    JvLabel38: TJvLabel;
    EtcContentMemo: TMemo;
    JvLabel39: TJvLabel;
    CurWorkCB: TComboBox;
    JvLabel40: TJvLabel;
    SalesProcTypeCB: TComboBox;
    JvLabel41: TJvLabel;
    CustCompanyTypeCB: TComboBox;
    JvLabel42: TJvLabel;
    SubPhonNumEdit: TEdit;
    JvLabel43: TJvLabel;
    SubFaxEdit: TEdit;
    JvLabel44: TJvLabel;
    CustPhonNumEdit: TEdit;
    JvLabel45: TJvLabel;
    CustFaxEdit: TEdit;
    JvLabel46: TJvLabel;
    PositionEdit: TEdit;
    CustPositionEdit: TEdit;
    JvLabel47: TJvLabel;
    DropEmptyTarget1: TDropEmptyTarget;
    DataFormatAdapterTarget: TDataFormatAdapter;
    DataFormatAdapter1: TDataFormatAdapter;
    Imglist16x16: TImageList;
    ServiceOrder1: TMenuItem;
    oCustomer1: TMenuItem;
    Korean1: TMenuItem;
    English1: TMenuItem;
    Korean2: TMenuItem;
    English2: TMenuItem;
    Korean3: TMenuItem;
    N14: TMenuItem;
    Commercial1: TMenuItem;
    N15: TMenuItem;
    JvLabel48: TJvLabel;
    ServicePOEdit: TEdit;
    ShipOwnerEdit: TEdit;
    JvLabel49: TJvLabel;
    JvLabel50: TJvLabel;
    QtnIssuePicker: TDateTimePicker;
    JvLabel51: TJvLabel;
    CurWorkFinishPicker: TDateTimePicker;
    JvLabel52: TJvLabel;
    SubConInvoiceIssuePicker: TDateTimePicker;
    JvLabel53: TJvLabel;
    SRRecvDatePicker: TDateTimePicker;
    DataFormatAdapter2: TDataFormatAdapter;
    DropEmptySource1: TDropEmptySource;
    JvLabel54: TJvLabel;
    SubConPriceEdit: TEdit;
    JvLabel55: TJvLabel;
    NationEdit: TEdit;
    JvLabel57: TJvLabel;
    ShippingNoEdit: TEdit;
    TabSheet6: TTabSheet;
    JvLabel56: TJvLabel;
    SalesReqPicker: TDateTimePicker;
    JvLabel58: TJvLabel;
    ShippingDatePicker: TDateTimePicker;
    JvLabel59: TJvLabel;
    JvLabel60: TJvLabel;
    ExchangeRateEdit: TEdit;
    JvLabel61: TJvLabel;
    CurrencyKindCB: TComboBox;
    N16: TMenuItem;
    SalesPriceEdit: TJvCalcEdit;
    JvLabel62: TJvLabel;
    NextWorkCB: TComboBox;
    Button1: TButton;
    Button2: TButton;
    CustomerNameCB: TComboBoxInc;
    Button3: TButton;
    MAPS1: TMenuItem;
    INQInput1: TMenuItem;
    Mail1: TMenuItem;
    Reply1: TMenuItem;
    N17: TMenuItem;
    JvLabel63: TJvLabel;
    DeliveryConditionCB: TComboBox;
    JvLabel64: TJvLabel;
    EstimateTypeCB: TComboBox;
    JvLabel65: TJvLabel;
    TermsPaymentCB: TComboBox;
    JvLabel66: TJvLabel;
    BaseProjectNoEdit: TEdit;
    SubCompanyEdit: TAdvEditBtn;
    JvLabel67: TJvLabel;
    ChargeInPersonIdEdit: TEdit;
    Create1: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    N22: TMenuItem;
    PO2: TMenuItem;
    Invoice2: TMenuItem;
    Button4: TButton;
    JvLabel68: TJvLabel;
    SubConNationEdit: TEdit;
    procedure AeroButton1Click(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SelectMailBtnClick(Sender: TObject);
    procedure CancelMailSelectBtnClick(Sender: TObject);
    procedure fileGridCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure AdvGlowButton5Click(Sender: TObject);
    procedure AeroButton4Click(Sender: TObject);
    procedure CurWorkCBDropDown(Sender: TObject);
    procedure ProductTypeCBDropDown(Sender: TObject);
    procedure SalesProcTypeCBDropDown(Sender: TObject);
    procedure AdvGlowButton6Click(Sender: TObject);
    procedure DropEmptyTarget1Drop(Sender: TObject; ShiftState: TShiftState;
      APoint: TPoint; var Effect: Integer);
    procedure oCustomer1Click(Sender: TObject);
    procedure English2Click(Sender: TObject);
    procedure ServiceOrder1Click(Sender: TObject);
    procedure fileGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure INQInput1Click(Sender: TObject);
    procedure N18Click(Sender: TObject);
    procedure N19Click(Sender: TObject);
    procedure N20Click(Sender: TObject);
    procedure N21Click(Sender: TObject);
    procedure N22Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure SubCompanyEditClickBtn(Sender: TObject);
  private
    function GetFileFromDropDataFormat(AFormat: TVirtualFileStreamDataFormat): TFileStream;

    function Get_Doc_Qtn_Rec: Doc_Qtn_Rec;
    function Get_Doc_Inv_Rec: Doc_Invoice_Rec;
    function Get_Doc_ServiceOrder_Rec: Doc_ServiceOrder_Rec;
    function Get_Doc_Cust_Reg_Rec: Doc_Cust_Reg_Rec;

    //MAPS->QUOTATION관리->INQ.내용에 들어갈 내용을 Clipboard로 복사함
    procedure Content2Clipboard(AContent: string);
    function GetQTN_InqContent: string;

    function CheckDocCompanySelection(ASOR: Doc_ServiceOrder_Rec): boolean;

    procedure OnGetStream(Sender: TFileContentsStreamOnDemandClipboardFormat;
      Index: integer; out AStream: IStream);

    procedure SQLGSFileRec2Grid(ARec: TSQLGSFileRec; AGrid: TNextGrid);
    procedure SQLGSFileCopy(ASrc: TSQLGSFile; out ADest: TSQLGSFile);

    procedure SaveCustomer2MasterCustomer(AMCustomer: TSQLMasterCustomer);
    procedure SaveCustEdit2MasterCustomer;
    procedure SaveSubContractEdit2MasterSubContract(AMCustomer: TSQLMasterCustomer);
    procedure SaveSubConEdit2MasterCustomer;
  public
    FTask,
    FEmailDisplayTask: TSQLGSTask;
    FSQLGSFiles: TSQLGSFile;
    FFSMState: TFSMState;
    FOLMessagesFromDrop,
    //현재 Task의 작업순서 List
    FSalesProcessList: TStringList;
    FFileContent: RawByteString;
    FToDoCollect: TpjhToDoItemCollection;

    class procedure ShowEMailListFromTask(ATask: TSQLGSTask);
    class procedure LoadEmailListFromTask(ATask: TSQLGSTask; AForm:TViewMailListF);
    procedure ShowDTIForm;
    procedure SPType2Combo(ACombo: TComboBox; AFSMState: TFSMState=nil);
    //Drag하여 파일 추가한 경우 AFileName <> ''
    //Drag를 윈도우 탐색기에서 하면 AFromOutLook=Fase,
    //Outlook 첨부 파일에서 하면 AFromOutLook=True임
    procedure ShowFileSelectF(AFileName: string = ''; AFromOutLook: Boolean = False);
    procedure LoadCustomerFromCompanycode(ACompanyCode: string);
//    procedure LoadCustomer2

    procedure LoadTaskVar2Form(AVar: TSQLGSTask; AForm: TTaskEditF; AFSMClass: TFSMClass);
    procedure LoadTaskForm2Var(AForm: TTaskEditF; out AVar: TSQLGSTask);
    procedure LoadTaskEditForm2Grid(AEditForm: TTaskEditF; AGrid: TNextGrid;
      ARow: integer);
    procedure LoadGrid2TaskEditForm(AGrid: TNextGrid; ARow: integer;
      AEditForm: TTaskEditF);

    procedure LoadGSFiles2Form(AGSFile: TSQLGSFile; AForm: TTaskEditF);
    procedure LoadTaskForm2GSFiles(AForm: TTaskEditF; out AGSFile: TSQLGSFile);
    procedure LoadCustomer2Form(ACustomer: TSQLCustomer; AForm: TTaskEditF);
    procedure LoadTaskForm2Customer(AForm: TTaskEditF; ACustomer: TSQLCustomer;
      ATaskID: TID = 0);
    procedure LoadTaskForm2MasterCustomer(AForm: TTaskEditF; var ACustomer: TSQLMasterCustomer;
      ATaskID: TID);
    procedure LoadTaskForm2MasterSubContractor(AForm: TTaskEditF; var ACustomer: TSQLMasterCustomer;
      ATaskID: TID);
    procedure LoadSubCon2Form(ASubCon: TSQLSubCon; AForm: TTaskEditF);
    procedure LoadTaskForm2SubCon(AForm: TTaskEditF; ASubCon: TSQLSubCon;
      ATaskID: TID = 0);
    procedure LoadMaterial4Project2Form(AMaterial: TSQLMaterial4Project; AForm: TTaskEditF);
    procedure LoadTaskForm2Material4Project(AForm: TTaskEditF;
      AMaterial: TSQLMaterial4Project; ATaskID: TID = 0);
  end;

    function DisplayTaskInfo2EditForm(var ATask: TSQLGSTask;
      ASQLEmailMsg: TSQLEmailMsg; ADoc: variant): Boolean; overload;

var
  TaskEditF: TTaskEditF;

implementation

uses FrmInqManage, FrmDisplayTaskInfo, DragDropInternet, DragDropFormats,
  UnitIPCModule, UnitTodoList, FrmSearchCustomer, UnitDragUtil, UnitStringUtil;

{$R *.dfm}

function DisplayTaskInfo2EditForm(var ATask: TSQLGSTask;
  ASQLEmailMsg: TSQLEmailMsg; ADoc: variant): Boolean;
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
      if ATask.IsUpdate then
        Caption := Caption + ' (Update)'
      else
        Caption := Caption + ' (New)';

      LTaskEditF.FEmailDisplayTask := ATask;
      if ADoc <> null then
        LoadTaskFromVariant(ATask, ADoc.Task);
      LoadTaskVar2Form(LTask, LTaskEditF, g_FSMClass);
      LCustomer := GetCustomerFromTask(LTask);
      if ADoc <> null then
        LoadCustomerFromVariant(LCustomer, ADoc.Customer);
      LoadCustomer2Form(LCustomer, LTaskEditF);
      LSubCon := GetSubConFromTask(LTask);
      if ADoc <> null then
        LoadSubConFromVariant(LSubCon, ADoc.SubCon);
      LoadSubCon2Form(LSubCon, LTaskEditF);
      LMat4Proj := GetMaterial4ProjFromTask(LTask);
      if ADoc <> null then
        LoadMaterial4ProjectFromVariant(LMat4Proj, ADoc.Material4Project);
      LoadMaterial4Project2Form(LMat4Proj, LTaskEditF);

      LTaskEditF.SelectMailBtn.Enabled := Assigned(ASQLEmailMsg);
      LTaskEditF.CancelMailSelectBtn.Enabled := Assigned(ASQLEmailMsg);

      if LTaskEditF.ShowModal = mrOK then
      begin
        Result := True;
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

    FreeAndNil(LTaskEditF);
  end;
end;

procedure TTaskEditF.AdvGlowButton5Click(Sender: TObject);
var
  li : integer;
begin
  with fileGrid do
  begin
    if SelectedRow > -1 then
    begin
      if not(CellByName['FileName',SelectedRow].AsString = '') then
      begin
        if Assigned(FSQLGSFiles) then
          FSQLGSFiles.DynArray('Files').Delete(SelectedRow);
        DeleteRow(SelectedRow);
      end;
    end;

    SelectedRow := -1;
  end;
end;

procedure TTaskEditF.AdvGlowButton6Click(Sender: TObject);
begin
  ShowFileSelectF;
end;

procedure TTaskEditF.AeroButton1Click(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TTaskEditF.AeroButton4Click(Sender: TObject);
begin
  ShowEMailListFromTask(FEmailDisplayTask);
end;

procedure TTaskEditF.SalesProcTypeCBDropDown(Sender: TObject);
begin
  SalesProcessType2Combo(SalesProcTypeCB);
end;

procedure TTaskEditF.SaveCustEdit2MasterCustomer;
var
  LCustomer: TSQLMasterCustomer;
begin
  LCustomer := GetMasterCustomerFromCompanyCodeNName(CustCompanyCodeEdit.Text, CustomerNameCB.Text);
  try
    SaveCustomer2MasterCustomer(LCustomer);
  finally
    FreeAndNil(LCustomer);
  end;
end;

procedure TTaskEditF.SaveCustomer2MasterCustomer(
  AMCustomer: TSQLMasterCustomer);
begin
  if AMCustomer.IsUpdate then
  begin
    if MessageDlg('고객 정보가 이미 MasterDB에 존재합니다.' + #13#10 + '새로운 정보로 Update 하시겠습니까?', mtConfirmation, [mbYes, mbNo],0) = mrYes then
      g_MasterDB.Update(AMCustomer);
  end
  else
  begin
//    AMCustomer.CompanyCode :=
    LoadTaskForm2MasterCustomer(Self,AMCustomer, Self.FTask.ID);
    g_MasterDB.Add(AMCustomer, true);
  end;
end;

procedure TTaskEditF.SaveSubConEdit2MasterCustomer;
var
  LCustomer: TSQLMasterCustomer;
begin
  LCustomer := GetMasterCustomerFromCompanyCodeNName(SubCompanyCodeEdit.Text, SubCompanyEdit.Text);
  try
    SaveSubContractEdit2MasterSubContract(LCustomer);
  finally
    FreeAndNil(LCustomer);
  end;
end;

procedure TTaskEditF.SaveSubContractEdit2MasterSubContract(AMCustomer: TSQLMasterCustomer);
begin
  if AMCustomer.IsUpdate then
  begin
    if MessageDlg('협력사 정보가 이미 MasterDB에 존재합니다.' + #13#10 + '새로운 정보로 Update 하시겠습니까?', mtConfirmation, [mbYes, mbNo],0) = mrYes then
      g_MasterDB.Update(AMCustomer);
  end
  else
  begin
    LoadTaskForm2MasterSubContractor(Self,AMCustomer, Self.FTask.ID);
    g_MasterDB.Add(AMCustomer, true);
  end;
end;

procedure TTaskEditF.SelectMailBtnClick(Sender: TObject);
begin
  ShowDTIForm;
end;

procedure TTaskEditF.ServiceOrder1Click(Sender: TObject);
var
  LRec: Doc_ServiceOrder_Rec;
begin
  LRec := Get_Doc_ServiceOrder_Rec;
  MakeDocServiceOrder(LRec);
end;

procedure TTaskEditF.CancelMailSelectBtnClick(Sender: TObject);
begin
  if Assigned(FTask) then
    FreeAndNil(FTask);
end;

function TTaskEditF.CheckDocCompanySelection(ASOR: Doc_ServiceOrder_Rec):Boolean;
begin
  Result := True;

  if ASOR.FSubConName = '' then
  begin
    ShowMessage('협력사 이름이 없습니다.');
    SubCompanyEdit.Color := clRed;
    SubCompanyEdit.SetFocus;
    Result := False;
  end;
end;

procedure TTaskEditF.Content2Clipboard(AContent: string);
begin
  Clipboard.AsText := AContent;
end;

procedure TTaskEditF.CurWorkCBDropDown(Sender: TObject);
begin
//  CurWorkCB.Clear;
//  SalesProcessType2Combo(CurWorkCB);
//  SPType2Combo(CurWorkCB);
end;

procedure TTaskEditF.DropEmptyTarget1Drop(Sender: TObject;
  ShiftState: TShiftState; APoint: TPoint; var Effect: Integer);
var
  i: integer;
  LFileName: string;
  LFromOutlook: Boolean;
  LTargetStream: TStream;
begin
  LFileName := '';
  // 윈도우 탐색기에서 Drag 했을 경우
  if (DataFormatAdapter1.DataFormat <> nil) then
  begin
    LFileName := (DataFormatAdapter1.DataFormat as TFileDataFormat).Files.Text;

    if LFileName <> '' then
    begin
      FFileContent := StringFromFile(LFileName);
//      LFromOutlook := False;
    end;
  end;

  // OutLook에서 첨부파일을 Drag 했을 경우
  if (TVirtualFileStreamDataFormat(DataFormatAdapterTarget.DataFormat).FileNames.Count > 0) then
  begin
    LFileName := TVirtualFileStreamDataFormat(DataFormatAdapterTarget.DataFormat).FileNames[0];
    LTargetStream := GetStreamFromDropDataFormat(TVirtualFileStreamDataFormat(DataFormatAdapterTarget.DataFormat));
    try
      if not Assigned(LTargetStream) then
        ShowMessage('Not Assigned');

      FFileContent := StreamToRawByteString(LTargetStream);
      LFromOutlook := True;
    finally
      if Assigned(LTargetStream) then
        LTargetStream.Free;
    end;
  end;

  if LFileName <> '' then
  begin
    LFileName.Replace('"','');
    ShowFileSelectF(LFileName, LFromOutlook);
  end;
end;

procedure TTaskEditF.English2Click(Sender: TObject);
var
  LRec: Doc_Invoice_Rec;
begin
  LRec := Get_Doc_Inv_Rec;
  MakeDocInvoice(LRec);
end;

procedure TTaskEditF.btn_CloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TTaskEditF.Button1Click(Sender: TObject);
begin
  if (CustomerNameCB.Text = '') or (CustCompanyCodeEdit.Text = '') then
  begin
    ShowMessage('회사이름 과 업체코드는 필수 입력 항목 입니다.');
    exit;
  end;

  if MessageDlg('Are you sure save to MasterCustomerDB?', mtConfirmation, [mbYes, mbNo],0) = mrYes then
    SaveCustEdit2MasterCustomer;
end;

procedure TTaskEditF.Button2Click(Sender: TObject);
var
  LSearchCustomerF: TSearchCustomerF;
begin
  LSearchCustomerF := TSearchCustomerF.Create(nil);
  try
    with LSearchCustomerF do
    begin
      FCompanyType := ctNull;

      if ShowModal = mrOk then
      begin
        if NextGrid1.SelectedRow <> -1 then
        begin
          CustomerNameCB.Text := NextGrid1.CellByName['CompanyName', NextGrid1.SelectedRow].AsString;
          CustCompanyCodeEdit.Text := NextGrid1.CellByName['CompanyCode', NextGrid1.SelectedRow].AsString;
          CustCompanyTypeCB.Text := NextGrid1.CellByName['CompanyType', NextGrid1.SelectedRow].AsString;
          CustManagerEdit.Text := NextGrid1.CellByName['ManagerName', NextGrid1.SelectedRow].AsString;
          CustPositionEdit.Text := NextGrid1.CellByName['Position', NextGrid1.SelectedRow].AsString;
          CustEmailEdit.Text := NextGrid1.CellByName['EMail', NextGrid1.SelectedRow].AsString;
          NationEdit.Text := NextGrid1.CellByName['Nation', NextGrid1.SelectedRow].AsString;
          CustPhonNumEdit.Text := NextGrid1.CellByName['Officeno', NextGrid1.SelectedRow].AsString;
          CustFaxEdit.Text := NextGrid1.CellByName['Mobileno', NextGrid1.SelectedRow].AsString;
          CustomerAddressMemo.Text := NextGrid1.CellByName['CompanyAddress', NextGrid1.SelectedRow].AsString;
        end;
      end;
    end;
  finally
    LSearchCustomerF.Free;
  end;
end;

procedure TTaskEditF.Button3Click(Sender: TObject);
begin
  LoadToDoCollectFromTask(FEmailDisplayTask, FToDoCollect);

  Create_ToDoList_Frm(IntToStr(FEmailDisplayTask.ID), FToDoCollect, False,
    InsertOrUpdateToDoList2DB, DeleteToDoListFromDB);
end;

procedure TTaskEditF.Button4Click(Sender: TObject);
begin
  if (SubCompanyCodeEdit.Text = '') or (SubCompanyEdit.Text = '') then
  begin
    ShowMessage('회사이름 과 업체코드는 필수 입력 항목 입니다.');
    exit;
  end;

  if MessageDlg('Are you sure save to MasterSubContractDB?', mtConfirmation, [mbYes, mbNo],0) = mrYes then
    SaveSubConEdit2MasterCustomer;
end;

procedure TTaskEditF.fileGridCellDblClick(Sender: TObject; ACol, ARow: Integer);
var
  LFileName: string;
begin
  if ARow = -1 then
    exit;

  if Assigned(FSQLGSFiles) then
  begin
    LFileName := 'C:\Temp\'+FSQLGSFiles.Files[ARow].fFilename;

    if FileExists(LFileName) then
      DeleteFile(LFileName);

    FileFromString(FSQLGSFiles.Files[ARow].fData,
      LFileName,True);

    ShellExecute(handle,'open', PChar(LFileName),nil,nil,SW_NORMAL);
  end;
end;

procedure TTaskEditF.fileGridMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i: integer;
begin
  if (FileGrid.SelectedCount > 0) and
    (DragDetectPlus(FileGrid.Handle, Point(X,Y))) then
  begin
    TVirtualFileStreamDataFormat(DataFormatAdapter2.DataFormat).FileNames.Clear;
    for i := 0 to FileGrid.RowCount - 1 do
      if (FileGrid.Row[i].Selected) then
      begin
        TVirtualFileStreamDataFormat(DataFormatAdapter2.DataFormat).
          FileNames.Add(FileGrid.CellByName['FileName',i].AsString);
      end;

    DropEmptySource1.Execute;
  end;
end;

procedure TTaskEditF.FormCreate(Sender: TObject);
begin
  FTask := nil;
  FSQLGSFiles := nil;
  FFSMState := nil;
  (DataFormatAdapter2.DataFormat as TVirtualFileStreamDataFormat).OnGetStream := OnGetStream;
  FToDoCollect := TpjhToDoItemCollection.Create(TpjhTodoItem);
  FOLMessagesFromDrop := TStringList.Create;
  FSalesProcessList := TStringList.Create;
  ElecProductType2Combo(ProductTypeCB);
//  SalesProcess2Combo(CurWorkCB);
  SalesProcessType2Combo(SalesProcTypeCB);
  CompanyType2Combo(CustCompanyTypeCB);

  PageControl1.ActivePageIndex := 0;
end;

procedure TTaskEditF.FormDestroy(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to FOLMessagesFromDrop.Count - 1 do
  begin
    TInterfaceList(FOLMessagesFromDrop.Objects[i]).Free;
  end;

  FOLMessagesFromDrop.Free;
  FSalesProcessList.Free;

  if Assigned(FTask) then
    FreeAndNil(FTask);

  FToDoCollect.Clear;
  FreeAndNil(FToDoCollect);

  if Assigned(FSQLGSFiles) then
    FSQLGSFiles.Free;
end;

function TTaskEditF.GetFileFromDropDataFormat(
  AFormat: TVirtualFileStreamDataFormat):TFileStream;
var
  LStream, LTargetAdapter: IStream;
  LTargetStream: TFileStream;
  LInt1, LInt2: LargeInt;
  FileName: string;
begin
  LStream := TVirtualFileStreamDataFormat(AFormat).FileContentsClipboardFormat.GetStream(0);
  if (LStream <> nil) then
  begin
    Filename := TVirtualFileStreamDataFormat(DataFormatAdapterTarget.DataFormat).FileNames[0];
    try
      LTargetStream := TFileStream.Create(Filename, fmCreate);
      try
        LTargetAdapter := TStreamAdapter.Create(LTargetStream, soOwned);
      except
        LTargetStream.Free;
        raise;
      end;
      LStream.CopyTo(LTargetAdapter, High(Int64), LInt1, LInt2);
    finally
      LTargetAdapter := nil;
    end;
  end;
end;

function TTaskEditF.GetQTN_InqContent: string;
begin
  Result := GetQTNContent(FEmailDisplayTask);
end;

function TTaskEditF.Get_Doc_Cust_Reg_Rec: Doc_Cust_Reg_Rec;
begin
  Result.FCompanyName := CustomerNameCB.Text;
  Result.FCountry := NationEdit.Text;
  Result.FCompanyAddress := CustomerAddressMemo.Text;
  Result.FTelNo := CustPhonNumEdit.Text;
  Result.FFaxNo := CustFaxEdit.Text;
  Result.FEMailAddress := CustEmailEdit.Text;
end;

function TTaskEditF.Get_Doc_Inv_Rec: Doc_Invoice_Rec;
begin
  Result.FCustomerInfo := CustomerAddressMemo.Text;
  Result.FCustomerInfo := Result.FCustomerInfo.Replace(#13, '');
//  Result.FCustomerInfo.Replace(#10, '');
  Result.FInvNo := OrderNoEdit.Text;
//  Result.FInvDate := FormatDateTime('dd.mmm.yyyy', now);
  Result.FHullNo := HullNoEdit.Text;
  Result.FShipName := ShipNameEdit.Text;
  Result.FSubject := WorkSummaryEdit.Text;
//  Result.FProduceType := ProductTypeCB.Text;
  Result.FPONo := PONoEdit.Text;
end;

function TTaskEditF.Get_Doc_Qtn_Rec: Doc_Qtn_Rec;
var
  LQTN: string;
begin
  Result.FCustomerInfo := CustomerAddressMemo.Text;
  Result.FCustomerInfo := Result.FCustomerInfo.Replace(#13, '');

  LQTN := QTNNoEdit.Text;
  if QTNNoEdit.Text = '' then
    LQTN := HullNoEdit.Text + '-' + IntToStr(Random(9));

  Result.FQtnNo := LQTN;
  Result.FQtnDate := FormatDateTime('dd.mmm.yyyy', now);
  Result.FHullNo := HullNoEdit.Text;
  Result.FShipName := ShipNameEdit.Text;
  Result.FSubject := WorkSummaryEdit.Text;
//  Result.FProduceType := ProductTypeCB.Text;
  Result.FPONo := PONoEdit.Text;
  Result.FValidateDate := FormatDateTime('mmm.dd.yyyy', now+30);
end;

function TTaskEditF.Get_Doc_ServiceOrder_Rec: Doc_ServiceOrder_Rec;
var
  LPeriod:string;
begin
  Result.FSubConName := SubCompanyEdit.Text;
  Result.FSubConManager := SubManagerEdit.Text;
  Result.FSubConPhonNo := SubPhonNumEdit.Text;
  Result.FSubConEmail := SubEmailEdit.Text;
  Result.FHullNo := HullNoEdit.Text;
  Result.FShipName := ShipNameEdit.Text;
  Result.FSubject := WorkSummaryEdit.Text;
//  Result.FWorkDesc := WorkSummaryEdit.Text;
//  Result.FProduceType := ProductTypeCB.Text;
  Result.FPONo2SubCon := ServicePOEdit.Text;
  Result.FOrderDate := FormatDateTime('dd.mmm.yyyy', now);
  Result.FWorkSch := '1.Place : ' + NationPortEdit.Text;
  LPeriod := FormatDateTime('yyyy.mm.dd',WorkBeginPicker.Date);
  LPeriod := LPeriod + ' ~ ' + FormatDateTime('yyyy.mm.dd',WorkEndPicker.Date);
  Result.FWorkPeriod := LPeriod;
  Result.FWorkSch := Result.FWorkSch + #13#10 + '2.Period : ' + NationPortEdit.Text;
  Result.FEngineerNo := SECountEdit.Text;
  Result.FLocalAgent := CustAgentMemo.Text;
  Result.FLocalAgent := Result.FLocalAgent.Replace(#13,'');

  Result.FProjCode := OrderNoEdit.Text;
  Result.FCustomer := CustomerNameCB.Text;
  Result.FNationPort := NationPortEdit.Text;
  Result.FWorkSummary := WorkSummaryEdit.Text;
  Result.FSubConPrice := SubConPriceEdit.Text;
end;

procedure TTaskEditF.INQInput1Click(Sender: TObject);
var
  LStr: string;
begin
  LStr := GetQTN_InqContent;
  Content2Clipboard(LStr);
end;

procedure TTaskEditF.LoadCustomer2Form(ACustomer: TSQLCustomer;
  AForm: TTaskEditF);
begin
  with AForm do
  begin
    CustomerNameCB.Text := ACustomer.CompanyName;
    CustCompanyCodeEdit.Text := ACustomer.CompanyCode;
    CustCompanyTypeCB.ItemIndex := Ord(ACustomer.CompanyType);
    CustManagerEdit.Text := ACustomer.ManagerName;
    CustEmailEdit.Text := ACustomer.EMail;
    CustomerAddressMemo.Text := ACustomer.CompanyAddress;
    CustAgentMemo.Text := ACustomer.AgentInfo;
    CustPhonNumEdit.Text := ACustomer.OfficePhone;
    CustFaxEdit.Text := ACustomer.MobilePhone;
    CustPositionEdit.Text := ACustomer.Position;
    NationEdit.Text := ACustomer.Nation;
  end;
end;

procedure TTaskEditF.LoadCustomerFromCompanycode(ACompanyCode: string);
var
  LMasterCustomer: TSQLMasterCustomer;
begin
  if ACompanyCode = '' then
    exit;

  LMasterCustomer := GetMasterCustomerFromCompanyCodeNName(ACompanyCode, '');
  try
    if LMasterCustomer.IsUpdate then
    begin

    end;
  finally
    FreeAndNil(LMasterCustomer);
  end;
end;

class procedure TTaskEditF.LoadEmailListFromTask(ATask: TSQLGSTask;
  AForm: TViewMailListF);
var
 LIds: TIDDynArray;
begin
  ATask.EmailMsg.DestGet(g_ProjectDB, ATask.ID, LIds);
  ShowEmailListFromIDs(AForm.grid_Mail, LIds);
end;

procedure TTaskEditF.LoadGrid2TaskEditForm(AGrid: TNextGrid; ARow: integer;
  AEditForm: TTaskEditF);
begin
  with AEditForm, AGrid do
  begin
    HullNoEdit.Text := CellByName['HullNo', ARow].AsString;
    ShipNameEdit.Text :=  CellByName['ShipName', ARow].AsString;
    ProductTypeCB.Text := CellByName['ProdType', ARow].AsString;
    PONoEdit.Text := CellByName['PONo', ARow].AsString;
    QTNNoEdit.Text := CellByName['QtnNo', ARow].AsString;
    OrderNoEdit.Text := CellByName['OrderNo', ARow].AsString;

    CustomerNameCB.Text := CellByName['CustomerName', ARow].AsString;
    CustomerAddressMemo.Text := CellByName['CustomerAddress', ARow].AsString;

    QTNInputPicker.Date := CellByName['QtnInputDate', ARow].AsDateTime;
    OrderInputPicker.Date := CellByName['OrderInputDate', ARow].AsDateTime;
    InqRecvPicker.Date := CellByName['RecvDate', ARow].AsDateTime;
    InvoiceIssuePicker.Date := CellByName['InvoiceInputDate', ARow].AsDateTime;
  end;
end;

procedure TTaskEditF.LoadGSFiles2Form(AGSFile: TSQLGSFile; AForm: TTaskEditF);
var
  LSQLGSFileRec: TSQLGSFileRec;
  LRow: integer;
begin
  with AForm do
  begin
    try
      FileGrid.BeginUpdate;
      FileGrid.ClearRows;

      while AGSFile.FillOne do
      begin
        for LRow := Low(AGSFile.Files) to High(AGSFile.Files) do
        begin
          SQLGSFileRec2Grid(AGSFile.Files[LRow], FileGrid);
        end;
      end;
    finally
      FileGrid.EndUpdate;
    end;
  end;
end;

procedure TTaskEditF.LoadMaterial4Project2Form(AMaterial: TSQLMaterial4Project;
  AForm: TTaskEditF);
begin
  with AForm do
  begin
    PORNoEdit.Text := AMaterial.PORNo;
    PORIssuePicker.Date := TimeLogToDateTime(AMaterial.PORIssueDate);
    DeliveryCompanyEdit.Text := AMaterial.DeliveryCompany;
    DeliveryChargeEdit.Text := AMaterial.DeliveryCharge;
    AWBEdit.Text := AMaterial.AirWayBill;
    MaterialCodeListMemo.Text := AMaterial.MaterialCodeList;
    DeliveryAddressMemo.Text := AMaterial.DeliveryAddress;
  end;
end;

procedure TTaskEditF.LoadSubCon2Form(ASubCon: TSQLSubCon; AForm: TTaskEditF);
begin
  with AForm do
  begin
    SubCompanyEdit.Text := ASubCon.CompanyName;
    SubCompanyCodeEdit.Text := ASubCon.CompanyCode;
    SubManagerEdit.Text := ASubCon.ManagerName;
    SubEmailEdit.Text := ASubCon.EMail;
    SubCompanyAddressMemo.Text := ASubCon.CompanyAddress;
    SubPhonNumEdit.Text := ASubCon.OfficePhone;
    SubFaxEdit.Text := ASubCon.MobilePhone;
    PositionEdit.Text := ASubCon.Position;
  end;
end;

procedure TTaskEditF.LoadTaskEditForm2Grid(AEditForm: TTaskEditF;
  AGrid: TNextGrid; ARow: integer);
begin
  with AEditForm, AGrid do
  begin
    CellByName['HullNo', ARow].AsString := HullNoEdit.Text;
    CellByName['ShipName', ARow].AsString := ShipNameEdit.Text;
    CellByName['ProdType', ARow].AsString := ProductTypeCB.Text;
    CellByName['PONo', ARow].AsString := PONoEdit.Text;
    CellByName['QtnNo', ARow].AsString := QTNNoEdit.Text;
    CellByName['OrderNo', ARow].AsString := OrderNoEdit.Text;
    CellByName['CustomerName', ARow].AsString := CustomerNameCB.Text;
    CellByName['CustomerAddress', ARow].AsString := CustomerAddressMemo.Text;

    CellByName['QtnInputDate', ARow].AsDateTime := QTNInputPicker.Date;
    CellByName['OrderInputDate', ARow].AsDateTime := OrderInputPicker.Date;
    CellByName['RecvDate', ARow].AsDateTime := InqRecvPicker.Date;
    CellByName['InvoiceInputDate', ARow].AsDateTime := InvoiceIssuePicker.Date;
  end;
end;

procedure TTaskEditF.LoadTaskForm2Customer(AForm: TTaskEditF;
  ACustomer: TSQLCustomer; ATaskID: TID);
begin
  with AForm do
  begin
    ACustomer.TaskID := ATaskID;
    ACustomer.CompanyName := CustomerNameCB.Text;
    ACustomer.CompanyCode := CustCompanyCodeEdit.Text;
    ACustomer.CompanyType := TCompanyType(CustCompanyTypeCB.ItemIndex);
    ACustomer.ManagerName := CustManagerEdit.Text;
    ACustomer.Position := CustPositionEdit.Text;
    ACustomer.OfficePhone := CustPhonNumEdit.Text;
    ACustomer.MobilePhone := CustFaxEdit.Text;

    ACustomer.EMail := CustEmailEdit.Text;
    ACustomer.CompanyAddress := CustomerAddressMemo.Text;
    ACustomer.AgentInfo := CustAgentMemo.Text;
    ACustomer.Nation := NationEdit.Text;
  end;
end;

procedure TTaskEditF.LoadTaskForm2GSFiles(AForm: TTaskEditF;
  out AGSFile: TSQLGSFile);
begin

end;

procedure TTaskEditF.LoadTaskForm2MasterCustomer(AForm: TTaskEditF;
  var ACustomer: TSQLMasterCustomer; ATaskID: TID);
begin
  with AForm do
  begin
//    ACustomer.TaskID := ATaskID;
    ACustomer.CompanyName := CustomerNameCB.Text;
    ACustomer.CompanyCode := CustCompanyCodeEdit.Text;
    ACustomer.CompanyType := TCompanyType(CustCompanyTypeCB.ItemIndex);
    ACustomer.ManagerName := CustManagerEdit.Text;
    ACustomer.Position := CustPositionEdit.Text;
    ACustomer.OfficePhone := CustPhonNumEdit.Text;
    ACustomer.MobilePhone := CustFaxEdit.Text;

    ACustomer.EMail := CustEmailEdit.Text;
    ACustomer.CompanyAddress := CustomerAddressMemo.Text;
//    CustAgentMemo.Text := ACustomer.AgentInfo;
    ACustomer.Nation := NationEdit.Text;
  end;
end;

procedure TTaskEditF.LoadTaskForm2MasterSubContractor(AForm: TTaskEditF;
  var ACustomer: TSQLMasterCustomer; ATaskID: TID);
begin
  with AForm do
  begin
    ACustomer.CompanyName := SubCompanyEdit.Text;
    ACustomer.CompanyCode := SubCompanyCodeEdit.Text;
    ACustomer.CompanyType := ctSubContractor;
    ACustomer.ManagerName := SubManagerEdit.Text;
    ACustomer.Position := PositionEdit.Text;
    ACustomer.OfficePhone := SubPhonNumEdit.Text;
    ACustomer.MobilePhone := SubFaxEdit.Text;

    ACustomer.EMail := SubEmailEdit.Text;
    ACustomer.CompanyAddress := SubCompanyAddressMemo.Text;
    ACustomer.Nation := SubConNationEdit.Text;
  end;
end;

procedure TTaskEditF.LoadTaskForm2Material4Project(AForm: TTaskEditF;
  AMaterial: TSQLMaterial4Project; ATaskID: TID);
begin
  with AForm do
  begin
    AMaterial.TaskID := ATaskID;
    AMaterial.PORNo := PORNoEdit.Text;
    AMaterial.PORIssueDate := TimeLogFromDateTime(PORIssuePicker.Date);
    AMaterial.DeliveryCompany := DeliveryCompanyEdit.Text;
    AMaterial.DeliveryCharge := DeliveryChargeEdit.Text;
    AMaterial.AirWayBill := AWBEdit.Text;
    AMaterial.MaterialCodeList := MaterialCodeListMemo.Text;
    AMaterial.DeliveryAddress := DeliveryAddressMemo.Text;
  end;
end;

procedure TTaskEditF.LoadTaskForm2SubCon(AForm: TTaskEditF; ASubCon: TSQLSubCon;
  ATaskID: TID);
begin
  with AForm do
  begin
    ASubCon.TaskID := ATaskID;
    ASubCon.CompanyName := SubCompanyEdit.Text;
    ASubCon.CompanyCode := SubCompanyCodeEdit.Text;
    ASubCon.ManagerName := SubManagerEdit.Text;
    ASubCon.EMail := SubEmailEdit.Text;
    ASubCon.CompanyAddress := SubCompanyAddressMemo.Text;
    ASubCon.OfficePhone := SubPhonNumEdit.Text;
    ASubCon.MobilePhone := SubFaxEdit.Text;
    ASubCon.Position := PositionEdit.Text;
  end;
end;

procedure TTaskEditF.LoadTaskForm2Var(AForm: TTaskEditF; out AVar: TSQLGSTask);
begin
  with AForm do
  begin
    AVar.HullNo := HullNoEdit.Text;
    AVar.ShipName := ShipNameEdit.Text;
//    AVar.ReqCustomer := CustomerNameEdit.Text;
    AVar.PO_No := PONoEdit.Text;
    AVar.QTN_No := QTNNoEdit.Text;
    AVar.Order_No := OrderNoEdit.Text;
    AVar.ProductType := ProductTypeCB.Text;
    Avar.WorkSummary := WorkSummaryEdit.Text;
    AVar.SubConPrice := SubConPriceEdit.Text;
    Avar.NationPort := NationPortEdit.Text;
    Avar.EtcContent := EtcContentMemo.Text;
    AVar.CurrentWorkStatus := Ord(String2SalesProcess(
      CurWorkCB.Items.Strings[CurWorkCB.ItemIndex]));
    AVar.NextWork := Ord(String2SalesProcess(
      NextWorkCB.Items.Strings[NextWorkCB.ItemIndex]));
    AVar.SalesProcessType := TSalesProcessType(SalesProcTypeCB.ItemIndex);
    AVar.ShipOwner := ShipOwnerEdit.Text;
//    AVar.CompanyType := TCompanyType(CustCompanyTypeCB.ItemIndex);
    AVar.SEList := SEEdit.Text;
    AVar.SECount := StrToIntDef(SECountEdit.Text,0);
    AVar.SalesPrice := SalesPriceEdit.Text;
    AVar.ExchangeRate := ExchangeRateEdit.Text;
    AVar.ShippingNo := ShippingNoEdit.Text;
    AVar.CurrencyKind := CurrencyKindCB.ItemIndex;

    AVar.BaseProjectNo := BaseProjectNoEdit.Text;
    AVar.DeliveryCondition := DeliveryConditionCB.ItemIndex;
    AVar.EstimateType := EstimateTypeCB.ItemIndex;
    AVar.TermsOfPayment := TermsPaymentCB.ItemIndex;

    AVar.QTNInputDate := TimeLogFromDateTime(QTNInputPicker.Date);
    AVar.OrderInputDate := TimeLogFromDateTime(OrderInputPicker.Date);
    AVar.InvoiceIssueDate := TimeLogFromDateTime(InvoiceIssuePicker.Date);
    Avar.QTNIssueDate := TimeLogFromDateTime(QtnIssuePicker.Date);
    AVar.InqRecvDate := TimeLogFromDateTime(InqRecvPicker.Date);
    Avar.AttendScheduled := TimeLogFromDateTime(AttendSchedulePicker.Date);
    Avar.WorkBeginDate := TimeLogFromDateTime(WorkBeginPicker.Date);
    Avar.WorkEndDate := TimeLogFromDateTime(WorkEndPicker.Date);
    AVar.CurWorkFinishDate := TimeLogFromDateTime(CurWorkFinishPicker.Date);
    AVar.SRRecvDate := TimeLogFromDateTime(SRRecvDatePicker.Date);
    AVar.SubConInvoiceIssueDate := TimeLogFromDateTime(SubConInvoiceIssuePicker.Date);
    AVar.SalesReqDate := TimeLogFromDateTime(SalesReqPicker.Date);
    AVar.ShippingDate := TimeLogFromDateTime(ShippingDatePicker.Date);
  end;
end;

procedure TTaskEditF.LoadTaskVar2Form(AVar: TSQLGSTask; AForm: TTaskEditF; AFSMClass: TFSMClass);
var
  LFSMState: TFSMState;
  LStr: string;
begin
  with AForm do
  begin
    if AVar.UniqueTaskID = '' then
    begin
      LStr := NewGUID;
      LStr := StringReplace(LStr, '{', '', [rfReplaceAll]);
      LStr := StringReplace(LStr, '}', '', [rfReplaceAll]);

      AVar.UniqueTaskID := LStr;
    end;

    HullNoEdit.Text := AVar.HullNo;
    ShipNameEdit.Text := AVar.ShipName;
//    CustomerNameEdit.Text := AVar.ReqCustomer;
    PONoEdit.Text := AVar.PO_No;
    QTNNoEdit.Text := AVar.QTN_No;
    OrderNoEdit.Text := AVar.Order_No;
    ProductTypeCB.ItemIndex := Ord(String2ElecProductType(AVar.ProductType));
    WorkSummaryEdit.Text := Avar.WorkSummary;
    SubConPriceEdit.Text := AVar.SubConPrice;

    NationPortEdit.Text := Avar.NationPort;
    EtcContentMemo.Text := Avar.EtcContent;
    SalesProcTypeCB.ItemIndex := Ord(AVar.SalesProcessType);
    ShipOwnerEdit.Text := AVar.ShipOwner;
    SEEdit.Text := AVar.SEList;
    SECountEdit.Text := IntToStr(AVar.SECount);
    SalesPriceEdit.Text := AVar.SalesPrice;
    ExchangeRateEdit.Text := AVar.ExchangeRate;
    ShippingNoEdit.Text := AVar.ShippingNo;
    CurrencyKindCB.ItemIndex := AVar.CurrencyKind;
    BaseProjectNoEdit.Text := AVar.BaseProjectNo;
    DeliveryConditionCB.ItemIndex := AVar.DeliveryCondition;
    EstimateTypeCB.ItemIndex := AVar.EstimateType;
    TermsPaymentCB.ItemIndex := AVar.TermsOfPayment;
    ChargeInPersonIdEdit.Text := AVar.ChargeInPersonId;
//    CompanyTypeCB.ItemIndex := Ord(AVar.CompanyType);

    LFSMState := AFSMClass.GetState(Ord(AVar.SalesProcessType));

    if Assigned(LFSMState) then
    begin
//      SPType2Combo(CurWorkCB, LFSMState);
      SalesProcess2List(FSalesProcessList, LFSMState);
      CurWorkCB.Items.Assign(FSalesProcessList);
      CurWorkCB.ItemIndex := FSalesProcessList.IndexOf(SalesProcess2String(
        TSalesProcess(AVar.CurrentWorkStatus)));
      NextWorkCB.Items.Assign(FSalesProcessList);
      NextWorkCB.ItemIndex := FSalesProcessList.IndexOf(SalesProcess2String(
        TSalesProcess(AVar.NextWork)));
    end;

    QTNInputPicker.Date := TimeLogToDateTime(AVar.QTNInputDate);
    OrderInputPicker.Date := TimeLogToDateTime(AVar.OrderInputDate);
    InvoiceIssuePicker.Date := TimeLogToDateTime(AVar.InvoiceIssueDate);
    QtnIssuePicker.Date := TimeLogToDateTime(Avar.QTNIssueDate);
    InqRecvPicker.Date := TimeLogToDateTime(AVar.InqRecvDate);
    AttendSchedulePicker.Date := TimeLogToDateTime(Avar.AttendScheduled);
    WorkBeginPicker.Date := TimeLogToDateTime(Avar.WorkBeginDate);
    WorkEndPicker.Date := TimeLogToDateTime(Avar.WorkEndDate);
    CurWorkFinishPicker.Date := TimeLogToDateTime(AVar.CurWorkFinishDate);
    SRRecvDatePicker.Date := TimeLogToDateTime(AVar.SRRecvDate);
    SubConInvoiceIssuePicker.Date := TimeLogToDateTime(AVar.SubConInvoiceIssueDate);
    SalesReqPicker.Date := TimeLogToDateTime(AVar.SalesReqDate);
    ShippingDatePicker.Date := TimeLogToDateTime(AVar.ShippingDate);

    FSQLGSFiles := GetFilesFromTask(AVar);
    LoadGSFiles2Form(FSQLGSFiles, AForm);
  end;
end;

procedure TTaskEditF.N18Click(Sender: TObject);
begin
  SendCmd2IPC4CreateMail(nil, 0, TMenuItem(Sender).Tag, FEmailDisplayTask);
end;

procedure TTaskEditF.N19Click(Sender: TObject);
begin
  SendCmd2IPC4CreateMail(nil, 0, TMenuItem(Sender).Tag, FEmailDisplayTask);
end;

procedure TTaskEditF.N20Click(Sender: TObject);
begin
  SendCmd2IPC4CreateMail(nil, 0, TMenuItem(Sender).Tag, FEmailDisplayTask);
end;

procedure TTaskEditF.N21Click(Sender: TObject);
begin
  SendCmd2IPC4CreateMail(nil, 0, TMenuItem(Sender).Tag, FEmailDisplayTask);
end;

procedure TTaskEditF.N22Click(Sender: TObject);
begin
  SendCmd2IPC4CreateMail(nil, 0, TMenuItem(Sender).Tag, FEmailDisplayTask);
end;

procedure TTaskEditF.N2Click(Sender: TObject);
var
  LRec: Doc_ServiceOrder_Rec;
begin
  LRec := Get_Doc_ServiceOrder_Rec;

  if CheckDocCompanySelection(LRec) then
    MakeDocCompanySelection(LRec);
end;

procedure TTaskEditF.N3Click(Sender: TObject);
var
  LRec: Doc_ServiceOrder_Rec;
begin
  LRec := Get_Doc_ServiceOrder_Rec;
  MakeDocConfirmComplete(LRec);
end;

procedure TTaskEditF.N8Click(Sender: TObject);
var
  LRec: Doc_Cust_Reg_Rec;
begin
  LRec := Get_Doc_Cust_Reg_Rec;
  MakeDocCustomerRegistration(LRec);
end;

procedure TTaskEditF.oCustomer1Click(Sender: TObject);
var
  LRec: Doc_Qtn_Rec;
begin
  LRec := Get_Doc_Qtn_Rec;
  MakeDocQtn(LRec);
end;

procedure TTaskEditF.OnGetStream(
  Sender: TFileContentsStreamOnDemandClipboardFormat; Index: integer;
  out AStream: IStream);
var
  Stream: TMemoryStream;
  Data: AnsiString;
  i: integer;
  SelIndex: integer;
  Found: boolean;
begin
  // This event handler is called by TFileContentsStreamOnDemandClipboardFormat
  // when the drop target requests data from the drop source (that's us).
  Stream := TMemoryStream.Create;
  try
    AStream := nil;
    // Find the listview item which corresponds to the requested data item.
    SelIndex := 0;
    Found := False;

    for i := 0 to FileGrid.RowCount-1 do
      if (FileGrid.Row[i].Selected) then
      begin
        if (SelIndex = Index) then
        begin
          if Assigned(FSQLGSFiles) then
          begin
            Data := FSQLGSFiles.Files[i].fData;
            Found := True;
            break;
          end;
        end;
        inc(SelIndex);
      end;
    if (not Found) then
      exit;

    // ...Write the file contents to a regular stream...
    Stream.Write(PAnsiChar(Data)^, Length(Data));

    (*
    ** Stream.Position must be equal to Stream.Size or the Windows clipboard
    ** will fail to read from the stream. This requirement is completely
    ** undocumented.
    *)
    // Stream.Position := 0;

    // ...and return the stream back to the target as an IStream. Note that the
    // target is responsible for deleting the stream (via reference counting).
    AStream := TFixedStreamAdapter.Create(Stream, soOwned);
  except
    Stream.Free;
    raise;
  end;
end;

procedure TTaskEditF.ProductTypeCBDropDown(Sender: TObject);
begin
  ElecProductType2Combo(ProductTypeCB);
end;

procedure TTaskEditF.ShowDTIForm;
var
  LDisplayTaskInfoF: TDisplayTaskInfoF;
  LIdList: TIDList;
  LRow: integer;
  LGrid: TNextGrid;
begin
  if MessageDlg('대표메일을 선택하면 현재 화면에 입력한 내용은 저장 되지 않고' + #13#10 +
                '대표메일의 내용으로 대체 됩니다.' + #13#10 + '그래도 계속 하시겠습니까?'
                , mtConfirmation, [mbYes, mbNo], 0)= mrNo then
  begin
    exit;
  end;

  LDisplayTaskInfoF := TDisplayTaskInfoF.Create(nil);
  try
    if LDisplayTaskInfoF.ShowModal = mrOK then
    begin
      LRow := LDisplayTaskInfoF.FSelectedRow;

      if LRow <> -1 then
      begin
        LGrid := LDisplayTaskInfoF.TDisplayTaskF1.grid_Req;
        if LGrid.Row[LRow].Data <> nil then
        begin
          if Assigned(FTask) then
            FTask.Free;

          FTask := nil;
          LIdList := TIDList(LGrid.Row[LRow].Data);
          FTask := CreateOrGetLoadTask(LIdList.fTaskId);
        end;
      end;
    end;
  finally
    LDisplayTaskInfoF.Free;
  end;
end;

class procedure TTaskEditF.ShowEMailListFromTask(ATask: TSQLGSTask);
var
  LViewMailListF: TViewMailListF;
begin
  LViewMailListF := TViewMailListF.Create(nil);
  try
    begin
      LViewMailListF.FTask := ATask;
//      LViewMailListF.SetMoveFolderIndex; //모든 StoredID가 동일하여 효과 없음
      LoadEmailListFromTask(ATask, LViewMailListF);

      if LViewMailListF.ShowModal = mrOK then
      begin
      end;
    end;
  finally
    LViewMailListF.Free;
  end;
end;

procedure TTaskEditF.ShowFileSelectF(AFileName: string;
  AFromOutLook: Boolean);
var
  li,le : integer;
  lfilename : String;
  lExt : String;
  lSize : int64;
  LFileSelectF: TFileSelectF;
  LSQLGSFileRec: TSQLGSFileRec;
  LDoc: RawByteString;
  i: integer;
begin
  LFileSelectF := TFileSelectF.Create(nil);
  try
    //Drag 했을 경우 AFileName <> ''이고
    //Task Edit 화면에서 추가 버튼을 눌렀을 경우 AFileName = ''임
    if AFileName <> '' then
      LFileSelectF.JvFilenameEdit1.FileName := AFileName;

    if LFileSelectF.ShowModal = mrOK then
    begin
      if LFileSelectF.JvFilenameEdit1.FileName = '' then
        exit;

      lfilename := ExtractFileName(LFileSelectF.JvFilenameEdit1.FileName);

      with fileGrid do
      begin
        BeginUpdate;
        try
          if AFileName <> '' then
            LDoc := FFileContent
          else
            LDoc := StringFromFile(LFileSelectF.JvFilenameEdit1.FileName);

          LSQLGSFileRec.fData := LDoc;
          LSQLGSFileRec.fGSDocType := String2GSDocType(LFileSelectF.ComboBox1.Text);
          LSQLGSFileRec.fFilename := lfilename;

          if not Assigned(FSQLGSFiles) then
            FSQLGSFiles := TSQLGSFile.Create;

          i := FSQLGSFiles.DynArray('Files').Add(LSQLGSFileRec);
          AddRow;
          CellByName['FileName',RowCount-1].AsString := lfilename;
          CellByName['FileSize',RowCount-1].AsString := IntToStr(lsize);
          CellByName['FilePath',RowCount-1].AsString := LFileSelectF.JvFilenameEdit1.FileName;
          CellByName['DocType',RowCount-1].AsString := LFileSelectF.ComboBox1.Text;
        finally
          EndUpdate;
        end;
      end;
    end;
  finally
    LFileSelectF.Free;
  end;
end;

procedure TTaskEditF.SPType2Combo(ACombo: TComboBox; AFSMState: TFSMState);
var
  LIntArr: TIntegerArray;
  i: integer;
begin
  if not Assigned(AFSMState) then
  begin
    if not Assigned(FFSMState) then
      exit;

    AFSMState := FFSMState;
  end;

  LIntArr := AFSMState.GetOutputs;

  for i := Low(LIntArr) to High(LIntArr) do
    ACombo.Items.Add(SalesProcess2String(TSalesProcess(LIntArr[i])));
end;

procedure TTaskEditF.SQLGSFileCopy(ASrc: TSQLGSFile; out ADest: TSQLGSFile);
var
  LRow: integer;
  LSQLGSFileRec: TSQLGSFileRec;
begin
  while ASrc.FillOne do
  begin
    for LRow := Low(ASrc.Files) to High(ASrc.Files) do
    begin
      LSQLGSFileRec.fFilename := ASrc.Files[LRow].fFilename;
      LSQLGSFileRec.fGSDocType := ASrc.Files[LRow].fGSDocType;
      LSQLGSFileRec.fData := ASrc.Files[LRow].fData;

      ADest.DynArray('Files').Add(LSQLGSFileRec);
    end;
  end;
end;

procedure TTaskEditF.SQLGSFileRec2Grid(ARec: TSQLGSFileRec; AGrid: TNextGrid);
var
  LRow: integer;
begin
  LRow := AGrid.AddRow();
  AGrid.CellByName['FileName', LRow].AsString := ARec.fFilename;
  AGrid.CellByName['DocType', LRow].AsString := GSDocType2String(ARec.fGSDocType);
end;

procedure TTaskEditF.SubCompanyEditClickBtn(Sender: TObject);
var
  LSearchCustomerF: TSearchCustomerF;
begin
  LSearchCustomerF := TSearchCustomerF.Create(nil);
  try
    with LSearchCustomerF do
    begin
      FCompanyType := ctSubContractor;

      if ShowModal = mrOk then
      begin
        if NextGrid1.SelectedRow <> -1 then
        begin
          SubCompanyEdit.Text := NextGrid1.CellByName['CompanyName', NextGrid1.SelectedRow].AsString;
          SubCompanyCodeEdit.Text := NextGrid1.CellByName['CompanyCode', NextGrid1.SelectedRow].AsString;
          SubManagerEdit.Text := NextGrid1.CellByName['ManagerName', NextGrid1.SelectedRow].AsString;
          PositionEdit.Text := NextGrid1.CellByName['Position', NextGrid1.SelectedRow].AsString;
          SubEmailEdit.Text := NextGrid1.CellByName['EMail', NextGrid1.SelectedRow].AsString;
          SubConNationEdit.Text := NextGrid1.CellByName['Nation', NextGrid1.SelectedRow].AsString;
          SubPhonNumEdit.Text := NextGrid1.CellByName['Officeno', NextGrid1.SelectedRow].AsString;
          SubFaxEdit.Text := NextGrid1.CellByName['Mobileno', NextGrid1.SelectedRow].AsString;
          SubCompanyAddressMemo.Text := NextGrid1.CellByName['CompanyAddress', NextGrid1.SelectedRow].AsString;
        end;
      end;
    end;
  finally
    LSearchCustomerF.Free;
  end;
end;

end.
