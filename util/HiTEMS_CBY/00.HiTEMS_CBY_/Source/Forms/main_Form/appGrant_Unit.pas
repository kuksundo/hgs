unit appGrant_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  JvExControls, JvLabel, Vcl.StdCtrls, NxEdit, Vcl.ImgList, AeroButtons,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, DB;

type
  TappGrant_Frm = class(TForm)
    Panel8: TPanel;
    Image1: TImage;
    JvLabel16: TJvLabel;
    JvLabel31: TJvLabel;
    JvLabel1: TJvLabel;
    JvLabel3: TJvLabel;
    JvLabel2: TJvLabel;
    JvLabel7: TJvLabel;
    JvLabel11: TJvLabel;
    JvLabel15: TJvLabel;
    et_empno: TNxEdit;
    Panel2: TPanel;
    im_person: TImage;
    cb_team: TComboBox;
    et_nameK: TEdit;
    et_nameE: TEdit;
    cb_dept: TComboBox;
    JvLabel4: TJvLabel;
    cb_user: TComboBox;
    et_grade: TEdit;
    JvLabel5: TJvLabel;
    grid_app: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn6: TNxTextColumn;
    NxTextColumn1: TNxTextColumn;
    Panel1: TPanel;
    btn_close: TAeroButton;
    btn_update: TAeroButton;
    cb_app: TComboBox;
    btn_add: TAeroButton;
    btn_del: TAeroButton;
    ImageList1: TImageList;
    procedure cb_teamDropDown(Sender: TObject);
    procedure cb_teamSelect(Sender: TObject);
    procedure cb_deptDropDown(Sender: TObject);
    procedure cb_deptSelect(Sender: TObject);
    procedure cb_userDropDown(Sender: TObject);
    procedure cb_userSelect(Sender: TObject);
    procedure cb_appDropDown(Sender: TObject);
    procedure cb_appSelect(Sender: TObject);
    procedure btn_closeClick(Sender: TObject);
    procedure btn_addClick(Sender: TObject);
    procedure btn_delClick(Sender: TObject);
    procedure btn_updateClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Get_User_AppList(aUserID:String);
  end;

var
  appGrant_Frm: TappGrant_Frm;

implementation
uses
  HiTEMS_CONST,
  DataModule_Unit;

{$R *.dfm}

procedure TappGrant_Frm.cb_appSelect(Sender: TObject);
var
  i : integer;
  appCode : String;
begin
  appCode := Copy(cb_app.Text,pos('(',cb_app.Text)+1, (pos(')',cb_app.Text)-1) - (pos('(',cb_app.Text)));
  cb_app.Hint := appCode;
end;

procedure TappGrant_Frm.cb_deptDropDown(Sender: TObject);
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
        SQL.Add('SELECT * FROM HiTEMS_DEPT ' +
                'WHERE DEPT_LV <= :param1 ' +
                'ORDER BY DEPT_CD ');
        ParamByName('param1').AsInteger := 1;
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

procedure TappGrant_Frm.cb_deptSelect(Sender: TObject);
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

procedure TappGrant_Frm.cb_teamDropDown(Sender: TObject);
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
          if cb_dept.Hint = '000' then //담당임원인 경우 부서리스트만 보여줌
          begin
            SQL.Add('SELECT * FROM HiTEMS_DEPT ' +
                  'WHERE DEPT_LV = :param1 ' +
                  'ORDER BY DEPT_CD ');
            ParamByName('param1').AsInteger := 1;
          end
          else
          begin
            SQL.Add('SELECT * FROM HiTEMS_DEPT ' +
                  'START WITH PARENT_CD = :param1 ' +
                  'CONNECT BY PRIOR DEPT_CD = PARENT_CD ' +
                  'ORDER SIBLINGS BY DEPT_CD ');
            ParamByName('param1').AsString := cb_dept.Hint;
          end;

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

procedure TappGrant_Frm.cb_teamSelect(Sender: TObject);
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

procedure TappGrant_Frm.cb_userDropDown(Sender: TObject);
var
  lteam : String;
begin
  if (cb_dept.Text <> '') or (cb_team.Text <> '') then
  begin
    if (cb_team.Hint <> '') then
      lteam := cb_team.Hint
    else
      lteam := cb_dept.Hint;

    with cb_user.Items do
    begin
      BeginUpdate;
      try
        Clear;
        with DM1.OraQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT USERID, DEPT_CD, NAME_KOR FROM HITEMS_USER ' +
                  'WHERE DEPT_CD = :param1 ' +
                  'ORDER BY PRIV DESC, POSITION, USERID ');
          ParamByName('param1').AsString := lteam;
          Open;

          while not eof do
          begin
            Add(FieldByName('NAME_KOR').AsString+'('+FieldByName('USERID').AsString+')');
            Next;
          end;
        end;
      finally
        EndUpdate;
      end;
    end;
  end else
  begin
    cb_dept.SetFocus;
    ShowMessage('먼저 부서를 선택하여 주십시오!');
  end;
end;

procedure TappGrant_Frm.cb_userSelect(Sender: TObject);
var
  userId : String;

begin
  userId := Copy(cb_user.Text,pos('(',cb_user.Text)+1, (pos(')',cb_user.Text)-1) - (pos('(',cb_user.Text)));
  cb_user.Hint := userId;

  if cb_user.Hint <> '' then
  begin
    Get_User_AppList(cb_user.Hint);

  end;
end;

procedure TappGrant_Frm.Get_User_AppList(aUserID: String);
var
  ms : TMemoryStream;
  bmp : TBitmap;
  lrow : Integer;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT A.*, B.DESCR FROM HITEMS_USER A, HITEMS_USER_GRADE B ' +
            'WHERE A.GRADE = B.GRADE ' +
            'AND USERID = :param1 ');
    ParamByName('param1').AsString := cb_user.Hint;
    Open;

    if RecordCount <> 0 then
    begin
      et_empno.Text := FieldByName('USERID').AsString;
      et_nameK.Text := FieldByName('NAME_KOR').AsString;
      et_nameE.Text := FieldByName('NAME_ENG').AsString;
      et_nameE.Text := FieldByName('NAME_ENG').AsString;
      et_grade.Text := FieldByName('DESCR').AsString;

      if not FieldByName('ID_PHOTO').IsNull then
      begin
        ms := TMemoryStream.Create;//TFileStream.Create('C:\Temp\id_photo.png',fmOpenReadWrite);
        try
          bmp := TBitmap.Create;
          try
            TBlobField(FieldByName('ID_PHOTO')).SaveToStream(ms);
            ms.Position := 0;
            bmp.LoadFromStream(ms);
            im_person.Picture.Bitmap.Assign(bmp);
            im_person.Invalidate;
            im_person.Hint := '';
          finally
            FreeAndNil(bmp);
          end;
        finally
          FreeAndNil(ms);
        end;
      end;
    end;
    //Get application list
    with grid_app do
    begin
      BeginUpdate;
      try
        ClearRows;

        Close;
        SQL.Clear;
        SQL.Add('SELECT A.*, B.APPNAME_K FROM HITEMS_USER_APPLICATION A, APP_CODE B ' +
                'WHERE A.APPCODE = B.APPCODE ' +
                'AND A.USERID = :param1 ' +
                'ORDER BY A.APPCODE ');
        ParamByName('param1').AsString := et_empno.Text;
        Open;

        while not eof do
        begin
          lrow := AddRow;
          Cells[1,lrow] := FieldByName('APPCODE').AsString;
          Cells[2,lrow] := FieldByName('APPNAME_K').AsString;
          Next;
        end;
      finally
        EndUpdate;
      end;
    end;
  end;
end;

procedure TappGrant_Frm.btn_closeClick(Sender: TObject);
begin
  Close;
end;

procedure TappGrant_Frm.btn_updateClick(Sender: TObject);
var
  i : Integer;
begin
  if (cb_user.Text <> '') and (et_empno.Text <> '') then
  begin
    with grid_app do
    begin
      BeginUpdate;
      try
        with DM1.OraQuery1 do
        begin
          for i := 0 to RowCount -1 do
          begin
            if Cell[0,i].TextColor = clRed then
            begin
              Close;
              SQL.Clear;
              SQL.Add('DELETE FROM HITEMS_USER_APPLICATION ' +
                      'WHERE USERID = :param1 ' +
                      'AND APPCODE = :param2 ');
              ParamByName('param1').AsString := et_empno.Text;
              ParamByName('param2').AsString := Cells[1,i];
              ExecSQL;
            end else
            if Cell[0,i].TextColor = clBlue then
            begin
              Close;
              SQL.Clear;
              SQL.Add('INSERT INTO HITEMS_USER_APPLICATION ' +
                      'VALUES( ' +
                      ':USERID, :APPCODE, :GRANTID, :GRANTDATE)');

              ParamByName('USERID').AsString      := et_empno.Text;
              ParamByName('APPCODE').AsString     := Cells[1,i];
              ParamByName('GRANTID').AsString     := CurrentUserId;
              ParamByName('GRANTDATE').AsDateTime := Now;
              ExecSQL;

            end;
          end;
        end;
      finally
        EndUpdate;
      end;
    end;
    ShowMessage('변경완료!');
    Get_User_AppList(et_empno.Text);

  end else
  begin
    cb_user.SetFocus;
    ShowMessage('먼저 유저를 선택하여 주십시오!');

  end;
end;

procedure TappGrant_Frm.btn_addClick(Sender: TObject);
var
  i,
  lrow : Integer;

begin
  if cb_app.Text <> '' then
  begin
    with grid_app do
    begin
      BeginUpdate;
      try
        for i := 0 to RowCount-1 do
        begin
          if Cells[1,i] = cb_app.Hint then
          begin
            ShowMessage('이미 부여된 어플리케이션 입니다.');
            Exit;
          end;
        end;

        lrow := AddRow;
        Cells[1,lrow] := cb_app.Hint;
        Cells[2,lrow] := Copy(cb_app.Text,1 , POS('(',cb_app.Text)-1);

        for i := 0 to Columns.Count-1 do
          Cell[i,lrow].TextColor := clBlue;


      finally
        EndUpdate;
      end;
    end;
  end else
  begin
    cb_app.SetFocus;
    ShowMessage('추가할 어플리케이션을 선택하여 주십시오!');
  end;
end;

procedure TappGrant_Frm.btn_delClick(Sender: TObject);
var
  i : Integer;
begin
  with grid_app DO
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

procedure TappGrant_Frm.cb_appDropDown(Sender: TObject);
begin
  with cb_app.Items do
  begin
    BeginUpdate;
    try
      Clear;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM APP_CODE ' +
                'WHERE APPTYPE = :param1 ' +
                'AND STATUS != :param2 ' +
                'ORDER BY SORTNO ');
        ParamByName('param1').AsString := 'Delphi';
        ParamByName('param2').AsInteger := 1;
        Open;

        while not eof do
        begin
          Add(FieldByName('APPNAME_K').AsString+'('+FieldByName('APPCODE').AsString+')');
          Next;
        end;
      end;

    finally
      EndUpdate;
    end;
  end;
end;

end.
