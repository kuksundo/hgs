unit CommonU;

interface

uses
  Classes, Windows,
  IdTCPServer, IdTCPClient;

type
  // this packet should always be the first thing in a communications packet
  TCommHeader = packed record
    DPType: Byte;      // type of packet
    DPCode: Byte;      // some extra code
    DPExtra: Word;     // other extra data
    DPSize: Cardinal;  // size of the following data
  end;

  TFramePacket = packed record
    KeyFrame: Boolean;
    Size: Cardinal;
    Data: PByte;
  end;

procedure SendData(Conn: TidTCPServerConnection; var Header: TCommHeader; Data: PByte);
procedure SendFrame(Conn: TidTCPServerConnection; var Header: TCommHeader; Packet: TFramePacket);
procedure ReceiveData(Conn: TIdTCPClient; var Header: TCommHeader; Data: PByte);
function CopyFrame(Source: TFramePacket): TFramePacket;
procedure FreeFrame(Packet: TFramePacket);

implementation

procedure SendData(Conn: TidTCPServerConnection; var Header: TCommHeader; Data: PByte);
var
  ms: TMemoryStream;
begin
  ms := TMemoryStream.Create;
  try
    ms.Write(Header, SizeOf(Header));
    if Header.DPSize > 0 then
      ms.Write(Data^, Header.DPSize);
    ms.Seek(0, soFromBeginning);
    if Conn.Connected then
      Conn.WriteStream(ms, false, false, ms.Size);
  finally
    ms.Free;
  end;
end;

procedure SendFrame(Conn: TidTCPServerConnection; var Header: TCommHeader; Packet: TFramePacket);
begin
  Header.DPCode:=Byte(Packet.KeyFrame);
  Header.DPSize:=Packet.Size;
  SendData(Conn, Header, Packet.Data);
end;

procedure ReceiveData(Conn: TIdTCPClient; var Header: TCommHeader; Data: PByte);
begin
  ReallocMem(Data, Header.DPSize);
  if Conn.Connected then
    Conn.ReadBuffer(Data^, Header.DPSize);
end;

function CopyFrame(Source: TFramePacket): TFramePacket;
begin
  Result.KeyFrame:=Source.KeyFrame;
  Result.Size:=Source.Size;
  GetMem(Result.Data, Result.Size);
  CopyMemory(Result.Data, Source.Data, Result.Size);
end;

procedure FreeFrame(Packet: TFramePacket);
begin
  FreeMem(Packet.Data, Packet.Size);
  ZeroMemory(@Packet, SizeOf(Packet));
end;

end.
