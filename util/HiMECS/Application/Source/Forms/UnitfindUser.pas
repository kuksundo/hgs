unit UnitfindUser;

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
    UserId: TNxTextColumn;
    UserName: TNxTextColumn;
    UserGrade: TNxTextColumn;
    Label13: TLabel;
    Label1: TLabel;
    NxCheckBoxColumn1: TNxCheckBoxColumn;
    AeroButton3: TAeroButton;
    deptno: TComboBoxInc;
    teamno: TComboBoxInc;
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
    procedure deptnoDropDown(Sender: TObject);
  private
    { Private declarations }
    fAllChecked : Boolean;
    FTeamList: TStringList;
  public
    procedure FillInUser2Grid;
  end;

var
  findUser_Frm: TfindUser_Frm;

  function Create_findUser_Frm(aUserId:String):String;

implementation

uses UnitDM, CommonUtil;

{$R *.dfm}

function Create_findUser_Frm(aUserId:String):String;
var
  luserId : String;
  li : Integer;
  lResult : String;
begin
  findUser_Frm := TfindUser_Frm.Create(nil);
  try
    with findUser_Frm do
    begin
      FallChecked := False;
      if not(aUserId = '') then
        lUserId := aUserId;

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
                lResult := lResult + empGrid.CellByName['UserId',li].AsString+';';
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
begin
  FillInUser2Grid;
end;

procedure TfindUser_Frm.deptnoDropDown(Sender: TObject);
begin
  DM1.FillInDeptCombo(deptno);
end;

procedure TfindUser_Frm.deptnoSelect(Sender: TObject);
var
  i: Integer;
  LDept: string;
begin
  //현재 선택된 ComboBox Index를 Tag에 저장하여
  //hint에 저장된 ';' 로 분리된 부서코드를 가져오기 위한 Index로 사용함
  deptno.Tag := deptno.ItemIndex;
  LDept := GetstrTokenNth(deptno.Hint, ';', deptno.Tag);
  DM1.FillInPartCombo(LDept, teamno);
end;

procedure TfindUser_Frm.empGridAfterEdit(Sender: TObject; ACol, ARow: Integer;
  Value: WideString);
var
  i : Integer;
begin
//  with empGrid do
//  begin
//    if ACol = 1 then
//    begin
//      if fCheckedType = 'A' then
//      begin
//        try
//          for i := 0 to RowCount-1 do
//            Cell[1,i].AsBoolean := False;
//        finally
//          Cell[1,ARow].AsBoolean := True;
//        end;
//      end;
//    end;
//  end;
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

procedure TfindUser_Frm.FillInUser2Grid;
var
  LDept: string;
  LTeam: string;
begin
  LDept := GetstrTokenNth(deptno.Hint, ';', deptno.Tag);
  teamno.Tag := teamno.ItemIndex;
  LTeam := GetstrTokenNth(teamno.Hint, ';', teamno.Tag);
  DM1.FillInUserGrid(LDept, LTeam, empGrid);
end;

procedure TfindUser_Frm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FTeamList.Free;
end;

procedure TfindUser_Frm.FormCreate(Sender: TObject);
begin
  FTeamList := TStringList.Create;
end;

procedure TfindUser_Frm.teamnoDropDown(Sender: TObject);
begin
  if deptno.Text <> '' then
  begin
  end
  else
    ShowMessage('먼저 부서를 선택하여 주십시오.');
end;

end.
