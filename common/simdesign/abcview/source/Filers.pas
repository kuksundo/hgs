{ Unit Filers

  This unit handles loading/saving of the ABC-View file format

  How to use this unit:
  - Create a TFileIO object
  - Assign the object you want to store to property 'FileObject'
  - Assign an OnStatus event handler if you want to have status feedback
  - Call LoadFromFile / SaveToFile

  Features:
  - Compresses/Decompresses with LZH, which makes this filer very space-efficient

  To Do:
  - Most Recently Used (MRU) List: to be implemented
  - Make threaded version

  Initial release: 20-12-2000

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!
  
}
unit Filers;

interface

uses

  SysUtils, Classes, Controls, Forms, Dialogs, ItemLists;

const

{ Current Load/Save version, Change here when new filetype used }
  FileSignature   = 'ABC-VIEW';
  FileVersion     = '1.30';
  ApplicationName = 'ABCView';

type

  TStatusEvent = procedure(Sender: TObject; AMessage: string) of object;

  EFileIOError = class(Exception);

  TFileIO = class(TObject)
  private
    // property variables
    FOnStatus: TStatusEvent;
    FItemMngr: TItemMngr;
    FStream: TStream;
  protected
    procedure DoStatus(AMessage: string);
    procedure LoadProgress(Sender: TObject);
    procedure SaveProgress(Sender: TObject);
  public
    // events
    property OnStatus: TStatusEvent read FOnStatus write FOnStatus;
    property FileObject: TItemMngr read FItemMngr write FItemMngr;
    // methods
    procedure LoadFromFile(AFilename: TFilename);
    procedure SaveToFile(AFilename: TFilename);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);
  end;

var
  FCurrentLoadVer: string = '';

implementation

uses
  sdStreamableData, ZLib;


procedure TFileIO.DoStatus(AMessage: string);
begin
  if assigned(FOnStatus) then FOnStatus(Self, AMessage);
end;

procedure TFileIO.LoadProgress(Sender: TObject);
begin
  if assigned(FStream) then
    DoStatus(
      Format('Loading (%d kB)', [round(FStream.Position / 1024)]));
end;

procedure TFileIO.SaveProgress(Sender: TObject);
begin
  if assigned(FStream) then
    DoStatus(
      Format('Saving (%d kB)', [round(FStream.Position / 1024)]));
end;

procedure TFileIO.LoadFromFile(AFilename: TFilename);
// Load a catalog with filename 'AFilename'
var
  Main: TFileStream;
begin
  DoStatus(Format('Loading "%s"',[AFilename]));
  Main := TFileStream.Create(AFilename, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(Main);
  finally
    Main.Free;
  end;
end;

procedure TFileIO.SaveToFile(AFilename: TFilename);
var
  AStream: TFileStream;
begin
  DoStatus(Format('Saving "%s"',[AFilename]));
  AStream := TFileStream.Create(AFilename, fmCreate or fmShareDenyWrite);
  try
    SaveToStream(AStream);
  finally
    AStream.Free;
  end;
end;

procedure TFileIO.LoadFromStream(Stream: TStream);
var
  Sign: array[0..255] of char;
  Ver: string;
  Decom: TDecompressionStream;
begin

  try

    // Read signature
    Stream.ReadBuffer(Sign, Length(FileSignature));
    Sign[Length(FileSignature)] := #0;

    // Signature check
    if Sign <> FileSignature then
      raise EFileIOError.Create(
        'The selected file is not a valid file.');

    // Read Version
    StreamReadShortString(Stream, Ver);

    // Version check
    if Ver <> FileVersion then
      if Ver > FileVersion then begin
        if MessageDlg(
          Format('The selected file is made with a higher version of %s.',[ApplicationName])+#13#10+
          'Loading this file can cause unpredictable results.'+#13#10+
          'Do you want to try and load it anyway?',mtWarning,
          [mbOK, mbCancel],0) <> mrOK then exit;
      end else
        MessageDlg(Format('This file is made by a previous version of %s. File will be',[ApplicationName])+#13#10+
                   'converted for use with this version. Some features may be lost.',mtWarning,[mbOK],0);

    // assign to global variable
    FCurrentLoadVer := Ver;

    FStream := Stream;
    Decom := TDecompressionStream.Create(Stream);
    Decom.OnProgress := LoadProgress;
    try
      FItemMngr.ReadFromStream(Decom);
    finally
      Decom.Free;
      DoStatus('Loading finished');
    end;

  except
    on E: Exception do MessageDlg(E.Message,mtWarning, [mbOK], 0);
  end;
  DoStatus('Loading finished');

end;

procedure TFileIO.SaveToStream(Stream: TStream);
var
  Sign: array[0..255] of char;
  Compr: TCompressionStream;
begin
  try
    // Get a pointer for onprogress
    FStream := Stream;

    // Write signature
    Sign := FileSignature;
    Stream.WriteBuffer(Sign, Length(FileSignature));

    // Write version
    StreamWriteShortString(Stream, FileVersion);

    // Start a ZLIB compression stream
    Compr := TCompressionStream.Create(clDefault, Stream);
    Compr.OnProgress := SaveProgress;
    try
      // Send the object to the stream
      FItemMngr.WriteToStream(Compr);
    finally
      Compr.Free;
    end;
  except
    on E: Exception do MessageDlg(E.Message,mtWarning,[mbOK],0);
  end;
  DoStatus('Saving finished');

end;

end.
