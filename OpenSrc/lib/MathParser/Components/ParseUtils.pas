{ *********************************************************************** }
{                                                                         }
{ ParseUtils                                                              }
{                                                                         }
{ Copyright (c) 2006 Pisarev Yuriy (post@pisarev.net)                     }
{                                                                         }
{ *********************************************************************** }

unit ParseUtils;

{$B-}
{$I Directives.inc}

interface

uses
  Windows, SysUtils, Types, Parser, ParseTypes, TextConsts, ValueTypes, ValueUtils;

type
  TFunctionFlagMethod = function(const AFunction: PFunction): Boolean;

  PFunctionFlag = ^TFunctionFlag;
  TFunctionFlag = record
    Index: Integer;
    AFunction: PFunction;
  end;
  TFunctionFlagArray = array of TFunctionFlag;

  TLockType = (ltBracket, ltChar);
  TLock = record
    StartIndex, EndIndex: Integer;
  end;
  TLockArray = array of TLock;

  TTextArray = TByteDynArray;

  TBracketMethod = function(var Text: string; const SubText: string;
    StartIndex, EndIndex: Integer; Data: Pointer): Boolean of object;

  PFindData = ^TFindData;
  TFindData = record
    Code, Index, FromIndex: Integer;
    Item: ^PScriptItem;
  end;

  TParseHelper = class
  protected
    function FindMethod(var Index: Integer; const Header: PScriptHeader;
      const ItemHeader: PItemHeader; const Item: PScriptItem;
      const Data: Pointer): Boolean; virtual;
    function FunctionArrayMethod(var Index: Integer; const Header: PScriptHeader;
      const ItemHeader: PItemHeader; const Item: PScriptItem;
      const Data: Pointer): Boolean; virtual;
  public
    function FindItem(const Script: TScript; const ACode, AFromIndex: Integer): PScriptItem;
    procedure GetFunctionArray(const Script: TScript; out FArray: TIntegerDynArray);
    function Optimizable(const Script: TScript; const Data: TFunctionData): Boolean;
  end;

procedure ParseScript(Index: Integer; const Method: TScriptMethod; const Data: Pointer);
procedure BuildScript(const Parser: TCustomParser; const ItemArray: TScriptArray;
  out Script: TScript; const Optimize: Boolean; Number: PNumber = nil);

function FormatInternalText(const Parser: TCustomParser; const Text: string;
  ScriptArray: TScriptArray; Parameter: Boolean = False): string;

procedure GetFunction(const Parser: TCustomParser; var Index: Integer; out AFunction: PFunction); overload;
function ParameterToScript(const Script: TScript; ATypeHandle: Integer = -1): TScript;
function GetScriptFromValue(const Parser: TCustomParser; Value: TValue; TypeFlag: Boolean;
  ScriptType: TScriptType): TScript; overload;
function GetScriptFromValue(const Parser: TCustomParser; Number: TNumber; ScriptType: TScriptType): TScript; overload;
function GetValueFromScript(const Parser: TCustomParser; Script: TScript; ScriptType: TScriptType): TValue;

function GetParameter(const Parser: TObject; const Parameter: TParameter): TParameter;
function AsValue(const Parser: TObject; const Parameter: TParameter): TValue;
function AsByte(const Parser: TObject; const Parameter: TParameter): Byte;
function AsShortint(const Parser: TObject; const Parameter: TParameter): Shortint;
function AsWord(const Parser: TObject; const Parameter: TParameter): Word;
function AsSmallint(const Parser: TObject; const Parameter: TParameter): Smallint;
function AsLongword(const Parser: TObject; const Parameter: TParameter): Longword;
function AsInteger(const Parser: TObject; const Parameter: TParameter): Integer;
function AsInt64(const Parser: TObject; const Parameter: TParameter): Int64;
function AsSingle(const Parser: TObject; const Parameter: TParameter): Single;
function AsDouble(const Parser: TObject; const Parameter: TParameter): Double;
function AsBoolean(const Parser: TObject; const Parameter: TParameter): Boolean; overload;
function AsText(const Parser: TObject; const Parameter: TParameter): string;
function AsBoolean(const Parser: TObject; const ParameterArray: TParameterArray;
  const Index: Integer; const Default: Boolean): Boolean; overload;

function Optimal(Script: TScript; ScriptType: TScriptType): Boolean;
function TypeDeclarationFlag(Script: TScript; ScriptType: TScriptType): Boolean;

function GetFlagArray(const Text: string; const LockType: TLockType; const Data: TFunctionData;
  out FlagArray: TFunctionFlagArray; const Method: TFunctionFlagMethod = nil): Boolean;
function GetItemArray(const Text: string; var Data: TFunctionData; out ItemArray: TStringDynArray;
  Prepare: Boolean = False; LockType: TLockType = ltChar): Boolean;
procedure DeleteParameterOperator(var Text: string);
function GetSign(var Text: string): Boolean;
function GetFunction(const Data: PFunctionData; var Text: string; const Cut: Boolean): PFunction; overload;
function GetType(const Parser: TCustomParser; const StringHandle: Integer;
  var Text: string; const Cut: Boolean): PType; overload;

procedure WriteItemHeader(const ItemHeader: PItemHeader; const ASign: Boolean; const AType: PType;
  const DefaultTypeHandle: Integer);
function GetInternalScriptIndex(var Text: string; const Parameter: PBoolean): Integer;

function GetLockArray(const Text: string; const LockBracket: TBracket): TLockArray; overload;
function GetLockArray(const Text: string; const LockChar: Char): TLockArray; overload;
function GetTextArray(const Text: string; const LockBracket: TBracket): TTextArray; overload;
function GetTextArray(const Text: string; const LockChar: Char): TTextArray; overload;
function GetTextArray(const Text: string; const LockArray: TLockArray): TTextArray; overload;
function GetTextArray(const Text: string; const LockType: TLockType): TTextArray; overload;
function Locked(const Index: Integer; const LockArray: TLockArray): Boolean; overload;
function Locked(const Index: Integer; const TextArray: TTextArray): Boolean; overload;

procedure ParseBracket(var Text: string; const Bracket: TBracket; const Method: TBracketMethod;
  const Data: Pointer);
function NextBracket(const Text: string; const Bracket: TBracket; Index: Integer): Integer;
function PreviousBracket(const Text: string; const Bracket: TBracket; Index: Integer): Integer;
function Embrace(const Text: string; const Bracket: TBracket): string;
function Embraced(const Text: string; const Bracket: TBracket): Boolean;
procedure DeleteBracket(var Text: string; const Index: Integer; const Bracket: TBracket);
procedure ChangeBracket(var Text: string; const Index: Integer; const BracketFrom, BracketTo: TBracket); overload;
function BracketFunction(const AFunction: PFunction): Boolean;
procedure ChangeBracket(var Text: string; const Data: TFunctionData;
  const BracketFrom, BracketTo: TBracket); overload;

function Lower(const Text: string): string;
function Upper(const Text: string): string;
function Whole(const Text: string; const Index, Count: Integer): Boolean;
function FollowingText(const Text: string; const Index: Integer): string;
function PrecedingText(const Text: string; const Index: Integer): string;
function WholeValue(const Parser: TCustomParser; const Data: PFunctionData;
  const Text: string; const Index, Count: Integer): Boolean;

function GotoBody(const Data: string; const Bracket: TBracket; var Index: Integer;
  const Count: Integer): Boolean;
function FindBody(const Name, Data: string; const Bracket: TBracket; out Index, Count: Integer): Boolean;
function BodyText(const Name, Data: string; const Bracket: TBracket; out Text: string): Boolean;

function Dequote(const Text: string): string;
function DequoteDouble(const Text, FunctionName: string; const Bracket: TBracket): string;
function Dequoted(const Text: string): Boolean;

function MakeTemplate(const Parser: TCustomParser; const Data: PFunctionData;
  const Text: string; const ValueArray: PValueArray;
  const NumberTemplate: string = Inquiry): string;
function WriteValue(Index: Integer; var ValueIndex: Integer; const ValueArray: TValueArray;
  const ScriptType: TScriptType): Boolean;

function Add(var Script: TScript; const Value: Smallint): Integer; overload;
function Add(var Script: TScript; const Value: Word): Integer; overload;
function Add(var Script: TScript; const Value: Integer): Integer; overload;
function Add(var Script: TScript; const Value: Longword): Integer; overload;
function Add(var Script: TScript; const Value: Int64): Integer; overload;
function Add(var Script: TScript; const Value: Single): Integer; overload;
function Add(var Script: TScript; const Value: Double): Integer; overload;
function Add(var Script: TScript; const Value: Extended): Integer; overload;
function Add(var Script: TScript; const Value: TValue): Integer; overload;

function Add(var Script: TScript; const Value: TScriptNumber): Integer; overload;
function Add(var Script: TScript; const Value: TScriptFunction): Integer; overload;
function Add(var Target: TScript; const Source: TScript): Integer; overload;
function Add(var Script: TScript; const Source: Pointer; const Count: Integer): Integer; overload;
function Add(var Script: TScript; const Text: string): Integer; overload;

function Add(var ScriptArray: TScriptArray; const Value: TScript): Integer; overload;
function Add(var Data: TFunctionData; const AFunction: TFunction): Integer; overload;
function Add(var Data: TTypeData; const AType: TType): Integer; overload;
function Add(var ParameterArray: TParameterArray; const ATypeHandle: Integer;
  const AValue: TValue): Integer; overload;
function Add(var ParameterArray: TParameterArray; const ATypeHandle: Integer;
  const AValue: string): Integer; overload;
function Add(var FlagArray: TFunctionFlagArray; const AIndex: Integer;
  const BFunction: PFunction): Integer; overload;
function Add(var LockArray: TLockArray; const AStartIndex, AEndIndex: Integer): Integer; overload;

procedure IncNumber(var Number: TNumber; const Value: TValue); overload;
procedure IncNumber(var Number: TNumber; const Parser: TCustomParser;
  const Script: TScript; const ScriptType: TScriptType); overload;

procedure DeleteArray(var ScriptArray: TScriptArray);

function Insert(var Script: TScript; Value: Int64; Index: Integer): Boolean; overload;
function Insert(var Script: TScript; Value, Index: Integer): Boolean; overload;
function Insert(var Script: TScript; Value: Byte; Index: Integer): Boolean; overload;

function GetFunction(const Data: TFunctionData; Index: Integer; out AFunction: PFunction): Boolean; overload;
function FunctionByIndex(const Data: TFunctionData; Index: Integer): PFunction;
function FunctionCompare(const AIndex, BIndex: Integer; const Target, Data: Pointer): TValueRelationship;
procedure FunctionExchange(const AIndex, BIndex: Integer; const Target, Data: Pointer);
procedure PrepareFData(const Data: PFunctionData); overload;
procedure PrepareFData(const Parser: TCustomParser); overload;

function GetType(const Data: TTypeData; Index: Integer; out AType: PType): Boolean; overload;
function TypeByIndex(const Data: TTypeData; const Index: Integer): PType;
function TypeCompare(const AIndex, BIndex: Integer; const Target, Data: Pointer): TValueRelationship;
procedure TypeExchange(const AIndex, BIndex: Integer; const Target, Data: Pointer);
procedure PrepareTData(const Parser: TCustomParser);

function MakeTypeHandle(const Data: TTypeData; const ValueType: TValueType;
  const DefaultTypeHandle: Integer): Integer; overload;
function MakeTypeHandle(const Parser: TCustomParser; const ValueType: TValueType): Integer; overload;
function AssignValueType(const Parser: TCustomParser; const ItemHeader: PItemHeader;
  const ValueType: TValueType): Boolean;
function GetType(const Parser: TCustomParser; const ItemHeader: PItemHeader): PType; overload;

var
  ParseHelper: TParseHelper;
  LockBracket: TBracket;
  LockChar: Char;

implementation

uses
  FlexibleList, Math, MemoryUtils, NumberConsts, ParseConsts, ParseErrors, StrUtils,
  TextBuilder, TextUtils, ValueConsts;

type
  TParser = class(Parser.TParser);

{ TParseHelper }

function TParseHelper.FindItem(const Script: TScript; const ACode, AFromIndex: Integer): PScriptItem;
var
  FindData: TFindData;
begin
  Result := nil;
  FillChar(FindData, SizeOf(TFindData), 0);
  with FindData do
  begin
    Code := ACode;
    FromIndex := AFromIndex;
    Item := @Result;
  end;
  ParseScript(Integer(Script), FindMethod, @FindData);
end;

function TParseHelper.FindMethod(var Index: Integer; const Header: PScriptHeader;
  const ItemHeader: PItemHeader; const Item: PScriptItem;
  const Data: Pointer): Boolean;
var
  FindData: ^TFindData absolute Data;
begin
  Result := FindData.Index < FindData.FromIndex;
  if Result then Inc(FindData.Index)
  else Result := FindData.Code <> Item.Code;
  if Result then
    case Item.Code of
      NumberCode: Inc(Index, SizeOf(TCode) + SizeOf(TScriptNumber));
      FunctionCode: Inc(Index, SizeOf(TCode) + SizeOf(TScriptFunction));
      StringCode:
        Inc(Index, SizeOf(TCode) + SizeOf(TScriptString) + Item.ScriptString.Size);
      ScriptCode, ParameterCode:
        begin
          ParseScript(Index + SizeOf(TCode), FindMethod, Data);
          Inc(Index, SizeOf(TCode) + Item.Script.Header.ScriptSize);
        end;
    else raise Error(ScriptError);
    end
  else FindData.Item^ := Item;
end;

function TParseHelper.FunctionArrayMethod(var Index: Integer; const Header: PScriptHeader;
  const ItemHeader: PItemHeader; const Item: PScriptItem;
  const Data: Pointer): Boolean;
var
  FArray: ^TIntegerDynArray absolute Data;
begin
  case Item.Code of
    NumberCode: Inc(Index, SizeOf(TCode) + SizeOf(TScriptNumber));
    FunctionCode:
      begin
        Inc(Index, SizeOf(TCode) + SizeOf(TScriptFunction));
        Add(FArray^, Item.ScriptFunction.Handle);
      end;
    StringCode:
      Inc(Index, SizeOf(TCode) + SizeOf(TScriptString) + Item.ScriptString.Size);
    ScriptCode, ParameterCode:
      begin
        ParseScript(Index + SizeOf(TCode), FunctionArrayMethod, Data);
        Inc(Index, SizeOf(TCode) + Item.Script.Header.ScriptSize);
      end;
  else raise Error(ScriptError);
  end;
  Result := True;
end;

procedure TParseHelper.GetFunctionArray(const Script: TScript; out FArray: TIntegerDynArray);
begin
  ParseScript(Integer(Script), FunctionArrayMethod, @FArray);
end;

function TParseHelper.Optimizable(const Script: TScript; const Data: TFunctionData): Boolean;
var
  FArray: TIntegerDynArray;
  I: Integer;
begin
  GetFunctionArray(Script, FArray);
  try
    for I := Low(FArray) to High(FArray) do
      if not Data.FArray[FArray[I]].Optimizable then
      begin
        Result := False;
        Exit;
      end;
    Result := True;
  finally
    FArray := nil;
  end;
end;

procedure ParseScript(Index: Integer; const Method: TScriptMethod; const Data: Pointer);
var
  I, J, K: Integer;
  Header: PScriptHeader absolute I;
  ItemHeader: PItemHeader absolute J;
  Item: Pointer absolute K;
begin
  if Assigned(Method) then
  begin
    I := Index;
    Inc(Index, Header.HeaderSize);
    while Index - I < Header.ScriptSize do
    begin
      J := Index;
      Inc(Index, SizeOf(TItemHeader));
      while Index - J < ItemHeader.Size do
      begin
        K := Index;
        if not Method(Index, Header, ItemHeader, Item, Data) then Exit;
      end;
    end;
  end;
end;

procedure BuildScript(const Parser: TCustomParser; const ItemArray: TScriptArray;
  out Script: TScript; const Optimize: Boolean; Number: PNumber);
var
  ANumber: TNumber;
  I, J, K: Integer;
  AItemArray: TScriptArray;
  ItemHeader: PItemHeader;
  Item: PScriptItem;
  FlagArray: TIntegerDynArray;
  Header: PScriptHeader absolute Script;
begin
  if not Assigned(Number) then
  begin
    FillChar(ANumber, SizeOf(TNumber), 0);
    Number := @ANumber;
  end;
  try
    if Optimize then
    begin
      for I := Low(ItemArray) to High(ItemArray) do
        if Assigned(ItemArray[I]) then
          if Optimal(ItemArray[I], stSubscript) then
            IncNumber(Number^, Parser, ItemArray[I], stSubscript)
          else Add(AItemArray, ItemArray[I]);
      if Number.Valid then
      begin
        Script := GetScriptFromValue(Parser, Number^, stSubscript);
        try
          Add(AItemArray, Script);
        finally
          Script := nil;
        end;
      end;
    end
    else AItemArray := ItemArray;
    Script := nil;
    K := 0;
    try
      for I := Low(AItemArray) to High(AItemArray) do
        if Assigned(AItemArray[I]) then
        begin
          ItemHeader := Pointer(AItemArray[I]);
          J := SizeOf(TItemHeader);
          while J < ItemHeader.Size do
          begin
            Item := @AItemArray[I][J];
            case Item.Code of
              NumberCode:
                Inc(J, SizeOf(TCode) + SizeOf(TScriptNumber));
              FunctionCode:
                Inc(J, SizeOf(TCode) + SizeOf(TScriptFunction));
              StringCode:
                Inc(J, SizeOf(TCode) + SizeOf(TScriptString) + Item.ScriptString.Size);
              ScriptCode:
                begin
                  Add(FlagArray, Integer(K + J + SizeOf(TCode)));
                  Inc(J, SizeOf(TCode) + Item.Script.Header.ScriptSize);
                end;
              ParameterCode:
                Inc(J, SizeOf(TCode) + Item.Script.Header.ScriptSize);
            else raise Error(ScriptError);
            end;
          end;
          Inc(K, ItemHeader.Size);
        end;
      I := Length(FlagArray);
      K := SizeOf(TScriptHeader) + I * SizeOf(Integer);
      Resize(Script, K);
      Header.ScriptCount := I;
      J := SizeOf(TScriptHeader);
      for I := Low(FlagArray) to High(FlagArray) do
      begin
        PInteger(@Script[J])^ := K + FlagArray[I];
        Inc(J, SizeOf(Integer));
      end;
      for I := Low(AItemArray) to High(AItemArray) do Add(Script, AItemArray[I]);
      Header.ScriptSize := Length(Script);
      Header.HeaderSize := K;
    finally
      FlagArray := nil;
    end;
  finally
    DeleteArray(AItemArray);
  end;
end;

{$WARNINGS OFF}
function FormatInternalText(const Parser: TCustomParser; const Text: string;
  ScriptArray: TScriptArray; Parameter: Boolean): string;
var
  Builder: TTextBuilder;
  StringArray: TStringDynArray;
  I, J: Integer;
  Script: TScript;
  S: string;
begin
  Builder := TTextBuilder.Create;
  try
    Split(Text, BracketArray[btBrace][btLeft], StringArray);
    try
      for I := Low(StringArray) to High(StringArray) do
        if Contains(StringArray[I], BracketArray[btBrace][btRight]) then
        begin
          J := GetInternalScriptIndex(StringArray[I], nil);
          if Builder.Size = 0 then
            Builder.Append(Parser.ScriptToString(ScriptArray[J], rmUserDeclared) + StringArray[I])
          else begin
            if Parameter then
            begin
              Script := ParameterToScript(ScriptArray[J], Parser.DefaultTypeHandle);
              try
                S := Parser.ScriptToString(Script, rmUserDeclared);
              finally
                Script := nil;
              end;
            end
            else S := Parser.ScriptToString(ScriptArray[J], rmUserDeclared);
            Builder.Append(Embrace(S + StringArray[I], Parser.Bracket));
          end;
        end
        else Builder.Append(StringArray[I]);
    finally
      StringArray := nil;
    end;
    Result := Builder.Text;
  finally
    Builder.Free;
  end;
end;
{$WARNINGS ON}

procedure GetFunction(const Parser: TCustomParser; var Index: Integer; out AFunction: PFunction);
var
  Item: PScriptItem absolute Index;
begin
  if Item.Code = FunctionCode then
  begin
    AFunction := Parser.FunctionByHandle[Item.ScriptFunction.Handle];
    Inc(Index, SizeOf(TCode) + SizeOf(TScriptFunction));
  end
  else AFunction := nil;
  if not Assigned(AFunction) then raise Error(ScriptError);
end;

function ParameterToScript(const Script: TScript; ATypeHandle: Integer): TScript;
begin
  Resize(Result, SizeOf(TScriptHeader) + SizeOf(TItemHeader));
  AddScript(Result, Script, True);
  with PItemHeader(@Result[SizeOf(TScriptHeader)])^ do
  begin
    Size := Length(Result) - SizeOf(TScriptHeader);
    TypeHandle := ATypeHandle;
  end;
  PScriptHeader(Result).ScriptSize := Length(Script);
end;

{$WARNINGS OFF}
function GetScriptFromValue(const Parser: TCustomParser; Value: TValue; TypeFlag: Boolean;
  ScriptType: TScriptType): TScript;
var
  ItemHeader: PItemHeader absolute Result;
  Script: TScript;
  ScriptHeader: PScriptHeader absolute Result;
begin
  Result := nil;
  case ScriptType of
    stSubscript:
      begin
        Resize(Result, SizeOf(TItemHeader));
        ItemHeader.Size := SizeOf(TItemHeader) + SizeOf(TCode) + SizeOf(TScriptNumber);
        ItemHeader.Sign := Ord(LessZero(Value));
        Value := Positive(Value);
        ItemHeader.TypeDeclarationFlag := TypeFlag;
        ItemHeader.TypeHandle := MakeTypeHandle(Parser, Value.ValueType);
        AddNumber(Result, Value);
      end;
    stScript:
      begin
        Resize(Result, SizeOf(TScriptHeader));
        Script := GetScriptFromValue(Parser, Value, TypeFlag, stSubscript);
        try
          Add(Result, Script, Length(Script));
        finally
          Script := nil;
        end;
        ScriptHeader.ScriptSize := Length(Result);
        ScriptHeader.HeaderSize := SizeOf(TScriptHeader);
      end;
  end;
end;
{$WARNINGS ON}

function GetScriptFromValue(const Parser: TCustomParser; Number: TNumber; ScriptType: TScriptType): TScript;
begin
  Result := GetScriptFromValue(Parser, Number.Value, Number.TypeFlag, ScriptType);
end;

function GetValueFromScript(const Parser: TCustomParser; Script: TScript; ScriptType: TScriptType): TValue;
begin
  case ScriptType of
    stSubscript:
      begin
        Result := PScriptItem(@Script[SizeOf(TItemHeader)]).ScriptNumber.Value;
        if Boolean(PItemHeader(Pointer(Script)).Sign) then Result := Negative(Result);
      end;
    stScript:
      Result := GetValueFromScript(Parser, @Script[SizeOf(TScriptHeader)], stSubscript);
  end;
end;

function GetParameter(const Parser: TObject; const Parameter: TParameter): TParameter;
var
  AParser: TParser absolute Parser;
  I, J: Integer;
  Item: PScriptItem absolute I;
  ItemHeader: PItemHeader;
begin
  with Parameter.Value do
  begin
    I := Int64Rec.Lo;
    ItemHeader := PItemHeader(Int64Rec.Hi);
  end;
  Result.TypeHandle := ItemHeader.TypeHandle;
  case Item.Code of
    NumberCode:
      Result.Value := Item.ScriptNumber.Value;
    FunctionCode:
      Result.Value := AParser.ExecuteFunction(I, ItemHeader, EmptyValue);
    StringCode:
      begin
        J := Item.ScriptString.Size;
        if J > SizeOf(TString) then J := SizeOf(TString);
        ZeroMemory(@Result.Text, SizeOf(TString));
        CopyMemory(@Result.Text, Pointer(I + SizeOf(TCode) + SizeOf(TScriptString)), J);
      end;
    ScriptCode:
      Result.Value := AParser.Execute(Integer(@Item.Script.Header))^;
  else raise ParseErrors.Error(ScriptError);
  end;
  if (Item.Code <> StringCode) and Boolean(ItemHeader.Sign) then
    Result.Value := Negative(Result.Value);
end;

function AsValue(const Parser: TObject; const Parameter: TParameter): TValue;
begin
  Result := GetParameter(Parser, Parameter).Value;
end;

function AsByte(const Parser: TObject; const Parameter: TParameter): Byte;
begin
  Result := Convert(AsValue(Parser, Parameter), vtByte).Unsigned8;
end;

function AsShortint(const Parser: TObject; const Parameter: TParameter): Shortint;
begin
  Result := Convert(AsValue(Parser, Parameter), vtShortint).Signed8;
end;

function AsWord(const Parser: TObject; const Parameter: TParameter): Word;
begin
  Result := Convert(AsValue(Parser, Parameter), vtWord).Unsigned16;
end;

function AsSmallint(const Parser: TObject; const Parameter: TParameter): Smallint;
begin
  Result := Convert(AsValue(Parser, Parameter), vtSmallint).Signed16;
end;

function AsLongword(const Parser: TObject; const Parameter: TParameter): Longword;
begin
  Result := Convert(AsValue(Parser, Parameter), vtLongword).Unsigned32;
end;

function AsInteger(const Parser: TObject; const Parameter: TParameter): Integer;
begin
  Result := Convert(AsValue(Parser, Parameter), vtInteger).Signed32;
end;

function AsInt64(const Parser: TObject; const Parameter: TParameter): Int64;
begin
  Result := Convert(AsValue(Parser, Parameter), vtInt64).Signed64;
end;

function AsSingle(const Parser: TObject; const Parameter: TParameter): Single;
begin
  Result := Convert(AsValue(Parser, Parameter), vtSingle).Float32;
end;

function AsDouble(const Parser: TObject; const Parameter: TParameter): Double;
begin
  Result := Convert(AsValue(Parser, Parameter), vtDouble).Float64;
end;

function AsBoolean(const Parser: TObject; const Parameter: TParameter): Boolean;
begin
  Result := Boolean(Convert(AsValue(Parser, Parameter), vtInteger).Signed32);
end;

function AsText(const Parser: TObject; const Parameter: TParameter): string;
begin
  Result := GetParameter(Parser, Parameter).Text;
end;

function AsBoolean(const Parser: TObject; const ParameterArray: TParameterArray;
  const Index: Integer; const Default: Boolean): Boolean;
begin
  if Default then
    Result := (High(ParameterArray) < Index) or AsBoolean(Parser, ParameterArray[Index])
  else
    Result := (High(ParameterArray) >= Index) and AsBoolean(Parser, ParameterArray[Index]);
end;

function Optimal(Script: TScript; ScriptType: TScriptType): Boolean;
const
  ScriptSize: array [TScriptType] of Integer = (SizeOf(TItemHeader) +
    SizeOf(TCode) + SizeOf(TScriptNumber), SizeOf(TScriptHeader) +
    SizeOf(TItemHeader) + SizeOf(TCode) + SizeOf(TScriptNumber));
  CodeOffset: array[TScriptType] of Integer = (SizeOf(TItemHeader),
    SizeOf(TScriptHeader) + SizeOf(TItemHeader));
begin
  Result := Assigned(Script);
  if Result then
    case ScriptType of
      stSubscript:
        Result := (PItemHeader(Script).Size = ScriptSize[ScriptType]) and
          (PInteger(@Script[CodeOffset[ScriptType]])^ = NumberCode);
      stScript:
        Result := (PScriptHeader(Script).ScriptSize = ScriptSize[ScriptType]) and
          (PInteger(@Script[CodeOffset[ScriptType]])^ = NumberCode);
    end;
end;

function TypeDeclarationFlag(Script: TScript; ScriptType: TScriptType): Boolean;
begin
  Result := Optimal(Script, stScript);
  if Result then
    case ScriptType of
      stSubscript:
        Result := PItemHeader(Script).TypeDeclarationFlag;
      stScript:
        Result := PItemHeader(@Script[SizeOf(TScriptHeader)]).TypeDeclarationFlag;
    end;
end;

function GetFunction(const Data: TFunctionData; Index: Integer; out AFunction: PFunction): Boolean;
begin
  Result := (Index >= 0) and (Index < Length(Data.FOrder));
  if Result then
  begin
    Index := Data.FOrder[Index];
    Result := (Index >= 0) and (Index < Length(Data.FArray));
    if Result then AFunction := @Data.FArray[Index];
  end;
end;

function FunctionByIndex(const Data: TFunctionData; Index: Integer): PFunction;
begin
  if not GetFunction(Data, Index, Result) then Result := nil;
end;

function GetFlagArray(const Text: string; const LockType: TLockType; const Data: TFunctionData;
  out FlagArray: TFunctionFlagArray; const Method: TFunctionFlagMethod): Boolean;
type
  TTextItem = record
    AFunction: PFunction;
    Index: Integer;
    Whole: Boolean;
  end;

  function Insert(var Item: TTextItem): Boolean;
  begin
    Result := not Assigned(Method) or Method(Item.AFunction);
    if Result then
      Add(FlagArray, Item.Index, Item.AFunction);
    Item.AFunction := nil;
  end;

  function Broken(const Item: TTextItem; const Index: Integer): Boolean;
  var
    I: Integer;
  begin
    for I := Index - 1 downto Item.Index + Integer(StrLen(Item.AFunction.Name)) do
      if not CharInSet(Text[I], WholeDelimiters) then
      begin
        Result := True;
        Exit;
      end;
    Result := False;
  end;

var
  TextArray: TTextArray;
  Item: TTextItem;
  I, J, K, Count: Integer;
  AFunction: PFunction;
  Flag: Boolean;
begin
  FlagArray := nil;
  TextArray := GetTextArray(Text, LockType);
  try
    Item.AFunction := nil;
    I := 1;
    Count := Length(Text);
    while I <= Count do
      if Locked(I, TextArray) then Inc(I)
      else begin
        J := Low(Data.FOrder);
        while (I <= Count) and GetFunction(Data, J, AFunction) do
        begin
          K := StrLen(AFunction.Name);
          Flag := (K = 0) or (I + K - 1 > Count) or not SameText(AFunction.Name, @Text[I], K);
          if Flag then Inc(J)
          else
            try
              Flag := not AFunction.Whole or AFunction.Whole and Whole(Text, I, K);
              if Assigned(Item.AFunction) then
                if not Broken(Item, I) then
                begin
                  Flag := Flag or not Item.AFunction.Whole;
                  if Flag then Insert(Item)
                  else Continue;
                end
                else if Item.Whole then Insert(Item);
              Item.AFunction := AFunction;
              Item.Index := I;
              Item.Whole := Flag;
              J := 0;
            finally
              Inc(I, K);
            end;
        end;
        Inc(I);
      end;
    if Assigned(Item.AFunction) and Item.Whole then Insert(Item);
  finally
    TextArray := nil;
  end;
  Result := Assigned(FlagArray);
end;

function GetItemArray(const Text: string; var Data: TFunctionData; out ItemArray: TStringDynArray;
  Prepare: Boolean = False; LockType: TLockType = ltChar): Boolean;
var
  FlagArray: TFunctionFlagArray;
  I, J, K: Integer;
  S: string;
begin
  ItemArray := nil;
  if Prepare then PrepareFData(PFunctionData(@Data));
  if GetFlagArray(Text, LockType, Data, FlagArray) then
  try
    for I := Low(FlagArray) to Length(FlagArray) do
    begin
      if I > Low(FlagArray) then
      begin
        J := FlagArray[I - 1].Index;
        if I < High(FlagArray) + 1 then K := FlagArray[I].Index - J
        else K := Length(Text) - J + 1;
      end
      else begin
        J := 1;
        K := FlagArray[I].Index - 1;
      end;
      S := Trim(Copy(Text, J, K));
      if S <> '' then Add(ItemArray, S);
    end;
  finally
    FlagArray := nil;
  end;
  if not Assigned(ItemArray) then
  begin
    S := Trim(Text);
    if S <> '' then Add(ItemArray, S);
  end;
  Result := Assigned(ItemArray);
end;

procedure DeleteParameterOperator(var Text: string);
var
  I: Integer;
  Found: Boolean;
begin
  repeat
    for I := Ord(Low(ParameterOperatorArray)) to Ord(High(ParameterOperatorArray)) do
    begin
      Found := CutText(Text, ParameterOperatorArray[TParameterOperator(I)]);
      if Found then Break;
    end;
  until not Found;
end;

function GetSign(var Text: string): Boolean;
var
  Flag: Boolean;
begin
  repeat
    Flag := CutText(Text, SignArray[stNegative]);
    Result := Flag;
    while Flag do
    begin
      Flag := CutText(Text, SignArray[stNegative]);
      Result := Result xor Flag;
    end;
  until not CutText(Text, SignArray[stPositive]);
end;

function GetFunction(const Data: PFunctionData; var Text: string;
  const Cut: Boolean): PFunction;
var
  I: Integer;
  AFunction: PFunction;
begin
  PrepareFData(Data);
  for I := Low(Data.FOrder) to High(Data.FOrder) do
    if GetFunction(Data^, I, AFunction) and
      (not AFunction.Whole or Whole(Text, 1, StrLen(AFunction.Name))) and
      CutText(Text, AFunction.Name, Cut) then
      begin
        Result := AFunction;
        Exit;
      end;
  Result := nil;
end;

function GetType(const Parser: TCustomParser; const StringHandle: Integer;
  var Text: string; const Cut: Boolean): PType;
var
  Data: PTypeData;
  I: Integer;
  AType: PType;
begin
  PrepareTData(Parser);
  Data := Parser.TData;
  if Dequoted(Text) then Result := @Data.TArray[StringHandle]
  else begin
    for I := Low(Data.TOrder) to High(Data.TOrder) do
      if GetType(Data^, I, AType) and Whole(Text, 1, StrLen(AType.Name)) and
        CutText(Text, AType.Name, Cut) then
        begin
          Result := AType;
          Exit;
        end;
    Result := nil;
  end;
end;

procedure WriteItemHeader(const ItemHeader: PItemHeader; const ASign: Boolean; const AType: PType;
  const DefaultTypeHandle: Integer);
begin
  ItemHeader.Sign := Ord(ASign);
  ItemHeader.TypeDeclarationFlag := Assigned(AType);
  if ItemHeader.TypeDeclarationFlag then ItemHeader.TypeHandle := AType.Handle^
  else ItemHeader.TypeHandle := DefaultTypeHandle;
end;

function GetInternalScriptIndex(var Text: string; const Parameter: PBoolean): Integer;
var
  I: Integer;
begin
  if Assigned(Parameter) then Parameter^ := CutText(Text, ParameterPrefix)
  else CutText(Text, ParameterPrefix);
  I := Pos(BracketArray[btBrace][btRight], Text);
  Result := StrToInt(Copy(Text, 1, I - 1));
  System.Delete(Text, 1, I);
end;

function GetLockArray(const Text: string; const LockBracket: TBracket): TLockArray;
var
  I, J: Integer;
begin
  Result := nil;
  I := 1;
  while I < Length(Text) do
    if Text[I] = LockBracket[btLeft] then
    begin
      J := NextBracket(Text, LockBracket, I);
      if J > 0 then
      begin
        Add(Result, I, J);
        I := J;
      end
      else Inc(I);
    end
    else Inc(I);
end;

function GetLockArray(const Text: string; const LockChar: Char): TLockArray;
var
  I, J: Integer;
begin
  Result := nil;
  J := -1;
  for I := 1 to Length(Text) do
    if (Text[I] = LockChar) and ((I = 1) or (Text[I - 1] <> LockChar)) and
      ((I = Length(Text)) or (Text[I + 1] <> LockChar)) then
        if J < 0 then J := I
        else begin
          Add(Result, J, I);
          J := -1;
        end;
end;

function GetTextArray(const Text: string; const LockBracket: TBracket): TTextArray;
var
  LockArray: TLockArray;
begin
  LockArray := GetLockArray(Text, LockBracket);
  try
    Result := GetTextArray(Text, LockArray);
  finally
    LockArray := nil;
  end;
end;

function GetTextArray(const Text: string; const LockChar: Char): TTextArray;
var
  LockArray: TLockArray;
begin
  LockArray := GetLockArray(Text, LockChar);
  try
    Result := GetTextArray(Text, LockArray);
  finally
    LockArray := nil;
  end;
end;

function GetTextArray(const Text: string; const LockArray: TLockArray): TTextArray;
var
  I, J: Integer;
begin
  Resize(Result, Length(Text));
  for I := Low(LockArray) to High(LockArray) do
    for J := LockArray[I].StartIndex to LockArray[I].EndIndex - 1 do
      Result[J] := Ord(True);
end;

function GetTextArray(const Text: string; const LockType: TLockType): TTextArray;
begin
  case LockType of
    ltBracket: Result := GetTextArray(Text, LockBracket);
    ltChar: Result := GetTextArray(Text, LockChar);
  end;
end;

function Locked(const Index: Integer; const LockArray: TLockArray): Boolean;
var
  I: Integer;
begin
  for I := Low(LockArray) to High(LockArray) do
    if (Index >= LockArray[I].StartIndex) and (Index <= LockArray[I].EndIndex) then
    begin
      Result := True;
      Exit;
    end;
  Result := False;
end;

function Locked(const Index: Integer; const TextArray: TTextArray): Boolean;
begin
  Result := (Index < 1) or (Index > Length(TextArray)) or Boolean(TextArray[Index - 1]);
end;

procedure ParseBracket(var Text: string; const Bracket: TBracket; const Method: TBracketMethod;
  const Data: Pointer);
var
  I: Integer;
  TextArray: TTextArray;
  AData: TBracketData;

  procedure Reset;
  begin
    I := 1;
    TextArray := GetTextArray(Text, ltChar);
    FillChar(AData, SizeOf(TBracketData), 0);
    AData.StartIndex := MaxInt;
  end;

begin
  if not Assigned(Method) then Exit;
  if SubTextCount(Text, Bracket[btLeft]) <> SubTextCount(Text, Bracket[btRight]) then
    raise Error(BracketError);
  try
    Reset;
    while I <= Length(Text) do
    begin
      if not Locked(I, TextArray) then
        if Text[I] = Bracket[btLeft] then
        begin
          if AData.StartIndex > I then AData.StartIndex := I;
          Inc(AData.StartCount);
        end
        else if Text[I] = Bracket[btRight] then
        begin
          AData.EndIndex := I;
          Inc(AData.EndCount);
        end;
      if (AData.StartCount > 0) and (AData.StartCount = AData.EndCount) and
        (AData.StartIndex < AData.EndIndex) then
          if Method(Text, Copy(Text, AData.StartIndex + 1, AData.EndIndex - AData.StartIndex - 1),
            AData.StartIndex, AData.EndIndex, Data) then Reset
          else Break
        else Inc(I);
    end;
  finally
    TextArray := nil;
  end;
end;

function NextBracket(const Text: string; const Bracket: TBracket; Index: Integer): Integer;
var
  I, J: Integer;
begin
  Result := 0;
  I := 0;
  J := 0;
  while Index <= Length(Text) do
  begin
    if Text[Index] = Bracket[btLeft] then Inc(I)
    else if Text[Index] = Bracket[btRight] then Inc(J);
    if (I > 0) and (I = J) then
    begin
      Result := Index;
      Break;
    end
    else Inc(Index);
  end;
end;

function PreviousBracket(const Text: string; const Bracket: TBracket; Index: Integer): Integer;
var
  I, J: Integer;
begin
  Result := 0;
  I := 0;
  J := 0;
  while Index > 0 do
  begin
    if Text[Index] = Bracket[btLeft] then Inc(I)
    else if Text[Index] = Bracket[btRight] then Inc(J);
    if (I > 0) and (I = J) then
    begin
      Result := Index;
      Break;
    end
    else Dec(Index);
  end;
end;

function Embrace(const Text: string; const Bracket: TBracket): string;
begin
  Result := Bracket[btLeft] + Text + Bracket[btRight];
end;

function Embraced(const Text: string; const Bracket: TBracket): Boolean;
var
  I: Integer;
begin
  I := Length(Text);
  Result := (I >= Length(Bracket)) and (Text[1] = Bracket[btLeft]) and
    (Text[I] = Bracket[btRight]);
end;

procedure DeleteBracket(var Text: string; const Index: Integer; const Bracket: TBracket);
var
  I, J: Integer;
begin
  for I := Index to Length(Text) do
  begin
    if Text[I] = Bracket[btLeft] then
    begin
      J := NextBracket(Text, Bracket, Index);
      if J > 0 then
      begin
        System.Delete(Text, I, 1);
        System.Delete(Text, J - 1, 1);
      end;
      Break;
    end
    else if not CharInSet(Text[I], Blanks) then Break;
  end;
end;

procedure ChangeBracket(var Text: string; const Index: Integer;
  const BracketFrom, BracketTo: TBracket);
var
  I, J: Integer;
begin
  for I := Index to Length(Text) do
  begin
    if Text[I] = BracketFrom[btLeft] then
    begin
      J := NextBracket(Text, BracketFrom, Index);
      if J > 0 then
      begin
        Text[I] := BracketTo[btLeft];
        Text[J] := BracketTo[btRight];
      end;
      Break;
    end
    else if not CharInSet(Text[I], Blanks) then Break;
  end;
end;

function BracketFunction(const AFunction: PFunction): Boolean;
begin
  Result := AFunction.Method.Parameter.Count > 0;
end;

procedure ChangeBracket(var Text: string; const Data: TFunctionData;
  const BracketFrom, BracketTo: TBracket);
var
  FlagArray: TFunctionFlagArray;
  I: Integer;
begin
  if GetFlagArray(Text, ltChar, Data, FlagArray, BracketFunction) then
  try
    for I := Low(FlagArray) to High(FlagArray) do
      ChangeBracket(Text, FlagArray[I].Index + Integer(StrLen(FlagArray[I].AFunction.Name)),
        BracketFrom, BracketTo);
  finally
    FlagArray := nil;
  end;
end;

function Lower(const Text: string): string;
var
  Builder: TTextBuilder;
  I: Integer;
begin
  Builder := TTextBuilder.Create;
  try
    for I := 0 to SubTextCount(Text, LockChar) do
      if Odd(I) then Builder.Append(SubText(Text, LockChar, I))
      else Builder.Append(LowerCase(SubText(Text, LockChar, I)));
    Result := Builder.Text;
  finally
    Builder.Free;
  end;
end;

function Upper(const Text: string): string;
var
  Builder: TTextBuilder;
  I: Integer;
begin
  Builder := TTextBuilder.Create;
  try
    for I := 0 to SubTextCount(Text, LockChar) do
      if Odd(I) then Builder.Append(SubText(Text, LockChar, I))
      else Builder.Append(UpperCase(SubText(Text, LockChar, I)));
    Result := Builder.Text;
  finally
    Builder.Free;
  end;
end;

function Whole(const Text: string; const Index, Count: Integer): Boolean;
begin
  Result := (Index + Count - 1 <= Length(Text)) and
    ((Index = 1) or CharInSet(Text[Index - 1], WholeDelimiters)) and
    ((Index + Count - 1 = Length(Text)) or
    CharInSet(Text[Index + Count], WholeDelimiters));
end;

function FollowingText(const Text: string; const Index: Integer): string;
var
  I, J: Integer;
begin
  I := Index;
  J := Length(Text);
  while (I < J) and not CharInSet(Text[I + 1], WholeDelimiters) do Inc(I);
  Result := Copy(Text, Index, I - Index + 1);
end;

function PrecedingText(const Text: string; const Index: Integer): string;
var
  I: Integer;
begin
  I := Index;
  while (I > 1) and not CharInSet(Text[I - 1], WholeDelimiters) do Dec(I);
  Result := Copy(Text, I, Index - I);
end;

function WholeValue(const Parser: TCustomParser; const Data: PFunctionData;
  const Text: string; const Index, Count: Integer): Boolean;
var
  I, J: Integer;
  FlagArray: TFunctionFlagArray;
  Flag: PFunctionFlag;

  function Check(const S: string): Boolean;
  var
    AFunction: PFunction;
    I: Integer;
  begin
    Result := Trim(S) = '';
    if not Result then
      if Assigned(Parser) then
      begin
        AFunction := Parser.FindFunction(S);
        Result := (not Assigned(AFunction) or not AFunction.Whole) and not Assigned(Parser.FindType(S));
      end
      else begin
        PrepareFData(Data);
        I := Data.NameList.List.IndexOf(S);
        if I < 0 then
          AFunction := nil
        else begin
          I := Integer(Data.NameList.List.Objects[I]);
          if (I < Low(Data.FArray)) or (I > High(Data.FArray)) then
            AFunction := nil
          else
            AFunction := @Data.FArray[I];
        end;
        Result := not Assigned(AFunction) or not AFunction.Whole;
      end;
  end;

begin
  Result := Whole(Text, Index, Count);
  if not Result then
  begin
    Result := Check(PrecedingText(Text, Index)) and Check(FollowingText(Text, Index + Count));
    if Result then
    begin
      GetFlagArray(Text, ltChar, Data^, FlagArray);
      try
        J := Index + Count;
        for I := Low(FlagArray) to High(FlagArray) do
        begin
          Flag := @FlagArray[I];
          if (Flag.Index <= Index) and (Flag.Index + Integer(StrLen(Flag.AFunction.Name)) >= J) then
          begin
            Result := False;
            Exit;
          end;
        end;
      finally
        FlagArray := nil;
      end;
    end;
  end;
end;

function GotoBody(const Data: string; const Bracket: TBracket; var Index: Integer;
  const Count: Integer): Boolean;
begin
  Result := Whole(Data, Index, Count);
  if Result then
  begin
    Inc(Index, Count);
    while CharInSet(Data[Index], Blanks) do Inc(Index);
    Result := Data[Index] = Bracket[btLeft];
  end;
end;

function FindBody(const Name, Data: string; const Bracket: TBracket; out Index, Count: Integer): Boolean;
var
  TextArray: TTextArray;

  function Find: Boolean;
  var
    I: Integer;
  begin
    Result := Index > 0;
    if Result then
    begin
      Result := not Locked(Index, TextArray);
      I := Index;
      if Result then Result := GotoBody(Data, Bracket, Index, Count);
      if not Result then
      begin
        Index := PosEx(Name, Data, I + Count);
        Result := Find;
      end;
    end;
  end;

begin
  Index := Pos(Name, Data);
  Result := Index > 0;
  if Result then
  begin
    TextArray := GetTextArray(Data, Bracket);
    try
      Count := Length(Name);
      Result := Find;
    finally
      TextArray := nil;
    end;
    if Result then
    begin
      Count := NextBracket(Data, Bracket, Index) - Index;
      Result := Count > 0;
    end;
  end;
end;

function BodyText(const Name, Data: string; const Bracket: TBracket; out Text: string): Boolean;
var
  I, J: Integer;
begin
  Result := FindBody(Name, Data, Bracket, I, J);
  if Result then Text := Copy(Data, I + 1, J - 1)
  else Text := '';
end;

function Dequote(const Text: string): string;
var
  I, J: Integer;
begin
  Result := Trim(Text);
  I := 1;
  J := Length(Result);
  while Result[I] = LockChar do Inc(I);
  if I > J then Result := ''
  else begin
    while Result[J] = LockChar do Dec(J);
    Result := Trim(Copy(Result, I, J - I + 1));
  end;
end;

function DequoteDouble(const Text, FunctionName: string; const Bracket: TBracket): string;
var
  I, J, AIndex, BIndex: Integer;
begin
  Result := Text;
  I := Pos(FunctionName, Result);
  if I > 0 then
  begin
    I := PosEx(Bracket[btLeft], Result, I + Length(FunctionName));
    if I > 0 then
    begin
      J := PosEx(LockChar, Result, I);
      if (J > 0) and (J < Length(Result)) and (Result[J + 1] = LockChar) then
      begin
        AIndex := J;
        I := NextBracket(Result, Bracket, I);
        while (I > 0) and (Result[I] <> LockChar) do Dec(I);
        BIndex := I;
        if (BIndex < Length(Result)) and (Result[BIndex] = LockChar) and
          (AIndex < BIndex) and (Result[BIndex] = LockChar) then
          begin
            System.Delete(Result, AIndex, 1);
            System.Delete(Result, BIndex - 1, 1);
          end;
      end;
    end;
  end;
end;

function Dequoted(const Text: string): Boolean;
begin
  Result := (Length(Text) > 1) and (Text[1] = LockChar) and (Text[Length(Text)] = LockChar);
end;

function MakeTemplate(const Parser: TCustomParser; const Data: PFunctionData;
  const Text: string; const ValueArray: PValueArray;
  const NumberTemplate: string): string;
var
  Builder: TTextBuilder;
  TextArray: TTextArray;
  I, J, K, L, Count: Integer;
  Negative, Flag: Boolean;
  Value: TValue;
begin
  Builder := TTextBuilder.Create(Length(Text));
  try
    TextArray := GetTextArray(Text, ltChar);
    try
      I := 1;
      Count := Length(Text);
      while I <= Count do
        if Locked(I, TextArray) then
        begin
          Builder.Append(Text[I]);
          Inc(I)
        end
        else if CharInSet(Text[I], Signs + Digits) then
        begin
          K := I;
          Negative := False;
          Flag := CharInSet(Text[I], Signs);
          if Flag then
          begin
            Negative := Text[I] = Minus;
            Inc(I);
          end;
          while CharInSet(Text[I], Blanks) and (I <= Count) do Inc(I);
          J := I;
          L := 0;
          while CharInSet(Text[J], Digits) and (J <= Count) do
          begin
            Inc(J);
            if (J < Count) and (Text[J] = {$IFDEF DELPHI_XE}FormatSettings.DecimalSeparator{$ELSE}DecimalSeparator{$ENDIF}) and
              CharInSet(Text[J + 1], Digits) then
                if L = 0 then
                begin
                  Inc(J);
                  Inc(L);
                end
                else Break;
          end;
          Dec(J, I);
          if WholeValue(Parser, Data, Text, I, J) and TryTextToValue(Copy(Text, I, J), Value) then
          begin
            if Flag then
              Builder.Append(Plus + NumberTemplate)
            else
              Builder.Append(NumberTemplate);
            if Assigned(ValueArray) then
              if Negative then
                ValueTypes.Add(ValueArray^, ValueUtils.Negative(Value))
              else
                ValueTypes.Add(ValueArray^, Value);
          end
          else Builder.Append(Copy(Text, K, I + J - K));
          Inc(I, J);
        end
        else begin
          if not CharInSet(Text[I], Blanks) then Builder.Append(Text[I]);
          Inc(I);
        end;
      Result := Builder.Text;
      if Result = '' then Result := NumberChar[ntZero];
    finally
      TextArray := nil;
    end;
  finally
    Builder.Free;
  end;
end;

function WriteValue(Index: Integer; var ValueIndex: Integer; const ValueArray: TValueArray;
  const ScriptType: TScriptType): Boolean;
var
  I, J: Integer;
  Header: PScriptHeader absolute I;
  ItemHeader: PItemHeader absolute J;
  Item: PScriptItem absolute Index;
begin
  Result := Assigned(ValueArray) and (ValueIndex < Length(ValueArray));
  if Result then
    case ScriptType of
      stSubscript:
        begin
          J := Index;
          Inc(Index, SizeOf(TItemHeader));
          while Index - J < ItemHeader.Size do
            case Item.Code of
              NumberCode:
                begin
                  ItemHeader.Sign := Ord(LessZero(ValueArray[ValueIndex]));
                  Item.ScriptNumber.Value := Positive(ValueArray[ValueIndex]);
                  Inc(ValueIndex);
                  if ValueIndex > High(ValueArray) then Exit;
                  Inc(Index, SizeOf(TCode) + SizeOf(TScriptNumber));
                end;
              FunctionCode:
                Inc(Index, SizeOf(TCode) + SizeOf(TScriptFunction));
              StringCode:
                Inc(Index, SizeOf(TCode) + SizeOf(TScriptString) + Item.ScriptString.Size);
              ScriptCode, ParameterCode:
                begin
                  WriteValue(Index + SizeOf(TCode), ValueIndex, ValueArray, ScriptType);
                  if ValueIndex > High(ValueArray) then Exit;
                  Inc(Index, SizeOf(TCode) + Item.Script.Header.ScriptSize);
                end;
            else raise Error(ScriptError);
            end;
        end;
      stScript:
        begin
          I := Index;
          Inc(Index, Header.HeaderSize);
          while Index - I < Header.ScriptSize do
          begin
            J := Index;
            Inc(Index, SizeOf(TItemHeader));
            while Index - J < ItemHeader.Size do
              case Item.Code of
                NumberCode:
                  begin
                    ItemHeader.Sign := Ord(LessZero(ValueArray[ValueIndex]));
                    Item.ScriptNumber.Value := Positive(ValueArray[ValueIndex]);
                    Inc(ValueIndex);
                    if ValueIndex > High(ValueArray) then Exit;
                    Inc(Index, SizeOf(TCode) + SizeOf(TScriptNumber));
                  end;
                FunctionCode:
                  Inc(Index, SizeOf(TCode) + SizeOf(TScriptFunction));
                StringCode:
                  Inc(Index, SizeOf(TCode) + SizeOf(TScriptString) + Item.ScriptString.Size);
                ScriptCode, ParameterCode:
                  begin
                    WriteValue(Index + SizeOf(TCode), ValueIndex, ValueArray, ScriptType);
                    if ValueIndex > High(ValueArray) then Exit;
                    Inc(Index, SizeOf(TCode) + Item.Script.Header.ScriptSize);
                  end;
              else raise Error(ScriptError);
              end;
          end;
        end;
    end;
end;

function Add(var Script: TScript; const Value: Smallint): Integer;
begin
  Result := Length(Script);
  SetLength(Script, Result + SizeOf(Smallint));
  PSmallint(@Script[Result])^ := Value;
end;

function Add(var Script: TScript; const Value: Word): Integer;
begin
  Result := Add(Script, Smallint(Value));
end;

function Add(var Script: TScript; const Value: Integer): Integer;
begin
  Result := Length(Script);
  SetLength(Script, Result + SizeOf(Integer));
  PInteger(@Script[Result])^ := Value;
end;

function Add(var Script: TScript; const Value: Longword): Integer;
begin
  Result := Add(Script, Integer(Value));
end;

function Add(var Script: TScript; const Value: Int64): Integer;
begin
  Result := Length(Script);
  SetLength(Script, Result + SizeOf(Int64));
  PInt64(@Script[Result])^ := Value;
end;

function Add(var Script: TScript; const Value: Single): Integer;
begin
  Result := Length(Script);
  SetLength(Script, Result + SizeOf(Double));
  PDouble(@Script[Result])^ := Value;
end;

function Add(var Script: TScript; const Value: Double): Integer;
begin
  Result := Length(Script);
  SetLength(Script, Result + SizeOf(Double));
  PDouble(@Script[Result])^ := Value;
end;

function Add(var Script: TScript; const Value: Extended): Integer;
begin
  Result := Length(Script);
  SetLength(Script, Result + SizeOf(Double));
  PDouble(@Script[Result])^ := Value;
end;

function Add(var Script: TScript; const Value: TValue): Integer;
begin
  Result := Length(Script);
  SetLength(Script, Result + SizeOf(TValue));
  PValue(@Script[Result])^ := Value;
end;

function Add(var Script: TScript; const Value: TScriptNumber): Integer;
begin
  Result := Length(Script);
  SetLength(Script, Result + SizeOf(TScriptNumber));
  PScriptNumber(@Script[Result])^ := Value;
end;

function Add(var Script: TScript; const Value: TScriptFunction): Integer;
begin
  Result := Length(Script);
  SetLength(Script, Result + SizeOf(TScriptFunction));
  PScriptFunction(@Script[Result])^ := Value;
end;

function Add(var Target: TScript; const Source: TScript): Integer;
begin
  Result := Add(Target, Source, Length(Source));
end;

function Add(var Script: TScript; const Source: Pointer; const Count: Integer): Integer;
begin
  Result := Length(Script);
  SetLength(Script, Result + Count);
  CopyMemory(@Script[Result], Source, Count);
end;

function Add(var Script: TScript; const Text: string): Integer;
begin
  Result := Add(Script, Pointer(Text), Length(Text) * SizeOf(Char));
end;

function Add(var ScriptArray: TScriptArray; const Value: TScript): Integer;
begin
  Result := Length(ScriptArray);
  SetLength(ScriptArray, Result + 1);
  if Assigned(Value) then Add(ScriptArray[Result], Value, Length(Value));
end;

function Add(var Data: TFunctionData; const AFunction: TFunction): Integer;
var
  I: Integer;
  BFunction: PFunction;
begin
  with Data do
  begin
    for I := Low(FArray) to High(FArray) do
    begin
      BFunction := @FArray[I];
      if StrLen(BFunction.Name) = 0 then
      begin
        Result := I;
        BFunction^ := AFunction;
        Exit;
      end;
    end;
    Result := Length(FArray);
    SetLength(FArray, Result + 1);
    Add(FArray, @AFunction, Result * SizeOf(TFunction), SizeOf(TFunction));
    Prepared := False;
  end;
end;

function Add(var Data: TTypeData; const AType: TType): Integer;
var
  I: Integer;
  BType: PType;
begin
  with Data do
  begin
    for I := Low(TArray) to High(TArray) do
    begin
      BType := @TArray[I];
      if StrLen(BType.Name) = 0 then
      begin
        Result := I;
        BType^ := AType;
        Exit;
      end;
    end;
    Result := Length(TArray);
    SetLength(TArray, Result + 1);
    Add(TArray, @AType, Result * SizeOf(TType), SizeOf(TType));
    Prepared := False;
  end;
end;

function Add(var ParameterArray: TParameterArray; const ATypeHandle: Integer;
  const AValue: TValue): Integer;
begin
  Result := Length(ParameterArray);
  SetLength(ParameterArray, Result + 1);
  with ParameterArray[Result] do
  begin
    TypeHandle := ATypeHandle;
    Value := AValue;
  end;
end;

function Add(var ParameterArray: TParameterArray; const ATypeHandle: Integer;
  const AValue: string): Integer;
begin
  Result := Length(ParameterArray);
  SetLength(ParameterArray, Result + 1);
  with ParameterArray[Result] do
  begin
    TypeHandle := ATypeHandle;
    StrLCopy(Text, PChar(AValue), SizeOf(TString) - 1);
  end;
end;

function Add(var FlagArray: TFunctionFlagArray; const AIndex: Integer;
  const BFunction: PFunction): Integer;
begin
  Result := Length(FlagArray);
  SetLength(FlagArray, Result + 1);
  with FlagArray[Result] do
  begin
    Index := AIndex;
    AFunction := BFunction;
  end;
end;

function Add(var LockArray: TLockArray; const AStartIndex, AEndIndex: Integer): Integer;
begin
  Result := Length(LockArray);
  SetLength(LockArray, Result + 1);
  with LockArray[Result] do
  begin
    StartIndex := AStartIndex;
    EndIndex := AEndIndex;
  end;
end;

procedure IncNumber(var Number: TNumber; const Value: TValue);
begin
  if Number.Valid then Number.Value := Operation(Number.Value, Value, otAdd)
  else begin
    Number.Value := Value;
    Number.Valid := True;
  end;
end;

procedure IncNumber(var Number: TNumber; const Parser: TCustomParser;
  const Script: TScript; const ScriptType: TScriptType);
begin
  IncNumber(Number, GetValueFromScript(Parser, Script, ScriptType));
  Number.TypeFlag := Number.TypeFlag or TypeDeclarationFlag(Script, ScriptType);
end;

procedure DeleteArray(var ScriptArray: TScriptArray);
var
  I: Integer;
begin
  for I := Low(ScriptArray) to High(ScriptArray) do ScriptArray[I] := nil;
  ScriptArray := nil;
end;

function Insert(var Script: TScript; Value: Int64; Index: Integer): Boolean;
var
  I: Integer;
begin
  I := Length(Script);
  SetLength(Script, I + SizeOf(Int64));
  Result := Insert(Script, @Value, Index, I, SizeOf(Int64));
end;

function Insert(var Script: TScript; Value, Index: Integer): Boolean;
var
  I: Integer;
begin
  I := Length(Script);
  SetLength(Script, I + SizeOf(Integer));
  Result := Insert(Script, @Value, Index, I, SizeOf(Integer));
end;

function Insert(var Script: TScript; Value: Byte; Index: Integer): Boolean;
var
  I: Integer;
begin
  I := Length(Script);
  SetLength(Script, I + SizeOf(Byte));
  Result := Insert(Script, @Value, Index, I, SizeOf(Byte));
end;

function FunctionCompare(const AIndex, BIndex: Integer; const Target, Data: Pointer): TValueRelationship;
var
  AData: PFunctionData absolute Target;
begin
  Result := CompareValue(StrLen(FunctionByIndex(AData^, BIndex).Name),
    StrLen(FunctionByIndex(AData^, AIndex).Name));
end;

procedure FunctionExchange(const AIndex, BIndex: Integer; const Target, Data: Pointer);
var
  I: Integer;
  AData: PFunctionData absolute Target;
begin
  I := AData.FOrder[AIndex];
  AData.FOrder[AIndex] := AData.FOrder[BIndex];
  AData.FOrder[BIndex] := I;
end;

procedure PrepareFData(const Data: PFunctionData);
var
  I: Integer;
begin
  if not Data.Prepared then
  begin
    SetLength(Data.FOrder, Length(Data.FArray));
    for I := Low(Data.FOrder) to High(Data.FOrder) do
      Data.FOrder[I] := I;
    QuickSort(Data, Low(Data.FArray), High(Data.FArray), FunctionCompare, FunctionExchange);
    for I := Low(Data.FArray) to High(Data.FArray) do
    begin
      SyncHandle(@Data.FArray[I]);
      if Assigned(Data.FArray[I].Handle) then Data.FArray[I].Handle^ := I;
    end;
    if not Assigned(Data.NameList) then
    begin
      Data.NameList := TFlexibleList.Create(nil);
      {$IFDEF DELPHI_7}
      Data.NameList.NameValueSeparator := Pipe;
      {$ENDIF}
    end;
    Data.NameList.List.Clear;
    for I := Low(Data.FArray) to High(Data.FArray) do
      Data.NameList.List.AddObject(Data.FArray[I].Name, Pointer(I));
    Data.Prepared := True;
  end;
end;

procedure PrepareFData(const Parser: TCustomParser);
begin
  PrepareFData(Parser.FData);
end;

function GetType(const Data: TTypeData; Index: Integer; out AType: PType): Boolean;
begin
  Result := (Index >= 0) and (Index < Length(Data.TOrder));
  if Result then
  begin
    Index := Data.TOrder[Index];
    Result := (Index >= 0) and (Index < Length(Data.TArray));
    if Result then AType := @Data.TArray[Index];
  end;
end;

function TypeByIndex(const Data: TTypeData; const Index: Integer): PType;
begin
  if not GetType(Data, Index, Result) then Result := nil;
end;

function TypeCompare(const AIndex, BIndex: Integer; const Target, Data: Pointer): TValueRelationship;
var
  AData: PTypeData absolute Target;
begin
  Result := CompareValue(StrLen(TypeByIndex(AData^, BIndex).Name),
    StrLen(TypeByIndex(AData^, AIndex).Name));
end;

procedure TypeExchange(const AIndex, BIndex: Integer; const Target, Data: Pointer);
var
  AData: PTypeData absolute Target;
  I: Integer;
begin
  I := AData.TOrder[AIndex];
  AData.TOrder[AIndex] := AData.TOrder[BIndex];
  AData.TOrder[BIndex] := I;
end;

procedure PrepareTData(const Parser: TCustomParser);
var
  Data: PTypeData;
  I: Integer;
begin
  Data := Parser.TData;
  if not Data.Prepared then
  begin
    SetLength(Data.TOrder, Length(Data.TArray));
    for I := Low(Data.TOrder) to High(Data.TOrder) do
      Data.TOrder[I] := I;
    QuickSort(Data, Low(Data.TArray), High(Data.TArray), TypeCompare, TypeExchange);
    Parser.DefaultTypeHandle := MakeTypeHandle(Data^, Parser.DefaultValueType, -1);
    if not Assigned(Data.NameList) then
    begin
      Data.NameList := TFlexibleList.Create(nil);
      {$IFDEF DELPHI_7}
      Data.NameList.NameValueSeparator := Pipe;
      {$ENDIF}
    end;
    Data.NameList.List.Clear;
    for I := Low(Data.TArray) to High(Data.TArray) do
      Data.NameList.List.AddObject(Data.TArray[I].Name, Pointer(I));
    Data.Prepared := True;
  end;
end;

function MakeTypeHandle(const Data: TTypeData; const ValueType: TValueType;
  const DefaultTypeHandle: Integer): Integer;
var
  I: Integer;
begin
  for I := Low(Data.TArray) to High(Data.TArray) do
    if Data.TArray[I].ValueType = ValueType then
    begin
      Result := I;
      Exit;
    end;
  Result := DefaultTypeHandle;
end;

function MakeTypeHandle(const Parser: TCustomParser; const ValueType: TValueType): Integer;
begin
  Result := MakeTypeHandle(Parser.TData^, ValueType, Parser.DefaultTypeHandle);
end;

function AssignValueType(const Parser: TCustomParser; const ItemHeader: PItemHeader;
  const ValueType: TValueType): Boolean;
var
  AType: PType;
begin
  AType := Parser.TypeByHandle[ItemHeader.TypeHandle];
  Result := not Assigned(AType) or not Assignable(ValueType, AType.ValueType);
  if Result then ItemHeader.TypeHandle := MakeTypeHandle(Parser, ValueType);
end;

function GetType(const Parser: TCustomParser; const ItemHeader: PItemHeader): PType;
begin
  with Parser do
  begin
    Result := TypeByHandle[ItemHeader.TypeHandle];
    if not Assigned(Result) then Result := TypeByHandle[DefaultTypeHandle];
  end;
end;

initialization
  ParseHelper := TParseHelper.Create;
  LockBracket := BracketArray[btParenthesis];
  LockChar := DoubleQuote;

finalization
  ParseHelper.Free;

end.
