unit pgRaster;
{
  Support for all kinds of raster graphics (loading/saving from file/stream)

  Creation Date:
  22May2005

  Modifications:

  Author: Nils Haeck
  Copyright (c) 2005 by SimDesign B.V.

}

interface

uses
  Classes, Contnrs, pgBitmap, NativeXml, sdDebug;

type

  TpgRasterFormatType = (
    crfUnknown,
    crfBitmap,
    crfJPG,
    crfPNG,
    crfGIF,
    crfTIF,
    crfJP2,
    crfTGA
  );

  TpgRasterFormat = class(TsdDebugPersistent)
  private
    FSaveQuality: integer;
    FAlphaThreshold: byte;
  public
    constructor Create; virtual;
    procedure LoadFromFile(const AFileName: string; AMap: TpgColorMap); virtual;
    procedure LoadFromStream(S: TStream; AMap: TpgColorMap); virtual; abstract;
    procedure SaveToFile(const AFileName: string; AMap: TpgColorMap); virtual;
    procedure SaveToStream(S: TStream; AMap: TpgColorMap); virtual; abstract;
    // For use with lossy formats: sets the quality when saving
    property SaveQuality: integer read FSaveQuality write FSaveQuality;
    // For use with formats that have non-AA transparency (only full or none):
    // All values lower than AlphaTreshold are considered fully transparent, all
    // values equal or above AlphaTreshold are considered fully opaque.
    property AlphaThreshold: byte read FAlphaThreshold write FAlphaThreshold;
  end;

  TpgRasterClass = class of TpgRasterFormat;

procedure LoadImageFromFile(const AFileName: string; AMap: TpgColorMap; AFormat: TpgRasterFormatType = crfUnknown);

procedure LoadImageFromStream(S: TStream; AMap: TpgColorMap; AClass: TpgRasterClass); overload;

procedure LoadImageFromStream(S: TStream; AMap: TpgColorMap; const AMimeType: string); overload;

procedure SaveImageToFile(const AFileName: string; AMap: TpgColorMap; const AMimeType: string; AQuality: integer = 90);

procedure SaveImageToStream(S: TStream; AMap: TpgColorMap; const AMimeType: string;
  AQuality: integer = 90);

procedure RegisterRasterFormat(AClass: TpgRasterClass; AFormat: TpgRasterFormatType;
  const MimeTypeList: string);

function FindRasterClassByMimeType(const AMimeType: string): TpgRasterClass;

resourcestring

  srfUnknownFormatNotSupportedForStreams = 'Unknown Format Not Supported For Streams';
  srfUnsupportedRasterFormat             = 'Unsupported Raster Format';

implementation

uses
  // By default, only pgRasterBmp (windows bitmaps) are supported. Add other
  // pgRasterXXX files to the uses clause of the application to include support
  // for other raster formats.
  pgRasterBmp,
  pgUriReference,
  SysUtils;

type

  TpgRasterClassHolder = class
  private
    FMimeTypeList: string;
    FRasterClass: TpgRasterClass;
    FRasterFormat: TpgRasterFormatType;
  public
    property RasterClass: TpgRasterClass read FRasterClass write FRasterClass;
    property RasterFormat: TpgRasterFormatType read FRasterFormat write FRasterFormat;
    property MimeTypeList: string read FMimeTypeList write FMimeTypeList;
    function SupportsMimeType(AMimeType: string): boolean;
  end;

var
  glRasterClassList: TObjectList = nil;

function FindRasterClass(AFormat: TpgRasterFormatType): TpgRasterClass;
var
  i: integer;
begin
  // Find suitable class for loading
  Result := nil;
  if assigned(glRasterClassList) then
    for i := 0 to glRasterClassList.Count - 1 do
      if TpgRasterClassHolder(glRasterClassList[i]).RasterFormat = AFormat then
      begin
        Result := TpgRasterClassHolder(glRasterClassList[i]).RasterClass;
        exit;
      end;
end;

function FindRasterClassByMimeType(const AMimeType: string): TpgRasterClass;
var
  i: integer;
begin
  // Find suitable class for loading
  Result := nil;
  if assigned(glRasterClassList) then
    for i := 0 to glRasterClassList.Count - 1 do
      if TpgRasterClassHolder(glRasterClassList[i]).SupportsMimeType(AMimeType) then
      begin
        Result := TpgRasterClassHolder(glRasterClassList[i]).RasterClass;
        exit;
      end;
end;

procedure LoadImageFromFile(const AFileName: string; AMap: TpgColorMap;
  AFormat: TpgRasterFormatType = crfUnknown);
var
  i: integer;
  AClass: TpgRasterClass;
  AInst: TpgRasterFormat;
  Ext, MimeType: string;
begin
  if AFormat = crfUnknown then begin
    // Use extension to find suitable class
    AClass := nil;
    Ext := ExtractFileExt(AFileName);
    MimeType := TpgUriReference.ExtensionToMimeType(Ext);
    if assigned(glRasterClassList) then
      for i := 0 to glRasterClassList.Count - 1 do
        if TpgRasterClassHolder(glRasterClassList[i]).SupportsMimeType(MimeType) then
        begin
          AClass := TpgRasterClassHolder(glRasterClassList[i]).RasterClass;
          break;
        end;
  end else
    // Find suitable class for loading
    AClass := FindRasterClass(AFormat);

  // Non-existent?
  if AClass = nil then
  begin
    raise Exception.Create(srfUnsupportedRasterFormat);
  end;

  // Now try to load
  AInst := AClass.Create;
  try
    AInst.LoadFromFile(AFileName, AMap);
  finally
    AInst.Free;
  end;
end;

procedure LoadImageFromStream(S: TStream; AMap: TpgColorMap; AClass: TpgRasterClass);
var
  AInst: TpgRasterFormat;
begin
  if not assigned(AClass) then
    raise Exception.Create(srfUnknownFormatNotSupportedForStreams);

  // Create class instance and load
  AInst := AClass.Create;
  try
    AInst.LoadFromStream(S, AMap);
  finally
    AInst.Free;
  end;
end;

procedure LoadImageFromStream(S: TStream; AMap: TpgColorMap; const AMimeType: string);
var
  AClass: TpgRasterClass;
  AInst: TpgRasterFormat;
begin
  if length(AMimeType) = 0 then
    raise Exception.Create(srfUnknownFormatNotSupportedForStreams);

  // Find suitable class for loading
  AClass := FindRasterClassByMimeType(AMimeType);
  if AClass = nil then
    raise Exception.Create(srfUnsupportedRasterFormat);

  // Create class instance and load
  AInst := AClass.Create;
  try
    AInst.LoadFromStream(S, AMap);
  finally
    AInst.Free;
  end;
end;

procedure SaveImageToFile(const AFileName: string; AMap: TpgColorMap;
  const AMimeType: string; AQuality: integer = 90);
var
  AClass: TpgRasterClass;
  AInst: TpgRasterFormat;
begin
  if length(AMimeType) = 0 then
    raise Exception.Create(srfUnknownFormatNotSupportedForStreams);

  // Find suitable class for loading
  AClass := FindRasterClassByMimeType(AMimeType);
  if AClass = nil then
    raise Exception.Create(srfUnsupportedRasterFormat);

  // Create class instance and save
  AInst := AClass.Create;
  try
    AInst.SaveQuality := AQuality;
    AInst.SaveToFile(AFileName, AMap);
  finally
    AInst.Free;
  end;
end;

procedure SaveImageToStream(S: TStream; AMap: TpgColorMap; const AMimeType: string;
  AQuality: integer = 90);
var
  AClass: TpgRasterClass;
  AInst: TpgRasterFormat;
begin
  if length(AMimeType) = 0 then
    raise Exception.Create(srfUnknownFormatNotSupportedForStreams);

  // Find suitable class for loading
  AClass := FindRasterClassByMimeType(AMimeType);
  if AClass = nil then
    raise Exception.Create(srfUnsupportedRasterFormat);

  // Create class instance and save
  AInst := AClass.Create;
  try
    AInst.SaveQuality := AQuality;
    AInst.SaveToStream(S, AMap);
  finally
    AInst.Free;
  end;
end;

{ TpgRasterClassHolder }

function TpgRasterClassHolder.SupportsMimeType(AMimeType: string): boolean;
begin
  Result := False;
  if length(AMimeType) = 0 then
    exit;
  if Pos(AMimeType, FMimeTypeList) > 0 then
    Result := True;
end;

procedure RegisterRasterFormat(AClass: TpgRasterClass; AFormat: TpgRasterFormatType;
  const MimeTypeList: string);
var
  AHolder: TpgRasterClassHolder;
begin
  if not assigned(glRasterClassList) then
    glRasterClassList := TObjectList.Create;
  AHolder := TpgRasterClassHolder.Create;
  AHolder.RasterClass := AClass;
  AHolder.RasterFormat := AFormat;
  AHolder.MimeTypeList := MimeTypeList;
  glRasterClassList.Add(AHolder);
end;

{ TpgRasterFormat }

constructor TpgRasterFormat.Create;
begin
  inherited Create;
  FSaveQuality := 90;
  FAlphaThreshold := 20;
end;

procedure TpgRasterFormat.LoadFromFile(const AFileName: string; AMap: TpgColorMap);
var
  S: TStream;
begin
  if not FileExists(AFileName) then
  begin
    DoDebugOut(Self, wsFail, Format('"%s" does not exist', [AFileName]));
    exit;
  end;
  S := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
  try
    LoadFromStream(S, AMap);
  finally
    S.Free;
  end;
end;

procedure TpgRasterFormat.SaveToFile(const AFileName: string; AMap: TpgColorMap);
var
  S: TStream;
begin
  S := TFileStream.Create(AFileName, fmCreate);
  try
    SaveToStream(S, AMap);
  finally
    S.Free;
  end;
end;

initialization

finalization

  FreeAndNil(glRasterClassList);

end.
