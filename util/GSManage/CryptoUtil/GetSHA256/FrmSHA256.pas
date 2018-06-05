unit FrmSHA256;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, UnitCryptUtil,
  Vcl.ExtCtrls;

type
  TForm4 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    HashAlgoRG: TRadioGroup;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    function GetHashString: string;
    function CheckHash: Boolean;
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

procedure TForm4.Button1Click(Sender: TObject);
begin
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
