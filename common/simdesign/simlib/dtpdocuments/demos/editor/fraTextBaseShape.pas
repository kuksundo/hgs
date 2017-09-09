unit fraTextBaseShape;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fraShape, ExtCtrls, StdCtrls, ComCtrls, dtpShape, dtpTextShape, dtpUtil,
  dtpDefaults, ColorPickerButton;

type
  TfrTextBaseShape = class(TfrShape)
    cbbFontName: TComboBox;
    Label8: TLabel;
    cpbFontColor: TColorPickerButton;
    Label9: TLabel;
    edFontHeight: TEdit;
    Label10: TLabel;
    chbBold: TCheckBox;
    chbItalic: TCheckBox;
    chbUnderline: TCheckBox;
    chbStrikeout: TCheckBox;
    Label7: TLabel;
    edFontHeightPts: TEdit;
    Label12: TLabel;
    procedure cbbFontNameDropDown(Sender: TObject);
    procedure cbbFontNameChange(Sender: TObject);
    procedure cpbFontColorChange(Sender: TObject);
    procedure edFontHeightExit(Sender: TObject);
    procedure chbBoldClick(Sender: TObject);
    procedure chbItalicClick(Sender: TObject);
    procedure chbUnderlineClick(Sender: TObject);
    procedure chbStrikeoutClick(Sender: TObject);
    procedure edFontHeightPtsExit(Sender: TObject);
  private
    FFontList: TStringList;
    procedure AddFontStyle(AStyle: TFontStyle; Checked: boolean);
  protected
    procedure CreateFontList;
    procedure ShapesToFrame; override;
  public
    destructor Destroy; override;
  end;

var
  frTextBaseShape: TfrTextBaseShape;

implementation

{$R *.DFM}

{ TfrTextShape }

procedure TfrTextBaseShape.AddFontStyle(AStyle: TFontStyle; Checked: boolean);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  for i := 0 to ShapeCount- 1 do
    if (Shapes[i] is TdtpTextBaseShape) then
      with TdtpTextBaseShape(Shapes[i]) do
        if Checked then
          FontStyle := FontStyle + [AStyle]
        else
          FontStyle := FontStyle - [AStyle];
  EndUpdate;
end;

procedure TfrTextBaseShape.cbbFontNameChange(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    if (Shapes[i] is TdtpTextBaseShape) then
      TdtpTextBaseShape(Shapes[i]).FontName := cbbFontName.Text;
  EndUpdate;
end;

procedure TfrTextBaseShape.cbbFontNameDropDown(Sender: TObject);
begin
  inherited;
  // We must get the list of font names
  CreateFontList;
  cbbFontName.Items.Assign(FFontList);
end;

procedure TfrTextBaseShape.chbBoldClick(Sender: TObject);
begin
  AddFontStyle(fsBold, chbBold.Checked);
end;

procedure TfrTextBaseShape.chbItalicClick(Sender: TObject);
begin
  AddFontStyle(fsItalic, chbItalic.Checked);
end;

procedure TfrTextBaseShape.chbStrikeoutClick(Sender: TObject);
begin
  AddFontStyle(fsStrikeout, chbStrikeout.Checked);
end;

procedure TfrTextBaseShape.chbUnderlineClick(Sender: TObject);
begin
  AddFontStyle(fsUnderline, chbUnderline.Checked);
end;

procedure TfrTextBaseShape.CreateFontList;
begin
  if not assigned(FFontList) then
    FFontList := TStringList.Create;
  FontnamesList(FFontList);
end;

procedure TfrTextBaseShape.cpbFontColorChange(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    if (Shapes[i] is TdtpTextBaseShape) then
      TdtpTextBaseShape(Shapes[i]).FontColor := cpbFontColor.SelectionColor;
  EndUpdate;
end;

destructor TfrTextBaseShape.Destroy;
begin
  FreeAndNil(FFontList);
  inherited;
end;

procedure TfrTextBaseShape.edFontHeightExit(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    if (Shapes[i] is TdtpTextBaseShape) then
      TdtpTextBaseShape(Shapes[i]).FontHeight := StrToFloat(edFontHeight.Text);
  EndUpdate;
end;

procedure TfrTextBaseShape.edFontHeightPtsExit(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    if (Shapes[i] is TdtpTextBaseShape) then
      TdtpTextBaseShape(Shapes[i]).FontHeightPts := StrToFloat(edFontHeightPts.Text);
  EndUpdate;
end;

procedure TfrTextBaseShape.ShapesToFrame;
var
  i: integer;
begin
  inherited;
  if ShapeCount = 0 then exit;
  // Main shape
  if Shapes[0] is TdtpTextBaseShape then with TdtpTextBaseShape(Shapes[0]) do begin

    // Font
    cbbFontName.Text := FontName;
    cpbFontColor.SelectionColor := FontColor;
    edFontHeight.Text    := Format(cTextMMFormat,  [FontHeight]);
    edFontHeightPts.Text := Format(cTextPtsFormat, [FontHeightPts]);
    chbBold.Checked      := fsBold      in FontStyle;
    chbItalic.Checked    := fsItalic    in FontStyle;
    chbUnderline.Checked := fsUnderline in FontStyle;
    chbStrikeout.Checked := fsStrikeout in FontStyle;

  end;
  // Additional shapes
  for i := 1 to ShapeCount - 1 do
    if Shapes[i] is TdtpTextBaseShape then with TdtpTextBaseShape(Shapes[i]) do begin
      if cbbFontName.Text <> FontName then
        cbbFontName.Text := '';
      if edFontHeight.Text <> Format(cTextMMFormat, [FontHeight]) then
        edFontHeight.Text := '';
    end;
end;

end.
