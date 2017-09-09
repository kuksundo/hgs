{ main form of LPR demo

  author: Nils Haeck M.Sc.
  copyright (c) 2007 SimDesign BV
  
}
unit frmMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ActnList, Menus, ComCtrls, ExtCtrls, ExtDlgs, Jpeg, sdOcr,
  NativeXml, ShellApi, Gr32, Gr32_Blend, Gr32_Polygons,
  ToolWin, CheckLst, Gr32_OrdinalMaps, Math;

const
  cCaption = 'License Plate Recognition Demo';

type
  TfmMain = class(TForm)
    StatusBar1: TStatusBar;
    mnuMain: TMainMenu;
    File1: TMenuItem;
    alMain: TActionList;
    acFileOpen: TAction;
    Open1: TMenuItem;
    Tools1: TMenuItem;
    acRecogniseAll: TAction;
    Recognise1: TMenuItem;
    acGlyphStats: TAction;
    acGlyphStats1: TMenuItem;
    acShowTrainers: TAction;
    View1: TMenuItem;
    ShowTrainers1: TMenuItem;
    acSaveOcrSetup: TAction;
    SaveTrainers1: TMenuItem;
    acLoadOcrSetup: TAction;
    LoadTrainers1: TMenuItem;
    pcMain: TPageControl;
    tsRecognise: TTabSheet;
    sbOcr: TScrollBox;
    imOCR: TImage;
    Label1: TLabel;
    mmTexts: TMemo;
    Label2: TLabel;
    mmMessages: TMemo;
    Label3: TLabel;
    udGlyph: TUpDown;
    lbGlyphNo: TLabel;
    Button1: TButton;
    tsTrainers: TTabSheet;
    ScrollBox2: TScrollBox;
    imTrainers: TImage;
    tsEditor: TTabSheet;
    tsOCRSettings: TTabSheet;
    Label4: TLabel;
    lbTrainers: TListBox;
    Label5: TLabel;
    CheckListBox1: TCheckListBox;
    ScrollBox3: TScrollBox;
    Label7: TLabel;
    Image1: TImage;
    imGlyph: TImage;
    lbAlternatives: TListBox;
    Label6: TLabel;
    btnRecognise: TButton;
    btnOpenBitmap: TButton;
    aGlyphToEditor: TAction;
    Button2: TButton;
    acTrainerNew: TAction;
    acTrainerDelete: TAction;
    Button3: TButton;
    GroupBox1: TGroupBox;
    chbAdaptiveTreshold: TCheckBox;
    Label8: TLabel;
    rbSingleTreshold: TRadioButton;
    rbDualTreshold: TRadioButton;
    Label9: TLabel;
    edTreshold: TEdit;
    udTreshold: TUpDown;
    Label10: TLabel;
    edTresholdLo: TEdit;
    udTresholdLo: TUpDown;
    GroupBox2: TGroupBox;
    edMinGlyphWidth: TEdit;
    Label11: TLabel;
    udMinGlyphWidth: TUpDown;
    Label12: TLabel;
    edMaxGlyphWidth: TEdit;
    udMaxGlyphWidth: TUpDown;
    Label13: TLabel;
    edMinGlyphHeight: TEdit;
    udMinGlyphHeight: TUpDown;
    Label14: TLabel;
    edMaxGlyphHeight: TEdit;
    udMaxGlyphHeight: TUpDown;
    Label15: TLabel;
    edMinGlyphPointCount: TEdit;
    udMinGlyphPointCount: TUpDown;
    acExit: TAction;
    N1: TMenuItem;
    Exit1: TMenuItem;
    procedure acFileOpenExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure acRecogniseAllExecute(Sender: TObject);
    procedure acGlyphStatsExecute(Sender: TObject);
    procedure acShowTrainersExecute(Sender: TObject);
    procedure udGlyphClick(Sender: TObject; Button: TUDBtnType);
    procedure imOCRMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure acSaveOcrSetupExecute(Sender: TObject);
    procedure acLoadOcrSetupExecute(Sender: TObject);
    procedure aGlyphToEditorExecute(Sender: TObject);
    procedure acTrainerNewExecute(Sender: TObject);
    procedure pcMainChange(Sender: TObject);
    procedure pcMainChanging(Sender: TObject; var AllowChange: Boolean);
    procedure acExitExecute(Sender: TObject);
  private
    FOcr: TsdOcrModule;
    FOcrBitmap: TBitmap;
    FScale: integer;
    FIsUpdating: boolean;
    procedure SetCurrentGlyph(AGlyph: TsdOcrGlyph);
    procedure UpdateTrainers;
    procedure UpdateOcrBitmap;
    procedure OcrDebugMessage(Sender: TObject; AMessage: string);
    procedure OcrDrawChar(Sender: TObject; X, Y: single; FontName: string; Character: widechar; FontSize: integer);
    procedure OcrDrawDot(Sender: TObject; X, Y: single; Color: TColor);
    procedure OcrDrawLine(Sender: TObject; StartX, StartY, CloseX, CloseY: single; Color: TColor);
    procedure OcrDrawMap(Sender: TObject; StartX, StartY: integer; Map: TByteMap);
    procedure LoadSettingsFromXml(ANode: TXmlNode);
    procedure SaveSettingsToXml(ANode: TXmlNode);
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

{$R *.DFM}

type
  THackOcr = class(TsdOcrModule);

procedure TfmMain.acFileOpenExecute(Sender: TObject);
var
  APicture: TPicture;
  OPD: TOpenPictureDialog;
begin
  OPD := TOpenPictureDialog.Create(nil);
  try
    OPD.Title := 'Select an image';
    OPD.Filter :=
      'Images (*.bmp, *.jpg)|*.bmp;*.jpg|' +
      'All files|*.*';
    if OPD.Execute then
    begin
      APicture := TPicture.Create;
      try
        APicture.LoadFromFile(OPD.FileName);
        FOcrBitmap.Assign(APicture.Graphic);
        UpdateOcrBitmap;;
        Caption := cCaption + Format(' [%s]', [ExtractFileName(OPD.FileName)]);
      finally
        APicture.Free;
      end;
    end;
  finally
    OPD.Free;
  end;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  FScale := 2;
  FOcr := TsdOcrModule.Create;
  FOcr.MinGroupLength := 5;
//FOcr.IncludeSpaces := True;
//  FOcr.AutoAspectCorrect := True;
//  FOcr.GroupwiseDeskew := True;
{ // For Lapo Guidi
  FOcr.TresholdType := cttSingle;
  FOcr.AdaptiveTreshold := True;
  FOcr.Treshold := 80;
  FOcr.MapConversion := ctRed;
  FOcr.MinConfidence := 0.70;
  FOcr.AddTrainerCharacters('Verdana Bold', '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');}

//  FOcr.TresholdType := cttSingle;
  FOcr.AdaptiveTreshold := True;
//  FOcr.MapConversion := ctRed;
  FOcr.Treshold := 70;
  FOcr.TresholdLo := 40;

  FOcr.OnDebugMessage := OcrDebugMessage;
  FOcr.OnDrawChar := OcrDrawChar;
  FOcr.OnDrawDot  := OcrDrawDot;
  FOcr.OnDrawLine := OcrDrawLine;
  FOcr.OnDrawMap  := OcrDrawMap;

  // Add trainer chars - this is quite a hefty work since we must
  // select the correct font and character combinations! Some may
  // Double up; the OCR will find the best suitable font.
{  FOcr.AddTrainerCharacters('Accidental Presidency', '0123456789');
  FOcr.AddTrainerCharacters('Larabiefont',           '7');
  FOcr.AddTrainerCharacters('Italian Plates 1999',   '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ', [fsBold]);}
//  FOcr.AddTrainerCharacters('Haettenschweiler', '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
//  FOcr.AddTrainerCharacters('Impact', '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
//  FOcr.AddTrainerCharacters('Licenz Plate', '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  //
  UpdateTrainers;
  pcMain.ActivePage := tsRecognise;
  FOcrBitmap := TBitmap.Create;
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FOcr);
  FreeAndNil(FOcrBitmap);
end;

procedure TfmMain.acRecogniseAllExecute(Sender: TObject);
begin
  Screen.Cursor := crHourglass;
  try
    mmMessages.Clear;
    UpdateOcrBitmap;
    FOcr.Recognise;
    mmTexts.Lines.Text := FOcr.Text;
    udGlyph.Max := THackOcr(FOcr).Glyphs.Count - 1;
    udGlyph.Position := 0;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfmMain.OcrDebugMessage(Sender: TObject; AMessage: string);
begin
  mmMessages.Lines.Add(AMessage);
end;

procedure TfmMain.OcrDrawChar(Sender: TObject; X, Y: single;
  FontName: string; Character: widechar; FontSize: integer);
var
  C: TCanvas;
begin
  C := imOcr.Picture.Bitmap.Canvas;
  Name := FontName;
  C.Font.Size := FontSize;
  C.TextOut(round((X + 0.5) * FScale), round((Y + 0.5) * FScale), Character);
end;

procedure TfmMain.OcrDrawDot(Sender: TObject; X, Y: single; Color: TColor);
begin
  imOcr.Picture.Bitmap.Canvas.Pixels[round((X + 0.5) * FScale), round((Y + 0.5) * FScale)] := Color;
end;

procedure TfmMain.OcrDrawLine(Sender: TObject; StartX, StartY, CloseX,
  CloseY: single; Color: TColor);
var
  C: TCanvas;
begin
  C := imOcr.Picture.Bitmap.Canvas;
  C.Pen.Color := Color;
  C.MoveTo(round((StartX + 0.5) * FScale), round((StartY + 0.5) * FScale));
  C.LineTo(round((CloseX + 0.5) * FScale), round((CloseY + 0.5) * FScale));
end;

procedure TfmMain.acGlyphStatsExecute(Sender: TObject);
var
  i: integer;
  ADoc: TNativeXml;
  ANode: TXmlNode;
begin
  ADoc := TNativeXml.CreateName('Glyphs');
  try
    with THackOcr(FOcr) do
      for i := 0 to Glyphs.Count - 1 do
      with Glyphs[i] do
      begin
        ANode := ADoc.Root.NodeNew('Glyph');
        ANode.WriteInteger('Left', round(Bounds.Left));
        ANode.WriteInteger('Top', round(Bounds.Top));
        ANode.WriteInteger('Width', round(Width));
        ANode.WriteInteger('Height', round(Height));
        ANode.WriteInteger('FillPercent', round(100 * FillPercent));
        ANode.WriteInteger('Pointcount', round(Pointcount));
      end;
    ADoc.XmlFormat := xfReadable;
    ADoc.SaveToFile('glyphs.txt');
    ShellExecute(Handle, 'open', 'glyphs.txt', nil, nil, SW_SHOWDEFAULT);
  finally
    ADoc.Free;
  end;
end;

procedure TfmMain.acShowTrainersExecute(Sender: TObject);
// Create an image of all trainers and show it
begin
  UpdateTrainers;
  pcMain.ActivePage := tsTrainers;
end;

procedure TfmMain.udGlyphClick(Sender: TObject; Button: TUDBtnType);
// Show the selected glyph and its most probable candidate
const
  cHeight = 200;
var
  AGroup: TsdOcrGroup;
  AGlyph: TsdOcrGlyph;
begin
  lbGlyphNo.Caption := Format('Glyph #%d', [udGlyph.Position + 1]);
  imGlyph.Picture.Bitmap := nil;
  AGroup := THackOcr(FOcr).Groups[0];
  if not assigned(AGroup) then
    exit;
  AGlyph := AGroup.Glyphs[udGlyph.Position];
  SetCurrentGlyph(AGlyph);
end;

procedure TfmMain.SetCurrentGlyph(AGlyph: TsdOcrGlyph);
// Show the selected glyph and its most probable candidate
const
  cHeight = 200;
var
  i, j, x, y: integer;
  ADib: TBitmap32;
  AColor: TColor32;
  APoint: TPoint;
begin
  if not assigned(AGlyph) then
    exit;

  AGlyph.Recognise;
  lbGlyphNo.Caption := Format('Char "%s" (%.2d%%)', [string(AGlyph.Character), round(AGlyph.Score * 100)]);
  ADib := TBitmap32.Create;
  try
    ADib.SetSize(cHeight div 2, cHeight);
    ADib.Clear(clWhite32);
    // Draw trainer
    if assigned(AGlyph.Trainer) then
    with AGlyph.Trainer do
    begin
      for y := 0 to Map.Height - 1 do
        for x := 0 to Map.Width - 1 do
        begin
          AColor := $FF00FFFF + dword((255 - Map[x, y]) shl 16);
          for i := 0 to 3 do
            for j := 0 to 3 do
              ADib[x * 4 + i, y * 4 + j] := AColor;
        end;
      for i := 0 to SegmentCount - 1 do
      with Segments[i] do
      begin
        AColor := CombineReg(clGreen32, clLightGray32, round(255 * Visited));
        EMMS;
        ADib.Line(
          round(cHeight * Start.X), round(cHeight * Start.Y),
          round(cHeight * Close.X), round(cHeight * Close.Y),
          AColor);

      end;
    end;
    // Draw scaled points
    with AGlyph do
      for i := 0 to PointCount - 1 do
      begin
        AColor := clBlack32;
        APoint := Point(
          round((cHeight-1) * ScaledPoints[i].X),
          round((cHeight-1) * ScaledPoints[i].Y));
        ADib.Pixels[APoint.X, APoint.Y]     := AColor;
        ADib.Pixels[APoint.X + 1, APoint.Y] := AColor;
        ADib.Pixels[APoint.X, APoint.Y + 1] := AColor;
        ADib.Pixels[APoint.X + 1, APoint.Y + 1] := AColor;
      end;
    imGlyph.Picture.Bitmap.Assign(ADib);
    imGlyph.Invalidate;

    // Alternatives
    lbAlternatives.Clear;
    for i := 0 to AGlyph.Candidates.Count - 1 do
    with AGlyph.Candidates[i] do
      lbAlternatives.Items.Add(Format('Char "%s" (%3.1f%%)', [string(Character), Score * 100]));

  finally
    ADib.Free;
  end;
end;

procedure TfmMain.imOCRMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
// User clicks on glyph
var
  i: integer;
begin
  if Button = mbLeft then
  begin
    X := X div 2;
    Y := Y div 2;
    // Find accompanying glyph
    with THackOcr(FOcr) do
      for i := 0 to Glyphs.Count - 1 do
      with Glyphs[i] do
        if (X > Bounds.Left) and (X < Bounds.Right) and
           (Y > Bounds.Top) and  (Y < Bounds.Bottom) then
        begin
          SetCurrentGlyph(Glyphs[i]);
        end;
  end;
end;

procedure TfmMain.acSaveOcrSetupExecute(Sender: TObject);
begin
  with TSaveDialog.Create(nil) do
    try
      Title := 'Save trainer file';
      Filter := 'Trainer files (*.xml)|*.xml';
      if Execute then
      begin
        FOcr.SaveToFile(FileName);
      end;
    finally
      Free;
    end;
end;

procedure TfmMain.acLoadOcrSetupExecute(Sender: TObject);
begin
  with TOpenDialog.Create(nil) do
    try
      Title := 'Open trainer file';
      Filter := 'Trainer files (*.xml)|*.xml';
      if Execute then
        FOcr.LoadFromFile(FileName);
      UpdateTrainers;  
    finally
      Free;
    end;
end;

procedure TfmMain.UpdateTrainers;
// Create an image of all trainers and show it
const
  cCellWidth  = 80;
  cCellHeight = 80;
var
  i, j, k, r, c: integer;
  ADib: TBitmap32;
  ColCount, RowCount: integer;
  APoly: TPolygon32;
  Trainer: TsdOCRTrainer;
  FP: TFixedPoint;
begin
  FIsUpdating := True;
  try
    // Update Trainers Tab
    ADib := TBitmap32.Create;
    try
      // Determine size
      ColCount := Max(1, round(sqrt(FOcr.Trainers.Count) * 1.3));
      RowCount := (FOcr.Trainers.Count + ColCount - 1) div ColCount;
      ADib.SetSize(ColCount * cCellWidth, RowCount * cCellHeight);
      ADib.Clear(clWhite32);
      ADib.Font.Size := 10;
      // Draw the trainers
      for i := 0 to FOcr.Trainers.Count - 1 do
      begin
        Trainer := FOcr.Trainers[i];
        c := i mod ColCount;
        r := i div ColCount;
        APoly := TPolygon32.Create;
        try
          // copy the points
          for j := 0 to High(Trainer.Poly.Points) do
          begin
            APoly.Points[j] := Copy(Trainer.Poly.Points[j], 0, Length(Trainer.Poly.Points[j]));
            if J < High(Trainer.Poly.Points) then
              APoly.NewLine;
          end;
          // Descale in X
          for j := 0 to High(APoly.Points) do
            for k := 0 to High(APoly.Points[j]) do
            begin
              FP := APoly.Points[j][k];
              if Trainer.AspectRatio > 0 then
                FP.X := round(FP.X / Trainer.AspectRatio);
            end;
          // Offset to correct cell
          APoly.Offset((c * cCellWidth  + 2) * $10000, (r * cCellHeight + 2) * $10000);
          // Draw the polyline
          APoly.Draw(ADib, clBlack32, $FFCCCCFF);
          // Offset back
          APoly.Offset(-(c * cCellWidth + 2) * $10000, -(r * cCellHeight + 2) * $10000);
        finally
          APoly.Free;
        end;
        ADib.TextOut(c * cCellWidth  + 2, r * cCellHeight + -28 + cCellHeight, Format('%d segments', [Trainer.SegmentCount]));
        ADib.TextOut(c * cCellWidth  + 2, r * cCellHeight + -16 + cCellHeight, Format('Aspect: %3.1f', [Trainer.AspectRatio]));
      end;
      // Show
      imTrainers.Picture.Bitmap.Assign(ADib);
    finally
      ADib.Free;
    end;

    // Update Editor Tab
    for i := 0 to FOcr.Trainers.Count - 1 do
    begin
      Trainer := FOcr.Trainers[i];
      if lbTrainers.Items.Count <= i then
        lbTrainers.Items.Add('');
      lbTrainers.Items[i] := Format('"%s" %s', [string(Trainer.Character), Trainer.FontName]);
    end;
    while lbTrainers.Items.Count > FOcr.Trainers.Count do
      lbTrainers.Items.Delete(lbTrainers.Items.Count - 1);

  finally
    FIsUpdating := False;
  end;
end;

procedure TfmMain.aGlyphToEditorExecute(Sender: TObject);
begin
//
end;

procedure TfmMain.acTrainerNewExecute(Sender: TObject);
var
  ATrainer: TsdOcrTrainer;
begin
  ATrainer := TsdOcrTrainer.Create(FOcr);
  ATrainer.Character := '#';
  ATrainer.Fontname := 'Custom';
  FOcr.AddTrainer(ATrainer);
  UpdateTrainers;
end;

procedure TfmMain.UpdateOcrBitmap;
var
  AScaled: TBitmap;
begin
  if not assigned(FOcrBitmap) then
    exit;
  AScaled := TBitmap.Create;
  try
    FOcr.AssignBitmap(FOcrBitmap);
    AScaled.Width  := FScale * FOcrBitmap.Width;
    AScaled.Height := FScale * FOcrBitmap.Height;
    AScaled.PixelFormat := pf24Bit;
    AScaled.Canvas.StretchDraw(
    Rect(0, 0, FScale * FOcrBitmap.Width, FScale * FOcrBitmap.Height),
      FOcrBitmap);
    imOcr.Picture.Bitmap.Assign(AScaled);
    imOcr.Invalidate;
    Application.ProcessMessages;
  finally
    AScaled.Free;
  end;
end;

procedure TfmMain.OcrDrawMap(Sender: TObject; StartX, StartY: integer; Map: TByteMap);
var
  x, y, i, j, XPos: integer;
  AValue: byte;
  AScan: PByteArray;
begin
  for y := 0 to Map.Height - 1 do
    for j := 0 to FScale - 1 do
    begin
      AScan := imOcr.Picture.Bitmap.Scanline[(y + StartY) * FScale + j];
      for x := 0 to Map.Width - 1 do
      with imOcr.Picture.Bitmap.Canvas do
        for i := 0 to FScale - 1 do
        begin
          XPos := ((x + StartX) * FScale + i) * 3;
          AValue := Map[x, y];
          AScan^[XPos    ] := AValue;
          AScan^[XPos + 1] := AValue;
          AScan^[XPos + 2] := AValue;
        end;
    end;
  imOcr.Invalidate;
end;

procedure TfmMain.LoadSettingsFromXml(ANode: TXmlNode);
var
  ATresholdType: TsdOcrTresholdType;
begin
  chbAdaptiveTreshold.Checked := ANode.ReadBool('AdaptiveTreshold');
  //  FAllowSlowSearch: boolean;// If true, bruteforce search methods are used in some cases (Default = false)
  //  FAutoAspectCorrect: boolean; // Correct aspect ratio with a bias (default = false)
  //  FGroupwiseDeskew: boolean;// If true, deskew in Y for complete group instead individually
  //  FIncludeSpaces: boolean;  // Include spaces in the final lines of text (if characters are spaced)
  //  FMapConversion: TConversionType;
{  FMinConfidence := ANode.ReadFloat('MinConfidence', FMinConfidence);}
  udMinGlyphHeight.Position := round(ANode.ReadFloat('MinGlyphHeight'));
  udMaxGlyphHeight.Position := round(ANode.ReadFloat('MaxGlyphHeight'));
  udMinGlyphWidth.Position := round(ANode.ReadFloat('MinGlyphWidth'));
  udMaxGlyphWidth.Position := round( ANode.ReadFloat('MaxGlyphWidth'));
  udMinGlyphPointCount.Position := ANode.ReadInteger('MinGlyphPointCount');
{  FMinGroupLength := ANode.ReadInteger('MinGroupLength',  FMinGroupLength);
  FMaxTextRotation := ANode.ReadFloat('MaxTextRotation', FMaxTextRotation);
  FDeskewStepCount := ANode.ReadInteger('DeskewStepCount',  FDeskewStepCount);
  FRecognitionMethod := TRecognitionMethodType(ANode.ReadInteger('RecognitionMethod',  integer(FRecognitionMethod)));
  FTrainerTolerance := ANode.ReadFloat('TrainerTolerance',  FTrainerTolerance);}
  ATresholdType := TsdOcrTresholdType(ANode.ReadInteger('TresholdType'));
  rbSingleTreshold.Checked := ATresholdType = cttSingle;
  rbDualTreshold.Checked := ATresholdType = cttDual;
  udTreshold.Position := ANode.ReadInteger('Treshold');
  udTresholdLo.Position := ANode.ReadInteger('TresholdLo');
//
end;

procedure TfmMain.SaveSettingsToXml(ANode: TXmlNode);
var
  ATresholdType: TsdOcrTresholdType;
begin
  ANode.WriteBool('AdaptiveTreshold', chbAdaptiveTreshold.Checked);
  //  FAllowSlowSearch: boolean;// If true, bruteforce search methods are used in some cases (Default = false)
  //  FAutoAspectCorrect: boolean; // Correct aspect ratio with a bias (default = false)
  //  FGroupwiseDeskew: boolean;// If true, deskew in Y for complete group instead individually
  //  FIncludeSpaces: boolean;  // Include spaces in the final lines of text (if characters are spaced)
  //  FMapConversion: TConversionType;
{  ANode.WriteFloat('MinConfidence', FMinConfidence);}
  ANode.WriteFloat('MinGlyphHeight', udMinGlyphHeight.Position);
  ANode.WriteFloat('MaxGlyphHeight',  udMaxGlyphHeight.Position);
  ANode.WriteFloat('MinGlyphWidth', udMinGlyphWidth.Position);
  ANode.WriteFloat('MaxGlyphWidth',  udMaxGlyphWidth.Position);
  ANode.WriteInteger('MinGlyphPointCount',  udMinGlyphPointCount.Position);
{  ANode.WriteInteger('MinGroupLength',  FMinGroupLength);
  ANode.WriteFloat('MaxTextRotation', FMaxTextRotation);
  ANode.WriteInteger('DeskewStepCount',  FDeskewStepCount);
  ANode.WriteInteger('RecognitionMethod',  integer(FRecognitionMethod));
  ANode.WriteFloat('TrainerTolerance',  FTrainerTolerance);}
  ATresholdType := cttSingle;
  if rbSingleTreshold.Checked then
    ATresholdType := cttSingle;
  if rbDualTreshold.Checked then
    ATresholdType := cttDual;
  ANode.WriteInteger('TresholdType',  integer(ATresholdType));
  ANode.WriteInteger('Treshold',  udTreshold.Position);
  ANode.WriteInteger('TresholdLo',  udTresholdLo.Position);
end;

procedure TfmMain.pcMainChange(Sender: TObject);
var
  ANode: TXmlNode;
  Xml: TNativeXml;
begin
  if TPageControl(Sender).ActivePage = tsOCRSettings then
  begin
    // Copy OCR settings
    Xml := TNativeXml.CreateName('root');
    try
      ANode := Xml.Root;
      THackOcr(FOcr).SaveSettingsToXml(ANode);
      LoadSettingsFromXml(ANode);
    finally
      Xml.Free;
    end;
  end;
end;

procedure TfmMain.pcMainChanging(Sender: TObject;
  var AllowChange: Boolean);
var
  ANode: TXmlNode;
  Xml: TNativeXml;
begin
  if TPageControl(Sender).ActivePage = tsOCRSettings then
  begin
    // Copy OCR settings
    Xml := TNativeXml.CreateName('root');
    try
      ANode := Xml.Root;
      SaveSettingsToXml(ANode);
      THackOcr(FOcr).LoadSettingsFromXml(ANode);
    finally
      Xml.Free;
    end;
  end;
end;

procedure TfmMain.acExitExecute(Sender: TObject);
begin
  Close;
end;

end.
