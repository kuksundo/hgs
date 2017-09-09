program MyItemStackTest;

{$APPTYPE CONSOLE}



uses
  SysUtils,
  u_MyItemStack in '..\..\u_MyItemStack.pas',
  u_MyItem in '..\..\u_MyItem.pas';

var
  Stack: TMyItemStack;

begin
  Stack := TMyItemStack.Create;
  Assert(Stack.IsEmpty);
  Assert(Stack.Depth = 0);
  Stack.Push(TMyItem.Create(0));
  Assert(not Stack.IsEmpty);
  Assert(Stack.Depth = 1);
  Stack.Push(TMyItem.Create(1));
  Assert(not Stack.IsEmpty);
  Assert(Stack.Depth = 2);
  with Stack.Pop do
    begin
      Assert(Key = 1);
      Free;
    end;
  Assert(not Stack.IsEmpty);
  Assert(Stack.Depth = 1);
  with Stack.Pop do
    begin
      Assert(Key = 0);
      Free;
    end;
  Assert(Stack.IsEmpty);
  Assert(Stack.Depth = 0);
  Stack.Free;
end.

