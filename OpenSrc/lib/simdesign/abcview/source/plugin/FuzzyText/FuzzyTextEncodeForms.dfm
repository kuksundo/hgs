object frmEncode: TfrmEncode
  Left = 393
  Top = 238
  Width = 354
  Height = 166
  Caption = 'Create registration keys for FUZZYTEXT'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 56
    Height = 13
    Caption = 'Client code:'
  end
  object Label2: TLabel
    Left = 16
    Top = 72
    Width = 79
    Height = 13
    Caption = 'Registration key:'
  end
  object edClientCode: TEdit
    Left = 16
    Top = 32
    Width = 225
    Height = 21
    TabOrder = 0
  end
  object btnCalculate: TButton
    Left = 248
    Top = 30
    Width = 75
    Height = 25
    Caption = 'Calculate'
    TabOrder = 1
    OnClick = btnCalculateClick
  end
  object edRegKey: TEdit
    Left = 16
    Top = 88
    Width = 225
    Height = 21
    TabOrder = 2
  end
end
