{ -----------------------------------------------------------------------------
  Unit Name: CommonU
  Author: Tristan Marlow
  Purpose: Common Objects

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
unit CommonU;

interface

uses
  Windows, Forms, SysUtils, Variants, Classes, SyncObjs,
  ShellAPI, SHFolder, Registry;

type
  TOnLog = procedure(ASender: TObject; AMessage: string) of object;
  TOnDebug = procedure(ASender: TObject; AProcedure, AMessage: string)
    of object;
  TOnProgress = procedure(ASender: TObject; AMessage: string;
    AProgress: integer) of object;

  TOnQuickFileSearchProgress = procedure(AMessage: string; AProgress: integer;
    var ACancel: boolean) of object;

type
  TThreadTimer = class(TThread)
    FActive: boolean;
    FOnTimer: TNotifyEvent;
    FTimeout: integer;
    procedure SyncOnTimer;
  public
    constructor Create(AOnTimer: TNotifyEvent; ATimeout: integer = 1000);
    destructor Destroy; override;
    procedure Execute; override;
  end;

function IsDelphiRunning: boolean;
function IsSystemX64: boolean;
procedure QuickFileSearch(const APathName, AFileName: string;
  const ARecurse: boolean; FileList: TStrings;
  AOnProgress: TOnQuickFileSearchProgress);
function GetApplicationDir: string;
function GetShellFolderPath(AFolder: integer): string;
function GetUserAppDataDir: string;
function GetCommonAppDataDir: string;
function GetTempFolder: string;
function GetTempFile(APrefix: string; AExtension: string = '.tmp'): string;
function CheckDirectoryExists(ADirectory: string; ACreate: boolean): boolean;
function IsValidFileName(AFileName: TFileName): boolean;
function ExecuteFile(const Operation, FileName, Params, DefaultDir: string;
  ShowCmd: word): integer;
function GetAssociatedApplication(AExtension: string): string;
function OpenDefaultAssociatedApplication(AFileName: string;
  APrint: boolean = False): boolean;
procedure OpenDefaultBrowser(AURL: string);
procedure OpenDefaultMailClient(ARecipient: string; ASubject: string = '');
function StripExtraSpaces(AValue: string; ARemoveTab: boolean = False;
  ARemoveCRLF: boolean = False): string;
function IsEmptyString(AValue: string): boolean;

implementation

// TThreadTimer

constructor TThreadTimer.Create(AOnTimer: TNotifyEvent;
  ATimeout: integer = 1000);
begin
  FOnTimer := AOnTimer;
  FTimeout := ATimeout;
  inherited Create(False);
  FreeOnTerminate := True;
end;

destructor TThreadTimer.Destroy;
begin
  FActive := False;
  inherited;
end;

procedure TThreadTimer.SyncOnTimer;
begin
  if Assigned(FOnTimer) and (FActive) then
  begin
    try
      FOnTimer(Self);
    except
    end;
  end;
end;

procedure TThreadTimer.Execute;
begin
  FActive := True;
  while (not Terminated) do
  begin
    try
      if not Terminated then
      begin
        Synchronize(SyncOnTimer);
      end;
      WaitForSingleObject(Self.Handle, FTimeout);
    except

    end;
  end;
end;

function IsDelphiRunning: boolean;
begin
{$WARN SYMBOL_PLATFORM OFF}
  Result := DebugHook <> 0;
{$WARN SYMBOL_PLATFORM ON}
end;

function IsSystemX64: boolean;
type
  TIsWow64Process = function(Handle: THandle; var Res: BOOL): BOOL; stdcall;
var
  IsWow64Result: BOOL;
  IsWow64Process: TIsWow64Process;
begin
  IsWow64Process := Windows.GetProcAddress(GetModuleHandle('kernel32'),
    'IsWow64Process');
  if Assigned(IsWow64Process) then
  begin
    if not IsWow64Process(GetCurrentProcess, IsWow64Result) then
      raise Exception.Create('Bad process handle');
    Result := not IsWow64Result;
  end
  else
    Result := True;
end;

procedure QuickFileSearch(const APathName, AFileName: string;
  const ARecurse: boolean; FileList: TStrings;
  AOnProgress: TOnQuickFileSearchProgress);
var
  Rec: TSearchRec;
  Path: string;
  Cancel: boolean;
begin
  Path := IncludeTrailingPathDelimiter(APathName);
  Cancel := False;
  if FindFirst(Path + AFileName, faAnyFile - faDirectory, Rec) = 0 then
    try
      repeat
        FileList.Add(Path + Rec.Name);
        if Assigned(AOnProgress) then
          AOnProgress(IncludeTrailingPathDelimiter(APathName) + Rec.Name,
            0, Cancel);
      until (FindNext(Rec) <> 0) or (Cancel = True);
    finally
      FindClose(Rec);
    end;

  if (ARecurse) and (Cancel = False) then
  begin
    if FindFirst(Path + '*.*', faDirectory, Rec) = 0 then
      try
        repeat
          if (Rec.Attr = faDirectory) and (Rec.Name <> '.') and
            (Rec.Name <> '..') then
          begin
            if Assigned(AOnProgress) then
              AOnProgress(IncludeTrailingPathDelimiter(APathName) + Rec.Name,
                0, Cancel);
            QuickFileSearch(Path + Rec.Name, AFileName, True, FileList,
              AOnProgress);
          end;
        until (FindNext(Rec) <> 0) or (Cancel = True);
      finally
        FindClose(Rec);
      end;
  end;
end;

function GetApplicationDir: string;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
end;

function GetShellFolderPath(AFolder: integer): string;
const
  SHGFP_TYPE_CURRENT = 0;
var
  Path: array [0 .. MAX_PATH] of char;
begin
  if SUCCEEDED(SHGetFolderPath(0, AFolder, 0, SHGFP_TYPE_CURRENT, @Path[0]))
  then
    Result := Path
  else
    Result := '';
end;

function GetUserAppDataDir: string;
begin
  Result := IncludeTrailingPathDelimiter
    (IncludeTrailingPathDelimiter(GetShellFolderPath(CSIDL_APPDATA)) +
    Application.Title);
  CheckDirectoryExists(Result, True);
end;

function GetCommonAppDataDir: string;
begin
  Result := IncludeTrailingPathDelimiter
    (IncludeTrailingPathDelimiter(GetShellFolderPath(CSIDL_COMMON_APPDATA)) +
    Application.Title);
  CheckDirectoryExists(Result, True);
end;

function GetTempFolder: string;
var
  Buffer: array [0 .. MAX_PATH] of char;
begin
  GetTempPath(MAX_PATH, Buffer);
  Result := IncludeTrailingPathDelimiter(Buffer);
end;

function GetTempFile(APrefix: string; AExtension: string = '.tmp'): string;
var
  Attempts: cardinal;

  function RandomFileName(ALength: integer): string;
  var
    str: string;
  begin
    Randomize;
    str := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Result := '';
    repeat
      Result := Result + str[Random(Length(str)) + 1];
    until (Length(Result) = ALength);
  end;

begin
  Attempts := 0;
  repeat
    Result := GetTempFolder + Copy(APrefix, 1, 3) + RandomFileName(5) +
      AExtension;
    Inc(Attempts);
  until (not FileExists(Result)) or (Attempts >= High(cardinal));
  if (Attempts >= High(cardinal)) then
  begin
    raise Exception.Create('Failed to generate temporary file.');
  end;
end;

function CheckDirectoryExists(ADirectory: string; ACreate: boolean): boolean;
begin
  try
    if ACreate then
    begin
      if not DirectoryExists(ADirectory) then
      begin
        ForceDirectories(ADirectory);
      end;
    end;
  finally
    Result := DirectoryExists(ADirectory);
  end;
end;

function IsValidFileName(AFileName: TFileName): boolean;
var
  TestFile: TextFile;
begin
  if not FileExists(AFileName) then
  begin
{$I-}
    AssignFile(TestFile, AFileName);
    Rewrite(TestFile);
    CloseFile(TestFile);
{$I+}
    Result := IOResult = 0;
    if FileExists(AFileName) then
      DeleteFile(AFileName);
  end
  else
  begin
    Result := True;
  end;
end;

function ExecuteFile(const Operation, FileName, Params, DefaultDir: string;
  ShowCmd: word): integer;
var
  zFileName, zParams, zDir: array [0 .. 255] of char;
begin
  Result := ShellExecute(Application.Handle, PChar(Operation),
    StrPCopy(zFileName, FileName), StrPCopy(zParams, Params),
    StrPCopy(zDir, DefaultDir), ShowCmd);
end;

function GetAssociatedApplication(AExtension: string): string;
var
  sExtDesc: string;
begin
  Result := '';
  with TRegistry.Create do
  begin
    try
      RootKey := HKEY_CLASSES_ROOT;
      if OpenKeyReadOnly(AExtension) then
      begin
        sExtDesc := ReadString('');
        CloseKey;
      end;
      if sExtDesc <> '' then
      begin
        if OpenKeyReadOnly(sExtDesc + '\Shell\Open\Command') then
        begin
          Result := ReadString('');
        end;
      end;
    finally
      Free;
    end;
  end;

  if Result <> '' then
  begin
    if Result[1] = '"' then
    begin
      Result := Copy(Result, 2, -1 + Pos('"', Copy(Result, 2, MaxINt)));
    end;
  end;
end;

function OpenDefaultAssociatedApplication(AFileName: string;
  APrint: boolean = False): boolean;
var
  Command: string;
begin
  Result := False;
  Command := 'open';
  if APrint then
    Command := 'print';
  if FileExists(AFileName) then
  begin
    if GetAssociatedApplication(ExtractFileExt(AFileName)) <> '' then
    begin
      Result := ExecuteFile('open', AFileName, '', ExtractFilePath(AFileName),
        SW_NORMAL) > 32;
    end;
  end;
end;

procedure OpenDefaultBrowser(AURL: string);
begin
  if (Pos('http', AURL) > 0) or (Pos('mailto', AURL) > 0) then
  begin
    ExecuteFile('open', AURL, '', GetApplicationDir, SW_SHOWNORMAL);
  end;
end;

procedure OpenDefaultMailClient(ARecipient: string; ASubject: string = '');
begin
  OpenDefaultBrowser('mailto:' + ARecipient + '?subject=' + ASubject);
end;

function StripExtraSpaces(AValue: string; ARemoveTab: boolean = False;
  ARemoveCRLF: boolean = False): string;
var
  i: integer;
  Source: string;
begin
  Source := Trim(AValue);

  if ARemoveTab then
    Source := StringReplace(Source, #9, ' ', [rfReplaceAll]);
  if ARemoveCRLF then
  begin
    Source := StringReplace(Source, #10, ' ', [rfReplaceAll]);
    Source := StringReplace(Source, #13, ' ', [rfReplaceAll]);
  end;

  if Length(Source) > 1 then
  begin
    Result := Source[1];
    for i := 2 to Length(Source) do
    begin
      if Source[i] = ' ' then
      begin
        if not(Source[i - 1] = ' ') then
          Result := Result + ' ';
      end
      else
      begin
        Result := Result + Source[i];
      end;
    end;
  end
  else
  begin
    Result := Source;
  end;
end;

function IsEmptyString(AValue: string): boolean;
begin
  Result := Trim(AValue) = '';
end;

end.
