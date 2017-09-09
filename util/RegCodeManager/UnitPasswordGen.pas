unit UnitPasswordGen;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ActnList, XPStyleActnCtrls, ActnMan,
  ExtCtrls, StrUtils, System.Actions;

type
  TPasswordGenF = class(TForm)
    edtPassword: TEdit;
    btnPwdGen: TButton;
    btnReset: TButton;
    lblLength: TLabel;
    edtLength: TEdit;
    udLength: TUpDown;
    cbxSep: TCheckBox;
    rbtDash: TRadioButton;
    rbtUnderscore: TRadioButton;
    actmgr1: TActionManager;
    actGenPwd: TAction;
    actCancel: TAction;
    rbgPwdType: TRadioGroup;
    edtSepNum: TEdit;
    udbSepNum: TUpDown;
    lblHowMany: TLabel;
    lblCount: TLabel;
    Button1: TButton;
    procedure actGenPwdExecute(Sender: TObject);
    procedure actGenPwdUpdate(Sender: TObject);
    procedure actCancelExecute(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    function GeneratePassword(MAX_PW_LEN: integer): string;
  public
    { Public declarations }
  end;

var
  PasswordGenF: TPasswordGenF;

implementation

{$R *.dfm}

{ TForm1 }

function TPasswordGenF.GeneratePassword(MAX_PW_LEN: integer): string;
var
  i: Byte;
  L: Integer;
  s, sep, P, R, C: string;
begin
  case rbgPwdType.ItemIndex of
  0: s := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
  1: s := '0123456789';
  2: s := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  end;
  Result := '';
  Randomize;
  for i := 0 to MAX_PW_LEN-1 do
    Result := Result + s[Random(Length(s)-1)+1];
  if cbxSep.Checked then
  begin
    if rbtDash.Checked then
      sep := '-'
    else
      sep := '_';
    L := Length(Result) div (udbSepNum.Position+1);
    R := '';
    if Odd(Length(Result)) then
    begin
      C := Result[Length(Result)];
      Result := LeftStr(Result, Length(Result) - 1);
      for i := 0 to udbSepNum.Position do
      begin
        Result := RightStr(Result, Length(Result)-Length(R));
        R := Copy(Result, 0, L);
        if i < udbSepNum.Position then
          R := R + sep;
        P := P + R;
      end;
      P := P + C;
    end
    else
    begin
      for i := 0 to udbSepNum.Position do
      begin
        Result := RightStr(Result, Length(Result)-Length(R));
        R := Copy(Result, 0, L);
        if i < udbSepNum.Position then
          R := R + sep;
        P := P + R;
      end;
    end;
    Result := P;
  end;
end;

procedure TPasswordGenF.actGenPwdExecute(Sender: TObject);
var
  s: string;
begin
  s := GeneratePassword(udLength.Position);
  edtPassword.Text := s;
  lblCount.Caption := IntToStr(Length(edtPassword.Text));
end;

procedure TPasswordGenF.actGenPwdUpdate(Sender: TObject);
begin
  rbtDash.Enabled := cbxSep.Checked;
  rbtUnderscore.Enabled := cbxSep.Checked;
  edtSepNum.Enabled := cbxSep.Checked;
  udbSepNum.Enabled := cbxSep.Checked;
end;

procedure TPasswordGenF.Button1Click(Sender: TObject);
begin
//  ModalResult := mrOK;
//  Close;
end;

procedure TPasswordGenF.actCancelExecute(Sender: TObject);
begin
  edtPassword.Clear;
  Close;
end;

end.
