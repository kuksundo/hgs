unit fraLineShape;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, fraPolygonShape, StdCtrls, ComCtrls, ExtCtrls, ColorPickerButton,
  dtpLineShape, dtpDefaults;

type
  TfrLineShape = class(TfrPolygonShape)
    Label11: TLabel;
    edLineWidth: TEdit;
    cbbArrow1Style: TComboBox;
    Label12: TLabel;
    Label13: TLabel;
    cbbArrow2Style: TComboBox;
    edArrow1Width: TEdit;
    Label14: TLabel;
    edArrow1Length: TEdit;
    Label16: TLabel;
    Label17: TLabel;
    edArrow2Width: TEdit;
    edArrow2Length: TEdit;
    Label15: TLabel;
    procedure edLineWidthExit(Sender: TObject);
    procedure cbbArrow1StyleChange(Sender: TObject);
    procedure cbbArrow2StyleChange(Sender: TObject);
    procedure edArrow1WidthExit(Sender: TObject);
    procedure edArrow2WidthExit(Sender: TObject);
    procedure edArrow1LengthExit(Sender: TObject);
    procedure edArrow2LengthExit(Sender: TObject);
  private
  protected
    procedure ShapesToFrame; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  frLineShape: TfrLineShape;

implementation

{$R *.dfm}

{ TfrLineShape }

constructor TfrLineShape.Create(AOwner: TComponent);
var
  i: integer;
begin
  inherited;
  // The Arrow style dropdown boxes
  cbbArrow1Style.Items.Clear;
  cbbArrow2Style.Items.Clear;
  for i := 0 to cArrowStyleCount - 1 do begin
    cbbArrow1Style.Items.Add(cArrowStyleNames[i]);
    cbbArrow2Style.Items.Add(cArrowStyleNames[i]);
  end;
end;

procedure TfrLineShape.ShapesToFrame;
var
  i: integer;
begin
  inherited;
  if ShapeCount = 0 then exit;
  // Title
  if ShapeCount = 1 then
    lblTitle.Caption := 'Line shape'
  else
    lblTitle.Caption := Format('Line shapes (%d items)', [ShapeCount]);
  // Main shape
  if Shapes[0] is TdtpLineShape then with TdtpLineShape(Shapes[0]) do begin
    // Linewidth
    edLineWidth.Text := Format(cDefaultMMFormat, [LineWidth]);
    // Arrow style
    cbbArrow1Style.ItemIndex := integer(Arrows[0].Style);
    cbbArrow2Style.ItemIndex := integer(Arrows[1].Style);
    // Width / Length
    edArrow1Width.Text := Format(cDefaultMMFormat, [Arrows[0].Width]);
    edArrow2Width.Text := Format(cDefaultMMFormat, [Arrows[1].Width]);
    edArrow1Length.Text := Format(cDefaultMMFormat, [Arrows[0].Length]);
    edArrow2Length.Text := Format(cDefaultMMFormat, [Arrows[1].Length]);

  end;
  // Additional shapes
  for i := 1 to ShapeCount - 1 do
    if Shapes[i] is TdtpLineShape then with TdtpLineShape(Shapes[i]) do begin
      if edLineWidth.Text <> Format(cDefaultMMFormat, [LineWidth]) then
        edLineWidth.Text := '';
      if cbbArrow1Style.ItemIndex <> integer(Arrows[0].Style) then
        cbbArrow1Style.ItemIndex := -1;
      if cbbArrow2Style.ItemIndex <> integer(Arrows[1].Style) then
        cbbArrow1Style.ItemIndex := -1;
    end;
end;

procedure TfrLineShape.edLineWidthExit(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    if (Shapes[i] is TdtpLineShape) then
      TdtpLineShape(Shapes[i]).LineWidth := StrToFloat(edLineWidth.Text);
  EndUpdate;
end;

procedure TfrLineShape.cbbArrow1StyleChange(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    if (Shapes[i] is TdtpLineShape) then
      TdtpLineShape(Shapes[i]).Arrows[0].Style := TdtpArrowStyle(cbbArrow1Style.ItemIndex);
  EndUpdate;
end;

procedure TfrLineShape.cbbArrow2StyleChange(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    if (Shapes[i] is TdtpLineShape) then
      TdtpLineShape(Shapes[i]).Arrows[1].Style := TdtpArrowStyle(cbbArrow2Style.ItemIndex);
  EndUpdate;
end;

procedure TfrLineShape.edArrow1WidthExit(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    if (Shapes[i] is TdtpLineShape) then
      TdtpLineShape(Shapes[i]).Arrows[0].Width := StrToFloat(edArrow1Width.Text);
  EndUpdate;
end;

procedure TfrLineShape.edArrow2WidthExit(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    if (Shapes[i] is TdtpLineShape) then
      TdtpLineShape(Shapes[i]).Arrows[1].Width := StrToFloat(edArrow2Width.Text);
  EndUpdate;
end;

procedure TfrLineShape.edArrow1LengthExit(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    if (Shapes[i] is TdtpLineShape) then
      TdtpLineShape(Shapes[i]).Arrows[0].Length := StrToFloat(edArrow1Length.Text);
  EndUpdate;
end;

procedure TfrLineShape.edArrow2LengthExit(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    if (Shapes[i] is TdtpLineShape) then
      TdtpLineShape(Shapes[i]).Arrows[1].Length := StrToFloat(edArrow2Length.Text);
  EndUpdate;
end;

end.
