{
  Unit frmAddPageWiz

  Implements a page wizard that can auto-insert a list of photos.

  Creation Date: 2003 (NH)
  Version: 1.0

  Modifications:

  Copyright (c) 2003-2004 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit frmAddPageWiz;

interface

uses
  {$IFDEF CUST1} // Commissioned work - these files are not available in common version
  dtpCropBitmap,
  {$ENDIF}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, dtpDocument, dtpGraphics, dtpBitmapShape, dtpShadoweffects,
  dtpResource, Math, dtpRasterFormats, dtpDefaults;

type
  TfmAddPageWiz = class(TForm)
    rgPerPage: TRadioGroup;
    chbAddShadow: TCheckBox;
    chbAddRandom: TCheckBox;
    btnOK: TButton;
    btnCancel: TButton;
    lbStats: TLabel;
    chbStartNewPage: TCheckBox;
    chbAutoCorrect: TCheckBox;
    Label1: TLabel;
    edMargin: TEdit;
    procedure rgPerPageClick(Sender: TObject);
  private
  public
    FFiles: TStrings;
    procedure UpdateStats;
  end;

var
  fmAddPageWiz: TfmAddPageWiz;

procedure DoInsertPhotoWiz(const AFileName: string; Document: TdtpDocument;
  Page: integer; Rect: TdtpRect; AutoOrient, AddShadow, AddRandom: boolean);

procedure DoAddFilesWizard(Document: TdtpDocument; Files: TStrings; PerPage,
  StartPage: integer; AutoOrient, AddShadow, AddRandom: boolean; Margin: single);

implementation

uses dtpEditorMain;

{$R *.DFM}

function GetSubRectangle(AMaster: TdtpRect; ALevel, AIndex: integer): TdtpRect;
// Here we get the correct sub-rectangle based on its index (works recursively)
var
  RectA, RectB: TdtpRect;
begin
  if ALevel <= 0 then
    Result := AMaster
  else begin
    if (AMaster.Right - AMaster.Left) > (AMaster.Bottom - AMaster.Top) then begin
      // Split horizontal
      RectA := dtpRect(AMaster.Left, AMaster.Top, (AMaster.Right + AMaster.Left) / 2, AMaster.Bottom);
      RectB := dtpRect((AMaster.Right + AMaster.Left) / 2, AMaster.Top, AMaster.Right, AMaster.Bottom);
    end else begin
      // Split vertical
      RectA := dtpRect(AMaster.Left, AMaster.Top, AMaster.Right, (AMaster.Top + AMaster.Bottom) / 2);
      RectB := dtpRect(AMaster.Left, (AMaster.Top + AMaster.Bottom) / 2, AMaster.Right, AMaster.Bottom);
    end;
    if (AIndex and 1) = 0 then
      Result := GetSubRectangle(RectA, ALevel - 1, AIndex shr 1)
    else
      Result := GetSubRectangle(RectB, ALevel - 1, AIndex shr 1);
  end;
end;

procedure DoInsertPhotoWiz(const AFileName: string; Document: TdtpDocument;
  Page: integer; Rect: TdtpRect; AutoOrient, AddShadow, AddRandom: boolean);
var
  {$IFDEF CUST1}
  AShape: TdtpCropBitmap;
  {$ELSE}
  AShape: TdtpBitmapShape;
  {$ENDIF}
  RWidth, RHeight: single;
  AScale: single;
  P: TdtpRect;
  Angle: single;
begin
  // Create shape
  {$IFDEF CUST1}
  AShape := TdtpCropBitmap.Create;
  AShape.AdaptAspectToImage := True;
  //AShape.OnDrawQualityIndicator := frmMain.BitmapDrawQualityIndicator;
  {$ELSE}
  AShape := TdtpBitmapShape.Create;
  {$ENDIF}
  AShape.Image.LoadFromFile(AFilename);
  AShape.Image.Storage := rsArchive;
  if AShape.Image.IsEmpty then begin
    AShape.Free;
    exit;
  end;
  RWidth  := Rect.Right - Rect.Left;
  RHeight := Rect.Bottom - Rect.Top;

  // Options
  if AddShadow then
    AShape.EffectAdd(TdtpShadowEffect.Create);
  Angle := 0;
  if AddRandom then
    Angle := (Random(1000) - 500) / 250; // +-2 degrees
  if AutoOrient then
    if Min(AShape.DocWidth  / RWidth, AShape.DocHeight / RHeight) <
       Min(AShape.DocHeight / RWidth, AShape.DocWidth  / RHeight) then
      Angle := Angle + 90;
  AShape.DocRotate(Angle);

  // Calculate size
  P := AShape.ParentRect;
  AScale := Max((P.Right - P.Left) / RWidth, (P.Bottom - P.Top) / RHeight);

  // Now fit them
  AShape.DocResize(AShape.DocWidth / AScale, AShape.DocHeight / AScale);
  AShape.Left := Rect.Left + (RWidth  - (AShape.Right - AShape.Left)) / 2;
  AShape.Top  := Rect.Top  + (RHeight - (AShape.Bottom - AShape.Top)) / 2;

  Document.Pages[Page].ShapeAdd(AShape);
end;

procedure DoAddFilesWizard(Document: TdtpDocument; Files: TStrings; PerPage,
  StartPage: integer; AutoOrient, AddShadow, AddRandom: boolean; Margin: single);
var
  i, j, FileCount: integer;
  PageIdx, PageCount: integer;
  StartFile, FileIdx: integer;
  PageR, ImageR: TdtpRect;
const
  cSubLevel: array[1..8] of integer = (0, 1, 1, 2, 2, 2, 2, 3);
begin
  if not assigned(Document) or not assigned(Files) then exit;

  Document.BeginPrinting; // Avoid screen paint for the while
  Document.BeginUndo; // Undo all in one go
  try
  FileCount := Files.Count;
  PageCount := 0;
  case PerPage of
  1: PageCount := FileCount;
  2: PageCount := (FileCount + 1) div 2;
  4: PageCount := (FileCount + 3) div 4;
  8: PageCount := (FileCount + 7) div 8;
  end;

  // Start progress
  Document.DoProgress(ptWizard, 0, PageCount, 0);

  // Split up in pages
  for i := 0 to PageCount - 1 do begin
    PageIdx := StartPage + i;

    // Make sure page exists
    if PageIdx >= Document.PageCount then
      Document.PageAdd(nil);
    if not assigned(Document.Pages[PageIdx]) then exit;

    // Calculate page rectangle
    PageR := Document.Pages[PageIdx].MarginRect;
    // Substract the margin left/top, add bottom/right
    InflateRect(PageR, Margin, Margin);

    // Do each file on the page
    StartFile := i * PerPage;
    for j := 0 to PerPage - 1 do begin

      // Verify file
      FileIdx := StartFile + j;
      if FileIdx >= FileCount then continue;

      // Get rectangle
      ImageR := GetSubRectangle(PageR, cSubLevel[PerPage], j);
      InflateRect(ImageR, -Margin, -Margin);

      // Call the individual photo insert
      DoInsertPhotoWiz(Files[FileIdx], Document, PageIdx, ImageR, AutoOrient, AddShadow, AddRandom);

      // Show progress
      Document.DoProgress(ptWizard, i + 1, PageCount, (i + (j + 1) / PerPage) / PageCount);
    end;

    // Update the new page thumbnail - important feedback for the user
    Document.Pages[PageIdx].UpdateThumbnail;
  end;

  // Terminate progress
  Document.DoProgress(ptWizard, PageCount, PageCount, 1);

  finally
    Document.EndUndo;
    Document.EndPrinting;
    Document.Invalidate;
  end;
end;

{ TfmAddPageWiz }

procedure TfmAddPageWiz.UpdateStats;
var
  FileCount, PageCount: integer;
begin
  if not assigned(FFiles) then exit;
  FileCount := FFiles.Count;
  PageCount := 0;
  case rgPerPage.ItemIndex of
  0: PageCount := FileCount;
  1: PageCount := (FileCount + 1) div 2;
  2: PageCount := (FileCount + 3) div 4;
  3: PageCount := (FileCount + 7) div 8;
  end;
  lbStats.Caption := Format('You are adding %d pages with %d images each (%d total).',
    [PageCount, 1 shl rgPerPage.ItemIndex, FileCount]);
end;

procedure TfmAddPageWiz.rgPerPageClick(Sender: TObject);
begin
  UpdateStats;
end;

end.
