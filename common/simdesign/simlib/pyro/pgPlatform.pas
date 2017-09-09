{ pgPlatform.pas:

  Platform-dependent functions used by the Pyro library.
  - methods for scrolling / virtual scrollbar
  - methods for truetype font processing

  Windows platform: define usewindows


  Author: Nils Haeck
  Date: 11jun2011
  copyright (c) 2011 SimDesign BV (www.simdesign.nl)
}

{$define usewindows}

unit pgPlatform;

interface

uses
{$ifdef usewindows}
  Windows, FLATSB,
{$endif usewindows}
  Pyro;

{$ifdef usewindows}
type
  HDC = Windows.HDC;

const
  pgSB_HORZ = SB_HORZ;
  pgSB_VERT = SB_VERT;

  pgVK_LEFT = VK_LEFT;
  pgVK_RIGHT = VK_RIGHT;
  pgVK_UP = VK_UP;
  pgVK_DOWN = VK_DOWN;
  pgVK_MENU = VK_MENU;
  pgVK_ESCAPE = VK_ESCAPE;
  pgVK_DELETE = VK_DELETE;

  pgWS_BORDER = WS_BORDER;
  pgWS_EX_CLIENTEDGE = WS_EX_CLIENTEDGE;

  pgCS_HREDRAW = CS_HREDRAW;
  pgCS_VREDRAW = CS_VREDRAW;

  pgSB_LINEUP = SB_LINEUP;
  pgSB_LINEDOWN = SB_LINEDOWN;
  pgSB_PAGEUP = SB_PAGEUP;
  pgSB_PAGEDOWN = SB_PAGEDOWN;
  pgSB_THUMBPOSITION = SB_THUMBPOSITION;
  pgSB_THUMBTRACK = SB_THUMBTRACK;
  pgSB_TOP = SB_TOP;
  pgSB_BOTTOM = SB_BOTTOM;
  pgSB_ENDSCROLL = SB_ENDSCROLL;

  pgSIF_ALL = SIF_ALL;

  pgSRCCOPY = SRCCOPY;

  pgMK_SHIFT = MK_SHIFT;
  pgMK_CONTROL = MK_CONTROL;
  pgMK_LBUTTON = MK_LBUTTON;
  pgMK_MBUTTON = MK_MBUTTON;
  pgMK_RBUTTON = MK_RBUTTON;

  pgGGO_NATIVE = GGO_NATIVE;

  pgTT_POLYGON_TYPE = TT_POLYGON_TYPE;

  pgTT_PRIM_LINE = TT_PRIM_LINE;
  pgTT_PRIM_QSPLINE = TT_PRIM_QSPLINE;

  pgLF_FACESIZE = LF_FACESIZE;

  pgOUT_TT_ONLY_PRECIS = OUT_TT_ONLY_PRECIS;
  pgANTIALIASED_QUALITY = ANTIALIASED_QUALITY;

  pgRGN_AND = RGN_AND;
  pgTA_BASELINE = TA_BASELINE;

  pgGDI_ERROR = GDI_ERROR;

{$endif usewindows}
type

{ for scrolling }

  TpgScrollInfo = packed record
    cbSize: longword;
    fMask: longword;
    nMin: Integer;
    nMax: Integer;
    nPage: longword;
    nPos: Integer;
    nTrackPos: Integer;
  end;

{ for truetype processing }

  TpgFixedR = packed record
    fract: Word;
    value: SmallInt;
  end;

  TpgPointFX = packed record
    x: TpgFixedR;
    y: TpgFixedR;
  end;

  TpgTTPolygonHeader = packed record
    cb: longword;
    dwType: longword;
    pfxStart: TpgPointFX;
  end;
  PpgTTPolygonHeader = ^TpgTTPolygonHeader;

  TpgTTPolyCurve = packed record
    wType: Word;
    cpfx: Word;
    apfx: array[0..0] of TpgPointFX;
  end;
  PpgTTPolyCurve = ^TpgTTPolyCurve;

  TpgGlyphMetrics = packed record
    gmBlackBoxX: longword;
    gmBlackBoxY: longword;
    gmptGlyphOrigin: TpgiPoint;
    gmCellIncX: SmallInt;
    gmCellIncY: SmallInt;
  end;

  TpgMat2 = packed record
    eM11: TpgFixedR;
    eM12: TpgFixedR;
    eM21: TpgFixedR;
    eM22: TpgFixedR;
  end;

  TpgKerningPair = packed record
    wFirst: Word;
    wSecond: Word;
    iKernAmount: Integer;
  end;

  TpgLogFontA = packed record
    lfHeight: integer;
    lfWidth: integer;
    lfEscapement: integer;
    lfOrientation: integer;
    lfWeight: integer;
    lfItalic: Byte;
    lfUnderline: Byte;
    lfStrikeOut: Byte;
    lfCharSet: Byte;
    lfOutPrecision: Byte;
    lfClipPrecision: Byte;
    lfQuality: Byte;
    lfPitchAndFamily: Byte;
    lfFaceName: array[0..pgLF_FACESIZE - 1] of AnsiChar;
  end;

{ for GDI }

  TpgSizeR = packed record
    cx: Longint;
    cy: Longint;
  end;

// function pgGetClipBox retrieves the dimensions of the tightest bounding rectangle
// that can be drawn around the current visible area on the device. The visible area
// is defined by the current clipping region or clip path, as well as any overlapping windows.
function pgGetClipBox(DC: longword; var Rect: TpgRect): integer;

// function pgGetTickCount retrieves the number of milliseconds that have elapsed
// since Windows was started. No parameters. Note: The elapsed time is stored as a
// longword value. Therefore, the time will wrap around to zero if Windows is run
// continuously for 49.7 days.
function pgGetTickCount: longword;

// function pgLoadCursor loads the specified cursor resource from the
// executable (.EXE) file associated with an application instance
function pgLoadCursor(hInstance: cardinal; lpCursorName: PAnsiChar): longword;

// function pgGetStockObject retrieves a handle to one of the predefined stock pens,
// brushes, fonts, or palettes.
function pgGetStockObject(fnObject: integer): longword;

// function pgGetCurrentThreadId returns the thread identifier of the calling thread.
function pgGetCurrentThreadId: longword;

// function pgScrollWindow function scrolls the content of the specified window's client area.
function pgScrollWindow(hWnd: cardinal; XAmount, YAmount: integer; ARect, AClipRect: PpgRect): boolean;

// function pgSetScrollInfo sets the parameters of a scroll bar, including
// the minimum and maximum scrolling positions, the page size, and the position
// of the scroll box (thumb). The function also redraws the scroll bar, if requested.
function pgSetScrollInfo(hWnd: cardinal; BarFlag: Integer; const ScrollInfo: TpgScrollInfo; Redraw: boolean): Integer;

// The pgGetScrollPos function retrieves the current position of the scroll box (thumb)
// in the specified scroll bar. The current position is a relative value that depends
// on the current scrolling range.
function pgGetScrollPos(hWnd: cardinal; nBar: Integer): Integer;

// function pgSetScrollPos sets the position of the scroll box (thumb) in the specified
// scroll bar and, if requested, redraws the scroll bar to reflect the new position of the scroll box.
function pgSetScrollPos(hWnd: cardinal; nBar, nPos: Integer; bRedraw: boolean): Integer;

// function pgSetWindowOrgEx sets the window origin of the device context by using
// the specified coordinates.
function pgSetWindowOrgEx(DC: longword; X, Y: integer; Point: PpgiPoint): boolean;

// function pgBitBlt performs a bit-block transfer of the color data corresponding
// to a rectangle of pixels from the specified source device context into a destination
// device context.
function pgBitBlt(DestDC: longword; X, Y, Width, Height: integer; SrcDC: longword;
  XSrc, YSrc: integer; Rop: cardinal): boolean;

// function pgInvalidateRect adds a rectangle to the specified window's update region.
// The update region represents the portion of the window's client area that must be redrawn.
function pgInvalidateRect(hWnd: cardinal; lpRect: PpgRect; bErase: boolean): boolean;

// function pgGetKeyState retrieves the status of the specified virtual key. The status
// specifies whether the key is up, down, or toggled (on, off alternating each time
// the key is pressed).
function pgGetKeyState(nVirtKey: integer): SmallInt;

// function pgCreateCompatibleDC creates a memory device context (DC) compatible
// with the specified device.
function pgCreateCompatibleDC(DC: longword): longword;

// function pgSelectObject selects an object into the specified device context.
// The new object replaces the previous object of the same type.
function pgSelectObject(DC: longword; p2: cardinal): cardinal;

// function pgDeleteObject deletes a logical pen, brush, font, bitmap, region, or palette,
// freeing all system resources associated with the object. After the object is deleted,
// the specified handle is no longer valid.
function pgDeleteObject(p1: cardinal): boolean;

// function pgDeleteDC deletes the specified device context (DC).
function pgDeleteDC(DC: longword): boolean;

// function pgGetGlyphOutlineW retrieves the outline or bitmap for a character in the
// TrueType font that is selected into the specified device context.
function pgGetGlyphOutlineW(DC: longword; uChar: cardinal; uFormat: cardinal;
  const lpgm: TpgGlyphMetrics; cbBuffer: cardinal; lpvbuffer: pointer; const lpmat2: TpgMat2): cardinal;

// function pgGetKerningPairs retrieves the character-kerning pairs for the currently
// selected font for the specified device context.
function pgGetKerningPairs(DC: longword; Count: cardinal; var KerningPairs): cardinal;

// function pgCreateFontIndirect creates a logical font that has the characteristics
// specified in the specified structure. The font can subsequently be selected as the
// current font for any device context.
function pgCreateFontIndirect(const p1: TpgLogFontA): cardinal;

// function pgBeginPath opens a path bracket in the specified device context.
function pgBeginPath(DC: longword): boolean;

// function pgPolygon draws a polygon consisting of two or more vertices connected
// by straight lines. The polygon is outlined by using the current pen and filled by
// using the current brush and polygon fill mode.
function pgPolygon(DC: longword; var Points; Count: integer): boolean;

// function pgEndPath closes a path bracket and selects the path defined by the
// bracket into the specified device context.
function pgEndPath(DC: longword): boolean;

// function pgSelectClipPath selects the current path as a clipping region for a
// device context, combining the new region with any existing clipping region by
// using the specified mode.
function pgSelectClipPath(DC: longword; Mode: integer): boolean;

// function pgSetTextAlign sets the text-alignment flags for the specified device context.
function pgSetTextAlign(DC: longword; Flags: cardinal): cardinal;

// function pgPlgBlt performs a bit-block transfer of the bits of color data from the
// specified rectangle in the source device context to the specified parallelogram
// in the destination device context. If the given bitmask handle identifies a valid
// monochrome bitmap, the function uses this bitmap to mask the bits of color data from
// the source rectangle.
function pgPlgBlt(DestDC: longword; const PointsArray; SrcDC: longword; XSrc, YSrc, Width, Height: integer;
  Mask: cardinal; XMask, YMask: integer): boolean;

// function pgRestoreDC restores a device context (DC) to the specified state.
// The device context is restored by popping state information off a stack created
// by earlier calls to the SaveDC function.
function pgRestoreDC(DC: longword; SavedDC: integer): boolean;

// function pgSaveDC saves the current state of the specified device context (DC)
// by copying data describing selected objects and graphic modes (such as the bitmap,
// brush, palette, font, pen, region, drawing mode, and mapping mode) to a context stack.
function pgSaveDC(DC: longword): integer;

implementation

{$ifdef usewindows}
function pgGetClipBox(DC: longword; var Rect: TpgRect): integer;
begin
  Result := GetClipBox(DC, TRect(Rect));
end;

function pgGetTickCount: longword;
begin
  Result := GetTickCount;
end;

function pgLoadCursor(hInstance: cardinal; lpCursorName: PAnsiChar): longword;
begin
  Result := LoadCursor(hInstance, lpCursorName);
end;

function pgGetStockObject(fnObject: integer): longword;
begin
  Result := GetStockObject(fnObject);
end;

function pgGetCurrentThreadId: longword;
begin
  Result := GetCurrentThreadId;
end;

function pgScrollWindow(hWnd: cardinal; XAmount, YAmount: integer; ARect, AClipRect: PpgRect): boolean;
begin
  Result := ScrollWindow(hWnd, XAmount, YAmount, PRect(ARect), PRect(AClipRect));
end;

function pgSetScrollInfo(hWnd: cardinal; BarFlag: Integer; const ScrollInfo: TpgScrollInfo; Redraw: boolean): Integer;
begin
  Result := FlatSB_SetScrollInfo(hWnd, BarFlag, tagScrollInfo(ScrollInfo), Redraw);
end;

function pgGetScrollPos(hWnd: cardinal; nBar: Integer): Integer;
begin
  Result := FlatSB_GetScrollPos(hWnd, nBar);
end;

function pgSetScrollPos(hWnd: cardinal; nBar, nPos: Integer; bRedraw: boolean): Integer;
begin
  Result := FlatSB_SetScrollPos(hWnd, nBar, nPos, bRedraw);
end;

function pgSetWindowOrgEx(DC: longword; X, Y: integer; Point: PpgiPoint): boolean;
begin
  Result := SetWindowOrgEx(DC, X, Y, PPoint(Point));
end;

function pgBitBlt(DestDC: longword; X, Y, Width, Height: integer; SrcDC: longword;
  XSrc, YSrc: integer; Rop: cardinal): boolean;
begin
  Result := BitBlt(DestDC, X, Y, Width, Height, SrcDC, XSrc, YSrc, Rop);
end;

function pgInvalidateRect(hWnd: cardinal; lpRect: PpgRect; bErase: boolean): boolean;
begin
  Result := InvalidateRect(hWnd, PRect(lpRect), bErase);
end;

function pgGetKeyState(nVirtKey: integer): SmallInt;
begin
  Result := GetKeyState(nVirtKey);
end;

function pgCreateCompatibleDC(DC: cardinal): cardinal;
begin
  Result := CreateCompatibleDC(DC);
end;

function pgSelectObject(DC: longword; p2: cardinal): cardinal;
begin
  Result := SelectObject(DC, p2);
end;

function pgDeleteObject(p1: cardinal): boolean;
begin
  Result := DeleteObject(p1);
end;

function pgDeleteDC(DC: longword): boolean;
begin
  Result := DeleteDC(DC);
end;

function pgGetGlyphOutlineW(DC: longword; uChar: cardinal; uFormat: cardinal;
  const lpgm: TpgGlyphMetrics; cbBuffer: cardinal; lpvbuffer: pointer; const lpmat2: TpgMat2): cardinal;
begin
  Result := GetGlyphOutlineW(DC, uChar, uFormat, _GLYPHMETRICS(lpgm), cbBuffer, lpvbuffer, _MAT2(lpmat2));
end;

function pgGetKerningPairs(DC: longword; Count: cardinal; var KerningPairs): cardinal;
begin
  Result := GetKerningPairs(DC, Count, KerningPairs);
end;

function pgCreateFontIndirect(const p1: TpgLogFontA): cardinal;
begin
  Result := CreateFontIndirectA(tagLOGFONTA(p1));
end;

function pgBeginPath(DC: longword): boolean;
begin
  Result := BeginPath(DC);
end;

function pgPolygon(DC: longword; var Points; Count: integer): boolean;
begin
  Result := Polygon(DC, Points, Count);
end;

function pgEndPath(DC: longword): boolean;
begin
  Result := EndPath(DC);
end;

function pgSelectClipPath(DC: longword; Mode: integer): boolean;
begin
  Result := SelectClipPath(DC, Mode);
end;

function pgSetTextAlign(DC: longword; Flags: cardinal): cardinal;
begin
  Result := SetTextAlign(DC, Flags);
end;

function pgPlgBlt(DestDC: longword; const PointsArray; SrcDC: longword; XSrc, YSrc, Width, Height: integer;
  Mask: cardinal; XMask, YMask: integer): boolean;
begin
  Result := PlgBlt(DestDC, PointsArray, SrcDC, XSrc, YSrc, Width, Height, Mask, XMask, YMask);
end;

function pgRestoreDC(DC: longword; SavedDC: integer): boolean;
begin
  Result := RestoreDC(DC, SavedDC);
end;

function pgSaveDC(DC: longword): integer;
begin
  Result := SaveDC(DC);
end;
{$endif usewindows}

end.
