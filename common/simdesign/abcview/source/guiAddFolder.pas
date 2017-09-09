{ Unit AddFolders

  "Add Folders" dialog box

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit guiAddFolder;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Mask, rxToolEdit, sdAbcVars,
  guiFolderOptions;

type
  TdlgAddFolder = class(TForm)
    dedFolder: TDirectoryEdit;
    Label1: TLabel;
    btnAdd: TBitBtn;
    btnCancel: TBitBtn;
    frFolderOptions: TfrFolderOptions;
    BitBtn1: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SettingsToAddFolderDlg;
    procedure AddFolderDlgToSettings;
  end;

implementation

{uses
  Utils;}

{$R *.DFM}

procedure TdlgAddFolder.SettingsToAddFolderDlg;
begin
  frFolderOptions.SetOptions(FFolderOptions);
  dedFolder.Text := ExcludeTrailingPathDelimiter(FAddDialogFolder);
end;

procedure TdlgAddFolder.AddFolderDlgToSettings;
begin
  FFolderOptions := frFolderOptions.GetOptions;
  FAddDialogFolder := IncludeTrailingPathDelimiter(dedFolder.Text);
end;

end.
