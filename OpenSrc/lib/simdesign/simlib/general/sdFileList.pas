{  Author: Nils Haeck M.Sc.
  Copyright (c) 2005 SimDesign B.V.

  This software may ONLY be used or replicated in accordance with
  the LICENSE found in this source distribution.

  Description:

  Simple unit that implements a file list, and allows easy scanning of folders
  for files.

  Please visit http://www.simdesign.nl for more information.
}

unit sdFileList;

interface

uses
  Classes, Contnrs, SysUtils, sdSortedLists;

type

  TsdFileReadResult = (
    frOK,
    frDoesNotExist,
    frCannotOpen
  );
  TsdFileList = class;

  TsdFileSortMethod = (
    smByName,
    smByDate,
    smBySize
  );

  TsdFileItem = class(TPersistent)
  private
    FParent: TsdFileList;
    FFolderIndex: integer; // Index into parent's folder stringlist
    FFileName: string;
    FFileDate: TDateTime;
    FFileSize: integer;
    function GetFullName: string;
    function GetFolder: string;
    procedure SetFolder(const AFolder: string);
  public
    constructor Create(AParent: TsdFileList); virtual;
    // Returns the filename part of the file (including extension)
    property FileName: string read FFileName;
    // Returns the file date in TDateTime format
    property FileDate: TDateTime read FFileDate;
    // Returns the file size in bytes. Note that this method is not compatible
    // with files > 2Gb
    property FileSize: integer read FFileSize;
    // Returns the full path + filename
    property FullName: string read GetFullName;
    // Returns the folder part of the filename (including the trailing backslash)
    property Folder: string read GetFolder;
    // Delete this file (doesn't move it to the recycle bin!). Result is true if
    // successful.
    function DeleteFile: boolean;
    // Move this file. Result is true if successful. The file's folder will be
    // updated if the move was successful.
    function MoveFile(const DestinationFolder: string): boolean;
    // Read the contents of of the file into string Contents.
    function ReadContents(var Contents: string): TsdFileReadResult;
    // Read the contents of of the file into string Contents. This version wants
    // exclusive access to the file. This can avoid opening a file that an other
    // process is writing to.
    function ReadContentsExclusive(MaxRetryCount, RetryInterval: integer; var Contents: string): TsdFileReadResult;
  end;

  TsdFileList = class(TCustomSortedList)
  private
    FFolders: TStringList;
    FSortMethod: TsdFileSortMethod;
    function GetItems(Index: integer): TsdFileItem;
    procedure SetSortMethod(const Value: TsdFileSortMethod);
  protected
    function DoCompare(Item1, Item2: TObject): integer; override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Scan(const AFolder, AMask: string; IncludeSubfolders: boolean);
    function IndexByName(const AFullName: string): integer;
    property Items[Index: integer]: TsdFileItem read GetItems; default;
    property SortMethod: TsdFileSortMethod read FSortMethod write SetSortMethod;
  end;

implementation

uses
{$ifndef lcl}
  Forms,
{$endif lcl}
  ShellApi;

{$ifdef lcl}
function SystemMoveFile(const FileName, DestDir: UTF8string): Boolean;
begin
// todo!
  Result := false;
end;
{$else lcl}
function SystemMoveFile(const FileName, DestDir: UTF8string): Boolean;
// Move a file using shell API, returns True if successful
var
  FileOpStruct: TSHFileOpStruct;
  SourceFileName, DestFileName: UTF8string;
begin
  // Need double 0 at end
  SourceFileName := FileName + #0#0;

  DestFileName := IncludeTrailingPathDelimiter(DestDir) + ExtractFileName(FileName);

  with FileOpStruct do
  begin
    {$ifdef UNICODE}
    pFrom := pwidechar(Utf8ToWidestring(SourceFileName));
    pTo   := pwidechar(Utf8ToWidestring(DestFileName));
    {$else UNICODE}
    pFrom := pansichar(SourceFileName);
    pTo   := pansichar(DestFileName);
    {$endif UNICODE}

    wFunc := FO_Move;

    wnd := Application.Handle;

    fFlags := 0;

    fFlags := fFlags or FOF_FilesOnly;
    fFlags := fFlags or FOF_NoConfirmation;
    fFlags := fFlags or FOF_Silent;
    fFlags := fFlags or FOF_AllowUndo;
    fFlags := fFlags or FOF_NoConfirmMkDir;
    fFlags := fFlags or FOF_RenameOnCollision;

    hNameMappings := nil;

  end;

  SHFileOperation(FileOpStruct);

  Result := not FileOpStruct.fAnyOperationsAborted;
end;
{$endif lcl}

{ TsdFileItem }

constructor TsdFileItem.Create(AParent: TsdFileList);
begin
  inherited Create;
  FParent := AParent;
  FFolderIndex := -1;
end;

function TsdFileItem.DeleteFile: boolean;
var
  Name: string;
begin
  Result := False;
  if FFolderIndex < 0 then
    exit;
  Name := GetFullName;
  if FileExists(Name) then
    Result := SysUtils.DeleteFile(Name);
end;

function TsdFileItem.GetFolder: string;
begin
  Result := '';
  if FFolderIndex < 0 then
    exit;
  Result := FParent.FFolders[FFolderIndex];
end;

function TsdFileItem.GetFullName: string;
begin
  Result := '';
  if FFolderIndex < 0 then
    exit;
  Result := FParent.FFolders[FFolderIndex] + FFileName;
end;

function TsdFileItem.MoveFile(const DestinationFolder: string): boolean;
var
  Name: string;
begin
  Result := False;
  if FFolderIndex < 0 then
    exit;
  Name := GetFullName;
  if FileExists(Name) then
    Result := SystemMoveFile(Name, DestinationFolder);
  if Result then
    SetFolder(DestinationFolder);
end;

function TsdFileItem.ReadContents(var Contents: string): TsdFileReadResult;
var
  Name: string;
  S: TFileStream;
begin
  Contents := '';
  Name := FullName;
  if not FileExists(Name) then
  begin
    Result := frDoesNotExist;
    exit;
  end;
  try
    S := TFileStream.Create(Name, fmOpenRead or fmShareDenyNone);
    // Load the contents
    if S.Size > 0 then
    begin
      SetLength(Contents, S.Size);
      S.Read(Contents[1], S.Size);
    end;
    Result := frOK;
  except
    Result := frCannotOpen;
  end;
end;

function TsdFileItem.ReadContentsExclusive(MaxRetryCount, RetryInterval: integer;
  var Contents: string): TsdFileReadResult;
var
  Name: string;
  S: TFileStream;
begin
  Contents := '';
  Name := FullName;
  if not FileExists(Name) then
  begin
    Result := frDoesNotExist;
    exit;
  end;
  repeat
    try
      S := TFileStream.Create(Name, fmOpenRead or fmShareExclusive);
      try
        // Load the contents
        if S.Size > 0 then
        begin
          SetLength(Contents, S.Size);
          S.Read(Contents[1], S.Size);
        end;
        Result := frOK;
        exit;
      finally
        S.Free;
      end;
    except
      dec(MaxRetryCount);
      sleep(RetryInterval);
    end;
  until MaxRetryCount <= 0;
  Result := frCannotOpen;
end;

procedure TsdFileItem.SetFolder(const AFolder: string);
var
  Fldr: string;
begin
  Fldr := IncludeTrailingPathDelimiter(AFolder);
  if Fldr = GetFolder then exit;
  FFolderIndex := FParent.FFolders.IndexOf(Folder);
  if FFolderIndex < 0 then
  begin
    FFolderIndex := FParent.FFolders.Count;
    FParent.FFolders.Sorted := False;
    FParent.FFolders.Add(Folder);
  end;
end;

{ TsdFileList }

constructor TsdFileList.Create;
begin
  inherited Create;
  FFolders := TStringList.Create;
  FFolders.Duplicates := dupIgnore;
  FFolders.Sorted := True;
end;

destructor TsdFileList.Destroy;
begin
  FreeAndNil(FFolders);
  inherited;
end;

function TsdFileList.DoCompare(Item1, Item2: TObject): integer;
var
  F1, F2: TsdFileItem;
begin
  F1 := TsdFileItem(Item1);
  F2 := TsdFileItem(Item2);
  case FSortMethod of
  smByName:
    begin
      Result := CompareInteger(F1.FFolderIndex, F2.FFolderIndex);
      if Result = 0 then
        Result := AnsiCompareText(F1.FFileName, F2.FFileName);
    end;
  smByDate:
    Result := CompareDouble(F1.FFileDate, F2.FFileDate);
  smBySize:
    Result := CompareInteger(F1.FFileSize, F2.FFileSize);
  else
    Result := 0;
  end;
end;

function TsdFileList.GetItems(Index: integer): TsdFileItem;
begin
  if (Index >= 0) and (Index < Count) then
    Result := TsdFileItem(GetItem(Index))
  else
    Result := nil;
end;

function TsdFileList.IndexByName(const AFullName: string): integer;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    if Items[i].FullName = AFullName then
    begin
      Result := i;
      exit;
    end;
  Result := -1;
end;

procedure TsdFileList.Scan(const AFolder, AMask: string; IncludeSubfolders: boolean);
var
  S: TSearchRec;
  FindRes: integer;
  FolderIndex: integer;
  Folder: string;
  Item: TsdFileItem;
begin
  Folder := IncludeTrailingPathDelimiter(AFolder);
  FolderIndex := FFolders.IndexOf(Folder);
  if FolderIndex < 0 then
    FolderIndex := FFolders.Add(Folder);
  FindRes := FindFirst(Folder + AMask, faAnyFile, S);
  while FindRes = 0 do
  begin
    if (faDirectory and S.Attr) > 0 then
    begin
      // This is a subfolder
      if IncludeSubfolders and (S.Name <> '..') and (S.Name <> '.') then
        Scan(Folder + S.Name, AMask, True);
    end else
    begin
      // This is a file
      Item := TsdFileItem.Create(Self);
      Item.FFolderIndex := FolderIndex;
      Item.FFileName := S.Name;
      Item.FFileDate := FileDateToDateTime(S.Time);
      Item.FFileSize := S.Size;
      Add(Item);
    end;
    FindRes := FindNext(S);
  end;
  FindClose(S);
end;

procedure TsdFileList.SetSortMethod(const Value: TsdFileSortMethod);
begin
  FSortMethod := Value;
  Sort;
end;

end.
