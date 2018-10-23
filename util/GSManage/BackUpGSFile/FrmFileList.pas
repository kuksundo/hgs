unit FrmFileList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.ImgList, AdvGlowButton,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, JvExControls, JvLabel,
  DragDropInternet,DropSource,DragDropFile,DragDropFormats, DragDrop, DropTarget,
  mORMot, SynCommons, SynSqlite3Static, FrameGSFileList, UnitFileListRecord;

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
    procedure Timer1Timer(Sender: TObject);
  private
    FFileContent: RawByteString;
    FTempFileList: TStringList;

    procedure OnGetStream(Sender: TFileContentsStreamOnDemandClipboardFormat;
      Index: integer; out AStream: IStream);
    //Drag하여 파일 추가한 경우 AFileName <> ''
    //Drag를 윈도우 탐색기에서 하면 AFromOutLook=Fase,
    //Outlook 첨부 파일에서 하면 AFromOutLook=True임
    procedure ShowFileSelectF(AFileName: string = ''; AFromOutLook: Boolean = False);

    procedure GSFileRec2Grid(ARec: TSQLBackUpFileRec; ADynIndex: integer;
      AGrid: TNextGrid);
  public
    FGSFiles_: TSQLBackUpFile;
    FItemID, FTaskID: TID;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LoadFiles2Grid(AIDList: TIDList4GSFile);
  end;

function CreateFileListForm(ATaskID: integer): integer;

var
  FileListF: TFileListF;

implementation

{$R *.dfm}

function CreateFileListForm(ATaskID: integer): integer;
var
  LFileListF: TFileListF;
  LSQLHiMAPRecord: TSQLHiMAPRecord;
  LDoc: variant;
begin
  LHiMapDetailF := THiMAPDetailF.Create(nil);
  try
    LSQLHiMAPRecord := GetHiMAPFromIMONo_InstalledPnl_DeviceType(AImoNo, ADeviceType, ADeviceVariant, AInstalledPnl);
    LHiMapDetailF.GetHiMAPDetailFromHiMAPRecord(LSQLHiMAPRecord);
    LHiMapDetailF.FSQLGSFiles := GetGSFilesFromID(LSQLHiMAPRecord.ID);
    LHiMapDetailF.LoadGSFiles2Form;

    if not LSQLHiMAPRecord.IsUpdate then
    begin
      LHiMapDetailF.IMONoEdit.Text := AImoNo;
      LHiMapDetailF.HullNoEdit.Text := AHullNo;
      LHiMapDetailF.VesselNameEdit.Text := AShipName;
    end;

    Result := LHiMapDetailF.ShowModal;

    if Result = mrOK then
    begin
      TDocVariant.New(LDoc);
      LHiMapDetailF.SetHiMAPDetail2Variant(LDoc);
      LoadHiMAPFromVariant(LSQLHiMAPRecord, LDoc);
      AddOrUpdateHiMAP(LSQLHiMAPRecord);

      if High(LHiMapDetailF.FSQLGSFiles.Files) >= 0 then
      begin
        g_FileDB.Delete(TSQLGSFile, LHiMapDetailF.FSQLGSFiles.ID);
        LHiMapDetailF.FSQLGSFiles.TaskID := LSQLHiMAPRecord.ID;
        g_FileDB.Add(LHiMapDetailF.FSQLGSFiles, true);
      end
      else
        g_FileDB.Delete(TSQLGSFile, LHiMapDetailF.FSQLGSFiles.ID);
    end;
  finally
    LHiMapDetailF.Free;
  end;
end;

procedure TFileListF.OnGetStream(
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

procedure TFileListF.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  (DataFormatAdapter2.DataFormat as TVirtualFileStreamDataFormat).OnGetStream := OnGetStream;
end;

end.
