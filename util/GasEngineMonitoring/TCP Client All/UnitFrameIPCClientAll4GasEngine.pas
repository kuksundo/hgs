unit UnitFrameIPCClientAll4GasEngine;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, IPCThrd_LBX, IPCThrdMonitor_LBX,
  IPCThrd_WT1600, IPCThrd_ECS_kumo, IPCThrd_MEXA7000, IPCThrd_MT210,
  IPCThrd_FlowMeter, IPCThrd_DYNAMO, IPCThrd_ECS_AVAT, IPCThrd_GasCalc,
  UnitFrameIPCClientAll, DataStruct4GasEngine, HiMECSConst;

type
  TFrame = TFrameIPCClientAll;

  TFrameIPCClientAll4GasEngine = class(TFrame)
  private

  public
    FData: TEventData_IPCAll;

    procedure IPCAll_Init;
    procedure IPCAll_Final;
    procedure DataDistrubute;
    procedure IPCAll_Pulse;
  end;

implementation

{$R *.dfm}

{ TFrameIPCClientAll4GasEngine }

procedure TFrameIPCClientAll4GasEngine.DataDistrubute;
begin
  system.Move(FData.ECS_AVAT_Data, FECSData_AVAT, Sizeof(FECSData_AVAT));
  system.Move(FData.WT1600, FWT1600Data, Sizeof(FWT1600Data));
  system.Move(FData.MEXA7000, FMEXA7000Data, Sizeof(FMEXA7000Data));
  system.Move(FData.GasCalc, FGasCalcData, Sizeof(FGasCalcData));
  system.Move(FData.MT210, FMT210Data, Sizeof(FMT210Data));

  {if FData.ModBusMode = 3 then
    System.Move(FData.ECS_AVAT_Data,  FECSData_AVAT.InpDataBuf_double, Sizeof(FData.ECS_AVAT_Data))
  else
    System.Move(FData.ECS_AVAT_Data2,  FECSData_AVAT.InpDataBuf, Sizeof(FData.ECS_AVAT_Data2));

  FECSData_AVAT.ModBusFunctionCode := FData.ModBusFunctionCode;
  FECSData_AVAT.ModBusMode := FData.ModBusMode;
  FECSData_AVAT.NumOfData := FData.NumOfData;
  FECSData_AVAT.BlockNo := FData.BlockNo;

  FWT1600Data.URMS1 := FloatToStr(FData.WT1600[0]);
  FWT1600Data.URMS2 := FloatToStr(FData.WT1600[1]);
  FWT1600Data.URMS3 := FloatToStr(FData.WT1600[2]);
  FWT1600Data.IRMS1 := FloatToStr(FData.WT1600[3]);
  FWT1600Data.IRMS2 := FloatToStr(FData.WT1600[4]);
  FWT1600Data.IRMS3 := FloatToStr(FData.WT1600[5]);
  FWT1600Data.PSIGMA := FloatToStr(FData.WT1600[6]);
  FWT1600Data.SSIGMA := FloatToStr(FData.WT1600[7]);
  FWT1600Data.QSIGMA := FloatToStr(FData.WT1600[8]);
  FWT1600Data.RAMDA := FloatToStr(FData.WT1600[9]);
  FWT1600Data.URMSAVG := FloatToStr(FData.WT1600[10]);
  FWT1600Data.IRMSAVG := FloatToStr(FData.WT1600[11]);
  FWT1600Data.FREQUENCY := FloatToStr(FData.WT1600[12]);
  FWT1600Data.F1 := FloatToStr(FData.WT1600[13]);

  FMEXA7000Data.CO2 := FloatToStr(FData.MEXA7000[0]);
  FMEXA7000Data.CO_L := FloatToStr(FData.MEXA7000[1]);
  FMEXA7000Data.O2 := FloatToStr(FData.MEXA7000[2]);
  FMEXA7000Data.NOx := FloatToStr(FData.MEXA7000[3]);
  FMEXA7000Data.THC := FloatToStr(FData.MEXA7000[4]);
  FMEXA7000Data.CH4 := FloatToStr(FData.MEXA7000[5]);
  FMEXA7000Data.non_CH4 := FloatToStr(FData.MEXA7000[6]);
  FMEXA7000Data.CollectedValue := FData.MEXA7000[7];

  FGasCalcData.FSVP := FData.GasCalc[0];
  FGasCalcData.FIAH2 := FData.GasCalc[1];
  FGasCalcData.FUFC := FData.GasCalc[2];
  FGasCalcData.FNhtCF := FData.GasCalc[3];
  FGasCalcData.FDWCFE := FData.GasCalc[4];
  FGasCalcData.FEGF := FData.GasCalc[5];
  FGasCalcData.FNOxAtO213 := FData.GasCalc[6];
  FGasCalcData.FNOx := FData.GasCalc[7];
  FGasCalcData.FAF1 := FData.GasCalc[8];
  FGasCalcData.FAF2 := FData.GasCalc[9];
  FGasCalcData.FAF3 := FData.GasCalc[10];
  FGasCalcData.FAF_Measured := FData.GasCalc[11];
  FGasCalcData.FMT210 := FData.GasCalc[12];
  FGasCalcData.FFC := FData.GasCalc[13];
  FGasCalcData.FEngineOutput := FData.GasCalc[14];
  FGasCalcData.FGeneratorOutput := FData.GasCalc[15];
  FGasCalcData.FEngineLoad := FData.GasCalc[16];
  FGasCalcData.FGenEfficiency := FData.GasCalc[17];
  FGasCalcData.FBHP := FData.GasCalc[18];
  FGasCalcData.FBMEP := FData.GasCalc[19];
  FGasCalcData.FLamda_Calculated := FData.GasCalc[20];
  FGasCalcData.FLamda_Measured := FData.GasCalc[21];
  FGasCalcData.FLamda_Brettschneider := FData.GasCalc[22];
  FGasCalcData.FAFRatio_Calculated := FData.GasCalc[23];
  FGasCalcData.FAFRatio_Measured := FData.GasCalc[24];
  FGasCalcData.FExhTempAvg := FData.GasCalc[25];
  FGasCalcData.FWasteGatePosition := FData.GasCalc[26];
  FGasCalcData.FThrottlePosition := FData.GasCalc[27];
  FGasCalcData.FBoostPress := FData.GasCalc[28];
  FGasCalcData.FDensity := FData.GasCalc[29];
  FGasCalcData.FLCV := FData.GasCalc[30];

  FMT210Data.FData := FData.MT210;
  }
end;

procedure TFrameIPCClientAll4GasEngine.IPCAll_Final;
begin
  DestroyIPCClient(psECS_AVAT);
  DestroyIPCClient(psMT210);
  DestroyIPCClient(psMEXA7000);
  DestroyIPCClient(psWT1600);
  DestroyIPCClient(psGasCalculated);
end;

procedure TFrameIPCClientAll4GasEngine.IPCAll_Init;
begin
  FEngineParameterItemRecord.FParameterSource := psECS_AVAT;
  CreateIPCClient(FEngineParameterItemRecord);

  FEngineParameterItemRecord.FParameterSource := psMT210;
  CreateIPCClient(FEngineParameterItemRecord);

  FEngineParameterItemRecord.FParameterSource := psMEXA7000;
  CreateIPCClient(FEngineParameterItemRecord);

  FEngineParameterItemRecord.FParameterSource := psWT1600;
  FEngineParameterItemRecord.FSharedName := '192.168.0.48';
  CreateIPCClient(FEngineParameterItemRecord);

  FEngineParameterItemRecord.FParameterSource := psGasCalculated;
  CreateIPCClient(FEngineParameterItemRecord);
end;

procedure TFrameIPCClientAll4GasEngine.IPCAll_Pulse;
begin
  FIPCClient_ECS_AVAT.PulseMonitor(FECSData_AVAT);
  FIPCClient_WT1600.PulseMonitor(FWT1600Data);
  FIPCClient_MEXA7000.PulseMonitor(FMEXA7000Data);
  FIPCClient_MT210.PulseMonitor(FMT210Data);
  FIPCClient_GasCalc.PulseMonitor(FGasCalcData);
end;

end.
