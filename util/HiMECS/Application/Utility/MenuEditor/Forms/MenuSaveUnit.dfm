object MenuSaveF: TMenuSaveF
  Left = 0
  Top = 0
  Caption = 'Menu Save To File'
  ClientHeight = 139
  ClientWidth = 426
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 48
    Top = 32
    Width = 77
    Height = 13
    Caption = 'Save File Name:'
  end
  object JvFilenameEdit1: TJvFilenameEdit
    Left = 131
    Top = 29
    Width = 246
    Height = 21
    Filter = 'Menu files(*.menu)|*.menu|All files (*.*)|*.*'
    ImeName = 'Microsoft Office IME 2007'
    TabOrder = 0
  end
  object BitBtn1: TBitBtn
    Left = 80
    Top = 72
    Width = 89
    Height = 41
    DoubleBuffered = True
    Kind = bkOK
    NumGlyphs = 2
    ParentDoubleBuffered = False
    TabOrder = 1
  end
  object BitBtn2: TBitBtn
    Left = 232
    Top = 72
    Width = 89
    Height = 41
    DoubleBuffered = True
    Kind = bkCancel
    NumGlyphs = 2
    ParentDoubleBuffered = False
    TabOrder = 2
  end
end
