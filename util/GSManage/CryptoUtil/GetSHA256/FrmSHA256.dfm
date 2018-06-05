object Form4: TForm4
  Left = 0
  Top = 0
  Caption = 'Get SHA256'
  ClientHeight = 216
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
    Width = 43
    Height = 13
    Caption = 'Hashed :'
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
    Width = 113
    Height = 25
    Caption = 'Get Hash String'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 328
    Top = 112
    Width = 121
    Height = 25
    Caption = 'Check Hash'
    TabOrder = 3
    OnClick = Button2Click
  end
  object HashAlgoRG: TRadioGroup
    Left = 56
    Top = 143
    Width = 505
    Height = 48
    Caption = 'Hash Algorithm'
    Columns = 5
    ItemIndex = 0
    Items.Strings = (
      'SHA256_Syn'
      'SHA256_Indy'
      'MD5_Indy'
      'BCrypt'
      'SCrypt')
    TabOrder = 4
  end
end
