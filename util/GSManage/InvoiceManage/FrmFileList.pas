unit FrmFileList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Winapi.Activex, WinApi.ShellAPI,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UnitDM, AdvGlowButton, Vcl.ExtCtrls,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, JvExControls, JvLabel, Vcl.ImgList, FrmFileSelect,
  DragDropInternet,DropSource,DragDropFile,DragDropFormats, DragDrop, DropTarget,
  mORMot, SynCommons, SynSqlite3Static, CommonData, UElecDataRecord;

type
  TFileListF = class(TForm)
    JvLabel13: TJvLabel;
    fileGrid: TNextGrid;
    NxIncrementColumn3: TNxIncrementColumn;
    FileName: TNxTextColumn;
    FileSize: TNxTextColumn;
    FilePath: TNxTextColumn;
    DocType: TNxTextColumn;
    Panel2: TPanel;
    AdvGlowButton6: TAdvGlowButton;
    AdvGlowButton5: TAdvGlowButton;
    ImageList16x16: TImageList;
    DropEmptyTarget1: TDropEmptyTarget;
    DataFormatAdapterTarget: TDataFormatAdapter;
    DataFormatAdapter1: TDataFormatAdapter;
    AdvGlowButton1: TAdvGlowButton;
    AdvGlowButton2: TAdvGlowButton;
    procedure DropEmptyTarget1Drop(Sender: TObject; ShiftState: TShiftState;
      APoint: TPoint; var Effect: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure AdvGlowButton6Click(Sender: TObject);
    procedure AdvGlowButton5Click(Sender: TObject);
    procedure AdvGlowButton1Click(Sender: TObject);
    procedure AdvGlowButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure fileGridCellDblClick(Sender: TObject; ACol, ARow: Integer);
  private
    FFileContent: RawByteString;

    procedure OnGetStream(Sender: TFileContentsStreamOnDemandClipboardFormat;
      Index: integer; out AStream: IStream);
    //Drag하여 파일 추가한 경우 AFileName <> ''
    //Drag를 윈도우 탐색기에서 하면 AFromOutLook=Fase,
    //Outlook 첨부 파일에서 하면 AFromOutLook=True임
    procedure ShowFileSelectF(AFileName: string = ''; AFromOutLook: Boolean = False);

    procedure InvoiceFileRec2Grid(ARec: TSQLInvoiceFileRec; ADynIndex: integer;
      AGrid: TNextGrid);
  public
    FInvoiceFiles_: TSQLInvoiceFile;
//    FSQLInvoiceItem_: TSQLInvoiceItem;
    FItemType: TGSInvoiceItemType;
    FItemID, FTaskID: TID;

    procedure LoadFiles2Grid(AIDList: TIDList4Invoice);
  end;

var
  FileListF: TFileListF;

implementation

uses UnitDragUtil;

{$R *.dfm}

{ TForm5 }

procedure TFileListF.AdvGlowButton1Click(Sender: TObject);
begin
  ShowFileSelectF;
end;

procedure TFileListF.AdvGlowButton2Click(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TFileListF.AdvGlowButton5Click(Sender: TObject);
var
  li : integer;
begin
  with fileGrid do
  begin
    if SelectedRow > -1 then
    begin
      if not(CellByName['FileName',SelectedRow].AsString = '') then
      begin
        if Assigned(FInvoiceFiles_) then
        begin
          FInvoiceFiles_.DynArray('Files').Delete(SelectedRow);
        end;

        DeleteRow(SelectedRow);
      end;
    end;

    SelectedRow := -1;
  end;
end;

procedure TFileListF.AdvGlowButton6Click(Sender: TObject);
begin
  ModalResult := mrCancel;
//  Close;
end;

procedure TFileListF.DropEmptyTarget1Drop(Sender: TObject; ShiftState: TShiftState;
  APoint: TPoint; var Effect: Integer);
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

procedure TFileListF.fileGridCellDblClick(Sender: TObject; ACol, ARow: Integer);
var
  LFileName: string;
  LFileRec: PSQLInvoiceFileRec;
  LData: RawByteString;
begin
  if ARow = -1 then
    exit;

  if High(FInvoiceFiles_.Files) >= ARow then
  begin
    LFileName := 'C:\Temp\'+FileGrid.CellByName['FileName', ARow].AsString;
    LData := FInvoiceFiles_.Files[ARow].fData;
//    LFileRec := PSQLInvoiceFileRec(FileGrid.Row[ARow].Data);
    FileFromString(LData, LFileName, True);

    ShellExecute(handle,'open', PChar(LFileName),nil,nil,SW_NORMAL);
  end;
end;

procedure TFileListF.FormCreate(Sender: TObject);
begin
  FInvoiceFiles_ := nil;
end;

procedure TFileListF.FormDestroy(Sender: TObject);
begin
  if Assigned(FInvoiceFiles_) then
    FInvoiceFiles_.Free;
end;

procedure TFileListF.InvoiceFileRec2Grid(ARec: TSQLInvoiceFileRec;
  ADynIndex: integer; AGrid: TNextGrid);
var
  LRow: integer;
begin
  LRow := AGrid.AddRow();
  AGrid.Row[LRow].ImageIndex := ADynIndex;
  AGrid.CellByName['FileName', LRow].AsString := ARec.fFilename;
  AGrid.CellByName['DocType', LRow].AsString := GSInvoiceItemType2String(ARec.fGSInvoiceItemType);
end;

procedure TFileListF.LoadFiles2Grid(AIDList: TIDList4Invoice);
var
  LSQLInvoiceFileRec: TSQLInvoiceFileRec;
  LRow: integer;
begin
  FItemType := AIDList.ItemType;
  FTaskID := AIDList.TaskId;

  FileGrid.BeginUpdate;
  try
    FileGrid.ClearRows;

    for LRow := Low(FInvoiceFiles_.Files) to High(FInvoiceFiles_.Files) do
    begin
      if FInvoiceFiles_.Files[LRow].fGSInvoiceItemType = FItemType then
        InvoiceFileRec2Grid(FInvoiceFiles_.Files[LRow], LRow, FileGrid);
    end;
  finally
    FileGrid.EndUpdate;
  end;
end;

procedure TFileListF.OnGetStream(Sender: TFileContentsStreamOnDemandClipboardFormat;
  Index: integer; out AStream: IStream);
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
          if Assigned(FInvoiceFiles_) then
          begin
            Data := FInvoiceFiles_.Files[i].fData;
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

procedure TFileListF.ShowFileSelectF(AFileName: string; AFromOutLook: Boolean);
var
  LRow : integer;
  lfilename : String;
  lExt : String;
  lSize : int64;
  LFileSelectF: TFileSelectF;
  LSQLInvoiceFileRec: TSQLInvoiceFileRec;
  LDoc: RawByteString;
  i: integer;
begin
  LFileSelectF := TFileSelectF.Create(nil);
  try
    //Drag 했을 경우 AFileName <> ''이고
    //Task Edit 화면에서 추가 버튼을 눌렀을 경우 AFileName = ''임
    if AFileName <> '' then
      LFileSelectF.JvFilenameEdit1.FileName := AFileName;

    LFileSelectF.ComboBox1.Text := GSInvoiceItemType2String(FItemType);
    LFileSelectF.ComboBox1.Enabled := False;

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
          LSQLInvoiceFileRec.fGSInvoiceItemType := String2GSInvoiceItemType(LFileSelectF.ComboBox1.Text);
          LSQLInvoiceFileRec.fFilename := lfilename;

          if not Assigned(FInvoiceFiles_) then
            FInvoiceFiles_ := TSQLInvoiceFile.Create;

          i := FInvoiceFiles_.DynArray('Files').Add(LSQLInvoiceFileRec);

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

end.
