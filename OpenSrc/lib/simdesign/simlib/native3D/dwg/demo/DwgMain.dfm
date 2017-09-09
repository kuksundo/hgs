object Form1: TForm1
  Left = 288
  Top = 115
  Width = 870
  Height = 640
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  DesignSize = (
    862
    586)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 128
    Top = 568
    Width = 32
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Label1'
  end
  object mmStatus: TMemo
    Left = 8
    Top = 8
    Width = 833
    Height = 553
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
  end
  object chbSuppress: TCheckBox
    Left = 8
    Top = 568
    Width = 97
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'chbSuppress'
    TabOrder = 1
  end
  object MainMenu1: TMainMenu
    Left = 808
    Top = 24
    object File1: TMenuItem
      Caption = 'File'
      object OpenDWG1: TMenuItem
        Caption = 'Open DWG'
        OnClick = OpenDWG1Click
      end
    end
  end
end
