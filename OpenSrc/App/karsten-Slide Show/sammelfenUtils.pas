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
 * The Original Code is sammelfenUtils.pas of Karsten Bilderschau, version 3.3.0
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

{ $Id: sammelfenUtils.pas 117 2008-02-11 02:21:22Z hiisi $ }

{
@abstract Utility classes for @link(TCollectionForm)
@author matthias muntwiler <hiisi@users.sourceforge.net>
@created 2006/09/02
@cvs $Date: 2008-02-10 20:21:22 -0600 (So, 10 Feb 2008) $
}
unit sammelfenUtils;

interface
uses
  Windows, SysUtils, Classes, Graphics, Forms, Controls, ComCtrls, ComObj,
  ShlObj, Math,
  sammelklassen, sammlung, jobs, thumbnails;

type
  TCheckObjektJob = class(TJob)
  private
    FPath: string;
    FBildStatus: TBildStatus;
  public
    constructor Create(ATicket: integer; const APath: string);
    property  Path: string read FPath write FPath;
    property  BildStatus: TBildStatus read FBildStatus;
  end;

  TCheckBildJob = class(TCheckObjektJob)
  protected
    procedure Execute; override;
  public
    constructor Create(ATicket: integer; const APath: string);
  end;

  TCheckBildOrdnerJob = class(TCheckObjektJob)
  protected
    procedure Execute; override;
  public
    constructor Create(ATicket: integer; const APath: string);
  end;

  TResolveShellLinkJob = class(TJob)
  private
    FSuccess: boolean;
    FShellLink: IShellLink;
    FResolvedPath: string;
    FOriginalPath: string;
  protected
    procedure Execute; override;
  public
    constructor Create(ATicket: integer; const AShellLink: IShellLink; const AOriginalPath: string);
    { Path of the sammelobjekt before link resolution.
      This is used to detect whether the user has changed the path manually
      while the job was in progress. }
    property  OriginalPath: string read FOriginalPath write FOriginalPath;
    { Shell link to be resolved. }
    property  ShellLink: IShellLink read FShellLink write FShellLink;
    { @true if the file was found. }
    property  Success: boolean read FSuccess;
    { New path from @link(ShellLink) after successful resolution.
      Empty f @link(Success) = @false. }
    property  ResolvedPath: string read FResolvedPath;
  end;

  TJobType = (jtNone, jtCheckStatus, jtExtractThumbnail, jtResolveShellLink);
  TJobInfoEvent = procedure(Sender: TObject; const message: string) of object;

  { @abstract(Updates the items of @link(TCollectionForm.BilderListe))
    This class is responsible for updating text and icons of the list view items.
    Updating an icon involves the following steps
    @orderedList(
      @item(check @link(Bildstatus))
      @item(determine item type and select default icon)
      @item(generate thumbnail image)
      @item(resolve shell link if the file is not found)
      )
    These steps are carried out in a separate thread.
    Steps 1-3 are carried out by @link(TExtractThumbnailJob),
    step 4 is carried out by @link(TResolveShellLinkJob).

    To get started, call the constructor, and assign the @link(Sammlung) property.
    All processing is triggered through @link(SammlungChange)
    which should be assigned to the OnChange handler of @link(TSammlung).
    @link(JobDone) must be called in response to the @link(um_JobDone) message
    to complete processing.
    Call @link(CustomDrawItem) in response to the OnCustomDrawItem event
    of the list view.
    }
  TSammlungListViewManager = class
  strict private
    FParent: TForm;
    FSammlung: TBilderSammlung;
    FListView: TListView;
    FLargeIcons: TImageList;
    FSmallIcons: TImageList;
    FCheckStatusThread: TJobThread;
    FResolveLinksThread: TJobThread;
    FExtractThumbnailsThread: TJobThread;
    FOnJobInfo: TJobInfoEvent;
    FPendingJobs: array[TJobType] of integer;
    FLastJobDoneTick: int64;
    procedure SetSammlung(const Value: TBilderSammlung);
  protected
    DefIconsSmall: array[TIconKind] of TBitmap;
    DefIconsLarge: array[TIconKind] of TBitmap;
    property  ListView: TListView read FListView;
    procedure BilderlisteCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure CheckBild(ASammelbild: TSammelbild);
    procedure CheckBildOrdner(ASammelordner: TSammelordner);
    procedure CheckObjektDone(const Job: TCheckObjektJob);
    procedure ExtractThumbnail(Obj: TSammelobjekt);
    procedure ExtractThumbnailDone(const Job: TExtractThumbnailJob);
    procedure ResolveShellLink(Obj: TSammelobjekt);
    procedure ResolveShellLinkDone(const Job: TResolveShellLinkJob);
    { Cancel all pending jobs - the sammlung has been cleared. }
    procedure CancelAllJobs;
    { Provide information about current jobs via the @link(OnJobInfo) event. }
    procedure DoJobInfo(CheckDone: boolean = false);
  public
    { Image lists of AListView must be set and contain the default icons. }
    constructor Create(AParent: TForm; AListView: TListView);
    destructor  Destroy; override;
    { Assign the @link(TBilderSammlung) to be displayed in the @link(ListView). }
    property  Sammlung: TBilderSammlung read FSammlung write SetSammlung;
    { Hook this method to the OnChange event of @link(Sammlung).
      In order to keep the flexibility, this is not done automatically. }
    procedure SammlungChange(Sender: TBilderSammlung; changes: TSammlungChanges;
      Item: TSammelobjekt);
    { Call this method in response to the @link(um_JobDone) message. }
    procedure JobDone(var message: TUMJobDone);
    { Hook this method to the OnCustomDrawItem event of the @link(ListView).
      In order to keep the flexibility, this is not done automatically. }
    procedure CustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    { Provides a message with the number of pending jobs.
      The event fires each time the job queue changes
      due to adding, completing, or cancelling of a job. }
    property  OnJobInfo: TJobInfoEvent read FOnJobInfo write FOnJobInfo;
  end;

  { @abstract A visitor to update a viewer from the collection data
    Create an object of this class and pass it each changed collection item
    in order to update the collection viewer
    which is represented by a @link(TSammlungListViewManager).

    You can either have one instance for all collection items,
    or create instances dynamically for each collection item.
    @classname will also store viewer information in the
    @link(TSammelobjekt.IconIndex) and @link(TSammelobjekt.ViewerItem) properties. }
  TViewItemUpdater = class(TSammelobjektVisitor)
  private
    FManager: TSammlungListViewManager;
  protected
    { Stores a reference to the list view manager
      that was passed to the constructor @link(Create). }
    property  Manager: TSammlungListViewManager read FManager;
  public
    { Creates a new updater object.
      @param AManager must be a valid instance of a list view manager. }
    constructor Create(AManager: TSammlungListViewManager);
    { Update the list view item that is linked to the given collection item.
      This will set the text of the item,
      and establish links between the collection item and the list view item.
      The TListItem is stored in @link(TSammelobjekt.ViewerItem). }
    procedure VisitSammelobjekt(ASammelobjekt: TSammelobjekt); override;
    { Update the list view item that is linked to the given collection picture.
      Calls @link(VisitSammelobjekt) and sets the correct icon.
      This method also triggers file status checking and shell resolution
      if necessary. }
    procedure VisitSammelbild(ASammelbild: TSammelbild); override;
    { Update the list view item that is linked to the given collection folder.
      Calls @link(VisitSammelobjekt) and sets the correct icon.
      This method also triggers folder status checking and shell resolution
      if necessary. }
    procedure VisitSammelordner(ASammelordner: TSammelordner); override;
  end;

const
  { Icon indices of the default list view icons in the image lists of the form }
  DefIconIndex: array[TIconKind] of integer = (0, 4, 9, 5, 6);
  { Icon index of the error icon in the image lists of the form }
  ErrorIconIndex = 2;
  { Highest predefined icon index in the image lists of the form }
  MaxDefIconIndex = 12;
  { Index of the error indicating overlay }
  ErrorOverlayIndex = 0;

implementation
uses
  globals, shelllinks, karsreg;

resourcestring
  SJobInfo = 'Background jobs: Status %d, Links %d, Thumbnails %d';

{ TViewItemUpdater }

constructor TViewItemUpdater.Create(AManager: TSammlungListViewManager);
begin
  inherited Create;
  FManager := AManager;
end;

procedure TViewItemUpdater.VisitSammelobjekt(ASammelobjekt: TSammelobjekt);
var
  LI: TListItem;
  dt: TDateTime;
begin
  LI := ASammelobjekt.ViewerItem as TListItem;
  if not Assigned(LI) then begin
    LI := Manager.ListView.Items.Add;
    ASammelobjekt.ViewerItem := LI;
  end;
  LI.Caption := ASammelobjekt.Name;
  LI.Data := ASammelobjekt;
  LI.SubItems.Clear;
  dt := ASammelobjekt.Wartezeit / SecsPerDay;
  LI.SubItems.Add(FormatDateTime('hh:nn:ss', dt));
  LI.SubItems.Add(IntToStr(ASammelobjekt.Haeufigkeit));
  LI.SubItems.Add(IntToStr(ASammelobjekt.SequenceNumber));
  LI.SubItems.Add(ASammelobjekt.Pfad);
end;

procedure TViewItemUpdater.VisitSammelbild(ASammelbild: TSammelbild);
var
  LI: TListItem;
  gf: TGrafikformat;
  ik: TIconKind;
  ii: integer;
begin
  VisitSammelobjekt(ASammelbild);
  LI := ASammelbild.ViewerItem as TListItem;
  if not Assigned(LI) then Exit;
  if ASammelbild.IconIndex = -1 then
    ii := DefIconIndex[ikUnknown]
  else
    ii := Abs(ASammelbild.IconIndex);
  case ASammelbild.BildStatus of
    bsPending: begin
      Manager.CheckBild(ASammelbild);
      if ASammelbild.IconIndex > MaxDefIconIndex then
        ASammelbild.IconIndex := -ASammelbild.IconIndex;
    end;
    bsOK: begin
      if ASammelbild.IconIndex = -1 then begin
        gf := MediaTypes.GetGrafikformat(ExtractFileExt(ASammelbild.Pfad));
        ik := CGrafikformatIconKind[gf];
        ASammelbild.IconIndex := -DefIconIndex[ik];
        ii := DefIconIndex[ik];
      end;
    end;
    bsResolvePending:
      Manager.ResolveShellLink(ASammelbild);
    bsFileNotFound..bsReadError:
      ii := ErrorIconIndex;
  end;
  LI.ImageIndex := ii;
end;

procedure TViewItemUpdater.VisitSammelordner(ASammelordner: TSammelordner);
var
  LI: TListItem;
begin
  VisitSammelobjekt(ASammelordner);
  LI := ASammelordner.ViewerItem as TListItem;
  if not Assigned(LI) then Exit;
  if ASammelordner.IconIndex = -1 then begin
    LI.ImageIndex := DefIconIndex[ikUnknown];
  end else
    LI.ImageIndex := Abs(ASammelordner.IconIndex);
  case ASammelordner.BildStatus of
    bsPending: begin
      Manager.CheckBildOrdner(ASammelordner);
      ASammelordner.IconIndex := -1;
    end;
    bsResolvePending: begin
      Manager.ResolveShellLink(ASammelordner);
      ASammelordner.IconIndex := -1;
    end;
    bsOK:
      if ASammelordner.IconIndex < 0 then begin
        ASammelordner.IconIndex := DefIconIndex[ikFolder];
        LI.ImageIndex := ASammelordner.IconIndex;
      end;
    bsFileNotFound..bsReadError:
      LI.ImageIndex := ErrorIconIndex;
  end;
end;

{ TResolveShellLinkJob }

constructor TResolveShellLinkJob.Create;
begin
  inherited Create(ATicket);
  FOriginalPath := AOriginalPath;
  FResolvedPath := '';
  FSuccess := false;
  FShellLink := CreateShellLink('');
  // since the link will be resolved in another thread we should clone it
  CloneShellLink(AShellLink, FShellLink);
end;

procedure TResolveShellLinkJob.Execute;
begin
  inherited;
  try
    FResolvedPath := ResolveShellLink(FShellLink, 0);
    FSuccess := FResolvedPath <> '';
    SetStatus(jsSuccess);
  except
    on EOleSysError do begin
      SetStatus(jsFail);
    end;
  end;
end;

{ TSammlungListViewManager }

constructor TSammlungListViewManager.Create;
var
  ik: TIconKind;
begin
  inherited Create;
  FParent := AParent;
  FSammlung := nil;
  FListView := AListView;
  FLargeIcons := AListView.LargeImages as TImageList;
  FSmallIcons := AListView.SmallImages as TImageList;
  FCheckStatusThread := TJobThread.Create(AParent.Handle);
  FCheckStatusThread.Priority := tpLower;
  FResolveLinksThread := TJobThread.Create(AParent.Handle);
  FResolveLinksThread.Priority := tpIdle;
  FExtractThumbnailsThread := TJobThread.Create(AParent.Handle);
  FExtractThumbnailsThread.Priority := tpLowest;
  for ik := Low(TIconKind) to High(TIconKind) do begin
    DefIconsSmall[ik] := TBitmap.Create;
    DefIconsSmall[ik].SetSize(FSmallIcons.Width, FSmallIcons.Height);
    FSmallIcons.GetBitmap(DefIconIndex[ik], DefIconsSmall[ik]);
    DefIconsLarge[ik] := TBitmap.Create;
    DefIconsLarge[ik].SetSize(FLargeIcons.Width, FLargeIcons.Height);
    FLargeIcons.GetBitmap(DefIconIndex[ik], DefIconsLarge[ik]);
  end;
  FLastJobDoneTick := GetTickCount;
end;

destructor TSammlungListViewManager.Destroy;
var
  ik: TIconKind;
begin
  FreeAndNil(FResolveLinksThread);
  FreeAndNil(FExtractThumbnailsThread);
  FreeAndNil(FCheckStatusThread);
  for ik := Low(TIconKind) to High(TIconKind) do begin
    FreeAndNil(DefIconsSmall[ik]);
    FreeAndNil(DefIconsLarge[ik]);
  end;
  inherited;
end;

procedure TSammlungListViewManager.SetSammlung;
var
  ik: TIconKind;
  i: integer;
begin
  if Value <> FSammlung then begin
    FSammlung := Value;
    if Assigned(FSammlung) then
      for i := 0 to FSammlung.Count - 1 do
        FSammlung[i].IconIndex := -1;
    if Assigned(FListView) then
      FListView.Items.Clear;
    if FLargeIcons.Count > MaxDefIconIndex + 1 then begin
      FLargeIcons.Clear;
      for ik := Low(TIconKind) to High(TIconKind) do begin
        FLargeIcons.Add(DefIconsLarge[ik], nil);
      end;
    end;
    if FSmallIcons.Count > MaxDefIconIndex + 1 then begin
      FSmallIcons.Clear;
      for ik := Low(TIconKind) to High(TIconKind) do begin
        FSmallIcons.Add(DefIconsSmall[ik], nil);
      end;
    end;
  end;
end;

procedure TSammlungListViewManager.BilderlisteCompare;
var
  idx1, idx2: integer;
begin
  idx1 := FSammlung.IndexOf(TSammelobjekt(Item1.Data));
  idx2 := FSammlung.IndexOf(TSammelobjekt(Item2.Data));
  compare := idx1 - idx2;
end;

procedure TSammlungListViewManager.SammlungChange;
var
  Updater: TViewItemUpdater;
  idx: integer;
  ListItem: TListItem;
  AllocBy: integer;
begin
  if not Assigned(FSammlung) or (Sender <> FSammlung) then Exit;
  if changes <> [] then begin
    FListView.Items.BeginUpdate;
    try
      // add and update list items from FSammlung
      if not (scRemoveObject in changes) or not Assigned(Item) then begin
        AllocBy := Max(20 + MaxDefIconIndex + 1,
          Max(FSammlung.Count + MaxDefIconIndex + 1, FLargeIcons.Count));
        FLargeIcons.AllocBy := AllocBy;
        FSmallIcons.AllocBy := AllocBy;
        Updater := TViewItemUpdater.Create(Self);
        try
          if Assigned(Item) then
            Item.AcceptVisitor(Updater)
          else
            FSammlung.AcceptItemsVisitor(Updater);
        finally
          Updater.Free;
        end;
      end;
      // remove orphans
      if scRemoveObject in changes then begin
        for idx := FListView.Items.Count - 1 downto 0 do begin
          ListItem := FListView.Items[idx];
          if FSammlung.IndexOf(TSammelobjekt(ListItem.Data)) < 0 then
            FListView.Items.Delete(idx);
        end;
        if FSammlung.Count = 0 then CancelAllJobs;
      end;
      // sort
      if scChangeOrder in changes then begin
        FListView.SortType := stData;
        FListView.OnCompare := BilderlisteCompare;
        FListView.AlphaSort;
      end;
    finally
      FListView.Items.EndUpdate;
    end;
  end;
end;

procedure TSammlungListViewManager.CancelAllJobs;
var
  n: integer;
begin
  n := FCheckStatusThread.CancelJobs(0, true);
  FPendingJobs[jtCheckStatus] := FPendingJobs[jtCheckStatus] - n;
  n := FExtractThumbnailsThread.CancelJobs(0, true);
  FPendingJobs[jtExtractThumbnail] := FPendingJobs[jtExtractThumbnail] - n;
  n := FResolveLinksThread.CancelJobs(0, true);
  FPendingJobs[jtResolveShellLink] := FPendingJobs[jtResolveShellLink] - n;
  DoJobInfo;
end;

procedure TSammlungListViewManager.CheckBild;
var
  n: integer;
begin
  n := FCheckStatusThread.CancelJobs(ASammelbild.ID);
  FCheckStatusThread.AddJob(TCheckBildJob.Create(ASammelbild.ID, ASammelbild.Pfad));
  FPendingJobs[jtCheckStatus] := FPendingJobs[jtCheckStatus] + 1 - n;
  DoJobInfo;
end;

procedure TSammlungListViewManager.CheckBildOrdner;
var
  n: integer;
begin
  n := FCheckStatusThread.CancelJobs(ASammelordner.ID);
  FCheckStatusThread.AddJob(TCheckBildOrdnerJob.Create(ASammelordner.ID, ASammelordner.Pfad));
  FPendingJobs[jtCheckStatus] := FPendingJobs[jtCheckStatus] + 1 - n;
  DoJobInfo;
end;

procedure TSammlungListViewManager.CheckObjektDone;
var
  ListItem: TListItem;
  iItem: integer;
  Item: TSammelobjekt;
begin
  Dec(FPendingJobs[jtCheckStatus]);
  iItem := FSammlung.IndexOfID(Job.Ticket);
  if iItem >= 0 then begin
    Item := FSammlung[iItem];
    ListItem := FListView.FindData(0, Item, true, false);
    // check that the user hasn't changed the item in the meantime
    if Assigned(ListItem) and SameFileName(Job.Path, Item.Pfad) then begin
      // this will trigger thumbnail extraction or shell link resolution
      // through SammlungChange
      Item.BildStatus := Job.BildStatus;
    end;
  end;
end;

procedure TSammlungListViewManager.CustomDrawItem;
var
  LV: TListView;
  LVTop: integer;
  ItemTop: integer;
  Obj: TSammelobjekt;
begin
  LV := (Sender as TListView);
  if Assigned(Item) then begin
    Obj := TSammelobjekt(Item.Data);
    if Assigned(Obj) and (Obj.IconIndex < 0) and
      (Obj.BildStatus = bsOK) and (Obj is TSammelbild) and
      (LV.ViewStyle = vsIcon)
    then begin
      LVTop := LV.ViewOrigin.Y;
      ItemTop := Item.Top;
      if (ItemTop >= LVTop) and (ItemTop < LVTop + LV.Height) then
        ExtractThumbnail(Obj);
    end;
  end;
end;

procedure TSammlungListViewManager.ExtractThumbnail;
var
  n: integer;
begin
  n := FExtractThumbnailsThread.CancelJobs(Obj.ID);
  FExtractThumbnailsThread.AddJob(TExtractThumbnailJob.Create(Obj.ID, Obj.Pfad,
    FLargeIcons.Width, FLargeIcons.BkColor));
  FPendingJobs[jtExtractThumbnail] := FPendingJobs[jtExtractThumbnail] + 1 - n;
  DoJobInfo;
end;

procedure TSammlungListViewManager.ExtractThumbnailDone;
var
  ListItem: TListItem;
  iItem: integer;
  Item: TSammelobjekt;
  imgidx1, imgidx2: integer;
  LargeIcon, SmallIcon: TBitmap;
begin
  Dec(FPendingJobs[jtExtractThumbnail]);
  iItem := FSammlung.IndexOfID(Job.Ticket);
  if iItem >= 0 then begin
    Item := FSammlung[iItem];
    ListItem := FListView.FindData(0, Item, true, false);
    if Assigned(ListItem) and SameFileName(Job.FilePath, Item.Pfad) then begin
      imgidx1 := DefIconIndex[Job.IconKind];
      if Job.Status = jsSuccess then begin
        if Job.IconKind = ikPicture then begin
          LargeIcon := Job.GetThumbnail;
          if Assigned(LargeIcon) then begin
            try
              SmallIcon := DefIconsSmall[Job.IconKind];
              imgidx1 := Abs(Item.IconIndex);
              if imgidx1 <= MaxDefIconIndex then begin
                while FLargeIcons.Count < FSmallIcons.Count do
                  FLargeIcons.Add(DefIconsLarge[ikUnknown], nil);
                while FSmallIcons.Count < FLargeIcons.Count do
                  FSmallIcons.Add(DefIconsSmall[ikUnknown], nil);
                imgidx1 := FLargeIcons.Add(LargeIcon, nil);
                imgidx2 := FSmallIcons.Add(SmallIcon, nil);
                if imgidx1 <> imgidx2 then
                  imgidx1 := DefIconIndex[Job.IconKind];
              end else begin
                FLargeIcons.Replace(imgidx1, LargeIcon, nil);
                FSmallIcons.Replace(imgidx1, SmallIcon, nil);
              end;
            finally
              LargeIcon.Free;
            end;
          end;
        end;
        Item.IconIndex := imgidx1;
      end;
      ListItem.ImageIndex := imgidx1;
    end;
  end;
end;

procedure TSammlungListViewManager.ResolveShellLink;
var
  n: integer;
begin
  // prohibit duplicate jobs
  n := FResolveLinksThread.CancelJobs(Obj.ID);
  FResolveLinksThread.AddJob(TResolveShellLinkJob.Create(Obj.ID, Obj.ShellLink, Obj.Pfad));
  FPendingJobs[jtResolveShellLink] := FPendingJobs[jtResolveShellLink] + 1 - n;
  DoJobInfo;
end;

procedure TSammlungListViewManager.ResolveShellLinkDone;
var
  iItem: integer;
  Item: TSammelobjekt;
begin
  Dec(FPendingJobs[jtResolveShellLink]);
  iItem := FSammlung.IndexOfID(Job.Ticket);
  if iItem >= 0 then begin
    Item := FSammlung[iItem];
    // check that the user hasn't changed the path manually in the meantime
    if SameFileName(Job.OriginalPath, Item.Pfad) then begin
      if Job.Success then begin
        if FSammlung.AllowDuplicates or
          (FSammlung.IndexOfFile(Job.ResolvedPath) < 0)
        then
          Item.ShellLink := Job.ShellLink
        else
          FSammlung.FreeItem(Item);
      end else
        Item.BildStatus := bsFileNotFound;
    end;
  end;
end;

procedure TSammlungListViewManager.JobDone;
var
  JobThread: TJobThread;
  Job: TJob;
  tick: int64;
begin
  if not Assigned(FSammlung) or not Assigned(message.Sender) then Exit;
  JobThread := message.Sender as TJobThread;
  // do not update more than 10 times per second
  tick := GetTickCount;
  if (tick - FLastJobDoneTick < 100) and (JobThread.PendingJobs > 0) then Exit;
  FSammlung.BeginUpdate;
  try
    repeat
      Job := JobThread.PopResult;
      try
        if Assigned(Job) and (Job.Status = jsSuccess) then begin
          if Job is TCheckObjektJob then
            CheckObjektDone(Job as TCheckObjektJob)
          else if Job is TExtractThumbnailJob then
            ExtractThumbnailDone(Job as TExtractThumbnailJob)
          else if Job is TResolveShellLinkJob then
            ResolveShellLinkDone(Job as TResolveShellLinkJob);
        end;
      finally
        Job.Free;
      end;
    until
      not Assigned(Job);
  finally
    FSammlung.EndUpdate;
  end;
  DoJobInfo(true);
  FLastJobDoneTick := GetTickCount;
end;

procedure TSammlungListViewManager.DoJobInfo;
var
  msg: string;
begin
  if checkdone then begin
   if not Assigned(FOnJobInfo) or (FCheckStatusThread.PendingJobs = 0) then
     FPendingJobs[jtCheckStatus] := 0;
   if not Assigned(FOnJobInfo) or (FResolveLinksThread.PendingJobs = 0) then
     FPendingJobs[jtResolveShellLink] := 0;
   if not Assigned(FOnJobInfo) or (FExtractThumbnailsThread.PendingJobs = 0) then
     FPendingJobs[jtExtractThumbnail] := 0;
  end;
  if Assigned(FOnJobInfo) then begin
    if FPendingJobs[jtCheckStatus] + FPendingJobs[jtExtractThumbnail] +
      FPendingJobs[jtResolveShellLink] > 0
    then
      msg := Format(SJobInfo, [FPendingJobs[jtCheckStatus],
        FPendingJobs[jtResolveShellLink], FPendingJobs[jtExtractThumbnail]])
    else
      msg := '';
    FOnJobInfo(Self, msg);
  end;
end;

{ TCheckObjektJob }

constructor TCheckObjektJob.Create(ATicket: integer; const APath: string);
begin
  inherited Create(ATicket);
  FPath := APath;
  FBildStatus := bsPending;
end;

{ TCheckBildJob }

constructor TCheckBildJob.Create(ATicket: integer; const APath: string);
begin
  inherited;
end;

procedure TCheckBildJob.Execute;
begin
  inherited;
  if FPath = '' then begin
    FBildStatus := bsUndefined;
  end else if FileExists(FPath) then begin
    FBildStatus := bsOK;
  end else begin
    FBildStatus := bsResolvePending;
  end;
  SetStatus(jsSuccess);
end;

{ TCheckBildOrdnerJob }

constructor TCheckBildOrdnerJob.Create(ATicket: integer; const APath: string);
begin
  inherited;
end;

procedure TCheckBildOrdnerJob.Execute;
var
  code: integer;
  search: TSearchRec;
  found: boolean;
begin
  inherited;
  if FPath = '' then begin
    FBildStatus := bsUndefined;
  end else if DirectoryExists(FPath) then begin
    FBildStatus := bsOK;
  end else begin
    FBildStatus := bsResolvePending;
  end;
  if FBildStatus = bsOK then begin
    found := false;
    code := SysUtils.FindFirst(FPath + '*.*', faReadOnly or faHidden, search);
    try
      while code = 0 do begin
        found := MediaTypes.GetGrafikformat(search.Name) <> gfUnbekannt;
        if found then Break;
        code := SysUtils.FindNext(search);
      end;
    finally
      if not found then FBildStatus := bsFileNotFound;
      SysUtils.FindClose(search);
    end;
  end;
  SetStatus(jsSuccess);
end;

end.
