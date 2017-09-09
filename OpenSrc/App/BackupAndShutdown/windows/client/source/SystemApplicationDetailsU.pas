{ -----------------------------------------------------------------------------
  Unit Name: SystemApplicationDetailsU
  Author: Tristan Marlow
  Purpose: Provides details for applications installed

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
unit SystemApplicationDetailsU;

interface

uses
  SystemDetailsU,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Forms, ShlObj,
  Dialogs, Buttons, ExtCtrls, Registry,
  ActiveX, ComObj, SHFolder, System.StrUtils,
  INIFiles;

type
  TEmailApplications = (eaUnknown, eaOutlookExpress, eaOutlook, eaWindowsMail);

type
  TEmailApplicationsSet = set of TEmailApplications;

type
  TBrowserApplications = (baUnknown, baIE, baFirefox, baChrome, baOpera,
    baSafari);

type
  TBrowserApplicationsSet = set of TBrowserApplications;

type
  TSystemApplicationDetails = class(TPersistent)
  private
  protected
  public
    function GetApplicationPath(AFileName: TFileName;
      var APath: string): boolean;
    procedure GetEnvironmentVariables(AVariablesList: TStrings);
    function GetEnvironmentVariable(AVariable: string): string;
    function DecodeEnvironmentVariables(AValue: string): string;
    function GetInstalledApplications(AApplicationList: TStrings): boolean;
    function GetRoamingAppDataFolder: string;
    function GetMyDocumentsFolder: string;
    function GetMyPicturesFolder: string;
    function GetMyMusicFolder: string;
    function GetMyVideoFolder: string;
    function GetDesktopFolder: string;
    function GetFavoritesFolder: string;
    function GetLocalAppDataFolder: string;
    function GetProgramFileFolder: string;
    function GetWindowsFolder: string;
    function GetSystemFolder: string;
    procedure FileSearch(const APathName, AFileName: string;
      const ARecurse: boolean; AFileList: TStrings);
  published
  end;

type
  TEmailApplicationDetails = class(TSystemApplicationDetails)
  private
  protected
    function GetDefaultMailApplicationFromFileName(AFileName: TFileName)
      : TEmailApplications;
    function GetDefaultMailApplication: TEmailApplications;
    function GetInstalledMailApplications: TEmailApplicationsSet;
    function IsOutlookInstalled: boolean;
    function IsOutlookExpressInstalled: boolean;
    function IsWindowsMailInstalled: boolean;
  public
    function GetOutlookDataFiles(AFileList: TStrings): boolean;
    function GetOutlookExpressDataFiles(AFileList: TStrings): boolean;
    function GetWindowsMailDataFolder: string;
    function GetOutlookWindowName: string;
    function GetOutlookExpressWindowName: string;
    function GetWindowsMailName: string;
  published
    property DefaultMailApplication: TEmailApplications
      Read GetDefaultMailApplication;
    property InstalledMailApplications: TEmailApplicationsSet
      Read GetInstalledMailApplications;
  end;

type
  TBrowserApplicationDetails = class(TSystemApplicationDetails)
  private
  protected
    function GetDefaultBrowserApplicationFromFileName(AFileName: TFileName)
      : TBrowserApplications;
    function GetDefaultBrowserApplication: TBrowserApplications;
    function GetInstalledBrowserApplications: TBrowserApplicationsSet;
    function IsFireFoxInstalled: boolean;
    function IsIEInstalled: boolean;
    function IsChromeInstalled: boolean;
    function IsSafariInstalled: boolean;
    function IsOperaInstalled: boolean;
    function GetFirefoxProfileIDFromName(AProfileName: string): string;
  public
    function GetIEFavoritesFolder: string;
    function GetFirefoxProfiles(AProfileList: TStrings): boolean;
    function GetFirefoxBookmarksFileName(AProfile: string): string;
    function GetChromeBookmarksFileName: string;
    function GetSafariBookmarksFileName: string;
    function GetOperaBookmarksFileName: string;
  published
    property DefaultBrowserApplication: TBrowserApplications
      Read GetDefaultBrowserApplication;
    property InstalledBrowserApplications: TBrowserApplicationsSet
      Read GetInstalledBrowserApplications;
  end;

implementation

// TApplicationDetails

function TSystemApplicationDetails.GetApplicationPath(AFileName: TFileName;
  var APath: string): boolean;
var
  Reg: TRegistry;
  FileName: TFileName;
begin
  Result := False;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKeyReadOnly
      ('\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\' + AFileName) then
    begin
      if Reg.ValueExists('') then
      begin
        if Reg.ValueExists('Path') then
        begin
          APath := Reg.ReadString('Path');
        end
        else
        begin
          APath := ExtractFilePath(Reg.ReadString(''));
        end;
        FileName := Reg.ReadString('');
        FileName := StringReplace(FileName, '"', '',
          [rfReplaceAll, rfIgnoreCase]);
        Result := FileExists(FileName);
      end;
      Reg.CloseKey;
    end;

  finally
    Reg.Free;
  end;
end;

procedure TSystemApplicationDetails.GetEnvironmentVariables(AVariablesList
  : TStrings);
var
  Variable: boolean;
  Str: PChar;
  Res: string;
begin
  if Assigned(AVariablesList) then
  begin
    AVariablesList.Clear;
    Str := GetEnvironmentStrings;
    Res := '';
    Variable := False;
    while True do
    begin
      if Str^ = #0 then
      begin
        if Variable then
          AVariablesList.Add(Res);
        Variable := True;
        Inc(Str);
        Res := '';
        if Str^ = #0 then
          Break
        else
          Res := Res + Str^;
      end
      else if Variable then
        Res := Res + Str^;
      Inc(Str);
    end;
  end;
end;

function TSystemApplicationDetails.GetEnvironmentVariable
  (AVariable: string): string;
begin
  Result := SysUtils.GetEnvironmentVariable(AVariable);
end;

function TSystemApplicationDetails.DecodeEnvironmentVariables
  (AValue: string): string;
var
  Variables: TStringList;
  Idx: integer;
begin
  Result := AValue;
  Variables := TStringList.Create;
  try
    GetEnvironmentVariables(Variables);
    for Idx := 0 to Pred(Variables.Count) do
    begin
      Result := StringReplace(Result, '%' + Variables.Names[Idx] + '%',
        Variables.ValueFromIndex[Idx], [rfReplaceAll]);
    end;
  finally
    FreeAndNil(Variables);
  end;

end;

function TSystemApplicationDetails.GetInstalledApplications(AApplicationList
  : TStrings): boolean;
var
  List: TStringList;
  i: integer;
  sVersion: string;
const
  sUninstall = 'Software\Microsoft\Windows\CurrentVersion\UnInstall';
begin
  List := TStringList.Create;
  Result := False;
  try
    with TRegistry.Create do
    begin
      RootKey := HKEY_LOCAL_MACHINE;
      if OpenKeyReadOnly(sUninstall) then
      begin
        GetKeyNames(List);
        CloseKey;

        for i := 0 to List.Count - 1 do
        begin
          if OpenKeyReadOnly(sUninstall + '\' + List[i]) then
          begin
            // collect some info about the installed stuff
            if ValueExists('DisplayVersion') then
              sVersion := 'Version ' + ReadString('DisplayVersion')
            else
              sVersion := '';

            AApplicationList.Add(List[i] + '=' + sVersion);
            CloseKey;
          end;
        end;
      end;
      // free the registry object
      Free;
    end;
  finally
    FreeAndNil(List);
  end;
end;

procedure TSystemApplicationDetails.FileSearch(const APathName,
  AFileName: string; const ARecurse: boolean; AFileList: TStrings);
var
  Rec: TSearchRec;
  Cancel: boolean;
begin
  Cancel := False;
  if FindFirst(IncludeTrailingPathDelimiter(APathName) + AFileName,
    faAnyFile - faDirectory, Rec) = 0 then
    try
      repeat
        AFileList.Add(IncludeTrailingPathDelimiter(APathName) + Rec.Name);
        Application.ProcessMessages;
      until (FindNext(Rec) <> 0) or (Cancel = True);
    finally
      FindClose(Rec);
    end;
  if (ARecurse) and (Cancel = False) then
  begin
    if FindFirst(IncludeTrailingPathDelimiter(APathName) + '*.*', faAnyFile,
      Rec) = 0 then
      try
        repeat
          if ((Rec.Attr and faDirectory) <> 0) and (Rec.Name <> '.') and
            (Rec.Name <> '..') then
          begin
            Application.ProcessMessages;
            FileSearch(IncludeTrailingPathDelimiter(APathName) + Rec.Name,
              AFileName, True, AFileList);
          end;
        until (FindNext(Rec) <> 0) or (Cancel = True);
      finally
        FindClose(Rec);
      end;
  end;
end;

function TSystemApplicationDetails.GetRoamingAppDataFolder: string;
var
  P: PChar;
begin
  Result := '';
  P := StrAlloc(1024);
  if SHGetFolderPath(0, CSIDL_APPDATA, 0, 0, P) = S_OK then
  begin
    Result := IncludeTrailingPathDelimiter(string(P));
  end;
  StrDispose(P);
end;

function TSystemApplicationDetails.GetMyDocumentsFolder: string;
var
  P: PChar;
begin
  Result := '';
  P := StrAlloc(1024);
  if SHGetFolderPath(0, CSIDL_PERSONAL, 0, 0, P) = S_OK then
  begin
    Result := IncludeTrailingPathDelimiter(string(P));
  end;
  StrDispose(P);
end;

function TSystemApplicationDetails.GetMyPicturesFolder: string;
var
  P: PChar;
begin
  Result := '';
  P := StrAlloc(1024);
  if SHGetFolderPath(0, CSIDL_MYPICTURES, 0, 0, P) = S_OK then
  begin
    Result := IncludeTrailingPathDelimiter(string(P));
  end;
  StrDispose(P);
end;

function TSystemApplicationDetails.GetMyMusicFolder: string;
var
  P: PChar;
begin
  Result := '';
  P := StrAlloc(1024);
  if SHGetFolderPath(0, CSIDL_MYMUSIC, 0, 0, P) = S_OK then
  begin
    Result := IncludeTrailingPathDelimiter(string(P));
  end;
  StrDispose(P);
end;

function TSystemApplicationDetails.GetMyVideoFolder: string;
var
  P: PChar;
begin
  Result := '';
  P := StrAlloc(1024);
  if SHGetFolderPath(0, CSIDL_MYVIDEO, 0, 0, P) = S_OK then
  begin
    Result := IncludeTrailingPathDelimiter(string(P));
  end;
  StrDispose(P);
end;

function TSystemApplicationDetails.GetDesktopFolder: string;
var
  P: PChar;
begin
  Result := '';
  P := StrAlloc(1024);
  if SHGetFolderPath(0, CSIDL_DESKTOP, 0, 0, P) = S_OK then
  begin
    Result := IncludeTrailingPathDelimiter(string(P));
  end;
  StrDispose(P);
end;

function TSystemApplicationDetails.GetFavoritesFolder: string;
var
  P: PChar;
begin
  Result := '';
  P := StrAlloc(1024);
  if SHGetFolderPath(0, CSIDL_FAVORITES, 0, 0, P) = S_OK then
  begin
    Result := string(P);
  end;
  StrDispose(P);
end;

function TSystemApplicationDetails.GetLocalAppDataFolder: string;
var
  P: PChar;
begin
  Result := '';
  P := StrAlloc(1024);
  if SHGetFolderPath(0, CSIDL_LOCAL_APPDATA, 0, 0, P) = S_OK then
  begin
    Result := IncludeTrailingPathDelimiter(string(P));
  end;
  StrDispose(P);
end;

function TSystemApplicationDetails.GetProgramFileFolder: string;
var
  P: PChar;
begin
  Result := '';
  P := StrAlloc(1024);
  if SHGetFolderPath(0, CSIDL_PROGRAM_FILES, 0, 0, P) = S_OK then
  begin
    Result := IncludeTrailingPathDelimiter(string(P));
  end;
  StrDispose(P);
end;

function TSystemApplicationDetails.GetWindowsFolder: string;
var
  P: PChar;
begin
  Result := '';
  P := StrAlloc(1024);
  if SHGetFolderPath(0, CSIDL_WINDOWS, 0, 0, P) = S_OK then
  begin
    Result := IncludeTrailingPathDelimiter(string(P));
  end;
  StrDispose(P);
end;

function TSystemApplicationDetails.GetSystemFolder: string;
var
  P: PChar;
begin
  Result := '';
  P := StrAlloc(1024);
  if SHGetFolderPath(0, CSIDL_SYSTEM, 0, 0, P) = S_OK then
  begin
    Result := IncludeTrailingPathDelimiter(string(P));
  end;
  StrDispose(P);
end;

// TEmailApplicationDetails

function TEmailApplicationDetails.GetDefaultMailApplicationFromFileName
  (AFileName: TFileName): TEmailApplications;
var
  FileName: string;
begin
  Result := eaUnknown;
  FileName := StringReplace(AFileName, '"', '', [rfReplaceAll]);
  FileName := ExtractFileName(FileName);
  if Pos('.EXE', FileName) > 0 then
  begin
    // Remove any parameters
    FileName := Copy(FileName, 1, Pos('.EXE', FileName) + 4);
    FileName := Trim(FileName);
    if UpperCase(FileName) = 'OUTLOOK.EXE' then
      Result := eaOutlook;
    if UpperCase(FileName) = 'MSIMN.EXE' then
      Result := eaOutlookExpress;
    if UpperCase(FileName) = 'WINMAIL.EXE' then
      Result := eaWindowsMail;
  end;
end;

function TEmailApplicationDetails.GetDefaultMailApplication: TEmailApplications;
var
  Reg: TRegistry;
begin
  Result := eaUnknown;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CLASSES_ROOT;
    if Reg.OpenKeyReadOnly('\mailto\shell\open\command') then
    begin
      if Reg.ValueExists('') then
      begin
        Result := GetDefaultMailApplicationFromFileName(Reg.ReadString(''));
      end;
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

function TEmailApplicationDetails.IsOutlookInstalled: boolean;
var
  ClassID: TCLSID;
  strOLEObject: string;
begin
  Result := False;
  strOLEObject := 'Outlook.Application';
  if (CLSIDFromProgID(PWideChar(WideString(strOLEObject)), ClassID) = S_OK) then
  begin
    Result := True;
  end;
end;
// var
// Outlook: olevariant;
// begin
// Result := False;
// try
// try
// Outlook := GetActiveOleObject('Outlook.Application');
// except
// try
// Outlook := CreateOleObject('Outlook.Application');
// except
// Result := False;
// end;
// end;
// Result := True;
// finally
// try
// Outlook := Unassigned;
// except
//
// end;
// end;
// end;

function TEmailApplicationDetails.IsOutlookExpressInstalled: boolean;
begin
  Result := GetWindowsVersion in [osWin2K, osWinXP];
end;

function TEmailApplicationDetails.IsWindowsMailInstalled: boolean;
var
  Path: string;
begin
  Result := False;
  case GetWindowsVersion of
    osWinVista, osWinSeven, osWin8, osWin81, osWin10:
      begin
        Result := GetApplicationPath('wlmail.exe', Path);
      end;
  end;
end;

function TEmailApplicationDetails.GetInstalledMailApplications
  : TEmailApplicationsSet;
begin
  Result := [];
  if IsOutlookInstalled then
    Result := Result + [eaOutlook];
  if IsOutlookExpressInstalled then
    Result := Result + [eaOutlookExpress];
  if IsWindowsMailInstalled then
    Result := Result + [eaWindowsMail];
end;

function TEmailApplicationDetails.GetOutlookDataFiles
  (AFileList: TStrings): boolean;
begin
  Result := False;
  AFileList.Clear;
  if IsOutlookInstalled then
  begin
    FileSearch(GetLocalAppDataFolder, '*.pst', True, AFileList);
    FileSearch(GetMyDocumentsFolder, '*.pst', True, AFileList);
    FileSearch(GetRoamingAppDataFolder, '*.nk2', True, AFileList);
    Result := True;
  end;
end;

function TEmailApplicationDetails.GetOutlookExpressDataFiles
  (AFileList: TStrings): boolean;
begin
  Result := False;
  AFileList.Clear;
  if IsOutlookExpressInstalled then
  begin
    FileSearch(GetLocalAppDataFolder, '*.wab', True, AFileList);
    FileSearch(GetLocalAppDataFolder, '*.dbx', True, AFileList);
    Result := True;
  end;
end;

function TEmailApplicationDetails.GetWindowsMailDataFolder: string;
var
  Reg: TRegistry;
  KeyName: string;
begin
  // HKEY_CURRENT_USER\Software\Microsoft\Windows Mail
  // StoreRoot
  Result := '';
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    KeyName := '\Software\Microsoft\Windows Mail';
    if Reg.OpenKeyReadOnly(KeyName) then
    begin
      if Reg.ValueExists('Store Root') then
      begin
        Result := DecodeEnvironmentVariables(Reg.ReadString('Store Root'));
      end;
    end;
    Reg.CloseKey;
  finally
    Reg.Free;
  end;
end;

function TEmailApplicationDetails.GetOutlookWindowName: string;
begin
  Result := '';
end;

function TEmailApplicationDetails.GetOutlookExpressWindowName: string;
begin
  Result := '';
end;

function TEmailApplicationDetails.GetWindowsMailName: string;
begin
  Result := '';
end;



// TBrowserApplicationDetails

function TBrowserApplicationDetails.GetDefaultBrowserApplicationFromFileName
  (AFileName: TFileName): TBrowserApplications;
var
  FileName: string;
begin
  Result := baUnknown;
  FileName := StringReplace(AFileName, '"', '', [rfReplaceAll]);
  FileName := UpperCase(ExtractFileName(FileName));
  if Pos('IEXPLORE.EXE', FileName) > 0 then
    Result := baIE;
  if Pos('FIREFOX.EXE', FileName) > 0 then
    Result := baFirefox;
  if Pos('CHROME.EXE', FileName) > 0 then
    Result := baChrome;
  if Pos('OPERA.EXE', FileName) > 0 then
    Result := baOpera;
  if Pos('SAFARI.EXE', FileName) > 0 then
    Result := baOpera;
end;

function TBrowserApplicationDetails.GetDefaultBrowserApplication
  : TBrowserApplications;
var
  Reg: TRegistry;
  KeyName, ProgID: string;
begin
  Result := baUnknown;
  Reg := TRegistry.Create;
  try
    if not(GetWindowsVersion in [osWin95, osWin98, osWin98SE, osWinME, osWinME,
      osWinNT, osWin2K, osWinXP]) then
    begin
      Reg.RootKey := HKEY_CURRENT_USER;
      KeyName :=
        '\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice';
      if Reg.OpenKeyReadOnly(KeyName) then
      begin
        if Reg.ValueExists('Progid') then
        begin
          ProgID := UpperCase(Reg.ReadString('Progid'));
          Result := baIE;
          if ProgID = 'FIREFOXURL' then
            Result := baFirefox;
          if ProgID = 'CHROMEHTML' then
            Result := baChrome;
          if ProgID = 'OPERA.PROTOCOL' then
            Result := baOpera;
          if ProgID = 'SAFARIURL' then
            Result := baOpera;
        end;
        Reg.CloseKey;
      end;
    end
    else
    begin
      Reg.RootKey := HKEY_CLASSES_ROOT;
      KeyName := '\http\shell\open\command';
      if Reg.OpenKeyReadOnly(KeyName) then
      begin
        if Reg.ValueExists('') then
        begin
          Result := GetDefaultBrowserApplicationFromFileName
            (Reg.ReadString(''));
        end;
        Reg.CloseKey;
      end;
    end;
  finally
    Reg.Free;
  end;
end;

function TBrowserApplicationDetails.IsFireFoxInstalled: boolean;
var
  Path: string;
begin
  Result := GetApplicationPath('firefox.exe', Path);
end;

function TBrowserApplicationDetails.IsIEInstalled: boolean;
var
  Path: string;
begin
  Result := GetApplicationPath('iexplore.exe', Path);
end;

function TBrowserApplicationDetails.IsChromeInstalled: boolean;
var
  Path: string;
begin
  Result := GetApplicationPath('chrome.exe', Path);
end;

function TBrowserApplicationDetails.IsSafariInstalled: boolean;
var
  Path: string;
begin
  Result := GetApplicationPath('safari.exe', Path);
end;

function TBrowserApplicationDetails.IsOperaInstalled: boolean;
var
  Path: string;
begin
  Result := GetApplicationPath('opera.exe', Path);
end;

function TBrowserApplicationDetails.GetInstalledBrowserApplications
  : TBrowserApplicationsSet;
begin
  Result := [];
  if IsFireFoxInstalled then
    Result := Result + [baFirefox];
  if IsIEInstalled then
    Result := Result + [baIE];
  if IsChromeInstalled then
    Result := Result + [baChrome];
  if IsSafariInstalled then
    Result := Result + [baSafari];
  if IsOperaInstalled then
    Result := Result + [baOpera];
end;

function TBrowserApplicationDetails.GetIEFavoritesFolder: string;
begin
  Result := GetFavoritesFolder;
end;

function TBrowserApplicationDetails.GetFirefoxProfiles
  (AProfileList: TStrings): boolean;
var
  Profile: string;
  INIFile: TINIFile;
  SectionList: TStringList;
  Idx: integer;
begin
  Result := False;
  if Assigned(AProfileList) then
  begin
    AProfileList.Clear;
    Profile := GetRoamingAppDataFolder + 'Mozilla\Firefox\profiles.ini';
    if FileExists(Profile) then
    begin
      INIFile := TINIFile.Create(Profile);
      SectionList := TStringList.Create;
      try
        with INIFile do
        begin
          ReadSections(SectionList);
          for Idx := 0 to Pred(SectionList.Count) do
          begin
            if ValueExists(SectionList[Idx], 'Name') then
            begin
              AProfileList.Add(ReadString(SectionList[Idx], 'Name', 'Unknown'));
            end;
          end;
        end;
      finally
        FreeAndNil(INIFile);
        FreeAndNil(SectionList);
      end;
    end;
  end;
end;

function TBrowserApplicationDetails.GetFirefoxProfileIDFromName
  (AProfileName: string): string;
var
  Profile: string;
  INIFile: TINIFile;
  SectionList: TStringList;
  Idx: integer;
begin
  Result := '';
  if AProfileName <> '' then
  begin
    Profile := GetRoamingAppDataFolder + 'Mozilla\Firefox\profiles.ini';
    if FileExists(Profile) then
    begin
      INIFile := TINIFile.Create(Profile);
      SectionList := TStringList.Create;
      try
        with INIFile do
        begin
          ReadSections(SectionList);
          for Idx := 0 to Pred(SectionList.Count) do
          begin
            if ValueExists(SectionList[Idx], 'Name') then
            begin
              if ReadString(SectionList[Idx], 'Name', '') = AProfileName then
              begin
                Result := SectionList[Idx];
              end;
            end;
          end;
        end;
      finally
        FreeAndNil(INIFile);
        FreeAndNil(SectionList);
      end;
    end;
  end;
end;

function TBrowserApplicationDetails.GetFirefoxBookmarksFileName
  (AProfile: string): string;
var
  ProfileFile, ProfileFolder, ProfileID, BookmarkFolder: string;
  INIFile: TINIFile;
begin
  Result := '';
  if AProfile <> '' then
  begin
    ProfileFolder := GetRoamingAppDataFolder + 'Mozilla\Firefox\';
    ProfileFile := ProfileFolder + 'profiles.ini';
    if FileExists(ProfileFile) then
    begin
      INIFile := TINIFile.Create(ProfileFile);
      try
        with INIFile do
        begin
          ProfileID := GetFirefoxProfileIDFromName(AProfile);
          if ProfileID <> '' then
          begin
            if SectionExists(ProfileID) then
            begin
              if ReadBool(ProfileID, 'IsRelative', True) then
              begin
                BookmarkFolder := IncludeTrailingPathDelimiter
                  (ProfileFolder + ReadString(ProfileID, 'Path', ''));
              end
              else
              begin
                BookmarkFolder := IncludeTrailingPathDelimiter
                  (ReadString(ProfileID, 'Path', ''));
              end;
              BookmarkFolder := StringReplace(BookmarkFolder, '/', '\',
                [rfReplaceAll]);
              Result := BookmarkFolder + 'bookmarks.html';
            end;
          end;
        end;
      finally
        FreeAndNil(INIFile);
      end;
    end;
  end;
end;

function TBrowserApplicationDetails.GetChromeBookmarksFileName: string;
var
  BookmarkFile: string;
begin
  Result := '';
  BookmarkFile := GetLocalAppDataFolder +
    'Google\Chrome\User Data\Default\Bookmarks';
  if FileExists(BookmarkFile) then
  begin
    Result := BookmarkFile;
  end;
end;

function TBrowserApplicationDetails.GetOperaBookmarksFileName: string;
var
  BookmarkFile: string;
begin
  Result := '';
  BookmarkFile := GetRoamingAppDataFolder +
    'Opera Software\Opera Stable\Bookmarks';
  if FileExists(BookmarkFile) then
  begin
    Result := BookmarkFile;
  end;
end;

function TBrowserApplicationDetails.GetSafariBookmarksFileName: string;
var
  BookmarkFile: string;
begin
  Result := '';
  BookmarkFile := GetRoamingAppDataFolder +
    'Apple Computer\Safari\Bookmarks.plist';
  if FileExists(BookmarkFile) then
  begin
    Result := BookmarkFile;
  end;
end;

end.
