object MT210ComF: TMT210ComF
  Left = 138
  Top = 359
  Caption = 'MT210 '#53685#49888' '#54868#47732
  ClientHeight = 426
  ClientWidth = 688
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object UnitLabel: TLabel
    Left = 392
    Top = 67
    Width = 34
    Height = 19
    Caption = 'Unit'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label6: TLabel
    Left = 142
    Top = 66
    Width = 119
    Height = 19
    Caption = 'Measure Data:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 688
    Height = 41
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label4: TLabel
      Left = 520
      Top = 16
      Width = 73
      Height = 16
      AutoSize = False
      Caption = '0'
    end
    object Button1: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Start'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 400
    Width = 688
    Height = 26
    Panels = <
      item
        Width = 50
      end
      item
        Width = 50
      end
      item
        Width = 50
      end>
  end
  object ModBusSendComMemo: TMemo
    Left = 0
    Top = 97
    Width = 688
    Height = 303
    Align = alBottom
    ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
    ScrollBars = ssBoth
    TabOrder = 2
    ExplicitTop = 104
  end
  object ValueEdit: TEdit
    Left = 264
    Top = 64
    Width = 121
    Height = 27
    BiDiMode = bdRightToLeft
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ImeName = 'Microsoft Office IME 2007'
    ParentBiDiMode = False
    ParentFont = False
    TabOrder = 3
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 104
    Top = 8
  end
  object MainMenu1: TMainMenu
    Left = 136
    Top = 8
    object N1: TMenuItem
      Caption = #49444#51221
      object N2: TMenuItem
        Caption = #54872#44221#49444#51221
        OnClick = N2Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object N4: TMenuItem
        Caption = #51333#47308
        OnClick = N4Click
      end
    end
    object About1: TMenuItem
      Caption = 'About'
    end
  end
end
