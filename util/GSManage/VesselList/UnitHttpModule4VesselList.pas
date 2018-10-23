unit UnitHttpModule4VesselList;

interface

uses System.SysUtils, System.Classes, UnitInterfaceHTTPManager, UnitCommonWSInterface,
  mORMot, SynCommons, UnitHttpModule;

function MakeCommand4VesselListServer(ACommand, AParam: RawUTF8): RawUTF8;
function SendReq2VesselList_Http(AIpAddress, APort, ARoot: string; ACommand, AParam: RawUTF8): RawUTF8;

implementation

end.
