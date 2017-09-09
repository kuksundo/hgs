// Written with Delphi XE3 Pro
// Created Nov 24, 2012 by Darian Miller
unit DelphiVault.StringUtils;

interface

uses
  System.SysUtils;


  function Trim(const Source:string; const TrimThis:Char):string; overload;
  function Trim(const Source:string; const TrimThis: array of Char):string; overload;
  function Trim(const Source:string; const TrimThis:string):string; overload;
  function Trim(const Source:string; const TrimThis:TSysCharSet):string; overload;

  function CharInArray(SearchFor:Char; Source: array of Char):Boolean;
  function CharInString(SearchFor:Char; Source:string):Boolean;


implementation

// Based on answer by Rob Kennedy on Nov 21, 2012 to question:
// http://stackoverflow.com/questions/13486438/how-to-trim-any-character-or-a-substring-from-a-string
function Trim(const Source:string; const TrimThis:Char):string;
var
  First, Last:Integer;
begin
  First := 1;
  Last := Length(Source);
  while (First <= Last) and (Source[ First ] = TrimThis) do
    Inc(First);
  while (First < Last) and (Source[ Last ] = TrimThis) do
    Dec(Last);
  Result := Copy(Source, First, Last - First + 1);
end;


// Based on answer by Rob Kennedy on Nov 21, 2012 to question:
// http://stackoverflow.com/questions/13486438/how-to-trim-any-character-or-a-substring-from-a-string
function Trim(const Source:string; const TrimThis: array of Char):string;
var
  First, Last:Integer;
begin
  First := 1;
  Last := Length(Source);
  while (First <= Last) and (CharInArray(Source[ First ], TrimThis)) do
    Inc(First);
  while (First < Last) and (CharInArray(Source[ Last ], TrimThis)) do
    Dec(Last);
  Result := Copy(Source, First, Last - First + 1);
end;


// Based on answer by Rob Kennedy on Nov 21, 2012 to question:
// http://stackoverflow.com/questions/13486438/how-to-trim-any-character-or-a-substring-from-a-string
function Trim(const Source:string; const TrimThis:string):string;
var
  First, Last:Integer;
begin
  First := 1;
  Last := Length(Source);
  while (First <= Last) and (CharInString(Source[ First ], TrimThis)) do
    Inc(First);
  while (First < Last) and (CharInString(Source[ Last ], TrimThis)) do
    Dec(Last);
  Result := Copy(Source, First, Last - First + 1);
end;


// Based on answer by Rob Kennedy on Nov 21, 2012 to question:
// http://stackoverflow.com/questions/13486438/how-to-trim-any-character-or-a-substring-from-a-string
function Trim(const Source:string; const TrimThis:TSysCharSet):string;
var
  First, Last:Integer;
begin
  First := 1;
  Last := Length(Source);
  while (First <= Last) and (CharInSet(Source[ First ], TrimThis)) do
    Inc(First);
  while (First < Last) and (CharInSet(Source[ Last ], TrimThis)) do
    Dec(Last);
  Result := Copy(Source, First, Last - First + 1);
end;


// Based on answer by Rob Kennedy on Nov 21, 2012 to question:
// http://stackoverflow.com/questions/13486438/how-to-trim-any-character-or-a-substring-from-a-string
function CharInArray(SearchFor:Char; Source: array of Char):Boolean;
var
  i:Integer;
begin
  Result := True;
  for i := low(Source) to high(Source) do
    if Source[ i ] = SearchFor then
      exit;
  Result := False;
end;

// Based on answer by Rob Kennedy on Nov 21, 2012 to question:
// http://stackoverflow.com/questions/13486438/how-to-trim-any-character-or-a-substring-from-a-string
function CharInString(SearchFor:Char; Source:string):Boolean;
var
  i:Integer;
begin
  Result := True;
  for i := low(Source) to high(Source) do
    if Source[ i ] = SearchFor then
      exit;
  Result := False;
end;


end.
