unit unCustomImageDrawHook;

{-------------------------------------------------------------------------------
Including this draw hook class in the project will make disabled toolbar items
appear as a gradient grayscale instead of monochrome when disabled.

The code in this file only is from StackOverflow, and is licensed under
the Creative Commons Licence.

Original Source:
http://stackoverflow.com/questions/6003018/make-disabled-menu-and-toolbar-images-look-better
-------------------------------------------------------------------------------}

interface
  {
uses
  Windows,
  SysUtils,
  Graphics,
  ImgList,
  CommCtrl,
  Math,
  Vcl.ActnMan,
  System.Classes;
    }
implementation
     {
type
  TJumpOfs = Integer;
  PPointer = ^Pointer;

  PXRedirCode = ^TXRedirCode;
  TXRedirCode = packed record
    Jump: Byte;
    Offset: TJumpOfs;
  end;

  PAbsoluteIndirectJmp = ^TAbsoluteIndirectJmp;
  TAbsoluteIndirectJmp = packed record
    OpCode: Word;
    Addr: PPointer;
  end;


  TCustomImageListHack = class(TCustomImageList);
  TCustomActionControlHook = class(TCustomActionControl);

var
  DoDrawBackup   : TXRedirCode;
  DoDrawBackup2   : TXRedirCode;

function GetActualAddr(Proc: Pointer): Pointer;
begin
  if Proc <> nil then
  begin
    if (Win32Platform = VER_PLATFORM_WIN32_NT) and (PAbsoluteIndirectJmp(Proc).OpCode = $25FF) then
      Result := PAbsoluteIndirectJmp(Proc).Addr^
    else
      Result := Proc;
  end
  else
    Result := nil;
end;

procedure HookProc(Proc, Dest: Pointer; var BackupCode: TXRedirCode);
var
  n: SIZE_T;
  Code: TXRedirCode;
begin
  Proc := GetActualAddr(Proc);
  Assert(Proc <> nil);
  if ReadProcessMemory(GetCurrentProcess, Proc, @BackupCode, SizeOf(BackupCode), n) then
  begin
    Code.Jump := $E9;
    Code.Offset := PAnsiChar(Dest) - PAnsiChar(Proc) - SizeOf(Code);
    WriteProcessMemory(GetCurrentProcess, Proc, @Code, SizeOf(Code), n);
  end;
end;

procedure UnhookProc(Proc: Pointer; var BackupCode: TXRedirCode);
var
  n: SIZE_T;
begin
  if (BackupCode.Jump <> 0) and (Proc <> nil) then
  begin
    Proc := GetActualAddr(Proc);
    Assert(Proc <> nil);
    WriteProcessMemory(GetCurrentProcess, Proc, @BackupCode, SizeOf(BackupCode), n);
    BackupCode.Jump := 0;
  end;
end;

procedure Bitmap2GrayScale(const BitMap: TBitmap);
type
  TRGBArray = array[0..32767] of TRGBTriple;
  PRGBArray = ^TRGBArray;
var
  x, y, Gray: Integer;
  Row       : PRGBArray;
begin
  BitMap.PixelFormat := pf24Bit;
  for y := 0 to BitMap.Height - 1 do
  begin
    Row := BitMap.ScanLine[y];
    for x := 0 to BitMap.Width - 1 do
    begin
      Gray             := (Row[x].rgbtRed + Row[x].rgbtGreen + Row[x].rgbtBlue) div 3;
      Row[x].rgbtRed   := Gray;
      Row[x].rgbtGreen := Gray;
      Row[x].rgbtBlue  := Gray;
    end;
  end;
end;


//from ImgList.GetRGBColor
function GetRGBColor(Value: TColor): DWORD;
begin
  Result := ColorToRGB(Value);
  case Result of
    clNone:
      Result := CLR_NONE;
    clDefault:
      Result := CLR_DEFAULT;
  end;
end;


procedure New_Draw(Self: TObject; Index: Integer; Canvas: TCanvas; X, Y: Integer; Style: Cardinal; Enabled: Boolean);
var
  MaskBitMap : TBitmap;
  GrayBitMap : TBitmap;
begin
  with TCustomImageListHack(Self) do
  begin
    if not HandleAllocated then Exit;
    if Enabled then
      ImageList_DrawEx(Handle, Index, Canvas.Handle, X, Y, 0, 0, GetRGBColor(BkColor), GetRGBColor(BlendColor), Style)
    else
    begin
      GrayBitMap := TBitmap.Create;
      MaskBitMap := TBitmap.Create;
      try
        GrayBitMap.SetSize(Width, Height);
        MaskBitMap.SetSize(Width, Height);
        GetImages(Index, GrayBitMap, MaskBitMap);
        Bitmap2GrayScale(GrayBitMap);
        BitBlt(Canvas.Handle, X, Y, Width, Height, MaskBitMap.Canvas.Handle, 0, 0, SRCERASE);
        BitBlt(Canvas.Handle, X, Y, Width, Height, GrayBitMap.Canvas.Handle, 0, 0, SRCINVERT);
      finally
        GrayBitMap.Free;
        MaskBitMap.Free;
      end;
    end;
  end;
end;


procedure New_Draw2(Self: TObject; const Location: TPoint);
var
  ImageList: TCustomImageList;
  DrawEnabled: Boolean;
  LDisabled: Boolean;
begin
  with TCustomActionControlHook(Self) do
  begin
    if not HasGlyph then Exit;
    ImageList := FindImageList(True, LDisabled, ActionClient.ImageIndex);
    if not Assigned(ImageList) then Exit;
    DrawEnabled := LDisabled or Enabled and (ActionClient.ImageIndex <> -1) or
      (csDesigning in ComponentState);
    ImageList.Draw(Canvas, Location.X, Location.Y, ActionClient.ImageIndex,
      dsTransparent, itImage, DrawEnabled);
  end;
end;


procedure HookDraw;
begin
  HookProc(@TCustomImageListHack.DoDraw, @New_Draw, DoDrawBackup);
  HookProc(@TCustomActionControlHook.DrawLargeGlyph, @New_Draw2, DoDrawBackup2);
end;

procedure UnHookDraw;
begin
  UnhookProc(@TCustomImageListHack.DoDraw, DoDrawBackup);
  UnhookProc(@TCustomActionControlHook.DrawLargeGlyph, DoDrawBackup2);
end;


initialization
  HookDraw;
finalization
  UnHookDraw;
  }

end.

