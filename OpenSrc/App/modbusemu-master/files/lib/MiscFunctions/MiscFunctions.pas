{
$Author: npcprom\fomin_k $
$Date: 2013-01-17 16:26:17 +0600 (Thu, 17 Jan 2013) $
$Rev: 345 $
}
unit MiscFunctions;

interface

function SerializeBuff(Buff : Pointer; BuffSize : Cardinal): AnsiString;

implementation

uses SysUtils;

function SerializeBuff(Buff : Pointer; BuffSize : Cardinal): AnsiString;
var TempByteBuff : PByteArray;
    i : Integer;
begin
  Result:='';
  if Buff=nil then Exit;
  TempByteBuff:=Buff;
  for i:=0 to BuffSize-1 do
   if i = 0 then Result:=Format('%s',[IntToHex(TempByteBuff^[i],2)])
     else Result:=Format('%s %s',[Result, IntToHex(TempByteBuff^[i],2)]);
end;

end.
