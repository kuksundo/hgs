unit cmem;

//{$mode objfpc}

interface


Function scalable_getmem(Size : nativeUInt) : Pointer;cdecl;external 'tbbmalloc' name 'scalable_malloc';
Procedure scalable_freemem(P : Pointer); cdecl; external 'tbbmalloc' name 'scalable_free';
function scalable_realloc(P : Pointer; Size : NativeUInt) : pointer; cdecl;external 'tbbmalloc' name 'scalable_realloc';

implementation
{$IFDEF FreePascal}
Function CGetMem  (Size : NativeUint) : Pointer;
{$ENDIF}
{$IFDEF XE}
Function CGetMem  (Size : NativeInt) : Pointer;
{$ENDIF}
{$IFDEF Delphi}
Function CGetMem  (Size : NativeInt) : Pointer;
{$ENDIF}

begin
  result:=scalable_getmem(Size);
end;

{$IFDEF FreePascal}
Function CFreeMem (P : pointer) : NativeUInt;
{$ENDIF}
{$IFDEF XE}
Function CFreeMem (P : pointer) : integer;
{$ENDIF}
{$IFDEF Delphi}
Function CFreeMem (P : pointer) : NativeInt;
{$ENDIF}


begin
  scalable_freemem(P);
  Result:=0;
end;

{$IFDEF FreePascal}
Function CReAllocMem (var p:pointer;Size:NativeUInt):Pointer;
{$ENDIF}
{$IFDEF XE}
Function CReAllocMem (p:pointer;Size:NativeInt):Pointer;
{$ENDIF}
{$IFDEF Delphi}
Function CReAllocMem (p:pointer;Size:NativeInt):Pointer;
{$ENDIF}


begin
  Result:=scalable_realloc(p,size);
end;

{$IFDEF FreePascal}
Function CAllocMem(Size : NativeUint) : Pointer;
{$ENDIF}
{$IFDEF XE}
Function CAllocMem(Size : NativeInt) : Pointer;
{$ENDIF}
{$IFDEF Delphi}
Function CAllocMem(Size : NativeInt) : Pointer;
{$ENDIF}

begin
  result:=scalable_getmem(Size);
if Assigned(Result) then
  FillChar(Result^, Size, 0);
end;

function RegisterUnregisterExpectedMemoryLeak(P: Pointer): Boolean; inline;
begin
  Result := False;
end;

Const
 CMemoryManager : TMemoryManagerEx =
    (
      GetMem : CGetmem;
      FreeMem : CFreeMem;
      //FreememSize : CFreememSize;
      ReallocMem : CReAllocMem;
      AllocMem : CAllocMem;
      //MemSize : CMemSize;
      //MemAvail : CMemAvail;
      //MaxAvail : MaxAvail;
      //HeapSize : CHeapSize;
      RegisterExpectedMemoryLeak: RegisterUnregisterExpectedMemoryLeak;
      UnregisterExpectedMemoryLeak: RegisterUnregisterExpectedMemoryLeak
    );

Var
  OldMemoryManager : TMemoryManagerEx;

Initialization
  GetMemoryManager (OldMemoryManager);
  SetMemoryManager (CmemoryManager);

Finalization
  SetMemoryManager (OldMemoryManager);
end.
