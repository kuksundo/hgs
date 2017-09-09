unit Testu_dzRecordArray;

interface

uses
  TestFramework,
  Classes,
  Windows,
  SysUtils,
  u_dzUnitTestUtils,
  u_dzRecordArray;

type
  TestTRecordArray = class(TdzTestCase)
  private
  public
  published
    procedure TestIntegers;
    procedure TestExtended;
    procedure TestSimpleRecord;
    procedure TestComplexRecord;
  end;

implementation

procedure TestTRecordArray.TestIntegers;
var
  Item: integer;
  i: Integer;
  RA: TRecordArray;
begin
  RA := TRecordArray.Create(SizeOf(Item));
  try
    RA.SetLength(3);
    for i := 0 to 2 do begin
      Item := i;
      RA.SetItem(i, Item);
    end;
    for i := 0 to RA.Length - 1 do begin
      RA.GetItem(i, Item);
      CheckEquals(i, Item);
    end;
  finally
    RA.Free;
  end;
end;

procedure TestTRecordArray.TestExtended;
var
  Item: extended;
  i: Integer;
  RA: TRecordArray;
begin
  RA := TRecordArray.Create(SizeOf(Item));
  try
    RA.SetLength(3);
    for i := 0 to 2 do begin
      Item := i;
      RA.SetItem(i, Item);
    end;
    for i := 0 to RA.Length - 1 do begin
      RA.GetItem(i, Item);
      CheckEquals(i, Item);
    end;
  finally
    RA.Free;
  end;
end;

procedure TestTRecordArray.TestSimpleRecord;
var
  Item: record
    Int: integer;
    Ext: extended;
  end;
  i: Integer;
  RA: TRecordArray;
begin
  RA := TRecordArray.Create(SizeOf(Item));
  try
    RA.SetLength(3);
    for i := 0 to 2 do begin
      Item.Int := i;
      Item.Ext := i;
      RA.SetItem(i, Item);
    end;
    for i := 0 to RA.Length - 1 do begin
      RA.GetItem(i, Item);
      CheckEquals(i, Item.Int);
      CheckEquals(i, Item.Ext);
    end;
  finally
    RA.Free;
  end;
end;

procedure TestTRecordArray.TestComplexRecord;
var
  Item: record
    Int: integer;
    Ext: extended;
    Rec: packed record
      Ext: extended;
      Int: integer;
      dbl: double;
    end;
  end;
  i: Integer;
  RA: TRecordArray;
begin
  RA := TRecordArray.Create(SizeOf(Item));
  try
    RA.SetLength(3);
    for i := 0 to 2 do begin
      Item.Int := i;
      Item.Ext := i;
      Item.Rec.Int := 10 - i;
      item.Rec.Ext := 10 - i;
      item.Rec.dbl := 10 - i;
      RA.SetItem(i, Item);
    end;
    for i := 0 to RA.Length - 1 do begin
      RA.GetItem(i, Item);
      CheckEquals(i, Item.Int);
      CheckEquals(i, Item.Ext);
      CheckEquals(10 - i, Item.Rec.Ext);
      CheckEquals(10 - i, Item.Rec.Int);
      CheckEquals(10 - i, Item.Rec.dbl);
    end;
  finally
    RA.Free;
  end;
end;

initialization
  RegisterTest(TestTRecordArray.Suite);
end.

