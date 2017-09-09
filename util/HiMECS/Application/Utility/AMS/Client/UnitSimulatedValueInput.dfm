object SimulatedValueInputF: TSimulatedValueInputF
  Left = 0
  Top = 0
  Caption = 'Simulated Value Input Form'
  ClientHeight = 170
  ClientWidth = 426
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = [fsBold]
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 88
    Top = 56
    Width = 112
    Height = 16
    Caption = 'Simulated Value: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object SimValueEdit: TEdit
    Left = 206
    Top = 55
    Width = 121
    Height = 24
    ImeName = 'Microsoft IME 2010'
    TabOrder = 0
  end
  object BitBtn1: TBitBtn
    Left = 88
    Top = 112
    Width = 89
    Height = 41
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 1
  end
  object BitBtn2: TBitBtn
    Left = 256
    Top = 112
    Width = 89
    Height = 41
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 2
  end
end
