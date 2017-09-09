/// some common definitions shared by both client and server side
unit UnitBuzzerInterface;

interface

uses SynCommons;

type
  IBuzzerServer = interface(IInvokable)
    ['{9A60C8ED-CEB2-4E09-87D4-4A16F496E5FE}']
//    function GetTagNames: TRawUTF8DynArray;
    function SetLamp(ARedLamp, AYellowLamp, AGreenLamp, A_dont, ASoundType: integer): string;
    function SetRedLampRetainPrev(ARedLamp: integer): string;
    function SetYellowLampRetainPrev(AYellowLamp: integer): string;
    function SetGreenLampRetainPrev(AGreenLamp: integer): string;
    function SetSoundRetainLamp(ASoundIndex: integer): string;
  end;

const
  ALARM_ROOT_NAME = 'alarmroot';
  ALARM_PORT = '800';
  ALARM_APPLICATION_NAME = 'AlarmRestService';

implementation

end.
