{   MPUI-hcb, an MPlayer frontend for Windows
    Copyright (C) 2005 Martin J. Fiedler <martin.fiedler@gmx.net>
    Copyright (C) 2005 Alex Fu <alexfu@nerdshack.com>
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
unit mo_es;
interface
implementation
uses Windows,Locale,Main,Options,plist;

procedure Activate;
begin
  with MainForm do begin
      LOCstr_Status_Opening:=UTF8Decode('Abriendo ...');
      LOCstr_Status_Closing:=UTF8Decode('Cerrando ...');
      LOCstr_Status_Playing:=UTF8Decode('Reproduciendo');
      LOCstr_Status_Paused:=UTF8Decode('Pausa');
      LOCstr_Status_Stopped:=UTF8Decode('Detenido');
      LOCstr_Status_Error:=UTF8Decode('Imposible leer medio (Click para más información)');
    BPlaylist.Hint:=UTF8Decode('Mostrar/esconder ventana de lista de reproducción');
    BFullscreen.Hint:=UTF8Decode('Cambiar modo pantalla completa');
    OSDMenu.Caption:=UTF8Decode('Establecer modo OSD');
      MNoOSD.Caption:=UTF8Decode('Sin OSD');
      MDefaultOSD.Caption:=UTF8Decode('OSD predefinido');
      MTimeOSD.Caption:=UTF8Decode('Mostrar tiempo');
      MFullOSD.Caption:=UTF8Decode('Mostrar tiempo total');
    MFile.Caption:=UTF8Decode('Archivo');
      MOpenFile.Caption:=UTF8Decode('Reproducir archivo ...');
      MOpenURL.Caption:=UTF8Decode('Reproducir URL ...');
        LOCstr_OpenURL_Caption:=UTF8Decode('Reproducir URL');
        LOCstr_OpenURL_Prompt:=UTF8Decode(''+'Cuál es el URL a reproducir?');
      MOpenDrive.Caption:=UTF8Decode('Reproducir (V)CD/DVD/BlueRay');
      MClose.Caption:=UTF8Decode('Cerrar');
      MQuit.Caption:=UTF8Decode('Salir');
    MView.Caption:=UTF8Decode('Ver');
      MSizeAny.Caption:=UTF8Decode('Tamaño personalizado (');
      MSize50.Caption:=UTF8Decode('Mitad del tamaño');
      MSize100.Caption:=UTF8Decode('Tamaño original');
      MSize200.Caption:=UTF8Decode('Doble del tamaño');
      MFullscreen.Caption:=UTF8Decode('Pantalla completa');
      MOSD.Caption:=UTF8Decode('Cambiar OSD');
      MOnTop.Caption:=UTF8Decode('Siempre visible');
    MSeek.Caption:=UTF8Decode('Reproducción');
      MPlay.Caption:=UTF8Decode('Reproducir');
      MPause.Caption:=UTF8Decode('Pausar');
      MPrev.Caption:=UTF8Decode('Título anterior');
      MNext.Caption:=UTF8Decode('Título siguiente');
      MShowPlaylist.Caption:=UTF8Decode('Lista de reproducción ...');
      MSeekF10.Caption:=UTF8Decode('Avanzar 10 segundos');
      MSeekR10.Caption:=UTF8Decode('Retroceder 10 segundos');
      MSeekF60.Caption:=UTF8Decode('Avanzar 1 minuto');
      MSeekR60.Caption:=UTF8Decode('Retroceder 1 minuto');
      MSeekF600.Caption:=UTF8Decode('Avanzar 10 minutos');
      MSeekR600.Caption:=UTF8Decode('Retroceder 10 minutos');
    MExtra.Caption:=UTF8Decode('Preferencias');
      MAudio.Caption:=UTF8Decode('Pista de audio');
      MSubtitle.Caption:=UTF8Decode('Pista de subtítulo');
      MAspects.Caption:=UTF8Decode('Formato de imagen');
        MAutoAspect.Caption:=UTF8Decode('Autodetectar');
        MForce43.Caption:=UTF8Decode('Forzar 4:3');
        MForce169.Caption:=UTF8Decode('Forzar 16:9');
        MForceCinemascope.Caption:=UTF8Decode('Forzar 2.35:1');
      MDeinterlace.Caption:=UTF8Decode('Desentrelazado');
        MNoDeint.Caption:=UTF8Decode('Deshabilitado');
        MSimpleDeint.Caption:=UTF8Decode('Simple');
        MAdaptiveDeint.Caption:=UTF8Decode('Adaptativo');
      MOptions.Caption:=UTF8Decode('Preferencias ...');
      MLanguage.Caption:=UTF8Decode('Idioma');
      MShowOutput.Caption:=UTF8Decode('Mostrar mensajes de MPlayer');
      MHelp.Caption:=UTF8Decode('Ayuda');
        MKeyHelp.Caption:=UTF8Decode('Ayuda de teclado ...');
        MAbout.Caption:=UTF8Decode('Acerca de ...');
  end;
  OptionsForm.Caption:=UTF8Decode('Mensajes de MPlayer');
  OptionsForm.BClose.Caption:=UTF8Decode('Cerrar');
  OptionsForm.HelpText.Text:=UTF8Decode(
'Teclas de navegación:'^M^J+
'Espacio'^I'Reproducir/Pausar'^M^J+
'Derecha'^I'Avanzar 10 segundos'^M^J+
'Izquierda'^I'Retroceder 10 segundos'^M^J+
'Arriba'^I'Avanzar 1 minuto'^M^J+
'Abajo'^I'Retroceder 1 minuto'^M^J+
'RePág'^I'Avanzar 10 minutos'^M^J+
'AvPág'^I'Retroceder 10 minutos'^M^J+
^M^J+
'Otras teclas:'^M^J+
'O'^I'Cambiar OSD'^M^J+
'F'^I'Cambiar pantalla completa'^M^J+
'Q'^I'Salir inmediatamente'^M^J+
'9/0'^I'Ajustar volumen'^M^J+
'-/+'^I'Ajustar sincronización de audio/vídeo'^M^J+
'1/2'^I'Ajustar brillo'^M^J+
'3/4'^I'Ajustar contraste'^M^J+
'5/6'^I'Ajustar tinta'^M^J+
'7/8'^I'Ajustar saturación');

  with OptionsForm do begin
    THelp.Caption:=MainForm.MHelp.Caption;
    TAbout.Caption:=UTF8Decode('Acerca de');
    LVersionMPUI.Caption:=UTF8Decode('Versión de MPUI-hcb:');
    LVersionMPlayer.Caption:=UTF8Decode('Versión de MPlayer:');
    Caption:=UTF8Decode('Preferencias');
    BOK.Caption:=UTF8Decode('Aceptar');
    BApply.Caption:=UTF8Decode('Aplicar');
    BSave.Caption:=UTF8Decode('Guardar');
    BClose.Caption:=OptionsForm.BClose.Caption;
    LAudioOut.Caption:=UTF8Decode('Controlador de salida de audio');
      CAudioOut.Items[0]:=UTF8Decode('(no decodificar sonido)');
      CAudioOut.Items[1]:=UTF8Decode('(no reproducir sonido)');
    LAudioDev.Caption:=UTF8Decode('Dispositivo de salida DirectSound');
    LPostproc.Caption:=UTF8Decode('Post-procesado');
      CPostproc.Items[0]:=UTF8Decode('Deshabilitado');
      CPostproc.Items[1]:=UTF8Decode('Automático');
      CPostproc.Items[2]:=UTF8Decode('Máxima calidad');
    LOCstr_AutoLocale:=UTF8Decode('(Auto-selección)');
    CIndex.Caption:=UTF8Decode('Reconstruir índice del archivo si es necesario');
    LParams.Caption:=UTF8Decode('Parámetros MPlayer adicionales:');
    LHelp.Caption:=THelp.Caption;
  end;
  with PlaylistForm do begin
    Caption:=UTF8Decode('Lista de reproducción');
    BPlay.Hint:=UTF8Decode('Reproducir');
    BAdd.Hint:=UTF8Decode('Agregar ...');
    BMoveUp.Hint:=UTF8Decode('Mover arriba');
    BMoveDown.Hint:=UTF8Decode('Mover abajo');
    BDelete.Hint:=UTF8Decode('Borrar');
  end;
end;

begin
  RegisterLocale(UTF8Decode('Español (Espanol)'),Activate,LANG_SPANISH,DEFAULT_CHARSET);
end.
