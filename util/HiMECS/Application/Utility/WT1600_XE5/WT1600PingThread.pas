unit WT1600PingThread;

interface

uses
  Windows, SysUtils, Classes, Forms, Messages, MyKernelObject, CopyData, WT1600_Util;

type
  TWT1600PingThread = class(TThread)
  private
    FOwner: TForm;
    function DoPing(AIpAddress: Ansistring): Boolean;
  public
    FIpAddress: Ansistring;
    FPingResult: Boolean;
    FStopPing: boolean;
    FEventHandle: TEvent;//Send한 후 Receive할때까지 Wait하는 Event
    FTimeOut: integer;//Event 대기하는 시간(mSec) - INFINITE
    FPowerMeterNo: word;//Power Meter No.
    FPingInterval: integer;
    //////////////////////////////
    FIPAddr: IPAddr;
    FIcmpHandle: THandle;
    function DoPing2(AIpAddress: Ansistring): Boolean;
    function Ping3(AIPAddr : IPAddr; AHandle: THandle) : boolean;
    //////////////////////////////
    procedure Execute; override;
    constructor Create(AOwner: TForm; AIpAddress: Ansistring);
    destructor Destroy; override;
    procedure CheckPowerMeterOn;
  end;

implementation

uses WT1600Const;

{ TWT1600PingThread }

procedure TWT1600PingThread.Execute;
begin
  while not Terminated do
  begin
    if FStopPing then
      Suspend;

    if FEventHandle.Wait(FTimeOut) then
    begin
      if terminated then
        exit;

      CheckPowerMeterOn;
      //Sleep(FPingInterval);
    end;
  end;//while

end;

function TWT1600PingThread.Ping3(AIPAddr: IPAddr; AHandle: THandle): boolean;
var
 DW : DWORD;
 rep : array[1..128] of byte;
begin
  result := TRUE;
  DW := IcmpSendEcho(AHandle, AIPAddr, nil, 0, nil, @rep, 128, 500);
  Result := (DW <> 0);
end;

procedure TWT1600PingThread.CheckPowerMeterOn;
var
  LInt: word;
  LIPAddr: IPAddr;
  LMsg: TMessage;
begin
  //while true do
  //begin
    //if FStopPing then
      //break;

    //if DoPing(FIPAddress) then
    if DoPing2(FIPAddress) then
    begin
      LMsg.WParamLo := 1;
      FPingResult := True;
      //SendCopyData2(FOwner.Handle, FIPAddress + ' Ping Successed!!!', 2);
      //FWT1600CommThread.FPingOK := True;
    end
    else
    begin
      LMsg.WParamLo := 0;
      FPingResult := False;
      //FWT1600CommThread.FPingOK := False;
      SendCopyData2(FOwner.Handle, FIPAddress + ' Ping Failed!!!', 2);
    end;

    //LMsg.WParamLo := Lint;
    LMsg.WParamHi := FPowerMeterNo;
    //TranslateStringToTInAddr(FIPAddress, LIPAddr);

    SendMessage(FOwner.Handle, WM_POWERMETER_ON, LMsg.WParam, 0);
    //SendMessage(FOwner.Handle, WM_POWERMETER_ON, LMsg.WParam, LIPAddr.S_addr);
    //Application.processMessages;
    //Sleep(FPingInterval);
  //end;//while
end;

constructor TWT1600PingThread.Create(AOwner: TForm; AIpAddress: Ansistring);
begin
  inherited Create(True);

  FOwner := AOwner;
  FStopPing := False;
  FTimeOut := INFINITE;//3000;
  FIpAddress := AIpAddress;
  TranslateStringToTInAddr(FIpAddress, FIPAddr);
  FIcmpHandle := IcmpCreateFile;

  if FIcmpHandle = INVALID_HANDLE_VALUE then
    SendCopyData2(FOwner.Handle, 'IcmpCreateFile Fail!!!', 2);
    
  FEventHandle := TEvent.Create('WT1600PingEvent',False);
end;

destructor TWT1600PingThread.Destroy;
begin
  IcmpCloseHandle(FIcmpHandle);
  FreeAndNil(FEventHandle);//.Free;

  inherited;
end;

function TWT1600PingThread.DoPing(AIpAddress: Ansistring): Boolean;
begin
  if AIpAddress = '' then
    Result := False
  else
  if Ping(AIpAddress) then
    Result := True
  else
    Result := False;
  //do_ping('10.14.21.112', Memo1.Lines);
end;

function TWT1600PingThread.DoPing2(AIpAddress: Ansistring): Boolean;
begin
  if AIpAddress = '' then
    Result := False
  else
  if Ping3(FIPAddr, FIcmpHandle) then
  //if Ping2(FIPAddr) then
    Result := True
  else
    Result := False;
end;

end.
