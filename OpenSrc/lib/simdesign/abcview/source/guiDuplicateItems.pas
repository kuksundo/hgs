{ Unit DupeItems

  Duplicate files dialog box

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit guiDuplicateItems;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, BrowseTrees, sdItems, sdAbcTypes, sdAbcFunctions,
  guiFilterFrame;

type

  // Frame belonging to DupeItem filter
  TDupeFrame = class(TFilterFrame)
    Label2: TLabel;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    chbNotify: TCheckBox;
    chbSortOnDupes: TCheckBox;
    GroupBox2: TGroupBox;
    chbFilterSmallerThan: TCheckBox;
    chbFilterBiggerThan: TCheckBox;
    chbFilterZeroByte: TCheckBox;
    cbbSmallerThan: TComboBox;
    cbbBiggerThan: TComboBox;
    chbDisplayDialog: TCheckBox;
    Label6: TLabel;
  private
    { Private declarations }
  public
    procedure DlgToFilter; override;
    procedure FilterToDlg; override;
  end;

  TDupeItem = class(TBrowseItem)
  protected
    // Override CreateFilterParams instead of Create to set the correct
    // set of filter, caption, frame etc
    procedure CreateFilterParams; override;
  public
    FNotifyShown: boolean;       // Notify dialog has been shown
    FCompareCount: integer;      // Total amount of compares
    FFilterSmallerThan: boolean; // Filter items smaller than..
    FFilterBiggerThan: boolean;  // Filter items bigger than..
    FSmallerThanStr: string;
    FSmallerThanSize: integer;   // The size for "smaller than"
    FBiggerThanStr: string;
    FBiggerThanSize: integer;    // The size for "bigger than"
    FFilterZeroByte: boolean;    // Filter out zero byte files
    procedure PreAcceptItem(Sender: TObject; AItem: TsdItem; var Accept: boolean);
    procedure PostProcess(Sender: TObject);
  end;


implementation

uses
  Duplicates, guiMain, sdAbcVars;

{$R *.DFM}

//
// TDupeFrame
//

procedure TDupeFrame.DlgToFilter;
begin
  try
  with TDupeItem(Item) do begin

    FDupeFilterNotify := chbNotify.Checked;
    FDupeFilterSortOnDupes := chbSortOnDupes.Checked;
    FFilterSmallerThan := chbFilterSmallerThan.Checked;
    FFilterBiggerThan := chbFilterBiggerThan.Checked;
    FSmallerThanStr := cbbSmallerThan.Text;
    FSmallerThanSize := SizeStrToInt(FSmallerThanStr);
    FBiggerThanStr := cbbBiggerThan.Text;
    FBiggerThanSize := SizeStrToInt(FBiggerThanStr);
    FFilterZeroByte := chbFilterZeroByte.Checked;
    FDupeFilterDisplayDialog := chbDisplayDialog.Checked;

    InitialiseFilter;
  end;
  except
    // Silent exception
  end;
end;

procedure TDupeFrame.FilterToDlg;
begin
  try
  with TDupeItem(Item) do begin

    chbNotify.Checked := FDupeFilterNotify;
    chbSortOnDupes.Checked := FDupeFilterSortOnDupes;
    chbFilterSmallerThan.Checked := FFilterSmallerThan;
    chbFilterBiggerThan.Checked := FFilterBiggerThan;
    cbbSmallerThan.Text := FSmallerThanStr;
    cbbBiggerThan.Text := FBiggerThanStr;
    chbFilterZeroByte.Checked := FFilterZeroByte;
    chbDisplayDialog.Checked := FDupeFilterDisplayDialog;

  end;
  except
    // Silent exception
  end;
end;

//
// TDupeItem
//

procedure TDupeItem.CreateFilterParams;
begin
  // Defaults
  Options := Options + [biAllowRemove];
  Caption := 'Duplicate Files';
  ImageIndex := 4;
  DialogCaption := 'Duplicates Filter';
  DialogIcon := 10;
  HelpContext := 0;

  // Filter defaults
  FFilterZeroByte := True;
  FSmallerThanStr := '5 MB';
  FBiggerThanStr := '10 bytes';

  // add the dupe filter
  Filter := TDupeFilter.Create;
  with TDupeFilter(Filter) do begin
    Name := 'duplicate file list';
    // Turn ON CRC calculation on the fly
    ActiveCRC := True;
    // Point to our events
    OnPreAccept := PreAcceptItem;
    OnPostProcess := PostProcess;
    // init
    FNotifyShown := False;
    FCompareCount := 0;
  end;

  // Set frame class
  FrameClass := TDupeFrame;
end;

procedure TDupeItem.PreAcceptItem(Sender: TObject; AItem: TsdItem; var Accept: boolean);
begin
  Accept := False;
  if not (biInitialised in Options) then exit;

  inc(FCompareCount);
  if not (AItem is TsdFile)then exit;

  Accept := True;

  // Smaller than
  if FFilterSmallerThan and (TsdFile(AItem).Size >= FSmallerThanSize) then
    Accept := False;
  // Bigger than
  if FFilterBiggerThan and (TsdFile(AItem).Size <= FBiggerThanSize) then
    Accept := False;
  // Zero byte files
  if FFilterZeroByte and (TsdFile(AItem).Size = 0) then
    Accept := False;
end;

procedure TDupeItem.PostProcess(Sender: TObject);
// This routine is called in a synchronised fashion when the dupe filter thread
// is finished
var
  Msg: string;
  ItemsPresent: boolean;
begin
 // Notify user
 ItemsPresent := False;
 if assigned(frmMain.View) then
   ItemsPresent := frmMain.View.ItemList.Count > 0;
 if FDupeFilterNotify and (FCompareCount > 0) and not FNotifyShown then begin
   if ItemsPresent then begin
     Msg :=  'The exact duplicate files filter has finished.'#13#13;
     if FDupeFilterSortOnDupes then
       Msg := Msg + 'The list will now be sorted by duplicate and the'#13+
                    'color banding will visualise these groups.';
   end else begin
     if assigned(Filter.Parent) then
       Msg := Format('No duplicates were found in the %d checked items.'#13#13, [Filter.Parent.Count])
     else
       Msg := 'No duplicates were found.';
   end;
   MessageDlg(Msg, mtInformation, [mbOK, mbHelp], 0);
   FNotifyShown := True;
 end;

 // Sorting on dupegroup
 if FDupeFilterSortOnDupes and ItemsPresent and (FCompareCount > 0) then begin
   if assigned(frmMain.View) then
     frmMain.View.SortByMethod(smByDupeGroup, sdAscending);
 end;

 // reinit
 FCompareCount := 0;
end;

end.
