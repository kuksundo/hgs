unit SerialComPort;

interface

uses
  Classes, Controls, StdCtrls, ExtCtrls, Forms, Messages, Graphics, Windows,
  Menus, CPort, CircularQ;
Type
  // property types
  TLedBitmap = Graphics.TBitmap;
  TLedKind = (lkRedLight, lkGreenLight, lkBlueLight, lkYellowLight,
    lkPurpleLight, lkBulb, lkCustom);
  TPjhComLedSignal = (lsConn, lsCTS, lsDSR, lsRLSD, lsRing, lsRx, lsTx);
  TLedState = (lsOff, lsOn);
  TPjhComLedGlyphs = array[TLedState] of TLedBitmap;
  TLedStateEvent = procedure(Sender: TObject; AState: TLedState) of object;

  // led control that shows the state of serial signals
  TPjhComLed = class(TGraphicControl)
  private
    FConnected: Boolean; //Comm Port를 오픈 할것인지의 여부
    FLedSignal: TPjhComLedSignal;
    FKind: TLedKind;
    FState: TLedState;
    FOnChange: TLedStateEvent;
    FGlyphs: TPjhComLedGlyphs;
    FComLink: TComLink;
    FRingTimer: TTimer;

    //for Simple of Property on Object inspector
    function GetAlign: TAlign;
    function GetCursor: TCursor;
    function GetDragCursor: TCursor;
    function GetDragMode: TDragMode;
    function GetEnabled: Boolean;
    function GetHelpContext: THelpContext;
    function GetHelpKeyWord: String;
    function GetHelpType: THelpType;
    function GetHint: String;
    function GetParentShowHint: Boolean;
    function GetPopupMenu: TPopupMenu;
    function GetShowHint: Boolean;
    function GetTag: Longint;
    function GetVisible: Boolean;

    function GetGlyph(const Index: Integer): TLedBitmap;
    function GetRingDuration: Integer;
    procedure SetComPort(const Value: TComPort);
    procedure SetKind(const Value: TLedKind);
    procedure SetState(const Value: TLedState);
    procedure SetLedSignal(const Value: TPjhComLedSignal);
    procedure SetGlyph(const Index: Integer; const Value: TLedBitmap);
    procedure SetRingDuration(const Value: Integer);
    function StoredGlyph(const Index: Integer): Boolean;
    procedure SelectLedBitmap(const LedKind: TLedKind);
    procedure SetStateInternal(const Value: TLedState);
    function CalcBitmapPos: TPoint;
    function BitmapToDraw: TLedBitmap;
    procedure BitmapNeeded;
    procedure SignalChange(Sender: TObject; OnOff: Boolean);
    procedure RingDetect(Sender: TObject);
    procedure DoTimer(Sender: TObject);
    function IsStateOn: Boolean;
    procedure SetConnected(const Value: Boolean);
  protected
    procedure Paint; override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DoChange(AState: TLedState); dynamic;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure DoOnDblClick(Sender: TObject); //add by pjh 2003.11.xx for logic designer
    procedure DoOnRxChar(Sender: TObject); //add by pjh 2003.12.8 for logic designer
    procedure DoOnRxBuf(Sender: TObject; const Buffer; Count: Integer); //add by pjh 2003.12.16 for logic designer
  public
    FBufByte: array[0..1023] of byte;//Byte형 수신버퍼
    FBufByteQ: TCircularQ;
    FComPort: TComPort;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align: TAlign read GetAlign;
    property ComPort: TComPort read FComPort write SetComPort;
    property Connected: Boolean read FConnected write SetConnected default False;
    property LedSignal: TPjhComLedSignal read FLedSignal write SetLedSignal;
    // kind property must be published before GlyphOn, GlyphOff
    property Kind: TLedKind read FKind write SetKind;
    property GlyphOn: TLedBitmap index 0
      read GetGlyph write SetGlyph stored StoredGlyph;
    property GlyphOff: TLedBitmap index 1
      read GetGlyph write SetGlyph stored StoredGlyph;
    property State: TLedState read FState write SetState default lsOff;
    property RingDuration: Integer read GetRingDuration write SetRingDuration default 1000;
    property Cursor: TCursor read GetCursor;
    property DragCursor: TCursor read GetDragCursor;
    property DragMode: TDragMode read GetDragMode;
    property Enabled: Boolean read GetEnabled;
    property HelpContext: THelpContext read GetHelpContext;
    property HelpKeyWord: String read GetHelpKeyWord;
    property HelpType: THelpType read GetHelpType;
    property Hint: String read GetHint;
    property ParentShowHint: Boolean read GetParentShowHint;
    property PopupMenu: TPopupMenu read GetPopupMenu;
    property ShowHint: Boolean read GetShowHint;
    property Tag: Longint read GetTag;
    property Visible: Boolean read GetVisible;
  end;

  TpjhComThread = class(TThread)
    FOwner: TComponent;
    FBufByte: array[0..1023] of byte;//Byte형 수신버퍼
    FBufStr: TStringList;//String형 수신버퍼

    procedure OnReceiveChar(Sender: TObject; Count: Integer);
    procedure OnReceiveByte(Sender: TObject; const Buffer; Count: Integer);

  protected
    procedure Execute; override;

  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
  end;

implementation

(*****************************************
 * auxilary functions                    *
 *****************************************)

function Min(A, B: Integer): Integer;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function Max(A, B: Integer): Integer;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

// create control
constructor TPjhComLed.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csSetCaption];
  Height := 25;
  Width := 25;

  FComport := TComport.Create(Self);

  with FComport do
  begin
    OnRxBuf := DoOnRxBuf;
    Name := Name + 'Comport';
    TriggersOnRxChar := False;
  end;//with

  FComLink := TComLink.Create;
  FComLink.OnConn := SignalChange;

  FBufByteQ := TCircularQ.Create(1024);

  FGlyphs[lsOn] := TLedBitmap.Create;
  FGlyphs[lsOn].Transparent := True;
  FGlyphs[lsOn].TransparentMode := tmAuto;
  FGlyphs[lsOff] := TLedBitmap.Create;
  FGlyphs[lsOff].Transparent := True;
  FGlyphs[lsOff].TransparentMode := tmAuto;
  
  FRingTimer := TTimer.Create(nil);
  FRingTimer.Enabled := False;
  FRingTimer.OnTimer := DoTimer;

  OnDblClick := DoOnDblClick;
end;

// destroy control
destructor TPjhComLed.Destroy;
begin
  FRingTimer.Free;
  FGlyphs[lsOn].Free;
  FGlyphs[lsOff].Free;
  FBufByteQ.Free;
  FComLink.Free;
  FComport.Free;
  FComPort := nil;
  inherited Destroy;
end;

// paint control
procedure TPjhComLed.Paint;
var
  Pt: TPoint;
begin
  // get bitmap handle
  BitmapNeeded;
  // calculate position
  Pt := CalcBitmapPos;
  // draw bitmap
  Canvas.Draw(Pt.x, Pt.y, BitmapToDraw);
end;

// remove ComPort if being destroyed
procedure TPjhComLed.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  //if (Operation = opRemove) and (AComponent = FComPort) then
  //  ComPort := nil;
end;

// ring timer
procedure TPjhComLed.DoTimer(Sender: TObject);
begin
  FRingTimer.Enabled := False;
  SetStateInternal(lsOff);
end;

procedure TPjhComLed.CMEnabledChanged(var Message: TMessage);
begin
  Invalidate;
end;

// trigger OnChangeEvent
procedure TPjhComLed.DoChange(AState: TLedState);
begin
  if Assigned(FOnChange) then
    FOnChange(Self, AState);
end;

// if bitmap is empty, load it
procedure TPjhComLed.BitmapNeeded;
begin
  if (FGlyphs[lsOn].Empty) or (FGlyphs[lsOff].Empty) then
    SelectLedBitmap(FKind);
end;

procedure TPjhComLed.SelectLedBitmap(const LedKind: TLedKind);
const
  OnBitmaps: array[TLedKind] of string = ('LEDREDON', 'LEDGREENON', 'LEDBLUEON',
    'LEDYELLOWON', 'LEDPURPLEON', 'LEDBULBON', '');
  OffBitmaps: array[TLedKind] of string = ('LEDREDOFF', 'LEDGREENOFF',
    'LEDBLUEOFF', 'LEDYELLOWOFF', 'LEDPURPLEOFF', 'LEDBULBOFF' ,'');
begin
  if LedKind <> lkCustom then
  begin
    FGlyphs[lsOn].LoadFromResourceName(HInstance, OnBitmaps[LedKind]);
    FGlyphs[lsOff].LoadFromResourceName(HInstance, OffBitmaps[LedKind]);
  end;
end;

// calculate bitmap position
function TPjhComLed.CalcBitmapPos: TPoint;
var
  Rect: TRect;
begin
  Rect := GetClientRect;
  Result.x := Rect.Left + Max(0, (Rect.Right - Rect.Left - FGlyphs[FState].Width) div 2);
  Result.y := Rect.Top + Max(0, (Rect.Bottom - Rect.Top - FGlyphs[FState].Height) div 2);
end;

// change led state on signal change
procedure TPjhComLed.SignalChange(Sender: TObject; OnOff: Boolean);
begin
  if OnOff then
    SetStateInternal(lsOn)
  else
    SetStateInternal(lsOff);
  Application.ProcessMessages;
end;

// change led state on ring detection
procedure TPjhComLed.RingDetect(Sender: TObject);
begin
  FRingTimer.Enabled := True;
  SetStateInternal(lsOn);
end;

// detect the state of led
function TPjhComLed.IsStateOn: Boolean;
begin
  case FLedSignal of
    lsCTS: Result := (csCTS in FComPort.Signals);
    lsDSR: Result := (csDSR in FComPort.Signals);
    lsRLSD: Result := (csRLSD in FComPort.Signals);
    lsRing: Result := False;
    lsTx: Result := False;
    lsRx: Result := False;
    lsConn: Result := (FComPort <> nil) and (FComPort.Connected);
  else
    Result := False;
  end;
end;

// set led state
procedure TPjhComLed.SetStateInternal(const Value: TLedState);
begin
  FState := Value;
  if not (csLoading in ComponentState) then
    DoChange(FState);
  Invalidate;
end;

// set led kind
procedure TPjhComLed.SetKind(const Value: TLedKind);
begin
  if FKind <> Value then
  begin
    FKind := Value;
    SelectLedBitmap(FKind);
    Invalidate;
  end;
end;

// set ComPort property
procedure TPjhComLed.SetComPort(const Value: TComPort);
begin
  if Value <> FComPort then
  begin
    if FComPort <> nil then
      FComPort.UnRegisterLink(FComLink);
    FComPort := Value;
    if FComPort <> nil then
    begin
      FComPort.FreeNotification(Self);
      FComPort.RegisterLink(FComLink);
      if (FComPort.Connected) and (not (csDesigning in ComponentState))
          and (not (csLoading in ComponentState)) then
        if IsStateOn then
          SetStateInternal(lsOn)
        else
          SetStateInternal(lsOff);
    end
    else
      SetStateInternal(lsOff);
  end;
end;

// set led state
procedure TPjhComLed.SetState(const Value: TLedState);
begin
  if FComPort <> nil then
    raise EComPort.CreateNoWinCode(CError_LedStateFailed);
  SetStateInternal(Value);
end;

// select which signal to watch
procedure TPjhComLed.SetLedSignal(const Value: TPjhComLedSignal);
begin
  if FLedSignal <> Value then
  begin
    FLedSignal := Value;
    FComLink.OnCTSChange := nil;
    FComLink.OnDSRChange := nil;
    FComLink.OnRLSDChange := nil;
    FComLink.OnRing := nil;
    FComLink.OnTx := nil;
    FComLink.OnRx := nil;
    FComLink.OnConn := nil;
    case FLedSignal of
      lsCTS: FComLink.OnCTSChange := SignalChange;
      lsDSR: FComLink.OnDSRChange := SignalChange;
      lsRLSD: FComLink.OnRLSDChange := SignalChange;
      lsRing: FComLink.OnRing := RingDetect;
      lsTx: FComLink.OnTx := SignalChange;
      lsRx: FComLink.OnRx := SignalChange;
      lsConn: FComLink.OnConn := SignalChange;
    end;
  end;
end;

function TPjhComLed.GetGlyph(const Index: Integer): TLedBitmap;
begin
  case Index of
    0: Result := FGlyphs[lsOn];
    1: Result := FGlyphs[lsOff];
  else
    Result := nil;
  end;
end;

// set custom bitmap
procedure TPjhComLed.SetGlyph(const Index: Integer; const Value: TLedBitmap);
begin
  if FKind = lkCustom then
  begin
    Value.TransparentMode := tmAuto;
    Value.Transparent := True;
    case Index of
      0: FGlyphs[lsOn].Assign(Value);
      1: FGlyphs[lsOff].Assign(Value);
    end;
    Invalidate;
  end;
end;

function TPjhComLed.StoredGlyph(const Index: Integer): Boolean;
begin
  Result := FKind = lkCustom;
end;

// get bitmap for drawing
function TPjhComLed.BitmapToDraw: TLedBitmap;
var
  ToDraw: TLedState;
begin
  if not Enabled then
    ToDraw := lsOff
  else
    ToDraw := FState;
  Result := FGlyphs[ToDraw];
end;

function TPjhComLed.GetRingDuration: Integer;
begin
  Result := FRingTimer.Interval;
end;

procedure TPjhComLed.SetRingDuration(const Value: Integer);
begin
  FRingTimer.Interval := Value;
end;

procedure TPjhComLed.SetConnected(const Value: Boolean);
begin
  if Value <> FConnected then
  begin
    FConnected := Value;
    
    if Value then
      FComport.Open
    else
      FComport.Close;
  end;
end;

procedure TPjhComLed.DoOnDblClick(Sender: TObject);
begin
  FComport.ShowSetupDialog;
  FComport.StoreSettings(stIniFile, 'Comport.ini');
{ Port := FComPort.Port;
  BaudRate := FComPort.BaudRate;
  DataBit := FComPort.DataBits;
  StopBit := FComPort.StopBits;
  Parity := FComPort.Parity;
  FlowControl := FComPort.FlowControl;
}
end;

procedure TPjhComLed.DoOnRxChar(Sender: TObject);
begin

end;

procedure TPjhComLed.DoOnRxBuf(Sender: TObject; const Buffer; Count: Integer);
begin
  FBufByteQ.Write(@Buffer, Count);  
end;

procedure TPjhComLed.Loaded;
begin
  inherited;
  FComport.LoadSettings(stIniFile, 'Comport.ini');
  if FComport.Connected then
    FComport.Open;
end;

function TPjhComLed.GetAlign: TAlign;
begin
  Result := inherited Align;
end;

function TPjhComLed.GetCursor: TCursor;
begin
  Result := inherited Cursor;
end;

function TPjhComLed.GetDragCursor: TCursor;
begin
  Result := inherited DragCursor;
end;

function TPjhComLed.GetDragMode: TDragMode;
begin
  Result := inherited DragMode;
end;

function TPjhComLed.GetEnabled: Boolean;
begin
  Result := inherited Enabled;
end;

function TPjhComLed.GetHelpContext: THelpContext;
begin
  Result := inherited HelpContext;
end;

function TPjhComLed.GetHelpKeyWord: String;
begin
  Result := inherited HelpKeyWord;
end;

function TPjhComLed.GetHelpType: THelpType;
begin
  Result := inherited HelpType;
end;

function TPjhComLed.GetHint: String;
begin
  Result := inherited Hint;
end;

function TPjhComLed.GetParentShowHint: Boolean;
begin
  Result := inherited ShowHint;
end;

function TPjhComLed.GetPopupMenu: TPopupMenu;
begin
  Result := inherited PopupMenu;
end;

function TPjhComLed.GetShowHint: Boolean;
begin
  Result := inherited ShowHint;
end;

function TPjhComLed.GetTag: Longint;
begin
  Result := inherited Tag;
end;

function TPjhComLed.GetVisible: Boolean;
begin
  Result := inherited Visible;
end;

{ TpjhComThread }

constructor TpjhComThread.Create(AOwner: TComponent);
begin
  inherited Create(True);

  FBufStr := TStringList.Create;
  FOwner := AOwner;
end;

destructor TpjhComThread.Destroy;
begin
  FBufStr.Free;

  inherited;
end;

procedure TpjhComThread.Execute;
begin
  while not terminated do
  begin
    ;
  end;//while
end;

procedure TpjhComThread.OnReceiveByte(Sender: TObject; const Buffer;
  Count: Integer);
begin

end;

procedure TpjhComThread.OnReceiveChar(Sender: TObject; Count: Integer);
var
  TmpBufStr: String;
begin
  TpjhComLed(FOwner).FComPort.ReadStr(TmpBufStr, Count);
  FBufStr.Add(TmpBufStr);
end;

end.
