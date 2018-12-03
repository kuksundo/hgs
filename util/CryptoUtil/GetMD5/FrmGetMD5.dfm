object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Get MD5 '
  ClientHeight = 182
  ClientWidth = 635
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
    Top = 40
    Width = 36
    Height = 13
    Caption = 'Original'
  end
  object Label2: TLabel
    Left = 56
    Top = 72
    Width = 21
    Height = 13
    Caption = 'MD5'
  end
  object Edit1: TEdit
    Left = 98
    Top = 37
    Width = 508
    Height = 21
    ImeName = 'Microsoft IME 2010'
    TabOrder = 0
  end
  object Edit2: TEdit
    Left = 98
    Top = 69
    Width = 508
    Height = 21
    ImeName = 'Microsoft IME 2010'
    TabOrder = 1
  end
  object Button1: TButton
    Left = 176
    Top = 112
    Width = 75
    Height = 25
    Caption = 'Get MD5'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 328
    Top = 112
    Width = 75
    Height = 25
    Caption = 'Check MD5'
    TabOrder = 3
    OnClick = Button2Click
  end
end
