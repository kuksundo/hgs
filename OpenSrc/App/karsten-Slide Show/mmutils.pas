{ $Id: mmutils.pas 1394 2006-10-30 05:20:21Z mm $ }
unit mmutils;
{<
@abstract matthias' tool kit
@author matthias muntwiler <mm@kspace.ch>
@created 2006-10-29
@cvs $Date: 2006-10-30 00:20:21 -0500 (Mo, 30 Okt 2006) $

This is an extract from the former mmvaria library which was broken up.
}

interface
uses
  Windows, SysUtils, Graphics, Messages, Forms, Classes, Controls, SyncObjs;

{ Converts all segments of a partially 8.3-formatted path to long format.
  This function is thread-safe.}
function GetLongPathName(const PathName: string): string;
{	Returns the file size to the given file name/path.
  This function is thread-safe.}
function GetFileSizeByName(const Filename: string): cardinal;
{	Creates a unique temp file name and returns the complete file path.
	prefix must be 3 chars, they will be the first 3 chars of the file name.
	path should be the desired file location, default is the user-specific temp folder.
  Raises an EWin32Error exception on failure.
  This function is thread-safe.}
function GetTempFilePath(const prefix: string; const path: string = ''): string;
{	Returns the free space at the path location in bytes.
	All windows 9x/NT versions are treated appropriately.
  This function is thread-safe.}
function GetFreeDriveSpace(const path: string): int64;
{	Checks that the given filename does not contain illegal characters <>|*?"
	with allowPathSep=false path separators \/: are illegal, too.
  This function is thread-safe.}
function CheckFileNameChars(filename: string; allowPathSep: boolean = false): boolean;

{	Writes a string to a stream and terminates it with CR, LF
	so that the streamed file can be read with a text editor.
	No type or length bytes are added.
	Indent: number of spaces to insert at the beginning of the line. }
procedure	StreamWriteLn(Stream: TStream; line: string; indent: cardinal = 0);
{	Reads a line of text from the stream.
	The line must be terminated with CR, LF or CR or LF.
	trim=true removes spaces at the beginning and the end of the line. }
function	StreamReadLn(Stream: TStream; trim: boolean = false): string;

var
	{ True if the process instance is the one that has been started first. }
	isFirstAppInstance: boolean;

implementation

{ various functions }

procedure	StreamWriteLn(Stream: TStream; line: string; indent: cardinal = 0);
const
	crlf: string = #13#10;
var
	prefix: string;
begin
	if indent > 0 then begin
		SetLength(prefix, indent);
		FillChar(prefix[1], indent, Ord(' '));
		Stream.WriteBuffer(prefix[1], indent);
	end;
	Stream.WriteBuffer(line[1], Length(line));
	Stream.WriteBuffer(crlf[1], 2);
end;


function	StreamReadLn(Stream: TStream; trim: boolean = false): string;
var
	buffer: array of char;
	pbuf: pChar;
	buflen: integer;
	i: integer;
	cr, lf, complete: boolean;
begin
	buflen := 0;
	i := 0;
	cr := false;
	lf := false;
	complete := false;
	while (Stream.Position < Stream.Size) and not complete do begin
		if i >= buflen then begin
			Inc(buflen, 256);
			SetLength(buffer, buflen);
		end;
		Stream.ReadBuffer(buffer[i], 1);
		complete := cr or lf;
		if cr and (buffer[i] <> #10) then begin
			Stream.Position := Stream.Position - 1;
			Dec(i);
		end;
		if lf and (buffer[i] <> #13) then begin
			Stream.Position := Stream.Position - 1;
			Dec(i);
		end;
		cr := (buffer[i] = #13);
		lf := (buffer[i] = #10);
		if cr or lf then buffer[i] := #0;
		Inc(i);
	end;
	if Length(buffer) > 0 then begin
		pBuf := @buffer[0];
		result := pBuf;
		if trim then result := SysUtils.Trim(result);
	end else
		result := '';
end;

function GetLongPathName(const PathName: String): String;
var
	Drive: String;
	Path: String;
	SearchRec: TSearchRec;
begin
	if Length(PathName) > 0 then begin
		Drive :=  ExtractFileDrive(PathName);
		Path :=  Copy(PathName, Length(Drive) + 1, Length(PathName));
		if (Path = '') or (Path = PathDelim) then begin
			Result :=  PathName;
			if Result[Length(Result)] = PathDelim then
				Delete(Result, Length(Result), 1)
    end else begin
			Path :=  GetLongPathName(ExtractFileDir(PathName));
			if FindFirst(PathName, faAnyFile, SearchRec) = 0 then begin
				Result := IncludeTrailingPathDelimiter(Path) + SearchRec.Name;
				FindClose(SearchRec)
      end else
        Result :=  IncludeTrailingPathDelimiter(Path) + ExtractFileName(PathName) end
	end else
    result := '';
end;

function GetFileSizeByName(const Filename: string): cardinal;
var
	hFile: tHandle;
begin
	hFile := CreateFile(pChar(Filename), generic_Read, file_Share_Read, nil, 
		open_Existing, file_Attribute_Normal, 0);
	if hFile <> invalid_Handle_Value then begin
		try
			result := GetFileSize(hFile, nil);
			if result = $ffffffff then result := 0;
		finally
			CloseHandle(hFile);
		end;
	end else
    result := 0;
end;

function GetFreeDriveSpace(const path: string): int64;
var
	drive: string;
	drivesize: int64;
	secperclu, bytpersec, numfreeclu, totfreeclu: cardinal;
begin
	if
    (Win32Platform = VER_PLATFORM_WIN32_WINDOWS) and
    (Win32BuildNumber < 1000)
  then begin
		drive := IncludeTrailingPathDelimiter(ExtractFileDrive(path));
		if not GetDiskFreeSpace(pChar(drive), secperclu, bytpersec, numfreeclu, totfreeclu) then
      RaiseLastOSError;
		result := numfreeclu * secperclu * bytpersec;
	end else begin
		drive := ExtractFileDir(path);
		if not GetDiskFreeSpaceEx(pChar(drive), result, drivesize, nil) then
      RaiseLastOSError;
	end;
end;

function CheckFileNameChars(filename: string; allowPathSep: boolean): boolean;
var
	i: integer;
	del: string;
begin
	result := true;
	if allowPathSep then
    del := '<>"|*?'
  else
    del := '<>: "/\|*?';
  for i := 1 to Length(filename) do begin
    if (Ord(filename[i]) < 32) or IsDelimiter(del, filename, i) then begin
      result := false;
      Break;
    end;
  end;
end;

var
	TempFiles: TStrings;
	TempFileSection: TCriticalSection;

function GetTempFilePath(const prefix: string; const path: string=''): string;
var
	tfnPath, tempFilename: string;
	apiResult: dword;
begin
	if Length(path) = 0 then begin
		SetLength(tfnPath, max_Path);
		apiResult := GetTempPath(Length(tfnPath) + 1, pChar(tfnPath));
		if (apiResult = 0) or (apiResult > max_Path) then RaiseLastOSError;
		SetLength(tfnPath, apiResult);
	end else
    tfnPath := path;
	SetLength(TempFilename, max_Path);
	if GetTempFileName(pChar(tfnPath), pChar(prefix), 0, pChar(TempFilename)) = 0 then
    RaiseLastOSError;
	SetLength(TempFilename, StrLen(pChar(TempFilename)));
	TempFileSection.Enter;
	try
		TempFiles.Add(tempFilename);
	finally
		TempFileSection.Leave;
	end;
	result := tempFilename;
end;

procedure CleanupTempFiles;
var
	idx: integer;
begin
	TempFileSection.Enter;
	try
		try
      for idx := 0 to TempFiles.Count-1 do
        DeleteFile(TempFiles[idx]);
		except
		end;
	finally
		TempFileSection.Leave;
	end;
end;

var
	FirstInstanceStartup: tHandle;
	sFirstInstanceStartupName: string;

initialization
	sFirstInstanceStartupName := ExtractFileName(ParamStr(0)) + 'FirstInstanceStartup';
	FirstInstanceStartup := CreateMutex(nil, false, pChar(sFirstInstanceStartupName));
	isFirstAppInstance := (FirstInstanceStartup > 0) and (GetLastError = 0);
	TempFiles := TStringList.Create;
	TempFileSection := TCriticalSection.Create;
finalization
	if FirstInstanceStartup > 0 then CloseHandle(FirstInstanceStartup);
	CleanupTempFiles;
	TempFiles.Free;
	TempFileSection.Free;
end.

