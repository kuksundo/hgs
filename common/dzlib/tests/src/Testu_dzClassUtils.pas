unit Testu_dzClassUtils;

interface
uses
  Windows,
  Classes,
  SysUtils,
  TestFramework,
  u_dzClassUtils,
  u_dzUnitTestUtils;

type
  TestTStringsUtils = class(TdzTestCase)
  private
    FCounter: Integer;
  protected
    FList: TStringList;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestTStrings_RemoveTrailingSpaces;
    procedure TestTStrings_FreeWithObjects;
    procedure TestTStrings_FreeAllObjects;
    procedure TestTStrings_DeleteAndFreeObject;
    procedure TestTStrings_StringByObj;
    procedure TestTStrings_TryStringByObj;
  end;

type
  TestTStreamUtils = class(TdzTestCase)
  protected
    FStream: TStringStream;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestTestTStream_WriteString;
    procedure TestTStream_WriteStringLn;
    procedure TestTStream_ReadStringLn;
    procedure TestTStream_WriteFmtLn;
  end;

implementation

{ TestTStringsUtils }

procedure TestTStringsUtils.SetUp;
begin
  inherited;
  FList := TStringList.Create;
  FList.Add('a');
  FList.Add('b ');
  FList.Add('c');
  FList.Add('d');
  FList.Add('e ');
  FList.Add('f');
end;

procedure TestTStringsUtils.TearDown;
begin
  FList.Free;
  inherited;
end;

type
  TMyObj = class
  private
    FCounter: PInteger;
  public
    constructor Create(_Counter: PInteger);
    destructor Destroy; override;
  end;

{ TMyObj }

constructor TMyObj.Create(_Counter: PInteger);
begin
  inherited Create;
  FCounter := _Counter;
end;

destructor TMyObj.Destroy;
begin
  Inc(FCounter^);
  inherited;
end;

procedure TestTStringsUtils.TestTStrings_DeleteAndFreeObject;
begin
  FCounter := 0;
  FList.Objects[0] := TMyObj.Create(@FCounter);
  TStrings_DeleteAndFreeObject(FList, 0);
  CheckEquals(1, FCounter, 'Destructor has not been called');
end;

procedure TestTStringsUtils.TestTStrings_FreeAllObjects;
begin
  FCounter := 0;
  FList.Objects[0] := TMyObj.Create(@FCounter);
  FList.Objects[2] := TMyObj.Create(@FCounter);
  FList.Objects[3] := TMyObj.Create(@FCounter);
  FList.Objects[4] := TMyObj.Create(@FCounter);
  TStrings_FreeAllObjects(FList);
  CheckEquals(4, FCounter, 'Destructor has not been called 4 times');
end;

procedure TestTStringsUtils.TestTStrings_FreeWithObjects;
var
  List: TStringList;
begin
  FCounter := 0;
  List := FList;
  FList := nil;
  List.Objects[0] := TMyObj.Create(@FCounter);
  List.Objects[2] := TMyObj.Create(@FCounter);
  List.Objects[3] := TMyObj.Create(@FCounter);
  List.Objects[4] := TMyObj.Create(@FCounter);
  TStrings_FreeWithObjects(List);
  CheckEquals(4, FCounter, 'Destructor has not been called 4 times');
end;

procedure TestTStringsUtils.TestTStrings_RemoveTrailingSpaces;
begin
  TStrings_RemoveTrailingSpaces(FList);
  CheckEqualsMultiline('a'#13#10'b'#13#10'c'#13#10'd'#13#10'e'#13#10'f'#13#10,
    FList.Text);
end;

procedure TestTStringsUtils.TestTStrings_StringByObj;
var
  MyObj: TMyObj;
begin
  MyObj := TMyObj.Create(@FCounter);
  FList.Objects[3] := MyObj;
  CheckEquals('d', TStrings_StringByObj(FList, MyObj));
end;

procedure TestTStringsUtils.TestTStrings_TryStringByObj;
var
  MyObj: TMyObj;
  s: string;
begin
  MyObj := TMyObj.Create(@FCounter);
  FList.Objects[3] := MyObj;
  CheckTrue(TStrings_TryStringByObj(FList, MyObj, s));
  CheckEquals('d', s);
end;

{ TestTStreamUtils }

procedure TestTStreamUtils.SetUp;
begin
  inherited;
  FStream := TStringStream.Create('hello world'#13#10);
  FStream.Seek(0, soEnd);
end;

procedure TestTStreamUtils.TearDown;
begin
  FStream.Free;
  inherited;
end;

procedure TestTStreamUtils.TestTestTStream_WriteString;
begin
  TStream_WriteString(FStream, 'hello again');
  CheckEquals('hello world'#13#10'hello again', FStream.DataString);
end;

procedure TestTStreamUtils.TestTStream_ReadStringLn;
var
  s: string;
begin
  FStream.Seek(0, soBeginning);
  CheckEquals(11, TStream_ReadStringLn(FStream, s));
  CheckEquals('hello world', s);
end;

procedure TestTStreamUtils.TestTStream_WriteFmtLn;
begin
  TStream_WriteFmtLn(FStream, 'hello %s', ['again']);
  CheckEquals('hello world'#13#10'hello again'#13#10, FStream.DataString);
end;

procedure TestTStreamUtils.TestTStream_WriteStringLn;
begin
  TStream_WriteStringLn(FStream, 'hello again');
  CheckEquals('hello world'#13#10'hello again'#13#10, FStream.DataString);
end;

initialization
  RegisterTest('ClassUtils', TestTStringsUtils.Suite);
  RegisterTest('ClassUtils', TestTStreamUtils.Suite);
end.

