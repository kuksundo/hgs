//Failed in Delphi XE, fixed in Delphi XE2 Update 4
//http://stackoverflow.com/questions/4856306/tthreadedqueue-not-capable-of-multiple-consumers
//http://qc.embarcadero.com/wc/qcmain.aspx?d=91246
//http://qc.embarcadero.com/wc/qcmain.aspx?d=101114   (Resolved)
program DelphiVault.Tests.Manual.MultipleConsumerFailure;

{$APPTYPE CONSOLE}

{$R *.res}
uses
  Windows,
  Messages,
  Classes,
  SysUtils,
  SyncObjs,
  Generics.Collections;

type TThreadTaskMsg =
       class(TObject)
         private
           threadID  : integer;
           threadMsg : string;
         public
           Constructor Create( ID : integer; const msg : string);
       end;

type TThreadReader =
       class(TThread)
         private
           fPopQueue   : TThreadedQueue<TObject>;
           fSync       : TCriticalSection;
           fMsg        : TThreadTaskMsg;
           fException  : Exception;
           procedure DoSync;
           procedure DoHandleException;
         public
           Constructor Create( popQueue : TThreadedQueue<TObject>;
                               sync     : TCriticalSection);
           procedure Execute; override;
       end;

Constructor TThreadReader.Create( popQueue : TThreadedQueue<TObject>;
                                  sync     : TCriticalSection);
begin
  fPopQueue:=            popQueue;
  fMsg:=                 nil;
  fSync:=                sync;
  Self.FreeOnTerminate:= FALSE;
  fException:=           nil;

  Inherited Create( FALSE);
end;

procedure TThreadReader.DoSync ;
begin
  WriteLn(fMsg.threadMsg + ' ' + IntToStr(fMsg.threadId));
end;

procedure TThreadReader.DoHandleException;
begin
  WriteLn('Exception ->' + fException.Message);
end;

procedure TThreadReader.Execute;
var signal : TWaitResult;
begin
  NameThreadForDebugging('QueuePop worker');
  while not Terminated do
  begin
    try
      {- Calling PopItem can return empty without waittime !? Let other threads in by sleeping. }
      Sleep(20);
      {- Serializing calls to PopItem works }
      if Assigned(fSync) then fSync.Enter;
      try
        signal:= fPopQueue.PopItem( TObject(fMsg));
      finally
        if Assigned(fSync) then fSync.Release;
      end;
      if (signal = wrSignaled) then
      begin
        try
          if Assigned(fMsg) then
          begin
            fMsg.threadMsg:= '<Thread id :' +IntToStr( Self.threadId) + '>';
            fMsg.Free; // We are just dumping the message in this test
            //Synchronize( Self.DoSync);
            //PostMessage( fParentForm.Handle,WM_TestQueue_Message,Cardinal(fMsg),0);
          end;
        except
          on E:Exception do begin
          end;
        end;
      end;
      except
       FException:= Exception(ExceptObject);
      try
        if not (FException is EAbort) then
        begin
          {Synchronize(} DoHandleException; //);
        end;
      finally
        FException:= nil;
      end;
   end;
  end;
end;

Constructor TThreadTaskMsg.Create( ID : Integer; Const msg : string);
begin
  Inherited Create;

  threadID:= ID;
  threadMsg:= msg;
end;

var
    fSync : TCriticalSection;
    fThreadQueue : TThreadedQueue<TObject>;
    fReaderArr : array[1..4] of TThreadReader;
    i : integer;
    iLoop:Integer;

begin
  try
    IsMultiThread:= TRUE;

    fSync:=        TCriticalSection.Create;
    fThreadQueue:= TThreadedQueue<TObject>.Create(1024,1,100);
    try
      {- Calling without fSync throws exceptions when two or more threads calls PopItem
         at the same time }
      WriteLn('Creating worker threads ...');
      for i:= 1 to 4 do fReaderArr[i]:= TThreadReader.Create( fThreadQueue,Nil);
      {- Calling with fSync works ! }
      //for i:= 1 to 4 do fReaderArr[i]:= TThreadReader.Create( fThreadQueue,fSync);
       WriteLn('Init done. Pushing items ...');

      iLoop := 0;
      while iLoop < 1000 do  //overly stress it, and it still fails after fix in XE2
      begin
        inc(iLoop);
        writeln('Loop: ' + IntToStr(iLoop));
        for i:= 1 to 100 do fThreadQueue.PushItem( TThreadTaskMsg.Create( i,''));
      end;

      ReadLn;

    finally
      for i:= 1 to 4 do fReaderArr[i].Free;
      fThreadQueue.Free;
      fSync.Free;
    end;

  except
    on E: Exception do
      begin
        Writeln(E.ClassName, ': ', E.Message);
        ReadLn;
      end;
  end;
end.

