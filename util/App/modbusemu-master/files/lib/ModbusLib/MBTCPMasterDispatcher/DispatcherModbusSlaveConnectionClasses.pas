unit DispatcherModbusSlaveConnectionClasses;

{$mode objfpc}{$H+}

interface

uses Classes, SyncObjs,
     MBDefine,
     DispatcherModbusItf,
     DispatcherDictionaryesClasses,
     DispatcherMBSlavePollingThreadClasses, DispatcherMBSlavePollingItemClasses,
     LoggerItf;
type

  {
    Объект соединения с Modbus TCP устройством.
    Возможные исключения: при добавлении объекта-запроса если запрашивается функция не
    поддерживаемая на данный момент.
   }
  TMBSlaveConnection = class(TComponentLogged,IMBSlaveConnectionItf)
  private
   FCSection             : TCriticalSection;
   FPollingItemDictinary : TDictionaryTCPItemObject;
   FPollingThread        : TMBSlavePollingThread;
   FConnectionParam      : TMBTCPSlavePollingParam;
   procedure StopPollingThread;
   procedure StartPollingThread;
   function  GetPollingItemCount: Cardinal;
  protected
   procedure SetLogger(const Value: IDLogger); override;
  public
   constructor Create(AOwner : TComponent); override;
   destructor  Destroy; override;
   // управление списком устройств для мониторинга
   procedure AddPollingItem(ItemProp: TMBTCPSlavePollingItem; CallBack: IMBDispCallBackItf); stdcall;
   procedure DelPollingItem(ItemProp : TMBTCPSlavePollingItem); stdcall;
   procedure ClearPollingList; stdcall;
   // запуск/остановка мониторинга всех устройств
   procedure StartAll; stdcall;
   procedure StopAll; stdcall;
   function  GetActive: Boolean; stdcall;
   // активация/деактивация устройства для мониторинга
   procedure Activate(ItemProp : TMBTCPSlavePollingItem); stdcall;
   procedure Deactivate(ItemProp : TMBTCPSlavePollingItem); stdcall;

   procedure SetConnectionParam(const Value: TMBTCPSlavePollingParam); stdcall;

   property PollingItemsCount : Cardinal read GetPollingItemCount;
   property ConnectionParam   : TMBTCPSlavePollingParam read FConnectionParam write SetConnectionParam;
  end;

  TMBSlaveConnectionsArray = array of TMBSlaveConnection;

implementation

uses sysutils;

{ TMBSlaveConnection }

constructor TMBSlaveConnection.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FCSection             := TCriticalSection.Create;
  FPollingItemDictinary := TDictionaryTCPItemObject.Create;
  FPollingThread        := nil;
end;

destructor TMBSlaveConnection.Destroy;
begin
  if Assigned(FPollingThread) then StopPollingThread;
  FreeAndNil(FCSection);
  FreeAndNil(FPollingItemDictinary);
  inherited;
end;

procedure TMBSlaveConnection.StopPollingThread;
begin
  if not Assigned(FPollingThread) then Exit;
  FPollingThread.Terminate;
  FPollingThread.WaitFor;
  FreeAndNil(FPollingThread);
end;

procedure TMBSlaveConnection.StartPollingThread;
begin
  if Assigned(FPollingThread) then Exit;
  FPollingThread := TMBSlavePollingThread.Create(True);//,65535);
  FPollingThread.Logger          := Logger;
  FPollingThread.CSection        := FCSection;
  FPollingThread.ItemDictinary   := FPollingItemDictinary;
  FPollingThread.ConnectionParam := FConnectionParam;
  FPollingThread.Start;
end;

function TMBSlaveConnection.GetActive: Boolean; stdcall;
begin
  Result := False;
  FCSection.Enter;
  try
   Result := Assigned(FPollingThread);
  finally
   FCSection.Leave;
  end;
end;

function TMBSlaveConnection.GetPollingItemCount: Cardinal;
begin
  Result := FPollingItemDictinary.Count;
end;

procedure TMBSlaveConnection.DelPollingItem(ItemProp: TMBTCPSlavePollingItem); stdcall;
begin
  FCSection.Enter;
  try
    FPollingItemDictinary.Remove(ItemProp);
    if FPollingItemDictinary.Count = 0 then
     begin
      StopPollingThread;
     end;
  finally
    FCSection.Leave;
  end;
end;

procedure TMBSlaveConnection.ClearPollingList; stdcall;
begin
  FCSection.Enter;
  try
    StopPollingThread;
    FPollingItemDictinary.Clear;
  finally
    FCSection.Leave;
  end;
end;

procedure TMBSlaveConnection.AddPollingItem(ItemProp: TMBTCPSlavePollingItem; CallBack: IMBDispCallBackItf); stdcall;
var TempItem : TMBSlavePollingItem;
begin
  FCSection.Enter;
  try
    if not FPollingItemDictinary.TryGetValue(ItemProp, TObject(TempItem)) then
     begin
      TempItem := TMBSlavePollingItem.Create(ItemProp);
      FPollingItemDictinary.Add(ItemProp,TempItem);
      TempItem.AddCallBackItf(CallBack);
     end;
  finally
   FCSection.Leave;
  end;
end;

procedure TMBSlaveConnection.SetConnectionParam(const Value: TMBTCPSlavePollingParam); stdcall;
begin
  FConnectionParam := Value;
  if Assigned(FPollingThread) then FPollingThread.ConnectionParam := FConnectionParam;
end;

procedure TMBSlaveConnection.SetLogger(const Value: IDLogger);
begin
  inherited SetLogger(Value);

  FPollingItemDictinary.Logger := Logger;

  if Assigned(FPollingThread) then FPollingThread.Logger := Logger;
end;

procedure TMBSlaveConnection.Activate(ItemProp: TMBTCPSlavePollingItem); stdcall;
var TempItem : TMBSlavePollingItem;
begin
  FCSection.Enter;
  try
    if not FPollingItemDictinary.TryGetValue(ItemProp, TObject(TempItem)) then Exit;
    TempItem.Active := True;
  finally
   FCSection.Leave;
  end;
end;

procedure TMBSlaveConnection.Deactivate(ItemProp: TMBTCPSlavePollingItem); stdcall;
var TempItem : TMBSlavePollingItem;
begin
  FCSection.Enter;
  try
    if not FPollingItemDictinary.TryGetValue(ItemProp, TObject(TempItem)) then Exit;
    TempItem.Active := False;
  finally
    FCSection.Leave;
  end;
end;

procedure TMBSlaveConnection.StartAll; stdcall;
begin
  StartPollingThread;
end;

procedure TMBSlaveConnection.StopAll; stdcall;
begin
  StopPollingThread;
end;

end.
