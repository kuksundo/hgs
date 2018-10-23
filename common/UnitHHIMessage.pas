{-----------------------------------------------------------}
{----Purpose : Send HHI Message.               }
{    By      : J.H. Park                                    }
{-----------------------------------------------------------}
{ yyyymmdd comment                                          }
{ -------- -------------------------------------------------}
{ 20110427-한글 깨지는 문제 해결함. TEncoding.Utf8 추가     }
{ 20110425-created.                                         }
{-----------------------------------------------------------}
{ Todo:                                                     }
{-----------------------------------------------------------}
{ Usage:                                                     }
{var
  LTXK0SMS2: TXK0SMS2;
  begin
  LTXK0SMS2 := TXK0SMS2.Create;
  try
    LTXK0SMS2.SEND_SABUN := 'A379042';
    LTXK0SMS2.RCV_SABUN := 'A379042';
    LTXK0SMS2.SYS_TYPE := '112';
    LTXK0SMS2.NOTICE_GUBUN := 'A';
    LTXK0SMS2.TITLE := 'SMS Test';
    //LTXK0SMS2.SEND_HPNO := '010-4190-6742';
    //LTXK0SMS2.RCV_HPNO := '010-3351-7553';
    LTXK0SMS2.CONTENT := 'aaa!';
    LTXK0SMS2.ALIM_HEAD := 'aaa';

    SendHHIMessage_OC(LTXK0SMS2);
  finally
    LTXK0SMS2.Free;
  end;

    SendHHIMessage_SMS('A379042', 'A379042', 'Test SMS');   }
{-----------------------------------------------------------}

unit UnitHHIMessage;

interface

uses SysUtils, Classes, InvokeRegistry, Rio, SOAPHTTPClient, SOAPHTTPTrans, HHI_WebService;

const
  __THhiSMSRecord =
  'FFlag string FSendID string  FRecvID string FHead string FTitle string FContent string';

type
  TEventHandlers = class // create a dummy class
    procedure HTTPRIO1AfterExecute(const MethodName: string;
        SOAPResponse: TStream);
    procedure HTTPRIO1BeforeExecute(const MethodName: string;
        SOAPRequest: TStream);
  end;

  PMsgRecord = ^THhiSMSRecord;
  THhiSMSRecord = packed record
    FFlag,
    FSendID,
    FRecvID,
    FHead,
    FTitle,
    FContent: string;
 end;

function SendHHIMessage(ATXK0SMS2: TXK0SMS2): string;
function SendHHIMessage_SMS(ASendSabun, ARecvSabun, ATitle: string): string;
procedure Send_Message_Main_CODE(FFlag,FSendID,FRecvID,FHead,FTitle,FContent:String); overload // 메세지 메인 함수
procedure Send_Message_Main_CODE(ARecord: THhiSMSRecord); overload // 메세지 메인 함수
procedure MakeHhiSMSRecord(var ARecord: THhiSMSRecord; AFlag,ASendID,ARecvID,AHead,ATitle,AContent:String);

var
  GEventHandlers: TEventHandlers;
  GHTTPRIO1: THTTPRIO;

implementation

uses SynCommons;

procedure TEventHandlers.HTTPRIO1AfterExecute(const MethodName: string;
  SOAPResponse: TStream);
begin
  //SoapResponse.Position := 0;
  //RespMemo.Lines.LoadFromStream(SOAPResponse);
end;

procedure TEventHandlers.HTTPRIO1BeforeExecute(const MethodName: string;
  SOAPRequest: TStream);
var
  Lstrlst, Lstrlst2: TStringList;
begin
  Lstrlst := TStringList.Create;
  Lstrlst2 := TStringList.Create;
  try
    SoapRequest.Position := 0;
    Lstrlst.LoadFromStream(SoapRequest, TEncoding.UTF8);
    Lstrlst.Delete(0);
    Lstrlst2.Add(StringReplace(Lstrlst.Strings[0], '<TXK0SMS2>', '<TXK0SMS2 xmlns="">', [rfReplaceAll, rfIgnoreCase]));
    //ReqMemo.Lines.LoadFromStream(SoapRequest);
    SoapRequest.Position := 0;
    SoapRequest.Size := 0;
    //StringReplace(
    //ReqMemo.Lines.Assign(Lstrlst2);
    Lstrlst2.SaveToStream(SoapRequest, TEncoding.UTF8);
    //SoapRequest.Position := 0;
  finally
    Lstrlst.Free;
    Lstrlst2.Free;
  end;
end;

//Gubun: A: OC 알림
//        B: SMS
//        C: OC -> SMS
function SendHHIMessage(ATXK0SMS2: TXK0SMS2): string;
var
  LRequest: WSTXK0SMS2_REQ;
  LRespond: WSTXK0SMS2_RSP;
begin
  try
    GHTTPRIO1 := THTTPRIO.Create(nil);
    GHTTPRIO1.URL := 'http://biztalk.hhi.co.kr/HHI_IFService/HHI_WebService.asmx';

    if Assigned(GHTTPRIO1) then
    begin
      GHTTPRIO1.OnAfterExecute := GEventHandlers.HTTPRIO1AfterExecute;
      GHTTPRIO1.OnBeforeExecute := GEventHandlers.HTTPRIO1BeforeExecute;

      SetLength(LRequest, 1);
      LRequest[0] := ATXK0SMS2;
      LRespond := (GHTTPRIO1 as HHI_WebServiceSoap).Send_TXK0SMS2(LRequest);
      Result := LRespond.STATUS;
    end;
  finally
    GHTTPRIO1.FreeOnRelease;
  end;
end;

//SMS 메세지 보냄
function SendHHIMessage_SMS(ASendSabun, ARecvSabun, ATitle: string): string;
var
  LRequest: WSTXK0SMS2_REQ;
  LRespond: WSTXK0SMS2_RSP;
  LTXK0SMS2: TXK0SMS2;
begin
  try
    GHTTPRIO1 := THTTPRIO.Create(nil);
    GHTTPRIO1.URL := 'http://biztalk.hhi.co.kr/HHI_IFService/HHI_WebService.asmx';
    LRespond := WSTXK0SMS2_RSP.Create;
    LTXK0SMS2 := TXK0SMS2.Create;
    LTXK0SMS2.SEND_SABUN := ASendSabun;
    LTXK0SMS2.RCV_SABUN := ARecvSabun;//'A379042';
    LTXK0SMS2.SYS_TYPE := '112';
    LTXK0SMS2.NOTICE_GUBUN := 'C';
    LTXK0SMS2.TITLE := ATitle;
    LTXK0SMS2.SEND_HPNO := '010-4190-6742';
    LTXK0SMS2.RCV_HPNO := '010-4190-6742';//'010-3351-7553';
    LTXK0SMS2.CONTENT := 'aaa!';
    LTXK0SMS2.ALIM_HEAD := 'aaa';

    if Assigned(GHTTPRIO1) then
    begin
      GHTTPRIO1.OnAfterExecute := GEventHandlers.HTTPRIO1AfterExecute;
      GHTTPRIO1.OnBeforeExecute := GEventHandlers.HTTPRIO1BeforeExecute;

      SetLength(LRequest, 1);
      LRequest[0] := LTXK0SMS2;
      LRespond := (GHTTPRIO1 as HHI_WebServiceSoap).Send_TXK0SMS2(LRequest);
      Result := LRespond.STATUS;
    end;
  finally
    LTXK0SMS2.Free;
    LRespond.Free;
    LRequest := nil;
    GHTTPRIO1.FreeOnRelease;
  end;
end;

procedure Send_Message_Main_CODE(FFlag,FSendID,FRecvID,FHead,FTitle,FContent:String); // 메세지 메인 함수
var
  LTXK0SMS2 : TXK0SMS2;
begin
  LTXK0SMS2 := TXK0SMS2.Create;
  try
    LTXK0SMS2.SEND_SABUN := FSendID;
    LTXK0SMS2.RCV_SABUN := FRecvID;
    LTXK0SMS2.SYS_TYPE := '112';
    LTXK0SMS2.NOTICE_GUBUN := FFlag;
    LTXK0SMS2.TITLE := FTitle;
    //LTXK0SMS2.SEND_HPNO := '010-4190-6742';
    //LTXK0SMS2.RCV_HPNO := '010-3351-7553';
    LTXK0SMS2.CONTENT := FContent;
    LTXK0SMS2.ALIM_HEAD := FHead;

    SendHHIMessage(LTXK0SMS2);
  finally
    LTXK0SMS2.Free;
  end;
end;

procedure Send_Message_Main_CODE(ARecord: THhiSMSRecord);
var
  LTXK0SMS2 : TXK0SMS2;
begin
  LTXK0SMS2 := TXK0SMS2.Create;
  try
    LTXK0SMS2.SEND_SABUN := ARecord.FSendID;
    LTXK0SMS2.RCV_SABUN := ARecord.FRecvID;
    LTXK0SMS2.SYS_TYPE := '112';
    LTXK0SMS2.NOTICE_GUBUN := ARecord.FFlag;
    LTXK0SMS2.TITLE := ARecord.FTitle;
    //LTXK0SMS2.SEND_HPNO := '010-4190-6742';
    //LTXK0SMS2.RCV_HPNO := '010-3351-7553';
    LTXK0SMS2.CONTENT := ARecord.FContent;
    LTXK0SMS2.ALIM_HEAD := ARecord.FHead;

    SendHHIMessage(LTXK0SMS2);
  finally
    LTXK0SMS2.Free;
  end;
end;

procedure MakeHhiSMSRecord(var ARecord: THhiSMSRecord; AFlag,ASendID,ARecvID,AHead,ATitle,AContent:String);
begin
  with ARecord do
  begin
    FFlag := AFlag;
    FSendID := ASendID;
    FRecvID := ARecvID;
    FHead := AHead;
    FTitle := ATitle;
    FContent := AContent;
  end;
end;

{
initialization
  GHTTPRIO1 := THTTPRIO.Create(nil);
  GHTTPRIO1.URL := 'http://biztalk.hhi.co.kr/HHI_IFService/HHI_WebService.asmx';
  //GHTTPRIO1.WSDLLocation := 'http://biztalk.hhi.co.kr/HHI_IFService/HHI_WebService.asmx?WSDL';
  //GHTTPRIO1.Service := 'HHI_WebService';
  //GHTTPRIO1.Port := 'HHI_WebServiceSoap';

finalization
  if Assigned(GHTTPRIO1) then
    GHTTPRIO1.FreeOnRelease;
}

initialization
  TTextWriter.RegisterCustomJSONSerializerFromText(
    TypeInfo(THhiSMSRecord), __THhiSMSRecord);

end.
