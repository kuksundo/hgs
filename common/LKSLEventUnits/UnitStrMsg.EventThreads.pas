unit UnitStrMsg.EventThreads;

interface

uses
  System.Classes, System.SyncObjs, System.SysUtils, System.IOUtils,
  LKSL.Common.Types,
  LKSL.Threads.Main,
  LKSL.Events.Main,
  LKSL.Generics.Collections,
  UnitStrMsg.Events;

type
  TDisplayMsgProc = procedure(msg: string; ADspNo: integer) of object;

  TStrMsgEventThread = class(TLKEventThread)
  private
    FPerformanceHistory: TLKList<LKFloat>;
    FListener: TStrMsgEventListener;
    procedure DoEvent(const AEvent: TStrMsgEvent);

    function GetAveragePerformance: LKFloat;
  protected
    function GetPauseOnNoEvent: Boolean; override;
//    procedure Tick(const ADelta, AStartTime: LKFloat); override;
    procedure InitializeListeners; override;
    procedure FinalizeListeners; override;
  public
    FDisplayMsgProc: TDisplayMsgProc;
  end;

  TStrMsgEventPool = class(TLKEventPool<TStrMsgEventThread>);

var
  StrMsgEventThread: TStrMsgEventThread;

implementation

uses
  LKSL.Math.SIUnits;

{ TStrMsgEventThread }

procedure TStrMsgEventThread.DoEvent(const AEvent: TStrMsgEvent);
var
  LDelta: LKFloat;
begin
//  LDelta := GetReferenceTime - AEvent.DispatchTime;
//  FPerformanceHistory.Add(LDelta);
  if AEvent.FileName <> '' then
  begin
    if FileExists(AEvent.FileName) then
      TFile.AppendAllText(AEvent.FileName, AEvent.StrMsg)
    else
      TFile.WriteAllText(AEvent.FileName, AEvent.StrMsg);
  end;


  SYNCHRONIZE(procedure
              begin
                if Assigned(FDisplayMsgProc) then
                   FDisplayMsgProc(AEvent.StrMsg,0);
//                Form1.memLog.Lines.Add(Format('Average Over %d Runs = %s Seconds [This run = %s Seconds]', [FPerformanceHistory.Count, FormatFloat('#######################.#######################', GetAveragePerformance), FormatFloat('#######################.#######################', LDelta)]));
//                Form1.memLog.Lines.Add(Format('Thread Event Rate Average = %s Events Per Second', [FormatFloat('#######################.####', EventRateAverage)]));
              end);
end;

procedure TStrMsgEventThread.FinalizeListeners;
begin
  inherited;
  FListener.Free;
  FPerformanceHistory.Free;
end;

function TStrMsgEventThread.GetAveragePerformance: LKFloat;
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

function TStrMsgEventThread.GetPauseOnNoEvent: Boolean;
begin
  Result := False; // Force this Thread to Tick constantly!
end;

procedure TStrMsgEventThread.InitializeListeners;
begin
  inherited;
  FPerformanceHistory := TLKList<LKFloat>.Create;
  FListener := TStrMsgEventListener.Create(Self, DoEvent);
end;

//procedure TStrMsgEventThread.Tick(const ADelta, AStartTime: LKFloat);
//begin
//  TStrMsgEvent.Create('Thread-Dispatched Event').Queue;
//end;

initialization
//  TestEventPool := TStrMsgEventPool.Create(TThread.ProcessorCount);
  StrMsgEventThread := TStrMsgEventThread.Create;
finalization
//  TestEventPool.Free;
  StrMsgEventThread.Free;

end.
