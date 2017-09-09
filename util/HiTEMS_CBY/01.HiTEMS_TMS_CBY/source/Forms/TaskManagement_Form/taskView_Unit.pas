unit taskView_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, AdvGroupBox, DateUtils,
  AdvOfficeButtons, Vcl.StdCtrls, JvExControls, JvLabel, CurvyControls,
  Vcl.Imaging.jpeg, Vcl.ExtCtrls, AeroButtons, NxColumnClasses, NxColumns,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.Menus,
  StrUtils, System.Generics.Collections, ComObj, OleCtrls, Vcl.Grids,
  Vcl.DBGrids, JvBaseDlg, JvProgressDialog, Ora;

type
  TGetSearchThread = class(TThread)
  private
    FGrid : TNextGrid;
    FBeginDate,
    FEndDate,
    FTeam,
    FPart,
    FTaskType,
    FUser,
    FEngType,
    FEngProjNo,
    FCaption : String;
    Fidx : Integer;
    FProgressDlg : TJvProgressDialog;
    procedure SetProgressDlg(aDialog:TJvProgressDialog);
  protected
    procedure UpdateVCL;
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy;override;
  end;

type
  TtaskView_Frm = class(TForm)
    Panel8: TPanel;
    Image1: TImage;
    Panel1: TPanel;
    CurvyPanel1: TCurvyPanel;
    JvLabel2: TJvLabel;
    CurvyPanel2: TCurvyPanel;
    rg_period: TAdvOfficeRadioGroup;
    dt_begin: TDateTimePicker;
    dt_end: TDateTimePicker;
    JvLabel1: TJvLabel;
    JvLabel3: TJvLabel;
    CurvyPanel3: TCurvyPanel;
    rg_team: TAdvOfficeCheckGroup;
    JvLabel5: TJvLabel;
    cb_engType: TComboBox;
    JvLabel6: TJvLabel;
    cb_engProjNo: TComboBox;
    planGrid: TNextGrid;
    NxIncrementColumn2: TNxIncrementColumn;
    NxTextColumn5: TNxTextColumn;
    NxTextColumn10: TNxTextColumn;
    NxTextColumn15: TNxTextColumn;
    NxTextColumn9: TNxTextColumn;
    planProgressColumn: TNxProgressColumn;
    AeroButton2: TAeroButton;
    AeroButton3: TAeroButton;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn4: TNxTextColumn;
    NxTextColumn6: TNxTextColumn;
    NxTextColumn1: TNxNumberColumn;
    NxTextColumn2: TNxNumberColumn;
    Label1: TLabel;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    NxTextColumn11: TNxTextColumn;
    NxTextColumn7: TNxTextColumn;
    AeroButton1: TAeroButton;
    JvLabel7: TJvLabel;
    cb_users: TComboBox;
    NxTextColumn12: TNxTextColumn;
    JvLabel8: TJvLabel;
    cb_part: TComboBox;
    NxTextColumn8: TNxTextColumn;
    NxImageColumn1: TNxImageColumn;
    JvLabel4: TJvLabel;
    CurvyPanel4: TCurvyPanel;
    rg_taskType: TAdvOfficeCheckGroup;
    JvProgressDialog1: TJvProgressDialog;
    NxImageColumn2: TNxImageColumn;
    procedure FormCreate(Sender: TObject);
    procedure AeroButton3Click(Sender: TObject);
    procedure rg_periodClick(Sender: TObject);
    procedure cb_engTypeDropDown(Sender: TObject);
    procedure cb_engProjNoDropDown(Sender: TObject);
    procedure AeroButton2Click(Sender: TObject);
    procedure planGridCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure N1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure AeroButton1Click(Sender: TObject);
    procedure cb_usersDropDown(Sender: TObject);
    procedure cb_usersSelect(Sender: TObject);
    procedure rg_teamClick(Sender: TObject);
    procedure cb_partDropDown(Sender: TObject);
    procedure cb_partSelect(Sender: TObject);
    procedure cb_usersKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FGetSearchThread : TGetSearchThread;
  public
    { Public declarations }
//    procedure set_dept_Dictionary;
    procedure show_resultDialog(aRow:Integer);
    procedure show_detailDialog(aRow:Integer);
    procedure Export_planGrid2Excel;
    function Check_AttachedFiles(aPlanNo:String):Integer;

    function Get_Test_Request_No(aPlanNo:String):String;
  end;

const
  teamList : array[0..2] of string = ('K2B1','K2B2','K2B3');

var
  taskView_Frm: TtaskView_Frm;

implementation

uses
  testRequest_Unit,
  logDialog_Unit,
  newTaskPlan_Unit,
  taskMain_Unit,
  HiTEMS_TMS_CONST,
  HiTEMS_TMS_COMMON,
  DataModule_Unit;

{$R *.dfm}

procedure TtaskView_Frm.rg_periodClick(Sender: TObject);
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

procedure TtaskView_Frm.rg_teamClick(Sender: TObject);
begin
  if rg_team.Checked[2] then
    cb_part.Enabled := True
  else
  begin
    cb_part.Clear;
    cb_part.Hint := '';
    cb_part.Enabled := False;
  end;
end;

//과명만 가져옴
//procedure TtaskView_Frm.set_dept_Dictionary;
//begin
//  with DM1.OraQuery1 do
//  begin
//    Close;
//    SQL.Clear;
//    SQL.Add('SELECT * FROM HITEMS_DEPT WHERE DEPT_CD LIKE ''K2B%'' ');
//    SQL.Add(' AND DEPT_CD >= ''K2B1'' AND DEPT_CD NOT LIKE ''%-%'' ');
//    SQL.Add(' ORDER BY DEPT_CD');
//    Open;
//
//    if Assigned(FdeptDic) then
//      FdeptDic.Clear
//    else
//      FdeptDic := TDictionary<String,String>.Create;
//
//    while not eof do
//    begin
//      FdeptDic.Add(FieldByName('DEPT_CD').AsString, FieldByName('DEPT_NAME').AsString);
//      FTeamList.Add(FieldByName('DEPT_CD').AsString);
//      Next;
//    end;
//  end;
//end;

procedure TtaskView_Frm.show_detailDialog(aRow: Integer);
var
  ltaskNo,
  lplanNo : String;
  lResult : Boolean;
  lstartDate,
  lendDate : TDateTime;
  lteamCode : String;
  lplanRevNo : Integer;
begin
  with planGrid do
  begin
    if ARow <> -1 then
    begin
      ltaskNo := Cells[2,aRow];
      lplanNo := Cells[3,aRow];
      lplanRevNo := Cell[15,aRow].AsInteger;

      lteamCode  := Cells[5,aRow];
      lstartDate := dt_begin.Date;
      lendDate   := dt_end.Date;

      lResult := Create_newPlan_Frm(ltaskNo,lplanNo,lteamCode,lstartDate,lendDate,lplanRevNo);

    end;
  end;
end;

procedure TtaskView_Frm.show_resultDialog(aRow: Integer);
var
  lplanNo, lrevNo : String;
begin
  lplanNo := planGrid.Cells[3,aRow];
  lrevNo  := planGrid.Cells[15,aRow];
  if Create_logDialog_Frm(lplanNo,lrevNo,dt_begin.Date,dt_end.Date) then
  begin


  end;
end;

procedure TtaskView_Frm.AeroButton1Click(Sender: TObject);
begin
  AeroButton1.Enabled := False;
  Export_planGrid2Excel;
end;
procedure TtaskView_Frm.AeroButton2Click(Sender: TObject);
begin
  Close;
end;

procedure TtaskView_Frm.AeroButton3Click(Sender: TObject);
var
  beginDate,
  endDate:String;
  team:String;
  taskType : String;
  i : Integer;
  lrow : Integer;

begin
  FGetSearchThread := TGetSearchThread.Create;
  with FGetSearchThread do
  begin
    FGrid := planGrid;
    FProgressDlg := JvProgressDialog1;
    FBeginDate := FormatDateTime('yyyy-MM-dd',dt_begin.Date);
    FEndDate   := FormatDateTime('yyyy-MM-dd',dt_end.Date);

    team := '';
    for i := 0 to rg_team.Items.Count-1 do
    begin
      if rg_team.Checked[i] = true then
        Team := Team + '''' + DM1.FTeamList.Strings[i]+''',';
        //team := team+''''+teamList[i]+''',';
    end;
    team := Copy(team,1,Length(team)-1);
    FTeam := team;

    taskType := '';
    for i := 0 to rg_taskType.Items.Count-1 do
    begin
      if rg_taskType.Checked[i] = true then
        taskType := taskType+''''+IntToStr(i)+''',';
    end;
    taskType := Copy(taskType,1,Length(taskType)-1);
    FTaskType := taskType;
    FPart := cb_part.Hint;
    FUser := cb_users.Hint;
    FEngType := cb_engType.Text;
    FEngProjNo := cb_engProjNo.Text;

    Resume;

    JvProgressDialog1.ShowModal;

  end;
end;

procedure TtaskView_Frm.cb_engProjNoDropDown(Sender: TObject);
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

procedure TtaskView_Frm.cb_engTypeDropDown(Sender: TObject);
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

procedure TtaskView_Frm.cb_partDropDown(Sender: TObject);
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

procedure TtaskView_Frm.cb_partSelect(Sender: TObject);
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

procedure TtaskView_Frm.cb_usersDropDown(Sender: TObject);
var
  i : Integer;
  team : String;
begin
  with cb_users.Items do
  begin
    BeginUpdate;
    try
      Clear;
      Add('');

      team := '';
      for i := 0 to rg_team.Items.Count-1 do
      begin
        if rg_team.Checked[i] = true then
          team := team+''''+teamList[i]+''',';
      end;
      team := Copy(team,1,Length(team)-1);

      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT NAME_KOR, USERID FROM HITEMS_USER ' +
                'WHERE GUNMU = :param1 ');

        if team <> '' then
          SQL.Add('AND SUBSTR(DEPT_CD,1,4) IN ('+team+')');

        SQL.Add('ORDER BY PRIV DESC, POSITION, GRADE, USERID ');
        ParamByName('param1').AsString := 'I';
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

procedure TtaskView_Frm.cb_usersKeyPress(Sender: TObject; var Key: Char);
var
  Found: boolean;
  j,SelSt: Integer;
  TmpStr: string;
begin
  { first, process the keystroke to obtain the current string }
  { This code requires all items in list to be uppercase}
  if Key in ['a'..'z'] then Dec(Key,32) ; {Force Uppercase only!}
  with (Sender as TComboBox) do
  begin
    SelSt := SelStart;
    if (Key = Chr(vk_Back)) and (SelLength <> 0) then
      TmpStr := Copy(Text,1,SelStart)+Copy(Text,SelLength+SelStart+1,255)
    else if Key = Chr(vk_Back) then {SelLength = 0}
      TmpStr := Copy(Text,1,SelStart-1)+Copy(Text,SelStart+1,255)
    else {Key in ['A'..'Z', etc]}
      TmpStr := Copy(Text,1,SelStart)+Key+Copy(Text,SelLength+SelStart+1,255) ;
    if TmpStr = '' then Exit;
    { update SelSt to the current insertion point }

    if (Key = Chr(vk_Back)) and (SelSt > 0) then
      Dec(SelSt)
    else if Key <> Chr(vk_Back) then
      Inc(SelSt) ;

    Key := #0; { indicate that key was handled }

    if SelSt = 0 then
    begin
      Text:= '';
      Exit;
    end;

    {Now that TmpStr is the currently typed
    string, see if we can locate a match }

    Found := False;

    for j := 1 to Items.Count do
    begin
      if Copy(Items[j-1],1,Length(TmpStr)) = TmpStr then
      begin
        Text := Items[j-1]; { update to the match that was found }
        ItemIndex := j-1;
        Found := True;
        Break;
      end;
    end;

    if Found then { select the untyped end of the string }
    begin
      SelStart := SelSt;
      SelLength := Length(Text)-SelSt;
    end
    else Text := TmpStr;
  end;
end;

procedure TtaskView_Frm.cb_usersSelect(Sender: TObject);
var
  i : Integer;
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
          Break;
        end;
        Next;
      end;
    end;
  end else
    cb_users.Hint := '';

end;

function TtaskView_Frm.Check_AttachedFiles(aPlanNo: String): Integer;
begin

end;

procedure TtaskView_Frm.Export_planGrid2Excel;
begin
  //   참조항목
  //    XL.workbooks.Add('C:\test.xls');    //특정 이름의 화일 열기
  //    XL.workbooks.Open('C:\'+sFileName); //특정 이름의 화일 열기
  //    XL.ActiveWorkbook.saveas('C:\123.xls'); //활성화된 엑셀 다른 이름으로 저장
  //    XL.ActiveCell.FormulaR1C1 := '=3*3';    //값입력
  //    XL.ActiveCell.Font.Bold := True      //글자 환경 변경
  //    XL.ActiveCell.CurrentRegion.Select;   //활성화 된 셀의 영역을 선택
  //    XL.selection.style:='Currency';       //선택영역 통화 형태로
  TThread.Queue(nil,
  procedure
  const
    ldec = 65;//Ascii Code Dec = A
  var
    XL, oWB, oSheet, oRng : variant;
    xlRowCount, xlColCount,
    i,j,s : Integer;
    lColumn, range : string;
  begin
    XL := CreateOleObject('Excel.Application');
    XL.DisplayAlerts := False;
    XL.visible := False;
    try
      oWB := XL.WorkBooks.Add;
      oSheet := oWB.ActiveSheet;

      with planGrid do
      begin
        BeginUpdate;
        try
          s := -1;
          for i := 0 to Columns.Count-1 do
          begin
            if Columns[i].Visible And not(Columns[i].Name = 'NxImageColumn1') then
            begin
              Inc(s);
              lColumn := Chr(ldec+s);
              range := lColumn + '1';

              XL.Range[range].Select;
              XL.ActiveCell.FormulaR1C1 := Columns.Item[i].Header.Caption;

              for j := 0 to RowCount-1 do
              begin
                range := lColumn + IntToStr(j+2);
                XL.Range[range].Select;
                XL.ActiveCell.FormulaR1C1 := ''''+Cells[i,j];
              end;
            end;
          end;

          xlRowCount := oSheet.UsedRange.Rows.Count;
          xlColCount := oSheet.UsedRange.Columns.Count;
          //Header Range 설정
          range := Chr(ldec)+'1:';
          range := range + chr(ldec+xlColCount-1)+'1';
          oRng := oSheet.Range[range];
          //Font bold
          oRng.font.bold := true;
          //Header AutoFit
          oRng.EntireColumn.AutoFit;
          //Header fill Color
          oRng.Interior.ColorIndex := 36;

          //전체 Range 설정
          range := Chr(ldec)+'1:';
          range := range + chr(ldec+xlColCount-1)+IntToStr(xlRowCount);
          oRng := oSheet.Range[range];

          oRng.Borders.LineStyle := 1;
        finally
          XL.Visible := True;
          EndUpdate;
          AeroButton1.Enabled := True;
        end;
      end;
    except
      MessageDlg('Excel이 설치되어 있지 않습니다.'+#13+
        '이 기능을 이용하시려면 반드시 MS오피스 엑셀이 설치되어 있어야 합니다.- ' ,
        MtWarning, [mbok], 0);
      XL.quit;
      XL := Unassigned;
    end;
  end);
end;


procedure TtaskView_Frm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
//  FreeAndNil(FTeamList);
//
//  if Assigned(FdeptDic) then
//    FreeAndNil(FdeptDic);
end;

procedure TtaskView_Frm.FormCreate(Sender: TObject);
var
  i : Integer;
begin
  //초기화
  dt_begin.Date := StartOfTheWeek(Now);
  dt_end.Date   := EndOfTheWeek(Now);

  for i := 0 to rg_team.Items.Count-1 do
    rg_team.Checked[i] := True;

  for i := 0 to rg_taskType.Items.Count-1 do
    rg_taskType.Checked[i] := True;

  cb_engType.Items.Clear;
  cb_engProjNo.Items.Clear;

//  FTeamList := TStringList.Create;

//  set_dept_Dictionary;
end;

function TtaskView_Frm.Get_Test_Request_No(aPlanNo: String): String;
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
      SQL.Add('SELECT REQ_NO FROM TMS_TEST_RECEIVE_INFO ' +
              'WHERE PLAN_NO LIKE :param1 ');
      ParamByName('param1').AsString := aPlanNo;
      Open;

      Result := FieldByName('REQ_NO').AsString;

    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure TtaskView_Frm.N1Click(Sender: TObject);
begin
  show_detailDialog(planGrid.SelectedRow);
end;

procedure TtaskView_Frm.planGridCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
var
  lreqNo,
  LPlanNo : String;
begin
  LPlanNo := planGrid.Cells[3,ARow];

  if ACol <> 1 then
    show_detailDialog(ARow)
  else
  begin
    lreqNo := Get_Test_Request_No(LPlanNo);
    if lreqNo <> '' then
      Preview_Request_Frm(lreqNo);
  end;


//    Create_testInfo_Frm(LPlanNo);
end;
{ TGetSearchThread }

constructor TGetSearchThread.Create;
begin
  FreeOnTerminate := False;
  inherited Create( true );
end;

destructor TGetSearchThread.Destroy;
begin

  inherited;
end;

procedure TGetSearchThread.Execute;
var
  OraQuery : TOraQuery;
  LRow : Integer;
begin
  with FGrid do
  begin
    BeginUpdate;
    try
      ClearRows;
      OraQuery := TOraQuery.Create(nil);
      try
        OraQuery.Session := DM1.OraSession1;
        OraQuery.FetchAll := True;
        with OraQuery do
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT ' +
                  '   A.*, ' +
                  '   (SELECT COUNT(*) FROM TMS_ATTFILES WHERE OWNER LIKE A.PLAN_NO) FILECNT, ' +
                  '   (SELECT COUNT(*) FROM TMS_TEST_RECEIVE_INFO WHERE PLAN_NO LIKE A.PLAN_NO) TESTCNT ' +
                  'FROM ' +
                  '( ' +
                  '   SELECT  ' +
                  '     PLAN_NO, A.PRN, TASK_NO, PLAN_CODE, CODE_NAME, PLAN_TYPE, ' +
                  '     PLAN_NAME, ENG_MODEL, ENG_TYPE, ENG_PROJNO, PLAN_START, ' +
                  '     PLAN_END, PLAN_MH, PLAN_PROGRESS, PLAN_DRAFTER, ' +
                  '     DRAFTER_NAME, SUBSTR(PLAN_TEAM,1,4) PLAN_TEAM, DEPT_NAME, PLAN_TEAM PART, NVL(MH,0) MH ' +
                  '   FROM ' +
                  '   ( ' +
                  '       SELECT  ' +
                  '         A.PLAN_NO, A.PRN, TASK_NO, PLAN_CODE, CODE_NAME, ' +
                  '         PLAN_TYPE, PLAN_NAME, ENG_MODEL, ENG_TYPE, ' +
                  '         ENG_PROJNO, PLAN_START, PLAN_END, PLAN_MH, ' +
                  '         PLAN_PROGRESS, PLAN_DRAFTER, DRAFTER_NAME, ' +
                  '         PLAN_TEAM, DEPT_NAME ' +
                  '       FROM ' +
                  '       ( ' +
                  '           SELECT  ' +
                  '             A.PLAN_NO, PRN, TASK_NO, PLAN_CODE, PLAN_TYPE, ' +
                  '             PLAN_NAME, ENG_MODEL, ENG_TYPE, ENG_PROJNO, ' +
                  '             PLAN_START, PLAN_END, PLAN_MH, PLAN_PROGRESS, ' +
                  '             PLAN_DRAFTER, CODE_NAME, DRAFTER_NAME ' +
                  '           FROM     ' +
                  '           ( ' +
                  '               SELECT PLAN_NO, MAX(PLAN_REV_NO) PRN FROM TMS_PLAN GROUP BY PLAN_NO ' +
                  '           ) A JOIN ' +
                  '           ( ' +
                  '               SELECT ' +
                  '                 A.*, B.CODE_NAME, C.NAME_KOR DRAFTER_NAME ' +
                  '               FROM TMS_PLAN A, HITEMS_CODE_GROUP B, HITEMS_USER C ' +
                  '               WHERE A.PLAN_CODE = B.GRP_NO ' +
                  '               AND A.PLAN_DRAFTER = C.USERID ' +
                  '           ) B ' +
                  '           ON A.PLAN_NO = B.PLAN_NO ' +
                  '           AND A.PRN = B.PLAN_REV_NO ' +
                  '       ) A JOIN ' +
                  '       (     ' +
                  '           SELECT ' +
                  '             A.PLAN_NO, PRN, PLAN_TEAM, DEPT_NAME  ' +
                  '           FROM     ' +
                  '           ( ' +
                  '               SELECT PLAN_NO, MAX(PLAN_REV_NO) PRN FROM TMS_PLAN GROUP BY PLAN_NO ' +
                  '           ) A JOIN ' +
                  '           ( ' +
                  '               SELECT ' +
                  '                 A.PLAN_NO, A.PLAN_REV_NO, PLAN_TEAM, B.DEPT_NAME ' +
                  '               FROM TMS_PLAN_INCHARGE A, HITEMS_DEPT B  ' +
                  '               WHERE A.PLAN_TEAM = B.DEPT_CD ' +
                  '               GROUP BY PLAN_NO, PLAN_REV_NO, PLAN_TEAM, DEPT_NAME ' +
                  '           ) B ' +
                  '           ON A.PLAN_NO = B.PLAN_NO ' +
                  '           AND A.PRN = B.PLAN_REV_NO ' +
                  '       ) B ' +
                  '       ON A.PLAN_NO = B.PLAN_NO ' +
                  '       AND A.PRN = B.PRN ' +
                  '   ) A LEFT OUTER JOIN ' +
                  '   ( ' +
                  '       SELECT PLAN_NO PN, DEPT_CD TN, SUM(RST_MH) MH FROM ' +
                  '       ( ' +
                  '           SELECT  ' +
                  '               A.PLAN_NO, A.RST_NO, B.RST_BY, B.RST_MH, C.DEPT_CD ' +
                  '           FROM ' +
                  '             TMS_RESULT A, ' +
                  '             TMS_RESULT_MH B, ' +
                  '             HITEMS_USER C ' +
                  '           WHERE A.RST_NO = B.RST_NO ' +
                  '           AND B.RST_BY = C.USERID ' +
                  '       ) GROUP BY PLAN_NO, DEPT_CD    ' +
                  '   ) B ' +
                  '   ON A.PLAN_NO = B.PN ' +
                  '   AND A.PLAN_TEAM = B.TN ' +
                  ') A ' +
                  'WHERE ' +
                  '(TO_CHAR(PLAN_START, ''yyyy-mm-dd'') <= :beginDate ' +
                  'AND PLAN_END >= TO_DATE(:beginDate, ''yyyy-mm-dd'') ' +
                  'AND TO_CHAR(PLAN_START, ''yyyy-mm-dd'') <= :endDate ' +
                  'AND TO_CHAR(PLAN_END, ''yyyy-mm-dd'') <= :endDate ' +
                  'OR PLAN_START >= TO_DATE(:beginDate, ''yyyy-mm-dd'') ' +
                  'AND TO_CHAR(PLAN_END, ''yyyy-mm-dd'') >= :beginDate ' +
                  'AND TO_CHAR(PLAN_START, ''yyyy-mm-dd'') <= :endDate ' +
                  'AND TO_CHAR(PLAN_END, ''yyyy-mm-dd'') <= :endDate ' +
                  'OR TO_CHAR(PLAN_START, ''yyyy-mm-dd'') >= :beginDate ' +
                  'AND TO_CHAR(PLAN_END, ''yyyy-mm-dd'') >= :beginDate ' +
                  'AND TO_CHAR(PLAN_START, ''yyyy-mm-dd'') <= :endDate ' +
                  'AND TO_CHAR(PLAN_END, ''yyyy-mm-dd'') >= :endDate ' +
                  'OR TO_CHAR(PLAN_START, ''yyyy-mm-dd'') <= :beginDate ' +
                  'AND TO_CHAR(PLAN_END, ''yyyy-mm-dd'') >= :beginDate ' +
                  'AND TO_CHAR(PLAN_START, ''yyyy-mm-dd'') <= :endDate ' +
                  'AND TO_CHAR(PLAN_END, ''yyyy-mm-dd'') >= :endDate) ' +
                  'AND PLAN_PROGRESS != 100 ' +
                  'AND ENG_TYPE = :engType ' +
                  'AND ENG_PROJNO = :engProjNo ' +
                  'AND PLAN_DRAFTER = :planDrafter ');

          ParamByName('beginDate').AsString := FBeginDate;
          ParamByName('endDate').AsString   := FEndDate;

          if FEngType <> '' then
            ParamByName('engType').AsString := FEngType
          else
            SQL.Text := ReplaceStr(SQL.Text,'AND ENG_TYPE = :engType ','');

          if FEngProjNo <> '' then
            ParamByName('engProjNo').AsString := FEngProjNo
          else
            SQL.Text := ReplaceStr(SQL.Text,'AND ENG_PROJNO = :engProjNo ','');

          if FUser <> '' then
            ParamByName('planDrafter').AsString := FUser
          else
            SQL.Text := ReplaceStr(SQL.Text,'AND PLAN_DRAFTER = :planDrafter ','');

          if FTeam <> '' then
          begin
            SQL.Add('AND PLAN_TEAM IN ('+FTeam+') ');
          end;

          if FtaskType <> '' then
          begin
            SQL.Add('AND PLAN_TYPE IN ('+FtaskType+') ');
          end;

          if FPart <> '' then
          begin
            SQL.Add('AND PART = :part');
            ParamByName('part').AsString := FPart
          end;

          SQL.Add('ORDER BY PLAN_TEAM, PLAN_START, PLAN_NAME ');

          open;

          FProgressDlg.Max := RecordCount;
          if FProgressDlg.Max <> 0 then
          begin
            while not eof do
            begin
              Fidx := RecNo;
              LRow := AddRow;
              if FieldByName('TESTCNT').AsInteger > 0 then
                Cell[1,LRow].AsInteger := 11
              else
                Cell[1,LRow].AsInteger := -1;

              Cells[2,LRow]  := FieldByName('TASK_NO').AsString;
              Cells[3,LRow]  := FieldByName('PLAN_NO').AsString;
              Cells[4,LRow]  := FieldByName('PLAN_CODE').AsString;
              Cells[5,LRow]  := FieldByName('DEPT_NAME').AsString;
              Cells[6,LRow]  := FieldByName('DRAFTER_NAME').AsString;

              Cells[7,LRow]  := FieldByName('ENG_TYPE').AsString;
              Cells[8,LRow]  := FieldByName('CODE_NAME').AsString;

              FCaption := FieldByName('PLAN_NAME').AsString;
              Cells[9,LRow]  := FCaption;
              Cells[10,LRow]  := FieldByName('PLAN_START').AsString;
              Cells[11,LRow] := FieldByName('PLAN_END').AsString;

              Cell[12,LRow].AsFloat := FieldByName('PLAN_MH').AsFloat;
              Cell[13,LRow].AsFloat := FieldByName('MH').AsFloat;
              Cell[14,LRow].AsInteger := FieldByName('PLAN_PROGRESS').AsInteger;
              Cells[15,LRow]          := FieldByName('PRN').AsString;

              if FieldByName('FILECNT').AsInteger > 0 then
                Cell[16,LRow].AsInteger := 39
              else
                Cell[16,LRow].AsInteger := -1;

              Synchronize( UpdateVCL );

              Application.ProcessMessages;

              Next;
            end;
          end;
        end;
      finally
        FreeAndNil(OraQuery);
      end;
    finally
      FProgressDlg.Hide;
      CalculateFooter;
      EndUpdate;
    end;
  end;
end;

procedure TGetSearchThread.SetProgressDlg(aDialog: TJvProgressDialog);
begin
  FProgressDlg := aDialog;
end;

procedure TGetSearchThread.UpdateVCL;
begin
  FProgressDlg.Position := Fidx;
  FProgressDlg.Caption := FCaption + '   ';
end;

end.



