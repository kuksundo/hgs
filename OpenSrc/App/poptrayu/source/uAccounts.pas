unit uAccounts;

{$REGION 'License'}
{-------------------------------------------------------------------------------
POPTRAYU
Copyright (C) 2014 Jessica Brown, Copyright (C) 2001-2005  Renier Crause
All Rights Reserved.

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 2 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program; if not, write to the Free Software Foundation, Inc.,
675 Mass Ave, Cambridge, MA 02139, USA.

The GNU GPL can be found at: http://www.gnu.org/copyleft/gpl.html
-------------------------------------------------------------------------------}
{$ENDREGION}
interface

{$REGION '-- Interfaces --'}
uses
  Classes, ExtCtrls, Contnrs, SysUtils, Graphics, uMailItems,
  {$IFDEF LOG4D}
  Log4D,
  {$ENDIF LOG4D}
  Generics.Collections, uProtocol, System.IniFiles;

type
  //------------------------------------------------------------------- Queue --
  TUniqueQueue = class(TQueue)
  protected
    procedure PushItem(AItem: Pointer); override;
  end;


  //------------------------------------------------------------ Account Item --
  TAccount = class
  public
    Name : string;
    Server : string;
    Port : integer;
    Protocol : string;
    Login : string;
    Password : string;
    MailProgram : string;
    Sound : string;
    Color : string;
    MsgIDs : string;
    ViewedMsgIDs : TStringList;
    IgnoreCount : integer;
    Enabled : boolean;
    Error : boolean;
    Status : string;
    Interval : real;
    Timer : TTimer;
    Size : integer;
    Connecting : boolean;
    OldNum : integer; //for re-ordering accounts
    Prot : TProtocol;
    UIDLSupported : boolean;
    Mail : TMailItems;
    UseSSLorTLS : boolean;
    DontCheckTimes : boolean;
    DontCheckStart : TTime;
    DontCheckEnd : TTime;
    AuthType : TAuthType;
    SslVersion : TsslVer;
    StartTLS : boolean;
    LastMsgCount : longint;

    //imap options
    MoveSpamOnDelete : boolean;
    SpamFolderName : string;
    MoveTrashOnDelete : boolean;
    TrashFolderName : string;
    ExpungeDeletedMessages : boolean;
    ArchiveFolderName : string;
    UseGmailExtensions : boolean;
  private
    FAccountIndex : Integer; //zero based
    FAccountNum : Integer; //one based
  protected

  public
    property AccountIndex : Integer read FAccountIndex; //zero based
    property AccountNum : Integer read FAccountNum;
    constructor Create();
    procedure RefreshAccountStatus();

    function CountNew(): integer;
    function CountUnviewed(): integer;
    function CountStatus(statusses : TMailItemStatusSet): integer;

    function IsImap() : boolean;
    function IsPop() : boolean;
    procedure Connect();
    procedure ConnectIfNeeded();
    procedure TestAccount();
    function GetUIDs(var UIDLs : TStringList; unreadOnly : boolean = false; const maxUIDs : integer = -1 ): boolean;
    function GetUID(msgnum: integer): string;
    function DebugPrint(): String;
    procedure SaveAccountToIniFile(Ini : TMemIniFile; section: string; const includePassword: boolean = true);
    procedure LoadAccountFromINI(Ini : TCustomIniFile; section: string);
    procedure SetProtocol();
    function IsSleeping(): boolean;

    class function GetDefaultDontCheckStartTime() : TTime;
    class function GetDefaultDontCheckEndTime() : TTime;
  end;

  //----------------------------------------------------------- Account Items --
  TAccounts = class(TObjectList<TAccount>)
  private
    function GetNumAccounts(): Integer;
  public
    constructor Create;
    function Add: TAccount;
    //function GetAccountNumber(Account : TAccount) : integer;
    property NumAccounts: Integer read GetNumAccounts;

    function CountAllNew: integer;
    function CountAll(UnviewedOnly: boolean): integer;

    procedure Move(CurIndex, NewIndex: Integer);
    procedure Delete(Index: Integer);
  end;

  //----------------------------------------------------------------- Globals --
var
  Accounts : TAccounts; //global

{$ENDREGION}

////////////////////////////////////////////////////////////////////////////////
implementation
uses uGlobal, IdException, uTranslate, Vcl.Forms, Vcl.Controls, uRCUtils,
  IdStack, StrUtils, Dialogs, uPOP3, uIMAP4, IdExceptionCore, IdReplyIMAP4,
  IdReplyPOP3, uIniSettings;

{$REGION '-- TUniqueQueue --'}
////////////////////////////////////////////////////////////////////////////////
{ TUniqueQueue }
////////////////////////////////////////////////////////////////////////////////

//------------------------------------------------------------------------------
// Unique Queue - Push Item
//------------------------------------------------------------------------------
procedure TUniqueQueue.PushItem(AItem: Pointer);
begin
  if List.IndexOf(AItem) = -1 then
    inherited;
end;
{$ENDREGION}

{$REGION '-- TAccount --'}
////////////////////////////////////////////////////////////////////////////////
{ TAccount }
////////////////////////////////////////////////////////////////////////////////

//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
constructor TAccount.Create();
begin
  inherited;
  UIDLSupported := True;
  FAccountNum := 0;    //not set
  FAccountIndex := -1; //not set
  LastMsgCount := 0;
  ExpungeDeletedMessages := true;
  MoveSpamOnDelete := true; //DEBUG
  SpamFolderName := '[Gmail]/Spam';
  MoveTrashOnDelete := True;
  TrashFolderName := '[Gmail]/Trash';
  DontCheckStart := GetDefaultDontCheckStartTime();
  DontCheckEnd := GetDefaultDontCheckEndTime();
  DontCheckTimes := false;
end;

procedure TAccount.ConnectIfNeeded();
begin
  if Prot.Connected then begin
    if isImap then begin
      try
      if NOT (prot as TProtocolIMAP4).ConnectionReady then // eg: if connection reset by peer, socket may still be open but in invalid state
        (prot as TProtocolIMAP4).Disconnect;
      except
        on EInvalidCast do begin
          // if all is coded right this error is NOT expected ever.
          ShowMessage('Error 191: Unable to connect as IMAP. Protocol is not IMAP.');
        end;
      end;
    end;
  end;

  if not Prot.Connected then begin
    try
      Connect();
    except
      on e: EIdConnClosedGracefully do
        raise;
      on e: EIdReplyIMAP4Error do begin
        // username or password rejected...or auth type rejected
        raise;
      end;
      on e2: Exception do begin
        Prot.Disconnect;
        Connect(); // retry once (retry failure should be passed back to caller)
      end;
    end;
  end;
end;

procedure TAccount.Connect();
var
  aHost,aProtocol : string;
  aUsername,aPassword : string;
  aPort : integer;
  errMsg : String;
begin
  aHost := Server;
  aPort := Port;
  aProtocol := Protocol;
  aUsername := Login;
  aPassword := Password;
  self.Connecting := True;
  try
    self.Prot.SetSSLOptions(UseSSLorTLS, AuthType, SslVersion, StartTLS);
    try
      self.Prot.Connect(aHost, aPort, aUsername, aPassword, Options.TimeOut*1000);
      errMsg := self.Prot.LastErrorMsg();
      if (errMsg <> '') then
      begin
        raise EIdException.Create(errMsg);
      end;
    except on E : EIdReadTimeout do
      raise;
    end;
  finally
    self.Connecting := False;
  end;
end;

procedure TAccount.TestAccount();
var
  msgcount : integer;
  info,st : string;
  sl : TStringList;
  dlgTitle : string;
begin
  try
    dlgTitle := Translate('Test Account') +' - '+ self.Name;
    self.Connect(); //includes Prot.Connect...
    try
      msgcount := integer(Prot.CountMessages);
      info := Translate('Incoming Mail Server:') + ' ' + self.Server + ':' + IntToStr(self.Port) +
        ' (' + self.Protocol +')' + sLineBreak;
      info := info + Translate('Username:')+' '+self.Login + sLineBreak + sLineBreak;
      info := info + Translate('Login OK') + sLineBreak;
      info := info + Translate('Message Count:')+' ' +IntToStr(msgcount) + sLineBreak + sLineBreak;
      sl := TStringList.Create;
      try
        if ( Prot.SupportsUIDL ) then
          st := Translate('Supported')
        else st := Translate('NOT Supported');

        info := info + Translate('Quick Checking and Safe Delete (UIDL):')+' '+st;
      finally
        sl.Free;
      end;
    finally
      Prot.DisconnectWithQuit;
      // TODO: GetWelcomeMessage was throwing an exception on GetResponse causing the connection not to be closed
      // which appears to be worse than not having this info that I'm not sure actually shows anything.
      //if Accounts[num-1].Port in [110,143] then
        //info := GetWelcomeMessage(Accounts[num-1].Server,Accounts[num-1].Port) + sLineBreak + info;
      Screen.Cursor := crDefault;
      ShowMemo(dlgTitle,info,450,250); //synchronize
    end;
  except
    on e: EIdSocketError do
    begin
      info := Translate('Failure connecting to server.') + sLineBreak + e.Message;
      if ( e.LastError = 11004 ) then info := info + Translate('Server found, but is not a mail server.');
      ShowMemo(dlgTitle,info,450,250); //synchronize
    end;
    on e1: EIdReplyIMAP4Error do
    begin
      info := Translate('Authenticaion Failure') + sLineBreak +
        sLineBreak +
        Translate('Possible Causes:') + sLineBreak +
        '* ' + Translate('Incorrect username or password') + sLineBreak +
        '* ' + Translate('Unsupported authentication mode') + sLineBreak +
        '* ' + Translate('IMAP access is disabled for this account');
      ShowMemo(dlgTitle,info,450,250); //synchronize
    end;
    on e3: EIdReplyPOP3Error do
    begin
      info := Translate('Authenticaion Failure') + sLineBreak +
        sLineBreak +
        Translate('Possible Causes:') + sLineBreak +
        '* ' + Translate('Incorrect username or password') + sLineBreak +
        '* ' + Translate('Unsupported authentication mode') + sLineBreak +
        '* ' + Translate('POP access is disabled for this account');
      ShowMemo(dlgTitle,info,450,250); //synchronize
    end;
    on e2: EIdException do begin
      ShowMemo(dlgTitle,
        Translate('An error occurred.') + sLineBreak +
        Translate('Error Type:') + ' ' + e2.className + sLineBreak +
        e2.Message, 450,250); //synchronize
    end;
  end;
end;

function TAccount.GetUID(msgnum: integer): string;
////////////////////////////////////////////////////////////////////////////////
// Get UID from server.  Must be connected
var
  UIDLs : TStringList;
  res : boolean;
begin
  UIDLs := TStringList.Create;
  try
    try
      if self.UIDLSupported then begin
        res := Prot.UIDL(UIDLs,msgnum);
      end else begin
        res := False;
      end;
    except
      res := False;
    end;
    if (UIDLs.Count > 0) and res then
      Result := StrAfter(UIDLs[0],' ')
    else
      Result := 'Error'+IntToStr(Random(10000));
  finally
    UIDLs.Free;
  end;
end;

// @Return true if account supports UIDL
function TAccount.GetUIDs(var UIDLs : TStringList; unreadOnly : boolean = false; const maxUIDs : integer = -1): boolean;
////////////////////////////////////////////////////////////////////////////////
// Get list of UIDS for this account from server. Must be connected.
// UIDLs is an OUTPUT parameter.
begin
//  try
    if self.UIDLSupported then
    begin
      if unreadOnly and self.isImap then
        Result := (Prot as TProtocolIMAP4).GetUnreadUIDs(UIDLs, maxUIDs)
      else
        Result := Prot.UIDL(UIDLs, -1, maxUIDs);
      if not Result then
        self.UIDLSupported := False;
    end
    else begin
      Result := False;
    end;
//  except
//    on E : Exception do begin
//    ShowMessage('Exception class name = '+E.ClassName);    //seeing connection reset by peer here.
//    ShowMessage('Exception message = '+E.Message);
//    // server doesn't support UIDL?
//    Result := False;
//    end;
//  end;
end;

//------------------------------------------------------------------------------
// Saves the RuleId for this account. The Rule ID is the array index into the
// accounts array + 1 (or 0 if account not saved, etc). The Rule ID is used for
// matching up rule to account for account-based rules. The Rule Number is
// basically the account number (one based).
//------------------------------------------------------------------------------
//procedure TAccount.setRuleId(id : Integer);
//begin
//  FRuleId := id;
//end;



//------------------------------------------------------------------------------
// IsImap
//------------------------------------------------------------------------------
function TAccount.IsImap() : boolean;
begin
  Result := (Prot is TProtocolIMAP4);
end;

//------------------------------------------------------------------------------
// IsImap
//------------------------------------------------------------------------------
function TAccount.IsPop() : boolean;
begin
  Result := (Prot is TProtocolPOP3);
end;


//------------------------------------------------------------------------------
// RefreshAccountStatus
//------------------------------------------------------------------------------
procedure TAccount.RefreshAccountStatus();
var
  mailItem : TMailItem;
begin
  self.MsgIDs := '';
  self.Size := 0;
  self.IgnoreCount := 0;
  for mailItem in self.Mail do
  begin
    MsgIDs := MsgIDs + mailItem.MsgID;
    Size := Size + mailItem.Size;
    if (mailItem.Ignored) or (mailItem.Spam) or
       (mailItem.ToDelete) then
      Inc(IgnoreCount);
  end;
end;

//------------------------------------------------------------------------------
// Checks whether this account is sleeping because the current time is between
// this account's "do not check hours" start and end time, if set.
//------------------------------------------------------------------------------
function TAccount.IsSleeping(): boolean;
begin
  Result := false;

  //only check whether account is sleeping if "use do not check hours" setting set for this account
  if self.DontCheckTimes then begin

    if self.DontCheckEnd < self.DontCheckStart then
    begin
      // times across midnight
      Result := (GetTime >= frac(self.DontCheckStart)) or (GetTime <= frac(self.DontCheckEnd));
    end
    else begin
      // normal times
      Result := (GetTime >= frac(self.DontCheckStart)) and (GetTime <= frac(self.DontCheckEnd));
    end;

  end;
end;

//------------------------------------------------------------------------------
// Count new messages from this account
//------------------------------------------------------------------------------
function TAccount.CountNew(): integer;
var
  mailItem : TMailItem;
begin
  Result := 0;
  if Mail = nil then exit;

  if self.Enabled and not self.IsSleeping then begin
    for mailItem in Mail do
      if mailItem.New and
        not mailItem.Ignored and
        not mailItem.ToDelete then
          Inc(Result);

    {$IFDEF LOG4D}
    TLogLogger.GetLogger('poptrayuLogger').Debug('TAcccount.CountNew(): ' + self.Name + ' has ' + IntToStr(result) + ' new messages');
    {$ENDIF LOG4D}

  end else begin
    {$IFDEF LOG4D}
    if not self.enabled then
      TLogLogger.GetLogger('poptrayuLogger').Debug('TAcccount.CountNew(): skipping disabled account: ' + self.Name)
    else
      TLogLogger.GetLogger('poptrayuLogger').Debug('TAcccount.CountNew(): skipping sleeping account: ' + self.Name);
    {$ENDIF LOG4D}
  end;

end;


//------------------------------------------------------------------------------
// Creates a diagnostic list of mail items present in this account.
//------------------------------------------------------------------------------
function TAccount.DebugPrint(): String;
var
  mailItem : TMailItem;
begin
  Result := 'MsgNum,UID,Seen,toDelete,Subject';
  if Mail = nil then exit;

  for mailItem in Mail do
    Result := Result + #13#10 + IntToStr(mailItem.MsgNum)+','+mailItem.UID+','+BoolToStr(mailItem.Seen, true)+','+IfThen(mailItem.ToDelete,'toDelete','--')+',"'+mailItem.Subject+'"';
end;


//------------------------------------------------------------------------------
// Count unviewed messages from this account
//------------------------------------------------------------------------------
function TAccount.CountUnviewed(): integer;
var
  mailItem : TMailItem;
begin
  Result := 0;
  if Mail=nil then Exit;
  for mailItem in Mail do
      if not mailItem.isRead(self.IsImap) and
         not mailItem.Ignored and
         not mailItem.ToDelete then
           Inc(Result);

end;

//------------------------------------------------------------------------------
// Count messages of the specified status
//------------------------------------------------------------------------------
function TAccount.CountStatus(statusses : TMailItemStatusSet): integer;
var
  mailItem : TMailItem;
begin
  Result := 0;
  for mailItem in Mail do
  begin
    if Options.HideViewed and mailItem.isRead(self.isImap) and (Statusses<>[misToBeDeleted]) then
      // ignore
    else if (misToBeDeleted in Statusses)   and mailItem.ToDelete      then Inc(Result)
    else if (misSpam in Statusses)          and mailItem.Spam          then Inc(Result)
    else if (misIgnored in Statusses)       and mailItem.Ignored       then Inc(Result)
    else if (misProtected in Statusses)     and mailItem.Protect       then Inc(Result)
    else if (misImportant in Statusses)     and mailItem.Important     then Inc(Result)
    else if (misHasAttachment in Statusses) and mailItem.HasAttachment then Inc(Result)
    else if (misViewed in Statusses)        and mailItem.isRead(self.IsImap) then Inc(Result)
    else if (misNew in Statusses)           and mailItem.New           then Inc(Result);
  end;
end;

//------------------------------------------------------------------------------
// Saves a single account to an ini file
// Caller is responsible for opening/closing the ini file and calling
// UpdateFile to end buffering on the ini file.
//------------------------------------------------------------------------------
procedure TAccount.SaveAccountToIniFile(Ini : TMemIniFile; section: string; const includePassword: boolean = true);
begin
    Ini.WriteString(Section,'Name',self.Name);
    Ini.WriteString(Section,'Server',self.Server);
    Ini.WriteInteger(Section,'Port',self.Port);
    Ini.WriteString(Section,'Protocol',self.Protocol);
    Ini.WriteBool(Section,'UseSSLorTLS',self.UseSSLorTLS);
    Ini.WriteInteger(Section,'AuthType',Integer(self.AuthType));
    Ini.WriteInteger(Section,'SslVer',Integer(self.SslVersion));
    Ini.WriteBool(Section,'StartTLS',self.StartTLS);
    Ini.WriteString(Section,'Login',self.Login);
    if (includePassword) then Ini.WriteString(Section,'Password',Encrypt(self.Password));
    Ini.WriteString(Section,'MailProgram',self.MailProgram);
    Ini.WriteString(Section,'Sound',self.Sound);
    Ini.WriteString(Section,'Color',self.Color);
    Ini.WriteBool(Section,'Enabled',self.Enabled);
    Ini.WriteFloat(Section,'Interval',self.Interval);
    Ini.WriteBool(Section,'DontCheckTimes',self.DontCheckTimes);
    Ini.WriteTime(Section,'DontCheckStart',self.DontCheckStart);
    Ini.WriteTime(Section,'DontCheckEnd', self.DontCheckEnd);
    Ini.WriteBool(Section, 'MoveSpamOnDelete', self.MoveSpamOnDelete);
    Ini.WriteBool(Section, 'MoveTrashOnDelete', self.MoveTrashOnDelete);
    Ini.WriteString(Section,'SpamFolderName', self.SpamFolderName);
    Ini.WriteString(Section, 'TrashFolderName', self.TrashFolderName);
    Ini.WriteString(Section, 'ArchiveFolderName',self.ArchiveFolderName);
    Ini.WriteBool(Section,'UseGmailExtensions',self.UseGmailExtensions);
end;

{*------------------------------------------------------------------------------
  Loads a single account from the ini file
-------------------------------------------------------------------------------}
procedure TAccount.LoadAccountFromINI(Ini : TCustomIniFile; Section: string);
begin
    self.Name := Ini.ReadString(Section,'Name','NoName');
    self.Server := Ini.ReadString(Section,'Server','');
    self.Port := Ini.ReadInteger(Section,'Port',110);
    self.Protocol := Ini.ReadString(Section,'Protocol','POP3');
    self.UseSSLorTLS := Ini.ReadBool(Section,'UseSSLorTLS',FALSE);
    self.AuthType := TAuthType(Ini.ReadInteger(Section,'AuthType',0));
    self.SslVersion := TsslVer(Ini.ReadInteger(Section,'SslVer',0));
    self.StartTLS := Ini.ReadBool(Section,'StartTLS',false);
    self.Login := Ini.ReadString(Section,'Login','');
    self.MailProgram := Ini.ReadString(Section,'MailProgram','');
    self.Password := Decrypt(Ini.ReadString(Section,'Password',''));
    self.Sound := Ini.ReadString(Section,'Sound','');
    self.Color := Ini.ReadString(Section,'Color','');
    self.Enabled := Ini.ReadBool(Section,'Enabled',True);
    self.Interval := Ini.ReadFloat(Section,'Interval',5);
    self.DontCheckTimes := Ini.ReadBool(Section,'DontCheckTimes',FALSE);
    try
      self.DontCheckStart := Ini.ReadTime(Section,'DontCheckStart',GetDefaultDontCheckStartTime());
    Except on e: EConvertError do begin
      ShowMessage(e.ToString);
      end;
    end;
    try
      self.DontCheckEnd := Ini.ReadTime(Section,'DontCheckEnd',GetDefaultDontCheckEndTime());
    Except on e: EConvertError do begin
      ShowMessage(e.ToString);
      end;
    end;
    self.MoveSpamOnDelete := Ini.ReadBool(Section, 'MoveSpamOnDelete', false);
    self.MoveTrashOnDelete := Ini.ReadBool(Section, 'MoveTrashOnDelete', false);
    self.SpamFolderName := Ini.ReadString(Section, 'SpamFolderName','[Gmail]/Spam');
    self.TrashFolderName := Ini.ReadString(Section, 'TrashFolderName','[Gmail]/Trash');
    self.ArchiveFolderName := Ini.ReadString(Section, 'ArchiveFolderName','[Gmail]/All Mail');
    self.UseGmailExtensions := Ini.ReadBool(Section, 'UseGmailExtensions',false);

    self.ViewedMsgIDs := TStringList.Create;
    self.Mail := TMailItems.Create;
    //uIniSettinngs.LoadViewedMessageIDs(num);

    self.SetProtocol();
end;


// Assigns an instance of the Protocol (IMAP or POP) to the account.
procedure TAccount.SetProtocol();
var
  prevProt : TProtocol;
begin
  prevProt := self.Prot;
  if (prevProt <> nil) then begin
    try
    prevProt.Free;
    except on E : Exception do
      begin
        //ignore (eg: socket error trying to disconnect as it's freeing)
      end;
    end;
  end;
  if (self.Protocol = 'POP3') then
  begin
    self.Prot := TProtocolPOP3.Create;
  end else begin
    self.Prot := TProtocolIMAP4.Create;
  end;

  if DebugOptions.ProtocolLogging then begin
    self.Prot.EnableLogging(uIniSettings.GetSettingsFolder() + 'logs\',
      'acc'+IntToStr(Self.AccountNum)+'_'+FormatDateTime('mmm-dd-yyyy_hh-mm', Now)+'.log');
  end;

end;



{*------------------------------------------------------------------------------
  Default time for Don't Check Hours start time
-------------------------------------------------------------------------------}
class function TAccount.GetDefaultDontCheckStartTime() : TTime;
begin
  Result := StrToTime('20'+FormatSettings.TimeSeparator+'00');
end;

{*------------------------------------------------------------------------------
  Default time for Don't Check Hours end time
-------------------------------------------------------------------------------}
class function TAccount.GetDefaultDontCheckEndTime() : TTime;
begin
  Result := StrToTime('08'+FormatSettings.TimeSeparator+'00');
end;

{$ENDREGION}

{$REGION '-- TAccounts --'}
////////////////////////////////////////////////////////////////////////////////
{ TAccounts }
////////////////////////////////////////////////////////////////////////////////

//------------------------------------------------------------------------------
// Creates a new account item.
//------------------------------------------------------------------------------
constructor TAccounts.Create;
begin
  inherited Create();
  self.OwnsObjects := true;
end;


//------------------------------------------------------------------------------
// Gets the total number of accounts
//------------------------------------------------------------------------------
function TAccounts.GetNumAccounts() : Integer;
begin
  Result := Inherited Count;
end;

//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
function TAccounts.Add: TAccount;
var
  accountIdx : integer;
begin
  Result := TAccount.Create();
  accountIdx := inherited Add(Result);
  Result.FAccountIndex := accountIdx;
  Result.FAccountNum := accountIdx + 1;
end;

//------------------------------------------------------------------------------
// Count the number of new messages from all accounts
//------------------------------------------------------------------------------
function TAccounts.CountAllNew: integer;

var
  account : TAccount;
begin
  Result := 0;

  {$IFDEF LOG4D}
  TLogLogger.GetLogger('poptrayuLogger').Debug('TAcccount.CountAllNew()'+DateTimeToStr(Now));
  {$ENDIF LOG4D}

  for account in Accounts do begin
    if account.isSleeping() then continue; //skip sleeping accounts
    if NOT account.Enabled then continue;  //skip disabled accounts
    if account.Error then continue;        //skip error accounts

    Result := Result + account.CountNew();
  end;

end;

//------------------------------------------------------------------------------
// Count messages (either unviewed or all) from all accounts
//------------------------------------------------------------------------------
function TAccounts.CountAll(UnviewedOnly: boolean): integer;
var
  account : TAccount;
begin
  Result := 0;
  for account in Accounts do
  begin
    if account.Mail = nil then continue;
    if account.isSleeping() then continue; //skip sleeping accounts
    if NOT account.Enabled then continue;  //skip disabled accounts
    if account.Error then continue;        //skip error accounts

    if UnviewedOnly then
      Result := Result + account.CountUnviewed()
    else
      Result := Result + account.Mail.Count - account.IgnoreCount;
  end;
end;

procedure TAccounts.Move(CurIndex, NewIndex: Integer);
var
  i : integer;
begin
  if (curIndex <> newIndex) then begin
    Items[curIndex].FAccountIndex := NewIndex;
    Items[curIndex].FAccountNum := NewIndex+1;

    if CurIndex < NewIndex then begin
      for i := CurIndex + 1 to NewIndex do begin
        Dec(Items[i].FAccountIndex);
        Dec(Items[i].FAccountNum);
      end
    end
    else if CurIndex > NewIndex then begin
      for i := NewIndex to CurIndex - 1 do begin
        Inc(Items[i].FAccountIndex);
        Inc(Items[i].FAccountNum);
      end;
    end;
  end;
  inherited;
end;

procedure TAccounts.Delete(Index: Integer);
var
  i : integer;
begin
  for i := Index to Count-1 do begin
    Dec(Items[i].FAccountIndex);
    Dec(Items[i].FAccountNum);
  end;
  inherited;
end;

////////////////////////////////////////////////////////////////////////////////
{$ENDREGION}
end.
