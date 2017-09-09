unit uPOP3;

{-------------------------------------------------------------------------------
POPTRAY
Copyright (C) 2003-2005  Renier Crause
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
  Classes, SysUtils,
  IdPOP3, IdMessage, IdComponent, IdExplicitTLSClientServerBase,
  uProtocol, Dialogs, IdAttachment,
  IdSASL_CRAM_MD5, IdSASLLogin, IdSASL_CRAM_SHA1, IdUserPassProvider, //SASL
  IdSASLUserPass, IdSASLPlain, IdSASLSKey,                            //SASL
  IdSASLOTP, IdSASLExternal, IdSASLDigest, IdSASLAnonymous,           //SASL
  IdSSLOpenSSL, IdLogFile;

const
  CONNECT_ERR_NO_HOST_STR = 'Server is a required field, and may not be blank.';

type
  TProtocolPOP3 = class(TProtocol)
  private
    mSSL : TIdSSLIOHandlerSocketOpenSSL;
    mTimeout : integer;
    mSSLDisabled : boolean;// = false;

    IdUserPassProvider: TIdUserPassProvider;
    IdSASLCRAMMD5: TIdSASLCRAMMD5;
    IdSASLCRAMSHA1: TIdSASLCRAMSHA1;
    IdSASLPlain: TIdSASLPlain;
    IdSASLLogin: TIdSASLLogin;
    IdSASLSKey: TIdSASLSKey;
    IdSASLOTP: TIdSASLOTP;
    IdSASLAnonymous: TIdSASLAnonymous;
    IdSASLExternal: TIdSASLExternal;

    mLastErrorMsg : string;
    mHasErrorToReport : boolean;
    autoAuthMode : boolean;

    procedure POPWork(Sender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64); //indy10
    procedure IdMessage1CreateAttachment(const AMsg: TIdMessage; const AHeaders: TStrings; var AAttachment: TIdAttachment);
    procedure ShowHttpStatus(ASender: TObject; const AStatus: TIdStatus; const AStatusText: string);
    procedure OnHttpConnected(Sender: TObject);
  public
    POP : TIdPOP3;
    constructor Create;
    procedure Connect(Server : String; Port : integer; UserName,Password : String; TimeOut : integer); override;
    procedure Disconnect; override;
    procedure DisconnectWithQuit; override;
    function Connected : boolean; override;
    function RetrieveHeader(const MsgNum : integer; var pHeader : PChar) : boolean; override;
    function RetrieveRaw(const MsgNum : integer; var pRawMsg : PChar) : boolean; override;
    function RetrieveTop(const MsgNum,LineCount: integer; var pDest: PChar) : boolean; override;
    function RetrieveMsgSize(const MsgNum : integer) : integer; override;
    function UIDL(var UIDLs : TStringList; const MsgNum : integer = -1; const maxUIDs : integer = -1) : boolean; override;
    function Delete(const MsgNum : integer) : boolean; override;
    procedure SetOnWork(const OnWorkProc : TPluginWorkEvent); override;
    procedure SetSSLOptions(
      const useSSLorTLS : boolean;
      const authType : TAuthType = password;
      const sslVersion : TsslVer = sslAuto;
      const startTLS : boolean = false); override;
    destructor Destroy; override;
    function LastErrorMsg : String; override;
    function SupportsSSL : boolean; override;
    function SupportsAPOP : boolean; override;
    function SupportsSASL : boolean; override;
    function SupportsUIDL(): boolean; override;
    function CountMessages(): LongInt; override;
    function MakeRead(const uid : string; isRead : boolean): boolean; override; //not supported. error case if called.
  protected
    procedure SetLogger(LogFile : TIdLogFile); override;
  end;

implementation
  uses
    IdIMap4,  //for wsOk indy10
    IdHTTP, IdStackConsts, Windows,
    IdException, IdExceptionCore, IdStack,  IdSASLCollection,
    IdIntercept, IdAttachmentMemory, IdGlobal, IdReplyPOP3,
    uIniSettings, uGlobal;
  //const
  //  debugPop = false;

{ TProtocolPOP3 }

constructor TProtocolPOP3.Create;
begin
  Self.Name := 'POP3';
  //Self.ProtocolType := protPOP3;
  POP := TidPOP3.Create(nil);
  autoAuthMode := true;


  TProtocol.InitOpenSSL;
  mSSLDisabled := not TProtocol.sslLoaded;

  // pretty much everything inside this IF will fail if the SSL DLLs fail to load
  if (not mSSLDisabled) then begin
    mSSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    mSSL.SSLOptions.Mode := sslmClient;
    mSSL.PassThrough := False;

    IdUserPassProvider := TIdUserPassProvider.Create(POP);

    // Initialize all the available SASL authentication mechnisms
    IdSASLCRAMMD5 := TIdSASLCRAMMD5.Create(POP);
    IdSASLCRAMMD5.UserPassProvider := IdUserPassProvider;

    IdSASLCRAMSHA1 := TIdSASLCRAMSHA1.Create(POP);
    IdSASLCRAMSHA1.UserPassProvider := IdUserPassProvider;

    IdSASLPlain := TIdSASLPlain.Create(POP);
    IdSASLPlain.UserPassProvider := IdUserPassProvider;

    IdSASLLogin := TIdSASLLogin.Create(POP);  // same as sasDefault
    IdSASLLogin.UserPassProvider := IdUserPassProvider;

    IdSASLSKey := TIdSASLSKey.Create(POP);
    IdSASLSKey.UserPassProvider := IdUserPassProvider;

    IdSASLOTP := TIdSASLOTP.Create(POP);
    IdSASLOTP.UserPassProvider := IdUserPassProvider;

    IdSASLAnonymous := TIdSASLAnonymous.Create(POP);
    // doesn't use a IdUserPassProvider

    IdSASLExternal := TIdSASLExternal.Create(POP);
    // doesn't use a IdUserPassProvider


    // The order of the SASL mechanisms is important, they need to be added
    // from most secure to least secure, so the most secure mechanisms are
    // tried first
    POP.SASLMechanisms.Add.SASL := IdSASLCRAMSHA1;
    POP.SASLMechanisms.Add.SASL := IdSASLCRAMMD5;
    POP.SASLMechanisms.Add.SASL := IdSASLSKey;
    POP.SASLMechanisms.Add.SASL := IdSASLOTP;
    POP.SASLMechanisms.Add.SASL := IdSASLAnonymous;
    POP.SASLMechanisms.Add.SASL := IdSASLExternal;
    POP.SASLMechanisms.Add.SASL := IdSASLLogin;
    POP.SASLMechanisms.Add.SASL := IdSASLPlain;

  end;

  mTimeout := 10000; //default timeout

  POP.OnWork := POPWork;
end;

procedure TProtocolPOP3.SetLogger(LogFile : TIdLogFile);
begin
  POP.Intercept := TIdConnectionIntercept(LogFile);
end;

// SSL options will be disabled for this protocol if the SSL plugin dlls
// did not load correctly in the constructor.
function TProtocolPOP3.SupportsSSL() : boolean;
begin
  Result := not mSSLDisabled;
end;

procedure TProtocolPOP3.ShowHttpStatus(ASender: TObject; const AStatus: TIdStatus; const AStatusText: string);
begin
{  case AStatus of
    hsResolving: ShowMessage('resolving...');
    hsConnecting: ShowMessage('connecting...');
    hsConnected: ShowMessage('connected...');
    hsDisconnecting: ShowMessage('disconnecting...');
    hsDisconnected: ShowMessage('disconnected...');
  end;     }
  //Update;
end;

procedure TProtocolPOP3.OnHttpConnected(Sender: TObject);
begin
{  with TIdHTTP(Sender).Socket.Binding do
  begin
    SetSockOpt(Id_SOL_SOCKET, Id_SO_RCVTIMEO, mTimeout);
    SetSockOpt(Id_SOL_SOCKET, Id_SO_SNDTIMEO, mTimeout);
  end; }
end;

procedure TProtocolPOP3.Connect(Server: String; Port: integer; UserName, Password: String; TimeOut: integer);
var
  doneTryingConnectionModes: boolean;
begin
  if (mSSLDisabled and mHasErrorToReport) then begin
    // error already logged in SSL options, return to avoid trying to connect
    // in plaintext on ssl port
    exit;
  end;

  POP.Host := Server;
  POP.Port := Port;
  POP.Username := Username;
  POP.Password := Password;
  POP.ReadTimeout := TimeOut;

  if (not mSSLDisabled) then begin
    IdUserPassProvider.Username := Username;
    IdUserPassProvider.Password:= Password;
  end;

  POP.OnStatus := ShowHttpStatus;
  POP.OnConnected := OnHttpConnected;

  mTimeout := TimeOut;


  Pop.ConnectTimeout := TimeOut;
  Pop.ReadTimeout := TimeOut;

  Repeat
    doneTryingConnectionModes := true;
    try
      POP.Connect();
    except
      on e : EIdDoesNotSupportAPOP do begin
        mHasErrorToReport := true;
        mLastErrorMsg := 'Server does not support APOP Authentication. Advanced account settings need to be modified.';
      end;
      on e : EIdSASLNotSupported do begin
        if (autoAuthMode) then begin
          // change connection mode (internally) to PASS since AUTH failed, and retry.
          POP.AuthType := patUserPass;
          doneTryingConnectionModes := false;
        end
        else begin
            mHasErrorToReport := true;
            mLastErrorMsg := 'Server does not support SASL Authentication mode. Advanced account settings need to be modified.';
        end;
      end;
      on e : EIdHostRequired do begin
        mHasErrorToReport := true;
        mLastErrorMsg := CONNECT_ERR_NO_HOST_STR;
      end;
      on e : EIdReadTimeout do begin
        mHasErrorToReport := true;
        mLastErrorMsg := 'Server did not respond in a reasonable amount of time. Unable to connect.';
      end;
      on e : EIdSocketError do begin
         mHasErrorToReport := true;
        mLastErrorMsg := 'Socket Error. Unable to connect.'+e.Message;
      end;
    end;
  Until doneTryingConnectionModes;


  // Set timeout for send/receive for SSL/TLS connections only.
  if (POP.UseTLS <> utNoTLSSupport) then begin
    //POP.Socket.Binding.SetSockOpt(Id_SOL_TCP, Id_SO_SNDTIMEO, TimeOut);
    //POP.Socket.Binding.SetSockOpt(Id_SOL_TCP, Id_SO_RCVTIMEO, mTimeout);
  end;
end;


function TProtocolPOP3.LastErrorMsg : String;
begin
  if (mHasErrorToReport) then
    Result := mLastErrorMsg
  else Result := '';
  mHasErrorToReport := false;
end;

procedure TProtocolPOP3.Disconnect;
begin
  if POP.Connected then
  begin
    POP.IOHandler.InputBuffer.clear; //Indy10 - need to clear input buffer to avoid already connected errors later.
    POP.Disconnect(false);
  end;
end;

procedure TProtocolPOP3.DisconnectWithQuit;
begin
  if POP.Connected then
  begin
    POP.IOHandler.InputBuffer.clear;
    POP.Disconnect(true);
  end;
end;

function TProtocolPOP3.Connected: boolean;
begin
  Result := POP.Connected;
end;

procedure TProtocolPOP3.IdMessage1CreateAttachment(const AMsg: TIdMessage; const AHeaders: TStrings; var AAttachment: TIdAttachment);
begin
  AAttachment := TIdAttachmentMemory.Create(AMsg.MessageParts);
end;

function TProtocolPOP3.RetrieveHeader(const MsgNum: integer; var pHeader: PChar): boolean;
var
  AMsg : TIdMessage;
begin
  AMsg := TIdMessage.Create(nil);
  AMsg.OnCreateAttachment := IdMessage1CreateAttachment;

  POP.IOHandler.MaxLineAction := maSplit;

  try
    try
    Result := POP.RetrieveHeader(MsgNum,AMsg);
    except on e : Exception do
      Result := false;
    end;
  finally
    pHeader := AMsg.Headers.GetText;
    AMsg.Free;
  end;
end;

function TProtocolPOP3.RetrieveRaw(const MsgNum: integer; var pRawMsg: PChar): boolean;
var
  RawMsg : TStringList;
begin
  RawMsg := TStringList.Create;

  POP.IOHandler.MaxLineAction := maSplit;

  try
    try
      Result := POP.RetrieveRaw(MsgNum,RawMsg);
      pRawMsg := RawMsg.GetText;
    except on E : Exception do
      begin
        Result := false;
      end;
    end;
  finally
    RawMsg.Free;
  end;
end;

function TProtocolPOP3.RetrieveTop(const MsgNum,LineCount: integer; var pDest: PChar) : boolean;
var
  Dest : TStringList;
begin

  POP.IOHandler.MaxLineAction := maSplit;

  // send TOP command
  POP.SendCmd('TOP '+IntToStr(MsgNum)+' '+IntToStr(LineCount));
  Result := POP.LastCmdResult.Code = '+OK';
  if Result then
  begin
    Dest := TStringList.Create;
    try
      POP.IOHandler.Capture(Dest);
      pDest := Dest.GetText;
    finally
      Dest.Free;
    end;
  end;
end;

function TProtocolPOP3.RetrieveMsgSize(const MsgNum: integer): integer;
begin
  Result := POP.RetrieveMsgSize(MsgNum);
end;

function TProtocolPOP3.UIDL(var UIDLs : TStringList; const MsgNum: integer = -1; const maxUIDs : integer = -1): boolean;
begin
  // maxUIDs is ignored, only supported for IMAP.
  Result := POP.UIDL(UIDLs,MsgNum);
end;

// This method expects to already be connected.
// Returns true if server supports UIDL, false otherwise
//
// If CAPA(bilities) is not supported by the server, we can get a false result
// that UIDL is not supported. Querying UIDL (with no parameter) is very slow
// for a large inbox. Most servers support both UIDL and CAPA, so this will
// be very fast in the average case, and only a little slower if UIDL is not
// supported or CAPA is not supported.
//
function TProtocolPOP3.SupportsUIDL(): boolean;
//var
  //capaSupport : boolean;
begin
  if (POP.HasCAPA) then begin
    //Result := POP.SendCmd('CAPA UIDL',ST_OK)=ST_OK; {Do not Localize}
    Result := POP.Capabilities.IndexOf('UIDL') <> -1;
  end
  else begin
    // if inbox is empty "-ERR There's no message 1" is expected.
    Result := POP.SendCmd('UIDL 1',ST_OK)=ST_OK; {Do not Localize}
    if (Result = true) then exit; //UIDL succeeded for msg 1

    // Most reliable (but slowest) way: Return value of UIDL is +OK followed by
    // a list of UIDLs or -ERR if UIDL is not supported.
    Result := POP.SendCmd('UIDL', ST_OK)=ST_OK; {Do not Localize}
  end;

end;

function TProtocolPOP3.CountMessages(): LongInt;
begin
  Result:=POP.CheckMessages();
end;

function TProtocolPOP3.Delete(const MsgNum: integer): boolean;
begin
  Result := POP.Delete(MsgNum);
end;

procedure TProtocolPOP3.POPWork(Sender: TObject; AWorkMode: TWorkMode;
  {$IFDEF INDY9} const AWorkCount: Integer {$ELSE} AWorkCount: Int64 {$ENDIF});
begin
  if Assigned(OnWork) then
    OnWork(AWorkCount);
end;

procedure TProtocolPOP3.SetOnWork(const OnWorkProc: TPluginWorkEvent);
begin
  OnWork := OnWorkProc;
end;

function TProtocolPOP3.SupportsAPOP : boolean;
begin
  Result := true;
end;

function TProtocolPOP3.SupportsSASL : boolean;
begin
  Result := true;
end;

// called right before connecting.
procedure TProtocolPOP3.SetSSLOptions(
  const useSSLorTLS : boolean;
  const authType : TAuthType = password;
  const sslVersion : TsslVer = sslAuto;
  const startTLS : boolean = false);
begin
  if (not mSSLDisabled) and (useSSLorTLS) then //Pos('SSL',Protocol) > 0 then
  begin
    POP.IOHandler := mSSL;


    case (sslVersion) of
      sslAuto :  mSSL.SSLOptions.Method := sslvSSLv23;// 23 = special value, means auto
      sslv2 :    mSSL.SSLOptions.Method := sslvSSLv2;
      sslv3 :    mSSL.SSLOptions.Method := sslvSSLv3;
      tlsv1 :    mSSL.SSLOptions.Method := sslvTLSv1;
      tlsv11 :   mSSL.SSLOptions.Method := sslvTLSv1_1;
      tlsv12 :   mSSL.SSLOptions.Method := sslvTLSv1_2;
    end;

    try
    if (startTLS) then
      POP.UseTLS := utUseExplicitTLS
    else
      POP.UseTLS := utUseImplicitTLS;
    except on EIdTLSClientCanNotSetWhileConnected do begin end;
    end;
  end
  else
  begin
    POP.IOHandler := nil;
    POP.UseTLS := utNoTLSSupport;
  end;

  if (authType = autoAuth) then
    autoAuthMode := true
  else autoAuthMode := false;

  case (authType) of
    autoAuth:
      if (not mSSLDisabled)
        then POP.AuthType := patSASL
      else POP.AuthType := DEF_ATYPE;
    password:
      POP.AuthType := patUserPass;
    apop:
      POP.AuthType := patAPOP;
    sasl:
      if (not mSSLDisabled) then
        POP.AuthType := patSASL;
      else
        POP.AuthType := DEF_ATYPE; //i.e. password
  end;

  if (mSSLDisabled and useSSLorTLS) then begin
    mHasErrorToReport := true;
    mLastErrorMsg := 'Account configured for SSL, but SSL is not available.';
  end;
end;

// Protocol doesn't support "mark read"
function TProtocolPOP3.MakeRead(const uid: string; isRead: Boolean): boolean;
begin
  Result := false;
  Assert(false);
end;

destructor TProtocolPOP3.Destroy;
begin
  if (not mSSLDisabled) then begin
    IdUserPassProvider.Free;
    IdSASLCRAMMD5.Free;
    IdSASLCRAMSHA1.Free;
    IdSASLSKey.Free;
    IdSASLOTP.Free;
    IdSASLAnonymous.Free;
    IdSASLExternal.Free;
    IdSASLLogin.Free;
    IdSASLPlain.Free;
  end;

  POP.Free;
  inherited;
end;

end.

