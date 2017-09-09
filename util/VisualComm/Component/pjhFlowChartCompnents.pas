unit pjhFlowChartCompnents;

interface

uses Windows, Messages, SysUtils, Classes, Controls, StdCtrls, Menus,
    FlowChartLogic, pjhStartButton;

  function GetPaletteList: TStringList;

implementation

function GetPaletteList: TStringList;
var
  LStr: string;
begin
  Result := TStringList.Create;
  LStr := 'FlowChart=';
  LStr := LStr + 'TpjhStartButton;';
  LStr := LStr + 'TpjhIfControl;TpjhGotoControl;TpjhStartControl;TpjhStopControl;';
  LStr := LStr + 'TpjhDelay;TpjhSetTimer;TpjhIFTimer;';
  Result.Add(LStr);
end;

exports
  GetPaletteList;

initialization
//bpl을 동적으로 로딩시 RegisterClass해도 GetClass시에 nil이 return 되는 문제 발생
//해결: exe와 bpl project option에서 vcl.dcp와 rtl.dcp를 포함해줌(release version)
  RegisterClasses([TpjhIfControl,TpjhGotoControl,TpjhStartControl,TpjhStopControl,TpjhDelay,TpjhSetTimer,TpjhIFTimer]);
  RegisterClasses([TpjhStartButton]);

finalization
  UnRegisterClasses([TpjhStartButton]);
  UnRegisterClasses([TpjhIfControl,TpjhGotoControl,TpjhStartControl,TpjhStopControl,TpjhDelay,TpjhSetTimer,TpjhIFTimer]);

end.
