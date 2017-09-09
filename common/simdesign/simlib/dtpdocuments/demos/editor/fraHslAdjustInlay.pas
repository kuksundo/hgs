unit fraHslAdjustInlay;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fraInlay, ComCtrls, StdCtrls, ExtCtrls;

const
  // Axis lengths for scaling
  cHueAxisLength        = 1.0;
  cSaturationAxisLength = 1.0;
  cLightnessAxisLength  = 1.0;

type

  TfrHslAdjustInlay = class(TfrInlay)
    trbHue: TTrackBar;
    Label1: TLabel;
    lbHue: TLabel;
    Label2: TLabel;
    lbSaturation: TLabel;
    trbSaturation: TTrackBar;
    Label4: TLabel;
    lbLightness: TLabel;
    trbLightness: TTrackBar;
    procedure trbHueChange(Sender: TObject);
    procedure trbSaturationChange(Sender: TObject);
    procedure trbLightnessChange(Sender: TObject);
  private
  protected
    procedure EffectToFrame; override;
  public
  end;

var
  frHslAdjustInlay: TfrHslAdjustInlay;

implementation

{$R *.DFM}

uses
  dtpColorEffects;

{ TfrHslAdjustInlay }

procedure TfrHslAdjustInlay.EffectToFrame;
begin
  inherited;
  if Effect is TdtpHslAdjustEffect then with TdtpHslAdjustEffect(Effect) do begin
    // Hue
    lbHue.Caption := Format('%3.3f', [Hue]);
    // Scale to [-1000, 1000]
    trbHue.Position := round(Hue / cHueAxisLength * 1000);
    // Saturation
    lbSaturation.Caption := Format('%3.3f', [Saturation]);
    // Scale to [-1000, 1000]
    trbSaturation.Position := round(Saturation / cSaturationAxisLength * 1000);
    // Lightness
    lbLightness.Caption := Format('%3.3f', [Lightness]);
    // Scale to [-1000, 1000]
    trbLightness.Position := round(Lightness / cLightnessAxisLength * 1000);
  end;
end;

procedure TfrHslAdjustInlay.trbHueChange(Sender: TObject);
begin
  if FUpdating then exit;
  with TdtpHslAdjustEffect(Effect) do begin
    NextUndoNoRepeatedPropertyChange;
    Hue :=
      // Scale back
      trbHue.Position / 1000 * cHueAxisLength;
  end;
end;

procedure TfrHslAdjustInlay.trbSaturationChange(Sender: TObject);
begin
  if FUpdating then exit;
  with TdtpHslAdjustEffect(Effect) do begin
    NextUndoNoRepeatedPropertyChange;
    Saturation :=
      // Scale back
      trbSaturation.Position / 1000 * cSaturationAxisLength;
  end;
end;

procedure TfrHslAdjustInlay.trbLightnessChange(Sender: TObject);
begin
  if FUpdating then exit;
  with TdtpHslAdjustEffect(Effect) do begin
    NextUndoNoRepeatedPropertyChange;
    Lightness :=
      // Scale back
      trbLightness.Position / 1000 * cLightnessAxisLength;
  end;    
end;

end.
