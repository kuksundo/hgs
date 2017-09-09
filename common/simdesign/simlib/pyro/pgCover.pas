{ Project: Pyro
  Module: Pyro Render

  Description:
    Coverage definition of a rectangular block of pixels.

  Author: Nils Haeck (n.haeck@simdesign.nl)
  Copyright (c) 2004 - 2011 SimDesign BV
}
unit pgCover;

{$i simdesign.inc}

interface

uses
  Classes, SysUtils, Pyro;

type

  TpgSpan = packed record
    XPos, YPos: word;
    Index: integer;
    Count: word;
  end;
  PpgSpan = ^TpgSpan;

  // TpgCover holds the coverage values of pixels in a rectangular block. The
  // covers are stored in spans, to avoid storing the whole coverage map. This
  // is conform the AGG approach on scan conversion. The coverage map can be
  // used later to paint in the pixels with either a solid color, a gradient,
  // a texture, or any other user-defined function.
  //
  // Width, Height describes the size of the cover.
  TpgCover = class(TPersistent)
  private
    FWidth: integer;
    FHeight: integer;
    FSpanCount: integer;
    FCoverCount: integer;
    FSpans: array of TpgSpan;
    FCovers: array of byte;
    function AddSpan: PpgSpan;
    function AddCovers(ACount: integer): integer;
    function GetSpans: PpgSpan;
    function GetCovers: Pbyte;
  protected
    // Combine spans A and B with AND, the cover pointers are in CoverA/B/R (result)
    procedure CombineSpansAND(const SpanA, SpanB: TpgSpan; B, R: TpgCover);
    function CombineValueAND(ValueA, ValueB: byte): byte;
  public
    constructor Create; virtual;
    procedure Assign(Source: TPersistent); override;
    procedure AddAASpan(x, y, Count: integer; Covers: PByte);
    procedure AddSolidSpan(x, y, Count: integer; Value: byte);
    procedure Clear; virtual;
    class function IsSolidSpan(const ASpan: TpgSpan): boolean;
    procedure SetSize(AWidth, AHeight: integer);
    function WriteToString: string;
    // Combine this cover with ACover, and put the result in this cover. Only
    // add spans where both have values, always take the smallest value. Scratch
    // is a cover used for temporary results, or nil if none availabe.
    procedure CombineAND(ACover: TpgCover; Scratch: TpgCover);
    property Width: integer read FWidth write FWidth;
    property Height: integer read FHeight write FHeight;
    property SpanCount: integer read FSpanCount;
    property Spans: PpgSpan read GetSpans;
    property Covers: Pbyte read GetCovers;
    property CoverCount: integer read FCoverCount;
  end;

implementation

{ TpgCover }

procedure TpgCover.AddAASpan(x, y, Count: integer; Covers: PByte);
var
  ASpan: PpgSpan;
begin
  if Count <= 0 then exit;
  ASpan := AddSpan;
  ASpan.XPos := X;
  ASpan.YPos := Y;
  ASpan.Count := Count;
  ASpan.Index := AddCovers(Count);
  Move(Covers^, FCovers[ASpan.Index], Count * sizeof(byte));
end;

function TpgCover.AddCovers(ACount: integer): integer;
begin
  if FCoverCount + ACount > length(FCovers) then
    SetLength(FCovers, FCoverCount + pgMax(ACount, FCoverCount div 2));
  Result := FCoverCount;
  inc(FCoverCount, ACount);
end;

procedure TpgCover.AddSolidSpan(x, y, Count: integer; Value: byte);
var
  ASpan: PpgSpan;
begin
  if Count <= 0 then exit;
  ASpan := AddSpan;
  ASpan.XPos := X;
  ASpan.YPos := Y;
  ASpan.Count := Count;
  ASpan.Index := -Value;
end;

function TpgCover.AddSpan: PpgSpan;
begin
  if FSpanCount >= length(FSpans) then
    SetLength(FSpans, FSpanCount + pgMax(FHeight, FSpanCount div 2));
  Result := @FSpans[FSpanCount];
  inc(FSpanCount);
end;

procedure TpgCover.Assign(Source: TPersistent);
var
  S: TpgCover;
begin
  if Source is TpgCover then
  begin
    S := Source as TpgCover;
    FWidth := S.FWidth;
    FHeight := S.FHeight;
    FSpanCount := S.FSpanCount;
    FCoverCount := S.FCoverCount;
    // Array lengths
    SetLength(FSpans,  pgMax(Length(S.FSpans),  Length(FSpans)));
    SetLength(FCovers, pgMax(Length(S.FCovers), Length(FCovers)));
    // Copy arrays
    if FSpanCount > 0 then
      Move(S.FSpans[0], FSpans[0], FSpanCount * SizeOf(TpgSpan));
    if FCoverCount > 0 then
      Move(S.FCovers[0], FCovers[0], FCoverCount * SizeOf(byte));
  end else
    inherited;
end;

procedure TpgCover.Clear;
begin
  FSpanCount := 0;
  FCoverCount := 0;
end;

procedure TpgCover.CombineAND(ACover, Scratch: TpgCover);
var
  Line: integer;
  R: TpgCover;
  SpanA, SpanB, SpanAEnd, SpanBEnd: PpgSpan;
begin
  if (FWidth <> ACover.Width) or (FHeight <> ACover.FHeight) then
    raise Exception.Create('Cover sizes not equal');

  if (SpanCount = 0) or (ACover.SpanCount = 0)then
  begin
    Clear;
    exit;
  end;

  // Resulting cover
  if not assigned(Scratch) then
    R := TpgCover.Create
  else
    R := Scratch;
  // Set size and clear R
  R.SetSize(FWidth, FHeight);

  // Span pointers
  SpanA := GetSpans;
  SpanAEnd := SpanA; inc(SpanAEnd, SpanCount);
  SpanB := ACover.Getspans;
  SpanBEnd := SpanB; inc(SpanBEnd, ACover.SpanCount);

  // Loop through our spans
  while (SpanA <> SpanAEnd) and (SpanB <> SpanBEnd) do
  begin
    // Get to the same line
    Line := SpanB.YPos;
    while (SpanA <> SpanAEnd) and (SpanA.YPos < Line) do
      inc(SpanA);
    if SpanA = SpanAEnd then break;
    Line := SpanA.YPos;
    while (SpanB <> SpanBEnd) and (SpanB.YPos < Line) do
      inc(SpanB);
    if SpanB = SpanBEnd then break;

    // At same line?
    if SpanA.YPos <> SpanB.YPos then continue;

    // we are at same line, get to overlap
    if SpanA.XPos + SpanA.Count <= SpanB.XPos then
    begin
      inc(SpanA);
      continue;
    end;
    if SpanB.XPos + SpanB.Count <= SpanA.XPos then
    begin
      inc(SpanB);
      continue;
    end;

    // We are at an overlap
    CombineSpansAND(SpanA^, SpanB^, ACover, R);

    // Determine which one to increase
    if SpanA.XPos + SpanA.Count < SpanB.XPos + SpanB.Count then
      inc(SpanA)
    else
      inc(SpanB);

  end;

  // Assign result
  Assign(R);

  // Free scratch if it wasn't passed
  if R <> Scratch then
    R.Free;
end;

procedure TpgCover.CombineSpansAND(const SpanA, SpanB: TpgSpan; B, R: TpgCover);
var
  i, StartA, StartB, StartR, CloseA, CloseB, CloseR, IndexR, CountR: integer;
  CoverA, CoverB, CoverR: Pbyte;
  ValueA, ValueB: byte;
  SpanR: PpgSpan;
begin
  // Determine start / close
  StartA := SpanA.XPos;
  CloseA := StartA + SpanA.Count;
  StartB := SpanB.XPos;
  closeB := StartB + SpanB.Count;

  // Smallest interval
  StartR := pgMax(StartA, StartB);
  CloseR := pgMin(CloseA, CloseB);

  // Number of bytes in span
  CountR := CloseR - StartR;

  // One of them AA spans?
  if (SpanA.Index >= 0) or (SpanB.Index >= 0) then
  begin
    // Reserve covers
    IndexR := R.AddCovers(CountR);
    CoverR := R.GetCovers;
    inc(CoverR, IndexR);

    // CoverA pointer
    if SpanA.Index >= 0 then
    begin
      CoverA := GetCovers;
      inc(CoverA, SpanA.Index);
      if StartA < StartR then
        inc(CoverA, StartR - StartA);
    end else
    begin
      ValueA := -SpanA.Index;
      CoverA := @ValueA;
    end;
    // CoverB pointer
    if SpanB.Index >= 0 then
    begin
      CoverB := B.GetCovers;
      inc(CoverB, SpanB.Index);
      if StartB < StartR then
        inc(CoverB, StartR - StartB);
    end else
    begin
      ValueB := -SpanB.Index;
      CoverB := @ValueB;
    end;

    // Copy covers
    for i := 0 to CountR - 1 do
    begin
      CoverR^ := CombineValueAND(CoverA^, CoverB^);
      if SpanA.Index >= 0 then
        inc(CoverA);
      if SpanB.Index >= 0 then
        inc(CoverB);
      inc(CoverR);
    end;

    // Now add an AA span
    SpanR := R.AddSpan;
    SpanR.XPos := StartR;
    SpanR.YPos := SpanA.YPos;
    SpanR.Count := CountR;
    SpanR.Index := IndexR;

  end else
  begin

    // Both solid spans
    R.AddSolidSpan(StartR, SpanA.YPos, CountR,
      CombineValueAND(-SpanA.Index, -SpanB.Index));

  end;
end;

function TpgCover.CombineValueAND(ValueA, ValueB: byte): byte;
begin
  // Combine two values - we use the (A * B) div 255 replacement
  Result := pgIntMul(ValueA, ValueB);
end;

constructor TpgCover.Create;
begin
  inherited Create;
end;

function TpgCover.GetCovers: Pbyte;
begin
  if FCoverCount > 0 then
    Result := @FCovers[0]
  else
    Result := nil;
end;

function TpgCover.GetSpans: PpgSpan;
begin
  if FSpanCount > 0 then
    Result := @FSpans[0]
  else
    Result := nil;
end;

class function TpgCover.IsSolidSpan(const ASpan: TpgSpan): boolean;
begin
  Result := ASpan.Index < 0;
end;

procedure TpgCover.SetSize(AWidth, AHeight: integer);
begin
  Clear;
  FWidth := AWidth;
  FHeight := AHeight;
end;

function TpgCover.WriteToString: string;
var
  i, j: integer;
begin
  Result := '';
  for i := 0 to FSpanCount - 1 do
  begin
    Result := Result + Format('X:%d Y:%d Cnt:%d', [FSpans[i].XPos, FSpans[i].YPos, FSpans[i].Count]);
    if FSpans[i].Index >= 0 then
    begin
      // solid span
      Result := Result + ' Cvrs: ';
      for j := 0 to FSpans[i].Count - 1 do
        Result := Result + IntToHex(FCovers[FSpans[i].Index +  j], 2) + ' ';
    end else
      Result := Result + ' Fixd: ' + IntToHex(-FSpans[i].Index, 2);
    Result := Result + #13#10;
  end;
end;

end.
