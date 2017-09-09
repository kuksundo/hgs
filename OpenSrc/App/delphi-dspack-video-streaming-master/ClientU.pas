unit ClientU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  VideoCoDec, CommonU;

type
  TClientF = class(TForm)
    TCPClient: TIdTCPClient;
    imgDisplay: TImage;
    tmrDisplay: TTimer;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    txtHost: TEdit;
    txtPort: TEdit;
    btnConnect: TButton;
    btnDisconnect: TButton;
    procedure TCPClientConnected(Sender: TObject);
    procedure TCPClientDisconnected(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnDisconnectClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tmrDisplayTimer(Sender: TObject);
  private
    VideoCoDec: TVideoCoDec;
    FFrames, FKeyFrames: Cardinal;
    procedure UpdateVideoFormat(InputFormat: TBitmapInfoHeader);
  end;

var
  ClientF: TClientF;

implementation

{$R *.dfm}

procedure TClientF.FormCreate(Sender: TObject);
begin
  VideoCoDec := TVideoCoDec.Create;
end;

procedure TClientF.FormDestroy(Sender: TObject);
begin
  FreeAndNil(VideoCoDec);
end;

procedure TClientF.TCPClientConnected(Sender: TObject);
var
  bmih: TBitmapInfoHeader;
  CH: TCommHeader;
begin
  FFrames := 0;
  FKeyFrames := 0;
  btnConnect.Enabled := False;
  btnDisconnect.Enabled := True;
  ZeroMemory(@CH, SizeOf(CH));
  CH.DPType := 1; // request for frame format
  TCPClient.WriteBuffer(CH, SizeOf(CH), True);
  TCPClient.ReadBuffer(CH, SizeOf(CH));
  if CH.DPType <> 1 then Exit; // not the right packet
  if CH.DPSize <> SizeOf(bmih) then Exit; // not what we expected
  // Read the format
  TCPClient.ReadBuffer(bmih, SizeOf(bmih));
  // Update the format
  UpdateVideoFormat(bmih);
  tmrDisplay.Interval := 1000 div CH.DPExtra;
  tmrDisplay.Enabled := True;
end;

procedure TClientF.TCPClientDisconnected(Sender: TObject);
begin
  tmrDisplay.Enabled := False;
  btnConnect.Enabled := True;
  btnDisconnect.Enabled := False;
end;

procedure TClientF.btnConnectClick(Sender: TObject);
begin
  TCPClient.Host := txtHost.Text;
  TCPClient.Port := StrToIntDef(txtPort.Text, 33000);
  TCPClient.Connect;
end;

procedure TClientF.btnDisconnectClick(Sender: TObject);
begin
  TCPClient.Disconnect;
end;

procedure TClientF.UpdateVideoFormat(InputFormat: TBitmapInfoHeader);
var
  bmihOut: TBitmapInfoHeader;
  FrameRate: Integer;
  FCC: TFourCC;
begin
  FCC.AsCardinal := InputFormat.biCompression;
  Caption := FCC.AsString;
  bmihOut := InputFormat;
  FrameRate := 30;
  InputFormat.biCompression :=0;  // rgb - used to decompress
  InputFormat.biBitCount := 24;   // decompress to 24 bit rgb
  VideoCoDec.Finish;
  VideoCoDec.Init(InputFormat, bmihOut, 100, 10);
  VideoCoDec.SetDataRate(1024, 1000 * 1000 div FrameRate, 1);
  if not VideoCoDec.StartDeCompressor then
    Caption := TranslateICError(VideoCoDec.LastError);
  imgDisplay.Height := InputFormat.biHeight;
  imgDisplay.Width  := InputFormat.biWidth;
end;

procedure TClientF.tmrDisplayTimer(Sender: TObject);
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
    if VideoCoDec.UnpackBitmap(Data, Boolean(CH.DPCode), imgDisplay.Picture.Bitmap) then begin
      Inc(FFrames);
      Inc(FKeyFrames, CH.DPCode);
      imgDisplay.Repaint;
      Caption := Format('Frames: %d (%d kf)', [FFrames, FKeyFrames]);
      Update;
    end;
  finally
    FreeMem(Data);
  end;
end;

end.
