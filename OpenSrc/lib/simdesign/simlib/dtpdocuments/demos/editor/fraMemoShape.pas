unit fraMemoShape;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fraTextBaseShape, StdCtrls, ComCtrls, ExtCtrls, ColorPickerButton,
  dtpMemoShape;

type
  TfrMemoShape = class(TfrTextBaseShape)
    chbWordWrap: TCheckBox;
    reText: TRichEdit;
    Label11: TLabel;
    lbAlignment: TLabel;
    cbbAlignment: TComboBox;
    chbAutoSize: TCheckBox;
    procedure reTextExit(Sender: TObject);
    procedure chbWordWrapClick(Sender: TObject);
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
  frMemoShape: TfrMemoShape;

implementation

{$R *.DFM}

{ TfrMemoShape }

procedure TfrMemoShape.cbbAlignmentChange(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    if (Shapes[i] is TdtpMemoShape) then
      TdtpMemoShape(Shapes[i]).Alignment := TAlignment(cbbAlignment.ItemIndex);
  EndUpdate;
end;

procedure TfrMemoShape.chbAutoSizeClick(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    if (Shapes[i] is TdtpMemoShape) then
      TdtpMemoShape(Shapes[i]).AutoSize := chbAutoSize.Checked;
  EndUpdate;
end;

procedure TfrMemoShape.ShapesToFrame;
var
  i: integer;
begin
  inherited;
  if ShapeCount = 0 then exit;
  // Title
  if ShapeCount = 1 then
    lblTitle.Caption := 'Memo shape'
  else
    lblTitle.Caption := Format('Memo shapes (%d items)', [ShapeCount]);
  // Main shape
  if Shapes[0] is TdtpMemoShape then with TdtpMemoShape(Shapes[0]) do begin
    // Text
    reText.Lines.Text := Text;
    // Wordwrap
    chbWordWrap.Checked := WordWrap;
    // Alignment and autosize
    cbbAlignment.ItemIndex := integer(Alignment);
    chbAutoSize.Checked := AutoSize;
  end;
  // Additional shapes
  for i := 1 to ShapeCount - 1 do
    if Shapes[i] is TdtpMemoShape then with TdtpMemoShape(Shapes[i]) do begin
      if reText.Text <> Text then
        reText.Text := '';
    end;
end;

procedure TfrMemoShape.reTextExit(Sender: TObject);
var
  i: integer;
begin
  BeginUpdate;
  if not FIsUpdating then for i := 0 to ShapeCount - 1 do
    if (Shapes[i] is TdtpMemoShape) then
      TdtpMemoShape(Shapes[i]).Lines.Assign({Text := }reText.Lines{.Text});
  EndUpdate;
end;

procedure TfrMemoShape.chbWordWrapClick(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    if (Shapes[i] is TdtpMemoShape) then
      TdtpMemoShape(Shapes[i]).WordWrap := chbWordWrap.Checked;
  EndUpdate;
end;

end.
