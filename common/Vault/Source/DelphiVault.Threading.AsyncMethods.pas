// Written with Delphi XE3 Pro
// Created Nov 24, 2012 by Darian Miller
//
// Based on answer by Smasher on Feb 17, 2009 to question:
// http://stackoverflow.com/questions/554142/indy-10-idtcpclient-reading-data-using-a-separate-thread
// which also references a blog article:
// http://delphidicas.blogspot.com/2008/08/anonymous-methods-when-should-they-be.html
//
unit DelphiVault.Threading.AsyncMethods;

interface
uses
  System.Classes;

type
  TAsyncCall = reference to procedure(const ThreadPayload:String);

  TAsyncMethod = class
  private type
    TMotileThread = class(TThread)
    private
      fMethodCall:TAsyncCall;
      fTerminateHandler:TAsyncCall;
      fSyncTerminateHandler:Boolean;
      fThreadPayload:String;
      procedure OnTerminateHandler(Sender:TObject);
    protected
      procedure Execute(); override;
    public
      constructor Create(const MethodCall:TAsyncCall;
                         const ThreadPayload:String;
                         const OnTerminateCallback:TAsyncCall;
                         const SyncOnTerminate:Boolean);
    end;
  public
    class procedure Execute(const MethodCall:TAsyncCall;
                            const ThreadPayload:String='';
                            const OnTerminateCallback:TAsyncCall=nil;
                            const SyncOnTerminate:Boolean=False);
  end;


implementation
uses
  WinApi.Windows;


class procedure TAsyncMethod.Execute(const MethodCall:TAsyncCall;
                                     const ThreadPayload:String='';
                                     const OnTerminateCallback:TAsyncCall=nil;
                                     const SyncOnTerminate:Boolean=False);
var
  vThread:TMotileThread;
begin
  vThread := TMotileThread.Create(MethodCall, ThreadPayload, OnTerminateCallback, SyncOnTerminate);
  vThread.Start();
end;


constructor TAsyncMethod.TMotileThread.Create(const MethodCall:TAsyncCall;
                                              const ThreadPayload:String;
                                              const OnTerminateCallback:TAsyncCall;
                                              const SyncOnTerminate:Boolean);
begin
  inherited Create(True);
  fMethodCall := MethodCall;
  fTerminateHandler := OnTerminateCallback;
  fSyncTerminateHandler := SyncOnTerminate;
  fThreadPayload := ThreadPayload;
  OnTerminate := OnTerminateHandler;

  //We create and leave this thread alone after it's started.
  //If the main application terminates, Windows will forcibly terminate any
  //outstanding threads
  FreeOnTerminate := True;
end;

procedure TAsyncMethod.TMotileThread.Execute();
begin
  fMethodCall(fThreadPayload);
end;

procedure TAsyncMethod.TMotileThread.OnTerminateHandler(Sender:TObject);
begin
  if Assigned(fTerminateHandler) then
    if fSyncTerminateHandler then
      Synchronize(
        procedure
        begin
          fTerminateHandler(fThreadPayload);
        end)
    else
      fTerminateHandler(fThreadPayload);
end;

end.
