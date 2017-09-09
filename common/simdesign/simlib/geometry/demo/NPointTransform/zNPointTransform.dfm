object frmNPointTransform: TfrmNPointTransform
  Left = 251
  Top = 200
  Width = 1063
  Height = 740
  Caption = 'NPointTransform'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    1055
    706)
  PixelsPerInch = 96
  TextHeight = 13
  object lblResult: TLabel
    Left = 456
    Top = 13
    Width = 40
    Height = 13
    Caption = 'lblResult'
  end
  object btnTest1: TButton
    Left = 8
    Top = 8
    Width = 210
    Height = 25
    Caption = 'Test 1 - Does not compare'
    TabOrder = 0
    OnClick = btnTest1Click
  end
  object memResults: TMemo
    Left = 8
    Top = 40
    Width = 1039
    Height = 658
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object btnTest2: TButton
    Left = 240
    Top = 8
    Width = 210
    Height = 25
    Caption = 'Test 2 - Compares'
    TabOrder = 2
    OnClick = btnTest2Click
  end
end
