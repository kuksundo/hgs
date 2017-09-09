unit GUID_Utils_Unit;

interface

function GetNewGUID:string;

implementation
uses
  ActiveX, SysUtils;

function GetNewGUID:string;
var aGUID : TGUID;
begin
  CoCreateGuid(aGUID);
  Result := GUIDToString(aGUID);
end;

end.
