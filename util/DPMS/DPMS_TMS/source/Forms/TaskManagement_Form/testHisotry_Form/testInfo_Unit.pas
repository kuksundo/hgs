unit testInfo_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.StdCtrls, AeroButtons, CurvyControls, NxCollection, Vcl.ComCtrls,
  JvExControls, JvLabel, NxColumnClasses, NxColumns, NxScrollControl,
  NxCustomGridControl, NxCustomGrid, NxGrid, AdvGroupBox, AdvOfficeButtons,
  AdvGlowButton, AdvDateTimePicker, Vcl.ImgList, Ora, StrUtils, DateUtils,
  ShellApi, Vcl.Menus, AdvMenus, DB;

type
  TtestInfo_Frm = class(TForm)
    Panel8: TPanel;
    Image1: TImage;
    Panel1: TPanel;
    CurvyPanel1: TCurvyPanel;
    AeroButton2: TAeroButton;
    JvLabel11: TJvLabel;
    ImageList16X16: TImageList;
    Button10: TButton;
    Button2: TButton;
    empGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    NxComboBoxColumn1: TNxComboBoxColumn;
    NxTextColumn6: TNxTextColumn;
    NxTextColumn4: TNxTextColumn;
    et_end: TEdit;
    et_engType: TEdit;
    et_planNo: TEdit;
    et_start: TEdit;
    et_testName: TEdit;
    et_testNo1: TEdit;
    et_testNo2: TEdit;
    et_testNo3: TEdit;
    et_testNo4: TEdit;
    et_testNo5: TEdit;
    et_testType: TEdit;
    JvLabel1: TJvLabel;
    JvLabel10: TJvLabel;
    JvLabel12: TJvLabel;
    JvLabel15: TJvLabel;
    JvLabel16: TJvLabel;
    JvLabel2: TJvLabel;
    JvLabel3: TJvLabel;
    JvLabel4: TJvLabel;
    JvLabel5: TJvLabel;
    JvLabel6: TJvLabel;
    JvLabel7: TJvLabel;
    JvLabel8: TJvLabel;
    JvLabel9: TJvLabel;
    btn_Reg: TAdvGlowButton;
    AdvGlowButton2: TAdvGlowButton;
    Splitter1: TSplitter;
    NxHeaderPanel1: TNxHeaderPanel;
    JvLabel13: TJvLabel;
    grid_Test: TNextGrid;
    fileGrid: TNextGrid;
    NxIncrementColumn3: TNxIncrementColumn;
    NxTextColumn8: TNxTextColumn;
    NxTextColumn11: TNxTextColumn;
    NxTextColumn12: TNxTextColumn;
    NxTextColumn19: TNxTextColumn;
    NxTextColumn20: TNxTextColumn;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    AdvPopupMenu1: TAdvPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    NxNumberColumn1: TNxNumberColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    NxTextColumn7: TNxTextColumn;
    NxTextColumn9: TNxTextColumn;
    NxTextColumn10: TNxTextColumn;
    NxTextColumn13: TNxTextColumn;
    NxTextColumn14: TNxTextColumn;
    et_testPurpose: TEdit;
    et_reqDept: TEdit;
    et_reqIncharge: TEdit;
    cb_testLocation: TComboBox;
    et_method: TMemo;
    procedure cb_testLocationDropDown(Sender: TObject);
    procedure cb_testLocationSelect(Sender: TObject);
    procedure AeroButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AdvGlowButton2Click(Sender: TObject);
    procedure btn_RegClick(Sender: TObject);
    procedure mGridDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Button2Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure grid_TestCellDblClick(Sender: TObject; ACol, ARow: Integer);
  private
    { Private declarations }
    ForiginFileGridWindowProc : TWndMethod;
    procedure FileGridWindowProc(var msg : TMessage);
    procedure FileGridDropFiles(aGrid:TNextGrid;var msg:TWMDropFiles);
  public
    { Public declarations }
    procedure Get_BaseInfo(aPlanNo:String);
    procedure Get_InchargeOfTest(aPlanNo:String;aRevNo:Integer);
    procedure Set_TestNo;

    procedure Get_Revision(aPlanNo:String);
    procedure Insert_TestInfo(aCause:String);
    procedure Management_Attfiles;
  end;

var
  testInfo_Frm: TtestInfo_Frm;
  procedure Create_testInfo_Frm(aPlanNo:String);

implementation
uses
  resultDialog_Unit,
  HITEMS_TMS_CONST,
  HITEMS_TMS_COMMON,
  DataModule_Unit;

{$R *.dfm}

procedure Create_testInfo_Frm(aPlanNo:String);
begin
  testInfo_Frm := TtestInfo_Frm.Create(nil);
  try
    with testInfo_Frm do
    begin
      et_planNo.Text := aPlanNo;
      Get_BaseInfo(et_planNo.Text);
      Get_Revision(et_planNo.Text);

      ShowModal;


    end;
  finally
    FreeAndNil(testInfo_Frm);
  end;
end;

{ TtestInfo_Frm }

procedure TtestInfo_Frm.btn_RegClick(Sender: TObject);
var
  LCause : String;
begin
  if StrToInt(et_testNo5.Text) = 1 then
  begin
    LCause := '최초등록';
  end else
    LCause := Create_resultDialog_Frm('변경사유입력');

  if LCause <> '' then
  begin
    DM1.OraTransaction1.StartTransaction;
    try
      Insert_TestInfo(LCause);
      Management_Attfiles;
      DM1.OraTransaction1.Commit;
      ShowMessage(btn_Reg.Caption+'성공!');

      Get_BaseInfo(et_planNo.Text);
      Get_Revision(et_planNo.Text);

    except
      DM1.OraTransaction1.Rollback;
      ShowMessage(btn_Reg.Caption+'실패!');
    end;
  end else
    ShowMessage('사유없이 등록할 수 없습니다!');
end;

procedure TtestInfo_Frm.AdvGlowButton2Click(Sender: TObject);
begin

  Get_BaseInfo(et_planNo.Text);

  et_testPurpose.Clear;
  et_reqDept.Clear;
  et_reqIncharge.Clear;
  et_method.Clear;

end;

procedure TtestInfo_Frm.AeroButton2Click(Sender: TObject);
begin

  Close;

end;

procedure TtestInfo_Frm.Button10Click(Sender: TObject);
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

procedure TtestInfo_Frm.Button2Click(Sender: TObject);
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

procedure TtestInfo_Frm.cb_testLocationDropDown(Sender: TObject);
begin
  with cb_testLocation.Items do
  begin
    BeginUpdate;
    try
      Clear;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM HITEMS_LOCATION_CODE ' +
                'WHERE CODE_LV = 0 ' +
                'ORDER BY SEQ_NO ');
        Open;

        Add('');
        while not eof do
        begin
          Add(FieldByName('CODE_NAME').AsString);
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TtestInfo_Frm.cb_testLocationSelect(Sender: TObject);
begin
  if cb_testLocation.ItemIndex <> 0 then
  begin
    with DM1.OraQuery1 do
    begin
      RecNo := cb_testLocation.ItemIndex;
      et_testNo2.Text := FieldByName('CODE').AsString;
    end;
  end else
    et_testNo2.Clear;
end;

procedure TtestInfo_Frm.FileGridDropFiles(aGrid: TNextGrid;
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

procedure TtestInfo_Frm.FileGridWindowProc(var msg: TMessage);
begin
  if msg.msg = WM_DROPFILES then
    FileGridDropFiles(fileGrid,TWMDROPFILES(Msg))
  else
    ForiginFileGridWindowProc(Msg);
end;

procedure TtestInfo_Frm.FormCreate(Sender: TObject);
begin
  et_testNo3.Text := FormatDateTime('yyyyMM',today);

  ForiginFileGridWindowProc := fileGrid.WindowProc;
  fileGrid.WindowProc := FileGridWindowProc;

  DragAcceptFiles(fileGrid.Handle,True);
end;

procedure TtestInfo_Frm.Get_BaseInfo(aPlanNo: String);
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
      SQL.Add('SELECT * FROM ' +
              '( ' +
              '   SELECT ' +
              '     A.PLAN_NO, PRN,TASK_NO, PLAN_CODE, PLAN_TYPE, PLAN_NAME, ' +
              '     PLAN_OUTLINE, ENG_MODEL, ENG_TYPE, ENG_PROJNO, PLAN_START, ' +
              '     PLAN_END, PLAN_MH, PLAN_PROGRESS, PLAN_DRAFTER, ' +
              '     PLAN_INDATE, PLAN_MOD_CAUSE ' +
              '   FROM ' +
              '   ( ' +
              '       SELECT PLAN_NO, MAX(PLAN_REV_NO) PRN FROM TMS_PLAN ' +
              '       WHERE PLAN_NO LIKE :PLAN_NO ' +
              '       GROUP BY PLAN_NO ' +
              '   ) A JOIN ' +
              '   ( ' +
              '       SELECT A.*, B.CODE_NAME FROM TMS_PLAN A, HITEMS_CODE_GROUP B ' +
              '       WHERE A.PLAN_CODE = B.GRP_NO ' +
              '   ) B ' +
              '   ON A.PLAN_NO = B.PLAN_NO ' +
              '   AND A.PRN = B.PLAN_REV_NO ' +
              ') A JOIN ' +
              '( ' +
              '   SELECT PROJNO, LOC_CODE, CODE_NAME FROM HIMSEN_INFO A, HITEMS_LOCATION_CODE B ' +
              '   WHERE A.LOC_CODE LIKE B.CODE ' +
              ') B ' +
              'ON A.ENG_PROJNO LIKE B.PROJNO ');

      ParamByName('PLAN_NO').AsString := aPlanNo;
      Open;

      if RecordCount <> 0 then
      begin
        et_testNo2.Text  := FieldByName('LOC_CODE').AsString;
        cb_testLocation.Items.Clear;
        cb_testLocation.Items.Add(FieldByName('CODE_NAME').AsString);
        cb_testLocation.ItemIndex := 0;

        et_testName.Text := FieldByName('PLAN_NAME').AsString;
        et_engType.Text  := FieldByName('ENG_TYPE').AsString;
        et_testType.Text := FieldByName('CODE_NAME').AsString;
        et_start.Text    := FormatDateTime('yyyy-MM-dd',FieldByName('PLAN_START').AsDateTime);
        et_end.Text      := FormatDateTime('yyyy-MM-dd',FieldByName('PLAN_END').AsDateTime);

        Get_InchargeOfTest(FieldByName('PLAN_NO').AsString,
                           FieldByName('PRN').AsInteger);


        Set_TestNo;
        Get_Attfiles(fileGrid,et_testNo1.Text +
                              et_testNo2.Text +
                              et_testNo3.Text +
                              et_testNo4.Text);

      end;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure TtestInfo_Frm.Get_InchargeOfTest(aPlanNo: String; aRevNo: Integer);
var
  OraQuery : TOraQuery;
  lrow : Integer;
  str : String;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.OraSession1;
    with empGrid do
    begin
      BeginUpdate;
      try
        ClearRows;
        with OraQuery do
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT * FROM TMS_PLAN_INCHARGE ' +
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

procedure TtestInfo_Frm.Get_Revision(aPlanNo: String);
begin
  with grid_Test do
  begin
    BeginUpdate;
    try
      ClearRows;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM TMS_TEST_INFO ' +
                'WHERE PLAN_NO LIKE :param1 ' +
                'ORDER BY TEST_REV_NO ');
        ParamByName('param1').AsString := aPlanNo;
        Open;

        if RecordCount <> 0 then
        begin
          while not eof do
          begin
            AddRow;
            Cell[0,LastAddedRow].AsInteger := FieldByName('TEST_REV_NO').AsInteger;
            Cell[1,LastAddedRow].AsString  := FormatDateTime('yyyy-MM-dd',FieldByName('REG_DATE').AsDateTime);
            Cell[2,LastAddedRow].AsString  := Get_UserName(FieldByName('REG_ID').AsString);
            Cell[3,LastAddedRow].AsString  := FieldByName('PLAN_NO').AsString;
            Cell[4,LastAddedRow].AsString  := FieldByName('TEST_NO').AsString;
            Cell[5,LastAddedRow].AsString  := FieldByName('TEST_PURPOSE').AsString;
            Cell[6,LastAddedRow].AsString  := FieldByName('TEST_REQ_DEPT').AsString;
            Cell[7,LastAddedRow].AsString  := FieldByName('TEST_REQ_EMP').AsString;

            Next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TtestInfo_Frm.grid_TestCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  if ARow = -1 then
    Exit;

  with grid_Test do
  begin
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM TMS_TEST_INFO ' +
              'WHERE TEST_NO LIKE :param1 ' +
              'AND TEST_REV_NO = :param2 ');
      ParamByName('param1').AsString := Cells[4,ARow];
      ParamByName('param2').AsInteger := Cell[0,ARow].AsInteger;
      Open;

      et_testPurpose.Text := FieldByName('TEST_PURPOSE').AsString;
      et_reqDept.Text     := FieldByName('TEST_REQ_DEPT').AsString;
      et_reqIncharge.Text := FieldByName('TEST_REQ_EMP').AsString;
      et_method.Text      := FieldByName('TEST_METHOD').AsString;

    end;
  end;
end;

procedure TtestInfo_Frm.Insert_TestInfo(aCause:String);
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('INSERT INTO TMS_TEST_INFO ( ' +
            ' PLAN_NO, TEST_NO, TEST_REV_NO, TEST_PURPOSE, TEST_REQ_DEPT, ' +
            ' TEST_METHOD, TEST_REQ_EMP, REG_DATE, REG_ID, MOD_CAUSE ) ' +
            'VALUES ( ' +
            ' :PLAN_NO, :TEST_NO, :TEST_REV_NO, :TEST_PURPOSE, :TEST_REQ_DEPT, ' +
            ' :TEST_METHOD, :TEST_REQ_EMP, :REG_DATE, :REG_ID, :MOD_CAUSE ) ');

    ParamByName('PLAN_NO').AsString       := et_planNo.Text;
    ParamByName('TEST_NO').AsString       := et_testNo1.Text +
                                             et_testNo2.Text +
                                             et_testNo3.Text +
                                             et_testNo4.Text;

    ParamByName('TEST_REV_NO').AsInteger  := StrToInt(et_testNo5.Text);
    ParamByName('TEST_PURPOSE').AsString  := et_testPurpose.Text;
    ParamByName('TEST_REQ_DEPT').AsString := et_reqDept.Text;
    ParamByName('TEST_METHOD').AsString   := et_method.Text;

    ParamByName('TEST_REQ_EMP').AsString  := et_reqIncharge.Text;
    ParamByName('REG_DATE').AsDateTime    := Now;
    ParamByName('REG_ID').AsString        := CurrentUsers;
    ParamByName('MOD_CAUSE').AsString     := aCause;

    ExecSQL;

  end;
end;

procedure TtestInfo_Frm.Management_Attfiles;
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
          aOwner       := et_testNo1.Text +
                          et_testNo2.Text +
                          et_testNo3.Text +
                          et_testNo4.Text;

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

procedure TtestInfo_Frm.mGridDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  DragAcceptFiles(handle,true);
  Accept := True;
end;

procedure TtestInfo_Frm.N1Click(Sender: TObject);
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
      SQL.Add('select * from TMS_ATTFILES ' +
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

procedure TtestInfo_Frm.N2Click(Sender: TObject);
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
        SQL.Add('select * from TMS_ATTFILES ' +
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


procedure TtestInfo_Frm.Set_TestNo;
var
  LTestNo:String;
  i : Integer;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT TEST_NO, MAX(TEST_REV_NO) TRV FROM TMS_TEST_INFO ' +
            'WHERE PLAN_NO LIKE :PLAN_NO ' +
            'GROUP BY TEST_NO ' +
            'ORDER BY TRV ');
    ParamByName('PLAN_NO').AsString := et_planNo.Text;
    Open;

    if RecordCount <> 0 then
    begin
      LTestNo := FieldByName('TEST_NO').AsString;
      et_testNo2.Text := Copy(LTestNo,2,2);
      et_testNo3.Text := Copy(LTestNo,4,6);
      et_testNo4.Text := Copy(LTestNo,10,3);
      et_testNo5.Text := FormatFloat('00',FieldByName('TRV').AsInteger+1);
    end else
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT MAX(TEST_NO) TEST_NO FROM TMS_TEST_INFO ' +
              'WHERE TEST_NO LIKE :TEST_NO ' +
              'ORDER BY TEST_NO ');
      ParamByName('TEST_NO').AsString := '%'+et_testNo2.Text+
                                             FormatDateTime('yyyyMM',today)+'%';
      Open;

      if Not FieldByName('TEST_NO').IsNull then
      begin
        LTestNo := FieldByName('TEST_NO').AsString;

        et_testNo2.Text := Copy(LTestNo,2,2);
        et_testNo3.Text := Copy(LTestNo,4,6);
        et_testNo4.Text := Copy(LTestNo,10,3);
        i := StrToInt(et_testNo4.Text) + 1;
        et_testNo4.Text := FormatFloat('000',i);
        et_testNo5.Text := '01';
      end else
      begin
        et_testNo3.Text := FormatDateTime('yyyyMM',today);
        et_testNo4.Text := '001';
        et_testNo5.Text := '01';
      end;
    end;
  end;
end;

end.
