unit UnitSaveData2MongoDB.EventThreads;
(*»ç¿ë¹ý:
  SaveData2MongoDBEventThread.InitializeMongoDB('127.0.0.1', 'DatabaseName');
  SaveData2MongoDBEventThread.InsertData2MongoDBProc := InsertData2MongoDB;
  TSaveData2MongoDBEvent.('CollName',{'name:"1", detp:"pjh"}').Queue;
  SaveData2MongoDBEventThread.FinalizeMongoDB;

  procedure InsertData2MongoDB(ADB : TMongoDatabase; AEvent:TSaveData2MongoDBEvent);
  var
    LColl: TMongoCollection;
    LDoc: variant;
  begin
    LColl := FDB.CollectionOrCreate[AEvent.MongoCollectName];
    try
      LDoc := TDocVariant.NewJSON(StringToUTF8(AEvent.JSONData));
      LColl.Insert(LDoc); // insert all values at once
    except

    end;
  end;
*)
interface

uses
  System.Classes, System.SyncObjs, System.SysUtils,
  LKSL.Common.Types,
  LKSL.Threads.Main,
  LKSL.Events.Main,
  LKSL.Generics.Collections,
  mORMot, mORMotUI, SynCommons, SynMongoDB,
  UnitSaveData2MongoDB.Events;

type
  TDisplayMsgProc = procedure(msg: string; ADspNo: integer) of object;
  TInsertData2MongoDBProc = procedure(ADB : TMongoDatabase; AEvent:TSaveData2MongoDBEvent) of object;

  TSaveData2MongoDBEventThread = class(TLKEventThread)
  private
    FPerformanceHistory: TLKList<LKFloat>;
    FListener: TStrMsgEventListener;
    procedure DoEvent(const AEvent: TSaveData2MongoDBEvent);

    function GetAveragePerformance: LKFloat;
  protected
    FClient : TMongoClient;
    FDB : TMongoDatabase;
    FInsertData2MongoDBProc : TInsertData2MongoDBProc;
    FDisplayMsgProc: TDisplayMsgProc;

    function GetPauseOnNoEvent: Boolean; override;
//    procedure Tick(const ADelta, AStartTime: LKFloat); override;
    procedure InitializeListeners; override;
    procedure FinalizeListeners; override;
    procedure InsertDataList2MongoDB(AEvent:TSaveData2MongoDBEvent);
    procedure SetInsertData2MongoDBProc(AProc : TInsertData2MongoDBProc);
    procedure SetDisplayMsgProc(AProc : TDisplayMsgProc);
  public
    procedure InitializeMongoDB(AHostIP, ADBName: string; APort: integer=27017);
    procedure FinalizeMongoDB;

    property DisplayMsgProc: TDisplayMsgProc read FDisplayMsgProc write SetDisplayMsgProc;
    property InsertData2MongoDBProc:TInsertData2MongoDBProc read FInsertData2MongoDBProc write SetInsertData2MongoDBProc;
  end;

  TStrMsgEventPool = class(TLKEventPool<TSaveData2MongoDBEventThread>);

var
  SaveData2MongoDBEventThread: TSaveData2MongoDBEventThread;

implementation

uses
  LKSL.Math.SIUnits;

{ TStrMsgEventThread }

procedure TSaveData2MongoDBEventThread.DoEvent(const AEvent: TSaveData2MongoDBEvent);
var
  LDelta: LKFloat;
begin
//  LDelta := GetReferenceTime - AEvent.DispatchTime;
//  FPerformanceHistory.Add(LDelta);
  InsertDataList2MongoDB(AEvent);

  SYNCHRONIZE(procedure
              begin
                if Assigned(FDisplayMsgProc) then
                   FDisplayMsgProc(AEvent.StrData,0);
//                Form1.memLog.Lines.Add(Format('Average Over %d Runs = %s Seconds [This run = %s Seconds]', [FPerformanceHistory.Count, FormatFloat('#######################.#######################', GetAveragePerformance), FormatFloat('#######################.#######################', LDelta)]));
//                Form1.memLog.Lines.Add(Format('Thread Event Rate Average = %s Events Per Second', [FormatFloat('#######################.####', EventRateAverage)]));
              end);
end;

procedure TSaveData2MongoDBEventThread.FinalizeListeners;
begin
  inherited;
  FListener.Free;
  FPerformanceHistory.Free;
end;

procedure TSaveData2MongoDBEventThread.FinalizeMongoDB;
begin
  if Assigned(FClient) then
    FClient.Free;
end;

function TSaveData2MongoDBEventThread.GetAveragePerformance: LKFloat;
var
  I: Integer;
  LTotal: LKFloat;
begin
  if FPerformanceHistory.Count > 0 then
  begin
    LTotal := 0;
    for I := 0 to FPerformanceHistory.Count - 1 do
      LTotal := LTotal + FPerformanceHistory[I];

    Result := LTotal / FPerformanceHistory.Count;
  end else
    Result := 0;
end;

function TSaveData2MongoDBEventThread.GetPauseOnNoEvent: Boolean;
begin
  Result := False; // Force this Thread to Tick constantly!
end;

procedure TSaveData2MongoDBEventThread.InitializeListeners;
begin
  inherited;
  FPerformanceHistory := TLKList<LKFloat>.Create;
  FListener := TStrMsgEventListener.Create(Self, DoEvent);
end;

procedure TSaveData2MongoDBEventThread.InitializeMongoDB(AHostIP, ADBName: string; APort: integer);
begin
  if Assigned(FClient) then
    FreeAndNil(FClient);

  FClient := TMongoClient.Create(AHostIP, APort);

  if Assigned(FClient) then
  begin
    FClient.WriteConcern := wcUnacknowledged;
    FDB := nil;
    FDB := FClient.Database[ADBName];
  end;
end;

procedure TSaveData2MongoDBEventThread.InsertDataList2MongoDB(
  AEvent:TSaveData2MongoDBEvent);
begin
  if Assigned(FInsertData2MongoDBProc) then
    FInsertData2MongoDBProc(FDB, AEvent);
end;

procedure TSaveData2MongoDBEventThread.SetDisplayMsgProc(
  AProc: TDisplayMsgProc);
begin
  FDisplayMsgProc := AProc;
end;

procedure TSaveData2MongoDBEventThread.SetInsertData2MongoDBProc(
  AProc: TInsertData2MongoDBProc);
begin
  FInsertData2MongoDBProc := AProc;
end;

initialization
  SaveData2MongoDBEventThread := TSaveData2MongoDBEventThread.Create;
finalization
  SaveData2MongoDBEventThread.Free;

end.
