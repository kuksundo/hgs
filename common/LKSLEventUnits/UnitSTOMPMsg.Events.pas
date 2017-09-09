unit UnitSTOMPMsg.Events;

interface

uses
  System.Classes,
  LKSL.Common.Types,
  LKSL.Events.Main;

type
  TSTOMPMsgEvent = class(TLKEvent)
  private
    FCommand: integer;
    FTopic: string;
    FMessage: string;
  public
    //AFileName <> '' 이면 파일에 Str 저장함
    constructor Create(const ATopic, AMessage: String; const ACommand: integer = -1); reintroduce;
    property Topic: String read FTopic;
    property FFMessage: string read FMessage;
    property Command: integer read FCommand;
  end;

  TSTOMPMsgEventListener = class(TLKEventListener<TSTOMPMsgEvent>);

implementation

{ TTestEvent }

constructor TSTOMPMsgEvent.Create(const ATopic, AMessage: String; const ACommand: integer);
begin
  inherited Create;

  FTopic := ATopic;
  FMessage := AMessage;
  FCommand := ACommand;
end;

end.
