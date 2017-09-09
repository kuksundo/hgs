unit u_dzStringPoolTest;

interface

uses
  SysUtils,
  Classes,
  TestFramework,
  u_dzStringPool,
  u_dzStringPoolDebugger;

type
{$M+}
  TestStringPool = class(TTestCase)
  strict private
    FPool: TStringPool;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestUnique;
    procedure TestMany;
  end;

implementation

uses
  u_dzStringUtils;

{ TestTEngineStateQuotedParam }

procedure TestStringPool.SetUp;
begin
  inherited;
  FPool := TStringPool.Create();
end;

procedure TestStringPool.TearDown;
begin
  FreeAndNil(FPool);
  inherited;
end;

procedure TestStringPool.TestMany;
var
  i: Integer;
  s: string;
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    for i := 1 to 1000 do begin
      s := 'hallo';
      UniqueString(s);
      FPool.Intern(s);
      sl.Add(s);
    end;

    for i := 1 to sl.Count - 1 do begin
      CheckEquals(Integer(Pointer(sl[0])), Integer(Pointer(sl[i])));
    end;

    CheckEquals(1, TDebugStringPool(FPool).List.Count);
  finally
    FreeAndNil(sl);
  end;
end;

procedure TestStringPool.TestUnique;
var
  s1: string;
  s2: string;
begin
  s1 := 'hallo';
  UniqueString(s1);
  FPool.Intern(s1);
  CheckEquals(2, GetStringReferenceCount(s1));

  s2 := s1;
  CheckEquals(3, GetStringReferenceCount(s1));
  CheckEquals(3, GetStringReferenceCount(s2));

  UniqueString(s2);
  CheckEquals(1, GetStringReferenceCount(s2));

  FPool.Intern(s2);
  CheckEquals(Integer(Pointer(s1)), Integer(Pointer(s2)));
  CheckEquals(3, GetStringReferenceCount(s1));
  CheckEquals(3, GetStringReferenceCount(s2));

  CheckEquals(1, TDebugStringPool(FPool).List.Count);
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestStringPool.Suite);
end.

