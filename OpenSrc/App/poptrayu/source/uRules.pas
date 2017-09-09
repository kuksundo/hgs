unit uRules;


{-------------------------------------------------------------------------------
POPTRAYU
Copyright (C) 2014 Jessica Brown
Copyright (C) 2001-2005  Renier Crause
All Rights Reserved.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

The GNU GPL can be found at:
  http://www.gnu.org/copyleft/gpl.html
-------------------------------------------------------------------------------}
interface

uses
  Classes, SysUtils, Graphics, IdMessage, Generics.Collections, System.IniFiles;

type
  TWhiteBlack = (wbWhite, wbBlack);

type
  //---------------------------------------------------------------- Rule Row --
  TRuleArea = (raHeader,raFrom,raSubject,raTo,raCC,raFromName,
    raFromAddress,raStatus,raBody);  // has to match with cmbRuleArea + raBody at the end
  TRuleCompare = (rcContains,rcEquals,rcWildcard,rcEmpty,rcRegExpr);

  TRuleRow = class
  public
    Area : TRuleArea;
    Compare : TRuleCompare;
    Text : string;
    RuleNot : boolean;

    procedure ImportRuleRow(Ini : TCustomIniFile; iniSection : String; ruleNum: String);
  end;

  //--------------------------------------------------------------- Rule Rows --
  TRuleRows = class(TObjectList<TRuleRow>)
  public
    constructor Create;
    function CreateAndAdd: TRuleRow;

    procedure ImportRuleRows(const Ini : TCustomIniFile; const iniSection : String);
  end;

  //--------------------------------------------------------------- Rule Item --
  TRuleOperator = (roAny,roAll);

  TRuleItem = class
  public
    Name : string;
    Enabled : boolean;
    New : boolean;
    Account : integer;
    Operator : TRuleOperator;
    Wav : string;
    Delete : boolean;
    Ignore : boolean;
    EXE : string;
    Important : boolean;
    Spam : boolean;
    Protect : boolean;
    Log : boolean;
    TrayColor : TColor;
    Rows : TRuleRows;
    AddLabel : string;
  public
    constructor Create();
    procedure ExportRuleItem(const Ini : TCustomIniFile; const iniSection : String);
    procedure ImportRuleItem(const Ini : TCustomIniFile; const iniSection : String; newRulesFormat : boolean = true);
  end;

  //--------------------------------------------------------------- Rule Items --
  TRuleItems = class(TObjectList<TRuleItem>)
  public
    constructor Create;
    function CreateAndAdd: TRuleItem;
    procedure ImportRules(const Ini : TCustomIniFile; newRulesFormat : boolean = true);
  end;

  //------------------------------------------------------------ Conversions ---

  // Functions for converting Rules to Strings and vice versa
  function RuleCompareToStr(rulecompare : TRuleCompare) : string;
  function StrToRuleCompare(st : string) : TRuleCompare;
  function RuleAreaToStr(rulearea : TRuleArea) : string; //uses uObjects
  function StrToRuleArea(st : string) : TRuleArea;

  //--------------------------------------------------------- Helper Methods ---
  function CheckRuleRow(area : string; comp : TRuleCompare; text : string; rulenot : boolean) : boolean;
  procedure LogRule(Action,Name,From,Subject,Account : string);
  function GetRuleAreaText(MsgHeader : TIdMessage; RuleArea : TRuleArea) : string;
  function InWhiteBlackList(WhiteBlack : TWhiteBlack; email : string) : boolean;

implementation

uses
  strUtils, uRegExp, uRCUtils, //CheckRuleRow needs
  uGlobal, uIniSettings; // LogRule needs

////////////////////////////////////////////////////////////////////////////////
{ TRuleRow }
////////////////////////////////////////////////////////////////////////////////

procedure TRuleRow.ImportRuleRow(Ini : TCustomIniFile; iniSection : String; ruleNum: String);
var
  comp : String;
begin
  Area := StrToRuleArea(Ini.ReadString(iniSection,'Area'+ruleNum,'Header'));
  RuleNot := Ini.ReadBool(iniSection,'Not'+ruleNum,False);
  comp := Ini.ReadString(iniSection,'Func'+ruleNum,'Contains');
  if comp = 'NOT Contains' then
  begin
    comp := 'Contains';
    RuleNot := True;
  end;
  Compare := StrToRuleCompare(comp);
  Text := Ini.ReadString(iniSection,'Text'+ruleNum,'');
end;

////////////////////////////////////////////////////////////////////////////////
{ TRuleRows }
////////////////////////////////////////////////////////////////////////////////

constructor TRuleRows.Create;
begin
  inherited Create();
  self.OwnsObjects := true;
end;

function TRuleRows.CreateAndAdd: TRuleRow;
begin
  Result := TRuleRow.Create();
  inherited Add(Result);
end;

procedure TRuleRows.ImportRuleRows(const Ini : TCustomIniFile; const iniSection : String);
var
  rowCount, rowNum : integer;
  rowNumSuffix : String;
  row : TRuleRow;
begin
  rowcount := Ini.ReadInteger(iniSection,'RowCount',1);
  for rowNum := 1 to rowCount do
  begin
    if rowNum=1 then
      rowNumSuffix := ''
    else
      rowNumSuffix := IntToStr(rowNum);

    row := TRuleRow.Create();
    row.ImportRuleRow(Ini,iniSection,rowNumSuffix);
    Add(row);
  end;
end;

{$REGION 'TRuleItem'}
////////////////////////////////////////////////////////////////////////////////
{ TRuleItem }
////////////////////////////////////////////////////////////////////////////////

constructor TRuleItem.Create();
begin
  inherited Create();
  Rows := TRuleRows.Create;
end;

procedure TRuleItem.ExportRuleItem(const Ini : TCustomIniFile; const iniSection : String);
var
  j : integer;
  st : string;
begin
  Ini.WriteString(iniSection,'Name',self.Name);
  Ini.WriteBool(iniSection,'Enabled',self.Enabled);
  Ini.WriteBool(iniSection,'New',self.New);
  Ini.WriteInteger(iniSection,'Account',self.Account);
  Ini.WriteInteger(iniSection,'Operator',Ord(self.Operator));
  Ini.WriteInteger(iniSection,'RowCount',self.Rows.Count);
  for j := 0 to self.Rows.Count-1 do
  begin
    if j=0 then st := '' else st := IntToStr(j+1);
    Ini.WriteString(iniSection,'Area'+st,RuleAreaToStr(self.Rows[j].Area));
    Ini.WriteString(iniSection,'Func'+st,RuleCompareToStr(self.Rows[j].Compare));
    Ini.WriteString(iniSection,'Text'+st,self.Rows[j].Text);
    Ini.WriteBool(iniSection,'Not'+st,self.Rows[j].RuleNot);
  end;
  Ini.WriteString(iniSection,'Wav',self.Wav);
  Ini.WriteBool(iniSection,'Delete',self.Delete);
  Ini.WriteBool(iniSection,'Ignore',self.Ignore);
  Ini.WriteString(iniSection,'EXE',self.EXE);
  Ini.WriteBool(iniSection,'Important',self.Important);
  Ini.WriteBool(iniSection,'Spam',self.Spam);
  Ini.WriteBool(iniSection,'Protect',self.Protect);
  Ini.WriteBool(iniSection,'Log',self.Log);
  Ini.WriteInteger(iniSection,'TrayColor',self.TrayColor);
  Ini.WriteString(iniSection,'AddLabel',self.AddLabel);
end;

procedure TRuleItem.ImportRuleItem(const Ini : TCustomIniFile; const iniSection : String; newRulesFormat : boolean = true);
begin
  Name := Ini.ReadString(iniSection,'Name','NoName');
  Account := Ini.ReadInteger(iniSection,'Account',0);
  Operator := TRuleOperator(Ini.ReadInteger(iniSection,'Operator',0));

  Wav := Ini.ReadString(iniSection,'Wav','');
  EXE := Ini.ReadString(iniSection,'EXE','');
  AddLabel := Ini.ReadString(iniSection,'AddLabel','');

  if newRulesFormat then
  begin
    Enabled := Ini.ReadBool(iniSection,'Enabled',False);
    New := Ini.ReadBool(iniSection,'New',False);
    Delete := Ini.ReadBool(iniSection,'Delete',False);
    Ignore := Ini.ReadBool(iniSection,'Ignore',False);
    Important := Ini.ReadBool(iniSection,'Important',False);
    Spam := Ini.ReadBool(iniSection,'Spam',False);
    Protect := Ini.ReadBool(iniSection,'Protect',False);
    Log := Ini.ReadBool(iniSection,'Log',True);
    TrayColor := Ini.ReadInteger(iniSection,'TrayColor',-1);
  end
  else begin
    Enabled := Ini.ReadString(iniSection,'Enabled','No') = 'Yes';
    New := Ini.ReadString(iniSection,'New','No') = 'Yes';
    Delete := Ini.ReadString(iniSection,'Delete','No') = 'Yes';
    Ignore := Ini.ReadString(iniSection,'Ignore','No') = 'Yes';
    Important := Ini.ReadString(iniSection,'Important','No') = 'Yes';
    Spam := False;
    Protect := False;
    Log := True;
    TrayColor := -1;
  end;

  // Add Rule Rows
  Rows.ImportRuleRows(Ini,iniSection);

end;
{$ENDREGION'}

{$REGION 'TRuleItems'}
////////////////////////////////////////////////////////////////////////////////
{ TRuleItems }
////////////////////////////////////////////////////////////////////////////////

constructor TRuleItems.Create;
begin
  inherited Create();
end;


function TRuleItems.CreateAndAdd(): TRuleItem;
begin
  Result := TRuleItem.Create();
  inherited Add(Result);
end;


procedure TRuleItems.ImportRules(const Ini : TCustomIniFile; newRulesFormat : boolean = true);
var
  i,rulecount : integer;
  section : String;
  rule : TRuleItem;
begin
  Clear(); // remove existing rules
  rulecount := Ini.ReadInteger('Options','NumRules',0);
  for i := 1 to rulecount do
  begin
    section := 'Rule'+IntToStr(i);

    rule := TRuleItem.Create;
    rule.ImportRuleItem(Ini, section, newRulesFormat);
    Add(rule);
  end;
end;

{$ENDREGION}


////////////////////////////////////////////////////////////////////////////////

function RuleAreaToStr(rulearea : TRuleArea) : string; //uses uObjects
begin
  case rulearea of
    raHeader     : Result := 'Header';
    raFrom       : Result := 'From';
    raSubject    : Result := 'Subject';
    raTo         : Result := 'To';
    raCC         : Result := 'CC';
    raFromName   : Result := 'From (name)';
    raFromAddress: Result := 'From (address)';
    raBody       : Result := 'Body';
    raStatus     : Result := 'Status';
  else
    Result := '';
  end;
end;

function StrToRuleCompare(st : string) : TRuleCompare;
begin
  st := LowerCase(st);
  if st = 'contains' then Result := rcContains
  else if st = 'equals' then Result := rcEquals
  else if st = 'wildcard' then Result := rcWildcard
  else if st = 'empty' then Result := rcEmpty
  else if st = 'reg expr' then Result := rcRegExpr
  else Result := rcContains;
end;

function RuleCompareToStr(rulecompare : TRuleCompare) : string;
begin
  case rulecompare of
    rcContains    : Result := 'Contains';
    rcEquals      : Result := 'Equals';
    rcWildcard    : Result := 'Wildcard';
    rcEmpty       : Result := 'Empty';
    rcRegExpr     : Result := 'Reg Expr';
  else
    Result := '';
  end;
end;


function StrToRuleArea(st : string) : TRuleArea;
begin
  st := LowerCase(st);
  if st = 'header' then Result := raHeader
  else if st = 'from' then Result := raFrom
  else if st = 'subject' then Result := raSubject
  else if st = 'to' then Result := raTo
  else if st = 'cc' then Result := raCC
  else if st = 'from (name)' then Result := raFromName
  else if st = 'from (address)' then Result := raFromAddress
  else if st = 'body' then Result := raBody
  else if st = 'status' then Result := raStatus
  else Result := raHeader;
end;


//---------------------- Static Helper Methods ---------------------------------

function CheckRuleRow(area : string; comp : TRuleCompare; text : string; rulenot : boolean) : boolean;
////////////////////////////////////////////////////////////////////////////////
//  Check if a specific rule compares
begin
  case comp of
    rcContains    : Result := AnsiContainsText(area,text);
    rcEquals      : Result := AnsiSameText(area,text);
    rcWildcard    : Result := CheckWildCard(area,text);
    rcEmpty       : Result := area = '';
    rcRegExpr     : Result := CheckRegExpr(area,text);
  else
    Result := false;
  end;
  if rulenot then
    Result := not Result;
end;


procedure LogRule(Action,Name,From,Subject,Account : string);
////////////////////////////////////////////////////////////////////////////////
// Write the log action to a tab-delimited file
var
  fl : TextFile;
begin
  if Options.LogRules then
  begin
    AssignFile(fl,LogRuleName);
    if FileExists(LogRuleName) then
      Append(fl)
    else begin
      Rewrite(fl);
      WriteLn(fl,'Date',#9,'Action',#9,'RuleName',#9,'From',#9,'Subject',#9,'Account');
    end;
    Subject := AnsiReplaceStr(Subject,#9,' ');
    WriteLn(fl,DateTimeToStr(Now),#9,Action,#9,Name,#9,From,#9,Subject,#9,Account);
    CloseFile(fl);
  end;
end;

function GetRuleAreaText(MsgHeader : TIdMessage; RuleArea : TRuleArea) : string;
begin
  case RuleArea of
      raFrom        : Result := MsgHeader.From.Text;
      raSubject     : Result := MsgHeader.Subject;
      raTo          : Result := MsgHeader.Headers.Values['To']; //Msg.Recipients.EMailAddresses
      raCC          : Result := MsgHeader.CCList.EMailAddresses;
      raFromName    : Result := MsgHeader.From.Name;
      raFromAddress : Result := MsgHeader.From.Address;
      raBody        : Result := MsgHeader.Body.Text;
    else
      Result := MsgHeader.Headers.Text;
    end;
end;



function InWhiteBlackList(WhiteBlack: TWhiteBlack; email: string): boolean;
var
  list : TStringList;
  i : integer;
begin
  // select list
  if WhiteBlack = wbWhite then
    list := Options.WhiteList
  else
    list := Options.BlackList;
  // check if in list using wildcards
  Result := True;
  for i := 0 to list.Count-1 do
  begin
    if CheckWildcard(email,list[i]) then
      Exit;
  end;
  Result := False;
end;

end.
