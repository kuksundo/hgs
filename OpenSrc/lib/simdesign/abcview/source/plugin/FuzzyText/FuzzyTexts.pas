unit FuzzyTexts;

interface

uses
  SysUtils, Classes, Inifiles;

// Load settings from ini
procedure LoadFromINI(AIniFile: string);
procedure SaveToIni(AIniFile: string);

// Initialisation routine
procedure CreateXRefTable;

// Create a blueprint from stream S into stream M
procedure CreateBlueprint(S: TStream; M: TStream);

// Compare two blueprints and return absolute difference
function BlueprintCompare(Data1: pointer; Size1: integer; Data2: pointer; Size2, Limit: integer): integer;

// Do we accept this file type for comparison?
function AcceptFiletype(AExt: string): boolean;

const

  cFuzzyTextLimitByTol: array[0..7] of integer =
    (0, 1, 2, 5, 10, 20, 50, 100);

  // Index method
  cftIndexBackgr = 0;
  cftIndexFilter = 1;

  // File diff method
  cftDiffNone    = 0;
  cftDiffAsLimit = 1;
  cftDiffSelect  = 2;

  // Process method
  cftProcessAll    = 0;
  cftProcessOnly   = 1;
  cftProcessExcept = 2;

var

  FAppFolder: string = '';
  FDllFolder: string = '';
  FInifile: string = '';

  FRegName: string;
  FRegKey: string;

  FAuthorised: boolean = False;

  FIndexMethod: integer = cftIndexFilter;
  FFileDiffMethod: integer = cftDiffNone;
  FDiffLimit: integer = 10;
  FProcessMethod: integer = cftProcessAll;
  FProcessOnly: string = '.txt;.log;.htm;.html;';
  FProcessExcept: string = '.exe;.dll';

  FTolLimits: array[0..7] of integer;

  FTolerance: integer;

const

  cFuzzyTextMagic: longword = $3E1F04DC; // Fuzzy text haxler for hardware code

implementation

uses
  Math;

var

  XRef: array[0..255] of byte;
  FEvaluation: boolean = False;

type

  TBlueprint = packed array[0..26] of word;

procedure LoadFromINI(AIniFile: string);
var
  i: integer;
  AIni: TInifile;
begin
  try
    AIni := TIniFile.Create(AIniFile);
    try
      FRegName := AIni.ReadString('Registration', 'Regname', '');
      FRegKey := AIni.ReadString('Registration', 'Regkey', '');
      FIndexMethod := AIni.ReadInteger('Options', 'IndexMethod', FIndexMethod);
      FFileDiffMethod := AIni.ReadInteger('Options', 'FileDiffMethod', FFileDiffMethod);
      FDiffLimit := AIni.ReadInteger('Options', 'DiffLimit', FDiffLimit);
      FProcessMethod := AIni.ReadInteger('Options', 'ProcessMethod', FProcessMethod);
      FProcessOnly := AIni.ReadString('Options', 'ProcessOnly', FProcessOnly);
      FProcessExcept := AIni.ReadString('Options', 'ProcessExcept', FProcessExcept);
      for i := 0 to 7 do
        FTolLimits[i] := AIni.ReadInteger('Options', Format('TolLimit%d',[i]), cFuzzyTextLimitByTol[i]);

    finally
      AIni.Free;
    end;
  except
  end;
end;

procedure SaveToIni(AIniFile: string);
var
  i: integer;
  AIni: TInifile;
begin
  try
    AIni := TIniFile.Create(AIniFile);
    try
      AIni.WriteString('Registration', 'Regname', FRegName);
      AIni.WriteString('Registration', 'Regkey', FRegKey);
      AIni.WriteInteger('Options', 'IndexMethod', FIndexMethod);
      AIni.WriteInteger('Options', 'FileDiffMethod', FFileDiffMethod);
      AIni.WriteInteger('Options', 'DiffLimit', FDiffLimit);
      AIni.WriteInteger('Options', 'ProcessMethod', FProcessMethod);
      AIni.WriteString('Options', 'ProcessOnly', FProcessOnly);
      AIni.WriteString('Options', 'ProcessExcept', FProcessExcept);
      for i := 0 to 7 do
        AIni.WriteInteger('Options', Format('TolLimit%d',[i]), FTolLimits[i]);
    finally
      AIni.Free;
    end;
  except
  end;
end;

procedure CreateXRefTable;
var
  i: integer;
begin
  // Zero out
  FillChar(XRef, SizeOf(XRef), 0);

  // Range "a..z" and "A..Z" map to the same 1..26
  for i := $41 to $5A do // "A..Z"
    XRef[i] := i - $40;
  for i := $61 to $7A do // "a..z"
    XRef[i] := i - $60;
end;

procedure CreateBlueprint(S: TStream; M: TStream);
// Create a blueprint from stream S into stream M
var
  i, Count: integer;
  Blue: TBlueprint;
  Buf: packed array[0..2047] of byte;
begin
  if not assigned(S) then exit;
  // zero
  FillChar(Blue, SizeOf(Blue), 0);
  S.Position := 0;

  // read the complete stream and translate into blueprint
  repeat
    Count := S.Read(Buf, SizeOf(Buf));
    for i := 0 to Count - 1 do
      inc(Blue[XRef[Buf[i]]]);
  until Count < SizeOf(Buf);

  // Now save the blueprint to M, skip Blue[0]
  M.Position := 0;
  M.Write(Blue[1], SizeOf(Word) * 26);
end;

function BlueprintCompare(Data1: pointer; Size1: integer; Data2: pointer; Size2, Limit: integer): integer;
var
  i: integer;
begin
  // Only process valid blueprints (Size > 0)
  if Size1 * Size2 = 0 then begin
    Result := $1FFFFFFF; // big!
    exit;
  end;
  // Loop trough and add up total absolute error
  Result := 0;
  for i := 0 to (Min(Size1, Size2) div 2) - 1 do begin
    Result := Result + Abs(PWordArray(Data1)^[i] - PWordArray(Data2)^[i]);
    if Result > Limit then
      exit;
  end;
end;

function AcceptFiletype(AExt: string): boolean;
begin
  case FProcessMethod of
  cftProcessAll: Result := True;
  cftProcessOnly:
    Result := Pos(uppercase(AExt + ';'), uppercase(FProcessOnly + ';')) > 0;
  cftProcessExcept:
    Result := not Pos(uppercase(AExt + ';'), uppercase(FProcessExcept + ';')) > 0;
  end;
end;


end.
