{.GXFormatter.config=twm}
unit u_dzResourceDllLoader;

interface

uses
  Windows,
  SysUtils,
  Classes,
  Contnrs,
  u_dzTranslator,
  u_dzVersionInfo,
  u_dzCustomDllLoader;

type
  ///<summary> wrapper for the Load/FreeLibrary and GetProcAddress API calls </summary>
  TdzResourceDllLoader = class(TdzCustomDllLoader)
  private
    FKernelHandle: THandle;
    FMyHandle: THandle;
    function GetEntryPoint(const _EntryPoint: string): pointer;
  protected
    ///<summary> Points to the loaded resourcedll </summary>
    FDllHandle: Pointer;
//    ///<summary> Version info of dll </summary>
//    FDllVersion: IFileInfo;
    procedure LoadDll; override;
    procedure UnloadDll; override;
  public
    ///<summary> calls GetEntryPoint and raises ENoEntryPoint if it returns nil
    ///          @param EntryPoint is the name of the entry point to get
    ///          @param DefaultFunc is a function pointer to assign if the entry point cannot be found
    ///                             if it is nil, an ENoEntryPoint exception will be raise in that case.
    ///                             Note: This function pointer must match the calling convention of
    ///                             the entry point and unless the calling convention is cdecl
    ///                             it must also match number of parameters of the entry point.
    ///                             See also the NotSupportedN functions in this unit.
    ///          @returns a pointer to the entry pointer
    ///          @raises ENoEntryPoint on failure </summary>
    function GetProcAddressEx(const _EntryPoint: string; _DefaultFunc: pointer = nil): pointer; overload; override;
    ///<summary> calls GetEntryPoint for MSC mangled entry points and raises ENoEntryPoint if it returns nil
    ///          @param EntryPoint is the name of the entry point to get
    ///          @param DWordParams is the number of DWord parameters of the entry point, used to
    ///                             generate the actual name of the entry point
    ///          @param DefaultFunc is a function pointer to assign if the entry point cannot be found
    ///                             if it is nil, an ENoEntryPoint exception will be raised in that case.
    ///                             Note: This function pointer must match the calling convention of
    ///                             the entry point and unless the calling convention is cdecl
    ///                             it must also match number of parameters of the entry point.
    ///                             See also the NotSupportedN functions in u_dzDllLoader.
    ///          @returns a pointer to the entry pointer
    ///          @raises ENoEntryPoint on failure </summary>
    function GetProcAddressEx(const _EntryPoint: string; _DWordParams: Integer; _DefaultFunc: pointer = nil): pointer; overload; override;
  public
    ///<summary> assumes that the dll has already been loaded and uses the given DllHandle,
    ///          NOTE: The destructor will call FreeLibrary anyway, so make sure you don't
    ///                store the dll handle anywhere else! </summary>
    constructor Create(const _DllName: string; _DllHandle: Pointer); overload;
    ///<summary> tries to load the given dll and raises EDllLoadError if it fails
    ///          @param DllName is the name of the dll to load, can contain absolute path
    ///          @raises EDllLoadError on failure </summary>
    constructor Create(const _DllName: string); overload;
    ///<summary> Generates a TVersionInfo object on demand and returns it </summary>
//    function DllVersion: IFileInfo;
    ///<summary> returns the full path of the dll that has been loaded </summary>
    function DllFilename: string; override;
    ///<summary> Returns a dummy TVersionInfo object </summary>
    function DllVersion: IFileInfo; override;
  end;

implementation

uses
  u_dzMiscUtils;

function _(const _s: string): string; inline;
begin
  Result := dzDGetText(_s, 'dzlib');
end;

{ TdzResourceDllLoader }

type
  TDllEntry = class
    LoadCount: Integer;
    FileName: string;
    Handle: Pointer;
    constructor Create(_FileName: string; _Handle: Pointer);
  end;

var
  FDllList: TObjectList;

constructor TdzResourceDllLoader.Create(const _DllName: string; _DllHandle: Pointer);
begin
  inherited Create;
  FDllName := ChangeFileExt(ExtractFilename(_DllName), '');
  FDllHandle := _DllHandle;
end;

constructor TdzResourceDllLoader.Create(const _DllName: string);
begin
  inherited Create(ChangeFileExt(ExtractFilename(_DllName), ''));
end;

function TdzResourceDllLoader.DllFilename: string;
begin
  Result := '@INMEM@\' + FDllName;
end;

function TdzResourceDllLoader.DllVersion: IFileInfo;
begin
  Result := TDummyFileInfo.Create;
end;

procedure TdzResourceDllLoader.LoadDll;

  procedure ChangeReloc(POrigBase, PBaseTemp, PReloc, PBaseTarget: Pointer; dwRelocSize: DWord);
  type
    TRelocBlock = packed record
      dwAddress: DWord;
      dwSize: DWord;
    end;
    PRelocBlock = ^TRelocBlock;
  var
    pCurrentRelocBlock: PRelocBlock;
    RelocCount: DWord;
    PCurrentStart: PWord;
    i: Integer;
    pRelocAddress: PInteger;
    iDif: Integer;
  begin
    pCurrentRelocBlock := PReloc;
    iDif := Integer(PBaseTarget) - Integer(POrigBase);
    PCurrentStart := Pointer(Integer(PReloc) + 8);
    while (not isBadReadPtr(pCurrentRelocBlock, SizeOf(TRelocBlock))) and
      (not isBadReadPtr(pCurrentStart, SizeOf(Pointer))) and
      (DWord(pCurrentRelocBlock) < DWord(pReloc) + dwRelocSize) do begin
      RelocCount := (pCurrentRelocBlock^.dwSize - 8) div SizeOf(Word);
      for i := 0 to RelocCount - 1 do begin // FI:W528 - i is not used in for loop code
        if (not isBadReadPtr(pCurrentStart, SizeOf(Pointer))) and
          (PCurrentStart^ xor $3000 < $1000) then begin
          pRelocAddress := Pointer(pCurrentRelocBlock^.dwAddress + PCurrentStart^ mod $3000 + DWord(PBaseTemp));
          if (not isBadWritePtr(pRelocAddress, SizeOf(Integer))) then
            pRelocAddress^ := pRelocAddress^ + iDif;
        end;
        PCurrentStart := Pointer(DWord(PCurrentStart) + SizeOf(Word));
      end;
      pCurrentRelocBlock := Pointer(PCurrentStart);
      pCurrentStart := Pointer(DWord(PCurrentStart) + 8);
    end;
  end;

  procedure CreateImportTable(pLibraryHandle, pImportTable: pointer);
  type
    TImportBlock = packed record
      dwCharacteristics: DWord;
      dwTimeDateStamp: DWord;
      dwForwarderChain: DWord;
      dwName: DWord;
      pFirstThunk: Pointer;
    end;
    PImportBlock = ^TImportBlock;
  var
    pIBlock: PImportBlock;
    pThunksRead: PDWord;
    pThunksWrite: PDWord;
    pDllName: PAnsiChar;
    dwLibraryHandle: DWord;
    dwOldProtect: DWord;
  begin
    pIBlock := pImportTable;
    while (not isBadReadPtr(pIBlock, SizeOf(TImportBlock))) and
      (pIBlock^.pFirstThunk <> nil) and (pIBlock^.dwName <> 0) do begin
      pDllName := Pointer(DWord(pLibraryHandle) + DWord(pIBlock^.dwName));
      if (not isBadReadPtr(pDllName, 4)) then begin
        dwLibraryHandle := LoadLibraryA(pDllName);
        pThunksRead := Pointer(DWord(pIBlock^.pFirstThunk) + DWord(pLibraryHandle));
        pThunksWrite := pThunksRead;
        if (DWord(pIBlock^.dwTimeDateStamp) = $FFFFFFFF) then
          pThunksRead := Pointer(DWord(pIBlock^.dwCharacteristics) + DWord(pLibraryHandle));
        while (not isBadReadPtr(pThunksRead, SizeOf(DWord))) and
          (not isBadReadPtr(pThunksWrite, SizeOf(Word))) and
          (pThunksRead^ <> 0) do begin
          if VirtualProtect(pThunksWrite, SizeOf(DWord), PAGE_EXECUTE_READWRITE, dwOldProtect) then begin
            if (DWord(pThunksRead^) and $80000000 <> 0) then
              pThunksWrite^ := DWord(GetProcAddress(dwLibraryHandle, PAnsiChar(pThunksRead^ and $FFFF)))
            else
              pThunksWrite^ := DWord(GetProcAddress(dwLibraryHandle, PAnsiChar(DWord(pLibraryHandle) + pThunksRead^ + SizeOf(Word))));
            VirtualProtect(pThunksWrite, SizeOf(DWord), dwOldProtect, dwOldProtect);
          end;
          Inc(pThunksRead);
          Inc(pThunksWrite);
        end;
      end;
      pIBlock := Pointer(DWord(pIBlock) + SizeOf(TImportBlock));
    end;
  end;

var
  Res, Glob: THandle;
  DllMain: function(dwHandle, dwReason, dwReserved: DWord): DWord; stdcall;
  IDH: PImageDosHeader;
  INH: PImageNtHeaders;
  SEC: PImageSectionHeader;
  dwSecCount: DWord;
  dwmemsize: DWord;
  i: Integer;
  pAll: Pointer;
  DllEntry: TDllEntry;
begin
  FDllHandle := nil;

  for i := FDllList.Count - 1 downto 0 do begin
    DllEntry := FDllList[i] as TDllEntry;
    if SameText(DllEntry.FileName, FDllName) then begin
      DllEntry.LoadCount := DllEntry.LoadCount + 1;
      FDllHandle := DllEntry.Handle;
      Exit; // ---> already loaded
    end;
  end;

  FKernelHandle := GetModuleHandle('kernel32.dll');
  FMyHandle := GetModuleHandle(nil);

  Res := FindResource(FMyHandle, PChar(FDllName), 'RESOURCEDLL');
  if Res = 0 then
    raise EDllLoadError.CreateFmt(_('Could not find RESOURCEDLL "%s"'), [FDllName]);

  Glob := LoadResource(FMyHandle, Res);
  if Glob = 0 then
    raise EDllLoadError.CreateFmt(_('Could not load RESOURCEDLL "%s"'), [FDllName]);

  IDH := LockResource(Glob);
  if not Assigned(IDH) then
    raise EDllLoadError.CreateFmt(_('Could not lock RESOURCEDLL "%s"'), [FDllName]);

  // UnlockFresource and FreeResource are obsolete in Win32

  if (isBadReadPtr(IDH, SizeOf(TImageDosHeader))) or (IDH^.e_magic <> IMAGE_DOS_SIGNATURE) then
    raise EDllLoadError.CreateFmt(_('RESOURCEDLL "%s" is not valid (Check #1)'), [FDllName]);

  INH := pointer(Cardinal(IDH) + cardinal(IDH^._lfanew));
  if (isBadReadPtr(INH, SizeOf(TImageNtHeaders))) or (INH^.Signature <> IMAGE_NT_SIGNATURE) then
    raise EDllLoadError.CreateFmt(_('RESOURCEDLL "%s" is not valid (Check #2)'), [FDllName]);

  SEC := Pointer(Integer(INH) + SizeOf(TImageNtHeaders));
  dwMemSize := INH^.OptionalHeader.SizeOfImage;
  if (dwMemSize = 0) then
    raise EDllLoadError.CreateFmt(_('RESOURCEDLL "%s" is not valid (Check #3)'), [FDllName]);

  pAll := VirtualAlloc(nil, dwMemSize, MEM_COMMIT or MEM_RESERVE, PAGE_EXECUTE_READWRITE);
  if (pAll = nil) then begin
    Exit;
  end;

  dwSecCount := INH^.FileHeader.NumberOfSections;
  CopyMemory(pAll, IDH, DWord(SEC) - DWord(IDH) + dwSecCount * SizeOf(TImageSectionHeader));
  for i := 0 to dwSecCount - 1 do begin // FI:W528 - i is not used in for loop code
    CopyMemory(Pointer(DWord(pAll) + SEC^.VirtualAddress),
      Pointer(DWord(IDH) + DWord(SEC^.PointerToRawData)),
      SEC^.SizeOfRawData);
    SEC := Pointer(Integer(SEC) + SizeOf(TImageSectionHeader));
  end;

  if (INH^.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC].VirtualAddress <> 0) then
    ChangeReloc(Pointer(INH^.OptionalHeader.ImageBase),
      pAll,
      Pointer(DWord(pAll) + INH^.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC].VirtualAddress),
      pAll,
      INH^.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC].Size);
  CreateImportTable(pAll, Pointer(DWord(pAll) + INH^.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT].VirtualAddress));

  @DllMain := Pointer(INH^.OptionalHeader.AddressOfEntryPoint + DWord(pAll));
  if (INH^.OptionalHeader.AddressOfEntryPoint <> 0) then begin
    DllMain(DWord(pAll), DLL_PROCESS_ATTACH, 0);
  end;
  FDllHandle := pAll;

  FDllList.Add(TDllEntry.Create(FDllName, FDllHandle));
end;

procedure TdzResourceDllLoader.UnloadDll;
var
  DllMain: function(dwHandle, dwReason, dwReserved: DWord): DWord; stdcall;
  IDH: PImageDosHeader;
  INH: PImageNtHeaders;
  i: Integer;
  DllEntry: TDllEntry;
begin
  IDH := FDllHandle;
  if (isBadReadPtr(IDH, SizeOf(TImageDosHeader))) or
    (IDH^.e_magic <> IMAGE_DOS_SIGNATURE) then begin
    Exit;
  end;

  INH := pointer(Cardinal(IDH) + cardinal(IDH^._lfanew));
  if (isBadReadPtr(INH, SizeOf(TImageNtHeaders))) or
    (INH^.Signature <> IMAGE_NT_SIGNATURE) then begin
    Exit;
  end;

  @DllMain := Pointer(INH^.OptionalHeader.AddressOfEntryPoint + DWord(IDH));

  for i := FDllList.Count - 1 downto 0 do begin
    DllEntry := (FDllList[i] as TDllEntry);
    if DllEntry.Handle = IDH then begin
      DllEntry.LoadCount := DllEntry.LoadCount - 1;
      if DllEntry.LoadCount = 0 then begin
        if Assigned(DllMain) then
          DllMain(DWord(IDH), DLL_PROCESS_DETACH, 0);

        VirtualFree(IDH, 0, MEM_RELEASE);
        FDllList.Delete(i);
      end;
    end;
  end;
end;

function tdzResourceDllLoader.GetEntryPoint(const _EntryPoint: string): pointer;
var
  NtHeader: PImageNtHeaders;
  DosHeader: PImageDosHeader;
  DataDirectory: PImageDataDirectory;
  ExportDirectory: PImageExportDirectory;
  i: Integer;
  iExportOrdinal: Integer;
  ExportName: string;
  dwPosDot: DWord;
  dwNewmodule: DWord;
  pFirstExportName: Pointer;
  pFirstExportAddress: Pointer;
  pFirstExportOrdinal: Pointer;
  pExportAddr: PDWord;
  pExportNameNow: PDWord;
  pExportOrdinalNow: PWord;
  Idx: Integer;
begin
  Result := nil;
  if (_EntryPoint = '') then
    Exit;

  DosHeader := FDllHandle;
  if (isBadReadPtr(DosHeader, sizeof(TImageDosHeader)) or
    (DosHeader^.e_magic <> IMAGE_DOS_SIGNATURE)) then
    Exit; {Wrong PE (DOS) Header}

  NtHeader := Pointer(DWord(DosHeader^._lfanew) + DWord(DosHeader));
  if (isBadReadPtr(NtHeader, sizeof(TImageNTHeaders)) or
    (NtHeader^.Signature <> IMAGE_NT_SIGNATURE)) then
    Exit; {Wrong PW (NT) Header}

  DataDirectory := @NtHeader^.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT];
  if (DataDirectory = nil) or (DataDirectory^.VirtualAddress = 0) then
    Exit; {Library has no exporttable}

  ExportDirectory := Pointer(DWord(DosHeader) + DWord(DataDirectory^.VirtualAddress));
  if isBadReadPtr(ExportDirectory, SizeOf(TImageExportDirectory)) then
    Exit;

  pFirstExportName := Pointer(DWord(ExportDirectory^.AddressOfNames) + DWord(DosHeader));
  pFirstExportOrdinal := Pointer(DWord(ExportDirectory^.AddressOfNameOrdinals) + DWord(DosHeader));
  pFirstExportAddress := Pointer(DWord(ExportDirectory^.AddressOfFunctions) + DWord(DosHeader));

  iExportOrdinal := -1; {if we dont find the correct ExportOrdinal}
  for i := 0 to ExportDirectory^.NumberOfNames - 1 do {for each export do} begin
    pExportNameNow := Pointer(Integer(pFirstExportName) + SizeOf(Pointer) * i);
    if (not isBadReadPtr(pExportNameNow, SizeOf(DWord))) then begin
      ExportName := string(PAnsiChar(pExportNameNow^ + DWord(DosHeader)));

      if Pos('@', _EntryPoint) = 0 then begin
        Idx := Pos('@', ExportName);
        if idx > 0 then begin
          ExportName := Copy(ExportName, 1, idx - 1);
          Idx := Pos('_', ExportName);
          if Idx = 1 then
            ExportName := Copy(ExportName, 2);
        end;
      end;

      if (ExportName = _EntryPoint) then {is it the export we search? Calculate the ordinal.} begin
        pExportOrdinalNow := Pointer(Integer(pFirstExportOrdinal) + SizeOf(Word) * i);
        if (not isBadReadPtr(pExportOrdinalNow, SizeOf(Word))) then
          iExportOrdinal := pExportOrdinalNow^;
      end;
    end;
  end;

  if (iExportOrdinal < 0) or (iExportOrdinal > Integer(ExportDirectory^.NumberOfFunctions)) then
    Exit; {havent found the ordinal}

  pExportAddr := Pointer(iExportOrdinal * 4 + Integer(pFirstExportAddress));
  if (isBadReadPtr(pExportAddr, SizeOf(DWord))) then
    Exit;

  {Is the Export outside the ExportSection? If not its NT specific forwared function}
  if (pExportAddr^ < DWord(DataDirectory^.VirtualAddress)) or
    (pExportAddr^ > DWord(DataDirectory^.VirtualAddress + DataDirectory^.Size)) then begin
    if (pExportAddr^ <> 0) then {calculate export address}
      Result := Pointer(pExportAddr^ + DWord(DosHeader));
  end else begin {forwarded function (like kernel32.EnterCriticalSection -> NTDLL.RtlEnterCriticalSection)}
    ExportName := string(PAnsiChar(LongWord(FDllHandle) + pExportAddr^));
    dwPosDot := Pos('.', ExportName);
    if (dwPosDot > 0) then begin
      dwNewModule := GetModuleHandle(PChar(Copy(ExportName, 1, dwPosDot - 1)));
      if (dwNewModule = 0) then
        dwNewModule := LoadLibrary(PChar(Copy(ExportName, 1, dwPosDot - 1)));
      if (dwNewModule <> 0) then
        Result := GetProcAddress(dwNewModule, PChar(Copy(ExportName, dwPosDot + 1, Length(ExportName))));
    end;
  end;
end;

function TdzResourceDllLoader.GetProcAddressEx(const _EntryPoint: string;
  _DWordParams: Integer; _DefaultFunc: pointer): pointer;
begin
  Result := GetProcAddressEx(_EntryPoint, _DefaultFunc)
end;

function TdzResourceDllLoader.GetProcAddressEx(const _EntryPoint: string;
  _DefaultFunc: pointer): pointer;
var
  ErrCode: LongWord;
begin
  Result := GetEntryPoint(_EntryPoint);
  if not Assigned(Result) then begin
    if Assigned(_DefaultFunc) then
      Result := _DefaultFunc
    else begin
      ErrCode := GetLastError;
      RaiseLastOsErrorEx(ErrCode, Format(_('Could not find entry point %s in %s'#13#10'ERROR= %%d, %%s'), [_EntryPoint, FDllName]));
    end;
  end;
end;

{ TDllEntry }

constructor TDllEntry.Create(_FileName: string; _Handle: Pointer);
begin
  LoadCount := 1;
  FileName := _FileName;
  Handle := _Handle;
end;

initialization
  FDllList := TObjectList.Create;

finalization
  FreeAndNil(FDllList);

end.

