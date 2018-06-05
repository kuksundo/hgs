unit fFrmEditTariffItem;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxColumnClasses, NxColumns,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.StdCtrls,
  AeroButtons, Vcl.ExtCtrls, Vcl.ImgList, AdvEdit, AdvEdBtn, Vcl.ComCtrls,
  JvExControls, JvLabel, UnitGSTariffRecord, UnitGSTriffData;

type
  TEditTariffItemF = class(TForm)
    Panel3: TPanel;
    JvLabel16: TJvLabel;
    JvLabel18: TJvLabel;
    JvLabel19: TJvLabel;
    JvLabel53: TJvLabel;
    JvLabel2: TJvLabel;
    JvLabel3: TJvLabel;
    JvLabel1: TJvLabel;
    JvLabel15: TJvLabel;
    JvLabel4: TJvLabel;
    GSServiceRateEdit: TEdit;
    AdaptedDatePicker: TDateTimePicker;
    GSWorkTypeCB: TComboBox;
    GSEngineerTypeCB: TComboBox;
    GSWorkDayTypeCB: TComboBox;
    GSWorkHourTypeCB: TComboBox;
    CurrencyKindCB: TComboBox;
    CompanyEdit: TAdvEditBtn;
    CompanyCodeEdit: TEdit;
    Panel1: TPanel;
    AeroButton1: TAeroButton;
    btn_Close: TAeroButton;
    procedure CompanyEditClickBtn(Sender: TObject);
  private
  public
    procedure FillInComBoBox;
    procedure AssignTariffItem2Form(ATariffSearchRec: TGSTariffSearchRec);
    procedure AssignTariffSearchRecFromForm(var ATariffSearchRec: TGSTariffSearchRec);
  end;

function DisplayGSTariffItem(var ATariffSearchRec: TGSTariffSearchRec): integer;

var
  EditTariffItemF: TEditTariffItemF;

implementation

uses CommonData, FrmSearchCustomer;

{$R *.dfm}

function DisplayGSTariffItem(var ATariffSearchRec: TGSTariffSearchRec): integer;
var
  LEditTariffItemF: TEditTariffItemF;
begin
  LEditTariffItemF := TEditTariffItemF.Create(nil);
  try
    with LEditTariffItemF do
    begin
      FillInComBoBox;
      AssignTariffItem2Form(ATariffSearchRec);
      Result := ShowModal;

      if Result = mrOK then
      begin
        AssignTariffSearchRecFromForm(ATariffSearchRec);
      end;
    end;
  finally
    LEditTariffItemF.Free;
  end;
end;

{ TEditTariffItemF }

procedure TEditTariffItemF.AssignTariffItem2Form(
  ATariffSearchRec: TGSTariffSearchRec);
var
  LDate: TDate;
  Ly, Lm, Ld: word;
begin
  CompanyEdit.Text := ATariffSearchRec.fCompanyName;
  CompanyCodeEdit.Text := ATariffSearchRec.fCompanyCode;

  if ATariffSearchRec.fYear = 0 then
    LDate := now
  else
  begin
    Ly := ATariffSearchRec.fYear;
    Lm := 1;
    Ld := 1;
    LDate := EncodeDate(Ly, Lm, Ld);
  end;

  AdaptedDatePicker.Date := LDate;

  GSWorkTypeCB.ItemIndex := Ord(ATariffSearchRec.fGSWorkType);
  GSEngineerTypeCB.ItemIndex := Ord(ATariffSearchRec.fGSEngineerType);
  GSWorkDayTypeCB.ItemIndex := Ord(ATariffSearchRec.fGSWorkDayType);
  GSWorkHourTypeCB.ItemIndex := Ord(ATariffSearchRec.fGSWorkHourType);
  CurrencyKindCB.ItemIndex := Ord(ATariffSearchRec.fCurrencyKind);
end;

procedure TEditTariffItemF.AssignTariffSearchRecFromForm(
  var ATariffSearchRec: TGSTariffSearchRec);
var
  Ly, Lm, Ld: word;
begin
  ATariffSearchRec.fCompanyName := CompanyEdit.Text;
  ATariffSearchRec.fCompanyCode := CompanyCodeEdit.Text;

  DecodeDate(AdaptedDatePicker.Date, Ly, Lm, Ld);
  ATariffSearchRec.fYear := Ly;

  ATariffSearchRec.fGSWorkType := TGSWorkType(GSWorkTypeCB.ItemIndex);
  ATariffSearchRec.fGSEngineerType := TGSEngineerType(GSEngineerTypeCB.ItemIndex);
  ATariffSearchRec.fGSWorkDayType := TGSWorkDayType(GSWorkDayTypeCB.ItemIndex);
  ATariffSearchRec.fGSWorkHourType := TGSWorkHourType(GSWorkHourTypeCB.ItemIndex);
  ATariffSearchRec.fCurrencyKind := TCurrencyKind(CurrencyKindCB.ItemIndex);
  ATariffSearchRec.fGSServiceRate := StrToIntDef(GSServiceRateEdit.Text,0);
end;

procedure TEditTariffItemF.CompanyEditClickBtn(Sender: TObject);
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
          Self.CompanyEdit.Text := NextGrid1.CellByName['CompanyName', NextGrid1.SelectedRow].AsString;
          Self.CompanyCodeEdit.Text := NextGrid1.CellByName['CompanyCode', NextGrid1.SelectedRow].AsString;
        end;
      end;
    end;
  finally
    LSearchCustomerF.Free;
  end;
end;

procedure TEditTariffItemF.FillInComBoBox;
begin
  GSEngineerType2Combo(GSEngineerTypeCB);
  GSWorkDayType2Combo(GSWorkDayTypeCB);
  GSWorkHourType2Combo(GSWorkHourTypeCB);
  GSWorkType2Combo(GSWorkTypeCB);
  CurrencyKind2Combo(CurrencyKindCB);
end;

end.
