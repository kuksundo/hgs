{ unit ZipFiles

  High-level routines to add files to a zip file

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!
}
unit Zipfiles;

interface

uses
  SysUtils, Classes, Controls, Forms, ItemLists, sdItems;

// MoveToZip will add the list of files in AList to a ZIP archive named
// AZipFile. if AZipFile does not yet exist, it will be created.
// AList is a list of pointers to TFile items.
// CAUTION: the original files will be deleted!
procedure MoveToZip(AList: TList; AZipFile: string; AProgressEvent: TStatusMessageEvent);

implementation

{$R ZIPMSGUS.RES}

uses
  ZipMstr, guiFeedback;

type

  TZipFeedback = class
  private
    FProcessedSize: int64;
    FCurrentSize: int64;
    FTotalFileSize: int64;
    FCurrentFile: string;
  public
    FZip: TZipMaster;
    procedure Progress(Sender : TObject; ProgrType: ProgressType;
      Filename: String; FileSize: Integer);
  end;

procedure TZipFeedback.Progress(Sender : TObject; ProgrType: ProgressType;
  Filename: String; FileSize: Integer);
// local
procedure DoProgress;
begin
  Feedback.Info := Format('Compressing file "%s"', [FCurrentFile]);
  Feedback.Progress := (FProcessedSize + FCurrentSize) / FZip.TotalSizeToProcess * 100;
end;
// main
begin
  case ProgrType of
  NewFile:
    begin
      FCurrentFile := FileName;

      // increment with the old file's total size
      inc(FProcessedSize, FTotalFileSize);
      // completed the task
      if FTotalFileSize > 0 then
        Feedback.Status := tsCompleted;

      // the new file's total size
      FTotalFileSize := FileSize;
      // reset the counter
      FCurrentSize := 0;

      DoProgress;
    end;
  ProgressUpdate:
    begin
      // increment the counter
      inc(FCurrentSize, FileSize);
      DoProgress;
    end;
  end;//case
end;

procedure MoveToZip(AList: TList; AZipFile: string; AProgressEvent: TStatusMessageEvent);
var
  FZip: TZipMaster;
  i: integer;
  ZipFeedback: TZipFeedback;
procedure DoProgress(AMsg: string);
begin
  if assigned(AProgressEvent) then
    AProgressEvent(Application, AMsg);
end;
begin
  Screen.Cursor := crHourGlass;

  DoProgress('Creating ZIP file...');

  // Create the zip archive master
  FZip := TZipMaster.Create(Application);

  // Feedback dialog
  Feedback.Start;

  // A special object that we need to receive the ZipMaster's OnProgress
  ZipFeedback := TZipFeedback.Create;
  ZipFeedback.FZip := FZip;
  try

    Feedback.Title := 'ABC-View ZIP file creation';

    // Add the tasks
    for i := 0 to AList.Count - 1 do
      Feedback.Add(Format('Adding %s to %s', [TsdFile(AList[i]).Name, ExtractFileName(AZipFile)]));
    // Delete task
    Feedback.Add('Deleting selected files');

    AZipFile := ExpandFilename(AZipFile);
    with FZip do
    begin

      // Any progress feedback should go to the user
      OnProgress := ZipFeedback.Progress;

      // Set the name of the zipfile
      ZipFileName := AZipFile;

      // Pass a list of files to archive
      for i := 0 to AList.Count - 1 do
        FSpecArgs.Add(TsdFile(AList[i]).FileName);

      // Options
      AddOptions :=
        [ AddDirNames,     // Store directory names
          AddHiddenFiles,  // Store hidden files
          AddMove ];        // Delete original - Dangerous!

      // Now we create the file and add the file list
      Add;

    end;

    // Last compress + delete task were completed
    Feedback.Status := tsCompleted;
    Feedback.Status := tsCompleted;
    DoProgress('Creation of ZIP file finished succesfully.');

  finally
    FZip.Free;
    Feedback.Finish;
    ZipFeedback.Free;
  end;
  Screen.Cursor := crDefault;
end;

end.
