unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, ComCtrls, ExtCtrls, Contnrs, JPeg, ImgList, Math,
  Grids, rxToolEdit;

type
  TItem = class(TObject)
  public
    FName: string;
    FThumb: TBitmap;
    FThumbIx: integer;  // Index into LargeImages
    FThumbCt: integer;  // Counter
    constructor Create;
    destructor Destroy; override;
    procedure GetThumbnail(AWidth, AHeight: integer);
  end;

  TfrmMain = class(TForm)
    nbType: TNotebook;
    GroupBox1: TGroupBox;
    rbListview: TRadioButton;
    rbTreeview: TRadioButton;
    rbDrawgrid: TRadioButton;
    lvList: TListView;
    deFolder: TDirectoryEdit;
    Label1: TLabel;
    btnLoad: TButton;
    ilList: TImageList;
    GroupBox2: TGroupBox;
    rbIcon: TRadioButton;
    rbList: TRadioButton;
    rbReport: TRadioButton;
    rbSmallIcon: TRadioButton;
    edSizeX: TEdit;
    Label2: TLabel;
    edSizeY: TEdit;
    Label3: TLabel;
    btnSizeApply: TButton;
    dgList: TDrawGrid;
    chbInclude: TCheckBox;
    lblFileCount: TLabel;
    procedure btnLoadClick(Sender: TObject);
    procedure lvListData(Sender: TObject; Item: TListItem);
    procedure FormCreate(Sender: TObject);
    procedure ListStyleChanged(Sender: TObject);
    procedure TableTypeChanged(Sender: TObject);
    procedure btnSizeApplyClick(Sender: TObject);
    procedure dgListDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
    FList: TObjectList;
    FCounter: integer;
  public
    { Public declarations }
    procedure DrawGridSize(ThumbX, ThumbY, ItemCount: integer);
  end;

var
  frmMain: TfrmMain;

const
  cMaxThumbInList = 1000;

implementation

{$R *.DFM}

constructor TItem.Create;
begin
  inherited Create;
  FThumbIx := -1;
end;

destructor TItem.Destroy;
begin
  if assigned(FThumb) then FreeAndNil(FThumb);
  inherited;
end;

procedure TItem.GetThumbnail(AWidth, AHeight: integer);
var
  JPeg: TJPegImage;
  Scale: double;
  SizeX, SizeY, OffsX, OffsY: integer;
begin
  // Quick and Dirty
  FThumb := TBitmap.Create;
  try
    if assigned(FThumb) then begin
      FThumb.Width := AWidth;
      FThumb.Height := AHeight;
      with FThumb.Canvas do begin
        Pen.Color := clBlack;
        Brush.Color := clRed;
        Brush.Style := bsSolid;
        Rectangle(rect(0, 0, AWidth, AHeight));
        if AnsiSameText(ExtractFileExt(FName), '.jpg') then begin
          JPeg := TJpegImage.Create;
          try
            JPeg.LoadFromFile(FName);
            if AHeight > 0 then begin
              Scale := JPeg.Height / AHeight;
              if Scale > 8 then JPeg.Scale := jsEighth
              else if Scale > 4 then JPeg.Scale := jsQuarter
                else if Scale > 2 then JPeg.Scale := jsHalf
                  else JPeg.Scale := jsFullSize;
            end;
            if JPeg.Width * JPeg.Height > 0 then begin
              Scale := Min(AWidth / JPeg.Width, AHeight / JPeg.Height);
              SizeX := round(JPeg.Width * Scale);
              SizeY := round(JPeg.Height * Scale);
              OffsX := (AWidth - SizeX) div 2;
              OffsY := (AHeight - SizeY) div 2;
              StretchDraw(rect(OffsX, OffsY, SizeX + OffsX, SizeY + OffsY), JPeg);
            end;
          finally
            JPeg.Free;
          end;
        end;
      end;
    end;
  except
    if assigned(FThumb) then FreeAndNil(Fthumb);
  end;
end;

procedure TfrmMain.btnLoadClick(Sender: TObject);
var
  i: integer;
  Folder: string;
  AItem: TItem;
// local: scanfolder
procedure ScanFolder(AName: string; Recursive: boolean);
var
  Result: integer;
  S: TSearchRec;
begin
  Result := FindFirst(AName + '*.*', faAnyFile, S);
  while Result = 0 do begin
    if (S.Attr and faDirectory) = 0 then begin
      // A File, add it
      AItem := TItem.Create;
      AItem.FName := AName + S.Name;
      FList.Add(AItem);
      if FList.Count mod 100 = 0 then begin
        lblFileCount.Caption := Format('%d files', [FList.Count]);
        Application.ProcessMessages;
      end;
    end else begin
      // ADirectory
      if Recursive and (S.Name <> '.') and (S.Name <> '..') then begin
        // Scan it!
        ScanFolder(IncludeTrailingBackslash(AName + S.Name), True);
      end;
    end;
    Result := FindNext(S);
  end;
  FindClose(S);
end;
// main
begin
  // Clear old stuff
  FList.Clear;
  lvList.Items.Count := 0;
  ilList.Clear;
  FCounter := cMaxThumbInList + 1;

  // Load a new list
  Folder := IncludeTrailingBackslash(deFolder.Text);
  ScanFolder(Folder, chbInclude.Checked);

  lblFileCount.Caption := Format('%d files', [FList.Count]);

  // Setup new listview
  lvList.Items.Count := FList.Count;
  lvList.Invalidate;

  // Setup Drawgrid
  DrawGridSize(ilList.Width, ilList.Height, FList.Count);
end;

procedure TfrmMain.lvListData(Sender: TObject; Item: TListItem);
var
  AItem: TItem;
begin
  AItem := nil;
  if (Item.Index >= 0) and (Item.Index < FList.Count) then
    AItem := TItem(FList[Item.Index]);
  if assigned(AItem) then with AItem do begin
    if FThumbIx < 0  then begin
      // Copy to imagelist
      if not assigned(FThumb) then
        GetThumbnail(ilList.Width, ilList.Height);
      FThumbIx := ilList.Add(FThumb, nil);
    end;
    Item.ImageIndex := FThumbIx;
    Item.Caption := ExtractFileName(FName);
  end;

end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FList := TObjectList.Create;
end;

procedure TfrmMain.TableTypeChanged(Sender: TObject);
var
  i: integer;
begin

  // Clear up first
  lvList.Items.Count := 0;

  if rbListView.Checked then begin
    nbType.ActivePage := 'Listview';
    lvList.Items.Count := FList.Count;
    lvList.invalidate;
  end;
  if rbTreeView.Checked then nbType.ActivePage := 'Treeview';
  if rbDrawGrid.Checked then nbType.ActivePage := 'Drawgrid';

end;

procedure TfrmMain.ListStyleChanged(Sender: TObject);
begin
  if rbIcon.Checked then begin
    lvList.SmallImages := nil;
    lvList.LargeImages := ilList;
    lvList.ViewStyle := vsIcon;
  end else begin
    lvList.SmallImages := ilList;
    lvList.LargeImages := nil;
    if rbList.Checked then lvList.ViewStyle := vsList;
    if rbReport.Checked then lvList.ViewStyle := vsReport;
    if rbSmallIcon.Checked then lvList.ViewStyle := vsSmallIcon;
  end;
  lvList.invalidate;
end;

procedure TfrmMain.btnSizeApplyClick(Sender: TObject);
var
  i: integer;
  OldSmall, OldLarge: TCustomImageList;
begin
  // prepare Listview
  OldSmall := lvList.SmallImages;
  OldLarge := lvList.LargeImages;
  lvList.Items.Count := 0;
  lvList.SmallImages := nil;
  lvList.LargeImages := nil;
  // Clear up thumb references
  for i := 0 to FList.Count - 1 do with TItem(FList[i]) do begin
    FThumbIx := -1;
    if assigned(FThumb) then FreeAndNil(FThumb);
  end;

  // change size
  ilList.Clear;
  ilList.Width := StrToInt(edSizeX.Text);
  ilList.Height := StrToInt(edSizeY.Text);

  // restore Listview
  lvList.SmallImages := OldSmall;
  lvList.LargeImages := OldLarge;
  lvList.Items.Count := FList.Count;

  // Set Cell size for Drawgrid
  DrawGridSize(ilList.Width, ilList.Height, FList.Count);

  // update controls
  lvList.Invalidate;
end;

procedure TfrmMain.dgListDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  Index: integer;
  AItem: TItem;
  TextR: TRect;
  Line: string;
begin
  with dgList do begin
    // Index of the thumbnail
    Index := ARow * ColCount + ACol;
    AItem := nil;
    if (Index >= 0) and (Index < FList.Count) then
      AItem := TItem(FList[Index]);
    if assigned(AItem) then with AItem do begin
      if FThumbIx < 0  then begin
        if not assigned(FThumb) then
          GetThumbnail(ilList.Width, ilList.Height);
        // Copy to imagelist
        FThumbIx := ilList.Add(FThumb, nil);
      end;
      ilList.Draw(Canvas, Rect.Left + 2, Rect.Top + 2, FThumbIx);

      TextR := Classes.Rect(Rect.Left, Rect.Bottom - 18, Rect.Right, Rect.Bottom);
      Line := ExtractFileName(FName);
      with Canvas do begin
        Font.Name := 'Verdana';
        Font.Size := 7;
        TextRect(
          TextR,
          Rect.Left + 1, // + (DefaultColWidth - TextWidth(Line)) div 2,
          Rect.Bottom - 16,
          Line);
      end;
    end;
  end;
end;

procedure TfrmMain.DrawGridSize(ThumbX, ThumbY, ItemCount: integer);
begin
  with dgList do begin
    DefaultColWidth := Max(ilList.Width + 4, 80);
    DefaultRowHeight := ilList.Height + 20;
    ColCount := Max(Width div DefaultColWidth, 1);
    RowCount := (ItemCount + ColCount - 1) div ColCount;
  end;
end;

end.
