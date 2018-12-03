unit UnitFGSSConst;

interface

uses System.Classes, UnitEnumHelper;

type
  TFGSSSystem = (fsNull, fsLNGVaporizer, fsGWHeater, fsBOGHeater, fsFinal);
  TFGSSWiringDiagramContents = (fwdcNull, fwdcOverView, fwdcPower, fwdc, fwdcFinal);

const
  R_FGSSSystem : array[Low(TFGSSSystem)..High(TFGSSSystem)] of string =
    ('', 'OverView', 'Power', 'BOG Heater', '');
var
  g_FGSSSystem: TLabelledEnum<TFGSSSystem>;

implementation

initialization
  g_FGSSSystem.InitArrayRecord(R_FGSSSystem);

end.
