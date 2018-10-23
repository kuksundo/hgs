unit UeventsSink_PPT;

interface

//{$mode objfpc}

uses
   Dialogs,
   ActiveX, windows, ComObj, SysUtils, PowerPoint_TLB;

type
//
//   ////  I Changed ProgID and CLSID.
//   IApplicationEvents = interface(IDispatch)
//      ['{64818D11-4F9B-11CF-86EA-00AA00B929E8}']// PPt - Slide    <--  Get from ChrisF Code
//      //['{91493441-5A91-11CF-8700-00AA0060263B}']// PPt - Application  <-- Get from ChrisF Code
//      //['{91493463-5A91-11CF-8700-00AA0060263B}']//IID_PresEvents  <-- from Import Type Library
//      //['{9149346D-5A91-11CF-8700-00AA0060263B}']//IID_SldEvents <-- from Import Type Library
//      //['{914934C1-5A91-11CF-8700-00AA0060263B}']//IID_OCXExtenderEvents <-- from Import Type Library
//      //['{914934D2-5A91-11CF-8700-00AA0060263B}']//IID_MasterEvents <-- from Import Type Library
//
//      //['{000209F7-0000-0000-C000-000000000046}'] // <-- MS-Word Application   [From Mike.Cornflake  Link]
//
//      //procedure Quit; safecall;
//   end;

   TApplicationEventsQuitEvent = procedure (Sender : TObject) of object;
   TPowerPointApplicationWindowSelectionChange = procedure(ASender: TObject; const Sel: variant) of object;

  TPowerpointEventSink = class(TObject, IUnknown, IDispatch)
  private
    FCookie : integer;
    FSinkIID : TGUID;
    FQuit : TApplicationEventsQuitEvent;
    FSlideChanged : TPowerPointApplicationWindowSelectionChange;
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
    procedure DoChangeSlide; stdcall;
  public
    constructor Create;

    procedure Connect (pSource : IUnknown);
    procedure Disconnect;

    property Quit : TApplicationEventsQuitEvent read FQuit write FQuit;
    property SlideChanged : TPowerPointApplicationWindowSelectionChange read FSlideChanged write FSlideChanged;
  end;

implementation

function TPowerpointEventSink.QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
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
function TPowerpointEventSink.GetTypeInfoCount(out Count: Integer): HResult; stdcall;
begin
  Result := E_NOTIMPL;
  Count := 0;
end;

// GetTypeInfo
//
function TPowerpointEventSink.GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult; stdcall;
begin
  Result := E_NOTIMPL;
  pointer (TypeInfo) := NIL;
end;

// GetIDsOfNames
//
function TPowerpointEventSink.GetIDsOfNames(const IID: TGUID; Names: Pointer;
     NameCount, LocaleID: Integer; DispIDs: Pointer): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TPowerpointEventSink.Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
   Flag: Word; var Params; VarResult, ExceptInfo, ArgErr: Pointer): HResult; stdcall;
begin
  Result:= DISP_E_MEMBERNOTFOUND;
  case DispID of
  2: begin
       ////////////////////////////////////////////////////
       //Interact when  window Form Sent_Program
       //ShowMessage('Invoke--IID==' + IntToStr(LocaleID));
       /////////////////////////////////////////////////////
       DoQuit;
       Result:= S_OK;
    end;
  end
end;

// DoQuit
//
procedure TPowerpointEventSink.DoQuit; stdcall;
begin
  if not Assigned (Quit) then Exit;
  Quit (Self);
end;

// DoQuit
//
procedure TPowerpointEventSink.DoChangeSlide; stdcall;
begin
  if not Assigned (SlideChanged) then Exit;

//  SlideChanged(Self, null);
end;


// Create
//
constructor TPowerpointEventSink.Create;
begin
   FSinkIID := EApplication;//IApplicationEvents;
end;

// Connect
//
procedure TPowerpointEventSink.Connect (pSource : IUnknown);
var
  pcpc : IConnectionPointContainer;
begin
  Assert (pSource <> NIL);
  Disconnect;

  try
    OleCheck (pSource.QueryInterface (IConnectionPointContainer, pcpc));
    OleCheck (pcpc.FindConnectionPoint (FSinkIID, FCP));  ///  <--  Finding Matching ID
    OleCheck (FCP.Advise (Self, FCookie));
    FSource := pSource;
  except
    raise Exception.Create (Format ('Unable to connect %s.'#13'%s',
      ['Ms-Office App', Exception (ExceptObject).Message]
    ));
  end;
end;

// Disconnect
//
procedure TPowerpointEventSink.Disconnect;
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
function TPowerpointEventSink._AddRef: Integer; stdcall;
begin
   Result := 2;
end;

// _Release
//
function TPowerpointEventSink._Release: Integer; stdcall;
begin
   Result := 1;
end;


end.
