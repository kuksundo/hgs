{ *********************************************************************** }
{                                                                         }
{ TextBuilder                                                             }
{                                                                         }
{ Copyright (c) 2008 Pisarev Yuriy (post@pisarev.net)                     }
{                                                                         }
{ *********************************************************************** }

unit TextBuilder;

interface

{$B-}

uses
  Windows, SysUtils, Types, MemoryUtils, NumberConsts;

type
  ETextBuilderError = class(Exception);

  TTextBuilder = class
  private
    FDecreaseFactor: Double;
    FIndex: Integer;
    FIncreaseFactor: Double;
    FCharArray: TCharDynArray;
    function GetCapacity: Integer;
    function GetData: PChar;
    function GetSize: Integer;
    function GetText: string;
    procedure SetCapacity(const Value: Integer);
  protected
    procedure Error(const Message: string); overload; virtual;
    procedure Error(const Message: string; const Arguments: array of const); overload; virtual;
    procedure FindIndex; virtual;
    procedure MoveIndex(const Value: Integer); virtual;
    property CharArray: TCharDynArray read FCharArray write FCharArray;
    property Index: Integer read FIndex write FIndex;
  public
    constructor Create(ACapacity: Integer); overload; virtual;
    constructor Create(const AText: string); overload; virtual;
    constructor Create; overload; virtual;
    destructor Destroy; override;
    procedure IncreaseCapacity(Value: Integer); virtual;
    procedure Clear; virtual;
    function Delete(AIndex, Count: Integer): Boolean; virtual;
    procedure Append(AData: Pointer; Count: Integer); overload; virtual;
    procedure Append(const AText: string); overload; virtual;
    procedure Append(const AText, Delimiter: string); overload; virtual;
    function Insert(AData: Pointer; Count: Integer; AIndex: Integer = 0): Boolean; overload; virtual;
    function Insert(const AText: string; AIndex: Integer = 0): Boolean; overload; virtual;
    property Data: PChar read GetData;
    property Text: string read GetText;
    property Capacity: Integer read GetCapacity write SetCapacity;
    property Size: Integer read GetSize;
    property IncreaseFactor: Double read FIncreaseFactor write FIncreaseFactor;
    property DecreaseFactor: Double read FDecreaseFactor write FDecreaseFactor;
  end;

const
  DefaultCapacity = Kilobyte;
  DefaultIncreaseFactor = 2;
  DefaultDecreaseFactor = 1;

implementation

uses
  Math, TextConsts;

{ TTextBuilder }

procedure TTextBuilder.Append(AData: Pointer; Count: Integer);
begin
  if Count > 0 then
  begin
    IncreaseCapacity(Count);
    CopyMemory(@FCharArray[Size], AData, Count * SizeOf(Char));
    MoveIndex(Count);
  end;
end;

procedure TTextBuilder.Append(const AText: string);
begin
  Append(Pointer(AText), Length(AText));
end;

procedure TTextBuilder.Append(const AText, Delimiter: string);
begin
  if Size > 0 then Append(Delimiter + AText)
  else Append(AText);
end;

procedure TTextBuilder.Clear;
begin
  Capacity := Round(Length(FCharArray) * FDecreaseFactor);
  ZeroMemory(FCharArray, Length(FCharArray) * SizeOf(Char));
  FIndex := -1;
end;

constructor TTextBuilder.Create(ACapacity: Integer);
begin
  FIncreaseFactor := DefaultIncreaseFactor;
  FDecreaseFactor := DefaultDecreaseFactor;
  FIndex := -1;
  Capacity := ACapacity;
end;

constructor TTextBuilder.Create(const AText: string);
begin
  Create;
  Append(AText);
end;

constructor TTextBuilder.Create;
begin
  Create(DefaultCapacity);
end;

function TTextBuilder.Delete(AIndex, Count: Integer): Boolean;
begin
  Result := MemoryUtils.Delete(FCharArray, AIndex * SizeOf(Char),
    Count * SizeOf(Char), Size * SizeOf(Char));
  if Result then
  begin
    ZeroMemory(Pointer(Integer(FCharArray) + (Size - Count) * SizeOf(Char)),
      Count * SizeOf(Char));
    MoveIndex(- Count);
  end;
end;

destructor TTextBuilder.Destroy;
begin
  FCharArray := nil;
  inherited;
end;

procedure TTextBuilder.Error(const Message: string; const Arguments: array of const);
begin
  raise ETextBuilderError.CreateFmt(Message, Arguments);
end;

procedure TTextBuilder.Error(const Message: string);
begin
  Error(Message, []);
end;

procedure TTextBuilder.FindIndex;
begin
  if FIndex < 0 then
  begin
    FIndex := High(FCharArray);
    while (FIndex > -1) and (FCharArray[Index] = #0) do Dec(FIndex);
  end;
end;

function TTextBuilder.GetCapacity: Integer;
begin
  Result := Length(FCharArray);
end;

function TTextBuilder.GetData: PChar;
begin
  Result := PChar(FCharArray);
end;

function TTextBuilder.GetSize: Integer;
begin
  FindIndex;
  Result := FIndex + 1;
end;

function TTextBuilder.GetText: string;
begin
  if Size > 0 then SetString(Result, PChar(FCharArray), Size)
  else Result := '';
end;

procedure TTextBuilder.IncreaseCapacity(Value: Integer);
begin
  if Size + Value > Length(FCharArray) then
    Capacity := Round((Size + Value) * FIncreaseFactor);
end;

function TTextBuilder.Insert(AData: Pointer; Count, AIndex: Integer): Boolean;
begin
  IncreaseCapacity(Count);
  Result := MemoryUtils.Insert(FCharArray, AData, AIndex * SizeOf(Char),
    Size * SizeOf(Char), Count * SizeOf(Char));
  MoveIndex(Count);
end;

function TTextBuilder.Insert(const AText: string; AIndex: Integer): Boolean;
begin
  Result := Insert(Pointer(AText), Length(AText), AIndex);
end;

procedure TTextBuilder.MoveIndex(const Value: Integer);
begin
  FIndex := EnsureRange(FIndex + Value, Low(FCharArray), High(FCharArray));
end;

procedure TTextBuilder.SetCapacity(const Value: Integer);
begin
  if Value <> Length(FCharArray) then
  begin
    if Value < Size then MoveIndex(Value - Size);
    Resize(FCharArray, Value);
  end;
end;

end.
