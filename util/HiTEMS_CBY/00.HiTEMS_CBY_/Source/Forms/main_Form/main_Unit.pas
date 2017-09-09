unit main_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.jpeg,ora,Data.DB,
  Vcl.ExtCtrls, AdvOfficeStatusBar, AdvOfficeStatusBarStylers, AdvSmoothTileList,
  AdvSmoothTileListImageVisualizer, AdvSmoothTileListHTMLVisualizer, AdvGDIP,
  System.Generics.Collections, Vcl.ComCtrls, ShellApi, JvBaseDlg,
  JvProgressDialog, Vcl.Menus, JvExComCtrls, JvComCtrls;

type
  TStreamProgressEvent = procedure(Sender:TObject; Percentage:Single) of Object;
  TProgressFileStream = class(TFileStream)
  private
    FOnProgress:TStreamProgressEvent;
    FProcessed : Int64;
    FSize : Int64;
  public
    procedure InitProgressCounter(aSize:Int64);
    function Read(var Buffer; Count:Integer):Integer;override;
    function Write(const Buffer; Count:Integer):Integer;override;
    property OnProgress:TStreamProgressEvent read FOnProgress write FOnProgress;

  end;


type
  TFadeType = (ftIn, ftOut);

type
  Tmain_Frm = class(TForm)
    StatusBar1: TAdvOfficeStatusBar;
    Panel3: TPanel;
    Image2: TImage;
    user_lb: TLabel;
    Button1: TButton;
    AdvOfficeStatusBarOfficeStyler1: TAdvOfficeStatusBarOfficeStyler;
    AdvSmoothTileListImageVisualizer1: TAdvSmoothTileListImageVisualizer;
    fadeTimer: TTimer;
    sysList: TAdvSmoothTileList;
    JvProgressDialog1: TJvProgressDialog;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    USER1: TMenuItem;
    N1: TMenuItem;
    Close1: TMenuItem;
    N2: TMenuItem;
    AdvSmoothTileListImageVisualizer2: TAdvSmoothTileListImageVisualizer;
    JvTrackBar1: TJvTrackBar;
    procedure Button1Click(Sender: TObject);
    procedure fadeTimerTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure sysListTileDblClick(Sender: TObject; Tile: TAdvSmoothTile;
      State: TTileState);
    procedure Close1Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure JvTrackBar1Change(Sender: TObject);
  private
    { Private declarations }
    FFirst : Boolean;
    fFadeType : TFadeType;
    FcurrentTile : TAdvSmoothTile;
    property FadeType : TFadeType read fFadeType write fFadeType;
    procedure StreamProgress(Sender:TObject; Percentage:Single);
  public
    { Public declarations }
    procedure Init_;
    procedure Set_Application_Tiles;
    procedure Show_Application(aTile:TAdvSmoothTile);
  end;

var
  main_Frm: Tmain_Frm;

implementation
uses
  appGrant_Unit,
  detailUser_Unit,
  CommonUtil_Unit,
  HiTEMS_CONST,
  DataModule_Unit;

{$R *.dfm}


procedure Tmain_Frm.Button1Click(Sender: TObject);
var
  FullProgPath: String;
  i : Integer;
begin
  fFadeType := ftOut;
  try
    AlphaBlendValue := 255;
    fadeTimer.Enabled := true;
    FullProgPath := Application.ExeName;
  finally
    while fadeTimer.Enabled do
    begin
      Application.ProcessMessages;
    end;
    ExecNewProcess2(FullProgPath);
    Application.Terminate;
  end;
end;

procedure Tmain_Frm.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure Tmain_Frm.fadeTimerTimer(Sender: TObject);
const
  FADE_IN_SPEED = 3;
  FADE_OUT_SPEED = 5;
var
  newBlendValue : integer;
begin
  case FadeType of
    ftIn:
    begin
      if AlphaBlendValue < 255 then
        AlphaBlendValue := FADE_IN_SPEED + AlphaBlendValue
      else
      begin
        fadeTimer.Enabled := false;
      end;
    end;

    ftOut:
    begin
      if AlphaBlendValue > 0 then
      begin
        newBlendValue := -1 * FADE_OUT_SPEED + AlphaBlendValue;
        if newBlendValue >  0 then
          AlphaBlendValue := newBlendValue
        else
          AlphaBlendValue := 0;
      end
      else
      begin
        fadeTimer.Enabled := false;
        Close;
      end;
    end;
  end;
end;

procedure Tmain_Frm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if FadeType = ftIn then
  begin
    fFadeType := ftOut;
    AlphaBlendValue := 255;
    fadeTimer.Enabled := true;
    CanClose := false;
  end
  else
  begin
    CanClose := true;
  end;
end;

procedure Tmain_Frm.FormCreate(Sender: TObject);
begin
  Init_;
end;

procedure Tmain_Frm.Init_;
var
  lpos : integer;
  lname : String;
  lid : String;
begin
  AlphaBlend := true;
  AlphaBlendValue := 0;
  fFadeType := ftIn;
  fadeTimer.Enabled := true;

  lname := CurrentUserName;
  lid   := CurrentUserId;
  User_lb.Caption := lname+User_lb.Caption;
  User_lb.Font.Color := clWhite;
  sysList.Tiles.Clear;

  if CurrentUserId = 'ADMIN' then
    N2.Visible := True
  else
    N2.Visible := False;

  //========== TileSetting ======================
//  sysList.PictureContainer := GDIPPictureContainer1;
  sysList.Visualizer := AdvSmoothTileListImageVisualizer1;
  sysList.Columns := 3;
  sysList.Rows := 2;
//  sysList.Header.Visible := False;
  sysList.Footer.ArrowNavigation := False;
  sysList.Footer.Fill.BorderColor := clNone;
  sysList.Footer.Fill.Color := clNone;
  sysList.Footer.Fill.GradientType := gtSolid;
  sysList.Footer.Fill.GradientMirrorType := gtNone;
  sysList.TileAppearance.VerticalSpacing := 10;
  sysList.TileAppearance.HorizontalSpacing := 10;

  sysList.TileAppearance.SmallViewFill.GradientType := gtNone;
  sysList.TileAppearance.SmallViewFill.BorderColor := clNone;
  sysList.TileAppearance.StatusIndicatorAppearance.Font.Size := 8;
  sysList.TileAppearance.SmallViewFillHover.Opacity := 100;
  sysList.TileAppearance.StatusIndicatorAppearance.Fill.BorderColor := clWhite;
  sysList.TileAppearance.StatusIndicatorAppearance.Fill.BorderWidth := 2;

  sysList.Footer.Float := True;

  sysList.TileAppearance.SmallViewFont.Size := 8;
  sysList.TileAppearance.SmallViewFont.Color := clSilver;
  sysList.TileAppearance.SmallViewFontSelected.Assign(sysList.TileAppearance.SmallViewFont);
  sysList.TileAppearance.SmallViewFontHover.Assign(sysList.TileAppearance.SmallViewFont);
  sysList.TileAppearance.SmallViewFontDisabled.Assign(sysList.TileAppearance.SmallViewFont);

  //Tile 설정
  Set_Application_Tiles;
end;

procedure Tmain_Frm.JvTrackBar1Change(Sender: TObject);
begin
  with sysList do
  begin
    BeginUpdate;
    try
      Columns := JvTrackBar1.Position;
      PreviousPage;
    finally
      EndUpdate;
    end;
  end;
end;

procedure Tmain_Frm.N1Click(Sender: TObject);
begin
  Create_detailUSer_Frm(CurrentUserId);
end;

procedure Tmain_Frm.N2Click(Sender: TObject);
var
  lForm : TappGrant_Frm;
begin
  lForm := TappGrant_Frm.Create(Self);
  try
    with lForm do
    begin
      ShowModal;
    end;
  finally
    FreeAndNil(lForm);
  end;
end;

procedure Tmain_Frm.Set_Application_Tiles;
begin
  TThread.Queue(nil,
  procedure
  var
    OraQuery1 : TOraQuery;
    lms : TMemoryStream;
    Tile : TAdvSmoothTile;
  begin
    OraQuery1 := TOraQuery.Create(nil);
    OraQuery1.Session := DM1.OraSession1;
    try
      //set list
      with sysList.Tiles do
      begin
        with OraQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT A.USERID, B.* FROM ' +
                  'HITEMS_USER_APPLICATION A, APP_CODE B ' +
                  'WHERE A.USERID = :param1  ' +
                  'AND A.APPCODE = B.APPCODE ' +
                  'AND B.STATUS != :param2 ' +
                  'ORDER BY SORTNO ');

          ParamByName('param1').AsString  := CurrentUserId;
          ParamByName('param2').AsInteger := 1; //0:사용중; 1:미사용; 2:점검중
          Open;

          lms := TMemoryStream.Create;
          try
            while not eof do
            begin
              lms.Clear;
              lms.Position := 0;

              if not(FieldByName('ICON').IsNull) then
              begin
                Tile := Add;
                with Tile do
                begin
                  TBlobField(FieldByName('ICON')).SaveToStream(lms);
                  Content.Image.LoadFromStream(lms);
                  Content.ImageStretch := True;
                  Content.Text := FieldByName('APPNAME_K').AsString;
                  Content.Hint := FieldByName('APPCODE').AsString;
                  Content.TextPosition := tpBottomCenter;

                  if FieldByName('STATUS').AsInteger = 2 then
                  begin
                    Enabled := False;
                    Content.Text := FieldByName('APPNAME_K').AsString+#10#13+
                                         '점검중';
                  end;
                end;
              end;
              Next;
            end;
          finally
            FreeAndNil(lms);
          end;
        end;
      end;
    finally
      FreeAndNil(OraQuery1);
    end;
  end);
end;

procedure Tmain_Frm.Show_Application(aTile: TAdvSmoothTile);
begin
  TThread.Queue(nil,
  procedure
  const
    defaultPath = 'C:\Temp\HiTEMS\';
  var
    OraQuery : TOraQuery;
    Stream : TProgressFileStream;
    appCode,
    appName,
    lFileName: String;
    lastWriteTime : TDateTime;

    function Download_Application(aAppCode,aAppName,aFileName:string):Boolean;
    begin
      Result := False;
      Stream := TProgressFileStream.Create(aFileName, fmCreate);
      try
        JvProgressDialog1.Caption := aAppName;
        JvProgressDialog1.Show;
        try
          OraQuery := TOraQuery.Create(nil);
          try
            OraQuery.Session := DM1.OraSession1;
            OraQuery.Options.TemporaryLobUpdate := True;
            JvProgressDialog1.Text := '업데이트 파일 오픈   ';
            with OraQuery do
            begin
              Close;
              SQL.Clear;
              SQL.Add('SELECT * FROM APP_VERSION  ' +
                      'WHERE VERNO = ( ' +
                      '                 SELECT MAX(VERNO) FROM APP_VERSION ' +
                      '                 WHERE APPCODE = :param1 ' +
                      '              ) ');

              ParamByName('param1').AsString := appCode;
              Open;

              JvProgressDialog1.Text := '다운로드 시작   ';
              Stream.OnProgress := StreamProgress;
              Stream.InitProgressCounter(TBlobField(FieldByName('FILES')).BlobSize);
              TBlobField(FieldByName('FILES')).SaveToStream(Stream);

              JvProgressDialog1.Text := '다운로드 완료   ';
              Sleep(300);
              JvProgressDialog1.Text := '실행   ';
              Result := True;
            end;
          finally
            FreeAndNil(OraQuery);
          end;
        finally
          JvProgressDialog1.Hide;
        end;
      finally
        FreeAndNil(stream);
      end;
    end;
  begin
    appName := aTile.Content.Text;
    appCode := aTile.Content.Hint;
    if appCode <> '' then
    begin
      if not DirectoryExists(defaultPath) then
        CreateDir(defaultPath);

      lFileName := defaultPath+appCode+'.exe';
      if FileExists(lFileName) then
      begin
        lastWriteTime := GetFileLastWriteTime(lFileName);
        with DM1.OraQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT APPCODE, LASTWRITETIME FROM APP_VERSION ' +
                  'WHERE APPCODE = :param1 ' +
                  'AND TO_DATE(LASTWRITETIME,''YYYY-MM-DD HH24:MI:SS'') > :param2 ');
          ParamByName('param1').AsString := appCode;
          ParamByName('param2').AsDateTime := lastWriteTime;
          Open;

          if RecordCount <> 0 then
          begin
            DeleteFile(lFileName);//기존 파일삭제
            if Download_Application(appCode,appName,lFileName) then
              ExecNewProcess2(lFileName,CurrentUserId);
          end
          else
          begin
            ExecNewProcess2(lFileName,CurrentUserId);
          end;
        end;
      end else
        if Download_Application(appCode,appName,lFileName) then
          ExecNewProcess2(lFileName,CurrentUserId);
    end;
    StatusBar1.Panels[0].Progress.Position := 0;
  end);
end;

procedure Tmain_Frm.StreamProgress(Sender: TObject; Percentage: Single);
begin
//  sleep();
  JvProgressDialog1.Position := Round(Percentage * JvProgressDialog1.Max);
  Application.ProcessMessages;
end;

procedure Tmain_Frm.sysListTileDblClick(Sender: TObject; Tile: TAdvSmoothTile;
  State: TTileState);
begin
  Show_Application(Tile);
end;

{ TProgressFileStream }

procedure TProgressFileStream.InitProgressCounter(aSize: Int64);
begin
  FProcessed := 0;
  if aSize <= 0 then
    FSize := 1
  else
    FSize := aSize;

  if Assigned(FOnProgress) then
    FOnProgress(Self,0);

end;

function TProgressFileStream.Read(var Buffer; Count: Integer): Integer;
begin
  Result := inherited Read(Buffer, Count);
  Inc(FProcessed, Result);
  if Assigned(FOnProgress) then
    FOnProgress(Self, FProcessed / FSize);
end;

function TProgressFileStream.Write(const Buffer; Count: Integer): Integer;
begin
  Result := inherited Write(Buffer, Count);
  Inc(FProcessed, Result);
  if Assigned(FOnProgress) then
    FOnProgress(Self, FProcessed / FSize);
end;

end.
