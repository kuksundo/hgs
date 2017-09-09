unit SubmitReportForm;
// MIT License
//
// Copyright (c) 2009 - Robert Love
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, SCapture, ComCtrls, Contnrs, MultiMon, ShellAPi;

type
  TCaptureDisplayContext = (cdNone,cdActiveWindow,cdActiveMonitor, cdAllMonitors);
  TCaptureContextSet = set of TCaptureDisplayContext;

  TfrmSubmitReport = class(TForm)
    pnlBottom: TPanel;
    btnCancel: TButton;
    btnOK: TButton;
    Panel1: TPanel;
    Splitter1: TSplitter;
    lblReport: TLabel;
    memUserComment: TMemo;
    PageControl1: TPageControl;
    tsImage: TTabSheet;
    tsTechDetails: TTabSheet;
    tsAttach: TTabSheet;
    rgShotSelection: TRadioGroup;
    imgDisplay: TImage;
    memTechDetails: TMemo;
    lvAttachedFiles: TListView;
    btnAddAttachment: TButton;
    btnRemoveAttachment: TButton;
    dlgOpen: TOpenDialog;
    tsCallStack: TTabSheet;
    memCallStack: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rgShotSelectionClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAddAttachmentClick(Sender: TObject);
    procedure btnRemoveAttachmentClick(Sender: TObject);
  private
    FMonitorCount : Integer;
    FCaptureOptions: TCaptureContextSet;
    FDefaultOption: TCaptureDisplayContext;
    FImage : TBitMap;
    FActiveWindow : TRect;
    FDesktopWindow : TRect;
    FActiveDesktopWindow : TRect;
    FImageCaptured : Boolean;
    FMonInfoArray : Array Of MONITORINFOEX;
    FDefaultMonIdx : Integer;
    FActiveMonIndx : Integer;
    FAllowAttachments: Boolean;
    procedure AddAttachment(aFileName : String); overload;
    procedure AddAttachment(aFileName : String; Description : String); overload;
    procedure SetCaptureOptions(const Value: TCaptureContextSet);
    procedure SetDefaultOption(const Value: TCaptureDisplayContext);
    procedure SetAllowAttachments(const Value: Boolean);
    { Private declarations }
  protected
    procedure SetupRadioGroup; virtual;
    procedure SetImage(Index : TCaptureDisplayContext); virtual;
    Function ContextFromText(aText : String) : TCaptureDisplayContext;
    procedure WMDropFiles(var Msg: TWMDropFiles); message WM_DropFiles;
  public
    { Public declarations }
    property CaptureOptions : TCaptureContextSet read FCaptureOptions write SetCaptureOptions;
    property DefaultOption : TCaptureDisplayContext read FDefaultOption write SetDefaultOption;
    property AllowAttachments :  Boolean read FAllowAttachments write SetAllowAttachments;
    procedure CaptureImages; virtual;
  end;

var
  frmSubmitReport: TfrmSubmitReport;


resourcestring
   icTitle = 'Report Details';
   icReportQuestion = 'Please Provide Additional Details';
   icImageHint = 'An old Chinese proverb "A Picture''s Meaning Can Express Ten Thousand Words"';
   icGroupBox = 'Screen Shot';
   icButtonOk = 'OK';
   icButtonCancel = 'Cancel';
   icNone = 'None';
   icActiveWindow = 'Active Window';
   icActiveMonitor = 'Active Monitor';
   icAllMonitors = 'All Monitors';
   icMonitorSelectText = 'Monitor';



const
   ScreenShotText : Array[TCaptureDisplayContext] of String =
                          (icNone,icActiveWindow,
                           icActiveMonitor,icAllMonitors);


implementation

{$R *.dfm}

procedure TfrmSubmitReport.AddAttachment(aFileName: String);
var
 lDesc : String;
begin
  if InputQuery('Please add description for File.',ExtractFileName(aFileName),lDesc) then
    AddAttachment(aFileName,lDesc);
end;

procedure TfrmSubmitReport.AddAttachment(aFileName, Description: String);
var
 li : TListItem;
begin
  li := lvAttachedFiles.Items.add;
  li.Caption := aFileName;
  li.SubItems.Add(Description);
end;

procedure TfrmSubmitReport.btnAddAttachmentClick(Sender: TObject);
var
  fn : String;
begin
  if dlgOpen.Execute then
  begin
    for fn in dlgOpen.Files do
      AddAttachment(fn);
  end;

end;

procedure TfrmSubmitReport.btnRemoveAttachmentClick(Sender: TObject);
begin
   lvAttachedFiles.DeleteSelected;
end;

procedure TfrmSubmitReport.CaptureImages;
var
 h : HWND;
 Mon : HMONITOR;
 MonInfo : MONITORINFO;
begin
  if FImageCaptured then
     FImage.FreeImage;

  CaptureScreen(ccAllMonitors,FImage);

  h := GetForegroundWindow;
  GetWindowRect(h,FActiveWindow);

  Mon := MonitorFromWindow(h,MONITOR_DEFAULTTONEAREST);
  MonInfo.cbSize := SizeOf(MonInfo);
  GetMonitorInfo(Mon,@MonInfo);
  FActiveDesktopWindow := MonInfo.rcMonitor;

  h := GetDesktopWindow;
  GetWindowRect(h,FDesktopWindow);

  FImageCaptured := True;
end;

function TfrmSubmitReport.ContextFromText(
  aText: String): TCaptureDisplayContext;
begin
 for result := low(TCaptureDisplayContext) to High(TCaptureDisplayContext) do
 begin
   if ScreenShotText[result] = aText then
      exit;
 end;
 result := cdNone;
end;




procedure TfrmSubmitReport.FormCreate(Sender: TObject);
begin
  FMonitorCount := MonitorCount;
  FImage := TBitmap.Create;
  Caption := icTitle;
  rgShotSelection.Caption := icGroupBox;
  btnOK.Caption := icButtonOk;
  btnCancel.Caption := icButtonCancel;
  FCaptureOptions := [cdNone,cdActiveWindow,cdActiveMonitor,cdAllMonitors];
  FDefaultOption := cdActiveWindow;
  FAllowAttachments := True;
end;

procedure TfrmSubmitReport.FormDestroy(Sender: TObject);
begin
  FImage.FreeImage;
  FImage.Free;
end;

procedure TfrmSubmitReport.FormShow(Sender: TObject);
begin
  SetupRadioGroup;
  If Not FImageCaptured then
     CaptureImages;
  SetAllowAttachments(FAllowAttachments);
  PageControl1.ActivePage := tsImage;
  SetImage(ContextFromText(rgShotSelection.Items[rgShotSelection.ItemIndex]));

end;

procedure TfrmSubmitReport.rgShotSelectionClick(Sender: TObject);
begin
  SetImage(ContextFromText(rgShotSelection.Items[rgShotSelection.ItemIndex]));
end;

procedure TfrmSubmitReport.SetAllowAttachments(const Value: Boolean);
begin
  FAllowAttachments := Value;
  tsAttach.TabVisible := Value;
  DragAcceptFiles(Handle,Value)
end;

procedure TfrmSubmitReport.SetCaptureOptions(
  const Value: TCaptureContextSet);
begin
  FCaptureOptions := Value;
  if Visible then
     SetupRadioGroup;
end;

procedure TfrmSubmitReport.SetDefaultOption(const Value: TCaptureDisplayContext);
begin
  FDefaultOption := Value;
  if Visible then
     SetupRadioGroup;
end;

procedure TfrmSubmitReport.SetImage(Index: TCaptureDisplayContext);
var
 B : TBitMap;
 SourceRect : TRect;
 DestRect : TRect;
begin
  imgDisplay.Picture.Assign(nil);
  case Index of
   cdNone:
   begin
      exit;
   end;
   cdActiveWindow:
   begin
     SourceRect := FActiveWindow;
     DestRect := Rect(0,0,FActiveWindow.Right - FActiveWindow.Left
                         ,FActiveWindow.Bottom - FActiveWindow.Top);
   end;
   cdActiveMonitor:
   begin
     SourceRect := FActiveDesktopWindow;
     DestRect := Rect(0,0,FActiveDesktopWindow.Right - FActiveDesktopWindow.Left
                         ,FActiveDesktopWindow.Bottom - FActiveDesktopWindow.Top);
   end;
   cdAllMonitors:
   begin
     imgDisplay.Picture.Assign(FImage);
     exit;
   end;
  end; { Case }

  B := TBitMap.Create;
  try
   b.width := DestRect.Right;
   b.height := DestRect.Bottom;
   b.Canvas.CopyRect(DestRect,FImage.Canvas,SourceRect);
   imgDisplay.Picture.Assign(B);
 finally
   B.FreeImage;
   B.Free;
 end;
end;

procedure TfrmSubmitReport.SetupRadioGroup;
var
 CC : TCaptureDisplayContext;
 Cnt : Integer;
 Idx : Integer;
begin
  rgShotSelection.Items.Clear;
  Cnt := 0;
  Idx := 0;
  for CC  := low(TCaptureDisplayContext) to High(TCaptureDisplayContext) do
  begin
    if CC in FCaptureOptions then
    begin
      rgShotSelection.Items.Add(ScreenShotText[cc]);
      if CC = FDefaultOption then
         Idx := Cnt;
      Inc(Cnt);
    end;
  end;
  rgShotSelection.Columns := Cnt;
  rgShotSelection.ItemIndex := Idx;;
end;

procedure TfrmSubmitReport.WMDropFiles(var Msg: TWMDropFiles);
var
  i    : Integer;
  lCnt : Integer;
  lFileName : String;
begin
  SetLength(lFileName,1024);
  lCnt := DragQueryFile( msg.Drop,
                           $FFFFFFFF,
                           pchar(lFileName),
                           Length(lFileName) );
  for i := 0 to lCnt-1 do
  begin
    SetLength(lFileName,1024);
    DragQueryFile( msg.Drop, i,
                   pchar(lFileName), Length(lFileName) );

    AddAttachment(lFileName);
  end;
  DragFinish( msg.Drop );
end;

end.
