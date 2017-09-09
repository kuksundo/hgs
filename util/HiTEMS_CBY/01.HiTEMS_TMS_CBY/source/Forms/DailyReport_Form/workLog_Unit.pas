unit workLog_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,Ora,
  AdvOfficeTabSet, NxCollection, NxColumnClasses, Vcl.StdCtrls, NxColumns,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.ComCtrls,
  JvExStdCtrls, JvEdit, Vcl.Grids, AdvObj, BaseGrid, AdvGrid, AdvCombo, NxEdit,
  AdvGlowButton, GradientLabel, Vcl.ImgList, AdvSmoothStepControl, DateUtils,
  JvExComCtrls, JvComCtrls, AdvPageControl, NxPageControl, AdvPanel, StrUtils,
  tmsAdvGridExcel, JvExControls, JvLabel, System.Generics.Collections;

type
  TworkLog_Frm = class(TForm)
    Panel8: TPanel;
    Image1: TImage;
    ImageList1: TImageList;
    AdvPanel1: TAdvPanel;
    Label13: TLabel;
    performpicker: TDateTimePicker;
    NxHeaderPanel1: TNxHeaderPanel;
    resultGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn18: TNxTextColumn;
    NxTextColumn4: TNxTextColumn;
    NxDateColumn1: TNxDateColumn;
    NxTextColumn9: TNxTextColumn;
    NxTextColumn15: TNxTextColumn;
    NxMemoColumn1: TNxMemoColumn;
    NxProgressColumn1: TNxProgressColumn;
    NxTextColumn20: TNxTextColumn;
    NxDateColumn2: TNxDateColumn;
    NxTextColumn14: TNxTextColumn;
    RST_PROGRESS: TNxNumberEdit;
    RST_PERFORM: TDateTimePicker;
    RST_TITLE: TNxEdit;
    RST_NOTE: TRichEdit;
    RST_NEXT_PLAN: TRichEdit;
    ENG_TYPE: TNxEdit;
    JvLabel1: TJvLabel;
    JvLabel2: TJvLabel;
    JvLabel3: TJvLabel;
    JvLabel4: TJvLabel;
    JvLabel5: TJvLabel;
    JvLabel6: TJvLabel;
    planName: TComboBox;
    planNo: TEdit;
    revNo: TNxNumberEdit;
    rst_Code: TComboBox;
    NxTextColumn1: TNxTextColumn;
    JvLabel7: TJvLabel;
    RST_TIME_TYPE: TNxComboBox;
    JvLabel8: TJvLabel;
    RST_MH: TNxNumberEdit;
    TeamLabel: TJvLabel;
    cb_part: TComboBox;
    userlabel: TJvLabel;
    cb_users: TComboBox;
    grid_over: TNextGrid;
    NxIncrementColumn2: TNxIncrementColumn;
    NxDateColumn3: TNxDateColumn;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    NxTextColumn6: TNxTextColumn;
    NxTextColumn7: TNxTextColumn;
    NxNumberColumn1: TNxNumberColumn;
    NxTextColumn8: TNxTextColumn;
    Panel1: TPanel;
    AdvGlowButton2: TAdvGlowButton;
    delBtn: TAdvGlowButton;
    regBtn: TAdvGlowButton;
    RST_NO: TNxTextColumn;
    accumulateMh: TNxNumberEdit;
    EngTypeCB: TComboBox;
    Work_Type_Col: TNxTextColumn;
    NxTextColumn10: TNxTextColumn;
    NxTextColumn11: TNxTextColumn;
    NxTextColumn12: TNxTextColumn;
    NxMemoColumn2: TNxMemoColumn;
    NxTextColumn13: TNxTextColumn;
    NxTextColumn16: TNxTextColumn;
    NxTextColumn17: TNxTextColumn;
    procedure FormCreate(Sender: TObject);
    procedure regBtnClick(Sender: TObject);
    procedure delBtnClick(Sender: TObject);
    procedure performpickerChange(Sender: TObject);
    procedure resultGridCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure planNameDropDown(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure planNameSelect(Sender: TObject);
    procedure rst_CodeDropDown(Sender: TObject);
    procedure rst_CodeSelect(Sender: TObject);
    procedure cb_partDropDown(Sender: TObject);
    procedure cb_usersDropDown(Sender: TObject);
    procedure cb_partSelect(Sender: TObject);
    procedure cb_usersSelect(Sender: TObject);
    procedure EngTypeCBDropDown(Sender: TObject);
    procedure grid_overCellDblClick(Sender: TObject; ACol, ARow: Integer);
  private
    { Private declarations }
    FRST_NO : String;
    FcodeDic : TDictionary<Integer,string>;
    FplanDic : TDictionary<Integer,string>;
  public
    FCurrentUserId,
    FCurrentTeam,
    FJobPosition: string;

    procedure Init_;
    //가져오기
    procedure Get_PlanName2(aEngType:string);
    procedure Get_PlanInfo(aPlanNo:string);
    function Get_HiTEMS_TMS_RESULT(aPerform:TDateTime;aRstType:Integer) : Integer;
    function Delete_HiTEMS_TMS_RESULT(aResultNo:String) : Boolean; // DELETE CASCADE 설정으로 자식값은 삭제
    function Get_HiTEMS_TMS_RESULT_CBY(aPerform:TDateTime;aRstType:Integer) : Integer;
  end;

var
  workLog_Frm: TworkLog_Frm;

implementation
uses
  CommonUtil_Unit,
  HiTEMS_TMS_COMMON,
  HiTEMS_TMS_CONST,
  DataModule_Unit;

{$R *.dfm}

procedure TworkLog_Frm.regBtnClick(Sender: TObject);
var
  li,le: Integer;
  lRST_NO : String;
  lRow : Integer;
  lToday : String;
begin
  if planName.Text = '' then
  begin
    planName.SetFocus;
    raise Exception.Create('금일업무를 선택하여 주십시오!');
  end;

  if RST_CODE.Text = '' then
  begin
    RST_CODE.SetFocus;
    raise Exception.Create('업무코드를 선택하여 주십시오!');
  end;

  if RST_TITLE.Text = '' then
  begin
    RST_TITLE.SetFocus;
    raise Exception.Create('금일추진현황 타이틀을 입력하여 주십시오!');
  end;

  if RST_NOTE.Text = '' then
  begin
    RST_NOTE.SetFocus;
    raise Exception.Create('최소 한줄이상의 금일추진현황을 입력하여 주십시오!');
  end;

  if TeamLabel.Enabled then
  begin
    if ((RST_TIME_TYPE.Text = '연장근무') or (RST_TIME_TYPE.Text = '야간연장') or (RST_TIME_TYPE.Text = '철야근무')) then
    begin
      if (accumulateMh.Value + RST_MH.Value) > 12  then
      begin
        raise Exception.Create('주간 MH(52시간)를 초과하였습니다!');
        exit;
      end;
    end;
  end;

  if regBtn.Caption = '업무실적 등록' then
  begin
    with resultGrid do
    begin
      BeginUpdate;

      for li := 0 to RowCount-1 do
      begin
        if SameText(planName.Hint, Cells[3,li]) then
          raise Exception.Create('같은 업무가 등록되어 있습니다.');
      end;

      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('INSERT INTO TMS_RESULT ' +
                'Values( ' +
                ':PLAN_NO,:RST_NO, :RST_CODE, :RST_TYPE, :RST_PERFORM,' +
                ':RST_TITLE, :RST_NOTE, :RST_PROGRESS,' +
                ':RST_NEXT_DATE,:RST_NEXT_TASK,:PLAN_REV_NO )');

        lRST_NO := Get_makeKeyValue;
        ParamByName('PLAN_NO').AsString       := planNo.Text;
        ParamByName('RST_NO').AsString        := lRST_NO;
        ParamByName('RST_CODE').AsString      := RST_CODE.Hint;
        ParamByName('RST_TYPE').AsInteger     := 1;// 0:업무, 1:시험
        ParamByName('RST_PERFORM').AsDate     := rst_perform.Date;
        ParamByName('RST_TITLE').AsString     := RST_TITLE.Text;
        ParamByName('RST_NOTE').AsString      := RST_NOTE.Text;
        ParamByName('RST_PROGRESS').AsInteger := RST_PROGRESS.AsInteger;
        ParamByName('RST_NEXT_TASK').AsString := rst_Next_plan.Text;
  //        ParamByName('RST_NEXT_DATE').AsDate   := RST_NEXT_DATE.Date;
        ParamByName('PLAN_REV_NO').AsInteger := revNo.AsInteger;
        ExecSQL;

        Close;
        SQL.Clear;
        SQL.Add('INSERT INTO TMS_RESULT_MH ' +
                '(RST_NO, RST_SORT, RST_BY, RST_MH, RST_TIME_TYPE) ' +
                'VALUES ' +
                '(:RST_NO, :RST_SORT, :RST_BY, :RST_MH, :RST_TIME_TYPE) ');
        ParamByName('RST_NO').AsString         := lRST_NO;
        ParamByName('RST_SORT').AsInteger      := 0;
        ParamByName('RST_BY').AsString         := FCurrentUserId;
        ParamByName('RST_MH').AsFloat        := RST_MH.AsFloat;
        ParamByName('RST_TIME_TYPE').AsInteger := RST_TIME_TYPE.ItemIndex;
        ExecSQL;

        ShowMessage('등록성공!')
      end;
    end;
  end else//업무실적수정
  begin
    if resultGrid.selectedRow = -1 then
      Exit;

    lrow := resultGrid.selectedRow;

    if TeamLabel.Enabled then
      lRST_NO := grid_over.Cells[9,lrow]
    else
      lRST_NO := resultGrid.Cells[2,lrow];

    with DM1.OraQuery1 do
    begin
      try
        Close;
        SQL.Clear;
        SQL.Add('UPDATE TMS_RESULT SET ' +
                'PLAN_NO = :PLAN_NO, RST_CODE = :RST_CODE, RST_PERFORM = :RST_PERFORM, ' +
                'RST_TITLE = :RST_TITLE, RST_NOTE = :RST_NOTE, RST_PROGRESS = :RST_PROGRESS, ' +
                'RST_NEXT_TASK = :RST_NEXT_TASK, PLAN_REV_NO = :PLAN_REV_NO ' +
                'WHERE RST_NO = :param1 ');
        ParamByName('param1').AsString := lRST_NO;

        ParamByName('PLAN_NO').AsString       := planNo.Text;
        ParamByName('RST_CODE').AsString      := RST_CODE.Hint;
        ParamByName('RST_PERFORM').AsDate     := performpicker.Date;
        ParamByName('RST_TITLE').AsString     := RST_TITLE.Text;
        ParamByName('RST_NOTE').AsString      := RST_NOTE.Text;
        ParamByName('RST_PROGRESS').AsInteger := RST_PROGRESS.AsInteger;
        ParamByName('RST_NEXT_TASK').AsString := rst_Next_plan.Text;
        ParamByName('PLAN_REV_NO').AsInteger  := revNo.AsInteger;
        ExecSQL;

        Close;
        SQL.Clear;
        SQL.Add('UPDATE TMS_RESULT_MH SET ' +
                'RST_MH = :RST_MH, RST_TIME_TYPE = :RST_TIME_TYPE ' +
                'WHERE RST_NO = :param1 ');
        ParamByName('param1').AsString := lRST_NO;

        ParamByName('RST_TIME_TYPE').AsFloat  := RST_MH.AsFloat;
        ParamByName('RST_TIME_TYPE').AsInteger:= RST_TIME_TYPE.ItemIndex;
        ExecSQL;

        ShowMessage('수정성공!');

      except
        on e:Exception do
        begin
          raise Exception.Create(e.Message);
        end;
      end;
    end;
  end;

  if TeamLabel.Enabled then
    Get_HiTEMS_TMS_RESULT_CBY(RST_PERFORM.Date, 1)
  else
    Get_HiTEMS_TMS_RESULT(RST_PERFORM.Date, 1);
end;

procedure TworkLog_Frm.resultGridCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  with resultGrid do
  begin
    if ARow > -1 then
    begin
      regBtn.Caption := '업무실적 수정';

      FRST_NO                := Cells[2,ARow];
      planNo.Text            := Cells[1,ARow];
      revNo.Text             := Cells[11,ARow];

      planName.Items.Clear;
      planName.Items.Add(Get_planName(planNo.Text, revNo.AsInteger));
      planName.ItemIndex := 0;

      RST_TITLE.Text         := Cells[5,ARow];
      RST_PERFORM.Date       := Cell[3,ARow].AsDateTime;
      RST_CODE.Hint          := Cells[10,ARow];
      RST_CODE.Items.Clear;
      RST_CODE.Items.Add((Get_Hitems_Code_Name(Cells[10,ARow])));
      RST_CODE.ItemIndex := 0;

      ENG_TYPE.Text          := Cells[4,ARow];
      RST_PROGRESS.AsInteger := Cell[7,ARow].AsInteger;
      RST_NOTE.Text          := Cells[6,ARow];
      RST_NEXT_PLAN.Text     := Cells[8,ARow];
    end;
  end;
end;

procedure TworkLog_Frm.rst_CodeDropDown(Sender: TObject);
var
  idx : Integer;
begin
  with rst_Code.Items do
  begin
    BeginUpdate;
    try
      Clear;
      Add('');

      if Assigned(FCodeDic) then
        FCodeDic.Clear
      else
        FCodeDic := TDictionary<Integer,string>.Create;

      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM HITEMS_CODE_GROUP ' +
                'WHERE CAT_NO = :param1 ' +
                'ORDER BY SEQ_NO ');
        ParamByName('param1').AsString := 'B06'; //현장업무
        Open;

        while not eof do
        begin
          idx := Add(FieldByName('CODE_NAME').AsString);
          FCodeDic.Add(idx, FieldByName('GRP_NO').AsString);
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;


procedure TworkLog_Frm.rst_CodeSelect(Sender: TObject);
var
  value : string;
begin
  if rst_Code.Text <> '' then
  begin
    FCodeDic.TryGetValue(rst_Code.ItemIndex,value);
    if value <> '' then
      rst_Code.Hint := value
    else
      rst_Code.Hint := '';
  end
  else
    rst_Code.Hint := '';
end;

procedure TworkLog_Frm.cb_partDropDown(Sender: TObject);
begin
  with cb_part.Items do
  begin
    BeginUpdate;
    try
      Clear;
      Add('');
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM HiTEMS_DEPT ' +
                'WHERE PARENT_CD LIKE ''K2B%'' AND DEPT_CD LIKE ''%-%''' +
                'ORDER BY DEPT_CD ');
        //ParamByName('param1').AsString := 'K2B2';
        //ParamByName('param2').AsString := 'K2B3';
        Open;

        if RecordCount <> 0 then
        begin
          while not eof do
          begin
            Add(FieldByName('DEPT_NAME').AsString);
            Next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TworkLog_Frm.cb_partSelect(Sender: TObject);
var
  i : Integer;
begin
  if cb_part.Text <> '' then
  begin
    with DM1.OraQuery1 do
    begin
      First;
      i := -1;
      while not eof do
      begin
        Inc(i);
        if i = cb_part.ItemIndex-1 then
        begin
          cb_part.Hint := FieldByName('DEPT_CD').AsString;
          Break;
        end;
        Next;
      end;
    end;
  end else
    cb_part.Hint := '';
end;

procedure TworkLog_Frm.cb_usersDropDown(Sender: TObject);
var
  i : Integer;
begin
  with cb_users.Items do
  begin
    BeginUpdate;
    try
      Clear;
      Add('');


      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT NAME_KOR, USERID FROM HITEMS_USER ' +
                'WHERE GUNMU = :param1 ');
        SQL.Add('AND DEPT_CD = :team');
        SQL.Add('ORDER BY PRIV DESC, POSITION, GRADE, USERID ');

        ParamByName('param1').AsString := 'I';
        ParamByName('team').AsString := cb_part.Hint;

        Open;

        while not eof do
        begin
          Add(FieldByName('NAME_KOR').AsString);
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TworkLog_Frm.cb_usersSelect(Sender: TObject);
var
  i : Integer;
  LWeekMH, Ld: double;
  LRestType: string;
begin
  if cb_users.Text <> '' then
  begin
    with DM1.OraQuery1 do
    begin
      First;
      i := -1;

      while not eof do
      begin
        Inc(i);
        if i = cb_users.ItemIndex-1 then
        begin
          cb_users.Hint := FieldByName('USERID').AsString;
          FCurrentUserId := cb_users.Hint;

          Break;
        end;
        Next;
      end;
    end;

    if TeamLabel.Enabled then
    begin
      if Assigned(DM1.FOffReasonList) then
        DM1.FOffReasonList.Clear;

      LWeekMH := DM1.GetWeekOverTimeMH(RST_PERFORM.Date, FCurrentUserId);

      if Assigned(DM1.FOffReasonList) then
      begin
        accumulateMh.Hint := '';

        for LRestType in DM1.FOffReasonList.Keys do
        begin
          DM1.FOffReasonList.TryGetValue(LRestType,i);
          accumulateMh.Hint := accumulateMh.Hint + LRestType + ':' + IntToStr(i) + #13#10;
        end;
      end;

      accumulateMh.Value := LWeekMH;
      Get_HiTEMS_TMS_RESULT_CBY(RST_PERFORM.Date, 1);
    end
    else
    begin
      accumulateMh.Visible := False;
      Get_HiTEMS_TMS_RESULT(RST_PERFORM.Date, 1);
    end;

  end else
    cb_users.Hint := '';
end;

procedure TworkLog_Frm.delBtnClick(Sender: TObject);
var
  lResultNo : String;
begin
  if MessageDlg('삭제 하시겠습니까? 삭제된 정보는 복구할 수 없습니다.', mtConfirmation, [mbYes, mbNo], 0) = mrYES then
  begin
    if TeamLabel.Enabled then
    begin
      with Grid_Over do
      begin
        BeginUpdate;
        try
          lResultNo := Cells[9,SelectedRow]; //RESULT NO
          if lResultNo <> '' then
            Delete_HiTEMS_TMS_RESULT(lResultNo);

        finally
          Get_HiTEMS_TMS_RESULT_CBY(RST_PERFORM.Date,1);
          Init_;
          EndUpdate;
        end;
      end;
    end
    else
    begin
      with resultGrid do
      begin
        BeginUpdate;
        try
          lResultNo := Cells[2,SelectedRow]; //RESULT NO
          if lResultNo <> '' then
            Delete_HiTEMS_TMS_RESULT(lResultNo);

        finally
          Get_HiTEMS_TMS_RESULT(RST_PERFORM.Date,1);
          Init_;
          EndUpdate;
        end;
      end;
    end;
  end;
end;

function TworkLog_Frm.Delete_HiTEMS_TMS_RESULT(aResultNo:String) : Boolean;
var
  li: Integer;
begin
  Result := False;
  with DM1.OraQuery1 do
  begin
    try
      Close;
      SQL.Clear;
      SQL.Add('Delete from TMS_RESULT ' +
              'where RST_NO = :param1 ');
      ParamByName('param1').AsString := aResultNo;
      ExecSQL;

      Result := True;
    except
      On E : Exception do
        ShowMessage(E.Message);
    end;
  end;
end;

procedure TworkLog_Frm.EngTypeCBDropDown(Sender: TObject);
var
  Lstr : string;
begin
  Get_PlanName2('');

  EngTypeCB.Items.Clear;
  EngTypeCB.Items.Add('');

  with DM1.OraQuery1 do
  begin
    First;

    while not eof do
    begin
      Lstr := FieldByName('ENG_TYPE').AsString;

      if EngTypeCB.Items.IndexOf(Lstr) < 0 then
        EngTypeCB.Items.Add(Lstr);

      Next;
    end;
  end;

end;

function TworkLog_Frm.Get_HiTEMS_TMS_RESULT(aPerform: TDateTime;
  aRstType: Integer): Integer;
var
  li : Integer;
  lrow : Integer;
begin
  with resultGrid do
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
                '     A.PLAN_NAME, PLAN_TYPE, ENG_TYPE, ENG_PROJNO, ' +
                '     B.PLAN_TEAM, ' +
                '     C.* ' +
                '   FROM ' +
                '   TMS_PLAN A, ' +
                '   TMS_PLAN_INCHARGE B, ' +
                '   TMS_RESULT C ' +
                '   WHERE (A.PLAN_NO = B.PLAN_NO AND A.PLAN_REV_NO = B.PLAN_REV_NO) ' +
                '   AND (A.PLAN_NO = C.PLAN_NO AND A.PLAN_REV_NO = C.PLAN_REV_NO) ' +
                ') ' +
                'WHERE PLAN_TYPE = :param1 ' +
                'AND PLAN_TEAM = :param2 ' +
                'AND RST_PERFORM = :param3 ');

        ParamByName('param1').AsInteger  := aRstType;
        ParamByName('param2').AsString   := FCurrentTeam;
        ParamByName('param3').AsDate     := aPerform;
        Open;

        Result := RecordCount;
        if RecordCount <> 0 then
        begin
          while not eof do
          begin
            lrow := AddRow;

            Cells[1,lrow]           := FieldByName('PLAN_NO').AsString;
            Cells[2,lrow]           := FieldByName('RST_NO').AsString;
            Cell[3,lrow].AsDateTime := FieldByName('RST_PERFORM').AsDateTime;
            Cells[4,lrow]           := FieldByName('ENG_PROJNO').AsString+'-'+
                                       FieldByName('ENG_TYPE').AsString;
            Cells[5,lrow]           := FieldByName('RST_TITLE').AsString;
            Cells[6,lrow]           := FieldByName('RST_NOTE').AsString;
            Cell[7,lrow].AsInteger  := FieldByName('RST_PROGRESS').AsInteger;
            Cells[8,lrow]           := FieldByName('RST_NEXT_TASK').AsString;
            Cell[9,lrow].AsDateTime := FieldByName('RST_NEXT_DATE').AsDateTime;
            Cells[10,lrow]          := FieldByName('RST_CODE').AsString;
            Cells[11,lrow]          := FieldByName('PLAN_REV_NO').AsString;
            Next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

function TworkLog_Frm.Get_HiTEMS_TMS_RESULT_CBY(aPerform: TDateTime;
  aRstType: Integer): Integer;
begin
  with grid_over do
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
                '     USERID, DESCR, NAME_KOR, DEPT_CD, GRADE, PRIV, POSITION, EOT,' +
                '     RST_PERFORM, RST_TITLE, RST_MH, A.PLAN_NO, ENG_PROJNO, ' +
                '     ENG_TYPE, ENG_MODEL, RST_NO, RST_TIME_TYPE, RST_NOTE, RST_CODE, PLAN_REV_NO, RST_NEXT_TASK ' +
                '   FROM ' +
                '   ( ' +
                '       SELECT * FROM ' +
                '       ( ' +
                '           SELECT ' +
                '             USERID, DESCR, NAME_KOR, DEPT_CD, D.GRADE, PRIV, ' +
                '             POSITION, EOT, RST_PERFORM, RST_TITLE, RST_MH, RST_TIME_TYPE, RST_NOTE, ' +
                '             RST_CODE,RST_NEXT_TASK, PLAN_REV_NO, PLAN_NO, A.RST_NO ' +
                '           FROM ' +
                '             TMS_RESULT A, ' +
                '             TMS_RESULT_MH B, ' +
                '             HITEMS_USER C, ' +
                '             HITEMS_USER_GRADE D ' +
                '           WHERE A.RST_NO = B.RST_NO ' +
//                '           AND B.RST_TIME_TYPE IN (1, 2) ' +
                '           AND B.RST_TIME_TYPE > 0 ' +
                '           AND RST_BY = C.USERID ' +
                '           AND C.GRADE = D.GRADE ' +
                '       ) ' +
                '   ) A LEFT OUTER JOIN ' +
                '   ( ' +
                '       SELECT A.PLAN_NO, ENG_PROJNO, ENG_TYPE, ENG_MODEL FROM ' +
                '       ( ' +
                '           SELECT PLAN_NO, MAX(PLAN_REV_NO) PN FROM TMS_PLAN ' +
                '           GROUP BY PLAN_NO ' +
                '       ) A LEFT OUTER JOIN TMS_PLAN B ' +
                '       ON A.PLAN_NO = B.PLAN_NO ' +
                '       AND A.PN = B.PLAN_REV_NO ' +
                '   ) B ' +
                '   ON A.PLAN_NO = B.PLAN_NO ' +
                ') ' +
                'WHERE RST_PERFORM = :BEGIN ' +
                'AND USERID = :USERID ' +
                'AND DEPT_CD LIKE :TEAM ' +
                'ORDER BY RST_PERFORM, PRIV DESC, POSITION, GRADE, USERID ');

        ParamByName('BEGIN').AsDate := performpicker.Date;
        if cb_Users.Hint <> '' then
          ParamByName('USERID').AsString  := cb_Users.Hint
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND USERID = :USERID ', '' );

        if cb_part.Hint <> '' then
          ParamByName('TEAM').AsString  := cb_part.Hint
        else
          ParamByName('TEAM').AsString  := '%'+DM1.FUserInfo.CurrentUsersDept+'%';

        Open;

        if RecordCount <> 0 then
        begin
          while not eof do
          begin
            if not(FieldByName('RST_PERFORM').IsNull) then
            begin
              AddRow;
              Cell[1,LastAddedRow].AsDateTime := FieldByName('RST_PERFORM').AsDateTime;
              Cells[2,LastAddedRow] := FieldByName('DESCR').AsString;
              Cells[3,LastAddedRow] := FieldByName('USERID').AsString;
              Cells[4,LastAddedRow] := FieldByName('NAME_KOR').AsString;
              Cells[5,LastAddedRow] := FieldByName('ENG_PROJNO').AsString;
              Cells[6,LastAddedRow] := FieldByName('RST_TITLE').AsString;
              Cell[7,LastAddedRow].AsFloat := FieldByName('RST_MH').AsFloat;
              Cells[8,LastAddedRow] := FieldByName('EOT').AsString;
              Cells[9,LastAddedRow] := FieldByName('RST_NO').AsString;
              Cells[10,LastAddedRow] := ftimeType[FieldByName('RST_TIME_TYPE').AsInteger];

              Cells[11,LastAddedRow] := FieldByName('PLAN_NO').AsString;
              Cells[12,LastAddedRow] := FieldByName('RST_NO').AsString;
              Cells[13,LastAddedRow] := FieldByName('ENG_TYPE').AsString;
              Cells[14,LastAddedRow] := FieldByName('RST_NOTE').AsString;
              Cells[15,LastAddedRow] := FieldByName('RST_CODE').AsString;
              Cells[16,LastAddedRow] := FieldByName('PLAN_REV_NO').AsString;
              Cells[17,LastAddedRow] := FieldByName('RST_NEXT_TASK').AsString;
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

procedure TworkLog_Frm.Get_PlanInfo(aPlanNo: string);
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT ' +
            '   A.PLAN_NO, REV_NO, TASK_NO, PLAN_CODE, PLAN_TYPE, PLAN_NAME, ' +
            '   PLAN_OUTLINE, ENG_MODEL, ENG_TYPE, ENG_PROJNO, PLAN_START, ' +
            '   PLAN_END, PLAN_MH, PLAN_PROGRESS ' +
            'FROM' +
            '( ' +
            '   SELECT PLAN_NO, MAX(PLAN_REV_NO) REV_NO ' +
            '   FROM TMS_PLAN GROUP BY PLAN_NO ' +
            ') A, ' +
            '( ' +
            '   SELECT * FROM TMS_PLAN ' +
            ') B ' +
            'WHERE A.PLAN_NO = :param1 ' +
            'AND A.PLAN_NO = B.PLAN_NO ' +
            'AND A.REV_NO = B.PLAN_REV_NO');

    ParamByName('param1').AsString := aPlanNo;
    Open;

    if RecordCount <> 0 then
    begin
      if not FieldByName('ENG_PROJNO').IsNull then
      begin
        eng_Type.Text := FieldByName('ENG_PROJNO').AsString + '-' +
                         FieldByName('ENG_TYPE').AsString;

      end;
    end;
  end;
end;

procedure TworkLog_Frm.Get_PlanName2(aEngType:string);
const
  Query   = 'SELECT * FROM ' +
            '( ' +
            '   SELECT ' +
            '       A.PLAN_NO, REV_NO, PLAN_NAME, PLAN_START, PLAN_END, PLAN_TEAM, TEAM, PLAN_TYPE, ENG_TYPE ' +
            '   FROM' +
            '   ( ' +
            '       SELECT ' +
            '           A.PLAN_NO, REV_NO, PLAN_TEAM, TEAM, ' +
            '           B.TASK_NO, PLAN_CODE, PLAN_TYPE, PLAN_NAME, ENG_MODEL, ENG_TYPE, ' +
            '           ENG_PROJNO, PLAN_START, PLAN_END, PLAN_MH, PLAN_PROGRESS, CODE_NAME ' +
            '       FROM ' +
            '       ( ' +
            '           SELECT A.PLAN_NO, REV_NO, PLAN_TEAM, TEAM FROM ' +
            '           ( ' +
            '               SELECT PLAN_NO, MAX(PLAN_REV_NO) REV_NO FROM TMS_PLAN GROUP BY PLAN_NO ' +
            '           ) A, ' +
            '           ( ' +
            '               SELECT PLAN_NO, PLAN_REV_NO, SUBSTR(PLAN_TEAM,1,4) PLAN_TEAM, PLAN_TEAM TEAM FROM TMS_PLAN_INCHARGE ' +
            '           ) B ' +
            '           WHERE A.PLAN_NO = B.PLAN_NO ' +
            '           AND A.REV_NO = B.PLAN_REV_NO ' +
            '           GROUP BY A.PLAN_NO, REV_NO, PLAN_TEAM, TEAM ' +
            '       ) A LEFT OUTER JOIN  ' +
            '       ( ' +
            '           SELECT TASK_NO, PLAN_NO, PLAN_REV_NO, A.PLAN_CODE, PLAN_TYPE, PLAN_NAME, ' +
            '           ENG_MODEL, ENG_TYPE, ENG_PROJNO, PLAN_START, PLAN_END, PLAN_MH, ' +
            '           PLAN_PROGRESS, CODE_NAME ' +
            '           FROM TMS_PLAN A LEFT OUTER JOIN HITEMS_CODE_GROUP B ' +
            '           ON A.PLAN_CODE = GRP_NO ' +
            '       ) B ' +
            '       ON A.PLAN_NO = B.PLAN_NO ' +
            '       AND A.REV_NO = B.PLAN_REV_NO ' +
            '   ) A LEFT OUTER JOIN ' +
            '   ( ' +
            '       SELECT PLAN_NO PN, DEPT_CD TN, SUM(RST_MH) MH FROM  ' +
            '       (  ' +
            '           SELECT A.PLAN_NO, A.RST_NO, B.RST_BY, B.RST_MH, C.DEPT_CD  ' +
            '           FROM  ' +
            '           TMS_RESULT A,  ' +
            '           TMS_RESULT_MH B, ' +
            '           HITEMS_USER C ' +
            '           WHERE A.RST_NO = B.RST_NO ' +
            '           AND B.RST_BY = C.USERID  ' +
            '           ORDER BY PLAN_NO, DEPT_CD  ' +
            '       )  ' +
            '       GROUP BY PLAN_NO, DEPT_CD ' +
            '   ) B ' +
            '   ON A.PLAN_NO = B.PN ' +
            '   AND A.PLAN_TEAM = B.TN ' +
            ')  ' +
            'WHERE (TO_CHAR(PLAN_START, ''yyyy-mm-dd'') <= :beginDate ' +
            '       AND PLAN_END >= TO_DATE(:beginDate, ''yyyy-mm-dd'') ' +
            '       AND TO_CHAR(PLAN_START, ''yyyy-mm-dd'') <= :endDate ' +
            '       AND TO_CHAR(PLAN_END, ''yyyy-mm-dd'') <= :endDate ' +
            '       OR PLAN_START >= TO_DATE(:beginDate, ''yyyy-mm-dd'') ' +
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
            '       AND TO_CHAR(PLAN_END, ''yyyy-mm-dd'') >= :endDate) ' +
            'AND PLAN_TYPE = :PLAN_TYPE ';// +
            //'AND ENG_TYPE = :ENGTYPE';
var
  str,str2,
  beginDate,
  endDate:String;
  team:String;
  i : Integer;
  lrow : Integer;
begin
  beginDate := FormatDateTime('yyyy-MM-dd',StartOfTheWeek(today));
  endDate   := FormatDateTime('yyyy-MM-dd',EndOfTheWeek(today));

  team := '';
  team := ''''+FCurrentTeam+'''';

  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add(Query);

//    if aEngType <> '' then
//      ParamByName('ENGTYPE').AsString := aEngType
//    else
//      SQL.Text := ReplaceStr(SQL.Text, 'AND ENG_TYPE = :ENGTYPE', '');

    ParamByName('beginDate').AsString := beginDate;
    ParamByName('endDate').AsString := endDate;
    ParamByName('PLAN_TYPE').AsInteger := 1;

    if team <> '' then
    begin
      SQL.Add('AND TEAM IN ('+team+') ')
    end;

    SQL.Add('ORDER BY PLAN_NAME, PLAN_START ');

    open;

  end;

end;

procedure TworkLog_Frm.grid_overCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  with grid_over do
  begin
    if ARow > -1 then
    begin
      regBtn.Caption := '업무실적 수정';

      RST_PERFORM.Date := Cell[1,ARow].AsDateTime;
      FRST_NO               := Cells[12,ARow];
      planNo.Text           := Cells[11,ARow];
      revNo.Text            := Cells[16,ARow];

      planName.Items.Clear;
      planName.Items.Add(Get_planName(planNo.Text, revNo.AsInteger));
      planName.ItemIndex := 0;

      RST_TITLE.Text         := Cells[6,ARow];
      RST_CODE.Hint          := Cells[15,ARow];
      RST_CODE.Items.Clear;
      RST_CODE.Items.Add((Get_Hitems_Code_Name(Cells[15,ARow])));
      RST_CODE.ItemIndex := 0;

      ENG_TYPE.Text          := Cells[13,ARow];
      EngTypeCB.Clear;
      EngTypeCB.Items.Add(Cells[13,ARow]);
      EngTypeCB.ItemIndex := 0;

      RST_NOTE.Text          := Cells[14,ARow];
      RST_NEXT_PLAN.Text     := Cells[17,ARow];
      RST_MH.Text            := Cells[7,ARow];
      accumulateMh.Value := accumulateMh.Value - StrToFloatDef(RST_MH.Text,0.0);
      RST_TIME_TYPE.Text     := Cells[10,ARow];
    end;
  end;
end;

procedure TworkLog_Frm.Init_;
var
  li: integer;
begin
  regBtn.Caption := '업무실적 등록';

  performpicker.Date := Today;
  RST_PERFORM.Date := performpicker.Date;

  planNo.Clear;
  revNo.Clear;
  planName.Clear;
  RST_CODE.Clear;
  ENG_TYPE.Clear;
  RST_PROGRESS.Clear;
  RST_TITLE.Clear;
  RST_NOTE.Clear;
  RST_NEXT_PLAN.Clear;

  with RST_TIME_TYPE.Items do
  begin
    BeginUpdate;
    try
      for li := 0 to Length(ftimeType)-1 do
        Add(ftimeType[li]);

    finally
      RST_TIME_TYPE.ItemIndex := 0;
      EndUpdate;
    end;
  end;

  FCurrentUserId := DM1.FUserInfo.CurrentUsers;
  FCurrentTeam := DM1.FUserInfo.CurrentUsersTeam;
  FJobPosition := DM1.FUserInfo.CurrentJobPosition;

  TeamLabel.Enabled := FJobPosition = '생산반장';
  cb_part.Enabled := TeamLabel.Enabled;
  userlabel.Enabled := TeamLabel.Enabled;
  cb_users.Enabled := TeamLabel.Enabled;
  ResultGrid.Visible := not TeamLabel.Enabled;
  Grid_Over.Visible := TeamLabel.Enabled;

  if Grid_Over.Visible then
  begin
    jvLabel8.Caption := '투입/주간누적연장 MH :';
    Grid_Over.Height := 180;
  end
  else
    jvLabel8.Caption := '투입 MH :';

end;

procedure TworkLog_Frm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Assigned(FCodeDic) then
    FreeAndNil(FCodeDic);

  if Assigned(FplanDic) then
    FreeAndNil(FplanDic);
end;

procedure TworkLog_Frm.FormCreate(Sender: TObject);
begin
  Init_;

  Get_HiTEMS_TMS_RESULT(performpicker.Date,1);
end;

procedure TworkLog_Frm.performpickerChange(Sender: TObject);
begin
  RST_PERFORM.Date := performpicker.Date;
  Get_HiTEMS_TMS_RESULT(performpicker.Date,1);
end;

procedure TworkLog_Frm.planNameDropDown(Sender: TObject);
var
  Lstr, str, str2,
  beginDate,
  endDate:String;
  team:String;
  i : Integer;
  lrow : Integer;
begin
//  if EngTypeCB.Text = '' then
//  begin
//    ShowMessage('');
//    exit;
//  end;

  with planName.Items do
  begin
    BeginUpdate;
    try
      Clear;
      Add('');

      Get_PlanName2(EngTypeCB.Text);

      if Assigned(FplanDic) then
        FplanDic.Clear
      else
        FplanDic := TDictionary<Integer,String>.Create;

      i := 0;

      with DM1.OraQuery1 do
      begin
        First;

        while not eof do
        begin
          Str2 := FieldByName('ENG_TYPE').AsString;
          str := FieldbyName('PLAN_NO').AsString+';'+FieldbyName('REV_NO').AsString;

          if EngTypeCB.Text <> '' then
          begin
            if EngTypeCB.Text = Str2 then
            begin
              FplanDic.Add(i,str);
              Inc(i);
            end;
          end
          else
          begin
            FplanDic.Add(i,str);
            Inc(i);
          end;

          //Add(FieldByName('ENG_TYPE').AsString + ':' + FieldByName('PLAN_NAME').AsString);
          LStr := FieldByName('ENG_TYPE').AsString;

          if EngTypeCB.Text <> '' then
          begin
            if EngTypeCB.Text = LStr then
              Add(FieldByName('PLAN_NAME').AsString);
          end
          else
          begin
            Add(FieldByName('ENG_TYPE').AsString + ':' + FieldByName('PLAN_NAME').AsString);
          end;
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TworkLog_Frm.planNameSelect(Sender: TObject);
var
  str : String;
  strList : TStringList;
begin
  if planName.Text <> '' then
  begin
    FplanDic.TryGetValue(planName.ItemIndex-1,str);
    if str <> '' then
    begin
      strList := TStringList.Create;
      try
        ExtractStrings([';'],[],PChar(str),strList);
        if strList.Count = 2 then
        begin
          planNo.Text := strList.Strings[0];
          revNo.Text  := strList.Strings[1];
        end;
      finally
        FreeAndNil(strList);
      end;

      Eng_Type.Text := Copy(PlanName.Text, 1, Pos(':', PlanName.Text)-1);
    end;
  end;
end;

end.



