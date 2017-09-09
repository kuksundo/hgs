object CaptionInputF: TCaptionInputF
  Left = 0
  Top = 0
  Caption = 'Change Tab Caption'
  ClientHeight = 143
  ClientWidth = 450
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 64
    Top = 27
    Width = 85
    Height = 16
    Caption = 'Caption Name:'
  end
  object CaptionNameEdit: TEdit
    Left = 155
    Top = 24
    Width = 238
    Height = 24
    ImeName = 'Microsoft Office IME 2007'
    TabOrder = 0
  end
  object BitBtn1: TBitBtn
    Left = 64
    Top = 80
    Width = 145
    Height = 49
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 1
  end
  object BitBtn2: TBitBtn
    Left = 248
    Top = 80
    Width = 145
    Height = 49
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 2
  end
end
