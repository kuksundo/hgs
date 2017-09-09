unit UnitFrameTileList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Winapi.ShellAPI, AdvSmoothTileList,
  AdvSmoothTileListImageVisualizer, AdvSmoothTileListHTMLVisualizer,
  GDIPPictureContainer, AdvGDIP, Data.DBXJSON, Data.DBXJSONCommon, BaseConfigCollect;

type
  TAddNewApp2List = procedure of object;

  TFrame1 = class(TFrame)
    tileList: TAdvSmoothTileList;
    GDIPPictureContainer1: TGDIPPictureContainer;
    AdvSmoothTileListHTMLVisualizer1: TAdvSmoothTileListHTMLVisualizer;
    AdvSmoothTileListImageVisualizer1: TAdvSmoothTileListImageVisualizer;
    SaveDialog1: TSaveDialog;
    procedure tileListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    procedure WMDropFiles(var msg:TMessage); message WM_DROPFILES;
  public
    FAddNewApp2List: TAddNewApp2List;

    function ConvertImage2String(APicture: TAdvGDIPPicture): string;
    function ConvertString2Stream(AString: string): TMemoryStream;

    procedure SaveTile2File(ACollect: TpjhBase; AInitPath: string='');

    procedure Initialize_list;
    procedure InitVar;
    procedure DestroyVar;
  end;

implementation

{$R *.dfm}

{ TFrame1 }

function TFrame1.ConvertImage2String(APicture: TAdvGDIPPicture): string;
var
  LJA: TJSONArray;
  LMS: TMemoryStream;
begin
  LMS := TMemoryStream.Create;
  try
    APicture.SaveToStream(LMS);
    LMS.Position := 0;
    LJA := TJSONArray.Create;
    LJA := TDBXJSONTools.StreamToJSON(LMS, 0, LMS.Size);
    Result := LJA.ToString;
  finally
    FreeAndNil(LMS);
  end;
end;

function TFrame1.ConvertString2Stream(AString: string): TMemoryStream;
var
  LJA: TJSONArray;
begin
  if AString = '' then
    exit;

  LJA := TJSONArray.Create;
  try
    LJA := TJSONObject.ParseJSONValue(AString) as TJSONArray;
    Result := TMemoryStream(TDBXJSONTools.JSONToStream(LJA));
    Result.Position := 0;
  finally
    FreeAndNil(LJA);
  end;
end;

procedure TFrame1.DestroyVar;
begin
  DragAcceptFiles(Handle,False);
end;

procedure TFrame1.Initialize_list;
var
  tile: TAdvSmoothTile;
begin
  with tileList do
  begin
    Tiles.Clear;

    PictureContainer := GDIPPictureContainer1;
    Visualizer := AdvSmoothTileListImageVisualizer1;
    //Columns := 3;
    //Rows := 2;
    Header.Visible := False;
    Footer.ArrowNavigation := False;
    Footer.Fill.BorderColor := clNone;
    Footer.Fill.Color := clNone;
    Footer.Fill.GradientType := gtSolid;
    Footer.Fill.GradientMirrorType := gtNone;
    TileAppearance.VerticalSpacing := 15;
    TileAppearance.HorizontalSpacing := 15;

    TileAppearance.SmallViewFill.GradientType := gtNone;
    TileAppearance.SmallViewFill.BorderColor := clNone;
    TileAppearance.StatusIndicatorAppearance.Font.Size := 14;
    TileAppearance.SmallViewFillHover.Opacity := 100;
    TileAppearance.StatusIndicatorAppearance.Fill.BorderColor := clWhite;
    TileAppearance.StatusIndicatorAppearance.Fill.BorderWidth := 2;

    Footer.Float := True;

    TileAppearance.SmallViewFont.Size := 10;
    TileAppearance.SmallViewFont.Color := clBlack;
    TileAppearance.SmallViewFontSelected.Assign(TileAppearance.SmallViewFont);
    TileAppearance.SmallViewFontHover.Assign(TileAppearance.SmallViewFont);
    TileAppearance.SmallViewFontDisabled.Assign(TileAppearance.SmallViewFont);
  end;
end;

procedure TFrame1.InitVar;
begin
  DragAcceptFiles(Handle,True);
  Initialize_list;
end;

procedure TFrame1.SaveTile2File(ACollect: TpjhBase; AInitPath: string);
begin
  if AInitPath <> '' then
    SaveDialog1.InitialDir := AInitPath;

  SaveDialog1.Filter :=  '*.*';

  if SaveDialog1.Execute then
  begin
    if FileExists(SaveDialog1.FileName) then
    begin
      if MessageDlg('File is already existed. Are you overwrite? if No press, then the data is not saved!.',
      mtConfirmation, [mbYes, mbNo], 0)= mrNo then
        exit;
    end;
  end
  else
    exit;

    ACollect.SaveToJSONFile(SaveDialog1.FileName);
end;

procedure TFrame1.tileListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //Delete
  if key = 46 then
  begin
    tileList.SelectedTile.Destroy;
  end;
end;

procedure TFrame1.WMDropFiles(var msg: TMessage);
var
  i, NumFiles, NameLength : Integer;
  hDrop : THandle;
  tmpFile : array[0..MAX_PATH] of Char;
begin
  hDrop := msg.WParam;
  try
    NumFiles := DragQueryFile(hDrop,$FFFFFFFF,nil,0);

    for i := 0 to NumFiles-1 do
    begin
      NameLength := DragQueryFile(hDrop,i,nil,0);
      DragQueryFile(hDrop,i,tmpFile,NameLength+1);

      if Assigned(FAddNewApp2List) then
        FAddNewApp2List;
    end;
  finally
    DragFinish(hDrop);
  end;
  msg.Result := 0;

  inherited;
end;

end.
