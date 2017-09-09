{
  unit fraGradientInlay

  Gradient effect inlay

}
unit fraGradientInlay;

interface

{$i simdesign.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fraInlay, ExtCtrls, StdCtrls, ColorPickerButton, ComCtrls, dtpGraphics;

type
  TfrGradientInlay = class(TfrInlay)
    lbReplace: TLabel;
    rbRed: TRadioButton;
    rbGreen: TRadioButton;
    rbBlue: TRadioButton;
    GroupBox1: TGroupBox;
    cpbColor1: TColorPickerButton;
    rbUseColors: TRadioButton;
    cpbColor2: TColorPickerButton;
    rbUsePreset: TRadioButton;
    cbbPreset: TComboBox;
    Label1: TLabel;
    cbbDirection: TComboBox;
    Label2: TLabel;
    cbbFillMethod: TComboBox;
    Label4: TLabel;
    trbAlpha1: TTrackBar;
    trbAlpha2: TTrackBar;
    cbbSource: TComboBox;
    Label3: TLabel;
    rbAlpha: TRadioButton;
    rbAny: TRadioButton;
    procedure rbRedClick(Sender: TObject);
    procedure rbGreenClick(Sender: TObject);
    procedure rbBlueClick(Sender: TObject);
    procedure rbUseColorsClick(Sender: TObject);
    procedure rbUsePresetClick(Sender: TObject);
    procedure cpbColor1Change(Sender: TObject);
    procedure cpbColor2Change(Sender: TObject);
    procedure trbAlpha1Change(Sender: TObject);
    procedure trbAlpha2Change(Sender: TObject);
    procedure cbbPresetChange(Sender: TObject);
    procedure cbbDirectionChange(Sender: TObject);
    procedure cbbFillMethodChange(Sender: TObject);
    procedure cbbSourceChange(Sender: TObject);
    procedure rbAlphaClick(Sender: TObject);
    procedure rbAnyClick(Sender: TObject);
  private
  protected
    procedure EffectToFrame; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  frGradientInlay: TfrGradientInlay;

implementation

{$R *.DFM}

uses
  dtpGradientEffects;

{ TfrGradientInlay }

constructor TfrGradientInlay.Create(AOwner: TComponent);
var
  i: integer;
begin
  inherited;
  // Fill combobox preset
  cbbPreset.Clear;
  for i := 0 to cgrPresetCount - 1 do
    cbbPreset.Items.Add(cgrPresetStrings[i]);
  // Fill combobox direction
  cbbDirection.Clear;
  for i := 0 to cgrDirectionCount - 1 do
    cbbDirection.Items.Add(cgrDirectionStrings[i]);
  // Fill combobox fillmethod
  cbbFillMethod.Clear;
  for i := 0 to cgrFillMethodCount - 1 do
    cbbFillMethod.Items.Add(cgrFillMethodStrings[i]);
end;

procedure TfrGradientInlay.EffectToFrame;
// Translate the effect properties to frame values
var
  i: integer;
begin
  inherited;
  if Effect is TdtpGradientEffect then with TdtpGradientEffect(Effect) do begin
    rbRed.Checked   := Replace = rtReplaceRed;
    rbGreen.Checked := Replace = rtReplaceGreen;
    rbBlue.Checked  := Replace = rtReplaceBlue;
    rbAlpha.Checked := Replace = rtReplaceAlpha;
    rbAny.Checked   := Replace = rtReplaceAny;
    rbUseColors.Checked := PaletteMethod = pmTwoColors;
    rbUsePreset.Checked := PaletteMethod = pmPreset;
    cpbColor1.SelectionColor := WinColor(Color1);
    cpbColor2.SelectionColor := WinColor(Color2);
    trbAlpha1.Position := AlphaComponent(Color1);
    trbAlpha2.Position := AlphaComponent(Color2);
    cbbPreset.ItemIndex := Preset;
    cbbDirection.ItemIndex := Direction;
    cbbFillMethod.ItemIndex := FillMethod;
    // Source
    cbbSource.Clear;
    cbbSource.Items.Add('Previous effect');
    cbbSource.Items.Add('Original shape');
    if assigned(Parent) then with Parent do
      for i := 0 to EffectCount - 1 do begin
        if (Effects[i] = Effect) then break;
        cbbSource.Items.Add(Format('Effect %d (%s)', [i + 1, Effects[i].EffectName]));
      end;
    cbbSource.ItemIndex := Source + 2;
  end;
end;

procedure TfrGradientInlay.rbRedClick(Sender: TObject);
begin
  if FUpdating then exit;
  TdtpGradientEffect(Effect).Replace := rtReplaceRed;
end;

procedure TfrGradientInlay.rbGreenClick(Sender: TObject);
begin
  if FUpdating then exit;
  TdtpGradientEffect(Effect).Replace := rtReplaceGreen;
end;

procedure TfrGradientInlay.rbBlueClick(Sender: TObject);
begin
  if FUpdating then exit;
  TdtpGradientEffect(Effect).Replace := rtReplaceBlue;
end;

procedure TfrGradientInlay.rbAlphaClick(Sender: TObject);
begin
  if FUpdating then exit;
  TdtpGradientEffect(Effect).Replace := rtReplaceAlpha;
end;

procedure TfrGradientInlay.rbAnyClick(Sender: TObject);
begin
  if FUpdating then exit;
  TdtpGradientEffect(Effect).Replace := rtReplaceAny;
end;

procedure TfrGradientInlay.rbUseColorsClick(Sender: TObject);
begin
  if FUpdating then exit;
  TdtpGradientEffect(Effect).PaletteMethod := pmTwoColors;
end;

procedure TfrGradientInlay.rbUsePresetClick(Sender: TObject);
begin
  if FUpdating then exit;
  TdtpGradientEffect(Effect).PaletteMethod := pmPreset;
end;

procedure TfrGradientInlay.cpbColor1Change(Sender: TObject);
begin
  if FUpdating then exit;
  with TdtpGradientEffect(Effect) do
    Color1 := SetAlpha(dtpColor(cpbColor1.SelectionColor), AlphaComponent(Color1));
end;

procedure TfrGradientInlay.cpbColor2Change(Sender: TObject);
begin
  if FUpdating then exit;
  with TdtpGradientEffect(Effect) do
    Color2 := SetAlpha(dtpColor(cpbColor2.SelectionColor), AlphaComponent(Color2));
end;

procedure TfrGradientInlay.trbAlpha1Change(Sender: TObject);
begin
  if FUpdating then exit;
  with TdtpGradientEffect(Effect) do
    Color1 := SetAlpha(Color1, trbAlpha1.Position);
end;

procedure TfrGradientInlay.trbAlpha2Change(Sender: TObject);
begin
  if FUpdating then exit;
  with TdtpGradientEffect(Effect) do
    Color2 := SetAlpha(Color2, trbAlpha2.Position);
end;

procedure TfrGradientInlay.cbbPresetChange(Sender: TObject);
begin
  if FUpdating then exit;
  TdtpGradientEffect(Effect).Preset := cbbPreset.ItemIndex;
end;

procedure TfrGradientInlay.cbbDirectionChange(Sender: TObject);
begin
  if FUpdating then exit;
  TdtpGradientEffect(Effect).Direction := cbbDirection.ItemIndex;
end;

procedure TfrGradientInlay.cbbFillMethodChange(Sender: TObject);
begin
  if FUpdating then exit;
  TdtpGradientEffect(Effect).FillMethod := cbbFillMethod.ItemIndex;
end;

procedure TfrGradientInlay.cbbSourceChange(Sender: TObject);
begin
  if FUpdating then exit;
  TdtpGradientEffect(Effect).Source := cbbSource.ItemIndex - 2;
end;

end.
