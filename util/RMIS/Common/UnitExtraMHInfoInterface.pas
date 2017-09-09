unit UnitExtraMHInfoInterface;

interface

uses SynCommons;

type
  IExtraMHInfo = interface(IInvokable)
    ['{C60A9108-CDDC-484C-A374-25BF3ED8EE68}']
    function GetExtraMHInfo(AFrom, ATo: string): RawUTF8;
    function GetEngDiv_kWh(ADate: string): RawUTF8;
    procedure GetCrankShaftCraneInfo(X,Y,W: string);
  end;
implementation

end.
