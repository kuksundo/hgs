unit uRulesManager;

interface

uses
  Classes, IdMessage, System.IniFiles,
  uRules, uMailItems, SysUtils, uAccounts;

type

  // TODO: turn rules manager into something useful or remove it.
  TRulesManager = Class (TObject)
    function CheckRule(rulenum : integer; MailItem : TMailItem; MsgHeader : TIdMessage) : boolean;
    procedure CheckRules(MailItem : TMailItem; MsgHeader : TIdMessage; Account : TAccount);
    procedure whitelistEmailAddresses(emails : TStringList);
    procedure blacklistEmailAddresses(emails : TStringList);
  public
    Rules : TRuleItems;
    constructor Create();
    destructor Destroy(); override;
    procedure SaveRulesToFile(Ini : TCustomIniFile);
    procedure LoadRulesFromFile(Ini : TCustomIniFile; newRulesFormat: boolean = true);
    procedure RemapRules(map : array of integer);
    procedure RemoveAccount(accountNum : integer);
  End;

var
  // todo - rules should eventually not be global variable?
  RulesManager : TRulesManager; //Global: Rules Manager (singleton instance)

  // todo: these variables (used for rules) should probably be eliminated
  FNotified : Boolean;
  FNotifyWav : TFileName;
  FImportant : boolean;

////////////////////////////////////////////////////////////////////////////////
implementation
  uses uGlobal, uIniSettings, uTranslate, Dialogs, Controls, System.StrUtils,
    uRCUtils, Winapi.Windows, uMain, uImap4;

const
  ALL_ACCOUNTS = 0; // account number for rules that apply to all accounts


constructor TRulesManager.Create;
begin
  inherited;
  Rules := TRuleItems.Create;
end;

destructor TRulesManager.Destroy;
begin
  if (Rules <> nil) then
    FreeAndNil(Rules);
  inherited;
end;


procedure TRulesManager.whitelistEmailAddresses(emails : TStringList);
begin
  if (emails = nil) or (emails.Count = 0) then exit;

  Options.WhiteList.Duplicates := dupIgnore;
  Options.WhiteList.CaseSensitive := False;
  Options.WhiteList.Sorted := True;
  Options.WhiteList.AddStrings(emails);
  SaveWhitelistToFile();
end;

procedure TRulesManager.blacklistEmailAddresses(emails : TStringList);
begin
  if (emails = nil) or (emails.Count = 0) then exit;

  Options.BlackList.Duplicates := dupIgnore;
  Options.BlackList.CaseSensitive := False;
  Options.BlackList.Sorted := True;
  Options.BlackList.AddStrings(emails);
  SaveBlacklistToFile();
end;


function TRulesManager.CheckRule(rulenum : integer; MailItem : TMailItem; MsgHeader : TIdMessage) : boolean;
var
  i : integer;
  //MsgHeader : TIdMessage;
begin
  //if MailItem <> nil then
  //begin
  //  MsgHeader := MailItem.
  //end;

  if Rules[rulenum].Operator = roAll then
  begin
    // and
    for i := 0 to Rules[rulenum].Rows.Count-1 do
    begin
      if Rules[rulenum].Rows[i].Area = raStatus then
      begin
        if (TMailItemStatus(StrToInt(Rules[rulenum].Rows[i].Text)) in MailItem.GetStatusSet) = Rules[rulenum].Rows[i].RuleNot then
        begin
          Result := False;
          Exit;
        end;
      end
      else begin
        if not CheckRuleRow(GetRuleAreaText(MsgHeader, Rules[rulenum].Rows[i].Area),
          Rules[rulenum].Rows[i].Compare,Rules[rulenum].Rows[i].Text,
          Rules[rulenum].Rows[i].RuleNot) then
        begin
          Result := False;
          Exit;
        end;
      end;
    end;
    Result := True;
  end
  else begin
    // or
    for i := 0 to Rules[rulenum].Rows.Count-1 do
    begin
      if Rules[rulenum].Rows[i].Area = raStatus then
      begin
        if (TMailItemStatus(StrToInt(Rules[rulenum].Rows[i].Text)) in MailItem.GetStatusSet) = not(Rules[rulenum].Rows[i].RuleNot) then
        begin
          Result := True;
          Exit;
        end;
      end
      else begin
        if CheckRuleRow(GetRuleAreaText(MsgHeader, Rules[rulenum].Rows[i].Area),
          Rules[rulenum].Rows[i].Compare,Rules[rulenum].Rows[i].Text,
          Rules[rulenum].Rows[i].RuleNot) then
        begin
          Result := True;
          Exit;
        end;
      end;
    end;
    Result := False;
  end;
end;

procedure TRulesManager.CheckRules(MailItem : TMailItem; MsgHeader : TIdMessage; Account : TAccount);
////////////////////////////////////////////////////////////////////////////////
// Check all the rules and perform action
var
  i, accountNum : integer;
  RuleEXE,ExeName,ExeParam, accountName : string;
begin
  accountName := Account.Name;
  accountNum := Account.AccountNum;

  // white list
  if InWhiteBlackList(wbWhite,MsgHeader.From.Address) and (MsgHeader.From.Address <> '') then
    MailItem.Protect := True;
  // rules for protect first
  for i := 0 to Rules.Count-1 do
  begin
    if Rules[i].Enabled and
       ( (Rules[i].Account = 0) or (Rules[i].Account = accountNum ) ) and
       ( not(Rules[i].New) or (Rules[i].New and MailItem.New) ) then
    begin
      if Rules[i].Protect then
      begin
        if CheckRule(i,MailItem, MsgHeader) then
        begin
          MailItem.Protect := True;
          if Rules[i].Log then
            LogRule('PROTECT',Rules[i].Name,MsgHeader.From.Text,MsgHeader.Subject,accountName);
        end;
      end;
    end;
  end;
  // black list
  if InWhiteBlackList(wbBlack,MsgHeader.From.Address) then
  begin
    if (MsgHeader.From.Address <> '') and not MailItem.Protect and not MailItem.Important then
    begin
      if Options.BlackListSpam then
      begin
        MailItem.Spam := True;
        MailItem.Ignored := True;
        LogRule('SPAM','BlackList',MsgHeader.From.Text,MsgHeader.Subject,accountName);
      end
      else begin
        MailItem.ToDelete := True;
        MailItem.Ignored := True;
        LogRule('DELETE','BlackList',MsgHeader.From.Text,MsgHeader.Subject,accountName);
      end;
    end;
  end;
  // other rules
  for i := 0 to Rules.Count-1 do
  begin
    // enabled?
    if Rules[i].Enabled and
       ( (Rules[i].Account = ALL_ACCOUNTS) or (Rules[i].Account = Account.AccountNum) ) and
       ( not(Rules[i].New) or (Rules[i].New and MailItem.New) ) then
    begin
      // check it against the rule
      if CheckRule(i,MailItem, MsgHeader) then
      begin
        // wav
        if Rules[i].Wav <> '' then
        begin
          if not FNotified then
            FNotifyWav := Rules[i].Wav;
          FNotified := True;
          if Rules[i].Log then
            LogRule('WAV',Rules[i].Name,MsgHeader.From.Text,MsgHeader.Subject,accountName);
        end;
        // delete
        if Rules[i].Delete then
        begin
          if not MailItem.ToDelete and
             not MailItem.Protect and
             not MailItem.Important then
          begin
            MailItem.ToDelete := True;
            if Rules[i].Log then
              LogRule('DELETE',Rules[i].Name,MsgHeader.From.Text,MsgHeader.Subject,accountName);
          end;
        end;
        // ignore
        if Rules[i].Ignore then
        begin
          MailItem.Ignored := True;
          if Rules[i].Log then
            LogRule('IGNORE',Rules[i].Name,MsgHeader.From.Text,MsgHeader.Subject,accountName);
        end;
        // exe
        if Rules[i].EXE <> '' then
        begin
          // replace macros
          RuleEXE := Rules[i].EXE;
          RuleEXE := AnsiReplaceText(RuleEXE,'%ACCOUNT%',accountName);
          RuleEXE := AnsiReplaceText(RuleEXE,'%ACCOUNTNUM%',IntToStr(Account.AccountNum));
          RuleEXE := AnsiReplaceText(RuleEXE,'%FROM%',MailItem.From);
          RuleEXE := AnsiReplaceText(RuleEXE,'%FROMADDRESS%',MailItem.Address);
          RuleEXE := AnsiReplaceText(RuleEXE,'%TO%',MailItem.MailTo);
          RuleEXE := AnsiReplaceText(RuleEXE,'%SUBJECT%',MailItem.Subject);
          RuleEXE := AnsiReplaceText(RuleEXE,'%DATE%',MailItem.DateStr);
          RuleEXE := AnsiReplaceText(RuleEXE,'%SIZE%',IntToStr(MailItem.Size));
          RuleEXE := AnsiReplaceText(RuleEXE,'%MSGID%',MailItem.MsgID);
          RuleEXE := AnsiReplaceText(RuleEXE,'%UID%',MailItem.UID);
          RuleEXE := AnsiReplaceText(RuleEXE,'%MSGNUM%',IntToStr(MailItem.MsgNum));
          // execute
          SplitExeParams(RuleEXE,ExeName,ExeParam);
          ExecuteFile(ExeName,ExeParam,'',SW_RESTORE);
          if Rules[i].Log then
            LogRule('EXE',Rules[i].Name,MsgHeader.From.Text,MsgHeader.Subject,accountName);
        end;
        // important
        if Rules[i].Important then
        begin
          MailItem.Important := True;
          MailItem.Spam := False;
          FImportant := True;
            LogRule('IMPORTANT',Rules[i].Name,MsgHeader.From.Text,MsgHeader.Subject,accountName);
        end;
        // spam
        if Rules[i].Spam and
           not MailItem.Protect and not MailItem.Important then
        begin
          MailItem.Spam := True;
          if Rules[i].Log then
            LogRule('SPAM',Rules[i].Name,MsgHeader.From.Text,MsgHeader.Subject,accountName);
        end;
        // tray color
        if Rules[i].TrayColor <> -1 then
        begin
          MailItem.TrayColor := Rules[i].TrayColor;
          if Rules[i].Log then
            LogRule('TRAYCOLOR',Rules[i].Name,MsgHeader.From.Text,MsgHeader.Subject,accountName);
        end;
        if Rules[i].AddLabel <> '' then
        begin
          if (account.IsImap and account.UseGmailExtensions) then begin
            (account.Prot as TProtocolIMAP4).AddGmailLabelToMsg(MailItem.UID, Rules[i].AddLabel);
            if Rules[i].Log then
              LogRule('ADDLABEL',Rules[i].Name,MsgHeader.From.Text,MsgHeader.Subject,accountName);
          end;
        end;

      end;
    end; //enabled
  end;
end;


//------------------------------------------------------------------------------
// Saves RULES to the rules INI file
//------------------------------------------------------------------------------
procedure TRulesManager.SaveRulesToFile(Ini : TCustomIniFile);
var
  i : integer;
  section : string;
begin
  Ini.WriteInteger('Options','NumRules',Rules.Count);
  for i := 0 to Rules.Count-1 do
  begin
    section := 'Rule'+IntToStr(i+1);
    Rules[i].ExportRuleItem(Ini, section);
  end;
end;

//------------------------------------------------------------------------------
// This method imports a single rule from old versions of PopTray that stored
// rules in PopTray.ini and had a more limited selection of rules options
//------------------------------------------------------------------------------
function LoadOldRuleFromFile(Ini : TCustomIniFile; IniSection : String): TRuleItem;
begin
  Result := TRuleItem.Create;

  Result.Enabled := Ini.ReadString(IniSection,'Enabled','No') = 'Yes';
  Result.New := Ini.ReadString(IniSection,'New','No') = 'Yes';
  Result.Delete := Ini.ReadString(IniSection,'Delete','No') = 'Yes';
  Result.Ignore := Ini.ReadString(IniSection,'Ignore','No') = 'Yes';
  Result.Important := Ini.ReadString(IniSection,'Important','No') = 'Yes';
  Result.Spam := False;
  Result.Protect := False;
  Result.Log := True;
  Result.TrayColor := -1;
end;

//------------------------------------------------------------------------------
// This method imports a single rule from Rules.Ini
//------------------------------------------------------------------------------
function LoadNewRuleFromFile(Ini : TCustomIniFile; IniSection : String): TRuleItem;
begin
  Result := TRuleItem.Create;


end;


{*------------------------------------------------------------------------------
  Get the rules from INI file.
  This method expects the ini file to already be open and ready to read from.
-------------------------------------------------------------------------------}
procedure TRulesManager.LoadRulesFromFile(Ini : TCustomIniFile; newRulesFormat: boolean = true);
begin

  Rules.ImportRules(Ini, newRulesFormat);

  frmPopUMain.RulesForm.RefreshRulesList();

  if (not newRulesFormat) then
    frmPopUMain.RulesForm.EnableSaveRulesButton(true)
  else
    frmPopUMain.RulesForm.EnableSaveRulesButton(false);
end;

{-------------------------------------------------------------------------------
  Remap Rules

  Called after accounts are re-ordered to fix the rules to map to the correct
  accounts.

  Map is an array of integers where the array index is the old rule number
  (zero based) and the value is the new rule number (one based).
-------------------------------------------------------------------------------}
procedure TRulesManager.RemapRules(map : array of integer);
var
  i : integer;
begin
  //notify Rules Form there are pending changes
  frmPopUMain.RulesForm.AccountsChanged();

  for i := 0 to Rules.Count-1 do
    if Rules[i].Account > 0 then
      Rules[i].Account := map[RulesManager.Rules[i].Account-1];

  frmPopUMain.RulesForm.listRulesClick(frmPopUMain.RulesForm.listRules);
  SaveRulesINI;
end;

// When an account is deleted, this method should be called. It will
// change rules that apply to the deleted account to apply to the default
// account (all accounts) and inactivate the rule. For all rules with an
// account number higher than the deleted account, the account number will
// be shifted to match.
procedure TRulesManager.RemoveAccount( accountNum : integer);
var
  i : integer;
begin
    for i := 0 to Rules.Count-1 do
    begin
      if Rules[i].Account = accountNum then begin
        Rules[i].Account := -1;
        Rules[i].Enabled := false; // if account rule is set for no longer exists, disable rule
      end;
      // fix rules - rule numbers after the deleted account all need to be decreased by one
      if Rules[i].Account > accountNum then
        Rules[i].Account := Rules[i].Account - 1;
    end;
    // Notify Rules form that it needs to remove an account from rules dropdown
    if Assigned(frmPopUMain.RulesForm) then begin
      frmPopUMain.RulesForm.AccountsChanged();
      frmPopUMain.RulesForm.listRulesClick(frmPopUMain.RulesForm.listRules);
    end;
    SaveRulesIni();
end;

end.
