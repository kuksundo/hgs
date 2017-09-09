//   Copyright 2015 Asbjørn Heid
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
unit IPC.Events;

interface

uses
  Winapi.Windows, System.SysUtils;

type
{$REGION 'Implementation details'}
  Detail = record type
    IEvent = interface
      function GetIsSignalled: boolean;

      procedure WaitFor(const Timeout: cardinal);
      procedure Signal;

      property IsSignalled: boolean read GetIsSignalled;
    end;

    TEventImpl = class(TInterfacedObject, IEvent)
    strict private
      FEventHandle: THandle;
    public
      constructor Create(const Name: string);
      destructor Destroy; override;

      procedure WaitFor(const Timeout: cardinal);
      procedure Signal;

      function GetIsSignalled: boolean;
    end;
  end;
{$ENDREGION}

  Event = record
  strict private
    FImpl: Detail.IEvent;
    function GetIsSignalled: boolean;
  private
    property Impl: Detail.IEvent read FImpl;
  public
    class function Create(const Name: string): Event; static;
    class operator Implicit(const Impl: Detail.IEvent): Event;

    procedure WaitForSignal(const TimeoutInMilliseconds: cardinal = INFINITE);
    procedure Signal;

    property IsSignalled: boolean read GetIsSignalled;
  end;


implementation

{ Detail.TEventImpl }

constructor Detail.TEventImpl.Create(const Name: string);
begin
  inherited Create;

  FEventHandle := CreateEvent(nil, False, False, PChar(Name));
  if (FEventHandle = 0) then
    RaiseLastOSError();
end;

destructor Detail.TEventImpl.Destroy;
begin
  CloseHandle(FEventHandle);

  inherited;
end;

function Detail.TEventImpl.GetIsSignalled: boolean;
var
  r: cardinal;
begin
  r := WaitForSingleObject(FEventHandle, 0);
  if (r = WAIT_FAILED) then
    RaiseLastOSError();

  result := (r = WAIT_OBJECT_0);
end;

procedure Detail.TEventImpl.Signal;
begin
  SetEvent(FEventHandle);
end;

procedure Detail.TEventImpl.WaitFor(const Timeout: cardinal);
var
  r: cardinal;
begin
  r := WaitForSingleObject(FEventHandle, Timeout);
  if (r = WAIT_FAILED) then
    RaiseLastOSError();
end;

{ Event }

class function Event.Create(const Name: string): Event;
begin
  result := Detail.TEventImpl.Create(Name);
end;

function Event.GetIsSignalled: boolean;
begin
  result := Impl.IsSignalled;
end;

class operator Event.Implicit(const Impl: Detail.IEvent): Event;
begin
  result.FImpl := Impl;
end;

procedure Event.Signal;
begin
  Impl.Signal;
end;

procedure Event.WaitForSignal(const TimeoutInMilliseconds: cardinal);
begin
  Impl.WaitFor(TimeoutInMilliseconds);
end;

end.
