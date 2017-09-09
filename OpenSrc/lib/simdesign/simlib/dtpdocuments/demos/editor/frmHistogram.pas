{
  Unit frmHistogram

  Implements a histogram dialog that shows red/green/blue/grayscale histogram
  of a shape.

  Creation Date: 03-10-2004 (NH)
  Version: 1.0

  Modifications:

  Copyright (c) 2004 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit frmHistogram;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, TeeProcs, TeEngine, Chart, Series, StdCtrls, dtpGraphics, dtpShape,
  dtpEffectShape, dtpColorEffects, Math;

type

  TfmHistogram = class(TForm)
    Chart1: TChart;
    srRed: TBarSeries;
    srGreen: TBarSeries;
    srBlue: TBarSeries;
    srGray: TBarSeries;
    btnOK: TButton;
    chbGrayScale: TCheckBox;
    chbRed: TCheckBox;
    chbGreen: TCheckBox;
    chbBlue: TCheckBox;
    chbAutoLevels: TCheckBox;
    procedure chbGrayScaleClick(Sender: TObject);
    procedure chbRedClick(Sender: TObject);
    procedure chbGreenClick(Sender: TObject);
    procedure chbBlueClick(Sender: TObject);
    procedure chbAutoLevelsClick(Sender: TObject);
  private
    RedH, GreenH, BlueH, GrayH: THistogram;
    FShape: TdtpShape;
    FEffect: TdtpBrightContrEffect;
    FAutoLevels: boolean; // reference to shape
    procedure SetDataFromBitmap(Bitmap: TdtpBitmap);
    procedure SetAutoLevels(const Value: boolean);
  public
    { Public declarations }
    procedure SetDataFromShape(AShape: TdtpShape);
    property AutoLevels: boolean read FAutoLevels write SetAutoLevels;
  end;

var
  fmHistogram: TfmHistogram;

implementation

{$R *.DFM}

{ TfmHistogram }

procedure TfmHistogram.SetDataFromBitmap(Bitmap: TdtpBitmap);
var
  i: integer;
  P: PByte;
begin
  srRed.Clear; srGreen.Clear; srBlue.Clear; srGray.Clear;
  if not assigned(Bitmap) then exit;

  // initialize
  P := @Bitmap.Bits[0];
  FillChar(BlueH,  SizeOf(THistogram), 0);
  FillChar(GreenH, SizeOf(THistogram), 0);
  FillChar(RedH,   SizeOf(THistogram), 0);
  FillChar(GrayH,  SizeOf(THistogram), 0);

  // count colors
  // (R * 61 + G * 174 + B * 21) / 256
  for i := 0 to Bitmap.Width * Bitmap.Height - 1 do begin
    inc(BlueH[P^]);  Inc(GrayH[P^],  21); inc(P);
    inc(GreenH[P^]); inc(GrayH[P^], 174); inc(P);
    inc(RedH[P^]);   inc(GrayH[P^],  61); inc(P);
    inc(P); // skip alpha
  end;
  for i := 0 to 255 do
    GrayH[i] := GrayH[i] shr 8;

  // Fill chart series
  for i := 0 to 255 do begin
    srBlue.AddXY(i, BlueH[i]);
    srGreen.AddXY(i, GreenH[i]);
    srRed.AddXY(i, RedH[i]);
    srGray.AddXY(i, GrayH[i]);
  end;
end;

procedure TfmHistogram.chbGrayScaleClick(Sender: TObject);
begin
  srGray.Active := chbGrayScale.Checked;
end;

procedure TfmHistogram.chbRedClick(Sender: TObject);
begin
  srRed.Active := chbRed.Checked;
end;

procedure TfmHistogram.chbGreenClick(Sender: TObject);
begin
  srGreen.Active := chbGreen.Checked;
end;

procedure TfmHistogram.chbBlueClick(Sender: TObject);
begin
  srBlue.Active := chbBlue.Checked;
end;

procedure TfmHistogram.SetDataFromShape(AShape: TdtpShape);
var
  Bitmap: TdtpBitmap;
begin
  FShape := AShape;
  chbAutoLevels.Enabled := FShape is TdtpEffectShape;
  Bitmap := FShape.ExportToBitmap(round(FShape.DocWidth), round(FShape.DocHeight));
  try
    SetDataFromBitmap(Bitmap);
  finally
    Bitmap.Free;
  end;
end;

procedure TfmHistogram.SetAutoLevels(const Value: boolean);
var
  Brightness, Contrast: single;
begin
  if FAutoLevels <> Value then begin
    FAutoLevels := Value;
    if FAutoLevels then begin
      FEffect := TdtpBrightContrEffect.Create;
      with TdtpEffectShape(FShape) do
        EffectAdd(FEffect);
    end else begin
      with TdtpEffectShape(FShape) do
        EffectRemove(FEffect);
      FEffect := nil;
    end;
    if assigned(FEffect) then begin
      CalculateAutoLevelsFromHistogram(GrayH, Brightness, Contrast);
      FEffect.Brightness := Brightness;
      FEffect.Contrast   := Contrast;
    end;
    SetDataFromShape(FShape);
  end;
end;

procedure TfmHistogram.chbAutoLevelsClick(Sender: TObject);
begin
  AutoLevels := chbAutoLevels.Checked;
end;

end.
