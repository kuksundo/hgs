unit newTestHistory_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, JvBackgrounds, Vcl.ExtCtrls,
  Vcl.StdCtrls, NxColumnClasses, NxColumns, NxScrollControl, Ora, DB,
  NxCustomGridControl, NxCustomGrid, NxGrid, NxEdit, Vcl.ComCtrls,
  AdvDateTimePicker, NxCollection, AdvSmoothPanel, Vcl.Imaging.pngimage,
  Vcl.ImgList, Vcl.Menus, strUtils;

type
  TnewTestHistory_Frm = class(TForm)
    OpenDialog1: TOpenDialog;
    ImageList1: TImageList;
    Panel3: TPanel;
    Button3: TButton;
    Button7: TButton;
    Button1: TButton;
    NxHeaderPanel1: TNxHeaderPanel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    mGrid: TNextGrid;
    NxIncrementColumn3: TNxIncrementColumn;
    NxTextColumn19: TNxTextColumn;
    NxTextColumn20: TNxTextColumn;
    NxTextColumn21: TNxTextColumn;
    Button2: TButton;
    Button6: TButton;
    rGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn4: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    Button9: TButton;
    msGrid: TNextGrid;
    NxIncrementColumn4: TNxIncrementColumn;
    NxTextColumn6: TNxTextColumn;
    NxTextColumn7: TNxTextColumn;
    Button10: TButton;
    Button11: TButton;
    engType: TNxComboBox;
    t_title: TNxEdit;
    T_Purpose: TNxEdit;
    t_req_dept: TNxEdit;
    t_req_person: TNxEdit;
    Button4: TButton;
    Button5: TButton;
    t_plan_begin: TAdvDateTimePicker;
    t_plan_end: TAdvDateTimePicker;
    t_site: TNxComboBox;
    t_method: TMemo;
    t_result: TMemo;
    detailBtn: TButton;
    NxSplitter1: TNxSplitter;
    NxHeaderPanel2: TNxHeaderPanel;
    listGrid: TNextGrid;
    NxIncrementColumn2: TNxIncrementColumn;
    NxTextColumn15: TNxTextColumn;
    NxTextColumn16: TNxTextColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn14: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn11: TNxTextColumn;
    NxTextColumn12: TNxTextColumn;
    NxTextColumn13: TNxTextColumn;
    Button12: TButton;
    Button8: TButton;
    t_rst_begin: TAdvDateTimePicker;
    t_rst_end: TAdvDateTimePicker;
    t_person: TNxEdit;
    t_op_person: TNxEdit;
    NxTextColumn8: TNxTextColumn;
    NxTextColumn9: TNxTextColumn;
    t_type: TNxComboBox;
    procedure engTypeButtonDown(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure t_siteButtonDown(Sender: TObject);
    procedure t_siteSelect(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure listGridDblClick(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure detailBtnClick(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button8Click(Sender: TObject);
    procedure t_personChange(Sender: TObject);
    procedure t_op_personChange(Sender: TObject);
    procedure engTypeChange(Sender: TObject);
  private
    { Private declarations }
    FCurrentKey : String;
    FCurrentProjNo : String;

  public
    { Public declarations }
    function Insert_Into_HIMSEN_TEST_HISTORY: Boolean;
    procedure management_HIMSEN_TEST_MS(aTestNo: String);

    procedure management_HIMSEN_ATTFILES(aTestNo,aGridName, aFlag: String);

    function UPDATE_HIMSEN_TEST_HISTORY(aTestNo:String): Boolean;

    procedure Set_listGrid;
    procedure mod_Attached_Files(aGridName: String);
    procedure Init_;

    function Get_Test_History(aTestNo:String) : Boolean;
    procedure Get_Test_MS(aTestNo:String);
    procedure Get_Test_Att_Files(aTestNo,aFlag,aGrid:String);

    function Get_Engine_Type(aProjNo: String): String;
    function Get_User_Name(aUserId: String): String;
    function Get_MS_Name(aMSNO: String): String;

  end;

var
  newTestHistory_Frm: TnewTestHistory_Frm;

implementation

uses
  searchHistory_Unit,
  testDetail_Unit,
  msCheckView_Unit,
  workerList_Unit,
  CommonUtil_Unit,
  HiTEMS_ETH_COMMON,
  HiTEMS_ETH_CONST,
  DataModule_Unit;

{$R *.dfm}

procedure TnewTestHistory_Frm.Button10Click(Sender: TObject);
var
  lRow: Integer;
  li: Integer;
begin
  with mGrid do
  begin
    if SelectedRow > -1 then
    begin
      lRow := SelectedRow;
      if not(Cells[3, lRow] = '') then
      begin
        DeleteRow(lRow);
      end
      else
      begin
        for li := 0 to Columns.Count - 1 do
          Cell[li, lRow].TextColor := clRed;
      end;
    end;
  end;
end;

procedure TnewTestHistory_Frm.Button11Click(Sender: TObject);
var
  lRow: Integer;
  li: Integer;
begin
  with rGrid do
  begin
    if SelectedRow > -1 then
    begin
      lRow := SelectedRow;
      if not(Cells[3, lRow] = '') then
      begin
        DeleteRow(lRow);
      end
      else
      begin
        for li := 0 to Columns.Count - 1 do
          Cell[li, lRow].TextColor := clRed;
      end;
    end;
  end;
end;

procedure TnewTestHistory_Frm.Button12Click(Sender: TObject);
var
  lSQL : String;
begin
  lSQL := Create_searchHistory;

  if not(lSQL = '') then
  begin
    with listGrid do
    begin
      BeginUpdate;
      ClearRows;
      try
        with DM1.OraQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add(lsql);
          Open;

          while not eof do
          begin
            AddRow;
            Cells[1, RowCount - 1] := FieldByName('PROJNO').AsString;
            Cells[2, RowCount - 1] :=
              Get_Engine_Type(FieldByName('PROJNO').AsString);
            Cells[3, RowCount - 1] := FieldByName('T_TITLE').AsString;
            Cells[4, RowCount - 1] := FieldByName('T_ST_TIME').AsString;
            Cells[5, RowCount - 1] := FieldByName('T_END_TIME').AsString;

//            Cells[6, RowCount - 1] :=
//              Return_Code_Name(FieldByName('T_SITE').AsString);
//            Cells[7, RowCount - 1] :=
//              Return_Code_Name(FieldByName('T_TYPE').AsString);
//            Cells[8, RowCount - 1] := FieldByName('TEST_NO').AsString;

            Next;
          end;
        end;
      finally
        EndUpdate;
      end;
    end;
  end;
end;

procedure TnewTestHistory_Frm.Button1Click(Sender: TObject);
var
  lResult : Boolean;
begin
  if ENGTYPE.Text = '' then
  begin
    ENGTYPE.SetFocus;
    raise Exception.Create('엔진타입을 선택하여 주십시오!');
  end;

  lResult := False;
  try
    if Insert_Into_HIMSEN_TEST_HISTORY = True then
    begin
      management_HIMSEN_TEST_MS(FCurrentKey);
      management_HIMSEN_ATTFILES(FCurrentKey, 'mGrid', 'm');
      management_HIMSEN_ATTFILES(FCurrentKey, 'rGrid', 'r');
      lResult := True;
    end;
  finally
    if lResult then
    begin
      DM1.OraTransaction1.Commit;
      detailBtn.Enabled := True;
      Button3.Enabled := True;
      Set_listGrid;
      ShowMessage('등록 성공!');
    end else
      DM1.OraTransaction1.Rollback;
  end;
end;

procedure TnewTestHistory_Frm.Button2Click(Sender: TObject);
begin
  mod_Attached_Files('mGrid');
end;

procedure TnewTestHistory_Frm.Button3Click(Sender: TObject);
begin
  if ENGTYPE.Text = '' then
  begin
    ENGTYPE.SetFocus;
    raise Exception.Create('엔진타입을 선택하여 주십시오!');
  end;

  DM1.OraTransaction1.StartTransaction;
  try
    if update_HIMSEN_TEST_HISTORY(FCurrentKey) = True then
    begin
      management_HIMSEN_TEST_MS(FCurrentKey);
      management_HIMSEN_ATTFILES(FCurrentKey, 'mGrid', 'm');
      management_HIMSEN_ATTFILES(FCurrentKey, 'rGrid', 'r');

      DM1.OraTransaction1.Commit;
      ShowMessage('일정수정 성공!');
    end;
    Set_listGrid;
  except
    DM1.OraTransaction1.Rollback;
  end;
end;

procedure TnewTestHistory_Frm.Button4Click(Sender: TObject);
var
  Employee: String;
  li: Integer;

  Id, Name: String;
  litem: TStringList;
begin
  Employee := Return_Employee_List(Id,0);
  if not(Employee = '') then
  begin
    litem := TStringList.Create;
    try
      ExtractStrings(['/'], [' '], PChar(Employee), litem);

      Name := litem.Strings[0];
      Id := litem.Strings[1];

      T_PERSON.Text := Name;
      t_person.hint := id;
    finally
      FreeAndNil(litem);
    end;
  end;
end;

procedure TnewTestHistory_Frm.Button5Click(Sender: TObject);
var
  Employee: String;
  li: Integer;

  Id, Name: String;
  litem: TStringList;
begin
  Employee := Return_Employee_List(Id,0);
  if not(Employee = '') then
  begin
    litem := TStringList.Create;
    try
      ExtractStrings(['/'], [' '], PChar(Employee), litem);

      Name := litem.Strings[0];
      Id := litem.Strings[1];

      T_OP_PERSON.Text := Name;
      t_op_person.hint := Id;
    finally
      FreeAndNil(litem);
    end;
  end;
end;

procedure TnewTestHistory_Frm.Button6Click(Sender: TObject);
begin
  mod_Attached_Files('rGrid');
end;

procedure TnewTestHistory_Frm.Button7Click(Sender: TObject);
begin
  Init_;

end;

procedure TnewTestHistory_Frm.Button8Click(Sender: TObject);
begin
  Set_listGrid;
end;

procedure TnewTestHistory_Frm.Button9Click(Sender: TObject);
var
  lResult: String;
  li: Integer;
  litem : TStringList;
  lstr: String;
  lmsname : String;
begin
  if msGrid.RowCount > 0 then
  begin
    for li := 0 to msGrid.RowCount - 1 do
      lstr := lstr + msGrid.Cells[2, li] + '/';

    lstr := Copy(lstr, 0, LastDelimiter('/', lstr) - 1);

  end;
  lResult := Create_Check_View(lstr);
  litem := TStringList.Create;
  try
    ExtractStrings(['/'], [], PChar(lResult), litem);
    with msGrid do
    begin
      BeginUpdate;
      try
        ClearRows;
        for li := 0 to litem.Count - 1 do
        begin
          AddRow;
          lmsname := Get_MS_Name(litem.Strings[li]);
          Cells[1, RowCount - 1] := lmsname;
          Cells[2, RowCount - 1] := litem.Strings[li]
        end;
      finally
        EndUpdate;
      end;
    end;
  finally
    FreeAndNil(litem);
  end;
end;

procedure TnewTestHistory_Frm.detailBtnClick(Sender: TObject);
var
  lstr : String;
  lTestNo : String;
  lTestTitle : String;
begin
  if not Assigned(testDetail_Frm) then
    Create_testDetail_Frm(t_title.text, engType.Text, FCurrentKey)
  else
  begin
    testDetail_Frm.BringToFront;
    testDetail_Frm.ShowModal;
  end;
end;

procedure TnewTestHistory_Frm.engTypeButtonDown(Sender: TObject);
var
  ltype: String;
begin
  with ENGTYPE.Items do
  begin
    BeginUpdate;
    Clear;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT ENGTYPE, PROJNO from HIMSEN_INFO ' +
                'WHERE STATUS = 0 ' +
                'ORDER BY PROJNO ');
        Open;

        Add('');
        while not eof do
        begin
          ltype := FieldByName('PROJNO').AsString + '-' +
            FieldByName('ENGTYPE').AsString;
          Add(ltype);
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TnewTestHistory_Frm.engTypeChange(Sender: TObject);
begin
  if engType.Text <> '' then
    FCurrentProjNo := LeftStr(engType.Text,6)
  else
    FCurrentProjNo := '';
end;

procedure TnewTestHistory_Frm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TnewTestHistory_Frm.FormCreate(Sender: TObject);
begin
  Init_;
end;

function TnewTestHistory_Frm.Get_Engine_Type(aProjNo: String): String;
var
  OraQuery1: TOraQuery;
begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.OraSession1;
  try
    with OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select ENGTYPE From HIMSENINFO ' + 'where PROJNO = ''' +
        aProjNo + ''' ');
      Open;

      if not(RecordCount = 0) then
        Result := FieldByName('ENGTYPE').AsString
      else
        Result := '';
    end;
  finally
    FreeAndNil(OraQuery1);
  end;
end;

function TnewTestHistory_Frm.Get_MS_Name(aMSNO: String): String;
var
  OraQuery1: TOraQuery;
begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.OraSession1;
  try
    with OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select MSNAME From HIMSEN_MS_NUMBER ' + 'where MSNO = ''' +
        aMSNO+ ''' ');
      Open;

      if not(RecordCount = 0) then
        Result := FieldByName('MSNAME').AsString
      else
        Result := '';
    end;
  finally
    FreeAndNil(OraQuery1);
  end;
end;


procedure TnewTestHistory_Frm.Get_Test_Att_Files(aTestNo, aFlag, aGrid: String);
var
  Grid : TNextGrid;
begin
  Grid := TNextGrid(FindComponent(aGrid));
  if Assigned(Grid) then
  begin
    with Grid do
    begin
      BeginUpdate;
      ClearRows;
      try
        with DM1.OraQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT FILE_NO, TEST_NO, FLAG, FILENAME, FILESIZE ' +
                  'FROM HITEMS_ETH_ATTFILES ' +
                  'WHERE TEST_NO = :param1 ' +
                  'AND FLAG = :param2 ' +
                  'ORDER BY FILE_NO ');

          ParamByName('param1').AsString := aTestNo;
          ParamByName('param2').AsString := aFlag;
          Open;

          if not(RecordCount = 0) then
          begin
            while not eof do
            begin
              AddRow;
              Cells[1,RowCount-1] := FieldByName('FILENAME').AsString;
              Cells[2,RowCount-1] := FieldByName('FILESIZE').AsString;
              Cells[4,RowCount-1] := FieldByName('FILE_NO').AsString;
              Next;
            end;
          end;
        end;
      finally
        EndUpdate;
      end;
    end;
  end;
end;

function TnewTestHistory_Frm.Get_Test_History(aTestNo: String): Boolean;
var
  lRow: Integer;
  lTestNo: String;
begin
  Result := False;
  with listGrid do
  begin
    lRow := listGrid.SelectedRow;
    lTestNo := Cells[8, lRow];
    BeginUpdate;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM HITEMS_ETH_HISTORY ' +
                'WHERE TEST_NO = :param1 ');
        ParamByName('param1').AsString := aTestNo;
        Open;

        if not(RecordCount = 0) then
        begin
          engType.Text := Cells[1,lRow]+'-'+Cells[2,lRow];
          t_title.Text := Cells[3,lRow];
          t_purpose.Text := FieldByName('T_PURPOSE').AsString;
          t_req_dept.Text := FieldByName('T_REQ_DEPT').AsString;
          t_req_person.Text := FieldByName('T_REQ_PERSON').AsString;

          T_Person.Hint     := FieldByName('T_PERSON').AsString;
          T_Person.Text     := Get_User_Name(t_person.Hint);

          T_OP_Person.Hint  := FieldByName('T_OP_Person').AsString;
          T_OP_Person.Text  := Get_User_Name(T_OP_Person.Hint);

          t_plan_begin.DateTime := FieldByName('T_PLAN_BEGIN').AsDateTime;
          t_plan_end.DateTime   := FieldByName('T_PLAN_END').AsDateTime;

          t_rst_begin.DateTime  := FieldByName('T_RST_BEGIN').AsDateTime;
          t_rst_end.DateTime    := FieldByName('T_RST_END').AsDateTime;

          T_SITE.Text := FieldByName('T_SITE').AsString;
          T_TYPE.Text := FieldByName('T_TYPE').AsString;

          t_method.Text := FieldByName('T_METHOD').AsString;
          t_result.Text := FieldByName('T_RESULT').AsString;
          Result := True;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TnewTestHistory_Frm.Get_Test_MS(aTestNo: String);
begin
  with msGrid do
  begin
    BeginUpdate;
    ClearRows;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select A.*, B.MSNAME from HITEMS_ETH_MS A, HIMSEN_MS_NUMBER B ' +
                ' where A.TEST_NO = :param1 '+
                ' and A.MSNO = B.MSNO '+
                ' order by A.SortNo');
        ParamByName('param1').AsString := aTestNo;
        Open;

        if not(RecordCount = 0) then
        begin
          while not eof do
          begin
            AddRow;
            Cells[1,RowCount-1] := FieldByName('MSNAME').AsString;
            Cells[2,RowCount-1] := FieldByName('MSNO').AsString;
            Next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

function TnewTestHistory_Frm.Get_User_Name(aUserId: String): String;
var
  OraQuery1: TOraQuery;
begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.OraSession1;
  try
    with OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT NAME_KOR FROM HiTEMS_EMPLOYEE ' +
              'WHERE USERID = :param1 ');
      ParamByName('param1').AsString := aUserId;
      Open;

      if not(RecordCount = 0) then
        Result := FieldByName('NAME_KOR').AsString
      else
        Result := '';
    end;
  finally
    FreeAndNil(OraQuery1);
  end;
end;

procedure TnewTestHistory_Frm.Init_;
begin
//  FillChar(FnewHistory, SizeOf(FnewHistory), '');
  listGrid.DoubleBuffered := False;
  msGrid.DoubleBuffered := False;
  mGrid.DoubleBuffered := False;
  rGrid.DoubleBuffered := False;

  listGrid.ClearRows;
  msGrid.ClearRows;
  mGrid.ClearRows;
  rGrid.ClearRows;

  t_plan_begin.DateTime := Now;
  t_plan_end.DateTime := Now;

  t_rst_begin.DateTime := Now;
  t_rst_end.DateTime := Now;

  Set_listGrid;

  NxHeaderPanel1.Caption := '신규일정 등록';
  Button3.Enabled := False;

  engType.Items.Clear;
  engType.Clear;

  T_TITLE.Clear;
  T_REQ_DEPT.Clear;
  T_REQ_PERSON.Clear;

  T_PERSON.Clear;

  T_OP_PERSON.Clear;

  T_METHOD.Clear;
  T_Purpose.Clear;
  T_RESULT.Clear;

  detailBtn.Enabled := False;

end;

procedure TnewTestHistory_Frm.management_HIMSEN_ATTFILES(aTestNo,aGridName,aFlag: String);
var
  Grid: TNextGrid;
  li: Integer;
  lms: TMemoryStream;
begin
  Grid := TNextGrid(FindComponent(aGridName));

  if Assigned(Grid) then
  begin
    with Grid do
    begin
      BeginUpdate;
      try
        for li := 0 to RowCount - 1 do
        begin
          if Cell[1,li].TextColor = clBlue then
          begin
            with DM1.OraQuery1 do
            begin
              Close;
              SQL.Clear;
              SQL.Add('INSERT INTO HITEMS_ETH_ATTFILES ' +
                      'VALUES( ' +
                      ':FILE_NO, :TEST_NO, :FLAG, :FILENAME, :FILESIZE, :FILES )');

              ParamByName('FILE_NO').AsString := make_ETH_Key;
              ParamByName('TEST_NO').AsString := aTestNo;
              ParamByName('FLAG').AsString := aFlag;
              ParamByName('FILENAME').AsString := Cells[1, li];

              lms := TMemoryStream.Create;
              try
                lms.LoadFromFile(Cells[3, li]);
                ParamByName('FILESIZE').AsFloat := lms.Size;

                ParamByName('Files').ParamType := ptInput;
                ParamByName('Files').AsOraBlob.LoadFromStream(lms);

                ExecSQL;

              finally
                FreeAndNil(lms);
              end;
            end;
          end else
          if Cell[1,li].TextColor = clRed then
          begin
            with DM1.OraQuery1 do
            begin
              Close;
              SQL.Clear;
              SQL.Add('DELETE FROM HITEMS_ETH_ATTFILES ' +
                      'WHERE FILE_NO = :param1 ');
              ParamByName('param1').AsString := Cells[4,li];
              ExecSQL;
            end;
          end;
        end;
        Get_Test_Att_Files(aTestNo,aFlag,aGridName);
      finally
        EndUpdate;
      end;
    end;
  end;
end;

function TnewTestHistory_Frm.Insert_Into_HIMSEN_TEST_HISTORY: Boolean;
begin
  Result := False;
  try
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('INSERT INTO HITEMS_ETH_HISTORY ' +
              'VALUES( ' +
              ':TEST_NO, :PROJNO, :T_SITE, :T_TYPE, :T_TITLE, ' +
              ':T_PLAN_BEGIN, :T_PLAN_END, :T_RST_BEGIN, :T_RST_END, :T_REQ_DEPT, ' +
              ':T_REQ_PERSON, :T_PERSON, :T_OP_PERSON, :T_METHOD, :T_PURPOSE, ' +
              ':T_RESULT, :REGID, :REGDATE, :MODID, :MODDATE )' );

      FCurrentKey := make_ETH_Key;
      ParamByName('TEST_NO').AsString        := FCurrentKey;
      ParamByName('PROJNO').AsString         := FCurrentProjNo;
      ParamByName('T_SITE').AsString         := t_site.Text;
      ParamByName('T_TYPE').AsString         := t_type.Text;
      ParamByName('T_TITLE').AsString        := t_title.Text;

      ParamByName('T_PLAN_BEGIN').AsDateTime := t_plan_begin.DateTime;
      ParamByName('T_PLAN_END').AsDateTime   := t_plan_end.DateTime;
      ParamByName('T_RST_BEGIN').AsDateTime  := t_rst_begin.DateTime;
      ParamByName('T_RST_END').AsDateTime    := t_rst_end.DateTime;
      ParamByName('T_REQ_DEPT').AsString     := t_req_dept.Text;

      ParamByName('T_REQ_PERSON').AsString   := t_req_person.Text;
      ParamByName('T_PERSON').AsString       := t_person.Hint;
      ParamByName('T_OP_PERSON').AsString    := t_op_person.Hint;
      ParamByName('T_METHOD').AsString       := t_Method.Text;
      ParamByName('T_PURPOSE').AsString      := t_purpose.Text;

      ParamByName('T_RESULT').AsString       := t_Result.Text;
      ParamByName('REGID').AsString          := CurrentUsers;
      ParamByName('REGDATE').AsDateTime      := Now;
      // ParamByName('MODID').AsString := PROJNO;
      // ParamByName('MODDATE').AsDateTime := PROJNO;
      ExecSQL;
      Result := True;
    end;
  except
    Result := False;
  end;
end;

procedure TnewTestHistory_Frm.management_HIMSEN_TEST_MS(aTestNo: String);
var
  li: Integer;
begin
  with msGrid do
  begin
    BeginUpdate;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('DELETE FROM HITEMS_ETH_MS ' +
                'WHERE TEST_NO = :param1 ');
        ParamByName('param1').AsString := aTestNo;
        ExecSQL;


        Close;
        SQL.Clear;
        SQL.Add('INSERT INTO HITEMS_ETH_MS ' +
                'VALUES(:TEST_NO, :MSNO, :SORTNO) ');

        for li := 0 to RowCount - 1 do
        begin
          ParamByName('TEST_NO').AsString := aTestNo;
          ParamByName('MSNO').AsString    := Cells[2, li];
          ParamByName('SORTNO').AsInteger := Cell[0, li].AsInteger;
          ExecSQL;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TnewTestHistory_Frm.listGridDblClick(Sender: TObject);
begin
  FCurrentKey := listGrid.Cells[8,listGrid.SelectedRow];
  if not(FCurrentKey = '') then
  begin
    NxHeaderPanel1.Caption := '시험일정 수정';
    Button3.Enabled := True;
    detailBtn.Enabled := True;

    if Get_Test_History(FCurrentKey) = True then
    begin
      Get_Test_MS(FCurrentKey);
      Get_Test_Att_Files(FCurrentKey,'m','mGrid');
      Get_Test_Att_Files(FCurrentKey,'r','rGrid');
    end;
  end;
end;

procedure TnewTestHistory_Frm.mod_Attached_Files(aGridName: String);
var
  li, le: Integer;
  lResult: Boolean;
  lname: String;
  lsame: TStringList;
  lms: TMemoryStream;
  lsize: Int64;
  Grid: TNextGrid;
begin
  Grid := TNextGrid(FindComponent(aGridName));

  if OpenDialog1.Execute then
  begin
    lsame := TStringList.Create;
    try
      for li := 0 to OpenDialog1.Files.Count - 1 do
      begin
        lResult := True;
        lname := OpenDialog1.Files.Strings[li];
        lname := ExtractFileName(lname);
        with Grid do
        begin
          BeginUpdate;
          try
            if RowCount > 0 then
            begin
              for le := 0 to RowCount - 1 do
              begin
                if lname = Cells[1, le] then
                begin
                  lsame.Add(lname);
                  lResult := False;
                  Break;
                end;
              end;
            end;

            if lResult = True then
            begin
              lms := TMemoryStream.Create;
              try
                AddRow(1);
                Cells[1, RowCount - 1] := lname;
                Cells[3, RowCount - 1] := OpenDialog1.Files.Strings[li];

                lms.LoadFromFile(OpenDialog1.Files.Strings[li]);
                lsize := lms.Size;
                Cells[2, RowCount - 1] := IntToStr(lsize);

                for le := 0 to Columns.Count - 1 do
                  Cell[le, RowCount - 1].TextColor := clBlue;
              finally
                FreeAndNil(lms);
              end;
            end;
          finally
            EndUpdate;
          end;
        end;
      end;

      lname := '';
      for li := 0 to lsame.Count - 1 do
        lname := lname + lsame.Strings[li] + #10#13;

      if not(lname = '') then
        ShowMessage('같은 이름의 파일이 등록되어 있습니다 : ' + #10#13 + lname);

    finally
      FreeAndNil(lsame);
    end;
  end;
end;

procedure TnewTestHistory_Frm.Set_listGrid;
begin
  with listGrid do
  begin
    BeginUpdate;
    ClearRows;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM HITEMS_ETH_HISTORY ' +
                'ORDER BY T_RST_BEGIN ');
        Open;

        while not eof do
        begin
          AddRow;
          Cells[1, RowCount - 1] := FieldByName('PROJNO').AsString;
          Cells[2, RowCount - 1] := Get_Engine_Type(FieldByName('PROJNO').AsString);
          Cells[3, RowCount - 1] := FieldByName('T_TITLE').AsString;
          Cells[4, RowCount - 1] := FieldByName('T_RST_BEGIN').AsString;
          Cells[5, RowCount - 1] := FieldByName('T_RST_END').AsString;

          Cells[6, RowCount - 1] := FieldByName('T_SITE').AsString;
          Cells[7, RowCount - 1] := FieldByName('T_TYPE').AsString;
          Cells[8, RowCount - 1] := FieldByName('TEST_NO').AsString;

          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TnewTestHistory_Frm.t_op_personChange(Sender: TObject);
begin
  if t_op_person.Text = '' then
    t_op_person.Hint := '';
end;

procedure TnewTestHistory_Frm.t_personChange(Sender: TObject);
begin
  if t_person.Text = '' then
    t_person.Hint := '';

end;

procedure TnewTestHistory_Frm.t_siteButtonDown(Sender: TObject);
var
  lstr: String;
  lTag: Integer;
  s: TNxComboBox;
begin
  with t_site.Items do
  begin
    BeginUpdate;
    try
      Clear;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM HITEMS_LOC_CODE ' +
                'WHERE LOC_LV = 0 ' +
                'ORDER BY LOC_SORT ');
        Open;

        Add('');
        while not eof do
        begin
          Add(FieldByName('LOC_NAME').AsString);
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TnewTestHistory_Frm.t_siteSelect(Sender: TObject);
var
  lCdNm, lCode: String;
  s: TNxComboBox;
begin
  if t_site.Text <> '' then
  begin
    with DM1.OraQuery1 do
    begin
      First;
      while not eof do
      begin
        if FieldByName('LOC_NAME').AsString = t_site.Text then
        begin
          t_site.Hint := FieldByName('LOC_CODE').AsString;
          Break;
        end;
        Next;
      end;
    end;
  end else
    t_site.Hint := '';
end;

function TnewTestHistory_Frm.UPDATE_HIMSEN_TEST_HISTORY(aTestNo:String): Boolean;
begin
  Result := False;
  try
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('UPDATE HITEMS_ETH_HISTORY SET ' +
              'PROJNO = :PROJNO, T_SITE = :T_SITE, T_TYPE = :T_TYPE,' +
              'T_TITLE = :T_TITLE, T_PLAN_BEGIN = :T_PLAN_BEGIN, T_PLAN_END = :T_PLAN_END, ' +
              'T_RST_BEGIN = :T_RST_BEGIN, T_RST_END = :T_RST_END, ' +
              'T_REQ_DEPT = :T_REQ_DEPT, T_REQ_PERSON = :T_REQ_PERSON, ' +
              'T_PERSON = :T_PERSON, T_OP_PERSON = :T_OP_PERSON, ' +
              'T_METHOD = :T_METHOD, T_PURPOSE = :T_PURPOSE,' +
              'T_RESULT = :T_RESULT, MODID = :MODID, MODDATE = :MODDATE ' +
              'WHERE TEST_NO = :param1 ');

      ParamByName('param1').AsString := aTestNo;

      ParamByName('PROJNO').AsString := FCurrentProjNo;
      ParamByName('T_SITE').AsString := t_site.Text;
      ParamByName('T_TYPE').AsString := t_type.Text;
      ParamByName('T_TITLE').AsString := t_title.Text;
      ParamByName('T_PLAN_BEGIN').AsDateTime := t_plan_begin.DateTime;

      ParamByName('T_PLAN_END').AsDateTime  := t_plan_end.DateTime;
      ParamByName('T_RST_BEGIN').AsDateTime := t_rst_begin.DateTime;
      ParamByName('T_RST_END').AsDateTime   := t_rst_end.DateTime;
      ParamByName('T_REQ_DEPT').AsString    := t_req_dept.Text;
      ParamByName('T_REQ_PERSON').AsString  := t_req_person.Text;

      ParamByName('T_PERSON').AsString      := t_person.Hint;
      ParamByName('T_OP_PERSON').AsString   := t_op_person.Hint;

      ParamByName('T_METHOD').AsString      := t_method.Text;
      ParamByName('T_PURPOSE').AsString     := T_Purpose.Text;
      ParamByName('T_RESULT').AsString      := t_result.Text;
      ParamByName('MODID').AsString         := CurrentUsers;
      ParamByName('MODDATE').AsDateTime     := Now;
      ExecSQL;

      Result := True;
    end;
  except
    Result := False;
  end;
end;

end.
