unit FrmOLMailTitleChangerUsingOL;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxColumnClasses, NxColumns, ActiveX,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.StdCtrls,
  Vcl.ExtCtrls, DropSource, DragDrop, DropTarget, DragDropFile, SynCommons,
  AdvGlowButton, Vcl.ImgList, Vcl.Menus, Outlook2010, Clipbrd;

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
    PopupMenu1: TPopupMenu;
    GetSubject1: TMenuItem;
    SaveDialog1: TSaveDialog;
    DataFormatAdapter1: TDataFormatAdapter;
    GUIDFileName: TNxTextColumn;
    CopyOriginalMailSubject1: TMenuItem;
    procedure DropEmptyTarget1Drop(Sender: TObject; ShiftState: TShiftState;
      APoint: TPoint; var Effect: Integer);
    procedure FormCreate(Sender: TObject);
    procedure AdvGlowButton5Click(Sender: TObject);
    procedure AdvGlowButton6Click(Sender: TObject);
    procedure fileGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure GetSubject1Click(Sender: TObject);
    procedure CopyOriginalMailSubject1Click(Sender: TObject);
  private
    FFileContent: RawByteString;
    FIPList: TStringList;
    FMyIP: string;

    procedure OnGetStream(Sender: TFileContentsStreamOnDemandClipboardFormat;
      Index: integer; out AStream: IStream);

    procedure DragedFile2Grid(AFileName: string);
    procedure CleanTempFile;
    procedure DeleteTempFile(ARow: integer);
    function GetOriginalSubjectName(ARow: integer): string;

    procedure SetMailSubject(ASubject: string);
  public
    { Public declarations }
  end;

var
  OLMailTitleChangeF: TOLMailTitleChangeF;

implementation

uses UnitDragUtil, UnitBase64Util, DragDropFormats, UnitStringUtil,
  UnitOutLookUtil, getIp;

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
        DeleteTempFile(SelectedRow);
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

procedure TOLMailTitleChangeF.CleanTempFile;
var
  i: integer;
begin
  for i := 0 to fileGrid.RowCount - 1 do
  begin
    DeleteTempFile(i);
  end;
end;

procedure TOLMailTitleChangeF.CopyOriginalMailSubject1Click(Sender: TObject);
begin
  Clipboard.AsText := GetOriginalSubjectName(fileGrid.SelectedRow);
end;

procedure TOLMailTitleChangeF.DeleteTempFile(ARow: integer);
var
  LStr: string;
begin
  LStr := fileGrid.CellsByName['GUIDFileName',ARow];
  DeleteFile(LStr);
end;

procedure TOLMailTitleChangeF.DragedFile2Grid(AFileName: string);
var
  LDoc: variant;
  LUtf8: RawUTF8;
  LFileName: string;
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
      LFileName := NewGUID;
      LFileName := 'c:\temp\' + ChangeFileExt(LFileName, '.msg');
      CellByName['GUIDFileName',RowCount-1].AsString := LFileName;
      FileFromString(FFileContent, LFileName);

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
    DragedFile2Grid(LFileName);
  end;
end;

procedure TOLMailTitleChangeF.fileGridMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i: integer;
  LFileName: string;
begin
  if (FileGrid.SelectedCount > 0) and
    (DragDetectPlus(FileGrid.Handle, Point(X,Y))) then
  begin
    TVirtualFileStreamDataFormat(DataFormatAdapter2.DataFormat).FileNames.Clear;

    for i := 0 to FileGrid.RowCount - 1 do
      if (FileGrid.Row[i].Selected) then
      begin
//        LFileName := Edit1.Text;

//        if LFileName = '' then
          LFileName := FileGrid.CellByName['FileName',i].AsString;
//        else
//          LFileName := ChangeFileExt(LFileName, '.msg');

        TVirtualFileStreamDataFormat(DataFormatAdapter2.DataFormat).
          FileNames.Add(LFileName);
        break;
      end;

    DropEmptySource1.Execute;
  end;
end;

procedure TOLMailTitleChangeF.FormCreate(Sender: TObject);
begin
  (DataFormatAdapter2.DataFormat as TVirtualFileStreamDataFormat).OnGetStream := OnGetStream;
  FIPList := TStringList.Create;
  FIPList.Add('10.22.41.188');
  FIPList.Add('10.22.41.189');
  FIPList.Add('10.22.41.65');
  FIPList.Add('10.22.41.87');
  FIPList.Add('10.22.41.160');
  FIPList.Add('10.22.41.81');
  FIPList.Add('10.0.2.15');
  FMyIP := GetLocalIP(0);

  if FIPList.IndexOf(FMyIP) = -1 then
  begin
    ShowMessage('당신은 기술영업팀원이 아니군요.' + #13#10 +
      '본 프로그램은 기술영업팀원만 사용 가능합니다.' + #13#10 +
      '사용을 원하시면 기술영업팀에 문의 하세요!');
    Halt(0);
  end;
end;

procedure TOLMailTitleChangeF.FormDestroy(Sender: TObject);
begin
  CleanTempFile;
  FIPList.Free;
end;

function TOLMailTitleChangeF.GetOriginalSubjectName(ARow: integer): string;
begin
  Result := fileGrid.CellsByName['FileName', ARow];
end;

procedure TOLMailTitleChangeF.GetSubject1Click(Sender: TObject);
begin
  SetMailSubject(Edit1.Text);
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
  LStr: string;
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
//          LUTf8 := StringToUTF8(FileGrid.CellByName['FileContent',i].AsString);
//          Data := MakeBase64ToUTF8(LUtf8);
          SetMailSubject(Edit1.Text);
          LStr := FileGrid.CellByName['GUIDFileName',i].AsString;
          if not FileExists(LStr) then
            exit;
          Data := StringFromFile(LStr);
//          Data := FFileContent;
          Found := True;
          break;
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

procedure TOLMailTitleChangeF.SetMailSubject(ASubject: string);
var
  LMail: OleVariant;
  LFileName: string;
  LUtf8: RawUTF8;
begin
  LFileName := fileGrid.CellsByName['GUIDFileName', fileGrid.SelectedRow];

  if FileExists(LFileName) then
  begin
    LMail := GetMailItemFromMsgFile(LFileName);
    LMail.Subject := ASubject;
    LMail.SaveAs(LFileName);
    FFileContent := StringFromFile(LFileName);
    LUtf8 := MakeRawByteStringToBin64(FFileContent);
    fileGrid.CellsByName['FileContent', fileGrid.SelectedRow] := UTF8ToString(Lutf8);;
  end;
end;

end.
