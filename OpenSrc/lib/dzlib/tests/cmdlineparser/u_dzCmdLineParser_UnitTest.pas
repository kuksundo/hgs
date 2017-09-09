{: Unit tests for the TCmdLineParser and the state machine it uses.
   @author Thomas Mueller <http://www.dummzeuch.de> }
unit u_dzCmdLineParser_UnitTest;

interface

uses
  SysUtils,
  Classes,
  TestFramework,
  u_dzCmdLineParser;

type
  TEngineStateClass = TClass;
  TCharSet = set of Char;

type
  ITestEngineContext = interface(IEngineContext)['{1680AC62-C4AE-4EF9-9B6F-07779E4B6D87}']
    function GetOptionPart: string;
    function GetParamPart: string;
    function GetOption: string;
    function GetParam: string;
  end;

type
  TTestContext = class(TInterfacedObject, ITestEngineContext)
  private
    FInput: string;
    FReadIdx: integer;
    FOptionPart: string;
    FParamPart: string;
    FOption: string;
    FParam: string;
  public
    constructor Create(const _Input: string);
    function GetNextChar: char;
    procedure AddToOption(_c: char);
    procedure AddToParameter(_c: char);
    procedure HandleCmdLinePart;
    function GetOptionPart: string;
    function GetParamPart: string;
    function GetOption: string;
    function GetParam: string;
  end;

type
  TTestEngineState = class(TTestCase)
  private
    FState: IEngineState;
    FContext: ITestEngineContext;
  protected
    procedure testChar(_c: char; _ExpectedState: TClass; const _ExpectedOptionPart: string = '';
      const _ExpectedParamPart: string = ''; const _ExpectedOption: string = '';
      const _ExpectedParam: string = '');
  public
  published
    procedure testNUL; virtual;
  end;

  TTestEndState = class(TTestEngineState)
  published
    procedure testNUL; override;
  end;

  TTestSpaceState = class(TTestEngineState)
  private
  public
    procedure SetUp; override;
  published
    procedure testDash;
    procedure testParam;
    procedure testQuote;
    procedure testSpace;
    procedure testNUL; override;
  end;

  TTestParamState = class(TTestEndState)
  public
    procedure SetUp; override;
  published
    procedure testSpace;
    procedure testQuote;
  end;

  TTestQuotedParamState = class(TTestEngineState)
  public
    procedure SetUp; override;
  published
    procedure testNotQuote;
    procedure testQuote;
  end;

  TTestDashState = class(TTestEngineState)
  public
    procedure SetUp; override;
  published
    procedure testDash;
    procedure testAlphanumeric;
  end;

  TTestDoubleDashState = class(TTestEngineState)
  public
    procedure SetUp; override;
  published
    procedure testAlphanumeric;
  end;

  TTestShortOption = class(TTestEndState)
  public
    procedure SetUp; override;
  published
    procedure testSwitch;
    procedure testSpace;
  end;

  TTestShortSwitchState = class(TTestEndState)
  public
    procedure SetUp; override;
  published
    procedure testSpace;
  end;

  TTestShortParamState = class(TTestEndState)
  public
    procedure SetUp; override;
  published
    procedure testSpace;
    procedure testQuote;
    procedure testDash;
  end;

  TTestQuotedShortParamState = class(TTestEngineState)
  public
    procedure SetUp; override;
  published
    procedure testQuote;
  end;

  TTestLongOptionState = class(TTestEndState)
  public
    procedure SetUp; override;
  published
    procedure testEquals;
    procedure testSpace;
    procedure testError;
    procedure testInLongOption;
  end;

  TTestLongParamState = class(TTestEndState)
  public
    procedure SetUp; override;
  published
    procedure testQuote;
    procedure testSpace;
    procedure testInLongParam;
  end;

  TTestQuotedLongParamState = class(TTestEngineState)
  public
    procedure SetUp; override;
  published
    procedure testQuote;
    procedure testInQuotedLongParam;
  end;

  TTestCmdlineParser = class(TTestCase)
  private
    FOptions: TStrings;
    FParams: TStrings;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  end;

  TTestCmdLineParserParams = class(TTestCmdlineParser)
  published
    procedure testEmpty;
    procedure testOneParam;
    procedure testQuotedParam;
    procedure testQuotedParamWithSpace;
    procedure testEmbeddedQuote;
    procedure testEmbeddedQuotedString;
    procedure testEmbeddedUnquotedString;
    procedure testEmbeddedDoubleQuote;
    procedure testTwoParams;
    procedure testTwoParamsMultipleSpaces;
    procedure testTwoQuotedparams;
    procedure testTwoQuotedparamsWithSpace;
  end;

  TTestCmdLineParserSwitches = class(TTestCmdlineParser)
  published
    procedure testOneSwitch;
    procedure testTwoSwitches;
    procedure testQuotedSwitch;
  end;

  TTestCmdLineParserShortOptions = class(TTestCmdlineParser)
  published
    procedure testOneShortOption;
    procedure testTwoShortOptions;
    procedure testShortOptionParam;
    procedure testShortOptionQuotedParam;
    procedure testShortOptionParamEmbeddedQuote;
    procedure testShortOptionParamEmbeddedQuotedString;
    procedure testShortOptionParamEmbeddedDoubleQuote;
    procedure testTwoShortOptionParams;
    procedure testOptionWithDash;
  end;

  TTestCmdLineParserLongOptions = class(TTestCmdlineParser)
  published
    procedure testOneLongOption;
    procedure testTowLongOptions;
    procedure testLongOptionParam;
    procedure testLongOptionQuotedParam;
    procedure testTwoLongOptionParams;
  end;

  TTestCmdLineParserMixed = class(TTestCmdlineParser)
  published
    procedure testLongShortOptions;
    procedure testShortLongOptions;
    procedure testParamShortOptions;
    procedure testParamLongOptions;
    procedure testShortOptionParam;
    procedure testLongOptionParam;
    procedure testLongOptionParamParam;
  end;

  TTestCmdLineParserDuplicates = class(TTestCmdlineParser)
  published
    procedure testDuplicateLongOptions;
    procedure testDuplicateShortOptions;
    procedure testDuplicateOptionValues;
    procedure testDuplicateParams;
  end;

implementation

uses
  u_dzCmdLineParserStates;

{ TTestContext }

constructor TTestContext.Create(const _Input: string);
begin
  inherited Create;
  FInput := _Input;
  FReadIdx := 0;
end;

procedure TTestContext.AddToOption(_c: char);
begin
  FOptionPart := FOptionPart + _c;
end;

procedure TTestContext.AddToParameter(_c: char);
begin
  FParamPart := FParamPart + _c;
end;

function TTestContext.GetNextChar: char;
begin
  if FReadIdx >= Length(FInput) then
    Result := #0
  else begin
    Inc(FReadIdx);
    Result := FInput[FReadIdx];
  end;
end;

function TTestContext.GetOption: string;
begin
  Result := FOption;
end;

function TTestContext.GetOptionPart: string;
begin
  Result := FOptionPart;
end;

function TTestContext.GetParam: string;
begin
  Result := FParam;
end;

function TTestContext.GetParamPart: string;
begin
  Result := FParamPart;
end;

procedure TTestContext.HandleCmdLinePart;
begin
  if FOptionPart <> '' then
    FOption := FOptionPart + '=' + FParamPart
  else
    FParam := FParamPart;
  FOptionPart := '';
  FParamPart := '';
end;

{ TTestEngineState }

procedure TTestEngineState.testNUL;
begin
  testChar(#0, TEngineStateError);
end;

procedure TTestEngineState.testChar(_c: char; _ExpectedState: TClass; const _ExpectedOptionPart: string = '';
  const _ExpectedParamPart: string = ''; const _ExpectedOption: string = '';
  const _ExpectedParam: string = '');
var
  State: IEngineState;
  s: string;
begin
  s := _c;
  s := PChar(s);
  FContext := TTestContext.Create(s);
  State := FState.Execute(FContext);
  CheckNotNull(State, Format('unexpected nil result parsing "%s" (#%.2d)', [s, Ord(_c)]));
  CheckEquals(_ExpectedState.ClassName, State.GetClassName,
    Format('unexpected class parsing "%s" (#%.2d)', [s, Ord(_c)]));
  CheckEquals(#0, FContext.GetNextChar, 'state did not consume a char');
  CheckEquals(_ExpectedOptionPart, FContext.GetOptionPart, 'OptionPart');
  CheckEquals(_ExpectedParamPart, FContext.GetParamPart, 'ParamPart');
  CheckEquals(_ExpectedOption, FContext.GetOption, 'Option');
  CheckEquals(_ExpectedParam, FContext.GetParam, 'Param');
end;

{ TTestEndState }

procedure TTestEndState.testNUL;
begin
  testChar(#0, TEngineStateSpace);
end;

{ TTestSpaceState }

procedure TTestSpaceState.SetUp;
begin
  inherited;
  FState := TEngineStateSpace.Create;
end;

procedure TTestSpaceState.testDash;
begin
  testChar('-', TEngineStateDash);
end;

procedure TTestSpaceState.testNUL;
var
  State: IEngineState;
begin
  FContext := TTestContext.Create('');
  State := FState.Execute(FContext);
  CheckNull(State, 'end state expected');
  CheckEquals('', FContext.GetOptionPart, 'OptionPart not empty');
  CheckEquals('', FContext.GetParamPart, 'ParamPart not empty');
  CheckEquals('', FContext.GetOption, 'Option not empty');
  CheckEquals('', FContext.GetParam, 'Param not empty');
end;

procedure TTestSpaceState.testParam;
const
  CHARS_TO_TEST = ALLCHARS_BUT_NULL - ['-', '"', ' '];
var
  c: char;
begin
  for c in CHARS_TO_TEST do
    testChar(c, TEngineStateParam, '', c);
end;

procedure TTestSpaceState.testQuote;
begin
  testChar('"', TEngineStateQuotedParam, '', '"');
end;

procedure TTestSpaceState.testSpace;
begin
  testChar(' ', TEngineStateSpace);
end;

{ TTestParamState }

procedure TTestParamState.SetUp;
begin
  inherited;
  FState := TEngineStateParam.Create;
end;

procedure TTestParamState.testQuote;
begin
  testChar('"', TEngineStateQuotedParam, '', '"');
end;

procedure TTestParamState.testSpace;
begin
  testChar(' ', TEngineStateSpace);
end;

{ TTestQuotedParamState }

procedure TTestQuotedParamState.SetUp;
begin
  inherited;
  FState := TEngineStateQuotedParam.Create;
end;

procedure TTestQuotedParamState.testNotQuote;
const
  CHARS_TO_TEST = ALLCHARS_BUT_NULL - ['"'];
var
  c: char;
begin
  for c in CHARS_TO_TEST do
    testChar(c, TEngineStateQuotedParam, '', c);
end;

procedure TTestQuotedParamState.testQuote;
begin
  testChar('"', TEngineStateParam, '', '"');
end;

{ TTestDashState }

procedure TTestDashState.SetUp;
begin
  inherited;
  FState := TEngineStateDash.Create;
end;

procedure TTestDashState.testAlphanumeric;
const
  CHARS_TO_TEST = ALPHANUMERIC_CHARS;
var
  c: char;
begin
  for c in CHARS_TO_TEST do
    testChar(c, TEngineStateShortOption, c, '');
end;

procedure TTestDashState.testDash;
begin
  testChar('-', TEngineStateDoubleDash);
end;

{ TTestShortOption }

procedure TTestShortOption.SetUp;
begin
  inherited;
  FState := TEngineStateShortOption.Create;
end;

procedure TTestShortOption.testSpace;
begin
  testChar(' ', TEngineStateShortParam);
end;

procedure TTestShortOption.testSwitch;
begin
  testChar('-', TEngineStateShortSwitch, '', '-');
  testChar('+', TEngineStateShortSwitch, '', '+');
end;

{ TTestShortSwitch }

procedure TTestShortSwitchState.SetUp;
begin
  inherited;
  FState := TEngineStateShortSwitch.Create;
end;

procedure TTestShortSwitchState.testSpace;
begin
  testChar(' ', TEngineStateSpace);
end;

{ TTestShortParam }

procedure TTestShortParamState.SetUp;
begin
  inherited;
  FState := TEngineStateShortParam.Create;
end;

procedure TTestShortParamState.testDash;
begin
  testChar('-', TEngineStateDash);
end;

procedure TTestShortParamState.testQuote;
begin
  testChar('"', TEngineStateQuotedShortParam, '', '"');
end;

procedure TTestShortParamState.testSpace;
begin
  testChar(' ', TEngineStateSpace);
end;

{ TTestQuotedShortParam }

procedure TTestQuotedShortParamState.SetUp;
begin
  inherited;
  FState := TEngineStateQuotedShortParam.Create;
end;

procedure TTestQuotedShortParamState.testQuote;
begin
  testChar('"', TEngineStateShortParam, '', '"');
end;

{ TTestDoubleDashState }

procedure TTestDoubleDashState.SetUp;
begin
  inherited;
  FState := TEngineStateDoubleDash.Create;
end;

procedure TTestDoubleDashState.testAlphanumeric;
const
  CHARS_TO_TEST = ALPHANUMERIC_CHARS;
var
  c: char;
begin
  for c in CHARS_TO_TEST do
    testChar(c, TEngineStateLongOption, c);
end;

{ TTestLongOptionState }

procedure TTestLongOptionState.SetUp;
begin
  inherited;
  FState := TEngineStateLongOption.Create;
end;

procedure TTestLongOptionState.testEquals;
begin
  testChar('=', TEngineStateLongParam);
end;

procedure TTestLongOptionState.testError;
begin
  testChar('"', TEngineStateError);
  testChar('''', TEngineStateError);
end;

procedure TTestLongOptionState.testInLongOption;
const
  CHARS_TO_TEST = ALLCHARS_BUT_NULL - ['"', '''', ' ', '='];
var
  c: char;
begin
  for c in CHARS_TO_TEST do
    testChar(c, TEngineStateLongOption, c);
end;

procedure TTestLongOptionState.testSpace;
begin
  testChar(' ', TEngineStateSpace);
end;

{ TTestLongParamState }

procedure TTestLongParamState.SetUp;
begin
  inherited;
  FState := TEngineStateLongParam.Create;
end;

procedure TTestLongParamState.testInLongParam;
const
  CHARS_TO_TEST = ALLCHARS_BUT_NULL - [' ', '"'];
var
  c: char;
begin
  for c in CHARS_TO_TEST do
    testChar(c, TEngineStateLongParam, '', c);
end;

procedure TTestLongParamState.testQuote;
begin
  testChar('"', TEngineStateQuotedLongParam, '', '"');
end;

procedure TTestLongParamState.testSpace;
begin
  testChar(' ', TEngineStateSpace);
end;

{ TTestQuotedLongParamState }

procedure TTestQuotedLongParamState.SetUp;
begin
  inherited;
  FState := TEngineStateQuotedLongParam.Create;
end;

procedure TTestQuotedLongParamState.testInQuotedLongParam;
const
  CHARS_TO_TEST = ALLCHARS_BUT_NULL - ['"'];
var
  c: char;
begin
  for c in CHARS_TO_TEST do
    testChar(c, TEngineStateQuotedLongParam, '', c);
end;

procedure TTestQuotedLongParamState.testQuote;
begin
  testChar('"', TEngineStateLongParam, '', '"');
end;

{ TTestCmdlineParser }

procedure TTestCmdlineParser.SetUp;
begin
  inherited;
  FOptions := TStringList.Create;
  FParams := TStringList.Create;
end;

procedure TTestCmdlineParser.TearDown;
begin
  inherited;
  FParams.Free;
  FOptions.Free;
end;

{ TTestCmdLineParserParams }

procedure TTestCmdLineParserParams.testEmbeddedDoubleQuote;
begin
  TCmdLineParser.Execute('one""two', FOptions, FParams);
  CheckEquals(0, FOptions.Count);
  CheckEquals(1, FParams.Count);
  CheckEquals('one""two', FParams[0]);
end;

procedure TTestCmdLineParserParams.testEmbeddedQuote;
begin
  TCmdLineParser.Execute('one"two"', FOptions, FParams);
  CheckEquals(0, FOptions.Count);
  CheckEquals(1, FParams.Count);
  CheckEquals('one"two"', FParams[0]);
end;

procedure TTestCmdLineParserParams.testEmbeddedQuotedString;
begin
  TCmdLineParser.Execute('one"two"three', FOptions, FParams);
  CheckEquals(0, FOptions.Count);
  CheckEquals(1, FParams.Count);
  CheckEquals('one"two"three', FParams[0]);
end;

procedure TTestCmdLineParserParams.testEmbeddedUnquotedString;
begin
  TCmdLineParser.Execute('"one"two"three"', FOptions, FParams);
  CheckEquals(0, FOptions.Count);
  CheckEquals(1, FParams.Count);
  CheckEquals('"one"two"three"', FParams[0]);
end;

procedure TTestCmdLineParserParams.testEmpty;
begin
  TCmdLineParser.Execute('', FOptions, FParams);
  CheckEquals(0, FOptions.Count);
  CheckEquals(0, FParams.Count);
end;

procedure TTestCmdLineParserParams.testOneParam;
begin
  TCmdLineParser.Execute('one', FOptions, FParams);
  CheckEquals(0, FOptions.Count);
  CheckEquals(1, FParams.Count);
  CheckEquals('one', FParams[0]);
end;

procedure TTestCmdLineParserParams.testQuotedParam;
begin
  TCmdLineParser.Execute('"one"', FOptions, FParams);
  CheckEquals(0, FOptions.Count);
  CheckEquals(1, FParams.Count);
  CheckEquals('"one"', FParams[0]);
end;

procedure TTestCmdLineParserParams.testQuotedParamWithSpace;
begin
  TCmdLineParser.Execute('"one two"', FOptions, FParams);
  CheckEquals(0, FOptions.Count);
  CheckEquals(1, FParams.Count);
  CheckEquals('"one two"', FParams[0]);
end;

procedure TTestCmdLineParserParams.testTwoParams;
begin
  TCmdLineParser.Execute('one two', FOptions, FParams);
  CheckEquals(0, FOptions.Count);
  CheckEquals(2, FParams.Count);
  CheckEquals('one', FParams[0]);
  CheckEquals('two', FParams[1]);
end;

procedure TTestCmdLineParserParams.testTwoParamsMultipleSpaces;
begin
  TCmdLineParser.Execute('one    two', FOptions, FParams);
  CheckEquals(0, FOptions.Count);
  CheckEquals(2, FParams.Count);
  CheckEquals('one', FParams[0]);
  CheckEquals('two', FParams[1]);
end;

procedure TTestCmdLineParserParams.testTwoQuotedparams;
begin
  TCmdLineParser.Execute('"one" "two"', FOptions, FParams);
  CheckEquals(0, FOptions.Count);
  CheckEquals(2, FParams.Count);
  CheckEquals('"one"', FParams[0]);
  CheckEquals('"two"', FParams[1]);
end;

procedure TTestCmdLineParserParams.testTwoQuotedparamsWithSpace;
begin
  TCmdLineParser.Execute('"one" "two   three"', FOptions, FParams);
  CheckEquals(0, FOptions.Count);
  CheckEquals(2, FParams.Count);
  CheckEquals('"one"', FParams[0]);
  CheckEquals('"two   three"', FParams[1]);
end;

{ TTestCmdLineParserSwitches }

procedure TTestCmdLineParserSwitches.testOneSwitch;
begin
  TCmdLineParser.Execute('-a+', FOptions, FParams);
  CheckEquals(1, FOptions.Count);
  CheckEquals(0, FParams.Count);
  CheckEquals('a=+', FOptions[0]);
end;

procedure TTestCmdLineParserSwitches.testQuotedSwitch;
begin
  TCmdLineParser.Execute('"-a+"', FOptions, FParams);
  CheckEquals(0, FOptions.Count);
  CheckEquals(1, FParams.Count);
  CheckEquals('"-a+"', FParams[0]);
end;

procedure TTestCmdLineParserSwitches.testTwoSwitches;
begin
  TCmdLineParser.Execute('-a+ -b-', FOptions, FParams);
  CheckEquals(2, FOptions.Count);
  CheckEquals(0, FParams.Count);
  CheckEquals('a=+', FOptions[0]);
  CheckEquals('b=-', FOptions[1]);
end;

{ TTestCmdLineParserShortOptions }

procedure TTestCmdLineParserShortOptions.testOneShortOption;
begin
  TCmdLineParser.Execute('-a', FOptions, FParams);
  CheckEquals(1, FOptions.Count);
  CheckEquals(0, FParams.Count);
  CheckEquals('a=', FOptions[0]);
end;

procedure TTestCmdLineParserShortOptions.testOptionWithDash;
begin
  TCmdLineParser.Execute('--hallo-welt', FOptions, FParams);
  CheckEquals(1, FOptions.Count);
  CheckEquals(0, FParams.Count);
  CheckEquals('hallo-welt=', FOptions[0]);
end;

procedure TTestCmdLineParserShortOptions.testShortOptionParam;
begin
  TCmdLineParser.Execute('-a one', FOptions, FParams);
  CheckEquals(1, FOptions.Count);
  CheckEquals(0, FParams.Count);
  CheckEquals('a=one', FOptions[0]);
end;

procedure TTestCmdLineParserShortOptions.testShortOptionParamEmbeddedDoubleQuote;
begin
  TCmdLineParser.Execute('-a one""two', FOptions, FParams);
  CheckEquals(1, FOptions.Count);
  CheckEquals(0, FParams.Count);
  CheckEquals('a=one""two', FOptions[0]);
end;

procedure TTestCmdLineParserShortOptions.testShortOptionParamEmbeddedQuote;
begin
  TCmdLineParser.Execute('-a one"two"', FOptions, FParams);
  CheckEquals(1, FOptions.Count);
  CheckEquals(0, FParams.Count);
  CheckEquals('a=one"two"', FOptions[0]);
end;

procedure TTestCmdLineParserShortOptions.testShortOptionParamEmbeddedQuotedString;
begin
  TCmdLineParser.Execute('-a one"two"three', FOptions, FParams);
  CheckEquals(1, FOptions.Count);
  CheckEquals(0, FParams.Count);
  CheckEquals('a=one"two"three', FOptions[0]);
end;

procedure TTestCmdLineParserShortOptions.testShortOptionQuotedParam;
begin
  TCmdLineParser.Execute('-a "one"', FOptions, FParams);
  CheckEquals(1, FOptions.Count);
  CheckEquals(0, FParams.Count);
  CheckEquals('a="one"', FOptions[0]);
end;

procedure TTestCmdLineParserShortOptions.testTwoShortOptions;
begin
  TCmdLineParser.Execute('-a -b', FOptions, FParams);
  CheckEquals(2, FOptions.Count);
  CheckEquals(0, FParams.Count);
  CheckEquals('a=', FOptions[0]);
  CheckEquals('b=', FOptions[1]);
end;

procedure TTestCmdLineParserShortOptions.testTwoShortOptionParams;
begin
  TCmdLineParser.Execute('-a one -b "two three"', FOptions, FParams);
  CheckEquals(2, FOptions.Count);
  CheckEquals(0, FParams.Count);
  CheckEquals('a=one', FOptions[0]);
  CheckEquals('b="two three"', FOptions[1]);
end;

{ TTestCmdLineParserLongOptions }

procedure TTestCmdLineParserLongOptions.testLongOptionParam;
begin
  TCmdLineParser.Execute('--one=two', FOptions, FParams);
  CheckEquals(1, FOptions.Count);
  CheckEquals(0, FParams.Count);
  CheckEquals('one=two', FOptions[0]);
end;

procedure TTestCmdLineParserLongOptions.testLongOptionQuotedParam;
begin
  TCmdLineParser.Execute('--one="two"', FOptions, FParams);
  CheckEquals(1, FOptions.Count);
  CheckEquals(0, FParams.Count);
  CheckEquals('one="two"', FOptions[0]);
end;

procedure TTestCmdLineParserLongOptions.testOneLongOption;
begin
  TCmdLineParser.Execute('--one', FOptions, FParams);
  CheckEquals(1, FOptions.Count);
  CheckEquals(0, FParams.Count);
  CheckEquals('one=', FOptions[0]);
end;

procedure TTestCmdLineParserLongOptions.testTowLongOptions;
begin
  TCmdLineParser.Execute('--one --two', FOptions, FParams);
  CheckEquals(2, FOptions.Count);
  CheckEquals(0, FParams.Count);
  CheckEquals('one=', FOptions[0]);
  CheckEquals('two=', FOptions[1]);
end;

procedure TTestCmdLineParserLongOptions.testTwoLongOptionParams;
begin
  TCmdLineParser.Execute('--one=two     --three=four', FOptions, FParams);
  CheckEquals(2, FOptions.Count);
  CheckEquals(0, FParams.Count);
  CheckEquals('one=two', FOptions[0]);
  CheckEquals('three=four', FOptions[1]);
end;

{ TTestCmdLineParserMixed }

procedure TTestCmdLineParserMixed.testLongOptionParam;
begin
  TCmdLineParser.Execute('--one two', FOptions, FParams);
  CheckEquals(1, FOptions.Count);
  CheckEquals(1, FParams.Count);
  CheckEquals('one=', FOptions[0]);
  CheckEquals('two', FParams[0]);
end;

procedure TTestCmdLineParserMixed.testLongOptionParamParam;
begin
  TCmdLineParser.Execute('--one=two three', FOptions, FParams);
  CheckEquals(1, FOptions.Count);
  CheckEquals(1, FParams.Count);
  CheckEquals('one=two', FOptions[0]);
  CheckEquals('three', FParams[0]);
end;

procedure TTestCmdLineParserMixed.testLongShortOptions;
begin
  TCmdLineParser.Execute('--one -a', FOptions, FParams);
  CheckEquals(2, FOptions.Count);
  CheckEquals(0, FParams.Count);
  CheckEquals('one=', FOptions[0]);
  CheckEquals('a=', FOptions[1]);
end;

procedure TTestCmdLineParserMixed.testParamLongOptions;
begin
  TCmdLineParser.Execute('one --two', FOptions, FParams);
  CheckEquals(1, FOptions.Count);
  CheckEquals(1, FParams.Count);
  CheckEquals('two=', FOptions[0]);
  CheckEquals('one', FParams[0]);
end;

procedure TTestCmdLineParserMixed.testParamShortOptions;
begin
  TCmdLineParser.Execute('one -a', FOptions, FParams);
  CheckEquals(1, FOptions.Count);
  CheckEquals(1, FParams.Count);
  CheckEquals('a=', FOptions[0]);
  CheckEquals('one', FParams[0]);
end;

procedure TTestCmdLineParserMixed.testShortLongOptions;
begin
  TCmdLineParser.Execute('-a --one', FOptions, FParams);
  CheckEquals(2, FOptions.Count);
  CheckEquals(0, FParams.Count);
  CheckEquals('a=', FOptions[0]);
  CheckEquals('one=', FOptions[1]);
end;

procedure TTestCmdLineParserMixed.testShortOptionParam;
begin
  TCmdLineParser.Execute('-a one two', FOptions, FParams);
  CheckEquals(1, FOptions.Count);
  CheckEquals(1, FParams.Count);
  CheckEquals('a=one', FOptions[0]);
  CheckEquals('two', FParams[0]);
end;

{ TTestCmdLineParserDuplicates }

procedure TTestCmdLineParserDuplicates.testDuplicateLongOptions;
begin
  TCmdLineParser.Execute('--one=two --one=three', FOptions, FParams);
  CheckEquals(2, FOptions.Count);
  CheckEquals(0, FParams.Count);
  CheckEquals('one=two', FOptions[0]);
  CheckEquals('one=three', FOptions[1]);
end;

procedure TTestCmdLineParserDuplicates.testDuplicateOptionValues;
begin
  TCmdLineParser.Execute('-a two -a three', FOptions, FParams);
  CheckEquals(2, FOptions.Count);
  CheckEquals(0, FParams.Count);
  CheckEquals('a=two', FOptions[0]);
  CheckEquals('a=three', FOptions[1]);
end;

procedure TTestCmdLineParserDuplicates.testDuplicateParams;
begin
  TCmdLineParser.Execute('one one one', FOptions, FParams);
  CheckEquals(0, FOptions.Count);
  CheckEquals(3, FParams.Count);
  CheckEquals('one', FParams[0]);
  CheckEquals('one', FParams[1]);
  CheckEquals('one', FParams[2]);
end;

procedure TTestCmdLineParserDuplicates.testDuplicateShortOptions;
begin
  TCmdLineParser.Execute('-a -a -a -a', FOptions, FParams);
  CheckEquals(4, FOptions.Count);
  CheckEquals(0, FParams.Count);
  CheckEquals('a=', FOptions[0]);
  CheckEquals('a=', FOptions[1]);
  CheckEquals('a=', FOptions[2]);
  CheckEquals('a=', FOptions[3]);
end;

initialization
  RegisterTest('states', TTestSpaceState.Suite);
  RegisterTest('states', TTestParamState.Suite);
  RegisterTest('states', TTestQuotedParamState.Suite);
  RegisterTest('states', TTestDashState.Suite);
  RegisterTest('states', TTestShortOption.Suite);
  RegisterTest('states', TTestShortSwitchState.Suite);
  RegisterTest('states', TTestShortParamState.Suite);
  RegisterTest('states', TTestQuotedShortParamState.Suite);
  RegisterTest('states', TTestDoubleDashState.Suite);
  RegisterTest('states', TTestLongOptionState.Suite);
  RegisterTest('states', TTestLongParamState.Suite);
  RegisterTest('states', TTestQuotedLongParamState.Suite);
  RegisterTest('parser', TTestCmdLineParserParams.Suite);
  RegisterTest('parser', TTestCmdLineParserSwitches.Suite);
  RegisterTest('parser', TTestCmdLineParserShortOptions.Suite);
  RegisterTest('parser', TTestCmdLineParserLongOptions.Suite);
  RegisterTest('parser', TTestCmdLineParserMixed.Suite);
  RegisterTest('parser', TTestCmdLineParserDuplicates.Suite);
end.

