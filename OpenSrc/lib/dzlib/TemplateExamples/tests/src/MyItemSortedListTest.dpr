program MyItemSortedListTest;

{$APPTYPE CONSOLE}



uses
  SysUtils,
  i_MyItemSortedList in '..\..\i_MyItemSortedList.pas',
  u_MyItemSortedList in '..\..\u_MyItemSortedList.pas',
  u_MyItem in '..\..\u_MyItem.pas',
  u_dzQuicksort in '..\..\..\Units\u_dzQuicksort.pas';

var
  MyItemSortedList: TMyItemSortedList;

begin
  MyItemSortedList := TMyItemSortedList.Create;
  MyItemSortedList.Add(TMyItem.Create(0));
  MyItemSortedList.Add(TMyItem.Create(1));
  MyItemSortedList.Free;
end.
