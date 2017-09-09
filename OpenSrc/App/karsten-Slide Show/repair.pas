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
 * The Original Code is repair.pas of Karsten Bilderschau, version 3.2.12.
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

{ $Id: repair.pas 82 2006-10-29 17:27:21Z hiisi $ }

{
@abstract Interactive repair of broken links
@author matthias muntwiler <hiisi@users.sourceforge.net>
@created 2004/11/23
@cvs $Date: 2006-10-29 11:27:21 -0600 (So, 29 Okt 2006) $

This form allows to interactively and collectively repair broken file paths.
}
unit repair;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Grids, Buttons, sammlung, sammelklassen, ExtDlgs,
  JvComponentBase, JvBaseDlg, JvBrowseFolder, ExtCtrls, repair.search, globals;

type
  { Indicates what to do with a broken link }
  TRepairAction = (
    raNone,     //< no action, this item won't be fixed
    raFixPath,  //< replace the file path with the new one. the new path must be valid.
    raRemove    //< remove this item from the collection
    );

  { @abstract Interactive repair of broken links
    Create the form, assign @link(Sammlung), and show the form.
    The form will do the repairs when the user clicks OK. }
  TSammlungRepairForm = class(TForm)
    OkButton: TBitBtn;
    CancelButton: TBitBtn;
    HelpButton: TBitBtn;
    ObjectListGrid: TStringGrid;
    ObjectListLabel: TLabel;
    ProcedurePages: TPageControl;
    ReplacePathSheet: TTabSheet;
    SourcePathLabel: TLabel;
    SourcePathEdit: TEdit;
    DestPathEdit: TEdit;
    DestPathLabel: TLabel;
    DestPathButton: TButton;
    ReplaceButton: TButton;
    TakeObjectButton: TButton;
    DestPathDialog: TOpenPictureDialog;
    RemoveObjSheet: TTabSheet;
    RemoveObjButton: TButton;
    RemoveObjLabel1: TLabel;
    Label2: TLabel;
    RemoveObjLabel2: TLabel;
    SearchSheet: TTabSheet;
    SearchPathEdit: TLabeledEdit;
    SearchPathButton: TButton;
    SearchPathDialog: TJvBrowseForFolderDialog;
    StartSearchButton: TButton;
    StopSearchButton: TButton;
    SearchProgressLabel: TLabel;
    SearchResultLabel: TLabel;
    SearchProcessTimer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ObjectListGridSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure TakeObjectButtonClick(Sender: TObject);
    procedure DestPathButtonClick(Sender: TObject);
    procedure ReplaceButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure RemoveObjButtonClick(Sender: TObject);
    procedure StartSearchButtonClick(Sender: TObject);
    procedure StopSearchButtonClick(Sender: TObject);
    procedure SearchPathButtonClick(Sender: TObject);
    procedure SearchPathEditChange(Sender: TObject);
    procedure ProcedurePagesChanging(Sender: TObject; var AllowChange: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure SearchProcessTimerTimer(Sender: TObject);
  private
    FSammlung: TBildersammlung;
    GridObjects: array of TSammelobjekt;
    RepairActions: array of TRepairAction;
    FSearchThread: TRepairSearchThread;
    FSearchTargets: TStrings;
    function FileOrFolderExists(const path: string): boolean;
  protected
    procedure SetSammlung(const Value: TBildersammlung);
		procedure JobDone(var message: TMessage); message um_JobDone;
    procedure DoRepairs;
  public
		property	Sammlung: TBildersammlung read FSammlung write SetSammlung;
  end;

var
  SammlungRepairForm: TSammlungRepairForm;

implementation
uses
  gnugettext;

resourcestring
  SObjectColumnTitle = 'Title';
  SStatusColumnTitle = 'Status';
  SOldPathColumnTitle = 'Previous Path';
  SNewPathColumnTitle = 'New Path';
  SInvalidPathStatus = 'Invalid Path';
  SFileFoundStatus = 'File found';
  SItemToBeRemoved = 'To be removed';
  SConfirmRepairMessage =
    'The repair process cannot be undone.'#13#10 +
    'Would you like to proceed anyway?';

{$R *.DFM}

{ TSammlungRepairForm }

procedure TSammlungRepairForm.FormCreate(Sender: TObject);
var
  w: integer;
begin
  TranslateComponent(Self);
  with ObjectListGrid do begin
    w := ClientWidth - 1;
    ColWidths[0] := Round(w * 0.20);
    ColWidths[1] := Round(w * 0.10);
    ColWidths[2] := Round(w * 0.35);
    ColWidths[3] := Round(w * 0.35);
    Cells[0, 0] := SObjectColumnTitle;
    Cells[1, 0] := SStatusColumnTitle;
    Cells[2, 0] := SOldPathColumnTitle;
    Cells[3, 0] := SNewPathColumnTitle;
  end;
end;

procedure TSammlungRepairForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FSearchThread);
  FreeAndNil(FSearchTargets);
end;

procedure TSammlungRepairForm.FormClose;
begin
  if Assigned(FSearchThread) then begin
    FSearchThread.Terminate;
    FSearchThread.WaitFor;
  end;
  if ModalResult = mrOK then DoRepairs;
end;

procedure TSammlungRepairForm.FormCloseQuery;
begin
  CanClose := (ModalResult = mrCancel) or
    (not Assigned(FSearchThread) and
    (MessageDlg(SConfirmRepairMessage, mtConfirmation, [mbYes, mbNo], 0) = mrYes));
end;

procedure TSammlungRepairForm.FormResize(Sender: TObject);
var
  w: integer;
  owidth: integer;
  ofracs: array[0..3] of single;
begin
  with ObjectListGrid do begin
    w := ClientWidth - 1;
    owidth := ColWidths[0] + ColWidths[1] + ColWidths[2] + ColWidths[3];
    if owidth < 1 then owidth := ClientWidth - 1;
    ofracs[0] := ColWidths[0] / owidth;
    ofracs[1] := ColWidths[1] / owidth;
    ofracs[2] := ColWidths[2] / owidth;
    ofracs[3] := ColWidths[3] / owidth;
    ColWidths[0] := Round(w * ofracs[0]);
    ColWidths[1] := Round(w * ofracs[1]);
    ColWidths[2] := Round(w * ofracs[2]);
    ColWidths[3] := Round(w * ofracs[3]);
  end;
end;

procedure TSammlungRepairForm.ObjectListGridSelectCell(Sender: TObject;
  ACol, ARow: Integer; var CanSelect: Boolean);
begin
  CanSelect := ARow >= 1;
end;

procedure TSammlungRepairForm.ProcedurePagesChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange := (ProcedurePages.ActivePage <> SearchSheet) or
    not Assigned(FSearchThread);
end;

procedure TSammlungRepairForm.SetSammlung(const Value: TBildersammlung);
var
  iSammlung: integer;
  iGrid: integer;
  Obj: TSammelobjekt;
begin
  FSammlung := Value;
  if Assigned(Sammlung) and (Sammlung.Count > 0) then begin
    ObjectListGrid.RowCount := Sammlung.Count + 1;
    SetLength(GridObjects, Sammlung.Count);
    SetLength(RepairActions, Sammlung.Count);
    iGrid := 0;
    for iSammlung := 0 to Sammlung.Count - 1 do begin
      Obj := Sammlung.Items[iSammlung];
      if Obj.BildStatus = bsFileNotFound then begin
        ObjectListGrid.Cells[0, iGrid+1] := Obj.Name;
        ObjectListGrid.Cells[1, iGrid+1] := SInvalidPathStatus;
        ObjectListGrid.Cells[2, iGrid+1] := Obj.Pfad;
        ObjectListGrid.Cells[3, iGrid+1] := '';
        GridObjects[iGrid] := Obj;
        RepairActions[iGrid] := raNone;
        Inc(iGrid);
      end;
    end;
    ObjectListGrid.RowCount := iGrid + 1;
    SetLength(GridObjects, iGrid);
    SetLength(RepairActions, iGrid);
  end else begin
    ObjectListGrid.RowCount := 1;
    SetLength(GridObjects, 0);
    SetLength(RepairActions, 0);
  end;
end;

function TSammlungRepairForm.FileOrFolderExists;
begin
  if path <> '' then begin
    if path[Length(path)] <> PathDelim then begin
      result := FileExists(path);
    end else begin
      result := DirectoryExists(Copy(path, 1, Length(path) - 1));
    end;
  end else
    result := false;
end;

procedure TSammlungRepairForm.DestPathButtonClick;
begin
  DestPathDialog.InitialDir := DestPathEdit.Text;
  if DestPathDialog.Execute then
    DestPathEdit.Text := ExtractFilePath(DestPathDialog.FileName);
end;

procedure TSammlungRepairForm.SearchPathButtonClick;
begin
  SearchPathDialog.Directory := SearchPathEdit.Text;
  if SearchPathDialog.Execute then
    SearchPathEdit.Text := SearchPathDialog.Directory;
end;

procedure TSammlungRepairForm.SearchPathEditChange;
begin
  StartSearchButton.Enabled := DirectoryExists(SearchPathEdit.Text);
end;

procedure TSammlungRepairForm.SearchProcessTimerTimer(Sender: TObject);
var
  nFoldersSearched, nFilesSearched, nFilesFound: integer;
  sFoldersSearched, sFilesSearched, sFilesFound: string;
begin
  if Assigned(FSearchThread) then begin
    nFoldersSearched := FSearchThread.FoldersSearched;
    nFilesSearched := FSearchThread.FilesSearched;
    nFilesFound := FSearchThread.FilesFound;
    sFoldersSearched := Format(dngettext('plurals', '%d folder', '%d folders',
      nFoldersSearched), [nFoldersSearched]);
    sFilesSearched := Format(dngettext('plurals', '%d file', '%d files',
      nFilesSearched), [nFilesSearched]);
    sFilesFound := Format(dngettext('plurals', '%d file', '%d files',
      nFilesFound), [nFilesFound]);
    // formatted string - example: 5 folders (278 files) searched
    SearchProgressLabel.Caption := Format(_('%s (%s) searched'),
      [sFoldersSearched, sFilesSearched]);
    // formatted string - example: 7 files found
    SearchResultLabel.Caption := Format(_('%s found'),
      [sFilesFound]);
  end;
end;

procedure TSammlungRepairForm.StartSearchButtonClick;
var
  i: integer;
  path, filename: string;
begin
  if DirectoryExists(SearchPathEdit.Text) then begin
    SearchProgressLabel.Caption := '';
    SearchResultLabel.Caption := '';
    SearchProgressLabel.Visible := true;
    SearchResultLabel.Visible := true;
    SearchProcessTimer.Enabled := true;
    SearchPathButton.Enabled := false;
    StopSearchButton.Enabled := true;
    StartSearchButton.Enabled := false;
    OkButton.Enabled := false;
    FSearchTargets := TStringList.Create;
    for i := Low(GridObjects) to High(GridObjects) do begin
      path := GridObjects[i].Pfad;
      if GridObjects[i] is TSammelordner then begin
        filename := ExtractFileName(ExcludeTrailingPathDelimiter(path));
        filename := IncludeTrailingPathDelimiter(filename);
        FSearchTargets.Add(filename);
      end else begin
        filename := ExtractFileName(path);
        FSearchTargets.Add(filename);
      end;
    end;
    FSearchThread := TRepairSearchThread.Create(SearchPathEdit.Text,
      FSearchTargets, Handle);
  end;
end;

procedure TSammlungRepairForm.StopSearchButtonClick;
begin
  if Assigned(FSearchThread) then FSearchThread.Terminate;
end;

procedure TSammlungRepairForm.JobDone;
var
  iGrid: integer;
  old, new: string;
begin
  iGrid := message.WParam;
  if iGrid >= 0 then begin
    // a file was found
    new := FSearchThread.ResultPath[iGrid];
    old := ObjectListGrid.Cells[3, iGrid + 1];
    if (old = '') and FileOrFolderExists(new) then begin
      ObjectListGrid.Cells[3, iGrid + 1] := new;
      ObjectListGrid.Cells[1, iGrid + 1] := SFileFoundStatus;
      RepairActions[iGrid] := raFixPath;
    end;
  end else begin
    // the search is complete
    SearchProcessTimer.Enabled := false;
    SearchProcessTimerTimer(Self);
    StopSearchButton.Enabled := false;
    StartSearchButton.Enabled := true;
    SearchPathButton.Enabled := true;
    OkButton.Enabled := true;
    FreeAndNil(FSearchTargets);
    FreeAndNil(FSearchThread);
  end;
end;

procedure TSammlungRepairForm.TakeObjectButtonClick(Sender: TObject);
var
  iGrid: integer;
begin
  iGrid := ObjectListGrid.Selection.Top - 1;
  if (iGrid >= Low(GridObjects)) and (iGrid <= High(GridObjects)) then begin
    SourcePathEdit.Text := ExtractFilePath(ObjectListGrid.Cells[2, iGrid+1]);
  end;
end;

procedure TSammlungRepairForm.RemoveObjButtonClick(Sender: TObject);
var
  iGrid: integer;
  repairpath: string;
begin
  for iGrid := Low(GridObjects) to High(GridObjects) do begin
    repairpath := ObjectListGrid.Cells[3, iGrid + 1];
    if
      (repairpath = '') or
      (RepairActions[iGrid] <> raFixPath)
    then begin
      RepairActions[iGrid] := raRemove;
      ObjectListGrid.Cells[3, iGrid + 1] := '';
      ObjectListGrid.Cells[1, iGrid + 1] := SItemToBeRemoved;
    end;
  end;
end;

procedure TSammlungRepairForm.ReplaceButtonClick(Sender: TObject);
var
  iGrid: integer;
  src: string; // portion of path to be replaced
  dst: string; // replacement
  old: string; // old path
  new: string; // new path
begin
  src := SourcePathEdit.Text;
  dst := DestPathEdit.Text;
  for iGrid := Low(GridObjects) to High(GridObjects) do begin
    old := ObjectListGrid.Cells[2, iGrid+1];
    if SameFileName(Copy(old, 1, Length(src)), src) then begin
      new := dst + Copy(old, Length(src) + 1, Length(old));
      ObjectListGrid.Cells[3, iGrid+1] := new;
      if FileOrFolderExists(new) then begin
        RepairActions[iGrid] := raFixPath;
        ObjectListGrid.Cells[1, iGrid+1] := SFileFoundStatus;
      end else begin
        RepairActions[iGrid] := raNone;
        ObjectListGrid.Cells[1, iGrid+1] := SInvalidPathStatus;
      end;
    end;
  end;
end;

procedure TSammlungRepairForm.DoRepairs;
var
  iGrid: Integer;
  old, new: string;
begin
  Sammlung.BeginUpdate;
  try
    for iGrid := Low(GridObjects) to High(GridObjects) do begin
      old := ObjectListGrid.Cells[2, iGrid + 1];
      new := ObjectListGrid.Cells[3, iGrid + 1];
      case RepairActions[iGrid] of
        raFixPath: begin
          GridObjects[iGrid].Pfad := new;
        end;
        raRemove: begin
          Sammlung.FreeItem(GridObjects[iGrid])
        end;
      end;
    end;
  finally
    Sammlung.EndUpdate;
  end;
end;

end.
