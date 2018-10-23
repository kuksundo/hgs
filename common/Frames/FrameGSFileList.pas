unit FrameGSFileList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Winapi.Activex, WinApi.ShellAPI,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvGlowButton, Vcl.ExtCtrls,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, JvExControls, JvLabel, Vcl.ImgList, FrmFileSelect,
  DragDropInternet,DropSource,DragDropFile,DragDropFormats, DragDrop, DropTarget,
  mORMot, SynCommons, SynSqlite3Static, UnitGSFileRecord;

type
  TGSFileListFrame = class(TFrame)
    JvLabel13: TJvLabel;
    fileGrid: TNextGrid;
    NxIncrementColumn3: TNxIncrementColumn;
    FileName: TNxTextColumn;
    FileSize: TNxTextColumn;
    FilePath: TNxTextColumn;
    DocType: TNxTextColumn;
    Panel2: TPanel;
    CloseButton: TAdvGlowButton;
    DeleteButton: TAdvGlowButton;
    AddButton: TAdvGlowButton;
    ApplyButton: TAdvGlowButton;
    ImageList16x16: TImageList;
    DropEmptyTarget1: TDropEmptyTarget;
    DataFormatAdapterTarget: TDataFormatAdapter;
    DataFormatAdapter1: TDataFormatAdapter;
    DropEmptySource1: TDropEmptySource;
    DataFormatAdapter2: TDataFormatAdapter;
    Timer1: TTimer;
    DataFormatAdapter3: TDataFormatAdapter;
    procedure DropEmptyTarget1Drop(Sender: TObject; ShiftState: TShiftState;
      APoint: TPoint; var Effect: Integer);
    procedure DropEmptyTarget1Drop2(Sender: TObject; ShiftState: TShiftState;
      APoint: TPoint; var Effect: Integer);
    procedure DeleteButtonClick(Sender: TObject);
    procedure AddButtonClick(Sender: TObject);
    procedure fileGridCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure fileGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
  private
    FFileContent: RawByteString;
    FTempFileList: TStringList;

    procedure OnGetStream(Sender: TFileContentsStreamOnDemandClipboardFormat;
      Index: integer; out AStream: IStream);
    procedure OnGetStream2(Sender: TFileContentsStreamOnDemandClipboardFormat;
      Index: integer; out AStream: IStream);
    //Drag하여 파일 추가한 경우 AFileName <> ''
    //Drag를 윈도우 탐색기에서 하면 AFromOutLook=Fase,
    //Outlook 첨부 파일에서 하면 AFromOutLook=True임
    procedure ShowFileSelectF(AFileName: string = ''; AFromOutLook: Boolean = False);
    procedure ShowFileSelectF2(AFileName: string = ''; AFromOutLook: Boolean = False);

    procedure GSFileRec2Grid(ARec: TSQLGSFileRec; ADynIndex: integer;
      AGrid: TNextGrid);
  public
    FGSFiles_: TSQLGSFile;
    FItemID, FTaskID: TID;
    FTaskJson: String;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure InitDragDrop;
    procedure LoadFiles2Grid(AIDList: TIDList4GSFile); overload;
    procedure LoadFiles2Grid; overload;
    procedure SQLGSFileCopy(ASrc: TSQLGSFile; out ADest: TSQLGSFile);
  end;

implementation

uses UnitDragUtil, UnitElecServiceData, UnitStringUtil;

{$R *.dfm}

{ TFrame2 }

procedure TGSFileListFrame.AddButtonClick(Sender: TObject);
begin
  ShowFileSelectF;
end;

procedure TGSFileListFrame.DeleteButtonClick(Sender: TObject);
var
  li : integer;
begin
  with fileGrid do
  begin
    if SelectedRow > -1 then
    begin
      if not(CellByName['FileName',SelectedRow].AsString = '') then
      begin
        if MessageDlg('Aru you sure delete the selected item?.', mtConfirmation, [mbYes, mbNo],0) = mrYes then
        begin
          if Assigned(FGSFiles_) then
          begin
            li := Row[SelectedRow].ImageIndex;
            FGSFiles_.DynArray('Files').Delete(li);
          end;

          DeleteRow(SelectedRow);
        end;
      end;
    end;

    SelectedRow := -1;
  end;
end;

constructor TGSFileListFrame.Create(AOwner: TComponent);
begin
  inherited;

  FTempFileList := TStringList.Create;
  FGSFiles_ := nil;
end;

destructor TGSFileListFrame.Destroy;
var
  i: integer;
begin
  if Assigned(FGSFiles_) then
    FGSFiles_.Free;

  inherited;

  try
    for i := 0 to FTempFileList.Count - 1 do
    begin
      try
        DeleteFile(FTempFileList.Strings[i]);
      except

      end;
    end;
  finally
    FTempFileList.Free;
  end;
end;

procedure TGSFileListFrame.DropEmptyTarget1Drop(Sender: TObject;
  ShiftState: TShiftState; APoint: TPoint; var Effect: Integer);
var
  i: integer;
  LFileName: string;
  LFromOutlook: Boolean;
  LTargetStream: TStream;
begin
  LFileName := '';
  // 윈도우 탐색기에서 Drag 했을 경우
  if (DataFormatAdapter1.DataFormat <> nil) then
  begin
    LFileName := (DataFormatAdapter1.DataFormat as TFileDataFormat).Files.Text;

    if LFileName <> '' then
    begin
      FFileContent := StringFromFile(LFileName);
//      LFromOutlook := False;
    end;
  end;

  // OutLook에서 첨부파일을 Drag 했을 경우
  if (TVirtualFileStreamDataFormat(DataFormatAdapterTarget.DataFormat).FileNames.Count > 0) then
  begin
    LFileName := TVirtualFileStreamDataFormat(DataFormatAdapterTarget.DataFormat).FileNames[0];
    LTargetStream := GetStreamFromDropDataFormat(TVirtualFileStreamDataFormat(DataFormatAdapterTarget.DataFormat));
    try
      if not Assigned(LTargetStream) then
        ShowMessage('Not Assigned');

      FFileContent := StreamToRawByteString(LTargetStream);
      LFromOutlook := True;
    finally
      if Assigned(LTargetStream) then
        LTargetStream.Free;
    end;
  end;

  if LFileName <> '' then
  begin
    LFileName.Replace('"','');
    ShowFileSelectF(LFileName, LFromOutlook);
  end;
end;

procedure TGSFileListFrame.DropEmptyTarget1Drop2(Sender: TObject;
  ShiftState: TShiftState; APoint: TPoint; var Effect: Integer);
var
  i: integer;
  LFileName: string;
  LFromOutlook: Boolean;
  LTargetStream: TStream;
begin
  LFileName := '';
  // 윈도우 탐색기에서 Drag 했을 경우
  if TFileDataFormat(DataFormatAdapter1.DataFormat).Files.Count > 0 then
    LFileName := (DataFormatAdapter1.DataFormat as TFileDataFormat).Files.Text;

  // OutLook에서 첨부파일을 Drag 했을 경우
  if (TVirtualFileStreamDataFormat(DataFormatAdapterTarget.DataFormat).FileNames.Count > 0) then
  begin
    LFileName := TVirtualFileStreamDataFormat(DataFormatAdapterTarget.DataFormat).FileNames.Text;
    LFromOutlook := True;
  end;

  if LFileName <> '' then
  begin
    LFileName.Replace('"','');
    ShowFileSelectF2(LFileName, LFromOutlook);
  end;
end;

procedure TGSFileListFrame.fileGridCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
var
  LFileName: string;
  LFileRec: PSQLGSFileRec;
  LData: RawByteString;
begin
  if ARow = -1 then
    exit;

  if High(FGSFiles_.Files) >= ARow then
  begin
    LFileName := 'C:\Temp\'+FileGrid.CellByName['FileName', ARow].AsString;
    FTempFileList.Add(LFileName);
    LData := FGSFiles_.Files[ARow].fData;
//    LFileRec := PSQLInvoiceFileRec(FileGrid.Row[ARow].Data);
    FileFromString(LData, LFileName, True);

    ShellExecute(handle,'open', PChar(LFileName),nil,nil,SW_NORMAL);
  end;
end;

procedure TGSFileListFrame.fileGridMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i: integer;
  LFileName: string;
begin
  if (DragDetectPlus(fileGrid.Handle, Point(X,Y))) then
  begin
    if fileGrid.SelectedRow = -1 then
      exit;

    TVirtualFileStreamDataFormat(DataFormatAdapter2.DataFormat).FileNames.Clear;
    LFileName := fileGrid.CellsByName['FileName',fileGrid.SelectedRow];;

    if LFileName <> '' then
      //파일 이름에 공란이 들어가면 OnGetStream 함수를 안 탐
      TVirtualFileStreamDataFormat(DataFormatAdapter2.DataFormat).
            FileNames.Add(LFileName);

    DropEmptySource1.Execute;
  end;
end;

procedure TGSFileListFrame.GSFileRec2Grid(ARec: TSQLGSFileRec; ADynIndex: integer;
  AGrid: TNextGrid);
var
  LRow: integer;
begin
  LRow := AGrid.AddRow();
//  AGrid.Row[LRow].Data := TIDList4Invoice.Create;
//  TIDList4Invoice(AGrid.Row[LRow].Data).ItemAction := -1;
  AGrid.Row[LRow].ImageIndex := ADynIndex;
  AGrid.CellByName['FileName', LRow].AsString := ARec.fFilename;
  AGrid.CellByName['FileSize',LRow].AsString := FormatByteString(ARec.fFileSize);
//  AGrid.CellByName['DocType', LRow].AsString := GSInvoiceItemType2String(ARec.fGSInvoiceItemType);
end;

procedure TGSFileListFrame.InitDragDrop;
begin
  (DataFormatAdapter2.DataFormat as TVirtualFileStreamDataFormat).OnGetStream := OnGetStream;
  (DataFormatAdapter3.DataFormat as TVirtualFileStreamDataFormat).OnGetStream := OnGetStream2;
end;

procedure TGSFileListFrame.LoadFiles2Grid;
var
  LRow: integer;
begin
  FileGrid.BeginUpdate;
  try
    FileGrid.ClearRows;

    for LRow := Low(FGSFiles_.Files) to High(FGSFiles_.Files) do
    begin
      GSFileRec2Grid(FGSFiles_.Files[LRow], LRow, FileGrid);
    end;
  finally
    FileGrid.EndUpdate;
  end;
end;

procedure TGSFileListFrame.LoadFiles2Grid(AIDList: TIDList4GSFile);
var
//  LSQLGSFileRec: TSQLGSFileRec;
  LRow: integer;
begin
  FTaskID := AIDList.TaskId;

  FileGrid.BeginUpdate;
  try
    FileGrid.ClearRows;

    for LRow := Low(FGSFiles_.Files) to High(FGSFiles_.Files) do
    begin
      GSFileRec2Grid(FGSFiles_.Files[LRow], LRow, FileGrid);
    end;
  finally
    FileGrid.EndUpdate;
  end;
end;

procedure TGSFileListFrame.OnGetStream(
  Sender: TFileContentsStreamOnDemandClipboardFormat; Index: integer;
  out AStream: IStream);
var
  Stream: TMemoryStream;
  Data: AnsiString;
  i: integer;
  SelIndex: integer;
  Found: boolean;
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
          if Assigned(FGSFiles_) then
          begin
            Data := FGSFiles_.Files[i].fData;
            Found := True;
            break;
          end;
        end;
        inc(SelIndex);
      end;
    if (not Found) then
      exit;

    Stream.Write(PAnsiChar(Data)^, Length(Data));
    AStream := TFixedStreamAdapter.Create(Stream, soOwned);
  except
    Stream.Free;
    raise;
  end;
end;

procedure TGSFileListFrame.OnGetStream2(
  Sender: TFileContentsStreamOnDemandClipboardFormat; Index: integer;
  out AStream: IStream);
var
  LStream: TStringStream;
begin
  LStream := TStringStream.Create;
  try
    LStream.WriteString(FTaskJson);
    AStream := nil;
    AStream := TFixedStreamAdapter.Create(LStream, soOwned);
  except
    raise;
  end;
end;

procedure TGSFileListFrame.ShowFileSelectF(AFileName: string; AFromOutLook: Boolean);
var
  LRow : integer;
  lfilename : String;
  lExt : String;
  lSize : int64;
  LFileSelectF: TFileSelectF;
  LSQLInvoiceFileRec: TSQLGSFileRec;
  LDoc: RawByteString;
  i: integer;
begin
  LFileSelectF := TFileSelectF.Create(nil);
  try
    //Drag 했을 경우 AFileName <> ''이고
    //Task Edit 화면에서 추가 버튼을 눌렀을 경우 AFileName = ''임
    if AFileName <> '' then
      LFileSelectF.JvFilenameEdit1.FileName := AFileName;

    LFileSelectF.ComboBox1.Visible := False;
    LFileSelectF.Label1.Visible := False;

    if LFileSelectF.ShowModal = mrOK then
    begin
      if LFileSelectF.JvFilenameEdit1.FileName = '' then
        exit;

      lfilename := ExtractFileName(LFileSelectF.JvFilenameEdit1.FileName);

      with fileGrid do
      begin
        BeginUpdate;
        try
          if AFileName <> '' then
            LDoc := FFileContent
          else
            LDoc := StringFromFile(LFileSelectF.JvFilenameEdit1.FileName);

          LSQLInvoiceFileRec.fData := LDoc;
          LSQLInvoiceFileRec.fFilename := lfilename;

          if not Assigned(FGSFiles_) then
            FGSFiles_ := TSQLGSFile.Create;

          i := FGSFiles_.DynArray('Files').Add(LSQLInvoiceFileRec);

          LRow := AddRow;
          Row[LRow].ImageIndex := i; //DynArray의 Index를 저장함(Delete시 필요함)

          CellByName['FileName',LRow].AsString := lfilename;
          CellByName['FileSize',LRow].AsString := IntToStr(lsize);
          CellByName['FilePath',LRow].AsString := LFileSelectF.JvFilenameEdit1.FileName;
          CellByName['DocType',LRow].AsString := LFileSelectF.ComboBox1.Text;
        finally
          EndUpdate;
        end;
      end;
    end;
  finally
    LFileSelectF.Free;
  end;
end;

procedure TGSFileListFrame.ShowFileSelectF2(AFileName: string;
  AFromOutLook: Boolean);
var
  li,LRow : integer;
  lfilename : String;
  lExt : String;
  lSize : int64;
  LFileSelectF: TFileSelectF;
  LSQLGSFileRec: TSQLGSFileRec;
  LDoc: RawByteString;
  i: integer;
  LFileNameList: TStringList;
  LTargetStream: TStream;
begin
  LFileSelectF := TFileSelectF.Create(nil);
  LFileNameList := TStringList.Create;
  try
    //Drag 했을 경우 AFileName <> ''이고
    //Task Edit 화면에서 추가 버튼을 눌렀을 경우 AFileName = ''임
    if AFileName <> '' then
    begin
      LFileNameList.Text := AFileName;
      LFileSelectF.JvFilenameEdit1.FileName := AFileName;
    end;

    g_GSDocType.SetType2Combo(LFileSelectF.ComboBox1);

    if LFileSelectF.ShowModal = mrOK then
    begin
      if LFileSelectF.JvFilenameEdit1.FileName = '' then
        exit;

      with fileGrid do
      begin
        BeginUpdate;
        try
          for li := 0 to LFileNameList.Count - 1 do
          begin
            LFileName := LFileNameList.Strings[li];

            if AFromOutLook then
            begin
              LTargetStream := GetStreamFromDropDataFormat2(TVirtualFileStreamDataFormat(DataFormatAdapterTarget.DataFormat),li);
              try
                if not Assigned(LTargetStream) then
                  ShowMessage('Not Assigned');

                LDoc := StreamToRawByteString(LTargetStream);
              finally
                if Assigned(LTargetStream) then
                  LTargetStream.Free;
              end;
            end
            else
              LDoc := StringFromFile(LFileName);

            LFileName := ExtractFileName(LFileName);

            LSQLGSFileRec.fData := LDoc;
            LSQLGSFileRec.fGSDocType := g_GSDocType.ToOrdinal(LFileSelectF.ComboBox1.Text);
            LSQLGSFileRec.fFilename := LFileName;
            LSQLGSFileRec.fFileSize := Length(LDoc);//ByteLength(LDoc);//

            if not Assigned(FGSFiles_) then
              FGSFiles_ := TSQLGSFile.Create;

            i := FGSFiles_.DynArray('Files').Add(LSQLGSFileRec);
            LRow := AddRow;
            CellByName['FileName',LRow].AsString := LFileName;
            CellByName['FileSize',LRow].AsString := FormatByteString(LSQLGSFileRec.fFileSize);
            CellByName['FilePath',LRow].AsString := ExtractFilePath(LFileName);
            CellByName['DocType',LRow].AsString := LFileSelectF.ComboBox1.Text;
          end;

        finally
          EndUpdate;
        end;
      end;
    end;
  finally
    LFileNameList.Free;
    LFileSelectF.Free;
  end;
end;

procedure TGSFileListFrame.SQLGSFileCopy(ASrc: TSQLGSFile;
  out ADest: TSQLGSFile);
var
  LRow: integer;
  LSQLGSFileRec: TSQLGSFileRec;
begin
  while ASrc.FillOne do
  begin
    for LRow := Low(ASrc.Files) to High(ASrc.Files) do
    begin
      LSQLGSFileRec.fFilename := ASrc.Files[LRow].fFilename;
      LSQLGSFileRec.fGSDocType := ASrc.Files[LRow].fGSDocType;
      LSQLGSFileRec.fData := ASrc.Files[LRow].fData;

      ADest.DynArray('Files').Add(LSQLGSFileRec);
    end;
  end;
end;

procedure TGSFileListFrame.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;

  (DataFormatAdapter2.DataFormat as TVirtualFileStreamDataFormat).OnGetStream := OnGetStream;
end;

end.
