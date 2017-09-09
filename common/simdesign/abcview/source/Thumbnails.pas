{ unit Thumbnails

  Thumbnail property

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!
}
unit Thumbnails;

interface

uses

  Classes, Graphics, JPeg, Dialogs, sdProperties, sdStreamableData, 
  sdAbcVars;

type

  TprThumbnail = class(TStoredProperty)
  private
    FHeight: integer; // Thumbnail height (window)
    FPos: integer;    // Position on the stream
    FWidth: integer;  // Thumbnail width (window)
  protected
    function GetPropID: word; override;
    function GetStream: TStream;
    function GetStreamSize: integer;
    function LockStream: TStream;
    procedure UnlockStream;
  public
    constructor Create; override;
    property Height: integer read FHeight write FHeight;
    property Pos: integer read FPos write FPos;
    property StreamSize: integer read GetStreamSize;
    property Width: integer read FWidth write FWidth;
{    procedure ClearBox;}
    procedure FindSpot(ASize: integer);
    // Call LoadBitmap to load the thumbnail from the stream and put a copy
    // in ABitmap. It returns True if successful
    function LoadBitmap(ABitmap: TBitmap): boolean;
    // Call LoadStream to put the chunk from the backing file into S, from current pos
    function LoadStream(S: TStream): boolean;
    // Call SaveBitmap to copy of the bitmap to the stream. It returns True
    // if successful
    function SaveBitmap(ABitmap: TBitmap): boolean;
    // Call SaveStream to put the stream S to the backing file
    function SaveStream(S: TStream): boolean;
    procedure ReadComponents(S: TStream); override;
    procedure WriteComponents(S: TStream); override;
  end;


implementation

uses
  sdRoots, guiMain;

{ TprThumbnail }

constructor TprThumbnail.Create;
begin
  inherited;
  // indicate "no stream position"
  Pos := -1;
  // Make sure to use the temporary stream
  IsTemporary := True;
end;

function TprThumbnail.GetPropID: word;
begin
  Result := prThumbnail;
end;

function TprThumbnail.GetStream: TStream;
begin
  Result := nil;
  if assigned(frmMain.Root) then
  begin
    if IsTemporary then
      Result := frmMain.Root.TmpThumbs
    else
      Result := frmMain.Root.SavThumbs;
  end;
end;

function TprThumbnail.GetStreamSize: integer;
var
  Thumbs: TStream;
begin
  Result := 0;
  Thumbs := LockStream;
  try
    if assigned(Thumbs) and (Pos >= 0) then begin
      Thumbs.Seek(Pos + SizeOf(integer), soFromBeginning);
      if Thumbs.Position < Thumbs.Size then
        Thumbs.Read(Result, SizeOf(integer));
    end;
  finally
    UnlockStream;
  end;
end;

function TprThumbnail.LockStream: TStream;
begin
  Result := nil;
  if assigned(frmMain.Root) then begin
    frmMain.Root.ThumbLock;
    Result := GetStream;
  end;
end;

procedure TprThumbnail.UnlockStream;
begin
  if assigned(frmMain.Root) then
    frmMain.Root.ThumbUnlock;
end;

procedure TprThumbnail.FindSpot(ASize: integer);
var
  Thumbs: TStream;
begin
  // Find a suitable spot for ASize bytes and position the stream there
  Thumbs := GetStream;
  if assigned(Thumbs) then
  begin
    // Right now we don't have any optimisation - just move to the end
    // to do: this must be moved to a Thumbstream Manager
    Thumbs.Seek(0, soFromEnd);
    Pos := Thumbs.Position;
  end;
end;

function TprThumbnail.LoadBitmap(ABitmap: TBitmap): boolean;
var
  JPeg: TJPegImage;
  S: TStream;
begin
  // The backing file holds a JPeg copy
  Result := False;
  if not assigned(ABitmap) then exit;

  try
    JPeg := TJPegImage.Create;
    try
      S := TMemoryStream.Create;
      try
        if LoadStream(S) then begin
          S.Seek(0, soFromBeginning);
          JPeg.LoadFromStream(S);
          JPeg.Performance := jpBestSpeed;
          // clear if it contained anything
          ABitmap.Width := 0;
          ABitmap.Height := 0;
          ABitmap.PixelFormat := pf24bit;
          // copy the jpeg to the bitmap
          ABitmap.Assign(JPeg);
          // if everything went well we arrive here
          Result := True;
        end;
      finally
        S.Free;
      end;
    finally
      JPeg.Free;
    end;
  except
    // Ignore any decoding errors, result will be false
    //DoDebugOut(Self, wsFail, 'Exception in LoadBitmap');
  end;
end;

function TprThumbnail.LoadStream(S: TStream): boolean;
var
  Thumbs: TStream;
  Count: integer;
begin
  Result := False;
  try
    Thumbs := LockStream;
    try
      if (Pos >= 0) and assigned(Thumbs) then begin
        // Move to the right spot
        Thumbs.Seek(Pos + SizeOf(integer), soFromBeginning);
        Thumbs.Read(Count, SizeOf(integer));
        if Count > 0 then begin
          S.CopyFrom(Thumbs, Count);
          Result := True;
        end;
      end;
    finally
      UnlockStream;
    end;
  except
    // handled per default, Result indicates success
  end;
end;

function TprThumbnail.SaveBitmap(ABitmap: TBitmap): boolean;
var
  JPeg: TJPegImage;
  S: TStream;
begin
  // The backing file will hold a JPeg copy
  Result := False;
  if not assigned(ABitmap) then exit;

  try
    JPeg := TJPegImage.Create;
    try
      S := TMemoryStream.Create;
      try
        JPeg.CompressionQuality := FStoreThumbJPGQual;
        JPeg.Assign(ABitmap);
        JPeg.SaveToStream(S);
        S.Seek(0, soFromBeginning);
        Result := SaveStream(S);
      finally
        S.Free;
      end;
    finally
      JPeg.Free;
    end;
  except
    //ignore any encoding errors
  end;
end;

function TprThumbnail.SaveStream(S: TStream): boolean;
var
  Thumbs: TStream;
  Count, Next: integer;
begin
  Result := False;
  try
    Thumbs := LockStream;
    try
      if assigned(Thumbs) then begin
        Count := S.Size;
        if (Pos >= 0) then begin
          // Move to the right spot
          Thumbs.Seek(Pos, soFromBeginning);
          Thumbs.Read(Next, SizeOf(integer));
          if (Next - Pos - SizeOf(integer) < Count) then begin
            // Does not fit
            FindSpot(Count);
          end;
        end else
          // New
          FindSpot(Count);

        // We're now at the right spot so write away
        Thumbs := GetStream;
        if Thumbs.Position = Thumbs.Size then begin
          Next := Thumbs.Position + sizeof(integer)*2 + Count;
          Thumbs.Write(Next, sizeof(integer));
        end else
          Thumbs.Read(Next, sizeof(integer));

        Thumbs.Write(Count, sizeof(integer));
        Thumbs.CopyFrom(S, Count);
        Result := True;
      end;
    finally
      UnlockStream;
    end;
  except
    // handled per default, Result indicates success
  end;
end;

procedure TprThumbnail.ReadComponents(S: TStream);
var
  Ver: byte;
begin
  inherited;
  // Read Version No
  StreamReadByte(S, Ver);
  StreamReadInteger(S, FPos);
  StreamReadInteger(S, FWidth);
  StreamReadInteger(S, FHeight);
end;

procedure TprThumbnail.WriteComponents(S: TStream);
begin
  inherited;
  // Write Version No
  StreamWriteByte(S, 10);
  StreamWriteInteger(S, FPos);
  StreamWriteInteger(S, FWidth);
  StreamWriteInteger(S, FHeight);
end;

end.
