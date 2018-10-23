// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://biztalk.hhi.co.kr/HHI_IFService/HHI_WebService.asmx?WSDL
//  >Import : http://biztalk.hhi.co.kr/HHI_IFService/HHI_WebService.asmx?WSDL>0
//  >Import : http://biztalk.hhi.co.kr/HHI_IFService/HHI_WebService.asmx?WSDL>1
//  >Import : http://biztalk.hhi.co.kr/HHI_IFService/HHI_WebService.asmx?WSDL>2
// Encoding : utf-8
// Codegen  : [wfOutputLiteralTypes+]
// Version  : 1.0
// (2011-04-22 ¿ÀÈÄ 1:17:53 - - $Rev: 28374 $)
// ************************************************************************ //

unit HHI_WebService;

interface

uses InvokeRegistry, SOAPHTTPClient, Types, XSBuiltIns;

const
  IS_OPTN = $0001;
  IS_UNBD = $0002;
  IS_UNQL = $0008;
  IS_REF  = $0080;

type
  // ************************************************************************ //
  // The following types, referred to in the WSDL document are not being represented
  // in this file. They are either aliases[@] of other types represented or were referred
  // to but never[!] declared in the document. The types from the latter category
  // typically map to predefined/known XML or Embarcadero types; however, they could also 
  // indicate incorrect WSDL documents that failed to declare or import a schema type.
  // ************************************************************************ //
  // !:string          - "http://www.w3.org/2001/XMLSchema"[Gbl]

  WSHO_TRANS_SM_REQ    = class;                 { "http://hhibts.com/WS/HO_TRANS_SM"[GblElm] }
  TXK0SMS2             = class;                 { "http://hhibts.com/WS/TXK0SMS2"[Cplx] }
  WSHO_TRANS_SM_RSP    = class;                 { "http://hhibts.com/WS/HO_TRANS_SM"[GblElm] }
  WSTXK0SMS2_RSP       = class;                 { "http://hhibts.com/WS/TXK0SMS2"[GblElm] }
  HO_TRANS_SM          = class;                 { "http://hhibts.com/WS/HO_TRANS_SM"[Cplx] }

  WSTXK0SMS2_REQ = array of TXK0SMS2;           { "http://hhibts.com/WS/TXK0SMS2"[GblElm] }

  // ************************************************************************ //
  // XML       : WSHO_TRANS_SM_REQ, global, <element>
  // Namespace : http://hhibts.com/WS/HO_TRANS_SM
  // ************************************************************************ //
  WSHO_TRANS_SM_REQ = class(TRemotable)
  private
    FHO_TRANS_SM: HO_TRANS_SM;
    FHO_TRANS_SM_Specified: boolean;
    procedure SetHO_TRANS_SM(Index: Integer; const AHO_TRANS_SM: HO_TRANS_SM);
    function  HO_TRANS_SM_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property HO_TRANS_SM: HO_TRANS_SM  Index (IS_OPTN or IS_UNQL) read FHO_TRANS_SM write SetHO_TRANS_SM stored HO_TRANS_SM_Specified;
  end;

  // ************************************************************************ //
  // XML       : TXK0SMS2, <complexType>
  // Namespace : http://hhibts.com/WS/TXK0SMS2
  // ************************************************************************ //
  TXK0SMS2 = class(TRemotable)
  private
    FSEND_SABUN: string;
    FSEND_SABUN_Specified: boolean;
    FRCV_SABUN: string;
    FRCV_SABUN_Specified: boolean;
    FSYS_TYPE: string;
    FSYS_TYPE_Specified: boolean;
    FNOTICE_GUBUN: string;
    FNOTICE_GUBUN_Specified: boolean;
    FTITLE: string;
    FTITLE_Specified: boolean;
    FSEND_HPNO: string;
    FSEND_HPNO_Specified: boolean;
    FRCV_HPNO: string;
    FRCV_HPNO_Specified: boolean;
    FCONTENT: string;
    FCONTENT_Specified: boolean;
    FALIM_HEAD: string;
    FALIM_HEAD_Specified: boolean;
    procedure SetSEND_SABUN(Index: Integer; const Astring: string);
    function  SEND_SABUN_Specified(Index: Integer): boolean;
    procedure SetRCV_SABUN(Index: Integer; const Astring: string);
    function  RCV_SABUN_Specified(Index: Integer): boolean;
    procedure SetSYS_TYPE(Index: Integer; const Astring: string);
    function  SYS_TYPE_Specified(Index: Integer): boolean;
    procedure SetNOTICE_GUBUN(Index: Integer; const Astring: string);
    function  NOTICE_GUBUN_Specified(Index: Integer): boolean;
    procedure SetTITLE(Index: Integer; const Astring: string);
    function  TITLE_Specified(Index: Integer): boolean;
    procedure SetSEND_HPNO(Index: Integer; const Astring: string);
    function  SEND_HPNO_Specified(Index: Integer): boolean;
    procedure SetRCV_HPNO(Index: Integer; const Astring: string);
    function  RCV_HPNO_Specified(Index: Integer): boolean;
    procedure SetCONTENT(Index: Integer; const Astring: string);
    function  CONTENT_Specified(Index: Integer): boolean;
    procedure SetALIM_HEAD(Index: Integer; const Astring: string);
    function  ALIM_HEAD_Specified(Index: Integer): boolean;
  published
    property SEND_SABUN:   string  Index (IS_OPTN or IS_UNQL) read FSEND_SABUN write SetSEND_SABUN stored SEND_SABUN_Specified;
    property RCV_SABUN:    string  Index (IS_OPTN or IS_UNQL) read FRCV_SABUN write SetRCV_SABUN stored RCV_SABUN_Specified;
    property SYS_TYPE:     string  Index (IS_OPTN or IS_UNQL) read FSYS_TYPE write SetSYS_TYPE stored SYS_TYPE_Specified;
    property NOTICE_GUBUN: string  Index (IS_OPTN or IS_UNQL) read FNOTICE_GUBUN write SetNOTICE_GUBUN stored NOTICE_GUBUN_Specified;
    property TITLE:        string  Index (IS_OPTN or IS_UNQL) read FTITLE write SetTITLE stored TITLE_Specified;
    property SEND_HPNO:    string  Index (IS_OPTN or IS_UNQL) read FSEND_HPNO write SetSEND_HPNO stored SEND_HPNO_Specified;
    property RCV_HPNO:     string  Index (IS_OPTN or IS_UNQL) read FRCV_HPNO write SetRCV_HPNO stored RCV_HPNO_Specified;
    property CONTENT:      string  Index (IS_OPTN or IS_UNQL) read FCONTENT write SetCONTENT stored CONTENT_Specified;
    property ALIM_HEAD:    string  Index (IS_OPTN or IS_UNQL) read FALIM_HEAD write SetALIM_HEAD stored ALIM_HEAD_Specified;
  end;

  // ************************************************************************ //
  // XML       : WSHO_TRANS_SM_RSP, global, <element>
  // Namespace : http://hhibts.com/WS/HO_TRANS_SM
  // ************************************************************************ //
  WSHO_TRANS_SM_RSP = class(TRemotable)
  private
    FSTATUS: string;
    FSTATUS_Specified: boolean;
    FDESCRIPTION: string;
    FDESCRIPTION_Specified: boolean;
    FERROR: string;
    FERROR_Specified: boolean;
    procedure SetSTATUS(Index: Integer; const Astring: string);
    function  STATUS_Specified(Index: Integer): boolean;
    procedure SetDESCRIPTION(Index: Integer; const Astring: string);
    function  DESCRIPTION_Specified(Index: Integer): boolean;
    procedure SetERROR(Index: Integer; const Astring: string);
    function  ERROR_Specified(Index: Integer): boolean;
  published
    property STATUS:      string  Index (IS_OPTN or IS_UNQL) read FSTATUS write SetSTATUS stored STATUS_Specified;
    property DESCRIPTION: string  Index (IS_OPTN or IS_UNQL) read FDESCRIPTION write SetDESCRIPTION stored DESCRIPTION_Specified;
    property ERROR:       string  Index (IS_OPTN or IS_UNQL) read FERROR write SetERROR stored ERROR_Specified;
  end;

  // ************************************************************************ //
  // XML       : WSTXK0SMS2_RSP, global, <element>
  // Namespace : http://hhibts.com/WS/TXK0SMS2
  // ************************************************************************ //
  WSTXK0SMS2_RSP = class(TRemotable)
  private
    FSTATUS: string;
    FSTATUS_Specified: boolean;
    FDESCRIPTION: string;
    FDESCRIPTION_Specified: boolean;
    FERROR: string;
    FERROR_Specified: boolean;
    procedure SetSTATUS(Index: Integer; const Astring: string);
    function  STATUS_Specified(Index: Integer): boolean;
    procedure SetDESCRIPTION(Index: Integer; const Astring: string);
    function  DESCRIPTION_Specified(Index: Integer): boolean;
    procedure SetERROR(Index: Integer; const Astring: string);
    function  ERROR_Specified(Index: Integer): boolean;
  published
    property STATUS:      string  Index (IS_OPTN or IS_UNQL) read FSTATUS write SetSTATUS stored STATUS_Specified;
    property DESCRIPTION: string  Index (IS_OPTN or IS_UNQL) read FDESCRIPTION write SetDESCRIPTION stored DESCRIPTION_Specified;
    property ERROR:       string  Index (IS_OPTN or IS_UNQL) read FERROR write SetERROR stored ERROR_Specified;
  end;

  // ************************************************************************ //
  // XML       : HO_TRANS_SM, <complexType>
  // Namespace : http://hhibts.com/WS/HO_TRANS_SM
  // ************************************************************************ //
  HO_TRANS_SM = class(TRemotable)
  private
    FM_REQSYS: string;
    FM_REQSYS_Specified: boolean;
    FM_FROM: string;
    FM_FROM_Specified: boolean;
    FM_SENDTO: string;
    FM_SENDTO_Specified: boolean;
    FM_SUBJECT: string;
    FM_SUBJECT_Specified: boolean;
    FM_BODY: string;
    FM_BODY_Specified: boolean;
    procedure SetM_REQSYS(Index: Integer; const Astring: string);
    function  M_REQSYS_Specified(Index: Integer): boolean;
    procedure SetM_FROM(Index: Integer; const Astring: string);
    function  M_FROM_Specified(Index: Integer): boolean;
    procedure SetM_SENDTO(Index: Integer; const Astring: string);
    function  M_SENDTO_Specified(Index: Integer): boolean;
    procedure SetM_SUBJECT(Index: Integer; const Astring: string);
    function  M_SUBJECT_Specified(Index: Integer): boolean;
    procedure SetM_BODY(Index: Integer; const Astring: string);
    function  M_BODY_Specified(Index: Integer): boolean;
  published
    property M_REQSYS:  string  Index (IS_OPTN or IS_UNQL) read FM_REQSYS write SetM_REQSYS stored M_REQSYS_Specified;
    property M_FROM:    string  Index (IS_OPTN or IS_UNQL) read FM_FROM write SetM_FROM stored M_FROM_Specified;
    property M_SENDTO:  string  Index (IS_OPTN or IS_UNQL) read FM_SENDTO write SetM_SENDTO stored M_SENDTO_Specified;
    property M_SUBJECT: string  Index (IS_OPTN or IS_UNQL) read FM_SUBJECT write SetM_SUBJECT stored M_SUBJECT_Specified;
    property M_BODY:    string  Index (IS_OPTN or IS_UNQL) read FM_BODY write SetM_BODY stored M_BODY_Specified;
  end;

  // ************************************************************************ //
  // Namespace : http://hhibts.com/WS/HHI_IFService
  // soapAction: http://hhibts.com/WS/HHI_IFService/HHI_WebService/%operationName%
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : document
  // binding   : HHI_WebServiceSoap12
  // service   : HHI_WebService
  // port      : HHI_WebServiceSoap12
  // URL       : http://biztalk.hhi.co.kr/HHI_IFService/HHI_WebService.asmx
  // ************************************************************************ //
  HHI_WebServiceSoap = interface(IInvokable)
  ['{CE766AB5-70E2-259B-CFB2-59D0191917E6}']
    function  Send_TXK0SMS2(const WSTXK0SMS2_REQ: WSTXK0SMS2_REQ): WSTXK0SMS2_RSP; stdcall;
    function  Send_HO_TRANS_SM(const WSHO_TRANS_SM_REQ: WSHO_TRANS_SM_REQ): WSHO_TRANS_SM_RSP; stdcall;
  end;

function GetHHI_WebServiceSoap(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): HHI_WebServiceSoap;

implementation

uses SysUtils;

function GetHHI_WebServiceSoap(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): HHI_WebServiceSoap;
const
  defWSDL = 'http://biztalk.hhi.co.kr/HHI_IFService/HHI_WebService.asmx?WSDL';
  defURL  = 'http://biztalk.hhi.co.kr/HHI_IFService/HHI_WebService.asmx';
  defSvc  = 'HHI_WebService';
  defPrt  = 'HHI_WebServiceSoap12';
var
  RIO: THTTPRIO;
begin
  Result := nil;
  if (Addr = '') then
  begin
    if UseWSDL then
      Addr := defWSDL
    else
      Addr := defURL;
  end;
  if HTTPRIO = nil then
    RIO := THTTPRIO.Create(nil)
  else
    RIO := HTTPRIO;
  try
    Result := (RIO as HHI_WebServiceSoap);
    if UseWSDL then
    begin
      RIO.WSDLLocation := Addr;
      RIO.Service := defSvc;
      RIO.Port := defPrt;
    end else
      RIO.URL := Addr;
  finally
    if (Result = nil) and (HTTPRIO = nil) then
      RIO.Free;
  end;
end;

destructor WSHO_TRANS_SM_REQ.Destroy;
begin
  SysUtils.FreeAndNil(FHO_TRANS_SM);
  inherited Destroy;
end;

procedure WSHO_TRANS_SM_REQ.SetHO_TRANS_SM(Index: Integer; const AHO_TRANS_SM: HO_TRANS_SM);
begin
  FHO_TRANS_SM := AHO_TRANS_SM;
  FHO_TRANS_SM_Specified := True;
end;

function WSHO_TRANS_SM_REQ.HO_TRANS_SM_Specified(Index: Integer): boolean;
begin
  Result := FHO_TRANS_SM_Specified;
end;

procedure TXK0SMS2.SetSEND_SABUN(Index: Integer; const Astring: string);
begin
  FSEND_SABUN := Astring;
  FSEND_SABUN_Specified := True;
end;

function TXK0SMS2.SEND_SABUN_Specified(Index: Integer): boolean;
begin
  Result := FSEND_SABUN_Specified;
end;

procedure TXK0SMS2.SetRCV_SABUN(Index: Integer; const Astring: string);
begin
  FRCV_SABUN := Astring;
  FRCV_SABUN_Specified := True;
end;

function TXK0SMS2.RCV_SABUN_Specified(Index: Integer): boolean;
begin
  Result := FRCV_SABUN_Specified;
end;

procedure TXK0SMS2.SetSYS_TYPE(Index: Integer; const Astring: string);
begin
  FSYS_TYPE := Astring;
  FSYS_TYPE_Specified := True;
end;

function TXK0SMS2.SYS_TYPE_Specified(Index: Integer): boolean;
begin
  Result := FSYS_TYPE_Specified;
end;

procedure TXK0SMS2.SetNOTICE_GUBUN(Index: Integer; const Astring: string);
begin
  FNOTICE_GUBUN := Astring;
  FNOTICE_GUBUN_Specified := True;
end;

function TXK0SMS2.NOTICE_GUBUN_Specified(Index: Integer): boolean;
begin
  Result := FNOTICE_GUBUN_Specified;
end;

procedure TXK0SMS2.SetTITLE(Index: Integer; const Astring: string);
begin
  FTITLE := Astring;
  FTITLE_Specified := True;
end;

function TXK0SMS2.TITLE_Specified(Index: Integer): boolean;
begin
  Result := FTITLE_Specified;
end;

procedure TXK0SMS2.SetSEND_HPNO(Index: Integer; const Astring: string);
begin
  FSEND_HPNO := Astring;
  FSEND_HPNO_Specified := True;
end;

function TXK0SMS2.SEND_HPNO_Specified(Index: Integer): boolean;
begin
  Result := FSEND_HPNO_Specified;
end;

procedure TXK0SMS2.SetRCV_HPNO(Index: Integer; const Astring: string);
begin
  FRCV_HPNO := Astring;
  FRCV_HPNO_Specified := True;
end;

function TXK0SMS2.RCV_HPNO_Specified(Index: Integer): boolean;
begin
  Result := FRCV_HPNO_Specified;
end;

procedure TXK0SMS2.SetCONTENT(Index: Integer; const Astring: string);
begin
  FCONTENT := Astring;
  FCONTENT_Specified := True;
end;

function TXK0SMS2.CONTENT_Specified(Index: Integer): boolean;
begin
  Result := FCONTENT_Specified;
end;

procedure TXK0SMS2.SetALIM_HEAD(Index: Integer; const Astring: string);
begin
  FALIM_HEAD := Astring;
  FALIM_HEAD_Specified := True;
end;

function TXK0SMS2.ALIM_HEAD_Specified(Index: Integer): boolean;
begin
  Result := FALIM_HEAD_Specified;
end;

procedure WSHO_TRANS_SM_RSP.SetSTATUS(Index: Integer; const Astring: string);
begin
  FSTATUS := Astring;
  FSTATUS_Specified := True;
end;

function WSHO_TRANS_SM_RSP.STATUS_Specified(Index: Integer): boolean;
begin
  Result := FSTATUS_Specified;
end;

procedure WSHO_TRANS_SM_RSP.SetDESCRIPTION(Index: Integer; const Astring: string);
begin
  FDESCRIPTION := Astring;
  FDESCRIPTION_Specified := True;
end;

function WSHO_TRANS_SM_RSP.DESCRIPTION_Specified(Index: Integer): boolean;
begin
  Result := FDESCRIPTION_Specified;
end;

procedure WSHO_TRANS_SM_RSP.SetERROR(Index: Integer; const Astring: string);
begin
  FERROR := Astring;
  FERROR_Specified := True;
end;

function WSHO_TRANS_SM_RSP.ERROR_Specified(Index: Integer): boolean;
begin
  Result := FERROR_Specified;
end;

procedure WSTXK0SMS2_RSP.SetSTATUS(Index: Integer; const Astring: string);
begin
  FSTATUS := Astring;
  FSTATUS_Specified := True;
end;

function WSTXK0SMS2_RSP.STATUS_Specified(Index: Integer): boolean;
begin
  Result := FSTATUS_Specified;
end;

procedure WSTXK0SMS2_RSP.SetDESCRIPTION(Index: Integer; const Astring: string);
begin
  FDESCRIPTION := Astring;
  FDESCRIPTION_Specified := True;
end;

function WSTXK0SMS2_RSP.DESCRIPTION_Specified(Index: Integer): boolean;
begin
  Result := FDESCRIPTION_Specified;
end;

procedure WSTXK0SMS2_RSP.SetERROR(Index: Integer; const Astring: string);
begin
  FERROR := Astring;
  FERROR_Specified := True;
end;

function WSTXK0SMS2_RSP.ERROR_Specified(Index: Integer): boolean;
begin
  Result := FERROR_Specified;
end;

procedure HO_TRANS_SM.SetM_REQSYS(Index: Integer; const Astring: string);
begin
  FM_REQSYS := Astring;
  FM_REQSYS_Specified := True;
end;

function HO_TRANS_SM.M_REQSYS_Specified(Index: Integer): boolean;
begin
  Result := FM_REQSYS_Specified;
end;

procedure HO_TRANS_SM.SetM_FROM(Index: Integer; const Astring: string);
begin
  FM_FROM := Astring;
  FM_FROM_Specified := True;
end;

function HO_TRANS_SM.M_FROM_Specified(Index: Integer): boolean;
begin
  Result := FM_FROM_Specified;
end;

procedure HO_TRANS_SM.SetM_SENDTO(Index: Integer; const Astring: string);
begin
  FM_SENDTO := Astring;
  FM_SENDTO_Specified := True;
end;

function HO_TRANS_SM.M_SENDTO_Specified(Index: Integer): boolean;
begin
  Result := FM_SENDTO_Specified;
end;

procedure HO_TRANS_SM.SetM_SUBJECT(Index: Integer; const Astring: string);
begin
  FM_SUBJECT := Astring;
  FM_SUBJECT_Specified := True;
end;

function HO_TRANS_SM.M_SUBJECT_Specified(Index: Integer): boolean;
begin
  Result := FM_SUBJECT_Specified;
end;

procedure HO_TRANS_SM.SetM_BODY(Index: Integer; const Astring: string);
begin
  FM_BODY := Astring;
  FM_BODY_Specified := True;
end;

function HO_TRANS_SM.M_BODY_Specified(Index: Integer): boolean;
begin
  Result := FM_BODY_Specified;
end;

initialization
  InvRegistry.RegisterInterface(TypeInfo(HHI_WebServiceSoap), 'http://hhibts.com/WS/HHI_IFService', 'utf-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(HHI_WebServiceSoap), 'http://hhibts.com/WS/HHI_IFService/HHI_WebService/%operationName%');
  InvRegistry.RegisterInvokeOptions(TypeInfo(HHI_WebServiceSoap), ioDocument);
  //InvRegistry.RegisterInvokeOptions(TypeInfo(HHI_WebServiceSoap), ioLiteral);
//  InvRegistry.RegisterInvokeOptions(TypeInfo(HHI_WebServiceSoap), ioSOAP12);
  InvRegistry.RegisterMethodInfo(TypeInfo(HHI_WebServiceSoap), 'Send_TXK0SMS2', '', '', IS_OPTN or IS_REF);
  InvRegistry.RegisterParamInfo(TypeInfo(HHI_WebServiceSoap), 'Send_TXK0SMS2', 'WSTXK0SMS2_REQ', '', 'http://hhibts.com/WS/TXK0SMS2', IS_OPTN or IS_REF);
  InvRegistry.RegisterParamInfo(TypeInfo(HHI_WebServiceSoap), 'Send_TXK0SMS2', 'WSTXK0SMS2_RSP', '', 'http://hhibts.com/WS/TXK0SMS2', IS_OPTN or IS_REF);
  InvRegistry.RegisterMethodInfo(TypeInfo(HHI_WebServiceSoap), 'Send_HO_TRANS_SM', '', '', IS_OPTN or IS_REF);
  InvRegistry.RegisterParamInfo(TypeInfo(HHI_WebServiceSoap), 'Send_HO_TRANS_SM', 'WSHO_TRANS_SM_REQ', '', 'http://hhibts.com/WS/HO_TRANS_SM', IS_OPTN or IS_REF);
  InvRegistry.RegisterParamInfo(TypeInfo(HHI_WebServiceSoap), 'Send_HO_TRANS_SM', 'WSHO_TRANS_SM_RSP', '', 'http://hhibts.com/WS/HO_TRANS_SM', IS_OPTN or IS_REF);
  RemClassRegistry.RegisterXSInfo(TypeInfo(WSTXK0SMS2_REQ), 'http://hhibts.com/WS/TXK0SMS2', 'WSTXK0SMS2_REQ');
  RemClassRegistry.RegisterXSClass(WSHO_TRANS_SM_REQ, 'http://hhibts.com/WS/HO_TRANS_SM', 'WSHO_TRANS_SM_REQ');
  RemClassRegistry.RegisterXSClass(TXK0SMS2, 'http://hhibts.com/WS/TXK0SMS2', 'TXK0SMS2');
  RemClassRegistry.RegisterXSClass(WSHO_TRANS_SM_RSP, 'http://hhibts.com/WS/HO_TRANS_SM', 'WSHO_TRANS_SM_RSP');
  RemClassRegistry.RegisterXSClass(WSTXK0SMS2_RSP, 'http://hhibts.com/WS/TXK0SMS2', 'WSTXK0SMS2_RSP');
  RemClassRegistry.RegisterXSClass(HO_TRANS_SM, 'http://hhibts.com/WS/HO_TRANS_SM', 'HO_TRANS_SM');

end.