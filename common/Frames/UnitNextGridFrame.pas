unit UnitNextGridFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, NxEdit,
  Vcl.ComCtrls, Vcl.ToolWin, Vcl.ImgList, NxColumns, NxColumnClasses,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.ExtCtrls;

type
  TFrame1 = class(TFrame)
    Panel4: TPanel;
    NextGrid1: TNextGrid;
    Itemname: TNxTextColumn;
    Value: TNxTextColumn;
    ImageList1: TImageList;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    btnLeftAlignment: TToolButton;
    btnCenterAlignment: TToolButton;
    btnRightAlignment: TToolButton;
    ToolButton6: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton7: TToolButton;
    btnAddRow: TToolButton;
    btnAddCol: TToolButton;
    ToolButton10: TToolButton;
    ToolButton13: TToolButton;
    ToolButton12: TToolButton;
    ToolButton14: TToolButton;
    ToolButton16: TToolButton;
    ToolButton15: TToolButton;
    ToolButton8: TToolButton;
    ToolButton17: TToolButton;
    ToolButton20: TToolButton;
    ToolButton18: TToolButton;
    ToolButton19: TToolButton;
    ToolButton9: TToolButton;
    ToolButton21: TToolButton;
    ToolButton22: TToolButton;
    ToolButton1: TToolButton;
    btnBold: TToolButton;
    btnItalic: TToolButton;
    btnUnderline: TToolButton;
    ToolButton2: TToolButton;
    ColorPickerEditor1: TNxColorPicker;
    ToolButton11: TToolButton;
    NxIncrementColumn1: TNxIncrementColumn;
    procedure btnLeftAlignmentClick(Sender: TObject);
    procedure btnCenterAlignmentClick(Sender: TObject);
    procedure btnRightAlignmentClick(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
    procedure btnAddRowClick(Sender: TObject);
    procedure ToolButton13Click(Sender: TObject);
    procedure ToolButton14Click(Sender: TObject);
    procedure ToolButton16Click(Sender: TObject);
    procedure ToolButton8Click(Sender: TObject);
    procedure ToolButton17Click(Sender: TObject);
    procedure ToolButton18Click(Sender: TObject);
    procedure ToolButton19Click(Sender: TObject);
    procedure btnBoldClick(Sender: TObject);
    procedure btnItalicClick(Sender: TObject);
    procedure btnUnderlineClick(Sender: TObject);
    procedure ColorPickerEditor1Change(Sender: TObject);
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure InitVar;
    procedure DestroyVar;
  end;

implementation

{$R *.dfm}

procedure TFrame1.btnAddRowClick(Sender: TObject);
begin
  NextGrid1.AddRow;
  NextGrid1.SelectLastRow;
end;

procedure TFrame1.btnBoldClick(Sender: TObject);
begin
  with NextGrid1 do
    if CellBounds(SelectedColumn, SelectedRow) then
      if TToolButton(Sender).Down
        then Cell[SelectedColumn, SelectedRow].FontStyle := Cell[SelectedColumn, SelectedRow].FontStyle + [fsBold]
        else Cell[SelectedColumn, SelectedRow].FontStyle := Cell[SelectedColumn, SelectedRow].FontStyle - [fsBold];
end;

procedure TFrame1.btnCenterAlignmentClick(Sender: TObject);
begin
  NextGrid1.Columns[NextGrid1.SelectedColumn].Alignment := taCenter;
end;

procedure TFrame1.btnItalicClick(Sender: TObject);
begin
  with NextGrid1 do
    if CellBounds(SelectedColumn, SelectedRow) then
      if TToolButton(Sender).Down
        then Cell[SelectedColumn, SelectedRow].FontStyle := Cell[SelectedColumn, SelectedRow].FontStyle + [fsItalic]
        else Cell[SelectedColumn, SelectedRow].FontStyle := Cell[SelectedColumn, SelectedRow].FontStyle - [fsItalic];
end;

procedure TFrame1.btnLeftAlignmentClick(Sender: TObject);
begin
  NextGrid1.Columns[NextGrid1.SelectedColumn].Alignment := taLeftJustify;
end;

procedure TFrame1.btnRightAlignmentClick(Sender: TObject);
begin
  NextGrid1.Columns[NextGrid1.SelectedColumn].Alignment := taRightJustify;
end;

procedure TFrame1.btnUnderlineClick(Sender: TObject);
begin
  with NextGrid1 do
    if CellBounds(SelectedColumn, SelectedRow) then
      if TToolButton(Sender).Down
        then Cell[SelectedColumn, SelectedRow].FontStyle := Cell[SelectedColumn, SelectedRow].FontStyle + [fsUnderline]
        else Cell[SelectedColumn, SelectedRow].FontStyle := Cell[SelectedColumn, SelectedRow].FontStyle - [fsUnderline];
end;

procedure TFrame1.ColorPickerEditor1Change(Sender: TObject);
begin
  with NextGrid1 do
    if CellBounds(SelectedColumn, SelectedRow) then
    begin
      if ColorPickerEditor1.SelectedColor = clNone
        then Cell[SelectedColumn, SelectedRow].Color := Color
        else Cell[SelectedColumn, SelectedRow].Color := ColorPickerEditor1.SelectedColor;
    end;
end;

constructor TFrame1.Create(AOwner: TComponent);
begin
  inherited;

  InitVar;
end;

destructor TFrame1.Destroy;
begin
  DestroyVar;

  inherited;
end;

procedure TFrame1.DestroyVar;
begin

end;

procedure TFrame1.InitVar;
begin
  NextGrid1.DoubleBuffered := False;
end;

procedure TFrame1.ToolButton13Click(Sender: TObject);
var
  Li: integer;
  LRow: integer;
begin
  LRow := NextGrid1.AddRow;

  for Li := 0 to 8 do
    NextGrid1.Cells[Li, LRow] := NextGrid1.Cells[Li, NextGrid1.SelectedRow];

  NextGrid1.SelectLastRow;
end;

procedure TFrame1.ToolButton14Click(Sender: TObject);
begin
  NextGrid1.DeleteRow(NextGrid1.SelectedRow);
end;

procedure TFrame1.ToolButton16Click(Sender: TObject);
begin
  NextGrid1.Columns.Delete(NextGrid1.SelectedColumn);
end;

procedure TFrame1.ToolButton17Click(Sender: TObject);
begin
  NextGrid1.MoveRow(NextGrid1.SelectedRow, NextGrid1.SelectedRow + 1);
  NextGrid1.SelectedRow := NextGrid1.SelectedRow + 1;
end;

procedure TFrame1.ToolButton18Click(Sender: TObject);
var
  o, n: Integer;
begin
  o := NextGrid1.Columns[NextGrid1.SelectedColumn].Position;
  if o = 0 then Exit;
  n := o - 1;
  NextGrid1.Columns.ChangePosition(o, n);
end;

procedure TFrame1.ToolButton19Click(Sender: TObject);
var
  o, n: Integer;
begin
  o := NextGrid1.Columns[NextGrid1.SelectedColumn].Position;
  n := o + 1;
  NextGrid1.Columns.ChangePosition(o, n);
end;

procedure TFrame1.ToolButton3Click(Sender: TObject);
begin
  NextGrid1.Columns[NextGrid1.SelectedColumn].VerticalAlignment := taAlignTop;
end;

procedure TFrame1.ToolButton4Click(Sender: TObject);
begin
  NextGrid1.Columns[NextGrid1.SelectedColumn].VerticalAlignment := taVerticalCenter;
end;

procedure TFrame1.ToolButton5Click(Sender: TObject);
begin
  NextGrid1.Columns[NextGrid1.SelectedColumn].VerticalAlignment := taAlignBottom;
end;

procedure TFrame1.ToolButton8Click(Sender: TObject);
var
  i: integer;
begin
  if NextGrid1.SelectedCount > 0 then
  begin
    if NextGrid1.SelectedCount = 1 then
    begin
      NextGrid1.MoveRow(NextGrid1.SelectedRow, NextGrid1.SelectedRow - 1);
      NextGrid1.SelectedRow := NextGrid1.SelectedRow - 1;
    end
    else
    begin
      for i := 1 to NextGrid1.RowCount - 1 do
      begin
        if NextGrid1.Selected[i] then
        begin
          NextGrid1.MoveRow(i, i - 1);
          NextGrid1.Selected[i] := False;
          NextGrid1.Selected[i-1] := True;
        end;
      end;

    end;
  end;
end;

end.
