object ServerFrmMain: TServerFrmMain
  Left = 655
  Top = 306
  Caption = 'AVAT ECS TCP-Server'
  ClientHeight = 491
  ClientWidth = 720
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
    Left = 0
    Top = 305
    Width = 720
    Height = 3
    Cursor = crVSplit
    Align = alTop
    ExplicitLeft = -364
    ExplicitTop = 457
    ExplicitWidth = 1028
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 720
    Height = 33
    Align = alTop
    TabOrder = 0
    object Button1: TButton
      Left = 421
      Top = 2
      Width = 75
      Height = 25
      Caption = 'Hide'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 133
    Width = 720
    Height = 172
    ActivePage = TabSheet1
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = #49892#49884#44036' '#51217#49549' '#54788#54889
      object lvConnections: TListView
        Left = 0
        Top = 0
        Width = 712
        Height = 144
        Align = alClient
        Columns = <
          item
            Caption = #51217#49549' IP '#51452#49548
          end
          item
            Alignment = taCenter
            Caption = #49345#53468
          end
          item
            Alignment = taCenter
            Caption = #50672#44208#49884#44036
          end
          item
            Alignment = taCenter
            Caption = #54252#53944#48264#54840
          end>
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
    object TabSheet2: TTabSheet
      Caption = #53685#49888' '#49345#53468
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Splitter2: TSplitter
        Left = 437
        Top = 0
        Width = 6
        Height = 144
        ExplicitLeft = 256
        ExplicitTop = 3
        ExplicitHeight = 300
      end
      object SendMemo: TRichEdit
        Left = 0
        Top = 0
        Width = 437
        Height = 144
        Align = alLeft
        Font.Charset = HANGEUL_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
      end
      object Recvmemo: TRichEdit
        Left = 443
        Top = 0
        Width = 269
        Height = 144
        Align = alClient
        Font.Charset = HANGEUL_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 1
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'TabSheet3'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
  end
  object PageControl2: TPageControl
    Left = 0
    Top = 308
    Width = 720
    Height = 164
    ActivePage = TabSheet4
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object TabSheet4: TTabSheet
      Caption = #49884#49828#53596' '#47196#44536
      object SMUDPSysLog: TSynMemo
        Left = 0
        Top = 0
        Width = 712
        Height = 136
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        TabOrder = 0
        Gutter.Font.Charset = DEFAULT_CHARSET
        Gutter.Font.Color = clWindowText
        Gutter.Font.Height = -11
        Gutter.Font.Name = 'Courier New'
        Gutter.Font.Style = []
        Gutter.Width = 0
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        RightEdge = 0
      end
    end
    object TabSheet5: TTabSheet
      Caption = #51217#49549' '#47196#44536
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object SMUDPConnectLog: TSynMemo
        Left = 0
        Top = 0
        Width = 712
        Height = 136
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        TabOrder = 0
        Gutter.Font.Charset = DEFAULT_CHARSET
        Gutter.Font.Color = clWindowText
        Gutter.Font.Height = -11
        Gutter.Font.Name = 'Courier New'
        Gutter.Font.Style = []
        Gutter.Width = 0
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        RightEdge = 0
      end
    end
    object TabSheet6: TTabSheet
      Caption = #51204#49569' '#47196#44536
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object SMCommLog: TSynMemo
        Left = 0
        Top = 0
        Width = 712
        Height = 136
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        TabOrder = 0
        Gutter.Font.Charset = DEFAULT_CHARSET
        Gutter.Font.Color = clWindowText
        Gutter.Font.Height = -11
        Gutter.Font.Name = 'Courier New'
        Gutter.Font.Style = []
        Gutter.Width = 0
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        RightEdge = 0
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 33
    Width = 720
    Height = 100
    Align = alTop
    TabOrder = 3
    object Label5: TLabel
      Left = 568
      Top = 33
      Width = 64
      Height = 13
      Caption = #49892' '#54665' '#54252' '#53944' :'
    end
    object Label6: TLabel
      Left = 568
      Top = 55
      Width = 64
      Height = 13
      Caption = #54788#51116#51217#49549#49688':'
    end
    object Label7: TLabel
      Left = 568
      Top = 77
      Width = 64
      Height = 13
      Caption = #52572#45824#51217#49549#49688':'
    end
    object LblPort: TLabel
      Left = 638
      Top = 33
      Width = 28
      Height = 16
      Caption = '       '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LblCurConnent: TLabel
      Left = 638
      Top = 55
      Width = 8
      Height = 16
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LblMaxConn: TLabel
      Left = 638
      Top = 77
      Width = 21
      Height = 13
      Caption = '       '
    end
    object Label8: TLabel
      Left = 568
      Top = 11
      Width = 64
      Height = 13
      Caption = #49436' '#48260' '#51452' '#49548' :'
    end
    object LblIP: TLabel
      Left = 638
      Top = 11
      Width = 28
      Height = 16
      Caption = '       '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object JvXPButton1: TJvXPButton
      Left = 24
      Top = 6
      Height = 91
      Caption = #49436#48260#49884#51089
      TabOrder = 0
      OnClick = JvXPButton1Click
    end
    object JvXPButton2: TJvXPButton
      Left = 103
      Top = 6
      Height = 91
      Caption = #49436#48260#51473#51648
      Enabled = False
      TabOrder = 1
      OnClick = JvXPButton2Click
    end
    object JvXPButton3: TJvXPButton
      Left = 200
      Top = 6
      Height = 91
      Caption = #49436#48260#49444#51221
      TabOrder = 2
    end
    object JvXPButton4: TJvXPButton
      Left = 287
      Top = 6
      Height = 91
      Caption = #50976#51200#49444#51221
      TabOrder = 3
    end
    object JvXPButton5: TJvXPButton
      Left = 368
      Top = 6
      Height = 91
      Caption = #54252#53944#52404#53356
      TabOrder = 4
    end
    object JvXPButton6: TJvXPButton
      Left = 447
      Top = 6
      Height = 91
      Caption = #51217#44540#51228#50612
      TabOrder = 5
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 472
    Width = 720
    Height = 19
    Panels = <
      item
        Width = 50
      end
      item
        Width = 50
      end
      item
        Width = 50
      end
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
  object MainMenu1: TMainMenu
    Left = 64
    Top = 48
    object N1: TMenuItem
      Caption = #49444#51221
      object N2: TMenuItem
        Caption = #54252#53944#49444#51221
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
    object rlsmd1: TMenuItem
      Caption = #46041#51089
      object StopMonitor1: TMenuItem
        Caption = 'Stop Monitor'
        OnClick = StopMonitor1Click
      end
      object StartMonitor1: TMenuItem
        Caption = 'Start Monitor'
        OnClick = StartMonitor1Click
      end
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 96
    Top = 48
  end
  object PopupMenu1: TPopupMenu
    Left = 176
    Top = 48
    object MenuItem1: TMenuItem
      Caption = #54868#47732#48372#51060#44592'(Show)'
      OnClick = MenuItem1Click
    end
    object MenuItem2: TMenuItem
      Caption = '-'
    end
    object MenuItem3: TMenuItem
      Caption = #51060' '#54532#47196#44536#47016#50640' '#45824#54616#50668'...(About)'
      OnClick = MenuItem3Click
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object MenuItem4: TMenuItem
      Caption = #45149#45236#44592'(Exit)'
      OnClick = MenuItem4Click
    end
  end
  object JvTrayIcon1: TJvTrayIcon
    IconIndex = 0
    PopupMenu = PopupMenu1
    Visibility = [tvVisibleTaskBar, tvVisibleTaskList, tvAutoHide, tvRestoreDbClick]
    Left = 136
    Top = 48
  end
  object IdTCPServer1: TIdTCPServer
    Bindings = <>
    DefaultPort = 47111
    OnConnect = IdTCPServer1Connect
    OnDisconnect = IdTCPServer1Disconnect
    OnExecute = IdTCPServer1Execute
    Left = 24
    Top = 48
  end
end
