unit fraCurvedText;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fraPolygonText, StdCtrls, ComCtrls, ExtCtrls, ColorPickerButton, dtpPolygonText,
  dtpDefaults;

type
  TfrCurvedText = class(TfrPolygonText)
    Label13: TLabel;
    edCurveAngle: TEdit;
    chbPerspective: TCheckBox;
    procedure edCurveAngleExit(Sender: TObject);
    procedure chbPerspectiveClick(Sender: TObject);
  private
  protected
    procedure ShapesToFrame; override;
  public
  end;

var
  frCurvedText: TfrCurvedText;

implementation

{$R *.DFM}

{ TfrCurvedText }

procedure TfrCurvedText.chbPerspectiveClick(Sender: TObject);
var
  i: integer;
begin
  BeginUpdate;
  if not FIsUpdating then for i := 0 to ShapeCount - 1 do
    if Shapes[i] is TdtpCurvedText then
      if chbPerspective.Checked then
        TdtpCurvedText(Shapes[i]).TransformMethod := tmPoints
      else
        TdtpCurvedText(Shapes[i]).TransformMethod := tmGlyphs;
  EndUpdate;
end;

procedure TfrCurvedText.edCurveAngleExit(Sender: TObject);
var
  i: integer;
begin
  BeginUpdate;
  if not FIsUpdating then for i := 0 to ShapeCount - 1 do
    if Shapes[i] is TdtpCurvedText then begin
      TdtpCurvedText(Shapes[i]).CurveAngle := StrToFloat(edCurveAngle.Text);
    end;
  EndUpdate;
end;

procedure TfrCurvedText.ShapesToFrame;
var
  i: integer;
begin
  inherited;
  if ShapeCount = 0 then exit;
  // Title
  if ShapeCount = 1 then
    lblTitle.Caption := 'Curved Text'
  else
    lblTitle.Caption := Format('Curved Texts (%d items)', [ShapeCount]);
  // Main shape
  if Shapes[0] is TdtpCurvedText then with TdtpCurvedText(Shapes[0]) do begin
    // Text
    edCurveAngle.Text := Format(cDefaultDegFormat, [CurveAngle]);
    chbPerspective.Checked := TransformMethod = tmPoints;
  end;
  // Additional shapes
  for i := 1 to ShapeCount - 1 do
    if Shapes[i] is TdtpPolygonText then with TdtpPolygonText(Shapes[i]) do begin
      if edText.Text <> Text then
        edText.Text := '';
    end;
end;

end.
