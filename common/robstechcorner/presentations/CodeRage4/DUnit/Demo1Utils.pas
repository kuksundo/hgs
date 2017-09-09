unit Demo1Utils;

interface

function DoSomething(Value1,Value2 : Integer) : Integer;

implementation

function DoSomething(Value1,Value2 : Integer) : Integer;
begin
  result := Value1 + Value2;
end;

end.
