{ Unit CloseMatchItems

  "Similar Images" dialog box.

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit guiCloseMatchItems;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, BrowseTrees, sdItems, RXSlider, sdAbcTypes,
  guiFilterFrame;

type

  // Frame belonging to CloseMatchItem filter
  TCloseMatchFrame = class(TFilterFrame)
    Label2: TLabel;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    chbNotify: TCheckBox;
    chbSortOnDupes: TCheckBox;
    GroupBox2: TGroupBox;
    chbDisplayDialog: TCheckBox;
    chbMatchDims: TCheckBox;
    chbMatchAspect: TCheckBox;
    Label30: TLabel;
    slTolerance: TRxSlider;
    Label31: TLabel;
    Label32: TLabel;
    lblTolVal: TLabel;
    procedure slToleranceChange(Sender: TObject);
  private
    { Private declarations }
    procedure SetTolVal(ATol: integer);
  public
    procedure DlgToFilter; override;
    procedure FilterToDlg; override;
  end;

  TCloseMatchItem = class(TBrowseItem)
  protected
    // Override CreateFilterParams instead of Create to set the correct
    // set of filter, caption, frame etc
    procedure CreateFilterParams; override;
  public
    FOptionsChanged: boolean;
    FNotifyShown: boolean;   // Notify dialog has been shown
    FCompareCount: integer;  // Total amount of compares
    FTolerance: integer;     // Tolerance used
    FMatchAspect: boolean;   // Match aspect ratio (5%)
    FMatchDims: boolean;     // Match dimensions exactly
    procedure InitialiseFilter; override;
    procedure CalculateItem(Sender: TObject; AItem: TsdItem; var Accept: boolean);
    function FuzzyCompare(Item1, Item2: TsdItem; Data1, Data2: pointer; Limit: integer): integer;
    function FuzzyFilter(Item1, Item2: TsdItem; var IsEqual: boolean): boolean;
    procedure ItemData(Sender: TObject; AItem: TsdItem; var Data: pointer);
    procedure PreAcceptItem(Sender: TObject; AItem: TsdItem; var Accept: boolean);
    procedure PostProcess(Sender: TObject);
  end;


implementation

uses
  CloseMatches, guiMain, sdProperties,
  PixRefs, sdAbcVars;

{$R *.DFM}

{ TCloseMatchFrame }

procedure TCloseMatchFrame.SetTolVal(ATol: integer);
begin
  lblTolVal.Caption := Format('%3.1f%%', [cPixRefDiffByTol[ATol] / 2000]);
end;

procedure TCloseMatchFrame.DlgToFilter;
begin
  try
  with TCloseMatchItem(Item) do begin

    FOptionsChanged := False;
    FDupeFilterNotify := chbNotify.Checked;
    FDupeFilterSortOnDupes := chbSortOnDupes.Checked;
    if FTolerance <> slTolerance.Value then begin
      FTolerance := slTolerance.Value;
      FOptionsChanged := True;
    end;
    if FMatchAspect <> chbMatchAspect.Checked then begin
      FMatchAspect := chbMatchAspect.Checked;
      FOptionsChanged := True;
    end;
    if FMatchDims <> chbMatchDims.Checked then begin
      FMatchDims := chbMatchDims.Checked;
      FOptionsChanged := True;
    end;
    FDupeFilterDisplayDialog := chbDisplayDialog.Checked;

    InitialiseFilter;
  end;
  except
    // Silent exception
  end;
end;

procedure TCloseMatchFrame.FilterToDlg;
begin
  try
  with TCloseMatchItem(Item) do begin

    chbNotify.Checked := FDupeFilterNotify;
    chbSortOnDupes.Checked := FDupeFilterSortOnDupes;
    slTolerance.Value := FTolerance;
    SetTolVal(FTolerance);
    chbMatchAspect.Checked := FMatchAspect;
    chbMatchDims.Checked := FMatchDims;
    chbDisplayDialog.Checked := FDupeFilterDisplayDialog;

  end;
  except
    // Silent exception
  end;
end;

{ TCloseMatchItem }

procedure TCloseMatchItem.CreateFilterParams;
begin
  // Defaults
  Options := Options + [biAllowRemove];
  Caption := 'Similar Images';
  ImageIndex := 8;
  DialogCaption := 'Similar Images Filter';
  DialogIcon := 11;
  HelpContext := 0;

  // Filter defaults
  FTolerance := 3;
  FMatchAspect := True;

  // add the close match filter
  Filter := TCloseMatchFilter.Create;
  with TCloseMatchFilter(Filter) do begin
    SetFilterName('similar images list');
    // Point to our events
    OnCalculate   := CalculateItem;
    OnCompare     := FuzzyCompare;
    OnFuzzyFilter := FuzzyFilter;
    OnItemData    := ItemData;
    OnPreAccept   := PreAcceptItem;
    OnPostProcess := PostProcess;
    // init
    FNotifyShown := False;
    FCompareCount := 0;
  end;

  // Set frame class
  FrameClass := TCloseMatchFrame;
end;

procedure TCloseMatchItem.CalculateItem(Sender: TObject; AItem: TsdItem; var Accept: boolean);
// All we do here is calculate the pixel reference and accept if this item has
// a valid pixel reference
begin
  Accept := False;
  if not assigned(AItem) then exit;

  // Calculate the pixref
  AItem.CalculatePixRef;

  // If we have it (e.g. all graphics) then we accept the item
  if AItem.HasProperty(prPixRef) then
    Accept := True;
end;

function TCloseMatchItem.FuzzyCompare(Item1, Item2: TsdItem; Data1, Data2: pointer; Limit: integer): integer;
begin
  Result := PixRefDifference(Item1, Item2, Data1, Data2, Limit);
end;

function TCloseMatchItem.FuzzyFilter(Item1, Item2: TsdItem; var IsEqual: boolean): boolean;
var
  X1, X2, Y1, Y2: integer;
  Pix: TPixelFormat;
begin
  // PixRef difference
  IsEqual := PixRefDifference(Item1, Item2, nil, nil, cMaxArrangeDiff) < cPixRefDiffByTol[FTolerance];
  // This value is to determine equality for the additional options
  Result := IsEqual;
  if Result then begin
    if FMatchAspect then begin
      try
        if sqrt(sqr(Item1.GetAspectRatio - Item2.GetAspectRatio) /
          (Item1.GetAspectRatio * Item2.GetAspectRatio)) > 0.05 then
          Result := False;
      except
        Result := False;
      end;
    end;
    if FMatchDims then begin
      Item1.GetImageDimensions(X1, Y1, Pix);
      Item2.GetImageDimensions(X2, Y2, Pix);
      if (X1 <> X2) or (Y1 <> Y2) then
        Result := False;
    end;
  end;
end;

procedure TCloseMatchItem.InitialiseFilter;
begin
  // New filter settings
  with TCloseMatchFilter(Filter) do begin
    // Tell the fuzzy filter what the limit value is
    DiffLimit := cPixRefDiffByTol[FTolerance];
    if FOptionsChanged then
      ClearItems(Self);
  end;
  inherited InitialiseFilter;
end;

procedure TCloseMatchItem.ItemData(Sender: TObject; AItem: TsdItem; var Data: pointer);
begin
  if assigned(AItem) then
    Data := AItem.GetProperty(prPixRef);
end;

procedure TCloseMatchItem.PreAcceptItem(Sender: TObject; AItem: TsdItem; var Accept: boolean);
begin
  Accept := False;
  if not (biInitialised in Options) then exit;

  inc(FCompareCount);
  if not (AItem is TsdFile) then exit;

  Accept := True;
end;

procedure TCloseMatchItem.PostProcess(Sender: TObject);
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
      Msg :=  'The similar images filter has finished.'#13#13;
      if FDupeFilterSortOnDupes then
        Msg := Msg + 'The list will now be sorted by similarity and the'#13+
                     'color banding will visualise these groups.';
    end else begin
      if assigned(Filter.Parent) then
        Msg := Format('No similar images were found in the %d checked items.'#13#13, [Filter.Parent.Count])
      else
        Msg := 'No similar images were found.';
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

procedure TCloseMatchFrame.slToleranceChange(Sender: TObject);
begin
  inherited;
  SetTolVal(slTolerance.Value);
end;

end.
