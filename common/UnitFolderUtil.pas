unit UnitFolderUtil;

interface

uses Windows, sysutils, SynCommons, Forms;

function GetSubFolderPath(ARootFolder, ASubFolder: string): string;
function GetDefaultDBPath: string;

implementation

function GetSubFolderPath(ARootFolder, ASubFolder: string): string;
begin
  Result := IncludeTrailingBackSlash(ARootFolder);
  Result := IncludeTrailingBackSlash(Result + ASubFolder);
  EnsureDirectoryExists(Result);
end;

function GetDefaultDBPath: string;
begin
  Result := GetSubFolderPath(ExtractFilePath(Application.ExeName), 'db');
end;

end.
