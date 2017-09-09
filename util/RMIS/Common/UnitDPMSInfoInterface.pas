unit UnitDPMSInfoInterface;

interface

uses SynCommons;

type
  IDPMSInfo = interface(IInvokable)
    ['{577C8465-60DF-4180-AAE9-180C6D7C3D1E}']
    function GetDPMSInfo(AFrom, ATo: string): RawUTF8;
  end;

implementation

end.
