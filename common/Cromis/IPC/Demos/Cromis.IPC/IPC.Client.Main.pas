unit IPC.Client.Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs, StdCtrls,

  // cromis units
  Cromis.Comm.Custom, Cromis.Comm.IPC, Cromis.Threading;

type
  TfMain = class(TForm)
    eServerName: TEdit;
    ListBox1: TListBox;
    btnSendSynchronous: TButton;
    eComputerName: TEdit;
    lbServerName: TLabel;
    lbComputerName: TLabel;
    btnSendASynchronous: TButton;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    procedure btnSendSynchronousClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSendASynchronousClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    FTaskPool: TTaskPool;
    procedure OnMessageComplete(const Msg: ITaskMessage);
    procedure OnAsynchronousIPCTask(const ATask: ITask);
    procedure OnSendFileIPCTask(const ATask: ITask);
  public
    { Public declarations }
  end;

var
  fMain: TfMain;

implementation

{$R *.dfm}

procedure TfMain.btnSendASynchronousClick(Sender: TObject);
var
  AsyncTask: ITask;
begin
  AsyncTask := FTaskPool.AcquireTask(OnAsynchronousIPCTask, 'AsyncTask');
  AsyncTask.Values.Ensure('ComputerName').AsString := eComputerName.Text;
  AsyncTask.Values.Ensure('ServerName').AsString := eServerName.Text;
  AsyncTask.Run;
end;

procedure TfMain.btnSendSynchronousClick(Sender: TObject);
var
  Result: IIPCData;
  Request: IIPCData;
  IPCClient: TIPCClient;
  TimeStamp: TDateTime;
  I: Integer;
begin
  IPCClient := TIPCClient.Create;
  try
    IPCClient.ComputerName := eComputerName.Text;
    IPCClient.ServerName := eServerName.Text;
    IPCClient.ConnectClient(cDefaultTimeout);
    try
      if IPCClient.IsConnected then
      begin
        for I := 0 to 9999 do
        begin
          Request := AcquireIPCData;
          Request.ID := DateTimeToStr(Now);
          Request.Data.WriteUTF8String('Command', 'Synchronous');
          Result := IPCClient.ExecuteConnectedRequest(Request);

          if IPCClient.AnswerValid then
          begin
            TimeStamp := Result.Data.ReadDateTime('TDateTime');
            ListBox1.Items.Add(Format('Synchronous Response with ID: %s', [Result.ID]));
            ListBox1.Items.Add(Format('Response: TDateTime [%s]', [DateTimeToStr(TimeStamp)]));
            ListBox1.Items.Add(Format('Response: Integer [%d]', [Result.Data.ReadInteger('Integer')]));
            ListBox1.Items.Add(Format('Response: Real [%f]', [Result.Data.ReadReal('Real')]));
            ListBox1.Items.Add(Format('Response: String [%s]', [Result.Data.ReadUTF8String('String')]));
            ListBox1.Items.Add('-----------------------------------------------------------');
          end;

          if IPCClient.LastError <> 0 then
            ListBox1.Items.Add(Format('Error: Code %d', [IPCClient.LastError]));
        end;
      end;
    finally
      IPCClient.DisconnectClient;
    end;
  finally
    IPCClient.Free;
  end;
end;

procedure TfMain.Button1Click(Sender: TObject);
var
  AsyncTask: ITask;
begin
  if OpenDialog1.Execute then
  begin
    AsyncTask := FTaskPool.AcquireTask(OnSendFileIPCTask, 'AsyncTask2');
    AsyncTask.Values.Ensure('ComputerName').AsString := eComputerName.Text;
    AsyncTask.Values.Ensure('ServerName').AsString := eServerName.Text;
    AsyncTask.Values.Ensure('FileName').AsString := OpenDialog1.FileName;
    AsyncTask.Run;
  end;
end;

procedure TfMain.FormCreate(Sender: TObject);
begin
  FTaskPool := TTaskPool.Create(5);
  FTaskPool.OnTaskMessage := OnMessageComplete;
  FTaskPool.Initialize;
end;

procedure TfMain.FormDestroy(Sender: TObject);
begin
  FTaskPool.Finalize;
  FTaskPool.Free;
end;

procedure TfMain.OnAsynchronousIPCTask(const ATask: ITask);
var
  Result: IIPCData;
  Request: IIPCData;
  IPCClient: TIPCClient;
  TimeStamp: TDateTime;
begin
  IPCClient := TIPCClient.Create;
  try
    IPCClient.ComputerName := ATask.Values.Get('ComputerName').AsString;
    IPCClient.ServerName := ATask.Values.Get('ServerName').AsString;

    Request := AcquireIPCData;
    Request.ID := DateTimeToStr(Now);
    Request.Data.WriteUTF8String('Command', 'ASynchronous');
    Result := IPCClient.ExecuteRequest(Request);

    if IPCClient.AnswerValid then
    begin
      ATask.Message.Ensure('ID').AsString := Result.ID;
      TimeStamp := Result.Data.ReadDateTime('TDateTime');
      ATask.Message.Ensure('TDateTime').AsString := DateTimeToStr(TimeStamp);
      ATask.Message.Ensure('Integer').AsInteger := Result.Data.ReadInteger('Integer');
      ATask.Message.Ensure('Real').AsFloat := Result.Data.ReadReal('Real');
      ATask.Message.Ensure('String').AsString := string(Result.Data.ReadUTF8String('String'));
      ATask.SendMessageAsync;
    end;
  finally
    IPCClient.Free;
  end;
end;

procedure TfMain.OnMessageComplete(const Msg: ITaskMessage);
begin
  ListBox1.Items.Add(Format('ASynchronous Response with ID: %s', [Msg.Values.Get('ID').AsString]));
  ListBox1.Items.Add(Format('Response: TDateTime [%s]', [Msg.Values.Get('TDateTime').AsString]));
  ListBox1.Items.Add(Format('Response: Integer [%d]', [Msg.Values.Get('Integer').AsInteger]));
  ListBox1.Items.Add(Format('Response: Real [%f]', [Msg.Values.Get('Real').AsFloat]));
  ListBox1.Items.Add(Format('Response: String [%s]', [Msg.Values.Get('String').AsString]));
  ListBox1.Items.Add('-----------------------------------------------------------');
end;

procedure TfMain.OnSendFileIPCTask(const ATask: ITask);
var
  Result: IIPCData;
  Request: IIPCData;
  IPCClient: TIPCClient;
  TimeStamp: TDateTime;
  LFileName: string;
  LFileStream: TFileStream;
begin
  IPCClient := TIPCClient.Create;
  try
    IPCClient.ComputerName := ATask.Values.Get('ComputerName').AsString;
    IPCClient.ServerName := ATask.Values.Get('ServerName').AsString;
    LFileName := ATask.Values.Get('FileName').AsString;

    Request := AcquireIPCData;
    Request.ID := DateTimeToStr(Now);
    Request.Data.WriteUTF8String('Command', 'SaveFile');
    Request.Data.WriteUnicodeString('FileName', ExtractFileName(LFileName));

    LFileStream := TFileStream.Create(LFileName, fmOpenRead);
    try
      Request.Data.WriteStream('File', LFileStream);
      Result := IPCClient.ExecuteRequest(Request);

      if IPCClient.AnswerValid then
      begin
        ATask.Message.Ensure('ID').AsString := Result.ID;
        TimeStamp := Result.Data.ReadDateTime('TDateTime');
        ATask.Message.Ensure('TDateTime').AsString := DateTimeToStr(TimeStamp);
        ATask.Message.Ensure('Integer').AsInteger := Result.Data.ReadInteger('Integer');
        ATask.Message.Ensure('Real').AsFloat := Result.Data.ReadReal('Real');
        ATask.Message.Ensure('String').AsString := string(Result.Data.ReadUTF8String('String'));
        ATask.SendMessageAsync;
      end;
    finally
      LFileStream.Free;
    end;
  finally
    IPCClient.Free;
  end;
end;

end.
