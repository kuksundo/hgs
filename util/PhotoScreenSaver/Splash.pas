{------------------------------------------------------------------------------}
{                                                                              }
{  PicShow Demonstration                                                       }
{  by Kambiz R. Khojasteh                                                      }
{                                                                              }
{  kambiz@delphiarea.com                                                       }
{  http://www.delphiarea.com                                                   }
{                                                                              }
{------------------------------------------------------------------------------}
{                                                                              }
{  If forms of your application appear with some delay on the screen, the      }
{  splash form of the other demo has a better result.                          }
{                                                                              }
{------------------------------------------------------------------------------}

unit Splash;

{$I DELPHIAREA.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  PicShow, ExtCtrls, jpeg;

type
  TSplashForm = class(TForm)
    PicShow: TPicShow;
    procedure PicShowProgress(Sender: TObject);
  private
    procedure CreateBackground;
  public
    class function Execute: TSplashForm;
  end;

implementation

{$R *.DFM}

{$IFNDEF COMPILER4_UP}
// I've realized the Random function on Delphi 3 does not work correctly. It
// sometimes returns a negative value and sometimes a value larger than the
// Range parameter. By the way, I have to mention that I have not installed
// any service pack.
function Random(Range: Integer): Integer;
begin
  Result := System.Random(Range);
  if Result < 0 then Result := -Result;
  Result := Result mod Range;
end;
{$ENDIF}

procedure TSplashForm.CreateBackground;
var
  Background: TBitmap;
  DC: HDC;
begin
  // First we set position of the form on the center of desktop.
  // We set Position property of the form to poDesigned because we
  // need the form's position before showing it.
  Left := (Screen.Width - Width) div 2;
  Top := (Screen.Height - Height) div 2;
  // We create a bitmap object for storing the screen behind the form.
  Background := TBitmap.Create;
  try
    Background.Width := Width;
    Background.Height := Height;
    // We get device context of the screen and copy the screen behind the form
    // in to the created bitmap.
    DC := GetDC(0);
    try
      BitBlt(Background.Canvas.Handle, 0, 0, Width, Height, DC, Left, Top, SRCCOPY);
    finally
      ReleaseDC(0, DC);
    end;
    // We set Backgrund property of PicShow to captured screen image.
    // By this trick the form seems as transparent.
    PicShow.BgPicture.Assign(Background);
  finally
    // We don't need the bitmap object, then we free it.
    Background.Free;
  end;
end;

class function TSplashForm.Execute: TSplashForm;
begin
  Result := TSplashForm.Create(nil);
  if ParamCount = 0 then
    with Result do
    begin
      // A trick to make PicShow as transparent
      CreateBackground;
      // Display the splash form.
      Show;
      // To prevent flickering, update the form immediately.
      Update;
      // Select randomly a transition effect.
      Randomize;
      PicShow.Style := TShowStyle(Random(High(TShowStyle))+1);
      // Start image transition.
      // For splash forms don't use PicShow as Threaded. When threaded is true,
      // transition will start after activation of main form.
      PicShow.Execute;
      // Wait a bit before continuing the rest of the application.
      // Consider that we don't use threaded mode, otherwise the following
      // line has no effect.
      Sleep(500);
    end;
end;

procedure TSplashForm.PicShowProgress(Sender: TObject);
begin
  if (PicShow.Progress = 100) and not PicShow.Reverse then
  begin
    // we select another transition effect randomly,
    PicShow.Style := TShowStyle(Random(High(TShowStyle))+1);
    // and continue the transaction to its initial state.
    PicShow.Reverse := True;
    // we wait two seconds before hiding the image
    Sleep(2000);
  end;
end;

end.
