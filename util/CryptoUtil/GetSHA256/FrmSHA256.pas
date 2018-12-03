unit FrmSHA256;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, UnitCryptUtil,
  Vcl.ExtCtrls, SynCommons;

type
  TForm4 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    HashAlgoRG: TRadioGroup;
    Button3: TButton;
    Button4: TButton;
    IVAtBeginChcek: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    function GetHashString: string;
    function CheckHash: Boolean;
  public
    { Public declarations }
  end;

type
  TECCCommand = (
    ecHelp, ecNew, ecRekey, ecSign, ecVerify, ecSource, ecInfoPriv,
    ecChain, ecChainAll,
    ecCrypt, ecDecrypt, ecInfoCrypt,
    ecCheatInit, ecCheat);
var
  Form4: TForm4;

implementation

{$R *.dfm}

procedure TForm4.Button1Click(Sender: TObject);
var
  cmd: RawUTF8;
begin
//  cmd := 'Rekey';
//  ShowMessage(IntToStr(GetEnumNameValueTrimmed(TypeInfo(TECCCommand), Pointer(cmd), Length(cmd))));
//  Edit2.Text := GetSHA256HashStringFromIndy(Edit1.Text);
//  Edit2.Text := GetSHA256HashStringFromSyn(Edit1.Text);
//  Edit2.Text := GetHashStringFromBCrypt(Edit1.Text);
//  Edit2.Text := GetHashStringFromSCrypt(Edit1.Text);
  GetHashString;
end;

procedure TForm4.Button2Click(Sender: TObject);
begin
//  if CheckSHA256HashStringFromIndy(Edit1.Text,Edit2.Text) then
//  if CheckSHA256HashStringFromSyn(Edit1.Text,Edit2.Text) then
//  if CheckHashStringFromBCrypt(Edit1.Text,Edit2.Text) then
//  if CheckHashStringFromSCrypt(Edit1.Text,Edit2.Text) then
  if CheckHash then
    ShowMessage('Matched')
  else
    ShowMessage('Not Matched');
end;

procedure TForm4.Button3Click(Sender: TObject);
begin
  Edit2.Text := EncryptString_Syn(Edit1.Text, IVAtBeginChcek.Checked);
end;

procedure TForm4.Button4Click(Sender: TObject);
begin
  Edit1.Text := DecryptString_Syn(Edit2.Text, IVAtBeginChcek.Checked);
end;

function TForm4.CheckHash: Boolean;
begin
  case HashAlgoRG.ItemIndex of
    0: Result := CheckSHA256HashStringFromSyn(Edit1.Text,Edit2.Text);
    1: Result := CheckSHA256HashStringFromIndy(Edit1.Text,Edit2.Text);
    2: Result := CheckMD5HashStringFromIndy(Edit1.Text,Edit2.Text);
    3: Result := CheckHashStringFromBCrypt(Edit1.Text,Edit2.Text);
    4: Result := CheckHashStringFromSCrypt(Edit1.Text,Edit2.Text);
  end;
end;

function TForm4.GetHashString: string;
begin
  case HashAlgoRG.ItemIndex of
    0: Edit2.Text := GetSHA256HashStringFromSyn(Edit1.Text);
    1: Edit2.Text := GetSHA256HashStringFromIndy(Edit1.Text);
    2: Edit2.Text := GetMD5HashStringFromIndy(Edit1.Text);
    3: Edit2.Text := GetHashStringFromBCrypt(Edit1.Text);
    4: Edit2.Text := GetHashStringFromSCrypt(Edit1.Text);
  end;
end;

end.
