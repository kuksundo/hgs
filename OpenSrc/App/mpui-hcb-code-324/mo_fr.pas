{   MPUI-hcb, an MPlayer frontend for Windows
    Copyright (C) 2005 Martin J. Fiedler <martin.fiedler@gmx.net>
    Copyright (C) 2005 Franois Gagn <frenchfrog@gmail.com>
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
unit mo_fr;
interface
implementation
uses Windows, Locale, Main, Options, plist;

procedure Activate;
begin
  with MainForm do begin
    LOCstr_Status_Opening := UTF8Decode('Ouverture ...');
    LOCstr_Status_Closing := UTF8Decode('Fermeture ...');
    LOCstr_Status_Playing := UTF8Decode('Joue');
    LOCstr_Status_Paused := UTF8Decode('Suspendu');
    LOCstr_Status_Stopped := UTF8Decode('Arrêté');
    LOCstr_Status_Error := UTF8Decode('Incapable de jouer le média (Cliquer pour plus d'#39'information)');
    BPlaylist.Hint := UTF8Decode('Ouvrir/fermer la liste ');
    BFullscreen.Hint := UTF8Decode('Basculer en mode plein écran');
    OSDMenu.Caption := UTF8Decode('Choisir le mode OSD');
    MNoOSD.Caption := UTF8Decode('Aucun OSD');
    MDefaultOSD.Caption := UTF8Decode('OSD par d' +
      'faud');
    MTimeOSD.Caption := UTF8Decode('Afficher le temps');
    MFullOSD.Caption := UTF8Decode('Afficher le temps total');
    MFile.Caption := UTF8Decode('Fichier');
    MOpenFile.Caption := UTF8Decode('Jouer un fichier ...');
    MOpenURL.Caption := UTF8Decode('Jouer un URL ...');
    LOCstr_OpenURL_Caption := UTF8Decode('Jouer un URL');
    LOCstr_OpenURL_Prompt := UTF8Decode('Quel URL voulez-vous jouer?');
    MOpenDrive.Caption := UTF8Decode('Jouer un (V)CD/DVD/BlueRay');
    MClose.Caption := UTF8Decode('Fermer');
    MQuit.Caption := UTF8Decode('Quitter');
    MView.Caption := UTF8Decode('Affichage');
    MSizeAny.Caption := UTF8Decode('Dimension sur mesure (');
    MSize50.Caption := UTF8Decode('Demi taille');
    MSize100.Caption := UTF8Decode('Taille originale');
    MSize200.Caption := UTF8Decode('Double taille');
    MFullscreen.Caption := UTF8Decode('Plein écran');
    MOSD.Caption := UTF8Decode('Cycler les modes OSD');
    MOnTop.Caption := UTF8Decode('Toujours sur le dessus');
    MSeek.Caption := UTF8Decode('Visualisation');
    MPlay.Caption := UTF8Decode('Jouer');
    MPause.Caption := UTF8Decode('Suspendre');
    MPrev.Caption := UTF8Decode('Titre précédent');
    MNext.Caption := UTF8Decode('Titre suivant');
    MShowPlaylist.Caption := UTF8Decode('Liste d'#39'écoute ...');
    MSeekF10.Caption := UTF8Decode('Avancer 10 secondes');
    MSeekR10.Caption := UTF8Decode('Reculer 10 secondes');
    MSeekF60.Caption := UTF8Decode('Avancer 1 minute');
    MSeekR60.Caption := UTF8Decode('Reculer 1 minute');
    MSeekF600.Caption := UTF8Decode('Avancer 10 minutes');
    MSeekR600.Caption := UTF8Decode('Reculer 10 minutes');
    MExtra.Caption := UTF8Decode('Préférences');
    MAudio.Caption := UTF8Decode('Audio');
    MSubtitle.Caption := UTF8Decode('Sous-titres');
    MAspects.Caption := UTF8Decode('Format de l''image');
    MAutoAspect.Caption := UTF8Decode('Auto-détection');
    MForce43.Caption := UTF8Decode('Forcer 4:3');
    MForce169.Caption := UTF8Decode('Forcer 16:9');
    MForceCinemascope.Caption := UTF8Decode('Forcer 2.35:1');
    MDeinterlace.Caption := UTF8Decode('Dé-entrelacer');
    MNoDeint.Caption := UTF8Decode('Aucun');
    MSimpleDeint.Caption := UTF8Decode('Simple');
    MAdaptiveDeint.Caption := UTF8Decode('Adaptatif');
    MOptions.Caption := UTF8Decode('Préférences ...');
    MLanguage.Caption := UTF8Decode('Langue');
    MShowOutput.Caption := UTF8Decode('Afficher la sortie de MPlayer');
    MHelp.Caption := UTF8Decode('Aide');
    MKeyHelp.Caption := UTF8Decode('Aide du clavier ...');
    MAbout.Caption := UTF8Decode('À propos ...');
  end;
  OptionsForm.Caption := UTF8Decode('Sortie MPlayer');
  OptionsForm.BClose.Caption := UTF8Decode('Fermer');
  OptionsForm.HelpText.Text := UTF8Decode(
    'Clefs de navigation:'^M^J +
    'Espace'^I'Jouer/Suspendre'^M^J +
    'Droite'^I'Avancer 10 secondes'^M^J +
    'Gauche'^I'Reculer 10 secondes'^M^J +
    'Haut'^I'Avancer 1 minute'^M^J +
    'Bas'^I'Reculer 1 minute'^M^J +
    'PgHaut'^I'Avancer 10 minutes'^M^J +
    'PgBas'^I'Reculer 10 minutes'^M^J +
    ^M^J+
    'Autre clefs:'^M^J +
    'O'^I'Cycler les modes OSD'^M^J +
    'F'^I'Basculer en plein écran'^M^J +
    'Q'^I'Quitter immediatement'^M^J +
    '9/0'^I'Ajuster le volume'^M^J +
    '-/+'^I'Ajuster la sync audio/video'^M^J +
    '1/2'^I'Ajuster la luminosité'^M^J +
    '3/4'^I'Ajuster le contraste'^M^J +
    '5/6'^I'Ajuster la hue'^M^J +
    '7/8'^I'Ajuster la saturation')
    ;

  with OptionsForm do begin
    THelp.Caption := MainForm.MHelp.Caption;
    TAbout.Caption := UTF8Decode('À propos');
    LVersionMPUI.Caption := UTF8Decode('MPUI-hcb version:');
    LVersionMPlayer.Caption := UTF8Decode('MPlayer version:');
    Caption := UTF8Decode('Préférences');
    BOK.Caption := UTF8Decode('OK');
    BApply.Caption := UTF8Decode('Appliquer');
    BSave.Caption := UTF8Decode('Sauver');
    BClose.Caption := OptionsForm.BClose.Caption;
    LAudioOut.Caption := UTF8Decode('Pilote de sortie audio');
    CAudioOut.Items[0] := UTF8Decode('(ne pas décoder le son)');
    CAudioOut.Items[1] := UTF8Decode('(ne pas jouer le son)');
    LAudioDev.Caption := UTF8Decode('Unité de sortie DirectSound');
    LPostproc.Caption := UTF8Decode('Post-traitement');
    CPostproc.Items[0] := UTF8Decode('Aucun');
    CPostproc.Items[1] := UTF8Decode('Automatique');
    CPostproc.Items[2] := UTF8Decode('Qualité maximum');
    LOCstr_AutoLocale := UTF8Decode('(Auto-sélection)');
    CIndex.Caption := UTF8Decode('Reconstruire l''index du fichier au besoin');
    LParams.Caption := UTF8Decode('Paramètres MPlayer additionnels:');
    LHelp.Caption := THelp.Caption;
  end;
  with PlaylistForm do begin
    Caption := UTF8Decode('Liste d'#39'écoute');
    BPlay.Hint := UTF8Decode('Jouer');
    BAdd.Hint := UTF8Decode('Ajouter ...');
    BMoveUp.Hint := UTF8Decode('Monter');
    BMoveDown.Hint := UTF8Decode('Descendre');
    BDelete.Hint := UTF8Decode('Enlever');
  end;
end;

begin
  RegisterLocale(UTF8Decode('Français (French)'), Activate, LANG_FRENCH, DEFAULT_CHARSET);
end.
