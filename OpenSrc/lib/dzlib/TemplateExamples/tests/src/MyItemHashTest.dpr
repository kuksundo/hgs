program MyItemHashTest;

{$APPTYPE CONSOLE}



uses
  SysUtils,
  t_dzHashTemplate in '..\..\..\Templates\t_dzHashTemplate.tpl',
  u_MyItem in '..\..\u_MyItem.pas',
  u_MyItemHash in '..\..\u_MyItemHash.pas';

var
  ItemHash: TMyItemHash;

begin
  ItemHash := TMyItemHash.Create;
  Assert(not ItemHash.Contains('hallo'));
  Assert(not ItemHash.Contains('welt'));

  ItemHash['hallo'] := TMyItem.Create(0);
  Assert(ItemHash.Contains('hallo'));
  Assert(not ItemHash.Contains('welt'));

  ItemHash['welt'] := TMyItem.Create(1);
  Assert(ItemHash.Contains('hallo'));
  Assert(ItemHash.Contains('welt'));

  with ItemHash['hallo'] do begin
    Assert(Key = 0);
    Free;
  end;
  ItemHash['hallo'] := nil;
  Assert(not ItemHash.Contains('hallo'));
  Assert(ItemHash.Contains('welt'));

  with ItemHash['welt'] do begin
    Assert(Key = 1);
    Free;
  end;
  ItemHash['welt'] := nil;
  Assert(not ItemHash.Contains('hallo'));
  Assert(not ItemHash.Contains('welt'));

  ItemHash.Free;
end.
