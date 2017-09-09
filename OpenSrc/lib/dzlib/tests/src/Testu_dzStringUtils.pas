unit Testu_dzStringUtils;

interface

uses
  Windows,
  Classes,
  SysUtils,
  TestFramework,
  u_dzStringUtils,
  u_dzUnitTestUtils;

type
  TestExtractStr = class(TdzTestCase)
  published
    procedure TestExtractStr1;
    procedure TestExtractStr2;
    procedure TestExtractStr3;
    procedure TestExtractStr4;
    procedure TestExtractStr5;
  end;

type
  TestTrimSpaces = class(TdzTestCase)
  published
    procedure TestTrimSpaces;
    procedure TestLTrimSpaces;
    procedure TestRTrimSpaces;
  end;

type
  TestMisc = class(TdzTestCase)
  published
    procedure TestStringOf;
    procedure TestSpaceString;
    procedure TestPrependBackslash;
  end;

type
  TestFileExt = class(TdzTestCase)
  published
    procedure TestForceExt;
    procedure TestJustFilename;
    procedure TestRemoveSuffixIfMatching;
  end;

implementation

{ TestStringUtils }

procedure TestExtractStr.TestExtractStr1;
var
  src: string;
  s: string;
begin
  src := 'hello#world';
  s := ExtractStr(src, '#');
  CheckEquals('hello', s);
  CheckEquals('world', src);

  src := 'helloworld';
  s := ExtractStr(src, '#');
  CheckEquals('helloworld', s);
  CheckEquals('', src);

  src := '';
  s := ExtractStr(src, '#');
  CheckEquals('', s);
  CheckEquals('', src);
end;

procedure TestExtractStr.TestExtractStr2;
var
  src: string;
  s: string;
begin
  src := 'hello#world';
  CheckTrue(ExtractStr(src, '#', s));
  CheckEquals('hello', s);
  CheckEquals('world', src);

  src := 'helloworld';
  CheckTrue(ExtractStr(src, '#', s));
  CheckEquals('helloworld', s);
  CheckEquals('', src);

  src := '';
  s := 'hello';
  CheckFalse(ExtractStr(src, '#', s));
  CheckEquals('', s);
  CheckEquals('', src);
end;

procedure TestExtractStr.TestExtractStr3;
var
  src: string;
  s: string;
  b: boolean;
  cnt: integer;
begin
  src := 'hello#world#';
  b := false;
  CheckTrue(ExtractStr(src, '#', s, b));
  CheckFalse(b);
  CheckEquals('hello', s);
  CheckEquals('world#', src);
  CheckTrue(ExtractStr(src, '#', s, b));
  CheckTrue(b);
  CheckEquals('world', s);
  CheckEquals('', src);
  CheckTrue(ExtractStr(src, '#', s, b));
  CheckFalse(b);
  CheckEquals('', s);
  CheckEquals('', src);
  CheckFalse(ExtractStr(src, '#', s, b));
  CheckFalse(b);
  CheckEquals('', s);
  CheckEquals('', src);

  src := 'hello##world';
  b := false;
  CheckTrue(ExtractStr(src, '#', s, b));
  CheckFalse(b);
  CheckEquals('hello', s);
  CheckEquals('#world', src);
  CheckTrue(ExtractStr(src, '#', s, b));
  CheckFalse(b);
  CheckEquals('', s);
  CheckEquals('world', src);
  CheckTrue(ExtractStr(src, '#', s, b));
  CheckFalse(b);
  CheckEquals('world', s);
  CheckEquals('', src);
  CheckFalse(ExtractStr(src, '#', s, b));
  CheckFalse(b);
  CheckEquals('', s);
  CheckEquals('', src);

  cnt := 0;
  src := 'hello#world#';
  b := false;
  while ExtractStr(src, '#', s, b) do begin
    Inc(Cnt);
  end;
  CheckEquals(3, Cnt);
end;

procedure TestExtractStr.TestExtractStr4;
var
  src: string;
  s: string;
begin
  src := 'hello#world';
  CheckTrue(ExtractStr(src, ['#'], s));
  CheckEquals('hello', s);
  CheckEquals('world', src);

  src := 'helloworld';
  CheckTrue(ExtractStr(src, ['#'], s));
  CheckEquals('helloworld', s);
  CheckEquals('', src);

  src := '';
  s := 'hello';
  CheckFalse(ExtractStr(src, ['#'], s));
  CheckEquals('', s);
  CheckEquals('', src);

  src := 'hello#big world';
  CheckTrue(ExtractStr(src, ['#', ' '], s));
  CheckEquals('hello', s);
  CheckEquals('big world', src);
  CheckTrue(ExtractStr(src, ['#', ' '], s));
  CheckEquals('big', s);
  CheckEquals('world', src);

  src := 'hellobigworld';
  CheckTrue(ExtractStr(src, ['#', ' '], s));
  CheckEquals('hellobigworld', s);
  CheckEquals('', src);

  src := '';
  s := 'hello';
  CheckFalse(ExtractStr(src, ['#', ' '], s));
  CheckEquals('', s);
  CheckEquals('', src);
end;

procedure TestExtractStr.TestExtractStr5;
var
  src: string;
  s: string;
  b: boolean;
  cnt: Integer;
begin
  src := 'hello#world';
  b := false;
  CheckTrue(ExtractStr(src, ['#'], s, b));
  CheckFalse(b);
  CheckEquals('hello', s);
  CheckEquals('world', src);

  src := 'helloworld';
  b := false;
  CheckTrue(ExtractStr(src, ['#'], s, b));
  CheckFalse(b);
  CheckEquals('helloworld', s);
  CheckEquals('', src);

  src := '';
  s := 'hello';
  b := false;
  CheckFalse(ExtractStr(src, ['#'], s, b));
  CheckFalse(b);
  CheckEquals('', s);
  CheckEquals('', src);

  src := 'hello#big world';
  b := false;
  CheckTrue(ExtractStr(src, ['#', ' '], s, b));
  CheckFalse(b);
  CheckEquals('hello', s);
  CheckEquals('big world', src);
  CheckTrue(ExtractStr(src, ['#', ' '], s, b));
  CheckFalse(b);
  CheckEquals('big', s);
  CheckEquals('world', src);

  src := 'hellobigworld';
  b := false;
  CheckTrue(ExtractStr(src, ['#', ' '], s, b));
  CheckFalse(b);
  CheckEquals('hellobigworld', s);
  CheckEquals('', src);

  src := '';
  s := 'hello';
  b := false;
  CheckFalse(ExtractStr(src, ['#', ' '], s, b));
  CheckFalse(b);
  CheckEquals('', s);
  CheckEquals('', src);

  // this are 5 strings, delimited by ' ' and '#':
  // 'hello'
  // 'big'
  // 'world'
  // '' (between ' ' and '#')
  // '' (after the last '#')
  src := 'hello#big world #';
  b := false;
  CheckTrue(ExtractStr(src, ['#', ' '], s, b));
  CheckFalse(b);
  CheckEquals('hello', s);
  CheckEquals('big world #', src);
  CheckTrue(ExtractStr(src, ['#', ' '], s, b));
  CheckFalse(b);
  CheckEquals('big', s);
  CheckEquals('world #', src);
  CheckTrue(ExtractStr(src, ['#', ' '], s, b));
  CheckFalse(b);
  CheckEquals('world', s);
  CheckEquals('#', src);
  CheckTrue(ExtractStr(src, ['#', ' '], s, b));
  CheckTrue(b);
  CheckEquals('', s);
  CheckEquals('', src);
  CheckTrue(ExtractStr(src, ['#', ' '], s, b));
  CheckFalse(b);
  CheckEquals('', s);
  CheckEquals('', src);
  CheckFalse(ExtractStr(src, ['#', ' '], s, b));
  CheckFalse(b);
  CheckEquals('', s);
  CheckEquals('', src);

  cnt := 0;
  src := 'hello big#world# ';
  b := false;
  while ExtractStr(src, ['#', ' '], s, b) do begin
    Inc(Cnt);
  end;
  CheckEquals(5, Cnt);
end;

{ TestTrimSpaces }

procedure TestTrimSpaces.TestLTrimSpaces;
begin
  CheckEquals('', LTrimSpaces(''));
  CheckEquals('', LTrimSpaces('   '));
  CheckEquals('a', LTrimSpaces('   a'));
  CheckEquals('a b c', LTrimSpaces('   a b c'));
  CheckEquals('a b c  ', LTrimSpaces('   a b c  '));
  CheckEquals(#9, LTrimSpaces(#9));
  CheckEquals(#13#10'a'#13#10'b', LTrimSpaces('  '#13#10'a'#13#10'b'));
end;

procedure TestTrimSpaces.TestRTrimSpaces;
begin
  CheckEquals('', TrimSpaces(''));
  CheckEquals('', TrimSpaces('   '));
  CheckEquals('a', TrimSpaces('   a'));
  CheckEquals('a b c', TrimSpaces('   a b c'));
  CheckEquals('a b c', TrimSpaces('   a b c  '));
  CheckEquals(#9, TrimSpaces(#9));
  CheckEquals(#13#10'a'#13#10'b', TrimSpaces('  '#13#10'a'#13#10'b'));
  CheckEquals(#13#10'a'#13#10'b', TrimSpaces('  '#13#10'a'#13#10'b '));
end;

procedure TestTrimSpaces.TestTrimSpaces;
begin
  CheckEquals('', RTrimSpaces(''));
  CheckEquals('', RTrimSpaces('   '));
  CheckEquals('a', RTrimSpaces('a   '));
  CheckEquals('a b c', RTrimSpaces('a b c   '));
  CheckEquals('   a b c', RTrimSpaces('   a b c  '));
  CheckEquals(#9, RTrimSpaces(#9));
  CheckEquals('  '#13#10'a'#13#10'b', RTrimSpaces('  '#13#10'a'#13#10'b'));
  CheckEquals('  '#13#10'a'#13#10'b', RTrimSpaces('  '#13#10'a'#13#10'b '));
end;

{ TestStringOf }

procedure TestMisc.TestPrependBackslash;
begin
  CheckEquals('\', PrependBackslash(''));
  CheckEquals('\', PrependBackslash('\'));
  CheckEquals('\hello', PrependBackslash('hello'));
  CheckEquals('\hello', PrependBackslash('\hello'));
  CheckEquals('\hello\world\', PrependBackslash('hello\world\'));
  CheckEquals('\hello\world', PrependBackslash('\hello\world'));
end;

procedure TestMisc.TestSpaceString;
begin
  CheckEquals('', SpaceStr(0));
  CheckEquals(' ', SpaceStr(1));
  CheckEquals('     ', SpaceStr(5));
end;

{$WARNINGS off}

procedure TestMisc.TestStringOf;
begin
  CheckEquals('', StringOf(' ', 0));
  CheckEquals(' ', StringOf(' ', 1));
  CheckEquals('     ', StringOf(' ', 5));
end;
{$WARNINGS on}

{ TestFileExt }

procedure TestFileExt.TestJustFilename;
begin
  CheckEquals('', JustFilename(''));
  CheckEquals('.', JustFilename('.'));
  CheckEquals('.txt', JustFilename('.txt'));
  CheckEquals('hello', JustFilename('hello'));
  CheckEquals('hello.txt', JustFilename('hello.txt'));
  CheckEquals('hello.', JustFilename('hello.'));
  CheckEquals('world', JustFilename('hello\world'));
  CheckEquals('world.', JustFilename('hello\world.'));
  CheckEquals('world.txt', JustFilename('hello\world.txt'));
end;

procedure TestFileExt.TestRemoveSuffixIfMatching;
begin
  CheckEquals('', RemoveSuffixIfMatching('', ''));
  CheckEquals('', RemoveSuffixIfMatching('', '.txt'));
  CheckEquals('', RemoveSuffixIfMatching('', '.'));
  CheckEquals('', RemoveSuffixIfMatching('', 'abc'));
  CheckEquals('hello', RemoveSuffixIfMatching('hello', ''));
  CheckEquals('hello', RemoveSuffixIfMatching('hello.txt', '.txt'));
  CheckEquals('hello.txt', RemoveSuffixIfMatching('hello.txt', '.abc'));
  CheckEquals('hello.', RemoveSuffixIfMatching('hello.txt', 'txt'));
  CheckEquals('hello.txt', RemoveSuffixIfMatching('hello.txt.abc', '.abc'));
  CheckEquals('hello.txt.abc', RemoveSuffixIfMatching('hello.txt.abc', '.def'));
  CheckEquals('hello ', RemoveSuffixIfMatching('hello World', 'World'));
  CheckEquals('hello', RemoveSuffixIfMatching('hello World', ' World'));
end;

procedure TestFileExt.TestForceExt;
begin

end;

initialization
  RegisterTest('StringUtils', TestExtractStr.Suite);
  RegisterTest('StringUtils', TestTrimSpaces.Suite);
  RegisterTest('StringUtils', TestMisc.Suite);
  RegisterTest('StringUtils', TestFileExt.Suite);
end.

