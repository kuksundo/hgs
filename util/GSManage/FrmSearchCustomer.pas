unit FrmSearchCustomer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, Vcl.ExtCtrls, Vcl.Buttons, Vcl.StdCtrls, UElecDataRecord,
  NxColumns, NxColumnClasses;

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
    CompanyType: TNxTextColumn;
    CompanyCode: TNxTextColumn;
    Position: TNxTextColumn;
    Officeno: TNxTextColumn;
    Mobileno: TNxTextColumn;
    CompanyAddress: TNxTextColumn;
    procedure FormCreate(Sender: TObject);
    procedure SearchButtonClick(Sender: TObject);
    procedure NextGrid1CellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure CompanyNameEditKeyPress(Sender: TObject; var Key: Char);
    procedure CompanyCodeEditKeyPress(Sender: TObject; var Key: Char);
  private
    procedure ExecuteSearch(Key: Char);
  public
    procedure DoSearchCustomer;
  end;

var
  SearchCustomerF: TSearchCustomerF;

implementation

uses CommonData;

{$R *.dfm}

procedure TSearchCustomerF.SearchButtonClick(Sender: TObject);
begin
  DoSearchCustomer;
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
  LRow: integer;
begin
  LCompanyName := CompanyNameEdit.Text;
  LCompanyCode := CompanyCodeEdit.Text;

  if (LCompanyCode = '') and (LCompanyName = '') then
    exit;

  LMasterCustomer := GetMasterCustomerFromCompanyCodeNName(LCompanyCode, LCompanyName);
  try
    NextGrid1.ClearRows;

    while LMasterCustomer.FillOne do
    begin
      LRow := NextGrid1.AddRow();
      NextGrid1.CellByName['CompanyName', LRow].AsString := LMasterCustomer.CompanyName;
      NextGrid1.CellByName['ManagerName', LRow].AsString := LMasterCustomer.ManagerName;
      NextGrid1.CellByName['EMail', LRow].AsString := LMasterCustomer.EMail;
      NextGrid1.CellByName['Nation', LRow].AsString := LMasterCustomer.Nation;
      NextGrid1.CellByName['CompanyType', LRow].AsString :=
        CompanyType2String(LMasterCustomer.CompanyType);
      NextGrid1.CellByName['CompanyCode', LRow].AsString := LMasterCustomer.CompanyCode;
      NextGrid1.CellByName['Position', LRow].AsString := LMasterCustomer.Position;
      NextGrid1.CellByName['Officeno', LRow].AsString := LMasterCustomer.OfficePhone;
      NextGrid1.CellByName['Mobileno', LRow].AsString := LMasterCustomer.MobilePhone;
      NextGrid1.CellByName['CompanyAddress', LRow].AsString := LMasterCustomer.CompanyAddress;
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

end.
