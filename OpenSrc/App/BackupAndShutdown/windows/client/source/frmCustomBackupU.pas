{-----------------------------------------------------------------------------
 Unit Name: frmCustomBackupU
 Author: Tristan Marlow
 Purpose: Backup and Shutdown Custom Backup Dialog.

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
unit frmCustomBackupU;

interface

uses
  BackupProfileU, ExitWindowsU, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Buttons, ActnList, System.Actions;

type
  TfrmCustomBackup = class(TForm)
    pnlBottom: TPanel;
    btnCancel: TBitBtn;
    btnOk: TBitBtn;
    pnlTop: TPanel;
    imgHeader: TImage;
    lblHeader: TLabel;
    ListViewBackupProfiles: TListView;
    imgBackground: TImage;
    pnlBackupOptions: TPanel;
    GroupBoxBackupOptions: TGroupBox;
    Label1: TLabel;
    comboShutdownOption: TComboBox;
    ActionListCustomBackup: TActionList;
    ActionBackup: TAction;
    ActionCancel: TAction;
    procedure ActionCancelExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ActionBackupExecute(Sender: TObject);
    procedure ActionBackupUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FBackupProfileManager : TBackupProfileManager;
    function GetCheckedCount : Integer;
    procedure UpdateProfileList;
    function GetShutdownOption : TExitParameter;
    procedure SetShutdownOption(AExitParameter : TExitParameter);
  public
    function Execute(ABackupProfileManager : TBackupProfileManager; var AExitParameter : TExitParameter) : Boolean;
  end;

var
  frmCustomBackup: TfrmCustomBackup;

implementation

{$R *.dfm}

procedure TfrmCustomBackup.UpdateProfileList;
var
  Idx : Integer;
  ListItem : TListItem;
begin
  ListViewBackupProfiles.Items.Clear;
  with FBackupProfileManager do
    begin
      For Idx := 0 to Pred(ProfileCount) do
      begin
        with Profile[Idx] do
        begin
          if Profile[Idx].LoadProfile then
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

function TfrmCustomBackup.GetShutdownOption : TExitParameter;
begin
  case comboShutdownOption.ItemIndex of
    1 : Result := xpShutdown;
    2 : Result := xpReboot;
    3 : Result := xpLogoff;
    4 : Result := xpLockWorkstation;
    else Result := xpNone;
  end;
end;

procedure TfrmCustomBackup.SetShutdownOption(AExitParameter : TExitParameter);
begin
  case AExitParameter of
    xpNone: comboShutdownOption.ItemIndex := 0;
    xpLogoff: comboShutdownOption.ItemIndex := 3;
    xpReboot: comboShutdownOption.ItemIndex := 2;
    xpShutdown: comboShutdownOption.ItemIndex := 1;
    xpLockWorkstation : comboShutdownOption.ItemIndex := 4;
  end;
end;


function TfrmCustomBackup.Execute(ABackupProfileManager : TBackupProfileManager; var AExitParameter : TExitParameter) : Boolean;
begin
  Result := False;
  FBackupProfileManager := ABackupProfileManager;
  SetShutdownOption(AExitParameter);
  if Self.ShowModal = mrOk then
    begin
      AExitParameter := GetShutdownOption;
      Result := True;
    end;
end;

procedure TfrmCustomBackup.FormCreate(Sender: TObject);
begin
  with comboShutdownOption.Items do
    begin
      Clear;
      Add('Do nothing');
      Add('Shutdown');
      Add('Reboot');
      Add('Logoff');
      Add('Lock Workstation');
    end;
end;

procedure TfrmCustomBackup.FormShow(Sender: TObject);
begin
  UpdateProfileList;
  ListViewBackupProfiles.SetFocus;
end;

function TfrmCustomBackup.GetCheckedCount : Integer;
var
  Idx : Integer;
begin
  Result := 0;
  for Idx := 0 to Pred(ListViewBackupProfiles.Items.Count) do
    begin
      if ListViewBackupProfiles.Items[Idx].Checked then Inc(Result);
    end;
end;

procedure TfrmCustomBackup.ActionBackupExecute(Sender: TObject);
var
  Idx : Integer;
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
      Self.ModalResult := mrOk;
    end;
end;

procedure TfrmCustomBackup.ActionBackupUpdate(Sender: TObject);
begin
  ActionBackup.Enabled := GetCheckedCount > 0;
end;

procedure TfrmCustomBackup.ActionCancelExecute(Sender: TObject);
begin
  Self.ModalResult := mrCancel;
end;

end.
