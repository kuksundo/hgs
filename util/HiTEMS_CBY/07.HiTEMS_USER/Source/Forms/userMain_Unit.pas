unit userMain_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  AdvGlowButton, Vcl.ImgList, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Mask, NxEdit,Ora,DB,
  JvExControls, JvLabel, AeroButtons, NxColumnClasses, NxColumns, StrUtils,
  DateUtils, CurvyControls, Vcl.ExtDlgs, AdvOfficeTabSet, AdvOfficeStatusBar,
  DBAdvGlowNavigator, NxDBGrid, DBAccess, MemDS, AdvTreeComboBox, System.Generics.Collections,
  NxDBColumns, Vcl.Grids, Vcl.DBGrids, GIFImg, Vcl.Menus;

type
  TdetailUser_Frm = class(TForm)
    Panel8: TPanel;
    ImageList1: TImageList;
    ImageList32x32: TImageList;
    OpenPictureDialog1: TOpenPictureDialog;
    Image1: TImage;
    AdvOfficeStatusBar1: TAdvOfficeStatusBar;
    Panel3: TPanel;
    JvLabel31: TJvLabel;
    JvLabel1: TJvLabel;
    JvLabel3: TJvLabel;
    JvLabel4: TJvLabel;
    JvLabel5: TJvLabel;
    JvLabel6: TJvLabel;
    JvLabel2: TJvLabel;
    JvLabel7: TJvLabel;
    JvLabel9: TJvLabel;
    JvLabel10: TJvLabel;
    JvLabel11: TJvLabel;
    JvLabel12: TJvLabel;
    JvLabel13: TJvLabel;
    JvLabel15: TJvLabel;
    JvLabel16: TJvLabel;
    JvLabel17: TJvLabel;
    JvLabel8: TJvLabel;
    JvLabel14: TJvLabel;
    JvLabel18: TJvLabel;
    JvLabel19: TJvLabel;
    JvLabel21: TJvLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Panel4: TPanel;
    im_person: TImage;
    Panel5: TPanel;
    im_sign: TImage;
    Panel6: TPanel;
    rb_private: TRadioButton;
    rb_public: TRadioButton;
    Panel7: TPanel;
    rb_solar: TRadioButton;
    rb_lunar: TRadioButton;
    AeroButton1: TAeroButton;
    AeroButton2: TAeroButton;
    AeroButton5: TAeroButton;
    AeroButton6: TAeroButton;
    Panel1: TPanel;
    tab_Grade: TAdvOfficeTabSet;
    OraQuery1: TOraQuery;
    OraDataSource1: TOraDataSource;
    grid_User: TNextGrid;
    ImageList24: TImageList;
    NxIncrementColumn2: TNxIncrementColumn;
    NxTextColumn7: TNxTextColumn;
    NxTextColumn8: TNxTextColumn;
    NxTextColumn9: TNxTextColumn;
    NxTextColumn10: TNxTextColumn;
    NxTextColumn11: TNxTextColumn;
    NxTextColumn12: TNxTextColumn;
    NxTextColumn13: TNxTextColumn;
    NxTextColumn14: TNxTextColumn;
    NxTextColumn15: TNxTextColumn;
    JvLabel23: TJvLabel;
    et_empno: TNxEdit;
    et_nameK: TEdit;
    et_nameE: TEdit;
    cb_grade: TComboBox;
    cb_position: TComboBox;
    cb_dept: TComboBox;
    cb_team: TComboBox;
    dt_runday: TDateTimePicker;
    AeroButton7: TAeroButton;
    dt_chgday: TDateTimePicker;
    AeroButton8: TAeroButton;
    cb_Gunmu: TComboBox;
    tel1: TEdit;
    tel2: TEdit;
    cell1: TEdit;
    cell2: TEdit;
    cell3: TEdit;
    et_email: TEdit;
    et_address: TEdit;
    grid_anniversary: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn6: TNxTextColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn4: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    cb_anniType: TComboBox;
    cb_year: TComboBox;
    cb_month: TComboBox;
    cb_day: TComboBox;
    et_msg: TNxEdit;
    JvLabel20: TJvLabel;
    JvLabel22: TJvLabel;
    AeroButton3: TAeroButton;
    tc_dept: TAdvTreeComboBox;
    AeroButton4: TAeroButton;
    MainMenu1: TMainMenu;
    Close1: TMenuItem;
    Close2: TMenuItem;
    Setting1: TMenuItem;
    UpdateHiTEMS1: TMenuItem;
    UpdateTMSPLANINCHARGE1: TMenuItem;
    N1: TMenuItem;
    AeroButton9: TAeroButton;
    HiTEMSUSERPRIV21: TMenuItem;
    HiTEMSUSERPRIV22: TMenuItem;
    HiTEMSUSERPRIV41: TMenuItem;
    HiTEMSUSERPRIV11: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    procedure cb_gradeDropDown(Sender: TObject);
    procedure cb_gradeSelect(Sender: TObject);
    procedure cb_deptDropDown(Sender: TObject);
    procedure cb_deptSelect(Sender: TObject);
    procedure cb_teamDropDown(Sender: TObject);
    procedure cb_teamSelect(Sender: TObject);
    procedure cb_yearDropDown(Sender: TObject);
    procedure cb_dayDropDown(Sender: TObject);
    procedure AeroButton3Click(Sender: TObject);
    procedure AeroButton1Click(Sender: TObject);
    procedure cb_yearChange(Sender: TObject);
    procedure AeroButton2Click(Sender: TObject);
    procedure AeroButton5Click(Sender: TObject);
    procedure AeroButton6Click(Sender: TObject);
    procedure AeroButton4Click(Sender: TObject);
    procedure dt_rundayChange(Sender: TObject);
    procedure dt_chgdayChange(Sender: TObject);
    procedure AeroButton7Click(Sender: TObject);
    procedure AeroButton8Click(Sender: TObject);
    procedure tc_deptDropDown(Sender: TObject;
      var acceptdrop: Boolean);
    procedure tc_deptDropUp(Sender: TObject; canceled: Boolean);
    procedure tab_GradeTabClick(Sender: TObject; TabIndex: Integer);
    procedure grid_UserCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure Image1DblClick(Sender: TObject);
    procedure UpdateHiTEMS1Click(Sender: TObject);
    procedure UpdateTMSPLANINCHARGE1Click(Sender: TObject);
    procedure AeroButton9Click(Sender: TObject);
    procedure HiTEMSUSERPRIV21Click(Sender: TObject);
    procedure HiTEMSUSERPRIV22Click(Sender: TObject);
    procedure HiTEMSUSERPRIV41Click(Sender: TObject);
    procedure HiTEMSUSERPRIV11Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
  private
    { Private declarations }
    FdeptDic : TDictionary<String,TTreeNode>;
    function Get_UserGrade(aDescr:String):String;
    procedure ChildFormClose(Sender: TObject; var Action: TCloseAction);
  public
    { Public declarations }
    procedure Make_GradeTab(aDept_CD:String);
    procedure Get_Users(aDept_CD, aGrade : String);

    procedure Get_UserInfo(aUserID:String);
//    procedure ChildFormClose(Sender: TObject; var Action: TCloseAction);
//    function ISCreateForm(aClass: TFormClass; aName ,aCaption : String): TForm;
    function ISCreateForm(aClass: TFormClass; aName ,aCaption : String): TForm;
    function Get_DeptName(aDeptCD:String):String;
    function Get_annivesary : String;
    function Update_HiTEMS_USER : Boolean;
    procedure Update_USER_Anniversary;
    procedure Update_TMS_TASK_SHARE;
    procedure Update_TMS_PLAN_INCHARGE;
    procedure Update_TMS_PLAN_INCHARGE_SQL(APlanTeam, APlanEmpNo: string);
    function Is_Duplicate_TaskNo_TaskTeam(ATaskNo, ATaskTeam: string): Boolean;
    function Is_Duplicate_TMS_PLAN_INCHARGE(APlanNo, APlanEmpNo, APlanTeam: string; APlanRole, APlanRevNo: integer): Boolean;

    procedure Update_HiTEMS_User_Priv(APriv, APosition: string);
  end;

var
  detailUser_Frm: TdetailUser_Frm;

implementation

uses
  GetUser_Unit,
  getUserInfo_Unit,
  CommonUtil_Unit,
  DataModule_Unit;

{$R *.dfm}

procedure TdetailUser_Frm.tab_GradeTabClick(Sender: TObject; TabIndex: Integer);
begin
  Get_Users(tc_dept.Hint, tab_grade.AdvOfficeTabs.Items[tabIndex].Caption);
end;

procedure TdetailUser_Frm.tc_deptDropDown(Sender: TObject;
  var acceptdrop: Boolean);
var
  i : Integer;
  lnode : TTreeNode;
begin
  if Assigned(FdeptDic) then
    FdeptDic.Clear
  else
    FdeptDic := TDictionary<String,TTreeNode>.Create;

  with tc_dept.Items do
  begin
    BeginUpdate;
    try
      Clear;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM HITEMS_DEPT ' +
                'START WITH PARENT_CD IS NULL ' +
                'CONNECT BY PRIOR DEPT_CD = PARENT_CD ' +
                'ORDER SIBLINGS BY DEPT_CD, DEPT_LV ');
        Open;

        if RecordCount <> 0 then
        begin
          while not eof do
          begin
            if FdeptDic.Count = 0 then
              lnode := Add(nil,FieldByName('DEPT_NAME').AsString)
            else
            begin
              if FdeptDic.TryGetValue(FieldByName('PARENT_CD').AsString, lnode) then
                lnode := AddChild(lnode, FieldByName('DEPT_NAME').AsString)
              else
                lnode := Add(nil,FieldByName('DEPT_NAME').AsString);
            end;

            FdeptDic.Add(FieldByName('DEPT_CD').AsString, lnode);

            Next;
          end;
        end;
      end;

      for i := 0 to Count-1 do
        Item[i].Expand(True);

    finally
      EndUpdate;
    end;
  end;
end;

procedure TdetailUser_Frm.tc_deptDropUp(Sender: TObject; canceled: Boolean);
var
  i : Integer;
  lselectedNode : TTreeNode;
  lkey : string;

  lCurrentTeam : string;

begin
  i := tc_dept.Selection;
  if i > -1 then
  begin
    lselectedNode := tc_dept.Items.Item[i];

    for lkey in FdeptDic.Keys do
    begin
      if FdeptDic.Items[lkey] = lselectedNode then
        Break;
    end;
    tc_dept.Hint := lkey;
    Make_GradeTab(tc_dept.Hint);
    Get_Users(tc_dept.Hint, tab_grade.AdvOfficeTabs.Items[0].Caption);

  end else
  begin
    tc_dept.Clear;
    tc_dept.Items.Clear;
    tc_dept.Hint := '';
  end;
end;

procedure TdetailUser_Frm.AeroButton1Click(Sender: TObject);
var
  i,
  lrow : Integer;
begin
  if cb_anniType.Text = '' then
  begin
    cb_anniType.SetFocus;
    raise Exception.Create('기념일 구분을 선택하여 주십시오!');
  end;

  if cb_year.ItemIndex = 0 then
  begin
    cb_year.SetFocus;
    raise Exception.Create('년도를 선택하여 주십시오!');
  end;

  if cb_month.ItemIndex = 0 then
  begin
    cb_month.SetFocus;
    raise Exception.Create('월을 선택하여 주십시오!');
  end;

  if cb_day.ItemIndex = 0 then
  begin
    cb_day.SetFocus;
    raise Exception.Create('요일을 선택하여 주십시오!');
  end;

  with grid_anniversary do
  begin
    BeginUpdate;
    try
      lrow := AddRow;

      Cells[1,lrow] := FormatDateTime('yyyyMMddHHmmsszzz',now);
      if rb_public.Checked then
        Cells[2,lrow] := rb_public.Caption
      else if rb_private.Checked then
        Cells[2,lrow] := rb_private.Caption;

      Cells[3,lrow] := cb_anniType.Text;

      if rb_solar.Checked then
        Cells[4,lrow] := rb_solar.Caption
      else if rb_lunar.Checked then
        Cells[4,lrow] := rb_lunar.Caption;

      Cells[5,lrow] := Get_annivesary;

      Cells[6,lrow] := et_msg.Text;

      for i := 0 to Columns.Count-1 do
        Cell[i,lrow].TextColor := clBlue;

    finally
      EndUpdate;
    end;
  end;
end;

procedure TdetailUser_Frm.AeroButton2Click(Sender: TObject);
var
  i : Integer;
begin
  with grid_anniversary do
  begin
    BeginUpdate;
    try
      if SelectedRow > -1 then
      begin
        if Cell[1,SelectedRow].TextColor = clBlue then
          DeleteRow(SelectedRow)
        else
          for i := 0 to Columns.Count-1 do
            Cell[i,SelectedRow].TextColor := clRed;

      end else
        ShowMessage('삭제할 열을 선택하여 주십시오');
    finally
      EndUpdate;
    end;
  end;

end;

procedure TdetailUser_Frm.AeroButton3Click(Sender: TObject);
begin
  Close;
end;

procedure TdetailUser_Frm.AeroButton4Click(Sender: TObject);
var
  i : Integer;
begin
  with DM1.OraTransaction1 do
  begin
    StartTransaction;
    try
      if Update_HiTEMS_USER then
      begin
        Update_USER_Anniversary;
        Commit;
        ShowMessage('수정성공!');
        Get_UserInfo(et_empNo.Text);
        Get_Users(tc_dept.Hint, tab_grade.AdvOfficeTabs.Items[tab_grade.ActiveTabIndex].Caption);
      end else
      begin
        Rollback;
      end;
    except
      on E:Exception do
        ShowMessage(E.Message);
    end;
  end;
end;

procedure TdetailUser_Frm.AeroButton5Click(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then
  begin
    im_person.Picture.LoadFromFile(OpenPictureDialog1.FileName);
    im_person.Hint := OpenPictureDialog1.FileName;
    im_person.Invalidate;
  end;
end;

procedure TdetailUser_Frm.AeroButton6Click(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then
  begin
    im_sign.Picture.LoadFromFile(OpenPictureDialog1.FileName);
    im_sign.Hint := OpenPictureDialog1.FileName;
    im_sign.Invalidate;
  end;
end;

procedure TdetailUser_Frm.AeroButton7Click(Sender: TObject);
begin
  dt_runday.Format := ' ';
end;

procedure TdetailUser_Frm.AeroButton8Click(Sender: TObject);
begin
  dt_chgday.Format := ' ';
end;

procedure TdetailUser_Frm.AeroButton9Click(Sender: TObject);
var
  LForm : TgetUserInfo_Frm;
begin
  LForm := TgetUserInfo_Frm.Create(nil);
  try
    with LForm do
    begin

      ShowModal;

    end;
  finally
    FreeAndNil(LForm);
  end;
end;

procedure TdetailUser_Frm.cb_deptDropDown(Sender: TObject);
begin
  with cb_dept.Items do
  begin
    BeginUpdate;
    try
      Clear;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM HITEMS_DEPT  ' +
                'WHERE DEPT_LV = 1 ');
//                'START WITH DEPT_CD LIKE ''K2'' ' +
//                'CONNECT BY PRIOR DEPT_CD = PARENT_CD ' +
//                'ORDER SIBLINGS BY DEPT_LV, DEPT_CD ');
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

procedure TdetailUser_Frm.cb_deptSelect(Sender: TObject);
var
  i: Integer;
begin
  if cb_dept.Text <> '' then
  begin
    with DM1.OraQuery1 do
    begin
      First;
      for i := 0 to RecordCount-1 do
      begin
        if FieldByName('DEPT_NAME').AsString = cb_dept.Text then
        begin
          cb_dept.Hint := FieldByName('DEPT_CD').AsString;
          Break;
        end;
        Next;
      end;
    end;
  end else
    cb_dept.Hint := '';
end;

procedure TdetailUser_Frm.cb_gradeDropDown(Sender: TObject);
begin
  with cb_grade.Items do
  begin
    BeginUpdate;
    try
      Clear;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM HITEMS_USER_GRADE ' +
                'ORDER BY GRADE ');
        Open;

        Add('');
        while not eof do
        begin
          Add(FieldByName('DESCR').AsString);
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TdetailUser_Frm.cb_gradeSelect(Sender: TObject);
begin
  if cb_grade.Text <> '' then
    cb_grade.Hint := Get_UserGrade(cb_grade.Text)
  else
    cb_grade.Hint := '';
end;

procedure TdetailUser_Frm.cb_teamDropDown(Sender: TObject);
begin
  if cb_dept.Text <> '' then
  begin
    with cb_team.Items do
    begin
      BeginUpdate;
      try
        Clear;
        with DM1.OraQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT * FROM HiTEMS_DEPT ' +
                  'START WITH PARENT_CD = :param1 ' +
                  'CONNECT BY PRIOR DEPT_CD = PARENT_CD ' +
                  'ORDER SIBLINGS BY DEPT_CD ');
          ParamByName('param1').AsString := cb_dept.Hint;
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
  end else
    ShowMessage('먼저 부서를 선택하여 주십시오.');

end;

procedure TdetailUser_Frm.cb_teamSelect(Sender: TObject);
var
  i: Integer;
begin
  if cb_team.Text <> '' then
  begin
    with DM1.OraQuery1 do
    begin
      First;
      for i := 0 to RecordCount-1 do
      begin
        if FieldByName('DEPT_NAME').AsString = cb_team.Text then
        begin
          cb_team.Hint := FieldByName('DEPT_CD').AsString;
          Break;
        end;
        Next;
      end;
    end;
  end else
    cb_team.Hint := '';
end;

procedure TdetailUser_Frm.cb_yearChange(Sender: TObject);
begin
  cb_month.ItemIndex := 0;
  cb_day.ItemIndex := 0;
end;

procedure TdetailUser_Frm.cb_yearDropDown(Sender: TObject);
var
  year,y,
  i,j : Integer;
  str : String;
begin
  with cb_year.Items do
  begin
    BeginUpdate;
    try
      Clear;
      Add('년도');
      j := 0;
      year := StrToInt(LeftStr(DateTimeToStr(today),4));
      for i := 99 DownTo 0 do
      begin
        y := year - j;
        Str := IntToStr(y)+'년';
        Add(Str);
        Inc(j);
      end;
    finally
      EndUpdate;
    end;
  end;
end;
procedure TdetailUser_Frm.ChildFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action   := caFree;
end;

procedure TdetailUser_Frm.dt_chgdayChange(Sender: TObject);
begin
  dt_chgday.Format := 'yyyy-MM-dd';
end;

procedure TdetailUser_Frm.dt_rundayChange(Sender: TObject);
begin
  dt_runday.Format := 'yyyy-MM-dd';
end;

procedure TdetailUser_Frm.cb_dayDropDown(Sender: TObject);
var
  Day : TDateTime;
  p,
  i, j : Integer;
  str : String;
begin
  with cb_day.Items do
  begin
    BeginUpdate;
    try
      if (cb_year.Text <> '년도') AND (cb_day.Text <> '월') then
      begin
        p := Pos('월',cb_month.Text);
        str := Copy(cb_month.Text,1,p-1);
        Day := StrToDateTime(LeftStr(cb_year.Text,4)+'-'+str+'-01');
        i := 1;
        Day := EndOfTheMonth(Day);
        j := StrToInt(FormatDateTime('DD',Day));
        while i <= j do
        begin
          Add(IntToStr(i)+'일');
          Inc(i);
        end;
      end else
      begin
        Clear;
        Add('일');
      end;
    finally
      EndUpdate;
    end;
  end;
end;

function TdetailUser_Frm.Get_annivesary: String;
var
  p : Integer;
  year,
  month,
  day : String;
  anni : TDateTime;
begin
  if cb_year.ItemIndex <> 0 then
  begin
    p := pos('년',cb_year.Text);
    year := Copy(cb_year.Text,1,p-1);
  end;

  if cb_month.ItemIndex <> 0 then
  begin
    p := pos('월',cb_month.Text);
    month := Copy(cb_month.Text,1,p-1);
  end;

  if cb_day.ItemIndex <> 0 then
  begin
    p := pos('일',cb_day.Text);
    day := Copy(cb_day.Text,1,p-1);
  end;

  if (year <> '') and (month <> '') and (day <> '') then
  begin
    Result := year+'-'+month+'-'+day;
    anni := StrToDateTime(Result);
    Result := FormatDateTime('yyyy-MM-dd',anni);
  end
  else
    Result := '';

end;

function TdetailUser_Frm.Get_DeptName(aDeptCD: String): String;
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
      SQL.Add('SELECT * FROM HITEMS_DEPT ' +
              'WHERE DEPT_CD = :param1 ');
      ParamByName('param1').AsString := aDeptCD;
      Open;

      Result := FieldByName('DEPT_NAME').AsString;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure TdetailUser_Frm.Make_GradeTab(aDept_CD: String);
var
  tabItem : TOfficeTabCollectionItem;
begin
  with tab_Grade.AdvOfficeTabs do
  begin
    BeginUpdate;
    try
      Clear;
      tabItem := add;
      tabItem.Caption := '전체';

      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT A.GRADE, B.DESCR FROM HITEMS_USER A, HITEMS_USER_GRADE B  ' +
                'WHERE A.GRADE = B.GRADE ' +
                'AND A.DEPT_CD LIKE :param1 ' +
                'GROUP BY A.GRADE, DESCR ' +
                'ORDER BY GRADE ');
        ParamByName('param1').AsString := '%'+aDept_CD+'%';
        Open;

        if RecordCount <> 0 then
        begin
          while not eof do
          begin
            tabItem := Add;
            tabItem.Caption := FieldByName('DESCR').AsString;
            Next;
          end;
        end;
      end;
      tab_grade.ActiveTabIndex := 0;
    finally
      EndUpdate;
    end;
  end;
end;


procedure TdetailUser_Frm.N2Click(Sender: TObject);
begin
  ISCreateForm(TGetUser_Frm,'GetUser_Frm','[유저정보]');
end;


function TdetailUser_Frm.Get_UserGrade(aDescr: String): String;
var
  OraQuery : TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.OraSession1;

    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM HITEMS_USER_GRADE ' +
              'WHERE DESCR = :param1 ');
      ParamByName('param1').AsString := aDescr;
      Open;

      Result := FieldByName('GRADE').AsString;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure TdetailUser_Frm.Get_UserInfo(aUserID: String);
var
  strList : TStringList;
  i : integer;
  ms : TMemoryStream;

begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT A.*, B.DESCR FROM HITEMS_USER A, HITEMS_USER_GRADE B ' +
            'WHERE USERID = :param1 ' +
            'AND A.GRADE = B.GRADE ');
    ParamByName('param1').AsString := aUserID;
    Open;

    if RecordCount <> 0 then
    begin
      et_nameK.Text := FieldByName('NAME_KOR').AsString;
      et_nameE.Text := FieldByName('NAME_ENG').AsString;

      cb_grade.Items.Clear;
      cb_grade.Items.Add(FieldByName('DESCR').AsString);
      cb_grade.ItemIndex := 0;
      cb_grade.Hint := FieldByName('GRADE').AsString;

      for i := 0 to cb_position.Items.Count-1 do
      begin
        if FieldByName('POSITION').AsString = cb_position.Items.Strings[i] then
        begin
          cb_position.ItemIndex := i;
          Break;
        end;
      end;

      cb_dept.Items.Clear;
      cb_dept.Hint := LeftStr(FieldByName('DEPT_CD').AsString,3);
      cb_dept.Items.Add(Get_DeptName(cb_dept.Hint));
      cb_dept.ItemIndex := 0;

      cb_team.Items.Clear;
      cb_team.Hint := FieldByName('DEPT_CD').AsString;
      cb_team.Items.Add(Get_DeptName(cb_team.Hint));
      cb_team.ItemIndex := 0;

      if FieldByName('GUNMU').AsString = 'I' then
        cb_Gunmu.ItemIndex := 0
      else
        cb_Gunmu.ItemIndex := 1;


      strList := TStringList.Create;
      try
        with strList do
        begin
          Clear;
          if not FieldByName('TELNO').IsNull then
          begin
            ExtractStrings(['-'],[],PChar(FieldByName('TELNO').AsString),strList);
            tel1.Text := strList.Strings[0];
            tel2.Text := strList.Strings[1];
          end;

          Clear;
          if not FieldByName('HPNO').IsNull then
          begin
            ExtractStrings(['-'],[],PChar(FieldByName('HPNO').AsString),strList);
            cell1.Text := strList.Strings[0];
            cell2.Text := strList.Strings[1];
            cell3.Text := strList.Strings[2];
          end;
        end;
      finally
        FreeAndNil(strList);
      end;

      if not(FieldByName('RUNDAY').IsNull) then
      begin
        dt_runday.Format := 'yyyy-MM-dd';
        dt_runday.Date   := FieldByName('RUNDAY').AsDateTime;
      end else
        dt_runday.Format := ' ';

      if not(FieldByName('CHGDAY').IsNull) then
      begin
        dt_chgday.Format := 'yyyy-MM-dd';
        dt_chgday.Date   := FieldByName('CHGDAY').AsDateTime;
      end else
        dt_chgday.Format := ' ';

      et_email.Text      := FieldByName('EMAIL').AsString;
      et_address.Text    := FieldByName('ADDRESS').AsString;

      if not FieldByName('ID_PHOTO').IsNull then
      begin
        ms := TMemoryStream.Create;//TFileStream.Create('C:\Temp\id_photo.png',fmOpenReadWrite);
        try
          TBlobField(FieldByName('ID_PHOTO')).SaveToStream(ms);
          Get_ImageFromStream(ms, im_person);
        finally
          FreeAndNil(ms);
        end;
      end else
      begin
        im_person.Picture.Graphic := nil;
        im_person.Invalidate;
      end;

      if not FieldByName('ELEC_SIGN').IsNull then
      begin
        ms := TMemoryStream.Create;//TFileStream.Create('C:\Temp\elec_sign.png',fmOpenReadWrite);
        try
          TBlobField(FieldByName('ELEC_SIGN')).SaveToStream(ms);
          Get_ImageFromStream(ms, im_sign);
        finally
          FreeAndNil(ms);
        end;
      end else
      begin
        im_sign.Picture.Graphic := nil;
        im_sign.Invalidate;
      end;

      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM HITEMS_USER_ANNIVERSARY ' +
              'WHERE USERID = :param1 ');
      ParamByName('param1').AsString := et_empno.Text;
      Open;

      with grid_anniversary do
      begin
        BeginUpdate;
        try
          ClearRows;
          while not eof do
          begin
            i := AddRow;
            Cells[1,i] := FieldByName('ANNI_NO').AsString;
            Cells[2,i] := FieldByName('OPEN').AsString;
            Cells[3,i] := FieldByName('ATYPE').AsString;
            Cells[4,i] := FieldByName('CALENDAR').AsString;
            Cells[5,i] := FieldByName('DAY').AsString;
            Cells[6,i] := FieldByName('MESSAGE').AsString;
            Next;
          end;
        finally
          EndUpdate;
        end;
      end;
    end;
  end;
end;

procedure TdetailUser_Frm.Get_Users(aDept_CD, aGrade: String);
var
  lrow : Integer;
begin
  with grid_User do
  begin
    BeginUpdate;
    try
      ClearRows;

      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM HITEMS_USER A, HITEMS_USER_GRADE B, HITEMS_DEPT C ' +
                'WHERE A.GRADE = B.GRADE ' +
                'AND A.GUNMU = ''I'' ' +
                'AND A.DEPT_CD = C.DEPT_CD '+
                'AND A.DEPT_CD LIKE :param1 ' +
                'AND B.DESCR = :param2 ' +
                'ORDER BY PRIV DESC, POSITION, A.DEPT_CD, A.GRADE, USERID ');

        ParamByName('param1').AsString := '%'+aDept_CD+'%';

        if not (aGrade = '전체')  then
          ParamByName('param2').AsString := aGrade
        else
          SQL.Text := ReplaceStr(SQL.Text,'AND B.DESCR = :param2 ', '');

        Open;

        if RecordCount <> 0 then
        begin
          while not eof do
          begin
            lrow := AddRow;
            Cells[1,lrow] := FieldByName('DEPT_NAME').AsString;
            Cells[2,lrow] := FieldByName('USERID').AsString;
            Cells[3,lrow] := FieldByName('NAME_KOR').AsString;
            Cells[4,lrow] := FieldByName('DESCR').AsString;
            Cells[5,lrow] := FieldByName('POSITION').AsString;

            Cells[6,lrow] := FieldByName('TELNO').AsString;
            Cells[7,lrow] := FieldByName('HPNO').AsString;
            Cells[8,lrow] := FieldByName('EMAIL').AsString;
            Cells[9,lrow] := FieldByName('ADDRESS').AsString;

            Next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TdetailUser_Frm.grid_UserCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  et_empno.Text := grid_User.Cells[2,ARow];
  Get_UserInfo(et_empno.Text);

end;

procedure TdetailUser_Frm.HiTEMSUSERPRIV11Click(Sender: TObject);
begin
  Update_HiTEMS_User_Priv('1', '');
end;

procedure TdetailUser_Frm.HiTEMSUSERPRIV21Click(Sender: TObject);
begin
  Update_HiTEMS_User_Priv('2', '직책과장');
end;

procedure TdetailUser_Frm.HiTEMSUSERPRIV22Click(Sender: TObject);
begin
  Update_HiTEMS_User_Priv('3', '부서장');
end;

procedure TdetailUser_Frm.HiTEMSUSERPRIV41Click(Sender: TObject);
begin
  Update_HiTEMS_User_Priv('4', '담당임원');
end;

procedure TdetailUser_Frm.Image1DblClick(Sender: TObject);
var
  LForm : TgetUserInfo_Frm;
begin
  LForm := TgetUserInfo_Frm.Create(nil);
  try
    with LForm do
    begin

      ShowModal;

    end;
  finally
    FreeAndNil(LForm);
  end;
end;

function TdetailUser_Frm.ISCreateForm(aClass: TFormClass; aName,
  aCaption: String): TForm;
var
  aForm : TForm;
  i : Integer;
begin
  aForm := nil;
  try
    LockMDIChild(True);

    if Assigned(GetUser_Frm) then
    begin
      for i:=(GetUser_Frm.MDIChildCount - 1) DownTo 0 Do
      begin
        if SameText(GetUser_Frm.MDIChildren[I].Name,aName) then
        begin
          aForm := GetUser_Frm.MDIChildren[I];
          Break;
        end;
      end;
    end;

    if aForm = nil Then
    begin
      aForm := aClass.Create(Application);
      with aForm do
      begin
        Caption := aCaption;
        OnClose := ChildFormClose;

      end;
      //AdvToolBar1.AddMDIChildMenu(aForm);
//      AdvOfficeMDITabSet1.AddTab(aForm);
    end;

    if aForm.WindowState = wsMinimized then
      aForm.WindowState := wsNormal;

    aForm.Show;
    Result := aForm;
  finally
    LockMDIChild(False);
  end;
end;

function TdetailUser_Frm.Is_Duplicate_TaskNo_TaskTeam(ATaskNo, ATaskTeam: string): Boolean;
var
  OraQuery : TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := Dm1.OraSession1;

    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM TMS_TASK_SHARE ' +
              'WHERE TASK_NO = :TASK_NO AND TASK_TEAM = :TASK_TEAM ');

      ParamByName('TASK_NO').AsString := ATaskNo;
      ParamByName('TASK_TEAM').AsString := ATaskTeam;

      Open;

      Result := RecordCount > 0;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

function TdetailUser_Frm.Is_Duplicate_TMS_PLAN_INCHARGE(APlanNo, APlanEmpNo,
  APlanTeam: string; APlanRole, APlanRevNo: integer): Boolean;
var
  OraQuery : TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := Dm1.OraSession1;

    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM TMS_PLAN_INCHARGE ' +
              'WHERE PLAN_NO = :PLAN_NO AND PLAN_EMPNO = :PLAN_EMPNO AND ' +
              '      PLAN_TEAM = :PLAN_TEAM AND PLAN_ROLE = :PLAN_ROLE AND ' +
              '      PLAN_REV_NO = :PLAN_REV_NO');

      ParamByName('PLAN_NO').AsString := APlanNo;
      ParamByName('PLAN_EMPNO').AsString := APlanEmpNo;
      ParamByName('PLAN_TEAM').AsString := APlanTeam;
      ParamByName('PLAN_ROLE').AsInteger := APlanRole;
      ParamByName('PLAN_REV_NO').AsInteger := APlanRevNo;

      Open;

      Result := RecordCount > 0;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure TdetailUser_Frm.UpdateHiTEMS1Click(Sender: TObject);
begin
  Update_TMS_TASK_SHARE;
end;

procedure TdetailUser_Frm.UpdateTMSPLANINCHARGE1Click(Sender: TObject);
begin
  Update_TMS_PLAN_INCHARGE;
end;

procedure TdetailUser_Frm.Update_TMS_PLAN_INCHARGE;
var
  OraQuery : TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := Dm1.OraSession1;

    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM TMS_PLAN_INCHARGE A, HITEMS_USER B ' +
              'WHERE A.PLAN_EMPNO = B.USERID AND A.PLAN_TEAM <> B.DEPT_CD' );

      Open;

//      Session.StartTransaction;
      try
        while not eof do
        begin
          if not Is_Duplicate_TMS_PLAN_INCHARGE(FieldByName('PLAN_NO').AsString,
                                                FieldByName('PLAN_EMPNO').AsString,
                                                FieldByName('DEPT_CD').AsString,
                                                FieldByName('PLAN_ROLE').AsInteger,
                                                FieldByName('PLAN_REV_NO').AsInteger) then
          begin
//            Update_TMS_PLAN_INCHARGE_SQL(FieldByName('DEPT_CD').AsString, FieldByName('PLAN_EMPNO').AsString);
            Edit;
            FieldByName('PLAN_TEAM').AsString := FieldByName('DEPT_CD').AsString;
            Post;
          end;

          Next;
        end;
      finally
//        Session.Commit;
      end;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure TdetailUser_Frm.Update_TMS_PLAN_INCHARGE_SQL(APlanTeam, APlanEmpNo: string);
var
  OraQuery : TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := Dm1.OraSession1;

    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('UPDATE TMS_PLAN_INCHARGE ' +
              'SET PLAN_TEAM = :PLAN_TEAM ' +
              'WHERE PLAN_EMPNO = :PLAN_EMPNO' );
      ParamByName('PLAN_TEAM').AsString := APlanTeam;
      ParamByName('PLAN_EMPNO').AsString := APlanEmpNo;

      ExecSql;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure TdetailUser_Frm.Update_TMS_TASK_SHARE;
var
  OraQuery : TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := Dm1.OraSession1;

    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM ' +
              '   ( ' +
              '     SELECT TASK_NO, TASK_DRAFTER, DEPT_CD, PRE_DEPT_CD ' +
              '     FROM TMS_TASK, HITEMS_USER ' +
              '     WHERE TASK_DRAFTER = USERID AND PRE_DEPT_CD IS NOT NULL ' +
              '   ) A JOIN TMS_TASK_SHARE B ' +
              '   ON ' +
//              '   (B.TASK_TEAM = SUBSTR(A.PRE_DEPT_CD, 1, 4)) AND ' +
              '   (A.TASK_NO = B.TASK_NO) ');
      Open;

      while not eof do
      begin
        if not Is_Duplicate_TaskNo_TaskTeam(FieldByName('TASK_NO').AsString,FieldByName('DEPT_CD').AsString) then
        begin
          Edit;
          FieldByName('TASK_TEAM').AsString := FieldByName('DEPT_CD').AsString;
          Post;
        end;

        Next;
      end;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

function TdetailUser_Frm.Update_HiTEMS_USER: Boolean;
var
  ms : TMemoryStream;
  OraQuery : TOraQuery;
begin
  Result := False;
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := Dm1.OraSession1;
    OraQuery.Options.TemporaryLobUpdate := True;
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM HITEMS_USER ' +
              'WHERE USERID = :param1 ');
      ParamByName('param1').AsString := et_empno.Text;
      Open;

      Edit;

      if RecordCount <> 0 then
      begin
        FieldByName('NAME_KOR').AsString := et_nameK.Text;
        FieldByName('NAME_ENG').AsString := et_nameE.Text;
        FieldByName('PRE_DEPT_CD').AsString := FieldByName('DEPT_CD').AsString;

        if (cb_dept.Text <> '') and (cb_team.Text <> '') then
          FieldByName('DEPT_CD').AsString := cb_team.Hint
        else if (cb_dept.Text <> '') and (cb_team.Text = '') then
          FieldByName('DEPT_CD').AsString := cb_dept.Hint;

        if (tel1.Text <> '') and (tel2.Text <> '') then
          FieldByName('TELNO').AsString   := tel1.Text+'-'+tel2.Text
        else
          FieldByName('TELNO').Clear;

        if (cell1.Text <> '') and (cell2.Text <> '') and (cell3.Text <> '') then
          FieldByName('HPNO').AsString   := cell1.Text+'-'+cell2.Text+'-'+cell3.Text
        else
          FieldByName('HPNO').Clear;

        if dt_runday.Format <> ' ' then
          FieldByName('RUNDAY').AsDateTime  := dt_runday.Date
        else
          FieldByName('RUNDAY').Clear;


        if dt_chgday.Format <> ' ' then
          FieldByName('CHGDAY').AsDateTime  := dt_chgday.Date
        else
          FieldByName('CHGDAY').Clear;

        FieldByName('GRADE').AsString    := cb_grade.Hint;
        FieldByName('POSITION').AsString := cb_position.Text;
        if cb_position.Text = '' then
          FieldByName('PRIV').AsString   := '1'
        else if cb_position.Text = '직책과장' then
          FieldByName('PRIV').AsString   := '2'
        else if cb_position.Text = '부서장' then
          FieldByName('PRIV').AsString   := '3';

        if cb_Gunmu.ItemIndex = 0 then
          FieldByName('GUNMU').AsString := 'I'
        else
          FieldByName('GUNMU').AsString := 'O';

        FieldByName('EMAIL').AsString    := et_email.Text;
        FieldByName('ADDRESS').AsString  := et_address.Text;

        im_person.Picture.Graphic := nil;
        if im_person.Hint <> '' then
        begin
          ms := TMemoryStream.Create;
          try
            ms.LoadFromFile(im_person.Hint);
            ms.Position := 0;
            FieldByName('ID_PHOTO').Clear;
            TBlobField(FieldByName('ID_PHOTO')).LoadFromStream(ms);
          finally
            FreeAndNil(ms);
          end;
        end;

        im_sign.Picture.Graphic := nil;
        if im_sign.Hint <> '' then
        begin
          ms := TMemoryStream.Create;
          try
            ms.LoadFromFile(im_sign.Hint);
            ms.Position := 0;
            FieldByName('ELEC_SIGN').Clear;
            TBlobField(FieldByName('ELEC_SIGN')).LoadFromStream(ms);
          finally
            FreeAndNil(ms);
          end;
        end;
        Post;
        Result := True;
      end;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure TdetailUser_Frm.Update_HiTEMS_User_Priv(APriv, APosition: string);
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('UPDATE HITEMS_USER SET ' +
            'PRIV = :PRIV ' +
            'WHERE POSITION = :POSITION ');

    if APosition = '' then
      StringReplace(SQL.Text,'WHERE POSITION = :POSITION','WHERE POSITION IS NULL OR POSITION = '' ''',[rfReplaceAll])
    else
      ParamByName('POSITION').AsString := APosition;

    ParamByName('PRIV').AsString  := APriv;

    ExecSQL;
  end;
end;

procedure TdetailUser_Frm.Update_USER_Anniversary;
var
  i : Integer;
  OraQuery : TOraQuery;
begin
  with grid_anniversary do
  begin
    BeginUpdate;
    try
      OraQuery := TOraQuery.Create(nil);
      try
        with OraQuery do
        begin
          Session := DM1.OraSession1;

          for i := 0 to RowCount-1 do
          begin
            if Cell[0,i].TextColor = clRed then
            begin
              Close;
              SQL.Clear;
              SQL.Add('DELETE FROM HITEMS_USER_ANNIVERSARY ' +
                      'WHERE ANNI_NO = :param1 ');
              ParamByName('param1').AsString := Cells[1,i];
              ExecSQL;
            end else
            if Cell[0,i].TextColor = clBlue then
            begin
              Close;
              SQL.Clear;
              SQL.Add('INSERT INTO HITEMS_USER_ANNIVERSARY ' +
                      'VALUES( ' +
                      ':USERID, :ANNI_NO, :OPEN, :ATYPE, :CALENDAR, :DAY, :MESSAGE )');

//              ParamByName('USERID').AsString   := CurrentUserId;
              ParamByName('ANNI_NO').AsString  := Cells[1,i];
              ParamByName('OPEN').AsString     := Cells[2,i];
              ParamByName('ATYPE').AsString    := Cells[3,i];
              ParamByName('CALENDAR').AsString := Cells[4,i];
              ParamByName('DAY').AsDate        := StrToDateTime(Cells[5,i]);
              ParamByName('MESSAGE').AsString  := Cells[6,i];
              ExecSQL;

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

end.
