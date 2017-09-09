unit AviFileHandler;

interface

uses Windows, Classes, sysutils, vfw, mmsystem, graphics;

type
  TFourCC = packed record
    case Integer of
      0: (AsCardinal: Cardinal);
      1: (AsString: array[0..3] of Char);
  end;

  TAVIBaseStream = class(TObject)
  private
    FName: string;
    FStream: IAVIStream;
    FStreamInfo: TAVIStreamInfoW;
    FAviFile: IAVIFile;
  protected
    FSamples: Cardinal;
  public
    constructor Create(AviFile: IAVIFile; StreamInfo: TAVIStreamInfoW); virtual;
    destructor Destroy; override;

    function WriteSample(Index: Integer; cbSize: Cardinal; lpData: Pointer; Flags: Cardinal): Boolean;
    function AddSample(cbSize: Cardinal; lpData: Pointer; Flags: Cardinal): Boolean;
    function ReadSample(Index: Integer; cbSize: Cardinal; lpData: Pointer): Boolean;
    function DeleteSamples(Index, Count: Cardinal): Integer;

    procedure SetName(Value: string);
    // returns the FOURCC code of the type
    function GetStreamType: Cardinal;

    property Name: string read FName write SetName; // streams name ... just to eat more memory
    property Stream: IAVIStream read FStream; // direct acces to the stream object if needed
    property StreamType: Cardinal read GetStreamType; // the streams type (streamtypeVIDEO/AUDIO, ...)
    property Samples: Cardinal read FSamples; // number of samples in the stream
  end;

  TAVIVideoStream = class(TAVIBaseStream)
  private
    FFormat: TBitmapInfoHeader;
    function Samples: Cardinal;
  public
    constructor Create(AviFile: IAVIFile; AFormat: TBitmapInfoHeader;
      FrameRate: Integer; fccHandler: Cardinal); reintroduce;
    destructor Destroy; override;

    function InsertFrame(Index: Integer; cbSize: Cardinal; lpData: Pointer; KeyFrame: Boolean): Boolean; overload;
    function InsertFrame(Index: Integer; Bmp: TBitmap; KeyFrame: Boolean): Boolean; overload;
    function AddFrame(cbSize: Cardinal; lpData: Pointer; KeyFrame: Boolean): Boolean; overload;
    function AddFrame(Bmp: TBitmap; KeyFrame: Boolean): Boolean; overload;
    function DeleteFrames(Index, Count: Cardinal): Integer;

    property Frames: Cardinal read Samples;
  end;

  TAVIAudioStream = class(TAVIBaseStream)
  private
    FFormat: TWaveFormatEx;
  public
    constructor Create(AviFile: IAVIFile; AFormat: TWaveFormatEx); reintroduce;
    destructor Destroy; override;
  end;

  TAviStreamList = class(TList)
  private
    function Get(Index: Integer): TAVIBaseStream;
    procedure Put(Index: Integer; Stream: TAVIBaseStream);
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  public
    function Insert(Index: Integer; Stream: TAVIBaseStream): Integer;
    function Add(Stream: TAVIBaseStream): Integer;

    property Items[Index: Integer]: TAVIBaseStream read Get write Put; default;
  end;

  TAviFileHandler = class(TObject)
  private
    FAviFile: IAVIFile;
    FStreams: TAviStreamList;
  public
    constructor Create(FileName: string);
    destructor Destroy; override;

    function FirstVideoStream: TAVIVideoStream;
    function FirstAudioStream: TAVIAudioStream;

    function AddVideoStream(BmpFormat: TBitmapInfoHeader; FrameRate: Integer; Codec: Cardinal): Integer; overload;
    function AddVideoStream(BmpFormat: TBitmap; FrameRate: Integer; Codec: Cardinal): Integer; overload;
    function AddVideoStream2(BmpFormat: TBitmap; FrameRate: Integer; Codec: Cardinal): TAVIVideoStream;

    function AddAudioStream(WaveFormat: TWaveFormatEx): Integer; overload;
    function AddAudioStream2(WaveFormat: TWaveFormatEx): TAVIAudioStream; 

    property Streams: TAviStreamList read FStreams;
  end;

  function BIHFromBitmap(Bmp: TBitmap; var BMIH: TBitmapInfoHeader): Boolean;


implementation

function BitmapImageSize(bmp: TBitmap): Cardinal;
var ihs: Cardinal;
begin
     GetDIBSizes(bmp.Handle, ihs, Result);
end;

function BIHFromBitmap(Bmp: TBitmap; var BMIH: TBitmapInfoHeader): Boolean;
var ihs, ims: Cardinal;
    bits: Pointer;
begin
     GetDIBSizes(Bmp.Handle, ihs, ims);
     GetMem(bits, ims);
     try
        GetDIB(Bmp.Handle, 0, BMIH, bits^);
        Result:=true;
     finally
        FreeMem(bits);
     end;
end;



{ TAVIBaseStream }

constructor TAVIBaseStream.Create(AviFile: IAVIFile;
  StreamInfo: TAVIStreamInfoW);
begin
     if AviFile = nil then
        exit;

     FAviFile:=AviFile;
     FStreamInfo:=StreamInfo;
     AviFile.CreateStream(FStream, FStreamInfo);
end;

destructor TAVIBaseStream.Destroy;
begin
     FStream:=nil;
     inherited;
end;

function TAVIBaseStream.WriteSample(Index: Integer; cbSize: Cardinal;
  lpData: Pointer; Flags: Cardinal): Boolean;
var bt, smp: Integer;
begin
     Result:=Succeeded(FStream.Write(Index, 1, lpData, cbSize, Flags, smp, bt));
     Inc(FSamples);
end;

function TAVIBaseStream.AddSample(cbSize: Cardinal; lpData: Pointer;
  Flags: Cardinal): Boolean;
var bt, smp: Integer;
begin
     Result:=Succeeded(FStream.Write(FSamples, 1, lpData, cbSize, Flags, smp, bt));
     Inc(FSamples);
end;

function TAVIBaseStream.DeleteSamples(Index, Count: Cardinal): Integer;
begin
     if Succeeded(FStream.Delete(Index, Count)) then
     begin
        Result:=Count;
        Dec(FSamples, Result);
     end
     else
        Result:=0;
end;

function TAVIBaseStream.ReadSample(Index: Integer; cbSize: Cardinal;
  lpData: Pointer): Boolean;
var bt, smp: Integer;
begin
     Result:=Succeeded(FStream.Read(Index, 1, lpData, cbSize, bt, smp));
end;

procedure TAVIBaseStream.SetName(Value: string);
begin
     FName:=Value;
end;


function TAVIBaseStream.GetStreamType: Cardinal;
begin
     Result:=FStreamInfo.fccType;
end;


{ TAVIVideoStream }

constructor TAVIVideoStream.Create(AviFile: IAVIFile;
  AFormat: TBitmapInfoHeader; FrameRate: Integer; fccHandler: Cardinal);
begin
     FAviFile:=AviFile;
     FFormat:=AFormat;
     FillChar(FStreamInfo, SizeOf(FStreamInfo), 0);
     FStreamInfo.fccType:=streamtypeVIDEO;
     FStreamInfo.fccHandler:=fccHandler;
     FStreamInfo.dwRate:=FrameRate;
     if Succeeded(AviFile.CreateStream(FStream, FStreamInfo)) then
        FStream.SetFormat(0, @FFormat, SizeOf(FFormat));
end;

destructor TAVIVideoStream.Destroy;
begin

     inherited;
end;

function TAVIVideoStream.InsertFrame(Index: Integer; cbSize: Cardinal;
  lpData: Pointer; KeyFrame: Boolean): Boolean;
const flagKeyFrame: array[Boolean] of Integer = (0, AVIIF_KEYFRAME);
begin
     if Index = -1 then
        Index:=FSamples;
     Result:=WriteSample(Index, cbSize, lpData, flagKeyFrame[KeyFrame]);
end;

function TAVIVideoStream.InsertFrame(Index: Integer; Bmp: TBitmap; KeyFrame: Boolean): Boolean;
var BmpSize: Cardinal;
begin
     Result:=Assigned(Bmp);
     if not Result then exit;
     BmpSize:=BitmapImageSize(Bmp);
     if Index = -1 then
        Index:=FSamples;
     Result:=InsertFrame(Index, BmpSize, Bmp.ScanLine[Bmp.Height-1], KeyFrame);
end;

function TAVIVideoStream.AddFrame(Bmp: TBitmap; KeyFrame: Boolean): Boolean;
begin
     Result:=InsertFrame(FSamples, Bmp, KeyFrame);
end;

function TAVIVideoStream.AddFrame(cbSize: Cardinal; lpData: Pointer;
  KeyFrame: Boolean): Boolean;
begin
     Result:=InsertFrame(FSamples, cbSize, lpData, KeyFrame);
end;

function TAVIVideoStream.DeleteFrames(Index, Count: Cardinal): Integer;
begin
     Result:=DeleteSamples(Index, Count);
end;

function TAVIVideoStream.Samples: Cardinal;
begin
     Result:=FSamples;
end;


{ TAVIAudioStream }

constructor TAVIAudioStream.Create(AviFile: IAVIFile;
  AFormat: TWaveFormatEx);
begin
     FAviFile:=AviFile;
     FFormat:=AFormat;
end;

destructor TAVIAudioStream.Destroy;
begin

     inherited;
end;


{ TAviStreamList }

function TAviStreamList.Add(Stream: TAVIBaseStream): Integer;
begin
     inherited Add(Stream);
     Result:=Count-1;
end;

function TAviStreamList.Insert(Index: Integer; Stream: TAVIBaseStream): Integer;
begin
     inherited Insert(Index, Stream);
     Result:=Index;
end;

function TAviStreamList.Get(Index: Integer): TAVIBaseStream;
begin
     Result:=TAVIBaseStream(inherited Get(Index));
end;

procedure TAviStreamList.Put(Index: Integer; Stream: TAVIBaseStream);
begin
     inherited Put(Index, Stream);
end;


procedure TAviStreamList.Notify(Ptr: Pointer; Action: TListNotification);
begin
     if Action = lnDeleted then
        TAVIBaseStream(Ptr).Free;

     inherited Notify(Ptr, Action);
end;


{ TAviFileHandler }

function TAviFileHandler.AddAudioStream(
  WaveFormat: TWaveFormatEx): Integer;
begin
     Result:=Streams.Add(TAVIAudioStream.Create(FAviFile, WaveFormat));
end;

function TAviFileHandler.AddAudioStream2(
  WaveFormat: TWaveFormatEx): TAVIAudioStream;
begin
     Result:=TAVIAudioStream(Streams.Items[AddAudioStream(WaveFormat)]);
end;

function TAviFileHandler.AddVideoStream(BmpFormat: TBitmapInfoHeader;
  FrameRate: Integer; Codec: Cardinal): Integer;
begin
     Result:=Streams.Add(TAVIVideoStream.Create(FAviFile, BmpFormat, FrameRate, Codec));
end;

function TAviFileHandler.AddVideoStream(BmpFormat: TBitmap;
  FrameRate: Integer; Codec: Cardinal): Integer;
var BMIH: TBitmapInfoHeader;
begin
     if BIHFromBitmap(BmpFormat, BMIH) then
        Result:=AddVideoStream(BMIH, FrameRate, Codec)
     else
        Result:=-1; 
end;

function TAviFileHandler.AddVideoStream2(BmpFormat: TBitmap;
  FrameRate: Integer; Codec: Cardinal): TAVIVideoStream;
begin
     Result:=TAVIVideoStream(Streams.Items[AddVideoStream(BmpFormat, FrameRate, Codec)]);
end;

constructor TAviFileHandler.Create(FileName: string);
begin
     AVIFileInit;
     if AVIFileOpen(FAVIFile, PChar(FileName), OF_CREATE or OF_WRITE, nil) <> AVIERR_OK then
        raise Exception.CreateFmt('Can''t open file %s for writing', [FileName]);
     FStreams:=TAviStreamList.Create;
end;

destructor TAviFileHandler.Destroy;
begin
     AVIFileExit;
     FreeAndNil(FStreams);
     FAVIFile:=nil;
     inherited;
end;

function TAviFileHandler.FirstAudioStream: TAVIAudioStream;
var I: Integer;
begin
     Result:=nil;
     for I:=0 to Streams.Count-1 do
         if Streams.Items[I].StreamType = streamtypeAUDIO then
         begin
           Result:=TAVIAudioStream(Streams.Items[I]);
           break;
         end;
end;

function TAviFileHandler.FirstVideoStream: TAVIVideoStream;
var I: Integer;
begin
     Result:=nil;
     for I:=0 to Streams.Count-1 do
         if Streams.Items[I].StreamType = streamtypeVIDEO then
         begin
           Result:=TAVIVideoStream(Streams.Items[I]);
           break;
         end;
end;

end.
