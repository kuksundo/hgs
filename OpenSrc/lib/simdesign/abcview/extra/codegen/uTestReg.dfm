object Form1: TForm1
  Left = 208
  Top = 107
  Width = 409
  Height = 239
  Caption = 'Testbed for HW Key generation'
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
    Left = 120
    Top = 24
    Width = 29
    Height = 13
    Caption = 'Serial:'
  end
  object Label2: TLabel
    Left = 120
    Top = 40
    Width = 43
    Height = 13
    Caption = 'HW Key:'
  end
  object lbSerial: TLabel
    Left = 168
    Top = 24
    Width = 15
    Height = 13
    Caption = 'xxx'
  end
  object lbHWKey: TLabel
    Left = 168
    Top = 40
    Width = 15
    Height = 13
    Caption = 'xxx'
  end
  object btnHWKey: TButton
    Left = 24
    Top = 16
    Width = 75
    Height = 25
    Caption = 'HW Key'
    TabOrder = 0
    OnClick = btnHWKeyClick
  end
end
