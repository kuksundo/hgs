object TileConfigF: TTileConfigF
  Left = 0
  Top = 0
  Caption = 'Tile Config'
  ClientHeight = 224
  ClientWidth = 334
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
    Left = 56
    Top = 48
    Width = 64
    Height = 16
    Caption = 'Row Num.:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 56
    Top = 88
    Width = 57
    Height = 16
    Caption = 'Col Num.:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object RowNumEdit: TEdit
    Left = 126
    Top = 47
    Width = 129
    Height = 21
    ImeName = 'Microsoft IME 2010'
    TabOrder = 0
  end
  object ColNumEdit: TEdit
    Left = 126
    Top = 87
    Width = 129
    Height = 21
    ImeName = 'Microsoft IME 2010'
    TabOrder = 1
  end
  object BitBtn1: TBitBtn
    Left = 56
    Top = 152
    Width = 105
    Height = 33
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 2
  end
  object BitBtn2: TBitBtn
    Left = 192
    Top = 152
    Width = 105
    Height = 33
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 3
  end
end
