{ *********************************************************************** }
{                                                                         }
{ ParseCache                                                              }
{                                                                         }
{ Copyright (c) 2007 Pisarev Yuriy (post@pisarev.net)                     }
{                                                                         }
{ *********************************************************************** }

unit ParseCache;

{$B-}
{$I Directives.inc}

interface

uses
  Windows, Messages, Classes, SysUtils, FlexibleList, NotifyManager, ParseTypes,
  TextConsts, TextList, ValueTypes, VariableUtils;

const
  DefaultEnabled = True;
  DefaultCacheType = ltHash;
  DefaultCountToCache = 500;
  LiteMinCountToCache = 10;
  LiteMaxCountToCache = 10000;
  DefaultSmartCache = True;

type
  PCacheData = ^TCacheData;
  TCacheData = record
    Script: TScript;
  end;

  TLiteCache = class(TNotifyControl)
  private
    FSmartCache: Boolean;
    FEnabled: Boolean;
    FCheck: Boolean;
    FIndex: Integer;
    FCountToCache: Integer;
    FCapacityFormula: string;
    FUsageCountVariableName: string;
    FMaxCountToCacheVariableName: string;
    FCountToCacheVariableName: string;
    FMatchCountVariableName: string;
    FMinCountToCacheVariableName: string;
    FRestrictFormula: string;
    FList: TFlexibleList;
    FWindowHandle: THandle;
    FEventManager: TObject;
    FCapacityScript: TScript;
    FRestrictScript: TScript;
    FScriptType: TScriptType;
    FUsageCount: TValue;
    FMatchCount: TValue;
    FMaxCount: TValue;
    FMinCount: TValue;
    FVariable: TVariableArray;
    function GetCacheData(Index: Integer): PCacheData;
    function GetCacheType: TListType;
    function GetMaxCountToCache: Integer;
    function GetMinCountToCache: Integer;
    {$IFDEF DELPHI_7}
    function GetNameValueSeparator: Char;
    {$ENDIF}
    procedure SetCacheType(const Value: TListType);
    procedure SetCapacityFormula(const Value: string);
    procedure SetMaxCountToCache(const Value: Integer);
    procedure SetMinCountToCache(const Value: Integer);
    {$IFDEF DELPHI_7}
    procedure SetNameValueSeparator(const Value: Char);
    {$ENDIF}
    procedure SetRestrictFormula(const Value: string);
    procedure SetSmartCache(const Value: Boolean);
  protected
    procedure SetName(const NewName: TComponentName); override;
    procedure WindowMethod(var Message: TMessage); virtual;
    procedure Connect; virtual;
    procedure Disconnect; virtual;
    function Cacheable(const Text: string): Boolean; virtual;
    function Next: Integer; virtual;
    function Compile: Boolean; virtual;
    procedure Modify; virtual;
    function Resizable(const Parser: TObject): Boolean; virtual;
    property WindowHandle: THandle read FWindowHandle write FWindowHandle;
    property List: TFlexibleList read FList write FList;
    property Index: Integer read FIndex write FIndex;
    property Check: Boolean read FCheck write FCheck;
    property MatchCount: TValue read FMatchCount write FMatchCount;
    property UsageCount: TValue read FUsageCount write FUsageCount;
    property MinCount: TValue read FMinCount write FMinCount;
    property MaxCount: TValue read FMaxCount write FMaxCount;
    property CapacityScript: TScript read FCapacityScript write FCapacityScript;
    property RestrictScript: TScript read FRestrictScript write FRestrictScript;
    property Variable: TVariableArray read FVariable write FVariable;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Notify(NotifyType: TNotifyType; Component: TComponent); override;
    procedure Add(const Text: string; const Script: TScript); virtual;
    procedure Clear; virtual;
    function Find(const Text: string): TScript; virtual;
    function FindParser: TComponent; overload; virtual;
    function FindParser(out Parser: TComponent): Boolean; overload; virtual;
    procedure Setup; virtual;
    property EventManager: TObject read FEventManager write FEventManager;
    property ScriptType: TScriptType read FScriptType write FScriptType;
    property MatchCountVariableName: string read FMatchCountVariableName;
    property UsageCountVariableName: string read FUsageCountVariableName;
    property MinCountToCacheVariableName: string read FMinCountToCacheVariableName;
    property MaxCountToCacheVariableName: string read FMaxCountToCacheVariableName;
    property CountToCacheVariableName: string read FCountToCacheVariableName;
    {$IFDEF DELPHI_7}
    property NameValueSeparator: Char read GetNameValueSeparator
      write SetNameValueSeparator;
    {$ENDIF}
    property Data[Index: Integer]: PCacheData read GetCacheData;
  published
    property Enabled: Boolean read FEnabled write FEnabled
      default DefaultEnabled;
    property CacheType: TListType read GetCacheType write SetCacheType
      default DefaultCacheType;
    property CountToCache: Integer read FCountToCache write FCountToCache
      default DefaultCountToCache;
    property MinCountToCache: Integer read GetMinCountToCache
      write SetMinCountToCache default LiteMinCountToCache;
    property MaxCountToCache: Integer read GetMaxCountToCache
      write SetMaxCountToCache default LiteMaxCountToCache;
    property SmartCache: Boolean read FSmartCache write SetSmartCache
      default DefaultSmartCache;
    property CapacityFormula: string read FCapacityFormula write SetCapacityFormula;
    property RestrictFormula: string read FRestrictFormula write SetRestrictFormula;
  end;

const
  HardMinCountToCache = 10;
  HardMaxCountToCache = 1000;

type
  THardCache = class(TLiteCache)
  private
    FParser: TComponent;
  protected
    property Parser: TComponent read FParser write FParser;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Add(const Text: string; const Script: TScript); override;
    function Find(const Text: string): TScript; override;
  published
    property MinCountToCache default HardMinCountToCache;
    property MaxCountToCache default HardMaxCountToCache;
  end;

const
  DefaultScriptType = stScript;

type
  TParseCache = class(TComponent)
  private
    FLock: PRTLCriticalSection;
    FHardCache: THardCache;
    FLiteCache: TLiteCache;
    FScriptType: TScriptType;
    procedure SetScriptType(const Value: TScriptType);
  protected
    procedure SetName(const NewName: TComponentName); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Add(const Text: string; const Script: TScript); virtual;
    procedure Clear; virtual;
    procedure WriteScriptType; virtual;
    function Find(const Text: string): TScript; virtual;
    property Lock: PRTLCriticalSection read FLock write FLock;
  published
    property ScriptType: TScriptType read FScriptType write SetScriptType
      default DefaultScriptType;
    property LiteCache: TLiteCache read FLiteCache;
    property HardCache: THardCache read FHardCache;
  end;

const
  InternalLiteCacheName = 'LiteCache';
  InternalHardCacheName = 'HardCache';

  UnknownName = 'Unknown';
  DefaultMatchCountName = '%s.%s.MatchCount';
  DefaultUsageCountName = '%s.%s.UsageCount';
  DefaultMinCountToCacheName = '%s.%s.MinCountToCache';
  DefaultMaxCountToCacheName = '%s.%s.MaxCountToCache';
  DefaultCountToCacheName = '%s.%s.CountToCache';

  DefaultCapacityFormula = '%s / %s * %s';
  DefaultRestrictFormula = '(%0:s / %1:s < 1 / 4) or (%0:s / %1:s > 3 / 4)';

function MakeData(const Script: TScript): PCacheData;

implementation

uses
  EventManager, Math, ParseConsts, ParseErrors, ParseMessages, Parser, ParseUtils,
  TextBuilder, ValueConsts, ValueUtils;

function MakeData(const Script: TScript): PCacheData;
begin
  New(Result);
  Result.Script := Script;
end;

{ TParseCache }

procedure TLiteCache.Add(const Text: string; const Script: TScript);
var
  I: Integer;
begin
  if FEnabled and Cacheable(Text) and (FList.List.IndexOf(Text) < 0) then
  begin
    FList.List.BeginUpdate;
    try
      if FList.List.Count < FCountToCache then
        FList.List.AddObject(Text, TObject(MakeData(Copy(Script))))
      else begin
        I := Next;
        Data[I].Script := Copy(Script);
        FList.List[I] := Text;
      end;
    finally
      FList.List.EndUpdate;
    end;
  end;
end;

function TLiteCache.Cacheable(const Text: string): Boolean;
begin
  Result := (FCheck and (Length(Text) <= FieldData[ftAText].Size) or not FCheck) and
    (Pos({$IFDEF DELPHI_7}List.NameValueSeparator{$ELSE}Equal{$ENDIF}, Text) = 0);
end;

procedure TLiteCache.Clear;
var
  I: Integer;
begin
  with FList do
  begin
    for I := 0 to List.Count - 1 do
      if Assigned(List.Objects[I]) then Dispose(PCacheData(List.Objects[I]));
    List.Clear;
  end;
  FMatchCount.Signed32 := 0;
  FUsageCount.Signed32 := 0;
end;

function TLiteCache.Compile: Boolean;
var
  Parser: TParser;
  I, J: Integer;
  AFunction: PFunction;
  AVariable: PFunctionVariable;
  Data: TVariableData;
begin
  Result := Assigned(FVariable) and FindParser(TComponent(Parser));
  if Result then
  try
    for I := Low(FVariable) to High(FVariable) do
    begin
      if not Assigned(Parser.FindFunction(FVariable[I].Name)) then
      begin
        with Parser do
        begin
          BeginUpdate;
          try
            for J := Low(FVariable) to High(FVariable) do
            begin
              AFunction := FindFunction(FVariable[J].Name);
              if Assigned(AFunction) then
              begin
                AVariable := @AFunction.Method.Variable;
                if (AVariable.VariableType <> vtValue) or (AVariable.AVariable <> FVariable[J].Variable) then
                begin
                  FSmartCache := False;
                  Exit;
                end;
              end
              else begin
                Data := VariableData(FVariable[J].Name, False, False, vtInteger);
                SendMessage(Parser.WindowHandle, WM_ADDVARIABLE, Integer(@Data),
                  Integer(FVariable[J].Variable));
                // AddVariable(FVariable[J].Name, FVariable[J].Variable^, False, False, vtInteger);
              end;
            end;
          finally
            EndUpdate;
          end;
        end;
        Break;
      end;
      if I = High(FVariable) then
        with Parser do
        begin
          StringToScript(FCapacityFormula, FCapacityScript);
          Optimize(FCapacityScript);
          StringToScript(FRestrictFormula, FRestrictScript);
          Optimize(FRestrictScript);
        end;
    end;
  except
    Result := False;
  end;
end;

procedure TLiteCache.Connect;
var
  AEventManager: TCustomEventManager;
begin
  AEventManager := TCustomEventManager(FEventManager);
  if Assigned(AEventManager) then AEventManager.NotifyManager.Add(Self);
end;

constructor TLiteCache.Create(AOwner: TComponent);
begin
  inherited;
  FWindowHandle := AllocateHWnd(WindowMethod);
  FList := TFlexibleList.Create(Self);
  FEventManager := TEventManager.Create(Self);
  FEnabled := DefaultEnabled;
  CacheType := DefaultCacheType;
  FCountToCache := DefaultCountToCache;
  SmartCache := DefaultSmartCache;
  AssignInteger(FMinCount, LiteMinCountToCache);
  AssignInteger(FMaxCount, LiteMaxCountToCache);
end;

destructor TLiteCache.Destroy;
begin
  Disconnect;
  Clear;
  FCapacityScript := nil;
  FRestrictScript := nil;
  FVariable := nil;
  DeallocateHWnd(FWindowHandle);
  inherited;
end;

procedure TLiteCache.Disconnect;
var
  AEventManager: TCustomEventManager;
begin
  AEventManager := TCustomEventManager(FEventManager);
  if Available(AEventManager) then AEventManager.NotifyManager.Delete(Self)
  else FEventManager := nil;
end;

function TLiteCache.Find(const Text: string): TScript;
var
  I: Integer;
  AData: PCacheData;
begin
  if FEnabled then
  begin
    I := FList.List.IndexOf(Text);
    if I < 0 then Result := nil
    else begin
      AData := Data[I];
      if Assigned(AData) then Result := Copy(AData.Script)
      else Result := nil;
      if FSmartCache then Inc(FMatchCount.Signed32);
    end;
    Setup;
  end
  else Result := nil;
end;

function TLiteCache.FindParser(out Parser: TComponent): Boolean;
begin
  Parser := FindParser;
  Result := Assigned(Parser);
end;

function TLiteCache.FindParser: TComponent;
begin
  Result := Owner;
  while Assigned(Result) and not (Result is TParser) do
    Result := Result.Owner;
end;

function TLiteCache.GetCacheData(Index: Integer): PCacheData;
begin
  Result := PCacheData(FList.List.Objects[Index]);
end;

function TLiteCache.GetCacheType: TListType;
begin
  Result := FList.ListType;
end;

function TLiteCache.GetMaxCountToCache: Integer;
begin
  Result := FMaxCount.Signed32;
end;

function TLiteCache.GetMinCountToCache: Integer;
begin
  Result := FMinCount.Signed32;
end;

{$IFDEF DELPHI_7}
function TLiteCache.GetNameValueSeparator: Char;
begin
  Result := FList.NameValueSeparator;
end;
{$ENDIF}

procedure TLiteCache.Modify;
begin
  PostMessage(FWindowHandle, WM_NOTIFY, 0, 0);
end;

function TLiteCache.Next: Integer;
begin
  if FIndex >= FList.List.Count then FIndex := 0;
  Inc(FIndex);
  Result := FIndex - 1;
end;

procedure TLiteCache.Notify(NotifyType: TNotifyType; Component: TComponent);
begin
  inherited;
  case NotifyType of
    ntCompile: FSmartCache := Compile;
    ntDisconnect: Disconnect;
  end;
end;

function TLiteCache.Resizable(const Parser: TObject): Boolean;
var
  AParser: TParser absolute Parser;
begin
  Result := Convert(AParser.Execute(FRestrictScript)^, vtInteger).Signed32 = AParser.TrueValue;
end;

procedure TLiteCache.SetCacheType(const Value: TListType);
begin
  FList.ListType := Value;
  FCheck := FList.List is TFastStringList;
end;

procedure TLiteCache.SetCapacityFormula(const Value: string);
begin
  FCapacityFormula := Value;
  Modify;
end;

procedure TLiteCache.SetMaxCountToCache(const Value: Integer);
begin
  AssignInteger(FMaxCount, Value);
end;

procedure TLiteCache.SetMinCountToCache(const Value: Integer);
begin
  AssignInteger(FMinCount, Value);
end;

procedure TLiteCache.SetName(const NewName: TComponentName);
var
  S: string;
begin
  inherited;
  if Assigned(Owner) and (Owner.Name <> '') then S := Owner.Name
  else S := UnknownName;
  FMatchCountVariableName := Format(DefaultMatchCountName, [S, Name]);
  FUsageCountVariableName := Format(DefaultUsageCountName, [S, Name]);
  FMinCountToCacheVariableName := Format(DefaultMinCountToCacheName, [S, Name]);
  FMaxCountToCacheVariableName := Format(DefaultMaxCountToCacheName, [S, Name]);
  FCountToCacheVariableName := Format(DefaultCountToCacheName, [S, Name]);
  FCapacityFormula := Format(DefaultCapacityFormula, [FMatchCountVariableName,
    FUsageCountVariableName, FMaxCountToCacheVariableName]);
  FRestrictFormula := Format(DefaultRestrictFormula, [FMatchCountVariableName,
    FUsageCountVariableName]);
  FVariable := nil;
  VariableUtils.Add(FVariable, FMatchCountVariableName, @FMatchCount);
  VariableUtils.Add(FVariable, FUsageCountVariableName, @FUsageCount);
  VariableUtils.Add(FVariable, FMinCountToCacheVariableName, @FMinCount);
  VariableUtils.Add(FVariable, FMaxCountToCacheVariableName, @FMaxCount);
  VariableUtils.Add(FVariable, FCountToCacheVariableName, @FCountToCache);
  FMatchCount := EmptyValue;
  FUsageCount := EmptyValue;
  FMatchCount.ValueType := vtInteger;
  FUsageCount.ValueType := vtInteger;
  Compile;
end;

{$IFDEF DELPHI_7}
procedure TLiteCache.SetNameValueSeparator(const Value: Char);
begin
  FList.NameValueSeparator := Value;
end;
{$ENDIF}

procedure TLiteCache.SetRestrictFormula(const Value: string);
begin
  FRestrictFormula := Value;
  Modify;
end;

procedure TLiteCache.SetSmartCache(const Value: Boolean);
var
  Parser: TParser;
begin
  FSmartCache := Value;
  if FSmartCache then
  begin
    FSmartCache := FindParser(TComponent(Parser));
    if FSmartCache then
    begin
      Parser.Connect(FEventManager);
      Connect;
    end;
  end;
end;

procedure TLiteCache.Setup;
var
  Parser: TParser;
begin
  if FEnabled and FSmartCache then
  begin
    FSmartCache := FindParser(TComponent(Parser));
    if FSmartCache and Assigned(FCapacityScript) then
    begin
      Inc(FUsageCount.Signed32);
      if (FUsageCount.Signed32 mod FCountToCache = 0) and Resizable(Parser) then
      begin
        FCountToCache := EnsureRange(Convert(Parser.Execute(FCapacityScript)^, vtInteger).Signed32,
          FMinCount.Signed32, FMaxCount.Signed32);
        FMatchCount.Signed32 := 0;
        FUsageCount.Signed32 := 0;
      end;
    end;
  end;
end;

procedure TLiteCache.WindowMethod(var Message: TMessage);
begin
  with Message do
    case Msg of
      WM_NOTIFY: Compile;
    else Result := DefWindowProc(FWindowHandle, Msg, WParam, LParam);
    end
end;

{ THardCache }

procedure THardCache.Add(const Text: string; const Script: TScript);
var
  AParser: TParser;
begin
  if Enabled and Assigned(FParser) then
  begin
    AParser := TParser(FParser);
    inherited Add(MakeTemplate(AParser, AParser.FData, Text, nil), Script);
  end;
end;

constructor THardCache.Create(AOwner: TComponent);
begin
  inherited;
  FParser := FindParser;
  AssignInteger(FMinCount, HardMinCountToCache);
  AssignInteger(FMaxCount, HardMaxCountToCache);
end;

function THardCache.Find(const Text: string): TScript;
var
  AParser: TParser;
  S: string;
  ValueArray: TValueArray;
  Index: Integer;
begin
  if not Enabled then Result := nil
  else
    if Assigned(FParser) then
    begin
      AParser := TParser(FParser);
      S := MakeTemplate(AParser, AParser.FData, Text, @ValueArray);
      try
        Result := inherited Find(S);
        if Assigned(Result) then
        begin
          Index := 0;
          WriteValue(Integer(Result), Index, ValueArray, ScriptType);
        end;
      finally
        ValueArray := nil;
      end;
    end;
end;

{ TParseCache }

procedure TParseCache.Add(const Text: string; const Script: TScript);
begin
  inherited;
  FLiteCache.Add(Text, Script);
  FHardCache.Add(Text, Script);
end;

procedure TParseCache.Clear;
begin
  FLiteCache.Clear;
  FHardCache.Clear;
end;

constructor TParseCache.Create(AOwner: TComponent);
begin
  inherited;
  New(FLock);
  InitializeCriticalSection(FLock^);
  FLiteCache := TLiteCache.Create(Self);
  FHardCache := THardCache.Create(Self);
  FScriptType := DefaultScriptType;
  WriteScriptType;
end;

destructor TParseCache.Destroy;
begin
  DeleteCriticalSection(FLock^);
  Dispose(FLock);
  inherited;
end;

function TParseCache.Find(const Text: string): TScript;
begin
  Result := FLiteCache.Find(Text);
  if not Assigned(Result) then Result := FHardCache.Find(Text);
end;

procedure TParseCache.SetName(const NewName: TComponentName);
begin
  inherited;
  with FLiteCache do
  begin
    Name := InternalLiteCacheName;
    SetSubComponent(True);
  end;
  with FHardCache do
  begin
    Name := InternalHardCacheName;
    SetSubComponent(True);
  end;
end;

procedure TParseCache.SetScriptType(const Value: TScriptType);
begin
  if FScriptType <> Value then
  begin
    FScriptType := Value;
    WriteScriptType;
  end;
end;

procedure TParseCache.WriteScriptType;
begin
  FLiteCache.ScriptType := FScriptType;
  FHardCache.ScriptType := FScriptType;
end;

end.
