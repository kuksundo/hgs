{  unit RotatesExifOri

  This unit implements auto-rotation of JPG images based on the EXIF orientation
  flag

  Modifications:
  28-May-2004: Added check for first-byte orientation info (some cameras like
    Canon A80 seem to put it there)

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit guiRotateExif;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Grids, Mask, rxToolEdit, ExtCtrls, {$warnings off}FileCtrl, {$warnings on}
  ComCtrls, ActnList, ImgList, Contnrs, RXSpin, sdItems, NativeXml,
  Lossless, sdAbcVars;

type

  TBatchRotateExifOriItem = class
  public
    Icon: integer;      // Icon index in system image list
    Ref: TsdItem;         // Pointer to the TItem
    Name: string;
    Error: word;        // 0 = ok; 1 = wrong filetype; 2 = no exif info
    Scanned: boolean;   // Did we scan the EXIF info?
    Value: string;
    SPos: integer;
    Raw: string;
    NumVal: integer;
    Action: TLosslessAction;
  end;

  TfrmRotateExifOri = class(TForm)
    Label2: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    GroupBox2: TGroupBox;
    lvFiles: TListView;
    BitBtn4: TBitBtn;
    alRename: TActionList;
    ilRename: TImageList;
    RemoveFromList: TAction;
    BitBtn5: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure lvFilesData(Sender: TObject; Item: TListItem);
    procedure RemoveFromListExecute(Sender: TObject);
    procedure alRenameUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure FormDestroy(Sender: TObject);
  protected
    FOnDebugOut: TsdDebugEvent;
    procedure DoDebugOut(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String);
  public
    FBatches: TObjectList;
    procedure SetFilesFromSelection(AList: TList);
    procedure SetNotification;
    procedure DoRotateExifOri;
    property OnDebugOut: TsdDebugEvent read FOnDebugOut write FOnDebugOut;
  end;

var
  frmRotateExifOri: TfrmRotateExifOri;

implementation

uses
  Links, sdMetadataExif, guiFeedback, guiMain;

const

  cDateFormat = 'YYYY:MM:DD HH:NN:SS';
  cTimeFormat = 'HH:MM:SS';

{$R *.DFM}

procedure TfrmRotateExifOri.FormCreate(Sender: TObject);
begin
  // Initialization
  lvFiles.SmallImages := FSmallIcons;
  FBatches := TObjectList.Create;
end;

procedure TfrmRotateExifOri.SetNotification;
var
  i, ARotCount: integer;
begin
  if not assigned(FBatches) then
    exit;
  ARotCount := 0;
  for i := 0 to FBatches.Count - 1 do
    if TBatchRotateExifOriItem(FBatches[i]).NumVal > 0 then
      inc(ARotCount);
  Label3.Caption:=Format('You''re about to rotate/flip %d of these %d images based on the EXIF orientation flag.',
    [ARotCount, FBatches.Count]);
end;

procedure TfrmRotateExifOri.SetFilesFromSelection(AList: TList);
var
  i: integer;
  Batch: TBatchRotateExifOriItem;
  AExif, AChild, ATag: TXmlNode;
  OldCursor: TCursor;
  Xml: TNativeXml;
begin
  if not assigned(AList) then
    exit;
  OldCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    // Create the object list
    for  i := 0 to AList.Count - 1 do
    begin
      if TsdItem(AList[i]).ItemType in [itFile] then
      begin
        Batch := TBatchRotateExifOriItem.Create;
        Batch.Ref := AList[i];
        Batch.Name := TsdFile(AList[i]).FileName;
        Batch.Icon := TsdItem(AList[i]).Icon;
        Batch.Error := 0;
        if UpperCase(ExtractFileExt(Name)) <> '.JPG' then
        begin
          Batch.Error := 1;
        end;
        if Batch.Error = 0 then
        begin
          Batch.Error := 2;
          // Get the EXIF info
          Xml := TNativeXml.CreateName('exif');
          AExif := Xml.Root;
          try
            Batch.Ref.GetTags(AExif);
            // Try to find the 'Exif' tags
            AChild := AExif.NodeByName('EXIF');
            if assigned(AChild) then
            begin
              // Start position of EXIF info in the file
              Batch.SPos := StrToInt('$' + AChild.AttributeByName['SPOS'].Value);
              // DateTime field
              ATag := AChild.NodeByName('Orientation');
              if assigned(ATag) then
              begin
                Batch.Error := 0;
                Batch.Value := ATag.Value;
                // Stream position
                Batch.SPos := Batch.SPos + StrToInt('$' + ATag.AttributeByName['SPOS'].Value);
                // Raw value
                Batch.Raw := ATag.AttributeByName['RDAT'].Value;
                // Bias in case RAW is longer than one byte
                inc(Batch.SPos, length(Batch.Raw) div 2 - 1);
                // Get numeric value
                Batch.NumVal := StrToIntDef('$' + Batch.Raw, 0);
                // Some cameras put the value in the first byte (e.g. Canon A80)!
                if Batch.NumVal >= 256 then
                  Batch.NumVal := Batch.NumVal div 256;
                // Decide what to do
                case Batch.NumVal of
                2: Batch.Action := laFlipHor;
                3: Batch.Action := laRotate180;
                4: Batch.Action := laFlipVer;
                6: Batch.Action := laRotateRight;
                8: Batch.Action := laRotateLeft;
                else
                  Batch.Numval := 0;
                end;//case
              end;
            end;
          finally
            Xml.Free;
          end;
        end;
        FBatches.Add(Batch);
      end;
    end;
    lvFiles.Items.Count := FBatches.Count;
    SetNotification;
  finally
    Screen.Cursor := OldCursor;
  end;
end;

procedure TfrmRotateExifOri.lvFilesData(Sender: TObject; Item: TListItem);
var
  Batch: TBatchRotateExifOriItem;
begin
  if Item.Index < FBatches.Count then
  begin
    Batch := TBatchRotateExifOriItem(FBatches[Item.Index]);
    try
      Item.Caption := ExtractFileName(Batch.Name);
      Item.ImageIndex := Batch.Icon;
      // Exif orientation
      case Error of
      0: Item.Subitems.Add(Batch.Value);
      1: Item.SubItems.Add('Must be JPG');
      2: Item.SubItems.Add('No EXIF info found');
      end;//case
      // Action
      case Error of
      0:
        case Batch.NumVal of
        2: Item.SubItems.Add('Flip Horizontal');
        3: Item.SubItems.Add('Rotate 180');
        4: Item.SubItems.Add('Flip Vertical');
        6: Item.SubItems.Add('Rotate Right');
        8: Item.SubItems.Add('Rotate Left');
        else
          Item.SubItems.Add('No Action');
        end;
      1,2: Item.SubItems.Add('No Action');
      end;
    except
      Item.Caption := '*error*';
    end;
  end;
  SetNotification;
end;

procedure TfrmRotateExifOri.RemoveFromListExecute(Sender: TObject);
var
  i: integer;
  Item: TListItem;
  Remove: TList;
begin
  Remove := TList.Create;
  try

    // Create temp remove list
    with lvFiles do
      if (SelCount > 0) then begin
        Item := Selected;
        repeat
          if Item.Selected then
            Remove.Add(FBatches[Item.Index]);
          Item := GetNextItem(Item, sdAll, [isSelected]);
        until Item = nil;
      end;

    // Remove the selected entries from the files list
    for i := 0 to Remove.Count - 1 do
      FBatches.Remove(Remove[i]);

    // Update
    lvFiles.Items.Count := FBatches.Count;
    lvFiles.Invalidate;
  finally
    Remove.Free;
  end;
end;

procedure TfrmRotateExifOri.alRenameUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  // Determine the state of the controls (actions)
  RemoveFromList.Enabled := lvFiles.SelCount > 0;
  Handled := True;
end;

procedure TfrmRotateExifOri.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FBatches);
end;

procedure TfrmRotateExifOri.DoRotateExifOri;
var
  i: integer;
  Source, Dest, FileName: string;
  Handle: integer;
  FileDate: integer;
  Batch: TBatchRotateExifOriItem;
  S: TFileStream;
  NoAction: byte;
  Lossless: TsdLossless;
begin
  FileDate := 0;
  // Only accepted extensions
  for i := FBatches.Count - 1 downto 0 do
    if TBatchRotateExifOriItem(FBatches[i]).Numval = 0 then
      FBatches.Delete(i);

  if FBatches.Count > 0 then
  begin

    Feedback.Start;
    try
      Feedback.Add(Format('Rotating %d item(s) using EXIF orientation',
        [FBatches.Count]));
      // Loop through files
      for i := 0 to FBatches.Count - 1 do
      begin
        Batch := TBatchRotateExifOriItem(FBatches[i]);

        FileName := Batch.Name;
        Feedback.Info := Format('%s item %d of %d (%s)',
          [cLosslessActionVerb[Batch.Action], i + 1, FBatches.Count, FileName]);

        Source := 'source.jpg';
        Dest   := 'destin.jpg';

        // Get original file date
        Handle := FileOpen(FileName, fmOpenRead + fmShareDenyNone);
        if Handle > 0 then
        begin
          FileDate := FileGetDate(Handle);
          FileClose(Handle);
        end;

        try

          // turn our watchdog off
          inc(FShellNotifyRef);
          try
            Lossless := TsdLossless.Create;
            try
              //todoLossless.OnDebugOut := DoDebugOut;

              Lossless.CopyFileNoWarning(FileName, FAppFolder + Source);

              // Do the lossless operation
              if Lossless.CommandPromptLossless(FAppFolder, Source, Dest, Batch.Action) then
              begin

                // Move the file back
                Lossless.MoveFileNoWarning(FAppFolder + Dest, FileName);

                // Process the EXIF so the orientation tag is $01
                S := TFileStream.Create(FileName, fmOpenReadWrite or fmShareDenyWrite);
                try
                  S.Seek(Batch.SPos, soFromBeginning);
                  // Write $01 to the position given in SPos (the position of the EXIF tag)
                  // The value of $01 means "normal orientation"
                  NoAction := 1;
                  S.Write(NoAction, 1);
                finally
                  S.Free;
                end;

                // Set original file date
                Handle := FileOpen(FileName, fmOpenWrite + fmShareDenyNone);
                if Handle > 0 then begin
                  FileSetDate(Handle, FileDate);
                  FileClose(Handle);
                end;
              end;

            finally
              Lossless.Free;
            end;
          finally
            // turn our watchdog back on
            dec(FShellNotifyRef);
          end;
          // Update feedback
          Feedback.edStatus.Lines.Add(Format('File %s processed OK', [FileName]));
        except
          DoDebugOut(Self, wsFail, 'Exception in RotatesExifOri');
        end;
        Feedback.Progress := (i + 1) / FBatches.Count * 100;
        // Since its rotated, its graphic needs to be reloaded
        Batch.Ref.Update([ufGraphic]);
      end;
      if Feedback.ErrorCount > 0 then
        Feedback.Status := tsError
      else
        Feedback.Status := tsCompleted;
    finally
      Feedback.Finish;
    end;

  end;

end;

procedure TfrmRotateExifOri.DoDebugOut(Sender: TObject;
  WarnStyle: TsdWarnStyle; const AMessage: Utf8String);
begin
  if assigned(FOnDebugOut) then
    FOnDebugOut(Sender, WarnStyle, AMessage);
end;

end.
