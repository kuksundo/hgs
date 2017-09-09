unit findUser_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AdvCombo, NxColumnClasses,
  NxColumns, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid,
  AdvGlowButton, AdvPanel, Vcl.Imaging.jpeg, Vcl.ExtCtrls, StrUtils, AeroButtons,
  pjhComboBox;

type
  TfindUser_Frm = class(TForm)
    Panel5: TPanel;
    Image1: TImage;
    AdvPanel1: TAdvPanel;
    Panel2: TPanel;
    AdvGlowButton2: TAdvGlowButton;
    AdvGlowButton3: TAdvGlowButton;
    empGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    Label13: TLabel;
    Label1: TLabel;
    teamno: TAdvComboBox;
    NxCheckBoxColumn1: TNxCheckBoxColumn;
    AeroButton3: TAeroButton;
    deptno: TComboBoxInc;
    procedure deptnoDropDown(Sender: TObject);
    procedure teamnoDropDown(Sender: TObject);
    procedure AdvGlowButton3Click(Sender: TObject);
    procedure deptnoSelect(Sender: TObject);
    procedure empGridCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure AdvGlowButton2Click(Sender: TObject);
    procedure empGridHeaderClick(Sender: TObject; ACol: Integer);
    procedure empGridAfterEdit(Sender: TObject; ACol, ARow: Integer;
      Value: WideString);
    procedure AeroButton3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    fAllChecked : Boolean;
    fCheckedType : String;
    FTeamList: TStringList;
  public
    { Public declarations }
    procedure Set_empGrid(aDeptNm,aTeamNm:String);
    procedure Set_empGrid2(ATeamCode: string);
  end;

var
  findUser_Frm: TfindUser_Frm;

  function Create_findUser_Frm(aUserId,aCheckedType:String):String;

implementation
uses
  taskMain_Unit,
  HITEMS_TMS_COMMON,
  HITEMS_TMS_CONST,
  DataModule_Unit;

{$R *.dfm}

function Create_findUser_Frm(aUserId,aCheckedType:String):String;
var
  luserId : String;
  li : Integer;
  lResult : String;
begin
  findUser_Frm := TfindUser_Frm.Create(nil);
  try
    with findUser_Frm do
    begin
      // aSelectedType = 'A' then Alone
      // aSelectedType = 'M' then Multi
      fCheckedType := aCheckedType;
      FallChecked := False;
      if not(aUserId = '') then
        lUserId := aUserId;

      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT DEPT_NAME FROM DPMS_DEPT ' +
                'WHERE DEPT_CD = (SELECT DEPT_CD FROM DPMS_USER ' +
                'where USERID = :param1 )');
        ParamByName('param1').AsString := aUserId;
        Open;

        teamNo.Text := FieldByName('DEPT_NAME').AsString;
        Set_empGrid(DM1.FUserInfo.UserID, teamNo.Text);

      end;

      ShowModal;

      if ModalResult = mrOk then
      begin
        with empGrid do
        begin
          BeginUpdate;
          try
            lResult := '';
            for li := 0 to RowCount-1 do
            begin
              if Cell[1,li].AsBoolean = True then
                lResult := lResult + empGrid.Cells[2,li]+';';
            end;

            lResult := Copy(lResult,0,Length(lResult)-1);

            if lResult <> '' then
              Result := lResult
            else
              Result := '';
            
          finally
            EndUpdate;
          end;
        end;
      end;
    end;
  finally
    FreeAndNil(findUser_Frm);
  end;
end;


procedure TfindUser_Frm.AdvGlowButton2Click(Sender: TObject);
begin
  Close;
end;

procedure TfindUser_Frm.AdvGlowButton3Click(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfindUser_Frm.AeroButton3Click(Sender: TObject);
var
  LCode: string;
begin
  if DeptNo.ItemIndex <> -1 then
  begin
    if teamno.ItemIndex <> -1 then
    begin
      if teamNo.ItemIndex > 0 then
        LCode := FTeamList.Strings[teamNo.ItemIndex - 1]
      else
        LCode := '';

      Set_empGrid2(LCode);
    end
    else
      Set_empGrid2(DM1.FDeptList.Strings[DeptNo.ItemIndex]);
  end;
end;

procedure TfindUser_Frm.deptnoDropDown(Sender: TObject);
var
  i : integer;
begin
  with deptNo.Items do
  begin
    BeginUpdate;
    try
      Clear;
      for i := 0 to DM1.FDeptList.Count - 1 do
        Add(TDeptClass(DM1.FDeptDic.Items[DM1.FDeptList.Strings[i]]).FName);

//      Add('');
//      with DM1.OraQuery1 do
//      begin
//        Close;
//        SQL.Clear;
//        SQL.Add('SELECT * FROM DPMS_DEPT ' +
//                'WHERE DEPT_LV = :param1 ' +
//                'ORDER BY DEPT_NAME ');
//        ParamByName('param1').AsInteger := 1;
//        Open;
//
//        while not eof do
//        begin
//          Add(FieldByName('DEPT_NAME').AsString);
//          Next;
//        end;
//      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TfindUser_Frm.deptnoSelect(Sender: TObject);
begin
//  ShowMessage(IntToStr(deptno.ItemIndex));
//  teamNo.Clear;
//  teamNo.Items.Clear;
//
//  with empGrid do
//  begin
//    BeginUpdate;
//    try
//      ClearRows;
//      with DM1.OraQuery1 do
//      begin
//        Close;
//        SQL.Clear;
//        SQL.Add('SELECT A.USERID, NAME_KOR, B.DESCR FROM DPMS_USER A, DPMS_USER_GRADE B ' +
//                'WHERE GUNMU = :param1 ' +
//                'AND A.GRADE = B.GRADE ' +
//                'AND SUBSTR(DEPT_CD,1,3) = (SELECT DEPT_CD FROM DPMS_DEPT ' +
//                'WHERE DEPT_NAME = :param2 ) ORDER BY PRIV Desc, POSITION, A.GRADE, USERID');
//
//        ParamByName('param1').AsString := 'I';
//        ParamByName('param2').AsString := deptno.Text;
//        Open;
//
//        while not eof do
//        begin
//          AddRow;
//
//          Cells[2,RowCount-1] := FieldByName('USERID').AsString;
//          Cells[3,RowCount-1] := FieldByName('NAME_KOR').AsString;
//          Cells[4,RowCount-1] := FieldByName('DESCR').AsString;
//
//          Next;
//        end;
//      end;
//    finally
//      EndUpdate;
//    end;
//  end;
end;

procedure TfindUser_Frm.empGridAfterEdit(Sender: TObject; ACol, ARow: Integer;
  Value: WideString);
var
  i : Integer;
begin
  with empGrid do
  begin
    if ACol = 1 then
    begin
      if fCheckedType = 'A' then
      begin
        try
          for i := 0 to RowCount-1 do
            Cell[1,i].AsBoolean := False;
        finally
          Cell[1,ARow].AsBoolean := True;
        end;
      end;
    end;
  end;
end;

procedure TfindUser_Frm.empGridCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  ModalResult := mrOk;
end;

procedure TfindUser_Frm.empGridHeaderClick(Sender: TObject; ACol: Integer);
var
  li : Integer;

begin
  with empGrid do
  begin
    BeginUpdate;
    try
      case ACol of
        1 : //FallChecked
        begin
          if FallChecked = True then
            FallChecked := False
          else
            FallChecked := True;

          for li := 0 to RowCount-1 do
            Cell[1,li].AsBoolean := FallChecked;

        end;
      end;

    finally
      EndUpdate;
    end;
  end;
end;

procedure TfindUser_Frm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FTeamList.Free;
end;

procedure TfindUser_Frm.FormCreate(Sender: TObject);
begin
  FTeamList := TStringList.Create;
end;

procedure TfindUser_Frm.Set_empGrid(aDeptNm, aTeamNm: String);
var
  lrow : Integer;
  lDeptNo : String;
begin
  with empGrid do
  begin
    BeginUpdate;
    try
      ClearRows;
      with DM1.OraQuery1 do
      begin
        if not(aTeamNm= '') then
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT * FROM DPMS_DEPT ' +
                  'WHERE DEPT_NAME = :param1 ');
          ParamByName('param1').AsString := aTeamNm;
          Open;

          if not(RecordCount = 0) then
          begin
            lDeptNo := FieldByName('DEPT_CD').AsString;

            Close;
            SQL.Clear;
            SQL.Add('SELECT A.*, B.DESCR FROM DPMS_USER A, DPMS_USER_GRADE B ' +
                    'WHERE GUNMU = :param1 ' +
                    'AND A.GRADE = B.GRADE ' +
                    'AND DEPT_CD like :param2 '+
                    'ORDER BY PRIV DESC, A.GRADE, USERID ');
            ParamByName('param1').AsString := 'I';
            ParamByName('param2').AsString := '%'+lDeptNo+'%';
          end;
        end
        else
        begin
          if not(aDeptNm = '') then
          begin
            Close;
            SQL.Clear;
            SQL.Add('SELECT * FROM DPMS_DEPT ' +
                    'WHERE DEPT_NAME = :param1 ');
            ParamByName('param1').AsString := aDeptNm;
            Open;

            if not(RecordCount = 0) then
            begin
              lDeptNo := FieldByName('DEPT_CD').AsString;

              Close;
              SQL.Clear;
              SQL.Add('SELECT A.*, B.DESCR FROM DPMS_USER A, DPMS_USER_GRADE B ' +
                      'WHERE GUNMU = :param1 ' +
                      'AND A.GRADE = B.GRADE ' +
                      'AND DEPT_NO like :param2 '+
                      'ORDER BY PRIV DESC, A.GRADE, USERID ');
              ParamByName('param1').AsString := 'I';
              ParamByName('param2').AsString := '%'+lDeptNo+'%';
            end;
          end
          else
          begin
            Close;
            SQL.Clear;
            SQL.Add('SELECT A.*, B.DESCR FROM DPMS_USER A, DPMS_USER_GRADE B ' +
                    'WHERE GUNMU = :param1 ' +
                    'AND A.GRADE = B.GRADE ' +
                    'ORDER BY PRIV DESC, A.GRADE , USERID ');
            ParamByName('param1').AsString := 'I';
          end;
        end;

        Open;
        if RecordCount > 0 then
        begin
          while not eof do
          begin
            lrow := AddRow;

            Cells[2,lrow] := FieldByName('USERID').AsString;
            Cells[3,lrow] := FieldByName('NAME_KOR').AsString;
            Cells[4,lrow] := FieldByName('DESCR').AsString;
            Next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;

end;

procedure TfindUser_Frm.Set_empGrid2(ATeamCode: string);
begin
  with empGrid do
  begin
    BeginUpdate;
    try
      ClearRows;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT A.USERID, NAME_KOR, B.DESCR FROM DPMS_USER A, DPMS_USER_GRADE B, DPMS_DEPT C ' +
                'WHERE GUNMU = :param1 ' +
                'AND A.GRADE = B.GRADE AND A.DEPT_CD = C.DEPT_CD AND A.DEPT_CD = :PARAM2 ');

        if Length(ATeamCode) = 3 then
          SQL.Text := ReplaceStr(SQL.Text, 'A.DEPT_CD = :PARAM2','SUBSTR(A.DEPT_CD,1,3) = :PARAM2');

        ParamByName('param1').AsString := 'I';
        ParamByName('param2').AsString := ATeamCode;

        Open;

        while not eof do
        begin
          AddRow;

          Cells[2,RowCount-1] := FieldByName('USERID').AsString;
          Cells[3,RowCount-1] := FieldByName('NAME_KOR').AsString;
          Cells[4,RowCount-1] := FieldByName('DESCR').AsString;

          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TfindUser_Frm.teamnoDropDown(Sender: TObject);
var
  ldeptNo, LStr : String;
begin
  with teamno.Items do
  begin
    BeginUpdate;
    try
      Clear;

      Add('');
      with DM1.OraQuery1 do
      begin
        if not(deptno.Text = '') then
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT DEPT_CD FROM DPMS_DEPT ' +
                  'where DEPT_NAME = :param1 ');
          ParamByName('param1').AsString := deptno.Text;
          Open;

          if RecordCount > 0 then
          begin
            lDeptNo := LeftStr(FieldByName('DEPT_CD').AsString,3);

            Close;
            SQL.Clear;
            SQL.Add('SELECT * FROM DPMS_DEPT ');
            SQL.Add('WHERE PARENT_CD like :param1 ' +
                    'ORDER BY DEPT_CD ');
            ParamByName('param1').AsString := '%'+lDeptNo+'%';
            Open;

            FTeamList.Clear;

            while not eof do
            begin
              LStr := FieldByName('DEPT_NAME').AsString;

              if RightStr(LStr,1) <> '0' then
              begin
                FTeamList.Add(FieldByName('DEPT_CD').AsString);
                Add(LStr);
              end;

              Next;
            end;
          end;
        end
        else
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT * FROM DPMS_DEPT ' +
                  'WHERE DEPT_LV = 1 ' +
                  'AND DEPT_NAME = :param1 '+
                  'ORDER BY DEPT_CD ');
          ParamByName('param1').AsString := Get_DeptName(DM1.FUserInfo.CurrentUsersDept);
          Open;

          while not eof do
          begin
            Add(FieldByName('DEPT_NAME').AsString);
            Next;
          end;
        end;
      end;
    finally
      EndUpdate;

    end;
  end;
end;

end.
