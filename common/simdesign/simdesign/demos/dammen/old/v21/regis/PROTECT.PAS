unit Protect;

INTERFACE

uses Dos,Objects;

var InstError: word;

procedure CreateDiskCode(Disk: byte; var Code: word; var OK: boolean);
procedure InsertDiskCode(FileName: string; Pos: longint; DskNr,RegNr: word; var OK: boolean);
procedure InsertDiskString(FileName: string; InsertString: Pstring; Pos: longint; var OK: boolean);
procedure SearchFile(SearchFile,SearchString: string;
               var SearchPos: longint; var SearchCount: word);
function Word2Hex(W: Word): string;
function Hex2Word(H: string): word;
function LongInt2Hex(L: LongInt): string;
function Hex2LongInt(H: string): longint;

function GetCurDir: DirStr;
function DriveValid(Drive: Char): Boolean;
function PathValid(var Path: PathStr): Boolean;

procedure MakeUpcase(S: Pstring);

IMPLEMENTATION

procedure CreateDiskCode(Disk: byte; var Code: word; var OK: boolean);
  var DirInfo: SearchRec;
      x: word;
      Dir: string;
  begin
    Code:=0;
    GetDir(Disk,Dir);
    FindFirst(Dir[1]+':\*.*', VolumeID, DirInfo);
    if DosError = 0 then
    begin
      OK:=true;
      for x:=1 to Length(DirInfo.Name) do
        Code:=Code+Ord(DirInfo.Name[x]);
      Code:=Code+LongRec(DirInfo.Time).Lo+LongRec(DirInfo.Time).Hi;
    end else
    begin
      OK:=false;
      InstError:=5;
    end;
  end;

procedure InsertDiskCode(FileName: string; Pos: longint; DskNr,RegNr: word; var OK: boolean);
  var S: TBufStream;
  begin
    S.Init(FileName,stOpenWrite,1024);
    if S.Status<>stOK then
      OK:=false
    else
    begin
      OK:=true;
      S.Seek(Pos);
      S.Write(DskNr,2);
      S.Write(RegNr,2);
    end;
    S.Done;
  end;

procedure InsertDiskString(FileName: string; InsertString: Pstring; Pos: longint; var OK: boolean);
  var S: TBufStream;
      x: integer;
  begin
    S.Init(FileName,stOpenWrite,1024);
    if S.Status<>stOK then
      OK:=false
    else
    begin
      OK:=true;
      S.Seek(Pos);
      for x:=1 to length(InsertString^) do
      begin
        S.Write(InsertString^[x],1);
      end;
    end;
    S.Done;
  end;

procedure SearchFile(SearchFile,SearchString: string;
               var SearchPos: longint; var SearchCount: word);
  var S: TBufStream;
      CurPos,Size: LongInt;
  function FindAtPos: boolean;
    var Result: boolean;
        x: integer;
        b: byte;
    begin
      Result:=true;
      x:=1;
      while (x<=Length(SearchString)) and Result do
      begin
        S.Read(b,1);
        if b<>ord(SearchString[x]) then Result:=false;
        inc(x);
      end;
      if Result then
      begin
        SearchPos:=CurPos;
        CurPos:=S.GetPos;
      end else
      begin
        inc(CurPos);
        if x>2 then
          S.Seek(CurPos);
      end;
      FindAtPos:=Result;
    end;
  begin
    CurPos:=0;
    SearchPos:=0;
    SearchCount:=0;
    S.Init(SearchFile,stOpenRead,1024);
    if S.Status=stOK then
    begin
      Size:=S.GetSize;
      While CurPos<=Size-Length(SearchString) do
      begin
        if FindAtPos then
          inc(SearchCount);
      end;
    end;
    S.Done;
  end;

function Word2Hex(W: Word): string;
  const HexChars: array[0..15] of char='0123456789ABCDEF';
  var Result: string[4];
  begin
    Result:=HexChars[WordRec(W).Hi div 16]+HexChars[WordRec(W).Hi mod 16]+
            HexChars[WordRec(W).Lo div 16]+HexChars[WordRec(W).Lo mod 16];
    Result[0]:=chr(4);
    Word2Hex:=Result;
  end;

function Hex2Word(H: string): word;
  function HexVal(Ch: char): byte;
    begin
      case Ch of
      '0'..'9': HexVal:=ord(Ch)-ord('0');
      'A'..'F': HexVal:=ord(Ch)-ord('A')+10;
      end;
    end;
  begin
    MakeUpcase(@H);
    Hex2Word:=(HexVal(H[1])*16+HexVal(H[2]))*256+HexVal(H[3])*16+HexVal(H[4]);
  end;

function LongInt2Hex(L: LongInt): string;
  begin
    LongInt2Hex:=Word2Hex(LongRec(L).Hi)+':'+Word2Hex(LongRec(L).Lo);
  end;

function Hex2LongInt(H: string): longint;
  var L: longint;
      Hs: string[4];
  begin
    Hs:=Copy(H,1,4);
    LongRec(L).Hi:=Hex2Word(Hs);
    Hs:=Copy(H,6,4);
    LongRec(L).Lo:=Hex2Word(Hs);
    Hex2LongInt:=L;
  end;

function GetCurDir: DirStr;
var
  CurDir: DirStr;
begin
  GetDir(0, CurDir);
  if Length(CurDir) > 3 then
  begin
    Inc(CurDir[0]);
    CurDir[Length(CurDir)] := '\';
  end;
  GetCurDir := CurDir;
end;
 
function DriveValid(Drive: Char): Boolean; assembler;
asm
	MOV	DL,Drive
        MOV	AH,36H
        SUB	DL,'A'-1
        INT	21H
        INC	AX
        JE	@@2
@@1:	MOV	AL,1
@@2:
end;

function PathValid(var Path: PathStr): Boolean;
var
  ExpPath: PathStr;
  F: File;
  SR: SearchRec;
begin
  ExpPath := FExpand(Path);
  if Length(ExpPath) <= 3 then PathValid := DriveValid(ExpPath[1])
  else
  begin
    if ExpPath[Length(ExpPath)] = '\' then Dec(ExpPath[0]);
    FindFirst(ExpPath, Directory, SR);
    PathValid := (DosError = 0) and (SR.Attr and Directory <> 0);
  end;
end;

procedure MakeUpcase(S: Pstring);
  var x: integer;
  begin
    for x:=1 to length(S^) do
      S^[x]:=Upcase(S^[x]);
  end;

end.