{ *****************************************************************************
  WARNING: This component file was generated using the EventSinkImp utility.
           The contents of this file will be overwritten everytime EventSinkImp
           is asked to regenerate this sink component.

  NOTE:    When using this component at the same time with the XXX_TLB.pas in
           your Delphi projects, make sure you always put the XXX_TLB unit name
           AFTER this component unit name in the USES clause of the interface
           section of your unit; otherwise you may get interface conflict
           errors from the Delphi compiler.

           EventSinkImp is written by Binh Ly (bly@techvanguards.com)
  *****************************************************************************
  //Sink Classes//
}

{$IFDEF VER100}
{$DEFINE D3}
{$ENDIF}

{$IFDEF VER140}
{$DEFINE D6}
{$DEFINE D6_OR_ABOVE}
{$ENDIF}

//SinkUnitName//
unit SinkComponentAsync;

interface

uses
  Windows, ActiveX, Classes, ComObj, OleCtrls
  //SinkUses//
  ;

type
  { backward compatibility types }
  {$IFDEF D3}
  OLE_COLOR = TOleColor;
  {$ENDIF}

  TBaseSinkInvokePacket = class
  protected
    FDispId: integer;
    FFlags: word;
    FParams: PDispParams;
    procedure FreeDispParams;
    procedure InitializeDispParams (const dp: TDispParams);
  public
    constructor Create (iDispId: integer; iFlags: word; const dp: TDispParams);
    destructor Destroy; override;
  end;

  TBaseSinkInvokeThread = class (TThread)
  protected
    FInvokePacket: TBaseSinkInvokePacket;
    FOwner: TObject;
    FReadyEvent: THandle;
    function DoInvoke (DispId: integer; Flags: Word; const dps: TDispParams;
      pDispIds: PDispIdList): HResult; virtual; abstract;
    procedure FreeInvokePacket;
    procedure FreeReadyEvent;
    procedure InitializeInvokePacket (ip: TBaseSinkInvokePacket);
    procedure Invoke;
  public
    constructor Create (Owner: TObject);
    destructor Destroy; override;
    procedure Execute; override;
    procedure InvokeAsync (iDispId: integer; iFlags: word; const dp: TDispParams);
  end;

  TBaseSink = class (TComponent, IUnknown, IDispatch)
  protected
    { IUnknown }
    function QueryInterface(const IID: TGUID; out Obj): HResult; {$IFNDEF D3} override; {$ENDIF} stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;

    { IDispatch }
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount, LocaleID: Integer; DispIDs: Pointer): HResult; virtual; stdcall;
    function GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult; virtual; stdcall;
    function GetTypeInfoCount(out Count: Integer): HResult; virtual; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult; virtual; stdcall;
  protected
    FCookie: integer;
    FCP: IConnectionPoint;
    FSinkIID: TGUID;
    FSource: IUnknown;
    FInvokeThread: TBaseSinkInvokeThread;
    procedure CreateInvokeThread; virtual; abstract;
    procedure FreeInvokeThread;
    function GetInvokeThread: TBaseSinkInvokeThread;
    property InvokeThread: TBaseSinkInvokeThread read GetInvokeThread;
  public
    destructor Destroy; override;
    procedure Connect (const ASource: IUnknown);
    procedure Disconnect;
    property SinkIID: TGUID read FSinkIID write FSinkIID;
    property Source: IUnknown read FSource;
  end;

  //SinkImportsForwards//

  //SinkImports//

  //SinkIntfStart//

  //SinkEventsForwards//

  //SinkComponent//
  TSinkComponentInvokeThread = class (TBaseSinkInvokeThread)
  protected
    function DoInvoke (DispId: integer; Flags: Word; const dps: TDispParams;
      pDispIds: PDispIdList): HResult; override;
  end;

  TSinkComponent = class (TBaseSink
    //ISinkInterface//
  )
  protected
    procedure CreateInvokeThread; override;

    //ISinkInterfaceMethods//
  public
    { system methods }
    constructor Create (AOwner: TComponent); override;
  protected
    //SinkInterface//
  protected
    //SinkEventsProtected//
  published
    //SinkEventsPublished//
  end;

  //SinkIntfEnd//

procedure Register;

implementation

uses
  Messages, SysUtils {$IFDEF D6_OR_ABOVE}, Variants {$ENDIF};

var
  WM_INVOKE: UINT = WM_USER + $1234;

{ globals }

procedure BuildPositionalDispIds (pDispIds: PDispIdList; const dps: TDispParams);
var
  i: integer;
begin
  Assert (pDispIds <> nil);
  
  { by default, directly arrange in reverse order }
  for i := 0 to dps.cArgs - 1 do
    pDispIds^ [i] := dps.cArgs - 1 - i;

  { check for named args }
  if (dps.cNamedArgs <= 0) then Exit;

  { parse named args }
  for i := 0 to dps.cNamedArgs - 1 do
    pDispIds^ [dps.rgdispidNamedArgs^ [i]] := i;
end;


{ TBaseSinkInvokePacket }

procedure TBaseSinkInvokePacket.FreeDispParams;
var
  i: integer;
begin
  if (FParams = nil) then Exit;
  for i := 0 to FParams^.cArgs - 1 do
    Variant (FParams^.rgvarg^ [i]) := Unassigned;
  if (FParams^.cArgs > 0) then
    FreeMem (FParams^.rgvarg, sizeof (TVariantArg) * FParams^.cArgs);
  if (FParams^.cNamedArgs > 0) then
    FreeMem (FParams^.rgdispidNamedArgs, sizeof (TDispId) * FParams^.cNamedArgs);
  Dispose (FParams);
  FParams := nil;
end;

procedure TBaseSinkInvokePacket.InitializeDispParams (const dp: TDispParams);
var
  i: integer;
begin
  FreeDispParams;
  New (FParams);
  FillChar (FParams^, sizeof (TDispParams), 0);
  FParams^.cArgs := dp.cArgs;
  FParams^.cNamedArgs := dp.cNamedArgs;
  if (dp.cArgs > 0) then
  begin
    GetMem (FParams^.rgvarg, sizeof (TVariantArg) * dp.cArgs);
    for i := 0 to dp.cArgs - 1 do
      Variant (FParams^.rgvarg^ [i]) := Variant (dp.rgvarg^ [i]);
  end;  { if }
  if (dp.cNamedArgs > 0) then
  begin
    GetMem (FParams^.rgdispidNamedArgs, sizeof (TDispId) * dp.cNamedArgs);
    for i := 0 to dp.cNamedArgs - 1 do
      FParams^.rgdispidNamedArgs^ [i] := dp.rgdispidNamedArgs^ [i];
  end;  { if }
end;

constructor TBaseSinkInvokePacket.Create (iDispId: integer; iFlags: word; const dp: TDispParams);
begin
  inherited Create;
  FDispId := iDispId;
  FFlags := iFlags;
  InitializeDispParams (dp);
end;

destructor TBaseSinkInvokePacket.Destroy;
begin
  FreeDispParams;
  inherited;
end;


{ TBaseSinkInvokeThread }

procedure TBaseSinkInvokeThread.FreeInvokePacket;
begin
  if (FInvokePacket = nil) then Exit;
  FInvokePacket.Free;
  FInvokePacket := nil;
end;

procedure TBaseSinkInvokeThread.FreeReadyEvent;
begin
  if (FReadyEvent = 0) then Exit;
  CloseHandle (FReadyEvent);
  FReadyEvent := 0;
end;

procedure TBaseSinkInvokeThread.InitializeInvokePacket (ip: TBaseSinkInvokePacket);
begin
  FreeInvokePacket;
  FInvokePacket := ip;
end;

procedure TBaseSinkInvokeThread.Invoke;
var
  bHasParams: boolean;
  pDispIds: PDispIdList;
  iDispIdsSize: integer;
begin
  if (FInvokePacket = nil) then Exit;

  with FInvokePacket do
  begin
    { validity checks }
    if (FFlags AND DISPATCH_METHOD = 0) then
      raise Exception.Create (
        Format ('%s only supports sinking of method calls!', [ClassName]
      ));

    { build pDispIds array. this maybe a bit of overhead but it allows us to
      sink named-argument calls such as Excel's AppEvents, etc!
    }
    pDispIds := nil;
    iDispIdsSize := 0;
    bHasParams := (FParams^.cArgs > 0);
    if (bHasParams) then
    begin
      iDispIdsSize := FParams^.cArgs * SizeOf (TDispId);
      GetMem (pDispIds, iDispIdsSize);
    end;  { if }

    try
      { rearrange dispids properly }
      if (bHasParams) then BuildPositionalDispIds (pDispIds, FParams^);
      DoInvoke (FDispId, FFlags, FParams^, pDispIds);
    finally
      { free pDispIds array }
      if (bHasParams) then FreeMem (pDispIds, iDispIdsSize);
    end;  { finally }
  end;  { with }

  FreeInvokePacket;
end;

constructor TBaseSinkInvokeThread.Create (Owner: TObject);
begin
  inherited Create (True);
  FReadyEvent := CreateEvent (nil, TRUE, FALSE, '');
  FOwner := Owner;
end;

destructor TBaseSinkInvokeThread.Destroy;
begin
  FreeInvokePacket;
  FreeReadyEvent;
  inherited;
end;

procedure TBaseSinkInvokeThread.Execute;
var
  rMsg: TMsg;
begin
  PeekMessage (rMsg, 0, 0, 0, PM_NOREMOVE);  // force thread message queue!
  SetEvent (FReadyEvent);
  
  while (GetMessage (rMsg, 0, 0, 0)) do
  begin
    if (rMsg.Message = WM_INVOKE) then
    begin
      { lParam -> TBaseSinkInvokePacket instance }
      InitializeInvokePacket (TBaseSinkInvokePacket (rMsg.lParam));
      Synchronize (Invoke);
    end;  { if }
  end;  { while }

  Terminate;
end;

procedure TBaseSinkInvokeThread.InvokeAsync (iDispId: integer; iFlags: word; const dp: TDispParams);
var
  ip: TBaseSinkInvokePacket;
begin
  ip := TBaseSinkInvokePacket.Create (iDispId, iFlags, dp);
  PostThreadMessage (ThreadId, WM_INVOKE, 0, lParam (ip));
end;


{ TBaseSink }

function TBaseSink.GetIDsOfNames(const IID: TGUID; Names: Pointer;
  NameCount, LocaleID: Integer; DispIDs: Pointer): HResult;
begin
  Result := E_NOTIMPL;
end;

function TBaseSink.GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult;
begin
  Result := E_NOTIMPL;
  pointer (TypeInfo) := nil;
end;

function TBaseSink.GetTypeInfoCount(out Count: Integer): HResult;
begin
  Result := E_NOTIMPL;
  Count := 0;
end;

function TBaseSink.Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
  Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult;
begin
  InvokeThread.InvokeAsync (DispId, Flags, TDispParams (Params));
  Result := S_OK;
end;

function TBaseSink.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if (GetInterface (IID, Obj)) then
  begin
    Result := S_OK;
    Exit;
  end
  else
    if (IsEqualIID (IID, FSinkIID)) then
      if (GetInterface (IDispatch, Obj)) then
      begin
        Result := S_OK;
        Exit;
      end;
  Result := E_NOINTERFACE;
  pointer (Obj) := nil;
end;

function TBaseSink._AddRef: Integer;
begin
  Result := 2;
end;

function TBaseSink._Release: Integer;
begin
  Result := 1;
end;

procedure TBaseSink.FreeInvokeThread;
begin
  if (FInvokeThread = nil) then Exit;
  if not (FInvokeThread.Terminated) then
  begin
    PostThreadMessage (FInvokeThread.ThreadId, WM_QUIT, 0, 0);
    FInvokeThread.WaitFor;
  end;  { if }
  FInvokeThread.Free;
  FInvokeThread := nil;
end;

function TBaseSink.GetInvokeThread: TBaseSinkInvokeThread;
begin
  if (FInvokeThread = nil) then
  begin
    CreateInvokeThread;
    FInvokeThread.Resume;
    WaitForSingleObject (FInvokeThread.FReadyEvent, INFINITE);
    FInvokeThread.FreeReadyEvent;
  end;  { if }
  Result := FInvokeThread;
end;

destructor TBaseSink.Destroy;
begin
  FreeInvokeThread;
  Disconnect;
  inherited;
end;

procedure TBaseSink.Connect (const ASource: IUnknown);
var
  pcpc: IConnectionPointContainer;
begin
  Assert (ASource <> nil);
  Disconnect;
  try
    OleCheck (ASource.QueryInterface (IConnectionPointContainer, pcpc));
    OleCheck (pcpc.FindConnectionPoint (FSinkIID, FCP));
    OleCheck (FCP.Advise (Self, FCookie));
    FSource := ASource;
  except
    raise Exception.Create (Format ('Unable to connect %s.'#13'%s',
      [Name, Exception (ExceptObject).Message]
    ));
  end;  { finally }
end;

procedure TBaseSink.Disconnect;
begin
  if (FSource = nil) then Exit;
  try
    FreeInvokeThread;
    OleCheck (FCP.Unadvise (FCookie));
    FCP := nil;
    FSource := nil;
  except
    pointer (FCP) := nil;
    pointer (FSource) := nil;
  end;  { except }
end;


//SinkImplStart//

function TSinkComponentInvokeThread.DoInvoke (DispId: integer; Flags: Word; const dps: TDispParams;
  pDispIds: PDispIdList): HResult;
type
  POleVariant = ^OleVariant;
begin
  Result := S_OK;
  with TSinkComponent (FOwner) do
  begin
    //SinkInvoke//
    //SinkInvokeEnd//
  end;  { with }
end;

procedure TSinkComponent.CreateInvokeThread;
begin
  FInvokeThread := TSinkComponentInvokeThread.Create (Self);
end;

constructor TSinkComponent.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);
  //SinkInit//
end;

//SinkImplementation//

//SinkImplEnd//

procedure Register;
begin
  //SinkRegisterStart//
  RegisterComponents ('SinkPage', [TSinkComponent]);
  //SinkRegisterEnd//
end;

initialization
  WM_INVOKE := RegisterWindowMessage ('SinkComponentAsyncInvokeMessage');
end.
