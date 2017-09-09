{ unit RenameFiles

  Batch renaming implementation

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit guiRenameFiles;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Grids, Mask, rxToolEdit, ExtCtrls, {$warnings off}FileCtrl, {$warnings on}
  ComCtrls, ActnList, ImgList, Contnrs, RXSpin, sdItems, sdAbcVars, sdAbcFunctions;

type

  TBatchRenameItem = class
  public
    Icon: integer;      // Icon index in system image list
    Ref: TsdItem;       // Pointer to the TItem
    Indiv: boolean;     // Use individual naming for this item
    Folder: string;     // Folder name
    NewName: string;    // New (calculated) filename
    Number: integer;    // Sequence number to use for this rename
    OldName: string;    // Old filename
    StripName: string;  // Old filename, stripped and decoded
    UseMask: boolean;   // Use masking for this item
    Conflict: boolean;  // Collision is detected for this item
  end;

  TfrmRenameFiles = class(TForm)
    Label2: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    lvFiles: TListView;
    BitBtn4: TBitBtn;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edOldMask: TEdit;
    cbbNewMask: TComboBox;
    SpeedButton1: TSpeedButton;
    alRename: TActionList;
    ilRename: TImageList;
    ItemUp: TAction;
    ItemDown: TAction;
    SpeedButton2: TSpeedButton;
    RemoveFromList: TAction;
    BitBtn5: TBitBtn;
    GroupBox4: TGroupBox;
    rbCopyNumbers: TRadioButton;
    rbNewNumbers: TRadioButton;
    seNumber: TRxSpinEdit;
    chbPersistant: TCheckBox;
    GroupBox5: TGroupBox;
    chbStripName: TCheckBox;
    chbConvertURL: TCheckBox;
    chbConvertSpace: TCheckBox;
    CopyMask: TAction;
    SpeedButton3: TSpeedButton;
    chbForceMask: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure lvFilesData(Sender: TObject; Item: TListItem);
    procedure lvFilesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ItemUpExecute(Sender: TObject);
    procedure ItemDownExecute(Sender: TObject);
    procedure RemoveFromListExecute(Sender: TObject);
    procedure alRenameUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure lvFilesEdited(Sender: TObject; Item: TListItem;
      var S: String);
    procedure FormShow(Sender: TObject);
    procedure CopyMaskExecute(Sender: TObject);
    procedure ValidateControls(Sender: TObject);
  protected
    procedure DoPreviewNames;
    function GetOldMask: string;
    function ReplaceInvalidChars(Name: string; ReplaceChar: char): string;
    function StripAndDecodeFileName(AName: string): string;
  public
    FItems: TObjectList;
    procedure SetFilesFromSelection(Value: TList);
    procedure SetNotification;
  end;

const

  // These characters cannot be used in filenames
  cIllegalCharsInFileName: set of char =
    ['\', '/', ':', '*', '?', '"', '<', '>', '|'];

var
  frmRenameFiles: TfrmRenameFiles;

implementation

uses
  Links;

{$R *.DFM}

procedure TfrmRenameFiles.FormCreate(Sender: TObject);
begin
  // Initialization
  lvFiles.SmallImages := FSmallIcons;
  FItems := TObjectList.Create;
end;

procedure TfrmRenameFiles.SetNotification;
var
  i: integer;
  ConflictCount: integer;
begin
  if not assigned(FItems) then exit;

  // Do we need to warn for a collision?
  ConflictCount := 0;
  for i := 0 to FItems.Count - 1 do
    if TBatchRenameItem(FItems[i]).Conflict then
      inc(ConflictCount);

  if ConflictCount > 0 then begin
    Label3.Font.Color := clRed;
    Label3.Caption:=Format(
      'WARNING: %d of the %d files that you are about to rename have conflicting names!',
        [ConflictCount, FItems.Count])
  end else begin
    Label3.Font.Color := clBlack;
    Label3.Caption:=Format('You''re about to rename these %d files.',
        [FItems.Count]);
  end;
end;

function TfrmRenameFiles.GetOldMask: string;
var
  i: integer;
  Masks: TStringList;
  MaxPos, MaxCount, AMin, AMax, ACount: integer;
  AName: string;
begin
  Result := '';
  // Create a list of masks, and select the most frequent
  Masks := TStringList.Create;
  Masks.Sorted := True;
  Masks.Duplicates := dupAccept;
  try
    for i := 0 to FItems.Count - 1 do
      with TBatchRenameItem(FItems[i]) do begin
        // create a good reference name
        AName := ConvertURLCodedToFileName(StripFilenameOfCopy(OldName));
        // and use this in the mask
        Masks.Add(lowercase(MaskFromNumberFormat(AName, FSmartSelectMaskCount)));
      end;
    // Determine most frequent
    AMin := 0;
    MaxPos := 0;
    MaxCount := 1;
    while AMin < Masks.Count do begin
      AMax := AMin + 1;
      while (AMax < Masks.Count) and
        (Masks[AMax] = Masks[AMin]) do
        inc(AMax);
      ACount := AMax - AMin;
      if ACount > MaxCount then begin
        MaxPos := AMin;
        MaxCount := ACount;
      end;
      inc(AMin, ACount);
    end;

    // The most frequent mask
    if (Masks.Count > 0) then
      Result := Masks[MaxPos];
    // Avoid single masks
    if MaxCount <= 1 then
      Result := '';
  finally
    Masks.Free;
  end;
end;

function TfrmRenameFiles.ReplaceInvalidChars(Name: string; ReplaceChar: char): string;
var
  i: integer;
begin
  for i := 1 to length(Name) do
    if Name[i] in cIllegalCharsInFileName then
      Name[i] := ReplaceChar;
  Result := Name;
end;

function TfrmRenameFiles.StripAndDecodeFileName(AName: string): string;
var
  i: integer;
begin
  // Strip copy etc
  if chbStripName.Checked then
    AName := StripFileNameOfCopy(AName);

  // URL decode
  if chbConvertURL.Checked then
    AName := ConvertURLCodedToFileName(AName);

  // Space to underscore
  if chbConvertSpace.Checked then
    for i := 1 to Length(AName) do
      if AName[i] = ' ' then
        AName[i] := '_';

  Result := AName;
end;

procedure TfrmRenameFiles.DoPreviewNames;
var
  i: integer;
  SeqNo: integer;
begin
  // First pass: find stripped names and find out which files use the mask
  for i := 0 to FItems.Count - 1 do
    with TBatchRenameItem(FItems[i]) do begin
      if not Indiv then begin

        // Create a stripped and converted filename
        StripName := StripAndDecodeFileName(OldName);

        // Numbering and mask
        Number := NumberFromMaskAndName(edOldMask.Text, StripName);
        UseMask := chbForceMask.Checked or (Number >= 0)

      end;
    end;

  // Second pass: determine sequence numbers and new filename preview
  SeqNo := round(seNumber.Value);
  for i := 0 to FItems.Count - 1 do
    with TBatchRenameItem(FItems[i]) do begin
      if not Indiv then begin
        if UseMask then begin
          // Do the mask creation for this item
          if rbCopyNumbers.Checked then begin
            if Number < 0 then begin
              Number := SeqNo;
              inc(SeqNo);
            end;
            NewName := NumberFormatFromMask(cbbNewMask.Text, Number);
          end;
          if rbNewNumbers.Checked then begin
            NewName := NumberFormatFromMask(cbbNewMask.Text, SeqNo);
            inc(SeqNo);
          end;
        end else begin
          // No mask used for this item
          NewName := StripName;
        end;
        // Make sure NewName is a valid filename
        NewName := ReplaceInvalidChars(NewName, '_');
        // Copy extension
        if (ExtractFileExt(NewName) = '') and
           (ExtractFileExt(OldName) <> '') then
          NewName := NewName + ExtractFileExt(OldName);
      end;
    end;
  // Update the listview
  lvFiles.Items.Count := 0;
  lvFiles.Items.Count := FItems.Count;
  // Update the notification
  SetNotification;
end;

procedure TfrmRenameFiles.SetFilesFromSelection(Value: TList);
var
  i: integer;
  Item: TBatchRenameItem;
begin
  if not assigned(Value) then exit;
  // Create the object list
  for  i := 0 to Value.Count - 1 do
    if TsdItem(Value[i]).ItemType in [itFile, itFolder] then begin
      Item := TBatchRenameItem.Create;
      Item.Ref := Value[i];
      case TsdItem(Value[i]).ItemType of
      itFile:
        begin
          Item.OldName := TsdFile(Value[i]).Name;
          Item.Folder := TsdFile(Value[i]).FolderName;
        end;
      itFolder:
        begin
          Item.OldName := TsdFolder(Value[i]).Name;
          Item.Folder := TsdFolder(Value[i]).ParentFolderName;
        end;
      end;
      Item.NewName := '<calculating>';
      Item.Icon := TsdItem(Value[i]).Icon;
      FItems.Add(Item);
    end;
  SetNotification;
end;

procedure TfrmRenameFiles.lvFilesData(Sender: TObject; Item: TListItem);
var
  AFile: TBatchRenameItem;
// Local function
function HasDupe(Index: integer): boolean;
var
  i: integer;
  Item, Cur: TBatchRenameItem;
begin
  Result := False;
  Item := TBatchRenameItem(FItems[Index]);
  Item.Conflict := False;
  for i := 0 to FItems.Count - 1 do
    if (i <> Index) then begin
      Cur := TBatchRenameItem(FItems[i]);
      if (Item.Folder = Cur.Folder) and
         (lowercase(Item.NewName) = lowercase(Cur.NewName)) then begin
        Result := True;
        Item.Conflict := True;
        exit;
      end;
    end;
end;
// main
begin
  //
  if Item.Index < FItems.Count then begin
    AFile := TBatchRenameItem(FItems[Item.Index]);
    with AFile do begin
      Item.Caption := NewName;
      Item.ImageIndex := Icon;
      Item.SubItems.Add(OldName);
      if FileExists(NewName) and (NewName <> OldName) then
        Item.SubItems.Add('Yes')
      else begin
        if HasDupe(Item.Index) then
          Item.SubItems.Add('Yes')
        else
          Item.SubItems.Add('');
      end;
    end;
  end else
    Item.Caption := '*error*';
  SetNotification;
end;

procedure TfrmRenameFiles.lvFilesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_F2 then
    // Place in edit mode
    lvFiles.ItemFocused.EditCaption;
end;

procedure TfrmRenameFiles.ItemUpExecute(Sender: TObject);
begin
  // Move the current item up
  with lvFiles do
    if assigned(ItemFocused) and (ItemFocused.Index > 0) and (ItemFocused.Index < Items.Count) then begin
      FItems.Exchange(ItemFocused.Index - 1, ItemFocused.Index);
      ItemFocused := Items[ItemFocused.Index - 1];
      Selected := nil;
      Selected := ItemFocused;
      ValidateControls(Self);
    end;
end;

procedure TfrmRenameFiles.ItemDownExecute(Sender: TObject);
begin
  // Move the current item down
  with lvFiles do
    if assigned(ItemFocused) and (ItemFocused.Index >= 0) and (ItemFocused.Index < Items.Count - 1) then begin
      FItems.Exchange(ItemFocused.Index + 1, ItemFocused.Index);
      ItemFocused := Items[ItemFocused.Index + 1];
      Selected := nil;
      Selected := ItemFocused;
      ValidateControls(Self);
    end;
end;

procedure TfrmRenameFiles.RemoveFromListExecute(Sender: TObject);
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
            Remove.Add(FItems[Item.Index]);
          Item := GetNextItem(Item, sdAll, [isSelected]);
        until Item = nil;
      end;

    // Remove the selected entries from the files list
    for i := 0 to Remove.Count - 1 do
      FItems.Remove(Remove[i]);

  finally
    Remove.Free;
  end;
  ValidateControls(Self);
end;

procedure TfrmRenameFiles.alRenameUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  // Determine the state of the controls (actions)
  ItemUp.Enabled := lvFiles.SelCount = 1;
  ItemDown.Enabled := lvFiles.SelCount = 1;
  RemoveFromList.Enabled := lvFiles.SelCount > 0;
  Handled := True;
end;

procedure TfrmRenameFiles.FormDestroy(Sender: TObject);
begin
  if assigned(FItems) then
    FreeAndNil(FItems);
end;

procedure TfrmRenameFiles.lvFilesEdited(Sender: TObject; Item: TListItem;
  var S: String);
var
  AItem: TBatchRenameItem;
begin
  // The item is edited
  AItem := nil;
  if (Item.Index >= 0) and (Item.Index < FItems.Count) then
    AItem := TBatchRenameItem(FItems[Item.Index]);
  if assigned(AItem) then with AItem do begin
    NewName := ReplaceInvalidChars(S, '_');
    // Copy extension
    if (ExtractFileExt(NewName) = '') and
       (ExtractFileExt(OldName) <> '') then
      NewName := NewName + ExtractFileExt(OldName);
    Indiv := True;
  end;
  ValidateControls(Self);
end;

procedure TfrmRenameFiles.FormShow(Sender: TObject);
begin
  // Start the previewer
  edOldMask.Text := GetOldMask;
  CopyMaskExecute(Self);
  ValidateControls(Self);
end;

procedure TfrmRenameFiles.CopyMaskExecute(Sender: TObject);
begin
  cbbNewMask.Text := edOldMask.Text;
  ValidateControls(Self);
end;

procedure TfrmRenameFiles.ValidateControls(Sender: TObject);
begin
  // Validate the controls
  DoPreviewNames;
end;

end.
