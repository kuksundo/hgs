{-----------------------------------------------------------------------------
 Unit Name: frmBackupAlertU
 Author: Tristan Marlow
 Purpose: Backup and Shutdown Display Backup Alerts.

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
unit frmBackupAlertU;

interface

uses
  BackupProfileU, Windows, Messages, SysUtils, Variants, Classes,
  Graphics, Controls, Forms,
  Dialogs, ComCtrls, JvExComCtrls, JvMonthCalendar, StdCtrls, CheckLst,
  ActnList, Buttons, ExtCtrls, JvSpecialProgress, System.UITypes, System.Actions;

type
  TfrmBackupAlert = class(TForm)
    pnlBottom: TPanel;
    pnlTop:    TPanel;
    btnOk:     TBitBtn;
    btnCancel: TBitBtn;
    ActionListBackupAlerts: TActionList;
    ActionBackup: TAction;
    ActionIgnore: TAction;
    pnlMain:   TPanel;
    pnlProfileDetails: TPanel;
    Calendar:  TJvMonthCalendar;
    Image1:    TImage;
    Image2:    TImage;
    lblHeader: TLabel;
    lblProfileAlert: TLabel;
    ListViewBackupProfiles: TListView;
    ActionUpdateCalendar: TAction;
    lblDaysOverdue: TLabel;
    procedure FormShow(Sender: TObject);
    procedure ActionIgnoreExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure ListViewBackupProfilesClick(Sender: TObject);
    procedure ActionUpdateCalendarExecute(Sender: TObject);
    procedure ActionBackupExecute(Sender: TObject);
    procedure ActionBackupUpdate(Sender: TObject);
  private
    FCanClose: boolean;
    FBackupProfileManager: TBackupProfileManager;
    procedure UpdateProfileList;
    function GetCheckedCount: integer;
    procedure SetDaysOverdue(ADateTime: TDateTime; AMaxDays: integer);
  public
    function Execute(ABackupProfileManager: TBackupProfileManager): boolean;
  end;

var
  frmBackupAlert: TfrmBackupAlert;

implementation

uses DateUtils;

{$R *.dfm}

procedure TfrmBackupAlert.SetDaysOverdue(ADateTime: TDateTime; AMaxDays: integer);
var
  OverDueDays: integer;
begin
  if ADateTime <> 0 then
  begin
    Calendar.Visible := True;
    Calendar.Date    := ADateTime;
    OverDueDays      := DaysBetween(IncDay(ADateTime, AMaxDays), Now);
    lblDaysOverdue.Caption :=
      Format('%d day(s) overdue.' + #13#10 +
      'Due: %s', [OverDueDays, DateToStr(IncDay(ADateTime, AMaxDays))]);
  end
  else
  begin
    Calendar.Visible := False;
    Calendar.Date    := 0;
    lblDaysOverdue.Caption := 'No previous backup details.';
  end;
end;

procedure TfrmBackupAlert.UpdateProfileList;
var
  Idx:      integer;
  ListItem: TListItem;
begin
  ListViewBackupProfiles.Items.Clear;
  with FBackupProfileManager do
  begin
    for Idx := 0 to Pred(ProfileCount) do
    begin
      if Profile[Idx].IsBackupOverdue then
      begin
        with Profile[Idx] do
        begin
          ListItem := ListViewBackupProfiles.Items.Add;
          with ListItem do
          begin
            Caption := Profile[Idx].ProfileName;
            Checked := Profile[Idx].Enabled;
            SubItems.Add(DateTimeToStr(Profile[Idx].LastBackup));
            SubItems.Add(ExtractFileName(Profile[Idx].ZipFile));
          end;
        end;
      end;
    end;
  end;
end;

function TfrmBackupAlert.Execute(ABackupProfileManager: TBackupProfileManager)
: boolean;
begin
  Result := False;
  FBackupProfileManager := ABackupProfileManager;
  if Self.ShowModal = mrOk then
  begin
    Result := True;
  end;
end;

procedure TfrmBackupAlert.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  if Self.Visible then
  begin
    if not FCanClose then
    begin
      Self.FormStyle := fsNormal;
      try
        if MessageDlg(
          'It is stronly recommended that you backup your data, are you sure you want to continue?',
          mtWarning, [mbYes, mbNo], 0) = mrYes then
        begin
          FCanClose := True;
          Self.ModalResult := mrCancel;
        end;
      finally
        Self.FormStyle := fsStayOnTop;
      end;
    end;
    CanClose := FCanClose;
  end;
end;

procedure TfrmBackupAlert.FormShow(Sender: TObject);
begin
  FCanClose := False;
  UpdateProfileList;
  ActionUpdateCalendar.Execute;
  ListViewBackupProfiles.SetFocus;
end;

procedure TfrmBackupAlert.ListViewBackupProfilesClick(Sender: TObject);
begin
  ActionUpdateCalendar.Execute;
end;

function TfrmBackupAlert.GetCheckedCount: integer;
var
  Idx: integer;
begin
  Result := 0;
  for Idx := 0 to Pred(ListViewBackupProfiles.Items.Count) do
  begin
    if ListViewBackupProfiles.Items[Idx].Checked then
      Inc(Result);
  end;
end;


procedure TfrmBackupAlert.ActionBackupExecute(Sender: TObject);
var
  Idx: integer;
begin
  if GetCheckedCount > 0 then
  begin
    FBackupProfileManager.ClearQueue;
    for Idx := 0 to Pred(ListViewBackupProfiles.Items.Count) do
    begin
      if ListViewBackupProfiles.Items[Idx].Checked then
      begin
        FBackupProfileManager.QueueAdd(ListViewBackupProfiles.Items[Idx].Caption);
      end;
    end;
    FCanClose := True;
    Self.ModalResult := mrOk;
  end;
end;

procedure TfrmBackupAlert.ActionBackupUpdate(Sender: TObject);
begin
  ActionBackup.Enabled := GetCheckedCount > 0;
end;

procedure TfrmBackupAlert.ActionIgnoreExecute(Sender: TObject);
begin
  Self.ModalResult := mrCancel;
end;

procedure TfrmBackupAlert.ActionUpdateCalendarExecute(Sender: TObject);
var
  BackupProfile: TBackupProfile;
begin
  SetDaysOverdue(0, 0);
  if ListViewBackupProfiles.ItemIndex <> -1 then
  begin
    BackupProfile := FBackupProfileManager.ProfileByName(
      ListViewBackupProfiles.Items[ListViewBackupProfiles.ItemIndex].Caption);
    if BackupProfile <> nil then
    begin
      SetDaysOverdue(BackupProfile.LastBackup, BackupProfile.AlertDays);
    end;
  end;
end;

end.

