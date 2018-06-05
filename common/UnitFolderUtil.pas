unit UnitFolderUtil;

interface

uses Windows, sysutils;

function GetSubFolderPath(ARootFolder, ASubFolder: string): string;

implementation

function GetSubFolderPath(ARootFolder, ASubFolder: string): string;
begin
  Result := IncludeTrailingBackSlash(ARootFolder);
  Result := IncludeTrailingBackSlash(Result + ASubFolder);
end;


end.
