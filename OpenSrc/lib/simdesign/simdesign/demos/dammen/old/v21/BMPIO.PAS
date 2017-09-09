{$G+} {$N+}

unit BmpIO;

{ Turbo-Pascal unit BmpIO:
   - implements import/export of Windows Bitmap (.BMP) files

  Version 1.0 06-05-96

  (c) 1996 by N. Haeck
}

INTERFACE

uses Graph,Objects,WBasic;

type TColor=array[0..2] of byte;
     PPalette=^TPalette;
     TPalette=array[0..255] of TColor;

const EGAPalette: array[0..15,0..2] of byte =
  (($00,$00,$00),($BF,$00,$00),($00,$BF,$00),($BF,$BF,$00),
   ($00,$00,$BF),($BF,$00,$BF),($00,$BF,$BF),($C0,$C0,$C0),
   ($40,$40,$40),($FF,$00,$00),($00,$FF,$00),($FF,$FF,$00),
   ($00,$00,$FF),($FF,$00,$FF),($00,$FF,$FF),($FF,$FF,$FF));

type PBmpRec=^TBmpRec;
     TBmpRec=record
       FileLength: longint;
       PaletteStart: longint;
       PictureStart: longint;
       Size: TPoint;
       ColorBits: byte;
     end;

const
  beStream=1;
  beSyntax=2;

type PBmp16=^TBmp16;
     TBmp16=object(TObject)
       Palette: pointer;
       PaletteSize: integer;
       Bmp: TBmpRec;
       Error: integer;
       StartX,StartY: integer;
       constructor Init(SizeX,SizeY: integer);
       constructor Load(var S: TStream);
       destructor Done; virtual;
       procedure SetStart(AStartX,AStartY: integer); virtual;
       procedure Store(var S: TStream);
     private
       function GetColorBits: byte; virtual;
       procedure GetScanLine(ScanBuf: PByteArray; Y: integer); virtual;
       procedure LoadData(var S: TStream); virtual;
       procedure LoadHeader(var S: TStream); virtual;
       procedure LoadPalette(var S: TStream); virtual;
       procedure PutScanLine(ScanBuf: PByteArray; Y: integer); virtual;
       procedure SetBmpRec; virtual;
       procedure StoreData(var S: TStream); virtual;
       procedure StoreHeader(var S: TStream); virtual;
       procedure StorePalette(var S: TStream); virtual;
     end;

IMPLEMENTATION

{Bmp16 object}
constructor TBmp16.Init;
  begin
    TObject.Init;
    Bmp.Size.X:=SizeX;
    Bmp.Size.Y:=SizeY;
    SetBmpRec;
    palette:=@EGApalette;
  end;

constructor TBmp16.Load;
  begin
    TObject.Init;
    LoadHeader(S);
    if S.Status<>stOK then
      Error:=beStream;
    if Error=0 then
      if Bmp.ColorBits<>GetColorBits then
        Error:=beSyntax;
    if Error=0 then
    begin
      LoadPalette(S);
      LoadData(S);
    end;
  end;

destructor TBmp16.Done;
  begin
    if (PaletteSize>0) and (Palette<>nil) then
      Freemem(Palette,PaletteSize);
    TObject.Done;
  end;

procedure TBmp16.SetStart(AStartX,AStartY: integer);
  begin
    StartX:=AStartX;
    StartY:=AStartY;
  end;

procedure TBmp16.Store;
  var pos: longint;
      Tmp: byte;
  begin
    if Error=0 then
    begin
      S.Seek(0);
      Tmp:=0;
      for pos:=1 to Bmp.FileLength do
        S.Write(Tmp,1);
      StoreHeader(S);
      StorePalette(S);
      StoreData(S);
    end;
  end;

{private Bmp16 routines}
function TBmp16.GetColorBits;
  begin
    GetColorBits:=4;
  end;

procedure TBmp16.GetScanLine(ScanBuf: PByteArray; Y: integer);
  var x: integer;
  begin
    for x:=0 to Bmp.Size.X-1 do
      ScanBuf^[x]:=GetPixel(StartX+x,StartY+Y);
  end;

procedure TBmp16.LoadData;
  var LoadBuf,ScanBuf: PByteArray;
      ScanX,x,y: integer;
      pix: byte;
      pos: longint;
  begin
    S.Seek(Bmp.PictureStart);
    ScanX:=((((Bmp.Size.X+1) div 2)+3) div 4)*4;
    GetMem(LoadBuf,ScanX);
    GetMem(ScanBuf,Bmp.Size.X);
    for y:=Bmp.Size.Y-1 downto 0 do
    begin
      S.Read(LoadBuf^,ScanX);
      for x:=0 to Bmp.Size.X-1 do
      begin
        if (x mod 2)=0 then
          Pix:=LoadBuf^[x div 2] div $10
        else
          Pix:=LoadBuf^[x div 2] and $0F;
        ScanBuf^[x]:=Pix;
      end;
      PutScanLine(ScanBuf,y);
    end;
    FreeMem(ScanBuf,Bmp.Size.X);
    FreeMem(LoadBuf,ScanX);
  end;

procedure TBmp16.LoadHeader;
  var TmpChr1,TmpChr2: char;
      TmpLng: longint;
      TmpWrd: word;
  begin
    S.Seek(0);
    S.Read(TmpChr1,1); S.Read(TmpChr2,1);
    if (TmpChr1<>'B') or (TmpChr2<>'M') then
      Error:=beSyntax;
    S.Read(Bmp.FileLength,4);
    S.Read(TmpLng,4); if TmpLng<>0 then Error:=beSyntax;
    S.Read(Bmp.PictureStart,4);
    Bmp.PaletteStart:=S.GetPos;
    S.Read(TmpLng,4); Bmp.PaletteStart:=BMP.PaletteStart+TmpLng;
    S.Read(TmpLng,4); Bmp.Size.X:=TmpLng;
    S.Read(TmpLng,4); Bmp.Size.Y:=TmpLng;
    S.Read(TmpWrd,2); if TmpWrd<>1 then Error:=beSyntax;
    S.Read(TmpWrd,2); Bmp.ColorBits:=TmpWrd;
  end;

procedure TBmp16.LoadPalette;
  var x: integer;
      TmpByte: byte;
  begin
    Case Bmp.ColorBits of
      4: PaletteSize:=16;
      8: PaletteSize:=256;
    end;
    GetMem(Palette,SizeOf(TColor)*PaletteSize);
    S.Seek(BMP.PaletteStart);
    for x:=0 to PaletteSize-1 do
    begin
      S.Read(PPalette(Palette)^[x],SizeOf(TColor));
      S.Read(TmpByte,1);
    end;
  end;

procedure TBmp16.PutScanLine(ScanBuf: PByteArray; Y: integer);
  var x: integer;
  begin
    for x:=0 to Bmp.Size.X-1 do
      PutPixel(StartX+x,StartY+Y,ScanBuf^[x]);
  end;

procedure TBmp16.SetBmpRec;
  var DataSize: longint;
  begin
    Bmp.PaletteStart:=54;
    Bmp.PictureStart:=118;
    Bmp.ColorBits:=4;
    DataSize:=LongMul(((((Bmp.Size.X+1) div 2)+3) div 4)*4,Bmp.Size.Y);
    Bmp.FileLength:=Bmp.PictureStart+DataSize;
  end;

procedure TBmp16.StoreData;
  var StoreBuf,ScanBuf: PByteArray;
      ScanX,x,y: integer;
      pix: byte;
      pos: longint;
  begin
    S.Seek(Bmp.PictureStart);
    ScanX:=((((Bmp.Size.X+1) div 2)+3) div 4)*4;
    GetMem(StoreBuf,ScanX);
    GetMem(ScanBuf,Bmp.Size.X);
    for y:=Bmp.Size.Y-1 downto 0 do
    begin
      GetScanLine(ScanBuf,y);
      for x:=0 to Bmp.Size.X-1 do
      begin
        Pix:=ScanBuf^[x];
        if (x mod 2)=0 then
          StoreBuf^[x div 2]:=Pix*$10
        else
          StoreBuf^[x div 2]:=StoreBuf^[x div 2]+Pix;
      end;
      S.Write(StoreBuf^,ScanX);
    end;
    FreeMem(ScanBuf,Bmp.Size.X);
    FreeMem(StoreBuf,ScanX);
  end;

procedure TBmp16.StoreHeader;
  var TmpS: string;
      TmpLng: longint;
      TmpWrd: word;
  begin
    S.Seek(0);
    TmpS:='BM';
    TmpLng:=0;
    S.Write(TmpS[1],2);
    S.Write(BMP.FileLength,4);
    S.Write(TmpLng,4);
    S.Write(BMP.PictureStart,4);
    TmpLng:=BMP.PaletteStart-S.GetPos;
    S.Write(TmpLng,4);
    TmpLng:=Bmp.Size.X;
    S.Write(TmpLng,4);
    TmpLng:=Bmp.Size.Y;
    S.Write(TmpLng,4);
    TmpWrd:=1;
    S.Write(TmpWrd,2);
    TmpWrd:=Bmp.ColorBits;
    S.Write(TmpWrd,2);
  end;

procedure TBmp16.StorePalette;
  var x: integer;
      TmpByte: byte;
      TmpPaletteSize: integer;
  begin
    TmpByte:=0;
    Case Bmp.ColorBits of
      4: TmpPaletteSize:=16;
      8: TmpPaletteSize:=256;
    end;
    S.Seek(Bmp.PaletteStart);
    for x:=0 to TmpPaletteSize-1 do
    begin
      S.Write(PPalette(Palette)^[x],SizeOf(TColor));
      S.Write(TmpByte,1);
    end;
  end;

end.