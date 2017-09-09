object DynamoCommF: TDynamoCommF
  Left = 0
  Top = 0
  Caption = 'DynamoCommF'
  ClientHeight = 631
  ClientWidth = 729
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 178
    Top = 377
    Height = 235
    ExplicitLeft = 209
    ExplicitTop = 87
    ExplicitHeight = 362
  end
  object RecvComMemo: TMemo
    Left = 181
    Top = 377
    Width = 548
    Height = 235
    Align = alClient
    ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
    TabOrder = 0
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 612
    Width = 729
    Height = 19
    Panels = <>
  end
  object SendComMemo: TMemo
    Left = 0
    Top = 377
    Width = 178
    Height = 235
    Align = alLeft
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 729
    Height = 377
    Align = alTop
    TabOrder = 3
    object Label1: TLabel
      Left = 297
      Top = 11
      Width = 71
      Height = 13
      Caption = 'Destination IP:'
    end
    object Label2: TLabel
      Left = 501
      Top = 11
      Width = 81
      Height = 13
      Caption = 'Destination Port:'
    end
    object IPEdit: TEdit
      Left = 374
      Top = 8
      Width = 75
      Height = 21
      ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
      ReadOnly = True
      TabOrder = 0
      Text = '192.168.1.2'
    end
    object PortEdit: TEdit
      Left = 588
      Top = 8
      Width = 37
      Height = 21
      ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
      ReadOnly = True
      TabOrder = 1
      Text = '5002'
    end
    object Button1: TButton
      Left = 99
      Top = 6
      Width = 57
      Height = 25
      Caption = 'Start'
      TabOrder = 2
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 162
      Top = 6
      Width = 57
      Height = 25
      Caption = 'Stop'
      TabOrder = 3
      OnClick = Button2Click
    end
    object GroupBox1: TGroupBox
      Left = 297
      Top = 50
      Width = 121
      Height = 73
      Caption = 'BEARING(T/B) Temp.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      object BRGTBPanel: TPanel
        Left = 13
        Top = 24
        Width = 92
        Height = 41
        Color = -1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clYellow
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
      end
    end
    object GroupBox3: TGroupBox
      Left = 424
      Top = 50
      Width = 120
      Height = 73
      Caption = 'Water Inlet Temp.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      object WaterInletPanel: TPanel
        Left = 13
        Top = 24
        Width = 92
        Height = 41
        Color = -1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clYellow
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
      end
    end
    object GroupBox4: TGroupBox
      Left = 424
      Top = 129
      Width = 120
      Height = 73
      Caption = 'Water Outlet Temp.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      object WaterOutletPanel: TPanel
        Left = 13
        Top = 24
        Width = 92
        Height = 41
        Color = -1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clYellow
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
      end
    end
    object GroupBox5: TGroupBox
      Left = 16
      Top = 50
      Width = 241
      Height = 73
      Caption = 'Power(kW)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 7
      object PowerPanel: TPanel
        Left = 13
        Top = 24
        Width = 212
        Height = 41
        Color = -1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clYellow
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
      end
    end
    object GroupBox6: TGroupBox
      Left = 16
      Top = 129
      Width = 241
      Height = 73
      Caption = 'Torque(kN)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 8
      object TorquePanel: TPanel
        Left = 13
        Top = 24
        Width = 212
        Height = 41
        Color = -1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clYellow
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
      end
    end
    object GroupBox7: TGroupBox
      Left = 16
      Top = 208
      Width = 241
      Height = 73
      Caption = 'RPM'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 9
      object RPMPanel: TPanel
        Left = 13
        Top = 24
        Width = 212
        Height = 41
        Color = -1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clYellow
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
      end
    end
    object GroupBox8: TGroupBox
      Left = 550
      Top = 50
      Width = 120
      Height = 73
      Caption = 'Water Supply Press.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 10
      object WaterSupplyPanel: TPanel
        Left = 13
        Top = 24
        Width = 92
        Height = 41
        Color = -1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clYellow
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
      end
    end
    object GroupBox9: TGroupBox
      Left = 550
      Top = 129
      Width = 120
      Height = 73
      Caption = 'Body 1 Press.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 11
      object Body1Panel: TPanel
        Left = 13
        Top = 24
        Width = 92
        Height = 41
        Color = -1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clYellow
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
      end
    end
    object GroupBox11: TGroupBox
      Left = 424
      Top = 208
      Width = 120
      Height = 73
      Caption = 'OIL Press.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 12
      object OilPressPanel: TPanel
        Left = 13
        Top = 24
        Width = 92
        Height = 41
        Color = -1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clYellow
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
      end
    end
    object GroupBox12: TGroupBox
      Left = 550
      Top = 208
      Width = 120
      Height = 73
      Caption = 'Body 2 Press.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 13
      object Body2Panel: TPanel
        Left = 13
        Top = 24
        Width = 92
        Height = 41
        Color = -1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clYellow
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
      end
    end
    object GroupBox13: TGroupBox
      Left = 16
      Top = 287
      Width = 241
      Height = 73
      Caption = 'INLET'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 14
      object Inlet1Panel: TPanel
        Left = 13
        Top = 24
        Width = 92
        Height = 41
        Color = -1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clYellow
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
      end
      object Inlet2Panel: TPanel
        Left = 133
        Top = 24
        Width = 92
        Height = 41
        Color = -1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clYellow
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 1
      end
    end
    object GroupBox14: TGroupBox
      Left = 424
      Top = 287
      Width = 246
      Height = 73
      Caption = 'OUTLET'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 15
      object Outlet1Panel: TPanel
        Left = 13
        Top = 24
        Width = 92
        Height = 41
        Color = -1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clYellow
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
      end
      object Outlet2Panel: TPanel
        Left = 139
        Top = 22
        Width = 92
        Height = 41
        Color = -1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clYellow
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 1
      end
    end
    object PowerPanel2: TPanel
      Left = 263
      Top = 74
      Width = 212
      Height = 41
      Color = -1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 16
    end
    object TorquePanel2: TPanel
      Left = 263
      Top = 208
      Width = 212
      Height = 41
      Color = -1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 17
    end
    object RPMPanel2: TPanel
      Left = 247
      Top = 264
      Width = 212
      Height = 41
      Color = -1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 18
    end
  end
  object GroupBox2: TGroupBox
    Left = 297
    Top = 129
    Width = 121
    Height = 73
    Caption = 'BEARING(MTR) Temp.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    object BRGMTRPanel: TPanel
      Left = 13
      Top = 24
      Width = 92
      Height = 41
      Color = -1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
    end
  end
  object MainMenu1: TMainMenu
    Left = 16
    Top = 8
    object N1: TMenuItem
      Caption = 'File'
      object N2: TMenuItem
        Caption = 'Config'
        OnClick = N2Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object N4: TMenuItem
        Caption = 'Close'
        OnClick = N4Click
      end
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 80
    Top = 8
  end
  object IdUDPClient1: TIdUDPClient
    Port = 0
    Left = 48
    Top = 8
  end
end
