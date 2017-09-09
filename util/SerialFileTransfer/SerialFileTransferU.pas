unit SerialFileTransferU;

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  EditBtn, ExtCtrls, ComCtrls,
  synaser, Mask, JvExMask, JvToolEdit;

const //error messages
  STRING_NOTIMPLEMENTED='Not implemented';
  STRING_INVALIDOUTPACKETDATA='Invalid out packet data';
  STRING_INVALIDINPACKETDATA='Invalid in packet data';
  STRING_UNEXPECTEDPACKETTYPE='Unexpected packet type';
  STRING_UNABLETOINIT='Unable to init';
  STRING_INVALIDBUFFERSIZE='Invalid buffer size';
  STRING_INVALIDFILEPOS='Invalid file position';
  STRING_FILETRANSFERABORTED='File transfer aborted';
  STRING_UNABLETOOPENFILE='Unable to open file';
  STRING_UNABLETOOPENDIR='Unable to open directory';
  STRING_UNABLETOCLOSEHANDLE='Unable to close handle';
  STRING_UNABLETOREADFILE='Unable to read file';
  STRING_UNABLETOREADDIR='Unable to read directory';
  STRING_UNABLETOWRITETOFILE='Unable to write to file';
  STRING_UNABLETODELETEFILE='Unable to delete file';
  STRING_UNABLETORENAMEFILE='Unable to rename file';
  STRING_UNABLETOCREATEDIR='Unable to create directory';
  STRING_UNABLETODELETEDIR='Unable to delete directory';
  STRING_UNABLETOSETFILEATTRIBUTES='Unable to set file attributes';
  STRING_INVALIDFILENAMECOUNT='Invalid file name count';
  STRING_RECEIVETIMEOUT='Receive timeout';
  STRING_UNEXPECTEDSSHMESSAGE='Unexpected SSH message';
  STRING_INVALIDCHANNELID='Invalid channel ID';
  STRING_INVALIDPROTOCOLVERSION='Invalid protocol version';
  STRING_UNABLETOSETPATH='Unable to set path';
  STRING_UNABLETOSETBUFFERSIZE='Unable to set buffer size';
  STRING_UNABLETOGETFILEATTRIBUTES='Unable to get file attributes';
  STRING_UNABLETOGETFILESIZE='Unable to get file size';
  STRING_UNABLETOGETFILETIMES='Unable to get file times';
  STRING_UNABLETOSETFILETIMES='Unable to set file times';
  STRING_UNABLETORECEIVEPACKETDATA='Unable to receive packet data';
  STRING_UNABLETOSENDPACKETDATA='Unable to receive packet data';
  STRING_UNKNOWNERROR='Unknown error';

type

  { TformSerial }

  TformSerial = class(TForm)
    btnConnect: TButton;
    comboClientServer: TComboBox;
    editDevice: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ScrollBox1: TScrollBox;
    StatusBar: TStatusBar;
    timerClientConnect: TTimer;
    timerServerConnect: TTimer;
    editFileName: TJvFilenameEdit;
    procedure btnConnectClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure timerClientConnectTimer(Sender: TObject);
    procedure timerServerConnectTimer(Sender: TObject);
  private
    { private declarations }
    connected: Boolean;
    ser: TBlockSerial;
    FBufferSize:DWORD;
    FBuffer:string;

    procedure ServerSendFile();
    procedure ClientReceiveFile();

    procedure DoError(ErrorMessage:string);
  public
    { public declarations }
  end;

var
  formSerial: TformSerial;

implementation

{$R *.dfm}

const
  INT_COMBO_SERVER = 0;
  INT_COMBO_CLIENT = 1;

  // Data records

  BYTE_REQUEST_CONNECTION = $00;
  // Followed by nothing else

  BYTE_ACCEPT_CONNECTION = $01;
  // Followed by nothing else

  BYTE_FILE_NAME = $02;
  // Followed by:
  // File name size - 1 Byte indicating the size sz_size. The name doesn't include path.
  // File name - sz_size bytes in UTF-8

  BYTE_FILE_DATA = $03;
  // Followed by:
  // File size - 8 Bytes, a Int64 in Little Endian, indicates sz_size
  // File data - sz_size bytes

{$R *.lfm}

{ TformSerial }

procedure TformSerial.FormCreate(Sender: TObject);
begin
  ser := TBlockSerial.Create;
  FBufferSize := 8;
end;

procedure TformSerial.btnConnectClick(Sender: TObject);
begin
  btnConnect.Enabled := False;

  try
    if connected then raise Exception.Create('Already connected');

    // Check the input data
    if (editDevice.Text = '') then raise Exception.Create('Invalid serial port name');

    if (editFileName.FileName = '') then raise Exception.Create('Invalid file path');

    if (comboClientServer.ItemIndex = INT_COMBO_SERVER)
      and (not FileExists(editFileName.FileName)) then raise Exception.Create('Invalid input file. It doesn''t exist');

    if (comboClientServer.ItemIndex = INT_COMBO_CLIENT)
      and (not DirectoryExists(editFileName.FileName)) then raise Exception.Create('Invalid output directory. It doesn''t exist');

    StatusBar.SimpleText := 'Connecting';
    Application.ProcessMessages;
    ser.Connect(editDevice.Text); //ComPort
    Sleep(1000);
    Application.ProcessMessages;
    ser.config(115000, 8, 'N', SB1, False, False);
    Sleep(1000);
    Application.ProcessMessages;

    StatusBar.SimpleText := 'Device: ' + ser.Device +
     ' Status: ' + ser.LastErrorDesc + ' ' +
     Inttostr(ser.LastError);

    if ser.LastError = 0 then connected := True;

    if comboClientServer.ItemIndex = INT_COMBO_SERVER then
      timerServerConnect.Enabled := True
    else
      timerClientConnect.Enabled := True;
  finally
    btnConnect.Enabled := True;
  end;
end;

procedure TformSerial.FormDestroy(Sender: TObject);
begin
  ser.free;
end;

procedure TformSerial.timerClientConnectTimer(Sender: TObject);
var
  Data: Byte;
begin
  Data := ser.RecvByte(timerClientConnect.Interval div 2);

  if (Data = BYTE_REQUEST_CONNECTION) and (ser.LastError = 0) then
  begin
    Connected := True;
    timerClientConnect.Enabled := False;
    ser.SendByte(BYTE_ACCEPT_CONNECTION);
    ClientReceiveFile();
  end;
end;

procedure TformSerial.timerServerConnectTimer(Sender: TObject);
var
  Data: Byte;
begin
  ser.SendByte(BYTE_REQUEST_CONNECTION);

  Data := ser.RecvByte(timerServerConnect.Interval div 2);

  if (Data = BYTE_ACCEPT_CONNECTION) and (ser.LastError = 0) then
  begin
    Connected := True;
    timerServerConnect.Enabled := False;
    ServerSendFile();
  end;
end;

procedure TformSerial.ServerSendFile();
var
  ShortStr: shortstring;
  Data, StrLen: Byte;
  i: Integer;
  lStream: TFileStream;
  lSize,SourceStartPos,TotalSize, SendSize: Int64;
  CurRead:Integer
begin
  StatusBar.SimpleText := 'Sending file';
  Application.ProcessMessages;

  // Send the file name:
  ShortStr := ExtractFileName(editFileName.Text);
  StrLen := Length(ShortStr);
  ser.SendByte(BYTE_FILE_NAME);
  ser.SendByte(StrLen);
  for i := 1 to StrLen do
    ser.SendByte(Byte(ShortStr[i]));

  if FBufferSize > 0 then
    SetLength(FBuffer,FBufferSize)
  else
  begin
    ShowMessage('Buffer size is 0!');
    exit;
  end;

  // Send the file data:
  lStream := TFileStream.Create(editFileName.Text, fmOpenRead or fmShareDenyNone);
  try
    SourceStartPos := 0;
    SendSize := 0;
    TotalSize := lStream.Size - SourceStartPos;
    lSize := Length(ShortStr);
    ser.SendByte(BYTE_FILE_DATA);
    ser.SendBuffer(@lSize, 8);

    lStream.Seek(SourceStartPos,soFromBeginning);

    if lStream.Position <> SourceStartPos then
      DoError(STRING_INVALIDFILEPOS+': '+editFileName.Text+' ('+IntToStr(SourceStartPos)+')');

    while SendSize < TotalSize do
    begin
      //read local file
      CurRead:=lStream.Read(Data,FBufferSize);
      if CurRead > 0 then //write remote file
      begin
        ser.SendByte(Data);
        SendSize := SendSize + CurRead;
      end;

      // Process messages each 100 bytes
      if (SendSize div 100) = 0 then Application.ProcessMessages();
    end;//while

{    for i := 0 to lSize - 1 do
    begin
      Data := lStream.Read();
      ser.SendByte(Data);
      // Process messages each 100 bytes
      if (i div 100) = 0 then Application.ProcessMessages();
    end;
}
  finally
    lStream.Free;
  end;
end;

procedure TformSerial.ClientReceiveFile();
var
  ShortStr: shortstring;
  Data, StrLen: Byte;
  i: Integer;
  lStream: TFileStream;
  lSize: Int64;
  filePath: string;
begin
  StatusBar.SimpleText := 'Receiving file';
  Application.ProcessMessages;

  // Read the file name:
  Data := ser.RecvByte(5000);
  // Process any remaining connect messages
  while (Data = BYTE_REQUEST_CONNECTION) do
    Data := ser.RecvByte(5000);
  if (Data <> BYTE_FILE_NAME) then raise Exception.Create('Expected record BYTE_FILE_SIZE, but received: ' + IntToStr(Data));
  StrLen := ser.RecvByte(5000);
  ShortStr := '';
  for i := 1 to StrLen do
    ShortStr := ShortStr + Char(ser.RecvByte(1000));
  editReceivedFileName.Text := ShortStr;

  // Read the file data:
  Data := ser.RecvByte(5000);
  if (Data <> BYTE_FILE_DATA) then raise Exception.Create('Expected record BYTE_FILE_DATA, but received: ' + IntToStr(Data));
  filePath := IncludeTrailingPathDelimiter(editFileName.Text) + editReceivedFileName.Text;
  lStream := TFileStream.Create(filePath, fmOpenWrite or fmCreate);
  try
    ser.RecvBuffer(@lSize, 8);
    for i := 0 to lSize - 1 do
    begin
      Data := ser.RecvByte(1000);
      lStream.WriteByte(Data);
      // Process messages each 100 bytes
      if (i div 100) = 0 then Application.ProcessMessages();
    end;
  finally
    lStream.Free;
  end;
end;

procedure TformSerial.DoError(ErrorMessage: string);
begin
  if Trim(ErrorMessage)='' then ErrorMessage:=STRING_UNKNOWNERROR;
  raise Exception.Create(ErrorMessage);
end;

end.

