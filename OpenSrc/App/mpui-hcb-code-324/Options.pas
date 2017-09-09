{   MPUI-hcb, an MPlayer frontend for Windows
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
unit Options;

interface

uses
  Windows, TntWindows, Messages, SysUtils, TntSysUtils, Variants, Classes, Graphics, Controls,
  Forms, TntForms, TntDialogs, StdCtrls, ShellAPI, ComCtrls, ExtCtrls, TntSystem,
  TntExtCtrls, TntComCtrls, TntStdCtrls, TntFileCtrl, TntRegistry, TntClasses,
  jpeg, CheckLst, ShlObj, Dialogs, ActiveX, TntGraphics, Math, TntMenus;

type
  Tass = class(TThread)
    protected
      procedure Execute; override;
  end;

  TOptionsForm = class(TTntForm)
    BOK: TTntButton;
    BApply: TTntButton;
    BSave: TTntButton;
    BClose: TTntButton;
    EParams: TTntEdit;
    LParams: TTntLabel;
    LHelp: TTntLabel;
    Tab: TTntPageControl;
    TSystem: TTntTabSheet;
    TVideo: TTntTabSheet;
    TAudio: TTntTabSheet;
    TLog: TTntTabSheet;
    TSub: TTntTabSheet;
    LAudioOut: TTntLabel;
    CAudioOut: TTntComboBox;
    LPostproc: TTntLabel;
    CPostproc: TTntComboBox;
    LAspect: TTntLabel;
    CAspect: TTntComboBox;
    LDeinterlace: TTntLabel;
    CDeinterlace: TTntComboBox;
    LLanguage: TTntLabel;
    CLanguage: TTntComboBox;
    LAudioDev: TTntLabel;
    CAudioDev: TComboBox;
    CSoftVol: TTntCheckBox;
    CVolnorm: TTntCheckBox;
    double: TTntCheckBox;
    CDr: TTntCheckBox;
    nfconf: TTntCheckBox;
    EMplayerLocation: TTntEdit;
    BSubfont: TTntButton;
    BMplayer: TTntButton;
    CSubcp: TComboBox;
    CMAspect: TComboBox;
    LMAspect: TTntLabel;
    CSPDIF: TTntCheckBox;
    CCh: TComboBox;
    CWid: TTntCheckBox;
    CFlip: TTntCheckBox;
    CYuy2: TTntCheckBox;
    CEq2: TTntCheckBox;
    CIndex: TTntCheckBox;
    CMir: TTntCheckBox;
    CNi: TTntCheckBox;
    CDnav: TTntCheckBox;
    CUtf: TTntCheckBox;
    CUni: TTntCheckBox;
    TFsize: TTrackBar;
    TFol: TTrackBar;
    EWadsp: TTntEdit;
    BWadsp: TTntButton;
    CWadsp: TTntCheckBox;
    CLavf: TTntCheckBox;
    RCMplayer: TTntRadioButton;
    RMplayer: TTntRadioButton;
    TFB: TTrackBar;
    SSubcode: TTntStaticText;
    SSubfont: TTntStaticText;
    SFsize: TTntStaticText;
    SFB: TTntStaticText;
    SFol: TTntStaticText;
    SFsP: TTntStaticText;
    SFBl: TTntStaticText;
    SFo: TTntStaticText;
    CFd: TTntCheckBox;
    CAsync: TTntCheckBox;
    EAsync: TTntEdit;
    UAsync: TTntUpDown;
    CCache: TTntCheckBox;
    ECache: TTntEdit;
    UCache: TTntUpDown;
    CPriorityBoost: TTntCheckBox;
    CRFScr: TTntCheckBox;
    CSubfont: TTntComboBox;
    BOsdfont: TButton;
    SFontColor: TTntStaticText;
    SOutline: TTntStaticText;
    PTc: TPanel;
    POc: TPanel;
    ColorDialog1: TColorDialog;
    CAss: TTntCheckBox;
    CEfont: TTntCheckBox;
    CRot: TComboBox;
    CISub: TTntCheckBox;
    SSF: TTntStaticText;
    BSsf: TTntButton;
    ESsf: TTntEdit;
    SOsdfont: TTntCheckBox;
    LCh: TTntStaticText;
    LRot: TTntStaticText;
    Cone: TTntCheckBox;
    CGUI: TTntCheckBox;
    CNobps: TTntCheckBox;
    CFilter: TTntCheckBox;
    TLyric: TTntGroupBox;
    LTCL: TTntLabel;
    PLTC: TPanel;
    LHCL: TTntLabel;
    PLBC: TPanel;
    LBCL: TTntLabel;
    PLHC: TPanel;
    SLyric: TTntLabel;
    ELyric: TTntEdit;
    BLyric: TTntButton;
    Ldlod: TTntCheckBox;
    CVSync: TTntCheckBox;
    BFont: TButton;
    FontDialog1: TFontDialog;
    LVideoout: TTntLabel;
    CVideoOut: TComboBox;
    THelp: TTntTabSheet;
    TAbout: TTntTabSheet;
    LURL: TLabel;
    MCredits: TMemo;
    HelpText: TTntMemo;
    PLogo: TPanel;
    ILogo: TImage;
    MTitle: TTntLabel;
    LVersionMPUI: TTntLabel;
    VersionMPUI: TTntLabel;
    LVersionMPlayer: TTntLabel;
    VersionMPlayer: TTntLabel;
    FY: TTntLabel;
    CRS: TTntCheckBox;
    CSP: TTntCheckBox;
    HCB: TTntLabel;
    TheLog: TTntMemo;
    Command: TTntEdit;
    CRP: TTntCheckBox;
    CTime: TTntCheckBox;
    TOther: TTntTabSheet;
    TFass: TCheckListBox;
    TFadd: TTntButton;
    TEAss: TTntEdit;
    TFSet: TTntButton;
    TFdel: TTntButton;
    TBa: TTntButton;
    TBn: TTntButton;
    CDs: TTntCheckBox;
    HK: TTntListView;
    RHK: TTntButton;
    TseekL: TTntLabel;
    Eseek: TTntEdit;
    TUnit: TTntLabel;
    nmsgm: TTntCheckBox;
    Esubfont: TTntEdit;
    Cosdfont: TTntComboBox;
    Eosdfont: TTntEdit;
    Cconfig: TTntCheckBox;
    CAddsfiles: TTntCheckBox;
    CLS: TTntCheckBox;
    EAV: TTntEdit;
    UDAV: TTntUpDown;
    CAV: TTntCheckBox;
    ads: TTntCheckBox;
    procedure BCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LHelpClick(Sender: TObject);
    procedure BApplyClick(Sender: TObject);
    procedure BOKClick(Sender: TObject);
    procedure BSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CAudioOutChange(Sender: TObject);
    procedure BSubfontClick(Sender: TObject);
    procedure BMplayerClick(Sender: TObject);
    procedure CDDXAClick(Sender: TObject);
    procedure TFsizeChange(Sender: TObject);
    procedure TFolChange(Sender: TObject);
    procedure CWadspClick(Sender: TObject);
    procedure BWadspClick(Sender: TObject);
    procedure RMplayerClick(Sender: TObject);
    procedure RCMplayerClick(Sender: TObject);
    procedure TFBChange(Sender: TObject);
    procedure CAsyncClick(Sender: TObject);
    procedure CCacheClick(Sender: TObject);
    procedure FontChange(Sender: TObject);
    procedure BOsdfontClick(Sender: TObject);
    procedure SetColor(Sender: TObject);
    procedure CAssClick(Sender: TObject);
    procedure SOsdfontClick(Sender: TObject);
    procedure BSsfClick(Sender: TObject);
    procedure BFontClick(Sender: TObject);
    procedure CommandKeyPress(Sender: TObject; var Key: Char);
    procedure CommandKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TabChange(Sender: TObject);
    procedure TFaddClick(Sender: TObject);
    procedure TFdelClick(Sender: TObject);
    procedure TBaClick(Sender: TObject);
    procedure TBnClick(Sender: TObject);
    procedure TFSetClick(Sender: TObject);
    procedure HKDblClick(Sender: TObject);
    procedure HKKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure HKClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure HKKeyPress(Sender: TObject; var Key: Char);
    procedure LoadHotKey;
    procedure SaveHotKey;
    procedure RHKClick(Sender: TObject);
    procedure CSubfontDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure CSubfontMeasureItem(Control: TWinControl; Index: Integer;
      var Height: Integer);
    procedure CSubfontChange(Sender: TObject);
    procedure LURLClick(Sender: TObject);
    procedure CosdfontMeasureItem(Control: TWinControl; Index: Integer;
      var Height: Integer);
    procedure CosdfontDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure CSubfontDropDown(Sender: TObject);
    procedure CAVClick(Sender: TObject);

  private
    { Private declarations }
    HelpFile, tCap: WideString;
    Changed, oML, Ikey: boolean;
    History: TTntStringList;
    HistoryPos, sIndex: integer;
  public
    { Public declarations }
    procedure Localize;
    procedure ApplyValues;
    procedure LoadValues;
    procedure AddLine(const Line: Widestring);
    function HotKeyToOldKey(var Shift: TShiftState; var Key: Word): TListItem;
    procedure GetFass;
    procedure SetFass;
  end;

  PDSEnumCallback = function(lpGuid: PGUID; lpcstrDescription, lpcstrModule: PChar; lpContext: pointer): LongBool; stdcall;

  ASSOCIATIONLEVEL = (AL_MACHINE, AL_EFFECTIVE, AL_USER);

  ASSOCIATIONTYPE = (AT_FILEEXTENSION, AT_URLPROTOCOL, AT_STARTMENUCLIENT, AT_MIMETYPE);

  IApplicationAssociationRegistration = interface(IUnknown)
    ['{4e530b0a-e611-4c77-a3ac-9031d022281b}']
    function QueryCurrentDefault(pszQuery: PWChar; atQueryType: ASSOCIATIONTYPE; alQueryLevel: ASSOCIATIONLEVEL; out ppszAssociation: PPWideChar): HRESULT; stdcall;
    function QueryAppIsDefault(pszQuery: PWChar; atQueryType: ASSOCIATIONTYPE; alQueryLevel: ASSOCIATIONLEVEL; pszAppRegistryName: PWChar; out pfDefault: PBool): HRESULT; stdcall;
    function QueryAppIsDefaultAll(alQueryLevel: ASSOCIATIONLEVEL; pszAppRegistryName: PWChar; out pfDefault: PBool): HRESULT; stdcall;
    function SetAppAsDefault(pszAppRegistryName: PWChar; pszSet: PWChar; atSetType: ASSOCIATIONTYPE): HRESULT; stdcall;
    function SetAppAsDefaultAll(pszAppRegistryName: PWChar): HRESULT; stdcall;
    function ClearUserAssociations: HRESULT; stdcall;
  end;

const CLSID_ApplicationAssociationRegistration: TGUID = '{591209c7-767b-42b2-9fba-44ee4615f2c7}';
  IID_IApplicationAssociationRegistration: TGUID = '{4e530b0a-e611-4c77-a3ac-9031d022281b}';

procedure LoadDsLibrary;
procedure UnLoadDsLibrary;
function KeyboardHook(nCode: Integer; wParam: WPARAM; lParam: LPARAM): LResult; stdcall;
procedure regAss();
procedure HkToShiftKey(const Hk: integer; var Shift: TShiftState; var Key: Word);

var
  OptionsForm: TOptionsForm; IsDsLoaded: THandle = 0; OptionsFormHook: HHOOK; ctrlkey: TShiftState = [];

implementation
uses Core, Config, Main, Locale, plist, unrar, LyricShow;

{$R *.dfm}
var DirectSoundEnumerate: function(lpDSEnumCallback: PDSEnumCallback; lpContext: pointer): HRESULT; stdcall;

procedure LoadDsLibrary;
begin
  if IsDsLoaded <> 0 then exit;
  IsDsLoaded := Tnt_LoadLibraryW('dsound.dll');
  if IsDsLoaded <> 0 then
    @DirectSoundEnumerate := GetProcAddress(IsDsLoaded, 'DirectSoundEnumerateA');
end;

procedure UnLoadDsLibrary;
begin
  if IsDsLoaded <> 0 then begin
    FreeLibrary(IsDsLoaded);
    IsDsLoaded := 0;
    DirectSoundEnumerate := nil;
  end;
end;

procedure TOptionsForm.BCloseClick(Sender: TObject);
begin
  Close;
end;

function GetProductVersion(const FileName: WideString): WideString;
var BufSize, cbSize, VerLen: Cardinal;
  VerOut: PWideChar; Buf: array of WideChar;
begin
  Result := '?';
  BufSize := Tnt_GetFileVersionInfoSizeW(PWideChar(FileName), cbSize);
  if BufSize = 0 then exit;
  SetLength(Buf, BufSize);
  if not Tnt_GetFileVersionInfoW(PWideChar(FileName), 0, BufSize, Buf) then exit;
  if not Tnt_VerQueryValueW(Buf, '\StringFileInfo\000004B0\ProductVersion', Pointer(VerOut), VerLen) then exit;
  Result := VerOut;
end;

function GetFileVersion(const FileName: WideString): WideString;
var BufSize, cbSize, VerLen: Cardinal;
  Info: ^VS_FIXEDFILEINFO; Buf: array of WideChar;
begin
  Result := '?';
  BufSize := Tnt_GetFileVersionInfoSizeW(PWideChar(FileName), cbSize);
  if BufSize = 0 then exit;
  SetLength(Buf, BufSize);
  if not Tnt_GetFileVersionInfoW(PWideChar(FileName), 0, BufSize, Buf) then exit;
  if not Tnt_VerQueryValueW(Buf, '\', Pointer(Info), VerLen) then exit;
  Result := IntToStr(Info.dwFileVersionMS shr 16) + '.' +
    IntToStr(Info.dwFileVersionMS and $FFFF) + '.' +
    IntToStr(Info.dwFileVersionLS shr 16) + ' build ' +
    IntToStr(Info.dwFileVersionLS and $FFFF);
  if (Info.dwFileFlags and VS_FF_DEBUG <> 0) then Result := Result + ' (debug)';
  if (Info.dwFileFlags and VS_FF_PRERELEASE <> 0) then Result := Result + ' (pre-release)';
end;

procedure TOptionsForm.Localize;
var i: integer;
begin
  with MainForm do begin
    MTitle.Caption := LOCstr_Title;
    LAspect.Caption := MAspects.Caption;
    CAspect.Items[0] := MAutoAspect.Caption;
    CAspect.Items[MAspects.Count - 1] := Copy(MCustomAspect.Caption, 1, Pos(' ', MCustomAspect.Caption)) + IntToStr(InterW) + ':' + IntToStr(InterH);

    LDeinterlace.Caption := MDeinterlace.Caption;
    CDeinterlace.Items[0] := MNoDeint.Caption;
    CDeinterlace.Items[1] := MSimpleDeint.Caption;
    CDeinterlace.Items[2] := MAdaptiveDeint.Caption;
    MPostproc.Caption := LPostproc.Caption;
    MPostOff.Caption := CPostproc.Items[0];
    MPostAuto.Caption := CPostproc.Items[1];
    MPostquality.Caption := CPostproc.Items[2];
    CAudioOut.Items[2] := LOCstr_AutoLocale;
    LLanguage.Caption := MLanguage.Caption;
    PlaylistForm.PLTC.Hint := LTCL.Caption;
    PlaylistForm.PLHC.Hint := LHCL.Caption;
    PlaylistForm.PLBC.Hint := LBCL.Caption;
    CLanguage.Clear;
    CLanguage.Items.Add(LOCstr_AutoLocale);
    for i := 0 to High(Locales) do
      CLanguage.Items.Add(Locales[i].Name);
  end;
end;

procedure TOptionsForm.FormShow(Sender: TObject);
begin
  LoadValues; TabChange(nil); Changed := false;
  if ML then HelpFile := WideExtractFileDir(MplayerLocation) + '\Mplayer.html'
  else HelpFile := HomeDir + 'Mplayer.html';
  if not WideFileExists(HelpFile) then begin
    HelpFile := WideExtractFileDir(HelpFile) + '\MPlayer.html';
    if not WideFileExists(HelpFile) then HelpFile := '';
  end;
  if length(HelpFile) > 0 then begin
    LHelp.Visible := true;
    HelpFile := #34 + HelpFile + #34;
  end
  else
    LHelp.Visible := false;
  if (left + width) >= (CurMonitor.Left + CurMonitor.Width) then left := CurMonitor.Left + CurMonitor.Width - width;
  if left < CurMonitor.Left then left := CurMonitor.Left; if top < CurMonitor.Top then top := CurMonitor.Top;
  if (top + height) >= (CurMonitor.Top + CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top) then
    top := CurMonitor.Top + CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top - height;
end;

procedure TOptionsForm.LHelpClick(Sender: TObject);
begin
  if length(HelpFile) > 0 then begin
    if Win32PlatformIsUnicode then
      ShellExecuteW(Handle, 'open', PWideChar(HelpFile), nil, nil, SW_SHOW)
    else ShellExecute(Handle, 'open', PAnsiChar(AnsiString(HelpFile)), nil, nil, SW_SHOW);
  end;
end;

procedure TOptionsForm.GetFass;
var i: integer;
begin
  if fass = '' then fass := DefaultFass;
  TFass.Items.CommaText := fass;
  for i := 0 to TFass.Count - 1 do begin
    TFass.Checked[i] := TFass.Items[i][1] <> '0';
    TFass.Items[i] := Trim(Tnt_WideLowerCase(copy(TFass.Items[i], 2, MaxInt)));
  end;
end;

procedure TOptionsForm.SetFass;
var i: integer;
begin
  fass := '';
  for i := 0 to TFass.Count - 1 do begin
    if TFass.Checked[i] then fass := fass + ',1' + TFass.Items[i]
    else fass := fass + ',0' + TFass.Items[i];
  end;
  delete(fass, 1, 1);
end;

procedure TOptionsForm.LoadValues;
begin
  Load(HomeDir + DefaultFileName, 1);
  CAudioOut.ItemIndex := AudioOut;
  CAudioDev.ItemIndex := AudioDev;
  Ldlod.Checked := dlod;
  Ldlod.Enabled:= Assigned(LyricShowForm);
  CIndex.Checked := ReIndex;
  CSoftVol.Checked := SoftVol;
  CRFScr.Checked := RFScr;
  CAddsfiles.Checked := Addsfiles;
  CLS.Checked := ADls;
  CDr.Checked := Dr;
  Double.Checked := dbbuf;
  CVolnorm.Checked := Volnorm;
  nfconf.Checked := nfc;
  nmsgm.Checked := nmsg;
  CSubcp.Text := subcode;
  oML := ML;
  EAV.Text:=avThread;
  CAV.Checked:=UAV; CAVClick(nil);
  RMplayer.Checked := ML;
  RCMplayer.Checked := not ML;
  EMplayerLocation.Enabled := ML;
  BMplayer.Enabled := ML;
  CWid.Checked := Wid;
  CDs.Checked := ds;
  CRS.Checked := RS;
  CSP.Checked := SP;
  CRP.Checked := RP;
  CTime.Checked := CT;
  EMplayerLocation.Text := MplayerLocation;
  CMAspect.Text := MAspect;
  CVideoOut.Text := VideoOut;
  CCh.ItemIndex := Ch;
  CRot.ItemIndex := Rot;
  CSPDIF.Checked := SPDIF;
  CFlip.Checked := Flip;
  CMir.Checked := Mirror;
  CEq2.Checked := Eq2;
  CYuy2.Checked := Yuy2;
  CVSync.Checked := vsync;
  CEq2.Enabled := not Dda;
  CYuy2.Enabled := CEq2.Enabled;
  LDeinterlace.Enabled := CEq2.Enabled;
  CDeinterlace.Enabled := CEq2.Enabled;
  CNi.Checked := ni;
  CNobps.Checked := nobps;
  CFilter.Checked := FilterDrop;
  CDnav.Checked := Dnav;
  CUni.Checked := Uni;
  CUtf.Checked := Utf;

  CWadsp.Checked := Wadsp;
  EWadsp.Enabled := Wadsp;
  BWadsp.Enabled := Wadsp;
  Cconfig.Enabled := Wadsp;
  Cconfig.Checked := sconfig;
  EWadsp.Text := WadspL;
  Clavf.Checked := lavf;
  CFd.Checked := Fd;
  CAsync.Checked := Async;
  EAsync.Enabled := Async;
  UAsync.Enabled := Async;
  EAsync.Text := AsyncV;
  CCache.Checked := Cache;
  ECache.Enabled := Cache;
  UCache.Enabled := Cache;
  ECache.Text := CacheV;
  CPriorityBoost.Checked := Pri;
  EParams.Text := Params;
  CAudioOutChange(nil);

  TFsize.Position := round(FSize * 10);
  TFol.Position := round(Fol * 10);
  TFB.Position := round(FB * 10);

  CAspect.Items[MainForm.MAspects.Count - 1] := Copy(MainForm.MCustomAspect.Caption, 1, Pos(' ', MainForm.MCustomAspect.Caption)) + IntToStr(InterW) + ':' + IntToStr(InterH);
  CAspect.ItemIndex := Aspect;
  CDeinterlace.ItemIndex := Deinterlace;
  CLanguage.ItemIndex := DefaultLocale + 1;
  CPostproc.ItemIndex := Postproc;
  EOsdfont.Text := osdfont;
  Esubfont.Text := subfont;
  PLTC.Color := LTextColor;
  PLBC.Color := LbgColor;
  PLHC.Color := LhgColor;
  BFont.Caption := LyricF;
  BFont.Font.Size:=LyricS;
  PTc.color := TextColor;
  PTc.Enabled := Ass;
  POc.color := OutColor;
  POc.Enabled := Ass;
  CAss.Checked := Ass;
  CEfont.Checked := Efont;
  CEfont.Enabled := Ass;
  SfontColor.Enabled := Ass;
  SOutline.Enabled := Ass;
  CISub.Checked := ISub;
  ESsf.Text := ShotDir;
  ELyric.Text := LyricDir;
  SOsdfont.Checked := uof;
  COsdfont.Enabled := uof;
  BOsdfont.Enabled := uof;
  EOsdfont.Enabled := uof;
  Cone.Checked := oneM;
  CGUI.Checked := GUI;
  Eseek.Text := IntToStr(seekLen);
  ads.Checked:= AutoDs;
  fontchange(EOsdfont); fontchange(ESubfont);
end;

procedure TOptionsForm.ApplyValues;
var s: string; ws: WideString; i,a: integer; f: real; b: boolean;
begin
  if AudioOut <> CAudioOut.ItemIndex then begin
    AudioOut := CAudioOut.ItemIndex; changed := true;
  end;

  if AudioDev <> CAudioDev.ItemIndex then begin
    AudioDev := CAudioDev.ItemIndex; changed := true;
  end;

  if Postproc <> CPostproc.ItemIndex then begin
    Postproc := CPostproc.ItemIndex; changed := true;
  end;

  if Aspect <> CAspect.ItemIndex then begin
    Aspect := CAspect.ItemIndex; changed := true;
  end;

  if Deinterlace <> CDeinterlace.ItemIndex then begin
    Deinterlace := CDeinterlace.ItemIndex; changed := true;
  end;

  if ReIndex <> CIndex.Checked then begin
    ReIndex := CIndex.Checked; changed := true;
  end;

  if SoftVol <> CSoftVol.Checked then begin
    SoftVol := CSoftVol.Checked; changed := true;
  end;

  MainForm.UpdateVolSlider;

  if Dr <> CDr.Checked then begin
    Dr := CDr.Checked; changed := true;
  end;

  if dbbuf <> double.Checked then begin
    dbbuf := double.Checked; changed := true;
  end;

  if Volnorm <> CVolnorm.Checked then begin
    Volnorm := CVolnorm.Checked; changed := true;
  end;

  if nfc <> nfconf.Checked then begin
    nfc := nfconf.Checked; changed := true;
  end;

  if nmsg <> nmsgm.Checked then begin
    nmsg := nmsgm.Checked; changed := true;
  end;

  if subcode <> CSubcp.Text then begin
    subcode := CSubcp.Text; changed := true;
    MainForm.SSD.Caption := subcode; MainForm.SSD.Checked := True;
  end;

  if uof <> SOsdfont.Checked then begin
    uof := SOsdfont.Checked; changed := true;
  end;

  if CheckSubfont(osdfont) <> CheckSubfont(EOsdfont.Text) then begin
    osdfont := EOsdfont.Text;
    if EOsdfont.Enabled then changed := true;
  end;

  if CheckSubfont(subfont) <> CheckSubfont(Esubfont.Text) then begin
    subfont := ESubfont.Text; changed := true;
  end;

  if oML <> ML then begin
    ML := oML; changed := true;
  end;

  if MplayerLocation <> EMplayerLocation.Text then begin
    MplayerLocation := EMplayerLocation.Text;
    if EMplayerLocation.Enabled then changed := true;
  end;

  s := Trim(CMAspect.Text);
  if MAspect <> s then begin
    MAspect := s; changed := true;
  end;

  s := Trim(CVideoOut.Text);
  if VideoOut <> s then begin
    VideoOut := s; changed := true;
  end;

  b := Trim(LowerCase(VideoOut)) = 'directx:noaccel';
  if Dda <> b then begin
    Dda := b; changed := true;
  end;

  if Ch <> CCh.ItemIndex then begin
    Ch := CCh.ItemIndex; changed := true;
  end;

  if Rot <> CRot.ItemIndex then begin
    Rot := CRot.ItemIndex; changed := true;
  end;

  if SPDIF <> CSPDIF.Checked then begin
    SPDIF := CSPDIF.Checked; changed := true;
  end;

  if Wid <> CWid.Checked then begin
    Wid := CWid.Checked; changed := true;
  end;

  if Flip <> CFlip.Checked then begin
    Flip := CFlip.Checked; changed := true;
  end;

  if Mirror <> CMir.Checked then begin
    Mirror := CMir.Checked; changed := true;
  end;

  if Eq2 <> CEq2.Checked then begin
    Eq2 := CEq2.Checked; changed := true;
  end;

  if Yuy2 <> CYuy2.Checked then begin
    Yuy2 := CYuy2.Checked; changed := true;
  end;

  if ni <> CNi.Checked then begin
    ni := CNi.Checked; changed := true;
  end;

  if nobps <> CNobps.Checked then begin
    nobps := CNobps.Checked; changed := true;
  end;

  if FilterDrop <> CFilter.Checked then begin
    FilterDrop := CFilter.Checked; changed := true;
  end;

  if Dnav <> CDnav.Checked then begin
    Dnav := CDnav.Checked; changed := true;
  end;

  if Uni <> CUni.Checked then begin
    Uni := CUni.Checked; changed := true;
  end;

  if Utf <> CUtf.Checked then begin
    Utf := CUtf.Checked; changed := true;
  end;

  f := TFsize.Position / 10;
  if FSize <> f then begin
    FSize := f; changed := true;
  end;

  f := TFol.Position / 10;
  if Fol <> f then begin
    Fol := f; changed := true;
  end;

  f := TFB.Position / 10;
  if FB <> f then begin
    FB := f; changed := true;
  end;

  if Wadsp <> CWadsp.Checked then begin
    Wadsp := CWadsp.Checked; changed := true;
  end;

  if WadspL <> EWadsp.Text then begin
    WadspL := EWadsp.Text;
    if EWadsp.Enabled then changed := true;
  end;

  if Cconfig.Checked <> sconfig then begin
    sconfig := Cconfig.Checked;
    if Cconfig.Enabled then changed := true;
  end;

  if lavf <> Clavf.Checked then begin
    lavf := Clavf.Checked; changed := true;
  end;

  if Fd <> CFd.Checked then begin
    Fd := CFd.Checked; changed := true;
  end;

  if Async <> CAsync.Checked then begin
    Async := CAsync.Checked; changed := true;
  end;

  if AsyncV <> EAsync.Text then begin
    AsyncV := EAsync.Text;
    if EAsync.Enabled then changed := true;
  end;

  if UAV <> CAV.Checked then begin
    UAV := CAV.Checked; changed := true;
  end;

  if AVThread <> EAV.Text then begin
    AVThread := EAV.Text;
    if CAV.Enabled then changed := true;
  end;

  if Cache <> CCache.Checked then begin
    Cache := CCache.Checked; changed := true;
  end;

  if CacheV <> ECache.Text then begin
    CacheV := ECache.Text;
    if ECache.Enabled then changed := true;
  end;

  if Pri <> CPriorityBoost.Checked then begin
    Pri := CPriorityBoost.Checked; changed := true;
  end;

  ws := Trim(EParams.Text);
  if Params <> ws then begin
    Params := ws; changed := true;
  end;

  i := ColorToRGB(PTc.color);
  if TextColor <> i then begin
    TextColor := i; changed := true;
  end;

  i := ColorToRGB(POc.color);
  if OutColor <> i then begin
    OutColor := i; changed := true;
  end;

  if Ass <> CAss.Checked then begin
    Ass := CAss.Checked; changed := true;
  end;

  if Efont <> CEfont.Checked then begin
    Efont := CEfont.Checked;
    if CEfont.Enabled then changed := true;
  end;

  if ISub <> CISub.Checked then begin
    ISub := CISub.Checked; changed := true;
  end;

  if GUI <> CGUI.Checked then begin
    GUI := CGUI.Checked; changed := true;
  end;

  if ShotDir <> ESsf.Text then begin
    ShotDir := ESsf.Text; changed := true;
  end;

  RFScr := CRFScr.Checked;
  with MainForm do begin
    if RFScr then begin
      OPanel.PopupMenu := nil; IPanel.PopupMenu := nil;
    end
    else begin
      OPanel.PopupMenu := MPopup; IPanel.PopupMenu := MPopup;
    end;
  end;

  if Running and (vsync <> CVSync.Checked) then begin
    if CVSync.Checked then SendCommand('set_property vsync 1')
    else SendCommand('set_property vsync 0');
  end;
  if DefaultLocale <> (CLanguage.ItemIndex - 1) then begin
    DefaultLocale := CLanguage.ItemIndex - 1;
    ActivateLocale(DefaultLocale);
  end;
  if WideDirectoryExists(ELyric.Text) then LyricDir := ELyric.Text;
  ds := CDs.Checked;
  RP := CRP.Checked;
  RS := CRS.Checked;
  SP := CSP.Checked;
  CT := CTime.Checked;
  if not (CT or Running) then MainForm.LTime.Caption := '';
  seekLen := StrToIntdef(Eseek.Text, 10);
  vsync := CVSync.Checked;
  oneM := Cone.Checked;

  if dlod <> Ldlod.Checked then begin
    if Ldlod.Checked then begin
      GDILyric.FontName := Bfont.Caption;
      if HaveLyric = 0 then exit;
      GDILyric.GetFontHeight;
      if MSecPos < Lyric.LyricTime[0].timecode then begin
        if LyricCount=0 then GDILyric.DisplayLyricD(Lyric.GetLyricString(0),'')
        else GDILyric.DisplayLyricD(Lyric.GetLyricString(0),Lyric.GetLyricString(1));
      end;
      if MSecPos > Lyric.LyricTime[LyricCount].timecode then begin
        if CurLyric mod 2 = 0 then GDILyric.DisplayLyricD(Lyric.GetLyricString(CurLyric),'')
        else GDILyric.DisplayLyricD(Lyric.GetLyricString(CurLyric-1),Lyric.GetLyricString(CurLyric));
      end;
      if (MSecPos >= Lyric.LyricTime[CurLyric].timecode) and (MSecPos <= Lyric.LyricTime[NextLyric].timecode) then begin
        if CurLyric mod 2 = 0 then begin
          if CurLyric = LyricCount then GDILyric.DisplayLyricD(Lyric.GetLyricString(CurLyric),'')
          else GDILyric.DisplayLyricD(Lyric.GetLyricString(CurLyric),Lyric.GetLyricString(NextLyric));
        end
        else begin
          if CurLyric = LyricCount then GDILyric.DisplayLyricD(Lyric.GetLyricString(CurLyric-1),Lyric.GetLyricString(CurLyric))
          else GDILyric.DisplayLyricD(Lyric.GetLyricString(NextLyric),Lyric.GetLyricString(CurLyric));
        end;
      end;
      if HaveLyric <> 0 then LyricShowForm.Show;
    end
    else
      LyricShowForm.Hide;
  end;
  dlod := Ldlod.Checked;
  LTextColor := ColorToRGB(PLTC.Color);
  LbgColor := ColorToRGB(PLBC.Color);
  LhgColor := ColorToRGB(PLHC.Color);
  PlaylistForm.PLTC.Color := LTextColor;
  PlaylistForm.PLBC.Color := LbgColor;
  PlaylistForm.PLHC.Color := LhgColor;
  if (LyricF <> Bfont.Caption) or (LyricS<> BFont.Font.Size) then begin
     LyricF := Bfont.Caption; LyricS := BFont.Font.Size;
     if Assigned(LyricShowForm) then GDILyric.SetFont(LyricF);
     PlaylistForm.CLyricF.Text:=LyricF; PlaylistForm.CLyricS.Text:=IntToStr(LyricS);
     Lyric.BitMap.Canvas.Font.Name := LyricF; Lyric.BitMap.Canvas.Font.Size := LyricS;
     Lyric.ItemHeight:= WideCanvasTextHeight(Lyric.BitMap.Canvas,'S') + 4;
     UpdatePW := True;
  end; 

  ADls:=CLS.Checked;
  AutoDs:=ads.Checked;
  Addsfiles := CAddsfiles.Checked;
  if PlaylistForm.Visible then PlaylistForm.TMLyricPaint(nil);
  MainForm.UpdateMenuCheck; SaveHotKey;
  Save(HomeDir + DefaultFileName, 2);
  for i := 0 to MainForm.SCodepage.Count - 3 do begin
    s:= MainForm.SCodepage.Items[i].Caption;
    a:=Pos('&',s);
    s:=Copy(s,1,a-1)+ Copy(s,a+1,MaxInt);
    if s=subcode then begin
      MainForm.SCodepage.Items[i].Checked:=True;
      Break;
    end
    else MainForm.SCodepage.Items[i].Checked:=false;
  end;
end;

procedure TOptionsForm.BApplyClick(Sender: TObject);
begin
  ApplyValues;
  if Changed then begin
    Changed := false;
    Restart;
  end;
  CLanguage.ItemIndex := DefaultLocale + 1;
  CAspect.ItemIndex := Aspect;
  CDeinterlace.ItemIndex := Deinterlace;
  CPostproc.ItemIndex := Postproc;
  CAudioOut.ItemIndex := AudioOut;
  CAudioDev.ItemIndex := AudioDev;
  CSubcp.Text := subcode;
  COsdfont.Text := osdfont;
  CSubfont.Text := subfont;
  EMplayerLocation.Text := MplayerLocation;
  CMAspect.Text := MAspect;
  CCh.ItemIndex := Ch;
  CRot.ItemIndex := Rot;
  ESsf.Text := ShotDir;
end;

procedure TOptionsForm.BSaveClick(Sender: TObject);
begin
  BApplyClick(nil);
  Config.Save(HomeDir + Config.DefaultFileName, 0);
end;

procedure TOptionsForm.BOKClick(Sender: TObject);
begin
  Close;
  ApplyValues;
  if Changed then Restart;
end;

function EnumFunc(lpGuid: PGUID; lpcstrDescription, lpcstrModule: PChar; lpContext: pointer): LongBool; stdcall;
begin
  TComboBox(lpContext^).Items.Add(lpcstrDescription);
  Result := True;
end;

procedure TOptionsForm.FormCreate(Sender: TObject);
var o: Integer;
  procedure initFontList;
  var i, j: integer; s: string; sn, sp, lsn: widestring; DefaultFont: TFont;
    reg: TTntRegistry; a: TTntStringList;
  begin
    DefaultFont := TFont.Create; DefaultFont.Handle := GetStockObject(DEFAULT_GUI_FONT);
    FontPaths := TTntStringList.Create; a := TTntStringList.Create;
    reg := TTntRegistry.Create; DefaultFontIndex := -1;
    DefaultFont.Name := Trim(Tnt_WideLowerCase(DefaultFont.Name));
    if Win32PlatformIsUnicode then s := '\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts'
    else s := '\SOFTWARE\Microsoft\Windows\CurrentVersion\Fonts';
    with reg do begin
      try
        RootKey := HKEY_LOCAL_MACHINE;
        if OpenKeyReadOnly(s) then begin
          GetValueNames(a); a.Sort;
          for i := 0 to a.Count - 1 do begin
            j := pos(' (TrueType)', a.Strings[i]);
            if j > 0 then begin
              sn := a.Strings[i]; sp := ReadString(sn);
              sn := Trim(copy(sn, 1, j));
              CSubfont.Items.Add(sn);
              FontPaths.Add(Trim(Tnt_WideLowerCase(sp)));
              lsn := Tnt_WideLowerCase(sn);
              if (lsn = DefaultFont.Name) or
                (Pos(DefaultFont.Name + ' & ', lsn) = 1) or
                (Pos(' & ' + DefaultFont.Name, lsn) > 1) then
                DefaultFontIndex := CSubfont.Items.Count - 1;
            end;
          end;
          CloseKey;
        end;
      finally
        Free; a.free;
      end;
    end;
    COsdfont.Items := CSubfont.Items;
    if subfont = '' then begin
      if DefaultFontIndex = -1 then subfont := 'Arial'
      else subfont := CSubfont.Items[DefaultFontIndex];
    end;
    if osdfont = '' then osdfont := subfont;
    if not WideFileExists(CheckSubfont(subfont)) then subfont := HomeDir + 'mplayer\subfont.ttf';
    if not WideFileExists(CheckSubfont(osdfont)) then osdfont := HomeDir + 'mplayer\subfont.ttf';
    if LyricF = '' then begin
      if DefaultFontIndex = -1 then LyricF := 'Tahoma'
      else LyricF := DefaultFont.Name;
    end;
    DefaultFont.Free;
  end;
begin
  OptionsFormHook := SetWindowsHookEx(WH_KEYBOARD, @KeyboardHook, 0, GetCurrentThreadID);
  initFontList; Ikey := false; LoadHotKey; GetFass;
  Tab.TabIndex := 0; History := TTntStringList.Create;
  if IsDsLoaded = 0 then LoadDsLibrary;
  if IsDsLoaded <> 0 then DirectSoundEnumerate(EnumFunc, @CAudioDev);

  CMAspect.Items.Add('Default'); CAspect.Items.Add('');
  for o := 1 to MainForm.MAspects.Count - 2 do begin
    CMAspect.Items.Add(MainForm.MAspects.Items[o].caption);
    CAspect.Items.Add(CMAspect.Items[o]);
  end;
  CAspect.Items.Add('');
  for o := 0 to MainForm.MPostproc.Count - 1 do
    CPostproc.Items.Add(MainForm.MPostproc.Items[o].caption);
  for o := 0 to MainForm.MDeinterlace.Count - 1 do
    CDeinterlace.Items.Add(MainForm.MDeinterlace.Items[o].caption);
{$IFDEF VER150}
  // some fixes for Delphi>=7 VCLs
  PTc.ParentBackground := False; POc.ParentBackground := False;
  PLogo.ParentBackground := False;
{$ENDIF}
end;

procedure TOptionsForm.CAudioOutChange(Sender: TObject);
var e: boolean;
begin
  e := (CAudioOut.ItemIndex = 4);
  LAudioDev.Enabled := e;
  CAudioDev.Enabled := e;
end;

procedure TOptionsForm.BSubfontClick(Sender: TObject);
var CurPath: WideString;
begin
  CurPath := WideGetCurrentDir;
  with MainForm.OpenDialog do begin
    Title := MainForm.MSubfont.Caption;
    Options := Options - [ofAllowMultiSelect] - [ofoldstyledialog];
    filter := FontFilter + '(*.ttf)|*.ttf|' + AnyFilter + '(*.*)|*.*';
    if Execute and (Trim(Tnt_WideLowerCase(ESubfont.Text)) <> Trim(Tnt_WideLowerCase(fileName))) then
      ESubfont.Text := fileName;
  end;
  WideSetCurrentDir(CurPath);
end;

procedure TOptionsForm.BOsdfontClick(Sender: TObject);
var CurPath: WideString;
begin
  CurPath := WideGetCurrentDir;
  with MainForm.OpenDialog do begin
    Title := FontTitle;
    Options := Options - [ofAllowMultiSelect] - [ofoldstyledialog];
    filter := FontFilter + '(*.ttf)|*.ttf|' + AnyFilter + '(*.*)|*.*';
    if Execute and (Trim(Tnt_WideLowerCase(EOsdfont.Text)) <> Trim(Tnt_WideLowerCase(fileName))) then
      EOsdfont.Text := fileName;
  end;
  WideSetCurrentDir(CurPath);
end;

procedure TOptionsForm.BMplayerClick(Sender: TObject);
begin
  with MainForm.OpenDialog do begin
    Title := RMplayer.Caption;
    Options := Options - [ofAllowMultiSelect] - [ofoldstyledialog];
    filter := '*.exe|*.exe|' + AnyFilter + '(*.*)|*.*';
    if Execute then EMplayerLocation.Text := fileName;
  end;
end;

procedure TOptionsForm.CDDXAClick(Sender: TObject);
begin
  CEq2.Enabled := Trim(LowerCase(CVideoOut.Text)) <> 'directx:noaccel';
  LDeinterlace.Enabled := CEq2.Enabled;
  CDeinterlace.Enabled := CEq2.Enabled;
  CYuy2.Enabled := CEq2.Enabled;
end;

procedure TOptionsForm.TFsizeChange(Sender: TObject);
begin
  SFsP.Caption := Tnt_WideFormat('%.1f%%', [TFsize.Position / 10]);
end;

procedure TOptionsForm.TFolChange(Sender: TObject);
begin
  SFo.Caption := Tnt_WideFormat('%.1f', [TFol.Position / 10]);
end;

procedure TOptionsForm.TFBChange(Sender: TObject);
begin
  SFBl.Caption := Tnt_WideFormat('%.1f', [TFB.Position / 10]);
end;

procedure TOptionsForm.CWadspClick(Sender: TObject);
begin
  EWadsp.Enabled := CWadsp.Checked;
  BWadsp.Enabled := CWadsp.Checked;
  Cconfig.Enabled := CWadsp.Checked;
end;

procedure TOptionsForm.BWadspClick(Sender: TObject);
begin
  with MainForm.OpenDialog do begin
    Title := CWadsp.Caption;
    Options := Options - [ofAllowMultiSelect] - [ofoldstyledialog];
    filter := '*.dll|*.Dll|' + AnyFilter + '(*.*)|*.*';
    if Execute then EWadsp.Text := fileName;
  end;
end;

procedure TOptionsForm.RMplayerClick(Sender: TObject);
begin
  if oML <> RMplayer.Checked then begin
    oML := RMplayer.Checked;
    EMplayerLocation.Enabled := oML;
    BMplayer.Enabled := oML;
  end;
end;

procedure TOptionsForm.RCMplayerClick(Sender: TObject);
begin
  if oML = RCMplayer.Checked then begin
    oML := not RCMplayer.Checked;
    EMplayerLocation.Enabled := oML;
    BMplayer.Enabled := oML;
  end;
end;

procedure TOptionsForm.CAsyncClick(Sender: TObject);
begin
  EAsync.Enabled := CAsync.Checked;
  UAsync.Enabled := CAsync.Checked;
end;

procedure TOptionsForm.CCacheClick(Sender: TObject);
begin
  ECache.Enabled := CCache.Checked;
  UCache.Enabled := CCache.Checked;
end;

procedure TOptionsForm.FontChange(Sender: TObject);
var i: integer; s, k, h, j: WideString;
begin
  s := Trim(Tnt_WideLowerCase((Sender as TTntEdit).Text));
  if Sender = Esubfont then Sender := CSubfont
  else Sender := COsdfont;
  for i := FontPaths.Count - 1 downto 0 do begin
    k := Tnt_WideLowerCase((Sender as TTntComboBox).Items[i]);
    h := FontPaths[i]; j := ExpandName(SystemDir + 'fonts\', FontPaths[i]);
    if (s = k) or (s = h) or (s = j) then begin
      if Sender = CSubfont then begin
        Esubfont.Font.Name := (Sender as TTntComboBox).Items[i];
        if (s = h) or (s = j) then Esubfont.Text := (Sender as TTntComboBox).Items[i];
      end
      else begin
        Eosdfont.Font.Name := (Sender as TTntComboBox).Items[i];
        if (s = h) or (s = j) then Eosdfont.Text := (Sender as TTntComboBox).Items[i];
      end;
      break;
    end;
  end;
  if i = -1 then begin
    if Sender = CSubfont then Esubfont.Font.Name := 'Tahoma'
    else Eosdfont.Font.Name := 'Tahoma';
  end;
  (Sender as TTntComboBox).ItemIndex := i;
  Eosdfont.Height := Cosdfont.Height; Esubfont.Height := CSubfont.Height;
end;

procedure TOptionsForm.SetColor(Sender: TObject);
begin
  ColorDialog1.Color := (Sender as TPanel).Color;
  if ColorDialog1.Execute then (Sender as TPanel).Color := ColorDialog1.Color;
end;

procedure TOptionsForm.CAssClick(Sender: TObject);
begin
  PTc.Enabled := CAss.Checked; POc.Enabled := CAss.Checked;
  CEfont.Enabled := CAss.Checked; SfontColor.Enabled := CAss.Checked;
  SOutline.Enabled := CAss.Checked;
end;

procedure TOptionsForm.SOsdfontClick(Sender: TObject);
begin
  COsdfont.Enabled := SOsdfont.Checked;
  BOsdfont.Enabled := SOsdfont.Checked;
  EOsdfont.Enabled := SOsdfont.Checked;
end;

procedure TOptionsForm.BSsfClick(Sender: TObject);
var s: widestring;
begin
  if WideSelectDirectory(AddDirCp, '', s) then begin
    case (Sender as TComponent).Tag of
      0: ESsf.Text := s;
      1: ELyric.Text := s;
    end;
  end;
end;

procedure TOptionsForm.BFontClick(Sender: TObject);
begin
  FontDialog1.Font.Name := BFont.Caption;
  FontDialog1.Font.Size := BFont.Font.Size;
  if FontDialog1.Execute then begin
    BFont.Caption := FontDialog1.Font.Name;
    BFont.Font.Name := FontDialog1.Font.Name;
    BFont.Font.Size:= FontDialog1.Font.Size;
  end;
end;

procedure TOptionsForm.AddLine(const Line: Widestring);
begin
  TheLog.Lines.Add(Line);
  if Visible then TheLog.Perform(EM_LINESCROLL, 0, 32767);
end;

procedure TOptionsForm.CommandKeyPress(Sender: TObject; var Key: Char);
begin
  if not Running then exit;
  if Key = ^M then begin
    TheLog.Lines.Add(WideString('> ') + Command.Text);
    SendCommand(UTF8Encode(Tnt_WideLowerCase(Command.Text)));
    History.Add(Command.Text);
    HistoryPos := History.Count;
    Command.Text := '';
  end;
end;

procedure TOptionsForm.CommandKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_UP) and (HistoryPos > 0) then begin
    dec(HistoryPos);
    Command.Text := History[HistoryPos];
    Command.SelStart := MaxInt;
  end;
  if (Key = VK_DOWN) and (HistoryPos < History.Count) then begin
    inc(HistoryPos);
    if HistoryPos >= History.Count then Command.Text := ''
    else Command.Text := History[HistoryPos];
    Command.SelStart := MaxInt;
  end;
end;

procedure TOptionsForm.TabChange(Sender: TObject);
begin
  if Tab.ActivePage = TLog then begin
    Command.SetFocus; TheLog.Perform(EM_LINESCROLL, 0, 32767); end
  else if Tab.ActivePage = TAbout then begin
    if ML then VersionMPlayer.Caption := GetProductVersion(MplayerLocation)
    else VersionMPlayer.Caption := GetProductVersion(HomeDir + 'mplayer.exe');
    VersionMPUI.Caption := GetFileVersion(WideParamStr(0));
  end
  else if Tab.ActivePage = THelp then begin
    if IKey then begin
      HK.Items[sIndex].Caption := tCap; IKey := false; end;
  end;
end;

procedure TOptionsForm.TFaddClick(Sender: TObject);
var p: integer;
begin
  TEAss.Text := Trim(TEAss.Text);
  if TEAss.Text = '' then exit;
  p := pos('.', TEAss.Text);
  while p > 0 do begin
    if length(TEAss.Text) > 1 then TEAss.Text := copy(TEAss.Text, p + 1, MaxInt)
    else exit;
    p := pos('.', TEAss.Text);
  end;
  TFass.Items.Add(TEAss.Text);
  TEAss.Text := '';
end;

procedure TOptionsForm.TFdelClick(Sender: TObject);
begin
  if TFass.ItemIndex <> -1 then TFass.Items.Delete(TFass.ItemIndex);
end;

procedure TOptionsForm.TBaClick(Sender: TObject);
var i: integer;
begin
  if TFass.Count < 1 then exit;
  for i := 0 to TFass.Count - 1 do TFass.Checked[i] := true;
end;

procedure TOptionsForm.TBnClick(Sender: TObject);
var i: integer;
begin
  if TFass.Count < 1 then exit;
  for i := 0 to TFass.Count - 1 do TFass.Checked[i] := false;
end;

procedure Tass.Execute;
begin
  OptionsForm.SetFass; Save(HomeDir + DefaultFileName, 4);
  if Win32PlatformIsVista and (not IsAdmin()) then
    ShellExecuteW(Handle, 'runas', PWChar(WideParamStr(0)), '/adminoption 0', nil, SW_SHOWDEFAULT)
  else regAss();
end;

procedure TOptionsForm.TFSetClick(Sender: TObject);
var t:Tass;
begin
  t:=Tass.Create(True);
  t.FreeOnTerminate:=True;
  t.Resume;
end;

procedure regAss();
var s: TTntStringList; reg: TTntRegistry; i: integer;
  hr: HRESULT; AppName, ext, AppPath: widestring;
  AAR: IApplicationAssociationRegistration;
begin
  s := TTntStringList.Create;
  s.CommaText := FAss;
  if s.Count < 1 then begin
    s.Free; exit; end;
  reg := TTntRegistry.Create;
  hr := 1; AAR := nil; ext := ''; AppName := 'MPUI-hcb';
  AppPath := WideExpandFileName(WideParamStr(0));
  with reg do begin
    try
      if Win32PlatformIsVista then begin
        RootKey := HKEY_LOCAL_MACHINE;
        if OpenKey('\SOFTWARE\RegisteredApplications\', true) then
          WriteString(AppName, 'Software\Clients\Media\' + AppName + '\Capabilities');
        if OpenKey('\Software\Clients\Media\' + AppName + '\Capabilities', true) then begin
          WriteExpandString('ApplicationDescription', 'A Windows frontend for MPlayer');
          WriteExpandString('ApplicationName', AppName);
        end;
        hr := CoCreateInstance(CLSID_ApplicationAssociationRegistration, nil, CLSCTX_INPROC_SERVER, IID_IApplicationAssociationRegistration, AAR);
      end;

      for i := 0 to s.Count - 1 do begin
        ext := '.' + Tnt_WideLowerCase(copy(s.Strings[i], 2, MaxInt));
        if s.Strings[i][1] = '1' then begin
          RootKey := HKEY_CLASSES_ROOT;
          if OpenKey('\' + AppName + ext, true) then
            WriteString('', 'MPlayer file (' + ext + ')');
          if OpenKey('\' + AppName + ext + '\DefaultIcon', true) then
            WriteString('', AppPath + ',0');
          if OpenKey('\' + AppName + ext + '\shell\open\command', true) then
            WriteString('', '"' + AppPath + '" "%1"');
          if OpenKey('\' + ext, true) then
            WriteString('', AppName + ext);
          if Win32PlatformIsUnicode then begin
            RootKey := HKEY_CURRENT_USER;
            if OpenKey('\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\' + ext, true) then
              WriteString('Progid', AppName + ext);
            if OpenKey('\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\' + ext + '\UserChoice', true) then
              WriteString('Progid', 'Applications\MPUI.exe');

            if Win32PlatformIsVista then begin
              RootKey := HKEY_LOCAL_MACHINE;
              if OpenKey('\Software\Clients\Media\' + AppName + '\Capabilities\FileAssociations', true) then
                WriteString(ext, AppName + ext);
              if hr = S_OK then
                AAR.SetAppAsDefault(PWChar(AppName), PWChar(ext), AT_FILEEXTENSION);
            end;
          end;
        end
        else begin
          RootKey := HKEY_CLASSES_ROOT;
          DeleteKey('\' + AppName + ext);
          if Win32PlatformIsVista then begin
            RootKey := HKEY_LOCAL_MACHINE;
            if OpenKey('\Software\Clients\Media\' + AppName + '\Capabilities\FileAssociations', true) then
              DeleteValue(ext);
          end;
        end;
      end;
      CloseKey;
      SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_IDLIST, nil, nil);
    finally
      Free;
    end;
    s.Free;
  end;
end;

procedure HkToShiftKey(const Hk: integer; var Shift: TShiftState; var Key: Word);
begin
  Key := Hk and $FFFF;
  Shift := TShiftState(Byte((Hk and $FF0000) shr 16));
end;

function ShiftKeyToHk(const Shift: TShiftState; const Key: Word): integer;
begin
  Result := (Byte(Shift) shl 16) + Key;
end;

function ShiftToStr(const Shift: TShiftState): string;
begin
  Result := '';
  if ssCtrl in Shift then Result := 'Ctrl + ';
  if ssShift in Shift then Result := Result + 'Shift + ';
  if ssAlt in Shift then Result := Result + 'Alt + ';
end;

function KeyToStr(const Key: Word): string;
var ScanCode: integer;
begin
  Result := '';
  ScanCode := MapVirtualKey(key, 0); //3 can't translate insert,home,pgup,pgdn,etc,so translate to scancode
  if key in [$21..$28, $2D, $2E, $5D] then ScanCode := ScanCode or $100;
  SetLength(Result, MAX_PATH - 1);
  GetKeyNameText(ScanCode shl 16, PChar(Result), MAX_PATH);
  Result := string(PChar(Result));
end;

procedure TOptionsForm.HKDblClick(Sender: TObject);
begin
  if IKey or (HK.ItemIndex < 0) then exit;
  sIndex := HK.ItemIndex; IKey := true;
  tCap := HK.Selected.Caption;
  HK.Selected.Caption := IKeyHint;
end;

procedure TOptionsForm.HKKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var t: TListItem; i: integer;
begin
  if IKey and (Key = VK_ESCAPE) then begin
    HK.Items[sIndex].Caption := tCap;
    Key := 0; IKey := false; exit;
  end;
  if Key in [$10..$12] then begin
    Key := 0; exit; end; //ctrl,shift,alt key
  i := ShiftKeyToHk(Shift, Key);
  if IKey then t := HK.FindData(sIndex, Pointer(i), false, true)
  else t := HK.FindData(0, Pointer(i), true, false);
  if t <> nil then begin
    if IKey then begin
      IKey := false; HK.Items[sIndex].Caption := tCap;
      t.Selected := true; t.MakeVisible(false);
      if WideMessageDlg('"' + t.Caption + '" ' + IKeyerror + ' <' + t.SubItems.Strings[0] +'>'^M^J + IKeyerror1 , mtWarning, [mbYes, mbNo], 0) = mrYes then begin
        HK.Items[sIndex].Caption := ShiftToStr(Shift) + KeyToStr(Key);
        HK.Items[sIndex].Data := Pointer(i);
        t.Caption := ''; t.Data := nil;
      end;
      HK.Items[sIndex].Selected := true; HK.Items[sIndex].MakeVisible(false);
    end
    else begin
      t.Selected := true; t.MakeVisible(false);
    end;
  end
  else if IKey then begin
    IKey := false;
    HK.Items[sIndex].Caption := ShiftToStr(Shift) + KeyToStr(Key);
    HK.Items[sIndex].Data := Pointer(i);
  end;
  Key := 0; IKey := false;
end;

procedure TOptionsForm.HKClick(Sender: TObject);
begin
  if IKey then HK.ItemIndex := sIndex;
end;

function TOptionsForm.HotKeyToOldKey(var Shift: TShiftState; var Key: Word): TListItem;
begin
  Result := HK.FindData(0, Pointer(ShiftKeyToHk(Shift, Key)), true, false);
  if Result <> nil then HkToShiftKey(DefaultHotKey[Result.Index], Shift, Key);
end;

procedure TOptionsForm.FormDestroy(Sender: TObject);
begin
  UnhookWindowsHookEx(OptionsFormHook); History.Free;
end;

function KeyboardHook(nCode: Integer; wParam: WPARAM; lParam: LPARAM): LResult;
var Key: word;
begin
  if nCode > -1 then begin
    if (wParam in [9, 16..18]) and OptionsForm.IKey then begin
      if (wParam = 9) then begin
        key := 9; OptionsForm.HKKeyDown(OptionsForm.HK, key, ctrlkey); end;
      case wParam of
        17: ctrlkey := [ssctrl];
        16: ctrlkey := [ssshift];
        18: ctrlkey := [ssalt];
      else ctrlkey := []
      end;
      Result := 1;
    end
    else Result := 0;
  end
  else Result := CallNextHookEx(OptionsFormHook, nCode, wParam, lParam);
end;

procedure TOptionsForm.HKKeyPress(Sender: TObject; var Key: Char);
begin
  key := #0;
end;

procedure TOptionsForm.LoadHotKey;
var a: TStringList; i, h: integer; Key: Word; Shift: TShiftState;
begin
  if HKS = '' then HKS := DefaultHKS;
  a := TStringList.Create;
  a.CommaText := HKS;
  for i := 0 to HK.Items.Count - 1 do begin
    if (a.Count < HK.Items.Count) and (i < a.Count) then
      h := StrToIntDef(a.Strings[i], DefaultHotKey[i])
    else h := DefaultHotKey[i];
    if h < VK_BACK {8} then h := DefaultHotKey[i];
    if HK.FindData(0, Pointer(h), true, false) <> nil then h := DefaultHotKey[i];
    HkToShiftKey(h, Shift, Key);
    HK.Items[i].Data := Pointer(h);
    HK.Items[i].Caption := ShiftToStr(Shift) + KeyToStr(Key);
  end;
  a.Free;
end;

procedure TOptionsForm.SaveHotKey;
var a: TStringList; i: integer;
begin
  a := TStringList.Create;
  for i := 0 to HK.Items.Count - 1 do a.add(IntToStr(Integer(HK.Items[i].Data)));
  HKS := a.CommaText;
  a.Free;
end;

procedure TOptionsForm.RHKClick(Sender: TObject);
begin
  HKS := DefaultHKS; LoadHotKey;
end;

procedure TOptionsForm.LURLClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://sourceforge.net/projects/mpui-hcb', nil, nil, SW_SHOW);
end;

procedure TOptionsForm.CSubfontDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  if Index < 0 then exit;
  with CSubfont.Canvas do begin
    FillRect(Rect);
    Font.Name := CSubfont.Items[Index];
    Font.Size := 0; // use font's preferred size
    WideCanvasTextOut(CSubfont.Canvas, Rect.Left + 10, (Rect.Top + Rect.Bottom - WideCanvasTextHeight(CSubfont.Canvas, Cosdfont.Items[Index])) div 2, CSubfont.Items[Index]);
  end;
  Esubfont.Height := CSubfont.Height;
end;

procedure TOptionsForm.CSubfontMeasureItem(Control: TWinControl;
  Index: Integer; var Height: Integer);
begin
  if Index < 0 then exit;
  with CSubfont.Canvas do begin
    Font.Name := CSubfont.Items[Index];
    Font.Size := 0; // use font's preferred size
    Height := WideCanvasTextHeight(CSubfont.Canvas, CSubfont.Items[Index]) + 2;
  end;
end;

procedure TOptionsForm.CSubfontChange(Sender: TObject);
begin
  if (Sender as TTntComboBox).ItemIndex <> -1 then begin
    if sender = CSubfont then ESubfont.Text := CSubfont.Text
    else Eosdfont.Text := Cosdfont.Text;
  end;
  Eosdfont.Height := Cosdfont.Height; Esubfont.Height := CSubfont.Height;
end;

procedure TOptionsForm.CosdfontMeasureItem(Control: TWinControl;
  Index: Integer; var Height: Integer);
begin
  if Index < 0 then exit;
  with Cosdfont.Canvas do begin
    Font.Name := Cosdfont.Items[Index];
    Font.Size := 0; // use font's preferred size
    Height := WideCanvasTextHeight(CSubfont.Canvas, CSubfont.Items[Index]) + 2;
  end;
end;

procedure TOptionsForm.CosdfontDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  with Cosdfont.Canvas do begin
    FillRect(Rect);
    Font.Name := Cosdfont.Items[Index];
    Font.Size := 0; // use font's preferred size
    WideCanvasTextOut(Cosdfont.Canvas, Rect.Left + 10, (Rect.Top + Rect.Bottom - WideCanvasTextHeight(Cosdfont.Canvas, Cosdfont.Items[Index])) div 2, Cosdfont.Items[Index]);
  end;
  Eosdfont.Height := Cosdfont.Height;
end;

procedure TOptionsForm.CSubfontDropDown(Sender: TObject);
var i, MaxWidth: Integer;
begin
  MaxWidth := (Sender as TTntCombobox).Width;
  for i := 0 to (Sender as TTntCombobox).Items.Count - 1 do
    MaxWidth := Max(MaxWidth, 50 + WideCanvasTextWidth((Sender as TTntCombobox).Canvas, (Sender as TTntCombobox).Items[i]));
  (Sender as TTntCombobox).Perform(CB_SETDROPPEDWIDTH, MaxWidth, 0);
end;

procedure TOptionsForm.CAVClick(Sender: TObject);
begin
  EAV.Enabled:=CAV.Checked; UDAV.Enabled:=CAV.Checked;
end;

end.

