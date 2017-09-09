object PopupForm: TPopupForm
  Left = 272
  Top = 166
  AlphaBlend = True
  AlphaBlendValue = 199
  BorderStyle = bsNone
  Caption = 'PopupForm'
  ClientHeight = 34
  ClientWidth = 170
  Color = clBtnFace
  ParentFont = True
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object lblComputer: TLabel
    Left = 24
    Top = 2
    Width = 55
    Height = 13
    Caption = 'lblComputer'
    Transparent = False
  end
  object lblTime: TLabel
    Left = 134
    Top = 2
    Width = 33
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblTime'
  end
  object lblEvent: TLabel
    Left = 24
    Top = 20
    Width = 38
    Height = 13
    Caption = 'lblEvent'
  end
  object imgStatus: TImage
    Left = 2
    Top = 10
    Width = 16
    Height = 16
    Transparent = True
  end
  object Timer: TTimer
    Interval = 4000
    OnTimer = TimerTimer
    Left = 100
    Top = 5
  end
end
