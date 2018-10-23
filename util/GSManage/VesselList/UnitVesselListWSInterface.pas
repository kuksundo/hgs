unit UnitVesselListWSInterface;

interface

uses
  SysUtils,
  SynCommons,
  mORMot;

type
  IVesselListCallback = interface(IInvokable)
    ['{3353F04E-3AFA-4E23-A8C7-64FA51374270}']
    procedure ClientExecute(const command, msg: string);
  end;

  IVesselListService = interface(IServiceWithCallbackReleased)
    ['{FF0AEF1B-4389-4911-A9D7-233EEB9E0FA6}']
    procedure Join(const pseudo: string; const callback: IVesselListCallback);
    function ServerExecute(const Acommand: RawUTF8): RawUTF8;
  end;

implementation

initialization
  TInterfaceFactory.RegisterInterfaces([
    TypeInfo(IVesselListService),TypeInfo(IVesselListCallback)]);
end.
