{   MPUI-hcb, an MPlayer frontend for Windows
    Copyright (C) 2006-2011 Huang Chen Bin <hcb428@foxmail.com>
    based on work by Martin J. Fiedler <martin.fiedler@gmx.net>

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
  Windows,
  Forms,
  TntForms,
  TntSysUtils,
  TntSystem,
  Main in 'Main.pas' {MainForm},
  Core in 'Core.pas',
  Locale in 'Locale.pas',
  Options in 'Options.pas' {OptionsForm},
  Config in 'Config.pas',
  mo_en in 'mo_en.pas',
  mo_ar in 'mo_ar.pas',
  mo_bg in 'mo_bg.pas',
  mo_by in 'mo_by.pas',
  mo_cz in 'mo_cz.pas',
  mo_de in 'mo_de.pas',
  mo_es in 'mo_es.pas',
  mo_eo in 'mo_eo.pas',
  mo_fr in 'mo_fr.pas',
  mo_it in 'mo_it.pas',
  mo_hu in 'mo_hu.pas',
  mo_kr in 'mo_kr.pas',
  mo_pl in 'mo_pl.pas',
  mo_ro in 'mo_ro.pas',
  mo_ru in 'mo_ru.pas',
  mo_ua in 'mo_ua.pas',
  mo_jp in 'mo_jp.pas',
  mo_sk in 'mo_sk.pas',
  mo_dk in 'mo_dk.pas',
  mo_pt in 'mo_pt.pas',
  mo_nl in 'mo_nl.pas',
  mo_cn in 'mo_cn.pas',
  mo_zh_tw in 'mo_zh_tw.pas',
  plist in 'Plist.pas' {PlaylistForm},
  Info in 'Info.pas' {InfoForm},
  UnRAR in 'UnRAR.pas',
  SevenZip in 'SevenZip.pas',
  SevenZipVCL in 'SevenZipVCL.pas',
  Equalizer in 'Equalizer.pas' {EqualizerForm},
  OpenDevice in 'OpenDevice.pas' {OpenDevicesForm},
  DLyric in 'DLyric.pas' {DLyricForm},
  md5 in 'md5.pas',
  GDILyrics in 'GDILyrics.pas',
  GDIPAPI in 'GDIPAPI.pas',
  GDIPOBJ in 'GDIPOBJ.pas',
  LyricShow in 'LyricShow.pas' {LyricShowForm},
  MediaInfoDll in 'MediaInfoDLL.pas';

{$R *.res}
{$R XPStyle.res}

var hAppMutex: Thandle; Mf: hWnd; s: WideString; t: string; i, PCount: integer;
begin
  Init;
  if Win32PlatformIsVista and (WideParamStr(1) = '/adminoption') then begin
    regAss; exit;
  end;

  hAppMutex := CreateMutex(nil, false, PChar('hcb428'));
  if oneM and (WaitForSingleObject(hAppMutex, 10) = WAIT_TIMEOUT) then begin
    if Win32PlatformIsUnicode then Mf := FindWindow('hcb428.UnicodeClass', nil)
    else Mf := FindWindow('hcb428', nil);
    if Mf <> 0 then begin
      if Win32PlatformIsUnicode then begin
        PCount := WideParamCount;
        for i := 1 to PCount do begin
          s := WideParamStr(i);
          if s <> '-enqueue' then SendMessage(Mf, $0401, GlobalAddAtomW(PWChar(S)), Length(S));
        end;
      end
      else begin
        PCount := ParamCount;
        for i := 1 to PCount do begin
          t := ParamStr(i);
          if s <> '-enqueue' then SendMessage(Mf, $0401, GlobalAddAtom(PChar(t)), Length(t));
        end;
      end;
      WaitForSingleObject(hAppMutex, 10);
    end;
  end
  else begin
    Application.Initialize;
    TntApplication.Title := 'MPUI-hcb';
    Application.CreateForm(TMainForm, MainForm);
    Application.CreateForm(TOptionsForm, OptionsForm);
    Application.CreateForm(TPlaylistForm, PlaylistForm);
    Application.CreateForm(TInfoForm, InfoForm);
    Application.CreateForm(TEqualizerForm, EqualizerForm);
    Application.CreateForm(TOpenDevicesForm, OpenDevicesForm);
    Application.CreateForm(TDLyricForm, DLyricForm);
    if (GdipHandle>0) and Assigned(UpdateLyricShowForm) then Application.CreateForm(TLyricShowForm, LyricShowForm);
    Application.Run;
    ReleaseMutex(hAppMutex);
  end;
  CloseHandle(hAppMutex);
end.

{var
  hAppMutex:Thandle; Mf:hWnd; s:String; i:integer;

begin
  Application.Initialize;
  hAppMutex:=CreateMutex(nil,false,PChar('hcb428'));
  if hAppMutex=0 then exit
  else begin
    if GetLastError=ERROR_ALREADY_EXISTS then begin
      //Mf:=FindWindowW(PWideChar(WideString('hcb428.UnicodeClass')),nil);
      Mf:=FindWindow(PChar('hcb428.UnicodeClass'),nil);
      if Mf<>0 then begin
        for i:=1 to ParamCount do begin
          s:=ParamStr(i);
          if GlobalFindAtom(PChar(S))=0 then
            SendMessage(Mf,$0401,GlobalAddAtom(PChar(S)),Length(S)+1);
        end;
      end;
      CloseHandle(hAppMutex); exit;
    end;
  end;
  TntApplication.Title := 'MPUI-hcb';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TLogForm, LogForm);
  Application.CreateForm(THelpForm, HelpForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.CreateForm(TOptionsForm, OptionsForm);
  Application.CreateForm(TPlaylistForm, PlaylistForm);
  Application.CreateForm(TInfoForm, InfoForm);
  Application.CreateForm(TAddDirForm, AddDirForm);
  Application.CreateForm(TEqualizerForm, EqualizerForm);
  Application.Run;
  CloseHandle(hAppMutex);
end.}

