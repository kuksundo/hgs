{ *********************************************************************** }
{                                                                         }
{ SearchUtils                                                             }
{                                                                         }
{ Copyright (c) 2003-2004 Pisarev Yuriy (post@pisarev.net)                }
{                                                                         }
{ *********************************************************************** }

unit SearchUtils;

{$B-}

interface

uses
  Windows, SysUtils, Classes, Types, TextConsts;

type
  TDriveType = (dtUnknown, dtNoDrive, dtFloppy, dtFixed, dtNetwork, dtCDROM, dtRAM);
  TDriveTypes = set of TDriveType;

const
  AnyFile = '*.*';

var
  MaskDelimiter: string = Semicolon;

function GetDriveArray(const DriveTypes: TDriveTypes): TStringDynArray;

function Search(const Target: string; const FileList: TStrings; const PathList: TStrings = nil;
  const SubPath: Boolean = True; const IncludeModuleName: Boolean = False;
  const FileLock: PRTLCriticalSection = nil; const PathLock: PRTLCriticalSection = nil): Boolean;

implementation

uses
  MemoryUtils, TextUtils, ThreadUtils;

function GetDriveArray(const DriveTypes: TDriveTypes): TStringDynArray;
const
  DriveCount = 26;
  CharOffset = Ord('a');
  NameSuffix = ':\';
var
  Drives: set of 0..DriveCount - 1;
  Drive: Integer;
  DriveName: string;
begin
  Integer(Drives) := GetLogicalDrives;
  for Drive := 0 to DriveCount - 1 do
    if Drive in Drives then
    begin
      DriveName := Char(Drive + CharOffset) + NameSuffix;
      if TDriveType(GetDriveType(PChar(DriveName))) in DriveTypes then
        Add(Result, DriveName);
    end;
end;

function Search(const Target: string; const FileList, PathList: TStrings; const SubPath: Boolean;
  const IncludeModuleName: Boolean; const FileLock, PathLock: PRTLCriticalSection): Boolean;

  procedure Add(const List: TStrings; const Data: Integer; const FileName: string; const Lock: PRTLCriticalSection);
  begin
    if Assigned(Lock) then
    begin
      Enter(Lock^);
      try
        List.AddObject(FileName, Pointer(Data));
      finally
        Leave(Lock^);
      end;
    end
    else List.AddObject(FileName, Pointer(Data));
  end;

const
  CFolder = '.';
  PFolder = '..';
var
  List: TStrings;
  MaskArray: TStringDynArray;
  I, J, K: Integer;
  Path, Name, S, ModuleName: string;
  F: TSearchRec;
begin
  if Assigned(PathList) then List := PathList
  else List := TStringList.Create;
  try
    Result := Write(Target, MaskDelimiter, MaskArray);
    if Result then
    try
      for I := Low(MaskArray) to High(MaskArray) do
      begin
        Path := Trim(ExtractFilePath(MaskArray[I]));
        Name := Trim(ExtractFileName(MaskArray[I]));
        if Name = '' then Name := AnyFile;
        J := List.Add(Path);
        K := List.Count;
        try
          if FindFirst(Path + AnyFile, faAnyFile, F) = 0 then
          repeat
            if (F.Attr and faDirectory = faDirectory) and not TextUtils.SameText(F.Name, CFolder) and
              not TextUtils.SameText(F.Name, PFolder) then
                Add(List, 0, IncludeTrailingPathDelimiter(Path + F.Name), PathLock);
          until FindNext(F) <> 0;
        finally
          FindClose(F);
        end;
        try
          ModuleName := ParamStr(0);
          if FindFirst(Path + Name, faAnyFile, F) = 0 then
          repeat
            if F.Attr and faDirectory = 0 then
            begin
              S := Path + F.Name;
              if IncludeModuleName or not TextUtils.SameText(ModuleName, S) then
                Add(FileList, J, S, FileLock);
            end;
          until FindNext(F) <> 0;
        finally
          FindClose(F);
        end;
        if SubPath then
          for J := K to List.Count - 1 do
            Search(List[J] + Name, FileList, List, SubPath, IncludeModuleName, FileLock, PathLock);
        Result := FileList.Count > 0;
      end;
    finally
      MaskArray := nil;
    end;
  finally
    if not Assigned(PathList) then List.Free;
  end;
end;

end.
