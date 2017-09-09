{-----------------------------------------------------------------------------
 Unit Name: ExitWindowsU
 Author: Tristan Marlow
 Purpose: Exit Windows - Logoff, Restart, Shutdown

 ----------------------------------------------------------------------------
 License
 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU Library General Public License as
 published by the Free Software Foundation; either version 2 of
 the License, or (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU Library General Public License for more details.
 ----------------------------------------------------------------------------

 History: 04/05/2007 - First Release.

-----------------------------------------------------------------------------}
unit ExitWindowsU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms;

type
  TExitParameter = (xpNone, xpLogoff, xpReboot, xpShutdown, xpLockWorkstation);

type
  TOnExitRequest = procedure(ASender: TObject; AExitParameter: TExitParameter;
    var Allow: boolean) of object;

type
  TExitWindows = class(TPersistent)
  private
    FOnInsufficientPrivileges: TNotifyEvent;
    FOnExitRequest: TOnExitRequest;
  protected
  public
    function ExitWindows(AExitParameter: TExitParameter): boolean;
    function LogOff: boolean;
    function Reboot: boolean;
    function Shutdown: boolean;
    function LockWorkStation: boolean;
  published
    property OnInsufficientPrivileges: TNotifyEvent
      Read FOnInsufficientPrivileges Write FOnInsufficientPrivileges;
    property OnExitRequest: TOnExitRequest Read FOnExitRequest Write FOnExitRequest;
  end;

implementation

function TExitWindows.ExitWindows(AExitParameter: TExitParameter): boolean;
var
  TTokenHd:     THandle;
  TTokenPvg:    TTokenPrivileges;
  cbtpPrevious: DWORD;
  rTTokenPvg:   TTokenPrivileges;
  pcbtpPreviousRequired: DWORD;
  tpResult:     boolean;
  RebootParam:  longword;
  AllowExit:    boolean;
const
  SE_SHUTDOWN_NAME = 'SeShutdownPrivilege';
begin
  Result := False;
  RebootParam := 0;
  tpResult    := True;
  AllowExit   := True;
  if (AExitParameter <> xpNone) and (AExitParameter <> xpLockWorkstation) then
  begin
    case AExitParameter of
      xpLogoff: RebootParam   := EWX_LOGOFF or EWX_FORCE;
      xpReboot: RebootParam   := EWX_REBOOT or EWX_FORCE;
      xpShutdown: RebootParam := EWX_SHUTDOWN or EWX_POWEROFF or EWX_FORCE;
    end;
    if Win32Platform = VER_PLATFORM_WIN32_NT then
    begin
      tpResult := OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES or
        TOKEN_QUERY, TTokenHd);
      if tpResult then
      begin
        tpResult     := LookupPrivilegeValue(nil, SE_SHUTDOWN_NAME,
          TTokenPvg.Privileges[0].Luid);
        TTokenPvg.PrivilegeCount := 1;
        TTokenPvg.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
        cbtpPrevious := SizeOf(rTTokenPvg);
        pcbtpPreviousRequired := 0;
        if tpResult then
        begin
          tpResult := Windows.AdjustTokenPrivileges(
            TTokenHd, False, TTokenPvg, cbtpPrevious, rTTokenPvg, pcbtpPreviousRequired);
        end;
      end;
    end;
    if tpResult then
    begin
      if Assigned(FOnExitRequest) then
      begin
        FOnExitRequest(Self, AExitParameter, AllowExit);
      end;
      if AllowExit then
      begin
        Result := ExitWindowsEx(RebootParam, 0);
      end
      else
      begin
        Result := True;
      end;
    end
    else
    begin
      if Assigned(FOnInsufficientPrivileges) then
        FOnInsufficientPrivileges(Self);
      Result := False;
    end;
  end
  else
  begin
    if AExitParameter = xpLockWorkstation then
    begin
      Result := LockWorkStation;
    end;
    if AExitParameter = xpNone then
    begin
      Result := True;
    end;
  end;
end;

function TExitWindows.LogOff: boolean;
begin
  Result := ExitWindows(xpLogoff);
end;

function TExitWindows.Reboot: boolean;
begin
  Result := ExitWindows(xpReboot);
end;

function TExitWindows.Shutdown: boolean;
begin
  Result := ExitWindows(xpShutdown);
end;

function TExitWindows.LockWorkStation: boolean;
type
  TLockWorkStation = function: boolean;
var
  hUser32: HMODULE;
  LockWS:  TLockWorkStation;
begin
  Result  := False;
  hUser32 := GetModuleHandle('USER32.DLL');
  if hUser32 <> 0 then
  begin
    @LockWS := GetProcAddress(hUser32, 'LockWorkStation');
    if @LockWS <> nil then
    begin
      LockWS;
      Result := True;
    end;
  end;
end;


end.

