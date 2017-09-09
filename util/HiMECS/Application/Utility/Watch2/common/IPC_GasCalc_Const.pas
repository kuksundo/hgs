unit IPC_GasCalc_Const;

interface

type
  TEventData_GasCalc = packed record
    FSVP: double;// Saturation Vapour Press.(kPa)
    FIAH2: double;// Intake Air Humidity(g/kg)
    FUFC: double;// Uncorrected Fuel Consumption(g/kwh)
    FNhtCF: double;  //Nox humidity/temp. Correction Factor
    FDWCFE: double;//Dry/Wet Correction Factor Exhaust:
    FEGF: double; //Exhaust Gas Flow(kg/h)
    FNOxAtO213: double;//NOx at 13% O2
    FNOx: double;//NOx(ppm)
    FAF1: double; //Air Flow (kg/h)
    FAF2: double; //Air Flow (kg/kwh)
    FAF3: double; //Air Flow (kg/s)
    FAF_Measured: double; //Measured Air Flow (kg/h):MT210
    FMT210: double; //Measured Diff. Press(mmH2O=mmAq=mm):MT210
    FFC: double;//Fuel Consumption(kg/h)
    FEngineOutput: Double; //Calculated(kW/h)
    FGeneratorOutput: Double; //Calculated(kW/h)
    FEngineLoad: double; //Current Engine Load(%)
    FGenEfficiency: double; //Generator Efficiency at current Load(%/100)
    FBHP: double; //Brake Horse Power
    FBMEP: double;//Brake Mean Effective Press.
    FLamda_Calculated: double; //Lamda Ratio by MEXA7000
    FLamda_Measured: double; //Lamda Ratio by MT210
    FLamda_Brettschneider: double; //Lamda(Brettschneider equation) - Normalized Air/Fuel balance
    FAFRatio_Calculated: double;//Air Fuel Ratio calculated by MEXA7000
    FAFRatio_Measured: double;//Air Fuel Ratio Measured by MT210
    FExhTempAvg: double;//Average of Exh. Temp.
    FWasteGatePosition: double;//Waste Gate Position
    FThrottlePosition: double;//Throttle Valve Position
    FBoostPress: double;//Boost Pressure
    FDensity: double;//Density (kg/m3)
    FLCV: double;//Low Caloric Value (kJ/kg)
    PowerOn: Boolean;
  end;

const
  GASCALC_EVENT_NAME = 'MONITOR_EVENT_GasCalc';

implementation

end.
