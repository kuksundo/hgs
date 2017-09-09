unit DeCALSamples;

interface

uses DeCAL;

procedure DoExamples;

implementation

uses Windows, Math, Classes, SysUtils, RandomTesting;

var
	counter : Integer = 0;

type
	TTest = class
  public
  	FName : String;
    FCount : Integer;
    FTest : Boolean;

    constructor Create;

  end;

constructor TTest.Create;
begin
	FCount := counter;
  FName := chr(65 + Random(26)) + chr(65 + Random(26)) + chr(65 + Random(26));
  FTest := Random(2) = 0;
  Inc(counter);
end;

function TestPrinter (obj : TObject) : String;
	function BToT(b : Boolean) : String;
  begin
  	if b then
    	result := 'Yes'
    else
    	result := 'No';
  end;
begin
	with obj as TTest do
  	result := format('Name: %s Count: %d Test:%s', [Fname, FCount, BTOT(FTest)]);
end;

function ComparatorTestName(ptr : Pointer; const obj1, obj2 : DObject) : Integer;
begin
	result := CompareStr(TTest(obj1.vobject).FName, TTest(obj2.vobject).Fname);
end;

function ComparatorTestCount(ptr : Pointer; const obj1, obj2 : DObject) : Integer;
begin
	result := TTest(obj1.vobject).FCount - TTest(obj2.vobject).FCount;
end;

function ComparatorTestTest(ptr : Pointer; const obj1, obj2 : DObject) : Integer;
var a,b : Boolean;
begin
	a := TTest(obj1.vobject).FTest;
  b := Ttest(obj2.vobject).Ftest;
  if a = b then
  	result := 0
  else if not a then
  	result := -1
  else
  	result := 1;
end;

procedure FreeAll(objs : array of TObject);
var i : Integer;
begin
	for i := Low(objs) to High(objs) do
  	objs[i].free;
end;

procedure PrintContainer(con : DContainer);
begin
	writeln('container: ', con.classname, ' size:', con.size);
	ForEach(con, MakeApply(ApplyPrintLN));
  writeln;
end;

procedure PrintContainers(cons : array of DContainer);
var i : Integer;
begin
	for i := Low(cons) to High(cons) do
  	PrintContainer(cons[i]);
end;

procedure PrintMap(assoc : DAssociative);
var iter : DIterator;
begin
	writeln;
	writeln('container: ', assoc.classname, ' size:', assoc.size);
  iter := assoc.start;
  while not atEnd(iter) do
  	begin
    	write('[');
      SetToKey(iter);
      ApplyPrint(nil, getRef(iter)^);
      write('][');
      SetToValue(iter);
      ApplyPrint(nil, getRef(iter)^);
      writeln(']');
      advance(iter);
    end;
end;

procedure AddExample1;
var arr : DArray;
begin
	arr := DArray.Create;
  arr.add([1]);
  arr.add([4,5,6]);
  PrintContainer(arr);
  arr.free;
end;

procedure AddExample2;
var arr : DArray;
begin
	arr := DArray.Create;
  arr.add(['this']);
  arr.add(['is', 'an', 'add', 'example']);
  PrintContainer(arr);
  arr.free;
end;

procedure AddExample3;
var list : DList;
begin
	list := DList.Create;
  list.add([chr(65)]);
  list.add([chr(66),chr(67)]);
  PrintContainer(list);
  list.free;
end;

procedure AddExample4;
var s : DSet;
begin
	s := DSet.Create;
  s.add(['here', 'we']);
  s.add(['perform', 'set', 'addition']);

  // Note that the set will be printed in sorted order!
  PrintContainer(s);

  s.free;
end;

procedure AddExample5;
var s : DHashSet;
begin
	s := DHashSet.Create;
  s.add(['here', 'we']);
  s.add(['perform', 'set', 'addition']);

  // Note that the set will be printed in random order!
  PrintContainer(s);

  s.free;
end;

procedure AddExample6;
var s : DSet;
		a : DArray;
    l : DList;
	procedure AddStringsToContainer(con : DContainer);
  begin
  	con.add(['these', 'are', 'strings', 'being', 'added']);
  end;
  procedure AddNumbersToContainer(con : DContainer);
  begin
  	con.add([1,2,3,4,5]);
  end;
begin
	s := DSet.Create;
  a := DArray.Create;
  l := DList.Create;

  AddStringsToContainer(s);
  AddStringsToContainer(a);
  AddStringsToContainer(l);

  // note that we can't add numbers to the set, 'cause all items must be the same type
  AddNumbersToContainer(a);
  AddNumbersToContainer(l);

  PrintContainers([s,a,l]);

  s.free;
  a.free;
  l.free;
end;

procedure AddExample7;
var a : DArray;
		l : DList;
	procedure AddStrings(cons : array of DContainer);
  var i : Integer;
  begin
  	for i := Low(cons) to High(cons) do cons[i].add(['just', 'another', 'string', 'addition']);
  end;
	procedure AddNumbers(cons : array of DContainer);
  var i : Integer;
  begin
  	for i := Low(cons) to High(cons) do cons[i].add([5,4,3,2,1]);
  end;
begin
	a := DArray.Create;
  l := DList.Create;
  AddStrings([a,l]);
  AddNumbers([a,l]);
  PrintContainers([a,l]);
  FreeAll([a,l]);
end;

procedure AddExample8;
var i : Integer;
		a : DArray;
begin
	a := DArray.Create;
  for i := 1 to 10 do
  	a.add([TTest.Create]);
  PrintContainer(a);
  ObjFree(a);
  a.free;
end;

procedure AddExample9;
var l : DList;
		j : Integer;
begin
	l := DList.Create;

  j := 0;
  while j < 360 do
  	begin
    	l.add([sin(DegToRad(j))]);
      Inc(j, 10);
    end;

  PrintContainer(l);

  l.free;
end;

procedure AddExample10;
var
  hset: DHashSet;
  wstr1, wstr2: WideString;
begin
  hset := DHashSet.Create;
  try
    wstr1 := 'value1';
    wstr2 := 'value1';
    hset.add([wstr1]);
    hset.add([wstr2]);
    Assert( hset.size = 1 );
  finally
    hset.Free;
  end;
end;


procedure Comparator1;
var a : DArray;
		i : Integer;
begin
	a := DArray.Create;
  for i := 1 to 10 do
  	a.add([TTest.Create]);
	PrintContainer(a);
  sortWith(a, MakeComparator(ComparatorTestName));
  PrintContainer(a);
  sortWith(a, MakeComparator(ComparatorTestCount));
  PrintContainer(a);
  ObjFree(a);
  a.free;
end;

procedure Comparator2;
var a : DArray;
		i : Integer;
begin
	a := DArray.CreateWith(MakeComparator(ComparatorTestName));
  for i := 1 to 10 do
  	a.add([TTest.Create]);
	PrintContainer(a);
  sort(a);
  PrintContainer(a);
  ObjFree(a);
  a.free;
end;

procedure Comparator3;
var s1, s2 : DSet;
		i : Integer;
    t : TTest;
begin
	s1 := DSet.CreateWith(MakeComparator(ComparatorTestName));
	s2 := DSet.CreateWith(MakeComparator(ComparatorTestCount));
  for i := 1 to 10 do
  	begin
    	t := TTest.Create;
	  	s1.add([t]);
      s2.add([t]);
    end;
  PrintContainers([s1, s2]);
  ObjFree(s1);
  s1.free;
  s2.free;
end;

procedure Set1;
var s : DSet;
		h : DHashSet;
begin
	s := DSet.Create;
  h := DHashSet.Create;

  s.add(['hello', 'there', 'just', 'testing', 'this']);
  h.add(['hello', 'there', 'just', 'testing', 'this']);

  PrintContainers([s,h]);

  if s.includes(['hello']) then
  	writeln('Found hello');
  if s.includes(['borf']) then
  	writeln('Error');

  s.free;
  h.free;

end;

procedure Set2;
var s : DSet;
		i : Integer;
    t : TTest;
begin
	s := DSet.CreateWith(makeComparator(ComparatorTestName));

  t := TTest.Create;
  s.add([t]);

  for i := 1 to 9 do
  	s.add([TTest.Create]);

  if s.includes([t]) then
  	writeln('Found t');

  t := TTest.Create;
  if s.includes([t]) then
  	writeln('Error!');
  t.free;

  ObjFree(s);
  s.free;
end;

procedure Set3;
var s : DSet;
		i : Integer;
begin
	s := DSet.Create;

  for i := 1 to 3 do
  	s.add([i]);

//  s.remove([5]);

  for i := 1 to 10 do
  	s.remove([i]);

  s.free;
end;


{** Demonstrates a mapping of integers to strings. }
procedure Map1;
var m : DMap;
		iter : DIterator;
begin
	m := DMap.Create;
  m.putPair([10, 'hello']);
  m.putAt([11, 12, 13], ['zonk', 'toast', 'bravo']);

  PrintMap(m);

  write('Finding 12...');
  iter := m.locate([12]);
  if not atEnd(iter) then
  	begin
	  	write('found it: ');
      ApplyPrintLN(nil, getRef(iter)^);
    end;

  m.free;

end;

{** Demonstrates a mapping of strings to objects. }
procedure Map2;
var m : DMap;
		i : Integer;
    t : TTest;
    iter : DIterator;
begin
	m := DMap.Create;

  for i := 1 to 10 do
  	begin
    	t := TTest.Create;
      m.putPair([t.Fname, t]);
    end;

  PrintMap(m);

  iter := m.locate([t.fname]);
  if not atEnd(iter) then
  	writeln('found it');

  ObjFree(m);
  m.free;
end;

{** Demonstrates a multi-map (multiple equal keys) of strings to integers. }
procedure Map3;
var m : DMultiMap;
begin
	m := DMultiMap.Create;

  m.putPair(['hello', 1]);
  m.putPair(['there', 2]);
  m.putPair(['just', 3]);
  m.putPair(['hello', 4]);
  m.putPair(['there', 5]);

  PrintMap(m);

  m.free;
end;

{** Demonstrates a multi-map of objects to integers.  Note that the
map is keyed off the boolean field in the test object. }
procedure Map4;
var m : DMultiMap;
		t : TTest;
    i : Integer;
begin
	m := DMultiMap.CreateWith(MakeComparator(ComparatorTestTest));

  for i := 1 to 10 do
  	begin
    	t := TTest.Create;
      m.putPair([t, i]);
    end;

  PrintMap(m);

  ObjFreeKeys(m);
	m.free;
end;

{** Demonstrates an object to object mapping. }
procedure Map5;
var m : DHashMap;
		t, t2 : TTest;
    i : Integer;
begin
	m := DHashMap.Create;

  for i := 1 to 10 do
  	begin
    	t := TTest.Create;
      t2 := TTest.Create;
      m.putPair([t, t2]);
    end;

  PrintMap(m);

  ObjFree(m);
  ObjFreeKeys(m);

	m.free;
end;

procedure Map6;
var m : DMap;
		mm : DMultiMap;
begin
	m := DMap.Create;
  mm := DMultiMap.Create;

  m.putPair([10, 'ten']);
  m.putPair([15, 'fifteen']);
  m.putPair([20, 'twenty']);
  m.putPair([15, 'ouch']);

  mm.putPair([10, 'ten']);
  mm.putPair([15, 'fifteen']);
  mm.putPair([20, 'twenty']);
  mm.putPair([15, 'ouch']);

  PrintContainer(m);
  PrintContainer(mm);

  FreeAll([m,mm]);
end;

procedure Map7;
var m : DHashMap;
		mm : DMultiHashMap;
begin
	m := DHashMap.Create;
  mm := DMultiHashMap.Create;

  m.putPair([10, 'ten']);
  m.putPair([15, 'fifteen']);
  m.putPair([20, 'twenty']);
  m.putPair([15, 'ouch']);

  mm.putPair([10, 'ten']);
  mm.putPair([15, 'fifteen']);
  mm.putPair([20, 'twenty']);
  mm.putPair([15, 'ouch']);

  PrintContainer(m);
  PrintContainer(mm);

  FreeAll([m,mm]);
end;

procedure Sorting1;
var l : DList;
begin
	l := DList.Create;
	l.add([3,6,1,8,3,6,9,2,4]);
  sort(l);
  PrintContainer(l);
  l.free;
end;

{** Demonstrates sort and stableSort.  The stableSort version will retain
the ordering of the container it is sorting, while sort will lose the
ordering. }
procedure Sorting2;
var a1, a2 : DArray;
		i : Integer;
begin
	a1 := DArray.Create;
  for i := 1 to 10 do
  	a1.add([TTest.Create]);

  sortWith(a1, MakeComparator(ComparatorTestCount));

  PrintContainer(a1);

  a2 := a1.clone as DArray;


  sortWith(a1, MakeComparator(ComparatorTestTest));

  stablesortWith(a2, MakeComparator(ComparatorTestTest));

  PrintContainers([a1, a2]);


  ObjFree(a1);
  a1.free;
  a2.free;

end;

procedure Sorting3;
var a : DArray;
		i : Integer;
begin
	a := DArray.CreateWith(MakeComparator(ComparatorTestName));

  for i := 1 to 10 do
  	a.add([TTest.Create]);

  PrintContainer(a);

  sort(a);

  PrintContainer(a);

  objFree(a);
  a.free;
end;

procedure Replace1;
var a : DArray;
		i : Integer;
begin
	a := DArray.Create;

  for i := 1 to 10 do
  	a.add([i]);

  PrintContainer(a);

  Replace(a, [3, 5], [1000, 1001]);

  PrintContainer(a);

  a.free;

end;

{** Replacement restricted to a certain range. }
procedure Replace2;
var a : DArray;
		i : Integer;
begin
	a := DArray.Create;

  for i := 1 to 10 do
  	a.add([i]);

  PrintContainer(a);

  ReplaceIn(advanceByF(a.start, 4), a.finish, [3, 7], [1000, 1001]);

  PrintContainer(a);

  a.free;

end;

function t1u(ptr : Pointer; const obj : DObject) : DObject;
begin
	result := Make(['binky ' + IntToStr(asInteger(obj))]);
end;

procedure Transform1;
var a, a2 : DArray;
		l : DList;
		i : Integer;
begin
	a := DArray.Create;
  l := DList.Create;

  for i := 1 to 10 do
  	a.add([i]);

  // This will add strings equivalent to the integers into the list.
  transformUnary(a, l, MakeUnary(t1u));

  PrintContainer(l);

  // Using the same call, we can send it to an array.
  a2 := DArray.Create;
  transformUnary(a,a2, MakeUnary(t1u));

  PrintContainer(a2);

	l.free;
  a.free;
  a2.free;
end;

function t2b(ptr : Pointer; const obj1, obj2 : DObject) : DObject;
begin
	SetInteger(result, asInteger(obj1) + asInteger(obj2));
end;

procedure Transform2;
var i : Integer;
		a,b : DArray;
    l : DList;
begin
	a := DArray.Create;
  b := DArray.Create;
  l := DList.Create;
	for i := 1 to 10 do
  	begin
    	a.add([i]);
      b.add([10 * i]);
    end;
  transformBinary(a,b,l, MakeBinary(t2b));
  PrintContainer(l);
  FreeAll([a,b,l]);
end;

procedure Shuffling1;
var i : Integer;
		a : DArray;
begin
	a := DArray.Create;
  for i := 1 to 10 do
  	a.add([i]);

  randomShuffle(a);

  PrintContainer(a);

  a.free;
end;

procedure SetOps1;
var a : DArray;
		l : DList;
    i : Integer;
begin
	a := DArray.Create;
  l := DList.Create;
	for i := 1 to 10 do
  	a.add([i]);
  for i := 4 to 7 do
  	l.add([i]);

  if includes(a,l) then
  	writeln('Inclusion');

  if includes(l,a) then
  	writeln('error');

  if includes(l,l) then
  	writeln('self include ok');

    
  FreeAll([a,l]);

end;

procedure SetOps2;
var a : DArray;
		l : DList;
    o : DArray;
    i : Integer;
begin
	a := DArray.Create;
  l := DList.Create;
	for i := 1 to 10 do
  	a.add([i]);
  for i := 4 to 7 do
  	l.add([i]);

  o := DArray.Create;
  setDifference(a,l,o.finish);
  PrintContainer(o);

  o.clear;

  setIntersection(a,l,o.finish);
  PrintContainer(o);

  FreeAll([a,l,o]);

end;

procedure SetOps3;
var a : DArray;
		l : DList;
    o : DArray;
    i : Integer;
begin
	a := DArray.Create;
  l := DList.Create;
	for i := 1 to 10 do
  	a.add([i]);
  for i := 20 to 27 do
  	l.add([i]);

  o := DArray.Create;
  setUnion(a,l,o.finish);
  PrintContainer(o);

  FreeAll([a,l,o]);

end;

procedure Comparing1;
var a,b : DArray;
		i : Integer;
begin

	a := DArray.Create;
  b := DArray.Create;

  for i := 1 to 15 do
  	begin
    	a.add([i]);
      b.add([i]);
    end;

  if equal(a,b) then
  	writeln('they''re equal');

  a.remove([5]);

  if equal(a,b) then
  	writeln('Error');

  FreeAll([a,b]);

end;


type
	TMorphing = class
  protected
  	FCount : Integer;
  public
  	function SimpleUnary(const obj : DObject) : DObject;
  end;

function TMorphing.SimpleUnary(const obj : DObject) : DObject;
begin
	result := Make([Format('closure %d - %d', [FCount, asInteger(obj)])]);
  Inc(FCount);
end;

function SimpleUnaryProc(ptr : Pointer; const obj : DObject) : DObject;
begin
	result := Make(['proc ' + IntToStr(asInteger(obj))]);
end;

{** Demonstrates how SDL function pointers can be used either as closures
or normal function pointers. }
procedure Morphing1;
var x : TMorphing;
		l : DList;
    a : DArray;
    s : DSet;
    i : Integer;
begin
	s := DSet.Create;

  x := TMorphing.Create;

  for i := 1 to 10 do
  	s.add([i]);

  l := DList.Create;
  a := DArray.Create;

  transformUnary(s, l, x.SimpleUnary);
  PrintContainer(l);

  transformUnary(s, a, MakeUnary(SimpleUnaryProc));
  PrintContainer(a);

  FreeAll([l,a,s,x]);
end;

procedure Rotate1;
var a : DArray;
		i : Integer;
begin
	a := DArray.Create;
  for i := 1 to 10 do
  	a.add([i]);

  PrintContainer(a);

  // rotate (shift) the entire array by 1 element
  rotate(a.start, advanceByF(a.start,1), a.finish);

  PrintContainer(a);

  a.free;
end;

procedure Rotate2;
var a : DArray;
		i : Integer;
begin
	a := DArray.Create;
  for i := 1 to 10 do
  	a.add([i]);

  PrintContainer(a);

  // shift the middle part of the array.  element 3 will go to position 5,
  // element 4 to position 6, and so on.
  rotate(advanceByF(a.start, 3), advanceByF(a.start, 5), advanceByF(a.start, 7));

  PrintContainer(a);

  a.free;
end;

{** Same as rotate2, but does the same operation on a list instead of an
array.  }
procedure Rotate3;
var a : DList;
		i : Integer;
begin
	a := DList.Create;
  for i := 1 to 10 do
  	a.add([i]);

  PrintContainer(a);

  // shift the middle part of the array.  element 3 will go to position 5,
  // element 4 to position 6, and so on.
  rotate(advanceByF(a.start, 3), advanceByF(a.start, 5), advanceByF(a.start, 7));

  PrintContainer(a);

  a.free;
end;

procedure Equal1;
var l : DList;
		a : DArray;
		i : Integer;
begin
	l := DList.Create;
  a := DArray.Create;
  for i := 1 to 10 do
  	begin
	  	l.add([i]);
      a.add([i]);
    end;

  // They should be equal at this point.
  if equal(a,l) then
  	writeln('They''re equal!');

  // Now they're not equal!
  a.remove([5]);

  if equal(a,l) then
  	writeln('Error');

  FreeAll([a,l]);

end;

procedure Mismatch1;
var l : DList;
		a : DArray;
		i : Integer;
    pair : DIteratorPair;
begin
	l := DList.Create;
  a := DArray.Create;
  for i := 1 to 10 do
  	begin
	  	l.add([i]);
      a.add([i]);
    end;

  // Since they have the same values, no mismatch should be detected
  pair := mismatch(a,l);
  if atEnd(pair.first) and atEnd(pair.second) then
  	writeln('Correct');

  // Now they're not equal!
  a.remove([5]);

  // Now we should detect a mismatch.
  pair := mismatch(a,l);
  if (not atEnd(pair.first)) or (not atEnd(pair.second)) then
  	begin
    	writeln('Mismatch detected.');
    end;

  FreeAll([a,l]);

end;

procedure DTStringList1;
var s : TStringList;
		dt : DTStrings;
begin
	s := TStringList.Create;
	dt := DTStrings.Create(s);

  s.Add('hello');
  s.Add('there');
  s.Add('in');
  s.Add('string');
  s.Add('land');
  s.Add('hello');

  PrintContainer(dt);

  writeln('There are ', count(dt, ['hello']), ' hellos.');

	dt.remove(['hello']);

  PrintContainer(dt);

  FreeAll([dt,s]);

end;

procedure BSearch1;
var a : DArray;
		i : Integer;
    iter : DIterator;
begin
	a := DArray.Create;
  i := 1;
  while i < 20 do
  	begin
	  	a.add([i]);
      Inc(i,2);
    end;

  iter := binarySearch(a, [1]);
  iter := binarySearch(a, [15]);
  iter := binarySearch(a, [7]);
  iter := binarySearch(a, [2]);
  iter := binarySearch(a, [14]);

  a.free;
end;

procedure Big1;
var i : Integer;
		a : DArray;
		ms, st : DeCALDWORD;
begin
	a := DArray.Create;

  ms := GetTickCount;

  a.ensureCapacity(500000);
	for i := 1 to 500000 do
  	a.add([i]);

  a.free;

  st := GetTickCount;
  ms := st - ms;
  writeln('Numerics done: ',ms);

	a := DArray.Create;

  a.ensureCapacity(500000);
	for i := 1 to 500000 do
  	a.add([IntToStr(i)]);

  a.free;

  ms := GetTickCount - st;
  writeln('Strings done: ', ms);

end;

procedure Big2;
var i : Integer;
		m : DMap;
		st, ms : DeCALDWORD;
begin
	m := DMap.Create;

  m.ensureCapacity(500000);

  ms := GetTickCount;

  for i := 1 to 500000 do
  	m.putPair([i, IntToStr(i)]);

  st := GetTickCount;
  ms := st - ms;
  writeln('add: ', ms);

  st := GetTickCount;

  m.free;

	ms := GetTickCount - st;

  writeln('free: ', ms);

end;

procedure Big3;
var i : Integer;
    a : DArray;
		ms : DeCALDWORD;
    sl : TStringList;
begin
	a := DArray.Create;

	i := 0;
  while i < 500000 do
  	begin
	  	a.add([i, i+1, i+2, i+3, i+4]);
      Inc(i,5);
    end;

  ms := GetTickCount;

	randomShuffle(a);

	writeln('Shuffle: ', GetTickCount - ms);

  ms := GetTickCount;

  sort(a);

	writeln('Sort: ', GetTickCount - ms);

  a.free;

  writeln('Now doing strings...');

	a := DArray.Create;

  ms := GetTickCount;
	i := 0;
  while i < 500000 do
  	begin
	  	a.add([IntToStr(i)]);
      Inc(i);
    end;
	writeln('Adding: ', GetTickCount - ms);

  ms := GetTickCount;

	randomShuffle(a);

  writeln('Shuffle: ', GetTickCount - ms);

  ms := GetTickCount;

  sort(a);

  writeln('Sort: ', GetTickCount - ms);

  ms := GetTickCount;

	randomShuffle(a);

  writeln('Shuffle: ', GetTickCount - ms);

  ms := GetTickCount;

  stablesort(a);

  writeln('StableSort: ', GetTickCount - ms);

  randomShuffle(a);

  // to make the timing comparison fair, we need to do it this way.
  // we don't predeclare a capacity for sl, because we don't do it
  // for SDL.  SDL doesn't require foreknowledge of this to perform well.
  // TStringList's performance does increase (~30%) if you declare
  // capacity early and large.
	sl := TStringList.Create;
  ms := GetTickCount;
	for i := 0 to 499999 do
  	sl.add(InttoStr(i));
  writeln('Adding to string list: ', GetTickCount - ms);

  // now we're going to add the shuffled strings.
  sl.clear;
	for i := 0 to 499999 do
  	sl.add(a.atAsString(i));

  ms := GetTickCount;
	sl.Sort;
	writeln('sorting string list: ', GetTickCount - ms);
	sl.free;

  a.free;

end;

procedure Big4;
var ms, i, x, dels : DeCALDWORD;
		iter : DIterator;
    s : DSet;
begin
	s := DSet.Create;
  dels := 0;
  ms := GetTickCount;
  for i := 1 to 500000 do
  	begin
    	if Random(2) = 0 then
      	begin
        	s.add([Random(500000)]);
        end
      else
      	begin
        	x := Random(500000);
        	iter := s.locate([x]);
          if not atEnd(iter) then
          	begin
							s.remove([x]);
              Inc(dels);
            end;
        end;
    end;

  writeln('Processed ', dels, ' in ', GetTickCount - ms);

  s.free;
end;

procedure StressHashSet;
var m : DHashSet;
		i : Integer;
		ms : DeCALDWORD;
    iter : DIterator;
begin
	m := DHashset.Create;

  ms := GetTickCount;

	for i := 1 to 10000 do
   	m.add([i]);

	writeln('Add time is: ', GetTickCount - ms);

  ms := GetTickCount;
  i := 1;
  while i < 10000 do
  	begin
		  m.remove([i]);
      Inc(i, 2);
    end;
	writeln('Remove time is: ', GetTickCount - ms);

  // Verify correct contents.
  iter := m.start;
  while not AtEnd(iter) do
  	begin
			if getInteger(iter) mod 2 <> 0 then
      	writeln('Error');
      advance(iter);
    end;


  m.free;
end;

function Gen1(ptr : Pointer) : DObject;
begin
	result := Make([TTest.Create]);
end;

procedure Generate1;
var list : DList;
begin
	list := DList.Create;
  Generate(list, 10, MakeGenerator(Gen1));
  ObjFree(list);
  list.free;
end;

function Inj1(ptr : Pointer; const obj1, obj2 : DObject) : DObject;
begin
	result := Make([asInteger(obj1) + TTest(asObject(obj2)).FCount]);
end;

procedure Inject1;
var arr : DArray;
begin
	arr := DArray.Create;
  Generate(arr, 10, makeGenerator(Gen1));
  writeln('Sum is ', decal.toInteger(Inject(arr, [0], MakeBinary(Inj1))));
  ObjFree(arr);
  arr.free;
end;

function Inj2(ptr : Pointer; const obj1, obj2 : DObject) : DObject;
var s : String;
begin
	s := asString(obj1);
  if Length(s) > 0 then
  	result := Make([s + ';' + TTest(asObject(obj2)).FName])
  else
  	result := Make([TTest(asObject(obj2)).FName]);
end;

procedure Inject2;
var arr : DArray;
	  bigString : String;
begin
	// Create a comma-delimited set of names.
	arr := DArray.Create;
  Generate(arr, 10, makeGenerator(gen1));
	bigString := decal.toString(Inject(arr, [''], MakeBinary(Inj2)));
  writeln('Here are the comma delimited names:');
  writeln(bigString);
  ObjFree(arr);
  arr.free;
end;

type
	ATest = procedure;

procedure FrameTest(proc : ATest; const name : String);
begin
	writeln('-----------------------------------------------------------');
  writeln('Test: ', name);
  proc;
  writeln;
end;

procedure DoExamples;
begin
	RegisterDeCALPrinter(TTest, TestPrinter);

  RandomGo;


//
// No leaks for these examples:
//


	FrameTest(AddExample1,        'AddExample1');
  FrameTest(AddExample2,        'AddExample2');
  FrameTest(AddExample3,        'AddExample3');
  FrameTest(AddExample4,        'AddExample4');
  FrameTest(AddExample5,        'AddExample5');
  FrameTest(AddExample6,        'AddExample6');
  FrameTest(AddExample7,        'AddExample7');
  FrameTest(AddExample8,        'AddExample8');
  FrameTest(AddExample9,        'AddExample9');
  FrameTest(AddExample10,       'AddExample10');

  FrameTest(Comparator1,        'Comparator1');
	FrameTest(Comparator2,        'Comparator2');
  FrameTest(Comparator3,        'Comparator3');

  FrameTest(Set1,               'Set1');
  FrameTest(Set2,               'Set2');
  FrameTest(Set3,               'Set3');

  FrameTest(Map1,               'Map1');
  FrameTest(Map2,               'Map2');
  FrameTest(Map3,               'Map3');
  FrameTest(Map4,               'Map4');
  FrameTest(Map5,               'Map5');
  FrameTest(Map6,               'Map6');
  FrameTest(Map7,               'Map7');

  FrameTest(Sorting1,           'Sorting1');
  FrameTest(Sorting2,           'Sorting2');
  FrameTest(Sorting3,           'Sorting3');

  FrameTest(Replace1,           'Replace1');
  FrameTest(Replace2,           'Replace2');

  FrameTest(Transform1,         'Transform1');
  FrameTest(Transform2,         'Transform2');

  FrameTest(Shuffling1,         'Shuffling1');

  FrameTest(Morphing1,          'Morphing1');

  FrameTest(SetOps1,            'SetOps1');
  FrameTest(SetOps2,            'SetOps2');
  FrameTest(SetOps3,            'SetOps3');

  FrameTest(Rotate1,            'Rotate1');
  FrameTest(Rotate2,            'Rotate2');
  FrameTest(Rotate3,            'Rotate3');

  FrameTest(Equal1,             'Equal1');

  FrameTest(Mismatch1,          'Mismatch1');

  FrameTest(DTStringList1,      'DTStringList1');

  FrameTest(StressHashSet,      'StressHashSet');
  FrameTest(Inject1,            'Inject1');
  FrameTest(Inject2,            'Inject2');
  FrameTest(Generate1,          'Generate1');
  FrameTest(Comparing1,         'Comparing1');
  FrameTest(Bsearch1,           'Bsearch1');

//
// These examples have leaks:
//

//
// These examples are untested:
//

{

  FrameTest(Big1,               'Big1');
  FrameTest(Big2,               'Big2');
  FrameTest(Big3,               'Big3');
  FrameTest(Big4,               'Big4');

  }


  Writeln('Testing is complete');

end;

end.
