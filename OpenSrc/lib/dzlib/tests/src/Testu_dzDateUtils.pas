unit Testu_dzDateUtils;

interface

uses
  Windows,
  Classes,
  SysUtils,
  TestFramework,
  u_dzDateUtils,
  u_dzUnitTestUtils;

type
  TestDateUtils = class(TdzTestCase)
  published
    procedure TestDateTime2Iso;
    procedure TestIso2Date;
    procedure TestIso2Time;
  end;

implementation

{ TestDateUtils }

procedure TestDateUtils.TestDateTime2Iso;
begin
  CheckEquals('1966-05-05', DateTime2Iso(EncodeDate(1966, 5, 5)));
  CheckEquals('2000-01-31', DateTime2Iso(EncodeDate(2000, 1, 31)));
  CheckEquals('1966-05-05 20:15:01', DateTime2Iso(EncodeDate(1966, 5, 5) + EncodeTime(20, 15, 1, 0), true));
end;

procedure TestDateUtils.TestIso2Date;
begin
  CheckEqualsDate(EncodeDate(1966, 5, 5), Iso2Date('1966-05-05'));
end;

procedure TestDateUtils.TestIso2Time;
begin
  CheckEqualsTime(EncodeTime(20, 15, 1, 0), Iso2Time('20:15:01'));
  CheckEqualsTime(EncodeTime(20, 15, 0, 0), Iso2Time('20:15'));
end;

initialization
  RegisterTest(TestDateUtils.Suite);
end.

