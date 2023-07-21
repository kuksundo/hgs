unit UnitEngineParamConst;

interface

uses Windows, Classes, StdCtrls, SysUtils, System.UITypes, System.Rtti, UnitEnumHelper;

type
  TDFCommissioningItem = (dfciNull,
    dfciSlowTurn, dfciCyclicSlowTurn, dfciEngineStart, dfciMPBuildUp, dfciMPTest,
    dfciDieselModeControl, dfciDVTControl, dfciLTVVControl, dfciGovernorTest3Step,
    dfciGasModeControl, dfciGRUControl, dfciChangeGas2Diesel, dfciChangeDiesel2Gas,
    dfciAFRControl, dfciCylinderBalance, dfciKnockControl, dfciGovernorTest5Strp,
    dfciFinal);

  TParameterCategory4AVAT2 = (pca2Null, pca2EngineSystem, pca2StartStopSeq, pca2SpeedControl,
                      pca2PowerControl, pca2AFRControl, pca2MFInjControl,
                      pca2MPInjControl, pca2MPPressControl, pca2FuelModeChangeOver,
                      pca2GasPressControl, pca2HTLTCooling, pca2CylinderBalancing,
                      pca2KnockControl_CylPress, pca2Mon_Fuel_StartAir, pca2Mon_LBLC,
                      pca2Mon_Exh_ChargeAir, pca2Mon_CoolingWater, pca2Mon_GasSystem,
                      pca2Mon_Power_Diverse, pca2Mon_Configure, pca2Mon_Others,
                      pca2Final);

  TParameterSubCategory4AVAT2 = (psca2Null,
    //Engine and System
    psca2EngineSetup, psca2TCPickUp, psca2SystemNode, psca2TestParam, psca2ESOption,
    psca2DVT,
    //Start and Stop Sequence
    psca2StartPrepNOption, psca2StartBlockLimit, psca2PreLubPump, psca2SpeedLimit,
    psca2WarmUp, psca2DieselActStart, psca2StopSeq, psca2SlowTurn, psca2ConfigPMS,
    //Speed Control
    psca2SCGeneral, psca2DieselSpeedControl, psca2GasSpeedControl,
    psca2DRSSpeedControl, psca2GRSSpeedControl, psca2LoadReject, psca2LoadStep,
    psca2EnergyTransition,
    //Power Control
    psca2BkupPower, psca2Power, psca2PowerDemand, psca2LoadReduct,
    psca2DieselPowerControl, psca2GasPowerControl, psca2PowerLimitMon,
    //AFR Control
    psca2AFRGeneral, psca2AFRController, psca2AFRChargeAir,
    psca2DVTSwitchOver, psca2JetAir, psca2ByPass,
    //Main Fuel Injection Control (Diesel + Gas)
    psca2MainDInject, psca2GasAdmi, psca2GasDurationA, psca2GasDurationB,
    psca2MSS, psca2MPI, psca2CCO,
    //Pilot Fuel Injection Control
    psca2MPGeneral, psca2MPSpeedControl, psca2MPLimitRate, psca2MPDurationOffset,
     psca2MPTimingOffset, psca2MPDurationValue,
    //Pilot Fuel Pressure Control
    psca2MPPresValue, psca2MPAct, psca2MPController, psca2MPMonitor,
    //Fuel Mode Changeover
    psca2FMGeneral, psca2DGChangeOver1, psca2DGChangeOver2, psca2DGChangeOver3,
    psca2GDChangeOver, psca2FuelShare,
    //Gas Pressure Control
    psca2GasPressCMP, psca2GasLeakMC, psca2GasStopSeq, psca2GasMon,
    //HT/LT Cooling
    psca2LTTempControl, psca2LTStbyPump, psca2HTTempControl,
    //Cylinder Balancing
    psca2GasDOIbg, psca2GasDOIbc, psca2MPbg, psca2MPbc,
    //Knock Control And Cylinder Pressure
    psca2KnockControl, psca2KnockSource, psca2PmaxHigh, psca2PmaxAvg,
    psca2DeviFromPmax, psca2MisFireDetect, psca2IMEPMon, psca2CylVibHighMon,
    //Monitoring (Fuel Oil / Start Air)
    psca2MonFOSAGeneral, psca2MonPT52, psca2MonPT5152, psca2MonTE52, psca2MonPT57,
    psca2MonTE58, psca2MonPT31, psca2MonPT3031, psca2MonTE31, psca2MonPT32,
    psca2MonCV321, psca2MonPT35, psca2MonFOTankLimit, psca2MonPT40, psca2MonPT41,
    //Monitoring (Lube Oil / Bearings / Liners / Crankcase)
    psca2MonPT62, psca2MonPT6162, psca2MonTE62, psca2MonPT63, psca2MonTE64,
    psca2MonPT66, psca2MonLOTankLevel, psca2MonTE05x, psca2MonTE06x, psca2MonTE07x,
    psca2MonPT03, psca2MonOMD,
    //Monitoring (Exhaust / Charge Air)
    psca2MonTE25xx, psca2MonTE26x, psca2MonTE29, psca2MonPT21, psca2MonTE21,
    psca2MonCV26GT26,
    //Monitoring (Cooling Water)
    psca2MonPT75, psca2MonTE75, psca2MonTE761762, psca2MonPT71, psca2MonTE71,
    psca2MonCV76ZT76, psca2MonCV73ZT73,
    //Monitoring (Gas System)
    psca2MonGACDuration, psca2MonPT87, psca2MonPT81, psca2MonPT8081,
    psca2MonTE82, psca2MonPT82, psca2MonPT83, psca2MonPT89, psca2MonPT99,
    //Monitoring (Engine Power / Diverse)
    psca2MonEP, psca2MonDiverse,
    //Configurable IO
    psca2ConfigDI, psca2ConfigDO,
    //Others
    psca2GasMeter,
    psca2Final);
                              //   1        2           3          4           5           6            7          8         9
  TAlarmKind4AVAT2 = (akaNull, akaEvent, akaMessage, akaAlarm, akaAlarmLL, akaAlarmLR, akaAlarmGT, akaAlarmPT, akaFailure, akaSB, akaESD, akaSFT, akaFinal);
  TAlarmLimit4AVAT2 = (alaNull, alaLower, alaUpper, alaTrue, alaFalse, alaSensorFail, alaDeviation, alaFinal);
  TPanelKind4AVAT2 = (pkaNull, pkaMCP, pkaACP, pkaLOP, pkaICM, pkaCMM, pkaFinal);
  TTBKind4AVAT2 = (tbkaNull, tbkaX04, tbkaX04_07, tbkaX05, tbkaX12_01, tbkaX20, tbkaX23, tbkaX24, tbkaX25, tbkaX30, tbkaX31, tbkaFinal);

  TE2S_Navigation4AVAT2 = (e2snNull, e2snOperation, e2snSafetyUnit, e2snAlarms,
    e2snLog, e2snMeasurands, e2snTestMode, e2snTrend, e2snSetup, e2snTuning,
    e2snSensorForceMode, e2snSimulation, e2snSystemInformation, e2snParameterDocumentation,
    e2snModbusBitForceTest, e2snMonitoringOverview, e2snSnapShotInfo, e2snSnapShots,
    e2snFinal);

  TE2S_Measurands4AVAT2 = (e2smNull, e2smControl, e2smTemperatures, e2smStartBlocks,
    e2smAnti_KnockGovernor, e2smGasRail, e2smCylinderPressureData, e2smCylinderRadar,
    e2smCombustion, e2smBalancing_Statistics, e2smEGT_KnockBalancing, e2smOMD,
    e2smIOInterfaces, e2smIOInterfaces_IVCS_MSB_AMS, e2smElectronicInjectionDevice,
    e2smFinal);

  TE2S_TestMode4AVAT2 = (e2stmNull, e2stmStarter_GRU, e2stmACPFrontDoor, e2stmMSB_PMS,
    e2stmIVCS_MotorStarters, e2stmElectronicInjectionDevice, e2stmActuators1, e2stmActuators2,
    e2stmFinal);

  TE2S_Tuning4AVAT2 = (e2stuNull, e2stuSpeed_Power, e2stuAFRControl, e2stuGRU,
    e2stuHT_LTCooling, e2stuFuelModeChangeOver,
    e2stuFinal);

  TE2S_SystemInfo4AVAT2 = (e2ssiNull, e2ssiVersion, e2ssiTimeSet, e2ssiCANDiag,
    e2ssiFinal);

  TE2S_Snapshot4AVAT2 = (e2sssNull, e2sssSaveSS, e2sssCompareSS,
    e2sssFinal);

const
  R_DFCommissioningItem : array[Low(TDFCommissioningItem)..High(TDFCommissioningItem)] of string =
         ('',
         'Slow Turning',
         'Cyclic Slow Turning',
         'Engine Starting',
         'Micro Pilot Build-up',
         'Micro Pilot Test',
         'Diesel Mode Control (Load vs. Fuel actuator position)',
         'DVT control',
         'LT 3-Way Valve Control',
         'Governing Test (3 Step, Load Rejection)',
         'Gas Mode Control',
         'Gas Regulator Control',
         'Changeover Gas to Diesel',
         'Changeover Diesel to Gas',
         'Air/Fuel Ratio Control',
         'Cylinder Balancing',
         'Knock Governing (Gas Duration, MP Timing)',
         'Governing Test (5 Step, Load Rejection)',
         '');

  R_ParameterCategory4AVAT2 : array[Low(TParameterCategory4AVAT2)..High(TParameterCategory4AVAT2)] of string =
         ('',
         'Engine and System',
         'Start and Stop Sequence',
         'Speed Control',
         'Power Control',
         'AFR Control',
         'Main Fuel Injection Control (Diesel + Gas)',
         'Pilot Fuel Injection Control',
         'Pilot Fuel Pressure Control',
         'Fuel Mode Changeover',
         'Gas Pressure Control',
         'HT/LT Cooling',
         'Cylinder Balancing',
         'Knock Control And Cylinder Pressure',
         'Monitoring (Fuel Oil / Start Air)',
         'Monitoring (Lube Oil / Bearings / Liners / Crankcase)',
         'Monitoring (Exhaust / Charge Air)',
         'Monitoring (Cooling Water)',
         'Monitoring (Gas System)',
         'Monitoring (Engine Power / Diverse)',
         'Configurable IO',
         'Others',
         ''
         );

  R_ParameterSubCategory4AVAT2 : array[Low(TParameterSubCategory4AVAT2)..High(TParameterSubCategory4AVAT2)] of string =
         ('',
    //Engine and System
         'Engine Setup',
         'TC Pickup Configuration',
         'System Mode',
         'Test Parameters (Internal)',
         'Options',
         'DVT',
    //Start and Stop Sequence
         'Start Preparation and options',
         'Limit Values for Start Blocks',
         'Prelubrication Pump and Pressure',
         'Speed Limit and Set Values',
         'Warm Up Phase',
         'Diesel Actuator (Fuel Rack) Start Position',
         'Stop Sequence',
         'Slow Turning',
         'Configurable Speed Limits To PMS',
    //Speed Control
         'General',
         'Speed Control (Diesel Operation)',
         'Speed Control (Gas Operation)',
         'Speed Control in Rated/Sync (Diesel Operation)',
         'Speed Control in Rated/Sync (Gas Operation)',
         'Load Rejection Support',
         'Load Step Support',
         'Emergency Transition Function',
    //Power Control
         'Backup Power Signal',
         'Power Signal',
         'Power Demand and Set Value',
         'Load Limitation and Load Reduction',
         'Power Controller (Diesel Operation)',
         'Power Controller (Gas Operation)',
         'Limits and Monitoring',
    //AFR Control
         'General',
         'AFR Controller',
         'Charge Air Set Value',
         'DVT Switchover To Miller Timing',
         'Jet Air System',
         'Air By-Pass Valve',
    //Main Fuel Injection Control (Diesel + Gas)
         'Main Diesel Fuel Injection',
         'Gas Adminssion',
         'Gas Adminission Duration Offsets A-Bank',
         'Gas Adminission Duration Offsets B-Bank',
         'Methan Slip Solution (MSS)',
         'Multi-Pulse Injection (MPI)',
         'Cylinder Cut-Off (CCO)',
    //Pilot Fuel Injection Control
         'Pilot Fuel Injection Test (General)',
         'Pilot Fuel Injection Test (Speed Control)',
         'Timing and Duration Rate Limitations',
         'Cylinder Individual Duration Offsets',
         'Cylinder Individual Timing Offsets',
         'Timing and Duration Set Values',
    //Pilot Fuel Pressure Control
         'Pilot Fuel Set Values',
         'Control Activation, etc.',
         'Pilot Fuel Pressure Controller',
         'Monitoring',
    //Fuel Mode Changeover
         'General',
         'Diesel To Gas ChangeOver (Step1: Diesel Governing, Activation of Gas Pressure Control)',
         'Diesel To Gas ChangeOver (Step2: Diesel Governing, Gas Ramp Up)',
         'Diesel To Gas ChangeOver (Step3: Gas Governing, Diesel Ramp Down)',
         'Gas To Diesel ChangeOver',
         'Fuel Sharing Operation',
    //Gas Pressure Control
         'Gas Pressure Control Main Chamber',
         'Gas Leakage Test(GLT) Main Chamber',
         'Gas Valves Stop Sequence',
         'Monitoring',
    //HT/LT Cooling
         'LT Cooling Temperature Control',
         'LT CW Standby Pump',
         'HT Cooling Temperature Control',
    //Cylinder Balancing
         'Gas DOI Balancing General',
         'Gas DOI Balancing Controller',
         'Pilot Fuel Balancing General',
         'Pilot Fuel Balancing Controller',
    //Knock Control And Cylinder Pressure
         'Knock Control',
         'Selected Sources',
         'High Pmax Detection',
         'Pmax Averaging (only apply to averaging process values',
         'Deviation From Pmax Detection', //2022-05-02 Ãß°¡µÊ
         'MisFire Detection',
         'IMEP Monitoring',
         'Cylinder Vibration High Monitoring',//2022-05-02 Ãß°¡µÊ
    //Monitoring (Fuel Oil / Start Air)
         'General',
         'PT52 Main Fuel Oil Pressure Engine Inlet',
         'PT51-PT52 Main Fuel Oil Diff Pressure',
         'TE52 Main Fuel Oil Temperature Engine Inlet',
         'PT57 Nozzle Cooling Oil Pressure Engine In',
         'TE58 Nozzle Cooling Oil Temp. Engine Out',
         'PT31 Pilot Fuel Oil Pressure Engine Inlet',
         'PT30-PT31 Pilot FO Filter Differential Pressure',
         'TE31 Pilot Fuel Oil Temperature Engine Inlet',
         'PT32 Pilot Fuel Pressure HP Pump Outlet',
         'CV321 Pilot Fuel Oil Pressure Control Valve',
         'PT35 Pilot Fuel Pressure Engine Outlet',
         'Fuel Oil Tank Limit Switches',
         'PT40 Starting Air Pressure Engine Inlet',
         'PT41 Control Air Pressure',
    //Monitoring (Lube Oil / Bearings / Liners / Crankcase)
         'PT62 Lube Oil Pressure Engine Inlet',
         'PT61-PT62 LO Filter Diff Pressure',
         'TE62 Lube Oil Temperature Engine Inlet',
         'PT63 Lube Oil Pressure TC Inlet',
         'TE64 Lube Oil TC Outlet',
         'PT66 Lube Oil Pressure Pilot FO HP Pump Inlet',
         'Lube Oil Tank Level Limit Switches',
         'TE05x Bearing Tempreatures',
         'TE06x Con-Rod Bearing Tempreatures',
         'TE07x Cylinder Liner Tempreatures',
         'PT03 CrankCase Pressure',
         'Oil Mist Detector',
    //Monitoring (Exhaust / Charge Air)
         'TE25-xx Exhaust Gas Temperatures',
         'TE26-x Exhaust Gas Temperatures TC',
         'TE29 Air Temperature TC Inlet',
         'PT21 Charge Pressure Engine Inlet',
         'TE21 Charge Air Temperature Engine Inlet',
         'CV26-ZT26 Wasgegate Position Deviation From Reference',
    //Monitoring (Cooling Water)
         'PT75 HT CW Pressure Jacket Inlet',
         'TE75 HT CW Temperature Jacket Inlet',
         'TE761/TE762 HT CW Temperature Jacket Outlet',
         'PT71 LT CW Pressure Air Cooler Inlet',
         'TE71 LT CW Temperature Air Cooler Inlet',
         'CV76-ZT76 HT CW Control Valve Deviation From Reference',
         'CV76-ZT76 LT CW Control Valve Deviation From Reference',
    //Monitoring (Gas System)
         'GAC Duration Limitation',
         'PT87 Gas Pressure Engine Inlet',
         'PT81 Gas Supply Pressure Filter Inlet',
         'PT8081 Gas Supply Filter Differential Pressure',
         'TE82 Gas Temperature',
         'PT82 Gas Pressure Regurator Outlet Deviation From Reference Main Chamber',
         'PT83 GRU Control Air Pressure',
         'PT89 Inert Gas Pressure',
         'PT99 GRU Enclosure Pressure', //2022-05-02 Ãß°¡µÊ
    //Monitoring (Engine Power / Diverse)
         'Engine Power',
         'Diverse',
    //Configurable IO
         'Digital Input',
         'Digital Output',
    //Others
         'Gas Metering',
         ''
         );

  R_AlarmKind4AVAT2 : array[Low(TAlarmKind4AVAT2)..High(TAlarmKind4AVAT2)] of string =
         ('',
         'Event',
         'Message',
         'Alarm',
         'Alarm (LL)',
         'Alarm (LR)',
         'Alarm (GT)',
         'Alarm (PT)',
         'Failure',
         'Start Block',
         'ShutDown',
         'Alarm (SFT)',
         '');

  R_AlarmKind4AVAT2Code : array[Low(TAlarmKind4AVAT2)..High(TAlarmKind4AVAT2)] of string =
         ('',
         'EVT',
         'MSG',
         'AL',
         'LL',
         'LR',
         'GT',
         'PT',
         'FA',
         'SB',
         'SD',
         'SFT',
         '');

  R_AlarmLimit4AVAT2 : array[Low(TAlarmLimit4AVAT2)..High(TAlarmLimit4AVAT2)] of string =
         ('',
         'Lower limit',
         'Upper limit',
         'TRUE',
         'FALSE',
         'Sensor failure',
         'deviation detected',
         '');

  R_PanelKind4AVAT2 : array[Low(TPanelKind4AVAT2)..High(TPanelKind4AVAT2)] of string =
         ('',
         'MCP',
         'ACP',
         'LOP',
         'ICM',
         'CMM',
         '');

  R_TBKind4AVAT2 : array[Low(TTBKind4AVAT2)..High(TTBKind4AVAT2)] of string =
         ('',
         'X04',
         'X04_07',
         'X05',
         'X12_01',
         'X20',
         'X23',
         'X24',
         'X25',
         'X30',
         'X31',
         '');

  R_Navigation4AVAT2 : array[Low(TE2S_Navigation4AVAT2)..High(TE2S_Navigation4AVAT2)] of string =
         ('', 'Operation', 'Safety Unit', 'Alarms', 'Log', 'Measurands',
          'Test Mode', 'Trend', 'Setup', 'Tuning', 'Sensor Force Mode',
          'Simulation', 'System Information', 'Parameter Documentation',
          'Modbus Bit Force Test', 'Monitoring Overview', 'SnapShot Info',
          'SnapShots',
         '');

  R_Measurands4AVAT2 : array[Low(TE2S_Measurands4AVAT2)..High(TE2S_Measurands4AVAT2)] of string =
         ('', 'Control', 'Temperatures', 'Start Blocks', 'Anti-Knock Governor', 'Gas Rail',
          'Cylinder Pressure Data', 'Cylinder Radar', 'Combustion', 'Balancing + Statistics',
          'EGT (scatter band) and Knock Balancing',
          'Oil Mist Detection', 'IO Interfaces', 'IO Interfaces (IVCS/MSB/AMS)',
          'Electronic Injection Device (EID)',
         '');

  R_TestMode4AVAT2 : array[Low(TE2S_TestMode4AVAT2)..High(TE2S_TestMode4AVAT2)] of string =
         ('', 'Starter and GRU', 'ACP Front door', 'Main switch board and PMS',
          'IVCS and motor starters', 'Electronic Injection Device',
          'Actuators 1', 'Actuators 2',
         '');

  R_Tuning4AVAT2 : array[Low(TE2S_Tuning4AVAT2)..High(TE2S_Tuning4AVAT2)] of string =
         ('', 'Speed+Power', 'AFRControl', 'Gas Regulating Unit', 'HT / LT Cooling',
         'Fuel Mode Changeover',
         '');

  R_SystemInfo4AVAT2 : array[Low(TE2S_SystemInfo4AVAT2)..High(TE2S_SystemInfo4AVAT2)] of string =
         ('', 'Version Overview', 'Time Settings', 'CAN diagnostic',
         '');

  R_Snapshot4AVAT2 : array[Low(TE2S_Snapshot4AVAT2)..High(TE2S_Snapshot4AVAT2)] of string =
         ('', 'Save snapshot', 'Compare snapshot',
         '');

var
  g_DFCommissioningItem: TLabelledEnum<TDFCommissioningItem>;
  g_ParameterCategory4AVAT2: TLabelledEnum<TParameterCategory4AVAT2>;
  g_ParameterSubCategory4AVAT2: TLabelledEnum<TParameterSubCategory4AVAT2>;
  g_AlarmKind4AVAT2: TLabelledEnum<TAlarmKind4AVAT2>;
  g_AlarmKind4AVAT2Code: TLabelledEnum<TAlarmKind4AVAT2>;
  g_AlarmLimit4AVAT2: TLabelledEnum<TAlarmLimit4AVAT2>;
  g_PanelKind4AVAT2: TLabelledEnum<TPanelKind4AVAT2>;
  g_TBKind4AVAT2: TLabelledEnum<TTBKind4AVAT2>;
  g_Navigation4AVAT2: TLabelledEnum<TE2S_Navigation4AVAT2>;
  g_Measurands4AVAT2: TLabelledEnum<TE2S_Measurands4AVAT2>;
  g_TestMode4AVAT2: TLabelledEnum<TE2S_TestMode4AVAT2>;
  g_Tuning4AVAT2: TLabelledEnum<TE2S_Tuning4AVAT2>;
  g_SystemInfo4AVAT2: TLabelledEnum<TE2S_SystemInfo4AVAT2>;
  g_Snapshot4AVAT2: TLabelledEnum<TE2S_Snapshot4AVAT2>;

implementation

initialization
//  g_DFCommissioningItem.InitArrayRecord(R_DFCommissioningItem);
//  g_ParameterCategory4AVAT2.InitArrayRecord(R_ParameterCategory4AVAT2);
//  g_ParameterSubCategory4AVAT2.InitArrayRecord(R_ParameterSubCategory4AVAT2);
//  g_AlarmKind4AVAT2.InitArrayRecord(R_AlarmKind4AVAT2);
//  g_AlarmKind4AVAT2Code.InitArrayRecord(R_AlarmKind4AVAT2Code);
//  g_AlarmLimit4AVAT2.InitArrayRecord(R_AlarmLimit4AVAT2);
//  g_PanelKind4AVAT2.InitArrayRecord(R_PanelKind4AVAT2);
//  g_TBKind4AVAT2.InitArrayRecord(R_TBKind4AVAT2);
//  g_Navigation4AVAT2.InitArrayRecord(R_Navigation4AVAT2);
//  g_Measurands4AVAT2.InitArrayRecord(R_Measurands4AVAT2);
//  g_TestMode4AVAT2.InitArrayRecord(R_TestMode4AVAT2);
//  g_Tuning4AVAT2.InitArrayRecord(R_Tuning4AVAT2);
//  g_SystemInfo4AVAT2.InitArrayRecord(R_SystemInfo4AVAT2);
//  g_Snapshot4AVAT2.InitArrayRecord(R_Snapshot4AVAT2);

end.
