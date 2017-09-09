unit mobileEmpIds_Unit;

interface

uses
  Main_Unit, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, AdvObj, BaseGrid, AdvGrid,
  Vcl.StdCtrls, Trouble_Mobile_Unit;

type
  TmobileEmpIds_Frm = class(TForm)
    Label9: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    dept: TEdit;
    team: TEdit;
    manager: TEdit;
    TeamTable: TAdvStringGrid;
    Label3: TLabel;
    member: TEdit;
    Button2: TButton;
    Button1: TButton;
    Button3: TButton;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TeamTableGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure TeamTableCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FFirst : Boolean;
  public
    FManager : String;
    FTeam : String;
    FEmpKind : Integer; //0 : 작성자 1 : 설계담당자
    FOwner : TTrouble_Mobile_Frm;


    function Get_DeptInfo(CheifID : String) : String;
    procedure Send_Message_to_Inempno(Amanager, Ainempno:String); //직성 담당자에게 통보
    procedure Send_Message_Main_CODE(FFlag,FSendID,FRecID,FHead,FTitle,FContent:String); // 메세지 메인 함수

  end;

var
  mobileEmpIds_Frm : TmobileEmpIds_Frm;

implementation
uses
  DataModule_Unit, HHI_WebService, UnitHHIMessage;

{$R *.dfm}

{ TmobileEmpIds_Frm }

procedure TmobileEmpIds_Frm.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TmobileEmpIds_Frm.Button2Click(Sender: TObject);
var
  EmpIds : String;
  li : integer;

begin
  EmpIds := '';
  for li := 0 to TeamTable.RowCount-1 do
  begin
    if TeamTable.IsRadioButtonChecked(3,li+1) = True then
    begin
      EmpIds := TeamTable.Cells[4,li+1];
      Break;
    end;
  end;

  if not(EmpIds = '') then
  begin
    case FEmpKind of
      0 : FOwner.PCharger.InEmpId := EmpIds;
      1 : FOwner.PCharger.EmpId   := EmpIds;
    end;

    case FEmpKind of
      0 : FOwner.inemp.Text := FOwner.Select_User_Info(EmpIds);
      1 : FOwner.emp.Text   := FOwner.Select_User_Info(EmpIds);
    end;
    Send_Message_to_Inempno(FManager, EmpIds);
    Close;
  end
  else
    ShowMessage('선택된 구성원이 없습니다.');

end;

procedure TmobileEmpIds_Frm.Button3Click(Sender: TObject);
var Loc: TPoint; Fp: TFindParams;
begin
  Loc := Point(-1,-1);
  Fp := [fnMatchRegular, fnAutoGoto];
//  repeat
    Loc := TeamTable.Find(loc, member.Text,fp);
//    if not ((loc.X = -1) or (loc.Y = -1)) then
//      ShowMessage('Text found at : '+IntToStr(loc.x)+':'+IntToStr(loc.y));
//  until (loc.X = -1) or (loc.Y = -1); ShowMessage('No more occurrences of text found');
end;

procedure TmobileEmpIds_Frm.FormActivate(Sender: TObject);
begin
  if FFirst = True then
  begin
    FFirst := False;
    Get_DeptInfo(FManager);
  end;

end;

procedure TmobileEmpIds_Frm.FormCreate(Sender: TObject);
begin
  FFirst := True;
end;

function TmobileEmpIds_Frm.Get_DeptInfo(CheifID: String): String;
var
  li : integer;
begin
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select DeptNo, DESCR from DeptNo');
    SQL.Add('where DEPTNO = (select SOSOK from DeptNo where MANAGER = :param1)' );
    SQL.Add('and GUBUN = ''D''' );
    parambyname('param1').AsString := CheifId;
    Open;
    dept.Text := Fieldbyname('DESCR').AsString;
  end;

  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from DeptNo where MANAGER = :param1');
    parambyname('param1').AsString := CheifId;
    Open;

    Team.Text := Fieldbyname('DESCR').AsString;
    FTeam := Fieldbyname('DeptNo').AsString;
  end;

  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select A.*, B.CODENM from User_Info A, ZHITEMSCODE B where TEAM = :param1 and PRIV = 1');
    SQL.Add(' and A.CLASS = B.CODE And Gunmu = ''I'' order by CLASS, USERID');
    parambyname('param1').AsString := FTEAM;
    Open;

    if not(RecordCount = 0) then
    begin
      with TeamTable do
      begin
        try
          beginUpdate;
          RowCount := RecordCount +1;
          AutoSize := False;
          for li := 0 to RecordCount-1 do
          begin
            Cells[1,li+1] := Fieldbyname('Name_Kor').AsString;
            Cells[2,li+1] := Fieldbyname('CODENM').AsString;
            AddRadioButton(3,li+1,false);
            Cells[4,li+1] := Fieldbyname('USERID').AsString;
            Next;
          end;
        finally
          AutoSize := True;
          ColWidths[4] := 0;
          EndUpdate;
        end;
      end;
    end
    else
    begin
      TeamTable.RowCount := 2;
      TeamTable.ClearRows(1,1);
    end;
  end;
end;

procedure TmobileEmpIds_Frm.Send_Message_Main_CODE(FFlag, FSendID, FRecID,
  FHead, FTitle, FContent: String);
var
  LTXK0SMS2 : TXK0SMS2;
begin
  LTXK0SMS2 := TXK0SMS2.Create;
  try
    LTXK0SMS2.SEND_SABUN := FSendID;
    LTXK0SMS2.RCV_SABUN := FRecID;
    LTXK0SMS2.SYS_TYPE := '112';
    LTXK0SMS2.NOTICE_GUBUN := FFlag;

    LTXK0SMS2.TITLE := FTitle;
    //LTXK0SMS2.SEND_HPNO := '010-4190-6742';
    //LTXK0SMS2.RCV_HPNO := '010-3351-7553';
    LTXK0SMS2.CONTENT := FContent;
    LTXK0SMS2.ALIM_HEAD := FHead;

    SendHHIMessage(LTXK0SMS2);
  finally
    LTXK0SMS2.Free;
  end;
end;

procedure TmobileEmpIds_Frm.Send_Message_to_Inempno(Amanager, Ainempno:String);
var
  Li : integer;
  LPending : integer;
  LCCount : integer;
  LSendMessage : Boolean;
  LFlag,
  LSend,
  LReceive,
  LTitle,
  LContent,
  LHead : AnsiString;
begin
    LSend := Amanager;
    LReceive := Ainempno;


  if (LSend = '') or (LReceive='') then Exit;
  if not(LSend = LReceive) then
  begin
    LHead := 'HiTEMS-문제점보고서';
    LTITLE := '모바일으로 접수된 문제점에 대한 담당자로 지정 되었습니다. 확인 후 조치 바랍니다.';
    LCONTENT := '모바일으로 접수된 문제점에 대한 담당자로 지정 되었습니다. 확인 후 조치 바랍니다.';

    for li := 0 to 1 do
    begin
      case li of
        0 : LFlag := 'A';
        1 : LFlag := 'B';
      end;
      Send_Message_Main_CODE(LFlag,LSend,LReceive,LHead,LTitle,LContent);
    end;
  end;
end;

procedure TmobileEmpIds_Frm.TeamTableCanEditCell(Sender: TObject; ARow,
  ACol: Integer; var CanEdit: Boolean);
begin
  if ARow > 0 then
    if ACol = 3 then
      CanEdit := True;
end;

procedure TmobileEmpIds_Frm.TeamTableGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  HAlign := taCenter;
end;

end.
