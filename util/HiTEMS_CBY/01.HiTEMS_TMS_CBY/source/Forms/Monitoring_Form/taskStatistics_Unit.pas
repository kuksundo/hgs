unit taskStatistics_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.StdCtrls, AeroButtons, Vcl.ComCtrls, AdvGroupBox, AdvOfficeButtons,
  JvExControls, JvLabel, CurvyControls, DateUtils, StrUtils, NxScrollControl,
  NxCustomGridControl, NxCustomGrid, NxGrid, NxColumnClasses, NxColumns, NxEdit,
  AdvCircularProgress, AdvTreeComboBox, System.Generics.Collections, Ora;


type
  TtaskStatistics_Frm = class(TForm)
    Panel5: TPanel;
    Image1: TImage;
    CurvyPanel1: TCurvyPanel;
    JvLabel2: TJvLabel;
    JvLabel4: TJvLabel;
    JvLabel5: TJvLabel;
    JvLabel6: TJvLabel;
    JvLabel1: TJvLabel;
    CurvyPanel2: TCurvyPanel;
    Label4: TLabel;
    rg_period: TAdvOfficeRadioGroup;
    dt_begin: TDateTimePicker;
    dt_end: TDateTimePicker;
    cb_engType: TComboBox;
    cb_engProjNo: TComboBox;
    AeroButton2: TAeroButton;
    btn_search: TAeroButton;
    cb_team: TComboBox;
    JvLabel3: TJvLabel;
    cb_user: TComboBox;
    grid_PlanCode: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    NxNumberColumn1: TNxNumberColumn;
    JvLabel8: TJvLabel;
    JvLabel9: TJvLabel;
    grid_rstCode: TNextGrid;
    NxIncrementColumn2: TNxIncrementColumn;
    NxTextColumn4: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    NxNumberColumn2: TNxNumberColumn;
    JvLabel10: TJvLabel;
    JvLabel11: TJvLabel;
    JvLabel12: TJvLabel;
    JvLabel13: TJvLabel;
    JvLabel14: TJvLabel;
    JvLabel7: TJvLabel;
    et_Cost: TEdit;
    cb_engModel: TComboBox;
    NxTextColumn3: TNxNumberColumn;
    NxTextColumn6: TNxNumberColumn;
    grid_User: TNextGrid;
    NxIncrementColumn3: TNxIncrementColumn;
    NxTextColumn7: TNxTextColumn;
    NxTextColumn8: TNxTextColumn;
    NxNumberColumn3: TNxNumberColumn;
    NxNumberColumn8: TNxNumberColumn;
    grid_Plan: TNextGrid;
    NxIncrementColumn4: TNxIncrementColumn;
    NxTextColumn9: TNxTextColumn;
    NxTextColumn10: TNxTextColumn;
    NxNumberColumn4: TNxNumberColumn;
    NxNumberColumn9: TNxNumberColumn;
    grid_Model: TNextGrid;
    NxIncrementColumn5: TNxIncrementColumn;
    NxTextColumn11: TNxTextColumn;
    NxTextColumn12: TNxTextColumn;
    NxNumberColumn5: TNxNumberColumn;
    NxNumberColumn10: TNxNumberColumn;
    grid_Type: TNextGrid;
    NxIncrementColumn6: TNxIncrementColumn;
    NxTextColumn13: TNxTextColumn;
    NxTextColumn14: TNxTextColumn;
    NxNumberColumn6: TNxNumberColumn;
    NxNumberColumn11: TNxNumberColumn;
    grid_Proj: TNextGrid;
    NxIncrementColumn7: TNxIncrementColumn;
    NxTextColumn15: TNxTextColumn;
    NxTextColumn16: TNxTextColumn;
    NxNumberColumn7: TNxNumberColumn;
    NxNumberColumn12: TNxNumberColumn;
    et_totalMh: TEdit;
    JvLabel15: TJvLabel;
    et_taskName: TEdit;
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    procedure rg_periodClick(Sender: TObject);
    procedure cb_engModelDropDown(Sender: TObject);
    procedure cb_engTypeDropDown(Sender: TObject);
    procedure cb_engProjNoDropDown(Sender: TObject);
    procedure cb_teamDropDown(Sender: TObject);
    procedure cb_teamSelect(Sender: TObject);
    procedure cb_userDropDown(Sender: TObject);
    procedure cb_userSelect(Sender: TObject);
    procedure btn_searchClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure AeroButton2Click(Sender: TObject);
    procedure JvLabel7Click(Sender: TObject);
    procedure et_totalmhChange(Sender: TObject);
    procedure grid_PlanCodeCellColoring(Sender: TObject; ACol, ARow: Integer;
      var CellColor, GridColor: TColor; CellState: TCellState);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    FtaskDic : TDictionary<String,TTreeNode>;
  public
    { Public declarations }
    function Get_TaskName(aTaskNo:String):String;

    procedure Get_ResultOfPlanCode;
    procedure Get_ResultOfResultCode;
    procedure Get_ResultOfUser;
    procedure Get_ResultOfPlanName;
    procedure Get_ResultOfHimsenModel;
    procedure Get_ResultOfHimsenType;
    procedure Get_ResultOfHimsenProj;
  end;

var
  taskStatistics_Frm: TtaskStatistics_Frm;

implementation
uses
  chooseTask_Unit,
  statisticsChart_Unit,
  taskMain_Unit,
  HiTEMS_TMS_CONST,
  HiTEMS_TMS_COMMON,
  CommonUtil_Unit,
  DataModule_Unit;

{$R *.dfm}

procedure TtaskStatistics_Frm.AeroButton2Click(Sender: TObject);
begin
  Close;
end;

procedure TtaskStatistics_Frm.btn_searchClick(Sender: TObject);
begin
  btn_search.Enabled := False;
  try

    Get_ResultOfPlanCode;
    Get_ResultOfResultCode;
    Get_ResultOfUser;
    Get_ResultOfPlanName;
    Get_ResultOfHimsenModel;
    Get_ResultOfHimsenType;
    Get_ResultOfHimsenProj;
  finally
    btn_search.Enabled := True;
  end;
end;

procedure TtaskStatistics_Frm.Button1Click(Sender: TObject);
var
  OraQuery : TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.OraSession1;
    OraQuery.FetchAll := True;
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM ' +
              '( ' +
              '   SELECT A.TASK_NO, TASK_PRT, TASK_ORDER, TASK_NAME, ' +
              '   ''T'' TYPE FROM TMS_TASK A, TMS_TASK_SHARE B ' +
              '   WHERE A.TASK_NO = B.TASK_NO ' +
              '   AND B.TASK_TEAM LIKE :DEPT_CD ' +
              '   AND  ' +
              '   ( ' +
              '     ( ' +
              '       TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :beginDate  ' +
              '       AND EXD_TASK_END >= TO_DATE(:beginDate, ''yyyy-mm-dd'')  ' +
              '       AND TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :endDate  ' +
              '       AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') <= :endDate   ' +
              '       OR EXD_TASK_START >= TO_DATE(:beginDate, ''yyyy-mm-dd'')  ' +
              '       AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') >= :beginDate ' +
              '       AND TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :endDate ' +
              '       AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') <= :endDate  ' +
              '       OR TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') >= :beginDate  ' +
              '       AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') >= :beginDate   ' +
              '       AND TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :endDate   ' +
              '       AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') >= :endDate  ' +
              '       OR TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :beginDate  ' +
              '       AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') >= :beginDate  ' +
              '       AND TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :endDate  ' +
              '       AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') >= :endDate ' +
              '     ) OR  ' +
              '     ( ' +
              '       (EXD_TASK_START IS NULL) OR (EXD_TASK_END IS NULL) ' +
              '     ) ' +
              '   ) UNION ' +
              '   SELECT PLAN_NO, TASK_NO, PRN, PLAN_NAME, ''P'' TYPE FROM ' +
              '   ( ' +
              '       SELECT A.PLAN_NO, TASK_NO, A.PRN, PLAN_NAME, ENG_MODEL, ' +
              '       ENG_TYPE, ENG_PROJNO, PLAN_EMPNO, PLAN_TEAM, PLAN_START, PLAN_END ' +
              '       FROM ' +
              '       (             ' +
              '           SELECT A.PLAN_NO, PRN, TASK_NO, PLAN_CODE, PLAN_TYPE, ' +
              '           PLAN_NAME, ENG_MODEL, ENG_TYPE, ENG_PROJNO, PLAN_DRAFTER, PLAN_START, PLAN_END ' +
              '           FROM ' +
              '           ( ' +
              '               SELECT PLAN_NO, MAX(PLAN_REV_NO) PRN FROM TMS_PLAN GROUP BY PLAN_NO ' +
              '           ) A JOIN  ' +
              '           ( ' +
              '               SELECT * FROM TMS_PLAN ' +
              '           )B ' +
              '           ON A.PLAN_NO = B.PLAN_NO ' +
              '           AND A.PRN = B.PLAN_REV_NO ' +
              '           AND  ' +
              '           ( ' +
              '               TO_CHAR(PLAN_START, ''yyyy-mm-dd'') <= :beginDate  ' +
              '               AND PLAN_END >= TO_DATE(:beginDate, ''yyyy-mm-dd'')  ' +
              '               AND TO_CHAR(PLAN_START, ''yyyy-mm-dd'') <= :endDate  ' +
              '               AND TO_CHAR(PLAN_END, ''yyyy-mm-dd'') <= :endDate   ' +
              '               OR PLAN_START >= TO_DATE(:beginDate, ''yyyy-mm-dd'')  ' +
              '               AND TO_CHAR(PLAN_END, ''yyyy-mm-dd'') >= :beginDate ' +
              '               AND TO_CHAR(PLAN_START, ''yyyy-mm-dd'') <= :endDate ' +
              '               AND TO_CHAR(PLAN_END, ''yyyy-mm-dd'') <= :endDate  ' +
              '               OR TO_CHAR(PLAN_START, ''yyyy-mm-dd'') >= :beginDate  ' +
              '               AND TO_CHAR(PLAN_END, ''yyyy-mm-dd'') >= :beginDate   ' +
              '               AND TO_CHAR(PLAN_START, ''yyyy-mm-dd'') <= :endDate   ' +
              '               AND TO_CHAR(PLAN_END, ''yyyy-mm-dd'') >= :endDate  ' +
              '               OR TO_CHAR(PLAN_START, ''yyyy-mm-dd'') <= :beginDate  ' +
              '               AND TO_CHAR(PLAN_END, ''yyyy-mm-dd'') >= :beginDate  ' +
              '               AND TO_CHAR(PLAN_START, ''yyyy-mm-dd'') <= :endDate  ' +
              '               AND TO_CHAR(PLAN_END, ''yyyy-mm-dd'') >= :endDate ' +
              '           ) ' +
              '       ) A JOIN ' +
              '       ( ' +
              '           SELECT A.PLAN_NO, PRN, PLAN_EMPNO, PLAN_TEAM FROM ' +
              '           ( ' +
              '               SELECT PLAN_NO, MAX(PLAN_REV_NO) PRN FROM TMS_PLAN GROUP BY PLAN_NO ' +
              '           ) A JOIN  ' +
              '           ( ' +
              '               SELECT * FROM TMS_PLAN_INCHARGE ' +
              '           )B ' +
              '           ON A.PLAN_NO = B.PLAN_NO ' +
              '           AND A.PRN = B.PLAN_REV_NO ' +
              '       ) B ' +
              '       ON A.PLAN_NO = B.PLAN_NO ' +
              '       AND A.PRN = B.PRN ' +
              '   )  ' +
              '   WHERE PLAN_TEAM LIKE :DEPT_CD ' +
              '   AND PLAN_EMPNO LIKE :USERID ' +
              '   AND ENG_MODEL LIKE :ENG_MODEL  ' +
              '   AND ENG_TYPE LIKE :ENG_TYPE  ' +
              '   AND ENG_PROJNO LIKE :ENG_PROJNO ' +
              '   GROUP BY PLAN_NO, TASK_NO, PRN, PLAN_NAME ' +
              ') ' +
              'START WITH TASK_PRT IS NULL ' +
              'CONNECT BY PRIOR TASK_NO = TASK_PRT ' +
              'ORDER SIBLINGS BY TASK_ORDER, TASK_NAME ');

      ParamByName('beginDate').AsString := FormatdateTime('yyyy-MM-dd',dt_begin.Date);
      ParamByName('endDate').AsString := FormatdateTime('yyyy-MM-dd',dt_end.Date);

      if cb_engModel.Text <> '' then
        ParamByName('ENG_MODEL').AsString := cb_engModel.Text
      else
        SQL.Text := ReplaceStr(SQL.Text, 'AND ENG_MODEL LIKE :ENG_MODEL ', '' );

      if cb_engType.Text <> '' then
        ParamByName('ENG_TYPE').AsString := cb_engType.Text
      else
        SQL.Text := ReplaceStr(SQL.Text, 'AND ENG_TYPE LIKE :ENG_TYPE ', '' );

      if cb_engProjNo.Text <> '' then
        ParamByName('ENG_PROJNO').AsString := cb_engProjNo.Text
      else
        SQL.Text := ReplaceStr(SQL.Text, 'AND ENG_PROJNO LIKE :ENG_PROJNO ', '' );

      if cb_team.Hint <> '' then
        ParamByName('DEPT_CD').AsString := '%'+cb_team.Hint+'%'
      else
        ParamByName('DEPT_CD').AsString := '%'+DM1.FUserInfo.CurrentUsersDept+'%';

      if cb_user.Hint <> '' then
        ParamByName('USERID').AsString := cb_user.Hint
      else
        SQL.Text := ReplaceStr(SQL.Text, 'AND PLAN_EMPNO LIKE :USERID ', '' );


      Open;

      if RecordCount <> 0 then
      begin

        et_taskName.Hint := Create_chooseTask_Frm('A',OraQuery);

        if et_taskName.Hint <> '' then
          et_taskName.Text := Get_TaskName(et_taskName.Hint);

        Edit1.Text := et_taskName.Hint;

      end else
        ShowMessage('조건에 맞는 데이터를 찾을 수 없습니다.');
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure TtaskStatistics_Frm.Button2Click(Sender: TObject);
begin
  et_taskName.Clear;
  et_taskName.Hint := '';
end;

procedure TtaskStatistics_Frm.cb_engModelDropDown(Sender: TObject);
begin
  with cb_engModel.Items do
  begin
    BeginUpdate;
    try
      Clear;
      Add('');
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT ENGMODEL FROM HIMSEN_INFO ' +
                'AND ENGTYPE = :ENGTYPE ' +
                'AND PROJNO = :PROJNO ' +
                'GROUP BY ENGMODEL ' +
                'ORDER BY ENGMODEL ');

        if cb_engType.Text <> '' then
          ParamByName('ENGTYPE').AsString := cb_engType.Text
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND ENGTYPE = :ENGTYPE ', '' );

        if cb_engProjNo.Text <> '' then
          ParamByName('PROJNO').AsString := cb_engProjNo.Text
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND PROJNO = :PROJNO ', '' );

        Open;

        while not eof do
        begin
          Add(FieldByName('ENGMODEL').AsString);
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TtaskStatistics_Frm.cb_engProjNoDropDown(Sender: TObject);
begin
  with cb_engProjNo.Items do
  begin
    BeginUpdate;
    try
      Clear;
      Add('');
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT DISTINCT(PROJNO) FROM HIMSEN_INFO ' +
                'WHERE STATUS = 0 ');

        if cb_engModel.Text <> '' then
          SQL.Add('AND ENGMODEL = '''+cb_engModel.Text+''' ');

        if cb_engType.Text <> '' then
          SQL.Add('AND ENGTYPE = '''+cb_engType.Text+''' ');


        SQL.Add('ORDER BY PROJNO ');
        Open;

        while not eof do
        begin
          Add(FieldByName('PROJNO').AsString);
          Next;
        end;
      end;


    finally
      EndUpdate;
    end;
  end;
end;

procedure TtaskStatistics_Frm.cb_engTypeDropDown(Sender: TObject);
begin
  with cb_engType.Items do
  begin
    BeginUpdate;
    try
      Clear;
      Add('');
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT DISTINCT(ENGTYPE) FROM HIMSEN_INFO ' +
                'WHERE STATUS = 0 ');

        if cb_engModel.Text <> '' then
          SQL.Add('AND ENGMODEL = '''+cb_engModel.Text+''' ');

        if cb_engProjNo.Text <> '' then
          SQL.Add('AND PROJNO = '''+cb_engProjNo.Text+''' ');


        SQL.Add('ORDER BY ENGTYPE ');
        Open;

        while not eof do
        begin
          Add(FieldByName('ENGTYPE').AsString);
          Next;
        end;
      end;


    finally
      EndUpdate;
    end;
  end;
end;

procedure TtaskStatistics_Frm.cb_teamDropDown(Sender: TObject);
var
  i: integer;
  lteam : string;
begin
  with cb_team.Items do
  begin
    BeginUpdate;
    try
      Clear;
      Add('');
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM HITEMS_DEPT ' +
                'WHERE PARENT_CD LIKE :param1 ' +
                'ORDER BY DEPT_CD ');

        ParamByName('param1').AsString := '%'+DM1.FUserInfo.CurrentUsersDept+'%';
        Open;

        if RecordCount <> 0 then
        begin
          for i := 0 to RecordCount-1 do
          begin
            if i = 0 then
            begin
              if FieldByName('DEPT_CD').AsString = DM1.FUserInfo.CurrentUsersTeam then
                Add(FieldByName('DEPT_NAME').AsString);
            end else
            begin
              Add(FieldByName('DEPT_NAME').AsString);
            end;
            Next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TtaskStatistics_Frm.cb_teamSelect(Sender: TObject);
begin
  if cb_team.Text <> '' then
  begin
    with DM1.OraQuery1 do
    begin
      First;
      while not eof do
      begin
        if FieldByName('DEPT_NAME').AsString = cb_team.Text then
        begin
          cb_team.Hint := FieldByName('DEPT_CD').AsString;
          Break;
        end;
        Next;
      end;
    end;
  end else
  begin
    cb_team.Clear;
    cb_team.Items.Clear;
    cb_team.Hint := '';
  end;
end;

procedure TtaskStatistics_Frm.cb_userDropDown(Sender: TObject);
begin
  with cb_user.Items do
  begin
    BeginUpdate;
    try
      Clear;
      Add('');

      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT ' +
                'A.DEPT_CD, A.USERID, A.PRIV, A.GRADE, A.NAME_KOR, ' +
                'A.POSITION, B.DESCR ' +
                'FROM HITEMS_USER A, HITEMS_USER_GRADE B ' +
                'WHERE A.GRADE = B.GRADE ' +
                'AND DEPT_CD LIKE :param1 ' +
                'ORDER BY PRIV DESC, POSITION, A.GRADE, USERID ');

        if cb_team.Hint <> '' then
          ParamByName('param1').AsString := '%'+cb_team.Hint+'%'
        else
          ParamByName('param1').AsString := '%'+DM1.FUserInfo.CurrentUsersDept+'%';

        Open;

        while not eof do
        begin
          Add(FieldByName('NAME_KOR').AsString+' '+FieldByName('DESCR').AsString);
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TtaskStatistics_Frm.cb_userSelect(Sender: TObject);
begin
  if cb_user.ItemIndex <> 0 then
  begin
    with DM1.OraQuery1 do
    begin
      First;
      cb_user.Hint := '';
      while not eof do
      begin
        if cb_user.ItemIndex = RecNo then
        begin
          cb_user.Hint := FieldByName('USERID').AsString;
          Break;
        end;
        Next;
      end;
    end;
  end else
    cb_user.Hint := '';
end;

procedure TtaskStatistics_Frm.et_totalmhChange(Sender: TObject);
begin
  if et_totalmh.Text <> '' then
  begin
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM TMS_ANNUAL_MH_COST ' +
              'WHERE YEAR = :param1 ');
      ParamByName('param1').AsInteger := StrToInt(FormatDateTime('YYYY',Today));
      Open;

      et_Cost.Text :=  NumberFormat(FloatToStr(Round((FieldByName('COST').AsFloat * StrToFloat(et_totalmh.Text))/1000)));

    end;
  end;
end;

procedure TtaskStatistics_Frm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if Assigned(FtaskDic) then
    FreeAndNil(FtaskDic);

end;

procedure TtaskStatistics_Frm.FormCreate(Sender: TObject);
begin
  dt_begin.Date := StartOfTheWeek(today);
  dt_end.Date   := EndOfTheWeek(today);

  cb_team.Hint := DM1.FUserInfo.CurrentUsersTeam;
  cb_team.Items.Add(Get_DeptName(cb_team.Hint));
  cb_team.ItemIndex := cb_team.Items.Count-1;
end;

procedure TtaskStatistics_Frm.Get_ResultOfHimsenModel;
Var
  i,
  lrow : Integer;
  ld : Double;

begin
  with grid_model do
  begin
    BeginUpdate;
    try
      ClearRows;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT ENG_MODEL, SUM(RST_MH) MH FROM ' +
                '( ' +
                '   SELECT A.* ,(SELECT NAME_KOR FROM HITEMS_USER WHERE USERID LIKE A.RST_BY) NAME_KOR FROM ' +
                '   (  ' +
                '       SELECT * FROM ' +
                '       ( ' +
                '           SELECT ' +
                '             TASK_NO, TASK_PRT, TASK_LV, ''''RST_NO, ' +
                '             ''''RST_CODE, TO_DATE('''') RST_PERFORM, '''' RST_BY, ' +
                '             0 RST_MH, ''''RST_CODE_NAME, ''''PLAN_CODE, ' +
                '             ''''ENG_MODEL, ''''ENG_TYPE, ''''ENG_PROJNO, ' +
                '             ''''PLAN_CODE_NAME, ''''DEPT_CD ' +
                '           FROM TMS_TASK ' +
                '           UNION ALL ' +
                '           SELECT ' +
                '             A.PLAN_NO, TASK_NO, A.PLAN_REV_NO, A.RST_NO, RST_CODE, RST_PERFORM, ' +
                '             B.RST_BY, RST_MH, ' +
                '             C.CODE_NAME RST_CODE_NAME, ' +
                '             D.PLAN_CODE, ENG_MODEL, ENG_TYPE, ENG_PROJNO, ' +
                '             E.CODE_NAME PLAN_CODE_NAME, ' +
                '             F.DEPT_CD ' +
                '           FROM ' +
                '           TMS_RESULT A, ' +
                '           TMS_RESULT_MH B, ' +
                '           HITEMS_CODE_GROUP C, ' +
                '           TMS_PLAN D, ' +
                '           HITEMS_CODE_GROUP E, ' +
                '           HITEMS_USER F ' +
                '           WHERE A. RST_NO = B.RST_NO ' +
                '           AND A. RST_CODE = C.GRP_NO ' +
                '           AND A.PLAN_NO = D.PLAN_NO ' +
                '           AND A.PLAN_REV_NO = D.PLAN_REV_NO ' +
                '           AND D.PLAN_CODE = E.GRP_NO ' +
                '           AND B.RST_BY = F.USERID ' +
                '       ) ' +
                '       START WITH TASK_PRT IS NULL ' +
                '       CONNECT BY PRIOR TASK_NO = TASK_PRT ' +
                '   ) A ' +
                '   WHERE RST_PERFORM BETWEEN :BEGIN AND :END ' +
                '   AND ENG_MODEL LIKE :ENG_MODEL ' +
                '   AND ENG_TYPE LIKE :ENG_TYPE ' +
                '   AND ENG_PROJNO LIKE :ENG_PROJNO ' +
                '   AND DEPT_CD LIKE :DEPT_CD ' +
                '   AND RST_BY LIKE :USERID ' +
                ') ' +
                'GROUP BY ENG_MODEL ' +
                'ORDER BY ENG_MODEL ');

        ParamByName('BEGIN').AsDate := dt_begin.Date;
        ParamByName('END').AsDate   := dt_end.Date;

        if et_taskName.Hint <> '' then
        begin
          SQL.Text := ReplaceStr(SQL.Text, 'START WITH TASK_PRT IS NULL', 'START WITH TASK_NO LIKE :param1' );
          ParamByName('param1').AsString := et_taskName.Hint;
        end;

        if cb_engModel.Text <> '' then
          ParamByName('ENG_MODEL').AsString := cb_engModel.Text
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND ENG_MODEL LIKE :ENG_MODEL ', '' );

        if cb_engType.Text <> '' then
          ParamByName('ENG_TYPE').AsString := cb_engType.Text
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND ENG_TYPE LIKE :ENG_TYPE ', '' );

        if cb_engProjNo.Text <> '' then
          ParamByName('ENG_PROJNO').AsString := cb_engProjNo.Text
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND ENG_PROJNO LIKE :ENG_PROJNO ', '' );

        if cb_team.Hint <> '' then
          ParamByName('DEPT_CD').AsString := '%'+cb_team.Hint+'%'
        else
          ParamByName('DEPT_CD').AsString := '%'+DM1.FUserInfo.CurrentUsersDept+'%';

        if cb_user.Hint <> '' then
          ParamByName('USERID').AsString := cb_user.Hint
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND RST_BY LIKE :USERID ', '' );

        Open;

        if RecordCount <> 0 then
        begin
          ld := 0;
          while not eof do
          begin
            lrow := AddRow;
            Cells[1,lrow] := FieldByName('ENG_MODEL').AsString;
            Cells[2,lrow] := FieldByName('ENG_MODEL').AsString;
            Cells[3,lrow] := FieldByName('MH').AsString;
            ld := ld + FieldByName('MH').AsFloat;
            Next;
          end;

          for i := 0 to RowCount-1 do
            Cell[4,i].AsInteger := Round((Cell[3,i].AsFloat / ld) * 100);
//            Cells[4,i] := Format('%d%%',[Round((Cell[3,i].AsFloat / ld) * 100)]);

        end;
      end;

    finally
      EndUpdate;
    end;
  end;
end;


procedure TtaskStatistics_Frm.Get_ResultOfHimsenProj;
Var
  i,
  lrow : Integer;
  ld : Double;

begin
  with grid_proj do
  begin
    BeginUpdate;
    try
      ClearRows;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT ENG_PROJNO, ENG_TYPE, SUM(RST_MH) MH FROM ' +
                '( ' +
                '   SELECT A.* ,(SELECT NAME_KOR FROM HITEMS_USER WHERE USERID LIKE A.RST_BY) NAME_KOR FROM ' +
                '   (  ' +
                '       SELECT * FROM ' +
                '       ( ' +
                '           SELECT ' +
                '             TASK_NO, TASK_PRT, TASK_LV, ''''RST_NO, ' +
                '             ''''RST_CODE, TO_DATE('''') RST_PERFORM, '''' RST_BY, ' +
                '             0 RST_MH, ''''RST_CODE_NAME, ''''PLAN_CODE, ' +
                '             ''''ENG_MODEL, ''''ENG_TYPE, ''''ENG_PROJNO, ' +
                '             ''''PLAN_CODE_NAME, ''''DEPT_CD ' +
                '           FROM TMS_TASK ' +
                '           UNION ALL ' +
                '           SELECT ' +
                '             A.PLAN_NO, TASK_NO, A.PLAN_REV_NO, A.RST_NO, RST_CODE, RST_PERFORM, ' +
                '             B.RST_BY, RST_MH, ' +
                '             C.CODE_NAME RST_CODE_NAME, ' +
                '             D.PLAN_CODE, ENG_MODEL, ENG_TYPE, ENG_PROJNO, ' +
                '             E.CODE_NAME PLAN_CODE_NAME, ' +
                '             F.DEPT_CD ' +
                '           FROM ' +
                '           TMS_RESULT A, ' +
                '           TMS_RESULT_MH B, ' +
                '           HITEMS_CODE_GROUP C, ' +
                '           TMS_PLAN D, ' +
                '           HITEMS_CODE_GROUP E, ' +
                '           HITEMS_USER F ' +
                '           WHERE A. RST_NO = B.RST_NO ' +
                '           AND A. RST_CODE = C.GRP_NO ' +
                '           AND A.PLAN_NO = D.PLAN_NO ' +
                '           AND A.PLAN_REV_NO = D.PLAN_REV_NO ' +
                '           AND D.PLAN_CODE = E.GRP_NO ' +
                '           AND B.RST_BY = F.USERID ' +
                '       ) ' +
                '       START WITH TASK_PRT IS NULL ' +
                '       CONNECT BY PRIOR TASK_NO = TASK_PRT ' +
                '   ) A ' +
                '   WHERE RST_PERFORM BETWEEN :BEGIN AND :END ' +
                '   AND ENG_MODEL LIKE :ENG_MODEL ' +
                '   AND ENG_TYPE LIKE :ENG_TYPE ' +
                '   AND ENG_PROJNO LIKE :ENG_PROJNO ' +
                '   AND DEPT_CD LIKE :DEPT_CD ' +
                '   AND RST_BY LIKE :USERID ' +
                ') ' +
                'GROUP BY ENG_PROJNO, ENG_TYPE ' +
                'ORDER BY ENG_TYPE ');

        ParamByName('BEGIN').AsDate := dt_begin.Date;
        ParamByName('END').AsDate   := dt_end.Date;

        if et_taskName.Hint <> '' then
        begin
          SQL.Text := ReplaceStr(SQL.Text, 'START WITH TASK_PRT IS NULL', 'START WITH TASK_NO LIKE :param1' );
          ParamByName('param1').AsString := et_taskName.Hint;
        end;

        if cb_engModel.Text <> '' then
          ParamByName('ENG_MODEL').AsString := cb_engModel.Text
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND ENG_MODEL LIKE :ENG_MODEL ', '' );

        if cb_engType.Text <> '' then
          ParamByName('ENG_TYPE').AsString := cb_engType.Text
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND ENG_TYPE LIKE :ENG_TYPE ', '' );

        if cb_engProjNo.Text <> '' then
          ParamByName('ENG_PROJNO').AsString := cb_engProjNo.Text
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND ENG_PROJNO LIKE :ENG_PROJNO ', '' );

        if cb_team.Hint <> '' then
          ParamByName('DEPT_CD').AsString := '%'+cb_team.Hint+'%'
        else
          ParamByName('DEPT_CD').AsString := '%'+DM1.FUserInfo.CurrentUsersDept+'%';

        if cb_user.Hint <> '' then
          ParamByName('USERID').AsString := cb_user.Hint
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND RST_BY LIKE :USERID ', '' );

        Open;

        if RecordCount <> 0 then
        begin
          ld := 0;
          while not eof do
          begin
            lrow := AddRow;
            Cells[1,lrow] := FieldByName('ENG_PROJNO').AsString;

            if FieldByName('ENG_PROJNO').AsString <> '' then
              Cells[2,lrow] := FieldByName('ENG_PROJNO').AsString+'('+FieldByName('ENG_TYPE').AsString+')';

            Cells[3,lrow] := FieldByName('MH').AsString;
            ld := ld + FieldByName('MH').AsFloat;
            Next;
          end;

          for i := 0 to RowCount-1 do
            Cell[4,i].AsInteger := Round((Cell[3,i].AsFloat / ld) * 100);
//            Cells[4,i] := Format('%d%%',[Round((Cell[3,i].AsFloat / ld) * 100)]);

        end;
      end;

    finally
      EndUpdate;
    end;
  end;
end;

procedure TtaskStatistics_Frm.Get_ResultOfHimsenType;
Var
  i,
  lrow : Integer;
  ld : Double;

begin
  with grid_type do
  begin
    BeginUpdate;
    try
      ClearRows;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT ENG_TYPE, SUM(RST_MH) MH FROM ' +
                '( ' +
                '   SELECT A.* ,(SELECT NAME_KOR FROM HITEMS_USER WHERE USERID LIKE A.RST_BY) NAME_KOR FROM ' +
                '   (  ' +
                '       SELECT * FROM ' +
                '       ( ' +
                '           SELECT ' +
                '             TASK_NO, TASK_PRT, TASK_LV, ''''RST_NO, ' +
                '             ''''RST_CODE, TO_DATE('''') RST_PERFORM, '''' RST_BY, ' +
                '             0 RST_MH, ''''RST_CODE_NAME, ''''PLAN_CODE, ' +
                '             ''''ENG_MODEL, ''''ENG_TYPE, ''''ENG_PROJNO, ' +
                '             ''''PLAN_CODE_NAME, ''''DEPT_CD ' +
                '           FROM TMS_TASK ' +
                '           UNION ALL ' +
                '           SELECT ' +
                '             A.PLAN_NO, TASK_NO, A.PLAN_REV_NO, A.RST_NO, RST_CODE, RST_PERFORM, ' +
                '             B.RST_BY, RST_MH, ' +
                '             C.CODE_NAME RST_CODE_NAME, ' +
                '             D.PLAN_CODE, ENG_MODEL, ENG_TYPE, ENG_PROJNO, ' +
                '             E.CODE_NAME PLAN_CODE_NAME, ' +
                '             F.DEPT_CD ' +
                '           FROM ' +
                '           TMS_RESULT A, ' +
                '           TMS_RESULT_MH B, ' +
                '           HITEMS_CODE_GROUP C, ' +
                '           TMS_PLAN D, ' +
                '           HITEMS_CODE_GROUP E, ' +
                '           HITEMS_USER F ' +
                '           WHERE A. RST_NO = B.RST_NO ' +
                '           AND A. RST_CODE = C.GRP_NO ' +
                '           AND A.PLAN_NO = D.PLAN_NO ' +
                '           AND A.PLAN_REV_NO = D.PLAN_REV_NO ' +
                '           AND D.PLAN_CODE = E.GRP_NO ' +
                '           AND B.RST_BY = F.USERID ' +
                '       ) ' +
                '       START WITH TASK_PRT IS NULL ' +
                '       CONNECT BY PRIOR TASK_NO = TASK_PRT ' +
                '   ) A ' +
                '   WHERE RST_PERFORM BETWEEN :BEGIN AND :END ' +
                '   AND ENG_MODEL LIKE :ENG_MODEL ' +
                '   AND ENG_TYPE LIKE :ENG_TYPE ' +
                '   AND ENG_PROJNO LIKE :ENG_PROJNO ' +
                '   AND DEPT_CD LIKE :DEPT_CD ' +
                '   AND RST_BY LIKE :USERID ' +
                ') ' +
                'GROUP BY ENG_TYPE ' +
                'ORDER BY ENG_TYPE ');

        ParamByName('BEGIN').AsDate := dt_begin.Date;
        ParamByName('END').AsDate   := dt_end.Date;

        if et_taskName.Hint <> '' then
        begin
          SQL.Text := ReplaceStr(SQL.Text, 'START WITH TASK_PRT IS NULL', 'START WITH TASK_NO LIKE :param1' );
          ParamByName('param1').AsString := et_taskName.Hint;
        end;

        if cb_engModel.Text <> '' then
          ParamByName('ENG_MODEL').AsString := cb_engModel.Text
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND ENG_MODEL LIKE :ENG_MODEL ', '' );

        if cb_engType.Text <> '' then
          ParamByName('ENG_TYPE').AsString := cb_engType.Text
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND ENG_TYPE LIKE :ENG_TYPE ', '' );

        if cb_engProjNo.Text <> '' then
          ParamByName('ENG_PROJNO').AsString := cb_engProjNo.Text
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND ENG_PROJNO LIKE :ENG_PROJNO ', '' );

        if cb_team.Hint <> '' then
          ParamByName('DEPT_CD').AsString := '%'+cb_team.Hint+'%'
        else
          ParamByName('DEPT_CD').AsString := '%'+DM1.FUserInfo.CurrentUsersDept+'%';

        if cb_user.Hint <> '' then
          ParamByName('USERID').AsString := cb_user.Hint
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND RST_BY LIKE :USERID ', '' );

        Open;

        if RecordCount <> 0 then
        begin
          ld := 0;
          while not eof do
          begin
            lrow := AddRow;
            Cells[1,lrow] := FieldByName('ENG_TYPE').AsString;
            Cells[2,lrow] := FieldByName('ENG_TYPE').AsString;
            Cells[3,lrow] := FieldByName('MH').AsString;
            ld := ld + FieldByName('MH').AsFloat;
            Next;
          end;

          for i := 0 to RowCount-1 do
            Cell[4,i].AsInteger := Round((Cell[3,i].AsFloat / ld) * 100);
//            Cells[4,i] := Format('%d%%',[Round((Cell[3,i].AsFloat / ld) * 100)]);

        end;
      end;

    finally
      EndUpdate;
    end;
  end;
end;

procedure TtaskStatistics_Frm.Get_ResultOfPlanCode;
Var
  i,j,
  lrow : Integer;
  ld : Double;

begin
  with grid_PlanCode do
  begin
    BeginUpdate;
    try
      ClearRows;
      et_totalmh.Clear;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT PLAN_CODE, PLAN_CODE_NAME, SUM(RST_MH) MH FROM ' +
                '( ' +
                '   SELECT * FROM ' +
                '   (  ' +
                '       SELECT * FROM ' +
                '       ( ' +
                '           SELECT ' +
                '             TASK_NO, TASK_PRT, TASK_LV, ''''RST_NO, ' +
                '             ''''RST_CODE, TO_DATE('''') RST_PERFORM, '''' RST_BY, ' +
                '             0 RST_MH, ''''RST_CODE_NAME, ''''PLAN_CODE, ' +
                '             ''''ENG_MODEL, ''''ENG_TYPE, ''''ENG_PROJNO, ' +
                '             ''''PLAN_CODE_NAME, ''''DEPT_CD ' +
                '           FROM TMS_TASK ' +
                '           UNION ALL ' +
                '           SELECT ' +
                '             A.PLAN_NO, TASK_NO, A.PLAN_REV_NO, A.RST_NO, RST_CODE, RST_PERFORM, ' +
                '             B.RST_BY, RST_MH, ' +
                '             C.CODE_NAME RST_CODE_NAME, ' +
                '             D.PLAN_CODE, ENG_MODEL, ENG_TYPE, ENG_PROJNO, ' +
                '             E.CODE_NAME PLAN_CODE_NAME, ' +
                '             F.DEPT_CD ' +
                '           FROM ' +
                '           TMS_RESULT A, ' +
                '           TMS_RESULT_MH B, ' +
                '           HITEMS_CODE_GROUP C, ' +
                '           TMS_PLAN D, ' +
                '           HITEMS_CODE_GROUP E, ' +
                '           HITEMS_USER F ' +
                '           WHERE A. RST_NO = B.RST_NO ' +
                '           AND A. RST_CODE = C.GRP_NO ' +
                '           AND A.PLAN_NO = D.PLAN_NO ' +
                '           AND A.PLAN_REV_NO = D.PLAN_REV_NO ' +
                '           AND D.PLAN_CODE = E.GRP_NO ' +
                '           AND B.RST_BY = F.USERID ' +
                '       ) ' +
                '       START WITH TASK_PRT IS NULL ' +
                '       CONNECT BY PRIOR TASK_NO = TASK_PRT ' +
                '   ) ' +
                '   WHERE RST_PERFORM BETWEEN :BEGIN AND :END ' +
                '   AND ENG_MODEL LIKE :ENG_MODEL ' +
                '   AND ENG_TYPE LIKE :ENG_TYPE ' +
                '   AND ENG_PROJNO LIKE :ENG_PROJNO ' +
                '   AND DEPT_CD LIKE :DEPT_CD ' +
                '   AND RST_BY LIKE :USERID ' +
                ') ' +
                'GROUP BY PLAN_CODE, PLAN_CODE_NAME ' +
                'ORDER BY PLAN_CODE_NAME ');

        ParamByName('BEGIN').AsDate := dt_begin.Date;
        ParamByName('END').AsDate   := dt_end.Date;

        if et_taskName.Hint <> '' then
        begin
          SQL.Text := ReplaceStr(SQL.Text, 'START WITH TASK_PRT IS NULL', 'START WITH TASK_NO LIKE :param1' );
          ParamByName('param1').AsString := et_taskName.Hint;
        end;

        if cb_engModel.Text <> '' then
          ParamByName('ENG_MODEL').AsString := cb_engModel.Text
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND ENG_MODEL LIKE :ENG_MODEL ', '' );

        if cb_engType.Text <> '' then
          ParamByName('ENG_TYPE').AsString := cb_engType.Text
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND ENG_TYPE LIKE :ENG_TYPE ', '' );

        if cb_engProjNo.Text <> '' then
          ParamByName('ENG_PROJNO').AsString := cb_engProjNo.Text
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND ENG_PROJNO LIKE :ENG_PROJNO ', '' );

        if cb_team.Hint <> '' then
          ParamByName('DEPT_CD').AsString := '%'+cb_team.Hint+'%'
        else
          ParamByName('DEPT_CD').AsString := '%'+DM1.FUserInfo.CurrentUsersDept+'%';

        if cb_user.Hint <> '' then
          ParamByName('USERID').AsString := cb_user.Hint
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND RST_BY LIKE :USERID ', '' );

        Open;

        if RecordCount <> 0 then
        begin
          ld := 0;
          while not eof do
          begin
            lrow := AddRow;
            Cells[1,lrow] := FieldByName('PLAN_CODE').AsString;
            Cells[2,lrow] := FieldByName('PLAN_CODE_NAME').AsString;
            Cells[3,lrow] := FieldByName('MH').AsString;
            ld := ld + FieldByName('MH').AsFloat;
            Next;
          end;

          et_totalmh.Text := FloatToStr(ld);

          for i := 0 to RowCount-1 do
            Cell[4,i].AsInteger := Round((Cell[3,i].AsFloat / ld) * 100);
//            Cells[4,i] := Format('%d%%',[Round((Cell[3,i].AsFloat / ld) * 100)]);

        end;
      end;

    finally
      EndUpdate;
    end;
  end;
end;

procedure TtaskStatistics_Frm.Get_ResultOfPlanName;
Var
  i,
  lrow : Integer;
  ld : Double;

begin
  with grid_plan do
  begin
    BeginUpdate;
    try
      ClearRows;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT TASK_NO, TASK_NAME, SUM(RST_MH) MH FROM ' +
                '( ' +
                '   SELECT * FROM ' +
                '   ( ' +
                '       SELECT A.* ,(SELECT NAME_KOR FROM HITEMS_USER WHERE USERID LIKE A.RST_BY) NAME_KOR FROM ' +
                '       ( ' +
                '           SELECT  ' +
                '             TASK_NO, TASK_PRT, ''''RST_NO, ''''RST_CODE, TO_DATE('''') RST_PERFORM,  ' +
                '             '''' RST_BY, 0 RST_MH, ''''RST_CODE_NAME, ''''PLAN_CODE, ''''ENG_MODEL,  ' +
                '             ''''ENG_TYPE, ''''ENG_PROJNO, ''''PLAN_CODE_NAME, ''''DEPT_CD, TASK_NAME   ' +
                '           FROM TMS_TASK ' +
                '           UNION ALL ' +
                '           SELECT  ' +
                '             PLAN_NO, TASK_NO, RST_NO, RST_CODE, RST_PERFORM,  ' +
                '             RST_BY, RST_MH, RST_CODE_NAME, PLAN_CODE, ENG_MODEL,  ' +
                '             ENG_TYPE, ENG_PROJNO, PLAN_CODE_NAME, DEPT_CD, PLAN_NAME  ' +
                '           FROM ' +
                '           ( ' +
                '               SELECT   ' +
                '                 A.PLAN_NO, TASK_NO,    ' +
                '                 A.RST_NO, RST_CODE, RST_PERFORM,  ' +
                '                 B.RST_BY, RST_MH,  ' +
                '                 C.CODE_NAME RST_CODE_NAME,  ' +
                '                 D.PLAN_CODE, ENG_MODEL, ENG_TYPE, ENG_PROJNO,  ' +
                '                 E.CODE_NAME PLAN_CODE_NAME,  ' +
                '                 F.DEPT_CD  ' +
                '               FROM  ' +
                '               TMS_RESULT A,  ' +
                '               TMS_RESULT_MH B,  ' +
                '               HITEMS_CODE_GROUP C,  ' +
                '               TMS_PLAN D,  ' +
                '               HITEMS_CODE_GROUP E,  ' +
                '               HITEMS_USER F  ' +
                '               WHERE A. RST_NO = B.RST_NO  ' +
                '               AND A. RST_CODE = C.GRP_NO  ' +
                '               AND A.PLAN_NO = D.PLAN_NO  ' +
                '               AND A.PLAN_REV_NO = D.PLAN_REV_NO  ' +
                '               AND D.PLAN_CODE = E.GRP_NO  ' +
                '               AND B.RST_BY = F.USERID ' +
                '           ) A JOIN ' +
                '           ( ' +
                '               SELECT PN, PLAN_NAME FROM ' +
                '               ( ' +
                '                   SELECT PLAN_NO PN, MAX(PLAN_REV_NO) PRN FROM TMS_PLAN GROUP BY PLAN_NO ' +
                '               ) A JOIN ' +
                '               ( ' +
                '                   SELECT PLAN_NO, PLAN_REV_NO, PLAN_NAME FROM TMS_PLAN ' +
                '               ) B ' +
                '               ON A.PN = B.PLAN_NO  ' +
                '               AND A.PRN = B.PLAN_REV_NO ' +
                '           ) B ' +
                '           ON A.PLAN_NO = B.PN ' +
                '       ) A     ' +
                '       START WITH TASK_PRT IS NULL ' +
                '       CONNECT BY PRIOR TASK_NO = TASK_PRT ' +
                '   ) ' +
                '   WHERE RST_PERFORM BETWEEN :BEGIN AND :END ' +
                '   AND ENG_MODEL LIKE :ENG_MODEL ' +
                '   AND ENG_TYPE LIKE :ENG_TYPE ' +
                '   AND ENG_PROJNO LIKE :ENG_PROJNO ' +
                '   AND DEPT_CD LIKE :DEPT_CD ' +
                '   AND RST_BY LIKE :USERID ' +
                ') ' +
                'GROUP BY TASK_NO, TASK_NAME ' +
                'ORDER BY TASK_NAME ');


        ParamByName('BEGIN').AsDate := dt_begin.Date;
        ParamByName('END').AsDate   := dt_end.Date;

        if et_taskName.Hint <> '' then
        begin
          SQL.Text := ReplaceStr(SQL.Text, 'START WITH TASK_PRT IS NULL', 'START WITH TASK_NO LIKE :param1' );
          ParamByName('param1').AsString := et_taskName.Hint;
        end;

        if cb_engModel.Text <> '' then
          ParamByName('ENG_MODEL').AsString := cb_engModel.Text
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND ENG_MODEL LIKE :ENG_MODEL ', '' );

        if cb_engType.Text <> '' then
          ParamByName('ENG_TYPE').AsString := cb_engType.Text
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND ENG_TYPE LIKE :ENG_TYPE ', '' );

        if cb_engProjNo.Text <> '' then
          ParamByName('ENG_PROJNO').AsString := cb_engProjNo.Text
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND ENG_PROJNO LIKE :ENG_PROJNO ', '' );

        if cb_team.Hint <> '' then
          ParamByName('DEPT_CD').AsString := '%'+cb_team.Hint+'%'
        else
          ParamByName('DEPT_CD').AsString := '%'+DM1.FUserInfo.CurrentUsersDept+'%';

        if cb_user.Hint <> '' then
          ParamByName('USERID').AsString := cb_user.Hint
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND RST_BY LIKE :USERID ', '' );

        Open;

        if RecordCount <> 0 then
        begin
          ld := 0;
          while not eof do
          begin
            lrow := AddRow;
            Cells[1,lrow] := FieldByName('TASK_NO').AsString;
            Cells[2,lrow] := FieldByName('TASK_NAME').AsString;
            Cells[3,lrow] := FieldByName('MH').AsString;
            ld := ld + FieldByName('MH').AsFloat;
            Next;
          end;

          for i := 0 to RowCount-1 do
            Cell[4,i].AsInteger := Round((Cell[3,i].AsFloat / ld) * 100);
//            Cells[4,i] := Format('%d%%',[Round((Cell[3,i].AsFloat / ld) * 100)]);

        end;
      end;

    finally
      EndUpdate;
    end;
  end;
end;

procedure TtaskStatistics_Frm.Get_ResultOfResultCode;
Var
  i,
  lrow : Integer;
  ld : Double;

begin
  with grid_rstCode do
  begin
    BeginUpdate;
    try
      ClearRows;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT RST_CODE, RST_CODE_NAME, SUM(RST_MH) MH FROM ' +
                '( ' +
                '   SELECT * FROM ' +
                '   (  ' +
                '       SELECT * FROM ' +
                '       ( ' +
                '           SELECT ' +
                '             TASK_NO, TASK_PRT, TASK_LV, ''''RST_NO, ' +
                '             ''''RST_CODE, TO_DATE('''') RST_PERFORM, '''' RST_BY, ' +
                '             0 RST_MH, ''''RST_CODE_NAME, ''''PLAN_CODE, ' +
                '             ''''ENG_MODEL, ''''ENG_TYPE, ''''ENG_PROJNO, ' +
                '             ''''PLAN_CODE_NAME, ''''DEPT_CD ' +
                '           FROM TMS_TASK ' +
                '           UNION ALL ' +
                '           SELECT ' +
                '             A.PLAN_NO, TASK_NO, A.PLAN_REV_NO, A.RST_NO, RST_CODE, RST_PERFORM, ' +
                '             B.RST_BY, RST_MH, ' +
                '             C.CODE_NAME RST_CODE_NAME, ' +
                '             D.PLAN_CODE, ENG_MODEL, ENG_TYPE, ENG_PROJNO, ' +
                '             E.CODE_NAME PLAN_CODE_NAME, ' +
                '             F.DEPT_CD ' +
                '           FROM ' +
                '           TMS_RESULT A, ' +
                '           TMS_RESULT_MH B, ' +
                '           HITEMS_CODE_GROUP C, ' +
                '           TMS_PLAN D, ' +
                '           HITEMS_CODE_GROUP E, ' +
                '           HITEMS_USER F ' +
                '           WHERE A. RST_NO = B.RST_NO ' +
                '           AND A. RST_CODE = C.GRP_NO ' +
                '           AND A.PLAN_NO = D.PLAN_NO ' +
                '           AND A.PLAN_REV_NO = D.PLAN_REV_NO ' +
                '           AND D.PLAN_CODE = E.GRP_NO ' +
                '           AND B.RST_BY = F.USERID ' +
                '       ) ' +
                '       START WITH TASK_PRT IS NULL ' +
                '       CONNECT BY PRIOR TASK_NO = TASK_PRT ' +
                '   ) ' +
                '   WHERE RST_PERFORM BETWEEN :BEGIN AND :END ' +
                '   AND ENG_MODEL LIKE :ENG_MODEL ' +
                '   AND ENG_TYPE LIKE :ENG_TYPE ' +
                '   AND ENG_PROJNO LIKE :ENG_PROJNO ' +
                '   AND DEPT_CD LIKE :DEPT_CD ' +
                '   AND RST_BY LIKE :USERID ' +
                ') ' +
                'GROUP BY RST_CODE, RST_CODE_NAME ' +
                'ORDER BY RST_CODE_NAME ');

        ParamByName('BEGIN').AsDate := dt_begin.Date;
        ParamByName('END').AsDate   := dt_end.Date;

        if et_taskName.Hint <> '' then
        begin
          SQL.Text := ReplaceStr(SQL.Text, 'START WITH TASK_PRT IS NULL', 'START WITH TASK_NO LIKE :param1' );
          ParamByName('param1').AsString := et_taskName.Hint;
        end;

        if cb_engModel.Text <> '' then
          ParamByName('ENG_MODEL').AsString := cb_engModel.Text
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND ENG_MODEL LIKE :ENG_MODEL ', '' );

        if cb_engType.Text <> '' then
          ParamByName('ENG_TYPE').AsString := cb_engType.Text
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND ENG_TYPE LIKE :ENG_TYPE ', '' );

        if cb_engProjNo.Text <> '' then
          ParamByName('ENG_PROJNO').AsString := cb_engProjNo.Text
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND ENG_PROJNO LIKE :ENG_PROJNO ', '' );

        if cb_team.Hint <> '' then
          ParamByName('DEPT_CD').AsString := '%'+cb_team.Hint+'%'
        else
          ParamByName('DEPT_CD').AsString := '%'+DM1.FUserInfo.CurrentUsersDept+'%';

        if cb_user.Hint <> '' then
          ParamByName('USERID').AsString := cb_user.Hint
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND RST_BY LIKE :USERID ', '' );

        Open;

        if RecordCount <> 0 then
        begin
          ld := 0;
          while not eof do
          begin
            lrow := AddRow;
            Cells[1,lrow] := FieldByName('RST_CODE').AsString;
            Cells[2,lrow] := FieldByName('RST_CODE_NAME').AsString;
            Cells[3,lrow] := FieldByName('MH').AsString;
            ld := ld + FieldByName('MH').AsFloat;
            Next;
          end;

          for i := 0 to RowCount-1 do
            Cell[4,i].AsInteger := Round((Cell[3,i].AsFloat / ld) * 100);
//            Cells[4,i] := Format('%d%%',[Round((Cell[3,i].AsFloat / ld) * 100)]);

        end;
      end;

    finally
      EndUpdate;
    end;
  end;
end;


procedure TtaskStatistics_Frm.Get_ResultOfUser;
Var
  i,
  lrow : Integer;
  ld : Double;

begin
  with grid_user do
  begin
    BeginUpdate;
    try
      ClearRows;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT RST_BY, NAME_KOR, SUM(RST_MH) MH FROM ' +
                '( ' +
                '   SELECT A.* ,(SELECT NAME_KOR FROM HITEMS_USER WHERE USERID LIKE A.RST_BY) NAME_KOR FROM ' +
                '   (  ' +
                '       SELECT * FROM ' +
                '       ( ' +
                '           SELECT ' +
                '             TASK_NO, TASK_PRT, TASK_LV, ''''RST_NO, ' +
                '             ''''RST_CODE, TO_DATE('''') RST_PERFORM, '''' RST_BY, ' +
                '             0 RST_MH, ''''RST_CODE_NAME, ''''PLAN_CODE, ' +
                '             ''''ENG_MODEL, ''''ENG_TYPE, ''''ENG_PROJNO, ' +
                '             ''''PLAN_CODE_NAME, ''''DEPT_CD ' +
                '           FROM TMS_TASK ' +
                '           UNION ALL ' +
                '           SELECT ' +
                '             A.PLAN_NO, TASK_NO, A.PLAN_REV_NO, A.RST_NO, RST_CODE, RST_PERFORM, ' +
                '             B.RST_BY, RST_MH, ' +
                '             C.CODE_NAME RST_CODE_NAME, ' +
                '             D.PLAN_CODE, ENG_MODEL, ENG_TYPE, ENG_PROJNO, ' +
                '             E.CODE_NAME PLAN_CODE_NAME, ' +
                '             F.DEPT_CD ' +
                '           FROM ' +
                '           TMS_RESULT A, ' +
                '           TMS_RESULT_MH B, ' +
                '           HITEMS_CODE_GROUP C, ' +
                '           TMS_PLAN D, ' +
                '           HITEMS_CODE_GROUP E, ' +
                '           HITEMS_USER F ' +
                '           WHERE A. RST_NO = B.RST_NO ' +
                '           AND A. RST_CODE = C.GRP_NO ' +
                '           AND A.PLAN_NO = D.PLAN_NO ' +
                '           AND A.PLAN_REV_NO = D.PLAN_REV_NO ' +
                '           AND D.PLAN_CODE = E.GRP_NO ' +
                '           AND B.RST_BY = F.USERID ' +
                '       ) ' +
                '       START WITH TASK_PRT IS NULL ' +
                '       CONNECT BY PRIOR TASK_NO = TASK_PRT ' +
                '   ) A ' +
                '   WHERE RST_PERFORM BETWEEN :BEGIN AND :END ' +
                '   AND ENG_MODEL LIKE :ENG_MODEL ' +
                '   AND ENG_TYPE LIKE :ENG_TYPE ' +
                '   AND ENG_PROJNO LIKE :ENG_PROJNO ' +
                '   AND DEPT_CD LIKE :DEPT_CD ' +
                '   AND RST_BY LIKE :USERID ' +
                ') ' +
                'GROUP BY RST_BY, NAME_KOR ' +
                'ORDER BY NAME_KOR ');

        ParamByName('BEGIN').AsDate := dt_begin.Date;
        ParamByName('END').AsDate   := dt_end.Date;

        if et_taskName.Hint <> '' then
        begin
          SQL.Text := ReplaceStr(SQL.Text, 'START WITH TASK_PRT IS NULL', 'START WITH TASK_NO LIKE :param1' );
          ParamByName('param1').AsString := et_taskName.Hint;
        end;

        if cb_engModel.Text <> '' then
          ParamByName('ENG_MODEL').AsString := cb_engModel.Text
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND ENG_MODEL LIKE :ENG_MODEL ', '' );

        if cb_engType.Text <> '' then
          ParamByName('ENG_TYPE').AsString := cb_engType.Text
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND ENG_TYPE LIKE :ENG_TYPE ', '' );

        if cb_engProjNo.Text <> '' then
          ParamByName('ENG_PROJNO').AsString := cb_engProjNo.Text
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND ENG_PROJNO LIKE :ENG_PROJNO ', '' );

        if cb_team.Hint <> '' then
          ParamByName('DEPT_CD').AsString := '%'+cb_team.Hint+'%'
        else
          ParamByName('DEPT_CD').AsString := '%'+DM1.FUserInfo.CurrentUsersDept+'%';

        if cb_user.Hint <> '' then
          ParamByName('USERID').AsString := cb_user.Hint
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND RST_BY LIKE :USERID ', '' );

        Open;

        if RecordCount <> 0 then
        begin
          ld := 0;
          while not eof do
          begin
            lrow := AddRow;
            Cells[1,lrow] := FieldByName('RST_BY').AsString;
            Cells[2,lrow] := FieldByName('NAME_KOR').AsString;
            Cells[3,lrow] := FieldByName('MH').AsString;
            ld := ld + FieldByName('MH').AsFloat;
            Next;
          end;

          for i := 0 to RowCount-1 do
            Cell[4,i].AsInteger := Round((Cell[3,i].AsFloat / ld) * 100);
//            Cells[4,i] := Format('%d%%',[Round((Cell[3,i].AsFloat / ld) * 100)]);

        end;
      end;

    finally
      EndUpdate;
    end;
  end;
end;

function TtaskStatistics_Frm.Get_TaskName(aTaskNo: String): String;
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
      SQL.Add('SELECT * FROM ' +
              '( ' +
              '   SELECT TASK_NO, TASK_NAME FROM TMS_TASK ' +
              '   UNION ALL ' +
              '   SELECT A.PLAN_NO, PLAN_NAME FROM ' +
              '   ( ' +
              '     SELECT PLAN_NO, MAX(PLAN_REV_NO) PRN FROM TMS_PLAN GROUP BY PLAN_NO ' +
              '   ) A JOIN ' +
              '   ( ' +
              '     SELECT PLAN_NO, PLAN_REV_NO, PLAN_NAME FROM TMS_PLAN ' +
              '   ) B ' +
              '   ON A.PLAN_NO = B.PLAN_NO ' +
              '   AND A.PRN = B.PLAN_REV_NO ' +
              ') WHERE TASK_NO LIKE :param1 ');
      ParamByName('param1').AsString := aTaskNo;
      Open;

      Result := FieldByName('TASK_NAME').AsString;

    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure TtaskStatistics_Frm.grid_PlanCodeCellColoring(Sender: TObject; ACol,
  ARow: Integer; var CellColor, GridColor: TColor; CellState: TCellState);
begin
  if (ARow mod 2) = 0 then
    CellColor := $00DFDFDF
  else
    CellColor := clWhite;

end;

procedure TtaskStatistics_Frm.JvLabel7Click(Sender: TObject);
var
  LGrid : TNextGrid;
begin
  if Sender is TJvLabel then
  begin
    with Sender as TJvLabel do
    begin
      if Caption = '계획코드별 투입 MH' then
        LGrid := grid_PlanCode
      else if Caption = '실적코드별 투입 MH' then
        LGrid := grid_rstCode
      else if Caption = '인원별 투입 MH' then
        LGrid := grid_user
      else if Caption = '업무별 투입 MH' then
        LGrid := grid_plan
      else if Caption = '엔진모델별 투입 MH' then
        LGrid := grid_model
      else if Caption = '엔진타입별 투입 MH' then
        LGrid := grid_type
      else if Caption = '엔진공사별 투입 MH' then
        LGrid := grid_proj;

      if (LGrid <> nil) And (LGrid.RowCount > 0) then
        Create_statsticsChart_Frm(Caption, LGrid);

    end;
  end;
end;

procedure TtaskStatistics_Frm.rg_periodClick(Sender: TObject);
begin
  dt_begin.Enabled := False;
  dt_end.Enabled   := False;
  case rg_period.ItemIndex of
    0 :
    begin
      dt_begin.Date := Now;
      dt_end.Date   := Now;
    end;
    1 :
    begin
      dt_begin.Date := StartOfTheWeek(Now);
      dt_end.Date   := EndOfTheWeek(Now);
    end;
    2 :
    begin
      dt_begin.Date := StartOfTheMonth(Now);
      dt_end.Date   := EndOfTheMonth(Now);
    end;
    3 :
    begin
      dt_begin.Enabled := True;
      dt_end.Enabled   := True;
    end;
  end;
end;

end.


{
업무별
procedure TtaskStatistics_Frm.tc_planDropDown(Sender: TObject;
  var acceptdrop: Boolean);
var
  i : Integer;
  lnode : TTreeNode;
begin

  if cb_team.Text = '' then
    Exit;

  tc_plan.Enabled := False;
  tc_plan.Selection := -1;
  with tc_plan.Items do
  begin
    BeginUpdate;
    try
      Clear;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM ' +
                '( ' +
                '   SELECT * FROM ' +
                '   ( ' +
                '       SELECT TASK_NO, TASK_PRT, TASK_LV, TASK_NAME, ''T'' TYPE FROM ' +
                '       ( ' +
                '           SELECT * FROM TMS_TASK ' +
                '           START WITH TASK_NO IN ' +
                '           ( ' +
                '               SELECT TASK_NO FROM ' +
                '               ( ' +
                '                   SELECT * FROM ' +
                '                   (SELECT PLAN_NO PN, MAX(PLAN_REV_NO) PRN FROM TMS_PLAN GROUP BY PLAN_NO) A, ' +
                '                   (SELECT A.*, B.PLAN_EMPNO, B.PLAN_TEAM FROM TMS_PLAN A, TMS_PLAN_INCHARGE B ' +
                '                   WHERE A.PLAN_NO = B.PLAN_NO ' +
                '                   AND A.PLAN_REV_NO = B.PLAN_REV_NO ) B ' +
                '                   WHERE A. PN = B.PLAN_NO ' +
                '                   AND A.PRN = B.PLAN_REV_NO ' +
                '                   AND PLAN_TEAM LIKE :DEPT_CD ' +
                '                   AND PLAN_EMPNO LIKE :PLAN_EMPNO ' +
                '                   AND ENG_MODEL LIKE :ENG_MODEL ' +
                '                   AND ENG_TYPE LIKE :ENG_TYPE ' +
                '                   AND ENG_PROJNO LIKE :ENG_PROJNO ' +
                '               ) GROUP BY TASK_NO ' +
                '           ) ' +
                '           CONNECT BY PRIOR TASK_PRT = TASK_NO ' +
                '       ) UNION ALL ' +
                '       ( ' +
                '           SELECT PLAN_NO, TASK_NO, PRN, PLAN_NAME, ''P'' TYPE FROM ' +
                '           (SELECT PLAN_NO PN, MAX(PLAN_REV_NO) PRN FROM TMS_PLAN GROUP BY PLAN_NO) A,' +
                '           (SELECT A.*, B.PLAN_EMPNO, B.PLAN_TEAM FROM TMS_PLAN A, TMS_PLAN_INCHARGE B ' +
                '           WHERE A.PLAN_NO = B.PLAN_NO ' +
                '           AND A.PLAN_REV_NO = B.PLAN_REV_NO ) B ' +
                '           WHERE A. PN = B.PLAN_NO ' +
                '           AND A.PRN = B.PLAN_REV_NO ' +
                '           AND PLAN_TEAM LIKE :DEPT_CD ' +
                '           AND PLAN_EMPNO LIKE :PLAN_EMPNO ' +
                '           AND ENG_MODEL LIKE :ENG_MODEL ' +
                '           AND ENG_TYPE LIKE :ENG_TYPE ' +
                '           AND ENG_PROJNO LIKE :ENG_PROJNO ' +
                '       ) ' +
                '   ) GROUP BY TASK_NO, TASK_PRT, TASK_LV, TASK_NAME, TYPE ' +
                ') START WITH TASK_PRT IS NULL ' +
                'CONNECT BY PRIOR TASK_NO = TASK_PRT ');

        if cb_engModel.Text <> '' then
          ParamByName('ENG_MODEL').AsString := cb_engModel.Text
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND ENG_MODEL LIKE :ENG_MODEL ', '' );

        if cb_engType.Text <> '' then
          ParamByName('ENG_TYPE').AsString := cb_engType.Text
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND ENG_TYPE LIKE :ENG_TYPE ', '' );

        if cb_engProjNo.Text <> '' then
          ParamByName('ENG_PROJNO').AsString := cb_engProjNo.Text
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND ENG_PROJNO LIKE :ENG_PROJNO ', '' );

        if cb_team.Hint <> '' then
          ParamByName('DEPT_CD').AsString := '%'+cb_team.Hint+'%'
        else
          ParamByName('DEPT_CD').AsString := '%'+CurrentUsersDept+'%';

        if cb_user.Hint <> '' then
          ParamByName('PLAN_EMPNO').AsString := cb_user.Hint
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND PLAN_EMPNO LIKE :PLAN_EMPNO ', '' );

        Open;

        if RecordCount <> 0 then
        begin
          if Assigned(FtaskDic) then
            FtaskDic.Clear
          else
            FtaskDic := TDictionary<String,TTreeNode>.Create;

          while not eof do
          begin
            if FtaskDic.Count = 0 then
              lnode := Add(nil, FieldByName('TASK_NAME').AsString)
            else
            begin
              if FtaskDic.TryGetValue(FieldByName('TASK_PRT').AsString, lnode) then
                lnode := AddChild(lnode, FieldByName('TASK_NAME').AsString)
              else
                lnode := Add(nil, FieldByName('TASK_NAME').AsString);
            end;

            if not(FtaskDic.ContainsKey(FieldByName('TASK_NO').AsString)) then
              FtaskDic.Add(FieldByName('TASK_NO').AsString,lnode);

            Next;
          end;

          for i := 0 to Count-1 do
            item[i].Expand(True);

        end;
      end;
    finally
      tc_plan.Enabled := True;
      EndUpdate;
    end;
  end;
end;
}
