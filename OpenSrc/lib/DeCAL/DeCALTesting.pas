unit DeCALTesting;

interface

uses DeCAL;

const

	{ These are sizes of containers -- the routines will generate containers
  of these sizes for testing purposes. }
	caseSmall = 20;
  caseMedium = 2000;
  caseBig = 25000;
  caseHuge = 100000;

var
  sizeCases : array[1..4] of Integer = (caseSmall, caseMedium, caseBig, caseHuge);

type

	DContainerTest = class
  private
  	procedure TestAlgorithms(container : DContainer);
  public
  	procedure Test(container : DContainer); virtual;
  end;

  DSequenceTest = class(DContainerTest)
  private
  	//procedure TestAlgorithms(seq : DSequence);
  public
  	procedure Test(container : DContainer); override;
  end;

  DVectorTest = class(DSequenceTest)
	end;

  DArrayTest = class(DVectorTest)
  end;

  DListTest = class(DSequenceTest)
  end;

  DAssociativeTest = class(DContainerTest)
  end;

  DMapTest = class(DAssociativeTest)
  end;

  DMultiMapTest = class(DMapTest)
  end;

  DSetTest = class(DAssociativeTest)
  end;

  DMultiSetTest = class(DSetTest)
  end;

  DHashMapTest = class(DAssociativeTest)
  end;

  DMultiHashMapTest = class(DHashMapTest)
  end;

  DHashSetTest = class(DHashMapTest)
  end;

  DMultiHashSetTest = class(DHashSetTest)
  end;

procedure TestDriver;

implementation

uses DeCALSamples;

procedure TestDriver;
begin
	DoExamples;
end;

//
// Test algorithms that work on all containers.
//
procedure DContainerTest.TestAlgorithms(container : DContainer);
begin

end;

//
// Test functions that are on all containers.
//
procedure DContainerTest.Test(container : DContainer);
begin
	TestAlgorithms(container);

  // Do function tests (for add, remove, etc...anything that's available
  // on DContainer.
end;

//
// Test algorithms that work on all sequences.
//
{procedure DSequenceTest.TestAlgorithms(seq : DSequence);
begin
	// Test algorithms that operate only on sequences (most are tested
  // already in DContainer.
end;}

//
// Test member functions that are on all sequences.
//
procedure DSequenceTest.Test(container : DContainer);
begin
	inherited Test(container);
end;

end.

