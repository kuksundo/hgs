unit UnitCommDisconnected.Events;

interface

uses
  System.Classes,
  LKSL.Common.Types,
  LKSL.Events.Main;

type
  TCommDisconnectedEvent = class(TLKEvent)
  private
    FItemIndex: integer;
  public
    constructor Create(const AItemIndex: integer); reintroduce;
    property ItemIndex: integer read FItemIndex;
  end;

  TCommDisconnectedEventListener = class(TLKEventListener<TCommDisconnectedEvent>);

implementation

{ TTestEvent }

constructor TCommDisconnectedEvent.Create(const AItemIndex: integer);
begin
  inherited Create;

  FItemIndex := AItemIndex;
end;

end.
