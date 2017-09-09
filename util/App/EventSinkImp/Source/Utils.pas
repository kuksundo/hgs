//******************************************************************************
//
// EventSinkImp
//
// Copyright © 1999-2000 Binh Ly
// All Rights Reserved
//
// bly@techvanguards.com
// http://www.techvanguards.com
//******************************************************************************
unit Utils;

interface

uses
  Windows;

const
  //help contexts
  HC_MAIN = 1;
  HC_OPTIONS = 2;

function GetAppVersion: string;
function GetVersionInfo (const FileName: string;
  var Major, Minor, Release, Build: integer): boolean;
function GetFileTime (const FileName: string): TDateTime;
procedure DoHelp (Command, Data: integer);

implementation

uses
  Forms, SysUtils, hh;

function GetAppVersion: string;
var
  Major, Minor, Release, Build: integer;
begin
  if GetVersionInfo (Application.ExeName, Major, Minor, Release, Build) then
    Result := Format ('%d.%d', [Major, Minor])
  else
    Result := '';
end;

function GetVersionInfo (const FileName: string;
  var Major, Minor, Release, Build: integer): boolean;
var
  Handle: dword;
  Size: integer;
  Buffer: pointer;
  VerInfo: PVSFixedFileInfo;
  VerInfoSize: Cardinal;
begin
  Result := False;
  Size := GetFileVersionInfoSize (pchar(FileName), Handle);
  if Size <> 0 then
  begin
    GetMem (Buffer, Size);
    try
      GetFileVersionInfo (pchar(FileName), 0, Size, Buffer);
      if VerQueryValue (Buffer, '\', pointer(VerInfo), VerInfoSize) then
      begin
        Major := HiWord (VerInfo.dwFileVersionMS);
        Minor := LoWord (VerInfo.dwFileVersionMS);
        Release := HiWord (VerInfo.dwFileVersionLS);
        Build := LoWord (VerInfo.dwFileVersionLS);
        Result := True;
      end;
    finally
      FreeMem (Buffer);
    end;
  end;
end;

function GetFileTime (const FileName: string): TDateTime;
begin
  Result := FileDateToDateTime (FileAge (FileName));
end;

function IsHtmlHelpInstalled: boolean;
begin
  Result := HHCtrlHandle <> 0;
end;

procedure CheckHtmlHelp;
begin
  if not IsHtmlHelpInstalled then
    raise Exception.Create ('Sorry, HTML Help is not installed on this machine.');
end;

procedure DoHelp (Command, Data: integer);
begin
  case Command of
    HELP_CONTEXT:
    begin
      CheckHtmlHelp;
      HtmlHelp (Application.Handle, pchar(Application.HelpFile),
        HH_HELP_CONTEXT, Data);
    end;

    HELP_QUIT:
    begin
      if IsHtmlHelpInstalled then
        HtmlHelp (0, nil, HH_CLOSE_ALL, 0);
    end;
  end;
end;

end.
