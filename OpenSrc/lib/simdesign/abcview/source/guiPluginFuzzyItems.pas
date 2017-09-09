{ unit PluginFuzzyItems

  Fuzzy item plugin

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit guiPluginFuzzyItems;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, BrowseTrees, sdItems, RXSlider, guiPlugins,
  sdAbcTypes, sdAbcVars, guiFilterFrame;

type

  // Frame belonging to PluginFuzzyItem filter
  TPluginFuzzyFrame = class(TFilterFrame)
    lblTitle: TLabel;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    chbNotify: TCheckBox;
    chbSortOnDupes: TCheckBox;
    GroupBox2: TGroupBox;
    chbDisplayDialog: TCheckBox;
    Label30: TLabel;
    slTolerance: TRxSlider;
    Label31: TLabel;
    Label32: TLabel;
    lblTolVal: TLabel;
    procedure slToleranceChange(Sender: TObject);
  private
    procedure SetTolVal(ATol: integer);
  public
    procedure DlgToFilter; override;
    procedure FilterToDlg; override;
  end;

  TPluginFuzzyItem = class(TBrowseItem)
  private
    FPlugin: TPlugin; // Pointer to the plugin
  protected
    // Override CreateFilterParams instead of Create to set the correct
    // set of filter, caption, frame etc
    procedure CreateFilterParams; override;
  public
    FOptionsChanged: boolean;
    FNotifyShown: boolean;   // Notify dialog has been shown
    FCompareCount: integer;  // Total amount of compares
    FTolerance: integer;     // Tolerance used
    constructor Create(APlugin: TPlugin);
    function FuzzyFilter(Item1, Item2: TsdItem; var IsEqual: boolean): boolean;
    procedure InitialiseFilter; override;
    procedure PreAcceptItem(Sender: TObject; AItem: TsdItem; var Accept: boolean);
    procedure PostProcess(Sender: TObject);
    property Plugin: TPlugin read FPlugin write FPlugin;
  end;

implementation

uses
  CloseMatches, guiMain;

{$R *.DFM}

const

  cFuzzyTextDiffByTol: array[0..7] of integer =
    (10, 20, 50, 100, 200, 500, 1000, 2000);

{ TPluginFuzzyFrame }

procedure TPluginFuzzyFrame.SetTolVal(ATol: integer);
begin
  with TPluginFuzzyItem(Item) do begin
    if assigned(Plugin) then
      lblTolVal.Caption := Plugin.GetFuzzyLimitStr(ATol)
    else
      lblTolVal.Caption := IntToStr(ATol);
  end;
end;

procedure TPluginFuzzyFrame.DlgToFilter;
begin
  try
  with TPluginFuzzyItem(Item) do begin

    FOptionsChanged := False;
    FDupeFilterNotify := chbNotify.Checked;
    FDupeFilterSortOnDupes := chbSortOnDupes.Checked;
    if FTolerance <> slTolerance.Value then begin
      FTolerance := slTolerance.Value;
      FOptionsChanged := True;
    end;
    FDupeFilterDisplayDialog := chbDisplayDialog.Checked;

    InitialiseFilter;
  end;
  except
    // Silent exception
  end;
end;

procedure TPluginFuzzyFrame.FilterToDlg;
begin
  try
  with TPluginFuzzyItem(Item) do begin

    if assigned(Plugin) then
      lblTitle.Caption := Plugin.FilterName;
    chbNotify.Checked := FDupeFilterNotify;
    chbSortOnDupes.Checked := FDupeFilterSortOnDupes;
    slTolerance.Value := FTolerance;
    SetTolVal(FTolerance);
    chbDisplayDialog.Checked := FDupeFilterDisplayDialog;

  end;
  except
    // Silent exception
  end;
end;

procedure TPluginFuzzyItem.CreateFilterParams;
begin
  // Defaults
  Options := Options + [biAllowRemove];
  if assigned(Plugin) then begin
    Caption := Plugin.FilterName;
    ImageIndex := 8;
    DialogCaption := Plugin.FilterName;
    DialogIcon := 11;
    HelpContext := 0;
  end;

  // Filter defaults
  FTolerance := 3;

  // add the close match filter
  Filter := TCloseMatchFilter.Create;
  with TCloseMatchFilter(Filter) do begin
    SetFilterName('fuzzy matches list');
    // properties and events
    if assigned(Plugin) then begin
      Name := Plugin.FilterName;
      OnCalculate   := Plugin.FilterCalculateItem;
      OnCompare     := Plugin.FilterFuzzyCompare;
      OnFuzzyFilter := FuzzyFilter;
      OnItemData    := Plugin.FilterItemData;
    end;
    OnPreAccept   := PreAcceptItem;
    OnPostProcess := PostProcess;
    // init
    FNotifyShown := False;
    FCompareCount := 0;
  end;

  // Set frame class
  FrameClass := TPluginFuzzyFrame;
end;

{ TPluginFuzzyItem }

constructor TPluginFuzzyItem.Create(APlugin: TPlugin);
begin
  Plugin := APlugin;
  inherited Create;
end;

function TPluginFuzzyItem.FuzzyFilter(Item1, Item2: TsdItem; var IsEqual: boolean): boolean;
var
  Limit: integer;
begin
  Result := False;
  if assigned(Plugin) then begin
    // Get limit first
    Limit := Plugin.GetFuzzyLimit(FTolerance);
    // Now invoke
    Result := Plugin.FilterFuzzyFilter(Item1, Item2, Limit, IsEqual);
  end;
end;

procedure TPluginFuzzyItem.InitialiseFilter;
begin
  // New filter settings
  with TCloseMatchFilter(Filter) do begin
    // Set limit
    if assigned(Plugin) then
      DiffLimit := Plugin.GetFuzzyLimit(FTolerance);
    if FOptionsChanged then
      ClearItems(Self);
  end;
  inherited InitialiseFilter;
end;

procedure TPluginFuzzyItem.PreAcceptItem(Sender: TObject; AItem: TsdItem; var Accept: boolean);
begin
  Accept := False;
  if not (biInitialised in Options) then exit;

  inc(FCompareCount);
  Accept := assigned(AItem) and (AItem.ItemType = itFile);
  if Accept and assigned(FPlugin) then with FPlugin do
    Accept := FilterFuzzyPreAccept(AItem);
end;

procedure TPluginFuzzyItem.PostProcess(Sender: TObject);
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
      if assigned(Plugin) then
      Msg :=  Format('The %s has finished.'#13#13, [Plugin.FilterName]);
      if FDupeFilterSortOnDupes then
        Msg := Msg + 'The list will now be sorted by matching percentage and the'#13+
                     'color banding will visualise these groups.';
    end else begin
      if assigned(Filter.Parent) then
        Msg := Format('No matching items were found in the %d checked items.'#13#13, [Filter.Parent.Count])
      else
        Msg := 'No matching items were found.';
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

procedure TPluginFuzzyFrame.slToleranceChange(Sender: TObject);
begin
  inherited;
  SetTolVal(slTolerance.Value);
end;

end.
