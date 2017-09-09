unit DispatcherModbusSlaveProxyClasses;

{$mode objfpc}{$H+}

interface

uses Classes,
     MBDefine,
     DispatcherModbusItf,
     DispatcherModbusSlaveConnectionClasses,
     DispatcherDictionaryesClasses,
     LoggerItf;

type

  { TDispatcherModbusSlaveProxy }

  TDispatcherModbusSlaveProxy = class(TComponentLogged, IMBSlaveProxyItf)
  private
   // один объект на один сокет
   FConnectionsDictinary : TDictionaryWordObject;
   function GetConnectionsCount: Cardinal;
  protected
   procedure SetLogger(const Value: IDLogger); override;
  public
   constructor Create(AOwner : TComponent); override;
   destructor  Destroy; override;
   // управление списком устройств для мониторинга
   procedure AddPollingItem(ItemProp : TMBTCPSlavePollingItem; CallBack : IMBDispCallBackItf); stdcall;
   procedure DelPollingItem(ItemProp : TMBTCPSlavePollingItem); stdcall;
   procedure ClearPollingList; stdcall;
   // запуск/остановка мониторинга всех устройств
   procedure StartAll; stdcall;
   procedure StopAll; stdcall;
   function  IsActive(ItemProp : TMBTCPSlavePollingItem): Boolean; stdcall;
   // активация/деактивация устройства для мониторинга
   procedure Activate(ItemProp : TMBTCPSlavePollingItem); stdcall;
   procedure Deactivate(ItemProp : TMBTCPSlavePollingItem); stdcall;
   // заглушки
   function SetCoilValue(ADevItf : IMBDispDeviceTCPItf; ARegAddress : Word; ARegValue : Boolean) : Boolean; stdcall;
   function SetInputValue(ADevItf : IMBDispDeviceTCPItf; ARegAddress : Word; ARegValue : Word) : Boolean; stdcall;

   property ConnectionsCount : Cardinal read GetConnectionsCount;
  end;

implementation

uses sysutils;

{ TDispatcherModbusSlaveProxy }

constructor TDispatcherModbusSlaveProxy.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FConnectionsDictinary := TDictionaryWordObject.Create;
end;

destructor TDispatcherModbusSlaveProxy.Destroy;
begin
  ClearPollinglist;
  FreeAndNil(FConnectionsDictinary);
  inherited;
end;

function TDispatcherModbusSlaveProxy.GetConnectionsCount: Cardinal;
begin
  Result := FConnectionsDictinary.Count;
end;

function TDispatcherModbusSlaveProxy.IsActive(ItemProp: TMBTCPSlavePollingItem): Boolean; stdcall;
var TempConnection : TMBSlaveConnection;
begin
  Result := False;
  if FConnectionsDictinary.TryGetValue(ItemProp.SlaveParams.SlaveAddr.Port, TObject(TempConnection)) then
  begin
    Result := TempConnection.GetActive;
  end;
end;

procedure TDispatcherModbusSlaveProxy.ClearPollingList; stdcall;
begin
  StopAll;
  FConnectionsDictinary.Clear;
end;

procedure TDispatcherModbusSlaveProxy.DelPollingItem(ItemProp: TMBTCPSlavePollingItem); stdcall;
var TempConnection : TMBSlaveConnection;
begin
  TempConnection := TMBSlaveConnection(FConnectionsDictinary.ObjectsOfKey[ItemProp.SlaveParams.SlaveAddr.Port]);

  if Assigned(TempConnection) then
   begin
    TempConnection.DelPollingItem(ItemProp);
   end;

  if TempConnection.PollingItemsCount = 0 then
   begin
    FConnectionsDictinary.Remove(ItemProp.SlaveParams.SlaveAddr.Port);
   end;
end;

procedure TDispatcherModbusSlaveProxy.Activate(ItemProp: TMBTCPSlavePollingItem); stdcall;
var TempConnection : TMBSlaveConnection;
begin
  if FConnectionsDictinary.TryGetValue(ItemProp.SlaveParams.SlaveAddr.Port, TObject(TempConnection)) then
  begin
    TempConnection.Activate(ItemProp);
  end;
end;

procedure TDispatcherModbusSlaveProxy.Deactivate(ItemProp: TMBTCPSlavePollingItem); stdcall;
var TempConnection : TMBSlaveConnection;
begin
 if FConnectionsDictinary.TryGetValue(ItemProp.SlaveParams.SlaveAddr.Port, TObject(TempConnection)) then
  begin
    TempConnection.Deactivate(ItemProp);
  end;
end;

function TDispatcherModbusSlaveProxy.SetCoilValue(ADevItf: IMBDispDeviceTCPItf; ARegAddress: Word; ARegValue: Boolean): Boolean; stdcall;
begin
  Result := False;
end;

function TDispatcherModbusSlaveProxy.SetInputValue(ADevItf: IMBDispDeviceTCPItf; ARegAddress: Word; ARegValue: Word): Boolean; stdcall;
begin
  Result := False;
end;

procedure TDispatcherModbusSlaveProxy.SetLogger(const Value: IDLogger);
var TempConnection : TObject;
begin
  inherited SetLogger(Value);

  for TempConnection in FConnectionsDictinary.Values do TMBSlaveConnection(TempConnection).Logger := Logger;
end;

procedure TDispatcherModbusSlaveProxy.StartAll; stdcall;
var TempConnection : TObject;
begin
  for TempConnection in FConnectionsDictinary.Values do TMBSlaveConnection(TempConnection).StartAll;
end;

procedure TDispatcherModbusSlaveProxy.StopAll; stdcall;
var TempConnection : TObject;
begin
  for TempConnection in FConnectionsDictinary.Values do
   begin
    TMBSlaveConnection(TempConnection).StopAll;
   end;
end;

procedure TDispatcherModbusSlaveProxy.AddPollingItem(ItemProp: TMBTCPSlavePollingItem; CallBack: IMBDispCallBackItf); stdcall;
var TempConnection : TMBSlaveConnection;
begin
  if not FConnectionsDictinary.TryGetValue(ItemProp.SlaveParams.SlaveAddr.Port, TObject(TempConnection)) then
   begin
    TempConnection := TMBSlaveConnection.Create(nil);
    TempConnection.Logger := Logger;
    TempConnection.ConnectionParam := ItemProp.SlaveParams;
    FConnectionsDictinary.Add(ItemProp.SlaveParams.SlaveAddr.Port,TempConnection);
   end;
  TempConnection.AddPollingItem(ItemProp,CallBack);
end;

end.
