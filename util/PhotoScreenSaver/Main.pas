{------------------------------------------------------------------------------}
{                                                                              }
{  PicShow Demonstration                                                       }
{  by Kambiz R. Khojasteh                                                      }
{                                                                              }
{  kambiz@delphiarea.com                                                       }
{  http://www.delphiarea.com                                                   }
{                                                                              }
{------------------------------------------------------------------------------}

unit Main;

{$I DELPHIAREA.INC}

{$IFDEF COMPILER6_UP}
  {$WARN UNIT_PLATFORM OFF}  // No warning for FileCtrl unit
{$ENDIF}

{.$DEFINE CAPTURE}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, ExtDlgs, PicShow, jpeg
  {$IFDEF COMPILER2009_UP}, PngImage, {$ENDIF}, DateUtils, iniFiles, DateUtil;

{$IFDEF CAPTURE}
const
  CaptureFile = 'C:\PS%6.6u.bmp';
{$ENDIF}

type
  TMainForm = class(TForm)
    PicShow: TPicShow;
    Timer: TTimer;
    StatusBar: TStatusBar;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    lblStyle: TLabel;
    cbStyle: TComboBox;
    rgStyleControl: TRadioGroup;
    gbProgressControl: TGroupBox;
    rbProgressAuto: TRadioButton;
    rbProgressManual: TRadioButton;
    lblStyleNo: TLabel;
    tbProgress: TTrackBar;
    lblProgressStep: TLabel;
    lblProgressDelay: TLabel;
    edtProgressStep: TEdit;
    udProgressStep: TUpDown;
    edtProgressDelay: TEdit;
    udProgressDelay: TUpDown;
    ckExactTiming: TCheckBox;
    ckThreaded: TCheckBox;
    ckOverDraw: TCheckBox;
    lblDisplayInterval: TLabel;
    tbDisplayInterval: TTrackBar;
    gbBackground: TGroupBox;
    lblBackgroundMode: TLabel;
    cbBackgroundMode: TComboBox;
    btnChangeBackground: TButton;
    gbImagePlacement: TGroupBox;
    ckCenter: TCheckBox;
    ckProportional: TCheckBox;
    ckStretch: TCheckBox;
    OpenPictureDialog: TOpenPictureDialog;
    lblDisplayIntervalValue: TLabel;
    gbFrame: TGroupBox;
    lblFrameWidth: TLabel;
    edtFrameWidth: TEdit;
    udFrameWidth: TUpDown;
    btnChangeFrameColor: TButton;
    ColorDialog: TColorDialog;
    btnChangePath: TButton;
    Bevel1: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PicShowStart(Sender: TObject; Picture, Screen: TBitmap);
    procedure PicShowStop(Sender: TObject);
    procedure PicShowProgress(Sender: TObject);
    procedure PicShowDblClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure cbStyleChange(Sender: TObject);
    procedure rbProgressAutoClick(Sender: TObject);
    procedure rbProgressManualClick(Sender: TObject);
    procedure edtProgressStepChange(Sender: TObject);
    procedure edtProgressDelayChange(Sender: TObject);
    procedure ckExactTimingClick(Sender: TObject);
    procedure ckThreadedClick(Sender: TObject);
    procedure tbProgressChange(Sender: TObject);
    procedure btnChangePathClick(Sender: TObject);
    procedure tbDisplayIntervalChange(Sender: TObject);
    procedure ckOverDrawClick(Sender: TObject);
    procedure ckCenterClick(Sender: TObject);
    procedure ckStretchClick(Sender: TObject);
    procedure ckProportionalClick(Sender: TObject);
    procedure cbBackgroundModeChange(Sender: TObject);
    procedure btnChangeBackgroundClick(Sender: TObject);
    procedure edtFrameWidthChange(Sender: TObject);
    procedure btnChangeFrameColorClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PicShowAfterNewFrame(Sender: TObject; Picture, Screen: TBitmap);
  public
    Pictures: TStringList;
    PicturesPath: String;
    ShowingImage: String;
    LoadedImage: String;

    FBirthDay: TDateTime;
    FSlide,
    FShowDay: Boolean;
    FFontHeight: integer;
    FPhotoPath: string;

    {$IFDEF CAPTURE}
    CaptureSequence: Integer;
    procedure CaptureScreen;
    {$ENDIF}
    procedure CheckTimer;
    procedure ShowNextImage;
    procedure LoadNextImage;
    procedure CreateImageList(const Path: String);
    procedure SetFullScreen(Active: Boolean);

    procedure FontRotation(DrawCanvas: TCanvas; Angle, X, Y: Integer; BrushColor: TColor; Text: String);
    function LoadIni2Var: boolean;
    function CalcRemainDays: word;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

uses
  FileCtrl {$IFDEF COMPILER7_UP}, XPMan {$ENDIF};

{$IFDEF CAPTURE}
procedure TMainForm.CaptureScreen;
var
  Bitmap: TBitmap;
  ScrDC: HDC;
begin
  Update;
  Bitmap := TBitmap.Create;
  try
    Bitmap.Canvas.Brush.Color := clFuchsia;
    Bitmap.Width := Width;
    Bitmap.Height := Height;
    Bitmap.HandleType := bmDIB;
    ScrDC := GetDC(0);
    try
      BitBlt(Bitmap.Canvas.Handle, 0, 0, Width, Height, ScrDC, Left, Top, SRCCOPY);
    finally
      ReleaseDC(0, ScrDC);
    end;
    Bitmap.SaveToFile(Format(CaptureFile, [CaptureSequence]));
  finally
    Bitmap.Free;
  end;
  Inc(CaptureSequence);
end;
{$ENDIF}

// Activate or deactvates the full screen mode
procedure TMainForm.SetFullScreen(Active: Boolean);
begin
  if Active and (PicShow.Align = alClient) then
  begin
    PicShow.SetFocus;
    PicShow.Align := alNone;
    PicShow.BgMode := bmNone;
    PicShow.FrameWidth := 0;
    PicShow.ShowHint := False;
    Windows.SetParent(PicShow.Handle, 0);
    PicShow.SetBounds(0, 0, Screen.Width, Screen.Height);
    SetWindowPos(PicShow.Handle, HWND_TOPMOST, 0, 0, Screen.Width, Screen.Height, SWP_SHOWWINDOW);
    ShowCursor(False);
  end
  else if not Active and (PicShow.Align = alNone) then
  begin
    Windows.SetParent(PicShow.Handle, Self.Handle);
    PicShow.Align := alClient;
    PicShow.BgMode := TBackgroundMode(cbBackgroundMode.ItemIndex);
    PicShow.FrameWidth := udFrameWidth.Position;
    PicShow.ShowHint := True;
    ShowCursor(True);
  end;
end;

// Toggles timer based on state of controls
procedure TMainForm.CheckTimer;
begin
  Timer.Enabled := not PicShow.Busy and rbProgressAuto.Checked and (Pictures.Count > 0);
end;

// Begins transition of the currently loaded image
procedure TMainForm.ShowNextImage;
begin
  Timer.Enabled := False;
  // if there is no picture in the list, exit
  if Pictures.Count = 0 then Exit;
  // if PicShow is playing, stops it
  if PicShow.Busy then PicShow.Stop;
  // Sets the transition style according to the user's choice
  case rgStyleControl.ItemIndex of
    0: cbStyle.ItemIndex := (cbStyle.ItemIndex + 1) mod cbStyle.Items.Count;
    1: cbStyle.ItemIndex := Random(cbStyle.Items.Count);
  end;
  cbStyleChange(nil);
  // Updates image name status
  ShowingImage := LoadedImage;
  StatusBar.Panels[0].Text := 'Showing: ' + ShowingImage;
  // Begins the transition
  PicShow.Execute;
end;

// Selects randomly an image from the list and loads it in to PicShow
function TMainForm.LoadIni2Var:boolean;
var
  iniFile: TIniFile;
  LFilePath: string;
begin
  Result := False;
  LFilePath := ExtractFilePath(Application.Exename)+'ParkDongBin.ini';

  if FileExists(LFilePath) then
  begin
    iniFile := nil;
    try
      iniFile := TIniFile.Create(LFilePath);
      with iniFile do
      begin
        FPhotoPath := ReadString('ParkDongBin', 'Photo Path','.\photos');
        FBirthDay := ReadDateTime('ParkDongBin', 'Birthday',StrToDateTime('2009-07-29 11:40:00'));
      end;//with
    finally
      iniFile.Free;
      Result := True;
    end;
  end
end;

procedure TMainForm.LoadNextImage;
var
  Index: Integer;
begin
  LoadedImage := '';
  if Pictures.Count > 0 then
  begin
    repeat
      Index := Random(Pictures.Count);
    until (Pictures.Count <= 1) or (ShowingImage <> Pictures[Index]);
    LoadedImage := Pictures[Index];
    PicShow.Picture.LoadFromFile(PicturesPath + '\' + LoadedImage);
  end;
  StatusBar.Panels[1].Text := 'Next: ' + LoadedImage;
end;

// Creates a list of image filenames found in the path
procedure TMainForm.CreateImageList(const Path: String);
const
  SNoImage = 'The specified folder does not contain any supported image file.';
var
  FileList: TFileListBox;
begin
  if Path <> PicturesPath then
  begin
    FileList := TFileListBox.Create(nil);
    try
      FileList.Visible := False;
      FileList.Parent := Self;
      FileList.Mask := GraphicFileMask(TGraphic);
      FileList.Directory := Path;
      if FileList.Items.Count > 0 then
      begin
        Pictures.Assign(FileList.Items);
        PicturesPath := Path;
        if (Length(Path) > 0) and (PicturesPath[Length(Path)] = '\') then
          Delete(PicturesPath, Length(Path), 1);
        StatusBar.Panels[2].Text := IntToStr(Pictures.Count) + ' Image(s)';
        StatusBar.Panels[3].Text := 'Folder: ' + Path;
        LoadNextImage;
      end
      else
        MessageDlg(Path + #13#10 + SNoImage, mtWarning, [mbCancel], 0);
    finally
      FileList.Free;
    end;
  end;
end;

//텍스트를 360 도 회전시키며 출력하기
//ex)
{
  i := 0;
  repeat
    i := i + 45; // 45 도씩
    FontRotation(Canvas,
                i,
                ClientWidth div 2,
                ClientHeight div 2,
                Self.Color,
                'ㅋ ㅏ ㅋ ㅏ ㅋ ㅏ 불멸의 화상');
    Application.ProcessMessages;
  until i >= 360;
}
procedure TMainForm.FontRotation(DrawCanvas: TCanvas; Angle, X, Y: Integer;
  BrushColor: TColor; Text: String);
var
  Font: hFont;
  LogFont: TLogFont;
  F: TFont;
begin
  // CreateFontIndirect()는 TLogFont 의 구조를 갖는 논리적인 폰트를 만든다
  FillChar(LogFont, SizeOf(LogFont), 0);
  with LogFont do
  begin
    lfHeight      := 100;
    FFontHeight := lfHeight;
    lfOrientation := Angle * 10; // 0 ~ 3600 (각도 * 10 으로 지정)
    lfEscapement  := Angle * 10;
    lfWeight      := FW_BOLD;
    lfCharSet     := DrawCanvas.Font.CharSet;
    StrCopy(lfFaceName, 'Tahoma'); // 폰트지정
    // HFONT CreateFont(
    //          int  nHeight,          // logical height of font
    //          int  nWidth,           // logical average character width
    //          int  nEscapement,      // angle of escapement
    //          int  nOrientation,     // base-line orientation angle
    //          int  fnWeight,         // font weight
    //          DWORD  fdwItalic,      // italic attribute flag
    //          DWORD  fdwUnderline,   // underline attribute flag
    //          DWORD  fdwStrikeOut,   // strikeout attribute flag
    //          DWORD  fdwCharSet,     // character set identifier
    //          DWORD  fdwOutputPrecision,  // output precision
    //          DWORD  fdwClipPrecision,    // clipping precision
    //          DWORD  fdwQuality,     // output quality
    //          DWORD  fdwPitchAndFamily,   // pitch and family
    //          LPCTSTR  lpszFace      // address of typeface name string
    // );
  end;

  Font := CreateFontIndirect(LogFont);

  F := TFont.Create;
  F.Handle := Font;
  DrawCanvas.Font := F;
  //DrawCanvas.Brush.Color := BrushColor;
  DrawCanvas.Brush.Style := bsClear;
  DrawCanvas.TextOut(X, Y, Text);
  F. Free;
  DeleteObject(Font);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Randomize;
  {$IFDEF CAPTURE}
  PicShow.ShowHint := False;
  PicShow.Step := 5;
  PicShow.ExactTiming := False;
  rgStyleControl.ItemIndex := 0; // Random Style
  {$ENDIF}
  // Creates a string list for storing list of image files
  Pictures := TStringList.Create;
  // Updates controls by PicShow's properties
  PicShow.GetStyleNames(cbStyle.Items);
  cbStyle.ItemIndex := PicShow.Style - 1;
  rbProgressAuto.Checked := not PicShow.Manual;
  rbProgressManual.Checked := PicShow.Manual;
  udProgressStep.Position := PicShow.Step;
  udProgressDelay.Position := PicShow.Delay;
  ckExactTiming.Checked := PicShow.ExactTiming;
  ckThreaded.Checked := PicShow.Threaded;
  tbProgress.Position := PicShow.Progress;
  ckOverDraw.Checked := PicShow.OverDraw;
  ckCenter.Checked := PicShow.Center;
  ckStretch.Checked := PicShow.Stretch;
  ckProportional.Checked := PicShow.Proportional;
  cbBackgroundMode.ItemIndex :=  Ord(PicShow.BgMode);
  udFrameWidth.Position := PicShow.FrameWidth;
  tbDisplayInterval.Position := Timer.Interval;
  // you may want to extend range of TPercent type!
  tbProgress.Min := Low(TPercent);
  tbProgress.Max := High(TPercent);
  tbProgress.Frequency := (High(TPercent) - Low(TPercent)) div 10;
  // prepare list by images found in the specified path or the program's path
  //if ParamCount > 0 then
  //  CreateImageList(ParamStr(1))
  //else
  if LoadIni2Var then
    CreateImageList(FPhotoPath)
  else
  begin
    CreateImageList(ExtractFilePath(Application.ExeName) + 'Photos');
    FBirthday := StrToDateTime('2009-07-29 11:40:00');
  end;
  // Checkes state of photo changer timer
  CheckTimer;

  PicShow.Stretch := True;
  PicShow.Proportional := True;
  //PicShow.OverDraw := True;

  FSlide := True;
  FShowDay := False;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  Pictures.Free;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE:begin
      if PicShow.Align = alNone then
        Close;
    //SetFullScreen(False);
    //Key := 0;
    end;
    VK_SPACE: FSlide := not FSlide;
    VK_CONTROL : FShowDay := not FShowDay;
  end;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  SetFullScreen(PicShow.Align <> alNone);
end;

procedure TMainForm.PicShowStart(Sender: TObject; Picture, Screen: TBitmap);
begin
  CheckTimer;
  // When PicShow begins transaction, we can load the next image into the
  // control. This is possible because PicShow converts the image to Bitmap
  // and use this copy during its process.
  LoadNextImage;
end;

procedure TMainForm.PicShowStop(Sender: TObject);
begin
  CheckTimer;
end;

procedure TMainForm.PicShowProgress(Sender: TObject);
begin
  tbProgress.Position := PicShow.Progress;
  {$IFDEF CAPTURE}
  CaptureScreen;
  {$ENDIF}
end;

procedure TMainForm.PicShowAfterNewFrame(Sender: TObject; Picture,
  Screen: TBitmap);
var
  LLifeY,LLifeMon,LLifeW,LLifeD,LLifeH,LLifeM,LLifeS: string;
  LTo: TDateTime;
  ADay: Word;
begin
  if FShowDay then
  begin
    LTo := now;
    LLifeY := IntToStr(YearsBetween( FBirthDay, LTo));
    LLifeMon := IntToStr(MonthsBetween( FBirthDay, LTo));
    LLifeW := IntToStr(WeeksBetween( FBirthDay, LTo));
    LLifeD := IntToStr(DaysBetween2( FBirthDay, LTo));
    LLifeH := IntToStr(HoursBetween( FBirthDay, LTo));
    LLifeM := IntToStr(MinutesBetween( FBirthDay, LTo));
    LLifeS := IntToStr(SecondsBetween( FBirthDay, LTo));
    ADay := CalcRemainDays;
    //LLifeM,LLifeD,LLifeH,LLifeM,LLifeS
    FontRotation(Screen.canvas,0,10,10,clBlue,'태어난날 : ' + DateToStr(FBirthDay));
    FontRotation(Screen.canvas,0,10, 30 + FFontHeight,clBlue,'살아온날 : ' + LLifeD + ' 일');
    FontRotation(Screen.canvas,0,10, 50 + FFontHeight*2,clBlue,'살아온 햇수 : ' + LLifeY + ' 살');
    FontRotation(Screen.canvas,0,10, 70 + FFontHeight*3,clBlue,'살아온 월수 : ' + LLifeMon + ' 개월 ' + IntToStr(ADay) + '일');
    FontRotation(Screen.canvas,0,10, 90 + FFontHeight*4,clBlue,'살아온 주 : ' + LLifeW + ' 주');
    FontRotation(Screen.canvas,0,10, 110 + FFontHeight*5,clBlue,'살아온 시간 : ' + LLifeH + ' 시간');
    FontRotation(Screen.canvas,0,10, 130 + FFontHeight*6,clBlue,'살아온 분 : ' + LLifeM + ' 분');
    FontRotation(Screen.canvas,0,10, 150 + FFontHeight*7,clBlue,'살아온 초 : ' + LLifeS + ' 초');
  end;

end;

procedure TMainForm.PicShowDblClick(Sender: TObject);
begin
  SetFullScreen(PicShow.Align <> alNone);
end;

procedure TMainForm.TimerTimer(Sender: TObject);
begin
  if FSlide then
    ShowNextImage;
end;

procedure TMainForm.cbStyleChange(Sender: TObject);
begin
  if PicShow.Style <> cbStyle.ItemIndex + 1 then
  begin
    PicShow.Style := cbStyle.ItemIndex + 1;
    lblStyleNo.Caption := Format('[ #%d ]', [PicShow.Style]);
    lblStyleNo.Update;
    cbStyle.Hint := PicShow.StyleName;
    if PtInRect(cbStyle.BoundsRect, cbStyle.Parent.ScreenToClient(Mouse.CursorPos)) then
      Application.CancelHint;
  end;
end;

procedure TMainForm.rbProgressAutoClick(Sender: TObject);
begin
  PicShow.Manual := False;
  lblProgressStep.Enabled := not PicShow.Manual;
  edtProgressStep.Enabled := not PicShow.Manual;
  udProgressStep.Enabled := not PicShow.Manual;
  lblProgressDelay.Enabled := not PicShow.Manual;
  edtProgressDelay.Enabled := not PicShow.Manual;
  udProgressDelay.Enabled := not PicShow.Manual;
  ckExactTiming.Enabled := not PicShow.Manual;
  ckThreaded.Enabled := not PicShow.Manual;
  tbProgress.Enabled := PicShow.Manual;
  CheckTimer;
end;

procedure TMainForm.rbProgressManualClick(Sender: TObject);
begin
  PicShow.Manual := True;
  lblProgressStep.Enabled := not PicShow.Manual;
  edtProgressStep.Enabled := not PicShow.Manual;
  udProgressStep.Enabled := not PicShow.Manual;
  lblProgressDelay.Enabled := not PicShow.Manual;
  edtProgressDelay.Enabled := not PicShow.Manual;
  udProgressDelay.Enabled := not PicShow.Manual;
  ckExactTiming.Enabled := not PicShow.Manual;
  ckThreaded.Enabled := not PicShow.Manual;
  tbProgress.Enabled := PicShow.Manual;
  tbProgress.PageSize := PicShow.Step;
  tbProgress.Position := PicShow.Progress;
  CheckTimer;
  // When PicShow is in manual mode, first we must call the Execute method.
  // Then, we can change the Progress property. If PicShow is already busy,
  // calling the Execute method is not necessary.
  if not (PicShow.Busy or PicShow.Empty) then
  begin
    Update;
    PicShow.Execute;
  end;
end;

procedure TMainForm.edtProgressStepChange(Sender: TObject);
begin
  PicShow.Step := udProgressStep.Position;
end;

procedure TMainForm.edtProgressDelayChange(Sender: TObject);
begin
  PicShow.Delay := udProgressDelay.Position;
end;

procedure TMainForm.ckExactTimingClick(Sender: TObject);
begin
  PicShow.ExactTiming := ckExactTiming.Checked;
end;

procedure TMainForm.ckThreadedClick(Sender: TObject);
begin
  PicShow.Threaded := ckThreaded.Checked;
end;

procedure TMainForm.tbProgressChange(Sender: TObject);
begin
  if PicShow.Manual then
    PicShow.Progress := tbProgress.Position;
end;

procedure TMainForm.btnChangePathClick(Sender: TObject);
var
  Path: String;
begin
  Path := PicturesPath;
  if SelectDirectory('Select folder of images for slide show:', '', Path) then
    CreateImageList(Path);
end;

//날짜가 같으면 1일을 반환
function TMainForm.CalcRemainDays: word;
var
  AYear, AMonth, ADay: Word;
  Tempdate: TDateTime;
begin
  Result := 0;

  DecodeDate(Today, AYear, AMonth, ADay);
  ADay := DayOf(FBirthDay);

  if ADay <> Dayof(Today) then
  begin
    if ADay > Dayof(Today) then
    begin
      if AMonth = 1 then
      begin
        Dec(AYear);
        AMonth := 12;
      end
      else
        Dec(AMonth);
        
      if not IsValidDate(AYear, AMonth, ADay) then
        ADay := DaysPerMonth(AYear, AMonth);
    end;

    if IsValidDate(AYear, AMonth, ADay) then
    begin
      Tempdate := EncodeDate(AYear, AMonth, ADay);
      Result := DaysBetween2(Tempdate, Today);
    end;
  end
  else
    Result := 1;
end;

procedure TMainForm.tbDisplayIntervalChange(Sender: TObject);
begin
  Timer.Interval := tbDisplayInterval.Position;
  lblDisplayIntervalValue.Caption := Format('[ %.1f Seconds ]', [Timer.Interval / 1000]);
end;

procedure TMainForm.ckOverDrawClick(Sender: TObject);
begin
  PicShow.OverDraw := ckOverDraw.Checked;
end;

procedure TMainForm.ckCenterClick(Sender: TObject);
begin
  PicShow.Center := ckCenter.Checked;
end;

procedure TMainForm.ckStretchClick(Sender: TObject);
begin
  PicShow.Stretch := ckStretch.Checked;
end;

procedure TMainForm.ckProportionalClick(Sender: TObject);
begin
  PicShow.Proportional := ckProportional.Checked;
end;

procedure TMainForm.cbBackgroundModeChange(Sender: TObject);
begin
  PicShow.BgMode := TBackgroundMode(cbBackgroundMode.ItemIndex);
end;

procedure TMainForm.btnChangeBackgroundClick(Sender: TObject);
begin
  if OpenPictureDialog.Execute then
    PicShow.BgPicture.LoadFromFile(OpenPictureDialog.FileName);
end;

procedure TMainForm.edtFrameWidthChange(Sender: TObject);
begin
  PicShow.FrameWidth := udFrameWidth.Position;
end;

procedure TMainForm.btnChangeFrameColorClick(Sender: TObject);
begin
  ColorDialog.Color := PicShow.FrameColor;
  if ColorDialog.Execute then
    PicShow.FrameColor := ColorDialog.Color;
end;

end.

