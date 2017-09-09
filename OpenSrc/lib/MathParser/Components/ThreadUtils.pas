{ *********************************************************************** }
{                                                                         }
{ ThreadUtils                                                             }
{                                                                         }
{ Copyright (c) 2008 Pisarev Yuriy (post@pisarev.net)                     }
{                                                                         }
{ *********************************************************************** }

unit ThreadUtils;

{$B-}

interface

uses
  Windows, Classes, Forms, Thread;

procedure Enter(var Lock: TRTLCriticalSection);
function TryEnter(var Lock: TRTLCriticalSection): Boolean;
procedure Leave(var Lock: TRTLCriticalSection);
procedure WaitFor(const ThreadArray: array of TThread); overload;
procedure WaitFor(const ThreadList: TList); overload;

implementation

procedure Enter(var Lock: TRTLCriticalSection);
begin
  EnterCriticalSection(Lock);
end;

function TryEnter(var Lock: TRTLCriticalSection): Boolean;
begin
  Result := TryEnterCriticalSection(Lock);
end;

procedure Leave(var Lock: TRTLCriticalSection);
begin
  LeaveCriticalSection(Lock);
end;

procedure WaitFor(const ThreadArray: array of TThread);
var
  I: Integer;
begin
  for I := Low(ThreadArray) to High(ThreadArray) do
    while not ThreadArray[I].Finished do Application.HandleMessage;
end;

procedure WaitFor(const ThreadList: TList);
var
  I: Integer;
begin
  for I := 0 to ThreadList.Count - 1 do
    while not TThread(ThreadList[I]).Finished do Application.HandleMessage;
end;

end.
