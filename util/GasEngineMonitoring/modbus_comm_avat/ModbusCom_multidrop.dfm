object ModbusComF: TModbusComF
  Left = 138
  Top = 359
  Caption = 'Modbus Communication'
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
  object Splitter1: TSplitter
    Left = 321
    Top = 41
    Height = 359
    ExplicitHeight = 366
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
    object Button1: TButton
      Left = 113
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Start'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 16
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Connect'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 560
      Top = 10
      Width = 107
      Height = 25
      Caption = 'Write ECU'
      TabOrder = 2
      OnClick = Button3Click
    end
  end
  object ModBusSendComMemo: TMemo
    Left = 0
    Top = 41
    Width = 321
    Height = 359
    Align = alLeft
    ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object ModBusRecvComMemo: TMemo
    Left = 324
    Top = 41
    Width = 364
    Height = 359
    Align = alClient
    ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object StatusBarPro1: TStatusBarPro
    Left = 0
    Top = 400
    Width = 688
    Height = 26
    Panels = <
      item
        Bevel = pbRaised
        Width = 50
      end
      item
        Control = JvLED1
        Width = 30
      end
      item
        Width = 100
      end
      item
        Width = 200
      end
      item
        Alignment = taRightJustify
        Text = 'Transfer(%)'
        Width = 200
      end
      item
        Control = JvProgressBar1
        Width = 50
      end>
    SimplePanel = False
    object JvLED1: TJvLED
      Left = 53
      Top = 3
      Width = 26
      Height = 22
      Active = True
      Interval = 0
      ParentShowHint = False
      ShowHint = True
      Status = False
    end
    object JvProgressBar1: TJvProgressBar
      Left = 583
      Top = 3
      Width = 68
      Height = 22
      TabOrder = 0
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 16
    Top = 56
  end
  object MainMenu1: TMainMenu
    Left = 56
    Top = 56
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
