{+--------------------------------------------------------------------------+
 | Class:       TmwPasLex
 | Created:     07.98 - 06.99
 | Author:      Martin Waldenburg
 | Description: A very fast Pascal tokenizer.
 | Version:     1.88
 | Copyright (c) 1998, 1999 Martin Waldenburg
 | All rights reserved.
 |
 | June 15th 1999.
 | I'd like to invite the Delphi community to develop
 | it further and to create a full featured Object Pascal parser.
 | The lizence to this software and all previous versions
 | has been moved to the MOZILLA PUBLIC LICENSE Version 1.1
 | http://www.mozilla.org/NPL/NPL-1_1Final.html
 | Martin.Waldenburg@T-Online.de
 +--------------------------------------------------------------------------+}

unit mwPasLex;

interface

uses
  SysUtils, Windows, Messages, Classes, Controls, mwPasLexTypes;

var
  Identifiers: array[#0..#255] of ByteBool;
  mHashTable: array[#0..#255] of Integer;

type
  TmwPasLex = class(TObject)
  private
    fCommentState: TCommentState;
    fOrigin: PChar;
    fProcTable: array[#0..#255] of procedure of Object;
    Run: Integer;
    TempRun: Integer;
    fIdentFuncTable: array[0..191] of function: TptTokenKind of Object;
    fTokenPos: Integer;
    fLineNumber: Integer;
    FTokenID: TptTokenKind;
    fLastIdentPos: Integer;
    fLastNoJunk: TptTokenKind;
    fLastNoJunkPos: Integer;
    fLinePos: Integer;
    fExID: TptTokenKind;
    fInternalStoredStatus: TmwPasLexStatus;
    fStoredStatus: TmwPasLexStatus;
    fLookAheadCount: Integer;
    fInternalLookAheadCount: Integer;
    function KeyHash: Integer;
    function KeyComp(aKey: String): Boolean;
    function Func15: TptTokenKind;
    function Func19: TptTokenKind;
    function Func20: TptTokenKind;
    function Func21: TptTokenKind;
    function Func23: TptTokenKind;
    function Func25: TptTokenKind;
    function Func27: TptTokenKind;
    function Func28: TptTokenKind;
    function Func32: TptTokenKind;
    function Func33: TptTokenKind;
    function Func35: TptTokenKind;
    function Func36: TptTokenKind;
    function Func37: TptTokenKind;
    function Func38: TptTokenKind;
    function Func39: TptTokenKind;
    function Func40: TptTokenKind;
    function Func41: TptTokenKind;
    function Func43: TptTokenKind;
    function Func44: TptTokenKind;
    function Func45: TptTokenKind;
    function Func46: TptTokenKind;
    function Func47: TptTokenKind;
    function Func49: TptTokenKind;
    function Func52: TptTokenKind;
    function Func54: TptTokenKind;
    function Func55: TptTokenKind;
    function Func56: TptTokenKind;
    function Func57: TptTokenKind;
    function Func59: TptTokenKind;
    function Func60: TptTokenKind;
    function Func61: TptTokenKind;
    function Func62: TptTokenKind;
    function Func63: TptTokenKind;
    function Func64: TptTokenKind;
    function Func65: TptTokenKind;
    function Func66: TptTokenKind;
    function Func69: TptTokenKind;
    function Func71: TptTokenKind;
    function Func73: TptTokenKind;
    function Func75: TptTokenKind;
    function Func76: TptTokenKind;
    function Func78: TptTokenKind;
    function Func79: TptTokenKind;
    function Func81: TptTokenKind;
    function Func84: TptTokenKind;
    function Func85: TptTokenKind;
    function Func87: TptTokenKind;
    function Func88: TptTokenKind;
    function Func91: TptTokenKind;
    function Func92: TptTokenKind;
    function Func94: TptTokenKind;
    function Func95: TptTokenKind;
    function Func96: TptTokenKind;
    function Func97: TptTokenKind;
    function Func98: TptTokenKind;
    function Func99: TptTokenKind;
    function Func100: TptTokenKind;
    function Func101: TptTokenKind;
    function Func102: TptTokenKind;
    function Func103: TptTokenKind;
    function Func104: TptTokenKind;
    function Func105: TptTokenKind;
    function Func106: TptTokenKind;
    function Func107: TptTokenKind;
    function Func108: TptTokenKind;
    function Func112: TptTokenKind;
    function Func117: TptTokenKind;
    function Func123: TptTokenKind;
    function Func126: TptTokenKind;
    function Func128: TptTokenKind;
    function Func129: TptTokenKind;
    function Func130: TptTokenKind;
    function Func132: TptTokenKind;
    function Func133: TptTokenKind;
    function Func136: TptTokenKind;
    function Func141: TptTokenKind;
    function Func143: TptTokenKind;
    function Func166: TptTokenKind;
    function Func167: TptTokenKind;
    function Func168: TptTokenKind;
    function Func191: TptTokenKind;
    function AltFunc: TptTokenKind;
    procedure FillStatusRecord(var Value: TmwPasLexStatus);
    procedure InitIdent;
    function IdentKind: TptTokenKind;
    procedure SetOrigin(NewValue: PChar);
    procedure SetRunPos(Value: Integer);
    procedure MakeMethodTables;
    procedure AddressOpProc;
    procedure AsciiCharProc;
    procedure AnsiProc;
    procedure BorProc;
    procedure BraceCloseProc;
    procedure BraceOpenProc;
    procedure ColonProc;
    procedure CommaProc;
    procedure CRProc;
    procedure EqualProc;
    procedure GreaterProc;
    procedure IdentProc;
    procedure IntegerProc;
    procedure LFProc;
    procedure LowerProc;
    procedure MinusProc;
    procedure NullProc;
    procedure NumberProc;
    procedure PlusProc;
    procedure PointerSymbolProc;
    procedure PointProc;
    procedure RoundCloseProc;
    procedure RoundOpenProc;
    procedure SemiColonProc;
    procedure SlashProc;
    procedure SpaceProc;
    procedure SquareCloseProc;
    procedure SquareOpenProc;
    procedure StarProc;
    procedure StringProc;
    procedure SymbolProc;
    procedure UnknownProc;
    function GetToken: String;
    function GetTokenLen: Integer;
    function GetCommentState: Pointer;
    function GetCompilerDirective: String;
    function GetLastIdentifier: String;
    procedure SetCommentState(const Value: Pointer);
    procedure InitLine;
    procedure SetLine(const Value: String);
    function GetStatus: TmwPasLexStatus;
    procedure SetStatus(const Value: TmwPasLexStatus);
    function GetDirectiveKind: TptTokenKind;
    function GetDirectiveParam: String;
    procedure InternalBeginLookAhead;
    procedure InternalEndLookAhead;
    procedure BeginNewLookAhead;
    procedure SetInternalStoredStatus;
    procedure SetStoredStatus;
    function GetStringContent: String;
    function GetIsJunk: Boolean;
    function GetIsSpace: Boolean;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    procedure Ahead(var ID1, ID2, ID3, ExID1, ExID2, ExID3: TptTokenKind);
    procedure OneAhead(var ID1, ExID1: TptTokenKind);
    function CharAhead: Char;
    procedure Next;
    procedure NextID(ID: TptTokenKind);
    procedure NextNoJunk;
    procedure NextNoSpace;
    procedure Init;
    function FirstInLine: Boolean;
    function LastInLine: Boolean;
    function AloneInLine: Boolean;
    procedure BeginLookAhead;
    procedure EndLookAhead;
    property CommentState: Pointer read GetCommentState write SetCommentState;
    property CompilerDirective: String read GetCompilerDirective;
    property DirectiveParam: String read GetDirectiveParam;
    property IsJunk: Boolean read GetIsJunk;
    property IsSpace: Boolean read GetIsSpace;
    property LastIdentifier: String read GetLastIdentifier;
    property LastIdentPos: Integer read fLastIdentPos;
    property LastNoJunk: TptTokenKind read fLastNoJunk;
    property LastNoJunkPos: Integer read fLastNoJunkPos;
    property Line: String write SetLine;
    property LineNumber: Integer read fLineNumber;
    property LinePos: Integer read fLinePos;
    property LookAheadCount: Integer read fLookAheadCount;
    property Origin: PChar read fOrigin write SetOrigin;
    property RunPos: Integer read Run write SetRunPos;
    property Token: String read GetToken;
    property TokenLen: Integer read GetTokenLen;
    property TokenPos: Integer read fTokenPos;
    property TokenID: TptTokenKind read FTokenID;
    property ExID: TptTokenKind read fExID;
    property Status: TmwPasLexStatus read GetStatus write SetStatus;
    property StoredStatus: TmwPasLexStatus read fStoredStatus write fStoredStatus;
    property StringContent: String read GetStringContent;
  end;

implementation

procedure MakeIdentTable;
var
  I, J: Char;
begin
  for I := #0 to #255 do
  begin
    Case I of
      '_', '0'..'9', 'a'..'z', 'A'..'Z': Identifiers[I] := True;
    else Identifiers[I] := False;
    end;
    J := UpperCase(I)[1];
    Case I of
      'a'..'z', 'A'..'Z', '_': mHashTable[I] := Ord(J) - 64;
    else mHashTable[Char(I)] := 0;
    end;
  end;
end;

function TmwPasLex.CharAhead: Char;
var
  RunAhead: Integer;
begin
  RunAhead := Run;
  while fOrigin[RunAhead] in [#1..#32] do inc(RunAhead);
  Result := fOrigin[RunAhead];
end;

procedure TmwPasLex.InitIdent;
var
  I: Integer;
begin
  for I := 0 to 191 do
    Case I of
      15: fIdentFuncTable[I] := Func15;
      19: fIdentFuncTable[I] := Func19;
      20: fIdentFuncTable[I] := Func20;
      21: fIdentFuncTable[I] := Func21;
      23: fIdentFuncTable[I] := Func23;
      25: fIdentFuncTable[I] := Func25;
      27: fIdentFuncTable[I] := Func27;
      28: fIdentFuncTable[I] := Func28;
      32: fIdentFuncTable[I] := Func32;
      33: fIdentFuncTable[I] := Func33;
      35: fIdentFuncTable[I] := Func35;
      36: fIdentFuncTable[I] := Func36;
      37: fIdentFuncTable[I] := Func37;
      38: fIdentFuncTable[I] := Func38;
      39: fIdentFuncTable[I] := Func39;
      40: fIdentFuncTable[I] := Func40;
      41: fIdentFuncTable[I] := Func41;
      43: fIdentFuncTable[I] := Func43;
      44: fIdentFuncTable[I] := Func44;
      45: fIdentFuncTable[I] := Func45;
      46: fIdentFuncTable[I] := Func46;
      47: fIdentFuncTable[I] := Func47;
      49: fIdentFuncTable[I] := Func49;
      52: fIdentFuncTable[I] := Func52;
      54: fIdentFuncTable[I] := Func54;
      55: fIdentFuncTable[I] := Func55;
      56: fIdentFuncTable[I] := Func56;
      57: fIdentFuncTable[I] := Func57;
      59: fIdentFuncTable[I] := Func59;
      60: fIdentFuncTable[I] := Func60;
      61: fIdentFuncTable[I] := Func61;
      62: fIdentFuncTable[I] := Func62;
      63: fIdentFuncTable[I] := Func63;
      64: fIdentFuncTable[I] := Func64;
      65: fIdentFuncTable[I] := Func65;
      66: fIdentFuncTable[I] := Func66;
      69: fIdentFuncTable[I] := Func69;
      71: fIdentFuncTable[I] := Func71;
      73: fIdentFuncTable[I] := Func73;
      75: fIdentFuncTable[I] := Func75;
      76: fIdentFuncTable[I] := Func76;
      78: fIdentFuncTable[I] := Func78;
      79: fIdentFuncTable[I] := Func79;
      81: fIdentFuncTable[I] := Func81;
      84: fIdentFuncTable[I] := Func84;
      85: fIdentFuncTable[I] := Func85;
      87: fIdentFuncTable[I] := Func87;
      88: fIdentFuncTable[I] := Func88;
      91: fIdentFuncTable[I] := Func91;
      92: fIdentFuncTable[I] := Func92;
      94: fIdentFuncTable[I] := Func94;
      95: fIdentFuncTable[I] := Func95;
      96: fIdentFuncTable[I] := Func96;
      97: fIdentFuncTable[I] := Func97;
      98: fIdentFuncTable[I] := Func98;
      99: fIdentFuncTable[I] := Func99;
      100: fIdentFuncTable[I] := Func100;
      101: fIdentFuncTable[I] := Func101;
      102: fIdentFuncTable[I] := Func102;
      103: fIdentFuncTable[I] := Func103;
      104: fIdentFuncTable[I] := Func104;
      105: fIdentFuncTable[I] := Func105;
      106: fIdentFuncTable[I] := Func106;
      107: fIdentFuncTable[I] := Func107;
      108: fIdentFuncTable[I] := Func108;
      112: fIdentFuncTable[I] := Func112;
      117: fIdentFuncTable[I] := Func117;
      123: fIdentFuncTable[I] := Func123;
      126: fIdentFuncTable[I] := Func126;
      128: fIdentFuncTable[I] := Func128;
      129: fIdentFuncTable[I] := Func129;
      130: fIdentFuncTable[I] := Func130;
      132: fIdentFuncTable[I] := Func132;
      133: fIdentFuncTable[I] := Func133;
      136: fIdentFuncTable[I] := Func136;
      141: fIdentFuncTable[I] := Func141;
      143: fIdentFuncTable[I] := Func143;
      166: fIdentFuncTable[I] := Func166;
      167: fIdentFuncTable[I] := Func167;
      168: fIdentFuncTable[I] := Func168;
      191: fIdentFuncTable[I] := Func191;
    else fIdentFuncTable[I] := AltFunc;
    end;
end;

function TmwPasLex.KeyHash: Integer;
begin
  Result := 0;
  while Identifiers[fOrigin[Run]] do
  begin
    inc(Result, mHashTable[fOrigin[Run]]);
    inc(Run);
  end;
end; { KeyHash }

function TmwPasLex.KeyComp(aKey: String): Boolean;
var
  I: Integer;
  Temp: PChar;
begin
  if Length(aKey) = TokenLen then
  begin
    Temp := fOrigin + fTokenPos;
    Result := True;
    for i := 1 to TokenLen do
    begin
      if mHashTable[Temp^] <> mHashTable[aKey[i]] then
      begin
        Result := False;
        break;
      end;
      inc(Temp);
    end;
  end else Result := False;
end; { KeyComp }

function TmwPasLex.Func15: TptTokenKind;
begin
  if KeyComp('If') then Result := ptIf else Result := ptIdentifier;
end;

function TmwPasLex.Func19: TptTokenKind;
begin
  if KeyComp('Do') then Result := ptDo else
    if KeyComp('And') then Result := ptAnd else Result := ptIdentifier;
end;

function TmwPasLex.Func20: TptTokenKind;
begin
  if KeyComp('As') then Result := ptAs else Result := ptIdentifier;
end;

function TmwPasLex.Func21: TptTokenKind;
begin
  if KeyComp('Of') then Result := ptOf else Result := ptIdentifier;
end;

function TmwPasLex.Func23: TptTokenKind;
begin
  if KeyComp('End') then
    Case CharAhead of
      '.':
        begin
          Result := ptTheEnd;
          inc(Run);
        end;
    else Result := ptEnd
    end
  else
    if KeyComp('In') then Result := ptIn else Result := ptIdentifier;
end;

function TmwPasLex.Func25: TptTokenKind;
begin
  if KeyComp('Far') then fExID := ptFar;
  Result := ptIdentifier;
end;

function TmwPasLex.Func27: TptTokenKind;
begin
  if KeyComp('Cdecl') then fExID := ptCdecl;
  Result := ptIdentifier;
end;

function TmwPasLex.Func28: TptTokenKind;
begin
  if KeyComp('Read') then
  begin
    fExID := ptRead;
    Result := ptIdentifier;
  end else
    if KeyComp('Case') then Result := ptCase else
      if KeyComp('Is') then Result := ptIs else Result := ptIdentifier;
end;

function TmwPasLex.Func32: TptTokenKind;
begin
  if KeyComp('File') then Result := ptFile else
    if KeyComp('Label') then Result := ptLabel else
      if KeyComp('Mod') then Result := ptMod else Result := ptIdentifier;
end;

function TmwPasLex.Func33: TptTokenKind;
begin
  if KeyComp('Or') then Result := ptOr else
    if KeyComp('Name') then
    begin
      fExID := ptName;
      Result := ptIdentifier;
    end else
      if KeyComp('Asm') then Result := ptAsm else Result := ptIdentifier;
end;

function TmwPasLex.Func35: TptTokenKind;
begin
  if KeyComp('Nil') then Result := ptNil else
    if KeyComp('To') then Result := ptTo else
      if KeyComp('Div') then Result := ptDiv else Result := ptIdentifier;
end;

function TmwPasLex.Func36: TptTokenKind;
begin
  if KeyComp('Real') then fExID := ptReal else
    if KeyComp('Real48') then fExID := ptReal48;
  Result := ptIdentifier;
end;

function TmwPasLex.Func37: TptTokenKind;
begin
  if KeyComp('Begin') then Result := ptBegin else Result := ptIdentifier;
end;

function TmwPasLex.Func38: TptTokenKind;
begin
  if KeyComp('Near') then fExID := ptNear;
  Result := ptIdentifier;
end;

function TmwPasLex.Func39: TptTokenKind;
begin
  if KeyComp('For') then Result := ptFor else
    if KeyComp('Shl') then Result := ptShl else Result := ptIdentifier;
end;

function TmwPasLex.Func40: TptTokenKind;
begin
  if KeyComp('Packed') then Result := ptPacked else Result := ptIdentifier;
end;

function TmwPasLex.Func41: TptTokenKind;
begin
  if KeyComp('Var') then Result := ptVar else
    if KeyComp('Else') then Result := ptElse else Result := ptIdentifier;
end;

function TmwPasLex.Func43: TptTokenKind;
begin
  if KeyComp('Int64') then fExID := ptInt64;
  Result := ptIdentifier;
end;

function TmwPasLex.Func44: TptTokenKind;
begin
  if KeyComp('Set') then Result := ptSet else
    if KeyComp('Package') then
    begin
      fExID := ptPackage;
      Result := ptIdentifier;
    end else Result := ptIdentifier;
end;

function TmwPasLex.Func45: TptTokenKind;
begin
  if KeyComp('Shr') then Result := ptShr else Result := ptIdentifier;
end;

function TmwPasLex.Func46: TptTokenKind;
begin
  if KeyComp('PChar') then fExId := ptPChar;
    Result := ptIdentifier;
end;

function TmwPasLex.Func47: TptTokenKind;
begin
  if KeyComp('Then') then Result := ptThen else
    if KeyComp('Comp') then
    begin
      fExID := ptComp;
      Result := ptIdentifier;
    end else Result := ptIdentifier;
end;

function TmwPasLex.Func49: TptTokenKind;
begin
  if KeyComp('Not') then Result := ptNot else Result := ptIdentifier;
end;

function TmwPasLex.Func52: TptTokenKind;
begin
  if KeyComp('Byte') then
  begin
    fExID := ptByte;
    Result := ptIdentifier;
  end else
    if KeyComp('Raise') then Result := ptRaise else
      if KeyComp('Pascal') then
      begin
        fExID := ptPascal;
        Result := ptIdentifier;
      end else Result := ptIdentifier;
end;

function TmwPasLex.Func54: TptTokenKind;
begin
  if KeyComp('Class') then Result := ptClass else Result := ptIdentifier;
end;

function TmwPasLex.Func55: TptTokenKind;
begin
  if KeyComp('Object') then Result := ptObject else Result := ptIdentifier;
end;

function TmwPasLex.Func56: TptTokenKind;
begin
  if KeyComp('Index') then
  begin
    fExID := ptIndex;
    Result := ptIdentifier;
  end else
    if KeyComp('Out') then Result := ptOut else Result := ptIdentifier;
end;

function TmwPasLex.Func57: TptTokenKind;
begin
  if KeyComp('While') then Result := ptWhile else
    if KeyComp('Xor') then Result := ptXor else
      if KeyComp('Goto') then Result := ptGoto else Result := ptIdentifier;
end;

function TmwPasLex.Func59: TptTokenKind;
begin
  if KeyComp('Safecall') then fExID := ptSafecall else
    if KeyComp('Double') then fExID := ptDouble;
  Result := ptIdentifier;
end;

function TmwPasLex.Func60: TptTokenKind;
begin
  if KeyComp('Word') then
  begin
    fExID := ptWord;
    Result := ptIdentifier;
  end else
    if KeyComp('With') then Result := ptWith else Result := ptIdentifier;
end;

function TmwPasLex.Func61: TptTokenKind;
begin
  if KeyComp('Dispid') then fExID := ptDispid;
  Result := ptIdentifier;
end;

function TmwPasLex.Func62: TptTokenKind;
begin
  if KeyComp('Cardinal') then fExID := ptCardinal;
  Result := ptIdentifier;
end;

function TmwPasLex.Func63: TptTokenKind;
begin
  if KeyComp('Public') then
  begin
    fExID := ptPublic;
    Result := ptIdentifier;
  end else
    if KeyComp('Array') then Result := ptArray else
      if KeyComp('Try') then Result := ptTry else
        if KeyComp('Record') then Result := ptRecord else
          if KeyComp('Inline') then Result := ptInline else Result := ptIdentifier;
end;

function TmwPasLex.Func64: TptTokenKind;
begin
  if KeyComp('Boolean') then
  begin
    fExID := ptBoolean;
    Result := ptIdentifier;
  end else
    if KeyComp('DWORD') then
    begin
      fExID := ptDWORD;
      Result := ptIdentifier;
    end else
      if KeyComp('Uses') then Result := ptUses else
        if KeyComp('Unit') then Result := ptUnit else Result := ptIdentifier;
end;

function TmwPasLex.Func65: TptTokenKind;
begin
  if KeyComp('Repeat') then Result := ptRepeat else Result := ptIdentifier;
end;

function TmwPasLex.Func66: TptTokenKind;
begin
  if KeyComp('Single') then
  begin
    fExID := ptSingle;
    Result := ptIdentifier;
  end else
    if KeyComp('Type') then Result := ptType else Result := ptIdentifier;
end;

function TmwPasLex.Func69: TptTokenKind;
begin
  if KeyComp('Default') then fExID := ptDefault else
    if KeyComp('Message') then fExID := ptMessage else
      if KeyComp('Dynamic') then fExID := ptDynamic;
  Result := ptIdentifier;
end;

function TmwPasLex.Func71: TptTokenKind;
begin
  if KeyComp('Stdcall') then
  begin
    fExID := ptStdcall;
    Result := ptIdentifier;
  end else
    if KeyComp('Const') then Result := ptConst else Result := ptIdentifier;
end;

function TmwPasLex.Func73: TptTokenKind;
begin
  if KeyComp('Except') then Result := ptExcept else Result := ptIdentifier;
end;

function TmwPasLex.Func75: TptTokenKind;
begin
  if KeyComp('Write') then fExID := ptWrite;
  Result := ptIdentifier;
end;

function TmwPasLex.Func76: TptTokenKind;
begin
  if KeyComp('Until') then Result := ptUntil else Result := ptIdentifier;
end;

function TmwPasLex.Func78: TptTokenKind;
begin
  if KeyComp('Integer') then fExID := ptInteger;
  Result := ptIdentifier;
end;

function TmwPasLex.Func79: TptTokenKind;
begin
  if KeyComp('Finally') then Result := ptFinally else Result := ptIdentifier;
end;

function TmwPasLex.Func81: TptTokenKind;
begin
  if KeyComp('Extended') then
  begin
    fExID := ptExtended;
    Result := ptIdentifier;
  end else
    if KeyComp('Stored') then
    begin
      fExID := ptStored;
      Result := ptIdentifier;
    end else
      if KeyComp('Interface') then
      begin
        if LastNoJunk = ptEqual then Result := ptInterface else
          Result := ptInterfaceStart
      end else Result := ptIdentifier;
end;

function TmwPasLex.Func84: TptTokenKind;
begin
  if KeyComp('Abstract') then fExID := ptAbstract;
  Result := ptIdentifier;
end;

function TmwPasLex.Func85: TptTokenKind;
begin
  if KeyComp('Library') then Result := ptLibrary else
    if KeyComp('Forward') then
    begin
      fExID := ptForward;
      Result := ptIdentifier;
    end else
      if KeyComp('Variant') then
      begin
        fExID := ptVariant;
        Result := ptIdentifier;
      end else Result := ptIdentifier;
end;

function TmwPasLex.Func87: TptTokenKind;
begin
  if KeyComp('String') then Result := ptString else Result := ptIdentifier;
end;

function TmwPasLex.Func88: TptTokenKind;
begin
  if KeyComp('Program') then Result := ptProgram else Result := ptIdentifier;
end;

function TmwPasLex.Func91: TptTokenKind;
begin
  if KeyComp('Downto') then Result := ptDownto else
    if KeyComp('Private') then
    begin
      fExID := ptPrivate;
      Result := ptIdentifier;
    end else
      if KeyComp('Longint') then
      begin
        fExID := ptLongint;
        Result := ptIdentifier;
      end else Result := ptIdentifier;
end;

function TmwPasLex.Func92: TptTokenKind;
begin
  if KeyComp('Inherited') then Result := ptInherited else
    if KeyComp('LongBool') then
    begin
      fExID := ptLongBool;
      Result := ptIdentifier;
    end else
{$IFDEF VER120}
      if KeyComp('Overload') then
      begin
        fExID := ptOverload;
        Result := ptIdentifier;
      end else
{$ENDIF}
        Result := ptIdentifier;
end;

function TmwPasLex.Func94: TptTokenKind;
begin
  if KeyComp('Resident') then fExID := ptResident else
    if KeyComp('Assembler') then fExID := ptAssembler else
      if KeyComp('Readonly') then fExID := ptReadonly;
  Result := ptIdentifier;
end;

function TmwPasLex.Func95: TptTokenKind;
begin
  if KeyComp('Contains') then fExID := ptContains else
    if KeyComp('Absolute') then fExID := ptAbsolute;
  Result := ptIdentifier;
end;

function TmwPasLex.Func96: TptTokenKind;
begin
  if KeyComp('ByteBool') then fExID := ptByteBool else
    if KeyComp('Override') then fExID := ptOverride else
      if KeyComp('Published') then fExID := ptPublished;
  Result := ptIdentifier;
end;

function TmwPasLex.Func97: TptTokenKind;
begin
  if KeyComp('Threadvar') then Result := ptThreadvar else Result := ptIdentifier;
end;

function TmwPasLex.Func98: TptTokenKind;
begin
  if KeyComp('Export') then fExID := ptExport else
    if KeyComp('Nodefault') then fExID := ptNodefault;
  Result := ptIdentifier;
end;

function TmwPasLex.Func99: TptTokenKind;
begin
  if KeyComp('External') then fExID := ptExternal;
  Result := ptIdentifier;
end;

function TmwPasLex.Func100: TptTokenKind;
begin
  if KeyComp('Automated') then fExID := ptAutomated else
    if KeyComp('Smallint') then fExID := ptSmallint;
  Result := ptIdentifier;
end;

function TmwPasLex.Func101: TptTokenKind;
begin
  if KeyComp('Register') then fExID := ptRegister;
  Result := ptIdentifier;
end;

function TmwPasLex.Func102: TptTokenKind;
begin
  if KeyComp('Function') then Result := ptFunction else Result := ptIdentifier;
end;

function TmwPasLex.Func103: TptTokenKind;
begin
  if KeyComp('Virtual') then fExID := ptVirtual;
  Result := ptIdentifier;
end;

function TmwPasLex.Func104: TptTokenKind;
begin
  if KeyComp('WordBool') then fExID := ptWordBool;
  Result := ptIdentifier;
end;

function TmwPasLex.Func105: TptTokenKind;
begin
  if KeyComp('Procedure') then Result := ptProcedure else Result := ptIdentifier;
end;

function TmwPasLex.Func106: TptTokenKind;
begin
  if KeyComp('Protected') then fExID := ptProtected;
  Result := ptIdentifier;
end;

function TmwPasLex.Func107: TptTokenKind;
begin
  if KeyComp('Currency') then fExID := ptCurrency;
  Result := ptIdentifier;
end;

function TmwPasLex.Func108: TptTokenKind;
begin
  if KeyComp('Longword') then fExID := ptLongword;
  Result := ptIdentifier;
end;

function TmwPasLex.Func112: TptTokenKind;
begin
  if KeyComp('Requires') then fExID := ptRequires;
  Result := ptIdentifier;
end;

function TmwPasLex.Func117: TptTokenKind;
begin
  if KeyComp('Exports') then Result := ptExports else
    if KeyComp('OleVariant') then
    begin
      fExID := ptOleVariant;
      Result := ptIdentifier;
    end else Result := ptIdentifier;
end;

function TmwPasLex.Func123: TptTokenKind;
begin
  if KeyComp('Shortint') then fExID := ptShortint;
  Result := ptIdentifier;
end;

function TmwPasLex.Func126: TptTokenKind;
begin
{$IFDEF VER120}
  if KeyComp('Implements') then fExID := ptImplements;
{$ENDIF}
  Result := ptIdentifier;
end;

function TmwPasLex.Func128: TptTokenKind;
begin
  if KeyComp('WideString') then fExID := ptWideString;
  Result := ptIdentifier;
end;

function TmwPasLex.Func129: TptTokenKind;
begin
  if KeyComp('Dispinterface') then Result := ptDispinterface else Result := ptIdentifier;
end;

function TmwPasLex.Func130: TptTokenKind;
begin
  if KeyComp('AnsiString') then fExID := ptAnsiString;
  Result := ptIdentifier;
end;

function TmwPasLex.Func132: TptTokenKind;
begin
{$IFDEF VER120}
  if KeyComp('Reintroduce') then fExID := ptReintroduce;
{$ENDIF}
  Result := ptIdentifier;
end;

function TmwPasLex.Func133: TptTokenKind;
begin
  if KeyComp('Property') then Result := ptProperty else Result := ptIdentifier;
end;

function TmwPasLex.Func136: TptTokenKind;
begin
  if KeyComp('Finalization') then Result := ptFinalization else Result := ptIdentifier;
end;

function TmwPasLex.Func141: TptTokenKind;
begin
  if KeyComp('Writeonly') then fExID := ptWriteonly;
  Result := ptIdentifier;
end;

function TmwPasLex.Func143: TptTokenKind;
begin
  if KeyComp('Destructor') then Result := ptDestructor else Result := ptIdentifier;
end;

function TmwPasLex.Func166: TptTokenKind;
begin
  if KeyComp('Constructor') then Result := ptConstructor else
    if KeyComp('Implementation') then Result := ptImplementation else Result := ptIdentifier;
end;

function TmwPasLex.Func167: TptTokenKind;
begin
  if KeyComp('ShortString') then fExID := ptShortString;
  Result := ptIdentifier;
end;

function TmwPasLex.Func168: TptTokenKind;
begin
  if KeyComp('Initialization') then Result := ptInitialization else Result := ptIdentifier;
end;

function TmwPasLex.Func191: TptTokenKind;
begin
  if KeyComp('Resourcestring') then Result := ptResourcestring else
    if KeyComp('Stringresource') then Result := ptStringresource else Result := ptIdentifier;
end;

function TmwPasLex.AltFunc: TptTokenKind;
begin
  Result := ptIdentifier
end;

function TmwPasLex.IdentKind: TptTokenKind;
var
  HashKey: Integer;
begin
  HashKey := KeyHash;
  if HashKey < 192 then Result := fIdentFuncTable[HashKey] else Result := ptIdentifier;
end;

procedure TmwPasLex.MakeMethodTables;
var
  I: Char;
begin
  for I := #0 to #255 do
    case I of
      #0: fProcTable[I] := NullProc;
      #10: fProcTable[I] := LFProc;
      #13: fProcTable[I] := CRProc;
      #1..#9, #11, #12, #14..#32:
        fProcTable[I] := SpaceProc;
      '#': fProcTable[I] := AsciiCharProc;
      '$': fProcTable[I] := IntegerProc;
      #39: fProcTable[I] := StringProc;
      '0'..'9': fProcTable[I] := NumberProc;
      'A'..'Z', 'a'..'z', '_':
        fProcTable[I] := IdentProc;
      '{': fProcTable[I] := BraceOpenProc;
      '}': fProcTable[I] := BraceCloseProc;
      '!', '"', '%', '&', '('..'/', ':'..'@', '['..'^', '`', '~':
        begin
          case I of
            '(': fProcTable[I] := RoundOpenProc;
            ')': fProcTable[I] := RoundCloseProc;
            '*': fProcTable[I] := StarProc;
            '+': fProcTable[I] := PlusProc;
            ',': fProcTable[I] := CommaProc;
            '-': fProcTable[I] := MinusProc;
            '.': fProcTable[I] := PointProc;
            '/': fProcTable[I] := SlashProc;
            ':': fProcTable[I] := ColonProc;
            ';': fProcTable[I] := SemiColonProc;
            '<': fProcTable[I] := LowerProc;
            '=': fProcTable[I] := EqualProc;
            '>': fProcTable[I] := GreaterProc;
            '@': fProcTable[I] := AddressOpProc;
            '[': fProcTable[I] := SquareOpenProc;
            ']': fProcTable[I] := SquareCloseProc;
            '^': fProcTable[I] := PointerSymbolProc;
          else fProcTable[I] := SymbolProc;
          end;
        end;
    else fProcTable[I] := UnknownProc;
    end;
end;

constructor TmwPasLex.Create;
begin
  inherited Create;
  fOrigin:= nil;
  InitIdent;
  MakeMethodTables;
  fExID := ptUnKnown;
  fLookAheadCount := 0;
  fInternalLookAheadCount := 0;
end; { Create }

destructor TmwPasLex.Destroy;
begin
  fOrigin:= nil;
  inherited Destroy;
end; { Destroy }

procedure TmwPasLex.SetOrigin(NewValue: PChar);
begin
  fOrigin := NewValue;
  Init;
  Next;
end; { SetOrigin }

procedure TmwPasLex.SetRunPos(Value: Integer);
begin
  Run := Value;
  Next;
end;

procedure TmwPasLex.AddressOpProc;
begin
  Case FOrigin[Run + 1] of
    '@':
      begin
        fTokenID := ptDoubleAddressOp;
        inc(Run, 2);
      end;
  else
    begin
      fTokenID := ptAddressOp;
      inc(Run);
    end;
  end;
end;

procedure TmwPasLex.AsciiCharProc;
begin
  fTokenID := ptAsciiChar;
  inc(Run);
  while FOrigin[Run] in ['0'..'9'] do inc(Run);
end;

procedure TmwPasLex.BraceCloseProc;
begin
  inc(Run);
  fTokenId := ptError;
end;

procedure TmwPasLex.BorProc;
begin
  fTokenID := ptBorComment;
  case FOrigin[Run] of
    #0:
      begin
        NullProc;
        exit;
      end;

    #10:
      begin
        LFProc;
        exit;
      end;

    #13:
      begin
        CRProc;
        exit;
      end;
  end;

  while FOrigin[Run] <> #0 do
    case FOrigin[Run] of
      '}':
        begin
          fCommentState := csNo;
          inc(Run);
          break;
        end;
      #10: break;

      #13: break;
    else inc(Run);
    end;
end;

procedure TmwPasLex.BraceOpenProc;
begin
  Case FOrigin[Run + 1] of
    '$': fTokenID := GetDirectiveKind;
  else
    begin
      fTokenID := ptBorComment;
      fCommentState := csBor;
    end;
  end;
  inc(Run);
  while FOrigin[Run] <> #0 do
    case FOrigin[Run] of
      '}':
        begin
          fCommentState := csNo;
          inc(Run);
          break;
        end;
      #10: break;

      #13: break;
    else inc(Run);
    end;
end;

procedure TmwPasLex.ColonProc;
begin
  Case FOrigin[Run + 1] of
    '=':
      begin
        inc(Run, 2);
        fTokenID := ptAssign;
      end;
  else
    begin
      inc(Run);
      fTokenID := ptColon;
    end;
  end;
end;

procedure TmwPasLex.CommaProc;
begin
  inc(Run);
  fTokenID := ptComma;
end;

procedure TmwPasLex.CRProc;
begin
  Case fCommentState of
    csBor: fTokenID := ptCRLFCo;
    csAnsi: fTokenID := ptCRLFCo;
  else fTokenID := ptCRLF;
  end;

  Case FOrigin[Run + 1] of
    #10: inc(Run, 2);
  else inc(Run);
  end;
  inc(fLineNumber);
  fLinePos := Run;
end;

procedure TmwPasLex.EqualProc;
begin
  inc(Run);
  fTokenID := ptEqual;
end;

procedure TmwPasLex.GreaterProc;
begin
  Case FOrigin[Run + 1] of
    '=':
      begin
        inc(Run, 2);
        fTokenID := ptGreaterEqual;
      end;
  else
    begin
      inc(Run);
      fTokenID := ptGreater;
    end;
  end;
end;

procedure TmwPasLex.IdentProc;
begin
  fExID := ptUnKnown;
  fTokenID := IdentKind;
end;

procedure TmwPasLex.IntegerProc;
begin
  inc(Run);
  fTokenID := ptIntegerConst;
  while FOrigin[Run] in ['0'..'9', 'A'..'F', 'a'..'f'] do inc(Run);
end;

procedure TmwPasLex.LFProc;
begin
  Case fCommentState of
    csBor: fTokenID := ptCRLFCo;
    csAnsi: fTokenID := ptCRLFCo;
  else fTokenID := ptCRLF;
  end;
  inc(Run);
  inc(fLineNumber);
  fLinePos := Run;
end;

procedure TmwPasLex.LowerProc;
begin
  case FOrigin[Run + 1] of
    '=':
      begin
        inc(Run, 2);
        fTokenID := ptLowerEqual;
      end;
    '>':
      begin
        inc(Run, 2);
        fTokenID := ptNotEqual;
      end
  else
    begin
      inc(Run);
      fTokenID := ptLower;
    end;
  end;
end;

procedure TmwPasLex.MinusProc;
begin
  inc(Run);
  fTokenID := ptMinus;
end;

procedure TmwPasLex.NullProc;
begin
  fTokenID := ptNull;
end;

procedure TmwPasLex.NumberProc;
begin
  inc(Run);
  fTokenID := ptIntegerConst;
  while FOrigin[Run] in ['0'..'9', '.', 'e', 'E'] do
  begin
    case FOrigin[Run] of
      '.':
        if FOrigin[Run + 1] = '.' then break else fTokenID := ptFloat
    end;
    inc(Run);
  end;
end;

procedure TmwPasLex.PlusProc;
begin
  inc(Run);
  fTokenID := ptPlus;
end;

procedure TmwPasLex.PointerSymbolProc;
begin
  inc(Run);
  fTokenID := ptPointerSymbol;
end;

procedure TmwPasLex.PointProc;
begin
  case FOrigin[Run + 1] of
    '.':
      begin
        inc(Run, 2);
        fTokenID := ptDotDot;
      end;
    ')':
      begin
        inc(Run, 2);
        fTokenID := ptSquareClose;
      end;
  else
    begin
      inc(Run);
      fTokenID := ptPoint;
    end;
  end;
end;

procedure TmwPasLex.RoundCloseProc;
begin
  inc(Run);
  fTokenID := ptRoundClose;
end;

procedure TmwPasLex.AnsiProc;
begin
  fTokenID := ptAnsiComment;
  case FOrigin[Run] of
    #0:
      begin
        NullProc;
        exit;
      end;

    #10:
      begin
        LFProc;
        exit;
      end;

    #13:
      begin
        CRProc;
        exit;
      end;
  end;

  while fOrigin[Run] <> #0 do
    case fOrigin[Run] of
      '*':
        if fOrigin[Run + 1] = ')' then
        begin
          fCommentState := csNo;
          inc(Run, 2);
          break;
        end else inc(Run);
      #10: break;

      #13: break;
    else inc(Run);
    end;
end;

procedure TmwPasLex.RoundOpenProc;
begin
  inc(Run);
  case fOrigin[Run] of
    '*':
      begin
        fTokenID := ptAnsiComment;
        if FOrigin[Run + 1] = '$' then fTokenID := GetDirectiveKind else
          fCommentState := csAnsi;
        inc(Run);
        while fOrigin[Run] <> #0 do
          case fOrigin[Run] of
            '*':
              if fOrigin[Run + 1] = ')' then
              begin
                fCommentState := csNo;
                inc(Run, 2);
                break;
              end else inc(Run);
            #10: break;
            #13: break;
          else inc(Run);
          end;
      end;
    '.':
      begin
        inc(Run);
        fTokenID := ptSquareOpen;
      end;
  else FTokenID := ptRoundOpen;
  end;
end;

procedure TmwPasLex.SemiColonProc;
begin
  inc(Run);
  fTokenID := ptSemiColon;
end;

procedure TmwPasLex.SlashProc;
begin
  case FOrigin[Run + 1] of
    '/':
      begin
        inc(Run, 2);
        fTokenID := ptSlashesComment;
        while FOrigin[Run] <> #0 do
        begin
          case FOrigin[Run] of
            #10, #13: break;
          end;
          inc(Run);
        end;
      end;
  else
    begin
      inc(Run);
      fTokenID := ptSlash;
    end;
  end;
end;

procedure TmwPasLex.SpaceProc;
begin
  inc(Run);
  fTokenID := ptSpace;
  while FOrigin[Run] in [#1..#9, #11, #12, #14..#32] do inc(Run);
end;

procedure TmwPasLex.SquareCloseProc;
begin
  inc(Run);
  fTokenID := ptSquareClose;
end;

procedure TmwPasLex.SquareOpenProc;
begin
  inc(Run);
  fTokenID := ptSquareOpen;
end;

procedure TmwPasLex.StarProc;
begin
  inc(Run);
  fTokenID := ptStar;
end;

procedure TmwPasLex.StringProc;
begin
  fTokenID := ptStringConst;
  if (FOrigin[Run + 1] = #39) and (FOrigin[Run + 2] = #39) then inc(Run, 2);
  repeat
    case FOrigin[Run] of
      #0, #10, #13: break;
    end;
    inc(Run);
  until FOrigin[Run] = #39;
  if FOrigin[Run] <> #0 then inc(Run);
end;

procedure TmwPasLex.SymbolProc;
begin
  inc(Run);
  fTokenID := ptSymbol;
end;

procedure TmwPasLex.UnknownProc;
begin
  inc(Run);
  fTokenID := ptUnknown;
end;

procedure TmwPasLex.Next;
begin
  Case fTokenID of
    ptIdentifier:
      begin
        fLastIdentPos := fTokenPos;
        fLastNoJunk := fTokenID;
        fLastNoJunkPos := fTokenPos;
      end;
    ptAnsiComment, ptBorComment, ptCRLF, ptCRLFCo, ptSlashesComment, ptSpace: ;
  else
    begin
      fLastNoJunk := fTokenID;
      fLastNoJunkPos := fTokenPos;
    end;
  end;
  fTokenPos := Run;
  Case fCommentState of
    csNo: fProcTable[fOrigin[Run]];
  else
    Case fCommentState of
      csBor: BorProc;
      csAnsi: AnsiProc;
    end;
  end;
end;

function TmwPasLex.GetIsJunk: Boolean;
begin
  Result:= fTokenID in [ptAnsiComment, ptBorComment, ptCRLF, ptCRLFCo, ptSlashesComment, ptSpace];
end;

function TmwPasLex.GetIsSpace: Boolean;
begin
  Result:= fTokenID in [ptCRLF, ptSpace];
end;

function TmwPasLex.GetToken: String;
begin
  SetString(Result, (FOrigin + fTokenPos), GetTokenLen);
end;

function TmwPasLex.GetTokenLen: Integer;
begin
  Result := Run - fTokenPos;
end;

procedure TmwPasLex.NextID(ID: TptTokenKind);
begin
  repeat
    Case fTokenID of
      ptNull: break;
    else Next;
    end;
  until fTokenID = ID;
end;

procedure TmwPasLex.NextNoJunk;
begin
  repeat
    Next;
  until not IsJunk;
end;

procedure TmwPasLex.NextNoSpace;
begin
  repeat
    Next;
  until not IsSpace;
end;

function TmwPasLex.FirstInLine: Boolean;
var
  RunBack: Integer;
begin
  Result := True;
  if fTokenPos = 0 then exit;
  RunBack := fTokenPos;
  dec(RunBack);
  while fOrigin[RunBack] in [#1..#9, #11, #12, #14..#32] do dec(RunBack);
  if RunBack = 0 then exit;
  Case fOrigin[RunBack] of
    #10, #13: exit;
  else
    begin
      Result := False;
      exit;
    end;
  end;
end;

function TmwPasLex.GetCommentState: Pointer;
begin
  Result := Pointer(fCommentState);
end;

function TmwPasLex.GetCompilerDirective: String;
var
  DirectLen: Integer;
begin
  if TokenID <> ptCompDirect then Result := ''
  else
    Case fOrigin[fTokenPos] of
      '(':
        begin
          DirectLen := Run - fTokenPos - 4;
          SetString(Result, (FOrigin + fTokenPos + 2), DirectLen);
          Result := UpperCase(Result);
        end;
      '{':
        begin
          DirectLen := Run - fTokenPos - 2;
          SetString(Result, (FOrigin + fTokenPos + 1), DirectLen);
          Result := UpperCase(Result);
        end;
    end;
end;

function TmwPasLex.GetDirectiveKind: TptTokenKind;
var
  TempPos: Integer;
begin
  Case fOrigin[fTokenPos] of
    '(': Run := FTokenPos + 3;
    '{': Run := FTokenPos + 2;
  end;
  TempPos := fTokenPos;
  fTokenPos := Run;
  Case KeyHash of
    9:
      if KeyComp('I') then Result := ptIncludeDirect else Result := ptCompDirect;
    18:
      if KeyComp('R') then
      begin
        if not (fOrigin[Run] in ['+', '-']) then
          Result := ptResourceDirect else Result := ptCompDirect;
      end else Result := ptCompDirect;
    30:
      if KeyComp('IFDEF') then Result := ptIfDefDirect else Result := ptCompDirect;
    38:
      if KeyComp('ENDIF') then Result := ptEndIfDirect else Result := ptCompDirect;
    41:
      if KeyComp('ELSE') then Result := ptElseDirect else Result := ptCompDirect;
    43:
      if KeyComp('DEFINE') then Result := ptDefineDirect else Result := ptCompDirect;
    44:
      if KeyComp('IFNDEF') then Result := ptIfNDefDirect else Result := ptCompDirect;
    50:
      if KeyComp('UNDEF') then Result := ptUndefDirect else Result := ptCompDirect;
    66:
      if KeyComp('IFOPT') then Result := ptIfOptDirect else Result := ptCompDirect;
    68:
      if KeyComp('INCLUDE') then Result := ptIncludeDirect else Result := ptCompDirect;
    104:
      if KeyComp('Resource') then Result := ptResourceDirect else Result := ptCompDirect;
  else Result := ptCompDirect;
  end;
  fTokenPos := TempPos;
  dec(Run);
end;

function TmwPasLex.GetDirectiveParam: String;
var
  EndPos: Integer;
  ParamLen: Integer;
begin
  Case fOrigin[fTokenPos] of
    '(':
      begin
        TempRun := FTokenPos + 3;
        EndPos := Run - 2;
      end;
    '{':
      begin
        TempRun := FTokenPos + 2;
        EndPos := Run - 1;
      end;
  end;
  while Identifiers[fOrigin[TempRun]] do inc(TempRun);
  while fOrigin[TempRun] in ['+', ',', '-'] do
  begin
    inc(TempRun);
    while Identifiers[fOrigin[TempRun]] do inc(TempRun);
    if (fOrigin[TempRun - 1] in ['+', ',', '-']) and (fOrigin[TempRun] = ' ')
      then inc(TempRun);
  end;
  if fOrigin[TempRun] = ' ' then inc(TempRun);
  ParamLen := EndPos - TempRun;
  SetString(Result, (FOrigin + TempRun), ParamLen);
  Result := UpperCase(Result);
end;

function TmwPasLex.GetLastIdentifier: String;
var
  IdentLen: Integer;
begin
  if Identifiers[fOrigin[fLastIdentPos]] then
  begin
    TempRun := fLastIdentPos;
    while Identifiers[fOrigin[TempRun]] do inc(TempRun);
    IdentLen := TempRun - fLastIdentPos;
    SetString(Result, (FOrigin + fLastIdentPos), IdentLen);
  end else Result := '';
end;

procedure TmwPasLex.Init;
begin
  fCommentState := csNo;
  fLineNumber := 0;
  fLastNoJunk := ptUnKnown;
  fLastNoJunkPos := 0;
  fLastIdentPos := 0;
  fLinePos := 0;
  Run := 0;
end;

procedure TmwPasLex.InitLine;
begin
  fLineNumber := 0;
  fLastNoJunkPos := 0;
  fLastIdentPos := 0;
  fLinePos := 0;
  Run := 0;
end;

procedure TmwPasLex.SetCommentState(const Value: Pointer);
begin
  fCommentState := TCommentState(Value);
end;

procedure TmwPasLex.SetLine(const Value: String);
begin
  fOrigin := PChar(Value);
  InitLine;
  Next;
end;

function TmwPasLex.AloneInLine: Boolean;
begin
  if FirstInLine and LastInLine then Result := True else Result := False;
end;

function TmwPasLex.LastInLine: Boolean;
var
  RunAhead: Integer;
begin
  Result := True;
  if fOrigin[Run] = #0 then exit;
  RunAhead := Run;
  while fOrigin[RunAhead] in [#1..#9, #11, #12, #14..#32] do inc(RunAhead);
  Case fOrigin[RunAhead] of
    #0, #10, #13: exit;
  else
    begin
      Result := False;
      exit;
    end;
  end;
end;

function TmwPasLex.GetStatus: TmwPasLexStatus;
begin
  Result.CommentState := fCommentState;
  Result.ExID := fExID;
  Result.LastIdentPos := fLastIdentPos;
  Result.LastNoJunk := fLastNoJunk;
  Result.LastNoJunkPos := fLastNoJunkPos;
  Result.LineNumber := fLineNumber;
  Result.LinePos := fLinePos;
  Result.Origin := fOrigin;
  Result.RunPos := Run;
  Result.TokenPos := fTokenPos;
  Result.TokenID := fTokenID;
end;

procedure TmwPasLex.SetStatus(const Value: TmwPasLexStatus);
begin
  fCommentState := Value.CommentState;
  fExID := Value.ExID;
  fLastIdentPos := Value.LastIdentPos;
  fLastNoJunk := Value.LastNoJunk;
  fLastNoJunkPos := Value.LastNoJunkPos;
  fLineNumber := Value.LineNumber;
  fLinePos := Value.LinePos;
  fOrigin := Value.Origin;
  Run := Value.RunPos;
  fTokenPos := Value.TokenPos;
  fTokenID := Value.TokenID;
end;

procedure TmwPasLex.FillStatusRecord(var Value: TmwPasLexStatus);
begin
  Value.CommentState := fCommentState;
  Value.ExID := fExID;
  Value.LastIdentPos := fLastIdentPos;
  Value.LastNoJunk := fLastNoJunk;
  Value.LastNoJunkPos := fLastNoJunkPos;
  Value.LineNumber := fLineNumber;
  Value.LinePos := fLinePos;
  Value.Origin := fOrigin;
  Value.RunPos := Run;
  Value.TokenPos := fTokenPos;
  Value.TokenID := fTokenID;
end;

procedure TmwPasLex.SetInternalStoredStatus;
begin
  FillStatusRecord(fInternalStoredStatus);
end;

procedure TmwPasLex.SetStoredStatus;
begin
  FillStatusRecord(fStoredStatus);
end;

procedure TmwPasLex.BeginLookAhead;
begin
  inc(fLookAheadCount);
  Case fLookAheadCount > 1 of
    True:;
    False: SetStoredStatus;
  end;
end;

procedure TmwPasLex.BeginNewLookAhead;
begin
  fLookAheadCount:= 0;
  BeginLookAhead;
end;

procedure TmwPasLex.EndLookAhead;
begin
  dec(fLookAheadCount);
  Case fLookAheadCount > 0 of
    True:;
    False: Status := fStoredStatus;
  end;
end;

procedure TmwPasLex.InternalBeginLookAhead;
begin
  inc(fInternalLookAheadCount);
  Case fInternalLookAheadCount > 1 of
    True:;
    False: SetInternalStoredStatus;
  end;
end;

procedure TmwPasLex.InternalEndLookAhead;
begin
  dec(fInternalLookAheadCount);
  Case fInternalLookAheadCount > 0 of
    True:;
    False: Status := fInternalStoredStatus;
  end;
end;

procedure TmwPasLex.Ahead(var ID1, ID2, ID3, ExID1, ExID2, ExID3: TptTokenKind);
{ Use it careful, it eats performance }
begin
  InternalBeginLookAhead;
  NextNoJunk;
  ID1:= fTokenID;
  ExID1:= fExID;
  NextNoJunk;
  ID2:= fTokenID;
  ExID2:= fExID;
  NextNoJunk;
  ID3:= fTokenID;
  ExID3:= fExID;
  InternalEndLookAhead;
end;

procedure TmwPasLex.OneAhead(var ID1, ExID1: TptTokenKind);
{ Use it careful, it eats performance }
begin
  InternalBeginLookAhead;
  NextNoJunk;
  ID1:= fTokenID;
  ExID1:= fExID;
  InternalEndLookAhead;
end;

function TmwPasLex.GetStringContent: String;
var
  TempString: String;
  sEnd: Integer;
begin
  if TokenID <> ptStringConst then Result:= '' else
  begin
    TempString:= Token;
    sEnd:= Length(TempString);
    if TempString[sEnd] <> #39 then inc(sEnd);
    Result:= Copy(TempString, 2, sEnd-2);
    TempString:= '';
  end;
end;

Initialization
  MakeIdentTable;
end.

