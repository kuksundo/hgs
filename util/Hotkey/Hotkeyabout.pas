unit Hotkeyabout;

interface


{

Fade In / Out an About Box or any Modal Delphi Form

http://delphi.about.com/od/formsdialogs/a/fadeinmodalform.htm

~Zarko Gajic

}


uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TFadeType = (ftIn, ftOut);
  TAboutBox = class(TForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    Version: TLabel;
    OKButton: TButton;
    fadeTimer: TTimer;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure fadeTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private

    fFadeType: TFadeType;
    property FadeType : TFadeType read fFadeType write fFadeType;
  public
    class function Execute() : TModalResult;
  end;

implementation
{$R *.dfm}

class function TAboutBox.Execute: TModalResult;
begin
  with TAboutBox.Create(nil) do
  begin
    try
      result := ShowModal;
    finally
      Release;
    end;
  end;
end;

procedure TAboutBox.fadeTimerTimer(Sender: TObject);
const
  FADE_IN_SPEED = 1;
  FADE_OUT_SPEED = 3;
var
  newBlendValue : integer;
begin
  case FadeType of
    ftIn:
      begin
        if AlphaBlendValue < 255 then
          AlphaBlendValue := FADE_IN_SPEED + AlphaBlendValue
        else
          fadeTimer.Enabled := false;
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

procedure TAboutBox.FormCreate(Sender: TObject);
begin
  AlphaBlend := true;
  AlphaBlendValue := 0;
  fFadeType := ftIn;
  fadeTimer.Enabled := true;
end;

procedure TAboutBox.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  //no close before we fade away
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

end.

