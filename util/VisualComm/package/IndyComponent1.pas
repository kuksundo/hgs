unit IndyComponent1;

interface

uses Classes, IdUDPClient, IdTCPConnection, IdTCPClient, IdUDPBase, IdUDPServer,
    IdBaseComponent, IdComponent, IdTCPServer;

function GetPaletteList: TStringList;

implementation

{$R Indy.res}

function GetPaletteList: TStringList;
begin
  Result := TStringList.Create;
  Result.Add('Indy=TIDTcpServer;TIDUdpServer;TIDTcpClient;TIDUdpClient;TIndyWriteClientTCP;TIndyReadClientTCP;TIndyWriteFile;');
end;

exports
  GetPaletteList;

initialization
  RegisterClasses([TIDTcpServer,TIDUdpServer,TIDTcpClient,TIDUdpClient]);

finalization
  UnRegisterClasses([TIDTcpServer,TIDUdpServer,TIDTcpClient,TIDUdpClient]);

end.
