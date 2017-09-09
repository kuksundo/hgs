unit uIniSettings;

{-------------------------------------------------------------------------------
POPTRAYU
Copyright (C) 2001-2005  Renier Crause
Copyright (C) 2012-2013 Jessica Brown
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
uses System.SysUtils;

    // ini files
    procedure LoadOptionsINI(); forward;
    procedure SaveOptionsINI(); forward;
    procedure LoadAccountINI(num : integer);
    procedure SaveAccountINI(num : integer);
    procedure LoadRulesINI; forward;
    procedure SaveRulesINI; forward;
    procedure LoadPosINI; forward;
    procedure SavePosINI; forward;
    procedure LoadViewedMessageIDs(num : integer);
    procedure SaveViewedMessageIDs; forward;
    function GetDefaultEmail(): string; forward; //would be ok to be private
    function GetSettingsFolder(): string; forward;
    function InitSettingsStoragePath(commandLinePath : string = '') : string; forward;
    procedure SaveWhiteBlackListsToFile;
    procedure SaveWhitelistToFile();
    procedure SaveBlacklistToFile();
var
    IniPath : TFileName;
    RulesFileName : TFileName; //File where Rules are saved
    LogRuleName : TFileName; // Where Rules are Logged (path+filename)
    ToolbarName : TFileName; // When toolbars are customized this file tracks what changes have been made
    IniName : TFileName; // Path+filename to the ini file where most settings are saved
    IniNumAccounts : Integer;

//------------------------------------------------------------------------------
// Implemenation
//------------------------------------------------------------------------------
implementation
uses
  System.Classes, System.Win.Registry, System.IniFiles, System.UITypes,
  Vcl.Dialogs, Vcl.Forms, Vcl.Graphics,
  WinApi.Windows, StrUtils, SHFolder,
  uProtocol, uPlugins, uGlobal, uRCUtils, uMain, uTranslate, uDM, uMailItems,
  uFontUtils, uRules, uRulesManager, uAccounts, System.TypInfo, uConstants;

// Forward function declarations
function GetSpecialFolderPath(folder : integer) : string; forward;

//------------------------------------------------------------------------------
// Begin Function Implementations
//------------------------------------------------------------------------------

function GetSettingsFolder(): string;
begin
  Result := IniPath;
end;

{*------------------------------------------------------------------------------
  Helper function to access the shell command to get special folders
  paths, such as appdata, program files, my documents, etc.

  @param folder the CSIDL of the folder to get the path for. 
-------------------------------------------------------------------------------}
function GetSpecialFolderPath(folder : integer) : string;
var
  path: array [0..MAX_PATH] of char;
begin
   if Succeeded(SHGetFolderPath(0,folder,0,0,@path[0])) then
     Result := path else Result := '';
end;

{*------------------------------------------------------------------------------
  Function to determine the place where the app should store user data. 

  Uses in precedence (1) Command line parameter (2) Registry setting for
  location (3) App's folder, usually in program files.

  Expected side effect: sets IniPath variable 

  @param commandLinePath if the command line parameter for ini path was
  specified on startup it should be passed as a parameter, otherwise this
  string should be left blank.
-------------------------------------------------------------------------------}
function InitSettingsStoragePath( commandLinePath : string = '' ) : string;
var
   Registry: TRegistry;
   iniLocation: Integer;
begin
  // If the user specified the ini folder on the command line, this takes
  // precedence over the registry setting.
  if (commandLinePath <> '') then
    Result := commandLinePath
  else
  begin
    // If PopTrayU key exists in registry, use it to determine where the
    // poptray.ini file is located.

    Registry := TRegistry.Create(KEY_READ);
    try
      Registry.RootKey := HKEY_LOCAL_MACHINE;
      if Registry.OpenKey('SOFTWARE\PopTrayU', false) then
      begin
        if Registry.ValueExists('IniPath') then
        begin
          iniLocation := Registry.ReadInteger('IniPath');
          Registry.CloseKey;
          if (iniLocation = CSIDL_APPDATA) or (iniLocation = CSIDL_COMMON_APPDATA) then
            Result := GetSpecialFolderPath(iniLocation)+ '\PopTrayU\';
          //else iniLocation should be program files, so fall through.
        end;
      end;
    finally
      Registry.Free;
    end;

    // if we haven't already set the path, default to the path of this app
    if Length(Result) = 0 then
      Result := ExtractFilePath(Application.ExeName);
  end;

  // make sure path ends in backslash
  if Copy(Result,Length(Result),1) <> '\' then Result := Result + '\';

  // Set variables to store the correct path to settings files in this folder
  IniPath := Result;
  IniName := IniPath+'PopTray.ini';
  RulesFileName := IniPath+'Rules.ini';
  LogRuleName := IniPath+'Rules.log';
  ToolbarName := uIniSettings.IniPath+'PopTray.customize';
end;


{*------------------------------------------------------------------------------
  Reads options from INI file 
-------------------------------------------------------------------------------}
procedure LoadOptionsINI();
var
  Ini : TIniFile;
  Interval,NewMail : string;
  i : integer;
  langCount : integer;
  //pluginCount : integer;
  //ThePluginType : TPluginType;
  //fInterfaceVersion : function : integer; stdcall;
  defaultFont : string;
  font : TFont;
begin
  // load options from INI
  Ini := TIniFile.Create(IniName);
  try
    //---- Defaults ----//
    // interval
    Interval := Ini.ReadString('Options','Interval','5');
    Options.Interval := StrToFloatDef(Interval,5);
    Options.TimerAccount := Ini.ReadBool('Options','TimerAccount',FALSE);
    // program
    Options.MailProgram := Ini.ReadString('Options','Program',GetDefaultEMail);
    // sound
    NewMail := ExtractFilePath(Application.ExeName)+'poptray_newmail_lo.wav';
    if not FileExists(NewMail) then
      NewMail := '';
    Options.DefSound := Ini.ReadString('Options','Sound',NewMail);
    Options.Use24HrTime := Ini.ReadBool('Options','Use24HrTime',false);
    //---- end ----//

    //-- Other categories --//
    // options
    with Options do
    begin
      // general options
      Startup := Ini.ReadBool('Options','CheckStartup',FALSE);
      Minimized := Ini.ReadBool('Options','Minimized',FALSE);
      Animated := Ini.ReadBool('Options','AnimatedTray',FALSE);
      ResetTray := Ini.ReadBool('Options','ResetTray',FALSE);
      RotateIcon := Ini.ReadBool('Options','RotateIcon',FALSE);
      ShowForm := Ini.ReadBool('Options','ShowForm',FALSE);
      Balloon := Ini.ReadBool('Options','Balloon',FALSE);
      DeleteNextCheck := Ini.ReadBool('Options','DeleteNextCheck',FALSE);
      FirstWait := Ini.ReadInteger('Options','FirstWait',0);
      // advanced - connection
      TimeOut := Ini.ReadInteger('Options','TimeOut',120);
      QuickCheck := Ini.ReadBool('Options','QuickCheck',TRUE);
      CheckWhileMinimized := Ini.ReadBool('Options','CheckWhileMinimized',FALSE);
      IgnoreRetrieveErrors := Ini.ReadBool('Options','IgnoreRetrieveErrors',FALSE);
      ShowErrorsInBalloons := Ini.ReadBool('Options','ShowErrorsInBalloons',FALSE);
      Online := Ini.ReadBool('Options','CheckOnline',FALSE);
      TopLines := Ini.ReadInteger('Options','TopLines',0);
      PreferEnvelopes := Ini.ReadBool('Options','PreferEnvelopes',TRUE);
      GetBody := Ini.ReadBool('Options','GetBody',FALSE);
      GetBodyLines := Ini.ReadInteger('Options','GetBodyLines',0);
      GetBodySize := Ini.ReadInteger('Options','GetBodySize',0);
      // advanced - interface
      CheckingIcon := Ini.ReadInteger('Options','CheckingIcon',ciAnimatedStar);
      ShowViewed := Ini.ReadBool('Options','ShowViewed',TRUE);
      CloseMinimize := Ini.ReadBool('Options','CloseMinimize',TRUE);
      MinimizeTray := Ini.ReadBool('Options','MinimizeTray',TRUE);
      NoError := Ini.ReadBool('Options','NoError',FALSE);
      MultilineAccounts := Ini.ReadBool('Options','MultilineAccounts',FALSE);
      DeleteConfirm := Ini.ReadBool('Options','DeleteConfirm',TRUE);
      DeleteConfirmProtected := Ini.ReadBool('Options','DeleteConfirmProtected',FALSE);
      OnTop := Ini.ReadBool('Options','OnTop',FALSE);
      AdvInfo := Ini.ReadBool('Options','AdvInfo',TRUE);
      AdvInfoDelay := Ini.ReadInteger('Options','AdvInfoDelay',20);
      HideViewed := Ini.ReadBool('Options','HideViewed',FALSE);
      UseCustomDateFormat := Ini.ReadBool('Options','UseCustomDateFormat',FALSE);
      CustomDateFormatString := Ini.ReadString('Options','CustomDateFormatString','m/d h:mma/p');

      DoubleClickDelay := Ini.ReadBool('Options','DoubleClickDelay',TRUE);
      ShowWhileChecking := Ini.ReadBool('Options','ShowWhileChecking',FALSE);
      Options.ToolbarSpamAction := Ini.ReadInteger('Options','ToolbarSpamAction',optSpamActNone);
      Options.AutoClosePreviewWindows := Ini.ReadBool('Options','AutoClosePreviewWindows',FALSE);
      // advanced - misc
      UseMAPI := Ini.ReadBool('Options','UseMAPI',FALSE);
      LogRules := Ini.ReadBool('Options','LogRules',FALSE);
      SafeDelete := Ini.ReadBool('Options','SafeDelete',TRUE);
      RememberViewed := Ini.ReadBool('Options','RememberViewed',FALSE);
      BlackListSpam := Ini.ReadBool('Options','BlackListSpam',FALSE);
      DontCheckTimes := Ini.ReadBool('Options','DontCheckTimes',FALSE);
      try
        DontCheckStart := Ini.ReadTime('Options','DontCheckStart',StrToTime('20'+FormatSettings.TimeSeparator+'00'));
      Except on e: EConvertError do begin
        ShowMessage(e.ToString);
      end;
      end;
      try
        DontCheckEnd := Ini.ReadTime('Options','DontCheckEnd',StrToTime('08'+FormatSettings.TimeSeparator+'00'));
      Except on e: EConvertError do begin
        ShowMessage(e.ToString);
      end;
      end;
      DisableHtmlPreview := Ini.ReadBool('Settings','DisableHtmlPreview',FALSE);
      TempEmailFilename := Ini.ReadString('Options','TempEmailFilename','temp.eml');
      ShowNewestMessagesOnly := Ini.ReadBool('Options','ShowNewestMessagesOnly',FALSE);
      NumNewestMsgToShow := Ini.ReadInteger('Options','NumNewestMsgToShow',20);
    end;

    // password
    Options.PasswordProtect := Ini.ReadBool('Options','PasswordProtect',FALSE);
    Options.Password := Decrypt(Ini.ReadString('Options','Password',''));

    // mouse button actions
    Options.LeftClick := Ini.ReadInteger('MouseButtons','Left',1);
    Options.RightClick := Ini.ReadInteger('MouseButtons','Right',2);
    Options.MiddleClick := Ini.ReadInteger('MouseButtons','Middle',3);
    Options.DblClick := Ini.ReadInteger('MouseButtons','Double',4);
    Options.ShiftLeftClick := Ini.ReadInteger('MouseButtons','ShiftLeft',0);
    Options.ShiftRightClick := Ini.ReadInteger('MouseButtons','ShiftRight',0);
    Options.ShiftMiddleClick := Ini.ReadInteger('MouseButtons','ShiftMiddle',0);

    // hotkey actions
    Options.Action1 := Ini.ReadInteger('HotKeys','HotKeyAction1',1);
    Options.Action2 := Ini.ReadInteger('HotKeys','HotKeyAction2',2);
    Options.Action3 := Ini.ReadInteger('HotKeys','HotKeyAction3',3);
    Options.Action4 := Ini.ReadInteger('HotKeys','HotKeyAction4',4);

    // hot-keys
    Options.HotKey1 := Ini.ReadInteger('HotKeys','HotKey1',0);
    Options.HotKey2 := Ini.ReadInteger('HotKeys','HotKey2',0);
    Options.HotKey3 := Ini.ReadInteger('HotKeys','HotKey3',0);
    Options.HotKey4 := Ini.ReadInteger('HotKeys','HotKey4',0);

    // languages
    langCount := Ini.ReadInteger('Languages','Count',0);
    if langCount = 0 then
      GetLanguages
    else begin
      SetLength(Options.Languages,langCount+1);
      Options.Languages[0] := 'English';
      for i := 1 to langCount do
        Options.Languages[i] := Ini.ReadString('Languages','Language'+IntToStr(i),'');
    end;
    Options.Language := Ini.ReadInteger('Languages','Active',0);

    // plug-ins
//    pluginCount := 0;//Ini.ReadInteger('Plug-ins','Count',0);
//    SetLength(Plugins,pluginCount);
//    for i := 0 to pluginCount-1 do
//    begin
//      ThePluginType := TPluginType(Ini.ReadInteger('Plug-ins','PluginType'+IntToStr(i+1),0));
//      case ThePluginType of
//        piNotify   : Plugins[i] := TPluginNotify.Create;
//        //piProtocol : Plugins[i] := TPluginProtocol.Create;
//      end;
//      Plugins[i].Name := Ini.ReadString('Plug-ins','PluginName'+IntToStr(i+1),'');
//      Plugins[i].DLLName := Ini.ReadString('Plug-ins','PluginDLLName'+IntToStr(i+1),'');
//      Plugins[i].PluginType := TPluginType(Ini.ReadInteger('Plug-ins','PluginType'+IntToStr(i+1),0));
//      Plugins[i].Enabled := Ini.ReadBool('Plug-ins','PluginEnabled'+IntToStr(i+1),False);
//      if Plugins[i].Enabled then
//      begin
//        Plugins[i].hPlugin := LoadLibrary(PChar(ExtractFilePath(Application.ExeName)+'plugins\'+Plugins[i].DLLName));
//        if Plugins[i].hPlugin = 0 then
//          Continue;
//        // skip old interface version
//        fInterfaceVersion := GetProcAddress(Plugins[i].hPlugin, 'InterfaceVersion');
//        if (@fInterfaceVersion=nil) or (fInterfaceVersion<INTERFACE_VERSION) then
//        begin
//          TranslateMsg(Translate('Incompatible Plugin:')+'  '+Plugins[i].DLLName,mtWarning,[mbOk],0);
//          FreeLibrary(Plugins[i].hPlugin);
//          Continue;
//        end;
//        Plugins[i].FInit := GetProcAddress(Plugins[i].hPlugin,'Init');
//        Plugins[i].FFreePChar := GetProcAddress(Plugins[i].hPlugin,'FreePChar');
//        Plugins[i].FUnload := GetProcAddress(Plugins[i].hPlugin,'Unload');
//        // notify
//        if (Plugins[i] is TPluginNotify) then
//        begin
//          (Plugins[i] as TPluginNotify).FNotify := GetProcAddress(Plugins[i].hPlugin,'Notify');
//          (Plugins[i] as TPluginNotify).FNotifyAccount := GetProcAddress(Plugins[i].hPlugin,'NotifyAccount');
//          (Plugins[i] as TPluginNotify).FMessageCheck := GetProcAddress(Plugins[i].hPlugin,'MessageCheck');
//          (Plugins[i] as TPluginNotify).FMessageBody := GetProcAddress(Plugins[i].hPlugin,'MessageBody');
//        end;
//        Plugins[i].Init;
//      end;
//    end;

    // Visual Appearance
    defaultFont := IfThen(IsWinVista(), DEFAULT_FONT_VISTA, DEFAULT_FONT_XP);

    font := StringToFont( Ini.ReadString('VisualOptions', 'ListboxFont',
      defaultFont), defaultFont);
    Options.ListboxFont.Assign(font);
    FreeAndNil(font);
    Options.ListboxFont.Charset := Ini.ReadInteger('VisualOptions','ListboxFontCharset',DEFAULT_CHARSET);

    Options.ListboxBg := StringToColor( Ini.ReadString('VisualOptions',
      'ListboxBg', 'clWindow'));

    font := StringToFont( Ini.ReadString('VisualOptions', 'GlobalFont',
      defaultFont), defaultFont);
    Options.GlobalFont.Assign(font);
    FreeAndNil(font);
    Options.GlobalFont.Charset := Ini.ReadInteger('VisualOptions','GlobalFontCharset',DEFAULT_CHARSET);

    font := StringToFont( Ini.ReadString('VisualOptions', 'VerticalFont',
      DEFAULT_FONT_VERTICAL), DEFAULT_FONT_VERTICAL);
    Options.VerticalFont.Assign(font);
    FreeAndNil(font);
    Options.VerticalFont.Charset := Ini.ReadInteger('VisualOptions','VerticalFontCharset',DEFAULT_CHARSET);

    Options.ToolbarColorScheme := Ini.ReadInteger('VisualOptions', 'ToolbarColorScheme',0);
    Options.VisualStyleFilename := Ini.ReadString('VisualOptions','VisualStyle','');

    // Preview Options
    Options.PreviewFont.Name := Ini.ReadString('Preview','FontName','Courier New');
    Options.PreviewFont.Size := Ini.ReadInteger('Preview','FontSize',8);
    Options.PreviewFont.Color := Ini.ReadInteger('Preview','FontColor',clWindowText);
    SetSetProp(Options.PreviewFont,'Style',Ini.ReadString('Preview','FontStyle',''));
    Options.PreviewFont.Charset := Ini.ReadInteger('Preview','FontCharset',DEFAULT_CHARSET);
    Options.DefaultPreviewTab := DefaultTabType(Ini.ReadInteger('Preview','DefaultPreviewTab', Integer(TAB_LAST_USED)));
    Options.DefaultSpamTab := DefaultTabType(Ini.ReadInteger('Preview','DefaultSpamTab', Integer(TAB_PLAIN_TEXT)));
    Options.ShowImages := Ini.ReadBool('Preview','ShowImages',true);
    Options.PreviewBgColor := Ini.ReadInteger('Preview','PreviewBgColor',clWindow);
    Options.ShowXMailer := Ini.ReadBool('Preview','ShowXMailer',false);

    DebugOptions.ProtocolLogging := Ini.ReadBool('DebugOptions','ProtocolLogging',false);

    // num accounts
    IniNumAccounts := Ini.ReadInteger('Options','NumAccounts',0);
  finally
     Ini.Free;
  end;

  // white / black list
  if FileExists(IniPath+'WhiteList.ptdat') then
    Options.WhiteList.LoadFromFile(IniPath+'WhiteList.ptdat',TEncoding.UTF8);
  if FileExists(IniPath+'BlackList.ptdat') then
    Options.BlackList.LoadFromFile(IniPath+'BlackList.ptdat',TEncoding.UTF8);


  frmPopUMain.UpdateUIAfterLoadingIni();
end;


{*------------------------------------------------------------------------------
  Saves both the blacklist and whitelist to files
-------------------------------------------------------------------------------}
procedure SaveWhiteBlackListsToFile;
begin
  // white/black list
  if Options.WhiteList.Count > 0 then
    SaveWhitelistToFile()
  else
    System.SysUtils.DeleteFile(ExtractFilePath(IniName) + 'WhiteList.ptdat');
  if Options.BlackList.Count > 0 then
    SaveBlacklistToFile()
  else
    System.SysUtils.DeleteFile(ExtractFilePath(IniName) + 'BlackList.ptdat');
end;

{*------------------------------------------------------------------------------
  Saves the whitelist to file
-------------------------------------------------------------------------------}
procedure SaveWhitelistToFile();
begin
  Options.WhiteList.SaveToFile(ExtractFilePath(IniName)+'WhiteList.ptdat', TEncoding.UTF8);
end;

{*------------------------------------------------------------------------------
  Saves the blacklist to file
-------------------------------------------------------------------------------}
procedure SaveBlacklistToFile();
begin
  Options.BlackList.SaveToFile(ExtractFilePath(IniName)+'BlackList.ptdat', TEncoding.UTF8);
end;

{*------------------------------------------------------------------------------
  Saves options globals to PopTray.ini
-------------------------------------------------------------------------------}
procedure SaveOptionsINI;
var
  Ini : TIniFile;
  i : integer;
begin
  Ini := TIniFile.Create(IniName);
  try
    try
    // interval
    Ini.WriteFloat('Options','Interval',Options.Interval);
    Ini.WriteBool('Options','TimerAccount',Options.TimerAccount);
    // defaults
    Ini.WriteString('Options','Program',Options.MailProgram);
    Ini.WriteString('Options','Sound',Options.DefSound);

    // options
    with Options do
    begin
      // general options
      Ini.WriteBool('Options','CheckStartup',Startup);
      Ini.WriteBool('Options','Minimized',Minimized);
      Ini.WriteBool('Options','AnimatedTray',Animated);
      Ini.WriteBool('Options','ResetTray',ResetTray);
      Ini.WriteBool('Options','RotateIcon',RotateIcon);
      Ini.WriteBool('Options','ShowForm',ShowForm);
      Ini.WriteBool('Options','Balloon',Balloon);
      Ini.WriteBool('Options','DeleteNextCheck',DeleteNextCheck);
      Ini.WriteInteger('Options','FirstWait',FirstWait);
      Ini.WriteBool('Options','Use24HrTime',Use24HrTime);
      // advanced - connection
      Ini.WriteInteger('Options','TimeOut',TimeOut);
      Ini.WriteBool('Options','QuickCheck',QuickCheck);
      Ini.WriteBool('Options','CheckWhileMinimized',CheckWhileMinimized);
      Ini.WriteBool('Options','IgnoreRetrieveErrors',IgnoreRetrieveErrors);
      Ini.WriteBool('Options','ShowErrorsInBalloons',ShowErrorsInBalloons);
      Ini.WriteBool('Options','CheckOnline',Online);
      Ini.WriteInteger('Options','TopLines',TopLines);
      Ini.WriteBool('Options','PreferEnvelopes',PreferEnvelopes);
      Ini.WriteBool('Options','GetBody',GetBody);
      Ini.WriteInteger('Options','GetBodyLines',GetBodyLines);
      Ini.WriteInteger('Options','GetBodySize',GetBodySize);
      // advanced - interface
      Ini.WriteInteger('Options','CheckingIcon',CheckingIcon);
      Ini.WriteBool('Options','ShowViewed',ShowViewed);
      Ini.WriteBool('Options','CloseMinimize',CloseMinimize);
      Ini.WriteBool('Options','MinimizeTray',MinimizeTray);
      Ini.WriteBool('Options','NoError',NoError);
      Ini.WriteBool('Options','MultilineAccounts',MultilineAccounts);
      Ini.WriteBool('Options','DeleteConfirm',DeleteConfirm);
      Ini.WriteBool('Options','DeleteConfirmProtected',DeleteConfirmProtected);
      Ini.WriteBool('Options','OnTop',OnTop);
      Ini.WriteBool('Options','AdvInfo',AdvInfo);
      Ini.WriteInteger('Options','AdvInfoDelay',AdvInfoDelay);
      Ini.WriteBool('Options','HideViewed',HideViewed);
      Ini.WriteBool('Options','DoubleClickDelay',DoubleClickDelay);
      Ini.WriteBool('Options','ShowWhileChecking',ShowWhileChecking);
      Ini.WriteInteger('Options','ToolbarSpamAction',ToolbarSpamAction);
      Ini.WriteBool('Options','AutoClosePreviewWindows',AutoClosePreviewWindows);
      Ini.WriteBool('Options','UseCustomDateFormat',UseCustomDateFormat);
      Ini.WriteString('Options','CustomDateFormatString',CustomDateFormatString);
      // advanced - misc
      Ini.WriteBool('Options','UseMAPI',UseMAPI);
      Ini.WriteBool('Options','LogRules',LogRules);
      Ini.WriteBool('Options','SafeDelete',SafeDelete);
      Ini.WriteBool('Options','RememberViewed',RememberViewed);
      Ini.WriteBool('Options','BlackListSpam',BlackListSpam);
      Ini.WriteBool('Options','DontCheckTimes',DontCheckTimes);
      Ini.WriteTime('Options','DontCheckStart',DontCheckStart);
      Ini.WriteTime('Options','DontCheckEnd',DontCheckEnd);

      Ini.WriteString('Options','TempEmailFilename',TempEmailFilename);
      Ini.WriteBool('Options','ShowNewestMessagesOnly',ShowNewestMessagesOnly);
      Ini.WriteInteger('Options','NumNewestMsgToShow',NumNewestMsgToShow);
    end;

    // password
    Ini.WriteBool('Options','PasswordProtect',Options.PasswordProtect);
    Ini.WriteString('Options','Password',Encrypt(Options.Password));

    // mouse button actions
    Ini.WriteInteger('MouseButtons','Left',Options.LeftClick);
    Ini.WriteInteger('MouseButtons','Right',Options.RightClick);
    Ini.WriteInteger('MouseButtons','Middle',Options.MiddleClick);
    Ini.WriteInteger('MouseButtons','Double',Options.DblClick);
    Ini.WriteInteger('MouseButtons','ShiftLeft',Options.ShiftLeftClick);
    Ini.WriteInteger('MouseButtons','ShiftRight',Options.ShiftRightClick);
    Ini.WriteInteger('MouseButtons','ShiftMiddle',Options.ShiftMiddleClick);

    // hotkey actions
    Ini.WriteInteger('HotKeys','HotKeyAction1',Options.Action1);
    Ini.WriteInteger('HotKeys','HotKeyAction2',Options.Action2);
    Ini.WriteInteger('HotKeys','HotKeyAction3',Options.Action3);
    Ini.WriteInteger('HotKeys','HotKeyAction4',Options.Action4);

    // hot-keys
    Ini.WriteInteger('HotKeys','HotKey1',Options.HotKey1);
    Ini.WriteInteger('HotKeys','HotKey2',Options.HotKey2);
    Ini.WriteInteger('HotKeys','HotKey3',Options.HotKey3);
    Ini.WriteInteger('HotKeys','HotKey4',Options.HotKey4);

    // languages
    Ini.WriteInteger('Languages','Active',Options.Language);
    Ini.WriteInteger('Languages','Count',Length(Options.Languages)-1);
    for i := 1 to Length(Options.Languages)-1 do
      Ini.WriteString('Languages','Language'+IntToStr(i),TranslateToEnglish(Options.Languages[i]));

    // plug-ins
//    Ini.WriteInteger('Plug-ins','Count',Length(Plugins));
//    for i := 0 to Length(Plugins)-1 do
//    begin
//      Ini.WriteString('Plug-ins','PluginName'+IntToStr(i+1),Plugins[i].Name);
//      Ini.WriteString('Plug-ins','PluginDLLName'+IntToStr(i+1),Plugins[i].DLLName);
//      Ini.WriteBool('Plug-ins','PluginEnabled'+IntToStr(i+1),Plugins[i].Enabled);
//      Ini.WriteInteger('Plug-ins','PluginType'+IntToStr(i+1),Integer(Plugins[i].PluginType));
//    end;

    // Visual appearance
    Ini.WriteString('VisualOptions', 'ListboxFont', FontToString(Options.ListboxFont));
    Ini.WriteString('VisualOptions', 'ListboxBg',ColorToString(Options.ListboxBg));
    Ini.WriteString('VisualOptions', 'GlobalFont', FontToString(Options.GlobalFont));
    Ini.WriteString('VisualOptions', 'VerticalFont', FontToString(Options.VerticalFont));
    Ini.WriteInteger('VisualOptions', 'ToolbarColorScheme', Options.ToolbarColorScheme);
    Ini.WriteString('VisualOptions', 'VisualStyle', Options.VisualStyleFilename);
    Ini.WriteInteger('VisualOptions', 'ListboxFontCharset', Options.ListboxFont.Charset);
    Ini.WriteInteger('VisualOptions', 'GlobalFontCharset', Options.GlobalFont.Charset);
    Ini.WriteInteger('VisualOptions', 'VerticalFontCharset', Options.VerticalFont.Charset);

    // Preview Options
    Ini.WriteString('Preview','FontName',Options.PreviewFont.Name);
    Ini.WriteInteger('Preview','FontSize',Options.PreviewFont.Size);
    Ini.WriteInteger('Preview','FontColor',Options.PreviewFont.Color);
    Ini.WriteString('Preview','FontStyle',GetSetProp(Options.PreviewFont,'Style'));
    Ini.WriteInteger('Preview','FontCharset',Options.PreviewFont.Charset);
    Ini.WriteBool('Settings','DisableHtmlPreview',Options.DisableHtmlPreview);
    Ini.WriteInteger('Preview','DefaultPreviewTab',Integer(Options.DefaultPreviewTab));
    Ini.WriteInteger('Preview','DefaultSpamTab',Integer(Options.DefaultSpamTab));
    Ini.WriteBool('Preview', 'ShowImages', Options.ShowImages);
    Ini.WriteInteger('Preview','PreviewBgColor', Options.PreviewBgColor);
    Ini.ReadBool('Preview','ShowXMailer',Options.ShowXMailer);

    // Don't add DebugOptions to ini file unless debugging options are in use somehow.
    if Ini.ValueExists('DebugOptions','ProtocolLogging') or DebugOptions.ProtocolLogging then
      Ini.WriteBool('DebugOptions','ProtocolLogging',DebugOptions.ProtocolLogging);

    except
      on e: EIniFileException do begin
        ShowTranslatedDlg(e.Message, mtError, [mbOK], 0, 'Error Saving PopTrayU Settings');
      end;
    end;
  finally
     Ini.Free;
  end;
  SaveWhiteBlackListsToFile;
end;

{*------------------------------------------------------------------------------
  Loads a single account from the ini file
-------------------------------------------------------------------------------}
procedure LoadAccountINI(num : integer);
var
  Ini : TIniFile;
  section : string;
begin
  Ini := TIniFile.Create(IniName);
  try
    try
    section := 'Account'+IntToStr(num);
    Accounts[num-1].LoadAccountFromINI(Ini, section);
    LoadViewedMessageIDs(num);
    except
      Assert(false);     //TODO add better error handling here.
      Exit;
    end;
  finally
     Ini.Free;
  end;
end;

{*------------------------------------------------------------------------------
  Saves a single account to the ini file
-------------------------------------------------------------------------------}
procedure SaveAccountINI(num : integer);
var
  Ini : TMemIniFile;
  section : string;
begin
  // write to ini
  Ini := TMemIniFile.Create(IniName);
  try
    section := 'Account'+IntToStr(num);
    Accounts[num-1].SaveAccountToIniFile(Ini, section);
    Ini.WriteInteger('Options','NumAccounts',Accounts.NumAccounts);
    try
      Ini.UpdateFile;
    except
      on e: Exception do begin //eg: EFCreateError
        ShowTranslatedDlg(e.Message, mtError, [mbOK], 0, 'Error Saving PopTrayU Settings');
      end;
    end;
  finally
     Ini.Free;
  end;
end;

{*------------------------------------------------------------------------------
  Gets the default e-mail program from registry 
-------------------------------------------------------------------------------}
function GetDefaultEmail: string;
var
  Reg: TRegistry;
  EMailClient : string;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('\Software\Clients\Mail', False) then
    begin
      EMailClient := Reg.ReadString('');
      Reg.CloseKey;
      Reg.OpenKey('\Software\Clients\Mail\'+EMailClient+'\shell\open\command', False);
      EMailClient := Reg.ReadString('');
      EMailClient := ExpandEnv(EMailClient);
      Result := EMailClient;
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;


{*------------------------------------------------------------------------------
  Load viewed message ids from file                                             
-------------------------------------------------------------------------------}
procedure LoadViewedMessageIDs(num : integer);
var
  filename : string;
begin
  if Options.RememberViewed then
  begin
    filename := ExtractFilePath(IniName)+'Account_'+IntToStr(num)+'.ids';
    if FileExists(filename) then
      Accounts[num-1].ViewedMsgIDs.LoadFromFile(filename); //ANSI is ok here
  end;
end;

{*------------------------------------------------------------------------------
  Save viewed message ids to file                                              
-------------------------------------------------------------------------------}
procedure SaveViewedMessageIDs;
var
  num : integer;
  filename : string;
begin
  if Options.RememberViewed then
  begin
    try
      for num := 1 to Accounts.NumAccounts do
      begin
        filename := ExtractFilePath(IniName)+'Account_'+IntToStr(num)+'.ids';
        if Accounts[num-1].ViewedMsgIDs.Count > 0 then
          Accounts[num-1].ViewedMsgIDs.SaveToFile(filename); //Ansi is fine here, these should not be unicode
      end;
    except
      on E:Exception do MessageDlg(E.Message,mtError,[mbOK],0);
    end;
  end;
end;

{*------------------------------------------------------------------------------
 Save all the rules to INI file
-------------------------------------------------------------------------------}
procedure SaveRulesINI();
var
  Ini : TMemIniFile; // use TCustomIniFile except for create
  i,numrules : integer;
begin
  // If we are upgrading from an old version of PopTray, we might need to
  // delete obsolete Rules sections from PopTray.ini to clean up
  if not FileExists(RulesFileName) then //if Rules.ini doesn't exist
  begin
    Ini := TMemIniFile.Create(IniName); //Remove Rules from Poptray.ini
    try
      numrules := Ini.ReadInteger('Options','NumRules',0);
      for i := 1 to numrules do
        Ini.EraseSection('Rule'+IntToStr(i));
      Ini.DeleteKey('Options','NumRules');
      Ini.UpdateFile;
    finally
      Ini.Free;
    end;
  end;
  // save to rules.ini
  Ini := TMemIniFile.Create(RulesFileName);
  try
    RulesManager.SaveRulesToFile(Ini);
    Ini.UpdateFile;
  finally
     Ini.Free;
  end;

  // Regardless of *why* we saved the rules, now that they're saved, the
  // buttons for saving or canceling changes to the rules should be
  // disabled unconditionally, since you can't undo this saving of the rules.
  frmPopUMain.RulesForm.btnSaveRules.Enabled := False;
  frmPopUMain.RulesForm.btnCancelRule.Enabled := False;
end;


{*------------------------------------------------------------------------------
  Get window position,window size and column widths from INI                   
-------------------------------------------------------------------------------}
procedure LoadPosINI();
var
  Ini : TIniFile;
  i,j,ColWidth,SortType : integer;
  colId : integer;
begin
  Ini := TIniFile.Create(IniName);
  try
    // form
    frmPopUMain.Width := Ini.ReadInteger('Position','Width',frmPopUMain.Width);
    frmPopUMain.Height := Ini.ReadInteger('Position','Height',frmPopUMain.Height);
    frmPopUMain.Left := Ini.ReadInteger('Position','Left',Screen.WorkAreaWidth-frmPopUMain.Width);
    frmPopUMain.Top := Ini.ReadInteger('Position','Top',Screen.WorkAreaHeight-frmPopUMain.Height);
    frmPopUMain.panMailButtonsResize(frmPopUMain.panMailButtons);
    // columns
    SortType := Ini.ReadInteger('Position','SortType',-1);
    frmPopUMain.FSortDirection := Ini.ReadInteger('Position','SortDirection',frmPopUMain.FSortDirection);
    dm.mnuSpamLast.Checked := Ini.ReadBool('Position', 'SortSpamLast', False);

    // re-order the columns
    for i := 0 to NUM_COLUMNS-1 do begin
      colId := Ini.ReadInteger('Position','Column'+IntToStr(i+1)+'ID',i);

      // the index of the remaining columns change as we move the columns
      // into the correct order
      for j := i to NUM_COLUMNS-1 do begin
        if frmPopUMain.lvMail.Columns[j].ID = colId then begin
          frmPopUMain.lvMail.Columns[j].index := i;
          break;
        end;
      end;
    end;

    // load column widths (do this AFTER ordering the columns)
    for i := 0 to 4 do
    begin
      ColWidth := Ini.ReadInteger('Position','Column'+IntToStr(i+1),frmPopUMain.lvMail.Columns[i].Width);
      if ColWidth = 0 then
        frmPopUMain.lvMail.Columns[i].MinWidth := 0;
      frmPopUMain.lvMail.Columns[i].Width := ColWidth;
    end;
    // load column to sort by (do this AFTER ordering the columns)
    frmPopUMain.SetSortType(TSortType(SortType));

    // tree widths
    frmPopUMain.OptionsForm.tvOptions.Width := Ini.ReadInteger('Position','OptionTree',145);
    frmPopUMain.RulesForm.panRuleList.Width := Ini.ReadInteger('Position','RuleList',100);
    // on screen?
    if frmPopUMain.Left < 0 then frmPopUMain.Left := 0;
    if frmPopUMain.top < 0 then frmPopUMain.Top := 0;
    if frmPopUMain.Left > Screen.WorkAreaWidth then
      frmPopUMain.Left := Screen.WorkAreaWidth - frmPopUMain.Width;
    if frmPopUMain.Top > Screen.WorkAreaHeight then
      frmPopUMain.Top := Screen.WorkAreaHeight - frmPopUMain.Height;
    // info
    Options.InfoTab := Ini.ReadInteger('Info','Tab',0);
    Options.InfoCol1 := Ini.ReadInteger('Info','Column1',70);
    Options.InfoCol2 := Ini.ReadInteger('Info','Column2',85);
    Options.InfoCol3 := Ini.ReadInteger('Info','Column3',120);
    Options.InfoCol4 := Ini.ReadInteger('Info','Column4',50);
    if (Options.InfoCol1=0) and (Options.InfoCol2=0) and
       (Options.InfoCol3=0) and (Options.InfoCol4=0) then
    begin
      Options.InfoCol1 := 70;
      Options.InfoCol2 := 85;
      Options.InfoCol3 := 120;
      Options.InfoCol4 := 50;
    end;
    frmPopUMain.AccountsForm.catAccName.Collapsed := Ini.ReadBool('Position','AccountNameCollapsed', false);
    frmPopUMain.AccountsForm.catBasicAccount.Collapsed := Ini.ReadBool('Position','BasicAccountCollapsed',false);
    frmPopUMain.AccountsForm.catAdvAcc.Collapsed := Ini.ReadBool('Position','AdvancedAccountCollapsed', true);
    frmPopUMain.AccountsForm.catPopTrayAccountPrefs.Collapsed := Ini.ReadBool('Position','AccountPrefsCollapsed',false);
  finally
     Ini.Free;
  end;
end;

{*------------------------------------------------------------------------------
  Save window position,window size and column widths to INI
-------------------------------------------------------------------------------}
procedure SavePosINI;
var
  Ini : TMemIniFile;
begin
  Ini := TMemIniFile.Create(IniName);
  try
    // form position
    Ini.WriteInteger('Position','Left',frmPopUMain.Left);
    Ini.WriteInteger('Position','Top',frmPopUMain.Top);
    Ini.WriteInteger('Position','Width',frmPopUMain.Width);
    Ini.WriteInteger('Position','Height',frmPopUMain.Height);
    // columns
    Ini.WriteInteger('Position','SortType',Integer(frmPopUMain.FSortType));
    Ini.WriteInteger('Position','SortDirection',frmPopUMain.FSortDirection);
    Ini.WriteBool('Position','SortSpamLast',dm.mnuSpamLast.Checked);

    Ini.WriteInteger('Position','Column1',frmPopUMain.lvMail.Columns[0].Width);
    Ini.WriteInteger('Position','Column2',frmPopUMain.lvMail.Columns[1].Width);
    Ini.WriteInteger('Position','Column3',frmPopUMain.lvMail.Columns[2].Width);
    Ini.WriteInteger('Position','Column4',frmPopUMain.lvMail.Columns[3].Width);
    Ini.WriteInteger('Position','Column5',frmPopUMain.lvMail.Columns[4].Width);
    // column order
    Ini.WriteInteger('Position','Column1ID',frmPopUMain.lvMail.Columns[0].ID);
    Ini.WriteInteger('Position','Column2ID',frmPopUMain.lvMail.Columns[1].ID);
    Ini.WriteInteger('Position','Column3ID',frmPopUMain.lvMail.Columns[2].ID);
    Ini.WriteInteger('Position','Column4ID',frmPopUMain.lvMail.Columns[3].ID);
    Ini.WriteInteger('Position','Column5ID',frmPopUMain.lvMail.Columns[4].ID);

    // list widths
    Ini.WriteInteger('Position','OptionTree',frmPopUMain.OptionsForm.tvOptions.Width);
    Ini.WriteInteger('Position','RuleList',frmPopUMain.RulesForm.panRuleList.Width);
    // info
    Ini.WriteInteger('Info','Tab',Options.InfoTab);
    Ini.WriteInteger('Info','Column1',Options.InfoCol1);
    Ini.WriteInteger('Info','Column2',Options.InfoCol2);
    Ini.WriteInteger('Info','Column3',Options.InfoCol3);
    Ini.WriteInteger('Info','Column4',Options.InfoCol4);

    Ini.WriteBool('Position','AccountNameCollapsed',frmPopUMain.AccountsForm.catAccName.Collapsed);
    Ini.WriteBool('Position','BasicAccountCollapsed',frmPopUMain.AccountsForm.catBasicAccount.Collapsed);
    Ini.WriteBool('Position','AdvancedAccountCollapsed',frmPopUMain.AccountsForm.catAdvAcc.Collapsed);
    Ini.WriteBool('Position','AccountPrefsCollapsed',frmPopUMain.AccountsForm.catPopTrayAccountPrefs.Collapsed);
    try
      Ini.UpdateFile;
    except
      on E:Exception do MessageDlg(E.Message,mtError,[mbOK],0);
    end;
  finally
     Ini.Free;
  end;
end;

{*------------------------------------------------------------------------------
  Get the rules from INI file.                 
  If Rules.ini doesn't exist read from PopTray.ini
-------------------------------------------------------------------------------}
procedure LoadRulesINI;
var
  Ini : TMemIniFile;
  NewRulesFormat : boolean;
begin
  NewRulesFormat := FileExists(RulesFileName);
  if NewRulesFormat then
    Ini := TMemIniFile.Create(RulesFileName) //load rules from Rules.ini
  else
    Ini := TMemIniFile.Create(IniName); //load rules from PopTray.ini

  try
    RulesManager.LoadRulesFromFile(Ini, NewRulesFormat);
  finally
     Ini.Free;
  end;
end;

end.

