unit ConfigConst;

interface

uses Messages;

Const
  WM_EVENT_WT1600 = WM_USER + 100;
  WM_EVENT_MEXA7000 = WM_USER + 101;
  WM_EVENT_ECS = WM_USER + 102;
  WM_EVENT_LBX = WM_USER + 103;
  WM_EVENT_MT210 = WM_USER + 104;

  NUMBEROFCYLINDER = 8;

  MEXA7000_SHARE_NAME = 'Horiba_MEXA_7000';
  MT210_SHARE_NAME = 'MT210';
  WT1600_SHARE_NAME = '192.168.0.48';
  ECS_SHARE_NAME = 'ModBusCom_Avat';
  LBX_SHARE_NAME = 'Horiba_MEXA_7000';
  GAS_TOTAL_SHARE_NAME = 'Gas_Total';

  COMP_CODE_FILENAME = 'ComponentCode.ini';
  INIFILENAME = 'MEXA7000.ini';
  MEXA7000_SECTION = 'MEXA 7000';

  ENGMONITOR_SECTION = 'Engine Monitor';
  INIFILENAME2 = '.\EngMonitor.ini';

  PiOn4 = 0.78539816339744830961566084581988; // PI / 4
  K_AirFlow = 0.49224;//Air Flow Nozzle Dia(380) Constant

  no2wet = 0; //NO2 Concentration (WET) (ppm)
  cwet = 0; //Soot in wet Exhaust (§·/§©)

  //-------------- Default Variables Exhaust Air Flow Calc -------------------

  //Standard air composition, volume basis
  n2air  = 78.09; //Standard Air Composition N2  (%, v/v)
  o2air  = 20.95; //Standard Air Composition O2  (%, v/v)
  co2air =  0.03; //Standard Air Composition CO2 (%, v/v)
  arair  =  0.93; //Standard Air Composition Ar  (%, v/v)

  //Physical constants
  awh  =  1.00794; //Atomic weight of H
  awc  = 12.011; //Atomic weight of C
  aws  = 32.060; //Atomic weight of S
  awn  = 14.007; //Atomic weight of N
  awo  = 15.999; //Atomic weight of O
  awar = 39.948; //Atomic weight of Ar

  awch4 = 16.04276;//Weight of CH4(1*awc + 4*awh)
  awc2h6 = 30.06964;//Weight of C2H6(2*awc + 6*awh)
  awc3h8 = 44.09652;//Weight of C3H8(3*awc + 8*awh)
  awc4h10 = 58.1234;//Weight of C4H10(4*awc + 10*awh)
  awc5h12 = 72.15028;//Weight of C5H12(5*awc + 12*awh)


  mvh2o = 21.100; //Molecular Volume of H2O (l/mol)
  mvco2 = 22.261; //Molecular Volume of CO2 (l/mol)
  mvco  = 22.400; //Molecular Volume of CO  (l/mol)
  mvso2 = 21.856; //Molecular Volume of SO2 (l/mol)
  mvo2  = 22.392; //Molecular Volume of O2  (l/mol)
  mvhc  = 20.906; //Molecular Volume of HC  (l/mol)
  mvno  = 22.390; //Molecular Volume of NO  (l/mol)
  mvno2 = 22.141; //Molecular Volume of NO2 (l/mol)
  mvn2  = 22.403; //Molecular Volume of N2  (l/mol)
  mvar  = 22.400; //Molecular Volume of Ar  (l/mol)
  mvair = 22.400; //Molecular Volume of AIR (l/mol)
  mvch4 = 22.400; //Molecular Volume of CH4 (l/mol)

  mwh2o = 18.015;    //Molecular Weight of H2O (g/mol)
  mwco2 = 44.010;    //Molecular Weight of CO2 (g/mol)
  mwco  = awc + awo; //Molecular Weight of CO  (g/mol)
  mwso2 = 64.059;    //Molecular Weight of SO2 (g/mol)
  mwno  = awn + awo; //Molecular Weight of NO  (g/mol)
  mwno2 = 48.006;    //Molecular Weight of NO2 (g/mol)
  mwo2  = 31.999;    //Molecular Weight of O2  (g/mol)
  mwn2  = 28.013;    //Molecular Weight of N2  (g/mol)
  mwar  = awar;      //Molecular Weight of Ar  (g/mol)
  mwair = 28.963;    //Molecular Weight of Air (g/mol)

type
  PDoublePoint = ^TDoublePoint;
  TDoublePoint = class(TObject)
    X: Double;
    Y: Double;
  end;
  
implementation

end.
