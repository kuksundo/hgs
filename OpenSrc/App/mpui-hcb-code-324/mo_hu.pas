{   MPUI-hcb, an MPlayer frontend for Windows
    Copyright (C) 2005 Martin J. Fiedler <martin.fiedler@gmx.net>
    Copyright (C) 2005 MrG <mrguba@gmail.com>
    Copyright (C) 2006-2013 Huang Chen Bin <hcb428@foxmail.com>
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
unit mo_hu;
interface
implementation
uses Windows,Locale,Main,Options,plist;

procedure Activate;
begin
  with MainForm do begin
      LOCstr_Status_Opening:=UTF8Decode('Megnyitás ...');
      LOCstr_Status_Closing:=UTF8Decode('Bezárás ...');
      LOCstr_Status_Playing:=UTF8Decode('Lejátszás');
      LOCstr_Status_Paused:=UTF8Decode('Szünet');
      LOCstr_Status_Stopped:=UTF8Decode('Leállítva');
      LOCstr_Status_Error:=UTF8Decode('Nem lejátszható média (Kattints ide több infoért)');
    BPlaylist.Hint:=UTF8Decode('Lejátszási lista ablakának mutatása/elrejtése');
    BFullscreen.Hint:=UTF8Decode('Teljes képernyõ ki/be');
    OSDMenu.Caption:=UTF8Decode('OSD mód beállítása');
      MNoOSD.Caption:=UTF8Decode('Nincs OSD');
      MDefaultOSD.Caption:=UTF8Decode('Alapértelmezett OSD');
      MTimeOSD.Caption:=UTF8Decode('Idõ kijelzése');
      MFullOSD.Caption:=UTF8Decode('Összes idõ kijelzése');
    MFile.Caption:=UTF8Decode('File');
      MOpenFile.Caption:=UTF8Decode('File lejátszása ...');
      MOpenURL.Caption:=UTF8Decode('URL lejátszása ...');
        LOCstr_OpenURL_Caption:=UTF8Decode('URL lejátszása');
        LOCstr_OpenURL_Prompt:=UTF8Decode('A lejátszandó URL');
      MOpenDrive.Caption:=UTF8Decode('(V)CD/DVD/BlueRay lejátszása');
      MClose.Caption:=UTF8Decode('Bezárás');
      MQuit.Caption:=UTF8Decode('Kilépés');
    MView.Caption:=UTF8Decode('Nézet');
      MSizeAny.Caption:=UTF8Decode('Más méret (');
      MSize50.Caption:=UTF8Decode('Feleakkora méret');
      MSize100.Caption:=UTF8Decode('Eredeti méret');
      MSize200.Caption:=UTF8Decode('Dupla méret');
      MFullscreen.Caption:=UTF8Decode('Teljes képernyõ');
      MOSD.Caption:=UTF8Decode('OSD ki/be');
      MOnTop.Caption:=UTF8Decode('Mindig látható');
    MSeek.Caption:=UTF8Decode('Navigáció');
      MPlay.Caption:=UTF8Decode('Lejátszás');
      MPause.Caption:=UTF8Decode('Szünet');
      MPrev.Caption:=UTF8Decode('Elõzõ cím');
      MNext.Caption:=UTF8Decode('Következõ cím');
      MShowPlaylist.Caption:=UTF8Decode('Lejátszási lista ...');
      MSeekF10.Caption:=UTF8Decode('Elõre 10 másodpercet');
      MSeekR10.Caption:=UTF8Decode('Vissza 10 másodpercet');
      MSeekF60.Caption:=UTF8Decode('Elõre 1 percet');
      MSeekR60.Caption:=UTF8Decode('Vissza 1 percet');
      MSeekF600.Caption:=UTF8Decode('Elõre 10 percet');
      MSeekR600.Caption:=UTF8Decode('Vissza 10 percet');
    MExtra.Caption:=UTF8Decode('Beállítások');
      MAudio.Caption:=UTF8Decode('Hangsáv');
      MSubtitle.Caption:=UTF8Decode('Felirat');
      MAspects.Caption:=UTF8Decode('Képarány');
        MAutoAspect.Caption:=UTF8Decode('Automatikus detektálás');
        MForce43.Caption:=UTF8Decode('Mindig 4:3');
        MForce169.Caption:=UTF8Decode('Mindig 16:9');
        MForceCinemascope.Caption:=UTF8Decode('Mindig 2.35:1');
      MDeinterlace.Caption:=UTF8Decode('Deinterlace');
        MNoDeint.Caption:=UTF8Decode('Ki');
        MSimpleDeint.Caption:=UTF8Decode('Egyszerû');
        MAdaptiveDeint.Caption:=UTF8Decode('Adaptív');
      MOptions.Caption:=UTF8Decode('Beállítások ...');
      MLanguage.Caption:=UTF8Decode('Nyelv');
      MShowOutput.Caption:=UTF8Decode('MPlayer kimenet mutatása');
      MHelp.Caption:=UTF8Decode('Súgó');
        MKeyHelp.Caption:=UTF8Decode('Billentyûparancsok ...');
        MAbout.Caption:=UTF8Decode('Névjegy ...');
  end;
  OptionsForm.Caption:=UTF8Decode('MPlayer kimenet');
  OptionsForm.BClose.Caption:=UTF8Decode('Bezárás');
  OptionsForm.HelpText.Text:=UTF8Decode(
'Navigáló billentyûk:'^M^J+
'Space'^I'Lejátszás/Sz'+
'net'^M^J+
'Right'^I'Elõre 10 másodpercet'^M^J+
'Left'^I'Vissza 10 másodpercet'^M^J+
'Up'^I'Elõre 1 percet'^M^J+
'Down'^I'Vissza 1 percet'^M^J+
'PgUp'^I'Elõre 10 percet'^M^J+
'PgDn'^I'Vissza 10 percet'^M^J+
^M^J+
'További billentyûk:'^M^J+
'O'^I'OSD ki/be'^M^J+
'F'^I'Teljes képernyõ ki/be'^M^J+
'Q'^I'Quit immediately'^M^J+
'9/0'^I'Hangerõ beállítása'^M^J+
'-/+'^I'Hang/videó szinkron beállítása'^M^J+
'1/2'^I'Fényesség beállítása'^M^J+
'3/4'^I'Kontraszt beállítása'^M^J+
'5/6'^I'Árnyalat beállítása'^M^J+
'7/8'^I'Telítettség beállítása');
  with OptionsForm do begin
    THelp.Caption:=MainForm.MHelp.Caption;
    TAbout.Caption:=UTF8Decode('Névjegy');
    LVersionMPUI.Caption:=UTF8Decode('MPUI-hcb verzió:');
    LVersionMPlayer.Caption:=UTF8Decode('MPlayer core verzió:');
    Caption:=UTF8Decode('Beállítások');
    BOK.Caption:=UTF8Decode('OK');
    BApply.Caption:=UTF8Decode('Alkalmaz');
    BSave.Caption:=UTF8Decode('Mentés');
    BClose.Caption:=OptionsForm.BClose.Caption;
    LAudioOut.Caption:=UTF8Decode('Hang kimeneti driver');
      CAudioOut.Items[0]:=UTF8Decode('(nincs hangdekódolás)');
      CAudioOut.Items[1]:=UTF8Decode('(nincs hanglejátszás)');
    LAudioDev.Caption:=UTF8Decode('DirectSound output device');
    LPostproc.Caption:=UTF8Decode('Postprocessing');
      CPostproc.Items[0]:=UTF8Decode('Ki');
      CPostproc.Items[1]:=UTF8Decode('Automatikus');
      CPostproc.Items[2]:=UTF8Decode('Maximális minõség');
    LOCstr_AutoLocale:=UTF8Decode('(Automatikus kiválasztás)');
    CIndex.Caption:=UTF8Decode('File index újraép'+
'tése, ha szükséges');
    LParams.Caption:=UTF8Decode('További MPlayer paraméterek:');
    LHelp.Caption:=THelp.Caption;
  end;
  with PlaylistForm do begin
    Caption:=UTF8Decode('Lejátszási lista');
    BPlay.Hint:=UTF8Decode('Lejátszás');
    BAdd.Hint:=UTF8Decode('Hozzáadás ...');
    BMoveUp.Hint:=UTF8Decode('Felfelé mozgat');
    BMoveDown.Hint:=UTF8Decode('Lefelé mozgat');
    BDelete.Hint:=UTF8Decode('Eltávolít');
  end;
end;

begin
  RegisterLocale(UTF8Decode('Magyar (Hungarian)'),Activate,LANG_HUNGARIAN,EASTEUROPE_CHARSET);
end.
