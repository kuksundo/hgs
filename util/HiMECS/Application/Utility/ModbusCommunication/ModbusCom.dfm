object ModbusComF: TModbusComF
  Left = 204
  Top = 223
  Width = 696
  Height = 480
  Caption = 'MODBUS '#53685#49888' '#54868#47732
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
    Height = 374
    Cursor = crHSplit
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
    object TxLed: TALed
      Left = 294
      Top = 16
      Width = 16
      Height = 16
      Blink = False
    end
    object RxLed: TALed
      Left = 328
      Top = 16
      Width = 16
      Height = 16
      Blink = False
    end
    object Label1: TLabel
      Left = 256
      Top = 16
      Width = 37
      Height = 16
      AutoSize = False
      Caption = #49569#49888
    end
    object Label2: TLabel
      Left = 348
      Top = 16
      Width = 37
      Height = 16
      AutoSize = False
      Caption = #49688#49888
    end
    object Label3: TLabel
      Left = 408
      Top = 16
      Width = 113
      Height = 16
      AutoSize = False
      Caption = #53685#49888#50640#47084' '#44148#49688':'
    end
    object Label4: TLabel
      Left = 520
      Top = 16
      Width = 73
      Height = 16
      AutoSize = False
      Caption = '0'
    end
    object Button2: TSwitch
      Left = 5
      Top = 5
      Width = 129
      Height = 33
      CaptionStyle = stSunken
      CaptionPos = posRight
      Diameter = 100
      Caption = #53685#49888#49884#51089
      Checked = False
      OnColor = clLime
      OnClick = Switch1Click
      Focused = False
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 415
    Width = 688
    Height = 19
    Panels = <>
    SimplePanel = False
  end
  object ModBusSendComMemo: TMemo
    Left = 0
    Top = 41
    Width = 321
    Height = 374
    Align = alLeft
    ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object ModBusRecvComMemo: TMemo
    Left = 324
    Top = 41
    Width = 364
    Height = 374
    Align = alClient
    ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
    ScrollBars = ssBoth
    TabOrder = 3
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 64
    Top = 8
  end
  object SynMsgSyn1: TSynMsgSyn
    StringAttri.Foreground = clRed
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
