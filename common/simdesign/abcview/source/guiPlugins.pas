{ unit Plugins

  Implements a plugin framework to communicate with DLLs that provide extra
  functionality.

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!
}
unit guiPlugins;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Mask, rxToolEdit, IniFiles, Contnrs, sdProperties,
  sdAbcTypes, sdItems, sdAbcVars;

type

  TPlugin = class
  private
    DllDoAuthorise:           function(var AMessage: PChar): word; stdcall;
    DllDoInit:                procedure(AppPath, DllPath: PChar); stdcall;
    DllDoSetup:               function(ASetup: pointer): word; stdcall;
    DllFuzzyAuxCompare:       function(Name1, Name2: PChar): boolean; stdcall;
    DllFuzzyCompare:          function(Data1: pointer; Size1: integer; Data2: pointer; Size2, Limit: integer): integer; stdcall;
    DllFuzzyPreAccept:        function(AName: PChar): boolean; stdcall;
    DllGetCapabilities:       function: word; stdcall;
    DllGetFilterName:         function: PChar; stdcall;
    DllGetFilterType:         function: integer; stdcall;
    DllGetFuzzyLimit:         function(ATolerance: integer): integer; stdcall;
    DllGetFuzzyLimitStr:      function(ATolerance: integer): PChar; stdcall;
    DllGetPluginName:         function: PChar; stdcall;
    DllGetPropertyID:         function: word; stdcall;
    DllGetPluginVersion:      function: PChar; stdcall;
    DllIndexByName:           procedure(AName: PChar; M: TStream); stdcall;
    DllIndexByStream:         procedure(AName: PChar; S, M: TStream); stdcall;
    DllIsAuthorised:          function(var AMessage: PChar): word; stdcall;
    DllShowInfo:              procedure; stdcall;
    FFlags: word;
    FMode: word;   // DLL mode
    FRegMessage: string;
    FLibrary: HMODULE;
    FLocation: string; // complete path + filename (abc*.dll) of this plugin
    procedure Connect(ALocation: string);
    procedure Disconnect;
  protected
    function CreateProperty(AItem: TsdItem; S: TStream): TsdProperty;
    function GetAllowed: boolean;
    function GetConnected: boolean;
    function GetFilterName: string;
    function GetFilterType: integer;
    function GetPluginName: string;
    function GetPluginVersion: string;
    function GetPropertyId: integer;
    function GetStatus: string;
    procedure SetLocation(AValue: string);
  public
    destructor Destroy; override;
    procedure DoCustomIndex(AItem: TsdItem; S: TStream);
    procedure FilterCalculateItem(Sender: TObject; AItem: TsdItem; var Accept: boolean);
    function FilterFuzzyPreAccept(Item: TsdItem): boolean;
    function FilterFuzzyCompare(Item1, Item2: TsdItem; Data1, Data2: pointer; Limit: integer): integer;
    function FilterFuzzyFilter(Item1, Item2: TsdItem; Limit: integer; var IsEqual: boolean): boolean;
    procedure FilterItemData(Sender: TObject; AItem: TsdItem; var Data: pointer);
    function GetCapabilities: word;
    function GetFuzzyLimit(ATolerance: integer): integer;
    function GetFuzzyLimitStr(ATolerance: integer): string;
    function HasFilter: boolean;
    procedure LoadFromIni(AIni: TInifile; ASection: string); virtual;
    procedure SaveToIni(AIni: TInifile; ASection: string); virtual;
    property Allowed: boolean read GetAllowed;
    property Connected: boolean read GetConnected;
    property Location: string read FLocation write SetLocation;
    property FilterName: string read GetFilterName;
    property FilterType: integer read GetFilterType;
    property Flags: word read FFlags write FFlags;
    property Mode: word read FMode write FMode;
    property PluginName: string read GetPluginName;
    property PluginVersion: string read GetPluginVersion;
    property PropertyId: integer read GetPropertyId;
    property Status: string read GetStatus;
  end;

  TPluginList = class(TObjectList)
  protected
    function GetItems(Index: integer): TPlugin;
  public
    procedure LoadFromIni(AInifile: string);
    procedure SaveToIni(AInifile: string);
    property Items[Index: integer]: TPlugin read GetItems; default;
  end;

  TdlgPlugin = class(TForm)
    Label1: TLabel;
    fePlugin: TFilenameEdit;
    btnLoad: TBitBtn;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    lblName: TLabel;
    Label4: TLabel;
    lblVersion: TLabel;
    Label6: TLabel;
    lblStatus: TLabel;
    BitBtn2: TBitBtn;
    BitBtn4: TBitBtn;
    btnCancel: TBitBtn;
    lblRegTo: TLabel;
    btnInfo: TButton;
    btnSetup: TButton;
    btnAuthorize: TButton;
    procedure btnLoadClick(Sender: TObject);
    procedure btnAuthorizeClick(Sender: TObject);
    procedure btnInfoClick(Sender: TObject);
    procedure btnSetupClick(Sender: TObject);
  private
    FPlugin: TPlugin;
  public
    procedure PluginToForm(APlugin: TPlugin);
    procedure UpdateControls(Sender: TObject);
  end;

  // Plugin property to hold custom data
  TprPlugin = class(TStoredProperty)
  protected
    function GetPropID: word; override;
  public
    FPropID: integer;
    FSize: integer;
    FMem: pointer;
    destructor Destroy; override;
    procedure SetSize(ASize: integer);
    procedure ReadComponents(S: TStream); override;
    procedure WriteComponents(S: TStream); override;
  end;

var
  dlgPlugin: TdlgPlugin;
  glPlugins: TPluginList = nil;

// Additonal plugins from 3rd parties
procedure Load3rdpartyPlugins;
procedure Unload3rdPartyPlugins;

// Load additional file formats (if the plugin is there)

procedure ReadDXF(AFilename: string; var Error: string; Bitmap: TBitmap);
procedure ReadDWG(AFilename: string; var Error: string; Bitmap: TBitmap);
procedure ReadAvi(AFilename: string; Bitmap: TBitmap);
procedure ReadTTF(AFilename: string; Bitmap: TBitmap);
procedure ReadJp2(AFilename: string; var Error: string; Bitmap: TBitmap);
procedure ReadSvg(AFilename: string; Bitmap: TBitmap);

// Set the global variables that handle plugins
procedure PluginGlobalVars;

// Do we need to create a custom index for AFile?
function MustIndexCustom(AFile: TsdFile): boolean;

implementation

{uses
  Utils;}

const

  cDefaultFuzzyLimitByTol: array[0..7] of integer =
    (10, 20, 50, 100, 200, 500, 1000, 2000);


{$R *.DFM}

type

  RGBRec = packed record
    B, G, R: byte;
  end;
  PRGBRec = ^RGBRec;

  TPalette = packed array[0..255] of RGBRec;
  PPalette = ^TPalette;

  // TImageContainer is used to communicate image info in JPeg2000 DLL
  TImageContainer = record
    Width, Height: integer;
    BytesPerLine: integer;
    PixelFormat: integer; // $QP: P is number of planes, Q=0 BGR, Q=1 BGR seperated planes
    Map: PByteArray;
    Palette: PPalette;
    Options: PChar;
  end;
  PImageContainer = ^TImageContainer;

var
  // DLL modules
  HDxf: HModule = 0;
  HDwg: HModule = 0;
  HAvi: HModule = 0;
  HTtf: HModule = 0;
  HJp2: HModule = 0;
  HSvg: HModule = 0;

  // Function mappings
  DllReadDxf: function (FileName: PChar; ErrorText: PChar): THandle; stdcall;
  DllReadDwg: function (FileName: PChar; ErrorText: PChar): THandle; stdcall;
  DllSetBmSizeDXF: function (W: word): boolean; stdcall;
  DllSetBmSizeDWG: function (W: word): boolean; stdcall;
  DllReadAvi: function (FileName: PChar): THandle; stdcall;
  DllReadTTF: function (FileName: PChar): THandle; stdcall;
  DllReadJP2: function (FileName,FileType: PChar; var Image: TImageContainer): integer; stdcall;
  DllFreeJP2: function (var Image: TImageContainer): Integer; stdcall;
  DllReadSvg: function (FileName: PChar): THandle; stdcall;

procedure Load3rdpartyPlugins;
var
  AFolderName: string;
begin
  // Folder with 3rdparty DLLs
  AFolderName := FAppFolder + 'Plugins\';

  // DXF www.cadsofttools.com - CS_DXF.dll
  HDxf := LoadLibrary(PChar(AFolderName + 'CS_DXF.dll'));
  if HDxf <> 0 then begin
    @DllReadDXF := GetProcAddress(HDxf, 'ReadDXF');
    @DllSetBMSizeDXF := GetProcAddress(HDxf, 'SetBMSize');
    if assigned(DllReadDXF) then
      FHasDXFPlugin := True;
  end;

  // DWG www.cadsofttools.com - CS_DWG.dll
  HDwg := LoadLibrary(PChar(AFolderName + 'CS_DWG.dll'));
  if HDwg <> 0 then begin
    @DllReadDWG := GetProcAddress(HDwg, 'ReadDWG');
    @DllSetBMSizeDWG := GetProcAddress(HDwg, 'SetBMSize');
    if assigned(DllReadDWG) then
      FHasDWGPlugin := True;
  end;

  // AVI first frame
  HAvi := LoadLibrary(PChar(AFoldername + 'formatsAVI.dll'));
  if HAvi <> 0 then begin
    @DllReadAVI := GetProcAddress(HAvi, 'ReadAVI');
    if assigned(DllReadAVI) then
      FHasAVIPlugin := True;
  end;

  // TTF impression
  HTtf := LoadLibrary(PChar(AFoldername + 'formatsTTF.dll'));
  if HTtf <> 0 then begin
    @DllReadTTF := GetProcAddress(HTtf, 'ReadTTF');
    if assigned(DllReadTTF) then
      FHasTTFPlugin := True;
  end;

  // JP2
  HJp2 := LoadLibrary(PChar(AFoldername + 'JasPerLib.dll'));
  if HJp2 <> 0 then begin
    @DllReadJP2 := GetProcAddress(HJp2, '?LibLoadImage@@YGHPAD0PAUTImageContainer@@@Z');
    // @DllSaveJP2 := GetProcAddress(HJp2, '?LibSaveImage@@YGHPAD0PAUTImageContainer@@@Z');
    @DllFreeJP2 := GetProcAddress(HJp2, '?LibFreeImage@@YGHPAUTImageContainer@@@Z');
    if assigned(DllReadJP2) then
      FHasJP2Plugin := True;
  end;
  
  HSvg := LoadLibrary(PChar(AFoldername + 'NativeSvg.dll'));
  if HSvg <> 0 then
  begin
    @DllReadSvg := GetProcAddress(HSvg, 'ReadSvg');
    if assigned(@DllReadSvg) then
      FHasSvgPlugin := True;
  end;

end;

procedure Unload3rdPartyPlugins;
begin
  // DXF
  if HDxf <> 0 then begin
    FreeLibrary(HDxf);
    HDxf := 0;
  end;
  // AVI
  if HAvi <> 0 then begin
    FreeLibrary(HAvi);
    HAvi := 0;
  end;
  // TTF
  if HTtf <> 0 then begin
    FreeLibrary(HTtf);
    HTtf := 0;
  end;
  // JP2
  if HJp2 <> 0 then begin
    FreeLibrary(HJp2);
    HJp2 := 0;
  end;
  if HSvg <> 0 then
  begin
    FreeLibrary(HSvg);
  end;
end;

procedure ReadDXF(AFilename: string; var Error: string; Bitmap: TBitmap);
// Load a DXF file using the plugin from www.cadsofttoools.com
var
  BM: THandle;
  P1,P2: PChar;
  M: TMemoryStream;
  Head: TBitmapFileHeader;
  Err: array[Byte] of char;
begin
  // Checks
  if not assigned(DllReadDXF) then exit;
  if not assigned(Bitmap) then exit;
  if not FUseDXFPlugin then exit;

  // Set the maximum size (longest axis) to 800 pixels
  if assigned(DllSetBMSizeDXF) then
    DllSetBMSizeDXF(800);

  // This calls the plugin and reads the DXF file
  BM := DllReadDXF(PChar(AFileName), Err);
  // Check for errors
  if BM = 0 then begin
    Error := Err;
    exit;
  end;
  try
    Head.bfType := $4D42;
    Head.bfSize := GlobalSize(BM) + 14;
    Head.bfReserved1 := 0;
    Head.bfReserved2 := 0;
    Head.bfOffBits := $42;
    P1 := GlobalLock(BM);
    try
      M := TMemoryStream.Create;
      try
	M.Size := Head.bfSize;
	P2 := M.Memory;
	Move(Head, P2^, 14);
	Inc(P2,14);
	Move(P1^, P2^, Head.bfSize-14);
        Bitmap.LoadFromStream(M);
      finally
	M.Free;
      end;
    finally
      GlobalUnlock(BM);
    end;
  finally
    GlobalFree(BM);
  end;
end;

procedure ReadDWG(AFilename: string; var Error: string; Bitmap: TBitmap);
// Load a DWG file using the plugin from www.cadsofttoools.com
var
  BM: THandle;
  P1,P2: PChar;
  M: TMemoryStream;
  Head: TBitmapFileHeader;
  Err: array[Byte] of char;
begin
  // Checks
  if not assigned(DllReadDWG) then exit;
  if not assigned(Bitmap) then exit;
  if not FUseDWGPlugin then exit;

  // Set the maximum size (longest axis) to 800 pixels
  if assigned(DllSetBMSizeDWG) then
    DllSetBMSizeDWG(800);

  // This calls the plugin and reads the DWG file
  BM := DllReadDWG(PChar(AFileName), Err);
  // Check for errors
  if BM = 0 then begin
    Error := Err;
    exit;
  end;
  try
    Head.bfType := $4D42;
    Head.bfSize := GlobalSize(BM) + 14;
    Head.bfReserved1 := 0;
    Head.bfReserved2 := 0;
    Head.bfOffBits := $42;
    P1 := GlobalLock(BM);
    try
      M := TMemoryStream.Create;
      try
	M.Size := Head.bfSize;
	P2 := M.Memory;
	Move(Head, P2^, 14);
	Inc(P2,14);
	Move(P1^, P2^, Head.bfSize-14);
        Bitmap.LoadFromStream(M);
      finally
	M.Free;
      end;
    finally
      GlobalUnlock(BM);
    end;
  finally
    GlobalFree(BM);
  end;
end;

procedure ReadAvi(AFilename: string; Bitmap: TBitmap);
var
  BM: THandle;
  P: pointer;
  M: TMemoryStream;
begin
  // Checks
  if not assigned(DllReadAvi) then exit;
  if not assigned(Bitmap) then exit;
  if not FUseAVIPlugin then exit;

  // Read AVI first frame
  BM := DllReadAVI(PChar(AFilename));
  // Check for errors
  if BM = 0 then exit;
  try
    P := GlobalLock(BM);
    try
      M := TMemoryStream.Create;
      try
	M.Size := GlobalSize(BM);
	Move(P^, M.Memory^, M.Size);
        Bitmap.LoadFromStream(M);
      finally
	M.Free;
      end;
    finally
      GlobalUnlock(BM);
    end;
  finally
    GlobalFree(BM);
  end;
end;

procedure ReadTTF(AFilename: string; Bitmap: TBitmap);
var
  BM: THandle;
  P: pointer;
  M: TMemoryStream;
begin
  // Checks
  if not assigned(DllReadTTF) then exit;
  if not assigned(Bitmap) then exit;
  if not FUseTTFPlugin then exit;

  // Read TTF impression
  BM := DllReadTTF(PChar(AFilename));
  // Check for errors
  if BM = 0 then exit;
  try
    P := GlobalLock(BM);
    try
      M := TMemoryStream.Create;
      try
	M.Size := GlobalSize(BM);
	Move(P^, M.Memory^, M.Size);
        Bitmap.LoadFromStream(M);
      finally
	M.Free;
      end;
    finally
      GlobalUnlock(BM);
    end;
  finally
    GlobalFree(BM);
  end;
end;

procedure ReadJp2(AFilename: string; var Error: string; Bitmap: TBitmap);
// Read a JPeg2000 file using the JasPer DLL
var
  i, AResult, Planes, C, P: integer;
  AImage: TImageContainer;
  AFiletype: string;
  ScanSize, BitsSize: integer;
  Interleaved: boolean;
  AMap: PByteArray;
  SrcPix, DstPix: PByte;
  pal: PLogPalette;
  hpal: HPALETTE;
begin
  AImage.Options := PChar(#0);
  AFileType := copy(ExtractFileExt(AFilename), 2, 255);
  AResult := DllReadJp2(PChar(AFileName), PChar(AFileType), AImage);
  if AResult = 0 then begin
    try
      Planes := AImage.PixelFormat and $0F;
      if Planes > 3 then Planes := 3;
      Interleaved := (AImage.PixelFormat and $F0 = $10) and (Planes > 1);
      case Planes of
      1:    Bitmap.PixelFormat := pf8bit;
      2, 3: Bitmap.PixelFormat := pf24bit;
      else
        Error := 'Unsupported bitmap Format';
        exit;
      end;

      Bitmap.Width  := AImage.Width;
      Bitmap.Height := AImage.Height;
      ScanSize := Planes * AImage.Width;
      BitsSize := Planes * AImage.Width * AImage.Height;

      // if interleaved data then de-interleave first
      if Interleaved then begin
        GetMem(AMap, BitsSize);
        try
          Move(AImage.Map^, AMap^, BitsSize);
          SrcPix := pointer(AMap);
          for C := 0 to Planes - 1 do begin
            DstPix := @AImage.Map^[C];
            for P := 1 to AImage.Width * AImage.Height do begin
              DstPix^ := SrcPix^;
              Inc(SrcPix);
              Inc(DstPix, Planes);
            end;
          end;
        finally
          FreeMem(AMap);
        end;
      end;

      // Palette based images
      if Bitmap.PixelFormat = pf8bit then begin
        // Create correct palette
        GetMem(pal, sizeof(TLogPalette) + sizeof(TPaletteEntry) * 256);
        try
          pal.palVersion := $300;
          pal.palNumEntries := 256;
          if assigned(AImage.Palette) then begin
            // Palette from image
            for i := 0 to 255 do begin
              pal.palPalEntry[i].peRed   := AImage.Palette[i].R;
              pal.palPalEntry[i].peGreen := AImage.Palette[i].G;
              pal.palPalEntry[i].peBlue  := AImage.Palette[i].B;
            end;
          end else begin
            // Grayscale palette
            for i := 0 to 255 do begin
              pal.palPalEntry[i].peRed   := i;
              pal.palPalEntry[i].peGreen := i;
              pal.palPalEntry[i].peBlue  := i;
            end;
          end;
          hpal := CreatePalette(pal^);
          if hpal <> 0 then
            Bitmap.Palette := hpal;
        finally
          FreeMem(pal);
        end;
      end;

      // Image bits
      if (Planes = 1) or (Planes = 3) then begin
        // Copy the bits scanline by scanline
        for i := 0 to Bitmap.Height - 1 do
          Move(AImage.Map^[i * ScanSize], Bitmap.Scanline[i]^, ScanSize);
      end else begin
        // We can do nothing with this
        Error := 'Unsupported pixel Format';
        Bitmap.Width  := 0;
        Bitmap.Height := 0;
        exit;
      end;

      if (AImage.PixelFormat and $0F) > 3 then
        Error := Format('The image contains %d color planes, only 3 were loaded', [AImage.PixelFormat and $0F]);

    finally
      DllFreeJp2(AImage);
    end;
  end else begin
    case AResult of
    2: Error := 'Unable to open file';
    3: Error := 'Error in bitmap data';
    4: Error := 'Invalid pixel Format';
    else
      Error := Format('Error in bitmap data: %d', [AResult]);
    end;
  end;
end;

procedure ReadSvg(AFilename: string; Bitmap: TBitmap);
var
  BM: THandle;
  P: pointer;
  M: TMemoryStream;
begin
  // Checks
  if not assigned(DllReadSvg) then exit;
  if not assigned(Bitmap) then exit;
  if not FUseSvgPlugin then exit;

  // Read Svg
  BM := DllReadSvg(PChar(AFilename));
  // Check for errors
  if BM = 0 then exit;
  try
    P := GlobalLock(BM);
    try
      M := TMemoryStream.Create;
      try
	      M.Size := GlobalSize(BM);
	      Move(P^, M.Memory^, M.Size);
        Bitmap.LoadFromStream(M);
      finally
	      M.Free;
      end;
    finally
      GlobalUnlock(BM);
    end;
  finally
    GlobalFree(BM);
  end;
end;

procedure PluginGlobalVars;
var
  i: integer;
begin
  // Some global variables to set
  FPluginIndexFiles := False;
  FPluginAddFilter := False;
  for i := 0 to glPlugins.Count - 1 do
    with glPlugins[i] do
    begin
      if (Flags and cpcIndexFiles) > 0 then
        FPluginIndexFiles := True;
      if (Flags and cpcAddFilter) > 0 then
        FPluginAddFilter := True;
    end;
end;

function MustIndexCustom(AFile: TsdFile): boolean;
var
  i: integer;
begin
  Result := False;
  if assigned(AFile) then with AFile do begin
    for i := 0 to glPlugins.Count - 1 do
      if (glPlugins[i].Flags and cpcIndexFiles > 0) and
          glPlugins[i].Allowed and
          not assigned(GetProperty(glPlugins[i].PropertyId)) then begin
        Result := True;
        exit;
      end;
  end;
end;

{ TdlgPlugin }

procedure TdlgPlugin.PluginToForm(APlugin: TPlugin);
begin
  FPlugin := APlugin;
  // Setup the form
  with FPlugin do begin
    if length(Location) > 0 then
      fePlugin.Text := Location
    else
      fePlugin.Text := FAppFolder + 'abc*.dll';
  end;
  UpdateControls(Self);
end;

procedure TdlgPlugin.UpdateControls(Sender: TObject);
begin
  //
  with FPlugin do begin
    lblName.Caption    := PluginName;
    lblVersion.Caption := PluginVersion;
    lblStatus.Caption  := Status;
    lblRegTo.Caption := FRegMessage;
    btnAuthorize.Visible := Mode in [cpcModeNotAuth, cpcModeEval];
    btnInfo.Enabled := Connected and assigned(DllShowInfo);
    btnSetup.Enabled := (Mode >= cpcModeEval) and assigned(DllDoSetup);
  end;
end;

{ TPlugin }

procedure TPlugin.Connect(ALocation: string);
var
  AMessage: PChar;
  ADllFolder: string;
begin
  Mode := cpcModeNotLoaded;
  // Load the DLL library
  if FileExists(ALocation) then begin
    Mode := cpcModeNotConnect;
    FLibrary := LoadLibrary(PChar(ALocation));
    if FLibrary <> 0 then begin
      Mode := cpcModeNotAuth;
      FLocation := ALocation;

      // Entry points for this library
      @DllDoAuthorise      := GetProcAddress(FLibrary, 'DoAuthorise');
      @DllDoInit           := GetProcAddress(FLibrary, 'DoInit');
      @DllDoSetup          := GetProcAddress(FLibrary, 'DoSetup');
      @DllFuzzyAuxCompare  := GetProcAddress(FLibrary, 'FuzzyAuxCompare');
      @DllFuzzyCompare     := GetProcAddress(FLibrary, 'FuzzyCompare');
      @DllFuzzyPreAccept   := GetProcAddress(FLibrary, 'FuzzyPreAccept');
      @DllGetCapabilities  := GetProcAddress(FLibrary, 'GetCapabilities');
      @DllGetFilterName    := GetProcAddress(FLibrary, 'GetFilterName');
      @DllGetFilterType    := GetProcAddress(FLibrary, 'GetFilterType');
      @DllGetFuzzyLimit    := GetProcAddress(FLibrary, 'GetFuzzyLimit');
      @DllGetFuzzyLimitStr := GetProcAddress(FLibrary, 'GetFuzzyLimitStr');
      @DllGetPluginName    := GetProcAddress(FLibrary, 'GetPluginName');
      @DllGetPluginVersion := GetProcAddress(FLibrary, 'GetPluginVersion');
      @DllGetPropertyID    := GetProcAddress(FLibrary, 'GetPropertyID');
      @DllIndexByName      := GetProcAddress(FLibrary, 'IndexByName');
      @DllIndexByStream    := GetProcAddress(FLibrary, 'IndexByStream');
      @DllIsAuthorised     := GetProcAddress(FLibrary, 'IsAuthorised');
      @DllShowInfo         := GetProcAddress(FLibrary, 'ShowInfo');

      // Do initialization
      if assigned(DllDoInit) then begin
        ADllFolder := IncludeTrailingPathDelimiter(ExtractFilePath(ALocation));
        DllDoInit(PChar(FAppFolder), PChar(ADllFolder));
        FFlags := GetCapabilities;
        if (FFlags and cpcMustAuthorise) > 0 then begin
          if assigned(DllIsAuthorised) then begin
            Mode := DllIsAuthorised(AMessage);
            FRegMessage := AMessage;
          end;
        end else begin
          Mode := cpcModeOK;
        end;
      end else
        FFlags := 0;
    end;
  end;
end;

procedure TPlugin.Disconnect;
begin
  // Unload DLL
  if FLibrary <> 0 then
    FreeLibrary(FLibrary);
  FLibrary := 0;
  FLocation := '';
end;

function TPlugin.CreateProperty(AItem: TsdItem; S: TStream): TsdProperty;
var
  M: TStream;
  AProp: TprPlugin;
begin
  Result := nil;
  if not assigned(AItem) then exit;
  if not Allowed then exit;

  Result := AItem.GetProperty(PropertyId);
  if assigned(Result) then exit;

  M := TMemoryStream.Create;
  try
    // Get the index
    if assigned(DllIndexByStream) and assigned(S) then
      DllIndexByStream(PChar(AItem.FileName), S, M)
    else
      if assigned(DllIndexByName) then
        DllIndexByName(PChar(AItem.FileName), M);

    AProp := TprPlugin.Create;
    // Copy to property fields
    with AProp do begin
      FPropId := PropertyId;
      SetSize(M.Size);
      M.Position := 0;
      M.Read(FMem^, FSize);
    end;
    AItem.AddProperty(AProp);
    Result := AProp;
  finally
    M.Free;
  end;
end;

function TPlugin.GetAllowed: boolean;
begin
  Result := Mode = cpcModeOK;
end;

function TPlugin.GetConnected: boolean;
begin
  Result := FLibrary <> 0;
end;

function TPlugin.GetFilterName: string;
begin
  Result := '<unknown>';
  if Connected and assigned(DllGetFilterName) then
    Result := DllGetFilterName;
end;

function TPlugin.GetFilterType: integer;
begin
  Result := cpcFilterNormal;
  if Connected and assigned(DllGetFilterType) then
    Result := DllGetFilterType;
end;

function TPlugin.GetCapabilities: word;
begin
  Result := 0;
  if Connected and assigned(DllGetCapabilities)then
    Result := DllGetCapabilities;
end;

function TPlugin.GetFuzzyLimit(ATolerance: integer): integer;
begin
  Result := cDefaultFuzzyLimitByTol[ATolerance];
  if Connected and assigned(DllGetFuzzyLimit) then
    Result := DllGetFuzzyLimit(ATolerance);
end;

function TPlugin.GetFuzzyLimitStr(ATolerance: integer): string;
begin
  Result := IntToStr(GetFuzzyLimit(ATolerance));
  if Connected and assigned(DllGetFuzzyLimitStr) then
    Result := DllGetFuzzyLimitStr(ATolerance);
end;

function TPlugin.GetPluginName: string;
begin
  Result := '<unknown>';
  if Connected and assigned(DllGetPluginName) then
    Result := DllGetPluginName;
end;

function TPlugin.GetPluginVersion: string;
begin
  Result := '<unknown>';
  if Connected and assigned(DllGetPluginVersion) then
    Result := DllGetPluginVersion;
end;

function TPlugin.GetPropertyId: integer;
begin
  Result := -1;
  if Connected and assigned(DllGetPropertyId) then
    Result := DllGetPropertyId;
end;

function TPlugin.GetStatus: string;
begin
  case Mode of
  cpcModeNotLoaded:  Result := 'Not loaded';
  cpcModeNotConnect: Result := 'Not connected';
  cpcModeNotAuth:    Result := 'Must authorise';
  cpcModeEval:       Result := 'Evaluation';
  cpcModeOK:         Result := 'Enabled';
  end;//case
end;

procedure TPlugin.SetLocation(AValue: string);
begin
  if AValue <> FLocation then begin
    if length(FLocation) > 0 then
      Disconnect;
    FLocation := '';
    if length(AValue) > 0 then
      Connect(AValue);
  end;
end;

procedure TPlugin.DoCustomIndex(AItem: TsdItem; S: TStream);
begin
  if (Flags and cpcIndexFiles > 0) and
      not assigned(AItem.GetProperty(PropertyId)) and
      (assigned(DllIndexByStream) or assigned(DllIndexByName)) then begin

    // We must index
    CreateProperty(AItem, S);
  end;
end;

procedure TPlugin.FilterCalculateItem(Sender: TObject; AItem: TsdItem; var Accept: boolean);
// Create the plugin property for AItem if not already there. If succeeded to create
// then set Accept = True
begin
  Accept := assigned(CreateProperty(AItem, nil))
end;

function TPlugin.FilterFuzzycompare(Item1, Item2: TsdItem; Data1, Data2: pointer; Limit: integer): integer;
begin
  if assigned(Data1) and assigned(Data2) and assigned(DllFuzzyCompare) then
    Result := DllFuzzyCompare(TprPlugin(Data1).FMem, TprPlugin(Data1).FSize, TprPlugin(Data2).FMem, TprPlugin(Data2).FSize, Limit)
  else
    Result := Limit + 1;
end;

function TPlugin.FilterFuzzyFilter(Item1, Item2: TsdItem; Limit: integer; var IsEqual: boolean): boolean;
var
  Prop1, Prop2: TsdProperty;
begin
  Result := False;
  if not assigned(Item1) or not assigned(Item2) then exit;
  Prop1 := Item1.GetProperty(PropertyId);
  Prop2 := Item2.GetProperty(PropertyId);
  if not assigned(Prop1) or not assigned(Prop2) then exit;
  if not assigned(DllFuzzyCompare) then exit;

  IsEqual := DllFuzzyCompare(
               TprPlugin(Prop1).FMem, TprPlugin(Prop1).FSize,
               TprPlugin(Prop2).FMem, TprPlugin(Prop2).FSize,
               Limit) <= Limit;

  Result := IsEqual;
  if IsEqual then begin
    if assigned(DllFuzzyAuxCompare) then
      Result := DllFuzzyAuxCompare(PChar(Item1.FileName), PChar(Item2.FileName))
    else
      Result := IsEqual;
  end
end;

function TPlugin.FilterFuzzyPreAccept(Item: TsdItem): boolean;
begin
  Result := False;
  if assigned(DllFuzzyPreAccept) then
    Result := DllFuzzyPreAccept(PChar(Item.FileName));
end;

procedure TPlugin.FilterItemData(Sender: TObject; AItem: TsdItem; var Data: pointer);
// Provide the pointer to the data
begin
  if assigned(AItem) then
    Data := AItem.GetProperty(PropertyId)
  else
    Data := nil;
end;

function TPlugin.HasFilter: boolean;
begin
  Result := (Flags and cpcAddFilter) > 0;
end;

procedure TPlugin.LoadFromIni(AIni: TInifile; ASection: string);
begin
  //
  Location := AIni.ReadString(ASection, 'Location', '');
end;

procedure TPlugin.SaveToIni(AIni: TInifile; ASection: string);
begin
  //
  AIni.WriteString(ASection, 'Location', Location);
end;

{ TPluginList }

function TPluginList.GetItems(Index: integer): TPlugin;
begin
  Result := nil;
  if (Index >= 0) and (Index < Count) then
    Result := Get(Index);
end;

procedure TPluginList.LoadFromIni(AInifile: string);
var
  i, ACount: integer;
  AIni: TIniFile;
  APlugin: TPlugin;
begin
  AIni := TIniFile.Create(AIniFile);
  try
    ACount := AIni.ReadInteger('Plugins', 'Count', 0);
    for i := 0 to ACount - 1 do begin
      APlugin := TPlugin.Create;
      APlugin.LoadFromIni(AIni, Format('Plugin%.2d', [i]));
      Add(APlugin);
    end;
  finally
    AIni.Free;
  end;

  // Redo the global vars
  PluginGlobalVars;
end;

procedure TPluginList.SaveToIni(AInifile: string);
var
  i: integer;
  AIni: TIniFile;
begin
  AIni := TIniFile.Create(AIniFile);
  try
    AIni.WriteInteger('Plugins', 'Count', Count);
    for i := 0 to Count - 1 do
      Items[i].SaveToIni(AIni, Format('Plugin%.2d', [i]));
  finally
    AIni.Free;
  end;
end;

{ TdlgPlugin }

procedure TdlgPlugin.btnLoadClick(Sender: TObject);
begin
  FPlugin.Location := fePlugin.FileName;
  UpdateControls(Sender);
end;

procedure TdlgPlugin.btnAuthorizeClick(Sender: TObject);
var
  AMessage: PChar;
begin
  with FPlugin do begin
    if assigned(DllDoAuthorise) then begin
      Mode := DllDoAuthorise(AMessage);
      FRegMessage := AMessage;
    end;
    UpdateControls(Sender);
  end;
end;

procedure TdlgPlugin.btnInfoClick(Sender: TObject);
begin
  with FPlugin do
    if assigned(DllShowInfo) then
      DllShowInfo;
end;

procedure TdlgPlugin.btnSetupClick(Sender: TObject);
begin
  with FPlugin do
    if assigned(DllDoSetup) then begin
      DllDoSetup(nil);
      Flags := GetCapabilities;
    end;
  // Recalc globals
  PluginGlobalVars;
end;

{ TPrPlugin }

function TprPlugin.GetPropID: word;
begin
  Result := FPropId;
end;

destructor TprPlugin.Destroy;
begin
  SetSize(0);
  inherited;
end;

procedure TprPlugin.SetSize(ASize: integer);
begin
  if ASize <> FSize then begin
    // Free old
    if FSize > 0 then begin
      FreeMem(FMem);
      FMem := nil;
    end;
    // Get new
    if ASize > 0 then
      GetMem(FMem, ASize);
    FSize := ASize;
  end;
end;

procedure TprPlugin.ReadComponents(S: TStream);
var
  ASize: integer;
begin
  inherited;
  S.Read(FPropID, Sizeof(integer));
  S.Read(ASize, Sizeof(integer));
  SetSize(ASize);
  if FSize > 0 then begin
    GetMem(FMem, FSize);
    S.Read(FMem^, FSize);
  end;
end;

procedure TprPlugin.WriteComponents(S: TStream);
begin
  inherited;
  S.Write(FPropID, Sizeof(integer));
  S.Write(FSize, Sizeof(integer));
  if FSize > 0 then begin
    S.Write(FMem^, FSize);
  end;
end;

destructor TPlugin.Destroy;
begin
  Disconnect;
  inherited;
end;

end.
