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
unit Equalizer;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, TntForms, Controls, StdCtrls,
  Buttons, ExtCtrls, ComCtrls, TntStdCtrls, TntButtons;

type
  TEqualizerForm = class(TTntForm)
    BReset: TTntButton;
    BClose: TTntButton;
    TBri: TTrackBar;
    TCon: TTrackBar;
    TSat: TTrackBar;
    THue: TTrackBar;
    Bevel1: TBevel;
    TGam: TTrackBar;
    Sbri: TTntSpeedButton;
    SCon: TTntSpeedButton;
    SSat: TTntSpeedButton;
    SHue: TTntSpeedButton;
    SGam: TTntSpeedButton;
    procedure BCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure TbChange(Sender: TObject);
    procedure BResetClick(Sender: TObject);
    procedure SbriClick(Sender: TObject);
    procedure SConClick(Sender: TObject);
    procedure SGamClick(Sender: TObject);
    procedure SHueClick(Sender: TObject);
    procedure SSatClick(Sender: TObject);
  private
    { Private declarations }
    Changed: boolean;
  public
    { Public declarations }
  end;

var
  EqualizerForm: TEqualizerForm;

implementation

uses Core, Locale;

{$R *.dfm}

procedure TEqualizerForm.BCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TEqualizerForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if Changed then begin
    CBHSA := 1;
    SendCommand('get_property contrast');
    SendCommand('get_property brightness');
    SendCommand('get_property hue');
    SendCommand('get_property saturation');
    SendCommand('get_property gamma');
  end;
end;

procedure TEqualizerForm.FormShow(Sender: TObject);
begin
  CBHSA := 5; Changed := false;
  BReset.Enabled := TCon.Enabled or TGam.Enabled or TBri.Enabled or THue.Enabled or TSat.Enabled;
  if (Left < CurMonitor.Left) or ((Left + Width) > (CurMonitor.Left + CurMonitor.Width)) then
    Left := CurMonitor.Left + (CurMonitor.Width - Width) div 2;
  if (Top < CurMonitor.Top) or ((Top + Height) > (CurMonitor.Top + CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top)) then
    Top := CurMonitor.Top + (CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top - Height) div 2
end;

procedure TEqualizerForm.TbChange(Sender: TObject);
begin
  if CBHSA <> 5 then exit
  else begin
    Changed := true;
    SendCommand('set_property ' + (Sender as TTrackBar).Hint + ' ' + IntToStr((Sender as TTrackBar).Position));
  end;
end;

procedure TEqualizerForm.BResetClick(Sender: TObject);
begin
  SbriClick(nil); SConClick(nil); SGamClick(nil);
  SHueClick(nil); SSatClick(nil);
  SendCommand('osd_show_text "' + OSD_Reset_Prompt + ' C/B/H/S/G"');
end;

procedure TEqualizerForm.SbriClick(Sender: TObject);
begin
  if briD <> 101 then begin
    Changed := true; bri := briD; TBri.Position := briD;
    SendCommand('set_property brightness ' + IntToStr(briD));
  end;
end;

procedure TEqualizerForm.SConClick(Sender: TObject);
begin
  if contrD <> 101 then begin
    Changed := true; contr := contrD; TCon.Position := contrD;
    SendCommand('set_property contrast ' + IntToStr(contrD));
  end;
end;

procedure TEqualizerForm.SGamClick(Sender: TObject);
begin
  if (gamD <> 101) and Eq2 then begin
    Changed := true; gam := gamD; TGam.Position := gamD;
    SendCommand('set_property gamma ' + IntToStr(gamD) + ' 1');
  end;
end;

procedure TEqualizerForm.SHueClick(Sender: TObject);
begin
  if huD <> 101 then begin
    Changed := true; hu := huD; THue.Position := huD;
    SendCommand('set_property hue ' + IntToStr(huD));
  end;
end;

procedure TEqualizerForm.SSatClick(Sender: TObject);
begin
  if satD <> 101 then begin
    Changed := true; sat := satD; TSat.Position := satD;
    SendCommand('set_property saturation ' + IntToStr(satD) + ' 1');
  end;
end;

end.

