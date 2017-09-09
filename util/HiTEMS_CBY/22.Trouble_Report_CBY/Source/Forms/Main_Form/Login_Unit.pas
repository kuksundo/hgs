unit Login_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

type
  TLogin_Frm = class(TForm)
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    FFirst : Boolean;
    FLoginID : String;
    FChkCount: Integer;
    procedure WMCopyData(var Msg: TMessage); message WM_COPYDATA;
    procedure WMCopyClone;
  public
    { Public declarations }
  end;

var
  Login_Frm: TLogin_Frm;

implementation
uses
  HiTEMSConst_Unit, Main_Unit;

{$R *.dfm}

{ TForm4 }

procedure TLogin_Frm.FormActivate(Sender: TObject);
begin
  if FFirst = True then
  begin
    FFirst := False;
//    WMCopyClone;
  end;
end;

procedure TLogin_Frm.FormCreate(Sender: TObject);
begin
  FFirst := True;
  FChkCount := 0;
  Timer1.Enabled := True;
end;

procedure TLogin_Frm.Timer1Timer(Sender: TObject);
begin
  if not(FLoginId = '') then
    Timer1.Enabled := False
  else
  begin
    Inc(FChkCount);
    if FChkCount = 7 then
    begin
      ShowMessage('문제점보고서 로드에 실패하였습니다. 재접속 부탁 드립니다.');
      Close;
    end;
  end;
end;

procedure TLogin_Frm.WMCopyClone;
var
  LUserID : String;
  LForm : TMain_Frm;
begin
//    FLoginID := 'A448737'; // 김병길 기사
//    FLoginID := 'A450723'; // 전병현 대리
//    FLoginID := 'A417041';
//    FLoginID := 'A393908'; //정대열 차장님
//    FLoginID := 'A313416';


  try
//    FLoginID := PUserInfoRecord(PCopyDataStruct(Msg.LParam)^.lpData)^.FUserId;
    if not(FLoginID = '') then
    begin
      Timer1.Enabled := False;
//      Self.Visible := False;
      try
        LForm := TMain_Frm.Create(nil);
        with LForm do
        begin
          FUserID := FLoginID;
          ShowModal;
        end;
      finally
        FreeAndNil(LForm);
      end;
    end;
  finally
    Close;
  end;
end;

procedure TLogin_Frm.WMCopyData(var Msg: TMessage);
var
  LUserID : String;
  LForm : TMain_Frm;
begin
  FLoginID := '';
  try
    FLoginID := PUserInfoRecord(PCopyDataStruct(Msg.LParam)^.lpData)^.FUserId;
    if not(FLoginID = '') then
    begin
      Timer1.Enabled := False;
      Self.Visible := False;
      try
        LForm := TMain_Frm.Create(nil);
        with LForm do
        begin
          FUserID := FLoginID;
          ShowModal;
        end;
      finally
        FreeAndNil(LForm);
      end;
    end;
  finally
    Close;
  end;
end;

end.
