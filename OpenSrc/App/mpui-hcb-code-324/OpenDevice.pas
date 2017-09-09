unit OpenDevice;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, TntForms, Controls, StdCtrls,
  Buttons, ExtCtrls, TntStdCtrls, ActiveX, ComCtrls, TntComCtrls,TntSysUtils,
  Dialogs, TntClasses;
type
    TOpenDevicesForm = class(TTntForm)
    CVideoDevices: TTntComboBox;
    CAudioDevices: TTntComboBox;
    CCountryCode: TTntComboBox;
    LVideoDevices: TTntStaticText;
    LCountryCode: TTntStaticText;
    LAudioDevices: TTntStaticText;
    HK: TTntListView;
    TScan: TTntButton;
    TView: TTntButton;
    TClear: TTntButton;
    TLoad: TTntButton;
    TStop: TTntButton;
    TSave: TTntButton;
    TPrev: TTntButton;
    TNext: TTntButton;
    TOpen: TTntButton;
    procedure FormShow(Sender: TObject);
    procedure TOpenClick(Sender: TObject);
    procedure TViewClick(Sender: TObject);
    procedure TStopClick(Sender: TObject);
    procedure TLoadClick(Sender: TObject);
    procedure TPrevClick(Sender: TObject);
    procedure TSaveClick(Sender: TObject);
    procedure TClearClick(Sender: TObject);
    procedure TScanClick(Sender: TObject);
    procedure TntFormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  ICreateDevEnum = interface(IUnknown)
    ['{29840822-5B84-11D0-BD3B-00A0C911CE86}']
    (*** ICreateDevEnum methods ***)
    function CreateClassEnumerator(const clsidDeviceClass: TGUID;
        out ppEnumMoniker: IEnumMoniker; dwFlags: DWORD): HResult; stdcall;
  end;

var
  OpenDevicesForm: TOpenDevicesForm; SysDevEnum:ICreateDevEnum; EnumCat:IEnumMoniker;
  Moniker:IMoniker; cFetched:Longint; PropBag:IPropertyBag; varName:oleVariant;

const  IID_IPropertyBag:TGUID='{55272A00-42CB-11CE-8135-00AA004BB851}';
       IID_ICreateDevEnum:TGUID='{29840822-5B84-11D0-BD3B-00A0C911CE86}';
       CLSID_SystemDeviceEnum:TGUID='{62BE5D10-60EB-11D0-BD3B-00A0C911CE86}';
       CLSID_VideoInputDeviceCategory:TGUID='{860BB310-5D01-11D0-BD3B-00A0C911CE86}';
       CLSID_AudioInputDeviceCategory:TGUID='{33D9A762-90C8-11D0-BD43-00A0C911CE86}';
                                                                                  
implementation

uses main, plist, Core;

{$R *.dfm}
procedure CreateDevEnum;
var hr:HResult;
begin SysDevEnum:=nil;
  hr:=CoCreateInstance(CLSID_SystemDeviceEnum,nil,CLSCTX_INPROC_SERVER,IID_ICreateDevEnum,SysDevEnum);
  if Failed(hr) then exit;
  EnumCat:=nil;
  hr:=SysDevEnum.CreateClassEnumerator(CLSID_VideoInputDeviceCategory,EnumCat,0);
  if hr=S_OK then begin Moniker:=nil; cFetched:=0;
    while(EnumCat.Next(1,Moniker,@cFetched)=S_OK) do begin
      PropBag:=nil;
      hr:=Moniker.BindToStorage(nil,nil,IID_IPropertyBag,PropBag);
      if Succeeded(hr) then begin
        VariantInit(varName);
        hr:=PropBag.Read('FriendlyName',varName,nil);
        if Succeeded(hr) then opendevicesForm.CVideoDevices.items.add(varname);
        VariantClear(varName);
      end;
    end;
  end;
  EnumCat:=nil;
  hr:=SysDevEnum.CreateClassEnumerator(CLSID_AudioInputDeviceCategory,EnumCat,0);
  if hr=S_OK then begin Moniker:=nil; cFetched:=0;
    while(EnumCat.Next(1,Moniker,@cFetched)=S_OK) do begin
      PropBag:=nil;
      hr:=Moniker.BindToStorage(nil,nil,IID_IPropertyBag,PropBag);
      if Succeeded(hr) then begin
        VariantInit(varName);
        hr:=PropBag.Read('FriendlyName',varName,nil);
        if Succeeded(hr) then opendevicesForm.CAudioDevices.items.add(varname);
        VariantClear(varName);
       end;
    end;
  end;
end;

procedure TOpenDevicesForm.TSaveClick(Sender: TObject);
var FList: TStringList; i, h: integer; FN: WideString;
begin
  with playlistform.SaveDialog do begin
    Title := playlistform.BSave.Hint;
    Filter:='Channel list [UTF-8] (*.cl)|*.cl';
    if Execute then begin
      FList := TStringList.Create;
      if Tnt_WideLowerCase(WideExtractFileExt(FileName)) = '.cl' then
        for i := 0 to Hk.items.Count - 1 do
          FList.Add(UTF8Encode(HK.items[i].caption+'@'+HK.items[i].SubItems.Strings[0]));
      if not WideFileExists(FileName) then begin
        h := WideFileCreate(FileName);
        if GetLastError = 0 then FN := WideExtractShortPathName(FileName);
        if h < 0 then
          FN := WideExtractShortPathName(WideIncludeTrailingPathDelimiter(WideExtractFilePath(FileName))) + WideExtractFileName(FileName)
        else CloseHandle(h);
      end
      else begin
        if WideFileIsReadOnly(FileName) then WideFileSetReadOnly(FileName, false);
        FN := WideExtractShortPathName(FileName);
      end;
      FList.SaveToFile(FN);
      FList.Free;
      cl:=FN;
    end;
  end;
end;

procedure TOpenDevicesForm.TPrevClick(Sender: TObject);
var i:integer;
begin
  if (not Running) or (Pos('tv://', MediaURL) = 0) then TOpenClick(nil);
  if Status <> sPaused then MainForm.BPlayClick(nil);
  if HK.Items.Count = 0 then exit;
  i:=(Sender as TTntButton).tag;
  if (HK.ItemIndex<0) then HK.ItemIndex:=0;
  if (HK.ItemIndex=0) and (i=-1) then i:=0;
  if (HK.ItemIndex+i)> HK.Items.Count -1 then exit;
  SendCommand('tv_set_freq '+ HK.Items[HK.ItemIndex+i].SubItems.Strings[0]);
  HK.Items[HK.ItemIndex+i].Selected:=true;
end;

procedure TOpenDevicesForm.FormShow(Sender: TObject);
begin
  CVideoDevices.Clear; CAudioDevices.Clear; CreateDevEnum;
  if CVideoDevices.Items.Count>0 then CVideoDevices.ItemIndex:=0;
  if CAudioDevices.Items.Count>0 then CAudioDevices.ItemIndex:=0;
  TOpen.Enabled:=CVideoDevices.Items.Count>0;
  TScan.Enabled:=TOpen.Enabled;
  TStop.Enabled:=TOpen.Enabled;
  TView.Enabled:=TOpen.Enabled;
  TPrev.Enabled:=TOpen.Enabled;
  TNext.Enabled:=TOpen.Enabled;
  TClear.Enabled:=TOpen.Enabled;
  TLoad.Enabled:=TOpen.Enabled;
  TSave.Enabled:=TOpen.Enabled;
end;

procedure TOpenDevicesForm.TOpenClick(Sender: TObject);
var Entry:TPlaylistEntry; s,a,i:WideString;
begin
  if CVideoDevices.ItemIndex=-1 then exit;
  PClear := true; EndOpenDir:=true;
  if HK.Items.Count>0 then begin
    if (HK.ItemIndex<0) then HK.ItemIndex:=0;
    a:=':freq='+HK.Items[HK.ItemIndex].SubItems.Strings[0]
  end
  else a:='';
  with Entry do begin
    State:=psNotPlayed;
    if CCountryCode.Text='' then s:='us-bcast'
    else s:=CCountryCode.Text;
    if CVideoDevices.ItemIndex<0 then i:='0'
    else i:=IntToStr(CVideoDevices.ItemIndex);
    DisplayURL:='TV-'+i;
    FullURL:='tv:// -tv device='+i+':automute=100:';
    if CAudioDevices.ItemIndex<0 then i:='0'
    else i:=IntToStr(CAudioDevices.ItemIndex);
    FullURL:=FullURL+'adevice='+i+':chanlist='+s+a;
  end;
  Playlist.Add(Entry);
  Playlist.Changed;
end;

procedure TOpenDevicesForm.TViewClick(Sender: TObject);
begin
  if (not Running) or (Pos('tv://', MediaURL) = 0) then TOpenClick(nil);
  if Status <> sPaused then MainForm.BPlayClick(nil);
  SendCommand('tv_set_freq '+HK.Selected.SubItems.Strings[0]);
end;

procedure TOpenDevicesForm.TStopClick(Sender: TObject);
begin
  MainForm.BStopClick(nil);
end;

procedure TOpenDevicesForm.TLoadClick(Sender: TObject);
var NameList: TWStringList; i,a: integer; s:WideString;
begin
  with MainForm.OpenDialog do begin
    Title := MainForm.MOpenFile.Caption;
    Options := Options - [ofAllowMultiSelect] - [ofoldstyledialog];
    filter := 'Channel list [UTF-8] (*.cl)|*.cl';
    if Execute then begin
      NameList := TWStringList.Create;
      NameList.LoadFile(FileName, csutf8);
      if NameList.Count > 0 then begin
        HK.Items.Clear;
        for i := 0 to NameList.Count - 1 do begin
          s:=Trim(NameList[i]); a:= pos('@',s);
          with HK.Items.Add do begin
            Caption:=Copy(s, 1, a-1);
            SubItems.add(Copy(s, a+1,maxint));
          end;
        end;
      end;
      NameList.Free;
      cl:=FileName;
    end;
  end;
end;

procedure TOpenDevicesForm.TClearClick(Sender: TObject);
begin
  HK.Items.Clear;
end;

procedure TOpenDevicesForm.TScanClick(Sender: TObject);
begin
  if (not Running) or (Pos('tv://', MediaURL) = 0) then TOpenClick(nil);
  if Status <> sPaused then MainForm.BPlayClick(nil);
  HK.Items.Clear;
  SendCommand('tv_start_scan');
end;

procedure TOpenDevicesForm.TntFormCreate(Sender: TObject);
var NameList: TWStringList; i,a: integer; s,FileName:WideString;
begin
  FileName := HomeDir + 'MPUI.cl';
  if not WideFileExists(FileName) then
    FileName := cl;
  if not WideFileExists(FileName) then exit;
  NameList := TWStringList.Create;
  NameList.LoadFile(FileName, csutf8);
  if NameList.Count > 0 then begin
    HK.Items.Clear;
    for i := 0 to NameList.Count - 1 do begin
      s:=Trim(NameList[i]); a:= pos('@',s);
      with HK.Items.Add do begin
        Caption:=Copy(s, 1, a-1);
        SubItems.add(Copy(s, a+1,maxint));
      end;
    end;
  end;
  NameList.Free;
end;

end.
