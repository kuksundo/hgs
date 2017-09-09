unit TeamChange_Unit;

interface

uses
  Main_Unit, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, AdvObj,
  BaseGrid, AdvGrid, NxEdit, Vcl.ExtCtrls;

type
  TTeamChange_Frm = class(TForm)
    Label9: TLabel;
    Chief: TEdit;
    Bevel1: TBevel;
    Label1: TLabel;
    Dept: TNxComboBox;
    Label2: TLabel;
    TeamTable: TAdvStringGrid;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure DeptButtonDown(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DeptSelect(Sender: TObject);
    procedure TeamTableCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure TeamTableGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    FFirst : Boolean;
    FFDeptList : TStringList;
    procedure Choice_Dept;
  public
    { Public declarations }
    FCODEID,
    FEngType,
    FCurrentChief,
    FSelectedDept,
    FItemName : AnsiString;

    function Get_DeptInfo(CheifID : String) : String;
    procedure Get_Team_List_From_Dept(fdeptno:String);
    function Apply_for_Change_Manager_to_DB(ChangeManager:String) : Boolean;
    procedure Change_Log(codeid, current, nextc:String);


    procedure Send_Message_to_After_Manager(current,next,itemnm, engType:String);// 결재 후 다음 결재자에게 메세지 보내기 함수
    procedure Send_Message_Main_CODE(FFlag,FSendID,FRecID,FHead,FTitle,FContent:String); // 메세지 메인 함수

  end;

var
  TeamChange_Frm: TTeamChange_Frm;

implementation
uses
  DataModule_Unit, HHI_WebService, UnitHHIMessage;

{$R *.dfm}

function TTeamChange_Frm.Apply_for_Change_Manager_to_DB(ChangeManager:String) : Boolean;
begin
  Result := False;
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Update Trouble_Mobile Set');
    SQL.Add('MANAGER = :param1 where MCODEID = :param2');
    parambyname('param1').AsString := ChangeManager;
    parambyname('param2').AsString := FCODEID;
    ExecSQL;
    Result := True;
  end;
end;

procedure TTeamChange_Frm.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TTeamChange_Frm.Button2Click(Sender: TObject);
var
  li : integer;
  lCheckManager : String;
  lBool : Boolean;
begin
  If MessageDlg('변경된 내용을 적용 하시겠습니까?'+#13+'적용 후에는 재수정할 수 없습니다.'
    , mtConfirmation, [mbYes, mbNo], 0) = mrYes Then
  begin
    for li := 1 to TeamTable.RowCount -1 do
    begin
      if TeamTable.IsRadioButtonChecked(3,li) = True then
      begin
        lCheckManager := TeamTable.Cells[4,li];
        Break;
      end;
    end;

    if not(lCheckManager = FCurrentChief) then
      if Apply_for_Change_Manager_to_DB(lCheckManager) = True then
      begin
        Send_Message_to_After_Manager(FCurrentChief,lCheckManager,FItemName, FEngType);

        Change_Log(FCODEID,FCurrentChief,lCheckManager);
        Button2.Enabled := False;
        ShowMessage('변경 완료');
      end
      else
        ShowMessage('변경 실패')

    else
      ShowMessage('변경된 내용이 없습니다.');
  end;
end;

procedure TTeamChange_Frm.Change_Log(codeid, current, nextc:String);
begin
  with DM1.OraQuery2 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('insert into TROUBLE_REPRESENTATIVE');
    SQL.Add('Values(:CODEID, :CDATE, :DESCR, :CURRENTLY, :NEXT)');
    parambyname('CODEID').AsString    := codeid;
    parambyname('CDATE').AsDateTime   := Now;
    parambyname('DESCR').AsString     := '팀장변경';
    parambyname('CURRENTLY').AsString := current;
    parambyname('NEXT').AsString      := nextc;
    ExecSQL;
  end;
end;

procedure TTeamChange_Frm.Choice_Dept;
begin

end;

procedure TTeamChange_Frm.DeptButtonDown(Sender: TObject);
begin
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from DeptNo where GUBUN = ''D''');
    SQL.Add('and SOSOK = ''K000'' and DIV = 3 order by SUBDIV');
    Open;

    FFDeptList.Clear;
    Dept.Items.Clear;

    while not eof do
    begin
      FFDeptList.Add(Fieldbyname('DEPTNO').AsString);
      Dept.Items.Add(Fieldbyname('DESCR').AsString);
      Next;
    end;
  end;
end;

procedure TTeamChange_Frm.DeptSelect(Sender: TObject);
begin
  FSelectedDept := FFDeptList.Strings[Dept.ItemIndex];
  Get_Team_List_From_Dept(FSelectedDept);
end;

procedure TTeamChange_Frm.FormActivate(Sender: TObject);
var
  li : integer;
begin
  if FFirst = True then
  begin
    FFirst := False;
    Dept.Text := Get_DeptInfo(FCurrentChief);
    Get_Team_List_From_Dept(FSelectedDept);

    for li := 1 to TeamTable.RowCount-1 do
    begin
      if TeamTable.Cells[4,li] = FCurrentChief then
      begin
        TeamTable.SetRadioButtonState(3,li,True);
        Break;
      end;
    end;
  end;
end;

procedure TTeamChange_Frm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(FFDeptList);
end;

procedure TTeamChange_Frm.FormCreate(Sender: TObject);
begin
  FFirst := True;
  FSelectedDept := '';
  FFDeptList := TStringList.Create;
end;

function TTeamChange_Frm.Get_DeptInfo(CheifID: String): String;
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

    if not(RecordCount = 0) then
    begin
      Result := Fieldbyname('DESCR').AsString;
      FSelectedDept := Fieldbyname('DeptNo').AsString;
    end
    else
      Result := '';

  end;
end;

procedure TTeamChange_Frm.Get_Team_List_From_Dept(fdeptno: String);
var
  li : integer;
begin
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select A.DESCR, A.MANAGER, B.Name_Kor from DeptNo A, User_Info B');
    SQL.Add('where A.SOSOK = :param1 and GUBUN = ''S''');
    SQL.Add('and A.Manager = B.USERID order by DESCR');
    parambyname('param1').AsString := fdeptno;
    Open;

    if not(RecordCount = 0) then
    begin
      with TeamTable do
      begin
        RowCount := RecordCount +1;
        BeginUpdate;
        AutoSize := False;
        try
          for li := 0 to RecordCount -1 do
          begin
            Cells[1,li+1] := Fieldbyname('DESCR').AsString;
            Cells[2,li+1] := Fieldbyname('NAME_KOR').AsString;
            AddRadioButton(3,li+1,false);
            Cells[4,li+1] := Fieldbyname('MANAGER').AsString;
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


procedure TTeamChange_Frm.Send_Message_Main_CODE(FFlag, FSendID, FRecID, FHead,
  FTitle, FContent: String);
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

procedure TTeamChange_Frm.Send_Message_to_After_Manager(current,next,itemnm, engType:String);
var
  Li : integer;
  LFlag,
  LSend,
  LReceive,
  LTitle,
  LContent,
  LHead : AnsiString;
begin
  LSend := current;
  LReceive := next;

  if (LSend = '') or (LReceive='') then Exit;
  if not(LSend = LReceive) then
  begin
    LHead := 'HiTEMS-문제점보고서';
    LTITLE := engType+'에관한 문제가 제보 되었습니다. 빠른 확인 부탁 드립니다.';
    LCONTENT := itemnm+'에 관한 문제가 제보 되었습니다. 검토 후 담당자 지정 부탁 드립니다.';

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

procedure TTeamChange_Frm.TeamTableCanEditCell(Sender: TObject; ARow,
  ACol: Integer; var CanEdit: Boolean);
begin
  if ARow > 0 then
    if ACol = 3 then
      CanEdit := True;

end;

procedure TTeamChange_Frm.TeamTableGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  HAlign := taCenter;
end;

end.
