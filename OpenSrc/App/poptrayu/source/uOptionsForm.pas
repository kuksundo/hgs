unit uOptionsForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, PngBitBtn,
  Vcl.StdCtrls, Vcl.Buttons, uGlobal;

type
  TOptionsForm = class(TForm)
    panOptionButtons: TPanel;
    btnSaveOptions: TBitBtn;
    btnCancel: TBitBtn;
    btnHintHelp: TSpeedButton;
    panOptionPage: TPanel;
    tvOptions: TTreeView;
    panOptions: TPanel;
    panOptSpacer: TPanel;
    panOptionsTitle: TPanel;
    imgOptionTitle: TImage;
    spltOptions: TSplitter;
    lblOptionTitle: TLabel;
    btnHelpOptions: TPngBitBtn;
    lblTest: TLabel;
    scrollBox1: TScrollBox;

    procedure btnHelpOptionsClick(Sender: TObject);
    procedure btnHintHelpClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure tvOptionsChange(Sender: TObject; Node: TTreeNode);
    procedure tvOptionsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnSaveOptionsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
//    procedure lvOptionsSelectItem(Sender: TObject; Item: TListItem;
//      Selected: Boolean);
    procedure OptionsChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure OnSetLanguage();
    procedure FormShow(Sender: TObject);

  private
    { Private declarations }
    frame : TFrame; //Frame currently shown in on the options page
    procedure changePanel(panelName : TOptionsPanelName);
  public
    { Public declarations }
    procedure UpdateUIAfterLoadingIni();
    procedure EnableSaveOptions();
    procedure SetBiDiModeOpts();
    procedure ShowSetEmailClient();
    procedure ShowMouseActions();
  end;

var
  OptionsForm: TOptionsForm;

implementation
uses uIniSettings, uDM, uFrameVisualAppearance, uFramePlugins,
  uFrameWhiteBlack, uFrameHotKeys, uFrameMouseButtons,
  uFrameMainWindowOptions, uFrameAdvancedOptions, uFrameGeneralOptions,
  uFrameInterval, uFrameDefaults, uMain, uTranslate, uFrameRulesOptions,
  uFramePreviewOptions, System.Math;

{$R *.dfm}

procedure TOptionsForm.btnCancelClick(Sender: TObject);
begin
  LoadOptionsINI;
end;

procedure TOptionsForm.btnHelpOptionsClick(Sender: TObject);
begin
  HtmlHelp(0, HelpFileName+'::/options.htm', HH_DISPLAY_TOPIC, 0);
end;

procedure TOptionsForm.btnHintHelpClick(Sender: TObject);
begin
  Screen.Cursor := crHelp;
end;

procedure TOptionsForm.btnSaveOptionsClick(Sender: TObject);
begin
  SaveOptionsINI();

  frmPopUMain.OptionsRefresh();

  // disable save/cancel buttons since we just saved
  btnSaveOptions.Enabled := False;
  btnCancel.Enabled := False;

end;

procedure TOptionsForm.FormCreate(Sender: TObject);
begin
  tvOptions.Selected := nil;
  //tvOptions.FullExpand;


  lblOptionTitle.Font.Style := [fsBold];

  TranslateComponentFromEnglish(self);
  TranslateComponentFromEnglish(tvOptions);

  // disable buttons
  btnSaveOptions.Enabled := False;
  btnCancel.Enabled := False;

end;

procedure TOptionsForm.SetBiDiModeOpts();
begin
 { if (Application.BiDiMode = bdRightToLeft) then begin
    SetWinControlBiDi(tvOptions);
    TranslateComponentFromEnglish(tvOptions);
  end; }
end;

procedure TOptionsForm.OnSetLanguage();
var
  i : integer;
begin
  TranslateForm(self);

  //if (Assigned(tvOptions)) then
  //  TranslateComponent(tvOptions);
  if (Assigned(frame)) then begin
    TranslateComponent(frame);
    frame.Refresh;
  end;

  if (Assigned(tvOptions)) then
    for i := 0 to tvOptions.Items.Count-1 do
    begin
      tvOptions.Items[i].Text := Translate(tvOptions.Items[i].Text);
    end;

end;

procedure TOptionsForm.FormResize(Sender: TObject);
begin
  panOptionButtons.Width := self.Width;

  lblTest.Caption := btnCancel.Caption;
  btnCancel.ClientWidth := Max(lblTest.Width, 90) + 10 + 16;
  btnCancel.Left := panOptionButtons.Width - btnCancel.Width - 6;
  btnCancel.Top := btnHelpOptions.Top;
  btnCancel.ClientHeight := Max(lblTest.Height, 25);

  lblTest.Caption := btnSaveOptions.Caption;
  btnSaveOptions.ClientWidth := Max(lblTest.Width, 120) + 10 + 16;
  btnSaveOptions.Left := btnCancel.Left - btnSaveOptions.Width - 10;
  btnSaveOptions.ClientHeight := btnCancel.ClientHeight;

  btnHelpOptions.ClientHeight := btnCancel.ClientHeight;
  lblTest.Caption := btnHelpOptions.Caption;
  btnHelpOptions.ClientWidth := Max(lblTest.Width, 70) + 10 + 16;
  btnHelpOptions.Height := Max(btnCancel.Height, 25);

  btnHintHelp.Left := btnHelpOptions.Left + btnHelpOptions.Width + 10;
  btnHintHelp.Height := btnCancel.Height;
  btnHintHelp.ClientHeight := btnCancel.ClientHeight;

  panOptionButtons.ClientHeight := btnHelpOptions.ClientHeight + 6;

end;

procedure TOptionsForm.FormShow(Sender: TObject);
begin
  if tvOptions.Selected = nil then
    changePanel(optNone);     // load default pane.
  OnSetLanguage();
end;

procedure TOptionsForm.tvOptionsChange(Sender: TObject; Node: TTreeNode);
var
  panelName : TOptionsPanelName;
begin
  if (Node = nil) then begin
    panelName := optNone;
  end
  else
    panelName := TOptionsPanelName(Node.AbsoluteIndex);

  changePanel(panelName);

end;

procedure TOptionsForm.changePanel(panelName : TOptionsPanelName);
begin
  // free any frames created
  if Assigned(frame) then FreeAndNil(frame);

  if (panelName=optNone) then
  begin
    lblOptionTitle.Caption := Translate('Options');
    Exit;
  end;

  // create the selected frame
  case panelName of
    optDefaults           : frame := TframeDefaults.Create(Self, EnableSaveOptions);
    optInterval           : frame := TframeInterval.Create(Self, EnableSaveOptions);
    optGeneralOptions     : frame := TframeGeneralOptions.Create(Self, EnableSaveOptions);
    optAdvancedOptions    : frame := TframeAdvancedOptions.Create(Self, EnableSaveOptions);
    optMainWindow         : frame := TframeMainWindowOptions.Create(Self, EnableSaveOptions);
    optMouseButtons       : frame := TframeMouseButtons.Create(Self, EnableSaveOptions);
    optHotKeys            : frame := TframeHotKeys.Create(Self, EnableSaveOptions);
    optWhiteBlackList     : frame := TframeWhiteBlack.Create(Self, EnableSaveOptions);
    //optPlugins            : frame := TframePlugins.Create(Self, EnableSaveOptions);
    optVisualAppearance   : frame := TframeVisualAppearance.Create(Self, EnableSaveOptions);
    optPreview            : frame := TframePreviewOptions.Create(Self, EnableSaveOptions);
    optRules              : frame := TframeRulesOptions.Create(Self, EnableSaveOptions);
  end;

  if (Application.BiDiMode = bdLeftToRight) then begin
    imgOptionTitle.Align := alLeft;
    imgOptionTitle.Anchors :=  [akTop, akBottom, akLeft];
  end else begin
    imgOptionTitle.Align := alRight;
    imgOptionTitle.Anchors := [akTop, akBottom, akRight];
  end;

  // show frame
  if Assigned(frame) then
  begin
    scrollbox1.Visible := false;
    frame.Parent := panOptions;
    frame.Align := alClient;
    frame.AutoSize := true;

    self.OnResize(self);
  end;
  // title
  lblOptionTitle.Caption := tvOptions.Items[Integer(panelName)].Text;
  imgOptionTitle.Transparent := true;
  dm.imlOptions.GetIcon(tvOptions.Items[Integer(panelName)].ImageIndex, imgOptionTitle.Picture.Icon);

end;


procedure TOptionsForm.tvOptionsMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    tvOptions.Selected := nil
  else
    frmPopUMain.QuickHelp(Sender, Button, Shift, X, Y);
end;

procedure TOptionsForm.UpdateUIAfterLoadingIni();
begin
  // show it
  if Assigned(frame) then
    tvOptionsChange(tvOptions,tvOptions.Selected);

  // disable buttons
  btnSaveOptions.Enabled := False;
  btnCancel.Enabled := False;
end;


procedure TOptionsForm.OptionsChange(Sender: TObject);
begin
  btnSaveOptions.Enabled := True;
  btnCancel.Enabled := True;
end;

// enables the save and cancel buttons on the options form.
procedure TOptionsForm.EnableSaveOptions();
begin
  btnSaveOptions.Enabled := True;
  btnCancel.Enabled := True;
end;

procedure TOptionsForm.ShowSetEmailClient();
begin
  changePanel(optDefaults);
  (frame as TframeDefaults).edProgram.SetFocus();
end;

procedure TOptionsForm.ShowMouseActions();
begin
  changePanel(optMouseButtons);
end;


end.

