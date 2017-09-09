{ *********************************************************************** }
{                                                                         }
{ Parser                                                                  }
{                                                                         }
{ Copyright (c) 2006 Pisarev Yuriy (post@pisarev.net)                     }
{                                                                         }
{ *********************************************************************** }

unit Parser;

{$B-}
{$I Directives.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Types, FlexibleList, Math, NotifyManager,
  ParseCache, ParseConsts, ParseMethod, ParseTypes, TextConsts, TextBuilder,
  ValueTypes;

type
  TFunctionEvent = function(const AFunction: PFunction; const AType: PType;
    out Value: TValue; const LValue, RValue: TValue;
    const ParameterArray: TParameterArray): Boolean of object;

  TTextType = (ttExpression, ttNumber, ttFunction, ttString, ttScript);
  TTextData = record
    TextType: TTextType;
    Value: TValue;
    AFunction: PFunction;
    S: TString;
  end;

  TOperatorKind = (okFirst, okLast, okNumber, okFunction, okScript, okParameter);
  TSyntax = record
    LastKind: TOperatorKind;
    LastFunction: TFunction;
  end;

  PBracketData = ^TBracketData;
  TBracketData = record
    ScriptArray: PScriptArray;
    Parameter: Boolean;
  end;

  PParameterArrayData = ^TParameterArrayData;
  TParameterArrayData = record
    Fake: Boolean;
    ParameterArray: PParameterArray;
    Index: PInteger;
  end;

  PParameterOptimizationData = ^TParameterOptimizationData;
  TParameterOptimizationData = record
    ItemArray: TScriptArray;
    Optimal: Boolean;
  end;

  POptimizationData = ^TOptimizationData;
  TOptimizationData = record
    ItemArray: TScriptArray;
    Number: TNumber;
  end;

  TRetrieveMode = (rmNone, rmUserDeclared, rmFull);

  PDecompileData = ^TDecompileData;
  TDecompileData = record
    Text, ItemText: TTextBuilder;
    Delimiter: string;
    AFunction: PFunction;
    Parameter: Boolean;
    ParameterBracket: TBracket;
    TypeMode: TRetrieveMode;
  end;

const
  CacheSeparator = Pipe;

type
  TCacheType = (ctScript, ctParameter, ctSubscript, ctSubparameter);
  TCacheArray = array[TCacheType] of TParseCache;

  TCache = class(TComponent)
  private
    FSubscript: TParseCache;
    FScript: TParseCache;
    FSubparameter: TParseCache;
    FNameValueSeparator: Char;
    FParameter: TParseCache;
    FCacheArray: TCacheArray;
    function GetCache(CacheType: TCacheType): TParseCache;
    {$IFDEF DELPHI_7}
    procedure SetNameValueSeparator(const Value: Char);
    {$ENDIF}
  protected
    procedure SetCacheType(const Value: TListType); virtual;
    property CacheArray: TCacheArray read FCacheArray;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Clear; virtual;
    {$IFDEF DELPHI_7}
    procedure WriteNameValueSeparator; virtual;
    {$ENDIF}
    property Cache[CacheType: TCacheType]: TParseCache read GetCache;
    property CacheType: TListType write SetCacheType;
  published
    {$IFDEF DELPHI_7}
    property NameValueSeparator: Char read FNameValueSeparator
      write SetNameValueSeparator default CacheSeparator;
    {$ENDIF}
    property Script: TParseCache read FScript;
    property Parameter: TParseCache read FParameter;
    property Subscript: TParseCache read FSubscript;
    property Subparameter: TParseCache read FSubparameter;
  end;

  TParameterType = (ptParameter {TParameterKind = pkValue}, ptScript {TParameterKind = pkReference});

  TNotify = record
    NotifyType: TNotifyType;
    Component: TComponent;
  end;
  TNotifyArray = array of TNotify;

  TExecuteOption = (eoSubsequent);
  TExecuteOptions = set of TExecuteOption;

const
  DefaultExecuteOptions = [eoSubsequent];

type
  TCustomParser = class(TComponent)
  private
    FWhileHandle: Integer;
    FOnFunction: TFunctionEvent;
    FRepeatHandle: Integer;
    FUpdateCount: Integer;
    FBeforeFunction: TFunctionEvent;
    FMethod: TMethod;
    FGetHandle: Integer;
    FDeleteHandle: Integer;
    FInternalHandle: Integer;
    FCache: TCache;
    FFData: PFunctionData;
    FConstantlist: TFlexibleList;
    FStringHandle: Integer;
    FFindHandle: Integer;
    FNotifyControl: TNotifyControl;
    FSetHandle: Integer;
    FForHandle: Integer;
    FDefaultTypeHandle: Integer;
    FParameterBracket: TBracket;
    FCached: Boolean;
    FTrueValue: Integer;
    FFalseValue: Integer;
    FNotifyArray: TNotifyArray;
    FExecuteOptions: TExecuteOptions;
    FNewHandle: Integer;
    FBracket: TBracket;
    FTData: PTypeData;
    FDefaultValueType: TValueType;
    FVoidHandle: Integer;
    FWindowHandle: THandle;
    FExceptionMask: TFPUExceptionMask;
    FScriptHandle: Integer;
    function GetFunctionByHandle(Handle: Integer): PFunction;
    function GetFunctionByVariable(Variable: PValue): PFunction;
    function GetTypeByHandle(Handle: Integer): PType;
    function InternalAddFunction(const AFunction: TFunction): Boolean; overload;
    function InternalAddFunction(const AName: string; var Handle: Integer; Kind: TFunctionKind;
      Method: TFunctionMethod; Optimizable, Whole: Boolean;
      ReturnType: TValueType = vtUnknown): Boolean; overload;
    function InternalAddVariable(const AName: string; var Variable: TValue;
      Optimizable, Whole: Boolean;
      ReturnType: TValueType = vtUnknown): Boolean; virtual;
    function InternalAddConstant(const AName: string; const Value: TValue): Boolean; virtual;
  protected
    procedure Notification(Component: TComponent; Operation: TOperation); override;
    procedure WindowMethod(var Message: TMessage); virtual;
    function Notifiable(const NotifyType: TNotifyType): Boolean; virtual;
    procedure Notify; overload; virtual;
    function DoEvent(const Event: TFunctionEvent; const AFunction: PFunction;
      const AType: PType; out Value: TValue; const LValue, RValue: TValue;
      const ParameterArray: TParameterArray): Boolean; virtual;
    procedure GetParameterArray(var AIndex: Integer; out AParameterArray: TParameterArray;
      const ParameterType: TParameterType = ptParameter; const AFake: Boolean = False); virtual; abstract;
    function ExecuteFunction(var Index: Integer; const ItemHeader: PItemHeader;
      const LValue: TValue; const Fake: Boolean = False): TValue; virtual; abstract;
    function GetTextData(const Text: string): TTextData; virtual;
    procedure Check(const AType: PType; const Data: TItemData); overload; virtual;
    procedure Check(var Syntax: TSyntax; const Kind: TOperatorKind; const Text: string;
      const ScriptArray: TScriptArray; const AFunction: PFunction = nil); overload; virtual;
    function InternalCompile(const Text: string; var ScriptArray: TScriptArray;
      const Parameter: Boolean): TScript; virtual; abstract;
    procedure InternalOptimize(Index: Integer; out Script: TScript); virtual; abstract;
    function InternalDecompile(Index: Integer; const ADelimiter: string; AParameter: Boolean;
      ABracket: TBracket; ATypeMode: TRetrieveMode): string; virtual; abstract;
    property NotifyArray: TNotifyArray read FNotifyArray write FNotifyArray;
    property Method: TMethod read FMethod write FMethod;
    property TextData[const Text: string]: TTextData read GetTextData;
    property InternalHandle: Integer read FInternalHandle;
    property ExceptionMask: TFPUExceptionMask read FExceptionMask
      write FExceptionMask;
    property ConstantList: TFlexibleList read FConstantlist write FConstantList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Connect(const Event: TFunctionEvent; const Control: TNotifyControl): TFunctionEvent; virtual;
    procedure Notify(NotifyType: TNotifyType; Component: TComponent); overload; virtual;
    procedure BeginUpdate; virtual;
    procedure EndUpdate; virtual;
    function AddConstant(const AName: string; const Value: TValue): Boolean; overload; virtual;
    {$IFDEF DELPHI_2006}
    function AddConstant(const AName: string; const Value: Byte): Boolean; overload; virtual;
    function AddConstant(const AName: string; const Value: Shortint): Boolean; overload; virtual;
    function AddConstant(const AName: string; const Value: Word): Boolean; overload; virtual;
    function AddConstant(const AName: string; const Value: Smallint): Boolean; overload; virtual;
    function AddConstant(const AName: string; const Value: Longword): Boolean; overload; virtual;
    function AddConstant(const AName: string; const Value: Integer): Boolean; overload; virtual;
    {$ENDIF}
    function AddConstant(const AName: string; const Value: Int64): Boolean; overload; virtual;
    {$IFDEF DELPHI_2006}
    function AddConstant(const AName: string; const Value: Single): Boolean; overload; virtual;
    {$ENDIF}
    function AddConstant(const AName: string; const Value: Double): Boolean; overload; virtual;
    {$IFDEF DELPHI_2006}
    function AddConstant(const AName: string; const Value: Extended): Boolean; overload; virtual;
    {$ENDIF}
    function AddConstant(const AName: string; const Value: Boolean): Boolean; overload; virtual;
    function AddFunction(const AFunction: TFunction): Boolean; overload; virtual;
    function AddFunction(const AName: string; var Handle: Integer; Kind: TFunctionKind;
      Method: TFunctionMethod; Optimizable, Whole: Boolean;
      ReturnType: TValueType = vtUnknown): Boolean; overload; virtual;
    function AddVariable(const AName: string; var Variable: TValue;
      Optimizable, Whole: Boolean;
      ReturnType: TValueType = vtUnknown): Boolean; overload; virtual;
    function AddVariable(const AName: string; const Variable: TLiveValue;
      Optimizable, Whole: Boolean;
      ReturnType: TValueType = vtUnknown): Boolean; overload; virtual;
    function AddVariable(const AName: string; var Variable: TValue): Boolean; overload; virtual;
    function AddVariable(const AName: string; const Variable: TLiveValue): Boolean; overload; virtual;
    function AddVariable(const AName: string; var Variable: Byte): Boolean; overload; virtual;
    function AddVariable(const AName: string; var Variable: Shortint): Boolean; overload; virtual;
    function AddVariable(const AName: string; var Variable: Word): Boolean; overload; virtual;
    function AddVariable(const AName: string; var Variable: Smallint): Boolean; overload; virtual;
    function AddVariable(const AName: string; var Variable: Longword): Boolean; overload; virtual;
    function AddVariable(const AName: string; var Variable: Integer): Boolean; overload; virtual;
    function AddVariable(const AName: string; var Variable: Int64): Boolean; overload; virtual;
    function AddVariable(const AName: string; var Variable: Single): Boolean; overload; virtual;
    function AddVariable(const AName: string; var Variable: Double): Boolean; overload; virtual;
    function AddVariable(const AName: string; var Variable: Boolean): Boolean; overload; virtual;
    function DeleteConstant(const AName: string): Boolean; virtual;
    function DeleteFunction(const Handle: Integer): Boolean; virtual;
    function DeleteVariable(var Variable: TValue): Boolean; virtual;
    function FindConstant(const AName: string): PValue; overload; virtual;
    function FindConstant(const AName: string; out Value: PValue): Boolean; overload; virtual;
    function FindFunction(const AName: string): PFunction; overload; virtual;
    function FindFunction(const Handle: Integer; var AFunction: PFunction): Boolean; overload; virtual;
    function AddType(const AType: TType): Boolean; overload; virtual;
    function AddType(const AName: string; var Handle: Integer; ValueType: TValueType): Boolean; overload; virtual;
    function DeleteType(const Handle: Integer): Boolean; virtual;
    function FindType(const AName: string): PType; overload; virtual;
    function FindType(const Handle: Integer; var AType: PType): Boolean; overload; virtual;
    procedure StringToScript(Text: string; out Script: TScript); virtual; abstract;
    procedure Optimize(const Source: TScript; out Target: TScript); overload; virtual; abstract;
    procedure Optimize(var Script: TScript); overload; virtual; abstract;
    function ScriptToString(const AScript: TScript; const TypeMode: TRetrieveMode = rmFull): string; overload; virtual; abstract;
    function ScriptToString(const AScript: TScript; const Delimiter: string;
      const TypeMode: TRetrieveMode = rmFull): string; overload; virtual; abstract;
    function ScriptToString(const AScript: TScript; const Delimiter: string; const ABracket: TBracket;
      const TypeMode: TRetrieveMode = rmFull): string; overload; virtual; abstract;
    function Execute(const Index: Integer): PValue; virtual; abstract;
    function AsValue(const Text: string): TValue; virtual;
    function AsByte(const Text: string): Byte; virtual;
    function AsShortint(const Text: string): Shortint; virtual;
    function AsWord(const Text: string): Word; virtual;
    function AsSmallint(const Text: string): Smallint; virtual;
    function AsLongword(const Text: string): Longword; virtual;
    function AsInteger(const Text: string): Integer; virtual;
    function AsInt64(const Text: string): Int64; virtual;
    function AsSingle(const Text: string): Single; virtual;
    function AsDouble(const Text: string): Double; virtual;
    function AsExtended(const Text: string): Extended; virtual;
    function AsBoolean(const Text: string): Boolean; virtual;
    function AsPointer(const Text: string): Pointer; virtual;
    function AsString(const Text: string): string; virtual;
    function DefaultFunction(const AFunction: PFunction; out Value: TValue;
      const LValue, RValue: TValue;
      const ParameterArray: TParameterArray): Boolean; virtual;
    procedure Prepare; virtual;
    property WindowHandle: THandle read FWindowHandle write FWindowHandle;
    property NotifyControl: TNotifyControl read FNotifyControl write FNotifyControl;
    property BeforeFunction: TFunctionEvent read FBeforeFunction write FBeforeFunction;
    property UpdateCount: Integer read FUpdateCount;
    property FData: PFunctionData read FFData write FFData;
    property FunctionByHandle[Handle: Integer]: PFunction read GetFunctionByHandle;
    property FunctionByVariable[Variable: PValue]: PFunction read GetFunctionByVariable;
    property TData: PTypeData read FTData write FTData;
    property TypeByHandle[Handle: Integer]: PType read GetTypeByHandle;
    property DefaultTypeHandle: Integer read FDefaultTypeHandle write FDefaultTypeHandle;
    property Bracket: TBracket read FBracket write FBracket;
    property ParameterBracket: TBracket read FParameterBracket write FParameterBracket;
    property VoidHandle: Integer read FVoidHandle;
    property NewHandle: Integer read FNewHandle;
    property DeleteHandle: Integer read FDeleteHandle;
    property FindHandle: Integer read FFindHandle;
    property GetHandle: Integer read FGetHandle;
    property SetHandle: Integer read FSetHandle;
    property ScriptHandle: Integer read FScriptHandle;
    property ForHandle: Integer read FForHandle;
    property RepeatHandle: Integer read FRepeatHandle;
    property WhileHandle: Integer read FWhileHandle;
    property StringHandle: Integer read FStringHandle;
  published
    property FalseValue: Integer read FFalseValue write FFalseValue default 0;
    property TrueValue: Integer read FTrueValue write FTrueValue default -1;
    property DefaultValueType: TValueType read FDefaultValueType write FDefaultValueType
      default vtInteger;
    property ExecuteOptions: TExecuteOptions read FExecuteOptions write FExecuteOptions
      default DefaultExecuteOptions;
    property Cached: Boolean read FCached write FCached default True;
    property Cache: TCache read FCache;
    property OnFunction: TFunctionEvent read FOnFunction write FOnFunction;
  end;

  TExceptionType = (etZeroDivide);
  TExceptionTypes = set of TExceptionType;

const
  DefaultExceptionTypes = [etZeroDivide];

type
  TParser = class(TCustomParser)
  private
    FIsZeroHandle: Integer;
    FShortintHandle: Integer;
    FExceptionTypes: TExceptionTypes;
    FSmallintHandle: Integer;
    FEqualHandle: Integer;
    FStrToIntDefHandle: Integer;
    FEventManager: TObject;
    FGreaterThanOrEqualHandle: Integer;
    FMultiplyHandle: Integer;
    FNotEqualHandle: Integer;
    FInt64Handle: Integer;
    FAndHandle: Integer;
    FOrHandle: Integer;
    FSingleHandle: Integer;
    FLongwordHandle: Integer;
    FIfThenHandle: Integer;
    FLessThanOrEqualHandle: Integer;
    FShlHandle: Integer;
    FSetDecimalSeparatorHandle: Integer;
    FFalseHandle: Integer;
    FTrueHandle: Integer;
    FParseHandle: Integer;
    FParseManager: TObject;
    FIntegerHandle: Integer;
    FScript: TScript;
    FWordHandle: Integer;
    FByteHandle: Integer;
    FGetEpsilonHandle: Integer;
    FNotHandle: Integer;
    FSuccHandle: Integer;
    FDivideHandle: Integer;
    FGreaterThanHandle: Integer;
    FStrToFloatHandle: Integer;
    FDoubleHandle: Integer;
    FEnsureRangeHandle: Integer;
    FText: string;
    FPredHandle: Integer;
    FSameValueHandle: Integer;
    FXorHandle: Integer;
    FEpsilonHandle: Integer;
    FIfHandle: Integer;
    FLessThanHandle: Integer;
    FStrToFloatDefHandle: Integer;
    FStrToIntHandle: Integer;
    FSetEpsilonHandle: Integer;
    FShrHandle: Integer;
  protected
    function CheckMethod(var Text: string; const SubText: string; StartIndex, EndIndex: Integer;
      Data: Pointer): Boolean; virtual;
    function ParseMethod(var Text: string; const SubText: string; StartIndex, EndIndex: Integer;
      Data: Pointer): Boolean; virtual;
    function ExecuteMethod(var Index: Integer; const Header: PScriptHeader;
      const ItemHeader: PItemHeader; const Item: PScriptItem;
      const Data: Pointer): Boolean; virtual;
    function ScriptArrayMethod(var AIndex: Integer; const Header: PScriptHeader;
      const ItemHeader: PItemHeader; const Item: PScriptItem;
      const Data: Pointer): Boolean; virtual;
    function ParameterArrayMethod(var AIndex: Integer; const Header: PScriptHeader;
      const ItemHeader: PItemHeader; const Item: PScriptItem;
      const Data: Pointer): Boolean; virtual;
    function OptimizationMethod(var Index: Integer; const Header: PScriptHeader;
      const ItemHeader: PItemHeader; const Item: PScriptItem;
      const Data: Pointer): Boolean; virtual;
    function ParameterOptimizationMethod(var Index: Integer; const Header: PScriptHeader;
      const ItemHeader: PItemHeader; const Item: PScriptItem;
      const Data: Pointer): Boolean; virtual;
    function DecompileMethod(var Index: Integer; const Header: PScriptHeader;
      const ItemHeader: PItemHeader; const Item: PScriptItem;
      const Data: Pointer): Boolean; virtual;
    procedure Check(Text: string); overload; virtual;
    procedure Parse(var Text: string; var AScriptArray: TScriptArray); virtual;
    function InternalCompile(const Text: string; var ScriptArray: TScriptArray;
      const Parameter: Boolean): TScript; override;
    function ExecuteFunction(var Index: Integer; const ItemHeader: PItemHeader;
      const LValue: TValue; const Fake: Boolean = False): TValue; override;
    procedure ExecuteInternalScript(Index: Integer); virtual;
    procedure GetParameterArray(var AIndex: Integer; out AParameterArray: TParameterArray;
      const ParameterType: TParameterType = ptParameter; const AFake: Boolean = False); override;
    procedure InternalOptimize(Index: Integer; out AScript: TScript); override;
    function OptimizeParameterArray(Index: Integer; out AScript: TScript): Boolean; virtual;
    function Optimizable(var Index: Integer; Number: Boolean; out Offset: Integer;
      out Parameter: Boolean; out AScript: TScript): Boolean; virtual;
    function InternalDecompile(Index: Integer; const ADelimiter: string; AParameter: Boolean;
      AParameterBracket: TBracket; ATypeMode: TRetrieveMode): string; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Connect(const AEventManager: TObject): Boolean; reintroduce; overload; virtual;
    procedure Notify(NotifyType: TNotifyType; Component: TComponent); override;
    procedure StringToScript(Text: string; out AScript: TScript); overload; override;
    procedure StringToScript(const AText: string); reintroduce; overload;
    procedure StringToScript; reintroduce; overload;
    procedure Optimize(const Source: TScript; out Target: TScript); overload; override;
    procedure Optimize(var AScript: TScript); overload; override;
    procedure Optimize; reintroduce; overload;
    function ScriptToString(const AScript: TScript; const TypeMode: TRetrieveMode = rmFull): string; override;
    function ScriptToString(const AScript: TScript; const Delimiter: string;
      const TypeMode: TRetrieveMode = rmFull): string; override;
    function ScriptToString(const AScript: TScript; const Delimiter: string; const ABracket: TBracket;
      const TypeMode: TRetrieveMode = rmFull): string; override;
    function ScriptToString(const TypeMode: TRetrieveMode = rmFull): string; reintroduce; overload;
    function Execute(const Index: Integer): PValue; overload; override;
    function Execute(const AScript: TScript): PValue; reintroduce; overload;
    function Execute: PValue; reintroduce; overload;
    property EventManager: TObject read FEventManager write FEventManager;
    property ParseManager: TObject read FParseManager write FParseManager;
    property Script: TScript read FScript write FScript;
    property MultiplyHandle: Integer read FMultiplyHandle;
    property DivideHandle: Integer read FDivideHandle;
    property SuccHandle: Integer read FSuccHandle;
    property PredHandle: Integer read FPredHandle;
    property NotHandle: Integer read FNotHandle;
    property AndHandle: Integer read FAndHandle;
    property OrHandle: Integer read FOrHandle;
    property XorHandle: Integer read FXorHandle;
    property ShlHandle: Integer read FShlHandle;
    property ShrHandle: Integer read FShrHandle;
    property SameValueHandle: Integer read FSameValueHandle;
    property IsZeroHandle: Integer read FIsZeroHandle;
    property IfHandle: Integer read FIfHandle;
    property IfThenHandle: Integer read FIfThenHandle;
    property EnsureRangeHandle: Integer read FEnsureRangeHandle;
    property StrToIntHandle: Integer read FStrToIntHandle;
    property StrToIntDefHandle: Integer read FStrToIntDefHandle;
    property StrToFloatHandle: Integer read FStrToFloatHandle;
    property StrToFloatDefHandle: Integer read FStrToFloatDefHandle;
    property ParseHandle: Integer read FParseHandle;
    property TrueHandle: Integer read FTrueHandle;
    property FalseHandle: Integer read FFalseHandle;
    property EqualHandle: Integer read FEqualHandle;
    property NotEqualHandle: Integer read FNotEqualHandle;
    property GreaterThanHandle: Integer read FGreaterThanHandle;
    property LessThanHandle: Integer read FLessThanHandle;
    property GreaterThanOrEqualHandle: Integer read FGreaterThanOrEqualHandle;
    property LessThanOrEqualHandle: Integer read FLessThanOrEqualHandle;
    property EpsilonHandle: Integer read FEpsilonHandle;
    property GetEpsilonHandle: Integer read FGetEpsilonHandle;
    property SetEpsilonHandle: Integer read FSetEpsilonHandle;
    property SetDecimalSeparatorHandle: Integer read FSetDecimalSeparatorHandle;
    property ShortintHandle: Integer read FShortintHandle;
    property ByteHandle: Integer read FByteHandle;
    property SmallintHandle: Integer read FSmallintHandle;
    property WordHandle: Integer read FWordHandle;
    property IntegerHandle: Integer read FIntegerHandle;
    property LongwordHandle: Integer read FLongwordHandle;
    property Int64Handle: Integer read FInt64Handle;
    property SingleHandle: Integer read FSingleHandle;
    property DoubleHandle: Integer read FDoubleHandle;
  published
    property Text: string read FText write FText;
    property ExceptionTypes: TExceptionTypes read FExceptionTypes
      write FExceptionTypes default DefaultExceptionTypes;
  end;

  TMathParser = class(TParser)
  private
    FArcCscHHandle: Integer;
    FTimeHandle: Integer;
    FArcTanHandle: Integer;
    FMinuteHandle: Integer;
    FPolyHandle: Integer;
    FArcTanHHandle: Integer;
    FFracHandle: Integer;
    FLogHandle: Integer;
    FDegToRadHandle: Integer;
    FRadToDegHandle: Integer;
    FCoTanHandle: Integer;
    FMaxValueHandle: Integer;
    FArcSecHandle: Integer;
    FCoTanHHandle: Integer;
    FModHandle: Integer;
    FGetYearHandle: Integer;
    FStdDevHandle: Integer;
    FArcSecHHandle: Integer;
    FExpHandle: Integer;
    FGetSecondHandle: Integer;
    FRandomRangeHandle: Integer;
    FMaxIntValueHandle: Integer;
    FEncodeDateHandle: Integer;
    FHourHandle: Integer;
    FPopnVarianceHandle: Integer;
    FDegreeHandle: Integer;
    FRandomHandle: Integer;
    FSumHandle: Integer;
    FRandGHandle: Integer;
    FCeilHandle: Integer;
    FCycleToDegHandle: Integer;
    FDegToCycleHandle: Integer;
    FSinHandle: Integer;
    FTruncHandle: Integer;
    FSumIntHandle: Integer;
    FPowerHandle: Integer;
    FSinHHandle: Integer;
    FGetMSecondHandle: Integer;
    FArcCoTanHandle: Integer;
    FGetDayHandle: Integer;
    FIntPowerHandle: Integer;
    FArcCoTanHHandle: Integer;
    FYearHandle: Integer;
    FVarianceHandle: Integer;
    FMaxHandle: Integer;
    FMinValueHandle: Integer;
    FMeanHandle: Integer;
    FGetMonthHandle: Integer;
    FDateHandle: Integer;
    FSecondHandle: Integer;
    FSumOfSquaresHandle: Integer;
    FGradToDegHandle: Integer;
    FDegToGradHandle: Integer;
    FIntHandle: Integer;
    FMinIntValueHandle: Integer;
    FMathMethod: TMathMethod;
    FNormHandle: Integer;
    FCycleToRadHandle: Integer;
    FRadToCycleHandle: Integer;
    FCosHandle: Integer;
    FCosHHandle: Integer;
    FArcSinHandle: Integer;
    FSqrtHandle: Integer;
    FFactorialHandle: Integer;
    FGetDayOfWeekHandle: Integer;
    FRandomFromHandle: Integer;
    FArcSinHHandle: Integer;
    FMSecondHandle: Integer;
    FLog10Handle: Integer;
    FCscHandle: Integer;
    FLnHandle: Integer;
    FDayHandle: Integer;
    FGradToRadHandle: Integer;
    FRadToGradHandle: Integer;
    FCscHHandle: Integer;
    FAbsHandle: Integer;
    FRoundHandle: Integer;
    FSqrHandle: Integer;
    FLdexpHandle: Integer;
    FArcTan2Handle: Integer;
    FTanHandle: Integer;
    FRoundToHandle: Integer;
    FDivHandle: Integer;
    FEncodeTimeHandle: Integer;
    FGetMinuteHandle: Integer;
    FMonthHandle: Integer;
    FMinHandle: Integer;
    FTanHHandle: Integer;
    FLog2Handle: Integer;
    FLnXP1Handle: Integer;
    FEncodeDateTimeHandle: Integer;
    FHypotHandle: Integer;
    FArcCosHandle: Integer;
    FTotalVarianceHandle: Integer;
    FSecHandle: Integer;
    FArcCosHHandle: Integer;
    FFloorHandle: Integer;
    FSecHHandle: Integer;
    FDayOfWeekHandle: Integer;
    FCycleToGradHandle: Integer;
    FGradToCycleHandle: Integer;
    FGetHourHandle: Integer;
    FPopnStdDevHandle: Integer;
    FArcCscHandle: Integer;
    FLgHandle: Integer;
  protected
    property MathMethod: TMathMethod read FMathMethod write FMathMethod;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property DivHandle: Integer read FDivHandle;
    property ModHandle: Integer read FModHandle;
    property DegreeHandle: Integer read FDegreeHandle;
    property FactorialHandle: Integer read FFactorialHandle;
    property SqrHandle: Integer read FSqrHandle;
    property SqrtHandle: Integer read FSqrtHandle;
    property IntHandle: Integer read FIntHandle;
    property RoundHandle: Integer read FRoundHandle;
    property RoundToHandle: Integer read FRoundToHandle;
    property TruncHandle: Integer read FTruncHandle;
    property AbsHandle: Integer read FAbsHandle;
    property FracHandle: Integer read FFracHandle;
    property LnHandle: Integer read FLnHandle;
    property LgHandle: Integer read FLgHandle;
    property LogHandle: Integer read FLogHandle;
    property ExpHandle: Integer read FExpHandle;
    property RandomHandle: Integer read FRandomHandle;
    property SinHandle: Integer read FSinHandle;
    property ArcSinHandle: Integer read FArcSinHandle;
    property SinHHandle: Integer read FSinHHandle;
    property ArcSinHHandle: Integer read FArcSinHHandle;
    property CosHandle: Integer read FCosHandle;
    property ArcCosHandle: Integer read FArcCosHandle;
    property CosHHandle: Integer read FCosHHandle;
    property ArcCosHHandle: Integer read FArcCosHHandle;
    property TanHandle: Integer read FTanHandle;
    property ArcTanHandle: Integer read FArcTanHandle;
    property TanHHandle: Integer read FTanHHandle;
    property ArcTanHHandle: Integer read FArcTanHHandle;
    property CoTanHandle: Integer read FCoTanHandle;
    property ArcCoTanHandle: Integer read FArcCoTanHandle;
    property CoTanHHandle: Integer read FCoTanHHandle;
    property ArcCoTanHHandle: Integer read FArcCoTanHHandle;
    property SecHandle: Integer read FSecHandle;
    property ArcSecHandle: Integer read FArcSecHandle;
    property SecHHandle: Integer read FSecHHandle;
    property ArcSecHHandle: Integer read FArcSecHHandle;
    property CscHandle: Integer read FCscHandle;
    property ArcCscHandle: Integer read FArcCscHandle;
    property CscHHandle: Integer read FCscHHandle;
    property ArcCscHHandle: Integer read FArcCscHHandle;
    property ArcTan2Handle: Integer read FArcTan2Handle;
    property HypotHandle: Integer read FHypotHandle;
    property RadToDegHandle: Integer read FRadToDegHandle;
    property RadToGradHandle: Integer read FRadToGradHandle;
    property RadToCycleHandle: Integer read FRadToCycleHandle;
    property DegToRadHandle: Integer read FDegToRadHandle;
    property DegToGradHandle: Integer read FDegToGradHandle;
    property DegToCycleHandle: Integer read FDegToCycleHandle;
    property GradToRadHandle: Integer read FGradToRadHandle;
    property GradToDegHandle: Integer read FGradToDegHandle;
    property GradToCycleHandle: Integer read FGradToCycleHandle;
    property CycleToRadHandle: Integer read FCycleToRadHandle;
    property CycleToDegHandle: Integer read FCycleToDegHandle;
    property CycleToGradHandle: Integer read FCycleToGradHandle;
    property LnXP1Handle: Integer read FLnXP1Handle;
    property Log10Handle: Integer read FLog10Handle;
    property Log2Handle: Integer read FLog2Handle;
    property IntPowerHandle: Integer read FIntPowerHandle;
    property PowerHandle: Integer read FPowerHandle;
    property LdexpHandle: Integer read FLdexpHandle;
    property CeilHandle: Integer read FCeilHandle;
    property FloorHandle: Integer read FFloorHandle;
    property PolyHandle: Integer read FPolyHandle;
    property MeanHandle: Integer read FMeanHandle;
    property SumHandle: Integer read FSumHandle;
    property SumIntHandle: Integer read FSumIntHandle;
    property SumOfSquaresHandle: Integer read FSumOfSquaresHandle;
    property MinValueHandle: Integer read FMinValueHandle;
    property MinIntValueHandle: Integer read FMinIntValueHandle;
    property MinHandle: Integer read FMinHandle;
    property MaxValueHandle: Integer read FMaxValueHandle;
    property MaxIntValueHandle: Integer read FMaxIntValueHandle;
    property MaxHandle: Integer read FMaxHandle;
    property StdDevHandle: Integer read FStdDevHandle;
    property PopnStdDevHandle: Integer read FPopnStdDevHandle;
    property VarianceHandle: Integer read FVarianceHandle;
    property PopnVarianceHandle: Integer read FPopnVarianceHandle;
    property TotalVarianceHandle: Integer read FTotalVarianceHandle;
    property NormHandle: Integer read FNormHandle;
    property RandGHandle: Integer read FRandGHandle;
    property RandomRangeHandle: Integer read FRandomRangeHandle;
    property RandomFromHandle: Integer read FRandomFromHandle;
    property YearHandle: Integer read FYearHandle;
    property MonthHandle: Integer read FMonthHandle;
    property DayHandle: Integer read FDayHandle;
    property DayOfWeekHandle: Integer read FDayOfWeekHandle;
    property HourHandle: Integer read FHourHandle;
    property MinuteHandle: Integer read FMinuteHandle;
    property SecondHandle: Integer read FSecondHandle;
    property MSecondHandle: Integer read FMSecondHandle;
    property TimeHandle: Integer read FTimeHandle;
    property DateHandle: Integer read FDateHandle;
    property GetYearHandle: Integer read FGetYearHandle;
    property GetMonthHandle: Integer read FGetMonthHandle;
    property GetDayHandle: Integer read FGetDayHandle;
    property GetDayOfWeekHandle: Integer read FGetDayOfWeekHandle;
    property GetHourHandle: Integer read FGetHourHandle;
    property GetMinuteHandle: Integer read FGetMinuteHandle;
    property GetSecondHandle: Integer read FGetSecondHandle;
    property GetMSecondHandle: Integer read FGetMSecondHandle;
    property EncodeTimeHandle: Integer read FEncodeTimeHandle;
    property EncodeDateHandle: Integer read FEncodeDateHandle;
    property EncodeDateTimeHandle: Integer read FEncodeDateTimeHandle;
  end;

const
  InternalScriptCacheName = 'ScriptCache';
  InternalSubscriptCacheName = 'SubscriptCache';
  InternalParameterCacheName = 'ParameterCache';
  InternalSubparameterCacheName = 'SubparameterCache';
  InternalCacheName = 'Cache';
  InternalEventManagerName = 'EventManager';
  InternalParseManagerName = 'ParseManager';

function Put(var NotifyArray: TNotifyArray; const Notify: TNotify): Integer;
function MakeNotify(const ANotifyType: TNotifyType; const AComponent: TComponent): TNotify;

function ItemData(const ANumber: TValue): TItemData; overload;
function ItemData(const BFunction: PFunction): TItemData; overload;
function ItemData(const AText: TString): TItemData; overload;
function ItemData(const AScript: PScript; const Parameter: Boolean): TItemData; overload;

procedure Register;

implementation

uses
  Dialogs, EventManager, License, MemoryUtils, NumberConsts, NumberUtils,
  ParseCommon, ParseErrors, ParseManager, ParseMessages, ParseUtils, ParseValidator,
  {$IFDEF DELPHI_XE3}System.UITypes, {$ENDIF}TextUtils, ThreadUtils, ValueConsts,
  ValueUtils, Variants;

procedure Register;
begin
  RegisterComponents('Samples', [TParser, TMathParser]);
end;

var
  WasteCount: Integer = 0;

function Put(var NotifyArray: TNotifyArray; const Notify: TNotify): Integer;
var
  I: Integer;
begin
  for I := Low(NotifyArray) to High(NotifyArray) do
    if NotifyArray[I].NotifyType = Notify.NotifyType then
    begin
      Result := I;
      NotifyArray[Result] := Notify;
      Exit;
    end;
  Result := Length(NotifyArray);
  SetLength(NotifyArray, Result + 1);
  NotifyArray[Result] := Notify;
end;

function MakeNotify(const ANotifyType: TNotifyType; const AComponent: TComponent): TNotify;
begin
  with Result do
  begin
    NotifyType := ANotifyType;
    Component := AComponent;
  end;
end;

function ItemData(const ANumber: TValue): TItemData;
begin
  with Result do
  begin
    Code := icNumber;
    Number := ANumber;
  end;
end;

function ItemData(const BFunction: PFunction): TItemData;
begin
  with Result do
  begin
    Code := icFunction;
    AFunction := BFunction;
  end;
end;

function ItemData(const AText: TString): TItemData;
begin
  with Result do
  begin
    Code := icString;
    StrLCopy(Text, AText, SizeOf(TString) - 1);
  end;
end;

function ItemData(const AScript: PScript; const Parameter: Boolean): TItemData;
begin
  with Result do
  begin
    Code := TItemCode(Ord(icScript) + Ord(Parameter));
    Script := AScript;
  end;
end;

{ TCache }

procedure TCache.Clear;
var
  I: TCacheType;
begin
  for I := Low(TCacheType) to High(TCacheType) do
    if Available(FCacheArray[I]) then FCacheArray[I].Clear;
end;

constructor TCache.Create(AOwner: TComponent);
begin
  inherited;
  FScript := TParseCache.Create(AOwner);
  with FScript do
  begin
    Name := InternalScriptCacheName;
    ScriptType := stScript;
    SetSubComponent(True);
  end;
  FSubscript := TParseCache.Create(AOwner);
  with FSubscript do
  begin
    Name := InternalSubscriptCacheName;
    ScriptType := stSubscript;
    HardCache.Enabled := False;
    SetSubComponent(True);
  end;
  FParameter := TParseCache.Create(AOwner);
  with FParameter do
  begin
    Name := InternalParameterCacheName;
    ScriptType := stScript;
    SetSubComponent(True);
  end;
  FSubparameter := TParseCache.Create(AOwner);
  with FSubparameter do
  begin
    Name := InternalSubparameterCacheName;
    ScriptType := stSubscript;
    HardCache.Enabled := False;
    SetSubComponent(True);
  end;
  FCacheArray[ctScript] := FScript;
  FCacheArray[ctSubscript] := FSubscript;
  FCacheArray[ctParameter] := FParameter;
  FCacheArray[ctSubparameter] := FSubparameter;
  FNameValueSeparator := CacheSeparator;
  {$IFDEF DELPHI_7}
  WriteNameValueSeparator;
  {$ENDIF}
end;

function TCache.GetCache(CacheType: TCacheType): TParseCache;
begin
  Result := FCacheArray[CacheType];
end;

procedure TCache.SetCacheType(const Value: TListType);
var
  I: TCacheType;
begin
  for I := Low(TCacheType) to High(TCacheType) do
  begin
    FCacheArray[I].LiteCache.CacheType := Value;
    FCacheArray[I].HardCache.CacheType := Value;
  end;
end;

{$IFDEF DELPHI_7}
procedure TCache.SetNameValueSeparator(const Value: Char);
begin
  if FNameValueSeparator <> Value then
  begin
    FNameValueSeparator := Value;
    WriteNameValueSeparator;
  end;
end;

procedure TCache.WriteNameValueSeparator;
var
  I: TCacheType;
begin
  for I := Low(TCacheType) to High(TCacheType) do
  begin
    FCacheArray[I].LiteCache.NameValueSeparator := FNameValueSeparator;
    FCacheArray[I].HardCache.NameValueSeparator := FNameValueSeparator;
  end;
end;
{$ENDIF}

{ TCustomParser }

function TCustomParser.AddConstant(const AName: string; const Value: TValue): Boolean;
var
  Item: PValue;
begin
  Result := not Assigned(FindFunction(AName));
  if Result then
  begin
    New(Item);
    try
      Item^ := Value;
      Result := AddVariable(AName, Item^, True, True);
      if Result then FConstantList.List.AddObject(AName, Pointer(Item))
      else Dispose(Item);
    except
      Dispose(Item);
    end;
  end;
end;

{$IFDEF DELPHI_2006}

function TCustomParser.AddConstant(const AName: string; const Value: Byte): Boolean;
begin
  Result := AddConstant(AName, MakeValue(Value));
end;

function TCustomParser.AddConstant(const AName: string; const Value: Shortint): Boolean;
begin
  Result := AddConstant(AName, MakeValue(Value));
end;

function TCustomParser.AddConstant(const AName: string; const Value: Word): Boolean;
begin
  Result := AddConstant(AName, MakeValue(Value));
end;

function TCustomParser.AddConstant(const AName: string; const Value: Smallint): Boolean;
begin
  Result := AddConstant(AName, MakeValue(Value));
end;

function TCustomParser.AddConstant(const AName: string; const Value: Longword): Boolean;
begin
  Result := AddConstant(AName, MakeValue(Value));
end;

function TCustomParser.AddConstant(const AName: string; const Value: Integer): Boolean;
begin
  Result := AddConstant(AName, MakeValue(Value));
end;

{$ENDIF}

function TCustomParser.AddConstant(const AName: string; const Value: Int64): Boolean;
begin
  Result := AddConstant(AName, MakeValue(Value));
end;

{$IFDEF DELPHI_2006}

function TCustomParser.AddConstant(const AName: string; const Value: Single): Boolean;
begin
  Result := AddConstant(AName, MakeValue(Value));
end;

{$ENDIF}

function TCustomParser.AddConstant(const AName: string; const Value: Double): Boolean;
begin
  Result := AddConstant(AName, MakeValue(Value));
end;

{$IFDEF DELPHI_2006}

function TCustomParser.AddConstant(const AName: string; const Value: Extended): Boolean;
begin
  Result := AddConstant(AName, MakeValue(Value));
end;

{$ENDIF}

function TCustomParser.AddConstant(const AName: string; const Value: Boolean): Boolean;
begin
  Result := AddConstant(AName, MakeValue(Byte(Value)));
end;

function TCustomParser.AddFunction(const AFunction: TFunction): Boolean;
var
  LicenseCount: Integer;
begin
  LicenseCount := GetLicenseCount;
  Result := (LicenseCount < 0) or (WasteCount < LicenseCount);
  if Result then
  begin
    Result := InternalAddFunction(AFunction);
    if Result and (LicenseCount > 0) then Inc(WasteCount);
  end
  else MessageDlg(LicenseError, mtError, [mbOk], 0);
end;

function TCustomParser.AddFunction(const AName: string; var Handle: Integer;
  Kind: TFunctionKind; Method: TFunctionMethod; Optimizable, Whole: Boolean;
  ReturnType: TValueType): Boolean;
begin
  Result := AddFunction(MakeFunction(AName, Handle, ReturnType, Kind, Method,
    Optimizable, Whole));
end;

function TCustomParser.AddType(const AType: TType): Boolean;
begin
  Notify(ntBeforeTypeAdd, Self);
  with AType do
  begin
    Result := (Name <> '') and not Assigned(FindType(Name));
    if Result then
    begin
      Validator.Check(Name, rtName);
      Handle^ := Add(FTData^, AType);
    end
    else Handle^ := -1;
  end;
  Notify(ntAfterTypeAdd, Self);
end;

function TCustomParser.AddType(const AName: string; var Handle: Integer;
  ValueType: TValueType): Boolean;
begin
  Result := AddType(MakeType(AName, Handle, ValueType));
end;

function TCustomParser.AddVariable(const AName: string; var Variable: TValue;
  Optimizable, Whole: Boolean; ReturnType: TValueType): Boolean;
var
  AFunction: TFunction;
begin
  AFunction := MakeFunction(AName, AFunction.Method.Variable.Handle, ReturnType, fkMethod,
    FunctionMethod(@Variable), Optimizable, Whole);
  Result := AddFunction(AFunction);
end;

function TCustomParser.AddVariable(const AName: string; const Variable: TLiveValue;
  Optimizable, Whole: Boolean; ReturnType: TValueType): Boolean;
var
  AFunction: TFunction;
begin
  AFunction := MakeFunction(AName, AFunction.Method.Variable.Handle, ReturnType, fkMethod,
    FunctionMethod(Variable), Optimizable, Whole);
  Result := AddFunction(AFunction);
end;

function TCustomParser.AddVariable(const AName: string; var Variable: TValue): Boolean;
begin
  Result := AddVariable(AName, Variable, False, True, Variable.ValueType);
end;

function TCustomParser.AddVariable(const AName: string; const Variable: TLiveValue): Boolean;
begin
  Result := AddVariable(AName, Variable, False, True, Variable.ValueType);
end;

function TCustomParser.AddVariable(const AName: string; var Variable: Byte): Boolean;
begin
  Result := AddVariable(AName, MakeLiveValue(Variable));
end;

function TCustomParser.AddVariable(const AName: string; var Variable: Shortint): Boolean;
begin
  Result := AddVariable(AName, MakeLiveValue(Variable));
end;

function TCustomParser.AddVariable(const AName: string; var Variable: Word): Boolean;
begin
  Result := AddVariable(AName, MakeLiveValue(Variable));
end;

function TCustomParser.AddVariable(const AName: string; var Variable: Smallint): Boolean;
begin
  Result := AddVariable(AName, MakeLiveValue(Variable));
end;

function TCustomParser.AddVariable(const AName: string; var Variable: Longword): Boolean;
begin
  Result := AddVariable(AName, MakeLiveValue(Variable));
end;

function TCustomParser.AddVariable(const AName: string; var Variable: Integer): Boolean;
begin
  Result := AddVariable(AName, MakeLiveValue(Variable));
end;

function TCustomParser.AddVariable(const AName: string; var Variable: Int64): Boolean;
begin
  Result := AddVariable(AName, MakeLiveValue(Variable));
end;

function TCustomParser.AddVariable(const AName: string; var Variable: Single): Boolean;
begin
  Result := AddVariable(AName, MakeLiveValue(Variable));
end;

function TCustomParser.AddVariable(const AName: string; var Variable: Double): Boolean;
begin
  Result := AddVariable(AName, MakeLiveValue(Variable));
end;

function TCustomParser.AddVariable(const AName: string; var Variable: Boolean): Boolean;
begin
  Result := AddVariable(AName, MakeLiveValue(PByte(@Variable)^));
end;

function TCustomParser.AsBoolean(const Text: string): Boolean;
begin
  Result := Boolean(AsByte(Text));
end;

function TCustomParser.AsByte(const Text: string): Byte;
begin
  Result := Convert(AsValue(Text), vtByte).Unsigned8;
end;

function TCustomParser.AsDouble(const Text: string): Double;
begin
  Result := Convert(AsValue(Text), vtDouble).Float64;
end;

function TCustomParser.AsExtended(const Text: string): Extended;
begin
  Result := AsDouble(Text);
end;

function TCustomParser.AsInt64(const Text: string): Int64;
begin
  Result := Convert(AsValue(Text), vtInt64).Signed64;
end;

function TCustomParser.AsInteger(const Text: string): Integer;
begin
  Result := Convert(AsValue(Text), vtInteger).Signed32;
end;

function TCustomParser.AsLongword(const Text: string): Longword;
begin
  Result := Convert(AsValue(Text), vtLongword).Unsigned32;
end;

function TCustomParser.AsPointer(const Text: string): Pointer;
begin
  Result := Pointer(AsInteger(Text));
end;

function TCustomParser.AsShortint(const Text: string): Shortint;
begin
  Result := Convert(AsValue(Text), vtShortint).Signed8;
end;

function TCustomParser.AsSingle(const Text: string): Single;
begin
  Result := Convert(AsValue(Text), vtSingle).Float32;
end;

function TCustomParser.AsSmallint(const Text: string): Smallint;
begin
  Result := Convert(AsValue(Text), vtSmallint).Signed16;
end;

function TCustomParser.AsString(const Text: string): string;
begin
  Result := ValueToText(AsValue(Text));
end;

function TCustomParser.AsValue(const Text: string): TValue;
var
  Script: TScript;
begin
  StringToScript(Text, Script);
  try
    Result := Execute(Integer(Script))^;
  finally
    Script := nil;
  end;
end;

function TCustomParser.AsWord(const Text: string): Word;
begin
  Result := Convert(AsValue(Text), vtWord).Unsigned16;
end;

procedure TCustomParser.BeginUpdate;
begin
  InterlockedIncrement(FUpdateCount);
end;

{$WARNINGS OFF}
procedure TCustomParser.Check(const AType: PType; const Data: TItemData);
var
  Script: TScript;
begin
  if Assigned(AType) and (AType.Handle^ = FStringHandle) then
    case Data.Code of
      icNumber: raise Error(StringTypeError, [ValueToText(Data.Number)]);
      icFunction: raise Error(StringTypeError, [Data.AFunction.Name]);
      icScript:
        raise Error(StringTypeError, [ScriptToString(Data.Script^, rmUserDeclared)]);
      icParameter:
        begin
          Script := ParameterToScript(Data.Script^);
          try
            raise Error(StringTypeError, [ScriptToString(Script, rmUserDeclared)]);
          finally
            Script := nil;
          end;
        end;
    end;
end;
{$WARNINGS ON}

procedure TCustomParser.Check(var Syntax: TSyntax; const Kind: TOperatorKind; const Text: string;
  const ScriptArray: TScriptArray; const AFunction: PFunction);
var
  Parameter, LastParameter: PFunctionParameter;
begin
  Parameter := @AFunction.Method.Parameter;
  LastParameter := @Syntax.LastFunction.Method.Parameter;
  case Kind of
    okLast:
      case Syntax.LastKind of
        okFunction:
          if LastParameter.Count > 0 then
            raise Error(FormatInternalText(Self, Text, ScriptArray), AParameterExpectError,
              [Syntax.LastFunction.Name])
          else
            if LastParameter.RParameter then
              raise Error(FormatInternalText(Self, Text, ScriptArray), RTextExpectError,
                [Syntax.LastFunction.Name]);
      end;
    okNumber, okScript:
      case Syntax.LastKind of
        okNumber, okScript, okParameter:
          raise Error(FunctionExpectError, [FormatInternalText(Self, Text, ScriptArray)]);
        okFunction:
          if (LastParameter.Count > 0) or not LastParameter.RParameter then
            raise Error(FormatInternalText(Self, Text, ScriptArray), RTextExcessError,
              [Syntax.LastFunction.Name]);
      end;
    okFunction:
      begin
        case Syntax.LastKind of
          okFirst:
            if LastParameter.LParameter then
              raise Error(LTextExpectError, [FormatInternalText(Self, Text, ScriptArray)]);
          okNumber, okScript, okParameter:
            if (Parameter.Count > 0) or not Parameter.LParameter then
              raise Error(FormatInternalText(Self, Text, ScriptArray), LTextExcessError,
                [AFunction.Name]);
          okFunction:
            if LastParameter.RParameter and Parameter.LParameter then
              raise Error(FormatInternalText(Self, Text, ScriptArray), AMutualExcessError,
                [Syntax.LastFunction.Name, AFunction.Name])
            else
              if not LastParameter.RParameter and not Parameter.LParameter then
                raise Error(FormatInternalText(Self, Text, ScriptArray), BMutualExcessError,
                  [Syntax.LastFunction.Name, AFunction.Name]);
        end;
        Syntax.LastFunction := AFunction^;
      end;
    okParameter:
      case Syntax.LastKind of
        okFirst, okNumber, okScript, okParameter:
          raise Error(FunctionExpectError, [FormatInternalText(Self, Text, ScriptArray)]);
        okFunction:
          if LastParameter.Count = 0 then
            raise Error(FormatInternalText(Self, Text, ScriptArray), AParameterExcessError,
              [Syntax.LastFunction.Name]);
      end;
  end;
  Syntax.LastKind := Kind;
end;

function TCustomParser.Connect(const Event: TFunctionEvent;
  const Control: TNotifyControl): TFunctionEvent;
begin
  FNotifyControl := Control;
  Result := FBeforeFunction;
  FBeforeFunction := Event;
end;

constructor TCustomParser.Create(AOwner: TComponent);
begin
  inherited;
  FMethod := TMethod.Create(Self);
  FWindowHandle := AllocateHWnd(WindowMethod);
  New(FFData);
  ZeroMemory(FFData, SizeOf(TFunctionData));
  New(FTData);
  ZeroMemory(FTData, SizeOf(TTypeData));
  FExceptionMask := GetExceptionMask;
  SetExceptionMask([exInvalidOp, exDenormalized, exZeroDivide, exOverflow, exUnderflow, exPrecision]);
  FCache := TCache.Create(Self);
  with FCache do
  begin
    Name := InternalCacheName;
    SetSubComponent(True);
  end;
  BeginUpdate;
  try
    InternalAddFunction(InternalFunctionName, FInternalHandle, fkHandle, FunctionMethod(False, False, 0),
      False, False);
    InternalAddFunction(VoidFunctionName, FVoidHandle, fkMethod, FunctionMethod(FMethod.VoidMethod),
      True, True, vtByte);
    InternalAddFunction(NewFunctionName, FNewHandle, fkMethod,
      FunctionMethod(FMethod.NewMethod, NewMinParameterCount, pkReference),
      False, False);
    InternalAddFunction(DeleteFunctionName, FDeleteHandle, fkMethod,
      FunctionMethod(FMethod.DeleteMethod, DeleteParameterCount, pkReference),
      False, False);
    InternalAddFunction(FindFunctionName, FFindHandle, fkMethod,
      FunctionMethod(FMethod.FindMethod, FindParameterCount, pkReference),
      False, False);
    InternalAddFunction(GetFunctionName, FGetHandle, fkMethod,
      FunctionMethod(FMethod.GetMethod, GetParameterCount, pkReference),
      False, False);
    InternalAddFunction(SetFunctionName, FSetHandle, fkMethod,
      FunctionMethod(FMethod.SetMethod, SetParameterCount, pkReference),
      False, False);
    InternalAddFunction(ScriptFunctionName, FScriptHandle, fkMethod,
      FunctionMethod(FMethod.ScriptMethod, ScriptMinParameterCount, pkReference),
      False, False);
    InternalAddFunction(ForFunctionName, FForHandle, fkMethod,
      FunctionMethod(FMethod.ForMethod, ForParameterCount, pkReference),
      False, False);
    InternalAddFunction(RepeatFunctionName, FRepeatHandle, fkMethod,
      FunctionMethod(FMethod.RepeatMethod, RepeatParameterCount, pkReference),
      False, False);
    InternalAddFunction(WhileFunctionName, FWhileHandle, fkMethod,
      FunctionMethod(FMethod.WhileMethod, WhileParameterCount, pkReference),
      False, False);
    AddType(StringTypeName, FStringHandle, vtUnknown);
  finally
    EndUpdate;
  end;
  FBracket := BracketArray[btParenthesis];
  FParameterBracket := BracketArray[btBracket];
  FFalseValue := 0;
  FTrueValue := -1;
  FDefaultValueType := vtInteger;
  FExecuteOptions := DefaultExecuteOptions;
  FCached := True;
end;

function TCustomParser.DefaultFunction(const AFunction: PFunction; out Value: TValue;
  const LValue, RValue: TValue; const ParameterArray: TParameterArray): Boolean;
begin
  Result := False;
end;

function TCustomParser.DeleteFunction(const Handle: Integer): Boolean;
var
  I: Integer;
begin
  try
    Notify(ntBeforeFunctionDelete, Self);
    with FFData^ do
    begin
      I := Length(FArray);
      Result := Delete(FArray, Handle * SizeOf(TFunction), SizeOf(TFunction),
        I * SizeOf(TFunction));
      if Result then
      begin
        SetLength(FArray, I - 1);
        Prepared := False;
      end;
    end;
    Notify(ntAfterFunctionDelete, Self);
    Notify(ntCompile, Self);
  finally
    if WasteCount > 0 then Dec(WasteCount);
  end;
end;

function TCustomParser.DeleteConstant(const AName: string): Boolean;
var
  I: Integer;
  Value: PValue;
begin
  Result := Find(FConstantList.List, AName, False, I);
  if Result then
  begin
    Value := PValue(FConstantList.List.Objects[I]);
    DeleteVariable(Value^);
    FConstantList.List.Delete(I);
    Dispose(Value);
  end;
end;

function TCustomParser.DeleteType(const Handle: Integer): Boolean;
var
  I: Integer;
begin
  Notify(ntBeforeTypeDelete, Self);
  with FTData^ do
  begin
    I := Length(TArray);
    Result := Delete(TArray, Handle * SizeOf(TType), SizeOf(TType), I * SizeOf(TType));
    if Result then
    begin
      SetLength(TArray, I - 1);
      Prepared := False;
    end;
  end;
  Notify(ntAfterTypeDelete, Self);
  Notify(ntCompile, Self);
end;

function TCustomParser.DeleteVariable(var Variable: TValue): Boolean;
var
  I: Integer;
  AVariable: PFunctionVariable;
begin
  for I := Low(FFData.FArray) to High(FFData.FArray) do
  begin
    AVariable := @FFData.FArray[I].Method.Variable;
    if (AVariable.VariableType = vtValue) and (AVariable.AVariable = @Variable) then
    begin
      Result := DeleteFunction(I);
      Exit;
    end;
  end;
  Result := False;
end;

destructor TCustomParser.Destroy;
begin
  Notify(ntDisconnect, Self);
  Cache.Clear;
  with FFData^ do
  begin
    FArray := nil;
    FOrder := nil;
    NameList.Free;
  end;
  with FTData^ do
  begin
    TArray := nil;
    TOrder := nil;
    NameList.Free;
  end;
  FNotifyArray := nil;
  SetExceptionMask(FExceptionMask);
  DeallocateHWnd(FWindowHandle);
  Dispose(FFData);
  Dispose(FTData);
  inherited;
end;

function TCustomParser.DoEvent(const Event: TFunctionEvent; const AFunction: PFunction;
  const AType: PType; out Value: TValue; const LValue, RValue: TValue;
  const ParameterArray: TParameterArray): Boolean;
begin
  Result := Assigned(Event) and
    Event(AFunction, AType, Value, LValue, RValue, ParameterArray);
end;

procedure TCustomParser.EndUpdate;
begin
  InterlockedDecrement(FUpdateCount);
end;

function TCustomParser.FindConstant(const AName: string): PValue;
var
  I: Integer;
begin
  I := IndexOf(FConstantList.List, AName, False);
  if I < 0 then Result := nil
  else Result := Pointer(FConstantList.List.Objects[I]);
end;

function TCustomParser.FindConstant(const AName: string; out Value: PValue): Boolean;
begin
  Value := FindConstant(AName);
  Result := Assigned(Value);
end;

function TCustomParser.FindFunction(const AName: string): PFunction;
var
  I: Integer;
begin
  if FFData.Prepared then
    if Assigned(FFData.NameList) then
    begin
      I := FFData.NameList.List.IndexOf(AName);
      if I < 0 then Result := nil
      else FindFunction(Integer(FFData.NameList.List.Objects[I]), Result);
    end
    else Result := nil
  else begin
    for I := Low(FFData.FArray) to High(FFData.FArray) do
      if TextUtils.SameText(FFData.FArray[I].Name, AName) then
      begin
        Result := @FFData.FArray[I];
        Exit;
      end;
    Result := nil;
  end;
end;

function TCustomParser.FindFunction(const Handle: Integer; var AFunction: PFunction): Boolean;
begin
  with FFData^ do
  begin
    Result := (Handle >= Low(FArray)) and (Handle <= High(FArray));
    if Result then AFunction := @FArray[Handle];
  end;
end;

function TCustomParser.FindType(const AName: string): PType;
var
  I: Integer;
begin
  if FTData.Prepared then
    if Assigned(FTData.NameList) then
    begin
      I := FTData.NameList.List.IndexOf(AName);
      if I < 0 then Result := nil
      else FindType(Integer(FTData.NameList.List.Objects[I]), Result);
    end
    else Result := nil
  else begin
    for I := Low(FTData.TArray) to High(FTData.TArray) do
      if TextUtils.SameText(FTData.TArray[I].Name, AName) then
      begin
        Result := @FTData.TArray[I];
        Exit;
      end;
    Result := nil;
  end;
end;

function TCustomParser.FindType(const Handle: Integer; var AType: PType): Boolean;
begin
  with FTData^ do
  begin
    Result := (Handle >= Low(TArray)) and (Handle <= High(TArray));
    if Result then AType := @TArray[Handle];
  end;
end;

function TCustomParser.GetFunctionByHandle(Handle: Integer): PFunction;
begin
  if not FindFunction(Handle, Result) then Result := nil;
end;

function TCustomParser.GetFunctionByVariable(Variable: PValue): PFunction;
var
  I: Integer;
begin
  for I := Low(FFData.FArray) to High(FFData.FArray) do
  begin
    Result := @FFData.FArray[I];
    if (Result.Kind = fkMethod) and (Result.Method.MethodType = mtVariable) and
      (Result.Method.Variable.AVariable = Variable) then Exit;
  end;
  Result := nil;
end;

function TCustomParser.GetTextData(const Text: string): TTextData;
begin
  FillChar(Result, SizeOf(TTextData), 0);
  if Embraced(Text, FBracket) then Result.TextType := ttScript
  else if Dequoted(Text) then
  begin
    Result.TextType := ttString;
    StrLCopy(Result.S, PChar(Dequote(Text)), SizeOf(TString) - 1);
  end
  else begin
    Result.Value := TextToValue(Text);
    if Result.Value.ValueType = vtUnknown then
    begin
      Result.AFunction := FindFunction(Text);
      if Assigned(Result.AFunction) then Result.TextType := ttFunction
      else Result.TextType := ttExpression;
    end
    else Result.TextType := ttNumber;
  end;
end;

function TCustomParser.GetTypeByHandle(Handle: Integer): PType;
begin
  if not FindType(Handle, Result) then Result := nil;
end;

function TCustomParser.Notifiable(const NotifyType: TNotifyType): Boolean;
var
  Attribute: PNotifyAttribute;
begin
  Attribute := @NotifyAttribute[NotifyType];
  Result := Attribute.Permanent and (Attribute.Reliable or Available(Self)) or
    (FUpdateCount = 0) and (Attribute.Reliable or Available(Self));
end;

procedure TCustomParser.Notification(Component: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (Component = FNotifyControl) then
    FNotifyControl := nil;
end;

{$WARNINGS OFF}
procedure TCustomParser.Notify;
var
  ANotifyArray: TNotifyArray;
  I: Integer;
begin
  if Assigned(FNotifyArray) then
  begin
    Integer(ANotifyArray) := InterlockedExchange(Integer(FNotifyArray), Integer(ANotifyArray));
    try
      for I := Low(ANotifyArray) to High(ANotifyArray) do
        Notify(ANotifyArray[I].NotifyType, ANotifyArray[I].Component);
    finally
      ANotifyArray := nil;
    end;
  end;
end;
{$WARNINGS ON}

procedure TCustomParser.Notify(NotifyType: TNotifyType; Component: TComponent);
begin
  if Notifiable(NotifyType) and Available(FNotifyControl) then
    FNotifyControl.Notify(NotifyType, Component);
end;

procedure TCustomParser.Prepare;
begin
  PrepareFData(Self);
  PrepareTData(Self);
  Notify;
end;

procedure TCustomParser.WindowMethod(var Message: TMessage);
var
  Data: PVariableData;
begin
  with Message do
    case Msg of
      WM_NOTIFY:
        Put(FNotifyArray, MakeNotify(TNotifyType(WParam), TComponent(LParam)));
      WM_ADDFUNCTION:
        Message.Result := Integer(InternalAddFunction(PFunction(Message.WParam)^));
      WM_ADDVARIABLE:
        begin
          Data := PVariableData(WParam);
          Message.Result := Integer(InternalAddVariable(Data.Name, PValue(LParam)^,
            Data.Optimizable, Data.Whole, Data.ReturnType));
        end;
    else Result := DefWindowProc(FWindowHandle, Msg, WParam, LParam);
    end
end;

{ TParser }

procedure TParser.Check(Text: string);
var
  Builder: TTextBuilder;
begin
  Builder := TTextBuilder.Create;
  try
    ParseBracket(Text, FBracket, CheckMethod, Builder);
  finally
    Builder.Free;
  end;
end;

function TParser.CheckMethod(var Text: string; const SubText: string;
  StartIndex, EndIndex: Integer; Data: Pointer): Boolean;
var
  I, J: Integer;
  Builder: TTextBuilder absolute Data;
  S: string;
  K: TOperatorType;
  AFunction: PFunction;
begin
  Result := False;
  I := StartIndex - 1;
  while (I > 0) and CharInSet(Text[I], Blanks) do Dec(I);
  Builder.Clear;
  while (I > 0) and not CharInSet(Text[I], Blanks) do
  begin
    if Builder.Size = 0 then
    begin
      S := Text[I];
      for K := Low(TOperatorType) to High(TOperatorType) do
        if Assigned(GetFunction(@OData[K], S, False)) then Exit;
    end;
    Builder.Insert(Text[I]);
    Dec(I);
  end;
  if Builder.Size > 0 then
  begin
    S := Builder.Text;
    for I := Ord(Low(TTextOperator)) to Ord(High(TTextOperator)) do
    begin
      if TextUtils.SameText(S, TextOperatorArray[TTextOperator(I)]) then Break;
      if I = Ord(High(TTextOperator)) then
      begin
        for J := Ord(Low(TParameterOperator)) to Ord(High(TParameterOperator)) do
        begin
          if TextUtils.SameText(S, ParameterOperatorArray[TParameterOperator(J)]) then Break;
          if (J = Ord(High(TParameterOperator))) and not Assigned(FindType(S)) then
          begin            
            AFunction := FindFunction(S);
            if not Assigned(AFunction) then raise Error(Text, RExcessError, [S])
            else
              if not AFunction.Method.Parameter.RParameter and
                (AFunction.Method.Parameter.Count = 0) then
                  raise Error(AParameterExcessError, [AFunction.Name])
          end;
        end;
      end;
    end;
  end;
  S := SubText;
  ParseBracket(S, FParameterBracket, CheckMethod, nil);
end;

function TParser.Connect(const AEventManager: TObject): Boolean;
var
  BEventManager: TCustomEventManager absolute AEventManager;
begin
  Result := Assigned(AEventManager);
  if Result then
    if Assigned(FEventManager) then
      BEventManager.EventManager := TCustomEventManager(FEventManager)
    else begin
      BEventManager.Parser := Self;
      FEventManager := AEventManager;
    end;
end;

constructor TParser.Create(AOwner: TComponent);
begin
  inherited;
  FEventManager := TEventManager.Create(Self);
  with TEventManager(FEventManager) do
  begin
    Name := InternalEventManagerName;
    Parser := Self;
  end;
  FParseManager := TParseManager.Create(Self);
  with TParseManager(FParseManager) do
  begin
    Name := InternalParseManagerName;
    Parser := Self;
  end;
  BeginUpdate;
  try
    InternalAddFunction(MultiplyFunctionName, FMultiplyHandle, fkMethod, FunctionMethod(FMethod.MultiplyMethod),
      True, False);
    InternalAddFunction(DivideFunctionName, FDivideHandle, fkMethod, FunctionMethod(FMethod.DivideMethod),
      True, False, vtDouble);
    InternalAddFunction(SuccFunctionName, FSuccHandle, fkMethod, FunctionMethod(FMethod.SuccMethod, False, True),
      True, True, vtInt64);
    InternalAddFunction(PredFunctionName, FPredHandle, fkMethod, FunctionMethod(FMethod.PredMethod, False, True),
      True, True, vtInt64);
    InternalAddFunction(BitwiseNegationFunctionName, FNotHandle, fkMethod, FunctionMethod(FMethod.NotMethod, False, True),
      True, True, vtInt64);
    InternalAddFunction(BitwiseAndFunctionName, FAndHandle, fkMethod, FunctionMethod(FMethod.AndMethod),
      True, True, vtDouble);
    InternalAddFunction(BitwiseOrFunctionName, FOrHandle, fkMethod, FunctionMethod(FMethod.OrMethod),
      True, True, vtDouble);
    InternalAddFunction(BitwiseXorFunctionName, FXorHandle, fkMethod, FunctionMethod(FMethod.XorMethod),
      True, True, vtDouble);
    InternalAddFunction(BitwiseShiftLeftFunctionName, FShlHandle, fkMethod, FunctionMethod(FMethod.ShlMethod),
      True, True, vtDouble);
    InternalAddFunction(BitwiseShiftRightFunctionName, FShrHandle, fkMethod, FunctionMethod(FMethod.ShrMethod),
      True, True, vtDouble);
    InternalAddFunction(SameValueFunctionName, FSameValueHandle, fkMethod, FunctionMethod(FMethod.SameValueMethod, SameValueMaxParameterCount),
      True, True, vtByte);
    InternalAddFunction(IsZeroFunctionName, FIsZeroHandle, fkMethod, FunctionMethod(FMethod.IsZeroMethod, IsZeroMaxParameterCount),
      True, True, vtByte);
    InternalAddFunction(IfFunctionName, FIfHandle, fkMethod, FunctionMethod(FMethod.IfMethod, IfMaxParameterCount, pkReference),
      True, True, vtByte);
    InternalAddFunction(IfThenFunctionName, FIfThenHandle, fkMethod, FunctionMethod(FMethod.IfThenMethod, IfThenParameterCount),
      True, True, vtByte);
    InternalAddFunction(EnsureRangeFunctionName, FEnsureRangeHandle, fkMethod, FunctionMethod(FMethod.EnsureRangeMethod, EnsureRangeParameterCount),
      True, True, vtDouble);
    InternalAddFunction(StrToIntFunctionName, FStrToIntHandle, fkMethod, FunctionMethod(FMethod.StrToIntMethod, StrToIntParameterCount),
      True, True, vtInteger);
    InternalAddFunction(StrToIntDefFunctionName, FStrToIntDefHandle, fkMethod, FunctionMethod(FMethod.StrToIntDefMethod, StrToIntDefParameterCount),
      True, True, vtInteger);
    InternalAddFunction(StrToFloatFunctionName, FStrToFloatHandle, fkMethod, FunctionMethod(FMethod.StrToFloatMethod, StrToFloatParameterCount),
      True, True, vtDouble);
    InternalAddFunction(StrToFloatDefFunctionName, FStrToFloatDefHandle, fkMethod, FunctionMethod(FMethod.StrToFloatDefMethod, StrToFloatDefParameterCount),
      True, True, vtDouble);
    InternalAddFunction(ParseFunctionName, FParseHandle, fkMethod, FunctionMethod(FMethod.ParseMethod, ParseMaxParameterCount),
      False, True, vtDouble);
    InternalAddFunction(FalseFunctionName, FFalseHandle, fkMethod, FunctionMethod(FMethod.FalseMethod),
      True, True, vtByte);
    InternalAddFunction(TrueFunctionName, FTrueHandle, fkMethod, FunctionMethod(FMethod.TrueMethod),
      True, True, vtByte);
    InternalAddFunction(EqualFunctionName, FEqualHandle, fkMethod, FunctionMethod(FMethod.EqualMethod),
      True, False, vtByte);
    InternalAddFunction(NotEqualFunctionName, FNotEqualHandle, fkMethod, FunctionMethod(FMethod.NotEqualMethod),
      True, False, vtByte);
    InternalAddFunction(GreaterThanFunctionName, FGreaterThanHandle, fkMethod, FunctionMethod(FMethod.GreaterThanMethod),
      True, False, vtByte);
    InternalAddFunction(LessThanFunctionName, FLessThanHandle, fkMethod, FunctionMethod(FMethod.LessThanMethod),
      True, False, vtByte);
    InternalAddFunction(GreaterThanOrEqualFunctionName, FGreaterThanOrEqualHandle, fkMethod, FunctionMethod(FMethod.GreaterThanOrEqualMethod),
      True, False, vtByte);
    InternalAddFunction(LessThanOrEqualFunctionName, FLessThanOrEqualHandle, fkMethod, FunctionMethod(FMethod.LessThanOrEqualMethod),
      True, False, vtByte);
    InternalAddFunction(GetEpsilonFunctionName, FGetEpsilonHandle, fkMethod, FunctionMethod(FMethod.GetEpsilonMethod),
      False, False, vtDouble);
    InternalAddFunction(SetEpsilonFunctionName, FSetEpsilonHandle, fkMethod, FunctionMethod(FMethod.SetEpsilonMethod, SetEpsilonParameterCount),
      False, False, vtDouble);
    InternalAddFunction(SetDecimalSeparatorFunctionName, FSetDecimalSeparatorHandle, fkMethod, FunctionMethod(FMethod.SetDecimalSeparatorMethod, SetDecimalSeparatorParameterCount),
      False, False, vtByte);
    AddType(ShortintTypeName, FShortintHandle, vtShortint);
    AddType(ByteTypeName, FByteHandle, vtByte);
    AddType(SmallintTypeName, FSmallintHandle, vtSmallint);
    AddType(WordTypeName, FWordHandle, vtWord);
    AddType(IntegerTypeName, FIntegerHandle, vtInteger);
    AddType(LongwordTypeName, FLongwordHandle, vtLongword);
    AddType(Int64TypeName, FInt64Handle, vtInt64);
    AddType(SingleTypeName, FSingleHandle, vtSingle);
    AddType(DoubleTypeName, FDoubleHandle, vtDouble);
  finally
    EndUpdate;
  end;
  FExceptionTypes := [etZeroDivide];
  FConstantList := TFlexibleList.Create(Self);
end;

function TParser.DecompileMethod(var Index: Integer; const Header: PScriptHeader;
  const ItemHeader: PItemHeader; const Item: PScriptItem;
  const Data: Pointer): Boolean;
var
  S: string;
  AData: PDecompileData absolute Data;
  Start: Integer absolute ItemHeader;
  AType: PType;
begin
  case Item.Code of
    NumberCode:
      begin
        S := ValueToText(Item.ScriptNumber.Value);
        if LessZero(Item.ScriptNumber.Value) then
          AData.ItemText.Append(Embrace(S, FBracket), AData.Delimiter)
        else AData.ItemText.Append(S, AData.Delimiter);
        Inc(Index, SizeOf(TCode) + SizeOf(TScriptNumber));
        AData.AFunction := nil;
      end;
    FunctionCode:
      begin
        GetFunction(Self, Index, AData.AFunction);
        AData.ItemText.Append(AData.AFunction.Name, AData.Delimiter);
      end;
    StringCode:
      begin
        AData.ItemText.Append(LockChar, AData.Delimiter);
        AData.ItemText.Append(Pointer(Index + SizeOf(TCode) + SizeOf(TScriptString)),
          Item.ScriptString.Size div SizeOf(Char));
        AData.ItemText.Append(LockChar);
        Inc(Index, SizeOf(TCode) + SizeOf(TScriptString) + Item.ScriptString.Size);
        AData.AFunction := nil;
      end;
    ScriptCode:
      begin
        S := InternalDecompile(Index + SizeOf(TCode), AData.Delimiter, False,
          AData.ParameterBracket, AData.TypeMode);
        if AData.Parameter then AData.ItemText.Append(S, AData.Delimiter)
        else AData.ItemText.Append(Embrace(S, FBracket), AData.Delimiter);
        Inc(Index, SizeOf(TCode) + Item.Script.Header.ScriptSize);
        AData.AFunction := nil;
      end;
    ParameterCode:
      begin
        S := InternalDecompile(Index + SizeOf(TCode), AData.Delimiter, True,
          AData.ParameterBracket, AData.TypeMode);
        AData.ItemText.Append(Embrace(S, AData.ParameterBracket), AData.Delimiter);
        Inc(Index, SizeOf(TCode) + Item.Script.Header.ScriptSize);
        AData.AFunction := nil;
      end;
  else raise Error(ScriptError);
  end;
  if Index - Start >= ItemHeader.Size then
    with AData^ do
    begin
      if ((TypeMode = rmUserDeclared) and ItemHeader.TypeDeclarationFlag or (TypeMode = rmFull)) and
        (AData.Parameter and (Item.Code <> ScriptCode) or not AData.Parameter) then
        begin
          AType := TypeByHandle[ItemHeader.TypeHandle];
          if Assigned(AType) then ItemText.Insert(string(AType.Name) + Space)
        end;
      if Boolean(ItemHeader.Sign) then ItemText.Insert(TextOperatorArray[toNegative] + Space);
      if Text.Size > 0 then
        if Parameter then ItemText.Insert(ParameterOperatorArray[poComma] + Space)
        else
          if not Boolean(ItemHeader.Sign) then
            ItemText.Insert(TextOperatorArray[toPositive] + Space);
      if Parameter then Text.Append(ItemText.Text)
      else if ItemText.Size > 0 then Text.Append(ItemText.Text, AData.Delimiter);
      ItemText.Clear;
    end;
  Result := True;
end;

destructor TParser.Destroy;
begin
  FMethod.Free;
  FScript := nil;
  inherited;
end;

function TParser.Execute(const Index: Integer): PValue;
var
  Header: PScriptHeader absolute Index;
  Value: TValue;
begin
  Notify;
  if not (eoSubsequent in FExecuteOptions) and (Header.ScriptCount > 0) then
    ExecuteInternalScript(Index);
  Result := @Header.Value;
  Header.Value := EmptyValue;
  Value := EmptyValue;
  ParseScript(Index, ExecuteMethod, @Value);
end;

function TParser.Execute(const AScript: TScript): PValue;
begin
  Result := Execute(Integer(AScript));
end;

function TParser.Execute: PValue;
begin
  Result := Execute(FScript);
end;

function TParser.ExecuteFunction(var Index: Integer; const ItemHeader: PItemHeader;
  const LValue: TValue; const Fake: Boolean): TValue;
var
  AFunction: PFunction;
  Parameter: PFunctionParameter;
  ParameterArray: TParameterArray;
  RValue: TValue;
  Item: PScriptItem absolute Index;
  AType: PType;
begin
  GetFunction(Self, Index, AFunction);
  try
    Parameter := @AFunction.Method.Parameter;
    if Parameter.Count > 0 then
    begin
      Inc(Index, SizeOf(TCode));
      GetParameterArray(Index, ParameterArray, TParameterType(Parameter.Kind = pkReference));
      RValue := EmptyValue;
    end
    else begin
      RValue := EmptyValue;
      if Parameter.RParameter then
        case Item.Code of
          NumberCode:
            begin
              if not Fake then RValue := Item.ScriptNumber.Value;
              Inc(Index, SizeOf(TCode) + SizeOf(TScriptNumber));
            end;
          FunctionCode:
            if Fake then
              ExecuteFunction(Index, ItemHeader, EmptyValue, Fake)
            else
              RValue := ExecuteFunction(Index, ItemHeader, EmptyValue, Fake);
          ScriptCode:
            begin
              if not Fake then
                if eoSubsequent in FExecuteOptions then
                  RValue := Execute(Integer(@Item.Script.Header))^
                else
                  RValue := Item.Script.Header.Value;
              Inc(Index, SizeOf(TCode) + Item.Script.Header.ScriptSize);
            end;
        else raise Error(ScriptError);
        end;
    end;
    if Fake then Result := EmptyValue
    else
      case AFunction.Kind of
        fkHandle:
          begin
            AType := GetType(Self, ItemHeader);
            if not DoEvent(FBeforeFunction, AFunction, AType, Result, LValue, RValue, ParameterArray) and
              not DefaultFunction(AFunction, Result, LValue, RValue, ParameterArray) and
              not DoEvent(FOnFunction, AFunction, AType, Result, LValue, RValue, ParameterArray) then
                raise Error(FunctionHandleError, [AFunction.Name]);
          end;
        fkMethod:
          case AFunction.Method.MethodType of
            mtParameterless:
              begin
                AType := GetType(Self, ItemHeader);
                Result := AFunction.Method.AMethod(AFunction, AType);
              end;
            mtSingleParameter:
              begin
                AType := GetType(Self, ItemHeader);
                if Parameter.LParameter then
                  Result := AFunction.Method.BMethod(AFunction, AType, LValue)
                else
                  Result := AFunction.Method.BMethod(AFunction, AType, RValue);
              end;
            mtDoubleParameter:
              begin
                AType := GetType(Self, ItemHeader);
                Result := AFunction.Method.CMethod(AFunction, AType, LValue, RValue);
              end;
            mtParameterArray:
              begin
                AType := GetType(Self, ItemHeader);
                Result := AFunction.Method.DMethod(AFunction, AType, ParameterArray);
              end;
            mtVariable:
              case AFunction.Method.Variable.VariableType of
                vtValue: Result := AFunction.Method.Variable.AVariable^;
                vtLiveValue: Result := MakeValue(AFunction.Method.Variable.BVariable);
              else
              end;
          else Result := EmptyValue;
          end;
        else Result := EmptyValue;
        end;
  finally
    ParameterArray := nil;
  end;
end;

procedure TParser.ExecuteInternalScript(Index: Integer);
var
  Header: PScriptHeader absolute Index;
  I, J, K: Integer;
begin
  if Header.ScriptCount > 0 then
  begin
    I := Index + SizeOf(TScriptHeader);
    J := I + Header.ScriptCount * SizeOf(Integer);
    while I < J do
    begin
      K := Index + PInteger(I)^;
      Execute(K);
      Inc(I, SizeOf(Integer));
    end;
  end;
end;

function TParser.ExecuteMethod(var Index: Integer; const Header: PScriptHeader;
  const ItemHeader: PItemHeader; const Item: PScriptItem;
  const Data: Pointer): Boolean;
var
  Value: PValue absolute Data;
  Start: Integer absolute ItemHeader;
begin
  case Item.Code of
    NumberCode:
      begin
        Value^ := Item.ScriptNumber.Value;
        Inc(Index, SizeOf(TCode) + SizeOf(TScriptNumber));
      end;
    FunctionCode:
      Value^ := ExecuteFunction(Index, ItemHeader, Value^);
    ScriptCode:
      begin
        if eoSubsequent in FExecuteOptions then
          Value^ := Execute(Integer(@Item.Script.Header))^
        else
          Value^ := Item.Script.Header.Value;
        Inc(Index, SizeOf(TCode) + Item.Script.Header.ScriptSize);
      end;
    ParameterCode:
      Inc(Index, SizeOf(TCode) + Item.Script.Header.ScriptSize);
  else raise Error(ScriptError);
  end;
  if Index - Start >= ItemHeader.Size then
    Header.Value := Operation(Header.Value, Value^, TOperationType(Ord(otAdd) + ItemHeader.Sign));
  Result := True;
end;

procedure TParser.GetParameterArray(var AIndex: Integer; out AParameterArray: TParameterArray;
  const ParameterType: TParameterType; const AFake: Boolean);
var
  Data: TParameterArrayData;
begin
  FillChar(Data, SizeOf(TParameterArrayData), 0);
  with Data do
  begin
    Fake := AFake;
    ParameterArray := @AParameterArray;
    Index := @AIndex;
  end;
  case ParameterType of
    ptParameter: ParseScript(AIndex, ParameterArrayMethod, @Data);
    ptScript: ParseScript(AIndex, ScriptArrayMethod, @Data);
  end;
end;

function TCustomParser.InternalAddConstant(const AName: string; const Value: TValue): Boolean;
var
  Item: PValue;
begin
  Result := not Assigned(FindFunction(AName));
  if Result then
  begin
    New(Item);
    try
      Item^ := Value;
      Result := InternalAddVariable(AName, Item^, True, True);
      if Result then FConstantList.List.AddObject(AName, Pointer(Item))
      else Dispose(Item);
    except
      Dispose(Item);
    end;
  end;
end;

function TCustomParser.InternalAddFunction(const AFunction: TFunction): Boolean;
begin
  Notify(ntBeforeFunctionAdd, Self);
  with AFunction do
  begin
    Result := (Name <> '') and not Assigned(FindFunction(Name));
    if Result then
    begin
      if AFunction.Handle^ <> FInternalHandle then
        Validator.Check(Name, rtName);
      Handle^ := Add(FFData^, AFunction);
    end
    else Handle^ := -1;
  end;
  Notify(ntAfterFunctionAdd, Self);
end;

function TCustomParser.InternalAddFunction(const AName: string;
  var Handle: Integer; Kind: TFunctionKind; Method: TFunctionMethod;
  Optimizable, Whole: Boolean; ReturnType: TValueType): Boolean;
begin
  Result := InternalAddFunction(MakeFunction(AName, Handle, ReturnType, Kind, Method, Optimizable, Whole));
end;

function TCustomParser.InternalAddVariable(const AName: string; var Variable: TValue;
  Optimizable, Whole: Boolean; ReturnType: TValueType): Boolean;
var
  AFunction: TFunction;
begin
  AFunction := MakeFunction(AName, AFunction.Method.Variable.Handle, ReturnType, fkMethod,
    FunctionMethod(@Variable), Optimizable, Whole);
  Result := InternalAddFunction(AFunction);
end;

//1) Set ( "Pi", Sum (1) + 2 )
//2) 1
//3) Sum {#0} + 2
//4) Pi, Sum {#0} + 2
//5) Pi, {1}
//6) Set {#2}

function TParser.InternalCompile(const Text: string; var ScriptArray: TScriptArray;
  const Parameter: Boolean): TScript;
var
  AText, Item, S: string;
  AFlag, BFlag, CFlag: Boolean;
  AFunction: PFunction;
  ACache, BCache: TParseCache;
  Data: TTextData;
  AItemArray, BItemArray: TStringDynArray;
  I, J, ItemIndex: Integer;
  AScript: TScript;
  Syntax: TSyntax;
  AType: PType;
  Header: PScriptHeader absolute Result;

  procedure WriteNumber;
  begin
    Check(Syntax, okNumber, AText, ScriptArray);
    if Assigned(AType) then
    begin
      Check(AType, ItemData(Data.Value));
      if Assignable(Data.Value.ValueType, AType.ValueType) then
        AddNumber(Result, Data.Value)
      else
        AddNumber(Result, Convert(Data.Value, AType.ValueType));
    end
    else begin
      AssignValueType(Self, @Result[ItemIndex], Data.Value.ValueType);
      AddNumber(Result, Data.Value);
    end;
  end;

begin
  Result := nil;
  AText := Text;
  if AText = '' then raise Error(AText, EmptyTextError);
  AFlag := Pos(InternalFunctionName, AText) > 0;
  ACache := FCache.CacheArray[TCacheType(Ord(ctScript) + Ord(Parameter))];
  if FCached and not AFlag then
  begin
    Enter(ACache.Lock^);
    try
      Result := ACache.Find(AText);
      Sleep(Integer(Result) - Integer(Result));
    finally
      Leave(ACache.Lock^);
    end;
  end;
  if not Assigned(Result) then
  begin
    Parse(AText, ScriptArray);
    BFlag := Pos(InternalFunctionName, AText) > 0;
    GetItemArray(AText, OData[TOperatorType(Ord(otText) + Ord(Parameter))], AItemArray, True);
    try
      BCache := FCache.CacheArray[TCacheType(Ord(ctSubscript) + Ord(Parameter))];
      Resize(Result, SizeOf(TScriptHeader));
      for I := Low(AItemArray) to High(AItemArray) do
      begin
        ItemIndex := Length(Result);
        S := AItemArray[I];
        if Parameter then DeleteParameterOperator(S);
        Item := S;
        CFlag := GetSign(S);
        if not FCached or Assigned(ScriptArray) then AScript := nil
        else begin
          Enter(BCache.Lock^);
          try
            AScript := BCache.Find(Item);
            Sleep(Integer(Result) - Integer(Result));
          finally
            Leave(BCache.Lock^);
          end;
        end;
        try
          if Assigned(AScript) then Add(Result, AScript)
          else begin
            Resize(Result, ItemIndex + SizeOf(TItemHeader));
            FillChar(Syntax, SizeOf(TSyntax), 0);
            AType := GetType(Self, FStringHandle, S, True);
            Data := TextData[S];
            WriteItemHeader(PItemHeader(@Result[ItemIndex]), CFlag, AType, FDefaultTypeHandle);
            if Data.TextType = ttNumber then WriteNumber
            else begin
              if S = '' then raise Error(TextError, [AText]);
              if Parameter and (Data.TextType = ttExpression) then
              begin
                try
                  if FCached and not Assigned(ScriptArray) then
                  begin
                    Enter(ACache.Lock^);
                    try
                      AScript := ACache.Find(S);
                      if not Assigned(AScript) then
                      begin
                        AScript := InternalCompile(S, ScriptArray, False);
                        ACache.Add(S, AScript);
                      end;
                    finally
                      Leave(ACache.Lock^);
                    end;
                  end
                  else AScript := InternalCompile(S, ScriptArray, False);
                  S := Embrace(IntToStr(Add(ScriptArray, AScript)), BracketArray[btBrace]);
                finally
                  AScript := nil;
                end;
              end;
              GetItemArray(S, FFData^, BItemArray);
              try
                Data.Value.ValueType := FDefaultValueType;
                for J := Low(BItemArray) to High(BItemArray) do
                begin
                  S := BItemArray[J];
                  AFunction := GetFunction(FFData, S, True);
                  if Assigned(AFunction) then
                    if AFunction.Handle^ = FInternalHandle then
                    begin
                      AScript := ScriptArray[GetInternalScriptIndex(S, @CFlag)];
                      Check(AType, ItemData(@AScript, CFlag));
                      Check(Syntax, TOperatorKind(Ord(okScript) + Ord(CFlag)), AText, ScriptArray);
                      AddScript(Result, AScript, CFlag, @ItemIndex);
                    end
                    else begin
                      Check(AType, ItemData(AFunction));
                      Check(Syntax, okFunction, AText, ScriptArray, AFunction);
                      ParseTypes.AddFunction(Result, AFunction.Handle^);
                      if Assignable(Data.Value.ValueType, AFunction.ReturnType) then
                      begin
                        AssignValueType(Self, @Result[ItemIndex], AFunction.ReturnType);
                        Data.Value.ValueType := AFunction.ReturnType;
                      end;
                    end;
                  Data := GetTextData(S);
                  case Data.TextType of
                    ttNumber: WriteNumber;
                    ttString:
                      if Parameter then
                      begin
                        PItemHeader(@Result[ItemIndex]).TypeHandle := FStringHandle;
                        AddString(Result, Data.S);
                      end
                      else raise Error(StringError, [Data.S]);
                  else if S <> '' then raise Error(ElementError, [S]);
                  end;
                end;
                Check(Syntax, okLast, AText, ScriptArray);
              finally
                BItemArray := nil;
              end;
            end;
            PItemHeader(@Result[ItemIndex]).Size := Length(Result) - ItemIndex;
            if FCached and not BFlag then
            begin
              Enter(BCache.Lock^);
              try
                AScript := Segment(Result, ItemIndex, Length(Result) - ItemIndex);
                try
                  BCache.Add(Item, AScript);
                finally
                  AScript := nil;
                end;
              finally
                Leave(BCache.Lock^);
              end;
            end;
          end;
        finally
          AScript := nil;
        end;
      end;
    finally
      AItemArray := nil;
    end;
    Header.ScriptSize := Length(Result);
    Header.HeaderSize := SizeOf(TScriptHeader) + Header.ScriptCount * SizeOf(Integer);
    if FCached and not AFlag then
    begin
      Enter(ACache.Lock^);
      try
        ACache.Add(Text, Result);
      finally
        Leave(ACache.Lock^);
      end;
    end;
  end;
end;

function TParser.InternalDecompile(Index: Integer; const ADelimiter: string;
  AParameter: Boolean; AParameterBracket: TBracket;
  ATypeMode: TRetrieveMode): string;
var
  Data: TDecompileData;
begin
  FillChar(Data, SizeOf(TDecompileData), 0);
  Data.Text := TTextBuilder.Create;
  try
    Data.ItemText := TTextBuilder.Create;
    try
      with Data do
      begin
        Delimiter := ADelimiter;
        Parameter := AParameter;
        ParameterBracket := AParameterBracket;
        TypeMode := ATypeMode;
      end;
      ParseScript(Index, DecompileMethod, @Data);
      Result := Data.Text.Text;
    finally
      Data.ItemText.Free;
    end;
  finally
    Data.Text.Free;
  end;
end;

procedure TParser.InternalOptimize(Index: Integer; out AScript: TScript);
var
  Data: TOptimizationData;
begin
  FillChar(Data, SizeOf(TOptimizationData), 0);
  try
    ParseScript(Index, OptimizationMethod, @Data);
    BuildScript(Self, Data.ItemArray, AScript, True);
  finally
    DeleteArray(Data.ItemArray);
  end;
end;

procedure TParser.Notify(NotifyType: TNotifyType; Component: TComponent);
begin
  if Notifiable(NotifyType) and (NotifyType = ntCompile) then Cache.Clear;
  inherited;
end;

function TParser.Optimizable(var Index: Integer; Number: Boolean; out Offset: Integer;
  out Parameter: Boolean; out AScript: TScript): Boolean;
var
  AFunction: PFunction;
  Item: PScriptItem absolute Index;
begin
  GetFunction(Self, Index, AFunction);
  Parameter := AFunction.Method.Parameter.Count > 0;
  if Parameter then
    if Item.Code = ParameterCode then
    begin
      Result := OptimizeParameterArray(Index + SizeOf(TCode), AScript) and AFunction.Optimizable;
      Offset := SizeOf(TCode) + Item.Script.Header.ScriptSize;
      if Result then
      begin
        AScript := nil;
        Inc(Index, Offset);
      end;
    end
    else raise Error(ScriptError)
  else begin
    Result := (AFunction.Method.Parameter.LParameter xor not Number) and AFunction.Optimizable;
    if Result and AFunction.Method.Parameter.RParameter then
      case Item.Code of
        NumberCode:
          Inc(Index, SizeOf(TCode) + SizeOf(TScriptNumber));
        FunctionCode:
          Result := Optimizable(Index, False, Offset, Parameter, AScript);
        ScriptCode:
          begin
            InternalOptimize(Integer(@Item.Script.Header), AScript);
            Result := Optimal(AScript, stScript);
            Offset := SizeOf(TCode) + Item.Script.Header.ScriptSize;
            if Result then
            begin
              Item.Script.Header.Value := Execute(AScript)^;
              AScript := nil;
              Inc(Index, Offset);
            end;
          end;
      else raise Error(ScriptError);
      end;
  end;
end;

function TParser.OptimizationMethod(var Index: Integer; const Header: PScriptHeader;
  const ItemHeader: PItemHeader; const Item: PScriptItem;
  const Data: Pointer): Boolean;
var
  Start: Integer absolute ItemHeader;
  I, J, Offset: Integer;
  AData: POptimizationData absolute Data;
  Parameter: Boolean;
  AScript: TScript;
begin
  if (Index - Start = SizeOf(TItemHeader)) or not Assigned(AData.ItemArray) then
  begin
    I := Add(AData.ItemArray, nil);
    Resize(AData.ItemArray[I], SizeOf(TItemHeader));
  end
  else I := High(AData.ItemArray);
  case Item.Code of
    NumberCode:
      begin
        with AData.Number do
        begin
          Value := Item.ScriptNumber.Value;
          Valid := True;
        end;
        Inc(Index, SizeOf(TCode) + SizeOf(TScriptNumber));
      end;
    FunctionCode:
      begin
        J := Index;
        try
          if Optimizable(Index, AData.Number.Valid, Offset, Parameter, AScript) then
          begin
            AData.Number.Value := ExecuteFunction(J, ItemHeader, AData.Number.Value);
            AData.Number.Valid := True;
          end
          else begin
            if AData.Number.Valid then
            begin
              AddNumber(AData.ItemArray[I], AData.Number.Value);
              AData.Number.Valid := False;
              AssignValueType(Self, ItemHeader, AData.Number.Value.ValueType);
            end;
            Add(AData.ItemArray[I], Pointer(J), Index - J);
            if Assigned(AScript) then
            begin
              AddScript(AData.ItemArray[I], AScript, Parameter);
              Inc(Index, Offset);
            end;
          end;
        finally
          AScript := nil;
        end;
      end;
    ScriptCode:
      begin
        InternalOptimize(Integer(@Item.Script.Header), AScript);
        try
          with AData^ do
          begin
            Number.Valid := Optimal(AScript, stScript);
            if Number.Valid then
            begin
              ItemHeader.TypeDeclarationFlag := TypeDeclarationFlag(AScript, stScript);
              Number.Value := Execute(AScript)^;
            end
            else AddScript(ItemArray[I], AScript, False);
          end;
        finally
          AScript := nil;
        end;
        Inc(Index, SizeOf(TCode) + Item.Script.Header.ScriptSize);
      end;
  else raise Error(ScriptError);
  end;
  if Index - Start >= ItemHeader.Size then
    with AData^ do
    begin
      if Number.Valid then
      begin
        AddNumber(ItemArray[I], Number.Value);
        Number.Valid := False;
        AssignValueType(Self, ItemHeader, Number.Value.ValueType);
      end;
      PItemHeader(ItemArray[I])^ := ItemHeader^;
      PItemHeader(ItemArray[I]).Size := Length(ItemArray[I]);
    end;
  Result := True;
end;

procedure TParser.Optimize(const Source: TScript; out Target: TScript);
begin
  InternalOptimize(Integer(Source), Target);
end;

procedure TParser.Optimize;
begin
  Optimize(FScript);
end;

procedure TParser.Optimize(var AScript: TScript);
var
  BScript: TScript;
begin
  Optimize(AScript, BScript);
  AScript := BScript;
end;

function TParser.OptimizeParameterArray(Index: Integer; out AScript: TScript): Boolean;
var
  Data: TParameterOptimizationData;
begin
  FillChar(Data, SizeOf(TParameterOptimizationData), 0);
  Data.Optimal := True;
  try
    ParseScript(Index, ParameterOptimizationMethod, @Data);
    Result := Data.Optimal;
    BuildScript(Self, Data.ItemArray, AScript, False);
  finally
    DeleteArray(Data.ItemArray);
  end;
end;

function TParser.ParameterArrayMethod(var AIndex: Integer; const Header: PScriptHeader;
  const ItemHeader: PItemHeader; const Item: PScriptItem;
  const Data: Pointer): Boolean;
var
  AData: PParameterArrayData absolute Data;
  I, J: Integer;
  Start: Integer absolute ItemHeader;
begin
  I := -1;
  case Item.Code of
    NumberCode:
      begin
        if not AData.Fake then
          I := Add(AData.ParameterArray^, ItemHeader.TypeHandle, Item.ScriptNumber.Value);
        Inc(AIndex, SizeOf(TCode) + SizeOf(TScriptNumber));
      end;
    FunctionCode:
      begin
        if AData.Fake then
          ExecuteFunction(AIndex, ItemHeader, EmptyValue, AData.Fake)
        else
          I := Add(AData.ParameterArray^, ItemHeader.TypeHandle, ExecuteFunction(AIndex, ItemHeader, EmptyValue));
      end;
    StringCode:
      begin
        if not AData.Fake then
        begin
          I := Add(AData.ParameterArray^, ItemHeader.TypeHandle, '');
          J := Item.ScriptString.Size;
          if J > SizeOf(TString) then J := SizeOf(TString);
          ZeroMemory(@AData.ParameterArray^[I].Text, SizeOf(TString));
          CopyMemory(@AData.ParameterArray^[I].Text, Pointer(AIndex + SizeOf(TCode) + SizeOf(TScriptString)), J);
        end;
        Inc(AIndex, SizeOf(TCode) + SizeOf(TScriptString) + Item.ScriptString.Size);
      end;
    ScriptCode:
      begin
        if not AData.Fake then
          I := Add(AData.ParameterArray^, ItemHeader.TypeHandle, Execute(Integer(@Item.Script.Header))^);
        Inc(AIndex, SizeOf(TCode) + Item.Script.Header.ScriptSize);
      end;
  else raise Error(ScriptError);
  end;
  if AIndex - Start >= ItemHeader.Size then
    with AData^ do
    begin
      if (I >= 0) and Boolean(ItemHeader.Sign) then
        ParameterArray^[I].Value := Negative(ParameterArray^[I].Value);
      Index^ := AIndex;
    end;
  Result := True;
end;

function TParser.ParameterOptimizationMethod(var Index: Integer; const Header: PScriptHeader;
  const ItemHeader: PItemHeader; const Item: PScriptItem;
  const Data: Pointer): Boolean;
var
  Start: Integer absolute ItemHeader;
  I, J, Offset: Integer;
  AData: PParameterOptimizationData absolute Data;
  Parameter: Boolean;
  AScript: TScript;
begin
  if (Index - Start = SizeOf(TItemHeader)) or not Assigned(AData.ItemArray) then
  begin
    I := Add(AData.ItemArray, nil);
    Resize(AData.ItemArray[I], SizeOf(TItemHeader));
  end
  else I := High(AData.ItemArray);
  case Item.Code of
    NumberCode:
      begin
        AddNumber(AData.ItemArray[I], Item.ScriptNumber.Value);
        Inc(Index, SizeOf(TCode) + SizeOf(TScriptNumber));
      end;
    FunctionCode:
      begin
        J := Index;
        try
          if Optimizable(Index, False, Offset, Parameter, AScript) then
            AddNumber(AData.ItemArray[I], ExecuteFunction(J, ItemHeader, EmptyValue))
          else begin
            Add(AData.ItemArray[I], Pointer(J), Index - J);
            if Assigned(AScript) then
            begin
              AddScript(AData.ItemArray[I], AScript, Parameter);
              Inc(Index, Offset);
            end;
            AData.Optimal := False;
          end;
        finally
          AScript := nil;
        end;
      end;
    StringCode:
      begin
        J := SizeOf(TCode) + SizeOf(TScriptString);
        AddString(AData.ItemArray[I], Pointer(Index + J), Item.ScriptString.Size);
        Inc(Index, J + Item.ScriptString.Size);
      end;
    ScriptCode:
      begin
        InternalOptimize(Integer(@Item.Script.Header), AScript);
        try
          if Optimal(AScript, stScript) then
            AddNumber(AData.ItemArray[I], Execute(AScript)^)
          else begin
            AddScript(AData.ItemArray[I], AScript, False);
            AData.Optimal := False;
          end;
        finally
          AScript := nil;
        end;
        Inc(Index, SizeOf(TCode) + Item.Script.Header.ScriptSize);
      end;
  else raise Error(ScriptError);
  end;
  if Index - Integer(ItemHeader) >= ItemHeader.Size then
    with AData^ do
    begin
      PItemHeader(ItemArray[I])^ := ItemHeader^;
      PItemHeader(ItemArray[I]).Size := Length(ItemArray[I]);
    end;
  Result := True;
end;

procedure TParser.Parse(var Text: string; var AScriptArray: TScriptArray);
var
  AData: TBracketData;
  I: Boolean;
begin
  AData.ScriptArray := @AScriptArray;
  for I := Low(Boolean) to High(Boolean) do
  begin
    AData.Parameter := I;
    if AData.Parameter then ParseBracket(Text, FParameterBracket, ParseMethod, @AData)
    else ParseBracket(Text, FBracket, ParseMethod, @AData);
  end;
end;

function TParser.ParseMethod(var Text: string; const SubText: string;
  StartIndex, EndIndex: Integer; Data: Pointer): Boolean;
var
  AData: PBracketData absolute Data;
  I: Integer;
  Prefix: string;
begin
  I := Add(AData.ScriptArray^, InternalCompile(SubText, AData.ScriptArray^, AData.Parameter));
  if AData.Parameter then Prefix := ParameterPrefix
  else Prefix := '';
  System.Delete(Text, StartIndex, EndIndex - StartIndex + 1);
  System.Insert(Embrace(Prefix + IntToStr(I), BracketArray[btBrace]), Text, StartIndex);
  Result := True;
end;

function TParser.ScriptToString(const AScript: TScript; const Delimiter: string;
  const TypeMode: TRetrieveMode): string;
begin
  Result := ScriptToString(AScript, Delimiter, FBracket, TypeMode);
end;

function TParser.ScriptToString(const AScript: TScript; const TypeMode: TRetrieveMode): string;
begin
  Result := ScriptToString(AScript, Space, FBracket, TypeMode);
end;

function TParser.ScriptArrayMethod(var AIndex: Integer; const Header: PScriptHeader;
  const ItemHeader: PItemHeader; const Item: PScriptItem;
  const Data: Pointer): Boolean;
var
  AData: PParameterArrayData absolute Data;
  Value: TValue;
  Start: Integer absolute ItemHeader;
begin
  if not AData.Fake then
  begin
    with Value do
    begin
      Int64Rec.Lo := Integer(Item);
      Int64Rec.Hi := Integer(ItemHeader);
      ValueType := vtInt64;
    end;
    Add(AData.ParameterArray^, ItemHeader.TypeHandle, Value);
  end;
  case Item.Code of
    NumberCode:
      Inc(AIndex, SizeOf(TCode) + SizeOf(TScriptNumber));
    FunctionCode:
      ExecuteFunction(AIndex, ItemHeader, EmptyValue, True);
    StringCode:
      Inc(AIndex, SizeOf(TCode) + SizeOf(TScriptString) + Item.ScriptString.Size);
    ScriptCode:
      Inc(AIndex, SizeOf(TCode) + Item.Script.Header.ScriptSize);
  else raise Error(ScriptError);
  end;
  if AIndex - Start >= ItemHeader.Size then AData.Index^ := AIndex;
  Result := True;
end;

function TParser.ScriptToString(const TypeMode: TRetrieveMode): string;
begin
  Result := ScriptToString(FScript, TypeMode);
end;

function TParser.ScriptToString(const AScript: TScript; const Delimiter: string;
  const ABracket: TBracket; const TypeMode: TRetrieveMode): string;
begin
  Result := InternalDecompile(Integer(AScript), Delimiter, False, ABracket, TypeMode);
end;

procedure TParser.StringToScript(Text: string; out AScript: TScript);
var
  ScriptArray: TScriptArray;
begin
  Text := Trim(Text);
  Validator.Check(Text, rtText);
  PrepareFData(Self);
  PrepareTData(Self);
  ChangeBracket(Text, FFData^, FBracket, FParameterBracket);
  try
    try
      AScript := InternalCompile(Text, ScriptArray, False);
    except
      Check(Text);
      raise;
    end;
  finally
    DeleteArray(ScriptArray);
  end;
end;

procedure TParser.StringToScript(const AText: string);
begin
  StringToScript(AText, FScript);
end;

procedure TParser.StringToScript;
begin
  StringToScript(FText, FScript);
end;

{ TMathParser }

constructor TMathParser.Create(AOwner: TComponent);
begin
  inherited;
  FMathMethod := TMathMethod.Create(Self);
  BeginUpdate;
  try
    InternalAddFunction(IntegerDivideFunctionName, FDivHandle, fkMethod, FunctionMethod(FMathMethod.DivMethod),
      True, True, vtInteger);
    InternalAddFunction(ReminderFunctionName, FModHandle, fkMethod, FunctionMethod(FMathMethod.ModMethod),
      True, True, vtInteger);
    InternalAddFunction(DegreeFunctionName, FDegreeHandle, fkMethod, FunctionMethod(FMathMethod.DegreeMethod),
      True, False, vtDouble);
    InternalAddFunction(FactorialFunctionName, FFactorialHandle, fkMethod, FunctionMethod(FMathMethod.FactorialMethod, True, False),
      True, False, vtInt64);
    InternalAddFunction(SqrFunctionName, FSqrHandle, fkMethod, FunctionMethod(FMathMethod.SqrMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(SqrtFunctionName, FSqrtHandle, fkMethod, FunctionMethod(FMathMethod.SqrtMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(IntFunctionName, FIntHandle, fkMethod, FunctionMethod(FMathMethod.IntMethod, False, True),
      True, True, vtInteger);
    InternalAddFunction(RoundFunctionName, FRoundHandle, fkMethod, FunctionMethod(FMathMethod.RoundMethod, False, True),
      True, True, vtInteger);
    InternalAddFunction(RoundToFunctionName, FRoundToHandle, fkMethod, FunctionMethod(FMathMethod.RoundToMethod, RoundToParameterCount),
      True, True, vtInteger);
    InternalAddFunction(TruncFunctionName, FTruncHandle, fkMethod, FunctionMethod(FMathMethod.TruncMethod, False, True),
      True, True, vtInteger);
    InternalAddFunction(AbsFunctionName, FAbsHandle, fkMethod, FunctionMethod(FMathMethod.AbsMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(FracFunctionName, FFracHandle, fkMethod, FunctionMethod(FMathMethod.FracMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(LnFunctionName, FLnHandle, fkMethod, FunctionMethod(FMathMethod.LnMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(LgFunctionName, FLgHandle, fkMethod, FunctionMethod(FMathMethod.LgMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(LogFunctionName, FLogHandle, fkMethod, FunctionMethod(FMathMethod.LogMethod),
      True, True, vtDouble);
    InternalAddFunction(ExpFunctionName, FExpHandle, fkMethod, FunctionMethod(FMathMethod.ExpMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(RandomFunctionName, FRandomHandle, fkMethod, FunctionMethod(FMathMethod.RandomMethod, False, True),
      False, True, vtInteger);
    InternalAddFunction(SinFunctionName, FSinHandle, fkMethod, FunctionMethod(FMathMethod.SinMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(ArcSinFunctionName, FArcSinHandle, fkMethod, FunctionMethod(FMathMethod.ArcSinMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(SinHFunctionName, FSinHHandle, fkMethod, FunctionMethod(FMathMethod.SinHMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(ArcSinHFunctionName, FArcSinHHandle, fkMethod, FunctionMethod(FMathMethod.ArcSinHMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(CosFunctionName, FCosHandle, fkMethod, FunctionMethod(FMathMethod.CosMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(ArcCosFunctionName, FArcCosHandle, fkMethod, FunctionMethod(FMathMethod.ArcCosMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(CosHFunctionName, FCosHHandle, fkMethod, FunctionMethod(FMathMethod.CosHMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(ArcCosHFunctionName, FArcCosHHandle, fkMethod, FunctionMethod(FMathMethod.ArcCosHMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(TanFunctionName, FTanHandle, fkMethod, FunctionMethod(FMathMethod.TanMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(ArcTanFunctionName, FArcTanHandle, fkMethod, FunctionMethod(FMathMethod.ArcTanMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(TanHFunctionName, FTanHHandle, fkMethod, FunctionMethod(FMathMethod.TanHMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(ArcTanHFunctionName, FArcTanHHandle, fkMethod, FunctionMethod(FMathMethod.ArcTanHMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(CoTanFunctionName, FCoTanHandle, fkMethod, FunctionMethod(FMathMethod.CoTanMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(ArcCotanFunctionName, FArcCoTanHandle, fkMethod, FunctionMethod(FMathMethod.ArcCoTanMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(CotanHFunctionName, FCoTanHHandle, fkMethod, FunctionMethod(FMathMethod.CoTanHMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(ArcCotanHFunctionName, FArcCoTanHHandle, fkMethod, FunctionMethod(FMathMethod.ArcCoTanHMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(SecFunctionName, FSecHandle, fkMethod, FunctionMethod(FMathMethod.SecMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(ArcSecFunctionName, FArcSecHandle, fkMethod, FunctionMethod(FMathMethod.ArcSecMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(SecHFunctionName, FSecHHandle, fkMethod, FunctionMethod(FMathMethod.SecHMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(ArcSecHFunctionName, FArcSecHHandle, fkMethod, FunctionMethod(FMathMethod.ArcSecHMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(CscFunctionName, FCscHandle, fkMethod, FunctionMethod(FMathMethod.CscMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(ArcCscFunctionName, FArcCscHandle, fkMethod, FunctionMethod(FMathMethod.ArcCscMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(CscHFunctionName, FCscHHandle, fkMethod, FunctionMethod(FMathMethod.CscHMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(ArcCscHFunctionName, FArcCscHHandle, fkMethod, FunctionMethod(FMathMethod.ArcCscHMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(ArcTan2FunctionName, FArcTan2Handle, fkMethod, FunctionMethod(FMathMethod.ArcTan2Method, ArcTan2ParameterCount),
      True, True, vtDouble);
    InternalAddFunction(HypotFunctionName, FHypotHandle, fkMethod, FunctionMethod(FMathMethod.HypotMethod, HypotParameterCount),
      True, True, vtDouble);
    InternalAddFunction(RadToDegFunctionName, FRadToDegHandle, fkMethod, FunctionMethod(FMathMethod.RadToDegMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(RadToGradFunctionName, FRadToGradHandle, fkMethod, FunctionMethod(FMathMethod.RadToGradMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(RadToCycleFunctionName, FRadToCycleHandle, fkMethod, FunctionMethod(FMathMethod.RadToCycleMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(DegToRadFunctionName, FDegToRadHandle, fkMethod, FunctionMethod(FMathMethod.DegToRadMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(DegToGradFunctionName, FDegToGradHandle, fkMethod, FunctionMethod(FMathMethod.DegToGradMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(DegToCycleFunctionName, FDegToCycleHandle, fkMethod, FunctionMethod(FMathMethod.DegToCycleMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(GradToRadFunctionName, FGradToRadHandle, fkMethod, FunctionMethod(FMathMethod.GradToRadMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(GradToDegFunctionName, FGradToDegHandle, fkMethod, FunctionMethod(FMathMethod.GradToDegMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(GradToCycleFunctionName, FGradToCycleHandle, fkMethod, FunctionMethod(FMathMethod.GradToCycleMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(CycleToRadFunctionName, FCycleToRadHandle, fkMethod, FunctionMethod(FMathMethod.CycleToRadMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(CycleToDegFunctionName, FCycleToDegHandle, fkMethod, FunctionMethod(FMathMethod.CycleToDegMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(CycleToGradFunctionName, FCycleToGradHandle, fkMethod, FunctionMethod(FMathMethod.CycleToGradMethod, False, True),
      True, True, vtDouble);
    InternalAddFunction(LnXP1FunctionName, FLnXP1Handle, fkMethod, FunctionMethod(FMathMethod.LnXP1Method, False, True),
      True, True, vtDouble);
    InternalAddFunction(Log10FunctionName, FLog10Handle, fkMethod, FunctionMethod(FMathMethod.Log10Method, False, True),
      True, True, vtDouble);
    InternalAddFunction(Log2FunctionName, FLog2Handle, fkMethod, FunctionMethod(FMathMethod.Log2Method, False, True),
      True, True, vtDouble);
    InternalAddFunction(IntPowerFunctionName, FIntPowerHandle, fkMethod, FunctionMethod(FMathMethod.IntPowerMethod, IntPowerParameterCount),
      True, True, vtDouble);
    InternalAddFunction(PowerFunctionName, FPowerHandle, fkMethod, FunctionMethod(FMathMethod.PowerMethod, PowerParameterCount),
      True, True, vtDouble);
    InternalAddFunction(LdexpFunctionName, FLdexpHandle, fkMethod, FunctionMethod(FMathMethod.LdexpMethod, LdexpParameterCount),
      True, True, vtDouble);
    InternalAddFunction(CeilFunctionName, FCeilHandle, fkMethod, FunctionMethod(FMathMethod.CeilMethod, False, True),
      True, True, vtInteger);
    InternalAddFunction(FloorFunctionName, FFloorHandle, fkMethod, FunctionMethod(FMathMethod.FloorMethod, False, True),
      True, True, vtInteger);
    InternalAddFunction(PolyFunctionName, FPolyHandle, fkMethod, FunctionMethod(FMathMethod.PolyMethod, PolyParameterCount),
      True, True, vtDouble);
    InternalAddFunction(MeanFunctionName, FMeanHandle, fkMethod, FunctionMethod(FMathMethod.MeanMethod, MeanParameterCount),
      True, True, vtDouble);
    InternalAddFunction(SumFunctionName, FSumHandle, fkMethod, FunctionMethod(FMathMethod.SumMethod, SumParameterCount),
      True, True, vtDouble);
    InternalAddFunction(SumIntFunctionName, FSumIntHandle, fkMethod, FunctionMethod(FMathMethod.SumIntMethod, SumIntParameterCount),
      True, True, vtInteger);
    InternalAddFunction(SumOfSquaresFunctionName, FSumOfSquaresHandle, fkMethod, FunctionMethod(FMathMethod.SumOfSquaresMethod, SumOfSquaresParameterCount),
      True, True, vtDouble);
    InternalAddFunction(MinValueFunctionName, FMinValueHandle, fkMethod, FunctionMethod(FMathMethod.MinValueMethod, MinValueParameterCount),
      True, True, vtDouble);
    InternalAddFunction(MinIntValueFunctionName, FMinIntValueHandle, fkMethod, FunctionMethod(FMathMethod.MinIntValueMethod, MinIntValueParameterCount),
      True, True, vtInteger);
    InternalAddFunction(MinFunctionName, FMinHandle, fkMethod, FunctionMethod(FMathMethod.MinMethod, MinParameterCount),
      True, True, vtDouble);
    InternalAddFunction(MaxValueFunctionName, FMaxValueHandle, fkMethod, FunctionMethod(FMathMethod.MaxValueMethod, MaxValueParameterCount),
      True, True, vtDouble);
    InternalAddFunction(MaxIntValueFunctionName, FMaxIntValueHandle, fkMethod, FunctionMethod(FMathMethod.MaxIntValueMethod, MaxIntValueParameterCount),
      True, True, vtInteger);
    InternalAddFunction(MaxFunctionName, FMaxHandle, fkMethod, FunctionMethod(FMathMethod.MaxMethod, MaxParameterCount),
      True, True, vtDouble);
    InternalAddFunction(StdDevFunctionName, FStdDevHandle, fkMethod, FunctionMethod(FMathMethod.StdDevMethod, StdDevParameterCount),
      True, True, vtDouble);
    InternalAddFunction(PopnStdDevFunctionName, FPopnStdDevHandle, fkMethod, FunctionMethod(FMathMethod.PopnStdDevMethod, PopnStdDevParameterCount),
      True, True, vtDouble);
    InternalAddFunction(VarianceFunctionName, FVarianceHandle, fkMethod, FunctionMethod(FMathMethod.VarianceMethod, VarianceParameterCount),
      True, True, vtDouble);
    InternalAddFunction(PopnVarianceFunctionName, FPopnVarianceHandle, fkMethod, FunctionMethod(FMathMethod.PopnVarianceMethod, PopnVarianceParameterCount),
      True, True, vtDouble);
    InternalAddFunction(TotalVarianceFunctionName, FTotalVarianceHandle, fkMethod, FunctionMethod(FMathMethod.TotalVarianceMethod, TotalVarianceParameterCount),
      True, True, vtDouble);
    InternalAddFunction(NormFunctionName, FNormHandle, fkMethod, FunctionMethod(FMathMethod.NormMethod, NormParameterCount),
      True, True, vtDouble);
    InternalAddFunction(RandGFunctionName, FRandGHandle, fkMethod, FunctionMethod(FMathMethod.RandGMethod, RandGParameterCount),
      True, True, vtDouble);
    InternalAddFunction(RandomRangeFunctionName, FRandomRangeHandle, fkMethod, FunctionMethod(FMathMethod.RandomRangeMethod, RandomRangeParameterCount),
      False, True, vtInteger);
    InternalAddFunction(RandomFromFunctionName, FRandomFromHandle, fkMethod, FunctionMethod(FMathMethod.RandomFromMethod, RandomFromParameterCount),
      False, True, vtInteger);
    InternalAddFunction(YearFunctionName, FYearHandle, fkMethod, FunctionMethod(FMathMethod.YearMethod), False, True, vtWord);
    InternalAddFunction(MonthFunctionName, FMonthHandle, fkMethod, FunctionMethod(FMathMethod.MonthMethod), False, True, vtWord);
    InternalAddFunction(DayFunctionName, FDayHandle, fkMethod, FunctionMethod(FMathMethod.DayMethod), False, True, vtWord);
    InternalAddFunction(DayOfWeekFunctionName, FDayOfWeekHandle, fkMethod, FunctionMethod(FMathMethod.DayOfWeekMethod), False, True, vtWord);
    InternalAddFunction(HourFunctionName, FHourHandle, fkMethod, FunctionMethod(FMathMethod.HourMethod), False, True, vtWord);
    InternalAddFunction(MinuteFunctionName, FMinuteHandle, fkMethod, FunctionMethod(FMathMethod.MinuteMethod), False, True, vtWord);
    InternalAddFunction(SecondFunctionName, FSecondHandle, fkMethod, FunctionMethod(FMathMethod.SecondMethod), False, True, vtWord);
    InternalAddFunction(MSecondFunctionName, FMSecondHandle, fkMethod, FunctionMethod(FMathMethod.MSecondMethod), False, True, vtWord);
    InternalAddFunction(TimeFunctionName, FTimeHandle, fkMethod, FunctionMethod(FMathMethod.TimeMethod), False, True, vtWord);
    InternalAddFunction(DateFunctionName, FDateHandle, fkMethod, FunctionMethod(FMathMethod.DateMethod), False, True, vtWord);
    InternalAddFunction(GetYearFunctionName, FGetYearHandle, fkMethod, FunctionMethod(FMathMethod.GetYearMethod, GetYearParameterCount),
      True, True, vtWord);
    InternalAddFunction(GetMonthFunctionName, FGetMonthHandle, fkMethod, FunctionMethod(FMathMethod.GetMonthMethod, GetMonthParameterCount),
      True, True, vtWord);
    InternalAddFunction(GetDayFunctionName, FGetDayHandle, fkMethod, FunctionMethod(FMathMethod.GetDayMethod, GetDayParameterCount),
      True, True, vtWord);
    InternalAddFunction(GetDayOfWeekFunctionName, FGetDayOfWeekHandle, fkMethod, FunctionMethod(FMathMethod.GetDayOfWeekMethod, GetDayOfWeekParameterCount),
      True, True, vtWord);
    InternalAddFunction(GetHourFunctionName, FGetHourHandle, fkMethod, FunctionMethod(FMathMethod.GetHourMethod, GetHourParameterCount),
      True, True, vtWord);
    InternalAddFunction(GetMinuteFunctionName, FGetMinuteHandle, fkMethod, FunctionMethod(FMathMethod.GetMinuteMethod, GetMinuteParameterCount),
      True, True, vtWord);
    InternalAddFunction(GetSecondFunctionName, FGetSecondHandle, fkMethod, FunctionMethod(FMathMethod.GetSecondMethod, GetSecondParameterCount),
      True, True, vtWord);
    InternalAddFunction(GetMSecondFunctionName, FGetMSecondHandle, fkMethod, FunctionMethod(FMathMethod.GetMSecondMethod, GetMSecondParameterCount),
      True, True, vtWord);
    InternalAddFunction(EncodeTimeFunctionName, FEncodeTimeHandle, fkMethod, FunctionMethod(FMathMethod.EncodeTimeMethod, EncodeTimeParameterCount),
      True, True, vtWord);
    InternalAddFunction(EncodeDateFunctionName, FEncodeDateHandle, fkMethod, FunctionMethod(FMathMethod.EncodeDateMethod, EncodeDateParameterCount),
      True, True, vtWord);
    InternalAddFunction(EncodeDateTimeFunctionName, FEncodeDateTimeHandle, fkMethod, FunctionMethod(FMathMethod.EncodeDateTimeMethod, EncodeDateTimeParameterCount),
      True, True, vtWord);
    InternalAddConstant(PiConstantName, MakeValue(Pi));
    InternalAddConstant(KilobyteConstantName, MakeValue(Kilobyte));
    InternalAddConstant(MegabyteConstantName, MakeValue(Megabyte));
    InternalAddConstant(GigabyteConstantName, MakeValue(Gigabyte));
    InternalAddConstant(MinShortintConstantName, MakeValue(- High(Shortint) - 1));
    InternalAddConstant(MaxShortintConstantName, MakeValue(High(Shortint)));
    InternalAddConstant(MinByteConstantName, MakeValue(0));
    InternalAddConstant(MaxByteConstantName, MakeValue(High(Byte)));
    InternalAddConstant(MinSmallintConstantName, MakeValue(- High(Smallint) - 1));
    InternalAddConstant(MaxSmallintConstantName, MakeValue(High(Smallint)));
    InternalAddConstant(MinWordConstantName, MakeValue(0));
    InternalAddConstant(MaxWordConstantName, MakeValue(High(Word)));
    InternalAddConstant(MinIntegerConstantName, MakeValue(- High(Integer) - 1));
    InternalAddConstant(MaxIntegerConstantName, MakeValue(High(Integer)));
    InternalAddConstant(MinLongwordConstantName, MakeValue(0));
    InternalAddConstant(MaxLongwordConstantName, MakeValue(High(Longword)));
    InternalAddConstant(MinInt64ConstantName, MakeValue(- High(Int64) - 1));
    InternalAddConstant(MaxInt64ConstantName, MakeValue(High(Int64)));
    InternalAddConstant(MinSingleConstantName, MakeValue(MinSingle));
    InternalAddConstant(MaxSingleConstantName, MakeValue(MaxSingle));
    InternalAddConstant(MinDoubleConstantName, MakeValue(MinDouble));
    InternalAddConstant(MaxDoubleConstantName, MakeValue(MaxDouble));
  finally
    EndUpdate;
  end;
end;

destructor TMathParser.Destroy;
begin
  FMathMethod.Free;
  inherited;
end;

initialization
  {$IFDEF DELPHI_XE}
  FormatSettings.DecimalSeparator := Dot;
  {$ELSE}
  DecimalSeparator := Dot;
  {$ENDIF}

end.
