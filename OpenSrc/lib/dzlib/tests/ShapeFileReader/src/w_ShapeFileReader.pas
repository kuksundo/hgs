unit w_ShapeFileReader;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  u_dzShapeFileReader;

type
  TLayer = record
    FColor: TColor;
    Parts: TShapeFileReader.TShpPartArr;
  end;

type
  Tf_ShapeFileReader = class(TForm)
    b_Execute: TButton;
    m_Output: TMemo;
    b_Close: TButton;
    im_Map: TImage;
    od_Shape: TOpenDialog;
    procedure b_ExecuteClick(Sender: TObject);
    procedure b_CloseClick(Sender: TObject);
  private
    FMinX: Double;
    FMinY: Double;
    FBmpWidth: Integer;
    FBmpHeight: Integer;
    FFactor: Double;
    FColor: Integer;
    FLayers: array of TLayer;
    procedure HandleOnFileHeader(_Sender: TObject; _FileCode: LongWord; _FileLength: Int64;
      _Version: LongWord; _ShapeType: TShapeFileReader.TShapeTypeEnum;
      _XMin: Double; _YMin: Double; _ZMin: Double; _MMin: Double;
      _XMax: Double; _YMax: Double; _ZMax: Double; _MMax: Double);
    procedure HandleOnRecordHeader(_Sender: TObject; _RecordNo, _ContentLength: LongWord);
    procedure HandleOnNullShape(_Sender: TObject; _RecordNo: LongWord);
    procedure HandleOnPointShape(_Sender: TObject;
      _RecordNo: LongWord; const _Point: TShapeFileReader.TShpPoint);
    procedure HandleOnPolygonShape(_Sender: TObject; _RecordNo: LongWord;
      const _BoundingBox: TShapeFileReader.TShpBoundingBox;
      const _Parts: TShapeFileReader.TShpPartArr);
    procedure DrawLayer(const _Layer: TLayer);
    procedure HandleFilesDropped(_Sender: TObject; _Files: TStrings);
    procedure HandleOnMultiPointZShape(_Sender: TObject; _RecordNo: LongWord;
      const _BoundingBox: TShapeFileReader.TShpBoundingBoxZ;
      const _Points: TShapeFileReader.TShpPointZArr);
    procedure HandleOnMultiPointMShape(_Sender: TObject; _RecordNo: LongWord;
      const _BoundingBox: TShapeFileReader.TShpBoundingBoxM;
      const _Points: TShapeFileReader.TShpPointMArr);
  public
    constructor Create(_Owner: TComponent); override;
  end;

var
  f_ShapeFileReader: Tf_ShapeFileReader;

implementation

{$R *.dfm}

uses
  u_dzVclUtils;

const
  COLORS: array[0..4] of TColor = (
    clRed, clBlue, clGreen, clPurple, clTeal);

constructor Tf_ShapeFileReader.Create(_Owner: TComponent);
begin
  inherited;
  TWinControl_ActivateDropFiles(Self, HandleFilesDropped)
end;

procedure Tf_ShapeFileReader.HandleFilesDropped(_Sender: TObject; _Files: TStrings);
var
  Reader: TShapeFileReader;
begin
  SetLength(FLayers, 0);

  Reader := TShapeFileReader.Create;
  try
    Reader.OnFileHeader := HandleOnFileHeader;
    Reader.OnRecordHeader := HandleOnRecordHeader;
    Reader.OnNullShape := HandleOnNullShape;
    Reader.OnPointShape := HandleOnPointShape;
    Reader.OnPolyLineShape := HandleOnPolygonShape;
    Reader.OnPolygonShape := HandleOnPolygonShape;
    Reader.ReadFile(_Files[0]);
  finally
    FreeAndNil(Reader);
  end;
end;

procedure Tf_ShapeFileReader.b_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure Tf_ShapeFileReader.b_ExecuteClick(Sender: TObject);
var
  Reader: TShapeFileReader;
begin
  SetLength(FLayers, 0);

  if not od_Shape.Execute then
    exit;

  Reader := TShapeFileReader.Create;
  try
    Reader.OnFileHeader := HandleOnFileHeader;
    Reader.OnRecordHeader := HandleOnRecordHeader;
    Reader.OnNullShape := HandleOnNullShape;
    Reader.OnPointShape := HandleOnPointShape;
    Reader.OnPolyLineShape := HandleOnPolygonShape;
    Reader.OnPolygonShape := HandleOnPolygonShape;
    Reader.OnMultiPointMShape := HandleOnMultiPointMShape;
    Reader.OnMultiPointZShape := HandleOnMultiPointZShape;
//    Reader.ReadFile(TApplication_GetExePathBS + 'testdata\States21basic\states.shp');
//    Reader.ReadFile(TApplication_GetExePathBS + 'testdata\vg2500_geo84\vg2500_sta.shp');
//    Reader.ReadFile(TApplication_GetExePathBS + 'testdata\vg2500_geo84\vg2500_rbz.shp');
//    Reader.ReadFile(TApplication_GetExePathBS + 'testdata\vg2500_geo84\vg2500_krs.shp');
//    Reader.ReadFile(TApplication_GetExePathBS + 'testdata\germany-building-shape\buildings.shp');
//    Reader.ReadFile(TApplication_GetExePathBS + 'testdata\germany-places-shape\places.shp');
//    Reader.ReadFile(TApplication_GetExePathBS + 'testdata\germany-railways-shape\railways.shp');
//    Reader.ReadFile(TApplication_GetExePathBS + 'testdata\multipoint.shape\multipoint.shp');
//    Reader.ReadFile(TApplication_GetExePathBS + 'testdata\antarctica\buildings.shp');
//    Reader.ReadFile(TApplication_GetExePathBS + 'testdata\StatPlanet_Germany\map\map.shp');
//    Reader.ReadFile(TApplication_GetExePathBS + 'testdata\MapLibrary\Algeria\alg.shp');
//    Reader.ReadFile(TApplication_GetExePathBS + 'testdata\MapLibrary\Algeria\ALG_boundaries.shp');
//    Reader.ReadFile(TApplication_GetExePathBS + 'testdata\ne_10m_populated_places_simple\ne_10m_populated_places_simple.shp');
//    Reader.ReadFile(TApplication_GetExePathBS + 'testdata\ne_10m_airports\ne_10m_airports.shp');
//    Reader.ReadFile(TApplication_GetExePathBS + 'testdata\ne_10m_geography_marine_polys\ne_10m_geography_marine_polys.shp');
    Reader.ReadFile(od_Shape.FileName);
  finally
    FreeAndNil(Reader);
  end;
end;

procedure Tf_ShapeFileReader.HandleOnNullShape(_Sender: TObject; _RecordNo: LongWord);
begin
  m_Output.Lines.Add(Format('NullShape: RecordNo: %d', [_RecordNo]));
end;

procedure Tf_ShapeFileReader.HandleOnMultiPointZShape(_Sender: TObject;
  _RecordNo: LongWord; const _BoundingBox: TShapeFileReader.TShpBoundingBoxZ;
  const _Points: TShapeFileReader.TShpPointZArr);
var
  Point: TShapeFileReader.TShpPoint;
  i: Integer;
begin
  for i := Low(_Points) to High(_Points) do begin
    Point.X := _Points[i].X;
    Point.Y := _Points[i].Y;
    HandleOnPointShape(_Sender, _RecordNo, Point);
  end;
end;

procedure Tf_ShapeFileReader.HandleOnMultiPointMShape(_Sender: TObject;
  _RecordNo: LongWord; const _BoundingBox: TShapeFileReader.TShpBoundingBoxM;
  const _Points: TShapeFileReader.TShpPointMArr);
var
  Point: TShapeFileReader.TShpPoint;
  i: Integer;
begin
  for i := Low(_Points) to High(_Points) do begin
    Point.X := _Points[i].X;
    Point.Y := _Points[i].Y;
    HandleOnPointShape(_Sender, _RecordNo, Point);
  end;
end;

procedure Tf_ShapeFileReader.HandleOnPointShape(_Sender: TObject;
  _RecordNo: LongWord; const _Point: TShapeFileReader.TShpPoint);
var
  cnv: TCanvas;
  X: Integer;
  Y: Integer;
begin
  cnv := im_Map.Picture.Bitmap.Canvas;
  cnv.Lock;
  try
    cnv.Pen.Color := clBlue;
    X := Round((_Point.X - FMinX) / FFactor);
    Y := FBmpHeight - (Round((_Point.Y - FMinY) / FFactor));
    cnv.MoveTo(X - 2, Y);
    cnv.LineTo(X + 2, Y);
    cnv.MoveTo(X, Y - 2);
    cnv.LineTo(X, Y + 2);
  finally
    cnv.Unlock;
  end;
//  m_Output.Lines.Add(Format('Point: RecordNo: %d', [_RecordNo]));
//  m_Output.Lines.Add(Format('X: %f Y: %f', [_Point.X, _point.Y]));
end;

procedure Tf_ShapeFileReader.DrawLayer(const _Layer: TLayer);
var
  cnv: TCanvas;
  i: Integer;
  j: Integer;
  First: Boolean;
  X: Integer;
  Y: Integer;
begin
  cnv := im_Map.Picture.Bitmap.Canvas;
  cnv.Lock;
  try
//    m_Output.Lines.Add(Format('Layer: %d parts', [Length(_Layer.Parts)]));
    cnv.Pen.Color := _Layer.FColor;
    for i := Low(_Layer.Parts) to High(_Layer.Parts) do begin
//      m_Output.Lines.Add(Format('Part %d', [i + 1]));
      First := True;
      for j := Low(_Layer.Parts[i]) to High(_Layer.Parts[i]) do begin
        X := Round((_Layer.Parts[i][j].X - FMinX) / FFactor);
        Y := FBmpHeight - (Round((_Layer.Parts[i][j].Y - FMinY) / FFactor));
//        m_Output.Lines.Add(Format('X: %d Y: %d', [X, Y]));
        if First then begin
          cnv.MoveTo(X, Y);
          First := False;
        end else begin
          cnv.LineTo(X, Y);
        end;
      end;
    end;
  finally
    cnv.Unlock;
  end;
end;

procedure Tf_ShapeFileReader.HandleOnPolygonShape(_Sender: TObject;
  _RecordNo: LongWord;
  const _BoundingBox: TShapeFileReader.TShpBoundingBox;
  const _Parts: TShapeFileReader.TShpPartArr);
var
  i: Integer;
  j: Integer;
  Layer: ^TLayer;
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    sl.BeginUpdate;
    try
//      sl.Add(Format('Polygon: RecordNo: %d', [_RecordNo]));
//      sl.Add(Format('BoundingBox: XMin: %f XMax: %f YMin: %f YMax: %f',
//        [_BoundingBox.XMin, _BoundingBox.XMax, _BoundingBox.YMin, _BoundingBox.YMax]));

//      for i := Low(_Parts) to High(_Parts) do begin
//        sl.Add(Format('Part %d:', [i]));
//        for j := Low(_Parts[i]) to High(_Parts[i]) do begin
//          sl.Add(Format('%d: X: %f y: %f', [j, _Parts[i][j].X, _Parts[i][j].Y]));
//        end;
//      end;
    finally
      sl.EndUpdate;
    end;

//    m_Output.Lines.BeginUpdate;
//    try
//      m_Output.Lines.AddStrings(sl);
//    finally
//      m_Output.Lines.EndUpdate;
//    end;

  finally
    FreeAndNil(sl);
  end;

  SetLength(FLayers, Length(FLayers) + 1);
  Layer := @FLayers[High(FLayers)];

  Layer^.FColor := COLORS[FColor];
  FColor := (FColor + 1) mod Length(COLORS);

  SetLength(Layer^.Parts, Length(_Parts));
  for i := Low(_Parts) to High(_Parts) do begin
    SetLength(Layer^.Parts[i], Length(_Parts[i]));
    for j := Low(_Parts[i]) to High(_Parts[i]) do begin
      Layer^.Parts[i][j] := _Parts[i][j];
    end;
  end;

  DrawLayer(Layer^);

  Application.ProcessMessages;
end;

procedure Tf_ShapeFileReader.HandleOnRecordHeader(_Sender: TObject; _RecordNo, _ContentLength: LongWord);
begin
//  m_Output.Lines.Add(Format('RecordHeader: RecordNo: %d, Length: %d bytes', [_RecordNo, _ContentLength]));
end;

procedure Tf_ShapeFileReader.HandleOnFileHeader(_Sender: TObject; _FileCode: LongWord; _FileLength: Int64;
  _Version: LongWord; _ShapeType: TShapeFileReader.TShapeTypeEnum;
  _XMin: Double; _YMin: Double; _ZMin: Double; _MMin: Double;
  _XMax: Double; _YMax: Double; _ZMax: Double; _MMax: Double);
var
  cnv: TCanvas;
  f: Double;
begin
  FBmpWidth := im_Map.Width;
  FBmpHeight := im_Map.Height;
  m_Output.Lines.Add(Format('Bitmap: W: %d, H: %d', [FBmpWidth, FBmpHeight]));

  FMinX := _XMin;
  FMinY := _YMin;
  FFactor := (_XMax - _XMin) / FBmpWidth;
  f := (_YMax - _YMin) / FBmpHeight;
  if FFactor < f then
    FFactor := f;

  im_Map.Picture.Bitmap.SetSize(im_Map.Width, im_Map.Height);
  cnv := im_Map.Picture.Bitmap.Canvas;
  cnv.Lock;
  try
    cnv.Brush.Color := clWhite;
    cnv.Brush.Style := bsSolid;
    cnv.FillRect(Rect(0, 0, FBmpWidth, FBmpHeight));
    cnv.Pen.Color := clBlack;
    cnv.Pen.Mode := pmCopy;
    cnv.Pen.Style := psSolid;
//    cnv.MoveTo(0, 0);
//    cnv.LineTo(Width, Height);
  finally
    cnv.Unlock;
  end;
//  Application.HandleMessage;

  m_Output.Lines.Add(Format('FileCode: %d', [_FileCode]));
  m_Output.Lines.Add(Format('FileLength: %d bytes', [_FileLength]));
  m_Output.Lines.Add(Format('Version: %d', [_Version]));
  m_Output.Lines.Add(Format('ShapeType: %s', [TShapeFileReader.ShapeTypeToString(_ShapeType)]));
  m_Output.Lines.Add(Format('XMin/Max: %f %f', [_XMin, _XMax]));
  m_Output.Lines.Add(Format('YMin/Max: %f %f', [_YMin, _YMax]));
  m_Output.Lines.Add(Format('ZMin/Max: %f %f', [_ZMin, _ZMax]));
  m_Output.Lines.Add(Format('MMin/Max: %f %f', [_MMin, _MMax]));
end;

end.

