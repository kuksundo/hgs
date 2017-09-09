unit fraTextShape;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fraTextBaseShape, StdCtrls, ComCtrls, ExtCtrls, ColorPickerButton,
  dtpTextShape, NativeXml;

type
  TfrTextShape = class(TfrTextBaseShape)
    edText: TEdit;
    Label11: TLabel;
    lbAlignment: TLabel;
    cbbAlignment: TComboBox;
    chbAutoSize: TCheckBox;
    procedure edTextExit(Sender: TObject);
    procedure cbbAlignmentChange(Sender: TObject);
    procedure chbAutoSizeClick(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure ShapesToFrame; override;
  public
    { Public declarations }
  end;

var
  frTextShape: TfrTextShape;

implementation

{$R *.DFM}

procedure TfrTextShape.cbbAlignmentChange(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    if (Shapes[i] is TdtpTextShape) then
      TdtpTextShape(Shapes[i]).Alignment := TAlignment(cbbAlignment.ItemIndex);
  EndUpdate;
end;

procedure TfrTextShape.chbAutoSizeClick(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    if (Shapes[i] is TdtpTextShape) then
      TdtpTextShape(Shapes[i]).AutoSize := chbAutoSize.Checked;
  EndUpdate;
end;

procedure TfrTextShape.edTextExit(Sender: TObject);
var
  i: integer;
begin
  BeginUpdate;
  if not FIsUpdating then
    for i := 0 to ShapeCount - 1 do
      if (Shapes[i] is TdtpTextShape) then
        TdtpTextShape(Shapes[i]).Text := sdUtf8ToWide(UTF8String(edText.Text));
  EndUpdate;
end;

procedure TfrTextShape.ShapesToFrame;
var
  i: integer;
begin
  inherited;
  if ShapeCount = 0 then exit;
  // Title
  if ShapeCount = 1 then
    lblTitle.Caption := 'Text shape'
  else
    lblTitle.Caption := Format('Text shapes (%d items)', [ShapeCount]);
  // Main shape
  if Shapes[0] is TdtpTextShape then
    with TdtpTextShape(Shapes[0]) do
    begin
      // Text, VCL does not support widestring so we set text to UTF8
      // NH: obsoleted D2010, what should we do in D7?
      edText.Text := Text;
      // Alignment and autosize
      cbbAlignment.ItemIndex := integer(Alignment);
      chbAutoSize.Checked := AutoSize;
    end;
  // Additional shapes
  for i := 1 to ShapeCount - 1 do
    if Shapes[i] is TdtpTextShape then
      with TdtpTextShape(Shapes[i]) do
      begin
        if edText.Text <> Text then
          edText.Text := '';
      end;
end;

end.
