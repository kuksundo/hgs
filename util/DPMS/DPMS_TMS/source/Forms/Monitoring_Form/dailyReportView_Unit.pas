unit dailyReportView_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, AdvObj, BaseGrid, AdvGrid,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,Ora,
  NxCustomGrid, NxGrid, AdvOfficeTabSet, Vcl.StdCtrls, NxEdit, Vcl.ComCtrls,
  NxCollection, Vcl.ExtCtrls, Vcl.Imaging.jpeg, AdvGlowButton, DateUtils,
  AdvListV, Vcl.ImgList, JvBaseDlg, JvProgressDialog, AdvOutlookList,
  OutlookGroupedList, AdvSmoothProgressBar, Vcl.Menus, AdvMenus, DB,
  ShellApi, StrUtils;

type
  TdailyReportView_Frm = class(TForm)
    Panel5: TPanel;
    Image1: TImage;
    NxHeaderPanel13: TNxHeaderPanel;
    Panel8: TPanel;
    NxSplitter7: TNxSplitter;
    regBtn: TAdvGlowButton;
    NxExpandPanel5: TNxExpandPanel;
    NxExpandPanel3: TNxExpandPanel;
    Label16: TLabel;
    pFrom: TDateTimePicker;
    pTo: TDateTimePicker;
    Button1: TButton;
    Button3: TButton;
    Button5: TButton;
    NxExpandPanel4: TNxExpandPanel;
    empGrid: TNextGrid;
    NxIncrementColumn7: TNxIncrementColumn;
    NxCheckBoxColumn3: TNxCheckBoxColumn;
    NxTextColumn17: TNxTextColumn;
    NxTextColumn18: TNxTextColumn;
    NxTextColumn19: TNxTextColumn;
    NxSplitter1: TNxSplitter;
    Panel1: TPanel;
    AdvOutlookList1: TAdvOutlookList;
    ImageList1: TImageList;
    workName: TLabel;
    userteam: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    lvPerform: TLabel;
    Panel4: TPanel;
    Panel6: TPanel;
    Label4: TLabel;
    Panel7: TPanel;
    Panel9: TPanel;
    Label5: TLabel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Label6: TLabel;
    ListView1: TListView;
    reWorkNote: TRichEdit;
    Panel14: TPanel;
    Label1: TLabel;
    lvManHour: TLabel;
    pprogress: TAdvSmoothProgressBar;
    fileIcon: TImageList;
    lvprogress: TLabel;
    NxExpandPanel1: TNxExpandPanel;
    keyWord: TNxEdit;
    Button2: TButton;
    AdvPopupMenu1: TAdvPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    ImageList2: TImageList;
    SaveDialog1: TSaveDialog;
    cb_team: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure regBtnClick(Sender: TObject);
    procedure AdvOutlookList1ItemClick(Sender: TObject; Item: POGLItem;
      Column: Integer);
    procedure Button2Click(Sender: TObject);
    procedure empGridHeaderClick(Sender: TObject; ACol: Integer);
    procedure ListView1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N2Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure cb_teamDropDown(Sender: TObject);
    procedure cb_teamSelect(Sender: TObject);
  private
    { Private declarations }
    progressDlg : TJvProgressDialog;
    CheckedAll : Boolean;
    OpenFileList : TStringList;

  public
    { Public declarations }
    procedure Set_listView;
    procedure Set_Preview(aResultNo:String);

    procedure Set_Performance(aPlanNo:String;aStartRow:Integer);
//    function Get_TASK_RESULT : TOraQuery;
    function Get_AttFileCount(aResultNo:String) : Integer;
    function Find_keyWord(aKey,aContent:String) : String;

    procedure Check_UserInfo;
    procedure Set_empGrid;
  end;

  PresultItem = ^TresultItem;
  TresultItem = record
    resultNo,
    workName,
    workNote,
    manHour,
    perform,
    progress,
    UserName,
    UserPos,
    UserTeam : String;
    Others : Pointer;
  end;

  TresultList = class(TList)
  private

  protected
    function GetItem(index:Integer):PresultItem;
    procedure SetItem(index:Integer;Item:PresultItem);
  public
    //destructor
    //destructor Destroy; override;
    //functions
    function AddItem(resultNo,workName,workNote,manHour,perform,workProgress,UserName,
                     UserPos,UserTeam:String; others:pointer):integer; //데이터 추가
    procedure InsertItem(Index:integer;resultNo,workName,workNote,manHour,
                         perform,workProgress,UserName,UserPos,UserTeam:String; others:pointer); //데이터 삽입
    procedure DeleteItem(Index:integer);//데이터 삭제
    procedure Clear; override; //리스트 모두 삭제

    property ItemList[Index:integer]:PresultItem read GetItem write SetItem;
  end;

var
  dailyReportView_Frm: TdailyReportView_Frm;
  FresultList : TresultList;
  procedure Create_monTerms_Frm;

implementation

uses
  taskMain_Unit,
  HiTEMS_TMS_COMMON,
  HiTEMS_TMS_CONST,
  CommonUtil_Unit,
  DataModule_Unit;

{$R *.dfm}

procedure Create_monTerms_Frm;
begin
  dailyReportView_Frm := TdailyReportView_Frm.Create(nil);
  with dailyReportView_Frm do
  begin
    Check_UserInfo;
    Show;
  end;
end;

{ TmonTerms_Frm }

procedure TdailyReportView_Frm.AdvOutlookList1ItemClick(Sender: TObject;
  Item: POGLItem; Column: Integer);
var
  olg : TOutlookGroup;
  lResultNo : String;
  S : TStrings;
begin
  S := AdvOutlookList1.GetItemData(Item);

  if S <> nil then
  begin
    lresultNo := S[0];

    Set_Preview(lresultNo);
  end;
end;

procedure TdailyReportView_Frm.Button1Click(Sender: TObject);
var
  lCaption : String;
begin
  if Sender is TButton then
  begin
    lCaption := TButton(Sender).Caption;
    if  lCaption = '오늘' then
    begin
      pFrom.Date := today;
      pTo.Date := today;
    end else
    if  lCaption = '이번주' then
    begin
      pFrom.Date := StartOfTheWeek(toDay);
      pTo.Date := EndOfTheWeek(toDay);
    end else
    if  lCaption = '이번달' then
    begin
      pFrom.Date := StartOfTheMonth(today);
      pTo.Date   := EndOfTheMonth(today);
    end;
    pFrom.Time := strToDateTime('00:00:00');
    pTo.Time := strToDateTime('23:59:59');
  end;
end;

procedure TdailyReportView_Frm.Button2Click(Sender: TObject);
begin
  keyWord.Clear;
end;

procedure TdailyReportView_Frm.cb_teamDropDown(Sender: TObject);
var
  i: integer;
  lteam : string;
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
        SQL.Add('SELECT * FROM DPMS_DEPT ' +
                'WHERE PARENT_CD LIKE :param1 ' +
                'ORDER BY DEPT_CD ');

        ParamByName('param1').AsString := '%'+DM1.FUserInfo.CurrentUsersDept+'%';
        Open;

        if RecordCount <> 0 then
        begin
          for i := 0 to RecordCount-1 do
          begin
            if i = 0 then
            begin
              if FieldByName('DEPT_CD').AsString = DM1.FUserInfo.CurrentUsersTeam then
                Add(FieldByName('DEPT_NAME').AsString);
            end else
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

procedure TdailyReportView_Frm.cb_teamSelect(Sender: TObject);
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
    Set_empGrid;
  end else
  begin
    cb_team.Clear;
    cb_team.Items.Clear;
    cb_team.Hint := '';
  end;
end;

procedure TdailyReportView_Frm.Check_UserInfo;
begin
  NxExpandPanel5.ExpandedText  := Get_DeptName(DM1.FUserInfo.CurrentUsersDept);
  NxExpandPanel5.CollapsedText := Get_DeptName(DM1.FUserInfo.CurrentUsersDept);
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM DPMS_USER ' +
            'WHERE USERID = :param1 ');
    ParamByName('param1').AsString := DM1.FUserInfo.CurrentUsers;
    Open;

    if RecordCount <> 0 then
    begin
      if FieldByName('PRIV').AsInteger > 2 then
      begin
        cb_team.Enabled := True;
      end else
      begin
        cb_team.Enabled := False;
        Set_empGrid;
      end;
    end;
  end;
end;

procedure TdailyReportView_Frm.empGridHeaderClick(Sender: TObject; ACol: Integer);
var
  li : Integer;
begin
  if ACol = 1 then
  begin
    if CheckedAll then
      CheckedAll := False
    else
      CheckedAll := True;

    for li := 0 to empGrid.RowCount-1 do
      empGrid.Cell[1,li].AsBoolean := CheckedAll;


  end;
end;

function TdailyReportView_Frm.Find_keyWord(aKey,aContent:String) : String;
var
  lkey,
  lstr, lstr1 : String;
  li,lidx : Integer;
begin
  li := Length(aKey);
  lkey := UpperCase(aKey);
  lstr := UpperCase(aContent);

  lidx := POS(lkey,lstr);
  if lidx > 0 then
  begin
    lstr := Copy(aContent,0,lidx-1);
    lstr := lstr+'<font color="clred"><b>';

    lstr1 := Copy(aContent,lidx+li,Length(aContent));
    lstr1 := '</b></font>'+lstr1;

    Result := lstr+aKey+lstr1;
  end
  else
    Result := aContent;

end;

procedure TdailyReportView_Frm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TdailyReportView_Frm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  li : integer;
begin
  FresultList.Clear;

  for li := OpenFileList.Count-1 DownTo 0 do
    DeleteFile(OpenFileList.Strings[li]);

  OpenFileList.Clear;
  FreeAndNil(OpenFileList);

end;

procedure TdailyReportView_Frm.FormCreate(Sender: TObject);
begin
  CheckedAll := True;

  AdvOutlookList1.PreviewSettings.Column := 7;
  AdvOutlookList1.PreviewSettings.Active := True;

  pFrom.Date := today;
  pTo.Date   := today;

  FresultList := TresultList.Create;
  OpenFileList := TStringList.Create;

end;

function TdailyReportView_Frm.Get_AttFileCount(aResultNo:String): Integer;
var
  OraQuery : TOraQuery;

begin
  OraQuery := TOraQuery.Create(Self);
  OraQuery.Session := DM1.OraSession1;
  try
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT REGNO FROM DPMS_TMS_ATTFILES ' +
              'WHERE OWNER = :param1 ');
      ParamByName('param1').AsString := aResultNo;
      Open;

      if RecordCount > 0 then
        Result := RecordCount
      else
        Result := 0;

    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

//function TdailyReportView_Frm.Get_TASK_RESULT: TOraQuery;
//var
//  luserId : String;
//  li : Integer;
//begin
//  with DM1.OraQuery1 do
//  begin
//    Close;
//    SQL.Clear;
//    SQL.Add('SELECT * FROM ' +
//            '( ' +
//            '   SELECT A.PLAN_NO, A.RST_NO, RST_CODE, RST_TYPE, RST_PERFORM, ' +
//            '   RST_TITLE, RST_NOTE, RST_PROGRESS, RST_NEXT_TASK, ' +
//            '   PLAN_REV_NO, RST_SORT, RST_BY, RST_MH, RST_TIME_TYPE ' +
//            '   FROM TMS_RESULT A, TMS_RESULT_MH B ' +
//            '   WHERE A.RST_NO = B.RST_NO ' +
//            ') A, ' +
//            '( ' +
//            '   SELECT USERID, DEPT_CD, NAME_KOR, DESCR ' +
//            '   FROM HITEMS_USER A, HITEMS_USER_GRADE B ' +
//            '   WHERE A.GRADE = B.GRADE ' +
//            ') B ' +
//            'WHERE A.RST_BY = B.USERID ' +
//            'AND RST_PERFORM BETWEEN :param1 AND :param2 ' +
//            'AND (DEPT_CD LIKE :teamCode) ' +
//            'AND UPPER(RST_TITLE) LIKE UPPER(:rstTitle) ');
//
//
//    if cb_team.Text <> '' then
//      ParamByName('teamCode').Text := '%'+cb_team.hint+'%'
//    else
//      SQL.Text := ReplaceStr(SQL.Text, 'AND (DEPT_CD LIKE :teamCode) ','');
//
//    ParamByName('param1').AsDate := pFrom.Date;
//    ParamByName('param2').AsDate := pTo.Date;
//
//    if keyWord.Text <> '' then
//      ParamByName('rstTitle').AsString := '%'+keyWord.Text+'%'
//    else
//      SQL.Text := ReplaceStr(SQL.Text, 'AND UPPER(RST_TITLE) LIKE UPPER(:rstTitle) ', '');
//
//    //User
//    lUserId := '';
//    for li := 0 to empGrid.RowCount-1 do
//    begin
//      if empGrid.Cell[1,li].AsBoolean = True then
//        lUserId := lUserId +' '''+ empGrid.Cells[4,li]+ ''',';
//    end;
//
//    if Length(lUserId) > 0 then
//    begin
//      system.Delete(lUserId,Length(lUserId),1);
//      SQL.Add('AND USERID In ('+lUserId+')');
//    end;
//
//    SQL.Add('order by RST_PERFORM ');
//
//    Open;
//
//    Result := DM1.OraQuery1;
//  end;
//end;

procedure TdailyReportView_Frm.ListView1DblClick(Sender: TObject);
begin
  if (Sender as TListView).Selected.Index > -1 then
  begin
    N1.OnClick(Sender);

  end;
end;

procedure TdailyReportView_Frm.ListView1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
  begin
    AdvPopupMenu1.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);


  end;
end;

procedure TdailyReportView_Frm.N1Click(Sender: TObject);
var
  lms: TMemoryStream;
  litem : TListItem;
  lFileName : String;
  lRegNo : String;
begin
  litem := listView1.Selected;
  lFileName := litem.Caption;

  if litem.SubItems.Count > 0 then
    lRegNo := litem.SubItems.Strings[0];

  if lRegNo <> '' then
  begin
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM DPMS_TMS_ATTFILES ' +
              'WHERE REGNO = :param1 ');
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


procedure TdailyReportView_Frm.N2Click(Sender: TObject);
var
  lms: TMemoryStream;
  litem : TListItem;
  lFileName : String;
  lDirectory : String;
  lRegNo : String;
begin
  litem := listView1.Selected;
  lFileName := litem.Caption;

  if litem.SubItems.Count > 0 then
    lRegNo := litem.SubItems.Strings[0];

  if lRegNo <> '' then
  begin
    SaveDialog1.FileName := lFileName;
    if SaveDialog1.Execute then
    begin
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM DPMS_TMS_ATTFILES ' +
                'WHERE REGNO = :param1 ');
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

procedure TdailyReportView_Frm.regBtnClick(Sender: TObject);
begin
  Set_listView;
end;

procedure TdailyReportView_Frm.Set_empGrid;
var
  lRow : Integer;
begin
  with empGrid do
  begin
    BeginUpdate;
    ClearRows;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT A.*, B.DESCR, B.STDTIME FROM DPMS_USER A, DPMS_USER_GRADE B ' +
                'WHERE DEPT_CD LIKE :param1 ' +
                'AND GUNMU = ''I'' ' +
                'AND A.GRADE = B.GRADE ' +
                'ORDER BY PRIV DESC, POSITION, A.GRADE, USERID ');
        ParamByName('param1').AsString := '%'+cb_team.Hint+'%';
        Open;

        while not eof do
        begin
          lRow := AddRow;
          Cell[1,lRow].AsBoolean := True;
          Cells[2,lRow] := FieldByName('NAME_KOR').AsString;
          Cells[3,lRow] := FieldByName('DESCR').AsString;
          Cells[4,lRow] := FieldByName('USERID').AsString;
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TdailyReportView_Frm.Set_listView;
var
  luserId : String;
  lidx,
  li,le : integer;
  OraQuery : TOraQuery;
  lstr,
  lGroupName : String;
  olg : TOutlookGroup;
  lResult : Boolean;
  ls : TStrings;
begin
  with AdvOutlookList1 do
  begin
    BeginUpdate;
    AdvOutlookList1.ClearGroups;
    try
      //User
      lUserId := '';
      for li := 0 to empGrid.RowCount-1 do
      begin
        if empGrid.Cell[1,li].AsBoolean = True then
          lUserId := lUserId +' '''+ empGrid.Cells[4,li]+ ''',';
      end;

      OraQuery := DM1.Get_TASK_RESULT(pFrom.Date, pTo.Date, cb_team.Hint, keyWord.Text, luserId);
//      OraQuery := Get_TASK_RESULT;

      if OraQuery.RecordCount <> 0 then
      begin
        progressDlg := TJvProgressDialog.Create(nil);
        progressDlg.ShowCancel := False;
        progressDlg.InitValues(0,OraQuery.RecordCount,1,0,'업무관리시스템','조건검색중..');
        try
          TThread.Synchronize(nil,procedure
          var
            li,le : Integer;
          begin
            with OraQuery do
            begin
              First;
              progressDlg.Show;
              for li := 0 to RecordCount-1 do
              begin
                lGroupName := Get_DeptName(FieldByName('DEPT_CD').AsString);
                if li <> 0 then
                begin
                  lResult := False;
                  for le := 0 to GroupCount-1 do
                  begin
                    if Groups[le].Caption = lGroupName then
                    begin
                      lResult := True;
                      olg := Groups[le];
                    end;
                  end;
                  if lResult = False then
                    olg := AdvOutlookList1.AddGroup(Get_DeptName(FieldByName('DEPT_CD').AsString));
                end else
                begin
                  olg := AdvOutlookList1.AddGroup(Get_DeptName(FieldByName('DEPT_CD').AsString));
                end;

                //set List
                FresultList.AddItem(FieldByName('RST_NO').AsString,
                                    FieldByName('RST_TITLE').AsString,
                                    FieldByName('RST_NOTE').AsString,
                                    FieldByName('RST_MH').AsString,
                                    FieldByName('RST_PERFORM').AsString,
                                    FieldByName('RST_PROGRESS').AsString,
                                    Get_UserName(FieldByName('USERID').AsString),
                                    FieldByName('DESCR').AsString,
                                    Get_DeptName(FieldByName('DEPT_CD').AsString),
                                    nil);



                ls := AdvOutlookList1.AddItem(olg);
                ls.Add(FieldByName('RST_NO').AsString);//Image


                if Get_AttFileCount(FieldByName('RST_NO').AsString) > 0 then
                  ls.Add('1')
                else
                  ls.Add('-1');

                if keyWord.Text = '' then
                begin
                  ls.Add(FormatDateTime('YYYY-MM-DD',FieldByName('RST_PERFORM').AsDateTime));
                  ls.Add(FieldByName('RST_TITLE').AsString);
                  ls.Add(Get_UserName(FieldByName('USERID').AsString));
                  ls.Add(FieldByName('RST_PROGRESS').AsString);
                  ls.Add(' '+FieldByName('RST_NOTE').AsString);
                end else
                begin
                  lstr := Find_keyWord(keyWord.Text, FieldByName('RST_TITLE').AsString);

                  ls.Add(FormatDateTime('YYYY-MM-DD',FieldByName('RST_PERFORM').AsDateTime));
                  ls.Add(lstr);
                  ls.Add(Get_UserName(FieldByName('USERID').AsString));
                  ls.Add(FieldByName('RST_PROGRESS').AsString);

                  lstr := Find_keyWord(keyWord.Text, FieldByName('RST_NOTE').AsString);
                  ls.Add(' '+lstr);
                end;

                progressDlg.Position := li+1;
                Application.ProcessMessages;
                Next;
              end;
            end;
          end);
        finally
          progressDlg.Free;
        end;
      end
      else
      begin
        workName.Caption := '';
        lvPerform.Caption := '';
        lvManHour.Caption := '';
        userTeam.Caption := '';
        pprogress.Position := 0;
        lvprogress.Caption := '';
        reWorkNote.Clear;
        listView1.Clear;

        ShowMessage('조회된 결과가 없습니다.');
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TdailyReportView_Frm.Set_Performance(aPlanNo: String; aStartRow: Integer);
begin

end;

procedure TdailyReportView_Frm.Set_Preview(aResultNo: String);
const
  listHeight : Integer = 22;
var
  Icon : TIcon;
  OraQuery : TOraQuery;
  li : Integer;
  Pr : PresultItem;
  lFileName : String;
  lItem : TListItem;
begin
  for li := 0 to FresultList.Count-1 do
  begin
    pr := FresultList.GetItem(li);

    if pr.resultNo = aResultNo then
    begin
      workName.Caption := pr.workName;
      reWorkNote.Text  := pr.workNote;
      userTeam.Caption := pr.UserName+' / '+pr.UserPos+' / '+pr.UserTeam;
      lvPerform.Caption := pr.perform;
      lvManHour.Caption := pr.manHour+' M/H';
      pprogress.Position := StrToInt(pr.progress);
      lvprogress.Caption := pr.progress+' %';

      OraQuery := TOraQuery.Create(nil);
      OraQuery.Session := DM1.OraSession1;
      try
        listView1.Clear;
        panel11.Height := listHeight;
        fileICon.Clear;
        with OraQuery do
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT * FROM DPMS_TMS_ATTFILES ' +
                  'WHERE OWNER LIKE :param1 ');
          ParamByName('param1').AsString := aResultNo;
          Open;

          if RecordCount <> 0 then
          begin
            listView1.Column[0].Width := listView1.Width;
            panel11.Height := listHeight * RecordCount;
            while not eof do
            begin
              lItem := listView1.Items.Add;
              with lItem do
              begin
                lFileName := FieldByName('FILENAME').AsString;
                Caption := lFileName;

                SubItems.Add(FieldByName('REGNO').AsString);

                ICon := TIcon.Create;
                ICon.Handle := GetFileIcon('C:\'+lFileName);
                fileIcon.AddIcon(Icon);

                lItem.ImageIndex := fileIcon.Count-1;
//                lItem.ImageIndex := 0;

                ICon.Free;

                Next;
              end;
            end;
          end;
        end;
      finally
        FreeAndNil(OraQuery);
      end;
      Break;
    end;//if
  end;//for
end;

{ TresultList }

function TresultList.AddItem(resultNo, workName, workNote, manHour, perform,
  workProgress, UserName, UserPos, UserTeam: String; others: pointer): integer;
var
  NewItem : PresultItem;
begin
  result := -1;
  New(NewItem);

  if NewItem <> nil then
  try
    NewItem.resultNo := resultNo;
    NewItem.workName := workName;
    NewItem.workNote := workNote;
    NewItem.manHour  := manHour;
    NewItem.perform  := perform;
    NewItem.progress := workProgress;
    NewItem.UserName := UserName;
    NewItem.UserPos  := UserPos;
    NewItem.UserTeam := UserTeam;

    NewItem.Others   := others;

    Result := Add(NewItem);

  except
    Dispose(NewItem);
  end;
end;

procedure TresultList.Clear;
var
  Index : integer;
  Item : PresultItem;
begin
  if Count > 0 then
  begin
    for Index := 0 to Count-1 do
    begin
      Item := ItemList[Index];
      if Item <> nil then
      try
        if Item.Others <> nil then
          Dispose(Item.Others);

      except

      end;
      Dispose(Item);

    end;
  end;
  inherited Clear;
end;

procedure TresultList.DeleteItem(Index: integer);
var
  Item : PresultItem;
begin
  Item := ItemList[Index];

  if Item <> nil then
  begin
    try
      if Item.Others <> nil then
        Dispose(Item.Others);


    except

    end;
    Dispose(Item);
  end;
  Delete(Index);
end;

procedure TresultList.InsertItem(Index: integer; resultNo, workName, workNote,
  manHour, perform, workProgress, UserName, UserPos, UserTeam: String; others: pointer);
var
  NewItem : PresultItem;
begin
  New(NewItem);

  if NewItem <> nil then
  try
    NewItem.resultNo := resultNo;
    NewItem.workName := workName;
    NewItem.workNote := workNote;
    NewItem.manHour  := manHour;
    NewItem.perform  := perform;
    NewItem.progress := workProgress;
    NewItem.UserName := UserName;
    NewItem.UserPos  := UserPos;
    NewItem.UserTeam := UserTeam;

    NewItem.Others   := others;

    Insert(Index,NewItem);
  except
    Dispose(NewItem);
  end;
end;

function TresultList.GetItem(index: Integer): PresultItem;
begin
  result := PresultItem(Items[Index]);
end;


procedure TresultList.SetItem(index: Integer; Item: PresultItem);
begin
  Items[Index] := Item;
end;

end.
