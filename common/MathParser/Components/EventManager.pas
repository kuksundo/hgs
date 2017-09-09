{ *********************************************************************** }
{                                                                         }
{ EventManager                                                            }
{                                                                         }
{ Copyright (c) 2007 Pisarev Yuriy (post@pisarev.net)                     }
{                                                                         }
{ *********************************************************************** }

unit EventManager;

{$B-}

interface

uses
  SysUtils, Classes, EventUtils, NotifyManager, Parser, ParseTypes, ValueTypes;

type
  TCustomEventManager = class(TNotifyControl)
  protected
    function GetConnected: Boolean; virtual; abstract;
    function GetEventManager: TCustomEventManager; virtual; abstract;
    function GetFunctionName: string; virtual; abstract;
    function GetNotifyManager: TNotifyManager; virtual; abstract;
    function GetParser: TParser; virtual; abstract;
    function GetPriority: Integer; virtual; abstract;
    procedure SetEventManager(const Value: TCustomEventManager); virtual; abstract;
    procedure SetFunctionName(const Value: string); virtual; abstract;
    procedure SetNotifyManager(const Value: TNotifyManager); virtual; abstract;
    procedure SetParser(const Value: TParser); virtual; abstract;
    procedure SetPriority(const Value: Integer); virtual; abstract;
    procedure Connect; virtual; abstract;
    procedure Suspend; virtual; abstract;
    procedure Disconnect; virtual; abstract;
    procedure Reset(AEventManager: TCustomEventManager = nil;
      AParser: TParser = nil); virtual; abstract;
  public
    function Add(var Handle: Integer; const Name: string; const Priority: Integer;
      const Event: TFunctionEvent): Boolean; virtual; abstract;
    procedure Clear; virtual; abstract;
    function Delete(Index: Integer): Boolean; virtual; abstract;
    function FindParser: TParser; virtual; abstract;
    function IndexOf(const AName: string): Integer; virtual; abstract;
    property NotifyManager: TNotifyManager read GetNotifyManager write SetNotifyManager;
    property Connected: Boolean read GetConnected;
  published
    property EventManager: TCustomEventManager read GetEventManager write SetEventManager;
    property Parser: TParser read GetParser write SetParser;
    property FunctionName: string read GetFunctionName write SetFunctionName;
    property Priority: Integer read GetPriority write SetPriority;
  end;

  TEventManager = class(TCustomEventManager)
  private
    FConnected: Boolean;
    FEventData: TEventData;
    FEventManager: TCustomEventManager;
    FFunctionEvent: TFunctionEvent;
    FFunctionHandle: Integer;
    FFunctionName: string;
    FNotifyManager: TNotifyManager;
    FParser: TParser;
    FPriority: Integer;
  protected
    procedure Notification(Component: TComponent; Operation: TOperation); override;
    function GetConnected: Boolean; override;
    function GetEventManager: TCustomEventManager; override;
    function GetFunctionName: string; override;
    function GetNotifyManager: TNotifyManager; override;
    function GetParser: TParser; override;
    function GetPriority: Integer; override;
    procedure SetEventManager(const Value: TCustomEventManager); override;
    procedure SetFunctionName(const Value: string); override;
    procedure SetName(const NewName: TComponentName); override;
    procedure SetNotifyManager(const Value: TNotifyManager); override;
    procedure SetParser(const Value: TParser); override;
    procedure SetPriority(const Value: Integer); override;
    procedure Connect; override;
    procedure Suspend; override;
    procedure Disconnect; override;
    procedure Reset(AEventManager: TCustomEventManager = nil; AParser: TParser = nil); override;
    function DoEvent(Event: TFunctionEvent; AFunction: PFunction; AType: PType;
      out Value: TValue; LValue, RValue: TValue;
      ParameterArray: TParameterArray): Boolean; virtual;
    function Custom(const AFunction: PFunction; const AType: PType;
      out Value: TValue; const LValue, RValue: TValue;
      const ParameterArray: TParameterArray): Boolean; virtual;
    property FunctionEvent: TFunctionEvent read FFunctionEvent write FFunctionEvent;
    property FunctionHandle: Integer read FFunctionHandle write FFunctionHandle;
    property EventData: TEventData read FEventData write FEventData;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Notify(NotifyType: TNotifyType; Component: TComponent); override;
    function Add(var Index: Integer; const Name: string; const Priority: Integer;
      const Event: TFunctionEvent): Boolean; override;
    procedure Clear; override;
    function Delete(Index: Integer): Boolean; override;
    function FindParser: TParser; override;
    function IndexOf(const AName: string): Integer; override;
  end;

procedure Register;

implementation

uses
  MemoryUtils, TextUtils;

procedure Register;
begin
  RegisterComponents('Samples', [TEventManager]);
end;

{ TEventManager }

function TEventManager.Add(var Index: Integer; const Name: string;
  const Priority: Integer; const Event: TFunctionEvent): Boolean;
begin
  Result := (Name <> '') and (IndexOf(Name) < 0);
  if Result then
    Index := EventUtils.Add(FEventData, MakeEvent(Index, Name, Priority, Event))
  else Index := -1;
end;

procedure TEventManager.Clear;
begin
  FEventData.Events := nil;
end;

procedure TEventManager.Connect;
begin
  FConnected := Assigned(FParser);
  if FConnected then FFunctionEvent := FParser.Connect(Custom, Self)
  else if Assigned(FEventManager) then
  begin
    FConnected := FEventManager.FindParser <> nil;
    FEventManager.NotifyManager.Add(Self);
    FEventManager.Add(FFunctionHandle, FFunctionName, FPriority, Custom);
  end;
  if FConnected then FNotifyManager.Notify(ntConnect, Self);
end;

constructor TEventManager.Create(AOwner: TComponent);
begin
  inherited;
  FNotifyManager := TNotifyManager.Create(Self);
  FFunctionName := CreateGuid;
end;

function TEventManager.Custom(const AFunction: PFunction; const AType: PType;
  out Value: TValue; const LValue, RValue: TValue;
  const ParameterArray: TParameterArray): Boolean;
var
  I: Integer;
begin
  SortEvents(FEventData);
  for I := Low(FEventData.Events) to High(FEventData.Events) do
  begin
    Result := DoEvent(FEventData.Events[I].Event, AFunction, AType, Value, LValue, RValue, ParameterArray);
    if Result then Exit;
  end;
  Result := DoEvent(FFunctionEvent, AFunction, AType, Value, LValue, RValue, ParameterArray);
end;

function TEventManager.Delete(Index: Integer): Boolean;
var
  I: Integer;
begin
  I := Length(FEventData.Events);
  Result := MemoryUtils.Delete(FEventData.Events, Index * SizeOf(TEvent),
    SizeOf(TEvent), I * SizeOf(TEvent));
  if Result then SetLength(FEventData.Events, I - 1);
end;

destructor TEventManager.Destroy;
begin
  Reset;
  FNotifyManager.Notify(ntDisconnect, Self);
  Clear;
  inherited;
end;

procedure TEventManager.Disconnect;
begin
  Suspend;
  if Available(FParser) then FParser.NotifyControl := nil
  else FParser := nil;
  if Available(FEventManager) then FEventManager.NotifyManager.Delete(Self)
  else FEventManager := nil;
end;

function TEventManager.DoEvent(Event: TFunctionEvent; AFunction: PFunction;
  AType: PType; out Value: TValue; LValue, RValue: TValue;
  ParameterArray: TParameterArray): Boolean;
begin
  Result := Assigned(Event) and
    Event(AFunction, AType, Value, LValue, RValue, ParameterArray);
end;

function TEventManager.FindParser: TParser;
var
  AEventManager: TCustomEventManager;
begin
  Result := FParser;
  if not Assigned(Result) then
  begin
    AEventManager := FEventManager;
    while Assigned(AEventManager) and not Assigned(Result) do
    begin
      Result := AEventManager.Parser;
      AEventManager := AEventManager.EventManager;
    end;
  end;
end;

function TEventManager.GetConnected: Boolean;
begin
  Result := FConnected;
end;

function TEventManager.GetEventManager: TCustomEventManager;
begin
  Result := FEventManager;
end;

function TEventManager.GetFunctionName: string;
begin
  Result := FFunctionName;
end;

function TEventManager.GetNotifyManager: TNotifyManager;
begin
  Result := FNotifyManager;
end;

function TEventManager.GetParser: TParser;
begin
  Result := FParser;
end;

function TEventManager.GetPriority: Integer;
begin
  Result := FPriority;
end;

function TEventManager.IndexOf(const AName: string): Integer;
var
  I: Integer;
begin
  for I := Low(FEventData.Events) to High(FEventData.Events) do
    if TextUtils.SameText(AName, FEventData.Events[I].Name) then
    begin
      Result := I;
      Exit;
    end;
  Result := -1;
end;

procedure TEventManager.Notification(Component: TComponent; Operation: TOperation);
begin
  inherited;
  if ((Component = FParser) or (Component = FEventManager)) and
    (Operation = opRemove) then Reset;
end;

procedure TEventManager.Notify(NotifyType: TNotifyType; Component: TComponent);
begin
  inherited;
  case NotifyType of
    ntConnect: Connect;
    ntSuspend: Suspend;
    ntDisconnect: Reset;
  else NotifyManager.Notify(NotifyType, Component);
  end;
end;

procedure TEventManager.Reset(AEventManager: TCustomEventManager;
  AParser: TParser);
begin
  Disconnect;
  FEventManager := AEventManager;
  FParser := AParser;
end;

procedure TEventManager.SetEventManager(const Value: TCustomEventManager);
begin
  if (Value <> FEventManager) and (Value <> Self) then
  begin
    Reset(Value);
    Connect;
  end;
end;

procedure TEventManager.SetFunctionName(const Value: string);
begin
  FFunctionName := Value;
end;

procedure TEventManager.SetName(const NewName: TComponentName);
begin
  if TextUtils.SameText(Name, FFunctionName) then FFunctionName := NewName;
  inherited;
end;

procedure TEventManager.SetNotifyManager(const Value: TNotifyManager);
begin
  FNotifyManager := Value;
end;

procedure TEventManager.SetParser(const Value: TParser);
begin
  if Value <> FParser then
  begin
    Reset(nil, Value);
    if Assigned(FParser) and Assigned(FParser.NotifyControl) then
      TEventManager(FParser.NotifyControl).Parser := nil;
    Connect;
  end;
end;

procedure TEventManager.SetPriority(const Value: Integer);
begin
  FPriority := Value;
end;

procedure TEventManager.Suspend;
begin
  if Available(FParser) then
  begin
    if Available(FParser) then FParser.BeforeFunction := FFunctionEvent;
    FNotifyManager.Notify(ntSuspend, Self);
  end;
  FFunctionEvent := nil;
  if Available(FEventManager) then
  begin
    if Available(FEventManager) then FEventManager.Delete(FFunctionHandle);
    FNotifyManager.Notify(ntSuspend, Self);
  end;
  FConnected := False;
end;

end.
