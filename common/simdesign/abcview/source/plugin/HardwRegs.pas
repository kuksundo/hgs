unit HardwRegs;
{ unit HardwRegs

  Hardware bound registration for ABC-View's plugins

  Use e.g. the FuzzyTextEncode.exe to create registration codes

  Copyright (c) 2002 Nils Haeck
}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls;

type
  TfrmAuthorise = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    lblClientCode: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lblStatus: TLabel;
    edRegName: TEdit;
    btnCalc: TButton;
    edRegCode: TEdit;
    btnRegister: TButton;
    BitBtn2: TBitBtn;
    BitBtn1: TBitBtn;
    procedure btnCalcClick(Sender: TObject);
    procedure btnRegisterClick(Sender: TObject);
  private
    FAuth: boolean;
    FMagic: dword;
    FRegName: string;
    FRegKey: string;
    FHKey1: dword;
    FHKey2: word;
    procedure UpdateControlVisibility(AVisible: boolean);
  public
    { Public declarations }
  end;

var
  frmAuthorise: TfrmAuthorise;

function AcceptRegKey(AMagic: dword; ARegName, ARegKey: string): boolean;
function CheckChars(var Code: string): boolean;
function DetermineHKeys(FMagic: dword; FRegName: string; var HKey1: dword; var HKey2: word): boolean;
procedure DoAuthDialog(AMagic: dword; var ARegName, ARegKey: string);
function LetterCount(ALine: string): word;

const

  cPseudok1: word = $4ED0;     // used for pseudo random key
  cPseudok2: word = $4751;     // used for pseudo random key
  cPseudok3: word = $973C;     // used for pseudo random key
  cMagic2:   word = $66BC;     // used as fill for encode

type

  TInitKey = array[0..3] of word;
  TCipherKey = packed record
    HKey1: dword;
    HKey2: word;
    Dummy: word;
  end;

implementation

{$R *.DFM}

uses
  DiskInfo;{, BlockCiphers;}

function AcceptRegKey(AMagic: dword; ARegName, ARegKey: string): boolean;
var
  HKey1: dword;
  HKey2: word;
  Key, Res: TInitKey;
//  Cipher: T64BitBlockCipher;
  Block: TCipherKey;
begin
{  Result := False;
  CheckChars(ARegKey);
  if length(ARegKey) <> 20 then exit;

  // First get the hardware key
  if not DetermineHKeys(AMagic, ARegName, HKey1, HKey2) then exit;

  // Now we decode
  Key[0] := StrToInt('$' + Copy(ARegKey, 1, 4));
  Key[1] := cpseudok1;
  Key[2] := cpseudok2;
  Key[3] := cpseudok3;
  Cipher := TBlowFishCipher.Create(Key, 8);
  Res[0] := StrToInt('$' + Copy(ARegKey,  5, 4));
  Res[1] := StrToInt('$' + Copy(ARegKey,  9, 4));
  Res[2] := StrToInt('$' + Copy(ARegKey, 13, 4));
  Res[3] := StrToInt('$' + Copy(ARegKey, 17, 4));
  with Cipher do
    int64(Block) := Cipher.DecryptedBlock(int64(Res));

  // Now we compare
  Result := (Block.HKey1 = HKey1) and (Block.HKey2 = HKey2);}
  Result := True;

end;

function CheckChars(var Code: string): boolean;
var
  i: integer;
const
  AllowChars: set of char = ['0'..'9', 'A'..'Z'];
  ValidChars: set of char = ['0'..'9', 'A'..'F'];
begin
  Result := True;
  i := 1;
  while i <= length(Code) do begin
    // letter O versus number 0
    if UpCase(Code[i]) = 'O' then Code[i] := '0';
    // l, i are often 1
    if UpCase(Code[i]) = 'L' then Code[i] := '1';
    if UpCase(Code[i]) = 'I' then Code[i] := '1';
    // S can be 5
    if UpCase(Code[i]) = 'S' then Code[i] := '5';
    if not (UpCase(Code[i]) in AllowChars) then begin
      Delete(Code, i, 1)
    end else begin
      if UpCase(Code[i]) in ValidChars then
        inc(i)
      else begin
        Result := False;
        exit;
      end;
    end;
  end;
end;

function DetermineHKeys(FMagic: dword; FRegName: string; var HKey1: dword; var HKey2: word): boolean;
var
  DInfo: TODVolumeInformation;
begin
  // Get hardware key
  if GetVolumeInformation('C', DInfo) then
  begin
    // Hardware key
    HKey1 := DInfo.VolumeSerialNumber xor FMagic;
    // HKey2 - this is a result of the letter count xor'ed with $F0F0F0
    HKey2 := LetterCount(FRegName) xor $F0F0F0;
  end else
    Result := False;
end;

procedure DoAuthDialog(AMagic: dword; var ARegName, ARegKey: string);
begin
  Application.CreateForm(TfrmAuthorise, frmAuthorise);
  try
    with frmAuthorise do begin
      FMagic := AMagic;
      edRegName.Text := ARegName;
      // Show the form now
      if ShowModal = mrOK then begin
        //
        ARegName := edRegName.Text;
        if FAuth then begin
          ARegKey := edRegCode.Text;
        end;
      end;
    end;
  finally
    frmAuthorise.Release;
  end;
end;

function LetterCount(ALine: string): word;
// Simple routine to determine a word blueprint of a string
// this routine detects switched letters and is insensitive
// to case differences
var
  i: integer;
  AChar: char;
begin
  Result := 0;
  for i := 1 to Length(ALine) do begin
    AChar := Upcase(ALine[i]);
    if AChar in ['A'..'Z'] then
      Result := Result + i * ord(AChar);
  end;
end;

{ TfrmAuthorise }

procedure TfrmAuthorise.UpdateControlVisibility(AVisible: boolean);
begin
  Label2.Visible := AVisible;
  lblClientCode.Visible := AVisible;
  Label3.Visible := AVisible;
  Label4.Visible := AVisible;
  edRegCode.Visible := AVisible;
  btnRegister.Visible := AVisible;
end;

procedure TfrmAuthorise.btnCalcClick(Sender: TObject);
// Use registration name and hardware info to construct unlock key
var
  ACursor: TCursor;
begin
  FRegName := edRegName.Text;
  FHKey2 := LetterCount(FRegName);
  if (length(FRegName) < 2) or (FHKey2 = 0) then begin
    ShowMessage('Please enter a valid name first');
    exit;
  end;
  ACursor := Screen.Cursor;
  Screen.Cursor := crHourglass;
  try
    if DetermineHKeys(FMagic, FRegName, FHKey1, FHKey2) then begin
      sleep(1500);
      // Display result
      lblClientCode.Caption :=
        IntToHex((FHKey1 shr 16   ), 4) + '-' +
        IntToHex((FHKey1 and $FFFF), 4) + '-' +
        IntToHex((FHKey2), 4);
    end;
    // Display controls
    UpdateControlVisibility(True);
  finally
    Screen.Cursor := ACursor;
  end;
end;

procedure TfrmAuthorise.btnRegisterClick(Sender: TObject);
// Here we will compare the HKeys with what we get from the decoded block cipher
var
  ACursor: TCursor;
begin
  // Now we validate the input!
  FRegKey := edRegCode.Text;
  FAuth := false;
  // mimick delay
  ACursor := Screen.Cursor;
  Screen.Cursor := crHourglass;
  sleep(1500);
  Screen.Cursor := ACursor;
  if not CheckChars(FRegKey) then begin
    ShowMessage('There is a typing error in this key');
    exit;
  end;
  if length(FRegKey)<>20 then begin
    ShowMessage('The key does not contain the correct number of characters');
    exit;
  end;
  if AcceptRegKey(FMagic, FRegName, FRegKey) then begin
    ShowMessage(
      'Thank you for registering!'#13#13 +
      'This plugin is now authorised.');
    lblStatus.Caption := 'This plugin is authorised';
    FAuth := True;
  end else begin
    ShowMessage(
      'The registration code is not correct.'#13#13 +
      'Please check for typing errors.');
    lblStatus.Caption := 'This plugin not authorised';
  end;
end;

end.
