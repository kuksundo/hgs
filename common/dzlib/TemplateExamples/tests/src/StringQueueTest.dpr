program StringQueueTest;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  u_PCharQueue in '..\..\u_PCharQueue.pas',
  u_StringQueue in '..\..\u_StringQueue.pas';

var
  Queue: TStringQueue;
  i: integer;
begin
  try
    Queue := TStringQueue.Create;
    try
      for i := 0 to 100 - 1 do
        Queue.Enqueue('Item#' + IntToStr(i));
      while not Queue.IsEmpty do
        WriteLn(Queue.Dequeue);
    finally
      Queue.Free;
    end;
    WriteLn('enter');
    Readln;
  except
    on E: Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;
end.

