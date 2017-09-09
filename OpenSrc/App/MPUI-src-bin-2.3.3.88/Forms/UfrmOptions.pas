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
unit UfrmOptions;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, FormLocal,
  StdCtrls, ShellAPI, Menus, ExtCtrls, ComCtrls, ImgList, Config, mplayer, AutoselectEdits,
  UVssColorPicker;

type

  TfrmOptions = class(TFormLocal)
    BOK: TButton;
    BApply: TButton;
    BSave: TButton;
    BClose: TButton;
    EParams: TEdit;
    LHelp: TLabel;
    Pc: TPageControl;
    TabGeneral: TTabSheet;
    TabAudio: TTabSheet;
    TabVideo: TTabSheet;
    LAudioOut: TLabel;
    CAudioOut: TComboBox;
    CAudioDev: TComboBox;
    LAudioDev: TLabel;
    CPostproc: TComboBox;
    LPostproc: TLabel;
    LAspect: TLabel;
    LDeinterlaceAlg: TLabel;
    CDeinterlaceAlg: TComboBox;
    LDeinterlace: TLabel;
    CDeinterlace: TComboBox;
    lblOverlay: TLabel;
    CAspect: TComboBox;
    LLanguage: TLabel;
    CLanguage: TComboBox;
    CIndex: TCheckBox;
    CPriorityBoost: TCheckBox;
    lblVideoOut: TLabel;
    CVideoOut: TComboBox;
    CvideoEq: TComboBox;
    lblVideoeq: TLabel;
    CSoftVol: TCheckBox;
    imgLOpt: TImageList;
    ShapeGeneral: TShape;
    ShapeAudio: TShape;
    ShapeVideo: TShape;
    chkUseVolcmd: TCheckBox;
    LParams: TLabel;
    chkDirectRender: TCheckBox;
    chkDrawSlices: TCheckBox;
    chkDoubleBuffer: TCheckBox;
    Shape4: TShape;
    Shape5: TShape;
    lblVideoScaler: TLabel;
    CvideoScaler: TComboBox;
    chkTryScaler: TCheckBox;
    Shape6: TShape;
    trkAc3Comp: TTrackBar;
    lblAc3Comp: TLabel;
    lblAc3CompVal: TLabel;
    TabCaching: TTabSheet;
    imgListDrive: TImageList;
    ShapeCaching: TShape;
    lblFullScreenMonitor: TLabel;
    TabOSDSub: TTabSheet;
    ShapeOSDSub: TShape;
    lblFontPath: TLabel;
    TabDvd: TTabSheet;
    ShapeDvd: TShape;
    chkUseDvdNav: TCheckBox;
    Shape1: TShape;
    Shape2: TShape;
    lblAutosync: TLabel;
    LblAVsyncperframe: TLabel;
    chkDeinterlaceDVD: TCheckBox;
    lblFontEncoding: TLabel;
    cFontEncoding: TComboBox;
    lblAudioDecodeChannels: TLabel;
    lblAudiofilterchannels: TLabel;
    Shape3: TShape;
    chkUseliba52: TCheckBox;
    chkForceEvenWidth: TCheckBox;
    cpkOverlay: TVssColorPicker;
    chkAssSubs: TCheckBox;
    chkFontConfig: TCheckBox;
    chkAutoLoadSubs: TCheckBox;
    cpkSubAssColor: TVssColorPicker;
    cpkSubAssBorderColor: TVssColorPicker;
    cpkSubBgColor: TVssColorPicker;
    lblSubAssBorderColor: TLabel;
    lblSubAssColor: TLabel;
    lblSubBgColor: TLabel;
    procedure FormHide(Sender: TObject);
    procedure trkAc3CompChange(Sender: TObject);
    procedure PcChange(Sender: TObject);
    procedure EParamsKeyPress(Sender: TObject; var Key: Char);
    procedure BCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LHelpClick(Sender: TObject);
    procedure BApplyClick(Sender: TObject);
    procedure BOKClick(Sender: TObject);
    procedure SomethingChanged(Sender: TObject);
    procedure BSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CAudioOutChange(Sender: TObject);
    procedure CVideoOutChange(Sender: TObject);
    procedure PcDrawTab(Control: TCustomTabControl; TabIndex: Integer;
      const Rect: TRect; Active: Boolean);
    //procedure CVideoEqChange(Sender: TObject);
  private
    { Private declarations }
    HelpFile:string;

    txtvideoout : TEditAutoselect;
    txtFontPath : TEditAutoselect;

    txtCache : array[0..MAX_CACHE_ENTRYS] of TEditNumeric;
    lblCache : array[0..MAX_CACHE_ENTRYS] of Tlabel;
    txtFullScreenMonitor : TEditNumeric;
    txtAutoSync : TEditNumeric;
    txtAVsyncPerFrame : TEditNumeric;
    txtAudioDecodeChannels : TEditNumeric;
    txtAudioFilterChannels : TEditNumeric;
  protected

  public
    { Public declarations }
    Changed:boolean;
    procedure ApplyValues;
    procedure LoadValues;
    procedure LoadAudiooutValue;
    procedure DoLocalize(); override;
  end;

var
  frmOptions: TfrmOptions;

implementation
uses  UfrmMain, Locale;

type PDSEnumCallback=function(lpGuid:PGUID; lpcstrDescription,lpcstrModule:PChar; lpContext:pointer):LongBool; stdcall;
function DirectSoundEnumerate(lpDSEnumCallback:PDSEnumCallback; lpContext:pointer):HRESULT;
         stdcall; external 'dsound.dll' name 'DirectSoundEnumerateA';

{$R *.dfm}



procedure TfrmOptions.BCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmOptions.DoLocalize;
var i : integer;
begin
  inherited;
  Font.Charset:=CurrentLocaleCharset;
  LHelp.Font.Charset:=CurrentLocaleCharset;

  //form texts
  Caption:=LOCstr.OptionsFormCaption;
  BOK.Caption:=LOCstr.OptionsFormOK;
  BApply.Caption:=LOCstr.OptionsFormApply;
  BSave.Caption:=LOCstr.OptionsFormSave;
  BClose.Caption:=LOCstr.OptionsFormClose;
  LHelp.Caption:=LOCstr.OptionsFormHelp;
  LParams.Caption:=LOCstr.OptionsFormParams;

  //general tab
  lblFullScreenMonitor.Caption := LOCstr.FullScreenMonitor;
  LLanguage.Caption:=LOCstr.Language;
  CIndex.Caption:=LOCstr.OptionsFormIndex;
  CPriorityBoost.Caption:=LOCstr.OptionsFormPriorityBoost;

  lblAutosync.Caption := LOCstr.Autosync;
  LblAVsyncperframe.caption := LOCstr.AVsyncperframe;

  //audio tab
  LAudioOut.Caption:=LOCstr.OptionsFormAudioOut;
  LAudioDev.Caption:=LOCstr.OptionsFormAudioDev;
  lblAudiofilterchannels.Caption := LOCstr.OptionsFormAudioFilterChannels;
  CSoftVol.Caption:=LOCstr.OptionsFormSoftVol;
  chkUseVolcmd.Caption := LOCstr.OptionsFormUseVolcmd;
  lblAudioDecodeChannels.Caption := LOCstr.OptionsFormAudioDecodeChannels;
  lblAc3Comp.Caption := LOCstr.OptionsFormAc3Comp;
  chkUseliba52.Caption := LOCstr.OptionsFormUseliba52;

  //video tab
  lblVideoOut.Caption := LOCstr.OptionsFormVideoOut;
  lblOverlay.Caption := LOCstr.OptionsFormOverlay;

  chkForceEvenWidth.Caption := LOCstr.ForceEvenWidth;
  chkDirectRender.Caption  := LOCstr.DirectRender;
  chkDoubleBuffer.Caption := LOCstr.DoubleBuffer;
  chkDrawSlices.Caption := LOCstr.DrawSlices;

  lblVideoeq.Caption  := LOCstr.OptionsFormVideoeq;
  lblVideoScaler.Caption := LOCstr.VideoScaler;
  chkTryScaler.Caption := LOCstr.TryScaler;

  LAspect.Caption:=LOCstr.Aspect;
  LDeinterlace.Caption:=LOCstr.Deinterlace;
  LDeinterlaceAlg.Caption := LOCstr.DeinterlaceAlg ;
  LPostproc.Caption:=LOCstr.OptionsFormPostproc;


  if Clanguage.Items.Count = 0 then begin
    CLanguage.Clear;
    CLanguage.Items.Add(LOCstr.AutoLocale);
    for i:=0 to High(Locales) do
      CLanguage.Items.Add(Locales[i].Name);
  end else begin
//    CLanguage.Items[0]:= LOCstr.AutoLocale;
    changeComboTstring(Clanguage,0, LOCstr.AutoLocale);
  end;

  if CAspect.items.Count =0 then begin // combos that don't do localize, only first time
    BuildOptCombo(VideoOutMap ,cVideoOut);
    BuildOptCombo(Videoeqmap ,cVideoEq);
  end;

  changeComboTstring(cVideoOut,cVideoOut.Items.Count-1,LOCstr.VideoOutUser);
  changecomboTstring(cVideoEq,0, LOCstr.VideoeqOff);

  if caudioout.Items.Count = 0 then
    BuildOptCombo(AudioOutMap,cAudioOut);

  BuildOptCombo(LOCstr.AspectMap,CAspect);
  BuildOptCombo(LOCstr.DeinterlaceAlgMap,CDeinterlaceAlg);
  BuildOptCombo(LOCstr.OffOnAuto,CDeinterlace);

  BuildOptCombo(LOCstr.Postproc, cPostProc);
  BuildOptCombo(LOCstr.AudioOut, cAudioOut);
  BuildOptCombo(LOCstr.OffOnAUto, CVideoScaler);

  Tabgeneral.Caption := LOCstr.OptionsFormGeneral;
  Tabaudio.Caption := LOCstr.OptionsFormAudio;
  Tabvideo.Caption := LOCstr.OptionsFormVideo;
  Tabcaching.Caption := LOCstr.OptionsFormCaching;
  TabOsdSub.Caption := LOCstr.OptionsFormOSDSub;

  if cFontEncoding.Items.Count =0 then begin
      cFontEncoding.Clear;
      BuildOptCombo(mplayerfontEncodingsMap, cFontEncoding);
  end;
  BuildOptCombo(LOCstr.FontEncodings, cFontEncoding);
  lblFontEncoding.Caption := LOCstr.FontEncoding;
  lblFontPath.Caption :=  LOCstr.FontPath;

  chkFontConfig.Caption := LOCstr.FontConfig;
  chkAssSubs.Caption := LOCstr.SubAss;
  chkAutoLoadSubs.Caption := LOCstr.SubAutoLoad;

  lblSubAssColor.Caption := LOCstr.SubAssColor;
  lblSubAssBorderColor.Caption := LOCstr.SubAssBorderColor;
  lblSubBgColor.Caption := locstr.SubBgColor;


  lblcache[CACHE_TYPE_DEFAULT].Caption  := LOCstr.MediaDefault;
  lblcache[CACHE_TYPE_FIXED].Caption := LOCstr.MediaFixed;
  lblcache[CACHE_TYPE_RAMDISK].Caption := LOCstr.MediaRamdisk;
  lblcache[CACHE_TYPE_CDROM].Caption := LOCstr.MediaCdrom;
  lblcache[CACHE_TYPE_REMOVABLE].Caption := LOCstr.MediaRemovable;
  lblcache[CACHE_TYPE_NETWORK].Caption := LOCstr.mediaNetwork;
  lblcache[CACHE_TYPE_INTERNET].Caption := LOCstr.MediaInternet;
  lblcache[CACHE_TYPE_DVD].Caption := LOCstr.MediaDvd;

  //dvd tab
  chkUseDvdNav.Caption := LOCstr.UseDvdNav;
  chkDeinterlaceDVD.Caption := LOCstr.DeinterlaceDVD;
end;


procedure TfrmOptions.FormShow(Sender: TObject);
begin
  frmMain.MOptions.Checked := true;
  LoadValues;
  Changed:=false;

  HelpFile:=frmMain.mpo.Mplayerpath +'man_page.html';
  if not FileExists(HelpFile) then begin
    HelpFile:=frmMain.mpo.Mplayerpath+'MPlayer.html';
    if not FileExists(HelpFile) then
      HelpFile:='';
  end;
  if length(HelpFile)>0 then begin
    LHelp.Visible:=true;
    HelpFile:=#34+HelpFile+#34;
  end else
    LHelp.Visible:=false;
end;
procedure TfrmOptions.FormHide(Sender: TObject);
begin
  frmMain.MOptions.Checked := false;
end;

procedure TfrmOptions.LHelpClick(Sender: TObject);
begin
  if length(HelpFile)>0 then
    ShellExecute(Handle,'open',PChar(HelpFile),nil,nil,SW_SHOW);
end;

procedure TfrmOptions.LoadAudiooutValue;
begin
  if (cAudiodev.Tag <> 0) and
     (frmMain.mpo.AudioDev < cAudiodev.Items.Count ) then // if enumerated
    CAudioDev.ItemIndex:=frmMain.mpo.AudioDev;
end;

procedure TfrmOptions.LoadValues;
var i : integer;
begin
 with frmMain.mpo do begin
  CAudioOut.ItemIndex:=AudioOut;
  LoadAudioOutValue;
  txtAudioFilterChannels.Text := AudioFilterChannels;
  CPostproc.ItemIndex:=Postproc;
  CAspect.ItemIndex:=Aspect;
  CDeinterlaceAlg.ItemIndex:=DeinterlaceAlg;
  Cdeinterlace.ItemIndex := Deinterlace ;
  CLanguage.ItemIndex:=opt.DefaultLocale+1;
  CIndex.Checked:=ReIndex;
  CSoftVol.Checked:=SoftVol;
  CPriorityBoost.Checked:=PriorityBoost;

  txtAutosync.Text := inttostr(Autosync);
  txtAVsyncPerFrame.Text := inttostr(AVsyncPerFrame);

  EParams.Text:=Params;
  cpkOverlay.SolidColor := overlaycolor;
  //cpkOverlay.HasAlpha := True;

  chkForceEvenWidth.Checked := Opt.ForceEvenWidth;

  chkDirectrender.Checked := DirectRender;
  chkDoublebuffer.Checked := DoubleBuffer;
  chkDrawslices.Checked := DrawSlices;

  chkTryscaler.Checked := TryScaler;
  CVideoScaler.ItemIndex := VideoScaler;

  CAudioOutChange(nil);
  chkUseVolcmd.Checked := UseVolCmd;

  txtAudioDecodechannels.Text := inttostr(AudioDecodechannels);
  trkAc3Comp.Position := Ac3Comp;
  chkUseliba52.Checked := Useliba52;

  checkComboOptStr(VideoOutMap , cVideoOut , videoout);
  txtvideoout.Text := videoout;
  CVideoOutChange(nil);

  checkComboOptStr(VideoeqMap , cVideoEq , videoeq);


  for i := 0 to MAX_CACHE_ENTRYS do begin
       txtcache[i].Text := inttostr(Cachesize[i]);
  end;

  checkComboOptStr(mplayerfontEncodingsMap,CFontEncoding,FontEncoding);
  txtFontPath.Text := FontPath;

  chkFontConfig.Checked := FontConfig;
  chkAssSubs.Checked := SubAss;
  chkAutoLoadSubs.Checked := SubAutoLoad;

  cpkSubAssColor.AlphaColor := SubAssColor;
  cpkSubAssBorderColor.AlphaColor := SubAssBorderColor;
  cpkSubBgColor.AlphaColor := SubBgColor;

  chkUseDvdNav.Checked := UseDvdNav;
  chkDeinterlaceDVD.Checked := DeinterlaceDVD;
 end;
 txtFullScreenMonitor.Text := inttostr(opt.FullScreenMonitor);

end;

function EnumFunc(lpGuid:PGUID; lpcstrDescription,lpcstrModule:PChar; lpContext:pointer):LongBool; stdcall;
begin
  TComboBox(lpContext^).Items.Add(lpcstrDescription);
  Result:=True;
end;
procedure TfrmOptions.PcChange(Sender: TObject);
begin
  if tabaudio.Visible then //enumerate devices only if tabaudio is clicked
    if cAudiodev.Tag = 0 then begin // only if not already enumerated
        DirectSoundEnumerate(EnumFunc,@CAudioDev);
        cAudiodev.Tag := 1;
        LoadAudiooutValue;
    end;
end;

procedure TfrmOptions.PcDrawTab(Control: TCustomTabControl; TabIndex: Integer;
  const Rect: TRect; Active: Boolean);
var txtName : string;
  rectT : Trect;
  iconSize : integer;
begin
  rectT := rect;
  if active  then begin
    control.Canvas.Brush.Color := clhighlight;
    control.Canvas.font.Color := clHighlightText;
    control.Canvas.Pen.Color := control.Canvas.Brush.Color;
    control.Canvas.Rectangle(rect);
  end;

  iconsize := imglOpt.Width;
  imglOpt.Draw(control.Canvas,Rect.Left +1,Rect.Top + (Rect.Bottom - Rect.Top -16) div 2 ,
       TabIndex, dsNormal,itImage);

  txtname := ((control as tpagecontrol).Pages[TabIndex] as Ttabsheet).Caption;
  control.Canvas.Brush.Style := bsclear;
  Rectt.Left  := Rectt.Left + iconsize;
  Control.canvas.TextRect(Rectt,txtName,[tfVerticalCenter, tfSingleLine, tfCenter]);
end;

procedure TfrmOptions.ApplyValues;
var i : integer;
begin
  with frmMain.mpo do begin
    StartPropertyChange;

    AudioOut:=CAudioOut.ItemIndex;
    if (cAudiodev.Tag <> 0) and
       (CAudioDev.ItemIndex >= 0) then // if enumerated
      AudioDev:=CAudioDev.ItemIndex;
    AudioFilterChannels :=txtAudioFilterChannels.Text;
    Postproc:=CPostproc.ItemIndex;
    Aspect:=CAspect.ItemIndex;
    DeinterlaceAlg:=CDeinterlaceAlg.ItemIndex;
    Deinterlace  := Cdeinterlace.ItemIndex;
    ReIndex:=CIndex.Checked;
    SoftVol:=CSoftVol.Checked;
    PriorityBoost:=CPriorityBoost.Checked;

    try Autosync :=  strtoint(txtAutosync.Text); except end;
    try AVsyncPerFrame :=  strtoint(txtAVsyncPerFrame.Text); except end;

    Params:=Trim(EParams.Text);
    overlaycolor := cpkOverlay.SolidColor;

    opt.ForceEvenWidth := chkForceEvenWidth.Checked;

    DirectRender := chkDirectRender.Checked;
    DoubleBuffer := chkDoubleBuffer.Checked;
    DrawSlices := chkDrawSlices.Checked;

    TryScaler := chkTryscaler.Checked;
    VideoScaler := CVideoScaler.ItemIndex;

    UseVolCmd := chkUseVolcmd.Checked;

    try AudioDecodechannels := strtoint(txtAudioDecodechannels.Text); except end;
    Ac3Comp := strtoint(lblAc3CompVal.Caption);
    Useliba52 := chkUseliba52.Checked;

    videoout := txtvideoout.Text;
    videoeq :=  VideoeqMap[Cvideoeq.itemindex];

    for i := 0 to MAX_CACHE_ENTRYS do begin
      try
        Cachesize[i] := strtoint(txtcache[i].Text);
      except
      end;
    end;
    if (CFontEncoding.ItemIndex >=0) and
       (CFontEncoding.ItemIndex <= high(mplayerfontEncodingsMap))  then
      FontEncoding := mplayerfontEncodingsMap[CFontEncoding.ItemIndex];
    FontPath := txtFontPath.Text;
  
    FontConfig := chkFontConfig.Checked;
    SubAss := chkAssSubs.Checked;
    SubAutoLoad := chkAutoLoadSubs.Checked;

    SubAssColor := cpkSubAssColor.AlphaColor;
    SubAssBorderColor := cpkSubAssBorderColor.AlphaColor;
    SubBgColor := cpkSubBgColor.AlphaColor;

    UseDvdNav := chkUseDvdNav.Checked;
    DeinterlaceDVD := chkDeinterlaceDVD.Checked;

    EndPropertyChange;
    frmMain.UpdateVolumeSlider;
  end;

  opt.FullScreenMonitor := strtoint(txtFullScreenMonitor.Text);

  if Changed then begin
    opt.DefaultLocale:=CLanguage.ItemIndex-1;
    ActivateLocale(opt.DefaultLocale);
    Changed:=false;
  end;
end;

procedure TfrmOptions.BApplyClick(Sender: TObject);
begin
  ApplyValues;
  LoadValues;
end;

procedure TfrmOptions.BOKClick(Sender: TObject);
begin
  ApplyValues;
  Close;
end;
procedure TfrmOptions.BSaveClick(Sender: TObject);
begin
  ApplyValues;
  Config.Save('');
  LoadValues;
end;

procedure TfrmOptions.SomethingChanged(Sender: TObject);
begin
  if sender <> nil then
    Changed:=true;
end;

procedure TfrmOptions.trkAc3CompChange(Sender: TObject);
begin
  lblAc3CompVal.Caption  := inttostr(trkAc3Comp.Position);
  //SomethingChanged(Sender);
end;


procedure TfrmOptions.FormCreate(Sender: TObject);
  function GetControlTop(cntrl: Tcontrol; row: integer): integer;
  begin
    Result := 21 + (row - 1)*24 - (cntrl.Height div 2);
    if cntrl is tlabel then
      Result := result -1;    
  end;
  function GetControlLeft(cntrl: Tcontrol; col: integer): integer;
  begin
    case col of
      1:
        Result := 10;
      2:
        Result := 176;
      3:
        Result := 352;
      else
        Result := col;
    end;
  end;
  function AddControl(cntrlClass : TcontrolClass; Tab:TTabsheet;
                     row: integer; col: integer): Tcontrol;
  begin
    Result := cntrlClass.Create(Tab);
    Result.Parent := Tab;
    if (row > 0) and (col > 0) then
      Result.SetBounds(GetControlLeft(Result,col),GetControlTop(Result,row),
                      Result.Width, Result.Height)
    else begin
      if row > 0 then
        Result.top := GetControlTop(Result,row);
      if col > 0 then
        Result.Left := GetControlLeft(Result,col);
    end;
      
    if Result is Tedit then begin
      if (col >= 2) and (col <= 3) then
        Result.Width := cLanguage.Width;
    end;
  end;
var i: integer;
  newlabel : Tlabel;
  newimage : Timage;
  newedit : TEditNumeric;
begin
  shapeGeneral.Brush.Color := self.Color;
  shapeAudio.Brush.Color := self.Color;
  shapeVideo.Brush.Color := self.Color;
  shapeCaching.Brush.Color := self.Color;
  shapeOsdSub.Brush.Color := self.Color;
  shapeDvd.Brush.Color := self.Color;
  trkAc3CompChange(nil); //update text
  //icon := mainform.Icon;



  txtFullScreenMonitor := (AddControl(TEditNumeric,Tabgeneral,5,2) as  TEditNumeric);
  txtFullScreenMonitor.AutoSize := true;
  txtFullScreenMonitor.MaxLength := 2;

  txtAutoSync :=  (AddControl(TEditNumeric,Tabgeneral,10,2) as TEditNumeric);
  txtAutoSync.MaxLength := 5;
  txtAVsyncPerFrame := (AddControl(TEditNumeric,Tabgeneral,11,2) as TEditNumeric);
  txtAVsyncPerFrame.MaxLength := 5;


  txtAudioDecodeChannels := (AddControl(TEditNumeric,TabAudio,7,2) as  TEditNumeric);
  txtAudioDecodeChannels.AutoSize := true;
  txtAudioDecodeChannels.MaxLength := 2;
  txtAudioDecodeChannels.TabOrder := trkAc3Comp.TabOrder;

  txtAudioFilterChannels := (AddControl(TEditNumeric,TabAudio,10,2) as  TEditNumeric);
  txtAudioFilterChannels.AutoSize := true;
  txtaudiofilterchannels.Allowedchars := txtaudiofilterchannels.Allowedchars + ':';


  txtvideoout := (AddControl(TEditAutoselect,Tabvideo,1,3) as TEditAutoselect);
  txtvideoout.TabOrder := cvideoout.taborder +1;


  txtFontPath := (AddControl(TEditAutoselect,TabOSDSub,1,176) as TEditAutoselect);
  txtfontpath.Width := GetControlLeft(nil,3) + cLanguage.Width - txtFontPath.Left ;
  txtfontpath.TabOrder := 0;

  cpkSubAssColor.HasAlpha := True;
  cpkSubAssBorderColor.HasAlpha := True;
  cpkSubBgColor.OnlyGrayScale := True;
  cpkSubBgColor.HasAlpha := True;

  //SetControlPos(lblAutosync,9);



  //create cache tab controls
  for i := 0 to MAX_CACHE_ENTRYS do begin
    newlabel := Tlabel.Create(TabCaching);
    newlabel.Parent := TabCaching;
    newlabel.Caption := cacheEntrys[i] + ':';
    newlabel.SetBounds(GetControlLeft(newlabel,1) +32,GetControlTop(newlabel,i+1),
                       newlabel.Width, newlabel.Height);
    newlabel.AutoSize := true;

    lblCache[i]:= newlabel;

    newImage := Timage.Create(Tabcaching);
    newImage.Parent := TabCaching;
    newImage.SetBounds(llanguage.Left, newlabel.Top, 16, 16);
    newimage.Transparent := true;
    newimage.Tag := -1;
    UpdateImageFromImagery(newimage,imgListDrive,i);

    newedit :=  (AddControl(TEditNumeric,Tabcaching,i+1,2) as TEditNumeric);
    newedit.AutoSize := true;
    newedit.MaxLength := 5;

    txtCache[i]:= newedit;
    //newedit.Align := taright;

    newlabel := Tlabel.Create(TabCaching);
    newlabel.Parent := TabCaching;
    newlabel.SetBounds(newedit.Left+ newedit.Width + 16, lblCache[i].top,
                           newlabel.Width, newlabel.Height);
    newlabel.Caption := 'Kbytes';
  end;

end;



procedure TfrmOptions.CAudioOutChange(Sender: TObject);
var e:boolean;
begin
  e:=(CAudioOut.ItemIndex=3);
  LAudioDev.Enabled:=e;
  CAudioDev.Enabled:=e;
  //SomethingChanged(Sender);
end;



(*procedure TOptionsForm.CVideoEqChange(Sender: TObject);
begin
  SomethingChanged(Sender);
end;*)

procedure TfrmOptions.CVideoOutChange(Sender: TObject);
var e:boolean;
begin
  e := (VideoOutMap[CVideoOut.itemindex]='#');
  if e then
    txtvideoout.Text := frmMain.mpo.videoout
  else
    txtvideoout.Text := VideoOutMap[CVideoOut.itemindex];

  Txtvideoout.Enabled := e;
  //SomethingChanged(Sender);
end;

procedure TfrmOptions.EParamsKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=^M then begin
    self.BApplyClick(self);
    key := #0;
  end;
end;



end.
