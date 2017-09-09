unit fraExposedMetafile;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fraShape, StdCtrls, ComCtrls, ExtCtrls, ColorPickerButton, dtpExposedMetafile;

type
  TfrExposedMetafile = class(TfrShape)
    chbOverridePen: TCheckBox;
    cpbPenColor: TColorPickerButton;
    Label7: TLabel;
    Width: TLabel;
    edPenWidth: TEdit;
    chbOverrideBrush: TCheckBox;
    Label8: TLabel;
    cpbBrushColor: TColorPickerButton;
    Label9: TLabel;
    cbbBrushStyle: TComboBox;
    chbPreserveAspect: TCheckBox;
    procedure chbOverridePenClick(Sender: TObject);
    procedure chbOverrideBrushClick(Sender: TObject);
    procedure cpbPenColorChange(Sender: TObject);
    procedure cpbBrushColorChange(Sender: TObject);
    procedure cbbBrushStyleChange(Sender: TObject);
    procedure edPenWidthExit(Sender: TObject);
    procedure chbPreserveAspectClick(Sender: TObject);
  private
  protected
    procedure ShapesToFrame; override;
  public
  end;

var
  frExposedMetafile: TfrExposedMetafile;

implementation

{$R *.DFM}

{ TfrExposedMetafile }

procedure TfrExposedMetafile.cbbBrushStyleChange(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    if (Shapes[i] is TdtpExposedMetafile) then
      TdtpExposedMetafile(Shapes[i]).Brush.Style := TBrushStyle(cbbBrushStyle.ItemIndex);
  EndUpdate;
end;

procedure TfrExposedMetafile.chbOverrideBrushClick(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    if (Shapes[i] is TdtpExposedMetafile) then
      TdtpExposedMetafile(Shapes[i]).OverrideBrush := chbOverrideBrush.Checked;
  EndUpdate;
end;

procedure TfrExposedMetafile.chbOverridePenClick(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    if (Shapes[i] is TdtpExposedMetafile) then
      TdtpExposedMetafile(Shapes[i]).OverridePen := chbOverridePen.Checked;
  EndUpdate;
end;

procedure TfrExposedMetafile.chbPreserveAspectClick(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    if (Shapes[i] is TdtpExposedMetafile) then
      TdtpExposedMetafile(Shapes[i]).PreserveAspect := chbPreserveAspect.Checked;
  EndUpdate;
end;

procedure TfrExposedMetafile.cpbBrushColorChange(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    if (Shapes[i] is TdtpExposedMetafile) then
      TdtpExposedMetafile(Shapes[i]).Brush.Color := cpbBrushColor.SelectionColor;
  EndUpdate;
end;

procedure TfrExposedMetafile.cpbPenColorChange(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    if (Shapes[i] is TdtpExposedMetafile) then
      TdtpExposedMetafile(Shapes[i]).Pen.Color := cpbPenColor.SelectionColor;
  EndUpdate;
end;

procedure TfrExposedMetafile.edPenWidthExit(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    if (Shapes[i] is TdtpExposedMetafile) then
      TdtpExposedMetafile(Shapes[i]).Pen.Width := StrToInt(edPenWidth.Text);
  EndUpdate;
end;

procedure TfrExposedMetafile.ShapesToFrame;
var
  i: integer;
begin
  inherited;
  if ShapeCount = 0 then exit;
  // Title
  if ShapeCount = 1 then
    lblTitle.Caption := 'Exposed Metafile'
  else
    lblTitle.Caption := Format('Exposed Metafiles (%d items)', [ShapeCount]);
  // Main shape
  if Shapes[0] is TdtpExposedMetafile then with TdtpExposedMetafile(Shapes[0]) do begin

    // Overrides
    chbOverridePen.Checked   := OverridePen;
    chbOverrideBrush.Checked := OverrideBrush;


    cpbPenColor.SelectionColor   := Pen.Color;
    edPenWidth.Text              := IntToStr(Pen.Width);
    cpbBrushColor.SelectionColor := Brush.Color;
    cbbBrushStyle.ItemIndex      := integer(Brush.Style);

    chbPreserveAspect.Checked    := PreserveAspect;
  end;
  // Additional shapes
  for i := 1 to ShapeCount - 1 do
    if Shapes[i] is TdtpExposedMetafile then with TdtpExposedMetafile(Shapes[i]) do begin
    //
    end;
end;

end.
