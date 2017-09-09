(* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is repair.search.pas of Karsten Bilderschau, version 3.4.0
 *
 * The Initial Developer of the Original Code is Matthias Muntwiler.
 * Portions created by the Initial Developer are Copyright (C) 2006
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** *)

{ $Id: repair.search.pas 82 2006-10-29 17:27:21Z hiisi $ }

{
@abstract Thread to search for missing files
@author matthias muntwiler <hiisi@users.sourceforge.net>
@created 2006/10/28
@cvs $Date: 2006-10-29 11:27:21 -0600 (So, 29 Okt 2006) $
}
unit repair.search;

interface

uses
  Windows, SysUtils, Classes, SyncObjs, globals;

type
  TRepairSearchThread = class(TThread)
  private
    Sync: TCriticalSection;
    FRootDir: string;
    FFoldersSearched: integer;
    FFilesSearched: integer;
    FFilesFound: integer;
    FTargetList: TStrings;
    FResultList: array of string;
    FRunning: boolean;
    FNotifyWnd: HWND;
    function GetFilesFound: integer;
    function GetFilesSearched: integer;
    function GetFoldersSearched: integer;
    function FindFile(const AFilePath: string): boolean;
    function GetResultPath(index: integer): string;
  protected
    procedure Execute; override;
    procedure SearchDirectory(const ADirPath: string);
    procedure DoTerminate; override;
  public
    { Starts the search thread.
      Call Terminate to stop it.
      Wait for the OnTerminate event.
      @param ARootDir is a path to the top level directory of the search
      @param AFileList is a list of file names to search for
      @param ANotifyWnd will receive a um_JobDone message when the thread terminates }
    constructor Create(const ARootDir: string; const AFileList: TStrings;
      ANotifyWnd: HWND);
    destructor  Destroy; override;
    property  Running: boolean read FRunning;
    { Number of folders searched }
    property  FoldersSearched: integer read GetFoldersSearched;
    { Number of files checked }
    property  FilesSearched: integer read GetFilesSearched;
    { Number of target files found }
    property  FilesFound: integer read GetFilesFound;
    { Retrieves results.
      The paths are copied to the string list.
      Wait for the OnTerminate event before calling this method. }
    function  GetResults(const APathList: TStrings): boolean;
    { Retrieve results, one by one.
      The index corresponds to the file list that was assigned to the constructor. }
    property  ResultPath[index: integer]: string read GetResultPath;
  end;

implementation

{ TRepairSearchThread }

constructor TRepairSearchThread.Create;
begin
  FRootDir := ARootDir;
  FNotifyWnd := ANotifyWnd;
  Sync := TCriticalSection.Create;
  FTargetList := TStringList.Create;
  FTargetList.Assign(AFileList);
  SetLength(FResultList, FTargetList.Count);
  FRunning := true;
  inherited Create(false);
end;

destructor TRepairSearchThread.Destroy;
begin
  inherited;
  FreeAndNil(Sync);
  FreeAndNil(FTargetList);
end;

procedure TRepairSearchThread.DoTerminate;
begin
  FRunning := false;
  inherited;
  if FNotifyWnd > 0 then
    PostMessage(FNotifyWnd, um_JobDone, -1, integer(@Self));
end;

function TRepairSearchThread.FindFile;
var
  FileName: string;
  i: integer;
begin
  if AFilePath[Length(AFilePath)] = PathDelim then begin
    FileName := ExcludeTrailingBackslash(AFilePath);
    FileName := ExtractFileName(FileName);
    FileName := IncludeTrailingPathDelimiter(FileName);
  end else
    FileName := ExtractFileName(AFilePath);
  result := false;
  for i := 0 to FTargetList.Count - 1 do begin
    if SameFileName(FTargetList[i], FileName) then begin
      result := true;
      Sync.Acquire;
      try
        if FResultList[i] = '' then begin
          FResultList[i] := AFilePath;
          InterlockedIncrement(FFilesFound);
          if FNotifyWnd > 0 then
            PostMessage(FNotifyWnd, um_JobDone, i, integer(@Self));
        end;
      finally
        Sync.Release;
      end;
      Break;
    end;
    if Terminated then Break;
  end;
  InterlockedIncrement(FFilesSearched);
end;

procedure TRepairSearchThread.SearchDirectory;
var
  dir: string;
  code: integer;
  sr: TSearchRec;
begin
  dir := IncludeTrailingPathDelimiter(ADirPath);
  // todo -cconfig : make search for hidden files configurable
  code := FindFirst(dir + '*.*', faReadOnly or faDirectory or faHidden, sr);
  try
    while not Terminated and (code = 0) do begin
      if (sr.Name <> '.') and (sr.Name <> '..') then begin
        if (sr.Attr and faDirectory) <> 0 then begin
          FindFile(IncludeTrailingPathDelimiter(dir + sr.Name));
          SearchDirectory(dir + sr.Name);
        end else begin
          FindFile(dir + sr.Name);
        end;
      end;
      code := FindNext(sr);
    end;
  finally
    FindClose(sr);
  end;
  InterlockedIncrement(FFoldersSearched);
end;

procedure TRepairSearchThread.Execute;
begin
  SearchDirectory(FRootDir);
end;

function TRepairSearchThread.GetFilesFound;
begin
  result := FFilesFound;
end;

function TRepairSearchThread.GetFilesSearched;
begin
  result := FFilesSearched;
end;

function TRepairSearchThread.GetFoldersSearched;
begin
  result := FFoldersSearched;
end;

function TRepairSearchThread.GetResultPath(index: integer): string;
begin
  Sync.Acquire;
  try
    result := FResultList[index];
  finally
    Sync.Release;
  end;
end;

function TRepairSearchThread.GetResults;
var
  i: integer;
begin
  Sync.Acquire;
  try
    result := not FRunning and (FFilesFound >= 1);
    if result then begin
      APathList.Clear;
      for i := Low(FResultList) to High(FResultList) do
        APathList.Add(FResultList[i]);
    end else
      result := false;
  finally
    Sync.Release;
  end;
end;

end.
