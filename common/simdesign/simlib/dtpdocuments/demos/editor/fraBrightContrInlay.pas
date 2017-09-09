{
  Contrast is limited from 0 to 4, Brightness from -200 to +200

  The control for contrast is made so that around 1 it is more sensitive

}
unit fraBrightContrInlay;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fraInlay, ExtCtrls, ComCtrls, StdCtrls;

const
  // Limit brightness correction to [-AxisLength, +AxisLength]
  cBrightnessAxisLength = 200;

type
  TfrBrightContrInlay = class(TfrInlay)
    Label1: TLabel;
    lbBrightness: TLabel;
    trbBrightness: TTrackBar;
    Label2: TLabel;
    lbContrast: TLabel;
    trbContrast: TTrackBar;
    procedure trbBrightnessChange(Sender: TObject);
    procedure trbContrastChange(Sender: TObject);
  private
  protected
    procedure EffectToFrame; override;
  public
  end;

var
  frBrightContrInlay: TfrBrightContrInlay;

implementation

{$R *.DFM}

uses
  dtpColorEffects;

procedure TfrBrightContrInlay.EffectToFrame;
// Use the effect props to set the control values
begin
  inherited;
  if Effect is TdtpBrightContrEffect then with TdtpBrightContrEffect(Effect) do begin
    // Brightness
    lbBrightness.Caption := Format('%3.1f', [Brightness]);
    // Divide by 200, then scale up to [-1000, 1000]
    trbBrightness.Position := round(Brightness / cBrightnessAxisLength * 1000);
    // Contrast
    lbContrast.Caption := Format('%2.2f', [Contrast]);
    // sqrt, then move to [-1, 1], then scale up to [-1000, 1000]
    trbContrast.Position := round((sqrt(Contrast) - 1) * 1000);
  end;
end;

procedure TfrBrightContrInlay.trbBrightnessChange(Sender: TObject);
begin
  if FUpdating then exit;
  with TdtpBrightContrEffect(Effect) do begin
    NextUndoNoRepeatedPropertyChange;
    Brightness :=
      // Scale down to [-1, 1] and scale up to [-200, 200]
      trbBrightness.Position / 1000 * cBrightnessAxisLength;
  end;
end;

procedure TfrBrightContrInlay.trbContrastChange(Sender: TObject);
begin
  if FUpdating then exit;
  with TdtpBrightContrEffect(Effect) do begin
    NextUndoNoRepeatedPropertyChange;
    Contrast :=
      // Scale to [-1, 1] and then move to [0, 2], then square so we're in [0, 4]
      sqr((trbContrast.Position / 1000) + 1);
  end;    
end;

end.
