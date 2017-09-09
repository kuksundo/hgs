unit mwPasParTypes;

interface

uses classes, mwPasLexTypes, SysUtils;

type
  TmwSorCompare = function(Item1, Item2: Pointer): Integer;

  TmwPasCodeInfoType = (
    ciArray,
    ciArrayConstant,
    ciBlock,
    ciCaseSection,
    ciClass,
    ciClassFieldDeclaration,
    ciClassForwardDeclaration,
    ciClassFunctionDeclaration,
    ciClassFunctionImplementation,
    ciClassOf,
    ciClassProcedureDeclaration,
    ciClassProcedureImplementation,
    ciClassReferenceDeclaration,
    ciConstDeclaration,
    ciConstructorDeclaration,
    ciConstructorImplementation,
    ciConstSection,
    ciDestructorDeclaration,
    ciDestructorImplementation,
    ciDispInterfaceDeclaration,
    ciFinalizationsSection,
    ciForLoop,
    ciFormalParameters,
    ciFunctionalTypeDeclaration,
    ciFunctionDeclaration,
    ciFunctionImplementation,
    ciFunctionMethodDeclaration,
    ciFunctionMethodImplementation,
    ciGUID,
    ciIfStatement,
    ciImplementationsSection,
    ciIncludeFile,
    ciInitializationsSection,
    ciInterfaceDeclaration,
    ciInterfaceSection,
    ciLabelDeclarationSection,
    ciLibrary,
    ciPackage,
    ciPackedArrayDeclaration,
    ciPackedSetDeclaration,
    ciPreHeader,
    ciPrivateVisible,
    ciProceduralTypeDeclaration,
    ciProcedureDeclaration,
    ciProcedureImplementation,
    ciProcedureMethodDeclaration,
    ciProcedureMethodImplementation,
    ciProgram,
    ciProtectetVisible,
    ciPublicVisible,
    ciPublishedVisible,
    ciRecord,
    ciRecordCaseSection,
    ciRecordConstantDeclaration,
    ciRecordDeclaration,
    ciRecordFieldConstantDeclaration,
    ciTypeSection,
    ciUnit,
    ciUnKnown,
    ciUnKnownSection,
    ciUnKnownVisible,
    ciUsesClause,
    ciVarDeclaration,
    ciVarSection
    );

  TmwPasCodeInfo = class;


  PPasCodeInfoArray = ^TPasCodeInfoArray;
  TPasCodeInfoArray = array[0..0] of TmwPasCodeInfo;

  TmwPasCodeInfoStack = class(TPersistent)
  private
    FCapacity: Integer;
    FCount: Integer;
    FCodeInfoList: PPasCodeInfoArray;
  protected
    procedure SetCapacity(NewCapacity: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    function Add(Item: TmwPasCodeInfo): Integer;
    function Last: TmwPasCodeInfo;
    property Count: Integer read FCount;
    procedure RemoveLast;
  end; { TmwPasCodeInfoStack }

  TmwPasCodeInfoList = class(TPersistent)
  private
    FCapacity: Integer;
    FCount: Integer;
    FCodeInfoList: PPasCodeInfoArray;
  protected
    function GetItems(Index: Integer): TmwPasCodeInfo;
    procedure SetCapacity(NewCapacity: Integer);
    procedure SetCount(NewCount: Integer);
    procedure SetItems(Index: Integer; Item: TmwPasCodeInfo);
  public
    constructor Create;
    destructor Destroy; override;
    function Add(Item: TmwPasCodeInfo): Integer;
    procedure Assign(Source: TPersistent); override;
    procedure Clear;
    procedure Delete(Index: Integer);
    procedure Exchange(Index1, Index2: Integer);
    function First: TmwPasCodeInfo;
    function IndexOf(Item: TmwPasCodeInfo): Integer;
    function IndexOfName(aName: String): Integer;
    procedure Insert(Index: Integer; Item: TmwPasCodeInfo);
    function Last: TmwPasCodeInfo;
    procedure Move(CurIndex, NewIndex: Integer);
    function Remove(Item: TmwPasCodeInfo): Integer;
    procedure Sort(SorCompare: TmwSorCompare);
    property Capacity: Integer read FCapacity write SetCapacity;
    property Count: Integer read FCount write SetCount;
    property Items[Index: Integer]: TmwPasCodeInfo read GetItems write SetItems; default;
    property InfoList: PPasCodeInfoArray read FCodeInfoList;
  end; { TmwPasCodeInfoList }

  TmwPasCodeInfo = class(TPersistent)
  private
    fName: String;
    fEndPos: Integer;
    fStartPos: Integer;
    fBelongsTo: TmwPasCodeInfo;
    fInfos: TmwPasCodeInfoList;
    fInfoType: TmwPasCodeInfoType;
    fLineNumber: Integer;
    procedure SetInfos(const Value: TmwPasCodeInfoList);
  public
    constructor Create;
    destructor Destroy; override;
  published
    procedure Assign(Source: TPersistent); override;
    property BelongsTo: TmwPasCodeInfo read fBelongsTo write fBelongsTo;
    property EndPos: Integer read fEndPos write fEndPos;
    property Infos: TmwPasCodeInfoList read fInfos write SetInfos;
    property InfoType: TmwPasCodeInfoType read fInfoType write fInfoType;
    property LineNumber: Integer read fLineNumber write fLineNumber;
    property Name: String read fName write fName;
    property StartPos: Integer read fStartPos write fStartPos;
  end;

  TmwPasUnitInfo = class(TmwPasCodeInfo)
  private
    fStream: TMemoryStream;
    fOwnStream: Boolean;
    fParsed: Boolean;
    fSecondUsesLine: Integer;
    fUsesLine: Integer;
    fInterfaceLine: Integer;
    fImplementationsLine: Integer;
    fLexStatus: TmwPasLexStatus;
    fUsesList: TStrings;
    fSecondUsesList: TStrings;
    fInfoStack: TmwPasCodeInfoStack;
    procedure SetParsed(const Value: Boolean);
    procedure SetSecondUsesList(const Value: TStrings);
    procedure SetUsesList(const Value: TStrings);
  protected
  public
    constructor Create(UnitName: string; SourceStream: TMemoryStream; OwnS: Boolean);
    destructor Destroy; override;
  published
    property ImplementationsLine: Integer read fImplementationsLine write fImplementationsLine;
    property InfoStack: TmwPasCodeInfoStack read fInfoStack;
    property InterfaceLine: Integer read fInterfaceLine write fInterfaceLine;
    property LexStatus: TmwPasLexStatus read fLexStatus write fLexStatus;
    property OwnStream: Boolean read fOwnStream;
    property Parsed: Boolean read fParsed write SetParsed;
    property SecondUsesLine: Integer read fSecondUsesLine write fSecondUsesLine;
    property SecondUsesList: TStrings read fSecondUsesList write SetSecondUsesList;
    property UsesLine: Integer read fUsesLine write fUsesLine;
    property UsesList: TStrings read fUsesList write SetUsesList;
  end;

implementation


{ TmwPasCodeInfoStack }

constructor TmwPasCodeInfoStack.Create;
begin
  inherited Create;
  FCount := 0;
  FCapacity := 0;
end; { Create }

destructor TmwPasCodeInfoStack.Destroy;
begin
  SetCapacity(0);
  inherited Destroy;
end; { Destroy }

procedure TmwPasCodeInfoStack.SetCapacity(NewCapacity: Integer);
begin
  if NewCapacity < FCount then FCount := NewCapacity;
  if NewCapacity <> FCapacity then
  begin
    ReallocMem(FCodeInfoList, NewCapacity * SizeOf(LongInt));
    FCapacity := NewCapacity;
  end;
end; { SetCapacity }

function TmwPasCodeInfoStack.Add(Item: TmwPasCodeInfo): Integer;
begin
  Result := FCount;
  if FCapacity = Result then
  begin
    if fCapacity < 4 then SetCapacity(FCapacity + 1) else
      if fCapacity < 10 then SetCapacity(FCapacity + 3) else
        if fCapacity < 30 then SetCapacity(FCapacity + 10) else
          if fCapacity < 100 then SetCapacity(FCapacity + 30) else SetCapacity(FCapacity + 256)
  end;
  FCodeInfoList[Result] := Item;
  Inc(FCount);
end; { Add }

function TmwPasCodeInfoStack.Last: TmwPasCodeInfo;
begin
  Result := FCodeInfoList[FCount - 1];
end; { Last }

procedure TmwPasCodeInfoStack.RemoveLast;
begin
  FCodeInfoList[fCount - 1] := nil;
  dec(FCount);
end; { Remove }

{ TmwPasCodeInfoList }

constructor TmwPasCodeInfoList.Create;
begin
  inherited Create;
  FCount := 0;
  FCapacity := 0;
end; { Create }

destructor TmwPasCodeInfoList.Destroy;
begin
  Clear;
  inherited Destroy;
end; { Destroy }

{ Based on a non-recursive QuickSort from the SWAG-Archive.
  ( TV Sorting Unit by Brad Williams ) }
procedure TmwPasCodeInfoList.Sort(SorCompare: TmwSorCompare);
var
  Left, Right, SubArray, SubLeft, SubRight: LongInt;
  Pivot, Temp: TmwPasCodeInfo;
  Stack: array[1..32] of record First, Last: LongInt;
  end;
begin
  if Count > 1 then
  begin
    SubArray := 1;
    Stack[SubArray].First := 0;
    Stack[SubArray].Last := Count - 1;
    repeat
      Left := Stack[SubArray].First;
      Right := Stack[SubArray].Last;
      Dec(SubArray);
      repeat
        SubLeft := Left;
        SubRight := Right;
        Pivot := FCodeInfoList[(Left + Right) shr 1];
        repeat
          while SorCompare(FCodeInfoList[SubLeft], Pivot) < 0 do Inc(SubLeft);
          while SorCompare(FCodeInfoList[SubRight], Pivot) < 0 do Dec(SubRight);
          IF SubLeft <= SubRight then
          begin
            Temp := FCodeInfoList[SubLeft];
            FCodeInfoList[SubLeft] := FCodeInfoList[SubRight];
            FCodeInfoList[SubRight] := Temp;
            Inc(SubLeft);
            Dec(SubRight);
          end;
        until SubLeft > SubRight;
        IF SubLeft < Right then
        begin
          Inc(SubArray);
          Stack[SubArray].First := SubLeft;
          Stack[SubArray].Last := Right;
        end;
        Right := SubRight;
      until Left >= Right;
    until SubArray = 0;
  end;
end; { Sort }

function TmwPasCodeInfoList.GetItems(Index: Integer): TmwPasCodeInfo;
begin
  Result := FCodeInfoList[Index];
end; { GetItems }

procedure TmwPasCodeInfoList.SetCapacity(NewCapacity: Integer);
begin
  if NewCapacity < FCount then FCount := NewCapacity;
  if NewCapacity <> FCapacity then
  begin
    ReallocMem(FCodeInfoList, NewCapacity * SizeOf(LongInt));
    FCapacity := NewCapacity;
  end;
end; { SetCapacity }

procedure TmwPasCodeInfoList.SetCount(NewCount: Integer);
begin
  if NewCount > FCapacity then SetCapacity(NewCount);
  FCount := NewCount;
end; { SetCount }

procedure TmwPasCodeInfoList.SetItems(Index: Integer; Item: TmwPasCodeInfo);
begin
  FCodeInfoList[Index] := Item;
end; { SetItems }

function TmwPasCodeInfoList.Add(Item: TmwPasCodeInfo): Integer;
begin
  Result := FCount;
  if FCapacity = Result then
  begin
    if fCapacity < 4 then SetCapacity(FCapacity + 1) else
      if fCapacity < 10 then SetCapacity(FCapacity + 3) else
        if fCapacity < 30 then SetCapacity(FCapacity + 10) else
          if fCapacity < 100 then SetCapacity(FCapacity + 30) else SetCapacity(FCapacity + 256)
  end;
  FCodeInfoList[Result] := Item;
  Inc(FCount);
end; { Add }

procedure TmwPasCodeInfoList.Clear;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do FCodeInfoList[I].Free;
  SetCount(0);
  SetCapacity(0);
end; { Clear }

procedure TmwPasCodeInfoList.Delete(Index: Integer);
begin
  Dec(FCount);
  if Index < FCount then
  begin
    FCodeInfoList[Index].Free;
    System.Move(FCodeInfoList[Index + 1], FCodeInfoList[Index],
      (FCount - Index) * SizeOf(LongInt));
  end;
end; { Delete }

procedure TmwPasCodeInfoList.Exchange(Index1, Index2: Integer);
var
  Item: TmwPasCodeInfo;
begin
  Item := FCodeInfoList[Index1];
  FCodeInfoList[Index1] := FCodeInfoList[Index2];
  FCodeInfoList[Index2] := Item;
end; { Exchange }

function TmwPasCodeInfoList.First: TmwPasCodeInfo;
begin
  Result := GetItems(0);
end; { First }

function TmwPasCodeInfoList.IndexOf(Item: TmwPasCodeInfo): Integer;
begin
  Result := 0;
  while (Result < FCount) and (FCodeInfoList[Result] <> Item) do Inc(Result);
  if Result = FCount then Result := -1;
end; { IndexOf }

function TmwPasCodeInfoList.IndexOfName(aName: String): Integer;
begin
  Result := 0;
  while (Result < FCount) and (CompareText(FCodeInfoList[Result].Name, aName) <> 0) do Inc(Result);
  if Result = FCount then Result := -1;
end; { IndexOfName }

procedure TmwPasCodeInfoList.Insert(Index: Integer; Item: TmwPasCodeInfo);
begin
  if FCount = FCapacity then SetCapacity(FCapacity + 1024);
  if Index < FCount then
    System.Move(FCodeInfoList[Index], FCodeInfoList[Index + 1],
      (FCount - Index) * SizeOf(LongInt));
  FCodeInfoList[Index] := Item;
  Inc(FCount);
end; { Insert }

function TmwPasCodeInfoList.Last: TmwPasCodeInfo;
begin
  Result := GetItems(FCount - 1);
end; { Last }

procedure TmwPasCodeInfoList.Move(CurIndex, NewIndex: Integer);
var
  Item: TmwPasCodeInfo;
begin
  if CurIndex <> NewIndex then
  begin
    Item := GetItems(CurIndex);
    Dec(FCount);
    if CurIndex < FCount then
    begin
      System.Move(FCodeInfoList[CurIndex + 1], FCodeInfoList[CurIndex],
        (FCount - CurIndex) * SizeOf(LongInt));
    end;
    Insert(NewIndex, Item);
  end;
end; { Move }

function TmwPasCodeInfoList.Remove(Item: TmwPasCodeInfo): Integer;
begin
  Result := IndexOf(Item);
  if Result <> -1 then Delete(Result);
end; { Remove }

procedure TmwPasCodeInfoList.Assign(Source: TPersistent);
var
  I: Integer;
begin
  if Source is TmwPasCodeInfo then
  begin
    try
      Clear;
      for I := 0 to TmwPasCodeInfoList(Source).Count - 1 do
        Add(TmwPasCodeInfoList(Source)[I]);
    finally
    end;
    Exit;
  end;
  inherited Assign(Source);
end;

{ TmwPasCodeInfo }

procedure TmwPasCodeInfo.Assign(Source: TPersistent);
begin
  if Source is TmwPasCodeInfo then
  begin
    BelongsTo := TmwPasCodeInfo(Source).BelongsTo;
    EndPos := TmwPasCodeInfo(Source).EndPos;
    Infos := TmwPasCodeInfo(Source).Infos;
    InfoType := TmwPasCodeInfo(Source).InfoType;
    Name := TmwPasCodeInfo(Source).Name;
    StartPos := TmwPasCodeInfo(Source).StartPos;
    Exit;
  end;
  inherited Assign(Source);
end;

constructor TmwPasCodeInfo.Create;
begin
  inherited Create;
  fInfos := TmwPasCodeInfoList.Create;
  fEndPos := -1;
  fInfoType := ciUnKnown;
  fName := '';
  fStartPos := -1;
end;

destructor TmwPasCodeInfo.Destroy;
begin
  fInfos.Free;
  inherited Destroy;
end;

procedure TmwPasCodeInfo.SetInfos(const Value: TmwPasCodeInfoList);
begin
  fInfos.Assign(Value);
end;

{ TmwPasUnitInfo }

constructor TmwPasUnitInfo.Create(UnitName: string;
  SourceStream: TMemoryStream; OwnS: Boolean);
begin
  inherited Create;
  fInfoStack := TmwPasCodeInfoStack.Create;
  fInfoStack.Add(Self);
  fImplementationsLine := -1;
  fInterfaceLine := -1;
  Name := UnitName;
  fOwnStream := OwnS;
  fParsed := False;
  fSecondUsesLine := -1;
  fSecondUsesList := TStringList.Create;
  fUsesLine := -1;
  fUsesList := TStringList.Create;
end;

destructor TmwPasUnitInfo.Destroy;
begin
  fSecondUsesList.Free;
  fUsesList.Free;
  fInfoStack.Free;
  if fStream <> nil then
    if fOwnStream then fStream.Free;
  inherited Destroy;
end;

procedure TmwPasUnitInfo.SetParsed(const Value: Boolean);
begin
  fParsed := Value;
 { if Value then
    if fOwnStream then
    begin
      fStream.Free;
      fStream := nil;
    end; }
end;

procedure TmwPasUnitInfo.SetSecondUsesList(const Value: TStrings);
begin
  fSecondUsesList.Assign(Value);
end;

procedure TmwPasUnitInfo.SetUsesList(const Value: TStrings);
begin
  fUsesList.Assign(Value);
end;

end.

