unit makeOrder_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, JvExControls, JvLabel, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Vcl.StdCtrls, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, Vcl.ComCtrls, DateUtils, System.Generics.Collections,
  NxColumnClasses, NxColumns, Vcl.ImgList, Vcl.Touch.GestureCtrls, AeroButtons,
  Vcl.Menus, AdvOfficeStatusBar, StrUtils;

type
  TmakeOrder_Frm = class(TForm)
    Panel8: TPanel;
    Image1: TImage;
    Panel2: TPanel;
    JvLabel3: TJvLabel;
    cb_part: TComboBox;
    Panel1: TPanel;
    JvLabel2: TJvLabel;
    cb_plan: TComboBox;
    et_planNo: TEdit;
    et_planRevNo: TEdit;
    Panel3: TPanel;
    Panel4: TPanel;
    ImageList24x24: TImageList;
    JvLabel1: TJvLabel;
    JvLabel4: TJvLabel;
    Splitter1: TSplitter;
    grid_Orders: TNextGrid;
    NxTreeColumn2: TNxTreeColumn;
    NxTextColumn11: TNxTextColumn;
    NxTextColumn4: TNxTextColumn;
    NxIncrementColumn1: TNxIncrementColumn;
    btn_Ok: TAeroButton;
    NxTextColumn5: TNxTextColumn;
    NxTextColumn6: TNxTextColumn;
    ImageList16x16: TImageList;
    Panel5: TPanel;
    btn_Up: TAeroButton;
    btn_Down: TAeroButton;
    ImageList16x16b: TImageList;
    btn_Add: TAeroButton;
    btn_Del: TAeroButton;
    Panel6: TPanel;
    NxTextColumn7: TNxTextColumn;
    NxTextColumn8: TNxTextColumn;
    Panel7: TPanel;
    JvLabel5: TJvLabel;
    dt_perform: TDateTimePicker;
    grid_Code: TNextGrid;
    NxTreeColumn1: TNxTreeColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn9: TNxTextColumn;
    NxTextColumn10: TNxTextColumn;
    AeroButton3: TAeroButton;
    ImageList32x32: TImageList;
    AeroButton4: TAeroButton;
    et_Filter: TEdit;
    btn_lastOrder: TAeroButton;
    PopupMenu1: TPopupMenu;
    mi_Del: TMenuItem;
    statusBar: TAdvOfficeStatusBar;
    cb_engType: TComboBox;
    procedure cb_partDropDown(Sender: TObject);
    procedure cb_partSelect(Sender: TObject);
    procedure cb_planDropDown(Sender: TObject);
    procedure cb_planSelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure grid_OrdersDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure grid_OrdersDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure grid_OrdersSelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure btn_OkClick(Sender: TObject);
    procedure btn_UpClick(Sender: TObject);
    procedure btn_DownClick(Sender: TObject);
    procedure btn_DelClick(Sender: TObject);
    procedure btn_AddClick(Sender: TObject);
    procedure dt_performChange(Sender: TObject);
    procedure cb_partChange(Sender: TObject);
    procedure grid_CodeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AeroButton3Click(Sender: TObject);
    procedure AeroButton4Click(Sender: TObject);
    procedure et_FilterChange(Sender: TObject);
    procedure grid_CodeCustomDrawCell(Sender: TObject; ACol, ARow: Integer;
      CellRect: TRect; CellState: TCellState);
    procedure btn_lastOrderClick(Sender: TObject);
    procedure mi_DelClick(Sender: TObject);
    procedure grid_OrdersDataChange(Sender: TObject; AChangeType: TDataChange;
      const AIndex: Integer);
    procedure cb_engTypeDropDown(Sender: TObject);
  private
    { Private declarations }

    procedure Get_WorkList;
    function GetButtonRect(ARect:TRect;Level:Integer):TRect;
    procedure DeleteSelectedRows;

  public
    { Public declarations }

    function INSERT_TMS_WORK_ORDERS:Boolean;
    procedure Get_WorkOrders(aPlanNo:String);
  end;

var
  makeOrder_Frm: TmakeOrder_Frm;

implementation
uses
  workCode_Unit,
  lastOrder_Unit,
  HITEMS_TMS_CONST,
  DataModule_Unit;

{$R *.dfm}

procedure TmakeOrder_Frm.btn_lastOrderClick(Sender: TObject);
var
  LStr,
  LPlanNo,
  LPerform : String;
  i,
  LRow : Integer;
begin
  LStr := Create_lastOrder_Frm;
  Get_WorkOrders(et_planNo.Text);
  if LStr <> '' then
  begin
    with grid_Orders do
    begin
      BeginUpdate;
      try
        LPerform := Copy(LStr,1,POS(';',LStr)-1);
        LPlanNo  := Copy(LStr,POS(';',LStr)+1, Length(LStr)-POS(';',LStr)+1);
        with DM1.OraQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT A.*, B.CODE_NAME FROM ' +
                  '( ' +
                  '   SELECT * FROM DPMS_TMS_WORK_ORDERS ' +
                  ') A, ' +
                  '( ' +
                  '   SELECT CAT_NO, CAT_NAME CODE_NAME FROM DPMS_TMS_WORK_CATEGORY UNION ALL ' +
                  '   SELECT GRP_NO, CODE_NAME FROM DPMS_TMS_WORK_CODEGRP ' +
                  ') B ' +
                  'WHERE A.CODE = B.CAT_NO ' +
                  'AND PLAN_NO = :param1  ' +
                  'AND PERFORM = :param2  ' +
                  'ORDER BY SEQ_NO ');

          ParamByName('param1').AsString := LPlanNo;
          ParamByName('param2').AsDate   := StrToDateTime(LPerform);
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
                  for i := 0 to RowCount-1 do
                  begin
                    if Cells[2,i] = FieldByName('PARENT_NO').AsString then
                    begin
                      AddChildRow(i,crLast);
                      LRow := LastAddedRow;
                      Break;
                    end;
                  end;
                  if LRow = -1 then
                    LRow := AddRow;
                end else
                  LRow := AddRow;
              end;

              Cell[0,LRow].AsString := FieldByName('CODE_NAME').AsString;
              Cell[1,LRow].AsString := FieldByName('CODE').AsString;
              Cell[2,LRow].AsString := FieldByName('ORDER_NO').AsString;
              Cell[3,LRow].AsString := FieldByName('CODE_TYPE').AsString;
  //            Cell[4,i].Clear;

              if GetParent(LRow) <> -1 then
                Cell[5,LRow].AsString := Cell[6,GetParent(LRow)].AsString;

              Cell[6,LRow].AsString := 'ORN'+FormatDateTime('YYYYMMDDHHMMSSZZZ',Now);
              Cell[7,LRow].AsString := et_planNo.Text;

              if Cell[3,LRow].AsString = 'C' then
                Cell[8,LRow].AsString := '대기'
              else
                Cell[8,LRow].Clear;

              Cell[9,LRow].Clear;

              for i := 0 to Columns.Count-1 do
                Cell[i,LRow].TextColor := clBlue;

              sleep(10);
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

procedure TmakeOrder_Frm.btn_OkClick(Sender: TObject);
var
  i : Integer;
begin
  if grid_Orders.RowCount = 0 then
    Exit;

  if INSERT_TMS_WORK_ORDERS then
    ShowMessage('Success');

  with grid_Orders do
  begin
    BeginUpdate;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('UPDATE DPMS_TMS_WORK_ORDERS SET ' +
                'SEQ_NO = :SEQ_NO ' +
                'WHERE ORDER_NO LIKE :param1 ');

        for i := 0 To RowCount-1 do
        begin
          ParamByName('param1').AsString := Cells[6,i];
          ParamByName('SEQ_NO').AsString := Cells[4,i];
          ExecSQL;
        end;
      end;
    finally
      statusBar.Panels[1].Text := '';
      Get_WorkOrders(et_planNo.Text);
      EndUpdate;
    end;
  end;
end;

procedure TmakeOrder_Frm.AeroButton3Click(Sender: TObject);
begin
  if statusBar.Panels[1].Text = 'Modified' then
  begin

    if MessageDlg('변경된 항목이 있습니다. 변경된 내용을 적용 하시겠습니까? '+#10#13+
                  '적용되지 않은 항목은 유실될 수 있습니다.',
                  mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      btn_OkClick(Self);

    end;
  end;
  Close;
end;

procedure TmakeOrder_Frm.AeroButton4Click(Sender: TObject);
begin
  if statusBar.Panels[1].Text = 'Modified' then
  begin

    if MessageDlg('변경된 항목이 있습니다. 변경된 내용을 적용 하시겠습니까? '+#10#13+
                  '적용되지 않은 항목은 유실될 수 있습니다.',
                  mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      btn_OkClick(Self);

    end;
  end;

  if Create_workCode_Frm then
  begin
    Get_WorkList;
    Get_WorkOrders(et_planNo.Text);
  end;
end;

procedure TmakeOrder_Frm.btn_AddClick(Sender: TObject);
var
  i,j,
  LRow,
  LWRow,
  LToCnt,
  LStartRow : Integer;
  LMoveDic : TDictionary<String,Integer>;
begin
  with grid_Orders do
  begin
    if grid_Code.SelectedRow <> -1 then
    begin
      LStartRow := AddRow;
      LRow := LStartRow;

      LToCnt := grid_Code.GetChildCount(grid_Code.SelectedRow)+1;

      LMoveDic := TDictionary<String,Integer>.Create;
      try
        for i := 0 to LToCnt-1 do
        begin
          LWRow := grid_Code.SelectedRow+i;
          if i <> 0 then
          begin
            if LMoveDic.ContainsKey(grid_Code.Cells[2,LWRow]) then
            begin
              if LMoveDic.TryGetValue(grid_Code.Cells[2,LWRow],LRow) then
              begin
                AddChildRow(LRow,crLast);
                LRow := LastAddedRow;
              end;
            end else
              LRow := AddRow;

          end;

          for j := 0 to grid_Code.Columns.Count-1 do
            Cells[j,LRow] := grid_Code.Cells[j,LWRow];

          if GetParent(LRow) <> -1 then
            Cells[2,LRow] := Cells[1,GetParent(LRow)];

          Cell[5,LRow].Clear;
          Cell[6,LRow].Clear;
          Cell[7,LRow].Clear;

          if Cells[3,LRow] = 'C' then
            Cells[8,LRow] := '대기'
          else
            Cell[3,LRow].Clear;

          Cell[9,LRow].Clear;

          LMoveDic.Add(grid_Code.Cells[1,LWRow], LRow);
        end;
        SelectedRow := LStartRow;
        SetFocus;
      finally
        statusBar.Panels[1].Text := 'Modified';
        FreeAndNil(LMoveDic);
      end;
    end;
  end;
end;

procedure TmakeOrder_Frm.btn_DelClick(Sender: TObject);
var
  LRow : Integer;
begin
  DeleteSelectedRows;

//  with grid_Orders do
//  begin
//    if SelectedRow = -1 then
//      Exit
//    else
//      LRow := SelectedRow;
//
//    if MessageDlg('작업명 : '+Cells[0,SelectedRow]+#10#13+
//                  '삭제 하시겠습니까? 삭제된 정보는 복구할 수 없습니다.',
//                  mtConfirmation, [mbYes, mbNo], 0) = mrYes then
//    begin
//      with DM1.OraQuery1 do
//      begin
//        Close;
//        SQL.Clear;
//        SQL.Add('DELETE FROM TMS_WORK_ORDERS ' +
//                'WHERE ORDER_NO LIKE :param1 ');
//
//        ParamByName('param1').AsString := Cells[6,LRow];
//        ExecSQL;
//
//      end;
//
//      if HasChildren(SelectedRow) then
//        ClearChildRows(SelectedRow);
//
//      DeleteRow(SelectedRow);
//      statusBar.Panels[1].Text := '';
//    end;
//  end;
end;

procedure TmakeOrder_Frm.btn_DownClick(Sender: TObject);
var
  i,
  LToRow,
  LFromRow,
  LoopCnt : Integer;
begin
  with grid_Orders do
  begin
    BeginUpdate;
    try
      LFromRow := SelectedRow;
      LToRow := GetNextSibling(SelectedRow);
      if HasChildren(LToRow) then
        LToRow := LToRow + GetChildCount(LToRow);

      if GetChildCount(LFromRow) > 0 then
      begin
        LoopCnt := GetChildCount(LFromRow);
        for i := 0 to LoopCnt do
          MoveRow(LFromRow,LToRow);

        SelectedRow := LToRow-LoopCnt;
        SetFocus;
      end else
      begin
        MoveRow(LFromRow, LToRow);
        SelectedRow := LToRow;
        SetFocus;
      end;
    finally
      statusBar.Panels[1].Text := 'Modified';
      EndUpdate;
    end;
  end;

end;

procedure TmakeOrder_Frm.btn_UpClick(Sender: TObject);
var
  i,
  LToRow,
  LFromRow,
  LoopCnt : Integer;
begin
  with grid_Orders do
  begin
    BeginUpdate;
    try
      LToRow := GetPrevSibling(SelectedRow);
      LFromRow := SelectedRow;

      if GetChildCount(LFromRow) > 0 then
      begin
        LoopCnt := GetChildCount(LFromRow);
        for i := 0 to LoopCnt do
          MoveRow(LFromRow+i,LToRow+i);

        SelectedRow := LToRow;
        SetFocus;
      end else
      begin
        MoveRow(LFromRow, LToRow);
        SelectedRow := LToRow;
        SetFocus;
      end;
    finally
      statusBar.Panels[1].Text := 'Modified';
      EndUpdate;
    end;
  end;

end;

procedure TmakeOrder_Frm.cb_engTypeDropDown(Sender: TObject);
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
          if RecordCount > 0 then
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

procedure TmakeOrder_Frm.cb_partChange(Sender: TObject);
begin
  et_planNo.Clear;
  et_planRevNo.Clear;
  grid_Orders.ClearRows;
end;

procedure TmakeOrder_Frm.cb_partDropDown(Sender: TObject);
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
procedure TmakeOrder_Frm.cb_partSelect(Sender: TObject);
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

  cb_plan.Clear;
  cb_plan.Items.Clear;

  et_planNo.Clear;
  et_planRevNo.Clear;

  btn_lastOrder.Enabled := False;
  grid_orders.ClearRows;
end;

procedure TmakeOrder_Frm.cb_planDropDown(Sender: TObject);
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
          ParamByName('day').AsDate := dt_perform.Date;

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

//  if cb_part.Text <> '' then
//  begin
//    with cb_plan.Items do
//    begin
//      BeginUpdate;
//      try
//        Clear;
//        with DM1.OraQuery1 do
//        begin
//          Close;
//          SQL.Clear;
//          SQL.Add('SELECT * FROM ' +
//                  '( ' +
//                  '   SELECT PN, PRN, PLAN_NAME, PLAN_TYPE, PLAN_START, PLAN_END, PLAN_TEAM FROM ' +
//                  '   ( ' +
//                  '       SELECT PN, PRN, PLAN_NAME, PLAN_TYPE, PLAN_START, PLAN_END FROM ' +
//                  '       ( ' +
//                  '           SELECT PLAN_NO PN, MAX(PLAN_REV_NO) PRN FROM TMS_PLAN GROUP BY PLAN_NO ' +
//                  '       ) A, ' +
//                  '       ( ' +
//                  '           SELECT * FROM TMS_PLAN ' +
//                  '       ) B ' +
//                  '       WHERE A.PN = B.PLAN_NO ' +
//                  '       AND A.PRN = B.PLAN_REV_NO ' +
//                  '   ) A, ' +
//                  '   ( ' +
//                  '       SELECT PLAN_NO, MAX(PLAN_REV_NO) PLAN_REV_NO, PLAN_TEAM ' +
//                  '       FROM TMS_PLAN_INCHARGE GROUP BY PLAN_NO, PLAN_TEAM ' +
//                  '   ) B ' +
//                  '   WHERE A.PN = B.PLAN_NO ' +
//                  '   AND A.PRN = B.PLAN_REV_NO ' +
//                  ') ' +
//                  'WHERE PLAN_TEAM LIKE :team ' +
//                  'AND PLAN_TYPE = 1 ' +
//                  'AND (PLAN_START <= :day AND PLAN_END >= :day) ' +
//                  'ORDER BY PLAN_NAME, PLAN_START ');
//
//          ParamByName('team').AsString  := cb_part.Hint;
//          ParamByName('day').AsDate     := dt_perform.Date;
//          Open;
//
//          while not eof do
//          begin
//            Add(FieldByName('PLAN_NAME').AsString);
//            Next;
//          end;
//        end;
//      finally
//        EndUpdate;
//      end;
//    end;
//  end else
//    ShowMessage('먼저 반(소속)을 선택하여 주십시오!');
end;


procedure TmakeOrder_Frm.cb_planSelect(Sender: TObject);
begin
  with DM1.OraQuery1 do
  begin
    First;
    btn_lastOrder.Enabled := False;
    while not eof do
    begin
      if cb_plan.ItemIndex = RecNo-1 then
      begin
        et_planNo.Text := FieldByName('PN').Text;
        et_planRevNo.Text := FieldByName('PRN').Text;
        btn_lastOrder.Enabled := True;
        Get_WorkOrders(et_planNo.Text);
        Break;
      end;
      Next;
    end;
    grid_orders.SetFocus;
  end;
end;

procedure TmakeOrder_Frm.DeleteSelectedRows;
var
  LRow : Integer;
  i: Integer;
begin
  with grid_Orders do
  begin
    BeginUpdate;
    try
      if SelectedRow = -1 then
        Exit;

      if MessageDlg('선택된 항목을 삭제 하시겠습니까? '+#10#13+'삭제된 정보는 복구할 수 없습니다.',
                    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        for i := RowCount-1 DownTo 0 do
        begin
          if Row[i].Selected then
          begin
            with DM1.OraQuery1 do
            begin
              Close;
              SQL.Clear;
              SQL.Add('DELETE FROM DPMS_TMS_WORK_ORDERS ' +
                      'WHERE ORDER_NO LIKE :param1 ');

              ParamByName('param1').AsString := Cells[6,i];
              ExecSQL;

            end;

            if HasChildren(i) then
              ClearChildRows(i);

            DeleteRow(i);
          end;
        end;

        statusBar.Panels[1].Text := '';
        for i := 0 to RowCount-1 do
          if Cell[0,i].TextColor = clBlue then
            statusBar.Panels[1].Text := 'Modified';
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TmakeOrder_Frm.dt_performChange(Sender: TObject);
begin
  if (cb_part.Hint <> '') and (et_planNo.Text <> '') then
    Get_WorkOrders(et_planNo.Text)
  else
  begin
    et_planNo.Clear;
    et_planRevNo.Clear;
    grid_Orders.ClearRows;
  end;
end;

procedure TmakeOrder_Frm.et_FilterChange(Sender: TObject);
var
  i: Integer;
  s: string;
  RowVisible: Boolean;
begin
  for i := 0 to grid_Code.RowCount - 1 do
  begin
    s := UpperCase(et_Filter.Text);
    RowVisible := (s = '') or (Pos(s, UpperCase(grid_Code.Cell[0, i].AsString)) > 0);
    grid_Code.RowVisible[i] := RowVisible;
  end;
end;

procedure TmakeOrder_Frm.FormCreate(Sender: TObject);
begin
  dt_perform.Date := Today;
  Get_WorkList;
end;

function TmakeOrder_Frm.GetButtonRect(ARect: TRect; Level: Integer): TRect;
var
  m, t: Integer;
begin
  m := ARect.Top + (ARect.Bottom - ARect.Top) div 2;
  t := m - 5;
  with Result do
  begin
    Left := Level * 19;
    Left := ARect.Left + Level * 19;
    Right := Left + 9;
    Top := ARect.Top;
    Bottom := Top + 3;
  end;
  OffsetRect(Result, 15, 3);
end;

procedure TmakeOrder_Frm.Get_WorkList;
var
  i,
  LRow : Integer;
begin
  with grid_Code do
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
                '   (SELECT CAT_NAME, CAT_NO, PARENT_NO, CAT_LV, SEQ_NO, ' +
                '   USE_YN, ''S'' TYPE FROM DPMS_TMS_WORK_CATEGORY) UNION ALL ' +
                '   (SELECT CODE_NAME, GRP_NO, CAT_NO, 3 LV, SEQ_NO, USE_YN, ''C'' TYPE ' +
                '   FROM DPMS_TMS_WORK_CODEGRP) ' +
                ') ' +
                'WHERE USE_YN = ''Y'' ' +
                'START WITH PARENT_NO IS NULL ' +
                'CONNECT BY PRIOR CAT_NO = PARENT_NO ' +
                'ORDER SIBLINGS BY SEQ_NO ');
        Open;

        if RecordCount <> 0 then
        begin
          while not eof do
          begin
            if RowCount = 0 then
              LRow := AddRow(1)
            else
            begin
              if FieldByName('PARENT_NO').AsString <> '' then
              begin
                for i := 0 to RowCount-1 do
                begin
                  if Cells[1,i] = FieldByName('PARENT_NO').AsString then
                  begin
                    AddChildRow(i,crLast);
                    LRow := LastAddedRow;
                    Break;
                  end;
                end;
              end else
                LRow := AddRow(1);

            end;

            Cells[0,LRow] := FieldByName('CAT_NAME').AsString;
            Cells[1,LRow] := FieldByName('CAT_NO').AsString;
            Cells[2,LRow] := FieldByName('PARENT_NO').AsString;
            Cells[3,LRow] := FieldByName('TYPE').AsString;
            Next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TmakeOrder_Frm.Get_WorkOrders(aPlanNo: String);
var
  i,
  LRow : Integer;

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
        SQL.Add('SELECT A.*, B.CODE_NAME FROM ' +
                '( ' +
                '   SELECT * FROM DPMS_TMS_WORK_ORDERS ' +
                ') A, ' +
                '( ' +
                '   SELECT CAT_NO, CAT_NAME CODE_NAME FROM DPMS_TMS_WORK_CATEGORY UNION ALL ' +
                '   SELECT GRP_NO, CODE_NAME FROM DPMS_TMS_WORK_CODEGRP ' +
                ') B ' +
                'WHERE A.CODE = B.CAT_NO ' +
                'AND PLAN_NO = :param1  ' +
                'AND PERFORM = :param2  ' +
                'ORDER BY SEQ_NO ');

        ParamByName('param1').AsString  := aPlanNo;
        ParamByName('param2').AsDate    := dt_perform.Date;
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
                for i := 0 to RowCount-1 do
                begin
                  if Cells[6,i] = FieldByName('PARENT_NO').AsString then
                  begin
                    AddChildRow(i,crLast);
                    LRow := LastAddedRow;
                    Break;
                  end;
                end;

                if LRow = -1 then
                  LRow := AddRow;
              end else
                LRow := AddRow;

            end;

            Cells[0,LRow] := FieldByName('CODE_NAME').AsString;
            Cells[1,LRow] := FieldByName('CODE').AsString;
            Cell[2,LRow].Clear;
            Cells[3,LRow] := FieldByName('CODE_TYPE').AsString;
            // Cells[4,LRow] := 자동정렬
            Cells[5,LRow] := FieldByName('PARENT_NO').AsString;
            Cells[6,LRow] := FieldByName('ORDER_NO').AsString;
            Cells[7,LRow] := FieldByName('PLAN_NO').AsString;
            Cells[8,LRow] := FieldByName('STATUS').AsString;
//            Cells[9,LRow] := FieldByName('STATUS').AsString;

            Next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;


procedure TmakeOrder_Frm.grid_CodeCustomDrawCell(Sender: TObject; ACol,
  ARow: Integer; CellRect: TRect; CellState: TCellState);
var
  s : String;
  LRect : TRect;
  LCanvas : TCanvas;
  bmp : TBitmap;
begin
  with Sender as TNextGrid do
  begin
    if ACol = 0 then
    begin
      LRect := GetButtonRect(CellRect,GetLevel(ARow));
      s := Cells[0,ARow];
      LCanvas := Canvas;
      LCanvas.FillRect(LRect);

      bmp := TBitmap.Create;
      try
        if Cells[3,ARow] = 'C' then
          ImageList16x16.GetBitmap(5,bmp)
        else
          ImageList16x16.GetBitmap(4,bmp);

        if bmp <> nil then
          LCanvas.Draw(LRect.Left, LRect.Top, bmp);

      finally
        bmp.Free;
      end;
    end;
  end;
end;

procedure TmakeOrder_Frm.grid_CodeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    with Sender as TNextGrid do
    begin
      if GetRowAtPos(X,Y) <> -1 then
        BeginDrag(False);
    end;
  end;
end;

procedure TmakeOrder_Frm.grid_OrdersDataChange(Sender: TObject;
  AChangeType: TDataChange; const AIndex: Integer);
begin
  if grid_Orders.RowCount = 0 then
    statusBar.Panels[1].Text := '';

end;

procedure TmakeOrder_Frm.grid_OrdersDragDrop(Sender, Source: TObject; X,Y: Integer);
var
  i,j,
  LRow,
  LToCnt,
  LStartRow : Integer;
  LMoveDic : TDictionary<String,Integer>;
  LWRow : Integer;
begin
  if Source is TNextGrid then
  begin
    with grid_Orders do
    begin
      BeginUpdate;
      try
        LStartRow := GetRowAtPos(X,Y);
        if LStartRow > -1 then
        begin
          AddChildRow(LStartRow);
          LStartRow := LastAddedRow;
        end else
          LStartRow := AddRow;

        LRow := LStartRow;

        LToCnt := grid_Code.GetChildCount(grid_Code.SelectedRow)+1;

        LMoveDic := TDictionary<String,Integer>.Create;
        try
          for i := 0 to LToCnt-1 do
          begin
            LWRow := grid_Code.SelectedRow+i;
            if i <> 0 then
            begin
              if LMoveDic.ContainsKey(grid_Code.Cells[2,LWRow]) then
              begin
                if LMoveDic.TryGetValue(grid_Code.Cells[2,LWRow],LRow) then
                begin
                  AddChildRow(LRow,crLast);
                  LRow := LastAddedRow;
                end;
              end else
                LRow := AddRow;

            end;

            for j := 0 to grid_Code.Columns.Count-1 do
              Cells[j,LRow] := grid_Code.Cells[j,LWRow];

            if GetParent(LRow) <> -1 then
              Cells[2,LRow] := Cells[1,GetParent(LRow)];

            if GetParent(LRow) <> -1 then
              Cell[5,LRow].AsString := Cell[6,GetParent(LRow)].AsString;

            Cell[6,LRow].AsString := 'ORN'+FormatDateTime('YYYYMMDDHHMMSSZZZ',Now);
            Cell[7,LRow].AsString := et_planNo.Text;

            if Cells[3,LRow] = 'C' then
              Cells[8,LRow] := '대기'
            else
              Cell[3,LRow].Clear;

            Cell[9,LRow].Clear;

            for j := 0 to Columns.Count-1 do
              Cell[j,LRow].TextColor := clBlue;

            LMoveDic.Add(grid_Code.Cells[1,LWRow], LRow);
            sleep(10);
          end;
          SelectedRow := LStartRow;
          SetFocus;
        finally
          FreeAndNil(LMoveDic);
        end;
      finally
        statusBar.Panels[1].Text := 'Modified';
        EndUpdate;
      end;
    end;
  end;
end;

procedure TmakeOrder_Frm.grid_OrdersDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  if (Source is TNextGrid) AND (cb_plan.Text <> '') then
    Accept := True
  else
    Accept := False;

end;

procedure TmakeOrder_Frm.grid_OrdersSelectCell(Sender: TObject; ACol,
  ARow: Integer);
begin
  if ARow = -1 then
    Exit;

  with grid_Orders do
  begin
    if GetPrevSibling(ARow) > -1 then
      btn_Up.Enabled := True
    else
      btn_Up.Enabled := False;

    if GetNextSibling(ARow) > -1 then
      btn_Down.Enabled := True
    else
      btn_Down.Enabled := False;

    Invalidate;
  end;
end;

function TmakeOrder_Frm.INSERT_TMS_WORK_ORDERS: Boolean;
var
  i : Integer;
  LParentNo:String;
begin
  Result := False;
  with grid_Orders do
  begin
    BeginUpdate;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('INSERT INTO DPMS_TMS_WORK_ORDERS ' +
                '( ' +
                '   PLAN_NO, PARENT_NO, ORDER_NO, SEQ_NO, PERFORM, CODE, ' +
                '   CODE_TYPE, STATUS, DRAFTER ' +
                ') VALUES ' +
                '(' +
                '   :PLAN_NO, :PARENT_NO, :ORDER_NO, :SEQ_NO, :PERFORM, :CODE, ' +
                '   :CODE_TYPE, :STATUS, :DRAFTER ' +
                ') ');

        for i := 0 to RowCount-1 do
        begin
          if Cell[6,i].TextColor <> clBlue then
            Continue;

          ParamByName('PLAN_NO').AsString   := Cells[7,i];
          ParamByName('PARENT_NO').AsString := Cells[5,i];
          ParamByName('ORDER_NO').AsString  := Cells[6,i];
          ParamByName('SEQ_NO').AsInteger   := Cell[4,i].AsInteger;
          ParamByName('PERFORM').AsDate     := dt_perform.Date;

          ParamByName('CODE').AsString      := Cells[1,i];
          ParamByName('CODE_TYPE').AsString := Cells[3,i];
          ParamByName('STATUS').AsString    := Cells[8,i];
          ParamByName('DRAFTER').AsString   := DM1.FUserInfo.CurrentUsers;
          ExecSQL;
        end;
        Result := True;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TmakeOrder_Frm.mi_DelClick(Sender: TObject);
begin
  DeleteSelectedRows;
end;

end.
