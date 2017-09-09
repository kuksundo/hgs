unit bussLog_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxColumnClasses, NxColumns,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.StdCtrls,
  NxEdit, Vcl.ExtCtrls, AdvSplitter, GradientLabel, NxCollection,
  Vcl.ComCtrls, AdvDateTimePicker, AdvOfficeStatusBar,DateUtils,StrUtils,
  Vcl.Menus,Ora,Db, AdvCombo, Vcl.Imaging.jpeg, AdvGroupBox, AdvOfficeButtons,
  AdvPanel, JvExControls, JvLabel, winApi.ShellApi;

type
  TbussLog_Frm = class(TForm)
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    OpenDialog1: TOpenDialog;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    Panel5: TPanel;
    Image1: TImage;
    AdvPanel1: TAdvPanel;
    Label13: TLabel;
    perform: TDateTimePicker;
    NxHeaderPanel1: TNxHeaderPanel;
    Panel1: TPanel;
    usedTime: TAdvOfficeRadioGroup;
    Button6: TButton;
    Panel6: TPanel;
    Button4: TButton;
    regBtn: TButton;
    Button2: TButton;
    Button3: TButton;
    Button5: TButton;
    Button7: TButton;
    bussGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn7: TNxTextColumn;
    NxTextColumn4: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn1: TNxTextColumn;
    NxProgressColumn1: TNxProgressColumn;
    RST_CODE: TNxEdit;
    NxTextColumn12: TNxTextColumn;
    NxTextColumn13: TNxTextColumn;
    NxTextColumn8: TNxTextColumn;
    NxTextColumn14: TNxTextColumn;
    delBtn: TButton;
    plan_Name: TNxEdit;
    RST_CODE_NAME: TNxEdit;
    RST_NOTE: TRichEdit;
    RST_TIME_TYPE: TNxComboBox;
    RST_MH: TNxNumberEdit;
    accumulateMh: TNxNumberEdit;
    RST_PROGRESS: TNxNumberEdit;
    RST_PERFORM: TDateTimePicker;
    plan_No: TNxEdit;
    restInfo: TLabel;
    fileGrid: TNextGrid;
    NxIncrementColumn3: TNxIncrementColumn;
    NxTextColumn9: TNxTextColumn;
    NxTextColumn10: TNxTextColumn;
    NxTextColumn11: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn15: TNxTextColumn;
    revNo: TNxNumberEdit;
    JvLabel1: TJvLabel;
    JvLabel2: TJvLabel;
    JvLabel3: TJvLabel;
    JvLabel4: TJvLabel;
    JvLabel5: TJvLabel;
    JvLabel6: TJvLabel;
    JvLabel7: TJvLabel;
    JvLabel8: TJvLabel;
    JvLabel9: TJvLabel;
    OTMHEdit: TNxNumberEdit;
    JvLabel10: TJvLabel;
    RST_TITLE: TComboBox;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure regBtnClick(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure RST_TITLEButtonDown(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure bussGridCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure Button2Click(Sender: TObject);
    procedure delBtnClick(Sender: TObject);
    procedure RST_TITLESelect(Sender: TObject);
    procedure performChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure N6Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure RST_NOTEEnter(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    FRST_NO : String;

    ForiginFileGridWindowProc : TWndMethod;
    procedure FileGridWindowProc(var msg : TMessage);
    procedure FileGridDropFiles(aGrid:TNextGrid;var msg:TWMDropFiles);

  public
    { Public declarations }
    procedure bussLog_Frm_Init;
    function Get_HiTEMS_TMS_RESULT(aPerform:TDateTime; aRstBy:String) : Boolean;

    procedure Insert_Into_HiTEMS_TMS_RESULT(aRST_NO:String);
    procedure Update_HiTEMS_TMS_RESULT(aRST_NO:String);
    procedure Management_Attfiles;
    function Check_rest_Info : String;

    procedure Set_Detail_Info(aRstNo, aRstBy:String);
  end;

var
  bussLog_Frm: TbussLog_Frm;
  procedure Preview_BussLog(aPerform,aRstNo,aRstBy:String);

implementation
uses
  selectCode_Unit,
  selectPlan_Unit,
  taskMain_Unit,
  HiTEMS_TMS_COMMON,
  HiTEMS_TMS_CONST,
  CommonUtil_Unit,
  DataModule_Unit;

{$R *.dfm}
procedure Preview_BussLog(aPerform,aRstNo,aRstBy:String);
var
  i : Integer;
begin
  bussLog_Frm := TbussLog_Frm.Create(nil);
  with bussLog_Frm do
  begin
    perform.Date := StrToDateTime(aPerform);
    Get_HiTEMS_TMS_RESULT(perform.Date, aRstBy);
    with bussGrid do
    begin
      BeginUpdate;
      try
        for i := 0 to RowCount-1 do
        begin
          if SameText(Cells[1,i], aRstNo) then
          begin
            SelectedRow := i;
            Break;
          end;
        end;
      finally
        EndUpdate;
      end;
    end;

    Set_Detail_Info(aRstNo, aRstBy);

    Show;

  end;
end;

procedure TbussLog_Frm.regBtnClick(Sender: TObject);
var
  LWeekMH: double;
  Ld: double;
begin
  if RST_TITLE.Text = '' then
  begin
    RST_TITLE.SetFocus;
    raise Exception.Create('업무내용 은(는) 필수 입력 입니다!');
  end;

  if RST_CODE.Text = '' then
  begin
    RST_CODE_NAME.SetFocus;
    raise Exception.Create('업무코드 은(는) 필수 입력 입니다!');
  end;

  if RST_MH.Value = 0 then
  begin
    RST_MH.SetFocus;
    raise Exception.Create('투입M/H 은(는) 필수 입력 입니다!');
  end;

  if RST_PROGRESS.Value = 0 then
  begin
    RST_PROGRESS.SetFocus;
    raise Exception.Create('진행율(%) 은(는) 필수 입력 입니다!');
  end;

  if regBtn.Caption = '업무실적 등록' then
    FRST_NO := Get_makeKeyValue;

  if ((RST_TIME_TYPE.Text = '연장근무') or (RST_TIME_TYPE.Text = '야간근무') or (RST_TIME_TYPE.Text = '철야근무')) then
  begin
    LWeekMH := OTMHEdit.Value;
    Ld := 12.0 - LWeekMH;

    if (LWeekMH + RST_MH.Value) > 12  then
    begin
      raise Exception.Create('주간 MH(52시간)를 초과하였습니다!' + #13#10 + FloatToStr(Ld) + ' 시간 연장 근무 입력 가능합니다.');
      exit;
    end;
  end;

  if regBtn.Caption = '업무실적 등록' then
  begin
    FRST_NO := Get_makeKeyValue;
    Insert_Into_HiTEMS_TMS_RESULT(FRST_NO);
  end else
  begin
    //업무실적수정
    Update_HiTEMS_TMS_RESULT(FRST_NO);

  end;

  Management_Attfiles;
  ShowMessage(format('%s 완료!',[regBtn.Caption]));

  Get_HiTEMS_TMS_RESULT(perform.Date, DM1.FUserInfo.CurrentUsers);
  Get_Attfiles(fileGrid,FRST_NO);

  if MessageDlg('입력란을 초기화 하시겠습니까?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    bussLog_Frm_Init;
  end;
end;

procedure TbussLog_Frm.bussGridCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  if ARow > -1 then
  begin
    with bussGrid do
    begin
      FRST_NO := Cells[1,ARow];
      Set_Detail_Info(FRST_NO,DM1.FUserInfo.CurrentUsers);

    end;
  end;
end;

procedure TbussLog_Frm.bussLog_Frm_Init;
begin
  FRST_NO := '';
  plan_No.Clear;
  plan_Name.Clear;

  RST_CODE_NAME.Clear;
  RST_CODE.Clear;

  RST_TITLE.Clear;

  RST_NOTE.Clear;

  RST_PERFORM.Date := perform.Date;

  RST_TIME_TYPE.ItemIndex := 0;
  RST_MH.Value := 0;
  RST_PROGRESS.Value := 0;

  fileGrid.ClearRows;

  regBtn.Caption := '업무실적 등록';
  delBtn.Enabled := False;
end;

procedure TbussLog_Frm.Button2Click(Sender: TObject);
begin
  bussLog_Frm_Init;
end;

procedure TbussLog_Frm.Button3Click(Sender: TObject);
var
  str : string;
  llist : TStringList;
begin
  str := Create_selectPlan_Frm(RST_PERFORM.Date);
  if str <> '' then
  begin
    llist := TStringList.Create;
    try
      ExtractStrings([';'],[],PChar(str),llist);

      if llist.Count <> 0 then
      begin
        plan_No.Text := llist.Strings[0];
        revNo.Text   := llist.Strings[1];
        plan_Name.Text := Get_planName(plan_No.Text, revNo.AsInteger);
      end else
      begin
        plan_No.Clear;
        plan_Name.Clear;
        revNo.AsInteger := 0;

      end;
    finally
      FreeAndNil(llist);
    end;
  end;
end;

procedure TbussLog_Frm.Button4Click(Sender: TObject);
begin
  Close;
end;

procedure TbussLog_Frm.Button5Click(Sender: TObject);
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
  end;
end;

procedure TbussLog_Frm.Button6Click(Sender: TObject);
var
  lTypeName: String;
  lTypeNo: String;
  lResult: String;
  lResultList: TStringList;
begin
  lResult := Create_selectCode_frm(RST_CODE.Text, 'B');
  if not(lResult = '') then
  begin
    RST_CODE.Text := lResult;
    RST_CODE_NAME.Text := Get_Hitems_Code_Name(RST_CODE.Text);
  end else
  begin
    RST_CODE.Clear;
    RST_CODE_NAME.Clear;
  end;
end;

procedure TbussLog_Frm.Button7Click(Sender: TObject);
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

function TbussLog_Frm.Check_rest_Info: String;
var
  lTeamNo : String;
begin
  lTeamNo := DM1.FUserInfo.CurrentUsersTeam;
  lTeamNo := LeftStr(lTeamNo,4);
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * FROM HITEMS_USER_REST ' +
            'WHERE USERID = :param1 ' +
            'AND RESTFROM <= :param2 and RESTTO >= :param2 ');

    ParamByName('param1').AsString := DM1.FUserInfo.CurrentUsers;
    ParamByName('param2').AsDate := perform.Date;
    Open;

    if RecordCount <> 0 then
      Result := '※ 근태구분 : '+FieldByName('RESTTYPE').AsString +' /' +
                  ' 근태사유 : '+FieldByName('RESTDESC').AsString
    else
      Result := '';

  end;
end;

procedure TbussLog_Frm.delBtnClick(Sender: TObject);
begin
  if MessageDlg('업무내용 : '+RST_TITLE.Text+#10#13+
                '삭제 하시겠습니까? 삭제된 정보는 복구할 수 없습니다.', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    with DM1.OraTransaction1 do
    begin
      StartTransaction;
      try
        //첨부파일 삭제
        Delete_Attfiles(FRST_NO);
        with DM1.OraQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('Delete From TMS_RESULT ' +
                  'WHERE RST_NO = :param1 ');
          ParamByName('param1').AsString := FRST_NO;
          ExecSQL;

        end;
        Commit;
        ShowMessage('삭제완료!');
        Get_HiTEMS_TMS_RESULT(perform.Date, DM1.FUserInfo.CurrentUsers);
        bussLog_Frm_Init;
      except
        DM1.OraTransaction1.Rollback;
      end;
    end;
  end;
end;

procedure TbussLog_Frm.FileGridDropFiles(aGrid: TNextGrid;
  var msg: TWMDropFiles);
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

procedure TbussLog_Frm.FileGridWindowProc(var msg: TMessage);
begin
  if (msg.msg = WM_DROPFILES) then
    FileGridDropFiles(fileGrid,TWMDROPFILES(Msg))
  else
    ForiginFileGridWindowProc(Msg);
end;

procedure TbussLog_Frm.FormActivate(Sender: TObject);
begin
  RST_NOTE.SetFocus;
  RST_TITLE.SetFocus;
end;

procedure TbussLog_Frm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TbussLog_Frm.FormCreate(Sender: TObject);
var
  li : integer;
begin
  ForiginFileGridWindowProc := fileGrid.WindowProc;
  fileGrid.WindowProc := FileGridWindowProc;

  DragAcceptFiles(fileGrid.Handle,True);

  perform.Date := Today;
  RST_PERFORM.Date  := Today;

  bussGrid.DoubleBuffered := False;
  fileGrid.DoubleBuffered := False;

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

  restInfo.Caption := Check_rest_Info;

  Get_HiTEMS_TMS_RESULT(toDay, DM1.FUserInfo.CurrentUsers);

  SetHangeulMode2(Application.Handle);//Application.Handle
end;

function TbussLog_Frm.Get_HiTEMS_TMS_RESULT(aPerform:TDateTime; aRstBy:String) : Boolean;
var
  lrow,i : Integer;
  laccumulate : Double;
  LWeekMH: double;
  LRestType: string;
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
        SQL.Add('select A.*, B.RST_SORT, B.RST_BY, B.RST_MH, B.RST_TIME_TYPE ' +
                'FROM TMS_RESULT A, TMS_RESULT_MH B ' +
                'WHERE A.RST_PERFORM = :param1 ' +
                'AND B.RST_BY = :param2 ' +
                'AND A.RST_NO = B.RST_NO ' +
                'ORDER BY A.RST_NO');
        ParamByName('param1').AsDate := aPerform;
        ParamByName('param2').AsString := aRstBy;

        Open;

        laccumulate := 0;
        if not(RecordCount = 0)  then
        begin
          while not eof do
          begin
            lrow := AddRow;
            Cells[1,lrow] := FieldByName('RST_NO').AsString;
            Cells[2,lrow] := FieldByName('PLAN_NO').AsString;
            Cells[3,lrow] := FieldByName('RST_CODE').AsString;
            Cells[4,lrow] := Get_planName(Cells[2,lrow], FieldByName('PLAN_REV_NO').AsInteger);
            Cells[5,lrow] := FieldByName('RST_TITLE').AsString;

            Cells[6,lrow] := FieldByName('RST_PERFORM').AsString;
            Cells[7,lrow] := FieldByName('RST_MH').AsString;
            Cell[8,lrow].AsInteger := FieldByName('RST_PROGRESS').AsInteger;
            Cells[9,lrow] := ftimeType[FieldByName('RST_TIME_TYPE').AsInteger];

            laccumulate := laccumulate + FieldByName('RST_MH').AsFloat;

            Next;
          end;
        end;
        accumulateMh.Value := laccumulate;
      end;

      if Assigned(DM1.FOffReasonList) then
        DM1.FOffReasonList.Clear;

      LWeekMH := DM1.GetWeekOverTimeMH(RST_PERFORM.Date, DM1.FUserInfo.CurrentUsers);

      if Assigned(DM1.FOffReasonList) then
      begin
        OTMHEdit.Hint := '';

        for LRestType in DM1.FOffReasonList.Keys do
        begin
          DM1.FOffReasonList.TryGetValue(LRestType,i);
          OTMHEdit.Hint := OTMHEdit.Hint + LRestType + ':' + IntToStr(i) + #13#10;
        end;

        OTMHEdit.Hint := Copy(OTMHEdit.Hint, 1, Length(OTMHEdit.Hint)-2);
      end;

      OTMHEdit.Value := LWeekMH;

    finally
      EndUpdate;
    end;
  end;
end;


procedure TbussLog_Frm.Insert_Into_HiTEMS_TMS_RESULT(aRST_NO:String);
begin
  with DM1.OraTransaction1 do
  begin
    StartTransaction;
    try
      with DM1.OraQuery1 do
      begin
        // HITEMS_TMS_TASK_RESULT
        Close;
        SQL.Clear;
        SQL.Add('INSERT INTO TMS_RESULT ' +
                'VALUES(:PLAN_NO, :RST_NO, :RST_CODE, :RST_TYPE, :RST_PERFORM, :RST_TITLE, ' +
                ':RST_NOTE, :RST_PROGRESS, :RST_NEXT_DATE, :RST_NEXT_TASK, :PLAN_REV_NO )');

        ParamByName('PLAN_NO').AsString       := plan_No.Text;
        ParamByName('RST_NO').AsString        := aRST_NO;
        ParamByName('RST_CODE').AsString      := RST_CODE.Text;
        ParamByName('RST_TYPE').AsInteger     := 0;
        ParamByName('RST_PERFORM').AsDate     := RST_PERFORM.Date;
        ParamByName('RST_TITLE').AsString     := RST_TITLE.Text;
        ParamByName('RST_NOTE').AsString      := RST_NOTE.Text;
        ParamByName('RST_PROGRESS').AsInteger := RST_PROGRESS.AsInteger;
        ParamByName('PLAN_REV_NO').AsInteger  := REVNO.AsInteger;

        ExecSQL;

        // HITEMS_TMS_TASK_RESULT_MH

        Close;
        SQL.Clear;
        SQL.Add('INSERT INTO TMS_RESULT_MH ' +
                'VALUES(:RST_NO, :RST_SORT, :RST_BY, :RST_MH, :RST_TIME_TYPE )');


        ParamByName('RST_NO').AsString         := aRST_NO;
        ParamByName('RST_SORT').AsInteger      := 0;
        ParamByName('RST_BY').AsString         := DM1.FUserInfo.CurrentUsers;
        ParamByName('RST_MH').AsFloat          := RST_MH.AsFloat;
        ParamByName('RST_TIME_TYPE').AsInteger := RST_TIME_TYPE.ItemIndex;

        ExecSQL;
      end;
      Commit;
    except
      Rollback;
    end;
  end;
end;

procedure TbussLog_Frm.Management_Attfiles;
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
          aOwner       := FRST_NO;
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


procedure TbussLog_Frm.N1Click(Sender: TObject);
var
  lrow : Integer;
  li,le : integer;
begin
  with FileGrid do
  begin
    BeginUpdate;
    try
      if OpenDialog1.Execute then
      begin
        for li := 0 to OpenDialog1.Files.Count-1 do
        begin
          lrow := AddRow;
          Cells[2,lrow] := OpenDialog1.FileName;
          Cells[1,lrow] := ExtractFileName(Cells[2,lrow]);

          for le := 0 to Columns.Count-1 do
            Cell[le,lrow].TextColor := clBlue;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TbussLog_Frm.N2Click(Sender: TObject);
var
  lrow : Integer;
  li : integer;
begin
  with fileGrid do
  begin
    BeginUpdate;
    try
      if SelectedRow > -1 then
      begin
        lrow := SelectedRow;

        if MessageDlg('선택된 파일을 삭제하시겠습니까?'+#10#13+
                      '삭제된 파일은 복구할 수 없습니다. ',
                       mtConfirmation, [mbYes, mbNo], 0) = mrYES then begin

          if not(Cells[2,lrow] = '') then
            DeleteRow(lrow)
          else
            for li := 0 to Columns.Count-1 do
              Cell[li,lrow].TextColor := clRed;

        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TbussLog_Frm.N6Click(Sender: TObject);
begin
  if GetImeHanMode(Application.Handle) then
    ShowMessage('한글 모드')
  else
    ShowMessage('영문 모드')
end;

procedure TbussLog_Frm.N8Click(Sender: TObject);
begin
  ToggleHanMode;
end;

procedure TbussLog_Frm.performChange(Sender: TObject);
begin
  Get_HiTEMS_TMS_RESULT(perform.Date, DM1.FUserInfo.CurrentUsers);
  RST_PERFORM.Date := perform.Date;
  restInfo.Caption := Check_rest_Info;
end;

procedure TbussLog_Frm.Update_HiTEMS_TMS_RESULT(aRST_NO: String);
begin
  with DM1.OraTransaction1 do
  begin
    StartTransaction;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('UPDATE TMS_RESULT SET ' +
                'PLAN_NO = :PLAN_NO, RST_CODE = :RST_CODE, ' +
                'RST_PERFORM = :RST_PERFORM, RST_TITLE = :RST_TITLE, ' +
                'RST_NOTE = :RST_NOTE, RST_PROGRESS = :RST_PROGRESS ' +
                'WHERE RST_NO = :param1 ');
        ParamByName('param1').AsString := aRST_NO;

        ParamByName('PLAN_NO').AsString       := plan_No.Text;
        ParamByName('RST_CODE').AsString      := RST_CODE.Text;
        ParamByName('RST_PERFORM').AsDate     := RST_PERFORM.Date;
        ParamByName('RST_TITLE').AsString     := RST_TITLE.Text;
        ParamByName('RST_NOTE').AsString      := RST_NOTE.Text;
        ParamByName('RST_PROGRESS').AsInteger := RST_PROGRESS.AsInteger;

        ExecSQL;

        // HITEMS_TMS_TASK_RESULT_MH

        Close;
        SQL.Clear;
        SQL.Add('DELETE FROM TMS_RESULT_MH ' +
                'WHERE RST_NO = :param1 ');
        ParamByName('param1').AsString := aRST_NO;
        ExecSQL;

        Close;
        SQL.Clear;
        SQL.Add('INSERT INTO TMS_RESULT_MH ' +
                'VALUES(:RST_NO, :RST_SORT, :RST_BY, :RST_MH, :RST_TIME_TYPE )');


        ParamByName('RST_NO').AsString         := aRST_NO;
        ParamByName('RST_SORT').AsInteger      := 0;
        ParamByName('RST_BY').AsString         := DM1.FUserInfo.CurrentUsers;
        ParamByName('RST_MH').AsFloat          := RST_MH.AsFloat;
        ParamByName('RST_TIME_TYPE').AsInteger := RST_TIME_TYPE.ItemIndex;

        ExecSQL;

      end;
      Commit;
    except
      Rollback;
    end;
  end;
end;

procedure TbussLog_Frm.RST_NOTEEnter(Sender: TObject);
begin
  SetHangeulMode2(RST_NOTE.Handle);//Application.Handle
end;

procedure TbussLog_Frm.RST_TITLEButtonDown(Sender: TObject);
begin
  if plan_Name.Text = '' then
  begin
    plan_Name.SetFocus;
    raise Exception.Create('먼저 업무를 선택하여 주십시오!');
  end;

  with RST_TITLE.Items do
  begin
    BeginUpdate;
    try
      Clear;
      Add('');
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select DISTINCT(RST_TITLE) ' +
                'FROM TMS_RESULT ' +
                'WHERE RST_TYPE = 0 ' +
                'AND PLAN_NO = :param1 ' +
                'ORDER BY RST_TITLE DESC ');
        ParamByName('param1').AsString := plan_No.Text;
        Open;

        if not(RecordCount = 0) then
        begin
          while not eof do
          begin
            Add(FieldByName('RST_TITLE').AsString);
            Next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TbussLog_Frm.RST_TITLESelect(Sender: TObject);
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select RST_PROGRESS, RST_PERFORM ' +
            'FROM TMS_RESULT ' +
            'WHERE RST_TYPE = 0 ' +
            'AND PLAN_NO = :param1 ' +
            'AND RST_TITLE = :param2 ' +
            'ORDER BY RST_PERFORM DESC ');
    ParamByName('param1').AsString := plan_No.Text;
    ParamByName('param2').AsString := RST_TITLE.Text;
    Open;

    if RecordCount <> 0 then
      RST_PROGRESS.AsInteger := FieldByName('RST_PROGRESS').AsInteger;

  end;
end;


procedure TbussLog_Frm.Set_Detail_Info(aRstNo, aRstBy: String);
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT A.*, B.RST_BY, B.RST_MH, B.RST_TIME_TYPE ' +
            'FROM TMS_RESULT A, TMS_RESULT_MH B ' +
            'WHERE A.RST_NO = :param1 ' +
            'AND B. RST_BY = :param2 ' +
            'AND A.RST_NO = B.RST_NO ');
    ParamByName('param1').AsString := aRstNo;
    ParamByName('param2').AsString := aRstBy;
    Open;

    if RecordCount <> 0 then
    begin
      plan_No.Text       := FieldByName('PLAN_NO').AsString;
      revNo.AsInteger    := FieldByName('PLAN_REV_NO').AsInteger;
      plan_Name.Text     := Get_planName(plan_No.Text, revNo.AsInteger);
      RST_CODE.Text      := FieldByName('RST_CODE').AsString;
      RST_CODE_NAME.Text := Get_Hitems_Code_Name(RST_CODE.Text);
      RST_TITLE.Text     := FieldByName('RST_TITLE').AsString;
      RST_NOTE.Text      := FieldByName('RST_NOTE').AsString;
      RST_PERFORM.Date   := FieldByName('RST_PERFORM').AsDateTime;
      RST_MH.AsFloat     := FieldByName('RST_MH').AsFloat;
      RST_PROGRESS.AsInteger := FieldByName('RST_PROGRESS').AsInteger;
      RST_TIME_TYPE.ItemIndex := FieldByName('RST_TIME_TYPE').AsInteger;

      Get_Attfiles(fileGrid,FRST_NO);

      regBtn.Caption := '업무실적 수정';
      delBtn.Enabled := True;

    end;
  end;
end;

end.
