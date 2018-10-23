unit FrameDragDropOutlook;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Winapi.ActiveX, System.SyncObjs,
  DragDropInternet,DropSource,DragDropFile,DragDropFormats, DragDrop, DropTarget,
  OtlCommon, OtlComm, OtlTaskControl, OtlContainerObserver, otlTask,
  mORMot, SynCommons;

const
  //'{0E39560C-DF72-46E2-BAAA-4C37CE143C77}'을 SHA256으로 hash함(UnitCryptUtil.GetSHA256HashStringFromSyn)
  OL_HASHED_JSON_DRAG_SIGNATURE = 'a274ab5754c5d1bf1e94ccc2fff8f6a753bc90b9d13f342487bac2b265dbf67b';

type
  TProcessVariant = procedure (ADoc: variant) of object;

  TOLDragRecord = record
    FEntryId,
    FStoreId,
    FSender,
    FReceiver,
    FCarbonCopy,
    FBlindCC,
    FSubject,
    FUserEmail,
    FUserName,
    FSavedOLFolderPath: string;
    FReceiveDate: TDateTime;
  end;

  TDragOutlookFrame = class(TFrame)
    DropEmptyTarget1: TDropEmptyTarget;
    DataFormatAdapterOutlook: TDataFormatAdapter;
    DataFormatAdapterTarget: TDataFormatAdapter;
    DataFormatAdapter1: TDataFormatAdapter;
    DropEmptySource1: TDropEmptySource;
    DataFormatAdapter2: TDataFormatAdapter;
    procedure DropEmptyTarget1Drop(Sender: TObject; ShiftState: TShiftState;
      APoint: TPoint; var Effect: Integer);
  private
    FIPCMQFromOL: TOmniMessageQueue;
    FStopEvent    : TEvent;
    FProcessVariant: TProcessVariant;

    procedure OnGetStream(Sender: TFileContentsStreamOnDemandClipboardFormat;
      Index: integer; out AStream: IStream);
    procedure AsyncProcessMQ;
    function ProcessJson(AJson: String): Boolean;
    procedure SetProcessVariant(AProcess: TProcessVariant);
  public
    FJson: String;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SetDropTarget(AWinControl: TWinControl);
  published
    property ProcessVariant: TProcessVariant read FProcessVariant write SetProcessVariant;
  end;

implementation

uses OtlParallel, UnitCryptUtil, UnitDragUtil;

{$R *.dfm}

{ TFrame2 }

procedure TDragOutlookFrame.AsyncProcessMQ;
begin
  Parallel.Async(
    procedure (const task: IOmniTask)
    var
      i: integer;
      handles: array [0..1] of THandle;
      msg    : TOmniMessage;
      rec    : TOLDragRecord;
      LID: TID;
      LTaskIds: TIDDynArray;
      LIsProcessJson: Boolean; //Task정보를 Json파일로 받음
      LStr: string;
    begin
      handles[0] := FStopEvent.Handle;
      handles[1] := FIPCMQFromOL.GetNewMessageEvent;

      while WaitForMultipleObjects(2, @handles, false, INFINITE) = (WAIT_OBJECT_0 + 1) do
      begin
        while FIPCMQFromOL.TryDequeue(msg) do
        begin
          rec := msg.MsgData.ToRecord<TOLDragRecord>;

          if msg.MsgID = 1 then
          begin
            LIsProcessJson := False;
          end
          else
          if msg.MsgID = 2 then
          begin
            LIsProcessJson := False;
          end
          else
          if msg.MsgID = 3 then
          begin
            LStr := rec.FSubject;
            LIsProcessJson := True;
          end;

          task.Invoke(
            procedure
            begin
              if LIsProcessJson then
              begin
                ProcessJson(LStr);
              end;
            end
          );
        end;//while
      end;//while
    end,

    Parallel.TaskConfig.OnMessage(Self).OnTerminated(
      procedure
      begin

      end
    )
  );
end;

constructor TDragOutlookFrame.Create(AOwner: TComponent);
begin
  inherited;

  (DataFormatAdapter2.DataFormat as TVirtualFileStreamDataFormat).OnGetStream := OnGetStream;
  AsyncProcessMQ;
end;

destructor TDragOutlookFrame.Destroy;
begin

  inherited;
end;

procedure TDragOutlookFrame.DropEmptyTarget1Drop(Sender: TObject; ShiftState: TShiftState;
  APoint: TPoint; var Effect: Integer);
var
  LTargetStream: TStream;
  LStr: RawByteString;
  LProcessOK: Boolean;
  LFileName: string;
  rec    : TOLDragRecord;
  LOmniValue: TOmniValue;
begin
  LFileName := '';
  // 윈도우 탐색기에서 Drag 했을 경우
  if (DataFormatAdapter1.DataFormat <> nil) then
  begin
    LFileName := (DataFormatAdapter1.DataFormat as TFileDataFormat).Files.Text;

    if LFileName <> '' then
    begin
      if ExtractFileExt(LFileName) <> '.hgs' then
      begin
        ShowMessage('This file is not auto created by HGS from explorer');
        exit;
      end;

      LStr := StringFromFile(LFileName);
      rec.FSubject := LStr;
      LOmniValue := TOmniValue.FromRecord<TOLDragRecord>(rec);
      FIPCMQFromOL.Enqueue(TOmniMessage.Create(3, LOmniValue));
      exit;
    end;
  end;

  // OutLook에서 첨부파일을 Drag 했을 경우
  if (TVirtualFileStreamDataFormat(DataFormatAdapterTarget.DataFormat).FileNames.Count > 0) then
  begin
    LFileName := TVirtualFileStreamDataFormat(DataFormatAdapterTarget.DataFormat).FileNames[0];

    if ExtractFileExt(LFileName) <> '.msg' then
    begin
      if ExtractFileExt(LFileName) <> '.hgs' then
      begin
        ShowMessage('This file is not auto created by HGS');
        exit;
      end;

      LTargetStream := GetStreamFromDropDataFormat(TVirtualFileStreamDataFormat(DataFormatAdapterTarget.DataFormat));
      try
        if not Assigned(LTargetStream) then
          ShowMessage('Not Assigned');

        LStr := StreamToRawByteString(LTargetStream);

        rec.FSubject := LStr;
        LOmniValue := TOmniValue.FromRecord<TOLDragRecord>(rec);
        FIPCMQFromOL.Enqueue(TOmniMessage.Create(3, LOmniValue));
        exit;
      finally
        if Assigned(LTargetStream) then
          LTargetStream.Free;
      end;
    end;
  end;

  // OutLook에서 메일을 Drag 했을 경우
  if not LProcessOK and (DataFormatAdapterOutlook.DataFormat <> nil) then
  begin
//    SendReqOLEmailInfo;
//    ShowMessage('Outlook Mail Dropped');
  end;
end;

procedure TDragOutlookFrame.OnGetStream(
  Sender: TFileContentsStreamOnDemandClipboardFormat; Index: integer;
  out AStream: IStream);
var
  LStream: TStringStream;
begin
  LStream := TStringStream.Create;
  try
    LStream.WriteString(FJson);
    AStream := nil;
    AStream := TFixedStreamAdapter.Create(LStream, soOwned);
  except
    raise;
  end;
end;

function TDragOutlookFrame.ProcessJson(AJson: String): Boolean;
var
  LDoc: variant;
  LUTF8: RawUTF8;
  LRaw: RawByteString;
  LHullNo, LPONO, LOrderNo: string;
  LIsFromInvoiceManage: Boolean;
begin
  TDocVariant.New(LDoc);
  LRaw := Base64ToBin(StringToUTF8(AJson));
  LRaw := SynLZDecompress(LRaw);
  LUTF8 := LRaw;
  LDoc := _JSON(LUTF8);

  try
    Result := CheckSHA256HashStringFromSyn(LDoc.OutlookJsonDragSign, OL_HASHED_JSON_DRAG_SIGNATURE);
  except
  end;

  if Result then
  begin
    if Assigned(ProcessVariant) then
      ProcessVariant(LDoc);
  end
  else
    ShowMessage('Signature is not correct');
end;

procedure TDragOutlookFrame.SetDropTarget(AWinControl: TWinControl);
begin
  DropEmptyTarget1.Target := AWinControl;
end;

procedure TDragOutlookFrame.SetProcessVariant(AProcess: TProcessVariant);
begin
  FProcessVariant := AProcess;
end;

end.
