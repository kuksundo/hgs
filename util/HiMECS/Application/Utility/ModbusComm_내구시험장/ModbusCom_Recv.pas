unit ModbusCom_Recv;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Grids,
  AdvObj, BaseGrid, AdvGrid;

type
  TDisplayRecvF = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    AdvStringGrid1: TAdvStringGrid;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AdvStringGrid1GetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
  private
    FCurrentRowNo: integer;
  public
    procedure AddRowFromCSV(ACSV: string);
    procedure AddColFromCSV(ACSV: string);
  end;

var
  DisplayRecvF: TDisplayRecvF;

implementation

uses CommonUtil, NxColumnClasses, NxColumns;

{$R *.dfm}

procedure TDisplayRecvF.AddColFromCSV(ACSV: string);
var
  LnxTextColumn: TnxTextColumn;
  LStr: string;
  R,C: integer;
begin
{  with NextGrid1 do
  begin
    //ClearRows;
    //Columns.Count := Columns.Count + 1;
    Columns.Add(TnxIncrementColumn,'No.');

    While ACSV <> '' do
    begin
      LStr := strToken(ACSV, ',');
      LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,LStr));
      //LnxTextColumn.Name := 'LevelIndex';
      LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];
    end;//while
  end;
}
  if ACSV = '' then
    exit;

  with AdvStringGrid1 do
  begin
    R := FixedRows;
    C := 3;
    FixedRows := FixedRows + 1;
    FCurrentRowNo := FixedRows;
    LStr := strToken(ACSV, ',');
    Cells[1,R] := '(' + LStr + ')';
    Cells[2,R] := 'Func Code';
    Cells[3,R] := 'Byte Count';

    While ACSV <> '' do
    begin
      if R = 0 then
        AddColumn;

      Inc(C);
      LStr := strToken(ACSV, ',');
      Cells[C,R] := LStr;
    end;//while

  end;
end;

procedure TDisplayRecvF.AddRowFromCSV(ACSV: string);
var
  LStr: string;
  R,C: integer;
begin
{  if ACSV <> '' then
  begin
    R := NextGrid1.AddRow;
  end;

  C := 0;

  While ACSV <> '' do
  begin
    LStr := strToken(ACSV, ',');
    NextGrid1.Cells[C,R] := LStr;
    Inc(C);
  end;
}
  if ACSV <> '' then
  begin
    if FCurrentRowNo > 100 then
    begin
      AdvStringGrid1.ClearRows(AdvStringGrid1.FixedRows, AdvStringGrid1.RowCount - AdvStringGrid1.FixedRows);
      FCurrentRowNo := AdvStringGrid1.FixedRows;
    end;

    R := FCurrentRowNo;
    AdvStringGrid1.Cells[0,R] := IntToStr(R - AdvStringGrid1.FixedRows + 1);
    AdvStringGrid1.Row := R;

    C := 1;

    While ACSV <> '' do
    begin
      LStr := strToken(ACSV, ',');
      AdvStringGrid1.Cells[C,R] := LStr;
      Inc(C);
    end;

    Inc(FCurrentRowNo);
  end;
end;

procedure TDisplayRecvF.AdvStringGrid1GetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  if ARow > 0 then
    HAlign := taCenter;
end;

procedure TDisplayRecvF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //Action := caFree;
end;

end.
