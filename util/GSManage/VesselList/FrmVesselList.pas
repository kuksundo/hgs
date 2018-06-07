unit FrmVesselList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxColumnClasses, NxColumns, System.DateUtils,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, SBPro,
  AdvOfficeTabSet, Vcl.ExtCtrls, Vcl.StdCtrls, AeroButtons, Vcl.ComCtrls,
  AdvGroupBox, AdvOfficeButtons, JvExControls, JvLabel, CurvyControls,
  Vcl.ImgList, Vcl.Menus, UnitVesselMasterRecord, CommonData, SynCommons, mORMot,
  AdvSmoothSplashScreen, UnitNationRecord, JvBaseDlg, JvSelectDirectory,
  pjhComboBox, UnitEngineMasterRecord, AdvSmoothPanel, AdvSmoothExpanderPanel,
  UnitGeneratorRecord, UnitVesselData, UnitCBData, UnitEngineMasterData;

type
  TVesselListF = class(TForm)
    imagelist24x24: TImageList;
    ImageList16x16: TImageList;
    CurvyPanel1: TCurvyPanel;
    JvLabel2: TJvLabel;
    JvLabel5: TJvLabel;
    JvLabel6: TJvLabel;
    JvLabel7: TJvLabel;
    JvLabel9: TJvLabel;
    PeriodPanel: TCurvyPanel;
    Label4: TLabel;
    rg_period: TAdvOfficeRadioGroup;
    dt_begin: TDateTimePicker;
    dt_end: TDateTimePicker;
    ComboBox1: TComboBox;
    OwnerEdit: TEdit;
    HullNoEdit: TEdit;
    ShipNameEdit: TEdit;
    Panel1: TPanel;
    btn_Search: TAeroButton;
    btn_Close: TAeroButton;
    AeroButton1: TAeroButton;
    ImoNoEdit: TEdit;
    Splitter1: TSplitter;
    TaskTab: TAdvOfficeTabSet;
    StatusBarPro1: TStatusBarPro;
    VesselListGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    HullNo: TNxTextColumn;
    ShipName: TNxTextColumn;
    ImoNo: TNxTextColumn;
    SClass1: TNxTextColumn;
    ShipType: TNxTextColumn;
    OwnerName: TNxTextColumn;
    ShipBuilderName: TNxTextColumn;
    VesselStatus: TNxTextColumn;
    SClass2: TNxTextColumn;
    JvLabel1: TJvLabel;
    TechManagerEdit: TEdit;
    JvLabel3: TJvLabel;
    OperatorEdit: TEdit;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Close1: TMenuItem;
    ImportFromFile1: TMenuItem;
    N2: TMenuItem;
    OpenDialog1: TOpenDialog;
    OwnerID: TNxTextColumn;
    TechManagerCountry: TNxTextColumn;
    TechManagerID: TNxTextColumn;
    OperatorID: TNxTextColumn;
    BuyingCompanyCountry: TNxTextColumn;
    BuyingCompanyID: TNxTextColumn;
    PopupMenu1: TPopupMenu;
    Add1: TMenuItem;
    Electric1: TMenuItem;
    HiMAP1: TMenuItem;
    Engine1: TMenuItem;
    N2Stroke1: TMenuItem;
    N4Stroke1: TMenuItem;
    SWBD1: TMenuItem;
    VCBACB1: TMenuItem;
    ImportAnsiDeviceFromXlsFile1: TMenuItem;
    View1: TMenuItem;
    ShowAnsiDeviceNoList1: TMenuItem;
    ImportVesselDeliveryDateFromXlsFile1: TMenuItem;
    ShipTypeDesc: TNxTextColumn;
    ransformer1: TMenuItem;
    Motor1: TMenuItem;
    Generator1: TMenuItem;
    GetVesselInfoFromWeb1: TMenuItem;
    ImageList32x32: TImageList;
    SplashScreen1: TAdvSmoothSplashScreen;
    ImportVesselGPandDeliveryFromXlsFile1: TMenuItem;
    Timer1: TTimer;
    GetVesselInfoFromText1: TMenuItem;
    DataBase1: TMenuItem;
    UpdateDockSurveyDateFrom1: TMenuItem;
    DeliveryDate: TNxTextColumn;
    DockingSurveyDueDate: TNxTextColumn;
    SpecialSurveyDueDate: TNxTextColumn;
    LastDryDockDate: TNxTextColumn;
    UpdatedDate: TNxTextColumn;
    JvLabel4: TJvLabel;
    VesselStatusCB: TComboBox;
    ImportVesselDeliveryFromXlsFile1: TMenuItem;
    TechManagerName: TNxTextColumn;
    JvLabel8: TJvLabel;
    ShowNationCode1: TMenuItem;
    AddNationListFromXls1: TMenuItem;
    ImportNationNameENFromXls1: TMenuItem;
    ImportNationFlagFromFolder1: TMenuItem;
    JvSelectDirectory1: TJvSelectDirectory;
    ImportNationFlagImageFromFolder1: TMenuItem;
    TechManagerCountryCB: TComboBoxInc;
    ImportEngineMasterFromXls1: TMenuItem;
    InstalledProduct1: TMenuItem;
    Engine2: TMenuItem;
    Electric2: TMenuItem;
    AeroButton2: TAeroButton;
    InstalledProduct2: TMenuItem;
    Engine3: TMenuItem;
    Electric3: TMenuItem;
    ools1: TMenuItem;
    QuotationManager1: TMenuItem;
    AddVesselInfoFromSeaWebDB1: TMenuItem;
    JvLabel10: TJvLabel;
    ShipBuilderNameEdit: TEdit;
    JvLabel11: TJvLabel;
    ClassEdit: TEdit;
    JvLabel13: TJvLabel;
    ShipTypeCB: TComboBoxInc;
    ShipStatusEdit: TEdit;
    JvLabel12: TJvLabel;
    GeneratorRate: TNxRateColumn;
    ImportGeneratorMasterFromXlsFile1: TMenuItem;
    SWBDRate: TNxRateColumn;
    GERate: TNxRateColumn;
    MERate: TNxRateColumn;
    UpdateInstalledProductInVesselMasterFromEngineMaster1: TMenuItem;
    RemoveGEFromInstalledProductInVesselMaster1: TMenuItem;
    SCRRate: TNxRateColumn;
    BWTSRate: TNxRateColumn;
    FGSSRate: TNxRateColumn;
    COPTRate: TNxRateColumn;
    PROPRate: TNxRateColumn;
    EGRRate: TNxRateColumn;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ImportFromFile1Click(Sender: TObject);
    procedure btn_SearchClick(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure HullNoEditKeyPress(Sender: TObject; var Key: Char);
    procedure ShipNameEditKeyPress(Sender: TObject; var Key: Char);
    procedure OwnerEditKeyPress(Sender: TObject; var Key: Char);
    procedure ImoNoEditKeyPress(Sender: TObject; var Key: Char);
    procedure TechManagerEditKeyPress(Sender: TObject; var Key: Char);
    procedure OperatorEditKeyPress(Sender: TObject; var Key: Char);
    procedure VesselListGridCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure HiMAP1Click(Sender: TObject);
    procedure ImportAnsiDeviceFromXlsFile1Click(Sender: TObject);
    procedure ShowAnsiDeviceNoList1Click(Sender: TObject);
    procedure ImportVesselDeliveryDateFromXlsFile1Click(Sender: TObject);
    procedure ComboBox1DropDown(Sender: TObject);
    procedure rg_periodClick(Sender: TObject);
    procedure GetVesselInfoFromWeb1Click(Sender: TObject);
    procedure ImportVesselGPandDeliveryFromXlsFile1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure GetVesselInfoFromText1Click(Sender: TObject);
    procedure UpdateDockSurveyDateFrom1Click(Sender: TObject);
    procedure AeroButton1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure ImportVesselDeliveryFromXlsFile1Click(Sender: TObject);
    procedure AddNationListFromXls1Click(Sender: TObject);
    procedure ImportNationNameENFromXls1Click(Sender: TObject);
    procedure ImportNationFlagFromFolder1Click(Sender: TObject);
    procedure ShowNationCode1Click(Sender: TObject);
    procedure ImportNationFlagImageFromFolder1Click(Sender: TObject);
    procedure TechManagerCountryCBDropDown(Sender: TObject);
    procedure ImportEngineMasterFromXls1Click(Sender: TObject);
    procedure Engine2Click(Sender: TObject);
    procedure AeroButton2Click(Sender: TObject);
    procedure AddVesselInfoFromSeaWebDB1Click(Sender: TObject);
    procedure Electric2Click(Sender: TObject);
    procedure ImportGeneratorMasterFromXlsFile1Click(Sender: TObject);
    procedure UpdateInstalledProductInVesselMasterFromEngineMaster1Click(
      Sender: TObject);
    procedure RemoveGEFromInstalledProductInVesselMaster1Click(Sender: TObject);
    procedure JvLabel4DblClick(Sender: TObject);
  private
    procedure DestroyList4VesselMaster;
    procedure ShowHiMAPEditFormFromGrid(ARow: integer);
    procedure ShowVesselInfoEditFormFromGrid(ARow: integer);
    procedure ShowGeneratorDetailFormFromGrid(ARow: integer);
    procedure ShowEngineMasterViewFormFromGrid(ARow: integer; AProdType: TEngineProductType);

    procedure GetVesselListFromAdvanced2Grid;
    procedure GetVesselListFromVariant2Grid(ADoc: Variant);
    procedure GetVesselSearchParam2Rec(var AVesselSearchParamRec: TVesselSearchParamRec);
    procedure GetVesselList2Grid;
    procedure ExecuteSearch(Key: Char);
    procedure FillInTechManagerCountryCombo;
  public
    //다른 프로그램에서 Vessel을 검색할 때만 사용하면 True
    FIsVesselSearchMode: Boolean;

    procedure GetVesselInfoFromText(AText: string; var ADoc: variant);
  end;

var
  VesselListF: TVesselListF;

implementation

uses frmHiMAPDetail, UnitHiMAPRecord, FrmHiMAPSelect, UnitMakeHgsDB,
  UnitMakeAnsiDeviceDB, UnitAnsiDeviceRecord, FrmAnsiDeviceNoList, HtmlParserEx,
  UnitStringUtil, FrmEditVesselInfo, UnitExcelUtil, FrmViewNationCode,
  FrmViewEngineMaster, FrmVesselAdvancedSearch, frmGeneratorDetail;

{$R *.dfm}

procedure TVesselListF.AddNationListFromXls1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    if FileExists(OpenDialog1.FileName) then
    begin
      ImportNationListFromXlsFile(OpenDialog1.FileName);
      ShowMessage('Nation list import is completed.');
    end;
  end;
end;

procedure TVesselListF.AddVesselInfoFromSeaWebDB1Click(Sender: TObject);
begin
  AddVesselInfoFromSeaWebDB;
end;

procedure TVesselListF.AeroButton1Click(Sender: TObject);
begin
  NextGridToExcel(VesselListGrid);
end;

procedure TVesselListF.AeroButton2Click(Sender: TObject);
begin
  GetVesselListFromAdvanced2Grid;
end;

procedure TVesselListF.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TVesselListF.btn_SearchClick(Sender: TObject);
begin
  GetVesselList2Grid;
end;

procedure TVesselListF.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure TVesselListF.ComboBox1DropDown(Sender: TObject);
begin
  ComboBox1.Clear;
  g_VesselQueryDateType.SetType2Combo(ComboBox1);
end;

procedure TVesselListF.DestroyList4VesselMaster;
var
  LRow: integer;
begin
  for LRow := 0 to VesselListGrid.RowCount - 1 do
  begin
    TList4VesselMaster(VesselListGrid.Row[LRow].Data).Free;
  end;
end;

procedure TVesselListF.Electric2Click(Sender: TObject);
begin
  if VesselListGrid.SelectedRow = -1 then
    exit;

  ShowGeneratorDetailFormFromGrid(VesselListGrid.SelectedRow);
end;

procedure TVesselListF.Engine2Click(Sender: TObject);
var
  LRow: integer;
  LHullNo: string;
begin
  LRow := VesselListGrid.SelectedRow;

  if LRow = -1 then
    exit;

  LHullNo := VesselListGrid.CellsByName['HullNo', LRow];
  CreateViewEngineMasterFormFromDB(LHullNo);
end;

procedure TVesselListF.ExecuteSearch(Key: Char);
begin
  if Key = Chr(VK_RETURN) then
    btn_SearchClick(nil);
end;

procedure TVesselListF.FillInTechManagerCountryCombo;
var
  LSQLNationRecord: TSQLNationRecord;
  LStr: string;
begin
  LSQLNationRecord := TSQLNationRecord.CreateAndFillPrepare(g_NationDB,
    'ID > ?', [0]);
  try
    while LSQLNationRecord.FillOne do
    begin
      if (LSQLNationRecord.NationAlpha2 <> '') and (LSQLNationRecord.NationName_KO <> '') then

      LStr := LSQLNationRecord.NationAlpha2 + '-' + LSQLNationRecord.NationName_KO;
      TechManagerCountryCB.Items.Add(LStr);
    end;
  finally
    LSQLNationRecord.Free;
  end;
end;

procedure TVesselListF.FormCreate(Sender: TObject);
begin
  Timer1.Enabled := True;
  dt_begin.Date := now;
  dt_end.Date := Now;

  if ExtractFileName(Application.ExeName) <> 'VesselList.exe' then
  begin
    ImportFromFile1.Visible := False;
    ImportVesselDeliveryDateFromXlsFile1.Visible := False;
    ImportVesselGPandDeliveryFromXlsFile1.Visible := False;
    ImportAnsiDeviceFromXlsFile1.Visible := False;
    ShowAnsiDeviceNoList1.Visible := False;
    GetVesselInfoFromWeb1.Visible := False;
    GetVesselInfoFromText1.Visible := False;
    DataBase1.Visible := False;
    ImportVesselDeliveryFromXlsFile1.Visible := False;
    AddNationListFromXls1.Visible := False;
    ImportNationNameENFromXls1.Visible := False;
    ImportNationFlagFromFolder1.Visible := False;
    ImportNationFlagImageFromFolder1.Visible := False;
    ImportEngineMasterFromXls1.Visible := False;

    FIsVesselSearchMode := True;
  end
  else
  begin
    VesselListGrid.PopupMenu := PopupMenu1;
  end;
end;

procedure TVesselListF.FormDestroy(Sender: TObject);
begin
  DestroyList4VesselMaster;
end;

procedure TVesselListF.GetVesselInfoFromText(AText: string; var ADoc: variant);
var
  LStr: string;
  i: integer;
begin
  i := Pos('Ship Name', AText);
  if i <> 0 then
  begin
    System.Delete(AText, 1, i-1);
    LStr := strToken(AText, #9);
    LStr := strToken(AText, #9);
    ADoc.ShipName := LStr;
  end
  else
    ADoc.ShipName := '';

  i := Pos('Shiptype', AText);
  if i <> 0 then
  begin
    System.Delete(AText, 1, i-1);
    LStr := strToken(AText, #9);
    LStr := strToken(AText, #10);
    ADoc.Shiptype := LStr;
  end
  else
    ADoc.Shiptype := '';

  i := Pos('IMO/LR No.', AText);
  if i <> 0 then
  begin
    System.Delete(AText, 1, i-1);
    LStr := strToken(AText, #9);
    LStr := strToken(AText, #9);
    ADoc.IMONo := LStr;
  end
  else
    ADoc.IMONo := '';

  i := Pos('Status', AText);
  if i <> 0 then
  begin
    System.Delete(AText, 1, i-1);
    LStr := strToken(AText, #9);
    LStr := strToken(AText, #13);
    ADoc.VesselStatus := LStr;
  end
  else
    ADoc.VesselStatus := '';

  i := Pos('Group Owner', AText);
  if i <> 0 then
  begin
    System.Delete(AText, 1, i-1);
    LStr := strToken(AText, #9);
    LStr := strToken(AText, #9);
    ADoc.OwnerName := LStr;

    LStr := strToken(AText, #9);
    LStr := strToken(AText, #9);
    ADoc.OwnerCountry := LStr;
  end
  else
  begin
    ADoc.OwnerName := '';
    ADoc.OwnerCountry := '';
  end;


  i := Pos('Operator', AText);
  if i <> 0 then
  begin
    System.Delete(AText, 1, i-1);
    LStr := strToken(AText, #9);
    LStr := strToken(AText, #9);
    ADoc.OperatorName := LStr;

    LStr := strToken(AText, #9);
    LStr := strToken(AText, #9);
    ADoc.OperatorCountry := LStr;
  end
  else
  begin
    ADoc.OperatorName := '';
    ADoc.OperatorCountry := '';
  end;

  i := Pos('Technical Manager', AText);
  if i <> 0 then
  begin
    System.Delete(AText, 1, i-1);
    LStr := strToken(AText, #9);
    LStr := strToken(AText, #9);
    ADoc.TechManagerName := LStr;

    LStr := strToken(AText, #9);
    LStr := strToken(AText, #9);
    ADoc.TechManagerCountry := LStr;
  end
  else
  begin
    ADoc.TechManagerName := '';
    ADoc.TechManagerCountry := '';
  end;

  i := Pos('Special Survey Due', AText);
  if i <> 0 then
  begin
    System.Delete(AText, 1, i-1);
    LStr := strToken(AText, ' ');
    LStr := strToken(AText, ' ');
    LStr := strToken(AText, ' ');
    LStr := strToken(AText, ',');
    ADoc.SpecialSurveyDueDate := LStr;
  end
  else
    ADoc.SpecialSurveyDueDate := '';

  i := Pos('Docking Survey Due', AText);
  if i <> 0 then
  begin
    System.Delete(AText, 1, i-1);
    LStr := strToken(AText, ' ');
    LStr := strToken(AText, ' ');
    LStr := strToken(AText, ' ');
    LStr := strToken(AText, ',');
    ADoc.DockingSurveyDueDate := LStr;
  end
  else
    ADoc.DockingSurveyDueDate := '';

  i := Pos('Ship Builder', AText);
  if i <> 0 then
  begin
    System.Delete(AText, 1, i-1);
    LStr := strToken(AText, #10);
    LStr := strToken(AText, ' ');
    i := Pos('Yard', AText);
    LStr := Trim(Copy(AText, 1, i-1));
    ADoc.ShipBuilderName := LStr;
  end
  else
    ADoc.ShipBuilderName := '';

  i := Pos('hull No.:', AText);
  if i <> 0 then
  begin
//    System.Delete(AText, 1, i-1);
    LStr := strToken(AText, ':');
    LStr := strToken(AText, #13);
    ADoc.HullNo := Trim(LStr);
  end
  else
    ADoc.HullNo := '';
end;

procedure TVesselListF.GetVesselInfoFromText1Click(Sender: TObject);
var
  LDoc: variant;
  LStrStream: TStringStream;
begin
  TDocVariant.New(LDoc);
  if OpenDialog1.Execute then
  begin
    LStrStream := TStringStream.Create;
    try
      LStrStream.LoadFromFile(OpenDialog1.FileName);
      GetVesselInfoFromText(LStrStream.DataString, LDoc);
      ShowMessage(LDoc);
    finally
      LStrStream.Free;
    end;
  end;
end;

procedure TVesselListF.GetVesselInfoFromWeb1Click(Sender: TObject);
var
  LStr, LStr2: string;
  LHtmlElement: IHtmlElement;
  LDoc: Variant;

  procedure ExtractDockSurveyFromHtml(AHtml: IHtmlElement);
  var
    LHtml, LHtml2: IHtmlElement;
    LHtmlList, LHtmlList2: IHtmlElementList;
  begin
    if AHtml <> nil then
    begin
      LHtmlList := AHtml.SimpleCSSSelector('table');

      for LHtml in LHtmlList do
      begin
        LStr := LHtml.Attributes['class'];
        if LStr = 'indent_wrap' then
        begin
          LHtmlList2 := LHtml.SimpleCSSSelector('span');
          for LHtml2 in LHtmlList2 do
          begin
            LStr := LHtml2.Text;

            if Pos('Special Survey Due', LStr) <> 0 then
            begin
              LStr2 := strToken(LStr, ',');
              System.Delete(LStr2,1,19);
              LDoc.SpecialSurveyDueDate := LStr2;
//              Memo1.Lines.Add('Special Survey Due: ' + LStr2);
            end;

            if Pos('Docking Survey Due', LStr) <> 0 then
            begin
              LStr2 := strToken(LStr, ',');
              LStr2 := strToken(LStr, ',');
              LStr2 := Copy(LStr2, Length(LStr2)-9,10);
              LDoc.DockingSurveyDueDate := LStr2;
//              Memo1.Lines.Add('Docking Survey Due: ' + LStr2);
              exit;
            end
          end;
        end;
      end;
    end;
  end;

  procedure ExtractShipNameNIMONoFromHtml(AHtml: IHtmlElement);
  var
    LHtmlList, LHtmlList2: IHtmlElementList;
    LHtml, LHtml2: IHtmlElement;
    LIsShipName, LIsIMONo, LIsShipType, LIsStatus: boolean;
  begin
    if AHtml <> nil then
    begin
      LHtmlList := AHtml.SimpleCSSSelector('table');

      for LHtml in LHtmlList do
      begin
        LStr := LHtml.Attributes['class'];
        if LStr = 'indent' then
        begin
          LHtmlList2 := LHtml.SimpleCSSSelector('td');
          for LHtml2 in LHtmlList2 do
          begin
            LStr := LHtml2.Attributes['class'];
            if LStr = 'label' then
            begin
              LIsShipName := LHtml2.Text = 'Ship Name';

              if not LIsShipName then
              begin
                LIsShipType := LHtml2.Text = 'Shiptype';

                if not LIsShipType then
                begin
                  LIsIMONo := LHtml2.Text = 'IMO/LR No.';

                  if not LIsIMONo then
                  begin
                    LIsStatus := LHtml2.Text = 'Status';
                  end;
                end;
              end;
            end;

            if LStr = 'data' then
            begin
              if LIsShipName then
              begin
                LDoc.ShipName := LHtml2.Text;
//                Memo1.Lines.Add('Ship Name: ' + LHtml2.Text);
                LIsShipName := False;
              end;

              if LIsShipType then
              begin
                LDoc.ShipType := LHtml2.Text;
//                Memo1.Lines.Add('Ship Type: ' + LHtml2.Text);
                LIsShipType := False;
              end;

              if LIsIMONo then
              begin
                LDoc.IMONo := LHtml2.Text;
//                Memo1.Lines.Add('IMO No: ' + LHtml2.Text);
                LIsIMONo := False;
              end;

              if LIsStatus then
              begin
                LDoc.VesselStatus := LHtml2.Text;
//                Memo1.Lines.Add('Status: ' + LHtml2.Text);
                LIsStatus := False;
              end;
            end;
          end;
        end;
      end;
    end;
  end;

  //Ownership은 JS함수로 결과를 보여주므로 Html로는 정보 추출 안되어 txt로 입력 받음
  procedure ExtractOwnershipFromTxt(ATxt: string);
  var
    LStr: string;
    i: integer;
  begin
    i := Pos('Group Owner', Atxt);
    System.Delete(ATxt, 1, i-1);
    LStr := strToken(ATxt, #9);
    LStr := strToken(ATxt, #9);
//    LStr := Copy(ATxt, 1, Pos('Address Location', ATxt));
    LDoc.OwnerName := LStr;
//    Memo1.Lines.Add('Group Owner: ' + LStr);
    LStr := strToken(ATxt, #9);
    LStr := strToken(ATxt, #9);
    LDoc.OwnerCountry := LStr;
//    Memo1.Lines.Add('Group Owner Address Location: ' + LStr);

    i := Pos('Operator', Atxt);
    System.Delete(ATxt, 1, i-1);
    LStr := strToken(ATxt, #9);
    LStr := strToken(ATxt, #9);
    LDoc.OperatorName := LStr;
//    Memo1.Lines.Add('Operator: ' + LStr);
    LStr := strToken(ATxt, #9);
    LStr := strToken(ATxt, #9);
    LDoc.OperatorCountry := LStr;
//    Memo1.Lines.Add('Operator Address Location: ' + LStr);

    i := Pos('Technical Manager', Atxt);
    System.Delete(ATxt, 1, i-1);
    LStr := strToken(ATxt, #9);
    LStr := strToken(ATxt, #9);
    LDoc.TechManagerName := LStr;
//    Memo1.Lines.Add('Technical Manager: ' + LStr);
    LStr := strToken(ATxt, #9);
    LStr := strToken(ATxt, #9);
    LDoc.TechManagerCountry := LStr;
//    Memo1.Lines.Add('Technical Manager Address Location: ' + LStr);
  end;

  procedure LoadHtmlFromFile(AFileName: string);
  var
    LStrStream,
    LStrStream2: TStringStream;
  begin
    LStrStream := TStringStream.Create;
    LStrStream2 := TStringStream.Create;
    try
      LStrStream.LoadFromFile(AFileName);
      LHtmlElement := ParserHtml(LStrStream.DataString);

      ExtractDockSurveyFromHtml(LHtmlElement);
      ExtractShipNameNIMONoFromHtml(LHtmlElement);

      LStrStream2.LoadFromFile(ChangeFileExt(AFileName, '.txt'));
      ExtractOwnershipFromTxt(LStrStream2.DataString);
    finally
      LStrStream.Free;
      LStrStream2.Free;
    end;
  end;
begin
  if OpenDialog1.Execute then
  begin
    TDocVariant.New(LDoc);
    LoadHtmlFromFile(OpenDialog1.FileName);
//    Memo1.Lines.Add(LDoc);
  end;
end;

procedure TVesselListF.GetVesselList2Grid;
var
  LSQLVesselMaster: TSQLVesselMaster;
  LVesselSearchParamRec: TVesselSearchParamRec;
  LDoc: Variant;
begin
  VesselListGrid.BeginUpdate;
  try
    VesselListGrid.ClearRows;
    GetVesselSearchParam2Rec(LVesselSearchParamRec);
    LSQLVesselMaster := GetVesselMasterFromSearchRec(LVesselSearchParamRec);
    try
      if LSQLVesselMaster.IsUpdate then
      begin
        DestroyList4VesselMaster;

  //      LDoc := GetVariantFromVesselMaster(LSQLVesselMaster);
  //      GetVesselListFromVariant2Grid(LDoc);
        LSQLVesselMaster.FillRewind;

        while LSQLVesselMaster.FillOne do
        begin
          LDoc := GetVariantFromVesselMaster(LSQLVesselMaster);
          GetVesselListFromVariant2Grid(LDoc);
        end;//while

        StatusBarPro1.Panels[1].Text := IntToStr(VesselListGrid.RowCount);
      end;
    finally
      LSQLVesselMaster.Free;
    end;
  finally
    VesselListGrid.EndUpdate;
  end;
end;

procedure TVesselListF.GetVesselListFromAdvanced2Grid;
var
  i: integer;
  LDoc: Variant;
  LStrList: TStringList;
  LSQLVesselMaster: TSQLVesselMaster;
begin
  VesselListGrid.BeginUpdate;
  VesselListGrid.ClearRows;
  try
    LStrList := GetEngineMasterListFromViewForm;
    try
      for i := 0 to LStrList.Count - 1 do
      begin
        LSQLVesselMaster := GetVesselMasterFromHullNo(LStrList.Strings[i]);
        try
          LSQLVesselMaster.FillRewind;

          if LSQLVesselMaster.FillOne then
          begin
            LDoc := GetVariantFromVesselMaster(LSQLVesselMaster);
            GetVesselListFromVariant2Grid(LDoc);
          end;
        finally
          LSQLVesselMaster.Free;
        end;
      end;
    finally
      LStrList.Free;
    end;
  finally
    VesselListGrid.EndUpdate;
  end;
end;

procedure TVesselListF.GetVesselListFromVariant2Grid(ADoc: Variant);
var
  LRow: integer;
  LShipProductTypes: TShipProductTypes;
begin
  LRow := VesselListGrid.AddRow;

  VesselListGrid.Row[LRow].Data := TList4VesselMaster.Create;
  TList4VesselMaster(VesselListGrid.Row[LRow].Data).TaskId := ADoc.TaskID;
  TList4VesselMaster(VesselListGrid.Row[LRow].Data).HullNo := ADoc.HullNo;
  TList4VesselMaster(VesselListGrid.Row[LRow].Data).ShipName := ADoc.ShipName;
  TList4VesselMaster(VesselListGrid.Row[LRow].Data).ImoNo := ADoc.ImoNo;

  VesselListGrid.CellsByName['HullNo', LRow] := ADoc.HullNo;
  VesselListGrid.CellsByName['ShipName', LRow] := ADoc.ShipName;
  VesselListGrid.CellsByName['ImoNo', LRow] := ADoc.ImoNo;
  VesselListGrid.CellsByName['SClass1', LRow] := ADoc.SClass1;
  VesselListGrid.CellsByName['ShipType', LRow] := ADoc.ShipType;
  VesselListGrid.CellsByName['OwnerName', LRow] := ADoc.OwnerName;
  VesselListGrid.CellsByName['ShipBuilderName', LRow] := ADoc.ShipBuilderName;
  VesselListGrid.CellsByName['VesselStatus', LRow] := ADoc.VesselStatus;
  VesselListGrid.CellsByName['SClass2', LRow] := ADoc.SClass2;
  VesselListGrid.CellsByName['OwnerID', LRow] := ADoc.OwnerID;
  VesselListGrid.CellsByName['TechManagerCountry', LRow] := ADoc.TechManagerCountry;
  VesselListGrid.CellsByName['TechManagerName', LRow] := ADoc.TechManagerName;
  VesselListGrid.CellsByName['OperatorID', LRow] := ADoc.OperatorID;
  VesselListGrid.CellsByName['BuyingCompanyCountry', LRow] := ADoc.BuyingCompanyCountry;
  VesselListGrid.CellsByName['BuyingCompanyID', LRow] := ADoc.BuyingCompanyID;
  VesselListGrid.CellsByName['ShipTypeDesc', LRow] := ADoc.ShipTypeDesc;

  LShipProductTypes := IntToTShipProductType_Set(ADoc.InstalledProductTypes);

  if shptME in LShipProductTypes then
    VesselListGrid.CellByName['MERate', LRow].AsInteger := 1;

  if shptGEN in LShipProductTypes then
    VesselListGrid.CellByName['GeneratorRate', LRow].AsInteger := 1;

  if shptGE in LShipProductTypes then
    VesselListGrid.CellByName['GERate', LRow].AsInteger := 1;

  if shptSWBD in LShipProductTypes then
    VesselListGrid.CellByName['SWBDRate', LRow].AsInteger := 1;

  if shptSCR in LShipProductTypes then
    VesselListGrid.CellByName['SCRRate', LRow].AsInteger := 1;

  if shptBWTS in LShipProductTypes then
    VesselListGrid.CellByName['BWTSRate', LRow].AsInteger := 1;

  if shptFGSS in LShipProductTypes then
    VesselListGrid.CellByName['FGSSRate', LRow].AsInteger := 1;

  if shptCOPT in LShipProductTypes then
    VesselListGrid.CellByName['COPTRate', LRow].AsInteger := 1;

  if shptPROPELLER in LShipProductTypes then
    VesselListGrid.CellByName['PROPRate', LRow].AsInteger := 1;

  if shptEGR in LShipProductTypes then
    VesselListGrid.CellByName['EGRRate', LRow].AsInteger := 1;

  if ADoc.DeliveryDate <> 0 then
    VesselListGrid.CellsByName['DeliveryDate', LRow] := DateToStr(TimeLogToDateTime(ADoc.DeliveryDate));
  if ADoc.LastDryDockDate <> 0 then
    VesselListGrid.CellsByName['LastDryDockDate', LRow] := DateToStr(TimeLogToDateTime(ADoc.LastDryDockDate));
  if ADoc.SpecialSurveyDueDate <> 0 then
    VesselListGrid.CellsByName['SpecialSurveyDueDate', LRow] := DateToStr(TimeLogToDateTime(ADoc.SpecialSurveyDueDate));
  if ADoc.DockingSurveyDueDate <> 0 then
    VesselListGrid.CellsByName['DockingSurveyDueDate', LRow] := DateToStr(TimeLogToDateTime(ADoc.DockingSurveyDueDate));
  if ADoc.UpdatedDate <> 0 then
    VesselListGrid.CellsByName['UpdatedDate', LRow] := DateToStr(TimeLogToDateTime(ADoc.UpdatedDate));
end;

procedure TVesselListF.GetVesselSearchParam2Rec(
  var AVesselSearchParamRec: TVesselSearchParamRec);
var
  LVesselQueryDateType: TVesselQueryDateType;
begin
  if ComboBox1.ItemIndex = -1 then
    LVesselQueryDateType := vqdtNull
  else
    LVesselQueryDateType := g_VesselQueryDateType.ToType(ComboBox1.ItemIndex);

  AVesselSearchParamRec.fQueryDate := LVesselQueryDateType;
  AVesselSearchParamRec.FFrom := dt_Begin.Date;
  AVesselSearchParamRec.FTo := dt_end.Date;
  AVesselSearchParamRec.fHullNo := HullNoEdit.Text;
  AVesselSearchParamRec.fShipName := ShipNameEdit.Text;
  AVesselSearchParamRec.fIMONo := ImoNoEdit.Text;
  AVesselSearchParamRec.fOwnerName := OwnerEdit.Text;
  AVesselSearchParamRec.fTechManagerName := TechManagerEdit.Text;
  AVesselSearchParamRec.fTechManagerCountry := TechManagerCountryCB.Text;
  AVesselSearchParamRec.fOperatorName := OperatorEdit.Text;
  AVesselSearchParamRec.fVesselStatus := VesselStatusCB.Text;
  AVesselSearchParamRec.fShipBuilderName := ShipBuilderNameEdit.Text;
  AVesselSearchParamRec.fClass := ClassEdit.Text;
  AVesselSearchParamRec.fShipType := ShipTypeCB.Text;
end;

procedure TVesselListF.HiMAP1Click(Sender: TObject);
var
  LList: TList4VesselMaster;
  LRow: integer;
begin
  LRow := VesselListGrid.SelectedRow;

  if LRow = -1 then
  begin
    ShowMessage('Select the vessel first with mouse!');
    exit;
  end;

  if VesselListGrid.Row[LRow].Data <> nil then
  begin
    LList := TList4VesselMaster(VesselListGrid.Row[LRow].Data);

    if CreateHiMAPDetailForm(LList.IMONo, LList.HullNo, LList.ShipName, 0, 0, 0) = mrOK then
    begin
        ShowMessage('mroooooooooooooooOK!');;
    end;
  end;
end;

procedure TVesselListF.HullNoEditKeyPress(Sender: TObject; var Key: Char);
begin
  ExecuteSearch(Key);
end;

procedure TVesselListF.ImoNoEditKeyPress(Sender: TObject; var Key: Char);
begin
  ExecuteSearch(Key);
end;

procedure TVesselListF.ImportAnsiDeviceFromXlsFile1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    if FileExists(OpenDialog1.FileName) then
    begin
      ImportAnsiDeviceFromXlsFile(OpenDialog1.FileName);
      GetVesselList2Grid;
    end;
  end;
end;

procedure TVesselListF.ImportEngineMasterFromXls1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    if FileExists(OpenDialog1.FileName) then
    begin
      ImportEngineMasterFromXlsFile(OpenDialog1.FileName);
      ShowMessage('Engine Master import is completed.');
    end;
  end;
end;

procedure TVesselListF.ImportFromFile1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    if FileExists(OpenDialog1.FileName) then
    begin
      ImportVesselMasterFromXlsFile(OpenDialog1.FileName);
      GetVesselList2Grid;
    end;
  end;
end;

procedure TVesselListF.ImportGeneratorMasterFromXlsFile1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    if FileExists(OpenDialog1.FileName) then
    begin
      ImportGeneratorMasterFromXlsFile(OpenDialog1.FileName);
      ShowMessage('Generator Master import is completed.');
    end;
  end;
end;

procedure TVesselListF.ImportNationFlagFromFolder1Click(Sender: TObject);
begin
  if JvSelectDirectory1.Execute then
  begin
    ImportNationFlagIconFromFolder(JvSelectDirectory1.Directory);
  end;
end;

procedure TVesselListF.ImportNationFlagImageFromFolder1Click(Sender: TObject);
begin
  if JvSelectDirectory1.Execute then
  begin
    ImportNationFlagImageFromFolder(JvSelectDirectory1.Directory);
  end;
end;

procedure TVesselListF.ImportNationNameENFromXls1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    if FileExists(OpenDialog1.FileName) then
    begin
      ImportNationNameKOFromXlsFile(OpenDialog1.FileName);
      ShowMessage('Nation Name(English) import is completed.');
    end;
  end;
end;

procedure TVesselListF.ImportVesselDeliveryDateFromXlsFile1Click(
  Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    if FileExists(OpenDialog1.FileName) then
    begin
      ImportVesselDeliveryFromXlsFile(OpenDialog1.FileName);
      GetVesselList2Grid;
    end;
  end;
end;

procedure TVesselListF.ImportVesselDeliveryFromXlsFile1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    if FileExists(OpenDialog1.FileName) then
    begin
      ImportVesselGuaranteePerionNDeliveryDateFromXlsFile(OpenDialog1.FileName);
      GetVesselList2Grid;
    end;
  end;
end;

procedure TVesselListF.ImportVesselGPandDeliveryFromXlsFile1Click(
  Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    if FileExists(OpenDialog1.FileName) then
    begin
      ImportVesselGuaranteePerionNDeliveryDateFromXlsFile(OpenDialog1.FileName);
      GetVesselList2Grid;
    end;
  end;
end;

procedure TVesselListF.JvLabel4DblClick(Sender: TObject);
//var
//  LStrList: TStrings;
begin
//  VesselStatusCB.Clear;
//  LStrList := CBKind.GetTypeLabels();
//  VesselStatusCB.Items := LStrList;
//  LStrList.Free;
//  ShowMessage(CBKind.ToString(ckVCS));
//  ShowMessage(IntToStr(Ord(CBKind.ToType('VCS'))));
end;

procedure TVesselListF.OperatorEditKeyPress(Sender: TObject; var Key: Char);
begin
  ExecuteSearch(Key);
end;

procedure TVesselListF.OwnerEditKeyPress(Sender: TObject; var Key: Char);
begin
  ExecuteSearch(Key);
end;

procedure TVesselListF.RemoveGEFromInstalledProductInVesselMaster1Click(
  Sender: TObject);
begin
  RemoveGEFromInstalledProductInVesselMaster;
end;

procedure TVesselListF.rg_periodClick(Sender: TObject);
var
  Ly,Lm,Ld: word;
begin
  dt_begin.Enabled := False;
  dt_end.Enabled := False;

  case rg_period.ItemIndex of
    0:
      begin
        dt_begin.Date := now;
        DecodeDate(dt_begin.Date,Ly,Lm,Ld);
        Ly := Ly - 5;
        Lm := 1;
        Ld := 1;
        dt_begin.Date := EncodeDate(Ly,Lm,Ld);
        Lm := 12;
        Ld := 31;
        dt_end.Date := EncodeDate(Ly,Lm,Ld);;
      end;
    1:
      begin
        dt_begin.Date := now;
        DecodeDate(dt_begin.Date,Ly,Lm,Ld);
        Ly := Ly - 10;
        Lm := 1;
        Ld := 1;
        dt_begin.Date := EncodeDate(Ly,Lm,Ld);
        Lm := 12;
        Ld := 31;
        dt_end.Date := EncodeDate(Ly,Lm,Ld);;
      end;
    2:
      begin
        dt_begin.Date := now;
        DecodeDate(dt_begin.Date,Ly,Lm,Ld);
        Ly := Ly - 15;
        Lm := 1;
        Ld := 1;
        dt_begin.Date := EncodeDate(Ly,Lm,Ld);
        Lm := 12;
        Ld := 31;
        dt_end.Date := EncodeDate(Ly,Lm,Ld);;
      end;
    3:
      begin
        dt_begin.Enabled := True;
        dt_end.Enabled := True;
      end;
  end;
end;

procedure TVesselListF.ShipNameEditKeyPress(Sender: TObject; var Key: Char);
begin
  ExecuteSearch(Key);
end;

procedure TVesselListF.ShowAnsiDeviceNoList1Click(Sender: TObject);
begin
  CreateAnsiDeviceNoForm;
end;

procedure TVesselListF.ShowEngineMasterViewFormFromGrid(ARow: integer; AProdType: TEngineProductType);
begin
  GetEngineMasterListFromViewForm(VesselListGrid.CellsByName['HullNo', ARow], AProdType);
end;

procedure TVesselListF.ShowGeneratorDetailFormFromGrid(ARow: integer);
var
  LTaskID: TID;
begin
  LTaskID := -1;

  if Assigned(VesselListGrid.Row[VesselListGrid.SelectedRow].Data) then
    LTaskID := TList4VesselMaster(VesselListGrid.Row[VesselListGrid.SelectedRow].Data).fTaskID;

  CreateGeneratorDetail(LTaskID);
end;

procedure TVesselListF.ShowHiMAPEditFormFromGrid(ARow: integer);
var
  LList: TList4VesselMaster;
begin
  if VesselListGrid.Row[ARow].Data <> nil then
  begin
    LList := TList4VesselMaster(VesselListGrid.Row[ARow].Data);

    if CreateHiMAPSelectForm(LList.IMONo, LList.HullNo, LList.ShipName) = mrOK then
    begin
//      GetVesselList2Grid;
    end;
  end;
end;

procedure TVesselListF.ShowNationCode1Click(Sender: TObject);
begin
  CreateViewNationCodeFormFromDB('','','');
end;

procedure TVesselListF.ShowVesselInfoEditFormFromGrid(ARow: integer);
var
  LIMONo, LHullNo, LShipName: string;
//  LList: TList4VesselMaster;
begin
//  if VesselListGrid.Row[ARow].Data <> nil then
//  begin
//    LList := TList4VesselMaster(VesselListGrid.Row[ARow].Data);
    LIMONo := VesselListGrid.CellsByName['IMONo', ARow];
    LHullNo := VesselListGrid.CellsByName['HullNo', ARow];
    LShipName := VesselListGrid.CellsByName['ShipName', ARow];

    if CreateVesselInfoEditFormFromDB(LIMONo, LHullNo, LShipName) = mrOK then
    begin
//      GetVesselList2Grid;
    end;
//  end;
end;

procedure TVesselListF.TechManagerCountryCBDropDown(Sender: TObject);
begin
  FillInTechManagerCountryCombo;
end;

procedure TVesselListF.TechManagerEditKeyPress(Sender: TObject; var Key: Char);
begin
  ExecuteSearch(Key);
end;

procedure TVesselListF.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  rg_period.ItemIndex := 3;
  rg_periodClick(nil);
  g_VesselStatus.SetType2Combo(VesselStatusCB);

  InitVesselMasterClient;
  InitNationClient(Application.ExeName);
  FillInTechManagerCountryCombo;

  if not FIsVesselSearchMode then
  begin
    InitHiMAPClient(Application.ExeName);
    InitAnsiDeviceClient(Application.ExeName);
    InitVesselInfo4SeaWebClient(Application.ExeName);
    InitEngineMasterClient('EngineMaster.sqlite');
    InitGeneratorClient(Application.ExeName);
  end;
end;

procedure TVesselListF.UpdateDockSurveyDateFrom1Click(Sender: TObject);
var
  i: integer;
begin
  i := UpdateDockSurveyDateFromSeaWebDB;
  ShowMessage(IntToStr(i) + ' is Complete Update for Survey Date etc.');
end;

procedure TVesselListF.UpdateInstalledProductInVesselMasterFromEngineMaster1Click(
  Sender: TObject);
begin
  UpdateInstalledProductInVesselMasterFromEngineMaster;
end;

procedure TVesselListF.VesselListGridCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  if ARow = -1 then
    Exit;

  if VesselListGrid.Columns.Item[ACol].Name = 'MERate' then
    ShowEngineMasterViewFormFromGrid(ARow, vepte2StrokeEngine)
  else
  if VesselListGrid.Columns.Item[ACol].Name = 'GERate' then
    ShowEngineMasterViewFormFromGrid(ARow, vepte4StrokeEngine)
  else
  if VesselListGrid.Columns.Item[ACol].Name = 'GeneratorRate' then
    ShowGeneratorDetailFormFromGrid(ARow)
  else
    ShowVesselInfoEditFormFromGrid(ARow);
//  ShowHiMAPEditFormFromGrid(ARow);
end;

end.
