unit DispatcherMBSlavePollingItemClasses;

{$mode objfpc}{$H+}

interface

uses Classes,
     MBDefine, MBReaderPacketClasses,
     DispatcherModbusItf;

type

 TMBSlavePollingItem = class
  private
   FActive           : Boolean;
   FItemProp         : TMBTCPSlavePollingItem;
   FCallBackItfList  : TInterfaceList;
   FRequest          : Pointer;
   FRequestSize      : Cardinal;
   FResponseReader   : TReaderMBTCPPacket;
   FLastResponse     : Pointer;
   FLastResponseSize : Cardinal;
   FLastError        : Cardinal;
   function  GetCallBackItf(Index: Integer): IMBDispCallBackItf;
   function  GetCallBackItfCount: Integer;

   procedure AllocRequestPackege;
   procedure CreateMBTCPReader;
  public
   constructor Create(ItemProp: TMBTCPSlavePollingItem); virtual;
   destructor  Destroy; override;

   function  AddCallBackItf(CallBack: IMBDispCallBackItf): Integer;
   procedure DelCallBackItf(CallBack: IMBDispCallBackItf);

   procedure SetLastResponse(const Value: Pointer; ResponseSize : Cardinal);

   property Active           : Boolean read FActive write FActive default True;
   property ItemProp         : TMBTCPSlavePollingItem read FItemProp;
   property Request          : Pointer read FRequest;  // ссылка на память содержащую запрос. Формируется при создании объекта. Разрушается(освобождается) при разрушении объекта. Содержимое зависит от запрашиваемой функции.
   property RequestSize      : Cardinal read FRequestSize;
   property ResponseReader   : TReaderMBTCPPacket read FResponseReader; // содержит объект-читатель соответствующий заданной функции
   property LastResponse     : Pointer read FLastResponse;   // ссылка на память с предыдущим ответом. используется при определении изменений данных на опрашиваемом устройстве
   property LastResponseSize : Cardinal read FLastResponseSize;
   property LastError        : Cardinal read FLastError write FLastError;
   property CallBackItfCount : Integer read GetCallBackItfCount;
   property CallBackItfs[Index : Integer] : IMBDispCallBackItf read GetCallBackItf; // список интерфейсов для пересылки изменений
  end;

  TMBSlavePollingItemArray = array of TMBSlavePollingItem;

implementation

uses SysUtils, MBRequestTypes, MBReaderTCPPacketClasses, DispatcherResStrings;

{ TMBSlavePollingItem }

constructor TMBSlavePollingItem.Create(ItemProp: TMBTCPSlavePollingItem);
begin
  FActive           := True;
  FItemProp         := ItemProp;
  FLastResponse     := nil;
  FLastResponseSize := 0;
  FCallBackItfList  := TInterfaceList.Create;

  AllocRequestPackege;
  CreateMBTCPReader;

  PMBTCPF1RequestNew(FRequest)^.TCPHeader.TransactioID             := 0;
  PMBTCPF1RequestNew(FRequest)^.TCPHeader.ProtocolID               := 0;
  PMBTCPF1RequestNew(FRequest)^.TCPHeader.Length                   := Swap(Word(FRequestSize - 6));
  PMBTCPF1RequestNew(FRequest)^.Header.DeviceInfo.DeviceAddress    := FItemProp.Item.DevNumber;
  PMBTCPF1RequestNew(FRequest)^.Header.DeviceInfo.FunctionCode     := FItemProp.Item.FunctNum;
  PMBTCPF1RequestNew(FRequest)^.Header.RequestData.StartingAddress := Swap(FItemProp.Item.StartAddr);
  PMBTCPF1RequestNew(FRequest)^.Header.RequestData.Quantity        := Swap(FItemProp.Item.Quantity);

  FResponseReader.SourceDevice   := FItemProp.Item.DevNumber;
end;

destructor TMBSlavePollingItem.Destroy;
begin
  if Assigned(FLastResponse) then FreeMem(FLastResponse);
  if Assigned(FRequest) then FreeMem(FRequest);
  FreeAndNil(FResponseReader);
  FreeAndNil(FCallBackItfList);
  inherited;
end;

procedure TMBSlavePollingItem.CreateMBTCPReader;
begin
  case FItemProp.Item.FunctNum of
   1 : begin
        FResponseReader := TReaderMBTCPF1Packet.Create(nil);
       end;
   2 : begin
        FResponseReader := TReaderMBTCPF2Packet.Create(nil);
       end;
   3 : begin
        FResponseReader := TReaderMBTCPF3Packet.Create(nil);
       end;
   4 : begin
        FResponseReader := TReaderMBTCPF4Packet.Create(nil);
       end;
   5 : begin
        FResponseReader := TReaderMBTCPF5Packet.Create(nil);
       end;
   6 : begin
        FResponseReader := TReaderMBTCPF6Packet.Create(nil);
       end;
  else
   raise Exception.CreateFmt(rsECreateReader,[FItemProp.Item.FunctNum]);
  end;
end;

procedure TMBSlavePollingItem.AllocRequestPackege;
begin
  case FItemProp.Item.FunctNum of
   1,2,3,4,5,6 : begin
                  FRequestSize := SizeOf(TMBTCPF1RequestNew);
                  FRequest := AllocMem(FRequestSize);
                 end;
  else
   raise Exception.CreateFmt(rsEAllocPackage,[FItemProp.Item.FunctNum]);
  end;
end;

function TMBSlavePollingItem.AddCallBackItf( CallBack: IMBDispCallBackItf): Integer;
begin
  Result := FCallBackItfList.Add(CallBack);
end;

procedure TMBSlavePollingItem.DelCallBackItf(CallBack: IMBDispCallBackItf);
var i : Integer;
begin
  i := FCallBackItfList.IndexOf(CallBack);
  if i = -1 then Exit;
  FCallBackItfList.Delete(i);
end;

function TMBSlavePollingItem.GetCallBackItf(Index: Integer): IMBDispCallBackItf;
begin
 Result := FCallBackItfList.Items[Index] as IMBDispCallBackItf;
end;

function TMBSlavePollingItem.GetCallBackItfCount: Integer;
begin
 Result := FCallBackItfList.Count;
end;

procedure TMBSlavePollingItem.SetLastResponse(const Value: Pointer; ResponseSize : Cardinal);
begin
  if Assigned(FLastResponse) then
   begin
    FreeMem(FLastResponse);
    FLastResponse := nil;
    FLastResponseSize := 0;
   end;
  if (Value = nil) or (ResponseSize = 0) then
   begin
    FreeMem(FLastResponse);
    FLastResponse := nil;
    FLastResponseSize := 0;
    Exit;
   end;
  FLastResponse := AllocMem(ResponseSize);
  Move(Value^,FLastResponse^,ResponseSize);
  FLastResponseSize := ResponseSize;
end;


end.
