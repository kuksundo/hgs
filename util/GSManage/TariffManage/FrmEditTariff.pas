unit FrmEditTariff;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls, Vcl.ComCtrls,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, Vcl.Mask, JvExMask, JvToolEdit, JvBaseEdits,
  JvExControls, JvLabel, AeroButtons, Vcl.ExtCtrls, AdvEdit, AdvEdBtn,
  Vcl.ImgList, UnitGSTariffRecord;

type
  TTariffEditF = class(TForm)
    Panel1: TPanel;
    AeroButton1: TAeroButton;
    btn_Close: TAeroButton;
    Panel2: TPanel;
    Panel4: TPanel;
    TariffItemGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    CompanyName: TNxTextColumn;
    CompanyCode: TNxTextColumn;
    GSWorkType: TNxTextColumn;
    GSEngineerType: TNxTextColumn;
    GSWorkDayType: TNxTextColumn;
    GSWorkHourType: TNxTextColumn;
    GSServiceRate: TNxTextColumn;
    CurrencyKind: TNxTextColumn;
    ImageList16x16: TImageList;
    AeroButton2: TAeroButton;
    AeroButton3: TAeroButton;
    Year: TNxTextColumn;
    Label1: TLabel;
    Label2: TLabel;
    CompanyCodeEdit: TEdit;
    AdaptedDatePicker: TDateTimePicker;
    Label3: TLabel;
    CompanyNameEdit: TAdvEditBtn;
    procedure AeroButton3Click(Sender: TObject);
    procedure AeroButton2Click(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure AeroButton1Click(Sender: TObject);
    procedure CompanyNameEditClickBtn(Sender: TObject);
    procedure CompanyNameEditKeyPress(Sender: TObject; var Key: Char);
    procedure CompanyCodeEditKeyPress(Sender: TObject; var Key: Char);
  private
    procedure LoadTariffSearchRecFromGrid(var ATariffSearchRec: TGSTariffSearchRec;
      ARow: integer);
    procedure LoadTariffItemListFromSearchRec(
      ATariffSearchRec: TGSTariffSearchRec);
    procedure LoadGSTariffList2GridFromSQLGSTariff(AGSTariff: TSQLGSTariff);
  public
    procedure AddTariffItem;
    procedure EditTariffItem;
    procedure DeleteTariffItem;
    procedure LoadTariffItemList;
  end;

procedure DisplayTariffEditF;

var
  TariffEditF: TTariffEditF;

implementation

uses fFrmEditTariffItem, UnitGSTriffData, CommonData, FrmSearchCustomer;

{$R *.dfm}

{ TTariffEditF }

procedure DisplayTariffEditF;
var
  LTariffEditF: TTariffEditF;
begin
  LTariffEditF := TTariffEditF.Create(nil);
  try
    LTariffEditF.ShowModal;
  finally
    LTariffEditF.Free;
  end;
end;

procedure TTariffEditF.AddTariffItem;
var
  LTariffSearchRec: TGSTariffSearchRec;
begin
  LTariffSearchRec.fYear := 0;
  LTariffSearchRec.fCompanyCode := CompanyCodeEdit.Text;
  LTariffSearchRec.fCompanyName := CompanyNameEdit.Text;

  if DisplayGSTariffItem(LTariffSearchRec) = mrOK then
  begin
    AddOrUpdateGSTariffFromTariffSearchRec(LTariffSearchRec);
    LoadTariffItemList;
  end;
end;

procedure TTariffEditF.AeroButton1Click(Sender: TObject);
begin
  LoadTariffItemList;
end;

procedure TTariffEditF.AeroButton2Click(Sender: TObject);
begin
  AddTariffItem;
end;

procedure TTariffEditF.AeroButton3Click(Sender: TObject);
begin
  if MessageDlg('Aru you sure delete the selected item?.', mtConfirmation, [mbYes, mbNo],0) = mrYes then
    DeleteTariffItem;
end;

procedure TTariffEditF.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TTariffEditF.CompanyCodeEditKeyPress(Sender: TObject; var Key: Char);
begin
  LoadTariffItemList;
end;

procedure TTariffEditF.CompanyNameEditClickBtn(Sender: TObject);
var
  LSearchCustomerF: TSearchCustomerF;
begin
  LSearchCustomerF := TSearchCustomerF.Create(nil);
  try
    with LSearchCustomerF do
    begin
      FCompanyType := [ctSubContractor];

      if ShowModal = mrOk then
      begin
        if NextGrid1.SelectedRow <> -1 then
        begin
          Self.CompanyNameEdit.Text := NextGrid1.CellByName['CompanyName', NextGrid1.SelectedRow].AsString;
          Self.CompanyCodeEdit.Text := NextGrid1.CellByName['CompanyCode', NextGrid1.SelectedRow].AsString;
        end;
      end;
    end;
  finally
    LSearchCustomerF.Free;
  end;
end;

procedure TTariffEditF.CompanyNameEditKeyPress(Sender: TObject; var Key: Char);
begin
  LoadTariffItemList;
end;

procedure TTariffEditF.DeleteTariffItem;
var
  LTariffSearchRec: TGSTariffSearchRec;
  LGSTariff: TSQLGSTariff;
  LRow: integer;
begin
  LRow := TariffItemGrid.SelectedRow;

  if LRow <> -1 then
  begin
    LoadTariffSearchRecFromGrid(LTariffSearchRec, LRow);
    LGSTariff := GetGSTariffFromSearchRec(LTariffSearchRec);
    try
      if LGSTariff.IsUpdate then
      begin
        DeleteGSTariff(LGSTariff);
        LoadTariffItemList;
      end;
    finally
      FreeAndNil(LGSTariff);
    end;
  end;
end;

procedure TTariffEditF.EditTariffItem;
var
  LRow: integer;
  LTariffSearchRec: TGSTariffSearchRec;
begin
  LRow := TariffItemGrid.SelectedRow;

  if LRow <> -1 then
  begin
    LoadTariffSearchRecFromGrid(LTariffSearchRec, LRow);

    if DisplayGSTariffItem(LTariffSearchRec) = mrOK then
    begin
      AddOrUpdateGSTariffFromTariffSearchRec(LTariffSearchRec);
    end;
  end;
end;

procedure TTariffEditF.LoadGSTariffList2GridFromSQLGSTariff(
  AGSTariff: TSQLGSTariff);
var
  LRow: integer;
begin
  AGSTariff.FillRewind;
  TariffItemGrid.Clearrows;

  while AGSTariff.FillOne do
  begin
    LRow := TariffItemGrid.AddRow();
    TariffItemGrid.CellsByName['CompanyName',LRow] := AGSTariff.CompanyName;
    TariffItemGrid.CellsByName['CompanyCode',LRow] := AGSTariff.CompanyCode;
    TariffItemGrid.CellByName['Year',LRow].AsInteger := AGSTariff.Year;
    TariffItemGrid.CellsByName['GSWorkType',LRow] := GSWorkType2String(AGSTariff.GSWorkType);
    TariffItemGrid.CellsByName['GSEngineerType',LRow] := GSEngineerType2String(AGSTariff.GSEngineerType);
    TariffItemGrid.CellsByName['GSWorkDayType',LRow] := GSWorkDayType2String(AGSTariff.GSWorkDayType);
    TariffItemGrid.CellsByName['GSWorkHourType',LRow] := GSWorkHourType2String(AGSTariff.GSWorkHourType);
    TariffItemGrid.CellsByName['CurrencyKind',LRow] := CurrencyKind2String(AGSTariff.CurrencyKind);
    TariffItemGrid.CellByName['GSServiceRate',LRow].AsInteger := AGSTariff.GSServiceRate;
  end;
end;

procedure TTariffEditF.LoadTariffItemList;
var
  LTariffSearchRec: TGSTariffSearchRec;
  Ly, Lm, Ld: word;
  LGSTariff: TSQLGSTariff;
  LRow: integer;
begin
  ClearTariffSearchRec(LTariffSearchRec);
  LTariffSearchRec.fCompanyName := CompanyNameEdit.Text;
  LTariffSearchRec.fCompanyCode := CompanyCodeEdit.Text;
  DecodeDate(AdaptedDatePicker.Date, Ly, Lm, Ld);
  LTariffSearchRec.fYear := Ly;
  TariffItemGrid.ClearRows;

  LGSTariff := GetGSTariffFromSearchRec(LTariffSearchRec);
  try
    if LGSTariff.IsUpdate then
      LoadGSTariffList2GridFromSQLGSTariff(LGSTariff);
  finally
    FreeAndNil(LGSTariff);
  end;

end;

procedure TTariffEditF.LoadTariffItemListFromSearchRec(
  ATariffSearchRec: TGSTariffSearchRec);
begin

end;

procedure TTariffEditF.LoadTariffSearchRecFromGrid(
  var ATariffSearchRec: TGSTariffSearchRec; ARow: integer);
begin
  ATariffSearchRec.fCompanyName := TariffItemGrid.CellsByName['CompanyName',ARow];
  ATariffSearchRec.fCompanyCode := TariffItemGrid.CellsByName['CompanyCode',ARow];
  ATariffSearchRec.fYear := TariffItemGrid.CellByName['Year',ARow].AsInteger;
  ATariffSearchRec.fGSWorkType := String2GSWorkType(TariffItemGrid.CellsByName['GSWorkType',ARow]);
  ATariffSearchRec.fGSEngineerType := String2GSEngineerType(TariffItemGrid.CellsByName['GSEngineerType',ARow]);
  ATariffSearchRec.fGSWorkDayType := String2GSWorkDayType(TariffItemGrid.CellsByName['GSWorkDayType',ARow]);
  ATariffSearchRec.fGSWorkHourType := String2GSWorkHourType(TariffItemGrid.CellsByName['GSWorkHourType',ARow]);
  ATariffSearchRec.fCurrencyKind := String2CurrencyKind(TariffItemGrid.CellsByName['CurrencyKind',ARow]);
  ATariffSearchRec.fGSServiceRate := TariffItemGrid.CellByName['GSServiceRate',ARow].AsInteger;
end;

end.
