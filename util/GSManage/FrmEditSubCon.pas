unit FrmEditSubCon;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AeroButtons, JvExControls,
  JvLabel, CurvyControls, Vcl.ExtCtrls, NxColumnClasses, NxColumns,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid,
  UElecDataRecord, CommonData, VarRecUtils;

type
  TForm2 = class(TForm)
    CurvyPanel1: TCurvyPanel;
    JvLabel5: TJvLabel;
    JvLabel6: TJvLabel;
    btn_Close: TAeroButton;
    btn_Search: TAeroButton;
    et_msNumber: TEdit;
    CompanyNameEdit: TEdit;
    ComapnyCodeEdit: TEdit;
    AeroButton1: TAeroButton;
    AeroButton2: TAeroButton;
    grid_SubCon: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    Panel1: TPanel;
    JvLabel15: TJvLabel;
    SubCompanyEdit: TEdit;
    JvLabel16: TJvLabel;
    SubCompanyCodeEdit: TEdit;
    JvLabel18: TJvLabel;
    SubManagerEdit: TEdit;
    JvLabel46: TJvLabel;
    PositionEdit: TEdit;
    JvLabel23: TJvLabel;
    SubEmailEdit: TEdit;
    SubPhonNumEdit: TEdit;
    JvLabel43: TJvLabel;
    SubFaxEdit: TEdit;
    JvLabel17: TJvLabel;
    SubCompanyAddressMemo: TMemo;
    JvLabel42: TJvLabel;
    CompanyName: TNxTextColumn;
    CompanyCode: TNxTextColumn;
    CompanyAddress: TNxTextColumn;
    JvLabel1: TJvLabel;
    NationEdit: TEdit;
    Splitter1: TSplitter;
    Email: TNxTextColumn;
    MobilePhone: TNxTextColumn;
    OfficePhone: TNxTextColumn;
    Position: TNxTextColumn;
    ID: TNxTextColumn;
    ManagerName: TNxTextColumn;
    Nation: TNxTextColumn;
    CompanyTypes: TNxTextColumn;
    procedure grid_SubConCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure AeroButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure DisplaySubCon2Grid(ACompanyName, ACompanyCode: string);
    procedure LoadSubCon2Grid(ASubCon:TSQLSubCon; AGrid: TNextGrid);
    procedure LoadSubConDetailFromGrid(ARow: integer);
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

{ TForm2 }

procedure TForm2.AeroButton1Click(Sender: TObject);
begin
  DisplaySubCon2Grid(CompanyNameEdit.Text, ComapnyCodeEdit.Text);
end;

procedure TForm2.DisplaySubCon2Grid(ACompanyName, ACompanyCode: string);
var
  ConstArray: TConstArray;
  LWhere: string;
  LSQLSubCon: TSQLSubCon;
begin
  LWhere := '';
  ConstArray := CreateConstArray([]);
  try
    if ACompanyName <> '' then
    begin
      AddConstArray(ConstArray, [ACompanyName+'%']);

      if LWhere <> '' then
        LWhere := LWhere + ' and ';

      LWhere := LWhere + 'CompanyName LIKE ? ';
    end;

    if ACompanyCode <> '' then
    begin
      AddConstArray(ConstArray, [ACompanyCode+'%']);

      if LWhere <> '' then
        LWhere := LWhere + ' and ';

      LWhere := LWhere + 'CompanyCode LIKE ? ';
    end;

    if LWhere = '' then
    begin
      ShowMessage('조회 조건을 선택하세요.');
      exit;
    end;

    LSQLSubCon := TSQLSubCon.CreateAndFillPrepare(g_ProjectDB, Lwhere, ConstArray);

    try
      grid_SubCon.ClearRows;

      while LSQLSubCon.FillOne do
      begin
        grid_SubCon.BeginUpdate;
        try
          LoadSubCon2Grid(LSQLSubCon, grid_SubCon);
        finally
          grid_SubCon.EndUpdate;
        end;
      end;
    finally
      LSQLSubCon.Free;
    end;
  finally
    FinalizeConstArray(ConstArray);
  end;
end;

procedure TForm2.grid_SubConCellDblClick(Sender: TObject; ACol, ARow: Integer);
begin
  LoadSubConDetailFromGrid(ARow);
end;

procedure TForm2.LoadSubCon2Grid(ASubCon: TSQLSubCon; AGrid: TNextGrid);
var
  LRow: integer;
begin
  with ASubCon, AGrid do
  begin
    LRow := AddRow;
    CellByName['CompanyName', LRow].AsString := CompanyName;
    CellByName['CompanyAddress', LRow].AsString := CompanyAddress;
    CellByName['CompanyCode', LRow].AsString := CompanyCode;
    CellByName['EMail', LRow].AsString := EMail;
    CellByName['MobilePhone', LRow].AsString := MobilePhone;
    CellByName['OfficePhone', LRow].AsString := OfficePhone;
    CellByName['Position', LRow].AsString := Position;
    CellByName['ManagerName', LRow].AsString := ManagerName;
    CellByName['Nation', LRow].AsString := Nation;
    CellByName['CompanyTypes', LRow].AsString := GetCompanyTypes2String(CompanyTypes);
    CellByName['ID', LRow].AsInteger := ID;
  end;
end;

procedure TForm2.LoadSubConDetailFromGrid(ARow: integer);
begin
  with grid_SubCon do
  begin
    SubCompanyEdit.text := CellByName['CompanyName', ARow].AsString;
    SubCompanyAddressMemo.text := CellByName['CompanyAddress', ARow].AsString;
    SubCompanyCodeEdit.text := CellByName['CompanyCode', ARow].AsString;
    SubEmailEdit.text := CellByName['EMail', ARow].AsString;
    SubFaxEdit.text := CellByName['MobilePhone', ARow].AsString;
    SubPhonNumEdit.text := CellByName['OfficePhone', ARow].AsString;
    PositionEdit.text := CellByName['Position', ARow].AsString;
    SubManagerEdit.text := CellByName['ManagerName', ARow].AsString;
    NationEdit.text := CellByName['Nation', ARow].AsString;
//    SubCompanyEdit.text := CellByName['CompanyType', ARow].AsString);
  end;
end;

end.
