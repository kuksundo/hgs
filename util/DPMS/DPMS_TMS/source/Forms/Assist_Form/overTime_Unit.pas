unit overTime_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ImgList, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Vcl.StdCtrls, AeroButtons, CurvyControls, NxColumnClasses,
  NxColumns, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid,
  Vcl.ComCtrls, JvExControls, JvLabel, ComObj, OleCtrls, DateUtils, Vcl.Grids,
  AdvObj, BaseGrid, AdvGrid, AdvGroupBox, AdvOfficeButtons, StrUtils;

type
  ToverTime_Frm = class(TForm)
    Panel8: TPanel;
    Image1: TImage;
    ImageList32x32: TImageList;
    CurvyPanel1: TCurvyPanel;
    btn_Close: TAeroButton;
    AeroButton3: TAeroButton;
    grid_over: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn4: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    NxNumberColumn1: TNxNumberColumn;
    btn_Excel: TAeroButton;
    NxTextColumn6: TNxTextColumn;
    SaveDialog1: TSaveDialog;
    cb_team: TComboBox;
    JvLabel2: TJvLabel;
    CurvyPanel2: TCurvyPanel;
    Label4: TLabel;
    rg_period: TAdvOfficeRadioGroup;
    dt_begin: TDateTimePicker;
    dt_end: TDateTimePicker;
    cb_engType: TComboBox;
    JvLabel5: TJvLabel;
    JvLabel7: TJvLabel;
    JvLabel1: TJvLabel;
    cb_Users: TComboBox;
    NxDateColumn1: TNxDateColumn;
    Label1: TLabel;
    procedure AeroButton3Click(Sender: TObject);
    procedure cb_teamDropDown(Sender: TObject);
    procedure cb_teamSelect(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_ExcelClick(Sender: TObject);
    procedure rg_periodClick(Sender: TObject);
    procedure cb_UsersDropDown(Sender: TObject);
    procedure cb_UsersSelect(Sender: TObject);
    procedure cb_engTypeDropDown(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  overTime_Frm: ToverTime_Frm;
  procedure Create_overTime_Frm;

implementation
uses
  HiTEMS_TMS_CONST,
  DataModule_Unit;

{$R *.dfm}
procedure Create_overTime_Frm;
begin
  overTime_Frm := ToverTime_Frm.Create(nil);
  try
    with overTime_Frm do
    begin
      ShowModal;
    end;
  finally
    FreeAndNil(overTime_Frm);
  end;
end;


procedure ToverTime_Frm.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure ToverTime_Frm.btn_ExcelClick(Sender: TObject);
const
  ldec = 65;//Ascii Code Dec = A
var
  MyResourceStream: TResourceStream;
  XL, oWB, oSheet, oRng : variant;
  xlRowCount, xlColCount,
  i,li,j,s : Integer;
  lColumn, range : string;

  STime,
  LTime : TTime;
  LendTime : String;
  LEot : String;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT  ' +
            ' AB.*, ' +
            ' (SELECT SUM(RST_MH) FROM DPMS_TMS_RESULT A, DPMS_TMS_RESULT_MH B ' +
            '  WHERE A.RST_NO = B.RST_NO AND A.RST_PERFORM = AB.RST_PERFORM ' +
            '  AND B.RST_BY LIKE AB.RST_BY ' +
            '  AND RST_TIME_TYPE = AB.RST_TIME_TYPE) MH ' +
            'FROM ' +
            '( ' +
            '   SELECT  ' +
            '     RST_TIME_TYPE, A.RST_PERFORM, A.RST_NO, PRIV, POSITION, GRADE, DEPT_CD TEAM, A.RST_BY, ' +
            '     NAME_KOR, DESCR, EOT, RST_TITLE, RST_CODE, RST_CODE_NAME,' +
            '     PLAN_NO, PLAN_REV_NO, ' +
            '     ( ' +
            '       SELECT ENG_PROJNO FROM DPMS_TMS_PLAN ' +
            '       WHERE PLAN_NO LIKE A.PLAN_NO ' +
            '       AND PLAN_REV_NO = A.PLAN_REV_NO ' +
            '     ) PROJNO, ' +
            '     ( SELECT ENG_TYPE FROM DPMS_TMS_PLAN ' +
            '       WHERE PLAN_NO LIKE A.PLAN_NO ' +
            '       AND PLAN_REV_NO = A.PLAN_REV_NO ' +
            '     ) ENG_TYPE ' +
            '   FROM ' +
            '   ( ' +
            '       SELECT ' +
            '         RST_TIME_TYPE, A.RST_PERFORM,  A.RST_NO, A.RST_BY, ' +
            '         RST_TITLE, RST_CODE, RST_CODE_NAME, PLAN_NO, PLAN_REV_NO ' +
            '       FROM ' +
            '       ( ' +
            '           SELECT RST_PERFORM, MAX(RST_NO) RST_NO, RST_BY, RST_TIME_TYPE ' +
            '           FROM ' +
            '           ( ' +
            '               SELECT A.*, B.RST_BY, B.RST_TIME_TYPE ' +
            '               FROM DPMS_TMS_RESULT A, DPMS_TMS_RESULT_MH B ' +
            '               WHERE A.RST_NO = B.RST_NO ' +
            '               AND RST_TIME_TYPE = 1 ' +
            '           )   ' +
            '           GROUP BY RST_PERFORM, RST_BY, RST_TIME_TYPE ' +
            '       ) A JOIN  ' +
            '       ( ' +
            '           SELECT A.*, B.CODE_NAME RST_CODE_NAME ' +
            '           FROM DPMS_TMS_RESULT A, DPMS_CODE_GROUP B ' +
            '           WHERE A.RST_CODE = B.GRP_NO ' +
            '       )  ' +
            '       B ON A.RST_NO = B.RST_NO ' +
            '   ) A JOIN ' +
            '   ( ' +
            '       SELECT A.USERID, PRIV, POSITION, A.GRADE, DEPT_CD, NAME_KOR, B.DESCR, EOT ' +
            '       FROM DPMS_USER A, DPMS_USER_GRADE B ' +
            '       WHERE A.GRADE = B.GRADE ' +
            '   ) B ' +
            '   ON A.RST_BY = B.USERID ' +
            ') AB  ' +
            'WHERE RST_PERFORM = :BEGIN ' +
//            'WHERE RST_PERFORM BETWEEN :BEGIN AND :END ' +
            'AND RST_BY = :RST_BY ' +
            'AND TEAM LIKE :TEAM ' +
            'AND ENG_TYPE LIKE :ENG_TYPE ' +
            'ORDER BY RST_PERFORM, PRIV DESC, POSITION, GRADE, RST_BY ');

    ParamByName('BEGIN').AsDate := dt_begin.Date;
//    ParamByName('END').AsDate   := dt_end.Date;

    if cb_Users.Hint <> '' then
      ParamByName('RST_BY').AsString  := cb_Users.Hint
    else
      SQL.Text := ReplaceStr(SQL.Text, 'AND RST_BY = :RST_BY ', '' );

    if cb_team.Hint <> '' then
      ParamByName('TEAM').AsString  := cb_team.Hint
    else
      ParamByName('TEAM').AsString  := '%'+DM1.FUserInfo.CurrentUsersDept+'%';

    if cb_engType.Text <> '' then
      ParamByName('ENG_TYPE').AsString  := cb_engType.Text
    else
      SQL.Text := ReplaceStr(SQL.Text, 'AND ENG_TYPE LIKE :ENG_TYPE ', '' );

    Open;

    if RecordCount <> 0 then
    begin
      SaveDialog1.FileName := FormatDateTime('YYMMDD',dt_begin.Date)+'_연장특근신청서.xls';
      if SaveDialog1.Execute then
      begin
        MyResourceStream := TResourceStream.Create(hInstance, 'Resource_1', RT_RCDATA);
        try
          MyResourceStream.SaveToFile(SaveDialog1.FileName);

        //   참조항목
        //    XL.workbooks.Add('C:\test.xls');    //특정 이름의 화일 열기
        //    XL.workbooks.Open('C:\'+sFileName); //특정 이름의 화일 열기
        //    XL.ActiveWorkbook.saveas('C:\123.xls'); //활성화된 엑셀 다른 이름으로 저장
        //    XL.ActiveCell.FormulaR1C1 := '=3*3';    //값입력
        //    XL.ActiveCell.Font.Bold := True      //글자 환경 변경
        //    XL.ActiveCell.CurrentRegion.Select;   //활성화 된 셀의 영역을 선택
        //    XL.selection.style:='Currency';       //선택영역 통화 형태로

          XL := CreateOleObject('Excel.Application');
          XL.DisplayAlerts := False;
          XL.visible := False;
          try
            oWB := XL.WorkBooks.Add(SaveDialog1.FileName);
            oSheet := oWB.ActiveSheet;

            try
              range := 'A5';
              XL.Range[range].Select;
              XL.ActiveCell.FormulaR1C1 := '【엔진기계개발시험부】       ' +
                                            FormatDateTime('yyyy 년   mm 월   dd 일',dt_begin.Date) +
                                            '   ('+fDayofWeek[DayOfWeek(dt_begin.Date)]+')';


              s := -1;
              for i := 0 to RecordCount-1 do
              begin
                li := DayOfTheWeek(FieldByName('RST_PERFORM').AsDateTime);
                if li > 5 then
                begin
                  STime := StrToDateTime('08:00');

                  if FieldByName('MH').AsInteger > 4 then
                    LTime := IncHour(STime,FieldByName('MH').AsInteger+1)
                  else
                    LTime := IncHour(STime,FieldByName('MH').AsInteger);

                  LendTime := FormatDateTime('HH:mm', LTime);

                end else
                begin
                  STime := FieldByName('EOT').AsDateTime;
                  LTime := IncHour(STime,FieldByName('MH').AsInteger);
                  LendTime := FormatDateTime('HH:mm', LTime);
                end;

                range := 'A'+IntToStr(9+i);
                XL.Range[range].Select;
                XL.ActiveCell.FormulaR1C1 := IntToStr(i+1);

                range := 'B'+IntToStr(9+i);
                XL.Range[range].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DESCR').AsString;

                range := 'C'+IntToStr(9+i);
                XL.Range[range].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('RST_BY').AsString;

                range := 'D'+IntToStr(9+i);
                XL.Range[range].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('NAME_KOR').AsString;

                range := 'E'+IntToStr(9+i);
                XL.Range[range].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('PROJNO').AsString;

                range := 'F'+IntToStr(9+i);
                XL.Range[range].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('RST_TITLE').AsString;

                range := 'G'+IntToStr(9+i);
                XL.Range[range].Select;
                XL.ActiveCell.FormulaR1C1 := FormatDateTime('HH:mm',STime)+'~'+LendTime;

                range := 'J'+IntToStr(9+i);
                XL.Range[range].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('MH').AsString;

                range := 'L'+IntToStr(9+i);
                XL.Range[range].Select;
                XL.ActiveCell.FormulaR1C1 := FormatDateTime('HH:mm',STime)+'~'+LendTime;

                range := 'P'+IntToStr(9+i);
                XL.Range[range].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('MH').AsString;

                Next;
              end;
            finally
              XL.Visible := True;
            end;
          except
            MessageDlg('Excel이 설치되어 있지 않습니다.'+#13+
              '이 기능을 이용하시려면 반드시 MS오피스 엑셀이 설치되어 있어야 합니다.- ' ,
              MtWarning, [mbok], 0);
            XL.quit;
            XL := Unassigned;
          end;
        finally
          FreeAndNil(MyResourceStream);
        end;
      end;
    end else
    begin
      ShowMessage(FormatDateTime('yyyy-MM-dd 일자로 검색된 자료가 없습니다.', dt_begin.Date));
    end;
  end;
end;

procedure ToverTime_Frm.AeroButton3Click(Sender: TObject);
begin
  with grid_over do
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
                '   SELECT ' +
                '     USERID, DESCR, NAME_KOR, DEPT_CD, GRADE, PRIV, POSITION, EOT,' +
                '     RST_PERFORM, RST_TITLE, RST_MH, A.PLAN_NO, ENG_PROJNO, ' +
                '     ENG_TYPE, ENG_MODEL ' +
                '   FROM ' +
                '   ( ' +
                '       SELECT * FROM ' +
                '       ( ' +
                '           SELECT ' +
                '             USERID, DESCR, NAME_KOR, DEPT_CD, D.GRADE, PRIV, ' +
                '             POSITION, EOT, RST_PERFORM, RST_TITLE, RST_MH, ' +
                '             PLAN_NO ' +
                '           FROM ' +
                '             DPMS_TMS_RESULT A, ' +
                '             DPMS_TMS_RESULT_MH B, ' +
                '             DPMS_USER C, ' +
                '             DPMS_USER_GRADE D ' +
                '           WHERE A.RST_NO = B.RST_NO ' +
//                '           AND B.RST_TIME_TYPE IN (1, 2) ' +
                '           AND B.RST_TIME_TYPE > 0 ' +
                '           AND RST_BY = C.USERID ' +
                '           AND C.GRADE = D.GRADE ' +
                '       ) ' +
                '   ) A LEFT OUTER JOIN ' +
                '   ( ' +
                '       SELECT A.PLAN_NO, ENG_PROJNO, ENG_TYPE, ENG_MODEL FROM ' +
                '       ( ' +
                '           SELECT PLAN_NO, MAX(PLAN_REV_NO) PN FROM DPMS_TMS_PLAN ' +
                '           GROUP BY PLAN_NO ' +
                '       ) A LEFT OUTER JOIN DPMS_TMS_PLAN B ' +
                '       ON A.PLAN_NO = B.PLAN_NO ' +
                '       AND A.PN = B.PLAN_REV_NO ' +
                '   ) B ' +
                '   ON A.PLAN_NO = B.PLAN_NO ' +
                ') ' +
                'WHERE RST_PERFORM BETWEEN :BEGIN AND :END ' +
                'AND USERID = :USERID ' +
                'AND DEPT_CD LIKE :TEAM ' +
                'AND ENG_TYPE LIKE :ENGTYPE ' +
                'ORDER BY RST_PERFORM, PRIV DESC, POSITION, GRADE, USERID ');

        ParamByName('BEGIN').AsDate := dt_begin.Date;
        ParamByName('END').AsDate   := dt_end.Date;
        if cb_Users.Hint <> '' then
          ParamByName('USERID').AsString  := cb_Users.Hint
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND USERID = :USERID ', '' );

        if cb_team.Hint <> '' then
          ParamByName('TEAM').AsString  := cb_team.Hint
        else
          ParamByName('TEAM').AsString  := '%'+DM1.FUserInfo.CurrentUsersDept+'%';

        if cb_engType.Text <> '' then
          ParamByName('ENGTYPE').AsString  := cb_engType.Text
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND ENG_TYPE LIKE :ENGTYPE ', '' );

        Open;

        if RecordCount <> 0 then
        begin
          while not eof do
          begin
            if not(FieldByName('RST_PERFORM').IsNull) then
            begin
              AddRow;
              Cell[1,LastAddedRow].AsDateTime := FieldByName('RST_PERFORM').AsDateTime;
              Cells[2,LastAddedRow] := FieldByName('DESCR').AsString;
              Cells[3,LastAddedRow] := FieldByName('USERID').AsString;
              Cells[4,LastAddedRow] := FieldByName('NAME_KOR').AsString;
              Cells[5,LastAddedRow] := FieldByName('ENG_PROJNO').AsString;
              Cells[6,LastAddedRow] := FieldByName('RST_TITLE').AsString;
              Cell[7,LastAddedRow].AsFloat := FieldByName('RST_MH').AsFloat;
              Cells[8,LastAddedRow] := FieldByName('EOT').AsString;
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

procedure ToverTime_Frm.cb_engTypeDropDown(Sender: TObject);
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
        SQL.Add('SELECT ENG_TYPE FROM ' +
                '( ' +
                '   SELECT ' +
                '     RST_BY, DESCR, NAME_KOR, DEPT_CD, GRADE, PRIV, POSITION, EOT,' +
                '     RST_PERFORM, RST_TITLE, RST_MH, A.PLAN_NO, ENG_PROJNO, ' +
                '     ENG_TYPE, ENG_MODEL ' +
                '   FROM ' +
                '   ( ' +
                '       SELECT * FROM ' +
                '       ( ' +
                '           SELECT ' +
                '             RST_BY, DESCR, NAME_KOR, DEPT_CD, D.GRADE, PRIV, ' +
                '             POSITION, EOT, RST_PERFORM, RST_TITLE, RST_MH, ' +
                '             PLAN_NO ' +
                '           FROM ' +
                '             DPMS_TMS_RESULT A, ' +
                '             DPMS_TMS_RESULT_MH B, ' +
                '             DPMS_USER C, ' +
                '             DPMS_USER_GRADE D ' +
                '           WHERE A.RST_NO = B.RST_NO ' +
                '           AND B.RST_TIME_TYPE = 1 ' +
                '           AND RST_BY = C.USERID ' +
                '           AND C.GRADE = D.GRADE ' +
                '       ) ' +
                '   ) A LEFT OUTER JOIN ' +
                '   ( ' +
                '       SELECT A.PLAN_NO, ENG_PROJNO, ENG_TYPE, ENG_MODEL FROM ' +
                '       ( ' +
                '           SELECT PLAN_NO, MAX(PLAN_REV_NO) PN FROM DPMS_TMS_PLAN ' +
                '           GROUP BY PLAN_NO ' +
                '       ) A LEFT OUTER JOIN DPMS_TMS_PLAN B ' +
                '       ON A.PLAN_NO = B.PLAN_NO ' +
                '       AND A.PN = B.PLAN_REV_NO ' +
                '   ) B ' +
                '   ON A.PLAN_NO = B.PLAN_NO ' +
                ') ' +
                'GROUP BY ENG_TYPE ' +
                'ORDER BY ENG_TYPE DESC ');

        Open;

        if RecordCount <> 0 then
        begin
          while not eof do
          begin
            Add(FieldByName('ENG_TYPE').AsString);
            Next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure ToverTime_Frm.cb_teamDropDown(Sender: TObject);
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

        ParamByName('param1').AsString := DM1.FUserInfo.CurrentUsersDept+'%';
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

procedure ToverTime_Frm.cb_teamSelect(Sender: TObject);
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
  end else
  begin
    cb_team.Clear;
    cb_team.Items.Clear;
    cb_team.Hint := '';
  end;
end;



procedure ToverTime_Frm.cb_UsersDropDown(Sender: TObject);
var
  i : Integer;
  team : String;
begin
  with cb_users.Items do
  begin
    BeginUpdate;
    try
      Clear;
      Add('');

      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM DPMS_USER ' +
                'WHERE GUNMU = :param1 ' +
                'AND DEPT_CD LIKE :team ' +
                'ORDER BY PRIV DESC, POSITION, GRADE, USERID ');

        if cb_team.Hint <> '' then
          ParamByName('team').AsString := cb_team.Hint
        else
          ParamByName('team').AsString := DM1.FUserInfo.CurrentUsersDept+'%';


        ParamByName('param1').AsString := 'I';
        Open;

        while not eof do
        begin
          Add(FieldByName('NAME_KOR').AsString);
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure ToverTime_Frm.cb_UsersSelect(Sender: TObject);
var
  i : Integer;
begin
  if cb_users.Text <> '' then
  begin
    with DM1.OraQuery1 do
    begin
      First;
      i := -1;

      while not eof do
      begin
        if RecNo = cb_users.ItemIndex then
        begin
          cb_users.Hint := FieldByName('USERID').AsString;
          Break;
        end;
        Next;
      end;
    end;
  end else
    cb_users.Hint := '';

end;

procedure ToverTime_Frm.FormCreate(Sender: TObject);
begin
  dt_begin.Date := StartOfTheWeek(Today);
  dt_end.Date   := EndOfTheWeek(Today);
end;

procedure ToverTime_Frm.rg_periodClick(Sender: TObject);
begin
  dt_begin.Enabled := False;
  dt_end.Enabled   := False;
  case rg_period.ItemIndex of
    0 :
    begin
      dt_begin.Date := Now;
      dt_end.Date   := Now;
    end;
    1 :
    begin
      dt_begin.Date := StartOfTheWeek(Now);
      dt_end.Date   := EndOfTheWeek(Now);
    end;
    2 :
    begin
      dt_begin.Date := StartOfTheMonth(Now);
      dt_end.Date   := EndOfTheMonth(Now);
    end;
    3 :
    begin
      dt_begin.Enabled := True;
      dt_end.Enabled   := True;
    end;
  end;
end;

end.
