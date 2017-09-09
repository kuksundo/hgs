unit u_dzShapeFileWriter;

interface

uses
  Windows,
  SysUtils,
  Classes,
  u_dzTranslator,
  u_dzShapeFileConsts,
  u_dzFileStreams;

type
  TShapeFileWriter = class
  protected
    type
      TShpMainFileHeader = packed record
        FFileCode: LongWord; // Big Endian, use FileCode function to get it in Little Endian
        Unused: array[1..5] of Integer; // Big Endian
        FFileLength: LongWord; // Big Endian, use FileLength function to get it in Little Endian
        Version: LongWord; // Little Endian
        FShapeType: LongWord; // Little Endian, use ShapeType to get it as TShapeTypeEnum
        XMin: Double; // Little Endian
        YMin: Double; // Little Endian
        XMax: Double; // Little Endian
        YMax: Double; // Little Endian
        ZMin: Double; // Little Endian
        ZMax: Double; // Little Endian
        MMin: Double; // Little Endian
        MMax: Double; // Little Endian
      end;
      TShpRecordHeader = packed record
        ///<sumamry> Record number in Big Endian format, corresponds to record number in dbf file </summary>
        FRecordNo: LongWord; // Big Endian
        ///<summary> Length of record content in Big Endian format in 16 bit words,
        ///          excluding the header size</summary>
        FContentLength: LongWord; // Big Endian
      end;
      // The .shx file consists of these records
      TShpIndexRecord = packed record
        Offset: LongWord; // Big Endian
        ContentLength: LongWord; // Big Endian
      end;
      TBoundingBox = record
        XMin: Double;
        YMin: Double;
        XMax: Double;
        YMax: Double;
        ZMin: Double;
        ZMax: Double;
        MMin: Double;
        MMax: Double;
        procedure SetXY(_XMin, _YMin: Double; _XMax, _YMax: Double);
        procedure SetXYZ(_XMin, _YMin, _ZMin: Double; _XMax, _YMax, _ZMax: Double);
        procedure SetXYM(_XMin, _YMin, _MMin: Double; _XMax, _YMax, _MMax: Double);
      end;
  private
    procedure OpenStream(const _Filename: string; var _Stream: TdzFile);
  protected
    FShapeType: TShapeTypeEnum;
    FVersion: Integer;
    FBoundingBox: TBoundingBox;
    FHasBoundingBoxBeenSet: Boolean;
    procedure WriteMainHeader(_Stream: TStream; _FileLengthInBytes: Int64);
  public
    constructor Create(_ShapeType: TShapeTypeEnum; _Version: Integer = 1000);
    procedure CalcBoundingBox; virtual; abstract;
    procedure WriteShpToFile(const _Filename: string); virtual;
    procedure WriteShpToStream(_Stream: TStream); virtual; abstract;
    procedure WriteShxToFile(const _Filename: string); virtual;
    procedure WriteShxToStream(_Stream: TStream); virtual; abstract;
    procedure WriteShpAndShx(const _BaseFilename: string); virtual;
  end;

  TShapeFileWriterPoint = class(TShapeFileWriter)
  private
    type
      TShpPointEx = record
        RecordNo: LongWord;
        Point: TShpPoint;
      end;
  private
    FPoints: array of TShpPointEx;
    FCount: Integer;
  public
    constructor Create;
    procedure SetBoundingBox(_XMin, _YMin: Double; _XMax, _YMax: Double);
    procedure CalcBoundingBox; override;
    procedure AddPoint(_x, _y: Double; _RecNo: LongWord);
    procedure WriteShpToStream(_Stream: TStream); override;
    procedure WriteShxToStream(_Stream: TStream); override;
  end;

implementation

uses
  u_dzFileUtils,
  u_dzConvertUtils;

{ TShapeFileWriterPoint }

constructor TShapeFileWriterPoint.Create;
begin
  inherited Create(stPoint);
  SetLength(FPoints, 100);
end;

procedure TShapeFileWriterPoint.AddPoint(_x, _y: Double; _RecNo: LongWord);
begin
  if FCount >= Length(FPoints) then
    SetLength(FPoints, FCount + FCount div 2);
  FPoints[FCount].Point.X := _x;
  FPoints[FCount].Point.Y := _y;
  FPoints[FCount].RecordNo := _RecNo;
  Inc(FCount);
end;

procedure TShapeFileWriterPoint.CalcBoundingBox;
var
  Min: TShpPoint;
  Max: TShpPoint;
  i: Integer;
  Pnt: PShpPoint;
begin
  if FCount = 0 then
    raise Exception.Create(_('Cannot calc a bounding box for 0 points.'));
  Min := FPoints[0].Point;
  Max := Min;
  for i := 1 to FCount - 1 do begin
    Pnt := @FPoints[i].Point;
    if Pnt.X > Max.X then
      Max.X := Pnt.X;
    if Pnt.Y > Max.Y then
      Max.Y := Pnt.Y;
    if Pnt.X < Min.X then
      Min.X := Pnt.X;
    if Pnt.Y < Min.Y then
      Min.Y := Pnt.Y;
  end;
  SetBoundingBox(Min.X, Min.Y, Max.X, Max.Y);
end;

procedure TShapeFileWriterPoint.SetBoundingBox(_XMin, _YMin, _XMax, _YMax: Double);
begin
  FBoundingBox.SetXY(_XMin, _YMin, _XMax, _YMax);
  FHasBoundingBoxBeenSet := True;
end;

procedure TShapeFileWriterPoint.WriteShpToStream(_Stream: TStream);
var
  ContentLength: Integer;
  Len: Int64;
  i: Integer;
  RecHeader: TShpRecordHeader;
  ShapeType: LongWord;
begin
  if not FHasBoundingBoxBeenSet then
    CalcBoundingBox;
  // The record header does not count towards the record size, only the content which consists
  // of the shape type (4 bytes) and two coordinates 2x 8 bytes.
  // So record size for a point shape is 20 bytes = 10 words.
  ContentLength := SizeOf(Integer) + SizeOf(TShpPoint);
  // the file size on the other hand includes the record headers
  Len := SizeOf(TShpMainFileHeader) + FCount * ContentLength + FCount * SizeOf(TShpRecordHeader);
  WriteMainHeader(_Stream, Len);
  // ContentLength is constant, so we set it only once, it is given in 16 bit words, thus the "div 2".
  RecHeader.FContentLength := Swap32(ContentLength div 2);
  ShapeType := Ord(FShapeType);
  for i := 0 to FCount - 1 do begin
    RecHeader.FRecordNo := Swap32(FPoints[i].RecordNo);
    _Stream.WriteBuffer(RecHeader, SizeOf(RecHeader));
    _Stream.WriteBuffer(ShapeType, SizeOf(ShapeType));
    _Stream.WriteBuffer(FPoints[i].Point, SizeOf(FPoints[i].Point));
  end;
end;

procedure TShapeFileWriterPoint.WriteShxToStream(_Stream: TStream);
var
  RecordSize: Integer;
  Len: Int64;
  i: Integer;
  IdxRec: TShpIndexRecord;
  ContentLength: LongWord;
  Offset: Integer;
begin
  if not FHasBoundingBoxBeenSet then
    CalcBoundingBox;
  // one record in the .shp file consists of
  // * the record header
  // * the shape type
  // * the point coordinates
  ContentLength := SizeOf(Integer) + SizeOf(TShpPoint);
  RecordSize := SizeOf(TShpRecordHeader) + ContentLength;
  Len := SizeOf(TShpMainFileHeader) + FCount * SizeOf(TShpIndexRecord);
  WriteMainHeader(_Stream, Len);
  // the records in the .shp file start after the main file header
  Offset := SizeOf(TShpMainFileHeader);
  // ContentLength is constant, so we set it only once, it is given in 16 bit words, thus the "div 2".
  IdxRec.ContentLength := Swap32(ContentLength div 2);
  for i := 0 to FCount - 1 do begin
    IdxRec.Offset := Swap32((Offset + i * RecordSize) div 2);
    _Stream.WriteBuffer(IdxRec, SizeOf(IdxRec));
  end;
end;

{ TShapeFileWriter }

constructor TShapeFileWriter.Create(_ShapeType: TShapeTypeEnum; _Version: Integer = 1000);
begin
  inherited Create;
  FShapeType := _ShapeType;
  FVersion := _Version;
end;

procedure TShapeFileWriter.WriteMainHeader(_Stream: TStream; _FileLengthInBytes: Int64);
var
  MainHeader: TShpMainFileHeader;
begin
  if not FHasBoundingBoxBeenSet then
    raise Exception.Create(_('Please set the bounding box first!'));

  MainHeader.FFileCode := Swap32(9994);
  ZeroMemory(@MainHeader.Unused, SizeOf(MainHeader.Unused));
  MainHeader.Version := FVersion;
  MainHeader.FShapeType := Ord(FShapeType);
  MainHeader.FFileLength := Swap32(_FileLengthInBytes div 2);
  _Stream.Position := 0;
  _Stream.WriteBuffer(MainHeader, SizeOf(MainHeader));
end;

procedure TShapeFileWriter.OpenStream(const _Filename: string; var _Stream: TdzFile);
begin
  _Stream := TdzFile.Create(_Filename);
  _Stream.ShareMode := fsNoSharing;
  _Stream.CreateDisposition := fcCreateTruncateIfExists;
  _Stream.AccessMode := faReadWrite;
  _Stream.Open;
end;

procedure TShapeFileWriter.WriteShpAndShx(const _BaseFilename: string);
begin
  WriteShpToFile(_BaseFilename + '.shp');
  WriteShxToFile(_BaseFilename + '.shx');
end;

procedure TShapeFileWriter.WriteShpToFile(const _Filename: string);
var
  st: TdzFile;
begin
  st := nil;
  try
    OpenStream(_Filename, st);
    WriteShpToStream(st);
  finally
    FreeAndNil(st);
  end;
end;

procedure TShapeFileWriter.WriteShxToFile(const _Filename: string);
var
  st: TdzFile;
begin
  st := nil;
  try
    OpenStream(_Filename, st);
    WriteShxToStream(st);
  finally
    FreeAndNil(st);
  end;
end;

{ TShapeFileWriter.TBoundingBox }

procedure TShapeFileWriter.TBoundingBox.SetXY(_XMin, _YMin, _XMax, _YMax: Double);
begin
  XMin := _XMin;
  YMin := _YMin;
  XMax := _XMax;
  YMax := _YMax;
  ZMin := 0;
  ZMax := 0;
  MMin := 0;
  MMax := 0;
end;

procedure TShapeFileWriter.TBoundingBox.SetXYM(_XMin, _YMin, _MMin, _XMax, _YMax, _MMax: Double);
begin
  XMin := _XMin;
  YMin := _YMin;
  XMax := _XMax;
  YMax := _YMax;
  ZMin := 0;
  ZMax := 0;
  MMin := _MMin;
  MMax := _MMax;
end;

procedure TShapeFileWriter.TBoundingBox.SetXYZ(_XMin, _YMin, _ZMin, _XMax, _YMax, _ZMax: Double);
begin
  XMin := _XMin;
  YMin := _YMin;
  XMax := _XMax;
  YMax := _YMax;
  ZMin := _ZMin;
  ZMax := _ZMax;
  MMin := 0;
  MMax := 0;
end;

end.
