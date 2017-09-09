{-----------------------------------------------------------------------------
 Unit Name: frmFailedBackupU
 Author: Tristan Marlow
 Purpose: Backup and Shutdown Backup Failed Backups.

 ----------------------------------------------------------------------------
 License
 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU Library General Public License as
 published by the Free Software Foundation; either version 2 of
 the License, or (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU Library General Public License for more details.
 ----------------------------------------------------------------------------

 History: 04/05/2007 - First Release.

-----------------------------------------------------------------------------}
unit frmFailedBackupU;

interface

uses
  BackupProfileU,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ComCtrls, ToolWin,
  JvMail, Menus, JvDialogs;

type
  TfrmFailedBackup = class(TForm)
    pnlBottom: TPanel;
    PageControlMain: TPageControl;
    pnlTop: TPanel;
    tabFailedProfiles: TTabSheet;
    tabLog: TTabSheet;
    ListBoxLog: TListBox;
    ToolBarLog: TToolBar;
    btnSave: TToolButton;
    Bevel1: TBevel;
    btnOk: TBitBtn;
    imgLeft: TImage;
    TimerAutoClose: TTimer;
    lblAutoClose: TLabel;
    ToolButton1: TToolButton;
    btnBack: TToolButton;
    PopupMenu: TPopupMenu;
    mnuShowLog: TMenuItem;
    N1: TMenuItem;
    mnuSaveLog: TMenuItem;
    mnuBack: TMenuItem;
    imgBackground: TImage;
    SaveDialog: TJvSaveDialog;
    ListViewFailedProfiles: TListView;
    lblHeader: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimerAutoCloseTimer(Sender: TObject);
    procedure lblAutoCloseClick(Sender: TObject);
    procedure lblAutoCloseMouseEnter(Sender: TObject);
    procedure lblAutoCloseMouseLeave(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure ListViewFailedProfilesDblClick(Sender: TObject);
  private
    FAutoCloseTimeout : Integer;
    FBackupProfileManager : TBackupProfileManager;
    procedure UpdateProfileList;
  public
    procedure Execute(ABackupProfileManager : TBackupProfileManager; AAutoCloseTimeout : Integer = 60);
  end;

var
  frmFailedBackup: TfrmFailedBackup;

implementation

{$R *.dfm}

uses
  dlgProgressU;


procedure TfrmFailedBackup.UpdateProfileList;
var
  Idx : Integer;
  BackupProfile : TBackupProfile;
  ListItem : TListItem;
begin
  ListViewFailedProfiles.Items.Clear;
  with FBackupProfileManager do
    begin
      For Idx := 0 to Pred(Queue.Count) do
      begin
        with Queue.Item[Idx] do
        begin
          if QueueStatus in [qsFailed,qsCancelled] then
            begin
              BackupProfile := FBackupProfileManager.ProfileByName(ProfileName);
              ListItem := ListViewFailedProfiles.Items.Add;
              with ListItem do
                begin
                  case QueueStatus of
                    qsPending: Caption := 'Pending';
                    qsInProgress: Caption := 'In Progress';
                    qsComplete: Caption := 'Complete';
                    qsFailed: Caption := 'Failed';
                    qsCancelled: Caption := 'Cancelled';
                  end;
                  SubItems.Add(BackupProfile.ProfileName);
                  SubItems.Add(BackupProfile.LogFile);
                end;
            end;
        end;
    end;
    end;
end;


procedure TfrmFailedBackup.Execute(ABackupProfileManager : TBackupProfileManager; AAutoCloseTimeout : Integer = 60);
begin
  FAutoCloseTimeout := AAutoCloseTimeout;
  FBackupProfileManager := ABackupProfileManager;
  TimerAutoClose.Enabled := (FAutoCloseTimeout > 0);
  Self.ShowModal;
end;

procedure TfrmFailedBackup.FormShow(Sender: TObject);
begin
  PageControlMain.ActivePageIndex := 0;
  lblAutoClose.Caption := Format('Dialog will automatically close in %d second(s)',[FAutoCloseTimeOut]);
  lblAutoClose.Visible := TimerAutoClose.Enabled;
  UpdateProfileList;
  ListViewFailedProfiles.SetFocus;
end;

procedure TfrmFailedBackup.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  PageControlMain.ActivePageIndex := 0;
  TimerAutoClose.Enabled := False;
  lblAutoClose.Visible := False;
end;

procedure TfrmFailedBackup.TimerAutoCloseTimer(Sender: TObject);
begin
  Dec(FAutoCloseTimeOut);
  lblAutoClose.Visible := True;
  lblAutoClose.Caption := Format('Dialog will automatically close in %d second(s)',[FAutoCloseTimeOut]);
  if FAutoCloseTimeOut <= 0 then Self.Close;
end;

procedure TfrmFailedBackup.lblAutoCloseClick(Sender: TObject);
begin
  TimerAutoClose.Enabled := False;
  lblAutoClose.Visible := False;
end;

procedure TfrmFailedBackup.lblAutoCloseMouseEnter(Sender: TObject);
begin
  lblAutoClose.Cursor := crHandPoint;
  lblAutoClose.Font.Style := [fsUnderline];
  lblAutoClose.Font.Color := clBlue;
end;

procedure TfrmFailedBackup.lblAutoCloseMouseLeave(Sender: TObject);
begin
  lblAutoClose.Cursor := crDefault;
  lblAutoClose.Font.Style := [];
  lblAutoClose.Font.Color := clWindowText;
end;

procedure TfrmFailedBackup.btnSaveClick(Sender: TObject);
begin
  lblAutoCloseClick(nil);
  if SaveDialog.Execute then
    begin
      ListBoxLog.Items.SaveToFile(SaveDialog.FileName);
    end;
end;

procedure TfrmFailedBackup.FormCreate(Sender: TObject);
var
  i : Integer;
begin
  for i := 0 to Pred(PageControlMain.PageCount) do
    begin
      PageControlMain.Pages[i].TabVisible := False;
    end;
  PageControlMain.ActivePageIndex := 0;
end;

procedure TfrmFailedBackup.btnBackClick(Sender: TObject);
begin
  PageControlMain.ActivePage := tabFailedProfiles;
end;

procedure TfrmFailedBackup.PopupMenuPopup(Sender: TObject);
begin
  if PageControlMain.ActivePage = tabFailedProfiles then
    begin
      mnuShowLog.Visible := True;
      mnuBack.Visible := False;
    end;
  if PageControlMain.ActivePage = tabLog then
    begin
      mnuShowLog.Visible := False;
      mnuBack.Visible := True;
    end;
end;

procedure TfrmFailedBackup.ListViewFailedProfilesDblClick(Sender: TObject);
var
  FileName : TFileName;
  dlgProgress : TdlgProgress;
begin
  dlgProgress := TdlgProgress.Create(Self);
  try
  dlgProgress.Show('Loading log file, please wait...',psNone);
  if ListViewFailedProfiles.ItemIndex <> -1 then
    begin
      lblAutoCloseClick(nil);
      FileName := ListViewFailedProfiles.Items[ListViewFailedProfiles.ItemIndex].SubItems[1];
      PageControlMain.ActivePage := tabLog;
      if FileExists(FileName) then
        begin
          ListBoxLog.Items.LoadFromFile(FileName);
        end else
        begin
          ListBoxLog.Items.Clear;
          ListBoxLog.Items.Add(Format('No log file available: "%s".',[Filename]));
        end;
    end;
   dlgProgress.Hide;
  finally
    FreeAndNil(dlgProgress);
  end;
end;

end.
