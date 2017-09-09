unit u_dzGraphicsUtils;

interface

uses
  Windows,
  Types,
  SysUtils,
  Graphics,
  u_dzTranslator;

///<summary> Returns the Rect's width </summary>
function TRect_Width(_Rect: TRect): Integer; inline;

///<summary> Returns the Rect's height </summary>
function TRect_Height(_Rect: TRect): Integer; inline;

///<summary> Returns the bounding box of the active clipping region </summary>
function TCanvas_GetClipRect(_Canvas: TCanvas): TRect;
///<summary> Sets a clipping rect, returns true, if the region is not empty, false if it is empty </summary>
function TCanvas_SetClipRect(_Canvas: TCanvas; _Rect: TRect): Boolean;

type
  TDrawTextFlags = (
    dtfLeft, dtfRight, dtfCenter, // horizontal alignment
    dtfWordBreak, // Breaks words. Lines are automatically broken between words if a word would
                  // extend past the edge of the rectangle specified by the lpRect parameter.
                  // A carriage return-line feed sequence also breaks the line.
                  // If this is not specified, output is on one line.
    dtfCalcRect, // Determines the width and height of the rectangle. If there are multiple lines
                 // of text, DrawText uses the width of the rectangle pointed to by the lpRect
                 // parameter and extends the base of the rectangle to bound the last line of text.
                 // If the largest word is wider than the rectangle, the width is expanded.
                 // If the text is less than the width of the rectangle, the width is reduced.
                 // If there is only one line of text, DrawText modifies the right side of the
                 // rectangle so that it bounds the last character in the line. In either case,
                 // DrawText returns the height of the formatted text but does not draw the text.
    dtfNoClip); // draw without clipping (slightly faster)
// not implemented:
//    dtfSingleLine, // only print as single line (ignore line breaks)
//    dtfTopSingle, dtfBottomSingle, dtfVCenterSingle, // vertical alignment, only if dtfSingleLine is given
//    dtfPathEllipsis, // replace characters in the middle of the string with ellipses ('...') so that
                     // the result fits in the specified rectangle. If the string contains backslash
                     // (\) characters, preserves as much as possible of the text after the last backslash.
//    dtfEndEllipsis, // if the end of a string does not fit in the rectangle, it is truncated and
                    // ellipses ('...') are added. If a word that is not at the end of the string
                    // goes beyond the limits of the rectangle, it is truncated without ellipses.
                    // (Unless dtfWordEllipsis is also specified.)
//    dtfWordEllipsis, // Truncates any word that does not fit in the rectangle and adds ellipses ('...').
//    dtfModifyStringEllipsis, // if given, together with one of the dtfXxxEllipsis flags, the
                             // string is modified to matcht the output.
//    dtfEditControl,
//    dtfExpandTabs, dtfExternalLeading, dtfHidePrefix, dtfInternal,
//    dtfNoFullWidthCharBreak, dtfNoPrefix,
//    dtfPrefixOnly, dtRtlReading, dtfTabStop,
  TDrawTextFlagSet = set of TDrawTextFlags;

///<summary>
/// Calculates the Rect necessary for drawing the text.
/// @returns the calculated height </summary>
function TCanvas_DrawText(_Canvas: TCanvas; const _Text: string; var _Rect: TRect; _Flags: TDrawTextFlagSet): Integer;

///<summary> calls Windows.SaveDC and returns an interface which will automatically call
///          Windows.RestoreDC when destroyed </summary>
function TCanvas_SaveDC(_Canvas: TCanvas): IInterface;

///<summary> abbreviation for StretchBlt that takes TRect </summary>
function dzStretchBlt(_DestHandle: Hdc; _DestRect: TRect; _SrcHandle: Hdc; _SrcRect: TRect; _Rop: DWORD): LongBool; inline; overload;

///<summary> abbreviation for StretchBlt that takes TRect and TBitmap </summary>
function dzStretchBlt(_DestHandle: Hdc; _DestRect: TRect; _Src: TBitmap; _Rop: DWORD): LongBool; inline; overload;

///<summary> abbreviation for StretchBlt that takes TPoint and TBitmap </summary>
function dzStretchBlt(_DestHandle: Hdc; _DestPos: TPoint; _Src: TBitmap; _Rop: DWORD): LongBool; inline; overload;

///<summary> abbreviation for BitBlt that takes TRect and TBitmap </summary>
function dzBitBlt(_DestHandle: Hdc; _DestRect: TRect; _Src: TBitmap; _Rop: DWORD): LongBool; inline; overload;

implementation

function _(const _s: string): string; inline;
begin
  Result := dzDGetText(_s, 'dzlib');
end;

function TRect_Width(_Rect: TRect): Integer; inline;
begin
  Result := _Rect.Right - _Rect.Left;
end;

function TRect_Height(_Rect: TRect): Integer; inline;
begin
  Result := _Rect.Bottom - _Rect.Top;
end;

function dzStretchBlt(_DestHandle: Hdc; _DestRect: TRect; _SrcHandle: Hdc; _SrcRect: TRect; _Rop: DWORD): LongBool;
begin
  Result := StretchBlt(_DestHandle, _DestRect.Left, _DestRect.Top, TRect_Width(_DestRect), TRect_Height(_DestRect),
    _SrcHandle, _SrcRect.Left, _SrcRect.Top, TRect_Width(_SrcRect), TRect_Height(_SrcRect), _Rop);
end;

function dzStretchBlt(_DestHandle: Hdc; _DestRect: TRect; _Src: TBitmap; _Rop: DWORD): LongBool;
begin
  Result := StretchBlt(_DestHandle, _DestRect.Left, _DestRect.Top, TRect_Width(_DestRect), TRect_Height(_DestRect),
    _Src.Canvas.Handle, 0, 0, _Src.Width, _Src.Height, _Rop);
end;

function dzStretchBlt(_DestHandle: Hdc; _DestPos: TPoint; _Src: TBitmap; _Rop: DWORD): LongBool;
begin
  Result := StretchBlt(_DestHandle, _DestPos.X, _DestPos.Y, _Src.Width, _Src.Height,
    _Src.Canvas.Handle, 0, 0, _Src.Width, _Src.Height, _Rop);
end;

function dzBitBlt(_DestHandle: Hdc; _DestRect: TRect; _Src: TBitmap; _Rop: DWORD): LongBool;
begin
  Result := BitBlt(_DestHandle, _DestRect.Left, _DestRect.Top, _DestRect.Right, _DestRect.Bottom,
    _Src.Canvas.Handle, 0, 0, SRCCOPY);
end;

function TCanvas_GetClipRect(_Canvas: TCanvas): TRect;
var
  RGN: THandle;
  Res: Integer;
begin
  RGN := CreateRectRgn(0, 0, 0, 0);
  if RGN = 0 then
    raise Exception.Create(_('CreateRectRgn failed'));
  try
    Res := GetClipRgn(_Canvas.Handle, RGN);
    if Res = -1 then
      raise Exception.Create(_('GetClipRgn failed'));
    GetRgnBox(RGN, Result);
  finally
    DeleteObject(RGN);
  end;
end;

function TCanvas_SetClipRect(_Canvas: TCanvas; _Rect: TRect): Boolean;
var
  RGN: THandle;
  Res: Integer;
begin
  Result := False;
  RGN := CreateRectRgn(_Rect.Left, _Rect.Top, _Rect.Right, _Rect.Bottom);
  if RGN = 0 then
    raise Exception.Create(_('CreateRectRgn failed'));
  try
    Res := SelectClipRgn(_Canvas.Handle, RGN);
    if Res = Error then
      raise Exception.Create(_('SelectClipRgn failed'));
    Result := (Res <> NULLREGION);
  finally
    DeleteObject(RGN);
  end;
end;

function TCanvas_DrawText(_Canvas: TCanvas; const _Text: string; var _Rect: TRect; _Flags: TDrawTextFlagSet): Integer;
var
  Flags: LongWord;
begin
  Flags := 0;
  if dtfLeft in _Flags then
    Flags := Flags or DT_LEFT;
  if dtfRight in _Flags then
    Flags := Flags or DT_RIGHT;
  if dtfCenter in _Flags then
    Flags := Flags or DT_CENTER;
  if dtfWordBreak in _Flags then
    Flags := Flags or DT_WORDBREAK;
  if dtfNoClip in _Flags then
    Flags := Flags or DT_NOCLIP;
  if dtfCalcRect in _Flags then
    Flags := Flags or DT_CALCRECT;
  Result := Windows.DrawText(_Canvas.Handle, PChar(_Text), -1, _Rect, Flags);
end;

type
  TCanvasSaveDC = class(TInterfacedObject)
  private
    FCanvas: TCanvas;
    FSavedDC: Integer;
  public
    constructor Create(_Canvas: TCanvas; _SavedDC: Integer);
    destructor Destroy; override;
  end;

{ TCanvasSaveDC }

constructor TCanvasSaveDC.Create(_Canvas: TCanvas; _SavedDC: Integer);
begin
  inherited Create;
  FCanvas := _Canvas;
  FSavedDC := _SavedDC;
end;

destructor TCanvasSaveDC.Destroy;
begin
  Windows.RestoreDC(FCanvas.Handle, FSavedDC);
  inherited;
end;

function TCanvas_SaveDC(_Canvas: TCanvas): IInterface;
var
  SavedDC: Integer;
begin
  SavedDC := Windows.SaveDC(_Canvas.Handle);
  Result := TCanvasSaveDC.Create(_Canvas, SavedDC);
end;

end.

