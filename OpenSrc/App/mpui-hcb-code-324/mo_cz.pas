{   MPUI-hcb, an MPlayer frontend for Windows
    Copyright (C) 2005 Martin J. Fiedler <martin.fiedler@gmx.net>
    Copyright (C) 2005 Antonn Fujera <fujera@seznam.cz>
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
unit mo_cz;
interface
implementation
uses Windows,Locale,Main,Options;

procedure Activate;
begin
  with MainForm do begin
    BFullscreen.Hint:=UTF8Decode('Celá obrazovka');
    OSDMenu.Caption:=UTF8Decode('Nastavit OSD Mód');
      MNoOSD.Caption:=UTF8Decode('Žádný OSD');
      MDefaultOSD.Caption:=UTF8Decode('Standardní OSD');
      MTimeOSD.Caption:=UTF8Decode('Zobraz odehraný čas');
      MFullOSD.Caption:=UTF8Decode('Zobraz celkový čas');
    MFile.Caption:=UTF8Decode('Soubor');
      MOpenFile.Caption:=UTF8Decode('Otevřít ...');
      MOpenURL.Caption:=UTF8Decode('Otevřít URL ...');
        LOCstr_OpenURL_Caption:=UTF8Decode('Otevřít URL');
        LOCstr_OpenURL_Prompt:=UTF8Decode('Zadejte URL, která má být otevřena');
      MOpenDrive.Caption:=UTF8Decode('Otevřít disk (V)CD/DVD/BlueRay');
      MClose.Caption:=UTF8Decode('Zavřít');
      MQuit.Caption:=UTF8Decode('Ukončit');
    MView.Caption:=UTF8Decode('Zobrazit');
      MSizeAny.Caption:=UTF8Decode('Vlastní velikost (');
      MSize50.Caption:=UTF8Decode('Poloviční velikost');
      MSize100.Caption:=UTF8Decode('Originální velikost');
      MSize200.Caption:=UTF8Decode('Dvojnásobná velikost');
      MFullscreen.Caption:=UTF8Decode('Celá obrazovka');
      MOSD.Caption:=UTF8Decode('Přepnout OSD');
      MOnTop.Caption:=UTF8Decode('Vždy nahoře');
    MSeek.Caption:=UTF8Decode('Přehrát');
      MPlay.Caption:=UTF8Decode('Přehrávat');
      MPause.Caption:=UTF8Decode('Pozastavit');
      MSeekF10.Caption:=UTF8Decode('O 10 sekund vpřed');
      MSeekR10.Caption:=UTF8Decode('O 10 sekund zpět');
      MSeekF60.Caption:=UTF8Decode('O 1 minutu vpřed');
      MSeekR60.Caption:=UTF8Decode('O 1 minutu zpět');
      MSeekF600.Caption:=UTF8Decode('O 10 minut vpřed');
      MSeekR600.Caption:=UTF8Decode('O 10 minut zpět');
    MExtra.Caption:=UTF8Decode('Nastavení');
      MAudio.Caption:=UTF8Decode('Zvuková stopa');
      MSubtitle.Caption:=UTF8Decode('Stopa titulků');
      MAspects.Caption:=UTF8Decode('Formát obrazu');
        MAutoAspect.Caption:=UTF8Decode('Automatický');
        MForce43.Caption:=UTF8Decode('Vždy 4:3');
        MForce169.Caption:=UTF8Decode('Vždy 16:9');
        MForceCinemascope.Caption:=UTF8Decode('Vždy 2.35:1');
      MDeinterlace.Caption:=UTF8Decode('Deinterlacing');
        MNoDeint.Caption:=UTF8Decode('Vypnuto');
        MSimpleDeint.Caption:=UTF8Decode('Jednoduché');
        MAdaptiveDeint.Caption:=UTF8Decode('Adaptivní');
      MOptions.Caption:=UTF8Decode('Nastavení ...');
      MLanguage.Caption:=UTF8Decode('Jazyk');
      MShowOutput.Caption:=UTF8Decode('Zobraz konzoli MPlayeru');
      MHelp.Caption:=UTF8Decode('Nápověda');
        MKeyHelp.Caption:=UTF8Decode('Klávesové zkratky ...');
        MAbout.Caption:=UTF8Decode('O programu ...');
  end;
  OptionsForm.Caption:=UTF8Decode('Výstup Mplayeru');
  OptionsForm.BClose.Caption:=UTF8Decode('Zavřít');
  OptionsForm.HelpText.Text:=UTF8Decode(
'Navigační klávesy:'^M^J+
'Mezerník'^I'Přehrávat/Pozastavit'^M^J+
'Šipka vpravo'^I'O 10 sekund vpřed'^M^J+
'Šipka vlevo'^I'O 10 sekund zpět'^M^J+
'Šipka nahoru'^I'O 1 minutu vpřed'^M^J+
'Šipka dolů'^I'O 1 minutu zpět'^M^J+
'PgUp'^I'O deset minut vpřed'^M^J+
'PgDn'^I'O deset minut zpět'^M^J+
^M^J+
'Jiné klávesy:'^M^J+
'O'^I'Přepnout OSD'^M^J+
'F'^I'Celá obrazovka'^M^J+
'Q'^I'Ukončení programu'^M^J+
'9/0'^I'Nastavení hlasitosti'^M^J+
'-/+'^I'Nastavení Audio/Video Synchronizace'^M^J+
'1/2'^I'Nastavení jasu'^M^J+
'3/4'^I'Nastavení kontrastu'^M^J+
'5/6'^I'Nastavení barev'^M^J+
'7/8'^I'Nastavení sytosti'
  );
  with OptionsForm do begin
    THelp.Caption:=MainForm.MHelp.Caption;
    TAbout.Caption:=UTF8Decode('O programu');
    LVersionMPUI.Caption:=UTF8Decode('Verze MPUI-hcb: ');
    LVersionMPlayer.Caption:=UTF8Decode('Verze Mplayeru:');
    Caption:=UTF8Decode('Nastavení');
    BOK.Caption:=UTF8Decode('OK');
    BApply.Caption:=UTF8Decode('Použít');
    BSave.Caption:=UTF8Decode('Uložit');
    BClose.Caption:=OptionsForm.BClose.Caption;
    LAudioOut.Caption:=UTF8Decode('Výstupní ovladač zvuku');
      CAudioOut.Items[0]:=UTF8Decode('(nedekódovat zvuk)');
      CAudioOut.Items[1]:=UTF8Decode('(nepřehrávat zvuk)');
    LPostproc.Caption:=UTF8Decode('Postprocessing');
      CPostproc.Items[0]:=UTF8Decode('Vypnuto');
      CPostproc.Items[1]:=UTF8Decode('Automatické');
      CPostproc.Items[2]:=UTF8Decode('Maximální kvalita');
    LOCstr_AutoLocale:=UTF8Decode('Automatický výběr');
    CIndex.Caption:=UTF8Decode('Zrekonstruování indexu souboru, pokud je to nezbytné');
    LParams.Caption:=UTF8Decode('Dodatkové parametry MPlayeru:');
    LHelp.Caption:=THelp.Caption;
  end;
end;

begin
  RegisterLocale(UTF8Decode('Cesky'),Activate,LANG_CZECH,EASTEUROPE_CHARSET);
end.
