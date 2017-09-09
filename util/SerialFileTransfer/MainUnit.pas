unit MainUnit;
//Serial File Transfer
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, SyncObjs,
  Dialogs, Menus, DragDrop, DropTarget, DragDropText, ExtCtrls,
  ComCtrls, JvExComCtrls, JvProgressBar, JvExControls, JvLED, SBPro, StdCtrls,
  JvExExtCtrls, JvSplitter, CPort, DeCAL, IPCThrd2, IPCThrdClient2, CommonUtil,
  Grids, iniFiles, SFTConst, Clipbrd, ZLibEx,
  MyKernelObject, ComPortThread, SFTConfig, ByteArray,CopyData,
  SFTConfigCollect, SFTStruct,
  FSMClass, FSMState, TimerPool, unitTMultiKlipboard,
  CPort_pjh;

type
  TSerialFileTransferF = class(TForm)
    Panel1: TPanel;
    Timer1: TTimer;
    Splitter1: TSplitter;
    ModBusRecvComMemo: TMemo;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    About1: TMenuItem;
    Label3: TLabel;
    Label4: TLabel;
    Button1: TButton;
    Button2: TButton;
    StatusBarPro1: TStatusBarPro;
    JvProgressBar1: TJvProgressBar;
    JvLED1: TJvLED;
    OpenDialog1: TOpenDialog;
    File1: TMenuItem;
    SendFile1: TMenuItem;
    N5: TMenuItem;
    Close1: TMenuItem;
    Button3: TButton;
    View1: TMenuItem;
    CurrentState1: TMenuItem;
    ResetState1: TMenuItem;
    N6: TMenuItem;
    Flush1: TMenuItem;
    DataFormatAdapterFile: TDataFormatAdapter;
    DataFormatAdapterURL: TDataFormatAdapter;
    DropTextTarget1: TDropTextTarget;
    Panel2: TPanel;
    ModBusSendComMemo: TMemo;
    lstviewData: TListView;
    JvSplitter1: TJvSplitter;
    popList: TPopupMenu;
    mnuItemInfo: TMenuItem;
    mnuItemSend: TMenuItem;
    MenuItem1: TMenuItem;
    mnuItemDelete: TMenuItem;
    SendtoCOMPort1: TMenuItem;
    N7: TMenuItem;
    JvSplitter2: TJvSplitter;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure WMReceiveByte( var Message: TMessage ); message WM_RECEIVEBYTE;
    procedure WMCopyData(var Msg: TMessage); message WM_COPYDATA;
    procedure WMFileSendComplete(var Msg: TMessage); message WM_FILESEND_COMPLETE;
    procedure WMFileRecvComplete(var Msg: TMessage); message WM_FILERECV_COMPLETE;
    procedure WMFileRecvCProgress(var Msg: TMessage); message WM_FILERECV_PROGRESS;
    procedure WMFileSendProgress(var Msg: TMessage); message WM_FILESEND_PROGRESS;
    procedure WMImageSendComplete(var Msg: TMessage); message WM_IMAGESEND_COMPLETE;
    procedure WMImageRecvComplete(var Msg: TMessage); message WM_IMAGERECV_COMPLETE;
    procedure WMRTFSendComplete(var Msg: TMessage); message WM_RTFSEND_COMPLETE;
    procedure WMRTFRecvComplete(var Msg: TMessage); message WM_RTFRECV_COMPLETE;

    procedure Timer1Timer(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure SendFile1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CurrentState1Click(Sender: TObject);
    procedure ResetState1Click(Sender: TObject);
    procedure Flush1Click(Sender: TObject);
    procedure DropTextTarget1Drop(Sender: TObject; ShiftState: TShiftState;
      APoint: TPoint; var Effect: Integer);
    procedure Button3Click(Sender: TObject);
    procedure mnuItemInfoClick(Sender: TObject);
    procedure mnuItemSendClick(Sender: TObject);
    procedure SendtoCOMPort1Click(Sender: TObject);
    procedure mnuItemDeleteClick(Sender: TObject);
  private
    FFirst: Boolean;//맨처음에 실행될때 True 그 다음부터는 False
    FFilePath: string;      //파일을 저장할 경로
    FRecvStrBuf: String;        //스트링형 데이터 수신값이 저장됨
    FComPort: TComPort_pjh;     //통신 포트
    FComPortStream: TComStream;
    FStoreType: TStoreType; //저장방식(ini or registry)
    FIPCClient: TIPCClient2;//공유 메모리 및 이벤트 객체
    //FEventHandle: TEvent;//Send한 후 Receive할때까지 Wait하는 Event

    FSFTCommThread: TComPortThread; //Thread 통신 객체
    FSFTBase: TSFTBase;
    FMultiKlipboard: TMultiKlipboard;
    FDataTypes: TSetDataType;
    FCriticalSection: TCriticalSection;

    procedure OnUpdateSB_FileReceiveComplete(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnReSendReqFile(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnSendFilesReq(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnSysClipChanged(newData: pMultiKlipboardDataItem);
    procedure DisplayList;
    procedure DisplayDataInfo(i: Byte);
    procedure DisplayDataInfo2(AData: Pointer; Asize: Integer);
    procedure DisplayDataInfo3(AStream: TStream);
    procedure DisplayDataInfo4(ABmp: TBitmap);
  public
    FRecvByteBuf: TByteArray2;//헥사유형의 데이터 수신값이 저장됨
    FRecvFileBuf: TByteArray2;//파일 데이터 수신값이 저장됨
    FSendCommandList: TList;//송신 명령 리스트
    FRecvCommandList: TList;//수신 명령 리스트
    FSendFileList: TStringList;//전송할 파일 리스트
    FSendFileName: string;
    FSendFileIndex: integer;//복수파일 전송시 현재 전송중인 파일 인덱스
    FSendTimerHandle: integer;//복수 파일 전송시 실행되는 타이머 핸들
    FSendFileOK: boolean;//복수파일 전송시 파일 전송중이면 False
    FReSendTimerHandle: integer;//재전송시 요청시 실행되는 타이머 핸들
    //현재 Comport에 Write한 FSendCommandList의 Index(0부터 시작함)
    FCurrentCommandIndex: integer;
    //일정시간 이상 통신에 대한 반응이 없으면 제어기 다운으로 간주(Wait 시간 설정)
    FCommFail: Boolean;
    FCommFailCount: integer; //통신 반응이 없이 FQueryInterval이 경과한 횟수
    FRecord : pTransferRecord ;
    FFSMClass: TFSMClass;
    FPJHTimerPool: TPJHTimerPool;
    FImageStream: TMemoryStream;
    FSendString: string;

    procedure InitVar;
    procedure InitState;
    procedure SetConfigData;
    procedure LoadConfigData2Form(AConfigForm: TSFTConfigF);
    procedure LoadFormData2Collect(AConfigForm: TSFTConfigF);

    procedure DisplayMessage(msg: string; IsSend: Boolean);
    procedure DisplayMessageSB(AMsg: string; AIndex: integer);

    procedure SetConfigComm;
    procedure InitComPort;
    procedure ProcessCommand;
    procedure FileSendCommandProcess;
    procedure ImageSendCommandProcess;
    procedure RTFSendCommandProcess;
    procedure SendCommand(ACommand: string);

    procedure RemoveClipBoardItem;

    function FileInfoSet(const FileName : String ) : Boolean ;
    function SendFileACK(var AFileName: string; var AFileSize: integer;
                                                var AAppend: boolean): integer;
    procedure SendFileReq(AFileName: string);
    procedure SendFileListReq;
    procedure SendImageReq(AItem: PMultiKlipboardDataItem);
    procedure SendRTFReq(AItem: PMultiKlipboardDataItem);
    procedure SendClipBoardReq;
    procedure AddCommandListItem(AList: TList; AMsg, AFileName: string;
                                         AFileSize: integer; AAppend: boolean);
    procedure DeleteCommandListItem(AList: TList; AIndex: integer);

  published
    property FilePath: string read FFilePath;
    property StrBuf: string read FRecvStrBuf write FRecvStrBuf;
  end;

var
  SerialFileTransferF: TSerialFileTransferF;

implementation

uses FileConfirm,
  // Note: In order to get the File and URL data format support linked into the
  // application, we have to include the appropiate units in the uses clause.
  // If you forget to do this, you will get a run time error.
  // The DragDropFile unit contains the TFileDataFormat class and the
  // DragDropInternet unit contains the TURLDataFormat class.
  DragDropFormats,
  DragDropInternet,
  DragDropFile,unitForm05,unitForm04;

{$R *.dfm}

function TSerialFileTransferF.FileInfoSet(const FileName: String): Boolean;
var
  SFileSize : Integer ;
begin
  Result:=False;

  if not fileExists(FileName) then
  begin
    SHowMessage('보내시려는 파일이 없습니다. 확인해 주십시오.');
    Exit;
  end;

  SFileSize := GetSizeOfFile(FileName);

  if SFileSize < 0 then SFileSize := TrunFileSize(FileName);

  if SFileSize = 0 then
  begin
    SHowMessage('보내시려는 파일의 싸이즈가 0 입니다. 확인해 주십시오.');
    Exit;
  end;

  AddCommandListItem(FSendCommandList, MSG_FILE_SEND_REQ, FileName, SFileSize, False);
  FSFTCommThread.FCurrentState := COMM_STATE(FFSMClass.StateTransition(Ord(csFile_Send_Req_Send)));

  Result:=True;
end;

procedure TSerialFileTransferF.FileSendCommandProcess;
var
  LP: pointer;
  Li: integer;
  LFileName: string;
  LFileSize: integer;
  LAppend: boolean;
begin
  FCriticalSection.Enter;

  LP := FRecvByteBuf.CStrFrom[0];

  try
    if TransferRecord(LP^).Msg = MSG_FILE_SEND_REQ then
    begin
      if FFSMClass.GetCurrentState <> Ord(csIdle) then
      begin
        DisplayMessageSB('Idle 상태가 아님!',3);
        exit;
      end;

      FSFTCommThread.FCurrentState :=
              COMM_STATE(FFSMClass.StateTransition(ord(csFile_Send_Req_Recv)));

      Li := SendFileACK(LFileName,LFileSize,LAppend);

      if Li = 3 then //취소..
      begin
        AddCommandListItem(FSendCommandList, MSG_FILE_SEND_NOACK, '', 0, False);
        FSFTCommThread.FCurrentState := COMM_STATE(FFSMClass.StateTransition(ord(csFile_Send_deny)));
      end
      else
      begin
        FSFTCommThread.FReceiveFileName := LFileName;//TransferRecord(LP^).FileName;
        FSFTCommThread.FFileSize := TransferRecord(LP^).FileSize;
        FComport.ClearBuffer(True,True);
        AddCommandListItem(FSendCommandList, MSG_FILE_SEND_ACK, LFileName,
                                            LFileSize, LAppend );
        FSFTCommThread.FCurrentState := COMM_STATE(FFSMClass.StateTransition(ord(csFile_Send_Ack)));
      end;

      FSFTCommThread.FIsCommandSend := True;
    end
    else if TransferRecord(LP^).Msg = MSG_FILE_RE_SEND_REQ then
    begin
      FSFTCommThread.FCurrentState := COMM_STATE(FFSMClass.StateTransition(ord(csFile_Send_Ack)));
      FSFTCommThread.FFileIndex := TransferRecord(LP^).FileSize;
      FSendFileName := TransferRecord(LP^).FileName;
      FSFTCommThread.FSendFileName := FSendFileName;
      FSFTCommThread.FIsFileSend := True;
    end
    else if TransferRecord(LP^).Msg = MSG_FILE_SEND_ACK then
    begin
      if FFSMClass.GetCurrentState <> Ord(csCommandSend) then
      begin
        DisplayMessageSB('Command Send 상태가 아님!',3);
        exit;
      end;

      FSFTCommThread.FCurrentState := COMM_STATE(FFSMClass.StateTransition(ord(csFile_Send_Ack)));
      FSFTCommThread.FFileIndex := 0;
      FSendFileName := TransferRecord(LP^).FileName;
      FSFTCommThread.FSendFileName := FSendFileName;
      FSFTCommThread.FIsFileSend := True;
    end
    else if TransferRecord(LP^).Msg = MSG_FILE_RECV_OK then
    begin
      if FFSMClass.GetCurrentState <> Ord(csFileSend) then
      begin
        DisplayMessageSB('File Send 상태가 아님!',3);
        exit;
      end;

      SendCommand(MSG_FILE_SEND_COMPLETE);
      FSFTCommThread.FCurrentState := COMM_STATE(FFSMClass.StateTransition(ord(csFile_Recv_OK)));
      FPJHTimerPool.AddOneShot(OnUpdateSB_FileReceiveComplete,2000);

      if (FSendFileList.Count - 1) <= FSendFileIndex then //모두 전송 후 전송 중지
      begin
        FPJHTimerPool.Remove(FSendTimerHandle);
      end
      else
      begin
        FSendFileIndex := FSendFileIndex + 1;//계속 전송
        FSendFileOK := True;
      end;
    end
    else if TransferRecord(LP^).Msg = MSG_FILE_SEND_COMPLETE then
    begin
      if FFSMClass.GetCurrentState <> Ord(csFileSend) then
      begin
        DisplayMessageSB('File Send 상태가 아님!',3);
        exit;
      end;

      FPJHTimerPool.AddOneShot(OnUpdateSB_FileReceiveComplete,2000);
      FSFTCommThread.FCurrentState := COMM_STATE(FFSMClass.StateTransition(ord(csFile_Recv_OK)));
    end
    else
      DisplayMessage('아무 상태도 아님',False);

  finally
    FRecvByteBuf.Clear;
    LFileName := GetStateName(COMM_STATE(FFSMClass.GetCurrentState));
    DisplayMessage(LFileName, False);
    FCriticalSection.Leave;
  end;
end;

procedure TSerialFileTransferF.Flush1Click(Sender: TObject);
begin
  FComport.ClearBuffer(True,True);
end;

procedure TSerialFileTransferF.FormCreate(Sender: TObject);
begin
  InitVar;
end;

procedure TSerialFileTransferF.FormDestroy(Sender: TObject);
var
  Li: integer;
begin

  if Assigned( FMultiKlipboard ) then FMultiKlipboard.StopHook;
  if Assigned( FMultiKlipboard ) then
  begin //  clear all data, and shutdown multiklipboard
    FMultiKlipboard.Clear;
    FreeAndNil(FMultiKlipboard);
  end;

  FImageStream.Free;
  FPJHTimerPool.Free;
  FFSMClass.Free;
  FSFTBase.Free;
  FComPortStream.Free;
  FComport.Free;

  FIPCClient.Free;

  for Li := FSendCommandList.Count - 1 downto 0 do
  begin
    DeleteCommandListItem(FSendCommandList, Li);
  end;
  FSendCommandList.Free;

  for Li := FRecvCommandList.Count - 1 downto 0 do
  begin
    DeleteCommandListItem(FRecvCommandList, Li);
  end;
  FRecvCommandList.Free;


  FSendFileList.Free;
  FRecvFileBuf.Free;
  FRecvByteBuf.Free;
  //FEventHandle.Free;
  if FSFTCommThread.Suspended then
    FSFTCommThread.Resume;

  FSFTCommThread.Terminate;
  FSFTCommThread.FEventHandle.Signal;

  FCriticalSection.Free;
  //FSFTCommThread.Free;
end;

procedure TSerialFileTransferF.ImageSendCommandProcess;
var
  LP: pointer;
  Li: integer;
  LFileName: string;
  LFileSize: integer;
  LAppend: boolean;
  di: TMultiKlipboardDataItem;
begin
  FCriticalSection.Enter;

  LP := FRecvByteBuf.CStrFrom[0];

  try
    if TransferRecord(LP^).Msg = MSG_IMAGE_SEND_REQ then
    begin
      if FFSMClass.GetCurrentState <> Ord(csIdle) then
      begin
        DisplayMessageSB('Idle 상태가 아님!',3);
        exit;
      end;

      FSFTCommThread.FCurrentState :=
              COMM_STATE(FFSMClass.StateTransition(ord(csImage_Send_Req_Recv)));

      FSFTCommThread.FReceiveFileName := TransferRecord(LP^).FileName;
      FSFTCommThread.FFileSize := TransferRecord(LP^).FileSize;
      FComport.ClearBuffer(True,True);
      AddCommandListItem(FSendCommandList, MSG_IMAGE_SEND_ACK, TransferRecord(LP^).FileName,
                                          TransferRecord(LP^).FileSize, False );
      FSFTCommThread.FCurrentState := COMM_STATE(FFSMClass.StateTransition(ord(csImage_Send_Ack)));

      FSFTCommThread.FIsCommandSend := True;
    end
    else if TransferRecord(LP^).Msg = MSG_IMAGE_RE_SEND_REQ then
    begin
      FSFTCommThread.FCurrentState := COMM_STATE(FFSMClass.StateTransition(ord(csImage_Send_Ack)));
      FSFTCommThread.FFileIndex := TransferRecord(LP^).FileSize + 1;
      FSendFileName := TransferRecord(LP^).FileName;
      FSFTCommThread.FSendFileName := IMAGEFILE;
      FSFTCommThread.FIsFileSend := True;
    end
    else if TransferRecord(LP^).Msg = MSG_IMAGE_SEND_ACK then
    begin
      if FFSMClass.GetCurrentState <> Ord(csCommandSend) then
      begin
        DisplayMessageSB('Command Send 상태가 아님!',3);
        exit;
      end;

      FSFTCommThread.FCurrentState := COMM_STATE(FFSMClass.StateTransition(ord(csImage_Send_Ack)));
      FSFTCommThread.FFileIndex := 0;
      FSendFileName := TransferRecord(LP^).FileName;
      //bmp.LoadFromStream(FImageStream);
      //DisplayDataInfo3(LStream);
      //DisplayDataInfo4(bmp);
      //ZCompressStream(LStream, FImageStream, zcMax);
      //FImageStream.Write(di.Content.Data, di.Content.Size);
      //FImageStream.Seek(0, soFromBeginning);
      //FMultiKlipboard.getBitmapData(FImageStream, FImageStream.Size, 'aaa');
      //FMultiKlipboard.getBitmapData(di.Content.Data, di.Content.Size);
      //DisplayList;
      FSFTCommThread.FImageStream := FImageStream;
      FSFTCommThread.FSendFileName := IMAGEFILE;
      FSFTCommThread.FIsFileSend := True;
    end
    else if TransferRecord(LP^).Msg = MSG_IMAGE_RECV_OK then
    begin
      if FFSMClass.GetCurrentState <> Ord(csImageSend) then
      begin
        DisplayMessageSB('File Send 상태가 아님!',3);
        exit;
      end;

      SendCommand(MSG_IMAGE_SEND_COMPLETE);
      FSFTCommThread.FCurrentState := COMM_STATE(FFSMClass.StateTransition(ord(csImage_Recv_OK)));
      FPJHTimerPool.AddOneShot(OnUpdateSB_FileReceiveComplete,2000);

      DisplayMessage(MSG_IMAGE_RECV_OK+ ' 수신완료', False);
    end
    else if TransferRecord(LP^).Msg = MSG_IMAGE_SEND_COMPLETE then
    begin
      if FFSMClass.GetCurrentState <> Ord(csImageSend) then
      begin
        DisplayMessageSB('Image Send 상태가 아님!',3);
        exit;
      end;

      FPJHTimerPool.AddOneShot(OnUpdateSB_FileReceiveComplete,2000);
      FSFTCommThread.FCurrentState := COMM_STATE(FFSMClass.StateTransition(ord(csImage_Recv_OK)));
    end
    else
      DisplayMessage('아무 상태도 아님',False);

  finally
    FRecvByteBuf.Clear;
    LFileName := GetStateName(COMM_STATE(FFSMClass.GetCurrentState));
    DisplayMessage(LFileName, False);
    FCriticalSection.Leave;
  end;
end;

procedure TSerialFileTransferF.InitComPort;
begin
  with FComport do
  begin
    FlowControl.ControlDTR := dtrEnable;
    OnRxChar := FSFTCommThread.OnReceiveChar;
    LoadSettings(FStoreType, FilePath + INIFILENAME);
    StatusBarPro1.Panels[0].Text := Port;
    StatusBarPro1.Panels[2].Text := BaudRateToStr(BaudRate)+','+
        DataBitsToStr(DataBits)+','+StopBitsToStr(StopBits)+','+ParityToStr(Parity.Bits);
    if Connected then
      Close;
  end;//with
end;

procedure TSerialFileTransferF.InitState;
var
  LFSMState: TFSMState;
begin
  LFSMState := TFSMState.Create(Ord(csIdle),6);
  LFSMState.AddTransition(Ord(csFile_Send_Req_Send), Ord(csCommandSend));
  LFSMState.AddTransition(Ord(csFile_Send_Req_Recv), Ord(csCommandRecv));
  LFSMState.AddTransition(Ord(csImage_Send_Req_Send), Ord(csCommandSend));
  LFSMState.AddTransition(Ord(csImage_Send_Req_Recv), Ord(csCommandRecv));
  LFSMState.AddTransition(Ord(csRTF_Send_Req_Send), Ord(csCommandSend));
  LFSMState.AddTransition(Ord(csRTF_Send_Req_Recv), Ord(csCommandRecv));
  FFSMClass.AddState(LFSMState);

  LFSMState := TFSMState.Create(Ord(csFileSend),1);
  LFSMState.AddTransition(Ord(csFile_Recv_OK), Ord(csIdle));
  FFSMClass.AddState(LFSMState);

  LFSMState := TFSMState.Create(Ord(csImageSend),1);
  LFSMState.AddTransition(Ord(csImage_Recv_OK), Ord(csIdle));
  FFSMClass.AddState(LFSMState);

  LFSMState := TFSMState.Create(Ord(csRTFSend),1);
  LFSMState.AddTransition(Ord(csRTF_Recv_OK), Ord(csIdle));
  FFSMClass.AddState(LFSMState);

  LFSMState := TFSMState.Create(Ord(csFileRecv),1);
  LFSMState.AddTransition(Ord(csFile_Send_Complete), Ord(csIdle));
  FFSMClass.AddState(LFSMState);

  LFSMState := TFSMState.Create(Ord(csImageRecv),1);
  LFSMState.AddTransition(Ord(csImage_Send_Complete), Ord(csIdle));
  FFSMClass.AddState(LFSMState);

  LFSMState := TFSMState.Create(Ord(csRTFRecv),1);
  LFSMState.AddTransition(Ord(csRTF_Send_Complete), Ord(csIdle));
  FFSMClass.AddState(LFSMState);

  LFSMState := TFSMState.Create(Ord(csCommandSend),6);
  LFSMState.AddTransition(Ord(csFile_Send_Ack), Ord(csFileSend));
  LFSMState.AddTransition(Ord(csFile_Send_deny), Ord(csIdle));
  LFSMState.AddTransition(Ord(csImage_Send_Ack), Ord(csImageSend));
  LFSMState.AddTransition(Ord(csImage_Send_deny), Ord(csIdle));
  LFSMState.AddTransition(Ord(csRTF_Send_Ack), Ord(csRTFSend));
  LFSMState.AddTransition(Ord(csRTF_Send_deny), Ord(csIdle));
  FFSMClass.AddState(LFSMState);

  LFSMState := TFSMState.Create(Ord(csCommandRecv),6);
  LFSMState.AddTransition(Ord(csFile_Send_Ack), Ord(csFileRecv));
  LFSMState.AddTransition(Ord(csFile_Send_deny), Ord(csIdle));
  LFSMState.AddTransition(Ord(csImage_Send_Ack), Ord(csImageRecv));
  LFSMState.AddTransition(Ord(csImage_Send_deny), Ord(csIdle));
  LFSMState.AddTransition(Ord(csRTF_Send_Ack), Ord(csRTFRecv));
  LFSMState.AddTransition(Ord(csRTF_Send_deny), Ord(csIdle));
  FFSMClass.AddState(LFSMState);

  FFSMClass.SetCurrentState(Ord(csIdle));
end;

procedure TSerialFileTransferF.InitVar;
begin
  FFirst := True;
  FFilePath := ExtractFilePath(Application.ExeName); //맨끝에 '\' 포함됨
  FIPCClient := TIPCClient2.Create(0, IPCCLIENTNAME, True);
  FSendCommandList := TList.Create;
  FRecvCommandList := TList.Create;
  FSendFileList := TStringList.Create;
  FRecvByteBuf := TByteArray2.Create(0);
  FRecvFileBuf := TByteArray2.Create(0);
  //FEventHandle := TEvent.Create('',False);
  FComport := TComPort_pjh.Create(nil);
  FComport.SyncMethod := smWindowSync;
  //FComport.Buffer.InputSize := MAX_SEND_SIZE;
  //FComport.Buffer.OutputSize := MAX_SEND_SIZE;

  FSFTCommThread := TComPortThread.Create(Self,1000);
  FSFTCommThread.CommPort := FComport;
  FSFTCommThread.StopComm := True;
  FSFTCommThread.FRecvFileBuf := FRecvFileBuf;
  FSFTCommThread.RecvByteBuf := FRecvByteBuf;
  FSFTCommThread.FSendCommandList := FSendCommandList;
  FSFTCommThread.FRecvCommandList := FRecvCommandList;

  FComPortStream := TComStream.Create(FComport);
  FSFTCommThread.FComPortStream := FComPortStream;

  FImageStream := TMemoryStream.Create;

  FPJHTimerPool := TPJHTimerPool.Create(nil);
  FSendTimerHandle := -1;
  FFSMClass := TFSMClass.Create(0);

  FDataTypes := [cdtString]+[cdtBitmap]+[cdtRTF];
  FMultiKlipboard := TMultiKlipboard.Create(CLIPBOARDCAPACITY, FDataTypes);
  FMultiKlipboard.OnClipboardNewItem := OnSysClipChanged;
  //  start hooking the system
  FMultiKlipboard.StartHook;;

  FStoreType := stIniFile;
  FSFTBase := TSFTBase.Create(nil);
  if FileExists('.\' + OPTIONFILENAME) then
    FSFTBase.LoadFromFile(OPTIONFILENAME);

  FCriticalSection := TCriticalSection.Create;

  InitState;
end;

procedure TSerialFileTransferF.LoadConfigData2Form(AConfigForm: TSFTConfigF);
begin
  with AConfigForm do
  begin
    QueryIntervalEdit.Text := IntToStr(FSFTBase.QueryInterval);
    ResponseWaitTimeOutEdit.Text := IntToStr(FSFTBase.ResponseWaitTime);
    DownLoadDirEdit.Text := FSFTBase.DownLoadDir;
    DontAskDnLdConfirmCB.Checked := FSFTBase.DontAskConfirm;

  end;//with
end;

procedure TSerialFileTransferF.LoadFormData2Collect(AConfigForm: TSFTConfigF);
begin
  with AConfigForm do
  begin
    FSFTBase.QueryInterval := StrToIntDef(QueryIntervalEdit.Text,0);
    FSFTBase.ResponseWaitTime := StrToIntDef(ResponseWaitTimeOutEdit.Text,0);
    FSFTBase.DownLoadDir := DownLoadDirEdit.Text;
    FSFTBase.DontAskConfirm := DontAskDnLdConfirmCB.Checked;
  end;//with
end;

procedure TSerialFileTransferF.mnuItemDeleteClick(Sender: TObject);
begin
  RemoveClipBoardItem;
end;

procedure TSerialFileTransferF.mnuItemInfoClick(Sender: TObject);
begin
  if (lstviewData.SelCount > 0) then
    DisplayDataInfo(lstviewData.Selected.Index);
end;

procedure TSerialFileTransferF.mnuItemSendClick(Sender: TObject);
begin
  if (lstviewData.SelCount > 0) and Assigned(FMultiKlipboard) then
    FMultiKlipboard.SendDataToClipboard(lstviewData.Selected.Index);
end;

procedure TSerialFileTransferF.WMReceiveByte(var Message: TMessage);
var
  i: integer;
  LP: pointer;
begin
  ProcessCommand;

{  LP := FRecvByteBuf.CStrFrom[0];
  DisplayMessage(TransferRecord(LP^).Msg + #13#10 +
    IntToStr(TransferRecord(LP^).FileSize) + #13#10 +
    TransferRecord(LP^).FileName + #13#10 +
    BoolToStr(TransferRecord(LP^).Append) + ' ==> Received', False);

  exit;
}
end;

procedure TSerialFileTransferF.WMRTFRecvComplete(var Msg: TMessage);
var
  LStream: TMemoryStream;
  LBuf: TByteArray2;
  LStr: string;
  iHandle: THandle;
  pData: Pointer;
  clip: TClipboard;
begin
  LStream := TMemoryStream.Create;
  //LBuf := TByteArray2.Create;
  try
    //FPJHTimerPool.RemoveAll;
    //LBuf.CopyByteArray(FRecvFileBuf, FSFTCommThread.FFileSize, Sizeof(TransferRecord));
    FRecvFileBuf.Remove(FSFTCommThread.FFileSize,FRecvFileBuf.Size-FSFTCommThread.FFileSize);
    //FRecvFileBuf.SaveToStream(LStream);
    //LStream.Seek(0, soFromBeginning);
    SetLength(LStr, FRecvFileBuf.Size);
    LStr := Copy(PChar(FRecvFileBuf.CStrFrom[0]), 0, FRecvFileBuf.Size);
    try
      clip := Clipboard;
      clip.Open;
      iHandle := GlobalAlloc(GHND or GMEM_DDESHARE, FRecvFileBuf.Size+1);

      if (iHandle <> 0) then
      begin
        pData := GlobalLock(iHandle);
        Move(LStr[1], pData^, FRecvFileBuf.Size+1);
      end;
    finally
      GlobalUnlock(iHandle);
      clip.SetAsHandle(CF_UNICODETEXT, iHandle);
      clip.Close;
    end;

    //DisplayMessage(Lstr, False);
    //DisplayMessage(IntToStr(FRecvFileBuf.Size),False);
    FPJHTimerPool.AddOneShot(OnUpdateSB_FileReceiveComplete,2000);
    FRecvFileBuf.Clear;
    FSFTCommThread.FReceivedSize := 0;
    SendCommand(MSG_RTF_RECV_OK);
    FSFTCommThread.FCurrentState := COMM_STATE(FFSMClass.StateTransition(ord(csRTF_Send_Complete)));
  finally
    //LBuf.Free;
    LStream.Free;
  end;
end;

procedure TSerialFileTransferF.WMRTFSendComplete(var Msg: TMessage);
begin
;
end;

procedure TSerialFileTransferF.Timer1Timer(Sender: TObject);
begin
  with Timer1 do
  begin
    Enabled := False;
    try
      if FFirst then
      begin
        FFirst := False;
        Interval := 500;
      end//if
      else
      begin
      end;
    finally
      Enabled := True;
    end;//try
  end;//with
end;

procedure TSerialFileTransferF.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure TSerialFileTransferF.CurrentState1Click(Sender: TObject);
var
  LStr: string;
begin
  LStr := GetStateName(COMM_STATE(FFSMClass.GetCurrentState));
  DisplayMessageSB(LStr,3);
end;

procedure TSerialFileTransferF.DeleteCommandListItem(AList: TList; AIndex: integer);
var
  LRecord: PTransferRecord;
begin
  LRecord := AList.Items[AIndex];
  Dispose(LRecord);
  LRecord := nil;

  AList.Delete(AIndex);
end;

procedure TSerialFileTransferF.DisplayDataInfo(i: Byte);
var
  frmDataInfo: TForm4;
  bmp: TBitmap;
  s: string;
  ni: TListItem;
  di: TMultiKlipboardDataItem;
  Li: integer;
begin
  frmDataInfo := TForm4.Create(nil);
  try
    if not Assigned(FMultiKlipboard.DataList) then Exit;
    if not Assigned(FMultiKlipboard.DataList.Items[i]) then Exit;

    di := PMultiKlipboardDataItem(FMultiKlipboard.DataList.Items[i])^;
    frmDataInfo.Caption := 'Data info : ($' + IntToHex(Integer(@di), 6) + ')';
    if (di.DataType = cdtString) or (di.DataType = cdtWideString) or (di.DataType = cdtRTF) then
      begin
        ni := frmDataInfo.lvi.Items.Add;
        ni.Caption := 'Display Name';
        ni.SubItems.Add(di.DataText);

        ni := frmDataInfo.lvi.Items.Add;
        ni.Caption := 'Data Size';
        ni.SubItems.Add(IntToStr(di.Content.Size) + ' byte(s)');

        ni := frmDataInfo.lvi.Items.Add;
        ni.Caption := 'Data Type';
        if di.DataType = cdtString then
          ni.SubItems.Add('cdtString')
        else
          ni.SubItems.Add('cdtWideString');

        FMultiKlipboard.GetStringStored(i, s);

        frmDataInfo.panelText.Visible := true;
        frmDataInfo.memoPreview.Text := s;
      end
    else
      begin
        bmp := TBitmap.Create;
        try
          frmDataInfo.Caption := IntToStr(sizeof(di)+di.Content.size);
          FMultiKlipboard.GetBitmapStored(i, bmp);
          if not Assigned(bmp) then Exit;

          ni := frmDataInfo.lvi.Items.Add;
          ni.Caption := 'Display Name';
          ni.SubItems.Add(di.DataText);

          ni := frmDataInfo.lvi.Items.Add;
          ni.Caption := 'Data Size';
          ni.SubItems.Add(IntToStr(di.Content.Size) + ' byte(s)');

          ni := frmDataInfo.lvi.Items.Add;
          ni.Caption := 'Width';
          ni.SubItems.Add(intToStr(bmp.Width));

          ni := frmDataInfo.lvi.Items.Add;
          ni.Caption := 'Height';
          ni.SubItems.Add(intToStr(bmp.Height));

          frmDataInfo.panelBitmap.Visible := true;
          frmDataInfo.MakeThumbnail(bmp);
        finally
          freeAndNil(bmp);
        end;
      end;

    //  show the dialog
    frmDataInfo.ShowModal;

  finally
    FreeAndNil(frmDataInfo);
  end;
end;

procedure TSerialFileTransferF.DisplayDataInfo2(AData: Pointer; Asize: Integer);
var
  frmDataInfo: TForm4;
  bmp: TBitmap;
begin
  frmDataInfo := TForm4.Create(nil);
  try
    if not Assigned(FMultiKlipboard.DataList) then Exit;

    bmp := TBitmap.Create;
    try
      FMultiKlipboard.GetBitmapFromPointer(AData, Asize, bmp);
      frmDataInfo.panelBitmap.Visible := true;
      frmDataInfo.MakeThumbnail(bmp);
    finally
      freeAndNil(bmp);
    end;

    //  show the dialog
    frmDataInfo.ShowModal;

  finally
    FreeAndNil(frmDataInfo);
  end;
end;

procedure TSerialFileTransferF.DisplayDataInfo3(AStream: TStream);
var
  frmDataInfo: TForm4;
  bmp: TBitmap;
  clip: TClipboard;
  iPictureFormat: Word;
  iPictureHandle: THandle;
  iPalleteHandle: HPALETTE;
begin
  frmDataInfo := TForm4.Create(nil);
  try
    bmp := TBitmap.Create;
    clip := Clipboard;
    clip.Open;
    try
      bmp.LoadFromStream(AStream);
      frmDataInfo.panelBitmap.Visible := true;
      frmDataInfo.MakeThumbnail(bmp);
      bmp.SaveToClipboardFormat(iPictureFormat, iPictureHandle, iPalleteHandle);
      clip.SetAsHandle(iPictureFormat, iPictureHandle);
    finally
      freeAndNil(bmp);
    end;

    //  show the dialog
    frmDataInfo.ShowModal;

  finally
    clip.Close;
    FreeAndNil(frmDataInfo);
  end;
end;

procedure TSerialFileTransferF.DisplayDataInfo4(ABmp: TBitmap);
var
  frmDataInfo: TForm4;
begin
  frmDataInfo := TForm4.Create(nil);
  try
    frmDataInfo.panelBitmap.Visible := true;
    frmDataInfo.MakeThumbnail(ABmp);
  //  show the dialog
  frmDataInfo.ShowModal;

  finally
    FreeAndNil(frmDataInfo);
  end;
end;

procedure TSerialFileTransferF.DisplayList;
var
  curDataItem: TMultiKlipboardDataItem;
  newListItem: TListItem;
  i: Integer;
  s: String;
begin
  lstviewData.Items.BeginUpdate;
  try
    lstviewData.Items.Clear;

    for i := 0 to FMultiKlipboard.DataList.Count -1 do
    begin
      if Assigned(FMultiKlipboard.DataList.Items[i]) and Assigned(PMultiKlipboardDataItem(FMultiKlipboard.DataList.Items[i])^.Content.Data) then
      begin
        curDataItem := PMultiKlipboardDataItem(FMultiKlipboard.DataList.Items[i])^;
        newListItem := lstviewData.Items.Add;

        if (curDataItem.DataType = cdtString) or (curDataItem.DataType = cdtWideString) then
          begin
            if (curDataItem.DataType = cdtString) then newListItem.ImageIndex := 0
            else newListItem.ImageIndex := 1;
            newListItem.SubItems.Add(curDataItem.DataText)
          end
        else if curDataItem.DataType = cdtBitmap then
          begin
            newListItem.ImageIndex := 2;
            newListItem.SubItems.Add(curDataItem.DataText);
          end
        else if curDataItem.DataType = cdtRTF then
          begin
            s := '[Rich Text Format Data]';
            newListItem.ImageIndex := 3;
            if (curDataItem.DataText = '') then newListItem.SubItems.Add(s)
            else newListItem.SubItems.Add(curDataItem.DataText + '...');
          end;
      end;
    end;

  finally
    lstviewData.Items.EndUpdate;
  end;
end;

procedure TSerialFileTransferF.DisplayMessage(msg: string; IsSend: Boolean);
begin
  if IsSend then
  begin
    if msg = ' ' then
    begin
      exit;
    end
    else

    with ModBusSendComMemo do
    begin
      if Lines.Count > 100 then
        Clear;

      Lines.Add(msg);
    end;//with
  end
  else
  begin
    if msg = 'RxTrue' then
    begin
      exit;
    end
    else
    if msg = 'RxFalse' then
    begin
      exit;
    end;

    with ModBusRecvComMemo do
    begin
      if Lines.Count > 100 then
        Clear;

      Lines.Add(msg);
    end;//with
  end;

end;

procedure TSerialFileTransferF.DisplayMessageSB(AMsg: string; AIndex: integer);
begin
  StatusBarPro1.Panels[AIndex].Text := AMsg;
end;

procedure TSerialFileTransferF.DropTextTarget1Drop(Sender: TObject;
  ShiftState: TShiftState; APoint: TPoint; var Effect: Integer);
var
  i: integer;
  LStr: string;
begin
  LStr := '';

  if DropTextTarget1.Text <> '' then
    LStr := DropTextTarget1.Text
  else
  if (DataFormatAdapterURL.DataFormat <> nil) and
     ((DataFormatAdapterURL.DataFormat as TURLDataFormat).URL <> '') then
  begin
    LStr := (DataFormatAdapterURL.DataFormat as TURLDataFormat).URL;
  end
  else
  if (DataFormatAdapterFile.DataFormat <> nil) and // Check if we have a data format and if so...
     ((DataFormatAdapterFile.DataFormat as TFileDataFormat).Files.Count > 0) then
  begin
    if FFSMClass.GetCurrentState = Ord(csIdle) then
    begin
      FSendFileList.Clear;
      // ...Extract the dropped data from it.
      for i := 0 to (DataFormatAdapterFile.DataFormat as TFileDataFormat).Files.Count - 1 do
      begin
        FSendFileList.Add(
            (DataFormatAdapterFile.DataFormat as TFileDataFormat).Files.Strings[i]);
        ModBusSendComMemo.Lines.Add((DataFormatAdapterFile.DataFormat as TFileDataFormat).Files.Strings[i]);
      end;
      DisplayMessage(IntToStr(FSendFileList.Count)+ ' 개 File 전송 준비중...', False);
    end
    else
      DisplayMessage('Idle 상태가 아님', False);
  end;

end;

procedure TSerialFileTransferF.AddCommandListItem(AList: TList; AMsg, AFileName: string;
                                          AFileSize: integer; AAppend: boolean);
var
  LRecord: PTransferRecord;
begin
  if AFileName = '' then
    AFileName := 'NULL';

  New(LRecord);
  LRecord^.Msg:= AMsg;
  LRecord^.FileName := AFileName;
  LRecord^.FileSize := AFileSize ;
  LRecord^.Append := AAppend;
  AList.Add(LRecord);
end;

procedure TSerialFileTransferF.Button1Click(Sender: TObject);
begin
  try
    InitComPort;
  except
    ShowMessage('Comm port Initialize fail!');
  end;

  FSFTCommThread.StopComm := not FSFTCommThread.StopComm;

  if FSFTCommThread.StopComm then
  begin
    if FComport.Connected then
      FComport.Close;

    Button1.Caption := '통신시작';
  end
  else
  begin
    //통신포트를 오픈한다
    FComport.Open;
    Sleep(100);
    FComport.ClearBuffer(True,True);

    FSFTCommThread.Resume;
    Button1.Caption := '통신중지';
  end;

  JvLED1.Status := FComport.Connected;
end;

procedure TSerialFileTransferF.Button2Click(Sender: TObject);
var
  di: TMultiKlipboardDataItem;
  newData: PMultiKlipboardDataItem;
  iHash: Cardinal;
  LSendBuf: TByteArray2;
  bmp: TBitmap;
  comprData: Pointer;
  comprSize: Integer;
  LStream: TMemoryStream;
begin
  LSendBuf := TByteArray2.Create(0);
  LStream := TMemoryStream.Create;

  FRecvFileBuf.SaveToFile('.\aaa.txt');

  try
{    FillChar(di, SizeOf(di), 0);
    di := PMultiKlipboardDataItem(FMultiKlipboard.DataList.Items[lstviewData.Selected.Index])^;
    bmp := TBitmap.Create;
    try
      FMultiKlipboard.GetBitmapFromPointer(di.Content.Data, di.Content.Size, bmp);
      bmp.SaveToStream(LStream);
      LStream.Seek(0,soFromBeginning);
      bmp.LoadFromStream(LStream);
      DisplayDataInfo4(bmp);
      //ZCompressStream(LStream, FImageStream, zcMax);
    finally
      freeAndNil(bmp);
    end;
}
    //DisplayDataInfo2(di.Content.Data, di.Content.Size);
    //FImageStream.Write(di.Content.Data, di.Content.Size);
    //FImageStream.Seek(0, soFromBeginning);
    //FMultiKlipboard.getBitmapData(FImageStream, FImageStream.Size, 'aaa');
    //FMultiKlipboard.getBitmapData(di.Content.Data, di.Content.Size);
    //iHash := FMultiKlipboard.computeHashValue(di.Content.Data, di.Content.Size);
    //New(newData);
    //newData^.Content.Data := di.Content.Data;
    //newData^.Content.Size := di.Content.Size;
    //newData^.Content.Data := FImageStream.Memory;
    //newData^.Content.Size := FImageStream.Size;
    //newData^.Content.Hash := iHash;
    //newData^.DataType := cdtBitmap;
    //newData^.DataText := 'Bitmap (' + FormatDateTime('dmyyhmsz', Now) + ')';

    //newData.Content.Hash := FMultiKlipboard.computeHashValue(newData.Content.Data, newData.Content.Size);
    //FMultiKlipboard.DataList.Insert(0, newData);
    //DisplayList;
  finally
    LSendBuf.Free;
    LStream.Free;
  end;
end;

procedure TSerialFileTransferF.Button3Click(Sender: TObject);
begin
  if FSendFileList.Count > 0 then
    SendFileListReq;
end;

procedure TSerialFileTransferF.N2Click(Sender: TObject);
begin
  SetConfigData;
end;

procedure TSerialFileTransferF.N4Click(Sender: TObject);
begin
  Close;
end;

procedure TSerialFileTransferF.OnReSendReqFile(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FPJHTimerPool.Remove(FReSendTimerHandle);

  if FSFTCommThread.FFileSize > FSFTCommThread.FReceivedSize then
  begin
    AddCommandListItem(FSendCommandList, MSG_FILE_RE_SEND_REQ, FSFTCommThread.FReceiveFileName,
                            FSFTCommThread.FReceivedSize, True);
    FSFTCommThread.FIsCommandSend := True;
  end;
end;

procedure TSerialFileTransferF.OnSendFilesReq(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FPJHTimerPool.Enabled[FSendTimerHandle] := False;
  try
    if FFSMClass.GetCurrentState = Ord(csIdle) then
    begin
      if (FSendFileList.Count > FSendFileIndex) and //모두 전송 후 전송 중지
           (FSendFileList.Count > 0) then
      begin
        if FSendFileOK then
        begin
          SendFileReq(FSendFileList.Strings[FSendFileIndex]);
          FSendFileOK := False;
        end;
      end;
    end;
  finally
    FPJHTimerPool.Enabled[FSendTimerHandle] := True;
  end;
end;

procedure TSerialFileTransferF.OnSysClipChanged(
  newData: pMultiKlipboardDataItem);
var
  notifyForm: TForm5;
begin
  if Showing then DisplayList;

  if Assigned(newData) then
  begin
    try
      notifyForm := TForm5.Create(Application);

      notifyForm.LabelCaption.Caption := 'Data collected ';
      case newData^.DataType of
        cdtString:      notifyForm.LabelText.Caption := 'New string item';
        cdtWidestring:  notifyForm.LabelText.Caption := 'New unicode string item';
        cdtBitmap:      notifyForm.LabelText.Caption := 'New picture item';
        cdtRTF:         notifyForm.LabelText.Caption := 'New rich text format item';
      end;
      notifyForm.Show;
      notifyForm.SetAutoFree(AUTOKILLTIME); //  we're not going to free this, it will destroy
                                            //  itself after a while
    except
      Exit;
    end;
  end;

end;

procedure TSerialFileTransferF.OnUpdateSB_FileReceiveComplete(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  DisplayMessageSB('Transfer(%)',4);
  JvProgressBar1.Position := 0;
  //FEventHandle.Pulse;
end;

procedure TSerialFileTransferF.ProcessCommand;
var
  LP: pointer;
  LStr: string;
begin
  LP := FRecvByteBuf.CStrFrom[0];
  LStr := TransferRecord(LP^).Msg;

  if 'FILE' = Copy(LStr,3,4) then
    FileSendCommandProcess
  else
  if 'IMAGE' = Copy(LStr,3,5) then
    ImageSendCommandProcess
  else
  if 'RTF' = Copy(LStr,3,3) then
    RTFSendCommandProcess;
end;

procedure TSerialFileTransferF.RemoveClipBoardItem;
var
  curDataItem: TMultiKlipboardDataItem;
  sCurCaption: string;
begin
  if (lstviewData.SelCount < 1) or (lstviewData.Selected.Index > 255) or (lstviewData.Selected.Index > FMultiKlipboard.DataCount) then Exit;

  curDataItem := PMultiKlipboardDataItem(FMultiKlipboard.DataList.Items[lstviewData.Selected.Index])^;

  if (curDataItem.DataText <> '') then
    sCurCaption := curDataItem.DataText else sCurCaption := lstviewData.Selected.SubItems.Strings[0];

  if (MessageDlg('This action will remove this entry "'  + sCurCaption + '" from ' + Application.Title + '. Are you sure you want to do this?', mtConfirmation, [mbYes, mbCancel], 0) = mrYes) then
  begin
    FMultiKlipboard.Remove(lstviewData.Selected.Index);
    DisplayList;
  end;
end;

procedure TSerialFileTransferF.ResetState1Click(Sender: TObject);
begin
  FFSMClass.SetCurrentState(Ord(csIdle));
  FComport.ClearBuffer(True, True);
end;

procedure TSerialFileTransferF.RTFSendCommandProcess;
var
  LP: pointer;
  Li: integer;
  LFileName: string;
  LFileSize: integer;
  LAppend: boolean;
  di: TMultiKlipboardDataItem;
begin
  FCriticalSection.Enter;

  LP := FRecvByteBuf.CStrFrom[0];

  try
    if TransferRecord(LP^).Msg = MSG_RTF_SEND_REQ then
    begin
      if FFSMClass.GetCurrentState <> Ord(csIdle) then
      begin
        DisplayMessageSB('Idle 상태가 아님!',3);
        exit;
      end;

      FSFTCommThread.FCurrentState :=
              COMM_STATE(FFSMClass.StateTransition(ord(csRTF_Send_Req_Recv)));

      FSFTCommThread.FReceiveFileName := TransferRecord(LP^).FileName;
      FSFTCommThread.FFileSize := TransferRecord(LP^).FileSize;
      FComport.ClearBuffer(True,True);
      AddCommandListItem(FSendCommandList, MSG_RTF_SEND_ACK, TransferRecord(LP^).FileName,
                                          TransferRecord(LP^).FileSize, False );
      FSFTCommThread.FCurrentState := COMM_STATE(FFSMClass.StateTransition(ord(csRTF_Send_Ack)));

      FSFTCommThread.FIsCommandSend := True;
    end
    else if TransferRecord(LP^).Msg = MSG_RTF_RE_SEND_REQ then
    begin
      FSFTCommThread.FCurrentState := COMM_STATE(FFSMClass.StateTransition(ord(csRTF_Send_Ack)));
      FSFTCommThread.FFileIndex := TransferRecord(LP^).FileSize + 1;
      FSendFileName := TransferRecord(LP^).FileName;
      FSFTCommThread.FSendFileName := RTFFILE;
      FSFTCommThread.FIsFileSend := True;
    end
    else if TransferRecord(LP^).Msg = MSG_RTF_SEND_ACK then
    begin
      if FFSMClass.GetCurrentState <> Ord(csCommandSend) then
      begin
        DisplayMessageSB('Command Send 상태가 아님!',3);
        exit;
      end;

      FSFTCommThread.FCurrentState := COMM_STATE(FFSMClass.StateTransition(ord(csRTF_Send_Ack)));
      FSFTCommThread.FFileIndex := 0;
      FSendFileName := TransferRecord(LP^).FileName;
      //FSFTCommThread.FImageStream := FImageStream;
      FSFTCommThread.FSendString := FSendString;
      FSFTCommThread.FSendFileName := RTFFILE;
      FSFTCommThread.FIsFileSend := True;
    end
    else if TransferRecord(LP^).Msg = MSG_RTF_RECV_OK then
    begin
      if FFSMClass.GetCurrentState <> Ord(csRTFSend) then
      begin
        DisplayMessageSB('File Send 상태가 아님!',3);
        exit;
      end;

      SendCommand(MSG_RTF_SEND_COMPLETE);
      FSFTCommThread.FCurrentState := COMM_STATE(FFSMClass.StateTransition(ord(csRTF_Recv_OK)));
      FPJHTimerPool.AddOneShot(OnUpdateSB_FileReceiveComplete,2000);

      DisplayMessage(MSG_RTF_RECV_OK+ ' 수신완료', False);
    end
    else if TransferRecord(LP^).Msg = MSG_RTF_SEND_COMPLETE then
    begin
      if FFSMClass.GetCurrentState <> Ord(csRTFSend) then
      begin
        DisplayMessageSB('Image Send 상태가 아님!',3);
        exit;
      end;

      FPJHTimerPool.AddOneShot(OnUpdateSB_FileReceiveComplete,2000);
      FSFTCommThread.FCurrentState := COMM_STATE(FFSMClass.StateTransition(ord(csRTF_Recv_OK)));
    end
    else
      DisplayMessage('아무 상태도 아님',False);

  finally
    FRecvByteBuf.Clear;
    LFileName := GetStateName(COMM_STATE(FFSMClass.GetCurrentState));
    DisplayMessage(LFileName, False);
    FCriticalSection.Leave;
  end;
end;

{**************************************************
 Result =
 1  : 전송된 파일 name 그대로.. 저장
 2  : 다른이름으로 저장
 3  : 취소..
***************************************************}
function TSerialFileTransferF.SendFileACK(var AFileName: string;
                         var AFileSize: integer; var AAppend: boolean): integer;
var
  LFilePath: string;
  LP: pointer;
  LSize: integer;
  LAppend: Boolean;
begin
  LP := FRecvByteBuf.CStrFrom[0];
  Result := 1;

  if not FSFTBase.DontAskConfirm then
  begin
    // 파일전송 알림 창을 뛰움..
    with TForm3.Create(nil) do
    try
      FileNameLbl.Caption := ExtractFileNAme(TransferRecord(LP^).FileName) ;
      ShowModal;
      Result := Turn_Value;
      AFileName := Turn_Fname ;
      FSFTBase.DontAskConfirm := DontAskDnLdConfirmCB.Checked;
    finally
      Free;
    end;
  end;

  // 다른이름으로 저장이 아닐시.. 기본적으로 현재 폴더.. 알아서 각자 수정 ^^
  if Result = 1 then //+ '\받은 파일\'
  begin
    if FSFTBase.DownLoadDir <> '' then
      LFilePath := IncludeTrailingBackslash(FSFTBase.DownLoadDir)
    else
      LFilePath := '';

    AFileName := LFilePath + ExtractFileNAme(TransferRecord(LP^).FileName);
  end;

  //try
    if fileExists(AFileName) then
    begin
      if Application.MessageBox('파일이 이미 있습니다. 이어받으시겠습니까?','File Recv',MB_ICONQUESTION or MB_YESNO) = IDYES Then
      begin
        AFileSize := GetSizeOfFile(AFileName);

        if AFileSize < 0 then
          AFileSize := TrunFileSize(AFileName);
        AAppend := true ;
      end
      else
      begin
        DeleteFile(AFileName);
        AFileSize := 0 ;
        AAppend := false ;
      end;
    end
    else
    begin
      AFileSize := 0 ;
      AAppend := false ;
    end;

    //통신으로 받은 이름 그래도 반환(보내는 쪽 경로가 있기 때문임)
    AFileName := TransferRecord(LP^).FileName;

    {***** 이어받기일경우 파일 포인터 변경 *****}
{    if MyReceivingRecord.Append then
    begin
       FStream := TFileStream.create( SaveAS , fmOpenWrite or fmShareExclusive) ;
       FStream.Seek( 0, soFromEnd ) ;
    end
    else
    begin
       FStream := TFileStream.Create( SaveAS , fmCreate  or fmShareExclusive);
    end;
    try
       AThread.Connection.WriteBuffer(MyReceivingRecord,SizeOf(MyReceivingRecord),true);
       AThread.Connection.ReadStream(FStream,-1,false);  //True
    finally
       FreeAndNil(FStream);
       AThread.Connection.Disconnect;
    end;
  Except on E: Exception do begin
  //ShowMessage('Error : ' + E.Message);
    End;
  end;
 }
end;

procedure TSerialFileTransferF.SendFileListReq;
var
  Li: integer;
  LFileName: string;
begin
  FSendFileIndex := 0;
  FSendFileOK := True;
  FSendTimerHandle := FPJHTimerPool.Add(OnSendFilesReq,2000);
end;

procedure TSerialFileTransferF.SendFileReq(AFileName: string);
begin
  if FFSMClass.GetCurrentState <> Ord(csIdle) then
  begin
    DisplayMessageSB('Idle 상태가 아님',3);
    exit;
  end;

  if AFileName = '' then
  begin
    if OpenDialog1.Execute then
      AFileName := OpenDialog1.FileName;
  end;

  if FileInfoSet(AFileName) then
  begin
    Label2.Caption := AFileName;
    FSFTCommThread.FIsCommandSend := True;
  end;
end;

procedure TSerialFileTransferF.SendImageReq(AItem: PMultiKlipboardDataItem);
var
  LStream: TMemoryStream;
  bmp: TBitmap;
begin
  LStream := TMemoryStream.Create;
  bmp := TBitmap.Create;
  try
    FMultiKlipboard.GetBitmapFromPointer(AItem.Content.Data, AItem.Content.Size, bmp);
    bmp.SaveToStream(LStream);
    LStream.Seek(0, soFromBeginning);
    ZCompressStream(LStream, FImageStream);
    //LStream.Seek(0, soFromBeginning);
    //ZDecompressStream(LStream,FImageStream);
    FImageStream.Seek(0, soFromBeginning);

    AddCommandListItem(FSendCommandList, MSG_IMAGE_SEND_REQ, IMAGEFILE, FImageStream.size, False);
    FSFTCommThread.FCurrentState := COMM_STATE(FFSMClass.StateTransition(Ord(csImage_Send_Req_Send)));
    FSFTCommThread.FIsCommandSend := True;
  finally
    freeAndNil(LStream);
    freeAndNil(bmp);
  end;
end;

procedure TSerialFileTransferF.SendRTFReq(AItem: PMultiKlipboardDataItem);
begin
  SetLength(FSendString, AItem.Content.Size);
  FSendString := Copy(PChar(AItem.Content.Data), 1, AItem.Content.Size);
  AddCommandListItem(FSendCommandList, MSG_RTF_SEND_REQ, RTFFILE, Length(FSendString)*Sizeof(FSendString[1]), False);
  FSFTCommThread.FCurrentState := COMM_STATE(FFSMClass.StateTransition(Ord(csRTF_Send_Req_Send)));
  FSFTCommThread.FIsCommandSend := True;
end;

procedure TSerialFileTransferF.SendtoCOMPort1Click(Sender: TObject);
begin
  SendClipBoardReq;
end;

procedure TSerialFileTransferF.SendClipBoardReq;
var
  i: integer;
  curDataItem: PMultiKlipboardDataItem;
begin
  if (lstviewData.SelCount > 0) then
  begin
    i := lstviewData.Selected.Index;
    if not Assigned(FMultiKlipboard.DataList) then Exit;
    if not Assigned(FMultiKlipboard.DataList.Items[i]) then Exit;

    curDataItem := PMultiKlipboardDataItem(FMultiKlipboard.DataList.Items[i]);

    case curDataItem.DataType of
      cdtString:      ;
      cdtWidestring:  SendRTFReq(curDataItem);
      cdtRTF:         SendRTFReq(curDataItem);
      cdtBitmap:      SendImageReq(curDataItem);
    end;
  end
  else
    ShowMessage('보낼 데이타가 없슴!');

end;

procedure TSerialFileTransferF.SendCommand(ACommand: string);
begin
  AddCommandListItem(FSendCommandList, ACommand, '', 0, False);
  FSFTCommThread.FIsCommandSend := True;
end;

procedure TSerialFileTransferF.SendFile1Click(Sender: TObject);
begin
  SendFileReq('');
end;

procedure TSerialFileTransferF.SetConfigComm;
begin
  FSFTCommThread.FComPort.ShowSetupDialog;
  FSFTCommThread.FComPort.StoreSettings(FStoreType,FilePath + INIFILENAME)
end;

procedure TSerialFileTransferF.SetConfigData;
var
  ConfigData: TSFTConfigF;
begin
  if Button1.Caption = 'Stop' then
    Button1Click(nil);

  ConfigData := nil;
  ConfigData := TSFTConfigF.Create(Self);
  try
    with ConfigData do
    begin
      LoadConfigData2Form(ConfigData);
      if ShowModal = mrOK then
      begin
        LoadFormData2Collect(ConfigData);
        FSFTBase.SaveToFile(OPTIONFILENAME);
      end;
    end;//with
  finally
    ConfigData.Free;
    ConfigData := nil;
  end;//try
end;

procedure TSerialFileTransferF.WMCopyData(var Msg: TMessage);
begin
  DisplayMessage(PRecToPass(PCopyDataStruct(Msg.LParam)^.lpData)^.StrMsg,
             Boolean(PRecToPass(PCopyDataStruct(Msg.LParam)^.lpData)^.iHandle));
end;

procedure TSerialFileTransferF.WMFileRecvComplete(var Msg: TMessage);
var
  LFileStream: TFileStream;
  LBuf: TByteArray2;
  LMode: Word;
  LP: pointer;
  LFileName: string;
begin
  if FSFTBase.DownLoadDir <> '' then
    LFileName := IncludeTrailingBackslash(FSFTBase.DownLoadDir)
  else
    LFileName := '';

  LFileName := LFileName + ExtractFileName(FSFTCommThread.FReceiveFileName);
  if FileExists(LFileName) then
    LMode := fmOpenWrite
  else
    LMode := fmCreate;

  LFileStream := TFileStream.Create(LFileName , LMode or fmShareDenyWrite);
  //LBuf := TByteArray2.Create;
  try
    //FPJHTimerPool.RemoveAll;
    //LBuf.CopyByteArray(FRecvFileBuf, FSFTCommThread.FFileSize,Sizeof(TransferRecord));
    FRecvFileBuf.Remove(FSFTCommThread.FFileSize,FRecvFileBuf.Size-FSFTCommThread.FFileSize);
    FRecvFileBuf.SaveToStream(LFileStream);
    //LP := LBuf.CStrFrom[0];
    //DisPlayMessage(TransferRecord(LP^).Msg, False);
    FPJHTimerPool.AddOneShot(OnUpdateSB_FileReceiveComplete,2000);
    FRecvFileBuf.Clear;
    SendCommand(MSG_FILE_RECV_OK);
    FSFTCommThread.FCurrentState := COMM_STATE(FFSMClass.StateTransition(ord(csFile_Send_Complete)));
  finally
    //LBuf.Free;
    LFileStream.Free;
  end;
end;

procedure TSerialFileTransferF.WMFileRecvCProgress(var Msg: TMessage);
var
  LStr: string;
  LFileSize: integer;
  LRecvSize: integer;
  LUnit: string;
begin
  if FSFTCommThread.FFileSize > 10000 then
  begin
    LFileSize := FSFTCommThread.FFileSize div 1000;
    LRecvSize := Msg.WParam div 1000;
    LUnit := 'kB';
  end
  else
  begin
    LFileSize := FSFTCommThread.FFileSize;
    LRecvSize := Msg.WParam;
    LUnit := 'Bytes';
  end;

  JvProgressBar1.Position := Trunc(Msg.WParam/FSFTCommThread.FFileSize*100);
  LStr := 'Receive('+formatfloat('#,##0',LRecvSize)+'/'+
                            formatfloat('#,##0',LFileSize)+')'+
                            LUnit +  ' ' +
                            IntToStr(JvProgressBar1.Position)+'%';
  DisplayMessageSB(LStr, 4);
  //FReSendTimerHandle := FPJHTimerPool.AddOneShot(OnReSendReqFile,2000);
end;

procedure TSerialFileTransferF.WMFileSendComplete(var Msg: TMessage);
begin
  //FSFTCommThread.FCurrentState := COMM_STATE(FFSMClass.StateTransition(ord(csFile_Recv_OK)));
  //SendCommand(MSG_FILE_SEND_COMPLETE);
end;

procedure TSerialFileTransferF.WMFileSendProgress(var Msg: TMessage);
var
  LStr: string;
  LFileSize: integer;
  LSendSize: integer;
  LUnit: string;
begin
  if FSFTCommThread.FFileSize > 10000 then
  begin
    LFileSize := FSFTCommThread.FFileSize div 1000;
    LSendSize := Msg.WParam div 1000;
    LUnit := 'kB';
  end
  else
  begin
    LFileSize := FSFTCommThread.FFileSize;
    LSendSize := Msg.WParam;
    LUnit := 'Bytes';
  end;

  JvProgressBar1.Position := Trunc(Msg.WParam/FSFTCommThread.FFileSize*100);
  LStr := 'Send('+formatfloat('#,##0',LSendSize)+'/'+
                            formatfloat('#,##0',LFileSize)+')'+
                            LUnit +  ' ' +
                            IntToStr(JvProgressBar1.Position)+'%';
  DisplayMessageSB(LStr, 4);
  FPJHTimerPool.AddOneShot(OnUpdateSB_FileReceiveComplete,2000);
end;

procedure TSerialFileTransferF.WMImageRecvComplete(var Msg: TMessage);
var
  LStream: TMemoryStream;
  LBuf: TByteArray2;
  LMode: Word;
  LP: pointer;
  LFileName: string;
  di: PMultiKlipboardDataItem;
  LBitmap: TBitmap;
  iPictureFormat: Word;
  iPictureHandle: THandle;
  iPalleteHandle: HPALETTE;
  clip: TClipboard;
begin
  LStream := TMemoryStream.Create;
  //LBuf := TByteArray2.Create;
  LBitmap := TBitmap.Create;
  try
    //FPJHTimerPool.RemoveAll;
    //LBuf.CopyByteArray(FRecvFileBuf, FSFTCommThread.FFileSize, Sizeof(TransferRecord));
    FRecvFileBuf.Remove(FSFTCommThread.FFileSize,FRecvFileBuf.Size-FSFTCommThread.FFileSize);
    FRecvFileBuf.SaveToStream(LStream);
    LStream.Seek(0, soFromBeginning);
    ZDecompressStream(LStream, FImageStream);
    FImageStream.Seek(0, soFromBeginning);
    DisplayDataInfo3(FImageStream);

    FPJHTimerPool.AddOneShot(OnUpdateSB_FileReceiveComplete,2000);
    FRecvFileBuf.Clear;
    FSFTCommThread.FReceivedSize := 0;
    SendCommand(MSG_IMAGE_RECV_OK);
    FSFTCommThread.FCurrentState := COMM_STATE(FFSMClass.StateTransition(ord(csImage_Send_Complete)));
  finally
    LBitmap.Free;
    //LBuf.Free;
    LStream.Free;
  end;
end;

procedure TSerialFileTransferF.WMImageSendComplete(var Msg: TMessage);
begin
  //FComPort.ClearBuffer(false,true);
  //SendCommand(MSG_IMAGE_SEND_COMPLETE);
end;

end.
