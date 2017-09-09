{ <b>Project</b>: Pyro<p>

  <b>Author</b>: Nils Haeck (n.haeck@simdesign.nl)<p>
  Copyright (c) 2006 SimDesign BV
}
unit pgBufferScrollbox;

interface

uses
  Classes, SysUtils, Graphics, pgVirtualScrollbox;

type

  TpgPaintBufferEvent = procedure (Sender: TObject; Buffer: TBitmap; ClipRect: TRect) of object;

  // TpgBufferScrollbox uses a 32bits TBitmap as buffer for drawing. The application
  // must draw to the buffer, and the buffer is blitted to the actual canvas.
  TpgBufferScrollbox = class(TpgVirtualScrollbox)
  private
    FClipRect: TRect;
    FBuffer: TBitmap;
    FOnPaintBuffer: TpgPaintBufferEvent;
  protected
    property ClipRect: TRect read FClipRect;
    procedure Paint; override;
    procedure PaintBuffer; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Buffer: TBitmap read FBuffer;
    property OnPaintBuffer: TpgPaintBufferEvent read FOnPaintBuffer write FOnPaintBuffer;
  end;

implementation

{ TpgBufferScrollbox }

constructor TpgBufferScrollbox.Create(AOwner: TComponent);
begin
  inherited;
  FBuffer := TBitmap.Create;
  FBuffer.PixelFormat := pf32bit;
end;

destructor TpgBufferScrollbox.Destroy;
begin
  FreeAndNil(FBuffer);
  inherited;
end;

procedure TpgBufferScrollbox.Paint;
begin
  // Check buffer size
  if (FBuffer.Width <> Width) or (FBuffer.Height <> Height) then begin
    FBuffer.Width := Width;
    FBuffer.Height := Height;
  end;

  // Clipping rectangle
  FClipRect := Canvas.ClipRect;
  if IsRectEmpty(FClipRect) then exit;

  // Paint the buffer
  PaintBuffer;

  // Copy buffer to the control's canvas
  BitBlt(
    Canvas.Handle,
    FClipRect.Left, FClipRect.Top,
    FClipRect.Right - FClipRect.Left, FClipRect.Bottom - FClipRect.Top,
    FBuffer.Canvas.Handle,
    FClipRect.Left, FClipRect.Top, SRCCOPY);

end;

procedure TpgBufferScrollbox.PaintBuffer;
// Default paints the background around scrollbox on the buffer.
// Override this method in descendants. Call "inherited" if you want to automatically
// clear the area that is outside of the scrollbox.
begin
  PaintBackground(FBuffer.Canvas, FClipRect);
  // Call event
  if assigned(FOnPaintBuffer) then FOnPaintBuffer(Self, FBuffer, FClipRect);
end;

end.
