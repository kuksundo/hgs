object MediaPlayerForm: TMediaPlayerForm
  Left = 343
  Top = 267
  AutoSize = True
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = 'Media Control'
  ClientHeight = 30
  ClientWidth = 0
  Color = clBtnFace
  ParentFont = True
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object MediaPlayer: TMediaPlayer
    Left = 0
    Top = 0
    Width = 197
    Height = 30
    EnabledButtons = [btPause, btStop, btNext, btPrev, btStep, btBack]
    VisibleButtons = [btPlay, btPause, btStop, btNext, btPrev, btStep, btBack]
    AutoEnable = False
    PopupMenu = PMMediaplayerKontext
    TabOrder = 0
  end
  object PMMediaplayerKontext: TPopupMenu
    Left = 72
    object MISchliessen: TMenuItem
      Caption = '&Close'
      Default = True
      Hint = 'Close media control window'
      ShortCut = 16499
      OnClick = MISchliessenClick
    end
  end
end
