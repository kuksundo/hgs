unit testRequest_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.StdCtrls, AeroButtons, JvExControls, JvLabel, CurvyControls,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, Vcl.ComCtrls, AdvDateTimePicker, Vcl.ImgList,
  Winapi.ShellApi, Ora, DB, DateUtils, DATA.DBXJSON, Vcl.Menus, AdvMenus,
  HiTEMSConst_Unit, TestReqCollect, JvImageList, AdvEdit, AdvEdBtn,
  PlannerDatePicker, pjhPlannerDatePicker;

type
  TtestRequest_Frm = class(TForm)
    Panel8: TPanel;
    Image1: TImage;
    CurvyPanel1: TCurvyPanel;
    JvLabel11: TJvLabel;
    btn_Close: TAeroButton;
    btn_Request: TAeroButton;
    imagelist24x24: TImageList;
    ImageList32x32: TImageList;
    ImageList16x16: TImageList;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    JvLabel7: TJvLabel;
    et_ReqNo: TEdit;
    OpenDialog1: TOpenDialog;
    btn_Del: TAeroButton;
    grid_part: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn2: TNxTextColumn;
    NxNumberColumn1: TNxNumberColumn;
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
    FileListCombo: TNxComboBoxColumn;
    AdvPopupMenu1: TAdvPopupMenu;
    mi_fileOpen: TMenuItem;
    mi_fileSave: TMenuItem;
    SaveDialog1: TSaveDialog;
    btnImsi: TAeroButton;
    JvImageList1: TJvImageList;
    Panel1: TPanel;
    JvLabel4: TJvLabel;
    JvLabel6: TJvLabel;
    JvLabel3: TJvLabel;
    JvLabel5: TJvLabel;
    et_EngLoc: TEdit;
    cb_EngType: TComboBox;
    et_reqDept: TEdit;
    et_reqIncharge: TEdit;
    JvLabel1: TJvLabel;
    et_testName: TEdit;
    JvLabel2: TJvLabel;
    et_testPurpose: TEdit;
    JvLabel10: TJvLabel;
    JvLabel15: TJvLabel;
    Panel2: TPanel;
    Panel3: TPanel;
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
    Panel4: TPanel;
    btn_delFile: TButton;
    btn_addFile: TButton;
    Panel5: TPanel;
    btn_addPart: TButton;
    dt_begin: TpjhPlannerDatePicker;
    dt_end: TpjhPlannerDatePicker;
    procedure btn_CloseClick(Sender: TObject);
    procedure btn_RequestClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_addPartClick(Sender: TObject);
    procedure cb_EngTypeDropDown(Sender: TObject);
    procedure cb_EngTypeSelect(Sender: TObject);
    procedure fileGridDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure btn_addFileClick(Sender: TObject);
    procedure btn_delFileClick(Sender: TObject);
    procedure dt_beginChange(Sender: TObject);
    procedure grid_partSelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mi_fileOpenClick(Sender: TObject);
    procedure mi_fileSaveClick(Sender: TObject);
    procedure btn_DelClick(Sender: TObject);
    procedure btnImsiClick(Sender: TObject);
  private
    FPlanNo,
    FParentReqNo: String;
    ForiginFileGridWindowProc: TWndMethod;
    procedure FileGridWindowProc(var msg: TMessage);
    procedure FileGridDropFiles(aGrid: TNextGrid; var msg: TWMDropFiles);
  public
    FSAFList: TStringList;//FileName, TSerialAttachFileInfo 정보 저장함
    FReqType: string;
    FTestReqList: TTestReqList;
    FReqNo: string;

    procedure Get_Attfiles(aGrid: TNextGrid; aOwner, aReqType: String);
    procedure Management_Attfiles;
    procedure Insert_Attfiles(aOwner, aRegNo, aFileName, aFileSize,
      aFilePath: String);
    procedure Delete_Attfile(aRegNo: String); // 파일 하나씩 개별삭제
    function Get_Test_Seq_Number(aType, aLocCode, aMonth: String): Integer;
    procedure Insert_TEST_REQUEST(ARequestType: string);
    procedure Insert_TEST_REQUEST_IMSI;
    procedure Get_Choose_List(aIdx:Integer;aPartNo: String; aTestPartItem:TTestPartItem);

    procedure Insert_Part_Attfiles(aReqNo,aPartNo,aSerial:String;aRow:Integer);

    procedure Update_TEST_REQUEST(AReqNo: string = '');
    procedure Update_TEST_REQUEST_IMSI;
    procedure Update_Change_Part_2_Request;
    procedure Update_Part_Request(AUpdated: Boolean);

    procedure Get_Request_Resource(aReqNo: String; aReqType: string='');
    procedure Get_Request_Resource_P(aPlanNo:String);

    procedure Test_Request_Process(ARequestType: string);
    procedure Insert_Test_Receive_Info(aReqNo,aPlanNo,aStatus,aComment:String);

    procedure Delete_Test_Req_Process(aReqType: string);
    function IsExistRequestIMSI(aReqNo: String): Boolean;

  end;

var
  testRequest_Frm: TtestRequest_Frm;

function Self_New_test_Request_Frm(aPlanNo:String; aReqNo: String = ''):Boolean;
function Try_test_Request_Frm(aReqNo: String): Boolean;
function New_test_Request_Frm(aReqNo: String; aReqType: string=''): Boolean;
procedure Preview_Request_Frm(aReqNo: String; aReqType: string='');

implementation

uses
{$IFDEF T_REQ}
  requestMain_Unit,
{$ELSE}
  HiTEMS_TMS_CONST,
  HiTEMS_TMS_COMMON,
{$ENDIF}
  newPartRequest_Unit,
  DataModule_Unit;

{$R *.dfm}

function Self_New_test_Request_Frm(aPlanNo:String; aReqNo: String):Boolean;
begin
  Result := False;
  testRequest_Frm := TtestRequest_Frm.Create(nil);
  try
    with testRequest_Frm do
    begin
      if aReqNo <> '' then
      begin
        btnImsi.Visible := False;
        btn_Del.Visible := False;

        et_ReqNo.Text := aReqNo;
        FReqNo := aReqNo;
        btn_Request.Caption := '수정';
        Get_Request_Resource(et_ReqNo.Text);
      end
      else
      begin
        FPlanNo := aPlanNo;

        btn_Del.Visible := False;
        btnImsi.Visible := False;
        btn_Request.Caption := '확인';

        Get_Request_Resource_P(aPlanNo);
      end;

      ShowModal;

      if ModalResult = mrOk then
        Result := True;
    end;
  finally
    FreeAndNil(testRequest_Frm);
  end;
end;

function Try_test_Request_Frm(aReqNo: String): Boolean;
begin
  Result := False;
  testRequest_Frm := TtestRequest_Frm.Create(nil);
  try
    with testRequest_Frm do
    begin
      FParentReqNo := aReqNo;

      btn_Request.Caption := '재요청';
      btn_Del.Visible := True;
      Get_Request_Resource(FParentReqNo);

      ShowModal;

      if ModalResult = mrOk then
        Result := True;

    end;
  finally
    FreeAndNil(testRequest_Frm);
  end;
end;

function New_test_Request_Frm(aReqNo: String; aReqType: string=''): Boolean;
begin
  Result := False;

  testRequest_Frm := TtestRequest_Frm.Create(nil);
  try
    with testRequest_Frm do
    begin
      FReqType := aReqType;
      btnImsi.Visible := (aReqType = '임시') or (aReqType = '');

      if aReqNo = '' then
      begin
        btn_Request.Caption := '요청';
        btn_Del.Visible := False;
        et_reqDept.Text := DM1.FUSerInfo.DeptName;
        et_reqIncharge.Text := DM1.FUSerInfo.UserName;
      end
      else
      begin
        btn_Del.Visible := True;
        et_ReqNo.Text := aReqNo;
        FReqNo := aReqNo;

        if aReqType = '임시' then
        begin
          btn_Request.Caption := '요청';
          Get_Request_Resource(et_ReqNo.Text, '임시');
        end
        else
        begin
          btn_Request.Caption := '수정';
          Get_Request_Resource(et_ReqNo.Text);
        end;
      end;

      ShowModal;

      if ModalResult = mrOk then
      begin
        Result := True;
      end;

    end;
  finally
    FreeAndNil(testRequest_Frm);
  end;
end;

procedure Preview_Request_Frm(aReqNo: String; aReqType: string='');
begin
  testRequest_Frm := TtestRequest_Frm.Create(nil);
  try
    with testRequest_Frm do
    begin
      Caption := '시험요청>상세보기';
      JvLabel11.Caption := '요청 상세보기';

      btn_Del.Visible := False;
      btn_Request.Visible := False;
      btn_delFile.Visible := False;
      btn_addFile.Visible := False;
      btnImsi.Visible := False;
      btn_addPart.Caption := '상세보기';

      cb_EngType.Enabled := False;
      et_testName.ReadOnly := True;
      et_testPurpose.ReadOnly := True;
      dt_begin.Enabled := False;
      dt_end.Enabled := False;
      et_method.ReadOnly := True;

      et_ReqNo.Text := aReqNo;
      FReqType := aReqType;

      if aReqType = '임시' then
      begin
        Get_Request_Resource(et_ReqNo.Text, '임시');
      end
      else
      begin
        Get_Request_Resource(et_ReqNo.Text);
      end;

      ShowModal;

    end;
  finally
    FreeAndNil(testRequest_Frm);
  end;
end;

procedure TtestRequest_Frm.btn_RequestClick(Sender: TObject);
begin
  Test_Request_Process(btn_Request.Caption);
end;

procedure TtestRequest_Frm.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TtestRequest_Frm.btn_DelClick(Sender: TObject);
begin
  Delete_Test_Req_Process(FReqType);
end;

procedure TtestRequest_Frm.btn_delFileClick(Sender: TObject);
var
  li: Integer;
begin
  with fileGrid do
  begin
    if SelectedRow > -1 then
    begin
      if not(Cells[3, SelectedRow] = '') then
        DeleteRow(SelectedRow)
      else
        for li := 0 to Columns.Count - 1 do
          Cell[li, SelectedRow].TextColor := clRed;

    end;
  end;
end;

procedure TtestRequest_Frm.btnImsiClick(Sender: TObject);
begin
  Test_Request_Process('임시'); //임시저장
end;

procedure TtestRequest_Frm.btn_addFileClick(Sender: TObject);
var
  li, le: Integer;
  lms: TMemoryStream;
  lfilename: String;
  lExt: String;
  lSize: int64;
  lResult: Boolean;

begin
  if OpenDialog1.Execute then
  begin
    with OpenDialog1 do
    begin
      for li := 0 to Files.Count - 1 do
      begin
        lfilename := ExtractFileName(Files.Strings[li]);
        with fileGrid do
        begin
          BeginUpdate;
          try
            lResult := True;
            for le := 0 to RowCount - 1 do
            begin
              if lfilename = Cells[1, le] then
              begin
                raise Exception.Create(Format('%s : 같은 이름의 파일이 등록되어 있습니다.',
                  [lfilename]));
                lResult := False;
                Break;
              end;
            end;

            if lResult = True then
            begin
              lms := TMemoryStream.Create;
              try
                lms.LoadFromFile(Files.Strings[li]);
                lSize := lms.Size;

                lExt := ExtractFileExt(lfilename);
                Delete(lExt, 1, 1);
                AddRow;
                Cells[1, RowCount - 1] := lfilename;
                Cells[2, RowCount - 1] := IntToStr(lSize);
                Cells[3, RowCount - 1] := Files.Strings[li];

                for le := 0 to Columns.Count - 1 do
                  Cell[le, RowCount - 1].TextColor := clBlue;
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

procedure TtestRequest_Frm.btn_addPartClick(Sender: TObject);
var
  i,j: Integer;
  LEngType : String;
  LJObj : TJSONObject;
begin
  if cb_EngType.Text = '' then
  begin
    ShowMessage('먼저 엔진타입을 선택하여 주십시오!');
    cb_EngType.SetFocus;
    Exit;
  end;

  with grid_part do
  begin
    BeginUpdate;
    try
      LEngType := Copy(cb_EngType.Text,POS('-',cb_EngType.Text)+1, Length(cb_EngType.Text) - POS('-',cb_EngType.Text));

      if btn_Request.Visible then
        Create_newPartRequest_Frm(LEngType, et_ReqNo.Text, grid_part, FTestReqList)
      else
        Preview_newPartRequest_Frm(LEngType, et_ReqNo.Text, grid_part, FTestReqList);

    finally
      EndUpdate;
    end;
  end;
end;

procedure TtestRequest_Frm.cb_EngTypeDropDown(Sender: TObject);
begin
  with cb_EngType.Items do
  begin
    BeginUpdate;
    try
      Clear;

      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT  ' +
                '   TO_NUMBER(SUBSTR(ENGTYPE, 1, INSTR(ENGTYPE, ''H'') - 1)) CYLNUM, ' +
                '   PROJNO, ' +
                '   ENGTYPE, ' +
                '   LOC_CODE, ' +
                '   (SELECT CODE_NAME FROM HITEMS_LOCATION_CODE WHERE CODE LIKE A.LOC_CODE) LOC_CODE_NAME ' +
                'FROM HIMSEN_INFO A ' + 'WHERE STATUS = 0 ' +
                'ORDER BY CYLNUM, LOC_CODE, PROJNO ');
        Open;

        Add('');
        while not eof do
        begin
          Add(FieldByName('PROJNO').AsString + '-' + FieldByName('ENGTYPE')
            .AsString);
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TtestRequest_Frm.cb_EngTypeSelect(Sender: TObject);
begin
  with DM1.OraQuery1 do
  begin
    if cb_EngType.ItemIndex <> 0 then
    begin
      RecNo := cb_EngType.ItemIndex;
      et_EngLoc.Text := FieldByName('LOC_CODE_NAME').AsString;
      et_EngLoc.Hint := FieldByName('LOC_CODE').AsString;
      cb_EngType.Hint := FieldByName('PROJNO').AsString;
    end
    else
    begin
      et_EngLoc.Clear;
      et_EngLoc.Hint := '';
      cb_EngType.Hint := '';
    end;
  end;
end;

procedure TtestRequest_Frm.Delete_Attfile(aRegNo: String);
var
  OraQuery: TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := DM1.OraSession1;
  try
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('DELETE FROM TMS_ATTFILES ' + 'where RegNo = :param1 ');
      ParamByName('param1').AsString := aRegNo;
      ExecSQL;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure TtestRequest_Frm.Delete_Test_Req_Process(aReqType: string);
begin
  if MessageDlg('시험명 : ' + et_testName.Text + #10#13 +
    '삭제 하시겠습니까? 삭제된 정보는 복구할 수 없습니다.', mtConfirmation, [mbYes, mbNo], 0) = mrYes
  then
  begin
    with DM1.OraTransaction1 do
    begin
      StartTransaction;
      try
        with DM1.OraQuery1 do
        begin
          // 첨부파일 삭제
          Close;
          SQL.Clear;
          SQL.Add('DELETE FROM TMS_ATTFILES ' + 'WHERE OWNER LIKE :param1 ');
          ParamByName('param1').AsString := et_ReqNo.Text;
          ExecSQL;

          // 시리얼 첨부파일 삭제
          Close;
          SQL.Clear;
          SQL.Add('DELETE FROM TMS_TEST_PART_ATTFILES ' + 'WHERE REQ_NO LIKE :param1 ');
          ParamByName('param1').AsString := et_ReqNo.Text;
          ExecSQL;

          // 부품 삭제
          Close;
          SQL.Clear;
          SQL.Add('DELETE FROM TMS_TEST_REQUEST_PART ' + 'WHERE REQ_NO = :param1 ');
          ParamByName('param1').AsString := et_ReqNo.Text;
          ExecSQL;

          // 요청 삭제
          Close;
          SQL.Clear;

          if aReqType = '임시' then
            SQL.Add('DELETE FROM TMS_TEST_REQUEST_IMSI ' +
              'WHERE REQ_NO LIKE :param1 ')
          else
            SQL.Add('DELETE FROM TMS_TEST_REQUEST ' +
              'WHERE REQ_NO LIKE :param1 ');

          ParamByName('param1').AsString := et_ReqNo.Text;
          ExecSQL;
        end;

        Commit;
        ShowMessage('삭제완료!');
        ModalResult := mrOk;
      except
        Rollback;
      end;
    end;
  end;
end;

procedure TtestRequest_Frm.dt_beginChange(Sender: TObject);
begin
  if dt_begin.Date > dt_end.Date then
  begin
    dt_begin.SetFocus;
    raise Exception.Create('시작일이 종료일보다 클 수 없습니다!');
  end;
end;

procedure TtestRequest_Frm.fileGridDragOver(Sender, Source: TObject;
  X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  DragAcceptFiles(handle, True);
  Accept := True;
end;

procedure TtestRequest_Frm.FileGridDropFiles(aGrid: TNextGrid;
  var msg: TWMDropFiles);
var
  i, j, c, numFiles, NameLength: Integer;
  hDrop: THandle;
  tmpFile: array [0 .. MAX_PATH] of char;
  FileName, str, lExt: String;
  lms: TMemoryStream;
  lSize: int64;
  lResult: Boolean;
begin
  with aGrid do
  begin
    BeginUpdate;
    try
      hDrop := msg.Drop;
      try
        numFiles := DragQueryFile(msg.Drop, $FFFFFFFF, nil, 0);
        for i := 0 to numFiles - 1 do
        begin
          NameLength := DragQueryFile(hDrop, i, nil, 0);

          DragQueryFile(hDrop, i, tmpFile, NameLength + 1);

          FileName := StrPas(tmpFile);

          if FileExists(FileName) then
          begin
            str := ExtractFileName(FileName);

            lResult := True;
            for j := 0 to RowCount - 1 do
              if SameText(str, Cells[1, j]) then
              begin
                lResult := False;
                Break;
              end;

            if lResult then
            begin
              lms := TMemoryStream.Create;
              try
                lms.LoadFromFile(FileName);
                lSize := lms.Size;

                lExt := ExtractFileExt(str);
                Delete(lExt, 1, 1);
                AddRow;
                Cells[1, LastAddedRow] := str;
                Cells[2, LastAddedRow] := IntToStr(lSize);
                Cells[3, LastAddedRow] := FileName;

                for c := 0 to Columns.Count - 1 do
                  Cell[c, LastAddedRow].TextColor := clBlue;
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

procedure TtestRequest_Frm.FileGridWindowProc(var msg: TMessage);
begin
  if msg.msg = WM_DROPFILES then
    FileGridDropFiles(fileGrid, TWMDropFiles(msg))
  else
    ForiginFileGridWindowProc(msg);
end;

procedure TtestRequest_Frm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i : Integer;
begin
  with grid_part do
  begin
    for i := 0 to RowCount-1 do
    begin
      if Assigned(grid_part.Row[i].Data) then
      begin
        TStringList(grid_part.Row[i].Data).Free;
        grid_part.Row[i].Data := nil;
      end;
    end;
  end;

  FreeAndNil(FTestReqList);
end;

procedure TtestRequest_Frm.FormCreate(Sender: TObject);
begin
  // Drag & Drop Method
  ForiginFileGridWindowProc := fileGrid.WindowProc;
  fileGrid.WindowProc := FileGridWindowProc;

  DragAcceptFiles(fileGrid.handle, True);
  // ============================

  PageControl1.ActivePageIndex := 0;
  dt_begin.Date := Today;
  dt_end.Date := dt_begin.Date;

  FTestReqList := TTestReqList.Create(self);
  FTestReqList.IsFetchSerialFileFromDB := False;
end;

procedure TtestRequest_Frm.Get_Attfiles(aGrid: TNextGrid; aOwner, aReqType: String);
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

        if aReqType = '임시' then
          SQL.Add('SELECT FILENAME, FILESIZE, REGNO, OWNER from TMS_ATTFILES ' +
            'WHERE OWNER IN ( ' + '   SELECT REQ_NO FROM TMS_TEST_REQUEST_IMSI  ' +
            '   START WITH REQ_NO LIKE :param1 ' +
            '   CONNECT BY PRIOR PARENT_NO = REQ_NO ) ')
        else
          SQL.Add('SELECT FILENAME, FILESIZE, REGNO, OWNER from TMS_ATTFILES ' +
            'WHERE OWNER IN ( ' + '   SELECT REQ_NO FROM TMS_TEST_REQUEST  ' +
            '   START WITH REQ_NO LIKE :param1 ' +
            '   CONNECT BY PRIOR PARENT_NO = REQ_NO ) ');

        ParamByName('param1').AsString := aOwner;
        Open;

        while not eof do
        begin
          AddRow;
          Cells[1, RowCount - 1] := FieldByName('FILENAME').AsString;
          Cells[2, RowCount - 1] := FieldByName('FILESIZE').AsString;
          Cells[4, RowCount - 1] := FieldByName('REGNO').AsString;
          Cells[5, RowCount - 1] := FieldByName('OWNER').AsString;
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TtestRequest_Frm.Get_Choose_List(aIdx:Integer;aPartNo: String; aTestPartItem:TTestPartItem);
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
          SQL.Add('SELECT * FROM HIMSEN_MS_PART  ' +
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

            with aTestPartItem do
            begin
              MS_NO := FieldByName('MS_NO').AsString;
              PARTNAME := FieldByName('NAME').AsString;
              MAKER := FieldByName('MAKER').AsString;
              PARTTYPE := FieldByName('TYPE').AsString;
              PARTSPEC := FieldByName('STANDARD').AsString;
            end;
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

procedure TtestRequest_Frm.Get_Request_Resource(aReqNo: String; aReqType: string='');
var
  i : Integer;
  LTestPartItem: TTestPartItem;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    if aReqType = '임시' then
      SQL.Add('SELECT * FROM ' + '( ' + '   SELECT ' + '     A.*, ' +
        '     B.ENGTYPE, LOC_CODE, ' +
        '     (SELECT NAME_KOR FROM HITEMS_USER WHERE USERID LIKE A.REQ_ID) REQ_ID_NAME, '
        + '     (SELECT DEPT_NAME FROM HITEMS_DEPT WHERE DEPT_CD LIKE A.REQ_DEPT) REQ_DEPT_NAME, '
        + '     (SELECT CODE_NAME FROM HITEMS_LOCATION_CODE WHERE CODE LIKE B.LOC_CODE) LOC_CODE_NAME '
        + '   FROM TMS_TEST_REQUEST_IMSI A LEFT OUTER JOIN ( ' +
        '     SELECT PROJNO, ENGTYPE, LOC_CODE FROM HIMSEN_INFO ' +
        '   ) B ON A.TEST_ENGINE = B.PROJNO ' + ') WHERE REQ_NO = :param1 ')
    else
      SQL.Add('SELECT * FROM ' + '( ' + '   SELECT ' + '     A.*, ' +
        '     B.ENGTYPE, LOC_CODE, ' +
        '     (SELECT NAME_KOR FROM HITEMS_USER WHERE USERID LIKE A.REQ_ID) REQ_ID_NAME, '
        + '     (SELECT DEPT_NAME FROM HITEMS_DEPT WHERE DEPT_CD LIKE A.REQ_DEPT) REQ_DEPT_NAME, '
        + '     (SELECT CODE_NAME FROM HITEMS_LOCATION_CODE WHERE CODE LIKE B.LOC_CODE) LOC_CODE_NAME '
        + '   FROM TMS_TEST_REQUEST A LEFT OUTER JOIN ( ' +
        '     SELECT PROJNO, ENGTYPE, LOC_CODE FROM HIMSEN_INFO ' +
        '   ) B ON A.TEST_ENGINE = B.PROJNO ' + ') WHERE REQ_NO = :param1 ');

    ParamByName('param1').AsString := aReqNo;
    Open;

    if RecordCount <> 0 then
    begin
      et_reqDept.Text := FieldByName('REQ_DEPT_NAME').AsString;
      et_reqDept.Hint := FieldByName('REQ_DEPT').AsString;

      cb_EngType.Items.Clear;
      cb_EngType.Items.Add(FieldByName('TEST_ENGINE').AsString + '-' +
        FieldByName('ENGTYPE').AsString);
      cb_EngType.ItemIndex := 0;
      cb_EngType.Hint := FieldByName('TEST_ENGINE').AsString;

      et_EngLoc.Text := FieldByName('LOC_CODE_NAME').AsString;
      et_EngLoc.Hint := FieldByName('LOC_CODE').AsString;

      et_reqIncharge.Text := FieldByName('REQ_ID_NAME').AsString;
      et_reqIncharge.Hint := FieldByName('REQ_ID').AsString;

      et_testName.Text := FieldByName('TEST_NAME').AsString;
      et_testPurpose.Text := FieldByName('TEST_PURPOSE').AsString;
      dt_begin.Date := FieldByName('TEST_BEGIN').AsDateTime;
      dt_end.Date := FieldByName('TEST_END').AsDateTime;
      et_method.Text := FieldByName('TEST_METHOD').AsString;

      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM TMS_TEST_REQUEST_PART ' +
        'WHERE REQ_NO = :param1 ');
      ParamByName('param1').AsString := aReqNo;
      Open;
      First;

{      DM1.OraQuery2.Close;
      DM1.OraQuery2.SQL.Clear;
      DM1.OraQuery2.SQL.Add('SELECT REQ_NO, PART_NO, SERIAL, FILENAME FROM TMS_TEST_PART_ATTFILES ' +
        'WHERE REQ_NO = :param1 ');
      DM1.OraQuery2.ParamByName('param1').AsString := aReqNo;
      DM1.OraQuery2.Open;
}
      FTestReqList.TestPartCollect.Clear;
      FTestReqList.TestPartSerialCollect.Clear;
      FTestReqList.TestPartSerialFileCollect.Clear;

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

            LTestPartItem := FTestReqList.TestPartCollect.Add;

            //Row[i].Data := LTestPartItem;

            with LTestPartItem do
            begin
              RowNo := i;
              ID := now;
              FileLocation := flDB;
              Req_No := aReqNo;
              PART_NO := FieldByName('PART_NO').AsString;
              SEQ_NO := FieldByName('SEQ_NO').AsString;
              STATUS := FieldByName('STATUS').AsString;
            end;

            with FTestReqList.TestPartSerialCollect.Add do
            begin
              ID := LTestPartItem.ID;
              BANK := FieldByName('BANK').AsString;
              CYL_NO := FieldByName('CYLNUM').AsString;
              EXH_INTAKE := FieldByName('CYCLE').AsString;
              EXH_CAMSIDE := FieldByName('SIDE').AsString;
              SERIAL_NO := FieldByName('SERIAL').AsString;
            end;

            Get_Choose_List(i, Cells[1,i],LTestPartItem);

            Next;
          end;
        finally
          EndUpdate;
        end;
      end;

      Get_Attfiles(fileGrid, aReqNo, aReqType);

    end;
  end;
end;

procedure TtestRequest_Frm.Get_Request_Resource_P(aPlanNo: String);
begin
{$IFNDEF T_REQ}
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT  ' +
            '   B.*, ' +
            '   ( ' +
            '     SELECT LOC_CODE FROM HIMSEN_INFO ' +
            '     WHERE PROJNO LIKE ENG_PROJNO) LOC_CODE, ' +
            '   ( ' +
            '     SELECT CODE_NAME FROM HIMSEN_INFO A, HITEMS_LOCATION_CODE B ' +
            '     WHERE A.PROJNO LIKE ENG_PROJNO ' +
            '     AND A.LOC_CODE = B.CODE) LOC_CODE_NAME ' +
            'FROM ' +
            '( ' +
            '   SELECT PLAN_NO, MAX(PLAN_REV_NO) PRN FROM TMS_PLAN ' +
            '   WHERE PLAN_NO LIKE :PLAN_NO ' +
            '   GROUP BY PLAN_NO ' +
            ') A LEFT OUTER JOIN ' +
            '( ' +
            '   SELECT * FROM TMS_PLAN ' +
            ')B ' +
            'ON A.PLAN_NO = B.PLAN_NO ' +
            'AND A.PRN = B.PLAN_REV_NO ');

    ParamByName('PLAN_NO').AsString := aPlanNo;
    Open;

    if RecordCount <> 0 then
    begin
      et_reqDept.Text      := Get_DeptName(DM1.FUserInfo.CurrentUsersDept);
      et_reqDept.Hint      := DM1.FUserInfo.CurrentUsersDept;

      cb_EngType.Items.Clear;
      cb_EngType.Items.Add(FieldByName('ENG_PROJNO').AsString+'-'+FieldByName('ENG_TYPE').AsString);
      cb_EngType.ItemIndex := 0;
      cb_EngType.Hint      := FieldByName('ENG_PROJNO').AsString;

      et_EngLoc.hint       := FieldByName('LOC_CODE').AsString;
      et_EngLoc.Text       := FieldByName('LOC_CODE_NAME').AsString;

      et_reqIncharge.Text  := Get_UserName(DM1.FUserInfo.CurrentUsers);
      et_reqIncharge.Hint  := DM1.FUserInfo.CurrentUsers;

      et_testName.Text     := FieldByName('PLAN_NAME').AsString;
      et_testPurpose.Clear;
      dt_begin.Date        := Today;
      dt_end.Date          := Tomorrow;
      et_method.Clear;

    end;
  end;
{$ENDIF}
end;

function TtestRequest_Frm.Get_Test_Seq_Number(aType, aLocCode,
  aMonth: String): Integer;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM TMS_TEST_SEQNO ' + 'WHERE TYPE LIKE :TYPE ' +
      'AND LOC_CODE LIKE :LOC_CODE ' + 'AND MONTH LIKE :MONTH ');
    ParamByName('TYPE').AsString := aType;
    ParamByName('LOC_CODE').AsString := aLocCode;
    ParamByName('MONTH').AsString := aMonth;
    Open;

    if RecordCount <> 0 then
    begin
      Result := FieldByName('SEQ_NO').AsInteger + 1;

      Close;
      SQL.Clear;
      SQL.Add('UPDATE TMS_TEST_SEQNO SET ' + ' SEQ_NO = :param1 ' +
        'WHERE TYPE LIKE :TYPE ' + 'AND LOC_CODE LIKE :LOC_CODE ' +
        'AND MONTH LIKE :MONTH ');

      ParamByName('TYPE').AsString := aType;
      ParamByName('LOC_CODE').AsString := aLocCode;
      ParamByName('MONTH').AsString := aMonth;

      ParamByName('param1').AsInteger := Result;
      ExecSQL;
    end
    else
    begin
      Result := 1;

      Close;
      SQL.Clear;
      SQL.Add('INSERT INTO TMS_TEST_SEQNO ' + '( ' +
        '   TYPE, LOC_CODE, MONTH, SEQ_NO ' + ') VALUES ( ' +
        '   :TYPE, :LOC_CODE, :MONTH, :SEQ_NO ' + ') ');

      ParamByName('TYPE').AsString := aType;
      ParamByName('LOC_CODE').AsString := aLocCode;
      ParamByName('MONTH').AsString := aMonth;
      ParamByName('SEQ_NO').AsInteger := Result;
      ExecSQL;

    end;
  end;
end;

procedure TtestRequest_Frm.grid_partSelectCell(Sender: TObject; ACol,
  ARow: Integer);
begin
  if Assigned(grid_part.Row[ARow].Data) then
  begin
    FileListCombo.Items.Clear;
    FileListCombo.Items.AddStrings(TStringList(grid_part.Row[ARow].Data));
  end;
end;

procedure TtestRequest_Frm.Insert_Attfiles(aOwner, aRegNo, aFileName, aFileSize,
  aFilePath: String);
var
  lms: TMemoryStream;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Insert Into TMS_ATTFILES ' +
      'Values(:OWNER,:REGNO,:FILENAME,:FILESIZE,:FILES)');

    ParamByName('OWNER').AsString := aOwner;
    ParamByName('REGNO').AsString := aRegNo;
    ParamByName('FILENAME').AsString := aFileName;
    ParamByName('FILESIZE').AsFloat := StrToFloat(aFileSize);

    lms := TMemoryStream.Create;
    try
      lms.Position := 0;
      lms.LoadFromFile(aFilePath);

      if lms <> nil then
      begin
        ParamByName('FILES').ParamType := ptInput;
        ParamByName('FILES').AsOraBlob.LoadFromStream(lms);
      end;
      try
        ExecSQL;
      except
        on e: Exception do
        begin
          ShowMessage(e.Message);
          Raise;
        end;
      end;
    finally
      FreeAndNil(lms);
    end;
  end;
end;

procedure TtestRequest_Frm.Insert_Part_Attfiles(aReqNo, aPartNo,aSerial: String;aRow:Integer);
var
  OraQuery : TOraQuery;
  i,j : Integer;
  lms : TMemoryStream;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.OraSession1;
    OraQuery.Options.TemporaryLobUpdate := True;
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Insert Into TMS_TEST_PART_ATTFILES ' +
              '(REQ_NO, PART_NO, SERIAL, FILE_NAME, FILES, FILE_SIZE) VALUES ' +
              '(:REQ_NO, :PART_NO, :SERIAL, :FILE_NAME, :FILES, :FILE_SIZE) ');


      if TStringList(grid_part.Row[aRow].Data).Count > 0 then
      begin
        lms := TMemoryStream.Create;
        try
          for j := 0 to TStringList(grid_part.Row[aRow].Data).Count-1 do
          begin
            ParamByName('REQ_NO').AsString    := aReqNo;
            ParamByName('PART_NO').AsString   := aPartNo;
            ParamByName('SERIAL').AsString    := aSerial;
            ParamByName('FILE_NAME').AsString := UPPERCASE(ExtractFileName(TStringList(grid_part.Row[aRow].Data).Strings[j]));
            ParamByName('FILE_SIZE').AsInteger := lms.Size;
            lms.LoadFromFile(TStringList(grid_part.Row[aRow].Data).Strings[j]);
            //lms.Position := 0;

            ParamByName('FILES').ParamType := ptInput;
            ParamByName('FILES').AsOraBlob.LoadFromStream(lms);

            ExecSQL;
          end;
        finally
          FreeAndNil(lms);
        end;
      end;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure TtestRequest_Frm.Insert_Test_Receive_Info(aReqNo, aPlanNo, aStatus,
  aComment: String);
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('INSERT INTO TMS_TEST_RECEIVE_INFO ' +
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

procedure TtestRequest_Frm.Insert_TEST_REQUEST(ARequestType: string);
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('INSERT INTO TMS_TEST_REQUEST ' + '( ' +
      '   REQ_NO, PARENT_NO, REQ_DEPT, REQ_ID, TEST_ENGINE, TEST_NAME, TEST_PURPOSE, '
      + '   TEST_BEGIN, TEST_END, TEST_METHOD, INDATE ' + ') VALUES ( ' +
      '   :REQ_NO, :PARENT_NO, :REQ_DEPT, :REQ_ID, :TEST_ENGINE, :TEST_NAME, :TEST_PURPOSE, '
      + '   :TEST_BEGIN, :TEST_END, :TEST_METHOD, :INDATE ) ');

    ParamByName('REQ_NO').AsString := et_ReqNo.Text;

    if ARequestType = '재요청' then
      ParamByName('PARENT_NO').AsString := FParentReqNo;

    ParamByName('REQ_DEPT').AsString := DM1.FUSerInfo.Dept_Cd;
    ParamByName('REQ_ID').AsString := DM1.FUSerInfo.UserId;
    ParamByName('TEST_ENGINE').AsString := cb_EngType.Hint;
    ParamByName('TEST_NAME').AsString := et_testName.Text;

    ParamByName('TEST_PURPOSE').AsString := et_testPurpose.Text;
    ParamByName('TEST_BEGIN').AsDateTime := dt_begin.Date;
    ParamByName('TEST_END').AsDateTime := dt_end.Date;
    ParamByName('TEST_METHOD').AsString := et_method.Text;
    ParamByName('INDATE').AsDateTime := Now;

    ExecSQL;

  end;
end;

procedure TtestRequest_Frm.Insert_TEST_REQUEST_IMSI;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('INSERT INTO TMS_TEST_REQUEST_IMSI ' + '( ' +
      '   REQ_NO, PARENT_NO, REQ_DEPT, REQ_ID, TEST_ENGINE, TEST_NAME, TEST_PURPOSE, '
      + '   TEST_BEGIN, TEST_END, TEST_METHOD, INDATE ' + ') VALUES ( ' +
      '   :REQ_NO, :PARENT_NO, :REQ_DEPT, :REQ_ID, :TEST_ENGINE, :TEST_NAME, :TEST_PURPOSE, '
      + '   :TEST_BEGIN, :TEST_END, :TEST_METHOD, :INDATE ) ');

    ParamByName('REQ_NO').AsString := et_ReqNo.Text;
    ParamByName('PARENT_NO').AsString := '';
    ParamByName('REQ_DEPT').AsString := DM1.FUSerInfo.Dept_Cd;
    ParamByName('REQ_ID').AsString := DM1.FUSerInfo.UserId;
    ParamByName('TEST_ENGINE').AsString := cb_EngType.Hint;
    ParamByName('TEST_NAME').AsString := et_testName.Text;
    ParamByName('TEST_PURPOSE').AsString := et_testPurpose.Text;
    ParamByName('TEST_BEGIN').AsDateTime := dt_begin.Date;
    ParamByName('TEST_END').AsDateTime := dt_end.Date;
    ParamByName('TEST_METHOD').AsString := et_method.Text;
    ParamByName('INDATE').AsDateTime := Now;

    ExecSQL;

  end;
end;

function TtestRequest_Frm.IsExistRequestIMSI(aReqNo: String): Boolean;
begin
  Result := False;

  with DM1.OraQuery2 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT REQ_NO FROM TMS_TEST_REQUEST_IMSI WHERE REQ_NO = :REQNO ');
    ParamByName('REQNO').AsString := aReqNo;

    open;

    if RecordCount > 0 then
      Result := True;
  end;

end;

procedure TtestRequest_Frm.Management_Attfiles;
var
  li: Integer;
  aOwner, aRegNo, aFileName, aFileSize, aFilePath: String;
begin
  with fileGrid do
  begin
    BeginUpdate;
    try
      for li := 0 to RowCount - 1 do
      begin
        if Cell[1, li].TextColor = clRed then
        begin
          aRegNo := Cells[4, li];
          Delete_Attfile(aRegNo);
        end;

        if Cell[1, li].TextColor = clBlue then
        begin
          aOwner := et_ReqNo.Text;
          aRegNo := FormatDateTime('YYYYMMDDHHmmsszzz', Now);
          aFileName := Cells[1, li];
          aFileSize := Cells[2, li];
          aFilePath := Cells[3, li];

          Insert_Attfiles(aOwner, aRegNo, aFileName, aFileSize, aFilePath);

        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TtestRequest_Frm.mi_fileOpenClick(Sender: TObject);
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

procedure TtestRequest_Frm.mi_fileSaveClick(Sender: TObject);
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

procedure TtestRequest_Frm.Test_Request_Process(ARequestType: string);
var
  SEQ_NO: Integer;
  LMonth: String;
  LIsUpdate: Boolean;
begin
  if cb_EngType.Text = '' then
  begin
    cb_EngType.SetFocus;
    raise Exception.Create('엔진타입을 선택하여 주십시오!');
  end;

  LIsUpdate := False;

  with DM1.OraTransaction1 do
  begin
    StartTransaction;
    try
      if POS('요청', ARequestType) > 0 then
      begin
        // 요청 or 재요청

        LMonth := FormatDateTime('YYYYMM', Now);
        SEQ_NO := Get_Test_Seq_Number('Q', et_EngLoc.Hint, LMonth);

        if SEQ_NO > 0 then
        begin
          et_ReqNo.Text := 'Q' + et_EngLoc.Hint + LMonth +
            FormatFloat('000', SEQ_NO);

          if FReqType = '임시' then //임시 저장 데이터를 요청하는 경우
          begin
            Update_TEST_REQUEST(FReqNo);
            LIsUpdate := True;
          end
          else//새요청 하는 경우
            Insert_TEST_REQUEST(ARequestType);

          if ARequestType = '재요청' then
          begin
            with DM1.OraQuery1 do
            begin
              Close;
              SQL.Clear;
              SQL.Add('UPDATE TMS_TEST_RECEIVE_INFO SET ' +
                '   STATUS = ''확인'' ' + 'WHERE REQ_NO LIKE :param1 ');
              ParamByName('param1').AsString := FParentReqNo;
              ExecSQL;
            end;
          end;
        end
        else
          raise Exception.Create('요청번호를 생성할 수 없습니다!');

      end
      else
      if POS('수정', ARequestType) > 0 then
      begin
        // 수정
        if et_ReqNo.Text <> '' then
        begin
          Update_TEST_REQUEST;
        end;
      end
      else
      if POS('임시', ARequestType) > 0 then
      begin
        if IsExistRequestIMSI(et_ReqNo.Text) then
        begin
          Update_TEST_REQUEST_IMSI;
        end
        else
        begin
          LMonth := FormatDateTime('YYYYMM', Now);
          SEQ_NO := Get_Test_Seq_Number('Q', et_EngLoc.Hint, LMonth);

          if SEQ_NO > 0 then
          begin
            et_ReqNo.Text := 'Q' + et_EngLoc.Hint + LMonth +
              FormatFloat('000', SEQ_NO);

            Insert_TEST_REQUEST_IMSI;
          end;
        end;
      end
      else
      if POS('확인', ARequestType) > 0 then
      begin
        LMonth := FormatDateTime('YYYYMM',Now);
        SEQ_NO := Get_Test_Seq_Number('Q',
                                      et_EngLoc.Hint,
                                      LMonth);

        et_ReqNo.Text := 'Q' +
                          et_EngLoc.Hint +
                          LMonth +
                          FormatFloat('000',SEQ_NO);

        Insert_TEST_REQUEST(FReqNo);

        Insert_Test_Receive_Info(et_ReqNo.Text, FPlanNo,'진행','최초등록');

        Commit;
      end;

      //Update_Change_Part_2_Request;
      Update_Part_Request(LIsUpdate);
      Management_Attfiles;

      Commit;
      ShowMessage(ARequestType + '완료!');
      ModalResult := mrOk;
    except
      Rollback;
    end;
  end;
end;

procedure TtestRequest_Frm.Update_Change_Part_2_Request;
var
  SEQ,
  i,li: Integer;
  LJObj : TJSONObject;
  OraQuery : TOraQuery;
  aOwner, aRegNo, aFileName, aFileSize, aFilePath: String;
begin
  with grid_part do
  begin
    BeginUpdate;
    try
      OraQuery := TOraQuery.Create(nil);
      try
        OraQuery.Session := DM1.OraSession1;

{            with DM1.OraQuery1 do
            begin
              Close;
              SQL.Clear;
              SQL.Add('DELETE FROM TMS_TEST_PART_ATTFILES ' +
                      'WHERE REQ_NO LIKE :param1 ' +
                      'AND PART_NO LIKE :param2 ' +
                      'AND SERIAL LIKE :param3 ' +
                      'AND FILE_NAME LIKE :param4 ');
              ParamByName('param1').AsString := et_ReqNo.Text;
              ParamByName('param2').AsString := LJObj.Get('PART_NO').JsonValue.Value;
              ParamByName('param3').AsString := LJObj.Get('SERIAL').JsonValue.Value;
              ParamByName('param4').AsString := LJObj.Get('FILE_NAME').JsonValue.Value;
              ExecSQL;
            end;
 }
        for li := 0 to RowCount - 1 do
        begin
          with OraQuery do
          begin
            if Cell[1, li].TextColor = clRed then
            begin
              Close;
              SQL.Clear;
              SQL.Add('DELETE FROM TMS_TEST_REQUEST_PART ' +
                      'WHERE REQ_NO LIKE :param1 ' +
                      'AND PART_NO LIKE :param2 ' +
                      'AND SERIAL LIKE :param3 ');
              ParamByName('param1').AsString := et_ReqNo.Text;
              ParamByName('param2').AsString := Cells[1,li];
              ParamByName('param3').AsString := Cells[12,li];
              ExecSQL;

              Close;
              SQL.Clear;
              SQL.Add('DELETE FROM TMS_TEST_PART_ATTFILES ' +
                      'WHERE REQ_NO LIKE :param1 ' +
                      'AND PART_NO LIKE :param2 ' +
                      'AND SERIAL LIKE :param3 ');
              ParamByName('param1').AsString := et_ReqNo.Text;
              ParamByName('param2').AsString := Cells[1,li];
              ParamByName('param3').AsString := Cells[12,li];
              ExecSQL;
            end;

            if Cell[1, li].TextColor = clBlue then
            begin
              Close;
              SQL.Clear;
              SQL.Add('SELECT MAX(SEQ_NO) SEQ FROM TMS_TEST_REQUEST_PART ' +
                      'WHERE REQ_NO LIKE :param1 ' +
                      'AND PART_NO LIKE :param2 ');

              ParamByName('param1').AsString  := et_reqNo.Text;
              ParamByName('param2').AsString := Cells[1,li];
              Open;

              SEQ := FieldByName('SEQ').AsInteger;

              if SEQ <> 0 then
                SEQ := SEQ+1
              else
                SEQ := 1;

              if SEQ > 0 then
              begin
                Close;
                SQL.Clear;
                SQL.Add('INSERT INTO TMS_TEST_REQUEST_PART ' +
                        '(REQ_NO, PART_NO, SEQ_NO, STATUS, BANK, CYLNUM, CYCLE, SIDE, SERIAL) VALUES ' +
                        '(:REQ_NO, :PART_NO, :SEQ_NO, :STATUS, :BANK, :CYLNUM, :CYCLE, :SIDE, :SERIAL) ');

                ParamByName('REQ_NO').AsString  := et_reqNo.Text;
                ParamByName('PART_NO').AsString := Cells[1,li];
                ParamByName('SEQ_NO').AsInteger := SEQ;
                ParamByName('STATUS').AsString  := '탑재전';
                ParamByName('BANK').AsString    := Cells[8,li];

                ParamByName('CYLNUM').AsInteger := Cell[9,li].AsInteger;
                ParamByName('CYCLE').AsString   := Cells[10,li];
                ParamByName('SIDE').AsString    := Cells[11,li];
                ParamByName('SERIAL').AsString  := Cells[12,li];

                ExecSQL;

              end;
            end;

            if Assigned(grid_part.Row[li].Data) then
            begin
              Insert_Part_Attfiles(et_ReqNo.Text,
                                   Cells[1,li],
                                   Cells[12,li],
                                   li);
            end;
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

//AUpdated = True: 임시저장에서 요청을 한 경우
procedure TtestRequest_Frm.Update_Part_Request(AUpdated: Boolean);
var
  SEQ,
  li,j: Integer;
  LObj : TJSONObject;
  OraQuery : TOraQuery;
  LReqNo, LPartNo, LSerialNo, LFileName: String;
  LArray: TJSONArray;
  LValue: TJSONValue;
  lms : TMemoryStream;
begin
  with grid_part do
  begin
    BeginUpdate;
    try
      OraQuery := TOraQuery.Create(nil);
      try
        OraQuery.Session := DM1.OraSession1;

        with OraQuery do
        begin
          for li := 0 to FTestReqList.TestPartCollect.Count - 1 do
          begin
            FTestReqList.GetSerialFileInfo(FTestReqList.TestPartCollect.Items[li].ID, LReqNo, LPartNo, LSerialNo);

            if (FTestReqList.TestPartCollect.Items[li].FileLocation = flDB) and
              (FTestReqList.TestPartCollect.Items[li].FileAction = faDelete) then
            begin
              if (LReqNo = et_ReqNo.Text) and (LPartNo = FTestReqList.TestPartCollect.Items[li].PART_NO) then
              begin
                Close;
                SQL.Clear;
                SQL.Add('DELETE FROM TMS_TEST_REQUEST_PART ' +
                        'WHERE REQ_NO LIKE :param1 ' +
                        'AND PART_NO LIKE :param2 ' +
                        'AND SERIAL LIKE :param3 ');
                //if AUpdated then
                  ParamByName('param1').AsString := LReqNo;//et_ReqNo.Text;
                //else
                //  ParamByName('param1').AsString := LReqNo;//et_ReqNo.Text;

                ParamByName('param2').AsString := LPartNo;
                ParamByName('param3').AsString := LSerialNo;
                ExecSQL;

                Close;
                SQL.Clear;
                SQL.Add('DELETE FROM TMS_TEST_PART_ATTFILES ' +
                        'WHERE REQ_NO LIKE :param1 ' +
                        'AND PART_NO LIKE :param2 ' +
                        'AND SERIAL LIKE :param3 ');
                ParamByName('param1').AsString := LReqNo;//et_ReqNo.Text;
                ParamByName('param2').AsString := LPartNo;
                ParamByName('param3').AsString := LSerialNo;
                ExecSQL;
              end;
            end
            else
            if (FTestReqList.TestPartCollect.Items[li].FileLocation = flDisk) and
              (FTestReqList.TestPartCollect.Items[li].FileAction = faInsert) then
            begin
              //if (LReqNo = et_ReqNo.Text) and (LPartNo = FTestReqList.TestPartCollect.Items[li].PART_NO) then
              if (LReqNo = FReqNo) and (LPartNo = FTestReqList.TestPartCollect.Items[li].PART_NO) then
              begin
                Close;
                SQL.Clear;
                SQL.Add('SELECT MAX(SEQ_NO) SEQ FROM TMS_TEST_REQUEST_PART ' +
                        'WHERE REQ_NO LIKE :param1 ' +
                        'AND PART_NO LIKE :param2 ');

                if LReqNo = '' then
                  LReqNo := et_reqNo.Text;

                ParamByName('param1').AsString  := LReqNo;//et_reqNo.Text;
                ParamByName('param2').AsString := LPartNo;
                Open;

                SEQ := FieldByName('SEQ').AsInteger;

                if SEQ <> 0 then
                  SEQ := SEQ+1
                else
                  SEQ := 1;

                if SEQ > 0 then
                begin
                  Close;
                  SQL.Clear;
                  SQL.Add('INSERT INTO TMS_TEST_REQUEST_PART ' +
                          '(REQ_NO, PART_NO, SEQ_NO, STATUS, BANK, CYLNUM, CYCLE, SIDE, SERIAL) VALUES ' +
                          '(:REQ_NO, :PART_NO, :SEQ_NO, :STATUS, :BANK, :CYLNUM, :CYCLE, :SIDE, :SERIAL) ');

                  ParamByName('REQ_NO').AsString  := LReqNo;//et_reqNo.Text;
                  ParamByName('PART_NO').AsString := LPartNo;
                  ParamByName('SEQ_NO').AsInteger := SEQ;
                  ParamByName('STATUS').AsString  := '탑재전';

                  ParamByName('BANK').AsString    := FTestReqList.GetBankPos(FTestReqList.TestPartCollect.Items[li].RowNo);
                  ParamByName('CYLNUM').AsInteger := StrToIntDef(FTestReqList.GetCylNo(FTestReqList.TestPartCollect.Items[li].RowNo),0);
                  ParamByName('CYCLE').AsString   := FTestReqList.GetExh_Intake(FTestReqList.TestPartCollect.Items[li].RowNo);
                  ParamByName('SIDE').AsString    := FTestReqList.GetSide(FTestReqList.TestPartCollect.Items[li].RowNo);
                  ParamByName('SERIAL').AsString  := FTestReqList.GetSerialNo(FTestReqList.TestPartCollect.Items[li].RowNo);

                  ExecSQL;
                end;
              end;
            end;//if

            for j := 0 to FTestReqList.TestPartSerialFileCollect.Count - 1 do
            begin
              if FTestReqList.TestPartSerialFileCollect.Items[j].ID = FTestReqList.TestPartCollect.Items[li].ID then
              begin
                if (FTestReqList.TestPartSerialFileCollect.Items[j].FileLocation = flDisk) and
                  (FTestReqList.TestPartSerialFileCollect.Items[j].FileAction = faInsert) then
                begin
                  LFileName := FTestReqList.TestPartSerialFileCollect.Items[j].FilePath;
                  Close;
                  SQL.Clear;
                  SQL.Add('Insert Into TMS_TEST_PART_ATTFILES ' +
                          '(REQ_NO, PART_NO, SERIAL, FILE_NAME, FILES, FILE_SIZE) VALUES ' +
                          '(:REQ_NO, :PART_NO, :SERIAL, :FILE_NAME, :FILES, :FILE_SIZE) ');

                  lms := TMemoryStream.Create;
                  try
                    ParamByName('REQ_NO').AsString    := LReqNo;
                    ParamByName('PART_NO').AsString   := LPartNo;
                    ParamByName('SERIAL').AsString    := LSerialNo;
                    ParamByName('FILE_NAME').AsString := UPPERCASE(FTestReqList.TestPartSerialFileCollect.Items[j].FileName);
                    lms.LoadFromFile(LFileName);
                    ParamByName('FILE_SIZE').AsInteger := lms.Size;
                    lms.Position := 0;
                    OraQuery.Options.TemporaryLobUpdate := True;

                    if lms <> nil then
                    begin
                      ParamByName('FILES').ParamType := ptInput;
                      ParamByName('FILES').AsOraBlob.LoadFromStream(lms);

                      ExecSQL;
                    end
                    else
                      ShowMessage('File: ' + LFileName + ' is null!');
                  finally
                    FreeAndNil(lms);
                  end;
                end//if
                else
                if (FTestReqList.TestPartSerialFileCollect.Items[j].FileLocation = flDB) and
                  (FTestReqList.TestPartSerialFileCollect.Items[j].FileAction = faDelete) then
                begin
                  Close;
                  SQL.Clear;
                  SQL.Add('DELETE FROM TMS_TEST_PART_ATTFILES ' +
                          'WHERE REQ_NO = :param1 AND ' +
                          '     PART_NO = :PART_NO AND ' +
                          '     SERIAL = :SERIAL AND ' +
                          '     FILE_NAME = :FN');
                  ParamByName('param1').AsString := LReqNo;
                  ParamByName('PART_NO').AsString := LPartNo;
                  ParamByName('SERIAL').AsString := LSerialNo;
                  ParamByName('FN').AsString := FTestReqList.TestPartSerialFileCollect.Items[j].FileName;
                  ExecSQL;
                end;//if
              end;//if
            end;//for

          end;//for

          //임시저장에서 요청을 한 경우
          if AUpdated then
          begin
            Close;
            SQL.Clear;
            SQL.Add('INSERT INTO TMS_TEST_REQUEST_PART ' +
                    '(REQ_NO, PART_NO, SEQ_NO, STATUS, BANK, CYLNUM, CYCLE, SIDE, SERIAL) ' +
                    ' SELECT ''' + et_reqNo.Text + ''', PART_NO, SEQ_NO, STATUS, BANK, CYLNUM, CYCLE, SIDE, SERIAL ' +
                    ' FROM TMS_TEST_REQUEST_PART ' +
                    ' WHERE REQ_NO = :REQ_NO ');

            ParamByName('REQ_NO').AsString  := FReqNo;
            ExecSQL;

            Close;
            SQL.Clear;
            SQL.Add('DELETE FROM TMS_TEST_REQUEST_PART ' +
                    'WHERE REQ_NO = :param1');
            ParamByName('param1').AsString := FReqNo;
            ExecSQL;

            Close;
            SQL.Clear;
            SQL.Add('Insert Into TMS_TEST_PART_ATTFILES ' +
                    '(REQ_NO, PART_NO, SERIAL, FILE_NAME, FILES, FILE_SIZE) ' +
                    'SELECT '''+ et_reqNo.Text + ''', PART_NO, SERIAL, FILE_NAME, FILES, FILE_SIZE ' +
                    ' FROM TMS_TEST_PART_ATTFILES ' +
                    'WHERE REQ_NO = :REQ_NO');
            ParamByName('REQ_NO').AsString  := FReqNo;
            ExecSQL;

            Close;
            SQL.Clear;
            SQL.Add('DELETE FROM TMS_TEST_PART_ATTFILES ' +
                    'WHERE REQ_NO = :param1');
            ParamByName('param1').AsString := FReqNo;
            ExecSQL;

            Close;
            SQL.Clear;
            SQL.Add('DELETE FROM TMS_TEST_REQUEST_IMSI ' +
                    'WHERE REQ_NO = :param1');
            ParamByName('param1').AsString := FReqNo;
            ExecSQL;

          end;
        end;//with
      finally
        FreeAndNil(OraQuery);
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TtestRequest_Frm.Update_TEST_REQUEST(AReqNo: string = '');
begin
  with DM1.OraQuery1 do
  begin
    if AReqNo <> '' then
    begin
//      Close;
//      SQL.Clear;
//      SQL.Add('DELETE TMS_TEST_REQUEST ' +
//        'WHERE REQ_NO = :param1 ');
//      ParamByName('param1').AsString := AReqNo;
//
//      ExecSQL;

      Close;
      SQL.Clear;
      SQL.Add('INSERT INTO TMS_TEST_REQUEST ' + '( ' +
        '   REQ_NO, PARENT_NO, REQ_DEPT, REQ_ID, TEST_ENGINE, TEST_NAME, TEST_PURPOSE, '
        + '   TEST_BEGIN, TEST_END, TEST_METHOD, INDATE ' + ')  ' +
        '     SELECT ''' + et_ReqNo.Text + ''', PARENT_NO, REQ_DEPT, REQ_ID, TEST_ENGINE, TEST_NAME, TEST_PURPOSE, '
        + '   TEST_BEGIN, TEST_END, TEST_METHOD, INDATE FROM TMS_TEST_REQUEST_IMSI '
        + ' WHERE REQ_NO = :REQ_NO ');

      ParamByName('REQ_NO').AsString := AReqNo;//et_ReqNo.Text;

      //if ARequestType = '재요청' then
{        ParamByName('PARENT_NO').AsString := FParentReqNo;

      ParamByName('REQ_DEPT').AsString := FUSerInfo.Dept_Cd;
      ParamByName('REQ_ID').AsString := FUSerInfo.UserId;
      ParamByName('TEST_ENGINE').AsString := cb_EngType.Hint;
      ParamByName('TEST_NAME').AsString := et_testName.Text;

      ParamByName('TEST_PURPOSE').AsString := et_testPurpose.Text;
      ParamByName('TEST_BEGIN').AsDateTime := dt_begin.Date;
      ParamByName('TEST_END').AsDateTime := dt_end.Date;
      ParamByName('TEST_METHOD').AsString := et_method.Text;
      ParamByName('INDATE').AsDateTime := Now;
}
      ExecSQL;
    end
    else
    begin
      Close;
      SQL.Clear;
      SQL.Add('UPDATE TMS_TEST_REQUEST SET ' +
        ' TEST_ENGINE = :TEST_ENGINE, TEST_NAME = :TEST_NAME, ' +
        ' TEST_PURPOSE = :TEST_PURPOSE, TEST_BEGIN = :TEST_BEGIN, ' +
        ' TEST_END = :TEST_END, TEST_METHOD = :TEST_METHOD, ' +
        ' MOD_ID = :MOD_ID, MOD_DATE = :MOD_DATE ' +
        'WHERE REQ_NO LIKE :param1 ');
      ParamByName('param1').AsString := et_ReqNo.Text;

      ParamByName('TEST_ENGINE').AsString := cb_EngType.Hint;
      ParamByName('TEST_NAME').AsString := et_testName.Text;

      ParamByName('TEST_PURPOSE').AsString := et_testPurpose.Text;
      ParamByName('TEST_BEGIN').AsDateTime := dt_begin.Date;
      ParamByName('TEST_END').AsDateTime := dt_end.Date;
      ParamByName('TEST_METHOD').AsString := et_method.Text;

      ParamByName('MOD_ID').AsString := DM1.FUSerInfo.UserID;
      ParamByName('MOD_DATE').AsDateTime := Now;

      ExecSQL;
    end;

  end;
end;

procedure TtestRequest_Frm.Update_TEST_REQUEST_IMSI;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('UPDATE TMS_TEST_REQUEST_IMSI SET ' +
      ' TEST_ENGINE = :TEST_ENGINE, TEST_NAME = :TEST_NAME, ' +
      ' TEST_PURPOSE = :TEST_PURPOSE, TEST_BEGIN = :TEST_BEGIN, ' +
      ' TEST_END = :TEST_END, TEST_METHOD = :TEST_METHOD, ' +
      ' MOD_ID = :MOD_ID, MOD_DATE = :MOD_DATE ' +
      'WHERE REQ_NO LIKE :param1 ');
    ParamByName('param1').AsString := et_ReqNo.Text;

    ParamByName('TEST_ENGINE').AsString := cb_EngType.Hint;
    ParamByName('TEST_NAME').AsString := et_testName.Text;

    ParamByName('TEST_PURPOSE').AsString := et_testPurpose.Text;
    ParamByName('TEST_BEGIN').AsDateTime := dt_begin.Date;
    ParamByName('TEST_END').AsDateTime := dt_end.Date;
    ParamByName('TEST_METHOD').AsString := et_method.Text;

    ParamByName('MOD_ID').AsString := DM1.FUSerInfo.UserID;
    ParamByName('MOD_DATE').AsDateTime := Now;

    ExecSQL;

  end;
end;

end.
