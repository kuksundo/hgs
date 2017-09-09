{   MPUI-hcb, an MPlayer frontend for Windows
    Copyright (C) 2005 Martin J. Fiedler <martin.fiedler@gmx.net>
    Copyright (C) 2006 Carlos Silvestre <cags69@portugalmail.pt>
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
unit mo_pt;
interface
implementation
uses Windows, Locale, Main, Options, plist, Info;

procedure Activate;
begin
  with MainForm do begin
    LOCstr_Status_Opening := UTF8Decode('A abrir...');
    LOCstr_Status_Closing := UTF8Decode('A fechar...');
    LOCstr_Status_Playing := UTF8Decode('a reproduzir');
    LOCstr_Status_Paused := UTF8Decode('Pausa');
    LOCstr_Status_Stopped := UTF8Decode('Parado');
    LOCstr_Status_Error := UTF8Decode('Não é possivél ler o filme (Clique para mais detalhes)');
    BPlaylist.Hint := UTF8Decode('Mostrar/Ocultar janela da lista de reproduo');
    BStreamInfo.Hint := UTF8Decode('Mostrar/Ocultar detalhes do ficheiro');
    BFullscreen.Hint := UTF8Decode('Alternar modo de écran completo');
    BCompact.Hint := UTF8Decode('Alternar modo compacto');
    BMute.Hint := UTF8Decode('Alternar silêncio');
    MPCtrl.Caption := UTF8Decode('Mostrar controlos no modo de écran completo');
    OSDMenu.Caption := UTF8Decode('Definir modo OSD');
    MNoOSD.Caption := UTF8Decode('Sem OSD');
    MDefaultOSD.Caption := UTF8Decode('OSD prédefinido');
    MTimeOSD.Caption := UTF8Decode('Mostrar tempo');
    MFullOSD.Caption := UTF8Decode('Mostrar tempo total');
    MFile.Caption := UTF8Decode('Ficheiro');
    MOpenFile.Caption := UTF8Decode('Reproduzir ficheiro...');
    MOpenURL.Caption := UTF8Decode('Reproduzir URL...');
    LOCstr_OpenURL_Caption := UTF8Decode('Reproduzir URL');
    LOCstr_OpenURL_Prompt := UTF8Decode('Qual o URL a reproduzir?');
    MOpenDrive.Caption := UTF8Decode('Reproduzir (V)CD/DVD/BlueRay');
    MClose.Caption := UTF8Decode('Fechar');
    MQuit.Caption := UTF8Decode('Sair');
    MView.Caption := UTF8Decode('Ver');
    MSizeAny.Caption := UTF8Decode('Tamanho personalizado (');
    MSize50.Caption := UTF8Decode('Metade do tamanho');
    MSize100.Caption := UTF8Decode('Tamanho original');
    MSize200.Caption := UTF8Decode('Dobro do tamanho');
    MFullscreen.Caption := UTF8Decode('Écran completo');
    MOSD.Caption := UTF8Decode('Alternar OSD');
    MOnTop.Caption := UTF8Decode('Sempre visivél');
    MSeek.Caption := UTF8Decode('Reprodução');
    MPlay.Caption := UTF8Decode('Reproduzir');
    MPause.Caption := UTF8Decode('Pausa');
    MPrev.Caption := UTF8Decode('Título anterior');
    MNext.Caption := UTF8Decode('Título seguinte');
    MShowPlaylist.Caption := UTF8Decode('Lista de reprodução...');
    MMute.Caption := UTF8Decode('Silêncio');
    MSeekF10.Caption := UTF8Decode('Avançar 10 segundos');
    MSeekR10.Caption := UTF8Decode('Retroceder 10 segundos');
    MSeekF60.Caption := UTF8Decode('Avançar 1 minuto');
    MSeekR60.Caption := UTF8Decode('Retroceder 1 minuto');
    MSeekF600.Caption := UTF8Decode('Avançar 10 minutos');
    MSeekR600.Caption := UTF8Decode('Retroceder 10 minutos');
    MExtra.Caption := UTF8Decode('Preferências');
    MAudio.Caption := UTF8Decode('Pista de áudio');
    MSubtitle.Caption := UTF8Decode('Pista de legendas');
    MAspects.Caption := UTF8Decode('Formato de imagem');
    MAutoAspect.Caption := UTF8Decode('Autodetectar');
    MForce43.Caption := UTF8Decode('Forçar 4:3');
    MForce169.Caption := UTF8Decode('Forçar 16:9');
    MForceCinemascope.Caption := UTF8Decode('Forçar 2.35:1');
    MDeinterlace.Caption := UTF8Decode('Desentrelaçar');
    MNoDeint.Caption := UTF8Decode('Desabilitado');
    MSimpleDeint.Caption := UTF8Decode('Simples');
    MAdaptiveDeint.Caption := UTF8Decode('Adaptativo');
    MOptions.Caption := UTF8Decode('Preferências...');
    MLanguage.Caption := UTF8Decode('Idioma');
    MStreamInfo.Caption := UTF8Decode('Mostrar detalhes do filme...');
    MShowOutput.Caption := UTF8Decode('Mostrar mensagens do MPlayer');
    MHelp.Caption := UTF8Decode('Ajuda');
    MKeyHelp.Caption := UTF8Decode('Ajuda do teclado...');
    MAbout.Caption := UTF8Decode('Sobre o...');
  end;
  OptionsForm.BClose.Caption := UTF8Decode('Fechar');
  OptionsForm.HelpText.Text := UTF8Decode(
    'Teclas de navegação:'^M^J +
    'Espaço'^I'Reproduzir/Pausa'^M^J +
    'Dereita'^I'Avançar 10 segundos'^M^J +
    'Esquerda'^I'Retroceder 10 segundos'^M^J +
    'Cima'^I'Avançar 1 minuto'^M^J +
    'Baixo'^I'Retroceder 1 minuto'^M^J +
    'PágUp'^I'Avançar 10 minutos'^M^J +
    'PágDw'^I'Retroceder 10 minutos'^M^J +
    ^M^J+
    'Outras teclas:'^M^J +
    'O'^I'Alternar OSD'^M^J +
    'F'^I'Alternar modo de écran completo'^M^J +
    'Q'^I'Sair imediatamente'^M^J +
    '9/0'^I'Ajustar volume'^M^J +
    '-/+'^I'Ajustar sincronização de audio/vídeo'^M^J +
    '1/2'^I'Ajustar brilho'^M^J +
    '3/4'^I'Ajustar contraste'^M^J +
    '5/6'^I'Ajustar cor'^M^J +
    '7/8'^I'Ajustar saturação');

  with OptionsForm do begin
    LVersionMPUI.Caption := UTF8Decode('Versão do MPUI-hcb:');
    LVersionMPlayer.Caption := UTF8Decode('Versão do MPlayer:');
    THelp.Caption := MainForm.MHelp.Caption;
    TAbout.Caption := UTF8Decode('Sobre o');
    Caption := UTF8Decode('Preferências');
    BOK.Caption := UTF8Decode('Aceitar');
    BApply.Caption := UTF8Decode('Aplicar');
    BSave.Caption := UTF8Decode('Guardar');
    LAudioOut.Caption := UTF8Decode('Controlador de saída de áudio:');
    CAudioOut.Items[0] := UTF8Decode('(não descodificar som)');
    CAudioOut.Items[1] := UTF8Decode('(não reproduzir som)');
    LAudioDev.Caption := UTF8Decode('Dispositivo de saída DirectSound');
    LPostproc.Caption := UTF8Decode('Pós-processamento:');
    CPostproc.Items[0] := UTF8Decode('Desabilitado');
    CPostproc.Items[1] := UTF8Decode('Automático');
    CPostproc.Items[2] := UTF8Decode('Qualidade máxima');
    LOCstr_AutoLocale := UTF8Decode('(Selecção automática)');
    CIndex.Caption := UTF8Decode('Reconstruir índice do ficheiro se necessário');
    CSoftVol.Caption := UTF8Decode('Controlo de volume / Aumentar volume');
    CPriorityBoost.Caption := UTF8Decode('Executar com prioridade total');
    LParams.Caption := UTF8Decode('Parâmetros MPlayer adicionais:');
    LHelp.Caption := THelp.Caption;
  end;
  with PlaylistForm do begin
    Caption := UTF8Decode('Lista de reprodução');
    BPlay.Hint := UTF8Decode('Reproduzir');
    BAdd.Hint := UTF8Decode('Adicionar...');
    BMoveUp.Hint := UTF8Decode('Subir');
    BMoveDown.Hint := UTF8Decode('Descer');
    BDelete.Hint := UTF8Decode('Apagar');
  end;
  InfoForm.Caption := UTF8Decode('Detalhes do filme');
  InfoForm.BClose.Caption := OptionsForm.BClose.Caption;
  LOCstr_NoInfo := UTF8Decode('Não existem informações disponiveis de momento.');
  LOCstr_InfoFileFormat := UTF8Decode('Formato');
  LOCstr_InfoPlaybackTime := UTF8Decode('Duração');
  LOCstr_InfoTags := UTF8Decode('Metadata do filme');
  LOCstr_InfoVideo := UTF8Decode('Pista de video');
  LOCstr_InfoAudio := UTF8Decode('Pista de áudio');
  LOCstr_InfoDecoder := UTF8Decode('Descodificador');
  LOCstr_InfoCodec := UTF8Decode('Codec');
  LOCstr_InfoBitrate := UTF8Decode('Bitrate');
  LOCstr_InfoVideoSize := UTF8Decode('Dimensões');
  LOCstr_InfoVideoFPS := UTF8Decode('Taxa de imagens');
  LOCstr_InfoVideoAspect := UTF8Decode('Formato de imagem');
  LOCstr_InfoAudioRate := UTF8Decode('Taxa de amostragem');
  LOCstr_InfoAudioChannels := UTF8Decode('Canais');
end;

begin
  RegisterLocale(UTF8Decode('Português (Portuguese)'), Activate, LANG_PORTUGUESE, DEFAULT_CHARSET);
end.
