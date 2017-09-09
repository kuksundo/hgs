unit launcherMain_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvSmoothTileList,AdvGDIP,
  AdvSmoothTileListImageVisualizer, AdvSmoothTileListHTMLVisualizer,
  Vcl.ComCtrls, Vcl.ExtCtrls, ShellApi, GDIPPictureContainer, AdvGlowButton,
  Data.DBXJSON, Data.DBXJSONCommon, Vcl.Imaging.jpeg, Vcl.ImgList, AutoRunClass,
  Vcl.StdCtrls, Vcl.Menus, newApp_Unit, HiMECSConst, CopyData, TimerPool,
  UnitFrameTileList, BaseConfigCollect;

type
  TeditType = (ftInsert,ftEdit);

  TlauncherMain_Frm = class(TForm)
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    AdvGlowButton1: TAdvGlowButton;
    Image1: TImage;
    ImageList1: TImageList;
    OpenDialog1: TOpenDialog;
    PopupMenu1: TPopupMenu;
    LoadFromFile1: TMenuItem;
    SaveToFile1: TMenuItem;
    Timer1: TTimer;
    N1: TMenuItem;
    ExecuteAll1: TMenuItem;
    ExecuteAuto1: TMenuItem;
    ExecuteManual1: TMenuItem;
    TileListFrame: TFrame1;
    ExecuteSelectedTile1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure AdvGlowButton1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure LoadFromFile1Click(Sender: TObject);
    procedure SaveToFile1Click(Sender: TObject);
    procedure tileListTileDblClick(Sender: TObject; ATile: TAdvSmoothTile;
      State: TTileState);
    procedure ExecuteAll1Click(Sender: TObject);
    procedure ExecuteSelectedTile1Click(Sender: TObject);
    procedure ExecuteAuto1Click(Sender: TObject);
    procedure ExecuteManual1Click(Sender: TObject);
  private
    FFilePath: string;
    FFirst: Boolean;
    FeditType : TeditType;
    FAutoRunClass: TAutoRunList;
    FPJHTimerPool: TPJHTimerPool;

    property EditType : TeditType read FeditType write FeditType;
    procedure AddNewApp2List;
    function Create_newApp(aEditType:Integer;aPath:String) : TJSONObject;
    function JSONObject2AutoRunClass(AJSONObject: TJSONObject;
      AdvSmoothTileContent, ASubTileContent:TAdvSmoothTileContent): integer;
    procedure WMCopyData(var Msg: TMessage); message WM_COPYDATA;
    procedure OnDisableAppStatus(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
  public
    { Public declarations }
    function Get_JsonValues(aJsonPair:TJSONPair):String;
    procedure LoadTileFromFile(AFileName: string; AIsAppend: Boolean);

    procedure LoadConfigForm2Var(AForm: TnewApp_Frm; AVar: TAutoRunItem);
    procedure LoadVar2ConfigForm(AForm: TnewApp_Frm; AVar: TAutoRunItem);
    procedure LoadVar2Form(ATile: TAdvSmoothTile; AVar: TAutoRunItem);

    procedure ExecuteList(AIsAll: Boolean=true; AIsAuto: Boolean=true;
        AIsSelected: Boolean=true);
    procedure ExecuteAuto;
    procedure ExecuteManual;
    procedure ExecuteSelectedTile;
  end;

var
  launcherMain_Frm: TlauncherMain_Frm;

implementation

uses CommonUtil_Unit, HiMECSCommonWinMessage;

{$R *.dfm}

{ TForm1 }

procedure TlauncherMain_Frm.AddNewApp2List;
var
  lJSONObject : TJSONObject;
  lTile, subTile : TAdvSmoothTile;
  lstr : String;
  LAutoRun: Boolean;
  i: integer;
begin
  lJSONObject := Create_newApp(0,'');
  try
    if lJSONObject <> nil then
    begin
      lTile := TileListFrame.tileList.Tiles.Add;
      with lTile do
      begin
        LAutoRun := StrToBool(Get_JsonValues(lJSONObject.get('AUTORUN')));
        if LAutoRun then
          StatusIndicator := 'Auto'
        else
          StatusIndicator := '';

        DisplayName := Get_JsonValues(lJSONObject.get('APPDESC'));
        Content.Text := Get_JsonValues(lJSONObject.get('APPTITLE'));
        Content.TextPosition := tpBottomCenter;

        lstr := Get_JsonValues(lJSONObject.get('USERELATIVEPATH'));
        if StrToBool(LStr) then
          LStr := ExtractRelativePathBaseApplication(FFilePath, Get_JsonValues(lJSONObject.get('APPPATH')))
        else
          LStr := Get_JsonValues(lJSONObject.get('APPPATH'));

        Content.Hint := LStr;
        //Data := Get_JsonValues(lJSONObject.get('APPPARAM'));
        Content.Image.LoadFromFile(Get_JsonValues(lJSONObject.get('APPICON')));
        subTile := Subtiles.Add;
        subTile.Content.Image.LoadFromFile(Get_JsonValues(lJSONObject.get('APPDISABLEICON')));
        i := JSONObject2AutoRunClass(lJSONObject, Content, subTile.Content);
        FAutoRunClass.AutoRunCollect.Items[i].TileIndex := Index;
        ItemOject := FAutoRunClass.AutoRunCollect.Items[i];
        Subtiles.Clear;
      end;
    end;
  finally
    //FreeAndNil(lJSONObject);
  end;
end;

procedure TlauncherMain_Frm.AdvGlowButton1Click(Sender: TObject);
begin
  AddNewApp2List;
end;

function TlauncherMain_Frm.Create_newApp(aEditType: Integer;
  aPath: String): TJSONObject;
var
  lTitle : String;
  lJsonArray : TJSONArray;
  lJsonObj : TJSONObject;
  LnewApp_Frm : TnewApp_Frm;
begin
  LnewApp_Frm := TnewApp_Frm.Create(nil);
  try
    with LnewApp_Frm do
    begin
      case aEditType of
        0 : //new App
        begin
          lTitle := ExtractFileName(aPath);
          appTitle.Text := Copy(lTitle,0,LastDelimiter('.',lTitle)-1);
          appPath.Text := aPath;
        end;
      end;

      if ShowModal = mrOk then
      begin
        Result := TJSONObject.Create;
        if RunParamEdit.Text = '' then
          RunParamEdit.Text := ' ';

        Result.AddPair('APPTITLE',appTitle.Text).
               AddPair('AUTORUN', BoolToStr(AutoRunCB.Checked)).
               AddPair('APPPATH',appPath.Text).
               AddPair('APPICON',FIconPath).
               AddPair('APPDISABLEICON',FDisableIconPath).
               AddPair('APPDESC',appDesc.Text).
               AddPair('APPPARAM', RunParamEdit.Text).
               AddPair('USERELATIVEPATH', BoolToStr(RelPathCB.Checked));
      end
      else
        Result := nil;
    end;
  finally
    FreeAndNil(LnewApp_Frm);
  end;
end;

procedure TlauncherMain_Frm.ExecuteList(AIsAll: Boolean; AIsAuto: Boolean;
  AIsSelected: Boolean);
var
  i: integer;
  LHandle,LProcessID: THandle;
  LAutoRunItem: TAutoRunItem;
begin
  SetCurrentDir(FFilePath);

  for i := 0 to FAutoRunClass.AutoRunCollect.Count - 1 do
  begin
    if not AIsAll then
    begin
      if AIsAuto then
      begin
        if not FAutoRunClass.AutoRunCollect.Items[i].IsAutoRun then
          continue;
      end
      else
      begin
        if AIsSelected then
        begin
          LAutoRunItem := TileListFrame.tileList.SelectedTile.ItemOject as TAutoRunItem;
          LProcessId := ExecNewProcess2(LAutoRunItem.AppPath,
                                        LAutoRunItem.RunParameter);
          LHandle := DSiGetProcessWindow(LProcessId);
          LAutoRunItem.AppHandle := LHandle;
          exit;
        end
        else
        if FAutoRunClass.AutoRunCollect.Items[i].IsAutoRun then
          continue;
      end;
    end;

    LProcessId := ExecNewProcess2(FAutoRunClass.AutoRunCollect.Items[i].AppPath,
                    FAutoRunClass.AutoRunCollect.Items[i].RunParameter);
    LHandle := DSiGetProcessWindow(LProcessId);
    FAutoRunClass.AutoRunCollect.Items[i].AppHandle := LHandle;
  end;
end;

procedure TlauncherMain_Frm.ExecuteAuto;
begin
  ExecuteList(False);
end;

procedure TlauncherMain_Frm.ExecuteAuto1Click(Sender: TObject);
begin
  ExecuteAuto;
end;

procedure TlauncherMain_Frm.ExecuteManual;
begin
  ExecuteList(False, False, False);
end;

procedure TlauncherMain_Frm.ExecuteManual1Click(Sender: TObject);
begin
  ExecuteManual;
end;

procedure TlauncherMain_Frm.ExecuteSelectedTile;
begin
  ExecuteList(False, False, True);
end;

procedure TlauncherMain_Frm.ExecuteSelectedTile1Click(Sender: TObject);
begin
  ExecuteSelectedTile;
end;

procedure TlauncherMain_Frm.FormCreate(Sender: TObject);
begin
  FFilePath := ExtractFilePath(Application.ExeName);
  SetCurrentDir(FFilePath);

  TileListFrame.InitVar;
  TileListFrame.FAddNewApp2List := AddNewApp2List;

  FAutoRunClass := TAutoRunList.Create(Self);
  FPJHTimerPool := TPJHTimerPool.Create(Self);
  FFirst := True;
end;


procedure TlauncherMain_Frm.FormDestroy(Sender: TObject);
var
  i: integer;
begin
  Timer1.Enabled := False;

  TileListFrame.DestroyVar;

  FPJHTimerPool.RemoveAll;
  FreeAndNil(FPJHTimerPool);

  for i := 0 to FAutoRunClass.AutoRunCollect.Count - 1 do
    SendMessage(FAutoRunClass.AutoRunCollect.Items[i].AppHandle, WM_CLOSE, 0, 0);

  FAutoRunClass.AutoRunCollect.Clear;
  FreeAndNil(FAutoRunClass);
end;

function TlauncherMain_Frm.Get_JsonValues(aJsonPair: TJSONPair): String;
var
  lstr : String;
  ljsonValue : TJSONValue;
begin
  ljsonValue := aJsonPair.JsonValue;
  Result := ljsonValue.Value;
end;

function TlauncherMain_Frm.JSONObject2AutoRunClass(AJSONObject: TJSONObject;
  AdvSmoothTileContent, ASubTileContent:TAdvSmoothTileContent): integer;
var
  LAutoRunItem: TAutoRunItem;
  LStr: string;
begin
  LAutoRunItem := FAutoRunClass.AutoRunCollect.Add;
  Result := LAutoRunItem.Index;
  LAutoRunItem.IsAutoRun := StrToBool(Get_JsonValues(AJSONObject.get('AUTORUN')));
  LAutoRunItem.AppDesc := Get_JsonValues(AJSONObject.get('APPDESC'));
  LAutoRunItem.AppTitle := Get_JsonValues(AJSONObject.get('APPTITLE'));
  Lstr := Get_JsonValues(AJSONObject.get('USERELATIVEPATH'));
  if StrToBool(LStr) then
    LStr := ExtractRelativePathBaseApplication(FFilePath, Get_JsonValues(AJSONObject.get('APPPATH')))
  else
    LStr := Get_JsonValues(AJSONObject.get('APPPATH'));
  LAutoRunItem.AppPath := LStr;
  LAutoRunItem.RunParameter := Get_JsonValues(AJSONObject.get('APPPARAM'));
  LAutoRunItem.AppImage := TileListFrame.ConvertImage2String(AdvSmoothTileContent.Image);
  LAutoRunItem.AppDisableImage := TileListFrame.ConvertImage2String(ASubTileContent.Image);
end;

procedure TlauncherMain_Frm.LoadConfigForm2Var(AForm: TnewApp_Frm;
  AVar: TAutoRunItem);
var
  LStr: string;
begin
  with AForm do
  begin
    AVar.AppTitle := appTitle.Text;
    AVar.IsAutoRun := AutoRunCB.Checked;
    if RelPathCB.Checked then
      LStr := ExtractRelativePathBaseApplication(FFilePath, appPath.Text)
    else
      LStr := appPath.Text;
    AVar.AppPath := LStr;
    AVar.AppDesc := appDesc.Text;
    AVar.RunParameter := RunParamEdit.Text;
    with GDIPPictureContainer1.Items do
    begin
      Clear;
      Add;
      Items[Count-1].Picture.Assign(Icon.Picture);
      AVar.AppImage := TileListFrame.ConvertImage2String(Items[Count-1].Picture);

      Items[Count-1].Picture.Assign(DisableIcon.Picture);
      AVar.AppDisableImage := TileListFrame.ConvertImage2String(Items[Count-1].Picture);
    end;
  end;
end;

procedure TlauncherMain_Frm.LoadFromFile1Click(Sender: TObject);
begin
  OpenDialog1.InitialDir := FFilePath;

  if OpenDialog1.Execute then
  begin
    if OpenDialog1.FileName <> '' then
    begin
      LoadTileFromFile(OpenDialog1.FileName, False);
    end;
  end;
end;

//AIsAppend = True: 기존 List에 추가함
//            False: 기존 List Clear;
procedure TlauncherMain_Frm.LoadTileFromFile(AFileName: string; AIsAppend: Boolean);
var
  lTile : TAdvSmoothTile;
  //LMemStream: TMemoryStream;
  i: integer;
begin
  SetCurrentDir(FFilePath);

  if not FileExists(AFileName) then
  begin
    ShowMessage('File not exist : '+AFileName);
    exit;
  end;

  if not AIsAppend then
  begin
    FAutoRunClass.AutoRunCollect.Clear;
    TileListFrame.tileList.Tiles.Clear;
  end;

  FAutoRunClass.LoadFromJSONFile(AFileName);

  //LMemStream := TMemoryStream.Create;
  //try
    for i := 0 to FAutoRunClass.AutoRunCollect.Count - 1 do
    begin
      lTile := TileListFrame.tileList.Tiles.Add;
      LoadVar2Form(lTile,FAutoRunClass.AutoRunCollect.Items[i]);
{      with lTile do
      begin
        DisplayName := FAutoRunClass.AutoRunCollect.Items[i].AppDesc;
        Content.Text := FAutoRunClass.AutoRunCollect.Items[i].AppTitle;
        Content.TextPosition := tpBottomCenter;
        Content.Hint := FAutoRunClass.AutoRunCollect.Items[i].AppPath;
        if FAutoRunClass.AutoRunCollect.Items[i].AppImage <> '' then
          Content.Image.LoadFromStream(ConvertString2Stream(FAutoRunClass.AutoRunCollect.Items[i].AppImage));
        Itemoject := FAutoRunClass.AutoRunCollect.Items[i];
      end; }
    end; //for
  //finally
    //FreeAndNil(LMemStream);
  //end;
end;

procedure TlauncherMain_Frm.LoadVar2ConfigForm(AForm: TnewApp_Frm;
  AVar: TAutoRunItem);
begin
  with AForm do
  begin
    appTitle.Text := AVar.AppTitle;
    AutoRunCB.Checked := AVar.IsAutoRun;
    appPath.Text := AVar.AppPath;
    appDesc.Text := AVar.AppDesc;
    RunParamEdit.Text := AVar.RunParameter;

    with GDIPPictureContainer1.Items do
    begin
      Clear;
      Add;
      if AVar.AppImage <> '' then
      begin
        Items[Count-1].Picture.LoadFromStream(TileListFrame.ConvertString2Stream(AVar.AppImage));
        Icon.Picture.Assign(Items[Count-1].Picture);
        Icon.Invalidate;
      end;

      if AVar.AppDisableImage <> '' then
      begin
        Items[Count-1].Picture.LoadFromStream(TileListFrame.ConvertString2Stream(AVar.AppDisableImage));
        DisableIcon.Picture.Assign(Items[Count-1].Picture);
        DisableIcon.Invalidate;
      end;
    end;
  end;
end;

procedure TlauncherMain_Frm.LoadVar2Form(ATile: TAdvSmoothTile; AVar: TAutoRunItem);
begin
  with ATile do
  begin
    Content.Text := AVar.AppTitle;
    Content.TextPosition := tpBottomCenter;

    if AVar.IsAutoRun then
      StatusIndicator := 'Auto'
    else
      StatusIndicator := '';

    Content.Hint := AVar.AppPath;
    DisplayName := AVar.AppDesc;
    ItemOject := AVar;

    if AVar.AppImage <> '' then
      Content.Image.LoadFromStream(TileListFrame.ConvertString2Stream(AVar.AppDisableImage));
  end;
end;

procedure TlauncherMain_Frm.OnDisableAppStatus(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  i,j: integer;
begin
  for i := 0 to FAutoRunClass.AutoRunCollect.Count - 1 do
  begin
    if FAutoRunClass.AutoRunCollect.Items[i].DisableTimerHandle = Handle then
    begin
      FPJHTimerPool.Remove(FAutoRunClass.AutoRunCollect.Items[i].DisableTimerHandle);
      j := FAutoRunClass.AutoRunCollect.Items[i].TileIndex;
      TileListFrame.tileList.Tiles[j].Content.Image.LoadFromStream(
        TileListFrame.ConvertString2Stream(
          FAutoRunClass.AutoRunCollect.Items[i].AppDisableImage));
      break;
    end;
  end;
end;

procedure TlauncherMain_Frm.SaveToFile1Click(Sender: TObject);
begin
  TileListFrame.SaveTile2File(TpjhBase(FAutoRunClass));
end;

procedure TlauncherMain_Frm.tileListTileDblClick(Sender: TObject;
  ATile: TAdvSmoothTile; State: TTileState);
var
  LnewApp_Frm : TnewApp_Frm;
  LAutoRunItem: TAutoRunItem;
begin
  LnewApp_Frm := TnewApp_Frm.Create(nil);
  try
    LAutoRunItem := ATile.ItemOject as TAutoRunItem;

    LoadVar2ConfigForm(LnewApp_Frm, LAutoRunItem);

    with LnewApp_Frm do
    begin
      if ShowModal = mrOk then
      begin
        LoadConfigForm2Var(LnewApp_Frm, LAutoRunItem);
        LAutoRunItem.TileIndex := ATile.Index;
        LoadVar2Form(ATile, LAutoRunItem);
      end;
    end;
  finally
    FreeAndNil(LnewApp_Frm);
  end;
end;

procedure TlauncherMain_Frm.Timer1Timer(Sender: TObject);
var
  LStr: string;
  i: integer;
begin
  Timer1.Enabled := False;
  try
    if FFirst then
    begin
      FFirst := False;
      Timer1.Interval := 5000;
      if ParamCount > 0 then
      begin
        LStr := UpperCase(ParamStr(1));
        i := Pos('/A', LStr);
        if i > 0 then  //A 제거
        begin
          LStr := Copy(LStr, i+2, Length(LStr)-i-1);
          LoadTileFromFile(LStr, False);
          ExecuteList(False, True, False);
        end;
      end;
    end;//if

    for i := 0 to FAutoRunClass.AutoRunCollect.Count - 1 do
    begin
      if FAutoRunClass.AutoRunCollect.Items[i].AppHandle <> 0 then
      begin
        FAutoRunClass.AutoRunCollect.Items[i].DisableTimerHandle :=
            FPJHTimerPool.AddOneShot(OnDisableAppStatus, 1000);
        SendHandleCopyData(FAutoRunClass.AutoRunCollect.Items[i].AppHandle, Handle, WParam_SENDWINHANDLE);
        //caption := IntToStr(FAutoRunClass.AutoRunCollect.Items[i].AppHandle);
      end;
    end;
  finally
    Timer1.Enabled := True;
  end;
end;

procedure TlauncherMain_Frm.WMCopyData(var Msg: TMessage);
var
  i,j: integer;
begin
  case Msg.WParam of //Echo
    WParam_SENDWINHANDLE: begin//Handle 수신 OK
      if PCopyDataStruct(Msg.LParam)^.dwData = Handle then
        SendHandleCopyData(PCopyDataStruct(Msg.LParam)^.cbData, Handle, WParam_RECVHANDLEOK);
    end;

    WParam_RECVHANDLEOK: begin
      if PCopyDataStruct(Msg.LParam)^.dwData = Handle then
      begin
        for i := 0 to FAutoRunClass.AutoRunCollect.Count - 1 do
        begin
          if PCopyDataStruct(Msg.LParam)^.cbData = FAutoRunClass.AutoRunCollect.Items[i].AppHandle then
          begin
            FPJHTimerPool.Remove(FAutoRunClass.AutoRunCollect.Items[i].DisableTimerHandle);
            FAutoRunClass.AutoRunCollect.Items[i].DisableTimerHandle := -1;
            j := FAutoRunClass.AutoRunCollect.Items[i].TileIndex;
            TileListFrame.tileList.Tiles[j].Content.Image.LoadFromStream(
              TileListFrame.ConvertString2Stream(
                FAutoRunClass.AutoRunCollect.Items[i].AppImage));
            break;
          end;
        end;
      end;
    end;

    WParam_FORMCLOSE: begin
      if PCopyDataStruct(Msg.LParam)^.dwData = Handle then
      begin
        for i := 0 to FAutoRunClass.AutoRunCollect.Count - 1 do
        begin
          if PCopyDataStruct(Msg.LParam)^.cbData = FAutoRunClass.AutoRunCollect.Items[i].AppHandle then
          begin
            FPJHTimerPool.Remove(FAutoRunClass.AutoRunCollect.Items[i].DisableTimerHandle);
            FAutoRunClass.AutoRunCollect.Items[i].DisableTimerHandle := -1;
            j := FAutoRunClass.AutoRunCollect.Items[i].TileIndex;
            TileListFrame.tileList.Tiles[j].Content.Image.LoadFromStream(
              TileListFrame.ConvertString2Stream(
                FAutoRunClass.AutoRunCollect.Items[i].AppDisableImage));
            break;
          end;
        end;
      end;
    end;

  end;
end;

procedure TlauncherMain_Frm.ExecuteAll1Click(Sender: TObject);
begin
  ExecuteList;
end;

end.
