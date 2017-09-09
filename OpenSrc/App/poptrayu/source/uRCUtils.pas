unit uRCUtils;

{-------------------------------------------------------------------------------
RC Utilities Unit
Copyright © 2001-2005  Renier Crause
All Rights Reserved.
-------------------------------------------------------------------------------}

interface

uses
  Windows, SysUtils, Graphics, Forms, Buttons, StdCtrls, Controls, Types,
  Classes, Dialogs, TypInfo, ActnCtrls, CommCtrl, ComCtrls, System.UITypes,
  AnsiStrings, System.Character;

type
  TKeyboardLight = (klNumLock,klCapsLock,klScrollLock);

// files
function ExecuteFile(const FileName, Params, DefaultDir: string; ShowCmd: Integer): THandle;
procedure SplitExeParams(Cmd : string; var ExeName,Param : string);
function GetShellImage(FileName : string; Open: Boolean = False): Integer;
function TempPath: string;
function TempFileName(FileName : string) : string;

// strings
function CheckWildcard(text,subtext : string) : boolean;
function StrBefore(str,substr : string) : string;
function StrAfter(str,substr : string) : string;
function HexEncodeSpecialChars(str : string; encodeLineBreaks: boolean) : string;
function SanitizeFileName(unsanitizedFileName : string) : string;
function RemoveBlankLines(st : string) : string;
function LoCase(ch : char) : char;

// misc
procedure PlayWav(FileName : TFileName);
procedure GetBitmapFromFileIcon(FileName : TFileName; bmp : TBitmap; SplitParams : boolean = False);
function ExpandEnv(st : string) : string;
procedure ShowMemo(ACaption,AMsg : string; AWidth : integer = 400; AHeight : integer = 300);
function InArray(arr : array of integer; item : integer) : boolean;
procedure DeleteFromArray(var arr : array of integer; item : integer);
function ExpandWidth(st : string; width : integer) : string;
function ReduceWidth(st : string; width : integer) : string;
function ForceWidth(st : string; width : integer) : string;
function WindowsVersion : string;
function WindowAt(Form : TForm; Left,Top : integer) : boolean;
function IsWinXP : boolean;
function IsWinVista : boolean;
procedure SwapOutMemory;
procedure EnableControl(Edit : TWinControl; Enabled : boolean);

// show message
procedure Alert(st : string); overload;
procedure Alert(int : integer); overload;

// encryption
function BorlandEncryptClassic(const S: String; Key: Word): String;
function BorlandDecryptClassic(const S: String; Key: Word): String;
function BorlandEncryptWide(const S: String; Key: Word): String;
function BorlandDecryptWide(const S: String; Key: Word): String;
function Encrypt(const password : string) : string;
function Decrypt(password : string) : string;

//wininet
function InternetGetConnectedState(var lpdwFlags: DWORD; dwReserved: DWORD): BOOL; stdcall;
function IsConnectedToInternet : boolean;

// html help
function HtmlHelp(Caller : HWND; FileName : string; Command : UINT; Data : DWORD) : HWND;

// MAPI
function MAPISendFile(h : HWND; FileNames : array of string) : cardinal;
function MAPISendMessage(h : HWND; const ToAddress,Subject,Body : string) : boolean;

// uxTheme
{function LoadThemeLib: Boolean;
var
  SetWindowTheme: function(hwnd: HWND; pszSubAppName: LPCWSTR; pszSubIdList: LPCWSTR): HRESULT; stdcall;
  IsThemeActive: function: BOOL; stdcall;
  IsAppThemed: function: BOOL; stdcall;}

// colors
procedure GetRGB(col : TColor; var r,g,b : integer);
procedure RecolorBitmap(bmp : TBitmap; col : TColor);

// keyboard lights
procedure SetKeyboardLight(Light : TKeyboardLight; OnOff : boolean);
function GetKeyboardLight(Light : TKeyboardLight) : boolean;
procedure ToggleKeyboardLight(Light : TKeyboardLight);

// arrays
function IndexInArray(arr : array of string; value : string) : integer;

// command-line parameters
function ParamSwitch(st : string) : boolean;
function ParamSwitchIndex(st : string; start : integer = 0) : integer;
function ParamNonSwitch(index : integer) : string;
function ParamSwitchValue(index : integer) : string;

// visual
procedure AutoSizeCheckBox(chkBox : TCheckBox); overload;
procedure AutoSizeCheckBox(chkBox : TRadioButton); overload;
procedure AutoSizeAllCheckBox(Control : TWinControl);

// misc. from uMain
function NumOnly(st : string) : integer;
function CompareInt(st1,st2 : string) : integer;
function CompareDateRC(st1,st2 : string) : integer;
function StripSubjectPrefix(const st : string) : string;
function StringToColorDef(st : string; DefColor : TColor) : TColor;
function StringToColorDef2(st : string; DefColor : TColor) : TColor;
function ColorToString2(Color : TColor) : string;
function DarkColor(col : TColor) : Boolean;
function MixColors(col1,col2 : TColor) : TColor;
procedure ClearImpairedCode(var str : string);
procedure SetColumnImage(lv : TListView; ColumnIndex,ImageIndex : integer; textRightAligned : boolean = false);
procedure ExecuteAccelAction(ToolBar : TActionToolbar; Key : word);

function GetAppVersionStr: string;

procedure DeleteToRecycleBin(const fileameWithPath : String; const ParentWindow: HWND = 0);

const
  HH_DISPLAY_TOPIC = $0000;
  HH_DISPLAY_TOC   = $0001;
  HH_DISPLAY_INDEX = $0002;

implementation

uses ShellAPI, Mapi, StrUtils, uTranslate, IdCoderMIME, IdGlobal;

const
  INTERNET_CONNECTION_MODEM           = $01;
  INTERNET_CONNECTION_LAN             = $02;
  INTERNET_CONNECTION_PROXY           = $04;
  INTERNET_CONNECTION_MODEM_BUSY      = $08; // no longer used
  INTERNET_RAS_INSTALLED              = $10;
  INTERNET_CONNECTION_OFFLINE         = $20;
  INTERNET_CONNECTION_CONFIGURED      = $40;


//-------------------------------------------------------------------- files ---

function ExecuteFile(const FileName, Params, DefaultDir: string; ShowCmd: Integer): THandle;
var
  f : PChar;
begin
  f := pchar(FileName);
  Result := ShellExecute(0, nil, f, PChar(Params), PChar(DefaultDir), ShowCmd);
end;

procedure SplitExeParams(Cmd : string; var ExeName,Param : string);
////////////////////////////////////////////////////////////////////////////////
// Split the EXE name and Params from a string
var
  i : integer;
begin
  i := Pos('.EXE',UpperCase(Cmd));              //  BG:changed 11.13.2002
  if i = 0 then
  begin
    ExeName := Cmd;
    Param := '';
  end
  else begin
    ExeName := Copy(Cmd,1,i+3);
    Param := Trim(Copy(Cmd,i+5,Length(Cmd)-i-4));
    ExeName := AnsiReplaceStr(ExeName,'"','');
  end;
end;

function GetShellImage(FileName : string; Open: Boolean = False): Integer;
////////////////////////////////////////////////////////////////////////////////
// Get Icon for a File
var
  FileInfo: TSHFileInfo;
  Flags: Integer;
begin
  FillChar(FileInfo, SizeOf(FileInfo), #0);
  Flags := SHGFI_SYSICONINDEX or SHGFI_ICON;
  if Open then Flags := Flags or SHGFI_OPENICON;
  Flags := Flags or SHGFI_SMALLICON;
  SHGetFileInfo(PChar(FileName),
                0,
                FileInfo,
                SizeOf(FileInfo),
                Flags);
  Result := FileInfo.iIcon;
end;

function TempPath: string;
////////////////////////////////////////////////////////////////////////////////
// Temp directory
var
	i: integer;
begin
  SetLength(Result, MAX_PATH);
	i := GetTempPath(Length(Result), PChar(Result));
	SetLength(Result, i);
  if not IsPathDelimiter(Result, Length(Result)) then
    Result := Result + PathDelim;
end;

function TempFileName(FileName : string) : string;
var
  Temp,ext : string;
  i : integer;
begin
  Temp := TempPath;
  Result := FileName;
  i := 0;
  while FileExists(Temp+Result) do
  begin
    Inc(i);
    ext := ExtractFileExt(FileName);
    Result := Copy(FileName,1,Length(FileName)-Length(ext)) + IntToStr(i) + ext;
  end;
  Result := Temp + Result;
end;

//------------------------------------------------------------------ strings ---

function CheckWildcard(text,subtext : string) : boolean;
////////////////////////////////////////////////////////////////////////////////
// Compare strings with *,? wildcards (ignore case)
begin
  // loop trough both strings deleting first chars as they match
  while (text <> '') and (subtext <> '') do
  begin
    case subtext[1] of
      '?' : begin
              Delete(text,1,1);
              Delete(subtext,1,1);
            end;
      '*' : begin
              Delete(subtext,1,1);
              while (text <> '') and not(CheckWildCard(text,subtext)) do
                Delete(text,1,1);
            end;
    else
      if UpCase(text[1]) = UpCase(subtext[1]) then
      begin
        Delete(text,1,1);
        Delete(subtext,1,1);
      end
      else begin
        Result := false;
        Exit;
      end;
    end;
  end;
  // remove any remaining *'s
  subtext := AnsiReplaceStr(subtext,'*','');
  // string compare if both satisfied
  Result := (text = '') and (subtext = '');
end;

function StrBefore(str,substr : string) : string;
var
  i : integer;
begin
  Result := '';
  for i := 1 to length(str) do
  begin
    if copy(str,i,length(substr)) = substr then
      break;
    Result := Result + str[i];
  end;
end;

function StrAfter(str,substr : string) : string;
var
  i : integer;
begin
  Result := '';
  if pos(substr,str) = 0 then Exit;
  for i := pos(substr,str)+length(substr) to length(str) do
  begin
    Result := Result + str[i];
  end;
end;

// Hex encodes special characters (for sending emails by MAILTO links)
function HexEncodeSpecialChars(str : string; encodeLineBreaks: boolean) : string;
var
  i : integer;
begin
  Result := '';

  for i := 1 to length(str) do
  begin
    case str[i] of
    ' ','&','%','=','?','"':
      Result := Result + '%' + IntToHex(Ord(str[i]),2);
    #13,#10:
      if (encodeLineBreaks) then
         Result := Result + '%' + IntToHex(Ord(str[i]),2)
      else
         Result := Result + str[i];
    else
      Result := Result + str[i];
    end;
  end;
end;

// Eliminates invalid characters from a filename
function SanitizeFileName(unsanitizedFileName : string) : string;
const
  invalidChars = [ '"', //double quote
                                 '/', //forward slash
                                 '*', //wildcard
                                 '\', //backslash
                                 '<', //angle bracket1
                                 '>', //angle bracket2
                                 '|', //vertical bar
                                 ':', //colon
                                 '?'];//questionmark
  replacementChar : char = ' ';
var
  i : integer;
begin
  Result := '';
  for i := 1 to length(unsanitizedFileName) do
  begin
    // CharInSet will fail for characters outside of ANSI range, but none of
    // the characters in our search set are non-ansi so this is safe.
    if CharInSet(unsanitizedFileName[i], invalidChars) then
      Result := Result + replacementChar
    else
      Result := Result + unsanitizedFileName[i];
  end;

  //Result := Trim(Result);
end;

function RemoveBlankLines(st : string) : string;
var
  i : integer;
begin
  // CRLF CRLF
  i := Pos(#13#10#13#10,st);
  while i <> 0 do
  begin
    Delete(st,i,2);
    i := Pos(#13#10#13#10,st);
  end;
  // CRCR
  i := Pos(#13#13,st);
  while i <> 0 do
  begin
    Delete(st,i,1);
    i := Pos(#13#13,st);
  end;
  // LFLF
  i := Pos(#10#10,st);
  while i <> 0 do
  begin
    Delete(st,i,1);
    i := Pos(#10#10,st);
  end;
  Result := st;
end;

function LoCase(ch : char) : char;
asm
   CMP     AL,'A'
   JB      @@exit
   CMP     AL,'Z'
   JA      @@exit
   ADD     AL,'a' - 'A'
@@exit:
end;

//--------------------------------------------------------------------- misc ---

function PlaySound(pszSound: PChar; hmod: HMODULE; fdwSound: DWORD): BOOL; stdcall; external 'winmm.dll' name 'PlaySoundW';

procedure PlayWav(FileName : TFileName);
const
  SND_ASYNC           = $00000001; { play asynchronously }
  SND_FILENAME        = $00020000; { indicates first param to PlaySound is file name }
  SND_SYSTEM          = $00200000; { play at system notification volume in Vista+ }
  SND_SENTRY          = $00080000; { display visual cue for sound if accessibility mode set in Vista+ }
  //SND_NODEFAULT       = $00000002; { if sound is not found, do not play windows default sound }
begin
  if FileName <> '' then
    if IsWinVista then
      PlaySound(pchar(FileName),0,SND_FILENAME or SND_ASYNC or SND_SYSTEM or SND_SENTRY)
    else
      PlaySound(pchar(FileName),0,SND_FILENAME or SND_ASYNC);
end;

procedure GetBitmapFromFileIcon(FileName : TFileName; bmp : TBitmap; SplitParams : boolean = False);
var
  FileInfo: TSHFileInfo;
  tmpIcon : TIcon;
  ExeName,Params : string;
begin
  if SplitParams then
    SplitExeParams(FileName,ExeName,Params)
  else
    ExeName := FileName;
  SHGetFileInfo(pChar(ExeName),0,FileInfo,SizeOf(FileInfo),SHGFI_ICON or SHGFI_SMALLICON);

  tmpIcon := TIcon.Create;
  try
    tmpIcon.Handle := FileInfo.hIcon;

    bmp.Width := 16;
    bmp.Height := 16;
    bmp.Transparent := True;                            //  BG:added 09.11.2002
    bmp.TransparentColor := clBtnFace;
    bmp.Canvas.Brush.Color := clBtnFace;
    bmp.Canvas.FillRect(bmp.Canvas.ClipRect);
    bmp.Canvas.Draw(0,0,tmpIcon);

  finally
    tmpIcon.Free;
  end;
end;

function ExpandEnv(st : string) : string;
var
  tmp : String;
begin
  SetLength(tmp,255);
  ExpandEnvironmentStrings(PChar(st),PChar(tmp),255);
  SetLength(tmp,Pos(#0,tmp));
  Result := tmp;
end;

procedure ShowMemo(ACaption,AMsg : string; AWidth : integer = 400; AHeight : integer = 300);
var
  frm : TForm;
begin
  frm := TForm.CreateNew(Application);
  with frm do
  begin
    Caption := ACaption;
    Width := AWidth;
    Height := AHeight;
    Position := poScreenCenter;
    with TBitBtn.Create(frm) do
    begin
      Parent := frm;
      Kind := bkOK;
      Left := frm.ClientWidth div 2 - Width div 2;
      Top := frm.ClientHeight - Height - 5;
      Anchors := [akLeft,akRight,akBottom];
      Constraints.MinWidth := 50;
    end;
    with TMemo.Create(frm) do
    begin
      Parent := frm;
      Font.Name := 'Courier New';
      Left := 10;
      Top := 10;
      Width := frm.ClientWidth-20;
      Height := frm.ClientHeight-50;
      ScrollBars := ssVertical;
      Anchors := [akLeft,akTop,akRight,akBottom];
      WordWrap := True;
      ReadOnly := True;
      Lines.Text := AMsg;
    end;
    ShowModal;
  end;
end;

function InArray(arr : array of integer; item : integer) : boolean;
var
  i : integer;
begin
  Result := False;
  for i := low(arr) to high(arr) do
  begin
    if item = arr[i] then
    begin
      Result := True;
      Break;
    end;
  end;
end;

procedure DeleteFromArray(var arr : array of integer; item : integer);
var
  i,j : integer;
begin
  for i := low(arr) to high(arr) do
  begin
    if item = arr[i] then
    begin
      for j := i+1 to high(arr) do
        arr[j-1] := arr[j];
      Break;
    end;
  end;
end;

function ExpandWidth(st : string; width : integer) : string;
var
  canvas : TCanvas;
begin
  //canvas := Application.MainForm.Canvas;
  canvas := TBitmap.Create.Canvas;
  try
    canvas.Font.Name := 'MS Sans Serif';
    canvas.Font.Size := 8;
    while canvas.TextWidth(st) < width do
      st := st + ' ';
    Result := st;
  finally
    canvas.Free;
  end;
end;

function ReduceWidth(st : string; width : integer) : string;
var
  canvas : TCanvas;
begin
  canvas := TBitmap.Create.Canvas;
  try
    canvas.Font.Name := 'MS Sans Serif';
    canvas.Font.Size := 8;
    while canvas.TextWidth(st) > width do
      Delete(st,length(st),1);
    Result := st;
  finally
    canvas.Free;
  end;
end;

function ForceWidth(st : string; width : integer) : string;
var
  canvas : TCanvas;
begin
  canvas := TBitmap.Create.Canvas;
  try
    canvas.Font.Name := 'MS Sans Serif';
    canvas.Font.Size := 8;
    if canvas.TextWidth(st) < width then
    begin
      // make it wider
      while canvas.TextWidth(st) < width do
        st := st + ' ';
    end
    else begin
      // make it narrower
      while canvas.TextWidth(st) > width do
        Delete(st,length(st),1);
    end;
    Result := st;
  finally
    canvas.Free;
  end;
end;


function WindowsVersion : string;
var
  strVersion    : String;
  strAdditional : String;
  strBuild      : String;
begin
  case Win32Platform of
    VER_PLATFORM_WIN32_NT:
      begin
        case Win32MajorVersion of
          3 : strVersion:='NT 3.51';
          4 : strVersion:='NT 4.0';
          5 : if Win32MinorVersion=0 then
                strVersion:='2000'
              else
                strVersion:='XP';
        end;
        strAdditional:=Win32CSDVersion;
        strBuild:=Format('(%d.%d.%d)',
                         [Win32MajorVersion,
                          Win32MinorVersion,
                          Win32BuildNumber]);
      end;

    VER_PLATFORM_WIN32_WINDOWS:
      begin
        case Win32MinorVersion of
          0   : begin
                  strVersion:='95';
                end;
          10  : begin
                  strVersion:='98';
                end;
          90  : strVersion:='Me';
        end;
        if Win32CSDVersion=' A' then
          strAdditional:='SE';
        if Win32CSDVersion=' C' then
          strAdditional:='OSR2';
        strBuild:=Format('(%d.%d.%d)',
                         [Win32MajorVersion,
                          Win32MinorVersion,
                          Win32BuildNumber]);
      end;

    VER_PLATFORM_WIN32s:
      begin
        strVersion:='3.1x (Win32s)';
      end;
  end;
  result := 'Windows '+strVersion + ' ' + strAdditional + ' '+strBuild;
end;

function WindowAt(Form : TForm; Left,Top : integer) : boolean;
////////////////////////////////////////////////////////////////////////////////
// See if there is a window at the specified location
var
  i : integer;
begin
  Result := False;
  for i := 0 to Application.ComponentCount-1 do
  begin
    if Application.Components[i] is Form.ClassType then
    begin
      if (Application.Components[i] <> Form) and
         ((Application.Components[i] as TForm).Left = Left) and
         ((Application.Components[i] as TForm).Top = Top) then
      begin
        Result := True;
        Break;
      end;
    end;
  end;
end;

function IsWinXP : boolean;
begin
  Result := (Win32Platform  = VER_PLATFORM_WIN32_NT) and
            (((Win32MajorVersion = 5) and (Win32MinorVersion >= 1)) or
            (Win32MajorVersion > 5));
end;

function IsWinVista : boolean;
begin
  Result := (Win32Platform  = VER_PLATFORM_WIN32_NT) and
            (((Win32MajorVersion = 6) and (Win32MinorVersion >= 0)) or
            (Win32MajorVersion > 6));
end;

procedure SwapOutMemory;
var
  ProcessID : THandle;
begin
  ProcessID := OpenProcess(PROCESS_ALL_ACCESS, FALSE, GetCurrentProcessID);
  SetProcessWorkingSetSize(ProcessID, $FFFFFFFF, $FFFFFFFF);
  CloseHandle(ProcessID);
end;

procedure SetProperty(obj: TObject; PropName: string; Value : Variant);
var
  pi : PPropInfo;
begin
  pi := GetPropInfo(obj.ClassInfo,PropName);
  if Assigned(pi) then
    SetVariantProp(obj,PropName,Value);
end;

procedure EnableControl(Edit : TWinControl; Enabled : boolean);
begin
  Edit.Enabled := Enabled;
  if Edit.Enabled then
    SetPropValue(Edit,'Color',clWindow)
  else
    SetPropValue(Edit,'Color',clBtnFace)
end;

//------------------------------------------------------------- show message ---

procedure Alert(st : string); overload;
begin
  ShowMessage(st);
end;

procedure Alert(int : integer); overload;
begin
  ShowMessage(IntTostr(int));
end;


//--------------------------------------------------------------- encryption ---

const
  // keys for borland encrypt classic
  C1 = 43941;
  C2 = 16302;

  // keys for borland encrypt wide
  C1B = 38677;
  C2B = 13873;

// This version of Borland Encrypt only works with ANSI strings, and wide
// string characters are truncated/ignored. It is, however,
// backward compatible with older versions of poptrayu
{$IFOPT Q+}{$DEFINE OVERFLOW_ON}{$Q-}{$ELSE}{$UNDEF OVERFLOW_ON}{$ENDIF}
{$IFOPT R+}{$DEFINE RANGEON}{$R-}{$ELSE}{$UNDEF RANGEON}{$ENDIF}
function BorlandEncryptClassic(const S: String; Key: Word): String;
var
  I: byte;
begin
  SetLength(Result,Length(S));
  for I := 1 to Length(S) do begin
    Result[I] := Char(byte(S[I]) xor (Key shr 8));
    Key := (byte(Result[I]) + Key) * C1 + C2;
  end;
end;
{$IFDEF RANGEON}{$R+}{$UNDEF RANGEON}{$ENDIF}
{$IFDEF OVERFLOW_ON}{$Q+}{$UNDEF OVERFLOW_ON}{$ENDIF}

// This version of Borland Encrypt works with Wide Strings without truncating
// the upper byte on each string.
{$IFOPT Q+}{$DEFINE OVERFLOW_ON}{$Q-}{$ELSE}{$UNDEF OVERFLOW_ON}{$ENDIF}
{$IFOPT R+}{$DEFINE RANGEON}{$R-}{$ELSE}{$UNDEF RANGEON}{$ENDIF}
function BorlandEncryptWide(const S: String; Key: Word): String;
var
  I: integer;
begin
  SetLength(Result,Length(S));
  for I := 1 to Length(S) do begin
    Result[I] := Char(word(S[I]) xor (Key shr 8));
    Key := (word(Result[I]) + Key) * C1B + C2B;
  end;
end;
{$IFDEF RANGEON}{$R+}{$UNDEF RANGEON}{$ENDIF}
{$IFDEF OVERFLOW_ON}{$Q+}{$UNDEF OVERFLOW_ON}{$ENDIF}

// the multiplication of Key * C1 may cause an expected integer overflow.
// so we've set compiler options here to disable rangechecking and
// overflow checking during this algorithm
{$IFOPT Q+}{$DEFINE OVERFLOW_ON}{$Q-}{$ELSE}{$UNDEF OVERFLOW_ON}{$ENDIF}
function BorlandDecryptClassic(const S: String; Key: Word): String;
var
  I, si: byte;
begin
  SetLength(Result,Length(S));
  for I := 1 to Length(S) do begin
    Result[I] := Char(byte(S[I]) xor (Key shr 8));
    si := byte(S[I]);
    {$IFOPT R+}{$DEFINE RANGEON}{$R-}{$ELSE}{$UNDEF RANGEON}{$ENDIF}
    Key := (si + Key) * C1 + C2;
    {$IFDEF RANGEON}{$R+}{$UNDEF RANGEON}{$ENDIF}
  end;
end;
{$IFDEF OVERFLOW_ON}{$Q+}{$UNDEF OVERFLOW_ON}{$ENDIF}



{$IFOPT Q+}{$DEFINE OVERFLOW_ON}{$Q-}{$ELSE}{$UNDEF OVERFLOW_ON}{$ENDIF}
function BorlandDecryptWide(const S: String; Key: Word): String;
var
  I : integer;
  si: word;
begin
  SetLength(Result,Length(S));
  for I := 1 to Length(S) do begin
    Result[I] := Char(word(S[I]) xor (Key shr 8));
    si := word(S[I]);
    {$IFOPT R+}{$DEFINE RANGEON}{$R-}{$ELSE}{$UNDEF RANGEON}{$ENDIF}
    Key := (si + Key) * C1B + C2B;
    {$IFDEF RANGEON}{$R+}{$UNDEF RANGEON}{$ENDIF}

  end;
end;
{$IFDEF OVERFLOW_ON}{$Q+}{$UNDEF OVERFLOW_ON}{$ENDIF}



function Encrypt(const password : string) : string;
var
  partially_encrypted : string;
begin
  { ----old encrypt ----
    result := '';
    for i := 1 to length(password) do
      result := result + char( (ord(password[i]) xor 43) + 11 ); }

  // new encrypt
  partially_encrypted := BorlandEncryptClassic(password,17732);
  Result := '<' + TIdEncoderMIME.EncodeString(partially_encrypted) + '>';  //ANSI
  if Decrypt(Result) <> password then begin
    partially_encrypted := BorlandEncryptWide(password,17732);
    Result := '>' + TIdEncoderMIME.EncodeString(partially_encrypted, IndyTextEncoding_UTF8) + '<'; //UTF-8
  end;
end;

function Decrypt(password : string) : string;
var
  i : integer;
begin
  if password = '' then
  begin
    result := '';
    Exit;
  end;
  if (Copy(password,1,1) = '>') and (Copy(password,Length(password),1) = '<') then
  begin
    // UTF8 decrypt
    password := Copy(password,2,Length(password)-2);
    password := TIdDecoderMIME.DecodeString(password, IndyTextEncoding_UTF8);
    Result := BorlandDecryptWide(password,17732);
  end
  else if (Copy(password,1,1) = '<') and (Copy(password,Length(password),1) = '>') then
  begin
    // ANSI decrypt
    password := Copy(password,2,Length(password)-2);
    password := TIdDecoderMIME.DecodeString(password);
    result := BorlandDecryptClassic(password,17732);
  end
  else begin
    // old decrypt
    result := '';
    for i := 1 to length(password) do
      result := result + char( (ord(password[i])-11) xor 43 );
  end;
end;

//----------------------------------------------------------------- win inet ---

function InternetGetConnectedState; external 'wininet.dll' name 'InternetGetConnectedState';

function IsConnectedToInternet : boolean;
var
  Flags: DWORD;
begin
  Result := false;
  if InternetGetConnectedState(Flags, 0) then
  begin
    Result := ((Flags and INTERNET_CONNECTION_LAN) > 0) or
              ((Flags and INTERNET_CONNECTION_MODEM) >  0) or
              ((Flags and INTERNET_CONNECTION_PROXY) > 0);
  end;
end;

//---------------------------------------------------------------- html help ---

type
  THtmlHelp = function(Caller : HWND; FileName : PChar; Command : UINT;
                       Data : DWORD) : HWND; stdcall;
var
  HtmlHelpProc : THtmlHelp = nil;
  HHLib : THandle = 0;

function HtmlHelp(Caller : HWND; FileName : string; Command : UINT; Data : DWORD) : HWND;
begin
  // load OCX if not loaded already
  if not Assigned(HtmlHelpProc) then
  begin
    HHLib := LoadLibrary('HHCtrl.ocx');
    if (HHLib <> 0) then
      HtmlHelpProc := GetProcAddress(HHLib, 'HtmlHelpW');
  end;
  // call help it successfull
  if not Assigned(HtmlHelpProc) then
  begin
    MessageDlg('HTML Help not installed.',mtError,[mbOK],0);
    Result := $FFFFFF;
  end
  else
    Result := HtmlHelpProc(Caller, PChar(FileName), Command, Data);
end;

//--------------------------------------------------------------------- MAPI ---

var
  SendMail: TFNMapiSendMail = nil;
  MAPIModule : HModule = 0;

function MapiSendMail2(lhSession: LHANDLE; ulUIParam: Cardinal;
  var lpMessage: TMapiMessage; flFlags: FLAGS; ulReserved: Cardinal): Cardinal;
////////////////////////////////////////////////////////////////////////////////
// Send MAPI mail using MAPI32.DLL without first checking in registry
begin
  // load DLL
  if MAPIModule = 0 then
    MAPIModule := LoadLibrary(PChar(MAPIDLL));
  if MAPIModule = 0 then
  begin
    Result := 99;
    Exit;
  end;
  // find SendMail function
  if @SendMail = nil then
    @SendMail := GetProcAddress(MAPIModule, 'MAPISendMail');
  // call sendmail
  if @SendMail <> nil then
    Result := SendMail(lhSession, ulUIParam, lpMessage, flFlags, ulReserved)
  else
    Result := 99;
end;

function MAPISendFile(h : HWND; FileNames : array of string) : cardinal;
////////////////////////////////////////////////////////////////////////////////
// Create mail message with FileNames as attachments, using MAPI client
var
  MapiMessage : TMapiMessage;
  i : Integer;
  files : array of TMapiFileDesc;
begin
  SetLength(files,Length(FileNames));
  for i := low(FileNames) to high(FileNames) do
  begin
    files[i].nPosition := i;
    files[i].lpszPathName := PAnsiChar(AnsiString(FileNames[i]));
    files[i].lpszFileName := PAnsiChar(AnsiString(FileNames[i]));
  end;

  with MapiMessage do
  begin
    ulReserved         := 0;
    lpszSubject        := nil;
    lpszNoteText       := '';
    lpszMessageType    := nil;
    lpszDateReceived   := nil;
    lpszConversationID := nil;
    flFlags            := 0;
    lpOriginator       := nil;
    nRecipCount        := 0;
    lpRecips           := nil;
    nFileCount         := Length(FileNames);
    lpFiles            := @files[0];
  end;
  Result := MapiSendMail2(0, h, MapiMessage,
               MAPI_DIALOG or MAPI_LOGON_UI or MAPI_NEW_SESSION, 0);
end;

var
  MapiMessage : TMapiMessage;  // must be global?

// TODO: this MAPI function is ANSI not unicode
// MAPISendMAilW is available on Windows 8+.
function MAPISendMessage(h : HWND; const ToAddress, Subject, Body : string) : boolean;
var
  Recips : TMapiRecipDesc;
  pToAddress,pSubject,pBody : PAnsiChar;
begin
  pToAddress := AnsiStrings.StrNew(PAnsiChar(AnsiString(ToAddress)));
  pSubject := AnsiStrings.StrNew(PAnsiChar(AnsiString(Subject)));
  pBody := AnsiStrings.StrNew(PAnsiChar(AnsiString(Body)));
  try
    Recips.ulRecipClass := MAPI_TO;
    Recips.lpszName := '';
    Recips.lpszAddress := pToAddress;
    with MapiMessage do
    begin
      ulReserved         := 0;
      lpszSubject        := pSubject;
      lpszNoteText       := pBody;
      lpszMessageType    := nil;
      lpszDateReceived   := nil;
      lpszConversationID := nil;
      flFlags            := 0;
      lpOriginator       := nil;
      nRecipCount        := 1;
      lpRecips           := @Recips;
      nFileCount         := 0;
      lpFiles            := nil;
    end;
    Result := MapiSendMail(0, h, MapiMessage,
                 MAPI_DIALOG or MAPI_LOGON_UI or MAPI_NEW_SESSION, 0) <> 99;
  finally
    AnsiStrings.StrDispose(pToAddress);
    AnsiStrings.StrDispose(pSubject);
    AnsiStrings.StrDispose(pBody);
  end;
end;


//------------------------------------------------------------------ uxTheme ---
{
const
  themedll = 'uxtheme.dll';

var
  ThemeLib: THandle;

function LoadThemeLib: Boolean;
begin
  if ThemeLib = 0 then
  begin
    ThemeLib := LoadLibrary(themedll);
    if ThemeLib > 0 then
    begin
      SetWindowTheme := GetProcAddress(ThemeLib, 'SetWindowTheme');
      IsThemeActive := GetProcAddress(ThemeLib, 'IsThemeActive');
      IsAppThemed := GetProcAddress(ThemeLib, 'IsAppThemed');
    end;
  end;
  Result := ThemeLib > 0;
end;
}


//-------------------------------------------------------------------- Color ---

procedure GetRGB(col : TColor; var r,g,b : integer);
var
  rgb : Longint;
begin
  rgb := ColorToRGB(col);
  r := rgb and $000000FF;
  g := (rgb and $0000FF00) shr 8;
  b := (rgb and $00FF0000) shr 16;
end;

function ColorToLevel(col : TColor; level : byte) : TColor;
////////////////////////////////////////////////////////////////////////////////
// Set color to level intesity (and make lighter)
var
  r,g,b : integer;
begin
  GetRGB(col,r,g,b);
  r := (r*level) div 255;
  g := (g*level) div 255;
  b := (b*level) div 255;
  Inc(r,20);
  Inc(g,20);
  Inc(b,20);
  if r>255 then r := 255;
  if g>255 then g := 255;
  if b>255 then b := 255;
  Result := RGB(r,g,b);
end;

procedure RecolorBitmap(bmp : TBitmap; col : TColor);
var
  x,y : integer;
  transcol,pcol : TColor;
begin
  transcol := bmp.Canvas.Pixels[0,bmp.Height-1];
  for x := 0 to bmp.Width-1 do
  begin
    for y := 0 to bmp.Height-1 do
    begin
      pcol := bmp.Canvas.Pixels[x,y];
      if pcol <> transcol then
        bmp.Canvas.Pixels[x,y] := ColorToLevel(col,pcol and $FF);
    end;
  end;
end;

//---------------------------------------------------------- Keyboard Lights ---

procedure SetKeyboardLight(Light : TKeyboardLight; OnOff : boolean);
var
  keyState : TKeyboardState;
  vkey : byte;
begin
   case Light of
     klNumLock    : vkey := VK_NUMLOCK;
     klCapsLock   : vkey := VK_CAPITAL;
     klScrollLock : vkey := VK_SCROLL;
   else
     vkey := 0;
   end;
   GetKeyboardState(keyState);
   if (OnOff and (keyState[vkey] and 1 <> 1)) or
       (not(OnOff) and (keyState[vkey] and 1 = 1)) then
   begin
     // simulate a key press
     keybd_event(vkey,$45,KEYEVENTF_EXTENDEDKEY or 0,0 );
     keybd_event(vkey,$45,KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP,0);
   end;
end;

function GetKeyboardLight(Light : TKeyboardLight) : boolean;
var
  vkey : byte;
begin
   case Light of
     klNumLock    : vkey := VK_NUMLOCK;
     klCapsLock   : vkey := VK_CAPITAL;
     klScrollLock : vkey := VK_SCROLL;
   else
     vkey := 0;
   end;

  Result := GetKeyState(vkey) and 1 = 1;
end;

procedure ToggleKeyboardLight(Light : TKeyboardLight);
var
  vkey : byte;
begin
   case Light of
     klNumLock    : vkey := VK_NUMLOCK;
     klCapsLock   : vkey := VK_CAPITAL;
     klScrollLock : vkey := VK_SCROLL;
   else
     vkey := 0;
   end;
   // simulate a key press
   keybd_event(vkey,$45,KEYEVENTF_EXTENDEDKEY or 0,0 );
   keybd_event(vkey,$45,KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP,0);
end;

//------------------------------------------------------------------- Arrays ---

function IndexInArray(arr : array of string; value : string) : integer;
var
  i : integer;
begin
  Result := -1;
  for i := Low(arr) to High(arr) do
    if arr[i] = value then
    begin
      Result := i;
      Break;
    end;
end;

//--------------------------------------------------- Command-line Paramters ---

function ParamSwitch(st : string) : boolean;
var
  i : integer;
  param : string;
begin
  Result := False;
  for i := 1 to ParamCount do
  begin
    param := StrBefore(UpperCase(ParamStr(i)),':');
    if (param = '/'+UpperCase(st)) or (param = '-'+UpperCase(st)) then
    begin
      Result := True;
      Break;
    end;
  end;
end;

function ParamSwitchIndex(st : string; start : integer = 0) : integer;
var
  i : integer;
  param : string;
begin
  Result := 0;
  for i := start+1 to ParamCount do
  begin
    param := StrBefore(UpperCase(ParamStr(i)),':');
    if (param = '/'+UpperCase(st)) or (param = '-'+UpperCase(st)) then
    begin
      Result := i;
      Break;
    end;
  end;
end;


function ParamNonSwitch(index : integer) : string;
var
  i,newindex : integer;
begin
  Result := '';
  newindex := 0;
  for i := 1 to ParamCount do
  begin
    if (Copy(ParamStr(i),1,1) <> '/') and (Copy(ParamStr(i),1,1) <> '-') then
    begin
      Inc(newindex);
      if newindex = index then
      begin
        Result := ParamStr(i);
        Break;
      end;
    end;
  end;
end;

function ParamSwitchValue(index : integer) : string;
begin
  Result := StrAfter(ParamStr(index),':');
end;

//------------------------------------------------------------------- Visual ---

procedure AutoSizeCheckBox(chkBox : TCheckBox); overload;
var
  canvas1 : TControlCanvas;
begin
  canvas1 := TControlCanvas.Create;
  try
    canvas1.Control := chkBox;
    canvas1.Font.Assign(chkBox.Font);
    chkBox.Width := GetSystemMetrics(SM_CXMENUCHECK) +
      GetSystemMetrics(SM_CXEDGE) +
      canvas1.TextWidth(chkBox.Caption);
    //chkBox.Height := canvas1.TextHeight(chkBox.Caption);

  finally
    canvas1.Free;
  end;
end;

procedure AutoSizeCheckBox(chkBox : TRadioButton);
var
  Rect : TRect;
  Canvas : TCanvas;
begin
  Rect := chkBox.ClientRect;
  Canvas := TCanvas.Create;
  try
    Canvas.Font := chkBox.Font;
    Canvas.Handle := GetDC(0);
    DrawText(Canvas.Handle, PChar(chkBox.Caption), Length(chkBox.Caption), Rect, DT_CALCRECT);
    chkBox.Width := Rect.Right - Rect.Left + 20;
    chkBox.Height := Rect.Height;
  finally
    Canvas.Free;
  end;
end;

procedure AutoSizeAllCheckBox(Control : TWinControl);
var
  i : integer;
begin
  for i := 0 to Control.ControlCount-1 do
    if (Control.Controls[i] is TCheckBox) then
      AutoSizeCheckBox(Control.Controls[i] as TCheckBox);
end;


function NumOnly(st : string) : integer;
var
  i : integer;
  s : string;
begin
  s := '';
  for i := 1 to Length(st) do
    if st[i].IsDigit then
      s := s + st[i];
  Result := StrToInt(s);
end;

function CompareInt(st1,st2 : string) : integer;
begin
  if NumOnly(st1) = NumOnly(st2) then
    Result := 0
  else begin
    if NumOnly(st1) > NumOnly(st2) then
      Result := 1
    else
      Result := -1;
  end;
end;

function CompareDateRC(st1,st2 : string) : integer;
var
  date1,date2 : TDateTime;
begin
  date1 := StrToFloat(st1);
  date2 := StrToFloat(st2);
  if date1 = date2 then
    Result := 0
  else begin
    if date1 > date2 then
      Result := 1
    else
      Result := -1;
  end;
end;

function StripSubjectPrefix(const st : string) : string;
var
  ipos : integer;
begin
  Result := st;
  ipos := Pos(':',st);
  if ipos in [3..4] then
     Delete(Result,1,ipos+1);
end;

function StringToColorDef(st : string; DefColor : TColor) : TColor;
begin
  try
    if st='' then
      Result := DefColor
    else
      Result := StringToColor(st);
  except
    Result := DefColor;
  end;
end;

function StringToColorDef2(st : string; DefColor : TColor) : TColor;
begin
  try
    // fix bug with using clLime in tray
    if st = 'clLime' then st := '$0000F900';
    Result := StringToColor(st);
  except
    Result := DefColor;
  end;
end;

function ColorToString2(Color : TColor) : string;
begin
  if Color = $0000F900 then // fix bug with using clLime in tray
    Result := 'clLime'
  else
    Result := ColorToString(Color);
end;

function DarkColor(col : TColor) : Boolean;
var
  r,g,b : integer;
begin
  if (col = clBlack) or (col = clNavy) or (col = clBlue) or
     (col = clMaroon) or (col = clRed) or (col = clGreen) or
     (col = clPurple) or (col = clTeal) or (col = clGray) or
     (col = clOlive) or (col = clFuchsia) then //dark colors
  begin
    Result := True;
  end
  else begin
    if (col = clWhite) or (col = clYellow) or (col = clSilver) or
       (col = clAqua) or (col = $0000F900) then // light colors
    begin
      Result := False
    end
    else begin
      //try it with RGB
      GetRGB(col,r,g,b);
      Result := ((r+g+b) div 3) < 128;
    end;
  end;
end;

function MixColors(col1,col2 : TColor) : TColor;
var
  r,g,b : integer;
  r1,g1,b1 : integer;
  r2,g2,b2 : integer;
begin
  GetRGB(col1,r1,g1,b1);
  GetRGB(col2,r2,g2,b2);
  r := (r1+r2) div 2;
  g := (g1+g2) div 2;
  b := (b1+b2) div 2;
  Result := (b shl 16) + (g shl 8) + r;
end;


procedure ClearImpairedCode(var str : string);
////////////////////////////////////////////////////////////////////////////////
// Clear half completed %hh values from end of string (BG: 12.09.2002)
var
   indLastPercent : integer;
begin
   indLastPercent := LastDelimiter('%', str);
   if ( indLastPercent > 0 ) and ( Length(str) < indLastPercent + 2 ) then
        str := LeftStr(str, indLastPercent - 1);
end;


// this helper function calls the CommCtrl library function ListView_SetColumn
// (see MSDN) to change the list view header image (eg: sort arrow) as this
// functionality is not exposed by the TListView in a way that you can select
// whether the header image should be left or right aligned.
procedure SetColumnImage(lv : TListView; ColumnIndex,ImageIndex : Integer; textRightAligned : boolean = false);
var
  lvColumnStruct : TLVColumn; //uses CommCtrl
begin
  // set image on right of text
  lvColumnStruct.mask := LVCF_FMT or LVCF_IMAGE;
  lvColumnStruct.iImage := ImageIndex;
  if not textRightAligned then
    lvColumnStruct.fmt := LVCFMT_BITMAP_ON_RIGHT // (explicit) arrow on right, (implicit) text left aligned
  else
    lvColumnStruct.fmt := LVCFMT_RIGHT; // (implicit) arrow on left, (explicit) right align text
  if (ImageIndex > -1) then
    lvColumnStruct.fmt := lvColumnStruct.fmt or LVCFMT_IMAGE
  else
    lvColumnStruct.fmt := lvColumnStruct.fmt and not LVCFMT_IMAGE;

  ListView_SetColumn(lv.Handle, ColumnIndex, lvColumnStruct);
end;

procedure ExecuteAccelAction(ToolBar : TActionToolbar; Key : word); //uses ActnCtrls
var
  i : integer;
begin
  if Assigned(ToolBar.ActionClient) then
    for i := 0 to ToolBar.ActionClient.Items.Count-1 do
      if IsAccel(Key,ToolBar.ActionClient.Items[i].Control.Caption) then
        ToolBar.ActionClient.Items[i].Control.Action.Execute;
end;

// This function is courtesy of Chris Rolliston
// see http://delphihaven.wordpress.com/2012/12/08/retrieving-the-applications-version-string/
//
function GetAppVersionStr: string;
const
  VS_FF_DEBUG_STRING = 'Beta Release';
var
  Exe: string;
  Size, Handle: DWORD;
  Buffer: TBytes;
  FixedPtr: PVSFixedFileInfo;
begin
  Exe := ParamStr(0);
  Size := GetFileVersionInfoSize(PChar(Exe), Handle);
  if Size = 0 then
    RaiseLastOSError;
  SetLength(Buffer, Size);
  if not GetFileVersionInfo(PChar(Exe), Handle, Size, Buffer) then
    RaiseLastOSError;
  if not VerQueryValue(Buffer, '\', Pointer(FixedPtr), Size) then
    RaiseLastOSError;
//  Result := Format('%d.%d.%d.%d',
//    [LongRec(FixedPtr.dwFileVersionMS).Hi,  //major
//     LongRec(FixedPtr.dwFileVersionMS).Lo,  //minor
//     LongRec(FixedPtr.dwFileVersionLS).Hi,  //release
//     LongRec(FixedPtr.dwFileVersionLS).Lo]) //build

  Result := Format('%d.%d.%d',
    [LongRec(FixedPtr.dwFileVersionMS).Hi,  //major
     LongRec(FixedPtr.dwFileVersionMS).Lo,  //minor
     LongRec(FixedPtr.dwFileVersionLS).Hi
     ,LongRec(FixedPtr.dwFileVersionLS).Lo
     ]); //release

  //If Debug Flag
  if FixedPtr.dwFileFlags and VS_FF_DEBUG <> 0 then
    Result := Result + ' (' + Translate(VS_FF_DEBUG_STRING)+')';
end;


procedure DeleteToRecycleBin(const fileameWithPath : String; const ParentWindow: HWND = 0);
var
  FileOpStruc: TSHFileOpStruct;
begin
  with FileOpStruc do
  begin
  Wnd := ParentWindow;
  wFunc := FO_DELETE;
  pFrom := PChar(fileameWithPath);
  fFlags := FOF_ALLOWUNDO
  end;
  SHFileOperation(FileOpStruc);
end;


end.

