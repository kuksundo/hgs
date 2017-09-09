{   MPUI, an MPlayer frontend for Windows
    Copyright (C) 2008-2010 Visenri
    Original source code (2005) by Martin J. Fiedler <martin.fiedler@gmx.net>

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
unit Config;
interface
uses UfrmMain, Locale, Menus, Classes, StdCtrls, graphics, controls, ExtCtrls;




type
      TconfigOpt=record
        WantFullscreen : boolean;
        WantCompact : boolean;
        AutoQuit : boolean;

        VideoInside : boolean;

        DefaultLocale:integer;
        AutoPlay: boolean;
        FullScreenMonitor: integer;

        AlwaysOnTop : boolean;
        WindowPos : TstringList;

        ForceEvenWidth : Boolean;
      end;

var
  opt : TconfigOpt;

const AudioOutMap:array[0..3]of string=('nosound','null','win32','dsound');
const PostprocMap:array[0..2]of string=('off','auto','max');
const DeinterlaceAlgMap:array[0..3]of string=('blend','simple','adaptive','double rate');
const DeinterlaceMap:array[0..2]of string=('off','on','auto');
const AspectMap:array[0..3]of string=('auto','4:3','16:9','2.35:1');
const VideoScalerMap: array[0..2] of string=('off','on','auto');


const VideoOutMap:array[0..12] of string =
('null','directx' ,'directx:noaccel','direct3d',
 'gl', 'gl:nomanyfmts' ,'gl:yuv=2:force-pbo' , 'gl:yuv=2:force-pbo:ati-hack' , 'gl:yuv=3',
 'gl2' , 'gl2:yuv=3',
 'matrixview','#');
const videoEqMap: array[0..2] of string=('', 'eq2', 'eq2,hue');

const mplayerfontEncodingsMap : array[0..22] of string =( '',
      'unicode', 'iso-8859-1', 'iso-8859-15', 'iso-8859-2', 'iso-8859-3',
      'iso-8859-4', 'iso-8859-5', 'iso-8859-6', 'iso-8859-7', 'iso-8859-9',
      'iso-8859-13', 'iso-8859-14', 'iso-8859-8', 'koi8-r', 'koi8-u/ru',
      'cp936', 'big5', 'shift-jis', 'cp949', 'cp874',
      'cp1251', 'cp1250');


Procedure UpdateImageFromImagery(image : Timage; imagery : Timagelist;
                                 imgindex : integer);
procedure changeComboTstring(Cmb: TCombobox; index : integer;
                             const str : wideString);
procedure BuildOptMenu(const Opt: array of string; Men: TMenuItem ; const _Event:TNotifyEvent = nil);
procedure BuildOptCombo(const Opt: array of string; Cmb: TCombobox); overload;
procedure BuildOptCombo(const Opt: array of widestring; Cmb: TCombobox); overload;
function checkComboOptStr(const Opt : array of string; Cmb: TCombobox; value : string) : integer;

procedure Load(FileName:string);
procedure Save(FileName:string ; onlysettings: boolean = false);
procedure ResetOpt();

implementation
uses SysUtils, VssIniFiles, mplayer, VisEffects;

const DEFAULTFILENAME='MPUI.ini';
      SECTIONNAME='MPUI';
      SECTIONNAMEVIS='MPUI-VIS';
      SECTIONNAMEWINDOWPOS='MPUI-WINDOWS';


Procedure UpdateImageFromImagery(image : Timage; imagery : Timagelist;
                                 imgindex : integer);
begin
  if imgindex >= 0  then begin
    if imgindex <> image.Tag  then begin
      image.Picture.Bitmap := nil;
      image.picture.Bitmap.TransparentMode := tmFixed;
      image.picture.Bitmap.TransparentColor := clWhite;
      imagery.GetBitmap(imgindex, image.Picture.Bitmap);
      image.Tag := imgindex;
    end;
    if image.visible = false then
      image.Visible := true;
  end else
    image.Visible := false;
end;


function checkComboOptStr(const Opt : array of string; Cmb: TCombobox; value : string) : integer;
var i, def : integer;
begin
  def := -1;
  Result := 0;
  for i := 0 to high(Opt) do begin
      if value = opt[i] then begin
        if i < cmb.Items.Count  then begin
          cmb.ItemIndex := i;
          Result := 1;
          exit;
        end
      end else
        if opt[i] = '#' then
          def := i;
  end;

  if  def >=0   then
    if def < cmb.Items.Count  then begin
      result := 2;
      cmb.ItemIndex := def
    end;
end;


procedure BuildOptMenu(const Opt: array of string; Men: TMenuItem ; const _Event: TNotifyEvent = nil);
var i:integer; Item:TMenuItem;
begin

  Men.Clear;
  for i := 0 to high(Opt) do begin
    Item:=TMenuItem.Create(Men );
    with Item do begin
      Caption:=Opt[i];
      //GroupIndex:=1;
      RadioItem:=true;
      Tag:=i;
      if assigned(_Event) then
        OnClick:=_Event;
    end;
    Men.Add(Item);
  end;

end;

procedure changeComboTstring(Cmb: TCombobox; index : integer;
                             const str : wideString);
var
sel : integer;
begin
  if index >= cmb.Items.Count  then
    exit;
  sel := cmb.ItemIndex;
  cmb.Items[index] := str;
  if sel > -1 then
    if sel < cmb.Items.Count then
      cmb.ItemIndex := sel;
end;

procedure BuildOptCombo(const Opt: array of string; Cmb: TCombobox);
var i, sel :integer;
begin
  //Cmb.Clear;
  sel := cmb.ItemIndex;
  for i:=0 to High(Opt) do
    if cmb.Items.Count  > i then
      cmb.Items[i] := Opt[i]
    else
      Cmb.Items.Add(Opt[i]);
  if sel > -1 then
    if sel < cmb.Items.Count then
      cmb.ItemIndex := sel;
end;
procedure BuildOptCombo(const Opt: array of widestring; Cmb: TCombobox);
var i , sel :integer;
begin
  //Cmb.Clear;
  sel := cmb.ItemIndex;
  for i:=0 to High(Opt) do
    if cmb.Items.Count  > i then
      cmb.Items[i] := Opt[i]
    else
      Cmb.Items.Add(Opt[i]);
  if sel > -1 then
    if sel < cmb.Items.Count then
      cmb.ItemIndex := sel;
end;

function Unmap(const Map:array of string; const original:integer; Value:string) : integer;
var i:integer;
begin
  Value:=LowerCase(Value);
  for i:=Low(Map) to High(Map) do
    if Map[i]=Value then begin
      Result:=i;
      exit;
    end;
  Result := original;
end;

function GetDefaultOptionsFile() : string;
begin
  Result := frmMain.mpo.Mplayerpath+DEFAULTFILENAME;
end;


procedure Load(FileName:string);
var INI:TVssMemIniFile;
    i,value : integer;
    svalue : string;
    mpo : Tmplayer;
    vis : TVisEffects;
begin
  if FileName ='' then
    FileName := GetDefaultOptionsFile;

  if not FileExists(FileName) then exit;
  INI:=TVssMemIniFile.Create(FileName);
  mpo := frmMain.mpo;
  vis := frmMain.VisEffects;
  with INI do begin
    opt.DefaultLocale:=ReadInteger(SECTIONNAME,'Locale',AutoLocale);
    mpo.AudioOut := Unmap(AudioOutMap,mpo.AudioOut,ReadString(SECTIONNAME,'AudioOut',''));
    mpo.AudioDev:=ReadInteger(SECTIONNAME,'AudioDev',mpo.AudioDev);
    mpo.AudioFilterChannels := ReadString  (SECTIONNAME,'AudioFilterChannels',mpo.AudioFilterChannels);
    mpo.UseVolCmd := ReadBool(SECTIONNAME,'UseVolCmd',mpo.UseVolCmd);

    mpo.Postproc := Unmap(PostprocMap,mpo.Postproc,ReadString(SECTIONNAME,'Postproc',''));
    mpo.DeinterlaceAlg := Unmap(DeinterlaceAlgMap,mpo.DeinterlaceAlg,ReadString(SECTIONNAME,'DeinterlaceAlg',''));
    mpo.Deinterlace := Unmap(DeinterlaceMap,mpo.Deinterlace,ReadString(SECTIONNAME,'Deinterlace',''));

    mpo.Aspect := Unmap(AspectMap,mpo.Aspect,ReadString(SECTIONNAME,'Aspect',''));
    mpo.ReIndex:=ReadBool(SECTIONNAME,'ReIndex',mpo.ReIndex);

    mpo.Autosync := ReadInteger(SECTIONNAME,'Autosync',mpo.Autosync);
    mpo.AVsyncPerFrame := ReadInteger(SECTIONNAME,'AVsyncPerFrame',mpo.AVsyncPerFrame);

    mpo.SoftVol:=ReadBool(SECTIONNAME,'SoftVol',mpo.SoftVol);
    mpo.PriorityBoost:=ReadBool(SECTIONNAME,'PriorityBoost',mpo.PriorityBoost);
    mpo.Params:=ReadString(SECTIONNAME,'Params',mpo.Params);

    for i := 0 to MAX_CACHE_ENTRYS do begin
      mpo.Cachesize[i] :=
          ReadInteger(SECTIONNAME,'Cache_' + cacheEntrys[i] , mpo.Cachesize[i]);
    end;

    mpo.FontEncoding := ReadString(SECTIONNAME, 'FontEncoding', mpo.FontEncoding);
    sValue := ReadString(SECTIONNAME, 'FontPath', mpo.FontPath);
    if (sValue = '') or fileexists(sValue) then
      mpo.FontPath := sValue;

    mpo.FontConfig := ReadBool(SECTIONNAME,'FontConfig',mpo.FontConfig);
    mpo.SubAss := ReadBool(SECTIONNAME,'SubAss',mpo.SubAss);
    mpo.SubAutoLoad := ReadBool(SECTIONNAME,'SubAutoLoad',mpo.SubAutoLoad);

    mpo.SubAssColor := ReadRGBAColor(SECTIONNAME,'SubAssColor',mpo.SubAssColor);
    mpo.SubAssBorderColor := ReadRGBAColor(SECTIONNAME,'SubAssBorderColor',mpo.SubAssBorderColor);
    mpo.SubBgColor := ReadRGBAColor(SECTIONNAME,'SubBgColor',mpo.SubBgColor);

    mpo.UseDvdNav := ReadBool(SECTIONNAME,'UseDvdNav', mpo.UseDvdNav);
    mpo.DeinterlaceDvd := ReadBool(SECTIONNAME,'DeinterlaceDvd', mpo.DeinterlaceDVD);

    opt.AutoPlay:=ReadBool(SECTIONNAME,'AutoPlay', False);
    opt.FullScreenMonitor := ReadInteger(SECTIONNAME,'FullScreenMonitor', 0);

    opt.WantFullscreen:=ReadBool(SECTIONNAME,'Fullscreen',False);
    opt.AutoQuit:=ReadBool(SECTIONNAME,'AutoQuit', False);

    mpo.overlaycolor := ReadRGBColor(SECTIONNAME,'OverlayColor',mpo.overlaycolor);

    mpo.videoout :=  readstring(SECTIONNAME,'VideoOut',mpo.videoout);

    i := unmap(videoeqMap, -1 ,readstring(SECTIONNAME,'VideoEq',''));
    if i<> -1 then
      mpo.videoeq := videoeqmap[i];

    opt.ForceEvenWidth := ReadBool(SECTIONNAME,'ForceEvenWidth', opt.ForceEvenWidth);

    mpo.DirectRender := ReadBool(SECTIONNAME,'DirectRender', mpo.DirectRender);
    mpo.DoubleBuffer  := ReadBool(SECTIONNAME,'DoubleBuffer', mpo.DoubleBuffer);
    mpo.DrawSlices := ReadBool(SECTIONNAME,'DrawSlices', mpo.DrawSlices);

    mpo.TryScaler :=  ReadBool(SECTIONNAME,'TryScaler', mpo.TryScaler);
    mpo.VideoScaler := Unmap(VideoScalerMap,mpo.VideoScaler ,ReadString(SECTIONNAME,'VideoScaler',''));


    i := ReadInteger(SECTIONNAME,'volume', mpo.Volume);

    if (i> 100)  and (mpo.softvol = false) or (i < 0) then
       i:= 100;
    mpo.volume := i;

    mpo.AudioDecodeChannels := ReadInteger(SECTIONNAME, 'AudioDecodeChannels', mpo.AudioDecodeChannels);
    mpo.Ac3Comp := ReadInteger(SECTIONNAME, 'Ac3Compression', mpo.Ac3Comp);
    mpo.Useliba52 := ReadBool(SECTIONNAME, 'Useliba52', mpo.Useliba52);

    for i := 0 to high(propertyEntrys)  do begin
      value := ReadInteger(SECTIONNAME,
                                 propertyEntrys[i].name,
                                 propertyEntrys[i].def);
      mpo.setProperty(i, value);
    end;
    opt.VideoInside := ReadBool(SECTIONNAME, 'VideoInside', opt.VideoInside);
    opt.AlwaysOnTop := ReadBool(SECTIONNAME, 'AlwaysOnTop', opt.AlwaysOnTop);

    //vis
    vis.Enabled := ReadBool(SECTIONNAMEVIS,'Enabled', vis.Enabled);
    vis.DirectRender := ReadBool(SECTIONNAMEVIS,'DirectRender', vis.DirectRender);
    for i := 0 to vis.VisCount -1 do begin
      vis.Vis[i].Enabled :=
          ReadBool(SECTIONNAMEVIS,'Eff_' + vis.Vis[i].Name , vis.Vis[i].Enabled);
      vis.Vis[i].Blur  :=
          ReadBool(SECTIONNAMEVIS,'Eff_' + vis.Vis[i].Name + '_Blur' , vis.Vis[i].Blur);
    end;
    ReadSectionValues(SECTIONNAMEWINDOWPOS, opt.windowPos);
    Free;
  end;
end;

procedure Save(FileName:string ; onlysettings: boolean = false);
var INI:TVssMemIniFile;
    i : integer;
    //sValue : string;
    mpo : Tmplayer;
    vis : TVisEffects;
    sl : TStringList;
begin

  if FileName ='' then
    FileName := GetDefaultOptionsFile;
  try INI:=TVssMemIniFile.Create(FileName); except exit; end;

  mpo := frmMain.mpo;
  vis := frmMain.VisEffects;
  with INI do begin
    try
      if onlysettings = false  then begin
       WriteInteger(SECTIONNAME,'Locale',opt.DefaultLocale);
       WriteString(SECTIONNAME,'AudioOut',AudioOutMap[mpo.AudioOut]);
       WriteInteger(SECTIONNAME,'AudioDev',mpo.AudioDev);
       WriteString  (SECTIONNAME,'AudioFilterChannels',mpo.AudioFilterChannels);
       WriteBool  (SECTIONNAME,'UseVolCmd',mpo.UseVolCmd);


       WriteString(SECTIONNAME,'Postproc',PostprocMap[mpo.Postproc]);
       WriteString(SECTIONNAME,'DeinterlaceAlg',DeinterlaceAlgMap[mpo.DeinterlaceAlg]);
       WriteString(SECTIONNAME,'Deinterlace',DeinterlaceMap[mpo.Deinterlace]);
       WriteString(SECTIONNAME,'Aspect',AspectMap[mpo.Aspect]);
       WriteBool  (SECTIONNAME,'ReIndex',mpo.ReIndex);

       WriteInteger(SECTIONNAME,'Autosync',mpo.Autosync);
       WriteInteger(SECTIONNAME,'AVsyncPerFrame',mpo.AVsyncPerFrame);

       WriteBool  (SECTIONNAME,'SoftVol',mpo.SoftVol);
       WriteBool  (SECTIONNAME,'PriorityBoost',mpo.PriorityBoost);
       WriteString(SECTIONNAME,'Params',mpo.Params);

       for i := 0 to MAX_CACHE_ENTRYS do begin
        WriteInteger(SECTIONNAME,'Cache_' + cacheEntrys[i], mpo.Cachesize[i])
       end;

       WriteString(SECTIONNAME, 'FontEncoding', mpo.FontEncoding);
       WriteString(SECTIONNAME, 'FontPath', mpo.FontPath);

       WriteBool  (SECTIONNAME,'FontConfig',mpo.FontConfig);
       WriteBool  (SECTIONNAME,'SubAss',mpo.SubAss);
       WriteBool  (SECTIONNAME,'SubAutoLoad',mpo.SubAutoLoad);

       WriteRGBAColor(SECTIONNAME,'SubAssColor',mpo.SubAssColor);
       WriteRGBAColor(SECTIONNAME,'SubAssBorderColor',mpo.SubAssBorderColor);
       WriteRGBAColor(SECTIONNAME,'SubBgColor',mpo.SubBgColor);

       WriteBool  (SECTIONNAME,'UseDvdNav',mpo.UseDvdNav);
       WriteBool  (SECTIONNAME,'DeinterlaceDvd',mpo.DeinterlaceDvd);


       WriteInteger(SECTIONNAME,'FullScreenMonitor',opt.FullScreenMonitor);

       WriteRGBColor(SECTIONNAME,'OverlayColor',mpo.overlaycolor);

       WriteString(SECTIONNAME,'VideoOut',mpo.videoout);
       WriteString(SECTIONNAME,'VideoEq',mpo.videoeq);

       WriteBool(SECTIONNAME,'ForceEvenWidth', opt.ForceEvenWidth);

       WriteBool(SECTIONNAME,'DirectRender', mpo.DirectRender);
       WriteBool(SECTIONNAME,'DoubleBuffer', mpo.DoubleBuffer);
       WriteBool(SECTIONNAME,'DrawSlices', mpo.DrawSlices);

       WriteBool(SECTIONNAME,'TryScaler', mpo.TryScaler);
       WriteString(SECTIONNAME,'VideoScaler',VideoScalerMap[mpo.VideoScaler]);

       WriteInteger(SECTIONNAME, 'AudioDecodeChannels', mpo.AudioDecodeChannels);
       WriteInteger(SECTIONNAME,'Ac3Compression',mpo.Ac3Comp);
       WriteBool(SECTIONNAME, 'Useliba52', mpo.Useliba52);
      end;


      WriteInteger(SECTIONNAME,'Volume', mpo.Volume);

      for i := 0 to high(propertyEntrys)  do begin
        WriteInteger(SECTIONNAME, propertyEntrys[i].name,
                                  mpo.propertyValues[i].value);
      end;
      WriteBool(SECTIONNAME, 'VideoInside' ,opt.VideoInside);
      WriteBool(SECTIONNAME, 'AlwaysOnTop', opt.AlwaysOnTop);

      //vis
      WriteBool(SECTIONNAMEVIS,'Enabled', vis.Enabled);
      WriteBool(SECTIONNAMEVIS,'DirectRender', vis.DirectRender);
      for i := 0 to vis.VisCount -1 do begin
        WriteBool(SECTIONNAMEVIS,'Eff_' + vis.Vis[i].Name , vis.Vis[i].Enabled);
        WriteBool(SECTIONNAMEVIS,'Eff_' + vis.Vis[i].Name + '_Blur' , vis.Vis[i].Blur);
      end;

      sl := TStringList.Create;
      sl.Delimiter := '=';
      try
        for i := 0 to opt.windowPos.Count - 1 do begin
          sl.Clear;
          sl.DelimitedText := opt.windowPos[i];
          if sl.Count >= 2 then
            WriteString(SECTIONNAMEWINDOWPOS, sl[0], sl[1]);
        end;
      finally
        FreeAndNil(sl);
      end;
    except
    end;

    try
      UpdateFile;
    except
    end;
   Free;
  end;
end;

procedure ResetOpt();
begin
  with opt do begin
    WantFullscreen := false;
    WantCompact := false;
    AutoQuit := false;

    DefaultLocale := AutoLocale;
    AutoPlay := false  ;
    FullScreenMonitor := 0;
    VideoInside := true;
    AlwaysOnTOp := false;

    ForceEvenWidth := True;
  end;
end;
end.
