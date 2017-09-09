unit frmAnchors;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, dtpShape;

type
  TdlgAnchors = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    GroupBox1: TGroupBox;
    chbPosXprop: TCheckBox;
    chbPosYprop: TCheckBox;
    chbSizeXprop: TCheckBox;
    chbSizeYprop: TCheckBox;
    GroupBox2: TGroupBox;
    chbTopLock: TCheckBox;
    chbLeftLock: TCheckBox;
    chbRightLock: TCheckBox;
    chbBottomLock: TCheckBox;
    chbOverrideDefault: TCheckBox;
    procedure BusinessRules(Sender: TObject);
  private
    FUpdating: boolean;
    function GetAnchors: TShapeAnchors;
    procedure SetAnchors(const Value: TShapeAnchors);
  public
    property Anchors: TShapeAnchors read GetAnchors write SetAnchors;
  end;

var
  dlgAnchors: TdlgAnchors;

implementation

{$R *.DFM}

{ TdlgAnchors }

{ TdlgAnchors }

procedure TdlgAnchors.BusinessRules(Sender: TObject);
var
  ACheck: TCheckBox;
  IsOverride: boolean;
begin
  if FUpdating then exit;
  FUpdating := True;
  IsOverride := chbOverrideDefault.Checked;

  // Visibility
  chbPosXprop.Enabled := IsOverride;
  chbPosYprop.Enabled := IsOverride;
  chbSizeXprop.Enabled := IsOverride;
  chbSizeYprop.Enabled := IsOverride;
  chbLeftLock.Enabled := IsOverride;
  chbTopLock.Enabled := IsOverride;
  chbRightLock.Enabled := IsOverride;
  chbBottomLock.Enabled := IsOverride;

  // Some checkbox settings rule out others
  ACheck := TCheckBox(Sender);
  if assigned(ACheck) and ACheck.Checked then begin
    // Rules when checking
    if ACheck = chbPosXprop then begin
      chbLeftLock.Checked := False;
      chbRightLock.Checked := False;
    end;
    if ACheck = chbPosYprop then begin
      chbTopLock.Checked := False;
      chbBottomLock.Checked := False;
    end;
    if ACheck = chbSizeXprop then
      if chbLeftLock.Checked and chbRightLock.Checked then
        chbRightLock.Checked := False;
    if ACheck = chbSizeYprop then
      if chbTopLock.Checked and chbBottomLock.Checked then
        chbBottomLock.Checked := False;
    if (ACheck = chbLeftLock) or (ACheck = chbRightLock) then begin
      chbPosXprop.Checked := False;
      if chbLeftLock.Checked and chbRightLock.Checked then
        chbSizeXprop.Checked := False;
    end;
    if (ACheck = chbTopLock) or (ACheck = chbBottomLock) then begin
      chbPosYprop.Checked := False;
      if chbTopLock.Checked and chbBottomLock.Checked then
        chbSizeYprop.Checked := False;
    end;
  end;
  if assigned(ACheck) and not ACheck.Checked then begin
    // Rules when unchecking
    if ACheck = chbPosXprop then
      if not chbRightLock.Checked then
        chbLeftLock.Checked := True;
    if ACheck = chbPosYprop then
      if not chbBottomLock.Checked then
        chbTopLock.Checked := True;
    if ACheck = chbLeftLock then
      if not chbPosXprop.Checked then
        chbRightLock.Checked := True;
    if ACheck = chbRightLock then
      if not chbPosXprop.Checked then
        chbLeftLock.Checked := True;
    if ACheck = chbTopLock then
      if not chbPosYprop.Checked then
        chbBottomLock.Checked := True;
    if ACheck = chbBottomLock then
      if not chbPosYprop.Checked then
        chbTopLock.Checked := True;
  end;
  // General cases of emptyness
  if not chbPosXprop.Checked and not chbRightLock.Checked then
    chbLeftLock.Checked := True;
  if not chbPosYprop.Checked and not chbBottomLock.Checked then
    chbTopLock.Checked := True;
  // General cases of fullness
  if chbLeftLock.Checked or chbRightLock.Checked then
    chbPosXprop.Checked := False;
  if chbLeftLock.Checked and chbRightLock.Checked then
    chbSizeXprop.Checked := False;
  if chbTopLock.Checked or chbBottomLock.Checked then
    chbPosYprop.Checked := False;
  if chbTopLock.Checked and chbBottomLock.Checked then
    chbSizeYprop.Checked := False;
  FUpdating := False;
end;

function TdlgAnchors.GetAnchors: TShapeAnchors;
begin
  Result := [];
  if not chbOverrideDefault.Checked then Result := [saDefault];
  if chbPosXprop.Checked   then Result := Result + [saPosXprop];
  if chbPosYprop.Checked   then Result := Result + [saPosYprop];
  if chbSizeXprop.Checked  then Result := Result + [saSizeXprop];
  if chbSizeYprop.Checked  then Result := Result + [saSizeYprop];
  if chbLeftLock.Checked   then Result := Result + [saLeftLock];
  if chbTopLock.Checked    then Result := Result + [saTopLock];
  if chbRightLock.Checked  then Result := Result + [saRightLock];
  if chbBottomLock.Checked then Result := Result + [saBottomLock];
end;

procedure TdlgAnchors.SetAnchors(const Value: TShapeAnchors);
begin
  FUpdating := True;
  chbOverrideDefault.Checked := not (saDefault in Value);
  chbPosXprop.Checked := saPosXprop in Value;
  chbPosYprop.Checked := saPosYprop in Value;
  chbSizeXprop.Checked := saSizeXprop in Value;
  chbSizeYprop.Checked := saSizeYprop in Value;
  chbLeftLock.Checked := saLeftLock in Value;
  chbTopLock.Checked := saTopLock in Value;
  chbRightLock.Checked := saRightLock in Value;
  chbBottomLock.Checked := saBottomLock in Value;
  FUpdating := False;
  BusinessRules(nil);
end;

end.
