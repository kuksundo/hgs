unit UnitSaveData2MongoDB.Events;

interface

uses
  System.Classes,
  LKSL.Common.Types,
  LKSL.Events.Main;

type
  TSaveData2MongoDBEvent = class(TLKEvent)
  private
    FJSONData,
    FMongoCollectName: string;
    FDispNo: integer;
  public
    constructor Create(const AMongoCollectName, AJSONData: String; ADispNo: integer=0); reintroduce;
    property JSONData: String read FJSONData;
    property MongoCollectName: String read FMongoCollectName;
    property DispNo: integer read FDispNo;
  end;

  TStrMsgEventListener = class(TLKEventListener<TSaveData2MongoDBEvent>);

implementation

{ TTestEvent }

constructor TSaveData2MongoDBEvent.Create(const AMongoCollectName, AJSONData: String; ADispNo: integer);
begin
  inherited Create;
  FMongoCollectName := AMongoCollectName;
  FJSONData := AJSONData;
  FDispNo := ADispNo;
end;

end.
