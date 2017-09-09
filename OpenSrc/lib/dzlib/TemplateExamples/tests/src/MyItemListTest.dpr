program MyItemListTest;

{$APPTYPE CONSOLE}



uses
  SysUtils,
  u_MyItemList in '..\..\u_MyItemList.pas',
  u_MyItem in '..\..\u_MyItem.pas',
  u_dzQuicksort in '..\..\..\Units\u_dzQuicksort.pas',
  i_MyItemList in '..\..\i_MyItemList.pas';

var
  MyItemList: TMyItemList;
  MyItem: TMyItem;
begin
  MyItemList := TMyItemList.Create;
  MyItemList.Add(TMyItem.Create(0));
  MyItemList.Add(TMyItem.Create(1));
  for MyItem in MyItemList do begin
    WriteLn(MyItem.Key);
  end;
  MyItemList.Free;
end.

