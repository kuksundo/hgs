{
  unit sdClusterFinder

  TsdClusterFinder allows to find clusters in N-dimensional space. A cluster is
  a cloud of points near to each other.

  Creation Date: 03Oct2008 (NH)

  Modifications:

  Copyright (c) 2008 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

}

unit sdClusterFinder;

interface

uses
  Classes, SysUtils, sdSortedLists;

type

  TsdCluster = class(TPersistent)
  private
    FValues: array of double;
    FCount: integer;
    FWeight: double;
    FReferences: TCustomSortedList;
    function GetValues(Index: integer): double;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    property Weight: double read FWeight;
    property Count: integer read FCount;
    property Values[Index: integer]: double read GetValues;
    property References: TCustomSortedList read FReferences;
  end;

  TsdClusterList = class(TCustomSortedList)
  private
    function GetItems(Index: integer): TsdCluster;
  protected
    function DoCompare(Item1, Item2: TObject): integer; override;
  public
    property Items[Index: integer]: TsdCluster read GetItems; default;
  end;

  TsdClusterFinder = class(TComponent)
  private
    FClusters: TsdClusterList;
    FLimitMin: array of double;
    FLimitMax: array of double;
    FInvTolerance: array of double;
    FDimensions: integer;
    procedure SetDimensions(const Value: integer);
  protected
    function FindCluster(const Values: array of double): TsdCluster;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear;
    procedure SetLimits(ADimension: integer; const ALimitMin, ALimitMax, ATolerance: double);
    function AddPoint(const Values: array of double; const AWeight: double): TsdCluster;
    property Dimensions: integer read FDimensions write SetDimensions;
    property Clusters: TsdClusterList read FClusters;
  end;

implementation

{ TsdCluster }

constructor TsdCluster.Create;
begin
  inherited;
  FReferences := TCustomSortedList.Create(False);
end;

destructor TsdCluster.Destroy;
begin
  FreeAndNil(FReferences);
  inherited;
end;

function TsdCluster.GetValues(Index: integer): double;
begin
  if (Index >= 0) and (Index < length(FValues)) then
    Result := FValues[Index]
  else
    Result := 0;
end;

{ TsdClusterList }

function TsdClusterList.DoCompare(Item1, Item2: TObject): integer;
var
  C1, C2: TsdCluster;
begin
  C1 := TsdCluster(Item1);
  C2 := TsdCluster(Item2);
  //Compare by weight, descending
  Result := -CompareDouble(C1.Weight, C2.Weight);
end;

function TsdClusterList.GetItems(Index: integer): TsdCluster;
begin
  if (Index >= 0) and (Index < Count) then
    Result := Get(Index)
  else
    Result := nil;
end;

{ TsdClusterFinder }

function TsdClusterFinder.AddPoint(const Values: array of double; const AWeight: double): TsdCluster;
  // local
  procedure AddPointToCluster;
  var
    j: integer;
    V, NewWeight: double;
  begin
    NewWeight := Result.FWeight + AWeight;

    // Update the values in a weighted manner
    for j := 0 to FDimensions - 1 do
    begin
      V := Result.FValues[j] * Result.FWeight + Values[j] * AWeight;
      Result.FValues[j] := V / NewWeight;
    end;
    Result.FWeight := NewWeight;
    inc(Result.FCount);

    // This re-sorts the list, using C's new weight
    FClusters.Extract(Result);
    FClusters.Add(Result);
  end;

  // local
  procedure NewCluster;
  var
    j: integer;
  begin
    Result.FWeight := AWeight;
    Result.FCount := 1;
    SetLength(Result.FValues, FDimensions);
    for j := 0 to FDimensions - 1 do
      Result.FValues[j] := Values[j];
    FClusters.Add(Result);
  end;

// main
var
  j: integer;
begin
  Result := nil;

  if (length(Values) < FDimensions) or (AWeight <= 0) then
    exit;

  // Check the limits
  for j := 0 to FDimensions - 1 do
    if (Values[j] < FLimitMin[j]) or (Values[j] > FLimitMax[j]) then
      exit;

  // Find a cluster in our list, that matches
  Result := FindCluster(Values);

  // If it exists, add to it, otherwise create a new cluster
  if assigned(Result) then
    AddPointToCluster
  else
  begin
    Result := TsdCluster.Create;
    NewCluster;
  end

end;

procedure TsdClusterFinder.Clear;
begin
  FClusters.Clear;
  SetDimensions(0);
end;

constructor TsdClusterFinder.Create(AOwner: TComponent);
begin
  inherited;
  FClusters := TsdClusterList.Create(True);
end;

destructor TsdClusterFinder.Destroy;
begin
  FreeAndNil(FClusters);
  inherited;
end;

function TsdClusterFinder.FindCluster(const Values: array of double): TsdCluster;
var
  i, j: integer;
  C: TsdCluster;
  Diff: double;
begin
  for i := 0 to FClusters.Count - 1 do
  begin
    C := FClusters[i];
    Diff := 0;
    for j := 0 to FDimensions - 1 do
    begin
      Diff := Diff + sqr((C.FValues[j] - Values[j]) * FInvTolerance[j]);
      if Diff > 1.0 then
        break;
    end;
    if Diff <= 1.0 then
    begin
      Result := C;
      exit;
    end;
  end;
  Result := nil;
end;

procedure TsdClusterFinder.SetDimensions(const Value: integer);
begin
  if FDimensions <> Value then
  begin
    FDimensions := Value;
    SetLength(FLimitMin, FDimensions);
    SetLength(FLimitMax, FDimensions);
    SetLength(FInvTolerance, FDimensions);
    // Ensure that cluster list is empty because dimensions of cluster items
    // might not match
    FClusters.Clear;
  end;
end;

procedure TsdClusterFinder.SetLimits(ADimension: integer; const ALimitMin, ALimitMax, ATolerance: double);
begin
  if ATolerance <= 0 then
    exit;
  FLimitMin[ADimension] := ALimitMin;
  FLimitMax[ADimension] := ALimitMax;
  FInvTolerance[ADimension] := 1 / ATolerance;
end;

end.
