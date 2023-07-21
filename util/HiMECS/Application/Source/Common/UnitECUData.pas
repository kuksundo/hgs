unit UnitECUData;

interface

uses System.Classes, UnitEnumHelper, UnitRttiUtil;

type
  TEngElecPartType = (eeptNull, eeptSensor, eeptValve, eeptConverter, eeptPump,
    eeptMotor, eeptHeater, eeptPanel, eeptUnit, eeptTerminal, eeptEthHub, eeptFinal);
  TEngInstrumentType = (itNull, itPickup, itLimitSwitch, itLevelSwitch, itPressureTransmitter,
    itTemperature, itVibration, itPneumaticActuator, itHydraulicActuator,
    itElectricActuator, itSolenoidValve, itThrottleValve, itIPConverter,
    itFlowMeter, itMotor, itHeater, itPump, itPanel, itUnit, itFinal);

const
  R_EngElecPartType : array[Low(TEngElecPartType)..High(TEngElecPartType)] of string =
         ('',
         'Sensor',
         'Valve',
         'Converter',
         'Pump',
         'Motor',
         'Heater',
         'Panel',
         'Unit',
         'Terminal',
         'Ethernet Hub',
         '');

  R_EngInstrumentType : array[Low(TEngInstrumentType)..High(TEngInstrumentType)] of string =
         ('',
         'Pickup',
         'LimitSwitch',
         'LevelSwitch',
         'PressureTransmitter',
         'Temperature',
         'Vibration',
         'PneumaticActuator',
         'HydraulicActuator',
         'ElectricActuator',
         'SolenoidValve',
         'ThrottleValve',
         'IPConverter',
         'FlowMeter',
         'Motor',
         'Heater',
         'Pump',
         'Panel',
         'Unit',
         '');

var
  g_EngElecPartType: TLabelledEnum<TEngElecPartType>;
  g_EngInstrumentType: TLabelledEnum<TEngInstrumentType>;

implementation

//initialization
//  g_EngElecPartType.InitArrayRecord(R_EngElecPartType);
//  g_EngInstrumentType.InitArrayRecord(R_EngInstrumentType);

end.
