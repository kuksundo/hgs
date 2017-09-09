unit sdSpaceballInput;
{
  Integration of 3D-Connexion device (SpaceBall)

  Author: Nils Haeck M.Sc.
  copyright (c) by SimDesign BV
}

interface

uses
  sdSpaceballInput_TLB, ActiveX, Classes, Windows,
  ExtCtrls;

type

  TsdTDxDeviceType = (
    dtUnknown,
    dtSpaceNavigator,
    dtSpaceExplorer,
    dtSpaceTraveler,
    dtSpacePilot);

const

  cTDxDeviceTypeNames: array [TsdTDxDeviceType] of string =
   ('Unknown',
    'Space Navigator',
    'Space Explorer',
    'Space Traveler',
    'Space Pilot');

type

  TsdTDxKeyPressEvent = procedure(Sender: TObject; AKeyCode: Integer) of object;

  TsdTDxInput = packed record
    Tx, Ty, Tz, Length: Double;
    Rx, Ry, Rz, Angle: Double;
  end;

  TsdTDxInputEvent = procedure(Sender: TObject; const AInput: TsdTDxInput) of object;

  TsdVector4f = array[0..3] of single;

  TsdMatrix4f = array[0..3] of TsdVector4f;
  //TsdTransformMatrix = array[0..3, 0..3] of double;

  // Encapsulation of the 3D-Connexion device
  TsdTDxInputManager = class(TComponent)
  private
    FDevice: TDevice;
    FKeyBoard: TKeyboard;
    FSensor: TSensor;
    FEnabled: Boolean;
    FOnKeyDown: TsdTDxKeyPressEvent;
    FOnKeyUp: TsdTDxKeyPressEvent;
    FOnInput: TsdTDxInputEvent;
    FOnDeviceChanged: TNotifyEvent;
    FInstalled: Boolean;
    procedure SetEnabled(const Value: Boolean);
    function GetDeviceType: TsdTDxDeviceType;
    procedure DeviceChange(ASender: TObject; AReserved: Integer);
    procedure KeyDown(ASender: TObject; AKeyCode: SYSINT);
    procedure KeyUp(ASender: TObject; AKeyCode: SYSINT);
    procedure SensorInput(ASender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // Provide the GLScene type transform matrix, rotation part in [0..2,0..2],
    // translation part in [0..2,3]
    procedure InputToTransformMatrix(const AInput: TsdTDxInput; var AMatrix: TsdMatrix4f);
    property DeviceType: TsdTDxDeviceType read GetDeviceType;
    property Enabled: Boolean read FEnabled write SetEnabled;
    property Installed: Boolean read FInstalled;
    property OnDeviceChanged: TNotifyEvent read FOnDeviceChanged write FOnDeviceChanged;
    property OnKeyDown: TsdTDxKeyPressEvent read FOnKeyDown write FOnKeyDown;
    property OnKeyUp: TsdTDxKeyPressEvent read FOnKeyUp write FOnKeyUp;
    property OnInput: TsdTDxInputEvent read FOnInput write FOnInput;
  end;

implementation

uses
  SysUtils;

const
  cTDxDeviceTypes: array [TsdTDxDeviceType] of integer = (0, 6, 4, 25, 29);

function Check3DxInstalled: Boolean;
// Check whether the 3D-connections device is installed, by creating a temp
// interface and seeing if the result is ok
var
  iHelper: IUnknown;
begin
  Result := CoCreateInstance(CLASS_TDxInfo, nil, CLSCTX_INPROC_SERVER, ITDxInfo, iHelper) = S_OK;
  iHelper := nil;
end;

{ TsdTDxInputManager }

constructor TsdTDxInputManager.Create;
begin
  inherited Create(AOwner);

  FInstalled := Check3DxInstalled;

  if FInstalled then
  begin
    FDevice := TDevice.Create(nil);
    FDevice.OnDeviceChange := DeviceChange;
    FDevice.Connect;

    FKeyBoard := TKeyboard.Create(nil);
    FKeyBoard.OnKeyDown := KeyDown;
    FKeyBoard.OnKeyUp := KeyUp;
    FKeyBoard.ConnectTo(FDevice.Keyboard);

    FSensor := TSensor.Create(nil);
    FSensor.OnSensorInput := SensorInput;
    FSensor.ConnectTo(FDevice.Sensor);
  end;
end;

destructor TsdTDxInputManager.Destroy;
begin
  if FInstalled then
  begin
    Enabled := False;
    FDevice.Disconnect;
    FreeAndNil(FDevice);
    FKeyBoard.Disconnect;
    FreeAndNil(FKeyBoard);
    FreeAndNil(FSensor);
  end;
  inherited;
end;

procedure TsdTDxInputManager.DeviceChange(ASender: TObject; AReserved: Integer);
begin
  if Assigned(FOnDeviceChanged) then
    FOnDeviceChanged(Self);
end;

function TsdTDxInputManager.GetDeviceType: TsdTDxDeviceType;
var
  DType: Integer;
begin
  if FInstalled then
  begin
    DType := FDevice.type_;
    for Result := Low(TsdTDxDeviceType) to High(TsdTDxDeviceType) do
      if DType = cTDxDeviceTypes[Result] then
        Exit;
  end;
  Result := dtUnknown;
end;

procedure TsdTDxInputManager.InputToTransformMatrix(const AInput: TsdTDxInput; var AMatrix: TsdMatrix4f);
const
  cMultiplier = 0.02;
  cTransMultiplier = 0.1 * cMultiplier;
  cRotMultiplier = pi / 180 * cMultiplier;
var
  c, s, i, j, k, Alpha: double;
begin
  FillChar(AMatrix, SizeOf(AMatrix), 0);

  // Translations
  AMatrix[3, 0] := AInput.Tx * cTransMultiplier;
  AMatrix[3, 1] := AInput.Ty * cTransMultiplier;
  AMatrix[3, 2] := AInput.Tz * cTransMultiplier;
  AMatrix[3, 3] := 1.0;

  // Rotations
  Alpha := AInput.Angle * cRotMultiplier;
  c := cos(Alpha);
  s := sin(Alpha);
  i := AInput.Rx;
  j := AInput.Ry;
  k := AInput.Rz;

  // matrix elements
  AMatrix[0, 0] := c + (1 - c) * i * i;
  AMatrix[1, 0] := (1 - c) * i * j - s * k;
  AMatrix[2, 0] := (1 - c) * i * k + s * j;

  AMatrix[0, 1] := (1 - c) * j * i + s * k;
  AMatrix[1, 1] := c + (1 - c) * j * j;
  AMatrix[2, 1] := (1 - c) * j * k - s * i;

  AMatrix[0, 2] := (1 - c) * k * i - s * j;
  AMatrix[1, 2] := (1 - c) * k * j + s * i;
  AMatrix[2, 2] := c + (1 - c) * k * k;
end;

procedure TsdTDxInputManager.KeyDown(ASender: TObject; AKeyCode: SYSINT);
begin
  if Assigned(FOnKeyDown) then
    FOnKeyDown(Self, AKeyCode);
end;

procedure TsdTDxInputManager.KeyUp(ASender: TObject; AKeyCode: SYSINT);
begin
  if Assigned(FOnKeyUp) then
    FOnKeyUp(Self, AKeyCode);
end;

procedure TsdTDxInputManager.SensorInput(ASender: TObject);
var
  SI: TsdTDxInput;
  V: IVector3D;
  A: IAngleAxis;
begin
  if Assigned(FOnInput) then
  begin
    V := FSensor.Translation;
    SI.Tx := V.X;
    SI.Ty := V.Y;
    SI.Tz := V.Z;
    SI.Length := V.Length;
    A := FSensor.Rotation;
    SI.Rx := A.X;
    SI.Ry := A.Y;
    SI.Rz := A.Z;
    SI.Angle := A.Angle;
    FOnInput(Self, SI)
  end;
end;

procedure TsdTDxInputManager.SetEnabled(const Value: Boolean);
begin
  if Value <> FEnabled then
  begin
    FEnabled := Value;
    if FInstalled then
    begin
      if FEnabled then
        FDevice.Connect1
      else
        FDevice.Disconnect1;
    end;
  end;
end;

initialization
  CoInitialize(nil);

finalization
  CoUninitialize;

end.
