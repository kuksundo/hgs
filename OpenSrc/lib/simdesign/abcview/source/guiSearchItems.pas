{ unit SearchItems

  Search dialog

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit guiSearchItems;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  BrowseTrees, sdItems, StdCtrls, ExtCtrls, ComCtrls, guiStandardItems,
  guiFilterFrame;

type
  TSearchFrame = class(TFilterFrame)
    pcSearch: TPageControl;
    tsSearch: TTabSheet;
    Label7: TLabel;
    cbbCond1: TComboBox;
    cbbTerm1: TComboBox;
    cbbCond2: TComboBox;
    cbbTerm2: TComboBox;
    cbbCond3: TComboBox;
    cbbTerm3: TComboBox;
    btnMore1: TButton;
    btnMore2: TButton;
    tsOptions: TTabSheet;
    chCaseSensitive: TCheckBox;
    CheckBox13: TCheckBox;
    chSearchExpandSel: TCheckBox;
    tsFields: TTabSheet;
    GroupBox3: TGroupBox;
    Label17: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    chSearchFileName: TCheckBox;
    chSearchDescription: TCheckBox;
    chSearchContent: TCheckBox;
    rbTextualContent: TRadioButton;
    rbAllContent: TRadioButton;
    chSearchUserFields: TCheckBox;
    chSearchPathName: TCheckBox;
    chSearchEncaps: TCheckBox;
    GroupBox4: TGroupBox;
    chSearchGroupsName: TCheckBox;
    chSearchGroupsDescr: TCheckBox;
    GroupBox5: TGroupBox;
    chSearchSeriesName: TCheckBox;
    chSearchSeriesDescr: TCheckBox;
    GroupBox6: TGroupBox;
    chSearchFoldersName: TCheckBox;
    chSearchFoldersDescr: TCheckBox;
    Label1: TLabel;
    procedure btnMore1Click(Sender: TObject);
    procedure btnMore2Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure DlgToFilter; override;
    procedure FilterToDlg; override;
    procedure ValidateTabs(Sender: TObject);
  end;

  TSearchItem = class(TBrowseItem)
  private
  public
    FCond1: integer;
    FCond2: integer;
    FCond3: integer;
    FPage: integer;
    FPhrase1: string;
    FPhrase2: string;
    FPhrase3: string;
    FPhrases1: TStrings;
    FPhrases2: TStrings;
    FPhrases3: TStrings;
    FCaseSensitive: boolean;
    FSearchFileName: boolean;
    FSearchPathName: boolean;
    FSearchDescription: boolean;
    FSearchContent: boolean;
    FContentMethod: integer;
    FSearchEncaps: boolean;
    FSearchUserFields: boolean;
    FSearchFoldersName: boolean;
    FSearchFoldersDescr: boolean;
    FSearchGroupsName: boolean;
    FSearchGroupsDescr: boolean;
    FSearchSeriesName: boolean;
    FSearchSeriesDescr: boolean;
    destructor Destroy; override;
    procedure CreateFilterParams; override;
    procedure FilterAcceptItem(Sender: TObject; Item: TsdItem; var Accept: boolean); virtual;
    function GetEmptyWarning: string; override;
    procedure InitialiseFilter; override;
  end;

const

  cNonTextual = '.exe;.com;.dll;.vbx;.zip;.cab;'
    + cDefaultImagesStr + cDefaultAudioStr + cDefaultVideoStr;

  cFileSearchLimit = 1048576; // 1 Mb search limit

implementation

uses
  ThreadedFilters, Math, Links;

{$R *.DFM}

procedure TSearchFrame.DlgToFilter;
begin
  try
  with TSearchItem(Item) do begin
    // Strings tab
    FCond1 := cbbCond1.ItemIndex;
    FCond2 := cbbCond2.ItemIndex;
    FCond3 := cbbCond3.ItemIndex;
    FPhrase1 := cbbTerm1.Text;
    FPhrase2 := cbbTerm2.Text;
    FPhrase3 := cbbTerm3.Text;
    FPage := pcSearch.ActivePageIndex;

    // Options tab
    FCaseSensitive := chCaseSensitive.Checked;
    if not FCaseSensitive then begin
      FPhrase1 := AnsiLowerCase(FPhrase1);
      FPhrase2 := AnsiLowerCase(FPhrase2);
      FPhrase3 := AnsiLowerCase(FPhrase3);
    end;

    // Fields tab
    FSearchFileName := chSearchFileName.Checked;
    FSearchPathName := chSearchPathName.Checked;
    FSearchDescription := chSearchDescription.Checked;
    FSearchContent := chSearchContent.Checked;
    if rbTextualContent.Checked then FContentMethod := 0;
    if rbAllContent.Checked then FContentMethod := 1;
    FSearchEncaps := chSearchEncaps.Checked;
    FSearchUserFields := chSearchUserFields.Checked;
    FSearchFoldersName := chSearchFoldersName.Checked;
    FSearchFoldersDescr := chSearchFoldersDescr.Checked;
    FSearchGroupsName := chSearchGroupsName.Checked;
    FSearchGroupsDescr := chSearchGroupsDescr.Checked;
    FSearchSeriesName := chSearchSeriesName.Checked;
    FSearchSeriesDescr := chSearchSeriesDescr.Checked;

    InitialiseFilter;
  end;
  except
//    DebugMessage('Exception in DlgToSearch');
  end;
end;

procedure TSearchFrame.FilterToDlg;
begin
  try
  with TSearchItem(Item) do begin
    // Strings tab
    cbbCond1.ItemIndex := FCond1;
    cbbCond2.ItemIndex := FCond2;
    cbbCond3.ItemIndex := FCond3;
    cbbTerm1.Text := FPhrase1;
    cbbTerm2.Text := FPhrase2;
    cbbTerm3.Text := FPhrase3;
    pcSearch.ActivePageIndex := FPage;
    // Options tab
    chCaseSensitive.Checked := FCaseSensitive;
    // Fields tab
    chSearchFileName.Checked := FSearchFileName;
    chSearchPathName.Checked := FSearchPathName;
    chSearchDescription.Checked := FSearchDescription;
    chSearchContent.Checked := FSearchContent;
    rbTextualContent.Checked := FContentMethod = 0;
    rbAllContent.Checked := FContentMethod = 1;
    chSearchEncaps.Checked := FSearchEncaps;
    chSearchUserFields.Checked := FSearchUserFields;
    chSearchFoldersName.Checked := FSearchFoldersName;
    chSearchFoldersDescr.Checked := FSearchFoldersDescr;
    chSearchGroupsName.Checked := FSearchGroupsName;
    chSearchGroupsDescr.Checked := FSearchGroupsDescr;
    chSearchSeriesName.Checked := FSearchSeriesName;
    chSearchSeriesDescr.Checked := FSearchSeriesDescr;

    ValidateTabs(Self);
  end;
  except
//    DebugMessage('Exception in SearchToDlg');
  end;
end;

procedure TSearchFrame.ValidateTabs(Sender: TObject);
begin
  // If cond2 not existing.. then also not cond3
  if cbbCond2.ItemIndex = -1 then
    cbbCond3.ItemIndex := -1;
  // Condition 3 visible?
  if cbbCond3.ItemIndex = -1 then
    btnMore2.Caption := 'More...'
  else
    btnMore2.Caption := 'Less...';
  cbbCond3.Visible := (cbbCond3.ItemIndex > -1);
  cbbTerm3.Visible := (cbbCond3.ItemIndex > -1);
  // Condition 2 visible?
  if cbbCond2.ItemIndex = -1 then
    btnMore1.Caption := 'More...'
  else
    btnMore1.Caption := 'Less...';
  btnMore2.Visible := (cbbCond2.ItemIndex > -1);
  cbbCond2.Visible := (cbbCond2.ItemIndex > -1);
  cbbTerm2.Visible := (cbbCond2.ItemIndex > -1);
end;

procedure TSearchFrame.btnMore1Click(Sender: TObject);
begin
  if cbbCond2.ItemIndex = -1 then
    cbbCond2.ItemIndex := 0
  else
    cbbCond2.ItemIndex := -1;
  ValidateTabs(Sender);
end;

procedure TSearchFrame.btnMore2Click(Sender: TObject);
begin
  inherited;
  if cbbCond3.ItemIndex = -1 then
    cbbCond3.ItemIndex := 0
  else
    cbbCond3.ItemIndex := -1;
  ValidateTabs(Sender);
end;

{ TSearchItem }

destructor TSearchItem.Destroy;
begin
  if assigned(FPhrases1) then FreeAndNil(FPhrases1);
  if assigned(FPhrases2) then FreeAndNil(FPhrases2);
  if assigned(FPhrases3) then FreeAndNil(FPhrases3);
  inherited;
end;

procedure TSearchItem.CreateFilterParams;
begin
  Options := Options + [biAllowRename, biAllowRemove];
  // Defaults
  Caption := 'Search Results';
  ImageIndex := 13;
  DialogCaption := 'Find';
  DialogIcon := 2;
  HelpContext := 0;

  // Search defaults
  FCond2 := -1;
  FCond3 := -1;
  FSearchFileName := True;
  FSearchDescription := True;

  // add a threaded filter with OnAcceptItem connected to FilterItem
  Filter := TThreadedFilter.Create;
  with TThreadedFilter(Filter) do begin
    ExpandedSelection := True;
    OnAcceptItem := FilterAcceptItem;
  end;

  // Set frame class
  FrameClass := TSearchFrame;
end;

procedure TSearchItem.FilterAcceptItem(Sender: TObject; Item: TsdItem; var Accept: boolean);
var
  Line: string;
  S: TStream;
  SearchLen: integer;
// local
function CaseCorrected(const ALine: string): string;
begin
  if FCaseSensitive then
    Result := ALine
  else
    Result := AnsiLowerCase(ALine);
end;
// local
function DoSearch(APhrases: TStrings; ALine: string): integer;
var
  i: integer;
begin
  Result := Pos(APhrases[0], ALine);
  i := 1;
  while (Result > 0) and (i < APhrases.Count) do begin
    Result := Min(Result, Pos(APhrases[i], ALine));
    inc(i);
  end;
end;
// local
function SearchSucceed(const Line: string): boolean;
var
  Success2,
  Success3: boolean;
begin
  Result := False;
  if length(Line) = 0 then exit;
  if FPhrases1.Count > 0 then
    Result := DoSearch(FPhrases1, Line) > 0;
  if (FCond2 >= 0) and (FPhrases2.Count > 0) then begin
    Success2 := DoSearch(FPhrases2, Line) > 0;
    case FCond2 of
    0: Result := Result AND Success2;
    1: Result := Result OR Success2;
    2: Result := Result AND NOT Success2;
    3: Result := Result OR NOT Success2;
    end;
  end;
  if (FCond3 >= 0) and (FPhrases3.Count > 0) then begin
    Success3 := DoSearch(FPhrases3, Line) > 0;
    case FCond3 of
    0: Result := Result AND Success3;
    1: Result := Result OR Success3;
    2: Result := Result AND NOT Success3;
    3: Result := Result OR NOT Success3;
    end;
  end;
end;
// local
function AllowOpen: boolean;
begin
  Result := True;
  if FContentMethod = 0 then
    Result := Pos(TsdFile(Item).Extension, cNonTextual) = 0;
end;
// main
begin
  Accept := False;
  if not assigned(Item) or not (biInitialised in Options) then exit;

  // For now we have simple search algorithms

  // Search description
  if FSearchDescription then begin
    Line := CaseCorrected(Item.Description);
    if SearchSucceed(Line) then Accept := True;
  end;

  case Item.ItemType of
  itFile:
  begin

    // Search item name
    if FSearchFileName then begin
      Line := CaseCorrected(Item.Name);
      if SearchSucceed(Line) then Accept := True;
    end;

    // Search path name
    if FSearchPathName then begin
      Line := CaseCorrected(TsdFile(Item).FileName);
      if SearchSucceed(Line) then Accept := True;
    end;

    // Search content
    if FSearchContent and AllowOpen then begin
      try
        // Create a file stream to scan
        S := TFileStream.Create(TsdFile(Item).FileName, fmOpenRead or fmShareDenyWrite);
        try
          // Copy to line
          SearchLen := Min(S.Size, cFileSearchLimit);
          SetLength(Line, SearchLen);
          S.Read(Line[1], SearchLen);
          if not FCaseSensitive then Line := AnsiLowerCase(Line);
          // now we can check
          if SearchSucceed(Line) then Accept := True;
          SetLength(Line, 0);
        finally
          S.Free;
        end;
      except
        // File could not be opened - silent exception
      end;
    end;

  end;
  end;//case

  // reversal
  if FCond1 = 1 then Accept := not Accept;
end;

function TSearchItem.GetEmptyWarning: string;
begin
  if assigned(Filter) and Filter.IsRunning then
    Result := 'ABC-View is currently performing the search. Please wait for the results to appear.'
  else
    Result := 'The search didn''t produce any results.'
end;

procedure TSearchItem.InitialiseFilter;
begin
  // Create & Convert to stringlist with words
  if not assigned(FPhrases1) then FPhrases1 := TStringList.Create;
  if not assigned(FPhrases2) then FPhrases2 := TStringList.Create;
  if not assigned(FPhrases3) then FPhrases3 := TStringList.Create;
  SplitToWords(FPhrase1, FPhrases1);
  SplitToWords(FPhrase2, FPhrases2);
  SplitToWords(FPhrase3, FPhrases3);

  inherited;
end;


end.
