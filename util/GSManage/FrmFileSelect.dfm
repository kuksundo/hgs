object FileSelectF: TFileSelectF
  Left = 0
  Top = 0
  Caption = 'File Select'
  ClientHeight = 176
  ClientWidth = 407
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = [fsBold]
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 56
    Top = 40
    Width = 68
    Height = 16
    Caption = 'Doc Type :'
  end
  object Label2: TLabel
    Left = 56
    Top = 80
    Width = 68
    Height = 16
    Caption = 'File Name :'
  end
  object ComboBox1: TComboBox
    Left = 130
    Top = 37
    Width = 201
    Height = 24
    ImeName = 'Microsoft IME 2010'
    TabOrder = 0
  end
  object JvFilenameEdit1: TJvFilenameEdit
    Left = 130
    Top = 77
    Width = 201
    Height = 24
    ImeName = 'Microsoft IME 2010'
    TabOrder = 1
    Text = ''
  end
  object BitBtn1: TBitBtn
    Left = 96
    Top = 120
    Width = 81
    Height = 33
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 2
  end
  object BitBtn2: TBitBtn
    Left = 250
    Top = 120
    Width = 81
    Height = 33
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 3
  end
end
