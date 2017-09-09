{ Project: Pyro
  Module: Pyro Core

  Description:
  - abstract storage
  - textual storage: Special storage class storing a container in textual form (comparable to DFM)
  - binary storage

  This storage component will be phased out, and NativeXml's methods are preferred.
  For now, some classes still depend on it.

  Author: Nils Haeck (n.haeck@simdesign.nl)
  Copyright (c) 2006 - 2011 SimDesign BV

  Modified:
  19may2011: string > Utf8String
}
unit pgStorage;

interface

uses
  Classes, SysUtils, NativeXml, sdDebug, Pyro;

type

  TSetOfChar = set of Char;

  TpgStorage = class(TsdDebugPersistent)
  private
    FStream: TStream;
    FFileVersion: integer;
    FOnWarning: TpgMessageEvent;
  protected
    property Stream: TStream read FStream;
    function PeekMarker: TpgStorageMarker; virtual;
    procedure RewindMarker; virtual; abstract;
    procedure WriteFileVersion; virtual;
    procedure SkipUntil(AMarker: TpgStorageMarker); virtual;
  public
    constructor Create(AOwner: TsdDebugComponent; AStream: TStream);
    function ReadBool: boolean; virtual; abstract;
    procedure StartLoad; virtual;
    procedure CloseLoad; virtual;
    function ReadMarker: TpgStorageMarker; virtual; abstract;
    procedure ReadFileVersion; virtual;
    procedure DoWarning(const AMessage: Utf8String);
    function GetPositionInfo: Utf8String; virtual;
    procedure StartSave; virtual;
    procedure WriteMarker(AMarker: TpgStorageMarker); virtual; abstract;
    procedure CloseSave; virtual;
    //
    procedure WriteBool(const Value: boolean); virtual; abstract;
    function ReadInt: integer; virtual; abstract;
    procedure WriteInt(const Value: integer); virtual; abstract;
    function ReadFloat: double; virtual; abstract;
    procedure WriteFloat(const Value: double); virtual; abstract;
    function ReadString: Utf8String; virtual; abstract;
    procedure WriteString(const Value: Utf8String); virtual; abstract;
    function ReadIntList(var List: TDynIntArray): integer; virtual;
    procedure WriteIntList(const List: array of integer; Count: integer); virtual;
    function ReadFloatList(var List: TDynFloatArray): integer; virtual;
    procedure WriteFloatList(const List: array of double; Count: integer); virtual;
    function ReadBinary: RawByteString; virtual;
    procedure WriteBinary(const AData: RawByteString); virtual;
    // FileVersion should be set in Create and should be increased every time
    // the property readers/writers change for a certain property
    property FileVersion: integer read FFileVersion;
    property OnWarning: TpgMessageEvent read FOnWarning write FOnWarning;
  end;

  // reference implementation for textual storage of containers
  TpgTextualStorage = class(TpgStorage)
  private
    FLevel: integer;
    FRewindPos: int64;
    function RString(const ALength: integer): Utf8String; overload;
    function RString: Utf8String; overload;
    function RString(const ATerminators: TSetOfChar): Utf8String; overload;
    procedure WString(const Value: Utf8String);
    procedure WIndent(Level: integer);
  protected
    procedure RewindMarker; override;
  public
    procedure StartLoad; override;
    procedure StartSave; override;
    function ReadMarker: TpgStorageMarker; override;
    procedure WriteMarker(AMarker: TpgStorageMarker); override;
    function ReadBool: boolean; override;
    procedure WriteBool(const Value: boolean); override;
    function ReadInt: integer; override;
    procedure WriteInt(const Value: integer); override;
    function ReadFloat: double; override;
    procedure WriteFloat(const Value: double); override;
    function ReadString: Utf8String; override;
    procedure WriteString(const Value: Utf8String); override;
    function ReadBinary: RawByteString; override;
    procedure WriteBinary(const Value: RawByteString); override;
  end;

type

  // reference implementation for binary storage of containers
  TpgBinaryStorage = class(TpgStorage)
  private
    FInfo: byte; // Contains marker and format info
    FMarker: TpgStorageMarker;
    FDigits: TpgStorageDigits;
    procedure WriteIntegerPart(const Value: integer);
    function ReadIntegerPart: integer;
  protected
    procedure RewindMarker; override;
  public
    function ReadMarker: TpgStorageMarker; override;
    procedure WriteMarker(AMarker: TpgStorageMarker); override;
    function ReadBool: boolean; override;
    procedure WriteBool(const Value: boolean); override;
    function ReadInt: integer; override;
    procedure WriteInt(const Value: integer); override;
    function ReadFloat: double; override;
    procedure WriteFloat(const Value: double); override;
    function ReadString: Utf8String; override;
    procedure WriteString(const Value: Utf8String); override;
  end;

implementation

const

  cQuoteChar = #$27; // single quote (')
const

  cInfoFromMarker: array[TpgStorageMarker] of byte =
   ($C0, $80, $90, $A0, $B0, $00, $10, $20, $30, $40, $D0);


{ TpgStorage }

procedure TpgStorage.CloseLoad;
begin
// default does nothing
end;

procedure TpgStorage.CloseSave;
begin
// default does nothing
end;

constructor TpgStorage.Create(AOwner: TsdDebugComponent; AStream: TStream);
begin
  CreateDebug(AOwner);
  FStream := AStream;
end;

procedure TpgStorage.DoWarning(const AMessage: Utf8String);
begin
  if assigned(FOnWarning) then
    FOnWarning(Self, AMessage);
end;

function TpgStorage.GetPositionInfo: Utf8String;
begin
  Result := IntToStr(Stream.Position);
end;

function TpgStorage.PeekMarker: TpgStorageMarker;
begin
  Result := ReadMarker;
  RewindMarker;
end;

function TpgStorage.ReadBinary: RawByteString;
begin
  Result := RawByteString(ReadString);
end;

procedure TpgStorage.ReadFileVersion;
begin
// default does nothing
end;

function TpgStorage.ReadFloatList(var List: TDynFloatArray): integer;
var
  i, Count: integer;
begin
  Count := ReadInt;
  if length(List) < Count then
    SetLength(List, Count);
  for i := 0 to Count - 1 do
    List[i] := ReadFloat;
  Result := Count;
end;

function TpgStorage.ReadIntList(var List: TDynIntArray): integer;
var
  i, Count: integer;
begin
  Count := ReadInt;
  if length(List) < Count then
    SetLength(List, Count);
  for i := 0 to Count - 1 do
    List[i] := ReadInt;
  Result := Count;
end;

procedure TpgStorage.SkipUntil(AMarker: TpgStorageMarker);
var
  Level: integer;
  M: TpgStorageMarker;
  IL: TDynIntArray;
  FL: TDynFloatArray;
begin
  Level := 1;
  repeat
    M := PeekMarker;
    if M = AMarker then
    begin
      dec(Level);
      if Level = 0 then
      begin
        ReadMarker;
        exit;
      end;
    end;

    if (M = smElementStart) and (AMarker = smElementClose) then
      inc(Level);

    case M of
    smIntValue: ReadInt;
    smFloatValue: ReadFloat;
    smStringValue: ReadString;
    smIntListValue: ReadIntList(IL);
    smFloatListValue: ReadFloatList(FL);
    else
      ReadMarker;
    end;
  until M = smEndOfFile;
end;

procedure TpgStorage.StartLoad;
begin
  // default rewinds stream
  FStream.Position := 0;
end;

procedure TpgStorage.StartSave;
begin
  // default rewinds stream
  FStream.Position := 0;
  FStream.Size := 0;
end;

procedure TpgStorage.WriteBinary(const AData: RawByteString);
begin
  WriteString(Utf8String(AData));
end;

procedure TpgStorage.WriteFileVersion;
begin
// default does nothing
end;

procedure TpgStorage.WriteFloatList(const List: array of double; Count: integer);
var
  i: integer;
begin
  WriteInt(Count);
  for i := 0 to Count - 1 do
    WriteFloat(List[i]);
end;

procedure TpgStorage.WriteIntList(const List: array of integer;
  Count: integer);
var
  i: integer;
begin
  WriteInt(Count);
  for i := 0 to Count - 1 do
    WriteInt(List[i]);
end;

{ TpgTextualStorage }

function TpgTextualStorage.ReadBinary: RawByteString;
begin
  Result := DecodeBase64(ReadString);
end;

function TpgTextualStorage.ReadBool: boolean;
begin
  if RString = 'true' then
    Result := True
  else
    Result := False;
end;

function TpgTextualStorage.ReadFloat: double;
begin
  Result := StrToFloatDef(RString, 0);
end;

function TpgTextualStorage.ReadInt: integer;
begin
  Result := StrToIntDef(RString, 0);
end;

function TpgTextualStorage.ReadMarker: TpgStorageMarker;
var
  S: Utf8String;
begin
  FRewindPos := Stream.Position;
  S := RString;
  if S = 'object' then
  begin
    Result := smElementStart
  end else
    if S = 'end' then
    begin
      Result := smElementClose;
    end else
    begin
      if length(S) > 0 then
      begin
        Result := smPropStart;
        Stream.Position := FRewindPos;
      end else
        Result := smEndOfFile;
    end;
end;

function TpgTextualStorage.ReadString: Utf8String;
begin
  Result := AnsiDequotedStr(RString, cQuoteChar);
end;

procedure TpgTextualStorage.RewindMarker;
begin
  Stream.Position := FRewindPos;
end;

function TpgTextualStorage.RString(const ALength: integer): Utf8String;
// Read string of length ALength from stream
begin
  SetLength(Result, ALength);
  if ALength > 0 then
    Stream.Read(Result[1], ALength);
end;

function TpgTextualStorage.RString: Utf8String;
// Read string until the standard terminator chars, then skip the terminator
// chars.
const
  cTerminators: TSetOfChar = [#$0A, #$0D, #$20];
begin
  Result := RString(cTerminators);
end;

function TpgTextualStorage.RString(const ATerminators: TSetOfChar): Utf8String;
// Read up till first terminator char, and skip over additonal ones in ATerminators
var
  Ch: Char;
  Len: integer;
begin
  Result := '';
  // Read characters up till first terminator, add to result
  repeat
    Len := Stream.Read(Ch, 1);
    if (Len > 0) and not (Ch in ATerminators) then
      Result := Result + Ch;
  until (Ch in ATerminators) or (Len = 0);
  // Skip over additional terminators
  while (Len > 0) and (Ch in ATerminators) do
  begin
    Len := Stream.Read(Ch, 1);
  end;
  if Len > 0 then
    Stream.Seek(-1, soCurrent);
end;

procedure TpgTextualStorage.StartLoad;
begin
  // Rewind
  inherited;
  RString(3); // skip UTF8 BOM
end;

procedure TpgTextualStorage.StartSave;
const
  cUtf8BOM: AnsiString = #$EF#$BB#$BF;
begin
  // Rewind
  inherited;
  // Write BOM marker for UTF8
  WString(Utf8String(cUtf8Bom));
end;

procedure TpgTextualStorage.WIndent(Level: integer);
var
  i: integer;
begin
  // Write indentation
  for i := 0 to Level - 1 do
    WString('  ');
end;

procedure TpgTextualStorage.WriteBinary(const Value: RawByteString);
begin
  WriteString(EncodeBase64(Value));
end;

procedure TpgTextualStorage.WriteBool(const Value: boolean);
begin
  case Value of
  True: WString(' true');
  False: WString(' false');
  end;
end;

procedure TpgTextualStorage.WriteFloat(const Value: double);
begin
  WString(' ' + FloatToStr(Value));
end;

procedure TpgTextualStorage.WriteInt(const Value: integer);
begin
  WString(' ' + IntToStr(Value));
end;

procedure TpgTextualStorage.WriteMarker(AMarker: TpgStorageMarker);
begin
  case AMarker of
  smElementStart:
    begin
      WIndent(FLevel);
      WString('object');
      inc(FLevel);
    end;
  smElementClose:
    begin
      dec(FLevel);
      WIndent(FLevel);
      WString('end'#13#10);
    end;
  smPropStart:
    begin
      WIndent(FLevel);
    end;
  smPropClose:
    begin
      WString(#13#10);
    end;
  end;
end;

procedure TpgTextualStorage.WriteString(const Value: Utf8String);
var
  S: Utf8String;
begin
  S := AnsiQuotedStr(Value, cQuoteChar);
  WString(' ' + S);
end;

procedure TpgTextualStorage.WString(const Value: Utf8String);
var
  Count: integer;
begin
  Count := length(Value);
  if Count > 0 then
  Stream.Write(Value[1], Count);
end;

{ TpgBinaryStorage }

function TpgBinaryStorage.ReadBool: boolean;
var
  Value: integer;
begin
  Value := ReadInt;
  if Value = 0 then
    Result := False
  else if Value = 1 then
    Result := True
  else
    raise Exception.Create(sFatalReadError);
end;

function TpgBinaryStorage.ReadFloat: double;
var
  S: single;
  D: double;
begin
  ReadMarker;
  if FMarker <> smFloatValue then
    raise Exception.CreateFmt(sUnexpectedMarker, [cMarkerNames[FMarker], GetPositionInfo]);
  case FDigits of
  sdValueIsZero: Result := 0;
  sdValueIsOne:  Result := 1;
  sdSingle:
    begin
      Stream.Read(S, 4);
      Result := S;
    end;
  sdDouble:
    begin
      Stream.Read(D, 8);
      Result := D;
    end;
  else
    raise Exception.Create(sFatalReadError);
  end;
end;

function TpgBinaryStorage.ReadInt: integer;
begin
  ReadMarker;
  if FMarker <> smIntValue then
    raise Exception.CreateFmt(sUnexpectedMarker, [cMarkerNames[FMarker], GetPositionInfo]);
  Result := ReadIntegerPart;
end;

function TpgBinaryStorage.ReadIntegerPart: integer;
var
  P1: byte;
  P2: word;
  P4: longword;
begin
  case FDigits of
  sdValueIsZero: Result := 0;
  sdValueIsOne:  Result := 1;
  sdPositive8bits, sdNegative8bits:
    begin
      Stream.Read(P1, 1);
      Result := P1;
    end;
  sdPositive16bits, sdNegative16bits:
    begin
      Stream.Read(P2, 2);
      Result := P2;
    end;
  sdPositive32bits, sdNegative32bits:
    begin
      Stream.Read(P4, 4);
      Result := P4;
    end;
  else
    raise Exception.Create(sFatalReadError);
  end;
  if FDigits in [sdNegative8bits, sdNegative16bits, sdNegative32bits] then
    Result := -Result;
end;

function TpgBinaryStorage.ReadMarker: TpgStorageMarker;
var
  D: byte;
begin
  if Stream.Read(FInfo, 1) <> 1 then
    raise Exception.Create(sUnexpectedEndOfFile);
  case FInfo and $F0 of
  $00: FMarker := smIntValue;
  $10: FMarker := smFloatValue;
  $20: FMarker := smStringValue;
  $30: FMarker := smIntListValue;
  $40: FMarker := smFloatListValue;
  $80: FMarker := smElementStart;
  $90: FMarker := smElementClose;
  $A0: FMarker := smPropStart;
  $B0: FMarker := smPropClose;
  $C0: FMarker := smFileVersion;
  $D0: FMarker := smEndOfFile;
  else
    raise Exception.Create(sFatalReadError);
  end;
  Result := FMarker;
  D := FInfo and $0F;
  if D <= integer(high(TpgStorageDigits)) then
    FDigits := TpgStorageDigits(D)
  else
    raise Exception.Create(sFatalReadError);
end;

function TpgBinaryStorage.ReadString: Utf8String;
var
  L: integer;
begin
  ReadMarker;
  if FMarker <> smStringValue then
    raise Exception.CreateFmt(sUnexpectedMarker, [cMarkerNames[FMarker], GetPositionInfo]);
  L := ReadIntegerPart;
  SetLength(Result, L);
  if L > 0 then
    Stream.Read(Result[1], L);
end;

procedure TpgBinaryStorage.RewindMarker;
begin
  Stream.Seek(-1, soFromCurrent);
end;

procedure TpgBinaryStorage.WriteBool(const Value: boolean);
begin
  if Value then
    WriteInt(1)
  else
    WriteInt(0);
end;

procedure TpgBinaryStorage.WriteFloat(const Value: double);
var
  S: single;
  D: double;
begin
  FInfo := cInfoFromMarker[smFloatValue];
  if Value = 0 then
  begin
    FInfo := FInfo or integer(sdValueIsZero);
    Stream.Write(FInfo, 1);
  end else if Value = 1 then
  begin
    FInfo := FInfo or integer(sdValueIsOne);
    Stream.Write(FInfo, 1);
  end else
  begin
    S := Value;
    D := S;
    if D = Value then
    begin
      FInfo := FInfo or integer(sdSingle);
      Stream.Write(FInfo, 1);
      Stream.Write(S, 4);
    end else
    begin
      FInfo := FInfo or integer(sdDouble);
      Stream.Write(FInfo, 1);
      Stream.Write(Value, 8);
    end;
  end;
end;

procedure TpgBinaryStorage.WriteInt(const Value: integer);
begin
  FInfo := cInfoFromMarker[smIntValue];
  WriteIntegerPart(Value);
end;

procedure TpgBinaryStorage.WriteIntegerPart(const Value: integer);
var
  P1: byte;
  P2: word;
  P4: longword;
  Compl: integer;
begin
  if Value = 0 then
  begin
    FInfo := FInfo or integer(sdValueIsZero);
    Stream.Write(FInfo, 1);
  end else if Value = 1 then
  begin
    FInfo := FInfo or integer(sdValueIsOne);
    Stream.Write(FInfo, 1);
  end else if Value > 0 then
  begin
    if Value < 255 then
    begin
      FInfo := FInfo or integer(sdPositive8bits);
      P1 := Value;
      Stream.Write(FInfo, 1);
      Stream.Write(P1, 1);
    end else if Value < 65535 then
    begin
      FInfo := FInfo or integer(sdPositive16bits);
      P2 := Value;
      Stream.Write(FInfo, 1);
      Stream.Write(P2, 2);
    end else
    begin
      FInfo := FInfo or integer(sdPositive32bits);
      P4 := Value;
      Stream.Write(FInfo, 1);
      Stream.Write(P4, 4);
    end;
  end else
  begin
    Compl := -Value;
    if Compl < 255 then
    begin
      FInfo := FInfo or integer(sdNegative8bits);
      P1 := Compl;
      Stream.Write(FInfo, 1);
      Stream.Write(P1, 1);
    end else if Compl < 65535 then
    begin
      FInfo := FInfo or integer(sdNegative16bits);
      P2 := Compl;
      Stream.Write(FInfo, 1);
      Stream.Write(P2, 2);
    end else
    begin
      FInfo := FInfo or integer(sdNegative32bits);
      P4 := Compl;
      Stream.Write(FInfo, 1);
      Stream.Write(P4, 4);
    end;
  end;
end;

procedure TpgBinaryStorage.WriteMarker(AMarker: TpgStorageMarker);
begin
  FInfo := cInfoFromMarker[AMarker];
  Stream.Write(FInfo, 1);
end;

procedure TpgBinaryStorage.WriteString(const Value: Utf8String);
var
  L: integer;
begin
  FInfo := cInfoFromMarker[smStringValue];
  L := length(Value);
  WriteIntegerPart(L);
  if L > 0 then
    Stream.Write(Value[1], L);
end;

end.
