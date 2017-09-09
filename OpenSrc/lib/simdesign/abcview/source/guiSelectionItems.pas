{ unit SelectionItems

  The frame for the selection filter

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit guiSelectionItems;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  guiFilterFrame, ExtCtrls, Buttons, ComCtrls, BrowseTrees,
  sdSortedLists, sdItems, ImgList, ActnList, sdAbcVars,
  guiItemView;

type

  TSelectionFrame = class(TFilterFrame)
    pcSelection: TPageControl;
    tsItems: TTabSheet;
    SpeedButton1: TSpeedButton;
    Panel1: TPanel;
    ivSelection: TItemView;
    alSelection: TActionList;
    RemoveFromSelection: TAction;
    ilSelection: TImageList;
    procedure RemoveFromSelectionExecute(Sender: TObject);
  private
  public
    procedure FrameClose; override;
    procedure FilterToDlg; override;
  end;

  TSelectionItem = class(TBrowseItem)
  private
    FSelection: TSortedList;
  public
    destructor Destroy; override;
    procedure AddItems(Sender: TObject; AList: TList);
    procedure RemoveItems(Sender: TObject; AList: TList);
    procedure FilterAcceptItem(Sender: TObject; Item: TsdItem; var Accept: boolean); virtual;
    procedure CreateFilterParams; override;
  end;



implementation

uses
  Filters, guiMain;

{$R *.DFM}

{ TSelectionItem }

procedure TSelectionFrame.FrameClose;
begin
  // Remove ivSelection from the filter chain
  if assigned(Item) then
    TSelectionItem(Item).DisconnectNode(ivSelection.ItemList);
  ivSelection.ListView.Selected := nil;
end;

procedure TSelectionFrame.FilterToDlg;
begin
  // Connect to provider frmABC
  ivSelection.OnSetItemType := frmMain.ItemviewSetItemType;
  frmMain.ItemviewSetItemType(ivSelection, itFile);
  ivSelection.ViewStyle := lvsReport;

  // point dropfile source images to global icon list
  ivSelection.dfsFiles.Images := FLargeIcons;

  // Tap ivSelection into the filter chain
  if assigned(Item) then
    TSelectionItem(Item).ConnectNode(ivSelection.ItemList);

  // Clear any selection
  ivSelection.ListView.Selected := nil;
end;

procedure TSelectionItem.CreateFilterParams;
begin
  Options := Options + [biAllowRename, biAllowRemove];
  // Defaults
  Caption := 'User Selection';
  ImageIndex := 9;

  DialogCaption := 'User election';
  DialogIcon := 3;

  // Initialise the selection list
  FSelection := TSortedList.Create(False);
  FSelection.CompareMethod := CompareItemGuid;

  // add a normal filter with OnAcceptItem connected to SelectionItem
  Filter := TFilter.Create;
  with TFilter(Filter) do
  begin
    ExpandedSelection := True;
    OnAcceptItem := FilterAcceptItem;
  end;

  // Set frame class
  FrameClass := TSelectionFrame;
end;

destructor TSelectionItem.Destroy;
begin
  // make sure the filter will not refer to FSelection when that one is destroyed
  if assigned(Filter) and assigned(Filter.Parent) then
    Filter.Parent.DisconnectNode(Filter);

  if assigned(FSelection) then
    FreeAndNil(FSelection);
  inherited;
end;

procedure TSelectionItem.AddItems(Sender: TObject; AList: TList);
var
  i, Index: integer;
  Item: TsdItem;
begin
  if assigned(AList) and assigned(FSelection) then
  begin
    // Add all elements to the list, but skip dupes
    for i := 0 to AList.Count - 1 do
    begin
      Item := TsdItem(AList[i]);
      if not FSelection.Find(Item, Index) then
        FSelection.Add(Item);
    end;
    // Now fire off the filter again
    if assigned(Filter) then
      Filter.Execute;
  end;
end;

procedure TSelectionItem.RemoveItems(Sender: TObject; AList: TList);
var
  i: integer;
  Item: TsdItem;
begin
  if assigned(AList) and assigned(FSelection) then
  begin
    // Remove all elements from the list
    for i := 0 to AList.Count - 1 do
    begin
      Item := TsdItem(AList[i]);
      FSelection.Remove(Item);
    end;
    // Now fire off the filter again
    if assigned(Filter) then
      Filter.Execute;
  end;
end;

procedure TSelectionItem.FilterAcceptItem(Sender: TObject; Item: TsdItem; var Accept: boolean);
var
  Index: integer;
begin
  // Check if Item is in our list
  Accept := False;
  if assigned(Item) and assigned(FSelection) then
  begin
    if FSelection.Find(Item, Index) then
      Accept := True;
  end;
end;

procedure TSelectionFrame.RemoveFromSelectionExecute(Sender: TObject);
var
  Removes: TList;
begin
  // Remove the selected items from the TSelectionItem
  if assigned(Item) then
  with TSelectionItem(Item) do
  begin
    Removes := TList.Create;
    try
      // Retrieve a list in Removes
      ivSelection.AddSelectedItems(Removes);
      // And remove this list from our selection
      RemoveItems(Sender, Removes);
    finally
      Removes.Free;
    end;
  end;
end;

end.
