program PopTrayU;

{-------------------------------------------------------------------------------
POPTRAY
Copyright (C) 2001-2005  Renier Crause
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

{$R 'PopTrayXP.res' 'PopTrayXP.rc'}

// Since PopTrayU only runs on Windows, turn off warnings for platform
// specific calls like DebugHook.
{$WARN SYMBOL_PLATFORM OFF}
//{$DEFINE LOG4D}


// dontTouchUses

uses
  {$ifdef madExcept}
  madExcept,
  {$endif }
  {$IFDEF LOG4D}
  Log4D,
  {$ENDIF LOG4D}
  Forms,
  Windows,
  SysUtils,
  uMain in 'uMain.pas' {frmPopUMain},
  uPreview in 'uPreview.pas' {frmPreview},
  uRCUtils in 'uRCUtils.pas',
  uPassword in 'uPassword.pas' {frmPassword},
  uFrameInterval in 'uFrameInterval.pas' {frameInterval: TFrame},
  uFrameDefaults in 'uFrameDefaults.pas' {frameDefaults: TFrame},
  uFrameGeneralOptions in 'uFrameGeneralOptions.pas' {frameGeneralOptions: TFrame},
  uFrameMainWindowOptions in 'uFrameMainWindowOptions.pas' {frameMainWindowOptions: TFrame},
  uFrameAdvancedOptions in 'uFrameAdvancedOptions.pas' {frameAdvancedOptions: TFrame},
  uFrameMouseButtons in 'uFrameMouseButtons.pas' {frameMouseButtons: TFrame},
  uFrameHotKeys in 'uFrameHotKeys.pas' {frameHotKeys: TFrame},
  uFramePlugins in 'uFramePlugins.pas' {framePlugins: TFrame},
  uFrameVisualAppearance in 'uFrameVisualAppearance.pas' {frameVisualAppearance: TFrame},
  uDM in 'uDM.pas' {dm: TDataModule},
  uInfo in 'uInfo.pas' {frmInfo},
  uFrameWhiteBlack in 'uFrameWhiteBlack.pas' {frameWhiteBlack: TFrame},
  uPlugins in 'uPlugins.pas',
  uGlobal in 'uGlobal.pas',
  uPOP3 in 'uPOP3.pas',
  uIMAP4 in 'uIMAP4.pas',
  uMailItems in 'uMailItems.pas',
  RegExpr in 'RegExpr.pas',
  uFontUtils in 'uFontUtils.pas',
  uHtmlDecoder in 'uHtmlDecoder.pas',
  uTranslate in 'uTranslate.pas',
  unCustomImageDrawHook in 'unCustomImageDrawHook.pas',
  uIniSettings in 'uIniSettings.pas',
  Vcl.Themes,
  Vcl.Styles,
  DateTimePickers in 'DateTimePickers.pas',
  Vcl.PlatformVclStylesActnCtrls in 'Vcl.PlatformVclStylesActnCtrls.pas',
  uTranslateDebugWindow in 'uTranslateDebugWindow.pas' {TranslateDebugWindow},
  uWebBrowserTamed in 'uWebBrowserTamed.pas',
  uRegExp in 'uRegExp.pas',
  uAccounts in 'uAccounts.pas',
  uRules in 'uRules.pas',
  uMailManager in 'uMailManager.pas',
  uRulesManager in 'uRulesManager.pas',
  uRulesForm in 'uRulesForm.pas' {RulesForm},
  uAccountsForm in 'uAccountsForm.pas' {AccountsForm},
  uPositioning in 'uPositioning.pas',
  uOptionsForm in 'uOptionsForm.pas' {OptionsForm},
  uAboutForm in 'uAboutForm.pas' {AboutForm},
  uFrameRulesOptions in 'uFrameRulesOptions.pas' {FrameRulesOptions: TFrame},
  uFramePreviewOptions in 'uFramePreviewOptions.pas' {FramePreviewOptions: TFrame},
  uCustomColorDialog in 'uCustomColorDialog.pas' {CustomColorDialog},
  uConstants in 'uConstants.pas',
  uProtocol in 'uProtocol.pas',
  ExportAcctDlg in 'ExportAcctDlg.pas' {ExportAccountsDlg},
  uImportAccountDlg in 'uImportAccountDlg.pas' {ImportAcctDlg},
  uImapFolderSelect in 'uImapFolderSelect.pas' {ImapFolderSelectDlg},
  SynTaskDialog in 'SynTaskDialog.pas',
  uRegistryFxns in 'uRegistryFxns.pas',
  TDEMU in 'TDEMU.PAS',
  SHDocVw_TLB in 'C:\Users\Administrator\Documents\RAD Studio\12.0\Imports\SHDocVw_TLB.pas';

{$R *.RES}

var
  hFirstWin : HWND;
  param : integer;
{$IFDEF LOG4D}
  Logger : TLogLogger;
{$ENDIF LOG4D}
begin
{$IFDEF LOG4D}
  TLogBasicConfigurator.Configure;

  // set the log level
  TLogLogger.GetRootLogger.Level := All;

  // create a named logger
  Logger := TLogLogger.GetLogger('poptrayuLogger');
  Logger.addAppender(TLogFileAppender.Create('filelogger','log4d.log'));


{$ENDIF LOG4D}


  if not ParamSwitch('MULTIPLE') then
  begin
    // check for previous instance
    hFirstWin := FindWindow('TfrmPopUMain', nil);
    if (hfirstWin = 0) then
    begin
      // If on a unicode platform, the class will have a different name.
      hFirstWin := FindWindow('TfrmPopUMain.UnicodeClass', nil);
    end;
    //if existing instance found AND we are NOT running in the debugger
    if (hFirstWin <> 0) {AND (DebugHook = 0)} then
    begin
      // If /ACTION specified on command line, execute actions, then quit
      param := ParamSwitchIndex('ACTION');
      if (param > 0) then
      begin
          repeat
            PostMessage(hFirstWin, UM_ACTION, Integer(StrToAction(ParamSwitchValue(param))), 0);
            param := ParamSwitchIndex('ACTION',param);
          until param = 0;
          Exit;
      end;

      // If /QUIT switch given, Kill other instance and then quit this one.
      if ParamSwitch('QUIT') then
      begin
          PostMessage(hFirstWin, UM_QUIT, 0, 0);
          Exit;
      end;

      // If user launches a second instance without /MULTIPLE switch,
      // Give focus to existing instance rather than launching a second copy.
      PostMessage(hFirstWin, UM_ACTIVATE, 0, 0);
      Exit;
    end;
    // If /QUIT specified but app isn't already running, just exit
    if ParamSwitch('QUIT') then Exit;
  end;

  // we expect to get here if the user specified /MULTIPLE, or if we've
  // fallen through the previous cases because PopTrayU isn't already
  // running, or if we are running in the debugger. In these cases, continue
  // initialization and start our new instance of the App/UI/etc.
  Application.Initialize;
  // MainFormOnTaskBar this must be false to prevent child forms from being
  // always on top of the main form. http://qc.embarcadero.com/wc/qcmain.aspx?d=49410
  Application.MainFormOnTaskBar := false;
  Application.ShowMainForm := False;
  Application.Title := 'PopTrayU'; //App Title on Windows Taskbar
  //if ParamSwitch('TRANSLATE') then
  //  Application.CreateForm(TTranslateDebugWindow, TranslateDebugWindow);

  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TfrmPopUMain, frmPopUMain);
  Application.CreateForm(TExportAccountsDlg, ExportAccountsDlg);
  Application.CreateForm(TImportAcctDlg, ImportAcctDlg);
  Application.CreateForm(TImapFolderSelectDlg, ImapFolderSelectDlg);
  Application.Run;

end.


