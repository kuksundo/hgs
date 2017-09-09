unit UnitEngParamConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AdvGlowButton, AdvOfficeSelectors, AdvOfficeButtons,
  AdvGroupBox, AdvPageControl, ComCtrls, ImgList, Buttons, ExtCtrls, Mask,
  JvExMask, JvToolEdit, EngineParameterClass, HiMECSConst, AdvOfficePager,
  NxEdit, UnitSelectUser;

type
  TEngParamItemConfigForm = class(TForm)
    ImageList1: TImageList;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    AdvOfficePager1: TAdvOfficePager;
    GeneralSheet: TAdvOfficePage;
    Label39: TLabel;
    Label40: TLabel;
    AdvGroupBox3: TAdvGroupBox;
    Label13: TLabel;
    Label14: TLabel;
    Label17: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label18: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label29: TLabel;
    IsAnalogCB: TCheckBox;
    TagNameEdit: TEdit;
    DescEdit: TEdit;
    UnitEdit: TEdit;
    MaxValueEdit: TEdit;
    ContactEdit: TEdit;
    MinValueEdit: TEdit;
    AdvGroupBox12: TAdvGroupBox;
    IntRB: TRadioButton;
    RealRB: TRadioButton;
    BlockNoEdit: TEdit;
    AlarmEnableCB: TCheckBox;
    AdvGroupBox2: TAdvGroupBox;
    Label15: TLabel;
    Label16: TLabel;
    Label26: TLabel;
    Label28: TLabel;
    AddressEdit: TEdit;
    FCEdit: TEdit;
    SharedNameEdit: TEdit;
    MemIndexEdit: TEdit;
    AdvGroupBox9: TAdvGroupBox;
    Label21: TLabel;
    Label30: TLabel;
    RadixEdit: TEdit;
    ViewMatrixButton: TButton;
    ManualInputValueEdit: TEdit;
    ThousandSepCB: TCheckBox;
    DispUnitCB: TCheckBox;
    ProjNoEdit: TEdit;
    EngNoEdit: TEdit;
    LimitValueSheet_A: TAdvOfficePage;
    AdvGroupBox1: TAdvGroupBox;
    LowAlarmGroup: TAdvGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label31: TLabel;
    Label37: TLabel;
    AdvGroupBox5: TAdvGroupBox;
    MinAlarmSoundEdit: TJvFilenameEdit;
    MinAlarmEdit: TEdit;
    MinAlarmColorSelector: TAdvOfficeColorSelector;
    MinAlarmSoundCB: TCheckBox;
    MinAlarmDeadBandEdit: TEdit;
    MinAlarmDelayEdit: TEdit;
    LowFaultGroup: TAdvGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label33: TLabel;
    Label35: TLabel;
    AdvGroupBox6: TAdvGroupBox;
    MinFaultSoundEdit: TJvFilenameEdit;
    MinFaultEdit: TEdit;
    MinFaultColorSelector: TAdvOfficeColorSelector;
    MinFaultSoundCB: TCheckBox;
    MinFaultDeadBandEdit: TEdit;
    MinFaultDelayEdit: TEdit;
    LowAlarmEnableCB: TAdvOfficeCheckBox;
    LowFaultEnableCB: TAdvOfficeCheckBox;
    AdvGroupBox4: TAdvGroupBox;
    MaxAlarmGroup: TAdvGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label32: TLabel;
    Label38: TLabel;
    AdvGroupBox7: TAdvGroupBox;
    MaxAlarmSoundEdit: TJvFilenameEdit;
    MaxAlarmEdit: TEdit;
    MaxAlarmColorSelector: TAdvOfficeColorSelector;
    MaxAlarmSoundCB: TCheckBox;
    MaxAlarmDeadBandEdit: TEdit;
    MaxAlarmDelayEdit: TEdit;
    MaxFaultGroup: TAdvGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    Label34: TLabel;
    Label36: TLabel;
    AdvGroupBox8: TAdvGroupBox;
    MaxFaultSoundEdit: TJvFilenameEdit;
    MaxFaultEdit: TEdit;
    MaxFaultColorSelector: TAdvOfficeColorSelector;
    MaxFaultSoundCB: TCheckBox;
    MaxFaultDeadBandEdit: TEdit;
    MaxFaultDelayEdit: TEdit;
    MaxAlarmEnableCB: TAdvOfficeCheckBox;
    MaxFaultEnableCB: TAdvOfficeCheckBox;
    LimitValueSheet_D: TAdvOfficePage;
    DigitalAlarmGroup: TAdvGroupBox;
    Label42: TLabel;
    Label44: TLabel;
    DigitalSoundEnableGrp: TAdvGroupBox;
    DigitalAlarmSoundEdit: TJvFilenameEdit;
    DigitalAlarmColorSelector: TAdvOfficeColorSelector;
    DigitalAlarmSoundCB: TCheckBox;
    DigitalAlarmDelayEdit: TEdit;
    ClassificationSheet: TAdvOfficePage;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    SensorTypeCombo: TComboBox;
    ParamCategoryCombo: TComboBox;
    ParamTypeCombo: TComboBox;
    ParamSourceCombo: TComboBox;
    GraphSheet: TAdvOfficePage;
    AdvGroupBox10: TAdvGroupBox;
    Label22: TLabel;
    Label23: TLabel;
    Label27: TLabel;
    MinEdit: TEdit;
    AdvOfficeColorSelector1: TAdvOfficeColorSelector;
    SpanEdit: TEdit;
    AlarmConfigSheet: TAdvOfficePage;
    AdvGroupBox11: TAdvGroupBox;
    PriorityGrp: TAdvOfficeRadioGroup;
    NotifyTerminalsGB: TAdvGroupBox;
    DesktopCB: TCheckBox;
    MobileCB: TCheckBox;
    NotifyAppsGB: TAdvGroupBox;
    SMSCB: TCheckBox;
    NoteCB: TCheckBox;
    EMailCB: TCheckBox;
    AdvGroupBox16: TAdvGroupBox;
    Label48: TLabel;
    Label49: TLabel;
    OutlampCB: TCheckBox;
    DueDayEdit: TEdit;
    AlarmMsgEdit: TEdit;
    DigitalAlarmBlinkCB: TAdvOfficeCheckBox;
    DigitalAlarmNeedAckCB: TAdvOfficeCheckBox;
    MinAlarmBlinkCB: TAdvOfficeCheckBox;
    MinAlarmNeedAckCB: TAdvOfficeCheckBox;
    MaxAlarmBlinkCB: TAdvOfficeCheckBox;
    MaxAlarmNeedAckCB: TAdvOfficeCheckBox;
    MinFaultBlinkCB: TAdvOfficeCheckBox;
    MinFaultNeedAckCB: TAdvOfficeCheckBox;
    MaxFaultBlinkCB: TAdvOfficeCheckBox;
    MaxFaultNeedAckCB: TAdvOfficeCheckBox;
    Label41: TLabel;
    RecipientsEdit: TNxButtonEdit;
    IsOnlyRunCB: TCheckBox;
    DigitalSetValueRG: TRadioGroup;
    DispAvgCB: TCheckBox;
    procedure LowAlarmEnableCBClick(Sender: TObject);
    procedure MaxAlarmEnableCBClick(Sender: TObject);
    procedure LowFaultEnableCBClick(Sender: TObject);
    procedure MaxFaultEnableCBClick(Sender: TObject);
    procedure MinAlarmSoundCBClick(Sender: TObject);
    procedure MaxAlarmSoundCBClick(Sender: TObject);
    procedure MinFaultSoundCBClick(Sender: TObject);
    procedure MaxFaultSoundCBClick(Sender: TObject);
    procedure RecipientsEditButtonClick(Sender: TObject);
  private
    procedure DisableOtherAlarmConfigUI(AExceptAlarm: TAlarmSetType);
  public
    FIsOnlyOneSelect: Boolean;

    procedure LoadConfigEngParamItem2Form(AEPItem:TEngineParameterItem);
    function LoadConfigForm2EngParamItem(AEP: TEngineParameter;
      AEPItem:TEngineParameterItem): integer;

    procedure LimitValue2Form(AEPItem:TEngineParameterItem);
    procedure LimitValueFromForm(AEPItem:TEngineParameterItem);
    procedure DigitalValue2Form(AEPItem:TEngineParameterItem);
    procedure DigitalValueFromForm(AEPItem:TEngineParameterItem);
  end;

var
  EngParamItemConfigForm: TEngParamItemConfigForm;

implementation

{$R *.dfm}

procedure TEngParamItemConfigForm.LowFaultEnableCBClick(Sender: TObject);
begin
  LowFaultGroup.Enabled := LowFaultEnableCB.Checked;

  if FIsOnlyOneSelect and LowFaultGroup.Enabled then
    DisableOtherAlarmConfigUI(astLoLo);
end;

procedure TEngParamItemConfigForm.DigitalValue2Form(
  AEPItem: TEngineParameterItem);
begin
  DigitalAlarmGroup.CheckBox.Checked := True;
  DigitalSetValueRG.ItemIndex := Ord(AEPItem.DigitalAlarmValue);
  //Digital Type은 MinAlarm* 변수를 사용함
  DigitalAlarmDelayEdit.Text := IntToStr(AEPItem.MinAlarmDelay);
  DigitalAlarmNeedAckCB.Checked := AEPItem.MinAlarmNeedAck;
  DigitalAlarmColorSelector.SelectedColor := AEPItem.MinAlarmColor;
  DigitalSoundEnableGrp.CheckBox.Checked := AEPItem.MinAlarmSoundEnable;
  DigitalAlarmSoundEdit.Text := AEPItem.MinAlarmSoundFilename;
end;

procedure TEngParamItemConfigForm.DigitalValueFromForm(
  AEPItem: TEngineParameterItem);
begin
  //Digital Type은 MinAlarm* 변수를 사용함
  AEPItem.MinAlarmDelay := StrToIntDef(DigitalAlarmDelayEdit.Text,0);
  AEPItem.MinAlarmNeedAck := DigitalAlarmNeedAckCB.Checked;
  AEPItem.MinAlarmColor := DigitalAlarmColorSelector.SelectedColor;
  AEPItem.MinAlarmSoundEnable := DigitalSoundEnableGrp.CheckBox.Checked;
  AEPItem.MinAlarmSoundFilename :=DigitalAlarmSoundEdit.Text;
end;

procedure TEngParamItemConfigForm.DisableOtherAlarmConfigUI(
  AExceptAlarm: TAlarmSetType);
begin
  case AExceptAlarm of
    astLoLo: begin
      LowAlarmEnableCB.Checked := False;
      MaxAlarmEnableCB.Checked := False;
      MaxFaultEnableCB.Checked := False;

      LowAlarmGroup.Enabled := False;
      MaxAlarmGroup.Enabled := False;
      MaxFaultGroup.Enabled := False;
    end;
    astLo: begin
      LowFaultEnableCB.Checked := False;
      MaxAlarmEnableCB.Checked := False;
      MaxFaultEnableCB.Checked := False;

      LowFaultGroup.Enabled := False;
      MaxAlarmGroup.Enabled := False;
      MaxFaultGroup.Enabled := False;
    end;
    astHiHi: begin
      LowAlarmEnableCB.Checked := False;
      LowFaultEnableCB.Checked := False;
      MaxAlarmEnableCB.Checked := False;

      LowAlarmGroup.Enabled := False;
      LowFaultGroup.Enabled := False;
      MaxAlarmGroup.Enabled := False;
    end;
    astHi: begin
      LowAlarmEnableCB.Checked := False;
      LowFaultEnableCB.Checked := False;
      MaxFaultEnableCB.Checked := False;

      LowAlarmGroup.Enabled := False;
      LowFaultGroup.Enabled := False;
      MaxFaultGroup.Enabled := False;
    end;
  end;
end;

procedure TEngParamItemConfigForm.LimitValue2Form(
  AEPItem: TEngineParameterItem);
begin
  LowAlarmGroup.Enabled := AEPItem.MinAlarmEnable;
  MaxAlarmGroup.Enabled := AEPItem.MaxAlarmEnable;
  LowFaultGroup.Enabled := AEPItem.MinFaultEnable;
  MaxFaultGroup.Enabled := AEPItem.MaxFaultEnable;

  LowAlarmEnableCB.Checked := AEPItem.MinAlarmEnable;
  MaxAlarmEnableCB.Checked := AEPItem.MaxAlarmEnable;
  LowFaultEnableCB.Checked := AEPItem.MinFaultEnable;
  MaxFaultEnableCB.Checked := AEPItem.MaxFaultEnable;

  MinAlarmEdit.Text := FloatToStr(AEPItem.MinAlarmValue);
  MinAlarmDeadBandEdit.Text := FloatToStr(AEPItem.MinAlarmDeadBand);
  MinAlarmDelayEdit.Text := FloatToStr(AEPItem.MinAlarmDelay);
  MinAlarmColorSelector.SelectedColor := AEPItem.MinAlarmColor;
  MinAlarmBlinkCB.Checked := AEPItem.MinAlarmBlink;
  MinAlarmNeedAckCB.Checked := AEPItem.MinAlarmNeedAck;
  MinAlarmSoundCB.Checked := AEPItem.MinAlarmSoundEnable;
  MinAlarmSoundEdit.FileName := AEPItem.MinAlarmSoundFilename;

  MaxAlarmEdit.Text := FloatToStr(AEPItem.MaxAlarmValue);
  MaxAlarmDeadBandEdit.Text := FloatToStr(AEPItem.MaxAlarmDeadBand);
  MaxAlarmDelayEdit.Text := FloatToStr(AEPItem.MaxAlarmDelay);
  MaxAlarmColorSelector.SelectedColor := AEPItem.MaxAlarmColor;
  MaxAlarmBlinkCB.Checked := AEPItem.MaxAlarmBlink;
  MaxAlarmNeedAckCB.Checked := AEPItem.MaxAlarmNeedAck;
  MaxAlarmSoundCB.Checked := AEPItem.MaxAlarmSoundEnable;
  MaxAlarmSoundEdit.FileName := AEPItem.MaxAlarmSoundFilename;

  MinFaultEdit.Text := FloatToStr(AEPItem.MinFaultValue);
  MinFaultDeadBandEdit.Text := FloatToStr(AEPItem.MinFaultDeadBand);
  MinFaultDelayEdit.Text := FloatToStr(AEPItem.MinFaultDelay);
  MinFaultColorSelector.SelectedColor := AEPItem.MinFaultColor;
  MinFaultBlinkCB.Checked := AEPItem.MinFaultBlink;
  MinFaultNeedAckCB.Checked := AEPItem.MinFaultNeedAck;
  MinFaultSoundCB.Checked := AEPItem.MinFaultSoundEnable;
  MinFaultSoundEdit.FileName := AEPItem.MinFaultSoundFilename;

  MaxFaultEdit.Text := FloatToStr(AEPItem.MaxFaultValue);
  MaxFaultDelayEdit.Text := FloatToStr(AEPItem.MaxFaultDelay);
  MaxFaultDeadBandEdit.Text := FloatToStr(AEPItem.MaxFaultDeadBand);
  MaxFaultColorSelector.SelectedColor := AEPItem.MaxFaultColor;
  MaxFaultBlinkCB.Checked := AEPItem.MaxFaultBlink;
  MaxFaultNeedAckCB.Checked := AEPItem.MaxFaultNeedAck;
  MaxFaultSoundCB.Checked := AEPItem.MaxFaultSoundEnable;
  MaxFaultSoundEdit.FileName := AEPItem.MaxFaultSoundFilename;
end;

procedure TEngParamItemConfigForm.LimitValueFromForm(
  AEPItem: TEngineParameterItem);
begin
  with AEPItem do
  begin
    MinAlarmEnable := LowAlarmEnableCB.Checked;
    MaxAlarmEnable := MaxAlarmEnableCB.Checked;
    MinFaultEnable := LowFaultEnableCB.Checked;
    MaxFaultEnable := MaxFaultEnableCB.Checked;

    MinAlarmValue := StrToFloatDef(MinAlarmEdit.Text, 0.0);
    MinAlarmDeadBand := StrToFloatDef(MinAlarmDeadBandEdit.Text, 0.0);
    MinAlarmDelay := StrToIntDef(MinAlarmDelayEdit.Text, 0);
    MinAlarmColor := MinAlarmColorSelector.SelectedColor;
    MinAlarmBlink := MinAlarmBlinkCB.Checked;
    MinAlarmNeedAck := MinAlarmNeedAckCB.Checked;
    MinAlarmSoundEnable := MinAlarmSoundCB.Checked;
    MinAlarmSoundFilename := MinAlarmSoundEdit.FileName;

    MaxAlarmValue := StrToFloatDef(MaxAlarmEdit.Text,0.0);
    MaxAlarmDeadBand := StrToFloatDef(MaxAlarmDeadBandEdit.Text, 0.0);
    MaxAlarmDelay := StrToIntDef(MaxAlarmDelayEdit.Text, 0);
    MaxAlarmColor := MaxAlarmColorSelector.SelectedColor;
    MaxAlarmBlink := MaxAlarmBlinkCB.Checked;
    MaxAlarmNeedAck := MaxAlarmNeedAckCB.Checked;
    MaxAlarmSoundEnable := MaxAlarmSoundCB.Checked;
    MaxAlarmSoundFilename := MaxAlarmSoundEdit.FileName;

    MinFaultValue := StrToFloatDef(MinFaultEdit.Text, 0.0);
    MinFaultDeadBand := StrToFloatDef(MinFaultDeadBandEdit.Text, 0.0);
    MinFaultDelay := StrToIntDef(MinFaultDelayEdit.Text, 0);
    MinFaultColor := MinFaultColorSelector.SelectedColor;
    MinFaultBlink := MinFaultBlinkCB.Checked;
    MinFaultNeedAck := MinFaultNeedAckCB.Checked;
    MinFaultSoundEnable := MinFaultSoundCB.Checked;
    MinFaultSoundFilename := MinFaultSoundEdit.FileName;

    MaxFaultValue := StrToFloatDef(MaxFaultEdit.Text, 0.0);
    MaxFaultDeadBand := StrToFloatDef(MaxFaultDeadBandEdit.Text, 0.0);
    MaxFaultDelay := StrToIntDef(MaxFaultDelayEdit.Text, 0);
    MaxFaultColor := MaxFaultColorSelector.SelectedColor;
    MaxFaultBlink := MaxFaultBlinkCB.Checked;
    MaxFaultNeedAck := MaxFaultNeedAckCB.Checked;
    MaxFaultSoundEnable := MaxFaultSoundCB.Checked;
    MaxFaultSoundFilename := MaxFaultSoundEdit.FileName;
  end;
end;

procedure TEngParamItemConfigForm.LoadConfigEngParamItem2Form(
  AEPItem: TEngineParameterItem);
var
  LStr: string;
begin
  //--------- General Page --------------
  ProjNoEdit.Text := AEPItem.ProjNo;
  EngNoEdit.Text := AEPItem.EngNo;
  TagNameEdit.Text := AEPItem.TagName;
  DescEdit.Text := AEPItem.Description;
  UnitEdit.Text := AEPItem.FFUnit;

  IntRB.Checked := AEPItem.MinMaxType = mmtInteger;
  RealRB.Checked := AEPItem.MinMaxType = mmtReal;

  if IntRB.Checked then
  begin
    MaxValueEdit.Text := IntToStr(AEPItem.MaxValue);
    MinValueEdit.Text := IntToStr(AEPItem.MinValue);
  end
  else if RealRB.Checked then
  begin
    MaxValueEdit.Text := FloatToStr(AEPItem.MaxValue_Real);
    MinValueEdit.Text := FloatToStr(AEPItem.MinValue_Real);
  end;

  ContactEdit.Text := IntToStr(AEPItem.Contact);
  BlockNoEdit.Text := IntToStr(AEPItem.BlockNo);
  IsAnalogCB.Checked := AEPItem.Alarm;
  AlarmEnableCB.Checked := AEPItem.AlarmEnable;

  if AEPItem.SharedName = '' then
    LStr := ParameterSource2SharedMN(AEPItem.ParameterSource)
  else
    LStr := AEPItem.SharedName;

  SharedNameEdit.Text := LStr;
  MemIndexEdit.Text := IntToStr(AEPItem.AbsoluteIndex);
  AddressEdit.Text := AEPItem.Address;
  FCEdit.Text := AEPItem.FCode;
  RadixEdit.Text := IntToStr(AEPItem.RadixPosition);
  ThousandSepCB.Checked := AEPItem.DisplayThousandSeperator;
  DispUnitCB.Checked := AEPItem.DisplayUnit;
  DispAvgCB.Checked := AEPItem.IsAverageValue;

  if AEPItem.ParameterSource = psManualInput then
    ManualInputValueEdit.Text := AEPItem.Value;

  //--------- Classfy Page --------------
  ParameterType2Combo(ParamTypeCombo);
  SensorType2Combo(SensorTypeCombo);
  ParameterSource2Combo(ParamSourceCombo);
  ParameterCatetory2Combo(ParamCategoryCombo);

  SensorTypeCombo.Text := SensorType2String(AEPItem.SensorType);
  ParamCategoryCombo.Text := ParameterCatetory2String(AEPItem.ParameterCatetory);
  ParamTypeCombo.Text := ParameterType2String(AEPItem.ParameterType);
  ParamSourceCombo.Text := ParameterSource2String(AEPItem.ParameterSource);

  //--------- Limit Value Page --------------
  //Analog Type
  LimitValueSheet_A.TabVisible := AEPItem.Alarm;
  LimitValueSheet_D.TabVisible := not AEPItem.Alarm;

  if LimitValueSheet_A.TabVisible then
    LimitValue2Form(AEPItem)
  else
    DigitalValue2Form(AEPItem);

  MinEdit.Text := FloatToStr(AEPItem.YAxesMinValue);
  SpanEdit.Text := FloatToStr(AEPItem.YAxesSpanValue);
end;

function TEngParamItemConfigForm.LoadConfigForm2EngParamItem(AEP: TEngineParameter;
  AEPItem: TEngineParameterItem): integer;
//var
//  LEngineParameterItem: TEngineParameterItem;
begin
//  Result := AEP.GetItemIndex(AEPItem);

//  if Result <> -1 then
//  begin
//    LEngineParameterItem := AEP.EngineParameterCollect.Items[Result];

    with AEPItem do
    begin
      //--------- General Page --------------
      ProjNo := ProjNoEdit.Text;
      EngNo := EngNoEdit.Text;
      TagName := TagNameEdit.Text;
      Description := DescEdit.Text;
      FFUnit := UnitEdit.Text;

      if IntRB.Checked then
      begin
        MaxValue := StrToIntDef(MaxValueEdit.Text, 0);
        MinValue := StrToIntDef(MinValueEdit.Text, 0);
        MinMaxType := mmtInteger;
      end
      else if RealRB.Checked then
      begin
        MaxValue_Real := StrToFloatDef(MaxValueEdit.Text, 0.0);
        MinValue_Real := StrToFloatDef(MinValueEdit.Text, 0.0);
        MinMaxType := mmtReal;
      end;

      Contact := StrToIntDef(ContactEdit.Text, 0);
      BlockNo := StrToIntDef(BlockNoEdit.Text, 0);
      Alarm := IsAnalogCB.Checked;
      AlarmEnable := AlarmEnableCB.Checked;

      SharedName := SharedNameEdit.Text;
      AbsoluteIndex := StrToIntDef(MemIndexEdit.Text, 0);
      Address := AddressEdit.Text;
      FCode := FCEdit.Text;
      RadixPosition := StrToIntDef(RadixEdit.Text, 0);
      DisplayThousandSeperator := ThousandSepCB.Checked;
      DisplayUnit := DispUnitCB.Checked;
      DisplayFormat := GetDisplayFormat(RadixPosition, DisplayThousandSeperator);
      IsAverageValue := DispAvgCB.Checked;


      if ParameterSource = psManualInput then
        Value := ManualInputValueEdit.Text;

      //--------- Classfy Page --------------
      SensorType := String2SensorType(SensorTypeCombo.Text);
      ParameterCatetory := String2ParameterCatetory(ParamCategoryCombo.Text);
      ParameterType := String2ParameterType(ParamTypeCombo.Text);
      ParameterSource := String2ParameterSource(ParamSourceCombo.Text);

      //--------- Limit Value Page --------------
      if AEPItem.Alarm then
        LimitValueFromForm(AEPItem)
      else
        DigitalValueFromForm(AEPItem);

      YAxesMinValue := StrToFloatDef(MinEdit.Text, 0.0);
      YAxesSpanValue := StrToFloatDef(SpanEdit.Text, 0.0);
    end;//with
//  end; //if
end;

procedure TEngParamItemConfigForm.LowAlarmEnableCBClick(Sender: TObject);
begin
  LowAlarmGroup.Enabled := LowAlarmEnableCB.Checked;

  if FIsOnlyOneSelect and LowAlarmGroup.Enabled then
    DisableOtherAlarmConfigUI(astLo);
end;

procedure TEngParamItemConfigForm.MaxFaultEnableCBClick(Sender: TObject);
begin
  MaxFaultGroup.Enabled := MaxFaultEnableCB.Checked;

  if FIsOnlyOneSelect and MaxFaultGroup.Enabled then
    DisableOtherAlarmConfigUI(astHiHi);
end;

procedure TEngParamItemConfigForm.MaxFaultSoundCBClick(Sender: TObject);
begin
  MaxFaultSoundEdit.Enabled := MaxFaultSoundCB.Checked;
end;

procedure TEngParamItemConfigForm.MinAlarmSoundCBClick(Sender: TObject);
begin
  MinAlarmSoundEdit.Enabled := MinAlarmSoundCB.Checked;
end;

procedure TEngParamItemConfigForm.MinFaultSoundCBClick(Sender: TObject);
begin
  MinFaultSoundEdit.Enabled := MinFaultSoundCB.Checked;
end;

procedure TEngParamItemConfigForm.RecipientsEditButtonClick(Sender: TObject);
var
  LResult: string;
begin
  //Panel1.Hint = DeptName;Deptcode;TeamName;TeamCode
  LResult := Create_SelectUser_Frm(RecipientsEdit.Text, Panel1.Hint);

  if LResult <> '?' then
    RecipientsEdit.Text := LResult;
end;

procedure TEngParamItemConfigForm.MaxAlarmEnableCBClick(Sender: TObject);
begin
  MaxAlarmGroup.Enabled := MaxAlarmEnableCB.Checked;

  if FIsOnlyOneSelect and MaxAlarmGroup.Enabled then
    DisableOtherAlarmConfigUI(astHi);
end;

procedure TEngParamItemConfigForm.MaxAlarmSoundCBClick(Sender: TObject);
begin
  MaxAlarmSoundEdit.Enabled := MaxAlarmSoundCB.Checked;
end;

end.
