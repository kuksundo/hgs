unit uMailItems;

{-------------------------------------------------------------------------------
POPTRAY
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
  Classes, SysUtils, Graphics, Generics.Collections;

type

  //--------------------------------------------------------------- Mail Item --
  TMessagePriority = (mpHighest, mpHigh, mpNormal, mpLow, mpLowest);
  TMailItemStatus = (misProtected,misToBeDeleted,misIgnored,misSpam,misImportant,misHasAttachment,misViewed,misNew); // these have to match with cmbRuleStatus
  TMailItemStatusSet = set of TMailItemStatus;

  TMailItem = class
  private
    procedure SetSeen(const isSeen : boolean);
  public
    MsgNum : integer;
    From : string;
    MailTo : string;
    Address : string;
    ReplyTo : string;
    Subject : string;
    Date : TDateTime;
    DateStr : string;
    Size : integer;
    Priority : TMessagePriority;
    Ignored : boolean;
    HasAttachment : boolean;
    Viewed : boolean; // local status - whether the message has been seen by poptrayu before
    mSeen : boolean;  // server status - whether the message is marked read on the server or not
                      // FYI READ in the code = seen for IMAP, viewed for POP3
    New : boolean;
    Important : boolean;
    Spam : boolean;
    Protect : boolean;
    ToDelete : boolean;
    ToArchive : boolean;
    MsgID : string;
    UID : string;
    TrayColor : TColor;
  public
    function GetStatusSet : TMailItemStatusSet;
    function isRead(const accountIsImap : boolean) : boolean;
    property Seen : boolean read mSeen write SetSeen; //whether the message is MARKED READ on the SERVER or not (applicability: imap accounts)
  end;

  //-------------------------------------------------------------- Mail Items --
  TMailItems = class (TObjectList<TMailItem>)
  public
    constructor Create;
    function Add: TMailItem;
    function FindMessage(MsgNum: Integer): TMailItem;
    function FindUID(UID: string): TMailItem;
    function FindUIDWithDuplicates(UID: string): TMailItem;
    procedure ClearAllMsgNums(uidToIndexMap : TDictionary<String, Integer> = nil);
    procedure SetAllNew(Value: boolean);
    function RemoveDeletedMessages() : boolean;
    function RemoveToDeleteMsgs(): boolean;
    function RemoveToArchiveMsgs(): boolean;
    procedure UpdateRelativeMsgNumbers();
  end;

implementation
uses uGlobal, Dialogs;

{ TMailItem }

function TMailItem.GetStatusSet: TMailItemStatusSet;
begin
  Result := [];
  if self.Protect then Result := Result + [misProtected];
  if self.ToDelete then Result := Result + [misToBeDeleted];
  if self.Ignored then Result := Result + [misIgnored];
  if self.Spam then Result := Result + [misSpam];
  if self.Important then Result := Result + [misImportant];
  if self.HasAttachment then Result := Result + [misHasAttachment];
  if self.viewed then Result := Result + [misViewed];  //TODO
  if self.New then Result := Result + [misNew];
end;

function TMailItem.isRead(const accountIsImap : boolean): boolean;
begin
  if accountIsImap then // todo: AND use server status
    result := self.Seen
  else
    result := self.Viewed;

end;

procedure TMailItem.SetSeen(const isSeen: boolean);
begin
  self.mSeen := isSeen;
end;


{ TMailItems }

constructor TMailItems.Create;
begin
  inherited Create();
  self.OwnsObjects := true;
end;

function TMailItems.Add: TMailItem;
var
  item: TMailItem;
begin
  item := TMailItem.Create();
  inherited Add(item);
  Result := item;
end;

//------------------------------------------------------------------------------
// FindMessage - Finds a message numbered MsgNum
//
// Originally this had an inefficient sequential lookup that grows more and
// more inefficient every time the list gets longer, since this is called
// sequentially for every new message. It appears the correct behavior is
// to change one-based indexing (MsgNum) to zero-based indexing (Items[MsgNum-1]).
// For now I have left the old sequential search code "just in case" this
// turns out to be flawed somehow. But in all tested cases, sequential search
// has been unnecessary.
//------------------------------------------------------------------------------
function TMailItems.FindMessage(MsgNum: Integer): TMailItem;
var
  i : Integer;
begin
  if (MsgNum < 1) then begin
    Result := nil;
    exit;
  end;
  if NOT Options.ShowNewestMessagesOnly  then begin
    if (MsgNum > self.Count) then begin
      Result := nil; // only out of range if > count when self contains ALL msgs
      exit;
    end;
    try
      Result := Items[MsgNum-1];
      if (Result.MsgNum = MsgNum) then Exit; //Message found
    except on E: EArgumentOutOfRangeException do begin
      //Return nil if index is out of bounds/range
      //Result := nil;
      end;
    end;
  end;

  // If Items[MsgNum-1] is not MsgNum, do a search of all msgs until found.
  for i := 0 to Count-1 do
  begin
    Result := Items[i];
    if Result.MsgNum = MsgNum then Exit;
  end;
  Result := nil;
end;

function TMailItems.FindUID(UID: string): TMailItem;
////////////////////////////////////////////////////////////////////////////////
// Find message with UID
var
  i : Integer;
begin
  if UID<>'' then
  begin
    for i := 0 to Count-1 do
    begin
      Result := Items[i];
      if Result.UID = UID then Exit;
    end;
  end;
  Result := nil;
end;

function TMailItems.FindUIDWithDuplicates(UID: string): TMailItem;
////////////////////////////////////////////////////////////////////////////////
// Find message with UID - non-unique UID allowed according to RFC1939
// NOTE: Call ClearAllMsgNums() before using this method
var
  i : Integer;
begin
  for i := 0 to Count-1 do
  begin
    Result := TMailItem(Items[i]);
    if (Result.UID = UID) and (Result.MsgNum = -1) then Exit;
  end;
  Result := nil;
end;

procedure TMailItems.ClearAllMsgNums(uidToIndexMap : TDictionary<String, Integer> = nil);
////////////////////////////////////////////////////////////////////////////////
// Set all items MsgNum property (so we can check which items are still there
// by UID
var
  i : integer;
begin
  for i := 0 to Count-1 do begin
    Items[i].MsgNum := -1;
    if uidToIndexMap <> nil then
      try
        uidToIndexMap.Add(Items[i].UID, i);
      except
        begin
          // error adding. ignore?
          ShowMessage('error adding');
        end
    end;
  end;
end;

procedure TMailItems.SetAllNew(Value: boolean);
////////////////////////////////////////////////////////////////////////////////
// Marks all emails as "new" or "viewed" depending on the parameter
var
  i : integer;
begin
  for i := 0 to Count-1 do
    Items[i].New := Value;
end;

function TMailItems.RemoveDeletedMessages() : boolean;
////////////////////////////////////////////////////////////////////////////////
// Deletes all items with MsgNum = -1. This is used to delete
// all messages no longer on the server
// @Return - True if messages were removed, false if no changes
var
  mailItem : TMailItem;
begin
  Result := False;
  for mailItem in Self do
  begin
    if mailItem.MsgNum = -1 then
    begin
      Remove(mailItem);
      Result := True;
    end
  end;
end;

function TMailItems.RemoveToDeleteMsgs(): boolean;
var
  mailItem : TMailItem;
begin
  Result := false;
  for mailItem in Self do
    if mailItem.ToDelete then
    begin
      Remove(mailItem);
      Result := True;
    end;
end;

function TMailItems.RemoveToArchiveMsgs(): boolean;
var
  mailItem : TMailItem;
begin
  Result := false;
  for mailItem in Self do
    if mailItem.ToArchive then
    begin
      Remove(mailItem);
      Result := True;
    end;
end;

// Should be called after removing messages for POP to correct the relative
// message numbers for messages after first deleted.
procedure TMailItems.UpdateRelativeMsgNumbers();
var
  i, startNum : integer;
  mailItem : TMailItem;
begin
  // THIS METHOD IS NOT THOROUGHLY TESTED
  Assert(false);
  startNum := self[0].msgNum + 1;
  for i := 1 to self.Count - 1 do
  begin
    mailItem := self[i] as TMailItem;
    mailItem.MsgNum := startNum + i;
  end
end;

end.
