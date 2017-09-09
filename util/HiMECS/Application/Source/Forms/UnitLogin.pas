unit UnitLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, NxEdit, NxCollection, ExtCtrls, jpeg, AdvOfficeStatusBar,
  QProgress, Buttons, EasterEgg;

Const
  WM_ThreadEnd = WM_User+100;

type
  TFadeType = (ftIn, ftOut);

  TFrmLogin = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    StatusBar1: TAdvOfficeStatusBar;
    Panel2: TPanel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Panel8: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    UserID: TNxEdit;
    Panel3: TPanel;
    Panel7: TPanel;
    PassWD: TNxEdit;
    fadeTimer: TTimer;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    QProgress1: TQProgress;
    procedure fadeTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure UserIDKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PassWDKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Image1DblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    fFadeType: TFadeType;
    fLabelCount : Integer;
    fModalResult : TModalResult;
    FEasternEgg: TEasternEgg;

    procedure East(msg: string);
    procedure WMThreadEnd(var Msg: TMessage); message WM_ThreadEnd;
    property FadeType : TFadeType read fFadeType write fFadeType;
  public
    FUserFileName: string;

    class function Execute(var AUserID, APasswd, AFileName: string) : TModalResult;
  end;

var
  FrmLogin: TFrmLogin;

implementation

uses UnitSelectProject;

{$R *.dfm}

procedure TFrmLogin.BitBtn1Click(Sender: TObject);
begin
  QProgress1.Active := True;
  fModalResult := mrOK;
end;

procedure TFrmLogin.BitBtn2Click(Sender: TObject);
begin
  fModalResult := mrCancel;
end;

procedure TFrmLogin.East(msg: string);
begin
  Image1.OnDblClick := Image1DblClick;
end;

class function TFrmLogin.Execute(var AUserID, APasswd, AFileName: string): TModalResult;
var
  LLogin: TFrmLogin;
begin
  LLogin := TFrmLogin.Create(nil);
//  with TFrmLogin.Create(nil) do
  with LLogin do
  begin
    try
      Result := ShowModal;
      Result := fModalResult;
      AUserID := UserID.Text;
      APassWd := PassWD.Text;
      AFileName := FUserFileName;
    finally
      QProgress1.Active := False;
      FreeAndNil(LLogin);
    end;
  end;

end;

procedure TFrmLogin.fadeTimerTimer(Sender: TObject);
const
  FADE_IN_SPEED = 3;
  FADE_OUT_SPEED = 3;
var
  newBlendValue : integer;
begin
  UserID.Setfocus;

  case FadeType of
    ftIn:
      begin
        if AlphaBlendValue < 255 then
          AlphaBlendValue := FADE_IN_SPEED + AlphaBlendValue
        else
          fadeTimer.Enabled := false;
      end;
    ftOut:
      begin
        if AlphaBlendValue > 0 then
        begin
          newBlendValue := -1 * FADE_OUT_SPEED + AlphaBlendValue;
          if newBlendValue >  0 then
            AlphaBlendValue := newBlendValue
          else
            AlphaBlendValue := 0;
        end
        else
        begin
          fadeTimer.Enabled := false;
          Close;
        end;
      end;
  end;
end;

procedure TFrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FEasternEgg.Free;
end;

procedure TFrmLogin.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  //no close before we fade away
  if FadeType = ftIn then
  begin
    fFadeType := ftOut;
    AlphaBlendValue := 255;
    fadeTimer.Enabled := true;
    CanClose := false;
  end
  else
  begin
    CanClose := true;
  end;

end;

procedure TFrmLogin.FormCreate(Sender: TObject);
begin
  AlphaBlend := true;
  AlphaBlendValue := 0;
  fFadeType := ftIn;
  fadeTimer.Enabled := true;

  //QProgress1.Active := True;
  fLabelCount := -1;
  FUserFileName := '';

  //Ctrl + 'user' key-in 하면 로그인 이미지 더블 클릭 시 user file 선택 가능함.
                                         //반드시 대문자로 할것
  FEasternEgg := TEasternEgg.Create([ssCtrl],'USER',Self);
  FEasternEgg.FOnEasterEgg := East;
end;

procedure TFrmLogin.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  FEasternEgg.CheckKeydown(Key, Shift);
end;

procedure TFrmLogin.Image1DblClick(Sender: TObject);
var
  LSelectProjectForm: TSelectProjectForm;
  LStr: string;
begin
  SetCurrentDir(ExtractFilePath(Application.ExeName)+'config\');

  LSelectProjectForm := TSelectProjectForm.Create(Self);
  try
    with LSelectProjectForm do
    begin
      FUserFileName := '';
      Label1.Caption := 'Select User File...';
      ListData2LV('.user');

      if ShowModal = mrOK then
      begin
        if projectLV.Items.Count > 0 then
        begin
          LStr := projectLV.ItemFocused.Caption;
          LStr := projectLV.ItemFocused.SubItems[0]+LStr;
          FUserFileName := LStr;
        end;
      end;
    end;
  finally
    LSelectProjectForm.Free;
    Image1.OnDblClick := nil;
  end;
end;

procedure TFrmLogin.PassWDKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    BitBtn1.SetFocus;
    //BitBtn1Click(Self);
  end;
end;

procedure TFrmLogin.UserIDKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    PassWD.SetFocus;
  end;
end;

procedure TFrmLogin.WMThreadEnd(var Msg: TMessage);
begin
  Close;
end;

end.
