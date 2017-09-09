unit fraPolygonMemoShape;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fraTextBaseShape, StdCtrls, ComCtrls, ExtCtrls, ColorPickerButton,
  dtpMemoShape,dtpPolygonText;

type
  TfrPolygonMemoShape = class(TfrTextBaseShape)
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
  frMemoShape: TfrPolygonMemoShape;

implementation

{$R *.DFM}

{ TfrPolygonMemoShape }

procedure TfrPolygonMemoShape.cbbAlignmentChange(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    if (Shapes[i] is TdtpPolygonMemo) then
      TdtpPolygonMemo(Shapes[i]).Alignment := TAlignment(cbbAlignment.ItemIndex);
  EndUpdate;
end;

procedure TfrPolygonMemoShape.chbAutoSizeClick(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    if (Shapes[i] is TdtpPolygonMemo) then
      TdtpPolygonMemo(Shapes[i]).AutoSize := chbAutoSize.Checked;
  EndUpdate;
end;

procedure TfrPolygonMemoShape.ShapesToFrame;
var
  i: integer;
begin
  inherited;
  if ShapeCount = 0 then exit;
  // Title
  if ShapeCount = 1 then
    lblTitle.Caption := 'Polygon Memo shape'
  else
    lblTitle.Caption := Format('Memo shapes (%d items)', [ShapeCount]);
  // Main shape
  if Shapes[0] is TdtpPolygonMemo then with TdtpPolygonMemo(Shapes[0]) do begin
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
    if Shapes[i] is TdtpPolygonMemo then with TdtpPolygonMemo(Shapes[i]) do begin
      if reText.Text <> Text then
        reText.Text := '';
    end;
end;

procedure TfrPolygonMemoShape.reTextExit(Sender: TObject);
var
  i: integer;
begin
  BeginUpdate;
  if not FIsUpdating then for i := 0 to ShapeCount - 1 do
    if (Shapes[i] is TdtpPolygonMemo) then
      TdtpPolygonMemo(Shapes[i]).Text := reText.Text;
  EndUpdate;
end;

procedure TfrPolygonMemoShape.chbWordWrapClick(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    if (Shapes[i] is TdtpPolygonMemo) then
      TdtpPolygonMemo(Shapes[i]).WordWrap := chbWordWrap.Checked;
  EndUpdate;
end;

end.
