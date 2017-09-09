///<summary> statistical tools </summary>
unit u_dzStatistics;

interface

uses
  SysUtils,
  u_dzTranslator,
  u_dzRingBuffer;

type
  TMovingAverage = class
  private
    FCount: integer;
    FSum: extended;
    FMaxCount: integer;
    FQueue: TdzRingQueue;
  public
    constructor Create(_MaxCount: integer);
    destructor Destroy; override;
    procedure Add(_Value: Extended);
    function GetAverage: extended;
    property Count: integer read FCount;
  end;

implementation


function _(const _s: string): string; inline;
begin
  Result := dzDGetText(_s, 'dzlib');
end;

{ TMovingAverage }

constructor TMovingAverage.Create(_MaxCount: integer);
begin
  inherited Create;
  FSum := 0;
  FCount := 0;
  FMaxCount := _MaxCount;
  FQueue := TdzRingQueue.Create(SizeOf(Extended), FMaxCount);
end;

destructor TMovingAverage.Destroy;
begin
  FreeAndNil(FQueue);
  inherited;
end;

procedure TMovingAverage.Add(_Value: Extended);
var
  ValueToRemove: extended;
begin
  if FCount >= FMaxCount then begin
    FQueue.ExtractFront(ValueToRemove);
    FSum := FSum - ValueToRemove;
  end else
    Inc(FCount);
  FQueue.InsertEnd(_Value);
  FSum := FSum + _Value;
end;

function TMovingAverage.GetAverage: extended;
begin
  if FCount > 0 then
    Result := FSum / FCount
  else
    raise Exception.Create(_('Cannot calculate moving average on zero elements'));
end;

end.

