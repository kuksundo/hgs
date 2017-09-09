object f_dzProgressTest: Tf_dzProgressTest
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'dzMultiProgress Test'
  ClientHeight = 54
  ClientWidth = 205
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object l_Count: TLabel
    Left = 8
    Top = 8
    Width = 46
    Height = 13
    Caption = 'Bar count'
  end
  object b_Start: TButton
    Left = 112
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Start'
    Default = True
    TabOrder = 1
    OnClick = b_StartClick
  end
  object ed_Count: TEdit
    Left = 8
    Top = 24
    Width = 57
    Height = 21
    TabOrder = 0
    Text = '3'
  end
end
