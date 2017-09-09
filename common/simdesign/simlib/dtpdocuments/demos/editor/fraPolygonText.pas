unit fraPolygonText;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fraTextBaseShape, StdCtrls, ComCtrls, ExtCtrls, ColorPickerButton,
  dtpPolygonText, NativeXml;

type
  TfrPolygonText = class(TfrTextBaseShape)
    Label11: TLabel;
    edText: TEdit;
    procedure edTextExit(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure ShapesToFrame; override;
  public
    { Public declarations }
  end;

var
  frPolygonText: TfrPolygonText;

implementation

{$R *.DFM}

{ TfrPolygonText }

procedure TfrPolygonText.edTextExit(Sender: TObject);
var
  i: integer;
begin
  BeginUpdate;
  if not FIsUpdating then
    for i := 0 to ShapeCount - 1 do
      if (Shapes[i] is TdtpPolygonText) then
        TdtpPolygonText(Shapes[i]).Text := sdUtf8ToWide(UTF8String(edText.Text));
  EndUpdate;
end;

procedure TfrPolygonText.ShapesToFrame;
var
  i: integer;
begin
  inherited;
  if ShapeCount = 0 then exit;
  // Title
  if ShapeCount = 1 then
    lblTitle.Caption := 'Polygon Text'
  else
    lblTitle.Caption := Format('Polygon Texts (%d items)', [ShapeCount]);
  // Main shape
  if Shapes[0] is TdtpPolygonText then
    with TdtpPolygonText(Shapes[0]) do
    begin
      // Text
      edText.Text := Text;
    end;
  // Additional shapes
  for i := 1 to ShapeCount - 1 do
    if Shapes[i] is TdtpPolygonText then
      with TdtpPolygonText(Shapes[i]) do
      begin
        if edText.Text <> Text then
          edText.Text := '';
      end;
end;

end.
