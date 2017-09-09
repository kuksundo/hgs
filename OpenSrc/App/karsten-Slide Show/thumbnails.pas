(* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is thumbnails.pas of Karsten Bilderschau, version 3.3.0
 *
 * The Initial Developer of the Original Code is Matthias Muntwiler.
 * Portions created by the Initial Developer are Copyright (C) 2006
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** *)

{ $Id: thumbnails.pas 107 2007-01-21 03:16:46Z hiisi $ }

{
@abstract Extract thumbnail images for the listview
@author matthias muntwiler <hiisi@users.sourceforge.net>
@created 2006/09/02
@cvs $Date: 2007-01-20 21:16:46 -0600 (Sa, 20 Jan 2007) $
}
unit thumbnails;

interface
uses
  Windows, Classes, SysUtils, Graphics, Controls, Contnrs, ImgList, SyncObjs,
  globals, jobs, sammelklassen;

type
  { Kind of icon that can be displayed for the sammelobjekt }
  TIconKind = (
    ikUnknown,   //< Unknown file format icon
    ikPicture,   //< Picture icon
    ikFolder,    //< Folder icon
    ikVideo,     //< Video icon
    ikAudio);    //< Audio icon

const
  { Maps @link(TGrafikformat) type to @link(TIconKind) }
  CGrafikformatIconKind: array[TGrafikformat] of TIconKind =
    (ikUnknown, ikPicture, ikPicture, ikPicture, ikPicture,
    ikPicture, ikPicture, ikVideo, ikVideo, ikUnknown);

type
  { @abstract Extracts the thumbnail image of one sammelobjekt
    The input parameters are passed to the constructor @link(Create)
    which sets the corresponding object properties.
    The owner can still modify these properties until it passes the object
    to the @link(TJobThread). The job can execute any time thereafter.
    Status result are available in the @link(Status), @link(BildStatus), and
    @link(IconKind) properties. The generated thumbnail can be obtained by
    calling the @link(GetThumbnail) method.

    The class works around VCL/GDI threading issues by passing the bitmap
    through a less fragile memory stream, and by detecting solid-color bitmaps.
    Be sure to follow the synchronization protocol required by @link(TJobThread). }
  TExtractThumbnailJob = class(TJob)
  private
    { Input parameter - see @link(FilePath) }
    FFilePath: string;
    { Input parameter - see @link(Size) }
    FSize: integer;
    { Input parameter - see @link(BackgroundColor) }
    FBackgroundColor: TColor;
    { Output parameter - see @link(BildStatus) }
    FBildStatus: TBildStatus;
    { Output parameter - see @link(IconKind) }
    FIconKind: TIconKind;
    { Thumbnail bitmap.
      The thumbnail is created in this bitmap.
      The bitmap is not publicly available because this would raise threading issues.
      Instead the the thumbnail is passed via a less fragile memory stream. }
    FThumbnail: TBitmap;
    { Thumbnail stream.
      This is a memory stream which is written by @link(SaveToStream) and
      read by @link(GetThumbnail).
      It contains the persistent data from @link(FThumbnail)
      which is less fragile when passed between threads than a bitmap. }
    FStream: TStream;
    { Loads Picture from @link(FFilePath) and performs JPEG optimizations. }
    procedure LoadPicture(Picture: TPicture);
    { Calculates the destination size and rectangle of the shrinked picture.
      Height or width can be greater than the final thumbnail size
      if parts of the picture are clipped.
      If they are are smaller than the thumbnail size
      the drawing procedure must also paint a background. }
    procedure CalcShrinkSize(Picture: TPicture; out width, height: integer;
      out PictRect: TRect);
    { Draws the thumbnail bitmap @link(FThumbnail) given the original Picture
      and the detailed output dimensions.
      The method tries to work around possible VCL thread conflicts
      by locking the canvas and repeating the drawing call up to three times
      if a faulty bitmap is returned.
      Faulty bitmaps are detected using the @link(IsFaultyBitmap) method
      which depending on implementation may give false alarms.

      @returns @true if successful, @false otherwise. }
    function  DrawThumbnail(Picture: TPicture; width, height: integer;
      PictRect: TRect): boolean;
    { Detects a faulty bitmap.
      As a result of an unresolvable VCL thread conflict
      the generated thumbnail is all white (can it also have another color?).
      This method considers a bitmap as faulty
      if its diagonals have a solid color.

      This may signal a false alarm if the original bitmap was all solid color.
      Unfortunately, there is no easy way to check for such a situation
      unless we also check the original picture,
      which we cannot do in the case of compressed picture files
      because their bitmap is only available through a Draw method!
      @returns( @true if the bitmap is considered faulty
        (really faulty or of solid color, that is),
        @false if it is correct. ) }
    function  IsFaultyBitmap(Bitmap: TBitmap): boolean;
    { Writes the the thumbnail bitmap @link(FThumbnail) to a memory stream
      in @link(FStream). }
    procedure SaveToStream;
  protected
    { Executes the job.
      This requires the input parameters
      @link(Ticket), @link(FilePath), @link(Size), and @link(BackgroundColor).
      Execute shall only be called by @link(TThumbnailExtractor). }
    procedure Execute; override;
  public
    { Creates an instance of a job control object.
      The parameters are assigned to the corresponding properties. }
    constructor Create(ATicket: integer; const AFilePath: string; ASize: integer;
      ABackgroundColor: TColor);
    { Destroy the object instance and its components. }
    destructor  Destroy; override;
    { Path to the file to be examined. }
    property  FilePath: string read FFilePath write FFilePath;
    { Width and height of the thumbnail }
    property  Size: integer read FSize write FSize;
    { Background color }
    property  BackgroundColor: TColor read FBackgroundColor write FBackgroundColor;
    { Indicates whether @link(FilePath) specifies a valid file path.
      This property is not implemented yet. }
    property  BildStatus: TBildStatus read FBildStatus;
    { Kind of icon that can be displayed for the sammelobjekt }
    property  IconKind: TIconKind read FIconKind;
    { Thumbnail output, if available.
      Each call creates a new TBitmap of the thumbnail
      which the caller can use and destroy to its own discretion.
      The bitmap is created from an internal memory stream.
      This works around some VCL/GDI thread issues.
      Call this method only after the job has successfully executed
      (@link(Status) = @link(jsSuccess)).
      @returns(the thumbnail bitmap.
        The caller assumes ownership and will destroy the object.
        @nil if no thumbnail is available. )  }
    function  GetThumbnail: TBitmap;
  end;

implementation

uses
  Types, Math, karsreg, jpeg;

{ TExtractThumbnailJob }

constructor TExtractThumbnailJob.Create;
begin
  inherited Create(ATicket);
  FFilePath := AFilePath;
  FSize := ASize;
  FBackgroundColor := ABackgroundColor;
  FBildStatus := bsPending;
  FIconKind := ikUnknown;
end;

destructor TExtractThumbnailJob.Destroy;
begin
  FreeAndNil(FThumbnail);
  FreeAndNil(FStream);
  inherited;
end;

procedure TExtractThumbnailJob.LoadPicture;
var
  scale: Integer;
  JPEGImage: TJPEGImage;
begin
  Picture.LoadFromFile(FFilePath);
  if Picture.Graphic is TJPEGImage then begin
    JPEGImage := TJPEGImage(Picture.Graphic);
    scale := Min(Picture.Width, Picture.Height) div FSize;
    if scale >= 8 then
      JPEGImage.Scale := jsEighth
    else if scale >= 4 then
      JPEGImage.Scale := jsQuarter
    else if scale >= 2 then
      JPEGImage.Scale := jsHalf
    else
      JPEGImage.Scale := jsFullSize;
  end;
end;

procedure TExtractThumbnailJob.CalcShrinkSize;
begin
  if (Picture.Width > 0) and (Picture.Height > 0) then begin
    if Picture.Width >= Picture.Height then begin
      width := (FSize * Picture.Width) div Picture.Height;
      height := Min(FSize, Picture.Height);
    end else begin
      width := Min(FSize, Picture.Width);
      height := (FSize * Picture.Height) div Picture.Width;
    end;
  end else begin
    width := 0;
    height := 0;
  end;
  PictRect.Left := (FSize - width) div 2;
  PictRect.Top := (FSize - height) div 2;
  PictRect.Right := PictRect.Left + width;
  PictRect.Bottom := PictRect.Top + height;
end;

function TExtractThumbnailJob.IsFaultyBitmap;
var
  iup, idown: integer;
  col: TColor;
begin
  Result := Bitmap.Empty;
  if not result then begin
    col := Bitmap.Canvas.Pixels[0, 0];
    Result := true;
    iup := 0;
    for idown := Min(Bitmap.Width, Bitmap.Height) - 1 downto 0 do begin
      if
        (col <> Bitmap.Canvas.Pixels[idown, idown]) or
        (col <> Bitmap.Canvas.Pixels[iup, idown])
      then begin
        Result := false;
        Break;
      end;
      Inc(iup);
    end;
  end;
end;

function TExtractThumbnailJob.DrawThumbnail;
var
  BGRect: TRect;
  rpt: integer;
begin
  if not Assigned(FThumbnail) then FThumbnail := TBitmap.Create;
  rpt := 3;
  repeat
    FThumbnail.Canvas.Lock;
    try
      FThumbnail.SetSize(FSize, FSize);
      if (width < FSize) or (height < FSize) then begin
        BGRect := FThumbnail.Canvas.ClipRect;
        with FThumbnail.Canvas.Brush do begin
          Style := bsSolid;
          Color := FBackgroundColor;
        end;
        FThumbnail.Canvas.FillRect(BGRect);
      end;
      if (width > 0) and (height > 0) then
        FThumbnail.Canvas.StretchDraw(PictRect, Picture.Graphic);
      result := not IsFaultyBitmap(FThumbnail);
    finally
      FThumbnail.Canvas.Unlock;
    end;
    if not result then Sleep(0);
    Dec(rpt);
  until
    result or (rpt <= 0);
end;

procedure TExtractThumbnailJob.Execute;
var
  Picture: TPicture;
  newWidth, newHeight: integer;
  PictRect: TRect;
  gf: TGrafikformat;
begin
  FreeAndNil(FThumbnail);
  FreeAndNil(FStream);
  gf := MediaTypes.GetGrafikformat(ExtractFileExt(FilePath));
  FIconKind := CGrafikformatIconKind[gf];
  if
    (FIconKind = ikPicture) and
    (FSize > 0)
  then begin
    Picture := TPicture.Create;
    try
      try
        LoadPicture(Picture);
        CalcShrinkSize(Picture, newWidth, newHeight, PictRect);
        if DrawThumbnail(Picture, newWidth, newHeight, PictRect) then
          SaveToStream
        else
          SetStatus(jsFail);
      except
        on EInvalidGraphic do begin
          FBildStatus := bsReadError;
        end;
        on EInvalidOperation do begin
          SetStatus(jsFail);
        end;
      end;
    finally
      Picture.Free;
      FreeAndNil(FThumbnail);
    end;
  end;
  if Status <> jsFail then SetStatus(jsSuccess);
end;

procedure TExtractThumbnailJob.SaveToStream;
begin
  if Assigned(FThumbnail) then begin
    if not Assigned(FStream) then
      FStream := TMemoryStream.Create
    else
      (FStream as TMemoryStream).Clear;
    FStream.Position := 0;
    FThumbnail.Canvas.Lock;
    try
      FThumbnail.SaveToStream(FStream);
    finally
      FThumbnail.Canvas.Unlock;
    end;
  end else
    FreeAndNil(FStream);
end;

function TExtractThumbnailJob.GetThumbnail: TBitmap;
begin
  if (Status = jsSuccess) and Assigned(FStream) then begin
    FStream.Position := 0;
    Result := TBitmap.Create;
    Result.LoadFromStream(FStream);
  end else begin
    Result := nil;
  end;
end;

end.
