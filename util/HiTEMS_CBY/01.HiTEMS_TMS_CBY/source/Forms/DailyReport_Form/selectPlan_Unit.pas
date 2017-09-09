unit selectPlan_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, NxCollection,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, AdvGlowButton, Vcl.StdCtrls, GradientLabel, AdvScrollBox,
  Vcl.CheckLst, TodoList, AdvSmoothPanel, Vcl.Imaging.jpeg, NxEdit,
  Vcl.ComCtrls, AdvPanel, Ora, DateUtils, StrUtils,System.Generics.Collections;

type
  TselectPlan_Frm = class(TForm)
    Panel2: TPanel;
    regBtn: TAdvGlowButton;
    AdvGlowButton1: TAdvGlowButton;
    Panel5: TPanel;
    Image1: TImage;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    taskGrid: TNextGrid;
    NxTextColumn1: TNxTextColumn;
    NxTreeColumn1: TNxTreeColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn4: TNxTextColumn;
    NxTextColumn6: TNxTextColumn;
    NxProgressColumn2: TNxProgressColumn;
    NxTextColumn11: TNxTextColumn;
    NxTextColumn13: TNxTextColumn;
    NxSplitter1: TNxSplitter;
    planGrid: TNextGrid;
    NxIncrementColumn2: TNxIncrementColumn;
    NxTextColumn7: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    NxTextColumn10: TNxTextColumn;
    NxComboBoxColumn1: TNxComboBoxColumn;
    NxTextColumn14: TNxTextColumn;
    NxTextColumn15: TNxTextColumn;
    NxTextColumn8: TNxTextColumn;
    NxTextColumn9: TNxTextColumn;
    NxTextColumn12: TNxTextColumn;
    NxDateColumn4: TNxDateColumn;
    NxDateColumn3: TNxDateColumn;
    NxProgressColumn1: TNxProgressColumn;
    NxImageColumn1: TNxImageColumn;
    NxHeaderPanel1: TNxHeaderPanel;
    Panel1: TPanel;
    Label2: TLabel;
    FieldList: TCheckListBox;
    bussGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn16: TNxTextColumn;
    NxTextColumn17: TNxTextColumn;
    NxTextColumn21: TNxTextColumn;
    NxTextColumn19: TNxTextColumn;
    NxTextColumn20: TNxTextColumn;
    NxDateColumn1: TNxDateColumn;
    NxDateColumn2: TNxDateColumn;
    NxProgressColumn3: TNxProgressColumn;
    NxSplitter2: TNxSplitter;
    NxHeaderPanel2: TNxHeaderPanel;
    AdvSmoothPanel2: TAdvSmoothPanel;
    AdvScrollBox1: TAdvScrollBox;
    GradientLabel1: TGradientLabel;
    taskName: TLabel;
    engModel: TLabel;
    engType: TLabel;
    startdate: TLabel;
    endDate: TLabel;
    exmh: TLabel;
    progress: TLabel;
    GradientLabel2: TGradientLabel;
    planName: TLabel;
    pic: TLabel;
    pstart: TLabel;
    pend: TLabel;
    pexmh: TLabel;
    pprogress: TLabel;
    pindate: TLabel;
    pdrafter: TLabel;
    outline: TLabel;
    pDesc: TLabel;
    taskCode: TLabel;
    Panel3: TPanel;
    AdvGlowButton2: TAdvGlowButton;
    AdvGlowButton3: TAdvGlowButton;
    NxNumberColumn1: TNxNumberColumn;
    NxNumberColumn2: TNxNumberColumn;
    procedure AdvGlowButton1Click(Sender: TObject);
    procedure regBtnClick(Sender: TObject);
    procedure bussGridCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure FormCreate(Sender: TObject);
    procedure taskGridSelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure planGridCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure planGridSelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure bussGridSelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure FieldListClickCheck(Sender: TObject);
    procedure bussGridCellClick(Sender: TObject; ACol, ARow: Integer);
    procedure AdvGlowButton2Click(Sender: TObject);
    procedure AdvGlowButton3Click(Sender: TObject);
  private
    { Private declarations }
    FxRow:Integer;
    FPerform : TDateTime;
    FselectedPlan : String;
  public
    { Public declarations }

    procedure Get_HiTEMS_TMS_TASK;

    procedure Get_HiTEMS_TMS_PLAN(aTask_No:String);
    function Check_Incharge(aPlan_No,aRev_No:String) : Integer;

    //Page1
    procedure Clear_Label_Caption;
    procedure Set_bussGrid;
    procedure Set_TaskInfo(aTask_No:String);
    procedure Set_PlanInfo(aPlan_No:String);
  end;

var
  selectPlan_Frm : TselectPlan_Frm;
  function Create_selectPlan_Frm(aPerform:TDateTime):String;

implementation
uses
  CommonUtil_Unit,
  HITEMS_TMS_COMMON,
  HITEMS_TMS_CONST,
  DataModule_Unit;

{$R *.dfm}

{ TForm1 }
function Create_selectPlan_Frm(aPerform:TDateTime):String;
var
  lplanNo,lrevNo:String;
begin
  selectPlan_Frm := TselectPlan_Frm.Create(nil);
  try
    with selectPlan_Frm do
    begin
      FPerform := aPerform;
      Get_HiTEMS_TMS_TASK;
      Set_bussGrid;

      ShowModal;

      if ModalResult = mrOk then
      begin
        Result := FselectedPlan;
      end;
    end;
  finally
    FreeAndNil(selectPlan_Frm);
  end;
end;

procedure TselectPlan_Frm.AdvGlowButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TselectPlan_Frm.AdvGlowButton2Click(Sender: TObject);
var
  li : Integer;
begin
  with taskGrid do
  begin
    BeginUpdate;
    try
      for li := 0 to RowCount-1 do
      begin
        if GetFirstChild(li) > 0 then
          Expanded[li] := True;

      end;
    finally
      ScrollToRow(SelectedRow);
      EndUpdate;
    end;
  end;
end;

procedure TselectPlan_Frm.AdvGlowButton3Click(Sender: TObject);
var
  li : Integer;
begin
  with taskGrid do
  begin
    BeginUpdate;
    try
      for li := 0 to RowCount-1 do
      begin
        if GetFirstChild(li) > 0 then
          Expanded[li] := False;

      end;
    finally
      ScrollToRow(SelectedRow);
      EndUpdate;
    end;
  end;
end;

procedure TselectPlan_Frm.bussGridCellClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  if ARow > -1 then
  begin
    with bussGrid do
    begin
      Set_TaskInfo(Cells[2,ARow]);
      Set_PlanInfo(Cells[3,ARow]);
    end;
  end;
end;

procedure TselectPlan_Frm.bussGridCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
var
  lplanNo,lrevNo : String;
begin
  if ARow <> -1 then
  begin
    lplanNo := bussGrid.Cells[3,FxRow];
    lrevNo := bussGrid.Cells[9,FxRow];

    if Check_Incharge(lplanNo,lrevNo) > 0 then
    begin
      FselectedPlan := lplanNo+';'+lrevNo;
      ModalResult := mrOk
    end
    else
      ShowMessage('선택된 업무의 담당자가 아닙니다.');
  end
  else
    ShowMessage('선택된 업무가 없습니다!');
end;

procedure TselectPlan_Frm.bussGridSelectCell(Sender: TObject; ACol,
  ARow: Integer);
begin
  with bussGrid do
  begin
    FxRow := ARow;
    try
      Set_TaskInfo(Cells[2,ARow]);
      Set_PlanInfo(Cells[3,ARow]);
    finally
      AdvSmoothPanel2.Invalidate;
    end;
  end;
end;

function TselectPlan_Frm.Check_Incharge(aPlan_No,aRev_No:String) : Integer;
var
  OraQuery : TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := DM1.OraSession1;
  try
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM TMS_PLAN_INCHARGE ' +
              'WHERE PLAN_NO = :param1 ' +
              'AND PLAN_REV_NO = :param2 ' +
              'AND PLAN_EMPNO = :param3 ');

      ParamByName('param1').AsString := aPlan_No;
      ParamByName('param2').AsString := aRev_No;
      ParamByName('param3').AsString := DM1.FUserInfo.CurrentUsers;
      Open;

      Result := RecordCount;

    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure TselectPlan_Frm.Clear_Label_Caption;
var
  li : Integer;
begin
  for li := 0 to Self.ComponentCount-1 do
  begin
    if (Components[li] is TLabel) then
      TLabel(Components[li]).Caption := '';

  end;

  GradientLabel1.Caption := '일정 정보';
  GradientLabel2.Caption := '세부 계획 정보';
end;

procedure TselectPlan_Frm.FieldListClickCheck(Sender: TObject);
var
  Chk : Boolean;
begin
  Chk := FieldList.Checked[FieldList.ItemIndex];

  with bussGrid do
  begin
    BeginUpdate;
    try
      case FieldList.ItemIndex of
        0 : if not(Chk) then
              Columns[0].Width := 0
            else
              Columns[0].Width := 30;

        1 : if not(Chk) then
              Columns[1].Width := 0
            else
              Columns[1].Width := 80;

        2 : if not(Chk) then
              Columns[2].Width := 0
            else
              Columns[2].Width := 80;

        3 : if not(Chk) then
              Columns[3].Width := 0
            else
              Columns[3].Width := 80;

        4 : if not(Chk) then
              Columns[4].Width := 0
            else
              Columns[4].Width := 80;

        5 : if not(Chk) then
              Columns[5].Width := 0
            else
              Columns[5].Width := 150;

        6 : if not(Chk) then
              Columns[6].Width := 0
            else
              Columns[6].Width := 300;

        7 : if not(Chk) then
              Columns[7].Width := 0
            else
              Columns[7].Width := 80;

        8 : if not(Chk) then
              Columns[8].Width := 0
            else
              Columns[8].Width := 80;

        9 : if not(Chk) then
              Columns[9].Width := 0
            else
              Columns[9].Width := 80;

      end;
    finally
      Invalidate;
      EndUpdate;

    end;
  end;
end;

procedure TselectPlan_Frm.FormCreate(Sender: TObject);
var
  i : Integer;
begin
  //page0
  taskGrid.DoubleBuffered := False;
  planGrid.DoubleBuffered := False;

  PageControl1.ActivePageIndex := 0;

  //Page1
  Clear_Label_Caption;
  FieldList.Checked[0] := True;
  FieldList.Checked[1] := True;
  FieldList.Checked[4] := True;
  FieldList.Checked[5] := True;
  FieldList.Checked[6] := True;
  FieldList.Checked[7] := True;
  FieldList.Checked[8] := True;

end;

procedure TselectPlan_Frm.Get_HiTEMS_TMS_TASK;
begin
  TThread.Queue(nil,
  procedure
  const
    Query = 'SELECT * FROM' +
            '( ' +
            '    SELECT  ' +
            '       A.TASK_NO, TASK_PRT, TASK_LV, TASK_NAME, EXD_TASK_START, ' +
            '       EXD_TASK_END, EXD_MH, ACT_TASK_START, ACT_TASK_END, ' +
            '       ACT_PROGRESS, TASK_OUTLINE, TASK_MANAGER, ' +
            '       TASK_DRAFTER, TASK_INDATE, TASK_ORDER, TASK_STATE, ' +
            '       TASK_TEAM, DRAFTER_NAME, MANAGER_NAME ' +
            '    FROM ' +
            '    ( ' +
            '       SELECT ' +
            '         A.TASK_NO, TASK_PRT, TASK_LV, TASK_NAME, EXD_TASK_START, ' +
            '         EXD_TASK_END, EXD_MH, ACT_TASK_START, ACT_TASK_END, ' +
            '         ACT_PROGRESS, TASK_OUTLINE, TASK_MANAGER, TASK_DRAFTER, ' +
            '         TASK_INDATE, TASK_ORDER, TASK_STATE, TASK_TEAM, DRAFTER_NAME ' +
            '       FROM ' +
            '       ( ' +
            '           SELECT ' +
            '             A.TASK_NO, TASK_PRT, TASK_LV, TASK_NAME, ' +
            '             EXD_TASK_START, EXD_TASK_END, EXD_MH, ACT_TASK_START, ' +
            '             ACT_TASK_END, ACT_PROGRESS, TASK_OUTLINE, TASK_MANAGER, ' +
            '             TASK_DRAFTER, TASK_INDATE, TASK_ORDER, TASK_STATE, TASK_TEAM ' +
            '           FROM TMS_TASK A, TMS_TASK_SHARE B ' +
            '           WHERE  ' +
            '           ( ' +
            '             ( ' +
            '               TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :beginDate  ' +
            '               AND EXD_TASK_END >= TO_DATE(:beginDate, ''yyyy-mm-dd'')  ' +
            '                AND TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :endDate  ' +
            '                 AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') <= :endDate  ' +
            '                OR EXD_TASK_START >= TO_DATE(:beginDate, ''yyyy-mm-dd'')  ' +
            '                AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') >= :beginDate  ' +
            '                AND TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :endDate  ' +
            '                 AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') <= :endDate  ' +
            '                 OR TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') >= :beginDate  ' +
            '                AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') >= :beginDate  ' +
            '                 AND TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :endDate  ' +
            '                 AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') >= :endDate  ' +
            '                 OR TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :beginDate  ' +
            '                 AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') >= :beginDate  ' +
            '                 AND TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :endDate  ' +
            '                AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') >= :endDate ' +
            '            ) ' +
            '            OR ' +
            '            ( ' +
            '               (EXD_TASK_START IS NULL) OR (EXD_TASK_END IS NULL) ' +
            '            ) ' +
            '          ) ' +
            '          AND A.TASK_NO = B.TASK_NO  ' +
            '          AND SUBSTR(TASK_TEAM, 1, 4) = :team  ' +
            '       ) A JOIN ' +
            '       ( ' +
            '           SELECT USERID, NAME_KOR DRAFTER_NAME FROM HITEMS_USER ' +
            '       ) B ' +
            '       ON A.TASK_DRAFTER = B.USERID ' +
            '    ) A LEFT OUTER JOIN ' +
            '    ( ' +
            '       SELECT USERID, NAME_KOR MANAGER_NAME FROM HITEMS_USER ' +
            '    ) B ' +
            '    ON A.TASK_MANAGER = B.USERID ' +
            ') '+
            'START WITH TASK_PRT IS NULL ' +
            'CONNECT BY PRIOR TASK_NO = TASK_PRT ' +
            'ORDER SIBLINGS BY TASK_ORDER ';
  var
    OraQuery : TOraQuery;
    str,
    lkey,
    lteam,
    ltaskNo : string;
    i,lrow : Integer;
    ldic : TDictionary<string,integer>;
  begin
    with taskGrid do
    begin
      BeginUpdate;
      try
        ClearRows;
        with DM1.OraQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add(Query);
          ParamByName('beginDate').AsString := FormatDateTime('yyyy-MM-dd',StartOfTheMonth(today));
          ParamByName('endDate').AsString   := FormatDateTime('yyyy-MM-dd',EndOfTheMonth(today));
          ParamByName('team').AsString  := LeftStr(DM1.FUserInfo.CurrentUsersTeam,4);
          Open;

          if RecordCount <> 0 then
          begin
            ldic := TDictionary<string,integer>.Create;
            try
              while not eof do
              begin
                if ldic.Count = 0 then
                  lrow := AddRow
                else
                begin
                  if ldic.ContainsKey(FieldByName('TASK_PRT').AsString) then
                  begin
                    ldic.TryGetValue(FieldByName('TASK_PRT').AsString,i);
                    AddChildRow(i,crLast);
                    lrow := LastAddedRow;
                  end else
                  begin
                    lrow := AddRow;
                  end;
                end;

                ldic.Add(FieldByName('TASK_NO').AsString,lrow);

                if lrow > -1 then
                begin
                  Cells[0,lrow] := FieldByName('TASK_NO').AsString;
                  Cells[1,lrow] := FieldByName('TASK_NAME').AsString;

                  if not FieldByName('EXD_TASK_START').IsNull then
                    Cell[2,lrow].AsDateTime := FieldByName('EXD_TASK_START').AsDateTime;

                  if not FieldByName('EXD_TASK_END').IsNull then
                    Cell[3,lrow].AsDateTime := FieldByName('EXD_TASK_END').AsDateTime;

                  if not FieldByName('ACT_TASK_START').IsNull then
                    Cell[4,lrow].AsDateTime := FieldByName('ACT_TASK_START').AsDateTime;

                  if not FieldByName('ACT_TASK_END').IsNull then
                    Cell[5,lrow].AsDateTime := FieldByName('ACT_TASK_END').AsDateTime;

                  Cell[6,lrow].AsInteger := FieldByName('ACT_PROGRESS').AsInteger;
                  Cells[7,lrow] := FieldByName('MANAGER_NAME').AsString;
                  Cells[8,lrow] := FieldByName('DRAFTER_NAME').AsString;

                end;
                Next;
              end;
            finally
              FreeAndNil(ldic);
              FreeAndNil(OraQuery);
            end;
          end;
        end;
      finally
        EndUpdate;
      end;
    end;
  end);
end;

procedure TselectPlan_Frm.Get_HiTEMS_TMS_PLAN(aTask_No: String);
var
  lrow : Integer;
begin
  if aTask_NO <> '' then
  begin
    with planGrid do
    begin
      BeginUpdate;
      try
        ClearRows;
        with DM1.OraQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT * FROM ' +
                  '( ' +
                  '   SELECT ' +
                  '     A.PLAN_NO, REV_NO, PLAN_CODE, PLAN_TYPE, PLAN_NAME, PLAN_OUTLINE, ' +
                  '     ENG_MODEL, ENG_TYPE, ENG_PROJNO, PLAN_START, PLAN_END, PLAN_MH, ' +
                  '     PLAN_PROGRESS, PLAN_DRAFTER, PLAN_INDATE ' +
                  '   FROM ' +
                  '   ( ' +
                  '       SELECT PLAN_NO, MAX(PLAN_REV_NO) REV_NO FROM TMS_PLAN ' +
                  '       WHERE TASK_NO = :TASK_NO ' +
                  '       GROUP BY PLAN_NO ' +
                  '   ) A LEFT OUTER JOIN ' +
                  '   ( ' +
                  '       SELECT * FROM TMS_PLAN ' +
                  '   ) B ' +
                  '   ON A.PLAN_NO = B.PLAN_NO ' +
                  '   AND A.REV_NO = B.PLAN_REV_NO ' +
                  '   AND PLAN_PROGRESS <> 100 ' +
                  ') A INNER JOIN ' +
                  '( ' +
                  '   SELECT GRP_NO, CODE_NAME FROM HITEMS_CODE_GROUP ' +
                  ') B ' +
                  'ON A.PLAN_CODE = B.GRP_NO ' +
                  'ORDER BY PLAN_NAME, PLAN_START ');

          ParamByName('TASK_NO').AsString := aTask_NO;

          Open;

          while not eof do
          begin
            lrow := AddRow;

            Cells[1,lrow] := aTask_NO;
            Cells[2,lrow] := FieldByName('PLAN_NO').AsString;
            Cells[3,lrow] := FieldByName('PLAN_CODE').AsString;
            Cells[4,lrow] := NxComboBoxColumn1.Items.Strings[FieldByName('PLAN_TYPE').AsInteger];
            Cells[5,lrow] := FieldByName('ENG_MODEL').AsString;
            Cells[6,lrow] := FieldByName('ENG_TYPE').AsString;

            Cells[7,lrow] := FieldByName('CODE_NAME').AsString;
            Cells[8,lrow] := FieldByName('PLAN_NAME').AsString;
            Cells[9,lrow] := Get_Plan_InCharge(Cells[2,lrow],FieldByName('REV_NO').AsString,'');
            if not FieldByName('PLAN_START').IsNull then
              Cells[10,lrow] := FieldByName('PLAN_START').AsString
            else
              Cells[10,lrow] := '';

            if not FieldByName('PLAN_END').IsNull then
              Cells[11,lrow] := FieldByName('PLAN_END').AsString
            else
              Cells[11,lrow] := '';

            Cell[12,lrow].AsInteger := FieldByName('PLAN_PROGRESS').AsInteger;

            if Get_AttfilesCount(Cells[2,lrow]) > 0 then
              Cell[13,lrow].AsInteger := 39
            else
              Cell[13,lrow].AsInteger := -1;

            Cell[14,lrow].AsInteger := FieldByName('REV_NO').AsInteger;

//            if (Cell[12,lrow].AsInteger = 100) and (rb_hide.Checked = True) then
//              row[lRow].Visible := False;


            Next;
          end;
        end;
      finally
        EndUpdate;
      end;
    end;
  end;
end;

procedure TselectPlan_Frm.regBtnClick(Sender: TObject);
var
  lplanNo,lrevNo : String;
begin
  if FxRow <> -1 then
  begin
    case PageControl1.ActivePageIndex of
      0 :
      begin
        lplanNo := planGrid.Cells[2,FxRow];
        lrevNo  := planGrid.Cells[14,FxRow];
      end;

      1 :
      begin
        lplanNo := bussGrid.Cells[3,FxRow];
        lrevNo := bussGrid.Cells[9,FxRow];
      end;
    end;

    if Check_Incharge(lplanNo,lrevNo) > 0 then
    begin
      FselectedPlan := lplanNo+';'+lrevNo;
      ModalResult := mrOk
    end
    else
      ShowMessage('선택된 업무의 담당자가 아닙니다.');
  end
  else
    ShowMessage('선택된 업무가 없습니다!');
end;

procedure TselectPlan_Frm.taskGridSelectCell(Sender: TObject; ACol,
  ARow: Integer);
begin
  if ARow <> -1 then
  begin
    Get_HiTEMS_TMS_PLAN(taskGrid.Cells[0,ARow]);

  end else
  begin
    FselectedPlan := '';
    planGrid.ClearRows;
  end;
end;

procedure TselectPlan_Frm.Set_bussGrid;
var
  lrow : Integer;
begin
  with bussGrid do
  begin
    BeginUpdate;
    try
      ClearRows;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM ' +
                '(' +
                '   SELECT * FROM ' +
                '   (                 ' +
                '       SELECT B.* FROM   ' +
                '       ( ' +
                '           SELECT PLAN_NO, MAX(PLAN_REV_NO) REV_NO ' +
                '           FROM TMS_PLAN  GROUP BY PLAN_NO ' +
                '       ) A,  ' +
                '       (  ' +
                '           SELECT * FROM ' +
                '           ( ' +
                '               SELECT A.*, B.PLAN_EMPNO, PLAN_TEAM ' +
                '               FROM TMS_PLAN A, TMS_PLAN_INCHARGE B ' +
                '               WHERE A.PLAN_NO = B.PLAN_NO  ' +
                '               AND A.PLAN_REV_NO = B.PLAN_REV_NO ' +
                '           ) A LEFT OUTER JOIN ' +
                '           ( ' +
                '               SELECT CODE_NAME, GRP_NO FROM HITEMS_CODE_GROUP ' +
                '           ) B ' +
                '           ON A.PLAN_CODE = B.GRP_NO ' +
                '       ) B  ' +
                '       WHERE A.PLAN_NO = B.PLAN_NO  ' +
                '       AND A.REV_NO = B.PLAN_REV_NO  ' +
                '   ) ' +
                '   WHERE  ' +
                '   ( ' +
                '       TO_CHAR(PLAN_START, ''yyyy-mm-dd'') <= :beginDate  ' +
                '       AND TO_CHAR(PLAN_END, ''yyyy-mm-dd'') >= :beginDate  ' + //TO_DATE(:beginDate, ''yyyy-mm-dd'')  ' +
                '       AND TO_CHAR(PLAN_START, ''yyyy-mm-dd'') <= :endDate  ' +
                '       AND TO_CHAR(PLAN_END, ''yyyy-mm-dd'') <= :endDate ' +
                '       OR TO_CHAR(PLAN_START, ''yyyy-mm-dd'') >= :beginDate  ' + // ' +TO_DATE(:beginDate, ''yyyy-mm-dd'') ' +
                '       AND TO_CHAR(PLAN_END, ''yyyy-mm-dd'') >= :beginDate ' +
                '       AND TO_CHAR(PLAN_START, ''yyyy-mm-dd'') <= :endDate ' +
                '       AND TO_CHAR(PLAN_END, ''yyyy-mm-dd'') <= :endDate ' +
                '       OR TO_CHAR(PLAN_START, ''yyyy-mm-dd'') >= :beginDate ' +
                '       AND TO_CHAR(PLAN_END, ''yyyy-mm-dd'') >= :beginDate ' +
                '       AND TO_CHAR(PLAN_START, ''yyyy-mm-dd'') <= :endDate ' +
                '       AND TO_CHAR(PLAN_END, ''yyyy-mm-dd'') >= :endDate ' +
                '       OR TO_CHAR(PLAN_START, ''yyyy-mm-dd'') <= :beginDate ' +
                '       AND TO_CHAR(PLAN_END, ''yyyy-mm-dd'') >= :beginDate ' +
                '       AND TO_CHAR(PLAN_START, ''yyyy-mm-dd'') <= :endDate ' +
                '       AND TO_CHAR(PLAN_END, ''yyyy-mm-dd'') >= :endDate ' +
                '   ) ' +
                ') ' +
                'WHERE PLAN_EMPNO = :empNo ' +
                'ORDER BY PLAN_START ');

        ParamByName('beginDate').AsString := FormatDateTime('yyyy-MM-dd',StartOfTheMonth(FPerform));
        ParamByName('endDate').AsString   := FormatDateTime('yyyy-MM-dd',EndOfTheMonth(FPerform));
        ParamByName('empNo').AsString     := DM1.FUserInfo.CurrentUsers;
        Open;

        if not(RecordCount = 0) then
        begin
          while not eof do
          begin
            lrow := AddRow;
            Cells[1,lrow]           := FieldByName('ENG_TYPE').AsString;
            Cells[2,lrow]           := FieldByName('TASK_NO').AsString;
            Cells[3,lrow]           := FieldByName('PLAN_NO').AsString;
            Cells[4,lrow]           := FieldByName('CODE_NAME').AsString;

            Cells[5,lrow]           := FieldByName('PLAN_NAME').AsString;
            Cell[6,lrow].AsDateTime := FieldByName('PLAN_START').AsDateTime;
            Cell[7,lrow].AsDateTime := FieldByName('PLAN_END').AsDateTime;
            Cell[8,lrow].AsInteger  := FieldByName('PLAN_PROGRESS').AsInteger;
            Cell[9,lrow].AsInteger  := FieldByName('PLAN_REV_NO').AsInteger;
            Next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TselectPlan_Frm.Set_PlanInfo(aPlan_No: String);
var
  lstr : String;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM TMS_PLAN ' +
            'WHERE PLAN_NO = :param1 ');
    ParamByName('param1').AsString := aPlan_No;
    Open;

    if not(RecordCount = 0) then
    begin
      if FieldByName('PLAN_CODE').IsNull then
        taskCode.Caption := ''
      else
//        taskCode.Caption := '업무구분 : '+#10#13+Get_PlanCodeName(FieldByName('PLAN_CODE').AsString);

      if FieldByName('PLAN_NAME').IsNull then
        planName.Caption := ''
      else
        planName.Caption := '주요업무 : '+#10#13+FieldByName('PLAN_NAME').AsString;

      lstr := Get_Plan_InCharge(aPlan_No,FieldByName('PLAN_REV_NO').AsString,'');
      if lstr <> '' then
        pic.Caption := ''
      else
        pic.Caption := '담당자 : '+ lstr;

      if FieldByName('PLAN_START').IsNull then
        pStart.Caption := ''
      else
        pStart.Caption := '시작일 : '+
        FormatDateTime('YYYY-MM-DD', FieldByName('PLAN_START').AsDateTime);

      if FieldByName('PLAN_END').IsNull then
        pEnd.Caption := ''
      else
        pEnd.Caption := '종료일 : '+
        FormatDateTime('YYYY-MM-DD', FieldByName('PLAN_END').AsDateTime);

      if FieldByName('PLAN_MH').AsInteger <> 0 then
        pexmh.Caption := '예상M/H : '+ FieldByName('PLAN_MH').AsString
      else
        pexmh.Caption := '';

      if FieldByName('PLAN_PROGRESS').AsInteger <> 0 then
        pprogress.Caption := '진행율(%) : '+ FieldByName('PLAN_PROGRESS').AsString
      else
        pprogress.Caption := '';

      if FieldByName('PLAN_INDATE').IsNull then
        pindate.Caption := ''
      else
        pindate.Caption := '기안일 : '+
        FormatDateTime('YYYY-MM-DD', FieldByName('PLAN_INDATE').AsDateTime);

      if FieldByName('PLAN_DRAFTER').IsNull then
        pdrafter.Caption := ''
      else
        pdrafter.Caption := '기안자 : '+ Get_UserName(FieldByName('PLAN_DRAFTER').AsString);

      if FieldByName('ENG_MODEL').IsNull then
        engModel.Caption := ''
      else
        engModel.Caption := '엔진모델 : '+FieldByName('ENG_MODEL').AsString;

      if FieldByName('ENG_TYPE').IsNull then
        engType.Caption := ''
      else
        engType.Caption := '엔진모델 : '+FieldByName('ENG_TYPE').AsString;

    end;
  end;
end;


procedure TselectPlan_Frm.Set_TaskInfo(aTask_NO: String);
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from TMS_TASK ' +
            'where TASK_NO = '+aTask_NO );
    Open;

    if not(RecordCount = 0) then
    begin
      if FieldByName('TASK_NAME').IsNull then
        taskName.Caption := ''
      else
        taskName.Caption := '업무명 : '+#10#13+FieldByName('TASK_NAME').AsString;

      if FieldByName('TASK_OUTLINE').IsNull then
        outline.Caption := ''
      else
        outline.Caption := '업무개요 : '+#10#13+FieldByName('TASK_OUTLINE').AsString;

      if FieldByName('EXD_TASK_START').IsNull then
        startdate.Caption := ''
      else
        startdate.Caption := '예상 시작일 : '+
        FormatDateTime('YYYY-MM-DD', FieldByName('EXD_TASK_START').AsDateTime);

      if FieldByName('EXD_TASK_END').IsNull then
        endDate.Caption := ''
      else
        endDate.Caption := '예상 종료일 : '+
        FormatDateTime('YYYY-MM-DD', FieldByName('EXD_TASK_END').AsDateTime);

      if FieldByName('EXD_MH').AsInteger <> 0 then
        exmh.Caption := '예상M/H : '+ FieldByName('EXD_MH').AsString
      else
        exmh.Caption := '';

      if FieldByName('ACT_PROGRESS').AsInteger <> 0 then
        exmh.Caption := '진행율(%) : '+ FieldByName('ACT_PROGRESS').AsString
      else
        exmh.Caption := '';

    end;
  end;
end;
procedure TselectPlan_Frm.planGridCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
var
  lplanNo, lrevNo : String;
begin
  if ARow <> -1 then
  begin
    lplanNo := planGrid.Cells[2,FxRow];
    lrevNo  := planGrid.Cells[14,FxRow];

    if Check_Incharge(lplanNo,lrevNo) > 0 then
    begin
      FselectedPlan := lplanNo+';'+lrevNo;
      ModalResult := mrOk
    end
    else
      ShowMessage('선택된 업무의 담당자가 아닙니다.');
  end
  else
    ShowMessage('선택된 업무가 없습니다!');
end;

procedure TselectPlan_Frm.planGridSelectCell(Sender: TObject; ACol,
  ARow: Integer);
begin
  FxRow := Arow;

end;

end.


