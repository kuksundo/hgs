library ProtocolIMAP4;

{-------------------------------------------------------------------------------
POPTRAY
Copyright (C) 2003  Renier Crause
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

uses
  Windows, SysUtils,
  IdComponent, IdMessage, IdIMAP4, IdSSLOpenSSL, //IdMailbox,
  uPlugins in '..\..\uPlugins.pas';

// general
function InterfaceVersion : integer; stdcall; forward;
procedure Init;  stdcall; forward;
function PluginType : TPluginType; stdcall; forward;
function PluginName : ShortString; stdcall; forward;
procedure ShowOptions; stdcall; forward;
procedure Unload; stdcall; forward;
procedure FreePChar(var p : PChar); stdcall; forward;
// protocol
function Protocols : ShortString; stdcall; forward;
procedure Connect(Server : PChar; Port : integer; Protocol,UserName,Password : PChar; TimeOut : integer); stdcall; forward;
procedure Disconnect; stdcall; forward;
function Connected : boolean; stdcall; forward;
function CheckMessages : integer; stdcall; forward;
function RetrieveHeader(const MsgNum : integer; var pHeader : PChar) : boolean; stdcall; forward;
function RetrieveRaw(const MsgNum : integer; var pRawMsg : PChar) : boolean; stdcall; forward;
function RetrieveTop(const MsgNum,LineCount: integer; var pDest: PChar) : boolean; stdcall; forward;
function RetrieveMsgSize(const MsgNum : integer) : integer; stdcall; forward;
function UIDL(var pUIDL : PChar; const MsgNum : integer = -1) : boolean; stdcall; forward;
function Delete(const MsgNum : integer) : boolean; stdcall; forward;
procedure SetOnWork(const OnWorkProc : TPluginWorkEvent); stdcall; forward;
function LastErrorMsg : PChar; stdcall; forward;

exports
  InterfaceVersion,
  // general
  Init,
  PluginType,
  PluginName,
  ShowOptions,
  FreePChar,
  Unload,
  // protocol
  Protocols,
  Connect,
  Disconnect,
  Connected,
  CheckMessages,
  RetrieveHeader,
  RetrieveRaw,
  RetrieveTop,
  RetrieveMsgSize,
  UIDL,
  Delete,
  SetOnWork,
  LastErrorMsg;

type
  TIMAPWorkObject = class(TObject)
  public
    OnWork : TPluginWorkEvent;
    procedure IMAPWork(Sender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
  end;
var
  IMAP : TIdIMAP4;
  Msg : TIdMessage;
  SSL : TIdSSLIOHandlerSocketOpenSSL;
  IMAPWorkObject : TIMAPWorkObject;

//------------------------------------------------------------------ helpers ---

function WordAfterStr(str,substr : string) : string;
var
  i : integer;
begin
  Result := '';
  if pos(substr,str) = 0 then Exit;
  for i := pos(substr,str)+length(substr) to length(str) do
  begin
    if not(str[i] in [' ',')',#13,#10]) then
      Result := Result + str[i];
  end;
end;

//---------------------------------------------------------- general exports ---

function InterfaceVersion : integer; stdcall;
begin
  Result := 1;
end;

procedure Init;
begin
  // init code goes here
  IMAP := TIdIMAP4.Create(nil);
  Msg := TIdMessage.Create(nil);
  Msg.NoEncode := True;
  Msg.NoDecode := True;
  IMAPWorkObject := TIMAPWorkObject.Create;
  IMAP.OnWork := IMAPWorkObject.IMAPWork;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SSL.SSLOptions.Method := sslvSSLv23;
  SSL.SSLOptions.Mode := sslmClient;
end;

function PluginType : TPluginType;
begin
  Result := piProtocol;
end;

function PluginName : ShortString;
begin
  Result := 'IMAP4 (Indy10)';
end;

procedure ShowOptions;
begin
  MessageBox(0,'IMAP Plugin does not have any configurable options.','IMAP',MB_OK);
end;

procedure Unload;
begin
  IMAP.Free;
  IMAPWorkObject.Free;
  SSL.Free;
  Msg.Free;
end;

procedure FreePChar(var p : PChar); stdcall;
// Have to free the PChars from inside the DLL
begin
  StrDispose(p);
  p := nil;
end;

//--------------------------------------------------------- protocol exports ---

function Protocols : ShortString;
begin
  Result := 'IMAP4:143,IMAP4 SSL:993';
end;

procedure Connect(Server : PChar; Port : integer; Protocol,UserName,Password : PChar; TimeOut : integer);
begin
  IMAP.Host := Server;
  IMAP.Port := Port;
  IMAP.Username := Username;
  IMAP.Password := Password;
  IMAP.IOHandler := nil;
  if Protocol = 'IMAP4 SSL' then
    IMAP.IOHandler := SSL;
  IMAP.ConnectTimeout := TimeOut;
  IMAP.Connect(true);
  IMAP.SelectMailBox('INBOX');
end;

procedure Disconnect;
begin
  IMAP.Disconnect;
end;

function Connected : boolean;
begin
  Result := IMAP.Connected;
end;

function CheckMessages : integer;
begin
  Result := IMAP.MailBox.TotalMsgs;
end;

function RetrieveHeader(const MsgNum : integer; var pHeader : PChar) : boolean;
begin
  Msg.Clear;
  Result := IMAP.RetrieveHeader(MsgNum,Msg);
  if Result then
    pHeader := Msg.Headers.GetText;
end;

function RetrieveRaw(const MsgNum : integer; var pRawMsg : PChar) : boolean;
begin
  Msg.Clear;
  Result := IMAP.Retrieve(MsgNum,Msg);
  if Result then
    pRawMsg := StrNew(PChar(Msg.Headers.Text+#13#10+Msg.Body.Text));
end;

function RetrieveTop(const MsgNum,LineCount: integer; var pDest: PChar) : boolean;
var
  st : string;
begin
  Msg.Clear;
  // get header
  Result := IMAP.RetrieveHeader(MsgNum,Msg);
  if Result then
  begin
    // get first LineCount*70 octets
    IMAP.RetrievePeek(MsgNum, Msg);      //Temp replacement
{
    IMAP.WriteLn('xx FETCH '+IntToStr(MsgNum)+' BODY.PEEK[TEXT]<0.'+
                 IntToStr(LineCount*70)+'>');
    Result := IMAP.GetLineResponse('xx',[wsOK]) = wsOK;
    if Result then
    begin
      Msg.Body.Clear;
      st := IMAP.ReadlnWait; //Changed from ReadLn indy9
      while Copy(st,1,3) <> 'xx ' do
      begin
        Msg.Body.Add(st);
        st := IMAP.ReadlnWait; //Changed from ReadLn indy9;
      end;
      // delete last line
      Msg.Body.Strings[Msg.Body.Count-1] := '';
      pDest := StrNew(PChar(Msg.Headers.Text+#13#10+Msg.Body.Text));
    end; }
  end;
end;

function RetrieveMsgSize(const MsgNum : integer) : integer;
begin
  Result := IMAP.RetrieveMsgSize(MsgNum);
end;

function UIDL(var pUIDL : PChar; const MsgNum : integer = -1) : boolean;
var
  st,UID : string;
  i, nCount : integer;
begin
  if MsgNum > -1 then
  begin
    Result := IMAP.GetUID(MsgNum, UID);
    st := IntToStr(MsgNum) + ' ' +IMAP.MailBox.UIDValidity + '_' + UID;
    pUIDL := StrNew(PChar(st));
  end
  else begin
    st := '';
    nCount := IMAP.MailBox.TotalMsgs;
    for i := 0 to nCount-1 do
    begin
      IMAP.GetUID(MsgNum, UID);
      if UID <> '' then
        st := st + IntToStr(i+1) + ' ' + IMAP.MailBox.UIDValidity + '_' + UID + #13#10;

    end;
    pUIDL := StrNew(PChar(Trim(st)));
    Result := True;
  end;
end;

function Delete(const MsgNum : integer) : boolean;
begin
  Result := IMAP.DeleteMsgs([MsgNum]);
  IMAP.ExpungeMailBox;
end;

procedure SetOnWork(const OnWorkProc : TPluginWorkEvent);
begin
  IMAPWorkObject.OnWork := OnWorkProc;
end;

function LastErrorMsg : PChar;
begin
  Result := nil;
end;

{ TIMAPWorkObject }

procedure TIMAPWorkObject.IMAPWork(Sender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
begin
  if Assigned(OnWork) then
    OnWork(AWorkCount);
end;




end.
