unit UnitSelectUser;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, pjhComboBox, AeroButtons,
  AdvPanel, NxColumnClasses, AdvGlowButton, NxColumns, NxScrollControl,
  NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.ExtCtrls, NxCollection,
  Vcl.ImgList, HiMECSConst{$IFDEF AMS}, UnitDM{$ENDIF};

type
  TSelectUserF = class(TForm)
    NxHeaderPanel1: TNxHeaderPanel;
    UserGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    UserId2: TNxTextColumn;
    UserName2: TNxTextColumn;
    AdvGlowButton5: TAdvGlowButton;
    Panel2: TPanel;
    Panel3: TPanel;
    empGrid: TNextGrid;
    NxIncrementColumn2: TNxIncrementColumn;
    Checked: TNxCheckBoxColumn;
    UserId: TNxTextColumn;
    UserName: TNxTextColumn;
    UserGrade: TNxTextColumn;
    AdvPanel1: TAdvPanel;
    Label13: TLabel;
    Label1: TLabel;
    AeroButton3: TAeroButton;
    deptno: TComboBoxInc;
    teamno: TComboBoxInc;
    Panel4: TPanel;
    AdvGlowButton3: TAdvGlowButton;
    Button1: TButton;
    ImageList1: TImageList;
    AdvGlowButton1: TAdvGlowButton;
    procedure deptnoDropDown(Sender: TObject);
    procedure teamnoDropDown(Sender: TObject);
    procedure deptnoSelect(Sender: TObject);
    procedure AeroButton3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure AdvGlowButton5Click(Sender: TObject);
    procedure teamnoSelect(Sender: TObject);
  private
    { Private declarations }
  public
    procedure FillInUser2Grid;
    procedure FillInUser2Grid2(AUserList: string);
    procedure Add2UserGrid; overload;
    procedure Add2UserGrid(AUserInfo: TUserInfo); overload;
    function CheckSameUserExist(AUserId: string; AGrid: TNextGrid; ACol: integer): Boolean;
  end;

  //ARegUserDeptCode = RegUser의 DeptName;Deptcode;TeamName;TeamCode
  function Create_SelectUser_Frm(AUserList, ARegUserDeptCode: string): string;

var
  SelectUserF: TSelectUserF;

implementation

uses CommonUtil;

{$R *.dfm}

function Create_SelectUser_Frm(AUserList, ARegUserDeptCode: string): string;
var
  i: integer;
begin
//  Result := '';
  SelectUserF := TSelectUserF.Create(nil);
  try
    with SelectUserF do
    begin
{$IFDEF AMS}
      if DM1.FUserInfo.UserId <> '' then
      begin
        Deptno.Text := DM1.FUserInfo.DeptName;
        Deptno.Tag := 1;
        Deptno.Hint := DM1.FUserInfo.Dept_Cd;
//        deptno.Tag := deptno.ItemIndex;
        Teamno.Text := DM1.FUserInfo.TeamName;
        Teamno.Hint := DM1.FUserInfo.TeamNo;
        Teamno.Tag := 1;
        AeroButton3Click(nil);
      end
      else
{$ENDIF}
      if ARegUserDeptCode <> '' then
      begin
        Deptno.Text := strToken(ARegUserDeptCode, ';');
        Deptno.Tag := 1;
        Deptno.Hint := strToken(ARegUserDeptCode, ';');
//        deptno.Tag := deptno.ItemIndex;
        Teamno.Text := strToken(ARegUserDeptCode, ';');
        Teamno.Hint := strToken(ARegUserDeptCode, ';');
        Teamno.Tag := 1;
        AeroButton3Click(nil);
      end;


      FillInUser2Grid2(AUserList);

      if ShowModal = mrOK then
      begin
        for i := 0 to UserGrid.RowCount - 1 do
        begin
          Result := Result + UserGrid.CellByName['UserId2', i].AsString + ';';
        end;
      end
      else
        Result := '?';
    end;
  finally
    FreeAndNil(SelectUserF);
  end;
end;

procedure TSelectUserF.Add2UserGrid;
var
  i,j,k: integer;
  LUser: string;
begin
  for i := 0 to empGrid.RowCount - 1 do
  begin
    if empGrid.CellByName['Checked',i].AsBoolean then
    begin
      LUser := empGrid.CellByName['UserId', i].AsString;
      k := UserGrid.Columns.Column['UserId2'].Index;
      if CheckSameUserExist(LUser, UserGrid, k) then
        Continue;

      j := UserGrid.AddRow;
      UserGrid.CellByName['UserId2',j].AsString := empGrid.CellByName['UserId', i].AsString;
      UserGrid.CellByName['UserName2',j].AsString := empGrid.CellByName['UserName',i].AsString;
    end;
  end;
end;

procedure TSelectUserF.Add2UserGrid(AUserInfo: TUserInfo);
var
  i: integer;
begin
  if AUserInfo.UserID <> '' then
  begin
    i := UserGrid.AddRow;
    UserGrid.CellByName['UserId2',i].AsString := AUserInfo.UserID;
    UserGrid.CellByName['UserName2',i].AsString := AUserInfo.UserName;
  end;
end;

procedure TSelectUserF.AdvGlowButton5Click(Sender: TObject);
begin
  UserGrid.DeleteRow(UserGrid.SelectedRow);
end;

procedure TSelectUserF.AeroButton3Click(Sender: TObject);
begin
  FillInUser2Grid;
end;

procedure TSelectUserF.Button1Click(Sender: TObject);
begin
  Add2UserGrid;
end;

function TSelectUserF.CheckSameUserExist(AUserId: string; AGrid: TNextGrid; ACol: integer): Boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to AGrid.RowCount - 1 do
  begin
    if SameText(AGrid.Cells[ACol,i], AUserId) then
    begin
      Result := True;
      Break;
    end;
  end;
end;

procedure TSelectUserF.deptnoDropDown(Sender: TObject);
begin
{$IFDEF AMS}
  DM1.FillInDeptCombo(deptno);
{$ENDIF}
end;

procedure TSelectUserF.deptnoSelect(Sender: TObject);
var
  i: Integer;
  LDept: string;
begin
  //현재 선택된 ComboBox Index를 Tag에 저장하여
  //hint에 저장된 ';' 로 분리된 부서코드를 가져오기 위한 Index로 사용함
  deptno.Tag := deptno.ItemIndex;
  LDept := GetstrTokenNth(deptno.Hint, ';', deptno.Tag);
{$IFDEF AMS}
  DM1.FillInPartCombo(LDept, teamno);
{$ENDIF}
end;

procedure TSelectUserF.FillInUser2Grid;
var
  LDept: string;
  LTeam: string;
begin
  LDept := GetstrTokenNth(deptno.Hint, ';', deptno.Tag);
//  teamno.Tag := teamno.ItemIndex;
  LTeam := GetstrTokenNth(teamno.Hint, ';', teamno.Tag);
{$IFDEF AMS}
  DM1.FillInUserGrid(LDept, LTeam, empGrid);
{$ENDIF}
end;

procedure TSelectUserF.FillInUser2Grid2(AUserList: string);
var
  LStr: string;
  LUser: TUserInfo;
begin
  LStr := AUserList;

  while LStr <> '' do
  begin
    LStr := strToken(AUserList, ';');
{$IFDEF AMS}
    LUser := DM1.Get_User_Info(LStr);
{$ENDIF}

    if LUser.UserID <> '' then
    begin
      Add2UserGrid(LUser);
    end;
  end;
end;

procedure TSelectUserF.teamnoDropDown(Sender: TObject);
begin
  if deptno.Text <> '' then
  begin
  end
  else
    ShowMessage('먼저 부서를 선택하여 주십시오.');
end;

procedure TSelectUserF.teamnoSelect(Sender: TObject);
begin
  teamno.Tag := teamno.ItemIndex;
end;

end.
