library formatsAVI;

uses
  SysUtils, Classes, Windows, dcAvi, Graphics;


{$R *.RES}

function ReadAVI(Filename: PChar): THandle; stdcall;
var
  favifile      : pointer;
  fvideostream  : pointer;
  fgetframe     : pointer;
  fStartFrame   : integer;
  fStopFrame    : integer;
  fLength       : integer;
  fFrameWidth   : integer;
  fFrameHeight  : integer;
  fFrame        : integer;
  fOpen         : boolean;

  info : TAVIStreamInfo;
  image        : pointer;
  imagestart   : integer;
  ABitmap: TBitmap;
  M: TMemoryStream;
  P: pointer;
  Size: TPoint;
begin
   // defaults to not found in this stage
  Result := 0;
  fvideostream := nil;
  favifile := nil;
  fgetframe := nil;
  fOpen := false;
  fLength := 0;
  try
    if length(FileName) = 0 then exit;
    AviFileInit;
    try

      if AVIFileOpen(@favifile, FileName, 0, nil) <> 0 then exit;
      try

        if AVIFileGetStream(favifile, @fvideostream, streamtypeVIDEO, 0) <> 0 then exit;
        try

          fgetframe := AVIStreamGetFrameOpen(fvideostream, nil);
          if fgetframe = nil then exit;
          try

            AVIStreamInfo(fvideostream, @info, sizeof(info));
            with info do begin
              fLength := dwlength;
              Size.X := rcframe.right - rcframe.left;
              Size.Y := rcframe.bottom - rcframe.top;
              fStartFrame := dwStart;
              fStopFrame := fLength - 1;
            end;
            fFrame := fStartFrame;
            fOpen := true;
            image := AVIStreamGetFrame(fgetframe, fFrame);
            // Try to capture the first frame
            ABitmap := TBitmap.Create;
            try
              // Try to capture first frame
              with ABitmap do begin
                PixelFormat := pf24Bit;
                Width := Size.X;
                Height:= Size.Y;

                imagestart := 0;
                if Assigned(Image) then  begin
                  SetStretchBltMode(Canvas.Handle, HALFTONE);
                  imagestart := TBitmapInfoHeader(image^).biSize + TBitmapInfoHeader(image^).biClrUsed * 4;
                end;

                StretchDIBits(Canvas.Handle, 0, 0, width, height, 0, 0, width, height, pchar(image) + imagestart,
                  TBitmapInfo(image^), 0, SRCCOPY);

              end;
              // Copy to handle
              if ABitmap.Width * ABitmap.Height > 0 then begin
                M := TMemoryStream.Create;
                try
                  ABitmap.SaveToStream(M);
                  Result := GlobalAlloc(GMEM_MOVEABLE, M.Size);
                  if Result <> 0 then begin
                    P := GlobalLock(Result);
                    Move(M.Memory^, P^, M.Size);
                    GlobalUnlock(Result);
                  end;
                finally
                  M.Free;
                end;
              end;
            finally
              ABitmap.Free;
            end;

          finally
            if Assigned(fgetframe) then AVIStreamGetFrameClose(fgetframe);
          end;
        finally
          if Assigned(fvideostream) then AVIStreamRelease(fvideostream);
        end;
      finally
        if Assigned(favifile) then AVIFileRelease(favifile);
      end;
    finally
      AviFileExit;
    end;
  except
    // Silent exception
  end;
end;

exports
  ReadAVI;

end.
