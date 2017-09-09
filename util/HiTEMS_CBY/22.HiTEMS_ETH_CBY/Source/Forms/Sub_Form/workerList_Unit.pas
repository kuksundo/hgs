unit workerList_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvSmoothListBox, Vcl.ImgList,
  AdvSmoothButton, NxColumnClasses, NxColumns, NxScrollControl,
  NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.StdCtrls, Vcl.ExtCtrls, NxEdit,
  Ora;
type
  TResultMode = (frChkOne, frChkAll);

type
  TworkerList_Frm = class(TForm)
    AdvSmoothListBox1: TAdvSmoothListBox;
    ImageList1: TImageList;
    Button1: TButton;
    Button2: TButton;
    workerGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxCheckBoxColumn1: TNxCheckBoxColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel4: TPanel;
    DeptNo: TNxComboBox;
    Panel3: TPanel;
    Panel5: TPanel;
    Team: TNxComboBox;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure TeamSelect(Sender: TObject);
    procedure workerGridAfterEdit(Sender: TObject; ACol, ARow: Integer;
      Value: WideString);
  private
    { Private declarations }
    fResultMode : TResultMode;

    Fworkers: String;
    FFirst: Boolean;

    property ResultMode : TResultMode read fResultMode write fResultMode;

    procedure Load_Emp_List(aDeptNo, aTeam: String);
    procedure set_Dept(aDeptNo:String);
    procedure set_Team(aDeptNo:String);
    procedure Check_Workers(aWorkers:String);
    function Return_DeptNo(aDeptName: String): String;
  public
    { Public declarations }
  end;

var
  workerList_Frm: TworkerList_Frm;
  function Return_Employee_List(aWorkers:String;aMode:integer): String;

implementation

uses
  HiTEMS_ETH_COMMON,
  HiTEMS_ETH_Const,
  DataModule_Unit;

{$R *.dfm}

function Return_Employee_List(aWorkers: String;aMode:Integer): String;
var
  lDeptNo : String;
begin
  with TworkerList_Frm.Create(Application) do
  begin
    Fworkers := aWorkers;
    lDeptNo := CurrentUsersDept;
    set_Dept(lDeptNo);
    set_Team(lDeptNo);

    case aMode of
      0 : ResultMode := frChkOne;
      1 : ResultMode := frChkAll;
    end;

    try
      Load_Emp_List(lDeptNo, '');

      if not(aWorkers = '') then
        Check_Workers(aWorkers);

      ShowModal;

      if ModalResult = mrOk then
        if not(Fworkers = '') then
          Result := Fworkers
        else
          Result := '';
    finally
      Free;
    end;
  end;
end;

procedure TworkerList_Frm.Button2Click(Sender: TObject);
var
  li: integer;
  LUSER : String;

begin
  try
    with workerGrid do
    begin
      for li := 0 to RowCount - 1 do
        if Cell[1, li].AsBoolean = True then
          LUSER := LUSER + Cells[2,li]+'/'+Cells[4,li]+',';

      li := 0;
      li := LastDelimiter(',',LUser);

      if li > 0 then
        LUSER := Copy(LUser,0,li-1);


      Fworkers := LUser;
    end;
  finally
    if not(Fworkers = '') then
      ModalResult := mrOk;
  end;
end;

procedure TworkerList_Frm.Check_Workers(aWorkers: String);
var
  le, li : integer;
  lUsers : TStringList;
  lstr : String;
begin
  if not(aWorkers = '') then
  begin
    with workerGrid do
    begin
      BeginUpdate;
      lUsers := TStringList.Create;
      try
        ExtractStrings([','],[],PChar(aWorkers),lUsers);

        for le := 0 to lUsers.Count-1 do
        begin
          lstr := lUsers.Strings[le];
          for li := 0 to RowCount-1 do
          begin
            if lstr = Cells[4,li] then
            begin
              Cell[1,li].AsBoolean := True;
              Break;
            end;
          end;
        end;
      finally
        FreeAndNil(lUsers);
        EndUpdate;
      end;
    end;
  end;
end;

procedure TworkerList_Frm.FormCreate(Sender: TObject);
begin
  FFirst := True;
  workerGrid.DoubleBuffered := False;
end;

procedure TworkerList_Frm.Load_Emp_List(aDeptNo, aTeam: String);
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HiTEMS_EMPLOYEE_V where GUNMU = ''I'' ');
    SQL.Add('and ATTACHED = ''HHI'' ');

    if not(aDeptNo = '') then
      SQL.Add('and DEPTNO = '''+aDeptNo+''' ');

    if not(aTeam = '') then
      SQL.Add('and TEAMNO = '''+aTeam+''' ');

    Open;

    if not(RecordCount = 0) then
    begin
      with workerGrid do
      begin
        BeginUpdate;
        ClearRows;
        try
          while not eof do
          begin
            AddRow;
            Cells[2,RowCount-1] := FieldByName('NAME_KOR').AsString;
            Cells[3,RowCount-1] := FieldByName('DESCR').AsString;
            Cells[4,RowCount-1] := FieldByName('USERID').AsString;
            Next;
          end;
        finally
          EndUpdate;
        end;
      end;
    end;
  end;
end;

function TworkerList_Frm.Return_DeptNo(aDeptName: String): String;
var
  OraQuery1: TOraQuery;
begin
  OraQuery1 := TOraQuery.Create(nil);
  try
    OraQuery1.Session := DM1.OraSession1;

    with OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.add('select * from DEPTNO ' + 'where DESCR = ''' + aDeptName + ''' ');
      // 'and GUBUN = ''S'' ');
      Open;

      if not(RecordCount = 0) then
        Result := FieldByName('DEPTNO').AsString;

    end;
  finally
    FreeAndNil(OraQuery1);
  end;
end;

procedure TworkerList_Frm.set_Dept(aDeptNo:String);
begin
  DeptNo.Items.Clear;
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HiTEMS_DEPTNO ' +
            'where LV = 0 ');
    Open;

    if not(RecordCount = 0) then
    begin
      DeptNo.Items.Add('');
      while not eof do
      begin
        DeptNo.Items.Add(FieldByName('DEPTNAME').AsString);

        if FieldByName('DeptNo').AsString = aDeptNo then
          DeptNo.Text := FieldByName('DEPTNAME').AsString;

        Next;
      end;
    end;
  end;
end;

procedure TworkerList_Frm.set_Team(aDeptNo:String);
begin
  TEAM.Items.Clear;
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HiTEMS_DEPTNO ' +
            'where PRTDEPTNO = '''+aDeptNo+''' ');
    Open;

    if not(RecordCount = 0) then
    begin
      TEAM.Items.Add('');
      while not eof do
      begin
        TEAM.Items.Add(FieldByName('DEPTNAME').AsString);
        Next;
      end;
    end;
  end;
end;

procedure TworkerList_Frm.TeamSelect(Sender: TObject);
var
  lDept, lTeam: String;
begin
  lDept := Return_DeptNo(DeptNo.Text);
  lTeam := Return_DeptNo(Team.Text);
  Load_Emp_List(lDept, lTeam);
end;

procedure TworkerList_Frm.workerGridAfterEdit(Sender: TObject; ACol,
  ARow: Integer; Value: WideString);
var
  li : integer;
begin
  if ResultMode = frChkOne then
  begin
    case ACol of
      1 : begin
            for li := 0 to workerGrid.RowCount-1 do
            begin
              workerGrid.Cell[1,li].AsBoolean := False;
            end;
            workerGrid.Cell[1,ARow].AsBoolean := True;
          end;
    end;
  end;
end;

end.
