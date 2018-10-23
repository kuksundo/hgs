unit FrmSubCompanyEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, AdvEdit,
  AdvEdBtn, JvExControls, JvLabel, Vcl.ExtCtrls, Generics.Collections,
  SynCommons, mORMot,
  FrmSearchCustomer, CommonData, AeroButtons, NxColumnClasses,
  {$IFDEF GAMANAGER}
  UnitGAMasterRecord,
  {$ELSE}
  UElecDataRecord,
  {$ENDIF}
  NxColumns, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid,
  Vcl.Mask, JvExMask, JvToolEdit, JvBaseEdits, AdvGroupBox, AdvOfficeButtons;

type
  TSubCompanyEditF = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    AeroButton1: TAeroButton;
    btn_Close: TAeroButton;
    Panel3: TPanel;
    JvLabel15: TJvLabel;
    JvLabel16: TJvLabel;
    JvLabel48: TJvLabel;
    JvLabel18: TJvLabel;
    JvLabel46: TJvLabel;
    JvLabel19: TJvLabel;
    Label1: TLabel;
    JvLabel35: TJvLabel;
    JvLabel54: TJvLabel;
    JvLabel53: TJvLabel;
    JvLabel52: TJvLabel;
    JvLabel23: TJvLabel;
    JvLabel68: TJvLabel;
    JvLabel42: TJvLabel;
    JvLabel43: TJvLabel;
    JvLabel17: TJvLabel;
    SubCompanyEdit: TAdvEditBtn;
    Button4: TButton;
    SubCompanyCodeEdit: TEdit;
    ServicePOEdit: TEdit;
    SubManagerEdit: TEdit;
    PositionEdit: TEdit;
    SEEdit: TEdit;
    SECountEdit: TEdit;
    SubConPriceEdit: TEdit;
    SRRecvDatePicker: TDateTimePicker;
    SubConInvoiceIssuePicker: TDateTimePicker;
    SubEmailEdit: TEdit;
    SubConNationEdit: TEdit;
    SubPhonNumEdit: TEdit;
    SubFaxEdit: TEdit;
    SubCompanyAddressMemo: TMemo;
    Splitter1: TSplitter;
    Panel4: TPanel;
    JvLabel61: TJvLabel;
    JvLabel59: TJvLabel;
    CurrencyKindCB: TComboBox;
    SalesPriceEdit: TJvCalcEdit;
    InvoiceGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    ItemType: TNxComboBoxColumn;
    ItemDesc: TNxTextColumn;
    Qty: TNxTextColumn;
    AUnit: TNxTextColumn;
    UnitPrice: TNxTextColumn;
    ExchangeRate: TNxTextColumn;
    TotalPrice: TNxButtonColumn;
    Attachments: TNxButtonColumn;
    EngineerKind: TNxTextColumn;
    JvLabel36: TJvLabel;
    WorkBeginPicker: TDateTimePicker;
    Label2: TLabel;
    JvLabel37: TJvLabel;
    WorkEndPicker: TDateTimePicker;
    JvLabel1: TJvLabel;
    SubConInvoiceNoEdit: TEdit;
    UniqueItemID: TNxTextColumn;
    UniqueSubConIDEdit: TEdit;
    BusinessAreaGrp: TAdvOfficeCheckGroup;
    JvLabel2: TJvLabel;
    JvLabel3: TJvLabel;
    ProductTypesEdit: TAdvEditBtn;
    JvLabel4: TJvLabel;
    CompanyTypeGrp: TAdvOfficeCheckGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SubCompanyEditClickBtn(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure AttachmentsButtonClick(Sender: TObject);
    procedure ProductTypesEditClickBtn(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
  private
    procedure ClearTIDList4Grid;
    procedure ShowFileListForm;
    procedure LoadSubConInvoiceFileFromVar2Grid(ADoc: variant);
    procedure LoadSubConInvoiceFileList2Grid(AFileList: TObjectList<TSQLSubConInvoiceFile>);
    procedure LoadSubConInvoiceFile2InvoiceGrid(AInvoiceFiles: TSQLSubConInvoiceFile;
      AIsFromDoc: Boolean = False);
    procedure LoadInvoiceFileCount2Grid(AInvoiceFiles: TSQLInvoiceFile;
      AGrid: TNextGrid; ARow: integer);
    procedure SetCompanyTypes2Grp;
    function GetCompanyTypesFromGrp: TCompanyTypes;
  public
    FTask: TSQLGSTask;

    procedure SaveSubConEdit2MasterCustomer;
    procedure SaveSubContractEdit2MasterSubContract(AMCustomer: TSQLMasterCustomer);
    procedure LoadTaskForm2MasterSubContractor(var ACustomer: TSQLMasterCustomer;
      ATaskID: TID);

    procedure LoadSQLSubCon2EditForm(ASubCon: TSQLSubCon);
    procedure LoadEditForm2SQLSubCon(var ASubCon: TSQLSubCon);
    procedure LoadEditFormFromVar(ADoc: variant);
    procedure LoadSQLSubConInvoiceItem2EditFormGrid(ASubConInvoiceItem: TSQLSubConInvoiceItem);
    procedure LoadInvoiceItemFromVar2Grid(ADocItem, ADocFile: variant);
  end;

//---DisplaySubCompanyEditForm()함수 실행 시점
//1. InvoiceManage에서 생성된 파일을 마우스로 InqManage에 DropDown 했을때
function DisplaySubCompanyEditForm(var ASubConID: TID; ADoc: variant): Boolean;

var
  SubCompanyEditF: TSubCompanyEditF;

implementation

uses FrmFileList, FrmSelectProductType,
  {$IFDEF GAMANAGER} UnitGAServiceData, UnitGAVarJsonUtil,
  {$ELSE} UnitElecServiceData, UnitVariantJsonUtil,
  {$ENDIF}
  UnitAdvComponentUtil, UnitGSTriffData;

{$R *.dfm}

function DisplaySubCompanyEditForm(var ASubConID: TID; ADoc: variant): Boolean;
var
  LSubCompanyEditF: TSubCompanyEditF;
  LSubCon: TSQLSubCon;
  LSubConInvoiceItem: TSQLSubConInvoiceItem;
begin
  LSubCompanyEditF := TSubCompanyEditF.Create(nil);
  try
    LSubCon := GetSubConFromSubConID(ASubConID);
    try
      if ADoc <> null then //1번 실행 시점의 경우
        LoadSubConFromVariant(LSubCon, ADoc, False);

      if (LSubCon.IsUpdate) or (ADoc <> null) then
        LSubCompanyEditF.LoadSQLSubCon2EditForm(LSubCon);

      LSubConInvoiceItem := GetSubConInvoiceItemFromSubConID(ASubConID);
      try
        if LSubConInvoiceItem.IsUpdate then
          LSubCompanyEditF.LoadSQLSubConInvoiceItem2EditFormGrid(LSubConInvoiceItem);

        Result := LSubCompanyEditF.ShowModal = mrOK;

        if Result then
        begin
          LSubCompanyEditF.LoadEditForm2SQLSubCon(LSubCon);
          AddOrUpdateSubCon(LSubCon);

          if not LSubCon.IsUpdate then
          begin
            LSubCon.SubConID := LSubCon.ID;
            LSubCon.IsUpdate := True;
            AddOrUpdateSubCon(LSubCon);
            ASubConID := LSubCon.SubConID;
          end;
        end;
      finally
        LSubConInvoiceItem.Free;
      end;
    finally
      LSubCon.Free;
    end;
  finally
    LSubCompanyEditF.Free;
  end;
end;

procedure TSubCompanyEditF.AttachmentsButtonClick(Sender: TObject);
begin
  ShowFileListForm;
end;

procedure TSubCompanyEditF.btn_CloseClick(Sender: TObject);
begin
  ModalResult := mrClose;
  Close;
end;

procedure TSubCompanyEditF.Button4Click(Sender: TObject);
begin
  if (SubCompanyCodeEdit.Text = '') or (SubCompanyEdit.Text = '') then
  begin
    ShowMessage('회사이름과 업체코드는 필수 입력 항목 입니다.');
    exit;
  end;

  if MessageDlg('Are you sure save to MasterSubContractDB?', mtConfirmation, [mbYes, mbNo],0) = mrYes then
    SaveSubConEdit2MasterCustomer;
end;

procedure TSubCompanyEditF.LoadSubConInvoiceFile2InvoiceGrid(
  AInvoiceFiles: TSQLSubConInvoiceFile; AIsFromDoc: Boolean);
var
  i: integer;
  LIDList: TIDList4Invoice;
begin
  if AIsFromDoc then
  begin
    for i := 0 to InvoiceGrid.RowCount - 1 do
    begin
      LIDList := TIDList4Invoice(InvoiceGrid.Row[i].Data);

      if LIDList.UniqueItemId = AInvoiceFiles.UniqueItemID then
      begin
        TIDList4Invoice(InvoiceGrid.Row[i].Data).fInvoiceFile :=
          TSQLInvoiceFile(AInvoiceFiles.CreateCopy);

        InvoiceGrid.CellByName['Attachments', i].AsInteger :=
          High(TIDList4Invoice(InvoiceGrid.Row[i].Data).fInvoiceFile.Files)+1;
        Break;
      end;
    end;
  end;
end;

procedure TSubCompanyEditF.LoadSubConInvoiceFileFromVar2Grid(ADoc: variant);
var
  LFileList: TObjectList<TSQLSubConInvoiceFile>;
begin
  LFileList := TObjectList<TSQLSubConInvoiceFile>.Create;
  try
    //ADoc로부터 Grid에 파일 저장하기
    LoadSubConInvoiceFileListFromVariant(ADoc, LFileList);
    LoadSubConInvoiceFileList2Grid(LFileList);
  finally
    LFileList.Clear;
    LFileList.Free;
  end;
end;

procedure TSubCompanyEditF.LoadSubConInvoiceFileList2Grid(
  AFileList: TObjectList<TSQLSubConInvoiceFile>);
var
  i: integer;
  LFile: TSQLSubConInvoiceFile;
begin
  for i := 0 to AFileList.Count - 1 do
  begin
    LFile := AFileList.Items[i];
    LoadSubConInvoiceFile2InvoiceGrid(LFile, True);
  end;
end;

procedure TSubCompanyEditF.LoadInvoiceFileCount2Grid(
  AInvoiceFiles: TSQLInvoiceFile; AGrid: TNextGrid; ARow: integer);
begin
  TNxButtonColumn(InvoiceGrid.ColumnByName['Attachments']).Editor.Text := IntToStr(High(AInvoiceFiles.Files) + 1);
end;

procedure TSubCompanyEditF.LoadInvoiceItemFromVar2Grid(ADocItem, ADocFile: variant);
var //ADocItem은 Array형식임 : InvoiceItem:[{},{}...], ADocFile: InvoiveFile:[{},{}...]
  LRow, i, j: integer;
  LData, LData2: RawUTF8;
  LDoc, LDoc2: TDocVariantData;
  LVar, LVar2: variant;
begin
  LData := ADocItem;
  LDoc.InitJSON(LData);

  if ADocFile <> null then
  begin
    LData2 := ADocFile;
    LDoc2.InitJSON(LData2);
  end;

  TDocVariant.New(LVar);

  for i := 0 to LDoc.Count - 1 do
  begin
    LVar := _JSON(LDoc.Value[i]);

    LRow := InvoiceGrid.AddRow();

    InvoiceGrid.CellsByName['ItemType',LRow] := g_GSInvoiceItemType.ToString(LVar.InvoiceItemType);
    InvoiceGrid.CellsByName['ItemDesc',LRow] := LVar.InvoiceItemDesc;
    InvoiceGrid.CellsByName['Qty',LRow] := LVar.Qty;
    InvoiceGrid.CellsByName['AUnit',LRow] := LVar.fUnit;
    InvoiceGrid.CellsByName['UnitPrice',LRow] := LVar.UnitPrice;
    InvoiceGrid.CellsByName['ExchangeRate',LRow] := LVar.ExchangeRate;
    InvoiceGrid.CellsByName['TotalPrice',LRow] := LVar.TotalPrice;
    InvoiceGrid.CellsByName['EngineerKind',LRow] := GSEngineerType2String(TGSEngineerType(LVar.GSEngineerType));
    InvoiceGrid.CellsByName['UniqueItemID',LRow] := LVar.UniqueItemID;

    InvoiceGrid.Row[LRow].Data := TIDList4Invoice.Create;
    TIDList4Invoice(InvoiceGrid.Row[LRow].Data).InvoiceFile := TSQLInvoiceFile.Create;
    TIDList4Invoice(InvoiceGrid.Row[LRow].Data).TaskId := LVar.TaskID;
    TIDList4Invoice(InvoiceGrid.Row[LRow].Data).ItemID := LVar.ItemID;
//    TIDList4Invoice(InvoiceGrid.Row[LRow].Data).UniqueSubConID := LVar.UniqueSubConID;
    TIDList4Invoice(InvoiceGrid.Row[LRow].Data).UniqueItemID := LVar.UniqueItemID;

    for j := 0 to LDoc2.Count - 1 do
    begin
      LVar2 := _JSON(LDoc2.Value[i]);
      if TIDList4Invoice(InvoiceGrid.Row[LRow].Data).UniqueItemID = LVar2.UniqueItemID then
      begin
        LoadSubConInvoiceFileFromVar2Grid(LVar2);
        break;
      end;
    end;
  end;
end;

procedure TSubCompanyEditF.LoadSQLSubCon2EditForm(ASubCon: TSQLSubCon);
var
  LRawUtf8: RawUTF8;
  LVar, LVar2: variant;
//  LInvoiceItem: TDocVariantData;
  i, LItemCount, LRow: integer;
begin
  SubCompanyEdit.Text := ASubCon.CompanyName;
  SubCompanyCodeEdit.Text := ASubCon.CompanyCode;
//  ASubCon.CompanyType := ctSubContractor;
  SubManagerEdit.Text := ASubCon.ManagerName;
  PositionEdit.Text := ASubCon.Position;
  SubPhonNumEdit.Text := ASubCon.OfficePhone;
  SubFaxEdit.Text := ASubCon.MobilePhone;

  SubEmailEdit.Text := ASubCon.EMail;
  SubCompanyAddressMemo.Text := ASubCon.CompanyAddress;
  SubConNationEdit.Text := ASubCon.Nation;
//  ServicePOEdit.Text := ASubCon.SubConInvoiceNo;
  SubConInvoiceNoEdit.Text := ASubCon.SubConInvoiceNo;

  SRRecvDatePicker.Date := TimeLogToDateTime(ASubCon.SRRecvDate);
  SubConInvoiceIssuePicker.Date := TimeLogToDateTime(ASubCon.SubConInvoiceIssueDate);
  WorkBeginPicker.Date := TimeLogToDateTime(ASubCon.SubConWorkBeginDate);
  WorkEndPicker.Date := TimeLogToDateTime(ASubCon.SubConWorkEndDate);

  LRawUtf8 := ASubCon.InvoiceItems;
  LVar := _JSON(LRawUtf8);

  LRawUtf8 := ASubCon.InvoiceFiles;
  LVar2 := _JSON(LRawUtf8);
//  LInvoiceItem.InitJSON(LRawUtf8);
  LoadInvoiceItemFromVar2Grid(LVar, LVar2);
end;

procedure TSubCompanyEditF.LoadSQLSubConInvoiceItem2EditFormGrid(
  ASubConInvoiceItem: TSQLSubConInvoiceItem);
var
  LVar: variant;
  LUtf8: RawUtf8;
begin
//  TDocVariant.New(LVar);
  LUtf8 := ASubConInvoiceItem.GetJSONValues(true, true, soSelect);
  LVar := _JSON(LUtf8);

  LoadInvoiceItemFromVar2Grid(LVar, null);
end;

procedure TSubCompanyEditF.LoadTaskForm2MasterSubContractor(
  var ACustomer: TSQLMasterCustomer; ATaskID: TID);
begin
  ACustomer.CompanyName := SubCompanyEdit.Text;
  ACustomer.CompanyCode := SubCompanyCodeEdit.Text;
  ACustomer.CompanyTypes := GetCompanyTypesFromGrp; //[ctSubContractor];
  ACustomer.ManagerName := SubManagerEdit.Text;
  ACustomer.Position := PositionEdit.Text;
  ACustomer.OfficePhone := SubPhonNumEdit.Text;
  ACustomer.MobilePhone := SubFaxEdit.Text;

  ACustomer.EMail := SubEmailEdit.Text;
  ACustomer.CompanyAddress := SubCompanyAddressMemo.Text;
  ACustomer.Nation := SubConNationEdit.Text;
//    ACustomer.SubConInvoiceNo := ServicePOEdit.Text;
  ACustomer.BusinessAreas := GetBusinessAreasFromGrpComponent(BusinessAreaGrp);
//    ACustomer.ShipProductTypes := SubConGrid.CellsByName['ShipProductTypes', i];
//    ACustomer.Engine2SProductTypes := SubConGrid.CellsByName['Engine2SProductTypes', i];
//    ACustomer.Engine4SProductTypes := SubConGrid.CellsByName['Engine4SProductTypes', i];
//    ACustomer.ElecProductTypes := SubConGrid.CellsByName['ElecProductTypes', i];
  ACustomer.ElecProductDetailTypes := GetElecProductDetailTypesFromCommaString(ProductTypesEdit.Text);
end;

procedure TSubCompanyEditF.ProductTypesEditClickBtn(Sender: TObject);
var
  LStr: string;
  LBusinessAreas: TBusinessAreas;
begin
  LBusinessAreas := GetBusinessAreasFromGrpComponent(BusinessAreaGrp);
  LStr := EditProductType(LBusinessAreas, ProductTypesEdit.Text);

  if LStr <> 'No Change' then
    ProductTypesEdit.Text := LStr;
end;

procedure TSubCompanyEditF.ClearTIDList4Grid;
var
  i: integer;
begin
  for i := 0 to InvoiceGrid.RowCount - 1 do
  begin
    TIDList4Invoice(InvoiceGrid.Row[i].Data).InvoiceFile.Free;
    TIDList4Invoice(InvoiceGrid.Row[i].Data).Free;
  end;
end;

procedure TSubCompanyEditF.FormCreate(Sender: TObject);
begin
  if not Assigned(g_MasterDB) then
  {$IFDEF GAMANAGER}
    InitCompanyMasterClient(Application.ExeName);
  {$ELSE}
    InitMasterClient(Application.ExeName);
  {$ENDIF}

  SetCompanyTypes2Grp;
end;

procedure TSubCompanyEditF.FormDestroy(Sender: TObject);
begin
  ClearTIDList4Grid;
end;

function TSubCompanyEditF.GetCompanyTypesFromGrp: TCompanyTypes;
begin
  Result := [];

  if CompanyTypeGrp.Checked[0] then
    Result := Result + [ctNewCompany];

  if CompanyTypeGrp.Checked[1] then
    Result := Result + [ctMaker];

  if CompanyTypeGrp.Checked[2] then
    Result := Result + [ctOwner];

  if CompanyTypeGrp.Checked[3] then
    Result := Result + [ctAgent];

  if CompanyTypeGrp.Checked[4] then
    Result := Result + [ctCorporation];

  if CompanyTypeGrp.Checked[5] then
    Result := Result + [ctSubContractor];

  if Result = [] then
    Result := [ctSubContractor];
end;

procedure TSubCompanyEditF.LoadEditForm2SQLSubCon(var ASubCon: TSQLSubCon);
var
  i: integer;
  LUtf8, LUtf8_2: RawUTF8;
  LDynUtf8, LDynUtf8_2: TRawUTF8DynArray;
  LDynArr, LDynArr2: TDynArray;

  function MakeInvoiceFileFromGrid_(ARow: integer): string;
  var
    LIDList4Invoice: TIDList4Invoice;
  begin
    LIDList4Invoice := TIDList4Invoice(InvoiceGrid.Row[ARow].Data);
    Result := ObjectToJson(LIDList4Invoice.fInvoiceFile);
//    Result := LIDList4Invoice.fInvoiceFile.GetJSONValues(True, True, soSelect);
  end;

  function MakeInvoiceItemFromGrid_(ARow: integer): string;
  var
    LDoc: Variant;
    LIDList4Invoice: TIDList4Invoice;
  begin
    TDocVariant.New(LDoc, [dvoReturnNullForUnknownProperty]);

    LIDList4Invoice := TIDList4Invoice(InvoiceGrid.Row[ARow].Data);
    LDoc.InvoiceItemType := g_GSInvoiceItemType.ToOrdinal(InvoiceGrid.CellsByName['ItemType', ARow]);
    LDoc.InvoiceItemDesc := InvoiceGrid.CellsByName['ItemDesc', ARow];
    LDoc.Qty := InvoiceGrid.CellsByName['Qty', ARow];
    LDoc.fUnit := InvoiceGrid.CellsByName['AUnit', ARow];
    LDoc.UnitPrice := InvoiceGrid.CellsByName['UnitPrice', ARow];
    LDoc.ExchangeRate := InvoiceGrid.CellsByName['ExchangeRate', ARow];
    LDoc.TotalPrice := InvoiceGrid.CellsByName['TotalPrice', ARow];
    LDoc.EngineerKind := Ord(String2GSEngineerType(InvoiceGrid.CellsByName['EngineerKind', ARow]));
    LDoc.UniqueItemID := InvoiceGrid.CellsByName['UniqueItemID', ARow];
    LDoc.UniqueSubConID := UniqueSubConIDEdit.Text;
    LDoc.TaskID := LIDList4Invoice.TaskId;
    LDoc.ItemID := LIDList4Invoice.ItemId;

    Result := LDoc;
  end;
begin
  ASubCon.CompanyName := SubCompanyEdit.Text;
  ASubCon.CompanyCode := SubCompanyCodeEdit.Text;
//  ASubCon.CompanyType := ctSubContractor;
  ASubCon.ManagerName := SubManagerEdit.Text;
  ASubCon.Position := PositionEdit.Text;
  ASubCon.OfficePhone := SubPhonNumEdit.Text;
  ASubCon.MobilePhone := SubFaxEdit.Text;

  ASubCon.EMail := SubEmailEdit.Text;
  ASubCon.CompanyAddress := SubCompanyAddressMemo.Text;
  ASubCon.Nation := SubConNationEdit.Text;
  ASubCon.BusinessAreas := GetBusinessAreasFromGrpComponent(BusinessAreaGrp);
  ASubCon.ElecProductDetailTypes := GetElecProductDetailTypesFromCommaString(ProductTypesEdit.Text);
//  ServicePOEdit.Text := ASubCon.SubConInvoiceNo;
  ASubCon.SubConInvoiceNo := SubConInvoiceNoEdit.Text;

  ASubCon.SRRecvDate := TimeLogFromDateTime(SRRecvDatePicker.Date);
  ASubCon.SubConInvoiceIssueDate := TimeLogFromDateTime(SubConInvoiceIssuePicker.Date);
  ASubCon.SubConWorkBeginDate := TimeLogFromDateTime(WorkBeginPicker.Date);
  ASubCon.SubConWorkEndDate := TimeLogFromDateTime(WorkEndPicker.Date);

  LDynArr.Init(TypeInfo(TRawUTF8DynArray), LDynUtf8);
  LDynArr2.Init(TypeInfo(TRawUTF8DynArray), LDynUtf8_2);

  for i := 0 to InvoiceGrid.RowCount - 1 do
  begin
    LUtf8 := MakeInvoiceItemFromGrid_(i);
    LDynArr.Add(LUtf8);
    LUtf8_2 := MakeInvoiceFileFromGrid_(i);
    LDynArr2.Add(LUtf8_2);
  end;

  LUtf8 := LDynArr.SaveToJSON;
  ASubCon.InvoiceItems := _JSON(LUtf8);
  LUtf8_2 := LDynArr2.SaveToJSON;
  ASubCon.InvoiceFiles := _JSON(LUtf8_2);
end;

procedure TSubCompanyEditF.LoadEditFormFromVar(ADoc: variant);
var
  LDocItem, LDocFile: variant;
  LElecProductDetailTypes: TElecProductDetailTypes;
begin
  SubCompanyEdit.Text := ADoc.CompanyName;
  SubPhonNumEdit.Text :=  ADoc.OfficePhone;
  SubFaxEdit.Text := ADoc.MobilePhone;
  SubEmailEdit.Text := ADoc.EMail;
  SubCompanyCodeEdit.Text := ADoc.CompanyCode;
  ServicePOEdit.Text := ADoc.ServicePO;
  SubManagerEdit.Text := ADoc.ManagerName;
  PositionEdit.Text := ADoc.Position;
  SubCompanyAddressMemo.Text := ADoc.CompanyAddress;
  SubConNationEdit.Text := ADoc.Nation;
  SubConInvoiceNoEdit.Text := ADoc.SubConInvoiceNo;
  SubConPriceEdit.Text := ADoc.SubConPrice;
  UniqueSubConIDEdit.Text := ADoc.UniqueSubConID;
  SetBusinessAreasGrpFromTBusinessAreas(BusinessAreaGrp, IntToTBusinessArea_Set(StrToIntDef(ADoc.BusinessAreas, 0)));
//  UniqueSubConIDEdit.Text := ADoc.ShipProductTypes;
//  UniqueSubConIDEdit.Text := ADoc.Engine2SProductTypes;
//  UniqueSubConIDEdit.Text := ADoc.Engine4SProductTypes;
//  UniqueSubConIDEdit.Text := ADoc.ElecProductTypes;
  LElecProductDetailTypes := IntToTElecProductDetailType_Set(StrToIntDef(ADoc.ElecProductDetailTypes, 0));
  ProductTypesEdit.Text := GetElecProductDetailTypes2String(LElecProductDetailTypes);

  LDocItem := _JSON(ADoc.InvoiceItems); //[]
  LDocFile := _JSON(ADoc.InvoiceFiles);

  LoadInvoiceItemFromVar2Grid(LDocItem,LDocFile);
end;

procedure TSubCompanyEditF.SaveSubConEdit2MasterCustomer;
var
  LCustomer: TSQLMasterCustomer;
begin
  LCustomer := GetMasterCustomerFromCompanyCodeNName(SubCompanyCodeEdit.Text, SubCompanyEdit.Text, GetCompanyTypesFromGrp);
  try
    SaveSubContractEdit2MasterSubContract(LCustomer);
  finally
    FreeAndNil(LCustomer);
  end;
end;

procedure TSubCompanyEditF.SaveSubContractEdit2MasterSubContract(
  AMCustomer: TSQLMasterCustomer);
begin
  if AMCustomer.IsUpdate then
  begin
    if MessageDlg('협력사 정보가 이미 MasterDB에 존재합니다.' + #13#10 + '새로운 정보로 Update 하시겠습니까?', mtConfirmation, [mbYes, mbNo],0) = mrYes then
    begin
      LoadTaskForm2MasterSubContractor(AMCustomer, Self.FTask.ID);
      g_MasterDB.Update(AMCustomer);
    end;
  end
  else
  begin
    LoadTaskForm2MasterSubContractor(AMCustomer, Self.FTask.ID);
    g_MasterDB.Add(AMCustomer, true);
  end;
end;

procedure TSubCompanyEditF.SetCompanyTypes2Grp;
var Li: TCompanyType;
begin
  for Li := Succ(ctNull) to Pred(ctFinal) do
    CompanyTypeGrp.Items.Add(R_CompanyType[Li].Description);
end;

procedure TSubCompanyEditF.ShowFileListForm;
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

      LFIleListF.AdvGlowButton5.Visible := False;
      LFIleListF.AdvGlowButton1.Visible := False;
      LFIleListF.AdvGlowButton2.Visible := False;

      if LFileListF.ShowModal = mrOK then
      begin
        if Assigned(TIDList4Invoice(InvoiceGrid.Row[LRow].Data).fInvoiceFile) then
          TIDList4Invoice(InvoiceGrid.Row[LRow].Data).fInvoiceFile.Free;

        LSQLInvoiceFile := TSQLInvoiceFile(LFileListF.FInvoiceFiles_.CreateCopy);
        TIDList4Invoice(InvoiceGrid.Row[LRow].Data).fInvoiceFile := LSQLInvoiceFile;
        LoadInvoiceFileCount2Grid(LSQLInvoiceFile, InvoiceGrid, LRow);
      end;
    finally
      LFileListF.Free;
    end;
  end;
end;

procedure TSubCompanyEditF.SubCompanyEditClickBtn(Sender: TObject);
var
  LSearchCustomerF: TSearchCustomerF;
begin
  LSearchCustomerF := TSearchCustomerF.Create(nil);
  try
    with LSearchCustomerF do
    begin
      FCompanyType := GetCompanyTypesFromGrp;

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

          SetBusinessAreasGrpFromTBusinessAreas(Self.BusinessAreaGrp, GetBusinessAreasFromCommaString(NextGrid1.CellByName['BusinessAreas', NextGrid1.SelectedRow].AsString));
          SetCompanyTypesGrpFromTCompanyTypes(Self.CompanyTypeGrp, GetCompanyTypesFromCommaString(NextGrid1.CellByName['CompanyTypes', NextGrid1.SelectedRow].AsString));
        //  UniqueSubConIDEdit.Text := ADoc.ShipProductTypes;
        //  UniqueSubConIDEdit.Text := ADoc.Engine2SProductTypes;
        //  UniqueSubConIDEdit.Text := ADoc.Engine4SProductTypes;
        //  UniqueSubConIDEdit.Text := ADoc.ElecProductTypes;
          Self.ProductTypesEdit.Text := NextGrid1.CellByName['ElecProductDetailTypes', NextGrid1.SelectedRow].AsString;
        end;
      end;
    end;
  finally
    LSearchCustomerF.Free;
  end;
end;

end.
