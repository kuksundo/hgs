{ unit FolderOptions

  Small dialog with folder scanning options

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit guiFolderOptions;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, sdAbcTypes;

type

  TfrFolderOptions = class(TFrame)
    GroupBox1: TGroupBox;
    Image1: TImage;
    chkDeleteProtected: TCheckBox;
    chkGraphicsFilesOnly: TCheckBox;
    chkAddHidden: TCheckBox;
    chkAddSystem: TCheckBox;
    chkInclSubdirs: TCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
    function GetOptions: TFolderOptions;
    procedure SetOptions(AValue: TFolderOptions);
  end;

implementation

{$R *.DFM}

function TfrFolderOptions.GetOptions: TFolderOptions;
begin
  with Result do begin
    InclSubDirs := chkInclSubdirs.Checked;
    DeleteProtected := chkDeleteProtected.Checked;
    GraphicsOnly := chkGraphicsFilesOnly.Checked;
    AddHidden := chkAddHidden.Checked;
    AddSystem := chkAddSystem.Checked;
  end;
end;

procedure TfrFolderOptions.SetOptions(AValue: TFolderOptions);
begin
  with AValue do begin
    chkInclSubdirs.Checked := InclSubDirs;
    chkDeleteProtected.Checked := DeleteProtected;
    chkGraphicsFilesOnly.Checked := GraphicsOnly;
    chkAddHidden.Checked := AddHidden;
    chkAddSystem.Checked := AddSystem;
  end;
end;

end.
