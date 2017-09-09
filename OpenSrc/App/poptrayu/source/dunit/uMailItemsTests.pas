unit uMailItemsTests;

interface

uses
  TestFrameWork, uMailItems;

type
 TTest_uMailItems = class(TTestCase)
 published
   procedure FakeTest;
 end;



implementation
uses SysUtils;


procedure TTest_uMailItems.FakeTest;
var
  items : TMailItems;
  item : TMailItem;
  i : integer;
begin
 (*items.Create();
  for i := 1 to 10 do
  begin
    item := items.Add();
    item.MsgNum := i;
    item.UID := IntToStr(i) + 'fake-uid';
  end;
  Check(items.FindMessage(5).MsgNum = 5, 'items[5].MsgNum = 5 failed');       *)
end;


initialization
   TestFramework.RegisterTest(TTest_uMailItems.Suite);
end.
