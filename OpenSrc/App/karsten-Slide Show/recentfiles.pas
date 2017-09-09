(* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is recentfiles.pas of Karsten Bilderschau, version 3.3.6
 *
 * The Initial Developer of the Original Code is Matthias Muntwiler.
 * Portions created by the Initial Developer are Copyright (C) 2006
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** *)

{ $Id: recentfiles.pas 66 2006-10-22 00:22:21Z hiisi $ }

{
@abstract Manages recent files lists and the corresponding actions
@author matthias muntwiler <hiisi@users.sourceforge.net>
@created 2006/10/07
@cvs $Date: 2006-10-21 19:22:21 -0500 (Sa, 21 Okt 2006) $
}
unit recentfiles;

interface
uses
  SysUtils, Classes, contnrs, ActnList, JvAppStorage;

type
  { @abstract Manages an MRU files list and linked action lists
    Follow these steps to implement an MRU list in the GUI:
    @orderedList(
      @item(Create, store, and destroy a @classname object
        on a sufficiently high level, e.g. in a class variable of the form class. )
      @item(Place a TActionList on the form and add a number of actions to it.
        Assign events to the actions that shall be triggered for the items
        of the list. The manager will control the Caption, Hint, Tag, and Visible
        properties of the actions, the other ones, especially Enabled and
        the events, can be used by the owner.)
      @item(Call @link(RegisterActionList) and @link(UnRegisterActionList)
        when the action list is created and destroyed, respectively,
        e.g. in the form's OnCreate and OnDestroy events.)
      @item(Call @link(AddFile) for each file that should be added
        to the list. The manager deletes the oldest entries that exceed
        a specified limit, and updates the captions of the actions
        in all registered action lists.)
      @item(For each registered action list, one file that is in the
        @link(Files) list may be hidden from the action list,
        e.g. the file that is currently open. See @link(HideFile).
      )
    }
  TRecentFilesManager = class
  private
    FFilesList: TStringList;
    FMaxCount: integer;
    { This list contains action list references in the Objects property,
      and the path of the hidden file in the Strings property. }
    FActionListClients: TStringList;
    FMaxCaptionLength: integer;
    function  GetCount: integer;
    function  GetFiles(index: integer): string;
    procedure SetMaxCount(const Value: integer);
  protected
    procedure DoChange;
  public
    { Create a manager instance.
      @param AMaxCount initializes the @link(MaxCount) property. }
    constructor Create(AMaxCount: integer);
    { Destroy the manager instance. }
    destructor  Destroy; override;
    { Maximum number of list entries.
      This number can be greater than the number of actual entries
      in the action lists. Action lists will display the most recent files. }
    property  MaxCount: integer read FMaxCount write SetMaxCount;
    { Current number of items in the @link(Files) list. }
    property  Count: integer read GetCount;
    { The current file paths. }
    property  Files[index: integer]: string read GetFiles;
    { Maximum number of characters that action captions can have.
      Long paths are truncated by replacing parts with an ellipsis.
      This limit is converted into a pixel amount before the path is shortened,
      the actual captions may thus actually show more characters
      depending on the font metrics.
      Default is 50. }
    property  MaxCaptionLength: integer read FMaxCaptionLength write FMaxCaptionLength;
    { Update the specified action list with the @link(Files) contained in the list.
      This sets the Caption, Hint, Tag, and Visible properties of the actions.
      The captions are set to the file names out of @link(Files)
      (while @link(Files) may contain complete path names).
      Hint is set to the complete file path.
      Tag is set to the file index, and can be used by the action handlers
      to query @link(Files).
      Visible is set to @false for the actions that don't get a caption
      if the @link(Files) list is too short.
      The Enabled property is left to the owner.

      This method is called automatically, whenever the @link(Files) list
      changes, and when the action list is registered.
      You normally don't have to call it from outside except e.g.
      if you change the number of items of a registered action list.
      AActionList can also be an unregistered list. }
    procedure UpdateActionList(const AActionList: TCustomActionList);
    { Register an action list so that the captions of its items
      are automatically set to the file names from @link(Files).
      The action list must already contain the desired number of actions.
      Action lists can only be registered once. }
    procedure RegisterActionList(const AActionList: TCustomActionList);
    { Don't forget to unregister an action list before it gets destroyed. }
    procedure UnRegisterActionList(const AActionList: TCustomActionList);
    { Add the most recently used file path to the list.
      If the list has reached @link(MaxCount), the oldest file is removed.
      Registered action lists are updated with the new file names
      (see @link(UpdateActionList)).
      If the new entry is a duplicate of an existing entry,
      the existing entry is just moved to the top of the list. }
    procedure AddFile(const APath: string);
    { Specify a file that should not appear in the given action list.
      The action list must have been registered before,
      and APath must match the path to be hidden exactly.
      This can be used to suppress the currently open file from the list.
      You may want to set @link(MaxCount) at least one greater
      than the number of actions in the action list
      when you use this feature. }
    procedure HideFile(const AActionList: TCustomActionList; const APath: string);
    { Save @link(Files) to an application storage.
      APath specifies the location (e.g. registry key) where the list is saved to.
      The path is relative to AppStorage.Root. }
    procedure SaveToAppStorage(const AppStorage: TJvCustomAppStorage; const APath: string);
    { Loads @link(Files) from an application storage.
      APath specifies the location (e.g. registry key) where the list is loaded from.
      The path is relative to AppStorage.Root. }
    procedure LoadFromAppStorage(const AppStorage: TJvCustomAppStorage; const APath: string);
  end;

implementation
uses
  jclStrings, jclFileUtils;

{ TRecentFilesManager }

constructor TRecentFilesManager.Create;
begin
  inherited Create;
  FMaxCaptionLength := 50;
  FMaxCount := AMaxCount;
  FFilesList := TStringList.Create;
  FActionListClients := TStringList.Create;
end;

destructor TRecentFilesManager.Destroy;
begin
  FreeAndNil(FFilesList);
  FreeAndNil(FActionListClients);
  inherited;
end;

function TRecentFilesManager.GetCount;
begin
  result := FFilesList.Count;
end;

procedure TRecentFilesManager.SetMaxCount;
begin
  if Value <> FMaxCount then begin
    FMaxCount := Value;
    while FFilesList.Count > FMaxCount do
      FFilesList.Delete(FFilesList.Count - 1);
    DoChange;
  end;
end;

function TRecentFilesManager.GetFiles;
begin
  if index < FFilesList.Count then
    result := FFilesList[index]
  else
    result := '';
end;

procedure TRecentFilesManager.LoadFromAppStorage;
begin
  AppStorage.ReadStringList(APath, FFilesList, true);
  while FFilesList.Count > FMaxCount do
    FFilesList.Delete(FFilesList.Count - 1);
  DoChange;
end;

procedure TRecentFilesManager.SaveToAppStorage;
begin
  AppStorage.DeleteSubTree(APath);
  AppStorage.WriteStringList(APath, FFilesList);
end;

procedure TRecentFilesManager.AddFile;
var
  i: integer;
begin
  FFilesList.Insert(0, APath);
  // remove duplicates
  for i := FFilesList.Count - 1 downto 1 do begin
    if SameFileName(FFilesList[i], APath) then
      FFilesList.Delete(i);
  end;
  // enforce maximum length
  while FFilesList.Count > FMaxCount do
    FFilesList.Delete(FFilesList.Count - 1);
  DoChange;
end;

procedure TRecentFilesManager.DoChange;
var
  i: integer;
begin
  for i := 0 to FActionListClients.Count - 1 do
    UpdateActionList(FActionListClients.Objects[i] as TCustomActionList);
end;

procedure TRecentFilesManager.RegisterActionList;
begin
  if FActionListClients.IndexOfObject(AActionList) < 0 then
    FActionListClients.AddObject('', AActionList);
  UpdateActionList(AActionList);
end;

procedure TRecentFilesManager.HideFile;
var
  idx: integer;
begin
  idx := FActionListClients.IndexOfObject(AActionList);
  if idx >= 0 then begin
    FActionListClients.Strings[idx] := APath;
    UpdateActionList(AActionList);
  end;
end;

procedure TRecentFilesManager.UnRegisterActionList;
var
  idx: integer;
begin
  idx := FActionListClients.IndexOfObject(AActionList);
  if idx >= 0 then
    FActionListClients.Delete(idx);
end;

function PathToCaption(const Path: string; MaxLen: Integer): string;
var
  List: TStringList;
  MinElements: integer;
  delIdx: integer;
begin
  MinElements := 2;
  if PathIsUNC(Path) then Inc(MinElements);
  List := TStringList.Create;
  try
    List.Delimiter := '\';
    List.StrictDelimiter := true;
    List.DelimitedText := Path;
    delIdx := -1;
    while (List.Count > MinElements) and (Length(List.DelimitedText) > MaxLen) do begin
      delIdx := List.Count div 2;
      List.Delete(delIdx);
    end;
    if delIdx >= 0 then
      List.Insert(delIdx, '...');
    Result := List.DelimitedText;
  finally
    List.Free;
  end;
end;

procedure TRecentFilesManager.UpdateActionList;
var
  iActionList: integer;
  iAction: integer;
  iFile: integer;
  Action: TCustomAction;
  hidefile: string;
  actfile: string;
  iHotkey: integer;
  hotkey: string;
begin
  iActionList := FActionListClients.IndexOfObject(AActionList);
  if iActionList >= 0 then
    hidefile := FActionListClients[iActionList]
  else
    hidefile := '';
  iAction := 0;
  for iFile := 0 to FFilesList.Count - 1 do begin
    if iAction < AActionList.ActionCount then begin
      actfile := FFilesList[iFile];
      if (hidefile = '') or (hidefile <> actfile) then begin
        iHotkey := iAction mod 36;
        if iHotkey < 10 then
          hotkey := '&' + IntToStr(iHotkey)
        else
          hotkey := '&' + Chr(iHotkey - 10 + Ord('A'));
        Action := AActionList.Actions[iAction] as TCustomAction;
        Action.Caption := hotkey + '  ' + ExtractFileName(actfile);
        Action.Hint := actfile;
        Action.Tag := iFile;
        Action.Visible := true;
        Inc(iAction);
      end;
    end else
      Break;
  end;
  while iAction < AActionList.ActionCount do begin
    Action := AActionList.Actions[iAction] as TCustomAction;
    Action.Visible := false;
    Inc(iAction);
  end;
end;

end.
