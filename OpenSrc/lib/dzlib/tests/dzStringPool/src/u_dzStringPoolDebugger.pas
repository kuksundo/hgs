unit u_dzStringPoolDebugger;

interface

uses
  Classes,
  u_dzStringPool;

type
  TDebugStringPool = class(TStringPool)
  public
    property List: TStringList read FList;
  end;

implementation

end.
