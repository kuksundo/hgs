unit dtpPlaceHolder;

{$i simdesign.inc}

interface

uses
  Classes, dtpEffectShape;

type

  TdtpPlaceHolder = class(TdtpGroupShape)
  public
    constructor Create; override;
  end;

implementation

uses
  dtpShape, dtpPolygonShape, dtpTextShape, dtpMemoShape, dtpDefaults;

{ TdtpPlaceHolder }

constructor TdtpPlaceHolder.Create;
var
  AFrame: TdtpRectangleShape;
  {$ifndef usePolygonText}
  AMemo: TdtpMemoShape;
  {$else}
  AMemo: TdtpPolygonMemo;
  {$endif}
begin
  inherited;
  // Create a frame and a memo that are for the placeholder function
  AFrame := TdtpRectangleShape.Create;
  AFrame.OutlineColor := cDefaultSnapFrameColor;
  AFrame.OutlineWidth := cDefaultSnapFrameWidth;
  AFrame.FillColor    := cDefaultSnapFillColor;
  AFrame.Anchors := [saLeftLock, saTopLock, saSizeXprop, saSizeYProp];
  AFrame.DocWidth  := 40;
  AFrame.DocHeight := 30;
  AFrame.AutoCreated := True;
  ShapeAdd(AFrame);

  {$ifndef usePolygonText}
  AMemo := TdtpMemoShape.Create;
  {$else}
  AMemo := TdtpPolygonMemo.Create;
  {$endif}

  AMemo.FontHeightPts := 12;
  {$ifndef usePolygonText}
  AMemo.Lines.Text    := cDefaultSnapMemoText;
  {$else}
  AMemo.Text          := cDefaultSnapMemoText;
  {$endif}
  AMemo.Alignment     := taCenter;
  AMemo.AutoSize      := False;
  AMemo.VertAlign     := alMiddle;
  AMemo.AllowEdit     := False;
  AMemo.Anchors := [saLeftLock, saTopLock, saSizeXprop, saSizeYProp];
  AMemo.SetDocBounds(2, 2, AFrame.DocWidth - 4, AFrame.DocHeight - 4);
  AMemo.AutoCreated := True;
  ShapeAdd(AMemo);

  // This command will group the controls and fit our bounds just around
  FindFittingBounds;
end;

end.
