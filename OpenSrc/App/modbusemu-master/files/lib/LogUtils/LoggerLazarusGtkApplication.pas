unit LoggerLazarusGtkApplication;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ExtCtrls, syncobjs,
  LoggerItf;

type

  { TGTKApplicationLogger }

  TGTKApplicationLogger = class(TComponent,IDLogger)
  private
   FCSection       : TCriticalSection;
   FEnableDebug    : Boolean;
   FEnableError    : Boolean;
   FEnableInfo     : Boolean;
   FEnableWarn     : Boolean;
   FLocalBuff      : TStringList;
   FBuffTimer      : TTimer;
   FLoggerStrings  : TStrings;
   procedure SetEnableDebug(AValue: Boolean);
   procedure SetEnableError(AValue: Boolean);
   procedure SetEnableInfo(AValue: Boolean);
   procedure SetEnableWarn(AValue: Boolean);
   procedure SetLoggerStrings(AValue: TStrings);
  protected
   procedure OnTimerProc(Sender : TObject);
  public
   constructor Create(AOwner: TComponent); override;
   destructor  Destroy; override;

   procedure info(Source, Msg: String); stdcall;
   procedure warn(Source, Msg: String); stdcall;
   procedure error(Source, Msg: String); stdcall;
   procedure debug(Source, Msg: String); stdcall;

   property  LoggerStrings : TStrings read FLoggerStrings write SetLoggerStrings;
   property  EnableInfo    : Boolean read FEnableInfo write SetEnableInfo default True;
   property  EnableWarn    : Boolean read FEnableWarn write SetEnableWarn default True;
   property  EnableDebug   : Boolean read FEnableDebug write SetEnableDebug default True;
   property  EnableError   : Boolean read FEnableError write SetEnableError default True;
  end;

procedure InitLogger;
procedure CloseLogger;

var LoggerObj : TGTKApplicationLogger;

implementation

procedure InitLogger;
begin
  if not Assigned(LoggerObj) then LoggerObj := TGTKApplicationLogger.Create(nil);
end;

procedure CloseLogger;
begin
  if Assigned(LoggerObj) then FreeAndNil(LoggerObj);
end;

{ TGTKApplicationLogger }

constructor TGTKApplicationLogger.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCSection    := TCriticalSection.Create;
  FLocalBuff   := TStringList.Create;
  FEnableDebug := True;
  FEnableError := True;
  FEnableInfo  := True;
  FEnableWarn  := True;
  FBuffTimer   := TTimer.Create(Nil);
  FBuffTimer.OnTimer := @OnTimerProc;
end;

destructor TGTKApplicationLogger.Destroy;
begin
  FBuffTimer.Free;
  FCSection.Free;
  FLocalBuff.Free;
  inherited Destroy;
end;

procedure TGTKApplicationLogger.SetLoggerStrings(AValue: TStrings);
begin
  if FLoggerStrings=AValue then Exit;
  FCSection.Enter;
  try
   if not Assigned(AValue) then OnTimerProc(Self);
   FLoggerStrings := AValue;
  finally
   FCSection.Leave;
  end;
end;

procedure TGTKApplicationLogger.SetEnableDebug(AValue: Boolean);
begin
  if FEnableDebug=AValue then Exit;
  FCSection.Enter;
  try
   FEnableDebug := AValue;
  finally
   FCSection.Leave;
  end;
end;

procedure TGTKApplicationLogger.SetEnableError(AValue: Boolean);
begin
  if FEnableError=AValue then Exit;
  FCSection.Enter;
  try
   FEnableError := AValue;
  finally
   FCSection.Leave;
  end;
end;

procedure TGTKApplicationLogger.SetEnableInfo(AValue: Boolean);
begin
  if FEnableInfo=AValue then Exit;
  FCSection.Enter;
  try
   FEnableInfo := AValue;
  finally
   FCSection.Leave;
  end;
end;

procedure TGTKApplicationLogger.SetEnableWarn(AValue: Boolean);
begin
  if FEnableWarn=AValue then Exit;
  FCSection.Enter;
  try
   FEnableWarn := AValue;
  finally
   FCSection.Leave;
  end;
end;

procedure TGTKApplicationLogger.OnTimerProc(Sender: TObject);
var TempRep  : String;
begin
 FCSection.Enter;
 try
  while FLocalBuff.Count > 0 do
   begin
    TempRep := FLocalBuff.Strings[0];
    FLocalBuff.Delete(0);
    if Assigned(FLoggerStrings) then FLoggerStrings.Add(TempRep)
     else
       if Pos('[error]', TempRep) = 0 then WriteLn(StdOut,TempRep)
        else WriteLn(StdErr,TempRep);
    if FLoggerStrings.Count > 10000 then FLoggerStrings.Delete(0);
   end;
 finally
  FCSection.Leave;
 end;
end;

procedure TGTKApplicationLogger.info(Source, Msg: String); stdcall;
begin
 FCSection.Enter;
 try
  if FEnableInfo then FLocalBuff.Add(Format('%s [Info] %s: %s',[FormatDateTime('hh:nn:ss,zzz',Now), Source,Msg]));
 finally
  FCSection.Leave;
 end;
end;

procedure TGTKApplicationLogger.warn(Source, Msg: String); stdcall;
begin
 FCSection.Enter;
 try
  if FEnableWarn then FLocalBuff.Add(Format('%s [warning] %s: %s',[FormatDateTime('hh:nn:ss,zzz',Now), Source,Msg]));
 finally
  FCSection.Leave;
 end;
end;

procedure TGTKApplicationLogger.error(Source, Msg: String); stdcall;
var TempThreadId : PtrUInt;
begin
 TempThreadId := GetCurrentThreadId;

 FCSection.Enter;
 try
  if FEnableError then FLocalBuff.Add(Format('%s [error][%s] %s: %s',[FormatDateTime('hh:nn:ss,zzz',Now), IntToStr(TempThreadId), Source,Msg]));
 finally
  FCSection.Leave;
 end;
end;

procedure TGTKApplicationLogger.debug(Source, Msg: String); stdcall;
var TempThreadId : PtrUInt;
begin
 TempThreadId := GetCurrentThreadId;

 FCSection.Enter;
 try
  if FEnableDebug then FLocalBuff.Add(Format('%s [debug][%s] %s: %s',[FormatDateTime('hh:nn:ss,zzz',Now), IntToStr(TempThreadId), Source,Msg]));
 finally
  FCSection.Leave;
 end;
end;

initialization
 InitLogger;

finalization;
 CloseLogger;

end.

