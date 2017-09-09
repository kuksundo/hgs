unit UnitMQTTMsg.Events;

interface

uses
  System.Classes,
  LKSL.Common.Types,
  LKSL.Events.Main;

type
  TMQTTMsgEvent = class(TLKEvent)
  private
    FCommand,
    FDispNo: integer;
    FTopic: string;
    FMessage: string;
  public
    //AFileName <> '' 이면 파일에 Str 저장함
    constructor Create(const ATopic, AMessage: String; const ADispNo: integer = 0; const ACommand: integer = -1); reintroduce;
    property Topic: String read FTopic;
    property FFMessage: string read FMessage;
    property Command: integer read FCommand;
    property DispNo: integer read FDispNo;
  end;

  TMQTTMsgEventListener = class(TLKEventListener<TMQTTMsgEvent>);

implementation

{ TTestEvent }

constructor TMQTTMsgEvent.Create(const ATopic, AMessage: String; const ADispNo, ACommand : integer);
begin
  inherited Create;

  FTopic := ATopic;
  FMessage := AMessage;
  FCommand := ACommand;
  FDispNo := ADispNo;
end;

end.
