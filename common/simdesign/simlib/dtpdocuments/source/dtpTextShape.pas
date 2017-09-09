{
  Unit dtpTextShape

  TdtpTextShape is a TdtpShape descendant that can be used to show single-line
  of text. It can be edited in-document. It has a Font.

  Project: DTP-Engine

  Creation Date: 02-08-2003 (NH)
  Version: 1.0

  Modifications:
  08nov2003: Added properties Autosize, Alignment.
  18may2005: Added span paradigm
  09apr2011: removed some "with" statements

  Copyright (c) 2003-2011 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

  Contributors: JohnF (JF)
  26may2010: changed local function FindBreakPos
    feb2011: fixes, SetAllowFontSizing

}
unit dtpTextShape;

{$i simdesign.inc}

// define for new projects, undefine to use the old text shapes. This allows to
// load TdtpPolygonText by default with old DtpDocuments archives.
// TdtpPolygonText is much more powerful and consumes less mem, so it is
// superior to the old TdtpText in almost all cases!

interface

uses
  Types, Classes, Contnrs, Windows, Graphics, SysUtils, ExtCtrls, dtpShape,
  dtpGraphics, dtpLineEdit, NativeXmlOld, dtpEffectShape,
  dtpDefaults, dtpHandles, dtpBorders, sdWidestrings, Math;

type

  TVerticalAlignment = (alTop, alMiddle, alBottom);

  TdtpTextBaseShape = class;

  TdtpTextSpan = class(TPersistent)
  private
    FCharCount: integer;
    FCharPos: integer;
    FTop: single;
    FLeft: single;
    FHeight: single;
    FWidth: single;
    FParent: TdtpTextBaseShape;
    function GetText: widestring;
  public
    constructor Create(AParent: TdtpTextBaseShape);
    procedure SetSize(AWidth, AHeight: single);
    procedure SaveToXml(ANode: TXmlNodeOld); virtual;
    procedure LoadFromXml(ANode: TXmlNodeOld); virtual;
    property Left: single read FLeft write FLeft;
    property Top: single read FTop write FTop;
    property Width: single read FWidth write FWidth;
    property Height: single read FHeight write FHeight;
    property CharPos: integer read FCharPos write FCharPos;
    property CharCount: integer read FCharCount write FCharCount;
    property Text: widestring read GetText;
  end;

  // TdtpTextBaseShape is a base class for all other text-based shapes in DtpDocuments.
  // It contains basic properties for text shapes, but doesn't implement a method
  // of rendering text. Use either TdtpTextShape for standard text, TdtpMemoShape
  // for multi-line text or TdtpPolygonShape for polygon-based text (for outlines,
  // and text effects like curved or wavy text).
  TdtpTextBaseShape = class(TdtpEffectShape)
  private
    FSpans: TObjectList;              // List of text spans
    FAutoSize: boolean;               // If True (Default) then shape rectangle will adjust to the size of the text
    FIsAdjusting: boolean;            // Signals that we are currently adjusting bounds
    FFontName: string;                // Font face name
    FFontHeight: single;              // Font height in mm (baseline)
    FFontStyle: TFontStyles;          // Collection of styles (bold, italic, ..)
    FFontColor: TColor;               // Color of the font
    FText: widestring;                // String holding the text
    FAlignment: TAlignment;           // Horizontal alignment within shape rectangle (taLeftJustify, taRightJustify, taCenter)
    FVertAlign: TVerticalAlignment;   // Vertical alignment
    // Text editing
    FCaretBlinkState: boolean;        // On/Off state of blinking caret
    FCaretIndex: integer;             // Position of the caret (0 = before first char)
    FCaretTimer: TTimer;              // Temporary TTimer object used for blinking
    FLineEdit: TdtpLineEdit;          // Temporary LineEdit object used when editing
    FBackupText: widestring;          // Backup text when editing (so ESC can go back)
    FSelStart: integer;               // Start of the selected text (edit mode)
    FSelLength: integer;
    FUseKerning: boolean;
    FWordSpacing: single;
    FCharacterSpacing: single;        // Length of the selected text (edit mode)
    procedure LineEditChanged(Sender: TObject);
    function GetFontHeightPts: single;
    procedure SetFontHeightPts(const Value: single);
    procedure SetAutoSize(const Value: boolean);
    function GetBold: boolean;
    function GetItalic: boolean;
    procedure SetBold(const Value: boolean);
    procedure SetItalic(const Value: boolean);
    procedure SetVertAlign(const Value: TVerticalAlignment);
    procedure SetWordWrap(const Value: boolean);
    procedure SetSelStart(const Value: integer);
    procedure SetSelLength(const Value: integer);
    procedure SetCaretIndex(const Value: integer);
    procedure SetAlignment(const Value: TAlignment);
    function GetSpanCount: integer;
    function GetSpans(Index: integer): TdtpTextSpan;
    procedure SetCharacterSpacing(const Value: single);
    procedure SetUseKerning(const Value: boolean);
    procedure SetWordSpacing(const Value: single);
    procedure SetPaintEditBorder(const Value: boolean);
  protected
    FAllowFontSizing: boolean;        // Allow user-resize to result in font size change (AutoSize must be true as well)
    FCaretPositions: array of TdtpPoint; // List of caret positions for each char (in doc coords)
    FCaretSpans: array of integer;    // Per caret an index in span array
    FMultiLine: boolean;              // multiline text (memo)
    FWordWrap: boolean;               // Allow wordwrap
    FLineHeight: single;
    FPaintEditBorder: boolean;        // Paint dotted border around shape when editing (added by JF)
    FEditBorder: TdtpBorderPainter;
    FAllSelected: boolean;
    function AddSpan: TdtpTextSpan; virtual;
    procedure AdjustBounds;
    procedure DetermineSpanDimensions;
    // This function should prepare any text rendering so the call to GetTextExtent
    // can succeed. It should normally be overridden in descendant text rendering classes
    procedure PrepareTextExtent; virtual;
    function GetCaretIndexAt(X,Y: integer): integer;
    function GetLineHeight: single; virtual;
    // GetTextExtent *must* be overridden in descendant shapes, and should return
    // the width and heigth of the text starting at APos and with length ALength
    procedure GetTextExtent(APos, ALength: integer; var AWidth, AHeight: double); virtual; abstract;
    procedure CalculateSpanPositions;
    procedure GetTotalSpanExtent(var AWidth, AHeight: single);
    function GetPasteOffset: TdtpPoint; override;
    procedure CaretTimer(Sender: TObject);
    procedure DoEditClose(Accept: boolean); override;
    procedure DoModification; virtual;
    function GetFontName: string; virtual;
    procedure SetFontName(const Value: string); virtual;
    function GetFontHeight: single; virtual;
    procedure SetFontHeight(const Value: single); virtual;
    function GetFontStyle: TFontStyles; virtual;
    procedure SetFontStyle(const Value: TFontStyles); virtual;
    function GetFontColor: TColor; virtual;
    procedure SetAllowFontSizing(const Value: boolean); // added by J.F. Feb 2011
    procedure SetFontColor(const Value: TColor); virtual;
    procedure SetDocSize(AWidth, AHeight: single); override;
    procedure SetPreserveAspect(const Value: boolean); override; //added by J.F. Feb 2011
    procedure SetPropertyByName(const AName, AValue: string); override;
    procedure SetText(const Value: widestring); virtual;
    procedure SetSelected(const Value: boolean); override;
    function GetCaretPosition(CharPos: integer): TdtpPoint;
    procedure CalculateCaretPositions; virtual;
    procedure DrawCaret;
    procedure PrepareCaretPositionCalculation(ADpm: single); virtual;
    procedure CalculateCaretPositionsOfSpan(ASpan: TdtpTextSpan; ADpm: single); virtual;
    function LineEditCaretPosition(Sender: TObject; ACaretPos: integer; AKeyCode: word): integer;
    procedure SetLineHeight(Value:single); virtual;
    procedure CreateEditBorderObject;
    procedure SetDocument(const Value: TObject); override;
    property Multiline: boolean read FMultiline;
    property IsAdjusting: boolean read FIsAdjusting write FIsAdjusting;
    property VertAlign: TVerticalAlignment read FVertAlign write SetVertAlign;
    property WordWrap: boolean read FWordWrap write SetWordWrap;
    property LineEdit: TdtpLineEdit read FLineEdit;
    property CaretIndex: integer read FCaretIndex write SetCaretIndex;
    property SpanCount: integer read GetSpanCount;
    property Spans[Index: integer]: TdtpTextSpan read GetSpans;
    property LineHeight: single read FLineHeight write SetLineHeight;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure LoadFromXml(ANode: TXmlNodeOld); override;
    procedure SaveToXml(ANode: TXmlNodeOld); override;
    procedure Edit; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure MouseDblClick(Left, Right, Shift, Ctrl: boolean; X, Y: integer); override;
    procedure MouseMove(Left, Right, Shift, Ctrl: boolean; X, Y: integer); override;
    procedure MouseDown(Left, Right, Shift, Ctrl: boolean; X, Y: integer); override;
    procedure PaintSelectionBorder(Canvas: TCanvas); override;
    property AllowFontSizing: boolean read FAllowFontSizing write SetAllowFontSizing;  // changed by J.F. Feb 2011
    property AutoSize: boolean read FAutoSize write SetAutoSize;
    property Text: widestring read FText write SetText;
    property FontColor: TColor read GetFontColor write SetFontColor;
    property FontName: string read GetFontName write SetFontName;
    property FontHeight: single read GetFontHeight write SetFontHeight;
    property FontHeightPts: single read GetFontHeightPts write SetFontHeightPts;
    property FontStyle: TFontStyles read GetFontStyle write SetFontStyle;
    property Bold: boolean read GetBold write SetBold;
    property Italic: boolean read GetItalic write SetItalic;
    property Alignment: TAlignment read FAlignment write SetAlignment;
    property SelStart: integer read FSelStart write SetSelStart;
    property SelLength: integer read FSelLength write SetSelLength;
    property CharacterSpacing: single read FCharacterSpacing write SetCharacterSpacing;
    property WordSpacing: single read FWordSpacing write SetWordSpacing;
    property UseKerning: boolean read FUseKerning write SetUseKerning;
    // If True, draw dotted rectangle around text area when editing (added by JF)
    property PaintEditBorder: boolean read FPaintEditBorder write SetPaintEditBorder;
  end;

  // TdtpTextShape implements text rendering based on Win GDI Text functions.
  // It uses a device independent method for finding text dimensions, and actual
  // rendered text font sizes will be adapted until they fit into a box with independent
  // text dimensions. This class is superseded by TdtpPolygonText, just there for
  // compatibility.

  {$ifndef usePolygonText}
  TdtpTextShape = class(TdtpTextBaseShape)
  private
    procedure FitTextIntoSpan(DIB: TdtpBitmap; const AText: widestring;
      ASpan: TdtpTextSpan; ADpm: single; var Headroom: single);
  protected
    procedure PrepareTextExtent; override;
    procedure GetTextExtent(APos, ALength: integer; var AWidth, AHeight: double); override;
    procedure PaintDib(Dib: TdtpBitmap; const Device: TDeviceContext); override;
    procedure PrepareCaretPositionCalculation(ADpm: single); override;
    procedure CalculateCaretPositionsOfSpan(ASpan: TdtpTextSpan; ADpm: single); override;
  public
    constructor Create; override;
  end;
  {$endif}

const

  // Font adjustment
  cFontPixelsPerInch = 14400; // Used for internal rendering
  cFontAdjustFactor  = cFontPixelsPerInch / 72;

implementation

uses                                     
  dtpDocument, dtpCommand, Forms, Controls,  Dialogs, dtpPolygonText;

var
  StockBitmap: TdtpBitmap = nil;

const
  c300Dpi = 300 / 25.4;

type
  TDocumentAccess = class(TdtpDocument);

{ TdtpTextBaseShape }

function TdtpTextBaseShape.AddSpan: TdtpTextSpan;
begin
  FSpans.Add(TdtpTextSpan.Create(Self));
  Result := Spans[SpanCount - 1];
end;

procedure TdtpTextBaseShape.AdjustBounds;
//changed by J.F. Feb 2011
var
  NewLeft, NewTop, NewWidth, NewHeight: single;
  W, H: double;
begin
  // Find the dimensions of the spans
  DetermineSpanDimensions;

  // If we autosize, we will update the bounds of the shape
  if FAutoSize then
  begin
    FIsAdjusting := True;
    DisableUndo;
    try
      GetTotalSpanExtent(NewWidth, NewHeight);
      // Emtpy text?
      if (NewWidth = 0) and (NewHeight = 0) then
      begin
        // Get a default text extent (character W)
        GetTextExtent(0, 0, W, H);
        NewWidth := W;
        NewHeight := H;
      end;
      if FMultiLine and FWordWrap then
        NewWidth := DocWidth;

      // Correct for alignment horizontal
      NewLeft := DocLeft;
      case Alignment of
      taCenter:       NewLeft := DocLeft + (DocWidth - NewWidth) * 0.5;
      taRightJustify: NewLeft := DocLeft + DocWidth - NewWidth;
      end;//case

      // Correct for alignment vertical
      NewTop := DocTop;
      case VertAlign of
      alMiddle: NewTop := DocTop + (DocHeight - NewHeight) * 0.5;
      alBottom: NewTop := DocTop + DocHeight - NewHeight;
      end;

      // ..and set the bounds
      SetDocBounds(NewLeft, NewTop, NewWidth, NewHeight);

    finally
      EnableUndo;
      IsAdjusting := False;
    end;

  end;

  // Calculate the new positions of the spans within the shape
  CalculateSpanPositions;
end;


procedure TdtpTextBaseShape.CalculateCaretPositions;
// Find the caret positions in current text
var
  i, j, APos: integer;
  ALength: integer;
  ASpan: TdtpTextSpan;
  ADpm: single;
begin
  ALength := Length(Text);

  // Initialize
  FCaretPositions := nil;
  SetLength(FCaretPositions, ALength + 1);
  SetLength(FCaretSpans, ALength + 1);
  for i := 0 to ALength do
    // indicate "invalid span"
    FCaretSpans[i] := -1;

  // No business if length is zero
  if ALength = 0 then
    exit;

  if not assigned(Document) then
    exit;
  // NH: changed from RenderDpm to ScreenDpm
  ADpm := TdtpDocument(Document).ScreenDpm;

  // Preparation (setting Dib etc)
  PrepareCaretPositionCalculation(ADpm);

  // Get caret positions for each span.
  for i := 0 to SpanCount - 1 do
  begin
    ASpan := Spans[i];

    // This is a virtual method that must be overridden in descendants
    CalculateCaretPositionsOfSpan(ASpan, ADpm);

    // Correct for span position
    for j := 0 to ASpan.CharCount do
    begin
      APos := ASpan.CharPos + j - 1;
      FCaretPositions[APos].X := FCaretPositions[APos].X + ASpan.Left;
      FCaretPositions[APos].Y := ASpan.Top;
      FCaretSpans[APos] := i;
    end;
  end;

end;

procedure TdtpTextBaseShape.CalculateCaretPositionsOfSpan(ASpan: TdtpTextSpan; ADpm: single);
begin
// default does nothing, should be overridden in descendant shapes
end;

procedure TdtpTextBaseShape.CalculateSpanPositions;
var
  i: integer;
  ALeft, ATop, AWidth, AHeight: single;
begin
  // Horizontal
  for i := 0 to SpanCount - 1 do
  begin
    ALeft := 0;
    case Alignment of
    taCenter:       ALeft := (DocWidth - Spans[i].Width) * 0.5;
    taRightJustify: ALeft := DocWidth - Spans[i].Width;
    end;//case
    Spans[i].Left := ALeft;
  end;

  // Vertical
  GetTotalSpanExtent(AWidth, AHeight);
  ATop := 0;
  case VertAlign of
  alMiddle: ATop := (DocHeight - AHeight) * 0.5;
  alBottom: ATop := DocHeight - AHeight;
  end;// case
  for i := 0 to SpanCount - 1 do
  begin
    Spans[i].Top := ATop;
    ATop := ATop + GetLineHeight;
  end;

  if IsEditing then
    CalculateCaretPositions;
end;

procedure TdtpTextBaseShape.CaretTimer(Sender: TObject);
begin
  FCaretBlinkState := not FCaretBlinkState;
  DrawCaret; // added by JF
end;

constructor TdtpTextBaseShape.Create;
begin
  inherited;
  // Owned objects
  FSpans := TObjectList.Create;
  // Defaults
  FAutoSize := True;
  FAllowFontSizing := True;
  //  FBkColor := clBlack32;
  FFontHeight := cDefaultFontHeight;
  InsertCursor := crDtpCrossText;
  FFontName := 'Arial';
  FFontColor := clBlack;
  FLineHeight := cDefaultLineDist; // added by JF
end;

destructor TdtpTextBaseShape.Destroy;
begin
  FreeAndNil(FEditBorder);
  FreeAndNil(FSpans);
  FreeAndNil(FCaretTimer);
  FreeAndNil(FLineEdit);
  inherited;
end;

procedure TdtpTextBaseShape.SetDocument(const Value: TObject);
// added by JF
begin
  inherited;
  if assigned(Document) then
    // check because on shape destroy the base class calls this and sets Document to nil
    FPaintEditBorder:= TdtpDocument(Document).PaintEditBorder;
end;

procedure TdtpTextBaseShape.DetermineSpanDimensions;
// changed by J.F. Feb 2011
var
  AWidth, AHeight: double;
  APos, ALen, Start: integer;
  ALine, APart: widestring;
  NewPos, EndPos: integer;
  Span: TdtpTextSpan;

  // local
  function FindBreakPos(const ALine: widestring; APos: integer): integer;
  begin
    repeat
      dec(APos);
      if ord(ALine[APos + 1]) in [ord(' '), ord('-')] then
        break;
    until APos = 0;
    Result := APos;
  end;

// main
begin
  PrepareTextExtent;

  FSpans.Clear;

  if Multiline then
  begin

    // Multiline text
    APos := 1;

    // Do we wordwrap?
    if WordWrap then
    begin
      // With wordwrap
      repeat
        Start := APos;
        ALen := GetLineLengthFrom(FText, APos);
        if ALen >= 0 then // added by JF
        begin
          ALine := CopyWide(FText, Start, ALen);
          repeat
            APart := ALine;
            EndPos := Length(ALine);
            if EndPos > 1 then
            repeat
              // Get size of a line
              GetTextExtent(Start, length(APart), AWidth, AHeight);
              if AWidth < DocWidth then
                break;
              // We're too wide so we must shrink the line
              NewPos := FindBreakPos(ALine, EndPos);
              if NewPos = 0 then
                NewPos := EndPos - 1;
              if NewPos < 1 then
                NewPos := 1;
              APart := TrimRight(CopyWide(ALine, 1, NewPos));
              EndPos := Length(APart);
            until EndPos <= 1;
            Span := AddSpan;
            Span.CharPos := Start;
            Span.CharCount := length(APart);
            GetTextExtent(Span.CharPos, Span.CharCount, AWidth, AHeight);
            Span.SetSize(AWidth, AHeight);
            // added by J.F. Feb 2011
            inc(EndPos);
            // changed by J.F. Feb 2011
            while (EndPos < length(Aline)) and (ord(ALine[EndPos]) in [ 32, 10, 13]) do
              inc(EndPos);
            ALine := CopyWide(ALine, EndPos, Length(ALine));
            inc(Start,EndPos - 1);
            if (FText[Start] = ' ') then
              inc(Start);  // get rid of space char at beginning of line
          until (Length(ALine) = 0);
        end else
          // added by JF
          if ALen < -1 then
          begin
            // add empty Span   // changed by J.F. Feb 2011
            Span := AddSpan;
            Span.CharPos := Start;
            Span.CharCount := 0;
            GetTextExtent(Span.CharPos, Span.CharCount, AWidth, AHeight);
            Span.SetSize(AWidth, AHeight);
          end;
      until ALen < 0;
    end
    else
    begin

      // No wordwrap, simply add spans
      repeat
        Start := APos;
        ALen := GetLineLengthFrom(FText, APos);
        if ALen <> -1 then // changed by JF
        begin
          Span := AddSpan;
          Span.CharPos := Start;
          if ALen = -2 then // added by JF
            Span.CharCount := 0
          else
            Span.CharCount := ALen;
          GetTextExtent(Span.CharPos, Span.CharCount, AWidth, AHeight);
          Span.SetSize(AWidth, AHeight);
        end;
      until ALen < 0 ;

    end;

  end
  else
  begin

    // One line text
    Span := AddSpan;
    Span.CharPos := 1;
    Span.CharCount := length(FText);
    GetTextExtent(Span.CharPos, Span.CharCount, AWidth, AHeight); // added by J.F. Feb 2011
    Span.SetSize(AWidth, AHeight);  // added by J.F. Feb 2011

  end;
end;


procedure TdtpTextBaseShape.DoEditClose(Accept: boolean);
begin
  if not Accept then
    Text := FBackupText;
  FreeAndNil(FCaretTimer);
  FreeAndNil(FLineEdit);
  Invalidate;
end;

procedure TdtpTextBaseShape.DoModification;
begin
  Invalidate;
  AdjustBounds;
  Regenerate;
  Changed;
end;

procedure TdtpTextBaseShape.Edit;
begin
  // Make a backup before editing
  FBackupText := Text;

  // Do we allow editing?
  if not AllowEdit then
  begin
    TdtpDocument(Document).DoEditClose(False);
    exit;
  end;

  // Calculate caret positions
  CalculateCaretPositions;

  // Create a timer - this will blink the caret
  if not assigned(FCaretTimer) then
  begin
    FCaretTimer := TTimer.Create(nil);
    FCaretTimer.Interval := cDefaultCaretBlinkInterval;
    FCaretTimer.OnTimer := CaretTimer;
    FCaretBlinkState := False;
  end;

  // Create line edit
  if not assigned(FLineEdit) then
  begin
    FLineEdit := TdtpLineEdit.Create;
    if FMultiLine then // added by JF
      FLineEdit.OnCaretPosition := LineEditCaretPosition;
    FLineEdit.Text := Text;
    FLineEdit.OnChanged := LineEditChanged;
    FLineEdit.SelectAll;
    // added by JF, fixes when MouseMove fires
    FAllSelected:= true;
  end;

  // Invalidate the control; so that it will display the caret etc
  Invalidate;

  // Grab focus - so we are getting keyboard input
  TdtpDocument(Document).SetFocus;
end;

function TdtpTextBaseShape.GetBold: boolean;
begin
  Result := fsBold in FontStyle;
end;

function TdtpTextBaseShape.GetCaretPosition(CharPos: integer): TdtpPoint;
begin
// see descendants
end;

function TdtpTextBaseShape.GetFontColor: TColor;
begin
  Result := FFontColor;
end;

function TdtpTextBaseShape.GetFontHeight: single;
begin
  Result := FFontHeight;
end;

function TdtpTextBaseShape.GetFontHeightPts: single;
begin
  Result := FontHeight * 72 / cMMtoInch;
end;

function TdtpTextBaseShape.GetFontName: string;
begin
  Result := FFontName;
end;

function TdtpTextBaseShape.GetFontStyle: TFontStyles;
begin
  Result := FFontStyle;
end;

function TdtpTextBaseShape.GetItalic: boolean;
begin
  Result := fsItalic in FontStyle;
end;

function TdtpTextBaseShape.GetLineHeight: single; // changed by JF June 2011
var
  TestHeight: integer;
begin
  PrepareTextExtent;
  TestHeight := StockBitmap.TextHeightW('W');
  Result:= (TestHeight / c300Dpi) * FLineHeight;
  //Result := FontHeight * FLineHeight; // changed by JF
end;

function TdtpTextBaseShape.GetPasteOffset: TdtpPoint;
begin
  Result.X := 0;
  Result.Y := GetLineHeight;
end;

function TdtpTextBaseShape.GetSpanCount: integer;
begin
  Result := FSpans.Count;
end;

function TdtpTextBaseShape.GetSpans(Index: integer): TdtpTextSpan;
begin
  if (Index >= 0) and (Index < SpanCount) then
    Result := TdtpTextSpan(FSpans[Index])
  else
    Result := nil;
end;

procedure TdtpTextBaseShape.GetTotalSpanExtent(var AWidth,
  AHeight: single);
var
  i: integer;
begin
  AWidth := 0;
  AHeight := 0;
  if MultiLine then
  begin
    for i := 0 to SpanCount - 1 do
      AWidth := Max(AWidth, Spans[i].Width);
    AHeight := SpanCount * GetLineHeight;
    // added by J.F. Apr 2011, fixes bottom of text cut off with LineHeight < 1 and text rotated
    if FLineHeight < 1 then
      AHeight := AHeight + (1 - FLineHeight);
  end else
  begin
    if assigned(Spans[0]) then
    begin
      AWidth  := Spans[0].Width;
      // needed for TextShape and Projective text J.F.
      AHeight:= GetLineHeight;  // changed by J.F.June 2011
    end;
  end;
end;

procedure TdtpTextBaseShape.KeyDown(var Key: Word; Shift: TShiftState);
begin
  case Key of
  VK_RETURN, VK_EXECUTE, VK_F2, VK_TAB:
    TdtpDocument(Document).DoEditClose(True);
  VK_ESCAPE, VK_CANCEL:
    TdtpDocument(Document).DoEditClose(False);
  else
    if assigned(LineEdit) then
      LineEdit.ProcessKeyDown(Key, Shift);
  end;
end;

procedure TdtpTextBaseShape.KeyPress(var Key: Char);
begin
  if assigned(LineEdit) then
    LineEdit.ProcessKeyPress(Key);
end;

procedure TdtpTextBaseShape.KeyUp(var Key: Word; Shift: TShiftState);
begin
  if assigned(LineEdit) then
    LineEdit.ProcessKeyUp(Key, Shift);
end;

function TdtpTextBaseShape.LineEditCaretPosition(Sender: TObject;
  ACaretPos: integer; AKeyCode: word): integer;
var
  Closest: integer;
  Span: TdtpTextSpan;

  // local
  function FindClosestOnSpan(SpanIndex: integer; APosX: single): integer;
  var
    i: integer;
    ASpan: TdtpTextSpan;
    Dist, MinDist: single;
  begin
    Result := -1;
    ASpan := Spans[SpanIndex];
    if not assigned(ASpan) then
      exit;
    MinDist := 0; // avoid compiler warning
    for i := 0 to ASpan.CharCount do
    begin
      Dist := abs(FCaretPositions[i + ASpan.CharPos - 1].X - FCaretPositions[ACaretPos].X);
      if (Result = -1) or (Dist < MinDist) then
      begin
        MinDist := Dist;
        Result := i + ASpan.CharPos - 1;
      end;
    end;
  end;

// main
begin
  Result := ACaretPos;
  case AKeyCode of
  VK_LEFT:
    begin
      Result := ACaretPos;
      repeat
        Result := Max(Result - 1, 0);
      until (Result = 0) or (FCaretSpans[Result] >= 0);
    end;
  VK_RIGHT:
    begin
      Result := ACaretPos;
      repeat
        Result := Min(Result + 1, length(FText));
      until (Result = length(FText)) or (FCaretSpans[Result] >= 0);
    end;
  VK_UP:
    begin
      Closest := FindClosestOnSpan(FCaretSpans[ACaretPos] - 1, FCaretPositions[ACaretPos].X);
      if Closest >= 0 then Result := Closest;
    end;
  VK_DOWN:
    begin
      Closest := FindClosestOnSpan(FCaretSpans[ACaretPos] + 1, FCaretPositions[ACaretPos].X);
      if Closest >= 0 then Result := Closest;
    end;
  VK_HOME: Result := Spans[FCaretSpans[ACaretPos]].CharPos - 1;
  VK_END:
    begin
      Span := Spans[FCaretSpans[ACaretPos]];
      Result := Span.CharPos + Span.CharCount - 1;
    end;
  end;// case
end;

procedure TdtpTextBaseShape.LineEditChanged(Sender: TObject);
begin
  if assigned(LineEdit) then begin
    Text := LineEdit.Text;
    SelStart := LineEdit.SelStart;
    SelLength := LineEdit.SelLength;
    CaretIndex := LineEdit.CaretIndex;
    CalculateCaretPositions;
  end;
end;

procedure TdtpTextBaseShape.SetLineHeight(Value:single);
// added by JF
begin
  FLineHeight:= Value;
  DoModification;
end;

procedure TdtpTextBaseShape.LoadFromXml(ANode: TXmlNodeOld);
var
  i: integer;
  AChild: TXmlNodeOld;
  AList: TXmlNodeList;
  ASpan: TdtpTextSpan;
begin
  inherited;
  FText       := sdUtf8ToUnicode(ANode.ReadString('Text'));
  FFontHeight := ANode.ReadFloat('FontHeight');
  FAutoSize   := ANode.ReadBool('AutoSize');
  FAlignment  := TAlignment(ANode.ReadInteger('Alignment'));
  FWordWrap   := ANode.ReadBool('WordWrap');
  FVertAlign  := TVerticalAlignment(ANode.ReadInteger('VertAlign'));

  FLineHeight := ANode.ReadFloat('LineHeight'); // added by JF
  if FLineHeight = 0.0 then
    FLineHeight:= cDefaultLineDist;

  AChild := ANode.NodeByName('Font');
  if assigned(AChild) then
  begin
    FFontName := sdUtf8ToUnicode(AChild.ReadString('Name'));
    FFontColor := AChild.ReadColor('Color');
    FFontStyle := [];
    if AChild.ReadBool('Bold', False) then
      FFontStyle := FFontStyle + [fsBold];
    if AChild.ReadBool('Italic', False) then
      FFontStyle := FFontStyle + [fsItalic];
    if AChild.ReadBool('Underline', False) then
      FFontStyle := FFontStyle + [fsUnderline];
    if AChild.ReadBool('Strikeout', False) then
      FFontStyle := FFontStyle + [fsStrikeout];
  end else
  begin
    // Defaults
    FFontName := 'Arial';
    FFontColor := clBlack;
    FFontStyle := [];
  end;

  FCharacterSpacing := ANode.ReadFloat('CharacterSpacing');
  FWordSpacing := ANode.ReadFloat('WordSpacing');
  FUseKerning := ANode.ReadBool('UseKerning');

  // Load spans
  FSpans.Clear;
  AList := TXmlNodeList.Create;{(False)};
  try
    ANode.NodesByName('Span', AList);
    for i := 0 to AList.Count - 1 do
    begin
      ASpan := AddSpan;
      ASpan.LoadFromXml(AList[i]);
    end;
  finally
    AList.Free;
  end;

  // If there are no spans, we must recreate them! (for compatibility)
  if SpanCount = 0 then
    AdjustBounds
  else
    CalculateSpanPositions;

  // after loading, update
  DoModification;
end;

procedure TdtpTextBaseShape.MouseDblClick(Left, Right, Shift, Ctrl: boolean; X,
  Y: integer);
begin
  if Left then // added by JF
  begin
    if (IsEditing) and (assigned(FLineEdit)) then
      FLineEdit.SelectAll;
  end;
end;

procedure TdtpTextBaseShape.MouseMove(Left, Right, Shift, Ctrl: boolean; X, Y: integer);
// added by JF: implements I-Beam, allows user to use mouse to select words etc
var
  Delta: integer;
begin
  if IsEditing then
  begin
    if GetHitTestInfoAt(Point(X, Y)) = htNone then
      Screen.Cursor:= crDefault
    else
    begin
      if Screen.Cursor <> crIBeam then
        Screen.Cursor := crIBeam;
      if Left then
      begin
        if FAllSelected then  // shape entered Edit mode
        begin
          FAllSelected := False;
          exit;
        end;

        Delta := GetCaretIndexAt(X, Y) - FLineEdit.CaretIndex;
        if FLineEdit.SelLength = 0 then
          FLineEdit.SelStart := FLineEdit.CaretIndex;

        // Change selection border at CaretIndex as well
        if FLineEdit.CaretIndex = FLineEdit.SelStart then
        begin
          FLineEdit.SelStart := FLineEdit.SelStart + Delta;
          FLineEdit.SelLength := FLineEdit.SelLength - Delta;
        end
        else
        if FLineEdit.CaretIndex = FLineEdit.SelStart + FLineEdit.SelLength then
          FLineEdit.SelLength := FLineEdit.SelLength + Delta;

        // Checks
        if FLineEdit.SelLength < 0 then // going positive
        begin
          // Swap
          FLineEdit.SelStart := FLineEdit.SelStart + FLineEdit.SelLength;
          FLineEdit.SelLength := abs(FLineEdit.SelLength);
        end;

        // Change caret index
        FLineEdit.CaretIndex := FLineEdit.CaretIndex + Delta;

      end;
    end;
  end;
end;

function RoundCorrect(Value: extended): integer;
//  added by J.F. Feb 2011
// fixes inAccurate Round and RoundTo function in older compilers
begin
  Result := Trunc(Value);       // extract the integer part
  if Frac(Value) >= 0.5 then   // if fractional part >= 0.5 then...
    Result := Result + 1;   // ...add 1
end;

function TdtpTextBaseShape.GetCaretIndexAt(X, Y: integer): integer;
// changed by J.F. Feb 2011
var
  MousePt: TdtpPoint;
  i, j: integer;
  ALineHeight: extended;
  CharCountTotal: integer;

// added by JF
begin
  Result := -1;
  if IsEditing then
  begin
    MousePt := ScreenToShape(Point(X, Y));
                 // **** RoundCorrect needed for Cursor Placement *****
    MousePt.X:= RoundCorrect(MousePt.X); // added by J.F. June 2011
    ALineHeight := GetLineHeight;
    CharCountTotal := 0;
    for i := 0 to SpanCount - 1 do
    begin
      if (MousePt.Y < Spans[i].Top + ALineHeight) then
      begin
        // we are on correct Span
        // changed by J.F. Apr 2011
        if MousePt.X <= DocWidth then
        for j := 0 to Spans[i].CharCount - 1 do
        begin
          // **** RouncCorrect needed for Cursor Placement *****
                    // changed by J.F. June 2011
          if MousePt.X < RoundCorrect(FCaretPositions[CharCountTotal].X) then
          begin
            // position cursor before char
            dec(CharCountTotal);   // changed by J.F.  Feb 2011
            break;  //  added by J.F. June 2011
          end
          else
            // next char    // changed by J.F. June 2011
          if MousePt.X > RoundCorrect(FCaretPositions[CharCountTotal].X) then
          begin
              // changed by J.F. June 2011
            if MousePt.X < RoundCorrect(FCaretPositions[CharCountTotal + 1].X) then
              break
            else
              inc(CharCountTotal);
          end;
        end
        else
           inc(CharCountTotal, Spans[i].CharCount);
        Result := CharCountTotal;
        exit;
      end;
      if MultiLine then  // added by J.F. Feb 2011
      begin
        inc(CharCountTotal, Spans[i].CharCount + 2); // account for #13#10

        if (ord(FText[CharCountTotal - 1]) in [32]) then // added by J.F. Feb 2011
          dec(CharCountTotal, 1);
      end;
    end;
  end;
end;

procedure TdtpTextBaseShape.MouseDown(Left, Right, Shift, Ctrl: boolean; X,
  Y: integer);
begin
  // changed by JF
  if IsEditing then
  begin
    // Try to determine the click position
    if GetHitTestInfoAt(Point(X, Y)) = htNone then
      // Outside of the document, so leave the edit mode
      TdtpDocument(Document).DoEditClose(True)
    else
      if Left then
      begin
        FLineEdit.OnChanged := nil;  // added by JF
        FLineEdit.Text:= Text;
        // in case undo / redo applied
        if FLineEdit.SelLength > 0 then
        begin
          FLineEdit.UnSelectAll;
          LineEditChanged(FLineEdit);  // added by J.F. June 2011
        end;
        CaretIndex := GetCaretIndexAt(X,Y);

        if CaretIndex > Length(FLineEdit.Text) then // added by J.F. Feb 2011
          CaretIndex := Length(FLineEdit.Text);

        if CaretIndex <> -1 then
          FLineEdit.CaretIndex:= CaretIndex;
        FLineEdit.OnChanged := LineEditChanged;  // added by JF
      end;
  end;
end;

procedure TdtpTextBaseShape.DrawCaret;
// added by JF
// DrawCaret moved here from Paint Selection Border
// so when CaretTimer fires it just draws Caret
// see change in CaretTimer procedure
var
  S_Shape, C_Shape: TdtpPoint;
  S_Screen, C_Screen: TPoint;
  ACaretPosition: TdtpPoint;
  C: TCanvas;
begin
  if (CaretIndex >= 0) and (CaretIndex <= Length(FCaretPositions)) then
  begin
    ACaretPosition:= FCaretPositions[CaretIndex];
    if Mirrored then
      ACaretPosition.X := DocWidth - ACaretPosition.X;
    S_Shape.X := ACaretPosition.X;
    S_Shape.Y := ACaretPosition.Y;
    C_Shape.X := ACaretPosition.X;
    C_Shape.Y := ACaretPosition.Y + GetLineHeight;
    S_Screen := Point(ShapeToScreen(S_Shape));
    C_Screen := Point(ShapeToScreen(C_Shape));
    C := TDocumentAccess(Document).Canvas;
    C.Pen.Style := psSolid;
    C.Pen.Mode  := pmNotXOR;
    C.Pen.Color := cDefaultCaretColor;
    C.Pen.Width := 2;
    C.MoveTo(S_Screen.X, S_Screen.Y);
    C.LineTo(C_Screen.X, C_Screen.Y);
  end;
end;


procedure TdtpTextBaseShape.SetPaintEditBorder(const Value: boolean);
// SetPaintEditBorder added by JF
begin
  if FPaintEditBorder <> Value then
  begin
    FPaintEditBorder:= Value;
    if assigned(FEditBorder) then
    begin
      case Value of
      True:
        if CurbLeft > 2 then
          // set to accomodate edit border
          SetCurbSize(2);
      False:
        if CurbLeft = 2 then
          SetCurbSize(0);
      end;//case
    end;
  end;
end;

procedure TdtpTextBaseShape.CreateEditBorderObject;
// added by JF
begin
  if not assigned(FEditBorder) then
  begin
    FEditBorder := TdtpBorderPainter.Create;
    if CurbLeft < 2 then
      // make sure its set to accomodate edit border for legacy files
      SetCurbSize(2);
    InvalidateSimple();
    FEditBorder.Shape := Self;
  end;
  FEditBorder.CreateCorners();
end;

procedure TdtpTextBaseShape.PaintSelectionBorder(Canvas: TCanvas);
// This method is overridden so we can paint the selection block here.
// This avoids having to draw them on the cache and therefore needing a regen
// all the time.

  // local
  procedure DrawSelection(PosFrom, PosTo: single; PosVert: single);
  // Draw a polygon around the selected area
  var
    i: integer;
    FPoints: array[0..4] of TdtpPoint;
    IPoints: array[0..4] of TPoint;
  begin
    if Mirrored then
    begin
     PosFrom := DocWidth - PosFrom;
     PosTo   := DocWidth - PosTo;
    end;
    // Get polygon in shape coords
    FPoints[0].X := PosFrom;
    FPoints[0].Y := PosVert;
    FPoints[1].X := PosFrom;
    FPoints[1].Y := PosVert + GetLineHeight;
    FPoints[2].X := PosTo;
    FPoints[2].Y := PosVert + GetLineHeight;
    FPoints[3].X := PosTo;
    FPoints[3].Y := PosVert;
    FPoints[4] := FPoints[0];
    // Convert to screencoords
    for i := 0 to 4 do
      IPoints[i] := Point(ShapeToScreen(FPoints[i]));
    // Draw the polyline
    Canvas.Brush.Style := bsDiagCross;
    Canvas.Brush.Color := cDefaultTextSelectionColor;
    Canvas.Pen.Style := psClear;
    Canvas.Polygon(IPoints);
  end;
  // local
  procedure DoDrawSelection(AStart, AClose: integer);
  var
    ANext: integer;
  begin
    ANext := AStart;
    repeat
      while (ANext < AClose) and (FCaretSpans[ANext + 1] = FCaretSpans[AStart]) do
        inc(ANext);
      if (ANext > AStart) and (FCaretSpans[AStart] >= 0) then
      begin
       if not (ord(Text[ANext]) in [13]) then
         // added by JF: fixes whole line visually selected when starting from mid line
         // and going to next line (Multiline Text). Either by keyboard cursor keys or mouse
         DrawSelection(FCaretPositions[AStart].X, FCaretPositions[ANext].X, FCaretPositions[AStart].Y);
      end;
      AStart := ANext;
      ANext := AStart + 1;
    until ANext > AClose;
  end;

// main
begin
  if IsEditing then
  begin
    if FPaintEditBorder then // do we want to show the edit border
    begin
      CreateEditBorderObject; // added by JF
      FEditBorder.PaintBorder(Canvas); // added by JF
    end;
    // Selection
    if (SelStart >= 0) and (SelStart < Length(Text)) and
       (SelLength > 0) and (SelStart + SelLength <= Length(Text)) then
      DoDrawSelection(SelStart, SelStart + SelLength);
  end
  else
    // Paint the handles the usual way
    inherited;
end;

procedure TdtpTextBaseShape.PrepareCaretPositionCalculation(ADpm: single);
begin
// default does nothing, should be overridden in descendant shapes
end;

procedure TdtpTextBaseShape.PrepareTextExtent;
begin
// Default does nothing, should be overridden in descendant shapes
end;

procedure TdtpTextBaseShape.SaveToXml(ANode: TXmlNodeOld);
var
  i: integer;
  Sub: TXmlNodeOld;
begin
  inherited;
  ANode.WriteString('Text', sdUnicodeToUtf8(FText));
  ANode.WriteFloat('FontHeight', FFontHeight);
  ANode.WriteBool('AutoSize', FAutoSize);
  ANode.WriteInteger('Alignment', integer(FAlignment));
  ANode.WriteBool('WordWrap', FWordWrap);
  ANode.WriteInteger('VertAlign', integer(FVertAlign));

  Sub := ANode.NodeNew('Font');
  Sub.WriteString('Name', UTF8String(FFontName));
  Sub.WriteColor('Color', FFontColor);
  Sub.WriteBool('Bold', fsBold in FFontStyle);
  Sub.WriteBool('Italic', fsItalic in FFontStyle);
  Sub.WriteBool('Underline', fsUnderline in FFontStyle);
  Sub.WriteBool('Strikeout', fsStrikeout in FFontStyle);

  ANode.WriteFloat('CharacterSpacing', FCharacterSpacing);
  ANode.WriteFloat('WordSpacing', FWordSpacing);
  ANode.WriteBool('UseKerning', FUseKerning);
  ANode.WriteFloat('LineHeight', FLineHeight); // added by JF

  // Save spans
  for i := 0 to SpanCount - 1 do
    Spans[i].SaveToXml(ANode.NodeNew('Span'));
end;

procedure TdtpTextBaseShape.SetAlignment(const Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    AddCmdToUndo(cmdSetProp, 'Alignment', integer(FAlignment));
    FAlignment := Value;
    CalculateSpanPositions;
    Regenerate;
  end;
end;

procedure TdtpTextBaseShape.SetAutoSize(const Value: boolean);
begin
  if (not Value) and FWordWrap then  // added by J.F. Feb 2011
    Exit;                             // preserve true value for WordWrap
  if FAutoSize <> Value then
  begin
    AddCmdToUndo(cmdSetProp, 'AutoSize', FAutoSize);
    Invalidate;
    FAutoSize := Value;
    if FAutoSize then
      DoModification;
  end;
end;

procedure TdtpTextBaseShape.SetBold(const Value: boolean);
begin
  if Value then
    FontStyle := FontStyle + [fsBold]
  else
    FontStyle := FontStyle - [fsBold];
end;

procedure TdtpTextBaseShape.SetCaretIndex(const Value: integer);
begin
  if FCaretIndex <> Value then
  begin
    FCaretIndex := Value;
    Invalidate;
  end;
end;

procedure TdtpTextBaseShape.SetCharacterSpacing(const Value: single);
begin
  if FCharacterSpacing <> Value then
  begin
    AddCmdToUndo(cmdSetProp, 'CharacterSpacing', FCharacterSpacing);
    FCharacterSpacing := Value;
    DoModification;
  end;
end;

procedure TdtpTextBaseShape.SetDocSize(AWidth, AHeight: single);
begin
  if FIsAdjusting or (DocHeight = 0) then
  begin
    inherited;
    exit;
  end;

  if FAllowFontSizing and AutoSize then
  begin
    // changed by JF: We simply adjust Fontheight so it is compatible
    FontHeight := FontHeight * (AHeight / DocHeight);
    if not MultiLine then // changed by JF
      exit;
  end;
  if MultiLine then
  begin
    inherited;
    AdjustBounds;
    exit;
  end;

  // Default behaviour - call inherited
  inherited;

  // And recalc the span positions
  CalculateSpanPositions;
end;

procedure TdtpTextBaseShape.SetAllowFontSizing(const Value: boolean);
// added by J.F. Feb 2011
begin
  if FAllowFontSizing <> Value then
  begin
    if FWordWrap and Value then
      exit
    else
      FAllowFontSizing := Value;
  end;
end;

procedure TdtpTextBaseShape.SetFontColor(const Value: TColor);
begin
  if FFontColor <> Value then
  begin
    AddCmdToUndo(cmdSetProp, 'FontColor', integer(FFontColor));
    FFontColor := Value;
    Refresh;
    Changed;
  end;
end;

procedure TdtpTextBaseShape.SetFontHeight(const Value: single);
begin
  if FFontHeight <> Value then
  begin
    AddCmdToUndo(cmdSetProp, 'FontHeight', FFontHeight);
    FFontHeight := Value;
    DoModification;
  end;
end;

procedure TdtpTextBaseShape.SetFontHeightPts(const Value: single);
begin
  FontHeight :=  Value * cMMtoInch / 72;
end;

procedure TdtpTextBaseShape.SetFontName(const Value: string);
begin
  if FFontName <> Value then
  begin
    AddCmdToUndo(cmdSetProp, 'FontName', FFontName);
    FFontName := Value;
    DoModification;
  end;
end;

procedure TdtpTextBaseShape.SetFontStyle(const Value: TFontStyles);
begin
  if FFontStyle <> Value then
  begin
    AddCmdToUndo(cmdSetProp, 'FontStyle', FFontStyle);
    FFontStyle := Value;
    DoModification;
  end;
end;

procedure TdtpTextBaseShape.SetItalic(const Value: boolean);
begin
  if Value then
    FontStyle := FontStyle + [fsItalic]
  else
    FontStyle := FontStyle - [fsItalic];
end;

procedure TdtpTextBaseShape.SetPreserveAspect(const Value: boolean); // added by J.F. Feb 2011
begin
  if Value <> PreserveAspect then
  begin
    if FWordWrap and Value then   // do not want to set this with WordWrap = True
      Exit
    else
      inherited;
  end;
end;

procedure TdtpTextBaseShape.SetPropertyByName(const AName, AValue: string);
begin
  inherited;
  if AnsiCompareText(AName, 'AutoSize') = 0 then
    AutoSize   := BoolFrom(AValue);
  if AnsiCompareText(AName, 'Text') = 0 then
    Text := sdUtf8ToUnicode(UTF8String(AValue));
  if AnsiCompareText(AName, 'FontName')  = 0 then
    FontName := AValue;
  if AnsiCompareText(AName, 'FontStyle') = 0 then
    FontStyle := FontStylesFrom(AValue);
  if AnsiCompareText(AName, 'FontHeight') = 0 then
    FontHeight := FloatFrom(AValue);
  if AnsiCompareText(AName, 'FontColor') = 0 then
    FontColor := StrToInt(AValue);
  if AnsiCompareText(AName, 'Alignment') = 0 then
    Alignment  := TAlignment(StrToInt(AValue));
  if AnsiCompareText(AName, 'VertAlign') = 0 then
    VertAlign  := TVerticalAlignment(StrToInt(AValue));
  if AnsiCompareText(AName, 'WordWrap') = 0 then
    WordWrap   := BoolFrom(AValue);
  if AnsiCompareText(AName, 'WordSpacing') = 0 then
    WordSpacing := FloatFrom(AValue);
  if AnsiCompareText(AName, 'UseKerning') = 0 then
    UseKerning  := BoolFrom(AValue);
  if AnsiCompareText(AName, 'CharacterSpacing') = 0 then
    CharacterSpacing := FloatFrom(AValue);
end;

procedure TdtpTextBaseShape.SetSelLength(const Value: integer);
begin
  if FSelLength <> Value then
  begin
    FSelLength := Value;
    Invalidate;
  end;
end;

procedure TdtpTextBaseShape.SetSelStart(const Value: integer);
begin
  if FSelStart <> Value then
  begin
    FSelStart := Value;
    Invalidate;
  end;
end;

procedure TdtpTextBaseShape.SetText(const Value: widestring);
var
  TempCaretIndex: integer;
begin
  if FText <> Value then
  try  // changed by J.F. Feb 2011
    AddCmdToUndo(cmdSetProp, 'Text', string(sdUnicodeToUtf8(FText)));
    FText := Value;
    if assigned(FLineEdit) then
    begin
      // added by JF: fixes caret position and re-syncs FText and FLineEdit.Text
      TempCaretIndex := FLineEdit.CaretIndex;
      // prevent un-necessary re-drawing
      FLineEdit.OnChanged := nil;
      FLineEdit.Text := value;
      FLineEdit.OnChanged := LineEditChanged;
      FLineEdit.CaretIndex := TempCaretIndex;
    end;
    IsPlaceHolderVisible := length(FText) = 0;
    DoModification;
  finally
       // changed by J.F. Feb 2011 in case someone puts a bunch of space chars at
       // end of line with word wrap - will look into further
  end;
end;

procedure TdtpTextBaseShape.SetSelected(const Value: boolean);
// added by JF: tell TdtpDocument to delete ourself
// if Empty Text, gets rid of empty TextShapes clutter
begin
  inherited;
  if (Value = false) and (Length(Text) = 0) then
    PostMessage(TdtpDocument(Document).Handle,WM_DELETE_SHAPE,integer(Self),0);
end;

procedure TdtpTextBaseShape.SetUseKerning(const Value: boolean);
begin
  if FUseKerning <> Value then
  begin
    AddCmdToUndo(cmdSetProp, 'UseKerning', FUseKerning);
    FUseKerning := Value;
    DoModification;
  end;
end;

procedure TdtpTextBaseShape.SetVertAlign(const Value: TVerticalAlignment);
begin
  if FVertAlign <> Value then
  begin
    AddCmdToUndo(cmdSetProp, 'VertAlign', integer(FVertAlign));
    FVertAlign := Value;
    CalculateSpanPositions;
    Regenerate;
    Changed;
  end;
end;

procedure TdtpTextBaseShape.SetWordSpacing(const Value: single);
begin
  if FWordSpacing <> Value then
  begin
    AddCmdToUndo(cmdSetProp, 'WordSpacing', FWordSpacing);
    FWordSpacing := Value;
    DoModification;
  end;
end;

procedure TdtpTextBaseShape.SetWordWrap(const Value: boolean);
begin
  if FWordWrap <> Value then
  begin
    AddCmdToUndo(cmdSetProp, 'WordWrap', FWordWrap);
    FWordWrap := Value;
    if Value then   // changed by J.F. Feb 2011
    begin           // make sure values for WordWrap are properly set
      PreserveAspect := False;
      FAllowFontSizing := False;
      AutoSize := True;
    end;
    DoModification;
    Changed;
  end;
end;

{ TdtpTextShape }

{$ifndef usePolygonText}

procedure TdtpTextShape.CalculateCaretPositionsOfSpan(ASpan: TdtpTextSpan; ADpm: single);
var
  i: integer;
  AText: widestring;
  Headroom: single;
begin
  AText := ASpan.Text;
  if length(AText) = 0 then
    exit;

  // Fit into span
  FitTextIntoSpan(StockBitmap, AText, ASpan, ADpm, Headroom);

  // Repeatedly find text extent, use as caret position
  for i := ASpan.CharCount - 1 downto 0 do
  begin
    // Text extent on render bitmap, converted to document units (divide by RenderDpm)
    FCaretPositions[ASpan.CharPos + i].X := StockBitmap.TextExtentW(AText).cx / ADpm + Headroom;
    // shorten widestring
    SetLength(AText, i);
  end;

  // 0th caret pos is at left side
  FCaretPositions[ASpan.CharPos - 1].X := Headroom;
end;

constructor TdtpTextShape.Create;
begin
  inherited;
  // We need this because the Paint method must clear the bitmap to work with
  // the GDI calls
  MustCache := True;
end;

procedure TdtpTextShape.FitTextIntoSpan(DIB: TdtpBitmap; const AText: widestring; ASpan: TdtpTextSpan; ADpm: single;
  var Headroom: single);
var
  ASize: TSize;
  ASpanWidth, ASpanHeight: single;
begin
  ASize := DIB.TextExtentW(AText);

  // Use the size in pixels on the render bitmap
  ASpanWidth := ASpan.Width * ADpm;
  ASpanHeight := ASpan.Height * ADpm;

  // Check size
  if (ASize.cx > ASpanWidth) or (ASize.cy > ASpanHeight) then
  begin
    // Decrease size if neccesary
    while (abs(Dib.Font.Height) > 0) and ((ASize.cx > ASpanWidth) or (ASize.cy > ASpanHeight)) do
    begin
      DIB.Font.Height := - (abs(DIB.Font.Height) - 1);
      ASize := DIB.TextExtentW(AText);
    end;
  end else
  begin
    // Increase size while we can
    if (ASize.cx < ASpanWidth) and (ASize.cy < ASpanHeight) then
    begin
      while (ASize.cx < ASpanWidth) and (ASize.cy < ASpanHeight) do
      begin
        DIB.Font.Height := - (abs(DIB.Font.Height) + 1);
        ASize := DIB.TextExtentW(AText);
      end;
      DIB.Font.Height := - (abs(DIB.Font.Height) - 1);
    end;
  end;
  // Determine additional headroom
  ASize := DIB.TextExtentW(AText);
  Headroom := (ASpanWidth  - ASize.cx) / ADpm;
  case Alignment of
  taLeftJustify: Headroom := 0;
  taCenter:      Headroom := Headroom / 2;
  end;// case

end;

procedure TdtpTextShape.GetTextExtent(APos, ALength: integer; var AWidth, AHeight: double);
var
  ASize: TSize;
  TestSize: TSize; // added by JF
begin
  // Get the text extent "device independently"
  TestSize := StockBitmap.TextExtentW('W'); // changed by JF Apr 2011

  ASize := StockBitmap.TextExtentW(copyWide(Text, APos, ALength));
  if ASize.cx < TestSize.cx then
    // added by JF: give it an minimal acceptable visual width
    // We used a fontheight of 5x height value, so here we divide by 5 again
    ASize := TestSize;

  AWidth := ASize.cx / c300Dpi;
  AHeight := ASize.cy / c300Dpi;
end;

procedure TdtpTextShape.PaintDib(Dib: TdtpBitmap; const Device: TDeviceContext);
// Here we paint the text on the DIB
var
  i: integer;
  ASpan: TdtpTextSpan;
  AText: widestring;
  P1, P2: TPoint;
  AFgColor: TdtpColor;
  P: PdtpColor;
  Headroom: single;
begin
  DIB.Clear($00000000);

  DIB.Font.PixelsPerInch := cFontPixelsPerInch;
  DIB.Font.Name := FontName;
  DIB.Font.Color := clWhite;
  DIB.Font.Style := FontStyle;
  DIB.Font.Height := round(FFontHeight * Device.ActualDpm);

  // Loop through spans
  for i := 0 to SpanCount - 1 do
  begin
    ASpan := Spans[i];
    AText := ASpan.Text;
    if length(AText) = 0 then
      continue;

    // Fit into span
    FitTextIntoSpan(DIB, AText, ASpan, Device.ActualDpm, Headroom);

    // Now output the text
    P1 := ShapeToPoint(dtpPoint(ASpan.Left + Headroom, ASpan.Top));
    P2 := ShapeToPoint(dtpPoint(ASpan.Left + Headroom + ASpan.Width, ASpan.Top + ASpan.Height));
    if cDefaultUseUnicode then
      DIB.TextOutW(Rect(P1.X, P1.Y, P2.X, P2.Y), DT_NOPREFIX, AText)
    else
      DIB.TextOut(Rect(P1.X, P1.Y, P2.X, P2.Y), DT_NOPREFIX, AText)
  end;

  // The text is drawn in the alpha channel, use that and the foreground color
  AFgColor := dtpColor(FFontColor) and $00FFFFFF;
  P := @DIB.Bits[0];
  for i := 0 to DIB.Width * DIB.Height - 1 do
  begin
    P^ := P^ shl 24 + AFgColor;
    inc(P);
  end;

end;

procedure TdtpTextShape.PrepareCaretPositionCalculation(ADpm: single);
begin
  Stockbitmap.Font.PixelsPerInch := cFontPixelsPerInch;
  StockBitmap.Font.Name   := FontName;
  StockBitmap.Font.Style  := FFontStyle;
  // Device-dependent font
  StockBitmap.Font.Height := -round(FFontHeight * ADpm);
  StockBitmap.UpdateFont;
end;

procedure TdtpTextShape.PrepareTextExtent;
begin
  // Set the stockbitmap's font to the font params
  Stockbitmap.Font.PixelsPerInch := cFontPixelsPerInch;
  StockBitmap.Font.Name   := FontName;
  // assume a "device independent" 5 pixels per mm
  StockBitmap.Font.Height := -round(FFontHeight * c300Dpi);
  StockBitmap.Font.Style  := FFontStyle;
  StockBitmap.UpdateFont;
end;

{$endif}

{ TdtpTextSpan }

constructor TdtpTextSpan.Create(AParent: TdtpTextBaseShape);
begin
  inherited Create;
  FParent := AParent;
end;

function TdtpTextSpan.GetText: widestring;
begin
  if assigned(FParent) then
    Result := CopyWide(FParent.Text, CharPos, CharCount)
  else
    Result := '';
end;

procedure TdtpTextSpan.LoadFromXml(ANode: TXmlNodeOld);
begin
  FCharPos := ANode.ReadInteger('CharPos');
  FCharCount := ANode.ReadInteger('CharCount');
  FWidth := ANode.ReadFloat('Width');
  FHeight := ANode.ReadFloat('Height');
end;

procedure TdtpTextSpan.SaveToXml(ANode: TXmlNodeOld);
begin
  ANode.WriteInteger('CharPos', FCharPos);
  ANode.WriteInteger('CharCount', FCharCount);
  ANode.WriteFloat('Width', FWidth);
  ANode.WriteFloat('Height', FHeight);
end;

procedure TdtpTextSpan.SetSize(AWidth, AHeight: single);
begin
  FWidth := AWidth;
  FHeight := AHeight;
end;

initialization
  // Register ourselves

{$ifdef usePolygonText}
  // this relays old text shapes to new TdtpPolygonText
  RegisterShapeClass(TdtpPolygonText, 'TdtpTextShape');
{$else}
  RegisterShapeClass(TdtpTextShape);
{$endif}


  // Create a stockbitmap we'll use for determining text size
  StockBitmap := TdtpBitmap.Create;
  StockBitmap.SetSize(8, 8);

finalization

  FreeAndNil(StockBitmap);

end.
