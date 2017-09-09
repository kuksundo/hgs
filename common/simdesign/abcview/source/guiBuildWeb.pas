{ unit BuildWebs

  This unit implements the Build-a-web wizard.

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit guiBuildWeb;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, Mask, rxToolEdit;

type
  TfrmBuildWeb = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    btnPrev: TButton;
    btnNext: TButton;
    BitBtn2: TBitBtn;
    nbBuildWeb: TNotebook;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    rbSelected: TRadioButton;
    rbCurrentView: TRadioButton;
    rbAllItems: TRadioButton;
    GroupBox2: TGroupBox;
    fsExport: TSaveDialog;
    Label4: TLabel;
    Label5: TLabel;
    deHtmlFolder: TDirectoryEdit;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    rbViewLocal: TRadioButton;
    rbViewWWW: TRadioButton;
    GroupBox3: TGroupBox;
    edWebTitle: TEdit;
  private
    { Private declarations }
  public
    FSelectedCount: integer;
    FViewCount: integer;
    FAllItemsCount: integer;
    procedure DoBuildWebWizard;
    procedure DoStep1(Sender: TObject);
    procedure Step1Next(Sender: TObject);
    procedure DoStep2(Sender: TObject);
    procedure DoStep3(Sender: TObject);
    procedure DoStep4(Sender: TObject);
    procedure DoStep5(Sender: TObject);
    procedure Step5Next(Sender: TObject);
  end;

const

  // Export status constants

  esOK        = 0;  // Export OK
  esInitError = 1;  // Initialisation error

implementation

uses
  guiMain, sdRoots, ExportCSVs, guiFeedback, guiBrowser, guiFilterDialog,
  ThumbItems, guiWebpageItems;

const
  cNext = 'Next >';
  cFinish = 'Finish!';

{$R *.DFM}

procedure TfrmBuildWeb.DoBuildWebWizard;
var
  Item: TWebPageItem;
// local
procedure AddWebPageItem;
begin
  with frmMain.Browser do begin
    if not assigned(ItemByNode(MenuNode)) then exit;

    // Add a webpage item
    Item := TWebPageItem.Create;
    with Item do begin
      FSheetFolder := IncludeTrailingPathDelimiter(deHtmlFolder.Text);
      ImageFolder := FSheetFolder + 'images\';
      ThumbFolder := FSheetFolder + 'thumbs\';
      FPageFolder := FSheetFolder;
      FWebTitle := edWebTitle.Text;
    end;

    // Add it to the browse tree
    BrowseTree.AddItem(Item, MenuNode);
    Item.Activate;

    // Display the Filter Dialog
    dlgFilter.Item := Item;
    dlgFilter.Show;
  end;
end;
// main
begin
  // Start the user
  DoStep1(Self);

  // Not cancelled?
  if ShowModal = mrOK then begin

    // Now we will create the appropriate TWebPage BrowseItem
    // Current Selection
    if rbSelected.Checked then begin
      // Add current selection filter
      frmMain.Browser.UseSelectionExecute(Self);

      // Add a TWebPage
      AddWebPageItem;
    end;

    if rbCurrentView.Checked then begin
      // Add a TWebPage
      AddWebPageItem;
    end;
    if rbAllItems.Checked then begin
      // Activate "All Items"
      frmMain.Browser.BrowseTree.Items[0].Activate;
      // Add a TWebPage
      AddWebPageItem;
    end;
  end;
end;

procedure TfrmBuildWeb.DoStep1(Sender: TObject);
begin
  // Welcome + select items + title
  nbBuildWeb.ActivePage := 'Step1';

  // Set buttons
  btnNext.Enabled := True;
  btnNext.Caption := cNext;
  btnNext.OnClick := Step1Next;
  btnPrev.Enabled := False;
  btnPrev.OnClick := nil;

  // Count items
  FSelectedCount := 0;
  if assigned(frmMain.SelectedItems) then
    FSelectedCount := frmMain.SelectedItems.Count;
  FViewCount := 0;
  if assigned(frmMain.View) then
    FViewCount := frmMain.View.ItemList.Count;
  FAllItemsCount := 0;
  if assigned(frmMain.Root) then
    FAllItemsCount := frmMain.Root.Count;

  // Set values in controls
  rbSelected.Caption := Format('The selected items (%d items)' , [FSelectedCount]);
  rbSelected.Enabled := (FSelectedCount > 0);
  rbCurrentView.Caption := Format('The current view (%d items)' , [FViewCount]);
  rbCurrentView.Enabled := (FViewCount > 0);
  rbAllItems.Caption := Format('All items in the catalog (%d items)' , [FAllItemsCount]);
  rbAllItems.Enabled := (FAllItemsCount > 0);
end;

procedure TfrmBuildWeb.Step1Next(Sender: TObject);
begin
  // WWW Page?
  if rbViewWWW.Checked then begin
    // No support yet
    MessageDlg(
      'This version of ABC-View Manager does not support WWW pages yet.',
      mtInformation, [mbOK, mbHelp], 0);
    rbViewLocal.Checked := True;
    exit;
  end;
  DoStep3(Sender);
end;

procedure TfrmBuildWeb.DoStep2(Sender: TObject);
begin
  // Not implemented yet - WWW address and FTP characteristics
end;

procedure TfrmBuildWeb.DoStep3(Sender: TObject);
begin
  // Ask user for base folder
  nbBuildWeb.ActivePage := 'Step3';

  // Set buttons
  btnNext.Enabled := True;
  btnNext.Caption := cNext;
  btnNext.OnClick := DoStep5;
  btnPrev.Enabled := True;
  btnPrev.OnClick := DoStep1;


end;

procedure TfrmBuildWeb.DoStep4(Sender: TObject);
begin
  // Not implemented yet:
  // - original images/create copies
  // - original images as thumbs/create thumbs/index page
end;

procedure TfrmBuildWeb.DoStep5(Sender: TObject);
begin

  // Show "Success" page
  nbBuildWeb.ActivePage := 'Step5';

  // Set buttons
  btnNext.Enabled := True;
  btnNext.Caption := cFinish;
  btnNext.OnClick := Step5Next;
  btnPrev.Enabled := True;
  btnPrev.OnClick := DoStep3;

end;

procedure TfrmBuildWeb.Step5Next(Sender: TObject);
begin
  // Result is OK
  ModalResult := mrOK;
end;

end.
