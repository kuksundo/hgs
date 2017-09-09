{ System depending code for light weight threads.

  This file is part of the Free Pascal run time library.

  Copyright (C) 2008 Mattias Gaertner mattias@freepascal.org

  See the file COPYING.FPC, included in this distribution,
  for details about the copyright.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit MTPCPU;
{$I defines.inc}

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$inline on}

{$ENDIF FPC}


interface


{$IF defined(windows) or defined(Windows32) or defined(Windows64)}
uses winapi.Windows;
{$ELSEIF defined(freebsd) or defined(darwin)}
uses ctypes, sysctl;
{$ELSEIF defined(linux)}
{$linklib c}
uses ctypes;
{$IFEND}

TYPE 

PtrInt = ^integer;


function GetSystemThreadCount: integer;

procedure CallLocalProc(AProc, Frame: Pointer; Param1: PtrInt;
  Param2, Param3: Pointer); //inline;

implementation


{$IFDEF Windows64}
function GetProcessAffinityMask1(hProcess: THandle;
  var lpProcessAffinityMask, lpSystemAffinityMask: uint64): BOOL; stdcall; external kernel32 name 'GetProcessAffinityMask'; 
{$ENDIF Windows64}
{$IFDEF Windows32}
function GetProcessAffinityMask1(hProcess: THandle;
  var lpProcessAffinityMask, lpSystemAffinityMask: DWORD): BOOL; stdcall; external kernel32 name 'GetProcessAffinityMask'; 
{$ENDIF Windows32}

{$IFDEF Linux}
const _SC_NPROCESSORS_ONLN = 83;
function sysconf(i: cint): clong; cdecl; external name 'sysconf';
{$ENDIF}

function GetSystemThreadCount: integer;
// returns a good default for the number of threads on this system
{$IF defined(windows) or defined(Windows32) or defined(Windows64)}
//returns total number of processors available to system including logical hyperthreaded processors
var
  i: Integer;
  {$IFDEF Windows64}
ProcessAffinityMask, SystemAffinityMask: uint64;
{$ENDIF Windows64}
{$IFDEF Windows32}
ProcessAffinityMask, SystemAffinityMask: DWORD;
{$ENDIF Windows32}
  Mask: DWORD;
  SystemInfo: SYSTEM_INFO;
begin
    //can't get the affinity mask so we just report the total number of processors
    GetSystemInfo(SystemInfo);
    Result := SystemInfo.dwNumberOfProcessors;
end;
{$ELSEIF defined(UNTESTEDsolaris)}
  begin
    t = sysconf(_SC_NPROC_ONLN);
  end;
{$ELSEIF defined(freebsd) or defined(darwin)}
var
  mib: array[0..1] of cint;
  len: cint;
  t: cint;
begin
  mib[0] := CTL_HW;
  mib[1] := HW_NCPU;
  len := sizeof(t);
  fpsysctl(pchar(@mib), 2, @t, @len, Nil, 0);
  Result:=t;
end;
{$ELSEIF defined(linux)}
  begin
    Result:=sysconf(_SC_NPROCESSORS_ONLN);
  end;

{$ELSE}
  begin
    Result:=1;
  end;
{$IFEND}

procedure CallLocalProc(AProc, Frame: Pointer; Param1: PtrInt;
  Param2, Param3: Pointer); //inline;
type
  PointerLocal = procedure(_EBP: Pointer; Param1: PtrInt;
                           Param2, Param3: Pointer);
begin
  PointerLocal(AProc)(Frame, Param1, Param2, Param3);
end;

end.

