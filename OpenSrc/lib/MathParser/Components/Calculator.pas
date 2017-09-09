{ *********************************************************************** }
{                                                                         }
{ Calculator                                                              }
{                                                                         }
{ Copyright (c) 2008 Pisarev Yuriy (post@pisarev.net)                     }
{                                                                         }
{ *********************************************************************** }

unit Calculator;

{$B-}

interface

uses
  Windows, SysUtils, Classes, Forms, Contnrs, DB, EventManager, NotifyManager,
  ParseManager, ParseValueList, ParseTypes, Parser, Thread, SyncThread,
  ValueTypes;

const
  DefaultThreadCacheSize = 0;
  DefaultThreadCount = 20;

type
  TCalcThread = class(TSyncThread)
  private
    FCount: Integer;
    FParseManager: TParseManager;
    FIndex: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    property ParseManager: TParseManager read FParseManager write FParseManager;
    property Index: Integer read FIndex write FIndex;
    property Count: Integer read FCount write FCount;
  end;

  PThreadItem = ^TThreadItem;
  TThreadItem = record
    Text: string;
    Value: TValue;
  end;
  TThreadDoneEvent = procedure(Thread: TSyncThread) of object;

  TCalculator = class;

  TThread = class(TNotifyControl)
  private
    FCacheSize: Integer;
    FOnThreadDone: TThreadDoneEvent;
    FOptimization: Boolean;
    FThreadCount: Integer;
    FStopTimeout: Integer;
    FCalculator: TCalculator;
    FEventManager: TCustomEventManager;
    FOnDone: TNotifyEvent;
    FTimer: TSyncTimer;
    FItemList: TList;
    FThreadList: TObjectList;
    FPriority: TThreadPriority;
    FStackSize: Integer;
    FActiveThreadCount: Integer;
    function GetFinished: Boolean;
    function GetItem(Index: Integer): PThreadItem;
    function GetItemCount: Integer;
    procedure SetCalculator(const Value: TCalculator);
    procedure SetEventManager(const Value: TCustomEventManager);
  protected
    procedure Notification(Component: TComponent; Operation: TOperation); override;
    procedure Connect; virtual;
    procedure Disconnect; virtual;
    procedure DoDone; virtual;
    procedure DoThreadDone(Thread: TSyncThread); virtual;
    procedure Work(Thread: TSyncThread); overload; virtual;
    procedure Done(Thread: TSyncThread); virtual;
    function Add(const Text: string): Integer; virtual;
    function AddThread: Integer; virtual;
    procedure SetupThread(Thread: TCalcThread); virtual;
    property ItemList: TList read FItemList write FItemList;
    property ThreadList: TObjectList read FThreadList write FThreadList;
  public
    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(AOwner: TComponent; ACalculator: TCalculator); reintroduce; overload; virtual;
    procedure Notify(NotifyType: TNotifyType; Component: TComponent); override;
    destructor Destroy; override;
    function AddText(const Text: string): Integer; overload; virtual;
    procedure BeginUpdate; virtual;
    procedure EndUpdate; virtual;
    procedure CheckThread(NotifyType: PNotifyType = nil); virtual;
    procedure Clear; virtual;
    function ShareCache: Boolean; virtual;
    function Execute: Boolean; overload; virtual;
    function WaitFor: Boolean; virtual;
    property Calculator: TCalculator read FCalculator write SetCalculator;
    property ActiveThreadCount: Integer read FActiveThreadCount;
    property Item[Index: Integer]: PThreadItem read GetItem;
    property ItemCount: Integer read GetItemCount;
    property Finished: Boolean read GetFinished;
  published
    property Timer: TSyncTimer read FTimer;
    property CacheSize: Integer read FCacheSize write FCacheSize
      default DefaultThreadCacheSize;
    property Optimization: Boolean read FOptimization write FOptimization
      default DefaultOptimization;
    property StackSize: Integer read FStackSize write FStackSize
      default DefaultStackSize;
    property Priority: TThreadPriority read FPriority write FPriority
      default DefaultPriority;
    property StopTimeout: Integer read FStopTimeout write FStopTimeout
      default DefaultStopTimeout;
    property ThreadCount: Integer read FThreadCount write FThreadCount
      default DefaultThreadCount;
    property EventManager: TCustomEventManager read FEventManager
      write SetEventManager;
    property OnThreadDone: TThreadDoneEvent read FOnThreadDone write FOnThreadDone;
    property OnDone: TNotifyEvent read FOnDone write FOnDone;
  end;

  TParseValueList = class(ParseValueList.TParseValueList);
  ECalculatorError = class(Exception);
  TValueEvent = procedure(const Index: Integer) of object;

  TCalculator = class(TComponent)
  private
    FEventManager: TEventManager;
    FParseManager: TParseManager;
    FParseValueList: TParseValueList;
    FCached: Boolean;
    FParser: TParser;
    FThread: TThread;
    FOnValue: TValueEvent;
    function GetCacheSize: Integer;
    function GetCount: Integer;
    function GetItemName(Index: Integer): string;
    function GetItemValue(const AName: string): string;
    function GetItemValueFromIndex(Index: Integer): string;
    function GetOptimizable(const AName: string): Boolean;
    function GetOptimizableFromIndex(Index: Integer): Boolean;
    procedure SetCacheSize(const Value: Integer);
    procedure SetItemValue(const AName, Value: string);
    procedure SetItemValueFromIndex(Index: Integer; const Value: string);
    procedure SetOptimizable(const AName: string; const Value: Boolean);
    procedure SetOptimizableFromIndex(Index: Integer; const Value: Boolean);
  protected
    function Error(const Message: string): Exception; overload; virtual;
    function Error(const Message: string; const Arguments: array of const): Exception; overload; virtual;
    function FindFunction(Index: Integer): PFunction; overload; virtual;
    function FindFunction(const AName: string): PFunction; overload; virtual;
    function FindFunction(Item: PItem): PFunction; overload; virtual;
    function FunctionByName(const AName: string): PFunction; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    procedure BeginUpdate; virtual;
    procedure EndUpdate; virtual;
    function AsValue(const Text: string): TValue; virtual;
    function AsByte(const Text: string): Byte; virtual;
    function AsShortint(const Text: string): Shortint; virtual;
    function AsWord(const Text: string): Word; virtual;
    function AsSmallint(const Text: string): Smallint; virtual;
    function AsLongword(const Text: string): Longword; virtual;
    function AsInteger(const Text: string): Integer; virtual;
    function AsInt64(const Text: string): Int64; virtual;
    function AsSingle(const Text: string): Single; virtual;
    function AsDouble(const Text: string): Double; virtual;
    function AsExtended(const Text: string): Extended; virtual;
    function AsBoolean(const Text: string): Boolean; virtual;
    function AsPointer(const Text: string): Pointer; virtual;
    function AsString(const Text: string): string; virtual;
    function CalcDataSet(const DataSet: TDataSet; const FormulaFieldName,
      OutputFieldName: string): Boolean; virtual;
    procedure AddStrings(Strings: TStrings); virtual;
    procedure CheckThread(NotifyType: PNotifyType = nil); virtual;
    procedure Clear; virtual;
    function Delete(const AName: string): Boolean; overload; virtual;
    function Delete(Index: Integer): Boolean; overload; virtual;
    function IndexOf(const AName: string): Integer; virtual;
    procedure LoadFromFile(const FileName: string); virtual;
    procedure SaveToFile(const FileName: string); virtual;
    property Count: Integer read GetCount;
    property ItemName[Index: Integer]: string read GetItemName;
    property ItemValue[const AName: string]: string read GetItemValue write SetItemValue;
    property ItemValueFromIndex[Index: Integer]: string read GetItemValueFromIndex
      write SetItemValueFromIndex;
    property Optimizable[const AName: string]: Boolean read GetOptimizable
      write SetOptimizable;
    property OptimizableFromIndex[Index: Integer]: Boolean read GetOptimizableFromIndex
      write SetOptimizableFromIndex;
  published
    property Parser: TParser read FParser;
    property EventManager: TEventManager read FEventManager;
    property ParseValueList: TParseValueList read FParseValueList;
    property ParseManager: TParseManager read FParseManager;
    property Thread: TThread read FThread;
    property CacheSize: Integer read GetCacheSize write SetCacheSize stored False;
    property OnValue: TValueEvent read FOnValue write FOnValue;
  end;

const
  OperationError = 'Cannot perform the operation while one or more threads are running';
  InternalParserName = 'Parser';
  InternalEventManagerName = 'EventManager';
  InternalParseValueListName = 'ValueList';
  InternalParseManagerName = 'ParseManager';
  InternalTimerName = 'Timer';
  InternalThreadName = 'Thread';
  ValueError = 'Value "%s" not found';
  ValueIndexError = 'Value with the index of "%d" does not exists';
  ValueNameError = 'Value with the name of "%s" does not exists';

procedure Register;

implementation

uses
  Math, ValueUtils;

procedure Register;
begin
  RegisterComponents('Samples', [TCalcThread, TCalculator]);
end;

{ TCalcThread }

constructor TCalcThread.Create(AOwner: TComponent);
begin
  inherited;
  FParseManager := TParseManager.Create(Self);
end;

{ TThread }

function TThread.Add(const Text: string): Integer;
var
  Data: PThreadItem;
begin
  New(Data);
  Result := FItemList.Add(Data);
  Data.Text := Text;
end;

function TThread.AddText(const Text: string): Integer;
begin
  CheckThread;
  Result := Add(Text);
end;

function TThread.AddThread: Integer;
var
  Thread: TCalcThread;
begin
  Thread := TCalcThread.Create(nil);
  Result := FThreadList.Add(Thread);
  Thread.Timer := FTimer;
  Thread.ParseManager.Parser := FCalculator.Parser;
  Thread.ParseManager.EventManager := FCalculator.EventManager;
  Thread.OnWork := Work;
  Thread.OnDone := Done;
end;

procedure TThread.BeginUpdate;
begin
  Inc(FActiveThreadCount);
end;

procedure TThread.CheckThread(NotifyType: PNotifyType);
begin
  if Available(FCalculator) then FCalculator.CheckThread;
end;

procedure TThread.Clear;
var
  I: Integer;
begin
  CheckThread;
  for I := 0 to FItemList.Count - 1 do
    if Assigned(FItemList[I]) then Dispose(FItemList[I]);
  FItemList.Clear;
end;

procedure TThread.Connect;
begin
  if Assigned(FEventManager) then FEventManager.NotifyManager.Add(Self);
end;

constructor TThread.Create(AOwner: TComponent);
begin
  inherited;
  FItemList := TList.Create;
  FThreadList := TObjectList.Create;
  FTimer := TSyncTimer.Create(Self);
  with FTimer do
  begin
    Name := InternalTimerName;
    SetSubComponent(True);
  end;
  FOptimization := DefaultOptimization;
  FStackSize := DefaultStackSize;
  FPriority := DefaultPriority;
  FStopTimeout := DefaultStopTimeout;
  FThreadCount := DefaultThreadCount;
  FCacheSize := DefaultThreadCacheSize;
end;

constructor TThread.Create(AOwner: TComponent; ACalculator: TCalculator);
begin
  Create(AOwner);
  FCalculator := ACalculator;
end;

destructor TThread.Destroy;
begin
  FThreadList.Free;
  FItemList.Free;
  inherited;
end;

procedure TThread.Disconnect;
begin
  if Available(FEventManager) then FEventManager.NotifyManager.Delete(Self)
  else FEventManager := nil;
end;

procedure TThread.DoDone;
begin
  if FThreadList.Count > FThreadCount then FThreadList.Count := FThreadCount;
  if Assigned(FOnDone) then FOnDone(Self);
end;

procedure TThread.Done(Thread: TSyncThread);
begin
  Dec(FActiveThreadCount);
  try
    DoThreadDone(Thread);
    if FActiveThreadCount = 0 then DoDone;
  finally
    Thread.RaiseFatalException;
  end;
end;

procedure TThread.DoThreadDone(Thread: TSyncThread);
begin
  if Assigned(FOnThreadDone) then FOnThreadDone(Thread);  
end;

procedure TThread.EndUpdate;
begin
  Dec(FActiveThreadCount);
end;

function TThread.Execute: Boolean;
var
  I, J, K, Count: Integer;
  Thread: TCalcThread;
begin
  CheckThread;
  Result := (FItemList.Count > 0) and (FThreadCount > 0) and Available(FCalculator) and
    (FCalculator.Parser.UpdateCount = 0);
  if Result then
  begin
    J := IfThen(FItemList.Count > FThreadCount, FThreadCount, FItemList.Count);
    FActiveThreadCount := J;
    Count := FItemList.Count div J;
    Dec(J);
    for I := 0 to J do
    begin
      if I < FThreadList.Count then Thread := TCalcThread(FThreadList[I])
      else Thread := TCalcThread(FThreadList[AddThread]);
      SetupThread(Thread);
      K := I * Count;
      Thread.Index := K;
      if I = J then Thread.Count := FItemList.Count - K
      else Thread.Count := Count;
      Thread.Start;
    end;
  end;
end;

function TThread.GetFinished: Boolean;
begin
  Result := FActiveThreadCount = 0;
end;

function TThread.GetItem(Index: Integer): PThreadItem;
begin
  Result := PThreadItem(FItemList[Index]);
end;

function TThread.GetItemCount: Integer;
begin
  Result := FItemList.Count;
end;

procedure TThread.Notification(Component: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
    if Component = FEventManager then
    begin
      Disconnect;
      FEventManager := nil;
    end;
end;

procedure TThread.Notify(NotifyType: TNotifyType; Component: TComponent);
begin
  inherited;
  CheckThread(@NotifyType);
end;

procedure TThread.SetCalculator(const Value: TCalculator);
begin
  CheckThread;
  FCalculator := Value;
end;

procedure TThread.SetEventManager(const Value: TCustomEventManager);
begin
  CheckThread;
  if Value <> FEventManager then
  begin
    Disconnect;
    FEventManager := Value;
    Connect;
  end;
end;

procedure TThread.SetupThread(Thread: TCalcThread);
begin
  Thread.FParseManager.MaxCount := FCacheSize;
  Thread.FParseManager.Optimization := FOptimization;
  Thread.StackSize := FStackSize;
  Thread.Priority := FPriority;
  Thread.StopTimeout := FStopTimeout;
end;

function TThread.ShareCache: Boolean;
var
  I, J: Integer;
  Thread: TCalcThread;
begin
  Result := (FThreadCount > 0) and Available(FCalculator) and (FCalculator.Parser.UpdateCount = 0);
  if Result then
    for I := 0 to FThreadCount - 1 do
    begin
      if I < FThreadList.Count then Thread := TCalcThread(FThreadList[I])
      else Thread := TCalcThread(FThreadList[AddThread]);
      with Thread.FParseManager do
      begin
        J := List.Count + FCalculator.FParseManager.List.Count;
        if MaxCount < J then MaxCount := J;
      end;
      FCalculator.ParseManager.AppendTo(Thread.ParseManager);
    end;
end;

function TThread.WaitFor: Boolean;
var
  I: Integer;
  Thread: TSyncThread;
begin
  Result := FActiveThreadCount > 0;
  if Result then
    for I := 0 to FThreadList.Count - 1 do
    begin
      Thread := TSyncThread(FThreadList[I]);
      while not Thread.Finished do Application.HandleMessage;
    end;
end;

procedure TThread.Work(Thread: TSyncThread);
var
  AThread: TCalcThread absolute Thread;
  I, J: Integer;
begin
  I := AThread.Index;
  J := AThread.Index + AThread.Count;
  while (I < J) and not AThread.Stopped and Available(FCalculator) do
  begin
    Item[I].Value := AThread.ParseManager.AsValue(Item[I].Text);
    Inc(I);
  end;
end;

{ TCalculator }

procedure TCalculator.AddStrings(Strings: TStrings);
begin
  with FParseValueList do
  begin
    Detach;
    List.AddStrings(Strings);
    Attach;
  end;
end;

function TCalculator.AsBoolean(const Text: string): Boolean;
begin
  Result := Boolean(AsByte(Text));
end;

function TCalculator.AsByte(const Text: string): Byte;
begin
  Result := Convert(AsValue(Text), vtByte).Unsigned8;
end;

function TCalculator.AsDouble(const Text: string): Double;
begin
  Result := Convert(AsValue(Text), vtDouble).Float64;
end;

function TCalculator.AsExtended(const Text: string): Extended;
begin
  Result := AsDouble(Text);
end;

function TCalculator.AsInt64(const Text: string): Int64;
begin
  Result := Convert(AsValue(Text), vtInt64).Signed64;
end;

function TCalculator.AsInteger(const Text: string): Integer;
begin
  Result := Convert(AsValue(Text), vtInteger).Signed32;
end;

function TCalculator.AsLongword(const Text: string): Longword;
begin
  Result := Convert(AsValue(Text), vtLongword).Unsigned32;
end;

function TCalculator.AsPointer(const Text: string): Pointer;
begin
  Result := Pointer(AsInteger(Text));
end;

function TCalculator.AsShortint(const Text: string): Shortint;
begin
  Result := Convert(AsValue(Text), vtShortint).Signed8;
end;

function TCalculator.AsSingle(const Text: string): Single;
begin
  Result := Convert(AsValue(Text), vtSingle).Float32;
end;

function TCalculator.AsSmallint(const Text: string): Smallint;
begin
  Result := Convert(AsValue(Text), vtSmallint).Signed16;
end;

function TCalculator.AsString(const Text: string): string;
begin
  Result := ValueToText(AsValue(Text));
end;

function TCalculator.AsValue(const Text: string): TValue;
begin
  if FThread.Finished then Result := FParseManager.AsValue(Text)
end;

function TCalculator.AsWord(const Text: string): Word;
begin
  Result := Convert(AsValue(Text), vtWord).Unsigned16;
end;

procedure TCalculator.BeginUpdate;
begin
  CheckThread;
  FParser.BeginUpdate;
end;

function TCalculator.CalcDataSet(const DataSet: TDataSet; const FormulaFieldName,
  OutputFieldName: string): Boolean;
var
  FormulaField, OutputField: TField;
  Bookmark: TBookmark;
begin
  Result := DataSet.Active and not DataSet.IsEmpty and (Thread.ActiveThreadCount = 0);
  if Result then
  begin
    FormulaField := DataSet.FieldByName(FormulaFieldName);
    OutputField := DataSet.FieldByName(OutputFieldName);
    DataSet.DisableControls;
    try
      Bookmark := DataSet.GetBookmark;
      try
        DataSet.First;
        while not DataSet.Eof do
        begin
          DataSet.Edit;
          OutputField.AsString := AsString(FormulaField.AsString);
          DataSet.Post;
          DataSet.Next;
        end;
        DataSet.GotoBookmark(Bookmark);
      finally
        DataSet.FreeBookmark(Bookmark);
      end;
    finally
      DataSet.EnableControls;
    end;
  end;
end;

procedure TCalculator.CheckThread(NotifyType: PNotifyType);
const
  NotifySet = [ntBeforeFunctionAdd, ntBeforeTypeAdd, ntBeforeFunctionDelete, ntBeforeTypeDelete];
begin
  if (FThread.FActiveThreadCount > 0) and
    (not Assigned(NotifyType) or (NotifyType^ in NotifySet)) then
      raise Error(OperationError);
end;

procedure TCalculator.Clear;
begin
  FParseValueList.Clear;
  FParseManager.Clear;
end;

constructor TCalculator.Create(AOwner: TComponent);
begin
  inherited;
  FParser := TMathParser.Create(Self);
  with FParser do
  begin
    Name := InternalParserName;
    SetSubComponent(True);
  end;
  FEventManager := TEventManager.Create(Self);
  with FEventManager do
  begin
    Name := InternalEventManagerName;
    SetSubComponent(True);
  end;
  FParser.Connect(FEventManager);
  FParseValueList := TParseValueList.Create(Self);
  FParseValueList.EventManager := FEventManager;
  with FParseValueList do
  begin
    Name := InternalParseValueListName;
    SetSubComponent(True);
  end;
  FParseManager := TParseManager.Create(Self);
  FParseManager.EventManager := FEventManager;
  FParseManager.Parser := FParser;
  with FParseManager do
  begin
    Name := InternalParseManagerName;
    SetSubComponent(True);
  end;
  FThread := TThread.Create(Self);
  FThread.EventManager := FEventManager;
  with FThread do
  begin
    Name := InternalThreadName;
    FCalculator := Self;
    SetSubComponent(True);
  end;
  FCached := True;
end;

function TCalculator.Delete(const AName: string): Boolean;
begin
  Result := Delete(IndexOf(AName));
end;

function TCalculator.Delete(Index: Integer): Boolean;
begin
  CheckThread;
  Result := (Index >= 0) and (Index < FParseValueList.List.Count);
  if Result then
  begin
    FParseValueList.List.BeginUpdate;
    try
      FParseValueList.Delete(Index);
      FParseValueList.List.Delete(Index);
    finally
      FParseValueList.List.EndUpdate;
    end;
  end;
end;

procedure TCalculator.EndUpdate;
begin
  FParser.EndUpdate;
  if FParser.UpdateCount = 0 then FParser.Notify(ntCompile, FParser);
end;

function TCalculator.Error(const Message: string): Exception;
begin
  Result := Error(Message, []);
end;

function TCalculator.Error(const Message: string;
  const Arguments: array of const): Exception;
begin
  Result := ECalculatorError.CreateFmt(Message, Arguments);
end;

function TCalculator.FindFunction(Item: PItem): PFunction;
begin
  if Assigned(Item) then
    if Item.FunctionHandle < 0 then
      Result := FParseValueList.Parser.FunctionByVariable[@Item.Item.Value]
    else Result := FParseValueList.Parser.FunctionByHandle[Item.FunctionHandle]
  else Result := nil;
end;

function TCalculator.FindFunction(Index: Integer): PFunction;
begin
  Result := FindFunction(PItem(FParseValueList.List.Objects[Index]));
end;

function TCalculator.FindFunction(const AName: string): PFunction;
begin
  Result := FindFunction(FParseValueList.Find(AName));
end;

function TCalculator.FunctionByName(const AName: string): PFunction;
begin
  Result := FindFunction(AName);
  if not Assigned(Result) then raise Error(ValueError, [AName]);
end;

function TCalculator.GetCacheSize: Integer;
begin
  Result := FParseManager.MaxCount;
end;

function TCalculator.GetCount: Integer;
begin
  Result := FParseValueList.List.Count;
end;

function TCalculator.GetItemName(Index: Integer): string;
begin
  Result := FParseValueList.List.Names[Index];
end;

function TCalculator.GetItemValue(const AName: string): string;
var
  Item: PItem;
begin
  Item := FParseValueList.Find(AName);
  if Assigned(Item) then Result := ValueToText(Item.Item.Value)
  else Result := '';
end;

function TCalculator.GetItemValueFromIndex(Index: Integer): string;
var
  Item: PItem;
begin
  Item := Pointer(FParseValueList.List.Objects[Index]);
  Result := ValueToText(Item.Item.Value);
end;

function TCalculator.GetOptimizable(const AName: string): Boolean;
begin
  Result := FunctionByName(AName).Optimizable;
end;

function TCalculator.GetOptimizableFromIndex(Index: Integer): Boolean;
var
  AFunction: PFunction;
begin
  AFunction := FindFunction(Index);
  if Assigned(AFunction) then Result := AFunction.Optimizable
  else raise Error(ValueIndexError, [Index]);
end;

function TCalculator.IndexOf(const AName: string): Integer;
begin
  Result := FParseValueList.IndexOf(AName);
end;

procedure TCalculator.LoadFromFile(const FileName: string);
begin
  CheckThread;
  FParseValueList.Detach;
  FParseValueList.List.LoadFromFile(FileName);
  FParseValueList.Attach;
end;

procedure TCalculator.SaveToFile(const FileName: string);
begin
  FParseValueList.List.SaveToFile(FileName);
end;

procedure TCalculator.SetCacheSize(const Value: Integer);
begin
  FParseManager.MaxCount := Value;
end;

procedure TCalculator.SetItemValue(const AName, Value: string);
begin
  CheckThread;
  FParseValueList.AssignValue(AName, Value);
end;

procedure TCalculator.SetItemValueFromIndex(Index: Integer; const Value: string);
begin
  CheckThread;
  FParseValueList.AssignValue(FParseValueList.List.Names[Index], Value);
end;

procedure TCalculator.SetOptimizable(const AName: string; const Value: Boolean);
var
  AFunction: PFunction;

  function Find: Boolean;
  begin
    AFunction := FindFunction(AName);
    Result := Assigned(AFunction);
  end;

begin
  CheckThread;
  if not Find then
  begin
    FParseValueList.AssignValue(AName, '');
    if not Find then raise Error(ValueNameError, [AName]);
  end;
  AFunction.Optimizable := Value;
end;

procedure TCalculator.SetOptimizableFromIndex(Index: Integer;
  const Value: Boolean);
var
  AFunction: PFunction;
begin
  CheckThread;
  AFunction := FindFunction(Index);
  if Assigned(AFunction) then AFunction.Optimizable := Value
  else raise Error(ValueIndexError, [Index]);
end;

end.
