unit taskManagement_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, NxCollection,
  Vcl.StdCtrls, Vcl.Grids, AdvObj, BaseGrid, AdvGrid, AdvPanel, AdvPageControl,
  Vcl.ComCtrls, Vcl.Imaging.jpeg, NxScrollControl, NxCustomGridControl, Ora,
  NxCustomGrid, NxGrid, AdvGroupBox, AdvOfficeButtons, NxColumnClasses,
  NxColumns, NxEdit, DateUtils, StrUtils, Vcl.ActnList, Vcl.Menus,
  AdvGlowButton,
  NxGridPrint, Vcl.ImgList, Vcl.OleCtrls, EXG2ANTTLib_TLB, AeroButtons,
  JvExControls, JvLabel, CurvyControls, System.Generics.Collections,
  OmniXML, OmniXMLUtils, OmniXMLXPath, JvBaseDlg, JvProgressDialog;

type
  TGetTaskThread = class(TThread)
  private
    iCnt: Integer;
    FBeginDate, FEndDate, FTeam: String;
    FProgressDlg: TJvProgressDialog;
    Fgrid_Task, FGridPlan: TNextGrid;
    procedure SetProgressDlg(aDialog: TJvProgressDialog);
    procedure SetGridTask(aGrid: TNextGrid);
    procedure SetGridPlan(aGrid: TNextGrid);
  protected
    procedure Display;
    procedure DisplayPlan;
    procedure DisplayPlan2;
    procedure Execute; override;
  public
    FReqNo: string;

    constructor Create;
    destructor Destroy; override;
    function Check_Task_Edit_Authority(aTaskNo, aUserId: String): Boolean;
    property grid_Task: TNextGrid read Fgrid_Task write SetGridTask;
    property grid_Plan: TNextGrid read FGridPlan write SetGridPlan;
    property ProgressDlg: TJvProgressDialog read FProgressDlg
      write SetProgressDlg;
  end;

type
  TtaskManagement_Frm = class(TForm)
    Panel8: TPanel;
    Image1: TImage;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    ImageList1: TImageList;
    CurvyPanel1: TCurvyPanel;
    JvLabel2: TJvLabel;
    JvLabel4: TJvLabel;
    JvLabel5: TJvLabel;
    JvLabel6: TJvLabel;
    CurvyPanel2: TCurvyPanel;
    Label4: TLabel;
    rg_period: TAdvOfficeRadioGroup;
    dt_begin: TDateTimePicker;
    dt_end: TDateTimePicker;
    cb_engModel: TComboBox;
    cb_engType: TComboBox;
    cb_engProjNo: TComboBox;
    AeroButton2: TAeroButton;
    AeroButton3: TAeroButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    NxSplitter1: TNxSplitter;
    Panel3: TPanel;
    AdvGlowButton1: TAdvGlowButton;
    AdvGlowButton2: TAdvGlowButton;
    taskDownBtn: TAdvGlowButton;
    taskUpBtn: TAdvGlowButton;
    taskGrid: TNextGrid;
    NxTextColumn1: TNxTextColumn;
    NxTreeColumn1: TNxTreeColumn;
    EXD_TASK_START: TNxDateColumn;
    EXD_TASK_END: TNxDateColumn;
    ACT_TASK_START: TNxDateColumn;
    ACT_TASK_END: TNxDateColumn;
    ACT_PROGRESS: TNxProgressColumn;
    TASK_STATE: TNxComboBoxColumn;
    NxTextColumn11: TNxTextColumn;
    NxTextColumn13: TNxTextColumn;
    NxTextColumn16: TNxTextColumn;
    NxImageColumn2: TNxImageColumn;
    panel2: TPanel;
    addTask: TButton;
    planGrid: TNextGrid;
    NxIncrementColumn2: TNxIncrementColumn;
    NxTextColumn7: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    NxTextColumn10: TNxTextColumn;
    NxComboBoxColumn1: TNxComboBoxColumn;
    NxTextColumn14: TNxTextColumn;
    NxTextColumn15: TNxTextColumn;
    NxTextColumn8: TNxTextColumn;
    NxTextColumn9: TNxTextColumn;
    NxTextColumn12: TNxTextColumn;
    NxDateColumn4: TNxDateColumn;
    NxDateColumn3: TNxDateColumn;
    planProgressColumn: TNxProgressColumn;
    NxImageColumn1: TNxImageColumn;
    Panel1: TPanel;
    addTaskBtn: TAdvGlowButton;
    TabSheet2: TTabSheet;
    G2antt1: TG2antt;
    NxNumberColumn1: TNxNumberColumn;
    startTimer: TTimer;
    JvLabel1: TJvLabel;
    cb_team: TComboBox;
    btn_dpms: TAdvGlowButton;
    SaveDialog1: TSaveDialog;
    JvProgressDialog1: TJvProgressDialog;
    rb_hide: TRadioButton;
    rb_All: TRadioButton;
    btn_testInfo: TButton;
    NxImageColumn3: TNxImageColumn;
    PopupMenu2: TPopupMenu;
    mi_viewInfo: TMenuItem;
    mi_newInfo: TMenuItem;
    JvLabel3: TJvLabel;
    reqnoedit: TNxButtonEdit;
    N3: TMenuItem;
    AliasType: TNxTextColumn;
    Button1: TButton;
    PopupMenu3: TPopupMenu;
    oDoList1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure planGridCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure taskGridCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure taskGridSelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure taskGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N1Click(Sender: TObject);
    procedure addTaskClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure AdvGlowButton1Click(Sender: TObject);
    procedure AdvGlowButton2Click(Sender: TObject);
    procedure taskUpBtnClick(Sender: TObject);
    procedure addTaskBtnClick(Sender: TObject);
    procedure taskGridCellFormating(Sender: TObject; ACol, ARow: Integer;
      var TextColor: TColor; var FontStyle: TFontStyles; CellState: TCellState);
    procedure planGridCellFormating(Sender: TObject; ACol, ARow: Integer;
      var TextColor: TColor; var FontStyle: TFontStyles; CellState: TCellState);
    procedure taskGridAfterEdit(Sender: TObject; ACol, ARow: Integer;
      Value: WideString);
    procedure taskGridBeforeEdit(Sender: TObject; ACol, ARow: Integer;
      var Accept: Boolean);
    procedure rg_periodClick(Sender: TObject);
    procedure cb_engModelDropDown(Sender: TObject);
    procedure cb_engTypeDropDown(Sender: TObject);
    procedure cb_engProjNoDropDown(Sender: TObject);
    procedure AeroButton3Click(Sender: TObject);
    procedure AeroButton2Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure startTimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cb_teamDropDown(Sender: TObject);
    procedure cb_teamSelect(Sender: TObject);
    procedure btn_dpmsClick(Sender: TObject);
    procedure rb_AllClick(Sender: TObject);
    procedure rb_hideClick(Sender: TObject);
    procedure it_addTaskClick(Sender: TObject);
    procedure planGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btn_testInfoClick(Sender: TObject);
    procedure btn_testInfoDropDownClick(Sender: TObject);
    procedure mi_viewInfoClick(Sender: TObject);
    procedure mi_newInfoClick(Sender: TObject);
    procedure reqnoeditButtonClick(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure planGridCellColoring(Sender: TObject; ACol, ARow: Integer;
      var CellColor, GridColor: TColor; CellState: TCellState);
    procedure oDoList1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure JvLabel2Click(Sender: TObject);
  private
    { Private declarations }
    FcurrentTaskNo: String;
    FcurrentPlanNo: String;
    FbeforeValues: Variant;
  public
    { Public declarations }
    GetTaskThread: TGetTaskThread;

    procedure Add_new_task(ARow: Integer);
    procedure Add_new_Plan(ARow: Integer);
    procedure Add_new_ToDo(ARow: Integer);
    procedure ApplyToDo2PlanGrid;

    procedure Get_HiTEMS_TMS_TASK(aTask_No: String);

    procedure Get_HiTEMS_TMS_TASK_PLAN(aTask_No: String);
    procedure Update_Task_Order;

    function Check_Task_Edit_Authority(aTaskNo, aUserId: String): Boolean;

    function Update_Task(ACol, ARow: Integer): Boolean;
    function Get_Test_Request_No(aPlanNo:String):String;

    // gantt
    procedure Init_ganttChart;
    procedure Set_GanttChart(const atBegin, atEnd, aTeam, aModel, aType,
      aProjno: String);

  end;

  // const
  // teamList : array[0..2] of string = ('K2B1','K2B2','K2B3');
var
  taskManagement_Frm: TtaskManagement_Frm;

implementation

uses
  testRequest_Unit,
  sendSMS_Unit,
  newTaskPlan_Unit,
  setProgress_Unit,
  newTask_Unit,
  CommonUtil_Unit,
  HiTEMS_TMS_COMMON,
  HiTEMS_TMS_CONST,
  taskMain_Unit,
  DataModule_Unit,
  testStatus_Unit,
  ToDoList_Unit;

{$R *.dfm}
{ Tschedule_Frm }

procedure TtaskManagement_Frm.addTaskClick(Sender: TObject);
begin
  Add_new_Plan(taskGrid.SelectedRow);
end;

procedure TtaskManagement_Frm.Add_new_task(ARow: Integer);
var
  lParent_No: String;
  i, lrow, lTaskLv: Integer;
  lResult: String;
  lstartDate, lendDate: TDateTime;
  lteamCode: String;
  lCurrentTeam: String;
begin
  with taskGrid do
  begin
    lteamCode := cb_team.Hint;
    lstartDate := dt_begin.Date;
    lendDate := dt_end.Date;

    if ARow <> -1 then
    begin
      lParent_No := Cells[0, ARow];

      lCurrentTeam := LeftStr(DM1.FUserInfo.CurrentUsersTeam, 4);
      lTaskLv := GetLevel(ARow);
      if Check_Authority_of_addTask(lParent_No, lCurrentTeam) = True then
      begin
        lResult := Create_newTask_Frm('', lParent_No, lteamCode, lTaskLv,
          lstartDate, lendDate);
      end
      else
        ShowMessage('일정을 추가 권한이 없습니다.');
    end
    else
    begin
      lResult := Create_newTask_Frm('', '', lteamCode, 0, lstartDate, lendDate);
    end;

    if lResult <> '' then
    begin
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM DPMS_TMS_TASK ' + 'WHERE TASK_NO = :param1 ');
        ParamByName('param1').AsString := lResult;
        Open;

        if RecordCount <> 0 then
        begin
          if FieldByName('TASK_PRT').AsString <> '' then
          begin
            for i := 0 to RowCount - 1 do
            begin
              if FieldByName('TASK_PRT').AsString = Cells[0, i] then
              begin
                AddChildRow(i, crLast);
                lrow := LastAddedRow;
                Break;
              end;
            end;
          end
          else
          begin
            lrow := AddRow;
          end;

          Cells[0, lrow] := FieldByName('TASK_NO').AsString;
          Cells[1, lrow] := FieldByName('TASK_NAME').AsString;

          if not FieldByName('EXD_TASK_START').IsNull then
            Cell[2, lrow].AsDateTime := FieldByName('EXD_TASK_START')
              .AsDateTime;

          if not FieldByName('EXD_TASK_END').IsNull then
            Cell[3, lrow].AsDateTime := FieldByName('EXD_TASK_END').AsDateTime;

          if not FieldByName('ACT_TASK_START').IsNull then
            Cell[4, lrow].AsDateTime := FieldByName('ACT_TASK_START')
              .AsDateTime;

          if not FieldByName('ACT_TASK_END').IsNull then
            Cell[5, lrow].AsDateTime := FieldByName('ACT_TASK_END').AsDateTime;

          Cell[6, lrow].AsInteger := FieldByName('ACT_PROGRESS').AsInteger;
          Cells[7, lrow] := FieldByName('TASK_STATE').AsString;
          Cells[8, lrow] := Get_UserName(FieldByName('TASK_MANAGER').AsString);
          Cells[9, lrow] := Get_UserName(FieldByName('TASK_DRAFTER').AsString);
          Cells[10, lrow] := FieldByName('TASK_ORDER').AsString;

          if Check_Task_Edit_Authority(Cells[0, lrow], DM1.FUserInfo.CurrentUsers) then
            Cell[11, lrow].AsInteger := 0
          else
            Cell[11, lrow].AsInteger := -1;

        end;
      end;
      SelectedRow := lrow;
      planGrid.ClearRows;
    end;
  end;
end;

procedure TtaskManagement_Frm.Add_new_ToDo(ARow: Integer);
var
  lResult: Boolean;
  lplanNo: String;
  lstartDate, lendDate: TDateTime;
  lteamCode: String;
begin
  with planGrid do
  begin
    if ARow <> -1 then
    begin
//      lCurrentTeam := LeftStr(DM1.FUserInfo.CurrentUsersTeam, 4);
      lplanNo := Cells[3, ARow];
//      DM1.GetToDoListFromDB(lplanNo, DM1.FToDoCollect4Alarm);

      lResult := Create_ToDoList_Frm(lplanNo);

      if lResult = True then
//        Get_HiTEMS_TMS_TASK_PLAN(lTask_NO);
    end
    else
      ShowMessage('먼저 계획을 선택하여 주십시오!');
  end;
end;

procedure TtaskManagement_Frm.Add_new_Plan(ARow: Integer);
var
  lTask_NO: String;
  lResult: Boolean;
  lCurrentTeam: String;
  lstartDate, lendDate: TDateTime;
  lteamCode: String;
begin
  with taskGrid do
  begin
    lteamCode := cb_team.Hint;
    lstartDate := dt_begin.Date;
    lendDate := dt_end.Date;

    if ARow <> -1 then
    begin
      lTask_NO := Cells[0, ARow];
      lCurrentTeam := LeftStr(DM1.FUserInfo.CurrentUsersTeam, 4);
      if Check_Authority_of_addTask(lTask_NO, lCurrentTeam) = True then
      begin
        lResult := Create_newPlan_Frm(lTask_NO, '', lteamCode, lstartDate,
          lendDate, 0);

        if lResult = True then
          Get_HiTEMS_TMS_TASK_PLAN(lTask_NO);

      end
      else
        ShowMessage('업무등록 권한이 없습니다.');
    end
    else
      ShowMessage('먼저 일정을 선택하여 주십시오!');
  end;
end;

procedure TtaskManagement_Frm.AdvGlowButton1Click(Sender: TObject);
var
  li: Integer;
begin
  with taskGrid do
  begin
    BeginUpdate;
    try
      for li := 0 to RowCount - 1 do
      begin
        if GetFirstChild(li) > 0 then
          Expanded[li] := True;

      end;
    finally
      ScrollToRow(SelectedRow);
      EndUpdate;
    end;
  end;
end;

procedure TtaskManagement_Frm.AdvGlowButton2Click(Sender: TObject);
var
  li: Integer;
begin
  with taskGrid do
  begin
    BeginUpdate;
    try
      for li := 0 to RowCount - 1 do
      begin
        if GetFirstChild(li) > 0 then
          Expanded[li] := False;

      end;
    finally
      ScrollToRow(SelectedRow);
      EndUpdate;
    end;
  end;
end;

procedure TtaskManagement_Frm.AeroButton2Click(Sender: TObject);
begin
  Close;
end;

procedure TtaskManagement_Frm.AeroButton3Click(Sender: TObject);
var
  lbegin, lend, lteam, lmodel, ltype, lprojno: String;
begin
  GetTaskThread := TGetTaskThread.Create;
  with GetTaskThread do
  begin
    iCnt := 0;
    FBeginDate := FormatDateTime('yyyy-MM-dd', dt_begin.Date);
    FEndDate := FormatDateTime('yyyy-MM-dd', dt_end.Date);
    FTeam := cb_team.Hint;
    FReqNo := reqnoedit.Text;
    SetProgressDlg(Self.JvProgressDialog1);
    SetGridTask(Self.taskGrid);
    SetGridPlan(Self.PlanGrid);
    resume;
    JvProgressDialog1.ShowModal;
  end;

  // AeroButton3.Enabled := False;
  //
  // Get_HiTEMS_TMS_TASK('');
  //
  // lend   := FormatDateTime('yyyy-MM-dd',dt_end.Date);
  // lteam  := teamList[rg_team.ItemIndex];
  // lmodel := cb_engModel.Text;
  // ltype  := cb_engType.Text;
  // lprojno:= cb_engProjNo.Text;
end;

procedure TtaskManagement_Frm.ApplyToDo2PlanGrid;
begin

end;

procedure TtaskManagement_Frm.btn_dpmsClick(Sender: TObject);
var
  MyResourceStream: TResourceStream;
  XMLDocument: IXMLDocument;
  expression: string;
  expressionList: string;
  iNode: Integer;
  nodeList: IXMLNodeList;
  Element: IXMLElement;
  lId, p: Integer;
  lNode, queryNode: IXMLNode;
  validResult: Boolean;
  nodeDic: TDictionary<string, IXMLNode>;
begin
  MyResourceStream := TResourceStream.Create(hInstance, 'dpms', RT_RCDATA);
  try
    Screen.Cursor := crHourGlass;
    try
      XMLDocument := CreateXMLDoc;
      with XMLDocument do
      begin
        XMLDocument.LoadFromStream(MyResourceStream);

        queryNode := XMLDocument.DocumentElement;
        expressionList := '/project/tasks';
        repeat
          p := Pos('+', expressionList);
          if p > 0 then
          begin
            expression := TrimRight(Copy(expressionList, 1, p - 1));
            Delete(expressionList, 1, p);
            expressionList := TrimLeft(expressionList);
          end
          else
            expression := expressionList;
          nodeList := XPathSelect(queryNode, expression);
          if nodeList.Length > 0 then
            queryNode := nodeList.Item[0]
          else
            queryNode := nil;
        until p = 0;

        if queryNode <> nil then
        begin
          with DM1.OraQuery1 do
          begin
            Close;
            SQL.Clear;
            SQL.Add('SELECT * FROM ' + '( ' + '   SELECT ' +
              '     A.TASK_NO, A.TASK_PRT, TASK_LV, TASK_NAME, EXD_TASK_START, '
              + '     EXD_TASK_END, NVL((EXD_TASK_END-EXD_TASK_START),0) DURATION, ''T'' TYPE, '
              + '     NVL(EXD_MH,0) EXD_MH, NVL(ACT_PROGRESS,0) ACT_PROGRESS  '
              + '   FROM DPMS_TMS_TASK A, DPMS_TMS_TASK_SHARE B ' +
              '   WHERE A.TASK_NO = B.TASK_NO ' + '   AND TASK_TEAM LIKE :team '
              + '   AND  ' + '   (( ' +
              '      TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :beginDate  ' +
              '      AND EXD_TASK_END >= TO_DATE(:beginDate, ''yyyy-mm-dd'')  '
              + '      AND TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :endDate  '
              + '      AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') <= :endDate  '
              + '      OR EXD_TASK_START >= TO_DATE(:beginDate, ''yyyy-mm-dd'')  '
              + '      AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') >= :beginDate  '
              + '      AND TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :endDate  '
              + '      AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') <= :endDate  '
              + '      OR TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') >= :beginDate  '
              + '      AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') >= :beginDate  '
              + '       AND TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :endDate  '
              + '       AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') >= :endDate  '
              + '       OR TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :beginDate  '
              + '       AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') >= :beginDate  '
              + '       AND TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :endDate  '
              + '       AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') >= :endDate '
              + '     ) OR ( ' +
              '       (EXD_TASK_START IS NULL) OR (EXD_TASK_END IS NULL) ' +
              '   )) UNION ' + '   SELECT * FROM ' + '   ( ' + '       SELECT '
              + '         PN, TASK_NO, PRN, PLAN_NAME, PLAN_START, PLAN_END, ' +
              '         NVL((PLAN_END-PLAN_START),0) DURATION,  ''P'' TYPE, ' +
              '         NVL(PLAN_MH,0) PLAN_MH, NVL(PLAN_PROGRESS,0) PLAN_PROGRESS  '
              + '       FROM ' + '       ( ' +
              '           SELECT PLAN_NO PN, MAX(PLAN_REV_NO) PRN FROM DPMS_TMS_PLAN GROUP BY PLAN_NO  '
              + '       ) A LEFT JOIN DPMS_TMS_PLAN B ' +
              '       ON A.PN = B.PLAN_NO ' +
              '       AND A.PRN = B.PLAN_REV_NO ' + '   )  ' +
              '   WHERE TASK_NO IN ' + '   ( ' +
              '       SELECT A.TASK_NO FROM DPMS_TMS_TASK A, DPMS_TMS_TASK_SHARE B ' +
              '       WHERE A.TASK_NO = B.TASK_NO ' +
              '       AND TASK_TEAM LIKE :team ' + '       AND  ' + '       (( '
              + '          TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :beginDate  '
              + '          AND EXD_TASK_END >= TO_DATE(:beginDate, ''yyyy-mm-dd'')  '
              + '          AND TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :endDate  '
              + '          AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') <= :endDate  '
              + '          OR EXD_TASK_START >= TO_DATE(:beginDate, ''yyyy-mm-dd'')  '
              + '          AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') >= :beginDate  '
              + '          AND TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :endDate  '
              + '         AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') <= :endDate  '
              + '         OR TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') >= :beginDate  '
              + '         AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') >= :beginDate  '
              + '          AND TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :endDate  '
              + '          AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') >= :endDate  '
              + '          OR TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :beginDate  '
              + '          AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') >= :beginDate  '
              + '          AND TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :endDate  '
              + '          AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') >= :endDate '
              + '         ) OR ( ' +
              '           (EXD_TASK_START IS NULL) OR (EXD_TASK_END IS NULL) ' +
              '        )) ' + '   ) ' + ')  ' + 'START WITH TASK_PRT IS NULL ' +
              'CONNECT BY PRIOR TASK_NO = TASK_PRT ' +
              'ORDER SIBLINGS BY EXD_TASK_START, TASK_NAME ');

            ParamByName('team').AsString := cb_team.Hint;
            ParamByName('beginDate').AsString := FormatDateTime('yyyy-MM-dd',
              dt_begin.Date);
            ParamByName('endDate').AsString := FormatDateTime('yyyy-MM-dd',
              dt_end.Date);

            Open;

            if RecordCount <> 0 then
            begin
              nodeDic := TDictionary<string, IXMLNode>.Create;
              try
                lId := 0;
                while not eof do
                begin
                  if RecNo = 1 then
                    lNode := AppendNode(queryNode, 'task')
                  else
                  begin
                    if nodeDic.ContainsKey(FieldByName('TASK_PRT').AsString)
                    then
                    begin
                      if nodeDic.TryGetValue(FieldByName('TASK_PRT').AsString,
                        lNode) then
                        lNode := AppendNode(lNode, 'task')
                      else
                        lNode := nil;
                    end
                    else
                    begin
                      lNode := AppendNode(queryNode, 'task')
                    end;
                  end;

                  nodeDic.Add(FieldByName('TASK_NO').AsString, lNode);

                  if lNode <> nil then
                  begin
                    Inc(lId);

                    Element := IXMLElement(lNode);
                    Element.SetAttribute('id', IntToStr(lId));
                    Element.SetAttribute('name', FieldByName('TASK_NAME')
                      .AsString);
                    Element.SetAttribute('color', '#66ff66');
                    Element.SetAttribute('start', FormatDateTime('YYYY-MM-DD',
                      FieldByName('EXD_TASK_START').AsDateTime));
                    Element.SetAttribute('duration', FieldByName('DURATION')
                      .AsString);
                    Element.SetAttribute('complete', FieldByName('ACT_PROGRESS')
                      .AsString);
                    Element.SetAttribute('nomalmh', FieldByName('EXD_MH')
                      .AsString);
                    Element.SetAttribute('addmh', '0');
                    Element.SetAttribute('nomalrealmh', '0');
                    Element.SetAttribute('realstart', '');
                    Element.SetAttribute('realend', '');
                    Element.SetAttribute('workcode', '');
                    Element.SetAttribute('cost', '0');
                    Element.SetAttribute('file', '0');
                    Element.SetAttribute('number', '0.0');
                    Element.SetAttribute('worklevel', '0');
                    Element.SetAttribute('webLink', '');
                    Element.SetAttribute('expand', 'true');
                  end;
                  Next;
                end;
              finally
                FreeAndNil(nodeDic);
              end;
            end;
          end;

          SaveDialog1.FileName := FormatDateTime('YYMMDD_', Now);
          SaveDialog1.FileName := SaveDialog1.FileName + cb_team.Text +
            '_DPMS.xml';
          if SaveDialog1.Execute then
          begin
            XMLDocument.Save(SaveDialog1.FileName);
            ShowMessage('파일생성완료!');
            // FXMLDocument.Save('..\..\resource\task_test.xml');
            // XMLDocument(FXMLDocument,TreeView1);
          end;
        end;
        // XML2TreeView(FXMLDocument,TreeView1);
      end;
    finally
      Screen.Cursor := crDefault;
    end;
  finally
    FreeAndNil(MyResourceStream);
  end;
end;

procedure TtaskManagement_Frm.btn_testInfoClick(Sender: TObject);
var
  i : Integer;
  lreqNo : String;
begin
  i := planGrid.SelectedRow;
  if i = -1 then
    Exit;

  if planGrid.Cell[1,i].AsInteger = -1 then
    Exit;

  lreqNo := Get_Test_Request_No(planGrid.Cells[3,planGrid.SelectedRow]);

  if lreqNo <> '' then
    Preview_Request_Frm(lreqNo);
end;

procedure TtaskManagement_Frm.btn_testInfoDropDownClick(Sender: TObject);
var
  i : Integer;
begin
  i := planGrid.SelectedRow;
  if i = -1 then
  begin
    mi_viewInfo.Enabled := False;
    mi_newInfo.Enabled := False;
    exit;
  end else
  begin
    if planGrid.Cell[1,i].AsInteger > -1 then
    begin
      mi_viewInfo.Enabled := True;
      mi_newInfo.Enabled := False;
    end
    else
    begin
      mi_viewInfo.Enabled := False;
      mi_newInfo.Enabled := True;
    end;
  end;
end;

procedure TtaskManagement_Frm.addTaskBtnClick(Sender: TObject);
begin
  Add_new_task(taskGrid.SelectedRow);
end;

procedure TtaskManagement_Frm.Button1Click(Sender: TObject);
begin
  Add_new_ToDo(planGrid.SelectedRow);
end;

procedure TtaskManagement_Frm.Button5Click(Sender: TObject);
begin
  Get_HiTEMS_TMS_TASK('');
end;

procedure TtaskManagement_Frm.cb_engModelDropDown(Sender: TObject);
begin
  with cb_engModel.Items do
  begin
    BeginUpdate;
    try
      Clear;
      Add('');
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT ENGMODEL FROM DPMS_HIMSEN_INFO ' + 'AND ENGTYPE = :ENGTYPE '
          + 'AND PROJNO = :PROJNO ' + 'GROUP BY ENGMODEL ' +
          'ORDER BY ENGMODEL ');

        if cb_engType.Text <> '' then
          ParamByName('ENGTYPE').AsString := cb_engType.Text
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND ENGTYPE = :ENGTYPE ', '');

        if cb_engProjNo.Text <> '' then
          ParamByName('PROJNO').AsString := cb_engProjNo.Text
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND PROJNO = :PROJNO ', '');

        Open;

        while not eof do
        begin
          Add(FieldByName('ENGMODEL').AsString);
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TtaskManagement_Frm.cb_engProjNoDropDown(Sender: TObject);
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
        SQL.Add('SELECT DISTINCT(PROJNO) FROM DPMS_HIMSEN_INFO ' +
          'WHERE STATUS = 0 ');

        if cb_engModel.Text <> '' then
          SQL.Add('AND ENGMODEL = ''' + cb_engModel.Text + ''' ');

        if cb_engType.Text <> '' then
          SQL.Add('AND ENGTYPE = ''' + cb_engType.Text + ''' ');

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

procedure TtaskManagement_Frm.cb_engTypeDropDown(Sender: TObject);
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
        SQL.Add('SELECT DISTINCT(ENGTYPE) FROM DPMS_HIMSEN_INFO ' +
          'WHERE STATUS = 0 ');

        if cb_engModel.Text <> '' then
          SQL.Add('AND ENGMODEL = ''' + cb_engModel.Text + ''' ');

        if cb_engProjNo.Text <> '' then
          SQL.Add('AND PROJNO = ''' + cb_engProjNo.Text + ''' ');

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

procedure TtaskManagement_Frm.cb_teamDropDown(Sender: TObject);
var
  i: Integer;
  lteam: string;
begin
  with cb_team.Items do
  begin
    BeginUpdate;
    try
      Clear;
      Add('');
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM DPMS_DEPT ' + 'WHERE PARENT_CD = :param1 ' +
          'ORDER BY DEPT_CD ');

        ParamByName('param1').AsString := DM1.FUserInfo.CurrentUsersDept;
        Open;

        if RecordCount <> 0 then
        begin
          for i := 0 to RecordCount - 1 do
          begin
            if i = 0 then
            begin
              if FieldByName('DEPT_CD').AsString = DM1.FUserInfo.CurrentUsersTeam then
                Add(FieldByName('DEPT_NAME').AsString);
            end
            else
            begin
              Add(FieldByName('DEPT_NAME').AsString);
            end;
            Next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TtaskManagement_Frm.cb_teamSelect(Sender: TObject);
begin
  if cb_team.Text <> '' then
  begin
    with DM1.OraQuery1 do
    begin
      First;
      while not eof do
      begin
        if FieldByName('DEPT_NAME').AsString = cb_team.Text then
        begin
          cb_team.Hint := FieldByName('DEPT_CD').AsString;
          Break;
        end;
        Next;
      end;
    end;
  end
  else
  begin
    cb_team.Clear;
    cb_team.Items.Clear;
    cb_team.Hint := '';
  end;
end;

function TtaskManagement_Frm.Check_Task_Edit_Authority(aTaskNo,
  aUserId: String): Boolean;
var
  OraQuery: TOraQuery;

begin
  if aTaskNo <> '' then
  begin
    OraQuery := TOraQuery.Create(nil);
    OraQuery.Session := DM1.OraSession1;
    try
      with OraQuery do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT TASK_MANAGER, TASK_DRAFTER FROM DPMS_TMS_TASK ' +
          'WHERE TASK_NO = :param1 ');
        ParamByName('param1').AsString := aTaskNo;
        Open;

        if RecordCount <> 0 then
        begin
          if SameText(aUserId, FieldByName('TASK_MANAGER').AsString) or
            SameText(aUserId, FieldByName('TASK_DRAFTER').AsString) then
          begin
            Result := True;
          end
          else
          begin
            Close;
            SQL.Clear;
            SQL.Add('SELECT * FROM DPMS_TMS_AUTHORITY ' + 'WHERE USERID = :param1 ');
            ParamByName('param1').AsString := aUserId;
            Open;

            if RecordCount <> 0 then
            begin
              if FieldByName('TASK_EDIT').AsInteger > 0 then
                Result := True
              else
                Result := False;
            end
            else
            begin
              Result := False;
            end;
          end;
        end
        else
        begin
          Result := False;
        end;
      end;
    finally
      FreeAndNil(OraQuery);
    end;
  end;
end;

procedure TtaskManagement_Frm.FormCreate(Sender: TObject);
var
  i: Integer;
  lbegin, lend, lteam: String;
begin
  taskGrid.DoubleBuffered := False;
  planGrid.DoubleBuffered := False;

  dt_begin.Date := StartOfTheWeek(today);
  dt_end.Date := EndOfTheWeek(today);

  PageControl1.DoubleBuffered := False;
  PageControl1.ActivePageIndex := 0;

  cb_team.Items.Clear;
  cb_team.Hint := DM1.FUserInfo.CurrentUsersTeam;

  if cb_team.Hint <> '' then
    cb_team.Items.Add(Get_DeptName(cb_team.Hint));

  cb_team.ItemIndex := 0;

  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM DPMS_TMS_AUTHORITY ' + 'WHERE USERID = :param1 ');
    ParamByName('param1').AsString := DM1.FUserInfo.CurrentUsers;
    Open;

    if RecordCount > 0 then
    begin
      if FieldByName('TASK_ARRANGE').AsInteger > 0 then
      begin
        taskDownBtn.Visible := True;
        taskUpBtn.Visible := True;
      end;
    end;
  end;
end;

procedure TtaskManagement_Frm.FormShow(Sender: TObject);
begin
  startTimer.Enabled := True;
end;

procedure TtaskManagement_Frm.Get_HiTEMS_TMS_TASK(aTask_No: String);
begin
  TThread.Queue(nil,
    procedure
    const
      Query = 'SELECT * FROM ' + '(         ' + '   SELECT ' +
        '       A.TASK_NO, TASK_PRT, TASK_LV, TASK_NAME, EXD_TASK_START, ' +
        '         EXD_TASK_END, EXD_MH, ACT_TASK_START, ACT_TASK_END, ' +
        '         ACT_PROGRESS, TASK_OUTLINE, TASK_MANAGER, TASK_DRAFTER, ' +
        '         TASK_INDATE, TASK_ORDER, TASK_STATE,' + '       B.TASK_TEAM '
        + '   FROM DPMS_TMS_TASK A, DPMS_TMS_TASK_SHARE B ' + '   WHERE  ' + '   ( ' +
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
        '     ) ' + '     OR ' + '     ( ' +
        '         (EXD_TASK_START IS NULL) OR (EXD_TASK_END IS NULL) ' +
        '     ) ' + '   ) ' + '   AND A.TASK_NO = B.TASK_NO  ' +
        '   AND SUBSTR(TASK_TEAM, 1, 4) = :team  ' + ')    ' +
        'START WITH TASK_PRT IS NULL ' + 'CONNECT BY PRIOR TASK_NO = TASK_PRT '
        + 'ORDER SIBLINGS BY TASK_ORDER ';
    var
      OraQuery: TOraQuery;
      str, lkey, lteam, ltaskNo: string;
      i, lrow: Integer;
      ldic: TDictionary<string, Integer>;
    begin
      with taskGrid do
      begin
        BeginUpdate;
        try
          ClearRows;
          with DM1.OraQuery1 do
          begin
            Close;
            SQL.Clear;
            SQL.Add(Query);
            ParamByName('beginDate').AsString := FormatDateTime('yyyy-MM-dd',
              dt_begin.Date);
            ParamByName('endDate').AsString := FormatDateTime('yyyy-MM-dd',
              dt_end.Date);
            ParamByName('team').AsString := cb_team.Hint;
            Open;

            if RecordCount <> 0 then
            begin
              ldic := TDictionary<string, Integer>.Create;
              try
                while not eof do
                begin
                  if ldic.Count = 0 then
                    lrow := AddRow
                  else
                  begin
                    if ldic.ContainsKey(FieldByName('TASK_PRT').AsString) then
                    begin
                      ldic.TryGetValue(FieldByName('TASK_PRT').AsString, i);
                      AddChildRow(i, crLast);
                      lrow := LastAddedRow;
                    end
                    else
                    begin
                      lrow := AddRow;
                    end;
                  end;

                  ldic.Add(FieldByName('TASK_NO').AsString, lrow);

                  if lrow > -1 then
                  begin
                    Cells[0, lrow] := FieldByName('TASK_NO').AsString;
                    Cells[1, lrow] := FieldByName('TASK_NAME').AsString;

                    if not FieldByName('EXD_TASK_START').IsNull then
                      Cell[2, lrow].AsDateTime := FieldByName('EXD_TASK_START')
                        .AsDateTime;

                    if not FieldByName('EXD_TASK_END').IsNull then
                      Cell[3, lrow].AsDateTime := FieldByName('EXD_TASK_END')
                        .AsDateTime;

                    if not FieldByName('ACT_TASK_START').IsNull then
                      Cell[4, lrow].AsDateTime := FieldByName('ACT_TASK_START')
                        .AsDateTime;

                    if not FieldByName('ACT_TASK_END').IsNull then
                      Cell[5, lrow].AsDateTime := FieldByName('ACT_TASK_END')
                        .AsDateTime;

                    Cell[6, lrow].AsInteger := FieldByName('ACT_PROGRESS')
                      .AsInteger;
                    Cells[7, lrow] := FieldByName('TASK_STATE').AsString;
                    Cells[8, lrow] := Get_UserName(FieldByName('TASK_MANAGER')
                      .AsString);
                    Cells[9, lrow] := Get_UserName(FieldByName('TASK_DRAFTER')
                      .AsString);
                    Cells[10, lrow] := FieldByName('TASK_ORDER').AsString;

                    if Check_Task_Edit_Authority(Cells[0, lrow], DM1.FUserInfo.CurrentUsers)
                    then
                      Cell[11, lrow].AsInteger := 0
                    else
                      Cell[11, lrow].AsInteger := -1;
                  end;
                  Next;
                end;
              finally
                FreeAndNil(ldic);
                FreeAndNil(OraQuery);
              end;
            end;
          end;
        finally
          EndUpdate;
          AeroButton3.Enabled := True;
        end;
      end;
    end);
end;

procedure TtaskManagement_Frm.Get_HiTEMS_TMS_TASK_PLAN(aTask_No: String);
var
  lrow: Integer;
  LCodeName: string;
  LAliasType, LAliasCode: integer;
begin
  if aTask_No <> '' then
  begin
    with planGrid do
    begin
      BeginUpdate;
      try
        ClearRows;
        with DM1.OraQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT ' + ' A.*, ' + ' B.*, ' +
            ' (SELECT COUNT(*) FROM DPMS_TMS_TEST_RECEIVE_INFO WHERE PLAN_NO LIKE A.PLAN_NO) TESTCNT '
            + 'FROM ' + '( ' + '   SELECT ' +
            '     A.PLAN_NO, REV_NO, PLAN_CODE, PLAN_TYPE, PLAN_NAME, PLAN_OUTLINE, '
            + '     ENG_MODEL, ENG_TYPE, ENG_PROJNO, PLAN_START, PLAN_END, PLAN_MH, '
            + '     PLAN_PROGRESS, PLAN_DRAFTER, PLAN_INDATE ' + '   FROM ' +
            '   ( ' + '       SELECT PLAN_NO, MAX(PLAN_REV_NO) REV_NO FROM DPMS_TMS_PLAN '
            + '       WHERE TASK_NO = :TASK_NO ' +
            '       AND ENG_MODEL = :param1 ' + '       AND ENG_TYPE = :param2 '
            + '       AND ENG_PROJNO = :param3 ' + '       GROUP BY PLAN_NO ' +
            '   ) A LEFT OUTER JOIN ' + '   ( ' +
            '       SELECT * FROM DPMS_TMS_PLAN ' + '   ) B ' +
            '   ON A.PLAN_NO = B.PLAN_NO ' + '   AND A.REV_NO = B.PLAN_REV_NO '
            + ') A INNER JOIN ' + '( ' +
            '   SELECT GRP_NO, CODE_NAME FROM DPMS_CODE_GROUP ' + ') B ' +
            'ON A.PLAN_CODE = B.GRP_NO ' + 'ORDER BY PLAN_NAME, PLAN_START ');

          ParamByName('TASK_NO').AsString := aTask_No;

          if cb_engModel.Text <> '' then
            ParamByName('param1').AsString := cb_engModel.Text
          else
            SQL.Text := ReplaceStr(SQL.Text, 'AND ENG_MODEL = :param1', '');

          if cb_engType.Text <> '' then
            ParamByName('param2').AsString := cb_engType.Text
          else
            SQL.Text := ReplaceStr(SQL.Text, 'AND ENG_TYPE = :param2', '');

          if cb_engProjNo.Text <> '' then
            ParamByName('param3').AsString := cb_engProjNo.Text
          else
            SQL.Text := ReplaceStr(SQL.Text, 'AND ENG_PROJNO = :param3', '');

          Open;

          while not eof do
          begin
            lrow := AddRow;

            if FieldByName('TESTCNT').AsInteger > 0 then
              Cell[1, lrow].AsInteger := 2
            else
              Cell[1, lrow].AsInteger := -1;

            Cells[2, lrow] := aTask_No;
            Cells[3, lrow] := FieldByName('PLAN_NO').AsString;
            Cells[4, lrow] := FieldByName('PLAN_CODE').AsString;
            Cells[5, lrow] := NxComboBoxColumn1.Items.Strings
              [FieldByName('PLAN_TYPE').AsInteger];
            Cells[6, lrow] := FieldByName('ENG_MODEL').AsString;
            Cells[7, lrow] := FieldByName('ENG_TYPE').AsString;

            Cells[8, lrow] := FieldByName('CODE_NAME').AsString;
            Cells[9, lrow] := FieldByName('PLAN_NAME').AsString;
            Cells[10, lrow] := Get_Plan_InCharge(Cells[3, lrow],
              FieldByName('REV_NO').AsString, '');
            if not FieldByName('PLAN_START').IsNull then
              Cells[11, lrow] := FieldByName('PLAN_START').AsString
            else
              Cells[11, lrow] := '';

            if not FieldByName('PLAN_END').IsNull then
              Cells[12, lrow] := FieldByName('PLAN_END').AsString
            else
              Cells[12, lrow] := '';

            Cell[13, lrow].AsInteger := FieldByName('PLAN_PROGRESS').AsInteger;

            if Get_AttfilesCount(Cells[3, lrow]) > 0 then
              Cell[14, lrow].AsInteger := 39
            else
              Cell[14, lrow].AsInteger := -1;

            Cell[15, lrow].AsInteger := FieldByName('REV_NO').AsInteger;

            if (Cell[13, lrow].AsInteger = 100) and (rb_hide.Checked = True)
            then
              row[lrow].Visible := False;

            LAliasType := DM1.GetVisibleTypeFromGrp(FieldByName('PLAN_CODE').AsString, ord(ctGroup), LCodeName, LAliasCode);
            Cell[16, lrow].AsInteger := LAliasType;

            Next;
          end;
        end;
      finally
        EndUpdate;
      end;
    end;
  end;
end;

function TtaskManagement_Frm.Get_Test_Request_No(aPlanNo: String): String;
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
      SQL.Add('SELECT REQ_NO FROM DPMS_TMS_TEST_RECEIVE_INFO ' +
              'WHERE PLAN_NO LIKE :param1 ');
      ParamByName('param1').AsString := aPlanNo;
      Open;

      Result := FieldByName('REQ_NO').AsString;

    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure TtaskManagement_Frm.Init_ganttChart;
begin
  with G2antt1 do
  begin
    BeginUpdate;
    try
      DoubleBuffered := False;
      with Chart do
      begin
        Images('gBJJgBAIEAAGAEGCAAhb/hz/EIAh8Tf5CJo2AEZjQAjEZFEaIEaEEaAIA' +
          'kcbk0olUrlktl0vmExmUzmk1m03nE5nU7nk9n0/oFBoVDolFo1HpFJpVLplNp1P' +
          'qFRqVTqlVq1XrFZrVbrldr1fsFhsVjslls1ntFptVrtltt1vuFxuVzul1u13vF5' +
          'vV7vl9v1BAmBhOCwMGwuDw2ExWJxmIx2HyGLv+TlykUCgABmGYzzObzuczWcKuj' +
          'zOa0ug02hz+r1Wtz2qoCA2QAYG1yk02YA3NMy2Yh8Sh202zx4gA4jxADM5XG4vH' +
          'ACy6ESdjM6XUZiZTMS5bwZSm1c83+yQHCYHk81Q8O7qW18u/9NG3vAf/y83u4PQW' +
          'QA0ZVADq/z6um6rkuw7TqH+5bYJu+z5vE8z2N02cGweoDfwfCrbQfBqkNzBb6Qf' +
          'DLxp6+LlOs5cSOTEzlm7FYACFFwADvGIAGvGjzOu7MbwHHECQSmUOvS8cGwk20g' +
          'Qc2ycQs4MLvLD8MNtDSfyS+cmyZJzywa96axzDsTw6/x1AAL8xRbF8Vm65jkH/A' +
          'L8QFNTqR6lsfuDIb2uDKTzTo88FTtIk+PK3SNRDKiew5JVDSnK08NnOUGRClkt0' +
          'PFEDUjMwAENS4AM2zj4udNznujT1PTgjdGQg8c71RPtESvCL1JrO8lozQUj1nP6' +
          'd1TKtc0U8dS1jCaNRzGhrxnGthWJYdjUrYwc2ZMMx2NB8czZNk4VLPMstzXD6Q6' +
          'mltVjPNAT0m1CvnDtBxBXlI3PRKNzZDtjQ6cd5TQ/TSU0/r/udC0A1Ez1SUja8/' +
          'QhWVavrSLfpxWNzXZR2CygmVtXXVl03Lg+BV+lV3UjeDgzEL4AXkcb6Pje5LZND' +
          'zhuLfrOX/RtT0TQbc5lENSvBi2K5xlFdUHhN1ZhJ9F59WybOU7NjWTFkvxhGT9z' +
          'IIQAWYHIABFqmnABSsT0HUaNYlI1dZmjNuUDRybzvIVWyDoOc54n8Oyxm9Ta9cS' +
          'UaLbbg44+b4xiO9nY/pt73u38Tuc52tpdruYxDVyUbBV+gYpu2c7PyGMKTt21cj' +
          'nW6OvzO8PppUvP/Ljlt/wt/Vvn+v8V1eCdbgaa7fnMi8vyD0TnzGEJXyp/wJ3js' +
          '98iXe+F3/hwGM3jeQZjTeUznmOT5bTKJyqYcbm2c5bzXpqvsWw4FUkCO473wgB8' +
          'cD9/znzO14n1+D4/efcTP4fl5+WKvxbbptmqV+B/ni/68R4514AvxeTAR50B3o' +
          'PNei/iBhFgfErgeR4kBIiSAAJKSiC7PT5wMKIQ4fwfyHDzg2PwD4/B/jgg2PgA4' +
          '8AfjgB+RkeAARwAPGAA8jI4AADgAOMAAZGTyw6YbDkA7ZDaAHgxDyCxGgBw8EBBm' +
          'JcS4LjAATDweBGoqjgAGP4jQ/AcjwAHBsiQex8gPH+MF7pDxxkB');

        Columns.Clear;
        ColumnAutoResize := False;
        OverviewVisible := EXG2ANTTLib_TLB.exOverviewShowAll;
        OverviewHeight := 64;

        AllowOverviewZoom := EXG2ANTTLib_TLB.exAlwaysZoom;

        OverviewZoomCaption := '|||<img>2</img>' + #10#13 +
          'Month||<img>1</img>' + #10#13 + 'Week|<img>3</img>' + #10#13
          + 'Day|||';
        Label_[EXG2ANTTLib_TLB.exYear] := '';
        // not appearance in overview zoom area
        Label_[EXG2ANTTLib_TLB.exHour] := '';
        Label_[EXG2ANTTLib_TLB.exMinute] := '';
        Label_[EXG2ANTTLib_TLB.exSecond] := '';

        Columns.Add('업무명').WidthAutoResize := True;
        Columns.Add('시작시간').Width := 80;
        Columns.Add('종료시간').Width := 80;
        Columns.Add('진행율(%)').Width := 80;
        Columns.Add('기안자').Width := 80;

        Bars.Add('Task%Progress').Shortcut := 'top';
        // Adding a Progress bar on Task bar, as a percent
        Bars.Copy('Task%Progress', 'middle').Color := RGB(0, 255, 0);
        Bars.Copy('Task%Progress', 'bottom').Color := RGB(255, 0, 255);

        FirstVisibleDate := StartOfTheYear(today);

        Chart.LevelCount := 3;
        PaneWidth[False] := 300;

      end;

      Items.RemoveAllItems;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TtaskManagement_Frm.it_addTaskClick(Sender: TObject);
begin
  addTaskBtnClick(Sender);
end;

procedure TtaskManagement_Frm.JvLabel2Click(Sender: TObject);
begin
//  ShowMessage(IntToStr(Round(dt_end.Date - dt_begin.Date)));
end;

procedure TtaskManagement_Frm.mi_newInfoClick(Sender: TObject);
var
  i : Integer;
begin
  i := planGrid.SelectedRow;
  if i = -1 then
    Exit
  else
  begin
    if Self_New_test_Request_Frm(planGrid.Cells[3,i]) then
      Get_HiTEMS_TMS_TASK_PLAN(FcurrentTaskNo);
  end;
end;

procedure TtaskManagement_Frm.mi_viewInfoClick(Sender: TObject);
begin
  btn_testInfoClick(sender);
end;

procedure TtaskManagement_Frm.N1Click(Sender: TObject);
begin
  Add_new_task(taskGrid.SelectedRow);
end;

procedure TtaskManagement_Frm.N2Click(Sender: TObject);
begin
  Add_new_Plan(taskGrid.SelectedRow);
end;

procedure TtaskManagement_Frm.N3Click(Sender: TObject);
var
  i : Integer;
  lreqNo : String;
begin
  i := planGrid.SelectedRow;
  if i = -1 then
    Exit;

  if planGrid.Cell[1,i].AsInteger = -1 then
    Exit;

  lreqNo := Get_Test_Request_No(planGrid.Cells[3,planGrid.SelectedRow]);

  if lreqNo <> '' then
  begin
    if Self_New_test_Request_Frm('',lreqNo) then
    begin
      Get_HiTEMS_TMS_TASK_PLAN(FcurrentTaskNo);
    end;
  end;
end;

procedure TtaskManagement_Frm.oDoList1Click(Sender: TObject);
begin
  Add_new_ToDo(planGrid.SelectedRow);
end;

procedure TtaskManagement_Frm.reqnoeditButtonClick(Sender: TObject);
begin
  reqnoedit.Text := Get_selected_Test('');
end;

procedure TtaskManagement_Frm.PageControl1Change(Sender: TObject);
var
  lbegin, lend, lteam: String;
begin
  case PageControl1.ActivePageIndex of
    1:
      begin
        Init_ganttChart;

        lbegin := FormatDateTime('yyyy-MM-dd', dt_begin.Date);
        lend := FormatDateTime('yyyy-MM-dd', dt_end.Date);
        lteam := cb_team.Hint;
        Set_GanttChart(lbegin, lend, lteam, '', '', '');
      end;
  end;
end;

procedure TtaskManagement_Frm.planGridCellColoring(Sender: TObject; ACol,
  ARow: Integer; var CellColor, GridColor: TColor; CellState: TCellState);
begin
  if not(csSelected in CellState) then
  begin
    if ARow mod 2 = 0 then CellColor := $00F5FCFE;
  end;
end;

procedure TtaskManagement_Frm.planGridCellDblClick(Sender: TObject;
ACol, ARow: Integer);
var
  lreqNo,
  ltaskNo, lplanNo: String;
  lResult: Boolean;
  lstartDate, lendDate: TDateTime;
  lteamCode: String;
  lplanRevNo: Integer;
begin
  if ARow = -1 then
    Exit;

  with planGrid do
  begin
    if ACol <> 1 then
    begin
      ltaskNo := Cells[2, ARow];
      lplanNo := Cells[3, ARow];
      lplanRevNo := Cell[15, ARow].AsInteger;

      lteamCode := cb_team.Hint;
      lstartDate := dt_begin.Date;
      lendDate := dt_end.Date;

      lResult := Create_newPlan_Frm(ltaskNo, lplanNo, lteamCode, lstartDate,
        lendDate, lplanRevNo);

      if lResult = True then
        Get_HiTEMS_TMS_TASK_PLAN(ltaskNo);

    end else
    begin
      lreqNo := Get_Test_Request_No(Cells[3,ARow]);
      if lreqNo <> '' then
        Preview_Request_Frm(lreqNo);
    end;
  end;
end;

procedure TtaskManagement_Frm.planGridCellFormating(Sender: TObject;
ACol, ARow: Integer; var TextColor: TColor; var FontStyle: TFontStyles;
CellState: TCellState);
begin
  if planGrid.CellByName['planProgressColumn', ARow].AsInteger = 100 then
  begin
    TextColor := clGrayText;
    FontStyle := FontStyle + [fsStrikeOut];
  end;

//  if ACol = 0 then //name = 'AliasCode'
//  begin
    with planGrid do
    begin
      if ARow <= RowCount - 1 then
      begin
        if Cell[16, ARow].AsInteger = 2 then
          TextColor := ALIAS_TEAM_COLOR
        else
        if Cell[16, ARow].AsInteger = 3 then
          TextColor := ALIAS_PRIVATE_COLOR;
      end;
    end;
//  end;

end;

procedure TtaskManagement_Frm.planGridMouseDown(Sender: TObject;
Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i : Integer;
begin
  i := planGrid.GetRowAtPos(X, Y);

  if i = -1 then
  begin
    for i := 0 to PopUpMenu2.Items.Count - 1 do
      PopUpMenu2.Items[i].Enabled := False;

    btn_testInfo.Enabled := False;
    Exit;
  end;

  with planGrid do
  begin
    BeginUpdate;
    try
      if Cells[5,i] = '시험' then
      begin
        for i := 0 to PopUpMenu2.Items.Count - 1 do
          PopUpMenu2.Items[i].Enabled := True;

        btn_testInfo.Enabled := True;
      end
      else
      begin
        for i := 0 to PopUpMenu2.Items.Count - 1 do
          PopUpMenu2.Items[i].Enabled := False;

        btn_testInfo.Enabled := False;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TtaskManagement_Frm.rb_AllClick(Sender: TObject);
var
  i: Integer;
begin
  with planGrid do
  begin
    BeginUpdate;
    try
      for i := 0 to RowCount - 1 do
        row[i].Visible := True;

    finally
      EndUpdate;
    end;
  end;
end;

procedure TtaskManagement_Frm.rb_hideClick(Sender: TObject);
var
  i: Integer;
begin
  with planGrid do
  begin
    BeginUpdate;
    try
      for i := 0 to RowCount - 1 do
      begin
        if Cell[13, i].AsInteger = 100 then
          row[i].Visible := False
        else
          row[i].Visible := True;
      end;

    finally
      EndUpdate;
    end;
  end;
end;

procedure TtaskManagement_Frm.rg_periodClick(Sender: TObject);
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

procedure TtaskManagement_Frm.Set_GanttChart(const atBegin, atEnd, aTeam,
  aModel, aType, aProjno: String);
const
  Query = 'SELECT * FROM ' + '( ' + '   SELECT * FROM ' + '   ( ' +
    '       SELECT * FROM ' + '       ( ' + '           SELECT ' +
    '             A.TASK_NO, TASK_PRT, TASK_NAME, EXD_TASK_START, ' +
    '               EXD_TASK_END, ACT_PROGRESS, TASK_DRAFTER, ' +
    '             B.TASK_TEAM, ''T'' POS ' +
    '           FROM DPMS_TMS_TASK A, DPMS_TMS_TASK_SHARE B ' +
    '           WHERE A.TASK_NO = B.TASK_NO ' + '       ) UNION ' +
    '       SELECT * FROM ' + '       ( ' + '           SELECT ' +
    '             A.PLAN_NO, TASK_NO, PLAN_NAME, PLAN_START, PLAN_END, ' +
    '               PLAN_PROGRESS, PLAN_DRAFTER, PLAN_TEAM, ''P'' POS ' +
    '           FROM ' + '           ( ' +
    '               SELECT A.PLAN_NO, REV_NO, PLAN_TEAM FROM ' +
    '               ( ' +
    '                   SELECT PLAN_NO, MAX(PLAN_REV_NO) REV_NO ' +
    '                   FROM DPMS_TMS_PLAN GROUP BY PLAN_NO ' +
    '               ) A, ' + '               ( ' +
    '                   SELECT PLAN_NO, PLAN_REV_NO, SUBSTR(PLAN_TEAM,1,4) PLAN_TEAM '
    + '                   FROM DPMS_TMS_PLAN_INCHARGE ' + '               ) B ' +
    '               WHERE A.PLAN_NO = B.PLAN_NO ' +
    '               AND A.REV_NO = B.PLAN_REV_NO ' +
    '               GROUP BY A.PLAN_NO, REV_NO, PLAN_TEAM ' + '           ) A, '
    + '           ( ' + '               SELECT ' +
    '                 TASK_NO, PLAN_NO, PLAN_REV_NO, A.PLAN_CODE, PLAN_TYPE, PLAN_NAME, '
    + '                 ENG_MODEL, ENG_TYPE, ENG_PROJNO, PLAN_START, PLAN_END, PLAN_MH, '
    + '                 PLAN_PROGRESS, PLAN_DRAFTER, CODE_NAME ' +
    '               FROM DPMS_TMS_PLAN A, DPMS_CODE_GROUP B ' +
    '               WHERE A.PLAN_CODE = B.GRP_NO ' + '           ) B ' +
    '           WHERE A.PLAN_NO = B.PLAN_NO ' +
    '           AND A.REV_NO = B.PLAN_REV_NO ' + '       ) ' + '   ) ' +
    'WHERE  ' + '(( ' +
    '   TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :beginDate  ' +
    '   AND EXD_TASK_END >= TO_DATE(:beginDate, ''yyyy-mm-dd'')  ' +
    '   AND TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :endDate  ' +
    '   AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') <= :endDate  ' +
    '   OR EXD_TASK_START >= TO_DATE(:beginDate, ''yyyy-mm-dd'')  ' +
    '   AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') >= :beginDate  ' +
    '   AND TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :endDate  ' +
    '   AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') <= :endDate  ' +
    '   OR TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') >= :beginDate  ' +
    '   AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') >= :beginDate  ' +
    '   AND TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :endDate  ' +
    '   AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') >= :endDate  ' +
    '   OR TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :beginDate  ' +
    '   AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') >= :beginDate  ' +
    '   AND TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :endDate  ' +
    '   AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') >= :endDate ' + ' ) OR ( ' +
    '   (EXD_TASK_START IS NULL) OR (EXD_TASK_END IS NULL) ' +
    ')) AND TASK_TEAM LIKE :TEAM ' + ') ' + 'START WITH TASK_PRT IS NULL ' +
    'CONNECT BY PRIOR TASK_NO = TASK_PRT ' +
    'ORDER SIBLINGS BY EXD_TASK_START, TASK_NO ';

var
  OraQuery: TOraQuery;
  i, hTask: Integer;
  sDate, eDate: TDateTime;
  str, Pos: string;
  taskNoDic: TDictionary<String, Integer>;
begin
  with G2antt1 do
  begin
    BeginUpdate;
    taskNoDic := TDictionary<String, Integer>.Create;
    try
      OraQuery := TOraQuery.Create(nil);
      try
        OraQuery.Session := DM1.OraSession1;
        OraQuery.FetchAll := True;

        with DM1.OraQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add(Query);

          ParamByName('beginDate').AsString := atBegin;
          ParamByName('endDate').AsString := atEnd;

          if aTeam <> '' then
            ParamByName('TEAM').AsString := aTeam
          else
            SQL.Text := ReplaceStr(SQL.Text, 'AND TASK_TEAM = :TEAM ', '');

          Open;

          with Items do
          begin
            while not eof do
            begin
              if (FieldByName('TASK_PRT').IsNull) And
                (FieldByName('POS').AsString = 'T') then
                Pos := 'top';
              if not(FieldByName('TASK_PRT').IsNull) And
                (FieldByName('POS').AsString = 'T') then
                Pos := 'middle';
              if FieldByName('POS').AsString = 'P' then
                Pos := 'bottom';

              hTask := 0;
              if ItemCount = 0 then
              begin
                hTask := AddItem(FieldByName('TASK_NAME').AsString);
                taskNoDic.Add(FieldByName('TASK_NO').AsString, hTask);
              end
              else
              begin
                if taskNoDic.ContainsKey(FieldByName('TASK_PRT').AsString) then
                begin
                  taskNoDic.TryGetValue(FieldByName('TASK_PRT')
                    .AsString, hTask);
                  hTask := InsertItem(hTask, OleVariant(0),
                    FieldByName('TASK_NAME').AsString);

                end
                else
                begin
                  hTask := AddItem(FieldByName('TASK_NAME').AsString);
                end;

                if not(taskNoDic.ContainsKey(FieldByName('TASK_NO').AsString))
                then
                  taskNoDic.Add(FieldByName('TASK_NO').AsString, hTask);
              end;

              if hTask <> 0 then
              begin
                AddBar(hTask, Pos, FieldByName('EXD_TASK_START').AsDateTime,
                  FieldByName('EXD_TASK_END').AsDateTime,
                  FieldByName('TASK_NO').AsString, // Key
                Null);
                ItemBar[hTask, FieldByName('TASK_NO').AsString, 12] :=
                  FieldByName('ACT_PROGRESS').AsInteger / 100;
                ItemBar[hTask, FieldByName('TASK_NO').AsString, 16] := False;
                // exBarCanResizePercent

                CellValue[hTask, 1] := FieldByName('EXD_TASK_START').AsDateTime;
                CellValue[hTask, 2] := FieldByName('EXD_TASK_END').AsDateTime;
                CellValue[hTask, 3] := FieldByName('ACT_PROGRESS').AsString;
                CellValue[hTask, 4] :=
                  Get_UserName(FieldByName('TASK_DRAFTER').AsString);
              end;
              Next;
            end; // with
            Chart.FirstVisibleDate := today;
            ExpandItem[0] := True;
            DefaultItem := ItemByIndex[0];
            DefaultItem := 0;
          end; // Items
        end;
      finally
        FreeAndNil(OraQuery);
      end;
    finally
      FreeAndNil(taskNoDic);
      EndUpdate;
    end;
  end;
end;

procedure TtaskManagement_Frm.startTimerTimer(Sender: TObject);
begin
  startTimer.Enabled := False;
  GetTaskThread := TGetTaskThread.Create;

  with GetTaskThread do
  begin
    iCnt := 0;
    FBeginDate := FormatDateTime('yyyy-MM-dd', dt_begin.Date);
    FEndDate := FormatDateTime('yyyy-MM-dd', dt_end.Date);
    FTeam := cb_team.Hint;
    SetProgressDlg(Self.JvProgressDialog1);
    SetGridTask(Self.taskGrid);
    resume;
    JvProgressDialog1.ShowModal;
  end;
end;

procedure TtaskManagement_Frm.taskGridAfterEdit(Sender: TObject;
ACol, ARow: Integer; Value: WideString);
var
  li: Integer;
begin
  with taskGrid do
  begin
    BeginUpdate;
    try
      Columns[ACol].Options := Columns[ACol].Options - [coEditing];
      if FbeforeValues <> Value then
      begin
        for li := 0 to Columns.Count - 1 do
          Cell[li, ARow].TextColor := clBlue;

      end;
    finally
      if ACol = 10 then
      begin
        // Update_Task_Order(ARow);
      end;

      EndUpdate;
    end;
  end;
end;

procedure TtaskManagement_Frm.taskGridBeforeEdit(Sender: TObject;
ACol, ARow: Integer; var Accept: Boolean);
begin
  FbeforeValues := taskGrid.Cells[ACol, ARow];
end;

procedure TtaskManagement_Frm.taskGridCellDblClick(Sender: TObject;
ACol, ARow: Integer);
var
  lTask_NO, lParent_No, lResult, lteamCode: String;
  i, lrow, lTaskLv: Integer;
  lstartDate, lendDate: TDateTime;
begin
  with taskGrid do
  begin
    if ARow > -1 then
    begin
      if ARow <> -1 then
        lTask_NO := Cells[0, ARow]
      else
        lTask_NO := '';

      lteamCode := cb_team.Hint;
      lstartDate := dt_begin.Date;
      lendDate := dt_end.Date;

      lrow := GetParent(ARow);
      if lrow <> -1 then
        lParent_No := Cells[0, lrow]
      else
        lParent_No := '';

      lTaskLv := GetLevel(ARow);

      lResult := Create_newTask_Frm(lTask_NO, lParent_No, lteamCode, lTaskLv,
        lstartDate, lendDate);

      if lResult <> '' then
      begin
//        if HasChildren(ARow) then
//          ClearChildRows(ARow);
//        DeleteRow(ARow);
        planGrid.ClearRows;
        BeginUpdate;
        try
          with DM1.OraQuery1 do
          begin
            Close;
            SQL.Clear;
            SQL.Add('SELECT * FROM DPMS_TMS_TASK ' + 'START WITH TASK_NO = :param1 '
              + 'CONNECT BY PRIOR TASK_NO = TASK_PRT ' +
              'ORDER SIBLINGS BY TASK_ORDER ');
            ParamByName('param1').AsString := lResult;
            Open;

            if RecordCount <> 0 then
            begin
//              while not eof do
//              begin
//                if FieldByName('TASK_PRT').AsString <> '' then
//                begin
//                  for i := 0 to RowCount - 1 do
//                  begin
//                    if SameText(FieldByName('TASK_PRT').AsString, Cells[0, i])
//                    then
//                    begin
//                      AddChildRow(i, crLast);
//                      lrow := LastAddedRow;
//                      Break;
//                    end;
//                  end;
//                end
//                else
//                  lrow := AddRow;
                lrow := ARow;

                Cells[0, lrow] := FieldByName('TASK_NO').AsString;
                Cells[1, lrow] := FieldByName('TASK_NAME').AsString;

                if not FieldByName('EXD_TASK_START').IsNull then
                  Cell[2, lrow].AsDateTime := FieldByName('EXD_TASK_START')
                    .AsDateTime;

                if not FieldByName('EXD_TASK_END').IsNull then
                  Cell[3, lrow].AsDateTime := FieldByName('EXD_TASK_END')
                    .AsDateTime;

                if not FieldByName('ACT_TASK_START').IsNull then
                  Cell[4, lrow].AsDateTime := FieldByName('ACT_TASK_START')
                    .AsDateTime;

                if not FieldByName('ACT_TASK_END').IsNull then
                  Cell[5, lrow].AsDateTime := FieldByName('ACT_TASK_END')
                    .AsDateTime;

                Cell[6, lrow].AsInteger := FieldByName('ACT_PROGRESS')
                  .AsInteger;
                Cells[7, lrow] := FieldByName('TASK_STATE').AsString;
                Cells[8, lrow] :=
                  Get_UserName(FieldByName('TASK_MANAGER').AsString);
                Cells[9, lrow] :=
                  Get_UserName(FieldByName('TASK_DRAFTER').AsString);
                Cells[10, lrow] := FieldByName('TASK_ORDER').AsString;

                if Check_Task_Edit_Authority(Cells[0, lrow], DM1.FUserInfo.CurrentUsers) then
                  Cell[11, lrow].AsInteger := 0
                else
                  Cell[11, lrow].AsInteger := -1;

//                Next;
//              end; //while
            end;
          end;
        finally
          EndUpdate;
          SelectedRow := lrow;
        end;
      end;
    end;
  end;
end;

procedure TtaskManagement_Frm.taskGridCellFormating(Sender: TObject;
ACol, ARow: Integer; var TextColor: TColor; var FontStyle: TFontStyles;
CellState: TCellState);
begin
  with taskGrid do
  begin
    case ACol of
      2 .. 5:
        begin
          if Cell[ACol, ARow].AsDateTime = 0 then
            TextColor := clWhite;

        end;

    end;
    if CellByName['ACT_PROGRESS', ARow].AsInteger = 100 then
    begin
      TextColor := clGrayText;
      FontStyle := FontStyle + [fsStrikeOut];
    end;
  end;
end;

procedure TtaskManagement_Frm.taskGridMouseDown(Sender: TObject;
Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  lrow: Integer;
begin
  with taskGrid do
  begin
    BeginUpdate;
    try
      if Button = mbRight then
      begin
        if lrow <> -1 then
        begin
          SelectedRow := taskGrid.GetRowAtPos(X, Y);
          PopupMenu1.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);

        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TtaskManagement_Frm.taskGridSelectCell(Sender: TObject;
ACol, ARow: Integer);
var
  li: Integer;
begin
  with taskGrid do
  begin
    BeginUpdate;
    try
      if ARow < 0 then
        Exit;

      if GetPrevSibling(ARow) > -1 then
        taskUpBtn.Enabled := True
      else
        taskUpBtn.Enabled := False;

      if GetNextSibling(ARow) > -1 then
        taskDownBtn.Enabled := True
      else
        taskDownBtn.Enabled := False;

      case ACol of
        2 .. 7:
          begin
            if Check_Task_Edit_Authority(Cells[0, ARow], DM1.FUserInfo.CurrentUsers) then
            begin
              Columns[ACol].Options := Columns[ACol].Options + [coEditing];

              if Columns[ACol].Name = 'ACT_PROGRESS' then
              begin
                Cell[ACol, ARow].AsInteger :=
                  Create_setProgress(Cell[ACol, ARow].AsInteger,
                  Mouse.CursorPos.X, Mouse.CursorPos.Y);
              end;
            end;
          end;

        11:
          begin
            if Cell[11, ARow].AsInteger = 0 then
            begin
              if MessageDlg('변경된 내용을 적용 하시겠습니까?', mtConfirmation, [mbYes, mbNo],
                0) = mrYes then
              begin
                if Update_Task(ACol, ARow) then
                begin
                  for li := 0 to Columns.Count - 1 do
                    Cell[0, ARow].TextColor := clBlack;

                  if MessageDlg('변경성공! 변경된 내용을 통보하시겠습니까?', mtConfirmation,
                    [mbYes, mbNo], 0) = mrYes then
                  begin
                    Create_sendSMS_Frm(taskGrid.Cells[0, ARow]);

                  end;
                end
                else
                  ShowMessage('변경오류!');
              end;
            end;
          end;
      end;
    finally
      EndUpdate;
    end;
  end;

  if ARow <> -1 then
  begin
    FcurrentTaskNo := taskGrid.Cells[0, ARow];
    Get_HiTEMS_TMS_TASK_PLAN(FcurrentTaskNo);
  end
  else
  begin
    FcurrentTaskNo := '';
    planGrid.ClearRows;
  end;
end;

procedure TtaskManagement_Frm.taskUpBtnClick(Sender: TObject);
var
  i, ltoRow, lchildCount, lrow: Integer;
  lfromOrder, ltoOrder: Integer;
begin
  with taskGrid do
  begin
    BeginUpdate;
    try
      lrow := SelectedRow;
      lfromOrder := Cell[10, lrow].AsInteger;

      if (Sender as TAdvGlowButton).Name = 'taskUpBtn' then
      begin
        ltoRow := GetPrevSibling(lrow);
        ltoOrder := Cell[10, ltoRow].AsInteger;

        if HasChildren(lrow) then
        begin
          for i := 0 to GetChildCount(lrow) do
            MoveRow(lrow + i, ltoRow + i);
        end
        else
          MoveRow(lrow, ltoRow);
      end
      else
      begin
        ltoRow := GetNextSibling(lrow);
        ltoOrder := Cell[10, ltoRow].AsInteger;
        if HasChildren(ltoRow) then
          ltoRow := ltoRow + GetChildCount(ltoRow);

        if HasChildren(lrow) then
        begin
          lchildCount := GetChildCount(lrow);
          for i := 0 to lchildCount do
            MoveRow(lrow, ltoRow);
        end
        else
        begin
          lchildCount := 0;
          MoveRow(lrow, ltoRow);
        end;

        ltoRow := ltoRow - lchildCount;
      end;

      Cell[10, lrow].AsInteger := lfromOrder;
      Cell[10, ltoRow].AsInteger := ltoOrder;

    finally
      SelectedRow := ltoRow;

      if GetPrevSibling(SelectedRow) > -1 then
        taskUpBtn.Enabled := True
      else
        taskUpBtn.Enabled := False;

      if GetNextSibling(SelectedRow) > -1 then
        taskDownBtn.Enabled := True
      else
        taskDownBtn.Enabled := False;

      EndUpdate;
      Update_Task_Order;
    end;
  end;
end;

function TtaskManagement_Frm.Update_Task(ACol, ARow: Integer): Boolean;
var
  OraQuery: TOraQuery;
  str: String;
begin
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := DM1.OraSession1;
  try
    Result := False;
    with taskGrid do
    begin
      with OraQuery do
      begin
        try
          Close;
          SQL.Clear;
          SQL.Add('UPDATE DPMS_TMS_TASK SET ' +
            'EXD_TASK_START = :EXD_TASK_START, EXD_TASK_END = :EXD_TASK_END, ' +
            'ACT_TASK_START = :ACT_TASK_START, ACT_TASK_END = :ACT_TASK_END, ' +
            'ACT_PROGRESS = :ACT_PROGRESS, TASK_STATE = :TASK_STATE ' +
            'WHERE TASK_NO = :param1 ');

          ParamByName('param1').AsString := taskGrid.Cells[0, ARow];

          if not SameText('1899-12-30', CellByName['EXD_TASK_START',
            ARow].AsString) then
            ParamByName('EXD_TASK_START').AsDate :=
              CellByName['EXD_TASK_START', ARow].AsDateTime
          else
            ParamByName('EXD_TASK_START').Clear;

          if not SameText('1899-12-30', CellByName['EXD_TASK_END',
            ARow].AsString) then
            ParamByName('EXD_TASK_END').AsDate :=
              CellByName['EXD_TASK_END', ARow].AsDateTime
          else
            ParamByName('EXD_TASK_END').Clear;

          if not SameText('1899-12-30', CellByName['ACT_TASK_START',
            ARow].AsString) then
            ParamByName('ACT_TASK_START').AsDate :=
              CellByName['ACT_TASK_START', ARow].AsDateTime
          else
            ParamByName('ACT_TASK_START').Clear;

          if not SameText('1899-12-30', CellByName['ACT_TASK_END',
            ARow].AsString) then
            ParamByName('ACT_TASK_END').AsDate :=
              CellByName['ACT_TASK_END', ARow].AsDateTime
          else
            ParamByName('ACT_TASK_END').Clear;

          ParamByName('ACT_PROGRESS').AsInteger :=
            CellByName['ACT_PROGRESS', ARow].AsInteger;
          ParamByName('TASK_STATE').AsString :=
            CellByName['TASK_STATE', ARow].AsString;

          ExecSQL;
          Result := True;
        except
          Result := False;
        end;
      end;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure TtaskManagement_Frm.Update_Task_Order;
var
  i: Integer;
begin
  with taskGrid do
  begin
    BeginUpdate;
    try
      with DM1.OraQuery1 do
      begin
        for i := 0 to RowCount - 1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('UPDATE DPMS_TMS_TASK SET ' + 'TASK_ORDER = :TASK_ORDER ' +
            'WHERE TASK_NO = :param1 ');
          ParamByName('param1').AsString := taskGrid.Cells[0, i];
          ParamByName('TASK_ORDER').AsInteger := i;

          ExecSQL;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

{ TGetTaskThread }

function TGetTaskThread.Check_Task_Edit_Authority(aTaskNo,
  aUserId: String): Boolean;
var
  OraQuery: TOraQuery;

begin
  if aTaskNo <> '' then
  begin
    OraQuery := TOraQuery.Create(nil);
    OraQuery.Session := DM1.OraSession1;
    try
      with OraQuery do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT TASK_MANAGER, TASK_DRAFTER FROM DPMS_TMS_TASK ' +
          'WHERE TASK_NO = :param1 ');
        ParamByName('param1').AsString := aTaskNo;
        Open;

        if RecordCount <> 0 then
        begin
          if SameText(aUserId, FieldByName('TASK_MANAGER').AsString) or
            SameText(aUserId, FieldByName('TASK_DRAFTER').AsString) then
          begin
            Result := True;
          end
          else
          begin
            Close;
            SQL.Clear;
            SQL.Add('SELECT * FROM DPMS_TMS_AUTHORITY ' + 'WHERE USERID = :param1 ');
            ParamByName('param1').AsString := aUserId;
            Open;

            if RecordCount <> 0 then
            begin
              if FieldByName('TASK_EDIT').AsInteger > 0 then
                Result := True
              else
                Result := False;
            end
            else
            begin
              Result := False;
            end;
          end;
        end
        else
        begin
          Result := False;
        end;
      end;
    finally
      FreeAndNil(OraQuery);
    end;
  end;
end;

constructor TGetTaskThread.Create;
begin
  iCnt := 0;
  FreeOnTerminate := False;
  inherited Create(True);
end;

destructor TGetTaskThread.Destroy;
begin

  inherited;
end;

procedure TGetTaskThread.Display;
var
  i, lrow: Integer;
begin
  with grid_Task do
  begin
    with DM1.OraQuery1 do
    begin
      ProgressDlg.Position := RecNo;
      ProgressDlg.Text := FieldByName('TASK_NAME').AsString + '     ';

      if RowCount = 0 then
        lrow := AddRow(1)
      else
      begin
        if FieldByName('TASK_PRT').AsString <> '' then
        begin
          for i := 0 to RowCount - 1 do
          begin
            if Cells[0, i] = FieldByName('TASK_PRT').AsString then
            begin
              AddChildRow(i, crLast);
              lrow := LastAddedRow;
              Break;
            end;
          end;
        end
        else
          lrow := AddRow(1);
      end;

      Cells[0, lrow] := FieldByName('TASK_NO').AsString;
      Cells[1, lrow] := FieldByName('TASK_NAME').AsString;

      if not FieldByName('EXD_TASK_START').IsNull then
        Cell[2, lrow].AsDateTime := FieldByName('EXD_TASK_START').AsDateTime;

      if not FieldByName('EXD_TASK_END').IsNull then
        Cell[3, lrow].AsDateTime := FieldByName('EXD_TASK_END').AsDateTime;

      if not FieldByName('ACT_TASK_START').IsNull then
        Cell[4, lrow].AsDateTime := FieldByName('ACT_TASK_START').AsDateTime;

      if not FieldByName('ACT_TASK_END').IsNull then
        Cell[5, lrow].AsDateTime := FieldByName('ACT_TASK_END').AsDateTime;

      Cell[6, lrow].AsInteger := FieldByName('ACT_PROGRESS').AsInteger;
      Cells[7, lrow] := FieldByName('TASK_STATE').AsString;
      Cells[8, lrow] := FieldByName('MANAGER_NAME').AsString;
      // Get_UserName(FieldByName('TASK_MANAGER').AsString);
      Cells[9, lrow] := FieldByName('DRAFTER_NAME').AsString;
      // Get_UserName(FieldByName('TASK_DRAFTER').AsString);
      Cells[10, lrow] := FieldByName('TASK_ORDER').AsString;

      if Check_Task_Edit_Authority(Cells[0, lrow], DM1.FUserInfo.CurrentUsers) then
        Cell[11, lrow].AsInteger := 0
      else
        Cell[11, lrow].AsInteger := -1;
    end;
  end;
end;

procedure TGetTaskThread.DisplayPlan;
var
  lrow : integer;
begin
  with Grid_Plan do
  begin
    with DM1.OraQuery1 do
    begin
      lrow := AddRow;

      if FieldByName('TESTCNT').AsInteger > 0 then
        Cell[1, lrow].AsInteger := 2
      else
        Cell[1, lrow].AsInteger := -1;

      Cells[2, lrow] := FieldByName('TASK_NO').AsString;
      Cells[3, lrow] := FieldByName('PLAN_NO').AsString;
      Cells[4, lrow] := FieldByName('PLAN_CODE').AsString;
        
      if FieldByName('PLAN_TYPE').AsInteger = 0 then
        Cells[5, lrow] := '업무'
      else
      if FieldByName('PLAN_TYPE').AsInteger = 1 then
        Cells[5, lrow] := '시험';;
        
      Cells[6, lrow] := FieldByName('ENG_MODEL').AsString;
      Cells[7, lrow] := FieldByName('ENG_TYPE').AsString;

      Cells[8, lrow] := FieldByName('CODE_NAME').AsString;
      Cells[9, lrow] := FieldByName('PLAN_NAME').AsString;
      Cells[10, lrow] := Get_Plan_InCharge(Cells[3, lrow],
        FieldByName('PLAN_REV_NO').AsString, '');
      if not FieldByName('PLAN_START').IsNull then
        Cells[11, lrow] := FieldByName('PLAN_START').AsString
      else
        Cells[11, lrow] := '';

      if not FieldByName('PLAN_END').IsNull then
        Cells[12, lrow] := FieldByName('PLAN_END').AsString
      else
        Cells[12, lrow] := '';

      Cell[13, lrow].AsInteger := FieldByName('PLAN_PROGRESS').AsInteger;

      if Get_AttfilesCount(Cells[3, lrow]) > 0 then
        Cell[14, lrow].AsInteger := 39
      else
        Cell[14, lrow].AsInteger := -1;

      Cell[15, lrow].AsInteger := FieldByName('PLAN_REV_NO').AsInteger;

//        if (Cell[13, lrow].AsInteger = 100) and (rb_hide.Checked = True) then
//          row[lrow].Visible := False;
    end;//with Query1
  end;//with PlanGrid

end;

procedure TGetTaskThread.DisplayPlan2;
var
  LTaskNo, LPlanNo: string;
  i,j: integer;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT A.*,B.*, (SELECT COUNT(*) FROM DPMS_TMS_TEST_RECEIVE_INFO WHERE PLAN_NO = A.PLAN_NO) TESTCNT  ' +
            ' FROM DPMS_TMS_PLAN A ' +
            '                INNER JOIN   (  ' +
            '                SELECT GRP_NO, CODE_NAME FROM DPMS_CODE_GROUP   ) B  ' +
            '                ON A.PLAN_CODE = B.GRP_NO ' +
            ' WHERE PLAN_NO = (SELECT PLAN_NO FROM DPMS_TMS_TEST_RECEIVE_INFO  WHERE REQ_NO = :REQ_NO) AND' +
            '       PLAN_REV_NO = (SELECT MAX(PLAN_REV_NO) PRN FROM DPMS_TMS_PLAN WHERE PLAN_NO =  ' +
            '           (SELECT PLAN_NO FROM DPMS_TMS_TEST_RECEIVE_INFO  WHERE REQ_NO = :REQ_NO) GROUP BY PLAN_NO)');
    ParamByName('REQ_NO').AsString := FReqNo;
    Open;

    if RecordCount > 0 then
    begin
      LTaskNo := FieldByName('TASK_NO').AsString;
      LPlanNo := FieldByName('PLAN_NO').AsString;

      for i := 0 to grid_Task.RowCount - 1 do
      begin
        if grid_Task.Cells[0,i] = LTaskNo then
        begin
          grid_Task.ScrollToRow(i);
          grid_Task.Selected[i] := True;
          grid_Task.SelectCell(0,i);

          for j := 0 to grid_Plan.RowCount - 1 do
          begin
            if grid_Plan.Cells[3,j] = LPlanNo then
            begin
              grid_Plan.ScrollToRow(j);
              grid_Plan.Selected[j] := True;
              break;
            end;
          end;

          break;
        end;
      end;
    end;
  end;
end;

procedure TGetTaskThread.Execute;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;

    SQL.Add('SELECT * FROM' + '( ' + '    SELECT  ' +
      '       A.TASK_NO, TASK_PRT, TASK_LV, TASK_NAME, EXD_TASK_START, ' +
      '       EXD_TASK_END, EXD_MH, ACT_TASK_START, ACT_TASK_END, ' +
      '       ACT_PROGRESS, TASK_OUTLINE, TASK_MANAGER, ' +
      '       TASK_DRAFTER, TASK_INDATE, TASK_ORDER, TASK_STATE, ' +
      '       TASK_TEAM, DRAFTER_NAME, MANAGER_NAME ' + '    FROM ' + '    ( ' +
      '       SELECT ' +
      '         A.TASK_NO, TASK_PRT, TASK_LV, TASK_NAME, EXD_TASK_START, ' +
      '         EXD_TASK_END, EXD_MH, ACT_TASK_START, ACT_TASK_END, ' +
      '         ACT_PROGRESS, TASK_OUTLINE, TASK_MANAGER, TASK_DRAFTER, ' +
      '         TASK_INDATE, TASK_ORDER, TASK_STATE, TASK_TEAM, DRAFTER_NAME ' +
      '       FROM ' + '       ( ' + '           SELECT ' +
      '             A.TASK_NO, TASK_PRT, TASK_LV, TASK_NAME, ' +
      '             EXD_TASK_START, EXD_TASK_END, EXD_MH, ACT_TASK_START, ' +
      '             ACT_TASK_END, ACT_PROGRESS, TASK_OUTLINE, TASK_MANAGER, ' +
      '             TASK_DRAFTER, TASK_INDATE, TASK_ORDER, TASK_STATE, TASK_TEAM '
      + '           FROM DPMS_TMS_TASK A, DPMS_TMS_TASK_SHARE B ' + '           WHERE  ' +
      '           ( ' + '             ( ' +
      '               TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :beginDate  ' +
      '               AND EXD_TASK_END >= TO_DATE(:beginDate, ''yyyy-mm-dd'')  '
      + '                AND TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :endDate  '
      + '                 AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') <= :endDate  '
      + '                OR EXD_TASK_START >= TO_DATE(:beginDate, ''yyyy-mm-dd'')  '
      + '                AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') >= :beginDate  '
      + '                AND TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :endDate  '
      + '                 AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') <= :endDate  '
      + '                 OR TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') >= :beginDate  '
      + '                AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') >= :beginDate  '
      + '                 AND TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :endDate  '
      + '                 AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') >= :endDate  '
      + '                 OR TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :beginDate  '
      + '                 AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') >= :beginDate  '
      + '                 AND TO_CHAR(EXD_TASK_START, ''yyyy-mm-dd'') <= :endDate  '
      + '                AND TO_CHAR(EXD_TASK_END, ''yyyy-mm-dd'') >= :endDate '
      + '            ) ' + '            OR ' + '            ( ' +
      '               (EXD_TASK_START IS NULL) OR (EXD_TASK_END IS NULL) ' +
      '            ) ' + '          ) ' +
      '          AND A.TASK_NO = B.TASK_NO  ' +
      '          AND SUBSTR(TASK_TEAM, 1, 4) = :team  ' + '       ) A JOIN ' +
      '       ( ' +
      '           SELECT USERID, NAME_KOR DRAFTER_NAME FROM DPMS_USER ' +
      '       ) B ' + '       ON A.TASK_DRAFTER = B.USERID ' +
      '    ) A LEFT OUTER JOIN ' + '    ( ' +
      '       SELECT USERID, NAME_KOR MANAGER_NAME FROM DPMS_USER ' +
      '    ) B ' + '    ON A.TASK_MANAGER = B.USERID ' + ') ' +
      'START WITH TASK_PRT IS NULL ' + 'CONNECT BY PRIOR TASK_NO = TASK_PRT ' +
      'ORDER SIBLINGS BY TASK_ORDER ');

    ParamByName('beginDate').AsString := FBeginDate;
    ParamByName('endDate').AsString := FEndDate;
    ParamByName('team').AsString := FTeam;

    Open;

    ProgressDlg.Max := RecordCount;
    try
      with grid_Task do
      begin
        BeginUpdate;
        try
          ClearRows;
          while not eof do
          begin

            Synchronize(Display);

            Application.ProcessMessages;

            Next;
          end;
        finally
          Sleep(300);
          EndUpdate;
        end;
      end;
    finally
      ProgressDlg.Hide;
    end;

    if FReqNo <> '' then
    begin
      Synchronize(DisplayPlan2);
    end;
  end;
end;

procedure TGetTaskThread.SetGridPlan(aGrid: TNextGrid);
begin
  FGridPlan := aGrid;
end;

procedure TGetTaskThread.SetGridTask(aGrid: TNextGrid);
begin
  Fgrid_Task := aGrid;
end;

procedure TGetTaskThread.SetProgressDlg(aDialog: TJvProgressDialog);
begin
  FProgressDlg := aDialog;
end;

end.
