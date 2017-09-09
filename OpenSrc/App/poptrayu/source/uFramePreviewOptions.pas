unit uFramePreviewOptions;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Buttons;

type
  TEnableSaveOptionsFunction = procedure of object;



type
  TFramePreviewOptions = class(TFrame)
    CategoryPanelGroup1: TCategoryPanelGroup;
    catHtmlTab: TCategoryPanel;
    chkDisableHtmlPreview: TCheckBox;
    catTabs: TCategoryPanel;
    lblDefaultTab: TLabel;
    cmbDefaultTab: TComboBox;
    lblSpamTab: TLabel;
    cmbSpamTab: TComboBox;
    chkShowImages: TCheckBox;
    catPlainText: TCategoryPanel;
    catDisplayPreview: TCategoryPanel;
    chkShowXMailer: TCheckBox;
    procedure HelpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OptionsChange(Sender: TObject);
  private
    { Private declarations }
    funcEnableSaveBtn : TEnableSaveOptionsFunction;
    procedure AlignLabels;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; SaveButtonProc : TEnableSaveOptionsFunction); reintroduce;
  end;

implementation

uses uGlobal, uTranslate, System.UITypes, uPositioning, System.Math, uMain;

{$R *.dfm}

constructor TFramePreviewOptions.Create(AOwner: TComponent; SaveButtonProc : TEnableSaveOptionsFunction);
begin
  inherited Create(AOwner);
  funcEnableSaveBtn := SaveButtonProc;

  Options.Busy := True;

  case Options.DefaultPreviewTab of
    TAB_LAST_USED:  cmbDefaultTab.ItemIndex := 0;
    TAB_HTML:       cmbDefaultTab.ItemIndex := 1;
    TAB_PLAIN_TEXT: cmbDefaultTab.ItemIndex := 2;
    TAB_RAW:        cmbDefaultTab.ItemIndex := 3;
  end;

  case Options.DefaultSpamTab of
    TAB_LAST_USED:  cmbSpamTab.ItemIndex := 0;
    TAB_HTML:       cmbSpamTab.ItemIndex := 1;
    TAB_PLAIN_TEXT: cmbSpamTab.ItemIndex := 2;
    TAB_RAW:        cmbSpamTab.ItemIndex := 3;
  end;

  chkDisableHtmlPreview.Checked := Options.DisableHtmlPreview;
  chkShowImages.Checked := Options.ShowImages;
  chkShowXMailer.Checked := Options.ShowXMailer;

  Options.Busy := False;



  // Fix fonts
  self.Font.Assign(Options.GlobalFont);

  CategoryPanelGroup1.HeaderFont.Assign(Options.GlobalFont);
  CategoryPanelGroup1.HeaderFont.Style := CategoryPanelGroup1.HeaderFont.Style + [fsBold];
  CategoryPanelGroup1.HeaderFont.Size := Options.GlobalFont.Size;

  TranslateComponentFromEnglish(self);
  AlignLabels();


end;

procedure TFramePreviewOptions.HelpMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  frmPopUMain.QuickHelp(Sender, Button, Shift, X, Y);
end;

procedure TFramePreviewOptions.OptionsChange(Sender: TObject);
begin

  if not Options.Busy then
  begin
    case cmbDefaultTab.ItemIndex of
      0: Options.DefaultPreviewTab := TAB_LAST_USED;
      1: Options.DefaultPreviewTab := TAB_HTML;
      2: Options.DefaultPreviewTab := TAB_PLAIN_TEXT;
      3: Options.DefaultPreviewTab := TAB_RAW;
    end;

    case cmbSpamTab.ItemIndex of
      0: Options.DefaultSpamTab := TAB_LAST_USED;
      1: Options.DefaultSpamTab := TAB_HTML;
      2: Options.DefaultSpamTab := TAB_PLAIN_TEXT;
      3: Options.DefaultSpamTab := TAB_RAW;
    end;

    Options.DisableHtmlPreview := chkDisableHtmlPreview.Checked;
    Options.ShowImages := chkShowImages.Checked;
    Options.ShowXMailer := chkShowXMailer.Checked;

    // enable save button
    funcEnableSaveBtn();
  end;

end;

procedure TFramePreviewOptions.AlignLabels;
var
  labelHeight : Integer;
begin
  labelHeight := lblDefaultTab.Height;

  cmbDefaultTab.Left := CalcPosToRightOf(lblDefaultTab);
  AutosizeCombobox(cmbDefaultTab, 100);
  cmbSpamTab.Left := CalcPosToRightOf(lblSpamTab);
  cmbSpamTab.Top := calcPosBelow(cmbDefaultTab);
  AutosizeCombobox(cmbSpamTab, 100);
  lblSpamTab.Top := cmbSpamTab.Top + 3;
  catTabs.ClientHeight := calcPosBelow(cmbSpamTab);

  chkDisableHtmlPreview.Height := labelHeight;
  chkShowImages.Height := labelHeight;
  chkShowImages.Top := calcPosBelow(chkDisableHtmlPreview);
  catHtmlTab.ClientHeight := calcPosBelow(chkShowImages);

  chkShowXMailer.Height := labelHeight;
  catDisplayPreview.ClientHeight := calcPosBelow(chkShowXMailer);

end;

end.
