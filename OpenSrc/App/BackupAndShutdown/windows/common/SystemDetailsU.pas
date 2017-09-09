{ -----------------------------------------------------------------------------
  Unit Name: SystemDetailsU
  Author: Tristan Marlow
  Purpose: Provides common system detail routines.

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

  ----------------------------------------------------------------------------- }
unit SystemDetailsU;

interface

uses
  CommonU,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Forms,
  Dialogs, Buttons, ExtCtrls, Registry, WinSock;

type
  TOperatingSystem = (osUnknown, osWin95, osWin98, osWin98SE, osWinME, osWinNT,
    osWin2K, osWinXP, osWinVista, osWinSeven, osWin8, osWin81, osWin10);

function GetTempFolder: string;
function GetTempFile(APrefix: string): string;
function GetNetworkIPAddress: string;
function GetNetworkUserName: string;
function GetNetworkComputerName: string;
function GetWindowsVersion: TOperatingSystem;
procedure GetInstalledSoftwareList(ASoftwareList: TStrings);

implementation

uses
  IdStack;

function GetTempFolder: string;
var
  Buffer: array [0 .. MAX_PATH] of char;
begin
  GetTempPath(MAX_PATH, Buffer);
  Result := IncludeTrailingPathDelimiter(Buffer);
end;

function GetTempFile(APrefix: string): string;
var
  Temp: array [0 .. MAX_PATH] of char;
begin
  GetTempFilename(PChar(GetTempFolder), PChar(APrefix), 0, Temp);
  Result := string(Temp);
end;

function GetNetworkIPAddress: string;
begin
  Result := '';
  TIdStack.IncUsage;
  try
    if Assigned(GStack) then
    begin
      Result := StripExtraSpaces(GStack.LocalAddress, True, False);
    end;
  finally
    TIdStack.DecUsage;
  end;
  if IsEmptyString(Result) then
  begin
    Result := '127.0.0.1';
  end;
end;

function GetNetworkUserName: string;
const
  cnMaxUserNameLen = 254;
var
  sUserName: string;
  dwUserNameLen: DWORD;
begin
  dwUserNameLen := 253;
  SetLength(sUserName, 254);
  GetUserName(PChar(sUserName), dwUserNameLen);
  SetLength(sUserName, dwUserNameLen);
  Result := sUserName;
end;

function GetNetworkComputerName: string;
var
  lpBuffer: PWideChar; // lpstr;
  success: Boolean;
  nSize: DWORD;
begin
  nSize := 255;
  Result := '';
  GetMem(lpBuffer, 255);
  try
    success := GetComputerName(lpBuffer, nSize);
    if success then
      Result := StrPas(lpBuffer)
    else
      Result := '';
  finally
    FreeMem(lpBuffer);
  end;
end;

function GetNetworkIPList: TStrings;
begin
  Result := TStringList.Create;
  TIdStack.IncUsage;
  try
    if Assigned(GStack) then
    begin
      Result.Add(StripExtraSpaces(GStack.LocalAddresses.Text, True, False));
    end;
  finally
    TIdStack.DecUsage;
    Result.Add('127.0.0.1');
  end;
end;

function GetWindowsVersion: TOperatingSystem;
var
  osVerInfo: Windows.TOSVersionInfo;
  majorVersion, minorVersion: integer;
begin
  Result := osUnknown;
  osVerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  if Windows.GetVersionEx(osVerInfo) then
  begin
    minorVersion := osVerInfo.dwMinorVersion;
    majorVersion := osVerInfo.dwMajorVersion;
    case osVerInfo.dwPlatformId of
      VER_PLATFORM_WIN32_NT:
        begin
          if majorVersion <= 4 then
            Result := osWinNT
          else if (majorVersion = 5) and (minorVersion = 0) then
            Result := osWin2K
          else if (majorVersion = 5) and (minorVersion = 1) then
            Result := osWinXP
          else if (majorVersion = 6) and (minorVersion = 0) then
            Result := osWinVista
          else if (majorVersion = 6) and (minorVersion = 1) then
            Result := osWinSeven
          else if (majorVersion = 6) and (minorVersion = 2) then
            Result := osWin8
          else if (majorVersion = 6) and (minorVersion = 3) then
            Result := osWin81
          else if (majorVersion = 10) and (minorVersion = 2) then
            Result := osWin10;
        end;
      VER_PLATFORM_WIN32_WINDOWS:
        begin
          if (majorVersion = 4) and (minorVersion = 0) then
            Result := osWin95
          else if (majorVersion = 4) and (minorVersion = 10) then
          begin
            if osVerInfo.szCSDVersion[1] = 'A' then
              Result := osWin98SE
            else
              Result := osWin98;
          end
          else if (majorVersion = 4) and (minorVersion = 90) then
            Result := osWinME
          else
            Result := osUnknown;
        end;
    end;
  end;
end;

procedure GetInstalledSoftwareList(ASoftwareList: TStrings);

const
  CLAVE = '\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';

var
  reg: TRegistry;
  Lista: TStringList;
  Listb: TStringList;
  i, n: integer;

begin
  reg := TRegistry.Create;
  Lista := TStringList.Create;
  Listb := TStringList.Create;
  try
    ASoftwareList.Clear;

    with reg do
    begin
      RootKey := HKEY_LOCAL_MACHINE;
      OpenKeyReadOnly(CLAVE);
      GetKeyNames(Lista);
    end;

    for i := 0 to Lista.Count - 1 do
    begin
      Application.ProcessMessages;
      reg.OpenKeyReadOnly(CLAVE + '\' + Lista.Strings[i]);
      reg.GetValueNames(Listb);
      n := Listb.IndexOf('DisplayName');
      if (n <> -1) and (Listb.IndexOf('UninstallString') <> -1) then
      begin
        ASoftwareList.Add(reg.ReadString(Listb.Strings[n]));
      end;
    end;
  finally
    Lista.Free;
    Listb.Free;
    reg.CloseKey;
    reg.Destroy;
  end;
end;

end.
