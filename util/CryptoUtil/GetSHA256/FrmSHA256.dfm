object Form4: TForm4
  Left = 0
  Top = 0
  Caption = 'Get SHA256'
  ClientHeight = 236
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
    Left = 88
    Top = 112
    Width = 113
    Height = 25
    Caption = 'Get Hash String'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 207
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
    Width = 272
    Height = 48
    Caption = 'Hash Algorithm'
    Columns = 3
    ItemIndex = 0
    Items.Strings = (
      'SHA256_Syn'
      'SHA256_Indy'
      'MD5_Indy'
      'BCrypt'
      'SCrypt')
    TabOrder = 4
  end
  object Button3: TButton
    Left = 344
    Top = 112
    Width = 97
    Height = 25
    Caption = 'Encrypt String'
    TabOrder = 5
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 464
    Top = 112
    Width = 97
    Height = 25
    Caption = 'Decrypt String'
    TabOrder = 6
    OnClick = Button4Click
  end
  object IVAtBeginChcek: TCheckBox
    Left = 352
    Top = 143
    Width = 275
    Height = 33
    Hint = 'True'#51060#47732' '#47588#48264' '#50516#54840' '#45936#51060#53552#44032' '#45804#46972#51664
    Caption = 'Initialization Vector and add beginning of buffer'
    TabOrder = 7
  end
end
