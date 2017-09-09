unit UnitCatvPanel;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ShellApi, Vcl.StdCtrls, Vcl.ExtCtrls,
  ActiveX, System.Win.ComObj, Vcl.AppEvnts, Vcl.Menus, Vcl.ImgList, TimerPool,DateUtils,
  // cromis units
  Cromis.Comm.Custom, Cromis.Comm.IPC, Cromis.Threading, Cromis.AnyValue,
  UnitFrameCromisIPCServer, AdvOfficePager, UnitScheduleList, UeventsSink_PPT,
  UnitSynLog, PowerPoint_TLB, JvComponentBase, JvChangeNotify, Vcl.ComCtrls,
  Vcl.Buttons, UnitCatvParamClass, GpCommandLineParser;

const
  WM_OPENPPSX = WM_USER + 1;
   msoTrue = $FFFFFFFF;
   msoFalse = $00000000;

type
  PCATVRecord = ^TCATVRecord;
  TCATVRecord = record
    FFileName: string;
    FDirName: string;
  end;

type
  TCatvPanelF = class(TForm)
    TrayIcon1: TTrayIcon;
    PopupMenu2: TPopupMenu;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    ApplicationEvents1: TApplicationEvents;
    ImageList1: TImageList;
    AdvOfficePager1: TAdvOfficePager;
    AdvOfficePager11: TAdvOfficePage;
    Edit1: TEdit;
    FCIPCServer: TFrameCromisIPCServer;
    AdvOfficePager12: TAdvOfficePage;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    pnlTop: TPanel;
    ShowScheduleListForm1: TMenuItem;
    AdvOfficePage1: TAdvOfficePage;
    Label3: TLabel;
    ListBox2: TListBox;
    ListView1: TListView;
    Panel2: TPanel;
    btnStart: TSpeedButton;
    Label2: TLabel;
    Label4: TLabel;
    btnAdd: TButton;
    btnDelete: TButton;
    Edit2: TEdit;
    udInterval: TUpDown;
    btnClear: TButton;
    JvChangeNotify1: TJvChangeNotify;
    ShowBlack1: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure ApplicationEvents1Minimize(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ShowScheduleListForm1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnClearClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure JvChangeNotify1ChangeNotify(Sender: TObject; Dir: string;
      Actions: TJvChangeActions);
    procedure ShowBlack1Click(Sender: TObject);
    procedure ApplicationEvents1Activate(Sender: TObject);
  private
    AppWnd : DWORD;
    FCATVRecord : TCATVRecord;
    FPJHTimerPool: TPJHTimerPool;
    FCurrentFileList: TStringList;
    FCommandLine: TCatvParameter;

    procedure OnOpenPPSX(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt); virtual;
    procedure OnOpenDirectory(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt); virtual;

    procedure OnExecuteRequest(const Context: ICommContext; const Request, Response: IMessageData);
    procedure WMCopyData(var Msg: TMessage); message WM_COPYDATA;
    procedure WMOpenPPSX(var Msg: TMessage); message WM_OPENPPSX;
    procedure ShowMainForm;
    procedure SendRecordCopyData(ToHandle: integer; ARecord: TCATVRecord);
    procedure ShowScheduleListForm;
    procedure MySlideShowEnd(ASender: TObject; const Pres: PowerPointPresentation);
    procedure MyPresentationClose(ASender: TObject; const Pres: PowerPointPresentation);
    procedure MySlideShowNextSlide(ASender: TObject; const Wn: SlideShowWindow);
    function OnSlideShowEnd(const Pres: OleVariant): HResult;

    procedure ResetCaptions(Invert: boolean);
    procedure WMGetMinMaxInfo(var Msg: TWMGetMinMaxInfo); message WM_GETMINMAXINFO;
    procedure EditItem(li: TListItem);
    procedure DeleteItem(li: TListItem);

    procedure GetFileListFromDir(AList: TStringList; Path, Mask: string; IncludeSubDir: boolean; Attr: integer = faAnyFile - faDirectory);
    function CommandLineParse(var AErrMsg: string): boolean;
  public
    oPPTApp: OleVariant;
    oPPTPres: OleVariant;
    oPPTCurrentPres: OleVariant;

    FPptApp: TPowerPointApplication;
    FIsOnlyOneFile: Boolean; //True = 디렉토리별 한개의 파일만 표시할 경우

    procedure InitVar;
    procedure FinilizeVar;
    procedure OpenPPSX(AFileName: string; AIsEmbeded: Boolean = False);
    procedure OpenPPSX2(AFileName: TCATVRecord; AIsEmbeded: Boolean = False);
  end;

var
  CatvPanelF: TCatvPanelF;

implementation

uses UnitCATVAsyncIPC, ChangeNotificationDirDlgU, UnitBlack;

{$R *.dfm}

const
  SHOW_FILE = 'c:\엔진기계사업본부 시험방송.ppsx';
  SHOW_FILE2 = 'c:\AM1.ppsx';

function OptionsToStr(Options: TJvChangeActions): string;
begin
  Result := '';
  if caChangeFileName in Options then
    Result := Result + 'Rename Files,';
  if caChangeDirName in Options then
    Result := Result + 'Rename Folders,';
  if caChangeAttributes in Options then
    Result := Result + 'Change Attributes,';
  if caChangeSize in Options then
    Result := Result + 'Change Size,';
  if caChangeLastWrite in Options then
    Result := Result + 'Change Content,';
  if caChangeSecurity in Options then
    Result := Result + 'Change Security,';
  if Length(Result) > 0 then
  begin
    SetLength(Result, Length(Result) - 1);
    Result := '(' + Result + ')';
  end;
end;

procedure TCatvPanelF.ApplicationEvents1Activate(Sender: TObject);
begin
  BlackF.Show;
end;

procedure TCatvPanelF.ApplicationEvents1Minimize(Sender: TObject);
begin
  Hide();
  WindowState := wsMinimized;

//  { Show the animated tray icon and also a hint balloon. }
  TrayIcon1.Visible := True;
  TrayIcon1.Animate := True;
  TrayIcon1.ShowBalloonHint;
end;

procedure TCatvPanelF.btnAddClick(Sender: TObject);
begin
  EditItem(nil);
end;

procedure TCatvPanelF.btnClearClick(Sender: TObject);
begin
  ListBox2.Clear;
  ResetCaptions(false);
end;

procedure TCatvPanelF.btnDeleteClick(Sender: TObject);
begin
  DeleteItem(ListView1.Selected);
end;

procedure TCatvPanelF.btnStartClick(Sender: TObject);
var b: boolean;
begin
  if JvChangeNotify1.Notifications.Count = 0 then
  begin
    ShowMessage('No notifications to monitor!');
    btnStart.Down := false;
    Exit;
  end;

  b := btnStart.Down;
  btnAdd.Enabled := not b;
  btnDelete.Enabled := not b;
  ResetCaptions(true);
  { do this *after* setting buttons }
  JvChangeNotify1.Active := b;
end;

procedure TCatvPanelF.Button1Click(Sender: TObject);
var
  ExecuteFile : string;
  SEInfo: TShellExecuteInfo;
begin
  ExecuteFile:='c:\Windows\notepad.exe';

  FillChar(SEInfo, SizeOf(SEInfo), 0) ;
  SEInfo.cbSize := SizeOf(TShellExecuteInfo) ;
  with SEInfo do
  begin
    fMask := SEE_MASK_NOCLOSEPROCESS;
    Wnd := pnlTop.Handle;
    lpFile := PChar(ExecuteFile) ;
    nShow := SW_HIDE;
  end;
  if ShellExecuteEx(@SEInfo) then
  begin
    AppWnd := FindWindow(nil, PChar('제목 없음 - 메모장'));
    if AppWnd <> 0 then
    begin
      Winapi.Windows.SetParent(AppWnd, SEInfo.Wnd);
      ShowWindow(AppWnd, SW_SHOWMAXIMIZED);
      ShowWindow(AppWnd, SW_SHOWMAXIMIZED);
    end;
  end
  else
    ShowMessage('Error starting notepad!') ;
end;

procedure TCatvPanelF.Button2Click(Sender: TObject);
Var Powerpoint : variant;
begin
  Powerpoint := CreateOleObject('Powerpoint.Application');
//  Powerpoint.Visible := False;
  Powerpoint.Presentations.Open('e:\scan\엔진기계사업본부 시험방송.ppsx', False, False,True);
  Powerpoint.Visible := True;
  PowerPoint.ActivePresentation.SlideShowSettings.Run;
end;

procedure TCatvPanelF.Button3Click(Sender: TObject);
begin
  FCATVRecord.FFileName := SHOW_FILE;
  OpenPPSX2(FCATVRecord);
end;

procedure TCatvPanelF.Button4Click(Sender: TObject);
begin
  FCATVRecord.FFileName := SHOW_FILE2;
  OpenPPSX2(FCATVRecord);
end;

function TCatvPanelF.CommandLineParse(var AErrMsg: string): boolean;
var
  LStr: string;
begin
  AErrMsg := '';

  try
    CommandLineParser.Options := [opIgnoreUnknownSwitches];
    Result := CommandLineParser.Parse(FCommandLine);
  except
    on E: ECLPConfigurationError do begin
      AErrMsg := '*** Configuration error ***' + #13#10 +
        Format('%s, position = %d, name = %s',
          [E.ErrorInfo.Text, E.ErrorInfo.Position, E.ErrorInfo.SwitchName]);
      Exit;
    end;
  end;

  if not Result then
  begin
    AErrMsg := Format('%s, position = %d, name = %s',
      [CommandLineParser.ErrorInfo.Text, CommandLineParser.ErrorInfo.Position,
       CommandLineParser.ErrorInfo.SwitchName]) + #13#10;
    for LStr in CommandLineParser.Usage do
      AErrMsg := AErrMSg + LStr + #13#10;
  end
  else
  begin
  end;
end;

procedure TCatvPanelF.DeleteItem(li: TListItem);
begin
  if li = nil then
    Exit;
  if li.Data <> nil then
    JvChangeNotify1.Notifications.Delete(li.Index);
  li.Delete;
end;

procedure TCatvPanelF.EditItem(li: TListItem);
var ADirectory: string;
  AOptions: TJvChangeActions;
  AIncludeSubDirs: boolean;
begin
  if (li = nil) or (li.Data = nil) then
  begin
    ADirectory := GetCurrentDir;
    AIncludeSubDirs := true;
    AOptions := [caChangeFileName, caChangeDirName];
  end
  else
    with TJvChangeItem(li.Data) do
    begin
      ADirectory := Directory;
      AIncludeSubDirs := IncludeSubTrees;
      AOptions := Actions;
    end;

  if TChangeNotificationDirDlg.Execute(ADirectory, AOptions, AIncludeSubDirs) then
  begin
    if li = nil then
    begin
      li := ListView1.Items.Add;
      li.Caption := ADirectory;
      if AIncludeSubDirs and (Win32Platform = VER_PLATFORM_WIN32_NT) then
        li.SubItems.Add('Yes')
      else
        li.SubItems.Add('No');
      li.SubItems.Add(OptionsToStr(AOptions));
    end
    else
    begin
      li.Caption := ADirectory;
      if AIncludeSubDirs and (Win32Platform = VER_PLATFORM_WIN32_NT) then
        li.SubItems[0] := 'Yes'
      else
        li.SubItems[0] := 'No';
      li.SubItems[1] := OptionsToStr(AOptions);
    end;
    if li.Data = nil then
      li.Data := JvChangeNotify1.Notifications.Add;
    with TJvChangeItem(li.Data) do
    begin
      IncludeSubTrees := AIncludeSubDirs and (Win32Platform = VER_PLATFORM_WIN32_NT);
      Directory := ADirectory;
      Actions := AOptions;
    end;
  end;
end;

procedure TCatvPanelF.FinilizeVar;
begin
  FCommandLine.Free;
  FPJHTimerPool.RemoveAll;
  FPJHTimerPool.Free;
  FPptApp.Free;
  FCurrentFileList.Free;
end;

procedure TCatvPanelF.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  JvChangeNotify1.Active := false;
end;

procedure TCatvPanelF.FormCreate(Sender: TObject);
begin
  InitVar;
end;

procedure TCatvPanelF.FormDestroy(Sender: TObject);
begin
  TrayIcon1.Visible := False;
  FinilizeVar;
end;

procedure TCatvPanelF.GetFileListFromDir(AList: TStringList; Path, Mask: string;
  IncludeSubDir: boolean; Attr: integer);
var
 FindResult: integer;
 SearchRec : TSearchRec;
begin
  Path := IncludeTrailingPathDelimiter(Path);
  FindResult := FindFirst(Path + Mask, Attr, SearchRec);

  while FindResult = 0 do
  begin
    { do whatever you'd like to do with the files found }
    AList.Add(Path + SearchRec.Name);
    FindResult := FindNext(SearchRec);
  end;
  { free memory }
  FindClose(SearchRec);

  if not IncludeSubDir then
    Exit;

  FindResult := FindFirst(Path + '*.*', faDirectory, SearchRec);
  while FindResult = 0 do
  begin
    if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
      GetFileListFromDir (AList, Path + SearchRec.Name + '\', Mask, TRUE);

    FindResult := FindNext(SearchRec);
  end;
  { free memory }
  FindClose(SearchRec);
end;

procedure TCatvPanelF.InitVar;
var
  LMsg: string;
begin
  InitSynLog;
//  oPPTApp := CreateOleObject('PowerPoint.Application');
  FPptApp := TPowerPointApplication.Create(Self);
  FPptApp.OnSlideShowEnd := MySlideShowEnd;
  FPptApp.OnPresentationClose := MyPresentationClose;
  FPptApp.OnSlideShowNextSlide := MySlideShowNextSlide;

  FPJHTimerPool := TPJHTimerPool.Create(Self);
  FCurrentFileList := TStringList.Create;
  FCommandLine := TCatvParameter.Create;
  FCIPCServer.SetCustomOnRequest(OnExecuteRequest);
  FCIPCServer.FAutoStartInterval := 5000; //5초
  FCIPCServer.FIPCServerName := IPCSERVERNAME;

  CommandLineParse(LMsg);

  if FCommandLine.FDisplayFileName <> '' then
  begin
    FCATVRecord.FFileName := FCommandLine.FDisplayFileName;
    FPJHTimerPool.AddOneShot(OnOpenPPSX, 1000);
  end;
end;

procedure TCatvPanelF.JvChangeNotify1ChangeNotify(Sender: TObject; Dir: string;
  Actions: TJvChangeActions);
begin
  Application.Title := Format('Change in %s (%s)', [Dir, ActionsToString(Actions)]);
  ListBox2.Items.Add(Application.Title);
  FlashWindow(CatvPanelF.Handle, true);
  MessageBeep(DWORD(-1));
end;

procedure TCatvPanelF.MenuItem6Click(Sender: TObject);
begin
  Close;
end;

procedure TCatvPanelF.MyPresentationClose(ASender: TObject;
  const Pres: PowerPointPresentation);
begin
  oPPTPres := UnAssigned;

  FCIPCServer.DisplayMessageFromOuter('Presentation Closed', 0);
end;

procedure TCatvPanelF.MySlideShowEnd(ASender: TObject;
  const Pres: PowerPointPresentation);
begin
  if not VarIsEmpty(oPPTPres) then
  begin
    oPPTPres.Close;
    oPPTPres := UnAssigned;
  end;
//  ShowMessage('Presentation Ended');
  FCIPCServer.DisplayMessageFromOuter('Presentation Ended', 0);
end;

procedure TCatvPanelF.MySlideShowNextSlide(ASender: TObject;
  const Wn: SlideShowWindow);
var
  i: integer;
begin
  if not VarIsEmpty(oPPTPres) then
  begin
    i := wn.View.Slide.SlideIndex;

    FCIPCServer.DisplayMessageFromOuter('Current Slide No = ' + IntToStr(i), 0);

    if i = oPPTPres.Slides.Count then
    begin
//      FCIPCServer.DisplayMessageFromOuter(oPPTPres.FullName + ' is Closed!', 0);
//      oPPTPres.Close;
    end;
  end;
end;

procedure TCatvPanelF.OnExecuteRequest(const Context: ICommContext; const Request,
  Response: IMessageData);
var
  Command: AnsiString;
  LFileName, LDirName, LData: string;
  LSendIsOk: Boolean;
begin
  LSendIsOk := False;
  Command := UpperCase(Request.Data.ReadUnicodeString('Command'));
  Response.Data.WriteDateTime('TDateTime', Now);
  Response.Data.WriteUnicodeString('Command', Command);

  if Command = 'CHANGE_FILENAME' then
  begin
    Response.ID := '4';
    LFileName := Request.Data.ReadUnicodeString('FileName');
    LDirName := Request.Data.ReadUnicodeString('DirName');
    LSendIsOk := True;
  end;

  if LSendIsOk then
  begin
    if FileExists(LFileName) then
    begin
      FCATVRecord.FFileName := LFileName;
      LData := LFileName;
    end
    else
    if FileExists(LDirName) then
    begin
      FCATVRecord.FDirName := LDirName;
      LData := LDirName;
    end;

    FPJHTimerPool.AddOneShot(OnOpenPPSX, 1000);

    Response.Data.WriteUnicodeString('Data', LData);
    FCIPCServer.DisplayMessageFromOuter(DateTimeToStr(Response.Data.ReadDateTime('TDateTime')) +
      ': Command = ' + Command + ' >>> Send Data = ' + LData, 2);
  end;
end;

procedure TCatvPanelF.OnOpenDirectory(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FCIPCServer.DisplayMessageFromOuter(FCATVRecord.FFileName,0);
  FCurrentFileList.Clear;
  GetFileListFromDir(FCurrentFileList, FCATVRecord.FFileName, '*.ppsx', False);
end;

procedure TCatvPanelF.OnOpenPPSX(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  if FCATVRecord.FFileName <> '' then
  begin
    FCIPCServer.DisplayMessageFromOuter(FCATVRecord.FFileName,0);
  end
  else
  if FCATVRecord.FDirName <> '' then
  begin
    FCIPCServer.DisplayMessageFromOuter(FCATVRecord.FDirName,0);
  end;

//  OpenPPSX(FCATVRecord.FFileName);
  OpenPPSX2(FCATVRecord, True);
end;

function TCatvPanelF.OnSlideShowEnd(const Pres: OleVariant): HResult;
begin
end;

procedure TCatvPanelF.OpenPPSX(AFileName: string; AIsEmbeded: Boolean);
const
  ppShowTypeSpeaker = 1;
  ppShowTypeInWindow = 1000;
var
  screenClasshWnd: HWND;
  pWidth, pHeight: Integer;

  function PixelsToPoints(Val: Integer; Vert: Boolean): Integer;
  begin
    if Vert then
      Result := Trunc(Val * 0.75)
    else
      Result := Trunc(Val * 0.75);
  end;

begin
  try
  //  oPPTApp := CreateOleObject('PowerPoint.Application');
    if not VarIsEmpty(oPPTPres) then
      oPPTPres.Close;

    oPPTPres := oPPTApp.Presentations.Open(AFileName, True, True, False);
//    oPPTApp.SlideShowEnd := OnSlideShowEnd(oPPTPres);
//    oPPTApp.SlideShowEnd := oPPTApp.SlideShowEnd + @OnSlideShowEnd(oPPTPres);

    if AIsEmbeded then
    begin
      pWidth := PixelsToPoints(pnlTop.Width, False);
      pHeight := PixelsToPoints(pnlTop.Height, True);
      oPPTPres.SlideShowSettings.ShowType := ppShowTypeSpeaker;
      oPPTPres.SlideShowSettings.Run.Width := pWidth;
      oPPTPres.SlideShowSettings.Run.Height := pHeight;

      screenClasshWnd := FindWindow('screenClass', nil);
      Winapi.Windows.SetParent(screenClasshWnd, pnlTop.Handle);
    end
    else
      oPPTPres.SlideShowSettings.Run;
  finally
  end;
end;

procedure TCatvPanelF.OpenPPSX2(AFileName: TCATVRecord; AIsEmbeded: Boolean);
const
  ppShowTypeSpeaker = 1;
  ppShowTypeInWindow = 1000;
var
  screenClasshWnd: HWND;
  pWidth, pHeight: Integer;

  function PixelsToPoints(Val: Integer; Vert: Boolean): Integer;
  begin
    if Vert then
      Result := Trunc(Val * 0.75)
    else
      Result := Trunc(Val * 0.75);
  end;

begin
  try
    if (not VarIsEmpty(oPPTPres)) then
      oPPTPres.Close;

    oPPTPres := FPptApp.Presentations.Open(AFileName.FFileName, msoTrue, msoTrue, msoFalse);
//    ShowMessage(IntToStr(oPPTPres.Slides.Count));

    if AIsEmbeded then
    begin
      pWidth := PixelsToPoints(BlackF.Panel1.Width, False);
      pHeight := PixelsToPoints(BlackF.Panel1.Height, True);
      oPPTPres.SlideShowSettings.ShowType := ppShowTypeSpeaker;
      oPPTPres.SlideShowSettings.Run.Width := pWidth;
      oPPTPres.SlideShowSettings.Run.Height := pHeight;

      screenClasshWnd := FindWindow('screenClass', nil);
      Winapi.Windows.SetParent(screenClasshWnd, BlackF.Panel1.Handle);
    end
    else
      oPPTPres.SlideShowSettings.Run;
  finally
    oPPTPres.SlideShowWindow.View.PointerType := ppSlideShowPointerAlwaysHidden;
  end;
end;

procedure TCatvPanelF.ResetCaptions(Invert: boolean);
const
  aCap: array[boolean] of string = ('TJvChangeNotification demo', 'Checking...');
begin
  if Invert then
    Caption := aCap[not JvChangeNotify1.Active]
  else
    Caption := aCap[JvChangeNotify1.Active];
  Application.Title := Caption;
end;

procedure TCatvPanelF.SendRecordCopyData(ToHandle: integer; ARecord: TCATVRecord);
var
  cd : TCopyDataStruct;
begin
  with cd do
  begin
    dwData := Application.Handle;
    cbData := sizeof(ARecord);
    lpData := @ARecord;
  end;//with

  SendMessage(ToHandle, WM_COPYDATA, 0, LongInt(@cd));
end;

procedure TCatvPanelF.ShowBlack1Click(Sender: TObject);
begin
  BlackF.Show;
end;

procedure TCatvPanelF.ShowMainForm;
begin
//  TrayIcon1.Visible := False;
  Show();
  WindowState := wsNormal;
  Application.BringToFront();
end;

procedure TCatvPanelF.ShowScheduleListForm;
var
  LScheduleListF: TScheduleListF;
begin
  LScheduleListF := TScheduleListF.Create(nil);
  try
    LScheduleListF.ShowModal;
  finally
    LScheduleListF.Free;
  end;
end;

procedure TCatvPanelF.ShowScheduleListForm1Click(Sender: TObject);
begin
  ShowScheduleListForm;
end;

procedure TCatvPanelF.TrayIcon1DblClick(Sender: TObject);
begin
  ShowMainForm;
end;

procedure TCatvPanelF.WMCopyData(var Msg: TMessage);
begin
  case Msg.WParam of
    0: ;//OpenPPSX(PCATVRecord(PCopyDataStruct(Msg.LParam)^.lpData)^.FFileName);
  end;
end;

procedure TCatvPanelF.WMGetMinMaxInfo(var Msg: TWMGetMinMaxInfo);
begin
  with Msg.MinMaxInfo^.ptMinTrackSize do
  begin
    X := 392;
    Y := 295;
  end;
  Msg.Result := 0;
end;

procedure TCatvPanelF.WMOpenPPSX(var Msg: TMessage);
begin
  OpenPPSX(FCATVRecord.FFileName);
end;

end.
