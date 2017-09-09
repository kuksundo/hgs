unit uRulesForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.PlatformDefaultStyleActnCtrls,
  System.Actions, Vcl.ActnList, Vcl.ActnMan, Vcl.StdCtrls, Vcl.CheckLst,
  Vcl.Grids, Vcl.ExtCtrls, Vcl.Buttons, Vcl.ToolWin, Vcl.ActnCtrls, PngBitBtn,
  uMailItems, uAccounts, uRules, Vcl.ComCtrls, IdMessage, System.UITypes;


const
  RULE_NOT = '  X';

type
  TRulesForm = class(TForm)
    panRulesButtons: TPanel;
    panRulesButtonsRight: TPanel;
    btnSaveRules: TBitBtn;
    btnCancelRule: TBitBtn;
    btnHelpRules: TPngBitBtn;
    panRulesTop: TPanel;
    spltRules: TSplitter;
    RulesToolbar: TActionToolBar;
    btnEdRuleWav: TSpeedButton;
    btnEdRuleEXE: TSpeedButton;
    btnRuleSoundTest: TSpeedButton;
    chkRuleDelete: TCheckBox;
    chkRuleWav: TCheckBox;
    chkRuleIgnore: TCheckBox;
    edRuleWav: TEdit;
    chkRuleEXE: TCheckBox;
    edRuleEXE: TEdit;
    chkRuleImportant: TCheckBox;
    chkRuleLog: TCheckBox;
    chkRuleSpam: TCheckBox;
    chkRuleProtect: TCheckBox;
    chkRuleTrayColor: TCheckBox;
    colRuleTrayColor: TColorBox;
    lblRuleName: TLabel;
    lblAccount: TLabel;
    lblNeeded: TLabel;
    grdRule: TStringGrid;
    edRuleName: TEdit;
    chkRuleEnabled: TCheckBox;
    chkRuleNew: TCheckBox;
    cmbRuleAccount: TComboBox;
    panRuleEdit: TPanel;
    btnTestRegExpr: TSpeedButton;
    cmbRuleArea: TComboBox;
    cmbRuleComp: TComboBox;
    edRuleText: TEdit;
    chkRuleNot: TCheckBox;
    cmbRuleStatus: TComboBox;
    cmbRuleOperator: TComboBox;
    btnRuleAddRow: TButton;
    btnRuleDeleteRow: TButton;
    panRuleList: TPanel;
    listRules: TCheckListBox;
    panRuleListButtons: TPanel;
    btnRuleDown: TSpeedButton;
    btnRuleUp: TSpeedButton;
    RulesActionManager: TActionManager;
    actRuleAdd: TAction;
    actRuleDelete: TAction;
    actRulesImport: TAction;
    CategoryPanelGroup1: TCategoryPanelGroup;
    catRuleDetail: TCategoryPanel;
    catRuleName: TCategoryPanel;
    catRuleActions: TCategoryPanel;
    panRuleDetail: TPanel;
    chkAddLabel: TCheckBox;
    edAddLabel: TEdit;


    procedure edRuleNameChange(Sender: TObject);
    procedure btnTestRegExprClick(Sender: TObject);
    procedure grdRuleTopLeftChanged(Sender: TObject);
    procedure grdRuleSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure panRuleDetailResize(Sender: TObject);
    procedure cmbRuleOperatorChange(Sender: TObject);
    procedure btnRuleAddRowClick(Sender: TObject);
    procedure chkRuleNotClick(Sender: TObject);
    procedure btnRuleDeleteRowClick(Sender: TObject);
    procedure chkRuleTrayColorClick(Sender: TObject);
    procedure colRuleTrayColorChange(Sender: TObject);
    procedure cmbRuleStatusChange(Sender: TObject);
    procedure btnRuleDownClick(Sender: TObject);
    procedure btnRuleUpClick(Sender: TObject);
    procedure panRuleListButtonsResize(Sender: TObject);
    procedure btnEdRuleWavClick(Sender: TObject);
    procedure chkRuleEXEClick(Sender: TObject);
    procedure edRuleEXEChange(Sender: TObject);
    procedure btnEdRuleEXEClick(Sender: TObject);
    procedure chkRuleWavClick(Sender: TObject);
    procedure chkRuleEnabledClick(Sender: TObject);
    procedure cmbRuleAreaChange(Sender: TObject);
    procedure edRuleTextChange(Sender: TObject);
    procedure edRuleWavChange(Sender: TObject);
    procedure chkRuleDeleteClick(Sender: TObject);
    procedure btnSaveRulesClick(Sender: TObject);
    procedure btnCancelRuleClick(Sender: TObject);
    procedure btnRuleSoundTestClick(Sender: TObject);
    procedure btnHelpRules1Click(Sender: TObject);
    procedure chkRuleIgnoreClick(Sender: TObject);
    procedure listRulesKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure listRulesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cmbRuleCompChange(Sender: TObject);
    procedure chkRuleImportantClick(Sender: TObject);
    procedure chkRuleNewClick(Sender: TObject);
    procedure listRulesClick(Sender: TObject);
    procedure listRulesClickCheck(Sender: TObject);
    procedure chkRuleLogClick(Sender: TObject);
    procedure listRulesDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure listRulesDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure listRulesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure chkRuleProtectClick(Sender: TObject);
    procedure chkRuleSpamClick(Sender: TObject);

    // actions methods
    procedure actRulesImportExecute(Sender: TObject);
    procedure actRuleAddExecute(Sender: TObject);
    procedure actRuleDeleteExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);

    // Drag & Drop Methods
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    procedure cmbRuleAccountChange(Sender: TObject);
    procedure colRuleTrayColorGetColors(Sender: TCustomColorBox;
      Items: TStrings);
    procedure CategoryPanelGroup1Resize(Sender: TObject);
    procedure chkAddLabelClick(Sender: TObject);
    procedure edAddLabelChange(Sender: TObject);
  private
    { Private declarations }
    FRuleChanged : boolean;
    FPendingAccountChanges : boolean;

    // Drag & Drop Methods
    procedure WMDropFiles(var msg: TWMDROPFILES); message WM_DROPFILES;

    procedure SetupRuleGrid;
    procedure ShowRuleEdit(ACol,ARow : integer);
    procedure ShowRule(selected : integer);
    procedure DeleteRule(rulenum : integer);
    procedure EnableRuleButtons;
    procedure MoveRule(old,new : integer);
    procedure FillRulesAccountsDropdown(const Accounts : TAccounts); //Updates the Rule "accounts" list drop down after an account is added or removed etc
    procedure ShowRuleEditingFields();
    procedure HideRuleEditingFields();
  public
    { Public declarations }
    procedure enableBodyRuleArea(enable : boolean);
    function AddRule(rulename : string) : TRuleItem;
    procedure UpdateComponentSizes();
    procedure AccountsChanged();
    procedure RefreshRulesList();
    procedure EnableSaveRulesButton(enable : boolean = true);
  end;


var
  RulesForm: TRulesForm;

////////////////////////////////////////////////////////////////////////////////
///-----------------------------------------------------------------------------
///  Implementation Section
///-----------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

implementation

{$R *.dfm}


uses uTranslate, uRulesManager, uIniSettings, uRegExp, uRCUtils, uGlobal,
  StrUtils, System.Types, System.IniFiles, uMain, ShellAPI, Math,
  uPositioning;


const
  COL_AREA = 0;
  COL_COMPARE = 1;
  COL_TEXT = 2;
  COL_NOT = 3;

//------------------------------------------------------------------------------

procedure TRulesForm.UpdateComponentSizes();
begin
    //AutoSizeAllCheckBox(gbRule);
    //AutoSizeAllCheckBox(gbActions);
    edRuleWav.Left := chkRuleWav.Left + chkRuleWav.Width + 4;
    edRuleWav.Width := btnEdRuleWav.Left - edRuleWav.Left - 2;
    edRuleEXE.Left := chkRuleEXE.Left + chkRuleEXE.Width + 4;
    edRuleEXE.Width := btnEdRuleEXE.Left - edRuleEXE.Left - 2;
    colRuleTrayColor.Left := chkRuleTrayColor.Left + chkRuleTrayColor.Width + 4;
    colRuleTrayColor.Width := CatRuleActions.ClientWidth - colRuleTrayColor.Left - 4;
end;

/// Used to show or hide "Body" from the list of rule areas
/// depending on the "Rerieve Body While Checking" option.
procedure TRulesForm.enableBodyRuleArea(enable : boolean);
begin
    if (enable) then      // TODO: should this use RuleAreaToStr??
    begin
      // Add Body to the list of areas that can be used for rules on the rules tab
      if TranslateToEnglish(cmbRuleArea.Items[cmbRuleArea.Items.Count-1]) <> 'Body' then
        cmbRuleArea.Items.Add(uTranslate.Translate('Body'));
    end
    else begin
      // Remove Body from the list of areas that can be used for rules on the rules tab
      if TranslateToEnglish(cmbRuleArea.Items[cmbRuleArea.Items.Count-1]) = 'Body' then
        cmbRuleArea.Items.Delete(cmbRuleArea.Items.Count-1);
    end;
end;



procedure TRulesForm.chkRuleWavClick(Sender: TObject);
begin
  edRuleWav.Text := '';
  edRuleWav.Visible := chkRuleWav.Checked;
  btnEdRuleWav.Visible := chkRuleWav.Checked;
  btnRuleSoundTest.Visible := chkRuleWav.Checked;
  btnEdRuleWav.Refresh;
  btnRuleSoundTest.Refresh;
end;

procedure TRulesForm.edRuleNameChange(Sender: TObject);
begin
  EnableRuleButtons;
  if listRules.ItemIndex > -1 then
  begin
    RulesManager.Rules[listRules.ItemIndex].Name := edRuleName.Text;
    if edRuleName.Tag = 0 then // bug in WinNT
      listRules.Items[listRules.ItemIndex] := edRuleName.Text;
  end;

end;

procedure TRulesForm.listRulesClick(Sender: TObject);
begin
  ShowRule(listRules.ItemIndex)
end;

procedure TRulesForm.chkRuleEnabledClick(Sender: TObject);
begin
  EnableRuleButtons;
  if listRules.ItemIndex > -1 then
  begin
    RulesManager.Rules[listRules.ItemIndex].Enabled := chkRuleEnabled.Checked;
    listRules.Checked[listRules.ItemIndex] := chkRuleEnabled.Checked;
  end;
end;

procedure TRulesForm.cmbRuleAccountChange(Sender: TObject);
begin
  EnableRuleButtons;
  if listRules.ItemIndex > -1 then
    RulesManager.Rules[listRules.ItemIndex].Account := cmbRuleAccount.ItemIndex;
end;

procedure TRulesForm.cmbRuleAreaChange(Sender: TObject);
begin
  if Sender<>nil then EnableRuleButtons;
  if listRules.ItemIndex > -1 then
  begin
    RulesManager.Rules[listRules.ItemIndex].Rows[grdRule.Row-1].Area := TRuleArea(cmbRuleArea.ItemIndex);
    grdRule.Cells[COL_AREA,grdRule.Row] := cmbRuleArea.Text;
  end;
  // show text or status
  if (cmbRuleArea.ItemIndex > -1) and (TRuleArea(cmbRuleArea.ItemIndex) = raStatus) then
  begin
    cmbRuleComp.ItemIndex := Ord(rcEquals);
    cmbRuleCompChange(nil);
    cmbRuleComp.Enabled := False;
    cmbRuleStatus.Show;
    cmbRuleStatusChange(nil);
    edRuleText.Hide;
  end
  else begin
    cmbRuleComp.Enabled := True;
    cmbRuleStatus.Hide;
    edRuleText.Show;
    edRuleTextChange(edRuleText);
  end;
end;

procedure TRulesForm.cmbRuleCompChange(Sender: TObject);
begin
  if Sender<>nil then EnableRuleButtons;
  if (listRules.ItemIndex > -1) and (cmbRuleComp.ItemIndex > -1) then
  begin
    RulesManager.Rules[listRules.ItemIndex].Rows[grdRule.Row-1].Compare := TRuleCompare(cmbRuleComp.ItemIndex);
    grdRule.Cells[COL_COMPARE,grdRule.Row] := cmbRuleComp.Text;
  end;
  // show text box?
  if (cmbRuleComp.ItemIndex > -1) and (TRuleCompare(cmbRuleComp.ItemIndex) = rcEmpty) then
  begin
    edRuleText.Text := '';
    edRuleText.Enabled := False;
    edRuleText.Color := clBtnFace;
  end
  else begin
    edRuleText.Enabled := True;
    edRuleText.Color := clWindow;
  end;
  // show reg expr button?
  if (cmbRuleComp.ItemIndex > -1) and (TRuleCompare(cmbRuleComp.ItemIndex) = rcRegExpr) then
  begin
    btnTestRegExpr.Visible := True;
    panRuleDetailResize(panRuleDetail);
  end
  else begin
    btnTestRegExpr.Visible := False;
    panRuleDetailResize(panRuleDetail);
  end;
end;


procedure TRulesForm.chkRuleNewClick(Sender: TObject);
begin
  EnableRuleButtons;
  if listRules.ItemIndex > -1 then
    RulesManager.Rules[listRules.ItemIndex].New := chkRuleNew.Checked;
end;

procedure TRulesForm.edRuleTextChange(Sender: TObject);
begin
  EnableRuleButtons;
  if listRules.ItemIndex > -1 then
  begin
    RulesManager.Rules[listRules.ItemIndex].Rows[grdRule.Row-1].Text := edRuleText.Text;
    grdRule.Cells[COL_TEXT,grdRule.Row] := edRuleText.Text;
  end;
end;

procedure TRulesForm.edRuleWavChange(Sender: TObject);
begin
  EnableRuleButtons;
  if listRules.ItemIndex > -1 then
    RulesManager.Rules[listRules.ItemIndex].Wav := edRulewav.Text;
end;

procedure TRulesForm.chkAddLabelClick(Sender: TObject);
begin
  edAddLabel.Text := '';
  edAddLabel.Visible := chkAddLabel.Checked;
end;

procedure TRulesForm.chkRuleDeleteClick(Sender: TObject);
begin
  EnableRuleButtons;
  if listRules.ItemIndex > -1 then
    RulesManager.Rules[listRules.ItemIndex].Delete := chkRuleDelete.Checked;
end;

procedure TRulesForm.chkRuleIgnoreClick(Sender: TObject);
begin
  EnableRuleButtons;
  if listRules.ItemIndex > -1 then
    RulesManager.Rules[listRules.ItemIndex].Ignore := chkRuleIgnore.Checked;
end;

procedure TRulesForm.chkRuleImportantClick(Sender: TObject);
begin
  EnableRuleButtons;
  if listRules.ItemIndex > -1 then
    RulesManager.Rules[listRules.ItemIndex].Important := chkRuleImportant.Checked;
end;

procedure TRulesForm.chkRuleLogClick(Sender: TObject);
begin
  EnableRuleButtons;
  if listRules.ItemIndex > -1 then
    RulesManager.Rules[listRules.ItemIndex].Log := chkRuleLog.Checked;
end;

procedure TRulesForm.edAddLabelChange(Sender: TObject);
begin
  EnableRuleButtons;
  if listRules.ItemIndex > -1 then
    RulesManager.Rules[listRules.ItemIndex].AddLabel := edAddLabel.Text;
end;

procedure TRulesForm.edRuleEXEChange(Sender: TObject);
begin
  EnableRuleButtons;
  if listRules.ItemIndex > -1 then
    RulesManager.Rules[listRules.ItemIndex].EXE := edRuleEXE.Text;
end;

procedure TRulesForm.chkRuleEXEClick(Sender: TObject);
begin
  edRuleEXE.Text := '';
  edRuleEXE.Visible := chkRuleEXE.Checked;
  btnEdRuleEXE.Visible := chkRuleEXE.Checked;
end;

procedure TRulesForm.btnEdRuleEXEClick(Sender: TObject);
var
  dlgOpen : TOpenDialog;
begin
  dlgOpen := TOpenDialog.Create(nil);
  try
    dlgOpen.InitialDir := ExtractFileDir(edRuleEXE.Text);
    dlgOpen.Filter := Translate('EXE files')+' (*.exe)|*.exe|'+
                      Translate('All Files')+' (*.*)|*.*';
    if dlgOpen.Execute then
    begin
      edRuleEXE.Text := dlgOpen.FileName;
    end;
  finally
    dlgOpen.Free;
  end;
end;

procedure TRulesForm.btnSaveRulesClick(Sender: TObject);
begin
  SaveRulesINI;
end;

procedure TRulesForm.btnCancelRuleClick(Sender: TObject);
begin
  LoadRulesINI;
  listRules.ItemIndex := -1;
  HideRuleEditingFields();
  actRuleDelete.Enabled := False;
  btnRuleDown.Enabled := False;
  btnRuleUp.Enabled := False;
end;


procedure TRulesForm.actRuleAddExecute(Sender: TObject);
var
  RuleStr : string;
  NewRule : TRuleItem;
begin
  RuleStr := Translate('Rule');
  // add to rules
  NewRule := AddRule(RuleStr);
  with NewRule.Rows.CreateAndAdd do
  begin
    Area := raHeader;
    Compare := rcContains;
    Text := '';
    RuleNot := False;
  end;
  // show in listbox
  listRules.ItemIndex := RulesManager.Rules.Count-1;

  ShowRuleEditingFields();

  // clear rule detail
  edRuleName.Text := NewRule.Name;
  edRuleName.SelectAll;
  edRuleName.SetFocus;
  chkRuleEnabled.Checked := NewRule.Enabled;
  chkRuleNew.Checked := NewRule.New;
  cmbRuleAccount.ItemIndex := NewRule.Account;
  cmbRuleOperator.ItemIndex := integer(NewRule.Operator);
  // setup grid
  SetupRuleGrid;
  grdRule.RowCount := 2;
  // clear row
  cmbRuleArea.ItemIndex := 0;
  cmbRuleAreaChange(nil);
  cmbRuleComp.ItemIndex := 0;
  cmbRuleCompChange(nil);
  edRuleText.Text := '';
  chkRuleNot.Checked := False;
  // clear action checkboxes
  chkRuleWav.Checked := NewRule.Wav<>'';
  chkRuleEXE.Checked := NewRule.EXE<>'';
  chkRuleDelete.Checked := NewRule.Delete;
  chkRuleIgnore.Checked := NewRule.Ignore;
  chkRuleImportant.Checked := NewRule.Important;
  chkRuleSpam.Checked := NewRule.Spam;
  chkRuleLog.Checked := NewRule.Log;
  chkRuleTrayColor.Checked := NewRule.TrayColor<>-1;
  chkRuleProtect.Checked := NewRule.Protect;
  chkAddLabel.Checked := NewRule.AddLabel<>'';

  // enable buttons
  FRuleChanged := True;
  EnableRuleButtons;
end;

procedure TRulesForm.actRuleDeleteExecute(Sender: TObject);
begin
  if listRules.ItemIndex > -1 then
  begin
    if ShowTranslatedDlg(Translate('Delete Rule:')+' '+RulesManager.Rules[listRules.ItemIndex].Name+#13#10+
                  Translate('Are you sure?'), mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      DeleteRule(listRules.ItemIndex);
    end;
  end
  else begin
    ShowTranslatedDlg(Translate('No rule selected'), mtError, [mbOK], 0);
  end;
  btnSaveRules.Enabled := True;
  btnCancelRule.Enabled := True;
end;


procedure TRulesForm.btnTestRegExprClick(Sender: TObject);
begin
  SyntaxCheckRegExpr(edRuleText.Text);
end;
{
function GetLargestValue( values : array of integer ) : integer;
var
  i : integer;
begin
  Result := 0;
  for i := 1 to values.Count-1 do
  begin
  if values[i]>maxval then
    Result := values[i];
  end;
end;
 }



procedure TRulesForm.CategoryPanelGroup1Resize(Sender: TObject);
const
  VMARGIN = 6;
  HMARGIN = 6;
  LBL_EDIT_SPACING = 2;
var
  rowHeight, col1Width, col2Width : Integer;
  colGrp : TArray<Integer>;//array of integer;
  chkGrp : TArray<TCheckbox>;
  chk : TCheckbox;
begin
  // Rule name panel -----------------------------------------------------------
  edRuleName.Left := lblRuleName.Left + lblRuleName.Width + LBL_EDIT_SPACING;
  chkRuleEnabled.Height := lblRuleName.Height;
  AutosizeCheckbox(chkRuleEnabled);
  chkRuleEnabled.Left := catRuleName.ClientWidth - HMARGIN - chkRuleEnabled.Width;
  catRuleName.ClientHeight := edRuleName.Top + edRuleName.Height + VMARGIN;

  // Conditions Panel ----------------------------------------------------------
  AutoSizeCheckBox(chkRuleNew);
  AutoSizeButton(btnRuleAddRow, Canvas);
  AutoSizeButton(btnRuleDeleteRow, Canvas);
  AutosizeCombobox(cmbRuleAccount, 117);
  AutosizeCombobox(cmbRuleOperator, 117);
  cmbRuleAccount.Width := Max(cmbRuleAccount.Width, cmbRuleOperator.Width);
  cmbRuleOperator.Width := cmbRuleAccount.Width;

  cmbRuleAccount.Left := HMARGIN + Max(lblAccount.Width, lblNeeded.Width) + LBL_EDIT_SPACING;
  cmbRuleOperator.Left := cmbRuleAccount.Left;
  lblAccount.Left := cmbRuleAccount.Left - lblAccount.Width - LBL_EDIT_SPACING;
  lblNeeded.Left := cmbRuleAccount.Left - lblNeeded.Width - LBL_EDIT_SPACING;
  chkRuleNew.Left := CalcPosToRightOf(cmbRuleAccount, HMARGIN);
  chkRuleNew.Height := lblRuleName.Height; // label height
  btnRuleAddRow.Left := CalcPosToRightOf(cmbRuleOperator, HMARGIN);
  btnRuleDeleteRow.Left := CalcPosToRightOf(btnRuleAddRow, HMARGIN);
  btnRuleAddRow.Height := cmbRuleOperator.Height;
  btnRuleDeleteRow.Height := cmbRuleOperator.Height;
  cmbRuleOperator.Top := cmbRuleAccount.Top + cmbRuleAccount.Height + 3;
  btnRuleAddRow.Top := cmbRuleOperator.Top;
  btnRuleDeleteRow.Top := cmbRuleOperator.Top;
  lblNeeded.Top := cmbRuleOperator.Top + 3;

  grdRule.DefaultRowHeight := cmbRuleArea.Height;

  panRuleEdit.Height := cmbRuleArea.Height;
  grdRule.RowHeights[0] := lblRuleName.Height;
  grdRule.Height := lblRuleName.Height + 3*cmbRuleArea.Height+3;
  panRuleDetail.Height := cmbRuleOperator.Top + cmbRuleOperator.Height + VMARGIN + grdRule.Height;
  catRuleDetail.ClientHeight := panRuleDetail.Height;

  // Actions Panel -------------------------------------------------------------
  //AutoSizeAllCheckBox(catRuleActions);  //does not work on TCategoryPanels - bug???
  AutoSizeCheckBox(chkRuleDelete);
  AutoSizeCheckBox(chkRuleSpam);
  AutoSizeCheckBox(chkRuleIgnore);
  AutoSizeCheckBox(chkRuleLog);
  AutoSizeCheckBox(chkRuleWav);
  AutoSizeCheckBox(chkRuleEXE);
  AutoSizeCheckBox(chkRuleTrayColor);
  AutoSizeCheckBox(chkRuleImportant);
  AutoSizeCheckBox(chkRuleProtect);
  AutoSizeCheckBox(chkAddLabel);

  // Set LEFT anchor for checkboxes in LEFT column.
  SetLength(colGrp, 4);
  colGrp := TArray<Integer>.Create(chkRuleDelete.Width, chkRuleSpam.Width,
    chkRuleIgnore.Width, chkRuleLog.Width, 119);
  col1Width := MaxIntValue(colGrp) + 10;
  col1Width := Max(119, col1Width);
  chkGrp := TArray<TCheckBox>.Create(chkRuleDelete, chkRuleSpam,
    chkRuleIgnore, chkRuleLog);
  for chk in chkGrp do begin
    chk.Left := VMARGIN;
    chk.Width := col1Width;
    chk.Height := lblRuleName.Height; // height = height of a label
  end;

  // row height = height of an arbitrary edit box + margin
  rowHeight := edRuleWav.Height + 3;

  // TOP anchor for checkboxes in the LEFT column.
  chkRuleSpam.Top := chkRuleDelete.Top + rowHeight + 3; //valign centered to edit box
  chkRuleIgnore.Top := chkRuleSpam.Top + rowHeight ;
  chkRuleLog.Top := chkRuleSpam.Top + (rowHeight)*2; //skip a row

  // Set LEFT anchor for checkboxes in RIGHT column.
  chkGrp := TArray<TCheckBox>.Create(chkRuleWav, chkRuleEXE,
    chkRuleTrayColor, chkRuleImportant, chkRuleProtect, chkAddLabel);
  colGrp := TArray<Integer>.Create(chkRuleWav.Width, chkRuleEXE.Width,
    chkRuleTrayColor.Width, chkRuleImportant.Width, chkRuleProtect.Width,
    chkAddLabel.Width);
  //col2Width := MaxIntValue(colGrp) + 10;
  for chk in chkGrp do begin
    chk.Left := VMARGIN + col1Width;
    chk.Height := lblRuleName.Height; // height = height of a label
  end;

  // TOP anchor for checkboxes in the RIGHT column.
  chkRuleWav.Top := VMARGIN + 3;
  chkRuleEXE.Top := chkRuleWav.Top + rowHeight;
  chkRuleTrayColor.Top := chkRuleEXE.Top + rowHeight;
  chkRuleImportant.Top := chkRuleTrayColor.Top + rowHeight;
  chkRuleProtect.Top := chkRuleImportant.Top + rowHeight;
  chkAddLabel.Top := chkRuleProtect.Top + rowHeight;

  // TOP and LEFT anchors for edit boxes & buttons next to RIGHT column.

  btnRuleSoundTest.Top := VMARGIN;
  btnEdRuleWav.Top := VMARGIN;
  edRuleWav.Top := VMARGIN;
  btnRuleSoundTest.Height := edRuleWav.Height;
  btnEdRuleWav.Height := edRuleWav.Height;
  edRuleWav.Left := CalcPosToRightOf(chkRuleWav, LBL_EDIT_SPACING);
  edRuleWav.Width := btnEdRuleWav.Left - edRuleWav.Left - HMARGIN;

  btnEdRuleEXE.Height := edRuleEXE.Height;
  edRuleEXE.Left := CalcPosToRightOf(chkRuleEXE, LBL_EDIT_SPACING);
  edRuleEXE.Width := btnEdRuleEXE.Left - edRuleEXE.Left - HMARGIN;
  edRuleEXE.Top := chkRuleEXE.Top;
  btnEdRuleEXE.Top := edRuleEXE.Top;

  chkAddLabel.Width := chkAddLabel.Width + 3; //add extra margin so word isn't cut off

  edAddLabel.Left := CalcPosToRightOf(chkAddLabel, LBL_EDIT_SPACING);
  edAddLabel.Width := (btnEdRuleEXE.Left + btnEdRuleEXE.Width) - edAddLabel.Left - HMARGIN;
  //                                RIGHT MARGIN POS               LEFT EDGE      SPACE BETWEEN
  edAddLabel.Top := chkAddLabel.Top - 3;

  colRuleTrayColor.Top := chkRuleTrayColor.Top;
  colRuleTrayColor.Left := chkRuleTrayColor.Left + chkRuleTrayColor.Width + LBL_EDIT_SPACING;

  // HEIGHT of the PANEL should be just below the BOTTOM of the LAST component on the panel.
  catRuleActions.ClientHeight := calcPosBelow(chkAddLabel) + VMARGIN;

end;

procedure TRulesForm.grdRuleTopLeftChanged(Sender: TObject);
begin
  if grdRule.CellRect(0,grdRule.Row).Top > 10 then
    ShowRuleEdit(0,grdRule.Row)
  else
    panRuleEdit.Hide;
end;

procedure TRulesForm.grdRuleSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  ShowRuleEdit(ACol,ARow);
end;

procedure TRulesForm.panRuleDetailResize(Sender: TObject);
begin
  panRuleEdit.Width := grdRule.Width - 17;
  grdRule.ColWidths[COL_TEXT] := grdRule.Width - grdRule.ColWidths[COL_AREA] -
    grdRule.ColWidths[COL_COMPARE] - grdRule.ColWidths[COL_NOT] - 21;
  if btnTestRegExpr.Visible then
    edRuleText.Width := grdRule.ColWidths[COL_TEXT] - btnTestRegExpr.Width + 1
  else
    edRuleText.Width := grdRule.ColWidths[COL_TEXT] + 2;
  cmbRuleStatus.Width := edRuleText.Width;
  btnTestRegExpr.Left := edRuleText.Left + edRuleText.Width;
  chkRuleNot.Left := edRuleText.Left + grdRule.ColWidths[COL_TEXT] + 8;
end;

procedure TRulesForm.cmbRuleOperatorChange(Sender: TObject);
begin
  EnableRuleButtons;
  if listRules.ItemIndex > -1 then
    RulesManager.Rules[listRules.ItemIndex].Operator := TRuleOperator(cmbRuleOperator.ItemIndex);
end;

procedure TRulesForm.chkRuleNotClick(Sender: TObject);
begin
  EnableRuleButtons;
  if listRules.ItemIndex > -1 then
  begin
    RulesManager.Rules[listRules.ItemIndex].Rows[grdRule.Row-1].RuleNot := chkRuleNot.Checked;
    if chkRuleNot.Checked then
      grdRule.Cells[COL_NOT,grdRule.Row] := RULE_NOT
    else
      grdRule.Cells[COL_NOT,grdRule.Row] := '';
  end;
end;

procedure TRulesForm.btnRuleAddRowClick(Sender: TObject);
var
  toprow : integer;
begin
  EnableRuleButtons;
  if listRules.ItemIndex > -1 then
  begin
    RulesManager.Rules[listRules.ItemIndex].Rows.CreateAndAdd;
    grdRule.RowCount := grdRule.RowCount + 1;
    grdRule.Cells[COL_AREA,grdRule.RowCount-1] := '';
    grdRule.Cells[COL_COMPARE,grdRule.RowCount-1] := '';
    grdRule.Cells[COL_TEXT,grdRule.RowCount-1] := '';
    grdRule.Cells[COL_NOT,grdRule.RowCount-1] := '';
    toprow := grdRule.RowCount-4;
    if (toprow < 1) then toprow := 1;
    grdRule.TopRow := toprow;
    ShowRuleEdit(COL_AREA,grdRule.RowCount-1);
  end;
end;

procedure TRulesForm.btnRuleDeleteRowClick(Sender: TObject);
var
  i : integer;
begin
  if grdRule.RowCount > 2 then
  begin
    EnableRuleButtons;
    if listRules.ItemIndex > -1 then
    begin
      RulesManager.Rules[listRules.ItemIndex].Rows.Delete(grdRule.Row-1);
      for i := grdRule.Row to grdRule.RowCount-2 do
        grdRule.Rows[i] := grdRule.Rows[i+1];
      grdRule.RowCount := grdRule.RowCount - 1;
      ShowRuleEdit(COL_AREA,grdRule.Row);
    end;
  end;
end;

procedure TRulesForm.chkRuleTrayColorClick(Sender: TObject);
begin
  EnableRuleButtons;
  if listRules.ItemIndex > -1 then
  begin
    colRuleTrayColor.Visible := chkRuleTrayColor.Checked;
    if chkRuleTrayColor.Checked then
      RulesManager.Rules[listRules.ItemIndex].TrayColor := colRuleTrayColor.Selected
    else
      RulesManager.Rules[listRules.ItemIndex].TrayColor := -1;
  end;
end;

procedure TRulesForm.colRuleTrayColorChange(Sender: TObject);
begin
  EnableRuleButtons;
  if listRules.ItemIndex > -1 then
    RulesManager.Rules[listRules.ItemIndex].TrayColor := colRuleTrayColor.Selected;
end;

procedure TRulesForm.colRuleTrayColorGetColors(Sender: TCustomColorBox;
  Items: TStrings);
var
  i: integer;
//  s: string;
begin
  for i := 0 to Items.Count - 1 do begin
    Items.Strings[i] := Translate(Items.Strings[i]);
  end;
end;

procedure TRulesForm.cmbRuleStatusChange(Sender: TObject);
begin
  if Sender<>nil then EnableRuleButtons;
  if listRules.ItemIndex > -1 then
  begin
    RulesManager.Rules[listRules.ItemIndex].Rows[grdRule.Row-1].Text := IntToStr(cmbRuleStatus.ItemIndex);
    grdRule.Cells[COL_TEXT,grdRule.Row] := cmbRuleStatus.Text;
  end;

end;

procedure TRulesForm.btnRuleDownClick(Sender: TObject);
begin
  MoveRule(listRules.ItemIndex,listRules.ItemIndex+1);
end;

procedure TRulesForm.btnRuleUpClick(Sender: TObject);
begin
  MoveRule(listRules.ItemIndex,listRules.ItemIndex-1);
end;

procedure TRulesForm.panRuleListButtonsResize(Sender: TObject);
begin
  btnRuleDown.Width := panRuleListButtons.Width div 2 - 5;
  btnRuleUp.Left := panRuleListButtons.Width div 2 + 1;
  btnRuleUp.Width := panRuleListButtons.Width div 2 - 5;
end;




procedure TRulesForm.SetupRuleGrid;
begin
  with grdRule do
  begin
    RowHeights[0] := lblRuleName.Height;
    Cells[COL_AREA,0] := Translate('Area');
    ColWidths[COL_AREA] := 91;                  //TODO: un-hardcode these
    Cells[COL_COMPARE,0] := Translate('Compare');
    ColWidths[COL_COMPARE] := 74;
    Cells[COL_TEXT,0] := Translate('Text');
    ColWidths[COL_TEXT] := 141;
    Cells[COL_NOT,0] := Translate('Not');
    ColWidths[COL_NOT] := 25;
    panRuleEdit.Top := grdRule.Top + grdRule.CellRect(0,0).Bottom + 1;
    panRuleDetailResize(panRuleDetail);
  end;
end;

procedure TRulesForm.ShowRuleEdit(ACol,ARow : integer);
var
  isstatus : boolean;
begin
  panRuleEdit.Hide;
  grdRule.OnSelectCell := nil;
  grdRule.Row := ARow;
  grdRule.OnSelectCell := grdRuleSelectCell;
  // set edits
  FRuleChanged := False;
  cmbRuleArea.ItemIndex := cmbRuleArea.Items.IndexOf(grdRule.Cells[COL_AREA,ARow]);
  isstatus := (cmbRuleArea.ItemIndex > -1) and (TRuleArea(cmbRuleArea.ItemIndex) = raStatus);
  if isstatus then
    cmbRuleStatus.ItemIndex := cmbRuleStatus.Items.IndexOf(grdRule.Cells[COL_TEXT,ARow])
  else
    edRuleText.Text := grdRule.Cells[COL_TEXT,ARow];
  cmbRuleAreaChange(nil);
  cmbRuleComp.ItemIndex := cmbRuleComp.Items.IndexOf(grdRule.Cells[COL_COMPARE,ARow]);
  cmbRuleCompChange(nil);
  chkRuleNot.Checked := grdRule.Cells[COL_NOT,ARow] = RULE_NOT;
  FRuleChanged := True;
  // show
  panRuleEdit.Top := grdRule.Top + grdRule.CellRect(ACol,ARow).Top;
  if ARow > 1 then panRuleEdit.Top := panRuleEdit.Top - 1;
  panRuleEdit.Show;
  // focus
  case ACol of
    COL_AREA    : cmbRuleArea.SetFocus;
    COL_COMPARE : if cmbRuleComp.Enabled then cmbRuleComp.SetFocus;
    COL_TEXT    : begin
                    if isstatus then
                      cmbRuleStatus.SetFocus
                    else begin
                      edRuleText.SelectAll;
                      edRuleText.SetFocus;
                    end;
                  end;
    COL_NOT     : chkRuleNot.SetFocus;
  end;
end;

procedure TRulesForm.ShowRuleEditingFields();
begin
  CategoryPanelGroup1.Visible := true;
  panRuleDetail.Visible := True;
  actRuleDelete.Enabled := True;
  btnRuleDown.Enabled := listRules.ItemIndex < listRules.Count-1;
  btnRuleUp.Enabled := listRules.ItemIndex > 0;
end;

procedure TRulesForm.HideRuleEditingFields();
begin
  CategoryPanelGroup1.Visible := false;
  actRuleDelete.Enabled := False;
  panRuleDetail.Visible := False;
  btnRuleDown.Enabled := False;
  btnRuleUp.Enabled := False;
end;

procedure TRulesForm.ShowRule(selected: integer);
var
  i : integer;
  isstatus : boolean;
begin
  // show the selected rule in the editboxes
  if selected > -1 then
  begin
    SetupRuleGrid;
    FRuleChanged := False;
    // visible
    ShowRuleEditingFields();
    // rule detail
    edRuleName.Tag := 1; // bug in WinNT
    edRuleName.Text := RulesManager.Rules[selected].Name;
    edRuleName.Tag := 0;
    chkRuleEnabled.Checked := RulesManager.Rules[selected].Enabled;
    chkRuleNew.Checked := RulesManager.Rules[selected].New;
    cmbRuleAccount.ItemIndex := RulesManager.Rules[selected].Account;
    cmbRuleOperator.ItemIndex := Ord(RulesManager.Rules[selected].Operator);

    // edit row
    grdRule.OnSelectCell := nil;
    grdRule.OnTopLeftChanged := nil;
    grdRule.Row := 1;
    grdRule.RowCount := RulesManager.Rules[selected].Rows.Count + 1;
    grdRule.OnSelectCell := grdRuleSelectCell;
    grdRule.OnTopLeftChanged := grdRuleTopLeftChanged;
    cmbRuleArea.ItemIndex := Ord(RulesManager.Rules[selected].Rows[0].Area);
    if (cmbRuleArea.ItemIndex > -1) and (TRuleArea(cmbRuleArea.ItemIndex) = raStatus) then
      cmbRuleStatus.ItemIndex := StrToInt(RulesManager.Rules[selected].Rows[0].Text)
    else
      edRuleText.Text := RulesManager.Rules[selected].Rows[0].Text;
    cmbRuleAreaChange(nil);
    cmbRuleComp.ItemIndex := Ord(RulesManager.Rules[selected].Rows[0].Compare);
    cmbRuleCompChange(nil);
    chkRuleNot.Checked := RulesManager.Rules[selected].Rows[0].RuleNot;
    // rows grid
    for i := 0 to RulesManager.Rules[selected].Rows.Count-1 do
    begin
      grdRule.Cells[COL_AREA,i+1] := Translate(RuleAreaToStr(RulesManager.Rules[selected].Rows[i].Area));
      grdRule.Cells[COL_COMPARE,i+1] := Translate(RuleCompareToStr(RulesManager.Rules[selected].Rows[i].Compare));
      isstatus :=  StrToRuleArea(grdRule.Cells[COL_AREA,i+1]) = raStatus;
      if isstatus then
        grdRule.Cells[COL_TEXT,i+1] := cmbRuleStatus.Items[StrToInt(RulesManager.Rules[selected].Rows[i].Text)]
      else
        grdRule.Cells[COL_TEXT,i+1] := RulesManager.Rules[selected].Rows[i].Text;
      if RulesManager.Rules[selected].Rows[i].RuleNot then
        grdRule.Cells[COL_NOT,i+1] := RULE_NOT
      else
        grdRule.Cells[COL_NOT,i+1] := '';
    end;

    // actions
    chkRuleWav.Checked := RulesManager.Rules[selected].Wav <> '';
    edRuleWav.Text := RulesManager.Rules[selected].Wav;
    chkRuleDelete.Checked := RulesManager.Rules[selected].Delete;
    chkRuleIgnore.Checked := RulesManager.Rules[selected].Ignore;
    chkRuleEXE.Checked := RulesManager.Rules[selected].EXE <> '';
    chkRuleImportant.Checked := RulesManager.Rules[selected].Important;
    chkRuleSpam.Checked := RulesManager.Rules[selected].Spam;
    chkRuleProtect.Checked := RulesManager.Rules[selected].Protect;
    edRuleEXE.Text := RulesManager.Rules[selected].EXE;
    chkRuleLog.Checked := RulesManager.Rules[selected].Log;
    colRuleTrayColor.Selected := RulesManager.Rules[selected].TrayColor;
    chkRuleTrayColor.Checked := RulesManager.Rules[selected].TrayColor <> -1;
    chkAddLabel.Checked := RulesManager.Rules[selected].AddLabel <> '';
    edAddLabel.Text := RulesManager.Rules[selected].AddLabel;
    Application.ProcessMessages;
    FRuleChanged := True;

  end
  else begin
    HideRuleEditingFields();
  end;
end;

procedure TRulesForm.DeleteRule(rulenum: integer);
begin
  RulesManager.Rules.Delete(rulenum);
  // list box
  listRules.Items.Delete(rulenum);
  if rulenum > listRules.Items.Count-1 then
    listRules.ItemIndex := listRules.Items.Count-1
  else
    listRules.ItemIndex := rulenum;
  ShowRule(listRules.ItemIndex);
end;



procedure TRulesForm.EnableRuleButtons;
begin
  if FRuleChanged then
  begin
    btnSaveRules.Enabled := True;
    btnCancelRule.Enabled := True;
  end;
end;

procedure TRulesForm.FillRulesAccountsDropdown(const Accounts : TAccounts);
var
  num,save : integer;
begin
  // fill rules account dropdown
  save := cmbRuleAccount.ItemIndex;
  cmbRuleAccount.Items.Text := Translate('All Accounts');
  for num := 0 to Accounts.Count-1 do
    cmbRuleAccount.Items.Add(Accounts[num].Name);
  cmbRuleAccount.ItemIndex := save;
end;


procedure TRulesForm.FormCreate(Sender: TObject);
begin
  inherited;
  FPendingAccountChanges := false;
end;

procedure TRulesForm.FormShow(Sender: TObject);
begin
  if (FPendingAccountChanges) then begin
    FillRulesAccountsDropdown(Accounts);
    FPendingAccountChanges := false;
  end;

  CategoryPanelGroup1.HeaderFont.Assign(Options.GlobalFont);
  CategoryPanelGroup1.HeaderFont.Style := CategoryPanelGroup1.HeaderFont.Style + [fsBold];
  CategoryPanelGroup1.HeaderFont.Size := Options.GlobalFont.Size;

  // the below lines will force an update of the colorbox so we can rename the fonts
  colRuleTrayColor.Style := colRuleTrayColor.Style - [cbCustomColors];
  colRuleTrayColor.Style := colRuleTrayColor.Style + [cbCustomColors];

  inherited;
end;

procedure TRulesForm.btnEdRuleWavClick(Sender: TObject);
var
  dlgOpen : TOpenDialog;
begin
  dlgOpen := TOpenDialog.Create(nil);
  try
    dlgOpen.InitialDir := ExtractFileDir(edRuleWav.Text);
    if dlgOpen.InitialDir='' then
       dlgOpen.InitialDir := ExtractFilePath(Application.ExeName)+'Sounds';
    dlgOpen.Filter := Translate('WAV files')+' (*.wav)|*.WAV';
    if dlgOpen.Execute then
    begin
      edRuleWav.Text := dlgOpen.FileName;
    end;
  finally
    dlgOpen.Free;
  end;
end;


procedure TRulesForm.btnRuleSoundTestClick(Sender: TObject);
begin
  PlayWav(edRuleWav.Text);
end;



procedure TRulesForm.MoveRule(old, new: integer);
begin
  if (old <> new) and (Screen.Cursor <> crHourGlass) and
     (new >= 0) and (new <= listRules.Count-1) and
     (old >= 0) and (old <= listRules.Count-1) then
  begin
    Screen.Cursor := crHourGlass;
    try
      // move
      RulesManager.Rules.Move(old,new);
      listRules.Items.Move(old,new);
      // select
      listRules.ItemIndex := new;
      // show change
      listRulesClick(listRules);
      FRuleChanged := True;
      EnableRuleButtons;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

function TRulesForm.AddRule(rulename: string): TRuleItem;
begin
  // add to rules
  Result := RulesManager.Rules.CreateAndAdd;
  with Result do
  begin
    Name := rulename+' '+IntToStr(RulesManager.Rules.Count);
    Enabled := True;
    New := False;
    Account := 0;
    Operator := roAny;
    Wav := '';
    Delete := False;
    Ignore := False;
    EXE := '';
    Important := False;
    Spam := False;
    TrayColor := -1;
    Protect := False;
    Log := Options.LogRules;
    AddLabel := '';
  end;
  // add to listbox
  listRules.Items.Add(RulesManager.Rules[RulesManager.Rules.Count-1].Name);
  listRules.Checked[RulesManager.Rules.Count-1] := True;
end;


procedure TRulesForm.btnHelpRules1Click(Sender: TObject);
begin
  HtmlHelp(0, HelpFileName+'::/rules.htm', HH_DISPLAY_TOPIC, 0);
end;

procedure TRulesForm.listRulesKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  ShowRule(listRules.ItemIndex);
end;

procedure TRulesForm.listRulesDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  save : integer;
  CursorPos: TPoint;
begin
  Accept := (Sender = Source);
  // bit of a hack to prevent false dragging
  if GetKeyState(VK_RBUTTON) >= 0 then
  begin
    save := listRules.ItemIndex;
    (Sender as TControl).EndDrag(False);
    listRules.ItemIndex := save;
    Exit;
  end;

  // scroll
  if (Y < 10) or (Y > listRules.Height-10) then
  begin
    GetCursorPos(CursorPos);
    CursorPos := listRules.ScreenToClient(CursorPos);
    while (CursorPos.X = X) and (CursorPos.Y = Y) do
    begin
      if GetAsyncKeyState(VK_RBUTTON) >= 0 then Exit;
      if (Y < 10) then
        SendMessage(listRules.Handle,WM_VSCROLL,SB_LINEUP,0)
      else
        SendMessage(listRules.Handle,WM_VSCROLL,SB_LINEDOWN,0);
      //Application.ProcessMessages;
      Sleep(50);
      GetCursorPos(CursorPos);
      CursorPos := listRules.ScreenToClient(CursorPos);
    end;
  end;
end;

procedure TRulesForm.listRulesDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  new,old : integer;
begin
  // get old/new
  new := (Sender as TCheckListBox).ItemAtPos(Point(X,Y),True);
  if new < 0 then new := (Sender as TCheckListBox).Count-1;
  old := (Sender as TCheckListBox).ItemIndex;
  MoveRule(old,new);
end;

procedure TRulesForm.listRulesMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 if (Button = mbRight) and (Screen.Cursor <> crHourGlass) and
    (GetKeyState(VK_RBUTTON) < 0) then
 begin
   listRules.ItemIndex := listRules.ItemAtPos(Point(X,Y),True);
   (Sender as TControl).BeginDrag(False,12);
 end;
end;

procedure TRulesForm.listRulesClickCheck(Sender: TObject);
begin
  if listRules.ItemIndex > -1 then
  begin
    RulesManager.Rules[listRules.ItemIndex].Enabled := listRules.Checked[listRules.ItemIndex];
    chkRuleEnabled.Checked := RulesManager.Rules[listRules.ItemIndex].Enabled;
    FRuleChanged := True;
    EnableRuleButtons;
  end;
end;

procedure TRulesForm.listRulesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then actRuleDelete.Execute;
end;

procedure TRulesForm.chkRuleProtectClick(Sender: TObject);
begin
  EnableRuleButtons;
  if listRules.ItemIndex > -1 then
    RulesManager.Rules[listRules.ItemIndex].Protect := chkRuleProtect.Checked;
end;


procedure TRulesForm.chkRuleSpamClick(Sender: TObject);
begin
  EnableRuleButtons;
  if listRules.ItemIndex > -1 then
    RulesManager.Rules[listRules.ItemIndex].Spam := chkRuleSpam.Checked;
end;



procedure TRulesForm.actRulesImportExecute(Sender: TObject);
var
  OpenDialog : TOpenDialog;
  Ini : TIniFile;
begin
  OpenDialog := TOpenDialog.Create(nil);
  try
    OpenDialog.Filter := Translate('INI Files')+' (*.ini)|*.ini';
    if OpenDialog.Execute then
    begin
      Ini := TIniFile.Create(OpenDialog.FileName);
      try
        RulesManager.Rules.ImportRules(Ini);
        RefreshRulesList();
        EnableSaveRulesButton();
      finally
        Ini.Free;
      end;
    end;
  finally
    OpenDialog.Free;
  end;
end;

procedure TRulesForm.AccountsChanged();
begin
  FPendingAccountChanges := true;
end;

//------------------------------------------------------------------------------
// RefreshRulesList
//
// This method should be called after loading/reloading rules from the INI file.
// It will clear listRules listbox on the UI for this form and repopulate it
// based on the Rules data object.
//------------------------------------------------------------------------------
procedure TRulesForm.RefreshRulesList();
var
  i : integer;
  rule : TRuleItem;
begin
  listRules.Items.BeginUpdate;
  try
    listRules.Clear;
    for i := 0 to RulesManager.Rules.Count-1 do
    begin
      rule := RulesManager.Rules.Items[i];
      listRules.Items.Add(rule.Name);
      listRules.Checked[i] := rule.Enabled;
    end;
  finally
    listRules.Items.EndUpdate;
  end;
end;

procedure TRulesForm.EnableSaveRulesButton(enable : boolean = true);
begin
frmPopUMain.RulesForm.btnSaveRules.Enabled := enable;
  frmPopUMain.RulesForm.btnCancelRule.Enabled := enable;
end;

procedure TRulesForm.CreateWnd;
begin
  inherited;
  DragAcceptFiles(Handle, True);
end;

procedure TRulesForm.DestroyWnd;
begin
  DragAcceptFiles(Handle, False);
  inherited;
end;

procedure TRulesForm.WMDropFiles(var msg: TWMDROPFILES);
begin
  DragFinish(msg.Drop);
end;

end.
