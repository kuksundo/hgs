{ dtpRasterJPG.pas

  convert JPG image to/from TBitmap32 used in dtpDocuments

  Author: Nils Haeck M.Sc.
  Date: 10nov2010
  copyright (c) 2010 - 2011 SimDesign BV

 }
unit dtpRasterJPG;

interface

uses
  SysUtils,
  // SimDesigns NativeJpg units
  NativeJpg, sdJpegTypes,
  Windows, Classes, dtpGraphics, Graphics, dtpRasterFormats;


type
  // Reader and writer for the JPEG raster format
  TdtpJpgFormat = class(TdtpRaster)
  private
    FCompressionQuality: integer;
  public
    constructor Create; override;
    procedure LoadImageFromStream(S: TStream; ADIB: TdtpBitmap; AMaxSize: TPoint; Page: integer); override;
    procedure SaveImageToStream(S: TStream; ADIB: TdtpBitmap); override;
    property CompressionQuality: integer read FCompressionQuality write FCompressionQuality;
  end;

implementation

{ TdtpJpgFormat }

constructor TdtpJpgFormat.Create;
begin
  inherited;
  FCompressionQuality := cDefaultJpgCompressionQuality;
end;

procedure TdtpJpgFormat.LoadImageFromStream(S: TStream; ADIB: TdtpBitmap;
  AMaxSize: TPoint; Page: integer);
var
  AJpeg: TsdJpegGraphic;
  AScale: integer;
  //F: TFileStream;
  AWidth, AHeight: integer;
begin
  if Page > 0 then
    raise ERasterError.Create(sreIllegalPageNumber);

  AJpeg := TsdJpegGraphic.Create;
  try
    AJpeg.LoadFromStream(S);

    // Arriving here is good news
    AWidth  := AJPeg.Width;
    AHeight := AJPeg.Height;

    // Set loading scale appropriately
    AScale := 1;
    while (AWidth  >= AMaxSize.X * AScale * 2) and
          (AHeight >= AMaxSize.Y * AScale * 2) and
          (AScale <= 4) do
      AScale := AScale * 2;
    case AScale of
    1: AJpeg.Scale := jsFull;
    2: AJpeg.Scale := jsDiv2;
    4: AJpeg.Scale := jsDiv4;
    8: AJpeg.Scale := jsDiv8;
    end;//

    // Other settings
    AJpeg.Performance := jpBestQuality;
    AJpeg.OnProgress  := GraphicProgress;

    // This will trigger the decompression of the JPG image
    try
      ADIB.Assign(AJpeg);
    except
      {AJpeg.SaveToFile('c:\temp\test.jpg');
      F := TFileStream.Create('c:\temp\test2.jpg', fmCreate);
      S.Position := 0;
      F.CopyFrom(S, S.Size);
      F.Free;}
    end;
  finally
    AJpeg.Free;
  end;
end;

procedure TdtpJpgFormat.SaveImageToStream(S: TStream; ADIB: TdtpBitmap);
var
  AJpeg: TsdJpegGraphic;
  ABitmap: TBitmap;
begin
  // Convert to 24-bit bitmap first, then set quality and save
  ABitmap := TBitmap.Create;
  try
    ABitmap.Assign(ADIB);
    ABitmap.PixelFormat := pf24bit;
    AJpeg := TsdJpegGraphic.Create;
    try
      AJpeg.Assign(ABitmap);
      AJpeg.CompressionQuality := CompressionQuality;
      AJpeg.SaveToStream(S);
    finally
      AJpeg.Free;
    end;
  finally
    ABitmap.Free;
  end;
end;

initialization

  RegisterRasterClass(TdtpJpgFormat, 'JPEG images', '.jpg;.jp;.jpeg;',
    [ofLoadStream, ofLoadFile, ofSaveStream, ofSaveFile, ofHasThumb, ofLossy,
     ofExif, ofIptc]);

end.
