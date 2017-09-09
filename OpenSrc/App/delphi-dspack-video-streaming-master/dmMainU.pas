unit dmMainU;

interface

{$I Defines.inc}
{.$DEFINE MANUALYUY2TORGB} //debug ON /OFF

uses
  Windows, Graphics, SysUtils, Classes, Forms, ExtCtrls,
  IdThreadMgr, IdThreadMgrDefault, IdBaseComponent, IdComponent, IdTCPServer,
  DSPack, DirectShow9,
  CommonU, VideoCoDec, IdContext, IdCustomTCPServer;

type
  TYUY2Word = packed record
    Y : Byte;
    UV : Byte;
  end;

  PRGBTripleArray = ^TRGBTripleArray;
  TRGBTripleArray = array[0..32767] of TRGBTriple;

  TdmMain = class(TDataModule)
    fgMain: TFilterGraph;
    sgVideo: TSampleGrabber;
    dsfCam: TFilter;
    TCPServer: TIdTCPServer;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure TCPServerExecute(AThread: TIdPeerThread);
    procedure sgVideoBuffer(sender: TObject; SampleTime: Double;
      pBuffer: Pointer; BufferLen: Integer);
  private
    YUY2Stream: TMemoryStream;
    {$IFDEF MANUALYUY2TORGB}
    LastFrame: TBitmap;
    {$ENDIF}
    LastPacket: TFramePacket;
  public
    FrameWidth: Integer;
    FrameHeight: Integer;
    VideoCoDec: TVideoCoDec;
    procedure UpdateVideoFormat(InputFormat: TBitmapInfoHeader);
  end;

var
  dmMain: TdmMain;
  MREWS: TMultiReadExclusiveWriteSynchronizer;

implementation

uses
  DisplayU, Preview;

{$R *.dfm}

{-------------------------------------------------------------------------------
  Procedure: YUY2ToBMP
  Author:    Michael Andersen - slightly modified by Lee_Nover
  Date:      18-nov-2002
  Arguments: const aWidth, aHeight: Integer; MemBuf: TMemoryStream
  Result:    TBitmap
-------------------------------------------------------------------------------}

{$IFDEF MANUALYUY2TORGB}
function YUY2ToBMP(const aWidth, aHeight: Integer; MemBuf: TMemoryStream; bmp: TBitmap = nil): TBitmap;

  function FixValue(const x: Double): Byte;
  var
    v: Integer;
  begin
    v := Round(x);
    if v > 255 then
       Result := 255
    else if v < 0 then
       Result := 0
    else
       Result := Byte(v);
  end;

var
  BufferYUV: array[0..32767] of TYUY2Word;
  i, j, Y, U, V: Integer;
  Row: PRGBTripleArray;
begin
  // quick hack - change this
  if Assigned(bmp) then
    Result:=bmp
  else
    Result := TBitmap.Create;

  Result.PixelFormat := pf24Bit;
  Result.Width := aWidth;
  Result.Height := aHeight;

  MemBuf.Position := 0;
  for j := 0 to aHeight-1 do begin
    MemBuf.Read(BufferYUV, Round((SizeOf(BufferYUV) / 32768) * aWidth) );

    Row := Result.Scanline[j];

    for i := 0 to aWidth-1 do begin
      if i mod 2 = 0 then begin
        Y := BufferYUV[i].Y;
        U := BufferYUV[i].UV;
        V := BufferYUV[i+1].UV;
      end else begin
        Y := BufferYUV[i].Y;
        U := BufferYUV[i-1].UV;
        V := BufferYUV[i].UV
      end;

      with Row[i] do begin
        rgbtRed := FixValue( 1.164383 * (Y -16) + 1.596027 * (V-128) );
        rgbtGreen := FixValue( 1.164383 * (Y - 16) - (0.391762 * (U-128)) - (0.812968 * (V-128)) );
        rgbtBlue := FixValue( 1.164383 * (Y - 16) + 2.017232 * (U-128) );
      end;
    end;
  end;
end;
{$ENDIF}

procedure TdmMain.DataModuleCreate(Sender: TObject);
begin
  ZeroMemory(@LastPacket, SizeOf(TFramePacket));
  VideoCoDec := TVideoCoDec.Create;
  MREWS := TMultiReadExclusiveWriteSynchronizer.Create;
  YUY2Stream := TMemoryStream.Create;
  {$IFDEF MANUALYUY2TORGB}
  LastFrame := TBitmap.Create;
  {$ENDIF}
  TCPServer.DefaultPort := 33000;
  //TCPServer.Active := True;
end;

procedure TdmMain.DataModuleDestroy(Sender: TObject);
begin
  TCPServer.Active := False;
  FreeAndNil(MREWS);
  {$IFDEF MANUALYUY2TORGB}
  FreeAndNil(LastFrame);
  {$ENDIF}
  FreeAndNil(YUY2Stream);
  FreeAndNil(VideoCoDec);

  sgVideo.MediaType := nil;
end;

procedure TdmMain.TCPServerExecute(AThread: TIdPeerThread);
var
  CH: TCommHeader;
  FP: TFramePacket;
  bmih: TBitmapInfoHeader;
begin
  // ALL messages should have a standard packet (easier coding)
  AThread.Connection.ReadBuffer(CH, SizeOf(CH));
  // check what the client wants

  case CH.DPType of
    1: // the client wants frame format and refresh rate
    begin
      bmih := VideoCoDec.BIOutput.bmiHeader;
      // set the size of the data part to the size of the header
      CH.DPSize := SizeOf(bmih);
      CH.DPExtra := 30; // hardcoded .. find out the real RR from the source
      // send the header
      SendData(AThread.Connection, CH, @bmih);
    end;

    2: // request for frame
    begin
      // synch the copying of the last frame
      MREWS.BeginRead;
      try
        FP := CopyFrame(LastPacket);
      finally
        MREWS.EndRead;
      end;
      // send the frame
      SendFrame(AThread.Connection, CH, FP);
      // free the copied packet
      FreeFrame(FP);
    end;
  end;
end;

procedure TdmMain.UpdateVideoFormat(InputFormat: TBitmapInfoHeader);
var
  bmihOut: TBitmapInfoHeader;
  FrameRate: Integer;
begin
  bmihOut := InputFormat;
  InputFormat.biCompression := 0;
  FrameRate := 30;
  VideoCoDec.Finish;
  VideoCoDec.ForceKeyFrameRate := true;
  VideoCoDec.Init(InputFormat, bmihOut, 100, 10);
  VideoCoDec.SetDataRate(1024, 1000 * 1000 div FrameRate, 1);
  if not VideoCoDec.StartCompressor then
    DisplayF.Caption := TranslateICError(VideoCoDec.LastError)
  else
    //DisplayF.Caption := VideoCoDec.CodecDescription;
    DisplayF.Caption := 'Delphi Streaming';

  frmPreview.ClientHeight := InputFormat.biHeight;
  frmPreview.ClientWidth  := InputFormat.biWidth;
end;

procedure TdmMain.sgVideoBuffer(sender: TObject; SampleTime: Double;
  pBuffer: Pointer; BufferLen: Integer);
var
  p: PByte;
begin
  if not VideoCoDec.CompressorStarted then
    Exit;

  {$IFDEF MANUALYUY2TORGB}
  // the data is in YUY2 format because of overlay so we need to convert it to RGB
  YUY2Stream.Clear;
  YUY2Stream.Write(pBuffer^, BufferLen);
  YUY2ToBMP(FrameWidth, FrameHeight, YUY2Stream, LastFrame);
  {$ENDIF}

  MREWS.BeginWrite;  // remove to gain performance but at desynch risk
  with LastPacket do
    try
      {$IFDEF MANUALYUY2TORGB}
      p := VideoCoDec.PackBitmap(LastFrame, KeyFrame, Size);
      {$ELSE}
      p := VideoCoDec.PackFrame(pBuffer, KeyFrame, Size);
      {$ENDIF}
      if Size < 1 then
        Exit;
      ReallocMem(Data, Size);
      CopyMemory(Data, p, Size);
    finally
      MREWS.EndWrite; // remove to gain performance but at desynch risk
    end;
end;

end.
