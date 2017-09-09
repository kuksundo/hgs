{ unit Registrations:

  This unit provides functionality for the good ol' Register box

  28-04-2002: Added HKLM *and/or* HKCU check

  08-11-2003 unprotected key and no checking of dates (avoid problems with limited users)

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit Registrations;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ShellAPI, ExtCtrls, ImgList, Registry, IniFiles, FileCtrl;

const

  cVendorLink = 'http://www.abc-view.com/abcbuy.html';
  cMailToInfo = 'mailto:support@abc-view.com';
  cMaxIncorrectRepeat = 4;

  cResultOK    = 0;
  cInvalidKey  = 1;
  cFraudDetect = 2;

  // How many starts do we allow the user to make before registering?
  cMaxAllowStarts = 20;

  // cProtectKey (decrypted) =
  // '\SOFTWARE\Microsoft\Cryptography\MachineKeys\TmpKeyCBA557B37D82D411A23E0060087B22A9'; -> Old
  // This is the encrypted string pointing to a secret location in the registry
  // We will put information in this section concerning registration codes & blacklist
  // It is made inrecognisable to prevent hackers from spotting it easily in exe
  cProtectKey = 'jcaZjo[nc|o62CBHF?O9yS\U[XR_Pa[nSF\`gjqjRn-)ke).b~=`abXZ^k^dsieykjl~qt1uw({}01>02C=';
  cUnprotectKey = '\Software\ABC-View\ABC-View Manager\Keys\';

  sNumbersOnly =
    'Please type in only digits (the numbers 0 through 9 on your'#13+
    'keyboard) and/or dashes (-) or dots (.)'#13+
    'The registration code is of form: XXXX-XXXX-XXXX-XXXX';
  sIncorrectLength =
    'The code you have typed has an incorrect number of digits.'#13+
    'The registration code is of form: XXXX-XXXX-XXXX-XXXX';
  sIncorrectKey =
    'The code you have provided is incorrect. Please make sure to type'#13+
    'in the exact registration code that was sent to you by the vendor.';
  sIncorrectRepeat =
    'The code you have provided is incorrect.'#13+
    'Please contact ABC-View to verify your registration key. You'#13+
    'can do this through email by clicking on the link below.';
  sKeyOK =
    'Thank you for registering this product. Your support helps us to keep'#13+
    'on developing products that you like and that you can use in future.'#13+
    'You will be kept informed of free updates through our e-mail service.'#13#13+
    'Please note that this copy is for strict personal use only. You are not'#13+
    'allowed to give the registration key to friends, family or others. All'#13+
    'abuse will be reported to the proper authorities.';
  sUpdateError =
    'Your user settings could not be updated!'#13#13+
    'Try to restart your computer, if the problem persists'#13+
    'please contact the customer support.';
  sFraudDetect =
    'Your account has been (temporarily) disabled because a large-scale'#13+
    'fraud has been detected with your registration code.'#13#13+
    'If you feel you should not get this message please contact our'#13+
    'customer support.';

  cBlackListCount = 6;
  cBlackList: array[0..cBlackListCount - 1] of integer =
    ( 0,             // Philip Lyons
      1, 2, 3,       // Dan Marbles the shithead
      524,           // Frederick, temporary
      542            // Andrew Bartle, temporary, 2732-8010-9636-3821
     );

type

  TRegDialog = class(TForm)
    GroupBox: TGroupBox;
    InfoLabel: TLabel;
    KeyEdit: TEdit;
    LinkLabel: TLabel;
    Label3: TLabel;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    BitBtn3: TBitBtn;
    ImageList: TImageList;
    Image: TImage;
    procedure LinkLabelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure KeyEditChange(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FRegistered:    boolean = False;
  FDoUpdateCheck: boolean = True;
  FMustRegister:  boolean = True;
  FStarts:        integer = 0;
  FRegSequence:   integer = -2; // This signals that it wasn't evaluated
  // If the user's registry contains the blacklist remark, this flag is set
  FBlackList: boolean = False;

// Procedure StartupCheck

// Use this procedure to check for the shareware status on startup,
// call it from Mainform.FormCreate
procedure StartupCheck(FIniFile: string);

// function CheckRegistrationKey:
// Checks registration key ARegKey
// Returns true if accepted, false if denied
// ASeqNum is the Sequence number of this key (if the key is correct), as
//   produced in the sequence by the key generator
function CheckRegistrationKey(ARegKey: string; var ASeqNum: integer): integer;

// function NumbersOnly:
// Utility function that strips all non-digit characters from AInput, and
// puts the result in AOutput. The function returns TRUE if there are only
// numbers or chars '-', '_', ' ', '=', '.' in AInput.
function NumbersOnly(AInput: string; var AOutput: string): boolean;

// function LatestRegUse will return the date when the registry was last updated
function LatestRegUpdate: double;

implementation

{$R *.DFM}

uses

  Main, Encrypt, RegCodes, GlobalVars;

var

  FRegistrationFinished: boolean = false;
  FIncorrectRepeat: integer = 0;

function NumbersOnly(AInput: string; var AOutput: string): boolean;
var
  i: integer;
begin
  Result:=true;
  AOutput:='';
  for i:=1 to length(AInput) do begin
    case AInput[i] of
    '0'..'9': AOutput:=AOutput+AInput[i];
    '-', '_', ' ', '=', '.':;
    else
      Result:=false;
    end;//case
  end;
end;

function CheckRegistrationKey(ARegKey: string; var ASeqNum: integer): integer;
// Check a registration key
// Returns true if accepted, false if denied
// ASeqNum is the Sequence number of this key (if the key is correct), as
//   produced in the sequence by the key generator
var
  i, j: integer;
  FBase:  array[0..crgMaxGroup-1] of integer;
  FCode: string[4];
  AValueN, AValue1, AValue2, AValue3: integer;
  Prev: char;
  Reg: TRegistry;
begin
  Result := cInvalidKey;

  ASeqNum:=-1; // Signals that it was evaluated, but not assigned

  // Final Hussle
  AValue1:=Ord(ARegkey[1])-Ord('0');
  AValue2:=Ord(ARegkey[2])-Ord('0');
  AValue3:=Ord(ARegkey[3])-Ord('0');
  for j:=4 to length(ARegkey) do begin
    case ARegkey[j] of
    '0'..'9': // A number
      begin
        // Formula bias footprint - how does that sound!
        AValueN:=AValue1 + 2*AValue2 + 3*AValue3 + 7;
        Prev:=ARegkey[j];

        // Substract AValueN from the new item ALine[j]
        while AValueN > 0 do dec(AValueN, 10);

        ARegkey[j]:=chr((((ord(ARegkey[j])-ord('0')-AValueN) mod 10)+ord('0')));

        // Slide through
        AValue1:=AValue2;
        AValue2:=AValue3;
        AValue3:=ord(Prev)-Ord('0');

      end;
    end;//case
  end;


  for i:=0 to crgMaxGroup-1 do begin

    // Get the partial code of the registration key
    FCode:=EncryptStr(copy(ARegKey, 1+i*4, 4));

    // Set the base on -1 to signal no solution state
    FBase[i]:=-1;

    for j:=0 to crgMaxBase-1 do
      if FCode = crgRegCodes[j, i] then FBase[i]:=j;

    if FBase[i]=-1 then exit; // No solution

  end;

  // Which sequence number?
  ASeqNum:=0;
  for i:=0 to crgMaxGroup-1 do begin
    ASeqNum:=ASeqNum * crgMaxBase;
    ASeqNum:=ASeqNum + FBase[crgMaxGroup-i-1];
  end;

  // OK, we have a valid number
  Result := cResultOK;

  // Does it belong to the black list?
  if FBlackList then
    // Installed newer that detected, now this old version knows :)
    Result := cFraudDetect;
  // Check this list
  for i := 0 to length(cBlackList) - 1  do
    if cBlackList[i] = ASeqNum then begin
      Result := cFraudDetect;

      // Signal the registry!
      Reg := TRegistry.Create;
      try
        // Our Registry safety hook
        Reg.Rootkey := HKEY_CURRENT_USER;
        if Reg.OpenKey(cUnProtectKey, True) then
          Reg.WriteString('PSBLK', EncryptStr(cVersionName));

      finally
        Reg.Free;
      end;

    end;

end;

procedure RegistrationCheck;
var
  ARegKey: string;
function FindRegistrationKey: boolean;
var
  Reg: TRegistry;
begin
  Result:=false;
  ARegKey:='';
  Reg:=TRegistry.Create;
  try
    // Our Registry safety hook
    Reg.Rootkey := HKEY_CURRENT_USER;
    if Reg.OpenKey(cUnProtectKey, True) then
      try
        // Read the key
        ARegKey := DecryptStr(Reg.ReadString('RK'));
        Result := length(ARegKey) > 0;
      except
      end;
  finally
    Reg.Free;
  end;
end;
begin

  // Default to shareware
  FRegistered := False;

  // Find Registration code
  if FindRegistrationKey then begin

    case CheckRegistrationKey(ARegKey, FRegSequence) of
    cResultOK:
      begin
        // We have a fine customer here!
        FMustRegister := False;
        FRegistered   := True;
      end;
    cFraudDetect:
      begin
        MessageDlg(sFraudDetect, mtError, [mbOK], 0);
        FMustRegister := True;
      end;
    end; //case
  end;
end;

// Procedure StartupCheck

procedure StartupCheck(FIniFile: string);
// Use this procedure to check for the shareware status on startup,
// call it from Mainform.FormCreate
var
  Ini: TIniFile;
  Reg: TRegistry;
  FDate: integer;
// How many INI starts?
procedure ReadIniStarts(var AStarts, ADate: integer);
begin
  // Assume allow+1
  AStarts := cMaxAllowStarts + 1;
  ADate := 0;
  if not FileExists(FIniFile) then
    AStarts := 0;
  // open INI
  Ini := TIniFile.Create(FIniFile);
  try
    // Read value
    AStarts := Ini.ReadInteger('history', 'starts', AStarts);
    ADate := Ini.ReadInteger('history', 'date', ADate);
  finally
    Ini.Free;
  end;
end;
// How many REG starts?
procedure ReadRegStarts(var AStarts, ADate: integer);
begin
  AStarts := cMaxAllowStarts + 1;
  ADate := 0;
  Reg := TRegistry.Create;
  try
    // Our Registry safety hook
    Reg.Rootkey := HKEY_CURRENT_USER;
    if Reg.OpenKey(cUnProtectKey, True) then begin

      // Do we have the identifier
      if Reg.ValueExists('PSKEYS') and  Reg.ValueExists('PSDAYS') then begin

        // Existing user
        try
          AStarts := cMaxAllowStarts - Reg.ReadInteger('PSKEYS');
          ADate := Reg.ReadInteger('PSDAYS')
        except
          AStarts := cMaxAllowStarts + 1;
        end;
        // Check blacklist
        if Reg.ValueExists('PSBLK') then
          // If the version writing the tag is higher, this is clearly a back-install
          FBlackList := DecryptStr(Reg.ReadString('PSBLK')) > cVersionName;

      end else

        // New user (presumably)
        AStarts := 0;

    end else begin
      // Unable to open any key!!
      MessageDlg(sUpdateError, mtWarning, [mbOK, mbHelp], 0);
      FMustRegister := true;
    end;

  finally
    Reg.Free;
  end;
end;
procedure WriteIniStarts;
begin
  Ini:=TIniFile.Create(FIniFile);
  try
    Ini.WriteInteger('history','starts', FStarts);
    Ini.WriteInteger('history','date', FDate);
  finally
    Ini.Free;
  end;
end;
procedure WriteRegStarts;
begin
  Reg:=TRegistry.Create;
  try
    // Our Registry safety hook
    Reg.Rootkey := HKEY_CURRENT_USER;
    if Reg.OpenKey(cUnProtectKey, True) then

      Reg.WriteInteger('PSKEYS', cMaxAllowStarts-FStarts);
      Reg.WriteInteger('PSDAYS', FDate);
  finally
    Reg.Free;
  end;
end;
// main
var
  FIniStarts, FRegStarts, FIniDate, FRegDate: integer;
  MustInc: boolean;
begin

  // Defaults
  FMustRegister := False;

  // Read the amount of past starts we had (2 methods)
  DebugLog('ReadStarts Start');
  ReadIniStarts(FIniStarts, FIniDate);
  ReadRegStarts(FRegStarts, FRegDate);
  DebugLog('ReadStarts Close');

  // Compare starts
  DebugLog('LatestUpdate Start');
  FStarts := FRegStarts;
  //Restore! FDate := trunc(LatestRegUpdate);
  FDate := trunc(Now);
  MustInc := False;
  if FIniStarts > FStarts then FStarts := FIniStarts;
  if FIniDate <> FDate then MustInc := True;
  if FRegDate <> FDate then MustInc := True;
  DebugLog('LatestUpdate Close');

  // Now we add a start if we have a different date
  if MustInc then
    inc(FStarts);
  FDate := trunc(Date);

  // Write the starts
  DebugLog('WriteStarts Start');
  WriteIniStarts;
  WriteRegStarts;
  DebugLog('WriteStarts Close');

  // Check registration
  RegistrationCheck;

  DebugLog('RegCheck Start');
  if not FRegistered then

    // Check starts
    if FStarts > cMaxAllowStarts then FMustRegister := true;

  DebugLog('RegCheck Close');
end;


procedure DoRegistration(ARegKey: string);
var
  Reg: TRegistry;
procedure WriteRegKey;
begin
  Reg:=TRegistry.Create;
  try
    // Our Registry safety hook
    Reg.Rootkey := HKEY_CURRENT_USER;
    if Reg.OpenKey(cUnProtectKey, True) then
      Reg.WriteString('RK', EncryptStr(ARegKey));
  finally
    Reg.Free;
  end;
end;
begin
  // Add the registration key to the registry
  WriteRegKey;

  // It is already checked and approved and will be rechecked everytime on startup
  // but we will recheck here for possible Blacklist entry
  RegistrationCheck;

end;

procedure TRegDialog.LinkLabelClick(Sender: TObject);
begin
  // link towards vendor's site
  if FIncorrectRepeat > cMaxIncorrectRepeat then
    ShellExecute(Handle,'open',pchar(cMailtoInfo),
    nil,nil,SW_SHOWNORMAL)
  else
    ShellExecute(Handle,'open',pchar(cVendorLink),
    nil,nil,SW_SHOWNORMAL);
end;

procedure TRegDialog.FormCreate(Sender: TObject);
begin
  ImageList.GetIcon(0, Image.Picture.Icon);
  LinkLabel.Hint := 'Surf to: ' + cVendorLink;
end;

procedure TRegDialog.KeyEditChange(Sender: TObject);
begin
  OKButton.Enabled := length(KeyEdit.Text)>0;
end;

procedure TRegDialog.OKButtonClick(Sender: TObject);
var
  SeqNo: integer;
  RegCode: string;
  CheckResult: integer;
label
  RegAccept;
begin

  if FRegistrationFinished then begin
    ModalResult:=mrOK;
    exit;
  end;

  // Check if we only have numeric input
  if NumbersOnly(KeyEdit.Text, RegCode)=false then begin
    ImageList.GetIcon(1, Image.Picture.Icon);
    InfoLabel.Caption := sNumbersOnly;
    KeyEdit.SelectAll;
    KeyEdit.SetFocus;
    exit;
  end;

  // Check code length
  if length(RegCode)<> 4*crgMaxGroup then begin
    ImageList.GetIcon(1, Image.Picture.Icon);
    InfoLabel.Caption := sIncorrectLength;
    KeyEdit.SelectAll;
    KeyEdit.SetFocus;
    exit;
  end;

  // Check actual registration
  CheckResult := CheckRegistrationKey(RegCode, SeqNo);
  if CheckResult <> cResultOK then begin
    ImageList.GetIcon(2, Image.Picture.Icon);
    inc(FIncorrectRepeat);
    if FIncorrectRepeat > cMaxIncorrectRepeat then begin
      InfoLabel.Caption := sIncorrectRepeat;
      LinkLabel.Caption:='Click here to contact ABC-View for support';
      LinkLabel.Hint:='Email to ABC-View';
    end else begin
      if CheckResult = cFraudDetect then begin
        InfoLabel.Caption := sFraudDetect;
        LinkLabel.Hide;
      end else
        InfoLabel.Caption := sIncorrectKey;
    end;
    KeyEdit.SelectAll;
    KeyEdit.Enabled:=false;
    Screen.Cursor:=crNoDrop;
    Application.ProcessMessages;
    sleep(2500);
    Screen.Cursor:=crDefault;
    KeyEdit.Enabled:=true;
    KeyEdit.SetFocus;
    exit;
  end;

  // Registration succeeded
  RegAccept:
  ImageList.GetIcon(3, Image.Picture.Icon);
  InfoLabel.Caption := sKeyOK;
  Caption:='Thank you for registering';
  GroupBox.Caption:='Registration Key correct!';
  KeyEdit.Hide;
  Label3.Hide;
  LinkLabel.Hide;
  CancelButton.Enabled:=false;
  DoRegistration(RegCode);

  FRegistrationFinished:=true;

end;

function LatestRegUpdate: double;
var
  NewDate: double;
  Res: integer;
  F: TSearchRec;
  Folder, AFile: string;
begin
  Result := Date;
  Folder := 'c:\windows\';
  if DirectoryExists(Folder) then begin
    // check for window's user.dat
    if FileExists(Folder + 'user.dat') then begin
      NewDate := FileDateToDateTime(FileAge(Folder + 'user.dat'));
      if NewDate > Result then Result := NewDate;
    end;
    // check for window's win.ini
    if FileExists(Folder + 'win.ini') then begin
      NewDate := FileDateToDateTime(FileAge(Folder + 'win.ini'));
      if NewDate > Result then Result := NewDate;
    end;
    // check for window's win386.swp
    if FileExists(Folder + 'win386.swp') then begin
      NewDate := FileDateToDateTime(FileAge(Folder + 'win386.swp'));
      if NewDate > Result then Result := NewDate;
    end;
  end else begin
    // check for pagefile.sys
    if FileExists('c:\pagefile.sys') then begin
      NewDate := FileDateToDateTime(FileAge('c:\pagefile.sys'));
      if NewDate > Result then Result := NewDate;
    end;
    Folder := 'c:\winnt\';
    if DirectoryExists(Folder) then begin
      // check for winnt win.ini
      if FileExists(Folder + 'win.ini') then begin
        NewDate := FileDateToDateTime(FileAge(Folder + 'win.ini'));
        if NewDate > Result then Result := NewDate;
      end;
    end;
    Folder := 'c:\winnt\profiles\';
    // Check for winnt profiles ntuser.dat
    if DirectoryExists(Folder) then begin
      Res := FindFirst(Folder + '*.*', faAnyFile, F);
      while Res = 0 do begin
        if ((F.Attr AND faDirectory) > 0) and
            (F.Name <> '.') and
            (F.Name <> '..') then begin
          AFile := Folder + F.Name + '\' + 'ntuser.dat';
          if FileExists(AFile) then begin
            NewDate := FileDateToDateTime(FileAge(AFile));
            if NewDate > Result then Result := NewDate;
          end;
        end;
        Res := FindNext(F);
      end;
      FindClose(F);
    end;
  end;
end;

end.
