unit UnitVariantFormUtil;

interface

uses System.Classes, Dialogs, System.Rtti, System.SysUtils,
  Vcl.Controls, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Forms,
  SynCommons, mORMot;

procedure LoadVariantFromForm(const AForm: TForm; var ADoc: Variant);
procedure LoadVariantFromEdit1(const AEdit: TEdit; var ADoc: Variant);
procedure LoadVariantFromCombo1(const ACombo: TComboBox; var ADoc: Variant; const AIsSaveIndex: Boolean = False);
procedure LoadVariantFromCheckBox1(const ACheckBox: TCheckBox; var ADoc: Variant);
procedure LoadVariantFromDatePicker1(const ADatePicker: TDateTimePicker; var ADoc: Variant);
procedure LoadVariantFromEdit(const AForm: TForm; var ADoc: Variant);
procedure LoadVariantFromCombo(const AForm: TForm; var ADoc: Variant; const AIsSaveIndex: Boolean = False);
procedure LoadVariantFromCheckBox(const AForm: TForm; var ADoc: Variant);

procedure LoadVariant2Form(const ADoc: Variant; AForm: TForm);

implementation

procedure LoadVariantFromForm(const AForm: TForm; var ADoc: Variant);
var
  i: integer;
  LStr: string;
begin
  for i := 0 to AForm.ComponentCount - 1 do
  begin
    if AForm.Components[i].ClassType = TEdit then
      LoadVariantFromEdit1(TEdit(AForm.Components[i]), ADoc)
    else
    if AForm.Components[i].ClassType = TComboBox then
      LoadVariantFromCombo1(TComboBox(AForm.Components[i]), ADoc)
    else
    if AForm.Components[i].ClassType = TCheckBox then
      LoadVariantFromCheckBox1(TCheckBox(AForm.Components[i]), ADoc)
    else
    if AForm.Components[i].ClassType = TDateTimePicker then
      LoadVariantFromDatePicker1(TDateTimePicker(AForm.Components[i]), ADoc)
  end;
end;

procedure LoadVariantFromEdit1(const AEdit: TEdit; var ADoc: Variant);
var
  LStr: string;
begin
  LStr := StringReplace(AEdit.Name, 'Edit', '', [rfReplaceAll]);
  TDocVariantData(ADoc).AddValue(LStr, AEdit.Text);
end;

procedure LoadVariantFromCombo1(const ACombo: TComboBox; var ADoc: Variant; const AIsSaveIndex: Boolean);
var
  LStr: string;
begin
  LStr := StringReplace(ACombo.Name, 'CB', '', [rfReplaceAll]);

  if AIsSaveIndex then
    TDocVariantData(ADoc).AddValue(LStr, ACombo.ItemIndex)
  else
    TDocVariantData(ADoc).AddValue(LStr, ACombo.Text);
end;

procedure LoadVariantFromCheckBox1(const ACheckBox: TCheckBox; var ADoc: Variant);
var
  LStr: string;
begin
  LStr := StringReplace(ACheckBox.Name, 'Check', '', [rfReplaceAll]);
  TDocVariantData(ADoc).AddValue(LStr, ACheckBox.Checked);
end;

procedure LoadVariantFromDatePicker1(const ADatePicker: TDateTimePicker; var ADoc: Variant);
var
  LStr: string;
begin
  LStr := StringReplace(ADatePicker.Name, 'DatePick', '', [rfReplaceAll]);
  TDocVariantData(ADoc).AddValue(LStr, ADatePicker.Date);
end;

procedure LoadVariantFromEdit(const AForm: TForm; var ADoc: Variant);
var
  i: integer;
  LStr: string;
  LEdit: TEdit;
begin
  for i := 0 to AForm.ComponentCount - 1 do
  begin
    if AForm.Components[i].ClassType = TEdit then
    begin
      LEdit := AForm.Components[i] as TEdit;
      LStr := StringReplace(LEdit.Name, 'Edit', '', [rfReplaceAll]);
      TDocVariantData(ADoc).AddValue(LStr, LEdit.Text);
    end;
  end;
end;

procedure LoadVariantFromCombo(const AForm: TForm; var ADoc: Variant; const AIsSaveIndex: Boolean);
var
  i: integer;
  LStr: string;
  LComboBox: TComboBox;
begin
  for i := 0 to AForm.ComponentCount - 1 do
  begin
    if AForm.Components[i].ClassType = TComboBox then
    begin
      LComboBox := AForm.Components[i] as TComboBox;
      LStr := StringReplace(LComboBox.Name, 'CB', '', [rfReplaceAll]);

      if AIsSaveIndex then
        TDocVariantData(ADoc).AddValue(LStr, LComboBox.ItemIndex)
      else
        TDocVariantData(ADoc).AddValue(LStr, LComboBox.Text);
    end;
  end;
end;

procedure LoadVariantFromCheckBox(const AForm: TForm; var ADoc: Variant);
var
  i: integer;
  LStr: string;
  LCheckBox: TCheckBox;
begin
  for i := 0 to AForm.ComponentCount - 1 do
  begin
    if AForm.Components[i].ClassType = TCheckBox then
    begin
      LCheckBox := AForm.Components[i] as TCheckBox;
      LStr := StringReplace(LCheckBox.Name, 'Check', '', [rfReplaceAll]);
      TDocVariantData(ADoc).AddValue(LStr, LCheckBox.Checked);
    end;
  end;
end;

procedure LoadVariant2Form(const ADoc: Variant; AForm: TForm);
var
  i: integer;
  LStr: string;
  LDate: TTimeLog;
begin
  for i := 0 to AForm.ComponentCount - 1 do
  begin
    LStr := AForm.Components[i].Name;

    if AForm.Components[i] is TEdit then
    begin
      LStr := StringReplace(LStr, 'Edit', '', [rfReplaceAll]);
      TEdit(AForm.Components[i]).Text := TDocVariantData(ADoc).Value[LStr];
    end
    else
    if AForm.Components[i] is TComboBox then
    begin
      LStr := StringReplace(LStr, 'CB', '', [rfReplaceAll]);
      TComboBox(AForm.Components[i]).Text := TDocVariantData(ADoc).Value[LStr];
    end
    else
    if AForm.Components[i] is TCheckBox then
    begin
      LStr := StringReplace(LStr, 'Check', '', [rfReplaceAll]);
      TCheckBox(AForm.Components[i]).Checked := TDocVariantData(ADoc).Value[LStr];
    end
    else
    if AForm.Components[i] is TDateTimePicker then
    begin
      LStr := StringReplace(LStr, 'DatePick', '', [rfReplaceAll]);
      LDate := TDocVariantData(ADoc).Value[LStr];
      TDateTimePicker(AForm.Components[i]).Date := TimeLogToDateTime(LDate);
    end;
  end;
end;

end.
