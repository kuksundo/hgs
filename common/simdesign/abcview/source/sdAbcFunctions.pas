{ sdAbcFunctions

  Functions that do not depend on the local abcview classes.

  author: Nils Haeck M.Sc.
  date: 02apr2011
  copyright (c) 2011 SimDesign (www.simdesign.nl)
}
unit sdAbcFunctions;

interface

uses
  Windows,  // for SetStretchBltMode function

  Graphics, Classes, Controls, ShellApi, Forms, GraphicEx, SysUtils,
  Registry, Inifiles, DiskInfo, sdAbcTypes, sdAbcVars;

// Sorting
function CompareDouble(Dbl1, Dbl2: double): integer;
function CompareWord(Word1, Word2: word): integer;
function CompareCardinal(C1, C2: cardinal): integer;
function CompareByte(Byte1, Byte2: byte): integer;
function CompareInt(Int1, Int2: integer): integer;
function CompareInt64(Int641, Int642: int64): integer;
function CompareBool(Bool1, Bool2: boolean): integer;
// Compare two strings, but in a numeric way
function CompareStringNum(const String1, String2: string): integer;

// Use these functions to read/write TRect structures from an ini file
function IniReadRect(AIni: TIniFile; AHeader, AKey: string; ADefault: TRect): TRect;
procedure IniWriteRect(AIni: TIniFile; AHeader, AKey: string; AValue: TRect);

// Call HasContent to see if these conditions are met
// a) The bitmap exists (is assigned)
// b) The bitmap has content (ABitmap.Width > 0 and ABitmap.Height > 0)
function HasContent(AGraphic: TGraphic): boolean;

// Rescale an image (Source->Target) so that the new dimensions do not exceed ImageWidth/Height
// but the image's aspect ratio is kept
procedure RescaleImage(const Source, Target: TBitmap; ImageWidth, ImageHeight: integer;
  DownScale, UpScale, UseFilter: boolean);

// check if a file is a graphics file (based on extension)
function IsGraphicsFile(AFileName: TFileName): boolean;

// Convert a string containing "K", "KB", "M", "MB", "G", "GB" into
// an integer containing number of bytes.
function SizeStrToInt(AValue: string): cardinal;

// Swap integer Int1 with Int2
procedure SwapInteger(var Int1, Int2: integer);

// Swap double D1 with D2
procedure SwapDouble(var D1, D2: double);

// Calculate from a string like "640x480" the number of square pixels
function SquareStrToInt(AValue: string): cardinal;

function GetParentFolder(AFolder: string): string;

function IsWindowsFolder(AFolder: string): boolean;

// Sets the system's imagelists for the listview
procedure CreateSystemImages(var SmallIcons, LargeIcons: TImageList);

// Find the position of Mask in S. Returns -1 if not found.
// Mask may contain # = number char (0..9)
//                  $ = Hex char (0..9, a..f)
// Find works case insensitive
function PosMask(Mask: string; S: string): integer;

// This function replaces the %20 etc characters by normal ones
// e.g. "my%20picture.jpg" -> "my picture.jpg"
function ConvertURLCodedToFileName(AName: string): string;

// Strip the filename AName of elements like "Copy of .., "(2):,  "_2" etc.
function StripFileNameOfCopy(AName: string): string;

// Retrieve the filesize in bytes of the specified file (FileName must include
// path info)
function sdGetFileSize(FileName: string): int64;

// Convert all commas to dots
function CommaToDot(Line: string): string;

// Check if a drive is removable
function IsRemovableDrive(ADrive: char): boolean;

// gets shell info about a file / folder
function ShellGetFileInfo(AFileName: TFileName; var AInfo: TShFileInfo): integer;
function ShellGetFolderInfo(AFolderName: TFileName; var AInfo: TShFileInfo): integer;

// Get disk's volume label
function GetDiskVolumeLabel(Drive: string): string;

procedure GetAssocActions(Extension: string; Captions: TStrings);

implementation

function CompareBool(Bool1, Bool2: boolean): integer;
const
  BoolVal: array[boolean] of integer = (0, 1);
begin
  Result := CompareInt(BoolVal[Bool1], BoolVal[Bool2]);
end;

function CompareDouble(Dbl1, Dbl2: double): integer;
begin
  if Dbl1 < Dbl2 then
    Result := -1
  else
    if Dbl1 > Dbl2 then
      Result := 1
    else
      Result := 0;
end;

function CompareCardinal(C1, C2: cardinal): integer;
begin
  if C1 < C2 then
    Result:=-1
  else
    if C1 > C2 then
      Result:=1
    else
      Result:=0;
end;

function CompareByte(Byte1, Byte2: byte): integer;
begin
  if Byte1 < Byte2 then
    Result := -1
  else
    if Byte1 > Byte2 then
      Result := 1
    else
      Result := 0;
end;

function CompareInt(Int1, Int2: longint): integer;
begin
  if Int1<Int2 then
    Result:=-1
  else
    if Int1>Int2 then
      Result:=1
    else
      Result:=0;
end;

function CompareInt64(Int641, Int642: int64): integer;
begin
  if Int641 < Int642 then
    Result := -1
  else
    if Int641 > Int642 then
      Result := 1
    else
      Result := 0;
end;

function CompareWord(Word1, Word2: word): integer;
begin
  if Word1 < Word2 then
    Result := -1
  else
    if Word1 > Word2 then
      Result := 1
    else
      Result := 0;
end;

function CompareStringNum(const String1, String2: string): integer;
var
  Mask1, Mask2: string;
  // local
  function CreateMask(AString: string): string;
  var
    i: integer;
  begin
    Result := AString;
    for i := 1 to Length(Result) do
      if Result[i] in ['0'..'9'] then
        Result[i] := '#';
  end;
// main
begin
  // First compare numeric masks
  Mask1 := CreateMask(String1);
  Mask2 := CreateMask(String2);
  Result := AnsiCompareText(Mask1, Mask2);
  if Result = 0 then
    Result := AnsiCompareText(String1, String2);
end;

function IniReadRect(AIni: TIniFile; AHeader, AKey: string; ADefault: TRect): TRect;
var
  S, NumS: string;
  Comma: integer;
begin
  Result := ADefault;
  S := '';
  if assigned(AIni) then
    S := AIni.ReadString(AHeader, AKey, '');
  if(length(S) > 0) then
  begin
    Comma := Pos(',', S);
    if Comma > 0 then
    begin
      NumS := Copy(S, 1, Comma - 1);
      Delete(S, 1, Comma);
      Result.Left := StrToIntDef(NumS, 0);
    end;
    Comma := Pos(',', S);
    if Comma > 0 then
    begin
      NumS := Copy(S, 1, Comma - 1);
      Delete(S, 1, Comma);
      Result.Top := StrToIntDef(NumS, 0);
    end;
    Comma := Pos(',', S);
    if Comma > 0 then
    begin
      NumS := Copy(S, 1, Comma - 1);
      Delete(S, 1, Comma);
      Result.Right := StrToIntDef(NumS, 0);
    end;
    Result.Bottom := StrToIntDef(S, 0);
  end;
end;

procedure IniWriteRect(AIni: TIniFile; AHeader, AKey: string; AValue: TRect);
begin
  if assigned(AIni) then
    AIni.WriteString(AHeader, AKey, Format('%d,%d,%d,%d',
      [AValue.Left, AValue.Top, AValue.Right, AValue.Bottom]));
end;

function HasContent(AGraphic: TGraphic): boolean;
begin
  Result := False;
  try
    if assigned(AGraphic) and (AGraphic.Width > 0) and (AGraphic.Height > 0) then
      Result := True;
  except
    // Silent exception
  end;
end;

procedure RescaleImage(const Source, Target: TBitmap; ImageWidth, ImageHeight: integer;
  DownScale, UpScale, UseFilter: boolean);
// if source is in at least one dimension larger than the thumb size then rescale
// source but keep aspect ratio
var
  NewWidth,
  NewHeight: Integer;
  // local
  procedure DoStretching;
  begin
    if UseFilter then
    begin

      // Use the method from GraphicEx
      Stretch(NewWidth, NewHeight, FResamplingFilter, 0, Source, Target);

    end else
    begin

      Target.Width := NewWidth;
      Target.Height := NewHeight;

      SetStretchBltMode(Target.Canvas.Handle, HALFTONE);//COLORONCOLOR
      StretchBlt(Target.Canvas.Handle, 0, 0, NewWidth, NewHeight, Source.Canvas.Handle, 0, 0,
                   Source.Width, Source.Height, SRCCOPY);
    end;
  end;
//main
begin

  if (ImageWidth<=0) or (ImageHeight<=0) or (Source.Width<=0) or (Source.Height<=0) then
    exit;

  if ((Source.Width > ImageWidth) OR (Source.Height > ImageHeight)) AND DownScale then
  begin
    if (Source.Width/ImageWidth) > (Source.Height/ImageHeight) then
    begin
      // Downscale horizontally
      NewWidth := ImageWidth;
      NewHeight := Round(ImageWidth * Source.Height / Source.Width);
    end else
    begin
      // Downscale vertically
      NewHeight := ImageHeight;
      NewWidth := Round(ImageHeight * Source.Width / Source.Height);
    end;

    DoStretching;

  end else
  begin
    if (Source.Width < ImageWidth) AND (Source.Height < ImageHeight) AND Upscale then
    begin
      if (Source.Width/ImageWidth) > (Source.Height/ImageHeight) then
      begin
        // Upscale horizontally
        NewWidth := ImageWidth;
        NewHeight := Round(ImageWidth * Source.Height / Source.Width);
      end else
      begin
        // Upscale vertically
        NewHeight := ImageHeight;
        NewWidth := Round(ImageHeight * Source.Width / Source.Height);
      end;

      DoStretching;

    end else
      // Just copy the Source to Target
      Target.Assign(Source);
  end;

end;

function IsGraphicsFile(AFileName: TFileName): boolean;
begin
  Result := Pos(LowerCase(ExtractFileExt(AFileName)) + ';', cGraphicsExt) > 0;
end;

function SizeStrToInt(AValue: string): cardinal;
var
  i: integer;
  Multipl: cardinal;
begin
  Multipl := 1;
  i := 1;
  while i <= length(AValue) do
  begin
    AValue[i] := UpCase(AValue[i]);
    case AValue[i] of
    'K': Multipl := 1024;
    'M': Multipl := 1024*1024;
    'G': Multipl := 1024*1024*1024;
    end;//case
    if AValue[i] in [' ', 'A'..'Z'] then
      Delete(AValue, i, 1)
    else
      inc(i);
  end;
  Result := StrToIntDef(AValue, 0) * integer(Multipl);
end;

procedure SwapInteger(var Int1, Int2: integer);
var
  Temp: integer;
begin
  Temp := Int1;
  Int1 := Int2;
  Int2 := Temp;
end;

procedure SwapDouble(var D1, D2: double);
var
  Temp: double;
begin
  Temp := D1;
  D1 := D2;
  D2 := Temp;
end;

function SquareStrToInt(AValue: string): cardinal;
var
  PosX: integer;
begin
  PosX := Pos('x', LowerCase(AValue));
  if PosX > 0 then
    Result := StrToIntDef(copy(AValue, 1, PosX-1), 0) *
              StrToIntDef(copy(AValue, PosX + 1, length(AValue)), 0)
  else
    Result := StrToIntDef(AValue, 0);
end;

function GetParentFolder(AFolder: string): string;
var
  AName: string;
  Index: integer;
begin
  Result := '';
  AName := ExcludeTrailingPathDelimiter(AFolder);
  Index := LastDelimiter('\', AName);
  if Index > 0 then
    Result := copy(AName, 1, Index);
end;

function IsWindowsFolder(AFolder: string): boolean;
// Detect if this folder is the windows folder
begin
  Result := False;
  if Pos('win', lowercase(AFolder)) > 0 then
  begin
    if (Pos(':\windows', lowercase(AFolder)) > 0) or
       (Pos(':\winnt', lowercase(AFolder)) > 0) then
      Result := True;
  end;
end;

procedure CreateSystemImages(var SmallIcons, LargeIcons: TImageList);
// Sets the system's imagelists for the listview
var
  SysIL: uint;
  SFI: TSHFileInfo;
begin

  LargeIcons := TImageList.Create(Application.MainForm);
  SysIL := SHGetFileInfo('', 0, SFI, SizeOf(SFI), SHGFI_SYSICONINDEX or SHGFI_LARGEICON);
  if SysIL <> 0 then
  begin
    LargeIcons.Handle := SysIL;
    LargeIcons.ShareImages := TRUE;  // DON'T FREE THE SYSTEM IMAGE LIST!!!!!  BAD IDEA (tm)!
  end;

  SmallIcons := TImageList.Create(Application.MainForm);
  SysIL := SHGetFileInfo('', 0, SFI, SizeOf(SFI), SHGFI_SYSICONINDEX or SHGFI_SMALLICON);
  if SysIL <> 0 then
  begin
    SmallIcons.Handle := SysIL;
    SmallIcons.ShareImages := TRUE;  // DON'T FREE THE SYSTEM IMAGE LIST!!!!!  BAD IDEA (tm)!
  end;

end;

function PosMask(Mask: string; S: string): integer;
// Find the position of Mask in S. Returns -1 if not found.
// Mask may contain # = number char (0..9)
//                  $ = Hex char (0..9, a..f)
// Find works case insensitive
var
  APos, Cur: integer;
  //local
  function EqualChars(A, M: Char): boolean;
  begin
    Result := (A = M) or
             ((M = '#') and (A in ['0'..'9'])) or
             ((M = '$') and (A in ['0'..'9', 'a'..'f']));
  end;
//main
begin
  Result := -1;
  if (length(Mask) = 0) or (length(S) = 0) then
    exit;
  APos := 1;
  S := lowercase(S);
  Mask := lowercase(Mask);
  while APos + length(Mask) - 1 <= length(S) do
  begin
    if EqualChars(S[APos], Mask[1]) then
    begin
      Cur := 2;
      repeat
        if not EqualChars(S[APos + Cur - 1], Mask[Cur]) then
          break;
        inc(Cur);
      until Cur > length(Mask);
      if Cur > length(Mask) then
      begin
        Result := APos;
        exit;
      end;
    end;
    inc(APos);
  end;

end;

function ConvertURLCodedToFileName(AName: string): string;
// This function replaces the %20 etc characters by normal ones
// e.g. "my%20picture.jpg" -> "my picture.jpg"
var
  APos: integer;
  B: byte;
begin
  repeat
    APos := PosMask('%$$', AName);
    if APos > 0 then
    begin
      try
        B := StrToInt('$' + Copy(AName, APos + 1, 2));
      except
        B := $20;
      end;
      Delete(AName, APos, 3);
      Insert(Chr(B), AName, APos);
    end;
  until APos <= 0;
  Result := AName;
end;

function StripFileNameOfCopy(AName: string): string;
const
  cFindCount = 10;
  cFinds: array[1..cFindCount] of string =
    ('copy of ', 'copy (#) of ', 'copy (##) of', '(#).',
     '(##).', '_#.', ' copy.', 'copy.', ' kopie.', 'kopie.');
  cReplaces: array[1..cFindCount] of string =
    ('', '', '', '.', '.', '.', '.', '.', '.', '.');
var
  i, APos: integer;
  LwrName: string;
begin
  LwrName := lowercase(AName);
  // find the cFinds
  for i := 1 to cFindCount do
  begin
    APos := PosMask(cFinds[i], LwrName);
    if APos > 0 then
    begin
      // Remove and replace
      Delete(AName, APos, length(cFinds[i]));
      Insert(cReplaces[i], AName, APos);
      // new lower case
      LwrName := lowercase(AName);
    end;
  end;
  Result := AName;
end;

function sdGetFileSize(FileName: string): int64;
var
  F: TSearchRec;
  FD: TWin32FindData;
begin
  Result := 0;
  if FindFirst(FileName, faAnyFile, F) = 0 then
  begin
  {$warnings off}
    FD := F.FindData;
  {$warnings on}
    Result := (FD.nFileSizeHigh shl 32) or FD.nFileSizeLow;
    //Result := F.Size;  // F.Size is a 32-bit number so not ccompatible with 64bit filesizes!
	// hence this strange construct.
  end;
  FindClose(F);
end;

function CommaToDot(Line: string): string;
var
  APos: integer;
begin
  Result := Line;
  repeat
    APos := Pos(',', Result);
    if APos > 0 then
      Result[APos] := '.';
  until APos = 0;
end;

function IsRemovableDrive(ADrive: char): boolean;
begin
  Result := GetDriveType(ADrive) in
    [dtUnknown, dtFloppy, dtCDROM, dtRAM, dtFloppy3720, dtFloppy3144, dtFloppy3288, dtFloppy3288M,
     dtFloppy5360,dtFloppy512];
end;

function ShellGetFileInfo(AFileName: TFileName; var AInfo: TShFileInfo): integer;
// gets shell info about a file / folder
{When using a generic file extension, you have to use the file
attributes flags like this:
ext:='*.bmp';}
begin
  Result := SHGetFileInfo(
    PChar(AFileName),
    FILE_ATTRIBUTE_NORMAL,
    AInfo, SizeOf(TSHFileInfo),
    SHGFI_SYSICONINDEX or SHGFI_USEFILEATTRIBUTES or SHGFI_TYPENAME);
end;

function ShellGetFolderInfo(AFolderName: TFileName; var AInfo: TShFileInfo): integer;
// gets shell info about a file / folder
begin
  Result := ShGetFileInfo(
    pchar(AFolderName),
    0, AInfo, sizeof(TShFileInfo),
    SHGFI_SYSICONINDEX or
    SHGFI_TYPENAME);
end;

function GetDiskVolumeLabel(Drive: string): string;
var
  Root: string;
  VolName, FSysName: array[0..255] of Char;
  SerialNo,
  ComponentLength,
  FileSystemFlags: dword;
  Succeed: boolean;
begin
  // Windows routine GetVolumeInformation
  Root := Drive + '\';
  Succeed := Windows.GetVolumeInformation(
    PChar(Root),         // Drive+'\'
    VolName, 256,       // Buffer to receive volume name
    @SerialNo,
    ComponentLength,
    FileSystemFlags,
    FSysName, 256);
  Result := '';
  if Succeed then
    Result := VolName;
end;

procedure GetAssocActions(Extension: string; Captions: TStrings);
var
  Regist: TRegistry;
  FileTypeName: string;
begin
  FileTypeName := '';
  Regist := TRegistry.Create;
  try
    Regist.RootKey := HKEY_CLASSES_ROOT;

    // file type
    if Regist.OpenKey(Extension, False) then begin
      FileTypeName := Regist.ReadString ('');
      Regist.CloseKey;
    end;

    // name
    if (length(FileTypeName) > 0) and
       Regist.OpenKey(FileTypeName + '\shell', False) then begin
      Regist.GetKeyNames(Captions);
      Regist.CloseKey;
    end;

  finally
    Regist.Free;
  end;
end;

end.
