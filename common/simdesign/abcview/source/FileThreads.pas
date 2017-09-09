{ Unit FileThreads

  This unit implements the background file decoding/statistics in a thread

  How to use this unit:
  - the thread is created in the Catalog's Create method

  Features:

  Issues:

  Initial release: 20-12-2000

  Modifications:
  23May2004: TFileThread.Run added "if assigned(Root) then..."

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit FileThreads;

interface

uses
  Windows, Graphics, NativeJpg, sdGraphicLoader, ComCtrls, Classes, SysUtils,
  sdProcessThread, sdItems, sdAbcTypes, sdAbcVars, sdAbcFunctions;

type

  TFileThread = class(TProcess)
  private
    FLoader: TsdGraphicLoader;
    FMessage: string;
    procedure DoAutoCRC(AFile: TsdFile; S: TStream);
    procedure DoAutoCustom(AFile: TsdFile; S: TStream);
    procedure DoAutoPixRef(AFile: TsdFile; S: TStream);
    procedure DoAutoThumb(AFile: TsdFile; S: TStream);
    procedure DoCalcs;
    procedure DoMessage;
  protected
    procedure Run; override;
  public
    constructor Create(CreateSuspended: boolean; AParent: TProcessList); override;
    destructor Destroy; override;
  end;

const

  cMessageInterval = 200;

implementation

uses

  guiMain, Crc32, Thumbnails, sdProperties, PixRefs, guiPlugins;

{  TFileThread }

procedure TFileThread.DoAutoCRC(AFile: TsdFile; S: TStream);
begin
  if assigned(AFile) and assigned(S) then
  begin
    // Update the file's properties
    AFile.SmallCRC := ComputeStreamCRCSmall(S);
    AFile.CRC := ComputeStreamCRC32(S);
    AFile.SetState(isCRCDone, True);

    // Update if we're not in silent mode
    if FUpdateFromBgr then
      AFile.Update([ufListing]);
  end;
end;

procedure TFileThread.DoAutoCustom(AFile: TsdFile; S: TStream);
// Create the custom indices of the plugins
var
  i: integer;
begin
  for i := 0 to glPlugins.Count - 1 do
    glPlugins[i].DoCustomIndex(AFile, S);
end;

procedure TFileThread.DoAutoPixRef(AFile: TsdFile; S: TStream);
begin
  AFile.CalculatePixRef;
end;

procedure TFileThread.DoAutoThumb(AFile: TsdFile; S: TStream);
var
  SourceW, SourceH: integer;
  Bitmap: TBitmap;
  Thumb: TprThumbnail;
  Dims: TprDimensions;
  PixRef: TprPixRef;
begin
  AFile.SetState(isThumbDone, True);
  try
    // Create the property
    Thumb := TprThumbnail.Create;
    if assigned(Thumb) then
    begin
      Thumb.Width := FThumbWidth;
      Thumb.Height := FThumbHeight;
      // Destination size
      S.Seek(0, soFromBeginning);
      FLoader.Quality := iqThumb;
      FLoader.SetDestSize(FThumbWidth, FThumbHeight);
      FLoader.LoadFromStream(S, AFile.Extension);
      SourceW := FLoader.SourceWidth;
      SourceH := FLoader.SourceHeight;
      // Do we have a result?
      if HasContent(FLoader.Bitmap) then
      begin
        Bitmap:= TBitmap.Create;
        try
          // Bitmaps will always be 24bpp
          Bitmap.PixelFormat := pf24bit;
          // Resize the graphic
          RescaleImage(FLoader.Bitmap, Bitmap, FThumbWidth, FThumbHeight,
            True,     // Downscale the image
            False,    // Do not upscale the image
            FThumbHQ);   // Fancy sampling for high quality thumbnails
          // Check
          if assigned(Bitmap) and (Bitmap.Width > 0) and (Bitmap.Height > 0) then
          begin
            // Try to avoid "out of resources"
            Bitmap.FreeImage;
            Bitmap.Dormant;
            // Store the graphic
            Thumb.SaveBitmap(Bitmap);
            // Now add the property and we're done
            AFile.AddProperty(Thumb);
          end;

          // Dimensions property
          Dims := TprDimensions(AFile.GetProperty(prDimensions));
          if not assigned(Dims) then
          begin
            Dims := TprDimensions.Create;
            Dims.SizeX := SourceW;
            Dims.SizeY := SourceH;
            Dims.PixelFormat := FLoader.Bitmap.PixelFormat;
            AFile.AddProperty(Dims);
          end;

          // Pixel reference, done here because we already have the bitmap
          if not (isPixRefd in AFile.States) and FAutoPixRef then
          begin
            PixRef := TprPixRef(AFile.GetProperty(prPixRef));
            if not assigned(PixRef) then
            begin
              // Create pixel reference
              PixRef := TprPixRef.Create;
              PixRef.SetSizeTo(FGranularity, FMatchMethod);
              PixRef.RefFromBitmap(Bitmap);
              // Add this pixref to the file
              AFile.AddProperty(PixRef);
              // The file is now pixrefd
              AFile.SetState(isPixRefd, True);
            end;
          end;

          // Signal main app
          if FUpdateFromBgr then
            AFile.Update([ufListing]);

        finally
          Bitmap.Free;
        end;
      end;
    end;
  except
    // Silent
    //DoDebugOut(Self, wsWarn, 'silent');
  end;
end;

// Calculate the CRC value automatically in this thread
procedure TFileThread.DoCalcs;
var
  Count: integer;
  AFile: TsdFile;
  S, F: TStream;
  OldTick, NewTick: cardinal;
begin
  Count := 0; // Start from beginning of list
  OldTick := GetTickCount;

  // Only do the CRC calculation if user selected it
  while (Count < frmMain.Root.FAllFiles.Count) and not Terminated do
  begin

    frmMain.Root.FAllFiles.LockRead;
    try
      AFile := TsdFile(frmMain.Root.FAllFiles[Count]);
    finally
      frmMain.Root.FAllFiles.UnlockRead;
    end;

    if assigned(AFile) and not (isNoAccess in AFile.States) then
    begin

      // Do we need to verify this file?
      if not (isVerified in AFile.States) and FAutoVerify then
      begin
        // Verify the file
        AFile.Verify;
      end;

      // Do we need to process this file?
      if (not (isThumbDone in AFile.States) and AFile.IsGraphicsFile and FAutoThumb) or
         (not (isCRCDone in AFile.States) and FAutoCRC) or
         (not (isPixRefd in AFile.States) and AFile.IsGraphicsFile and FAutoPixRef) or
         (FPluginIndexFiles and MustIndexCustom(AFile))then
      begin
        try
          S := TMemoryStream.Create;
          try
            try
              // Copy the file to the memory stream S
              F := TFileStream.Create(AFile.FileName, fmOpenRead or fmShareDenyWrite);
              try
                S.CopyFrom(F, F.Size);
              finally
                F.Free;
              end;
            except
              // File access denied
              AFile.SetState(isNoAccess, True);
            end;

            // Auto thumbnailing
            if not (isThumbDone in AFile.States) and AFile.IsGraphicsFile
               and FAutoThumb then
            begin
              DoAutoThumb(AFile, S);
              // Allow other threads
              Sleep(2);
            end;

            // Auto PixRef
            if not (isPixRefd in AFile.States) and FAutoPixRef then
            begin
              DoAutoPixRef(AFile, S);
              // Allow other threads
              Sleep(2);
            end;

            // Auto CRC
            if not (isCRCDone in AFile.States) and FAutoCRC then
            begin
              DoAutoCRC(AFile, S);
              // Allow other threads
              Sleep(2);
            end;

            // Custom indices of plugins
            if FPluginIndexFiles and MustIndexCustom(AFile) then
            begin
              DoAutoCustom(AFile, S);
              // Allow other threads
              Sleep(2);
            end;

          finally
            S.Free;
          end;
        except
          // Silent exception - most probably from graph decoder
        end;
      end;

      // Small CRC does not need complete file stream
      if (AFile.SmallCRC = 0) and FAutoSCRC and not FAutoCRC then
      begin
        AFile.CalculateSmallCRCValue;
      end;

      // Custom indices of plugins, this time with just filename
      if FPluginIndexFiles and MustIndexCustom(AFile) then
      begin
        DoAutoCustom(AFile, nil);
        // Allow other threads
        Sleep(2);
      end;

    end;

    NewTick := GetTickCount;
    if (NewTick - OldTick >= cMessageInterval) then
    begin
      if frmMain.Root.FAllFiles.Count > 0 then
        FMessage := Format('Processing file %d of %d (%3.1f%%)',
          [Count, frmMain.Root.FAllFiles.Count, Count / frmMain.Root.FAllFiles.Count * 100])
      else
        FMessage := 'Processing 0 files';

      if not Terminated then
        synchronize(DoMessage);

      Task := Format('File %d of %d', [Count, frmMain.Root.FAllFiles.Count]);
      OldTick := NewTick;
    end;

    // Next item
    inc(Count);

    // Pause Check
    if Status = psPausing then
      Pause;

    // Allow other threads
    if (Count mod 1000) = 0 then
      Sleep(2);

  end;

  FMessage := '';
  if not Terminated then
    synchronize(DoMessage);
end;

procedure TFileThread.Run;
begin
  repeat
    if assigned(frmMain.Root) then
      while frmMain.Root.MustIndex do
      begin

        // Reset our activator
        frmMain.Root.MustIndex := false;

        // A start pause
        Sleep(100);

        // Calculations
        if FAutoVerify or FAutoThumb or FAutoPixref or FAutoCRC then
          DoCalcs;

      end;

    if not Terminated then
      Pause;

  until Terminated;
end;

procedure TFileThread.DoMessage;
begin
  frmMain.StatusMessage(Self, FMessage, suPanel2);
end;

constructor TFileThread.Create(CreateSuspended: boolean; AParent: TProcessList);
begin
  inherited;
  FLoader := TsdGraphicLoader.Create;
end;

destructor TFileThread.Destroy;
begin
  FreeAndNil(FLoader);
  inherited;
end;

end.
