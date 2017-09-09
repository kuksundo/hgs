unit fraShadowInlay;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fraInlay, StdCtrls, ExtCtrls, ComCtrls, ColorPickerButton;

const

  cBlurAxisLength      = 15.0;
  cIntensityAxisLength =  2.0;

type

  TfrShadowInlay = class(TfrInlay)
    Width: TLabel;
    edDeltaX: TEdit;
    Label1: TLabel;
    edDeltaY: TEdit;
    trbBlur: TTrackBar;
    Label2: TLabel;
    lbBlur: TLabel;
    trbIntensity: TTrackBar;
    Label3: TLabel;
    lbIntensity: TLabel;
    cpbColor: TColorPickerButton;
    Label5: TLabel;
    procedure trbIntensityChange(Sender: TObject);
    procedure trbBlurChange(Sender: TObject);
    procedure cpbColorChange(Sender: TObject);
    procedure edDeltaXExit(Sender: TObject);
    procedure edDeltaYExit(Sender: TObject);
  private
  protected
    procedure EffectToFrame; override;
  public
    { Public declarations }
  end;

var
  frShadowInlay: TfrShadowInlay;

implementation

{$R *.DFM}

uses
  dtpShadowEffects;

{ TfrShadowInlay }

procedure TfrShadowInlay.EffectToFrame;
begin
  inherited;
  if Effect is TdtpShadowEffect then with TdtpShadowEffect(Effect) do begin
    edDeltaX.Text := Format('%3.1f', [DeltaX]);
    edDeltaY.Text := Format('%3.1f', [DeltaY]);
    cpbColor.SelectionColor := Color;
    // Blur
    lbBlur.Caption := Format('%3.1f', [Blur]);
    // Divide by axis lenght, then scale up to [0, 1000]
    trbBlur.Position := round(Blur / cBlurAxisLength * 1000);
    // Intensity
    lbIntensity.Caption := Format('%3.1f%%', [Intensity * 100]);
    // scale up to [0, 1000]
    trbIntensity.Position := round(Intensity / cIntensityAxisLength * 1000);
  end;
end;

procedure TfrShadowInlay.trbIntensityChange(Sender: TObject);
begin
  if FUpdating then exit;
  with TdtpShadowEffect(Effect) do begin
    NextUndoNoRepeatedPropertyChange;
    Intensity :=
      // Scale back
      trbIntensity.Position / 1000 * cIntensityAxisLength;
  end;
end;

procedure TfrShadowInlay.trbBlurChange(Sender: TObject);
begin
  if FUpdating then exit;
  with TdtpShadowEffect(Effect) do begin
    NextUndoNoRepeatedPropertyChange;
    Blur :=
      // Scale back
      trbBlur.Position / 1000 * cBlurAxisLength;
  end;
end;

procedure TfrShadowInlay.cpbColorChange(Sender: TObject);
begin
  if FUpdating then exit;
  TdtpShadowEffect(Effect).Color := cpbColor.SelectionColor;
end;

procedure TfrShadowInlay.edDeltaXExit(Sender: TObject);
begin
  if FUpdating then exit;
  TdtpShadowEffect(Effect).DeltaX := StrToFloat(edDeltaX.Text);
end;

procedure TfrShadowInlay.edDeltaYExit(Sender: TObject);
begin
  if FUpdating then exit;
  TdtpShadowEffect(Effect).DeltaY := StrToFloat(edDeltaY.Text);
end;

end.
