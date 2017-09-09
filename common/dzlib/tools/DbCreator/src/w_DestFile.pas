unit w_DestFile;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  JvExMask,
  JvToolEdit,
  w_ExportFormat;

type
  Tf_DestFile = class(TForm)
  private
  public
    procedure SetExportFormats(_Formats: TExportFormatSet);
    function areFilenamesSet: boolean;
  end;

implementation

{$R *.DFM}

{ Tf_DestFile }

function Tf_DestFile.areFilenamesSet: boolean;
begin
  Result := false;
end;

procedure Tf_DestFile.SetExportFormats(_Formats: TExportFormatSet);
var
  i: integer;
  fe_OutFile: TJvFilenameEdit;
  l_Prompt: TLabel;
  cmb_HistoryString: TComboBox;
  btn_Browse: TButton;
  ef: TExportFormat;
  TopPos: integer;
begin
  for i := self.ComponentCount - 1 downto 0 do
    self.Components[i].Free;

  TopPos := 0;
  for ef := low(TExportFormat) to high(TExportFormat) do begin
    if not (ef in _Formats) then
      Continue;
    l_Prompt := TLabel.Create(Self);
    l_Prompt.Name := Format('Label%d', [Ord(ef)]);
    l_Prompt.Parent := self;
    l_Prompt.Left := 0;
    l_Prompt.Top := TopPos;
    l_Prompt.Caption := EXPORT_FORMAT_NAMES[ef];
    Inc(TopPos, 20);
  end;
  exit;

  fe_OutFile := TJvFilenameEdit.Create(Self);
  l_Prompt := TLabel.Create(Self);
  cmb_HistoryString := TComboBox.Create(Self);
  btn_Browse := TButton.Create(Self);
  with fe_OutFile do begin
    Name := 'fe_OutFile';
    Parent := Self;
    Left := 0;
    Top := 0;
    Width := 273;
    Height := 37;
    Align := alTop;
    Constraints.MaxHeight := 37;
    Constraints.MinHeight := 37;
    Constraints.MinWidth := 172;
    TabOrder := 0;
    DialogTitle := 'Export File';
//    DialogType := dtSaveDialog;
    FilterIndex := 0;
    Filter := '';
//    Prompt := 'Export File';
//    MaxHistory := 10;
  end;
  with l_Prompt do begin
    Name := 'l_Prompt';
    Parent := fe_OutFile;
    Left := 0;
    Top := 0;
    Width := 49;
    Height := 13;
    Caption := 'Export File';
  end;
  with cmb_HistoryString do begin
    Name := 'cmb_HistoryString';
    Parent := fe_OutFile;
    Left := 0;
    Top := 16;
    Width := 249;
    Height := 21;
    Anchors := [akLeft, akTop, akRight];
    ItemHeight := 13;
    TabOrder := 0;
  end;
  with btn_Browse do begin
    Name := 'btn_Browse';
    Parent := fe_OutFile;
    Left := 252;
    Top := 16;
    Width := 21;
    Height := 21;
    Anchors := [akTop, akRight];
    Caption := '...';
    TabOrder := 1;
  end;

end;

end.

