{ *********************************************************************** }
{                                                                         }
{ ParseTypes                                                              }
{                                                                         }
{ Copyright (c) 2006 Pisarev Yuriy (post@pisarev.net)                     }
{                                                                         }
{ *********************************************************************** }

unit ParseTypes;

{$B-}

interface

uses
  SysUtils, Types, FlexibleList, ValueTypes;

const
  StringLength = 1024;

type
  TItemCode = (icNumber, icFunction, icString, icScript, icParameter);

  TString = array[0..StringLength - 1] of Char;

  PType = ^TType;
  TType = record
    Handle: PInteger;
    ValueType: TValueType;
    Name: TString;
  end;
  TTypeArray = array of TType;

  TTypeOrder = TIntegerDynArray;

  PTypeData = ^TTypeData;
  TTypeData = record
    TArray: TTypeArray;
    TOrder: TTypeOrder;
    NameList: TFlexibleList;
    Prepared: Boolean;
  end;

  TParameter = record
    TypeHandle: Integer;
    case Byte of
      0: (Value: TValue);
      1: (Text: TString);
  end;
  PParameterArray = ^TParameterArray;
  TParameterArray = array of TParameter;

  PFunction = ^TFunction;
  TFunctionKind = (fkHandle, fkMethod);

  TParameterlessMethod = function(const AFunction: PFunction; const AType: PType): TValue of object;
  TSingleParameterMethod = function(const AFunction: PFunction; const AType: PType;
    const Value: TValue): TValue of object;
  TDoubleParameterMethod = function(const AFunction: PFunction; const AType: PType;
    const LValue, RValue: TValue): TValue of object;
  TParameterArrayMethod = function(const AFunction: PFunction; const AType: PType;
    const ParameterArray: TParameterArray): TValue of object;

  TMethodType = (mtEmpty, mtParameterless, mtSingleParameter, mtDoubleParameter,
    mtParameterArray, mtVariable);

  TParameterKind = (pkValue, pkReference);
  PFunctionParameter = ^TFunctionParameter;
  TFunctionParameter = record
    Kind: TParameterKind;
    LParameter, RParameter: Boolean;
    Count: Integer;
  end;

  TVariableType = (vtValue, vtLiveValue);

  PFunctionVariable = ^TFunctionVariable;
  TFunctionVariable = record
    VariableType: TVariableType;
    // TFunction.Handle = @TFunctionVariable.Handle
    Handle: Integer;
    case Byte of
      0: (AVariable: PValue);
      1: (BVariable: TLiveValue);
  end;

  PFunctionMethod = ^TFunctionMethod;
  TFunctionMethod = record
    Parameter: TFunctionParameter;
    MethodType: TMethodType;
    Variable: TFunctionVariable;
    case Byte of
      0: (AMethod: TParameterlessMethod);
      1: (BMethod: TSingleParameterMethod);
      2: (CMethod: TDoubleParameterMethod);
      3: (DMethod: TParameterArrayMethod);
  end;

  TFunction = record
    Handle: PInteger;
    ReturnType: TValueType;
    Kind: TFunctionKind;
    Name: TString;
    Method: TFunctionMethod;
    Optimizable, Whole: Boolean;
  end;
  TFunctionArray = array of TFunction;

  TFunctionOrder = TIntegerDynArray;

  PFunctionData = ^TFunctionData;
  TFunctionData = record
    FArray: TFunctionArray;
    FOrder: TFunctionOrder;
    NameList: TFlexibleList;
    Prepared: Boolean;
  end;

  PScript = ^TScript;
  TScript = TByteDynArray;

  TScriptType = (stSubscript, stScript);

  PScriptArray = ^TScriptArray;
  TScriptArray = array of TScript;

  TItemData = record
    Code: TItemCode;
    case Byte of
      0: (Number: TValue);
      1: (AFunction: PFunction);
      2: (Text: TString);
      3: (Script: PScript);
  end;

  TBracketType = (btLeft, btRight);
  TBracket = array[TBracketType] of Char;

  TBracketData = record
    StartIndex, StartCount, EndIndex, EndCount: Integer;
  end;

  PNumber = ^TNumber;
  TNumber = record
    Value: TValue;
    Valid, TypeFlag: Boolean;
  end;

  PScriptHeader = ^TScriptHeader;
  TScriptHeader = record
    Value: TValue;
    ScriptSize: Integer;
    ScriptCount: Integer;
    HeaderSize: Integer;
  end;

  PItemHeader = ^TItemHeader;
  TItemHeader = record
    Size: Integer;
    Sign: Integer;
    TypeDeclarationFlag: Boolean;
    TypeHandle: Integer;
  end;

  TCode = Integer;

  PScriptNumber = ^TScriptNumber;
  TScriptNumber = record
    Value: TValue;
  end;

  PScriptFunction = ^TScriptFunction;
  TScriptFunction = record
    Handle: Integer;
  end;

  PInternalScript = ^TInternalScript;
  TInternalScript = record
    Header: TScriptHeader;
  end;

  TScriptString = record
    Size: Integer;
  end;

  PScriptItem = ^TScriptItem;
  TScriptItem = packed record
    Code: TCode;
    case Byte of
      0: (ScriptNumber: TScriptNumber);
      1: (ScriptFunction: TScriptFunction);
      2: (Script: TInternalScript);
      3: (ScriptString: TScriptString);
  end;

  TScriptMethod = function(var Index: Integer; const Header: PScriptHeader;
    const ItemHeader: PItemHeader; const Item: PScriptItem;
    const Data: Pointer): Boolean of object;

function MakeParameter(const ALParameter, ARParameter: Boolean; const ACount: Integer;
  const AKind: TParameterKind = pkValue): TFunctionParameter;
function MakeFunction(const AName: string; var AHandle: Integer;
  AReturnType: TValueType; AKind: TFunctionKind; AMethod: TFunctionMethod;
  AOptimizable, AWhole: Boolean): TFunction; overload;
function MakeType(const AName: string; var AHandle: Integer; AValueType: TValueType): TType;

function FunctionVariable(const Variable: PValue; const AHandle: PInteger = nil): TFunctionVariable; overload;
function FunctionVariable(const Variable: TLiveValue; const AHandle: PInteger = nil): TFunctionVariable; overload;
function FunctionMethod(const Parameter: TFunctionParameter): TFunctionMethod; overload;
function FunctionMethod(const LParameter, RParameter: Boolean; const Count: Integer;
  const Kind: TParameterKind = pkValue): TFunctionMethod; overload;
function FunctionMethod(const Method: TParameterlessMethod): TFunctionMethod; overload;
function FunctionMethod(const Method: TSingleParameterMethod;
  const AParameter: TFunctionParameter): TFunctionMethod; overload;
function FunctionMethod(const Method: TSingleParameterMethod; const LParameter, RParameter: Boolean;
  Kind: TParameterKind = pkValue): TFunctionMethod; overload;
function FunctionMethod(const Method: TDoubleParameterMethod): TFunctionMethod; overload;
function FunctionMethod(const Method: TParameterArrayMethod;
  const AParameter: TFunctionParameter): TFunctionMethod; overload;
function FunctionMethod(const Method: TParameterArrayMethod; const Count: Integer;
  const Kind: TParameterKind = pkValue): TFunctionMethod; overload;
function FunctionMethod(const AVariable: TFunctionVariable): TFunctionMethod; overload;
function FunctionMethod(const Variable: PValue; const AHandle: PInteger = nil): TFunctionMethod; overload;
function FunctionMethod(const Variable: TLiveValue; const AHandle: PInteger = nil): TFunctionMethod; overload;
function MakeFunction(const AFunction: PFunction; const AHandle: PInteger): Boolean; overload;
function MakeVariable(const AFunction: PFunction; const Variable: PValue): Boolean;
function SyncHandle(const AFunction: PFunction): Boolean; overload;

procedure AddNumber(var Script: TScript; const Value: TValue);
procedure AddFunction(var Script: TScript; const Handle: Integer);
procedure AddScript(var Target: TScript; const Source: TScript; const Parameter: Boolean;
  const ItemIndex: Pointer = nil);
procedure AddString(var Script: TScript; const S: string); overload;
procedure AddString(var Script: TScript; const Source: Pointer; const Count: Integer); overload;

implementation

uses
  MemoryUtils, ParseConsts, ParseUtils, ValueUtils;

function MakeParameter(const ALParameter, ARParameter: Boolean; const ACount: Integer;
  const AKind: TParameterKind): TFunctionParameter;
begin
  with Result do
  begin
    LParameter := ALParameter;
    RParameter := ARParameter;
    Count := ACount;
    Kind := AKind;
  end;
end;

function MakeFunction(const AName: string; var AHandle: Integer;
  AReturnType: TValueType; AKind: TFunctionKind; AMethod: TFunctionMethod;
  AOptimizable, AWhole: Boolean): TFunction;
begin
  with Result do
  begin
    StrLCopy(Name, PChar(AName), SizeOf(TString) - 1);
    Handle := @AHandle;
    ReturnType := AReturnType;
    Kind := AKind;
    Method := AMethod;
    Optimizable := AOptimizable;
    Whole := AWhole;
  end;
end;

function MakeType(const AName: string; var AHandle: Integer; AValueType: TValueType): TType;
begin
  with Result do
  begin
    StrLCopy(Name, PChar(AName), SizeOf(TString) - 1);
    Handle := @AHandle;
    ValueType := AValueType;
  end;
end;

function FunctionVariable(const Variable: PValue; const AHandle: PInteger): TFunctionVariable;
begin
  FillChar(Result, SizeOf(TFunctionVariable), 0);
  with Result do
  begin
    VariableType := vtValue;
    if Assigned(AHandle) then Handle := AHandle^;
    AVariable := Variable;
  end;
end;

function FunctionVariable(const Variable: TLiveValue; const AHandle: PInteger): TFunctionVariable;
begin
  FillChar(Result, SizeOf(TFunctionVariable), 0);
  with Result do
  begin
    VariableType := vtLiveValue;
    if Assigned(AHandle) then Handle := AHandle^;
    BVariable := Variable;
  end;
end;

function FunctionMethod(const Parameter: TFunctionParameter): TFunctionMethod;
begin
  FillChar(Result, SizeOf(TFunctionMethod), 0);
  Result.Parameter := Parameter;
end;

function FunctionMethod(const LParameter, RParameter: Boolean; const Count: Integer;
  const Kind: TParameterKind = pkValue): TFunctionMethod;
begin
  Result := FunctionMethod(MakeParameter(LParameter, RParameter, Count, Kind));
end;

function FunctionMethod(const Method: TParameterlessMethod): TFunctionMethod;
begin
  FillChar(Result, SizeOf(TFunctionMethod), 0);
  with Result do
  begin
    MethodType := mtParameterless;
    AMethod := Method;
  end;
end;

function FunctionMethod(const Method: TSingleParameterMethod;
  const AParameter: TFunctionParameter): TFunctionMethod;
begin
  FillChar(Result, SizeOf(TFunctionMethod), 0);
  with Result do
  begin
    Parameter := AParameter;
    MethodType := mtSingleParameter;
    BMethod := Method;
  end;
end;

function FunctionMethod(const Method: TSingleParameterMethod; const LParameter, RParameter: Boolean;
  Kind: TParameterKind): TFunctionMethod;
begin
  Result := FunctionMethod(Method, MakeParameter(LParameter, RParameter, 0, Kind));
end;

function FunctionMethod(const Method: TDoubleParameterMethod): TFunctionMethod;
begin
  FillChar(Result, SizeOf(TFunctionMethod), 0);
  with Result do
  begin
    Parameter.LParameter := True;
    Parameter.RParameter := True;
    MethodType := mtDoubleParameter;
    CMethod := Method;
  end;
end;

function FunctionMethod(const Method: TParameterArrayMethod;
  const AParameter: TFunctionParameter): TFunctionMethod;
begin
  FillChar(Result, SizeOf(TFunctionMethod), 0);
  with Result do
  begin
    Parameter := AParameter;
    MethodType := mtParameterArray;
    DMethod := Method;
  end;
end;

function FunctionMethod(const Method: TParameterArrayMethod; const Count: Integer;
  const Kind: TParameterKind = pkValue): TFunctionMethod;
begin
  Result := FunctionMethod(Method, MakeParameter(False, False, Count, Kind));
end;

function FunctionMethod(const AVariable: TFunctionVariable): TFunctionMethod;
begin
  FillChar(Result, SizeOf(TFunctionMethod), 0);
  with Result do
  begin
    MethodType := mtVariable;
    Variable := AVariable;
  end;
end;

function FunctionMethod(const Variable: PValue; const AHandle: PInteger = nil): TFunctionMethod;
begin
  Result := FunctionMethod(FunctionVariable(Variable, AHandle));
end;

function FunctionMethod(const Variable: TLiveValue; const AHandle: PInteger = nil): TFunctionMethod;
begin
  Result := FunctionMethod(FunctionVariable(Variable, AHandle));
end;

function MakeFunction(const AFunction: PFunction; const AHandle: PInteger): Boolean;
begin
  Result := (AFunction.Kind = fkMethod) and (AFunction.Method.MethodType = mtVariable);
  if Result then
  begin
    AFunction.Handle := AHandle;
    if Assigned(AFunction.Handle) then
      AFunction.Handle^ := AFunction.Method.Variable.Handle;
    AFunction.Kind := fkHandle;
  end;
end;

function MakeVariable(const AFunction: PFunction; const Variable: PValue): Boolean;
begin
  Result := AFunction.Kind = fkHandle;
  if Result then
  begin
    if Assigned(AFunction.Handle) then
      AFunction.Method.Variable.Handle := AFunction.Handle^;
    AFunction.Handle := @AFunction.Method.Variable.Handle;
    AFunction.Method.MethodType := mtVariable;
    AFunction.Method.Variable.AVariable := Variable;
    AFunction.Kind := fkMethod;
  end;
end;

function SyncHandle(const AFunction: PFunction): Boolean;
begin
  with AFunction^ do
  begin
    Result := (Kind = fkMethod) and (Method.MethodType = mtVariable);
    if Result then Handle := @Method.Variable.Handle;
  end;
end;

procedure AddNumber(var Script: TScript; const Value: TValue);
var
  Number: TScriptNumber;
begin
  Add(Script, Integer(NumberCode));
  FillChar(Number, SizeOf(TScriptNumber), 0);
  Number.Value := Value;
  Add(Script, Number);
end;

procedure AddFunction(var Script: TScript; const Handle: Integer);
var
  AFunction: TScriptFunction;
begin
  Add(Script, Integer(FunctionCode));
  FillChar(AFunction, SizeOf(TScriptFunction), 0);
  AFunction.Handle := Handle;
  Add(Script, AFunction);
end;

procedure AddScript(var Target: TScript; const Source: TScript; const Parameter: Boolean;
  const ItemIndex: Pointer);
var
  I, J: Integer;
  Header: PScriptHeader absolute Target;
begin
  if Parameter then Add(Target, Integer(ParameterCode))
  else
    if Assigned(ItemIndex) then
    begin
      {
        Увеличиваем адреса вложенных сценариев на SizeOf(Integer), так как
        будет добавлен еще один адрес
      }
      J := SizeOf(TScriptHeader);
      for I := 0 to Header.ScriptCount - 1 do
      begin
        Inc(PInteger(@Target[J])^, SizeOf(Integer));
        Inc(J, SizeOf(Integer));
      end;
      {
        Определяем адрес конца заголовка скрипта
      }
      I := SizeOf(TScriptHeader) + Header.ScriptCount * SizeOf(Integer);
      Inc(Header.ScriptCount);
      {
        Добавляем в конец заголовка скрипта (I) адрес нового вложенного сценария (J)
        Адрес нового вложенного сценария состоит из:
          1) длина скрипта (Length(Target))
          2) длина адреса нового вложенного сценария (SizeOf(Integer))
          3) длина флага вложенного сценария (SizeOf(TCode))
      }
      J := Length(Target) + SizeOf(Integer) + SizeOf(TCode);
      Insert(Target, J, I);
      {
        Увеличиваем количество вложенных сценариев
      }
      if Assigned(ItemIndex) then Inc(PInteger(ItemIndex)^, SizeOf(Integer));
      {
        Добавляем флаг вложенного сценария
      }
      Add(Target, Integer(ScriptCode));
    end
    else Add(Target, Integer(ScriptCode));
  Add(Target, Source, Length(Source));
end;

procedure AddString(var Script: TScript; const S: string);
begin
  Add(Script, Integer(StringCode));
  Add(Script, Length(S) * SizeOf(Char));
  Add(Script, S);
end;

procedure AddString(var Script: TScript; const Source: Pointer; const Count: Integer);
begin
  Add(Script, Integer(StringCode));
  Add(Script, Count);
  Add(Script, Source, Count);
end;

end.
