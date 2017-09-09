{ Unit sdGraphicLoader

  Generic graphic types loading based mostly on GraphicEx.

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2007 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit sdGraphicLoader;

interface

uses

  Windows, SysUtils, Classes, Graphics, GraphicEx, NativeJpg,
  GifImage, Math, sdJpegTypes, sdViewCanonCRW;

type

  // Graphics Status constants
  TsdGraphicStatus = (
    gsGraphicsOK,     // Graphics decoding is OK
    gsDecodeWarning,  // The decoder returned warnings, but the result contains a partial bitmap
    gsDecodeError,    // The decoder returned a fatal error, the bitmap is empty
    gsMemoryError,    // There was a memory allocation problem
    gsInitError,      // ABitmap is not initialized
    gsUnknownFormat,  // The stream contains an unsupported format
    gsNotFound,       // Graphic was not found at location
    gsSaveError       // Graphic could not be saved
  );

  // Quality factors for image loading
  TImageQuality = (
    iqNormal, // Load normal-sized image
    iqThumb,  // Load thumbnail
    iqMini    // Load mini-thumbnail
  );

  TsdGraphicLoader = class
  private
    FBitmap: TBitmap;
    FGraphic: TGraphic; // A TGraphic instance that is used for loading
    FOnlyMetadata: boolean;
    FQuality: TImageQuality;
    FSourceWidth: integer;
    FDestWidth: integer;
    FSourceHeight: integer;
    FDestHeight: integer;
    FOnProgress: TProgressEvent;
  protected
    function HasContent(AGraphic: TGraphic): boolean;
    function DetermineGraphicClass(AExt: string; AStream: TStream): TGraphicClass;
    function LoadGraphicFromStream(AGraphic: TGraphic; AStream: TStream): TsdGraphicStatus;
    function DefaultLoadGraphicFromStream(AGraphic: TGraphic; AStream: TStream): TsdGraphicStatus;
    function LoadJpegGraphicFromStream(AJpg: TsdJpegGraphic; AStream: TStream): TsdGraphicStatus;
    function LoadCrwGraphicFromStream(ACrw: TCrwGraphic; AStream: TStream): TsdGraphicStatus;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    // LoadFromFile returns a bitmap of the graphics in AFileName. See also
    // LoadFromStream.
    function LoadFromFile(const AFileName: string): TsdGraphicStatus;
    // LoadFromStream returns a bitmap of the graphics on stream AStream. Also
    // provide AExt for cases where the graphics format cannot be deducted from
    // the stream. AExt can be given as the filename, or the extension, with or
    // without the dot. DestWidth/Height should contain the final destination
    // size of the graphic, and is only an indicator for the routine to obtain
    // a downsized graphic in some cases (JPeg loading), when AQuality = iqThumb
    // or iqMini. DestWidth/Height can be left to 0.
    // ABitmap must be initialized before calling the routine and it will be
    // assigned the graphic which is decoded. When calling with OnlyMetadata = True,
    // SourceWidth/Height will/ be filled with image dimensions, but no graphic
    // will be actually loaded.
    function LoadFromStream(AStream: TStream; const AExt: string): TsdGraphicStatus;
    procedure SetDestSize(AWidth, AHeight: integer);
    property Bitmap: TBitmap read FBitmap;
    property OnlyMetadata: boolean read FOnlyMetadata write FOnlyMetadata;
    property Quality: TImageQuality read FQuality write FQuality;
    property DestWidth: integer read FDestWidth write FDestWidth;
    property DestHeight: integer read FDestHeight write FDestHeight;
    property SourceWidth: integer read FSourceWidth write FSourceWidth;
    property SourceHeight: integer read FSourceHeight write FSourceHeight;
    property OnProgress: TProgressEvent read FOnProgress write FOnProgress;
  end;

implementation

{ TsdGraphicLoader }

procedure TsdGraphicLoader.Clear;
begin
  FBitmap.Width := 0;
  FBitmap.Height := 0;
  FBitmap.PixelFormat := pf24bit;
end;

constructor TsdGraphicLoader.Create;
begin
  inherited;
  FBitmap := TBitmap.Create;
end;

function TsdGraphicLoader.DefaultLoadGraphicFromStream(AGraphic: TGraphic;
  AStream: TStream): TsdGraphicStatus;
begin
  Result := gsGraphicsOK;
  AGraphic.LoadFromStream(AStream);
  FSourceWidth := AGraphic.Width;
  FSourceHeight := AGraphic.Height;
  // Now we assign it - at this very moment the stream is decompressed
  if not FOnlyMetadata then
  begin
    if not (AGraphic is TBitmap) then
    begin
      FBitmap.Width := FSourceWidth;
      FBitmap.Height := FSourceHeight;
      FBitmap.PixelFormat := pf24bit;
      FBitmap.Canvas.Lock;
      FBitmap.Canvas.Draw(0, 0, AGraphic);
      FBitmap.Canvas.UnLock;
    end else
      FBitmap.Assign(AGraphic);
  end;
end;

destructor TsdGraphicLoader.Destroy;
begin
  FreeAndNil(FBitmap);
  FreeAndNil(FGraphic);
  inherited;
end;

function TsdGraphicLoader.DetermineGraphicClass(AExt: string; AStream: TStream): TGraphicClass;
var
  P: int64;
begin
  // Extension in lower case with leading dot
  AExt := lowercase(AExt);
  if (length(AExt) > 0) and (AExt[1] <> '.') then
    AExt := '.' + AExt;

  P := AStream.Position;
  Result := FileFormatList.GraphicFromContent(AStream);
  AStream.Position := P;

  if Result = nil then
  begin

    Result := FileFormatList.GraphicFromExtension(AExt);
    if Result = nil then
    begin

      // Try GIF
      if AExt = '.gif' then
        Result := TGifImage;

    end;

  end;
end;

function TsdGraphicLoader.HasContent(AGraphic: TGraphic): boolean;
begin
  Result := False;
  try
    if assigned(AGraphic) and (AGraphic.Width > 0) and (AGraphic.Height > 0) then
      Result := True;
  except
    // Silent exception
  end;
end;

function TsdGraphicLoader.LoadCrwGraphicFromStream(ACrw: TCrwGraphic;
  AStream: TStream): TsdGraphicStatus;
var
  M: TMemoryStream;
  Jpg: TsdJpegGraphic;
begin
  // Canon CRW format contains a thumbnail
  if FQuality <> iqNormal then
  begin
    M := TMemoryStream.Create;
    try
      ACrw.GetThumbnail(AStream, M);
      if M.Size > 0 then begin
        M.Position := 0;
        Jpg := TsdJpegGraphic.Create;
        try
          Result := LoadJpegGraphicFromStream(Jpg, M);
          Exit;
        finally
          Jpg.Free;
        end;
      end;
    finally
      M.Free;
    end;
  end;
  // If not, default loading
  Result := DefaultLoadGraphicFromStream(ACrw, AStream);
end;

function TsdGraphicLoader.LoadFromFile(const AFileName: string): TsdGraphicStatus;
var
  F: TFileStream;
begin
  if not FileExists(AFileName) then
  begin
    Result := gsNotFound;
    exit;
  end;
  F := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
  try
    Result := LoadFromStream(F, ExtractFileExt(AFileName));
  finally
    F.Free;
  end;
end;

function TsdGraphicLoader.LoadFromStream(AStream: TStream; const AExt: string): TsdGraphicStatus;
var
  GraphicClass: TGraphicClass;
begin
  Result := gsUnknownFormat;
  Clear;

  // Determine class
  GraphicClass := DetermineGraphicClass(AExt, AStream);

  if GraphicClass = nil then
    exit;

  if not assigned(FGraphic) or not (FGraphic is GraphicClass) then
  begin
    // We must instantiate
    FreeAndNil(FGraphic);
    FGraphic := GraphicClass.Create;
  end;

  // Now load the graphic
  try
    Result := LoadGraphicFromStream(FGraphic, AStream);
  except
    Result := gsDecodeError;
  end;

  // Draw a red cross on the thumbnail
  if (Result in [gsDecodeError]) and
     (FQuality = iqThumb) and
     HasContent(FBitmap) then begin
    with FBitmap.Canvas do begin
      Pen.Color := clRed;
      Pen.Width := 2;
      MoveTo(0, 0);
      LineTo(FBitmap.Width, FBitmap.Height);
      MoveTo(0, FBitmap.Height);
      LineTo(FBitmap.Width, 0);
    end;
  end;
end;

function TsdGraphicLoader.LoadGraphicFromStream(AGraphic: TGraphic;
  AStream: TStream): TsdGraphicStatus;
begin
  // Classes that use special code to load
  if AGraphic is TsdJpegGraphic then
  begin
    Result := LoadJpegGraphicFromStream(TsdJpegGraphic(Agraphic), AStream);
    Exit;
  end else if AGraphic is TCrwGraphic then
  begin
    Result := LoadCRWGraphicFromStream(TCrwGraphic(Agraphic), AStream);
    Exit;
  end else
    // Default loading
    Result := DefaultLoadGraphicFromStream(AGraphic, AStream);
end;

function TsdGraphicLoader.LoadJpegGraphicFromStream(AJpg: TsdJpegGraphic;
  AStream: TStream): TsdGraphicStatus;
var
  ScaleX, ScaleY, Scale: double;
begin
  AJpg.Performance := jpBestQuality;
  AJpg.Scale := jsFull;

  Result := gsGraphicsOK;
  try
    AJpg.LoadFromStream(AStream);
  except
    Result := gsDecodeWarning;
  end;
  FSourceWidth := AJpg.Width;
  FSourceHeight := AJpg.Height;
  if (FSourceWidth = 0) or(FSourceHeight = 0) then
  begin
    Result := gsDecodeError;
    exit;
  end;

  // Jpeg decompression - we can speed up by decoding grainier for Mini/Thumb quality
  if FQuality in [iqMini, iqThumb] then
  begin
    AJpg.Performance := jpBestSpeed;
    AJpg.Scale := jsFull;
    // Determine size req's
    ScaleX := FDestWidth / FSourceWidth;
    ScaleY := FDestHeight / FSourceHeight;
    Scale := Min(ScaleX, ScaleY);
    if Scale <= 0.5 then begin
      AJpg.Scale := jsDiv2;
      if Scale <= 0.25 then begin
        AJpg.Scale := jsDiv4;
        if Scale <= 0.125 then begin
          AJpg.Scale := jsDiv8;
        end;
      end;
    end;
    // Load Mini's in grayscale
    if FQuality = iqMini then
      AJpg.Grayscale := True;
  end;

  // Finally assign to our bitmap
  try
    FBitmap.Assign(AJpg);
  except
    Result := gsDecodeWarning;
  end;
end;

procedure TsdGraphicLoader.SetDestSize(AWidth, AHeight: integer);
begin
  FDestWidth := AWidth;
  FDestHeight := AHeight;
end;

end.
