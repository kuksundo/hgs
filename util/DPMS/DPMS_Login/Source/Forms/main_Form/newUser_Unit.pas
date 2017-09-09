unit newUser_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  AdvGlowButton, Vcl.ImgList, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Mask, NxEdit,
  JvExControls, JvLabel;

type
  TnewUser_Frm = class(TForm)
    Panel8: TPanel;
    Image1: TImage;
    JvLabel31: TJvLabel;
    JvLabel1: TJvLabel;
    JvLabel3: TJvLabel;
    JvLabel11: TJvLabel;
    JvLabel12: TJvLabel;
    JvLabel17: TJvLabel;
    ImageList1: TImageList;
    Button1: TButton;
    Button2: TButton;
    ImageList32x32: TImageList;
    JvLabel2: TJvLabel;
    JvLabel7: TJvLabel;
    Label1: TLabel;
    Button3: TButton;
    et_empno: TEdit;
    et_nameK: TEdit;
    et_nameE: TEdit;
    cb_grade: TComboBox;
    cb_position: TComboBox;
    cb_dept: TComboBox;
    cb_team: TComboBox;
    procedure cb_gradeDropDown(Sender: TObject);
    procedure cb_deptSelect(Sender: TObject);
    procedure cb_gradeSelect(Sender: TObject);
    procedure cb_teamDropDown(Sender: TObject);
    procedure cb_teamSelect(Sender: TObject);
    procedure cb_deptDropDown(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure et_empnoChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Get_DeptName(aDeptCD:String):String;
    function Get_DeptCode(aDeptNm:String):String;
    function Get_UserGrade(aDescr:String):String;
    function Insert_DPMS_USER : Boolean;
  end;

var
  newUser_Frm: TnewUser_Frm;
  function Create_newUser_Frm : String;

implementation
uses
  DataModule_Unit;

{$R *.dfm}

function Create_newUser_Frm : String;
begin
  newUser_Frm := TnewUser_Frm.Create(nil);
  try
    with newUser_Frm do
    begin
      button1.Enabled := False;
      ShowModal;

      if ModalResult = mrOk then
        Result := et_empno.Text
      else
        Result := '';
    end;
  finally
    FreeAndNil(newUser_Frm);
  end;
end;

procedure TnewUser_Frm.Button1Click(Sender: TObject);
begin
  if et_empno.Text = '' then
  begin
    et_empno.SetFocus;
    raise Exception.Create('사번을 입력하여 주십시오!');
  end;

  if et_nameK.Text = '' then
  begin
    et_nameK.SetFocus;
    raise Exception.Create('성명(한글)을 입력하여 주십시오!');
  end;

  if cb_grade.Text = '' then
  begin
    cb_grade.SetFocus;
    raise Exception.Create('직급을 선택하여 주십시오!');
  end;

  if cb_dept.Text = '' then
  begin
    cb_dept.SetFocus;
    raise Exception.Create('부서를 선택하여 주십시오!');
  end;

  if Insert_DPMS_USER then
  begin
    ShowMessage('등록성공!');
    ModalResult := mrOk;
  end else
  begin
    ShowMessage('등록실패!');
  end;
end;

procedure TnewUser_Frm.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TnewUser_Frm.Button3Click(Sender: TObject);
begin
  if et_empno.Text <> '' then
  begin
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM DPMS_USER ' +
              'WHERE USERID = :param1 ');
      ParamByName('param1').AsString := et_empno.Text;
      Open;

      if RecordCount <> 0 then
        ShowMessage('이미 등록된 사번 입니다.')
      else
      begin
        ShowMessage('사용 가능한 사번 입니다.');
        button1.Enabled := True;
      end;
    end;
  end else
  begin
    button1.Enabled := False;
  end;
end;

procedure TnewUser_Frm.cb_deptDropDown(Sender: TObject);
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
        SQL.Add('SELECT * FROM DPMS_DEPT ' +
                'WHERE DEPT_LV = :param1 ' +
                'ORDER BY DEPT_CD ');
        ParamByName('param1').AsInteger := 0;
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

procedure TnewUser_Frm.cb_deptSelect(Sender: TObject);
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

procedure TnewUser_Frm.cb_gradeDropDown(Sender: TObject);
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
        SQL.Add('SELECT * FROM DPMS_USER_GRADE ' +
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

procedure TnewUser_Frm.cb_gradeSelect(Sender: TObject);
begin
  if cb_grade.Text <> '' then
    cb_grade.Hint := Get_UserGrade(cb_grade.Text)
  else
    cb_grade.Hint := '';

end;

procedure TnewUser_Frm.cb_teamDropDown(Sender: TObject);
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
          SQL.Add('SELECT * FROM DPMS_DEPT ' +
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

procedure TnewUser_Frm.cb_teamSelect(Sender: TObject);
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

procedure TnewUser_Frm.et_empnoChange(Sender: TObject);
begin
  Button1.Enabled := False;
end;

function TnewUser_Frm.Get_DeptCode(aDeptNm: String): String;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM DPMS_DEPT ' +
            'WHERE DEPT_NAME = :param1 ');
    ParamByName('param1').AsString := aDeptNm;
    Open;

    Result := FieldByName('DEPT_CD').AsString;

  end;
end;

function TnewUser_Frm.Get_DeptName(aDeptCD: String): String;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM DPMS_DEPT ' +
            'WHERE DEPT_CD = :param1 ');
    ParamByName('param1').AsString := aDeptCD;
    Open;

    Result := FieldByName('DEPT_NAME').AsString;
  end;
end;

function TnewUser_Frm.Get_UserGrade(aDescr: String): String;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM DPMS_USER_GRADE ' +
            'WHERE DESCR = :param1 ');
    ParamByName('param1').AsString := aDescr;
    Open;

    Result := FieldByName('GRADE').AsString;
  end;
end;

function TnewUser_Frm.Insert_DPMS_USER: Boolean;
begin
  Result := True;
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('INSERT INTO DPMS_USER ' +
            '(USERID, PASSWD, DEPT_CD, NAME_KOR, ' +
            'NAME_ENG, GRADE, POSITION) '+
            'VALUES( ' +
            ':USERID, :PASSWD, :DEPT_CD, :NAME_KOR, ' +
            ':NAME_ENG, :GRADE, :POSITION )');
    try
      ParamByName('USERID').AsString := et_empno.Text;
      ParamByName('PASSWD').AsString := et_empno.Text;

      if (cb_dept.Text <> '') and (cb_team.Text <> '') then
        ParamByName('DEPT_CD').AsString := cb_team.Hint
      else if (cb_dept.Text <> '') and (cb_team.Text = '') then
        ParamByName('DEPT_CD').AsString := cb_dept.Hint;

      ParamByName('NAME_KOR').AsString := et_nameK.Text;
      ParamByName('NAME_ENG').AsString := et_nameE.Text;
      ParamByName('GRADE').AsString := cb_grade.Hint;
      ParamByName('POSITION').AsString := cb_position.Text;

      ExecSQL;
      Result := True;
    except
      on E:Exception do
        ShowMessage(e.Message);
    end;
  end;
end;

end.
