unit w_dzInputDialog;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls;

type
  Tf_dzInputDialog = class(TForm)
    l_Query: TLabel;
    ed_Input: TEdit;
    b_Ok: TButton;
    b_Cancel: TButton;
    procedure ed_InputChange(Sender: TObject);
  public
    type
      TOnCheckEvent = procedure(_Sender: TObject; const _Value: string; var _OK: Boolean) of object;
  private
    FOnCheck: TOnCheckEvent;
    FMin: Integer;
    FMax: Integer;
    function doOnCheck(const _Value: string): Boolean;
    procedure CheckInteger(_Sender: TObject; const _Value: string; var _OK: Boolean);
  public
    class function InputQuery(const _Caption: string; const _Prompt: string; var _Value: string): Boolean;
    class function InputBox(const _Caption: string; const _Prompt: string; const _Default: string): string;
    class function Execute(_Owner: TWinControl; const _Caption: string; const _Prompt: string; var _Value: string): Boolean;
    class procedure Display(_Owner: TWinControl; const _Caption, _Prompt, _Value: string);
    class function InputQueryChecked(_Owner: TWinControl; const _Caption, _Prompt: string;
      _CheckCallback: TOnCheckEvent; var _Value: string): Boolean;
    class function InputInteger(_Owner: TWinControl; const _Caption, _Prompt: string;
      _Min, _Max: Integer; var _Value: Integer): Boolean;
  end;

implementation

{$R *.dfm}

uses
  u_dzVclUtils;

{ Tf_dzInputDialog }

procedure Tf_dzInputDialog.CheckInteger(_Sender: TObject; const _Value: string; var _OK: Boolean);
var
  IntValue: Integer;
begin
  _OK := TryStrToInt(_Value, IntValue);
  if _OK then
    _OK := (IntValue >= FMin) and (IntValue <= FMax);
end;

class procedure Tf_dzInputDialog.Display(_Owner: TWinControl; const _Caption, _Prompt, _Value: string);
var
  frm: Tf_dzInputDialog;
begin
  frm := Tf_dzInputDialog.Create(_Owner);
  try
    TForm_CenterOn(frm, _Owner);
    frm.Caption := _Caption;
    frm.l_Query.Caption := _Prompt;
    frm.ed_Input.Text := _Value;
    frm.b_Ok.Visible := False;
    frm.b_Cancel.Caption := 'Close';
    frm.b_Cancel.Default := True;
    frm.ShowModal;
  finally
    FreeAndNil(frm);
  end;
end;

function Tf_dzInputDialog.doOnCheck(const _Value: string): Boolean;
begin
  Result := True;
  if Assigned(FOnCheck) then
    FOnCheck(Self, _Value, Result);
end;

procedure Tf_dzInputDialog.ed_InputChange(Sender: TObject);
begin
  if doOnCheck(ed_Input.Text) then begin
    ed_Input.Color := clWindow;
    b_Ok.Enabled := True;
  end else begin
    ed_Input.Color := clYellow;
    b_Ok.Enabled := False;
  end;
end;

class function Tf_dzInputDialog.Execute(_Owner: TWinControl; const _Caption,
  _Prompt: string; var _Value: string): Boolean;
var
  frm: Tf_dzInputDialog;
begin
  frm := Tf_dzInputDialog.Create(_Owner);
  try
    TForm_CenterOn(frm, _Owner);
    frm.Caption := _Caption;
    frm.l_Query.Caption := _Prompt;
    frm.ed_Input.Text := _Value;
    Result := (frm.ShowModal = mrOk);
    if Result then
      _Value := frm.ed_Input.Text;
  finally
    FreeAndNil(frm);
  end;
end;

class function Tf_dzInputDialog.InputBox(const _Caption, _Prompt, _Default: string): string;
begin
  Result := _Default;
  if not InputQuery(_Caption, _Prompt, Result) then
    Result := _Default;
end;

class function Tf_dzInputDialog.InputInteger(_Owner: TWinControl; const _Caption, _Prompt: string;
  _Min, _Max: Integer; var _Value: Integer): Boolean;
var
  frm: Tf_dzInputDialog;
begin
  frm := Tf_dzInputDialog.Create(_Owner);
  try
    TForm_CenterOn(frm, _Owner);
    frm.Caption := _Caption;
    frm.l_Query.Caption := _Prompt;
    frm.ed_Input.Text := IntToStr(_Value);
    frm.FMin := _Min;
    frm.FMax := _Max;
    frm.FOnCheck := frm.CheckInteger;
    Result := (frm.ShowModal = mrOk);
    if Result then
      _Value := StrToInt(frm.ed_Input.Text);
  finally
    FreeAndNil(frm);
  end;
end;

class function Tf_dzInputDialog.InputQuery(const _Caption, _Prompt: string; var _Value: string): Boolean;
begin
  Result := Execute(nil, _Caption, _Prompt, _Value);
end;

class function Tf_dzInputDialog.InputQueryChecked(_Owner: TWinControl; const _Caption, _Prompt: string;
  _CheckCallback: TOnCheckEvent; var _Value: string): Boolean;
var
  frm: Tf_dzInputDialog;
begin
  frm := Tf_dzInputDialog.Create(_Owner);
  try
    TForm_CenterOn(frm, _Owner);
    frm.Caption := _Caption;
    frm.l_Query.Caption := _Prompt;
    frm.ed_Input.Text := _Value;
    frm.FOnCheck := _CheckCallback;
    Result := (frm.ShowModal = mrOk);
    if Result then
      _Value := frm.ed_Input.Text;
  finally
    FreeAndNil(frm);
  end;
end;

end.
