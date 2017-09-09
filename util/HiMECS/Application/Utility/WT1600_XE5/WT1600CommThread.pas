unit WT1600CommThread;

interface

uses Windows, SysUtils, classes, Forms, MyKernelObject, CopyData, Dialogs,
    tmctl_h, WT1600Connection;

type
  TWT1600CommThread = class(TThread)
    FOwner: TForm;
    //FStoreType: TStoreType; //저장방식(ini or registry)
    FQueryInterval: integer;//통신 Query 간격(mSec)
    FStopComm: Boolean;//통신 일시 중지 = True
    FTimeOut: integer;//통신 Send후 다음 Send까지 대기하는 시간(mSec) - INFINITE
    FErrorMessage: TStringList;

    procedure SetStopComm(Value: Boolean);
    procedure SetTimeOut(Value: integer);
    procedure SetQueryInterval(Value: integer);

  protected
    procedure Execute; override;

  public
    FEventHandle: TEvent;//Send한 후 Receive할때까지 Wait하는 Event
    FSendCommandList: TStringList;//WT1600 통신 명령 리스트
    FWT1600Connection: TWT1600Connection;
    FWT1600Connected: boolean;//WT1600 연결 상태 저장
    FWT1600ID: integer; //WT1600 통신에 필요한 ID
    FPingOK: boolean;//ping 성공시 true
    FIsInitExec: Boolean;//초기화 수행 여부

    constructor Create(AOwner: TForm; AIpAddress: Ansistring;
      AUserName: Ansistring; AModel: integer = 0);
    destructor Destroy; override;
    procedure SendQuery;
    function QueryData(AMaxLength: integer; AMsg: Ansistring; var Abuf: array of Ansichar):Boolean;
    procedure InitVar(APMID: integer);
    procedure SendItemSettings;
    procedure DispWT1600Error(AErrNo: integer);
    procedure InitErrorMsg;
  published
    property StopComm: Boolean read FStopComm write SetStopComm;
    property TimeOut: integer read FTimeOut write SetTimeOut;
    property QueryInterval: integer read FQueryInterval write SetQueryInterval;
  end;

implementation

uses WT1600_Util;

{ TWT1600CommThread }

constructor TWT1600CommThread.Create(AOwner: TForm;AIpAddress: Ansistring;
  AUserName: Ansistring; AModel: integer = 0);
begin
  inherited Create(True);

  FWT1600Connection := TWT1600Connection.Create(0,'',AModel);
  FWT1600Connection.IpAddress := AIpAddress;
  //{$IFDEF WT500}
  if AModel = 0 then
  begin
    FWT1600Connection.ConnectAddress := FWT1600Connection.IpAddress;
    FWT1600Connection.ConnectType := 8;//(for WT500)
  end
  else
  begin
    //{$ELSE}
    FWT1600Connection.ConnectAddress := FWT1600Connection.IpAddress + ',' + AUserName + ',';//(for WT1600)
    FWT1600Connection.ConnectType := 4;//TM_CTL_ETHER;//(for WT1600)
    //{$ENDIF}
  end;

  FOwner := AOwner;
  FStopComm := False;
  FEventHandle := TEvent.Create('WT1600CommEvent'+FWT1600Connection.IpAddress,False);
  SendCopyData2(FOwner.Handle, 'FEventHandle: ' + FWT1600Connection.IpAddress, 1);
  FSendCommandList := TStringList.Create;
  FErrorMessage := TStringList.Create;
  FTimeOut := INFINITE;//3000; //3초 기다린 후에 계속 명령을 전송함(Default = INFINITE)
  FIsInitExec := False;
  FQueryInterval := 0;
end;

destructor TWT1600CommThread.Destroy;
begin
  FreeAndNil(FErrorMessage);
  SendCopyData2(FOwner.Handle, 'FreeAndNil(FErrorMessage)', 1);
  FreeAndNil(FEventHandle);//.Free;
  SendCopyData2(FOwner.Handle, 'FreeAndNil(FEventHandle)', 1);
  FreeAndNil(FSendCommandList);//.Free;
  SendCopyData2(FOwner.Handle, 'FreeAndNil(FSendCommandList)', 1);
  //FWT1600Connection.Finish;
  //SendCopyData2(FOwner.Handle, 'FWT1600Connection.Finish', 2);
  //FreeAndNil(FWT1600Connection);//.Finish;
  FWT1600Connection.destroy;
  SendCopyData2(FOwner.Handle, 'FreeAndNil(FWT1600Connection)', 1);
  //ShowMessage('bbb');
  //inherited;

end;

procedure TWT1600CommThread.InitVar(APMID: integer);
begin
  InitErrorMsg;

  if FWT1600Connected then
  begin
    FWT1600Connected := False;
    FWT1600Connection.Finish;
  end;

  FWT1600Connection.ConnectID := APMID;

  if FPingOK then
  begin
    if FWT1600Connection.Initialize = 0 then
    begin
      FWT1600Connected := True;
      SendCopyData2(FOwner.Handle, 'WT1600 Connect Succeed',1);
    end
    else
    begin
      FWT1600Connected := False;
      FWT1600Connection.Finish;
      DispWT1600Error(FWT1600Connection.GetLastError);
      SendCopyData2(FOwner.Handle, 'WT1600 Connect Failed', 2);
      exit;
    end;//else
  end;
end;

procedure TWT1600CommThread.SendItemSettings;
var
  Li: integer;
  LMsg: Ansistring;
  LBuf: TDynaArray;
begin
  if FPingOK and FWT1600Connected then
  begin
    LMsg := Ansistring(':NUMERIC:FORMAT ASCII');
    SendCopyData2(FOwner.Handle,LMsg,0);
    Li := FWT1600Connection.Send(LMsg);

    if Li <> 0 then
      DispWT1600Error(FWT1600Connection.GetLastError());

    LMsg := Ansistring(':NUMERIC:NORMAL:NUMBER 12');
    SendCopyData2(FOwner.Handle,LMsg,0);
    Li := FWT1600Connection.Send(LMsg);

    if Li <> 0 then
      DispWT1600Error(FWT1600Connection.GetLastError());

    //LMsg := Ansistring(':NUMERIC:NORMAL:ITEM1 URMS,1;ITEM2 URMS,2;ITEM3 URMS,3;ITEM4 IRMS,1;ITEM5 IRMS,2;ITEM6 IRMS,3;ITEM7 FU,1;ITEM8 LAMBDA,1;ITEM9 P,SIGMA;ITEM10 S,SIGMA;ITEM11 Q,SIGMA');
    LMsg := Ansistring(':NUMERIC:NORMAL:ITEM1 URMS,1;ITEM2 URMS,2;ITEM3 URMS,3;ITEM4 IRMS,1;ITEM5 IRMS,2;ITEM6 IRMS,3;ITEM7 FU,1;ITEM8 LAMBDA,SIGMA;ITEM9 P,SIGMA;ITEM10 S,SIGMA;ITEM11 Q,SIGMA;ITEM12 F1');
    SendCopyData2(FOwner.Handle,LMsg,0);
    Li := FWT1600Connection.Send(LMsg);

    if Li <> 0 then
      DispWT1600Error(FWT1600Connection.GetLastError());
  end
  else
    SendCopyData2(FOwner.Handle, 'SendItemSettings: WT1600 not connected!', 2);
end;

procedure TWT1600CommThread.Execute;
begin
  while not terminated do
  begin

    if terminated then
      exit;

    if FStopComm then
      Suspend;

    if FEventHandle.Wait(FTimeOut) then
    begin
      if terminated then
        exit;

      if not FPingOK then
      begin
        SendCopyData2(FOwner.Handle, 'FPingOK Failure!!!', 2);
        continue;
      end;

      if FIsInitExec then
      begin
        InitVar(1);//FWT1600ID

        if FWT1600Connected then
        begin
          SendItemSettings;
          FIsInitExec := False;
        end;//if
      end;//if

      //Sleep(FQueryInterval);
      if FWT1600Connected then
        SendQuery
      else
        SendCopyData2(FOwner.Handle, 'Not connect to WT1600', 1);
    end;
  end;//while
end;

//FSendCommandList 에 있는 명령어를 WT1600에 전송함
procedure TWT1600CommThread.SendQuery;
var
  i: integer;
  LMsg: Ansistring;
  //LBuf: TDynaArray;
begin
  //Thread가 Suspend되면 종료시에 Resume을 한번 해 주므로
  //종료시에 이 루틴이 실행되지 않게 하기 위함
  if StopComm then
    exit;

  if FPingOK and FWT1600Connected then
  begin
    for i := 0 to FSendCommandList.Count - 1 do
    begin
      if StopComm then
        exit;

      //LBuf := nil;
      //SetLength(LBuf, 15*11);
      SendCopyData2(FOwner.Handle, FSendCommandList.Strings[i], 0);
      LMsg := FSendCommandList.Strings[i];

      if not QueryData(15*11, LMsg, FWT1600Connection.m_aData) then
      begin
        SendCopyData2(FOwner.Handle, 'QueryData Failure!!!', 1);
        FIsInitExec := True;
        //LBuf := nil;
        exit;
      end;//if

      LMsg := Ansistring(FWT1600Connection.m_aData);//LBuf);
      LMsg := GetToken(LMsg, #10);
      //data인 경우에는 마지막 파라미터에 4를 대입함.
      SendCopyData2(FOwner.Handle, LMsg, 4);
      //LBuf :=nil;
      {if FEventHandle.Wait(FTimeOut) then
      begin
        if terminated then
          exit;
      end
      else
        Continue;
      }
      Sleep(FQueryInterval);
    end;//for
  end
  else
  begin
{    SetLength(LBuf, 15*11);
    FillChar(LBuf,15*11, '0');
    LMsg := String(LBuf);
    LMsg := GetToken(LMsg, #10); }
    //wt1600에 연결이 안된 경우에는 마지막 파라미터에 5를 대입함.(데이타 초기화 때문임)
    SendCopyData2(FOwner.Handle, 'Can''t connect to WT1600', 5);
    SendCopyData2(FOwner.Handle, 'Can''t connect to WT1600', 1);
  end;
end;

//AMsg 명령어를 WT1600에 전송함
function TWT1600CommThread.QueryData(AMaxLength: integer; AMsg: Ansistring; var Abuf: array of Ansichar):Boolean;
var
  Li: integer;
  LRealLength: integer;
begin
  //Send Command.
  Li := FWT1600Connection.Send(AMsg);

  if Li <> 0 then
  begin
    DispWT1600Error(Li);
    Result := False;
    exit;
  end;//if

  //Queries Data.
  //SetLength(Abuf, AMaxLength);
  Li := FWT1600Connection.Receive(@Abuf[0], AMaxLength, @LRealLength );

  if Li <> 0 then
  begin
    DispWT1600Error(Li);
    Result := False;
    exit;
  end;//if
  Result := True;
end;

procedure TWT1600CommThread.SetQueryInterval(Value: integer);
begin
  if FQueryInterval <> Value then
    FQueryInterval := Value;
end;

procedure TWT1600CommThread.SetStopComm(Value: Boolean);
begin
  if FStopComm <> Value then
  begin
    FStopComm := Value;

    if FStopComm then
      //Suspend
    else
      if Suspended then
        Resume;
  end;
end;

procedure TWT1600CommThread.SetTimeOut(Value: integer);
begin
  if FTimeOut <> Value then
    FTimeOUt := Value;
end;

procedure TWT1600CommThread.DispWT1600Error(AErrNo: integer);
var
  Li: integer;
begin
  Li := 0;

  if AErrNo = 0 then
    SendCopyData2(FOwner.Handle, 'getting detail error failed.', 1)
  else
  begin
    //while ((2 shl Li) <> AErrNo) do
    //  inc(Li);
    if AErrNo < FErrorMessage.Count then
      SendCopyData2(FOwner.Handle, FErrorMessage.Strings[AErrNo], 1)
    else
      SendCopyData2(FOwner.Handle, 'Unknown error msg no: (' +IntToStr(AErrNo) + ')', 1);
  end;
end;

procedure TWT1600CommThread.InitErrorMsg;
begin
  FErrorMessage.Add('Device not found: Check the wiring.');
  FErrorMessage.Add('Connection to device failed: Check the wiring.');
  FErrorMessage.Add('Device not connected: Connect the device using the initialization function.');
  FErrorMessage.Add('Device already connected: Two connections cannot be opened.');
  FErrorMessage.Add('Incompatible PC: Check the hardware you are using.');
  FErrorMessage.Add('Illegal parameter: Check parameter type etc.');
  FErrorMessage.Add('');
  FErrorMessage.Add('Send error: Check the wiring, address, and ID.');
  FErrorMessage.Add('Receive error: Check whether an error occurred on the device.');
  FErrorMessage.Add('Received data not block data');
  FErrorMessage.Add('System error: There is a problem with the operating environment.');
  FErrorMessage.Add('Illegal device ID: Use the ID of the device acquired by the initialization function.');
end;

end.
