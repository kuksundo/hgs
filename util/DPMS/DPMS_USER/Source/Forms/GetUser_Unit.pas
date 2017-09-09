unit GetUser_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Mask,
  JvExMask, JvToolEdit, system.Generics.Collections, Vcl.ComCtrls, Vcl.Grids,
  AdvObj, BaseGrid, AdvGrid, NxCollection, NxColumnClasses, NxColumns,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid;

type
  TUsers = record
    FID: string; //사번
    FName: string; //이름
    FPosition: string;//직책
    FChair: string;//직위
    FEmail: string;//이메일 주소
    FDEPTNO: string;//부서명
    FDEPTNOGET: String;
  end;

  TGetUser_Frm = class(TForm)
    Splitter1: TSplitter;
    NxHeaderPanel1: TNxHeaderPanel;
    Panel2: TPanel;
    Panel1: TPanel;
    Label2: TLabel;
    Button1: TButton;
    JvFilenameEdit1: TJvFilenameEdit;
    Button3: TButton;
    Button5: TButton;
    DEPT: TEdit;
    chair: TEdit;
    Panel3: TPanel;
    Panel4: TPanel;
    Memo1: TMemo;
    Panel10: TPanel;
    Panel5: TPanel;
    Edit1: TEdit;
    Label1: TLabel;
    Panel6: TPanel;
    userGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn4: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    NxTextColumn6: TNxTextColumn;
    NxTextColumn7: TNxTextColumn;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    FUsers: TStringList;
    FUserList: TDictionary<string,TUsers>;
  public
    procedure SetUsers2List(AData: string);
    procedure SetUserList2View;
    procedure Update_Test_UserInfo;
    function Get_UserItems(const aVal, aItem :String):String;
  end;

var
  GetUser_Frm: TGetUser_Frm;

implementation
uses
  DataModule_Unit, CommonUtil_Unit;

{$R *.dfm}

function NextPosRel(SearchStr: string; var Str : String; Position : integer) : integer;
begin
  delete(Str, 1, Position-1);
  Result := pos(SearchStr, Str) - 1;
end;

procedure TGetUser_Frm.Button1Click(Sender: TObject);
var
  LValueList,
  LStrList: TStringList;
  LStr, LStr1: string;
  i,j,v,c,d,lrow : integer;
begin
  LStrList := TStringList.Create;
  try
    if JvFilenameEdit1.FileName <> '' then
    begin
      with userGrid do
      begin
        BeginUpdate;
        ClearRows;
        try
          with LStrList do
          begin
            LStrList.LoadFromFile(JvFilenameEdit1.FileName);

            LValueList := TStringList.Create;
            try
              i := 0;
              while i < LStrList.Count do
              begin
                LStr := LStrList.Strings[i];

                LValueList.Clear;

                v := POS('id=chkText',LStr);
                if v > 0 then
                begin
                  lrow := AddRow;

                  LStr1 := Get_UserItems(LStr, 'DisplayName');

                  //Name
                  Cells[1,lrow] := strToken(LStr1, '(');
                  Cells[2,lrow] := strToken(LStr1, ')');
                  Cells[3,lrow] := Get_UserItems(LStr, 'EmpID');
                  Cells[4,lrow] := Get_UserItems(LStr, 'RankName');
                  Cells[5,lrow] := Get_UserItems(LStr, 'CellPhone');
                  Cells[6,lrow] := Get_UserItems(LStr, 'OFFICETEL');
                  Cells[7,lrow] := Get_UserItems(LStr, 'addr');
                end;
                Inc(i);
              end;

              edit1.Text := (IntToStr(userGrid.RowCount-1));
            finally
              FreeAndNil(LValueList);
            end;
          end;
        finally
          EndUpdate;
        end;
      end;
    end
    else
    begin
      ShowMessage('Choose File Name first!');
      exit;
    end;
  finally
    FreeAndNil(LStrList);

  end;



//    i := 0;
////    i := NextPosRel('ext:qtip="직위', LStr, i);
//    i := NextPosRel('id=chkText', LStr, i);
//
//    while i > 0 do
//    begin
//      j := NextPosRel('</TD>', LStr, i);
//      i := Pos('SPAN id=', LStr);
//      if i < j then
//        LStr2 := Copy(LStr, 0, i + 15)
//      else
//        LStr2 := Copy(LStr, 0, j);
//
//      FUsers.Add(LStr2);
//      SetUsers2List(LStr2);
//      i := NextPosRel('ext:qtip="직위', LStr, j+1);
//    end;
//
//    Memo1.Lines.Clear;
//    Memo1.Lines.AddStrings(FUsers);
//    SetUserList2View;
//
//    Edit1.Text := IntToStr(FUsers.Count);
//  finally
//    FreeAndNil(LStrList);
//  end;
end;

procedure TGetUser_Frm.Button5Click(Sender: TObject);

begin
  memo1.Lines.Clear;
  Memo1.Clear;
//  listview1.Items.Clear;
  TStringList.Create.Clear;
  fuserlist.Clear;
  jvfilenameedit1.Clear;

end;

procedure TGetUser_Frm.Button3Click(Sender: TObject);
begin
  Update_Test_UserInfo;
end;

//DPMS_User Table에 영문 이름 및 전화번호만 업데이트 함
procedure TGetUser_Frm.Update_Test_UserInfo;
var
  LID : String;
  li : integer;
  FDEPTNOGet : String;
  FFChair : String;
  FFDept : String;

begin
  for li := 0 to UserGrid.RowCount - 1 do
  begin
    LID := UserGrid.Cells[3,li];

    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from DPMS_USER');
      SQL.Add('where USERID = :param1');
      parambyname('param1').AsString   :=  LID;
      Open;

      if RecordCount > 0 then
      begin
        Close;
        SQL.Clear;
        SQL.Add('UPDATE DPMS_USER ');
        SQL.Add('SET NAME_ENG = :NAME_ENG, TELNO = :TELNO, HPNO = :HPNO, EMAIL = :EMAIL');
        SQL.Add('WHERE USERID = :USERID ');

        parambyname('USERID').AsString    := LID;
        parambyname('NAME_ENG').AsString  := UserGrid.Cells[2,li];
        parambyname('TELNO').AsString  := UserGrid.Cells[6,li];
        parambyname('HPNO').AsString   := UserGrid.Cells[5,li];
        parambyname('EMAIL').AsString   := UserGrid.Cells[7,li];
        ExecSQL;
      end;
    end;
  end;
  ShowMessage('등록 완료!!!');
end;




procedure TGetUser_Frm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(FUsers);
  FreeAndNil(FUserList);
end;

procedure TGetUser_Frm.FormCreate(Sender: TObject);
begin
  FUsers := TStringList.Create;
  FUserList := TDictionary<string,TUsers>.Create;
end;

function TGetUser_Frm.Get_UserItems(const aVal, aItem: String): String;
var
  c, d : Integer;
  LStr1 : String;
begin
  c := POS('<'+aItem+'>',aVal)+(Length(aItem)+2);
  d := POS('</'+aItem+'>',aVal);
  d := d - c;

  LStr1 := Copy(aVal,c,d);

  c := POS('<![CDATA[',LStr1)+9;
  d := POS(']]>',LStr1);
  d := d - c;

  Result := Copy(LStr1,c,d);

end;

procedure TGetUser_Frm.SetUserList2View;
var
  LID: string;
  li : integer;

  FChair : String;
  FDept : String;
begin
//  ListView1.Items.Clear;
  for LID in FUserList.Keys do
  begin
//    with ListView1.Items.Add do
//    begin
//      with DM1.OraQuery1 do
//      begin
//        Close;
//        SQL.Clear;
//        SQL.Add('select A.CLASS_, A.DESCR, B.DEPTNO, B.DESCR from DPMS_EMPLOYEE_CLASS A, DEPTNO B ');
//        SQL.Add('where B.DESCR = '''+DEPT.TEXT+''' and A.DESCR = '''+CHAIR.TEXT+''' ');
//        Open;
//
//        FChair := FieldByname('CLASS_').AsString;
//        FDept := FieldByname('Deptno').AsString;
//
//      end;//with
//
//      Caption := LID;
//      SubItems.Add(FUserList.Items[LID].FName);
//      SubItems.Add(FUserList.Items[LID].FChair);
//      SubItems.Add(FUserList.Items[LID].FPosition);
//      SubItems.Add(FUserList.Items[LID].FDeptno);
//      SubItems.Add(FUserList.Items[LID].FEmail);

//    end;
  end;
end;

procedure TGetUser_Frm.SetUsers2List(AData: string);
var
  LUser: TUsers;
  LStr: string;
  i,j: integer;
begin
  i := 0;
  j := 0;
  i := NextPosRel('직위  : ', AData, i);
  if i > -1 then
  begin
    j := Pos('<', AData);
    i := i + 7; //'직위  : ' 제거

    LStr := Copy(AData, i, j-i);
    LUser.FChair := LStr; //직위

    j := j + 1;//'<' skip
  end
  else
    j:= 0;

  i := NextPosRel('직책  : ', AData, j);
  if i > -1 then
  begin
    j := Pos('<', AData);
    i := i + 7; //'직책  : ' 제거

    LStr := Copy(AData, i, j-i);
    LUser.FPosition := LStr; //직책
    j := j + 1;//'<' skip
  end
  else
    j:= 0;

  i := NextPosRel('부서  : ', AData, j);
  if i > -1 then
  begin
    j := Pos('<', AData);
    i := i + 7; //'부서  : ' 제거

    LStr := Copy(AData, i, j-i);
    LUser.FDEPTNO := LStr; //부서
    j := j + 1;//'<' skip
  end
  else
    j:= 0;

  i := NextPosRel('이메일: ', AData, j);
  if i > -1 then
  begin
    j := Pos('<', AData);
    i := i + 6; //'이메일: ' 제거

    LStr := Copy(AData, i, j-i);
    LUser.FEmail := LStr; //이메일
    j := j + 1;//'<' skip
  end
  else
    j := 0;

  i := NextPosRel('qtitle="', AData, j);
  if i > -1 then
  begin
    i := NextPosRel('"', AData, i+9);   //'qtitle="' 제거
    j := Pos('"', AData);
    LStr := Copy(AData, 0, j-1);
    LUser.FName := LStr; //이름
    j := j + 1;//'<' skip
  end
  else
    j := 0;

  i := NextPosRel('SPAN id=', AData, j);
  if i > -1 then
  begin
    i := i + 9; //'SPAN id=' 제거
    j := Pos('cl', AData)-1;
    if j < 1 then
      LStr := Copy(AData, i, 7)
    else
      LStr := Copy(AData, i, j-i);

    LUser.FID := LStr; //사번
  end
  else
    LUser.FID := IntToStr(Random(100)); //사번

  FUserList.Add(LUser.FID, LUser);
end;

end.


{
procedure TGetUser_Frm.Button1Click(Sender: TObject);
var
  LStrList: TStringList;
  LStr, LStr2: string;
  i,j: integer;
begin
  LStrList := TStringList.Create;
  try
    if JvFilenameEdit1.FileName <> '' then
      LStrList.LoadFromFile(JvFilenameEdit1.FileName)
    else
    begin
      ShowMessage('Choose File Name first!');
      exit;
    end;

    FUsers.Clear;
    LStr := LStrList.Text;  // 메모장 내용을 가지고옴
    i := 0;
//    i := NextPosRel('ext:qtip="직위', LStr, i);
    i := NextPosRel('id=chkText', LStr, i);

    while i > 0 do
    begin
      j := NextPosRel('</TD>', LStr, i);
      i := Pos('SPAN id=', LStr);
      if i < j then
        LStr2 := Copy(LStr, 0, i + 15)
      else
        LStr2 := Copy(LStr, 0, j);

      FUsers.Add(LStr2);
      SetUsers2List(LStr2);
      i := NextPosRel('ext:qtip="직위', LStr, j+1);
    end;

    Memo1.Lines.Clear;
    Memo1.Lines.AddStrings(FUsers);
    SetUserList2View;

    Edit1.Text := IntToStr(FUsers.Count);
  finally
    FreeAndNil(LStrList);
  end;
end;
}
