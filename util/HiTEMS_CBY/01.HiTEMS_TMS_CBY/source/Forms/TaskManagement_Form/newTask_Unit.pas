unit newTask_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvToolBar, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ImgList, AdvGroupBox, AdvOfficeButtons, NxEdit, AdvGlowButton,
  JvExStdCtrls, JvCombobox, JvListComb, JvEdit, NxCollection, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, NxColumnClasses, NxColumns, NxScrollControl,StrUtils,
  NxCustomGridControl, NxCustomGrid, NxGrid, DateUtils, AdvSmoothProgressBar,
  Vcl.CheckLst, AdvTreeComboBox, Ora, AdvDateTimePicker, Vcl.Mask, JvExMask,
  System.Generics.Collections,JvToolEdit, AeroButtons;

type
  TnewTask_Frm = class(TForm)
    Panel8: TPanel;
    Image1: TImage;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    OpenDialog1: TOpenDialog;
    Panel2: TPanel;
    regBtn: TAdvGlowButton;
    AdvGlowButton1: TAdvGlowButton;
    delBtn: TAdvGlowButton;
    Label7: TLabel;
    et_taskName: TJvEdit;
    Label15: TLabel;
    et_Outline: TRichEdit;
    TabSheet3: TTabSheet;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    dt_exp_begin: TDateTimePicker;
    dt_exp_end: TDateTimePicker;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    dt_act_begin: TDateTimePicker;
    dt_act_end: TDateTimePicker;
    Label8: TLabel;
    GroupBox3: TGroupBox;
    Label9: TLabel;
    ACT_PROGRESS: TNxNumberEdit;
    ACT_PROGRESSBAR: TAdvSmoothProgressBar;
    Label10: TLabel;
    et_manager: TJvEdit;
    AdvGlowButton2: TAdvGlowButton;
    Label11: TLabel;
    Label12: TLabel;
    GroupBox4: TGroupBox;
    Label13: TLabel;
    EXD_MH: TNxNumberEdit;
    shareGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    Label14: TLabel;
    tree_taskParent: TAdvTreeComboBox;
    NxComboBoxColumn1: TNxComboBoxColumn;
    JvComboBox1: TJvComboBox;
    AdvGlowButton3: TAdvGlowButton;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn1: TNxTextColumn;
    et_taskNo: TEdit;
    nb_taskLv: TNxNumberEdit;
    Label16: TLabel;
    cb_taskState: TComboBox;
    Label17: TLabel;
    et_taskDrafter: TJvEdit;
    dt_indate: TDateTimePicker;
    AeroButton1: TAeroButton;
    AeroButton2: TAeroButton;
    AeroButton3: TAeroButton;
    AeroButton4: TAeroButton;
    procedure FormCreate(Sender: TObject);
    procedure regBtnClick(Sender: TObject);
    procedure delBtnClick(Sender: TObject);
    procedure AdvGlowButton1Click(Sender: TObject);
    procedure dt_exp_beginChange(Sender: TObject);
    procedure dt_exp_endChange(Sender: TObject);
    procedure dt_act_beginChange(Sender: TObject);
    procedure dt_act_endChange(Sender: TObject);
    procedure ACT_PROGRESSChange(Sender: TObject);
    procedure AdvGlowButton2Click(Sender: TObject);
    procedure AdvGlowButton3Click(Sender: TObject);
    procedure AdvGlowButton4Click(Sender: TObject);
    procedure JvComboBox1DropDown(Sender: TObject);
    procedure JvComboBox1Select(Sender: TObject);
    procedure shareGridAfterEdit(Sender: TObject; ACol, ARow: Integer;
      Value: WideString);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tree_taskParentDropDown(Sender: TObject; var acceptdrop: Boolean);
    procedure tree_taskParentDropUp(Sender: TObject; canceled: Boolean);
    procedure AeroButton1Click(Sender: TObject);
    procedure AeroButton2Click(Sender: TObject);
    procedure AeroButton3Click(Sender: TObject);
    procedure AeroButton4Click(Sender: TObject);
  private
    { Private declarations }
    Fchanged : Boolean;
    FselectedDept : String;
    FteamCode : String;
    FstartDate,
    FendDate : TDateTime; //FstartDate & FendDate make Parent Tree Resource
    FtreeDic : TDictionary<string,TTreeNode>;

    FparentTaskBegin, FparentTaskEnd : TDateTime; //새로 지정하는 일정이 상위 일정보다 크거나 작지않게
    procedure Refresh_Attfiles;
  public
    { Public declarations }
    procedure Get_ParentTaskSchedule(aTask_Prt:String);
    procedure Set_taskTree;
    function Insert_Into_HiTEMS_TMS_TASK : Boolean;
    procedure Insert_Into_HiTEMS_TMS_TASK_SHARE(aTask_No:String);

    function Update_HiTEMS_TMS_TASK : Boolean;
    procedure Get_HiTEMS_TMS_TASK(aTask_No:String);

    procedure Set_shareGrid;
    procedure Set_shareDeptList;
    function Get_TaskOrder(aTask_No:String):Integer;

    procedure In_Update_case_Button_State_Set(aSC_No:String);

  end;

var
  newTask_Frm: TnewTask_Frm;
  function Create_newTask_Frm(aTask_No,aParent_No,aTeamCode:String;
        aTaskLv:Integer;aStartDate,aEndDate:TDateTime) : String;

implementation
uses
  findUser_Unit,
  sendSMS_Unit,
  CommonUtil_Unit,
  HiTEMS_TMS_COMMON,
  HiTEMS_TMS_CONST,
  taskMain_Unit,
  DataModule_Unit;

{$R *.dfm}

function Create_newTask_Frm(aTask_No,aParent_No,aTeamCode:String;
        aTaskLv:Integer;aStartDate,aEndDate:TDateTime) : String;
begin
  newTask_Frm := TnewTask_Frm.Create(nil);
  try
    with newTask_Frm do
    begin
      FteamCode := aTeamCode;
      FstartDate := aStartDate;
      FendDate   := aEndDate;
      et_taskNo.Text := aTask_No;
      nb_taskLv.AsInteger := aTaskLv;

      tree_TaskParent.Hint := aParent_No;
      tree_TaskParent.Text := Get_TaskName(tree_TaskParent.Hint);
      if tree_taskParent.Hint <> '' then
        Get_ParentTaskSchedule(tree_TAskParent.Hint)
      else
      begin
        FparentTaskBegin := 0;
        FparentTaskEnd := 0;
      end;

      Set_shareDeptList;

      if et_taskNo.Text <> '' then
      begin
        //업무수정
        regBtn.Caption := '업무수정';
        DelBtn.Enabled := True;

        Get_HiTEMS_TMS_TASK(aTask_No);

        In_Update_case_Button_State_Set(aTask_No);
      end else
      begin
        //신규업무등록
        et_taskNo.Clear;
        nb_taskLv.AsInteger := 0;
        regBtn.Caption := '업무등록';
        DelBtn.Enabled := False;
        Set_shareGrid;
      end;

      ShowModal;

      if Fchanged then
        Result := et_taskNo.Text
      else
        Result := '';

    end;
  finally
    FreeAndNil(newTask_Frm);
  end;
end;

procedure TnewTask_Frm.delBtnClick(Sender: TObject);
var
  taskNo : String;
begin
  Fchanged := True;
  if MessageDlg('업무명 : '+et_taskName.Text+#10#13+
                '삭제 하시겠습니까? 삭제된 정보는 복구할 수 없습니다.', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    with DM1.OraTransaction1 do
    begin
      StartTransaction;
      try
        taskNo := et_taskNo.Text;

        //첨부파일 삭제
        Delete_Attfiles(taskNo);
        with DM1.OraQuery1 do
        begin
          // task 삭제
          Close;
          SQL.Clear;
          SQL.Add('DELETE FROM TMS_TASK ' +
                  'WHERE TASK_NO = :param1 ');
          ParamByName('param1').AsString := taskNo;
          ExecSQL;
        end;
        Commit;
        Insert_Change_Log_('TASK','DELETE',et_taskName.Text,DM1.FUserInfo.CurrentUsers);
        ShowMessage('삭제완료!');
        Close;
      except
        Rollback;
      end;
    end;
  end;
end;

procedure TnewTask_Frm.ACT_PROGRESSChange(Sender: TObject);
begin
  ACT_PROGRESSBAR.Position := ACT_PROGRESS.AsInteger;
end;

procedure TnewTask_Frm.dt_act_endChange(Sender: TObject);
begin
  dt_act_end.Format := 'yyyy-MM-dd';
end;

procedure TnewTask_Frm.dt_act_beginChange(Sender: TObject);
begin
  dt_act_begin.Format := 'yyyy-MM-dd';
end;

procedure TnewTask_Frm.AdvGlowButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TnewTask_Frm.AdvGlowButton2Click(Sender: TObject);
var
  lemp : String;

begin
  lemp := DM1.FUserInfo.CurrentUsers;
  lemp := Create_findUser_Frm(lemp,'A');

  if not(lemp = '') then
  begin
    et_manager.Hint := lemp;
    et_manager.Text := Get_UserName(lemp);
  end else
  begin
    et_manager.Hint := '';
    et_manager.Clear;
  end;
end;

procedure TnewTask_Frm.AdvGlowButton3Click(Sender: TObject);
var
  lrow : Integer;
  li : Integer;
begin
  if JvComboBox1.Text <> '' then
  begin
    with shareGrid do
    begin
      BeginUpdate;
      try
        for li := 0 to RowCount-1 do
        begin
          if SameText(JvComboBox1.Text,Cells[1,li]) then
          begin
            ShowMessage('등록된 팀 입니다.');
            Exit;
          end;
        end;

        lrow := shareGrid.AddRow;
        Cells[1,lrow] := JvComboBox1.Text;
        if lrow <> 0 then
          Cells[2,lrow] := NxComboBoxColumn1.Items.Strings[0]//읽기 권한
        else
          Cells[2,lrow] := NxComboBoxColumn1.Items.Strings[1];//읽기쓰기 권한
        Cells[3,lrow] := FselectedDept;

      finally
        EndUpdate;
      end;
    end;
  end;
end;

procedure TnewTask_Frm.AdvGlowButton4Click(Sender: TObject);
var
  lrow : Integer;
begin
  lrow := shareGrid.SelectedRow;

  if lrow <> 0 then
    shareGrid.DeleteRow(lrow);


end;

procedure TnewTask_Frm.AeroButton1Click(Sender: TObject);
begin
  dt_exp_begin.Format := ' ';
end;

procedure TnewTask_Frm.AeroButton2Click(Sender: TObject);
begin
  dt_exp_end.Format := ' ';
end;

procedure TnewTask_Frm.AeroButton3Click(Sender: TObject);
begin
  dt_act_begin.Format := ' ';
end;

procedure TnewTask_Frm.AeroButton4Click(Sender: TObject);
begin
  dt_act_end.Format := ' ';
end;

procedure TnewTask_Frm.Get_ParentTaskSchedule(aTask_Prt: String);
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM TMS_TASK ' +
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

procedure TnewTask_Frm.dt_exp_endChange(Sender: TObject);
begin
  if FparentTaskEnd <> 0 then
  begin
    if dt_exp_end.Date > FparentTaskEnd then
    begin
      ShowMessage('종료일은 상위 업무의 종료일보다 클 수 없습니다.');
      dt_exp_end.Date := FparentTaskEnd;
    end;
    dt_exp_end.Format := 'yyyy-MM-dd';
  end else
    if dt_exp_end.Date <> 0 then
      dt_exp_end.Format := 'yyyy-MM-dd'
    else
      dt_exp_end.Format := ' ';
end;

procedure TnewTask_Frm.dt_exp_beginChange(Sender: TObject);
begin
  if FparentTaskBegin <> 0 then
  begin
    if dt_exp_begin.Date < FparentTaskBegin then
    begin
      ShowMessage('시작일은 상위 업무의 시작일보다 작을 수 없습니다.');
      dt_exp_begin.Date := FparentTaskBegin;
    end;
    dt_exp_begin.Format := 'yyyy-MM-dd';
  end else
    if dt_exp_begin.Date <> 0 then
      dt_exp_begin.Format := 'yyyy-MM-dd'
    else
      dt_exp_begin.Format := ' ';
end;

procedure TnewTask_Frm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TnewTask_Frm.FormCreate(Sender: TObject);
begin
  Fchanged := False;
  shareGrid.DoubleBuffered := False;
  PageControl1.ActivePageIndex := 0;

  //예상일정
  dt_exp_begin.Date := today;
  dt_exp_end.Date   := Tomorrow;
  dt_exp_begin.Format := ' ';
  dt_exp_end.Format := ' ';

  //실제일정
  dt_act_begin.Date := today;
  dt_act_end.Date   := Tomorrow;
  dt_act_begin.Format := ' ';
  dt_act_end.Format := ' ';

end;

procedure TnewTask_Frm.Get_HiTEMS_TMS_TASK(aTask_No: String);
var
  i,
  lrow : Integer;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from TMS_TASK ' +
            'where TASK_NO = :param1 ');
    ParamByName('param1').AsString := aTask_No;
    Open;

    if RecordCount <> 0 then
    begin
      et_taskNo.Text          := FieldByName('TASK_NO').AsString;
      tree_taskParent.Hint    := FieldByName('TASK_PRT').AsString;
      tree_taskParent.Text    := Get_TaskName(tree_taskParent.Hint);

      nb_taskLv.AsInteger     := FieldByName('TASK_LV').AsInteger;
      et_taskName.Text        := FieldByName('TASK_NAME').AsString;

      if not FieldByName('EXD_TASK_START').IsNull then
      begin
        dt_exp_begin.Date := FieldByName('EXD_TASK_START').AsDateTime;
        dt_exp_begin.Format := 'yyyy-MM-dd';
      end else
        dt_exp_begin.Format := ' ';

      if not FieldByName('EXD_TASK_END').IsNull then
      begin
        dt_exp_end.Date   := FieldByName('EXD_TASK_END').AsDateTime;
        dt_exp_end.Format := 'yyyy-MM-dd';
      end else
        dt_exp_end.Format := ' ';


      EXD_MH.AsInteger    := FieldByName('EXD_MH').AsInteger;

      if not FieldByName('ACT_TASK_START').IsNull then
      begin
        dt_act_begin.Date := FieldByName('ACT_TASK_START').AsDateTime;
        dt_act_begin.Format := 'yyyy-MM-dd';
      end else
        dt_act_begin.Format := ' ';

      if not FieldByName('ACT_TASK_END').IsNull then
      begin
        dt_act_end.Date   := FieldByName('ACT_TASK_END').AsDateTime;
        dt_act_end.Format := 'yyyy-MM-dd';
      end else
        dt_act_end.Format := ' ';

      ACT_PROGRESS.AsInteger := FieldByName('ACT_PROGRESS').AsInteger;

      et_Outline.Text := FieldByName('TASK_OUTLINE').AsString;


      for i := 0 to cb_taskState.Items.Count-1 do
      begin
        if FieldByName('TASK_STATE').AsString = cb_taskState.Text then
        begin
          cb_taskState.ItemIndex := i;
          break;
        end;
      end;

      et_manager.Hint := FieldByName('TASK_MANAGER').AsString;
      et_manager.Text := Get_UserName(et_manager.Hint);

      et_taskDrafter.Text      := FieldByName('TASK_DRAFTER').AsString;
      dt_indate.Date           := FieldByName('TASK_INDATE').AsDateTime;

      with shareGrid do
      begin
        BeginUpdate;
        ClearRows;
        try
          Close;
          SQL.Clear;
          SQL.Add('SELECT * FROM TMS_TASK_SHARE ' +
                  'WHERE TASK_NO = :param1 ' +
                  'ORDER BY TASK_SORT ');
          ParamByName('param1').AsString := et_taskNo.Text;
          Open;

          if RecordCount <> 0 then
          begin
            while not eof do
            begin
              lrow := AddRow;
              Cells[1,lrow] := Get_DeptName(FieldByName('TASK_TEAM').AsString);
              Cells[2,lrow] := NxComboBoxColumn1.Items.Strings[FieldByName('TASK_AUTHORITY').AsInteger];
              Cells[3,lrow] := FieldByName('TASK_TEAM').AsString;

              Next;
            end;
          end;
        finally
          EndUpdate;
        end;
      end;
    end;
  end;
end;

function TnewTask_Frm.Get_TaskOrder(aTask_No: String): Integer;
var
  OraQuery : TOraQuery;
  Query : String;
begin
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := DM1.OraSession1;
  try
    if aTask_No <> '' then
    begin
      Query := 'SELECT NVL(MAX(TASK_ORDER)+1,1) ORDERS FROM TMS_TASK WHERE TASK_PRT = :param1 ';
    end else
      Query := 'SELECT NVL(MAX(TASK_ORDER)+1,1) ORDERS FROM ' +
               '( ' +
               '    SELECT A.TASK_NO, A.TASK_PRT, A.TASK_ORDER, B.TASK_TEAM ' +
               '    FROM TMS_TASK A, TMS_TASK_SHARE B ' +
               '    WHERE A.TASK_NO = B.TASK_NO ' +
               '    AND B.TASK_TEAM = :param1 ' +
               ') ';


    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add(Query);
      if aTask_No <> '' then
        ParamByName('param1').AsString := aTask_No
      else
        ParamByName('param1').AsString := LeftStr(DM1.FUserInfo.CurrentUsersTeam,4);
      Open;

      Result := FieldByName('ORDERS').AsInteger;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

function TnewTask_Frm.Insert_Into_HiTEMS_TMS_TASK : Boolean;
var
  i : Integer;
  n : TTreeNode;
  taskNo : string;
begin
  et_taskNo.Text := Get_makeKeyValue;
  with DM1.OraTransaction1 do
  begin
    StartTransaction;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Insert Into TMS_TASK ' +
                'Values(:TASK_NO, :TASK_PRT, :TASK_LV, :TASK_NAME, :EXD_TASK_START, :EXD_TASK_END, ' +
                ':EXD_MH, :ACT_TASK_START, :ACT_TASK_END, :ACT_PROGRESS, :TASK_OUTLINE, ' +
                ':TASK_MANAGER, :TASK_DRAFTER, :TASK_INDATE, :TASK_ORDER,:TASK_STATE) ');


        ParamByName('TASK_NO').AsString         := et_taskNo.Text;
        ParamByName('TASK_PRT').AsString        := tree_taskParent.Hint;

        i := tree_taskParent.Selection;
        if i <> -1 then
        begin
          n := tree_taskParent.Items[i];
          nb_taskLv.AsInteger := n.Level+1;
          ParamByName('TASK_LV').AsInteger      := nb_taskLv.AsInteger;
        end else
          ParamByName('TASK_LV').AsInteger      := 0;

        ParamByName('TASK_NAME').AsString       := et_taskName.Text;

        if UpperCase(dt_exp_begin.Format) <> 'YYYY-MM-DD' then
          ParamByName('EXD_TASK_START').Clear
        else
          ParamByName('EXD_TASK_START').AsDate  := dt_exp_begin.Date;

        if UpperCase(dt_exp_end.Format) <> 'YYYY-MM-DD' then
          ParamByName('EXD_TASK_END').Clear
        else
          ParamByName('EXD_TASK_END').AsDate  := dt_exp_end.Date;

        ParamByName('EXD_MH').AsInteger         := EXD_MH.AsInteger;

        if UpperCase(dt_act_begin.Format) <> 'YYYY-MM-DD' then
          ParamByName('ACT_TASK_START').Clear
        else
          ParamByName('ACT_TASK_START').AsDate  := dt_act_begin.Date;

        if UpperCase(dt_act_end.Format) <> 'YYYY-MM-DD' then
          ParamByName('ACT_TASK_END').Clear
        else
          ParamByName('ACT_TASK_END').AsDate  := dt_act_end.Date;

        ParamByName('ACT_PROGRESS').AsInteger   := ACT_PROGRESS.AsInteger;
        ParamByName('TASK_OUTLINE').AsString    := et_Outline.Text;

        ParamByName('TASK_MANAGER').AsString    := et_manager.Hint;
        ParamByName('TASK_DRAFTER').AsString    := DM1.FUserInfo.CurrentUsers;
        ParamByName('TASK_INDATE').AsDateTime   := Now;
        ParamByName('TASK_ORDER').AsInteger     := Get_TaskOrder(tree_taskParent.Hint);
        ParamByName('TASK_STATE').AsString      := cb_taskState.Text;

        ExecSQL;

        Insert_Into_HiTEMS_TMS_TASK_SHARE(et_taskNo.Text);

        Commit;
        Result := True;
      end;
    except
      Result := False;
      Rollback;
    end;
  end;
end;

procedure TnewTask_Frm.Insert_Into_HiTEMS_TMS_TASK_SHARE(aTask_No:String);
var
  OraQuery : TOraQuery;
  li : Integer;

begin
  with shareGrid do
  begin
    BeginUpdate;
    OraQuery := TOraQuery.Create(nil);
    OraQuery.Session := DM1.OraSession1;
    try
      with OraQuery do
      begin
        Close;
        SQL.Clear;
        SQL.Add('DELETE FROM TMS_TASK_SHARE ' +
                'WHERE TASK_NO = :param1 ');
        ParamByName('param1').AsString := aTask_No;
        ExecSQL;

        for li := 0 to RowCount-1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('INSERT INTO TMS_TASK_SHARE ' +
                  'Values(:TASK_NO, :TASK_TEAM, :TASK_AUTHORITY, :TASK_SORT)');

          ParamByName('TASK_NO').AsString      := aTask_No;
          ParamByName('TASK_TEAM').AsString    := Cells[3,li];
          ParamByName('TASK_AUTHORITY').AsInteger := NxComboBoxColumn1.Items.IndexOf(Cells[2,li]);
          ParamByName('TASK_SORT').AsInteger   := li;

          ExecSQL;

        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TnewTask_Frm.In_Update_case_Button_State_Set(aSC_No: String);
begin
  if aSC_No <> '' then
  begin
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT TASK_MANAGER, TASK_DRAFTER FROM TMS_TASK ' +
              'WHERE TASK_NO = '''+aSC_No+''' ');
      Open;

      if RecordCount <> 0 then
      begin
        if SameText(DM1.FUserInfo.CurrentUsers,FieldByName('TASK_MANAGER').AsString) or
        SameText(DM1.FUserInfo.CurrentUsers,FieldByName('TASK_DRAFTER').AsString) then
        begin
          regBtn.Enabled := True;
          delBtn.Enabled := True;
        end
        else
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT * FROM TMS_AUTHORITY ' +
                  'WHERE USERID = '''+DM1.FUserInfo.CurrentUsers+''' ');
          Open;

          if RecordCount <> 0 then
          begin
            if regBtn.Caption = '업무등록' then
              if FieldByName('TASK_NEW').AsInteger > 0 then
                regBtn.Enabled := True
              else
                regBtn.Enabled := False
            else
              if FieldByName('TASK_EDIT').AsInteger > 0 then
                regBtn.Enabled := True
              else
                regBtn.Enabled := False;

            if FieldByName('TASK_DEL').AsInteger > 0 then
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
        regBtn.Enabled := False;
        delBtn.Enabled := False;
      end;
    end;
  end;
end;

procedure TnewTask_Frm.JvComboBox1DropDown(Sender: TObject);
begin
  Set_shareDeptList;
end;

procedure TnewTask_Frm.JvComboBox1Select(Sender: TObject);
var
  lDeptName : String;
begin
  with DM1.OraQuery1 do
  begin
    First;
    lDeptName := JvComboBox1.Text;
    while not eof do
    begin
      if SameText(lDeptName,FieldByName('DEPT_NAME').AsString) then
      begin
        FselectedDept := FieldByName('DEPT_CD').AsString;
        Break;
      end;
      Next;
    end;
  end;
end;

procedure TnewTask_Frm.Refresh_Attfiles;
begin

end;

procedure TnewTask_Frm.regBtnClick(Sender: TObject);
var
  lMsg : String;
begin
  if MessageDlg(Format('%s 하시겠습니까?',[regBtn.Caption]),
                mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    Fchanged := True;
    if regBtn.Caption = '업무등록' then
    begin
      if Insert_Into_HiTEMS_TMS_TASK = True then
      begin
        Insert_Change_Log_('TASK','INSERT',et_taskName.Text,DM1.FUserInfo.CurrentUsers);
        ModalResult := mrOk;
        ShowMessage('등록성공!');
      end
      else
      begin
        ModalResult := mrCancel;
        ShowMessage('등록실패!');
      end;
    end
    else //업무수정
    begin
      if Update_HiTEMS_TMS_TASK = True then
      begin
        Insert_Change_Log_('TASK','UPDATE',et_taskName.Text,DM1.FUserInfo.CurrentUsers);
        ModalResult := mrOk;
        if MessageDlg('변경성공! 변경된 내용을 통보하시겠습니까?',
            mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        begin
          Create_sendSMS_Frm(et_taskNo.Text);
        end;
      end
      else
      begin
        ModalResult := mrCancel;
        ShowMessage('등록실패!');
      end;
    end;
    Close;
  end;
end;

procedure TnewTask_Frm.Set_shareDeptList;
begin
  with JvComboBox1.Items do
  begin
    BeginUpdate;
    try
      Clear;

      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM HITEMS_DEPT WHERE PARENT_CD LIKE :param1 ');
        ParamByName('param1').AsString := DM1.FUserInfo.CurrentUsersDept;
        Open;

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

procedure TnewTask_Frm.Set_shareGrid;
var
  lrow : Integer;
  lTeam : String;
begin
  with shareGrid do
  begin
    BeginUpdate;
    try
      lTeam := LeftStr(DM1.FUserInfo.CurrentUsersTeam,4);
      lrow := AddRow;
      Cells[1,lrow] := Get_DeptName(lTeam);
      Cells[2,lrow] := NxComboBoxColumn1.Items.Strings[1];
      Cells[3,lrow] := lTeam;
    finally
      EndUpdate;
    end;
  end;
end;


procedure TnewTask_Frm.Set_taskTree;
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
            '   FROM TMS_TASK A, ' +
            '   TMS_TASK_SHARE B  ' +
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
    with tree_taskParent.Items do
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

procedure TnewTask_Frm.shareGridAfterEdit(Sender: TObject; ACol,
  ARow: Integer; Value: WideString);
var
  lidx : Integer;
begin
  with shareGrid do
  begin
    BeginUpdate;
    try
      if ACol = 2 then
      begin
        lidx := NxComboBoxColumn1.Items.IndexOf(Cells[2,SelectedRow]);
        //idx = 2 = 제거
        if lidx = 2 then
          DeleteRow(SelectedRow);
      end;

    finally
      EndUpdate;
    end;
  end;
end;

procedure TnewTask_Frm.tree_taskParentDropDown(Sender: TObject;
  var acceptdrop: Boolean);
begin
  Set_taskTree;
end;

procedure TnewTask_Frm.tree_taskParentDropUp(Sender: TObject;
  canceled: Boolean);
var
  i : Integer;
  lselectedNode : TTreeNode;
  lkey : string;

  lCurrentTeam : string;

begin
  tree_taskParent.Hint := '';
  i := tree_taskParent.Selection;
  try
    if i > -1 then
    begin
      lselectedNode := tree_taskParent.Items.Item[i];
      nb_taskLv.AsInteger := lselectedNode.Level;

      for lkey in FtreeDic.Keys do
      begin
        if FtreeDic.Items[lkey] = lselectedNode then
          Break;
      end;
      tree_taskParent.Hint := lkey;
    end else
    begin
      tree_taskParent.Clear;
      tree_taskParent.Hint := '';
      nb_taskLv.AsInteger := 0;
    end;
  finally
    if tree_taskParent.Hint <> '' then
    begin
      lCurrentTeam := LeftStr(DM1.FUserInfo.CurrentUsersTeam,4);
    end else
    begin
      tree_taskParent.Clear;
      tree_taskParent.Hint := '';
    end;
  end;
end;

function TnewTask_Frm.Update_HiTEMS_TMS_TASK : Boolean;
begin
  with DM1.OraTransaction1 do
  begin
    StartTransaction;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Update TMS_TASK Set ' +
                'TASK_PRT = :TASK_PRT, TASK_LV = :TASK_LV, TASK_NAME = :TASK_NAME, ' +
                'EXD_TASK_START = :EXD_TASK_START, EXD_TASK_END = :EXD_TASK_END, ' +
                'EXD_MH = :EXD_MH, ACT_TASK_START = :ACT_TASK_START, ' +
                'ACT_TASK_END = :ACT_TASK_END, ACT_PROGRESS = :ACT_PROGRESS, ' +
                'TASK_OUTLINE = :TASK_OUTLINE, TASK_MANAGER = :TASK_MANAGER, ' +
                'TASK_STATE = :TASK_STATE ' +
                'WHERE TASK_NO = :param1 ');

        ParamByName('param1').AsString          := et_taskNo.Text;

        ParamByName('TASK_PRT').AsString        := tree_taskParent.Hint;
        ParamByName('TASK_LV').AsInteger        := nb_taskLv.AsInteger+1;
        ParamByName('TASK_NAME').AsString       := et_taskName.Text;

        if UpperCase(dt_exp_begin.Format) <> 'YYYY-MM-DD' then
          ParamByName('EXD_TASK_START').Clear
        else
          ParamByName('EXD_TASK_START').AsDate  := dt_exp_begin.Date;

        if UpperCase(dt_exp_end.Format) <> 'YYYY-MM-DD' then
          ParamByName('EXD_TASK_END').Clear
        else
          ParamByName('EXD_TASK_END').AsDate  := dt_exp_end.Date;

        ParamByName('EXD_MH').AsInteger         := EXD_MH.AsInteger;

        if UpperCase(dt_act_begin.Format) <> 'YYYY-MM-DD' then
          ParamByName('ACT_TASK_START').Clear
        else
          ParamByName('ACT_TASK_START').AsDate  := dt_act_begin.Date;

        if UpperCase(dt_act_end.Format) <> 'YYYY-MM-DD' then
          ParamByName('ACT_TASK_END').Clear
        else
          ParamByName('ACT_TASK_END').AsDate  := dt_act_end.Date;

        ParamByName('ACT_PROGRESS').AsInteger   := ACT_PROGRESS.AsInteger;
        ParamByName('TASK_OUTLINE').AsString    := et_Outline.Text;
        ParamByName('TASK_MANAGER').AsString    := et_manager.Hint;
        ParamByName('TASK_STATE').AsString      := cb_taskState.Text;
        ExecSQL;
      end;

      Insert_Into_HiTEMS_TMS_TASK_SHARE(et_taskNo.Text);

      Commit;
      Result := True;
    except
      Result := False;
      Rollback;
    end;
  end;
end;

end.
