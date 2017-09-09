{ *********************************************************************** }
{                                                                         }
{ ParseValueList                                                          }
{                                                                         }
{ Copyright (c) 2007 Pisarev Yuriy (post@pisarev.net)                     }
{                                                                         }
{ *********************************************************************** }

unit ParseValueList;

{$B-}
{$I Directives.inc}

interface

uses
  Windows, SysUtils, Classes, EventManager, FlexibleList, NotifyManager,
  ParseCommon, ParseConsts, Parser, ParseTypes, TextConsts, TextList, Types,
  ValueTypes;

const
  DefaultOptimization = True;
  DefaultRaiseError = True;

type
  EParseValueListError = class(Exception);

  PItem = ^TItem;
  TItem = record
    Item: TCommonItem;
    FunctionHandle: Integer;
  end;

  TParseValueList = class(TNotifyControl)
  private
    FOptimization: Boolean;
    FRaiseError: Boolean;
    FFunctionHandle: Integer;
    FPriority: Integer;
    FFunctionName: string;
    FEventManager: TCustomEventManager;
    FFlexibleList: TFlexibleList;
    FParser: TParser;
    FErrorValue: TValue;
    function GetList: TStrings;
    function GetListType: TListType;
    procedure SetEventManager(const Value: TCustomEventManager);
    procedure SetFlexibleList(const Value: TFlexibleList);
    procedure SetList(const Value: TStrings);
    procedure SetListType(const Value: TListType);
  protected
    procedure Loaded; override;
    procedure Notification(Component: TComponent; Operation: TOperation); override;
    procedure SetName(const NewName: TComponentName); override;
    function Error(const Message: string): Exception; overload; virtual;
    function Error(const Message: string; const Arguments: array of const): Exception; overload; virtual;
    function Recurse(FunctionHandle: Integer; const Script: TScript): Boolean; virtual;
    function Custom(const AFunction: PFunction; const AType: PType;
      out Value: TValue; const LValue, RValue: TValue;
      const ParameterArray: TParameterArray): Boolean; virtual;
    function Compile(Index: Integer): Boolean; overload; virtual;
    procedure Compile; overload; virtual;
    procedure Connect; virtual;
    procedure Delete(Index: Integer); virtual;
    procedure Disconnect; virtual;
    function FindFunction(Item: PItem): PFunction; overload; virtual;
    function FindFunction(Item: PItem; out AFunction: PFunction): Boolean; overload; virtual;
    function FindParser: Boolean; virtual;
    procedure Reset(AEventManager: TCustomEventManager = nil); virtual;
    procedure Suspend; virtual;
    property FunctionHandle: Integer read FFunctionHandle write FFunctionHandle;
  public
    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(AOwner: TComponent; AListType: TListType); reintroduce; overload; virtual;
    destructor Destroy; override;
    procedure Notify(NotifyType: TNotifyType; Component: TComponent); override;
    function AssignValue(const AName, Value: string; out Index: Integer): Boolean; overload; virtual;
    function AssignValue(const AName, Value: string): Integer; overload; virtual;
    procedure Clear; virtual;
    function Find(const AName: string; ItemName: PString = nil): PItem; virtual;
    function IndexOf(const AName: string; ItemName: PString = nil): Integer; virtual;
    function Attach: Boolean; virtual;
    procedure Detach; virtual;
    property Parser: TParser read FParser write FParser;
  published
    property FlexibleList: TFlexibleList read FFlexibleList write SetFlexibleList;
    property List: TStrings read GetList write SetList;
    property ListType: TListType read GetListType write SetListType stored False;
    property ErrorValue: TValue read FErrorValue write FErrorValue;
    property Optimization: Boolean read FOptimization write FOptimization
      default DefaultOptimization;
    property RaiseError: Boolean read FRaiseError write FRaiseError
      default DefaultRaiseError;
    property EventManager: TCustomEventManager read FEventManager write SetEventManager;
    property FunctionName: string read FFunctionName write FFunctionName;
    property Priority: Integer read FPriority write FPriority;
  end;

const
  InternalFlexibleListName = 'FlexibleList';
  RecurseError = 'Function "%s" recursively uses itself';

procedure Register;

implementation

uses
  EventUtils, MemoryUtils, ParseUtils, StrUtils, TextUtils, ValueConsts,
  ValueUtils;

procedure Register;
begin
  RegisterComponents('Samples', [TParseValueList]);
end;

{ TParseValueList }

function TParseValueList.AssignValue(const AName, Value: string;
  out Index: Integer): Boolean;
var
  S, ItemName: string;
  Item: PItem;
begin
  Result := Assigned(FParser);
  if Result then
  begin
    List.BeginUpdate;
    try
      if Trim(Value) = '' then S := ValueToText(EmptyValue)
      else S := Value;
      Index := ParseCommon.IndexOf(List, AName, True, @ItemName);
      if Index < 0 then
      begin
        Result := not Assigned(FParser.FindFunction(ItemName));
        if Result then
        begin
          FParser.BeginUpdate;
          try
            New(Item);
            try
              ZeroMemory(Item, SizeOf(TItem));
              if TryTextToValue(S, Item.Item.Value) then
              begin
                Result := FParser.AddVariable(ItemName, Item.Item.Value,
                  not AnsiStartsText(Lock, AName), True);
                Item.FunctionHandle := -1;
              end
              else
                Result := FParser.AddFunction(ItemName, Item.FunctionHandle,
                  fkHandle, FunctionMethod(False, False, 0),
                  not AnsiStartsText(Lock, AName), True);
              if Result then
              begin
                Index := List.Add(ItemName + {$IFDEF DELPHI_7}List.NameValueSeparator{$ELSE}Equal{$ENDIF} + S);
                List.Objects[Index] := Pointer(Item);
              end
              else Dispose(Item);
            except
              Dispose(Item);
            end;
          finally
            FParser.EndUpdate;
          end;
          if Result then Compile(Index);
        end;
      end
      else begin
        {$IFDEF DELPHI_7}
        List.ValueFromIndex[Index] := S;
        {$ELSE}
        SetValueFromIndex(List, Index, S);
        {$ENDIF}
        Result := Compile(Index);
      end;
    finally
      List.EndUpdate;
    end;
  end
  else Index := -1;
end;

function TParseValueList.AssignValue(const AName, Value: string): Integer;
begin
  if not AssignValue(AName, Value, Result) then Result := -1;  
end;

function TParseValueList.Attach: Boolean;
var
  Item: PItem;
  I: Integer;
  S: string;
begin
  Result := FindParser;
  if Result then
  begin
    FParser.BeginUpdate;
    try
      List.BeginUpdate;
      try
        Item := nil;
        for I := 0 to List.Count - 1 do
        begin
          if not Assigned(Item) then
          begin
            New(Item);
            ZeroMemory(Item, SizeOf(TItem));
          end;
          S := Trim(List.Names[I]);
          if FParser.AddFunction(S, Item.FunctionHandle, fkHandle, FunctionMethod(False, False, 0),
            not CutText(S, Lock), True, vtDouble) then
            begin
              List.Objects[I] := Pointer(Item);
              Item := nil;
            end;
          List[I] := S + {$IFDEF DELPHI_7}List.NameValueSeparator{$ELSE}Equal{$ENDIF} + Trim({$IFDEF DELPHI_7}List.ValueFromIndex[I]{$ELSE}GetValueFromIndex(List, I){$ENDIF});
        end;
      finally
        List.EndUpdate;
      end;
      if Assigned(Item) then Dispose(Item);
    finally
      FParser.EndUpdate;
    end;
    FParser.Notify(ntCompile, Self);
  end;
end;

procedure TParseValueList.Clear;
begin
  Detach;
  List.Clear;
end;

procedure TParseValueList.Compile;
var
  I: Integer;
begin
  if Assigned(FParser) then
  begin
    List.BeginUpdate;
    try
      for I := 0 to List.Count - 1 do Compile(I);
    finally
      List.EndUpdate;
    end;
  end;
end;

function TParseValueList.Compile(Index: Integer): Boolean;
var
  Item: PItem;
  AFunction: PFunction;
  S: string;
begin
  Result := Assigned(FParser);
  if Result then
  begin
    Item := Pointer(List.Objects[Index]);
    try
      Result := FindFunction(Item, AFunction);
      if Result then
      begin
        Item.Item.Script := nil;
        S := {$IFDEF DELPHI_7}List.ValueFromIndex[Index]{$ELSE}GetValueFromIndex(List, Index){$ENDIF};
        if TryTextToValue(S, Item.Item.Value) then MakeVariable(AFunction, @Item.Item.Value)
        else begin
          FParser.StringToScript(S, Item.Item.Script);
          if not ParseHelper.Optimizable(Item.Item.Script, FParser.FData^) then
            AFunction.Optimizable := False;
          if Recurse(AFunction.Handle^, Item.Item.Script) then
            if FRaiseError then raise Error(RecurseError, [List.Names[Index]])
            else ParseCommon.AssignValue(Item.Item, FErrorValue)
          else begin
            if FOptimization then FParser.Optimize(Item.Item.Script);
            if Optimal(Item.Item.Script, stScript) then
            begin
              ParseCommon.AssignValue(Item.Item, FParser.Execute(Item.Item.Script)^);
              MakeVariable(AFunction, @Item.Item.Value);
            end
            else begin
              MakeFunction(AFunction, @Item.FunctionHandle);
              Item.Item.ItemType := itScript;
            end;
          end;
        end;
      end;
    except
      ParseCommon.AssignValue(Item.Item, FErrorValue);
      {$IFDEF DELPHI_7}
      List.ValueFromIndex[Index] := ValueToText(FErrorValue);
      {$ELSE}
      SetValueFromIndex(List, Index, ValueToText(FErrorValue));
      {$ENDIF}
      if FRaiseError then raise;
    end;
  end;
end;

procedure TParseValueList.Connect;
begin
  if Assigned(FEventManager) then
  begin
    FEventManager.NotifyManager.Add(Self);
    FEventManager.Add(FFunctionHandle, FFunctionName, FPriority, Custom);
  end;
  Attach;
end;

constructor TParseValueList.Create(AOwner: TComponent);
begin
  inherited;
  FFlexibleList := TFlexibleList.Create(Self);
  with FFlexibleList do
  begin
    Name := InternalFlexibleListName;
    SetSubComponent(True);
  end;
  AssignDouble(FErrorValue, 0);
  FOptimization := DefaultOptimization;
  FRaiseError := DefaultRaiseError;
  if Name = '' then FFunctionName := CreateGuid;
end;

constructor TParseValueList.Create(AOwner: TComponent;
  AListType: TListType);
begin
  Create(AOwner);
end;

function TParseValueList.Custom(const AFunction: PFunction; const AType: PType;
  out Value: TValue; const LValue, RValue: TValue;
  const ParameterArray: TParameterArray): Boolean;
var
  I: Integer;
  Item: PItem;
begin
  if Assigned(FParser) then
  begin
    I := List.IndexOfName(AFunction.Name);
    if I < 0 then Item := nil
    else Item := Pointer(List.Objects[I]);
    Result := Assigned(Item);
    if Result then
      case Item.Item.ItemType of
        itNumber: Value := Item.Item.Value;
        itScript: Value := FParser.Execute(Item.Item.Script)^;
      else Value := EmptyValue;
      end;
  end
  else Result := False;
end;

procedure TParseValueList.Delete(Index: Integer);
var
  Item: PItem;
begin
  Item := Pointer(List.Objects[Index]);
  if Assigned(Item) then
  begin
    List.Objects[Index] := nil;
    if Available(FParser) then
      if Item.FunctionHandle < 0 then FParser.DeleteVariable(Item.Item.Value)
      else FParser.DeleteFunction(Item.FunctionHandle);
    Dispose(Item);
  end;
end;

destructor TParseValueList.Destroy;
begin
  Reset;
  inherited;
end;

procedure TParseValueList.Detach;
var
  I: Integer;
begin
  if Available(FParser) then FParser.BeginUpdate;
  try
    List.BeginUpdate;
    try
      for I := List.Count - 1 downto 0 do Delete(I);
    finally
      List.EndUpdate;
    end;
  finally
    if Available(FParser) then
    begin
      FParser.EndUpdate;
      FParser.Notify(ntCompile, Self);
    end;
  end;
end;

procedure TParseValueList.Disconnect;
begin
  Suspend;
  if Available(FEventManager) then FEventManager.NotifyManager.Delete(Self)
  else FEventManager := nil;
end;

function TParseValueList.Error(const Message: string): Exception;
begin
  Result := Error(Message, []);
end;

function TParseValueList.Error(const Message: string;
  const Arguments: array of const): Exception;
begin
  Result := EParseValueListError.CreateFmt(Message, Arguments);
end;

function TParseValueList.Find(const AName: string; ItemName: PString): PItem;
var
  I: Integer;
begin
  I := IndexOf(AName, ItemName);
  if I < 0 then Result := nil
  else Result := Pointer(List.Objects[I]);
end;

function TParseValueList.FindFunction(Item: PItem): PFunction;
begin
  if not FindFunction(Item, Result) then Result := nil;
end;

function TParseValueList.FindFunction(Item: PItem; out AFunction: PFunction): Boolean;
begin
  if Assigned(Item) then
    if Item.FunctionHandle < 0 then AFunction := FParser.FunctionByVariable[@Item.Item.Value]
    else AFunction := FParser.FunctionByHandle[Item.FunctionHandle]
  else AFunction := nil;
  Result := Assigned(AFunction);
end;

function TParseValueList.FindParser: Boolean;
begin
  Result := Assigned(FParser);
  if not Result then
  begin
    if Assigned(FEventManager) then FParser := FEventManager.FindParser
    else FParser := nil;
    Result := Assigned(FParser);
  end;
end;

function TParseValueList.GetList: TStrings;
begin
  Result := FFlexibleList.List;
end;

function TParseValueList.GetListType: TListType;
begin
  Result := FFlexibleList.ListType;
end;

function TParseValueList.IndexOf(const AName: string; ItemName: PString): Integer;
begin
  Result := ParseCommon.IndexOf(List, AName, True, ItemName);
end;

procedure TParseValueList.Loaded;
begin
  inherited;
  if List.Count > 0 then Attach;
end;

procedure TParseValueList.Notification(Component: TComponent; Operation: TOperation);
begin
  inherited;
  if (Component = FEventManager) and (Operation = opRemove) then Reset;
end;

procedure TParseValueList.Notify(NotifyType: TNotifyType;
  Component: TComponent);
begin
  inherited;
  case NotifyType of
    ntConnect: Connect;
    ntSuspend: Suspend;
    ntDisconnect: Reset;
    ntCompile: Compile;
  end;
end;

function TParseValueList.Recurse(FunctionHandle: Integer; const Script: TScript): Boolean;
var
  AFunction: PFunction;
  FunctionArray: TIntegerDynArray;
  I: Integer;
begin
  Result := Assigned(FParser) and FParser.FindFunction(FunctionHandle, AFunction) and
    (not AFunction.Optimizable or not FOptimization);
  if Result then
  begin
    ParseHelper.GetFunctionArray(Script, FunctionArray);
    try
      for I := Low(FunctionArray) to High(FunctionArray) do
        if FunctionHandle = FunctionArray[I] then
        begin
          Result := True;
          Exit;
        end;
      Result := False;
    finally
      FunctionArray := nil;
    end;
  end;
end;

procedure TParseValueList.Reset(AEventManager: TCustomEventManager);
begin
  Disconnect;
  FEventManager := AEventManager;
end;

procedure TParseValueList.SetEventManager(const Value: TCustomEventManager);
begin
  if Value <> FEventManager then
  begin
    Reset(Value);
    Connect;
  end;
end;

procedure TParseValueList.SetFlexibleList(const Value: TFlexibleList);
begin
  Detach;
  FFlexibleList.Assign(Value);
  Attach;
end;

procedure TParseValueList.SetList(const Value: TStrings);
begin
  FFlexibleList.List := Value;
end;

procedure TParseValueList.SetListType(const Value: TListType);
begin
  FFlexibleList.ListType := Value;
end;

procedure TParseValueList.SetName(const NewName: TComponentName);
begin
  if SysUtils.SameText(Name, FFunctionName) then FFunctionName := NewName;
  inherited;
end;

procedure TParseValueList.Suspend;
begin
  Detach;
  if Available(FEventManager) then FEventManager.Delete(FFunctionHandle);
  FParser := nil;
end;

end.
