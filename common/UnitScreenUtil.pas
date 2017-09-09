unit UnitScreenUtil;

interface

uses
   Forms, SysUtils, Windows, Classes;

const
   MaxVideoModes = 200;

type
   TResolution = 0..MaxVideoModes;
   TAspectRatio = (ar_4v3, ar_15v9, ar_16v10, ar_Other);

   TVideoMode = packed record
      Width: Word;
      Height: Word;
      ColorDepth: Byte;
      MaxFrequency: Byte;
      AspectRatio: TAspectRatio;
      Description: string;
   end;
   PVideoMode = ^TVideoMode;

   TScreenSettings = class
   private
      procedure TryToAddToVideoModeList(deviceMode: TDevMode);

      function FGetCurrentVideoMode: TVideoMode;
      function FGetDefaultVideoMode: TVideoMode;
      function FGetProperWindowedMode(AspectRatio: TAspectRatio): TVideoMode;

      function GetAspectRatio(Width, Height: Integer): TAspectRatio;
   public
      vVideoModes: array of TVideoMode;
      vNumberVideoModes: Integer;
      vCurrentVideoMode: Integer;
      vProperWindowedModes: array[ar_4v3..ar_16v10] of TVideoMode;

      procedure LoadSettings;
      procedure SaveSettings;
      procedure SettinsChanged;
      procedure ApplyDefaultSettings;
      procedure ApplySettings;

      procedure ReadVideoModes;
      procedure RestoreDefaultMode;
      procedure SetProperWindowedMode;
      function GetIndexFromResolution(XRes, YRes, BPP: Integer): TResolution;
      function SetFullscreenMode(ModeIndex: TResolution; displayFrequency: Integer = 0): Boolean;
      function GetResolutionFromDescription(videoModeStr: string): TResolution;
      procedure GetVideoModeList(_AspectRatio: TAspectRatio; _ColorDepth: Integer; List: TStrings);
      procedure ChangePrimaryMonitor(APrimScreenName, ASecondScreenName: string);
      function ChangeMonitorResolution(Index, Width, Height: DWORD): Boolean;

      constructor Create;
      destructor Destroy; override;

      property CurrentVideoMode: TVideoMode read FGetCurrentVideoMode;
      property DefaultVideoMode: TVideoMode read FGetDefaultVideoMode;
      property ProperWindowedModes[Index: TAspectRatio]: TVideoMode read FGetProperWindowedMode;
   end;

implementation

const
   Str_ResolutionFmt = '%dx%d';

   MinResolutionHeight = 480;
   WindowedModeRatio = 0.8;

   _vProperWindowedModesSize: array[ar_4v3..ar_16v10] of TPoint =
   ((X: 800; Y: 600), (X: 1280; Y: 768), (X: 1280; Y: 800));

   { TScreenSettings }

function FloatEqual(flo1, flo2, ep: Double): Boolean;
begin
  if Abs(flo1 - flo2) < ep then
    Result := True
  else
    Result := False;
end;

procedure TScreenSettings.ApplyDefaultSettings;
begin

end;

procedure TScreenSettings.ApplySettings;
begin

end;

function TScreenSettings.ChangeMonitorResolution(Index, Width,
  Height: DWORD): Boolean;
var
  DeviceMode: TDeviceMode;
  DisplayDevice: TDisplayDevice;
begin
  Result := False;
  ZeroMemory(@DisplayDevice, SizeOf(DisplayDevice));
  DisplayDevice.cb := SizeOf(TDisplayDevice);
  // get the name of a device by the given index
  if EnumDisplayDevices(nil, Index, DisplayDevice, 0) then
  begin
    ZeroMemory(@DeviceMode, SizeOf(DeviceMode));
    DeviceMode.dmSize := SizeOf(TDeviceMode);
    DeviceMode.dmPelsWidth := Width;
    DeviceMode.dmPelsHeight := Height;
    DeviceMode.dmFields := DM_PELSWIDTH or DM_PELSHEIGHT;
    // check if it's possible to set a given resolution; if so, then...
    if (ChangeDisplaySettingsEx(PChar(@DisplayDevice.DeviceName[0]),
      DeviceMode, 0, CDS_TEST, nil) = DISP_CHANGE_SUCCESSFUL)
    then
      // change the resolution temporarily (if you use CDS_UPDATEREGISTRY
      // value for the penultimate parameter, the graphics mode will also
      // be saved to the registry under the user's profile; for more info
      // see the ChangeDisplaySettingsEx reference, dwflags parameter)
      Result := ChangeDisplaySettingsEx(PChar(@DisplayDevice.DeviceName[0]),
        DeviceMode, 0, 0, nil) = DISP_CHANGE_SUCCESSFUL;
  end;
end;

procedure TScreenSettings.ChangePrimaryMonitor(APrimScreenName, ASecondScreenName: string);
var
  DevMode1,DevMode2: TDeviceMode;
  tmpx,tmpy : DWORD;
  flags: integer;
begin
  // get current display settings
  EnumDisplaySettings(nil, 0, DevMode1);
  EnumDisplaySettings(nil, 1, DevMode2);

  // move old primary display to new position
  DevMode1.dmFields := DM_POSITION;
  tmpx := DevMode2.dmPelsWidth;
  tmpy := 0;
  Move(tmpx, DevMode1.dmOrientation, sizeOf(tmpx));
  Move(tmpy, DevMode1.dmPaperLength, sizeOf(tmpy));
  flags := CDS_UPDATEREGISTRY or CDS_NORESET;
  ChangeDisplaySettingsEx(PChar(ASecondScreenName), DevMode1, 0, flags, nil);//'\\.\DISPLAY1'

//  Win32Check(ChangeDisplaySettingsEx(PChar(AOldPrimaryDevice), DevMode1, 0,
//    CDS_UPDATEREGISTRY or CDS_NORESET, nil)):

  // move old secondary display to (0, 0) and make the primary display
  DevMode2.dmFields := DM_POSITION;
  tmpx := 0;
  tmpy := 0;
//  DevMode2.dmPosition.x := 0;
//  DevMode2.dmPosition.y := 0;
  Move(tmpx, DevMode2.dmOrientation, sizeOf(tmpx));
  Move(tmpy, DevMode2.dmPaperLength, sizeOf(tmpy));
  flags := CDS_UPDATEREGISTRY or CDS_SET_PRIMARY or CDS_NORESET;
  ChangeDisplaySettingsEx(PChar(APrimScreenName), devMode2, 0, flags, nil);//'\\.\DISPLAY2'

//  Win32Check(ChangeDisplaySettingsEx(PChar(ANewPrimaryDevice), DevMode2, 0,
//    CDS_SET_PRIMARY or CDS_UPDATEREGISTRY or CDS_NORESET or DM_DISPLAYFLAGS, nil)):

  // magic ???
  ChangeDisplaySettingsEx(nil, PDeviceMode(0)^, 0, 0, nil);
end;

constructor TScreenSettings.Create;
begin
   vCurrentVideoMode := 0;
   vNumberVideoModes := 0;
   ReadVideoModes;
end;

destructor TScreenSettings.Destroy;
begin
   SetLength(vVideoModes, 0);
   RestoreDefaultMode;
end;

function TScreenSettings.FGetCurrentVideoMode: TVideoMode;
begin
  Result := vVideoModes[vCurrentVideoMode];
end;

function TScreenSettings.FGetDefaultVideoMode: TVideoMode;
begin
  Result := vVideoModes[0];
end;

function TScreenSettings.FGetProperWindowedMode(
  AspectRatio: TAspectRatio): TVideoMode;
begin
  Result := vProperWindowedModes[AspectRatio];
end;

function TScreenSettings.GetAspectRatio(Width, Height: Integer): TAspectRatio;
var
   r: Single;
begin
   r := Width / Height;
   if FloatEqual(r, 4 / 3, 0.01) then
      Result := ar_4v3
   else if FloatEqual(r, 5 / 3, 0.01) then
      Result := ar_15v9
   else if FloatEqual(r, 8 / 5, 0.01) then
      Result := ar_16v10
   else
      Result := ar_Other;
end;

function TScreenSettings.GetIndexFromResolution(XRes, YRes,
  BPP: Integer): TResolution;
// Determines the index of a screen resolution nearest to the
// given values. The returned screen resolution is always greater
// or equal than XRes and YRes or, in case the resolution isn't
// supported, the value 0, which indicates the default mode.
var
   I: Integer;
   XDiff, YDiff, CDiff: Integer;
begin
   ReadVideoModes;
   // prepare result in case we don't find a valid mode
   Result := 0;
   // set differences to maximum
   XDiff := 9999; YDiff := 9999; CDiff := 99;
   for I := 1 to vNumberVideomodes - 1 do
      with vVideoModes[I] do
      begin
         if (Width >= XRes) and ((Width - XRes) <= XDiff)
            and (Height >= YRes) and ((Height - YRes) <= YDiff)
            and (ColorDepth >= BPP) and ((ColorDepth - BPP) <= CDiff) then
         begin
            XDiff := Width - XRes;
            YDiff := Height - YRes;
            CDiff := ColorDepth - BPP;
            Result := I;
         end;
      end;
end;

function TScreenSettings.GetResolutionFromDescription(
  videoModeStr: string): TResolution;
var
   x, y, bpp: Integer;
   p, p2: Integer;
begin
   p := pos('x', videoModeStr);
   p2 := pos(' ', videoModeStr);
   x := StrToInt(Copy(videoModeStr, 1, p - 1));
   y := StrToInt(Copy(videoModeStr, p + 1, p2 - p - 1));
   bpp := StrToInt(Copy(videoModeStr, p2 + 1, 2));

   Result := GetIndexFromResolution(x, y, bpp);
end;

procedure TScreenSettings.GetVideoModeList(_AspectRatio: TAspectRatio;
  _ColorDepth: Integer; List: TStrings);
var
   i: Integer;
begin
   List.Clear;

   for i := 1 to vNumberVideoModes - 1 do
   begin
      with vVideoModes[i] do
      begin
         if (AspectRatio = _AspectRatio)
            and (ColorDepth = _ColorDepth)
            and (Height >= MinResolutionHeight) then
         begin
            List.Add(Description);
         end;
      end;
   end;
end;

procedure TScreenSettings.LoadSettings;
begin

end;

procedure TScreenSettings.ReadVideoModes;
var
   ModeNumber: Integer;
   done: Boolean;
   DeviceMode: TDevMode;
   DeskDC: HDC;
   AR: TAspectRatio;
begin
   if vNumberVideoModes > 0 then
      Exit;

   SetLength(vVideoModes, MaxVideoModes);
   vNumberVideoModes := 1;

   // prepare 'default' entry
   DeskDC := GetDC(0);
   with vVideoModes[0] do
   try
      ColorDepth := GetDeviceCaps(DeskDC, BITSPIXEL) * GetDeviceCaps(DeskDC, PLANES);
      Width := Screen.Width;
      Height := Screen.Height;
      Description := Format(Str_ResolutionFmt, [Width, Height]);
      AspectRatio := GetAspectRatio(Width, Height);
   finally
      ReleaseDC(0, DeskDC);
   end;

   // enumerate all available video modes
   ModeNumber := 0;
   repeat
      done := not EnumDisplaySettings(nil, ModeNumber, DeviceMode);
      TryToAddToVideoModeList(DeviceMode);
      Inc(ModeNumber);
   until (done or (vNumberVideoModes >= MaxVideoModes));

   //获得所有窗口下的合适显示模式
   for AR := ar_4v3 to ar_16v10 do
   begin
      with vProperWindowedModes[AR] do
      begin
         Width := Round(_vProperWindowedModesSize[AR].X * WindowedModeRatio);
         Height := Round(_vProperWindowedModesSize[AR].Y * WindowedModeRatio);
         ColorDepth := 32;
         MaxFrequency := 100;
         AspectRatio := AR;
         Description := Format(Str_ResolutionFmt, [Width, Height]);
      end;
   end;
end;

procedure TScreenSettings.RestoreDefaultMode;
var
  t: PDevMode;
begin
  t := nil;
  ChangeDisplaySettings(t^, CDS_FULLSCREEN);
  vCurrentVideoMode := 0;
end;

procedure TScreenSettings.SaveSettings;
begin

end;

function TScreenSettings.SetFullscreenMode(ModeIndex: TResolution;
  displayFrequency: Integer): Boolean;
var
   deviceMode: TDevMode;
begin
  ReadVideoModes;
  FillChar(deviceMode, SizeOf(deviceMode), 0);

  with deviceMode do
  begin
    dmSize := SizeOf(DeviceMode);
    dmBitsPerPel := vVideoModes[ModeIndex].ColorDepth;
    dmPelsWidth := vVideoModes[ModeIndex].Width;
    dmPelsHeight := vVideoModes[ModeIndex].Height;
    dmFields := DM_BITSPERPEL or DM_PELSWIDTH or DM_PELSHEIGHT;

    if displayFrequency > 0 then
    begin
      dmFields := dmFields or DM_DISPLAYFREQUENCY;
      if displayFrequency > vVideoModes[ModeIndex].MaxFrequency then
        displayFrequency := vVideoModes[ModeIndex].MaxFrequency;
      dmDisplayFrequency := displayFrequency;
    end;
  end;

  Result := ChangeDisplaySettings(deviceMode, CDS_FULLSCREEN) = DISP_CHANGE_SUCCESSFUL;
  if Result then
    vCurrentVideoMode := ModeIndex;
end;

procedure TScreenSettings.SetProperWindowedMode;
begin
end;

procedure TScreenSettings.SettinsChanged;
begin

end;

procedure TScreenSettings.TryToAddToVideoModeList(deviceMode: TDevMode);
var
   i: Integer;
   vm: PVideoMode;
begin
   // See if this is a duplicate mode (can happen because of refresh
   // rates, or because we explicitly try all the low-res modes)
   for i := 1 to vNumberVideoModes - 1 do
      with DeviceMode do
      begin
         vm := @vVideoModes[i];
         if ((dmBitsPerPel = vm.ColorDepth)
            and (dmPelsWidth = vm.Width)
            and (dmPelsHeight = vm.Height)) then
         begin
         // it's a duplicate mode, higher frequency?
            if dmDisplayFrequency > vm.MaxFrequency then
               vm.MaxFrequency := dmDisplayFrequency;
            Exit;
         end;
      end;

   // do a mode set test (doesn't actually do the mode set, but reports whether it would have succeeded).
   if ChangeDisplaySettings(DeviceMode, CDS_TEST or CDS_FULLSCREEN) <> DISP_CHANGE_SUCCESSFUL then
      Exit;

   // it's a new, valid mode, so add this to the list
   vm := @vVideoModes[vNumberVideoModes];
   with DeviceMode do
   begin
      vm.ColorDepth := dmBitsPerPel;
      vm.Width := dmPelsWidth;
      vm.Height := dmPelsHeight;
      vm.MaxFrequency := dmDisplayFrequency;
      vm.Description := Format(Str_ResolutionFmt, [dmPelsWidth, dmPelsHeight]);
      vm.AspectRatio := GetAspectRatio(vm.Width, vm.Height);
   end;
   Inc(vNumberVideomodes);
end;

end.
