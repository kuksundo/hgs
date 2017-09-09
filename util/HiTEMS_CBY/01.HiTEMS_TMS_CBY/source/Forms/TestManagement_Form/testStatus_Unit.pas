unit testStatus_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.StdCtrls, AeroButtons, JvExControls, JvLabel, CurvyControls, Vcl.ImgList,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, AdvOfficeTabSet,
  NxColumnClasses, NxColumns, Vcl.ComCtrls, Vcl.Menus, AdvGroupBox,
  AdvOfficeButtons, StrUtils, DateUtils;

type
  TtestStatus_Frm = class(TForm)
    Panel8: TPanel;
    Image1: TImage;
    imagelist24x24: TImageList;
    ImageList32x32: TImageList;
    ImageList16x16: TImageList;
    CurvyPanel1: TCurvyPanel;
    JvLabel11: TJvLabel;
    btn_Close: TAeroButton;
    AdvOfficeTabSet1: TAdvOfficeTabSet;
    grid_Req: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    tc_reqNo: TNxTextColumn;
    NxTextColumn6: TNxTextColumn;
    NxTextColumn7: TNxTextColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    NxDateColumn1: TNxDateColumn;
    NxTextColumn3: TNxTextColumn;
    PopupMenu1: TPopupMenu;
    mi_Receive: TMenuItem;
    mi_detail: TMenuItem;
    N1: TMenuItem;
    mi_complete: TMenuItem;
    btn_Search: TAeroButton;
    CurvyPanel2: TCurvyPanel;
    JvLabel2: TJvLabel;
    JvLabel5: TJvLabel;
    cb_engType: TComboBox;
    JvLabel6: TJvLabel;
    cb_engProjNo: TComboBox;
    JvLabel1: TJvLabel;
    cb_team: TComboBox;
    JvLabel3: TJvLabel;
    cb_user: TComboBox;
    JvLabel7: TJvLabel;
    et_keyWord: TEdit;
    NxTextColumn5: TNxTextColumn;
    AdvOfficeRadioGroup1: TAdvOfficeRadioGroup;
    rg_period: TAdvOfficeRadioGroup;
    dt_begin: TDateTimePicker;
    Label4: TLabel;
    dt_end: TDateTimePicker;
    N2: TMenuItem;
    N3: TMenuItem;
    JvLabel14: TJvLabel;
    et_msNumber: TEdit;
    Button2: TButton;
    procedure btn_CloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure grid_ReqCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure grid_ReqMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AdvOfficeTabSet1Change(Sender: TObject);
    procedure mi_ReceiveClick(Sender: TObject);
    procedure mi_detailClick(Sender: TObject);
    procedure mi_completeClick(Sender: TObject);
    procedure cb_engTypeDropDown(Sender: TObject);
    procedure cb_engProjNoDropDown(Sender: TObject);
    procedure rg_periodClick(Sender: TObject);
    procedure cb_teamDropDown(Sender: TObject);
    procedure cb_teamSelect(Sender: TObject);
    procedure cb_userDropDown(Sender: TObject);
    procedure btn_SearchClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Get_Request_List;
    function Test_Complete(aReqNo: String): Boolean;
    procedure Get_Plan_From_ReqNo(AReqNo: string);

    procedure Send_SMS;
    procedure Send_Message_Main_CODE(FFlag,FSendID,FRecID,FHead,FTitle,FContent:String); // 메세지 메인 함수
  end;

var
  testStatus_Frm: TtestStatus_Frm;
function Get_selected_Test(aReqNo: String): String;

implementation

uses
  HHI_WebService,
  UnitHHIMessage,
  HiTEMS_TMS_CONST,
  HiTEMS_TMS_COMMON,
  testRequest_Unit,
  testReceive_Unit,
  DataModule_Unit,
  newTaskPlan_Unit;

{$R *.dfm}

function Get_selected_Test(aReqNo: String): String;
begin
  testStatus_Frm := TtestStatus_Frm.Create(nil);
  try
    with testStatus_Frm do
    begin
      FormStyle := fsNormal;
      Position  := poScreenCenter;
      Visible := False;
      grid_Req.PopupMenu := nil;

      ShowModal;

      if ModalResult = mrOk then
      begin
        if grid_Req.SelectedRow <> -1 then
          Result := grid_Req.Cells[1, grid_Req.SelectedRow];
      end;
    end;
  finally
    FreeAndNil(testStatus_Frm);
  end;
end;

procedure TtestStatus_Frm.AdvOfficeTabSet1Change(Sender: TObject);
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


procedure TtestStatus_Frm.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TtestStatus_Frm.btn_SearchClick(Sender: TObject);
begin
  Get_Request_List;
end;

procedure TtestStatus_Frm.cb_engProjNoDropDown(Sender: TObject);
begin
  with cb_engProjNo.Items do
  begin
    BeginUpdate;
    try
      Clear;

      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT  ' +
                ' TEST_ENGINE, ' +
                ' ENGTYPE, ' +
                ' TO_NUMBER(SUBSTR(ENGTYPE, 1, INSTR(ENGTYPE, ''H'') - 1)) CYLNUM ' +
                'FROM ' +
                '( ' +
                '   SELECT ' +
                '     TEST_ENGINE, ' +
                '     (SELECT ENGTYPE FROM HIMSEN_INFO WHERE PROJNO LIKE TEST_ENGINE) ENGTYPE ' +
                '   FROM TMS_TEST_REQUEST A ' +
                '   GROUP BY TEST_ENGINE ' +
                ')WHERE ENGTYPE LIKE :ENGTYPE ' +
                'ORDER BY CYLNUM, ENGTYPE, TEST_ENGINE ');

        if cb_engType.Text <> '' then
          ParamByName('ENGTYPE').AsString := cb_engType.Text
        else
          SQL.Text := ReplaceStr(SQL.Text, 'WHERE ENGTYPE LIKE :ENGTYPE ', '');

        Open;

        Add('');
        while not eof do
        begin
          Add(FieldByName('TEST_ENGINE').AsString);
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TtestStatus_Frm.cb_engTypeDropDown(Sender: TObject);
begin
  with cb_engType.Items do
  begin
    BeginUpdate;
    try
      Clear;

      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT  ' +
                ' TEST_ENGINE, ' +
                ' ENGTYPE, ' +
                ' TO_NUMBER(SUBSTR(ENGTYPE, 1, INSTR(ENGTYPE, ''H'') - 1)) CYLNUM ' +
                'FROM ' +
                '( ' +
                '   SELECT ' +
                '     TEST_ENGINE, ' +
                '     (SELECT ENGTYPE FROM HIMSEN_INFO WHERE PROJNO LIKE TEST_ENGINE) ENGTYPE ' +
                '   FROM TMS_TEST_REQUEST A ' +
                '   GROUP BY TEST_ENGINE ' +
                ')WHERE TEST_ENGINE LIKE :TEST_ENGINE ' +
                'ORDER BY CYLNUM, ENGTYPE, TEST_ENGINE ');

        if cb_engProjNo.Text <> '' then
          ParamByName('TEST_ENGINE').AsString := cb_engProjNo.Text
        else
          SQL.Text := ReplaceStr(SQL.Text, 'WHERE TEST_ENGINE LIKE :TEST_ENGINE ', '');

        Open;

        Add('');
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

procedure TtestStatus_Frm.cb_teamDropDown(Sender: TObject);
begin
  with cb_team.Items do
  begin
    BeginUpdate;
    try
      Clear;

      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT ' +
                ' REQ_DEPT, ' +
                ' (SELECT DEPT_NAME FROM HITEMS_DEPT WHERE DEPT_CD LIKE REQ_DEPT) DEPT_NAME ' +
                'FROM TMS_TEST_REQUEST A ' +
                'GROUP BY REQ_DEPT ' +
                'ORDER BY REQ_DEPT ');

        Open;

        Add('');
        while not eof do
        begin
          Add(FieldByName('DEPT_NAME').AsString);
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TtestStatus_Frm.cb_teamSelect(Sender: TObject);
begin
  cb_user.Items.Clear;
  cb_user.Clear;
end;

procedure TtestStatus_Frm.cb_userDropDown(Sender: TObject);
begin
  with cb_user.Items do
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
                '   SELECT ' +
                '     REQ_DEPT, ' +
                '     REQ_ID, ' +
                '     (SELECT DEPT_NAME FROM HITEMS_DEPT WHERE DEPT_CD LIKE REQ_DEPT) DEPT_NAME, ' +
                '     (SELECT NAME_KOR FROM HITEMS_USER WHERE USERID LIKE REQ_ID) REQ_ID_NAME ' +
                '   FROM TMS_TEST_REQUEST A ' +
                '   GROUP BY REQ_DEPT, REQ_ID ' +
                ') ' +
                'WHERE DEPT_NAME LIKE :DEPT_NAME ' +
                'ORDER BY REQ_DEPT, REQ_ID_NAME ');

        if cb_team.Text <> '' then
          ParamByName('DEPT_NAME').AsString := cb_team.Text
        else
          SQL.Text := ReplaceStr(SQL.Text, 'WHERE DEPT_NAME LIKE :DEPT_NAME ', '');


        Open;

        Add('');
        while not eof do
        begin
          Add(FieldByName('REQ_ID_NAME').AsString);
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TtestStatus_Frm.FormCreate(Sender: TObject);
begin
  JvLabel2.Caption := '검색기간'+#10#13+'(요청일)';

  dt_begin.Date := StartOfTheWeek(today);
  dt_end.Date   := EndOfTheWeek(today);

  AdvOfficeTabSet1.ActiveTabIndex := 0;
  Get_Request_List;
end;

procedure TtestStatus_Frm.Get_Plan_From_ReqNo(AReqNo: string);
var
  LTaskNo, LPlanNo: string;
  LResult: Boolean;
  LStartDate, LEndDate: TDateTime;
  LTeamCode: string;
  LPlanRevNo: integer;
begin
  GetPlanInfo(AReqNo, LTaskNo, LPlanNo, LTeamCode, LStartDate, LEndDate, LPlanRevNo);

  LResult := Create_NewPlan_Frm(LTaskNo, LPlanNo, LTeamCode, LStartDate, LEndDate, LPlanRevNo);
end;

procedure TtestStatus_Frm.Get_Request_List;
var
  TabCaption: String;
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
        SQL.Add('SELECT * FROM   ' +
                '(   ' +
                '   SELECT   ' +
                '     A.*,   ' +
                '     (SELECT ENGTYPE FROM HIMSEN_INFO WHERE PROJNO LIKE TEST_ENGINE) ENG_TYPE, ' +
                '     (SELECT NAME_KOR FROM HITEMS_USER WHERE USERID LIKE REQ_ID) USER_NAME,   ' +
                '     (SELECT DEPT_NAME FROM HITEMS_DEPT WHERE REQ_DEPT LIKE DEPT_CD) DEPT_NAME  ' +
                '   FROM   ' +
                '   (   ' +
                '     SELECT A.*, B.PLAN_NO, NVL(B.STATUS,''미접수'') STATUS, RECEIVE_ID ' +
                '     FROM TMS_TEST_REQUEST A LEFT OUTER JOIN TMS_TEST_RECEIVE_INFO '+
                '     B ON A.REQ_NO = B.REQ_NO   ' +
                '   )A   ' +
                ')  ' +
                'WHERE INDATE BETWEEN :beginDate And :endDate ' +
                'AND STATUS != ''확인'' ' +
                'AND TEST_ENGINE LIKE :PROJNO ' +
                'AND ENG_TYPE LIKE :ENG_TYPE ' +
                'AND UPPER(TEST_NAME) LIKE :TEST_NAME ' +
                'AND DEPT_NAME LIKE :DEPT_NAME ' +
                'AND USER_NAME LIKE :USER_NAME ' +
                'ORDER BY TEST_BEGIN ');

        ParamByName('beginDate').AsDate := dt_begin.Date;
        ParamByName('endDate').AsDate   := dt_end.Date;

        if cb_engProjNo.Text <> '' then
          ParamByName('PROJNO').AsString := cb_engProjNo.Text
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND TEST_ENGINE LIKE :PROJNO ', '');

        if cb_engType.Text <> '' then
          ParamByName('ENG_TYPE').AsString := cb_engType.Text
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND ENG_TYPE LIKE :ENG_TYPE ', '');

        if et_keyWord.Text <> '' then
          ParamByName('TEST_NAME').AsString := '%' + et_keyWord.Text + '%'
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND UPPER(TEST_NAME) LIKE :TEST_NAME ', '');

        if cb_team.Text <> '' then
          ParamByName('DEPT_NAME').AsString := cb_team.Text
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND DEPT_NAME LIKE :DEPT_NAME ', '');

        if cb_user.Text <> '' then
          ParamByName('USER_NAME').AsString := '%' + cb_user.Text + '%'
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND USER_NAME LIKE :USER_NAME ', '');

        Open;

        TabCaption := AdvOfficeTabSet1.AdvOfficeTabs [AdvOfficeTabSet1.ActiveTabIndex].Caption;
        while not eof do
        begin
          AddRow;
          //if FieldByName('REQ_NO').AsString = 'QE3201402011' then
          //  Cells[1, LastAddedRow] := FieldByName('REQ_NO').AsString;

          Cells[1, LastAddedRow] := FieldByName('REQ_NO').AsString;
          Cells[2, LastAddedRow] := FieldByName('DEPT_NAME').AsString;
          Cells[3, LastAddedRow] := FieldByName('USER_NAME').AsString;
          Cells[4, LastAddedRow] := FieldByName('TEST_NAME').AsString;
          Cells[5, LastAddedRow] := FieldByName('ENG_TYPE').AsString;

          Cells[6, LastAddedRow] := FormatdateTime('yyyy-MM-dd HH:mm',
            FieldByName('INDATE').AsDateTime);
          Cells[7, LastAddedRow] := FieldByName('STATUS').AsString;


          if TabCaption <> '전체' then
          begin
            if SameText(Cells[7,LastAddedRow], TabCaption) then
              RowVisible[LastAddedRow] := True
            else
              RowVisible[LastAddedRow] := False;
          end else
            RowVisible[LastAddedRow] := True;

          Cells[8, LastAddedRow] := FieldByName('RECEIVE_ID').AsString;


          Next;

        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TtestStatus_Frm.grid_ReqCellDblClick(Sender: TObject;
  ACol, ARow: Integer);
var
  i: Integer;
begin
  if ARow = -1 then
    Exit;

  ModalResult := mrOk;
end;

procedure TtestStatus_Frm.grid_ReqMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
  TabCaption: String;

  LRow: Integer;
begin
  with grid_Req do
  begin
    BeginUpdate;
    try
      LRow := GetRowAtPos(X, Y);
      if LRow = -1 then
      begin
        mi_Receive.Enabled := False;
        mi_detail.Enabled := False;
        mi_complete.Enabled := False;
        SelectedRow := LRow;
        Exit;
      end
      else
      begin
        mi_detail.Enabled := True;
        mi_Receive.Enabled := Cells[7, LRow] = '미접수';

        if (Cells[7, LRow] = '진행') AND (Cells[8, LRow] = DM1.FUserInfo.CurrentUsers) then
          mi_complete.Enabled := True
        else
          mi_complete.Enabled := False;

      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TtestStatus_Frm.mi_completeClick(Sender: TObject);
begin
  with grid_Req do
  begin
    if SelectedRow = -1 then
      Exit;

    if MessageDlg('시험명 : ' + Cells[4, SelectedRow] + #10#13 + '완료 처리 하시겠습니까? ',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin

      if Test_Complete(Cells[1, SelectedRow]) then
        Get_Request_List;

      Send_SMS;

    end;
  end;
end;

procedure TtestStatus_Frm.mi_detailClick(Sender: TObject);
begin
  Preview_Request_Frm(grid_Req.Cells[1, grid_Req.SelectedRow]);
end;

procedure TtestStatus_Frm.mi_ReceiveClick(Sender: TObject);
begin
  with grid_Req do
  begin
    if SelectedRow = -1 then
      Exit
    else if Create_test_Receive_Frm(Cells[1, SelectedRow]) then
      Get_Request_List;

  end;

end;

procedure TtestStatus_Frm.N2Click(Sender: TObject);
var
  LReqNo: string;
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
        ShowMessage('상태가 ''진행'' 또는 ''완료''인 경우에만 진행계획 조회 가능함!');
      end;
    end;
  end;//with
end;

procedure TtestStatus_Frm.rg_periodClick(Sender: TObject);
begin
  dt_begin.Enabled := False;
  dt_end.Enabled := False;
  case rg_period.ItemIndex of
    0:
      begin
        dt_begin.Date := Now;
        dt_end.Date := Now;
      end;
    1:
      begin
        dt_begin.Date := StartOfTheWeek(Now);
        dt_end.Date := EndOfTheWeek(Now);
      end;
    2:
      begin
        dt_begin.Date := StartOfTheMonth(Now);
        dt_end.Date := EndOfTheMonth(Now);
      end;
    3:
      begin
        dt_begin.Enabled := True;
        dt_end.Enabled := True;
      end;
  end;
end;

procedure TtestStatus_Frm.Send_Message_Main_CODE(FFlag, FSendID, FRecID, FHead,
  FTitle, FContent: String);
var
  LTXK0SMS2 : TXK0SMS2;
begin

  LTXK0SMS2 := TXK0SMS2.Create;
  try
    LTXK0SMS2.SEND_SABUN := FSendID;
    LTXK0SMS2.RCV_SABUN := FRecID;
    LTXK0SMS2.SYS_TYPE := '112';
    LTXK0SMS2.NOTICE_GUBUN := FFlag;

    LTXK0SMS2.TITLE := FTitle;
    //LTXK0SMS2.SEND_HPNO := '010-4190-6742';
    //LTXK0SMS2.RCV_HPNO := '010-3351-7553';
    LTXK0SMS2.CONTENT := FContent;
    LTXK0SMS2.ALIM_HEAD := FHead;

    SendHHIMessage(LTXK0SMS2);
  finally
    LTXK0SMS2.Free;
  end;
end;

procedure TtestStatus_Frm.Send_SMS;
var
  li,le : Integer;
  LMsg,
  LReqID,
  lflag,
  lhead,
  ltitle,
  lstr,
  lcontent : AnsiString;

begin
//  헤더의 길이가 21byte를 넘지 않아야 함.
//  lhead := 'HiTEMS-문제점보고서';
//  lhead := '123456780123456789012';

  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT REQ_ID FROM TMS_TEST_REQUEST ' +
            'WHERE REQ_NO LIKE :param1 ');

    ParamByName('param1').AsString := grid_Req.CellsByName['tc_reqNo',grid_Req.SelectedRow];
    Open;

    if RecordCount <> 0 then
    begin
      lhead    := 'HiTEMS ';
      ltitle   := '시험완료건 ';
      LReqID := FieldByName('REQ_ID').AsString;

      LMsg := '요청하신 시험('+grid_Req.Cells[4,grid_Req.SelectedRow]+')이 완료 되었습니다. ' +
              '결과는 시험요청서에서 확인하실 수 있습니다.';

      lcontent := LMsg;
      lcontent := StringReplace(lcontent,#$D#$A,'',[rfReplaceAll]);
      for le := 0 to 1 do
      begin
        case le of
          0 : lflag := 'A'; //쪽지
          1 : lflag := 'B'; //SMS
        end;

        if lflag = 'B' then
        begin
          while True do
          begin
            if lcontent = '' then
              Break;

            if Length(AnsiString(lcontent)) > 80 then
            begin
              lstr := Copy(lcontent,1,80);
              lcontent := Copy(lcontent,81,Length(lcontent)-80);
            end else
            begin
              lstr := Copy(lcontent,1,Length(lcontent));
              lcontent := '';
            end;
            //문자 메세지는 title(lstr)만 보낸다.
            Send_Message_Main_CODE(LFlag,DM1.FUserInfo.CurrentUsers,LReqID,LHead,lstr,LTitle);
          end;
        end
        else
        begin
          lstr := lcontent;
          Send_Message_Main_CODE(LFlag,DM1.FUserInfo.CurrentUsers,LReqID,LHead,LTitle,lstr);

        end;
      end;
    end;
  end;
end;


function TtestStatus_Frm.Test_Complete(aReqNo: String): Boolean;
begin
  Result := False;
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('UPDATE TMS_TEST_RECEIVE_INFO SET ' + 'STATUS = ''완료'' ' +
      'WHERE REQ_NO LIKE :param1 ');
    ParamByName('param1').AsString := aReqNo;
    try
      ExecSQL;
      ShowMessage('완료성공!');
      Result := True;
    except
      On E: Exception do
      begin
        ShowMessage(E.Message);
      end;
    end;
  end;
end;

end.
