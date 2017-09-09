{ unit Slideshow

  Slideshow thread

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit Slideshows;

interface

uses
  Classes, guiActions, guiMain, sdProcessThread, sdAbcTypes, sdAbcVars;

type

  TSlideShowThread = class(TProcess)
  public
    FActions: TdmActions;
    FMain: TfrmMain;
    procedure Run; override;
  end;

implementation

uses
  Windows;

procedure TSlideShowThread.Run;
var
  NewTick, OldTick: integer;
begin
  repeat
    OldTick := GetTickCount;
    while FSlideShow do
    begin
      repeat
        NewTick := GetTickCount;
        sleep(20);
      until NewTick - OldTick > FSlideShowDelay;
      OldTick := NewTick;
      // Do the command
      if FSlideshow then
        case FSlideShowDir of
        sdBackward: dmActions.GoLeftExecute(Self);
        sdForward: dmActions.GoRightExecute(Self);
        end;
    end;
    Sleep(10);
  until Terminated or (Status <> psRun);
end;

end.
