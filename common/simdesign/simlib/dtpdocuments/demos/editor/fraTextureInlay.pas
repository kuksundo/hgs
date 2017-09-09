unit fraTextureInlay;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fraInlay, StdCtrls, ExtCtrls, dtpGradientEffects, dtpTextureEffects,
  ExtDlgs, dtpRasterFormats, dtpDefaults;

type
  TfrTextureInlay = class(TfrInlay)
    lbReplace: TLabel;
    Label3: TLabel;
    cbbSource: TComboBox;
    Label7: TLabel;
    edImageName: TEdit;
    btnChange: TButton;
    chbTiled: TCheckBox;
    edTextureDpi: TEdit;
    edOffsetX: TEdit;
    lbOffsetX: TLabel;
    lbOffsetY: TLabel;
    edOffsetY: TEdit;
    lbTextureDpi: TLabel;
    rbRed: TRadioButton;
    rbGreen: TRadioButton;
    rbBlue: TRadioButton;
    rbAlpha: TRadioButton;
    rbAny: TRadioButton;
    procedure rbRedClick(Sender: TObject);
    procedure rbGreenClick(Sender: TObject);
    procedure rbBlueClick(Sender: TObject);
    procedure cbbSourceChange(Sender: TObject);
    procedure btnChangeClick(Sender: TObject);
    procedure edOffsetXExit(Sender: TObject);
    procedure edOffsetYExit(Sender: TObject);
    procedure edTextureDpiExit(Sender: TObject);
    procedure chbTiledClick(Sender: TObject);
    procedure rbAlphaClick(Sender: TObject);
    procedure rbAnyClick(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure EffectToFrame; override;
  public
    { Public declarations }
  end;

var
  frTextureInlay: TfrTextureInlay;

implementation

{$R *.DFM}

{ TfrTextureInlay }

procedure TfrTextureInlay.EffectToFrame;
// Translate the effect properties to frame values
var
  i: integer;
begin
  inherited;
  if Effect is TdtpTextureEffect then with TdtpTextureEffect(Effect) do begin
    rbRed.Checked   := Replace = rtReplaceRed;
    rbGreen.Checked := Replace = rtReplaceGreen;
    rbBlue.Checked  := Replace = rtReplaceBlue;
    rbAlpha.Checked := Replace = rtReplaceAlpha;
    rbAny.Checked   := Replace = rtReplaceAny;
    // Source
    cbbSource.Clear;
    cbbSource.Items.Add('Previous effect');
    cbbSource.Items.Add('Original shape');
    if assigned(Parent) then with Parent do
      for i := 0 to EffectCount - 1 do begin
        if (Effects[i] = Effect) then break;
        cbbSource.Items.Add(Format('Effect %d (%s)', [i + 1, Effects[i].EffectName]));
      end;
    cbbSource.ItemIndex := Source + 2;
    // Filename
    edImageName.Text := Texture.FileName;
    // other controls
    chbTiled.Checked := Tiled;
    lbOffsetX.Visible := Tiled;
    lbOffsetY.Visible := Tiled;
    edOffsetX.Visible := Tiled;
    edOffsetY.Visible := Tiled;
    lbTextureDpi.Visible := Tiled;
    edTextureDpi.Visible := Tiled;
    if Tiled then begin
      edOffsetX.Text := Format(cDefaultMMFormat, [OffsetX]);
      edOffsetY.Text := Format(cDefaultMMFormat, [OffsetY]);
      edTextureDpi.Text := IntToStr(round(RenderDpm * cMMToInch));
    end;
  end;
end;

procedure TfrTextureInlay.rbRedClick(Sender: TObject);
begin
  if FUpdating then exit;
  TdtpTextureEffect(Effect).Replace := rtReplaceRed;
end;

procedure TfrTextureInlay.rbGreenClick(Sender: TObject);
begin
  if FUpdating then exit;
  TdtpTextureEffect(Effect).Replace := rtReplaceGreen;
end;

procedure TfrTextureInlay.rbBlueClick(Sender: TObject);
begin
  if FUpdating then exit;
  TdtpTextureEffect(Effect).Replace := rtReplaceBlue;
end;

procedure TfrTextureInlay.rbAlphaClick(Sender: TObject);
begin
  if FUpdating then exit;
  TdtpTextureEffect(Effect).Replace := rtReplaceAlpha;
end;

procedure TfrTextureInlay.rbAnyClick(Sender: TObject);
begin
  if FUpdating then exit;
  TdtpTextureEffect(Effect).Replace := rtReplaceAny;
end;

procedure TfrTextureInlay.cbbSourceChange(Sender: TObject);
begin
  if FUpdating then exit;
  TdtpTextureEffect(Effect).Source := cbbSource.ItemIndex - 2;
end;

procedure TfrTextureInlay.btnChangeClick(Sender: TObject);
begin
  if FUpdating then exit;
  with TOpenPictureDialog.Create(Application) do begin
    try
      Title := 'Change to another file (choose)';
      Filter := RasterFormatOpenFilter;
      if Execute then
        TdtpTextureEffect(Effect).Texture.LoadFromFile(FileName);
    finally
      Free;
    end;
  end;

end;

procedure TfrTextureInlay.edOffsetXExit(Sender: TObject);
begin
  if FUpdating then exit;
  TdtpTextureEffect(Effect).OffsetX := StrToFloat(edOffsetX.Text);
end;

procedure TfrTextureInlay.edOffsetYExit(Sender: TObject);
begin
  if FUpdating then exit;
  TdtpTextureEffect(Effect).OffsetY := StrToFloat(edOffsetY.Text);
end;

procedure TfrTextureInlay.edTextureDpiExit(Sender: TObject);
begin
  if FUpdating then exit;
  TdtpTextureEffect(Effect).RenderDpm := StrToFloat(edTextureDpi.Text) / cMMToInch;
end;

procedure TfrTextureInlay.chbTiledClick(Sender: TObject);
begin
  if FUpdating then exit;
  TdtpTextureEffect(Effect).Tiled := chbTiled.Checked;
end;

end.
