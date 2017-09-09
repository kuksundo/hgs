unit fraPolygonShape;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fraShape, StdCtrls, ComCtrls, ExtCtrls, dtpPolygonShape,
  ColorPickerButton;

type
  TfrPolygonShape = class(TfrShape)
    chbPreserveAspect: TCheckBox;
    chbUseOutline: TCheckBox;
    Label8: TLabel;
    cpbOutlineColor: TColorPickerButton;
    Label7: TLabel;
    edOutlineWidth: TEdit;
    chbUseFill: TCheckBox;
    Label9: TLabel;
    cpbFillColor: TColorPickerButton;
    Label10: TLabel;
    trbFillAlpha: TTrackBar;
    lbFillAlpha: TLabel;
    Bevel3: TBevel;
    procedure chbPreserveAspectClick(Sender: TObject);
    procedure chbUseOutlineClick(Sender: TObject);
    procedure chbUseFillClick(Sender: TObject);
    procedure cpbOutlineColorChange(Sender: TObject);
    procedure cpbFillColorChange(Sender: TObject);
    procedure trbFillAlphaChange(Sender: TObject);
    procedure edOutlineWidthExit(Sender: TObject);
  private
  protected
    procedure ShapesToFrame; override;
  public
  end;

var
  frPolygonShape: TfrPolygonShape;

  // Some non-persistent globals used as defaults
  FFillAlpha: cardinal = 255;
  FUseFill: boolean = True;
  FUseOutline: boolean = True;
  FFillColor: TColor = clBlue;
  FOutlineColor: TColor = clBlack;
  FOutlineWidth: single = 0.5;

procedure SetPolygonShapeDefaults(APoly: TdtpPolygonShape);

implementation

{$R *.DFM}

procedure SetPolygonShapeDefaults(APoly: TdtpPolygonShape);
begin
  if not assigned(APoly) then exit;
  with APoly do begin
    FillAlpha := FFillAlpha;
    UseFill := FUseFill;
    UseOutline := FUseOutline;
    FillColor := FFillColor;
    OutlineColor := FOutlineColor;
    OutlineWidth := FOutlineWidth;
  end;
end;

{ TfrPolygonShape }

procedure TfrPolygonShape.chbPreserveAspectClick(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    if (Shapes[i] is TdtpPolygonShape) then
      TdtpPolygonShape(Shapes[i]).PreserveAspect := chbPreserveAspect.Checked;
  EndUpdate;
end;

procedure TfrPolygonShape.chbUseFillClick(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  FUseFill := chbUseFill.Checked;
  for i := 0 to ShapeCount - 1 do
    if (Shapes[i] is TdtpPolygonShape) then
      TdtpPolygonShape(Shapes[i]).UseFill := chbUseFill.Checked;
  EndUpdate;
end;

procedure TfrPolygonShape.chbUseOutlineClick(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  FUseOutline := chbUseOutline.Checked;
  for i := 0 to ShapeCount - 1 do
    if (Shapes[i] is TdtpPolygonShape) then
      TdtpPolygonShape(Shapes[i]).UseOutline := chbUseOutline.Checked;
  EndUpdate;
end;

procedure TfrPolygonShape.cpbFillColorChange(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  FFillColor := cpbFillColor.SelectionColor;
  for i := 0 to ShapeCount - 1 do
    if (Shapes[i] is TdtpPolygonShape) then
      TdtpPolygonShape(Shapes[i]).FillColor := cpbFillColor.SelectionColor;
  EndUpdate;
end;

procedure TfrPolygonShape.cpbOutlineColorChange(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  FOutlineColor := cpbOutlineColor.SelectionColor;
  for i := 0 to ShapeCount - 1 do
    if (Shapes[i] is TdtpPolygonShape) then
      TdtpPolygonShape(Shapes[i]).OutlineColor := cpbOutlineColor.SelectionColor;
  EndUpdate;
end;

procedure TfrPolygonShape.edOutlineWidthExit(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  FOutlineWidth := StrToFloat(edOutlineWidth.Text);
  for i := 0 to ShapeCount - 1 do
    if (Shapes[i] is TdtpPolygonShape) then
      TdtpPolygonShape(Shapes[i]).OutlineWidth := StrToFloat(edOutlineWidth.Text);
  EndUpdate;
end;

procedure TfrPolygonShape.ShapesToFrame;
var
  i: integer;
  ATitle: string;
begin
  inherited;
  if ShapeCount = 0 then exit;
  // Title
  if Shapes[0].ClassType = TdtpEllipseShape then
    Atitle := 'Ellipse'
  else if Shapes[0].ClassType = TdtpRectangleShape then
    ATitle := 'Rectangle'
  else if Shapes[0].ClassType = TdtpRoundRectShape then
    ATitle := 'Rounded Rectangle'
  else
    ATitle := 'Polygon Shape';
  // Title
  if ShapeCount = 1 then
    lblTitle.Caption := ATitle
  else
    lblTitle.Caption := Format('%ss (%d items)', [ATitle, ShapeCount]);
  // Main shape
  if Shapes[0] is TdtpPolygonShape then with TdtpPolygonShape(Shapes[0]) do begin

    // Outline
    chbUseOutline.Checked          := UseOutline;
    cpbOutlineColor.SelectionColor := OutlineColor;
    edOutlineWidth.Text            := Format('%3.1f', [OutlineWidth]);

    // Fill
    chbUseFill.Checked             := UseFill;
    cpbFillColor.SelectionColor    := FillColor;
    trbFillAlpha.Position          := FillAlpha;
    lbFillAlpha.Caption            := IntToStr(FillAlpha);

    // Aspect ratio
    chbPreserveAspect.Checked := PreserveAspect;

  end;

  // Additional shapes
  for i := 1 to ShapeCount - 1 do
    if Shapes[i] is TdtpPolygonShape then with TdtpPolygonShape(Shapes[i]) do begin
{      if edImageName.Text <> Image.FileName then
        edImageName.Text := '';}
    end;
end;

procedure TfrPolygonShape.trbFillAlphaChange(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  FFillAlpha := trbFillAlpha.Position;
  for i := 0 to ShapeCount - 1 do
    if (Shapes[i] is TdtpPolygonShape) then
      with TdtpPolygonShape(Shapes[i]) do begin
        // This ensures that we don't get 1001 undo states when moving the slider
        // up and down
        NextUndoNoRepeatedPropertyChange;
        FillAlpha := trbFillAlpha.Position;
      end;
  EndUpdate;
end;

end.
