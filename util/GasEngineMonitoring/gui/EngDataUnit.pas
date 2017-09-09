unit EngDataUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, iLabel, iComponent, iVCLComponent, iCustomComponent, iAnalogDisplay;

type
  TEngDataF = class(TForm)
    GenOutput: TiAnalogDisplay;
    iLabel14: TiLabel;
    A0106: TiAnalogDisplay;
    iLabel15: TiLabel;
    iLabel1: TiLabel;
    EfficiencyEdit: TiAnalogDisplay;
    iLabel7: TiLabel;
    EngLoadAnalog: TiAnalogDisplay;
    iLabel12: TiLabel;
    A00DD: TiAnalogDisplay;
    iLabel13: TiLabel;
    Nox: TiAnalogDisplay;
    EngineOutput: TiAnalogDisplay;
    iLabel2: TiLabel;
    iLabel3: TiLabel;
    BMEP: TiAnalogDisplay;
    iLabel4: TiLabel;
    LamdaAnalog: TiAnalogDisplay;
    AirFuelRatioAnalog: TiAnalogDisplay;
    Noxato2: TiAnalogDisplay;
    iLabel6: TiLabel;
    iLabel8: TiLabel;
    MT210Analog: TiAnalogDisplay;
    iLabel9: TiLabel;
    M_AirFlowAnalog: TiAnalogDisplay;
    iLabel10: TiLabel;
    C_AirFlowAnalog: TiAnalogDisplay;
    iLabel11: TiLabel;
    iLabel16: TiLabel;
    iLabel17: TiLabel;
    M_AirFuelRatioAnalog: TiAnalogDisplay;
    iLabel18: TiLabel;
    iLabel5: TiLabel;
    iLabel19: TiLabel;
    iLabel20: TiLabel;
    M_LamdaAnalog: TiAnalogDisplay;
    iLabel21: TiLabel;
    iLabel22: TiLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EngDataF: TEngDataF;

implementation

{$R *.dfm}

end.
