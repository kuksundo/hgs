{ unit PluginFrames

  Frame for plugins

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit guiPluginFrames;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ActnList, ImgList, Buttons, sdAbcTypes;

type

  TfrmPlugin = class(TFrame)
    Label1: TLabel;
    lvPlugins: TListView;
    ilPlugin: TImageList;
    alPlugin: TActionList;
    actAddPlugin: TAction;
    actEditPlugin: TAction;
    actDeletePlugin: TAction;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    procedure actAddPluginExecute(Sender: TObject);
    procedure lvPluginsData(Sender: TObject; Item: TListItem);
    procedure actEditPluginExecute(Sender: TObject);
    procedure actDeletePluginExecute(Sender: TObject);
    procedure lvPluginsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    { Private declarations }
  public
    procedure UpdateControls(Sender: TObject);
  end;

implementation

uses
  guiPlugins;

{$R *.DFM}

procedure TfrmPlugin.actAddPluginExecute(Sender: TObject);
var
  APlugin: TPlugin;
begin
  // Create an add plugin dialog
  Application.CreateForm(TdlgPlugin, dlgPlugin);
  try
    // New plugin
    APlugin := TPlugin.Create;
    dlgPlugin.PluginToForm(APlugin);
    if dlgPlugin.ShowModal = mrOK then
    begin
      if assigned(glPlugins) then
        glPlugins.Add(APlugin);
      UpdateControls(Sender);
    end else
      APlugin.Free;
  finally
    dlgPlugin.Release;
  end;
end;

procedure TfrmPlugin.actEditPluginExecute(Sender: TObject);
var
  APlugin: TPlugin;
begin
  // Create an add plugin dialog
  Application.CreateForm(TdlgPlugin, dlgPlugin);
  try
    // No cancel
    dlgPlugin.btnCancel.Enabled := False;

    // Get plugin
    APlugin := glPlugins[lvPlugins.Selected.Index];
    if assigned(APlugin) then begin
      dlgPlugin.PluginToForm(APlugin);
      dlgPlugin.ShowModal;
      UpdateControls(Sender);
    end;
  finally
    dlgPlugin.Release;
  end;
end;

procedure TfrmPlugin.actDeletePluginExecute(Sender: TObject);
begin
  // Delete one and redraw
  glPlugins.Delete(lvPlugins.Selected.Index);
  UpdateControls(Sender);
end;

procedure TfrmPlugin.UpdateControls(Sender: TObject);
begin
  // Set listview length and invalidate it
  if lvPlugins.Items.Count <> glPlugins.Count then
    lvPlugins.Items.Count := glPlugins.Count;
  lvPlugins.Invalidate;
  // Buttons
  actEditPlugin.Enabled := assigned(lvPlugins.Selected);
  actDeletePlugin.Enabled := assigned(lvPlugins.Selected);

  // global variables
  PluginGlobalVars;
end;

procedure TfrmPlugin.lvPluginsData(Sender: TObject; Item: TListItem);
var
  Plugin: TPlugin;
begin
  Plugin := glPlugins[Item.Index];
  if assigned(Plugin) then
    with Plugin do
    begin
      // Active? and icon
      Case Mode of
      cpcModeNotLoaded, cpcModeNotConnect:
        begin
          Item.Caption := 'Error';
          Item.ImageIndex := 1;
        end;
      cpcModeNotAuth:
        begin
          Item.Caption := 'No';
          Item.ImageIndex := 3;
        end;
      cpcModeEval, cpcModeOK:
        begin
          Item.Caption := 'Yes';
          Item.ImageIndex := 0;
        end;
      end;//case

      // name
      Item.SubItems.Add(PluginName);
      // version
      Item.SubItems.Add(PluginVersion);
    end;
end;

procedure TfrmPlugin.lvPluginsSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  UpdateControls(Sender);
end;

end.
