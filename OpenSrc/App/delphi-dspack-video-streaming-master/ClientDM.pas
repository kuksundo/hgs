unit ClientDM;

interface

uses
  Windows, SysUtils, Classes, ExtCtrls, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient,
  VideoCoDec, CommonU;

type
  TdmClient = class(TDataModule)
    TCPClient: TIdTCPClient;
    tmrDisplay: TTimer;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure TCPClientConnected(Sender: TObject);
    procedure TCPClientDisconnected(Sender: TObject);
    procedure tmrDisplayTimer(Sender: TObject);
  private
    VideoCoDec: TVideoCoDec;
    FFrames, FKeyFrames: Cardinal;
    procedure UpdateVideoFormat(InputFormat: TBitmapInfoHeader);
  end;

var
  dmClient: TdmClient;

implementation

uses SettingsU, DisplayU;

{$R *.dfm}

procedure TdmClient.DataModuleCreate(Sender: TObject);
begin
  VideoCoDec := TVideoCoDec.Create;
end;

procedure TdmClient.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(VideoCoDec);
end;

procedure TdmClient.TCPClientConnected(Sender: TObject);
var
  bmih: TBitmapInfoHeader;
  CH: TCommHeader;
begin
  FFrames := 0;
  FKeyFrames := 0;
  SettingsF.btnConnect.Enabled := False;
  SettingsF.btnDisconnect.Enabled := True;
  ZeroMemory(@CH, SizeOf(CH));
  CH.DPType := 1;  // request for frame format
  TCPClient.WriteBuffer(CH, SizeOf(CH), True);
  TCPClient.ReadBuffer(CH, SizeOf(CH));
  if CH.DPType <> 1 then
    Exit;  // not the right packet
  if CH.DPSize <> SizeOf(bmih) then
    Exit;  // not what we expected
  // Read the format
  TCPClient.ReadBuffer(bmih, SizeOf(bmih));
  // Update the format
  UpdateVideoFormat(bmih);
  tmrDisplay.Interval := 1000 div CH.DPExtra;
  tmrDisplay.Enabled := True;

  DisplayF.lbClientSt.Caption := 'CONNECTED';
end;

procedure TdmClient.TCPClientDisconnected(Sender: TObject);
begin
  tmrDisplay.Enabled := False;
  SettingsF.btnConnect.Enabled := True;
  SettingsF.btnDisconnect.Enabled := False;

  DisplayF.lbClientSt.Caption := 'DISCONNECTED';
end;

procedure TdmClient.UpdateVideoFormat(InputFormat: TBitmapInfoHeader);
var
  bmihOut: TBitmapInfoHeader;
  FrameRate: Integer;
  FCC: TFourCC;
begin
  FCC.AsCardinal := InputFormat.biCompression;
  SettingsF.lbFCC.Caption := FCC.AsString;
  bmihOut := InputFormat;
  FrameRate := 30;
  InputFormat.biCompression :=0;  // rgb - used to decompress
  InputFormat.biBitCount := 24;   // decompress to 24 bit rgb
  VideoCoDec.Finish;
  VideoCoDec.Init(InputFormat, bmihOut, 100, 10);
  VideoCoDec.SetDataRate(1024, 1000 * 1000 div FrameRate, 1);
  if not VideoCoDec.StartDeCompressor then
    SettingsF.lbClientError.Caption := TranslateICError(VideoCoDec.LastError);
  DisplayF.ClientHeight := InputFormat.biHeight +
    DisplayF.Panel1.Height + DisplayF.Panel2.Height;
  DisplayF.ClientWidth  := InputFormat.biWidth;
end;

procedure TdmClient.tmrDisplayTimer(Sender: TObject);
var
  CH: TCommHeader;
  Data: PByte;
begin
  if not VideoCoDec.DecompressorStarted then
    Exit;

  ZeroMemory(@CH, SizeOf(CH));
  CH.DPType := 2; // request the frame
  TCPClient.WriteBuffer(CH, SizeOf(CH), True);

  // Read the frame
  TCPClient.ReadBuffer(CH, SizeOf(CH));

  if CH.DPType <> 2 then
    Exit; // not a frame packet
  if CH.DPSize < 1 then
    Exit;

  GetMem(Data, CH.DPSize);
  try
    TCPClient.ReadBuffer(Data^, CH.DPSize);
    if VideoCoDec.UnpackBitmap(Data, Boolean(CH.DPCode), DisplayF.imgDisplay.Picture.Bitmap) then begin
      Inc(FFrames);
      Inc(FKeyFrames, CH.DPCode);
      DisplayF.imgDisplay.Repaint;
      SettingsF.lbFrames.Caption := Format('Frames: %d (%d kf)', [FFrames, FKeyFrames]);
      SettingsF.Update;
    end;
  finally
    FreeMem(Data);
  end;
end;

end.
