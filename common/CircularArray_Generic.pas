unit CircularArray_Generic;

interface

uses
  SysUtils, Classes;

type
  TCircularArray<T> = class
  private
    FSize  : integer;
    FFirst : integer;
    FLast  : integer;
    FAverage: double;
    FSum   : T;
    FMin   : T;
    FMax   : T;
    FFirstCircular: Boolean;
  protected
    procedure   SetBufSize(newSize : Integer);
  public
    FData  : array of T;

    constructor Create( qsize: integer );
    destructor Destroy; override;
    function IsFull: boolean;
    function IsEmpty: boolean;
    function Put( data: T ): boolean;
    function Get: T;
    function Peek: T;
    procedure ClearBuffer;

    property Size: integer read FSize write SetBufSize;
    property Sum: T read FSum write FSum;
    property Average: double read FAverage write FAverage;
    property Min: T read FMin write FMin;
    property Max: T read FMax write FMax;
  end;

implementation

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ TCircularArray }

procedure TCircularArray<T>.ClearBuffer;
begin
  FLast := -1;
  FFirst := -1;
  FSum := Default(T);
  FAverage := 0.0;
  FFirstCircular := False;
end;

constructor TCircularArray<T>.Create( qsize: integer );
begin
  inherited Create;

  if qsize <= 0 then
    qsize := 1;

  FSize := qsize;
  FLast := -1;
  FFirst := -1;
  FSum := Default(T);
  FAverage := 0.0;
  FFirstCircular := False;

  SetLength(FData,FSize);
end;

destructor TCircularArray<T>.Destroy;
begin
  SetLength(FData,0);
  inherited Destroy;
end;

function TCircularArray<T>.IsFull: boolean;
begin
  //result := FCount=FSize;
  result := False;
end;

function TCircularArray<T>.IsEmpty: boolean;
begin
  //result := FCount=0;
  result := False;
end;

function TCircularArray<T>.Put( data: T ): boolean;
begin
  if IsFull then
    result := false
  else
  begin
    inc(FLast);
    
    if FLast = FSize then
    begin
      FLast := 0;
      FFirstCircular := True;
    end;

    if FFirstCircular then
    begin
      Sum := Sum + data - FData[FLast];
      Average := Sum / FSize;
    end
    else
    begin
      Sum := Sum + data;
      Average := Sum / (FLast + 1);
    end;

    if FMin > data then
      FMin := data;

    if FMax < data then
      FMax := data;
    
    FData[FLast] := data;

    result := true;
  end;
end;

procedure TCircularArray<T>.SetBufSize(newSize: Integer);
var
  Li: integer;
begin
  if newSize = FSize then
    Exit;

  if (FLast = 0) and not FFirstCircular then
  begin{ Buffer is empty }
    FSum := 0.0;
    FAverage := 0.0;
    FLast := -1;
    FSize := newSize;
    SetLength(FData,FSize);
  end
  else
  begin{ Buffer contains data }
    if FSize > newSize then   //기존 크기보다 줄어든 경우
    begin
      if FLast >= newSize then
        FLast := newSize - 1;
    end
    else
    begin
      if FFirstCircular then
        FLast := FSize - 1;
        
      FFirstCircular := False;
    end;

    FSize := newSize;
    SetLength(FData,FSize);

    FSum := 0.0;
    
    for Li := Low(FData) to High(FData) do
      FSum := FSum + FData[Li];

    if FLast <> -1 then
      FAverage := FSum / (FLast + 1);
  end;
end;

function TCircularArray<T>.Get: T;
begin
  if IsEmpty then result := 0.0
  else
  begin
    result := FData[FFirst];
    inc(FFirst);
    if FFirst=FSize then FFirst := 0;
  end;
end;

function TCircularArray<T>.Peek: T;
begin
  if IsEmpty then result := 0.0
             else result := FData[FFirst];
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
end.

