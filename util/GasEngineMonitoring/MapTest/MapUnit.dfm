object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Form3'
  ClientHeight = 344
  ClientWidth = 565
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
    Left = 48
    Top = 24
    Width = 121
    Height = 57
    Caption = 'Make Data Map'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 175
    Top = 24
    Width = 105
    Height = 57
    Caption = 'Display Iterate'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Memo1: TMemo
    Left = 312
    Top = 8
    Width = 241
    Height = 329
    ImeName = 'Microsoft Office IME 2007'
    TabOrder = 2
  end
  object Button3: TButton
    Left = 48
    Top = 96
    Width = 121
    Height = 57
    Caption = 'Replace Data'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 176
    Top = 96
    Width = 105
    Height = 57
    Caption = 'Locate'
    TabOrder = 4
    OnClick = Button4Click
  end
end
