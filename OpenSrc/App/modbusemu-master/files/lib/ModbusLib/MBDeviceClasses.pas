unit MBDeviceClasses;

{$mode objfpc}{$H+}

interface

uses Classes,
     MBDefine, MBRegistersCalsses, MBRegListSimpleClasses;

type
  TMBDevice = class;

  TDeviceArray = array [0..255] of TMBDevice;
  PDeviceArray = ^TDeviceArray;

  TAllowCleanRegListProc = procedure (Sender : TObject; var AllowCleanUp : Boolean) of object;
  TOnDeviceChange = procedure (Sender : TMBDevice; ErrorCode : Cardinal;
                               DiscretRegs : TMBBitRegsArray;
                               CoilRegs : TMBBitRegsArray;
                               InputRegs : TMBWordRegsArray;
                               HoldingRegs : TMBWordRegsArray) of object;

  TOnDeviceError = procedure (Sender : TMBDevice; Error : Cardinal) of object;

  { TMBDevice }

  TMBDevice = class(TComponent)
  private
    FDeviceNum           : Byte;
    FDeviceFunctions     : TMBFunctionsSet;
    FLastError           : Cardinal;

    FIsDiscretChangedData: Boolean;
    FIsCoilChangedData   : Boolean;
    FIsInputChangedData  : Boolean;
    FIsHoldingChangedData: Boolean;

    FIsPacketUpdate      : Boolean;

    FDefDiscret          : Boolean;
    FDefCoil             : Boolean;
    FDefInput            : Word;
    FDefHolding          : Word;

    FOnBefoClearHolding  : TAllowCleanRegListProc;
    FOnBefoClearDiscret  : TAllowCleanRegListProc;
    FOnBefoClearCoil     : TAllowCleanRegListProc;
    FOnBefoClearInput    : TAllowCleanRegListProc;

    FOnBefoCoilChange    : TBefoRegBitChange;
    FOnBefoDiscretChange : TBefoRegBitChange;
    FOnBefoInputChange   : TBefoRegWordChange;
    FOnBefoHoldingChange : TBefoRegWordChange;

    FOnClearCoil         : TNotifyEvent;
    FOnClearHolding      : TNotifyEvent;
    FOnClearInput        : TNotifyEvent;
    FOnClearDiscret      : TNotifyEvent;

    FOnCoilChange        : TOnRegBitChange;
    FOnDiscretChange     : TOnRegBitChange;
    FOnHoldingChange     : TOnRegWordChange;
    FOnInputChange       : TOnRegWordChange;

    FOnBefoClearAll      : TAllowCleanRegListProc;
    FOnClearAll          : TNotifyEvent;

    FOnDiscretsChange    : TOnRegsBitChange;
    FOnCoilsChange       : TOnRegsBitChange;
    FOnInputsChange      : TOnRegsWordChange;
    FOnHoldingsChange    : TOnRegsWordChange;

    FOnDeviceChange      : TOnDeviceChange;
    FOnDeviceError       : TOnDeviceError;

    FLastUpdateTime      : TDateTime;
    FLastErrorTime       : TDateTime;
    FLastErrorCounter    : Cardinal;
    procedure SetDeviceFunctions(const Value: TMBFunctionsSet);
    procedure SetDeviceNum(const Value: Byte);
    function  GetCoilCount: Integer;
    function  GetCoils(Address: Word): TMBBitRegister;
    function  GetDiscretCount: Integer;
    function  GetDiscrets(Address: Word): TMBBitRegister;
    function  GetHoldingCount: Integer;
    function  GetHoldings(Address: Word): TMBWordRegister;
    function  GetInputCount: Integer;
    function  GetInputs(Address: Word): TMBWordRegister;
    function  GetCoilRangeCount: Integer;
    function  GetCoilsRanges(Index: Integer): TMBRegistersRangeClassic;
    function  GetDiscretRangeCount: Integer;
    function  GetDiscretsRanges(Index: Integer): TMBRegistersRangeClassic;
    function  GetHoldingRangeCount: Integer;
    function  GetHoldingsRanges(Index: Integer): TMBRegistersRangeClassic;
    function  GetInputRangeCount: Integer;
    function  GetInputsRanges(Index: Integer): TMBRegistersRangeClassic;
    procedure SetLastError(const Value: Cardinal);
  protected
    FDiscretList   : TMBRegBitSimpleList;
    FCoilList      : TMBRegBitSimpleList;
    FInputList     : TMBRegWordSimpleList;
    FHoldingList   : TMBRegWordSimpleList;

    FDiscretsBuff  : TMBBitRegsArray;
    FCoilsBuff     : TMBBitRegsArray;
    FInputsBuff    : TMBWordRegsArray;
    FHoldingsBuff  : TMBWordRegsArray;

    procedure ClearBuffs;
    procedure ResetFlagChanges;

    procedure DoSetDeviceFunctions(const Value: TMBFunctionsSet); virtual;
    procedure DoSetDeviceNum(const Value: Byte); virtual;
    procedure DoSetLastError(Error : Cardinal); virtual;

    procedure OnDiscretChangeProc(Sender : TMBBitRegister); virtual;
    procedure OnCoilChangeProc(Sender : TMBBitRegister); virtual;
    procedure OnInputChangeProc(Sender : TMBWordRegister; ChangeBitSet : TRegBits = []); virtual;
    procedure OnHoldingChangeProc(Sender : TMBWordRegister; ChangeBitSet : TRegBits = []); virtual;

    procedure OnDiscretsChangeProc(Sender : TObject; ChangedRegs : TMBBitRegsArray); virtual;
    procedure OnCoilsChangeProc(Sender : TObject; ChangedRegs : TMBBitRegsArray); virtual;
    procedure OnInputsChangeProc(Sender : TObject; ChangedRegs  : TMBWordRegsArray); virtual;
    procedure OnHoldingsChangeProc(Sender : TObject; ChangedRegs  : TMBWordRegsArray); virtual;

    procedure OnDeviceChangeProc(Sender : TMBDevice; ErrorCode : Cardinal;
                                 DiscretRegs : TMBBitRegsArray;
                                 CoilRegs : TMBBitRegsArray;
                                 InputRegs : TMBWordRegsArray;
                                 HoldingRegs : TMBWordRegsArray); virtual;
    procedure OnDeviceErrorProc(Sender : TMBDevice; Error : Cardinal); virtual;

    procedure OnBefoDiscretChangeProc(Sender : TMBBitRegister; NewValue : Boolean; var isChange : Boolean); virtual;
    procedure OnBefoCoilChangeProc(Sender : TMBBitRegister; NewValue : Boolean; var isChange : Boolean); virtual;
    procedure OnBefoInputChangeProc(Sender : TMBWordRegister; NewValue : Word; var isChange : Boolean); virtual;
    procedure OnBefoHoldingChangeProc(Sender : TMBWordRegister; NewValue : Word; var isChange : Boolean); virtual;

    procedure OnBefoClearAllProc(Sender : TObject; var AllowCleanUp : Boolean); virtual;
    procedure OnBefoClearDiscretProc(Sender : TObject; var AllowCleanUp : Boolean); virtual;
    procedure OnBefoClearCoilProc(Sender : TObject; var AllowCleanUp : Boolean); virtual;
    procedure OnBefoClearInputProc(Sender : TObject; var AllowCleanUp : Boolean); virtual;
    procedure OnBefoClearHoldingProc(Sender : TObject; var AllowCleanUp : Boolean); virtual;

    procedure OnClearAllProc(Sender : TObject); virtual;
    procedure OnClearDiscretProc(Sender : TObject); virtual;
    procedure OnClearCoilProc(Sender : TObject); virtual;
    procedure OnClearInputProc(Sender : TObject); virtual;
    procedure OnClearHoldingProc(Sender : TObject); virtual;
  public
   constructor Create(AOwner : TComponent); override;
   destructor  Destroy; override;
   // удаление регистров из устройства
   procedure ClearDiscrets;
   procedure ClearCoils;
   procedure ClearInputs;
   procedure ClearHoldings;
   procedure ClearAll;
   procedure ResetLastErrorCounter;
   // методы начала и конца пакетного обновления
   procedure BeginPacketUpdate;
   procedure EndPacketUpdate;
   // добавление диапазона регистров и инициализация регистров определенным значением
   procedure AddRegisters(RegType: TRegMBTypes; StartAddress, Count : Word);
   procedure InitializeDevice(aDefDiscret : Boolean; aDefCoil : Boolean; aDefInput : Word; aDefHolding : Word); overload;
   procedure InitializeDevice; overload;
   procedure InitializeCoils;
   procedure InitializeDiscrets;
   procedure InitializeHoldings;
   procedure InitializeInputs;
   // получение диапазонов значений
   function  GetDiscretRegValues(StartAddr : Word; Count: Word): TBits;
   function  GetCoilRegValues(StartAddr : Word; Count: Word): TBits;
   function  GetInputRegValues(StartAddr : Word; Count: Word): TWordRegsValues;
   function  GetHoldingRegValues(StartAddr : Word; Count: Word): TWordRegsValues;
   // установка диапазонов значений
   procedure SetDiscretRegValues(StartAddr : Word; Regs : TBits);
   procedure SetCoilRegValues(StartAddr : Word; Regs : TBits);
   procedure SetInputRegValues(StartAddr : Word; Regs : TWordRegsValues);
   procedure SetHoldingRegValues(StartAddr : Word; Regs : TWordRegsValues);
   // получение среза состояния устройства
   function GetSliceOfDeviceStatus : TMBSliceOfDeviceStatus;
   // перечисление функций поддерживаемых устройством
   property DeviceFunctions                  : TMBFunctionsSet read FDeviceFunctions write SetDeviceFunctions;
   property LastUpdateTime                   : TDateTime read FLastUpdateTime;
   // идентификатор последней ошибки
   property LastError                        : Cardinal read FLastError write SetLastError;
   property LastErrorTime                    : TDateTime read FLastErrorTime;
   property LastErrorCounter                 : Cardinal read FLastErrorCounter;
   // флаг указывающий, что объект был изменен
   property IsDiscretChangedData             : Boolean read FIsDiscretChangedData write FIsDiscretChangedData;
   property IsCoilChangedData                : Boolean read FIsCoilChangedData write FIsCoilChangedData;
   property IsInputChangedData               : Boolean read FIsInputChangedData write FIsInputChangedData;
   property IsHoldingChangedData             : Boolean read FIsHoldingChangedData write FIsHoldingChangedData;
   // списки переменных с доступом по адресам
   property Discrets[Address : Word]         : TMBBitRegister read GetDiscrets;
   property Coils[Address : Word]            : TMBBitRegister read GetCoils;
   property Inputs[Address : Word]           : TMBWordRegister read GetInputs;
   property Holdings[Address : Word]         : TMBWordRegister read GetHoldings;
   // списки переменных с доступом по индексу списка
   property DiscretCount                     : Integer read GetDiscretCount;
   property CoilCount                        : Integer read GetCoilCount;
   property InputCount                       : Integer read GetInputCount;
   property HoldingCount                     : Integer read GetHoldingCount;
   // списки диапазонов переменных данного устройства(диапазоны могут пересекаться)
   property DiscretRangeCount                : Integer read GetDiscretRangeCount;
   property DiscretsRanges[Index : Integer]  : TMBRegistersRangeClassic read GetDiscretsRanges;
   property CoilRangeCount                   : Integer read GetCoilRangeCount;
   property CoilsRanges[Index : Integer]     : TMBRegistersRangeClassic read GetCoilsRanges;
   property InputRangeCount                  : Integer read GetInputRangeCount;
   property InputsRanges[Index : Integer]    : TMBRegistersRangeClassic read GetInputsRanges;
   property HoldingRangeCount                : Integer read GetHoldingRangeCount;
   property HoldingsRanges[Index : Integer]  : TMBRegistersRangeClassic read GetHoldingsRanges;
  published
   // номер устройства
   property DeviceNum           : Byte read FDeviceNum write SetDeviceNum;
   // значения по умолчанию
   property DefDiscret          : Boolean read FDefDiscret write FDefDiscret default False;
   property DefCoil             : Boolean read FDefCoil write FDefCoil default False;
   property DefInput            : Word read FDefInput write FDefInput default 0;
   property DefHolding          : Word read FDefHolding write FDefHolding default 0;

   property OnBefoClearAll      : TAllowCleanRegListProc read FOnBefoClearAll write FOnBefoClearAll ;
   property OnBefoClearDiscret  : TAllowCleanRegListProc read FOnBefoClearDiscret write FOnBefoClearDiscret ;
   property OnBefoClearCoil     : TAllowCleanRegListProc read FOnBefoClearCoil write FOnBefoClearCoil ;
   property OnBefoClearInput    : TAllowCleanRegListProc read FOnBefoClearInput write FOnBefoClearInput ;
   property OnBefoClearHolding  : TAllowCleanRegListProc read FOnBefoClearHolding write FOnBefoClearHolding ;

   property OnClearAll          : TNotifyEvent read FOnClearAll write FOnClearAll ;
   property OnClearDiscret      : TNotifyEvent read FOnClearDiscret write FOnClearDiscret ;
   property OnClearCoil         : TNotifyEvent read FOnClearCoil write FOnClearCoil ;
   property OnClearInput        : TNotifyEvent read FOnClearInput write FOnClearInput ;
   property OnClearHolding      : TNotifyEvent read FOnClearHolding write FOnClearHolding ;

   property OnBefoDiscretChange : TBefoRegBitChange read FOnBefoDiscretChange write FOnBefoDiscretChange;
   property OnBefoCoilChange    : TBefoRegBitChange read FOnBefoCoilChange write FOnBefoCoilChange;
   property OnBefoInputChange   : TBefoRegWordChange read FOnBefoInputChange write FOnBefoInputChange;
   property OnBefoHoldingChange : TBefoRegWordChange read FOnBefoHoldingChange write FOnBefoHoldingChange;

   property OnDiscretChange     : TOnRegBitChange read FOnDiscretChange write FOnDiscretChange;
   property OnCoilChange        : TOnRegBitChange read FOnCoilChange write FOnCoilChange;
   property OnInputChange       : TOnRegWordChange read FOnInputChange write FOnInputChange;
   property OnHoldingChange     : TOnRegWordChange read FOnHoldingChange write FOnHoldingChange;

   property OnDiscretsChange    : TOnRegsBitChange read FOnDiscretsChange write FOnDiscretsChange;
   property OnCoilsChange       : TOnRegsBitChange read FOnCoilsChange write FOnCoilsChange;
   property OnInputsChange      : TOnRegsWordChange read FOnInputsChange write FOnInputsChange;
   property OnHoldingsChange    : TOnRegsWordChange read FOnHoldingsChange write FOnHoldingsChange;

   property OnDeviceChange      : TOnDeviceChange read FOnDeviceChange write FOnDeviceChange;
   property OnDeviceError       : TOnDeviceError read FOnDeviceError write FOnDeviceError;
  end;

  { TMBTCPDevice }

  TMBTCPDevice = class(TMBDevice)
   private
    FIPAddressInfo : TTCP4AddrInfo;
    function  GetIPAddress: Cardinal;
    function  GetIPPort: Word;
    procedure SetIPAddress(AValue: Cardinal);
    procedure SetIPPort(AValue: Word);
   public
    property IPAddress : Cardinal read GetIPAddress write SetIPAddress;
    property IPPort    : Word read GetIPPort write SetIPPort;
  end;

implementation

uses SysUtils,
     {Библиотека MiscFunctions}
     ExceptionsTypes;

{ TMBTCPDevice }

function TMBTCPDevice.GetIPAddress: Cardinal;
begin
  Result := FIPAddressInfo.IP.Addr;
end;

function TMBTCPDevice.GetIPPort: Word;
begin
  Result := FIPAddressInfo.Port;
end;

procedure TMBTCPDevice.SetIPAddress(AValue: Cardinal);
begin
  FIPAddressInfo.IP.Addr := AValue;
end;

procedure TMBTCPDevice.SetIPPort(AValue: Word);
begin
  FIPAddressInfo.Port := AValue;
end;

{ TMBDevice }

constructor TMBDevice.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDeviceNum               := 0;
  FDeviceFunctions         := [];
  FLastError               := 0;
  FLastUpdateTime          := 0;
  FLastErrorTime           := 0;
  FIsDiscretChangedData    := False;
  FIsCoilChangedData       := False;
  FIsInputChangedData      := False;
  FIsHoldingChangedData    := False;
  FIsPacketUpdate          := False;

  FDiscretList             := TMBRegBitSimpleList.Create; // TRegistersListBit.Create;//TMBDiscretRegList.Create;
  FDiscretList.RegListType := rgDiscrete;
  FDiscretList.OnRegChange := @OnDiscretChangeProc;
  FDiscretList.BefoChange  := @OnBefoDiscretChangeProc;

  FCoilList                := TMBRegBitSimpleList.Create; // TRegistersListBit.Create;//TMBCoilRegList.Create;
  FCoilList.RegListType    := rgCoils;
  FCoilList.OnRegChange    := @OnCoilChangeProc;
  FCoilList.BefoChange     := @OnBefoCoilChangeProc;

  FInputList               := TMBRegWordSimpleList.Create; // TRegistersListWord.Create;//TMBInputRegList.Create;
  FInputList.RegDefType    := rtSimpleWord;
  FInputList.RegListType   := rgInput;
  FInputList.OnRegChange   := @OnInputChangeProc;
  FInputList.BefoChange    := @OnBefoInputChangeProc;

  FHoldingList             := TMBRegWordSimpleList.Create; // TRegistersListWord.Create;//TMBHoldingRegList.Create;
  FHoldingList.RegDefType  := rtSimpleWord;
  FHoldingList.RegListType := rgHolding;
  FHoldingList.OnRegChange := @OnHoldingChangeProc;
  FHoldingList.BefoChange  := @OnBefoHoldingChangeProc;
  
  FDefDiscret              := False;
  FDefCoil                 := False;
  FDefInput                := 0;
  FDefHolding              := 0;
end;

destructor TMBDevice.Destroy;
begin
  ClearAll;
  FreeAndNil(FDiscretList);
  FreeAndNil(FCoilList);
  FreeAndNil(FInputList);
  FreeAndNil(FHoldingList);
  inherited;
end;

procedure TMBDevice.AddRegisters(RegType: TRegMBTypes; StartAddress, Count: Word);
begin
  case RegType of
   rgDiscrete : FDiscretList.AddRangeOfRegs(StartAddress,Count);
   rgCoils    : FCoilList.AddRangeOfRegs(StartAddress,Count);
   rgInput    : FInputList.AddRangeOfRegs(StartAddress,Count);
   rgHolding  : FHoldingList.AddRangeOfRegs(StartAddress,Count);
  end;
end;

procedure TMBDevice.ClearAll;
var TempAllowClean : Boolean;
begin
  TempAllowClean := True;
  OnBefoClearAllProc(Self,TempAllowClean);
  if not TempAllowClean then Exit;

  ClearDiscrets;
  ClearCoils;
  ClearInputs;
  ClearHoldings;

  OnClearAllProc(Self);
end;

procedure TMBDevice.ClearCoils;
var TempAllowClean : Boolean;
begin
  TempAllowClean := True;
  OnBefoClearCoilProc(Self,TempAllowClean);
  if not TempAllowClean then Exit;

   FCoilList.Clear;

  OnClearCoilProc(Self);
end;

procedure TMBDevice.ClearDiscrets;
var TempAllowClean : Boolean;
begin
  TempAllowClean := True;
  OnBefoClearDiscretProc(Self,TempAllowClean);
  if not TempAllowClean then Exit;

  FDiscretList.Clear;

  OnClearDiscretProc(Self);
end;

procedure TMBDevice.ClearHoldings;
var TempAllowClean : Boolean;
begin
  TempAllowClean := True;
  OnBefoClearHoldingProc(Self,TempAllowClean);
  if not TempAllowClean then Exit;

  FHoldingList.Clear;

  OnClearHoldingProc(Self);
end;

procedure TMBDevice.ClearInputs;
var TempAllowClean : Boolean;
begin
  TempAllowClean := True;
  OnBefoClearInputProc(Self,TempAllowClean);
  if not TempAllowClean then Exit;

  FInputList.Clear;

  OnClearInputProc(Self);
end;

procedure TMBDevice.DoSetDeviceFunctions(const Value: TMBFunctionsSet);
begin
  if FDeviceFunctions = Value then Exit;
  FDeviceFunctions := Value;
end;

procedure TMBDevice.DoSetDeviceNum(const Value: Byte);
begin
  if FDeviceNum = Value then Exit;
  FDeviceNum := Value;
end;

function TMBDevice.GetCoilCount: Integer;
begin
  Result:= FCoilList.InfoCountReg;
end;

function TMBDevice.GetCoils(Address: Word): TMBBitRegister;
begin
  Result:=FCoilList.Registers[Address];
end;

function TMBDevice.GetDiscretCount: Integer;
begin
  Result:= FDiscretList.InfoCountReg;
end;

function TMBDevice.GetDiscrets(Address: Word): TMBBitRegister;
begin
  Result:=FDiscretList.Registers[Address];
end;

function TMBDevice.GetHoldingCount: Integer;
begin
  Result:= FHoldingList.InfoCountReg;
end;

function TMBDevice.GetHoldings(Address: Word): TMBWordRegister;
begin
  Result:=FHoldingList.Registers[Address];
end;

function TMBDevice.GetInputCount: Integer;
begin
  Result:= FInputList.InfoCountReg;
end;

function TMBDevice.GetInputs(Address: Word): TMBWordRegister;
begin
  Result:=FInputList.Registers[Address];
end;

procedure TMBDevice.OnDiscretChangeProc(Sender: TMBBitRegister);
var Count,i : Integer;
begin
  if not FIsPacketUpdate then
   begin
    if Assigned(FOnDiscretChange) then FOnDiscretChange(Sender);
   end
  else
   begin
    Count := Length(FDiscretsBuff);

    for i := 0 to Count-1 do
     if FDiscretsBuff[i] = Sender then Exit;

    SetLength(FDiscretsBuff,Count+1);
    FDiscretsBuff[Count]:=Sender;

    FIsDiscretChangedData := True;
   end;
end;

procedure TMBDevice.OnCoilChangeProc(Sender: TMBBitRegister);
var i,Count : Integer;
begin
  if not FIsPacketUpdate then
   begin
    if Assigned(FOnCoilChange) then FOnCoilChange(Sender);
   end
  else
   begin
    Count := Length(FCoilsBuff);

    for i := 0 to Count-1 do
     if FCoilsBuff[i] = Sender then Exit;

    SetLength(FCoilsBuff, Count+1);
    FCoilsBuff[Count] := Sender;

    FIsCoilChangedData := True;
   end;
end;

procedure TMBDevice.OnInputChangeProc(Sender: TMBWordRegister; ChangeBitSet: TRegBits);
var i,Count : Integer;
begin
  if not FIsPacketUpdate then
   begin
    if Assigned(FOnInputChange) then FOnInputChange(Sender,ChangeBitSet);
   end
  else
   begin
   Count := Length(FInputsBuff);

   for i := 0 to Count-1 do
     if FInputsBuff[i] = Sender then Exit;

   SetLength(FInputsBuff,Count+1);
   FInputsBuff[Count]:=Sender;

   FIsInputChangedData := True;
  end;
end;

procedure TMBDevice.OnHoldingChangeProc(Sender: TMBWordRegister; ChangeBitSet: TRegBits);
var i,Count : Integer;
begin
  if not FIsPacketUpdate then
   begin
    if Assigned(FOnHoldingChange) then FOnHoldingChange(Sender,ChangeBitSet);
   end
  else
   begin
    Count := Length(FHoldingsBuff);

    for i := 0 to Count-1 do
     if FHoldingsBuff[i] = Sender then Exit;

    SetLength(FHoldingsBuff,Count+1);
    FHoldingsBuff[Count]:=Sender;

    FIsHoldingChangedData := True;
   end;
end;

procedure TMBDevice.SetDeviceFunctions(const Value: TMBFunctionsSet);
begin
  DoSetDeviceFunctions(Value);
end;

procedure TMBDevice.SetDeviceNum(const Value: Byte);
begin
  DoSetDeviceNum(Value);
end;

procedure TMBDevice.OnBefoCoilChangeProc(Sender: TMBBitRegister; NewValue: Boolean; var isChange: Boolean);
begin
  if Assigned(FOnBefoCoilChange) then FOnBefoCoilChange(Sender,NewValue,isChange);
end;

procedure TMBDevice.OnBefoDiscretChangeProc(Sender: TMBBitRegister; NewValue: Boolean; var isChange: Boolean);
begin
  if Assigned(FOnBefoDiscretChange) then FOnBefoDiscretChange(Sender,NewValue,isChange);
end;

procedure TMBDevice.OnBefoHoldingChangeProc(Sender: TMBWordRegister; NewValue: Word; var isChange: Boolean);
begin
  if Assigned(FOnBefoHoldingChange) then FOnBefoHoldingChange(Sender,NewValue,isChange);
end;

procedure TMBDevice.OnBefoInputChangeProc(Sender: TMBWordRegister; NewValue: Word; var isChange: Boolean);
begin
  if Assigned(FOnBefoInputChange) then FOnBefoInputChange(Sender,NewValue,isChange);
end;

procedure TMBDevice.OnBefoClearCoilProc(Sender: TObject; var AllowCleanUp: Boolean);
begin
  if Assigned(FOnBefoClearCoil) then FOnBefoClearCoil(Sender,AllowCleanUp);
end;

procedure TMBDevice.OnBefoClearDiscretProc(Sender: TObject; var AllowCleanUp: Boolean);
begin
  if Assigned(FOnBefoClearDiscret) then FOnBefoClearDiscret(Sender,AllowCleanUp);
end;

procedure TMBDevice.OnBefoClearHoldingProc(Sender: TObject; var AllowCleanUp: Boolean);
begin
  if Assigned(FOnBefoClearHolding) then FOnBefoClearHolding(Sender,AllowCleanUp);
end;

procedure TMBDevice.OnBefoClearInputProc(Sender: TObject; var AllowCleanUp: Boolean);
begin
  if Assigned(FOnBefoClearInput) then FOnBefoClearInput(Sender,AllowCleanUp);
end;

procedure TMBDevice.OnClearCoilProc(Sender: TObject);
begin
  if Assigned(FOnClearCoil) then FOnClearCoil(Sender);
end;

procedure TMBDevice.OnClearDiscretProc(Sender: TObject);
begin
  if Assigned(FOnClearDiscret) then FOnClearDiscret(Sender);
end;

procedure TMBDevice.OnClearHoldingProc(Sender: TObject);
begin
  if Assigned(FOnClearHolding) then FOnClearHolding(Sender);
end;

procedure TMBDevice.OnClearInputProc(Sender: TObject);
begin
  if Assigned(FOnClearInput) then FOnClearInput(Sender);
end;

procedure TMBDevice.OnBefoClearAllProc(Sender: TObject; var AllowCleanUp: Boolean);
begin
  if Assigned(FOnBefoClearAll) then FOnBefoClearAll(Sender,AllowCleanUp);
end;

procedure TMBDevice.OnClearAllProc(Sender: TObject);
begin
  if Assigned(FOnClearAll) then FOnClearAll(Sender);
end;

procedure TMBDevice.InitializeDevice(aDefDiscret : Boolean; aDefCoil : Boolean; aDefInput : Word; aDefHolding : Word);
var i, Count, ii, Count1  : Integer;
    TempRange : TMBRegistersRangeClassic;
begin
  if FDefDiscret <> aDefDiscret then FDefDiscret := aDefDiscret;
  Count := FDiscretList.RegRangeCount-1;
  if Count <> -1 then
   for i := 0 to Count do
    begin
     TempRange := FDiscretList.RegRanges[i];
     Count1 := TempRange.StartAddres + TempRange.Count-1;
     for ii :=  TempRange.StartAddres to Count1 do FDiscretList.Registers[ii].SetDefValue(DefDiscret);
    end;

  if FDefCoil <> aDefCoil then FDefCoil := aDefCoil;
  Count := FCoilList.RegRangeCount-1;
  if Count <> -1 then
   for i := 0 to Count do
    begin
     TempRange := FCoilList.RegRanges[i];
     Count1 := TempRange.StartAddres + TempRange.Count-1;
     for ii :=  TempRange.StartAddres to Count1 do FCoilList.Registers[ii].SetDefValue(DefCoil);
    end;

  if FDefInput <> aDefInput then FDefInput := aDefInput;
  Count := FInputList.RegRangeCount-1;
  if Count <> -1 then
   for i := 0 to Count do
    begin
     TempRange := FInputList.RegRanges[i];
     Count1 := TempRange.StartAddres + TempRange.Count-1;
     for ii :=  TempRange.StartAddres to Count1 do FInputList.Registers[ii].SetDefValue(DefInput);
    end;

  if FDefHolding <> aDefHolding then FDefHolding := aDefHolding;
  Count := FHoldingList.RegRangeCount-1;
  if Count <> -1 then
   for i := 0 to Count do
    begin
     TempRange := FHoldingList.RegRanges[i];
     Count1 := TempRange.StartAddres + TempRange.Count-1;
     for ii :=  TempRange.StartAddres to Count1 do FHoldingList.Registers[ii].SetDefValue(DefHolding);
    end;
end;

procedure TMBDevice.InitializeDevice;
begin
  InitializeDevice(FDefDiscret,FDefCoil,FDefHolding,FDefHolding);
end;

procedure TMBDevice.InitializeCoils;
var i, Count, ii, Count1  : Integer;
    TempRange : TMBRegistersRangeClassic;
begin
  Count := FCoilList.RegRangeCount-1;
  if Count <> -1 then
   for i := 0 to Count do
    begin
     TempRange := FCoilList.RegRanges[i];
     Count1 := TempRange.StartAddres + TempRange.Count-1;
     for ii :=  TempRange.StartAddres to Count1 do FCoilList.Registers[ii].SetDefValue(DefCoil);
    end;
end;

procedure TMBDevice.InitializeDiscrets;
var i, Count, ii, Count1  : Integer;
    TempRange : TMBRegistersRangeClassic;
begin
  Count := FDiscretList.RegRangeCount-1;
  if Count <> -1 then
   for i := 0 to Count do
    begin
     TempRange := FDiscretList.RegRanges[i];
     Count1 := TempRange.StartAddres + TempRange.Count-1;
     for ii :=  TempRange.StartAddres to Count1 do FDiscretList.Registers[ii].SetDefValue(DefDiscret);
    end;
end;

procedure TMBDevice.InitializeHoldings;
var i, Count, ii, Count1  : Integer;
    TempRange : TMBRegistersRangeClassic;
begin
  Count := FHoldingList.RegRangeCount-1;
  if Count <> -1 then
   for i := 0 to Count do
    begin
     TempRange := FHoldingList.RegRanges[i];
     Count1 := TempRange.StartAddres + TempRange.Count-1;
     for ii :=  TempRange.StartAddres to Count1 do FHoldingList.Registers[ii].SetDefValue(DefHolding);
    end;
end;

procedure TMBDevice.InitializeInputs;
var i, Count, ii, Count1  : Integer;
    TempRange : TMBRegistersRangeClassic;
begin
  Count := FInputList.RegRangeCount-1;
  if Count <> -1 then
   for i := 0 to Count do
    begin
     TempRange := FInputList.RegRanges[i];
     Count1 := TempRange.StartAddres + TempRange.Count-1;
     for ii :=  TempRange.StartAddres to Count1 do FInputList.Registers[ii].SetDefValue(DefInput);
    end;
end;

function TMBDevice.GetDiscretRegValues(StartAddr : Word; Count : Word) : TBits;
var TempReg : TMBBitRegister;
    TempAdderss : Cardinal;
    i : Word;
begin
  Result:=nil;
  TempAdderss:=StartAddr;

  TempReg := FDiscretList.Registers[TempAdderss];
  if TempReg =nil then raise EMBIllegalDataAddress.Create;
  TempReg := FDiscretList.Registers[TempAdderss+Count-1];
  if TempReg =nil then raise EMBIllegalDataAddress.Create;

  Result:=TBits.Create;
  try
   Result.Size:=Count;
   for i:=0 to Count-1 do
    begin
     TempReg:=FDiscretList.Registers[TempAdderss+i];
     Result.Bits[i]:=TempReg.Value;
    end;
  except
   FreeAndNil(Result);
   raise;
  end
end;

function TMBDevice.GetCoilRegValues(StartAddr : Word; Count : Word) : TBits;
var TempReg : TMBBitRegister;
    TempAdderss : Cardinal;
    i : Cardinal;
begin
  Result:=nil;
  TempAdderss:=StartAddr;

  TempReg := FCoilList.Registers[TempAdderss];
  if TempReg =nil then raise EMBIllegalDataAddress.Create;
  TempReg := FCoilList.Registers[TempAdderss+Count-1];
  if TempReg =nil then raise EMBIllegalDataAddress.Create;

  Result:=TBits.Create;
  try
   Result.Size:=Count;
   for i:=0 to Count-1 do
    begin
     TempReg:=FCoilList.Registers[TempAdderss+i];
     Result.Bits[i]:=TempReg.Value;
    end;
  except
   FreeAndNil(Result);
   raise;
  end
end;

function TMBDevice.GetInputRegValues(StartAddr : Word; Count : Word) : TWordRegsValues;
var TempReg : TMBWordRegister;
    TempAdderss : Cardinal;
    i : Cardinal;
begin
  SetLength(Result,0);
  TempAdderss:=StartAddr;

  TempReg := FInputList.Registers[TempAdderss];
  if TempReg =nil then raise EMBIllegalDataAddress.Create;
  TempReg := FInputList.Registers[TempAdderss+Count-1];
  if TempReg =nil then raise EMBIllegalDataAddress.Create;

  SetLength(Result,Count);
  try
   for i:=0 to Count-1 do
    begin
     TempReg:=FInputList.Registers[TempAdderss+i];
     Result[i]:=TempReg.Value;
    end;
  except
   SetLength(Result,0);
   raise;
  end
end;

function TMBDevice.GetHoldingRegValues(StartAddr : Word; Count : Word) : TWordRegsValues;
var TempReg : TMBWordRegister;
    TempAdderss : Cardinal;
    i : Cardinal;
begin
  SetLength(Result,0);
  TempAdderss:=StartAddr;

  TempReg := FHoldingList.Registers[TempAdderss];
  if TempReg =nil then raise EMBIllegalDataAddress.Create;
  TempReg := FHoldingList.Registers[TempAdderss+Count-1];
  if TempReg =nil then raise EMBIllegalDataAddress.Create;

  SetLength(Result,Count);
  try
   for i:=0 to Count-1 do
    begin
     TempReg:=FHoldingList.Registers[TempAdderss+i];
     Result[i]:=TempReg.Value;
    end;
  except
   SetLength(Result,0);
   raise;
  end
end;

procedure TMBDevice.SetDiscretRegValues(StartAddr: Word; Regs: TBits);
var TempAdderss : Integer;
    i,Count : Integer;
begin
  TempAdderss:=StartAddr;
  Count:=Regs.Size;
  if Count=0 then Exit;
  FDiscretList.Registers[TempAdderss]; // проверяем стартовый адрес. в случае отсутствия адреса возбуждается исключение
  FDiscretList.Registers[TempAdderss+Count]; // проверяем конечный адрес.
  for i:=0 to Count-1 do FDiscretList.Registers[TempAdderss+i].Value:=Regs.Bits[i];
end;

procedure TMBDevice.SetCoilRegValues(StartAddr: Word; Regs: TBits);
var TempAdderss : Integer;
    i,Count : Integer;
begin
  TempAdderss:=StartAddr;
  Count:=Regs.Size;
  if Count=0 then Exit;
  FCoilList.Registers[TempAdderss]; // случае отсутствия адреса возбуждается исключение
  FCoilList.Registers[TempAdderss+Count];
  for i:=0 to Count-1 do FCoilList.Registers[TempAdderss+i].Value:=Regs.Bits[i];
end;

procedure TMBDevice.SetInputRegValues(StartAddr: Word; Regs: TWordRegsValues);
var TempAdderss : Integer;
    i,Count : Integer;
begin
  TempAdderss:=StartAddr;
  Count:=length(Regs);
  if Count=0 then Exit;
  FInputList.Registers[TempAdderss]; // случае отсутствия адреса возбуждается исключение
  FInputList.Registers[TempAdderss+Count];
  for i:=0 to Count-1 do FInputList.Registers[TempAdderss+i].Value:=Regs[i];
end;

procedure TMBDevice.SetHoldingRegValues(StartAddr: Word; Regs: TWordRegsValues);
var TempAdderss : Integer;
    i,Count : Integer;
begin
  TempAdderss:=StartAddr;
  Count:=length(Regs);
  if Count=0 then Exit;
  FHoldingList.Registers[TempAdderss]; // случае отсутствия адреса возбуждается исключение
  FHoldingList.Registers[TempAdderss+Count];
  for i:=0 to Count-1 do FHoldingList.Registers[TempAdderss+i].Value:=Regs[i];
end;

function TMBDevice.GetDiscretRangeCount: Integer;
begin
  Result := FDiscretList.RegRangeCount;
end;

function TMBDevice.GetDiscretsRanges(Index: Integer): TMBRegistersRangeClassic;
begin
  Result.StartAddres := FDiscretList.RegRanges[Index].StartAddres;
  Result.Count := FDiscretList.RegRanges[Index].Count;
end;

function TMBDevice.GetCoilRangeCount: Integer;
begin
  Result:=FCoilList.RegRangeCount;
end;

function TMBDevice.GetCoilsRanges(Index: Integer): TMBRegistersRangeClassic;
begin
  Result.StartAddres := FCoilList.RegRanges[Index].StartAddres;
  Result.Count := FCoilList.RegRanges[Index].Count;
end;

function TMBDevice.GetInputRangeCount: Integer;
begin
  Result:=FInputList.RegRangeCount;
end;

function TMBDevice.GetInputsRanges(Index: Integer): TMBRegistersRangeClassic;
begin
  Result.StartAddres := FInputList.RegRanges[Index].StartAddres;
  Result.Count := FInputList.RegRanges[Index].Count;
end;

function TMBDevice.GetHoldingRangeCount: Integer;
begin
  Result:=FHoldingList.RegRangeCount;
end;

function TMBDevice.GetHoldingsRanges(Index: Integer): TMBRegistersRangeClassic;
begin
  Result.StartAddres := FHoldingList.RegRanges[Index].StartAddres;
  Result.Count := FHoldingList.RegRanges[Index].Count;
end;

procedure TMBDevice.OnDeviceChangeProc(Sender : TMBDevice; ErrorCode : Cardinal; DiscretRegs : TMBBitRegsArray; CoilRegs : TMBBitRegsArray; InputRegs : TMBWordRegsArray; HoldingRegs : TMBWordRegsArray);
begin
  if Assigned(FOnDeviceChange) then FOnDeviceChange(Sender,ErrorCode,DiscretRegs,CoilRegs,InputRegs,HoldingRegs);
end;

procedure TMBDevice.OnDiscretsChangeProc(Sender: TObject; ChangedRegs: TMBBitRegsArray);
begin
  if Assigned(FOnDiscretsChange) then FOnDiscretsChange(Sender,ChangedRegs)
end;

procedure TMBDevice.OnCoilsChangeProc(Sender: TObject; ChangedRegs: TMBBitRegsArray);
begin
  if Assigned(FOnCoilsChange) then FOnCoilsChange(Sender,ChangedRegs)
end;

procedure TMBDevice.OnInputsChangeProc(Sender: TObject; ChangedRegs: TMBWordRegsArray);
begin
  if Assigned(FOnInputsChange) then FOnInputsChange(Sender,ChangedRegs)
end;

procedure TMBDevice.OnHoldingsChangeProc(Sender: TObject; ChangedRegs: TMBWordRegsArray);
begin
  if Assigned(FOnHoldingsChange) then FOnHoldingsChange(Sender,ChangedRegs)
end;

procedure TMBDevice.ClearBuffs;
begin
  SetLength(FDiscretsBuff,0);
  SetLength(FCoilsBuff,0);
  SetLength(FInputsBuff,0);
  SetLength(FHoldingsBuff,0);
end;

procedure TMBDevice.BeginPacketUpdate;
begin
  FIsPacketUpdate:=True;
  ClearBuffs;
  ResetFlagChanges;
end;

procedure TMBDevice.EndPacketUpdate;
begin
  FLastUpdateTime:= Now;

  if FIsDiscretChangedData then OnDiscretsChangeProc(Self,FDiscretsBuff);
  if FIsCoilChangedData then OnCoilsChangeProc(Self,FCoilsBuff);
  if FIsInputChangedData then OnInputsChangeProc(Self,FInputsBuff);
  if FIsHoldingChangedData then OnHoldingsChangeProc(Self,FHoldingsBuff);

  OnDeviceChangeProc(Self,FLastError,FDiscretsBuff,FCoilsBuff,FInputsBuff,FHoldingsBuff);

  FIsPacketUpdate := False;
  ClearBuffs;
  ResetFlagChanges;
end;

procedure TMBDevice.OnDeviceErrorProc(Sender: TMBDevice; Error: Cardinal);
begin
  if Assigned(FOnDeviceError) then FOnDeviceError(Sender,Error);
end;

procedure TMBDevice.ResetFlagChanges;
begin
  FIsDiscretChangedData:=False;
  FIsCoilChangedData:=False;
  FIsInputChangedData:=False;
  FIsHoldingChangedData:=False;
end;

procedure TMBDevice.SetLastError(const Value: Cardinal);
begin
  FLastErrorTime := Now;
  DoSetLastError(Value);
end;

procedure TMBDevice.DoSetLastError(Error: Cardinal);
begin
  if Error <> FLastError then FLastError := Error;
  try
    if FLastError<>0 then inc(FLastErrorCounter);
  except
    ResetLastErrorCounter;
  end;
  if FLastError<>0 then OnDeviceErrorProc(Self,Error);
end;

function TMBDevice.GetSliceOfDeviceStatus: TMBSliceOfDeviceStatus;
var i,ii,Count,Count1 : Integer;
    TempRange : TBitRegsValues;
    TempWordRange : TWordRegsValues;
begin
  Result.SliceTime := Now;
  Result.DeviceNum := FDeviceNum;
  Result.Error     := FLastError;
  Result.ErrorTime := FLastErrorTime;

  Count:=DiscretRangeCount-1;
  SetLength(Result.DiscretRanges,Count+1);
  SetLength(Result.DiscretRegVal,Count+1);
  for i := 0 to Count do
   begin
    Result.DiscretRanges[i]:=DiscretsRanges[i];

    Count1 := Result.DiscretRanges[i].Count-1;
    SetLength(Result.DiscretRegVal[i],Count1+1);
    TempRange:=Result.DiscretRegVal[i];
    for ii := Result.DiscretRanges[i].StartAddres to Count1 do
     TempRange[ii]:= Discrets[ii].Value;
   end;

  Count:=CoilRangeCount-1;
  SetLength(Result.CoilRanges,Count+1);
  SetLength(Result.CoilRegVal,Count+1);
  for i := 0 to Count do
   begin
    Result.CoilRanges[i]:=CoilsRanges[i];

    Count1 := Result.CoilRanges[i].Count-1;
    SetLength(Result.CoilRegVal[i],Count1+1);
    TempRange:=Result.CoilRegVal[i];
    for ii := Result.CoilRanges[i].StartAddres to Count1 do
      TempRange[ii]:= Coils[ii].Value;
   end;

  Count:=InputRangeCount-1;
  SetLength(Result.InputRanges,Count+1);
  SetLength(Result.InputRegVal,Count+1);
  for i := 0 to Count do
   begin
    Result.InputRanges[i]:=InputsRanges[i];

    Count1 := Result.InputRanges[i].Count-1;
    SetLength(Result.InputRegVal[i],Count1+1);
    TempWordRange:=Result.InputRegVal[i];
    for ii := Result.InputRanges[i].StartAddres to Count1 do
      TempWordRange[ii]:= Inputs[ii].Value;
   end;

  Count:=HoldingRangeCount-1;
  SetLength(Result.HoldingRanges,Count+1);
  SetLength(Result.HoldingRegVal,Count+1);
  for i := 0 to Count do
   begin
    Result.HoldingRanges[i]:=HoldingsRanges[i];

    Count1 := Result.HoldingRanges[i].Count-1;
    SetLength(Result.HoldingRegVal[i],Count1+1);
    TempWordRange:=Result.HoldingRegVal[i];
    for ii := Result.HoldingRanges[i].StartAddres to Count1 do
      TempWordRange[ii]:= Holdings[ii].Value;
   end;
end;

procedure TMBDevice.ResetLastErrorCounter;
begin
  FlastErrorCounter := 0;
end;

end.
