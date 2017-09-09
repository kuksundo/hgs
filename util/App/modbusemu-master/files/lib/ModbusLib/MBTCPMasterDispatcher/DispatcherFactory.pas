unit DispatcherFactory;

{$mode objfpc}{$H+}

interface

uses Classes,
     DispatcherModbusItf,
     EssoClientDispatcherItf,
     LoggerItf;

type

  { TTrasmitterDispFactory }

  TTrasmitterDispFactory = class
  public
   class function  GetEssoDispatcherNew : IESSOClientDisp;
   class function  GetModbusDispatcher  : IMBDispatcherItf;
   class procedure SetLoggerItf(LogItf : IDLogger);
   class procedure DestroyAllDispatchers;
  end;

implementation

uses sysutils,
     DispatcherModbusClasses,
     EssoClientDispNewTypes;

{ TTrasmitterDispFactory }

var EssoDispatcherNew : TESSOClientDisp;
    ModbusDispatcher  : TDispatcherModbusMaster;
    LoggerItfVar      : IDLogger;

class function TTrasmitterDispFactory.GetEssoDispatcherNew: IESSOClientDisp;
begin
  Result := nil;
  if not Assigned(EssoDispatcherNew) then
   begin
    EssoDispatcherNew := TESSOClientDisp.Create(nil);
    EssoDispatcherNew.Logger := LoggerItfVar;
   end;
  Result := EssoDispatcherNew as IESSOClientDisp;
end;

class function TTrasmitterDispFactory.GetModbusDispatcher: IMBDispatcherItf;
begin
  Result := nil;
  if not Assigned(ModbusDispatcher) then
   begin
    ModbusDispatcher        := TDispatcherModbusMaster.Create(nil);
//    ModbusDispatcher.AddRef;
    ModbusDispatcher.Logger := LoggerItfVar;
   end;
  Result := ModbusDispatcher as IMBDispatcherItf;
end;

class procedure TTrasmitterDispFactory.SetLoggerItf(LogItf: IDLogger);
begin
  if Assigned(EssoDispatcherNew) then EssoDispatcherNew.Logger := LogItf;
  if Assigned(ModbusDispatcher) then ModbusDispatcher.Logger := LogItf;

  LoggerItfVar := LogItf;
end;

class procedure TTrasmitterDispFactory.DestroyAllDispatchers;
begin
  if Assigned(EssoDispatcherNew) then
   begin
    FreeAndNil(EssoDispatcherNew);
   end;

  if Assigned(ModbusDispatcher) then
   begin
//    ModbusDispatcher.Release;
    FreeAndNil(ModbusDispatcher); //ModbusDispatcher := nil;
   end;

  LoggerItfVar := nil;
end;

initialization
 EssoDispatcherNew := nil;
 ModbusDispatcher  := nil;
 LoggerItfVar      := nil;
finalization
 TTrasmitterDispFactory.DestroyAllDispatchers;
end.
