{: Unit tests for the TGetOpt.
   @author Thomas Mueller <http://www.dummzeuch.de> }
unit u_dzGetOpt_UnitTest;

interface

uses
  TestFramework,
  u_dzGetOpt,
  u_dzParamDescList,
  u_dzOptionFoundList,
  u_dzOptionDescList,
  Classes,
  u_dzParamFoundList,
  SysUtils,
  u_dzOptionNameList;

type
  TGetOptTest = class(TTestCase)
  protected
    FGetOpt: TGetOpt;
    procedure ParseNone;
    procedure ParseOne;
    procedure ParseTwo;
    procedure ParseThree;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  end;

type
  TUnknownParamTest = class(TGetOptTest)
  published
    procedure testNoParamRegistered;
    procedure testUnregisteredParam;
    procedure testWindowsCmdLine;
  end;

type
  TSingleParamTest = class(TGetOptTest)
  public
  published
    procedure testParamGiven;
    procedure testTwoParams;
  end;

type
  TSingleRequiredParamTest = class(TSingleParamTest)
  public
    procedure SetUp; override;
  published
    procedure testParamMissing;
  end;

type
  TSingleOptionalParamTest = class(TSingleParamTest)
  public
    procedure SetUp; override;
  published
    procedure testParamMissing;
  end;

type
  TSingleParamMultipleTest = class(TGetOptTest)
  private
  public
    procedure SetUp; override;
  published
    procedure testParamMissing;
    procedure testOneParam;
    procedure testTwoParams;
    procedure testThreeParams;
  end;

type
  TTwoParamsTest = class(TGetOptTest)
  published
    procedure testTwoParams;
    procedure testThreeParams;
  end;

type
  TTwoRequiredParamsTest = class(TTwoParamsTest)
  public
    procedure SetUp; override;
  published
    procedure testAllParamsMissing;
    procedure testOneParam;
  end;

type
  TTwoOptionalParamsTest = class(TTwoParamsTest)
  public
    procedure SetUp; override;
  published
    procedure testAllParamsMissing;
    procedure testOneParam;
  end;

type
  TRequiredAndOptionalParamTest = class(TTwoParamsTest)
  public
    procedure SetUp; override;
  published
    procedure testAllParamsMissing;
    procedure testOneParam;
  end;

type
  TOneParamRequiredTwice = class(TGetOptTest)
  public
    procedure SetUp; override;
  published
    procedure testAllParamsMissing;
    procedure testOneParam;
    procedure testTwoParams;
    procedure testThreeParams;
  end;

type
  TRegisterOptionTest = class(TGetOptTest)
  private
    FInvalidChar: char;
    procedure RegisterEmpty;
    procedure RegisterHallo;
    procedure RegisterHalloHallo;
    procedure RegisterWithChar;
    procedure RegisterStartChar;
  published
    procedure testDuplicateOption;
    procedure testDuplicateName;
    procedure testDuplicateSecondaryName;
    procedure testRegisterInvalidOptionNames;
  end;

type
  TOneOptionTest = class(TGetOptTest)
  private
    procedure GetUnknownOption;
  public
    procedure SetUp; override;
  published
    procedure testNotGiven;
    procedure testGivenOnce;
    procedure testGivenTwice;
    procedure testGivenThrice;
    procedure testUnkownOption;
  end;

implementation

{ TGetOptTest }

procedure TGetOptTest.SetUp;
begin
  inherited;
  FGetOpt := TGetOpt.Create;
end;

procedure TGetOptTest.TearDown;
begin
  FGetOpt.Free;
  inherited;
end;

procedure TGetOptTest.ParseNone;
begin
  FGetOpt.Parse('');
end;

procedure TGetOptTest.ParseTwo;
begin
  FGetOpt.Parse('one two');
end;

procedure TGetOptTest.ParseOne;
begin
  FGetOpt.Parse('one');
end;

procedure TGetOptTest.ParseThree;
begin
  FGetOpt.Parse('one two three');
end;

{ TUnknownParamTest }

procedure TUnknownParamTest.testNoParamRegistered;
var
  s: string;
begin
  CheckFalse(FGetOpt.ParamPassed('hallo', s), 'result of ParamPassed(hallo)');
  CheckEquals(0, FGetOpt.ParamPassed('hallo', nil), 'result of ParamPassed(hallo)');
end;

procedure TUnknownParamTest.testUnregisteredParam;
var
  s: string;
begin
  FGetOpt.RegisterParam('welt', 'welt');
  CheckFalse(FGetOpt.ParamPassed('hallo', s), 'result of ParamPassed(hallo)');
  CheckEquals(0, FGetOpt.ParamPassed('hallo', nil), 'result of ParamPassed(hallo)');
end;

procedure TUnknownParamTest.testWindowsCmdLine;
begin
  FGetOpt.Parse;
end;

{ TSingleParamTest }

procedure TSingleParamTest.testParamGiven;
var
  s: string;
begin
  FGetOpt.Parse('one');
  CheckTrue(FGetOpt.ParamPassed('hallo', s), 'result of ParamFound');
  CheckEquals('one', s, 'value of param');
  CheckEquals(1, FGetOpt.ParamPassed('hallo', nil), 'result of ParamFound');
end;

procedure TSingleParamTest.testTwoParams;
begin
  CheckException(ParseTwo, ETooManyParams);
end;

{ TSingleRequiredParamTest }

procedure TSingleRequiredParamTest.SetUp;
begin
  inherited;
  FGetOpt.RegisterParam('hallo', 'hallo', 1, 1);
end;

procedure TSingleRequiredParamTest.testParamMissing;
begin
  CheckException(ParseNone, ETooFewParams);
end;

{ TSingleOptionalParamTest }

procedure TSingleOptionalParamTest.SetUp;
begin
  inherited;
  FGetOpt.RegisterParam('hallo', 'hallo', 0, 1);
end;

procedure TSingleOptionalParamTest.testParamMissing;
var
  s: string;
begin
  FGetOpt.Parse('');
  CheckFalse(FGetOpt.ParamPassed('hallo', s), 'result of ParamFound');
  CheckEquals(0, FGetOpt.ParamPassed('hallo', nil), 'result of ParamFound');
end;

{ TSingleParamMultipleTest }

procedure TSingleParamMultipleTest.SetUp;
begin
  inherited;
  FGetOpt.RegisterParam('hallo', 'hallo', 1, 2);
end;

procedure TSingleParamMultipleTest.testOneParam;
var
  s: string;
begin
  FGetOpt.Parse('one');
  CheckTrue(FGetOpt.ParamPassed('hallo', s), 'result of ParamFound');
  CheckEquals('one', s, 'value of param');
  CheckEquals(1, FGetOpt.ParamPassed('hallo', nil), 'result of ParamFound');
end;

procedure TSingleParamMultipleTest.testParamMissing;
begin
  CheckException(ParseNone, ETooFewParams);
end;

procedure TSingleParamMultipleTest.testThreeParams;
begin
  CheckException(ParseThree, ETooManyParams);
end;

procedure TSingleParamMultipleTest.testTwoParams;
var
  s: string;
  sl: TStringList;
begin
  FGetOpt.Parse('one two');
  CheckFalse(FGetOpt.ParamPassed('hallo', s), 'result of ParamFound');
  sl := TStringList.Create;
  try
    CheckEquals(2, FGetOpt.ParamPassed('hallo', sl), 'result of ParamFound');
    CheckEquals(2, sl.Count, 'string list count');
    CheckEquals('one', sl[0], 'param one');
    CheckEquals('two', sl[1], 'param two');
  finally
    sl.Free;
  end;
end;

{ TTwoParamsTest }

procedure TTwoParamsTest.testThreeParams;
begin
  CheckException(ParseThree, ETooManyParams);
end;

procedure TTwoParamsTest.testTwoParams;
var
  s: string;
begin
  ParseTwo;
  CheckTrue(FGetOpt.ParamPassed('hallo', s), 'result of ParamFound(hallo)');
  CheckEquals('one', s, 'value of param hallo');
  CheckTrue(FGetOpt.ParamPassed('welt', s), 'result of ParamFound(welt)');
  CheckEquals('two', s, 'value of param welt');
end;

{ TTwoRequiredParamsTest }

procedure TTwoRequiredParamsTest.SetUp;
begin
  inherited;
  FGetOpt.RegisterParam('hallo', 'hallo');
  FGetOpt.RegisterParam('welt', 'welt');
end;

procedure TTwoRequiredParamsTest.testAllParamsMissing;
begin
  CheckException(ParseNone, ETooFewParams);
end;

procedure TTwoRequiredParamsTest.testOneParam;
begin
  CheckException(ParseOne, ETooFewParams);
end;

{ TTwoOptionalParamsTest }

procedure TTwoOptionalParamsTest.SetUp;
begin
  inherited;
  FGetOpt.RegisterParam('hallo', 'hallo', 0, 1);
  FGetOpt.RegisterParam('welt', 'welt', 0, 1);
end;

procedure TTwoOptionalParamsTest.testAllParamsMissing;
var
  s: string;
begin
  ParseNone;
  CheckFalse(FGetOpt.ParamPassed('hallo', s), 'result of ParamFound(hallo)');
  CheckEquals(0, FGetOpt.ParamPassed('hallo', nil), 'result of ParamFound(hallo)');
  CheckFalse(FGetOpt.ParamPassed('welt', s), 'result of ParamFound(welt)');
  CheckEquals(0, FGetOpt.ParamPassed('welt', nil), 'result of ParamFound(welt)');
end;

procedure TTwoOptionalParamsTest.testOneParam;
var
  s: string;
begin
  ParseOne;
  CheckTrue(FGetOpt.ParamPassed('hallo', s), 'result of ParamFound(hallo)');
  CheckEquals('one', s, 'value of param hallo');
  CheckFalse(FGetOpt.ParamPassed('welt', s), 'result of ParamFound(welt)');
end;

{ TRequiredAndOptionalParamTest }

procedure TRequiredAndOptionalParamTest.SetUp;
begin
  inherited;
  FGetOpt.RegisterParam('hallo', 'hallo');
  FGetOpt.RegisterParam('welt', 'welt', 0, 1);
end;

procedure TRequiredAndOptionalParamTest.testAllParamsMissing;
begin
  CheckException(ParseNone, ETooFewParams);
end;

procedure TRequiredAndOptionalParamTest.testOneParam;
var
  s: string;
begin
  ParseOne;
  CheckTrue(FGetOpt.ParamPassed('hallo', s), 'result of ParamFound(hallo)');
  CheckEquals('one', s, 'value of param hallo');
  CheckFalse(FGetOpt.ParamPassed('welt', s), 'result of ParamFound(welt)');
end;

{ TOneParamRequiredTwice }

procedure TOneParamRequiredTwice.SetUp;
begin
  inherited;
  FGetOpt.RegisterParam('hallo', 'hallo', 2, 2);
end;

procedure TOneParamRequiredTwice.testAllParamsMissing;
begin
  CheckException(ParseNone, ETooFewParams);
end;

procedure TOneParamRequiredTwice.testOneParam;
begin
  CheckException(ParseOne, ETooFewParams);
end;

procedure TOneParamRequiredTwice.testThreeParams;
begin
  CheckException(ParseThree, ETooManyParams);
end;

procedure TOneParamRequiredTwice.testTwoParams;
var
  s: string;
  sl: TStringList;
begin
  ParseTwo;
  CheckFalse(FGetOpt.ParamPassed('hallo', s), 'result of ParamFound(hallo)');
  sl := TStringList.Create;
  try
    CheckEquals(2, FGetOpt.ParamPassed('hallo', sl), 'result of ParamFound(hallo)');
    CheckEquals('one', sl[0], '1st value of param hallo');
    CheckEquals('two', sl[1], '2nd value of param hallo');
  finally
    sl.Free;
  end;
end;

{ TRegisterOptionTest }

procedure TRegisterOptionTest.RegisterEmpty;
begin
  FGetOpt.RegisterOption('', 'hallo');
end;

procedure TRegisterOptionTest.RegisterHallo;
begin
  FGetOpt.RegisterOption('hallo', 'hallo');
end;

procedure TRegisterOptionTest.RegisterHalloHallo;
begin
  FGetOpt.RegisterOption(['hallo', 'hallo'], 'hallo');
end;

procedure TRegisterOptionTest.RegisterStartChar;
begin
  FGetOpt.RegisterOption(FInvalidChar + 'hallo', 'hallo');
end;

procedure TRegisterOptionTest.RegisterWithChar;
begin
  FGetOpt.RegisterOption('hallo' + FInvalidChar + 'welt', 'hallo welt');
end;

procedure TRegisterOptionTest.testDuplicateName;
begin
  CheckException(RegisterHalloHallo, EListError);
end;

procedure TRegisterOptionTest.testDuplicateOption;
begin
  RegisterHallo;
  CheckException(RegisterHallo, EListError);
end;

procedure TRegisterOptionTest.testDuplicateSecondaryName;
begin
  FGetOpt.RegisterOption(['welt', 'hallo'], 'hallo welt');
  CheckException(RegisterHallo, EListError);
end;

procedure TRegisterOptionTest.testRegisterInvalidOptionNames;
begin
  CheckException(RegisterEmpty, EOptionName);

  FInvalidChar := ' ';
  CheckException(RegisterWithChar, EOptionName);
  CheckException(RegisterStartChar, EOptionName);

  FInvalidChar := '+';
  CheckException(RegisterWithChar, EOptionName);
  CheckException(RegisterStartChar, EOptionName);

  FInvalidChar := #10;
  CheckException(RegisterWithChar, EOptionName);
  CheckException(RegisterStartChar, EOptionName);

  FInvalidChar := '-';
  RegisterWithChar;
  CheckException(RegisterStartChar, EOptionName);

  FInvalidChar := '_';
  RegisterWithChar;
  CheckException(RegisterStartChar, EOptionName);
end;

{ TOneOptionTest }

procedure TOneOptionTest.GetUnknownOption;
begin
  CheckEquals(0, FGetOpt.OptionPassed('welt', nil), 'result of OptionPassed(welt)');
end;

procedure TOneOptionTest.SetUp;
begin
  inherited;
  FGetOpt.RegisterOption('hallo', 'hallo');
end;

procedure TOneOptionTest.testGivenOnce;
var
  s: string;
  sl: TStringList;
begin
  FGetOpt.Parse('--hallo');
  CheckTrue(FGetOpt.OptionPassed('hallo'), 'OptionPassed(hallo):bool');
  CheckTrue(FGetOpt.OptionPassed('hallo', s), 'OptionPassed(hallo):bool');
  CheckEquals('', s, 'Value for option');
  CheckEquals(1, FGetOpt.OptionPassed('hallo', nil), 'OptionPassed(hallo):bool');
  sl := TStringList.Create;
  try
    CheckEquals(1, FGetOpt.OptionPassed('hallo', sl), 'OptionPassed(hallo):bool');
    CheckEquals(1, sl.Count, 'sl.count');
    CheckEquals('', sl[0], 'Value for option');
  finally
    sl.Free;
  end;
end;

procedure TOneOptionTest.testGivenThrice;
var
  s: string;
  sl: TStringList;
begin
  FGetOpt.Parse('--hallo --hallo --hallo');
  CheckFalse(FGetOpt.OptionPassed('hallo'), 'OptionPassed(hallo):bool');
  CheckFalse(FGetOpt.OptionPassed('hallo', s), 'OptionPassed(hallo):bool');
  CheckEquals(3, FGetOpt.OptionPassed('hallo', nil), 'OptionPassed(hallo):bool');
  sl := TStringList.Create;
  try
    CheckEquals(3, FGetOpt.OptionPassed('hallo', sl), 'OptionPassed(hallo):bool');
    CheckEquals(3, sl.Count, 'sl.count');
    CheckEquals('', sl[0], 'Value for option');
    CheckEquals('', sl[1], 'Value for option');
    CheckEquals('', sl[2], 'Value for option');
  finally
    sl.Free;
  end;
end;

procedure TOneOptionTest.testGivenTwice;
var
  s: string;
  sl: TStringList;
begin
  FGetOpt.Parse('--hallo --hallo');
  CheckFalse(FGetOpt.OptionPassed('hallo'), 'OptionPassed(hallo):bool');
  CheckFalse(FGetOpt.OptionPassed('hallo', s), 'OptionPassed(hallo):bool');
  CheckEquals(2, FGetOpt.OptionPassed('hallo', nil), 'OptionPassed(hallo):bool');
  sl := TStringList.Create;
  try
    CheckEquals(2, FGetOpt.OptionPassed('hallo', sl), 'OptionPassed(hallo):bool');
    CheckEquals(2, sl.Count, 'sl.count');
    CheckEquals('', sl[0], 'Value for option');
    CheckEquals('', sl[1], 'Value for option');
  finally
    sl.Free;
  end;
end;

procedure TOneOptionTest.testNotGiven;
begin
  ParseNone;
  CheckFalse(FGetOpt.OptionPassed('hallo'), 'OptionPassed(hallo):bool')
end;

procedure TOneOptionTest.testUnkownOption;
begin
  ParseNone;
  CheckException(GetUnknownOption, EUnknownOption);
end;

initialization
  RegisterTest('getopt', TUnknownParamTest.Suite);
  // do NOT register TSingleParamTest!
  RegisterTest('getopt', TSingleRequiredParamTest.Suite);
  RegisterTest('getopt', TSingleOptionalParamTest.Suite);
  RegisterTest('getopt', TSingleParamMultipleTest.Suite);
  RegisterTest('getopt', TTwoRequiredParamsTest.Suite);
  RegisterTest('getopt', TTwoOptionalParamsTest.Suite);
  RegisterTest('getopt', TRequiredAndOptionalParamTest.Suite);
  RegisterTest('getopt', TOneParamRequiredTwice.Suite);
  RegisterTest('getopt', TRegisterOptionTest.Suite);
  RegisterTest('getopt', TOneOptionTest.Suite);
end.

