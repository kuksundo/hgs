unit UnitInternetUtil;

interface

uses Windows;

//wininet
function InternetGetConnectedState(var lpdwFlags: DWORD; dwReserved: DWORD): BOOL; stdcall;
function IsConnectedToInternet : boolean;

implementation

function InternetGetConnectedState; external 'wininet.dll' name 'InternetGetConnectedState';

function IsConnectedToInternet : boolean;
var
  Flags: DWORD;
begin
  Result := false;
  if InternetGetConnectedState(Flags, 0) then
  begin
//    Result := ((Flags and INTERNET_CONNECTION_LAN) > 0) or
//              ((Flags and INTERNET_CONNECTION_MODEM) >  0) or
//              ((Flags and INTERNET_CONNECTION_PROXY) > 0);
  end;
end;

end.
