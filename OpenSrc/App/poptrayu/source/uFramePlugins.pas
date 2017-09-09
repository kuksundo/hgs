unit uFramePlugins;

{-------------------------------------------------------------------------------
POPTRAY
Copyright (C) 2003-2005  Renier Crause
All Rights Reserved.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

The GNU GPL can be found at:
  http://www.gnu.org/copyleft/gpl.html
-------------------------------------------------------------------------------}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ImgList, ComCtrls, Menus, ActnPopup,
  Vcl.PlatformDefaultStyleActnCtrls;

type
  TEnableSaveOptionsFunction = procedure of object;

type
  TframePlugins = class(TFrame)
    lvPlugins: TListView;
    imlPlugins: TImageList;
    mnuPlugins: TPopupActionBar;
    PluginOptions1: TMenuItem;
    N1: TMenuItem;
    Refresh1: TMenuItem;
    procedure lvPluginsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure PluginOptions1Click(Sender: TObject);
    procedure Refresh1Click(Sender: TObject);
    procedure lvPluginsResize(Sender: TObject);
    procedure HelpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lvPluginsDblClick(Sender: TObject);
  private
    { Private declarations }
    funcEnableSaveBtn : TEnableSaveOptionsFunction;
    procedure Refresh;
    procedure ShowOptions;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; SaveButtonProc : TEnableSaveOptionsFunction); reintroduce;
    destructor Destroy; override;
  end;

implementation

uses uMain, uGlobal, uPlugins, uTranslate;

{$R *.dfm}

Procedure UnloadPlugin(PlugNum : integer);
begin
  FreeLibrary(Plugins[PlugNum].hPlugin);
  Plugins[PlugNum].hPlugin := 0;
  // general functions
  Plugins[PlugNum].FInit := nil;
  Plugins[PlugNum].FFreePChar := nil;
  Plugins[PlugNum].FUnload := nil;
  // notify functions
  if (Plugins[PlugNum] is TPluginNotify) then
    with (Plugins[PlugNum] as TPluginNotify) do
    begin
      FNotify := nil;
      FMessageCheck := nil;
      FMessageBody := nil;
    end;
  // protocol functions
//  if (Plugins[PlugNum] is TPluginProtocol) then
//    with (Plugins[PlugNum] as TPluginProtocol) do
//    begin
//      FProtocols := nil;
//      FConnect := nil;
//      FDisconnect := nil;
//      FConnected := nil;
//      FCheckMessages := nil;
//      FRetrieveHeader := nil;
//      FRetrieveRaw := nil;
//      FRetrieveTop := nil;
//      FRetrieveMsgSize := nil;
//      FUIDL := nil;
//      FDelete := nil;
//      FSetOnWork := nil;
//    end;
end;

{ TframePlugins }

constructor TframePlugins.Create(AOwner: TComponent; SaveButtonProc : TEnableSaveOptionsFunction);
begin
  inherited Create(AOwner);
  funcEnableSaveBtn := SaveButtonProc;
  Refresh;
  TranslateComponentFromEnglish(self);
end;

procedure TframePlugins.Refresh;
var
  i,res : integer;
  srec : TSearchRec;
  hPlugin : THandle;
  fInterfaceVersion : function : integer; stdcall;
  fPluginName : function : ShortString; stdcall;
  fPluginType : function : TPluginType; stdcall;
  PluginName : shortstring;
  ThePluginType : TPluginType;
  Plugin : TPlugin;
  tmpPlugins : TStringList;
  tmpPluginCount : integer;
begin
  tmpPlugins := TStringList.Create;
  try
    // remember enabled plugins (and unload DLLs)
    for i := Low(Plugins) to High(Plugins) do
    begin
      if Plugins[i].Enabled then
        tmpPlugins.Add(Plugins[i].Name);
      if Plugins[i].hPlugin <> 0 then
      begin
        FreeLibrary(Plugins[i].hPlugin);
        Plugins[i].hPlugin := 0;
      end;
      Plugins[i].Free; //Free up memory for plugin before reloading it
    end;
    // clear array and listview
    tmpPluginCount := length(Plugins);
    SetLength(Plugins,0);
    lvPlugins.Clear;

    // refresh from files
    res := FindFirst(ExtractFilePath(Application.ExeName)+'plugins\*.dll',faAnyFile-faDirectory,srec);
    while res = 0 do
    begin
      // load DLL
      hPlugin := LoadLibrary(PChar(ExtractFilePath(Application.ExeName)+'plugins\'+srec.Name));
      // skip old interface verson
      fInterfaceVersion := GetProcAddress(hPlugin, 'InterfaceVersion');
      if (@fInterfaceVersion=nil) or (fInterfaceVersion<INTERFACE_VERSION) then
      begin
        if GetProcAddress(hPlugin, 'PluginName') <> nil then
          TranslateMsg(Translate('Incompatible Plugin:')+'  '+srec.Name,mtWarning,[mbOk],0);
        FreeLibrary(hPlugin);
        res := FindNext(srec);
        Continue;
      end;
      // name and type
      fPluginName := GetProcAddress(hPlugin, 'PluginName');
      fPluginType := GetProcAddress(hPlugin, 'PluginType');
      // skip non-plugin DLLs
      if (@fPluginName = nil) or (@fPluginType = nil) then
      begin
        FreeLibrary(hPlugin);
        res := FindNext(srec);
        Continue;
      end;
      // set plugin type
      PluginName := fPluginName;
      ThePluginType := fPluginType;
      // plugin object
      case ThePluginType of
        piNotify   : Plugin := TPluginNotify.Create;
        //piProtocol : Plugin := TPluginProtocol.Create;
      else
        Plugin := TPlugin.Create;
      end;
      Plugin.Name := String(PluginName);
      Plugin.DLLName := srec.Name;
      Plugin.hPlugin := hPlugin;
      Plugin.Enabled := False;
      Plugin.PluginType := ThePluginType;
      Plugin.FInit := GetProcAddress(hPlugin,'Init');
      Plugin.FFreePChar := GetProcAddress(hPlugin,'FreePChar');
      Plugin.FUnload := GetProcAddress(hPlugin,'Unload');
      // notify
      if (Plugin is TPluginNotify) then
      begin
        (Plugin as TPluginNotify).FNotify := GetProcAddress(hPlugin,'Notify');
        (Plugin as TPluginNotify).FMessageCheck := GetProcAddress(hPlugin,'MessageCheck');
        (Plugin as TPluginNotify).FMessageBody := GetProcAddress(hPlugin,'MessageBody');
      end;
      // protocol
//      if (Plugin is TPluginProtocol) then
//      begin
//        (Plugin as TPluginProtocol).FProtocols := GetProcAddress(hPlugin,'Protocols');
//        (Plugin as TPluginProtocol).FConnect := GetProcAddress(hPlugin,'Connect');
//        (Plugin as TPluginProtocol).FDisconnect := GetProcAddress(hPlugin,'Disconnect');
//        (Plugin as TPluginProtocol).FConnected := GetProcAddress(hPlugin,'Connected');
//        (Plugin as TPluginProtocol).FCheckMessages := GetProcAddress(hPlugin,'CheckMessages');  //replaced by CountMessages
//        (Plugin as TPluginProtocol).FRetrieveHeader := GetProcAddress(hPlugin,'RetrieveHeader');
//        (Plugin as TPluginProtocol).FRetrieveRaw := GetProcAddress(hPlugin,'RetrieveRaw');
//        (Plugin as TPluginProtocol).FRetrieveTop := GetProcAddress(hPlugin,'RetrieveTop');
//        (Plugin as TPluginProtocol).FRetrieveMsgSize := GetProcAddress(hPlugin,'RetrieveMsgSize');
//        (Plugin as TPluginProtocol).FUIDL := GetProcAddress(hPlugin,'UIDL');
//        (Plugin as TPluginProtocol).FDelete := GetProcAddress(hPlugin,'Delete');
//        (Plugin as TPluginProtocol).FSetOnWork := GetProcAddress(hPlugin,'SetOnWork');
//        (Plugin as TPluginProtocol).FLastErrorMsg := GetProcAddress(hPlugin,'LastErrorMsg');
//      end;
      // init
      Plugin.Init; //suggested by Attila / köszi Attilának
      // add to array
      SetLength(Plugins,Length(Plugins)+1);
      Plugins[Length(Plugins)-1] := Plugin;
      // next
      res := FindNext(srec);
    end;
    FindClose(srec); // free up resources used by successful FindFirst/Next calls
    // refresh listview
    lvPlugins.Items.Clear;
    for i := Low(Plugins) to High(Plugins) do
    begin
      with lvPlugins.Items.Add do
      begin
        Caption := {Translate(}Plugins[i].Name{)};
        ImageIndex := Integer(Plugins[i].PluginType);
        SubItems.Add(IntToStr(i));
        // re-enable the remembered plugins
        Plugins[i].Enabled := tmpPlugins.IndexOf(Plugins[i].Name) <> -1;
        Checked := Plugins[i].Enabled;
      end;
    end;
    // buttons
    if  tmpPluginCount <> length(plugins) then
    begin
      // enable save button
      funcEnableSaveBtn();
    end;

  finally
    tmpPlugins.Free;
  end;
end;

procedure TframePlugins.ShowOptions;
var
  ShowOptions : procedure (Owner : TComponent);
begin
  if lvPlugins.Selected <> nil then
  begin
    ShowOptions := GetProcAddress(Plugins[StrToInt(lvPlugins.Selected.SubItems[0])].hPlugin,'ShowOptions');
    if @ShowOptions <> nil then
      ShowOptions(frmPopUMain);
  end;
end;

//-----------------------------------------------------------------[ Events ]---

procedure TframePlugins.lvPluginsChange(Sender: TObject; Item: TListItem; Change: TItemChange);
var
  i : integer;
begin
  if not FBusy then
  begin
    if Change = ctState then
    begin
      for i := Low(Plugins) to High(Plugins) do
      begin
        if (Plugins[i].Name = {TranslateToEnglish(}Item.Caption{)}) and (Plugins[i].Enabled <> Item.Checked) then
        begin
          // enable it
          Plugins[i].Enabled := Item.Checked;
          if Plugins[i].Enabled then
            Plugins[i].Init
          else
            Plugins[i].Unload;
          // enable save button
          funcEnableSaveBtn();
        end;
      end;
      // refresh protocols
      //frmPopUMain.AccountsForm.RefreshProtocols;
    end;
  end;
end;

procedure TframePlugins.PluginOptions1Click(Sender: TObject);
begin
  ShowOptions;
end;

procedure TframePlugins.Refresh1Click(Sender: TObject);
begin
  Refresh;
end;

procedure TframePlugins.lvPluginsResize(Sender: TObject);
begin
  lvPlugins.Columns[0].Width := lvPlugins.Width-24;
end;

destructor TframePlugins.Destroy;
var
  i : integer;
begin
  // unload all disabled DLLs
  for i := Low(Plugins) to High(Plugins) do
    if not Plugins[i].Enabled then
      UnloadPlugin(i);
  inherited;
end;

procedure TframePlugins.HelpMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  frmPopUMain.QuickHelp(Sender, Button, Shift, X, Y);
end;

procedure TframePlugins.lvPluginsDblClick(Sender: TObject);
begin
  ShowOptions;
end;


end.
