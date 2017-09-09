object FrameCromisIPCServer: TFrameCromisIPCServer
  Left = 0
  Top = 0
  Width = 896
  Height = 593
  TabOrder = 0
  object Splitter1: TSplitter
    Left = 0
    Top = 326
    Width = 896
    Height = 3
    Cursor = crVSplit
    Align = alTop
    ExplicitLeft = -364
    ExplicitTop = 457
    ExplicitWidth = 1028
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 133
    Width = 896
    Height = 193
    ActivePage = TabSheet1
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #49892#49884#44036' '#51217#49549' '#54788#54889
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lvConnections: TListView
        Left = 0
        Top = 0
        Width = 888
        Height = 165
        Align = alClient
        Columns = <
          item
            Caption = #51217#49549' IP '#51452#49548
            Width = 100
          end
          item
            Alignment = taCenter
            Caption = #49345#53468
          end
          item
            Alignment = taCenter
            Caption = #50672#44208#49884#44036
            Width = 100
          end
          item
            Alignment = taCenter
            Caption = #54252#53944#48264#54840
          end
          item
            Alignment = taCenter
            Caption = 'LogIn ID'
            Width = 100
          end
          item
            Alignment = taCenter
            Caption = 'Session ID'
            Width = 100
          end>
        PopupMenu = PopupMenu2
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
    object TabSheet2: TTabSheet
      Caption = #53685#49888' '#49345#53468
      ImageIndex = 1
      object Splitter2: TSplitter
        Left = 437
        Top = 0
        Width = 6
        Height = 165
        ExplicitLeft = 256
        ExplicitTop = 3
        ExplicitHeight = 300
      end
      object SendMemo: TRichEdit
        Left = 0
        Top = 0
        Width = 437
        Height = 165
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
        Width = 445
        Height = 165
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
  end
  object PageControl2: TPageControl
    Left = 0
    Top = 329
    Width = 896
    Height = 245
    ActivePage = TabSheet4
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object TabSheet4: TTabSheet
      Caption = #49884#49828#53596' '#47196#44536
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object SMSysLog: TMemo
        Left = 0
        Top = 0
        Width = 888
        Height = 217
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ImeName = 'Microsoft IME 2010'
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object TabSheet5: TTabSheet
      Caption = #51217#49549' '#47196#44536
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object SMUDPConnectLog: TMemo
        Left = 0
        Top = 0
        Width = 888
        Height = 217
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ImeName = 'Microsoft IME 2010'
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object TabSheet6: TTabSheet
      Caption = #51204#49569' '#47196#44536
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object SMCommLog: TMemo
        Left = 0
        Top = 0
        Width = 888
        Height = 217
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ImeName = 'Microsoft IME 2010'
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 896
    Height = 33
    Align = alTop
    TabOrder = 2
    object AutoStartCheck: TCheckBox
      Left = 24
      Top = 10
      Width = 369
      Height = 17
      Caption = 'Auto start IPC Server  after 10 seconds'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 33
    Width = 896
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
    object ServerStartBtn: TJvXPButton
      Left = 24
      Top = 6
      Height = 91
      Caption = #49436#48260#49884#51089
      TabOrder = 0
      OnClick = ServerStartBtnClick
    end
    object ServerStopBtn: TJvXPButton
      Left = 103
      Top = 6
      Height = 91
      Caption = #49436#48260#51473#51648
      Enabled = False
      TabOrder = 1
      OnClick = ServerStopBtnClick
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
    object ServerIpCombo: TComboBox
      Left = 632
      Top = 8
      Width = 111
      Height = 21
      ImeName = 'Microsoft IME 2010'
      TabOrder = 6
      Text = 'localhost'
    end
  end
  object AdvOfficeStatusBar1: TAdvOfficeStatusBar
    Left = 0
    Top = 574
    Width = 896
    Height = 19
    AnchorHint = False
    Panels = <
      item
        AppearanceStyle = psLight
        DateFormat = 'yyyy/MM/dd'
        Progress.BackGround = clNone
        Progress.Indication = piPercentage
        Progress.Min = 0
        Progress.Max = 100
        Progress.Position = 0
        Progress.Level0Color = clLime
        Progress.Level0ColorTo = 14811105
        Progress.Level1Color = clYellow
        Progress.Level1ColorTo = 13303807
        Progress.Level2Color = 5483007
        Progress.Level2ColorTo = 11064319
        Progress.Level3Color = clRed
        Progress.Level3ColorTo = 13290239
        Progress.Level1Perc = 70
        Progress.Level2Perc = 90
        Progress.BorderColor = clBlack
        Progress.ShowBorder = False
        Progress.Stacked = False
        TimeFormat = 'AMPM h:mm:ss'
        Width = 80
      end
      item
        AppearanceStyle = psLight
        DateFormat = 'yyyy/MM/dd'
        Progress.BackGround = clNone
        Progress.Indication = piPercentage
        Progress.Min = 0
        Progress.Max = 100
        Progress.Position = 0
        Progress.Level0Color = clLime
        Progress.Level0ColorTo = 14811105
        Progress.Level1Color = clYellow
        Progress.Level1ColorTo = 13303807
        Progress.Level2Color = 5483007
        Progress.Level2ColorTo = 11064319
        Progress.Level3Color = clRed
        Progress.Level3ColorTo = 13290239
        Progress.Level1Perc = 70
        Progress.Level2Perc = 90
        Progress.BorderColor = clBlack
        Progress.ShowBorder = False
        Progress.Stacked = False
        TimeFormat = 'AMPM h:mm:ss'
        Width = 100
      end
      item
        AppearanceStyle = psLight
        DateFormat = 'yyyy/MM/dd'
        Progress.BackGround = clNone
        Progress.Indication = piPercentage
        Progress.Min = 0
        Progress.Max = 100
        Progress.Position = 0
        Progress.Level0Color = clLime
        Progress.Level0ColorTo = 14811105
        Progress.Level1Color = clYellow
        Progress.Level1ColorTo = 13303807
        Progress.Level2Color = 5483007
        Progress.Level2ColorTo = 11064319
        Progress.Level3Color = clRed
        Progress.Level3ColorTo = 13290239
        Progress.Level1Perc = 70
        Progress.Level2Perc = 90
        Progress.BorderColor = clBlack
        Progress.ShowBorder = False
        Progress.Stacked = False
        Style = psProgress
        TimeFormat = 'AMPM h:mm:ss'
        Width = 130
      end
      item
        AppearanceStyle = psLight
        DateFormat = 'yyyy/MM/dd'
        Progress.BackGround = clNone
        Progress.Indication = piPercentage
        Progress.Min = 0
        Progress.Max = 100
        Progress.Position = 0
        Progress.Level0Color = clLime
        Progress.Level0ColorTo = 14811105
        Progress.Level1Color = clYellow
        Progress.Level1ColorTo = 13303807
        Progress.Level2Color = 5483007
        Progress.Level2ColorTo = 11064319
        Progress.Level3Color = clRed
        Progress.Level3ColorTo = 13290239
        Progress.Level1Perc = 70
        Progress.Level2Perc = 90
        Progress.BorderColor = clBlack
        Progress.ShowBorder = False
        Progress.Stacked = False
        TimeFormat = 'AMPM h:mm:ss'
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = False
    ShowSplitter = True
    SimplePanel = False
    Styler = AdvOfficeStatusBarOfficeStyler1
    Version = '1.5.3.0'
  end
  object JvTrayIcon1: TJvTrayIcon
    IconIndex = 0
    PopupMenu = PopupMenu1
    Visibility = [tvVisibleTaskBar, tvVisibleTaskList, tvAutoHide, tvRestoreDbClick]
    Left = 120
    Top = 208
  end
  object PopupMenu1: TPopupMenu
    Left = 160
    Top = 208
    object MenuItem1: TMenuItem
      Caption = #54868#47732#48372#51060#44592'(Show)'
    end
    object MenuItem2: TMenuItem
      Caption = '-'
    end
    object MenuItem3: TMenuItem
      Caption = #51060' '#54532#47196#44536#47016#50640' '#45824#54616#50668'...(About)'
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object MenuItem4: TMenuItem
      Caption = #45149#45236#44592'(Exit)'
    end
  end
  object Timer1: TTimer
    Left = 80
    Top = 208
  end
  object AdvOfficeStatusBarOfficeStyler1: TAdvOfficeStatusBarOfficeStyler
    BorderColor = 14986888
    PanelAppearanceLight.BorderColor = 14922381
    PanelAppearanceLight.BorderColorHot = clGray
    PanelAppearanceLight.BorderColorDown = 10240783
    PanelAppearanceLight.Color = 16440774
    PanelAppearanceLight.ColorTo = 14854530
    PanelAppearanceLight.ColorHot = 13958143
    PanelAppearanceLight.ColorHotTo = 6538487
    PanelAppearanceLight.ColorDown = 9232890
    PanelAppearanceLight.ColorDownTo = 1940207
    PanelAppearanceLight.ColorMirror = 14854530
    PanelAppearanceLight.ColorMirrorTo = 14854530
    PanelAppearanceLight.ColorMirrorHot = 6538487
    PanelAppearanceLight.ColorMirrorHotTo = 6538487
    PanelAppearanceLight.ColorMirrorDown = 1940207
    PanelAppearanceLight.ColorMirrorDownTo = 1940207
    PanelAppearanceLight.TextColor = clBlack
    PanelAppearanceLight.TextColorHot = clBlack
    PanelAppearanceLight.TextColorDown = clBlack
    PanelAppearanceLight.TextStyle = []
    PanelAppearanceDark.BorderColor = clNone
    PanelAppearanceDark.BorderColorHot = clGray
    PanelAppearanceDark.BorderColorDown = 10240783
    PanelAppearanceDark.Color = 13861717
    PanelAppearanceDark.ColorTo = 10240783
    PanelAppearanceDark.ColorHot = 13958143
    PanelAppearanceDark.ColorHotTo = 6538487
    PanelAppearanceDark.ColorDown = 9232890
    PanelAppearanceDark.ColorDownTo = 1940207
    PanelAppearanceDark.ColorMirror = 10240783
    PanelAppearanceDark.ColorMirrorTo = 10240783
    PanelAppearanceDark.ColorMirrorHot = 6538487
    PanelAppearanceDark.ColorMirrorHotTo = 6538487
    PanelAppearanceDark.ColorMirrorDown = 1940207
    PanelAppearanceDark.ColorMirrorDownTo = 1940207
    PanelAppearanceDark.TextColor = clWhite
    PanelAppearanceDark.TextColorHot = clWhite
    PanelAppearanceDark.TextColorDown = clWhite
    PanelAppearanceDark.TextStyle = []
    Left = 200
    Top = 208
  end
  object PopupMenu2: TPopupMenu
    Left = 300
    Top = 213
    object DeleteItem1: TMenuItem
      Caption = 'Delete Item'
    end
  end
end
