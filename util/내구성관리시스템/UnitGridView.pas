unit UnitGridView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, NxScrollControl,
  NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.StdCtrls, Vcl.ExtCtrls,
  GridViewFrame, Vcl.Menus;

type
  TGridViewF = class(TForm)
    TFrame11: TFrame1;
    PopupMenu1: TPopupMenu;
    Sum1: TMenuItem;
    Average1: TMenuItem;
    N1: TMenuItem;
    SetColumn1: TMenuItem;
    Min1: TMenuItem;
    Max1: TMenuItem;
    Button1: TButton;
    procedure Average1Click(Sender: TObject);
    procedure SetColumn1Click(Sender: TObject);
    procedure Sum1Click(Sender: TObject);
    procedure Min1Click(Sender: TObject);
    procedure Max1Click(Sender: TObject);
  private
    FSelectedCol: integer;//°è»êÇÒ Ä®·³ ÀÎµ¦½º ÀúÀå
  public
    function SelectedColAvg(ACol: integer): double;
    function SelectedColSum(ACol: integer): integer;
    function SelectedColMin(ACol: integer): integer;
    function SelectedColMax(ACol: integer): integer;
  end;

var
  GridViewF: TGridViewF;

implementation

{$R *.dfm}

{ TGridViewF }

procedure TGridViewF.Average1Click(Sender: TObject);
begin
  SelectedColAvg(FSelectedCol);
end;

procedure TGridViewF.Max1Click(Sender: TObject);
begin
  SelectedColMax(FSelectedCol);
end;

procedure TGridViewF.Min1Click(Sender: TObject);
begin
  SelectedColMin(FSelectedCol);
end;

function TGridViewF.SelectedColAvg(ACol: integer): double;
var
  i: integer;
  LSum: integer;
  LCnt: integer;
begin
  LSum := 0;
  LCnt := 0;

  for i := 0 to TFrame11.NextGrid1.RowCount - 1 do
  begin
    if TFrame11.NextGrid1.Selected[i] then
    begin
//      LSum := LSum + StrToIntDef(TFrame11.NextGrid1.Cells[ACol, i],0);
      LSum := LSum + StrToInt(TFrame11.NextGrid1.Cells[ACol, i]);
      Inc(LCnt);
    end;
  end;

  if LCnt > 0 then
    Result := LSum / LCnt
  else
    Result := 0.0;

  ShowMessage('Data Count: ' + IntToStr(LCnt) + #13#10 + 'Average: ' + FloatToStr(Result));
end;

function TGridViewF.SelectedColMax(ACol: integer): integer;
var
  i: integer;
  LMax: integer;
  LCnt: integer;
begin
  LMax := 0;
  LCnt := 0;

  for i := 0 to TFrame11.NextGrid1.RowCount - 1 do
  begin
    if TFrame11.NextGrid1.Selected[i] then
    begin
      if LMax < StrToIntDef(TFrame11.NextGrid1.Cells[ACol, i],0) then
        LMax := StrToIntDef(TFrame11.NextGrid1.Cells[ACol, i],0);

      Inc(LCnt);
    end;
  end;

  if LCnt > 0 then
    Result := LMax
  else
    Result := 0;

  ShowMessage('Data Count: ' + IntToStr(LCnt) + #13#10 + 'Max: ' + IntToStr(Result));
end;

function TGridViewF.SelectedColMin(ACol: integer): integer;
var
  i: integer;
  LMin: integer;
  LCnt: integer;
  LFirst: boolean;
begin
  LMin := 0;
  LCnt := 0;
  LFirst := True;

  for i := 0 to TFrame11.NextGrid1.RowCount - 1 do
  begin
    if TFrame11.NextGrid1.Selected[i] then
    begin
      if LFirst then
      begin
        LFirst := False;
        LMin := StrToIntDef(TFrame11.NextGrid1.Cells[ACol, i],0);
      end;

      if LMin > StrToIntDef(TFrame11.NextGrid1.Cells[ACol, i],0) then
        LMin := StrToIntDef(TFrame11.NextGrid1.Cells[ACol, i],0);

      Inc(LCnt);
    end;
  end;

  if LCnt > 0 then
    Result := LMin
  else
    Result := 0;

  ShowMessage('Data Count: ' + IntToStr(LCnt) + #13#10 + 'Min: ' + IntToStr(Result));
end;

function TGridViewF.SelectedColSum(ACol: integer): integer;
var
  i: integer;
  LSum: integer;
  LCnt: integer;
begin
  LSum := 0;
  LCnt := 0;

  for i := 0 to TFrame11.NextGrid1.RowCount - 1 do
  begin
    if TFrame11.NextGrid1.Selected[i] then
    begin
      LSum := LSum + StrToIntDef(TFrame11.NextGrid1.Cells[ACol, i],0);
      Inc(LCnt);
    end;
  end;

  if LCnt > 0 then
    Result := LSum
  else
    Result := 0;

  ShowMessage('Data Count: ' + IntToStr(LCnt) + #13#10 + 'Sum: ' + IntToStr(Result));
end;

procedure TGridViewF.SetColumn1Click(Sender: TObject);
begin
  FSelectedCol := TFrame11.NextGrid1.SelectedColumn;
end;

procedure TGridViewF.Sum1Click(Sender: TObject);
begin
  SelectedColSum(FSelectedCol);
end;

end.
