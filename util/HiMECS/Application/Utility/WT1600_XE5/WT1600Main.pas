unit WT1600Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, iLed, iLedRound, StdCtrls, iComponent,
  iVCLComponent, iCustomComponent, iSwitchLed, iPanel, MyKernelObject, CopyData,
  IPCThrd_WT1600, IPCThrdMonitor_WT1600, WT1600ComStruct,  WT1600Const, ComCtrls;

type
  TDisplayTarget = (dtSendMemo, dtRecvMemo, dtStatusBar);

  TWT1600MainF = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    New1: TMenuItem;
    Open1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Window1: TMenuItem;
    Tile1: TMenuItem;
    Cascade1: TMenuItem;
    Arrangeicons1: TMenuItem;
    Panel1: TPanel;
    CreateAll1: TMenuItem;
    N2: TMenuItem;
    PowerMeter11: TMenuItem;
    PowerMeter21: TMenuItem;
    PowerMeter31: TMenuItem;
    PowerMeter41: TMenuItem;
    PowerMeter51: TMenuItem;
    PowerMeter61: TMenuItem;
    PowerMeter71: TMenuItem;
    PowerMeter81: TMenuItem;
    PowerMeter91: TMenuItem;
    iPanel1: TiPanel;
    iLedRound1: TiLedRound;
    iPanel2: TiPanel;
    iLedRound2: TiLedRound;
    iPanel3: TiPanel;
    iLedRound3: TiLedRound;
    iPanel4: TiPanel;
    iLedRound4: TiLedRound;
    iPanel5: TiPanel;
    iLedRound5: TiLedRound;
    iPanel6: TiPanel;
    iLedRound6: TiLedRound;
    iPanel7: TiPanel;
    iLedRound7: TiLedRound;
    iPanel8: TiPanel;
    iLedRound8: TiLedRound;
    iPanel9: TiPanel;
    iLedRound9: TiLedRound;
    CreateAll2: TMenuItem;
    N3: TMenuItem;
    PowerMeter12: TMenuItem;
    PowerMeter22: TMenuItem;
    PowerMeter32: TMenuItem;
    PowerMeter42: TMenuItem;
    PowerMeter52: TMenuItem;
    PowerMeter62: TMenuItem;
    PowerMeter72: TMenuItem;
    PowerMeter82: TMenuItem;
    PowerMeter92: TMenuItem;
    Timer1: TTimer;
    SendComMemo: TMemo;
    StatusBar1: TStatusBar;
    procedure Exit1Click(Sender: TObject);
    procedure Tile1Click(Sender: TObject);
    procedure Cascade1Click(Sender: TObject);
    procedure Arrangeicons1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure WMPowerMeterOn(var Msg: TMessage); message WM_POWERMETER_ON;
    procedure PowerMeter11Click(Sender: TObject);
    procedure PowerMeter21Click(Sender: TObject);
    procedure PowerMeter31Click(Sender: TObject);
    procedure PowerMeter41Click(Sender: TObject);
    procedure PowerMeter51Click(Sender: TObject);
    procedure PowerMeter61Click(Sender: TObject);
    procedure PowerMeter71Click(Sender: TObject);
    procedure PowerMeter81Click(Sender: TObject);
    procedure PowerMeter91Click(Sender: TObject);
    procedure CreateAll1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PowerMeter12Click(Sender: TObject);
    procedure PowerMeter22Click(Sender: TObject);
    procedure PowerMeter32Click(Sender: TObject);
    procedure PowerMeter42Click(Sender: TObject);
    procedure PowerMeter52Click(Sender: TObject);
    procedure PowerMeter62Click(Sender: TObject);
    procedure PowerMeter72Click(Sender: TObject);
    procedure PowerMeter82Click(Sender: TObject);
    procedure PowerMeter92Click(Sender: TObject);
    procedure CreateAll2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure OnSignal1(Sender: TIPCThread_WT1600; Data: TEventData_WT1600);
    procedure OnSignal2(Sender: TIPCThread_WT1600; Data: TEventData_WT1600);
    procedure OnSignal3(Sender: TIPCThread_WT1600; Data: TEventData_WT1600);
    procedure OnSignal4(Sender: TIPCThread_WT1600; Data: TEventData_WT1600);
    procedure OnSignal5(Sender: TIPCThread_WT1600; Data: TEventData_WT1600);
    procedure OnSignal6(Sender: TIPCThread_WT1600; Data: TEventData_WT1600);
    procedure OnSignal7(Sender: TIPCThread_WT1600; Data: TEventData_WT1600);
    procedure OnSignal8(Sender: TIPCThread_WT1600; Data: TEventData_WT1600);
    procedure OnSignal9(Sender: TIPCThread_WT1600; Data: TEventData_WT1600);

    procedure WMWT1600Data1(var Msg: TMessage); message WM_WT1600DATA1;
    procedure WMWT1600Data2(var Msg: TMessage); message WM_WT1600DATA2;
    procedure WMWT1600Data3(var Msg: TMessage); message WM_WT1600DATA3;
    procedure WMWT1600Data4(var Msg: TMessage); message WM_WT1600DATA4;
    procedure WMWT1600Data5(var Msg: TMessage); message WM_WT1600DATA5;
    procedure WMWT1600Data6(var Msg: TMessage); message WM_WT1600DATA6;
    procedure WMWT1600Data7(var Msg: TMessage); message WM_WT1600DATA7;
    procedure WMWT1600Data8(var Msg: TMessage); message WM_WT1600DATA8;
    procedure WMWT1600Data9(var Msg: TMessage); message WM_WT1600DATA9;
  public
    FFirst: Boolean;//맨처음에 실행될때 True 그 다음부터는 False
    FMonitorStart: Boolean; //타이머 동작 완료하면 True

    FIPCMonitor: array[1..CMaxMonitorCount] of TIPCMonitor_WT1600;//공유 메모리 및 이벤트 객체
    FWT1600On: array[1..CMaxMonitorCount] of Boolean;
    FIPAddress: array[1..CMaxMonitorCount] of string;
    FWMWT1600Data: array[1..CMaxMonitorCount] of TWMWT1600Data; //공유메모리로부터 받은 데이터 저장

    procedure InitVar;
    procedure DisplayMessage(msg: string; ADspNo: TDisplayTarget);
  end;

var
  WT1600MainF: TWT1600MainF;

implementation

uses WaitForm;

{$R *.dfm}

procedure TWT1600MainF.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TWT1600MainF.Tile1Click(Sender: TObject);
begin
  Tile;
end;

procedure TWT1600MainF.Timer1Timer(Sender: TObject);
var
  Li: integer;
begin
  with Timer1 do
  begin
    Enabled := False;
    try
      if FFirst then
      begin
        FFirst := False;
        FMonitorStart := True;
        for Li := 1 to CMaxMonitorCount do
        begin
          FIPCMonitor[Li] := TIPCMonitor_WT1600.Create(0, FIPAddress[Li], True);
          //FIPCMonitor[Li].Priority := tpLowest;
          FIPCMonitor[Li].Resume;
          DisplayMessage('Shared Memory: ' + FIPAddress[Li] + ' Created!', dtSendMemo);
        end;//for

        FIPCMonitor[1].OnSignal := OnSignal1;
        FIPCMonitor[2].OnSignal := OnSignal2;
        FIPCMonitor[3].OnSignal := OnSignal3;
        FIPCMonitor[4].OnSignal := OnSignal4;
        FIPCMonitor[5].OnSignal := OnSignal5;
        FIPCMonitor[6].OnSignal := OnSignal6;
        FIPCMonitor[7].OnSignal := OnSignal7;
        FIPCMonitor[8].OnSignal := OnSignal8;
        FIPCMonitor[9].OnSignal := OnSignal9;

      end;
    finally
      Enabled := True;
    end;//try
  end;//with
end;

procedure TWT1600MainF.Cascade1Click(Sender: TObject);
begin
  Cascade;
end;

procedure TWT1600MainF.Arrangeicons1Click(Sender: TObject);
begin
  ArrangeIcons;
end;

procedure TWT1600MainF.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Li: integer;
  LF: TWaitF;
begin
  FMonitorStart := False;

  for Li := 1 to CMaxMonitorCount do
  begin
    FreeAndNil(FIPCMonitor[Li]);
  end;

  LF := TWaitF.Create(self);
  LF.Show;

  try
    for Li := MDIChildCount - 1 downto 0 do
    begin
      LF.ProgressBar1.Position := Round((Li / MDIChildCount) * 100);
      LF.Label3.Caption := MDIChildren[Li].Caption + ' 종료중...';
      LF.Update;
      MDIChildren[Li].Close;
      //Application.ProcessMessages;
    end;
  finally
    LF.Close;
    LF.Free;
  end;
{  if Assigned(FPM9Handle) then
    FreeAndNil(FPM9Handle);

  if Assigned(FPM8Handle) then
    FreeAndNil(FPM8Handle);


  if Assigned(FPM7Handle) then
    FreeAndNil(FPM7Handle);


  if Assigned(FPM6Handle) then
    FreeAndNil(FPM6Handle);


  if Assigned(FPM5Handle) then
    FreeAndNil(FPM5Handle);


  if Assigned(FPM4Handle) then
    FreeAndNil(FPM4Handle);


  if Assigned(FPM3Handle) then
    FreeAndNil(FPM3Handle);


  if Assigned(FPM2Handle) then
    FreeAndNil(FPM2Handle);


  if Assigned(FPM1Handle) then
    FreeAndNil(FPM1Handle);
}
end;

procedure TWT1600MainF.FormCreate(Sender: TObject);
begin
  InitVar;
end;

procedure TWT1600MainF.FormResize(Sender: TObject);
begin
  //ShowMessage('');
end;

procedure TWT1600MainF.InitVar;
begin
  FFirst := True;
  FMonitorStart := False;

  FIPAddress[1] := '192.168.0.41';
  FIPAddress[2] := '192.168.0.42';
  FIPAddress[3] := '192.168.0.43';
  FIPAddress[4] := '192.168.0.44';
  FIPAddress[5] := '192.168.0.45';
  FIPAddress[6] := '192.168.0.46';
  FIPAddress[7] := '192.168.0.47';
  FIPAddress[8] := '192.168.0.48';
  FIPAddress[9] := '192.168.0.49';
end;

procedure TWT1600MainF.OnSignal1(Sender: TIPCThread_WT1600; Data: TEventData_WT1600);
begin
  if not FMonitorStart then
    exit;

  with TiPanel(FindComponent('iPanel' + IntToStr(Data.PowerMeterNo))) do
    TitleText := FIPAddress[Data.PowerMeterNo];

  with TiLedRound(FindComponent('iLedRound' + IntToStr(Data.PowerMeterNo))) do
    Active := Data.PowerMeterOn;
end;

procedure TWT1600MainF.OnSignal2(Sender: TIPCThread_WT1600; Data: TEventData_WT1600);
begin
  if not FMonitorStart then
    exit;

  with TiPanel(FindComponent('iPanel' + IntToStr(Data.PowerMeterNo))) do
    TitleText := FIPAddress[Data.PowerMeterNo];

  with TiLedRound(FindComponent('iLedRound' + IntToStr(Data.PowerMeterNo))) do
    Active := Data.PowerMeterOn;
end;

procedure TWT1600MainF.OnSignal3(Sender: TIPCThread_WT1600; Data: TEventData_WT1600);
begin
  if not FMonitorStart then
    exit;

  with TiPanel(FindComponent('iPanel' + IntToStr(Data.PowerMeterNo))) do
    TitleText := FIPAddress[Data.PowerMeterNo];

  with TiLedRound(FindComponent('iLedRound' + IntToStr(Data.PowerMeterNo))) do
    Active := Data.PowerMeterOn;
end;

procedure TWT1600MainF.OnSignal4(Sender: TIPCThread_WT1600; Data: TEventData_WT1600);
begin
  if not FMonitorStart then
    exit;

  with TiPanel(FindComponent('iPanel' + IntToStr(Data.PowerMeterNo))) do
    TitleText := FIPAddress[Data.PowerMeterNo];

  with TiLedRound(FindComponent('iLedRound' + IntToStr(Data.PowerMeterNo))) do
    Active := Data.PowerMeterOn;
end;

procedure TWT1600MainF.OnSignal5(Sender: TIPCThread_WT1600; Data: TEventData_WT1600);
begin
  if not FMonitorStart then
    exit;

  with TiPanel(FindComponent('iPanel' + IntToStr(Data.PowerMeterNo))) do
    TitleText := FIPAddress[Data.PowerMeterNo];

  with TiLedRound(FindComponent('iLedRound' + IntToStr(Data.PowerMeterNo))) do
    Active := Data.PowerMeterOn;
end;

procedure TWT1600MainF.OnSignal6(Sender: TIPCThread_WT1600; Data: TEventData_WT1600);
begin
  if not FMonitorStart then
    exit;

  with TiPanel(FindComponent('iPanel' + IntToStr(Data.PowerMeterNo))) do
    TitleText := FIPAddress[Data.PowerMeterNo];

  with TiLedRound(FindComponent('iLedRound' + IntToStr(Data.PowerMeterNo))) do
    Active := Data.PowerMeterOn;
end;

procedure TWT1600MainF.OnSignal7(Sender: TIPCThread_WT1600; Data: TEventData_WT1600);
begin
  if not FMonitorStart then
    exit;

  with TiPanel(FindComponent('iPanel' + IntToStr(Data.PowerMeterNo))) do
    TitleText := FIPAddress[Data.PowerMeterNo];

  with TiLedRound(FindComponent('iLedRound' + IntToStr(Data.PowerMeterNo))) do
    Active := Data.PowerMeterOn;
end;

procedure TWT1600MainF.OnSignal8(Sender: TIPCThread_WT1600; Data: TEventData_WT1600);
begin
  if not FMonitorStart then
    exit;

  with TiPanel(FindComponent('iPanel' + IntToStr(Data.PowerMeterNo))) do
    TitleText := FIPAddress[Data.PowerMeterNo];

  with TiLedRound(FindComponent('iLedRound' + IntToStr(Data.PowerMeterNo))) do
    Active := Data.PowerMeterOn;
end;

procedure TWT1600MainF.OnSignal9(Sender: TIPCThread_WT1600; Data: TEventData_WT1600);
begin
  if not FMonitorStart then
    exit;

  with TiPanel(FindComponent('iPanel' + IntToStr(Data.PowerMeterNo))) do
    TitleText := FIPAddress[Data.PowerMeterNo];

  with TiLedRound(FindComponent('iLedRound' + IntToStr(Data.PowerMeterNo))) do
    Active := Data.PowerMeterOn;
end;

procedure TWT1600MainF.WMPowerMeterOn(var Msg: TMessage);
var
  //LInAddr: IPAddr;
  LIPAddr: string;
  Lstr: string;
  LTiPanel: TiPanel;
  LTiLedRound: TiLedRound;
begin
  //LInAddr.S_un_b := (Msg.LParam);
  //LInAddr.S_addr := (Msg.LParam);
  //LIPAddr := TInAddrToString(LInAddr);
  LIPAddr := '192.168.0.4' + IntToStr(Msg.WParamHi);

  LTiPanel := TiPanel(FindComponent('iPanel' + IntToStr(Msg.WParamHi)));

  if Assigned(LTiPanel) then
    LTiPanel.TitleText := LIPAddr;

  LTiLedRound := TiLedRound(FindComponent('iLedRound' + IntToStr(Msg.WParamHi)));

  if Assigned(LTiLedRound) then
    LTiLedRound.Active := (Msg.WParamLo = 1);
end;

procedure TWT1600MainF.WMWT1600Data1(var Msg: TMessage);
begin

end;

procedure TWT1600MainF.WMWT1600Data2(var Msg: TMessage);
begin

end;

procedure TWT1600MainF.WMWT1600Data3(var Msg: TMessage);
begin

end;

procedure TWT1600MainF.WMWT1600Data4(var Msg: TMessage);
begin

end;

procedure TWT1600MainF.WMWT1600Data5(var Msg: TMessage);
begin

end;

procedure TWT1600MainF.WMWT1600Data6(var Msg: TMessage);
begin

end;

procedure TWT1600MainF.WMWT1600Data7(var Msg: TMessage);
begin

end;

procedure TWT1600MainF.WMWT1600Data8(var Msg: TMessage);
begin

end;

procedure TWT1600MainF.WMWT1600Data9(var Msg: TMessage);
begin

end;

procedure TWT1600MainF.PowerMeter11Click(Sender: TObject);
begin
  WinExec(PAnsiChar('.\WT1600CommSDI_XE.exe 1'), SW_SHOWNOACTIVATE);
end;

procedure TWT1600MainF.PowerMeter12Click(Sender: TObject);
var
  Lwnd: THandle;
begin
  Lwnd := FindWindow(nil, 'Power Meter (192.168.0.41)');
  if Lwnd > 32 then // 찾았으면
    PostMessage(Lwnd, WM_QUIT, 0, 0);
end;

procedure TWT1600MainF.PowerMeter21Click(Sender: TObject);
begin
  WinExec(PAnsiChar('.\WT1600CommSDI_XE.exe 2'), SW_SHOWNOACTIVATE);
end;

procedure TWT1600MainF.PowerMeter22Click(Sender: TObject);
var
  Lwnd: THandle;
begin
  Lwnd := FindWindow(nil, 'Power Meter (192.168.0.42)');
  if Lwnd > 32 then // 찾았으면
    PostMessage(Lwnd, WM_QUIT, 0, 0);
end;

procedure TWT1600MainF.PowerMeter31Click(Sender: TObject);
begin
  WinExec(PAnsiChar('.\WT1600CommSDI_XE.exe 3'), SW_SHOWNOACTIVATE);
end;

procedure TWT1600MainF.PowerMeter32Click(Sender: TObject);
var
  Lwnd: THandle;
begin
  Lwnd := FindWindow(nil, 'Power Meter (192.168.0.43)');
  if Lwnd > 32 then // 찾았으면
    PostMessage(Lwnd, WM_QUIT, 0, 0);
end;

procedure TWT1600MainF.PowerMeter41Click(Sender: TObject);
begin
  WinExec(PAnsiChar('.\WT1600CommSDI_XE.exe 4'), SW_SHOWNOACTIVATE);
end;

procedure TWT1600MainF.PowerMeter42Click(Sender: TObject);
var
  Lwnd: THandle;
begin
  Lwnd := FindWindow(nil, 'Power Meter (192.168.0.44)');
  if Lwnd > 32 then // 찾았으면
    PostMessage(Lwnd, WM_QUIT, 0, 0);
end;

procedure TWT1600MainF.PowerMeter51Click(Sender: TObject);
begin
  WinExec(PAnsiChar('.\WT1600CommSDI_XE.exe 5'), SW_SHOWNOACTIVATE);
end;

procedure TWT1600MainF.PowerMeter52Click(Sender: TObject);
var
  Lwnd: THandle;
begin
  Lwnd := FindWindow(nil, 'Power Meter (192.168.0.45)');
  if Lwnd > 32 then // 찾았으면
    PostMessage(Lwnd, WM_QUIT, 0, 0);
end;

procedure TWT1600MainF.PowerMeter61Click(Sender: TObject);
begin
  WinExec(PAnsiChar('.\WT1600CommSDI_XE.exe 6'), SW_SHOWNOACTIVATE);
end;

procedure TWT1600MainF.PowerMeter62Click(Sender: TObject);
var
  Lwnd: THandle;
begin
  Lwnd := FindWindow(nil, 'Power Meter (192.168.0.46)');
  if Lwnd > 32 then // 찾았으면
    PostMessage(Lwnd, WM_QUIT, 0, 0);
end;

procedure TWT1600MainF.PowerMeter71Click(Sender: TObject);
begin
  WinExec(PAnsiChar('.\WT1600CommSDI_XE.exe 7'), SW_SHOWNOACTIVATE);
end;

procedure TWT1600MainF.PowerMeter72Click(Sender: TObject);
var
  Lwnd: THandle;
begin
  Lwnd := FindWindow(nil, 'Power Meter (192.168.0.47)');
  if Lwnd > 32 then // 찾았으면
    PostMessage(Lwnd, WM_QUIT, 0, 0);
end;

procedure TWT1600MainF.PowerMeter81Click(Sender: TObject);
begin
  WinExec(PAnsiChar('.\WT1600CommSDI_XE.exe 8'), SW_SHOWNOACTIVATE);
end;

procedure TWT1600MainF.PowerMeter82Click(Sender: TObject);
var
  Lwnd: THandle;
begin
  Lwnd := FindWindow(nil, 'Power Meter (192.168.0.48)');
  if Lwnd > 32 then // 찾았으면
    PostMessage(Lwnd, WM_QUIT, 0, 0);
end;

procedure TWT1600MainF.PowerMeter91Click(Sender: TObject);
begin
  WinExec(PAnsiChar('.\WT1600CommSDI_XE.exe 9'), SW_SHOWNOACTIVATE);
end;

procedure TWT1600MainF.PowerMeter92Click(Sender: TObject);
var
  Lwnd: THandle;
begin
  Lwnd := FindWindow(nil, 'Power Meter (192.168.0.49)');
  if Lwnd > 32 then // 찾았으면
    PostMessage(Lwnd, WM_QUIT, 0, 0);
end;

procedure TWT1600MainF.CreateAll1Click(Sender: TObject);
var
  Li: integer;
  LMenuItem: TMenuItem;
begin
  //CreateAll1.Checked := True;

  for Li := 1 to 9 do
  begin
    LMenuItem := TMenuItem(FindComponent('PowerMeter' + IntToStr(Li) + '1'));

    if Assigned(LMenuItem) then
    begin
      LMenuItem.Checked := False;
      LMenuItem.Click;
    end;//if
  end;//for
end;

procedure TWT1600MainF.CreateAll2Click(Sender: TObject);
var
  Li: integer;
  LMenuItem: TMenuItem;
begin
  for Li := 1 to 9 do
  begin
    LMenuItem := TMenuItem(FindComponent('PowerMeter' + IntToStr(Li) + '2'));

    if Assigned(LMenuItem) then
    begin
      LMenuItem.Checked := False;
      LMenuItem.Click;
    end;//if
  end;//for
end;

procedure TWT1600MainF.DisplayMessage(msg: string; ADspNo: TDisplayTarget);
begin
  case ADspNo of
    dtSendMemo : begin
      if msg = ' ' then
      begin
        exit;
      end
      else
        ;

      with SendComMemo do
      begin
        if Lines.Count > 200 then
          Clear;

        Lines.Add(msg);
      end;//with
    end;//dtSendMemo

    dtStatusBar: begin
       StatusBar1.SimplePanel := True;
       StatusBar1.SimpleText := msg;
    end;//dtStatusBar
  end;//case

end;

end.
