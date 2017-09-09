unit uFrameRulesOptions;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TEnableSaveOptionsFunction = procedure of object;

const
  // array indexes into cmbBlacklistAction
  MARK_BLACKLIST_AS_SPAM = 0;
  DELETE_BLACKLIST = 1;

type
  TFrameRulesOptions = class(TFrame)
    CategoryPanelGroup1: TCategoryPanelGroup;
    catRules: TCategoryPanel;
    catStartup: TCategoryPanel;
    chkLogRules: TCheckBox;
    lblBlacklistAct: TLabel;
    cmbBlacklistAction: TComboBox;
    chkDeleteConfirmProtected: TCheckBox;
    catMsgDl: TCategoryPanel;
    lblGetBodyLines: TLabel;
    lblGetBodySize: TLabel;
    lblMsgDlInfo: TLabel;
    chkGetBody: TCheckBox;
    chkGetBodyLines: TCheckBox;
    chkGetBodySize: TCheckBox;
    chkRetrieveTop: TCheckBox;
    edGetBodyLines: TEdit;
    edGetBodySize: TEdit;
    edTopLines: TEdit;
    chkDlForPreview: TCheckBox;
    chkPreferEnvelopes: TCheckBox;
    procedure OptionsChange(Sender: TObject);
    procedure HelpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    funcEnableSaveBtn : TEnableSaveOptionsFunction;
    procedure AlignLabels;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; SaveButtonProc : TEnableSaveOptionsFunction); reintroduce;
  end;

implementation

uses uGlobal, uTranslate, uMain, uRCUtils, uPositioning, System.UITypes;

{$R *.dfm}



constructor TFrameRulesOptions.Create(AOwner: TComponent; SaveButtonProc : TEnableSaveOptionsFunction);
begin
  inherited Create(AOwner);
  funcEnableSaveBtn := SaveButtonProc;

  Options.Busy := True;
  // options to screen
  //chkStartUp.Checked := Options.StartUp;
  //edFirstWait.Text := IntToStr(Options.FirstWait);

  chkRetrieveTop.Checked := Options.TopLines>0;
  if chkRetrieveTop.Checked then edTopLines.Text := IntToStr(Options.TopLines);
  chkGetBody.Checked := Options.GetBody;
  chkGetBodySize.Checked := Options.GetBodySize > 0;
  if chkGetBodySize.Checked then edGetBodySize.Text := IntToStr(Options.GetBodySize);
  chkGetBodyLines.Checked := Options.GetBodyLines > 0;
  if chkGetBodyLines.Checked then edGetBodyLines.Text := IntToStr(Options.GetBodyLines);
  chkPreferEnvelopes.Checked := Options.PreferEnvelopes;

  chkDeleteConfirmProtected.Checked := Options.DeleteConfirmProtected;
  chkLogRules.Checked := Options.LogRules;

  if (Options.BlackListSpam) then
    cmbBlacklistAction.ItemIndex := MARK_BLACKLIST_AS_SPAM
  else
    cmbBlacklistAction.ItemIndex := DELETE_BLACKLIST;

  Options.Busy := False;


  // Fix fonts
  self.Font.Assign(Options.GlobalFont);
  lblMsgDlInfo.Font.Assign(self.Font);
  lblMsgDlInfo.Font.Style := lblMsgDlInfo.Font.Style + [fsItalic];

  CategoryPanelGroup1.HeaderFont.Assign(Options.GlobalFont);
  CategoryPanelGroup1.HeaderFont.Style := CategoryPanelGroup1.HeaderFont.Style + [fsBold];
  CategoryPanelGroup1.HeaderFont.Size := Options.GlobalFont.Size;

  TranslateComponentFromEnglish(self);
  AlignLabels();


end;

procedure TFrameRulesOptions.HelpMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  frmPopUMain.QuickHelp(Sender, Button, Shift, X, Y);
end;


procedure TFrameRulesOptions.AlignLabels;
var
  labelHeight : Integer;
begin
  AutoSizeCheckBox(chkRetrieveTop);
  AutoSizeCheckBox(chkGetBodyLines);
  AutoSizeCheckBox(chkGetBodySize);

  edTopLines.Left := chkRetrieveTop.Left + chkRetrieveTop.Width + 4;
  edGetBodySize.Left := chkGetBodySize.Left + chkGetBodySize.Width + 4;
  lblGetBodySize.Left := edGetBodySize.Left + edGetBodySize.Width + 4;
  edGetBodyLines.Left := chkGetBodyLines.Left + chkGetBodyLines.Width + 4;
  lblGetBodyLines.Left := edGetBodyLines.Left + edGetBodyLines.Width + 4;

  labelHeight := lblGetBodyLines.Height;

  // Rules category
  chkLogRules.Height := labelHeight;
  chkDeleteConfirmProtected.Height := labelHeight;
  chkDeleteConfirmProtected.Top := calcPosBelow(chkLogRules);
  catRules.ClientHeight := calcPosBelow(chkDeleteConfirmProtected);

  // Message Download category
  chkRetrieveTop.Height := labelHeight;
  chkGetBody.Height := labelHeight;
  chkGetBodySize.Height := labelHeight;
  chkGetBodyLines.Height := labelHeight;
  chkDlForPreview.Height := labelHeight;
  chkPreferEnvelopes.Height := labelHeight;

  chkRetrieveTop.Top := calcPosBelow(lblMsgDlInfo);
  edTopLines.Top := chkRetrieveTop.Top - 3;

  chkGetBody.Top := calcPosBelow(chkRetrieveTop);

  chkGetBodySize.Top := calcPosBelow(chkGetBody);
  edGetBodySize.Top := chkGetBodySize.Top - 3;
  lblGetBodySize.Top := chkGetBodySize.Top;

  chkGetBodyLines.Top := calcPosBelow(edGetBodySize) + 3;
  lblGetBodyLines.Top := chkGetBodyLines.Top;
  edGetBodyLines.Top := chkGetBodyLines.Top - 3;

  chkDlForPreview.Top := calcPosBelow(edGetBodyLines);
  chkPreferEnvelopes.Top := calcPosBelow(chkDlForPreview);

  catMsgDl.ClientHeight := calcPosBelow(chkPreferEnvelopes);

  // Whitelist/blacklist category
  cmbBlacklistAction.Left := CalcPosToRightOf(lblBlacklistAct);
  AutosizeCombobox(cmbBlacklistAction, 100);


end;

procedure TFrameRulesOptions.OptionsChange(Sender: TObject);
begin
  // show top lines
  EnableControl(edTopLines,chkRetrieveTop.Checked);
  // get body
  if not chkGetBody.Checked then
  begin
    chkGetBodySize.Checked := false;
    chkGetBodyLines.Checked := false;
  end;
  // get body size
  chkGetBodySize.Enabled := chkGetBody.Checked;
  lblGetBodySize.Enabled := chkGetBody.Checked;
  EnableControl(edGetBodySize,chkGetBodySize.Checked);
  // get body lines
  chkGetBodyLines.Enabled := chkGetBody.Checked;
  lblGetBodyLines.Enabled := chkGetBody.Checked;
  EnableControl(edGetBodyLines,chkGetBodyLines.Checked);

  EnableControl(chkPreferEnvelopes,chkGetBody.Checked = false);


  // other options
  if not Options.Busy then
  begin

    // get body size
    if edTopLines.Enabled and (Sender=chkRetrieveTop) then edTopLines.Text := '50';
    if not edTopLines.Enabled then edTopLines.Text := '';
    // get body size
    if edGetBodySize.Enabled and (Sender=chkGetBodySize) then edGetBodySize.Text := '20';
    if not edGetBodySize.Enabled then edGetBodySize.Text := '';
    // get body lines
    if edGetBodyLines.Enabled and (Sender=chkGetBodyLines) then edGetBodyLines.Text := '50';
    if not edGetBodyLines.Enabled then edGetBodyLines.Text := '';
    // rules area
        //TODO: this would be better done with a broadcast message.
    frmPopUMain.RulesForm.enableBodyRuleArea( Options.GetBody );

    // screen to options
    Options.TopLines := StrToIntDef(edTopLines.Text,0);
    Options.GetBody := chkGetBody.Checked;
    Options.GetBodyLines := StrToIntDef(edGetBodyLines.Text,0);
    Options.GetBodySize := StrToIntDef(edGetBodySize.Text,0);
    Options.PreferEnvelopes := chkPreferEnvelopes.Checked;


    Options.DeleteConfirmProtected := chkDeleteConfirmProtected.Checked;
    Options.LogRules := chkLogRules.Checked;
    Options.BlackListSpam := cmbBlacklistAction.Text = cmbBlacklistAction.Items[MARK_BLACKLIST_AS_SPAM];

    // enable save button
    funcEnableSaveBtn();
  end;

end;


end.
