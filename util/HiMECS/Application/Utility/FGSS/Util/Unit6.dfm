object Form6: TForm6
  Left = 0
  Top = 0
  Caption = 'Form6'
  ClientHeight = 337
  ClientWidth = 481
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
    Left = 16
    Top = 32
    Width = 185
    Height = 65
    Caption = 'Make FGSSTag.sqlite'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 223
    Top = 32
    Width = 185
    Height = 65
    Caption = 'Make FGSSKMTerminalInfo.sqlite'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 16
    Top = 103
    Width = 185
    Height = 65
    Caption = 'Make FGSSKMTerminalInfo.sqlite'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 223
    Top = 103
    Width = 185
    Height = 65
    Caption = 'Make FGSSManualContents.sqlite'
    TabOrder = 3
    OnClick = Button4Click
  end
  object OpenDialog1: TOpenDialog
    Left = 40
    Top = 112
  end
end
