unit DispatcherModelObjectClasses;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils, contnrs,
     LoggerItf,
     DispatcherModbusDeviceClasses, DispatcherModbusItf,
     NativeXml;

const

  ciDefPoolingInterval          = 500;
  ciDefPoolingReconnectInterval = 10000;
  ciDefPoolingTimeOut           = 5000;

type

  { TDispatcherModelObject }

  TDispatcherModelObject = class(TComponentLogged)
  private
    FObjectDevices            : TObjectList;
    FObjectID                 : String;
    FObjectName               : String;
    FObjectType               : String;
    FPoolingInterval          : Integer;
    FPoolingReconnectInterval : Integer;
    FPoolingTimeOut           : Integer;
    function  GetDeviceCount: Integer;
    function  GetDevices(Index : Integer): TDispatcherModbusDevice;
    procedure SetPoolingInterval(AValue: Integer);
    procedure SetPoolingReconnectInterval(AValue: Integer);
    procedure SetPoolingTimeOut(AValue: Integer);
   protected
    procedure SetLogger(const AValue: IDLogger); override;
   public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;

    // подписка устройства на получение данных от диспетчера
    procedure SubscribeToUpdates(ADispetcherItf : IMBDispatcherItf);
    // снятие подписки устройства на получение данных от диспетчера
    procedure UnsubscribeToUpdates;
    // загрузка параметров объекта из конфигурационного файла
    procedure LoadFromXML(AObjectTag : TXmlNode); virtual;

    function  IndexOf(AID : String) : Integer; overload;
    function  IndexOf(ADevNum : Byte) : Integer; overload;
    function  AddObjectModel(AID,ACaption : String): TDispatcherModbusDevice;
    procedure Clear;

    property ObjectID                 : String read FObjectID write FObjectID;
    property ObjectName               : String read FObjectName write FObjectName;
    property ObjectType               : String read FObjectType write FObjectType;

    property DeviceCount              : Integer read GetDeviceCount;
    property Devices[Index : Integer] : TDispatcherModbusDevice read GetDevices;

    // период опроса
    property PoolingInterval          : Integer read FPoolingInterval write SetPoolingInterval default 500;
    // интервал повторного коннекта при обрыве соединения
    property PoolingReconnectInterval : Integer read FPoolingReconnectInterval write SetPoolingReconnectInterval default 10000;
    // таймаут ожидания прихода ответа
    property PoolingTimeOut           : Integer read FPoolingTimeOut write SetPoolingTimeOut default 5000;
  end;

implementation

uses DispatcherResStrings,
     {Библиотека MiscFunctions}
     XMLConsts,
     ExceptionsTypes;

{ TDispatcherModelObject }

constructor TDispatcherModelObject.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FObjectDevices := TObjectList.Create(True);
  FObjectID   := '';
  FObjectName := '';
  FPoolingInterval          := ciDefPoolingInterval;
  FPoolingReconnectInterval := ciDefPoolingReconnectInterval;
  FPoolingTimeOut           := ciDefPoolingTimeOut;
end;

destructor TDispatcherModelObject.Destroy;
begin
  FreeAndNil(FObjectDevices);
  inherited Destroy;
end;

procedure TDispatcherModelObject.SetPoolingInterval(AValue: Integer);
var i, Count : Integer;
begin
  if FPoolingInterval = AValue then Exit;
  FPoolingInterval := AValue;
  Count := FObjectDevices.Count-1;
  for i := 0 to Count do TDispatcherModbusDevice(FObjectDevices.Items[i]).PoolingInterval := FPoolingInterval;
end;

function TDispatcherModelObject.GetDeviceCount: Integer;
begin
  Result := FObjectDevices.Count;
end;

function TDispatcherModelObject.GetDevices(Index : Integer): TDispatcherModbusDevice;
begin
  Result := TDispatcherModbusDevice(FObjectDevices.Items[Index]);
end;

procedure TDispatcherModelObject.SetPoolingReconnectInterval(AValue: Integer);
var i, Count : Integer;
begin
  if FPoolingReconnectInterval = AValue then Exit;
  FPoolingReconnectInterval := AValue;
  Count := FObjectDevices.Count-1;
  for i := 0 to Count do TDispatcherModbusDevice(FObjectDevices.Items[i]).PoolingReconnectInterval := FPoolingReconnectInterval;
end;

procedure TDispatcherModelObject.SetPoolingTimeOut(AValue: Integer);
var i, Count : Integer;
begin
  if FPoolingTimeOut = AValue then Exit;
  FPoolingTimeOut := AValue;
  Count := FObjectDevices.Count-1;
  for i := 0 to Count do TDispatcherModbusDevice(FObjectDevices.Items[i]).PoolingTimeOut := FPoolingTimeOut;
end;

procedure TDispatcherModelObject.SetLogger(const AValue: IDLogger);
var i, Count : Integer;
begin
  inherited SetLogger(AValue);
  Count := FObjectDevices.Count-1;
  for i := 0 to Count do TDispatcherModbusDevice(FObjectDevices.Items[i]).Logger := Logger;
end;

procedure TDispatcherModelObject.SubscribeToUpdates(ADispetcherItf: IMBDispatcherItf);
var i, Count : Integer;
begin
  Count := FObjectDevices.Count-1;
  for i := 0 to Count do
   begin
    TDispatcherModbusDevice(FObjectDevices.Items[i]).SubscribeToUpdates(ADispetcherItf);
   end;
end;

procedure TDispatcherModelObject.UnsubscribeToUpdates;
var i, Count : Integer;
begin
  Count := FObjectDevices.Count-1;
  for i := 0 to Count do
   begin
    TDispatcherModbusDevice(FObjectDevices.Items[i]).UnsubscribeToUpdates;
   end;
end;

procedure TDispatcherModelObject.LoadFromXML(AObjectTag: TXmlNode);
var TempNode,
    TempNode1,
    TempNode2,
    TempNode3  : TXmlNode;
    TempAttr   : TsdAttribute;
    i,  Count,
    i1, Count1,
    i2, Count2 : Integer;
    TempIP     : String;
    TempPort   : Word;
    TempDevice : TDispatcherModbusDevice;
begin
  if not Assigned(AObjectTag) then raise EObjectNotAssigned.Create(csXMLObject);
  if AObjectTag.Name <> csXMLObject then raise EObjectParamInvalid.Create(csXMLObject);
  if AObjectTag.Parent.Parent.Name <> csXMLTrasmitterSNMP then raise EObjectParamInvalid.Create(csXMLObject);
  // имя объекта
  TempAttr := AObjectTag.AttributeByName[csXMLName];
  if Assigned(TempAttr) then FObjectName := TempAttr.Value;
  // идентификатор объекта
  TempAttr := AObjectTag.AttributeByName[csXMLObjectID];
  if Assigned(TempAttr) then FObjectID := TempAttr.Value
   else raise EObjectParamInvalid.Create(csXMLObjectID);

  // Загрузка временных параметров опроса
  TempNode := AObjectTag.NodeByName(csXMLIDCS);
  if not Assigned(TempNode) then
   begin
    FPoolingInterval          := ciDefPoolingInterval;
    FPoolingReconnectInterval := ciDefPoolingReconnectInterval;
    FPoolingTimeOut           := ciDefPoolingTimeOut;
   end
  else
   begin
    TempAttr := TempNode.AttributeByName[csXMLDeviceInterval];
    if not Assigned(TempAttr) then FPoolingInterval := ciDefPoolingInterval
     else FPoolingInterval := TempAttr.ValueAsInteger;

    TempAttr := TempNode.AttributeByName[csXMLDeviceReconnect];
    if not Assigned(TempAttr) then FPoolingReconnectInterval := ciDefPoolingReconnectInterval
     else FPoolingReconnectInterval := TempAttr.ValueAsInteger;

    TempAttr := TempNode.AttributeByName[csXMLDeviceTimeout];
    if not Assigned(TempAttr) then FPoolingTimeOut := ciDefPoolingTimeOut
     else FPoolingTimeOut := TempAttr.ValueAsInteger;
   end;


  //                     ObjL    Trans   DDAC  Host   HostL  PDON
  TempNode := AObjectTag.Parent.Parent.Parent.Parent.Parent.Parent.NodeByName(csXMLObjectList);
  if not Assigned(TempNode) then raise EObjectListNotAssigned.Create(csXMLObjectList);

  Count := TempNode.NodeCount-1; // количество тегов в теге ObjectList
  for i := 0 to Count do
   begin
    // Объект наблюдения
    TempNode1 := TempNode.Nodes[i]; // тег объекта
    if TempNode1.ElementType <> xeElement then Continue;
    if TempNode1.Name <> csXMLObject then Continue;

    TempAttr := TempNode1.AttributeByName[csXMLObjectID]; // идентификатор объекта
    if not Assigned(TempAttr) then Continue;
    if not SameText(FObjectID,TempAttr.Value) then Continue;

    TempNode1 := TempNode1.NodeByName(csXMLHostList); // список хостов объекта
    if not Assigned(TempNode1) then Continue;

    Count1 := TempNode1.NodeCount-1;
    for i1 := 0 to Count1 do  // перебираем хосты
     begin
      TempNode2 := TempNode1.Nodes[i1]; // хост
      if TempNode2.ElementType <> xeElement then Continue;
      if TempNode2.Name <> csXMLHost then Continue;

      TempAttr := TempNode2.AttributeByName[csXMLIPAddress]; // адрес хоста
      if not Assigned(TempAttr) then Continue;
      TempIP := TempAttr.Value;
      TempAttr := TempNode2.AttributeByName[csXMLTCPPort]; // порт хоста
      if not Assigned(TempAttr) then TempPort := 502
       else TempPort := TempAttr.ValueAsInteger;

      Count2 := TempNode2.NodeCount-1; // количество девайсов
      for i2 := 0 to Count2 do         // перебираем девайсы,загружаем параметры девайсов и добавляем в список
       begin
        TempNode3 := TempNode2.Nodes[i2]; // тег устройства
        if TempNode3.ElementType <> xeElement then Continue;
        if TempNode3.Name <> csXMLDevice then Continue;
        TempDevice := TDispatcherModbusDevice.Create(nil);
        TempDevice.Logger := Logger;
        TempDevice.ObjectID                 := FObjectID;
        TempDevice.PoolingInterval          := FPoolingInterval;
        TempDevice.PoolingReconnectInterval := FPoolingReconnectInterval;
        TempDevice.PoolingTimeOut           := FPoolingTimeOut;
        TempDevice.LoadFromXML(TempIP,TempPort,TempNode3);

        SendLogMessage(llDebug,rsDevDebug15, Format(rsDevDebug16,[TempDevice.Device.DeviceNum]));

        FObjectDevices.Add(TempDevice);
       end;
     end;
   end;
end;

function TDispatcherModelObject.IndexOf(AID: String): Integer;
var i,Count : Integer;
begin
  Result := -1;
  Count := FObjectDevices.Count-1;
  for i := 0 to Count do
   begin
    if SameText(TDispatcherModbusDevice(FObjectDevices.Items[i]).DeviceID, AID) then
     begin
      Result := i;
      Break;
     end;
   end;
end;

function TDispatcherModelObject.IndexOf(ADevNum: Byte): Integer;
var i,Count : Integer;
begin
  Result := -1;
  Count := FObjectDevices.Count-1;
  for i := 0 to Count do
   begin
    if TDispatcherModbusDevice(FObjectDevices.Items[i]).Device.DeviceNum = ADevNum then
     begin
      Result := i;
      Break;
     end;
   end;
end;

function TDispatcherModelObject.AddObjectModel(AID, ACaption: String): TDispatcherModbusDevice;
var i : Integer;
begin
  i := IndexOf(AID);
  if i <> -1 then
   begin
    Result := Devices[i];
    Exit;
   end;
  Result := TDispatcherModbusDevice.Create(nil);
  Result.DeviceID      := AID;
  Result.DeviceCaption := ACaption;
  Result.PoolingInterval := FPoolingInterval;
  Result.PoolingReconnectInterval := FPoolingReconnectInterval;
  Result.PoolingTimeOut := FPoolingTimeOut;
  FObjectDevices.Add(Result);
end;

procedure TDispatcherModelObject.Clear;
begin
  FObjectDevices.Clear;
end;

end.

