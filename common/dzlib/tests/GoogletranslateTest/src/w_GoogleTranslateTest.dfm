object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Google Translate Test'
  ClientHeight = 177
  ClientWidth = 529
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object b_Translate: TButton
    Left = 8
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Translate'
    Default = True
    TabOrder = 0
    OnClick = b_TranslateClick
  end
  object ed_English: TEdit
    Left = 8
    Top = 8
    Width = 513
    Height = 21
    TabOrder = 1
    Text = 'This is an English text which I want to translate.'
  end
  object ed_German: TEdit
    Left = 8
    Top = 72
    Width = 513
    Height = 21
    TabOrder = 2
  end
  object ed_French: TEdit
    Left = 8
    Top = 112
    Width = 513
    Height = 21
    TabOrder = 3
  end
  object b_Close: TButton
    Left = 448
    Top = 144
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 4
    OnClick = b_CloseClick
  end
end
