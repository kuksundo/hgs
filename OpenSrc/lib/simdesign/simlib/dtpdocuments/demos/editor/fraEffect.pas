unit fraEffect;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fraEffectBase, StdCtrls, ExtCtrls, CheckLst, dtpEffectShape, fraInlay;

type
  TfrEffect = class(TfrEffectBase)
    clbInstalled: TCheckListBox;
    Label1: TLabel;
    lbAvailable: TListBox;
    Label2: TLabel;
    btnAddEffect: TButton;
    btnRemoveEffect: TButton;
    btnEffectUp: TButton;
    btnEffectDn: TButton;
    pnlEffect: TPanel;
    procedure clbInstalledClick(Sender: TObject);
    procedure btnAddEffectClick(Sender: TObject);
    procedure btnRemoveEffectClick(Sender: TObject);
    procedure clbInstalledClickCheck(Sender: TObject);
    procedure btnEffectUpClick(Sender: TObject);
    procedure btnEffectDnClick(Sender: TObject);
  private
    FEffectIndex: integer;
    FShape: TdtpEffectShape;  // Current parent effect shape
    FInlayFrame: TfrInlay;    // Current effect inlay frame
    function GetEffects(Index: integer): TdtpEffect;
    function GetEffectCount: integer;
    function GetEffect: TdtpEffect; // List with effect classes in use
  protected
    property Effect: TdtpEffect read GetEffect;
    function GetInlayClassForEffect(AEffect: TdtpEffect): TfrInlayClass;
    procedure ShapesToFrame; override;
    procedure UpdateInstalledList;
    procedure UpdateAvailableList;
    procedure UpdateFrame;
  public
    constructor Create(AOwner: TComponent); override;
    property EffectCount: integer read GetEffectCount;
    property Effects[Index: integer]: TdtpEffect read GetEffects;
  end;

var
  frEffect: TfrEffect;

implementation

{$R *.DFM}

uses
  dtpColorEffects, fraBrightContrInlay, fraHslAdjustInlay, dtpShadowEffects,
  fraShadowInlay, dtpFrameEffects, fraFrameInlay, dtpGradientEffects,
  fraGradientInlay, dtpTextureEffects, fraTextureInlay, fraSepiaInlay;

{ TfrEffect }

procedure TfrEffect.btnAddEffectClick(Sender: TObject);
// Add the selected effect from available list to the shape(s)
var
  AClass: TdtpEffectClass;
begin
  if lbAvailable.ItemIndex < 0 then begin
    ShowMessage('Select an effect in available list first');
    exit;
  end;
  // Get effect class
  AClass := TdtpEffectClass(lbAvailable.Items.Objects[lbAvailable.ItemIndex]);
  if not assigned(AClass) then exit;
  // Insert this effect
  if assigned(FShape) then
    FShape.EffectAddClass(AClass);
end;

procedure TfrEffect.btnEffectDnClick(Sender: TObject);
begin
  if assigned(FShape) then
    if clbInstalled.ItemIndex < clbInstalled.Items.Count - 1 then begin
      FShape.EffectExchange(clbInstalled.ItemIndex, clbInstalled.ItemIndex + 1);
      clbInstalled.ItemIndex := clbInstalled.ItemIndex + 1;
      clbInstalledClick(nil);
    end;
end;

procedure TfrEffect.btnEffectUpClick(Sender: TObject);
begin
  if assigned(FShape) then
    if clbInstalled.ItemIndex > 0 then begin
      FShape.EffectExchange(clbInstalled.ItemIndex, clbInstalled.ItemIndex - 1);
      clbInstalled.ItemIndex := clbInstalled.ItemIndex - 1;
      clbInstalledClick(nil);
    end;
end;

procedure TfrEffect.btnRemoveEffectClick(Sender: TObject);
begin
  if assigned(FShape) then
    FShape.EffectDelete(clbInstalled.ItemIndex);
end;

procedure TfrEffect.clbInstalledClick(Sender: TObject);
begin
  if FIsUpdating then exit;
  // Store effect index
  FEffectIndex := clbInstalled.ItemIndex;
  // And update frame
  UpdateFrame;
end;

procedure TfrEffect.clbInstalledClickCheck(Sender: TObject);
var
  i: integer;
begin
  if not assigned(FShape) then exit;
  with clbInstalled do
    for i := 0 to Items.Count - 1 do
      if assigned(FShape.Effects[i]) then
        FShape.Effects[i].Enabled := Checked[i];
end;

constructor TfrEffect.Create(AOwner: TComponent);
begin
  inherited;
  UpdateAvailableList;
end;

function TfrEffect.GetEffect: TdtpEffect;
begin
  Result := nil;
  if assigned(FShape) then
    Result := FShape.Effects[clbInstalled.ItemIndex];
end;

function TfrEffect.GetEffectCount: integer;
begin
  Result := 0;
  if assigned(FShape) then Result := FShape.EffectCount;
end;

function TfrEffect.GetEffects(Index: integer): TdtpEffect;
begin
  Result := nil;
  if assigned(FShape) then
    Result := FShape.Effects[Index];
end;

function TfrEffect.GetInlayClassForEffect(
  AEffect: TdtpEffect): TfrInlayClass;
begin
  Result := TfrInlay;
  if AEffect is TdtpBrightContrEffect then begin
    Result := TfrBrightContrInlay;
    exit;
  end;
  if AEffect is TdtpHslAdjustEffect then begin
    Result := TfrHslAdjustInlay;
    exit;
  end;
  if AEffect is TdtpShadowEffect then begin
    Result := TfrShadowInlay;
    exit;
  end;
  if AEffect is TdtpFrameEffect then begin
    Result := TfrFrameInlay;
    exit;
  end;
  if AEffect is TdtpGradientEffect then begin
    Result := TfrGradientInlay;
    exit;
  end;
  if AEffect is TdtpTextureEffect then begin
    Result := TfrTextureInlay;
    exit;
  end;
  if AEffect is TdtpSepiaEffect then begin
    Result := TfrSepiaInlay;
    exit;
  end;
end;

procedure TfrEffect.ShapesToFrame;
// Here we fill the dual list boxes
begin
  inherited;
  FShape := nil;
  if ShapeCount = 0 then exit;
  if Shapes[0] is TdtpEffectShape then FShape := TdtpEffectShape(Shapes[0]);
  UpdateInstalledList;
  // Title
  if ShapeCount = 1 then
    lblTitle.Caption := 'Effects'
  else
    lblTitle.Caption := 'Effects (focused only)';
  // Make sure that after a "changed" the values get updated on the inlay frame
  UpdateFrame;
end;

procedure TfrEffect.UpdateAvailableList;
// Create a list of available effects
var
  AEffects: TStringList;
begin
  AEffects := TStringList.Create;
  try
    GetAvailableEffectNames(AEffects);
    lbAvailable.Items.Assign(AEffects);
  finally
    AEffects.Free;
  end;
end;

procedure TfrEffect.UpdateFrame;
var
  AInlayClass: TfrInlayClass;
begin
  AInlayClass := GetInlayClassForEffect(Effect);
  if not assigned(FInlayFrame) or (AInlayClass <> FInlayFrame.ClassType) then begin
    // Remove old and insert new frame
    FreeAndNil(FInlayFrame);
    if assigned(AInlayClass) then
      FInlayFrame := AInlayClass.Create(Self);
  end;
  if assigned(FInlayFrame) then begin
    // This calls "EffectToFrame" through setter
    FInlayFrame.Effect := Effect;
    FInlayFrame.Parent := pnlEffect;
  end;
end;

procedure TfrEffect.UpdateInstalledList;
var
  i: integer;
begin
  // Copy to checklistbox
  for i := 0 to EffectCount - 1 do begin
    if clbInstalled.Items.Count <= i then
      clbInstalled.Items.Add(' ');
    // Set the name, and associated effect class
    clbInstalled.Items[i] := Effects[i].EffectName;
    clbInstalled.Items.Objects[i] := TObject(Effects[i]);
    // Checked depends on first shape's enabled state
    if assigned(FShape) then
      clbInstalled.Checked[i] := FShape.Effects[i].Enabled
  end;
  // Remove excess items
  while clbInstalled.Items.Count > EffectCount do
    clbInstalled.Items.Delete(clbInstalled.Items.Count - 1);
  // Set to last index
  if (FEffectIndex >= 0) and (FEffectIndex < EffectCount) then
    clbInstalled.ItemIndex := FEffectIndex;
end;

end.
