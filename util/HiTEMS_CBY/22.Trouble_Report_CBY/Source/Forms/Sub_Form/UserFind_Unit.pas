unit UserFind_Unit;

interface

uses
  Trouble_Unit, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Forms, Dialogs, Buttons, StdCtrls, Grids, BaseGrid, AdvGrid, ExtCtrls,
  AdvObj, NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, NxCollection, NxEdit, StrUtils;

type
  TUserFind_Frm = class(TForm)
    NxHeaderPanel1: TNxHeaderPanel;
    NextGrid1: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    person: TEdit;
    Label1: TLabel;
    Label17: TLabel;
    NxTextColumn4: TNxTextColumn;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    NxComboBox1: TNxComboBox;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure NextGrid1DblClick(Sender: TObject);
    procedure NextGrid1SelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure NxComboBox1ButtonDown(Sender: TObject);
    procedure NxComboBox1Select(Sender: TObject);
  private
    { Private declarations }
    FxRow, FxCol : Integer;
  public
    FOwner : TTrouble_Frm;
//    FSubForm : TCharge_Frm;
    UserKind : integer; // 0 : novalue 1 : EMPNO 2 : INEMPNO 3 : HIEMPNO 4 : HIINEMPNO 5 : Apply Charge 6 : Change Design Charge
    procedure User_Infomation_Load(aDeptName:String);
  end;

var
  UserFind_Frm: TUserFind_Frm;

implementation
uses
  Datamodule_Unit;

{$R *.dfm}

procedure TUserFind_Frm.User_Infomation_Load(aDeptName:String);
var
  li : integer;
  lDeptNo : String;
begin
  with nextGrid1 do
  begin
    BeginUpdate;
    try
      ClearRows;
      with DM1.OraQuery2 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from HiTEMS_DEPTNO ' +
                'where DEPTNAME = '''+aDeptName+''' ');
        Open;

        if RecordCount <> 0 then
        begin
          lDeptNo := FieldByName('DEPTNO').AsString;
          Close;
          SQL.Clear;
          SQL.Add('select * from HiTEMS_EMPLOYEE_V ' +
                  'where GUNMU = ''I'' '+
                  'and DEPTNO = '''+lDeptNo+''' ' +
                  'order by Priv Desc, POSITION, CLASS_, USERID ');
          Open;

          while not eof do
          begin
            li := addRow;
            Cells[1,li] := FieldByName('USERID').AsString;
            Cells[2,li] := FieldByName('Name_KOR').AsString;
            Cells[3,li] := FieldByName('DESCR').AsString;
            Next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;

//  with FOwner do
//  begin
//    Self.NextGrid1.ClearRows;
//    with DM1.EQuery1 do
//    begin
//      Close;
//      SQL.Clear;
//      SQL.Add('select * from USERS A, GENCODES B where A.GUNMU = ''I''');
//      SQL.Add('and (Dept = ''K2B0'' or Dept = ''K2D0'' or Dept = ''K210''');
//      SQL.Add('or Dept = ''K240'' or Dept = ''K190'') and A.CLASS = B.CODE2');
//      SQL.Add('order by Dept, Class, Name');
//      Open;
//
//      for li := 0 to RecordCount -1 do
//      begin
//        Self.NextGrid1.AddRow(1);
//
//        Self.NextGrid1.Cells[1,li] := FieldByName('Sabun').AsString;
//        Self.NextGrid1.Cells[2,li] := FieldByName('Name').AsString;
//        Self.NextGrid1.Cells[3,li] := FieldByName('DESCR').AsString;
//
//        if FieldByName('Dept').AsString = 'K2D0' THEN
//          Self.NextGrid1.Cells[4,li] := '엔진기술개발부';
//        if FieldByName('Dept').AsString = 'K2B0' THEN
//          Self.NextGrid1.Cells[4,li] := '엔진개발시험부';
//        if FieldByName('Dept').AsString = 'K210' THEN
//          Self.NextGrid1.Cells[4,li] := '대형엔진설계부';
//        if FieldByName('Dept').AsString = 'K240' THEN
//          Self.NextGrid1.Cells[4,li] := '중형엔진설계부';
//        if FieldByName('Dept').AsString = 'K190' THEN
//          Self.NextGrid1.Cells[4,li] := '엔진고객지원부';
//        NEXT;
//      end;//for
//    end;//with
//  end;//with
end;

procedure TUserFind_Frm.FormActivate(Sender: TObject);
begin
  User_Infomation_Load(NxComboBox1.Text);
end;
procedure TUserFind_Frm.FormCreate(Sender: TObject);
begin
  FxCol := 0;
  FxRow := 0;
end;

procedure TUserFind_Frm.Button1Click(Sender: TObject);
var
  li : integer;
  lDeptNo : String;
  lrow : Integer;
begin
  if Person.Text <> '' then
  begin
    with NextGrid1 do
    begin
      BeginUpdate;
      try
        ClearRows;
        lDeptNo := '';
        with DM1.OraQuery2 do
        begin
          if NxComboBox1.Text <> '' then
          begin
            Close;
            SQL.Clear;
            SQL.Add('select * From HiTEMS_DEPTNO ' +
                    'where DEPTNAME = '''+NxComboBox1.Text+''' ');
            Open;

            if RecordCount <> 0 then
              lDeptNo := FieldByName('DEPTNO').AsString;
          end;

          Close;
          SQL.Clear;
          SQL.Add('select * from HiTEMS_EMPLOYEE_V ' +
                  'where NAME_KOR = '''+person.Text+''' ');
          if lDeptNo <> '' then
            SQL.Add('and DEPTNO = '''+lDeptNo+''' ');

          Open;

          if RecordCount <> 0 then
          begin
            while not eof do
            begin
              lRow := AddRow;
              Cells[1,lrow] := FieldByName('USERID').AsString;
              Cells[2,lrow] := FieldByName('NAME_KOR').AsString;
              Cells[3,lrow] := FieldByName('DESCR').AsString;
              Next;
            end;
          end;
        end;
      finally
        EndUpdate;
      end;
    end;
  end
  else
    ShowMessage('성명을 입력하여 주십시오!');

end;


procedure TUserFind_Frm.Button2Click(Sender: TObject);
begin
  case UserKind of
    1 : begin
          FOwner.EMPNO.Items.Clear;
          FOwner.EMPNO.Items.Add(NextGrid1.Cells[1,FxRow]);
          FOwner.EMPNO.Text := NextGrid1.Cells[2,FxRow];
        end;
    2 : begin
          FOwner.INEMPNO.Items.Clear;
          FOwner.INEMPNO.Items.Add(NextGrid1.Cells[1,FxRow]);
          FOwner.INEMPNO.Text := NextGrid1.Cells[2,FxRow];
        end;
    3 : begin
          FOwner.HIEMPNO.Items.Clear;
          FOwner.HIEMPNO.Items.Add(NextGrid1.Cells[1,FxRow]);
          FOwner.HIEMPNO.Text := NextGrid1.Cells[2,FxRow];
        end;
    4 : begin
          FOwner.HIINEMPNO.Items.Clear;
          FOwner.HIINEMPNO.Items.Add(NextGrid1.Cells[1,FxRow]);
          FOwner.HIINEMPNO.Text := NextGrid1.Cells[2,FxRow];
        end;
    5 : begin
          FOwner.ApplyEmpno.Items.Clear;
          FOwner.ApplyEmpno.Items.Add(NextGrid1.Cells[1,FxRow]);
          FOwner.ApplyEmpno.Text := NextGrid1.Cells[2,FxRow];
        end;

{
    6 : begin
          FSubForm.NxComboBox2.Items.Clear;
          FSubForm.NxComboBox2.Items.Add(NextGrid1.Cells[1,FxRow]);
          FSubForm.NxComboBox2.Text := NextGrid1.Cells[2,FxRow];
        end;
}
  end;
  Close;
end;

procedure TUserFind_Frm.Button3Click(Sender: TObject);
begin
  Close;
end;

procedure TUserFind_Frm.SpeedButton3Click(Sender: TObject);
begin
  Close;
end;

procedure TUserFind_Frm.NextGrid1DblClick(Sender: TObject);
begin
// UserKind : integer; // 0 : novalue 1 : EMPNO 2 : INEMPNO 3 : HIEMPNO 4 : HIINEMPNO
  Button2Click(sender);
end;

procedure TUserFind_Frm.NextGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer);
begin
  FxRow := ARow;
  FxCol := ACol;
end;

procedure TUserFind_Frm.NxComboBox1ButtonDown(Sender: TObject);
begin
  with NxComboBox1.Items do
  begin
    BeginUpdate;
    try
      Clear;
      with DM1.OraQuery2 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select DeptName From HiTEMS_DEPTNO ' +
                'where LV = 0 order by DeptNo');
        Open;

        while not eof do
        begin
          Add(FieldByName('DEPTNAME').AsString);
          Next;
        end;
      end;
    finally
      EndUpdate;

    end;
  end;
end;

procedure TUserFind_Frm.NxComboBox1Select(Sender: TObject);
begin
  User_Infomation_Load(NxComboBox1.Text);
end;

end.








