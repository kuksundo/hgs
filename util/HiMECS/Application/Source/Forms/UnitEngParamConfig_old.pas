unit UnitEngParamConfig_old;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AdvGlowButton, AdvOfficeSelectors, AdvOfficeButtons,
  AdvGroupBox, AdvPageControl, ComCtrls, ImgList, Buttons, ExtCtrls, Mask,
  JvExMask, JvToolEdit, EngineParameterClass, HiMECSConst;

type
  TEngParamItemConfigForm = class(TForm)
    ImageList1: TImageList;
    LimitValueSheet_A: TAdvTabSheet;
    GeneralSheet: TAdvTabSheet;
    ClassificationSheet: TAdvTabSheet;
    AdvGroupBox1: TAdvGroupBox;
    LowAlarmGroup: TAdvGroupBox;
    Label1: TLabel;
    MinAlarmEdit: TEdit;
    Label2: TLabel;
    MinAlarmColorSelector: TAdvOfficeColorSelector;
    MinAlarmBlinkCB: TCheckBox;
    LowFaultGroup: TAdvGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    MinFaultEdit: TEdit;
    MinFaultColorSelector: TAdvOfficeColorSelector;
    MinFaultBlinkCB: TCheckBox;
    AdvGroupBox4: TAdvGroupBox;
    MaxAlarmGroup: TAdvGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    MaxAlarmEdit: TEdit;
    MaxAlarmColorSelector: TAdvOfficeColorSelector;
    MaxAlarmBlinkCB: TCheckBox;
    MaxFaultGroup: TAdvGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    MaxFaultEdit: TEdit;
    MaxFaultColorSelector: TAdvOfficeColorSelector;
    MaxFaultBlinkCB: TCheckBox;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    SensorTypeCombo: TComboBox;
    ParamCategoryCombo: TComboBox;
    ParamTypeCombo: TComboBox;
    ParamSourceCombo: TComboBox;
    LowAlarmEnableCB: TAdvOfficeCheckBox;
    LowFaultEnableCB: TAdvOfficeCheckBox;
    MaxAlarmEnableCB: TAdvOfficeCheckBox;
    MaxFaultEnableCB: TAdvOfficeCheckBox;
    AdvGroupBox2: TAdvGroupBox;
    AddressEdit: TEdit;
    Label15: TLabel;
    Label16: TLabel;
    FCEdit: TEdit;
    AdvGroupBox3: TAdvGroupBox;
    Label13: TLabel;
    Label14: TLabel;
    Label17: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    IsAnalogCB: TCheckBox;
    TagNameEdit: TEdit;
    DescEdit: TEdit;
    UnitEdit: TEdit;
    MaxValueEdit: TEdit;
    ContactEdit: TEdit;
    Label18: TLabel;
    AdvGroupBox5: TAdvGroupBox;
    MinAlarmSoundEdit: TJvFilenameEdit;
    MinAlarmSoundCB: TCheckBox;
    MinFaultSoundCB: TCheckBox;
    MaxAlarmSoundCB: TCheckBox;
    MaxFaultSoundCB: TCheckBox;
    AdvGroupBox6: TAdvGroupBox;
    MinFaultSoundEdit: TJvFilenameEdit;
    AdvGroupBox7: TAdvGroupBox;
    MaxAlarmSoundEdit: TJvFilenameEdit;
    AdvGroupBox8: TAdvGroupBox;
    MaxFaultSoundEdit: TJvFilenameEdit;
    AdvGroupBox9: TAdvGroupBox;
    Label21: TLabel;
    RadixEdit: TEdit;
    GraphSheet: TAdvTabSheet;
    AdvGroupBox10: TAdvGroupBox;
    Label22: TLabel;
    Label23: TLabel;
    MinEdit: TEdit;
    AdvOfficeColorSelector1: TAdvOfficeColorSelector;
    Label24: TLabel;
    MinValueEdit: TEdit;
    Label25: TLabel;
    AdvGroupBox12: TAdvGroupBox;
    IntRB: TRadioButton;
    RealRB: TRadioButton;
    Label26: TLabel;
    SharedNameEdit: TEdit;
    Label27: TLabel;
    SpanEdit: TEdit;
    Label29: TLabel;
    BlockNoEdit: TEdit;
    ViewMatrixButton: TButton;
    Label30: TLabel;
    ManualInputValueEdit: TEdit;
    MemIndexEdit: TEdit;
    Label28: TLabel;
    AlarmEnableCB: TCheckBox;
    Label31: TLabel;
    MinAlarmDeadBandEdit: TEdit;
    Label32: TLabel;
    MaxAlarmDeadBandEdit: TEdit;
    Label33: TLabel;
    MinFaultDeadBandEdit: TEdit;
    Label34: TLabel;
    MaxFaultDeadBandEdit: TEdit;
    Label35: TLabel;
    MinFaultDelayEdit: TEdit;
    Label36: TLabel;
    MaxFaultDelayEdit: TEdit;
    Label37: TLabel;
    MinAlarmDelayEdit: TEdit;
    Label38: TLabel;
    MaxAlarmDelayEdit: TEdit;
    ThousandSepCB: TCheckBox;
    DispUnitCB: TCheckBox;
    MinAlarmNeedAckCB: TCheckBox;
    MaxAlarmNeedAckCB: TCheckBox;
    MinFaultNeedAckCB: TCheckBox;
    MaxFaultNeedAckCB: TCheckBox;
    Label39: TLabel;
    ProjNoEdit: TEdit;
    Label40: TLabel;
    EngNoEdit: TEdit;
    LimitValueSheet_D: TAdvTabSheet;
    DigitalAlarmGroup: TAdvGroupBox;
    Label42: TLabel;
    Label44: TLabel;
    AdvGroupBox13: TAdvGroupBox;
    DigitalAlarmSoundEdit: TJvFilenameEdit;
    DigitalAlarmColorSelector: TAdvOfficeColorSelector;
    DigitalAlarmBlinkCB: TCheckBox;
    DigitalAlarmSoundCB: TCheckBox;
    DigitalAlarmDelayEdit: TEdit;
    DigitalAlarmNeedAckCB: TCheckBox;
    DigitalAlarmEnableCB: TAdvOfficeCheckBox;
    AlarmConfigSheet: TAdvTabSheet;
    AdvGroupBox11: TAdvGroupBox;
    PriorityGrp: TAdvOfficeRadioGroup;
    AdvGroupBox14: TAdvGroupBox;
    DesktopCB: TCheckBox;
    MobileCB: TCheckBox;
    AdvGroupBox15: TAdvGroupBox;
    SMSCB: TCheckBox;
    NoteCB: TCheckBox;
    EMailCB: TCheckBox;
    AdvGroupBox16: TAdvGroupBox;
    NeedAckCB: TCheckBox;
    OutlampCB: TCheckBox;
    Label48: TLabel;
    DueDayEdit: TEdit;
    Label49: TLabel;
    AlarmMsgEdit: TEdit;
    advPageControl1: TAdvPageControl;
    procedure LowAlarmEnableCBClick(Sender: TObject);
    procedure MaxAlarmEnableCBClick(Sender: TObject);
    procedure LowFaultEnableCBClick(Sender: TObject);
    procedure MaxFaultEnableCBClick(Sender: TObject);
    procedure DigitalAlarmEnableCBClick(Sender: TObject);
  private
    procedure DisableOtherAlarmConfigUI(AExceptAlarm: TAlarmSetType);
  public
    FIsOnlyOneSelect: Boolean;

    procedure LoadConfigEngParamItem2Form(AEPItem:TEngineParameterItem);
    function LoadConfigForm2EngParamItem(AEP: TEngineParameter;
      AEPItem:TEngineParameterItem): integer;

    procedure LimitValue2Form(AEPItem:TEngineParameterItem);
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

procedure TEngParamItemConfigForm.DigitalAlarmEnableCBClick(Sender: TObject);
begin
  DigitalAlarmGroup.Enabled := DigitalAlarmEnableCB.Checked;
end;

procedure TEngParamItemConfigForm.DisableOtherAlarmConfigUI(
  AExceptAlarm: TAlarmSetType);
begin
  case AExceptAlarm of
    astLoLo: begin
      LowAlarmEnableCB.Enabled := False;
      MaxAlarmEnableCB.Enabled := False;
      MaxFaultEnableCB.Enabled := False;

      LowAlarmGroup.Enabled := False;
      MaxAlarmGroup.Enabled := False;
      MaxFaultGroup.Enabled := False;
    end;
    astLo: begin
      LowFaultEnableCB.Enabled := False;
      MaxAlarmEnableCB.Enabled := False;
      MaxFaultEnableCB.Enabled := False;

      LowFaultGroup.Enabled := False;
      MaxAlarmGroup.Enabled := False;
      MaxFaultGroup.Enabled := False;
    end;
    astHiHi: begin
      LowAlarmEnableCB.Enabled := False;
      LowFaultEnableCB.Enabled := False;
      MaxAlarmEnableCB.Enabled := False;

      LowAlarmGroup.Enabled := False;
      LowFaultGroup.Enabled := False;
      MaxAlarmGroup.Enabled := False;
    end;
    astHi: begin
      LowAlarmEnableCB.Enabled := False;
      LowFaultEnableCB.Enabled := False;
      MaxFaultEnableCB.Enabled := False;

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
  MaxFaultDeadBandEdit.Text := FloatToStr(AEPItem.MaxFaultDeadBand);
  MaxFaultDelayEdit.Text := FloatToStr(AEPItem.MaxFaultDelay);
  MaxFaultColorSelector.SelectedColor := AEPItem.MaxFaultColor;
  MaxFaultBlinkCB.Checked := AEPItem.MaxFaultBlink;
  MaxFaultNeedAckCB.Checked := AEPItem.MaxFaultNeedAck;
  MaxFaultSoundCB.Checked := AEPItem.MaxFaultSoundEnable;
  MaxFaultSoundEdit.FileName := AEPItem.MaxFaultSoundFilename;
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
  LimitValue2Form(AEPItem);

  MinEdit.Text := FloatToStr(AEPItem.YAxesMinValue);
  SpanEdit.Text := FloatToStr(AEPItem.YAxesSpanValue);
end;

function TEngParamItemConfigForm.LoadConfigForm2EngParamItem(AEP: TEngineParameter;
  AEPItem: TEngineParameterItem): integer;
begin
  Result := AEP.GetItemIndex(AEPItem);

  if Result <> -1 then
  begin
    with AEP.EngineParameterCollect.Items[Result] do
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


      if ParameterSource = psManualInput then
        Value := ManualInputValueEdit.Text;

      //--------- Classfy Page --------------
      SensorType := String2SensorType(SensorTypeCombo.Text);
      ParameterCatetory := String2ParameterCatetory(ParamCategoryCombo.Text);
      ParameterType := String2ParameterType(ParamTypeCombo.Text);
      ParameterSource := String2ParameterSource(ParamSourceCombo.Text);

      //--------- Limit Value Page --------------
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

      YAxesMinValue := StrToFloatDef(MinEdit.Text, 0.0);
      YAxesSpanValue := StrToFloatDef(SpanEdit.Text, 0.0);
    end;//with
  end; //if
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

procedure TEngParamItemConfigForm.MaxAlarmEnableCBClick(Sender: TObject);
begin
  MaxAlarmGroup.Enabled := MaxAlarmEnableCB.Checked;

  if FIsOnlyOneSelect and MaxAlarmGroup.Enabled then
    DisableOtherAlarmConfigUI(astHi);
end;

end.
