unit pjhTMSSmoothCompList;

interface

uses Windows, Messages, SysUtils, Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.Menus,
    pjhTMSSmoothCompConst, pjhadvSmoothGauge, pjhadvSmoothLabel, pjhadvSmoothPanel,
    pjhadvSmoothTrackBar, pjhadvSmoothStatusIndicator, pjhadvSmoothProgressBar,
    pjhadvSmoothToggleButton, pjhadvSmoothLedLabel, pjhadvSmoothExpanderPanel,
    pjhadvSmoothExpanderButtonPanel, pjhadvSmoothTimeLine, pjhadvSmoothCalculator,
    pjhadvSmoothCalculatorDropDown;

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
  LStr := 'TMS Smooth =';
  LStr := LStr + 'TpjhadvSmoothGauge;TpjhAdvSmoothLabel;TpjhAdvSmoothPanel;';
  LStr := LStr + 'TpjhAdvSmoothTrackBar;TpjhAdvSmoothStatusIndicator;';
  LStr := LStr + 'TpjhAdvSmoothProgressBar;TpjhAdvSmoothToggleButton;';
  LStr := LStr + 'TpjhAdvSmoothLedLabel;TpjhAdvSmoothExpanderPanel;';
  LStr := LStr + 'TpjhAdvSmoothExpanderButtonPanel;TpjhAdvSmoothTimeLine;';
  LStr := LStr + 'TpjhAdvSmoothCalculator;TpjhAdvSmoothCalculatorDropDown;';
  Result.Add(LStr);
end;

function GetBplFileName: string;
begin
  Result := pjhTMSSmoothCompBplFileName;
end;

exports
  GetPaletteList,
  GetBplFileName;

initialization
//bpl을 동적으로 로딩시 RegisterClass해도 GetClass시에 nil이 return 되는 문제 발생
//해결: exe와 bpl project option에서 vcl.dcp와 rtl.dcp를 포함해줌(release version)
  RegisterClasses([TpjhadvSmoothGauge,TpjhAdvSmoothLabel,TpjhAdvSmoothPanel]);
  RegisterClasses([TpjhAdvSmoothTrackBar,TpjhAdvSmoothStatusIndicator]);
  RegisterClasses([TpjhAdvSmoothProgressBar,TpjhAdvSmoothToggleButton]);
  RegisterClasses([TpjhAdvSmoothLedLabel,TpjhAdvSmoothExpanderPanel]);
  RegisterClasses([TpjhAdvSmoothExpanderButtonPanel,TpjhAdvSmoothTimeLine]);
  RegisterClasses([TpjhAdvSmoothCalculator,TpjhAdvSmoothCalculatorDropDown]);

finalization
  UnRegisterClasses([TpjhadvSmoothGauge,TpjhAdvSmoothLabel,TpjhAdvSmoothPanel]);
  UnRegisterClasses([TpjhAdvSmoothTrackBar,TpjhAdvSmoothStatusIndicator]);
  UnRegisterClasses([TpjhAdvSmoothProgressBar,TpjhAdvSmoothToggleButton]);
  UnRegisterClasses([TpjhAdvSmoothLedLabel,TpjhAdvSmoothExpanderPanel]);
  UnRegisterClasses([TpjhAdvSmoothExpanderButtonPanel,TpjhAdvSmoothTimeLine]);
  UnRegisterClasses([TpjhAdvSmoothCalculator,TpjhAdvSmoothCalculatorDropDown]);

end.
