unit UnitMQTTMsg.EventThreads;

interface

uses
  System.Classes, System.SyncObjs, System.SysUtils, System.IOUtils,
  LKSL.Common.Types,
  LKSL.Threads.Main,
  LKSL.Events.Main,
  LKSL.Generics.Collections,
  UnitMQTTMsg.Events;

type
  TDisplayMsgProc = procedure(msg: string; ADspNo: integer) of object;
  TMQTTMsgProc = procedure(AMsgEvent: TMQTTMsgEvent) of object;
  TSynchroProc = procedure(AMsgEvent: TMQTTMsgEvent) of object;

  TMQTTMsgEventThread = class(TLKEventThread)
  private
    FPerformanceHistory: TLKList<LKFloat>;
    FListener: TMQTTMsgEventListener;
    procedure DoEvent(const AEvent: TMQTTMsgEvent);

    function GetAveragePerformance: LKFloat;
  protected
    function GetPauseOnNoEvent: Boolean; override;
//    procedure Tick(const ADelta, AStartTime: LKFloat); override;
    procedure InitializeListeners; override;
    procedure FinalizeListeners; override;
  public
    FDisplayMsgProc: TDisplayMsgProc;
    FMQTTMsgProc: TMQTTMsgProc;
    FSynchroProc: TSynchroProc;

    procedure SetMQTTMsgProc(AProc: TMQTTMsgProc);
    procedure SetDisplayMsgProc(AProc: TDisplayMsgProc);
    procedure SetSynchroProc(AProc: TSynchroProc);
  end;

  TMQTTMsgEventPool = class(TLKEventPool<TMQTTMsgEventThread>);

var
  MQTTMsgEventThread: TMQTTMsgEventThread;

implementation

uses LKSL.Math.SIUnits, UnitWorker4OmniMsgQ;

{ TMQTTMsgEventThread }

procedure TMQTTMsgEventThread.DoEvent(const AEvent: TMQTTMsgEvent);
var
  LDelta: LKFloat;
begin
  //AEvent.Command = 4 이면 Synchronize에서 실행해야 함(화면 변경)
  if (AEvent.Command <> 4) and Assigned(FMQTTMsgProc) then
     FMQTTMsgProc(AEvent);

  SYNCHRONIZE(procedure
              begin
                if Assigned(FSynchroProc) then
                  FSynchroProc(AEvent);

                if Assigned(FDisplayMsgProc) then
                  FDisplayMsgProc(AEvent.Topic + ':' + AEvent.FFMessage,AEvent.DispNo);
              end);
end;

procedure TMQTTMsgEventThread.FinalizeListeners;
begin
  inherited;
  FListener.Free;
  FPerformanceHistory.Free;
end;

function TMQTTMsgEventThread.GetAveragePerformance: LKFloat;
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

function TMQTTMsgEventThread.GetPauseOnNoEvent: Boolean;
begin
  Result := False; // Force this Thread to Tick constantly!
end;

procedure TMQTTMsgEventThread.InitializeListeners;
begin
  inherited;
  FPerformanceHistory := TLKList<LKFloat>.Create;
  FListener := TMQTTMsgEventListener.Create(Self, DoEvent);
end;

procedure TMQTTMsgEventThread.SetDisplayMsgProc(AProc: TDisplayMsgProc);
begin
  FDisplayMsgProc := AProc;
end;

procedure TMQTTMsgEventThread.SetMQTTMsgProc(AProc: TMQTTMsgProc);
begin
  FMQTTMsgProc := AProc;
end;

procedure TMQTTMsgEventThread.SetSynchroProc(AProc: TSynchroProc);
begin
  FSynchroProc := AProc;
end;

//procedure TMQTTMsgEventThread.Tick(const ADelta, AStartTime: LKFloat);
//begin
//  TMQTTMsgEvent.Create('Thread-Dispatched Event').Queue;
//end;

initialization
//  TestEventPool := TMQTTMsgEventPool.Create(TThread.ProcessorCount);
  MQTTMsgEventThread := TMQTTMsgEventThread.Create;
finalization
//  TestEventPool.Free;
  MQTTMsgEventThread.Free;

end.
