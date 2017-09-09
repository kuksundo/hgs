{ unit Viewers

  The control showing the fullscreen version of an image

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!
}
unit guiViewer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, SyncObjs, ItemLists, RxConst, Math, sdAbcVars, sdAbcFunctions;

type

  TGetResampleEvent = procedure(Sender: TObject; AWidth, AHeight: integer;
    AResample: TBitmap; var ASuccess: boolean) of object;

  TViewer = class(TFrame)
    pbPicture: TPaintBox;
    procedure pbPicturePaint(Sender: TObject);
    procedure Initialize(Sender: TObject);
    procedure Finalize(Sender: TObject);
    procedure WMEraseBkgnd(var m: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure pbPictureMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pbPictureMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbPictureMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FBackground: TPicture;
    FBuffer: TBitmap;
    FDragX,
    FDragY: integer;
    FGrowToFit: boolean;
    FInvalidBuffer: boolean;
    FIsDragging: boolean;
    FIsResizing: boolean;
    FLock: TCriticalSection;
    FMouseX,
    FMouseY: integer;
    FPicture: TPicture;
    FPosX,
    FPosY: integer;
    FScale: double;
    FScaled: TBitmap;
    FShrinkToFit: boolean;
    FWasDragging: boolean;
    FZoomFit: boolean;
    FOnGetResample: TGetResampleEvent;
    FOnStatus: TStatusMessageEvent;
  protected
    function AllowDragging: boolean;
    procedure CreateBuffer;
    procedure CreateScaled(UseHQSampling: boolean);
    procedure DoStatus(AMessage: string);
    function InsidePicture(X, Y: integer): boolean;
    procedure LockBuffer;
    procedure ScaleImage(AValue: double);
    procedure ScaleTo(AWidth, AHeight: integer; UseHQSampling: boolean);
    procedure SetBackground(const AValue: TPicture);
    procedure SetGrowToFit(AValue: boolean);
    procedure SetInvalidBuffer(AValue: boolean);
    procedure SetIsDragging(AValue: boolean);
    procedure SetIsResizing(AValue: boolean);
    procedure SetPicture(const AValue: TPicture);
    procedure SetScale(AValue: double);
    procedure SetScaled(AValue: TBitmap);
    procedure SetShrinkToFit(AValue: boolean);
    procedure UnlockBuffer;
  public
    property Background: TPicture write SetBackground;
    property GrowToFit: boolean read FGrowToFit write SetGrowToFit;
    property InvalidBuffer: boolean read FInvalidBuffer write SetInvalidBuffer;
    property IsDragging: boolean read FIsDragging write SetIsDragging;
    property IsResizing: boolean read FIsResizing write SetIsResizing;
    property Picture: TPicture read FPicture write SetPicture;
    property Scale: double read FScale write SetScale;
    property Scaled: TBitmap read FScaled write SetScaled;
    property ShrinkToFit: boolean read FShrinkToFit write SetShrinkToFit;
    property WasDragging: boolean read FWasDragging write FWasDragging;
    property OnGetResample: TGetResampleEvent read FOnGetResample write FOnGetResample;
    property OnStatus: TStatusMessageEvent read FOnStatus write FOnStatus;
    procedure DoZoomFit;
    procedure DragImage(DeltaX, DeltaY: integer);
    procedure ExitSizeMove;
  end;

implementation

{$R *.DFM}

{uses
  Utils;}

procedure TViewer.WMEraseBkgnd(var m: TWMEraseBkgnd);
begin
  // No automatic erase of background
  m.Result := LRESULT(False);
end;

procedure TViewer.WMSize(var Message: TWMSize);
begin
  if (not assigned(Self)) or (not assigned(FScaled)) then // ensure bitmap scaled is assigned!
    exit;

  // We must redraw the background and the picture with new fit
  FPosX := (Width  - FScaled.Width ) div 2;
  FPosY := (Height - FScaled.Height) div 2;

  if not IsResizing then
  begin
    if ShrinkToFit or GrowToFit or FZoomFit then
      CreateScaled(False);
    InvalidBuffer := True;
  end;
  Message.Result := 0;

  inherited;
end;

function TViewer.AllowDragging: boolean;
begin
  // Test if we allow the user to drag this picture around in it's frame
  Result := false;
  if assigned(FScaled) and
    ((FScaled.Width > pbPicture.Width) or (FScaled.Height > pbPicture.Height)) then
    Result := True;
end;

procedure TViewer.CreateBuffer;
var
  x, y: integer;
begin
  LockBuffer;
  try

    // Correct buffer size, and force redraw
    FBuffer.Width := pbPicture.Width;
    FBuffer.Height := pbPicture.Height;

    // Draw background
    if assigned(FBackground) and (FBackground.Width > 0) and (FBackground.Height > 0) then
    begin

      // Paint each patch but only if it is not completely behind picture
      Y := 0;
      while Y < Height do
      begin
        X := 0;
        while X < Width do
        begin
          if (X < FPosX) or
             (Y < FPosY) or
             (X + FBackground.Width  > FPosX + FScaled.Width) or
             (Y + FBackground.Height > FPosY + FScaled.Height) then
          begin

            FBuffer.Canvas.Draw(X, Y, FBackground.Graphic);

          end;
          inc(X, FBackground.Width);
        end;
        inc(Y, FBackground.Height);
      end;

    end else
    begin

      // Paint background with inherited color
      FBuffer.Canvas.Brush.Color := Color;
      FBuffer.Canvas.Brush.Style := bsSolid;
      FBuffer.Canvas.FillRect(Rect(0, 0, Width, Height));

    end;

    // Draw the scaled image
    FBuffer.Canvas.Draw(FPosX, FPosY, FScaled);

  finally
    UnlockBuffer;
  end;
end;

procedure TViewer.CreateScaled(UseHQSampling: boolean);
begin
  // Remove scaled version
  FScaled.Width := 0;
  FScaled.Height := 0;
  FScale := 1.0;

  if assigned(FPicture.Graphic) then
  begin

    // Create scaled version
    if (FShrinkToFit and
         ((FPicture.Height > Height) or (FPicture.Width > Width))) or
       (FGrowToFit and
         ((FPicture.Height < Height) and (FPicture.Width < Width))) or
        FZoomFit then
    begin

      // Scaled
      ScaleTo(pbPicture.Width, pbPicture.Height, UseHQSampling);

    end else
    begin

      // Original size
      ScaleTo(FPicture.Width, FPicture.Height, UseHQSampling);

    end;

    FPosX := (Width  - FScaled.Width ) div 2;
    FPosY := (Height - FScaled.Height) div 2;

  end else
  begin

    // No picture
    FScaled.Width := 0;
    FScaled.Height := 0;
    FPosX := 0;
    FPosY := 0;

  end;

  // Make sure to recreate buffer
  InvalidBuffer := True;
end;

procedure TViewer.DoStatus(AMessage: string);
begin
  if assigned(FOnStatus) then
    FOnStatus(Self, AMessage);
end;

procedure TViewer.DragImage(DeltaX, DeltaY: integer);
var
  OldPosX, OldPosY: integer;
begin
  if not assigned(FScaled) then
    exit;

  OldPosX := FPosX;
  OldPosY := FPosY;

  // Move in X
  if (FScaled.Width > pbPicture.Width) and (DeltaX <> 0) then
  begin
    inc(FPosX, DeltaX);
    if FPosX > Max(pbPicture.Width - FScaled.Width, 0) then
      FPosX := Max(pbPicture.Width - FScaled.Width, 0);
    if FPosX < Min(pbPicture.Width - FScaled.Width, 0) then
      FPosX := Min(pbPicture.Width - FScaled.Width, 0);
  end;

  // Move in Y
  if (FScaled.Height > pbPicture.Height) and (DeltaY <> 0) then
  begin
    inc(FPosY, DeltaY);
    if FPosY > Max(pbPicture.Height - FScaled.Height, 0) then
      FPosY := Max(pbPicture.Height - FScaled.Height, 0);
    if FPosY < Min(pbPicture.Height - FScaled.Height, 0) then
      FPosY := Min(pbPicture.Height - FScaled.Height, 0);
  end;

  if (OldPosX <> FPosX) or (OldPosY <> FPosY) then
  begin
    // Reflect changes
    InvalidBuffer := true;
  end;

end;

procedure TViewer.ExitSizeMove;
begin
  // This method is called when the user size/move has finished
  if not IsResizing then
  begin
    if ShrinkToFit or GrowToFit or FZoomFit then
      CreateScaled(True);
    InvalidBuffer := True;
  end;
end;

function TViewer.InsidePicture(X, Y: integer): boolean;
begin
  Result := false;
  if assigned(FScaled) and
    (X >= FPosX) and (X <= FPosX + FScaled.Width) and
    (Y >= FPosY) and (Y <= FPosY + FScaled.Height) then
  begin
    Result := true;
  end;
end;

procedure TViewer.LockBuffer;
begin
  FLock.Enter;
end;

procedure TViewer.ScaleTo(AWidth, AHeight: integer; UseHQSampling: boolean);
var
  Bitmap: TBitmap;
  Success: boolean;
begin
  // Create scaled version
  if (AWidth <> FPicture.Width) or (AHeight <> FPicture.Height) then
  begin

    // The dimensions differ so we have to resize

    // Try the external scaling function of cached, resampled bitmaps
    Success := False;
    if UseHQSampling and assigned(FOnGetResample) then
    begin

      // Create a copy
      Bitmap := TBitmap.Create;
      try
        Bitmap.Width := FPicture.Width;
        Bitmap.Height := FPicture.Height;
        Bitmap.Canvas.Draw(0, 0, FPicture.Graphic);

        // See if it already exists
        FOnGetResample(Self, AWidth, AHeight, Bitmap, Success);

        if Success then
          // Yes, so assign to Scaled
          Scaled := Bitmap;

      finally
        Bitmap.Free;
      end;
    end;

    if not Success then
    begin

      if FPicture.Graphic is TBitmap then
      begin

        // Do the resize
        RescaleImage(FPicture.Bitmap, FScaled, AWidth, AHeight, True, True, False);

      end else
      begin

        // Convert odd graphic formats to bitmap
        Bitmap := TBitmap.Create;
        try
          Bitmap.Width := FPicture.Width;
          Bitmap.Height := FPicture.Height;
          Bitmap.Canvas.Draw(0, 0, FPicture.Graphic);

          // Do the resize
          RescaleImage(Bitmap, FScaled, AWidth, AHeight, True, True, False);

        finally
          Bitmap.Free;
        end;
      end;
    end;

    // The new scale factor
    FScale := FScaled.Width / FPicture.Width;

  end else
  begin

    // Just copy but keep 24bit format
    FScaled.Width  := FPicture.Width;
    FScaled.Height := FPicture.Height;
    FScaled.Canvas.Draw(0, 0, FPicture.Graphic);

  end;

end;

procedure TViewer.ScaleImage(AValue: double);
var
  FMidX,
  FMidY: double;
begin
  if assigned(FPicture.Graphic) then
  begin

    // Determine pivot point
    if (FScaled.Width > 0) and (FScaled.Height > 0) then
    begin
      FMidX := (pbPicture.Width  /  2 - FPosX) / FScaled.Width;
      FMidY := (pbPicture.Height /  2 - FPosY) / FScaled.Height;
    end else
    begin
      FMidX := (pbPicture.Width  /  2);
      FMidY := (pbPicture.Height /  2);
    end;

    // Remove scaled version
    FScaled.Width := 0;
    FScaled.Height := 0;
    FScale := 1.0;

    ScaleTo(round(FPicture.Width * AValue), round(FPicture.Height * AValue), True);

    // Use pivot point to set correct start positions
    FPosX := round(pbPicture.Width  / 2 - FMidX * FScaled.Width);
    if FPosX >= 0 then
      FPosX := (pbPicture.Width  - FScaled.Width ) div 2;
    if FPosX < Min(pbPicture.Width - FScaled.Width, 0) then
      FPosX := Min(pbPicture.Width - FScaled.Width, 0);

    FPosY := round(pbPicture.Height / 2 - FMidY * FScaled.Height);

    if FPosY >= 0 then
      FPosY := (pbPicture.Height - FScaled.Height) div 2;
    if FPosY < Min(pbPicture.Height - FScaled.Height, 0) then
      FPosY := Min(pbPicture.Height - FScaled.Height, 0);

  end else
  begin

    // No picture
    FScaled.Width := 0;
    FScaled.Height := 0;
    FPosX := 0;
    FPosY := 0;

  end;

  // Make sure to recreate buffer
  InvalidBuffer := True;
end;

procedure TViewer.SetBackground(const AValue: TPicture);
begin
  // Assign to background
  FBackground.Assign(AValue);

  // Make sure to re-create buffer
  InvalidBuffer := True;
end;

procedure TViewer.SetGrowToFit(AValue: boolean);
begin
  if FGrowToFit <> AValue then
  begin
    FGrowToFit := AValue;
    CreateScaled(True);
  end;
end;

procedure TViewer.SetInvalidBuffer(AValue: boolean);
var
  G: TGraphic;
begin
  FInvalidBuffer := true;
  Invalidate;

  // Show information
  if assigned(FPicture.Graphic) then
  begin
    G := FPicture.Graphic;
    DoStatus(Format('%dx%d pixels at %d%%',
      [G.Width, G.Height, round(FScale*100)]));
  end;
end;

procedure TViewer.SetIsDragging(AValue: boolean);
begin
  if FIsDragging <> AValue then
  begin
    FIsDragging := AValue;
    if FIsDragging then
    begin

      // Dragging starts
      FDragX := FMouseX;
      FDragY := FMouseY;
      Screen.Cursor := crHandPoint;

    end else
    begin

      // Dragging finished
      Screen.Cursor := crDefault;
      pbPicture.Cursor := crDragHand;

    end;
  end;
end;

procedure TViewer.SetIsResizing(AValue: boolean);
begin
  if FIsResizing <> AValue then
  begin
    FIsResizing := AValue;

    // We need to do a recreation after any resizing operation
    if FIsResizing = false then
      CreateScaled(True);
  end;
end;

procedure TViewer.SetPicture;
begin

  // Assign to picture
  FPicture.Assign(AValue);

  // Switch off previous zooming
  FZoomFit := false;

  // Create the scaled version where neccesary
  CreateScaled(True);

end;

procedure TViewer.SetScale(AValue: double);
begin
  if FScale <> AValue then
    ScaleImage(AValue);
end;

procedure TViewer.SetScaled(AValue: TBitmap);
begin
  Scaled.Assign(AValue);
  InvalidBuffer := True;
end;

procedure TViewer.SetShrinkToFit(AValue: boolean);
begin
  if FShrinkToFit <> AValue then
  begin
    FShrinkToFit := AValue;
    CreateScaled(True);
  end;
end;

procedure TViewer.UnlockBuffer;
begin
  FLock.Leave;
end;

procedure TViewer.pbPicturePaint(Sender: TObject);
var
  R: TRect;
begin
  // If we are in a resize period, we will not update
  if not FIsResizing then
  begin

    if FInvalidBuffer then
    begin
      // Create new buffer
      CreateBuffer;
      FInvalidBuffer := false;
    end;

    R := pbPicture.Canvas.ClipRect;

    LockBuffer;
    try

      // Draw buffer
      if assigned(FBuffer) then
      begin
        BitBlt(pbPicture.Canvas.Handle, R.Left, R.Top, R.Right - R.Left,
          R.Bottom - R.Top, FBuffer.Canvas.Handle, R.Left, R.Top, SRCCOPY);
      end;

    finally
      UnlockBuffer;
    end;

  end;
end;

procedure TViewer.DoZoomFit;
begin
  FZoomFit := True;
  CreateScaled(True);
end;

procedure TViewer.Initialize(Sender: TObject);
begin
  FLock := TCriticalSection.Create;
  FBuffer := TBitmap.Create;
  FBuffer.PixelFormat := pf24bit;
  FScaled := TBitmap.Create;
  FScaled.PixelFormat := pf24bit;
  FBackground := TPicture.Create;
  FPicture := TPicture.Create;
  // Defaults
  FShrinkToFit := FWinShrinkFit;
  FGrowToFit := FWinGrowFit;
end;

procedure TViewer.Finalize(Sender: TObject);
begin
  FreeAndNil(FBackground);
  FreeAndNil(FBuffer);
  FreeAndNil(FPicture);
  FreeAndNil(FScaled);
  FreeAndNil(FLock);
end;

procedure TViewer.pbPictureMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  // Store location
{  FMouseX := X;
  FMouseY := Y;}

  // Mouse cursor
  if IsDragging then
  begin

    // We are dragging
    DragImage(X - FDragX, Y - FDragY);
    FDragX := X;
    FDragY := Y;
    WasDragging := True;

  end else
  begin

    // Inside picture
    if AllowDragging and InsidePicture(X, Y) then
      pbPicture.Cursor := crDragHand
    else
      pbPicture.Cursor := crDefault;

  end;

  // Status
//  DoStatus(Format('Position: X=%.4d Y=%.4d', [X, Y]));
end;

procedure TViewer.pbPictureMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // Store location
  FMouseX := X;
  FMouseY := Y;

  if not IsDragging then
  begin
    // Capture a start drag operation
    if (ssLeft in Shift) and AllowDragging and InsidePicture(X, Y) then
    begin
      IsDragging := True;
    end;
  end;
end;

procedure TViewer.pbPictureMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  IsDragging := False;
end;

end.
