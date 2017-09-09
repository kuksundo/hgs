unit UnitSTOMPMsg.EventThreads;

interface

uses
  System.Classes, System.SyncObjs, System.SysUtils, System.IOUtils,
  LKSL.Common.Types,
  LKSL.Threads.Main,
  LKSL.Events.Main,
  LKSL.Generics.Collections,
  UnitSTOMPMsg.Events;

type
  TDisplayMsgProc = procedure(msg: string; ADspNo: integer) of object;
  TSTOMPMsgProc = procedure(AMsgEvent: TSTOMPMsgEvent) of object;
  TSynchroProc = procedure(AMsgEvent: TSTOMPMsgEvent) of object;

  TSTOMPMsgEventThread = class(TLKEventThread)
  private
    FPerformanceHistory: TLKList<LKFloat>;
    FListener: TSTOMPMsgEventListener;
    procedure DoEvent(const AEvent: TSTOMPMsgEvent);

    function GetAveragePerformance: LKFloat;
  protected
    function GetPauseOnNoEvent: Boolean; override;
//    procedure Tick(const ADelta, AStartTime: LKFloat); override;
    procedure InitializeListeners; override;
    procedure FinalizeListeners; override;
  public
    FDisplayMsgProc: TDisplayMsgProc;
    FSTOMPMsgProc: TSTOMPMsgProc;
    FSynchroProc: TSynchroProc;

    procedure SetSTOMPMsgProc(AProc: TSTOMPMsgProc);
    procedure SetDisplayMsgProc(AProc: TDisplayMsgProc);
    procedure SetSynchroProc(AProc: TSynchroProc);
  end;

  TSTOMPMsgEventPool = class(TLKEventPool<TSTOMPMsgEventThread>);

var
  STOMPMsgEventThread: TSTOMPMsgEventThread;

implementation

uses LKSL.Math.SIUnits, UnitWorker4OmniMsgQ;

{ TSTOMPMsgEventThread }

procedure TSTOMPMsgEventThread.DoEvent(const AEvent: TSTOMPMsgEvent);
var
  LDelta: LKFloat;
begin
  //AEvent.Command = 4 이면 Synchronize에서 실행해야 함(화면 변경)
  if (AEvent.Command <> 4) and Assigned(FSTOMPMsgProc) then
     FSTOMPMsgProc(AEvent);

  SYNCHRONIZE(procedure
              begin
                if Assigned(FSynchroProc) then
                  FSynchroProc(AEvent);

                if Assigned(FDisplayMsgProc) then
                  FDisplayMsgProc(AEvent.Topic + ':' + AEvent.FFMessage,0);
              end);
end;

procedure TSTOMPMsgEventThread.FinalizeListeners;
begin
  inherited;
  FListener.Free;
  FPerformanceHistory.Free;
end;

function TSTOMPMsgEventThread.GetAveragePerformance: LKFloat;
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

function TSTOMPMsgEventThread.GetPauseOnNoEvent: Boolean;
begin
  Result := False; // Force this Thread to Tick constantly!
end;

procedure TSTOMPMsgEventThread.InitializeListeners;
begin
  inherited;
  FPerformanceHistory := TLKList<LKFloat>.Create;
  FListener := TSTOMPMsgEventListener.Create(Self, DoEvent);
end;

procedure TSTOMPMsgEventThread.SetDisplayMsgProc(AProc: TDisplayMsgProc);
begin
  FDisplayMsgProc := AProc;
end;

procedure TSTOMPMsgEventThread.SetSTOMPMsgProc(AProc: TSTOMPMsgProc);
begin
  FSTOMPMsgProc := AProc;
end;

procedure TSTOMPMsgEventThread.SetSynchroProc(AProc: TSynchroProc);
begin
  FSynchroProc := AProc;
end;

//procedure TSTOMPMsgEventThread.Tick(const ADelta, AStartTime: LKFloat);
//begin
//  TSTOMPMsgEvent.Create('Thread-Dispatched Event').Queue;
//end;

initialization
//  TestEventPool := TSTOMPMsgEventPool.Create(TThread.ProcessorCount);
  STOMPMsgEventThread := TSTOMPMsgEventThread.Create;
finalization
//  TestEventPool.Free;
  STOMPMsgEventThread.Free;

end.
