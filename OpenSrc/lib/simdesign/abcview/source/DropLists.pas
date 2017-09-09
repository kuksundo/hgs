{ Unit DropLists

  Implements a list that contains drag/drop items
  
  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit DropLists;

interface

uses
  Windows, Classes, SysUtils, Contnrs, {$warnings off}FileCtrl, {$warnings on}DropSource, ActiveX, sdAbcVars;

type

  TExtFile = class
    Name: string;
  end;

  TDropList = class(TList)
  private
    FExternals: TObjectList;
    FExtMimick: boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddExternal(Files, Mapped: TStrings);
    // Get the allowed effects
    function DragEffect: integer;
    // Get the allowed drag types for this droplist
    function DragTypes: TDragTypes;
    // Get external files and add them to AList
    procedure GetExternal(AList: TStringList);
    // Get internal files and add them to AList
    procedure GetInternal(AList: TStringList);
    // Get all files (internal or external) and add them to AList
    procedure GetFiles(AList: TStringList);
    procedure Clear; override;
    function Contains(AClass: TClass): boolean;
    function IsEmpty: boolean;
    // Set ExtPreview only during a dragover to imitate presence of
    // external file (for cursor feedback)
    property ExtMimick: boolean read FExtMimick write FExtMimick;
  end;

implementation

uses
  sdItems, BrowseTrees;

constructor TDropList.Create;
begin
  inherited Create;
  FExternals := TObjectList.Create;
end;

destructor TDropList.Destroy;
begin
  FreeAndNil(FExternals);
  inherited;
end;

procedure TDropList.AddExternal(Files, Mapped: TStrings);
var
  i: integer;
  FileName: string;
  Ext: TExtFile;
begin
  if not assigned(Files) or not assigned(Mapped) then exit;

  // Add the files
  for i := 0 to Files.Count - 1 do
  begin
    if i < Mapped.count then
    begin
      Filename := FTempFolder + Mapped[i];
      // Restore to temp location first
      copyfile(PChar(Files[i]), PChar(Filename), true);
    end else
      FileName := Files[i];

    // Folder? just include the backslash
    if DirectoryExists(FileName) then
      FileName := IncludeTrailingPathDelimiter(FileName);

    // Add to ext list
    Ext := TExtFile.Create;
    Ext.Name := FileName;
    FExternals.Add(Ext);
    Add(Ext);
  end;
end;

function TDropList.DragEffect: integer;
var
  ADragTypes: TDragTypes;
begin
  Result := 0;
  ADragTypes := DragTypes;
  if dtMove in ADragTypes then Result := Result or DROPEFFECT_MOVE;
  if dtCopy in ADragTypes then Result := Result or DROPEFFECT_COPY;
  if dtLink in ADragTypes then Result := Result or DROPEFFECT_LINK;
end;

function TDropList.DragTypes: TDragTypes;
var
  i: integer;
begin
  Result := [];
  if Count = 0 then exit;
  // Start with full set
  Result := [dtMove, dtCopy, dtLink];
  for i := 0 to Count - 1 do begin
    // Intersect with all items
    if TObject(Items[i]) is TsdItem then
      Result := Result * TsdItem(Items[i]).DragTypes;
    if TObject(Items[i]) is TBrowseItem then
      Result := Result * TBrowseItem(Items[i]).DragTypes;
  end;
end;

procedure TDropList.GetExternal(AList: TStringList);
var
  i: integer;
begin
  if not assigned(AList) then exit;
  for i := 0 to Count - 1 do begin
    if TObject(Items[i]) is TExtFile then
      AList.Add(TExtFile(Items[i]).Name);
  end;
end;

procedure TDropList.GetFiles(AList: TStringList);
begin
  GetInternal(AList);
  GetExternal(AList);
end;

procedure TDropList.Clear;
begin
  if assigned(FExternals) then
    FExternals.Clear;
  inherited;
end;

procedure TDropList.GetInternal(AList: TStringList);
var
  i: integer;
begin
  if not assigned(AList) then exit;
  for i := 0 to Count - 1 do begin
    if TObject(Items[i]) is TsdFile then
      AList.Add(TsdFile(Items[i]).FileName);
    if TObject(Items[i]) is TsdFolder then
      AList.Add(TsdFile(Items[i]).FolderName);
  end;
end;

function TDropList.Contains(AClass: TClass): boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to Count - 1 do
    if TObject(Items[i]) is AClass then
      Result := True;
  if (not Result) and (AClass = TExtFile) and ExtMimick then
    Result := True;
end;

function TDropList.IsEmpty: boolean;
begin
  Result := Count = 0;
end;

end.
