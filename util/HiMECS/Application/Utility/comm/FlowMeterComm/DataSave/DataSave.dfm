object Form1: TForm1
  Left = 513
  Top = 150
  Width = 337
  Height = 558
  Caption = 'BEM500 - KRAL Flow Meter Mon.'
  Color = clGradientInactiveCaption
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 20
  object MsgLed: TSCLED
    Left = 0
    Top = 0
    Width = 329
    Height = 58
    Lines.Strings = (
      ' Flow Meter Monitoring')
    ForeColor = clYellow
    BackColor = clBlack
    LEDCountX = 109
    LEDCountY = 19
    AlignmentH = schaLeft
    AlignmentV = scvaCenter
    Caption = 'MsgLed'
    Color = clMaroon
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 8
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ParentColor = False
    Align = alTop
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 500
    Width = 329
    Height = 24
    Panels = <>
    SimplePanel = False
  end
  object Panel29: TPanel
    Left = 11
    Top = 268
    Width = 154
    Height = 22
    Alignment = taLeftJustify
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Caption = 'Consumption (A-B) Q'
    Color = clInactiveCaptionText
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #48148#53461
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object Panel30: TPanel
    Left = 11
    Top = 288
    Width = 154
    Height = 22
    Alignment = taLeftJustify
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Caption = 'Total (A-B) '#8721'1'
    Color = clInactiveCaptionText
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #48148#53461
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object Panel31: TPanel
    Left = 11
    Top = 308
    Width = 154
    Height = 22
    Alignment = taLeftJustify
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Caption = 'Total (A-B) '#8721'2'
    Color = clInactiveCaptionText
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #48148#53461
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object Panel32: TPanel
    Left = 11
    Top = 328
    Width = 154
    Height = 22
    Alignment = taLeftJustify
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Caption = 'Volumeter A QA'
    Color = clInactiveCaptionText
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #48148#53461
    Font.Style = []
    ParentFont = False
    TabOrder = 4
  end
  object Panel33: TPanel
    Left = 11
    Top = 348
    Width = 154
    Height = 22
    Alignment = taLeftJustify
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Caption = 'Volumeter A T'
    Color = clInactiveCaptionText
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #48148#53461
    Font.Style = []
    ParentFont = False
    TabOrder = 5
  end
  object Panel28: TPanel
    Left = 11
    Top = 241
    Width = 154
    Height = 25
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Caption = #54637' '#47785
    Color = clInactiveCaptionText
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #48148#53461
    Font.Style = []
    ParentFont = False
    TabOrder = 6
  end
  object CONSUMPTIONQ: TPanel
    Left = 163
    Top = 268
    Width = 117
    Height = 22
    BevelOuter = bvNone
    BorderWidth = 1
    BorderStyle = bsSingle
    Color = clInactiveCaptionText
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = #48148#53461
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
  end
  object TOTALT1: TPanel
    Left = 163
    Top = 288
    Width = 117
    Height = 22
    BevelOuter = bvNone
    BorderWidth = 1
    BorderStyle = bsSingle
    Color = clInactiveCaptionText
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = #48148#53461
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
  end
  object TOTALT2: TPanel
    Left = 163
    Top = 308
    Width = 117
    Height = 22
    BevelOuter = bvNone
    BorderWidth = 1
    BorderStyle = bsSingle
    Color = clInactiveCaptionText
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = #48148#53461
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 9
  end
  object VOL_A_QA: TPanel
    Left = 163
    Top = 328
    Width = 117
    Height = 22
    BevelOuter = bvNone
    BorderWidth = 1
    BorderStyle = bsSingle
    Color = clInactiveCaptionText
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = #48148#53461
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 10
  end
  object VOL_A_T: TPanel
    Left = 163
    Top = 348
    Width = 117
    Height = 22
    BevelOuter = bvNone
    BorderWidth = 1
    BorderStyle = bsSingle
    Color = clInactiveCaptionText
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = #48148#53461
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 11
  end
  object Panel83: TPanel
    Left = 163
    Top = 241
    Width = 117
    Height = 25
    BevelOuter = bvNone
    BorderWidth = 1
    BorderStyle = bsSingle
    Caption = #44050
    Color = clInactiveCaptionText
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = 13
    Font.Name = #48148#53461
    Font.Style = []
    ParentFont = False
    TabOrder = 12
  end
  object Panel36: TPanel
    Left = 11
    Top = 368
    Width = 154
    Height = 22
    Alignment = taLeftJustify
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Caption = 'Volumeter B QB'
    Color = clInactiveCaptionText
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #48148#53461
    Font.Style = []
    ParentFont = False
    TabOrder = 13
  end
  object Panel23: TPanel
    Left = 11
    Top = 388
    Width = 154
    Height = 22
    Alignment = taLeftJustify
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Caption = 'Volumeter B T'
    Color = clInactiveCaptionText
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #48148#53461
    Font.Style = []
    ParentFont = False
    TabOrder = 14
  end
  object VOL_B_QB: TPanel
    Left = 163
    Top = 368
    Width = 117
    Height = 22
    BevelOuter = bvNone
    BorderWidth = 1
    BorderStyle = bsSingle
    Color = clInactiveCaptionText
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = #48148#53461
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 15
  end
  object VOL_B_T: TPanel
    Left = 163
    Top = 388
    Width = 117
    Height = 22
    BevelOuter = bvNone
    BorderWidth = 1
    BorderStyle = bsSingle
    Color = clInactiveCaptionText
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = #48148#53461
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 16
  end
  object Panel9: TPanel
    Left = 278
    Top = 268
    Width = 41
    Height = 22
    BevelOuter = bvNone
    BorderWidth = 1
    BorderStyle = bsSingle
    Caption = 'kg/h'
    Color = clInactiveCaptionText
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = #48148#53461
    Font.Style = []
    ParentFont = False
    TabOrder = 17
  end
  object Panel10: TPanel
    Left = 278
    Top = 288
    Width = 41
    Height = 22
    BevelOuter = bvNone
    BorderWidth = 1
    BorderStyle = bsSingle
    Caption = 'kg'
    Color = clInactiveCaptionText
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = #48148#53461
    Font.Style = []
    ParentFont = False
    TabOrder = 18
  end
  object Panel11: TPanel
    Left = 278
    Top = 308
    Width = 41
    Height = 22
    BevelOuter = bvNone
    BorderWidth = 1
    BorderStyle = bsSingle
    Caption = 'kg'
    Color = clInactiveCaptionText
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = #48148#53461
    Font.Style = []
    ParentFont = False
    TabOrder = 19
  end
  object Panel12: TPanel
    Left = 278
    Top = 328
    Width = 41
    Height = 22
    BevelOuter = bvNone
    BorderWidth = 1
    BorderStyle = bsSingle
    Caption = 'kg/h'
    Color = clInactiveCaptionText
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = #48148#53461
    Font.Style = []
    ParentFont = False
    TabOrder = 20
  end
  object Panel14: TPanel
    Left = 278
    Top = 348
    Width = 41
    Height = 22
    BevelOuter = bvNone
    BorderWidth = 1
    BorderStyle = bsSingle
    Caption = #8451
    Color = clInactiveCaptionText
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = #48148#53461
    Font.Style = []
    ParentFont = False
    TabOrder = 21
  end
  object Panel18: TPanel
    Left = 278
    Top = 241
    Width = 41
    Height = 25
    BevelOuter = bvNone
    BorderWidth = 1
    BorderStyle = bsSingle
    Caption = #45800#50948
    Color = clInactiveCaptionText
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = 13
    Font.Name = #48148#53461
    Font.Style = []
    ParentFont = False
    TabOrder = 22
  end
  object Panel8: TPanel
    Left = 278
    Top = 368
    Width = 41
    Height = 22
    BevelOuter = bvNone
    BorderWidth = 1
    BorderStyle = bsSingle
    Caption = 'kg/h'
    Color = clInactiveCaptionText
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = #48148#53461
    Font.Style = []
    ParentFont = False
    TabOrder = 23
  end
  object Panel19: TPanel
    Left = 278
    Top = 388
    Width = 41
    Height = 22
    BevelOuter = bvNone
    BorderWidth = 1
    BorderStyle = bsSingle
    Caption = #8451
    Color = clInactiveCaptionText
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = #48148#53461
    Font.Style = []
    ParentFont = False
    TabOrder = 24
  end
  object Panel3: TPanel
    Left = 11
    Top = 408
    Width = 154
    Height = 22
    Alignment = taLeftJustify
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Caption = 'Volumeter A Total '#8721'A1'
    Color = clInactiveCaptionText
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #48148#53461
    Font.Style = []
    ParentFont = False
    TabOrder = 25
  end
  object Panel5: TPanel
    Left = 11
    Top = 428
    Width = 154
    Height = 22
    Alignment = taLeftJustify
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Caption = 'Volumeter A Total '#8721'A2'
    Color = clInactiveCaptionText
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #48148#53461
    Font.Style = []
    ParentFont = False
    TabOrder = 26
  end
  object Panel6: TPanel
    Left = 11
    Top = 448
    Width = 154
    Height = 22
    Alignment = taLeftJustify
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Caption = 'Volumeter B Total '#8721'B1'
    Color = clInactiveCaptionText
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #48148#53461
    Font.Style = []
    ParentFont = False
    TabOrder = 27
  end
  object VOL_A_TOT_TA1: TPanel
    Left = 163
    Top = 408
    Width = 117
    Height = 22
    BevelOuter = bvNone
    BorderWidth = 1
    BorderStyle = bsSingle
    Color = clInactiveCaptionText
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = #48148#53461
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 28
  end
  object VOL_A_TOT_TA2: TPanel
    Left = 163
    Top = 428
    Width = 117
    Height = 22
    BevelOuter = bvNone
    BorderWidth = 1
    BorderStyle = bsSingle
    Color = clInactiveCaptionText
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = #48148#53461
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 29
  end
  object VOL_B_TOT_TB1: TPanel
    Left = 163
    Top = 448
    Width = 117
    Height = 22
    BevelOuter = bvNone
    BorderWidth = 1
    BorderStyle = bsSingle
    Color = clInactiveCaptionText
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = #48148#53461
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 30
  end
  object Panel15: TPanel
    Left = 278
    Top = 408
    Width = 41
    Height = 22
    BevelOuter = bvNone
    BorderWidth = 1
    BorderStyle = bsSingle
    Caption = 'kg'
    Color = clInactiveCaptionText
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = #48148#53461
    Font.Style = []
    ParentFont = False
    TabOrder = 31
  end
  object Panel16: TPanel
    Left = 278
    Top = 428
    Width = 41
    Height = 22
    BevelOuter = bvNone
    BorderWidth = 1
    BorderStyle = bsSingle
    Caption = 'kg'
    Color = clInactiveCaptionText
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = #48148#53461
    Font.Style = []
    ParentFont = False
    TabOrder = 32
  end
  object Panel17: TPanel
    Left = 278
    Top = 448
    Width = 41
    Height = 22
    BevelOuter = bvNone
    BorderWidth = 1
    BorderStyle = bsSingle
    Caption = 'kg'
    Color = clInactiveCaptionText
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = #48148#53461
    Font.Style = []
    ParentFont = False
    TabOrder = 33
  end
  object Panel34: TPanel
    Left = 11
    Top = 468
    Width = 154
    Height = 22
    Alignment = taLeftJustify
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Caption = 'Volumeter B Total '#8721'B2'
    Color = clInactiveCaptionText
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #48148#53461
    Font.Style = []
    ParentFont = False
    TabOrder = 34
  end
  object VOL_B_TOT_TB2: TPanel
    Left = 163
    Top = 468
    Width = 117
    Height = 22
    BevelOuter = bvNone
    BorderWidth = 1
    BorderStyle = bsSingle
    Color = clInactiveCaptionText
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = #48148#53461
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 35
  end
  object Panel7: TPanel
    Left = 278
    Top = 468
    Width = 41
    Height = 22
    BevelOuter = bvNone
    BorderWidth = 1
    BorderStyle = bsSingle
    Caption = 'kg'
    Color = clInactiveCaptionText
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = #48148#53461
    Font.Style = []
    ParentFont = False
    TabOrder = 36
  end
  object GroupBox2: TGroupBox
    Left = 11
    Top = 64
    Width = 90
    Height = 73
    Caption = #53685#49888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 8
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 37
    object Button4: TButton
      Left = 8
      Top = 17
      Width = 76
      Height = 25
      Caption = #53685#49888#49884#51089
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 8
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = Button4Click
    end
    object Button1: TButton
      Left = 8
      Top = 42
      Width = 76
      Height = 25
      Caption = #53685#49888#51333#47308
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 8
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = Button1Click
    end
  end
  object GroupBox3: TGroupBox
    Left = 107
    Top = 64
    Width = 211
    Height = 73
    Caption = #47196#44536#49444#51221'('#49884#51089' '#51204' '#49464#54021')'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 8
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 38
    object Label1: TLabel
      Left = 5
      Top = 21
      Width = 54
      Height = 13
      Caption = #54788#51116#47196#46300' :'
    end
    object Label2: TLabel
      Left = 5
      Top = 45
      Width = 54
      Height = 13
      Caption = #44592#47197#49884#44036' :'
    end
    object Label3: TLabel
      Left = 109
      Top = 21
      Width = 8
      Height = 13
      Caption = '%'
    end
    object Label4: TLabel
      Left = 191
      Top = 45
      Width = 12
      Height = 13
      Caption = #52488
    end
    object Label6: TLabel
      Left = 148
      Top = 45
      Width = 12
      Height = 13
      Caption = #48516
    end
    object Label7: TLabel
      Left = 93
      Top = 45
      Width = 27
      Height = 13
      Caption = #49884#44036' '
    end
    object ed_Load: TEdit
      Left = 66
      Top = 17
      Width = 39
      Height = 21
      TabOrder = 0
      Text = '0'
    end
    object ed_LogSec: TEdit
      Left = 164
      Top = 41
      Width = 24
      Height = 21
      TabOrder = 1
      Text = '00'
    end
    object ed_LogMin: TEdit
      Left = 121
      Top = 41
      Width = 24
      Height = 21
      TabOrder = 2
      Text = '05'
    end
    object ed_LogHour: TEdit
      Left = 66
      Top = 41
      Width = 24
      Height = 21
      TabOrder = 3
      Text = '00'
    end
  end
  object GroupBox1: TGroupBox
    Left = 11
    Top = 144
    Width = 308
    Height = 89
    Caption = #47196#44536
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 8
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 39
    object Label5: TLabel
      Left = 150
      Top = 67
      Width = 7
      Height = 13
      Caption = '~'
    end
    object Label8: TLabel
      Left = 8
      Top = 19
      Width = 63
      Height = 13
      Caption = #54788#51116#49345#53468' :   '
    end
    object lb_status: TLabel
      Left = 72
      Top = 19
      Width = 42
      Height = 13
      HelpType = htKeyword
      Caption = #45824#44592#51473'  '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = 8
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Button2: TButton
      Left = 162
      Top = 16
      Width = 70
      Height = 42
      HelpType = htKeyword
      Caption = #44592#47197#49884#51089' '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 8
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 232
      Top = 16
      Width = 70
      Height = 42
      Caption = #44592#47197#51333#47308
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 8
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = Button3Click
    end
    object Edit1: TEdit
      Left = 4
      Top = 36
      Width = 140
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Text = #54788#51116#49884#44036' :'
    end
    object Edit2: TEdit
      Left = 4
      Top = 60
      Width = 140
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      Text = #49884#51089#49884#44036' :'
    end
    object ed_LogEndTime: TEdit
      Left = 161
      Top = 60
      Width = 140
      Height = 21
      TabOrder = 4
      Text = #47785#54364#49884#44036' :'
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 280
    Top = 24
  end
  object PopupMenu1: TPopupMenu
    Left = 248
    Top = 24
    object N1: TMenuItem
      Caption = #54872#44221#49444#51221
      OnClick = N1Click
    end
  end
  object Timer2: TTimer
    OnTimer = Timer2Timer
    Left = 215
    Top = 24
  end
end
