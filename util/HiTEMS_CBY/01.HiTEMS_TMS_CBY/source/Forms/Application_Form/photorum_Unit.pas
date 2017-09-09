unit photorum_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvSmoothTileList, AdvGDIP, Data.DB,
  AdvSmoothTileListImageVisualizer, Vcl.StdCtrls, AdvTrackBar, NxCollection,
  Vcl.Imaging.jpeg, Vcl.ExtCtrls, Ora, GDIPPictureContainer, Vcl.Menus,
  Vcl.ImgList, AdvSmoothTileListHTMLVisualizer, Vcl.ExtDlgs;

type
  Tphotorum_Frm = class(TForm)
    Panel5: TPanel;
    Image1: TImage;
    Panel1: TPanel;
    NxPanel1: TNxPanel;
    ImgList: TAdvSmoothTileList;
    tracbar_Col: TAdvTrackBar;
    Label1: TLabel;
    Label2: TLabel;
    tracbar_Row: TAdvTrackBar;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    ImageList1: TImageList;
    AdvSmoothTileListHTMLVisualizer1: TAdvSmoothTileListHTMLVisualizer;
    SavePictureDialog1: TSavePictureDialog;
    procedure FormCreate(Sender: TObject);
    procedure tracbar_RowChange(Sender: TObject);
    procedure ImgListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImgListTileClick(Sender: TObject; Tile: TAdvSmoothTile;
      State: TTileState);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FMouseButton : TMouseButton;
    FCurrentTile : TAdvSmoothTile;
  public
    { Public declarations }
    procedure Get_HiTEMS_MEDIA_STORE;
    procedure SaveAsImages(aTile:TAdvSmoothTile);
    procedure DeleteImages(aTile:TAdvSmoothTile);
  end;

var
  photorum_Frm: Tphotorum_Frm;

implementation
uses
  HiTEMS_TMS_COMMON,
  CommonUtil_Unit,
  DataModule_Unit;

{$R *.dfm}

{ Tphotorum_Frm }

procedure Tphotorum_Frm.DeleteImages(aTile: TAdvSmoothTile);
begin
  if MessageDlg('삭제 하시겠습니까? 삭제된 이미지는 복구할 수 없습니다.',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    with aTile do
    begin
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('DELETE FROM HITEMS_MEDIA_STORE ' +
                'WHERE REGNO = :param1 ');
        ParamByName('param1').AsString := Data; //DATA = REGNO
        ExecSQL;

        ShowMessage('삭제성공!');
        aTile.Destroy;
      end;
    end;
  end;
end;

procedure Tphotorum_Frm.FormCreate(Sender: TObject);
begin
  with imgList do
  begin
    Tiles.Clear;

//    Visualizer := AdvSmoothTileListImageVisualizer1;
    Columns := tracbar_Col.Position;
    Rows := tracbar_Row.Position;
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

procedure Tphotorum_Frm.FormShow(Sender: TObject);
begin
  Get_HiTEMS_MEDIA_STORE;
end;

procedure Tphotorum_Frm.Get_HiTEMS_MEDIA_STORE;
begin
  TThread.Synchronize(nil,procedure
  var
    Thumbnail,
    LMS : TMemoryStream;
    li : Integer;
    OraQuery : TOraQuery;
    Tiles : TAdvSmoothTile;
    Pic : TAdvGDIPPicture;
    fileInfo,
    fileName,
    fileDesc,
    fileRegNo,
    fileIndate,
    fileExt,
    empNo : String;
  begin
    OraQuery := TOraQuery.Create(nil);
    try
      OraQuery.Session := DM1.OraSession1;

      with ImgList.Tiles do
      begin
        BeginUpdate;
        try
          Clear;

          with OraQuery do
          begin
            Close;
            SQL.Clear;
            SQL.Add('SELECT * FROM HITEMS_MEDIA_STORE ' +
                    'ORDER BY REGNO DESC' );
            Open;

            if RecordCount <> 0 then
            begin
              LMS := TMemoryStream.Create;
              Pic := TAdvGDIPPicture.Create;
              try
                while not eof do
                begin
                  empNo      := FieldByName('EMPNO').AsString;
                  fileName   := FieldByName('MEDIANAME').AsString;
                  fileDesc   := FieldByName('MEDIADESC').AsString;
                  fileRegNo  := FieldByName('REGNO').AsString;
                  fileIndate := DataSavedTimeToDateFormat(fileRegNo);
                  fileInfo := '<B>작성자: '+Get_userNameAndPosition(empNo)+'</B><BR>'+
                              '<B>작성일: '+fileIndate+'</B><BR>'+
                              fileDesc;



                  LMS.Clear;
                  Pic.Assign(nil);
                  if FieldByName('MEDIA').IsBlob then
                  begin
                    TBlobField(FieldByName('MEDIA')).SaveToStream(LMS);
                    LMS.Position := 0;

                    Thumbnail := ThumbnailFromImage(fileName,LMS,520);
                    Thumbnail.Position := 0;

                    Pic.LoadFromStream(Thumbnail);

                    Tiles := Add;
                    with Tiles do
                    begin
                      Tiles.Data := fileRegNo;
                      Content.TextPosition := tpTopLeft;
                      Content.Text := fileInfo;
                      Content.ImageName := fileName;
                      Content.Image.Assign(Pic);

                    end;


                    FreeAndNil(Thumbnail);
                  end;
                  Next;
                end;
              finally
                FreeAndNil(LMS);
                FreeAndNil(Pic);
              end;
            end;
          end;
        finally
          EndUpdate;
        end;
      end;
    finally
      FreeAndNil(OraQuery);
    end;
  end);
end;

procedure Tphotorum_Frm.ImgListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FMouseButton := Button;
end;

procedure Tphotorum_Frm.ImgListTileClick(Sender: TObject; Tile: TAdvSmoothTile;
  State: TTileState);
begin
  if FMouseButton = mbRight then
  begin
    PopupMenu1.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
    FCurrentTile := Tile;

  end;
end;

procedure Tphotorum_Frm.N1Click(Sender: TObject);
begin
//선택된 이미지 저장
  SaveAsImages(FCurrentTile);
end;

procedure Tphotorum_Frm.N2Click(Sender: TObject);
begin
//선택된 이미지 삭제
  DeleteImages(FCurrentTile);
end;

procedure Tphotorum_Frm.SaveAsImages(aTile: TAdvSmoothTile);
var
  LMS : TMemoryStream;
begin
  with aTile do
  begin
    SavePictureDialog1.FileName := Content.ImageName;
    SavePictureDialog1.DefaultExt := ExtractFileExt(SavePictureDialog1.FileName);
    if SavePictureDialog1.Execute then
    begin
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM HITEMS_MEDIA_STORE ' +
                'WHERE REGNO = :param1' );
        ParamByName('param1').AsString := Data; //DATA = REGNO;
        Open;

        if RecordCount <> 0 then
        begin
          LMS := TMemoryStream.Create;
          try
            if FieldByName('MEDIA').IsBlob then
            begin
              TBlobField(FieldByName('MEDIA')).SaveToStream(LMS);
              LMS.Position := 0;

              LMS.SaveToFile(SavePictureDialog1.FileName);
              ShowMessage('이미지 저장 성공!');
            end;
          finally
            FreeAndNil(LMS);
          end;
        end;
      end;
    end;
  end;
end;

procedure Tphotorum_Frm.tracbar_RowChange(Sender: TObject);
begin
  with ImgList do
  begin
    BeginUpdate;
    try
      if (Sender is TAdvTrackBar) then
      begin
        if TAdvTrackBar(Sender).Name = 'tracbar_Row' then
          Rows := tracbar_Row.Position
        else if TAdvTrackBar(Sender).Name = 'tracbar_Col' then
          Columns := tracbar_Col.Position;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

end.
