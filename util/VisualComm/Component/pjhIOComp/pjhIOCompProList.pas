unit pjhIOCompProList;

interface

uses Windows, Messages, SysUtils, Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.Menus,
    pjhIOCompProConst, pjhiAngularLogGauge, pjhiCompass, pjhiDualCompass,
    pjhiLCDMatrix, pjhiLedArrow, pjhiLedDiamond, pjhiLogGauge, pjhiMotor,
    pjhiPanel, pjhiPipe, pjhiPipeJoint, pjhiRotationDisplay, pjhiSlidingScale,
    pjhiSwitchLever, pjhiSwitchRocker, pjhiTank, pjhiValve;

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
  LStr := 'IOCompPro=';
  LStr := LStr + 'TpjhiAngularLogGauge;TpjhiCompass;';
  LStr := LStr + 'TpjhiDualCompass;TpjhiLCDMatrix;';
  LStr := LStr + 'TpjhiLedArrow;TpjhiLedDiamond;';
  LStr := LStr + 'TpjhiLogGauge;TpjhiMotor;';
  LStr := LStr + 'TpjhiPanel;TpjhiPipe;';
  LStr := LStr + 'TpjhiPipeJoint;TpjhiRotationDisplay;';
  LStr := LStr + 'TpjhiSlidingScale;TpjhiSwitchLever;';
  LStr := LStr + 'TpjhiSwitchRocker;TpjhiTank;';
  LStr := LStr + 'TpjhiValve';
  //LStr := LStr + 'TpjhIfControl;TpjhGotoControl;TpjhStartControl;TpjhStopControl;';
  Result.Add(LStr);
end;

function GetBplFileName: string;
begin
  Result := pjhIOCompProBplFileName;
end;

exports
  GetPaletteList,
  GetBplFileName;

initialization
//bpl을 동적으로 로딩시 RegisterClass해도 GetClass시에 nil이 return 되는 문제 발생
//해결: exe와 bpl project option에서 vcl.dcp와 rtl.dcp를 포함해줌(release version)
  //RegisterClasses([TpjhIfControl,TpjhGotoControl,TpjhStartControl,TpjhStopControl,TpjhDelay,TpjhSetTimer,TpjhIFTimer]);
  RegisterClasses([TpjhiAngularLogGauge,TpjhiCompass]);
  RegisterClasses([TpjhiDualCompass,TpjhiLCDMatrix]);
  RegisterClasses([TpjhiLedArrow,TpjhiLedDiamond]);
  RegisterClasses([TpjhiLogGauge,TpjhiMotor]);
  RegisterClasses([TpjhiPanel,TpjhiPipe]);
  RegisterClasses([TpjhiPipeJoint,TpjhiRotationDisplay]);
  RegisterClasses([TpjhiSlidingScale,TpjhiSwitchLever]);
  RegisterClasses([TpjhiSwitchRocker,TpjhiTank]);
  RegisterClasses([TpjhiValve]);

finalization
  //UnRegisterClasses([TpjhIfControl,TpjhGotoControl,TpjhStartControl,TpjhStopControl,TpjhDelay,TpjhSetTimer,TpjhIFTimer]);
  UnRegisterClasses([TpjhiAngularLogGauge,TpjhiCompass]);
  UnRegisterClasses([TpjhiDualCompass,TpjhiLCDMatrix]);
  UnRegisterClasses([TpjhiLedArrow,TpjhiLedDiamond]);
  UnRegisterClasses([TpjhiLogGauge,TpjhiMotor]);
  UnRegisterClasses([TpjhiPanel,TpjhiPipe]);
  UnRegisterClasses([TpjhiPipeJoint,TpjhiRotationDisplay]);
  UnRegisterClasses([TpjhiSlidingScale,TpjhiSwitchLever]);
  UnRegisterClasses([TpjhiSwitchRocker,TpjhiTank]);
  UnRegisterClasses([TpjhiValve]);

end.
