unit DispatcherMBSlavePollingThreadClasses;

{$mode objfpc}{$H+}

interface

uses Classes, SyncObjs,
     MBDefine,
     DispatcherModbusItf ,DispatcherMBSlavePollingItemClasses,
     DispatcherDictionaryesClasses,
     SocketMyTypes, SocketSimpleTypes,
     LoggerItf;

const
  cLocalHostAddr = '127.0.0.1';

type

  TMBSlavePollingThread = class(TThreadLogged)
  private
   FCSection        : TCriticalSection;
   FItemDictinary   : TDictionaryTCPItemObject;
   FSlaveConnection : TBaseClientSocket;
   FConnectionParam : TMBTCPSlavePollingParam;
   FLastError       : Cardinal;
   procedure SetCSection(const Value: TCriticalSection);
   procedure SetItemDictinary( const Value: TDictionaryTCPItemObject);
   procedure Lock;
   procedure UnLock;
   procedure InitThread;
   procedure CloseThread;
   procedure Reconnect;
   procedure ReadResponse(RspBuff : Pointer; RespSize : Cardinal; Item : TMBSlavePollingItem);
   procedure SendErrorToAll(ErrorType : TMBDispEventEnum; ErrorCode : Cardinal);
   procedure SetLastAllItemError(ErrorCode : Cardinal);
   procedure SetLastResponseNilToAllItem;
   procedure SendError(Item : TMBSlavePollingItem; ErrorType : TMBDispEventEnum; ErrorCode : Cardinal);
   procedure SendWordPacket(Item : TMBSlavePollingItem; Packet : array of Word);
   procedure SendBoolPacket(Item : TMBSlavePollingItem; Packet : array of Boolean);

   procedure OnSocketErrorProc(Source: TObject; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
   procedure OnConnectProc(ASender : TObject);
   procedure OnDisconnect(ASender : TObject);

   function  IsPackegesSame(Item : TMBSlavePollingItem; const NewPackege : Pointer; const PackegeSize : Cardinal): Boolean;
   procedure SaveLastPacket(Item : TMBSlavePollingItem; const Packege : Pointer; const PackegeSize : Cardinal);
  protected
   procedure Execute; override;
  public
   property CSection        : TCriticalSection read FCSection write SetCSection;
   property ItemDictinary   : TDictionaryTCPItemObject read FItemDictinary write SetItemDictinary;
   property ConnectionParam : TMBTCPSlavePollingParam read FConnectionParam write FConnectionParam;
   property LastError       : Cardinal read FLastError write FLastError;
  end;

implementation

uses SysUtils, SocketMisc, SocketErrorCode,
     {Библиотека MiscFunctions}
     ExceptionsTypes,
     MBReaderTCPPacketClasses, MBRequestTypes, DispatcherResStrings;

{ TMBSlavePollingThread }

procedure TMBSlavePollingThread.Execute;
var TempItem     : TObject;
    TempBuff     : Pointer;
    TempBuffSize : Cardinal;
    ReadRes      : Cardinal;
    TempRequest  : PMBTCPF1RequestNew;
    TempRequestSize : Cardinal;
    TempTransNum : Word;
    WaitRes      : TWaitResult;
    SendRes      : Integer;
    Counter      : Integer;
    TempInterval : Cardinal;
    TempReconnect: Cardinal;

  function CheckResultNil(ARes : Cardinal; MessCode : Cardinal): Boolean;
  begin
   Result := False;
   if ARes = 0 then
    begin
     SendErrorToAll(mdeeSocketError,MessCode); // код ошибки на нулевой размер пришедших данных - разрыв соединения
     FSlaveConnection.Active := False;
     Result := True;
    end;
  end;

begin
  TempBuff     := GetMem(1024);
  TempBuffSize := 1024;

  InitThread;

  TempInterval  := FConnectionParam.PoolingTimeParam.Interval;
  TempReconnect := FConnectionParam.PoolingTimeParam.ReconnectInterval;

  try
   while not Terminated do
    begin
     Sleep(TempInterval);
     if Terminated then Break;
     try
      Lock;
      try
       // пытаемся восстановить соединение
       if not FSlaveConnection.Active then
        begin
         SetLastResponseNilToAllItem;
         SendLogMessage(llInfo,rsDispThread,Format(rsEDispThread1,[FSlaveConnection.Address,TempReconnect/1000]));
         Sleep(TempReconnect);
         Reconnect;
         if not FSlaveConnection.Active then
          begin
           //SendLogMessage(llError,rsDispThread,Format(rsEDispThread2,[FSlaveConnection.Address]));
           Continue;
          end;
        end;

       for TempItem in FItemDictinary.Values do
        begin
         // чистим буфер
         FillByte(TempBuff^,TempBuffSize,0);

         // пропускаем не активные итемы
         if not TMBSlavePollingItem(TempItem).Active then Continue;

         // получаем запрос
         TempRequest  := TMBSlavePollingItem(TempItem).Request;
         // инкремент номера тразакции
         TempTransNum := Swap(TempRequest^.TCPHeader.TransactioID);
         try
          Inc(TempTransNum);
         except
          TempTransNum := 0;
         end;
         TempRequest^.TCPHeader.TransactioID := Swap(TempTransNum);
         // подмена номера тразакции в последнем ответе дабы исключить его из сравнения
         TempRequest := TMBSlavePollingItem(TempItem).LastResponse;
         if TempRequest <> nil then TempRequest^.TCPHeader.TransactioID:= Swap(TempTransNum);
         // снова получаем запрос
         TempRequest     := TMBSlavePollingItem(TempItem).Request;
         TempRequestSize := TMBSlavePollingItem(TempItem).RequestSize;

         // передача запроса
         SendRes := FSlaveConnection.SendBuf(TempRequest^,TempRequestSize);
         if Cardinal(SendRes) <> TempRequestSize then  // количество отправленных байт
          begin
           case SendRes of
            -1  : begin
                   SendLogMessage(llError,rsDispThread,Format(rsEDispThread3,[FSlaveConnection.LastWaitError]));
                   SendErrorToAll(mdeeSocketError,FSlaveConnection.LastWaitError);
                   FSlaveConnection.Active := False;
                   Break; // выходим из цикла при ошибке отсылки
                  end
           else
            { при не полной отправке данных необходимо дождаться возможного ответа, но об ошибке
            сообщить необходимо}
            SendError(TMBSlavePollingItem(TempItem),mdeeSend,ER_SLAVE_SENT_NOT_FULL);
           end;
          end;
         // устанавливаем время ожидания
         FSlaveConnection.SelectTimeOut  := TMBSlavePollingItem(TempItem).ItemProp.SlaveParams.PoolingTimeParam.TimeOut;
         // ждем прихода ответа
         WaitRes := wrAbandoned;
         Counter := 0;
         while (Counter <= 5) do
          begin
           WaitRes := FSlaveConnection.WaiteReceiveData;
           if (WaitRes = wrSignaled) then Break;
           Inc(Counter);
           if Terminated then Break;
          end;
         // проверяем на то что не дождались ответа
         if (WaitRes <> wrSignaled) or (Counter >=5) then
          begin
           SendLogMessage(llDebug,rsDispThread,Format(rsEDispThread4,
                                                      [TempRequest^.Header.DeviceInfo.DeviceAddress,
                                                       swap(TempRequest^.Header.RequestData.StartingAddress),
                                                       swap(TempRequest^.Header.RequestData.Quantity)
                                                      ]));
           SendError(TMBSlavePollingItem(TempItem),mdeeReceive,ER_SLAVE_ANSVER_TIMEOUT);
           FSlaveConnection.Active := False;
           Break; // не дождались ответа - пробуем следующий итем
          end;
         // читаем ответ
         ReadRes := FSlaveConnection.GetQuantityDataCame; // получаем количество пришедших данных
         if CheckResultNil(ReadRes,ER_SLAVE_CONNECT_BROKEN) then // проверяем количество на 0
          begin
           // скорей всего соединение с сервером разорвано
           FSlaveConnection.Active := False; // закрываем соединение и выходим из цикла
           Break;
          end;
         if ReadRes > TempBuffSize then ReadRes := TempBuffSize; // надо подумать об вычитке всего блока пришедших данных - иначе часть данных теряется
         ReadRes := FSlaveConnection.ReceiveBuf(TempBuff^, ReadRes);
         if Terminated then Break;
         if CheckResultNil(ReadRes,ER_SLAVE_CONNECT_BROKEN) then
          begin
           SendLogMessage(llError,rsDispThread,rsEDispThread5);
           // скорей всего соединение с сервером разорвано
           FSlaveConnection.Active := False; // закрываем соединение и выходим из цикла
           Break;
          end;
         // разбираем ответ и отсылаем подписчикам оповещение об изменении состояния объекта
         try
          ReadResponse(TempBuff,ReadRes,TMBSlavePollingItem(TempItem));
         except
          on E : Exception do
           begin
            SendLogMessage(llError,rsDispThread, Format(rsEDispThread6,[E.Message]));
           end;
         end;

         if Terminated then Break;
      end;
     finally
      UnLock;
     end;
    except
     on E : Exception do
      begin
       SendLogMessage(llError,rsDispThread, Format(rsEDispThread7,[E.Message]));
      end;
    end;
   end;
  finally
   FreeMem(TempBuff);
   CloseThread;
  end;
end;

procedure TMBSlavePollingThread.ReadResponse(RspBuff: Pointer; RespSize: Cardinal; Item: TMBSlavePollingItem);
var TempWordArray : array of Word;
    TempBoolArray : array of Boolean;
    TempF1Reader : TReaderMBTCPF1Packet;
    TempF2Reader : TReaderMBTCPF2Packet;
    TempF3Reader : TReaderMBTCPF3Packet;
    TempF4Reader : TReaderMBTCPF4Packet;
    TempF5Reader : TReaderMBTCPF5Packet;
    TempF6Reader : TReaderMBTCPF6Packet;
    i,Count : Integer;
begin
   if (RspBuff = nil) or (RespSize =0) or (Item = nil) then Exit;

   // пришедший пакет не отличается от предыдущего
   if IsPackegesSame(Item,RspBuff,RespSize) then Exit;

   try
    case Item.ItemProp.Item.FunctNum of
     1: begin
         TempF1Reader := TReaderMBTCPF1Packet(Item.ResponseReader);
         TempF1Reader.Response(RspBuff,RespSize);
         if TempF1Reader.ErrorCode<>0 then
          begin
           SendError(Item,mdeeMBError,TempF1Reader.ErrorCode);
           Exit;
          end;
         Count := TempF1Reader.BitCount-1;
         SetLength(TempBoolArray, Count+1);
         for i := 0 to Count do TempBoolArray[i] :=TempF1Reader.Bits[i];
         SendBoolPacket(Item,TempBoolArray);
        end;
     2: begin
         TempF2Reader := TReaderMBTCPF2Packet(Item.ResponseReader);
         TempF2Reader.Response(RspBuff,RespSize);
         if TempF2Reader.ErrorCode<>0 then
          begin
           SendError(Item,mdeeMBError,TempF2Reader.ErrorCode);
           Exit;
          end;
         Count := TempF2Reader.BitCount-1;
         SetLength(TempBoolArray, Count+1);
         for i := 0 to Count do TempBoolArray[i] :=TempF2Reader.Bits[i];
         SendBoolPacket(Item,TempBoolArray);
        end;
     3: begin
         TempF3Reader := TReaderMBTCPF3Packet(Item.ResponseReader);
         TempF3Reader.Response(RspBuff,RespSize);
         if TempF3Reader.ErrorCode<>0 then
          begin
           SendError(Item,mdeeMBError,TempF3Reader.ErrorCode);

//           SendLogMessage(llWarning,'TMBSlavePollingThread.ReadResponse',Format('Устройство %d. Пришла ошибка %d',[TempF3Reader.DeviceAddress,TempF3Reader.ErrorCode]));

           Exit;
          end;
         Count := TempF3Reader.RegCount-1;
         SetLength(TempWordArray, Count+1);
         for i := 0 to Count do TempWordArray[i] :=TempF3Reader.RegValues[i];

//         SendLogMessage(llWarning,'TMBSlavePollingThread.ReadResponse',Format('Устройство %d. Пришли данные.',[TempF3Reader.DeviceAddress]));

         SendWordPacket(Item,TempWordArray);
        end;
     4: begin
         TempF4Reader := TReaderMBTCPF4Packet(Item.ResponseReader);
         TempF4Reader.Response(RspBuff,RespSize);
         if TempF4Reader.ErrorCode<>0 then
          begin
           SendError(Item,mdeeMBError,TempF4Reader.ErrorCode);
           Exit;
          end;
         Count := TempF4Reader.RegCount-1;
         SetLength(TempWordArray, Count+1);
         for i := 0 to Count do TempWordArray[i] :=TempF4Reader.RegValues[i];
         SendWordPacket(Item,TempWordArray);
        end;
     5: begin
         TempF5Reader := TReaderMBTCPF5Packet(Item.ResponseReader);
         TempF5Reader.Response(RspBuff,RespSize);
         if TempF5Reader.ErrorCode<>0 then
          begin
           SendError(Item,mdeeMBError,TempF5Reader.ErrorCode);
           Exit;
          end;
         SetLength(TempBoolArray, 1);
         TempBoolArray[0]:=TempF5Reader.Value;
         SendBoolPacket(Item,TempBoolArray);
        end;
     6: begin
         TempF6Reader := TReaderMBTCPF6Packet(Item.ResponseReader);
         TempF6Reader.Response(RspBuff,RespSize);
         if TempF6Reader.ErrorCode<>0 then
          begin
           SendError(Item,mdeeMBError,TempF6Reader.ErrorCode);
           Exit;
          end;
         SetLength(TempWordArray, 1);
         TempWordArray[0]:=TempF6Reader.Value;
         SendWordPacket(Item,TempWordArray);
        end;
    end;
   finally
    SetLength(TempWordArray, 0);
    SetLength(TempBoolArray, 0);
    SaveLastPacket(Item,RspBuff,RespSize);
   end;
end;

procedure TMBSlavePollingThread.InitThread;
begin
 FLastError := Cardinal(-1);
 try
  FSlaveConnection := TBaseClientSocket.Create;
  FSlaveConnection.Logger         := Logger;
  if FConnectionParam.SlaveAddr.IP.Addr = 0 then FSlaveConnection.Address := cLocalHostAddr
   else FSlaveConnection.Address := GetIPStr(FConnectionParam.SlaveAddr.IP.Addr);
  FSlaveConnection.Port           := FConnectionParam.SlaveAddr.Port;
  FSlaveConnection.SelectEnable   := False;
  FSlaveConnection.BlockingSocket := False;
  FSlaveConnection.OnError        := @OnSocketErrorProc;
  FSlaveConnection.OnConnect      := @OnConnectProc;
  FSlaveConnection.OnDisconnect   := @OnDisconnect;
  FSlaveConnection.Open;
//  if FSlaveConnection.Active then
//   begin
//    SendErrorToAll(mdeeConnect,0);
//    SendLogMessage(llInfo,rsDispESSOM,Format(rsDispESSOM1,[FSlaveConnection.Address,FSlaveConnection.Port]));
//   end;
 except
  on E : Exception do
   begin
    FLastError := FSlaveConnection.LastWaitError;
    if FLastError = 0 then FLastError := WSAETIMEDOUT;
    SendErrorToAll(mdeeConnect,FLastError);
   end;
 end;
end;

procedure TMBSlavePollingThread.CloseThread;
begin
  if Assigned(FSlaveConnection) then
   begin
//    SendLogMessage(llInfo,rsDispESSOM,Format(rsDispESSOM2,[FSlaveConnection.Address,FSlaveConnection.Port]));
    FreeAndNil(FSlaveConnection);
   end;
//  SendErrorToAll(mdeeDisconnect,0);
  FLastError := 0;//Cardinal(-1);
end;

function TMBSlavePollingThread.IsPackegesSame(Item : TMBSlavePollingItem; const NewPackege : Pointer; const PackegeSize : Cardinal): Boolean;
begin
  Result := False;
  if (NewPackege = nil) or (PackegeSize = 0) then Exit;
  if (Item.LastResponse = nil) or (Item.LastResponseSize = 0) then Exit;
  Result:=CompareMem(Item.LastResponse,NewPackege,PackegeSize);
end;

procedure TMBSlavePollingThread.SaveLastPacket(Item: TMBSlavePollingItem; const Packege: Pointer; const PackegeSize: Cardinal);
begin
  if (Packege = nil) or (PackegeSize = 0) then Exit;
  Item.SetLastResponse(Packege,PackegeSize);
end;

procedure TMBSlavePollingThread.Reconnect;
begin
  try
    FSlaveConnection.Active := False;
  except
   FLastError := FSlaveConnection.LastWaitError;
   if FLastError = 0 then FLastError := WSAETIMEDOUT;
   SendErrorToAll(mdeeDisconnect,FLastError);
  end;

  try
   FSlaveConnection.Active := True;
  except
   FLastError := FSlaveConnection.LastWaitError;
   if FLastError = 0 then FLastError := WSAETIMEDOUT;
   SendErrorToAll(mdeeDisconnect,FLastError);
  end;
end;

procedure TMBSlavePollingThread.Lock;
begin
  if not Assigned(FCSection) then Exit;
  FCSection.Enter;
end;

procedure TMBSlavePollingThread.UnLock;
begin
  if not Assigned(FCSection) then Exit;
  FCSection.Leave;
end;

procedure TMBSlavePollingThread.SendError(Item : TMBSlavePollingItem; ErrorType : TMBDispEventEnum; ErrorCode: Cardinal);
var i, Count : Integer;
begin
  Count := Item.CallBackItfCount-1;
  for i := 0 to Count do
   begin
    Item.CallBackItfs[i].SendEvent(Item.ItemProp,ErrorType,ErrorCode);
   end;
end;

procedure TMBSlavePollingThread.SendErrorToAll(ErrorType: TMBDispEventEnum; ErrorCode: Cardinal);
var TempItem : TObject;
begin
 for TempItem in FItemDictinary.Values do
  begin
   SendError(TMBSlavePollingItem(TempItem),ErrorType,ErrorCode);
  end;
end;

procedure TMBSlavePollingThread.SetLastAllItemError(ErrorCode : Cardinal);
var TempItem : TObject;
begin
 for TempItem in FItemDictinary.Values do
  begin
   TMBSlavePollingItem(TempItem).LastError := ErrorCode;
  end;
end;

procedure TMBSlavePollingThread.SetLastResponseNilToAllItem;
var TempItem : TObject;
begin
  for TempItem in FItemDictinary.Values do
   begin
    TMBSlavePollingItem(TempItem).SetLastResponse(nil,0);
   end;
end;

procedure TMBSlavePollingThread.SendWordPacket(Item: TMBSlavePollingItem; Packet: array of Word);
var i, Count : Integer;
begin
  Count := Item.CallBackItfCount-1;
  for i := 0 to Count do Item.CallBackItfs[i].ProcessWordRegChangesPackage(Item.ItemProp,Packet);
end;

procedure TMBSlavePollingThread.SendBoolPacket(Item: TMBSlavePollingItem; Packet: array of Boolean);
var i, Count : Integer;
begin
  Count := Item.CallBackItfCount-1;
  for i := 0 to Count do
   begin
    Item.CallBackItfs[i].ProcessBitRegChangesPackage(Item.ItemProp,Packet);
   end;
end;

procedure TMBSlavePollingThread.OnSocketErrorProc(Source : TObject; ErrorEvent : TErrorEvent; var ErrorCode : Integer);
begin
  SendErrorToAll(mdeeSocketError,ErrorCode);
  SendLogMessage(llError,rsDispESSOM,Format(rsDispESSOM3,[FSlaveConnection.Address,FSlaveConnection.Port,ErrorCode,SysErrorMessage(ErrorCode)]));
end;

procedure TMBSlavePollingThread.OnConnectProc(ASender : TObject);
begin
  SendErrorToAll(mdeeConnect,0);
  SendLogMessage(llInfo,rsDispESSOM,Format(rsDispESSOM1,[FSlaveConnection.Address,FSlaveConnection.Port]));
end;

procedure TMBSlavePollingThread.OnDisconnect(ASender : TObject);
begin
  SendErrorToAll(mdeeDisconnect,0);
  SendLogMessage(llInfo,rsDispESSOM,Format(rsDispESSOM2,[FSlaveConnection.Address,FSlaveConnection.Port]));
end;

procedure TMBSlavePollingThread.SetCSection(const Value: TCriticalSection);
begin
  FCSection := Value;
end;

procedure TMBSlavePollingThread.SetItemDictinary(const Value: TDictionaryTCPItemObject);
begin
  FItemDictinary := Value;
end;

end.
