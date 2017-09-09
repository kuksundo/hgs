unit UnitCommDisconnected.EventThreads;

interface

uses
  System.Classes, System.SyncObjs, System.SysUtils, System.IOUtils,
  LKSL.Common.Types,
  LKSL.Threads.Main,
  LKSL.Events.Main,
  LKSL.Generics.Collections,
  UnitCommDisconnected.Events;

type
  TDisplayMsgProc = procedure(msg: string; ADspNo: integer) of object;
  TCommDisconnectedProc = procedure(AMsgEvent: TCommDisconnectedEvent) of object;

  TCommDisconnectedEventThread = class(TLKEventThread)
  private
    FPerformanceHistory: TLKList<LKFloat>;
    FListener: TCommDisconnectedEventListener;
    procedure DoEvent(const AEvent: TCommDisconnectedEvent);

    function GetAveragePerformance: LKFloat;
  protected
    function GetPauseOnNoEvent: Boolean; override;
//    procedure Tick(const ADelta, AStartTime: LKFloat); override;
    procedure InitializeListeners; override;
    procedure FinalizeListeners; override;
  public
    FDisplayMsgProc: TDisplayMsgProc;
    FCommDisconnectedProc: TCommDisconnectedProc;

    procedure SetCommDisconnectedProc(AProc: TCommDisconnectedProc);
    procedure SetDisplayMsgProc(AProc: TDisplayMsgProc);
  end;

  TCommDisconnectedEventPool = class(TLKEventPool<TCommDisconnectedEventThread>);

var
  CommDisconnectedEventThread: TCommDisconnectedEventThread;

implementation

uses LKSL.Math.SIUnits, UnitWorker4OmniMsgQ;

{ TCommDisconnectedEventThread }

procedure TCommDisconnectedEventThread.DoEvent(const AEvent: TCommDisconnectedEvent);
var
  LDelta: LKFloat;
begin
  if Assigned(FCommDisconnectedProc) then
     FCommDisconnectedProc(AEvent);

  SYNCHRONIZE(procedure
              begin
                if Assigned(FDisplayMsgProc) then
                   FDisplayMsgProc(AEvent.Topic + ':' + AEvent.FFMessage,0);
              end);
end;

procedure TCommDisconnectedEventThread.FinalizeListeners;
begin
  inherited;
  FListener.Free;
  FPerformanceHistory.Free;
end;

function TCommDisconnectedEventThread.GetAveragePerformance: LKFloat;
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

function TCommDisconnectedEventThread.GetPauseOnNoEvent: Boolean;
begin
  Result := False; // Force this Thread to Tick constantly!
end;

procedure TCommDisconnectedEventThread.InitializeListeners;
begin
  inherited;
  FPerformanceHistory := TLKList<LKFloat>.Create;
  FListener := TCommDisconnectedEventListener.Create(Self, DoEvent);
end;

procedure TCommDisconnectedEventThread.SetDisplayMsgProc(AProc: TDisplayMsgProc);
begin
  FDisplayMsgProc := AProc;
end;

procedure TCommDisconnectedEventThread.SetCommDisconnectedProc(AProc: TCommDisconnectedProc);
begin
  FCommDisconnectedProc := AProc;
end;

//procedure TCommDisconnectedEventThread.Tick(const ADelta, AStartTime: LKFloat);
//begin
//  TCommDisconnectedEvent.Create('Thread-Dispatched Event').Queue;
//end;

initialization
//  TestEventPool := TCommDisconnectedEventPool.Create(TThread.ProcessorCount);
  CommDisconnectedEventThread := TCommDisconnectedEventThread.Create;
finalization
//  TestEventPool.Free;
  CommDisconnectedEventThread.Free;

end.
