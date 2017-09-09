unit FuzzyTextEncodeForms;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmEncode = class(TForm)
    edClientCode: TEdit;
    Label1: TLabel;
    btnCalculate: TButton;
    edRegKey: TEdit;
    Label2: TLabel;
    procedure btnCalculateClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEncode: TfrmEncode;

const

  cMagic: dword = $3E1F04DC; // Fuzzy text haxler for hardware code

implementation

uses
  BlockCiphers, HardwRegs;

{$R *.DFM}

procedure TfrmEncode.btnCalculateClick(Sender: TObject);
var
  Key, Res: TInitKey;
  Block: TCipherKey;
  Cipher: T64BitBlockCipher;
  ACode: string;
begin
  // This is the encoder
  // Key will be a random key
  randomize;
  Key[0] := random($10000);
  Key[1] := cpseudok1;
  Key[2] := cpseudok2;
  Key[3] := cpseudok3;

  // Check codes
  ACode := edClientCode.Text;
  if not CheckChars(ACode) then begin
    ShowMessage('Client code contains illegal characters');
    exit;
  end;
  if length(ACode) <> 12 then begin
    ShowMessage('Client code incorrect length');
    exit;
  end;
  //  Encrypt hkey1 and hkey2
  Block.HKey1 := StrToInt('$' + copy(ACode, 1, 8));
  Block.HKey2 := StrToInt('$' + copy(ACode, 9, 4));
  Block.Dummy := cMagic2;
  Cipher := TBlowFishCipher.Create(Key, 8);
  with Cipher do begin
    int64(Res) := Cipher.EncryptedBlock(int64(Block));
    edRegKey.Text :=
      IntToHex(Key[0], 4) + '-' +
      IntToHex(Res[0], 4) + '-' +
      IntToHex(Res[1], 4) + '-' +
      IntToHex(Res[2], 4) + '-' +
      IntToHex(Res[3], 4);
  end;
end;

end.
