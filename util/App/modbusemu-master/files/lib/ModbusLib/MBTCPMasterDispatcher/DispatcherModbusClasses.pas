unit DispatcherModbusClasses;

{$mode objfpc}{$H+}

interface

uses Classes,
     MBDefine,
     DispatcherModbusItf,
     DispatcherModbusSlaveProxyClasses,
     DispatcherDictionaryesClasses,
     DispatcherModbusSetThreadClasses,
     LoggerItf;

type
  {
   Класс реализует объект диспетчера производящий опрос устройств по протоколу Modbus TCP.
   Диспетчером не производится оптимизация запрашиваемых интервалов переменных.
   Оптимизация(минимизация количества запросов) должна производиться на стороне
   объекта подписывающегося на опрос того или иного устройства.
   }

  { TDispatcherModbusMaster }

  TDispatcherModbusMaster = class(TComponentLogged, IMBDispatcherItf)
  private
   FProxyDictinary : TDictionaryCardinalObject;
   FSetThread      : TMBSlaveSetThread;
  protected
   procedure SetLogger(const Value: IDLogger); override;

   procedure StopSetThread;
   procedure StartSetThread;
   function  IsSetThreadActive : Boolean;
  public
   constructor Create(AOwner : TComponent); override;
   destructor  Destroy; override;

   function ItemPropToStr(ItemProp : TMBTCPSlavePollingItem): string;

   // управление набором устройств для мониторинга
   procedure AddPollingItem(ItemProp : TMBTCPSlavePollingItem; CallBack : IMBDispCallBackItf); stdcall;
   procedure DelPollingItem(ItemProp : TMBTCPSlavePollingItem); stdcall;
   procedure ClearPollingList; stdcall;
   // запуск/остановка мониторинга всех устройств
   procedure StartAll; stdcall;
   procedure StopAll; stdcall;
   // получение состояния активности опроса
   function  IsActive(ItemProp : TMBTCPSlavePollingItem): Boolean; stdcall;
   // активация/деактивация устройства для мониторинга
   procedure Activate(ItemProp : TMBTCPSlavePollingItem); stdcall;
   procedure Deactivate(ItemProp : TMBTCPSlavePollingItem); stdcall;
   // методы записи значений в устройство
   function  SetCoilValue(ADevItf : IMBDispDeviceTCPItf; ARegAddress : Word; ARegValue : Boolean) : Boolean; stdcall;
   function  SetInputValue(ADevItf : IMBDispDeviceTCPItf; ARegAddress : Word; ARegValue : Word) : Boolean; stdcall;
  end;

implementation

uses SysUtils, SocketMisc, DispatcherResStrings;

{ TDispatcherModbusSlave }

constructor TDispatcherModbusMaster.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FLogger := nil;
  FProxyDictinary := TDictionaryCardinalObject.Create;
  FSetThread := nil;
end;

destructor TDispatcherModbusMaster.Destroy;
begin
  ClearPollingList;
  FreeAndNil(FProxyDictinary);
  inherited Destroy;
end;

function TDispatcherModbusMaster.IsActive(ItemProp: TMBTCPSlavePollingItem): Boolean; stdcall;
var TempProxy : TDispatcherModbusSlaveProxy;
begin
  Result := False;
  if FProxyDictinary.TryGetValue(ItemProp.SlaveParams.SlaveAddr.IP.Addr, TObject(TempProxy)) then
  begin
    Result := TempProxy.IsActive(ItemProp);
  end;
end;

function TDispatcherModbusMaster.ItemPropToStr(ItemProp: TMBTCPSlavePollingItem): string;
begin
  Result := Format('%s:%d:%d:%d:%d:%d:%d:%d:%d',
                      [GetIPStr(ItemProp.SlaveParams.SlaveAddr.IP.Addr),
                      ItemProp.SlaveParams.SlaveAddr.Port,
                      ItemProp.SlaveParams.PoolingTimeParam.Interval,
                      ItemProp.SlaveParams.PoolingTimeParam.TimeOut,
                      ItemProp.SlaveParams.PoolingTimeParam.ReconnectInterval,
                      ItemProp.Item.DevNumber,
                      ItemProp.Item.FunctNum,
                      ItemProp.Item.StartAddr,
                      ItemProp.Item.Quantity
                      ]);
end;

procedure TDispatcherModbusMaster.Activate(ItemProp: TMBTCPSlavePollingItem); stdcall;
var TempProxy : TDispatcherModbusSlaveProxy;
begin
  if FProxyDictinary.TryGetValue(ItemProp.SlaveParams.SlaveAddr.IP.Addr, TObject(TempProxy)) then
    TempProxy.Activate(ItemProp);
end;

procedure TDispatcherModbusMaster.Deactivate(ItemProp: TMBTCPSlavePollingItem); stdcall;
var TempProxy : TDispatcherModbusSlaveProxy;
begin
  if FProxyDictinary.TryGetValue(ItemProp.SlaveParams.SlaveAddr.IP.Addr, TObject(TempProxy)) then
    TempProxy.Deactivate(ItemProp);
end;

function TDispatcherModbusMaster.SetCoilValue(ADevItf: IMBDispDeviceTCPItf; ARegAddress: Word; ARegValue: Boolean): Boolean; stdcall;
begin
  Result := False;
  if not Assigned(ADevItf) then raise Exception.Create(rsSetCoilValue11);
  if not Assigned(FSetThread) then raise Exception.Create(rsSetCoilValue12);
  FSetThread.AddCoilMessage(ADevItf.GetDeviceIP,
                            ADevItf.GetDevicePort,
                            ADevItf.GetDeviceNum,
                            ARegAddress,
                            ARegValue);
  Result := True;
end;

function TDispatcherModbusMaster.SetInputValue(ADevItf: IMBDispDeviceTCPItf; ARegAddress: Word; ARegValue: Word): Boolean; stdcall;
begin
  Result := False;
  if not Assigned(ADevItf) then raise Exception.Create(rsSetInputValue11);
  if not Assigned(FSetThread) then raise Exception.Create(rsSetInputValue12);
  FSetThread.AddInputMessage(ADevItf.GetDeviceIP,
                             ADevItf.GetDevicePort,
                             ADevItf.GetDeviceNum,
                             ARegAddress,
                             ARegValue);
  Result := True;
end;

procedure TDispatcherModbusMaster.SetLogger(const Value: IDLogger);
var TempProxy : TObject;
begin
  inherited SetLogger(Value);
  for TempProxy in FProxyDictinary.Values do TDispatcherModbusSlaveProxy(TempProxy).Logger := Logger;
end;

procedure TDispatcherModbusMaster.StopSetThread;
begin
  if not Assigned(FSetThread) then Exit;
  FSetThread.Terminate;
  FSetThread.WaitFor;
  FreeAndNil(FSetThread);
end;

procedure TDispatcherModbusMaster.StartSetThread;
begin
  if Assigned(FSetThread) then Exit;
  FSetThread := TMBSlaveSetThread.Create(True);
  FSetThread.Logger := Logger;



  FSetThread.Start;
end;

function TDispatcherModbusMaster.IsSetThreadActive: Boolean;
begin
  Result := Assigned(FSetThread);
end;

procedure TDispatcherModbusMaster.StartAll; stdcall;
var TempProxy : TObject;
begin
  StartSetThread;
  for TempProxy in FProxyDictinary.Values do TDispatcherModbusSlaveProxy(TempProxy).StartAll;
end;

procedure TDispatcherModbusMaster.StopAll; stdcall;
var TempProxy : TObject;
begin
  for TempProxy in FProxyDictinary.Values do TDispatcherModbusSlaveProxy(TempProxy).StopAll;
  StopSetThread;
end;

procedure TDispatcherModbusMaster.AddPollingItem(ItemProp: TMBTCPSlavePollingItem; CallBack: IMBDispCallBackItf); stdcall;
var TempProxy : TDispatcherModbusSlaveProxy;
begin
  if not FProxyDictinary.TryGetValue(ItemProp.SlaveParams.SlaveAddr.IP.Addr, TObject(TempProxy)) then
  begin
    TempProxy := TDispatcherModbusSlaveProxy.Create(nil);
    TempProxy.Logger := Logger;
    FProxyDictinary.Add(ItemProp.SlaveParams.SlaveAddr.IP.Addr,TempProxy);
  end;
  TempProxy.AddPollingItem(ItemProp,CallBack);
end;

procedure TDispatcherModbusMaster.ClearPollingList; stdcall;
var TempProxy : TObject;
begin
  for TempProxy in FProxyDictinary.Values do
   begin
    TDispatcherModbusSlaveProxy(TempProxy).ClearPollinglist;
   end;
  FProxyDictinary.Clear;
end;

procedure TDispatcherModbusMaster.DelPollingItem(ItemProp: TMBTCPSlavePollingItem); stdcall;
var TempProxy : TDispatcherModbusSlaveProxy;
begin
  if FProxyDictinary.TryGetValue(ItemProp.SlaveParams.SlaveAddr.IP.Addr, TObject(TempProxy)) then
  begin
    TempProxy.DelPollingItem(ItemProp);
    if TempProxy.ConnectionsCount = 0 then
     begin
       FProxyDictinary.Remove(ItemProp.SlaveParams.SlaveAddr.IP.Addr);
     end;
  end;
end;

end.
