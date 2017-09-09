unit newTestHistory_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, NxCollection,
  Vcl.Imaging.pngimage, AdvSmoothListBox, AdvSmoothPanel, Vcl.StdCtrls, NxEdit,
  Vcl.ComCtrls, AdvDateTimePicker, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, AdvPageControl, JvBackgrounds, NxColumnClasses,
  NxColumns, Vcl.Grids, AdvObj, BaseGrid, AdvGrid, GradientLabel, Ora,
  Vcl.ImgList;
type
  TnewHistory = Record
    TEST_NO,
    TEST_SITE,
    TEST_TYPE : Double;
    PROJNO,
    T_TITLE,
    T_REQ_DEPT,
    T_REQ_PERSON,
    T_PERSON,
    T_OP_PERSON,
    T_METHOD,
    T_PURPOSE : String;
    T_ST_TIME,
    T_END_TIME : TDATETIME;
  End;

type
  TnewTestHistory_Frm = class(TForm)
    AdvSmoothPanel1: TAdvSmoothPanel;
    Image2: TImage;
    AdvPageControl2: TAdvPageControl;
    AdvTabSheet4: TAdvTabSheet;
    AdvTabSheet5: TAdvTabSheet;
    Panel3: TPanel;
    Button3: TButton;
    Panel1: TPanel;
    Label1: TLabel;
    engType: TNxComboBox;
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
    Button4: TButton;
    Button5: TButton;
    AdvPageControl1: TAdvPageControl;
    AdvTabSheet1: TAdvTabSheet;
    op_grid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn4: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    NxTextColumn6: TNxTextColumn;
    NxTextColumn7: TNxTextColumn;
    NxTextColumn8: TNxTextColumn;
    NxTextColumn9: TNxTextColumn;
    NxTextColumn10: TNxTextColumn;
    AdvTabSheet2: TAdvTabSheet;
    GradientLabel1: TGradientLabel;
    GradientLabel2: TGradientLabel;
    op_fiv: TAdvStringGrid;
    op_fip: TAdvStringGrid;
    AdvTabSheet3: TAdvTabSheet;
    OILGRID: TAdvStringGrid;
    editType: TRadioGroup;
    t_title: TNxEdit;
    t_st_time: TAdvDateTimePicker;
    t_end_time: TAdvDateTimePicker;
    t_site: TNxComboBox;
    t_type: TNxComboBox;
    t_req_dept: TNxEdit;
    t_req_person: TNxEdit;
    T_Person: TNxComboBox;
    T_OP_PERSON: TNxComboBox;
    t_method: TMemo;
    t_purpose: TMemo;
    listGrid: TNextGrid;
    NxIncrementColumn2: TNxIncrementColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn11: TNxTextColumn;
    NxTextColumn12: TNxTextColumn;
    NxTextColumn14: TNxTextColumn;
    NxHeaderPanel2: TNxHeaderPanel;
    Panel6: TPanel;
    s_search_btn: TButton;
    Button6: TButton;
    Label5: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    s_st_time: TAdvDateTimePicker;
    s_end_time: TAdvDateTimePicker;
    s_site: TNxComboBox;
    s_type: TNxComboBox;
    s_test_name: TNxComboBox;
    CheckBox1: TNxCheckBox;
    CheckBox2: TNxCheckBox;
    NxTextColumn13: TNxTextColumn;
    NxTextColumn15: TNxTextColumn;
    NxTextColumn16: TNxTextColumn;
    Label22: TLabel;
    s_engtype: TNxComboBox;
    Button7: TButton;
    Button8: TButton;
    JvBackground1: TJvBackground;
    ImageList1: TImageList;
    Button9: TButton;
    Panel2: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label4: TLabel;
    Panel4: TPanel;
    Button1: TButton;
    Button2: TButton;
    op_load: TNxComboBox;
    op_st_time: TAdvDateTimePicker;
    op_end_time: TAdvDateTimePicker;
    op_amb_temp: TNxNumberEdit;
    op_amb_press: TNxNumberEdit;
    op_amb_hygro: TNxNumberEdit;
    op_fuel1: TNxNumberEdit;
    op_fuel2: TNxNumberEdit;
    procedure FormCreate(Sender: TObject);
    procedure engTypeButtonDown(Sender: TObject);
    procedure engTypeSelect(Sender: TObject);
    procedure t_siteButtonDown(Sender: TObject);
    procedure t_typeButtonDown(Sender: TObject);
    procedure t_siteSelect(Sender: TObject);
    procedure t_typeSelect(Sender: TObject);
    procedure op_end_timeCloseUp(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure op_loadButtonDown(Sender: TObject);
    procedure op_st_timeCloseUp(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure op_fipCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure op_fipGetEditorType(Sender: TObject; ACol, ARow: Integer;
      var AEditor: TEditorType);
    procedure op_fipKeyPress(Sender: TObject; var Key: Char);
    procedure op_fipSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure op_fivGetEditorType(Sender: TObject; ACol, ARow: Integer;
      var AEditor: TEditorType);
    procedure op_fivKeyPress(Sender: TObject; var Key: Char);
    procedure OILGRIDKeyPress(Sender: TObject; var Key: Char);
    procedure OILGRIDCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure OILGRIDGetEditorType(Sender: TObject; ACol, ARow: Integer;
      var AEditor: TEditorType);
    procedure OILGRIDGetEditorProp(Sender: TObject; ACol, ARow: Integer;
      AEditLink: TEditLink);
    procedure OILGRIDSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure op_fivSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure op_fivCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure t_st_timeChange(Sender: TObject);
    procedure t_end_timeChange(Sender: TObject);
    procedure s_test_nameButtonDown(Sender: TObject);
    procedure s_siteButtonDown(Sender: TObject);
    procedure s_typeButtonDown(Sender: TObject);
    procedure s_search_btnClick(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure s_engtypeButtonDown(Sender: TObject);
    procedure s_engtypeSelect(Sender: TObject);
    procedure listGridDblClick(Sender: TObject);
    procedure editTypeClick(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure op_gridDblClick(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure T_PersonKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
    FnewHistory : TnewHistory;
    FxRow,FxCol : Integer;
  public
    { Public declarations }
    procedure Initialize_;
    procedure Set_Test_History;
    procedure Show_History_by_Conditions;



    procedure Set_FIE_Table(aEngType:String);

    function Check_for_History : String;
    function Check_for_DateTime_In_opGrid(var aMsg:String) : Boolean;

    procedure Insert_Routine;
    procedure Insert_Into_HIMSEN_TEST_HISTORY;
    procedure Insert_Into_HIMSEN_ETH_OPERATING(aTestNo:String;aProjNo:String);
    procedure Insert_Into_HIMSEN_ETH_FIE(aTestNo:String;aProjNo:String);
    procedure Insert_Into_HIMSEN_ETH_USEDOIL(aTestNo:String;aProjNo:String);


    procedure Update_Routine;
    procedure Update_HIMSEN_TEST_HISTORY;
    procedure Update_HIMSEN_ETH_OPERATING(aTestNo:String;aProjNo:String);
    procedure Update_HIMSEN_ETH_FIE(aTestNo:String;aProjNo:String);
    procedure Update_HIMSEN_ETH_USEDOIL(aTestNo:String;aProjNo:String);


    function Return_Code_Name(aCode:Double) : String;
    function Return_Code_(aCodeName:String) : String;



    procedure Delete_all_Record(aTestNo:String);

    procedure load_Data_Routine(aTestNo:String);
    procedure load_for_Test_History(aTestNo:String);
    procedure load_for_Operating_Data(aTestNo:String);
    procedure load_for_FIE_Data(aTestNo:String);
    procedure load_for_ETH_UsedOil(aTestNo:String);

    function Return_name(aUserID:String) : String;



  end;

var
  newTestHistory_Frm: TnewTestHistory_Frm;

implementation
uses
  MountedGrid_Unit,
  workerList_Unit,
  CommonUtil_Unit,
  HiTEMS_ETH_CONST,
  DataModule_Unit;


{$R *.dfm}

{ TnewTestHistory_Frm }

procedure TnewTestHistory_Frm.Button1Click(Sender: TObject);
var
  lMsg : String;
begin
  if not(op_load.Text = '') then
  begin
    if Check_for_DateTime_In_opGrid(lMsg) = True then
    begin
      with op_grid do
      begin
        BeginUpdate;
        try
          AddRow;
          Cells[1,RowCount-1] := op_load.Text;
          Cells[2,RowCount-1] := FormatDateTime('YYYY-MM-DD HH:mm',op_st_time.DateTime);
          Cells[3,RowCount-1] := FormatDateTime('YYYY-MM-DD HH:mm',op_end_time.DateTime);
          Cells[4,RowCount-1] := op_amb_temp.Text;
          Cells[5,RowCount-1] := op_amb_press.Text;
          Cells[6,RowCount-1] := op_amb_hygro.Text;
          Cells[7,RowCount-1] := op_fuel1.Text;
          Cells[8,RowCount-1] := op_fuel2.Text;

        finally
          SortColumn(op_grid.Columns[2],True);
          EndUpdate;
        end;
      end;
    end
    else
    begin
      ShowMessage(lMsg);
    end;
  end
  else
    ShowMessage('로드는 필수 입력 입니다!');
end;

procedure TnewTestHistory_Frm.Button2Click(Sender: TObject);
begin
  if op_grid.SelectedRow > -1 then
  begin
    op_grid.DeleteRow(op_grid.SelectedRow);
  end;
end;

procedure TnewTestHistory_Frm.Button3Click(Sender: TObject);
var
  lMsg : String;
  lMsgList : TStringList;
  li : integer;
begin
  if not(engType.Text = '') then
  begin
    lMsg := Check_for_History;
    if lMsg = '' then
    begin
      case editType.ItemIndex of
        0 : Insert_Routine;
        1 : Update_Routine;
      end;
      Show_History_by_Conditions;
    end
    else
    begin
      lMsgList := TStringList.Create;
      try
        lMsgList.Delimiter := ';';
        lMsgList.DelimitedText := lMsg;

        lMsg := '';
        for li := 0 to lMsgList.Count-1 do
          lMsg := lMsg + lMsgList.Strings[li] + #10#13;

        ShowMessage(lMsg);
      finally
        FreeAndNil(lMsgList);
      end;
    end;
  end
  else
    ShowMessage('엔진타입을 선택 하십시오!');
end;

procedure TnewTestHistory_Frm.Button4Click(Sender: TObject);
var
  Employee : String;
  li : integer;

  Id,Name : String;
begin
  Employee := Return_Employee_List(T_Person.Text);
  if not(Employee = '') then
  begin
    li := POS('/',Employee);

    Name := Copy(Employee,0,li-1);
    Id := Copy(Employee,li+1,Length(Employee));

    li := POS(',',Name);
    if li > 0 then
      Name := Copy(Name,0,li-1);

    li := POS(',',ID);
    if li > 0 then
      ID := Copy(ID,0,li-1);

    T_Person.Items.Clear;
    T_Person.Items.Add(ID);
    T_Person.Text := Name;
  end;
end;

procedure TnewTestHistory_Frm.Button5Click(Sender: TObject);
var
  Employee : String;
  li : integer;

  Id,Name : String;
begin
  Employee := Return_Employee_List(T_OP_Person.Text);
  if not(Employee = '') then
  begin
    li := POS('/',Employee);

    Name := Copy(Employee,0,li-1);
    Id := Copy(Employee,li+1,Length(Employee));

    li := POS(',',Name);
    if li > 0 then
      Name := Copy(Name,0,li-1);

    li := POS(',',ID);
    if li > 0 then
      ID := Copy(ID,0,li-1);

    T_OP_Person.Items.Clear;
    T_OP_Person.Items.Add(ID);
    T_OP_Person.Text := Name;
  end;
end;


procedure TnewTestHistory_Frm.Button6Click(Sender: TObject);
begin
  Set_Test_History;
end;

procedure TnewTestHistory_Frm.Button7Click(Sender: TObject);
begin
  Initialize_;
end;

procedure TnewTestHistory_Frm.Button8Click(Sender: TObject);
var
  lProjNo : String;
  lTestDate : TDateTime;
begin
  lProjNo := FnewHistory.PROJNO;

  if not(lProjNo = '') then
  begin
    lTestDate := T_ST_TIME.DateTime;
    Show_Mounted_Grid(lProjNo,lTestDate);
  end;
end;

procedure TnewTestHistory_Frm.Button9Click(Sender: TObject);
begin
  try
    Initialize_;
  finally
    AdvPageControl2.ActivePageIndex := 1;
  end;
end;

function TnewTestHistory_Frm.Check_for_DateTime_In_opGrid(var aMsg:String) : Boolean;
var
  li,le : integer;

begin
  Result := True;
  with op_Grid do
  begin
    BeginUpdate;
    try

      if op_st_time.DateTime = op_end_time.DateTime then
      begin
        aMsg := aMsg + '시작시간과 종료시간이 같습니다!';
        Result := False;
        Exit;
      end;


      for li := 0 to RowCount-1 do
      begin
        if Cells[2,li] = FormatDateTime('YYYY-MM-DD HH:mm',op_st_time.DateTime) then
        begin
          aMsg := aMsg + '같은 시작 시간으로 등록된 정보가 있습니다.';
          Result := False;
          Exit;
        end;

        if Cells[3,li] = FormatDateTime('YYYY-MM-DD HH:mm',op_end_time.DateTime) then
        begin
          aMsg := aMsg + '같은 종료 시간으로 등록된 정보가 있습니다.';
          Result := False;
          Exit;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

function TnewTestHistory_Frm.Check_for_History: String;
var
  lResult : String;
begin
  lResult := '';
  try
    with FnewHistory do
    begin
      if PROJNO = '' then
        lResult := lResult + '엔진타입을 선택하여 주십시오!;';

      if TEST_SITE = 0 then
        lResult := lResult + '시험장소는 필수 입력 항목 입니다!;';

      if TEST_TYPE = 0 then
        lResult := lResult + '시험구분은 필수 입력 항목 입니다!;';

      T_TITLE      := Self.t_title.Text;
      T_REQ_DEPT   := Self.t_req_dept.Text;
      T_REQ_PERSON := Self.t_req_person.Text;

      T_PERSON     := '';
      if Self.T_PERSON.Items.Count > 0 then
        T_PERSON     := Self.T_Person.Items.Strings[0];

      T_OP_PERSON  := '';
      if Self.T_OP_PERSON.Items.Count > 0 then
        T_OP_PERSON  := Self.T_OP_PERSON.Items.Strings[0];

      T_ST_TIME    := Self.t_st_time.DateTime;
      T_END_TIME   := Self.t_end_time.DateTime;
      T_METHOD     := Self.t_method.Text;
      T_PURPOSE    := Self.t_purpose.Text;
    end;
  finally
    Result := lResult;
  end;
end;

procedure TnewTestHistory_Frm.Delete_all_Record(aTestNo:String);
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Delete From HIMSEN_ETH_OPERATING ' +
            'where TEST_NO = '+aTestNo);
    ExecSQL;
  end;

  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Delete From HIMSEN_ETH_FIE ' +
            'where TEST_NO = '+aTestNo);
    ExecSQL;
  end;

  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Delete From HIMSEN_ETH_USEDOIL ' +
            'where TEST_NO = '+aTestNo);
    ExecSQL;
  end;

  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Delete From HIMSEN_TEST_HISTORY ' +
            'where TEST_NO = '+aTestNo);
    ExecSQL;
  end;
end;

procedure TnewTestHistory_Frm.editTypeClick(Sender: TObject);
begin
  case editType.ItemIndex of
    0 : begin
          Button3.Caption := '이력등록';
          Button3.ImageIndex := 6;
          AdvPageControl2.Pages[1].Caption := '신규이력등록';

        end;
    1 : begin
          Button3.Caption := '이력수정';
          Button3.ImageIndex := 7;
          AdvPageControl2.Pages[1].Caption := '시험이력조회';
        end;
  end;

  AdvPageControl2.Invalidate;
end;

procedure TnewTestHistory_Frm.engTypeButtonDown(Sender: TObject);
var
  ltype : String;
begin
  with engType.Items do
  begin
    BeginUpdate;
    Clear;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from HIMSEN_ENG_LIST order by PROJNO ');
        Open;

        Add('');
        while not eof do
        begin
          lType := FieldByName('PROJNO').AsString +'-'+ FieldByName('ENGTYPE').AsString;
          Add(lType);
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TnewTestHistory_Frm.engTypeSelect(Sender: TObject);
var
  lProj : String;
  lpos : integer;
begin
  if not(engType.Text = '') then
  begin
    lpos := POS('-',engType.Text);

    if lpos > 0 then
    begin
      lProj := Copy(engType.Text,0,lpos-1);
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from HIMSEN_ENG_LIST ' +
                'where PROJNO = '''+lProj+''' ');
        Open;

        if not(RecordCount = 0) then
        begin
          FnewHistory.PROJNO := lProj;
          engType.Text := FieldByName('ENGTYPE').AsString;
          Set_FIE_Table(engType.Text);
        end;
      end;
    end;
  end;
end;

procedure TnewTestHistory_Frm.FormCreate(Sender: TObject);
begin
  Initialize_;
  Set_Test_History;
end;

procedure TnewTestHistory_Frm.Initialize_;
var
  li,le : integer;
begin
  AdvPageControl2.ActivePageIndex := 0; //Main
  AdvPageControl1.ActivePageIndex := 0; //Edit Page

  op_Grid.DoubleBuffered := False;
  listGrid.DoubleBuffered := False;

  FillChar(FnewHistory,SizeOf(FnewHistory),'');

  editType.ItemIndex := 0;

  //Search Page
  s_test_name.Items.Clear;
  s_test_name.Clear;

  s_st_time.DateTime := Now;
  s_end_time.DateTime := Now;

  s_site.Items.Clear;
  s_site.Clear;

  s_type.Items.Clear;
  s_type.Clear;

  //Edit Page
  engType.Clear;
  t_title.Clear;
  t_st_time.DateTime := Now;
  t_end_time.DateTime := Now;
  t_site.Clear;
  t_type.Clear;
  t_req_person.Clear;
  t_req_dept.Clear;
  t_person.Clear;
  t_op_person.Clear;
  t_method.Clear;
  t_purpose.Clear;

  op_load.Clear;
  op_st_time.DateTime := Now;
  op_end_time.DateTime := Now;
  op_amb_temp.Clear;
  op_amb_press.Clear;
  op_amb_hygro.Clear;
  op_fuel1.Clear;
  op_fuel2.Clear;

  while op_grid.RowCount > 0 do
    op_grid.DeleteRow(0);


  with op_fip do
  begin
    BeginUpdate;
    try
      for li := 1 to ColCount-1 do
        for le := 1 to 3 do
          Cells[li,le] := '';

    finally
      EndUpdate;
    end;
  end;

  with op_fiv do
  begin
    BeginUpdate;
    try
      for li := 1 to ColCount-1 do
        Cells[li,1] := '';

    finally
      EndUpdate;
    end;
  end;

  with oilGrid do
  begin
    BeginUpdate;
    try
      MergeCells(1,0,3,1);
      for li := 1 to 4 do
        for le := 1 to 10 do
          Cells[li,le] := '';

    finally
      EndUpdate;

    end;
  end;
end;

procedure TnewTestHistory_Frm.Insert_Into_HIMSEN_ETH_FIE(aTestNo,
  aProjNo: String);
var
  li,le : integer;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Insert Into HIMSEN_ETH_FIE ' +
            'Values(:TESTNO, :PROJNO, :ITEM, :CYLNUM, :VALUES_)');

    // FIP
    for li := 1 to 3 do
    begin
      for le := 1 to op_fip.ColCount-1 do
      begin
        ParamByName('TESTNO').AsFloat   := StrToFloat(aTestNo);
        ParamByName('PROJNO').AsString  := aProjNo;
        ParamByName('ITEM').AsString    := op_fip.Cells[0,li];
        ParamByName('CYLNUM').AsInteger := le;

        if not(op_fip.Cells[le,li] = '') then
          ParamByName('VALUES_').AsFloat   := StrToFloat(op_fip.Cells[le,li])
        else
          ParamByName('VALUES_').AsFloat   := 0;

        ExecSQL;
      end;
    end;

    // FIV
    for le := 1 to op_fiv.ColCount-1 do
    begin
      ParamByName('TESTNO').AsFloat   := StrToFloat(aTestNo);
      ParamByName('PROJNO').AsString  := aProjNo;
      ParamByName('ITEM').AsString    := op_fiv.Cells[0,1];
      ParamByName('CYLNUM').AsInteger := le;
      if not(op_fiv.Cells[le,1] = '') then
        ParamByName('VALUES_').AsFloat   := StrToFloat(op_fiv.Cells[le,1])
      else
        ParamByName('VALUES_').AsFloat   := 0;

      ExecSQL;
    end;
  end;
end;

procedure TnewTestHistory_Frm.Insert_Into_HIMSEN_ETH_OPERATING(aTestNo,
  aProjNo: String);
var
  li : integer;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Insert Into HIMSEN_ETH_OPERATING ' +
            'Values(:TESTNO, :PROJNO, :OP_LOAD, :OP_ST_TIME, :OP_END_TIME,' +
            ':AMB_TEMP, :AMB_PRESS, :AMB_HYGRO, :FUEL_W1, :FUEL_W2)');

    with op_grid do
    begin
      for li := 0 to RowCount-1 do
      begin
        ParamByName('TESTNO').AsFloat         := StrToFloat(aTestNo);
        ParamByName('PROJNO').AsString        := aProjNo;
        ParamByName('OP_LOAD').AsInteger      := Cell[1,li].AsInteger;
        ParamByName('OP_ST_TIME').AsDateTime  := Cell[2,li].AsDateTime;
        ParamByName('OP_END_TIME').AsDateTime := Cell[3,li].AsDateTime;

        if not(Cells[4,li] = '') then
          ParamByName('AMB_TEMP').AsFloat       := Cell[4,li].AsFloat;
        if not(Cells[5,li] = '') then
          ParamByName('AMB_PRESS').AsFloat      := Cell[5,li].AsFloat;
        if not(Cells[6,li] = '') then
          ParamByName('AMB_HYGRO').AsFloat      := Cell[6,li].AsFloat;
        if not(Cells[7,li] = '') then
          ParamByName('FUEL_W1').AsFloat        := Cell[7,li].AsFloat;
        if not(Cells[8,li] = '') then
          ParamByName('FUEL_W2').AsFloat        := Cell[8,li].AsFloat;
        ExecSQL;
      end;
    end;
  end;
end;

procedure TnewTestHistory_Frm.Insert_Into_HIMSEN_ETH_USEDOIL(aTestNo,
  aProjNo: String);
var
  li,le : integer;
  lCode : String;

begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Insert Into HIMSEN_ETH_USEDOIL ' +
            'Values(:TEST_NO, :PROJNO, '+
            ':NUM_OIL, :KIND_OIL, :GRAVITY, :FLASH, :VISCO50,' +
            ':VISCO40, :RECARBON, :ASH, :WATER, :SULFER,' +
            ':LCV, :NETCAL)');

    with oilGrid do
    begin
      for li := 1 to ColCount-1 do
      begin
        if not(Cells[li,1] = '') then
        begin
          lCode := Return_Code_(Cells[li,1]);
          if not(lCode = '') then
          begin
            ParamByName('TEST_NO').AsFloat := StrToFloat(aTestNo);
            ParamByName('PROJNO').AsString := aProjNo;

            ParamByName('NUM_OIL').AsInteger := li;
            ParamByName('KIND_OIL').AsFloat := StrToFloat(lCode);

            if not(Cells[li,2] = '') then
              ParamByName('GRAVITY').AsFloat := StrToFloat(Cells[li,2]);
            if not(Cells[li,3] = '') then
              ParamByName('FLASH').AsFloat := StrToFloat(Cells[li,3]);
            if not(Cells[li,4] = '') then
              ParamByName('VISCO50').AsFloat := StrToFloat(Cells[li,4]);

            if not(Cells[li,5] = '') then
              ParamByName('VISCO40').AsFloat := StrToFloat(Cells[li,5]);
            if not(Cells[li,6] = '') then
              ParamByName('RECARBON').AsFloat := StrToFloat(Cells[li,6]);
            if not(Cells[li,7] = '') then
              ParamByName('ASH').AsFloat := StrToFloat(Cells[li,7]);
            if not(Cells[li,8] = '') then
              ParamByName('WATER').AsFloat := StrToFloat(Cells[li,8]);
            if not(Cells[li,9] = '') then
              ParamByName('SULFER').AsFloat := StrToFloat(Cells[li,9]);

            if not(Cells[li,10] = '') then
              ParamByName('LCV').AsFloat := StrToFloat(Cells[li,10]);
            if not(Cells[li,11] = '') then
              ParamByName('NETCAL').AsFloat := StrToFloat(Cells[li,11]);

            ExecSQL;
          end;
        end;
      end;
    end;
  end;
end;

procedure TnewTestHistory_Frm.Insert_Into_HIMSEN_TEST_HISTORY;
begin
  with FnewHistory do
  begin
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Insert Into HIMSEN_TEST_HISTORY ' +
              'Values(:TESTNO, :PROJNO, :T_SITE, :T_TYPE, :T_TITLE, :T_ST_TIME, ' +
              ':T_END_TIME, :T_REQ_DEPT, :T_REQ_PERSON, :T_PERSON, :T_OP_PERSON, ' +
              ':T_METHOD, :T_PURPOSE, :REGID, :REGDATE, :MODID, :MODDATE)');

      ParamByName('TESTNO').AsFloat        := TEST_NO;
      ParamByName('PROJNO').AsString       := PROJNO;
      ParamByName('T_SITE').AsFloat        := TEST_SITE;
      ParamByName('T_TYPE').AsFloat        := TEST_TYPE;
      ParamByName('T_TITLE').AsString      := T_Title;
      ParamByName('T_ST_TIME').AsDateTime  := T_ST_TIME;

      ParamByName('T_END_TIME').AsDateTime := T_END_TIME;
      ParamByName('T_REQ_DEPT').AsString   := T_REQ_DEPT;
      ParamByName('T_REQ_PERSON').AsString := T_REQ_PERSON;
      ParamByName('T_PERSON').AsString     := T_PERSON;
      ParamByName('T_OP_PERSON').AsString  := T_OP_PERSON;

      ParamByName('T_METHOD').AsString     := T_METHOD;
      ParamByName('T_PURPOSE').AsString    := T_PURPOSE;
      ParamByName('REGID').AsString        := CurrentUsers;
      ParamByName('REGDATE').AsDateTime    := Now;
//      ParamByName('MODID').AsString := PROJNO;
//      ParamByName('MODDATE').AsDateTime := PROJNO;
      ExecSQL;
    end;
  end;
end;

procedure TnewTestHistory_Frm.Insert_Routine;
var
  lKey : String;
  lProjNo : String;
begin
  try
    lKey := IntToStr(DateTimeToMilliseconds(now));
    FnewHistory.TEST_NO := StrToFloat(lKey);
    lProjNo := FnewHistory.PROJNO;

    Insert_Into_HIMSEN_TEST_HISTORY;

    if op_grid.RowCount > 0 then
      Insert_Into_HIMSEN_ETH_OPERATING(lKey, FnewHistory.PROJNO);

    Insert_Into_HIMSEN_ETH_FIE(lKey, FnewHistory.PROJNO);
    Insert_Into_HIMSEN_ETH_USEDOIL(lKey, FnewHistory.PROJNO);

    editType.ItemIndex := 1;// 저장 완료 후 수정모드
    ShowMessage('시험이력등록 성공!');
  except
    Delete_all_Record(lKey);
  end;
end;

procedure TnewTestHistory_Frm.listGridDblClick(Sender: TObject);
var
  li : integer;
  lTestno, lprojno : String;

begin
  if listGrid.SelectedCount > 0 then
  begin
    lTestNo := listGrid.Cells[7,listGrid.SelectedRow];
    lProjNo := listGrid.Cells[8,listGrid.SelectedRow];

    FnewHistory.TEST_NO := StrToFloat(lTestNo);
    FnewHistory.PROJNO  := lProjNo;
    FnewHistory.TEST_SITE := StrToFloat(Return_Code_(listGrid.Cells[5,listGrid.SelectedRow]));
    FnewHistory.TEST_TYPE := StrToFloat(Return_Code_(listGrid.Cells[6,listGrid.SelectedRow]));

    editType.ItemIndex := 1;

    try
      engType.Text := listGrid.Cells[1,listGrid.SelectedRow];
      Set_FIE_Table(engType.Text);
      load_Data_Routine(lTestNo);
    finally
      AdvPageControl2.ActivePageIndex := 1;
    end;
  end;
end;

procedure TnewTestHistory_Frm.load_Data_Routine(aTestNo:String);
begin
  load_for_Test_History(aTestNo);

  load_for_Operating_Data(aTestNo);
  load_for_FIE_Data(aTestNo);
  load_for_ETH_UsedOil(aTestNo);
end;

procedure TnewTestHistory_Frm.load_for_ETH_UsedOil(aTestNo: String);
var
  li : integer;
  lCol : integer;
begin
  with oilGrid do
  begin
    BeginUpdate;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from HIMSEN_ETH_USEDOIL ' +
                'where TEST_NO = '+aTestNo+
                ' order by NUM_OIL');
        Open;

        if not(RecordCount = 0) then
        begin
          while not eof do
          begin
            lCol := FieldByName('NUM_OIL').AsInteger;

            Cells[lCol,1] := Return_Code_Name(FieldByName('KIND_OIL').AsFloat);
            Cells[lCol,2] := FieldByName('GRAVITY').AsString;
            Cells[lCol,3] := FieldByName('FLASH').AsString;
            Cells[lCol,4] := FieldByName('VISCO50').AsString;
            Cells[lCol,5] := FieldByName('VISCO40').AsString;
            Cells[lCol,6] := FieldByName('RECARBON').AsString;
            Cells[lCol,7] := FieldByName('ASH').AsString;
            Cells[lCol,8] := FieldByName('WATER').AsString;
            Cells[lCol,9] := FieldByName('SULFER').AsString;
            Cells[lCol,10] := FieldByName('LCV').AsString;
            Cells[lCol,11] := FieldByName('NETCAL').AsString;
            Next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TnewTestHistory_Frm.load_for_FIE_Data(aTestNo: String);
var
  li,le : integer;
begin
  with op_fip do
  begin
    BeginUpdate;
    try
      for li := 1 to 3 do
      begin
        with DM1.OraQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('select * from HIMSEN_ETH_FIE ' +
                  'where TEST_NO = '+aTestNo+
                  ' and ITEM = '''+Cells[0,li]+''' '+
                  ' order by ITEM, CYLNUM');
          Open;

          if not(RecordCount = 0) then
          begin
            for le := 0 to RecordCount-1 do
            begin
              Cells[le+1,li] := Fieldbyname('Values_').AsString;
              Next;
            end;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;

  with op_fiv do
  begin
    BeginUpdate;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from HIMSEN_ETH_FIE ' +
                'where TEST_NO = '+aTestNo+
                ' and ITEM = '''+Cells[0,1]+''' '+
                ' order by ITEM, CYLNUM');
        Open;

        if not(RecordCount = 0) then
        begin
          for le := 0 to RecordCount-1 do
          begin
            Cells[le+1,1] := Fieldbyname('Values_').AsString;
            Next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TnewTestHistory_Frm.load_for_Operating_Data(aTestNo: String);
var
  li : integer;
begin
  with op_Grid do
  begin
    BeginUpdate;
    try
      ClearRows;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from HIMSEN_ETH_OPERATING '+
                'where TEST_NO = '+aTestNo+
                ' order by OP_ST_TIME');
        Open;

        if not(RecordCount = 0) then
        begin
          while not eof do
          begin
            AddRow;
            Cells[1,RowCount-1] := FieldByName('OP_LOAD').AsString;
            Cells[2,RowCount-1] := FormatDateTime('YYYY-MM-DD HH:mm',FieldByName('OP_ST_TIME').AsDateTime);
            Cells[3,RowCount-1] := FormatDateTime('YYYY-MM-DD HH:mm',FieldByName('OP_END_TIME').AsDateTime);
            Cells[4,RowCount-1] := FieldByName('AMB_TEMP').AsString;
            Cells[5,RowCount-1] := FieldByName('AMB_PRESS').AsString;
            Cells[6,RowCount-1] := FieldByName('AMB_HYGRO').AsString;
            Cells[7,RowCount-1] := FieldByName('FUEL_W1').AsString;
            Cells[8,RowCount-1] := FieldByName('FUEL_W2').AsString;
            Next;

          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TnewTestHistory_Frm.load_for_Test_History(aTestNo: String);
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HIMSEN_TEST_HISTORY ' +
            'where TEST_NO = '+aTestNo);
    Open;

    if not(RecordCount = 0) then
    begin
      t_title.Text := FieldByName('T_TITLE').AsString;
      t_st_time.DateTime := FieldByName('T_ST_TIME').AsDateTime;
      t_end_time.DateTime := FieldByName('T_END_TIME').AsDateTime;
      t_site.Text := Return_Code_Name(FieldByName('T_SITE').AsFloat);
      t_type.Text := Return_Code_Name(FieldByName('T_TYPE').AsFloat);
      t_req_dept.Text := FieldByName('T_REQ_DEPT').AsString;
      t_req_person.Text := FieldByName('T_REQ_PERSON').AsString;

      t_person.Items.Add(FieldByName('T_PERSON').AsString);
      t_person.Text := Return_name(FieldByName('T_PERSON').AsString);

      t_op_person.Items.Add(FieldByName('T_OP_PERSON').AsString);
      t_op_person.Text := Return_name(FieldByName('T_OP_PERSON').AsString);

      t_method.Text := FieldByName('T_METHOD').AsString;
      t_purpose.Text := FieldByName('T_PURPOSE').AsString;

    end;
  end;
end;

procedure TnewTestHistory_Frm.s_engtypeButtonDown(Sender: TObject);
var
  ltype : String;
begin
  with s_engType.Items do
  begin
    BeginUpdate;
    Clear;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select Distinct(A.PROJNO), B.ENGTYPE ' +
                'from HIMSEN_TEST_HISTORY A, HIMSEN_ENG_LIST B ' +
                'where A.ProjNo = B.ProjNo ' +
                'order by ProjNo');

        Open;

        Add('');
        while not eof do
        begin
          lType := FieldByName('PROJNO').AsString +'-'+ FieldByName('ENGTYPE').AsString;
          Add(lType);
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TnewTestHistory_Frm.s_engtypeSelect(Sender: TObject);
var
  lProj : String;
  lpos : integer;
begin
  if not(s_engType.Text = '') then
  begin
    lpos := POS('-',s_engType.Text);
    if lpos > 0 then
    begin
      lProj := Copy(s_engType.Text,0,lpos-1);
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from HIMSEN_ENG_LIST ' +
                'where PROJNO = '''+lProj+''' ');
        Open;

        if not(RecordCount = 0) then
        begin
          FnewHistory.PROJNO := lProj;
          s_engType.Text := FieldByName('ENGTYPE').AsString;
        end;
      end;
    end;
  end;
end;

procedure TnewTestHistory_Frm.OILGRIDCanEditCell(Sender: TObject; ARow,
  ACol: Integer; var CanEdit: Boolean);
begin
  if (ACol > 0) and (ARow > 0) then
    CanEdit := True;

end;

procedure TnewTestHistory_Frm.OILGRIDGetEditorProp(Sender: TObject; ACol,
  ARow: Integer; AEditLink: TEditLink);
var
  lRoot : String;
begin
  if (ARow > 0) and (ACol > 0) then
  begin
    with oilgrid do
    begin
      BeginUpdate;
      try
        case ACol of
          1..3 : lRoot := '63482624850265';
          4    : lRoot := '63482624861906';
        end;

        ClearComboString;

        with DM1.OraQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('select * from HITEMS_CODE_GROUP_V ' +
                  'where CDGRP = '+lRoot+' '+
                  'order by sortno');
          Open;

          while not eof do
          begin
            AddComboString(FieldByName('CODENAME').AsString);
            Next;
          end;
        end;
      finally
        EndUpdate;
      end;
    end;
  end;
end;

procedure TnewTestHistory_Frm.OILGRIDGetEditorType(Sender: TObject; ACol,
  ARow: Integer; var AEditor: TEditorType);
begin
  if (ACol > 0) and (ARow > 0)then
  begin
    if not(ARow > 1) then
    begin
      AEditor := edComboEdit;
      oilGrid.Combobox.ButtonWidth := 23;
    end
    else
      AEditor := edFloat;
  end;
end;

procedure TnewTestHistory_Frm.OILGRIDKeyPress(Sender: TObject; var Key: Char);
var
  lRow,lCol : Integer;
  lNext : Integer;
begin
  if (key = #$D) then
  begin
    lRow := FxRow;
    lCol := FxCol;
    with oilGrid do
    begin
      if (lRow > 0) and (lCol > 0) then
      begin
        lRow := lRow+1;
        if lRow > RowCount-1 then
        begin
          lRow := 1;
          lCol := lCol+1;

          if lCol > ColCount-1 then
            lCol := 1;
        end;
        SelectRange(lCol,lCol,lRow,lRow);
        SetFocus;
      end;
    end;
  end;
end;

procedure TnewTestHistory_Frm.OILGRIDSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  FxRow := ARow;
  FxCol := ACol;
end;

procedure TnewTestHistory_Frm.op_end_timeCloseUp(Sender: TObject);
begin
  if op_st_time.DateTime > op_end_time.DateTime then
  begin
    op_end_time.DateTime := op_st_time.DateTime+1;
    ShowMessage('선택한 종료 일시가 시작일시보다 작습니다.');
  end;
end;

procedure TnewTestHistory_Frm.op_fipCanEditCell(Sender: TObject; ARow,
  ACol: Integer; var CanEdit: Boolean);
begin
  if (ARow > 0) and (ACol > 0) then
    CanEdit := True
  else
    CanEdit := False;
end;

procedure TnewTestHistory_Frm.op_fipGetEditorType(Sender: TObject; ACol,
  ARow: Integer; var AEditor: TEditorType);
begin
  if (ACol > 0) and (ARow > 0) then
    AEditor := edFloat;
end;

procedure TnewTestHistory_Frm.op_fipKeyPress(Sender: TObject; var Key: Char);
var
  lRow,lCol : Integer;
  lNext : Integer;
begin
  if key = #$D then
  begin
    lRow := FxRow;
    lCol := FxCol;
    with op_fip do
    begin
      if (lRow > 0) and (lCol > 0) then
      begin
        lCol := lCol+1;
        if lCol > ColCount-1 then
        begin
          lCol := 1;
          lRow := lRow+1;

          if lRow > RowCount-1 then
            lRow := 1;
        end;
        SelectRange(lCol,lCol,lRow,lRow);
        SetFocus;
      end;
    end;
  end;
end;


procedure TnewTestHistory_Frm.op_fipSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  FxRow := ARow;
  FxCol := ACol;
end;

procedure TnewTestHistory_Frm.op_fivCanEditCell(Sender: TObject; ARow,
  ACol: Integer; var CanEdit: Boolean);
begin
  if (ARow > 0) and (ACol > 0) then
    CanEdit := True
  else
    CanEdit := False;
end;

procedure TnewTestHistory_Frm.op_fivGetEditorType(Sender: TObject; ACol,
  ARow: Integer; var AEditor: TEditorType);
begin
  if (ACol > 0) and (ARow > 0) then
    AEditor := edFloat;
end;

procedure TnewTestHistory_Frm.op_fivKeyPress(Sender: TObject; var Key: Char);
var
  lRow,lCol : Integer;
  lNext : Integer;
begin
  if key = #$D then
  begin
    lRow := FxRow;
    lCol := FxCol;
    with op_fiv do
    begin
      if (lRow > 0) and (lCol > 0) then
      begin
        lCol := lCol+1;
        if lCol > ColCount-1 then
        begin
          lCol := 1;
          lRow := lRow+1;

          if lRow > RowCount-1 then
            lRow := 1;
        end;
        SelectRange(lCol,lCol,lRow,lRow);
        SetFocus;
      end;
    end;
  end;
end;

procedure TnewTestHistory_Frm.op_fivSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  FxRow := ARow;
  FxCol := ACol;
end;

procedure TnewTestHistory_Frm.op_gridDblClick(Sender: TObject);
begin
  with op_Grid do
  begin
    op_load.Text           := Cells[1,SelectedRow];
    op_st_time.DateTime    := Cell[2,SelectedRow].AsDateTime;
    op_end_time.DateTime   := Cell[3,SelectedRow].AsDateTime;
    op_amb_temp.Text       := Cells[4,SelectedRow];
    op_amb_press.Text      := Cells[5,SelectedRow];
    op_amb_hygro.Text      := Cells[6,SelectedRow];
    op_fuel1.Text          := Cells[7,SelectedRow];
    op_fuel2.Text          := Cells[8,SelectedRow];
  end;
end;

procedure TnewTestHistory_Frm.op_loadButtonDown(Sender: TObject);
var
  li : integer;
begin
  op_load.Items.Clear;
  op_Load.Items.Add(IntToStr(10));
  li := 10;
  while li < 110 do
  begin
    li := li+5;
    op_load.Items.Add(IntToStr(li));
  end;
end;

procedure TnewTestHistory_Frm.op_st_timeCloseUp(Sender: TObject);
begin
  if op_st_time.DateTime > op_end_time.DateTime then
  begin
    Op_st_time.DateTime := op_end_time.DateTime-1;

    ShowMessage('선택한 시작 일시가 종료일시보다 큽니다.');
  end;
end;

function TnewTestHistory_Frm.Return_Code_(aCodeName: String): String;
var
  OraQuery : TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.OraSession1;
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select CODE from HITEMS_CODE ' +
              'where CODENAME = :param1');
      ParamByName('param1').AsString := aCodeName;
      Open;

      if not(RecordCount = 0) then
        Result := FieldByName('CODE').AsString
      else
        Result := '';
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

function TnewTestHistory_Frm.Return_Code_Name(aCode: Double): String;
var
  OraQuery : TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.OraSession1;
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select CODENAME from HITEMS_CODE ' +
              'where CODE = :param1');
      ParamByName('param1').AsFloat := aCode;
      Open;

      if not(RecordCount = 0) then
        Result := FieldByName('CODENAME').AsString
      else
        Result := '';
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

function TnewTestHistory_Frm.Return_name(aUserID: String): String;
var
  OraQuery : TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.OraSession1;
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select Name_Kor from User_Info '+
              'where USERID = '''+aUserID+''' ');
      Open;

      if not(RecordCount = 0) then
        Result := FieldByName('Name_Kor').AsString
      else
        Result := '';
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure TnewTestHistory_Frm.Set_FIE_Table(aEngType:String);
var
  lpos,
  li,lt : integer;
  lstr : String;
begin
  lpos := POS('H',aEngType);

  if lpos > 0 then
  begin
    lstr := Copy(aEngType, 0, lpos-1);
    lt := StrToInt(lstr);

    with op_fip do
    begin
      BeginUpdate;
      try
        ColCount := lt+1;

        DefaultColWidth := 80;
        FixedColWidth := 120;

        for li := 0 to lt-1 do
          Cells[1+li,0] := 'Cylinder#'+IntToStr(li+1);
      finally
        EndUpdate;
      end;
    end;

    with op_fiv do
    begin
      BeginUpdate;
      try
        ColCount := lt+1;

        DefaultColWidth := 80;
        FixedColWidth := 120;

        for li := 0 to lt-1 do
          Cells[1+li,0] := 'Cylinder#'+IntToStr(li+1);
      finally
        EndUpdate;
      end;
    end;
  end;
end;

procedure TnewTestHistory_Frm.Set_Test_History;
begin
  with listGrid do
  begin
    BeginUpdate;
    try
      AutoSize := False;
      ClearRows;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select A.EngType, B.* from HIMSEN_ENG_LIST A, HIMSEN_TEST_HISTORY B ' +
                'where A.PROJNO = B.PROJNO order by B.T_ST_TIME');
        Open;

        while not eof do
        begin
          AddRow;
          Cells[1,RowCount-1] := FieldByName('ENGTYPE').AsString;
          Cells[2,RowCount-1] := FieldByName('T_TITLE').AsString;
          Cells[3,RowCount-1] := FormatDateTime('YYYY-MM-DD HH:mm',FieldByName('T_ST_TIME').AsDateTime);
          Cells[4,RowCount-1] := FormatDateTime('YYYY-MM-DD HH:mm',FieldByName('T_END_TIME').AsDateTime);
          Cells[5,RowCount-1] := Return_Code_Name(FieldByName('T_SITE').AsFloat);
          Cells[6,RowCount-1] := Return_Code_Name(FieldByName('T_TYPE').AsFloat);
          Cells[7,RowCount-1] := FieldByName('TEST_NO').AsString;
          Cells[8,RowCount-1] := FieldByName('PROJNO').AsString;
          Next;
        end;
      end;
    finally
      AutoSize := True;
      EndUpdate;
    end;
  end;
end;

procedure TnewTestHistory_Frm.Show_History_by_Conditions;
var
  lConditonCnt : Integer;
  lCheck : String;
begin
  with listGrid do
  begin
    BeginUpdate;
    try
      AutoSize := False;
      ClearRows;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select A.EngType, B.* from HIMSEN_ENG_LIST A, HIMSEN_TEST_HISTORY B ' +
                'where A.PROJNO = B.PROJNO ');

        if not(s_engType.Text = '') then
          SQL.Add(' and A.ProjNo = '''+FnewHistory.PROJNO+''' ');


        if not(s_test_name.Text = '') then
          SQL.Add(' and T_TITLE = '''+s_test_name.Text+''' ');

        if CheckBox1.Checked = True then
        begin
          SQL.Add(' and T_ST_TIME >= :param1 ');
          ParamByName('param1').AsDateTime := s_st_time.DateTime;
        end;

        if CheckBox2.Checked = True then
        begin
          SQL.Add(' and T_END_TIME <= :param2 ');
          ParamByName('param2').AsDateTime := s_end_time.DateTime;
        end;

        if not(s_site.Text = '') then
          SQL.Add(' and T_SITE = '+Return_Code_(s_site.Text));

        if not(s_type.Text = '') then
          SQL.Add(' and T_Type = '+Return_Code_(s_type.Text));

        SQL.Add('order by T_ST_TIME');

        Open;

        while not eof do
        begin
          AddRow;
          Cells[1,RowCount-1] := FieldByName('ENGTYPE').AsString;
          Cells[2,RowCount-1] := FieldByName('T_TITLE').AsString;
          Cells[3,RowCount-1] := FormatDateTime('YYYY-MM-DD HH:mm',FieldByName('T_ST_TIME').AsDateTime);
          Cells[4,RowCount-1] := FormatDateTime('YYYY-MM-DD HH:mm',FieldByName('T_END_TIME').AsDateTime);
          Cells[5,RowCount-1] := Return_Code_Name(FieldByName('T_SITE').AsFloat);
          Cells[6,RowCount-1] := Return_Code_Name(FieldByName('T_TYPE').AsFloat);
          Cells[7,RowCount-1] := FieldByName('TEST_NO').AsString;
          Cells[8,RowCount-1] := FieldByName('PROJNO').AsString;
          Next;
        end;
      end;
    finally
      AutoSize := True;
      EndUpdate;
    end;
  end;
end;

procedure TnewTestHistory_Frm.s_search_btnClick(Sender: TObject);
begin
  Show_History_by_Conditions;
end;

procedure TnewTestHistory_Frm.s_siteButtonDown(Sender: TObject);
begin
  with s_site.Items do
  begin
    BeginUpdate;
    try
      Clear;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from HITEMS_CODE_GROUP_V ' +
                'where CDGRP = 63482624794234 ' +
                'order by SORTNO');
        Open;

        Add('');
        while not eof do
        begin
          Add(FieldByName('CODENAME').AsString);
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TnewTestHistory_Frm.s_test_nameButtonDown(Sender: TObject);
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select Distinct(T_TITLE), T_ST_TIME from HIMSEN_TEST_HISTORY ' +
            'order by T_ST_TIME');
    Open;

    with s_test_name.Items do
    begin
      BeginUpdate;
      try
        Clear;
        Add('');
        while not eof do
        begin
          Add(FieldByName('T_TITLE').AsString);
          Next;
        end;
      finally
        s_test_name.Items.EndUpdate;
      end;
    end;
  end;
end;

procedure TnewTestHistory_Frm.s_typeButtonDown(Sender: TObject);
begin
  with s_type.Items do
  begin
    BeginUpdate;
    try
      Clear;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from HITEMS_CODE_GROUP_V ' +
                'where CDGRP = 63482624767656 ' +
                'order by SORTNO');
        Open;

        Add('');
        while not eof do
        begin
          Add(FieldByName('CODENAME').AsString);
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TnewTestHistory_Frm.t_end_timeChange(Sender: TObject);
begin
  if T_ST_Time.DateTime > t_end_time.DateTime then
  begin
    t_end_time.DateTime := t_st_time.DateTime + 0.04166666666667;
    ShowMessage('선택한 종료 일시가 시작일시보다 작습니다.');
  end;
end;

procedure TnewTestHistory_Frm.T_PersonKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  T_Person.Items.Clear;
  T_Person.Clear;
  Exit;
end;

procedure TnewTestHistory_Frm.t_siteButtonDown(Sender: TObject);
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
        SQL.Add('select * from HITEMS_CODE_GROUP_V ' +
                'where CDGRP = 63482624794234 ' +
                'order by SORTNO');
        Open;

        Add('');
        while not eof do
        begin
          Add(FieldByName('CODENAME').AsString);
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
  lCdNm,
  lCode : String;
begin
  lCdNm := t_site.Text;

  if not(lCdNm = '') then
  begin
    lCode := Return_Code_(lCdNm);
    t_site.Clear;
    t_site.Items.Clear;
    if not(lCode = '') then
    begin
      FnewHistory.TEST_SITE := StrToFloat(lCode);
      t_site.Text := lcdnm;
    end;
  end;
end;

procedure TnewTestHistory_Frm.t_st_timeChange(Sender: TObject);
begin
  if T_ST_Time.DateTime > t_end_time.DateTime then
  begin
    T_ST_Time.DateTime := t_end_time.DateTime - 0.04166666666667;
    ShowMessage('선택한 시작 일시가 종료일시보다 큽니다.');
  end;

  OP_ST_Time.DateTime := T_ST_Time.DateTime;
  OP_End_Time.DateTime := T_End_Time.DateTime;
end;

procedure TnewTestHistory_Frm.t_typeButtonDown(Sender: TObject);
begin
  with t_type.Items do
  begin
    BeginUpdate;
    try
      Clear;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from HITEMS_CODE_GROUP_V ' +
                'where CDGRP = 63482624767656 ' +
                'order by SORTNO');
        Open;

        Add('');
        while not eof do
        begin
          Add(FieldByName('CODENAME').AsString);
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TnewTestHistory_Frm.t_typeSelect(Sender: TObject);
var
  lCdNm,
  lCode : String;
begin
  lCdNm := t_type.Text;

  if not(lCdNm = '') then
  begin
    lCode := Return_Code_(lCdNm);
    t_type.Clear;
    t_type.Items.Clear;
    if not(lCode = '') then
    begin
      FnewHistory.TEST_TYPE := StrToFloat(lCode);
      t_type.Text := lcdnm;
    end;
  end;
end;

procedure TnewTestHistory_Frm.Update_HIMSEN_ETH_FIE(aTestNo:String;aProjNo:String);
var
  lResult : Boolean;
  lTestNo, lProjNo : String;
begin
  lResult := False;
  try
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Delete From HIMSEN_ETH_FIE ' +
              'where TEST_NO = '+aTestNo);
      ExecSQL;
      lResult := True;
    end;
  finally
    if lResult = True then
    begin
      Insert_Into_HIMSEN_ETH_FIE(aTestNo,aProjNo);
    end;
  end;
end;

procedure TnewTestHistory_Frm.Update_HIMSEN_ETH_OPERATING(aTestNo:String;aProjNo:String);
var
  lResult : Boolean;
begin
  lResult := False;
  try
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Delete From HIMSEN_ETH_OPERATING ' +
              'where TEST_NO = '+aTestNo);
      ExecSQL;
      lResult := True;
    end;
  finally
    if lResult = True then
    begin
      Insert_Into_HIMSEN_ETH_OPERATING(aTestNo,aProjNo);
    end;
  end;
end;

procedure TnewTestHistory_Frm.Update_HIMSEN_ETH_USEDOIL(aTestNo:String;aProjNo:String);
var
  lResult : Boolean;
  lTestNo, lProjNo : String;
begin
  lResult := False;
  try
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Delete From HIMSEN_ETH_USEDOIL ' +
              'where TEST_NO = '+aTestNo);
      ExecSQL;
      lResult := True;
    end;
  finally
    if lResult = True then
    begin
      Insert_Into_HIMSEN_ETH_USEDOIL(aTestNo,aProjNo);
    end;
  end;
end;

procedure TnewTestHistory_Frm.Update_HIMSEN_TEST_HISTORY;
begin
  with FnewHistory do
  begin
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Update HIMSEN_TEST_HISTORY Set ' +
              'PROJNO = :PROJNO, T_SITE = :T_SITE, T_TYPE = :T_TYPE,'+
               'T_TITLE = :T_TITLE, T_ST_TIME = :T_ST_TIME, T_END_TIME = :T_END_TIME, ' +
               'T_REQ_DEPT = :T_REQ_DEPT, T_REQ_PERSON = :T_REQ_PERSON, T_PERSON = :T_PERSON, ' +
               'T_OP_PERSON = :T_OP_PERSON, T_METHOD = :T_METHOD, T_PURPOSE = :T_PURPOSE, ' +
               'MODID = :MODID, MODDATE = :MODDATE ' +
               'where TEST_NO = :param1');

      ParamByName('param1').AsFloat := TEST_NO;

      ParamByName('PROJNO').AsString       := PROJNO;
      ParamByName('T_SITE').AsFloat        := TEST_SITE;
      ParamByName('T_TYPE').AsFloat        := TEST_TYPE;
      ParamByName('T_TITLE').AsString      := T_Title;
      ParamByName('T_ST_TIME').AsDateTime  := T_ST_TIME;

      ParamByName('T_END_TIME').AsDateTime := T_END_TIME;
      ParamByName('T_REQ_DEPT').AsString   := T_REQ_DEPT;
      ParamByName('T_REQ_PERSON').AsString := T_REQ_PERSON;
      ParamByName('T_PERSON').AsString     := T_PERSON;
      ParamByName('T_OP_PERSON').AsString  := T_OP_PERSON;

      ParamByName('T_METHOD').AsString     := T_METHOD;
      ParamByName('T_PURPOSE').AsString    := T_PURPOSE;
//      ParamByName('REGID').AsString        := CurrentUsers;
//      ParamByName('REGDATE').AsDateTime    := Now;
      ParamByName('MODID').AsString := CurrentUsers;
      ParamByName('MODDATE').AsDateTime := Now;
      ExecSQL;
    end;
  end;
end;

procedure TnewTestHistory_Frm.Update_Routine;
var
  lKey : String;
  lProjNo : String;
begin
  lKey := FloatToStr(FnewHistory.TEST_NO);
  lProjNo := FnewHistory.PROJNO;

  if editType.ItemIndex = 1 then
  begin

    Update_HIMSEN_TEST_HISTORY;

    Update_HIMSEN_ETH_OPERATING(lKey,lProjNo);
    Update_HIMSEN_ETH_FIE(lKey,lProjNo);
    Update_HIMSEN_ETH_USEDOIL(lKey,lProjNo);
  end;
  ShowMessage('시험이력수정 성공!');
end;

end.
