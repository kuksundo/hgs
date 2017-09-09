unit DispatcherModbusDeviceClasses;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils, syncobjs,
     LoggerItf,
     MBDefine, MBDeviceClasses,
     DispatcherModbusItf, DispatcherModbusDeviceSubscriberClasses,
     NativeXml;

type

  TMBTCPSlavePollingItemArray = array of TMBTCPSlavePollingItem;

  { TDispatcherModbusDevice }

  TDispatcherModbusDevice = class(TComponentLogged, IMBDispDeviceTCPItf, IMBDispCallBackItf)
   private
    FDeviceCS                 : TCriticalSection;
    FObjectID                 : String;

    FTCPDevice                : TMBTCPDevice;
    FDevicePollItms           : TMBTCPSlavePollingItemArray;
    FDeviceID                 : String;
    FDeviceCaption            : String;

    FSubscribers              : TDeviceSubscribers;

    FRangesDiscret            : TDeviceRangeArray;
    FRangesCoil               : TDeviceRangeArray;
    FRangesInput              : TDeviceRangeArray;
    FRangesHolding            : TDeviceRangeArray;

    FPoolingInterval          : Integer;
    FPoolingReconnectInterval : Integer;
    FPoolingTimeOut           : Integer;

    FDispatcherItf            : IMBDispatcherItf;

    FOnPollingError           : TPollingError;
    FOnPollingEvent           : TPollingEvent;

    function GetRangesCoilCount: Integer;
    function GetRangesCoilItem(Index : Integer): TDeviceRangeItem;
    function GetRangesDiscretCount: Integer;
    function GetRangesDiscretItem(Index : Integer): TDeviceRangeItem;
    function GetRangesHoldingCount: Integer;
    function GetRangesHoldingItem(Index : Integer): TDeviceRangeItem;
    function GetRangesInputCount: Integer;
    function GetRangesInputItem(Index : Integer): TDeviceRangeItem;
   protected
    property DispatcherItf    : IMBDispatcherItf read FDispatcherItf;

    // IMBDispCallBackItf
    // извещение об обновлении битовых регистров
    procedure ProcessBitRegChangesPackage(ItemProp : TMBTCPSlavePollingItem; Package : array of Boolean); stdcall;
    // извещения об обновлении вордовых регистров
    procedure ProcessWordRegChangesPackage(ItemProp : TMBTCPSlavePollingItem; Package : array of Word); stdcall;
    // извещение о событии устройства
    procedure SendEvent(ItemProp : TMBTCPSlavePollingItem; EvType : TMBDispEventEnum; Code1 : Cardinal = 0; Code2 : Cardinal = 0); stdcall;

    //IMBDispDeviceTCPItf
    function  GetDeviceIP : Cardinal; stdcall;
    function  GetDevicePort : Word; stdcall;
    function  GetDeviceNum : Byte; stdcall;

    function  GetCoilValue(ARegNumber : Word) : Boolean; stdcall;
    function  GetDiscretValue(ARegNumber : Word) : Boolean; stdcall;
    function  GetHoldingValue(ARegNumber : Word) : Word; stdcall;
    function  GetInputValue(ARegNumber : Word) : Word; stdcall;

    procedure SetCoilValue(ARegNumber : Word; AValue : Boolean); stdcall;
    procedure SetDiscretValue(ARegNumber : Word; AValue : Boolean); stdcall;
    procedure SetHoldingValue(ARegNumber : Word; AValue : Word); stdcall;
    procedure SetInputValue(ARegNumber : Word; AValue : Word); stdcall;

    // функции загрузки
    procedure DevFunctionsFromXML(ParamXML : TXMLNode);

    procedure DiscretRangesFromXML(ParamXML: TXMLNode);
    procedure CoilRangesFromXML(ParamXML : TXMLNode);
    procedure InputRangesFromXML(ParamXML : TXMLNode);
    procedure HoldingRangesFromXML(ParamXML : TXMLNode);

    function  SearchInRange(ARange : TDeviceRangeArray; ARangeID : String) : Integer;

    // генерация списка структур для подписки у диспетчера
    procedure GeneretePollingItems;
   public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;

    procedure Lock;
    procedure UnLock;

    procedure AddRange(ARangeType: TRegMBTypes; ARegStart, ARegQuantity: Word);

    // подписка устройства на получение данных от диспетчера
    procedure SubscribeToUpdates(ADispetcherItf : IMBDispatcherItf);
    // снятие подписки устройства на получение данных от диспетчера
    procedure UnsubscribeToUpdates;
    // загрузка параметров устройства из конфигурационного файла
    procedure LoadFromXML(AIPAddr : String; APort : Word; ADeviceTag : TXmlNode); virtual;
    // поиск заданного интервала переменных
    function  SearchRangeItem(ARangeID : String) : TDeviceRangeItem;
    // получить идетенфикатор секции переменных
    function  GetRangeItemID(ARangeType: TRegMBTypes; ARegStart, ARegQuantity: Word) : String;
    // устанавливаем подписсчиков на изменения регистров
    procedure SetDataSubscribers(ASubscribers : TDeviceSubscribers);

    // идентификатор объекта к которому принадлежит устройство
    property ObjectID                 : String read FObjectID write FObjectID;
    // объект модели устройства
    property Device                   : TMBTCPDevice read FTCPDevice;
    // идентификатор устройства
    property DeviceID                 : String read FDeviceID write FDeviceID;
    // заголовок устройства
    property DeviceCaption            : String read FDeviceCaption write FDeviceCaption;
    // критическая секция устройства
    property DeviceCS                 : TCriticalSection read FDeviceCS;
    // период опроса
    property PoolingInterval          : Integer read FPoolingInterval write FPoolingInterval;
    // интервал повторного коннекта при обрыве соединения
    property PoolingReconnectInterval : Integer read FPoolingReconnectInterval write FPoolingReconnectInterval;
    // таймаут ожидания прихода ответа
    property PoolingTimeOut           : Integer read FPoolingTimeOut write FPoolingTimeOut;

    property RangesDiscretCount       : Integer read GetRangesDiscretCount;
    property RangesCoilCount          : Integer read GetRangesCoilCount;
    property RangesInputCount         : Integer read GetRangesInputCount;
    property RangesHoldingCount       : Integer read GetRangesHoldingCount;

    property RangesDiscret[Index : Integer] : TDeviceRangeItem read GetRangesDiscretItem;
    property RangesCoil[Index : Integer]    : TDeviceRangeItem read GetRangesCoilItem;
    property RangesInput[Index : Integer]   : TDeviceRangeItem read GetRangesInputItem;
    property RangesHolding[Index : Integer] : TDeviceRangeItem read GetRangesHoldingItem;

    property Subscribers  : TDeviceSubscribers read FSubscribers write SetDataSubscribers;

    property OnPollingError           : TPollingError read FOnPollingError write FOnPollingError;
    property OnPollingEvent           : TPollingEvent read FOnPollingEvent write FOnPollingEvent;
  end;

implementation

uses SocketMisc,
     DispatcherResStrings,
     {Библиотека MiscFunctions}
     XMLConsts,
     ExceptionsTypes;

{ TDispatcherModbusDevice }

constructor TDispatcherModbusDevice.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTCPDevice     := TMBTCPDevice.Create(nil);
  FDispatcherItf := nil;
  FDeviceCS      := TCriticalSection.Create;
  FSubscribers   := nil;
  SetLength(FDevicePollItms,0);
end;

destructor TDispatcherModbusDevice.Destroy;
begin
  if Assigned(FDispatcherItf) then
   begin
    try
     UnsubscribeToUpdates;
    except
     on E : Exception do
      begin
       SendLogMessage(llError,rsEDestroy1,Format(rsEDestroy2,[E.Message]));
      end;
    end;
   end;
  FSubscribers := nil;
  FDispatcherItf := nil;
  SetLength(FDevicePollItms,0);
  SetLength(FRangesDiscret,0);
  SetLength(FRangesCoil,0);
  SetLength(FRangesInput,0);
  SetLength(FRangesHolding,0);
  FreeAndNil(FTCPDevice);
  FreeAndNil(FDeviceCS);
  inherited Destroy;
end;

procedure TDispatcherModbusDevice.Lock;
begin
  FDeviceCS.Enter;
end;

procedure TDispatcherModbusDevice.UnLock;
begin
  FDeviceCS.Leave;
end;

procedure TDispatcherModbusDevice.AddRange(ARangeType: TRegMBTypes; ARegStart, ARegQuantity: Word);
var TempItf : IMBDispatcherItf;
begin
   FTCPDevice.AddRegisters(ARangeType,ARegStart,ARegQuantity);
   if not Assigned(FDispatcherItf) then Exit;

   SendLogMessage(llDebug,rsDevDebug1,Format(rsDevDebug2,[ARegStart,ARegQuantity]));

   GeneretePollingItems;
   TempItf := FDispatcherItf;
   SubscribeToUpdates(TempItf);
end;

function TDispatcherModbusDevice.GetRangesCoilCount: Integer;
begin
  Result := Length(FRangesCoil);
end;

function TDispatcherModbusDevice.GetRangesCoilItem(Index : Integer): TDeviceRangeItem;
begin
  Result := FRangesCoil[Index];
end;

function TDispatcherModbusDevice.GetRangesDiscretCount: Integer;
begin
  Result := Length(FRangesDiscret);
end;

function TDispatcherModbusDevice.GetRangesDiscretItem(Index : Integer): TDeviceRangeItem;
begin
  Result := FRangesDiscret[Index];
end;

function TDispatcherModbusDevice.GetRangesHoldingCount: Integer;
begin
  Result := Length(FRangesHolding);
end;

function TDispatcherModbusDevice.GetRangesHoldingItem(Index : Integer): TDeviceRangeItem;
begin
  Result := FRangesHolding[Index];
end;

function TDispatcherModbusDevice.GetRangesInputCount: Integer;
begin
  Result := Length(FRangesInput);
end;

function TDispatcherModbusDevice.GetRangesInputItem(Index : Integer): TDeviceRangeItem;
begin
  Result := FRangesInput[Index];
end;

procedure TDispatcherModbusDevice.ProcessBitRegChangesPackage(ItemProp: TMBTCPSlavePollingItem; Package: array of Boolean); stdcall;
var i,Count   : Integer;
    TempAddr  : Word;
    TempSustr : TSubscribersArray;
begin
  Lock;
  try
   if ItemProp.Item.DevNumber <> FTCPDevice.DeviceNum then
    begin
     SendLogMessage(llError,rsEPBRCPack1,Format(rsEPBRCPack2,[FTCPDevice.DeviceNum,ItemProp.Item.DevNumber]));
     Exit;
    end;
   Count := Length(Package)-1;
   if (Count+1) <> ItemProp.Item.Quantity then
    begin
     SendLogMessage(llError,rsEPBRCPack1,Format(rsEPBRCPack3,[ItemProp.Item.Quantity, Count+1]));
     Exit;
    end;
   case ItemProp.Item.FunctNum of
    1 : begin
         FTCPDevice.BeginPacketUpdate;
         for i := 0 to Count do
          begin
           try
            TempAddr := ItemProp.Item.StartAddr+i;
            if FTCPDevice.Coils[TempAddr].Value <> Package[i] then
             begin
              FTCPDevice.Coils[TempAddr].ServerSideSetValue(Package[i]);
              if not Assigned(FSubscribers) then Continue;
              if FTCPDevice.Coils[TempAddr].IsChanged then
               begin
                FSubscribers.CheckCoilReg(TempAddr);
                FTCPDevice.Coils[TempAddr].IsChanged := False;
               end;
             end;
           except
            on E : Exception do
             begin
              SendLogMessage(llError,rsEPBRCPack1,Format(rsEPBRCPack4,[E.Message]));
             end;
           end;
          end;
         FTCPDevice.EndPacketUpdate;
        end;
    2 : begin
         FTCPDevice.BeginPacketUpdate;
         for i := 0 to Count do
          begin
           try
            TempAddr := ItemProp.Item.StartAddr+i;
            if FTCPDevice.Discrets[TempAddr].Value <> Package[i] then
             begin
              FTCPDevice.Discrets[TempAddr].ServerSideSetValue(Package[i]);
              if not Assigned(FSubscribers) then Continue;
              if FTCPDevice.Discrets[TempAddr].IsChanged then
               begin
                FSubscribers.CheckDiskretReg(TempAddr);
                FTCPDevice.Discrets[TempAddr].IsChanged := False;
               end;
             end;
           except
            on E : Exception do
             begin
              SendLogMessage(llError,rsEPBRCPack1,Format(rsEPBRCPack4,[E.Message]));
             end;
           end;
          end;
         FTCPDevice.EndPacketUpdate;
        end;
   else
    SendLogMessage(llError,rsEPBRCPack1,Format(rsEPBRCPack6,[ItemProp.Item.FunctNum]));
   end;

   if Assigned(FSubscribers) then
    begin
     TempSustr := FSubscribers.GetChengedSubscribers;
     Count := Length(TempSustr)-1;
     for i := 0 to Count do TempSustr[i].Notify;
     SetLength(TempSustr,0);
    end;

   if ItemProp.LastError <> 0 then
    begin
     if not Assigned(FOnPollingError) then Exit;
     ItemProp.LastError := 0;
     FOnPollingError(ItemProp);
    end;

  finally
   UnLock;
  end;
end;

procedure TDispatcherModbusDevice.ProcessWordRegChangesPackage(ItemProp: TMBTCPSlavePollingItem; Package: array of Word); stdcall;
var i,Count  : Integer;
    TempAddr : Word;
    TempSustr : TSubscribersArray;
begin
  Lock;
  try
   if ItemProp.Item.DevNumber <> FTCPDevice.DeviceNum then
    begin
     SendLogMessage(llError,rsEPWRCPack1,Format(rsEPBRCPack2,[FTCPDevice.DeviceNum,ItemProp.Item.DevNumber]));
     Exit;
    end;
   Count := Length(Package)-1;
   if (Count+1) <> ItemProp.Item.Quantity then
    begin
     SendLogMessage(llError,rsEPWRCPack1,Format(rsEPBRCPack3,[ItemProp.Item.Quantity, Count+1]));
     Exit;
    end;
   case ItemProp.Item.FunctNum of
    3 : begin
         FTCPDevice.BeginPacketUpdate;
         for i := 0 to Count do
          begin
           try
            TempAddr := ItemProp.Item.StartAddr+i;
            if FTCPDevice.Holdings[TempAddr].Value <> Package[i] then
             begin
              FTCPDevice.Holdings[TempAddr].ServerSideSetValue(Package[i]);
              if not Assigned(FSubscribers) then Continue;
              if FTCPDevice.Holdings[TempAddr].IsChanged then
               begin
                FSubscribers.CheckHoldingReg(TempAddr);
                FTCPDevice.Holdings[TempAddr].IsChanged := False;
               end;
             end;
           except
            on E : Exception do
             begin
              SendLogMessage(llError,rsEPBRCPack1,Format(rsEPBRCPack4,[E.Message]));
             end;
           end;
          end;
         FTCPDevice.EndPacketUpdate;
        end;
    4 : begin
         FTCPDevice.BeginPacketUpdate;
         for i := 0 to Count do
          begin
           try
            TempAddr := ItemProp.Item.StartAddr+i;
            if FTCPDevice.Inputs[TempAddr].Value <> Package[i] then
             begin
              FTCPDevice.Inputs[TempAddr].ServerSideSetValue(Package[i]);
              if not Assigned(FSubscribers) then Continue;
              if FTCPDevice.Inputs[TempAddr].IsChanged then
               begin
                FSubscribers.CheckDiskretReg(TempAddr);
                FTCPDevice.Inputs[TempAddr].IsChanged := False;
               end;
             end;
           except
            on E : Exception do
             begin
              SendLogMessage(llError,rsEPWRCPack1,Format(rsEPBRCPack4,[E.Message]));
             end;
           end;
          end;
         FTCPDevice.EndPacketUpdate;
        end;
   else
    SendLogMessage(llError,rsEPWRCPack1,Format(rsEPBRCPack6,[ItemProp.Item.FunctNum]));
   end;

   if Assigned(FSubscribers) then
    begin
     TempSustr := FSubscribers.GetChengedSubscribers;
     Count := Length(TempSustr)-1;
     for i := 0 to Count do TempSustr[i].Notify;
     SetLength(TempSustr,0);
    end;

   if ItemProp.LastError <> 0 then
    begin
     if not Assigned(FOnPollingError) then Exit;
     ItemProp.LastError := 0;
     FOnPollingError(ItemProp);
    end;

  finally
   UnLock;
  end;
end;

procedure TDispatcherModbusDevice.SendEvent(ItemProp: TMBTCPSlavePollingItem; EvType: TMBDispEventEnum; Code1: Cardinal; Code2: Cardinal); stdcall;
begin
  Lock;
  try
   if ItemProp.Item.DevNumber <> FTCPDevice.DeviceNum then Exit;
   case EvType of
    mdeeConnect     : begin
                       if Assigned(FOnPollingEvent) then FOnPollingEvent(ItemProp,EvType);
                       SendLogMessage(llDebug,rsDevDebug3,Format(rsDevDebug4,[ItemProp.RangeID, ItemProp.Item.DevNumber,Code1,Code2]));
                      end;
    mdeeDisconnect  : begin
                       if Assigned(FOnPollingEvent) then FOnPollingEvent(ItemProp,EvType);
                       FTCPDevice.InitializeDevice;
                       SendLogMessage(llDebug,rsDevDebug3,Format(rsDevDebug5,[ItemProp.RangeID, ItemProp.Item.DevNumber,Code1,Code2]));
                      end;
    mdeeReceive     : begin
                       if Assigned(FOnPollingEvent) then FOnPollingEvent(ItemProp,EvType);
                       SendLogMessage(llDebug,rsDevDebug3,Format(rsDevDebug6,[ItemProp.RangeID, ItemProp.Item.DevNumber,Code1,Code2]));
                      end;
    mdeeSend        : begin
                       if Assigned(FOnPollingEvent) then FOnPollingEvent(ItemProp,EvType);
                       SendLogMessage(llDebug,rsDevDebug3,Format(rsDevDebug7,[ItemProp.RangeID, ItemProp.Item.DevNumber,Code1,Code2]));
                      end;
    mdeeMBError     : begin
                       ItemProp.LastError := Code1;
                       FTCPDevice.InitializeDevice;
                       if Assigned(FOnPollingError) then FOnPollingError(ItemProp);
                       SendLogMessage(llDebug,rsDevDebug3,Format(rsDevDebug8,[ItemProp.RangeID, ItemProp.Item.DevNumber,Code1,Code2]));
                      end;
    mdeeSocketError : begin
                       ItemProp.LastError := Code1;
                       FTCPDevice.InitializeDevice;
                       if Assigned(FOnPollingError) then FOnPollingError(ItemProp);
                       SendLogMessage(llDebug,rsDevDebug3,Format(rsDevDebug9,[ItemProp.RangeID, ItemProp.Item.DevNumber,Code1,Code2]));
                      end;
   end;
  finally
   UnLock;
  end;
end;

function TDispatcherModbusDevice.GetDeviceIP: Cardinal; stdcall;
begin
  Lock;
  try
   Result := FTCPDevice.IPAddress;
  finally
   UnLock;
  end;
end;

function TDispatcherModbusDevice.GetDevicePort: Word; stdcall;
begin
  Lock;
  try
   Result := FTCPDevice.IPPort;
  finally
   UnLock;
  end;
end;

function TDispatcherModbusDevice.GetDeviceNum: Byte; stdcall;
begin
  Lock;
  try
   Result := FTCPDevice.DeviceNum;
  finally
   UnLock;
  end;
end;

function TDispatcherModbusDevice.GetCoilValue(ARegNumber: Word): Boolean; stdcall;
begin
  Lock;
  try
   Result := FTCPDevice.Coils[ARegNumber].Value;
  finally
   UnLock;
  end;
end;

function TDispatcherModbusDevice.GetDiscretValue(ARegNumber: Word): Boolean; stdcall;
begin
  Lock;
  try
   Result := FTCPDevice.Discrets[ARegNumber].Value;
  finally
   UnLock;
  end;
end;

function TDispatcherModbusDevice.GetHoldingValue(ARegNumber: Word): Word; stdcall;
begin
  Lock;
  try
   Result := FTCPDevice.Holdings[ARegNumber].Value;
  finally
   UnLock;
  end;
end;

function TDispatcherModbusDevice.GetInputValue(ARegNumber: Word): Word; stdcall;
begin
  Lock;
  try
   Result := FTCPDevice.Inputs[ARegNumber].Value;
  finally
   UnLock;
  end;
end;

procedure TDispatcherModbusDevice.SetCoilValue(ARegNumber: Word; AValue: Boolean ); stdcall;
var Res : Boolean;
begin
  Lock;
  try
   if not Assigned(FDispatcherItf) then
    begin
     FTCPDevice.Coils[ARegNumber].ServerSideSetValue(AValue);
     SendLogMessage(llError,rsESetCoilValue,rsEItfDisp);
    end
   else
    begin
     try
      Res := FDispatcherItf.SetCoilValue(Self as IMBDispDeviceTCPItf,ARegNumber,AValue);
     except
      on E : Exception do
       begin
        raise Exception.CreateFmt(rsSetCoilValue1,[ARegNumber,E.Message]);
       end;
     end;
     if not Res then raise Exception.CreateFmt(rsSetCoilValue2,[ARegNumber]);
    end;
  finally
   UnLock;
  end;
end;

procedure TDispatcherModbusDevice.SetInputValue(ARegNumber: Word; AValue: Word); stdcall;
var Res : Boolean;
begin
  Lock;
  try
   if not Assigned(FDispatcherItf) then
    begin
     FTCPDevice.Inputs[ARegNumber].ServerSideSetValue(AValue);
     SendLogMessage(llError,rsESetInputValue,rsEItfDisp);
    end
   else
    begin
     try
      Res := FDispatcherItf.SetInputValue(Self as IMBDispDeviceTCPItf,ARegNumber,AValue);
     except
      on E : Exception do
       begin
        raise Exception.CreateFmt(rsSetInputValue1,[ARegNumber,E.Message]);
       end;
     end;
     if not Res then raise Exception.CreateFmt(rsSetInputValue2,[ARegNumber]);
    end;
  finally
   UnLock;
  end;
end;

procedure TDispatcherModbusDevice.SetDiscretValue(ARegNumber: Word; AValue: Boolean); stdcall;
begin

  raise Exception.Create(rsSetDiskretValue1);

{  Lock;
  try
   if not Assigned(FDispatcherItf) then
    begin
     FTCPDevice.Discrets[ARegNumber].ServerSideSetValue(AValue);
     SendLogMessage(llError,rsESetDiscretValue,rsEItfDisp);
    end
   else
    begin
     raise Exception.Create('Не реализована функция записи в диспетчере соединений.');
    end;
  finally
   UnLock;
  end;}
end;

procedure TDispatcherModbusDevice.SetHoldingValue(ARegNumber: Word; AValue: Word); stdcall;
begin

  raise Exception.Create(rsSetHoldingValue1);

{  Lock;
  try
   if not Assigned(FDispatcherItf) then
    begin
     FTCPDevice.Holdings[ARegNumber].ServerSideSetValue(AValue);
     SendLogMessage(llError,rsESetHoldingValue,rsEItfDisp);
    end
   else
    begin
     raise Exception.Create('Modbus Holding-регистры являются регистрами только для чтения.');
    end;
  finally
   UnLock;
  end;}
end;

procedure TDispatcherModbusDevice.DevFunctionsFromXML(ParamXML: TXMLNode);
var i, Count : Integer;
    TempNode : TXmlNode;
begin
  if ParamXML=nil then raise EDevSaveParamXMLNotAssigned.Create;
  FTCPDevice.DeviceFunctions := [];
  Count := ParamXML.NodeCount-1;
  if Count = -1 then raise EXMLLoadDevFuncNotAssign.Create;
  for i:=0 to Count do
   begin
    TempNode:=ParamXML.Nodes[i];
    if not SameText(TempNode.Name,csXMLMBFunction) then Continue;
    FTCPDevice.DeviceFunctions:=FTCPDevice.DeviceFunctions+[TMBFunctionsEnum(TempNode.AttributeByName[csXMLValue].ValueAsInteger)];
   end;
end;

procedure TDispatcherModbusDevice.DiscretRangesFromXML(ParamXML: TXMLNode);
var i, Count      : Integer;
    TempNode      : TXmlNode;
    TempRange     : TMBRegistersRangeClassic;
    TempAttr      : TsdAttribute;
    TempRangeItem : TDeviceRangeItem;
begin
  if ParamXML=nil then raise EDevLoadParamXMLNotAssigned.Create('MBDiscretRanges');
  Count:=ParamXML.NodeCount-1;
  for i:=0 to Count do
   begin
    TempNode:=ParamXML.Nodes[i];
    if not SameText(TempNode.Name,csXMLMBRange) then Continue;

    TempAttr := TempNode.AttributeByName[csXMLMBSectionID];
    if TempAttr = nil then raise EXMLLoadOutOfRangeID.Create(rsDevice1);
    TempRangeItem.RangeID := TempAttr.Value;
    TempRangeItem.RegType := rgDiscrete;

    TempAttr := TempNode.AttributeByName[csXMLMBStartAddress];
    if TempAttr = nil then raise EXMLLoadOutOfRangeOfAddr.Create(rsDevice1);
    try
     TempRange.StartAddres  := TempAttr.ValueAsInteger;
     TempRangeItem.StartReg := TempAttr.ValueAsInteger;
    except
     on E : ERangeError do raise EXMLLoadOutOfRangeOfAddr.Create(rsDevice2);
    end;

    TempAttr := TempNode.AttributeByName[csXMLMBQuantity];
    if TempAttr = nil then raise EXMLLoadOutOfRangeOfAddr.Create(rsDevice3);
    try
     TempRange.Count        := TempAttr.ValueAsInteger;
     TempRangeItem.Quantity := TempAttr.ValueAsInteger;
    except
     on E : ERangeError do raise EXMLLoadOutOfRangeOfReg.Create(rsDevice4);
    end;

    if TempRange.Count=0 then Continue;

    SetLength(FRangesDiscret,Length(FRangesDiscret)+1);
    FRangesDiscret[Length(FRangesDiscret)-1] := TempRangeItem;

    FTCPDevice.AddRegisters(rgDiscrete,TempRange.StartAddres,TempRange.Count);
   end;
end;

procedure TDispatcherModbusDevice.CoilRangesFromXML(ParamXML: TXMLNode);
var i, Count : Integer;
    TempNode : TXmlNode;
    TempRange : TMBRegistersRangeClassic;
    TempAttr      : TsdAttribute;
    TempRangeItem : TDeviceRangeItem;
begin
  if ParamXML=nil then raise EDevLoadParamXMLNotAssigned.Create('MBCoilsRanges');
  Count:=ParamXML.NodeCount-1;
  for i:=0 to Count do
   begin
    TempNode:=ParamXML.Nodes[i];
    if not SameText(TempNode.Name,csXMLMBRange) then Continue;

    TempAttr := TempNode.AttributeByName[csXMLMBSectionID];
    if TempAttr = nil then raise EXMLLoadOutOfRangeID.Create(rsDevice1);
    TempRangeItem.RangeID := TempAttr.Value;
    TempRangeItem.RegType := rgCoils;

    try
     TempRange.StartAddres := TempNode.AttributeByName[csXMLMBStartAddress].ValueAsInteger;
     TempRangeItem.StartReg := TempRange.StartAddres;
    except
     on E : ERangeError do raise EXMLLoadOutOfRangeOfAddr.Create(rsDevice5);
    end;
    try
     TempRange.Count:= TempNode.AttributeByName[csXMLMBQuantity].ValueAsInteger;
     TempRangeItem.Quantity := TempRange.Count;
    except
     on E : ERangeError do raise EXMLLoadOutOfRangeOfReg.Create(rsDevice5);
    end;

    if TempRange.Count=0 then Continue;

    SetLength(FRangesCoil,Length(FRangesCoil)+1);
    FRangesCoil[Length(FRangesCoil)-1] := TempRangeItem;

    FTCPDevice.AddRegisters(rgCoils,TempRange.StartAddres,TempRange.Count);
   end;
end;

procedure TDispatcherModbusDevice.InputRangesFromXML(ParamXML: TXMLNode);
var i, Count : Integer;
    TempNode : TXmlNode;
    TempRange : TMBRegistersRangeClassic;
    TempAttr      : TsdAttribute;
    TempRangeItem : TDeviceRangeItem;
begin
  if ParamXML=nil then raise EDevLoadParamXMLNotAssigned.Create('MBCoilsRanges');
  Count:=ParamXML.NodeCount-1;
  for i:=0 to Count do
   begin
    TempNode:=ParamXML.Nodes[i];
    if not SameText(TempNode.Name,csXMLMBRange) then Continue;

    TempAttr := TempNode.AttributeByName[csXMLMBSectionID];
    if TempAttr = nil then raise EXMLLoadOutOfRangeID.Create(rsDevice1);
    TempRangeItem.RangeID := TempAttr.Value;
    TempRangeItem.RegType := rgInput;

    try
     TempRange.StartAddres := TempNode.AttributeByName[csXMLMBStartAddress].ValueAsInteger;
     TempRangeItem.StartReg := TempRange.StartAddres;
    except
     on E : ERangeError do raise EXMLLoadOutOfRangeOfAddr.Create(rsDevice6);
    end;
    try
     TempRange.Count := TempNode.AttributeByName[csXMLMBQuantity].ValueAsInteger;
     TempRangeItem.Quantity := TempRange.Count;
    except
     on E : ERangeError do raise EXMLLoadOutOfRangeOfReg.Create(rsDevice6);
    end;
    if TempRange.Count=0 then Continue;

    SetLength(FRangesInput,Length(FRangesInput)+1);
    FRangesInput[Length(FRangesInput)-1] := TempRangeItem;

    FTCPDevice.AddRegisters(rgInput,TempRange.StartAddres,TempRange.Count);
   end;
end;

procedure TDispatcherModbusDevice.HoldingRangesFromXML(ParamXML: TXMLNode);
var i, Count : Integer;
    TempNode : TXmlNode;
    TempRange : TMBRegistersRangeClassic;
    TempAttr      : TsdAttribute;
    TempRangeItem : TDeviceRangeItem;
begin
  if ParamXML=nil then raise EDevLoadParamXMLNotAssigned.Create('MBHoldingRanges');
  Count:=ParamXML.NodeCount-1;
  for i:=0 to Count do
   begin
    TempNode:=ParamXML.Nodes[i];
    if not SameText(TempNode.Name,csXMLMBRange) then Continue;

    TempAttr := TempNode.AttributeByName[csXMLMBSectionID];
    if TempAttr = nil then raise EXMLLoadOutOfRangeID.Create(rsDevice1);
    TempRangeItem.RangeID := TempAttr.Value;
    TempRangeItem.RegType := rgHolding;

    try
     TempRange.StartAddres := TempNode.AttributeByName[csXMLMBStartAddress].ValueAsInteger;
     TempRangeItem.StartReg := TempRange.StartAddres;
    except
     on E : ERangeError do raise EXMLLoadOutOfRangeOfAddr.Create(rsDevice7);
    end;
    try
     TempRange.Count := TempNode.AttributeByName[csXMLMBQuantity].ValueAsInteger;
     TempRangeItem.Quantity := TempRange.Count;
    except
     on E : ERangeError do raise EXMLLoadOutOfRangeOfReg.Create(rsDevice7);
    end;
    if TempRange.Count=0 then Continue;

    SetLength(FRangesHolding,Length(FRangesHolding)+1);
    FRangesHolding[Length(FRangesHolding)-1] := TempRangeItem;

    FTCPDevice.AddRegisters(rgHolding,TempRange.StartAddres,TempRange.Count);
   end;
end;

procedure TDispatcherModbusDevice.GeneretePollingItems;
var i,Count : Integer;
    TempPos : Integer;
begin
  TempPos := 0;
  Count   := 0;

  SetLength(FDevicePollItms,0);

  if fn01 in FTCPDevice.DeviceFunctions then
   begin
    Count := FTCPDevice.DiscretRangeCount-1;
    if  Count > -1 then
     begin
      SetLength(FDevicePollItms, Length(FDevicePollItms)+Count+1);
      for i := 0 to Count do
       begin
        FDevicePollItms[i+TempPos].ObjectID                                       := FObjectID;
        FDevicePollItms[i+TempPos].ID                                             := FDeviceID;
        FDevicePollItms[i+TempPos].Caption                                        := FDeviceCaption;
        FDevicePollItms[i+TempPos].Item.DevNumber                                 := FTCPDevice.DeviceNum;
        FDevicePollItms[i+TempPos].Item.FunctNum                                  := 1;
// надо сделать проверку размера добавляемого диапазона - он может быть очень большим или сделать это в потоке опроса
        FDevicePollItms[i+TempPos].Item.StartAddr                                 := FTCPDevice.DiscretsRanges[i].StartAddres;
        FDevicePollItms[i+TempPos].Item.Quantity                                  := FTCPDevice.DiscretsRanges[i].Count;
        FDevicePollItms[i+TempPos].RangeID                                        := GetRangeItemID(rgDiscrete,FDevicePollItms[i+TempPos].Item.StartAddr,FDevicePollItms[i+TempPos].Item.Quantity);
        FDevicePollItms[i+TempPos].SlaveParams.SlaveAddr.IP.Addr                  := FTCPDevice.IPAddress;
        FDevicePollItms[i+TempPos].SlaveParams.SlaveAddr.Port                     := FTCPDevice.IPPort;
        FDevicePollItms[i+TempPos].SlaveParams.PoolingTimeParam.Interval          := FPoolingInterval;
        FDevicePollItms[i+TempPos].SlaveParams.PoolingTimeParam.ReconnectInterval := FPoolingReconnectInterval;
        FDevicePollItms[i+TempPos].SlaveParams.PoolingTimeParam.TimeOut           := FPoolingTimeOut;
        SendLogMessage(llDebug,rsDevDebug11,Format(rsDevDebug10,
                                                   [FDevicePollItms[i+TempPos].Item.DevNumber,
                                                    FDevicePollItms[i+TempPos].Item.StartAddr,
                                                    FDevicePollItms[i+TempPos].Item.Quantity]));

       end;
      TempPos := Count + 1;
     end;
   end;

  if fn02 in FTCPDevice.DeviceFunctions then
   begin
    Count := FTCPDevice.CoilRangeCount-1;
    if  Count > -1 then
     begin
      SetLength(FDevicePollItms, Length(FDevicePollItms)+Count+1);
      for i := 0 to Count do
       begin
        FDevicePollItms[i+TempPos].ObjectID                                       := FObjectID;
        FDevicePollItms[i+TempPos].ID                                             := FDeviceID;
        FDevicePollItms[i+TempPos].Caption                                        := FDeviceCaption;
        FDevicePollItms[i+TempPos].Item.DevNumber                                 := FTCPDevice.DeviceNum;
        FDevicePollItms[i+TempPos].Item.FunctNum                                  := 2;
// надо сделать проверку размера добавляемого диапазона - он может быть очень большим или сделать это в потоке опроса
        FDevicePollItms[i+TempPos].Item.StartAddr                                 := FTCPDevice.CoilsRanges[i].StartAddres;
        FDevicePollItms[i+TempPos].Item.Quantity                                  := FTCPDevice.CoilsRanges[i].Count;
        FDevicePollItms[i+TempPos].RangeID                                        := GetRangeItemID(rgCoils,FDevicePollItms[i+TempPos].Item.StartAddr,FDevicePollItms[i+TempPos].Item.Quantity);
        FDevicePollItms[i+TempPos].SlaveParams.SlaveAddr.IP.Addr                  := FTCPDevice.IPAddress;
        FDevicePollItms[i+TempPos].SlaveParams.SlaveAddr.Port                     := FTCPDevice.IPPort;
        FDevicePollItms[i+TempPos].SlaveParams.PoolingTimeParam.Interval          := FPoolingInterval;
        FDevicePollItms[i+TempPos].SlaveParams.PoolingTimeParam.ReconnectInterval := FPoolingReconnectInterval;
        FDevicePollItms[i+TempPos].SlaveParams.PoolingTimeParam.TimeOut           := FPoolingTimeOut;
        SendLogMessage(llDebug,rsDevDebug11,Format(rsDevDebug12,
                                                   [FDevicePollItms[i+TempPos].Item.DevNumber,
                                                    FDevicePollItms[i+TempPos].Item.StartAddr,
                                                    FDevicePollItms[i+TempPos].Item.Quantity]));

       end;
      TempPos := Count + 1;
     end;
   end;

  if fn03 in FTCPDevice.DeviceFunctions then
   begin
    Count := FTCPDevice.HoldingRangeCount-1;
    if  Count > -1 then
     begin
      SetLength(FDevicePollItms, Length(FDevicePollItms)+Count+1);
      for i := 0 to Count do
       begin
        FDevicePollItms[i+TempPos].ObjectID                                       := FObjectID;
        FDevicePollItms[i+TempPos].ID                                             := FDeviceID;
        FDevicePollItms[i+TempPos].Caption                                        := FDeviceCaption;
        FDevicePollItms[i+TempPos].Item.DevNumber                                 := FTCPDevice.DeviceNum;
        FDevicePollItms[i+TempPos].Item.FunctNum                                  := 3;
// надо сделать проверку размера добавляемого диапазона - он может быть очень большим или сделать это в потоке опроса
        FDevicePollItms[i+TempPos].Item.StartAddr                                 := FTCPDevice.HoldingsRanges[i].StartAddres;
        FDevicePollItms[i+TempPos].Item.Quantity                                  := FTCPDevice.HoldingsRanges[i].Count;
        FDevicePollItms[i+TempPos].RangeID                                        := GetRangeItemID(rgHolding,FDevicePollItms[i+TempPos].Item.StartAddr,FDevicePollItms[i+TempPos].Item.Quantity);
        FDevicePollItms[i+TempPos].SlaveParams.SlaveAddr.IP.Addr                  := FTCPDevice.IPAddress;
        FDevicePollItms[i+TempPos].SlaveParams.SlaveAddr.Port                     := FTCPDevice.IPPort;
        FDevicePollItms[i+TempPos].SlaveParams.PoolingTimeParam.Interval          := FPoolingInterval;
        FDevicePollItms[i+TempPos].SlaveParams.PoolingTimeParam.ReconnectInterval := FPoolingReconnectInterval;
        FDevicePollItms[i+TempPos].SlaveParams.PoolingTimeParam.TimeOut           := FPoolingTimeOut;
        SendLogMessage(llDebug,rsDevDebug11,Format(rsDevDebug13,
                                                   [FDevicePollItms[i+TempPos].Item.DevNumber,
                                                    FDevicePollItms[i+TempPos].Item.StartAddr,
                                                    FDevicePollItms[i+TempPos].Item.Quantity]));
       end;
      TempPos := Count + 1;
     end;
   end;

  if fn04 in FTCPDevice.DeviceFunctions then
   begin
    Count := FTCPDevice.InputRangeCount-1;
    if  Count > -1 then
     begin
      SetLength(FDevicePollItms, Length(FDevicePollItms)+Count+1);
      for i := 0 to Count do
       begin
        FDevicePollItms[i+TempPos].ObjectID                                       := FObjectID;
        FDevicePollItms[i+TempPos].ID                                             := FDeviceID;
        FDevicePollItms[i+TempPos].Caption                                        := FDeviceCaption;
        FDevicePollItms[i+TempPos].Item.DevNumber                                 := FTCPDevice.DeviceNum;
        FDevicePollItms[i+TempPos].Item.FunctNum                                  := 4;
// надо сделать проверку размера добавляемого диапазона - он может быть очень большим или сделать это в потоке опроса
        FDevicePollItms[i+TempPos].Item.StartAddr                                 := FTCPDevice.InputsRanges[i].StartAddres;
        FDevicePollItms[i+TempPos].Item.Quantity                                  := FTCPDevice.InputsRanges[i].Count;
        FDevicePollItms[i+TempPos].RangeID                                        := GetRangeItemID(rgInput,FDevicePollItms[i+TempPos].Item.StartAddr,FDevicePollItms[i+TempPos].Item.Quantity);
        FDevicePollItms[i+TempPos].SlaveParams.SlaveAddr.IP.Addr                  := FTCPDevice.IPAddress;
        FDevicePollItms[i+TempPos].SlaveParams.SlaveAddr.Port                     := FTCPDevice.IPPort;
        FDevicePollItms[i+TempPos].SlaveParams.PoolingTimeParam.Interval          := FPoolingInterval;
        FDevicePollItms[i+TempPos].SlaveParams.PoolingTimeParam.ReconnectInterval := FPoolingReconnectInterval;
        FDevicePollItms[i+TempPos].SlaveParams.PoolingTimeParam.TimeOut           := FPoolingTimeOut;
        SendLogMessage(llDebug,rsDevDebug11,Format(rsDevDebug14,
                                                   [FDevicePollItms[i+TempPos].Item.DevNumber,
                                                    FDevicePollItms[i+TempPos].Item.StartAddr,
                                                    FDevicePollItms[i+TempPos].Item.Quantity]));

       end;
     end;
   end;
end;

procedure TDispatcherModbusDevice.SubscribeToUpdates(ADispetcherItf: IMBDispatcherItf);
var i,Count : Integer;
    TempCallBack : IMBDispCallBackItf;
begin
  if not Assigned(ADispetcherItf) then raise Exception.CreateFmt(rsDevExcept1,[rsEItfDisp1]);

  FDispatcherItf := ADispetcherItf;
  TempCallBack   := Self as IMBDispCallBackItf;

  Count := Length(FDevicePollItms)-1;
  for i := 0 to Count do FDispatcherItf.AddPollingItem(FDevicePollItms[i],TempCallBack);
end;

procedure TDispatcherModbusDevice.UnsubscribeToUpdates;
var i,Count : Integer;
begin
  if not Assigned(FDispatcherItf) then raise Exception.CreateFmt(rsDevExcept2,[rsEItfDisp1]);

  Count := Length(FDevicePollItms)-1;
  for i := 0 to Count do
   begin
    FDispatcherItf.DelPollingItem(FDevicePollItms[i]);
   end;

  FDispatcherItf := nil;
end;

procedure TDispatcherModbusDevice.LoadFromXML(AIPAddr: String; APort: Word; ADeviceTag: TXmlNode);
var TempNode   : TXmlNode;
    TempAttr   : TsdAttribute;
begin
  if not Assigned(ADeviceTag) then raise EDeviceNotAssigned.Create(csXMLDevice);

  FTCPDevice.IPAddress := GetIPFromStr(AIPAddr);
  FTCPDevice.IPPort    := APort;

  if ADeviceTag.Name <> csXMLDevice then raise EDeviceParamInvalid.Create(csXMLDevice);

  // загружаем идентификатор устройства
  TempAttr := ADeviceTag.AttributeByName[csXMLDevID];
  if TempAttr <> nil then FDeviceID := TempAttr.Value
   else raise EDeviceParamInvalid.Create(csXMLDevID);

  // загрузка номера устройства
  TempAttr := ADeviceTag.AttributeByName[csXMLMBDeviceNum];
  if TempAttr <> nil then FTCPDevice.DeviceNum:=TempAttr.ValueAsInteger
   else raise EDeviceParamInvalid.Create(csXMLMBDeviceNum);

//  // загрузка типа устройства
//  TempAttr:=ADeviceTag.AttributeByName[csXMLMBDeviceType];
//  if TempAttr<>nil then FMBDeviceType :=GetModbusDeviceTypeFromString(TempAttr.Value)
//   else raise EDeviceParamInvalid.Create(csXMLMBDeviceType);

  // загрузка перечня поддерживаемых функций
  TempNode:=ADeviceTag.NodeByName(csXMLMBFunctions);
  DevFunctionsFromXML(TempNode);

  // загрузка списков используемых интервалов регистров
  TempNode:=ADeviceTag.NodeByName(csXMLMBDiscreteRenges);
  if TempNode<>nil then DiscretRangesFromXML(TempNode);

  TempNode:=ADeviceTag.NodeByName(csXMLMBCoilsRenges);
  if TempNode<>nil then CoilRangesFromXML(TempNode);

  TempNode:=ADeviceTag.NodeByName(csXMLMBInputRenges);
  if TempNode<>nil then InputRangesFromXML(TempNode);

  TempNode:=ADeviceTag.NodeByName(csXMLMBHoldingRenges);
  if TempNode<>nil then HoldingRangesFromXML(TempNode);

  FTCPDevice.InitializeDevice(True,True,$FFFF,$FFFF);

  GeneretePollingItems;

  if Length(FDevicePollItms) = 0 then raise EDeviceParamInvalid.Create(csXMLMBRange);
end;

function TDispatcherModbusDevice.SearchInRange(ARange: TDeviceRangeArray; ARangeID: String): Integer;
var i,Count : Integer;
begin
  Result := -1;
  Count := Length(ARange)-1;
  for i := 0 to Count do
   begin
    if SameText(ARange[i].RangeID,ARangeID) then
     begin
      Result := i;
      Exit;
     end;
   end;
end;

function TDispatcherModbusDevice.SearchRangeItem(ARangeID: String): TDeviceRangeItem;
var i : Integer;
begin
  Result.RangeID  := '';
  Result.Quantity := 0;
  Result.StartReg := 0;
  Result.RegType  := rgNone;

  i := SearchInRange(FRangesHolding,ARangeID);
  if i <> -1 then
   begin
    Result := FRangesHolding[i];
    Exit;
   end;

  i := SearchInRange(FRangesDiscret,ARangeID);
  if i <> -1 then
   begin
    Result := FRangesDiscret[i];
    Exit;
   end;

  i := SearchInRange(FRangesCoil,ARangeID);
  if i <> -1 then
   begin
    Result := FRangesCoil[i];
    Exit;
   end;

  i := SearchInRange(FRangesInput,ARangeID);
  if i <> -1 then
   begin
    Result := FRangesInput[i];
    Exit;
   end;
end;

function TDispatcherModbusDevice.GetRangeItemID(ARangeType : TRegMBTypes; ARegStart, ARegQuantity : Word) : String;
var TempRangeList : TDeviceRangeArray;
    TempRange     : TDeviceRangeItem;
    i, Count      : Integer;
begin
  Result := '';
  case ARangeType of
   rgCoils    : TempRangeList := FRangesCoil;
   rgDiscrete : TempRangeList := FRangesDiscret;
   rgHolding  : TempRangeList := FRangesHolding;
   rgInput    : TempRangeList := FRangesInput;
  end;
  Count := Length(TempRangeList)-1;
  for i := 0 to Count do
   begin
    TempRange := TempRangeList[i];
    if (TempRange.StartReg = ARegStart) and (TempRange.Quantity = ARegQuantity) then
     begin
      Result := TempRange.RangeID;
      Break;
     end;
   end;
end;

procedure TDispatcherModbusDevice.SetDataSubscribers(ASubscribers: TDeviceSubscribers);
begin
  Lock;
  try
   FSubscribers := ASubscribers;
  finally
   UnLock;
  end;
end;

end.

