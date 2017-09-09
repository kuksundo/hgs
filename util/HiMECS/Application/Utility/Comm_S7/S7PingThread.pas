unit S7PingThread;

interface

uses
  Windows, SysUtils, Classes, Forms, Messages, MyKernelObject, CopyData, UnitPing;

type
  TPLCPingThread = class(TThread)
  private
    FOwner: TForm;
  public
    FIpAddress: Ansistring;
    FPingResult: Boolean;
    FStopPing: boolean;
    FEventHandle: TEvent;//Send한 후 Receive할때까지 Wait하는 Event
    FTimeOut: integer;//Event 대기하는 시간(mSec) - INFINITE
    FPingInterval: integer;
    //////////////////////////////
    Fping: Tping;
    //////////////////////////////
    procedure Execute; override;
    constructor Create(AOwner: TForm; AIpAddress: Ansistring);
    destructor Destroy; override;
    procedure CheckPLCOn;
  end;

implementation

{ TPLCPingThread }

procedure TPLCPingThread.Execute;
begin
  while not Terminated do
  begin
    if FStopPing then
      Suspend;

    if FEventHandle.Wait(FTimeOut) then
    begin
      if terminated then
        exit;

      CheckPLCOn;
      //Sleep(FPingInterval);
    end;
  end;//while

end;

procedure TPLCPingThread.CheckPLCOn;
var
  str:string;
begin
  if Fping.pinghost(FIpAddress,str) then
  begin
    FPingResult := True;
  end
  else
  begin
    FPingResult := False;
    SendCopyData2(FOwner.Handle, FIPAddress + ' Ping Failed!!!', 2);
  end;

//  SendMessage(FOwner.Handle, WM_POWERMETER_ON, LMsg.WParam, 0);
end;

constructor TPLCPingThread.Create(AOwner: TForm; AIpAddress: Ansistring);
begin
  inherited Create(True);

  FOwner := AOwner;
  FStopPing := False;
  FTimeOut := INFINITE;//3000;
  FIpAddress := AIpAddress;

  Fping:=Tping.create;

  FEventHandle := TEvent.Create('S7PingEvent',False);
end;

destructor TPLCPingThread.Destroy;
begin
  FreeAndNil(Fping);
  FreeAndNil(FEventHandle);//.Free;

  inherited;
end;

end.
