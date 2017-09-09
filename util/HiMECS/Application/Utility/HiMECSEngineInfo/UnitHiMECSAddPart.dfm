object AddPartF: TAddPartF
  Left = 0
  Top = 0
  Caption = 'Add Component'
  ClientHeight = 148
  ClientWidth = 455
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 56
    Top = 24
    Width = 54
    Height = 13
    Caption = 'Part Name:'
  end
  object Edit1: TEdit
    Left = 56
    Top = 48
    Width = 361
    Height = 21
    ImeName = 'Microsoft IME 2010'
    TabOrder = 0
  end
  object BitBtn1: TBitBtn
    Left = 304
    Top = 88
    Width = 113
    Height = 33
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 1
  end
  object BitBtn2: TBitBtn
    Left = 56
    Top = 88
    Width = 97
    Height = 33
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 2
  end
end
