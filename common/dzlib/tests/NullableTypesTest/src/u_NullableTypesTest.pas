unit u_NullableTypesTest;

interface

uses
  TestFramework,
  u_dzUnitTestUtils,
  u_dzNullableInteger,
  u_dzNullableInt64,
  u_dzNullableSingle,
  u_dzNullableDouble,
  u_dzNullableExtended;

type
  TestTNullableTypes = class(TdzTestCase)
  public
  published
    procedure TestNullableInteger;
    procedure TestNullableInt64;
    procedure TestNullableSingle;
    procedure TestNullableExtended;
  end;

  TestNullableDouble = class(TdzTestCase)
  private
    One: TNullableDouble;
    Two: TNullableDouble;
    Res: TNullableDouble;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestAssign;
    procedure TestAdd;
    procedure TestSubtract;
    procedure TestMultiply;
    procedure TestDivide;
    procedure TestIncDec;
  end;

implementation

uses
  SysUtils;

{ TestTNullableTypes }

//procedure TestTNullableTypes.TestNullableDate;
//var
//  dt: TDateTime;
//  One, Two: TNullableDate;
//begin
//  dt := Date;
//  CheckFalse(One.IsValid, 'Variable One should be invalid');
//  One := dt;
//  CheckTrue(One.IsValid, 'Variable One should be valid');
//  CheckEqualsDate(dt, One);
//  CheckFalse(Two.IsValid, 'Variable two should be invalid');
//  Two := One;
//  CheckTrue(Two.IsValid, 'Variable two should be valid');
//  CheckEqualsDate(dt, Two);
//end;

procedure TestTNullableTypes.TestNullableInteger;
var
  One, Two: TNullableInteger;
begin
  CheckFalse(One.IsValid, 'Variable One should be invalid');
  One := 1;
  CheckTrue(One.IsValid, 'Variable One should be valid');
  CheckEquals(1, One);
  CheckFalse(Two.IsValid, 'Variable two should be invalid');
  Two := One;
  CheckTrue(Two.IsValid, 'Variable two should be valid');
  CheckEquals(1, Two);
  Two := One + 1;
  CheckTrue(Two.IsValid, 'Variable two should be valid');
  CheckEquals(2, Two);
  Two.Invalidate;
  CheckFalse(Two.IsValid, 'Variable two should be invalid again');
end;

procedure TestTNullableTypes.TestNullableInt64;
var
  One, Two: TNullableInt64;
begin
  CheckFalse(One.IsValid, 'Variable One should be invalid');
  One := 1;
  CheckTrue(One.IsValid, 'Variable One should be valid');
  CheckEquals(1, One);
  CheckFalse(Two.IsValid, 'Variable two should be invalid');
  Two := One;
  CheckTrue(Two.IsValid, 'Variable two should be valid');
  CheckEquals(1, Two);
  Two := One + 1;
  CheckTrue(Two.IsValid, 'Variable two should be valid');
  CheckEquals(2, Two);
  Two.Invalidate;
  CheckFalse(Two.IsValid, 'Variable two should be invalid again');
end;

procedure TestTNullableTypes.TestNullableSingle;
var
  s: single;
  One: TNullableSingle;
  Two: TNullableSingle;
  Res: TNullableSingle;
begin
  CheckFalse(One.IsValid, 'Variable One should be invalid');

  One := 1;
  CheckTrue(One.IsValid, 'Variable One should be valid');
  CheckEquals(1, One);

  CheckFalse(Two.IsValid, 'Variable Two should be invalid');
  Two := 2;
  CheckTrue(Two.IsValid, 'Variable Two should be valid');
  CheckEquals(2, Two);

  Res := One;
  CheckTrue(Res.IsValid, 'Variable Res should be valid');
  CheckEquals(1, Res);

  Res := One + 1;
  CheckEquals(2, Res);

  Res := 1 + One;
  CheckEquals(2, Res);

  Res := One - 1;
  CheckEquals(0, Res);

  Res := 1 - One;
  CheckEquals(0, Res);

  Res := One + Two;
  CheckEquals(3, Res);

  Res := Two - One;
  CheckEquals(1, Res);

  Res := One * 2;
  CheckEquals(2, Res);

  Res := 2 * One;
  CheckEquals(2, Res);

  Res := Two * One;
  CheckEquals(2, Res);

  Res := -One;
  CheckEquals(-1, Res);

  Res := +Two;
  CheckEquals(2, Res);

  Res := Two;
  Inc(Res);
  CheckEquals(3, Res);

  Res := Two;
  Inc(Res, 2);
  CheckEquals(4, Res);

  Res := Two;
  Dec(Res);
  CheckEquals(1, Res);

  Res := Two;
  Dec(Res, 2);
  CheckEquals(0, Res);

  Res := 1.1;
  Inc(Res);
  s := 1.1 + 1;
  CheckEquals(s, Res);

  Res := 1.1;
  Dec(Res);
  s := 1.1 - 1;
  CheckEquals(s, Res);

  Res.Invalidate;
  CheckFalse(Res.IsValid, 'Variable Res should be invalid again');
end;

procedure TestTNullableTypes.TestNullableExtended;
var
  One: TNullableExtended;
  Two: TNullableExtended;
  Res: TNullableExtended;
begin
  CheckFalse(One.IsValid, 'Variable One should be invalid');

  One := 1;
  CheckTrue(One.IsValid, 'Variable One should be valid');
  CheckEquals(1, One);

  CheckFalse(Two.IsValid, 'Variable Two should be invalid');
  Two := 2;
  CheckTrue(Two.IsValid, 'Variable Two should be valid');
  CheckEquals(2, Two);

  Res := One;
  CheckTrue(Res.IsValid, 'Variable Res should be valid');
  CheckEquals(1, Res);

  Res := One + 1;
  CheckEquals(2, Res);

  Res := 1 + One;
  CheckEquals(2, Res);

  Res := One - 1;
  CheckEquals(0, Res);

  Res := 1 - One;
  CheckEquals(0, Res);

  Res := One + Two;
  CheckEquals(3, Res);

  Res := Two - One;
  CheckEquals(1, Res);

  Res := One * 2;
  CheckEquals(2, Res);

  Res := 2 * One;
  CheckEquals(2, Res);

  Res := Two * One;
  CheckEquals(2, Res);

  Res := -One;
  CheckEquals(-1, Res);

  Res := +Two;
  CheckEquals(2, Res);

  Res := Two;
  Inc(Res);
  CheckEquals(3, Res);

  Res := Two;
  Inc(Res, 2);
  CheckEquals(4, Res);

  Res := Two;
  Dec(Res);
  CheckEquals(1, Res);

  Res := Two;
  Dec(Res, 2);
  CheckEquals(0, Res);

  Res := 1.1;
  Inc(Res);
  CheckEquals(2.1, Res);

  Res := 1.1;
  Dec(Res);
  CheckEquals(0.1, Res);

  Res.Invalidate;
  CheckFalse(Res.IsValid, 'Variable Res should be invalid again');
end;

{ TestNullableDouble }

procedure TestNullableDouble.Setup;
begin
  inherited;
  One := 1;
  Two := 2;
  Res.Invalidate;
end;

procedure TestNullableDouble.TearDown;
begin
  inherited;
  One.Invalidate;
  Two.Invalidate;
  Res.Invalidate;
end;

procedure TestNullableDouble.TestAssign;
begin
  CheckTrue(One.IsValid, 'Variable One should be valid');
  CheckEquals(1, One);

  CheckTrue(Two.IsValid, 'Variable Two should be valid');
  CheckEquals(2, Two);

  CheckFalse(Res.IsValid, 'Variable One should be invalid');

  Res := One;
  CheckTrue(Res.IsValid, 'Variable Res should be valid');
  CheckEquals(1, Res);

  Res := Two;
  CheckTrue(Res.IsValid, 'Variable Res should be valid');
  CheckEquals(2, Res);

  Res := -One;
  CheckEquals(-1, Res);

  Res := +Two;
  CheckEquals(2, Res);

  Res.Invalidate;
  CheckFalse(Res.IsValid, 'Variable One should be invalid again');
end;

procedure TestNullableDouble.TestAdd;
begin
  Res := One + 1;
  CheckEquals(2, Res);

  Res := 1 + One;
  CheckEquals(2, Res);

  Res := One + Two;
  CheckEquals(3, Res);
end;

procedure TestNullableDouble.TestSubtract;
begin
  Res := One - 1;
  CheckEquals(0, Res);

  Res := 1 - One;
  CheckEquals(0, Res);

  Res := Two - One;
  CheckEquals(1, Res);
end;

procedure TestNullableDouble.TestMultiply;
begin
  Res := One * 2;
  CheckEquals(2, Res);

  Res := 2 * One;
  CheckEquals(2, Res);

  Res := Two * One;
  CheckEquals(2, Res);

end;

procedure TestNullableDouble.TestDivide;
begin
  Res := Two / 1;
  CheckEquals(2, Res);

  Res := One / 2;
  CheckEquals(0.5, Res);

  Res := One / Two;
  CheckEquals(0.5, Res);
end;

procedure TestNullableDouble.TestIncDec;
begin
  Res := Two;
  Inc(Res);
  CheckEquals(3, Res);

  Res := Two;
  Inc(Res, 2);
  CheckEquals(4, Res);

  Res := Two;
  Dec(Res);
  CheckEquals(1, Res);

  Res := Two;
  Dec(Res, 2);
  CheckEquals(0, Res);

  Res := 1.1;
  Inc(Res);
  CheckEquals(2.1, Res);

  Res := 1.1;
  Dec(Res);
  CheckEquals(0.1, Res);
end;

initialization
  RegisterTest(TestTNullableTypes.Suite);
  RegisterTest(TestNullableDouble.Suite);
end.

