{ Unit DeleteFiles

  "Delete Files" dialog box.

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit guiDeleteFile;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Grids, Mask, rxToolEdit, ExtCtrls, ComCtrls, sdAbcVars;

type

  TDeletionMethod = (dmRecycleBin, dmMovetoArchive, dmMovetoZip, dmDelete);

  TfrmDeleteFiles = class(TForm)
    Label2: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    raRecycle: TRadioButton;
    raMoveToArchive: TRadioButton;
    edArchiveFolder: TDirectoryEdit;
    btnRemove: TBitBtn;
    raDelete: TRadioButton;
    Image1: TImage;
    Image2: TImage;
    raMoveToZip: TRadioButton;
    Image3: TImage;
    edZipFile: TFilenameEdit;
    lvFiles: TListView;
    BitBtn4: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure raRecycleClick(Sender: TObject);
    procedure raMoveToArchiveClick(Sender: TObject);
    procedure raDeleteClick(Sender: TObject);
    procedure edArchiveFolderExit(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure lvFilesData(Sender: TObject; Item: TListItem);
    procedure raMoveToZipClick(Sender: TObject);
  private
    { Private declarations }
    FFileList: TList;
    FUndoList: TList;
    procedure SetFileList(Value: TList);
  public
    FNumFiles,                // Number of files in Filelist
    FNumBytes: int64;         // Number of bytes to clear
    FMethod: TDeletionMethod; // Deletion method
    property FileList: TList read FFileList write SetFileList;
    property UndoList: TList read FUndoList write FUndoList;
    { Public declarations }
    procedure SetNotification;
  end;

var
  frmDeleteFiles: TfrmDeleteFiles;

implementation

uses
  sdItems;

{$R *.DFM}

procedure TfrmDeleteFiles.FormCreate(Sender: TObject);
begin

  // Initialization
  if FUseRecycleBin then
    FMethod := dmRecycleBin
  else
    FMethod := dmDelete;

  if length(FArchiveFolder) = 0 then
    FArchiveFolder := FAppFolder + 'Archive\';

  edArchiveFolder.Text := ExcludeTrailingPathDelimiter(FArchiveFolder);

  edZipFile.Text := FZipFileName;

  lvFiles.SmallImages := FSmallIcons;

end;

procedure TfrmDeleteFiles.SetNotification;
var
  i: integer;
begin

  if not assigned(FFileList) then
    exit;

  // Calculate profit
  FNumFiles := 0;
  FNumBytes := 0;

  for i := 0 to FFileList.Count - 1 do
  begin
    inc(FNumFiles);
    inc(FNumBytes, TsdFile(FFileList[i]).Size);
  end;

  lvFiles.Items.Count := FFileList.Count;
  lvFiles.Invalidate;

  case FMethod of
  dmRecyclebin:
    Label3.Caption:=Format('You''re about to put these %d files into the recycle bin,',
      [FNumFiles]);
  dmMovetoArchive:
    Label3.Caption:=Format('You''re about to move these %d files to folder %s,',
      [FNumFiles, FArchiveFolder]);
  dmMovetoZip:
    Label3.Caption:=Format('You''re about to move these %d files to ZIP archive "%s",',
      [FNumFiles, FZipFileName]);
  dmDelete:
    Label3.Caption:=Format('You''re about to permanently delete these %d files,',
      [FNumFiles]);
  end;//case

  Label4.Caption:=Format('clearing approximately %s kB of diskspace.',
      [IntToStr(round(FNumBytes/1024))]);

end;

procedure TfrmDeleteFiles.raRecycleClick(Sender: TObject);
begin
  FMethod := dmRecycleBin;
  edArchiveFolder.Hide;
  edZipFile.Hide;
  FUseRecycleBin := true;
  SetNotification;
end;

procedure TfrmDeleteFiles.raMoveToArchiveClick(Sender: TObject);
begin
  FMethod := dmMovetoArchive;
  edArchiveFolder.Show;
  edArchiveFolder.SetFocus;
  edZipFile.Hide;
  SetNotification;
end;

procedure TfrmDeleteFiles.raMoveToZipClick(Sender: TObject);
begin
  FMethod := dmMovetoZip;
  edArchiveFolder.Hide;
  edZipFile.Show;
  edZipFile.SetFocus;
  SetNotification;
end;

procedure TfrmDeleteFiles.raDeleteClick(Sender: TObject);
begin
  if MessageDlg(
    'You are strongly discouraged to use this option.'#13#13+
    'All files removed using this option are permanently deleted and'#13+
    'cannot be recovered!'#13#13+
    'Do you really want to select this option?',mtWarning, mbYesNoCancel, 0) =
    mrYes then begin
    FMethod := dmDelete;
    edArchiveFolder.Hide;
    edZipFile.Hide;
    FUseRecycleBin := false;
  end else
    raRecycle.Checked:=true;
  SetNotification;
end;

procedure TfrmDeleteFiles.edArchiveFolderExit(Sender: TObject);
begin
  FArchiveFolder := IncludeTrailingPathDelimiter(edArchiveFolder.Text);
  if ForceDirectories(FArchiveFolder) then
    edArchiveFolder.Text := ExcludeTrailingPathDelimiter(FArchiveFolder);
end;

procedure TfrmDeleteFiles.btnRemoveClick(Sender: TObject);
var
  i: integer;
  Item: TListItem;
  RemoveList: TList;
begin

  RemoveList := TList.Create;
  try

    // Create temp remove list
    with lvFiles do
      if (SelCount > 0) then
      begin
        Item := Selected;
        repeat
          if Item.Selected then
            RemoveList.Add(FFileList[Item.Index]);
          Item := GetNextItem(Item, sdAll, [isSelected]);
        until Item = nil;
      end;

    // Remove the selected entries from the files list
    for i := 0 to RemoveList.Count - 1 do
    begin
      FileList.Remove(RemoveList[i]);
      if assigned(UndoList) then
        UndoList.Add(RemoveList[i]);
    end;

  finally
    RemoveList.Free;
  end;

  SetNotification;
end;

procedure TfrmDeleteFiles.SetFileList(Value: TList);
begin
  FFileList := Value;
  SetNotification;
end;

procedure TfrmDeleteFiles.lvFilesData(Sender: TObject; Item: TListItem);
var
  AFile: TsdFile;
  AIcon: integer;
  AType: string;
begin
  //
  if Item.Index < FFileList.Count then
  begin
    AFile := TsdFile(FFileList[Item.Index]);
    //with AFile do begin
      AFile.GetIconAndType(AIcon, AType);
      Item.Caption := AFile.Name;
      Item.ImageIndex := AIcon;
      Item.SubItems.Add(FormatFloat('#,##0', AFile.Size));
      Item.SubItems.Add(AFile.FolderName);
    //end;
  end else
    Item.Caption := '*error*';
end;

end.
