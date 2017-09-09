program RegressSDL;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  DeCALIO in 'DeCALIO.pas',
  DeCAL in 'DeCAL.pas',
  SuperStream in 'SuperStream.pas',
  RandomTesting in 'RandomTesting.pas',
  DeCALSamples in 'DeCALSamples.pas',
  DeCALTesting in 'DeCALTesting.pas',
  mwFixedRecSort in 'mwFixedRecSort.pas';

var
  AssociativeClasses : array [1..8] of DAssociativeClass =
  (DMap, DMultiMap, DSet, DMultiSet, DHashMap, DMultiHashMap, DHashSet, DMultiHashSet);

  SequenceClasses : array[1..2] of DSequenceClass =
  (DList, DArray);

procedure SequentialBasicTest(seq : DSequence);
begin
end;

procedure SequentialAlgoTest(seq : DSequence);
begin
end;

procedure TestSequential;
var seqIdx : Integer;
    seq : DSequence;
begin
  for seqIdx := Low(SequenceClasses) to High(SequenceClasses) do
    begin
      seq := SequenceClasses[seqIdx].Create;
      SequentialBasicTest(seq);
      SequentialAlgoTest(seq);
    end;
end;

procedure AssociativeAlgoTest(assoc : DAssociative);
begin
end;

procedure TestAssociative;
var h : DHashMap;
    i : Integer;
    iter : DIterator;
    s : DHashSet;
begin
  h := DHashMap.Create;

  for i := 0 to 100 do
    h.putPair([i, IntToStr(i)]);


  iter := h.start;
  while IterateOver(iter) do
    begin
      writeln(GetString(iter));
    end;

  iter := h.locate([55]);
  if not atEnd(iter) then
    writeln(getString(iter));

  iter := h.locate([9000]);
  if not atEnd(iter) then
    writeln('error');

  h.free;

  s := DHashSet.Create;
  for i := 0 to 100 do
    s.add([i]);

  iter := s.start;
  while not atEnd(iter) do
    begin
      writeln(GetInteger(iter));
      advance(iter);
    end;

  s.free;
end;

procedure TestSorting;
var a : DArray;
    last, i : Integer;
    iter, x : DIterator;
begin
  a := DArray.Create;

  for i := 1 to 1000 do
    a.add([Random(32000)]);

  sort(a);

  // show the first 25 entries
  iter := a.start;
  x := iter;
  advanceBy(x, 25);

  last := -1;
  while not equals(iter, x) do
    begin
      i := getInteger(iter);
      if last > i then
        writeln('Sorting error found');
      last := i;
      writeln(i);
      advance(iter);
    end;

  a.free;
end;

procedure Go;
begin
//  TestDriver;
//  TestSequential;
//  TestAssociative;
end;

begin
  try
    Go;
  except
    on E: Exception do
    begin
      WriteLn(ErrOutput);
      WriteLn(ErrOutput, E.ClassName, ': ', E.Message);
      ReadLn;
    end;
  end;
end.
