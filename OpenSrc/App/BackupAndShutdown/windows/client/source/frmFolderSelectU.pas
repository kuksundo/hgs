{-----------------------------------------------------------------------------
 Unit Name: frmFolderSelectU
 Author: Tristan Marlow
 Purpose: Backup and Shutdown Folder Selection.

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
unit frmFolderSelectU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, JvExStdCtrls,
  JvCombobox, JvDriveCtrls, JvListBox;

type
  TfrmFolderSelect = class(TForm)
    pnlBottom: TPanel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    comboBoxWildcards: TComboBox;
    cbRecurse: TCheckBox;
    Panel1: TPanel;
    cbShowHidden: TCheckBox;
    DirectoryListBox: TJvDirectoryListBox;
    DriveCombo: TJvDriveCombo;
    Panel2: TPanel;
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    procedure cbShowHiddenClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FFolder : String;
    FWildcards : String;
    FRecurse : Boolean;
    FShowHidden : Boolean;
  public
    property Folder : String read FFolder write FFolder;
    property Wildcards : String read FWildcards write FWildcards;
    property Recurse : Boolean read FRecurse write FRecurse;
    property ShowHidden : Boolean read FShowHidden write FShowHidden;
    function Execute : Boolean;
  end;


implementation

{$R *.dfm}

function TfrmFolderSelect.Execute : Boolean;
begin
  cbRecurse.Checked := FRecurse;
  if FWildcards <> '' then
    begin
      comboBoxWildcards.Text := FWildcards;
    end else
    begin
      comboBoxWildcards.ItemIndex := 0;
    end;
  cbShowHidden.Checked := FShowHidden;
  try
    DirectoryListBox.Directory := FFolder;
  except;
  end;
  Result := (Self.ShowModal = mrOk);
  If Result then
    begin
      FFolder := DirectoryListBox.Directory;
      FRecurse := cbRecurse.Checked;
      if comboBoxWildcards.Text <> '' then
        begin
          FWildcards := comboBoxWildcards.Text;
        end else
        begin
          FWildcards := '*.*';
        end;
    end else
    begin
      FFolder := '';
      FWildcards := '*.*';
      FRecurse := False;
    end;
end;

procedure TfrmFolderSelect.cbShowHiddenClick(Sender: TObject);
begin
  DirectoryListBox.ShowAllFolders := cbShowHidden.Checked;
end;

procedure TfrmFolderSelect.FormShow(Sender: TObject);
begin
  cbShowHiddenClick(nil);
  DirectoryListBox.SetFocus;
end;

end.
