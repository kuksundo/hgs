/// some common definitions shared by both client and server side
unit UnitLampInterface;

interface

uses SynCommons;

type
  ILampService = interface(IInvokable)
    ['{628A8393-0149-4A12-88A1-EC61ECBB5096}']
    function SetLamp(ARedLamp, AYellowLamp, AGreenLamp, A_dont, ASoundType: integer): string;
    function SetRedLampRetainPrev(ARedLamp: integer): string;
    function SetYellowLampRetainPrev(AYellowLamp: integer): string;
    function SetGreenLampRetainPrev(AGreenLamp: integer): string;
    function SetSoundRetainLamp(ASoundIndex: integer): string;
  end;

implementation

end.
