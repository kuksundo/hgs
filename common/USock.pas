unit USock;

interface

uses Windows, Classes, Winsock, SysUtils, ActiveX, ComObj, Variants,
  UnitNetworkAdaptor;

{

  This function enumerates all TCP/IP interfaces and
  returns a CRLF separated string containing:

  IP, NetMask, BroadCast-Address, Up/Down status,
  Broadcast support, Loopback

  If you feed this string to a wide TMEMO (to its memo.lines.text
  property) you will see cleary the results.

  To use this you need Win98/ME/2K, 95 OSR 2 or NT service
  pack #3 because WinSock 2 is used (WS2_32.DLL)

}

function EnumInterfaces(var sInt: Ansistring): Boolean;
procedure GetWin32_NetworkAdapterConfigurationInfo(ACollect: TNetworkAdapterCollect);

{ Imported function WSAIOCtl from Winsock 2.0 - Winsock 2 is }
{ available only in Win98/ME/2K and 95 OSR2, NT srv pack #3 }

function WSAIoctl(s: TSocket; cmd: DWORD; lpInBuffer: PCHAR; dwInBufferLen:
  DWORD;
  lpOutBuffer: PCHAR; dwOutBufferLen: DWORD;
  lpdwOutBytesReturned: LPDWORD;
  lpOverLapped: POINTER;
  lpOverLappedRoutine: POINTER): Integer; stdcall; external 'WS2_32.DLL';

{ Constants taken from C header files }

const
  SIO_GET_INTERFACE_LIST = $4004747F;
  IFF_UP = $00000001;
  IFF_BROADCAST = $00000002;
  IFF_LOOPBACK = $00000004;
  IFF_POINTTOPOINT = $00000008;
  IFF_MULTICAST = $00000010;

type
  sockaddr_gen = packed record
    AddressIn: sockaddr_in;
    filler: packed array[0..7] of char;
  end;

type
  INTERFACE_INFO = packed record
    iiFlags: u_long; // Interface flags
    iiAddress: sockaddr_gen; // Interface address
    iiBroadcastAddress: sockaddr_gen; // Broadcast address
    iiNetmask: sockaddr_gen; // Network mask
  end;

implementation

{-------------------------------------------------------------------

1. Open WINSOCK
2. Create a socket
3. Call WSAIOCtl to obtain network interfaces
4. For every interface, get IP, MASK, BROADCAST, status
5. Fill a CRLF separated string with this info
6. Finito

--------------------------------------------------------------------}

function EnumInterfaces(var sInt: Ansistring): Boolean;
var
  s: TSocket;
  wsaD: WSADATA;
  NumInterfaces: Integer;
  BytesReturned, SetFlags: u_long;
  pAddrInet: SOCKADDR_IN;
  pAddrString: PAnsiCHAR;
  PtrA: pointer;
  Buffer: array[0..20] of INTERFACE_INFO;
  i: Integer;
begin
  result := true; // Initialize
  sInt := '';

  WSAStartup($0101, wsaD); // Start WinSock
  // You should normally check
  // for errors here :)

  s := Socket(AF_INET, SOCK_STREAM, 0); // Open a socket
  if (s = INVALID_SOCKET) then
    exit;

  try // Call WSAIoCtl
    PtrA := @bytesReturned;
    if (WSAIoCtl(s, SIO_GET_INTERFACE_LIST, nil, 0, @Buffer, 1024, PtrA, nil,
      nil)
      <> SOCKET_ERROR) then
    begin // If ok, find out how
      // many interfaces exist

      NumInterfaces := BytesReturned div SizeOf(INTERFACE_INFO);

      for i := 0 to NumInterfaces - 1 do // For every interface
      begin
        pAddrInet := Buffer[i].iiAddress.addressIn; // IP ADDRESS
        pAddrString := inet_ntoa(pAddrInet.sin_addr);
        sInt := sInt + ' IP=' + pAddrString + ',';
        pAddrInet := Buffer[i].iiNetMask.addressIn; // SUBNET MASK
        pAddrString := inet_ntoa(pAddrInet.sin_addr);
        sInt := sInt + ' Mask=' + pAddrString + ',';
        pAddrInet := Buffer[i].iiBroadCastAddress.addressIn; // Broadcast addr
        pAddrString := inet_ntoa(pAddrInet.sin_addr);
        sInt := sInt + ' Broadcast=' + pAddrString + ',';

        SetFlags := Buffer[i].iiFlags;
        if (SetFlags and IFF_UP) = IFF_UP then
          sInt := sInt + ' Interface UP,' // Interface up/down
        else
          sInt := sInt + ' Interface DOWN,';

        if (SetFlags and IFF_BROADCAST) = IFF_BROADCAST then // Broadcasts
          sInt := sInt + ' Broadcasts supported,' // supported or
        else // not supported
          sInt := sInt + ' Broadcasts NOT supported,';

        if (SetFlags and IFF_LOOPBACK) = IFF_LOOPBACK then // Loopback or
          sInt := sInt + ' Loopback interface'
        else
          sInt := sInt + ' Network interface'; // normal

        sInt := sInt + #13#10; // CRLF between
        // each interface
      end;
    end;
  except
  end;
  //
  // Close sockets
  //
  CloseSocket(s);
  WSACleanUp;
  result := false;
end;

function VarArrayToStr(const vArray: variant): string;
  function _VarToStr(const V: variant): string;
  var
    Vt: integer;
  begin
    Vt := VarType(V);

    case Vt of
      varSmallint,
      varInteger  : Result := IntToStr(integer(V));
      varSingle,
      varDouble,
      varCurrency : Result := FloatToStr(Double(V));
      varDate     : Result := VarToStr(V);
      varOleStr   : Result := WideString(V);
      varBoolean  : Result := VarToStr(V);
      varVariant  : Result := VarToStr(Variant(V));
      varByte     : Result := char(byte(V));
      varString   : Result := String(V);
      varArray    : Result := VarArrayToStr(Variant(V));
    end;
  end;
var
  i : integer;
begin
//  Result := '[';
  if (VarType(vArray) and VarArray)=0 then
     Result := _VarToStr(vArray)
  else
  for i := VarArrayLowBound(vArray, 1) to VarArrayHighBound(vArray, 1) do
  begin
   if i=VarArrayLowBound(vArray, 1)  then
   begin
      Result := Result+_VarToStr(vArray[i]);
      break;
   end
   else
    Result := Result+'|'+_VarToStr(vArray[i]);
  end;//for

//  Result:=Result+']';
end;

procedure GetWin32_NetworkAdapterConfigurationInfo(ACollect: TNetworkAdapterCollect);
const
  WbemUser            ='';
  WbemPassword        ='';
  WbemComputer        ='localhost';
  wbemFlagForwardOnly = $00000020;
var
  FSWbemLocator : OLEVariant;
  FWMIService   : OLEVariant;
  FWbemObjectSet: OLEVariant;
  FWbemObject   : OLEVariant;
  oEnum         : IEnumvariant;
  iValue        : LongWord;
  LNetworkAdapterItem: TNetworkAdapterItem;
begin;

  try
    CoInitialize(nil);
    try
      FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
      FWMIService   := FSWbemLocator.ConnectServer(WbemComputer, 'root\CIMV2', WbemUser, WbemPassword);
      FWbemObjectSet:= FWMIService.ExecQuery('SELECT * FROM Win32_NetworkAdapterConfiguration Where IpEnabled=True','WQL',wbemFlagForwardOnly);
      oEnum         := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;
      while oEnum.Next(1, FWbemObject, iValue) = 0 do
      begin
        LNetworkAdapterItem := ACollect.Add;

        if not VarIsNull(FWbemObject.IPAddress) then
          LNetworkAdapterItem.IPAddress := VarArrayToStr(FWbemObject.IPAddress);

        if not VarIsNull(FWbemObject.IPSubnet) then
          LNetworkAdapterItem.IPSubnet := VarArrayToStr(FWbemObject.IPSubnet);

        if not VarIsNull(FWbemObject.MACAddress) then
          LNetworkAdapterItem.MacAddress := VarArrayToStr(FWbemObject.MACAddress);

        if not VarIsNull(FWbemObject.DHCPServer) then
          LNetworkAdapterItem.DHCPServer := String(FWbemObject.DHCPServer);

//        Writeln(Format('Caption       %s',[String(FWbemObject.Caption)]));// String
//        if not VarIsNull(FWbemObject.DHCPServer) then
//          Writeln(Format('DHCPServer    %s',[String(FWbemObject.DHCPServer)]));// String
//        if not VarIsNull(FWbemObject.IPAddress) then
//          Writeln(Format('IPAddress     %s',[VarArrayToStr(FWbemObject.IPAddress)]));// array String
//
//        if not VarIsNull(FWbemObject.IPSubnet) then
//          Writeln(Format('IPSubnet      %s',[VarArrayToStr(FWbemObject.IPSubnet)]));// array String
//
//        if not VarIsNull(FWbemObject.MACAddress) then
//          Writeln(Format('MACAddress     %s',[VarArrayToStr(FWbemObject.MACAddress)]));// array String
//
//        Writeln;
        FWbemObject:=Unassigned;
      end;
    finally
      CoUninitialize;
    end;
  except
    on E:EOleException do
        Writeln(Format('EOleException %s %x', [E.Message,E.ErrorCode]));
    on E:Exception do
        Writeln(E.Classname, ':', E.Message);
  end;
end;

end.

