unit imagefunctions_Unit;

interface

///
///
///
///   shrink images - all functions inside a unit  for that purpose .....
///
///
///


uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, pngimage;



  procedure ResizeJPEG(j:TJPEGImage; AWidth,AHeight:Integer);

  procedure ResizeBitmap(imgo, imgd: TBitmap; nw, nh: Integer);

  procedure ResizePNGImage(const AFileIn, AFileOut: String; newW, newH: Integer);



implementation



///
///    http://www.delphipraxis.net/147015-jpeg-skalieren.html
///

procedure ResizeJPEG(j:TJPEGImage; AWidth,AHeight:Integer);
var Bmp1,Bmp2: TBitmap;
    Faktor: double;
begin
 Bmp1:=TBitmap.Create;
 try
  Bmp1.Assign(j);
  Bmp2:=TBitmap.Create;
  try
   with Bmp2 do begin
    if (j.Height>=j.Width) then
     begin
      Faktor := j.Width/j.Height;
      Height := AHeight;
      Width := Trunc(AHeight*Faktor)
     end; // if (j.Height>=j.Width) then

    if (j.Height<j.Width) then
     begin
      Faktor := j.Height/j.Width;
      Height := Trunc(AWidth*Faktor);
      Width := AWidth
     end; // if (j.Height>=j.Width) then

    Canvas.StretchDraw(Rect(0,0,Bmp2.Width,Bmp2.Height),Bmp1);
   end;
  j.Assign(Bmp2);
  finally
   Bmp2.Free;
  end;
 finally
  Bmp1.Free;
 end;
end;


///
///   http://www.swissdelphicenter.ch/torry/showcode.php?id=1463
///
procedure ResizeBitmap(imgo, imgd: TBitmap; nw, nh: Integer);
var
  xini, xfi, yini, yfi, saltx, salty: single;
  x, y, px, py, tpix: integer;
  PixelColor: TColor;
  r, g, b: longint;

function MyRound(const X: Double): Integer;
  begin
    Result := Trunc(x);
    if Frac(x) >= 0.5 then
      if x >= 0 then Result := Result + 1
      else
        Result := Result - 1;
    // Result := Trunc(X + (-2 * Ord(X < 0) + 1) * 0.5);
  end;

begin
  // Set target size

  imgd.Width  := nw;
  imgd.Height := nh;

  // Calcs width & height of every area of pixels of the source bitmap

  saltx := imgo.Width / nw;
  salty := imgo.Height / nh;


  yfi := 0;
  for y := 0 to nh - 1 do
  begin
    // Set the initial and final Y coordinate of a pixel area

    yini := yfi;
    yfi  := yini + salty;
    if yfi >= imgo.Height then yfi := imgo.Height - 1;

    xfi := 0;
    for x := 0 to nw - 1 do
    begin
      // Set the inital and final X coordinate of a pixel area

      xini := xfi;
      xfi  := xini + saltx;
      if xfi >= imgo.Width then xfi := imgo.Width - 1;


      // This loop calcs del average result color of a pixel area
      // of the imaginary grid

      r := 0;
      g := 0;
      b := 0;
      tpix := 0;

      for py := MyRound(yini) to MyRound(yfi) do
      begin
        for px := MyRound(xini) to MyRound(xfi) do
        begin
          Inc(tpix);
          PixelColor := ColorToRGB(imgo.Canvas.Pixels[px, py]);
          r := r + GetRValue(PixelColor);
          g := g + GetGValue(PixelColor);
          b := b + GetBValue(PixelColor);
        end;
      end;

      // Draws the result pixel

      imgd.Canvas.Pixels[x,y] :=
        rgb(MyRound(r / tpix),
        MyRound(g / tpix),
        MyRound(b / tpix)
        );
    end;
  end;
end;


///
///   resize a png image using TBITmap
///
///

procedure ResizePNGImage(const AFileIn, AFileOut: String; newW, newH: Integer);
var
  Bmp1,Bmp2   : TBitmap;
  PNG         : TPNGImage;
  JpegImg     : TJpegImage;

begin


 try

  Bmp1:=TBitmap.Create;
  Bmp2:=TBitmap.Create;
  PNG := TPNGImage.Create;


  PNG.LoadFromFile(AFileIn);
  Bmp1.Assign(PNG);

  try


   with Bmp2 do begin
        Width :=  newW;
        Height := newH;

        Canvas.StretchDraw(Rect(0,0,Bmp2.Width,Bmp2.Height),Bmp1);
   end;

  finally

  PNG.Assign(BMP2);

  PNG.SaveToFile(aFileOut);

  end;
 finally
  Bmp1.Free;
  Bmp2.Free;
  PNG.Free;
 end;
end;



end.
