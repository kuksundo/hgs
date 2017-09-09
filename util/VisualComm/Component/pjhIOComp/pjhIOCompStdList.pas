unit pjhIOCompStdList;

interface

uses Windows, Messages, SysUtils, Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.Menus,
    pjhIOCompStdConst, pjhiAnalogDisplay, pjhiAnalogOutPut, pjhiAngularGauge,
    pjhiEdit, pjhiGradient, pjhiIntegerOutput, pjhiKnob, pjhiLabel, pjhiLedBar,
    pjhiLedRectangle, pjhiLedRound, pjhiLedSpiral, pjhiLinearGauge, pjhiOdometer,
    pjhiSevenSegmentAnalog, pjhiSevenSegmentBinary, pjhiSevenSegmentHexaDecimal,
    pjhiSevenSegmentInteger, pjhiSlider, pjhiSwitchLed, pjhiSwitchPanel,
    pjhiSwitchRotary, pjhiSwitchSlider, pjhiSwitchToggle, pjhiThermoMeter;

  function GetPaletteList: TStringList;
  function GetBplFileName: string;
  //procedure Register;

implementation
{
procedure Register;
begin
    RegisterComponents ('pjhComp', [TpjhiAngularGuage]);
end;
}
function GetPaletteList: TStringList;
var
  LStr: string;
begin
  Result := TStringList.Create;
  LStr := 'IOCompStd=';
  LStr := LStr + 'TpjhiAnalogOutPut;TpjhiAnalogDisplay;';
  LStr := LStr + 'TpjhiAngularGauge;TpjhiEdit;';
  LStr := LStr + 'TpjhiGradient;TpjhiIntegerOutput;';
  LStr := LStr + 'TpjhiKnob;TpjhiLabel;';
  LStr := LStr + 'TpjhiLedBar;TpjhiLedRectangle;';
  LStr := LStr + 'TpjhiLedRound;TpjhiLedSpiral;';
  LStr := LStr + 'TpjhiLinearGauge;TpjhiOdometer;';
  LStr := LStr + 'TpjhiSlider;TpjhiSwitchLed;';
  LStr := LStr + 'TpjhiSwitchPanel;TpjhiSwitchRotary;';
  LStr := LStr + 'TpjhiSwitchSlider;TpjhiSwitchToggle;';
  LStr := LStr + 'TpjhiThermoMeter;';
  //LStr := LStr + 'TpjhIfControl;TpjhGotoControl;TpjhStartControl;TpjhStopControl;';
  Result.Add(LStr);
end;

function GetBplFileName: string;
begin
  Result := pjhIOCompStdBplFileName;
end;

exports
  GetPaletteList,
  GetBplFileName;

initialization
//bpl을 동적으로 로딩시 RegisterClass해도 GetClass시에 nil이 return 되는 문제 발생
//해결: exe와 bpl project option에서 vcl.dcp와 rtl.dcp를 포함해줌(release version)
  //RegisterClasses([TpjhIfControl,TpjhGotoControl,TpjhStartControl,TpjhStopControl,TpjhDelay,TpjhSetTimer,TpjhIFTimer]);
  RegisterClasses([TpjhiAnalogOutPut,TpjhiAnalogDisplay]);
  RegisterClasses([TpjhiAngularGauge,TpjhiEdit]);
  RegisterClasses([TpjhiGradient,TpjhiIntegerOutput]);
  RegisterClasses([TpjhiKnob,TpjhiLabel]);
  RegisterClasses([TpjhiLedBar,TpjhiLedRectangle]);
  RegisterClasses([TpjhiLedRound,TpjhiLedSpiral]);
  RegisterClasses([TpjhiLinearGauge,TpjhiOdometer]);
  RegisterClasses([TpjhiSevenSegmentInteger,TpjhiSevenSegmentHexaDecimal]);
  RegisterClasses([TpjhiSevenSegmentBinary,TpjhiSevenSegmentAnalog]);
  RegisterClasses([TpjhiSlider,TpjhiSwitchLed]);
  RegisterClasses([TpjhiSwitchPanel,TpjhiSwitchRotary]);
  RegisterClasses([TpjhiSwitchSlider,TpjhiSwitchToggle]);
  RegisterClasses([TpjhiThermoMeter]);

finalization
  //UnRegisterClasses([TpjhIfControl,TpjhGotoControl,TpjhStartControl,TpjhStopControl,TpjhDelay,TpjhSetTimer,TpjhIFTimer]);
  UnRegisterClasses([TpjhiAnalogOutPut,TpjhiAnalogDisplay]);
  UnRegisterClasses([TpjhiAngularGauge,TpjhiEdit]);
  UnRegisterClasses([TpjhiGradient,TpjhiIntegerOutput]);
  UnRegisterClasses([TpjhiKnob,TpjhiLabel]);
  UnRegisterClasses([TpjhiLedBar,TpjhiLedRectangle]);
  UnRegisterClasses([TpjhiLedRound,TpjhiLedSpiral]);
  UnRegisterClasses([TpjhiLinearGauge,TpjhiOdometer]);
  UnRegisterClasses([TpjhiSevenSegmentInteger,TpjhiSevenSegmentHexaDecimal]);
  UnRegisterClasses([TpjhiSevenSegmentBinary,TpjhiSevenSegmentAnalog]);
  UnRegisterClasses([TpjhiSlider,TpjhiSwitchLed]);
  UnRegisterClasses([TpjhiSwitchPanel,TpjhiSwitchRotary]);
  UnRegisterClasses([TpjhiSwitchSlider,TpjhiSwitchToggle]);
  UnRegisterClasses([TpjhiThermoMeter]);

end.
