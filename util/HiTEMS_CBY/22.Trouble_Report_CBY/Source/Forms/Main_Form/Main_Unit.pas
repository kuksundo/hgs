unit Main_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvOfficeStatusBar, NxEdit, Vcl.Buttons,
  NxCollection, Vcl.StdCtrls, AdvOfficeButtons, Vcl.ExtCtrls, NxColumnClasses,
  NxColumns, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid,
  AdvGroupBox, Vcl.Imaging.jpeg, VCLTee.Series, VCLTee.TeEngine,
  VCLTee.TeeProcs, VCLTee.Chart, Vcl.Grids, AdvObj, BaseGrid, AdvGrid,
  NxPageControl, Vcl.Menus, HitemsConst_Unit, CommonUtil_Unit, Vcl.ComCtrls,
  Vcl.ImgList, StrUtils, Winapi.ShellAPI, AdvDateTimePicker, JvExComCtrls,
  JvDateTimePicker, AdvSmoothSplashScreen, Generics.Collections,
  VclTee.TeeGDIPlus;

type
  TDeptUsers = class
  private
    FDeptCode: TDictionary<string, string>; //<반코드,반이름>

    constructor Create;
  public
    destructor Destroy; override;
    class function Instance: TDeptUsers;
    procedure GetDeptCodeFromDB;
    function GetDeptCodeList: TDictionary<string, string>;
    function GetDeptNameFromCode(ACode: string): string;
  end;

  TMain_Frm = class(TForm)
    MainMenu1: TMainMenu;
    Files1: TMenuItem;
    Close1: TMenuItem;
    Edit1: TMenuItem;
    Summary1: TMenuItem;
    N1: TMenuItem;
    Statusbar1: TAdvOfficeStatusBar;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    NxHeaderPanel1: TNxHeaderPanel;
    Chart2: TChart;
    Series2: TBarSeries;
    Chart1: TChart;
    Series1: TPieSeries;
    Imglist16x16: TImageList;
    Panel2: TPanel;
    NxAlertWindow1: TNxAlertWindow;
    Button1: TButton;
    Timer1: TTimer;
    NxLinkLabel2: TNxLinkLabel;
    PopupMenu2: TPopupMenu;
    N4: TMenuItem;
    Button2: TButton;
    SaveDialog1: TSaveDialog;
    Panel1: TPanel;
    Panel8: TPanel;
    Panel11: TPanel;
    grptype: TAdvOfficeRadioGroup;
    Panel37: TPanel;
    Panel61: TPanel;
    TITLE: TNxEdit;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel10: TPanel;
    Button7: TButton;
    Button3: TButton;
    INEMPNO: TNxComboBox;
    Panel5: TPanel;
    EngType: TNxComboBox;
    Panel7: TPanel;
    TroubleItems: TNxComboBox;
    NxComboBox1: TNxComboBox;
    DateP1: TJvDateTimePicker;
    Panel9: TPanel;
    DateP2: TJvDateTimePicker;
    NxComboBox2: TNxComboBox;
    Label1: TLabel;
    SplashScreen1: TAdvSmoothSplashScreen;
    Button5: TButton;
    Button6: TButton;
    N2: TMenuItem;
    N3: TMenuItem;
    firstTimer: TTimer;
    N5: TMenuItem;
    Button8: TButton;
    PageControl2: TPageControl;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    MainTable: TAdvStringGrid;
    TempTable: TAdvStringGrid;
    Button4: TButton;
    Button9: TButton;
    TabSheet6: TTabSheet;
    issueGrid: TNextGrid;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    NxComboBoxColumn1: TNxComboBoxColumn;
    NxTextColumn12: TNxTextColumn;
    NxTextColumn14: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn13: TNxTextColumn;
    NxTextColumn4: TNxTextColumn;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    InPCombo: TNxComboBox;
    procedure MainTableGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure Button1Click(Sender: TObject);
    procedure MainTableDblClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure TempTableDblClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TempTableRightClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure N4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure NxComboBox1Select(Sender: TObject);
    procedure NxComboBox2Select(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Panel12Click(Sender: TObject);
    procedure firstTimerTimer(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure MobileTableDblClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure MobileTableGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure Button9Click(Sender: TObject);
    procedure PageControl2Change(Sender: TObject);
    procedure issueGridCellDblClick(Sender: TObject; ACol, ARow: Integer);
  private
    { Private declarations }
    FdotCnt : integer;//결재대기문서 카운트
    FCODEID : STring;
    FReturnMsg : String;
    FTroubleType : TStringList;
    FInEMPNO : TStringList;
    FUserPriv : Integer;
    FFirst : Boolean;

  public
    FUserID : String;
    FTroubleFrmChanged : Boolean;
    { Public declarations }

    procedure Check_for_DB_Connect;

    procedure Initialize_for_First_open;
    procedure Initialize_for_params;
    function Check_System_Version : String;

    procedure Add_for_EngType_and_TroubleType;

    procedure UserInfo_Get_From_DB(UserID : String);

    function Check_for_User_Conditions_RPTYPE : Integer;
    function Check_for_User_Conditions_SDATE : Integer;
    procedure fill_out_of_Main_Table_First; //처음 한번만 실행 사용자 환경 저장기능 이용

    procedure fill_out_of_Main_Table; //메인화면 조건으로 검색

    procedure Statistical_Graph_of_Engine; //엔진별 등록현황 집계...
    procedure Statistical_Graph_of_Operator; // 등록자별 등록현황 집계...

    procedure Manager_Search_to_TempSave;
    procedure Search_to_TempSave; // 결재상신전 임시 저장 데이터 목록 확인(작성자별 출력)
    procedure Search_to_Empno_First(var FCount:integer); // 설계담당자 확인 후 처리해야할 문서 테이블에 등록!


    procedure Scan_to_Pending_Report; //미결재 문서 조회


    procedure Check_for_Return_Msg(FCODE:String);

    procedure Reflect_the_Changes;


    //Moblie 관련
    procedure fill_out_of_MobileTabe;
    function Select_User_Info(fUserId:String) : String;

    procedure Show_Trouble_Mobile_Items(pRow:integer);

    //TRC
    procedure Get_HiTEMS_TRC_ISSUE(aState:Integer);

  end;

var
  Main_Frm: TMain_Frm;
  Excel: Variant;
  MyShape : Variant;
  WorkBook: Variant;//ExcelWorkbook;
  Fworksheet: OleVariant;
  Fworksheet1: OleVariant;

  g_DeptUsers: TDeptUsers;
  g_DeptUsersDestroyed: Boolean;

implementation
uses
  trReport_Unit,HiTEMS_TRC_COMMON,
  DataModule_Unit, Trouble_Unit, PendingRp_Unit, ReturnMsg_Unit,
  CODE_Function, STATISTICS, rpStep_Unit, userConditions_Unit,
  TRtypeUpdate_Unit, DetailS_Unit, Trouble_Mobile_Unit;
{$R *.dfm}

{ TMain_Frm }

procedure TMain_Frm.Add_for_EngType_and_TroubleType;
var
  li, le, lc : integer;
  LCode : String;
  LBool : Boolean;
  LStr : String;
begin
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select Distinct(EngType) from Trouble_Data order by EngType');
    Open;

    EngType.Items.Clear;
    while not(Eof) do
    begin
      EngType.Items.Add(Fieldbyname('EngType').AsString);
      Next;
    end;
  end;

  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from Trouble_Data');
    Open;

    FTroubleType.Clear;
    if not(RecordCount = 0) then
    begin
      for lc := 0 to RecordCount -1 do
      begin
        for li := 1 to 5 do
        begin
          LCode := Fieldbyname('TroubleType'+IntToStr(li)).AsString;

          if not(LCode = '') then
          begin
            if FTroubleType.Count = 0 then
              FTroubleType.Add(LCODE)
            else
            begin
              LBool := True;
              for le := 0 to FTroubleType.Count-1 do
              begin
                if LCode = FTroubleType.Strings[le] then
                begin
                  LBool := False;
                  Break;
                end;
              end;

              if LBool = True then
                FTroubleType.Add(LCode);
            end;
          end;
        end;//for
        Next;
      end;
    end;//if
  end;//with

  FTroubleType.Sorted := True;

  for le:= 0 to FTroubleType.Count-1 do
  begin
    with DM1.EQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select A.Data, B.Data from TS_TroubleRoot A, TS_TroubleType B');
      SQL.Add('where A.CODE = B.PCODE and B.CODE = :param1 order by A.CODE');
      parambyname('param1').AsString := FTroubleType.Strings[le];
      Open;

      if not(RecordCount = 0) then
      begin
        LStr := Fieldbyname('DATA').AsString+'-'+Fieldbyname('DATA_1').AsString;
        TroubleItems.Items.Add(LStr);
      end;
    end;
  end;
end;

procedure TMain_Frm.Button1Click(Sender: TObject);
var
  LForm : TTrouble_Frm;
  LCount : integer;
  lemp : String;
begin
  try
    LForm := TTrouble_Frm.Create(self);
    with LForm do
    begin
      FOwner := Self;
      Caption := '문제점 보고서 신규 등록';
      FOpenCase := 0; //0:신규문서 //1:저장된 문서
      lemp := Statusbar1.Panels[4].Text;
      INEMPNO.Text := Get_UserName(lemp);
      INEMPNO.Hint := lemp;
      Statusbar1.Panels[0].Text := Self.Statusbar1.Panels[0].Text;
      Statusbar1.Panels[1].Text := Self.Statusbar1.Panels[1].Text;
      Statusbar1.Panels[2].Text := Self.Statusbar1.Panels[2].Text;
      Statusbar1.Panels[3].Text := Self.Statusbar1.Panels[3].Text;
      Statusbar1.Panels[4].Text := Self.Statusbar1.Panels[4].Text;

      ShowModal;
    end;
  finally
//    FreeAndNil(LForm);
  end;
end;

procedure TMain_Frm.Button2Click(Sender: TObject);
var
  LWebPath : String;
begin
  LWebPath := 'http://etech.hhi.co.kr:8080/miplatform/tsstart.jsp?userid='+
              Statusbar1.Panels[4].Text;

  ShellExecute(0, 'open',pChar(LWebPath), nil, nil, SW_SHOW);
end;

procedure TMain_Frm.Button3Click(Sender: TObject);
var
  LFileName : String;
begin
  Try
    LFileName := FormatDateTime('YYMMDD_',Now)+'문제점 보고서 목록.xls';
    SaveDialog1.FileName := LFileName;
    if SaveDialog1.Execute then
    begin
      with DM1.AdvGridExcelIO1 do
      begin
        DateFormat := 'YYYY-MM-DD';
        AdvStringGrid := MainTable;
        XLSExport(SaveDialog1.FileName);
      end;
      ShowMessage('목록 출력이 완료 되었습니다.');
    end;
  Except
    ShowMessage('알 수 없는 문제로 목록 출력이 실패되었습니다.');
  End;
end;

procedure TMain_Frm.Button4Click(Sender: TObject);
var
  li : integer;
begin
  case PageControl2.ActivePageIndex of
    0 : fill_out_of_Main_Table;
    1 : Search_to_TempSave;
    2 : fill_out_of_MobileTabe;
  end;
end;

procedure TMain_Frm.Button5Click(Sender: TObject);
var
  LForm : TPendingRp_Frm;
begin
  try
    LForm := TPendingRp_Frm.Create(self);
    with LForm do
    begin
      Fowner := Self;
      Statusbar1.Panels[0].Text := Self.Statusbar1.Panels[0].Text;
      Statusbar1.Panels[1].Text := Self.Statusbar1.Panels[1].Text;
      Statusbar1.Panels[2].Text := Self.Statusbar1.Panels[2].Text;
      Statusbar1.Panels[3].Text := Self.Statusbar1.Panels[3].Text;
      Statusbar1.Panels[4].Text := Self.Statusbar1.Panels[4].Text;
      ShowModal;
    end;
  finally
    FreeAndNil(LForm);
//    Reflect_the_Changes;
  end;
end;

procedure TMain_Frm.Button6Click(Sender: TObject);
var
  LForm : TrpStep_Frm;
begin
  try
    LForm := TrpStep_Frm.Create(self);
    with LForm do
    begin
      FOwner := Self;
      Statusbar1.Panels[0].Text := Self.Statusbar1.Panels[0].Text;
      Statusbar1.Panels[1].Text := Self.Statusbar1.Panels[1].Text;
      Statusbar1.Panels[2].Text := Self.Statusbar1.Panels[2].Text;
      Statusbar1.Panels[3].Text := Self.Statusbar1.Panels[3].Text;
      Statusbar1.Panels[4].Text := Self.Statusbar1.Panels[4].Text;
      ShowModal;
    end;
  finally
    FreeAndNil(LForm);
//    Reflect_the_Changes;
  end;
end;

procedure TMain_Frm.Button7Click(Sender: TObject);
begin
  fill_out_of_Main_Table;
end;

procedure TMain_Frm.Button8Click(Sender: TObject);
var
  LForm : TDetailS_Frm;
begin
  try
    LForm := TDetailS_Frm.Create(self);
    with LForm do
    begin
      FOwner := Self;
      Statusbar1.Panels[0].Text := Self.Statusbar1.Panels[0].Text;
      Statusbar1.Panels[1].Text := Self.Statusbar1.Panels[1].Text;
      Statusbar1.Panels[2].Text := Self.Statusbar1.Panels[2].Text;
      Statusbar1.Panels[3].Text := Self.Statusbar1.Panels[3].Text;
      Statusbar1.Panels[4].Text := Self.Statusbar1.Panels[4].Text;
      ShowModal;
    end;
  finally
    FreeAndNil(LForm);
  end;
end;

procedure TMain_Frm.Button9Click(Sender: TObject);
begin
  if Create_trReport_Frm('') = True then
  begin
    Get_HiTEMS_TRC_ISSUE(1);

  end;
end;

procedure TMain_Frm.Check_for_DB_Connect;
var
  LStat : String;
begin
  LStat := '';
  with DM1 do
  begin
    if not(TSession1.Connected) then
      LStat := 'TBACS 연결 실패';

    if not(TSession1.Connected) then
      LStat := 'EDMS 연결 실패';
  end;

  if not(LStat = '') then
  begin
    ShowMessage(LStat);
  end
  else
  begin
    Statusbar1.Panels[0].ImageIndex := 1;
    Statusbar1.Panels[0].Text := 'DB : Connected';
  end;
end;

procedure TMain_Frm.Check_for_Return_Msg(FCODE: String);
var
  LForm : TReturnMsg_Frm;
begin
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from ZHITEMS_DOCRETURN where CODEID = :param1 order by BCount Desc');
    parambyname('param1').AsString := FCODE;
    Open;

    if not(RecordCount = 0) then
    begin
      try
        LForm := TReturnMsg_Frm.Create(nil);
        with LForm do
        begin
          FMode := 1; // 0: 등록모드, 1:확인모드
          Label1.Caption := FCODE;
          RichEdit1.Text := FieldbyName('DCOMMENT').AsString;
          ShowModal;
        end;
      finally
        FreeAndNil(LForm);
      end;
    end;
  end;
end;

function TMain_Frm.Check_for_User_Conditions_RPTYPE: Integer;
begin
  Result := 0;
  with DM1.TQuery2 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from Trouble_UserConditions where UserID = :param1');
    parambyname('param1').AsString := Statusbar1.Panels[4].Text;
    Open;

    if not(RecordCount = 0) then
      Result := Fieldbyname('RPTYPE').AsInteger;

  end;
end;

function TMain_Frm.Check_for_User_Conditions_SDATE: Integer;
begin
  Result := 0;
  with DM1.TQuery2 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from Trouble_UserConditions where UserID = :param1');
    parambyname('param1').AsString := Statusbar1.Panels[4].Text;
    Open;

    if not(RecordCount = 0) then
      Result := Fieldbyname('SDATETERMS').AsInteger;

  end;
end;

function TMain_Frm.Check_System_Version: String;
begin
  Result := '';
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from ZHITEMS_SYSTEMINFO');
    SQL.Add('where SYSFLAG = ''P01TR'' order by REGDATE DESC');
    Open;

    if not(RecordCount = 0) then
      Result := Fieldbyname('LASTWRITETIME').AsString;

  end;
end;

procedure TMain_Frm.Close1Click(Sender: TObject);
begin
  Close;

end;

procedure TMain_Frm.fill_out_of_Main_Table;
var
  LDate,LDate1 : String;
  LStr : String;
  li : integer;
  LUserID, LEMPNO : String;
  LRPResult : integer;
begin
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select * from TROUBLE_DATA ');

    case GrpType.ItemIndex of
      0 : SQL.Add('where Rptype in (0,1,2)');
      1 : SQL.Add('where Rptype in (0)');//품질
      2 : SQL.Add('where Rptype in (1)');//설비
      3 : SQL.Add('where Rptype in (2)');//예상
    end;

    if not(Title.Text = '') then
      SQL.Add(' and Title LIKE ''%'+Title.Text+'%''');

    if not(INEMPNO.Text = '') then
    begin
      LStr := FINEMPNO.Strings[INEMPNO.ItemIndex];
      case NxComboBox2.ItemIndex of
        1 : SQL.Add(' and INEMPNO = '''+ LStr + '''');
        2 : SQL.Add(' and EMPNO = '''+ LStr + '''');
      end;
    end;

    if not(EngType.Text = '') then
      SQL.Add(' and EngType = '''+ EngType.Text + '''');

    if not(TroubleItems.Text = '') then
    begin
      LStr := FTroubleType.Strings[TroubleItems.ItemIndex];
      SQL.Add(' and TroubleType1 = '''+ LStr+ '''');
      SQL.Add(' or TroubleType2 = '''+ LStr + '''');
      SQL.Add(' or TroubleType3 = '''+ LStr + '''');
      SQL.Add(' or TroubleType4 = '''+ LStr + '''');
      SQL.Add(' or TroubleType5 = '''+ LStr + '''');
    end;

    LDate := FormatDateTime(DateP1.Format,DateP1.DateTime);
    LDate1 := FormatDateTime(DateP2.Format,DateP2.DateTime);

    if InPCombo.ItemIndex = 0 then
    begin
      case NxComboBox1.ItemIndex of
        1 : SQL.Add(' and to_char(InDate,''yyyy-mm-dd'')='''+LDate+'''');//일
        2 : SQL.Add(' and to_char(InDate,''yyyy-mm'')='''+LDate+'''');//월
        3 : SQL.Add(' and Indate between '''+LDate+''' and '+''''+LDate1+'''');
      end;

      SQL.Add(' order by INDATE DESC');
    end
    else
    if InPCombo.ItemIndex = 1 then
    begin
      case NxComboBox1.ItemIndex of
        1 : SQL.Add(' and to_char(SDate,''yyyy-mm-dd'')='''+LDate+'''');//일
        2 : SQL.Add(' and to_char(SDate,''yyyy-mm'')='''+LDate+'''');//월
        3 : SQL.Add(' and Sdate between '''+LDate+''' and '+''''+LDate1+'''');
      end;

      SQL.Add(' order by SDATE DESC');
    end;

    Open;

    MainTable.AutoSize := False;
    MainTable.Color := clWhite;

    if not(RecordCount = 0) then
      label1.Caption := '※ 검색된 데이터는 모두 ('+IntToStr(RecordCount)+')건 입니다.'
    else
      label1.Caption := '※ 검색된 데이터가 없습니다.';

    if not(RecordCount = 0) then
      MainTable.RowCount := RecordCount+1
    else
    begin
      MainTable.RowCount := 2;
      MainTable.ClearRows(1,1);
//      MainTable.RowFontColor[1] := clBlack;
//      MainTable.RowColorTo[2] := clRed;
    end;

    for li := 0 to RecordCount-1 do
    begin
      with MainTable do
      begin
//        RowColor[li+1] := clWhite;
//        RowFontColor[li+1] := 0;

        Cells[0,li+1] := IntToStr(li+1);
        Cells[1,li+1] := FieldByName('CODEID').AsString;
        Cells[2,li+1] := FieldByName('ProjNo').AsString;
        Cells[3,li+1] := FieldByName('EngType').AsString;
        Cells[4,li+1] := FormatDateTime('YYYY-MM-DD',FieldByName('Indate').AsDateTime);

        LUserID := fieldbyname('InEMPNO').AsString;

        if LUserID <> '' then
        begin
          if IsHanGeul(LUserID) = True then
            MainTable.Cells[5,li+1] := fieldbyname('InEMPNO').AsString
          else
          begin
  //          with DM1.TQuery2 do
  //          begin
  //            Close;
  //            SQL.Clear;
  //            sQL.Add('select Name_Kor from HITEMS.HITEMS_USER WHERE UserID = :param1');
  //            parambyname('param1').AsString := LUserID;
  //            Open;
  //            MainTable.Cells[5,li+1] := fieldbyname('Name_Kor').AsString;
  //          end;
            MainTable.Cells[5,li+1] := DM1.GetKORNameFromID(LUserID);
          end;
        end;

        LStr := FormatDateTime('yyyy-MM-dd HH:mm', Fieldbyname('SDate').AsDateTime);
        Cells[6,li+1] := LeftStr(LStr,10);
        Cells[7,li+1] := FieldByName('Title').AsString;


        LStr := Fieldbyname('FResult').AsString;

        if not(LStr = '') then
        begin
          LRPResult := Fieldbyname('FResult').AsInteger;
          case LRPResult of
            0 : Cells[8,li+1] := '미조치';
            1 : Cells[8,li+1] := '조치입력중';
            2 : Cells[8,li+1] := '조치완료';
          end;
        end;

        LEMPNO := fieldbyname('EMPNO').AsString;
        if not(LEMPNO = '') then
        begin
          if IsHanGeul(LEMPNO) = True then
            MainTable.Cells[9,li+1] := fieldbyname('EMPNO').AsString
          else
          begin
//            with DM1.TQuery2 do
//            begin
//              Close;
//              SQL.Clear;
//              sQL.Add('select Name_Kor from HITEMS.HITEMS_USER where UserID = :param1');
//              parambyname('param1').AsString := LEMPNO;
//              Open;
//              MainTable.Cells[9,li+1] := fieldbyname('Name_Kor').AsString;
//            end;
            MainTable.Cells[9,li+1] := DM1.GetKORNameFromID(LEMPNO);
          end;
        end;
      end;
      Next;
    end;//for
    MainTable.AutoSize := True;
    MainTable.ColWidths[1] := 0;
    MainTable.Refresh;
    MainTable.Invalidate;

    Statistical_Graph_of_Operator; //작성자별 등록현황 집계
    Statistical_Graph_of_Engine; //엔진별 등록현황 집계
  end;//with
end;

procedure TMain_Frm.fill_out_of_Main_Table_First;
var
  LDate,LDate1 : String;
  LStr : String;
  li : integer;
  LUserID, LEMPNO : String;
  LRPResult : integer;
begin
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select * from TROUBLE_DATA ');

    case Check_for_User_Conditions_RPTYPE of
      0 : SQL.Add('where Rptype in (0,1,2)');
      1 : SQL.Add('where Rptype in (0)');//품질
      2 : SQL.Add('where Rptype in (1)');//설비
      3 : SQL.Add('where Rptype in (2)');//예상
    end;

    if not(Title.Text = '') then
      SQL.Add(' and Title LIKE ''%'+Title.Text+'%''');

    if not(INEMPNO.Text = '') then
    begin
      LStr := FINEMPNO.Strings[INEMPNO.ItemIndex];
      case NxComboBox2.ItemIndex of
        1 : SQL.Add(' and INEMPNO = '''+ LStr + '''');
        2 : SQL.Add(' and EMPNO = '''+ LStr + '''');
      end;
    end;

    if not(EngType.Text = '') then
      SQL.Add(' and EngType = '''+ EngType.Text + '''');

    if not(TroubleItems.Text = '') then
    begin
      LStr := FTroubleType.Strings[TroubleItems.ItemIndex];
      SQL.Add(' and TroubleType1 = '''+ LStr+ '''');
      SQL.Add(' or TroubleType2 = '''+ LStr + '''');
      SQL.Add(' or TroubleType3 = '''+ LStr + '''');
      SQL.Add(' or TroubleType4 = '''+ LStr + '''');
      SQL.Add(' or TroubleType5 = '''+ LStr + '''');
    end;

    case Check_for_User_Conditions_SDATE of
      1 : begin
            LDate := FormatDateTime('yyyy-mm-dd',Now);
            SQL.Add(' and to_char(InDate,''yyyy-mm-dd'')='''+LDate+'''');//일
          end;
      2 : begin
            LDate := FormatDateTime('yyyy-mm',Now);
            SQL.Add(' and to_char(InDate,''yyyy-mm'')='''+LDate+'''');//월
          end;

      3 : begin
            LDate := FormatDateTime('yyyy-mm-dd',Now-7);
            LDate1 := FormatDateTime('yyyy-mm-dd',Now);
            SQL.Add(' and Indate between '''+LDate+''' and '+''''+LDate1+'''');
          end;
    end;

    SQL.Add(' order by INDATE DESC');
    Open;

    MainTable.AutoSize := False;
    MainTable.Color := clWhite;

    if not(RecordCount = 0) then
      label1.Caption := '※ 검색된 데이터는 모두 ('+IntToStr(RecordCount)+')건 입니다.'
    else
      label1.Caption := '※ 검색된 데이터가 없습니다.';

    if not(RecordCount = 0) then
      MainTable.RowCount := RecordCount+1
    else
    begin
      MainTable.RowCount := 2;
      MainTable.ClearRows(1,1);
//      MainTable.RowFontColor[1] := clBlack;
//      MainTable.RowColorTo[2] := clRed;
    end;

    for li := 0 to RecordCount-1 do
    begin
      with MainTable do
      begin
//        RowColor[li+1] := clWhite;
//        RowFontColor[li+1] := 0;

        Cells[0,li+1] := IntToStr(li+1);
        Cells[1,li+1] := FieldByName('CODEID').AsString;
        Cells[2,li+1] := FieldByName('ProjNo').AsString;
        Cells[3,li+1] := FieldByName('EngType').AsString;
        Cells[4,li+1] := FormatDateTime('YYYY-MM-DD',FieldByName('Indate').AsDateTime);

        LUserID := fieldbyname('InEMPNO').AsString;

        if LUserId <> '' then
        begin
          if IsHanGeul(LUserID) = True then
            MainTable.Cells[5,li+1] := fieldbyname('InEMPNO').AsString
          else
          begin
            with DM1.TQuery2 do
            begin
              Close;
              SQL.Clear;
              sQL.Add('select Name_Kor from HITEMS.HITEMS_USER where UserID = :param1');
              parambyname('param1').AsString := LUserID;
              Open;
              MainTable.Cells[5,li+1] := fieldbyname('Name_Kor').AsString;
            end;
          end;
        end;

        LStr := FormatDateTime('yyyy-MM-dd HH:mm', Fieldbyname('SDate').AsDateTime);
        Cells[6,li+1] := LeftStr(LStr,10);
        Cells[7,li+1] := FieldByName('Title').AsString;


        LStr := Fieldbyname('FResult').AsString;

        if not(LStr = '') then
        begin
          LRPResult := Fieldbyname('FResult').AsInteger;
          case LRPResult of
            0 : Cells[8,li+1] := '미조치';
            1 : Cells[8,li+1] := '조치입력중';
            2 : Cells[8,li+1] := '조치완료';
          end;
        end;

        LEMPNO := fieldbyname('EMPNO').AsString;
        if not(LEMPNO = '') then
        begin
          if IsHanGeul(LEMPNO) = True then
            MainTable.Cells[9,li+1] := fieldbyname('EMPNO').AsString
          else
          begin
            with DM1.TQuery2 do
            begin
              Close;
              SQL.Clear;
              sQL.Add('select Name_Kor from HITEMS.HITEMS_USER where UserID = :param1');
              parambyname('param1').AsString := LEMPNO;
              Open;
              MainTable.Cells[9,li+1] := fieldbyname('Name_Kor').AsString;
            end;
          end;
        end;
      end;
      Next;
    end;//for
    MainTable.AutoSize := True;
    MainTable.ColWidths[1] := 0;
    MainTable.Refresh;
    MainTable.Invalidate;

    Statistical_Graph_of_Operator; //작성자별 등록현황 집계
    Statistical_Graph_of_Engine; //엔진별 등록현황 집계
  end;//with
end;


procedure TMain_Frm.fill_out_of_MobileTabe;
var
  li : integer;
  lidx : integer;
  lvalue : String;
begin
//  with DM1.TQuery1 do
//  begin
//    Close;
//    SQL.Clear;
//    SQL.Add('select * from Trouble_Mobile order by Indate Desc');
//    Open;
//
//    if not(RecordCount = 0) then
//      MobileTable.RowCount := RecordCount+1
//    else
//      MobileTable.RowCount := 2;
//
//    li := 0;
//
//    with MobileTable do
//    begin
//      beginUpdate;
//      autoSize := False;
//      while not eof do
//      begin
//        Inc(li);
//        Cells[1,li] := Fieldbyname('TCODEID').AsString;
//        Cells[2,li] := Fieldbyname('MCODEID').AsString;
//        Cells[3,li] := Fieldbyname('ENGTYPE').AsString;
//        Cells[4,li] := Fieldbyname('STATUS').AsString;
//        Cells[5,li] := FormatDateTime('YYYY-MM-DD',Fieldbyname('INDATE').AsDateTime);
//        Cells[6,li] := Select_User_Info(Fieldbyname('INFORMER').AsString);
//
//        lidx := Fieldbyname('STEP').AsInteger;
//        case lidx of
//          0 : lvalue := '미접수';
//          1 : lvalue := '담당자 지정';
//          2 : lvalue := '담당자 확인';
//          3 : lvalue := '보고서 작성중';
//          4 : lvalue := '보고서 완료';
//        end;
//        Cells[7,li] := lvalue;
//        Cells[8,li] := Select_User_Info(Fieldbyname('INEMPNO').AsString);
//        Cells[9,li] := Select_User_Info(Fieldbyname('EMPNO').AsString);
//        Next;
//
//      end;
//      autoSize := true;
//      ColWidths[1] := 0;
//      ColWidths[2] := 0;
//
//      endUpdate;
//    end;
//  end;
end;

procedure TMain_Frm.firstTimerTimer(Sender: TObject);
begin
  firstTimer.Enabled := False;


  FUserID := ParamStr(1);
  Set_User_Info(FUserID);
  FTroubleType := TStringList.Create;
  FTroubleType.Clear;
  FInEMPNO := TStringList.Create;
  FInEMPNO.Clear;

  Initialize_for_First_open;
  FFirst := False;
end;

procedure TMain_Frm.FormCreate(Sender: TObject);
begin
  if ParamCount > 0 then
  begin
    Sleep(1000);
    firstTimer.Enabled := True;
    FFirst := True;

  end
  else
    Close;
end;

procedure TMain_Frm.Get_HiTEMS_TRC_ISSUE(aState: Integer);
var
  li : integer;
  lrow : Integer;
  lbackColor : TColor;
  lpCnt,
  lmCnt : Integer;
begin
  with issueGrid do
  begin
    BeginUpdate;
    try
      ClearRows;

      with DM1.TQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM HiTEMS_TRC_ISSUE ' +
                'WHERE TRSTATE = :param1 ' +
                'ORDER BY INDATE ');

        ParamByName('param1').AsInteger := aState;
        Open;

        lpCnt := 0;
        lmCnt := 0;
        if RecordCount <> 0 then
        begin
          while not eof do
          begin
            lrow := AddRow;
            Cells[0,lrow] := FieldByName('TROUBLE_NO').AsString;
            Cells[1,lrow] := FormatDateTime('YYYY-MM-DD HH:mm:ss',FieldByName('OCCURENCE').AsDateTime);
            Cells[2,lrow] := NxComboBoxColumn1.Items.Strings[FieldByName('TRTYPE').AsInteger];
            Cells[3,lrow] := FieldByName('TYPECODE').AsString;
            Cells[4,lrow] := FieldByName('TYPENAME').AsString;
            Cells[5,lrow] := FieldByName('STATUS').AsString;
            Cells[6,lrow] := FormatDateTime('YYYY-MM-DD HH:mm:ss',FieldByName('INDATE').AsDateTime);
            Cells[7,lrow] := Get_UserName(FieldByName('INFORMER').AsString);

            if FieldByName('REGTYPE').AsString = 'P' then
            begin
              lbackColor := $00FFE6C4;
              Inc(lpCnt);

            end else
            begin
              lbackColor := $00B6FEE9;
              Inc(lmCnt);
            end;

            for li := 0 to Columns.Count-1 do
              Cell[li,lrow].Color := lbackColor;

            Next;
          end;
        end;
      end;
    finally
      panel13.Caption := '모바일 제보('+IntToStr(lmCnt)+') 건';
      panel14.Caption := 'PC 제보('+IntToStr(lpCnt)+') 건';
      EndUpdate;
    end;
  end;
end;

procedure TMain_Frm.Initialize_for_First_open;
var
  LCount : integer;
  LStr : String;
begin
  SplashScreen1.BeginUpdate;
  SplashScreen1.BasicProgramInfo.ProgramVersion.Text := '';
  SplashScreen1.EndUpdate;
  SplashScreen1.Show;
  try
    Check_for_DB_Connect; //DB 연결상태 확인
    Initialize_for_params;//변수.. 기본값 초기화

    Statusbar1.Panels[4].Text := FUserID;
    Statusbar1.Panels[6].Text := Check_System_Version;

    UserInfo_Get_From_DB(STATUSBAR1.Panels[4].Text);
    Add_for_EngType_and_TroubleType; // 등록된 엔진타입, 트러블 타입

    fill_out_of_Main_Table_First; // 메인화면 채우고 -> 그래프 표시
    fill_out_of_MobileTabe;

    // 관리자 권한 ======================================
    if (Statusbar1.Panels[1].Text = 'S') or (Statusbar1.Panels[1].Text = 'M') then
      Manager_Search_to_TempSave // 작성중인 모든 문서 검색
    else
      Search_to_TempSave; // 작성자 문서만 검색

    Scan_to_Pending_Report;
    Search_to_Empno_First(LCount);//처음 한번만 실행 조치입력할 데이터가 있는지 검색

  finally
    sleep(500);
    SplashScreen1.Hide;
    if not(LCount = 0) then
      ShowMessage('미 완료 보고서는 모두('+IntToStr(LCount)+')건 있습니다.'+#13+
                  '메인화면 좌측상단의 조치대기문서 버튼을 클릭하여, 조치내용을 입력, 완료처리 하여 주십시오.');

    if not(FReturnMsg = '') then
      showMessage(FReturnMsg);

  end;
end;

procedure TMain_Frm.Initialize_for_params;
begin
  FdotCnt := 0;//결재대기문서 카운트
  FCODEID := '';
  FReturnMsg := '';//반려메세지
  FTroubleType.Clear;
  FInEMPNO.Clear;
  DateP1.DateTime := Now;
  DateP2.DateTime := Now;
  NxComboBox1.ItemIndex := -1;
  PageControl1.ActivePageIndex := 0;
  PageControl2.ActivePageIndex := 0;
end;

procedure TMain_Frm.issueGridCellDblClick(Sender: TObject; ACol, ARow: Integer);
begin
  with issueGrid do
  begin
    if Cells[0,Arow] <> '' then
    begin
      Create_trReport_Frm(Cells[0,ARow]);

    end;
  end;
end;

procedure TMain_Frm.MainTableDblClickCell(Sender: TObject; ARow, ACol: Integer);
var
  LCodeId : String;
  LForm : TTrouble_Frm;
begin
  if ARow > 0 then
  begin
    LCodeId := MainTable.Cells[1,ARow];
    try
      LForm := TTrouble_Frm.Create(self);
      with LForm do
      begin
        FOwner := Self;
        Caption := '문제점 보고서 신규 등록';
        FOpenCase := 1; //0:신규문서 //1:저장된 문서
        FUserPriv  := Self.FUserPriv;
        FRpCode := LCodeId;
        Statusbar1.Panels[0].Text := Self.Statusbar1.Panels[0].Text;
        Statusbar1.Panels[1].Text := Self.Statusbar1.Panels[1].Text;
        Statusbar1.Panels[2].Text := Self.Statusbar1.Panels[2].Text;
        Statusbar1.Panels[3].Text := Self.Statusbar1.Panels[3].Text;
        Statusbar1.Panels[4].Text := Self.Statusbar1.Panels[4].Text;
        Show;
      end;
    finally
    end;
  end;
end;

procedure TMain_Frm.MainTableGetAlignment(Sender: TObject; ARow, ACol: Integer;
  var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  case ARow of
    0 : HAlign := taCenter;
  end;
  case ACol of
    0..2  : HAlign := taCenter;
    4..6  : HAlign := taCenter;
    8..9  : HAlign := taCenter;
  end;
end;

procedure TMain_Frm.Manager_Search_to_TempSave;
var
  LCodeID : String;
  LConfirmID : String;
  li,lr : integer;
  LPending : integer;
  LCCount : integer;

begin
  with TempTable do
  begin
    Clear;
    Cells[1,0] := '관리번호';
    Cells[2,0] := '작성일';
    Cells[3,0] := '문제점';
    Cells[4,0] := '결재대기자';
    Cells[5,0] := '문서상태';

    for li := 1 to 4 do
      Alignments[li,0] := taCenter;

  end;//with

  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select A.*, B.APPROVAL1, B.ACount, C.Pending, C.Status from Trouble_DataTemp A, ZHITEMS_APPROVER B, ZHITEMS_APPROVEP C');
    SQL.Add('where A.CODEID = B.CODEID and A.CODEID = C.CODEID order by A.CODEID');
    Open;

    if not(RecordCount = 0) then
    begin
//      TempPanel.Caption := '저장된 문서가 ('+IntToStr(RecordCount)+')건 있습니다.';

      if RecordCount > 4 then
        TempTable.RowCount := RecordCount +1;

      for li := 1 to RecordCount do
      begin
        LPending := FieldByName('Pending').AsInteger;
        Lpending := Lpending+1;
        LCCount  := FieldByName('ACount').AsInteger;

        with TempTable do
        begin
          LCodeID := FieldByName('CODEID').AsString;
          Cells[0,li] := IntToStr(li);
          Cells[1,li] := LCodeID;
          Cells[2,li] := FormatDateTime('YYYY-MM-DD',FieldByName('Indate').AsDateTime);
          Cells[3,li] := FieldByName('Title').AsString;

          if not(LPending > LCCount) then
          begin
            with DM1.TQuery2 do
            begin
              Close;
              SQL.Clear;
              SQL.Add('Select * from zHITEMS_APPROVER');
              SQL.Add('where CODEID = :param1');
              parambyname('param1').AsString := LCODEID;
              Open;

              LConfirmID := Fields[2+LPending].AsString;
            end;

            with DM1.TQuery2 do
            begin
              Close;
              SQL.Clear;
              SQL.Add('Select Name_Kor from HITEMS.HITEMS_USER ');
              SQL.Add('where USERID = :param1');
              parambyname('param1').AsString := LConfirmID;
              Open;

              Cells[4,li] := Fieldbyname('Name_Kor').AsString;
            end;
          end;

          if not(FieldByName('Status_1').AsInteger < 0) then
          begin
            case FieldByName('Status_1').AsInteger of
              0 : Cells[5,li] := '작성중';
              1 : Cells[5,li] := '결재진행중';
              2 : Cells[5,li] := '반려된보고서';
            end;
          end;
        end;
        Next;
      end;//for
    end;
  end;
end;

procedure TMain_Frm.MobileTableDblClickCell(Sender: TObject; ARow,
  ACol: Integer);
begin
  Show_Trouble_Mobile_Items(ARow);
end;

procedure TMain_Frm.MobileTableGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  if not(ACol = 4) then
    HAlign := taCenter;

  if ARow = 0 then
    HAlign := taCenter;
end;

procedure TMain_Frm.N1Click(Sender: TObject);
var
  LForm : TRP_Agg;
begin
  try
    LForm := TRp_Agg.Create(nil);
    with LForm do
    begin
      FOwner := Self;
      ShowModal;
    end;

  finally
    FreeAndNil(LForm);
  end;
end;

procedure TMain_Frm.N2Click(Sender: TObject);
var
  LForm : TuserConditions_Frm;
begin
  try
    LForm := TuserConditions_Frm.Create(nil);
    with LForm do
    begin
      FOwner := Self;
      Statusbar1.Panels[0].Text := Self.Statusbar1.Panels[4].Text;
      ShowModal;
    end;
  finally
    FreeAndNil(LForm);
  end;
end;

procedure TMain_Frm.N4Click(Sender: TObject);
begin
  Check_for_Return_Msg(FCODEID);
end;

procedure TMain_Frm.N5Click(Sender: TObject);
var
  LForm : TTRtypeUpdate_Frm;
begin
  try
    LForm := TTRtypeUpdate_Frm.Create(nil);
    LForm.ShowModal;
  finally
    FreeAndNil(LForm);
  end;
end;

procedure TMain_Frm.NxComboBox1Select(Sender: TObject);
var
  LStr : String;
begin
  case NxComboBox1.ItemIndex of
    0 : begin
          DateP1.Enabled := False;
          DateP2.Enabled := False;
          DateP1.Format := 'yyyy-MM-dd';
        end;

    1 : begin
          DateP1.Enabled := True;
          Panel9.Enabled := False;
          DateP2.Enabled := False;
          DateP1.Format := 'yyyy-MM-dd';
        end;

    2 : begin
          DateP1.Enabled := True;
          Panel9.Enabled := False;
          DateP2.Enabled := False;
          DateP1.Format := 'yyyy-MM';
        end;

    3 : begin
          DateP1.Enabled := True;
          Panel9.Enabled := True;
          DateP2.Enabled := True;
          DateP1.Format := 'yyyy-MM-dd';
        end;
  end;
end;

procedure TMain_Frm.NxComboBox2Select(Sender: TObject);
var
  lc,le : integer;
  LStr : String;

begin
  case NxComboBox2.ItemIndex of
    0 : begin
          InEMPNO.Clear;
          InEmpNo.Items.Clear;
          FINEMPNO.Clear;
        end;

    1 : begin
          //작성자
          FInEMPNO.Clear;
          InEmpNo.Items.Clear;
          with DM1.TQuery1 do
          begin
            Close;
            SQL.Clear;
            SQL.Add('SELECT DISTINCT A.INEMPNO, B.NAME_KOR, B.GRADE, C.DESCR ' +
                    'FROM TBACS.TROUBLE_DATA A, HITEMS.HITEMS_USER B, HITEMS.HITEMS_USER_GRADE C ' +
                    'WHERE A.INEMPNO = B.USERID ' +
                    'AND B.GRADE = C.GRADE ' +
                    'ORDER BY NAME_KOR ');
            Open;

            if not(RecordCount = 0) then
            begin
              for lc := 0 to RecordCount -1 do
              begin
                FINEMPNO.Add(Fieldbyname('INEMPNO').AsString);
                INEMPNO.Items.Add(Fieldbyname('DESCR').AsString+' '+Fieldbyname('NAME_KOR').AsString);
                Next;
              end;
            end;//if
          end;//with
        end;

    2 : begin
          //설계담당자
          FInEMPNO.Clear;
          InEmpNo.Items.Clear;
          with DM1.TQuery1 do
          begin
            Close;
            SQL.Clear;
            SQL.Add('SELECT DISTINCT A.EMPNO, B.NAME_KOR, B.GRADE, C.DESCR ' +
                    'FROM TBACS.TROUBLE_DATA A, HITEMS.HITEMS_USER B, HITEMS.HITEMS_USER_GRADE C ' +
                    'WHERE A.EMPNO = B.USERID ' +
                    'AND B.GRADE = C.GRADE ' +
                    'ORDER BY NAME_KOR ');
            Open;

            if not(RecordCount = 0) then
            begin
              for lc := 0 to RecordCount -1 do
              begin
                FINEMPNO.Add(Fieldbyname('EMPNO').AsString);
                INEMPNO.Items.Add(Fieldbyname('DESCR').AsString+' '+Fieldbyname('NAME_KOR').AsString);
                Next;
              end;
            end;//if
          end;//with
        end;
  end;
end;

procedure TMain_Frm.PageControl2Change(Sender: TObject);
begin
  case PageControl2.ActivePageIndex of
    2 : Get_HiTEMS_TRC_ISSUE(1);//제보된 리스트 가져오기
  end;
end;

procedure TMain_Frm.Panel12Click(Sender: TObject);
var
  li : integer;
begin
  li := 0;

end;

procedure TMain_Frm.Reflect_the_Changes;
var
  LCount : integer;
begin
  FTroubleFrmChanged := False;
  fill_out_of_Main_Table;
  Statistical_Graph_of_Operator; //작성자별 등록현황 집계
  Statistical_Graph_of_Engine; //엔진별 등록현황 집계

  // 관리자 권한 ======================================
  if Statusbar1.Panels[1].Text = 'M' then
  begin
    Manager_Search_to_TempSave;
  end
  // 일반 유저 =========================================
  else
  begin
    Scan_to_Pending_Report;
    Search_to_TempSave;
    Search_to_Empno_First(LCount);//처음 한번만 실행 조치입력할 데이터가 있는지 검색
    if not(LCount = 0) then
      ShowMessage('미 완료 보고서는 모두('+IntToStr(LCount)+')건 있습니다.'+#13+
                  '메인화면 좌측상단의 조치대기문서 버튼을 클릭하여, 조치내용을 입력, 완료처리 하여 주십시오.');
  end;
end;

procedure TMain_Frm.Scan_to_Pending_Report;
var
  li : integer;
  LP : integer;
  LStr : String;
  LCount : integer;
  LS : String;

begin
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select distinct A.*, B.Pending, B.Status from ZHITEMS_APPROVER A, ZHITEMS_APPROVEP B');
    SQL.Add('where A.CODEID = B.CODEID and FLAG = ''P01TR''');
    Open;

    if RecordCount = 0 then
    begin
      Button5.Enabled := False;
      Timer1.Enabled := False;
      Exit;
    end;

    LStr := Statusbar1.Panels[4].Text;
    LCount := 0;

    for li := 0 to RecordCount -1 do
    begin
      if FieldByName('Status').AsInteger=1 then
      begin
        LP := FieldByname('pending').AsInteger;
        if not(LP >= FieldByName('ACount').AsInteger) then
        begin
          if LStr = Fields[3+LP].AsString then
            Inc(LCount);
        end;
      end;
      Next;
    end;//for

    if LCount > 0 then
    begin
      Button5.Enabled := True;
      FdotCnt := 0;
      Timer1.Enabled := True;
      NxAlertWindow1.Text := '  ※.현재결재 대기중인 문서는 '+#13+IntToStr(LCount)+'건 입니다.';
      NxAlertWindow1.Popup;
    end
    else
    begin
      Button5.Enabled := False;
      Timer1.Enabled := False;
      NxLinkLabel2.Caption := '';
    end;
  end;
end;

procedure TMain_Frm.Search_to_Empno_First(var FCount: integer);
var
  LCodeID, LUserID : String;
  li,LC : integer;
begin
  LUserID := Statusbar1.Panels[4].Text;
  FCount := 0;

  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select * from Trouble_Data where EmpNo = :param1 and (FResult = 0 or FResult = 1)');
    parambyname('param1').AsString := Statusbar1.Panels[4].Text;
    Open;

    if not(RecordCount =0) then
    begin
      FCount := RecordCount;
      Button6.Enabled := True;
      Timer1.Enabled := True;
    end
    else
    begin
      Button6.Enabled := False;

      if Timer1.Enabled = False then
        Timer1.Enabled := False;
    end;
  end;
end;

procedure TMain_Frm.Search_to_TempSave;
var
  LUserID : String;
  LCodeID : String;
  LApproveID : String;
  li,lr : integer;
  LPending : integer;
  LCCount : integer;
  LReturnCnt : integer;

begin
  LUserID := Statusbar1.Panels[4].Text;
  LReturnCnt := 0;
  with TempTable do
  begin
    Clear;
    Cells[1,0] := '관리번호';
    Cells[2,0] := '작성일';
    Cells[3,0] := '문제점';
    Cells[4,0] := '결재대기자';
    Cells[5,0] := '문서상태';

    for li := 1 to 4 do
      Alignments[li,0] := taCenter;

    ColWidths[1] := 0;
  end;//with

  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select distinct A.*, B.APPROVAL1, B.ACount, C.Pending, C.Status from Trouble_DataTemp A, ZHITEMS_APPROVER B, ZHITEMS_APPROVEP C');
    SQL.Add('where A.CODEID = B.CODEID and A.CODEID = C.CODEID and B.APPROVAL1 = :param1 order by A.CODEID');
    parambyname('param1').AsString := LUserID;
    Open;

    if not(RecordCount = 0) then
    begin
      //TempPanel.Caption := '저장된 문서가 ('+IntToStr(RecordCount)+')건 있습니다.';

//      if RecordCount > 4 then
        TempTable.RowCount := RecordCount +1;

      for li := 1 to RecordCount do
      begin
        LPending := FieldByName('Pending').AsInteger;
        Lpending := Lpending+1;
        LCCount  := FieldByName('ACount').AsInteger;

        with TempTable do
        begin
          LCodeID := FieldByName('CODEID').AsString;
          Cells[0,li] := IntToStr(li);
          Cells[1,li] := LCodeID;
          Cells[2,li] := FormatDateTime('YYYY-MM-DD',FieldByName('Indate').AsDateTime);
          Cells[3,li] := FieldByName('Title').AsString;

          if not(LPending > LCCount) then
          begin
            with DM1.TQuery2 do
            begin
              Close;
              SQL.Clear;
              SQL.Add('Select * from ZHITEMS_APPROVER');
              SQL.Add('where CODEID = :param1');
              parambyname('param1').AsString := LCODEID;
              Open;

              LApproveID := Fields[LPending+2].AsString;
            end;

            with DM1.TQuery2 do
            begin
              Close;
              SQL.Clear;
              SQL.Add('Select Name_Kor from HITEMS.HITEMS_USER ');
              SQL.Add('where USERID = :param1');
              parambyname('param1').AsString := LApproveID;
              Open;

              Cells[4,li] := Fieldbyname('Name_Kor').AsString;
            end;
          end;

          if not(FieldByName('Status_1').AsInteger < 0) then
          begin
            case FieldByName('Status_1').AsInteger of
              0 : Cells[5,li] := '작성중';
              1 : Cells[5,li] := '결재진행중';
              2 : Cells[5,li] := '반려된보고서';
            end;

            if FieldByName('Status_1').AsInteger = 2 then
              Inc(LReturnCnt);
          end;
        end;
        Next;
      end;//for
      if LReturnCnt > 0 then
        FReturnMsg := '반려된 문서가 ('+IntToStr(LReturnCnt)+')건 있습니다.';

    end;
  end;
end;

function TMain_Frm.Select_User_Info(fUserId: String): String;
var
  li : integer;
  LName, LClass : String;
begin
  try
    with DM1.TQuery2 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select A.Name_Kor, B.Codenm from HITEMS.HITEMS_USER A, ZHITEMSCODE B');
      SQL.Add('where A.UserID = :param1 and A.CLASS = B.CODE');
      parambyname('param1').AsString := fUserId;
      Open;

      if not(Fieldbyname('Name_Kor').AsString = '') then
      begin
        LName := Fieldbyname('Name_Kor').AsString;
        LClass := Fieldbyname('CODENM').AsString;
        Result := LName + ' ' + LClass;
      end
      else
        Result := '';
    end;
  except
    Result := '';
  end;
end;

procedure TMain_Frm.Show_Trouble_Mobile_Items(pRow:integer);
var
  LForm : TTrouble_Mobile_Frm;
begin
  LForm := TTrouble_Mobile_Frm.Create(nil);
  with LForm do
  begin
    FUserPriv  := Self.FUserPriv;
    PUserInfo.DBConn := Statusbar1.Panels[0].Text;
    PUserInfo.Privity:= Statusbar1.Panels[1].Text;
    PUserInfo.Deptno := Statusbar1.Panels[2].Text;
    PUserInfo.Teamno := Statusbar1.Panels[3].Text;
    PUserInfo.UserId := Statusbar1.Panels[4].Text;
//    FCODEID := MobileTable.Cells[2,pRow];
    ShowModal;
  end;
end;

procedure TMain_Frm.Statistical_Graph_of_Engine;
var
  li, ITC : integer;
  LEngtype : TStringList;
  LDate,LDate1 : String;
  LCnt : Integer;

begin
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select Distinct EngType from TROUBLE_DATA');

    LDate := FormatDateTime(DateP1.Format,DateP1.DateTime);
    LDate1 := FormatDateTime(DateP2.Format,DateP2.DateTime);

    if FFirst = True then
    begin
      case Check_for_User_Conditions_SDATE of
        1 : begin
              LDate := FormatDateTime('yyyy-mm-dd',Now);
              SQL.Add(' where to_char(InDate,''yyyy-mm-dd'')='''+LDate+'''');//일
            end;
        2 : begin
              LDate := FormatDateTime('yyyy-mm',Now);
              SQL.Add(' where to_char(InDate,''yyyy-mm'')='''+LDate+'''');//월
            end;

        3 : begin
              LDate := FormatDateTime('yyyy-mm-dd',Now-7);
              LDate1 := FormatDateTime('yyyy-mm-dd',Now);
              SQL.Add(' where Indate between '''+LDate+''' and '+''''+LDate1+'''');
            end;
      end;
    end
    else
    begin
      case NxComboBox1.ItemIndex of
        1 : SQL.Add(' where to_char(InDate,''yyyy-mm-dd'')='''+LDate+'''');//일
        2 : SQL.Add(' where to_char(InDate,''yyyy-mm'')='''+LDate+'''');//월
        3 : SQL.Add(' where Indate between '''+LDate+''' and '+''''+LDate1+'''');//기간
      end;
    end;

    Open;

    if not(RecordCount = 0) then
    begin
      LEngType := TStringList.Create;
      LEngType.Clear;

      LCnt := RecordCount;
      for li := 0 to RecordCount-1 do
      begin
        LEngType.Add(Fieldbyname('EngType').AsString);
        Next;
      end;
    end
    else
    begin
      Chart1.Series[0].Clear;
      Exit;
    end;
  end;//with

  LEngType.Sorted := True;
  Chart1.Series[0].Clear;

  for li := 0 to LEngType.Count-1 do
  begin
    with DM1.TQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select EngType from TROUBLE_DATA');
      SQL.Add('where EngType = :param1');

      if FFirst = True then
      begin
        case Check_for_User_Conditions_SDATE of
          1 : begin
                LDate := FormatDateTime('yyyy-mm-dd',Now);
                SQL.Add(' and to_char(InDate,''yyyy-mm-dd'')='''+LDate+'''');//일
              end;
          2 : begin
                LDate := FormatDateTime('yyyy-mm',Now);
                SQL.Add(' and to_char(InDate,''yyyy-mm'')='''+LDate+'''');//월
              end;

          3 : begin
                LDate := FormatDateTime('yyyy-mm-dd',Now-7);
                LDate1 := FormatDateTime('yyyy-mm-dd',Now);
                SQL.Add(' and Indate between '''+LDate+''' and '+''''+LDate1+'''');
              end;
        end;
      end
      else
      begin
        case NxComboBox1.ItemIndex of
          1 : SQL.Add(' and to_char(InDate,''yyyy-mm-dd'')='''+LDate+'''');//일
          2 : SQL.Add(' and to_char(InDate,''yyyy-mm'')='''+LDate+'''');//월
          3 : SQL.Add(' and Indate between '''+LDate+''' and '+''''+LDate1+'''');//기간
        end;
      end;

      ParamByName('Param1').AsString := LEngType.Strings[li];
      Open;

      if not (RecordCount = 0) then
        Chart1.Series[0].AddY(RecordCount,LEngType.Strings[li]);
    end;//with
  end;//for
end;


procedure TMain_Frm.Statistical_Graph_of_Operator;
var
  li, ITC : integer;
  LInEmpNo : TStringList;
  LUser : String;
  LDate, LDate1 : String;
  LCnt : integer;
begin
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select Distinct A.InEMPNO, B.Name_Kor from Trouble_Data A, HITEMS.HITEMS_USER B');
    SQL.Add('where A.InempNo = B.UserID');

    LDate := FormatDateTime(DateP1.Format,DateP1.DateTime);
    LDate1 := FormatDateTime(DateP2.Format,DateP2.DateTime);

    if FFirst = True then
    begin
      case Check_for_User_Conditions_SDATE of
        1 : begin
              LDate := FormatDateTime('yyyy-mm-dd',Now);
              SQL.Add(' and to_char(InDate,''yyyy-mm-dd'')='''+LDate+'''');//일
            end;
        2 : begin
              LDate := FormatDateTime('yyyy-mm',Now);
              SQL.Add(' and to_char(InDate,''yyyy-mm'')='''+LDate+'''');//월
            end;

        3 : begin
              LDate := FormatDateTime('yyyy-mm-dd',Now-7);
              LDate1 := FormatDateTime('yyyy-mm-dd',Now);
              SQL.Add(' and Indate between '''+LDate+''' and '+''''+LDate1+'''');
            end;
      end;
    end
    else
    begin
      case NxComboBox1.ItemIndex of
        1 : SQL.Add(' and to_char(InDate,''yyyy-mm-dd'')='''+LDate+'''');//일
        2 : SQL.Add(' and to_char(InDate,''yyyy-mm'')='''+LDate+'''');//월
        3 : SQL.Add(' and Indate between '''+LDate+''' and '+''''+LDate1+'''');//기간
      end;
    end;

    SQL.Add('order by B.Name_Kor');
    Open;

    LInEmpNo := TStringList.Create;
    LInEmpNo.Clear;
    LCnt := RecordCount;
    if not(RecordCount = 0) then
    begin
      for li := 0 to RecordCount-1 do
      begin
        LInEmpNo.Add(fieldbyname('InEmpNo').AsString);
        Next;
      end;
    end
    else
    begin
      Chart2.Series[0].Clear;
      Exit;
    end;
  end;

  Chart2.Series[0].Clear;

  LCnt := 0;
  for li := 0 to LInEmpNo.Count-1 do
  begin
    with DM1.TQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select A.INEMPNO, B.Name_Kor from TROUBLE_DATA A, HITEMS.HITEMS_USER B');
      SQL.Add('where A.InEmpNo = :param1 And A.InEmpNo = B.UserID');

      if FFirst = True then
      begin
        case Check_for_User_Conditions_SDATE of
          1 : begin
                LDate := FormatDateTime('yyyy-mm-dd',Now);
                SQL.Add(' and to_char(InDate,''yyyy-mm-dd'')='''+LDate+'''');//일
              end;
          2 : begin
                LDate := FormatDateTime('yyyy-mm',Now);
                SQL.Add(' and to_char(InDate,''yyyy-mm'')='''+LDate+'''');//월
              end;

          3 : begin
                LDate := FormatDateTime('yyyy-mm-dd',Now-7);
                LDate1 := FormatDateTime('yyyy-mm-dd',Now);
                SQL.Add(' and Indate between '''+LDate+''' and '+''''+LDate1+'''');
              end;
        end;
      end
      else
      begin
        case NxComboBox1.ItemIndex of
          1 : SQL.Add(' and to_char(InDate,''yyyy-mm-dd'')='''+LDate+'''');//일
          2 : SQL.Add(' and to_char(InDate,''yyyy-mm'')='''+LDate+'''');//월
          3 : SQL.Add(' and Indate between '''+LDate+''' and '+''''+LDate1+'''');//기간
        end;
      end;

      SQL.Add('order by B.Name_Kor');
      parambyname('param1').AsString := LInEmpNo.Strings[li];
      Open;

      if not (RecordCount = 0) then
      begin
        if LCnt = 0 then
          LCnt := RecordCount
        else
          if RecordCount > LCnt then LCnt := RecordCount;

        Chart2.Series[0].AddY(RecordCount,FieldBYName('Name_Kor').AsString);
      end;
    end;//with
  end;//for
  Chart2.Axes.Left.Maximum := LCnt + 5;
end;

procedure TMain_Frm.TempTableDblClickCell(Sender: TObject; ARow, ACol: Integer);
var
  LCodeId : String;
  LForm : TTrouble_Frm;
begin
  if ARow > 0 then
  begin
    LCodeId := TempTable.Cells[1,ARow];

    if not(LCODEID = '') then
    begin
      try
        LForm := TTrouble_Frm.Create(self);
        with LForm do
        begin
          FOwner := Self;
          Caption := '문제점 보고서 결재 완료전 문서 조회';
          FOpenCase := 1; //0:신규문서 //1:저장된 문서
          FUserPriv  := Self.FUserPriv;
          FRpCode := LCodeId;
          Statusbar1.Panels[0].Text := Self.Statusbar1.Panels[0].Text;
          Statusbar1.Panels[1].Text := Self.Statusbar1.Panels[1].Text;
          Statusbar1.Panels[2].Text := Self.Statusbar1.Panels[2].Text;
          Statusbar1.Panels[3].Text := Self.Statusbar1.Panels[3].Text;
          Statusbar1.Panels[4].Text := Self.Statusbar1.Panels[4].Text;
          Show;
        end;
      finally
      end;
    end;
  end;
end;

procedure TMain_Frm.TempTableRightClickCell(Sender: TObject; ARow,
  ACol: Integer);
begin
  if not(Arow=0) then
  begin
    if TempTable.Cells[5,Arow] = '반려된보고서' then
    begin
      FCODEID := TempTable.Cells[1,Arow];
      PopupMenu2.Popup(mouse.CursorPos.X, Mouse.CursorPos.Y);
    end;
  end;
end;

procedure TMain_Frm.Timer1Timer(Sender: TObject);
begin
  if Timer1.Enabled then
  begin
    case FdotCnt of
      0 : NxLinkLabel2.Caption := '';
      1 : NxLinkLabel2.Caption := '  ';
      2 : NxLinkLabel2.Caption := '   ';
      3 : NxLinkLabel2.Caption := '    ';
      4 : NxLinkLabel2.Caption := '     ';
    end;

    if FdotCnt = 4 then
      fdotCnt := 0
    else
      Inc(FdotCnt);
  end;
end;

procedure TMain_Frm.UserInfo_Get_From_DB(UserID: String);
var
  LStr : String;
begin
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.add('select * from HITEMS.HiTEMS_USER where UserID = :param1');
    paramByname('param1').AsString := UserID;
    Open;

//    Statusbar1.Panels[1].Text := FieldByName('AUTHORITY').AsString;
    Statusbar1.Panels[2].Text := LEFTSTR(FieldByName('DEPT_CD').AsString,3)+'0';

    FUserPriv := FieldByName('Priv').AsInteger;

    LStr := RightStr(FieldByName('DEPT_CD').AsString,1);
    Statusbar1.Panels[3].Text := LStr;
    Statusbar1.Panels[4].Text := FieldByName('UserID').AsString;
  end;

  if Statusbar1.Panels[1].Text = 'M' then
    N5.Visible := True
  else
  begin
    N5.Visible := False;
    N5.Visible := False;
  end;
end;


{ TDeptUsers }

constructor TDeptUsers.Create;
begin
  g_DeptUsersDestroyed := False;
  FDeptCode := TDictionary<string, string>.create;
  GetDeptCodeFromDB;
end;

destructor TDeptUsers.Destroy;
begin
  g_DeptUsersDestroyed := True;
  FreeAndNil(FDeptCode);

  inherited;
end;

procedure TDeptUsers.GetDeptCodeFromDB;
begin
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM HiTEMS.HiTEMS_DEPT ' +
            'WHERE PARENT_CD LIKE ''K2B%'' AND DEPT_CD LIKE ''%-%''' +
            'ORDER BY DEPT_CD ');
    Open;

    if RecordCount > 0 then
    begin
      FDeptCode.Clear;

      while not eof do
      begin
        FDeptCode.Add(FieldByName('DEPT_CD').AsString, FieldByName('DEPT_NAME').AsString);
        Next;
      end;
    end;
  end;
end;

function TDeptUsers.GetDeptCodeList: TDictionary<string, string>;
begin
  Result := FDeptCode;
end;

function TDeptUsers.GetDeptNameFromCode(ACode: string): string;
begin
  if ACode <> '' then
  begin
    Result := FDeptCode.Items[ACode];
  end;
end;

class function TDeptUsers.Instance: TDeptUsers;
begin
  if g_DeptUsers = nil then
    g_DeptUsers := TDeptUsers.Create;

  Result := g_DeptUsers;
end;

end.
