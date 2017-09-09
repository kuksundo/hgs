object f_dzDialogTest: Tf_dzDialogTest
  Left = 0
  Top = 0
  Caption = 'dzDialog Test'
  ClientHeight = 138
  ClientWidth = 320
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object b_ShowException1: TButton
    Left = 8
    Top = 8
    Width = 145
    Height = 25
    Caption = 'ShowException 1'
    TabOrder = 0
    OnClick = b_ShowException1Click
  end
  object b_ShowException2: TButton
    Left = 8
    Top = 40
    Width = 145
    Height = 25
    Caption = 'ShowException 2'
    TabOrder = 1
    OnClick = b_ShowException2Click
  end
  object b_ShowException3: TButton
    Left = 8
    Top = 72
    Width = 145
    Height = 25
    Caption = 'ShowException 3'
    TabOrder = 2
    OnClick = b_ShowException3Click
  end
  object b_ShowMessage1: TButton
    Left = 168
    Top = 8
    Width = 129
    Height = 25
    Caption = 'ShowMessage 1'
    TabOrder = 3
    OnClick = b_ShowMessage1Click
  end
  object b_ShowMessage2: TButton
    Left = 168
    Top = 40
    Width = 129
    Height = 25
    Caption = 'ShowMessage 2'
    TabOrder = 4
    OnClick = b_ShowMessage2Click
  end
end
