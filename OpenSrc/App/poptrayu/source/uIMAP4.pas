unit uIMAP4;

{-------------------------------------------------------------------------------
POPTRAYU Copyright (C) 2012-2013 Jessica Brown
POPTRAY  Copyright (C) 2003  Renier Crause
All Rights Reserved.

This is free software.

Permission to use, copy, modify, and distribute this software and
its documentation for any purpose, without fee, and without written
agreement is hereby granted, provided that the above copyright
notice appear in all copies of this software.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
-------------------------------------------------------------------------------}
interface

uses
  Windows,
  SysUtils,
  IdComponent,
  IdGlobal,
  IdMessage,
  IdIMAP4,
  uProtocol,
  IdStackConsts,
  Classes,
  IdAttachment, IdAttachmentMemory, System.Generics.Collections,
  IdMailbox,
  IdSASL_CRAM_MD5,
  IdSASLLogin,
  IdSASL_CRAM_SHA1,
  IdUserPassProvider,
  IdSASLUserPass,
  IdSASLPlain,
  IdSASLSKey,
  IdSASLOTP,
  IdSASLExternal,
  IdSASLDigest,
  IdSASLAnonymous,
  IdExplicitTLSClientServerBase,
  IdSSLOpenSSL,
  IdLogFile;

const
   DEST_DOES_NOT_EXIST_MSG = 'Cannot move message because destination mailbox does not exist.';

type
   EInvalidImapFolderException = class(Exception);

type
  TProtocolIMAP4 = class(TProtocol)
  private
    Msg : TIdMessage;

    mSSL : TIdSSLIOHandlerSocketOpenSSL;
    mSSLDisabled : boolean;// = false;

    mIdUserPassProvider: TIdUserPassProvider;
    mIdSASLCRAMMD5: TIdSASLCRAMMD5;
    mIdSASLCRAMSHA1: TIdSASLCRAMSHA1;
    mIdSASLPlain: TIdSASLPlain;
    mIdSASLLogin: TIdSASLLogin;
    mIdSASLSKey: TIdSASLSKey;
    mIdSASLOTP: TIdSASLOTP;
    mIdSASLAnonymous: TIdSASLAnonymous;
    mIdSASLExternal: TIdSASLExternal;
    cmdNum : integer;  // counter for imapCmdNum

    mLastErrorMsg : string;
    mHasErrorToReport : boolean;
    capabilities : TStringList;
    procedure IMAPWork(Sender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
    procedure IdMessage1CreateAttachment(const AMsg: TIdMessage; const AHeaders: TStrings; var AAttachment: TIdAttachment);
    function HasCapa(capability: string) : boolean;
  public
    // general
    IMAP : TIdIMAP4;
    constructor Create;
    // protocol
    procedure Connect(Server : String; Port : integer; UserName,Password : String; TimeOut : integer); override;
    procedure Disconnect; override;
    procedure DisconnectWithQuit; override;
    function Connected : boolean; override;
    function RetrieveHeader(const MsgNum : integer; var pHeader : PChar) : boolean; override;
    function RetrieveRaw(const MsgNum : integer; var pRawMsg : PChar) : boolean; override;
    function RetrieveTop(const MsgNum,LineCount: integer; var pDest: PChar) : boolean; override;
    function RetrieveTopByUID(const UID: String; LineCount: integer; var pDest: PChar) : boolean;
    function RetrieveMsgSize(const MsgNum : integer) : integer; override;
    function UIDL(var UIDLs : TStringList; const MsgNum : integer = -1; const maxUIDs : integer = -1) : boolean; override;
    function Delete(const MsgNum : integer) : boolean; override;
    procedure SetOnWork(const OnWorkProc : TPluginWorkEvent); override;
    function LastErrorMsg : String; override;
    function SupportsSSL : boolean; override;
    function SupportsAPOP : boolean; override;
    function SupportsSASL : boolean; override;
    function SupportsUIDL(): boolean; override;
    function CountMessages(): LongInt; override;
    procedure SetSSLOptions(
      const useSSLorTLS : boolean;
      const authType : TAuthType = password;
      const sslVersion : TsslVer = sslAuto;
      const startTLS : boolean = false); override;
    destructor Destroy; override;
    procedure Expunge;
    function DeleteMsgsByUID(const uidList: TStrings; expunge : boolean = true): boolean;
    function MoveToFolderByUID(const uidList: TStrings; destFolder : string): boolean;
    function UIDRetrievePeekHeader(const UID: String; var outMsg: TIdMessage) : boolean;
    function UIDRetrievePeekEnvelope(const UID: String; var outMsg: TIdMessage) : boolean;
    function RetrieveMsgSizeByUID(const AMsgUID : String) : integer;
    function RetrieveRawByUid(const uid: String; var pRawMsg : PChar) : boolean;
    function MakeRead(const uid : string; isRead : boolean): boolean; override;
    function UIDCheckMsgSeen(const UID: String) : boolean;
    function GetFlags(const uid : string; var outFlags: TIdMessageFlagsSet) : Boolean;
    function GetFlagsBySequenceNumber(const sequenceNum : integer; var outFlags: TIdMessageFlagsSet ) : Boolean;
    function SetImportantFlag(const uid : string; isImportant : boolean): boolean;
    function AddGmailLabelToMsgs(const uidList: TStrings; labelname : string): boolean;
    function AddGmailLabelToMsg(const uid: string; labelname : string) : boolean;
    function RemoveGmailLabelFromMsgs(const uidList: TStrings; labelname : string): boolean;
    function FetchGmailLabels(const uid: String; labels: TStrings): boolean; overload;
    function GetFolderNames(folders : TStringList): boolean;
    function CheckMsgExists(const uid: String): boolean;
    function GetUnreadUIDs(var UIDLs : TStringList; const maxUIDs : integer = -1) : boolean;
    function ConnectionReady() : boolean;
    function CreateIMAPFolder(folderName : String) : boolean;
  protected
    procedure SetLogger(LogFile : TIdLogFile); override;
  end;

  function AddQuotesIfNeeded(input: string) : string;

implementation
uses
    {$IFDEF LOG4D}
    Log4D,
    {$ENDIF}
    Math,
             Dialogs,
  IdLogBase, IdIntercept, uIniSettings, IdReplyIMAP4, IdExceptionCore, IdCoderHeader,
  uGlobal;


type
  TIdIMAP4Access = class(TIdIMAP4);
  TIdIMAPLineStructAccess = class(TIdIMAPLineStruct);


//---------------------------------------------------------- general exports ---

constructor TProtocolIMAP4.Create;
var
  DLL1, DLL2 : THandle;
  //idLogFile1 : TidLogFile;//DEBUG - logging.
begin
  Self.Name := 'IMAP';
  IMAP := TIdIMAP4.Create(nil);
  Msg := TIdMessage.Create(nil);
  Msg.OnCreateAttachment := IdMessage1CreateAttachment;
  Msg.NoEncode := True;
  Msg.NoDecode := True;
  capabilities := TStringList.Create;
  cmdNum := 1;

  IMAP.OnWork := IMAPWork;
  IMAP.MilliSecsToWaitToClearBuffer := 10;

  TProtocol.InitOpenSSL;
  mSSLDisabled := not TProtocol.sslLoaded;

  // pretty much everything inside this IF will fail if the SSL DLLs fail to load
  if (not mSSLDisabled) then begin
    mSSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    mSSL.SSLOptions.Mode := sslmClient;
    mSSL.PassThrough := False;
    mSSL.MaxLineAction := maException;
    mSSL.SSLOptions.VerifyMode := [];
    mSSL.SSLOptions.VerifyDepth := 0;


    mIdUserPassProvider := TIdUserPassProvider.Create(IMAP);

    // Initialize all the available SASL authentication mechnisms
    mIdSASLCRAMMD5 := TIdSASLCRAMMD5.Create(IMAP);
    mIdSASLCRAMMD5.UserPassProvider := mIdUserPassProvider;

    mIdSASLCRAMSHA1 := TIdSASLCRAMSHA1.Create(IMAP);
    mIdSASLCRAMSHA1.UserPassProvider := mIdUserPassProvider;

    mIdSASLPlain := TIdSASLPlain.Create(IMAP);
    mIdSASLPlain.UserPassProvider := mIdUserPassProvider;

    mIdSASLLogin := TIdSASLLogin.Create(IMAP);  // same as sasDefault
    mIdSASLLogin.UserPassProvider := mIdUserPassProvider;

    mIdSASLSKey := TIdSASLSKey.Create(IMAP);
    mIdSASLSKey.UserPassProvider := mIdUserPassProvider;

    mIdSASLOTP := TIdSASLOTP.Create(IMAP);
    mIdSASLOTP.UserPassProvider := mIdUserPassProvider;

    mIdSASLAnonymous := TIdSASLAnonymous.Create(IMAP);
    // doesn't use a IdUserPassProvider

    mIdSASLExternal := TIdSASLExternal.Create(IMAP);
    // doesn't use a IdUserPassProvider


    // The order of the SASL mechanisms is important, they need to be added
    // from most secure to least secure, so the most secure mechanisms are
    // tried first
    IMAP.SASLMechanisms.Add.SASL := mIdSASLCRAMSHA1;
    IMAP.SASLMechanisms.Add.SASL := mIdSASLCRAMMD5;
    IMAP.SASLMechanisms.Add.SASL := mIdSASLSKey;
    IMAP.SASLMechanisms.Add.SASL := mIdSASLOTP;
    IMAP.SASLMechanisms.Add.SASL := mIdSASLAnonymous;
    IMAP.SASLMechanisms.Add.SASL := mIdSASLExternal;
    IMAP.SASLMechanisms.Add.SASL := mIdSASLLogin;
    IMAP.SASLMechanisms.Add.SASL := mIdSASLPlain;


  end;


end;

procedure TProtocolIMAP4.SetLogger(LogFile : TIdLogFile);
begin
  IMAP.Intercept:= TIdConnectionIntercept(LogFile);
end;


destructor TProtocolIMAP4.Destroy;
begin
  if (not mSSLDisabled) then begin
    mIdUserPassProvider.Free;
    mIdSASLCRAMMD5.Free;
    mIdSASLCRAMSHA1.Free;
    mIdSASLSKey.Free;
    mIdSASLOTP.Free;
    mIdSASLAnonymous.Free;
    mIdSASLExternal.Free;
    mIdSASLLogin.Free;
    mIdSASLPlain.Free;
    mSSL.Free;
  end;

  IMAP.Free;
  Msg.Free;
  capabilities.Free;
end;

//function TProtocolIMAP4.ImapCmdNum(): string;
//begin
//  Result := 'C'+IntToStr(cmdNum);
//  inc(cmdNum)
//end;

procedure TProtocolIMAP4.Connect(Server : String; Port : integer; UserName,Password : String; TimeOut : integer);
begin
  IMAP.Host := Server;
  IMAP.Port := Port;
  IMAP.Username := Username;
  IMAP.Password := Password;

  if (not mSSLDisabled) then begin
    mIdUserPassProvider.Username := Username;
    mIdUserPassProvider.Password:= Password;
  end;

  IMAP.ConnectTimeout := TimeOut; // ConnectTimeout expects milliseconds
  IMAP.ReadTimeout := TimeOut;
  IMAP.Connect(false);

  //if (IMAP.IOHandler = mSSL) then begin  //SSL socket read/write timeout
    //IMAP.Socket.Binding.SetSockOpt(Id_SOL_TCP, Id_SO_SNDTIMEO, TimeOut*1000);
    //IMAP.Socket.Binding.SetSockOpt(Id_SOL_TCP, Id_SO_RCVTIMEO, TimeOut*1000);
  //end;

  IMAP.Login;
  IMAP.SelectMailBox('INBOX');
end;


function TProtocolIMAP4.LastErrorMsg : String;
begin
  if (mHasErrorToReport) then
    Result := mLastErrorMsg
  else Result := '';
  mHasErrorToReport := false;
end;

function TProtocolIMAP4.SupportsSSL : boolean;
begin
  Result := not mSSLDisabled;
end;

function TProtocolIMAP4.SupportsAPOP : boolean;
begin
  Result := false;
end;

function TProtocolIMAP4.SupportsSASL : boolean;
begin
  Result := true;
end;


procedure TProtocolIMAP4.Disconnect;
begin
  IMAP.IOHandler.InputBuffer.clear;
  IMAP.Disconnect(false);
end;

procedure TProtocolIMAP4.DisconnectWithQuit;
begin
  if IMAP.Connected then
  begin
    IMAP.IOHandler.InputBuffer.clear;
    IMAP.Disconnect(true);
  end;
end;

function TProtocolIMAP4.Connected : boolean;
begin
  Result := IMAP.Connected;
end;

function TProtocolIMAP4.RetrieveHeader(const MsgNum : integer; var pHeader : PChar) : boolean;
begin
  Msg.Clear;
  IMAP.IOHandler.MaxLineAction := maSplit;
  Result := IMAP.RetrieveHeader(MsgNum,Msg);
  if Result then
    pHeader := Msg.Headers.GetText;
end;

function TProtocolIMAP4.RetrieveRaw(const MsgNum : integer; var pRawMsg : PChar) : boolean;
begin
  Msg.Clear;
  IMAP.IOHandler.MaxLineAction := maSplit;
  Result := IMAP.Retrieve(MsgNum,Msg);
  if Result then
    pRawMsg := StrNew(PChar(Msg.Headers.Text+#13#10+Msg.Body.Text));
end;

function TProtocolIMAP4.RetrieveRawByUid(const uid: String; var pRawMsg : PChar) : boolean;
begin
  Msg.Clear;
  IMAP.IOHandler.MaxLineAction := maSplit;
  Result := IMAP.UIDRetrieve(uid,Msg);
  if Result then
    pRawMsg := StrNew(PChar(Msg.Headers.Text+#13#10+Msg.Body.Text));
end;

function TProtocolIMAP4.RetrieveTopByUID(const UID: String; LineCount: integer; var pDest: PChar) : boolean;
var
  st : string;
begin
  Msg.Clear;
  IMAP.IOHandler.MaxLineAction := maSplit;
  // get header
  Result := IMAP.UIDRetrieveHeader(UID,Msg);
  if Result then
  begin
    // get first LineCount*70 octets
    IMAP.SendCmd('UID FETCH '+UID+' BODY.PEEK[TEXT]<0.'+
                 IntToStr(LineCount*70)+'>', ['FETCH','UID'], true);
    Result := IMAP.LastCmdResult.Code = 'OK';

    if Result then
    begin
      Msg.Body.Clear;
      Msg.Body.AddStrings(IMAP.LastCmdResult.Text);


      pDest := StrNew(PChar(Msg.Headers.Text+#13#10+Msg.Body.Text));
    end;
  end;
end;


function TProtocolIMAP4.RetrieveTop(const MsgNum,LineCount: integer; var pDest: PChar) : boolean;
begin
  raise Exception.Create('Method not supported. Use RetrieveTopByUID instead');
end;

function TProtocolIMAP4.RetrieveMsgSize(const MsgNum : integer) : integer;
begin
  Result := IMAP.RetrieveMsgSize(MsgNum);
end;

function TProtocolIMAP4.RetrieveMsgSizeByUID(const AMsgUID : String) : integer;
begin
  Result := IMAP.UIDRetrieveMsgSize(AMsgUID);
end;

function TProtocolIMAP4.UIDL(var UIDLs : TStringList; const MsgNum : integer = -1; const maxUIDs : integer = -1) : boolean;
var
  UID : string;
  i, nCount, startMsg : integer;
begin

  if MsgNum > -1 then
  begin
    Result := IMAP.GetUID(MsgNum, UID);
    UIDLs.Add(IntToStr(MsgNum) + ' ' + (*'UID' +*) UID (*+ '-' + IMAP.MailBox.UIDValidity*));
  end
  else begin  //get a list of all UIDs in mailbox
    nCount := IMAP.MailBox.TotalMsgs; //number of messages on the server

    if maxUIDs <= 0 then
      startMsg := 1
    else begin
      startMsg := Math.Min(nCount, nCount - maxUIDs);
      startMsg := Math.Max(startMsg, 1);
    end;

    for i := startMsg to nCount do  //Relative message numbers start from 1 and go up according to INDY docs
    begin
      UID := '';
      try
        IMAP.GetUID(i, UID);
      except
        on E : Exception do begin
          {$IFDEF LOG4D}
          TLogLogger.GetLogger('poptrayuLogger').Debug('TProtocolIMAP4.UIDL() Fetch Error'+#13#10+'Exception class name = '+E.ClassName+ #13#10 +'Exception message = '+E.Message);
          {$ENDIF}
          UID := '';
        end;
      end;
      if UID <> '' then begin
        UIDLs.Add(IntToStr(i) + ' ' + (*'UID' +*) UID (*+ '-' + IMAP.MailBox.UIDValidity *));
      end;
    end;
    Result := True;
  end;
  if (Result = false) then begin
    {$IFDEF LOG4D}
    TLogLogger.GetLogger('poptrayuLogger').Debug('TProtocolIMAP4.UIDL() FALSE'+#13#10+UIDLs.CommaText);
    {$ENDIF}
  end;
end;

function TProtocolIMAP4.GetUnreadUIDs(var UIDLs : TStringList; const maxUIDs : integer = -1) : boolean;
var
  SearchInfo: array of TIdIMAP4SearchRec;
  I, firstIndex, lastIndex : integer;
begin
  Result := false;
  // if the mailbox selection succeed, then...
  if IMAP.SelectMailBox('INBOX') then
  begin
    SetLength(SearchInfo, 1); // set length of the search criteria to 1
    SearchInfo[0].SearchKey := skUnseen;
    // TODO: to expand this search key idea to do a full gmail style body text search see
    // http://stackoverflow.com/questions/13612968/how-to-search-for-a-specific-e-mail-message-in-imap-mailbox

    if IMAP.UIDSearchMailBox(SearchInfo) then
    begin
      // iterate the search results

      lastIndex := High(IMAP.MailBox.SearchResult);
      if maxUIDs <= 0 then
        firstIndex := 0
      else
        firstIndex := Math.Max(Math.Min(lastIndex, lastIndex - maxUIDs), 0);


      for I := firstIndex to lastIndex do
      begin
        // this is a little bit of a hack. the function calling this is expecting a map of ID->UID
        // but for IMAP we don't do anything by ID, so fake the ID column with UID so we don't have
        // to waste bandwidth asking for the sequential IDs
        uidls.Add(intToStr(IMAP.MailBox.SearchResult[i]) + ' ' + intToStr(IMAP.MailBox.SearchResult[i]));
      end;
      Result := true;
    end;
  end;

end;




function TProtocolIMAP4.Delete(const MsgNum : integer) : boolean;
begin
  Result := IMAP.DeleteMsgs([MsgNum]);
end;

procedure  TProtocolIMAP4.Expunge();
begin
  IMAP.ExpungeMailBox;
end;


procedure TProtocolIMAP4.SetOnWork(const OnWorkProc : TPluginWorkEvent);
begin
  OnWork := OnWorkProc;
end;

{ TIMAPWorkObject }

procedure TProtocolIMAP4.IMAPWork(Sender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
begin
  if Assigned(OnWork) then
    OnWork(AWorkCount);
end;



// called right before connecting.
procedure TProtocolIMAP4.SetSSLOptions(
  const useSSLorTLS : boolean;
  const authType : TAuthType = password;
  const sslVersion : TsslVer = sslAuto;
  const startTLS : boolean = false);
begin
  if (not mSSLDisabled) and (useSSLorTLS) then
  begin
    if (IMAP.Connected) then begin
      IMAP.IOHandler.InputBuffer.clear;
      IMAP.Disconnect();
    end;

    IMAP.IOHandler := mSSL;


    case (sslVersion) of
      sslAuto :  mSSL.SSLOptions.Method := sslvSSLv23;// 23 = special value, means auto
      sslv2 :    mSSL.SSLOptions.Method := sslvSSLv2;
      sslv3 :    mSSL.SSLOptions.Method := sslvSSLv3;
      tlsv1 :    mSSL.SSLOptions.Method := sslvTLSv1;
      tlsv11 :   mSSL.SSLOptions.Method := sslvTLSv1_1;
      tlsv12 :   mSSL.SSLOptions.Method := sslvTLSv1_2;
    end;

    if (startTLS) then
      IMAP.UseTLS := utUseExplicitTLS
    else
      IMAP.UseTLS := utUseImplicitTLS;
  end
  else
  begin
    IMAP.IOHandler := nil;
    IMAP.UseTLS := utNoTLSSupport;
  end;

  case (authType) of
    autoAuth:
      if (not mSSLDisabled)
        then IMAP.AuthType := iatSASL
      else IMAP.AuthType := DEF_IMAP4_AUTH;
    password:
      IMAP.AuthType := iatUserPass;
    //apop:
    //  IMAP.AuthType := iatAPOP;
    sasl:
      if (not mSSLDisabled) then
        IMAP.AuthType := iatSASL;
    else
      IMAP.AuthType := DEF_IMAP4_AUTH; //i.e. password
  end;

  if (mSSLDisabled and useSSLorTLS) then begin
    mHasErrorToReport := true;
    mLastErrorMsg := 'Account configured for SSL, but SSL is not available.';
  end;
end;


// This method expects to already be connected.
// Returns true if server supports UIDL, false otherwise
function TProtocolIMAP4.SupportsUIDL(): boolean;
begin
  Result:=true;
end;

function TProtocolIMAP4.CountMessages(): LongInt;
begin
  if IMAP.SelectMailBox('INBOX') then begin
    Result := IMAP.MailBox.TotalMsgs;
  end else Result := -1;
end;


// throws EIdReadTimeout
function TProtocolIMAP4.DeleteMsgsByUID(const uidList: TStrings; expunge : boolean): boolean;
begin
    Result := IMAP.UIDDeleteMsgs(uidList.ToStringArray);

    if (expunge) then
      if HasCapa('UIDPLUS') then
        IMAP.SendCmd('UID EXPUNGE '+uidList.commaText, ['EXPUNGE'])
      else
        IMAP.ExpungeMailBox();
end;

// moves messages to the SPAM or other folder.
// does not expunge.
function TProtocolIMAP4.MoveToFolderByUID(const uidList: TStrings; destFolder : string): boolean;
var
  mbName : string;
  mbExists : boolean;
begin

  if (uidList = nil) or (uidList.Count < 1) then begin
    Result := false;
    Exit;
  end;

  // If server supports RFC 6851 (MOVE Extension) https://tools.ietf.org/html/rfc6851
  if HasCapa('MOVE') then begin
    // add quotation marks around the folder name if it has spaces in it
    if (pos(' ',destFolder)<>0) then    // POS is one based: "not found" = 0 and "first char" = 1
      if (pos('"',destFolder)<>1) then
        destFolder := '"'+destFolder + '"';

    try
      IMAP.SendCmd('UID MOVE '+uidList.CommaText +' '+destFolder, ['OK', 'EXISTS', 'EXPUNGE'], true);
      Result := IMAP.LastCmdResult.Code = IMAP_OK;

      // if deleting/moving/archiving failed, check whether the folder we tried to move to exists
      if not Result then begin
        mbName := IMAP.MailBox.Name;
        mbExists := IMAP.SelectMailBox(destFolder);
        IMAP.SelectMailBox(mbName);

        // if folder did not exist, throw that back to the caller to show an error message
        // specific to fixing the invalid folder problem.
        if not mbExists then raise EInvalidImapFolderException.Create(DEST_DOES_NOT_EXIST_MSG);
      end;
    except
      on E1 : EInvalidImapFolderException do raise; // re-throw the folder error
      on E : Exception do begin // for any other exception, indicate generic failure
        Result := false;
      end;
    end;
  end else begin
    // server does not support MOVE so COPY and then DELETE and EXPUNGE the original
    Result := IMAP.UIDCopyMsgs(uidList, destFolder);
    if (Result) then
      DeleteMsgsByUID(uidList);
  end;

end;

function TProtocolIMAP4.CreateIMAPFolder(folderName : String) : boolean;
var
  mbName : string;
begin
  mbName := IMAP.MailBox.Name;
  try
    Result := IMAP.CreateMailBox(foldername);
    if Result then
      Result := IMAP.SelectMailBox(folderName); //check the created folder now exists
  except
    begin
      Result := false;
    end;
  end;
  IMAP.SelectMailBox(mbName); //change selected folder back to original
end;



procedure TProtocolIMAP4.IdMessage1CreateAttachment(const AMsg: TIdMessage; const AHeaders: TStrings; var AAttachment: TIdAttachment);
begin
  AAttachment := TIdAttachmentMemory.Create(AMsg.MessageParts);
end;


function TProtocolIMAP4.UIDRetrievePeekHeader(const UID: String; var outMsg: TIdMessage) : boolean;
begin
  Result := IMAP.UIDRetrieveHeader(UID, outMsg);
end;

function TProtocolIMAP4.UIDRetrievePeekEnvelope(const UID: String; var outMsg: TIdMessage) : boolean;
begin
  Result := IMAP.UIDRetrieveEnvelope(UID, outMsg);

  // Bug Fix: a certain percentage of messages (about 5-10%) seem to not download correctly with
  // only envelopes downloaded. Usually this shows up as the subject or sender not being parsed.
  // For messages that are affected by this, fall back to downloading the full-headers instead
  // of the envelope.
  if (Result = false) OR ((outMsg.Subject = '') OR (outMsg.Sender.Address = '')) then
    Result := IMAP.UIDRetrieveHeader(UID, outMsg)
  else
    // Retrieve Envelope does not automatically decode UTF-8, etc. in the headers the way
    // Retrieve Header does. Must manually call decode functions for each envelope field.
    try
      outMsg.Subject := DecodeHeader(outMsg.Subject);
      DecodeAddresses(outMsg.FromList.EMailAddresses, outMsg.FromList);
      DecodeAddress(outMsg.Sender);
      DecodeAddresses(outMsg.ReplyTo.EMailAddresses, outMsg.ReplyTo);
      DecodeAddresses(outMsg.Recipients.EMailAddresses, outMsg.Recipients);
      DecodeAddresses(outMsg.CCList.EMailAddresses, outMsg.CCList);
      DecodeAddresses(outMsg.BccList.EMailAddresses, outMsg.BccList);
    except

    end;
end;

// @Throws EIdNumberInvalid, EIdConnectionStateError
function TProtocolIMAP4.UIDCheckMsgSeen(const UID: String) : boolean;
begin
  Result := IMAP.UIDCheckMsgSeen(UID);
end;

//------------------------------------------------------------------------------
// MakeRead
//
// Changes the "read" or "seen" status on a message. Expects connection to
// already be open.
//------------------------------------------------------------------------------
function TProtocolIMAP4.MakeRead(const uid : string; isRead : boolean) : boolean;
var
  flags : TidMessageFlagsSet;
begin
  IMAP.UIDRetrieveFlags(uid, flags);
  if (isRead) then
    IMAP.UIDStoreFlags(uid, sdReplace, flags + [mfSeen])
  else
    IMAP.UIDStoreFlags(uid, sdReplace, flags - [mfSeen]);

    //TODO: this way is more efficient but doesn't work yet b/c of a bug in indy
//  if (isRead) then
//    IMAP.UIDStoreFlags(uid, sdAddSilent, [mfSeen])
//  else
//    IMAP.UIDStoreFlags(uid, sdRemoveSilent, [mfSeen]);

  Result := true;
end;

//------------------------------------------------------------------------------
// SetImportantFlag
//------------------------------------------------------------------------------
function TProtocolIMAP4.SetImportantFlag(const uid : string; isImportant : boolean): boolean;
 var
  flags : TidMessageFlagsSet;
begin
  IMAP.UIDRetrieveFlags(uid, flags);
  if (isImportant) then
    IMAP.UIDStoreFlags(uid, sdReplace, flags + [mfFlagged])
  else
    IMAP.UIDStoreFlags(uid, sdReplace, flags - [mfFlagged]);

    //TODO: this way is more efficient but doesn't work yet b/c of a bug in indy
//  if (isImportant) then
//    IMAP.UIDStoreFlags(uid, sdAddSilent, [mfFlagged])
//  else
//    IMAP.UIDStoreFlags(uid, sdRemoveSilent, [mfFlagged]);

  Result := true;
end;

//------------------------------------------------------------------------------
// GetFlags
//
// @throws EIdNumberInvalid exception when AMsgUID contains an invalid value for use as a UID.
// @throws EIdConnectionStateError if connection state is not csSelected
//------------------------------------------------------------------------------
function TProtocolIMAP4.GetFlags(const uid : string; var outFlags: TIdMessageFlagsSet ) : Boolean;
begin
  Result := IMAP.UIDRetrieveFlags(uid, outFlags);
end;

//------------------------------------------------------------------------------
// GetFlags
//
// @throws EIdNumberInvalid exception when AMsgUID contains an invalid value for use as a UID.
// @throws EIdConnectionStateError if connection state is not csSelected
//------------------------------------------------------------------------------
function TProtocolIMAP4.GetFlagsBySequenceNumber(const sequenceNum : integer; var outFlags: TIdMessageFlagsSet ) : Boolean;
begin
  Result := IMAP.RetrieveFlags(sequenceNum, outFlags);
end;

// Exceptions for IMAP:EIdIMAP4ServerException, EIdIMAP4ImplicitTLSRequiresSSL,
// EIdReplyIMAP4Error


// Wrapper to check whether the server has a specific IMAP capability.
// This will populate the capablity list only if it has not already been filled
// so it doesn't call CAPA every single deletion, etc.
function TProtocolIMAP4.HasCapa(capability: string) : boolean;
begin
  if (capabilities.count = 0) then begin
    IMAP.Capability(capabilities);
  end;
  Result := (capabilities.IndexOf(capability)<>-1);
end;

function TProtocolIMAP4.AddGmailLabelToMsgs(const uidList: TStrings; labelname : string) : boolean;
begin
  Result := false;
  if (uidList.Count > 0) then
    Result := AddGmailLabelToMsg(uidList.CommaText, labelname);
end;

function TProtocolIMAP4.AddGmailLabelToMsg(const uid: string; labelname : string) : boolean;
begin
  try
    if HasCapa('X-GM-EXT-1') and (labelname <> '') then begin
      IMAP.SendCmd('UID STORE '+uid+' +X-GM-LABELS ("'+ labelname + '")',['UID','STORE','FETCH','SEARCH'], true);
      Result := IMAP.LastCmdResult.Code = 'OK';
    end else
      Result := false;
  except
    on E : Exception do
     begin
       //Dialogs.ShowMessage('Exception class name = '+E.ClassName);
       //Dialogs.ShowMessage('Exception message = '+E.Message);
       Result := false;
     end;
  end;
end;


function TProtocolIMAP4.RemoveGmailLabelFromMsgs(const uidList: TStrings; labelname : string): boolean;
begin
  try
    if HasCapa('X-GM-EXT-1') and (uidList.Count >0) and (labelname <> '')  then begin
      IMAP.SendCmd('UID STORE '+uidList.CommaText+' -X-GM-LABELS ("'+ labelname + '")',['UID','FETCH'], true);
      Result := IMAP.LastCmdResult.Code = 'OK';
    end else
      Result := false;
  except
    Result := false;
  end;
end;

// TStrings.CommaText can be substituted for uid for multiple uids
function TProtocolIMAP4.FetchGmailLabels(const uid: String; labels: TStrings): boolean;
var
  labelsStr : string;
begin
  Result := false;
  try
    if HasCapa('X-GM-EXT-1') and (uid <> '') and (labels <> nil)  then begin
      IMAP.SendCmd('UID FETCH '+uid+' (X-GM-LABELS)',['FETCH','UID'], false);
      labels.Clear;


      // a010 FETCH 1 (X-GM-LABELS)
      //
      // * 1 FETCH (X-GM-LABELS (\Inbox \Sent Important "Muy Importante"))
      // a010 OK FETCH (Success)

      if IMAP.LastCmdResult.Text.Count > 0 then
      begin
        labelsStr := IMAP.LastCmdResult.Text[0];
        //System.Delete(labelsStr,0,Pos('X-GM-LABELS',labelsStr)+12);
        //ExtractStrings(['(',')'],[' '],PChar(labelsStr), labels);

        if TIdIMAP4Access(IMAP).ParseLastCmdResult(IMAP.LastCmdResult.Text[0], 'FETCH', ['X-GM-LABELS']) then begin
          labelsStr := TIdIMAPLineStructAccess(TIdIMAP4Access(IMAP).FLineStruct).IMAPValue;
          ExtractStrings(['''','"',' '],[' '],PChar(labelsStr), labels);
        end;

        Result := IMAP.LastCmdResult.Code = 'OK';
      end;
    end else
      Result := false;
  except
    Result := false;
  end;
end;


function TProtocolIMAP4.GetFolderNames(folders : TStringList): boolean;
begin
  Result := IMAP.ListMailBoxes(folders);
end;

function TProtocolIMAP4.CheckMsgExists(const uid: String): boolean;
var
  AFlags: TIdMessageFlagsSet;
begin
  Result := IMAP.UIDRetrieveFlags(uid, AFlags); //returns false when message doesn't exist
end;

function TProtocolIMAP4.ConnectionReady() : boolean;
var
  connState : TIdIMAP4ConnectionState;
begin
  result := false;
  try
    connState := TIdIMAP4Access(IMAP).CheckConnectionState(csSelected);
    case connState of
      csSelected:
        result := true;
      csAny, csNonAuthenticated, csAuthenticated, csUnexpectedlyDisconnected:
        result := false;
    end;
  except
    on e : EIdConnectionStateError do
      //nothing, leave result := false
  end;
end;



function AddQuotesIfNeeded(input: string) : string;
begin
    if (pos(' ',input)<>-1) and ((FindDelimiter('"',input)<>1) and (LastDelimiter('"',input)>1)) then
    Result := '"'+input + '"';
end;


end.
