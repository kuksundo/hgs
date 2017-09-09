unit SelectTypes;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils, syncobjs,
     Sockets,
     {$IFDEF UNIX}
     BaseUnix,
     {$ELSE}
     winsock,
     {$ENDIF}
     LoggerItf;

type

  TSelectThread = class(TThreadLogged)
   private
    FSocket     : TSocket;
    FCSection   : TCriticalSection;
    FTimeOut    : Cardinal;
    FLastError  : Cardinal;
    FOnError    : TNotifyEvent;
    FOnSignaled : TNotifyEvent;
    FOnTimeOut  : TNotifyEvent;
    procedure SetTimeOut(AValue: Cardinal);
   protected
    procedure Execute; override;
   public
    constructor Create(ASocket : TSocket; ACSection : TCriticalSection = nil); virtual; reintroduce;

    property TimeOut    : Cardinal read FTimeOut write SetTimeOut default 1000;
    property LastError  : Cardinal read FLastError;

    property OnError    : TNotifyEvent read FOnError write FOnError;
    property OnTimeOut  : TNotifyEvent read FOnTimeOut write FOnTimeOut;
    property OnSignaled : TNotifyEvent read FOnSignaled write FOnSignaled;
  end;

implementation

uses {$IFDEF UNIX}SocketMisc,{$ENDIF} SocketResStrings;

{ TSelectThread }

constructor TSelectThread.Create(ASocket: TSocket; ACSection: TCriticalSection);
begin
  if ASocket = INVALID_SOCKET then raise Exception.Create(rsErrorSocketDescr);
  inherited Create(True,65535);
  FSocket   := ASocket;
  FCSection := ACSection;
  FTimeOut  := 1000;
  FLastError:= 0;
end;

procedure TSelectThread.SetTimeOut(AValue: Cardinal);
begin
  if FTimeOut=AValue then Exit;
  if AValue < 10 then FTimeOut := 10
   else FTimeOut:= AValue;
end;

procedure TSelectThread.Execute;
var TempTimeval   : timeval;
    Res           : Integer;
    TempReadFDSet : TFDSet;
begin
  {$IFDEF WINDOWS} TempReadFDSet.fd_count := 0; {$ELSE} TempReadFDSet[0] := 0; {$ENDIF}
  while not Terminated do
   begin
    TempTimeval.tv_sec := FTimeOut div 1000;
    TempTimeval.tv_usec := (FTimeOut mod 1000) * 1000;
    {$IFDEF UNIX}fpFD_ZERO{$ELSE}FD_ZERO{$ENDIF}(TempReadFDSet);
    {$IFDEF UNIX}fpFD_SET{$ELSE}FD_SET{$ENDIF}(FSocket,TempReadFDSet);
    Res := {$IFDEF UNIX}fpSelect{$ELSE}select{$ENDIF}(FSocket+1,@TempReadFDSet,nil,nil,@TempTimeval);
    case Res of
     -1 : begin // ошибка
           FLastError := {$IFDEF UNIX}fpgeterrno{$ELSE}GetLastOSError{$ENDIF};
           if Assigned(FCSection) then FCSection.Enter;
           try
            if Assigned(FOnError) then FOnError(Self);
           finally
            if Assigned(FCSection) then FCSection.Leave;
           end;
           FLastError := 0;
          end;
     0  : begin // таймаут
           if Assigned(FCSection) then FCSection.Enter;
           try
            if Assigned(FOnTimeOut) then FOnTimeOut(Self);
           finally
            if Assigned(FCSection) then FCSection.Leave;
           end;
          end;
    else        // пришли данные
     if Assigned(FCSection) then FCSection.Enter;
     try
      if Assigned(FOnSignaled) then FOnSignaled(Self);
     finally
      if Assigned(FCSection) then FCSection.Leave;
     end;
    end;
   end;
end;

end.

