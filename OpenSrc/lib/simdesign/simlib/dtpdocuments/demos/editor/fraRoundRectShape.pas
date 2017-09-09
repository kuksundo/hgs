unit fraRoundRectShape;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fraPolygonShape, StdCtrls, ComCtrls, ExtCtrls, ColorPickerButton,
  dtpPolygonShape;

type
  TfrRoundRectShape = class(TfrPolygonShape)
    Label11: TLabel;
    edCornerWidth: TEdit;
    Label12: TLabel;
    edCornerHeight: TEdit;
    procedure edCornerWidthExit(Sender: TObject);
    procedure edCornerHeightExit(Sender: TObject);
  private
  protected
    procedure ShapesToFrame; override;
  public
  end;

var
  frRoundRectShape: TfrRoundRectShape;

implementation

{$R *.DFM}

{ TfrRoundRectShape }

procedure TfrRoundRectShape.ShapesToFrame;
var
  i: integer;
  ATitle: string;
begin
  inherited;
  ATitle := 'Rounded Rectangle';
  // Title
  if ShapeCount = 1 then
    lblTitle.Caption := ATitle
  else
    lblTitle.Caption := Format('%ss (%d items)', [ATitle, ShapeCount]);

  // Main shape
  if Shapes[0] is TdtpRoundRectShape then with TdtpRoundRectShape(Shapes[0]) do begin

    // Corner width/height
    edCornerWidth.Text  := Format('%3.1f', [CornerWidth]);
    edCornerHeight.Text := Format('%3.1f', [CornerHeight]);

  end;

  // Additional shapes
  for i := 1 to ShapeCount - 1 do
    if Shapes[i] is TdtpPolygonShape then with TdtpPolygonShape(Shapes[i]) do begin
{      if edImageName.Text <> Image.FileName then
        edImageName.Text := '';}
    end;
end;

procedure TfrRoundRectShape.edCornerWidthExit(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    if (Shapes[i] is TdtpRoundRectShape) then
      TdtpRoundRectShape(Shapes[i]).CornerWidth := StrToFloat(edCornerWidth.Text);
  EndUpdate;
end;

procedure TfrRoundRectShape.edCornerHeightExit(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    if (Shapes[i] is TdtpRoundRectShape) then
      TdtpRoundRectShape(Shapes[i]).CornerHeight := StrToFloat(edCornerHeight.Text);
  EndUpdate;
end;

end.
