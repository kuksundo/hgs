{   MPUI, an MPlayer frontend for Windows
    Copyright (C) 2005 Martin J. Fiedler <martin.fiedler@gmx.net>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}
program MPUI;



uses
  sysutils,
  windows,
  Forms,
  VssAppVersion in 'VclAddOns\VssAppVersion.pas',
  VssThisAppVersion in 'VclAddOns\VssThisAppVersion.pas',
  UfrmMain in 'Forms\UfrmMain.pas' {frmMain},
  UfrmLog in 'Forms\UfrmLog.pas' {frmLog},
  URL in 'URL.pas',
  UfrmHelp in 'Forms\UfrmHelp.pas' {frmHelp},
  UFrmAbout in 'Forms\UFrmAbout.pas' {frmAbout},
  Locale in 'Locale\Locale.pas',
  UfrmOptions in 'Forms\UfrmOptions.pas' {frmOptions},
  Config in 'Config.pas',
  mo_en in 'Locale\mo_en.pas',
  mo_es in 'Locale\mo_es.pas',
  mo_fr in 'Locale\mo_fr.pas',
  UfrmPlaylist in 'Forms\UfrmPlaylist.pas' {frmPlayList},
  UfrmInfo in 'Forms\UfrmInfo.pas' {frmInfo},
  UfrmSettings in 'Forms\UfrmSettings.pas' {frmSettings},
  FormLocal in 'FormClasses\FormLocal.pas',
  mplayer in 'mplayer.pas',
  NumUtils in 'NumUtils.pas',
  AutoselectEdits in 'Controls\AutoselectEdits.pas',
  mp3parser in 'mp3parser.pas',
  FileClasses in 'FileClasses.pas',
  FileUtils in 'FileUtils.pas',
  VisEffects in 'VisEffects.pas',
  VssList in 'VssList.pas',
  VssDockForm in 'FormClasses\VssDockForm.pas',
  CustomFormsHelper in 'VclAddOns\CustomFormsHelper.pas',
  UVssProgressForm in 'Controls\UVssProgressForm.pas' {VssProgressForm},
  UVssColorPicker in 'Controls\UVssColorPicker.pas' {VssColorPicker: TFrame},
  FormsFixed in 'VclAddOns\FormsFixed.pas',
  UVssColorpickerForm in 'Controls\UVssColorpickerForm.pas' {VssColorPickerForm},
  VssIniFiles in 'VssIniFiles.pas',
  VssScrollbar in 'Controls\VssScrollbar.pas',
  VssPlaylist in 'VssPlaylist.pas';

{$R *.res}
{$R XPStyle.res}
(*
var
prev : int64;
act : int64;
freq : int64;
*)
begin
  //QueryPerformanceFrequency(freq);
  //QueryPerformanceCounter(prev);
  //ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.Title := 'MPUI-Ve';
  Application.MainFormOnTaskBar := True;

  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmLog, frmLog);
  (*
  QueryPerformanceCounter(act);
  logform.AddLine(inttostr(1000*(act-prev) div freq));
  prev := act;
  *)
  Application.Run;

end.


