unit RandomTesting;

interface

procedure RandomGo;

implementation

uses SysUtils, DeCAL;

const
	Executions = 100;
  Cycles = 10;

type
	TOperation = (opAdd, opRemove, opClear, opFind);

var
	containerClasses : DArray;
  sequenceClasses : DArray;
  setClasses : DArray;
  mapClasses : DArray;

procedure ContainerTesting;
var exec, cycle : Integer;
		cls : DContainerClass;
		con1, con2 : DContainer;
		value, test, count : Integer;
    iter1, iter2 : DIterator;
    v1,v2, diff : DArray;
    scenarioNumber : Integer;
    errors : Boolean;
begin

	errors := false;

	v1 := DArray.Create;
  v2 := DArray.Create;
  diff := Darray.Create;

	for exec := 1 to Executions do
  	begin
			// Randomly choose two container classes
      writeln('Exec: ', exec);

      RandomShuffle(containerClasses);


      cls := DContainerClass(containerClasses.atAsClass(0));
      con1 := cls.Create;
      cls := DContainerClass(containerClasses.atAsClass(1));
      con2 := cls.Create;

      for cycle := 1 to cycles do
      	begin
        	scenarioNumber := exec * cycles + cycle;

        	case Random(5) of
            0:
            	begin
              	count := Random(100);
              	for test := 1 to count do
                	begin
										value := Random(1000);
    		            con1.add([value]);
                    con2.add([value]);
                  end;
              end;
            1:
            	begin
              	count := Random(100);
                for test := 1 to count do
                	begin
                  	value := Random(1000);
                    con1.remove([value]);
                    con2.remove([value]);

                    if con1.size <> con2.size then
                    	writeln('Error: ', scenarioNumber, ' ', test);

                  end;
              end;
            2:
            	begin
              	con1.clear;
                con2.clear;
              end;
            3:
            	begin
              	count := Random(100);
                for test := 1 to count do
                	begin
                    value := Random(1000);
                    iter1 := find(con1, [value]);
                    iter2 := find(con2, [value]);
                    if atEnd(iter1) <> atEnd(iter2) then
                    	begin
	                      writeln('Error: ', scenarioNumber);
                        errors := true;
                      end;
                  end;
              end;

          end;

          // Verify that they're the same.
          if con1.size <> con2.size then
            begin
              writeln('Container sizes are different: ', scenarioNumber);
              errors := true;
            end
          else
            begin
              // Verify they contain the same stuff.
              v1.Clear;
              v2.Clear;
              diff.Clear;

              CopyContainer(con1, v1);
              CopyContainer(con2, v2);

              sort(v1);
              sort(v2);

              setSymmetricDifference(v1, v2, diff.finish);
              if diff.size > 0 then
                begin
                  writeln('Difference found: ', scenarioNumber);
                  errors := true;
                end;

            end;

        end;

      FreeAll([con1, con2]);
    end;

  if errors then
  	writeln('Errors were found');
end;

procedure SequenceTesting;
begin
end;

procedure VectorTesting;
begin
	
end;

procedure WriteIt(const s : String);
var f : Text;
begin
	AssignFile(f, 'tree.out');
  if FileExists('tree.out') then
	  Append(f)
  else
  	Rewrite(f);

  writeln(f, s);

  CloseFile(f);
end;

procedure MapTesting;
var exec, cycle : Integer;
		cls : DAssociativeClass;
		con1, con2 : DAssociative;
    value, test, count : Integer;
    iter1, iter2 : DIterator;
    v1,v2, diff : DArray;
    scenarioNumber : Integer;
    errors : Boolean;
    cyc : Boolean;
    writing : Boolean;
begin

	errors := false;
  cyc := false;
  writing := false;

	v1 := DArray.Create;
  v2 := DArray.Create;
  diff := Darray.Create;

	for exec := 1 to Executions do
  	begin
			// Randomly choose two container classes
      writeln('Exec: ', exec);

			// Randomly choose two container classes

      RandomShuffle(mapClasses);

      cls := DAssociativeClass(mapClasses.atAsClass(0));
      con1 := cls.Create;
      cls := DAssociativeClass(mapClasses.atAsClass(1));
      con2 := cls.Create;

      for cycle := 1 to cycles do
      	begin

        	if cyc then
          	writeln('Cycle: ', cycle);

        	scenarioNumber := exec * cycles + cycle;

					case Random(5) of
						0:
            	begin
								count := Random(100);
              	for test := 1 to count do
                	begin
										value := Random(1000);

                    if writing then WriteIt('put ' + IntToStr(value));

										con1.putPair([value, value]);
                    con2.putPair([value, value]);

                    if con1.size <> con2.size then
                    	writeln('Error: ', scenarioNumber, ' ', test);

                  end;
              end;
            1:
            	begin
              	count := Random(100);
                for test := 1 to count do
                	begin
                  	// happens on iteration 30?
                  	value := Random(1000);

                    if writing then WriteIt('remove ' + IntToStr(value));

                    con1.remove([value]);
                    con2.remove([value]);

                    if con1.size <> con2.size then
                    	writeln('Error: ', scenarioNumber, ' ', test);

                  end;
              end;
            2:
            	begin

              	if writing then WriteIt('clear');

              	con1.clear;
                con2.clear;
              end;
            3:
            	begin
              	count := Random(100);
                for test := 1 to count do
                	begin
                    value := Random(1000);
                    iter1 := find(con1, [value]);
                    iter2 := find(con2, [value]);
                    if atEnd(iter1) <> atEnd(iter2) then
                    	begin
	                      writeln('Error: ', scenarioNumber);
                        errors := true;
                      end;
                  end;
              end;

          end;

          // Verify that they're the same.
          if con1.size <> con2.size then
            begin
              writeln('Container sizes are different: ', scenarioNumber);
              errors := true;
            end
          else
            begin
              // Verify they contain the same stuff.
              v1.Clear;
              v2.Clear;
              diff.Clear;

              CopyContainer(con1, v1);
              CopyContainer(con2, v2);

              sort(v1);
              sort(v2);

              setSymmetricDifference(v1, v2, diff.finish);
              if diff.size > 0 then
                begin
                  writeln('Difference found: ', scenarioNumber);
                  errors := true;
                end;

            end;

        end;

      FreeAll([con1, con2]);
    end;

  FreeAll([v1, v2, diff]);

  if errors then
  	writeln('Errors were found');
end;

procedure SetTesting;
begin
end;

var
	puts : array[1..91] of Integer = (

    866,
    208,
    669,
    847,
    14 ,
    917,
    558,
    494,
    617,
    660,
    372,
    297,
    508,
    542,
    44 ,
    739,
    904,
    368,
    20 ,
    869,
    942,
    55 ,
    741,
    942,
    823,
    997,
    913,
    908,
    203,
    743,
    328,
    744,
    781,
    595,
    311,
    855,
    236,
    996,
    72 ,
    27 ,
    944,
    802,
    516,
    673,
    145,
    809,
    313,
    359,
    488,
    137,
    264,
    825,
    105,
    338,
    270,
    15 ,
    671,
    332,
    441,
    821,
    84 ,
    526,
    156,
    549,
    714,
    742,
    102,
    324,
    382,
    788,
    606,
    933,
    491,
    810,
    800,
    822,
    982,
    758,
    414,
    258,
    38 ,
    596,
    241,
    858,
    709,
    101,
    589,
    0  ,
    870,
    370,
    238

    );

removes : array[1..31] of integer = (
    722,
    845,
    113,
    262,
    980,
    334,
    723,
    18 ,
    658,
    74 ,
    445,
    988,
    623,
    108,
    714,
    243,
    490,
    521,
    855,
    617,
    182,
    493,
    249,
    201,
    861,
    80 ,
    208,
    423,
    738,
    487,
    241);

procedure TestSpecial;
var map : DMap;
		i : Integer;
    t : Text;
    iter : DIterator;
begin
	map := DMap.Create;

	for i := Low(puts) to High(puts) do
  	begin
	   	map.putPair([puts[i], puts[i]]);

      AssignFile(t, 'c:\redblack\delphi\put' + IntToStr(i - 1) + '.txt');
      Rewrite(t);

			iter := map.start;
      while iterateOver(iter) do
      	begin
        	if iter.treeNode.color = tnfRed then
          	writeln(t, 'red')
          else
          	writeln(t, 'black');
        end;

      CloseFile(t);
    end;

  // map.putPair([238, 238]);

	for i := Low(removes) to High(removes) do
  	begin
	   	map.remove([removes[i]]);
      AssignFile(t, 'c:\redblack\delphi\remove' + IntToStr(i - 1) + '.txt');
      Rewrite(t);

			iter := map.start;
      while iterateOver(iter) do
      	begin
        	if iter.treeNode.color = tnfRed then
          	writeln(t, 'red')
          else
          	writeln(t, 'black');
        end;

      CloseFile(t);
    end;

  // map.remove([487]);
  // map.remove([241]);

  map.free;

end;

procedure RandomGo;
begin

	RandSeed := 0;

  TestSpecial;
  
	containerClasses := DArray.Create;
  sequenceClasses := DArray.Create;
	setClasses := DArray.Create;
  mapClasses := DArray.Create;

  containerClasses.add([DArray, DList, DMultiSet, DMultiHashSet]);
	sequenceClasses.add([DArray, DList]);
  setClasses.add([DSet, DMultiSet, DHashSet, DMultiHashSet]);
  mapClasses.add([DMap, DHashMap]);

  // ContainerTesting;
	SequenceTesting;
  MapTesting;
  SetTesting;

  FreeAll([containerClasses, sequenceClasses, setClasses, mapClasses]);

end;

end.
