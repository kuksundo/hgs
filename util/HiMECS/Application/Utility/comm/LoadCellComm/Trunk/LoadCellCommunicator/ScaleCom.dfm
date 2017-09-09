object ModbusComF: TModbusComF
  Left = 264
  Top = 124
  Width = 635
  Height = 415
  Caption = 'MODBUS '#53685#49888' '#54868#47732'(Multi-Drop)'
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
  object Splitter1: TSplitter
    Left = 321
    Top = 41
    Width = 3
    Height = 301
    Cursor = crHSplit
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 627
    Height = 41
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 256
      Top = 16
      Width = 37
      Height = 16
      AutoSize = False
      Caption = #49569#49888
    end
    object Label2: TLabel
      Left = 340
      Top = 16
      Width = 37
      Height = 16
      AutoSize = False
      Caption = #49688#49888
    end
    object Label3: TLabel
      Left = 464
      Top = 16
      Width = 113
      Height = 16
      AutoSize = False
      Caption = #53685#49888#50640#47084' '#44148#49688':'
    end
    object Label4: TLabel
      Left = 592
      Top = 16
      Width = 39
      Height = 16
      AutoSize = False
      Caption = '0'
    end
    object Button1: TButton
      Left = 8
      Top = 8
      Width = 97
      Height = 25
      BiDiMode = bdLeftToRight
      Caption = 'CommStart'
      ParentBiDiMode = False
      TabOrder = 0
      OnClick = Switch1Click
    end
    object Button2: TButton
      Left = 376
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Button2'
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 342
    Width = 627
    Height = 19
    Panels = <>
    SimplePanel = False
  end
  object ModBusSendComMemo: TMemo
    Left = 0
    Top = 41
    Width = 321
    Height = 301
    Align = alLeft
    ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object ModBusRecvComMemo: TMemo
    Left = 324
    Top = 41
    Width = 303
    Height = 301
    Align = alClient
    ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
    ScrollBars = ssBoth
    TabOrder = 3
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 112
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
  object ApplicationEvents1: TApplicationEvents
    OnException = ApplicationEvents1Exception
    Left = 168
    Top = 8
  end
end
