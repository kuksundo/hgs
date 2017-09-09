object ModbusComF: TModbusComF
  Left = 260
  Top = 121
  Width = 346
  Height = 423
  Caption = #54788#45824#51473#44277#50629' '#50644#51652#49884#54744#44592#49696#48512
  Color = 14597308
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object MsgLed: TSCLED
    Left = 0
    Top = 0
    Width = 338
    Height = 58
    Lines.Strings = (
      'LoadCell Communicator')
    ForeColor = 16738047
    BackColor = clBlack
    LEDCountX = 112
    LEDCountY = 19
    AlignmentH = schaCenter
    AlignmentV = scvaCenter
    Caption = 'MsgLed'
    Color = 867650
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
    Top = 370
    Width = 338
    Height = 19
    Panels = <>
    SimplePanel = False
  end
  object GroupBox1: TGroupBox
    Left = 4
    Top = 102
    Width = 329
    Height = 128
    Caption = #49569#49888#45800
    TabOrder = 1
    object ModBusSendComMemo: TMemo
      Left = 8
      Top = 18
      Width = 313
      Height = 100
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ImeName = 'Microsoft IME 2003'
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object GroupBox2: TGroupBox
    Left = 4
    Top = 234
    Width = 329
    Height = 126
    Caption = #49688#49888#45800
    TabOrder = 2
    object ModBusRecvComMemo: TMemo
      Left = 8
      Top = 17
      Width = 313
      Height = 100
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ImeName = 'Microsoft IME 2003'
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object Button1: TButton
    Left = 4
    Top = 65
    Width = 97
    Height = 35
    BiDiMode = bdLeftToRight
    Caption = #53685#49888#49884#51089
    ParentBiDiMode = False
    TabOrder = 3
    OnClick = Switch1Click
  end
  object Button2: TButton
    Left = 205
    Top = 69
    Width = 93
    Height = 28
    Caption = #53580#49828#53944#53685#49888
    TabOrder = 4
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 100
    Top = 65
    Width = 96
    Height = 35
    Caption = #54872#44221#49444#51221
    TabOrder = 5
    OnClick = Button3Click
  end
  object GroupBox3: TGroupBox
    Left = 204
    Top = 60
    Width = 129
    Height = 37
    TabOrder = 6
    object Label1: TLabel
      Left = 16
      Top = 15
      Width = 57
      Height = 13
      Caption = #54788#51116#49345#53468' : '
    end
    object Label2: TLabel
      Left = 77
      Top = 15
      Width = 42
      Height = 13
      Caption = #45824#44592#51473'  '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 276
    Top = 111
  end
  object ApplicationEvents1: TApplicationEvents
    OnException = ApplicationEvents1Exception
    Left = 228
    Top = 111
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer2Timer
    Left = 252
    Top = 111
  end
end
