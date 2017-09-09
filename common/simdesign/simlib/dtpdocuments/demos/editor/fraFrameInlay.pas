{
  Unit fraFrameInlay

  Implements the frame inlay TFrame

  This frame is loaded into its container in:
  fraEffect.TfrEffect.GetInlayClassForEffect

  Project: DTP-Engine

  Creation Date: 05-11-2003 (NH)
  Version: 1.0

  Modifications:

  Copyright (c) 2003 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.
}
unit fraFrameInlay;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fraInlay, StdCtrls, ExtCtrls, ComCtrls, ColorPickerButton;

type
  TfrFrameInlay = class(TfrInlay)
    Label8: TLabel;
    cpbFrameColor: TColorPickerButton;
    Label7: TLabel;
    edFrameWidth: TEdit;
    Bevel3: TBevel;
    Label9: TLabel;
    cpbFillColor: TColorPickerButton;
    trbFillAlpha: TTrackBar;
    Label10: TLabel;
    lbFillAlpha: TLabel;
    edFrameSpacing: TEdit;
    edFrameRadius: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    procedure cpbFrameColorChange(Sender: TObject);
    procedure edFrameWidthExit(Sender: TObject);
    procedure edFrameSpacingExit(Sender: TObject);
    procedure edFrameRadiusExit(Sender: TObject);
    procedure cpbFillColorChange(Sender: TObject);
    procedure trbFillAlphaChange(Sender: TObject);
  private
  protected
    procedure EffectToFrame; override;
  public
  end;

var
  frFrameInlay: TfrFrameInlay;

implementation

{$R *.DFM}

uses
  dtpFrameEffects;

{ TfrFrameInlay }

procedure TfrFrameInlay.EffectToFrame;
begin
  inherited;
  if Effect is TdtpFrameEffect then with TdtpFrameEffect(Effect) do begin
    // Frame
    edFrameWidth.Text   := Format('%3.1f', [FrameWidth]);
    edFrameSpacing.Text := Format('%3.1f', [FrameSpacing]);
    edFrameRadius.Text  := Format('%3.1f', [FrameRadius]);
    cpbFrameColor.SelectionColor := FrameColor;
    // Fill
    cpbFillColor.SelectionColor := FillColor;
    trbFillAlpha.Position := FillAlpha;
    lbFillAlpha.Caption := IntToStr(FillAlpha);
  end;

end;

procedure TfrFrameInlay.cpbFrameColorChange(Sender: TObject);
begin
  if FUpdating then exit;
  TdtpFrameEffect(Effect).FrameColor := cpbFrameColor.SelectionColor;
end;

procedure TfrFrameInlay.edFrameWidthExit(Sender: TObject);
begin
  if FUpdating then exit;
  TdtpFrameEffect(Effect).FrameWidth := StrToFloat(edFrameWidth.Text);
end;

procedure TfrFrameInlay.edFrameSpacingExit(Sender: TObject);
begin
  if FUpdating then exit;
  TdtpFrameEffect(Effect).FrameSpacing := StrToFloat(edFrameSpacing.Text);
end;

procedure TfrFrameInlay.edFrameRadiusExit(Sender: TObject);
begin
  if FUpdating then exit;
  TdtpFrameEffect(Effect).FrameRadius := StrToFloat(edFrameRadius.Text);
end;

procedure TfrFrameInlay.cpbFillColorChange(Sender: TObject);
begin
  if FUpdating then exit;
  TdtpFrameEffect(Effect).FillColor := cpbFillColor.SelectionColor;
end;

procedure TfrFrameInlay.trbFillAlphaChange(Sender: TObject);
begin
  if FUpdating then exit;
  TdtpFrameEffect(Effect).FillAlpha := trbFillAlpha.Position;
end;

end.
