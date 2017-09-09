/// some common definitions shared by both client and server side
unit UnitEngParamInterface;

interface

uses SynCommons, EngineParameterClass;

type
  IEngParameter = interface(IInvokable)
    ['{DB47F7C8-50E9-4E8D-8757-6B7059AF1197}']
    function GetTagNames: TRawUTF8DynArray;
    procedure GetEngParam(out AEPCollect: TEngineParameterCollect);
    function GetTagValues: TRawUTF8DynArray;
  end;

const
  ROOT_NAME = 'root';
  PORT_NAME = '889';
  APPLICATION_NAME = 'EngParam_RestService';

implementation

end.
