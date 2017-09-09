unit searchHistory_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.CheckLst, NxEdit, Vcl.ComCtrls, AdvDateTimePicker, NxCollection,
  Vcl.ImgList;

type
  TsearchHistory_Frm = class(TForm)
    NxHeaderPanel2: TNxHeaderPanel;
    Label5: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label22: TLabel;
    s_st_time: TAdvDateTimePicker;
    s_end_time: TAdvDateTimePicker;
    CheckBox1: TNxCheckBox;
    CheckBox2: TNxCheckBox;
    engList: TCheckListBox;
    Panel6: TPanel;
    s_search_btn: TButton;
    testList: TCheckListBox;
    siteList: TCheckListBox;
    typeList: TCheckListBox;
    ImageList1: TImageList;
    procedure s_search_btnClick(Sender: TObject);
  private
    { Private declarations }
    fsql : String;
  public
    { Public declarations }
    procedure Set_Check_List_Items;
  end;

var
  searchHistory_Frm: TsearchHistory_Frm;

  function Create_searchHistory : String;

implementation
uses
  HiTEMS_ETH_CONST,
  DataModule_Unit;

{$R *.dfm}

{ TsearchHistory_Frm }
function Create_searchHistory : String;
begin
  searchHistory_Frm := TsearchHistory_Frm.Create(nil);
  try
    with searchHistory_Frm do
    begin
      Set_Check_List_Items;
      ShowModal;

      if ModalResult = mrOk then
      begin
        Result := fsql;
      end;
    end;
  finally
    FreeAndNil(searchHistory_Frm);
  end;
end;

procedure TsearchHistory_Frm.Set_Check_List_Items;
begin
  with DM1.OraQuery1 do
  begin
    with engList.Items do
    begin
      BeginUpdate;
      Clear;
      try
        Close;
        SQL.Clear;
        SQL.Add('select distinct(A.ProjNo), B.ENGTYPE from HIMSEN_TEST_HISTORY A, HIMSENINFO B ' +
                'where A.ProjNo = B.ProjNo ');
        Open;

        First;
        while not eof do
        begin
          Add(FieldByName('PROJNO').AsString+'-'+FieldByName('ENGTYPE').AsString);
          Next;
        end;
      finally
        EndUpdate
      end;
    end;

    with testList.Items do
    begin
      BeginUpdate;
      Clear;
      try
        Close;
        SQL.Clear;
        SQL.Add('select distinct(T_TITLE) from HIMSEN_TEST_HISTORY '+
                'order by T_TITLE');
        Open;

        First;
        while not eof do
        begin
          Add(FieldByName('T_TITLE').AsString);
          Next;
        end;
      finally
        EndUpdate
      end;
    end;

    with siteList.Items do
    begin
      BeginUpdate;
      Clear;
      try
        Close;
        SQL.Clear;
        SQL.Add('select distinct(T_SITE) from HIMSEN_TEST_HISTORY '+
                'order by T_SITE');
        Open;

        First;
        while not eof do
        begin
//          Add(Return_Code_Name(FieldByName('T_SITE').AsString));
          Next;
        end;
      finally
        EndUpdate
      end;
    end;

    with typeList.Items do
    begin
      BeginUpdate;
      Clear;
      try
        Close;
        SQL.Clear;
        SQL.Add('select distinct(T_TYPE) from HIMSEN_TEST_HISTORY '+
                'order by T_TYPE');
        Open;

        First;
        while not eof do
        begin
//          Add(Return_Code_Name(FieldByName('T_TYPE').AsString));
          Next;
        end;
      finally
        EndUpdate
      end;
    end;

    s_st_time.DateTime := Now;
    s_end_time.DateTime := Now;
  end;
end;

procedure TsearchHistory_Frm.s_search_btnClick(Sender: TObject);
var
  li : integer;
  litem : TStringList;
  lsql : String;
  sTime,eTime : String;
begin
  fsql := 'select * from HIMSEN_TEST_HISTORY where TEST_NO != 0 ';

  litem := TStringList.Create;
  try
    // 엔진타입
    lsql := '';
    for li := 0 to engList.Count-1 do
    begin
      if engList.Checked[li] then
      begin
        litem.Clear;
        ExtractStrings(['-'],[],PChar(engList.Items.Strings[li]),litem);
        lsql := lsql+litem.Strings[0]+''',''';
      end;
    end;
    if not(lsql = '') then
    begin
      fsql := fsql + 'and PROJNO In ('''+lsql;
      fsql := Copy(fsql,0,LastDelimiter(',',fsql)-1);
      fsql := fsql+') ';
    end;

    // 시험명
    lsql := '';
    for li := 0 to testList.Count-1 do
    begin
      if testList.Checked[li] then
      begin
        litem.Clear;
        ExtractStrings(['-'],[],PChar(testList.Items.Strings[li]),litem);
        lsql := lsql+litem.Strings[0]+''',''';
      end;
    end;
    if not(lsql = '') then
    begin
      fsql := fsql + 'and T_TITLE In ('''+lsql;
      fsql := Copy(fsql,0,LastDelimiter(',',fsql)-1);
      fsql := fsql+') ';
    end;

    // 시험장소
    lsql := '';
    for li := 0 to siteList.Count-1 do
    begin
      if siteList.Checked[li] then
      begin
//        lsql := lsql+Return_Code_(siteList.Items.Strings[li])+''',''';
      end;
    end;
    if not(lsql = '') then
    begin
      fsql := fsql + 'and T_SITE In ('''+lsql;
      fsql := Copy(fsql,0,LastDelimiter(',',fsql)-1);
      fsql := fsql+') ';
    end;

    // 시험구분
    lsql := '';
    for li := 0 to typeList.Count-1 do
    begin
      if typeList.Checked[li] then
      begin
//        lsql := lsql+Return_Code_(typeList.Items.Strings[li])+''',''';
      end;
    end;
    if not(lsql = '') then
    begin
      fsql := fsql + 'and T_TYPE In ('''+lsql;
      fsql := Copy(fsql,0,LastDelimiter(',',fsql)-1);
      fsql := fsql+') ';
    end;

    lsql := '';
    sTime := FormatDateTime('YYYY-MM-DD HH:mm:ss',s_st_time.DateTime);
    eTime := FormatDateTime('YYYY-MM-DD HH:mm:ss',s_end_time.DateTime);
    if (CheckBox1.Checked = True) and (checkBox2.Checked = False) then
      lsql := 'and T_ST_TIME > to_Date('''+sTime+''','''+'YYYY-MM-DD HH24:MI:SS'') '
    else
    if (CheckBox1.Checked = False) and (checkBox2.Checked = True) then
      lsql := 'and T_END_TIME < to_Date('''+eTime+''','''+'YYYY-MM-DD HH24:MI:SS'') '
    else
    if (CheckBox1.Checked = True) and (checkBox2.Checked = True) then
      lsql := 'and T_ST_TIME > to_Date('''+sTime+''','''+'YYYY-MM-DD HH24:MI:SS'') ' +
              'and T_END_TIME < to_Date('''+eTime+''','''+'YYYY-MM-DD HH24:MI:SS'') ';


    if not(lsql = '') then
      fsql := fsql+lsql;

    fsql := fsql+' order by T_ST_TIME';
  finally
    FreeAndNil(litem);
  end;
end;

end.
