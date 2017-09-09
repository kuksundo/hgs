/// some common definitions shared by both client and server side
unit UnitPMSOPCInterface;

interface

uses SynCommons, UnitTagCollect;

type
  IPMSOPC = interface(IInvokable)
    ['{9A60C8ED-CEB2-4E09-87D4-4A16F496E5FE}']
    function GetTagNames: TRawUTF8DynArray;
    procedure GetTagnames2(out ATagNames: TTagCollect);
    function GetTagValues: TRawUTF8DynArray;
  end;

const
  ROOT_NAME = 'root';
  PORT_NAME = '888';
  APPLICATION_NAME = 'RestService';
  PPP_PMS_TOPIC = '/topic/EngDiv_PPP_PMS';
  PPP_PMS_TAG_TOPIC = '/topic/EngDiv_PPP_PMS_TAG';
  PPP_PMS_VALUE_TOPIC = '/topic/EngDiv_PPP_PMS_VALUE';

implementation

end.
