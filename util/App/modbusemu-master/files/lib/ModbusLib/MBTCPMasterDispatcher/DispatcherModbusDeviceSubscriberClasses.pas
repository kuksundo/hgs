unit DispatcherModbusDeviceSubscriberClasses;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils, contnrs,
     DispatcherModbusItf, MBDefine,
     LoggerItf;

type
  TSubscribersArray = array of IMBDispDevSubscriberItf;

  { TDeviceSubscriber }

  TDeviceSubscriber = class(TObjectLogged)
   private
    FSubscriber   : IMBDispDevSubscriberItf;
    FCoilRegs     : TRegAddressArray;
    FDiscretRegs  : TRegAddressArray;
    FHoldingRegs  : TRegAddressArray;
    FInputRegs    : TRegAddressArray;
    FIsDataChenge : Boolean;
   public
    constructor Create; virtual;
    destructor  Destroy; override;

    procedure SetCoilLength(ALength : Integer);
    procedure SetDiscretLength(ALength : Integer);
    procedure SetInputLength(ALength : Integer);
    procedure SetHoldingLength(ALength : Integer);

    function IsAddressInArray(AAddres : Word; AAddrArray : TRegAddressArray) : Boolean;

    // интерфейс для оповещения подписчика об изменении чего либо из перечисленных регистров
    property Subscriber   : IMBDispDevSubscriberItf read FSubscriber write FSubscriber;
    // перечни регистров подлежащих отслеживанию
    property CoilRegs     : TRegAddressArray read FCoilRegs write FCoilRegs;
    property DiscretRegs  : TRegAddressArray read FDiscretRegs write FDiscretRegs;
    property InputRegs    : TRegAddressArray read FInputRegs write FInputRegs;
    property HoldingRegs  : TRegAddressArray read FHoldingRegs write FHoldingRegs;
    // ключ определяющий менялось что либо в списке отслеживания или нет
    property IsDataChenge : Boolean read FIsDataChenge write FIsDataChenge;
  end;

  { TDeviceSubscribers }

  TDeviceSubscribers = class(TObjectLogged)
   private
    FSubscribersList : TObjectList;
    FDeviceID        : AnsiString;
    function GetCountSubscribers: Integer;
    function GetSubscribers(Index : Integer): TDeviceSubscriber;
    function IsAddressInArray(AAddres : Word; AAddrArray : TRegAddressArray) : Boolean;
   protected
    procedure SetLogger(const AValue: IDLogger); override;
   public
    constructor Create(ADeviceID : AnsiString); virtual;
    destructor  Destroy; override;

    function  IndexOf(ASubscriberItf : IMBDispDevSubscriberItf) : Integer;

    function  AddSubscriber(ASubscriberItf : IMBDispDevSubscriberItf) : TDeviceSubscriber;
    procedure Clear;

    procedure CheckDiskretReg(ARegAddres : Word);
    procedure CheckCoilReg(ARegAddres : Word);
    procedure CheckInputReg(ARegAddres : Word);
    procedure CheckHoldingReg(ARegAddres : Word);

    function  GetChengedSubscribers : TSubscribersArray;
    procedure SetAllNotChenged;

    property DeviceID : AnsiString read FDeviceID;

    property SubscribersCount : Integer read GetCountSubscribers;
    property Subscribers[Index : Integer] : TDeviceSubscriber read GetSubscribers;
  end;

  { TObjectSubscribe }

  TObjectSubscribe = class(TObjectLogged)
   private
    FObgectID  : AnsiString;
    FDevList   : TStringList;
    function GetDeviceCount: Integer;
    function GetDevices(Index : Integer): TDeviceSubscribers;
   protected
    procedure SetLogger(const AValue: IDLogger); override;
   public
    constructor Create(AObjectID : AnsiString); virtual;
    destructor  Destroy; override;

    function  IndexOf(ADeviceID : AnsiString) : Integer;

    function  AddDevice(ADeviceID : AnsiString) : TDeviceSubscribers;
    procedure Clear;

    property ObgectID : AnsiString read FObgectID;

    property DeviceCount : Integer read GetDeviceCount;
    property Devices[Index : Integer] : TDeviceSubscribers read GetDevices;
  end;

  { TDispObjects }

  TDispObjects = class(TObjectLogged)
   private
    FObjList : TStringList;
    function GetObjectCount: Integer;
    function GetObjects(Index : Integer): TObjectSubscribe;
   protected
    procedure SetLogger(const AValue: IDLogger); override;
   public
    constructor Create; virtual;
    destructor  Destroy; override;

    function IndexOf(AObjectID : AnsiString) : Integer;

    function  AddObject(AObjectID : AnsiString): TObjectSubscribe;
    procedure Clear;

    property ObjectCount : Integer read GetObjectCount;
    property Objects[Index : Integer] : TObjectSubscribe read GetObjects;
  end;

implementation

{ TDispObjects }

constructor TDispObjects.Create;
begin
  FObjList := TStringList.Create;
  FObjList.OwnsObjects := True;
end;

destructor TDispObjects.Destroy;
begin
  FreeAndNil(FObjList);
  inherited Destroy;
end;

function TDispObjects.GetObjectCount: Integer;
begin
  Result := FObjList.Count;
end;

function TDispObjects.GetObjects(Index : Integer): TObjectSubscribe;
begin
  Result := TObjectSubscribe(FObjList.Objects[Index]);
end;

procedure TDispObjects.SetLogger(const AValue: IDLogger);
var i, Count : Integer;
begin
  inherited SetLogger(AValue);
  Count := ObjectCount-1;
  for i := 0 to Count do Objects[i].Logger := Logger;
end;

function TDispObjects.IndexOf(AObjectID: AnsiString): Integer;
begin
  Result := FObjList.IndexOf(AObjectID);
end;

function TDispObjects.AddObject(AObjectID: AnsiString): TObjectSubscribe;
var i : Integer;
begin
  i := IndexOf(AObjectID);
  if i <> -1 then
   begin
     Result := TObjectSubscribe(FObjList.Objects[i]);
     Exit;
   end;
  Result := TObjectSubscribe.Create(AObjectID);
  Result.Logger := Logger;
  FObjList.AddObject(AObjectID,Result);
end;

procedure TDispObjects.Clear;
begin
  FObjList.Clear;
end;

{ TObjectSubscribe }

constructor TObjectSubscribe.Create(AObjectID: AnsiString);
begin
  FObgectID := AObjectID;
  FDevList  := TStringList.Create;
  FDevList.OwnsObjects := True;
  FDevList.Sorted := True;
end;

destructor TObjectSubscribe.Destroy;
begin
  FreeAndNil(FDevList);
  inherited Destroy;
end;

function TObjectSubscribe.GetDeviceCount: Integer;
begin
  Result := FDevList.Count;
end;

function TObjectSubscribe.GetDevices(Index : Integer): TDeviceSubscribers;
begin
  Result := TDeviceSubscribers(FDevList.Objects[Index]);
end;

procedure TObjectSubscribe.SetLogger(const AValue: IDLogger);
var i,Count : Integer;
begin
  inherited SetLogger(AValue);
  Count := DeviceCount-1;
  for i := 0 to Count do Devices[i].Logger := Logger;
end;

function TObjectSubscribe.IndexOf(ADeviceID: AnsiString): Integer;
begin
  Result := FDevList.IndexOf(ADeviceID);
end;

function TObjectSubscribe.AddDevice(ADeviceID: AnsiString): TDeviceSubscribers;
var i : Integer;
begin
  Result := nil;
  if ADeviceID = '' then Exit;

  i := IndexOf(ADeviceID);
  if i <> -1 then
   begin
    Result := Devices[i];
    Exit;
   end;
  Result := TDeviceSubscribers.Create(ADeviceID);
  Result.Logger := Logger;
  FDevList.AddObject(ADeviceID,Result);
end;

procedure TObjectSubscribe.Clear;
begin
  FDevList.Clear;
end;

{ TDeviceSubscribers }

constructor TDeviceSubscribers.Create(ADeviceID : AnsiString);
begin
  FSubscribersList := TObjectList.Create(True);
  FDeviceID := ADeviceID;
end;

destructor TDeviceSubscribers.Destroy;
begin
  FreeAndNil(FSubscribersList);
  inherited Destroy;
end;

function TDeviceSubscribers.IndexOf(ASubscriberItf: IMBDispDevSubscriberItf): Integer;
var TempObj : TDeviceSubscriber;
    i,Count : Integer;
begin
  Result := -1;
  Count := SubscribersCount-1;
  for i := 0 to Count do
   begin
    TempObj := Subscribers[i];
    if TempObj.Subscriber = ASubscriberItf then
     begin
      Result := i;
      Break;
     end;
   end;
end;

function TDeviceSubscribers.GetCountSubscribers: Integer;
begin
  Result := FSubscribersList.Count;
end;

function TDeviceSubscribers.GetSubscribers(Index : Integer): TDeviceSubscriber;
begin
  Result := TDeviceSubscriber(FSubscribersList.Items[Index]);
end;

function TDeviceSubscribers.IsAddressInArray(AAddres: Word; AAddrArray: TRegAddressArray): Boolean;
var i : Integer;
begin
  Result := False;
  for i := Low(AAddrArray) to High(AAddrArray) do
   if AAddrArray[i] = AAddres then
    begin
     Result := True;
     Break;
    end;
end;

procedure TDeviceSubscribers.SetLogger(const AValue: IDLogger);
var i, Count : Integer;
begin
  inherited SetLogger(AValue);
  Count := SubscribersCount-1;
  for i := 0 to Count do Subscribers[i].Logger := Logger;
end;

function TDeviceSubscribers.AddSubscriber(ASubscriberItf: IMBDispDevSubscriberItf): TDeviceSubscriber;
var i : Integer;
begin
  Result := nil;
  if not Assigned(ASubscriberItf) then Exit;
  i := IndexOf(ASubscriberItf);
  if i <> -1 then
   begin
    Result := Subscribers[i];
    Exit;
   end;
  Result := TDeviceSubscriber.Create;
  Result.Logger := Logger;
  Result.Subscriber := ASubscriberItf;
  FSubscribersList.Add(Result);
end;

procedure TDeviceSubscribers.Clear;
begin
  FSubscribersList.Clear;
end;

procedure TDeviceSubscribers.CheckDiskretReg(ARegAddres: Word);
var i,Count    : Integer;
    TempSubscr : TDeviceSubscriber;
begin
  Count := SubscribersCount-1;
  for i := 0 to Count do
   begin
    TempSubscr := Subscribers[i];
    if not IsAddressInArray(ARegAddres,TempSubscr.DiscretRegs) then Continue;
    TempSubscr.IsDataChenge := True;
   end;
end;

procedure TDeviceSubscribers.CheckCoilReg(ARegAddres: Word);
var i,Count    : Integer;
    TempSubscr : TDeviceSubscriber;
begin
  Count := SubscribersCount-1;
  for i := 0 to Count do
   begin
    TempSubscr := Subscribers[i];
    if not IsAddressInArray(ARegAddres,TempSubscr.CoilRegs) then Continue;
    TempSubscr.IsDataChenge := True;
   end;
end;

procedure TDeviceSubscribers.CheckInputReg(ARegAddres: Word);
var i,Count    : Integer;
    TempSubscr : TDeviceSubscriber;
begin
  Count := SubscribersCount-1;
  for i := 0 to Count do
   begin
    TempSubscr := Subscribers[i];
    if not IsAddressInArray(ARegAddres,TempSubscr.InputRegs) then Continue;
    TempSubscr.IsDataChenge := True;
   end;
end;

procedure TDeviceSubscribers.CheckHoldingReg(ARegAddres: Word);
var i,Count    : Integer;
    TempSubscr : TDeviceSubscriber;
begin
  Count := SubscribersCount-1;
  for i := 0 to Count do
   begin
    TempSubscr := Subscribers[i];
    if not IsAddressInArray(ARegAddres, TempSubscr.HoldingRegs) then Continue;
    TempSubscr.IsDataChenge := True;
   end;
end;

function TDeviceSubscribers.GetChengedSubscribers: TSubscribersArray;
var i,Count    : Integer;
    TempSubscr : TDeviceSubscriber;
begin
  SetLength(Result,0);
  Count := SubscribersCount-1;
  for i := 0 to Count do
   begin
    TempSubscr := Subscribers[i];
    if TempSubscr.IsDataChenge then
     begin
      SetLength(Result,Length(Result)+1);
      Result[Length(Result)-1] := TempSubscr.Subscriber;
     end;
    TempSubscr.IsDataChenge := False;
   end;
end;

procedure TDeviceSubscribers.SetAllNotChenged;
var i,Count    : Integer;
begin
  Count := SubscribersCount-1;
  for i := 0 to Count do Subscribers[i].IsDataChenge := False;
end;

{ TDeviceSubscriber }

constructor TDeviceSubscriber.Create;
begin
  FIsDataChenge := False;
  SetLength(FCoilRegs,0);
  SetLength(FDiscretRegs,0);
  SetLength(FInputRegs,0);
  SetLength(FHoldingRegs,0);
  FSubscriber := nil;
end;

destructor TDeviceSubscriber.Destroy;
begin
  SetLength(FCoilRegs,0);
  SetLength(FDiscretRegs,0);
  SetLength(FInputRegs,0);
  SetLength(FHoldingRegs,0);
  FSubscriber := nil;
  inherited Destroy;
end;

procedure TDeviceSubscriber.SetCoilLength(ALength: Integer);
begin
  SetLength(FCoilRegs,ALength);
end;

procedure TDeviceSubscriber.SetDiscretLength(ALength: Integer);
begin
  SetLength(FDiscretRegs,ALength);
end;

procedure TDeviceSubscriber.SetInputLength(ALength: Integer);
begin
  SetLength(FInputRegs,ALength);
end;

procedure TDeviceSubscriber.SetHoldingLength(ALength: Integer);
begin
  SetLength(FHoldingRegs,ALength);
end;

function TDeviceSubscriber.IsAddressInArray(AAddres: Word; AAddrArray: TRegAddressArray): Boolean;
var i : Integer;
begin
  Result := False;
  for i := Low(AAddrArray) to High(AAddrArray) do
   if AAddrArray[i] = AAddres then
    begin
     Result := True;
     Break;
    end;
end;

end.

