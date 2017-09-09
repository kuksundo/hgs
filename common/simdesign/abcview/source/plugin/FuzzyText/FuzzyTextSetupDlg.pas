unit FuzzyTextSetupDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, Aligrid, RXSpin, Buttons, IniFiles;

type
  TfrmFuzzyText = class(TForm)
    GroupBox1: TGroupBox;
    rbIndexBackgr: TRadioButton;
    rbIndexFilter: TRadioButton;
    GroupBox2: TGroupBox;
    rbProcessAll: TRadioButton;
    rbProcessOnly: TRadioButton;
    rbProcessExcept: TRadioButton;
    edProcessOnly: TEdit;
    edProcessExcept: TEdit;
    GroupBox3: TGroupBox;
    rbDiffNone: TRadioButton;
    rbDiffAsLimit: TRadioButton;
    rbDiffSelect: TRadioButton;
    seDiffLimit: TRxSpinEdit;
    GroupBox4: TGroupBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    sgTolerance: TStringAlignGrid;
  public
    { Public declarations }
    procedure FormToSettings(AInifile: string);
    procedure SettingsToForm(AInifile: string);
  end;

var
  frmFuzzyText: TfrmFuzzyText;

implementation

uses
  FuzzyTexts;

{$R *.DFM}

{ TfrmFuzzyText }

procedure TfrmFuzzyText.FormCreate(Sender: TObject);
begin
  sgTolerance := TStringAlignGrid.Create(Self);
  with sgTolerance do
  begin
    Parent := Groupbox4;
    Left := 8;
    Top := 16;
    Width := 377;
    Height := 41;
    ColCount := 8;
    DefaultColWidth := 45;
    DefaultRowHeight := 18;
    FixedCols := 0;
    RowCount := 2;
    Options := [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goThumbTracking];
    ScrollBars := ssNone;
    TabOrder := 0;
  end;

end;

procedure TfrmFuzzyText.FormToSettings(AInifile: string);
var
  i: integer;
begin
  if rbIndexBackgr.Checked then FIndexMethod := cftIndexBackgr;
  if rbIndexFilter.Checked then FIndexMethod := cftIndexFilter;
  if rbDiffNone.Checked    then FFileDiffMethod := cftDiffNone;
  if rbDiffAsLimit.Checked then FFileDiffMethod := cftDiffAsLimit;
  if rbDiffSelect.Checked  then FFileDiffMethod := cftDiffSelect;
  FDiffLimit := round(seDiffLimit.Value);
  if rbProcessAll.Checked    then FProcessMethod := cftProcessAll;
  if rbProcessOnly.Checked   then FProcessMethod := cftProcessOnly;
  if rbProcessExcept.Checked then FProcessMethod := cftProcessExcept;
  FProcessOnly := edProcessOnly.Text;
  FProcessExcept := edProcessExcept.Text;
  for i := 0 to 7 do
    try
      FTolLimits[i] := StrToInt(sgTolerance.Cells[i, 1]);
    except
    end;
end;

procedure TfrmFuzzyText.SettingsToForm(AInifile: string);
var
  i: integer;
begin
  rbIndexBackgr.Checked := FIndexMethod = cftIndexBackgr;
  rbIndexFilter.Checked := FIndexMethod = cftIndexFilter;
  rbDiffNone.Checked    := FFileDiffMethod = cftDiffNone;
  rbDiffAsLimit.Checked := FFileDiffMethod = cftDiffAsLimit;
  rbDiffSelect.Checked  := FFileDiffMethod = cftDiffSelect;
  seDiffLimit.Value := FDiffLimit;
  rbProcessAll.Checked    := FProcessMethod = cftProcessAll;
  rbProcessOnly.Checked   := FProcessMethod = cftProcessOnly;
  rbProcessExcept.Checked := FProcessMethod = cftProcessExcept;
  edProcessOnly.Text := FProcessOnly;
  edProcessExcept.Text := FProcessExcept;
  for i := 0 to 7 do
  begin
    sgTolerance.Cells[i, 0] := Format('Level%d', [i + 1]);
    sgTolerance.Cells[i, 1] := IntToStr(FTolLimits[i]);
  end
end;

end.
