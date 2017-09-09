unit workOrder_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, JvExControls, JvLabel, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Vcl.StdCtrls, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, Vcl.ComCtrls, DateUtils, System.Generics.Collections,
  NxColumnClasses, NxColumns, Vcl.ImgList, Vcl.Touch.GestureCtrls, Ora,
  Vcl.Menus, AdvMenus, DB, ShellApi, AdvGlowButton, StrUtils;

type
  TworkOrder_Frm = class(TForm)
    Panel8: TPanel;
    Image1: TImage;
    grid_orders: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxImageColumn1: TNxImageColumn;
    NxImageColumn3: TNxImageColumn;
    ImageList1: TImageList;
    Panel3: TPanel;
    JvLabel1: TJvLabel;
    JvLabel4: TJvLabel;
    JvLabel5: TJvLabel;
    JvLabel6: TJvLabel;
    Timer1: TTimer;
    NxTextColumn1: TNxTextColumn;
    NxTreeColumn1: TNxTreeColumn;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn4: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    NxTextColumn6: TNxTextColumn;
    NxTextColumn7: TNxTextColumn;
    Panel5: TPanel;
    tree_Parent: TTreeView;
    ImageList24x24: TImageList;
    JvLabel8: TJvLabel;
    JvLabel9: TJvLabel;
    NxImageColumn2: TNxImageColumn;
    grid_Attfiles: TNextGrid;
    NxIncrementColumn3: TNxIncrementColumn;
    NxTextColumn9: TNxTextColumn;
    NxTextColumn10: TNxTextColumn;
    NxTextColumn11: TNxTextColumn;
    NxTextColumn12: TNxTextColumn;
    NxTextColumn8: TNxTextColumn;
    AdvPopupMenu1: TAdvPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    SaveDialog1: TSaveDialog;
    NxTextColumn13: TNxTextColumn;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel1: TPanel;
    JvLabel2: TJvLabel;
    cb_plan: TComboBox;
    et_planNo: TEdit;
    et_planRevNo: TEdit;
    Panel2: TPanel;
    JvLabel3: TJvLabel;
    cb_part: TComboBox;
    Panel4: TPanel;
    JvLabel7: TJvLabel;
    Label1: TLabel;
    Panel9: TPanel;
    AdvGlowButton1: TAdvGlowButton;
    AdvGlowButton2: TAdvGlowButton;
    ImageList32x32: TImageList;
    N3: TMenuItem;
    mi_AddFiles: TMenuItem;
    OpenDialog1: TOpenDialog;
    cb_engType: TComboBox;
    procedure cb_partDropDown(Sender: TObject);
    procedure cb_partSelect(Sender: TObject);
    procedure cb_planDropDown(Sender: TObject);
    procedure cb_planSelect(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure grid_ordersSelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure grid_ordersCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure grid_AttfilesCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure AdvGlowButton1Click(Sender: TObject);
    procedure AdvGlowButton2Click(Sender: TObject);
    procedure mi_AddFilesClick(Sender: TObject);
    procedure cb_engTypeDropDown(Sender: TObject);
  private
    { Private declarations }
    FtreeDic: TDictionary<String, TTreeNode>;
  public
    { Public declarations }
    procedure Get_ParentTask(aPlanNo: String);
    procedure Get_Attfiles(aOwner: String);
    procedure Get_WorkOrders(aPlanNo: String);
    procedure Set_Status_Of_Grid(aStatus: String; ARow: Integer);

    function Get_SEQ_NO(aOrderNo: String): Integer;
    function Get_Num_Of_Workers(aList: String): Integer;

    function Update_Status_Of_Order(aOrderNo, aStatus: String): Boolean;
    function Insert_Result_Of_Order(aOrderNo, aStart, aStatus,
      aWorker: String): Boolean;
    function Update_Result_Of_Order(aOrderNo, aStop, aStatus,
      aMsg: String): Boolean;

    procedure Send_StopMessage(aHeader, aTitle, aMsg: String);
    procedure Send_Message_Main_CODE(FFlag, FSendID, FRecID, FHead, FTitle,
      FContent: String); // 메세지 메인 함수

    function GetForm(frmClassName:String):TForm;
    procedure Open_the_Work_sheet(aAction_Time, aOrderNo, aCode, aCodeName: String);

  end;

var
  workOrder_Frm: TworkOrder_Frm;



implementation

uses
  checkChangePart_Unit,
  shimDataSheet_Unit,
  localSheet_Unit,
  HiTEMS_TMS_CONST,
  HHI_WebService,
  UnitHHIMessage,
  makeOrder_Unit,
  detailOrder_Unit,
  resultDialog_Unit,
  workerDialog_Unit,
  DataModule_Unit;


{$R *.dfm}


procedure TworkOrder_Frm.AdvGlowButton1Click(Sender: TObject);
var
  LForm: TmakeOrder_Frm;
begin
  LForm := TmakeOrder_Frm.Create(Application);
  try
    with LForm do
    begin
      ShowModal;
    end;
  finally
    FreeAndNil(LForm);

    if et_planNo.Text <> '' then
      Get_WorkOrders(et_planNo.Text)

  end;
end;

procedure TworkOrder_Frm.AdvGlowButton2Click(Sender: TObject);
begin
  Close;
end;

procedure TworkOrder_Frm.cb_engTypeDropDown(Sender: TObject);
begin
  if cb_part.Hint <> '' then
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
          SQL.Add('SELECT ENG_PROJNO, ENG_TYPE FROM  ' +
                  '( ' +
                  '   SELECT ' +
                  '     PN, PRN, PLAN_NAME, PLAN_TYPE, PLAN_START, ' +
                  '     PLAN_END, ENG_PROJNO, ENG_TYPE, PLAN_TEAM ' +
                  '   FROM ' +
                  '   ( ' +
                  '       SELECT ' +
                  '         PN, PRN, PLAN_NAME, PLAN_TYPE, PLAN_START, ' +
                  '         PLAN_END, ENG_PROJNO, ENG_TYPE ' +
                  '       FROM ' +
                  '       ( ' +
                  '           SELECT PLAN_NO PN, MAX(PLAN_REV_NO) PRN FROM DPMS_TMS_PLAN GROUP BY PLAN_NO ' +
                  '       ) A, ' +
                  '       ( ' +
                  '           SELECT * FROM DPMS_TMS_PLAN ' +
                  '       ) B ' +
                  '       WHERE A.PN = B.PLAN_NO ' +
                  '       AND A.PRN = B.PLAN_REV_NO ' +
                  '   ) A, ' +
                  '   ( ' +
                  '       SELECT PLAN_NO, MAX(PLAN_REV_NO) PLAN_REV_NO, PLAN_TEAM ' +
                  '       FROM DPMS_TMS_PLAN_INCHARGE GROUP BY PLAN_NO, PLAN_TEAM ' +
                  '   ) B ' +
                  '   WHERE A.PN = B.PLAN_NO ' +
                  '   AND A.PRN = B.PLAN_REV_NO ' +
                  ') ' +
                  'WHERE PLAN_TEAM LIKE :team ' +
                  'AND PLAN_TYPE = 1 ' +
                  'AND (PLAN_START <= :day AND PLAN_END >= :day) ' +
                  'GROUP BY ENG_PROJNO, ENG_TYPE ' +
                  'ORDER BY ENG_TYPE DESC ');

          ParamByName('team').AsString := cb_part.Hint;
          ParamByName('day').AsDate := Today;
          Open;

          Add('');
          if RecordCount <> 0 then
          begin
            while not eof do
            begin
              Add(FieldByName('ENG_PROJNO').AsString + '-' +
                FieldByName('ENG_TYPE').AsString);
              Next;
            end;
          end;
        end;
      finally
        EndUpdate;
      end;
    end;
  end;
end;

procedure TworkOrder_Frm.cb_partDropDown(Sender: TObject);
begin
  with cb_part.Items do
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
                '   SELECT * FROM DPMS_DEPT ' +
                '   START WITH PARENT_CD LIKE :param1 ' +
                '   CONNECT BY PRIOR DEPT_CD = PARENT_CD ' +
                ') ' +
                'WHERE DEPT_CD LIKE ''%-%'' ' +
                'ORDER BY DEPT_CD ');

        ParamByName('param1').AsString := LeftStr(DM1.FUserInfo.CurrentUsersDept,4);
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

procedure TworkOrder_Frm.cb_partSelect(Sender: TObject);
var
  i: Integer;
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
        if i = cb_part.ItemIndex - 1 then
        begin
          cb_part.Hint := FieldByName('DEPT_CD').AsString;
          Break;
        end;
        Next;
      end;
    end;
  end
  else
    cb_part.Hint := '';

  cb_plan.Clear;
  cb_plan.Items.Clear;

  et_planNo.Clear;
  et_planRevNo.Clear;

  tree_Parent.Items.Clear;
  grid_Attfiles.ClearRows;
  grid_orders.ClearRows;
end;

procedure TworkOrder_Frm.cb_planDropDown(Sender: TObject);
begin
  if cb_part.Text <> '' then
  begin
    with cb_plan.Items do
    begin
      BeginUpdate;
      try
        Clear;
        with DM1.OraQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT ' +
                  '   A.*, ' +
                  '   (SELECT ENGTYPE FROM DPMS_HIMSEN_INFO WHERE PROJNO LIKE A.ENG_PROJNO) ENG_TYPE ' +
                  'FROM ' +
                  '( ' +
                  '   SELECT PN, PRN, PLAN_NAME, PLAN_TYPE, PLAN_START, PLAN_END, ENG_PROJNO, PLAN_TEAM FROM ' +
                  '   ( ' +
                  '       SELECT PN, PRN, PLAN_NAME, PLAN_TYPE, PLAN_START, PLAN_END, ENG_PROJNO FROM ' +
                  '       ( ' +
                  '           SELECT PLAN_NO PN, MAX(PLAN_REV_NO) PRN FROM DPMS_TMS_PLAN GROUP BY PLAN_NO ' +
                  '       ) A, ' +
                  '       ( ' +
                  '           SELECT * FROM DPMS_TMS_PLAN ' + '       ) B ' +
                  '       WHERE A.PN = B.PLAN_NO ' +
                  '       AND A.PRN = B.PLAN_REV_NO ' + '   ) A, ' + '   ( ' +
                  '       SELECT PLAN_NO, MAX(PLAN_REV_NO) PLAN_REV_NO, PLAN_TEAM ' +
                  '       FROM DPMS_TMS_PLAN_INCHARGE GROUP BY PLAN_NO, PLAN_TEAM ' +
                  '   ) B ' + '   WHERE A.PN = B.PLAN_NO ' +
                  '   AND A.PRN = B.PLAN_REV_NO ' + ') A ' +
                  'WHERE PLAN_TEAM LIKE :team ' + 'AND PLAN_TYPE = 1 ' +
                  'AND (PLAN_START <= :day AND PLAN_END >= :day) ' +
                  'AND ENG_PROJNO LIKE :param1 ' + 'ORDER BY PLAN_NAME, PLAN_START ');

          ParamByName('team').AsString := cb_part.Hint;
          ParamByName('day').AsDate := Today;

          if cb_engType.Text <> '' then
            ParamByName('param1').AsString := LeftStr(cb_engType.Text, 6)
          else
            SQL.Text := ReplaceStr(SQL.Text,
              'AND ENG_PROJNO LIKE :param1 ', '');

          Open;

          while not eof do
          begin
            Add(FieldByName('PLAN_NAME').AsString);
            Next;
          end;
        end;
      finally
        EndUpdate;
      end;
    end;
  end
  else
    ShowMessage('먼저 반(소속)을 선택하여 주십시오!');
end;

procedure TworkOrder_Frm.cb_planSelect(Sender: TObject);
var
  LEngProjNo : String;
begin
  with DM1.OraQuery1 do
  begin
    First;
    while not eof do
    begin
      if cb_plan.ItemIndex = RecNo - 1 then
      begin
        et_planNo.Text := FieldByName('PN').Text;
        et_planRevNo.Text := FieldByName('PRN').Text;

        with cb_engType.Items do
        begin
          BeginUpdate;
          try
            Clear;
            Add(FieldByName('ENG_PROJNO').AsString + '-' + FieldByName('ENG_TYPE').AsString);
            cb_engType.ItemIndex := 0;
          finally
            EndUpdate;
          end;
        end;

        Get_ParentTask(et_planNo.Text);
        Get_WorkOrders(et_planNo.Text);
        Break;
      end;
      Next;
    end;
    grid_orders.SetFocus;
    Get_Attfiles(et_planNo.Text);
  end;
end;

procedure TworkOrder_Frm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Assigned(FtreeDic) then
    FreeAndNil(FtreeDic);
end;

procedure TworkOrder_Frm.FormCreate(Sender: TObject);
begin
  Label1.Caption := FormatDateTime('yyyy-MM-dd HH:mm:ss', Now);
  grid_orders.Options := grid_orders.Options - [goHeader];
end;

function TworkOrder_Frm.GetForm(frmClassName: String): TForm;
var
  frm : TForm;
  idx : Integer;
begin
  for idx:=0 to Screen.FormCount -1 do
  begin
    if(Screen.Forms[idx].ClassNameIs(frmClassName))then
    begin
      Result:=Screen.Forms[idx];
      Exit;
    end;
  end;

  Application.CreateForm(TComponentClass(GetClass(frmClassName)),frm);
  // frm:=TForm2.Create(Application);
  Result:=frm;
end;

procedure TworkOrder_Frm.Get_Attfiles(aOwner: String);
begin
  TThread.Queue(nil,
    procedure
    var
      LRow: Integer;
    begin
      with grid_Attfiles do
      begin
        BeginUpdate;
        try
          ClearRows;
          with DM1.OraQuery1 do
          begin
            Close;
            SQL.Clear;
            SQL.Add('SELECT * FROM DPMS_TMS_ATTFILES ' + 'WHERE OWNER LIKE :param1 '
              + 'ORDER BY REGNO ');
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
    end);
end;

function TworkOrder_Frm.Get_Num_Of_Workers(aList: String): Integer;
var
  LStrList: TStringList;
begin
  LStrList := TStringList.Create;
  try
    ExtractStrings([','], [], PChar(aList), LStrList);
    Result := LStrList.Count;
  finally
    FreeAndNil(LStrList);
  end;
end;

procedure TworkOrder_Frm.Get_ParentTask(aPlanNo: String);
var
  i: Integer;
  lnode: TTreeNode;
begin
  with tree_Parent.Items do
  begin
    BeginUpdate;
    try
      Clear;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM ' + '( ' + '   SELECT * FROM ' + '   ( ' +
          '       ( ' + '           SELECT TASK_NO, PLAN_NO, PLAN_NAME ' +
          '           FROM DPMS_TMS_PLAN ' + '           WHERE PLAN_NO = :param1 ' +
          '           AND PLAN_REV_NO = :param2 ' + '       ) union all ' +
          '       ( ' +
          '           SELECT TASK_PRT, TASK_NO, TASK_NAME FROM DPMS_TMS_TASK ' +
          '       )' + '   ) ' + '   START WITH PLAN_NO = :param1 ' +
          '   CONNECT BY  PLAN_NO = PRIOR TASK_NO ' + ') ' +
          'START WITH TASK_NO IS NULL ' +
          'CONNECT BY PRIOR PLAN_NO = TASK_NO ');
        ParamByName('param1').AsString := et_planNo.Text;
        ParamByName('param2').AsInteger := StrToInt(et_planRevNo.Text);
        Open;

        if RecordCount <> 0 then
        begin
          if Assigned(FtreeDic) then
            FtreeDic.Clear
          else
            FtreeDic := TDictionary<String, TTreeNode>.Create;

          while not eof do
          begin
            if FtreeDic.Count = 0 then
            begin
              lnode := AddFirst(nil, FieldByName('PLAN_NAME').AsString);
            end
            else
            begin
              if FtreeDic.TryGetValue(FieldByName('TASK_NO').AsString, lnode)
              then
                lnode := AddChild(lnode, FieldByName('PLAN_NAME').AsString)
              else
                lnode := Add(nil, FieldByName('PLAN_NAME').AsString);
            end;
            FtreeDic.Add(FieldByName('PLAN_NO').AsString, lnode);
            Next;
          end;
        end;

        if Count > 0 then
        begin
          for i := 0 to Count - 1 do
            Item[i].Expand(True);

          tree_Parent.Selected := Item[Count - 1];
          tree_Parent.SetFocus;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

function TworkOrder_Frm.Get_SEQ_NO(aOrderNo: String): Integer;
var
  OraQuery: TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.OraSession1;
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT MAX(SEQ_NO) SEQ FROM DPMS_TMS_WORK_RESULT ' +
        'WHERE ORDER_NO LIKE :param1 ');
      ParamByName('param1').AsString := aOrderNo;
      Open;

      if RecordCount <> 0 then
        Result := FieldByName('SEQ').AsInteger
      else
        Result := 0;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure TworkOrder_Frm.Get_WorkOrders(aPlanNo: String);
var
  i, LRow: Integer;

begin
  with grid_orders do
  begin
    BeginUpdate;
    try
      ClearRows;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT A.*, B.CODE_NAME FROM ' + '( ' +
          '   SELECT * FROM DPMS_TMS_WORK_ORDERS ' + ') A, ' + '( ' +
          '   SELECT CAT_NO, CAT_NAME CODE_NAME FROM DPMS_TMS_WORK_CATEGORY UNION ALL '
          + '   SELECT GRP_NO, CODE_NAME FROM DPMS_TMS_WORK_CODEGRP ' + ') B ' +
          'WHERE A.CODE = B.CAT_NO ' + 'AND PLAN_NO = :param1  ' +
          'AND PERFORM = :param2  ' + 'ORDER BY SEQ_NO ');

        ParamByName('param1').AsString := aPlanNo;
        ParamByName('param2').AsDate := Today;
        Open;

        if RecordCount <> 0 then
        begin
          while not eof do
          begin
            if RowCount = 0 then
              LRow := AddRow
            else
            begin
              if FieldByName('PARENT_NO').AsString <> '' then
              begin
                LRow := -1;
                for i := 0 to RowCount - 1 do
                begin
                  if Cells[2, i] = FieldByName('PARENT_NO').AsString then
                  begin
                    AddChildRow(i, crLast);
                    LRow := LastAddedRow;
                    Break;
                  end;
                end;

                if LRow = -1 then
                  LRow := AddRow;
              end
              else
                LRow := AddRow;

            end;

            Cells[1, LRow] := FieldByName('PARENT_NO').AsString;
            Cells[2, LRow] := FieldByName('ORDER_NO').AsString;
            Cells[3, LRow] := FieldByName('CODE_NAME').AsString;

            Cells[12, LRow] := FieldByName('CODE_TYPE').AsString;
            if Cells[12, LRow] = 'C' then
            begin
              Set_Status_Of_Grid(FieldByName('STATUS').AsString, LRow);
            end
            else
            begin
              Cell[5, LRow].AsInteger := -1;
              Cell[6, LRow].AsInteger := -1;
              for i := 0 to Columns.Count - 1 do
                Cell[i, LRow].Color := clSilver;
            end;

            Cells[7, LRow] := FieldByName('CODE').AsString;

            Next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TworkOrder_Frm.grid_AttfilesCellDblClick(Sender: TObject;
ACol, ARow: Integer);
var
  lms: TMemoryStream;
  litem: TListItem;
  lFileName: String;
  lRegNo: String;

begin
  if ARow = -1 then
    Exit;

  lRegNo := grid_Attfiles.Cells[4, grid_Attfiles.SelectedRow];
  lFileName := grid_Attfiles.Cells[1, grid_Attfiles.SelectedRow];
  if lRegNo <> '' then
  begin
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from DPMS_TMS_ATTFILES ' + 'where REGNO = :param1 ');
      ParamByName('param1').AsString := lRegNo;
      Open;

      if not(RecordCount = 0) then
      begin
        lms := TMemoryStream.Create;
        try
          (FieldByName('Files') as TBlobField).SaveToStream(lms);
          lms.SaveToFile('C:\Temp\' + lFileName);

          ShellExecute(handle, 'open', PWideChar('C:\Temp\' + lFileName), nil,
            nil, SW_NORMAL);
        finally
          FreeAndNil(lms);
        end;
      end;
    end;
  end;
end;

procedure TworkOrder_Frm.grid_ordersCellDblClick(Sender: TObject;
ACol, ARow: Integer);
begin
  if ARow = -1 then
    Exit;

  with grid_orders do
  begin
    if Cells[12, ARow] = 'C' then
      Create_detailOrder_Frm(Cells[2, ARow], cb_part.Hint, cb_engType.Text);

  end;
end;

procedure TworkOrder_Frm.grid_ordersSelectCell(Sender: TObject;
ACol, ARow: Integer);
var
  i: Integer;
  LOrder_No, workers: String;
  ResultMsg: String;
  LResult: Boolean;
begin
  with grid_orders do
  begin
    if (ACol = 5) OR (ACol = 6) then
    begin
      case Cell[ACol, ARow].AsInteger of
        // 시작
        0:
          begin
            workers := Create_workerDialog_Frm(cb_part.Hint);
            if workers <> '' then
            begin
              Cell[9, ARow].AsString := DateTimeToStr(Now); // 시작시간 저장
              Cell[10, ARow].Clear; // 완료시간 클리어
              Cell[11, ARow].AsString := workers; // 작업자 저장

              with DM1.OraTransaction1 do
              begin
                StartTransaction;
                try
                  LResult := False;
                  if Update_Status_Of_Order(Cells[2, ARow], '진행') then
                  begin
                    LResult := Insert_Result_Of_Order(Cells[2, ARow],
                      Cells[9, ARow], '진행', workers);

                  end;
                finally
                  if LResult then
                  begin
                    Commit;
                    Set_Status_Of_Grid('진행', ARow);
                    Open_the_Work_sheet('시작',LOrder_No, Cells[7, ARow], Cells[3, ARow]);
                  end
                  else
                    Rollback;
                end;
              end;
            end
            else
              ShowMessage('먼저 담당자를 선택하여 주십시오!');
          end;

        // 완료
        1:
          begin
            LOrder_No := Cells[2, ARow]; // Order_No
            ResultMsg := Create_resultDialog_Frm('작업완료결과 입력','');
            Cell[10, ARow].AsString := DateTimeToStr(Now); // 완료시간 저장
            with DM1.OraTransaction1 do
            begin
              StartTransaction;
              try
                LResult := False;
                if Update_Status_Of_Order(Cells[2, ARow], '완료') then
                  LResult := Update_Result_Of_Order(Cells[2, ARow],
                    Cells[10, ARow], '완료', ResultMsg);

              finally
                if LResult then
                begin
                  Commit;
                  Set_Status_Of_Grid('완료', ARow);
                end
                else
                  Rollback;
              end;
            end;

            Open_the_Work_sheet('완료',LOrder_No, Cells[7, ARow], Cells[3, ARow]);

          end;

        // 중지
        3:
          begin
            ResultMsg := Create_resultDialog_Frm('작업중지사유 입력','');
            if ResultMsg <> '' then
            begin
              with DM1.OraTransaction1 do
              begin
                StartTransaction;
                try
                  LResult := False;
                  if Cell[5, ARow].AsInteger = 1 then
                  begin
                    // Update
                    Cell[10, ARow].AsString := DateTimeToStr(Now); // 완료시간 저장
                    if Update_Status_Of_Order(Cells[2, ARow], '중지') then
                      LResult := Update_Result_Of_Order(Cells[2, ARow],
                        Cells[10, ARow], '중지', ResultMsg);
                  end
                  else if (Cell[5, ARow].AsInteger = 0) OR
                    (Cell[5, ARow].AsInteger = 5) then
                  begin
                    // Insert
                    Cell[9, ARow].AsString := DateTimeToStr(Now); // 시작시간 저장
                    Cell[10, ARow].AsString := Cells[9, ARow]; // 완료시간 저장
                    if Update_Status_Of_Order(Cells[2, ARow], '중지') then
                    begin
                      if Insert_Result_Of_Order(Cells[2, ARow], Cells[9, ARow],
                        '중지', '') then
                        LResult := Update_Result_Of_Order(Cells[2, ARow],
                          Cells[10, ARow], '중지', ResultMsg);
                    end;
                  end;
                finally
                  if LResult then
                  begin
                    Commit;

                    ResultMsg := '작업중지발생 > 작업명 : ' + Cells[3, ARow] + '  ' +
                      ResultMsg;

                    ResultMsg := ReplaceStr(ResultMsg, '#10#13', ' ');
                    Send_StopMessage('업무관리시스템', '작업중지발생('+cb_engType.Text+')', ResultMsg);
                    Set_Status_Of_Grid('중지', ARow);
                  end
                  else
                    Rollback;
                end;
              end;
            end
            else
              ShowMessage('작업중지에 관한 사유를 입력하여 주십시오!');

            Open_the_Work_sheet('중지',LOrder_No, Cells[7, ARow], Cells[3, ARow]);
          end;

        // 계속
        5:
          begin
            workers := Create_workerDialog_Frm(cb_part.Hint);
            if workers <> '' then
            begin
              Cell[9, ARow].AsString := DateTimeToStr(Now); // 시작시간 저장
              Cell[10, ARow].Clear; // 완료시간 클리어
              Cell[11, ARow].AsString := workers; // 작업자 저장

              with DM1.OraTransaction1 do
              begin
                StartTransaction;
                try
                  LResult := False;
                  if Update_Status_Of_Order(Cells[2, ARow], '진행') then
                  begin
                    LResult := Insert_Result_Of_Order(Cells[2, ARow],
                      Cells[9, ARow], '진행', workers);

                  end;
                finally
                  if LResult then
                  begin
                    Commit;
                    Set_Status_Of_Grid('진행', ARow);
                  end
                  else
                    Rollback;
                end;
              end;
            end
            else
              ShowMessage('먼저 담당자를 선택하여 주십시오!');
          end;
      end;
    end;

    i := ARow + 4;
    if i < RowCount then
      ScrollToRow(ARow + 4)
    else
      ScrollToRow(RowCount - 1);
  end;
end;

function TworkOrder_Frm.Insert_Result_Of_Order(aOrderNo, aStart, aStatus,
  aWorker: String): Boolean;
begin
  Result := False;
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('INSERT INTO DPMS_TMS_WORK_RESULT ' +
      '(ORDER_NO, SEQ_NO, ACT_START, STATUS, LIST_OF_WORKERS, NUM_OF_WORKERS ) '
      + 'VALUES ' +
      '(:ORDER_NO, :SEQ_NO, :ACT_START, :STATUS, :LIST_OF_WORKERS, :NUM_OF_WORKERS ) ');

    ParamByName('ORDER_NO').AsString := aOrderNo;
    ParamByName('SEQ_NO').AsInteger := Get_SEQ_NO(aOrderNo) + 1;
    ParamByName('ACT_START').AsDateTime := StrToDateTime(aStart);
    ParamByName('STATUS').AsString := aStatus;
    ParamByName('LIST_OF_WORKERS').AsString := aWorker;
    ParamByName('NUM_OF_WORKERS').AsInteger := Get_Num_Of_Workers(aWorker);
    ExecSQL;
    Result := True;
  end;
end;

procedure TworkOrder_Frm.mi_AddFilesClick(Sender: TObject);
var
  i: Integer;
  lFileName: String;
  ms: TMemoryStream;
  LSize: Int64;
begin
  with grid_Attfiles do
  begin
    BeginUpdate;
    try
      if OpenDialog1.Execute then
      begin
        with DM1.OraQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('INSERT INTO DPMS_TMS_ATTFILES ' +
            '(OWNER, REGNO, FILENAME, FILESIZE, FILES) ' + 'VALUES ' +
            '(:OWNER, :REGNO, :FILENAME, :FILESIZE, :FILES) ');

          with OpenDialog1 do
          begin
            ms := TMemoryStream.Create;
            try
              for i := 0 to Files.Count - 1 do
              begin
                lFileName := Files.Strings[i];
                ms.LoadFromFile(lFileName);
                lFileName := ExtractFileName(lFileName);
                ms.Position := 0;
                LSize := ms.Size;

                ParamByName('OWNER').AsString := et_planNo.Text;
                ParamByName('REGNO').AsString :=
                  FormatDateTime('YYYYMMDDHHMMSSZZZ', Now);
                ParamByName('FILENAME').AsString := lFileName;
                ParamByName('FILESIZE').AsFloat := LSize;
                ParamByName('FILES').ParamType := ptInput;
                ParamByName('FILES').AsOraBlob.LoadFromStream(ms);
                sleep(10);
                ExecSQL;
              end;
            finally
              FreeAndNil(ms);
              ShowMessage('파일추가 성공!');
              Get_Attfiles(et_planNo.Text);
            end;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TworkOrder_Frm.N1Click(Sender: TObject);
var
  lms: TMemoryStream;
  litem: TListItem;
  lFileName: String;
  lRegNo: String;
begin
  lRegNo := grid_Attfiles.Cells[4, grid_Attfiles.SelectedRow];
  lFileName := grid_Attfiles.Cells[1, grid_Attfiles.SelectedRow];
  if lRegNo <> '' then
  begin
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from DPMS_TMS_ATTFILES ' + 'where REGNO = :param1 ');
      ParamByName('param1').AsString := lRegNo;
      Open;

      if not(RecordCount = 0) then
      begin
        lms := TMemoryStream.Create;
        try
          (FieldByName('Files') as TBlobField).SaveToStream(lms);
          lms.SaveToFile('C:\Temp\' + lFileName);

          ShellExecute(handle, 'open', PWideChar('C:\Temp\' + lFileName), nil,
            nil, SW_NORMAL);
        finally
          FreeAndNil(lms);
        end;
      end;
    end;
  end;
end;

procedure TworkOrder_Frm.N2Click(Sender: TObject);
var
  lms: TMemoryStream;
  litem: TListItem;
  lFileName: String;
  lDirectory: String;
  lRegNo: String;
begin
  lRegNo := grid_Attfiles.Cells[4, grid_Attfiles.SelectedRow];
  lFileName := grid_Attfiles.Cells[1, grid_Attfiles.SelectedRow];
  if lRegNo <> '' then
  begin
    SaveDialog1.FileName := lFileName;
    if SaveDialog1.Execute then
    begin
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from DPMS_TMS_ATTFILES ' + 'where REGNO = :param1 ');
        ParamByName('param1').AsString := lRegNo;
        Open;

        if not(RecordCount = 0) then
        begin
          lms := TMemoryStream.Create;
          try
            (FieldByName('Files') as TBlobField).SaveToStream(lms);
            lms.SaveToFile(SaveDialog1.FileName);

            lDirectory := ExtractFilePath
              (ExcludeTrailingBackslash(SaveDialog1.FileName));

            ShowMessage('파일저장 완료!');
            ShellExecute(handle, 'open', PWideChar(lDirectory), nil, nil,
              SW_NORMAL);
          finally
            FreeAndNil(lms);
          end;
        end;
      end;
    end;
  end;
end;

procedure TworkOrder_Frm.Open_the_Work_sheet(aAction_Time, aOrderNo, aCode, aCodeName: String);
var
  OraQuery: TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.OraSession1;

    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT A.*, B.ENG_PROJNO, B.ENG_TYPE FROM ' +
              '( ' +
              '   SELECT * FROM DPMS_TMS_WORK_CODE_SHEET ' +
              '   WHERE CODE IN ( ' +
              '     SELECT CODE FROM DPMS_TMS_WORK_CODEGRP ' +
              '     WHERE GRP_NO LIKE :groupNo ) ' +
              '   AND ACTION_TIME LIKE :ACTION_TIME ' +
              ') A LEFT OUTER JOIN TMS_PLAN B ' +
              'ON B.PLAN_NO LIKE :planNo ' +
              'AND B.PLAN_REV_NO = :revNo');

      ParamByName('groupNo').AsString := aCode;
      ParamByName('planNo').AsString := et_planNo.Text;
      ParamByName('revNo').AsInteger := StrToInt(et_planRevNo.Text);
      ParamByName('ACTION_TIME').AsString := aAction_Time;
      Open;

      if RecordCount <> 0 then
      begin
        while not eof do
        begin
          if SameText(FieldByName('CLASS_NAME').AsString, 'localSheet_Frm') then
            Create_localSheet_Frm(aOrderNo, aCodeName, FieldByName('ENG_PROJNO').AsString);

          if SameText(FieldByName('CLASS_NAME').AsString, 'shimDataSheet_Frm') then
            Create_shimDataSheet_Frm(aOrderNo, FieldByName('ENG_TYPE').AsString);

          if SameText(FieldByName('CLASS_NAME').AsString, 'checkChangePart_Frm') then
            Create_checkChangePart_Frm(aOrderNo, FieldByName('ENG_PROJNO').AsString);

          // if SameText(FieldByName('CLASS_NAME').AsString,'newMounted_Frm') then
          // Create_newMounted_Frm('a20140107', 'BF1562-18H32V');

          Next;
        end;
      end;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure TworkOrder_Frm.Send_StopMessage(aHeader, aTitle, aMsg: String);
var
  li, le: Integer;
  lflag, lhead, ltitle, lstr, lcontent: AnsiString;

  lIncharge: String;

begin
  // 헤더의 길이가 21byte를 넘지 않아야 함.
  // lhead := 'HiTEMS-업무관리시스템';
  // lhead := '123456789012345678901';
  // lhead    := '업무관리시스템';
  // ltitle   := '업무변경건';
  // lcontent := memo1.Text;

  lhead := aHeader;
  ltitle := aTitle;

  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT PLAN_EMPNO FROM DPMS_TMS_PLAN_INCHARGE ' +
      'WHERE PLAN_NO LIKE :param1 ' + 'AND PLAN_REV_NO = :param2 ');
    ParamByName('param1').AsString := et_planNo.Text;
    ParamByName('param2').AsInteger := StrToInt(et_planRevNo.Text);
    Open;

    if RecordCount <> 0 then
    begin
      while not eof do
      begin
        lIncharge := FieldByName('PLAN_EMPNO').AsString;

        for le := 0 to 1 do
        begin
          lcontent := aMsg;
          case le of
            0:
              lflag := 'A'; // 쪽지
            1:
              lflag := 'B'; // SMS
          end;

          if lflag = 'B' then
          begin
            while True do
            begin
              if lcontent = '' then
                Break;

              if Length(AnsiString(lcontent)) > 80 then
              begin
                lstr := Copy(lcontent, 1, 80);
                lcontent := Copy(lcontent, 81, Length(lcontent) - 80);
              end
              else
              begin
                lstr := Copy(lcontent, 1, Length(lcontent));
                lcontent := '';
              end;
              // 문자 메세지는 title(lstr)만 보낸다.
              Send_Message_Main_CODE(lflag, DM1.FUserInfo.CurrentUsers, lIncharge, lhead,
                lstr, ltitle);
            end;
          end
          else
          begin
            lstr := lcontent;
            Send_Message_Main_CODE(lflag, DM1.FUserInfo.CurrentUsers, lIncharge, lhead,
              ltitle, lstr);

          end;
        end;
        Next;
      end;
    end;
  end;
end;

procedure TworkOrder_Frm.Send_Message_Main_CODE(FFlag, FSendID, FRecID, FHead,
  FTitle, FContent: String);
var
  LTXK0SMS2: TXK0SMS2;
begin

  LTXK0SMS2 := TXK0SMS2.Create;
  try
    LTXK0SMS2.SEND_SABUN := FSendID;
    LTXK0SMS2.RCV_SABUN := FRecID;
    LTXK0SMS2.SYS_TYPE := '112';
    LTXK0SMS2.NOTICE_GUBUN := FFlag;

    LTXK0SMS2.TITLE := FTitle;
    // LTXK0SMS2.SEND_HPNO := '010-4190-6742';
    // LTXK0SMS2.RCV_HPNO := '010-3351-7553';
    LTXK0SMS2.CONTENT := FContent;
    LTXK0SMS2.ALIM_HEAD := FHead;

    SendHHIMessage(LTXK0SMS2);
  finally
    LTXK0SMS2.Free;
  end;
end;

procedure TworkOrder_Frm.Set_Status_Of_Grid(aStatus: String; ARow: Integer);
var
  i: Integer;
begin
  with grid_orders do
  begin
    BeginUpdate;
    try
      if aStatus = '대기' then
      begin
        Cell[5, ARow].AsInteger := 0;
        Cell[6, ARow].AsInteger := 3;
      end
      else if aStatus = '진행' then
      begin
        Cell[5, ARow].AsInteger := 1;
        Cell[6, ARow].AsInteger := 3;
        for i := 0 to Columns.Count - 1 do
        begin
          Cell[i, ARow].Color := clSkyBlue;
          Cell[i, ARow].TextColor := clBlue;
          Cell[i, ARow].FontStyle := Cell[i, ARow].FontStyle + [fsbold];
        end;
      end
      else if aStatus = '완료' then
      begin
        Cell[5, ARow].AsInteger := 2;
        Cell[6, ARow].AsInteger := 4;
        for i := 0 to Columns.Count - 1 do
        begin
          Cell[i, ARow].Color := $00AAFFAA;
          Cell[i, ARow].TextColor := clGrayText;
          Cell[i, ARow].FontStyle := Cell[i, ARow].FontStyle - [fsbold];
        end;
      end
      else if aStatus = '중지' then
      begin
        Cell[5, ARow].AsInteger := 5;
        Cell[6, ARow].AsInteger := 3;
        for i := 0 to Columns.Count - 1 do
        begin
          Cell[i, ARow].Color := $0071B8FF;
          Cell[i, ARow].TextColor := clRed;
          Cell[i, ARow].FontStyle := Cell[i, ARow].FontStyle - [fsbold];
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TworkOrder_Frm.Timer1Timer(Sender: TObject);
begin
  Label1.Caption := FormatDateTime('yyyy-MM-dd HH:mm:ss', Now);
end;

function TworkOrder_Frm.Update_Result_Of_Order(aOrderNo, aStop, aStatus,
  aMsg: String): Boolean;
begin
  Result := False;
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('UPDATE DPMS_TMS_WORK_RESULT SET ' +
      'ACT_STOP = :ACT_STOP, STATUS = :STATUS, REMARK = :REMARK ' +
      'WHERE ORDER_NO LIKE :ORDER_NO ' + 'AND SEQ_NO = :SEQ_NO ');
    ParamByName('ORDER_NO').AsString := aOrderNo;
    ParamByName('SEQ_NO').AsInteger := Get_SEQ_NO(aOrderNo);

    ParamByName('ACT_STOP').AsDateTime := StrToDateTime(aStop);
    ParamByName('STATUS').AsString := aStatus;
    ParamByName('REMARK').AsString := aMsg;
    ExecSQL;
    Result := True;
  end;
end;

function TworkOrder_Frm.Update_Status_Of_Order(aOrderNo,
  aStatus: String): Boolean;
var
  OraQuery: TOraQuery;
begin
  Result := False;
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.OraSession1;
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('UPDATE DPMS_TMS_WORK_ORDERS SET ' + 'STATUS = :param1 ' +
        'WHERE ORDER_NO LIKE :param2 ');
      ParamByName('param1').AsString := aStatus;
      ParamByName('param2').AsString := aOrderNo;
      ExecSQL;
      Result := True;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

end.
