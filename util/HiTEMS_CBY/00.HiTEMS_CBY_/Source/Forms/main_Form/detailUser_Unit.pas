unit detailUser_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  AdvGlowButton, Vcl.ImgList, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Mask, NxEdit,Ora,DB,
  JvExControls, JvLabel, AeroButtons, NxColumnClasses, NxColumns, StrUtils,
  DateUtils, CurvyControls, Vcl.ExtDlgs;

type
  TdetailUser_Frm = class(TForm)
    Panel8: TPanel;
    Panel1: TPanel;
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
    Panel2: TPanel;
    im_person: TImage;
    Panel3: TPanel;
    im_sign: TImage;
    grid_anniversary: TNextGrid;
    ImageList1: TImageList;
    JvLabel17: TJvLabel;
    JvLabel8: TJvLabel;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    JvLabel14: TJvLabel;
    JvLabel18: TJvLabel;
    AeroButton3: TAeroButton;
    AeroButton4: TAeroButton;
    Image1: TImage;
    JvLabel19: TJvLabel;
    JvLabel21: TJvLabel;
    Panel4: TPanel;
    rb_private: TRadioButton;
    rb_public: TRadioButton;
    Panel5: TPanel;
    rb_solar: TRadioButton;
    rb_lunar: TRadioButton;
    AeroButton1: TAeroButton;
    AeroButton2: TAeroButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn4: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    AeroButton5: TAeroButton;
    AeroButton6: TAeroButton;
    ImageList32x32: TImageList;
    OpenPictureDialog1: TOpenPictureDialog;
    NxTextColumn6: TNxTextColumn;
    AeroButton7: TAeroButton;
    AeroButton8: TAeroButton;
    et_empno: TNxEdit;
    et_nameK: TEdit;
    et_nameE: TEdit;
    cb_grade: TComboBox;
    cb_position: TComboBox;
    cb_dept: TComboBox;
    cb_team: TComboBox;
    dt_runday: TDateTimePicker;
    dt_chgday: TDateTimePicker;
    tel1: TEdit;
    tel2: TEdit;
    cell1: TEdit;
    cell2: TEdit;
    cell3: TEdit;
    et_email: TEdit;
    et_address: TEdit;
    cb_anniType: TComboBox;
    cb_year: TComboBox;
    cb_month: TComboBox;
    cb_day: TComboBox;
    et_msg: TNxEdit;
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
  private
    { Private declarations }
    function Get_UserGrade(aDescr:String):String;
  public
    { Public declarations }
    procedure Get_UserInfo(aUserID:String);
    function Get_DeptName(aDeptCD:String):String;
    function Get_annivesary : String;
    function Update_HiTEMS_USER : Boolean;
    procedure Update_USER_Anniversary;
  end;

var
  detailUser_Frm: TdetailUser_Frm;
  procedure Create_detailUSer_Frm(aEmpNo:String);


implementation
uses
  HiTEMS_CONST,
  DataModule_Unit;

{$R *.dfm}

procedure Create_detailUSer_Frm(aEmpNo:String);
begin
  detailUser_Frm := TdetailUser_Frm.Create(nil);
  try
    with detailUser_Frm do
    begin
      et_empno.Text := aEmpNo;
      Get_UserInfo(et_empno.Text);

      ShowModal;

    end;
  finally
    FreeAndNil(detailUser_Frm);
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

  if et_msg.Text = '' then
  begin
    et_msg.SetFocus;
    raise Exception.Create('알림말을 입력하여 주십시오!');
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
        SQL.Add('SELECT * FROM HiTEMS_DEPT ' +
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
  bmp : TBitmap;
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

      if not FieldByName('ELEC_SIGN').IsNull then
      begin
        ms := TMemoryStream.Create;//TFileStream.Create('C:\Temp\elec_sign.png',fmOpenReadWrite);
        try
          bmp := TBitmap.Create;
          try
            TBlobField(FieldByName('ELEC_SIGN')).SaveToStream(ms);
            ms.Position := 0;
            bmp.LoadFromStream(ms);
            im_sign.Picture.Bitmap.Assign(bmp);
            im_sign.Invalidate;
            im_sign.Hint := '';
          finally
            FreeAndNil(bmp);
          end;
        finally
          FreeAndNil(ms);
        end;
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

function TdetailUser_Frm.Update_HiTEMS_USER: Boolean;
var
  ms : TMemoryStream;
  OraQuery : TOraQuery;
  bmp : TBitmap;
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

        FieldByName('EMAIL').AsString    := et_email.Text;
        FieldByName('ADDRESS').AsString  := et_address.Text;

        if im_person.Hint <> '' then
        begin
          ms := TMemoryStream.Create;
          try
            bmp := TBitmap.Create;
            try
              bmp.Width := im_person.Picture.Width;
              bmp.Height := im_person.Picture.Height;
              bmp.Canvas.Draw(0,0,im_person.Picture.Graphic);
              bmp.SaveToStream(ms);
              ms.Position := 0;
              FieldByName('ID_PHOTO').Clear;
              TBlobField(FieldByName('ID_PHOTO')).LoadFromStream(ms);
            finally
              FreeAndNil(bmp);
            end;
          finally
            FreeAndNil(ms);
          end;
        end;

        if im_sign.Hint <> '' then
        begin
          ms := TMemoryStream.Create;
          try
            bmp := TBitmap.Create;
            try
              bmp.Width := im_sign.Picture.Width;
              bmp.Height := im_sign.Picture.Height;
              bmp.Canvas.Draw(0,0,im_sign.Picture.Graphic);
              bmp.SaveToStream(ms);
              ms.Position := 0;
              FieldByName('ELEC_SIGN').Clear;
              TBlobField(FieldByName('ELEC_SIGN')).LoadFromStream(ms);
            finally
              FreeAndNil(bmp);
            end;
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

              ParamByName('USERID').AsString   := CurrentUserId;
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
