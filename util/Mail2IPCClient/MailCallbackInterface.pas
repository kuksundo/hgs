unit MailCallbackInterface;

interface

uses
  SysUtils,
  SynCommons,
  mORMot;

type
  TCommMode = (cmRESTful, cmWebSocket, cmCromisIPC);
  TCommModes = Set of TCommMode;

  IOLMailCallback = interface(IInvokable)
    ['{EA7EFE51-3EBA-4047-A356-253374518D1D}']
    procedure ClientExecute(const command, msg: string);
  end;

  IOLMailService = interface(IServiceWithCallbackReleased)
    ['{C92DCBEA-C680-40BD-8D9C-3E6F2ED9C9CF}']
    procedure Join(const pseudo: string; const callback: IOLMailCallback);
    function ServerExecute(const Acommand: string): RawUTF8;
    function GetOLEmailInfo(ACommand: string): RawUTF8;
  end;

const
  OL_ROOT_NAME_4_WS = 'root';
  OL_PORT_NAME_4_WS = '704';
  OL_APPLICATION_NAME_4_WS = 'OL_RestService_WebSocket';
  OL_DEFAULT_IP = '10.22.43.55';

  OL4WS_TRANSMISSION_KEY = 'OL_PrivateKey';

implementation

initialization
  TInterfaceFactory.RegisterInterfaces([
    TypeInfo(IOLMailService),TypeInfo(IOLMailCallback)]);
end.
