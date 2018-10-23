unit UnitEventsSink;

interface

uses
   ActiveX, windows, ComObj, SysUtils;

type
   IApplicationEvents = interface(IDispatch)
      ['{000209F7-0000-0000-C000-000000000046}']
      procedure Quit; safecall;
   end;

   TApplicationEventsQuitEvent = procedure (Sender : TObject) of object;

   TEventSink = class(TObject, IUnknown, IDispatch)
    private
       FCookie : integer;
       FSinkIID : TGUID;
       FQuit : TApplicationEventsQuitEvent;
       // IUnknown methods
       function _AddRef: Integer; stdcall;
       function _Release: Integer; stdcall;
       function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
       // IDispatch methods
       function GetTypeInfoCount(out Count: Integer): HResult; stdcall;
       function GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult;     stdcall;
     function GetIDsOfNames(const IID: TGUID; Names: Pointer;
           NameCount, LocaleID: Integer; DispIDs: Pointer): HResult; stdcall;
     function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer; Flag: Word;
           var Params; VarResult, ExceptInfo, ArgErr: Pointer): HResult; stdcall;
  protected
     FCP : IConnectionPoint;
     FSource : IUnknown;
     procedure DoQuit; stdcall;
  public
     constructor Create;

     procedure Connect (pSource : IUnknown);
     procedure Disconnect;

     property Quit : TApplicationEventsQuitEvent read FQuit write FQuit;
   end;

implementation

function TEventSink.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
      Result:= S_OK
  else if IsEqualIID(IID, FSinkIID) then
     Result:= QueryInterface(IDispatch, Obj)
  else
   Result:= E_NOINTERFACE;
end;

// GetTypeInfoCount
//
function TEventSink.GetTypeInfoCount(out Count: Integer): HResult;
begin
  Result := E_NOTIMPL;
  Count := 0;
end;

// GetTypeInfo
//
function TEventSink.GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult;
begin
  Result := E_NOTIMPL;
  pointer (TypeInfo) := NIL;
end;

// GetIDsOfNames
//
function TEventSink.GetIDsOfNames(const IID: TGUID; Names: Pointer;
     NameCount, LocaleID: Integer; DispIDs: Pointer): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TEventSink.Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
   Flag: Word; var Params; VarResult, ExceptInfo, ArgErr: Pointer): HResult;
begin
  Result:= DISP_E_MEMBERNOTFOUND;
  case DispID of
  2: begin
       DoQuit;
       Result:= S_OK;
    end;
  end
end;

// DoQuit
//
procedure TEventSink.DoQuit;
begin
  if not Assigned (Quit) then Exit;
  Quit (Self);
end;

// Create
//
constructor TEventSink.Create;
begin
   FSinkIID := IApplicationEvents;
end;

// Connect
//
procedure TEventSink.Connect (pSource : IUnknown);
var
  pcpc : IConnectionPointContainer;
begin
  Assert (pSource <> NIL);
  Disconnect;
  try
    OleCheck (pSource.QueryInterface (IConnectionPointContainer, pcpc));
    OleCheck (pcpc.FindConnectionPoint (FSinkIID, FCP));
    OleCheck (FCP.Advise (Self, FCookie));
    FSource := pSource;
  except
    raise Exception.Create (Format ('Unable to connect %s.'#13'%s',
      ['Word', Exception (ExceptObject).Message]
    ));
  end;
end;

// Disconnect
//
procedure TEventSink.Disconnect;
begin
  if (FSource = NIL) then Exit;
  try
    OleCheck (FCP.Unadvise(FCookie));
    FCP := NIL;
    FSource := NIL;
  except
    pointer (FCP) := NIL;
    pointer (FSource) := NIL;
  end;
end;

// _AddRef
//
function TEventSink._AddRef: Integer;
begin
   Result := 2;
end;

// _Release
//
function TEventSink._Release: Integer;
begin
   Result := 1;
end;

end.
