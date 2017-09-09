unit UDPMiscTypes;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils, Sockets;

type
  TOnRecvPackage = procedure(ASource : TObject; const ASourceAddr : sockaddr; const Buff : Pointer; const BuffLen : Integer) of object;

implementation

end.

