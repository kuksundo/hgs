unit FrmInvoiceEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Generics.Collections,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DropSource, DragDrop, DropTarget,
  Vcl.Menus, Vcl.ImgList, AeroButtons, CurvyControls, Vcl.Mask, JvExMask,
  JvToolEdit, JvBaseEdits, AdvEdit, AdvEdBtn, pjhComboBox, NxColumnClasses,
  NxColumns, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, NxEdit,
  AdvGlowButton, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls, JvExControls, JvLabel,
  UElecDataRecord, SynCommons, CommonData, mORMot, UnitMakeReport, UnitElecServiceData;

type
  TInvoiceTaskEditF = class(TForm)
    JvLabel3: TJvLabel;
    JvLabel4: TJvLabel;
    JvLabel5: TJvLabel;
    JvLabel6: TJvLabel;
    JvLabel9: TJvLabel;
    JvLabel2: TJvLabel;
    JvLabel31: TJvLabel;
    JvLabel30: TJvLabel;
    JvLabel49: TJvLabel;
    HullNoEdit: TEdit;
    ShipNameEdit: TEdit;
    OrderNoEdit: TEdit;
    PONoEdit: TEdit;
    InqRecvPicker: TDateTimePicker;
    PageControl1: TPageControl;
    TabSheet5: TTabSheet;
    JvLabel36: TJvLabel;
    JvLabel37: TJvLabel;
    Label2: TLabel;
    JvLabel38: TJvLabel;
    WorkBeginPicker: TDateTimePicker;
    WorkEndPicker: TDateTimePicker;
    EtcContentMemo: TMemo;
    TabSheet1: TTabSheet;
    JvLabel12: TJvLabel;
    JvLabel20: TJvLabel;
    JvLabel21: TJvLabel;
    JvLabel22: TJvLabel;
    JvLabel24: TJvLabel;
    JvLabel34: TJvLabel;
    JvLabel44: TJvLabel;
    JvLabel45: TJvLabel;
    JvLabel47: TJvLabel;
    JvLabel55: TJvLabel;
    CustomerAddressMemo: TMemo;
    CustCompanyCodeEdit: TEdit;
    CustManagerEdit: TEdit;
    CustEmailEdit: TEdit;
    CustAgentMemo: TMemo;
    CustPhonNumEdit: TEdit;
    CustFaxEdit: TEdit;
    CustPositionEdit: TEdit;
    NationEdit: TEdit;
    TabSheet2: TTabSheet;
    JvLabel15: TJvLabel;
    JvLabel16: TJvLabel;
    JvLabel17: TJvLabel;
    JvLabel18: TJvLabel;
    JvLabel19: TJvLabel;
    JvLabel23: TJvLabel;
    Label1: TLabel;
    JvLabel35: TJvLabel;
    JvLabel42: TJvLabel;
    JvLabel43: TJvLabel;
    JvLabel46: TJvLabel;
    JvLabel48: TJvLabel;
    JvLabel52: TJvLabel;
    JvLabel53: TJvLabel;
    JvLabel54: TJvLabel;
    SubCompanyCodeEdit: TEdit;
    SubManagerEdit: TEdit;
    SubCompanyAddressMemo: TMemo;
    SEEdit: TEdit;
    SubEmailEdit: TEdit;
    SECountEdit: TEdit;
    SubPhonNumEdit: TEdit;
    SubFaxEdit: TEdit;
    SubPositionEdit: TEdit;
    ServicePOEdit: TEdit;
    SubConInvoiceIssuePicker: TDateTimePicker;
    SRRecvDatePicker: TDateTimePicker;
    SubConPriceEdit: TEdit;
    TabSheet4: TTabSheet;
    CurvyPanel1: TCurvyPanel;
    JvLabel14: TJvLabel;
    btn_Close: TAeroButton;
    AeroButton1: TAeroButton;
    AttendSchedulePicker: TDateTimePicker;
    SubjectEdit: TEdit;
    NationPortEdit: TEdit;
    ShipOwnerEdit: TEdit;
    ImageList16x16: TImageList;
    DropEmptyTarget1: TDropEmptyTarget;
    DataFormatAdapterTarget: TDataFormatAdapter;
    DataFormatAdapter1: TDataFormatAdapter;
    Imglist16x16: TImageList;
    DataFormatAdapter2: TDataFormatAdapter;
    DropEmptySource1: TDropEmptySource;
    InvoiceGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    AUnit: TNxTextColumn;
    UnitPrice: TNxTextColumn;
    Attachments: TNxButtonColumn;
    ItemType: TNxComboBoxColumn;
    Qty: TNxTextColumn;
    PopupMenu1: TPopupMenu;
    AddItem1: TMenuItem;
    Add1: TMenuItem;
    Delete1: TMenuItem;
    JvLabel60: TJvLabel;
    ExchangeRateEdit: TEdit;
    ItemDesc: TNxTextColumn;
    PopupMenu2: TPopupMenu;
    Doc1: TMenuItem;
    InvoiceEnglish1: TMenuItem;
    CustomerNameEdit: TEdit;
    SubCompanyNameEdit: TEdit;
    SomePicker: TDateTimePicker;
    JvLabel11: TJvLabel;
    Panel1: TPanel;
    AeroButton2: TAeroButton;
    AeroButton3: TAeroButton;
    ExchangeRate: TNxTextColumn;
    Document1: TMenuItem;
    Create1: TMenuItem;
    JvLabel61: TJvLabel;
    CurrencyKindCB: TComboBox;
    EngineerKind: TNxTextColumn;
    TotalPrice: TNxButtonColumn;
    JvLabel59: TJvLabel;
    SalesPriceEdit: TJvCalcEdit;
    Button1: TButton;
    UniqueItemID: TNxTextColumn;
    UniqueSubConIDEdit: TEdit;
    ItemAction: TNxTextColumn;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure AeroButton1Click(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure AttachmentsButtonClick(Sender: TObject);
    procedure Add1Click(Sender: TObject);
    procedure ItemTypeSelect(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure InvoiceEnglish1Click(Sender: TObject);
    procedure AeroButton2Click(Sender: TObject);
    procedure AeroButton3Click(Sender: TObject);
    procedure Create1Click(Sender: TObject);
    procedure TotalPriceButtonClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure InvoiceGridAfterEdit(Sender: TObject; ACol, ARow: Integer;
      Value: WideString);
  private
    function GetSQLInvoiceItem(AGrid: TNextGrid; ARow: integer; var AInvoiceItem: TSQLInvoiceItem): Boolean;
    procedure GetInvoiceItemFromGrid2StrList(AGrid: TNextGrid; var AList: TStringList);
    procedure GetInvoiceItemFromObjList2StrList(AItemList: TObjectList<TSQLInvoiceItem>; var AList: TStringList);
    procedure ClearTIDList4Grid(AGrid: TNextGrid);
    function Get_Doc_Inv_Rec: Doc_Invoice_Rec;
    procedure CalcInvoice2Var;
    function GetTotalPrice: integer;
  public
//    FSQLInvoiceFiles: TSQLInvoiceFile;
//    FSQLInvoiceItem: TSQLInvoiceItem;
    FInvoiceTask: TSQLInvoiceTask;
    FItemID: TID;

    procedure LoadInvoiceTask2Form(ATask: TSQLInvoiceTask;
      AForm: TInvoiceTaskEditF; ADoc: variant);
    procedure LoadForm2InvoiceTask(AForm: TInvoiceTaskEditF; out ATask: TSQLInvoiceTask);
    function SaveInvoiceItemFromForm(AForm: TInvoiceTaskEditF): Boolean;
    procedure LoadInvoiceTask2Grid(ATask: TSQLInvoiceTask; AGrid: TNextGrid;
      ARow: integer);
    //AIsFromDoc : DB가 아닌 파일로 부터 로드함
    procedure LoadInvoiceItem2Form(AInvoiceItem: TSQLInvoiceItem;
      AForm: TInvoiceTaskEditF; AIsFromDoc: Boolean = False);
    procedure LoadInvoiceItem2Grid(AInvoiceItem: TSQLInvoiceItem;
      AGrid: TNextGrid; AIsFromDoc: Boolean = False);
    procedure LoadInvoiceItemFromVar2Form(ADoc: variant; AForm: TInvoiceTaskEditF);
    procedure LoadInvoiceItemList2Form(AItemList: TObjectList<TSQLInvoiceItem>; AForm: TInvoiceTaskEditF);
    procedure LoadInvoiceFileList2Form(AFileList: TObjectList<TSQLInvoiceFile>; AForm: TInvoiceTaskEditF);
    procedure LoadInvoiceFile2InvoiceGrid(AInvoiceFiles: TSQLInvoiceFile;
      AGrid: TNextGrid; AIsFromDoc: Boolean = False);
    procedure LoadInvoiceFile2InvoiceGrid_(AInvoiceFiles: TSQLInvoiceFile;
      AGrid: TNextGrid; ARow: integer);
    procedure LoadInvoiceFileCount2Grid(AInvoiceFiles: TSQLInvoiceFile;
      AGrid: TNextGrid; ARow: integer);
    procedure  LoadInvoiceFileCount2Grid_(AInvoiceFiles: TSQLInvoiceFile;
      AGrid: TNextGrid; ARow: integer);

    procedure UpdateInvoiceFileFromGrid(AGrid: TNextGrid; AItem: TSQLInvoiceItem);
    procedure UpdateInvoiceFileFromGridRow(AGrid: TNextGrid; ARow: integer; AItem: TSQLInvoiceItem);
    procedure AddInvoiceFileFromGrid(AGrid: TNextGrid; ARow: integer; AItem: TSQLInvoiceItem);
    procedure UpdateInvoiceItemFromGrid(AGrid: TNextGrid; AIndex: Integer; AIDList: TIDList4Invoice);
    procedure DeleteNAddInvoiceItemNFileFromGrid(AGrid: TNextGrid; AIndex: Integer; AIDList: TIDList4Invoice);
    procedure AddInvoiceItemFromGrid(AGrid: TNextGrid; AIndex: Integer; ATaskID: TID);
    procedure DeleteInvoiceItemFromGrid(AIDList: TIDList4Invoice);
    procedure UpdateTaskID2InvoiceGrid(ATaskID: TID; AGrid: TNextGrid);
    procedure UpdateItemID2InvoiceGrid(AItemID: TID; AUniqueItemID:RawUTF8; AGrid: TNextGrid;
      AIndex: Integer);

    procedure InvoiceItemAdd;
    procedure InvoiceItemDelete;

    procedure ShowFileListForm;
  end;

  function DisplayInvoiceTaskInfo2EditForm(var ATask: TSQLInvoiceTask;
    ADoc: variant): Boolean;

var
  InvoiceTaskEditF: TInvoiceTaskEditF;

implementation

uses FrmFileList, UnitVariantJsonUtil, UnitStringUtil;

{$R *.dfm}

function DisplayInvoiceTaskInfo2EditForm(var ATask: TSQLInvoiceTask;
    ADoc: variant): Boolean;
var
  LTaskEditF: TInvoiceTaskEditF;
  LFiles: TSQLInvoiceFile;
  LItem: TSQLInvoiceItem;
  i: integer;
  LID: TID;
  LIsFromInvoiceManage: Boolean;
begin
  LTaskEditF := TInvoiceTaskEditF.Create(nil);
  try
    with LTaskEditF do
    begin
      FInvoiceTask := ATask;

      if ATask.IsUpdate then
        Caption := Caption + ' (Update)'
      else
        Caption := Caption + ' (New)';

      if ADoc <> null then
      begin //*.hgs 파일 DragDrop된 경우
        LIsFromInvoiceManage := LoadInvoiceTaskFromVariant(ATask, ADoc);

//        if LIsFromInvoiceManage then
//        begin
//          LoadInvoiceItemFromVariant(
//          LoadInvoiceFileFromVariant
//        end;
      end;

      LoadInvoiceTask2Form(ATask, LTaskEditF, ADoc);

      if LTaskEditF.ShowModal = mrOK then
      begin
        Result := True;
        LoadForm2InvoiceTask(LTaskEditF, ATask);
        AddOrUpdateInvoiceTask(ATask);

        //신규 Task일 경우 TaskID가 DB에 ADD 후에 생성됨
        if not ATask.IsUpdate then
          UpdateTaskID2InvoiceGrid(ATask.ID, LTaskEditF.InvoiceGrid);

        if SaveInvoiceItemFromForm(LTaskEditF) then
        begin
//          UpdateInvoiceFileFromGrid(LTaskEditF.InvoiceGrid, LItem);
        end
        else//Item이 0개 인 경우
//        if LItem.IsUpdate then
        begin
//          g_InvoiceItemDB.Delete(TSQLInvoiceItem, 'TaskID = ?', [LItem.TaskID]);
//          DeleteFilesFromID(LItem.TaskID, FItemID);
        end;
      end;
    end;//with
  finally
    FreeAndNil(LTaskEditF);
  end;
end;

procedure TInvoiceTaskEditF.Add1Click(Sender: TObject);
begin
  InvoiceItemAdd;
end;

procedure TInvoiceTaskEditF.AddInvoiceFileFromGrid(AGrid: TNextGrid; ARow: integer;
  AItem: TSQLInvoiceItem);
var
//  i: integer;
  LIDList: TIDList4Invoice;
  LSQLInvoiceFile, LAddInvoiceFile: TSQLInvoiceFile;
begin
//  for i := 0 to AGrid.RowCount - 1 do
//  begin
    LIDList := TIDList4Invoice(AGrid.Row[ARow].Data);
    LSQLInvoiceFile := GetFilesFromInvoiceIDList(LIDList);
    try
      if not LSQLInvoiceFile.FillOne then
      begin
        LAddInvoiceFile := TSQLInvoiceFile(TIDList4Invoice(AGrid.Row[ARow].Data).fInvoiceFile.CreateCopy);
        try
          LAddInvoiceFile.TaskID := LIDList.TaskId;
          LAddInvoiceFile.ItemID := LIDList.ItemId;
          LAddInvoiceFile.UniqueItemID := LIDList.UniqueItemID;
          LAddInvoiceFile.UniqueSubConID := LIDList.UniqueSubConID;
          LAddInvoiceFile.FIsUpdate := False;

          AddOrUpdateInvoiceFiles(LAddInvoiceFile);
        finally
          FreeAndNil(LAddInvoiceFile);
        end;
      end;
    finally
      FreeAndNil(LSQLInvoiceFile);
    end;
//  end;
end;

procedure TInvoiceTaskEditF.AddInvoiceItemFromGrid(AGrid: TNextGrid;
  AIndex: Integer; ATaskID: TID);
var
  LInvoiceItem: TSQLInvoiceItem;
begin
  LInvoiceItem := nil;
  GetSQLInvoiceItem(AGrid, AIndex, LInvoiceItem);
  try
    LInvoiceItem.TaskID := ATaskID;
    LInvoiceItem.IsUpdate := False;

    AddOrUpdateInvoiceItem(LInvoiceItem);

    if not LInvoiceItem.IsUpdate then
      UpdateItemID2InvoiceGrid(LInvoiceItem.ID, LInvoiceItem.UniqueItemID,
        AGrid, AIndex);

    AddInvoiceFileFromGrid(AGrid, AIndex, LInvoiceItem);
  finally
    FreeAndNil(LInvoiceItem);
  end;
end;

procedure TInvoiceTaskEditF.UpdateInvoiceFileFromGrid(AGrid: TNextGrid;
  AItem: TSQLInvoiceItem);
var
  i: integer;
  LIDList: TIDList4Invoice;
  LSQLInvoiceFile, LUpdateInvoiceFile: TSQLInvoiceFile;
begin
  for i := 0 to AGrid.RowCount - 1 do
  begin
    LIDList := TIDList4Invoice(AGrid.Row[i].Data);
    LUpdateInvoiceFile := GetFilesFromInvoiceIDList(LIDList);
    try
      LUpdateInvoiceFile.FIsUpdate := LUpdateInvoiceFile.FillOne;
      LSQLInvoiceFile := TIDList4Invoice(AGrid.Row[i].Data).fInvoiceFile;
      LUpdateInvoiceFile.DynArray('Files').Copy(LSQLInvoiceFile.DynArray('Files'));

      if not LUpdateInvoiceFile.FIsUpdate then
      begin
        LUpdateInvoiceFile.TaskID := LIDList.TaskId;
        LUpdateInvoiceFile.ItemID := LIDList.ItemId;
        LUpdateInvoiceFile.UniqueSubConID := LIDList.UniqueSubConID;
      end;

      AddOrUpdateInvoiceFiles(LUpdateInvoiceFile);
    finally
      FreeAndNil(LUpdateInvoiceFile);
    end;
  end;
end;

procedure TInvoiceTaskEditF.UpdateInvoiceFileFromGridRow(AGrid: TNextGrid;
  ARow: integer; AItem: TSQLInvoiceItem);
var
  LIDList: TIDList4Invoice;
  LSQLInvoiceFile, LUpdateInvoiceFile: TSQLInvoiceFile;
begin
  LIDList := TIDList4Invoice(AGrid.Row[ARow].Data);
  LUpdateInvoiceFile := GetFilesFromInvoiceIDList(LIDList);
  try
    LUpdateInvoiceFile.FIsUpdate := LUpdateInvoiceFile.FillOne;
    LSQLInvoiceFile := TIDList4Invoice(AGrid.Row[ARow].Data).fInvoiceFile;
    LUpdateInvoiceFile.DynArray('Files').Clear;
    LUpdateInvoiceFile.DynArray('Files').Copy(LSQLInvoiceFile.DynArray('Files'));

    if not LUpdateInvoiceFile.FIsUpdate then
    begin
      LUpdateInvoiceFile.TaskID := LIDList.TaskId;
      LUpdateInvoiceFile.ItemID := LIDList.ItemId;
      LUpdateInvoiceFile.UniqueSubConID := LIDList.UniqueSubConID;
      TIDList4Invoice(AGrid.Row[ARow].Data).TaskId := LIDList.TaskId;
      TIDList4Invoice(AGrid.Row[ARow].Data).ItemId := LIDList.ItemId;
    end;

//    if LUpdateInvoiceFile.UniqueItemID = '' then
//      LUpdateInvoiceFile.UniqueItemID := NewGUID;

    if LUpdateInvoiceFile.UniqueInvoiceFileID = '' then
      LUpdateInvoiceFile.UniqueInvoiceFileID := NewGUID;

    AddOrUpdateInvoiceFiles(LUpdateInvoiceFile);
  finally
    FreeAndNil(LUpdateInvoiceFile);
  end;
end;

procedure TInvoiceTaskEditF.AeroButton1Click(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TInvoiceTaskEditF.AeroButton2Click(Sender: TObject);
begin
  InvoiceItemAdd;
end;

procedure TInvoiceTaskEditF.AeroButton3Click(Sender: TObject);
begin
  InvoiceItemDelete;
end;

procedure TInvoiceTaskEditF.btn_CloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TInvoiceTaskEditF.Button1Click(Sender: TObject);
begin
  GetTotalPrice;
end;

procedure TInvoiceTaskEditF.CalcInvoice2Var;
var
  LRec: Doc_Invoice_Rec;
  LStrList: TStringList;
  LStr: string;
  i: integer;
  LDoc: Variant;
  LItemList: TObjectList<TSQLInvoiceItem>;
begin
  LRec := Get_Doc_Inv_Rec;
  GetInvoiceItemFromGrid2StrList(InvoiceGrid, LRec.FInvoiceItemList);

  if Assigned(LRec.FInvoiceItemList) then
  begin
    TDocVariant.New(LDoc);
    LItemList := TObjectList<TSQLInvoiceItem>.Create;
    LStrList := TStringList.Create;

    try
      for i := 0 to LRec.FInvoiceItemList.Count - 1 do
      begin
        LStr := LRec.FInvoiceItemList.Strings[i];
        GetInvoiceItem2Var(LStr, LDoc);
        AddInvoiceItemFromVar2ItemList(LDoc, LItemList);
      end;

      GetInvoiceItemFromObjList2StrList(LItemList, LStrList);

      LRec.FInvoiceItemList.Clear;
      LRec.FInvoiceItemList.Assign(LStrList);

      MakeSubConInvoice(SubCompanyNameEdit.Text, LRec);
    finally
      LItemList.Clear;
      LItemList.Free;
      LStrList.Free;
      LRec.FInvoiceItemList.Free;
    end;
  end;
end;

procedure TInvoiceTaskEditF.ClearTIDList4Grid(AGrid: TNextGrid);
var
  i: integer;
begin
  for i := 0 to AGrid.RowCount - 1 do
  begin
    TIDList4Invoice(AGrid.Row[i].Data).InvoiceFile.Free;
    TIDList4Invoice(AGrid.Row[i].Data).Free;
  end;
end;

procedure TInvoiceTaskEditF.Create1Click(Sender: TObject);
begin
  CalcInvoice2Var;
end;

procedure TInvoiceTaskEditF.Delete1Click(Sender: TObject);
begin
  InvoiceItemDelete;
end;

procedure TInvoiceTaskEditF.DeleteInvoiceItemFromGrid(AIDList: TIDList4Invoice);
begin
  DeleteFilesFromID(AIDList.TaskId, AIDList.ItemId);
  DeleteInvoiceItemFromID(AIDList.ItemId);
end;

procedure TInvoiceTaskEditF.DeleteNAddInvoiceItemNFileFromGrid(AGrid: TNextGrid;
  AIndex: Integer; AIDList: TIDList4Invoice);
begin
  DeleteInvoiceItemFromGrid(AIDList);
  AddInvoiceItemFromGrid(AGrid, AIndex, AIDList.TaskID);
end;

procedure TInvoiceTaskEditF.FormCreate(Sender: TObject);
begin
  DOC_DIR := ExtractFilePath(Application.ExeName) + '양식\';
  InvoiceGrid.DoubleBuffered := False;
  CurrencyKind2Combo(CurrencyKindCB);
//  FSQLInvoiceFiles := nil;
end;

procedure TInvoiceTaskEditF.FormDestroy(Sender: TObject);
begin
//  if Assigned(FSQLInvoiceFiles) then
//    FSQLInvoiceFiles.Free;

//  if Assigned(FInvoiceTask) then
//    FreeAndNil(FInvoiceTask);

  ClearTIDList4Grid(InvoiceGrid);
end;

procedure TInvoiceTaskEditF.GetInvoiceItemFromGrid2StrList(AGrid: TNextGrid;
  var AList: TStringList);
var
  i: integer;
  LStr: string;
begin
  AList.Clear;

  for i := 0 to AGrid.RowCount - 1 do
  begin
    if TIDList4Invoice(AGrid.Row[i].Data).UniqueItemID <> '' then
      LStr := TIDList4Invoice(AGrid.Row[i].Data).UniqueItemID
    else
      LStr := NewGUID;

    LStr := StringReplace(LStr, '{', '', [rfReplaceAll]);
    LStr := StringReplace(LStr, '}', '', [rfReplaceAll]);
    LStr := LStr + ';';
    LStr := LStr + TIDList4Invoice(AGrid.Row[i].Data).UniqueSubConID + ';';
    LStr := LStr + AGrid.CellByName['ItemType', i].AsString + ';';
    LStr := LStr + AGrid.CellByName['ItemDesc', i].AsString + ';';
    LStr := LStr + AGrid.CellByName['Qty', i].AsString + ';';
    LStr := LStr + AGrid.CellByName['AUnit', i].AsString + ';';
    LStr := LStr + AGrid.CellByName['UnitPrice', i].AsString + ';';
    LStr := LStr + AGrid.CellByName['ExchangeRate', i].AsString + ';';
    LStr := LStr + AGrid.CellByName['TotalPrice', i].AsString + ';';
    LStr := LStr + AGrid.CellByName['EngineerKind', i].AsString;

    AList.Add(LStr);
  end;
end;

procedure TInvoiceTaskEditF.GetInvoiceItemFromObjList2StrList(
  AItemList: TObjectList<TSQLInvoiceItem>; var AList: TStringList);
var
  i: integer;
  LStr: string;
  LItem: TSQLInvoiceItem;
begin
  for i := 0 to AItemList.Count - 1 do
  begin
    LItem := AItemList.Items[i];

    LStr := LItem.UniqueItemID + ';';
    LStr := LStr + GSInvoiceItemType2String(LItem.InvoiceItemType) + ';';
    LStr := LStr + LItem.InvoiceItemDesc + ';';
    LStr := LStr + LItem.Qty + ';';
    LStr := LStr + LItem.fUnit + ';';
    LStr := LStr + LItem.UnitPrice + ';';
    LStr := LStr + LItem.ExchangeRate + ';';
    LStr := LStr + LItem.TotalPrice + ';';
    LStr := LStr + EngineerKind2String(LItem.EngineerKind);

    AList.Add(LStr);
  end;
end;

function TInvoiceTaskEditF.GetSQLInvoiceItem(AGrid: TNextGrid;
  ARow: integer; var AInvoiceItem: TSQLInvoiceItem): Boolean;
begin
  if not Assigned(AInvoiceItem) then
    AInvoiceItem := TSQLInvoiceItem.Create;

  if TIDList4Invoice(AGrid.Row[ARow].Data).UniqueItemID <> '' then
    AInvoiceItem.UniqueItemID := TIDList4Invoice(AGrid.Row[ARow].Data).UniqueItemID
  else
    AInvoiceItem.UniqueItemID := NewGUID;

  AInvoiceItem.UniqueSubConID := TIDList4Invoice(AGrid.Row[ARow].Data).UniqueSubConID;
  AInvoiceItem.InvoiceItemDesc := AGrid.CellByName['ItemDesc', ARow].AsString;
  AInvoiceItem.Qty := AGrid.CellByName['Qty', ARow].AsString;
  AInvoiceItem.fUnit := AGrid.CellByName['AUnit', ARow].AsString;
  AInvoiceItem.UnitPrice := AGrid.CellByName['UnitPrice', ARow].AsString;
  AInvoiceItem.ExchangeRate := AGrid.CellByName['ExchangeRate', ARow].AsString;
  AInvoiceItem.TotalPrice := AGrid.CellByName['TotalPrice', ARow].AsString;
  AInvoiceItem.InvoiceItemType := String2GSInvoiceItemType(AGrid.CellByName['ItemType', ARow].AsString);
  AInvoiceItem.EngineerKind := String2EngineerKind(AGrid.CellByName['EngineerKind', ARow].AsString);
//  AInvoiceItem.UniqueItemID := AGrid.CellByName['UniqueItemID', ARow].AsString;

//  if AInvoiceItem.UniqueItemID = '' then
//    AInvoiceItem.UniqueItemID := NewGUID;
end;

function TInvoiceTaskEditF.GetTotalPrice: integer;
var
  i, LPrice: integer;
begin
  for i := 0 to InvoiceGrid.RowCount - 1 do
  begin
    LPrice := LPrice + InvoiceGrid.CellByName['TotalPrice', i].AsInteger;
  end;

  SalesPriceEdit.Value := LPrice;
end;

function TInvoiceTaskEditF.Get_Doc_Inv_Rec: Doc_Invoice_Rec;
begin
  Result.FCustomerInfo := CustomerAddressMemo.Text;
  Result.FCustomerInfo := Result.FCustomerInfo.Replace(#13, '');
  Result.FInvNo := OrderNoEdit.Text;
  Result.FHullNo := HullNoEdit.Text;
  Result.FShipName := ShipNameEdit.Text;
  Result.FSubject := SubjectEdit.Text;
  Result.FPONo := ServicePOEdit.Text;
  Result.FOnboardDate := AttendSchedulePicker.Date;
  Result.FTotalPrice := '₩' + system.SysUtils.FormatFloat('###,###,##0', SalesPriceEdit.Value);
  Result.FInvoiceItemList := TStringList.Create;
end;

function TInvoiceTaskEditF.SaveInvoiceItemFromForm(AForm: TInvoiceTaskEditF): Boolean;
var
  i: integer;
  LIDList: TIDList4Invoice;
begin
  Result := AForm.InvoiceGrid.RowCount > 0;

  for i := 0 to AForm.InvoiceGrid.RowCount - 1 do
  begin
    LIDList := TIDList4Invoice(AForm.InvoiceGrid.Row[i].Data);

    case LIDList.ItemAction of
      0:  DeleteNAddInvoiceItemNFileFromGrid(AForm.InvoiceGrid, i, LIDList);//Delete and Add
      1:  AddInvoiceItemFromGrid(AForm.InvoiceGrid, i, LIDList.fTaskId);//Add
      2:  DeleteInvoiceItemFromGrid(LIDList);//Delete
      3:  UpdateInvoiceItemFromGrid(AForm.InvoiceGrid, i, LIDList);//Update
    end;
  end;
end;

procedure TInvoiceTaskEditF.LoadForm2InvoiceTask(AForm: TInvoiceTaskEditF;
  out ATask: TSQLInvoiceTask);
begin
  ATask.HullNo := HullNoEdit.Text;
  ATask.ShipName := ShipNameEdit.Text;
  ATask.Order_No := OrderNoEdit.Text;
  ATask.PO_No := PONoEdit.Text;
  ATask.WorkSummary := SubjectEdit.Text;
  ATask.ShipOwner := ShipOwnerEdit.Text;
  ATask.NationPort := NationPortEdit.Text;
  ATask.EtcContent := EtcContentMemo.Text;
  ATask.InvoicePrice := SalesPriceEdit.Text;
  ATask.ExchangeRate := ExchangeRateEdit.Text;
  ATask.CurrencyKind := String2CurrencyKind(CurrencyKindCB.Text);
  ATask.CustCompanyName := CustomerNameEdit.Text;
  ATask.CustCompanyCode := CustCompanyCodeEdit.Text;
  ATask.CustManagerName := CustManagerEdit.Text;
  ATask.CustPosition := CustPositionEdit.Text;
  ATask.CustEMail := CustEmailEdit.Text;
  ATask.CustNation := NationEdit.Text;
  ATask.CustOfficePhone := CustPhonNumEdit.Text;
  ATask.CustMobilePhone := CustFaxEdit.Text;
  ATask.CustCompanyAddress := CustomerAddressMemo.Text;
  ATask.CustAgentInfo := CustAgentMemo.Text;

  ATask.SubConCompanyName := SubCompanyNameEdit.Text;
  ATask.SubConCompanyCode := SubCompanyCodeEdit.Text;
  ATask.SubConInvoiceNo := ServicePOEdit.Text;
  ATask.SubConManagerName := SubManagerEdit.Text;
  ATask.SubConPosition := SubPositionEdit.Text;
  ATask.SubConEMail := SubEmailEdit.Text;
  ATask.SubConOfficePhone := SubPhonNumEdit.Text;
  ATask.SubConMobilePhone := SubFaxEdit.Text;
  ATask.SubConCompanyAddress := SubCompanyAddressMemo.Text;
  ATask.UniqueSubConID := UniqueSubConIDEdit.Text;

  ATask.AttendScheduled := TimeLogFromDateTime(AttendSchedulePicker.DateTime);
  ATask.InqRecvDate := TimeLogFromDateTime(InqRecvPicker.DateTime);
//  ATask.InvoiceIssueDate := TimeLogFromDateTime(InvoiceIssuePicker.DateTime);
  ATask.WorkBeginDate := TimeLogFromDateTime(WorkBeginPicker.DateTime);
  ATask.WorkEndDate := TimeLogFromDateTime(WorkEndPicker.DateTime);
  ATask.SEList := SEEdit.Text;
//  ATask.ChargeInPersonId := ChargeInPersonIdEdit.Text;
end;

procedure TInvoiceTaskEditF.LoadInvoiceFile2InvoiceGrid(
  AInvoiceFiles: TSQLInvoiceFile; AGrid: TNextGrid; AIsFromDoc: Boolean);
var
  i: integer;
  LIDList: TIDList4Invoice;
begin
  if AIsFromDoc then
  begin
    for i := 0 to AGrid.RowCount - 1 do
    begin
      LIDList := TIDList4Invoice(AGrid.Row[i].Data);

      if (LIDList.TaskId = AInvoiceFiles.TaskID) and
        (LIDList.ItemId = AInvoiceFiles.ItemID)then
      begin
        TIDList4Invoice(AGrid.Row[i].Data).fInvoiceFile :=
          TSQLInvoiceFile(AInvoiceFiles.CreateCopy);

        AGrid.CellByName['Attachments', i].AsInteger :=
          High(TIDList4Invoice(AGrid.Row[i].Data).fInvoiceFile.Files)+1;
        Break;
      end;
    end;
  end;
end;

procedure TInvoiceTaskEditF.LoadInvoiceFile2InvoiceGrid_(
  AInvoiceFiles: TSQLInvoiceFile; AGrid: TNextGrid; ARow: integer);
var
  j,LCount: integer;
  LIndex: integer;
begin
  LIndex := ARow;
  LCount := 0;

//  if AInvoiceFiles.FillRewind then
//  begin
    if AInvoiceFiles.FillOne then
    begin
//      if LIndex = AInvoiceFiles.ItemIndex then
      if Assigned(TIDList4Invoice(AGrid.Row[ARow].Data).fInvoiceFile) then
        FreeAndNil(TIDList4Invoice(AGrid.Row[ARow].Data).fInvoiceFile);

        TIDList4Invoice(AGrid.Row[ARow].Data).fInvoiceFile :=
          TSQLInvoiceFile(AInvoiceFiles.CreateCopy);
    end;
//  end;

  AGrid.CellByName['Attachments', ARow].AsInteger :=
    High(TIDList4Invoice(AGrid.Row[ARow].Data).fInvoiceFile.Files)+1;
end;

procedure TInvoiceTaskEditF.LoadInvoiceFileCount2Grid(
  AInvoiceFiles: TSQLInvoiceFile; AGrid: TNextGrid; ARow: integer);
begin
  TNxButtonColumn(InvoiceGrid.ColumnByName['Attachments']).Editor.Text := IntToStr(High(AInvoiceFiles.Files) + 1);
end;

procedure TInvoiceTaskEditF.LoadInvoiceFileCount2Grid_(
  AInvoiceFiles: TSQLInvoiceFile; AGrid: TNextGrid; ARow: integer);
var
  j,LCount: integer;
  LIndex: integer;
begin
//  LIndex := TIDList4Invoice(AGrid.Row[ARow].Data).fItemIndex;
  LCount := 0;

  if AInvoiceFiles.FillRewind then
  begin
    while AInvoiceFiles.FillOne do
    begin
      if LIndex = AInvoiceFiles.ItemIndex then
        TIDList4Invoice(AGrid.Row[ARow].Data).fInvoiceFile :=
          TSQLInvoiceFile(AInvoiceFiles.CreateCopy);

      for j := Low(AInvoiceFiles.Files) to High(AInvoiceFiles.Files) do
      begin
        if LIndex = AInvoiceFiles.ItemIndex then
          Inc(LCount);
      end;
    end;
  end;

  AGrid.CellByName['Attachments', ARow].AsInteger := LCount;
end;

procedure TInvoiceTaskEditF.LoadInvoiceFileList2Form(
  AFileList: TObjectList<TSQLInvoiceFile>; AForm: TInvoiceTaskEditF);
var
  i: integer;
  LFile: TSQLInvoiceFile;
begin
  for i := 0 to AFileList.Count - 1 do
  begin
    LFile := AFileList.Items[i];
    LoadInvoiceFile2InvoiceGrid(LFile, AForm.InvoiceGrid, True);
  end;
end;

procedure TInvoiceTaskEditF.LoadInvoiceItem2Form(AInvoiceItem: TSQLInvoiceItem;
  AForm: TInvoiceTaskEditF; AIsFromDoc: Boolean);
begin
  //InvoiceGrid에서 더블클릭 한 경우 = AIsFromDoc : False
  //*.hgs 을 InvoiceGrid에 Drop 한 경우 = AIsFromDOc : True;
  InvoiceGrid.BeginUpdate;
  try
    if AIsFromDoc then
    begin
      FItemID := AInvoiceItem.ID;
      LoadInvoiceItem2Grid(AInvoiceItem, AForm.InvoiceGrid, AIsFromDoc);
    end
    else
    begin
      if AInvoiceItem.FillRewind then
      begin
        ClearTIDList4Grid(AForm.InvoiceGrid);
        AForm.InvoiceGrid.ClearRows;

        while AInvoiceItem.FillOne do
        begin
          FItemID := AInvoiceItem.ID;
          LoadInvoiceItem2Grid(AInvoiceItem, AForm.InvoiceGrid);
        end;
      end;
    end;
  finally
    InvoiceGrid.EndUpdate();
  end;
end;

procedure TInvoiceTaskEditF.LoadInvoiceItem2Grid(AInvoiceItem: TSQLInvoiceItem;
  AGrid: TNextGrid; AIsFromDoc: Boolean);
var
  LIds: TIDDynArray;
  i, LRow, LAction: integer;
  LInvoiceFiles: TSQLInvoiceFile;
begin
  if not Assigned(AInvoiceItem) then
    exit;

  with AGrid do
  begin
    BeginUpdate;
    try
      with AInvoiceItem do
      begin
        LRow := AddRow;
        CellByName['ItemType', LRow].AsString := GSInvoiceItemType2String(InvoiceItemType);
        CellByName['ItemDesc', LRow].AsString := InvoiceItemDesc;
        CellByName['Qty', LRow].AsString := Qty;
        CellByName['AUnit', LRow].AsString := fUnit;
        CellByName['UnitPrice', LRow].AsString := UnitPrice;
        CellByName['ExchangeRate', LRow].AsString := ExchangeRate;
        CellByName['TotalPrice', LRow].AsString := TotalPrice;
        CellByName['EngineerKind', LRow].AsString := EngineerKind2String(EngineerKind);
        CellByName['UniqueItemID', LRow].AsString := UniqueItemID;

        InvoiceGrid.Row[LRow].Data := TIDList4Invoice.Create;
        TIDList4Invoice(InvoiceGrid.Row[LRow].Data).InvoiceFile := TSQLInvoiceFile.Create;
        TIDList4Invoice(InvoiceGrid.Row[LRow].Data).TaskId := TaskID;
        TIDList4Invoice(InvoiceGrid.Row[LRow].Data).ItemID := ItemID;
        TIDList4Invoice(InvoiceGrid.Row[LRow].Data).UniqueItemID := UniqueItemID;
        TIDList4Invoice(InvoiceGrid.Row[LRow].Data).UniqueSubConID := UniqueSubConID;

        if AIsFromDoc then
          LAction := 0//Delete and Add
        else
          LAction := -1;//No action(Add 또는 Delete 버튼 눌렀을 경우에만 Action이 필요함

        TIDList4Invoice(InvoiceGrid.Row[LRow].Data).ItemAction := LAction;
        TIDList4Invoice(InvoiceGrid.Row[LRow].Data).InvoiceItemType := InvoiceItemType;

        if not AIsFromDoc then
        begin
          LInvoiceFiles := GetFilesFromInvoiceItem(AInvoiceItem);
          try
            LoadInvoiceFile2InvoiceGrid_(LInvoiceFiles, AGrid, LRow);
        //    LoadInvoiceFileCount2Grid(LInvoiceFiles, AForm.InvoiceGrid);
          finally
            FreeAndNil(LInvoiceFiles);
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;//With
end;

procedure TInvoiceTaskEditF.LoadInvoiceItemFromVar2Form(ADoc: variant; AForm: TInvoiceTaskEditF);
var
  LInvoiceFile: TSQLInvoiceFile;
  LItemList: TObjectList<TSQLInvoiceItem>;
  LFileList: TObjectList<TSQLInvoiceFile>;
  i: integer;
begin //*.hgs 을 InvoiceGrid에 Drop 한 경우
  if ADoc.InvoiceTaskJsonDragSign <> INVOICETASK_JSON_DRAG_SIGNATURE then
    exit;

  LItemList := TObjectList<TSQLInvoiceItem>.Create;
  LFileList := TObjectList<TSQLInvoiceFile>.Create;
  try
    LoadInvoiceItemListFromVariant(ADoc.InvoiceItem, LItemList);
    LoadInvoiceItemList2Form(LItemList, AForm);

    LoadInvoiceFileListFromVariantWithSQLInvoiceFile(ADoc.InvoiceFile, LFileList);
    LoadInvoiceFileList2Form(LFileList, AForm);
  finally
//    for i := 0 to LItemList.Count - 1 do
//      TSQLInvoiceItem(LItemList[i]).Free;
    LFileList.Clear;
    LFileList.Free;
    LItemList.Clear;
    LItemList.Free;
  end;
end;

procedure TInvoiceTaskEditF.LoadInvoiceItemList2Form(
  AItemList: TObjectList<TSQLInvoiceItem>; AForm: TInvoiceTaskEditF);
var
  i: integer;
  LItem: TSQLInvoiceItem;
begin
  ClearTIDList4Grid(AForm.InvoiceGrid);
  AForm.InvoiceGrid.ClearRows;

  for i := 0 to AItemList.Count - 1 do
  begin
    LItem := AItemList.Items[i];
    LoadInvoiceItem2Form(LItem, AForm, True);
  end;
end;

procedure TInvoiceTaskEditF.LoadInvoiceTask2Form(ATask: TSQLInvoiceTask;
  AForm: TInvoiceTaskEditF; ADoc: variant);
var
  LInvoiceItem: TSQLInvoiceItem;
begin
  HullNoEdit.Text := ATask.HullNo;
  ShipNameEdit.Text := ATask.ShipName;
  OrderNoEdit.Text := ATask.Order_No;
  PONoEdit.Text := ATask.PO_No;
  SubjectEdit.Text := ATask.WorkSummary;
  ShipOwnerEdit.Text := ATask.ShipOwner;
  NationPortEdit.Text := ATask.NationPort;
  EtcContentMemo.Text := ATask.EtcContent;
  SalesPriceEdit.Text := ATask.InvoicePrice;
  ExchangeRateEdit.Text := ATask.ExchangeRate;

  CustomerNameEdit.Text := ATask.CustCompanyName;
  CustCompanyCodeEdit.Text := ATask.CustCompanyCode;
  CustManagerEdit.Text := ATask.CustManagerName;
  CustPositionEdit.Text := ATask.CustPosition;
  CustEmailEdit.Text := ATask.CustEMail;
  NationEdit.Text := ATask.CustNation;
  CustPhonNumEdit.Text := ATask.CustOfficePhone;
  CustFaxEdit.Text := ATask.CustMobilePhone;
  CustomerAddressMemo.Text := ATask.CustCompanyAddress;
  CustAgentMemo.Text := ATask.CustAgentInfo;

  SubCompanyNameEdit.Text := ATask.SubConCompanyName;
  SubCompanyCodeEdit.Text := ATask.SubConCompanyCode;
  ServicePOEdit.Text := ATask.SubConInvoiceNo;
  SubManagerEdit.Text := ATask.SubConManagerName;
  SubPositionEdit.Text := ATask.SubConPosition;
  SubEmailEdit.Text := ATask.SubConEMail;
  SubPhonNumEdit.Text := ATask.SubConOfficePhone;
  SubFaxEdit.Text := ATask.SubConMobilePhone;
  SubCompanyAddressMemo.Text := ATask.SubConCompanyAddress;
  UniqueSubConIDEdit.Text := ATask.UniqueSubConID;

  CurrencyKindCB.ItemIndex := Ord(ATask.CurrencyKind);
  AttendSchedulePicker.DateTime := TimeLogToDateTime(ATask.AttendScheduled);
  InqRecvPicker.DateTime := TimeLogToDateTime(ATask.InqRecvDate);
//  InvoiceIssuePicker.DateTime := TimeLogToDateTime(ATask.InvoiceIssueDate);
  WorkBeginPicker.DateTime := TimeLogToDateTime(ATask.WorkBeginDate);
  WorkEndPicker.DateTime := TimeLogToDateTime(ATask.WorkEndDate);
  SEEdit.Text := ATask.SEList;
//  ChargeInPersonIdEdit.Text := ATask.ChargeInPersonId;

  if ADoc = null then
  begin
    try
      LInvoiceItem := GetItemsFromInvoiceTask(ATask);
      LoadInvoiceItem2Form(LInvoiceItem, AForm);
    finally
      FreeAndNil(LInvoiceItem);
    end;
  end
  else //InvoiceManage.exe에서 만들어진 *.hgs 파일인 경우
  begin//InvoiceItem 및 InvoiceFile도 포함됨
    LoadInvoiceItemFromVar2Form(ADoc, AForm);
  end;
end;

procedure TInvoiceTaskEditF.LoadInvoiceTask2Grid(ATask: TSQLInvoiceTask;
  AGrid: TNextGrid; ARow: integer);
begin
  with AGrid do
  begin
    CellByName['HullNo', ARow].AsString := ATask.HullNo;
    CellByName['ShipName', ARow].AsString := ATask.ShipName;
    CellByName['OrderNo', ARow].AsString := ATask.Order_No;

    CellByName['RecvDate', ARow].AsDateTime := TimeLogToDateTime(ATask.InqRecvDate);
    CellByName['InvoiceInputDate', ARow].AsDateTime := TimeLogToDateTime(ATask.InvoiceIssueDate);
  end;
end;

procedure TInvoiceTaskEditF.AttachmentsButtonClick(Sender: TObject);
begin
  ShowFileListForm;
end;

procedure TInvoiceTaskEditF.InvoiceEnglish1Click(Sender: TObject);
var
  LRec: Doc_Invoice_Rec;
  LStrList: TStringList;
begin
  LRec := Get_Doc_Inv_Rec;
  GetInvoiceItemFromGrid2StrList(InvoiceGrid, LRec.FInvoiceItemList);

  MakeDocInvoice(LRec);
end;

procedure TInvoiceTaskEditF.InvoiceGridAfterEdit(Sender: TObject; ACol,
  ARow: Integer; Value: WideString);
begin
  if InvoiceGrid.CellByName['ItemAction', ARow].AsString <> 'ADD' then
    TIDList4Invoice(InvoiceGrid.Row[ARow].Data).ItemAction := 3; //Update
end;

procedure TInvoiceTaskEditF.InvoiceItemAdd;
var
  LRow: integer;
//  LSQLItemRec: TSQLInvoiceItemRec;
begin
  LRow := InvoiceGrid.AddRow;
  InvoiceGrid.Row[LRow].Data := TIDList4Invoice.Create;
  TIDList4Invoice(InvoiceGrid.Row[LRow].Data).InvoiceFile := TSQLInvoiceFile.Create;
  TIDList4Invoice(InvoiceGrid.Row[LRow].Data).UniqueItemID := NewGUID;
  TIDList4Invoice(InvoiceGrid.Row[LRow].Data).UniqueSubConID := UniqueSubConIDEdit.Text;
  TIDList4Invoice(InvoiceGrid.Row[LRow].Data).InvoiceFile.UniqueInvoiceFileID := NewGUID;
  TIDList4Invoice(InvoiceGrid.Row[LRow].Data).TaskId := FInvoiceTask.ID;
  TIDList4Invoice(InvoiceGrid.Row[LRow].Data).ItemId := -1;
  TIDList4Invoice(InvoiceGrid.Row[LRow].Data).ItemAction := 1; //Add
  TIDList4Invoice(InvoiceGrid.Row[LRow].Data).InvoiceItemType := iitWork_Week_N;
  InvoiceGrid.CellByName['ItemType', LRow].AsString :=
    GSInvoiceItemType2String(iitWork_Week_N);
  InvoiceGrid.CellByName['AUnit', LRow].AsString := 'Day';
  InvoiceGrid.CellByName['EngineerKind', LRow].AsString := EngineerKind2String(ekServiceEngineer);
  InvoiceGrid.CellByName['UniqueItemID', LRow].AsString := NewGUID;
  InvoiceGrid.CellByName['ItemAction', LRow].AsString := 'ADD';

  if ExchangeRateEdit.Text <> '' then
    InvoiceGrid.CellByName['ExchangeRate', LRow].AsString := ExchangeRateEdit.Text
  else
    InvoiceGrid.CellByName['ExchangeRate', LRow].AsString := '1.0';
end;

procedure TInvoiceTaskEditF.InvoiceItemDelete;
var
  LRow: integer;
//  LID: TID;
begin
  LRow := InvoiceGrid.SelectedRow;

  if LRow = -1 then
    exit;

  if MessageDlg('선택한 Invoice Item을 삭제 하시겠습니까?', mtConfirmation, [mbYes, mbNo],0) = mrNo then
    exit;

//  LID := TIDList4Invoice(InvoiceGrid.Row[LRow].Data).ItemId;

//  FSQLInvoiceFiles.FillRewind;
//
//  while FSQLInvoiceFiles.FillOne do
//  begin
//    if LID = FSQLInvoiceFiles.ItemID then
//    begin
//      FSQLInvoiceFiles.DynArray('Files').Clear;
//      FSQLInvoiceFiles.ClearProperties;
//    end;
//  end;

//  FSQLInvoiceItem.DynArray('Items').Delete(LRow);
//  TIDList4Invoice(InvoiceGrid.Row[LRow].Data).InvoiceFile.Free;
//  TIDList4Invoice(InvoiceGrid.Row[LRow].Data).Free;
  TIDList4Invoice(InvoiceGrid.Row[LRow].Data).ItemAction := 2; //Delete
  InvoiceGrid.BeginUpdate;
  try
    InvoiceGrid.Row[LRow].Visible := False;
  finally
    InvoiceGrid.EndUpdate;
  end;
//  InvoiceGrid.DeleteRow(LRow);
end;

procedure TInvoiceTaskEditF.ItemTypeSelect(Sender: TObject);
var
  LItemType: TGSInvoiceItemType;
  LRow: integer;
  LStr: string;
begin
  LRow := InvoiceGrid.SelectedRow;

  if LRow > -1 then
  begin
    if not Assigned(InvoiceGrid.Row[LRow].Data) then
    begin
      InvoiceGrid.Row[LRow].Data := TIDList4Invoice.Create;
      TIDList4Invoice(InvoiceGrid.Row[LRow].Data).TaskId := FInvoiceTask.ID;
      TIDList4Invoice(InvoiceGrid.Row[LRow].Data).InvoiceFile := TSQLInvoiceFile.Create;
    end;

//    LStr := InvoiceGrid.CellByName['Items',LRow].AsString;
    LStr := TNxComboBox(TNxComboBoxColumn(InvoiceGrid.ColumnByName['ItemType']).Editor).Text;
    LItemType := String2GSInvoiceItemType(LStr);

    if (LItemType = iitWork_Week_N) or (LItemType = iitWork_Holiday_N) then
      InvoiceGrid.CellByName['AUnit', LRow].AsString := 'Day'
    else
      InvoiceGrid.CellByName['AUnit', LRow].AsString := 'Set';

    TIDList4Invoice(InvoiceGrid.Row[LRow].Data).InvoiceItemType := LItemType;
  end;
end;

procedure TInvoiceTaskEditF.ShowFileListForm;
var
  LFileListF: TFileListF;
  LRow: integer;
  LIDList4Invoice: TIDList4Invoice;
  LSQLInvoiceFile: TSQLInvoiceFile;
begin
  LRow := InvoiceGrid.SelectedRow;

  if LRow > -1 then
  begin
    LFileListF := TFileListF.Create(nil);
    try
      LIDList4Invoice := TIDList4Invoice(InvoiceGrid.Row[LRow].Data);
      LFileListF.FInvoiceFiles_ := TSQLInvoiceFile(LIDList4Invoice.fInvoiceFile.CreateCopy);
      LFileListF.LoadFiles2Grid(LIDList4Invoice);

      if LFileListF.ShowModal = mrOK then
      begin
        if Assigned(TIDList4Invoice(InvoiceGrid.Row[LRow].Data).fInvoiceFile) then
          TIDList4Invoice(InvoiceGrid.Row[LRow].Data).fInvoiceFile.Free;

        LSQLInvoiceFile := TSQLInvoiceFile(LFileListF.FInvoiceFiles_.CreateCopy);
        TIDList4Invoice(InvoiceGrid.Row[LRow].Data).fInvoiceFile := LSQLInvoiceFile;
        LSQLInvoiceFile.UniqueItemID := TIDList4Invoice(InvoiceGrid.Row[LRow].Data).UniqueItemID;
        LoadInvoiceFileCount2Grid(LSQLInvoiceFile, InvoiceGrid, LRow);
      end;
    finally
      LFileListF.Free;
    end;
  end;
end;

procedure TInvoiceTaskEditF.TotalPriceButtonClick(Sender: TObject);
var
  LRow, LNumOfWorker, LQty, LUnitPrice: integer;
  LGSInvoiceItemType: TGSInvoiceItemType;
begin
  LRow := InvoiceGrid.SelectedRow;
  LGSInvoiceItemType := String2GSInvoiceItemType(InvoiceGrid.CellsByName['ItemType', LRow]);
  LNumOfWorker := 1;

  if (LGSInvoiceItemType = iitWork_Week_N) or (LGSInvoiceItemType = iitWork_Week_OT) or
     (LGSInvoiceItemType = iitWork_Holiday_N) or (LGSInvoiceItemType = iitWork_Holiday_OT) or
     (LGSInvoiceItemType = iitTravellingHours)then
  begin
    LNumOfWorker := StrToIntDef(InvoiceGrid.CellsByName['ItemDesc', LRow],1);
  end;

  LQty := StrToIntDef(InvoiceGrid.CellsByName['Qty', LRow],1);
  LUnitPrice := StrToIntDef(InvoiceGrid.CellsByName['UnitPrice', LRow],1);
  TNxButtonColumn(InvoiceGrid.ColumnByName['TotalPrice']).Editor.Text :=
    IntToStr(LNumOfWorker*LQty*LUnitPrice);

end;

procedure TInvoiceTaskEditF.UpdateInvoiceItemFromGrid(AGrid: TNextGrid;
  AIndex: Integer; AIDList: TIDList4Invoice);
var
  LInvoiceItem: TSQLInvoiceItem;
begin
  LInvoiceItem := GetInvoiceItemFromUniqueID(AIDList.UniqueItemID);
  try
    if LInvoiceItem.IsUpdate then
    begin
      GetSQLInvoiceItem(AGrid, AIndex, LInvoiceItem);
      LInvoiceItem.IsUpdate := True;

      AddOrUpdateInvoiceItem(LInvoiceItem);
      UpdateInvoiceFileFromGridRow(AGrid, AIndex, LInvoiceItem);
    end
    else//Task는 Update이지만 InvoiceItem은 추가 될 수 있음
    begin
      AddInvoiceItemFromGrid(AGrid, AIndex, AIDList.TaskId);
    end;
  finally
    FreeAndNil(LInvoiceItem);
  end;
end;

procedure TInvoiceTaskEditF.UpdateItemID2InvoiceGrid(AItemID: TID;
  AUniqueItemID: RawUTF8; AGrid: TNextGrid; AIndex: Integer);
//var
//  i: integer;
begin
//  for i := 0 to AGrid.RowCount - 1 do
  TIDList4Invoice(AGrid.Row[AIndex].Data).ItemId := AItemID;
  TIDList4Invoice(AGrid.Row[AIndex].Data).UniqueItemID := AUniqueItemID;
end;

procedure TInvoiceTaskEditF.UpdateTaskID2InvoiceGrid(ATaskID: TID;
  AGrid: TNextGrid);
var
  i: integer;
begin
  for i := 0 to AGrid.RowCount - 1 do
  begin
    TIDList4Invoice(AGrid.Row[i].Data).TaskId := ATaskID;
    TIDList4Invoice(AGrid.Row[i].Data).ItemAction := 1;//add
  end;
end;

end.
