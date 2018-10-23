object Form4: TForm4
  Left = 0
  Top = 0
  Caption = 'Form4'
  ClientHeight = 304
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
  object Button1: TButton
    Left = 24
    Top = 8
    Width = 161
    Height = 49
    Caption = 'Version'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 200
    Top = 8
    Width = 145
    Height = 49
    Caption = 'Open mpp'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 351
    Top = 8
    Width = 145
    Height = 49
    Caption = 'Get Task'
    TabOrder = 2
    OnClick = Button3Click
  end
end
