unit testReceive_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.StdCtrls, AeroButtons, JvExControls, JvLabel, CurvyControls,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, Vcl.ComCtrls, AdvDateTimePicker, Vcl.ImgList, NxEdit,
  AdvGlowButton, Vcl.Menus, Ora, AdvMenus, winapi.ShellApi, DB, DateUtils,
  StrUtils;

type
  TtestReceive_Frm = class(TForm)
    Panel8: TPanel;
    Image1: TImage;
    CurvyPanel1: TCurvyPanel;
    JvLabel11: TJvLabel;
    btn_Close: TAeroButton;
    JvLabel1: TJvLabel;
    JvLabel10: TJvLabel;
    JvLabel15: TJvLabel;
    JvLabel2: TJvLabel;
    JvLabel4: TJvLabel;
    JvLabel6: TJvLabel;
    et_testName: TEdit;
    et_testPurpose: TEdit;
    et_engLoc: TEdit;
    JvLabel3: TJvLabel;
    et_reqDept: TEdit;
    JvLabel5: TJvLabel;
    et_reqIncharge: TEdit;
    btn_receive: TAeroButton;
    imagelist24x24: TImageList;
    ImageList32x32: TImageList;
    ImageList16x16: TImageList;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    JvLabel8: TJvLabel;
    et_method: TMemo;
    JvLabel12: TJvLabel;
    fileGrid: TNextGrid;
    NxIncrementColumn3: TNxIncrementColumn;
    NxTextColumn8: TNxTextColumn;
    NxTextColumn11: TNxTextColumn;
    NxTextColumn12: TNxTextColumn;
    NxTextColumn19: TNxTextColumn;
    NxTextColumn20: TNxTextColumn;
    JvLabel7: TJvLabel;
    et_engType: TEdit;
    et_begin: TEdit;
    et_end: TEdit;
    JvLabel9: TJvLabel;
    JvLabel13: TJvLabel;
    Bevel1: TBevel;
    JvLabel14: TJvLabel;
    JvLabel16: TJvLabel;
    AdvGlowButton7: TAdvGlowButton;
    AdvGlowButton1: TAdvGlowButton;
    JvLabel17: TJvLabel;
    JvLabel18: TJvLabel;
    JvLabel19: TJvLabel;
    empGrid: TNextGrid;
    NxIncrementColumn2: TNxIncrementColumn;
    NxTextColumn5: TNxTextColumn;
    NxTextColumn6: TNxTextColumn;
    NxComboBoxColumn1: TNxComboBoxColumn;
    NxTextColumn7: TNxTextColumn;
    NxTextColumn9: TNxTextColumn;
    AdvGlowButton4: TAdvGlowButton;
    AdvGlowButton2: TAdvGlowButton;
    et_taskName: TEdit;
    planCode: TEdit;
    JvLabel20: TJvLabel;
    btn_return: TAeroButton;
    et_ReqNo: TEdit;
    AdvPopupMenu1: TAdvPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    SaveDialog1: TSaveDialog;
    planStart: TDateTimePicker;
    planEnd: TDateTimePicker;
    et_mh: TNxNumberEdit;
    et_planNo: TEdit;
    grid_part: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn10: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn4: TNxTextColumn;
    NxTextColumn13: TNxTextColumn;
    NxTextColumn22: TNxTextColumn;
    NxTextColumn18: TNxTextColumn;
    NxTextColumn14: TNxTextColumn;
    NxTextColumn15: TNxTextColumn;
    NxTextColumn21: TNxTextColumn;
    NxNumberColumn1: TNxNumberColumn;
    procedure btn_CloseClick(Sender: TObject);
    procedure btn_receiveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AdvGlowButton7Click(Sender: TObject);
    procedure fileGridCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure AdvGlowButton1Click(Sender: TObject);
    procedure AdvGlowButton2Click(Sender: TObject);
    procedure AdvGlowButton4Click(Sender: TObject);
    procedure btn_returnClick(Sender: TObject);
    procedure planStartChange(Sender: TObject);
    procedure planEndChange(Sender: TObject);
    procedure grid_partCellDblClick(Sender: TObject; ACol, ARow: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
    function INSERT_INTO_HiTEMS_TMS_PLAN(aPlanNo,aModCause:String;aRevNo:Integer) : Boolean;
    procedure INSERT_INTO_HiTEMS_TMS_PLAN_INCHARGE(aPlanNo:string;aPlanRevNo:Integer);

    procedure Insert_Receive_Info(aReqNo,aPlanNo,aStatus,aComment:String);
    procedure Get_Request_Resource(aReqNo:String);
    procedure Get_Choose_List(aIdx:Integer;aPartNo: String);
    procedure Get_Attfiles(aGrid:TNextGrid;aOwner:String);

    procedure Send_SMS(aMsg:String);
    procedure Send_Message_Main_CODE(FFlag,FSendID,FRecID,FHead,FTitle,FContent:String); // 메세지 메인 함수

  end;

var
  testReceive_Frm: TtestReceive_Frm;
  function Create_test_Receive_Frm(aReqNo:String):Boolean;

implementation
uses
  detailPartInfo_Unit,
  HHI_WebService,
  UnitHHIMessage,
  resultDialog_Unit,
  findUser_Unit,
  selectCode_Unit,
  chooseTask_Unit,
  CommonUtil_Unit,
  HiTEMS_TMS_COMMON,
  HiTEMS_TMS_CONST,
  DataModule_Unit;

{$R *.dfm}

function Create_test_Receive_Frm(aReqNo:String):Boolean;
begin
  Result := False;
  testReceive_Frm := TtestReceive_Frm.Create(nil);
  try
    with testReceive_Frm do
    begin
      et_ReqNo.Text := aReqNo;
      Get_Request_Resource(et_ReqNo.Text);

      ShowModal;

      if ModalResult = mrOk then
        Result := True;

    end;
  finally
    FreeAndNil(testReceive_Frm);
  end;
end;

procedure TtestReceive_Frm.AdvGlowButton1Click(Sender: TObject);
var
  lResult : String;
begin
  lResult := Create_selectCode_Frm(planCode.Hint, 'A');

  if lResult <> '' then
  begin
    planCode.Hint := lResult;
    planCode.Text := Get_Hitems_Code_Name(planCode.Hint);
  end else
  begin
    planCode.Hint := '';
    planCode.Clear;
  end;
end;

procedure TtestReceive_Frm.AdvGlowButton2Click(Sender: TObject);
var
  lResult : String;
  li : Integer;
  list : TStringList;
  lrow : Integer;
  lUserId,
  str : String;
  SearchOptions: TSearchOptions;
begin
  SearchOptions := [];
//  Include(SearchOptions, soCaseInsensitive);
//  Include(SearchOptions, soFromSelected);
  Include(SearchOptions, soContinueFromTop);
//  Include(SearchOptions, soExactMatch);

//  NextGrid1.FindText(0, edtText.Text, SearchOptions);

  lResult := Create_findUser_Frm(DM1.FUserInfo.CurrentUsers,'M');

  if lResult <> '' then
  begin
    list := TStringList.Create;
    try
      ExtractStrings([';'],[],PChar(lResult),list);

      if list.Count <> -1 then
      begin
        with empGrid do
        begin
          BeginUpdate;
          try
            for li := 0 to list.Count-1 do
            begin
              str := list.Strings[li];
              if not FindText(4,str,SearchOptions) then
              begin
                with DM1.OraQuery1 do
                begin
                  Close;
                  SQL.Clear;
                  SQL.Add('SELECT * from DPMS_USER A, DPMS_USER_GRADE B ' +
                          'WHERE A.USERID = :param1 ' +
                          'AND A.GUNMU LIKE ''I'' ' +
                          'AND A.GRADE = B.GRADE ');
                  ParamByName('param1').AsString := list.Strings[li];
                  Open;

                  if not RecordCount <> 0 then
                  begin
                    lrow := AddRow;

                    lUserID := FieldByName('USERID').AsString;
                    Cells[1,lrow] := Get_DeptName(LeftStr(FieldByName('DEPT_CD').AsString,4));
                    Cells[2,lrow] := Get_UserName(lUserId) +' / '+
                                     FieldByName('DESCR').AsString;

                    if lUserID[1] in ['A'..'Z'] then
                      Cells[3,lrow] := NxComboBoxColumn1.Items.Strings[0]
                    else
                      Cells[3,lrow] := NxComboBoxColumn1.Items.Strings[1];

                    Cells[4,lrow] := lUserId;
                    Cells[5,lrow] := FieldByName('DEPT_CD').AsString;

                  end;
                end;
              end;
            end;//for
          finally
            EndUpdate;
          end;
        end;
      end;
    finally
      FreeAndNil(list);
    end;
  end;
end;


procedure TtestReceive_Frm.AdvGlowButton4Click(Sender: TObject);
begin
  empGrid.DeleteRow(empGrid.SelectedRow);
end;

procedure TtestReceive_Frm.AdvGlowButton7Click(Sender: TObject);
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
              '   ''T'' TYPE FROM DPMS_TMS_TASK A, DPMS_TMS_TASK_SHARE B ' +
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
              '   )  ' +
              ') ' +
              'START WITH TASK_PRT IS NULL ' +
              'CONNECT BY PRIOR TASK_NO = TASK_PRT ' +
              'ORDER SIBLINGS BY TASK_ORDER, TASK_NAME ');

      ParamByName('DEPT_CD').AsString   := DM1.FUserInfo.CurrentUsersTeam+'%';
      ParamByName('beginDate').AsString := FormatdateTime('yyyy-MM-dd',StartOfTheMonth(Today));
      ParamByName('endDate').AsString := FormatdateTime('yyyy-MM-dd',EndOfTheMonth(Today));

      Open;

      if RecordCount <> 0 then
      begin

        et_taskName.Hint := Create_chooseTask_Frm('T',OraQuery);

        if et_taskName.Hint <> '' then
          et_taskName.Text := Get_TaskName(et_taskName.Hint);

      end else
        ShowMessage('조건에 맞는 데이터를 찾을 수 없습니다.');
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure TtestReceive_Frm.btn_receiveClick(Sender: TObject);
var
  i : Integer;
  LReceiveMsg : String;
begin  if et_taskName.Text = '' then
  begin
    et_taskName.SetFocus;
    raise Exception.Create('먼저 업무를 선택하여 주십시오!');
  end;

  if planCode.Text = '' then
  begin
    planCode.SetFocus;
    raise Exception.Create('먼저 업무구분을 선택하여 주십시오!');
  end;

  if et_mh.Value <= 0 then
  begin
    et_mh.SetFocus;
    raise Exception.Create('예상M/H는 필수 입력입니다!');
  end;

  if empGrid.RowCount = 0 then
  begin
    empGrid.SetFocus;
    raise Exception.Create('한명 이상의 담당자를 선택하셔야 합니다!');
  end;

  with empGrid do
  begin
    BeginUpdate;
    try
      for i := 0 to RowCount-1 do
      begin
        if Cells[3,i] = '' then
          raise Exception.Create('담당자 역할을 선택하여 주십시오!');

      end;
    finally
      EndUpdate;
    end;
  end;

  if MessageDlg('시험명 : '+et_testName.Text+#10#13+
                '접수 하시겠습니까? ', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    et_planNo.Text := Get_makeKeyValue;
    if Insert_Into_HiTEMS_TMS_PLAN(et_planNo.Text,'최초등록',0) then
    begin
      Insert_Change_Log_('PLAN','INSERT',et_planNo.Text,DM1.FUserInfo.CurrentUsers);
      Insert_Receive_Info(et_ReqNo.Text,et_planNo.Text,'진행','최초등록');
      ShowMessage('접수완료!');

      LReceiveMsg := '요청하신 시험('+et_testName.Text+')이 정상적으로 접수 되었습니다. ' +
                     '접수자('+Get_UserName(DM1.FUserInfo.CurrentUsers)+') '+
                     '시험예정일 '+FormatDateTime('yyyy-MM-dd',planStart.Date) +
                     ' ~ ' + FormatDateTime('yyyy-MM-dd',planStart.Date);

      Send_SMS(LReceiveMsg);
      ModalResult := mrOk;
    end;
  end;
end;

procedure TtestReceive_Frm.btn_returnClick(Sender: TObject);
var
  LComment : String;
begin
  if MessageDlg('시험명 : '+et_testName.Text+#10#13+
                '반려 하시겠습니까? ', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    LComment := Create_resultDialog_Frm('반려사유 입력','');
    if LComment <> '' then
    begin
      Insert_Receive_Info(et_ReqNo.Text,'','반려',LComment);


      Send_SMS(LComment);


      ShowMessage('반려성공!');
      ModalResult := mrOk;
    end else
      raise Exception.Create('반려사유는 필수 입력 입니다!');
  end;
end;

procedure TtestReceive_Frm.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TtestReceive_Frm.fileGridCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
var
  lms: TMemoryStream;
  litem : TListItem;
  lFileName : String;
  lRegNo : String;
begin
  lRegNo := fileGrid.Cells[4,fileGrid.SelectedRow];
  lFileName := fileGrid.Cells[1,fileGrid.SelectedRow];
  if lRegNo <> '' then
  begin
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from DPMS_TMS_ATTFILES ' +
              'where REGNO = :param1 ');
      ParamByName('param1').AsString := lRegNo;
      Open;

      if not(RecordCount = 0) then
      begin
        lms := TMemoryStream.Create;
        try
          (FieldByName('Files') as TBlobField).SaveToStream(lms);
          lms.SaveToFile('C:\Temp\'+lFileName);

          ShellExecute(handle,'open',PWideChar('C:\Temp\'+lFileName),nil,nil,SW_NORMAL);
        finally
          FreeAndNil(lms);
        end;
      end;
    end;
  end;
end;


procedure TtestReceive_Frm.FormCreate(Sender: TObject);
begin
  planStart.DateTime := Now;
  planEnd.DateTime   := planStart.DateTime;

  PageControl1.ActivePageIndex := 0;

end;

procedure TtestReceive_Frm.Get_Attfiles(aGrid: TNextGrid; aOwner: String);
begin
  with aGrid do
  begin
    BeginUpdate;
    try
      ClearRows;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT FILENAME, FILESIZE, REGNO, OWNER from DPMS_TMS_ATTFILES ' +
                'WHERE OWNER IN ( ' +
                '   SELECT REQ_NO FROM DPMS_TMS_TEST_REQUEST  ' +
                '   START WITH REQ_NO LIKE :param1 ' +
                '   CONNECT BY PRIOR PARENT_NO = REQ_NO ) ');

        ParamByName('param1').AsString := aOwner;
        Open;

        while not eof do
        begin
          AddRow;
          Cells[1,RowCount-1] := FieldByName('FILENAME').AsString;
          Cells[2,RowCount-1] := FieldByName('FILESIZE').AsString;
          Cells[4,RowCount-1] := FieldByName('REGNO').AsString;
          Cells[5,RowCount-1] := FieldByName('OWNER').AsString;
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TtestReceive_Frm.Get_Choose_List(aIdx:Integer;aPartNo: String);
var
  i: Integer;
  OraQuery: TOraQuery;
begin
  with grid_part do
  begin
    BeginUpdate;
    try
      OraQuery := TOraQuery.Create(nil);
      try
        OraQuery.Session := DM1.OraSession1;
        OraQuery.FetchAll := True;

        with OraQuery do
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT * FROM DPMS_HIMSEN_MS_PART  ' +
            'WHERE PART_NO LIKE :param1 ');
          ParamByName('param1').AsString := aPartNo;
          Open;

          if RecordCount <> 0 then
          begin
            Cells[3, aIdx] := FieldByName('MS_NO').AsString;
            Cells[4, aIdx] := FieldByName('NAME').AsString;
            Cells[5, aIdx] := FieldByName('MAKER').AsString;
            Cells[6, aIdx] := FieldByName('TYPE').AsString;
            Cells[7, aIdx] := FieldByName('STANDARD').AsString;
          end;
        end;
      finally
        FreeAndNil(OraQuery);
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TtestReceive_Frm.Get_Request_Resource(aReqNo: String);
var
  i : Integer;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM ' +
            '( ' +
            '   SELECT ' +
            '     A.*, ' +
            '     B.ENGTYPE, LOC_CODE, ' +
            '     (SELECT NAME_KOR FROM DPMS_USER WHERE USERID LIKE A.REQ_ID) REQ_ID_NAME, ' +
            '     (SELECT DEPT_NAME FROM DPMS_DEPT WHERE DEPT_CD LIKE A.REQ_DEPT) REQ_DEPT_NAME, ' +
            '     (SELECT CODE_NAME FROM DPMS_LOCATION_CODE WHERE CODE LIKE B.LOC_CODE) LOC_CODE_NAME ' +
            '   FROM DPMS_TMS_TEST_REQUEST A LEFT OUTER JOIN ( ' +
            '     SELECT PROJNO, ENGTYPE, LOC_CODE FROM DPMS_HIMSEN_INFO ' +
            '   ) B ON A.TEST_ENGINE = B.PROJNO ' +
            ') WHERE REQ_NO LIKE :param1 ');

    ParamByName('param1').AsString := aReqNo;
    Open;

    if RecordCount <> 0 then
    begin
      et_reqDept.Text      := FieldByName('REQ_DEPT_NAME').AsString;
      et_reqDept.Hint      := FieldByName('REQ_DEPT').AsString;


      et_EngType.Text      := FieldByName('TEST_ENGINE').AsString+'-'+FieldByName('ENGTYPE').AsString;
      et_EngLoc.Text       := FieldByName('LOC_CODE_NAME').AsString;

      et_reqIncharge.Text  := FieldByName('REQ_ID_NAME').AsString;
      et_reqIncharge.Hint  := FieldByName('REQ_ID').AsString;

      et_testName.Text     := FieldByName('TEST_NAME').AsString;
      et_testPurpose.Text  := FieldByName('TEST_PURPOSE').AsString;
      et_begin.Text        := FormatDateTime('yyyy-MM-dd', FieldByName('TEST_BEGIN').AsDateTime);
      et_end.Text          := FormatDateTime('yyyy-MM-dd', FieldByName('TEST_END').AsDateTime);
      et_method.Text       := FieldByName('TEST_METHOD').AsString;


      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM DPMS_TMS_TEST_REQUEST_PART ' +
              'WHERE REQ_NO LIKE :param1 ');
      ParamByName('param1').AsString := aReqNo;
      Open;

      First;
      with grid_part do
      begin
        BeginUpdate;
        try
          while not eof do
          begin
            i := AddRow;
            Cells[1,i] := FieldByName('PART_NO').AsString;
            Cell[2,i].AsInteger := FieldByName('SEQ_NO').AsInteger;

            Cells[8,i] := FieldByName('BANK').AsString;
            Cells[9,i] := FieldByName('CYLNUM').AsString;
            Cells[10,i] := FieldByName('CYCLE').AsString;
            Cells[11,i] := FieldByName('SIDE').AsString;
            Cells[12,i] := FieldByName('SERIAL').AsString;
            Get_Choose_List(i, Cells[1,i]);
            Next;
          end;
        finally
          EndUpdate;
        end;
      end;

      Get_Attfiles(fileGrid,aReqNo);

    end;
  end;
end;

procedure TtestReceive_Frm.grid_partCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  if ARow = -1 then
    Exit;


  with grid_part do
  begin
    Preview_Detail_Part(et_ReqNo.Text,
                        Cells[1,ARow],
                        Cell[2,Arow].AsInteger);

  end;
end;

function TtestReceive_Frm.INSERT_INTO_HiTEMS_TMS_PLAN(aPlanNo,
  aModCause: String; aRevNo: Integer): Boolean;
begin
  Result := False;
  with DM1.OraTransaction1 do
  begin
    StartTransaction;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('INSERT INTO DPMS_TMS_PLAN ' +
                'VALUES(:TASK_NO, :PLAN_NO, :PLAN_CODE, :PLAN_TYPE, :PLAN_NAME, ' +
                ':PLAN_OUTLINE, :ENG_MODEL, :ENG_TYPE, :ENG_PROJNO, ' +
                ':PLAN_START, :PLAN_END, :PLAN_MH, :PLAN_PROGRESS, :PLAN_DRAFTER, ' +
                ':PLAN_INDATE, :PLAN_REV_NO, :PLAN_MOD_CAUSE )');

        ParamByName('TASK_NO').AsString    := et_taskName.Hint;
        ParamByName('PLAN_NO').AsString    := aPlanNo;
        ParamByName('PLAN_CODE').AsString  := planCode.Hint;
        ParamByName('PLAN_TYPE').AsInteger := 1;
        ParamByName('PLAN_NAME').AsString  := et_testName.Text;

        ParamByName('PLAN_OUTLINE').AsString := et_testPurpose.Text+#10#13+et_method.Text;
//        ParamByName('ENG_MODEL').AsString  := engModel.Text;

        ParamByName('ENG_TYPE').AsString   := Copy(et_engType.Text,POS('-',et_engType.Text)+1, Length(et_engType.Text)-POS('-',et_engType.Text));
        ParamByName('ENG_PROJNO').AsString := LeftStr(et_engType.Text,6);

        ParamByName('PLAN_START').AsDate     := planStart.Date;
        ParamByName('PLAN_END').AsDate       := planEnd.Date;

        ParamByName('PLAN_MH').AsInteger       := et_mh.AsInteger;
        ParamByName('PLAN_PROGRESS').AsInteger := 0;
        ParamByName('PLAN_DRAFTER').AsString   := DM1.FUserInfo.CurrentUsers;
        ParamByName('PLAN_INDATE').AsDateTime  := Now;

        ParamByName('PLAN_REV_NO').AsInteger   := aRevNo;
        ParamByName('PLAN_MOD_CAUSE').AsString := aModCause;

        ExecSQL;

        INSERT_INTO_HiTEMS_TMS_PLAN_INCHARGE(aPlanNo,aRevNo);

      end;
      Commit;
      Result := True;
    except
      Rollback;
    end;
  end;
end;

procedure TtestReceive_Frm.INSERT_INTO_HiTEMS_TMS_PLAN_INCHARGE(aPlanNo: string;
  aPlanRevNo: Integer);
var
  OraQuery : TOraQuery;
  li: Integer;

begin
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := DM1.OraSession1;
  try
    with empGrid do
    begin
      BeginUpdate;
      try
        with OraQuery do
        begin
          Close;
          SQL.Clear;
          SQL.Add('DELETE FROM DPMS_TMS_PLAN_INCHARGE ' +
                  'WHERE PLAN_NO = :param1 ' +
                  'AND PLAN_REV_NO = :param2 ');
          ParamByName('param1').AsString  := aPlanNo;
          ParamByName('param2').AsInteger := aPlanRevNo;
          ExecSQL;

          for li := 0 to RowCount-1 do
          begin
            Close;
            SQL.Clear;
            SQL.Add('INSERT INTO DPMS_TMS_PLAN_INCHARGE ' +
                    'Values(:PLAN_NO, :PLAN_EMPNO, :PLAN_TEAM, :PLAN_ROLE, :PLAN_SEQ, :PLAN_REV_NO)');

            ParamByName('PLAN_NO').AsString    := aPlanNo;
            ParamByName('PLAN_EMPNO').AsString := Cells[4,li];
            ParamByName('PLAN_TEAM').AsString  := Cells[5,li];
            ParamByName('PLAN_ROLE').AsInteger := NxComboBoxColumn1.Items.IndexOf(Cells[3,li]);
            ParamByName('PLAN_SEQ').AsInteger  := li;
            ParamByName('PLAN_REV_NO').AsInteger := aPlanRevNo;

            ExecSQL;
          end;
        end;
      finally
        EndUpdate;
      end;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure TtestReceive_Frm.Insert_Receive_Info(aReqNo,aPlanNo,aStatus,aComment:String);
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('INSERT INTO DPMS_TMS_TEST_RECEIVE_INFO ' +
            '(REQ_NO, PLAN_NO, RECEIVE_DATE, ' +
            ' RECEIVE_ID, STATUS, REMARK ) VALUES ( ' +
            ' :REQ_NO, :PLAN_NO, :RECEIVE_DATE, ' +
            ' :RECEIVE_ID, :STATUS, :REMARK ) ');

    ParamByName('REQ_NO').AsString         := aReqNo;
    ParamByName('PLAN_NO').AsString        := aPlanNo;
    ParamByName('RECEIVE_DATE').AsDateTime := Now;

    ParamByName('RECEIVE_ID').AsString     := DM1.FUserInfo.CurrentUsers;
    ParamByName('STATUS').AsString         := aStatus;
    ParamByName('REMARK').AsString         := aComment;

    ExecSQL;
  end;
end;

procedure TtestReceive_Frm.N1Click(Sender: TObject);
var
  lms: TMemoryStream;
  litem : TListItem;
  lFileName : String;
  lRegNo : String;
begin
  lRegNo := fileGrid.Cells[4,fileGrid.SelectedRow];
  lFileName := fileGrid.Cells[1,fileGrid.SelectedRow];
  if lRegNo <> '' then
  begin
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from DPMS_TMS_ATTFILES ' +
              'where REGNO = :param1 ');
      ParamByName('param1').AsString := lRegNo;
      Open;

      if not(RecordCount = 0) then
      begin
        lms := TMemoryStream.Create;
        try
          (FieldByName('Files') as TBlobField).SaveToStream(lms);
          lms.SaveToFile('C:\Temp\'+lFileName);

          ShellExecute(handle,'open',PWideChar('C:\Temp\'+lFileName),nil,nil,SW_NORMAL);
        finally
          FreeAndNil(lms);
        end;
      end;
    end;
  end;
end;
procedure TtestReceive_Frm.N2Click(Sender: TObject);
var
  lms: TMemoryStream;
  litem : TListItem;
  lFileName : String;
  lDirectory : String;
  lRegNo : String;
begin
  lRegNo := fileGrid.Cells[4,fileGrid.SelectedRow];
  lFileName := fileGrid.Cells[1,fileGrid.SelectedRow];
  if lRegNo <> '' then
  begin
    SaveDialog1.FileName := lFileName;
    if SaveDialog1.Execute then
    begin
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from DPMS_TMS_ATTFILES ' +
                'where REGNO = :param1 ');
        ParamByName('param1').AsString := lRegNo;
        Open;

        if not(RecordCount = 0) then
        begin
          lms := TMemoryStream.Create;
          try
            (FieldByName('Files') as TBlobField).SaveToStream(lms);
            lms.SaveToFile(SaveDialog1.FileName);

            lDirectory := ExtractFilePath(ExcludeTrailingBackslash(SaveDialog1.FileName));

            ShowMessage('파일저장 완료!');
            ShellExecute(handle,'open',PWideChar(lDirectory),nil,nil,SW_NORMAL);
          finally
            FreeAndNil(lms);
          end;
        end;
      end;
    end;
  end;
end;

procedure TtestReceive_Frm.planEndChange(Sender: TObject);
begin
  if planEnd.Date <> 0 then
    planEnd.Format := 'yyyy-MM-dd'
  else
    planEnd.Format := ' ';
end;

procedure TtestReceive_Frm.planStartChange(Sender: TObject);
begin
  if planStart.Date <> 0 then
    planStart.Format := 'yyyy-MM-dd'
  else
    planStart.Format := ' ';
end;

procedure TtestReceive_Frm.Send_Message_Main_CODE(FFlag, FSendID, FRecID, FHead,
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

procedure TtestReceive_Frm.Send_SMS(aMsg:String);
var
  li,le : Integer;
  lflag,
  lhead,
  ltitle,
  lstr,
  lcontent : AnsiString;

begin
//  헤더의 길이가 21byte를 넘지 않아야 함.
//  lhead := 'HiTEMS-문제점보고서';
//  lhead := '123456780123456789012';
  lhead    := 'HiTEMS ';
  ltitle   := '시험접수건 ';

  lcontent := aMsg;
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
        Send_Message_Main_CODE(LFlag,DM1.FUserInfo.CurrentUsers,et_reqIncharge.Hint,LHead,lstr,LTitle);
      end;
    end
    else
    begin
      lstr := lcontent;
      Send_Message_Main_CODE(LFlag,DM1.FUserInfo.CurrentUsers,et_reqIncharge.Hint,LHead,LTitle,lstr);

    end;
  end;
end;


end.
