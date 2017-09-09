unit logDialog_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, AdvGlowButton, Vcl.StdCtrls, NxEdit, Vcl.ComCtrls,
  JvExControls, JvLabel, AeroButtons, AdvTreeComboBox, DateUtils,
  System.Generics.Collections, StrUtils;

type
  TlogDialog_Frm = class(TForm)
    JvLabel2: TJvLabel;
    JvLabel31: TJvLabel;
    JvLabel1: TJvLabel;
    JvLabel3: TJvLabel;
    JvLabel4: TJvLabel;
    JvLabel5: TJvLabel;
    JvLabel6: TJvLabel;
    JvLabel7: TJvLabel;
    JvLabel8: TJvLabel;
    planName: TComboBox;
    engType: TEdit;
    perform: TDateTimePicker;
    rst_Title: TEdit;
    rst_Note: TMemo;
    rst_Next_Task: TMemo;
    regBtn: TAdvGlowButton;
    JvLabel9: TJvLabel;
    rstGrid: TNextGrid;
    NxIncrementColumn2: TNxIncrementColumn;
    NxTextColumn7: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    NxTextColumn10: TNxTextColumn;
    NxTextColumn14: TNxTextColumn;
    NxTextColumn15: TNxTextColumn;
    NxTextColumn8: TNxTextColumn;
    NxTextColumn9: TNxTextColumn;
    planProgressColumn: TNxProgressColumn;
    Panel8: TPanel;
    Image1: TImage;
    planNo: TEdit;
    RST_PROGRESS: TNxNumberEdit;
    revNo: TNxNumberEdit;
    rst_Code: TComboBox;
    initBtn: TAdvGlowButton;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    delBtn: TAdvGlowButton;
    procedure regBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure rst_CodeDropDown(Sender: TObject);
    procedure rst_CodeSelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure initBtnClick(Sender: TObject);
    procedure rstGridCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure delBtnClick(Sender: TObject);
    procedure planNameDropDown(Sender: TObject);
    procedure planNameSelect(Sender: TObject);
  private
    { Private declarations }
    FRstNo : string;
    FbeginDate,
    FendDate:TDateTime;
    FcodeDic : TDictionary<Integer,string>;
    FplanDic : TDictionary<Integer,string>;
  public
    { Public declarations }
    procedure Get_ResultOfPlan(aPlanNo:string);
    procedure Get_PlanInfo(aPlanNo:string);

    procedure Init_;
    procedure Insert_HiTEMS_TMS_RESULT;
    procedure Update_HiTEMS_TMS_RESULT;

  end;

var
  logDialog_Frm: TlogDialog_Frm;
  function Create_logDialog_Frm(aPlanNo,aRevNo:string;aBeginDate,aEndDate:TDateTime):Boolean;

implementation
uses
  taskMain_Unit,
  HiTEMS_TMS_CONST,
  HiTEMS_TMS_COMMON,
  DataModule_Unit;

{$R *.dfm}

function Create_logDialog_Frm(aPlanNo,aRevNo:string;aBeginDate,aEndDate:TDateTime):Boolean;
var
  str : string;
begin
  logDialog_Frm := TlogDialog_Frm.Create(nil);
  try
    with logDialog_Frm do
    begin
      planNo.Text := aPlanNo;
      revNo.Text  := aRevNo;
      FbeginDate := aBeginDate;
      FendDate := aEndDate;

      planName.Items.Clear;
      planName.Items.Add(Get_PlanName(planNo.Text, revNo.AsInteger));
      planName.ItemIndex := 0;

      Get_ResultOfPlan(planNo.Text);
      Get_PlanInfo(planNo.Text);

      ShowModal;

      if ModalResult = mrOk then
        Result := True
      else
        Result := False;
    end;
  finally
    FreeAndNil(logDialog_Frm);
  end;
end;

{ TlogDialog_Frm }

procedure TlogDialog_Frm.initBtnClick(Sender: TObject);
begin
  Init_;


end;

procedure TlogDialog_Frm.delBtnClick(Sender: TObject);
begin
begin
  if MessageDlg('삭제 하시겠습니까? 삭제된 정보는 복구할 수 없습니다.', mtConfirmation, [mbYes, mbNo], 0) = mrYES then
  begin
    if FRstNo <> '' then
    begin
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('DELETE FROM DPMS_TMS_RESULT ' +
                'WHERE RST_NO = :param1 ');
        ParamByName('param1').AsString := FRstNo;
        ExecSQL;

        Get_ResultOfPlan(planNo.Text);
        Get_PlanInfo(planNo.Text);

        rst_Code.Items.Clear;
        rst_Code.Clear;
        self.perform.Date := today;
        RST_PROGRESS.AsInteger := 0;
        rst_Title.Clear;
        rst_Note.Clear;
        rst_Next_Task.Clear;

      end;
    end;
  end;
end;

end;

procedure TlogDialog_Frm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Assigned(FCodeDic) then
    FreeAndNil(FCodeDic);

  if Assigned(FplanDic) then
    FreeAndNil(FplanDic);

end;

procedure TlogDialog_Frm.FormCreate(Sender: TObject);
begin
  perform.Date := today;
end;

procedure TlogDialog_Frm.Get_PlanInfo(aPlanNo: string);
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
            '   FROM DPMS_TMS_PLAN GROUP BY PLAN_NO ' +
            ') A, ' +
            '( ' +
            '   SELECT * FROM DPMS_TMS_PLAN ' +
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
        engType.Text := FieldByName('ENG_PROJNO').AsString + '-' +
                        FieldByName('ENG_TYPE').AsString;

      end;
    end;
  end;
end;

procedure TlogDialog_Frm.Get_ResultOfPlan(aPlanNo: string);
var
  lrow : Integer;
begin
  with rstGrid do
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
                '   SELECT A.*, B.CODE_NAME FROM DPMS_TMS_RESULT A LEFT OUTER JOIN INTEGRATED_CODE B ' +
                '   ON A.RST_CODE = INT_CODE ' +
                ') ' +
                'WHERE PLAN_NO = :param1 ' +
                'ORDER BY RST_PERFORM ');
        ParamByName('param1').AsString := aPlanNo;
        Open;

        while not eof do
        begin
          lrow := AddRow;
          Cells[1,lrow] := FieldByName('PLAN_NO').AsString;
          Cells[2,lrow] := FieldByName('PLAN_REV_NO').AsString;
          Cells[3,lrow] := FieldByName('RST_NO').AsString;
          Cells[4,lrow] := FieldByName('RST_CODE').AsString;
          Cells[5,lrow] := FieldByName('CODE_NAME').AsString;
          Cells[6,lrow] := FormatDateTime('yyyy-MM-dd',FieldByName('RST_PERFORM').AsDateTime);
          Cells[7,lrow] := FieldByName('RST_TITLE').AsString;
          Cell[8,lrow].AsInteger := FieldByName('RST_PROGRESS').AsInteger;
          Cells[9,lrow] := FieldByName('RST_NOTE').AsString;
          Cells[10,lrow] := FieldByName('RST_NEXT_TASK').AsString;

          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;

end;

procedure TlogDialog_Frm.Init_;
begin
  FRstNo := '';
  rstGrid.ClearRows;
  regBtn.Caption := '업무실적 등록';
  delBtn.Enabled := False;
  planNo.Clear;
  revNo.AsInteger := 0;
  planName.Items.Clear;
  planName.Clear;
  planName.Hint := '';
  rst_Code.Items.Clear;
  rst_Code.Clear;
  rst_Code.Hint := '';
  engType.Clear;
  perform.Date := today;
  RST_PROGRESS.AsInteger := 0;
  rst_title.Clear;
  rst_note.Clear;
  rst_Next_Task.Clear;
end;

procedure TlogDialog_Frm.Insert_HiTEMS_TMS_RESULT;
var
  lRST_NO : String;
begin
  with DM1.OraQuery1 do
  begin
    try
      Close;
      SQL.Clear;
      SQL.Add('INSERT INTO DPMS_TMS_RESULT ' +
              'Values( ' +
              ':PLAN_NO,:RST_NO, :RST_CODE, :RST_TYPE, :RST_PERFORM,' +
              ':RST_TITLE, :RST_NOTE, :RST_PROGRESS,' +
              ':RST_NEXT_DATE,:RST_NEXT_TASK,:PLAN_REV_NO )');

      lRST_NO := Get_makeKeyValue;
      ParamByName('PLAN_NO').AsString       := planNo.Text;
      ParamByName('RST_NO').AsString        := lRST_NO;
      ParamByName('RST_CODE').AsString      := RST_CODE.Hint;
      ParamByName('RST_TYPE').AsInteger     := 1;// 0:업무, 1:시험
      ParamByName('RST_PERFORM').AsDate     := perform.Date;
      ParamByName('RST_TITLE').AsString     := RST_TITLE.Text;
      ParamByName('RST_NOTE').AsString      := RST_NOTE.Text;
      ParamByName('RST_PROGRESS').AsInteger := RST_PROGRESS.AsInteger;
      ParamByName('RST_NEXT_TASK').AsString := rst_Next_Task.Text;
//        ParamByName('RST_NEXT_DATE').AsDate   := RST_NEXT_DATE.Date;
      ParamByName('PLAN_REV_NO').AsInteger := revNo.AsInteger;
      ExecSQL;

      Close;
      SQL.Clear;
      SQL.Add('INSERT INTO DPMS_TMS_RESULT_MH ' +
              '(RST_NO, RST_SORT, RST_BY, RST_MH, RST_TIME_TYPE) ' +
              'VALUES ' +
              '(:RST_NO, :RST_SORT, :RST_BY, :RST_MH, :RST_TIME_TYPE) ');
      ParamByName('RST_NO').AsString         := lRST_NO;
      ParamByName('RST_SORT').AsInteger      := 0;
      ParamByName('RST_BY').AsString         := DM1.FUserInfo.CurrentUsers;
      ParamByName('RST_MH').AsInteger        := 0;
      ParamByName('RST_TIME_TYPE').AsInteger := 1;//시험
      ExecSQL;

      ShowMessage('등록성공!');

    except
      on e:Exception do
      begin
        raise Exception.Create(e.Message);
      end;
    end;
  end;
end;

procedure TlogDialog_Frm.planNameDropDown(Sender: TObject);
const
  Query   = 'SELECT * FROM ' +
            '( ' +
            '   SELECT ' +
            '       A.PLAN_NO, REV_NO, PLAN_NAME, PLAN_START, PLAN_END, PLAN_TEAM, PLAN_TYPE ' +
            '   FROM' +
            '   ( ' +
            '       SELECT ' +
            '           A.PLAN_NO, REV_NO, PLAN_TEAM, ' +
            '           B.TASK_NO, PLAN_CODE, PLAN_TYPE, PLAN_NAME, ENG_MODEL, ENG_TYPE, ' +
            '           ENG_PROJNO, PLAN_START, PLAN_END, PLAN_MH, PLAN_PROGRESS, CODE_NAME ' +
            '       FROM ' +
            '       ( ' +
            '           SELECT A.PLAN_NO, REV_NO, PLAN_TEAM FROM ' +
            '           ( ' +
            '               SELECT PLAN_NO, MAX(PLAN_REV_NO) REV_NO FROM DPMS_TMS_PLAN GROUP BY PLAN_NO ' +
            '           ) A, ' +
            '           ( ' +
            '               SELECT PLAN_NO, PLAN_REV_NO, SUBSTR(PLAN_TEAM,1,4) PLAN_TEAM FROM DPMS_TMS_PLAN_INCHARGE ' +
            '           ) B ' +
            '           WHERE A.PLAN_NO = B.PLAN_NO ' +
            '           AND A.REV_NO = B.PLAN_REV_NO ' +
            '           GROUP BY A.PLAN_NO, REV_NO, PLAN_TEAM ' +
            '       ) A LEFT OUTER JOIN  ' +
            '       ( ' +
            '           SELECT TASK_NO, PLAN_NO, PLAN_REV_NO, A.PLAN_CODE, PLAN_TYPE, PLAN_NAME, ' +
            '           ENG_MODEL, ENG_TYPE, ENG_PROJNO, PLAN_START, PLAN_END, PLAN_MH, ' +
            '           PLAN_PROGRESS, CODE_NAME ' +
            '           FROM DPMS_TMS_PLAN A LEFT OUTER JOIN INTEGRATED_CODE B ' +
            '           ON A.PLAN_CODE = INT_CODE ' +
            '       ) B ' +
            '       ON A.PLAN_NO = B.PLAN_NO ' +
            '       AND A.REV_NO = B.PLAN_REV_NO ' +
            '   ) A LEFT OUTER JOIN ' +
            '   ( ' +
            '       SELECT PLAN_NO PN, DEPT_CD TN, SUM(RST_MH) MH FROM  ' +
            '       (  ' +
            '           SELECT A.PLAN_NO, A.RST_NO, B.RST_BY, B.RST_MH, C.DEPT_CD  ' +
            '           FROM  ' +
            '           DPMS_TMS_RESULT A,  ' +
            '           DPMS_TMS_RESULT_MH B, ' +
            '           DPMS_USER C ' +
            '           WHERE A.RST_NO = B.RST_NO ' +
            '           AND B.RST_BY = C.USERID  ' +
            '           ORDER BY PLAN_NO, DEPT_CD  ' +
            '       )  ' +
            '       GROUP BY PLAN_NO, DEPT_CD ' +
            '   ) B ' +
            '   ON A.PLAN_NO = B.PN ' +
            '   AND A.PLAN_TEAM = B.TN ' +
            ')  ' +
            'WHERE ((TO_CHAR(PLAN_START,''yyyy-mm-dd'') BETWEEN :beginDate AND :endDate ) ' +
            '       OR (TO_CHAR(PLAN_END,''yyyy-mm-dd'') BETWEEN :beginDate AND :endDate)) ' +
            'AND PLAN_TYPE = :PLAN_TYPE';
var
  str,
  beginDate,
  endDate:String;
  team:String;
  i : Integer;
  lrow : Integer;
begin
  with planName.Items do
  begin
    BeginUpdate;
    try
      Clear;
      Add('');

      beginDate := FormatDateTime('yyyy-MM-dd',FbeginDate);
      endDate   := FormatDateTime('yyyy-MM-dd',FendDate);

      team := '';
      team := ''''+LeftStr(DM1.FUserInfo.CurrentUsersTeam,4)+'''';

      if Assigned(FplanDic) then
        FplanDic.Clear
      else
        FplanDic := TDictionary<Integer,String>.Create;

      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add(Query);

        ParamByName('beginDate').AsString := beginDate;
        ParamByName('endDate').AsString := endDate;
        ParamByName('PLAN_TYPE').AsInteger := 1;

        if team <> '' then
        begin
          SQL.Add('AND PLAN_TEAM IN ('+team+') ')
        end;

        SQL.Add('ORDER BY PLAN_TEAM, PLAN_START ');

        open;

        while not eof do
        begin
          i := Add(FieldByName('PLAN_NAME').AsString);
          str := FieldbyName('PLAN_NO').AsString+';'+FieldbyName('REV_NO').AsString;
          FplanDic.Add(i,str);
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TlogDialog_Frm.planNameSelect(Sender: TObject);
var
  str : String;
  strList : TStringList;
begin
  if planName.Text <> '' then
  begin
    FplanDic.TryGetValue(planName.ItemIndex,str);
    if str <> '' then
    begin
      strList := TStringList.Create;
      try
        ExtractStrings([';'],[],PChar(str),strList);
        if strList.Count = 2 then
        begin
          planNo.Text := strList.Strings[0];
          revNo.Text  := strList.Strings[1];

          Get_ResultOfPlan(planNo.Text);
          Get_PlanInfo(planNo.Text);

          rst_Code.Items.Clear;
          rst_Code.Clear;
          self.perform.Date := today;
          RST_PROGRESS.AsInteger := 0;
          rst_Title.Clear;
          rst_Note.Clear;
          rst_Next_Task.Clear;
        end;
      finally
        FreeAndNil(strList);
      end;
    end;
  end;
end;

procedure TlogDialog_Frm.regBtnClick(Sender: TObject);
begin
  if planName.ItemIndex < 0 then
  begin
    planName.SetFocus;
    raise Exception.Create('업무명을 선택하여 주십시오!');
  end;

  if rst_Code.ItemIndex < 0 then
  begin
    rst_Code.SetFocus;
    raise Exception.Create('업무코드를 선택하여 주십시오!');
  end;

  if RST_PROGRESS.AsInteger < 0 then
  begin
    RST_PROGRESS.SetFocus;
    raise Exception.Create('업무진행율을 입력하여 주십시오!');
  end;

  if rst_Title.Text = '' then
  begin
    rst_Title.SetFocus;
    raise Exception.Create('금일 추진현황을 입력하여 주십시오!');
  end;

  if regBtn.Caption = '업무실적 등록' then
  begin
    Insert_HiTEMS_TMS_RESULT;
  end else
  begin
    Update_HiTEMS_TMS_RESULT;
  end;
  Get_ResultOfPlan(planNo.Text);
end;

procedure TlogDialog_Frm.rstGridCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  with rstGrid do
  begin
    BeginUpdate;
    try
      if ARow > -1 then
      begin
        regBtn.Caption := '업무실적 수정';
        delBtn.Enabled := True;
        with DM1.OraQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT * FROM ' +
                  '( ' +
                  '   SELECT A.*, B.CODE_NAME FROM DPMS_TMS_RESULT A LEFT OUTER JOIN INTEGRATED_CODE B ' +
                  '   ON A.RST_CODE = INT_CODE ' +
                  ') WHERE RST_NO = :param1 ');

          FRstNo := Cells[3,ARow];
          ParamByName('param1').AsString := FRstNo;
          Open;

          if RecordCount <> 0 then
          begin
            planNo.Text := FieldByName('PLAN_NO').AsString;
            revNo.AsInteger := FieldByName('PLAN_REV_NO').AsInteger;

            planName.Items.Clear;
            planName.Items.Add(Get_PlanName(planNo.Text, revNo.AsInteger));
            planName.ItemIndex := 0;

            rst_Code.Items.Clear;
            rst_Code.Items.Add(FieldByName('CODE_NAME').AsString);
            rst_Code.ItemIndex := 0;
            rst_Code.Hint := FieldByName('RST_CODE').AsString;

            self.perform.Date := FieldByName('RST_PERFORM').AsDateTime;

            RST_PROGRESS.AsInteger := FieldByName('RST_PROGRESS').AsInteger;

            rst_Title.Text := FieldByName('RST_TITLE').AsString;
            rst_Note.Text  := FieldByName('RST_NOTE').AsString;
            rst_Next_Task.Text := FieldByName('RST_NEXT_TASK').AsString;

          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TlogDialog_Frm.rst_CodeDropDown(Sender: TObject);
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
        SQL.Add('SELECT * FROM INTEGRATED_CODE ' +
                'WHERE PATH_CODE = :param1 ' +
                'ORDER BY CODE_SEQ ');
        ParamByName('param1').AsString := 'B06'; //현장업무
        Open;

        while not eof do
        begin
          idx := Add(FieldByName('CODE_NAME').AsString);
          FCodeDic.Add(idx, FieldByName('INT_CODE').AsString);
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TlogDialog_Frm.rst_CodeSelect(Sender: TObject);
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

procedure TlogDialog_Frm.Update_HiTEMS_TMS_RESULT;
begin
  if FRstNo <> '' then
  begin
    with DM1.OraQuery1 do
    begin
      try
        Close;
        SQL.Clear;
        SQL.Add('UPDATE DPMS_TMS_RESULT SET ' +
                'PLAN_NO = :PLAN_NO, RST_CODE = :RST_CODE, RST_PERFORM = :RST_PERFORM, ' +
                'RST_TITLE = :RST_TITLE, RST_NOTE = :RST_NOTE, RST_PROGRESS = :RST_PROGRESS, ' +
                'RST_NEXT_TASK = :RST_NEXT_TASK, PLAN_REV_NO = :PLAN_REV_NO ' +
                'WHERE RST_NO = :param1 ');
        ParamByName('param1').AsString := FRstNo;

        ParamByName('PLAN_NO').AsString       := planNo.Text;
        ParamByName('RST_CODE').AsString      := RST_CODE.Hint;
        ParamByName('RST_PERFORM').AsDate     := perform.Date;
        ParamByName('RST_TITLE').AsString     := RST_TITLE.Text;
        ParamByName('RST_NOTE').AsString      := RST_NOTE.Text;
        ParamByName('RST_PROGRESS').AsInteger := RST_PROGRESS.AsInteger;
        ParamByName('RST_NEXT_TASK').AsString := rst_Next_Task.Text;
        ParamByName('PLAN_REV_NO').AsInteger  := revNo.AsInteger;
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
end;


end.
