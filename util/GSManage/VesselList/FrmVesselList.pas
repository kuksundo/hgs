unit FrmVesselList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxColumnClasses, NxColumns,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, SBPro,
  AdvOfficeTabSet, Vcl.ExtCtrls, Vcl.StdCtrls, AeroButtons, Vcl.ComCtrls,
  AdvGroupBox, AdvOfficeButtons, JvExControls, JvLabel, CurvyControls,
  Vcl.ImgList, Vcl.Menus, UnitVesselMasterRecord;

type
  TVesselListF = class(TForm)
    imagelist24x24: TImageList;
    ImageList32x32: TImageList;
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
    SpecialSurveyDue: TNxDateColumn;
    ShipType: TNxTextColumn;
    OwnerName: TNxTextColumn;
    ShipBuilderName: TNxTextColumn;
    VesselStatus: TNxTextColumn;
    SClass2: TNxTextColumn;
    DockSurveyDue: TNxDateColumn;
    JvLabel1: TJvLabel;
    TechManagerEdit: TEdit;
    JvLabel3: TJvLabel;
    OperatorEdit: TEdit;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    New1: TMenuItem;
    Open1: TMenuItem;
    N1: TMenuItem;
    Close1: TMenuItem;
    ImportFromFile1: TMenuItem;
    N2: TMenuItem;
    OpenDialog1: TOpenDialog;
    OwnerID: TNxTextColumn;
    TechManageCountry: TNxTextColumn;
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
    procedure ImportFromFile1Click(Sender: TObject);
    procedure btn_SearchClick(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure HullNoEditKeyPress(Sender: TObject; var Key: Char);
    procedure ShipNameEditKeyPress(Sender: TObject; var Key: Char);
    procedure OwnerEditKeyPress(Sender: TObject; var Key: Char);
    procedure ImoNoEditKeyPress(Sender: TObject; var Key: Char);
    procedure TechManagerEditKeyPress(Sender: TObject; var Key: Char);
    procedure OperatorEditKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure VesselListGridCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure HiMAP1Click(Sender: TObject);
    procedure ImportAnsiDeviceFromXlsFile1Click(Sender: TObject);
    procedure ShowAnsiDeviceNoList1Click(Sender: TObject);
  private
    procedure DestroyList4VesselMaster;
    procedure ShowHiMAPEditFormFromGrid(ARow: integer);

    procedure GetVesselListFromVariant2Grid(ADoc: Variant);
    procedure GetVesselSearchParam2Rec(var AVesselSearchParamRec: TVesselSearchParamRec);
    procedure GetVesselList2Grid;
    procedure ExecuteSearch(Key: Char);
  public
    { Public declarations }
  end;

var
  VesselListF: TVesselListF;

implementation

uses frmHiMAPDetail, UnitHiMAPRecord, FrmHiMAPSelect, UnitMakeHgsDB,
  UnitMakeAnsiDeviceDB, UnitAnsiDeviceRecord, FrmAnsiDeviceNoList;

{$R *.dfm}

procedure TVesselListF.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TVesselListF.btn_SearchClick(Sender: TObject);
begin
  GetVesselList2Grid;
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

procedure TVesselListF.ExecuteSearch(Key: Char);
begin
  if Key = Chr(VK_RETURN) then
    btn_SearchClick(nil);
end;

procedure TVesselListF.FormCreate(Sender: TObject);
begin
  InitVesselMasterClient;
  InitHiMAPClient;
  InitAnsiDeviceClient;
end;

procedure TVesselListF.FormDestroy(Sender: TObject);
begin
  DestroyList4VesselMaster;
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

    if LSQLVesselMaster.IsUpdate then
    begin
      DestroyList4VesselMaster;

      LDoc := GetVariantFromVesselMaster(LSQLVesselMaster);
      GetVesselListFromVariant2Grid(LDoc);

      while LSQLVesselMaster.FillOne do
      begin
        LDoc := GetVariantFromVesselMaster(LSQLVesselMaster);
        GetVesselListFromVariant2Grid(LDoc);
      end;//while
    end;
  finally
    VesselListGrid.EndUpdate;
  end;
end;

procedure TVesselListF.GetVesselListFromVariant2Grid(ADoc: Variant);
var
  LRow: integer;
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
  VesselListGrid.CellsByName['TechManageCountry', LRow] := ADoc.TechManageCountry;
  VesselListGrid.CellsByName['TechManagerID', LRow] := ADoc.TechManagerID;
  VesselListGrid.CellsByName['OperatorID', LRow] := ADoc.OperatorID;
  VesselListGrid.CellsByName['BuyingCompanyCountry', LRow] := ADoc.BuyingCompanyCountry;
  VesselListGrid.CellsByName['BuyingCompanyID', LRow] := ADoc.BuyingCompanyID;
end;

procedure TVesselListF.GetVesselSearchParam2Rec(
  var AVesselSearchParamRec: TVesselSearchParamRec);
begin
  AVesselSearchParamRec.fHullNo := HullNoEdit.Text;
  AVesselSearchParamRec.fShipName := ShipNameEdit.Text;
  AVesselSearchParamRec.fIMONo := ImoNoEdit.Text;
  AVesselSearchParamRec.fOwnerName := OwnerEdit.Text;
  AVesselSearchParamRec.fTechManagerName := TechManagerEdit.Text;
  AVesselSearchParamRec.fOperatorName := OperatorEdit.Text;
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

procedure TVesselListF.OperatorEditKeyPress(Sender: TObject; var Key: Char);
begin
  ExecuteSearch(Key);
end;

procedure TVesselListF.OwnerEditKeyPress(Sender: TObject; var Key: Char);
begin
  ExecuteSearch(Key);
end;

procedure TVesselListF.ShipNameEditKeyPress(Sender: TObject; var Key: Char);
begin
  ExecuteSearch(Key);
end;

procedure TVesselListF.ShowAnsiDeviceNoList1Click(Sender: TObject);
begin
  CreateAnsiDeviceNoForm;
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

procedure TVesselListF.TechManagerEditKeyPress(Sender: TObject; var Key: Char);
begin
  ExecuteSearch(Key);
end;

procedure TVesselListF.VesselListGridCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  if ARow = -1 then
    Exit;

  ShowHiMAPEditFormFromGrid(ARow);
end;

end.
