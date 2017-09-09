unit dtpTestProcedures;

interface

uses
  dtpPage;

procedure PrintPagesAsJpg;
procedure ConvertSnapToCrop;
procedure FillCropBitmaps;
procedure PageWithFontGlyphs(APage: TdtpPage; const AFontName: string; AFontHeight: double);

implementation

uses
  Classes, SysUtils, Graphics, dtpRasterFormats, Controls, Forms, dtpEditorMain, dtpGraphics,
  dtpShape, dtpBitmapShape, dtpResource, Dialogs, ExtDlgs, Jpeg, dtpCropBitmap,
  dtpDefaults, dtpTextShape, dtpPolygonText;

procedure PrintPagesAsJpg;
// Test: print all pages as jpeg
var
  i: integer;
  ABitmap: TBitmap;
  AFiler: TdtpImageFiler;
  ADib: TdtpBitmap;
begin
  with frmMain do begin
    Screen.Cursor := crHourglass;
    Document.OnProgress := nil;
    for i := 0  to Document.PageCount - 1 do begin
      ABitmap := TBitmap.Create;
      try
        // Create a bitmap, at 300 DPI (page sizes are in mm)
        ABitmap.PixelFormat := pf24bit;
        ABitmap.Width  := round(Document.Pages[i].DocWidth * 300 / 25.4);
        ABitmap.Height := round(Document.Pages[i].DocHeight * 300 / 25.4);
        // Print to the bitmap
        Document.Pages[i].Print(ABitmap.Canvas,
          Rect(0, 0, ABitmap.Width, ABitmap.Height), 0, 0, False, False);
        // Create a filer that will save it for us
        AFiler := TdtpImageFiler.Create;
        try
          ADib := TdtpBitmap.Create;
          try
            ADib.Assign(ABitmap);
            AFiler.FileName := Format('c:\temp\test%.4d.jpg', [i + 1]);
            AFiler.SaveDIB(ADib);
            sbMain.Panels[1].Text := Format('Printing page %d of %d', [i + 1, Document.PageCount]);
            Application.ProcessMessages;
          finally
            ADib.Free;
          end;
        finally
          AFiler.Free;
        end;
      finally
        ABitmap.Free;
      end;
    end;
    Screen.Cursor := crDefault;
  end;
end;

procedure ConvertSnapToCrop;
// Test: convert all snapbitmaps to cropbitmaps
var
  i, j: integer;
  ACrop: TdtpCropBitmap;
begin
  with frmMain do begin
    for i := 0 to Document.PageCount - 1 do begin
      Document.Pages[i].LoadPageAsNeeded;
      for j := 0 to Document.Pages[i].ShapeCount - 1 do begin
        if Document.Pages[i].Shapes[j].ClassType = TdtpSnapBitmap then begin
          ACrop := TdtpCropBitmap.Create;
          ACrop.Assign(Document.Pages[i].Shapes[j]);
          Document.Pages[i].ShapeDelete(j);
          Document.Pages[i].ShapeInsert(j, ACrop);
          ACrop.Image.Storage := rsArchive;
        end;
      end;
    end;
  end;
end;

procedure FillCropBitmaps;
// Test: fill all empty cropbitmaps with a photo from a list
var
  i, j: integer;
  FileList: TStringList;
  FileIdx: integer;
  AShape: TdtpShape;
  AJpg: TJpegImage;
  ABmp: TdtpBitmap;
begin
  with frmMain do begin
    AbortTest := False;
    FileList := TStringList.Create;
    try
      // First: open a dialog to let the user select some graphics files
      with TOpenPictureDialog.Create(Application) do
        try
          Title := 'Multi-select some images for filling';
          Filter := RasterFormatOpenFilter;
          Options := Options + [ofAllowMultiSelect];
          if Execute then
            FileList.Assign(Files);
        finally
          Free;
        end;
      if FileList.Count = 0 then exit;
      // Now fill
      FileIdx := 0;
      for i := 0 to Document.PageCount - 1 do begin
        Document.Pages[i].LoadPageAsNeeded;
        for j := 0 to Document.Pages[i].ShapeCount - 1 do begin
          sbMain.Panels[1].Text := Format('Filling page %d of %d', [i + 1, Document.PageCount]);
          Application.ProcessMessages;
          AShape := Document.Pages[i].Shapes[j];
          if (AShape is TdtpCropBitmap) and TdtpCropBitmap(AShape).IsEmpty then
          begin
//            TdtpCropBitmap(AShape).Image.LoadFromFile(FileList[FileIdx]);
            // Test: load to bitmap
            AJpg := TJpegImage.Create;
            ABmp := TdtpBitmap.Create;
            try
              AJpg.LoadFromFile(FileList[FileIdx]);
              ABmp.Assign(AJpg);
              TdtpCropBitmap(AShape).Image.Storage := rsArchive;
              TdtpCropBitmap(AShape).Image.LoadFromBitmap(ABmp);
            finally
              AJpg.Free;
              ABmp.Free;
            end;
            inc(FileIdx);
          end;
          if FileIdx = FileList.Count then exit;//FileIdx := 0;
          if AbortTest then break;
        end;
        Document.Pages[i].UpdateThumbnail;
        if AbortTest then break;
      end;
    finally
      FileList.Free;
    end;
  end;
end;

procedure PageWithFontGlyphs(APage: TdtpPage; const AFontName: string; AFontHeight: double);
var
  x, y: integer;
  Margin, W, H: double;
  AText: TdtpPolygonText;
begin
  Margin := APage.DocWidth * 0.05;
  W := APage.DocWidth - 2 * Margin;
  H := APage.DocHeight - 2 * Margin;
  for y := 0 to 13 do
    for x := 0 to 15 do begin
      AText := TdtpPolygonText.Create;
      AText.Text := widechar((y + 2) * 16 + x);
      AText.DocLeft := Margin + x / 16 * W;
      AText.DocTop := Margin + y / 14 * H;
      AText.FontName := AFontName;
      AText.FontHeight := AFontHeight;
      APage.ShapeAdd(AText);
    end;
end;

end.
