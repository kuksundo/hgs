unit LoggerLinuxSysEvent ;

{$mode objfpc}{$H+}

interface

uses
  Classes , SysUtils,
  LoggerItf;

type
  { TLoggerLinuxSysEvent }

  TLoggerLinuxSysEvent = class(TComponent,IDLogger,IDLoggerLinuxSysLogSettings)
  private
   FOwnerName      : String;
   FLogEnable      : Boolean ;
   FLogLayerSet    : TLogMesTypeSet ;

   procedure SetLogEnable (AValue : Boolean );
   procedure WriteLogMsgToSysLog(MesType : TLogMesTypeEnum; AMessage : String); // запись сообщения в syslog

   procedure LogSysLogActivate;   // активация лога в syslog
   procedure LogSysLogDeActivate; // деактивация лога в syslog

   //IDLoggerLinuxSysLogSettings
   procedure setOwnerName(OwnName : String); stdcall;
   procedure setLogLayerSet(TypesSet : TLogMesTypeSet); stdcall;
   function  getLogLayerSet :TLogMesTypeSet; stdcall;
   procedure Activate; stdcall;
   procedure DeActivate;stdcall;

  public
   constructor Create(AOwner : TComponent); override;
   destructor  Destroy; override;

   //IDLogger
   procedure Info(Source, AMessage : String); stdcall;    // обёртка записи информационнго события
   procedure Debug(Source, AMessage : String); stdcall;   // обёртка записи отладочного события
   procedure Warn(Source, AMessage : String); stdcall; // обёртка записи предупреждения
   procedure Error(Source, AMessage : String); stdcall;   // обёртка записи сообщения об ошибке

   property OwnerName      : String read FOwnerName write FOwnerName;                     // имя программы использующей логгер
   property LogEnable      : Boolean read FLogEnable write SetLogEnable default True;     // вести или нет лог - при установке в True активируется
   property LogLayerSet    : TLogMesTypeSet read FLogLayerSet write FLogLayerSet;   // по умолчанию [lmtInfo,lmtError,lmtWarn]

  end;

procedure InitLogger;
procedure CloseLogger;

var LoggerObj : TLoggerLinuxSysEvent;


implementation

uses systemlog;

procedure InitLogger;
begin
  if not Assigned(LoggerObj) then LoggerObj := TLoggerLinuxSysEvent.Create(nil);
end;

procedure CloseLogger;
begin
  if Assigned(LoggerObj) then FreeAndNil(LoggerObj);
end;

{ TLoggerLinuxSysEvent }

constructor TLoggerLinuxSysEvent.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FOwnerName      := 'NoName';
  FLogEnable      := False;
  FLogLayerSet    := [lmtInfo,lmtDebug,lmtError,lmtWarn];
end;

destructor TLoggerLinuxSysEvent.Destroy ;
begin
  inherited;
end;

procedure TLoggerLinuxSysEvent .SetLogEnable (AValue : Boolean );
begin
  if FLogEnable = AValue then Exit ;

  if AValue then
   begin
    LogSysLogActivate;
   end
  else
   begin
    LogSysLogDeActivate;
   end;
  FLogEnable := AValue ;
end;

procedure TLoggerLinuxSysEvent .WriteLogMsgToSysLog (MesType : TLogMesTypeEnum ; AMessage : String );
begin
  case MesType of
   lmtDebug : begin
               syslog(LOG_INFO{LOG_DEBUG},PChar(Format('[DEBUG] %s',[AMessage])),[]);
              end;
   lmtError : begin
               syslog(LOG_ERR,PChar(Format('[ERROR] %s',[AMessage])),[]);
              end;
   lmtWarn  : begin
               syslog(LOG_WARNING,PChar(Format('[WARNING] %s',[AMessage])),[]);
              end;
   lmtInfo  : begin
               syslog(LOG_INFO,PChar(Format('[INFO] %s',[AMessage])),[]);
              end;
  end;
end;

procedure TLoggerLinuxSysEvent .Info (Source ,AMessage : String ); stdcall ;
begin
  if not FLogEnable then Exit;
  if (lmtInfo in FLogLayerSet) then
   begin
     WriteLogMsgToSysLog(lmtInfo,Format('[%s] %s',[Source,AMessage]));
   end;
end;

procedure TLoggerLinuxSysEvent .Debug (Source ,AMessage : String ); stdcall ;
begin
  if not FLogEnable then Exit;

  if (lmtDebug in FLogLayerSet) then
   begin
     WriteLogMsgToSysLog(lmtDebug,Format('[%s] %s',[Source,AMessage]));
   end;
end;

procedure TLoggerLinuxSysEvent .Warn (Source ,AMessage : String ); stdcall ;
begin
  if not FLogEnable then Exit;
  if (lmtWarn in FLogLayerSet) then
   begin
    WriteLogMsgToSysLog(lmtWarn,Format('[%s] %s',[Source,AMessage]));
   end;
end;

procedure TLoggerLinuxSysEvent .Error (Source ,AMessage : String ); stdcall ;
begin
  if not FLogEnable then Exit;
  if (lmtError in FLogLayerSet) then
   begin
    WriteLogMsgToSysLog(lmtError,Format('[%s] %s',[Source,AMessage]));
   end;
end;

procedure TLoggerLinuxSysEvent .LogSysLogActivate ;
begin
  openlog(PChar(FOwnerName),(LOG_CONS or LOG_PID or LOG_PERROR),LOG_USER);
end;

procedure TLoggerLinuxSysEvent .LogSysLogDeActivate ;
begin
  closelog;
end;

procedure TLoggerLinuxSysEvent .setOwnerName (OwnName : String ); stdcall ;
begin
   OwnerName := OwnName;
end;

procedure TLoggerLinuxSysEvent .setLogLayerSet (TypesSet : TLogMesTypeSet ); stdcall ;
begin
  LogLayerSet := TypesSet;
end;

function TLoggerLinuxSysEvent .getLogLayerSet : TLogMesTypeSet ; stdcall ;
begin
  Result := LogLayerSet;
end;

procedure TLoggerLinuxSysEvent .Activate ; stdcall ;
begin
  LogEnable := True;
end;

procedure TLoggerLinuxSysEvent .DeActivate ; stdcall ;
begin
  LogEnable := False;
end;

initialization
 InitLogger;

finalization;
 CloseLogger;

end.

