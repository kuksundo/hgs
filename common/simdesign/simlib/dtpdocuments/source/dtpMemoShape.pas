{
  Unit dtpMemoShape

  TdtpMemoShape is a TdtpTextShape descendant that can be used to show multi-line
  of text. It can be edited in-document.

  Note: AutoSize for a TdtpMemoShape works only vertically, as opposed to AutoSize
  for the TdtpTextShape which works horizontally.

  Project: DTP-Engine

  Creation Date: 09-11-2003 (NH)
  Version: 1.0
  Contributor: JohnF (JF)

  Modifications:
  - 15Feb2006: Added TdtpPolygonMemo, a polygon-drawn memo shape

  Copyright (c) 2003 - 2006 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit dtpMemoShape;

{$i simdesign.inc}

interface

uses
  Classes, Windows, SysUtils, dtpTextShape, dtpPolygonText, dtpShape, dtpGraphics, Math,
  NativeXmlOld, sdWideStrings, dtpTruetypeFonts, dtpDefaults;

type

  {$ifndef usePolygonText}

  TdtpMemoShape = class(TdtpTextShape)
  private
    FLines: TsdWideStringList;
    procedure LinesChange(Sender: TObject);
  protected
    procedure SetText(const Value: widestring); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure LoadFromXml(ANode: TXmlNodeOld); override;
    property Lines: TsdWidestringList read FLines;
    // When AutoSize if False, VertAlign controls the vertical alignment of the
    // text in the shape. VertAlign = alTop will align the text with the top
    // of the shape, alMiddle will center it vertically and alBottom will align
    // it along the bottom.
    property VertAlign;
    // Set WordWrap to True (default) to make the control wrap the lines (move
    // portions to the next line) if they do not fit in the width.
    property WordWrap;
    // LineHeight (added by JF)
    // Suggested values:
    // Small:   0.80 - less than this will have ascenders and desenders overlapping
    // Default: 1.00
    // Large:   1.20
    property LineHeight;
  end;

  {$endif}

  TdtpPolygonMemo = class(TdtpPolygonText)
  protected
    function GetLineHeight: single; override;
  public
    constructor Create; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    // When AutoSize if False, VertAlign controls the vertical alignment of the
    // text in the shape. VertAlign = alTop will align the text with the top
    // of the shape, alMiddle will center it vertically and alBottom will align
    // it along the bottom.
    property VertAlign;
    // Set WordWrap to True (default) to make the control wrap the lines (move
    // portions to the next line) if they do not fit in the width.
    property WordWrap;
    // LineHeight (added by JF)
    // Suggested values:
    // Small   0.80 - less than this will have ascenders and desenders overlapping
    // Default 1.00
    // Large   1.20
    property LineHeight;
  end;

implementation

uses
  dtpCommand, dtpDocument;

{ TdtpMemoShape }

{$ifndef usePolygonText}

constructor TdtpMemoShape.Create;
begin
  inherited;
  FLines := TsdWidestringList.Create;
  FLines.OnChange := LinesChange;
  // Defaults
  FWordWrap := False;
  FMultiLine := True;
  FAllowFontSizing := False;
end;

destructor TdtpMemoShape.Destroy;
begin
  FreeAndNil(FLines);
  inherited;
end;

procedure TdtpMemoShape.KeyDown(var Key: Word; Shift: TShiftState);
begin
  case Key of
  VK_EXECUTE, VK_F2, VK_TAB:
    TdtpDocument(Document).DoEditClose(True);
  VK_ESCAPE, VK_CANCEL:
    TdtpDocument(Document).DoEditClose(False);
  else
    if assigned(LineEdit) then LineEdit.ProcessKeyDown(Key, Shift);
  end;
end;

procedure TdtpMemoShape.LinesChange(Sender: TObject);
// User changed the Lines property .. so we must update the Text property accordingly
begin
  Text := FLines.Text;
end;

procedure TdtpMemoShape.LoadFromXml(ANode: TXmlNodeOld);
begin
  inherited;

  FLines.OnChange := nil;
  FLines.Text := Text;
  FLines.OnChange := LinesChange;
end;

procedure TdtpMemoShape.SetText(const Value: widestring);
begin
  // Keep a synced copy but make sure not to come into update endless loop
  FLines.OnChange := nil;
  FLines.Text := Value;
  FLines.OnChange := LinesChange;
  inherited;
end;

{$endif}

{ TdtpPolygonMemo }


constructor TdtpPolygonMemo.Create;
begin
  inherited;
  // Defaults
  FWordWrap := False;
  FMultiLine := True;
  FAllowFontSizing := False;
  MustCache := False;
end;

procedure TdtpPolygonMemo.KeyDown(var Key: Word; Shift: TShiftState);
begin
  case Key of
  VK_EXECUTE, VK_F2, VK_TAB:
    TdtpDocument(Document).DoEditClose(True);
  VK_ESCAPE, VK_CANCEL:
    TdtpDocument(Document).DoEditClose(False);
  else
    if assigned(LineEdit) then LineEdit.ProcessKeyDown(Key, Shift);
  end;
end;

function TdtpPolygonMemo.GetLineHeight: single; 
// added by JF
begin
  Result := LineHeight;
  if CheckFont then
  begin
    // added by J.F. Apr 2011,
    // fixes descenders cut off with one line and LineHeight < 1 and text rotated
    if SpanCount < 2 then
      Result := FFont.GetLineHeight(FontHeight)
    else
      Result := FFont.GetLineHeight(FontHeight) * LineHeight;
  end;
end;

initialization
  // Register ourselves
  {$ifndef UsePolygonText}
  RegisterShapeClass(TdtpMemoShape);
  {$else}
  RegisterShapeClass(TdtpPolygonMemo,'TdtpMemoShape');
  {$endif}
  RegisterShapeClass(TdtpPolygonMemo);

end.
