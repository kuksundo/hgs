unit ChennelClasses;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils, syncobjs,
     MBDeviceClasses,
     LoggerItf;

type

  { абстрактный класс потока канала }
  TChennelBaseThread = class(TThreadLogged)
   private
    FCSection    : TCriticalSection;
    FDeviceArray : PDeviceArray;
   protected
    procedure Lock;
    procedure UnLock;
   public
    constructor Create(CreateSuspended: Boolean; const StackSize: SizeUInt = 65535); reintroduce;
    property CSection    : TCriticalSection read FCSection write FCSection;
    property DeviceArray : PDeviceArray read FDeviceArray write FDeviceArray;
  end;

  { абстрактный класс канала }
  TChennelBase = class(TObjectLogged)
   private
    FName        : String;           // наименование канала
    FCSection    : TCriticalSection; // критическая секци для доступа к списку устройств
    FDeviceArray : PDeviceArray;     // список устройств
    function  GetActive : Boolean;
    procedure SetCSection(AValue : TCriticalSection);
    procedure SetDeviceArray(AValue : PDeviceArray);
    procedure SetActive(AValue : Boolean);
    procedure SetActiveFalse;
   protected
    FChennelThread : TChennelBaseThread;
    procedure SetLogger(const AValue: IDLogger); override;
    procedure Lock;
    procedure UnLock;

    procedure SetActiveTrue; virtual; abstract;   // создание и запуск потока канала
   public
    constructor Create; virtual;
    destructor  Destroy; override;

    property Name        : String read FName write FName;
    property Active      : Boolean read GetActive write SetActive;
    property CSection    : TCriticalSection read FCSection write SetCSection;
    property DeviceArray : PDeviceArray read FDeviceArray write SetDeviceArray;
  end;

implementation

{ TChennelBaseThread }

procedure TChennelBaseThread.Lock;
begin
  if Assigned(FCSection) then FCSection.Enter;
end;

procedure TChennelBaseThread.UnLock;
begin
  if Assigned(FCSection) then FCSection.Leave;
end;

constructor TChennelBaseThread.Create(CreateSuspended : Boolean; const StackSize : SizeUInt);
begin
  inherited Create(CreateSuspended,StackSize);
end;

{ TChennelBase }

constructor TChennelBase.Create;
begin
  FCSection      := nil;
  FName          := '';
  FChennelThread := nil;
end;

destructor TChennelBase.Destroy;
begin
  if Active then Active := False;
  inherited Destroy;
end;

function TChennelBase.GetActive : Boolean;
begin
  Result := Assigned(FChennelThread);
end;

procedure TChennelBase.SetCSection(AValue : TCriticalSection);
begin
  if FCSection = AValue then Exit;
  FCSection := AValue;
  if Assigned(FChennelThread) then FChennelThread.CSection := FCSection;
end;

procedure TChennelBase.SetDeviceArray(AValue : PDeviceArray);
begin
  FDeviceArray := AValue;
  Lock;
  try
   if Assigned(FChennelThread) then FChennelThread.DeviceArray := FDeviceArray;
  finally
   UnLock;
  end;
end;

procedure TChennelBase.SetActive(AValue : Boolean);
begin
  if AValue then SetActiveTrue
   else SetActiveFalse;
end;

procedure TChennelBase.SetActiveFalse;
begin
  if not Active then Exit;
  FChennelThread.Terminate;
  FChennelThread.WaitFor;
  FreeAndNil(FChennelThread);
end;

procedure TChennelBase.SetLogger(const AValue : IDLogger);
begin
  inherited SetLogger(AValue);
  if Assigned(FChennelThread) then FChennelThread.Logger := Logger;
end;

procedure TChennelBase.Lock;
begin
  if Assigned(FCSection) then FCSection.Enter;
end;

procedure TChennelBase.UnLock;
begin
  if Assigned(FCSection) then FCSection.Leave;
end;

end.

