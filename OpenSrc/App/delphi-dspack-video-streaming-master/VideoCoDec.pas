{
    Compression scheme taken from VirtualDub
    Converted for Delphi by Lee_Nover - Lee_Nover@delphi-si.com 27.5.2002
}

unit VideoCoDec;

interface

uses windows, sysutils, Classes, vfw, Graphics, AviFileHandler;

const
  VFW_EXT_RESULT = 1;

resourcestring
  sErrorICGetInfo = 'Unable to retrieve video compressor information';
  sErrorICCompressBegin = 'Cannot start video compression'#13#10'Error code: %d';
  sErrorICCompressBeginBF = 'Cannot start video compression'#13#10'Unsupported format (Error code: %d)';

type
  TFourCC = packed record
    case Integer of
      0: (AsCardinal: Cardinal);
      1: (AsString: array[0..3] of Char);
  end;

  TVideoCoDec = class(TObject)
  private
    hICDec: Cardinal;
    cv: TCompVars;
    FFlags: Cardinal;
    FPrevBuffer: PChar;
    FBuffCompOut: PChar;
    FBuffDeCompOut: PChar;
    FCompressorStarted: Boolean;
    FDecompressorStarted: Boolean;

    FFrameNum: Integer;
    FKeyRateCounter: Integer;
    FForceKeyFrameRate: Boolean;
    FMaxKeyFrameInterval: Cardinal;
    FMaxFrameSize: Cardinal;
    FMaxPackedSize: Cardinal;
    FSlopSpace: Cardinal;

    FCodecName: string;
    FCodecDescription: string;

    pConfigData: Pointer;
    cbConfigData: Cardinal;
    FLastError: Integer;

    function InternalInit(const HasComp: Boolean = false): Boolean;
    procedure SetCompVars(CompVars: TCompVars);
    procedure ClearCompVars(var CompVars: TCompVars);
    procedure CloseDrivers;
  public
    constructor Create;
    destructor Destroy; override;

    function Init(CompVars: TCompVars): Boolean; overload;
    function Init(InputFormat, OutputFormat: TBitmapInfo;
      const Quality, KeyRate: Integer): Boolean; overload;
    function Init(InputFormat, OutputFormat: TBitmapInfoHeader;
      const Quality, KeyRate: Integer): Boolean; overload;

    function StartCompressor: Boolean;
    function StartDecompressor: Boolean;
    // start calls the 2 functions above
    procedure Start;

    procedure CloseDecompressor;
    procedure CloseCompressor;
    // finish calls the 2 procedures above
    procedure Finish;
    function ChooseCodec: Boolean;
    procedure ConfigureCompressor;

    procedure SetDataRate(const lDataRate, lUsPerFrame, lFrameCount: Integer);
    procedure SetQuality(const Value: Integer);
    function GetQuality: Integer;

    function EnumCodecs(List: TStrings): Integer;

    procedure DropFrame;
    function PackFrame(ImageData: Pointer; var IsKeyFrame: Boolean; var Size: Cardinal): Pointer;
    function UnpackFrame(ImageData: Pointer; KeyFrame: Boolean; var Size: Cardinal): Pointer;
    function CompressImage(ImageData: Pointer; Quality: Integer; var Size: Cardinal): HBITMAP;
    function DecompressImage(ImageData: Pointer): HBITMAP;
    function PackBitmap(Bitmap: TBitmap; var IsKeyFrame: Boolean; var Size: Cardinal): Pointer;
    function UnpackBitmap(ImageData: Pointer; KeyFrame: Boolean; Bitmap: TBitmap): Boolean;

    function GetBitmapInfoIn: TBitmapInfo;
    function GetBitmapInfoOut: TBitmapInfo;

    property CompressorStarted: Boolean read FCompressorStarted;
    property DecompressorStarted: Boolean read FDecompressorStarted;
    property BIInput: TBitmapInfo read GetBitmapInfoIn;
    property BIOutput: TBitmapInfo read GetBitmapInfoOut;
    property Quality: Integer read GetQuality write SetQuality;
    property ForceKeyFrameRate: Boolean read FForceKeyFrameRate write FForceKeyFrameRate;
    property MaxKeyFrameRate: Cardinal read FMaxKeyFrameInterval write FMaxKeyFrameInterval;
    property CodecName: string read FCodecName;
    property CodecDescription: string read FCodecDescription;
    property LastError: Integer read FLastError;
  end;


function IIF(const Condition: Boolean; const ifTrue, ifFalse: Integer): Integer;overload;
function IIF(const Condition: Boolean; const ifTrue, ifFalse: Pointer): Pointer;overload;
function HasFlag(const Flags, CheckFlag: Integer): Boolean;overload;
function HasFlag(const Flags, CheckFlag: Cardinal): Boolean;overload;
function TranslateICError(ErrCode: Integer): string;

implementation

resourcestring
  sVideoCoDecAbort = 'Abort';
  sVideoCoDecBadBitDepth = 'Bad bit-depth';
  sVideoCoDecBadFlags = 'Bad flags';
  sVideoCoDecBadFormat = 'Bad format';
  sVideoCoDecBadHandle = 'Bad handle';
  sVideoCoDecBadImageSize = 'Bad image size';
  sVideoCoDecBadParameter = 'Bad parameter';
  sVideoCoDecBadSize = 'Bad size';
  sVideoCoDecCanTUpdate = 'Can''t update';
  sVideoCoDecDonTDraw = 'Don''t draw';
  sVideoCoDecError = 'Error';
  sVideoCoDecGoToKeyFrame = 'Go to KeyFrame';
  sVideoCoDecInternalError = 'Internal error';
  sVideoCoDecNewPalette = 'New palette';
  sVideoCoDecNoError = 'No error';
  sVideoCoDecNotEnoughMemory = 'Not enough memory';
  sVideoCoDecStopDrawing = 'Stop drawing';
  sVideoCoDecUnknownError = 'Unknown error';
  sVideoCoDecUnsupportedFunctionFormat = 'Unsupported function/format';

function IIF(const Condition: Boolean; const ifTrue, ifFalse: Integer): Integer;overload;
begin
   if Condition then
      Result:=ifTrue
   else
      Result:=ifFalse;
end;

function IIF(const Condition: Boolean; const ifTrue, ifFalse: Pointer): Pointer;overload;
begin
   if Condition then
      Result:=ifTrue
   else
      Result:=ifFalse;
end;

function HasFlag(const Flags, CheckFlag: Integer): Boolean;overload;
begin
     Result:=(Flags and CheckFlag) = CheckFlag;
end;

function HasFlag(const Flags, CheckFlag: Cardinal): Boolean;overload;
begin
     Result:=(Flags and CheckFlag) = CheckFlag;
end;

function TranslateICError(ErrCode: Integer): string;
begin
     case ErrCode of
       ICERR_OK:            Result:=sVideoCoDecNoError;
       ICERR_DONTDRAW:      Result:=sVideoCoDecDonTDraw;
       ICERR_NEWPALETTE:    Result:=sVideoCoDecNewPalette;
       ICERR_GOTOKEYFRAME:  Result:=sVideoCoDecGoToKeyFrame;
       ICERR_STOPDRAWING:   Result:=sVideoCoDecStopDrawing;

       ICERR_UNSUPPORTED:   Result:=sVideoCoDecUnsupportedFunctionFormat;
       ICERR_BADFORMAT:     Result:=sVideoCoDecBadFormat;
       ICERR_MEMORY:        Result:=sVideoCoDecNotEnoughMemory;
       ICERR_INTERNAL:      Result:=sVideoCoDecInternalError;
       ICERR_BADFLAGS:      Result:=sVideoCoDecBadFlags;
       ICERR_BADPARAM:      Result:=sVideoCoDecBadParameter;
       ICERR_BADSIZE:       Result:=sVideoCoDecBadSize;
       ICERR_BADHANDLE:     Result:=sVideoCoDecBadHandle;
       ICERR_CANTUPDATE:    Result:=sVideoCoDecCanTUpdate;
       ICERR_ABORT:         Result:=sVideoCoDecAbort;
       ICERR_ERROR:         Result:=sVideoCoDecError;
       ICERR_BADBITDEPTH:   Result:=sVideoCoDecBadBitDepth;
       ICERR_BADIMAGESIZE:  Result:=sVideoCoDecBadImageSize;
       else                 Result:=sVideoCoDecUnknownError;
     end;
end;

{ TVideoCoDec }

constructor TVideoCoDec.Create;
begin
     hICDec:=0;
     FillChar(cv, SizeOf(cv), 0);
     cv.cbSize:=SizeOf(cv);
     cv.lpbiIn:=AllocMem(SizeOf(TBitmapInfo));
     cv.lpbiOut:=AllocMem(SizeOf(TBitmapInfo));
     FFlags:=0;
     FPrevBuffer:=nil;
     FBuffCompOut:=nil;
     FBuffDeCompOut:=nil;
     FCompressorStarted:=false;
     FDecompressorStarted:=false;
     FForceKeyFrameRate:=false;
     pConfigData:=nil;
     cbConfigData:=0;
     FLastError:=ICERR_OK;
end;

destructor TVideoCoDec.Destroy;
begin
     ReallocMem(FPrevBuffer, 0);
     ReallocMem(FBuffCompOut, 0);
     ReallocMem(FBuffDeCompOut, 0);
     ReallocMem(pConfigData, 0);
     // these could be freed by ICCompressFree
     // but I don't know what that function REALLY does !
     CloseDrivers;
     ClearCompVars(cv);
     inherited;
end;

procedure TVideoCoDec.ClearCompVars(var CompVars: TCompVars);
begin
     ReallocMem(CompVars.lpbiIn, 0);
     ReallocMem(CompVars.lpbiOut, 0);
     ReallocMem(CompVars.lpBitsOut, 0);
     ReallocMem(CompVars.lpBitsPrev, 0);
     ReallocMem(CompVars.lpState, 0);
     FillChar(CompVars, SizeOf(TCompVars), 0);
end;

procedure TVideoCoDec.SetCompVars(CompVars: TCompVars);
begin
     cv.cbState:=CompVars.cbState;
     cv.dwFlags:=CompVars.dwFlags;
     cv.fccHandler:=CompVars.fccHandler;
     cv.fccType:=CompVars.fccType;

     if CompVars.hic > 0 then
     begin
       if cv.hic > 0 then
          ICClose(cv.hic);

       cv.hic:=CompVars.hic;
     end;
     
     cv.lDataRate:=CompVars.lDataRate;
     cv.lFrame:=CompVars.lFrame;
     cv.lKey:=CompVars.lKey;
     cv.lKeyCount:=CompVars.lKeyCount;
     cv.lQ:=CompVars.lQ;
     CopyMemory(cv.lpbiIn, CompVars.lpbiIn, SizeOf(TBitmapInfo));
     CopyMemory(cv.lpbiOut, CompVars.lpbiOut, SizeOf(TBitmapInfo));
end;

procedure TVideoCoDec.CloseCompressor;
begin
     if cv.hic > 0 then
        ICClose(cv.hic);
     cv.hic:=0;
end;

procedure TVideoCoDec.CloseDecompressor;
begin
     if hICDec > 0 then
        ICClose(hICDec);
     hICDec:=0;
end;

procedure TVideoCoDec.CloseDrivers;
begin
     CloseCompressor;
     CloseDecompressor;
end;

function TVideoCoDec.InternalInit(const HasComp: Boolean = false): Boolean;
var info: TICINFO;
    lRealMaxPackedSize: Cardinal;
begin
     FCodecName:='';
     FCodecDescription:='';

     CloseDecompressor;
     if not HasComp then
     begin
       CloseCompressor;
       cv.hic:=ICOpen(cv.fccType, cv.fccHandler, ICMODE_COMPRESS);
     end;
     hICDec:=ICOpen(cv.fccType, cv.fccHandler, ICMODE_DECOMPRESS);

     FKeyRateCounter:=1;

     // Retrieve compressor information.
     FillChar(info, SizeOf(info), 0);
     FLastError:=ICGetInfo(cv.hic, @info, SizeOf(info));
     Result:=FLastError <> 0;
     if not Result then
     begin
//       SetLastError();
       exit;
     end
     else
       FLastError:=0;

     FCodecName:=info.szName;
     FCodecDescription:=info.szDescription;

     FFlags:=info.dwFlags;
     if HasFlag(info.dwFlags, VIDCF_TEMPORAL) then
        if not HasFlag(info.dwFlags, VIDCF_FASTTEMPORALC) then
           // Allocate backbuffer
           ReallocMem(FPrevBuffer, cv.lpbiIn^.bmiHeader.biSizeImage);

     if not HasFlag(info.dwFlags, VIDCF_QUALITY) then
        cv.lQ:=0;

     // Allocate destination buffer

     FMaxPackedSize:=ICCompressGetSize(cv.hic, @(cv.lpbiIn^.bmiHeader), @(cv.lpbiOut^.bmiHeader));

     // Work around a bug in Huffyuv.  Ben tried to save some memory
     // and specified a "near-worst-case" bound in the codec instead
     // of the actual worst case bound.  Unfortunately, it's actually
     // not that hard to exceed the codec's estimate with noisy
     // captures -- the most common way is accidentally capturing
     // static from a non-existent channel.
     //
     // According to the 2.1.1 comments, Huffyuv uses worst-case
     // values of 24-bpp for YUY2/UYVY and 40-bpp for RGB, while the
     // actual worst case values are 43 and 51.  We'll compute the
     // 43/51 value, and use the higher of the two.

     if info.fccHandler = MKFOURCC('U', 'Y', 'F', 'H') then
     begin
       lRealMaxPackedSize:=cv.lpbiIn^.bmiHeader.biWidth * cv.lpbiIn^.bmiHeader.biHeight;

       if (cv.lpbiIn^.bmiHeader.biCompression = BI_RGB) then
          lRealMaxPackedSize:=(lRealMaxPackedSize * 51) shr 3
       else
          lRealMaxPackedSize:=(lRealMaxPackedSize * 43) shr 3;

       if lRealMaxPackedSize > FMaxPackedSize then
          FMaxPackedSize:=lRealMaxPackedSize;
     end;

     ReallocMem(FBuffCompOut, FMaxPackedSize);

     // Save configuration state.
     //
     // Ordinarily, we wouldn't do this, but there seems to be a bug in
     // the Microsoft MPEG-4 compressor that causes it to reset its
     // configuration data after a compression session.  This occurs
     // in all versions from V1 through V3.
     //
     // Stupid fscking Matrox driver returns -1!!!

     cbConfigData:=ICGetStateSize(cv.hic);

     if cbConfigData > 0 then
     begin
       ReallocMem(pConfigData, cbConfigData);

       cbConfigData:=ICGetState(cv.hic, pConfigData, cbConfigData);
       // As odd as this may seem, if this isn't done, then the Indeo5
       // compressor won't allow data rate control until the next
       // compression operation!

       if cbConfigData <> 0 then
          ICSetState(cv.hic, pConfigData, cbConfigData);
     end;

     FMaxFrameSize:=0;
     FSlopSpace:=0;
end;

function TVideoCoDec.Init(CompVars: TCompVars): Boolean;
begin
     Finish;
     SetCompVars(CompVars);
     Result:=InternalInit(CompVars.hic > 0);
end;

function TVideoCoDec.Init(InputFormat, OutputFormat: TBitmapInfo;
  const Quality, KeyRate: Integer): Boolean;
begin
     cv.lQ:=Quality;
     cv.lKey:=KeyRate;
     cv.lpbiIn^:=InputFormat;
     cv.lpbiOut^:=OutputFormat;
     cv.fccType:=MKFOURCC('V', 'I', 'D', 'C');
     cv.fccHandler:=OutputFormat.bmiHeader.biCompression;
     Result:=InternalInit;
end;

function TVideoCoDec.Init(InputFormat, OutputFormat: TBitmapInfoHeader;
  const Quality, KeyRate: Integer): Boolean;
begin
     cv.lQ:=Quality;
     cv.lKey:=KeyRate;
     cv.lpbiIn^.bmiHeader:=InputFormat;
     cv.lpbiOut^.bmiHeader:=OutputFormat;
     cv.fccType:=MKFOURCC('V', 'I', 'D', 'C');
     cv.fccHandler:=OutputFormat.biCompression;
     Result:=InternalInit;
end;

procedure TVideoCoDec.SetDataRate(const lDataRate, lUsPerFrame,
  lFrameCount: Integer);
var ici: TICINFO;
    icf: TICCOMPRESSFRAMES;
begin
     if cv.hic = 0 then exit;
     
     if (lDataRate > 0) and HasFlag(FFlags, VIDCF_CRUNCH) then
        FMaxFrameSize:=MulDiv(lDataRate, lUsPerFrame, 1000000)
     else
        FMaxFrameSize:=0;

     // Indeo 5 needs this message for data rate clamping.

     // The Morgan codec requires the message otherwise it assumes 100%
     // quality :(

     // The original version (2700) MPEG-4 V1 requires this message, period.
     // V3 (DivX) gives crap if we don't send it.  So special case it.

     ICGetInfo(cv.hic, @ici, SizeOf(ici));

     FillChar(icf, SizeOf(icf), 0);

     icf.dwFlags:=Cardinal(@icf.lKeyRate);
     icf.lStartFrame:=0;
     icf.lFrameCount:=lFrameCount;
     icf.lQuality:=cv.lQ;
     icf.lDataRate:=lDataRate; // = dwRate div dwScale
     icf.lKeyRate:=cv.lKey;
     icf.dwRate:=1000000;
     icf.dwScale:=lUsPerFrame;

     FLastError:=ICSendMessage(cv.hic, ICM_COMPRESS_FRAMES_INFO, WPARAM(@icf), SizeOf(TICCOMPRESSFRAMES));
end;

procedure TVideoCoDec.Start;
begin
     StartCompressor;
     StartDecompressor;
end;

function TVideoCoDec.StartCompressor: Boolean;
begin
     FFrameNum:=0;
     FCompressorStarted:=false;

     // Start compression process
     FLastError:=ICCompressBegin(cv.hic, @(cv.lpbiIn^.bmiHeader), @(cv.lpbiOut^.bmiHeader));
     Result:=FLastError = ICERR_OK;
     if not Result then exit;

     // Start decompression process if necessary
     if Assigned(FPrevBuffer) then
     begin
       FLastError:=ICDecompressBegin(cv.hic, @(cv.lpbiOut^.bmiHeader), @(cv.lpbiIn^.bmiHeader));
       Result:=FLastError = ICERR_OK;
       if not Result then
       begin
         ICCompressEnd(cv.hic);
         exit;
       end;
     end;

     FCompressorStarted:=true;
end;

function TVideoCoDec.StartDecompressor: Boolean;
begin
     // Start decompression process
     FLastError:=ICDecompressBegin(hICDec, @(cv.lpbiOut^.bmiHeader), @(cv.lpbiIn^.bmiHeader));
     FDecompressorStarted:=FLastError = ICERR_OK;
     Result:=FDecompressorStarted;
end;

procedure TVideoCoDec.Finish;
begin
     if FCompressorStarted then
     begin
       if Assigned(FPrevBuffer) then
          ICDecompressEnd(cv.hic);

       ICCompressEnd(cv.hic);

       FCompressorStarted:=false;
       // Reset MPEG-4 compressor
       if (cbConfigData > 0) and Assigned(pConfigData) then
     	  ICSetState(cv.hic, pConfigData, cbConfigData);
     end;

     if FDecompressorStarted then
     begin
       FDecompressorStarted:=false;
       ICDecompressEnd(hICDec);
     end;
end;

function TVideoCoDec.ChooseCodec: Boolean;
var pc: TCompVars;
begin
     Result:=not FCompressorStarted;
     if not Result then exit;

     pc:=cv;
     pc.dwFlags:=ICMF_COMPVARS_VALID;
     pc.lpbiIn:=nil;
     pc.hic:=0;
     pc.lpbiOut:=AllocMem(SizeOf(TBitmapInfo));

     Result:=ICCompressorChoose(0, ICMF_CHOOSE_DATARATE or ICMF_CHOOSE_KEYFRAME,
       nil {maybe check input format ? @(cv.lpbiIn^.bmiHeader)}, nil, @pc, nil);

     // copy the original input format as it will be copied back in SetCompVars :)
     pc.lpbiIn:=AllocMem(SizeOf(TBitmapInfo));
     CopyMemory(pc.lpbiIn, cv.lpbiIn, SizeOf(TBitmapInfo));

     if Result then
     begin
       SetCompVars(pc);
       InternalInit(pc.hic > 0);
     end;
     ClearCompVars(pc);
end;

procedure TVideoCoDec.ConfigureCompressor;
begin
     if cv.hic > 0 then
        FLastError:=ICConfigure(cv.hic, 0);
end;

function TVideoCoDec.CompressImage(ImageData: Pointer; Quality: Integer;
  var Size: Cardinal): HBITMAP;
begin
     Result:=ICImageCompress(cv.hic, 0, @(cv.lpbiIn^.bmiHeader), ImageData,
       @(cv.lpbiOut^.bmiHeader), Quality, @Size);
end;

function TVideoCoDec.DecompressImage(ImageData: Pointer): HBITMAP;
begin
     Result:=ICImageDecompress(hICDec, 0, @(cv.lpbiOut^.bmiHeader), ImageData,
       @(cv.lpbiIn^.bmiHeader));
end;

procedure TVideoCoDec.DropFrame;
begin
     if (cv.lKey > 0) and (FKeyRateCounter > 1) then
     	Dec(FKeyRateCounter);
     Inc(FFrameNum);
end;

function TVideoCoDec.PackFrame(ImageData: Pointer; var IsKeyFrame: Boolean;
  var Size: Cardinal): Pointer;
var
   dwChunkId: Cardinal;
   dwFlags: Cardinal;
   dwFlagsIn: Cardinal;
   sizeImage: Cardinal;
   lAllowableFrameSize: Cardinal;
   lKeyRateCounterSave: Cardinal;
   bNoOutputProduced: Boolean;
begin
     Size:=0;
     Result:=nil;
     if not FCompressorStarted then exit;
     
     dwChunkId:=0;
     dwFlags:=0;
     dwFlagsIn:=ICCOMPRESS_KEYFRAME;
     lAllowableFrameSize:=0;//xFFFFFF;	// yes, this is illegal according to the docs (see below)
     lKeyRateCounterSave:=FKeyRateCounter;

     // Figure out if we should force a keyframe.  If we don't have any
     // keyframe interval, force only the first frame.  Otherwise, make
     // sure that the key interval is lKeyRate or less.  We count from
     // the last emitted keyframe, since the compressor can opt to
     // make keyframes on its own.

     if FForceKeyFrameRate then
     begin
       if (cv.lKey = 0) then
       begin
         if (FFrameNum > 0) then
            dwFlagsIn:=0;
       end
       else
       begin
         Dec(FKeyRateCounter);
         if (FKeyRateCounter > 0) then
            dwFlagsIn:=0
         else
            FKeyRateCounter:=cv.lKey;
       end;
     end
     else
        dwFlagsIn:=0;

     // Figure out how much space to give the compressor, if we are using
     // data rate stricting.  If the compressor takes up less than quota
     // on a frame, save the space for later frames.  If the compressor
     // uses too much, reduce the quota for successive frames, but do not
     // reduce below half datarate.
     if (FMaxFrameSize > 0) then
     begin
       lAllowableFrameSize:=FMaxFrameSize + (FSlopSpace shr 2);
       if (lAllowableFrameSize < (FMaxFrameSize shr 1)) then
       	  lAllowableFrameSize:=FMaxFrameSize shr 1;
     end;

     // A couple of notes:
     //
     //	o  ICSeqCompressFrame() passes 0x7FFFFFFF when data rate control
     //	   is inactive.  Docs say 0.  We pass 0x7FFFFFFF here to avoid
     //	   a bug in the Indeo 5 QC driver, which page faults if
     //	   keyframe interval=0 and max frame size = 0.

     sizeImage:=cv.lpbiOut^.bmiHeader.biSizeImage;

//	pbiOutput->bmiHeader.biSizeImage = 0;

     // Compress!

     if (dwFlagsIn > 0) then
        dwFlags:=AVIIF_KEYFRAME;

     FLastError:=ICCompress(
       cv.hic, dwFlagsIn, @(cv.lpbiOut^.bmiHeader), FBuffCompOut,
       @(cv.lpbiIn^.bmiHeader), ImageData, @dwChunkId, @dwFlags, FFrameNum,
       IIF(FFrameNum > 0, lAllowableFrameSize, $0FFFFFF), cv.lQ,
       IIF(HasFlag(dwFlagsIn, ICCOMPRESS_KEYFRAME), nil, @(cv.lpbiIn^.bmiHeader)),
       IIF(HasFlag(dwFlagsIn, ICCOMPRESS_KEYFRAME), nil, FPrevBuffer));

     // Special handling for DivX 5 codec:
     //
     // A one-byte frame starting with 0x7f should be discarded
     // (lag for B-frame).

     bNoOutputProduced:=false;
     if (cv.lpbiOut^.bmiHeader.biCompression = MKFOURCC('0', '5', 'x', 'd')) or
        (cv.lpbiOut^.bmiHeader.biCompression = MKFOURCC('0', '5', 'X', 'D')) then
     begin
       if (cv.lpbiOut^.bmiHeader.biSizeImage = 1) and (FBuffCompOut^ = Char($7f)) then
          bNoOutputProduced:=true;
     end;

     // Special handling for XviD codec:
     //
     // Query codec for extended status.

     if bNoOutputProduced then
     begin
       cv.lpbiOut^.bmiHeader.biSizeImage:=sizeImage;
       FKeyRateCounter:=lKeyRateCounterSave;
       Result:=nil;
       exit;
     end;

     Inc(FFrameNum);

     Size:=cv.lpbiOut^.bmiHeader.biSizeImage;

     // If we're using a compressor with a stupid algorithm (Microsoft Video 1),
     // we have to decompress the frame again to compress the next one....
     if (FLastError = ICERR_OK) and Assigned(FPrevBuffer) and
        ((cv.lKey = 0) or (FKeyRateCounter > 1)) then
          FLastError:=ICDecompress(cv.hic,
            IIF(HasFlag(dwFlags, AVIIF_KEYFRAME), 0, ICDECOMPRESS_NOTKEYFRAME),
            @(cv.lpbiOut^.bmiHeader), FBuffCompOut, @(cv.lpbiIn^.bmiHeader), FPrevBuffer);

     cv.lpbiOut^.bmiHeader.biSizeImage:=sizeImage;

     {
     if (res <> ICERR_OK) then
        raise Exception.Create('Video compression error');
     }
     if FLastError <> ICERR_OK then
     begin
       Result:=nil;
       Size:=0;
       exit;
     end;

     // Update quota.

     if (FMaxFrameSize > 0) then
     begin
       FSlopSpace:=FSlopSpace + FMaxFrameSize - Size;
     end;

     // Was it a keyframe?
     if HasFlag(dwFlags, AVIIF_KEYFRAME) then
     begin
       IsKeyframe:=true;
       FKeyRateCounter:=cv.lKey;
     end
     else
     begin
       IsKeyframe:=false;
     end;

     // handle PB frames ( I263 and maybe some other codecs also)
     if (Size = 8) and (FBuffCompOut^ = #0) then
        Result:=PackFrame(ImageData, IsKeyFrame, Size)
     else
        Result:=FBuffCompOut;
end;

function TVideoCoDec.UnpackFrame(ImageData: Pointer; KeyFrame: Boolean;
  var Size: Cardinal): Pointer;
begin
     Size:=cv.lpbiIn^.bmiHeader.biSizeImage;
     ReallocMem(FBuffDecompOut, Size);
     FLastError:=ICDecompress(hICDec,
       IIF(KeyFrame, 0, ICDECOMPRESS_NOTKEYFRAME),
       @(cv.lpbiOut^.bmiHeader), ImageData, @(cv.lpbiIn^.bmiHeader), FBuffDecompOut);


     Result:=nil;
     if (FLastError <> ICERR_OK) then
     begin
       Size:=0;
       exit;
     end;
     
     Result:=FBuffDecompOut;
end;

function TVideoCoDec.GetBitmapInfoIn: TBitmapInfo;
begin
     Result:=cv.lpbiIn^;
end;

function TVideoCoDec.GetBitmapInfoOut: TBitmapInfo;
begin
     Result:=cv.lpbiOut^;
end;

function TVideoCoDec.GetQuality: Integer;
begin
     Result:=cv.lQ;
end;

procedure TVideoCoDec.SetQuality(const Value: Integer);
begin
     cv.lQ:=Value;
end;

function TVideoCoDec.PackBitmap(Bitmap: TBitmap; var IsKeyFrame: Boolean;
  var Size: Cardinal): Pointer;
begin
     if not Assigned(Bitmap) then
     begin
       Result:=nil;
       Size:=0;
       exit;
     end
     else
       Result:=PackFrame(Bitmap.ScanLine[0], IsKeyFrame, Size);
end;

function TVideoCoDec.UnpackBitmap(ImageData: Pointer; KeyFrame: Boolean;
  Bitmap: TBitmap): Boolean;
var Size: Cardinal;
    lpData: Pointer;
    bmi: TBitmapInfo;
    bmih: TBitmapInfoHeader;
    usage, paintmode: Integer;
begin
     Result:=Assigned(ImageData) and Assigned(Bitmap);
     if not Result then exit;
     try
        bmi:=BIInput;
        bmih:=bmi.bmiHeader;
        lpData:=UnpackFrame(ImageData, KeyFrame, Size);
        Result:=Assigned(lpData) and (Size > 0);
        if not Result then exit;
        usage:=IIF(bmih.biClrUsed = 0, DIB_RGB_COLORS, DIB_PAL_COLORS);
        PaintMode:=IIF(KeyFrame, SRCCOPY, MERGECOPY);
        with Bitmap do
        begin
          Width:=bmih.biWidth;
          Height:=bmih.biHeight;
          Result:=StretchDIBits(Canvas.Handle, 0, 0, bmih.biWidth, bmih.biHeight,
            0, 0, bmih.biWidth, bmih.biHeight, lpData, bmi, usage, paintmode) > 0;
        end;
     except
        Result:=false;
     end;
end;

// typecast the List.Objects[I] as Cardinal to get the fccHandler code !
function TVideoCoDec.EnumCodecs(List: TStrings): Integer;
var pII: TICINFO;
    c: Integer;
    ok: Boolean;
    fccType: TFourCC;
    hIC: Cardinal;
begin
     c:=0;
     List.Clear;
     fccType.AsString:='vidc';
     ZeroMemory(@pII, SizeOf(pII));
     repeat
       ok:=ICInfo(fccType.AsCardinal, c, @pII);
       if ok then
       begin
         Inc(c);
         // open the compressor ..
         // should get all the info with ICInfo but it doesn't ?!?!
         // this slows the whole thing quite a bit .. about 0.5 - 1 sec !
         hIC:=ICOpen(fccType.AsCardinal, pII.fccHandler, ICMODE_COMPRESS);
         if hIC > 0 then
         try
            if ICGetInfo(hIC, @pII, SizeOf(pII)) > 0 then
               List.AddObject(pII.szDescription, TObject(pII.fccHandler));
         finally
            ICClose(hIC);
         end;
       end;
     until not ok;

     // return the number of installed codecs
     // the list can contain less codecs !
     Result:=c;
end;

end.


