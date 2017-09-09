unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls, Menus, Variants, Vcl.ImgList;

type
  TfrmMain = class(TForm)
    tvFolders: TTreeView;
    splitter: TSplitter;
    pnlItems: TPanel;
    lvItems: TListView;
    ItemSplitter: TSplitter;
    lvAttachments: TListView;
    memoItem: TMemo;
    imgAttachment: TImageList;
    lblListMessages: TLabel;
    lblMessageBody: TLabel;
    lblAttachments: TLabel;
    pmAttachments: TPopupMenu;
    Savetodisk1: TMenuItem;
    SaveDialog: TSaveDialog;
    lblLogo: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure tvFoldersChange(Sender: TObject; Node: TTreeNode);
    procedure FormDestroy(Sender: TObject);
    procedure lvItemsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure lvItemsDeletion(Sender: TObject; Item: TListItem);
    procedure Savetodisk1Click(Sender: TObject);
    procedure lblLogoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ClearTVItems;

    procedure RetrieveOutlookFolders;
    procedure RetrieveFolderItems;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.DFM}

uses ActiveX, ComObj, ShellAPI;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  RetrieveOutlookFolders;
end;

procedure TfrmMain.RetrieveOutlookFolders;

  procedure LoadFolder(ParentNode: TTreeNode; Folder: OleVariant);
  var
    i: Integer;
    node: TTreeNode;
  begin
    for i := 1 to Folder.Count do
    begin
      node := tvFolders.Items.AddChildObject(ParentNode,
                                             Folder.Item[i].Name,
                                             TObject(LongInt(NewStr(Folder.Item[i].EntryID))));

      LoadFolder(node, Folder.Item[i].Folders);
    end;
  end;

var
  outlook, NameSpace: OLEVariant;
begin
  outlook := CreateOleObject('Outlook.Application');
  NameSpace := outlook.GetNameSpace('MAPI');

  LoadFolder(nil, NameSpace.Folders);

  outlook := UnAssigned;
end;

procedure TfrmMain.ClearTVItems;
var
  i: Integer;
begin
  for i := 0 to tvFolders.Items.Count-1 do
    DisposeStr(PAnsiString(tvFolders.Items[i].Data));
  tvFolders.Items.Clear;
end;

procedure TfrmMain.RetrieveFolderItems;

  procedure AddColumn(strCaption: string; intWidth: Integer);
  begin
    with lvItems.Columns.Add do
    begin
      Caption := strCaption;
      Width := intWidth;
    end;
  end;

const
  olMailItem = $00000000;
  olAppointmentItem = $00000001;
  olContactItem = $00000002;
  olTaskItem = $00000003;
  olJournalItem = $00000004;
  olNoteItem = $00000005;
  olPostItem = $00000006;

var
  outlook, NameSpace, Folder: OLEVariant;
  i, intFolderType: Integer;
begin
  outlook := CreateOleObject('Outlook.Application');
  NameSpace := outlook.GetNameSpace('MAPI');
  Folder := NameSpace.GetFolderFromID(PAnsiString(tvFolders.Selected.Data)^);
  intFolderType := Folder.DefaultItemType;

  {create structure(columns equals to fields) of selected item}
//  lvItems.Items.BeginUpdate;

  lvItems.OnChange := nil;
  lvItems.Columns.Clear;
  lvItems.Items.Clear;

  case intFolderType of
    olMailItem: begin
                  AddColumn('SenderName', 80);
                  AddColumn('Subject', 250);
                  AddColumn('Received', 80);
                  AddColumn('RecipientName', 80);
                end;
    olAppointmentItem: begin
                         AddColumn('Subject', 300);
                         AddColumn('ReplyTime', 50);
                       end;
    olContactItem: begin
                     AddColumn('FullName', 150);
                     AddColumn('Email', 150);
                   end;
    olTaskItem: begin
                  AddColumn('SenderName', 80);
                  AddColumn('DueDate', 80);
                  AddColumn('PercentComplete', 80);
                end;
    olJournalItem: begin
                     AddColumn('SenderName', 50);
                   end;
    olNoteItem: begin
                  AddColumn('Subject', 250);
                  AddColumn('CreationTime', 80);
                  AddColumn('LastModificationTime', 80);
                end;
    olPostItem: begin
                  AddColumn('SenderName', 80);
                  AddColumn('Subject', 250);
                  AddColumn('ReceivedTime', 80);
                end;
  end;

  {iterate Folder items}
  for i := 1 to Folder.Items.Count do
  begin
    if VarIsNull(Folder.Items[i]) or
       VarIsEmpty(Folder.Items[i]) then
      continue;

    with lvItems.Items.Add do
    begin
      try
        case intFolderType of
          olMailItem: begin
                        Caption := VarToStr(Folder.Items[i].SenderName);
                        SubItems.Add(Folder.Items[i].Subject);
                        SubItems.Add(Folder.Items[i].ReceivedTime);
                        SubItems.Add(Folder.Items[i].ReceivedByName);
                      end;
          olAppointmentItem: begin
                               Caption := Folder.Items[i].Subject;
                               SubItems.Add(Folder.Items[i].ReplyTime);
                             end;
          olContactItem: begin
                           Caption := Folder.Items[i].FullName;
                           SubItems.Add(Folder.Items[i].Email);
                         end;
          olTaskItem: begin
                        Caption := Folder.Items[i].SenderName;
                        SubItems.Add(Folder.Items[i].DueDate);
                        SubItems.Add(Folder.Items[i].PercentComplete);
                      end;
          olJournalItem: begin
                           Caption := Folder.Items[i].SenderName;
                         end;
          olNoteItem: begin
                        Caption := Folder.Items[i].Subject;
                        SubItems.Add(Folder.Items[i].CreationTime);
                        SubItems.Add(Folder.Items[i].LastModificationTime);
                      end;
          olPostItem: begin
                        Caption := VarToStr(Folder.Items[i].SenderName);
                        SubItems.Add(Folder.Items[i].Subject);
                        SubItems.Add(Folder.Items[i].ReceivedTime);
                      end;
        end;
      except
      end;
      Data := TObject(LongInt(NewStr(Folder.Items[i].EntryID)));
    end;
  end;
//  lvItems.Items.EndUpdate;

  lvItems.OnChange := lvItemsChange;
  outlook := UnAssigned;
end;

procedure TfrmMain.tvFoldersChange(Sender: TObject; Node: TTreeNode);
begin
  memoItem.Lines.Clear;
  lvAttachments.Items.Clear;

  RetrieveFolderItems;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
//  ClearTVItems;
end;

procedure TfrmMain.lvItemsChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var
  outlook, NameSpace, ItemOL: OLEVariant;
  i: Integer;
begin
  {fill a body of selected item}
  memoItem.Lines.Clear;
  lvAttachments.Items.Clear;

  if Assigned(lvItems.Selected) then
  begin
    outlook := CreateOleObject('Outlook.Application');
    NameSpace := outlook.GetNameSpace('MAPI');
    ItemOL := NameSpace.GetItemFromID(PAnsiString(lvItems.Selected.Data)^);

    if not VarIsNull(ItemOL) and not VarIsEmpty(ItemOL) then
    begin
      memoItem.Lines.Add(ItemOL.Body);
      for i := 1 to itemOL.Attachments.Count do
        with lvAttachments.Items.Add do
          Caption := itemOL.Attachments.Item(i);

      {set a current position of cursor to start}
      SendMessage(memoItem.Handle, EM_SETSEL, 0, 0);

      {scroll a memo to start position}
      SendMessage(memoItem.Handle, EM_SCROLLCARET, 0, 0);
    end;

    outlook := UnAssigned;
  end;
end;

procedure TfrmMain.lvItemsDeletion(Sender: TObject; Item: TListItem);
begin
  DisposeStr(PAnsiString(Item.Data));
end;

procedure TfrmMain.Savetodisk1Click(Sender: TObject);
var
  outlook, NameSpace, ItemOL: OLEVariant;
begin
  if Assigned(lvItems.Selected) and
     Assigned(lvAttachments.Selected) then
  begin
    SaveDialog.FileName := lvAttachments.Selected.Caption;
    if not SaveDialog.Execute then exit;

    outlook := CreateOleObject('Outlook.Application');
    NameSpace := outlook.GetNameSpace('MAPI');
    ItemOL := NameSpace.GetItemFromID(PString(lvItems.Selected.Data)^);

    if not VarIsNull(ItemOL) and not VarIsEmpty(ItemOL) then
      itemOL.Attachments.Item(lvAttachments.Selected.Index+1).SaveAsFile(SaveDialog.FileName);

    outlook := UnAssigned;
  end;

end;

procedure TfrmMain.lblLogoClick(Sender: TObject);
begin
  ShellExecute(0, 'open', 'http://www.scalabium.com', nil, nil, SW_SHOWNORMAL);
end;

end.
