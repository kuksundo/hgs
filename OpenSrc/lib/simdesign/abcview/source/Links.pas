{ Unit Links

  Create customised html from a list of links and other text tools

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit Links;

interface

uses
  Windows, Classes, SysUtils, {$warnings off}FileCtrl;{$warnings on}


// Per spec R. Jeantet: change all "\" for "/", this is because Netscape stumbles
// over the "\" in links
function ConvertToForwardSlash(S: string): string;

// Call MakeLink to create a HTML link. Item is the displayed text, Link is the
// link, and Self is the document name to create it in. If Self=Link, no link
// will be created and just Item will be displayed
function MakeLink(Item, Link, Self: string): string;

// Make a <img src= alt= > link. If Alt = '' it will be skipped
function MakeImgLink(Src, Alt: string): string;

// Call MakePeerLinks to make a list of HTML links
function MakePeerLinks(
  Items, Links: TStrings;
  First, Last, JumpPrev, JumpNext, Spacer, Bracks: string;
  APos, AMax: integer): string;

// This procedure will extract filename information from a html text. It will assume
// that filenames are in " " and contain no illegal chars.
procedure GetFilenamesFromHtml(const AHtml: string; AFolder: string; AList: TStrings);

// This procedure will copy all referenced files in AHtml to another destination. The
// filenames are first parsed from AHtml, then each one is searched in original location
// relative to OrigFileName, then copied to a location relative to DestFolder
procedure CopyWebpageReferences(const AHtml: string; OrigFileName, DestFolder: string);

// This function will create a numbered filename from a mask.
// e.g. Mask = 'image###.html', number = 15, result = 'image015.html'
function NumberFormatFromMask(Mask: string; Number: integer): string;

// This function will create a mask from a numbered filename.
// e.g. AFileName = 'image015.html', maskcount = 2, result = 'image0##.html'
function MaskFromNumberFormat(AFilename: string; MaskCount: integer): string;

// This function returns the number of a filename as calculated from mask.
// e.g. AFilename = 'image215.html', mask = 'image2##.html', result = 15.
// Returns -1 if no valid match was found
function NumberFromMaskAndName(Mask, AFileName: string): integer;

procedure SplitToWords(APhrase: string; AResult: TStrings; Delimiters: string = ' '#9#13#10 );

implementation

function ConvertToForwardSlash(S: string): string;
// Per spec R. Jeantet: change all "\" for "/", this is because Netscape stumbles
// over the "\" in links
var
  APos: integer;
begin
  Result := S;
  repeat
    APos := Pos('\', Result);
    if APos = 0 then exit;
    Result[APos] := '/';
  until False;
end;

function MakeLink(Item, Link, Self: string): string;
begin
  if Self = Link then
    Result := Item
  else
    Result := Format('<a href="%s">%s</a>', [Link, Item]);
  Result := ConvertToForwardSlash(Result);
end;

function MakeImgLink(Src, Alt: string): string;
begin
  if length(Alt) > 0 then
    Result := Format('<img src="%s" alt="%s">', [Src, Alt])
  else
    Result := Format('<img src="%s">', [Src]);
  Result := ConvertToForwardSlash(Result);
end;

function MakePeerLinks(
  Items, Links: TStrings;
  First, Last, JumpPrev, JumpNext, Spacer, Bracks: string;
  APos, AMax: integer): string;
var
  i: integer;
  Start, Close: integer;
  BrL, BrR: string;
  Names, Elems: TStrings;
// local
function LinkItem(AText: string; AIndex: integer): string;
begin
  if APos = AIndex then
    Result := Format('%s%s%s',
      [BrL, AText, BrR])
  else
    Result := Format('<a href="%s">%s%s%s</a>',
      [Links[AIndex], BrL, AText, BrR]);
  Result := ConvertToForwardSlash(Result);
end;
begin
  // Checks
  if not assigned(Links) then exit;
  Result := '';

  // Text checks
  if Spacer = '' then Spacer := '&nbsp;&nbsp;';
  if JumpPrev = '' then JumpPrev := '...';
  if JumpNext = '' then JumpNext := '...';
  if First = '' then First := 'First';
  if Last = '' then Last := 'Last';
  Names := TStringList.Create;
  try
    // Names list
    for i := 0 to Links.Count - 1 do
      if Items = nil then
        Names.Add(IntToStr(i + 1))
      else
        Names.Add(Items[i]);

    // Left & Right brackets
    brL := Copy(Bracks, 1, Length(Bracks) div 2);
    brR := Copy(Bracks, 1 + Length(Bracks) div 2, Length(Bracks));

    // Find Start & Close
    Start := APos - (AMax div 2);
    if Start < 0 then Start := 0;
    Close := Start + AMax - 1;
    if Close >= Links.Count then begin
      Close := Links.Count - 1;
      Start := Close - AMax + 1;
      if Start < 0 then Start := 0;
    end;

    Elems := TStringList.Create;
    try
      // First
      if Start > 0 then
        Elems.Add(LinkItem(First, 0));
      // Prev X
      if APos - AMax > 0 then
        Elems.Add(LinkItem(JumpPrev, APos - AMax));
      // The row
      for i := Start to Close do
        Elems.Add(LinkItem(Names[i], i));
      // Next X
      if APos + AMax < Links.Count - 1 then
        Elems.Add(LinkItem(JumpNext, APos + AMax));
      // Last
      if Close < Links.Count - 1 then
        Elems.Add(LinkItem(Last, Links.Count - 1));

      // Create the link chain
      Result := '';
      if Elems.Count > 1 then begin
        Result := Elems[0];
        for i := 1 to Elems.Count - 1 do
          Result := Result + Spacer + Elems[i];
      end;
    finally
      Elems.Free;
    end;

{    // Prev
    if APos > 0 then
      Result := Result + LinkItem(Prev, APos - 1) + Spacer
    else
      Result := Result + LinkItem(Prev, APos) + Spacer;

    // First
    if Start > 0 then
      Result := Result + LinkItem(First, 0) + Spacer;
    // Prev X
    if APos - AMax > 0 then
      Result := Result + LinkItem(Format('%s%d', [Prev, AMax]), APos - AMax) + Spacer;
    // The row
    for i := Start to Close do
      Result := Result + LinkItem(Names[i], i) + Spacer;
    // Next X
    if APos + AMax < Links.Count - 1 then
      Result := Result + LinkItem(Format('%s%d', [Next, AMax]), APos + AMax) + Spacer;
    // Last
    if Close < Links.Count - 1 then
      Result := Result + LinkItem(Last, Links.Count - 1) + Spacer;
    // Next
    if APos < Links.Count - 1 then
      Result := Result + LinkItem(Next, APos + 1)
    else
      Result := Result + LinkItem(Next, APos);}

  finally
    Names.Free;
  end;
end;

procedure GetFilenamesFromHtml(const AHtml: string; AFolder: string; AList: TStrings);
var
  Index, Start: integer;
  InQuotes: boolean;
  AFileName: string;
// local
function IsValidFile(AFileName: string): boolean;
begin
  Result := False;
  if length(AFileName) = 0 then exit;

  // filename must have a dot
  if Pos('.', AFileName) = 0 then exit;

  // Otherwise it's pretty scary what can be in, so just check existance
  if FileExists(ExpandFileName(AFileName)) then Result := True;
end;
// main
begin
  Start := 1; // avoid compiler complaint
  if (length(AHtml) = 0) or not assigned(AList) then exit;
  SetCurrentDir(AFolder);
  Index := 1;
  InQuotes := False;
  while length(AHtml) > Index do begin
    if AHtml[Index] = '"' then begin
      InQuotes := not InQuotes;
      if InQuotes then
        Start := Index
      else begin
        AFileName := copy(AHtml, Start + 1, Index - Start - 1);
        if IsValidFile(AFileName) then begin
          AList.Add(AFileName);
        end;
      end;
    end;
    inc(Index);
  end;
end;

procedure CopyWebpageReferences(const AHtml: string; OrigFileName, DestFolder: string);
var
  i: integer;
  FileList: TStringList;
  FOrig, FDest: string;
begin
  FileList := TStringList.Create;
  try
    with FileList do begin
      Sorted := True;
      Duplicates := dupIgnore;
    end;
    GetFilenamesFromHtml(AHtml, ExtractFilePath(OrigFileName), FileList);
    // Copy these files!
    for i := 0 to FileList.Count - 1 do begin
      SetCurrentDir(ExtractFilePath(OrigFileName));
      FOrig := ExpandFileName(FileList[i]);
      SetCurrentDir(DestFolder);
      FDest := ExpandFileName(FileList[i]);
      ForceDirectories(ExtractFilePath(FDest));
      CopyFile(pchar(FOrig), pchar(FDest), False);
    end;
  finally
    FileList.Free;
  end;
end;

function NumberFormatFromMask(Mask: string; Number: integer): string;
var
  APos: integer;
begin
  repeat
    APos := LastDelimiter('#', Mask);
    if APos > 0 then begin
      Mask[APos] := Char(ord('0') + (Number mod 10));
      Number := Number div 10;
    end;
  until APos = 0;
  Result := Mask;

  // Make sure to create a filename that has the complete number
  if Number > 0 then
    Result := IntToStr(Number) + Result;
end;

function MaskFromNumberFormat(AFilename: string; MaskCount: integer): string;
var
  APos: integer;
begin
  repeat
    APos := LastDelimiter('0123456789', AFileName);
    if (APos > 0) and (MaskCount > 0) then begin
      AFileName[APos] := '#';
      dec(MaskCount);
    end;
  until (APos = 0) or (MaskCount = 0);
  Result := AFileName;

end;

function NumberFromMaskAndName(Mask, AFileName: string): integer;
var
  i, APos: integer;
begin
  Result := -1;
  // Find first mask character
  APos := Pos('#', Mask);
  // Check if valid mask and base is equal
  if (APos > 0) and (lowercase(copy(Mask, 1, APos - 1)) = lowercase(copy(AFilename, 1, APos - 1))) then begin
    // just the last part
    Mask := Copy(Mask, APos, 255);
    AFileName := Copy(AFileName, APos, 255);
    // Create equal length strings
    while length(AFileName) < length(Mask) do
      AFileName := '0' + AFileName;
    while length(AFileName) > length(Mask) do
      Mask:= '#' + Mask;
    Result := 0;
    for i := 1 to length(Mask) do begin
      if (Mask[i] = '#') and (AFileName[i] in ['0'..'9']) then begin
        Result := Result * 10 + ord(AFIleName[i]) - Ord('0');
      end else begin
        if lowercase(Mask[i]) <> lowercase(AFileName[i]) then begin
          Result := -1;
          exit;
        end;
      end;
    end;
  end;
end;

procedure SplitToWords(APhrase: string; AResult: TStrings; Delimiters: string = ' '#9#13#10 );
// SplitToWords will take APhrase and put each individual word. Parts in quotes are
// unquoted and kept together as one 'word'
var
  i: integer;
  InQuotes: boolean;
begin

  if not assigned(AResult) then exit;
  // First replace all delimiters with #13 if in quotes
  InQuotes := False;
  for i := 1 to length(APhrase) do begin
    if APhrase[i] = '"' then begin
      APhrase[i] := #13;
      InQuotes := not InQuotes;
    end;
    if not InQuotes and (Pos(APhrase[i], Delimiters) > 0) then
      APhrase[i] := #13;
  end;

  // Next, assign to stringlist and delete all empty lines
  AResult.Text := APhrase;
  i := 0;
  while i < AResult.Count do
    if length(AResult[i]) = 0 then
      AResult.Delete(i)
    else
      inc(i);
end;

end.
