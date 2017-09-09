unit SettingsU;

interface

{$I Defines.inc}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  DSPack, DSUtil, DirectShow9, ComCtrls;

type
  TSettingsF = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    btnApply: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    cbxCameras: TComboBox;
    cbxFormats: TComboBox;
    cbxCodecs: TComboBox;
    chkPreview: TCheckBox;
    TabSheet2: TTabSheet;
    Label5: TLabel;
    txtServerPort: TEdit;
    chkServer: TCheckBox;
    TabSheet3: TTabSheet;
    Label4: TLabel;
    Label6: TLabel;
    txtClientHost: TEdit;
    txtClientPort: TEdit;
    btnConnect: TButton;
    btnDisconnect: TButton;
    lbFrames: TLabel;
    Label7: TLabel;
    lbFCC: TLabel;
    Label8: TLabel;
    lbClientError: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbxCamerasChange(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnDisconnectClick(Sender: TObject);
  private
    DevEnum: TSysDevEnum;
    VideoMediaTypes: TEnumMediaType;
  end;

var
  SettingsF: TSettingsF;

implementation

uses
  dmMainU, DisplayU, ActiveX, Preview, ClientDM;

{$R *.dfm}

function PinListForMoniker(Moniker: IMoniker): TPinList;
var
  BF: TBaseFilter;
  IBF: IBaseFilter;
begin
  BF := TBaseFilter.Create;
  try
    BF.Moniker := Moniker;
    IBF := BF.CreateFilter;
    Result := TPinList.Create(IBF);
  finally
    IBF := nil;
    BF.Free;
  end;
end;

procedure TSettingsF.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  PageControl1.ActivePageIndex := 0;

  DevEnum := TSysDevEnum.Create(CLSID_VideoInputDeviceCategory);
  VideoMediaTypes := TEnumMediaType.Create;

  for I := 0 to DevEnum.CountFilters - 1 do
    cbxCameras.Items.Add(DevEnum.Filters[I].FriendlyName);

  dmMain.VideoCoDec.EnumCodecs(cbxCodecs.Items);
end;

procedure TSettingsF.FormDestroy(Sender: TObject);
begin
  FreeAndNil(DevEnum);
  FreeAndNil(VideoMediaTypes);
end;

procedure TSettingsF.cbxCamerasChange(Sender: TObject);
var
  PinList: TPinList;
  I: Integer;
begin
    if cbxCameras.ItemIndex < 0 then
      Exit;

    DevEnum.SelectGUIDCategory(CLSID_VideoInputDeviceCategory);
    PinList := PinListForMoniker(DevEnum.GetMoniker(cbxCameras.ItemIndex));
    try
      cbxFormats.Clear;
      VideoMediaTypes.Assign(PinList.First);
      for I := 0 to VideoMediaTypes.Count - 1 do
        cbxFormats.Items.Add(VideoMediaTypes.MediaDescription[I]);
    finally
       PinList.Free;
    end;
end;

procedure TSettingsF.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TSettingsF.btnOKClick(Sender: TObject);
begin
  btnApply.Click;
  Close;
end;

procedure TSettingsF.btnApplyClick(Sender: TObject);
var
  PinList: TPinList;
  ok: Boolean;
  bmih: TBitmapInfoHeader;
  DefPort: Integer;
begin
  if (cbxCameras.ItemIndex > -1) and (cbxFormats.ItemIndex > -1) then begin
    with dmMain do begin
      if fgMain.Active then begin
        fgMain.Stop;
        fgMain.Active := False;
      end;

      dsfCam.BaseFilter.Moniker := DevEnum.GetMoniker(cbxCameras.ItemIndex);
      sgVideo.MediaType := VideoMediaTypes.Items[cbxFormats.ItemIndex];
      with VideoMediaTypes.Items[cbxFormats.ItemIndex].AMMediaType^ do
        case formattype.D1 of
          $05589F80: bmih := PVideoInfoHeader(pbFormat)^.bmiHeader;
          $F72A76A0: bmih := PVideoInfoHeader2(pbFormat)^.bmiHeader;
        end;

      if cbxCodecs.ItemIndex > -1 then
        bmih.biCompression := Cardinal(cbxCodecs.Items.Objects[cbxCodecs.ItemIndex]);
      UpdateVideoFormat(bmih);

      FrameHeight := bmih.biHeight;
      FrameWidth := bmih.biWidth;

      dsfCam.FilterGraph := fgMain;
      sgVideo.FilterGraph := fgMain;
      fgMain.Active := True;

      //PinList:=PinListForMoniker(DevEnum.GetMoniker(cbxCameras.ItemIndex));  // Erro!!!
      PinList := TPinList.Create(dmMain.dsfCam as IBaseFilter);
      try
        with (PinList.First as IAMStreamConfig) do
          ok := Succeeded(SetFormat(VideoMediaTypes.Items[cbxFormats.ItemIndex].AMMediaType^));
        if not ok then begin
          MessageBox(0, 'aaaaaa', nil, 0);
          Exit;
        end;
      finally
        PinList.Free;
      end;

      // Now render streams
      with fgMain as ICaptureGraphBuilder2 do
        try
          // render the grabber - must be here to get rendered at all
          RenderStream(@PIN_CATEGORY_CAPTURE, nil, dsfCam as IBaseFilter, nil, sgVideo as IBaseFilter);

          // Connect Video preview (VideoWindow)
          if chkPreview.Checked and (dsfCam.BaseFilter.DataLength > 0) then begin
            frmPreview.VideoWindow.FilterGraph := dmMain.fgMain;
            RenderStream(@PIN_CATEGORY_PREVIEW, nil, dsfCam as IBaseFilter,
              nil, frmPreview.VideoWindow as IBaseFilter);
            if not frmPreview.Visible then
              frmPreview.Show;
          end else begin
            frmPreview.VideoWindow.FilterGraph := nil;
            frmPreview.Hide;
          end;
        except
        end;

      fgMain.Play;

      DefPort := StrToIntDef(txtServerPort.Text, 33000);
      if dmMain.TCPServer.DefaultPort <> DefPort then
        dmMain.TCPServer.Active := False;
      dmMain.TCPServer.DefaultPort := StrToIntDef(txtServerPort.Text, 33000);
      dmMain.TCPServer.Active := chkServer.Checked;
    end;
  end else begin
    dmMain.TCPServer.Active := False;
  end;

  if dmMain.TCPServer.Active then
    DisplayF.lbServerSt.Caption := 'ON'
  else
    DisplayF.lbServerSt.Caption := 'OFF';
end;

procedure TSettingsF.btnConnectClick(Sender: TObject);
begin
  dmClient.TCPClient.Host := txtClientHost.Text;
  dmClient.TCPClient.Port := StrToIntDef(txtClientPort.Text, 33000);
  dmClient.TCPClient.Connect;
end;

procedure TSettingsF.btnDisconnectClick(Sender: TObject);
begin
  dmClient.TCPClient.Disconnect;
end;

end.
