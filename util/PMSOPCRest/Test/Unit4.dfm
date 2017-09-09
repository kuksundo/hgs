object Form4: TForm4
  Left = 0
  Top = 0
  Caption = 'Form4'
  ClientHeight = 576
  ClientWidth = 605
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
    Width = 177
    Height = 81
    Caption = 'Connect DB'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 408
    Top = 8
    Width = 193
    Height = 81
    Caption = 'Disconnect DB'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Memo1: TMemo
    Left = 24
    Top = 160
    Width = 569
    Height = 393
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object Button3: TButton
    Left = 216
    Top = 8
    Width = 177
    Height = 81
    Caption = 'Insert Or Update'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 216
    Top = 96
    Width = 177
    Height = 49
    Caption = 'Select'
    TabOrder = 4
    OnClick = Button4Click
  end
end
