(* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is dscontrol.pas of Karsten Bilderschau, version 3.2.12.
 *
 * The Initial Developer of the Original Code is Matthias Muntwiler.
 * Portions created by the Initial Developer are Copyright (C) 2006
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** *)

{ $Id: dscontrol.pas 65 2006-10-22 00:20:52Z hiisi $ }

{
@abstract DirectShow playback control form
@author matthias muntwiler <hiisi@users.sourceforge.net>
@created 2003/05/17
@cvs $Date: 2006-10-21 19:20:52 -0500 (Sa, 21 Okt 2006) $

The @link(TDirectShowControl) form handles the playback of DirectX-compatible
movie files.
}
unit dscontrol;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComObj, DirectShow, ComCtrls, Buttons, ExtCtrls, Math, JvExComCtrls,
  JvComCtrls, JvUpDown, PngSpeedButton, ImgList, PngImageList;

const
  wm_MediaEvent = wm_User + 1;

type
  TMediaEventNotify = procedure(Sender: TObject; eventcode: integer) of object;

type
  { @abstract DirectShow playback control form

    This form handles the playback of DirectX-compatible movie files,
    and provides some movie controls to the user.
    Initially, the form is invisible but can be made visible on demand.
    The actual movie displays in the window specified by @link(DisplayWindow).
  }
  TDirectShowControl = class(TForm)
    ButtonsPanel: TPanel;
    TrackingTimer: TTimer;
    TimeTrackBar: TJvTrackBar;
    VolumeUpDown: TJvUpDown;
    PauseButton: TPngSpeedButton;
    PlayButton: TPngSpeedButton;
    StopButton: TPngSpeedButton;
    RewindButton: TPngSpeedButton;
    ForwardButton: TPngSpeedButton;
    ImageList: TPngImageList;
    procedure TimeTrackBarKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TimeTrackBarKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure VolumeUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure TimeTrackBarChange(Sender: TObject);
    procedure TimeTrackBarMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TimeTrackBarMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TrackingTimerTimer(Sender: TObject);
    procedure PlayButtonClick(Sender: TObject);
    procedure PauseButtonClick(Sender: TObject);
    procedure StopButtonClick(Sender: TObject);
    procedure RewindButtonClick(Sender: TObject);
    procedure ForwardButtonClick(Sender: TObject);
  private
    DSReady: boolean;
    FMediaReady: boolean;
    FPlaying: boolean;
    FDisplayWindow: HWnd;
    FOnMediaEvent: TMediaEventNotify;
    FDisplayRect: TRect;
    AudioExists: boolean;
    { Indicates that the user is dragging the @link(TimeTrackBar) slider,
      i.e. has the mouse button down in that control.
      In this case we must not update the slider position in @link(TrackingTimerTimer). }
    UserSeeking: boolean;
    { Indicates whether the user has adjusted the volume using this control.
      In this case we start each movie with the adjusted volume. }
    ControlVolume: boolean;
    procedure SetDisplayRect(const Value: TRect);
    procedure SetDisplayWindow(const Value: HWnd);
  protected
    { Detected media duration in 100 ns units (default time format). }
    Duration: int64;
    { Skip amount used by @link(SkipForward) and @link(SkipBack) in 100 ns units. }
    SkipAmount: int64;
    GraphBuilder: IGraphBuilder;
    MediaControl: IMediaControl;
    MediaSeeking: IMediaSeeking;
    BasicAudio: IBasicAudio;
    BasicVideo: IBasicVideo;
    VideoWindow: IVideoWindow;
    MediaEvent: IMediaEventEx;
    procedure UpdateControlRanges;
    procedure UpdateControlStates;
		procedure	WMMediaEvent(var message: TMessage); message wm_MediaEvent;
  public
    procedure LoadFile(filename: string);
    procedure ReleaseMedia;
    function  GetVideoSize: TPoint;
    procedure Play;
    procedure Stop;
    procedure Pause;
    procedure SkipForward;
    procedure SkipBack;
    property  OnMediaEvent: TMediaEventNotify read FOnMediaEvent write FOnMediaEvent;
    property  DisplayWindow: HWnd read FDisplayWindow write SetDisplayWindow;
    property  DisplayRect: TRect read FDisplayRect write SetDisplayRect;
    property  MediaReady: boolean read FMediaReady;
    property  Playing: boolean read FPlaying;
  end;

var
  DirectShowControl: TDirectShowControl;

implementation
uses
  gnugettext;

{$R *.DFM}

{ TDirectShowControl }

procedure TDirectShowControl.FormCreate(Sender: TObject);
begin
  TranslateComponent(Self);
  DSReady := false;
  PlayButton.PngImage.Assign(ImageList.PngImages[0].PngImage);
  PauseButton.PngImage.Assign(ImageList.PngImages[1].PngImage);
  StopButton.PngImage.Assign(ImageList.PngImages[2].PngImage);
  RewindButton.PngImage.Assign(ImageList.PngImages[3].PngImage);
  ForwardButton.PngImage.Assign(ImageList.PngImages[4].PngImage);
end;

procedure TDirectShowControl.FormDestroy(Sender: TObject);
begin
  if Assigned(MediaControl) then MediaControl.Stop;
  if Assigned(MediaEvent) then begin
    MediaEvent.SetNotifyWindow(0, 0, 0);
  end;
  if Assigned(VideoWindow) then begin
    VideoWindow.put_Visible(false);
    VideoWindow.put_Owner(0);
  end;
  VideoWindow  := nil;
  BasicAudio   := nil;
  BasicVideo   := nil;
  MediaSeeking := nil;
  MediaControl := nil;
  GraphBuilder := nil;
end;

procedure TDirectShowControl.LoadFile(filename: string);
var
  wfn: WideString;
  vol: integer;
begin
  if FileExists(filename) then begin
    MediaControl := CoFilgraphManager.Create;
    GraphBuilder := MediaControl as IGraphBuilder;
    MediaSeeking := MediaControl as IMediaSeeking;
    BasicAudio   := MediaControl as IBasicAudio;
    BasicVideo   := MediaControl as IBasicVideo;
    VideoWindow  := MediaControl as IVideoWindow;
    MediaEvent   := MediaControl as IMediaEventEx;
    DSReady := true;
    wfn := filename;
    FPlaying := false;
    OleCheck(GraphBuilder.RenderFile(PWideChar(wfn), nil));
    OleCheck(MediaEvent.SetNotifyWindow(Handle, wm_MediaEvent, 0));
    AudioExists := Succeeded(BasicAudio.get_Volume(vol));
    if ControlVolume then
      BasicAudio.put_Volume(VolumeUpDown.Position)
    else
      VolumeUpDown.Position := vol;
    FMediaReady := true;
    UpdateControlRanges;
    UpdateControlStates;
  end else begin
    DSReady := false;
    FMediaReady := false;
  end;
end;

procedure TDirectShowControl.ReleaseMedia;
var
  EnumFilters: IEnumFilters;
  Filters: array of IBaseFilter;
  filterCount: ulong;
  filterIndex: integer;
begin
  if DSReady and MediaReady then begin
    VideoWindow.put_Visible(false);
    VideoWindow.put_Owner(0);
    VideoWindow.put_Visible(false);
    OleCheck(GraphBuilder.EnumFilters(EnumFilters));
    filterCount := 0;
    while EnumFilters.Skip(1) = S_OK do Inc(filterCount);
    if filterCount > 0 then begin
      SetLength(Filters, filterCount);
      OleCheck(EnumFilters.Reset);
      OleCheck(EnumFilters.Next(filterCount, Filters[0], @filterCount));
      for filterIndex := 0 to filterCount-1 do begin
        OleCheck(GraphBuilder.RemoveFilter(Filters[filterIndex]));
      end;
    end;
    FMediaReady := false;
  end;
end;

procedure TDirectShowControl.Play;
begin
  if DSReady then OleCheck(MediaControl.Run);
  FPlaying := duration > 0;
  UpdateControlStates;
end;

procedure TDirectShowControl.Pause;
begin
  if DSReady then MediaControl.Pause;
  FPlaying := false;
  UpdateControlStates;
end;

procedure TDirectShowControl.Stop;
begin
  if DSReady then MediaControl.Stop;
  FPlaying := false;
  UpdateControlStates;
end;

procedure TDirectShowControl.SkipBack;
var
  p1, p2: int64;
begin
  if DSReady and Succeeded(MediaSeeking.GetPositions(p1, p2)) then begin
    p1 := Max(p1 - SkipAmount, 0);
    MediaSeeking.SetPositions(p1, AM_SEEKING_AbsolutePositioning, p2, AM_SEEKING_NoPositioning);
    TrackingTimerTimer(nil);
  end;
end;

procedure TDirectShowControl.SkipForward;
var
  p1, p2: int64;
begin
  if DSReady and Succeeded(MediaSeeking.GetPositions(p1, p2)) then begin
    p1 := Min(p1 + SkipAmount, p2);
    MediaSeeking.SetPositions(p1, AM_SEEKING_AbsolutePositioning, p2, AM_SEEKING_NoPositioning);
    TrackingTimerTimer(nil);
  end;
end;

procedure TDirectShowControl.UpdateControlRanges;
var
  maxpos: integer;
  line: integer;
  page: integer;
begin
  if Succeeded(MediaSeeking.GetDuration(duration)) then begin
    // duration is in 100 ns units
    // trackbar represents 100 ms intervals
    maxpos := Min(duration div 1000000, MaxInt);
    line := Max(maxpos div 100, 10);
    page := Max(maxpos div 10, 10);
    SkipAmount := duration div 10;
  end else begin
    duration := 0;
    SkipAmount := 0;
    maxpos := 1;
    line := 1;
    page := 1;
  end;
  TimeTrackBar.Min := 0;
  TimeTrackBar.Position := 0;
  TimeTrackBar.Max := maxpos;
  TimeTrackBar.LineSize := line;
  TimeTrackBar.PageSize := page;
  TimeTrackBar.Frequency := page;
end;

procedure TDirectShowControl.TimeTrackBarChange(Sender: TObject);
var
  p1, p2: int64;
begin
  if
    UserSeeking and (duration > 0) and (TimeTrackBar.Max > 0) and
    Succeeded(MediaSeeking.GetPositions(p1, p2))
  then begin
    p1 := Round(duration * TimeTrackBar.Position / TimeTrackBar.Max);
    MediaSeeking.SetPositions(p1, AM_SEEKING_AbsolutePositioning, p2, AM_SEEKING_NoPositioning);
  end;
end;

procedure TDirectShowControl.TimeTrackBarKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  UserSeeking := true;
  TrackingTimer.Enabled := false;
end;

procedure TDirectShowControl.TimeTrackBarKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  UserSeeking := false;
  TrackingTimer.Enabled := Playing;
end;

procedure TDirectShowControl.TimeTrackBarMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then begin
    UserSeeking := true;
    TrackingTimer.Enabled := false;
  end;
end;

procedure TDirectShowControl.TimeTrackBarMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then begin
    UserSeeking := false;
    TrackingTimer.Enabled := Playing;
  end;
end;

procedure TDirectShowControl.TrackingTimerTimer(Sender: TObject);
var
  position: int64;
  p: double;
begin
  if Succeeded(MediaSeeking.GetCurrentPosition(position)) then begin
    if duration > 0 then
      p := position / duration
    else
      p := 0;
  end else
    p := 0;
  if not UserSeeking then
    TimeTrackBar.Position := Round(p * TimeTrackBar.Max);
end;

procedure TDirectShowControl.UpdateControlStates;
begin
  TimeTrackBar.Enabled := MediaReady and Playing;
  PlayButton.Enabled := MediaReady and not Playing;
  PauseButton.Enabled := MediaReady and Playing;
  StopButton.Enabled := MediaReady and Playing;
  RewindButton.Enabled := MediaReady and Playing;
  ForwardButton.Enabled := MediaReady and Playing;
  VolumeUpDown.Enabled := MediaReady and AudioExists;
  TrackingTimer.Enabled := Playing;
end;

procedure TDirectShowControl.VolumeUpDownClick(Sender: TObject;
  Button: TUDBtnType);
begin
  if AudioExists then
    BasicAudio.put_Volume(VolumeUpDown.Position);
  ControlVolume := true;
end;

procedure TDirectShowControl.WMMediaEvent(var message: TMessage);
var
  ec, p1, p2: integer;
begin
  while Succeeded(MediaEvent.GetEvent(ec, p1, p2, 0)) do
    try
      if Assigned(FOnMediaEvent) then FOnMediaEvent(Self, ec);
    finally
      MediaEvent.FreeEventParams(ec, p1, p2);
    end;
end;

procedure TDirectShowControl.SetDisplayRect(const Value: TRect);
begin
  FDisplayRect := Value;
  if DSReady then
    with FDisplayRect do
      OleCheck(VideoWindow.SetWindowPosition(left, top, right, bottom));
end;

procedure TDirectShowControl.SetDisplayWindow(const Value: HWnd);
begin
  FDisplayWindow := Value;
  if DSReady then begin
    OleCheck(VideoWindow.put_Owner(FDisplayWindow));
    OleCheck(VideoWindow.put_WindowStyle(WS_CHILD or WS_CLIPSIBLINGS));
  end;
end;

function TDirectShowControl.GetVideoSize: TPoint;
begin
  OleCheck(BasicVideo.GetVideoSize(result.x, result.y));
end;

procedure TDirectShowControl.PlayButtonClick(Sender: TObject);
begin
  Play;
end;

procedure TDirectShowControl.PauseButtonClick(Sender: TObject);
begin
  Pause;
end;

procedure TDirectShowControl.StopButtonClick(Sender: TObject);
begin
  Stop;
end;

procedure TDirectShowControl.RewindButtonClick(Sender: TObject);
begin
  SkipBack;
end;

procedure TDirectShowControl.ForwardButtonClick(Sender: TObject);
begin
  SkipForward;
end;

end.

