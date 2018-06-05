unit FrmOLMailTitleChanger;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxColumnClasses, NxColumns, ActiveX,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.StdCtrls,
  Vcl.ExtCtrls, DropSource, DragDrop, DropTarget, DragDropFile, SynCommons,
  AdvGlowButton, Vcl.ImgList, System.Win.ComObj, MapiDefs, UnitMAPIMessage,
  Vcl.Menus;

type
  TOLMailTitleChangeF = class(TForm)
    DropEmptyTarget1: TDropEmptyTarget;
    DataFormatAdapterTarget: TDataFormatAdapter;
    DropEmptySource1: TDropEmptySource;
    DataFormatAdapter2: TDataFormatAdapter;
    Panel1: TPanel;
    Label2: TLabel;
    Edit1: TEdit;
    fileGrid: TNextGrid;
    NxIncrementColumn3: TNxIncrementColumn;
    FileName: TNxTextColumn;
    FileSize: TNxTextColumn;
    ImageList16x16: TImageList;
    Panel2: TPanel;
    AdvGlowButton5: TAdvGlowButton;
    FileContent: TNxMemoColumn;
    AdvGlowButton6: TAdvGlowButton;
    DataFormatAdapterOutlook: TDataFormatAdapter;
    PopupMenu1: TPopupMenu;
    GetSubject1: TMenuItem;
    SaveDialog1: TSaveDialog;
    SaveToFile1: TMenuItem;
    procedure DropEmptyTarget1Drop(Sender: TObject; ShiftState: TShiftState;
      APoint: TPoint; var Effect: Integer);
    procedure FormCreate(Sender: TObject);
    procedure AdvGlowButton5Click(Sender: TObject);
    procedure AdvGlowButton6Click(Sender: TObject);
    procedure fileGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure fileGridSelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure GetSubject1Click(Sender: TObject);
    procedure SaveToFile1Click(Sender: TObject);
  private
    FFileContent: RawByteString;
    FCurrentMessage: TMAPIMessage;
    FHasMessageSession: boolean;

    procedure OnGetStream(Sender: TFileContentsStreamOnDemandClipboardFormat;
      Index: integer; out AStream: IStream);

    procedure SaveToMsgFile(AFileName: string='');
    procedure DragedFile2Grid(AFileName: string);
    function GetSubject(const AMessage: IMessage): string;
    procedure SetSubject(const AMessage: IMessage; ASubject: string);
    procedure SetAttachFileName(const AMessage: IMessage; AFileName: string);
    procedure SetDisplayName(const AMessage: IMessage; ADispName: string);
    procedure SetConversationTopic(const AMessage: IMessage; ADispName: string);
    procedure ReSetSentMailEntryID(const AMessage: IMessage);
    function GetSentMailEntryID(const AMessage: IMessage): integer;
    procedure DeleteTMAPIMessageFromGridData(ARow: integer);
    procedure CleanUpGridData;
    procedure CleanUpSession;
  public
    { Public declarations }
  end;

var
  OLMailTitleChangeF: TOLMailTitleChangeF;

implementation

uses UnitDragUtil, UnitBase64Util, DragDropFormats, DragDropInternet, MapiTags,
  MAPIUtil;

{$R *.dfm}

procedure TOLMailTitleChangeF.AdvGlowButton5Click(Sender: TObject);
var
  li : integer;
begin
  with fileGrid do
  begin
    if SelectedRow > -1 then
    begin
      if not(CellByName['FileName',SelectedRow].AsString = '') then
      begin
        DeleteTMAPIMessageFromGridData(SelectedRow);
        DeleteRow(SelectedRow);
      end;
    end;

    SelectedRow := -1;
  end;
end;

procedure TOLMailTitleChangeF.AdvGlowButton6Click(Sender: TObject);
begin
  Close;
end;

procedure TOLMailTitleChangeF.CleanUpGridData;
var
  i: integer;
begin
  for i := 0 to fileGrid.RowCount - 1 do
  begin
    DeleteTMAPIMessageFromGridData(i);
  end;
end;

procedure TOLMailTitleChangeF.CleanUpSession;
var
  OutlookDataFormat: TOutlookDataFormat;
begin
  FCurrentMessage := nil;
  if (FHasMessageSession) then
  begin
    OutlookDataFormat := DataFormatAdapterOutlook.DataFormat as TOutlookDataFormat;
    OutlookDataFormat.Messages.UnlockSession;
    FHasMessageSession := False;
  end;
end;

procedure TOLMailTitleChangeF.DeleteTMAPIMessageFromGridData(ARow: integer);
begin
  if ARow < 0 then
    exit;

  if Assigned(fileGrid.Row[ARow].Data) then
    TObject(fileGrid.Row[ARow].Data).Free;
end;

procedure TOLMailTitleChangeF.DragedFile2Grid(AFileName: string);
var
  LDoc: variant;
  LUtf8: RawUTF8;
begin
  with fileGrid do
  begin
    BeginUpdate;
    try
      LUtf8 := MakeRawByteStringToBin64(FFileContent);
      AddRow;
      CellByName['FileName',RowCount-1].AsString := AFileName;
      CellByName['FileContent',RowCount-1].AsString := UTF8ToString(Lutf8);
      CellByName['FileSize',RowCount-1].AsString := IntToStr(Length(FFileContent));
//      LUTf8 := StringToUTF8(CellByName['FileContent',RowCount-1].AsString);
//      FFileContent := MakeBase64ToUTF8(LUtf8);
    finally
      EndUpdate;
    end;
  end;
end;

procedure TOLMailTitleChangeF.DropEmptyTarget1Drop(Sender: TObject; ShiftState: TShiftState;
  APoint: TPoint; var Effect: Integer);
var
  i, LRow: integer;
  LFileName: string;
  LTargetStream: TStream;
  OutlookDataFormat: TOutlookDataFormat;
  AMessage: IMessage;
begin
  //OutLook Mail을 Drag 했을 경우
  if (DataFormatAdapterOutlook.DataFormat <> nil) then
  begin
    OutlookDataFormat := DataFormatAdapterOutlook.DataFormat as TOutlookDataFormat;
    OutlookDataFormat.Messages.LockSession;
    FHasMessageSession := True;
    try
      for i := 0 to OutlookDataFormat.Messages.Count-1 do
      begin
        // Get an IMessage interface
        if (Supports(OutlookDataFormat.Messages[i], IMessage, AMessage)) then
        begin
          try
            with fileGrid do
            begin
              BeginUpdate;
              try
                LRow := AddRow;
  //              SetDisplayName(AMessage,'aaa');
                SetSubject(AMessage,'aaa');
//                SetConversationTopic(AMessage,'aaa');
  //              SetDisplayName(AMessage,'aaa');
                CellByName['FileName',LRow].AsString := GetSubject(AMessage);
                CellByName['FileSize',LRow].AsInteger := GetSentMailEntryID(AMessage);
                Row[LRow].Data := TMAPIMessage.Create(AMessage, OutlookDataFormat.Storages[i]);
                ReSetSentMailEntryID(AMessage);
  //              FCurrentMessage := TMAPIMessage(Row[LRow].Data);
  //              GetSubject(FCurrentMessage.Msg);
              finally
                EndUpdate;
              end;
            end;
          finally
            AMessage := nil;
          end;
        end;
      end;
    finally
//      OutlookDataFormat.Messages.UnLockSession;
    end;
  end;

//  // OutLook에서 첨부파일을 Drag 했을 경우
//  if (TVirtualFileStreamDataFormat(DataFormatAdapterTarget.DataFormat).FileNames.Count > 0) then
//  begin
//    LFileName := TVirtualFileStreamDataFormat(DataFormatAdapterTarget.DataFormat).FileNames[0];
//    LTargetStream := GetStreamFromDropDataFormat(TVirtualFileStreamDataFormat(DataFormatAdapterTarget.DataFormat));
//    try
//      if not Assigned(LTargetStream) then
//        ShowMessage('Not Assigned');
//
//      FFileContent := StreamToRawByteString(LTargetStream);
//    finally
//      if Assigned(LTargetStream) then
//        LTargetStream.Free;
//    end;
//  end;

//  DragedFile2Grid(LFileName);
end;

procedure TOLMailTitleChangeF.fileGridMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i: integer;
  LFileName: string;
  LMessage: TMAPIMessage;
begin
  if (FileGrid.SelectedCount > 0) and
    (DragDetectPlus(FileGrid.Handle, Point(X,Y))) then
  begin
    TVirtualFileStreamDataFormat(DataFormatAdapter2.DataFormat).FileNames.Clear;
    for i := 0 to FileGrid.RowCount - 1 do
      if (FileGrid.Row[i].Selected) then
      begin
        LFileName := Edit1.Text;

        if LFileName = '' then
          LFileName := FileGrid.CellByName['FileName',i].AsString;
//        else
//          LFileName := ChangeFileExt(LFileName, '.msg');

//        LMessage := TMAPIMessage(FileGrid.Row[i].Data);
//        SetSubject(LMessage.Msg, LFileName);
        TVirtualFileStreamDataFormat(DataFormatAdapter2.DataFormat).
          FileNames.Add(LFileName);
        break;
      end;

    DropEmptySource1.Execute;
  end;
end;

procedure TOLMailTitleChangeF.fileGridSelectCell(Sender: TObject; ACol,
  ARow: Integer);
begin
  FCurrentMessage := TMAPIMessage(fileGrid.Row[ARow].Data);
end;

procedure TOLMailTitleChangeF.FormCreate(Sender: TObject);
begin
  (DataFormatAdapter2.DataFormat as TVirtualFileStreamDataFormat).OnGetStream := OnGetStream;

  LoadMAPI32;

  try
    OleCheck(MAPIInitialize(@MapiInit));
  except
    on E: Exception do
      ShowMessage(Format('Failed to initialize MAPI: %s', [E.Message]));
  end;
end;

procedure TOLMailTitleChangeF.FormDestroy(Sender: TObject);
begin
  CleanUpGridData;
  MAPIUninitialize;
end;

function TOLMailTitleChangeF.GetSentMailEntryID(
  const AMessage: IMessage): integer;
var
  Prop: PSPropValue;
begin
  if (Succeeded(HrGetOneProp(AMessage, PR_SENTMAIL_ENTRYID, Prop))) then
  begin
    try
//      Prop.ulPropTag := PR_SUBJECT;
      Result := Prop.Value.bin.cb;
//      Prop.Value.bin.lpb := nil;
//      HrSetOneProp(AMessage, Prop);
    finally
      MAPIFreeBuffer(Prop);
    end
  end;
end;

function TOLMailTitleChangeF.GetSubject(const AMessage: IMessage): string;
var
  Prop: PSPropValue;
begin
  //PR_SUBJECT_IPM, PR_SUBJECT_PREFIX, PR_ORIGINAL_SUBJECT는 모두 공란임
  // PR_SUBJECT, PR_NORMALIZED_SUBJECT
  if (Succeeded(HrGetOneProp(AMessage, PR_SUBJECT, Prop))) then
    try
      if (Prop.ulPropTag and PT_UNICODE = PT_UNICODE) then
        { TODO : TSPropValue.Value.lpszW is declared wrong }
        Result := String(PWideChar(Prop.Value.lpszW))
      else
        Result := String(Prop.Value.lpszA);
    finally
      MAPIFreeBuffer(Prop);
    end
  else
    Result := '';
end;

procedure TOLMailTitleChangeF.GetSubject1Click(Sender: TObject);
begin
  FCurrentMessage := TMAPIMessage(fileGrid.Row[fileGrid.SelectedRow].Data);
  ShowMessage(GetSubject(FCurrentMessage.Msg));
end;

procedure TOLMailTitleChangeF.OnGetStream(Sender: TFileContentsStreamOnDemandClipboardFormat;
  Index: integer; out AStream: IStream);
var
  Stream: TMemoryStream;
  Data: RawByteString;
  i: integer;
  SelIndex: integer;
  Found: boolean;
  LUtf8: RawUTF8;
begin
  Stream := TMemoryStream.Create;
  try
    AStream := nil;
    SelIndex := 0;
    Found := False;

    for i := 0 to FileGrid.RowCount-1 do
      if (FileGrid.Row[i].Selected) then
      begin
        if (SelIndex = Index) then
        begin
          TMAPIMessage(FileGrid.Row[i].Data).SaveToStream(Stream);
//          LUTf8 := StringToUTF8(FileGrid.CellByName['FileContent',i].AsString);
//          Data := MakeBase64ToUTF8(LUtf8);
          Found := True;
          break;
        end;
        inc(SelIndex);
      end;
    if (not Found) then
      exit;

//    Stream.Write(PAnsiChar(Data)^, Length(Data));
    AStream := TFixedStreamAdapter.Create(Stream, soOwned);
  except
    Stream.Free;
    raise;
  end;
end;

procedure TOLMailTitleChangeF.ReSetSentMailEntryID(const AMessage: IMessage);
var
  Prop: PSPropValue;
begin
  if (Succeeded(HrGetOneProp(AMessage, PR_SENTMAIL_ENTRYID, Prop))) then
  begin
    try
//      Prop.ulPropTag := PR_SUBJECT;
      Prop.Value.bin.cb := 0;
      Prop.Value.bin.lpb := nil;
      HrSetOneProp(AMessage, Prop);
//        PWideChar(Prop.Value.lpszW) := Addr(ASubject[1]) //PWideChar()
    finally
      MAPIFreeBuffer(Prop);
    end
  end;
end;

procedure TOLMailTitleChangeF.SaveToFile1Click(Sender: TObject);
begin
  SaveToMsgFile;
end;

procedure TOLMailTitleChangeF.SaveToMsgFile(AFileName: string);
var
  Dest: TFileStream;
  Prop: PSPropValue;
  Filename: AnsiString;
  p: PAnsiChar;
begin
  // Use message subject as default file name
  if (Succeeded(HrGetOneProp(FCurrentMessage.Msg, PR_SUBJECT_A, Prop))) then
  begin
    Filename := Prop.Value.lpszA;

    p := PAnsiChar(Filename);
    while (p^ <> #0) do
    begin
      if (p^ in ['*', '?', ':', '/', '\']) then
        p^:= ' ';
      inc(p);
    end;

    if AFileName <> '' then
      SaveDialog1.Filename := AFileName
    else
      SaveDialog1.Filename := String(Filename);
  end else
    SaveDialog1.Filename := 'Message';

  if (SaveDialog1.Execute) then
  begin
    Dest := TFileStream.Create(SaveDialog1.FileName, fmCreate);
    try
      FCurrentMessage.SaveToStream(Dest);
    finally
      Dest.Free;
    end;
  end;
end;

procedure TOLMailTitleChangeF.SetAttachFileName(const AMessage: IMessage;
  AFileName: string);
var
  Prop: PSPropValue;
begin
  if (Succeeded(HrGetOneProp(AMessage, PR_ATTACH_FILENAME, Prop))) then //PR_ATTACH_FILENAME
  begin
    try
      if (Prop.ulPropTag and PT_UNICODE = PT_UNICODE) then
      begin
        Prop.ulPropTag := PR_ATTACH_LONG_FILENAME;
        PWideChar(Prop.Value.lpszW) := Addr(AFileName[1]);
        HrSetOneProp(AMessage, Prop);
//        PWideChar(Prop.Value.lpszW) := Addr(ASubject[1]) //PWideChar()
      end
      else
        Prop.Value.lpszA := Addr(AFileName[1]);
    finally
      MAPIFreeBuffer(Prop);
    end
  end;
end;

procedure TOLMailTitleChangeF.SetConversationTopic(const AMessage: IMessage;
  ADispName: string);
var
  Prop: PSPropValue;
begin
  if (Succeeded(HrGetOneProp(AMessage, PR_CONVERSATION_TOPIC, Prop))) then
  begin
    try
      if (Prop.ulPropTag and PT_UNICODE = PT_UNICODE) then
      begin
//        Prop.ulPropTag := PR_SUBJECT;
        PWideChar(Prop.Value.lpszW) := StrPCopy(PWideChar(Prop.Value.lpszW), ADispName);
        HrSetOneProp(AMessage, Prop);
      end
      else
        Prop.Value.lpszA := Addr(ADispName[1]);
    finally
      MAPIFreeBuffer(Prop);
    end
  end;
end;

procedure TOLMailTitleChangeF.SetDisplayName(const AMessage: IMessage;
  ADispName: string);
var
  Prop: PSPropValue;
begin
  if (Succeeded(HrGetOneProp(AMessage, PR_DISPLAY_NAME, Prop))) then
  begin
    try
      if (Prop.ulPropTag and PT_UNICODE = PT_UNICODE) then
      begin
//        Prop.ulPropTag := PR_DISPLAY_NAME;
        PWideChar(Prop.Value.lpszW) := StrPCopy(PWideChar(Prop.Value.lpszW), ADispName);
//        PWideChar(Prop.Value.lpszW) := Addr(ADispName[1]);
        HrSetOneProp(AMessage, Prop);
      end
      else
        Prop.Value.lpszA := Addr(ADispName[1]);
    finally
      MAPIFreeBuffer(Prop);
    end
  end;
end;

procedure TOLMailTitleChangeF.SetSubject(const AMessage: IMessage;
  ASubject: string);
var
  Prop: PSPropValue;
begin
  if (Succeeded(HrGetOneProp(AMessage, PR_SUBJECT, Prop))) then//PR_NORMALIZED_SUBJECT   PR_SUBJECT
  begin
    try
      if (Prop.ulPropTag and PT_UNICODE = PT_UNICODE) then
      begin
//        Prop.ulPropTag := PR_SUBJECT;
        PWideChar(Prop.Value.lpszW) := StrPCopy(PWideChar(Prop.Value.lpszW), ASubject);
//        Prop.Value.lpszW := ASubject;
        HrSetOneProp(AMessage, Prop);
//        PWideChar(Prop.Value.lpszW) := Addr(ASubject[1]) //PWideChar()
      end
      else
        Prop.Value.lpszA := Addr(ASubject[1]);
    finally
      MAPIFreeBuffer(Prop);
    end
  end;
end;

end.
