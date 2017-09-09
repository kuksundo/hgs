unit UnitFrameIPCMonitorAll4GasEngine;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, IPCThrd_LBX, IPCThrdMonitor_LBX,
  IPCThrd_WT1600, IPCThrd_ECS_kumo, IPCThrd_MEXA7000, IPCThrd_MT210,
  IPCThrd_FlowMeter, IPCThrd_DYNAMO, IPCThrd_ECS_AVAT, IPCThrd_GasCalc,
  UnitFrameIPCMonitorAll, DataStruct4GasEngine;

type
  TFrame = TFrameIPCMonitorAll;

  TFrameIPCMonitorAll4GasEngine = class(TFrame)
  private
  public
    FEventData_IPCAll: TEventData_IPCAll;
    FMexa7000Data_2: TEventData_MEXA7000_2;
    FMexa7000Data: TEventData_MEXA7000;

    procedure WT1600_OnSignal(Sender: TIPCThread_WT1600; Data: TEventData_WT1600); override;
    procedure MEXA7000_OnSignal(Sender: TIPCThread_MEXA7000; Data: TEventData_MEXA7000); override;
    procedure MT210_OnSignal(Sender: TIPCThread_MT210; Data: TEventData_MT210); override;
    procedure ECS_OnSignal_kumo(Sender: TIPCThread_ECS_kumo; Data: TEventData_ECS_kumo); override;
    procedure ECS_OnSignal_AVAT(Sender: TIPCThread_ECS_AVAT; Data: TEventData_ECS_AVAT);override;
    procedure LBX_OnSignal(Sender: TIPCThread_LBX; Data: TEventData_LBX); override;
    procedure FlowMeter_OnSignal(Sender: TIPCThread_FlowMeter; Data: TEventData_FlowMeter); override;
    procedure DYNAMO_OnSignal(Sender: TIPCThread_DYNAMO; Data: TEventData_DYNAMO); override;
    procedure GasCalc_OnSignal(Sender: TIPCThread_GasCalc; Data: TEventData_GasCalc); override;

    procedure OverRide_WT1600(AData: TEventData_WT1600); override;
    procedure OverRide_MEXA7000(AData: TEventData_MEXA7000_2); override;
    procedure OverRide_MT210(AData: TEventData_MT210); override;
    procedure OverRide_ECS_kumo(AData: TEventData_ECS_kumo); override;
    procedure OverRide_ECS_AVAT(AData: TEventData_ECS_AVAT); override;
    procedure OverRide_LBX(AData: TEventData_LBX); override;
    procedure OverRide_FlowMeter(AData: TEventData_FlowMeter); override;
    procedure OverRide_DYNAMO(AData: TEventData_DYNAMO); override;
    procedure OverRide_GasCalc(AData: TEventData_GasCalc); override;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

{ TFrame1 }

procedure TFrameIPCMonitorAll4GasEngine.DYNAMO_OnSignal(
  Sender: TIPCThread_DYNAMO; Data: TEventData_DYNAMO);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroDYNAMO,5000);

  OverRide_DYNAMO(Data);
end;

procedure TFrameIPCMonitorAll4GasEngine.ECS_OnSignal_AVAT(
  Sender: TIPCThread_ECS_AVAT; Data: TEventData_ECS_AVAT);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroECS_AVAT,5000);

  OverRide_ECS_AVAT(Data);
end;

procedure TFrameIPCMonitorAll4GasEngine.ECS_OnSignal_kumo(
  Sender: TIPCThread_ECS_kumo; Data: TEventData_ECS_kumo);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroECS_kumo,5000);

  OverRide_ECS_kumo(Data);
end;

procedure TFrameIPCMonitorAll4GasEngine.FlowMeter_OnSignal(
  Sender: TIPCThread_FlowMeter; Data: TEventData_FlowMeter);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroFlowMeter,5000);

  OverRide_FlowMeter(Data);
end;

procedure TFrameIPCMonitorAll4GasEngine.GasCalc_OnSignal(
  Sender: TIPCThread_GasCalc; Data: TEventData_GasCalc);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroGasCalc,5000);

  OverRide_GasCalc(Data);
end;

procedure TFrameIPCMonitorAll4GasEngine.LBX_OnSignal(Sender: TIPCThread_LBX;
  Data: TEventData_LBX);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroLBX,5000);

  OverRide_LBX(Data);
end;

procedure TFrameIPCMonitorAll4GasEngine.MEXA7000_OnSignal(
  Sender: TIPCThread_MEXA7000; Data: TEventData_MEXA7000);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroMEXA7000,5000);

  system.Move(Data, FMexa7000Data, sizeof(FMexa7000Data));
  OverRide_MEXA7000(FMexa7000Data_2);
end;

procedure TFrameIPCMonitorAll4GasEngine.MT210_OnSignal(Sender: TIPCThread_MT210;
  Data: TEventData_MT210);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroMT210,5000);

  OverRide_MT210(Data);
end;

procedure TFrameIPCMonitorAll4GasEngine.OverRide_DYNAMO(AData: TEventData_DYNAMO);
begin

end;

procedure TFrameIPCMonitorAll4GasEngine.OverRide_ECS_AVAT(AData: TEventData_ECS_AVAT);
begin
  System.Move( AData, FEventData_IPCAll.ECS_AVAT_Data, Sizeof(FEventData_IPCAll.ECS_AVAT_Data));

{  if AData.ModBusMode = 3 then
    System.Move(AData.InpDataBuf_double, FEventData_IPCAll.ECS_AVAT_Data, Sizeof(AData.InpDataBuf_double))
  else
    System.Move(AData.InpDataBuf, FEventData_IPCAll.ECS_AVAT_Data2, Sizeof(AData.InpDataBuf));

  FEventData_IPCAll.ModBusFunctionCode := AData.ModBusFunctionCode;
  FEventData_IPCAll.ModBusMode := AData.ModBusMode;
  FEventData_IPCAll.NumOfData := AData.NumOfData;
  FEventData_IPCAll.BlockNo := AData.BlockNo;  }
end;

procedure TFrameIPCMonitorAll4GasEngine.OverRide_ECS_kumo(AData: TEventData_ECS_kumo);
begin
  //System.Move( AData, FEventData_IPCAll.ECS_AVAT_Data, Sizeof(FEventData_IPCAll.ECS_AVAT_Data));
  //FEventData_IPCAll.ModBusFunctionCode := AData.ModBusFunctionCode;
  //FEventData_IPCAll.ModBusMode := AData.ModBusMode;
  //FEventData_IPCAll.NumOfData := AData.NumOfData;
  //FEventData_IPCAll.BlockNo := AData.BlockNo;
end;

procedure TFrameIPCMonitorAll4GasEngine.OverRide_FlowMeter(AData: TEventData_FlowMeter);
begin

end;

procedure TFrameIPCMonitorAll4GasEngine.OverRide_GasCalc(AData: TEventData_GasCalc);
begin
  System.Move( AData, FEventData_IPCAll.GasCalc, Sizeof(FEventData_IPCAll.GasCalc));

{  FEventData_IPCAll.GasCalc[0] := AData.FSVP;
  FEventData_IPCAll.GasCalc[1] := AData.FIAH2;
  FEventData_IPCAll.GasCalc[2] := AData.FUFC;
  FEventData_IPCAll.GasCalc[3] := AData.FNhtCF;
  FEventData_IPCAll.GasCalc[4] := AData.FDWCFE;
  FEventData_IPCAll.GasCalc[5] := AData.FEGF;
  FEventData_IPCAll.GasCalc[6] := AData.FNOxAtO213;
  FEventData_IPCAll.GasCalc[7] := AData.FNOx;
  FEventData_IPCAll.GasCalc[8] := AData.FAF1;
  FEventData_IPCAll.GasCalc[9] := AData.FAF2;

  FEventData_IPCAll.GasCalc[10] := AData.FAF3;
  FEventData_IPCAll.GasCalc[11] := AData.FAF_Measured;
  FEventData_IPCAll.GasCalc[12] := AData.FMT210;
  FEventData_IPCAll.GasCalc[13] := AData.FFC;
  FEventData_IPCAll.GasCalc[14] := AData.FEngineOutput;
  FEventData_IPCAll.GasCalc[15] := AData.FGeneratorOutput;
  FEventData_IPCAll.GasCalc[16] := AData.FEngineLoad;
  FEventData_IPCAll.GasCalc[17] := AData.FGenEfficiency;
  FEventData_IPCAll.GasCalc[18] := AData.FBHP;
  FEventData_IPCAll.GasCalc[19] := AData.FBMEP;

  FEventData_IPCAll.GasCalc[20] := AData.FLamda_Calculated;
  FEventData_IPCAll.GasCalc[21] := AData.FLamda_Measured;
  FEventData_IPCAll.GasCalc[22] := AData.FLamda_Brettschneider;
  FEventData_IPCAll.GasCalc[23] := AData.FAFRatio_Calculated;
  FEventData_IPCAll.GasCalc[24] := AData.FAFRatio_Measured;
  FEventData_IPCAll.GasCalc[25] := AData.FExhTempAvg;
  FEventData_IPCAll.GasCalc[26] := AData.FWasteGatePosition;
  FEventData_IPCAll.GasCalc[27] := AData.FThrottlePosition;
  FEventData_IPCAll.GasCalc[28] := AData.FBoostPress;
  FEventData_IPCAll.GasCalc[29] := AData.FDensity;

  FEventData_IPCAll.GasCalc[30] := AData.FLCV;
  }
end;

procedure TFrameIPCMonitorAll4GasEngine.OverRide_LBX(AData: TEventData_LBX);
begin

end;

procedure TFrameIPCMonitorAll4GasEngine.OverRide_MEXA7000(AData: TEventData_MEXA7000_2);
begin
  System.Move( FMexa7000Data, FEventData_IPCAll.MEXA7000, Sizeof(FEventData_IPCAll.MEXA7000));
{  FEventData_IPCAll.MEXA7000[0] := AData.CO2;
  FEventData_IPCAll.MEXA7000[1] := AData.CO_L;
  FEventData_IPCAll.MEXA7000[2] := AData.O2;
  FEventData_IPCAll.MEXA7000[3] := AData.NOx;
  FEventData_IPCAll.MEXA7000[4] := AData.THC;
  FEventData_IPCAll.MEXA7000[5] := AData.CH4;
  FEventData_IPCAll.MEXA7000[6] := AData.non_CH4;
  FEventData_IPCAll.MEXA7000[7] := AData.CollectedValue;
}
end;

procedure TFrameIPCMonitorAll4GasEngine.OverRide_MT210(AData: TEventData_MT210);
begin
  System.Move( AData, FEventData_IPCAll.MT210, Sizeof(FEventData_IPCAll.MT210));
//  FEventData_IPCAll.MT210 := AData.FData;
end;

procedure TFrameIPCMonitorAll4GasEngine.OverRide_WT1600(AData: TEventData_WT1600);
begin
  System.Move(AData, FEventData_IPCALL.WT1600, sizeof(FEventData_IPCALL.WT1600));

{  FEventData_IPCAll.WT1600[0] := StrToFloatDef(AData.URMS1,0.0);
  FEventData_IPCAll.WT1600[1] := StrToFloatDef(AData.URMS2,0.0);
  FEventData_IPCAll.WT1600[2] := StrToFloatDef(AData.URMS3,0.0);
  FEventData_IPCAll.WT1600[3] := StrToFloatDef(AData.IRMS1,0.0);
  FEventData_IPCAll.WT1600[4] := StrToFloatDef(AData.IRMS2,0.0);
  FEventData_IPCAll.WT1600[5] := StrToFloatDef(AData.IRMS3,0.0);
  FEventData_IPCAll.WT1600[6] := StrToFloatDef(AData.PSIGMA,0.0);
  FEventData_IPCAll.WT1600[7] := StrToFloatDef(AData.SSIGMA,0.0);
  FEventData_IPCAll.WT1600[8] := StrToFloatDef(AData.QSIGMA,0.0);
  FEventData_IPCAll.WT1600[9] := StrToFloatDef(AData.RAMDA,0.0);
  FEventData_IPCAll.WT1600[10] := StrToFloatDef(AData.URMSAVG,0.0);
  FEventData_IPCAll.WT1600[11] := StrToFloatDef(AData.IRMSAVG,0.0);
  FEventData_IPCAll.WT1600[12] := StrToFloatDef(AData.FREQUENCY,0.0);
  FEventData_IPCAll.WT1600[13] := StrToFloatDef(AData.F1,0.0);   }
end;

procedure TFrameIPCMonitorAll4GasEngine.WT1600_OnSignal(
  Sender: TIPCThread_WT1600; Data: TEventData_WT1600);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroWT1600,5000);

  OverRide_WT1600(Data);
end;

end.
