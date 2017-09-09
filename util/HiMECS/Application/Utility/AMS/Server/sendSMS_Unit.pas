unit sendSMS_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxColumnClasses, NxColumns,
  AdvGlowButton, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid,
  Vcl.ExtCtrls, NxCollection, Vcl.StdCtrls, Vcl.Imaging.pngimage, Vcl.ImgList;

type
  TsendSMS_Frm = class(TForm)
    Image1: TImage;
    Memo1: TMemo;
    Label1: TLabel;
    NxHeaderPanel1: TNxHeaderPanel;
    Panel1: TPanel;
    smsGrid: TNextGrid;
    AdvGlowButton1: TAdvGlowButton;
    AdvGlowButton2: TAdvGlowButton;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    AdvGlowButton3: TAdvGlowButton;
    AdvGlowButton4: TAdvGlowButton;
    AdvGlowButton5: TAdvGlowButton;
    ImageList1: TImageList;
    procedure AdvGlowButton3Click(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AdvGlowButton2Click(Sender: TObject);
    procedure AdvGlowButton4Click(Sender: TObject);
    procedure AdvGlowButton5Click(Sender: TObject);
    procedure AdvGlowButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Send_Message;
    procedure Get_BaseMembers(aTaskNo:String);
    procedure Set_Message(aTaskNo:String);
    procedure Send_Message_Main_CODE(FFlag,FSendID,FRecID,FHead,FTitle,FContent:String); // 메세지 메인 함수

  end;

var
  sendSMS_Frm: TsendSMS_Frm;
  procedure Create_sendSMS_Frm(aTaskNo:String);

implementation
uses
  UnitfindUser,
  HHI_WebService,
  UnitHHIMessage, UnitDM;

{$R *.dfm}

procedure Create_sendSMS_Frm(aTaskNo:String);
begin
  sendSMS_Frm := TsendSMS_Frm.Create(nil);
  try
    with sendSMS_Frm do
    begin
      if aTaskNo <> '' then
      begin
        Set_Message(aTaskNo);
        Get_BaseMembers(aTaskNo);
      end;

      ShowModal;

    end;
  finally
    FreeAndNil(sendSMS_Frm);
  end;
end;

procedure TsendSMS_Frm.AdvGlowButton1Click(Sender: TObject);
begin
  Send_Message;
end;

procedure TsendSMS_Frm.AdvGlowButton2Click(Sender: TObject);
begin
  memo1.Clear;
end;

procedure TsendSMS_Frm.AdvGlowButton3Click(Sender: TObject);
begin
  Close;
end;

procedure TsendSMS_Frm.AdvGlowButton4Click(Sender: TObject);
var
  lResult : String;
  li,le : Integer;
  list : TStringList;
  lrow : Integer;
  lUserId : String;
  lboolean : Boolean;
begin
  lResult := Create_findUser_Frm('');

  if lResult <> '' then
  begin
    list := TStringList.Create;
    try
      ExtractStrings([';'],[],PChar(lResult),list);

      if list.Count <> -1 then
      begin
        with smsGrid do
        begin
          BeginUpdate;
          try
            for li := 0 to list.Count-1 do
            begin
              lboolean := True;
              for le := 0 to RowCount -1 do
              begin
                if SameText(Cells[1,le],list.Strings[li]) then
                begin
                  lboolean := False;
                  Break;
                end;
              end;

              if lboolean then
              begin
                lrow := AddRow;
                Cells[1,lrow] := list.Strings[li];
//                Cells[2,lrow] := Get_userNameAndPosition(Cells[1,lrow]);
              end;
            end;
          finally
            EndUpdate;
          end;
        end;
      end;
    finally
      FreeAndNil(list);
    end;
  end;
end;

procedure TsendSMS_Frm.AdvGlowButton5Click(Sender: TObject);
begin
  smsGrid.DeleteRow(smsGrid.SelectedRow);
end;

procedure TsendSMS_Frm.FormCreate(Sender: TObject);
begin
  smsGrid.DoubleBuffered := False;
end;

procedure TsendSMS_Frm.Get_BaseMembers(aTaskNo:String);
var
  lrow,
  li,le : Integer;
  lEmpList : TStringList;
  lboolean : Boolean;
begin
  with DM1.OraQuery1 do
  begin
    lEmpList := TStringList.Create;
    try
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM DPMS_TMS_TASK ' +
              'WHERE TASK_NO = :aTaskNo ');
      ParamByName('aTaskNo').AsString := aTaskNo;
      Open;

      // 업무 담당자
      if not(FieldByName('TASK_MANAGER').IsNull) then
        lEmpList.Add(FieldByName('TASK_MANAGER').AsString);

      // 업무 기안자
      if not(FieldByName('TASK_DRAFTER').IsNull) then
        lEmpList.Add(FieldByName('TASK_DRAFTER').AsString);

      Close;
      SQL.Clear;
      SQL.Add('SELECT MANAGER FROM DPMS_DEPT ' +
              'WHERE DEPT_CD = :param1 ');
//      ParamByName('param1').AsString := DM1.FUserInfo.CurrentUsersTeam;
      Open;

      // 현재 사용자의 팀장
      if not(FieldByName('MANAGER').IsNull) then
        lEmpList.Add(FieldByName('MANAGER').AsString);

      Close;
      SQL.Clear;
      SQL.Add('SELECT MANAGER FROM DPMS_DEPT ' +
              'WHERE DEPT_CD = :param1 ');
//      ParamByName('param1').AsString := DM1.FUserInfo.CurrentUsersDept;
      Open;

      // 현재 사용자의 부서장
      if not(FieldByName('MANAGER').IsNull) then
        lEmpList.Add(FieldByName('MANAGER').AsString);

      if lEmpList.Count > 0 then
      begin
        with smsGrid do
        begin
          BeginUpdate;
          try
            for li := 0 to lEmpList.Count-1 do
            begin
              lboolean := True;
              for le := 0 to RowCount -1 do
              begin
                if SameText(Cells[1,le],lEmpList.Strings[li]) then
                begin
                  lboolean := False;
                  Break;
                end;
              end;

              if lboolean then
              begin
                lrow := AddRow;
                Cells[1,lrow] := lEmpList.Strings[li];
//                Cells[2,lrow] := Get_userNameAndPosition(Cells[1,lrow]);
              end;
            end;
          finally
            EndUpdate;
          end;
        end;
      end;
    finally
      FreeAndNil(lEmpList);
    end;
  end;
end;

procedure TsendSMS_Frm.Memo1Change(Sender: TObject);
var
  lsize : Integer;
begin
  lsize := Length(AnsiString(Memo1.Text));
  Label1.Caption := IntToStr(lsize)+' byte';
//
//  if lsize > 80 then
//  begin
////    ShowMessage('메세지는 최대 80byte 까지 입력 가능합니다.');
//    memo1.Text := Copy(AnsiString(memo1.Text),1,80);
//
//  end;
end;

procedure TsendSMS_Frm.Send_Message;
var
  li,le : Integer;
  lflag,
  lhead,
  ltitle,
  lstr,
  lcontent : AnsiString;

begin
//  헤더의 길이가 21byte를 넘지 않아야 함.
//  lhead := 'HiTEMS-문제점보고서';
//  lhead := '123456780123456789012';
  lhead    := '업무관리시스템';
  ltitle   := '업무변경건';

  with smsGrid do
  begin
    BeginUpdate;
    try
      for li := 0 to RowCount-1 do
      begin
        lcontent := memo1.Text;
        for le := 0 to 1 do
        begin
          case le of
            0 : lflag := 'A'; //쪽지
            1 : lflag := 'B'; //SMS
          end;

          if lflag = 'B' then
          begin
            while True do
            begin
              if lcontent = '' then
                Break;

              if Length(AnsiString(lcontent)) > 90 then
              begin
                lstr := Copy(lcontent,1,90);
                lcontent := Copy(lcontent,91,Length(lcontent)-90);
              end else
              begin
                lstr := Copy(lcontent,1,Length(lcontent));
                lcontent := '';
              end;
              //문자 메세지는 title(lstr)만 보낸다.
//              Send_Message_Main_CODE(LFlag,DM1.FUserInfo.CurrentUsers,Cells[1,li],LHead,lstr,LTitle);
            end;
          end
          else
          begin
            lstr := lcontent;
//            Send_Message_Main_CODE(LFlag,DM1.FUserInfo.CurrentUsers,Cells[1,li],LHead,LTitle,lstr);

          end;
        end;
      end;
    finally
      EndUpdate;
      //ModalResult := mrOk;
    end;
  end;
end;

procedure TsendSMS_Frm.Send_Message_Main_CODE(FFlag, FSendID, FRecID, FHead,
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


procedure TsendSMS_Frm.Set_Message(aTaskNo: String);
var
  lcontent : String;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT TASK_NAME FROM DPMS_TMS_TASK ' +
            'WHERE TASK_NO = :param1 ');
    ParamByName('param1').AsString := aTaskNo;
    Open;

    lcontent := FieldByName('TASK_NAME').AsString;

  end;

  memo1.Text := '업무명 : '+lcontent+'업무 내용이 변경 되었습니다  ' +
                '확인 부탁 드립니다.';

end;

end.
