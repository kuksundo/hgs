{ unit WebPages

  The wizard for building web pages

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit WebPages;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, Mask, ToolEdit;

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
    deBaseFolder: TDirectoryEdit;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    rbViewLocal: TRadioButton;
    rbViewWWW: TRadioButton;
    GroupBox3: TGroupBox;
    Edit1: TEdit;
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

var
  frmBuildWeb: TfrmBuildWeb;

const

  // Export status constants

  esOK        = 0;  // Export OK
  esInitError = 1;  // Initialisation error

implementation

uses
  Main, Roots, ExportCSVs, Feedbacks;

const
  cNext = 'Next >';
  cFinish = 'Finish!';

{$R *.DFM}

procedure TfrmBuildWeb.DoBuildWebWizard;
begin
  DoStep1(Self);
  if ShowModal = mrOK then begin
    // to do: Copy the stuff 
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

  // Count export items
  FSelectedCount := 0;
  if assigned(frmABC.SelectedItems) then
    FSelectedCount := frmABC.SelectedItems.Count;
  FViewCount := 0;
  if assigned(frmABC.View) then
    FViewCount := frmABC.View.ItemList.Count;
  FAllItemsCount := 0;
  if assigned(Root) then
    FAllItemsCount := Root.Count;

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
var
  i: integer;
  ExportList: TList;
  OutFile: TStream;
  CSVOptions: TCSVOptions;
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
