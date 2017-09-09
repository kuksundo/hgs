unit newTaskPlan_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxColumnClasses, NxColumns, Ora,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.StdCtrls,
  Vcl.ComCtrls, NxEdit, JvExStdCtrls, JvCombobox, JvListComb, AdvGlowButton,
  Vcl.ExtCtrls, JvEdit, NxCollection, AdvGroupBox, AdvOfficeButtons,
  AdvTreeComboBox, Vcl.Imaging.jpeg, AdvSmoothProgressBar, StrUtils,
  AdvExplorerTreeview, JvCheckBox, DateUtils, System.Generics.Collections,
  Vcl.Menus, AdvMenus, DB, ShellApi, AeroButtons, AdvOfficeStatusBar,
  Vcl.ImgList;

type
  TnewTaskPlan_Frm = class(TForm)
    Panel2: TPanel;
    regBtn: TAdvGlowButton;
    AdvGlowButton1: TAdvGlowButton;
    delBtn: TAdvGlowButton;
    Panel8: TPanel;
    Image1: TImage;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Label14: TLabel;
    Label7: TLabel;
    Label15: TLabel;
    Label10: TLabel;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label11: TLabel;
    AdvGlowButton5: TAdvGlowButton;
    AdvGlowButton6: TAdvGlowButton;
    OpenDialog1: TOpenDialog;
    checkSchedule: TJvCheckBox;
    PlanTypeSelectBtn: TAdvGlowButton;
    planCode: TJvEdit;
    planName: TJvEdit;
    planOutline: TRichEdit;
    engModel: TNxComboBox;
    engType: TNxComboBox;
    engProjNo: TJvEdit;
    planType: TAdvOfficeRadioGroup;
    empGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn6: TNxTextColumn;
    fileGrid: TNextGrid;
    NxIncrementColumn3: TNxIncrementColumn;
    NxTextColumn9: TNxTextColumn;
    NxTextColumn10: TNxTextColumn;
    NxTextColumn11: TNxTextColumn;
    NxTextColumn12: TNxTextColumn;
    AdvGroupBox1: TAdvGroupBox;
    Label2: TLabel;
    planStart: TDateTimePicker;
    Label3: TLabel;
    planEnd: TDateTimePicker;
    AdvGroupBox2: TAdvGroupBox;
    Label13: TLabel;
    planMh: TNxNumberEdit;
    AdvGroupBox3: TAdvGroupBox;
    Label9: TLabel;
    planProgress: TNxNumberEdit;
    planProgressBar: TAdvSmoothProgressBar;
    AdvGlowButton4: TAdvGlowButton;
    AdvGlowButton2: TAdvGlowButton;
    NxComboBoxColumn1: TNxComboBoxColumn;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn7: TNxTextColumn;
    planNo: TEdit;
    revNo: TNxNumberEdit;
    AdvPopupMenu1: TAdvPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    SaveDialog1: TSaveDialog;
    TabSheet4: TTabSheet;
    taskNo: TAdvTreeComboBox;
    planGrid: TNextGrid;
    NxIncrementColumn2: TNxIncrementColumn;
    NxTextColumn4: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    NxTextColumn8: TNxTextColumn;
    NxComboBoxColumn2: TNxComboBoxColumn;
    NxTextColumn14: TNxTextColumn;
    NxTextColumn15: TNxTextColumn;
    NxTextColumn13: TNxTextColumn;
    NxTextColumn16: TNxTextColumn;
    NxTextColumn17: TNxTextColumn;
    NxDateColumn4: TNxDateColumn;
    NxDateColumn3: TNxDateColumn;
    planProgressColumn: TNxProgressColumn;
    NxImageColumn1: TNxImageColumn;
    NxNumberColumn1: TNxNumberColumn;
    NxTextColumn18: TNxTextColumn;
    NxTextColumn19: TNxTextColumn;
    NxTextColumn20: TNxTextColumn;
    ImageList16x16: TImageList;
    TeamAliasText: TNxTextColumn;
    procedure FormCreate(Sender: TObject);
    procedure AdvGlowButton1Click(Sender: TObject);
    procedure engModelButtonDown(Sender: TObject);
    procedure engTypeButtonDown(Sender: TObject);
    procedure engModelSelect(Sender: TObject);
    procedure engTypeSelect(Sender: TObject);
    procedure AdvGlowButton6Click(Sender: TObject);
    procedure AdvGlowButton5Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure taskNoDropDown(Sender: TObject; var acceptdrop: Boolean);
    procedure taskNoDropUp(Sender: TObject; canceled: Boolean);
    procedure PlanTypeSelectBtnClick(Sender: TObject);
    procedure planStartChange(Sender: TObject);
    procedure planEndChange(Sender: TObject);
    procedure planProgressChange(Sender: TObject);
    procedure AdvGlowButton2Click(Sender: TObject);
    procedure AdvGlowButton4Click(Sender: TObject);
    procedure regBtnClick(Sender: TObject);
    procedure delBtnClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure AeroButton1Click(Sender: TObject);
    procedure AeroButton2Click(Sender: TObject);
    procedure fileGridCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure fileGridDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);

  private
    { Private declarations }
    Fmodifyed,
    Fchanged : Boolean;
    FteamCode : String;
    FstartDate,
    FendDate : TDateTime; //FstartDate & FendDate make Parent Tree Resource
    FtreeDic : TDictionary<string,TTreeNode>;
    FparentTaskBegin, FparentTaskEnd : TDateTime; //새로 지정하는 일정이 상위 일정보다 크거나 작지않게

    ForiginFileGridWindowProc : TWndMethod;
    procedure FileGridWindowProc(var msg : TMessage);
    procedure FileGridDropFiles(aGrid:TNextGrid;var msg:TWMDropFiles);
  public
    { Public declarations }
    procedure Get_ParentTaskSchedule(aTask_Prt:String);
    procedure Set_Parent_Task_Tree;
    procedure Management_Attfiles;

    function INSERT_INTO_HiTEMS_TMS_PLAN(aPlanNo,aModCause:String;aRevNo:Integer) : Boolean;
    procedure INSERT_INTO_HiTEMS_TMS_PLAN_INCHARGE(aPlanNo:string;aPlanRevNo:Integer);
    function UPDATE_HiTEMS_TMS_PLAN(aPlanNo:string;aPlanRevNo:Integer) : Boolean;

    function Get_HITEMS_TMS_PLAN(aPlanNo:String;aRevNo:Integer) : Boolean;
    procedure Get_HITEMS_TMS_PLAN_INCHARGE(aPlanNo:String;aRevNo:Integer);

    procedure In_Update_case_Button_State_Set;
    procedure Get_Revisions(aPlanNo:String);

    procedure Send_SMS;
    procedure SetUI;
    procedure AddCurrentUser2empGrid;
  end;

var
  newTaskPlan_Frm: TnewTaskPlan_Frm;

  function Create_newPlan_Frm(aTask_No,aPlan_No,aTeamCode:String;
        aStartDate,aEndDate:TDateTime;aRevNo:Integer) : Boolean;

implementation

uses
{$IFNDEF T_REQ}
  selectCode_Unit,
  findUser_Unit,
  HiTEMS_TMS_CONST,
  taskMain_Unit,
{$ENDIF}
  HiTEMS_TMS_COMMON,
  resultDialog_Unit,
  CommonUtil_Unit,
  DataModule_Unit;

{$R *.dfm}

function Create_newPlan_Frm(aTask_No,aPlan_No,aTeamCode:String;
        aStartDate,aEndDate:TDateTime;aRevNo:Integer) : Boolean;
begin
  newTaskPlan_Frm := TnewTaskPlan_Frm.Create(nil);
  try
    with newTaskPlan_Frm do
    begin
      SetUI;

      FteamCode := aTeamCode;
      FstartDate := aStartDate;
      FendDate   := aEndDate;

      taskNo.Hint := aTask_No;
      taskNo.Text := Get_TaskName(taskNo.Hint);

      if taskNo.Hint <> '' then
        Get_ParentTaskSchedule(taskNo.Hint)
      else
      begin
        FparentTaskBegin := 0;
        FparentTaskEnd := 0;
      end;

      planNo.Text := aPlan_No;
      revNo.AsInteger := aRevNo;
      Get_Revisions(planNo.Text);

      if planNo.Text <> '' then
      begin
        //UPDATE TASK
        Caption := '계획 수정';
        regBtn.Caption := '계획수정';
        delBtn.Enabled := True;

        In_Update_case_Button_State_Set;

        if Get_HITEMS_TMS_PLAN(planNo.Text,revNo.AsInteger) = True then
        begin
          Get_HITEMS_TMS_PLAN_INCHARGE(planNo.Text, revNo.AsInteger);
          Get_Attfiles(fileGrid,planNo.Text);
        end;
      end else
      begin
        //NEW TASK
        Caption := '새 계획 등록';
        regBtn.Caption := '계획등록';
        delBtn.Enabled := False;
        AddCurrentUser2empGrid;
      end;

      ShowModal;

      Result := Fchanged;
    end;
  finally
    FreeAndNil(newTaskPlan_Frm);
  end;
end;

procedure TnewTaskPlan_Frm.AddCurrentUser2empGrid;
var
  lrow: integer;
begin
  with empGrid do
  begin
    lrow := AddRow;

    Cells[1,lrow] := DM1.FUserInfo.TeamName;
    Cells[2,lrow] := DM1.FUserInfo.UserName + ' / ' + DM1.FUserInfo.Grade;

    if DM1.FUserInfo.UserID[1] in ['A'..'Z'] then
      Cells[3,lrow] := NxComboBoxColumn1.Items.Strings[0]
    else
      Cells[3,lrow] := NxComboBoxColumn1.Items.Strings[1];

    Cells[4,lrow] := DM1.FUserInfo.UserID;
    Cells[5,lrow] := DM1.FUserInfo.TeamNo;
    CellByName['TeamAliasText', lrow].AsInteger := DM1.FUserInfo.AliasCode_Team;
  end;
end;

procedure TnewTaskPlan_Frm.AdvGlowButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TnewTaskPlan_Frm.AdvGlowButton2Click(Sender: TObject);
var
  lResult : String;
  li : Integer;
  list : TStringList;
  lrow : Integer;
  lUserId,
  str, LTeamCode : String;
  SearchOptions: TSearchOptions;
begin
  SearchOptions := [];
//  Include(SearchOptions, soCaseInsensitive);
//  Include(SearchOptions, soFromSelected);
  Include(SearchOptions, soContinueFromTop);
//  Include(SearchOptions, soExactMatch);

//  NextGrid1.FindText(0, edtText.Text, SearchOptions);

{$IFNDEF T_REQ}
  lResult := Create_findUser_Frm(DM1.FUserInfo.CurrentUsers,'M');
{$ENDIF}

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

              //사번으로 담당자의 기 존재 여부 확인
              if not FindText(4,str,SearchOptions) then
              begin
                with DM1.OraQuery1 do
                begin
                  Close;
                  SQL.Clear;
                  SQL.Add('SELECT * from DPMS_USER A, DPMS_USER_GRADE B ' +
                          'WHERE A.USERID = :param1 ' +
                          'AND A.GUNMU = ''I'' ' +
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
                    LTeamCode := FieldByName('DEPT_CD').AsString;;
                    Cells[5,lrow] := LTeamCode;
                    CellByName['TeamAliasText', lrow].AsInteger := DM1.GetAliasCode(LTeamCode);
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
      Fmodifyed := True;
      FreeAndNil(list);
    end;
  end;
end;

procedure TnewTaskPlan_Frm.AdvGlowButton4Click(Sender: TObject);
begin
  Fmodifyed := True;
  empGrid.DeleteRow(empGrid.SelectedRow);
end;

procedure TnewTaskPlan_Frm.AdvGlowButton5Click(Sender: TObject);
var
  li : integer;
begin
  with fileGrid do
  begin
    if SelectedRow > -1 then
    begin
      if not(Cells[3,SelectedRow] = '') then
        DeleteRow(SelectedRow)
      else
        for li := 0 to Columns.Count-1 do
          Cell[li,SelectedRow].TextColor := clRed;
    end;

    SelectedRow := -1;
  end;
end;

procedure TnewTaskPlan_Frm.AdvGlowButton6Click(Sender: TObject);
var
  li,le : integer;
  lms : TMemoryStream;
  lfilename : String;
  lExt : String;
  lSize : int64;
  lResult : Boolean;

begin
  if OpenDialog1.Execute then
  begin
    with OpenDialog1 do
    begin
      for li := 0 to Files.Count-1 do
      begin
        lfilename := ExtractFileName(Files.Strings[li]);
        with fileGrid do
        begin
          BeginUpdate;
          try
            lResult := True;
            for le := 0 to RowCount-1 do
            begin
              if lfilename = Cells[1,le] then
              begin
                raise Exception.Create(Format('%s : 같은 이름의 파일이 등록되어 있습니다.',[lfilename]));
                lResult := False;
                Break;
              end;
            end;

            if lResult = True then
            begin
              lms := TMemoryStream.Create;
              try
                lms.LoadFromFile(Files.Strings[li]);
                lsize := lms.Size;

                lExt := ExtractFileExt(lfileName);
                Delete(lExt,1,1);
                AddRow;
                Cells[1,RowCount-1] := lfilename;
                Cells[2,RowCount-1] := IntToStr(lsize);
                Cells[3,RowCount-1] := Files.Strings[li];

                for le := 0 to Columns.Count-1 do
                  Cell[le,RowCount-1].TextColor := clBlue;
              finally
                FreeAndNil(lms);
              end;
            end;
          finally
            EndUpdate;
          end;
        end;
      end;
    end;
  end;
end;

procedure TnewTaskPlan_Frm.PlanTypeSelectBtnClick(Sender: TObject);
var
  lResult : String;
  LCodeName: string;
  LAliasType, LAliasCode: integer;
begin
{$IFNDEF T_REQ}
  lResult := Create_selectCode_Frm(planCode.Hint, 'A');
{$ENDIF}

  if lResult <> '' then
  begin
    planCode.Hint := lResult;
//    planCode.Text := Get_Hitems_Code_Name(planCode.Hint);

    LAliasType := DM1.GetVisibleTypeFromGrp(planCode.hint, ord(ctGroup), LCodeName, LAliasCode);
    planCode.Text := LCodeName;

    if LAliasType = ord(atPrivate) then
      planCode.Color := ALIAS_PRIVATE_COLOR
    else
    if LAliasType = ord(atTeam)  then
      planCode.Color := ALIAS_TEAM_COLOR
    else
      planCode.Color := clWindow;
  end else
  begin
    planCode.Hint := '';
    planCode.Clear;
  end;
end;

procedure TnewTaskPlan_Frm.AeroButton1Click(Sender: TObject);
begin
  planStart.Format := ' ';
end;

procedure TnewTaskPlan_Frm.AeroButton2Click(Sender: TObject);
begin
  planEnd.Format := ' ';
end;

procedure TnewTaskPlan_Frm.delBtnClick(Sender: TObject);
begin
  Fchanged := True;
  if MessageDlg('계획명 : '+planName.Text+#10#13+
                '삭제 하시겠습니까? 삭제된 정보는 복구할 수 없습니다.', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    with DM1.OraTransaction1 do
    begin
      try
        //첨부파일 삭제
        Delete_Attfiles(planNo.Text);

        //작업계획 삭제
        Delete_Work_Orders(planNo.Text);

        with DM1.OraQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('DELETE FROM DPMS_TMS_PLAN ' +
                  'WHERE PLAN_NO = :param1 ');
          ParamByName('param1').AsString := planNo.Text;
          ExecSQL;
        end;

        Commit;
        Insert_Change_Log_('PLAN','DELETE',planName.Text,DM1.FUserInfo.CurrentUsers);
        ShowMessage('삭제완료!');
        Close;
      except
        Rollback;
      end;
    end;
  end;
end;

procedure TnewTaskPlan_Frm.planStartChange(Sender: TObject);
begin
  if FparentTaskBegin <> 0 then
  begin
    if planStart.Date < FparentTaskBegin then
    begin
      ShowMessage('시작일은 상위 업무의 시작일보다 작을 수 없습니다.');
      planStart.Date := FparentTaskBegin;
    end;
    planStart.Format := 'yyyy-MM-dd';
  end else
    if planStart.Date <> 0 then
      planStart.Format := 'yyyy-MM-dd'
    else
      planStart.Format := ' ';

  Fmodifyed := True;
end;

procedure TnewTaskPlan_Frm.FileGridWindowProc(var msg: TMessage);
begin
  if msg.msg = WM_DROPFILES then
    FileGridDropFiles(fileGrid,TWMDROPFILES(Msg))
  else
    ForiginFileGridWindowProc(Msg);
end;

procedure TnewTaskPlan_Frm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Assigned(FtreeDic) then
    FreeAndNil(FtreeDic);
end;

procedure TnewTaskPlan_Frm.FormCreate(Sender: TObject);
var
  li : Integer;
begin

  //Drag & Drop Method
  ForiginFileGridWindowProc := fileGrid.WindowProc;
  fileGrid.WindowProc := FileGridWindowProc;

  DragAcceptFiles(fileGrid.Handle,True);

  //Page Set
  PageControl1.ActivePageIndex := 0;
  empGrid.DoubleBuffered := False;

  planStart.Date := today;
  planEnd.Date := tomorrow;
  //변수초기화
  Fmodifyed := False; //일정시작,종료, 담당자 추가, 삭제시 에 True
  Fchanged := False; //

end;

procedure TnewTaskPlan_Frm.FileGridDropFiles(aGrid:TNextGrid;var msg : TWMDropFiles);
var
  i,j,c, numFiles,NameLength : Integer;
  hDrop : THandle;
  tmpFile : array[0..MAX_PATH] of char;
  FileName,
  str,
  lExt : String;
  lms : TMemoryStream;
  lsize : Int64;
  LResult : Boolean;
begin
  with aGrid do
  begin
    BeginUpdate;
    try
      hDrop := Msg.Drop;
      try
        numFiles := DragQueryFile(Msg.Drop, $FFFFFFFF, nil, 0);
        for i := 0 to numFiles-1 do
        begin
          NameLength := DragQueryFile(hDrop, i, nil, 0);

          DragQueryFile(hDrop, i, tmpFile, NameLength+1);

          FileName := StrPas(tmpFile);

          if FileExists(FileName) then
          begin
            str := ExtractFileName(FileName);

            LResult := True;
            for j := 0 to RowCount-1 do
              if SameText(str, Cells[1,j]) then
              begin
                LResult := False;
                Break;
              end;

            if LResult then
            begin
              lms := TMemoryStream.Create;
              try
                lms.LoadFromFile(FileName);
                lsize := lms.Size;

                lExt := ExtractFileExt(str);
                Delete(lExt,1,1);
                AddRow;
                Cells[1,LastAddedRow] := str;
                Cells[2,LastAddedRow] := IntToStr(lsize);
                Cells[3,LastAddedRow] := FileName;

                for c := 0 to Columns.Count-1 do
                  Cell[c,LastAddedRow].TextColor := clBlue;
              finally
                FreeAndNil(lms);
              end;
            end;
          end;
        end;
      finally
        DragFinish(hDrop);
      end;
    finally
      EndUpdate;
    end;
  end;
end;

function TnewTaskPlan_Frm.Get_HITEMS_TMS_PLAN(aPlanNo:String;aRevNo:Integer) : Boolean;
var
  LCodeName: string;
  LAliasType, LAliasCode: integer;
begin
  Result := False;
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM DPMS_TMS_PLAN ' +
            'WHERE PLAN_NO = :param1 ' +
            'AND PLAN_REV_NO = :param2 ');
    ParamByName('param1').AsString := aPlanNo;
    ParamByName('param2').AsInteger := aRevNo;
    Open;

    if RecordCount <> 0 then
    begin
      taskNo.Hint := FieldByName('TASK_NO').AsString;
      taskNo.Text := Get_TaskName(taskNo.Hint);

      planCode.hint := FieldByName('PLAN_CODE').AsString;
      LAliasType := DM1.GetVisibleTypeFromGrp(planCode.hint, ord(ctGroup), LCodeName, LAliasCode);

      planCode.Text := LCodeName;

      if LAliasType = ord(atPrivate) then
        planCode.Color := ALIAS_PRIVATE_COLOR
      else
      if LAliasType = ord(atTeam)  then
        planCode.Color := ALIAS_TEAM_COLOR
      else
        planCode.Color := clWindow;

      planType.ItemIndex := FieldByName('PLAN_TYPE').AsInteger;

      planName.Text    := FieldByName('PLAN_NAME').AsString;

      planOutline.Text := FieldByName('PLAN_OUTLINE').AsString;

      engModel.Text  := FieldByName('ENG_MODEL').AsString;
      engType.Text   := FieldByName('ENG_TYPE').AsString;
      engProjNo.Text := FieldByName('ENG_PROJNO').AsString;

      if not FieldByName('PLAN_START').IsNull then
      begin
        planStart.Format := 'yyyy-MM-dd';
        planStart.Date := FieldByName('PLAN_START').AsDateTime;
      end else
      begin
        planStart.Format := '';
      end;

      if not FieldByName('PLAN_END').IsNull then
      begin
        planEnd.Format := 'yyyy-MM-dd';
        planEnd.Date := FieldByName('PLAN_END').AsDateTime;
      end else
      begin
        planEnd.Format := '';
      end;

      planMh.AsInteger := FieldByName('PLAN_MH').AsInteger;

      planProgress.AsInteger := FieldByName('PLAN_PROGRESS').AsInteger;
      planProgressBar.Position := planProgress.AsInteger;

      Result := True;

    end;
  end;
end;

procedure TnewTaskPlan_Frm.Get_HITEMS_TMS_PLAN_INCHARGE(aPlanNo:String;aRevNo:Integer);
var
  OraQuery : TOraQuery;
  li: Integer;
  lrow : Integer;
  str : string;

begin
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := DM1.OraSession1;
  try
    with empGrid do
    begin
      BeginUpdate;
      try
        ClearRows;
        with OraQuery do
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT * FROM DPMS_TMS_PLAN_INCHARGE ' +
                  'WHERE PLAN_NO = :param1 ' +
                  'AND PLAN_REV_NO = :param2 ' +
                  'ORDER BY PLAN_SEQ ');

          ParamByName('param1').AsString := aPlanNO;
          ParamByName('param2').AsInteger := aRevNo;
          Open;

          while not eof do
          begin
            lrow := AddRow;
            Cells[4,lrow] := FieldByName('PLAN_EMPNO').AsString;
            Cells[5,lrow] := FieldByName('PLAN_TEAM').AsString;

            str := LeftStr(Cells[5,lrow],4);
            Cells[1,lrow] := Get_DeptName(str);
            Cells[2,lrow] := Get_userNameAndPosition(Cells[4,lrow]);
            Cells[3,lrow] := NxComboBoxColumn1.Items.Strings[FieldByName('PLAN_ROLE').AsInteger];

            Next;

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

procedure TnewTaskPlan_Frm.Get_ParentTaskSchedule(aTask_Prt: String);
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM DPMS_TMS_TASK ' +
            'WHERE TASK_NO = :param1 ');
    ParamByName('param1').AsString := aTask_Prt;
    Open;

    if RecordCount <> 0 then
    begin
      FparentTaskBegin := FieldByName('EXD_TASK_START').AsDateTime;
      FparentTaskEnd   := FieldByName('EXD_TASK_END').AsDateTime;
    end;
  end;
end;

procedure TnewTaskPlan_Frm.Get_Revisions(aPlanNo: String);
var
  lrow : Integer;
begin
  with planGrid do
  begin
    BeginUpdate;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM DPMS_TMS_PLAN ' +
                'WHERE PLAN_NO = :param1 ' +
                'ORDER BY PLAN_REV_NO ');
        ParamByName('param1').AsString := aPlanNo;
        Open;

        if RecordCount <> 0 then
        begin
          while not eof do
          begin
            lrow := AddRow;
            Cells[1,lrow] := FieldByName('PLAN_INDATE').AsString;
            Cells[2,lrow] := Get_UserName(FieldByName('PLAN_DRAFTER').AsString);
            Cells[3,lrow] := FieldByName('PLAN_MOD_CAUSE').AsString;

            Cells[4,lrow] := FieldByName('TASK_NO').AsString;
            Cells[5,lrow] := FieldByName('PLAN_NO').AsString;
            Cells[6,lrow] := FieldByName('PLAN_CODE').AsString;
            Cells[7,lrow] := NxComboBoxColumn1.Items.Strings[FieldByName('PLAN_TYPE').AsInteger];
            Cells[8,lrow] := FieldByName('ENG_MODEL').AsString;
            Cells[9,lrow] := FieldByName('ENG_TYPE').AsString;

    //            Cells[7,lrow] := Get_planCodeName(Cells[3,lrow]);
            Cells[11,lrow] := FieldByName('PLAN_NAME').AsString;
            Cells[12,lrow] := Get_Plan_InCharge(Cells[5,lrow],FieldByName('PLAN_REV_NO').AsString,'');
            if not FieldByName('PLAN_START').IsNull then
              Cells[13,lrow] := FieldByName('PLAN_START').AsString
            else
              Cells[13,lrow] := '';

            if not FieldByName('PLAN_END').IsNull then
              Cells[14,lrow] := FieldByName('PLAN_END').AsString
            else
              Cells[14,lrow] := '';

            Cell[15,lrow].AsInteger := FieldByName('PLAN_PROGRESS').AsInteger;

            if Get_AttfilesCount(Cells[2,lrow]) > 0 then
              Cell[16,lrow].AsInteger := 39
            else
              Cell[16,lrow].AsInteger := -1;

            Cell[17,lrow].AsInteger := FieldByName('PLAN_REV_NO').AsInteger;

            Next;

          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

function TnewTaskPlan_Frm.INSERT_INTO_HiTEMS_TMS_PLAN(aPlanNo,aModCause:String;aRevNo:Integer) : Boolean;
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

        ParamByName('TASK_NO').AsString    := taskNo.Hint;
        ParamByName('PLAN_NO').AsString    := aPlanNo;
        ParamByName('PLAN_CODE').AsString  := planCode.Hint;
        ParamByName('PLAN_TYPE').AsInteger := planType.ItemIndex;
        ParamByName('PLAN_NAME').AsString  := planName.Text;

        ParamByName('PLAN_OUTLINE').AsString := planOutline.Text;
        ParamByName('ENG_MODEL').AsString  := engModel.Text;
        ParamByName('ENG_TYPE').AsString   := engType.Text;
        ParamByName('ENG_PROJNO').AsString := engProjNo.Text;

        ParamByName('PLAN_START').AsDate     := planStart.Date;
        ParamByName('PLAN_END').AsDate       := planEnd.Date;

        ParamByName('PLAN_MH').AsInteger       := planMh.AsInteger;
        ParamByName('PLAN_PROGRESS').AsInteger := planProgress.AsInteger;
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

procedure TnewTaskPlan_Frm.INSERT_INTO_HiTEMS_TMS_PLAN_INCHARGE(aPlanNo:string;aPlanRevNo:Integer);
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

procedure TnewTaskPlan_Frm.In_Update_case_Button_State_Set;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM ' +
            '( ' +
            '   SELECT A.PLAN_NO, A.PLAN_REV_NO, PLAN_DRAFTER, PLAN_EMPNO ' +
            '   FROM DPMS_TMS_PLAN A, DPMS_TMS_PLAN_INCHARGE B ' +
            '   WHERE A.PLAN_NO = B.PLAN_NO ' +
            '   AND A.PLAN_REV_NO = B.PLAN_REV_NO ' +
            ') ' +
            'WHERE PLAN_NO = :param1 ' +
            'AND PLAN_REV_NO = :param2 ');

    ParamByName('param1').AsString := planNo.Text;
    ParamByName('param2').AsInteger := revNo.AsInteger;
    Open;

    if RecordCount <> 0 then
    begin
      regBtn.Enabled := False;
      delBtn.Enabled := False;

      while not eof do
      begin
        if SameText(DM1.FUserInfo.CurrentUsers,FieldByName('PLAN_DRAFTER').AsString) or
        SameText(DM1.FUserInfo.CurrentUsers,FieldByName('PLAN_EMPNO').AsString) then
        begin
          regBtn.Enabled := True;
          delBtn.Enabled := True;
          Break;
        end;
        Next;
      end;

      if not regBtn.Enabled then
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM DPMS_TMS_AUTHORITY ' +
                'WHERE USERID = '''+DM1.FUserInfo.CurrentUsers+''' ');
        Open;

        if RecordCount <> 0 then
        begin
          if regBtn.Caption = '일정등록' then
            if FieldByName('PLAN_NEW').AsInteger > 0 then
              regBtn.Enabled := True
            else
              regBtn.Enabled := False
          else
            if FieldByName('PLAN_EDIT').AsInteger > 0 then
              regBtn.Enabled := True
            else
              regBtn.Enabled := False;

          if FieldByName('PLAN_DEL').AsInteger > 0 then
            delBtn.Enabled := True
          else
            delBtn.Enabled := False;

        end
        else
        begin
          regBtn.Enabled := False;
          delBtn.Enabled := False;
        end;
      end;
    end else
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM DPMS_TMS_AUTHORITY ' +
              'WHERE USERID = '''+DM1.FUserInfo.CurrentUsers+''' ');
      Open;

      if RecordCount <> 0 then
      begin
        if regBtn.Caption = '일정등록' then
          if FieldByName('PLAN_NEW').AsInteger > 0 then
            regBtn.Enabled := True
          else
            regBtn.Enabled := False
        else
          if FieldByName('PLAN_EDIT').AsInteger > 0 then
            regBtn.Enabled := True
          else
            regBtn.Enabled := False;

        if FieldByName('PLAN_DEL').AsInteger > 0 then
          delBtn.Enabled := True
        else
          delBtn.Enabled := False;

      end
      else
      begin
        regBtn.Enabled := False;
        delBtn.Enabled := False;
      end;
    end;
  end;
end;

procedure TnewTaskPlan_Frm.Management_Attfiles;
var
  li : integer;
  lms : TMemoryStream;
  aOwner,
  aRegNo,
  aFileName,
  aFileSize,
  aFilePath : String;
begin
  with fileGrid do
  begin
    BeginUpdate;
    try
      for li := 0 to RowCount-1 do
      begin
        if Cell[1,li].TextColor = clRed then
        begin
          aRegNo       := Cells[4,li];
          Delete_Attfile(aRegNo);
        end;

        if Cell[1,li].TextColor = clBlue then
        begin
          aOwner       := planNo.Text;
          aRegNo       := Get_makeKeyValue;
          aFileName    := Cells[1,li];
          aFileSize    := Cells[2,li];
          aFilePath    := Cells[3,li];

          Insert_Attfiles(aOwner,aRegNo,aFileName,aFileSize,aFilePath);

        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TnewTaskPlan_Frm.N1Click(Sender: TObject);
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

procedure TnewTaskPlan_Frm.N2Click(Sender: TObject);
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

procedure TnewTaskPlan_Frm.regBtnClick(Sender: TObject);
var
  lrevNo,
  li : Integer;
  str : string;
begin
  if planCode.Text = '' then
  begin
    planCode.SetFocus;
    raise Exception.Create('업무구분을 선택하여 주십시오!');
  end;

  if planName.Text = '' then
  begin
    planName.SetFocus;
    raise Exception.Create('업무내용을 입력하여 주십시오!');
  end;
  
  if empGrid.RowCount = 0 then
  begin
    PageControl1.ActivePageIndex := 1;
    empGrid.SetFocus;
    raise Exception.Create('한명 이상의 담당자를 선택하셔야 합니다!');
  end;

  if checkSchedule.Checked = False then
  begin
    taskNo.SetFocus;
    raise Exception.Create('사용 가능한 업무일정을 선택하여 주십시오!');
  end;

  if not(UpperCase(planStart.Format) = 'YYYY-MM-DD') then
  begin
    planStart.SetFocus;
    raise Exception.Create('업무일정/시작일을 입력하여 주십시오!');
  end;

  if not(UpperCase(planEnd.Format) = 'YYYY-MM-DD') then
  begin
    planEnd.SetFocus;
    raise Exception.Create('업무일정/종료일을 입력하여 주십시오!');
  end;

  with empGrid do
  begin
    BeginUpdate;
    try
      for li := 0 to RowCount-1 do
      begin
        if Cells[3,li] = '' then
          raise Exception.Create('담당자 역할을 선택하여 주십시오!');

      end;
    finally
      EndUpdate;
    end;
  end;

  if regBtn.Caption = '계획등록' then
  begin
    PlanNo.Text := Get_makeKeyValue;
    if Insert_Into_HiTEMS_TMS_PLAN(planNo.Text,'최초등록',revNo.AsInteger) then
    begin
      Insert_Change_Log_('PLAN','INSERT',planName.Text,DM1.FUserInfo.CurrentUsers);
      Management_Attfiles;
      Send_SMS;
      Fchanged := True;
      Close;

    end;
  end else
  begin
    //계획수정
    if Fmodifyed then
    begin
      str := Create_resultDialog_Frm('수정사유입력','');
      if str <> '' then
      begin
        revNo.AsInteger := revNo.AsInteger+1;
        if Insert_Into_HiTEMS_TMS_PLAN(planNo.Text,str,revNo.AsInteger) then
        begin
          Insert_Change_Log_('PLAN','UPDATE',planName.Text,DM1.FUserInfo.CurrentUsers);
          Management_Attfiles;
          Send_SMS;
          Fchanged := True;
          Close;
        end;
      end else
        ShowMessage('수정실패!(수정 사유를 입력하여 주십시오.)');
    end else
    begin
      if taskNo.Text = '' then
      begin
        ShowMessage('업무명이 공란이면 수정이 안됩니다.');
        exit;
      end;

      if UPDATE_HiTEMS_TMS_PLAN(planNo.Text,revNo.AsInteger) then
      begin
        Insert_Change_Log_('PLAN','UPDATE',planName.Text,DM1.FUserInfo.CurrentUsers);
        Management_Attfiles;
        Fchanged := True;
        ShowMessage('수정성공!');
        Close;
      end;
    end;
  end;
end;

procedure TnewTaskPlan_Frm.taskNoDropDown(Sender: TObject; var acceptdrop: Boolean);
begin
  Set_Parent_Task_Tree;
end;

procedure TnewTaskPlan_Frm.taskNoDropUp(Sender: TObject; canceled: Boolean);
var
  i : Integer;
  lselectedNode : TTreeNode;
  lkey : string;

  lCurrentTeam : string;

begin
  i := taskNo.Selection;
  try
    if i > -1 then
    begin
      lselectedNode := taskNo.Items.Item[i];

      for lkey in FtreeDic.Keys do
      begin
        if FtreeDic.Items[lkey] = lselectedNode then
          Break;
      end;
      taskNo.Hint := lkey;
    end else
    begin
      taskNo.Clear;
      taskNo.Hint := '';
      taskNo.Items.Clear;
    end;

  finally
    if taskNo.Hint <> '' then
    begin
      lCurrentTeam := LeftStr(DM1.FUserInfo.CurrentUsersTeam,4);

      if Check_Authority_of_addTask(taskNo.Hint, lCurrentTeam) then
      begin
        checkSchedule.Checked := True;
        checkSchedule.Caption := '사용 가능한 일정!';
        checkSchedule.Font.Color := clBlue;
      end else
      begin
        checkSchedule.Checked := False;
        checkSchedule.Caption := '사용 불가능한 일정!';
        checkSchedule.Font.Color := clRed;
        taskNo.Clear;
        taskNo.Hint := '';
      end;
    end else
    begin
      taskNo.Clear;
      taskNo.Hint := '';
    end;
  end;
end;

function TnewTaskPlan_Frm.UPDATE_HiTEMS_TMS_PLAN(aPlanNo: string;
  aPlanRevNo: Integer): Boolean;
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
        SQL.Add('UPDATE DPMS_TMS_PLAN SET ' +
                'TASK_NO = :TASK_NO, PLAN_CODE = :PLAN_CODE, PLAN_TYPE = :PLAN_TYPE, ' +
                'PLAN_NAME = :PLAN_NAME, PLAN_OUTLINE = :PLAN_OUTLINE, ENG_MODEL = :ENG_MODEL, ' +
                'ENG_TYPE = :ENG_TYPE, ENG_PROJNO = :ENG_PROJNO, PLAN_MH = :PLAN_MH, ' +
                'PLAN_PROGRESS = :PLAN_PROGRESS ' +
                'WHERE PLAN_NO = :param1 ' +
                'AND PLAN_REV_NO = :param2 ');

        ParamByName('param1').AsString  := aPlanNo;
        ParamByName('param2').AsInteger := aPlanRevNo;

        ParamByName('TASK_NO').AsString    := taskNo.Hint;
        ParamByName('PLAN_CODE').AsString  := planCode.Hint;
        ParamByName('PLAN_TYPE').AsInteger := planType.ItemIndex;
        ParamByName('PLAN_NAME').AsString  := planName.Text;

        ParamByName('PLAN_OUTLINE').AsString := planOutline.Text;
        ParamByName('ENG_MODEL').AsString  := engModel.Text;
        ParamByName('ENG_TYPE').AsString   := engType.Text;
        ParamByName('ENG_PROJNO').AsString := engProjNo.Text;

        ParamByName('PLAN_MH').AsInteger       := planMh.AsInteger;
        ParamByName('PLAN_PROGRESS').AsInteger := planProgress.AsInteger;

        ExecSQL;

        INSERT_INTO_HiTEMS_TMS_PLAN_INCHARGE(aPlanNo,aPlanRevNo);

      end;
      Commit;
      Result := True;
    except
      Rollback;
    end;
  end;
end;

procedure TnewTaskPlan_Frm.Send_SMS;
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
    SQL.Add('SELECT REQ_ID FROM DPMS_TMS_TEST_REQUEST WHERE REQ_NO LIKE ' +
            '( SELECT REQ_NO FROM DPMS_TMS_TEST_RECEIVE_INFO ' +
            '  WHERE PLAN_NO LIKE :param1 )');
    ParamByName('param1').AsString := planNo.Text;
    Open;

    if RecordCount <> 0 then
    begin
      lhead    := 'HiTEMS ';
      ltitle   := '시험접수건 ';
      LReqID := FieldByName('REQ_ID').AsString;

      LMsg := '요청하신 시험('+planName.Text+')의 일정이 아래와 같이 변경되었습니다. ' +
              '시험예정일 '+FormatDateTime('yyyy-MM-dd',planStart.Date) +
              ' ~ ' + FormatDateTime('yyyy-MM-dd',planEnd.Date);

      lcontent := LMsg;

      Send_SMS_Note(lMsg,lReqID,lhead,ltitle,lcontent,'A');
    end;
  end;
end;

procedure TnewTaskPlan_Frm.SetUI;
begin
  if DM1.FUserInfo.AliasCode_Dept <> 18 then    //신뢰성 연구실 Alias = 18(K1G)
    planType.Items.Delete(PlanType.Items.Count - 1); //"시험일정" 항목 삭제
end;

procedure TnewTaskPlan_Frm.Set_Parent_Task_Tree;
begin
  TThread.Queue(nil,
  procedure
  const
    Query = 'SELECT * FROM ' +
            '(         ' +
            '   SELECT ' +
            '       A.TASK_NO, TASK_PRT, TASK_LV, TASK_NAME, EXD_TASK_START, ' +
            '         EXD_TASK_END, EXD_MH, ACT_TASK_START, ACT_TASK_END, ' +
            '         ACT_PROGRESS, TASK_OUTLINE, TASK_MANAGER, TASK_DRAFTER, ' +
            '         TASK_INDATE, TASK_ORDER, TASK_STATE,' +
            '       B.TASK_TEAM ' +
            '   FROM DPMS_TMS_TASK A, ' +
            '     DPMS_TMS_TASK_SHARE B  ' +
            '   WHERE  ' +
            '   ( ' +
            '     ( ' +
            '       TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :beginDate  ' +
            '       AND EXD_TASK_END >= TO_DATE(:beginDate, ''yyyy-mm-dd'')  ' +
            '       AND TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :endDate  ' +
            '       AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') <= :endDate  ' +
            '       OR EXD_TASK_START >= TO_DATE(:beginDate, ''yyyy-mm-dd'')  ' +
            '       AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') >= :beginDate  ' +
            '       AND TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :endDate  ' +
            '       AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') <= :endDate  ' +
            '       OR TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') >= :beginDate  ' +
            '       AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') >= :beginDate  ' +
            '       AND TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :endDate  ' +
            '       AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') >= :endDate  ' +
            '       OR TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :beginDate  ' +
            '       AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') >= :beginDate  ' +
            '       AND TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :endDate  ' +
            '       AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') >= :endDate ' +
            '     ) ' +
            '     OR ' +
            '     ( ' +
            '         (EXD_TASK_START IS NULL) OR (EXD_TASK_END IS NULL) ' +
            '     ) ' +
            '   ) ' +
            '   AND A.TASK_NO = B.TASK_NO  ' +
            '   AND SUBSTR(TASK_TEAM, 1, 4) = :team  ' +
            ')    ' +
            'START WITH TASK_PRT IS NULL ' +
            'CONNECT BY PRIOR TASK_NO = TASK_PRT ';
  var
    OraQuery : TOraQuery;
    lnode : TTreeNode;
    lbeginDate, lendDate : TDateTime;
    lteam : String;
  begin
    with taskNo.Items do
    begin
      BeginUpdate;
      try
        Clear;
        with DM1.OraQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add(Query);
          ParamByName('beginDate').AsString := FormatDateTime('yyyy-MM-dd',FstartDate);
          ParamByName('endDate').AsString := FormatDateTime('yyyy-MM-dd',FendDate);
          ParamByName('team').AsString  := FteamCode;
          Open;

          if RecordCount <> 0 then
          begin
            if not Assigned(FtreeDic) then
              FtreeDic := TDictionary<string,TTreeNode>.Create
            else
              FtreeDic.Clear;

            while not eof do
            begin
              if FtreeDic.Count = 0 then
                lnode := AddFirst(nil,FieldByName('TASK_NAME').AsString)
              else
              begin
                if FtreeDic.ContainsKey(FieldByName('TASK_PRT').AsString) then
                begin
                  FtreeDic.TryGetValue(FieldByName('TASK_PRT').AsString,lnode);
                  lnode := AddChild(lnode, FieldByName('TASK_NAME').AsString);
                end else
                begin
                  lnode := AddFirst(nil,FieldByName('TASK_NAME').AsString);
                end;
              end;

              FtreeDic.Add(FieldByName('TASK_NO').AsString,lnode);

              Next;
            end;
          end;
        end;
      finally
        EndUpdate;
      end;
    end;
  end);
end;

procedure TnewTaskPlan_Frm.planEndChange(Sender: TObject);
begin
  if FparentTaskEnd <> 0 then
  begin
    if planEnd.Date > FparentTaskEnd then
    begin
      ShowMessage('종료일은 상위 업무의 종료일보다 클 수 없습니다.');
      planEnd.Date := FparentTaskEnd;
    end;
    planEnd.Format := 'yyyy-MM-dd';
  end else
    if planEnd.Date <> 0 then
      planEnd.Format := 'yyyy-MM-dd'
    else
      planEnd.Format := ' ';

  Fmodifyed := True;
end;

procedure TnewTaskPlan_Frm.engModelButtonDown(Sender: TObject);
begin
  with engModel.Items do
  begin
    BeginUpdate;
    try
      Clear;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select Distinct(ENGMODEL) from DPMS_HIMSEN_INFO ' +
                'where STATUS = 0 ' +
                'order by ENGMODEL DESC');
        Open;

        Add('');
        if not(RecordCount = 0) then
        begin
          while not eof do
          begin
            Add(FieldByName('ENGMODEL').AsString);
            Next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TnewTaskPlan_Frm.engModelSelect(Sender: TObject);
begin
  engProjNo.Clear;
  engType.Clear;
  engType.Items.Clear;
end;

procedure TnewTaskPlan_Frm.engTypeButtonDown(Sender: TObject);
var
  lstr : String;
begin
  with engType.Items do
  begin
    BeginUpdate;
    try
      Clear;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select PROJNO, ENGTYPE, ENGMODEL from DPMS_HIMSEN_INFO ' +
                'where STATUS = 0 ' +
                'AND ENGMODEL = :param1 ' +
                'order by ENGTYPE DESC ');

        if engModel.Text <> '' then
          ParamByName('param1').AsString := engModel.Text
        else
          SQL.Text := ReplaceStr(SQL.Text,'AND ENGMODEL = :param1 ','');

        Open;

        Add('');
        if not(RecordCount = 0) then
        begin
          while not eof do
          begin
            lstr := FieldByName('PROJNO').AsString +'-'+
                    FieldByName('ENGTYPE').AsString;

            Add(lstr);
            Next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TnewTaskPlan_Frm.engTypeSelect(Sender: TObject);
var
  litem : TStringList;
begin
  if not(engType.Text = '') then
  begin
    litem := TStringList.Create;
    try
      ExtractStrings(['-'],[],PChar(engType.Text),litem);

      if litem.Count > 0 then
      begin

        with DM1.OraQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('select PROJNO, ENGMODEL, ENGTYPE from DPMS_HIMSEN_INFO ' +
                  'where PROJNO = :param1 ');

          ParamByName('param1').AsString := litem.Strings[0];
          Open;

          if not(RecordCount = 0) then
          begin
            engModel.Text := FieldByName('ENGMODEL').Text;
            engType.Text  := FieldByName('ENGTYPE').Text;
            engProjNo.Text   := FieldByName('PROJNO').Text;
          end;
        end;
      end;
    finally
      FreeAndNil(litem);
    end;
  end;
end;

procedure TnewTaskPlan_Frm.fileGridCellDblClick(Sender: TObject; ACol,
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

procedure TnewTaskPlan_Frm.fileGridDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  DragAcceptFiles(handle,true);
  Accept := True;

end;

procedure TnewTaskPlan_Frm.planProgressChange(Sender: TObject);
begin
  planProgressBar.Position := planProgress.AsInteger;
end;

end.




