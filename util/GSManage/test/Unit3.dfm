object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Form3'
  ClientHeight = 249
  ClientWidth = 418
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 24
    Top = 8
    Width = 97
    Height = 41
    Caption = 'Client1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 127
    Top = 8
    Width = 89
    Height = 41
    Caption = 'Client2'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 24
    Top = 55
    Width = 97
    Height = 41
    Caption = 'VariantDynArray'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 24
    Top = 104
    Width = 97
    Height = 41
    Caption = 'EncryptAES'
    TabOrder = 3
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 127
    Top = 102
    Width = 97
    Height = 41
    Caption = 'DecryptAES'
    TabOrder = 4
    OnClick = Button5Click
  end
  object edtTextToEncrypt: TEdit
    Left = 24
    Top = 152
    Width = 201
    Height = 21
    ImeName = 'Microsoft IME 2010'
    TabOrder = 5
  end
  object edtCrypted: TEdit
    Left = 23
    Top = 179
    Width = 201
    Height = 21
    ImeName = 'Microsoft IME 2010'
    TabOrder = 6
  end
  object edtDecrypted: TEdit
    Left = 24
    Top = 206
    Width = 201
    Height = 21
    ImeName = 'Microsoft IME 2010'
    TabOrder = 7
  end
end
