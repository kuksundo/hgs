unit chooseMSHistory_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxColumnClasses, NxColumns,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.ImgList,
  AdvOfficeTabSet, Vcl.StdCtrls, Vcl.ComCtrls, AdvGroupBox, AdvOfficeButtons,
  AeroButtons, JvExControls, JvLabel, CurvyControls, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Ora, MemDS, OraTransaction, OraSmart, OraCall, DateUtils;

type
  TChooseMSHistoryF = class(TForm)
    Panel8: TPanel;
    Image1: TImage;
    CurvyPanel1: TCurvyPanel;
    JvLabel11: TJvLabel;
    JvLabel2: TJvLabel;
    JvLabel5: TJvLabel;
    JvLabel6: TJvLabel;
    JvLabel3: TJvLabel;
    JvLabel7: TJvLabel;
    JvLabel14: TJvLabel;
    btn_Close: TAeroButton;
    btn_Search: TAeroButton;
    CurvyPanel2: TCurvyPanel;
    Label4: TLabel;
    BasePeriod_RG: TAdvOfficeRadioGroup;
    rg_period: TAdvOfficeRadioGroup;
    dt_begin: TDateTimePicker;
    dt_end: TDateTimePicker;
    cb_engType: TComboBox;
    cb_engProjNo: TComboBox;
    cb_user: TComboBox;
    et_keyWord: TEdit;
    et_msNumber: TEdit;
    Button2: TButton;
    AdvOfficeTabSet1: TAdvOfficeTabSet;
    imagelist24x24: TImageList;
    ImageList32x32: TImageList;
    ImageList16x16: TImageList;
    grid_Req: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    tc_reqNo: TNxTextColumn;
    NxTextColumn6: TNxTextColumn;
    NxTextColumn7: TNxTextColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    NxDateColumn1: TNxDateColumn;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    AeroButton1: TAeroButton;
    JvLabel1: TJvLabel;
    cb_team: TComboBox;
    procedure rg_periodClick(Sender: TObject);
    procedure cb_engTypeDropDown(Sender: TObject);
    procedure cb_engProjNoDropDown(Sender: TObject);
    procedure cb_userDropDown(Sender: TObject);
    procedure btn_SearchClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cb_teamDropDown(Sender: TObject);
    procedure AeroButton1Click(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure BasePeriod_RGClick(Sender: TObject);
    procedure grid_ReqDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Get_Request_List;
  end;

var
  ChooseMSHistoryF: TChooseMSHistoryF;

implementation

uses chooseMS_Unit, DataModule_Unit;

{$R *.dfm}

procedure TChooseMSHistoryF.BasePeriod_RGClick(Sender: TObject);
begin
  if BasePeriod_RG.ItemIndex = 2 then
  begin
    rg_period.Enabled := False;
    dt_begin.Enabled := False;
    dt_end.Enabled := False;
  end
  else
  begin
    rg_period.Enabled := True;
    dt_begin.Enabled := True;
    dt_end.Enabled := True;
  end;
end;

procedure TChooseMSHistoryF.AeroButton1Click(Sender: TObject);
begin
  if grid_Req.SelectedCount > 0 then
  begin
    ModalResult := mrOK;
  end
  else
    ModalResult := mrNone;
end;

procedure TChooseMSHistoryF.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TChooseMSHistoryF.btn_SearchClick(Sender: TObject);
begin
  Get_Request_List;
end;

procedure TChooseMSHistoryF.Button2Click(Sender: TObject);
var
  OraQuery: TOraQuery;
  idx: Integer;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.OraSession1;
    with OraQuery do
    begin
      FetchAll := True;

      idx := Create_chooseMS_Frm(OraQuery);

      if idx > 0 then
      begin
        RecNo := idx;
        et_msNumber.Text := FieldByName('MS_NAME').AsString;
        et_msNumber.Hint := FieldByName('MS_NO').AsString;
//        Get_Part_List(et_msNumber.Hint);
      end
      else
      begin
        et_msNumber.Clear;
        et_msNumber.Hint := '';
      end;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure TChooseMSHistoryF.cb_engProjNoDropDown(Sender: TObject);
begin
  with cb_engProjNo.Items do
  begin
    BeginUpdate;
    try
      Clear;

      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT  ' +
                ' TEST_ENGINE, ' +
                ' ENGTYPE, ' +
                ' TO_NUMBER(SUBSTR(ENGTYPE, 1, INSTR(ENGTYPE, ''H'') - 1)) CYLNUM ' +
                'FROM ' +
                '( ' +
                '   SELECT ' +
                '     TEST_ENGINE, ' +
                '     (SELECT ENGTYPE FROM HIMSEN_INFO WHERE PROJNO LIKE TEST_ENGINE) ENGTYPE ' +
                '   FROM TMS_TEST_REQUEST A ' +
                '   GROUP BY TEST_ENGINE ' +
                ')WHERE ENGTYPE LIKE :ENGTYPE ' +
                'ORDER BY CYLNUM, ENGTYPE, TEST_ENGINE ');

        if cb_engType.Text <> '' then
          ParamByName('ENGTYPE').AsString := cb_engType.Text
        else
          SQL.Text := StringReplace(SQL.Text, 'WHERE ENGTYPE LIKE :ENGTYPE ', '', [rfReplaceAll, rfIgnoreCase]);

        Open;

        Add('');
        while not eof do
        begin
          Add(FieldByName('TEST_ENGINE').AsString);
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TChooseMSHistoryF.cb_engTypeDropDown(Sender: TObject);
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
        SQL.Add('SELECT  ' +
                ' TEST_ENGINE, ' +
                ' ENGTYPE, ' +
                ' TO_NUMBER(SUBSTR(ENGTYPE, 1, INSTR(ENGTYPE, ''H'') - 1)) CYLNUM ' +
                'FROM ' +
                '( ' +
                '   SELECT ' +
                '     TEST_ENGINE, ' +
                '     (SELECT ENGTYPE FROM HIMSEN_INFO WHERE PROJNO LIKE TEST_ENGINE) ENGTYPE ' +
                '   FROM TMS_TEST_REQUEST A ' +
                '   GROUP BY TEST_ENGINE ' +
                ')WHERE TEST_ENGINE LIKE :TEST_ENGINE ' +
                'ORDER BY CYLNUM, ENGTYPE, TEST_ENGINE ');

        if cb_engProjNo.Text <> '' then
          ParamByName('TEST_ENGINE').AsString := cb_engProjNo.Text
        else
          SQL.Text := StringReplace(SQL.Text, 'WHERE TEST_ENGINE LIKE :TEST_ENGINE ', '', [rfReplaceAll, rfIgnoreCase]);

        Open;

        Add('');
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

procedure TChooseMSHistoryF.cb_teamDropDown(Sender: TObject);
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
        SQL.Add('SELECT ' +
                '   REQ_DEPT, ' +
                '   (SELECT DEPT_NAME FROM HITEMS_DEPT WHERE DEPT_CD LIKE REQ_DEPT) DEPT_NAME ' +
                'FROM TMS_TEST_REQUEST A ' +
                'GROUP BY REQ_DEPT ' +
                'ORDER BY REQ_DEPT ');
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

procedure TChooseMSHistoryF.cb_userDropDown(Sender: TObject);
begin
  with cb_user.Items do
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
                '   SELECT ' +
                '     REQ_DEPT, ' +
                '     REQ_ID, ' +
                '     (SELECT DEPT_NAME FROM HITEMS_DEPT WHERE DEPT_CD = REQ_DEPT) DEPT_NAME, ' +
                '     (SELECT NAME_KOR FROM HITEMS_USER WHERE USERID = REQ_ID) REQ_ID_NAME ' +
                '   FROM TMS_TEST_REQUEST ' +
                '   GROUP BY REQ_DEPT, REQ_ID ' +
                ') ' +
                'ORDER BY REQ_DEPT, REQ_ID_NAME ');

        Open;

        Add('');
        while not eof do
        begin
          Add(FieldByName('REQ_ID_NAME').AsString);
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TChooseMSHistoryF.FormCreate(Sender: TObject);
begin
  dt_begin.Date := StartOfTheWeek(today);
  dt_end.Date   := EndOfTheWeek(today);
end;

procedure TChooseMSHistoryF.Get_Request_List;
var
  TabCaption: String;
begin
  with grid_Req do
  begin
    BeginUpdate;
    try
      ClearRows;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT DISTINCT REQ_NO,TEST_NAME,ENG_TYPE,USER_NAME,DEPT_NAME,TEST_BEGIN,INDATE FROM   ' +
                '(   ' +
                '   SELECT A.*, ' +
                '         (SELECT ENGTYPE FROM HIMSEN_INFO WHERE PROJNO = TEST_ENGINE) ENG_TYPE, ' +
                '         (SELECT NAME_KOR FROM HITEMS_USER WHERE USERID = REQ_ID) USER_NAME,   ' +
                '         (SELECT DEPT_NAME FROM HITEMS_DEPT WHERE REQ_DEPT = DEPT_CD) DEPT_NAME  ' +
                '   FROM ' +
                '   ( ' +
                '     SELECT D.* ' +
                '     FROM ( ' +
                '           SELECT B.req_no FROM himsen_ms_part A,TMS_TEST_REQUEST_part B ' +
                '           WHERE ms_no = :MS_NO AND A.PART_NO = B.PART_NO ' +
                '           ) C, TMS_TEST_REQUEST D ' +
                '     WHERE C.req_no = D.req_no ' +
                '   ) A ' +
                ')  ' +
                'WHERE INDATE BETWEEN :beginDate AND :endDate ' +
                'AND TEST_ENGINE = :PROJNO ' +
                'AND ENG_TYPE = :ENG_TYPE ' +
                'AND UPPER(TEST_NAME) = :TEST_NAME ' +
                'AND DEPT_NAME LIKE :DEPT_NAME ' +
                'AND USER_NAME = :USER_NAME ' +
                'ORDER BY TEST_BEGIN ');

        ParamByName('MS_NO').AsString := et_msNumber.Hint;

        if cb_engProjNo.Text <> '' then
          ParamByName('PROJNO').AsString := cb_engProjNo.Text
        else
          SQL.Text := StringReplace(SQL.Text, 'AND TEST_ENGINE = :PROJNO ', '', [rfReplaceAll, rfIgnoreCase]);

        if cb_engType.Text <> '' then
          ParamByName('ENG_TYPE').AsString := cb_engType.Text
        else
          SQL.Text := StringReplace(SQL.Text, 'AND ENG_TYPE = :ENG_TYPE ', '', [rfReplaceAll, rfIgnoreCase]);

        if et_keyWord.Text <> '' then
          ParamByName('TEST_NAME').AsString := '%' + et_keyWord.Text + '%'
        else
          SQL.Text := StringReplace(SQL.Text, 'AND UPPER(TEST_NAME) = :TEST_NAME ', '', [rfReplaceAll, rfIgnoreCase]);

        if cb_team.Text <> '' then
          ParamByName('DEPT_NAME').AsString := cb_team.Text
        else
          SQL.Text := StringReplace(SQL.Text, 'AND DEPT_NAME LIKE :DEPT_NAME ', '', [rfReplaceAll, rfIgnoreCase]);

        if cb_user.Text <> '' then
          ParamByName('USER_NAME').AsString := '%' + cb_user.Text + '%'
        else
          SQL.Text := StringReplace(SQL.Text, 'AND USER_NAME = :USER_NAME ', '', [rfReplaceAll, rfIgnoreCase]);

        if BasePeriod_RG.ItemIndex = 2 then
        begin
          SQL.Text := StringReplace(SQL.Text, 'INDATE BETWEEN :beginDate AND :endDate AND', '', [rfReplaceAll, rfIgnoreCase]);
          SQL.Text := StringReplace(SQL.Text, 'INDATE BETWEEN :beginDate AND :endDate', '', [rfReplaceAll, rfIgnoreCase]);
          SQL.Text := StringReplace(SQL.Text, 'ORDER BY TEST_BEGIN', 'ORDER BY INDATE DESC ', [rfReplaceAll, rfIgnoreCase]);
        end
        else
        begin
          ParamByName('beginDate').AsDate := dt_begin.Date;
          ParamByName('endDate').AsDate   := dt_end.Date;
        end;

        Open;

        TabCaption := AdvOfficeTabSet1.AdvOfficeTabs [AdvOfficeTabSet1.ActiveTabIndex].Caption;

        while not eof do
        begin
          AddRow;
          //if FieldByName('REQ_NO').AsString = 'QE3201402011' then
          //  Cells[1, LastAddedRow] := FieldByName('REQ_NO').AsString;

          Cells[1, LastAddedRow] := FieldByName('REQ_NO').AsString;
          Cells[2, LastAddedRow] := FieldByName('DEPT_NAME').AsString;
          Cells[3, LastAddedRow] := FieldByName('USER_NAME').AsString;
          Cells[4, LastAddedRow] := FieldByName('TEST_NAME').AsString;
          Cells[5, LastAddedRow] := FieldByName('ENG_TYPE').AsString;

          Cells[6, LastAddedRow] := FormatdateTime('yyyy-MM-dd HH:mm',
            FieldByName('INDATE').AsDateTime);
//          Cells[7, LastAddedRow] := FieldByName('STATUS').AsString;


          if TabCaption <> 'ÀüÃ¼' then
          begin
            if SameText(Cells[7,LastAddedRow], TabCaption) then
              RowVisible[LastAddedRow] := True
            else
              RowVisible[LastAddedRow] := False;
          end else
            RowVisible[LastAddedRow] := True;

//          Cells[8, LastAddedRow] := FieldByName('RECEIVE_ID').AsString;
          if BasePeriod_RG.ItemIndex = 2 then
            break
          else
            Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TChooseMSHistoryF.grid_ReqDblClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TChooseMSHistoryF.rg_periodClick(Sender: TObject);
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

end.
