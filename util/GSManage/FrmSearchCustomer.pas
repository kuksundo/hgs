unit FrmSearchCustomer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, Vcl.ExtCtrls, Vcl.Buttons, Vcl.StdCtrls, UElecDataRecord,
  NxColumns, NxColumnClasses, CommonData, AdvGroupBox, AdvOfficeButtons,
  AdvEdit, AdvEdBtn;

type
  TSearchCustomerF = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    NextGrid1: TNextGrid;
    Label1: TLabel;
    Label2: TLabel;
    CompanyNameEdit: TEdit;
    CompanyCodeEdit: TEdit;
    SearchButton: TButton;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    CompanyName: TNxTextColumn;
    ManagerName: TNxTextColumn;
    Email: TNxTextColumn;
    Nation: TNxTextColumn;
    CompanyTypes: TNxTextColumn;
    CompanyCode: TNxTextColumn;
    Position: TNxTextColumn;
    Officeno: TNxTextColumn;
    Mobileno: TNxTextColumn;
    CompanyAddress: TNxTextColumn;
    BusinessAreaGrp: TAdvOfficeCheckGroup;
    Label3: TLabel;
    BusinessAreas: TNxTextColumn;
    Label4: TLabel;
    ProductTypesEdit: TAdvEditBtn;
    ShipProductTypes: TNxTextColumn;
    Engine2SProductTypes: TNxTextColumn;
    Engine4SProductTypes: TNxTextColumn;
    ElecProductTypes: TNxTextColumn;
    ElecProductDetailTypes: TNxTextColumn;
    procedure FormCreate(Sender: TObject);
    procedure SearchButtonClick(Sender: TObject);
    procedure NextGrid1CellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure CompanyNameEditKeyPress(Sender: TObject; var Key: Char);
    procedure CompanyCodeEditKeyPress(Sender: TObject; var Key: Char);
    procedure ProductTypesEditClickBtn(Sender: TObject);
  private
    FBusinessAreas: TBusinessAreas;

    procedure ExecuteSearch(Key: Char);
    procedure SetBusinessAreas;
  public
    FCompanyType: TCompanyTypes;
    procedure DoSearchCustomer;
  end;

var
  SearchCustomerF: TSearchCustomerF;

implementation

uses FrmSelectProductType;

{$R *.dfm}

procedure TSearchCustomerF.SearchButtonClick(Sender: TObject);
begin
  DoSearchCustomer;
end;

procedure TSearchCustomerF.SetBusinessAreas;
begin
  FBusinessAreas := [];

  if BusinessAreaGrp.Checked[0] then
    FBusinessAreas := FBusinessAreas + [baShip];

  if BusinessAreaGrp.Checked[1] then
    FBusinessAreas := FBusinessAreas + [baEngine];

  if BusinessAreaGrp.Checked[2] then
    FBusinessAreas := FBusinessAreas + [baElectric];
end;

procedure TSearchCustomerF.CompanyCodeEditKeyPress(Sender: TObject;
  var Key: Char);
begin
  ExecuteSearch(Key);
end;

procedure TSearchCustomerF.CompanyNameEditKeyPress(Sender: TObject;
  var Key: Char);
begin
  ExecuteSearch(Key);
end;

procedure TSearchCustomerF.DoSearchCustomer;
var
  LCompanyName, LCompanyCode: string;
  LMasterCustomer: TSQLMasterCustomer;
  LProductTypes: TElecProductDetailTypes;
  LRow: integer;
begin
  LCompanyName := CompanyNameEdit.Text;
  LCompanyCode := CompanyCodeEdit.Text;
  LProductTypes := GetElecProductDetailTypesFromCommaString(ProductTypesEdit.Text);

  SetBusinessAreas;
//  if (LCompanyCode = '') and (LCompanyName = '') then
//    exit;

  LMasterCustomer := GetMasterCustomerFromCompanyCodeNName(LCompanyCode, LCompanyName, FCompanyType, LProductTypes);
  try
    NextGrid1.ClearRows;
    LMasterCustomer.FillRewind;

    while LMasterCustomer.FillOne do
    begin
      if (FBusinessAreas <> []) and (not IsInFromTBusinessAreas2TBusinessAreas(LMasterCustomer.BusinessAreas, FBusinessAreas)) then
        continue;

      if (LProductTypes <> []) and (not IsInFromElecProductDetailTypes2TElecProductDetailTypes(LMasterCustomer.ElecProductDetailTypes, LProductTypes)) then
        continue;

      LRow := NextGrid1.AddRow();
      NextGrid1.CellByName['CompanyName', LRow].AsString := LMasterCustomer.CompanyName;
      NextGrid1.CellByName['ManagerName', LRow].AsString := LMasterCustomer.ManagerName;
      NextGrid1.CellByName['EMail', LRow].AsString := LMasterCustomer.EMail;
      NextGrid1.CellByName['Nation', LRow].AsString := LMasterCustomer.Nation;
      NextGrid1.CellByName['CompanyTypes', LRow].AsString :=
        GetCompanyTypes2String(LMasterCustomer.CompanyTypes);
      NextGrid1.CellByName['BusinessAreas', LRow].AsString :=
        GetBusinessAreas2String(LMasterCustomer.BusinessAreas);
      NextGrid1.CellByName['CompanyCode', LRow].AsString := LMasterCustomer.CompanyCode;
      NextGrid1.CellByName['Position', LRow].AsString := LMasterCustomer.Position;
      NextGrid1.CellByName['Officeno', LRow].AsString := LMasterCustomer.OfficePhone;
      NextGrid1.CellByName['Mobileno', LRow].AsString := LMasterCustomer.MobilePhone;
      NextGrid1.CellByName['CompanyAddress', LRow].AsString := LMasterCustomer.CompanyAddress;
//      NextGrid1.CellByName['ShipProductTypes', LRow].AsString := LMasterCustomer.ShipProductTypes;
//      NextGrid1.CellByName['Engine2SProductTypes', LRow].AsString := LMasterCustomer.Engine2SProductTypes;
//      NextGrid1.CellByName['Engine4SProductTypes', LRow].AsString := LMasterCustomer.Engine4SProductTypes;
//      NextGrid1.CellByName['ElecProductTypes', LRow].AsString := LMasterCustomer.ElecProductTypes;
      NextGrid1.CellByName['ElecProductDetailTypes', LRow].AsString := GetElecProductDetailTypes2String(LMasterCustomer.ElecProductDetailTypes);
    end;
  finally
    FreeAndNil(LMasterCustomer);
  end;
end;

procedure TSearchCustomerF.ExecuteSearch(Key: Char);
begin
  if Key = Chr(VK_RETURN) then
    SearchButtonClick(nil);
end;

procedure TSearchCustomerF.FormCreate(Sender: TObject);
begin
  NextGrid1.DoubleBuffered := False;
end;

procedure TSearchCustomerF.NextGrid1CellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  ModalResult := mrOK;
end;

procedure TSearchCustomerF.ProductTypesEditClickBtn(Sender: TObject);
begin
  ProductTypesEdit.Text := EditProductType(ProductTypesEdit.Text);
end;

end.

