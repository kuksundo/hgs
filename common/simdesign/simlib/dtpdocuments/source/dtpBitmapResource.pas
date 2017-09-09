{
  Unit dtpBitmapResource

  TdtpBitmapResource is a TdtpResource descendant holding a 32bit DIB bitmap.

  Project: DTP-Engine

  Creation Date: 22-08-2003 (NH)

  Modifications:
  - added TdtpBitmap from dtpGraphics instead of TBitmap32 from Graphics32

  Copyright (c) 2003 - 2010 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit dtpBitmapResource;

{$i simdesign.inc}

interface

uses
  Types, Classes, SysUtils, dtpResource, dtpRasterFormats, dtpGraphics;

type

  // TdtpBitmapResource is a TdtpResource descendant that holds a 32bit DIB bitmap,
  // and provides methods for loading and saving these from the registered file formats.
  TdtpBitmapResource = class(TdtpResource)
  private
    function GetBitmap: TdtpBitmap;
    procedure SetBitmap(const Value: TdtpBitmap);
  protected
    procedure DefaultLoadFromExternal; override;
    procedure DefaultObjectToStream; override;
    procedure DefaultObjectFromStream; override;
    function GetObjectApproximateSize: integer; override;
  public
    // Call bitmapChanged after you have updated the bitmap, e.g. by using the
    // Pixels property. When assigning a new bitmap with "Bitmap := MyBitmap"
    // this procedure will automatically be called. You must always wrap access
    // to the bitmap in calls to BeginAccess and EndAccess, like this:
    // <code>
    // with MyBitmapResource do begin
    //   BeginAccess;
    //   try
    //     Bitmap.Pixels[10, 10] := clRed32;
    //     {any more bitmap manipulation}
    //     BitmapChanged;
    //   finally
    //     EndAccess;
    //   end;
    // end;
    // </code>
    procedure BitmapChanged; virtual;
    // Call LoadFromBitmap to "load" the bitmap into the resource, which will
    // cause a call to OnAfterLoadFromFile which can be used by the application
    // to do postprocessing. When you call MyBitmapResource.Bitmap := ABitmap
    // you also assign the bitmap to the resource, but the OnAfterLoadFromFile
    // event is not fired. Provide an extension if you want the resource to be
    // saved in a different format as "hck", e.g. LoadFromBitmap(MyBitmap, '.jpg')
    procedure LoadFromBitmap(ABitmap: TdtpBitmap; const AExtension: string = '.hck');
  published  
    // Read Bitmap to get a pointer to the TBitmap32 that the resource holds.
    // Set Bitmap to your own TBitmap32 to create a copy of it in the resource.
    property Bitmap: TdtpBitmap read GetBitmap write SetBitmap;
  end;

implementation

{ TdtpBitmapResource }

procedure TdtpBitmapResource.BitmapChanged;
begin
  // Make sure to save the object
  ObjectModified := True;
  DoObjectChanged;
end;

procedure TdtpBitmapResource.DefaultLoadFromExternal;
// Load a mapped stream from AFilename
var
  TmpClass: TdtpRasterClass;
  Loader, Saver: TdtpImageFiler;
  Dib: TdtpBitmap;
begin
  // Determine raster class
  TmpClass := RasterClassFromExt(Filename);

  // Determine if the class implements loading from stream. If not, we will
  // convert it to hck, because we must be able to work with streams in the
  // resource.
  if ofLoadStream in GetRasterClassOptions(TmpClass) then

    inherited

  else
  begin

    // Load the file, and save as HCK stream
    Loader := TdtpImageFiler.Create;
    Saver := TdtpImageFiler.Create;
    Dib := TdtpBitmap.Create;
    try
      Stream.Size := 0;
      Loader.Filename := Filename;
      Loader.LoadDib(Dib);
      Saver.Stream := Stream;
      Saver.Extension := '.hck';
      Saver.SaveDib(Dib);
      FileName := ChangeFileExt(FileName, '.hck');
    finally
      Loader.Free;
      Saver.Free;
      Dib.Free;
    end;
  end;
end;

procedure TdtpBitmapResource.DefaultObjectFromStream;
var
  Bmp: TdtpBitmap;
begin
  Bmp := TdtpBitmap.Create;
  try
    LoadImageFromStream(Stream, Extension, Bmp, Point(0, 0), 0);
    if assigned(FObjectRef) then
      FreeAndNil(FObjectRef);
    FObjectRef := Bmp;
  except
    FreeAndNil(Bmp);
    FObjectRef := nil;
    raise;
  end;
end;

procedure TdtpBitmapResource.DefaultObjectToStream;
var
  TmpClass: TdtpRasterClass;
  Options: TdtpRasterOptions;
  Saver: TdtpImageFiler;
begin
  // When we save the bitmap to the stream, make sure to use a format that doesn't
  // loose quality
  TmpClass := RasterclassFromExt(Extension);
  if not assigned(TmpClass) then
    exit;

  // Make sure we can safely stream the class
  Options := GetRasterClassOptions(TmpClass);
  if {(ofLossy in Options) or} not (ofSaveStream in Options) then
    Filename := ChangeFileExt(Filename, '.hck');

  // Now save the object to the correct image stream
  Saver := TdtpImageFiler.Create;
  try
    Saver.Stream := Stream;
    Saver.Extension := Extension;
    if assigned(Bitmap) then
      Saver.SaveDib(Bitmap);
  finally
    Saver.Free;
  end;
end;

function TdtpBitmapResource.GetBitmap: TdtpBitmap;
begin
  Result := TdtpBitmap(ObjectRef);
end;

function TdtpBitmapResource.GetObjectApproximateSize: integer;
begin
  if assigned(FObjectRef) then
    Result := TdtpBitmap(FObjectRef).Width * TdtpBitmap(FObjectRef).Height * 4
  else
    Result := 0;
end;

procedure TdtpBitmapResource.LoadFromBitmap(ABitmap: TdtpBitmap; const AExtension: string = '.hck');
begin
  Clear;
  Extension := AExtension;
  Bitmap := ABitmap;
  DoAfterLoadFromFile;
end;

procedure TdtpBitmapResource.SetBitmap(const Value: TdtpBitmap);
begin
  BeginAccess;
  try
    // Create an object if not existing already
    if not assigned(ObjectRef) then
    begin
      ObjectRef := TdtpBitmap.Create;
      if length(Extension) = 0 then
        Extension := '.hck';
    end;
    if assigned(Value) then
    begin
      TdtpBitmap(ObjectRef).Assign(Value);
      ObjectModified := True;
    end else
      Clear;
  finally
    EndAccess;
  end;
  DoObjectChanged;
end;

initialization

  RegisterResourceClass(TdtpBitmapResource);

end.
