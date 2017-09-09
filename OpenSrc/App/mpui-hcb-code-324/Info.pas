{   MPUI-hcb, an MPlayer frontend for Windows
    Copyright (C) 2006-2013 Huang Chen Bin <hcb428@foxmail.com>
    based on work by Martin J. Fiedler <martin.fiedler@gmx.net>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}
unit Info;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, TntGraphics, Controls, Forms,
  Dialogs, TntStdCtrls,TntForms, StdCtrls, Graphics, TntClipBrd, TntClasses, TntSysUtils;

type
  TInfoForm = class(TTntForm)
    InfoBox: TTntListBox;
    BClose: TTntButton;
    TCB: TTntButton;
    procedure BCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure InfoBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormDestroy(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure TCBClick(Sender: TObject);
    procedure TntFormResize(Sender: TObject);
  private
    { Private declarations }
    TabOffset,MW:integer;
    ClipText:WideString;
    procedure FormMove(var msg:TMessage); message WM_MOVE;
  public
    { Public declarations }
    ControlledMove:boolean;
    procedure UpdateInfo(calcoff:boolean);
  end;

var
  InfoForm: TInfoForm;
  Docked:boolean;

implementation
uses Core, Locale, Main, MediaInfoDll;

{$R *.dfm}

function FormatAspectRatio(const Aspect:real):wideString;
var Numerator,Denominator:integer;
begin
  for Denominator:=1 to 50 do begin
    Numerator:=round(Aspect*Denominator);
    if abs(Numerator/Denominator-Aspect)<0.001 then begin
      Result:=IntToStr(Numerator)+':'+IntToStr(Denominator);
      exit;
    end;
  end;
  str(Aspect:0:3,Result); Result:=Result+':1';
end;


procedure TInfoForm.FormCreate(Sender: TObject);
begin
  ControlledMove:=True; Docked:=true;
  if Core.RP then begin Left:=Core.IL; Top:=Core.IT; end;
end;

procedure TInfoForm.BCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TInfoForm.UpdateInfo(calcoff:boolean);
var HaveTagHeader,HaveVideoHeader,HaveAudioHeader:boolean;
    i,j,c:integer; s,VB,VW,VH,FR,DR,AB,AR,AC:WideString; h: Cardinal;

  procedure calcOffset;
  var w,a:integer; KeySet:TTntStringList;
  begin
    with StreamInfo do begin
      TabOffset:=0; KeySet:=TTntStringList.Create;
      KeySet.Add(LOCstr_InfoFileName);
      if length(FileFormat)>0 then KeySet.Add(LOCstr_InfoFileFormat);
      if length(PlaybackTime)>0 then KeySet.Add(LOCstr_InfoPlaybackTime);
      if (length(Video.Decoder)>0) or (length(Audio.Decoder)>0) then KeySet.Add(LOCstr_InfoDecoder);
      if (length(Video.Codec)>0) or (length(Audio.Codec)>0) then KeySet.Add(LOCstr_InfoCodec);
      if Video.Bitrate<>0 then KeySet.Add(LOCstr_InfoBitrate);
      if (Video.Width<>0) AND (Video.Height<>0) then KeySet.Add(LOCstr_InfoVideoSize);
      if (Video.FPS>0.01) then KeySet.Add(LOCstr_InfoVideoFPS);
      if (Video.Aspect>0.01) then KeySet.Add(LOCstr_InfoVideoAspect);
      if Audio.Bitrate<>0 then KeySet.Add(LOCstr_InfoBitrate);
      if Audio.Rate<>0 then KeySet.Add(LOCstr_InfoAudioRate);
      if Audio.Channels<>0 then KeySet.Add(LOCstr_InfoAudioChannels);
      for a:=0 to 9 do
        With ClipInfo[a] do
          if (length(Key)>0) AND (length(Value)>0) then KeySet.Add(Key);
      for a:=0 to KeySet.Count-1 do begin
        w:=WideCanvasTextWidth(InfoBox.Canvas,KeySet[a])+20;
        if w>TabOffset then TabOffset:=w;
      end;
      KeySet.Free;
    end;
  end;

  procedure AddItem(Key,Value:WideString);
  var d,t,w:integer;
  const Lset=['.','(','[','{']; Rset=[' ',',','_','-',')',']','}'];
  begin
    Key:=Key+':';
    ClipText:=ClipText+Key+^I+Value+^M^J;
    j:=TabOffset+20+WideCanvasTextWidth(InfoBox.Canvas,Value);
    if j>MW then MW:=j; w:=length(Value);
    repeat
      for d:=1 to w do begin
        j:=WideCanvasTextWidth(InfoBox.Canvas,copy(Value,1,d));
        if j>=(InfoBox.Width-TabOffset-10) then begin
          if Char(Value[d]) in Rset then t:=d+1
          else if Char(Value[d-1]) in Lset then t:=d-1
          else t:=d;
          InfoBox.Items.Add(Key+^I+copy(Value,1,t-1));
          Value:=copy(Value,t,MaxInt);
          Key:=''; break;
        end;
      end;
      if d>length(Value) then begin
        InfoBox.Items.Add(Key+^I+Value);
        break;
      end;
    until False; 

  end;

  procedure AddHeader(var Flag:boolean; const Caption:WideString);
  begin
    if Flag then exit;
    InfoBox.Items.Add(WideString('!')+Caption);
    ClipText:=ClipText+^M^J+Caption+^M^J;
    Flag:=true;
  end;

  procedure T(const Key,Value:WideString);
  begin
    AddHeader(HaveTagHeader,LOCstr_InfoTags);
    AddItem(Key,Value);
  end;

  procedure V(const Key,Value:WideString);
  begin
    AddHeader(HaveVideoHeader,LOCstr_InfoVideo);
    AddItem(Key,Value);
  end;

  procedure A(const Key,Value:WideString);
  begin
    AddHeader(HaveAudioHeader,LOCstr_InfoAudio);
    AddItem(Key,Value);
  end;

  procedure M(z,y:WideString; var o:WideString);
  var d: WideString;
  begin
    MediaInfo_Option (0, 'Inform', PWideChar(z+';%'+y+'%'));
    d := MediaInfo_Inform(h, 0);
    if d<>'' then o:= d;
  end;

begin
  with StreamInfo do begin
    if not Visible then exit;
    InfoBox.Items.Clear;
    ClipText:=''; MW:=0; c:=-1;
    if length(FileName)=0 then begin
      InfoBox.Items.Add(LOCstr_NoInfo);
      j:=WideCanvasTextWidth(InfoBox.Canvas,LOCstr_NoInfo)+20;
      if j>MW then MW:=j;
      exit;
    end;
    if calcOff then calcOffset;
    HaveTagHeader:=false; HaveVideoHeader:=false; HaveAudioHeader:=false;
    VB:=''; VW:=''; VH:=''; FR:=''; DR:=''; AB:=''; AR:=''; AC:='';
    if IsMediaInfoLoaded = 0 then MediaInfoDLL_Load;
    if IsMediaInfoLoaded <> 0 then begin
      h := MediaInfo_New();
      MediaInfo_Open(h,PWideChar(EscapeParam(WideExtractShortPathName(MediaURL))));
      M('General','Format',FileFormat);
      //M('General','Duration/String3',PlaybackTime);
      M('General','Video_Format_List',Video.Codec); M('Video','BitRate/String',VB);
      M('Video','Width',VW); M('Video','Height',VH);
      M('General','FrameRate/String',FR); M('Video','DisplayAspectRatio/String',DR);
      M('General','Audio_Format_List ',Audio.Decoder); M('Audio','BitRate/String',AB);
      M('Audio','SamplingRate/String',AR); M('Audio','Channel(s)/String)',AC);
      MediaInfo_Close(h);
    end;
    AddItem(LOCstr_InfoFileName,FileName);
    if length(FileFormat)>0 then AddItem(LOCstr_InfoFileFormat,FileFormat);
    if length(PlaybackTime)>0 then AddItem(LOCstr_InfoPlaybackTime,PlaybackTime);
    for i:=0 to 9 do begin
      with ClipInfo[i] do begin
        if (length(Key)>0) AND (length(Value)>0) then begin
          if Pos('Comment',Key)<>1 then T(Key, Value)
          else c:=i;
        end;
      end;
    end;
    if c>-1 then T(ClipInfo[c].Key, ClipInfo[c].Value);
    if length(Video.Decoder)>0 then V(LOCstr_InfoDecoder, Video.Decoder);
    if length(Video.Codec)>0 then V(LOCstr_InfoCodec, Video.Codec);
    if VB<>'' then V(LOCstr_InfoBitrate, VB)
    else if Video.Bitrate<>0 then V(LOCstr_InfoBitrate, IntToStr(Video.Bitrate div 1000)+' kbps');
    if (VW<>'') and (VH<>'') then V(LOCstr_InfoVideoSize, VW+' x '+VH)
    else if (Video.Width<>0) AND (Video.Height<>0) then V(LOCstr_InfoVideoSize, IntToStr(Video.Width)+' x '+IntToStr(Video.Height));
    if FR<>'' then V(LOCstr_InfoVideoFPS, FR)
    else if (Video.FPS>0.01) then begin str(Video.FPS:0:3,s); V(LOCstr_InfoVideoFPS, s+' fps'); end;
    if DR<>'' then V(LOCstr_InfoVideoAspect, DR)
    else if (Video.Aspect>0.01) then V(LOCstr_InfoVideoAspect, FormatAspectRatio(Video.Aspect));
    if length(Audio.Decoder)>0 then A(LOCstr_InfoDecoder, Audio.Decoder);
    if length(Audio.Codec)>0 then A(LOCstr_InfoCodec, Audio.Codec);
    if AB<>'' then A(LOCstr_InfoBitrate, AB)
    else if Audio.Bitrate<>0 then A(LOCstr_InfoBitrate, IntToStr(Audio.Bitrate div 1000)+' kbps');
    if AR<>'' then A(LOCstr_InfoAudioRate, AR)
    else if Audio.Rate<>0 then A(LOCstr_InfoAudioRate, IntToStr(Audio.Rate)+' Hz');
    if AC<>'' then  A(LOCstr_InfoAudioChannels, AC)
    else if Audio.Channels<>0 then A(LOCstr_InfoAudioChannels, IntToStr(Audio.Channels));
    Constraints.MinHeight:=Height-InfoBox.Height+InfoBox.Count*InfoBox.ItemHeight+5;
  end;
end;

procedure TInfoForm.FormShow(Sender: TObject);
begin
  UpdateInfo(true);
  MainForm.MStreamInfo.Checked:=True;
  MainForm.BStreamInfo.Down:=True;
  if (left+width)>=(CurMonitor.Left + CurMonitor.Width) then begin ControlledMove:=true; left:=CurMonitor.Left + CurMonitor.Width-width; end;
  if left<CurMonitor.Left then begin ControlledMove:=true; left:=CurMonitor.Left; end;
  if top<CurMonitor.Top then begin ControlledMove:=true; top:=CurMonitor.Top; end;
  if (top+height)>=(CurMonitor.Top + CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top) then begin
    ControlledMove:=true; top:=CurMonitor.Top + CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top-height; end;
  if (MainForm.Width>=CurMonitor.Width) OR (MainForm.Height>=(CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top)) then MainForm.Enabled:=false;
  if (OnTop>0) OR MainForm.MFullScreen.Checked then SetWindowPos(Handle,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE OR SWP_NOSIZE);
end;

procedure TInfoForm.FormHide(Sender: TObject);
begin
  MainForm.MStreamInfo.Checked:=False;
  MainForm.BStreamInfo.Down:=False;
  MainForm.Enabled:=true;
  if (OnTop=1) OR ((OnTop=2) AND (Status=sPlaying)) OR MainForm.MFullScreen.Checked then
    SetWindowPos(MainForm.Handle,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE OR SWP_NOSIZE);
end;

procedure TInfoForm.InfoBoxDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var s,t:WideString; p:integer;
begin
  if InfoBox.Items.Count<1 then exit;
  with InfoBox.Canvas do begin
    s:=InfoBox.Items[Index];
    if (length(s)>0) AND (s[1]='!') then begin
      Brush.Color:=clBtnFace;
      Font.Color:=clBtnText;
      Font.Style:=Font.Style+[fsBold];
      FillRect(Rect);
      WideCanvasTextOut(InfoBox.Canvas,Rect.Left+2,Rect.Top+1,copy(s,2,MaxInt));
      exit;
    end;
    p:=Pos(^I,s);
    if p>0 then begin
      FillRect(Rect);
      WideCanvasTextOut(InfoBox.Canvas,Rect.Left+2,Rect.Top+1,copy(s,1,p-1));
      t:=copy(s,p+1,MaxInt);
      WideCanvasTextOut(InfoBox.Canvas,Rect.Left+TabOffset,Rect.Top+1,t);
    end
    else WideCanvasTextOut(InfoBox.Canvas,Rect.Left+2,Rect.Top+1,s);
  end;
end;

procedure TInfoForm.FormDestroy(Sender: TObject);
begin
  Docked:=False; IL:=left; IT:=Top;
end;

procedure TInfoForm.FormMove(var msg:TMessage);
begin
  msg.Result:=0;
  if ControlledMove then ControlledMove:=False else Docked:=False;
end;

procedure TInfoForm.FormDblClick(Sender: TObject);
begin
  Docked:=True; MainForm.UpdateDockedWindows;
end;

procedure TInfoForm.TCBClick(Sender: TObject);
begin
  TntClipboard.AsWideText:=ClipText;
end;

procedure TInfoForm.TntFormResize(Sender: TObject);
begin
  ControlledMove:=true;
  UpdateInfo(false);
end;

end.
