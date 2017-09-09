unit LocalData_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxColumnClasses, NxColumns,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, NxEdit,
  Vcl.StdCtrls, Vcl.ComCtrls, AdvGlowButton, CurvyControls, AdvPanel,
  Vcl.ExtCtrls, NxCollection;

type
  TLocalData_Frm = class(TForm)
    NxHeaderPanel1: TNxHeaderPanel;
    Panel5: TPanel;
    AdvPanel1: TAdvPanel;
    CurvyPanel1: TCurvyPanel;
    CurvyPanel2: TCurvyPanel;
    Panel1: TPanel;
    Panel2: TPanel;
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
    Localgrid: TNextGrid;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn4: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    NxTextColumn6: TNxTextColumn;
    NxTextColumn7: TNxTextColumn;
    indates: TEdit;
    procedure AdvGlowButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DateTimePicker1Change(Sender: TObject);
    procedure LocalgridDblClick(Sender: TObject);
    procedure LocalgridSelectCell(Sender: TObject; ACol, ARow: Integer);
  private
    { Private declarations }
  public

    { Public declarations }
  end;

var
  LocalData_Frm: TLocalData_Frm;

implementation
uses
Value_Unit,
DataModule_Unit;

{$R *.dfm}

procedure TLocalData_Frm.AdvGlowButton1Click(Sender: TObject);
var
  li : integer;
  TABLE_NAME, COLUMN_NAME, COLUMN : String;
  COLUMN_LIST : TStringList;
  OCCUR_TIME : String;

begin
  TABLE_NAME := 'HEMMS_E1_PLC';
  COLUMN_NAME := 'ADDR';

  OCCUR_TIME := '20130319235927550';

  with DM1.OraQuery3 do
  begin
    Close;
    Sql.Clear;
    //sql.Add('select * from ALL_COL_COMMENTS WHERE TABLE_NAME = '''+TABLE_NAME+''' ');
    //Sql.Add(' AND COLUMN_NAME like ''%'+COLUMN_NAME+'%'' order by COLUMN_NAME ');
    Sql.Add('select * from HEMMS_E1_PLC WHERE OCCUR_TIME = '''+OCCUR_TIME+''' ');
    Open;

    for li := 0 to recordCount-1 do
    begin
      with Localgrid do
      begin


      end;
    end;
  end;
end;

procedure TLocalData_Frm.DateTimePicker1Change(Sender: TObject);
var
  Indate : String;
  li : integer;
begin
  Indate := DateToStr(DateTimePicker1.Date);

  with DM1.OraQuery3 do
  begin
    Close;
    Sql.Clear;
    sql.Add('select INDATE, ENGINE_CODE, ENGINE_TYPE, TEST_NAME, TEST_LOAD, EVALUATOR ');
    sql.Add(' , RUNNING_HOUR From HEMMS_LDS WHERE TO_CHAR(INDATE, ''YYYY-MM-DD'') = '''+Indate+''' ');
    Open;

    if not(RecordCount = 0) then
    begin
      with Localgrid do
      begin
        BeginUpdate;
        try
          ClearRows;
          for li := 0 to RecordCount-1 do
          begin
            AddRow();
            Cells[0, li] := FieldByName('INDATE').AsString;
            Cells[1, li] := FieldByName('ENGINE_CODE').AsString;
            Cells[2, li] := FieldByName('ENGINE_TYPE').AsString;
            Cells[3, li] := FieldByName('TEST_NAME').AsString;
            Cells[4, li] := FieldByName('TEST_LOAD').AsString;
            Cells[5, li] := FieldByName('EVALUATOR').AsString;
            Cells[6, li] := FieldByName('RUNNING_HOUR').AsString;

            Next;
          end;
        finally
          EndUpdate;
        end;
      end;
    end;
  end;
end;

procedure TLocalData_Frm.FormCreate(Sender: TObject);
var
  Indate : String;
  li : integer;
begin
  DateTimePicker1.Date := now;

  Indate := DateToStr(DateTimePicker1.Date);

  with DM1.OraQuery3 do
  begin
    Close;
    Sql.Clear;
    sql.Add('select INDATE, ENGINE_CODE, ENGINE_TYPE, TEST_NAME, TEST_LOAD, EVALUATOR ');
    sql.Add(' , RUNNING_HOUR From HEMMS_LDS WHERE TO_CHAR(INDATE, ''YYYY-MM-DD'') = '''+Indate+''' ');
    Open;

    if not(RecordCount = 0) then
    begin
      with Localgrid do
      begin
        BeginUpdate;
        try
          ClearRows;
          for li := 0 to RecordCount-1 do
          begin
            AddRow();
            Cells[0, li] := FieldByName('INDATE').AsString;
            Cells[1, li] := FieldByName('ENGINE_CODE').AsString;
            Cells[2, li] := FieldByName('ENGINE_TYPE').AsString;
            Cells[3, li] := FieldByName('TEST_NAME').AsString;
            Cells[4, li] := FieldByName('TEST_LOAD').AsString;
            Cells[5, li] := FieldByName('EVALUATOR').AsString;
            Cells[6, li] := FieldByName('RUNNING_HOUR').AsString;

            Next;
          end;
        finally
          EndUpdate;
        end;
      end;
    end;
  end;
end;

procedure TLocalData_Frm.LocalgridDblClick(Sender: TObject);
var
  LForm : TValue_Frm;

begin
  try
    LForm := TValue_Frm.Create(self);

    with LForm do
    begin
      indate.text := indates.Text;
      FOwner := Self;
      ShowModal;
    end;
    finally
      FreeAndNil(LForm);
    end;


end;

procedure TLocalData_Frm.LocalgridSelectCell(Sender: TObject; ACol,
  ARow: Integer);
var
  indate : String;
begin
  indate := localgrid.Cells[0, AROW];
  indates.Text := indate;
end;

end.
