unit requestMain_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, AdvOfficeStatusBar,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.StdCtrls,
  AeroButtons, Vcl.ComCtrls, AdvGroupBox, AdvOfficeButtons, JvExControls,
  JvLabel, CurvyControls, Vcl.ImgList, NxColumns, NxColumnClasses, StrUtils,
  DateUtils, AdvOfficeTabSet, pjhTouchKeyboard, DataModule_Unit, AdvEdit,
  AdvEdBtn, PlannerDatePicker, Vcl.ExtCtrls, PlannerCal, JvExComCtrls,
  JvDateTimePicker, AdvDateTimePicker, Vcl.Grids, Vcl.Samples.Calendar, pjhPlannerDatePicker;

type
  TrequestMain_Frm = class(TForm)
    AdvOfficeStatusBar1: TAdvOfficeStatusBar;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Close1: TMenuItem;
    CurvyPanel1: TCurvyPanel;
    JvLabel2: TJvLabel;
    CurvyPanel2: TCurvyPanel;
    Label4: TLabel;
    rg_period: TAdvOfficeRadioGroup;
    AeroButton2: TAeroButton;
    AeroButton3: TAeroButton;
    grid_Req: TNextGrid;
    imagelist24x24: TImageList;
    JvLabel1: TJvLabel;
    btn_Request: TAeroButton;
    ImageList32x32: TImageList;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    JvLabel3: TJvLabel;
    et_Keyword: TEdit;
    JvLabel4: TJvLabel;
    JvLabel5: TJvLabel;
    et_EngType: TComboBox;
    et_ReqId: TComboBox;
    NxDateColumn1: TNxDateColumn;
    NxTextColumn4: TNxTextColumn;
    NxTextColumn6: TNxTextColumn;
    NxTextColumn7: TNxTextColumn;
    PopupMenu1: TPopupMenu;
    mi_edit: TMenuItem;
    NxTextColumn5: TNxTextColumn;
    mi_detail: TMenuItem;
    mi_return: TMenuItem;
    N2: TMenuItem;
    mi_try: TMenuItem;
    AdvOfficeTabSet1: TAdvOfficeTabSet;
    N1: TMenuItem;
    mi_testResult: TMenuItem;
    N3: TMenuItem;
    dt_begin: TpjhPlannerDatePicker;
    dt_end: TpjhPlannerDatePicker;
    procedure Close1Click(Sender: TObject);
    procedure AeroButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_RequestClick(Sender: TObject);
    procedure rg_periodClick(Sender: TObject);
    procedure AeroButton3Click(Sender: TObject);
    procedure et_EngTypeDropDown(Sender: TObject);
    procedure et_ReqIdDropDown(Sender: TObject);
    procedure et_ReqIdSelect(Sender: TObject);
    procedure grid_ReqMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mi_editClick(Sender: TObject);
    procedure mi_detailClick(Sender: TObject);
    procedure mi_returnClick(Sender: TObject);
    procedure mi_tryClick(Sender: TObject);
    procedure AdvOfficeTabSet1Change(Sender: TObject);
    procedure mi_testResultClick(Sender: TObject);
    procedure grid_ReqDblClick(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
//    FpjhPlannerCal: TpjhPlannerCal;

    procedure Get_Request_List;
    procedure Get_Request_List_IMSI;
    procedure Get_Plan_From_ReqNo(AReqNo: string);
  end;

var
  requestMain_Frm: TrequestMain_Frm;
  FpjhTouchKeyboard: TpjhPopupTouchKeyBoard;

implementation
uses
  testResult_Unit,
  resultDialog_Unit,
  testRequest_Unit,
  newTaskPlan_Unit,
  HiTEMS_TMS_COMMON;

{$R *.dfm}

procedure TrequestMain_Frm.AdvOfficeTabSet1Change(Sender: TObject);
var
  i : Integer;
  TabCaption : String;
begin
  with grid_Req do
  begin
    BeginUpdate;
    try
      TabCaption := AdvOfficeTabSet1.AdvOfficeTabs[AdvOfficeTabSet1.ActiveTabIndex].Caption;
      for i := 0 to RowCount-1 do
      begin
        if TabCaption = '전체' then
          RowVisible[i] := True
        else
        begin
          if SameText(Cells[7,i], TabCaption) then
            RowVisible[i] := True
          else
            RowVisible[i] := False;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TrequestMain_Frm.AeroButton2Click(Sender: TObject);
begin
  Close1Click(Sender);
end;

procedure TrequestMain_Frm.AeroButton3Click(Sender: TObject);
begin
  Get_Request_List;
  Get_Request_List_IMSI;
end;

procedure TrequestMain_Frm.btn_RequestClick(Sender: TObject);
begin
  if New_test_Request_Frm('') then
  begin
    Get_Request_List;
    Get_Request_List_IMSI;
  end;
end;

procedure TrequestMain_Frm.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure TrequestMain_Frm.et_EngTypeDropDown(Sender: TObject);
begin
  with et_EngType.Items do
  begin
    BeginUpdate;
    try
      Clear;

      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT ' +
                '  A.*, ' +
                '  (SELECT ENGTYPE FROM HIMSEN_INFO WHERE PROJNO LIKE TEST_ENGINE ) ENGINE ' +
                'FROM ' +
                '( ' +
                '   SELECT TEST_ENGINE FROM TMS_TEST_REQUEST ' +
                '   GROUP BY TEST_ENGINE ' +
                ') A ');
        Open;

        Add('');

        while not eof do
        begin
          Add(FieldByName('ENGINE').AsString);
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TrequestMain_Frm.et_ReqIdDropDown(Sender: TObject);
begin
  with et_ReqId.Items do
  begin
    BeginUpdate;
    try
      Clear;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT REQ_ID, NAME_KOR, DESCR FROM ' +
                '( ' +
                '   SELECT ' +
                '     REQ_ID ' +
                '   FROM TMS_TEST_REQUEST GROUP BY REQ_ID ' +
                ') A LEFT OUTER JOIN ' +
                '( ' +
                '   SELECT USERID, NAME_KOR, A.GRADE, DESCR ' +
                '   FROM HITEMS_USER A, HITEMS_USER_GRADE B ' +
                '   WHERE A.GRADE = B.GRADE ' +
                '   AND A.DEPT_CD LIKE :DEPT_CD ' +
                ') ' +
                'B ON A.REQ_ID = B.USERID ' +
                'ORDER BY NAME_KOR, GRADE ');
        ParamByName('DEPT_CD').AsString := DM1.FUSerInfo.Dept_Cd+'%';
        Open;

        Add('');
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

procedure TrequestMain_Frm.et_ReqIdSelect(Sender: TObject);
begin
  with DM1.OraQuery1 do
  begin
    if et_ReqId.ItemIndex <> 0 then
    begin
      RecNo := et_ReqId.ItemIndex;
      et_ReqId.Hint := FieldByName('REQ_ID').AsString;
    end else
      et_ReqId.Hint := '';

  end;
end;

procedure TrequestMain_Frm.FormCreate(Sender: TObject);
var
  UserID : String;
begin
  JvLabel2.Caption := '검색기간'+#10#13+'(요청일)';

  UserID := ParamStr(1);
  DM1.SetUserInfo(UserID);

  dt_begin.Date := StartOfTheWeek(today);
  dt_end.Date := EndOfTheWeek(today);

  AdvOfficeTabSet1.ActiveTabIndex := 0;

  Get_Request_List;
  Get_Request_List_IMSI;

//  TTempClass.SetPlannerCalDellDraw(Self);
  TTempClass.SetPlannerCalEvent(Self);

//  FpjhPlannerCal:= TpjhPlannerCal.Create(Self);
end;

procedure TrequestMain_Frm.FormDestroy(Sender: TObject);
begin
//  FpjhPlannerCal.Free;
end;

procedure TrequestMain_Frm.Get_Plan_From_ReqNo(AReqNo: string);
var
  ltaskNo, lplanNo: String;
  lResult: Boolean;
  lstartDate, lendDate: TDateTime;
  lteamCode: String;
  lplanRevNo: Integer;
begin
  GetPlanInfo(AReqNo, LTaskNo, LPlanNo, LTeamCode, LStartDate, LEndDate, LPlanRevNo);

  lResult := Create_newPlan_Frm(ltaskNo, lplanNo, lteamCode, lstartDate,
    lendDate, lplanRevNo);
end;

procedure TrequestMain_Frm.Get_Request_List;
var
  TabCaption : String;
begin
  with grid_Req do
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
                '     A.*, ' +
                '     (SELECT ENGTYPE FROM HIMSEN_INFO WHERE PROJNO LIKE TEST_ENGINE) ENG_TYPE, ' +
                '     (SELECT NAME_KOR FROM HITEMS_USER WHERE USERID LIKE REQ_ID) USER_NAME, ' +
                '     (SELECT DEPT_NAME FROM HITEMS_DEPT WHERE REQ_DEPT LIKE DEPT_CD) DEPT_NAME '+
                '   FROM ' +
                '   ( ' +
                '       SELECT A.*, B.PLAN_NO, NVL(B.STATUS,''미접수'') STATUS ' +
                '       FROM TMS_TEST_REQUEST A LEFT OUTER JOIN TMS_TEST_RECEIVE_INFO ' +
                '       B ON A.REQ_NO = B.REQ_NO ' +
                '   )A ' +
                ') ' +
                'WHERE INDATE BETWEEN :beginDate And :endDate ' +
                'AND STATUS != ''확인'' ' +
                'AND REQ_DEPT = :DEPT_CD ' +
                'AND UPPER(TEST_NAME) LIKE :param1 ' +
                'AND ENG_TYPE LIKE :param2 ' +
                'AND USER_NAME LIKE :param3 ' +
                'ORDER BY TEST_BEGIN, TEST_NAME ' );

        ParamByName('beginDate').AsDate := dt_begin.Date;
        ParamByName('endDate').AsDate := dt_end.Date;
        ParamByName('DEPT_CD').AsString := DM1.FUSerInfo.FDept_Cd;

        if et_Keyword.Text <> '' then
          ParamByName('param1').AsString := '%'+et_Keyword.Text+'%'
        else
          SQL.Text := ReplaceStr(SQL.Text,'AND UPPER(TEST_NAME) LIKE :param1 ','');

        if et_EngType.Text <> '' then
          ParamByName('param2').AsString := '%'+et_EngType.Text+'%'
        else
          SQL.Text := ReplaceStr(SQL.Text,'AND ENG_TYPE LIKE :param2 ','');

        if et_ReqId.Text <> '' then
          ParamByName('param3').AsString := '%'+et_ReqId.Text+'%'
        else
          SQL.Text := ReplaceStr(SQL.Text,'AND USER_NAME LIKE :param3 ','');

        Open;

        while not eof do
        begin
          AddRow;

          Cells[1,LastAddedRow] := FieldByName('REQ_NO').AsString;
          Cells[2,LastAddedRow] := FieldByName('DEPT_NAME').AsString;
          Cells[3,LastAddedRow] := FieldByName('USER_NAME').AsString;
          Cells[4,LastAddedRow] := FieldByName('TEST_NAME').AsString;
          Cells[5,LastAddedRow] := FieldByName('ENG_TYPE').AsString;

          Cells[6,LastAddedRow] := FormatDateTime('yyyy-MM-dd HH:mm', FieldByName('INDATE').AsDateTime);
          Cells[7,LastAddedRow] := FieldByName('STATUS').AsString;
          Cells[8,LastAddedRow] := FieldByName('REQ_ID').AsString;

          TabCaption := AdvOfficeTabSet1.AdvOfficeTabs[AdvOfficeTabSet1.ActiveTabIndex].Caption;
          if TabCaption <> '전체' then
          begin
            if SameText(Cells[7,LastAddedRow], TabCaption) then
              RowVisible[LastAddedRow] := True
            else
              RowVisible[LastAddedRow] := False;
          end else
            RowVisible[LastAddedRow] := True;

          Next;

        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TrequestMain_Frm.Get_Request_List_IMSI;
var
  TabCaption : String;
  i: integer;
begin
  with grid_Req do
  begin
    //BeginUpdate;
    try
      //ClearRows;
      for i := 0 to RowCount - 1 do
      begin
        if Cells[7,i] = '임시' then
        begin
          DeleteRow(i);
        end;
      end;

      with DM1.OraQuery2 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM ' +
                '( ' +
                '   SELECT ' +
                '     A.*, ' +
                '     (SELECT ENGTYPE FROM HIMSEN_INFO WHERE PROJNO LIKE TEST_ENGINE) ENG_TYPE, ' +
                '     (SELECT NAME_KOR FROM HITEMS_USER WHERE USERID LIKE REQ_ID) USER_NAME, ' +
                '     (SELECT DEPT_NAME FROM HITEMS_DEPT WHERE REQ_DEPT LIKE DEPT_CD) DEPT_NAME '+
                '   FROM ' +
                '   ( ' +
                '       SELECT A.*, B.PLAN_NO, NVL(B.STATUS,''임시'') STATUS ' +
                '       FROM TMS_TEST_REQUEST_IMSI A LEFT OUTER JOIN TMS_TEST_RECEIVE_INFO ' +
                '       B ON A.REQ_NO = B.REQ_NO ' +
                '   )A ' +
                ') ' +
                'WHERE INDATE BETWEEN :beginDate And :endDate ' +
                //'AND STATUS = ''임시'' ' +
                'AND REQ_DEPT = :DEPT_CD ' +
                'AND UPPER(TEST_NAME) LIKE :param1 ' +
                'AND ENG_TYPE LIKE :param2 ' +
                'AND USER_NAME LIKE :param3 ' +
                'ORDER BY TEST_BEGIN, TEST_NAME ' );

        ParamByName('beginDate').AsDate := dt_begin.Date;
        ParamByName('endDate').AsDate := dt_end.Date+1;
        ParamByName('DEPT_CD').AsString := DM1.FUSerInfo.FDept_Cd;

        if et_Keyword.Text <> '' then
          ParamByName('param1').AsString := '%'+et_Keyword.Text+'%'
        else
          SQL.Text := ReplaceStr(SQL.Text,'AND UPPER(TEST_NAME) LIKE :param1 ','');

        if et_EngType.Text <> '' then
          ParamByName('param2').AsString := '%'+et_EngType.Text+'%'
        else
          SQL.Text := ReplaceStr(SQL.Text,'AND ENG_TYPE LIKE :param2 ','');

        if et_ReqId.Text <> '' then
          ParamByName('param3').AsString := '%'+et_ReqId.Text+'%'
        else
          SQL.Text := ReplaceStr(SQL.Text,'AND USER_NAME LIKE :param3 ','');

        Open;

        while not eof do
        begin
          AddRow;

          Cells[1,LastAddedRow] := FieldByName('REQ_NO').AsString;
          Cells[2,LastAddedRow] := FieldByName('DEPT_NAME').AsString;
          Cells[3,LastAddedRow] := FieldByName('USER_NAME').AsString;
          Cells[4,LastAddedRow] := FieldByName('TEST_NAME').AsString;
          Cells[5,LastAddedRow] := FieldByName('ENG_TYPE').AsString;

          Cells[6,LastAddedRow] := FormatDateTime('yyyy-MM-dd HH:mm', FieldByName('INDATE').AsDateTime);
          Cells[7,LastAddedRow] := FieldByName('STATUS').AsString;
          Cells[8,LastAddedRow] := FieldByName('REQ_ID').AsString;

          TabCaption := AdvOfficeTabSet1.AdvOfficeTabs[AdvOfficeTabSet1.ActiveTabIndex].Caption;
          if TabCaption = '임시저장' then
          begin
            if SameText(Cells[7,LastAddedRow], '임시') then
              RowVisible[LastAddedRow] := True
            else
              RowVisible[LastAddedRow] := False;
          end;

          Next;

        end;
      end;
    finally
      //EndUpdate;
    end;
  end;
end;

procedure TrequestMain_Frm.grid_ReqDblClick(Sender: TObject);
var
  LReqNo : String;
begin
  with grid_Req do
  begin
    if SelectedRow <> -1 then
    begin
      if mi_detail.Enabled then
        Preview_Request_Frm(Cells[1,SelectedRow]);
    end;
  end;
end;

procedure TrequestMain_Frm.grid_ReqMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  LRow : Integer;
begin
  with grid_Req do
  begin
    LRow := GetRowAtPos(X,Y);
    if LRow = -1 then
    begin
      SelectedRow := LRow;

      mi_detail.Enabled := False;
      mi_edit.Enabled := False;
      mi_return.Enabled := False;
      mi_try.Enabled := False;
      mi_testResult.Enabled := False;
    end else
    begin
      mi_detail.Enabled := (LRow > -1) and (Cells[7,LRow] <> '임시');
      mi_edit.Enabled := (Cells[8,LRow] = DM1.FUSerInfo.FUserID) And ((Cells[7,LRow] = '미접수') or (Cells[7,LRow] = '임시'));
      mi_return.Enabled := (Cells[7,LRow] = '반려');
      mi_try.Enabled := (Cells[7,LRow] = '반려');
      mi_testResult.Enabled := ((Cells[7,LRow] = '진행') or (Cells[7,LRow] = '완료'));
    end;
  end;
end;

procedure TrequestMain_Frm.mi_detailClick(Sender: TObject);
var
  LReqNo : String;
begin
  with grid_Req do
  begin
    if SelectedRow <> -1 then
    begin
      if Cells[7,SelectedRow] = '임시' then
        Preview_Request_Frm(Cells[1,SelectedRow], '임시')
      else
        Preview_Request_Frm(Cells[1,SelectedRow]);
    end;
  end;
end;

procedure TrequestMain_Frm.mi_editClick(Sender: TObject);
var
  LReqNo : String;
begin
  with grid_Req do
  begin
    if SelectedRow <> -1 then
    begin
      if Cells[7,SelectedRow] = '임시' then
      begin
        if New_test_Request_Frm(Cells[1,SelectedRow],'임시') then
        begin
          Get_Request_List_IMSI;
        end;
      end
      else
      begin
        if New_test_Request_Frm(Cells[1,SelectedRow]) then
        begin
          Get_Request_List;
          Get_Request_List_IMSI;
        end;
      end;
    end;
  end;
end;

procedure TrequestMain_Frm.mi_returnClick(Sender: TObject);
begin
  with grid_Req do
  begin
    BeginUpdate;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM TMS_TEST_RECEIVE_INFO ' +
                'WHERE REQ_NO LIKE :param1 ');
        ParamByName('param1').AsString := Cells[1,SelectedRow];
        Open;

        if RecordCount <> 0 then
        begin
          Create_resultDialog_Frm('반려메세지 확인', FieldByName('REMARK').AsString);

        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TrequestMain_Frm.mi_testResultClick(Sender: TObject);
begin
  with grid_Req do
  begin
    if SelectedRow = -1 then
      Exit;

    View_Test_Result(Cells[4,SelectedRow],
                     Cells[1,SelectedRow]);

  end;

end;

procedure TrequestMain_Frm.mi_tryClick(Sender: TObject);
begin
  with grid_Req do
  begin
    if Try_test_Request_Frm(Cells[1,SelectedRow]) then
      Get_Request_List;
  end;
end;

procedure TrequestMain_Frm.N3Click(Sender: TObject);
var
  LReqNo : String;
begin
  with grid_Req do
  begin
    if SelectedRow <> -1 then
    begin
      LReqNo := Cells[7,SelectedRow];//상태

      if (LReqNo = '진행') or (LReqNo = '완료') then
      begin
        LReqNo := Cells[1,SelectedRow];
        Get_Plan_From_ReqNo(LReqNo);
      end
      else
      begin
        ShowMessage('상태가 ''진행'' 또는 ''완료'' 인 경우에만 진행계획 조회 가능함!');
      end;
    end;//if
  end;//with
end;

procedure TrequestMain_Frm.rg_periodClick(Sender: TObject);
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
