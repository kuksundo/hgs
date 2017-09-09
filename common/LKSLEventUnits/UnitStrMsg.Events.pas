unit UnitStrMsg.Events;

interface

uses
  System.Classes,
  LKSL.Common.Types,
  LKSL.Events.Main;

type
  TStrMsgEvent = class(TLKEvent)
  private
    FStrMsg: string;
    FFileName: String;
    FDispNo: integer;
  public
    //AFileName <> '' 이면 파일에 Str 저장함
    constructor Create(const AMsg: String; ADispNo: integer; AFileName: string = ''); reintroduce;
    property StrMsg: String read FStrMsg;
    property DispNo: integer read FDispNo;
    property FileName: String read FFileName;
  end;

  TStrMsgEventListener = class(TLKEventListener<TStrMsgEvent>);

implementation

{ TTestEvent }

constructor TStrMsgEvent.Create(const AMsg: String; ADispNo: integer; AFileName: string);
begin
  inherited Create;
  FStrMsg := AMsg;
  FDispNo := ADispNo;
  FFileName := AFileName;
end;

end.
