unit Problem_Unit;

interface

uses
  Main_Unit, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxColumnClasses, NxColumns,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.StdCtrls,
  CurvyControls, AdvGlowButton, Vcl.ExtCtrls, NxCollection, Vcl.ImgList, NxEdit,
  Vcl.ComCtrls, AdvPanel;

type
  TProblem_Frm = class(TForm)
    NxHeaderPanel1: TNxHeaderPanel;
    Panel5: TPanel;
    AdvPanel1: TAdvPanel;
    CurvyPanel1: TCurvyPanel;
    CurvyPanel2: TCurvyPanel;
    Panel12: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    DateTimePicker1: TDateTimePicker;
    date: TEdit;
    Panel32: TPanel;
    AdvGlowButton5: TAdvGlowButton;
    nowhave: TNxNumberEdit;
    Panel6: TPanel;
    Panel7: TPanel;
    CurvyPanel4: TCurvyPanel;
    Panel36: TPanel;
    value: TEdit;
    Panel35: TPanel;
    Problemgrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn7: TNxTextColumn;
    NxTextColumn9: TNxTextColumn;
    NxTextColumn10: TNxTextColumn;
    NxTextColumn12: TNxTextColumn;
    NxTextColumn13: TNxTextColumn;
    NxTextColumn14: TNxTextColumn;
    ImageList1: TImageList;
    imagelist24x24: TImageList;
    ImageList16x16: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure DateTimePicker1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Problem_Frm: TProblem_Frm;

implementation
uses
DataModule_Unit;

{$R *.dfm}

procedure TProblem_Frm.DateTimePicker1Change(Sender: TObject);
var
  li : integer;
  indate : string;
begin
  indate := DateToStr(DateTimePicker1.Date);

  with DM1.OraQuery3 do
  begin
    CLOSE;
    SQL.Clear;
    SQL.Add('select * from TROUBLE_MOBILE WHERE TO_CHAR(INDATE, ''YYYY-MM-DD'') = '''+indate+''' ');
    Open;

    if not(RecordCount = 0) then
    begin
      with Problemgrid do
      begin
        BeginUpdate;
        try
          ClearRows;
          for li := 0 to RecordCount-1 do
          begin
            ProblemGrid.AddRow();
            Cells[0,li] := IntToStr(li +1);
            Cells[1,li] := FieldByName('STATUS').AsString;
            Cells[2,li] := FieldByName('ITEMNAME').AsString;
            Cells[3,li] := FieldByName('REASON').AsString;
            Cells[4,li] := FieldByName('ENGTYPE').AsString;
            Cells[5,li] := FieldByName('INFORMER').AsString;
            Cells[6,li] := FieldByName('INDATE').AsString;

            Next;
          end;

        finally
          EndUpdate;
        end;
      end;
    end;
  end;
  value.Text := IntToStr(Problemgrid.RowCount);
end;

procedure TProblem_Frm.FormCreate(Sender: TObject);
var
  li : integer;
  indate : string;
begin
  DateTimePicker1.Date := now;
  indate := DateToStr(DateTimePicker1.Date);

  with DM1.OraQuery3 do
  begin
    CLOSE;
    SQL.Clear;
    SQL.Add('select * from TROUBLE_MOBILE WHERE TO_CHAR(INDATE, ''YYYY-MM-DD'') = '''+indate+''' ');
    Open;

    if not(RecordCount = 0) then
    begin
      with Problemgrid do
      begin
        BeginUpdate;
        try
          ClearRows;
          for li := 0 to RecordCount-1 do
          begin
            ProblemGrid.AddRow();
            Cells[0,li] := IntToStr(li +1);
            Cells[1,li] := FieldByName('STATUS').AsString;
            Cells[2,li] := FieldByName('ITEMNAME').AsString;
            Cells[3,li] := FieldByName('REASON').AsString;
            Cells[4,li] := FieldByName('ENGTYPE').AsString;
            Cells[5,li] := FieldByName('INFORMER').AsString;
            Cells[6,li] := FieldByName('INDATE').AsString;

            Next;
          end;

        finally
          EndUpdate;
        end;
      end;
    end;
  end;

  value.Text := IntToStr(Problemgrid.RowCount);
end;

end.
