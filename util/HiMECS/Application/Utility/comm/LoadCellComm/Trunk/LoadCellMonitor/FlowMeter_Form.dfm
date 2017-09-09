object Form1: TForm1
  Left = 218
  Top = 319
  Width = 346
  Height = 458
  Caption = #54788#45824#51473#44277#50629' '#50644#51652#49884#54744#44592#49696#48512
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 338
    Height = 57
    Align = alTop
    TabOrder = 0
    object MsgLed: TSCLED
      Left = 1
      Top = 1
      Width = 336
      Height = 55
      Lines.Strings = (
        'LoadCell Monitor')
      BackColor = clBlack
      LEDCountX = 112
      LEDCountY = 18
      LEDStyle = sclsRound
      AlignmentH = schaCenter
      AlignmentV = scvaCenter
      Caption = 'FlowMeterMonitoring'
      Color = 867650
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -8
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentColor = False
      Align = alClient
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 57
    Width = 338
    Height = 348
    Align = alClient
    TabOrder = 1
    object Panel4: TPanel
      Left = 1
      Top = 1
      Width = 336
      Height = 346
      Align = alClient
      Color = 14408448
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -8
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object GroupBox3: TGroupBox
        Left = 4
        Top = 84
        Width = 327
        Height = 97
        Caption = #51064#49828#53556#53944' '#52404#53356#44592#45733#49444#51221
        TabOrder = 0
        object Label1: TLabel
          Left = 14
          Top = 43
          Width = 59
          Height = 13
          Caption = #47196#46300#49472'ID :  '
        end
        object Label9: TLabel
          Left = 12
          Top = 20
          Width = 63
          Height = 13
          Caption = #54788#51116#49345#53468' :   '
        end
        object lb_CheckStatus: TLabel
          Left = 80
          Top = 20
          Width = 48
          Height = 13
          HelpType = htKeyword
          Caption = #45824#44592#51473'    '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGreen
          Font.Height = 8
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label2: TLabel
          Left = 12
          Top = 68
          Width = 60
          Height = 13
          Caption = #52404#53356#44036#44201' :  '
        end
        object Label4: TLabel
          Left = 203
          Top = 69
          Width = 12
          Height = 13
          Caption = #52488
        end
        object Label6: TLabel
          Left = 160
          Top = 69
          Width = 12
          Height = 13
          Caption = #48516
        end
        object Label7: TLabel
          Left = 105
          Top = 69
          Width = 27
          Height = 13
          Caption = #49884#44036' '
        end
        object bt_CheckStart: TButton
          Left = 226
          Top = 15
          Width = 94
          Height = 36
          Caption = #52404#53433#49884#51089
          TabOrder = 0
          OnClick = bt_CheckStartClick
        end
        object cb_LoadCell: TComboBox
          Left = 78
          Top = 40
          Width = 95
          Height = 21
          ImeName = 'Microsoft IME 2003'
          ItemHeight = 13
          TabOrder = 1
          Text = #47196#46300#49472' '#49440#53469
          Items.Strings = (
            'HFO1'
            'HFO2'
            'MDO1'
            'MDO2'
            'LDO')
        end
        object bt_CheckStop: TButton
          Left = 226
          Top = 51
          Width = 94
          Height = 36
          Caption = #52404#53433#51333#47308
          TabOrder = 2
          OnClick = bt_CheckStopClick
        end
        object ed_LogSec: TEdit
          Left = 176
          Top = 65
          Width = 24
          Height = 21
          ImeName = 'Microsoft IME 2003'
          TabOrder = 3
          Text = '00'
        end
        object ed_LogMin: TEdit
          Left = 133
          Top = 65
          Width = 24
          Height = 21
          ImeName = 'Microsoft IME 2003'
          TabOrder = 4
          Text = '01'
        end
        object ed_LogHour: TEdit
          Left = 78
          Top = 65
          Width = 24
          Height = 21
          ImeName = 'Microsoft IME 2003'
          TabOrder = 5
          Text = '00'
        end
      end
      object GroupBox1: TGroupBox
        Left = 4
        Top = 6
        Width = 327
        Height = 74
        Caption = #54788#51116#49345#53468
        TabOrder = 1
        object Label10: TLabel
          Left = 13
          Top = 48
          Width = 63
          Height = 13
          Caption = #54788#51116#51473#47049' :   '
        end
        object Label11: TLabel
          Left = 13
          Top = 21
          Width = 63
          Height = 13
          Caption = #54788#51116#49884#44036' :   '
        end
        object Label12: TLabel
          Left = 184
          Top = 47
          Width = 13
          Height = 13
          Caption = 'Kg'
        end
        object ed_weight: TPanel
          Left = 81
          Top = 42
          Width = 96
          Height = 22
          BevelOuter = bvNone
          BorderWidth = 1
          BorderStyle = bsSingle
          Color = clWhite
          Font.Charset = HANGEUL_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #44404#47548#52404
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object pl_Time: TPanel
          Left = 81
          Top = 15
          Width = 190
          Height = 22
          BevelOuter = bvNone
          BorderWidth = 1
          BorderStyle = bsSingle
          Color = clWhite
          Font.Charset = HANGEUL_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #44404#47548#52404
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
      end
      object GroupBox2: TGroupBox
        Left = 4
        Top = 185
        Width = 327
        Height = 149
        Caption = #51064#49828#53556#53944' '#52404#53356#54868#47732
        TabOrder = 2
        object mm_Check: TMemo
          Left = 8
          Top = 19
          Width = 312
          Height = 118
          ImeName = 'Microsoft IME 2003'
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 405
    Width = 338
    Height = 19
    Panels = <>
    SimplePanel = False
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 248
    Top = 296
  end
  object PopupMenu1: TPopupMenu
    Left = 284
    Top = 248
    object Config1: TMenuItem
      Caption = 'Config'
      OnClick = Config1Click
    end
  end
  object Timer2: TTimer
    OnTimer = Timer2Timer
    Left = 280
    Top = 296
  end
  object Timer3: TTimer
    Enabled = False
    OnTimer = Timer3Timer
    Left = 248
    Top = 328
  end
end
