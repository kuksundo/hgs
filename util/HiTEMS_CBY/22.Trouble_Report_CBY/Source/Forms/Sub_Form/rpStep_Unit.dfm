object rpStep_Frm: TrpStep_Frm
  Left = 0
  Top = 0
  Caption = #47928#51228#51216' '#48372#44256#49436' - '#51312#52824#51077#47141#45824#44592#47928#49436
  ClientHeight = 327
  ClientWidth = 719
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = #47569#51008' '#44256#46357
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object NxHeaderPanel1: TNxHeaderPanel
    Left = 0
    Top = 0
    Width = 719
    Height = 274
    Align = alClient
    Caption = #51312#52824#51077#47141' '#47928#49436' '#47785#47197
    ColorScheme = csBlack
    HeaderFont.Charset = ANSI_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -16
    HeaderFont.Name = #47569#51008' '#44256#46357
    HeaderFont.Style = [fsBold, fsItalic]
    HeaderSize = 36
    HeaderStyle = psWindowsLive
    InnerMargins.Left = 1
    InnerMargins.Top = 1
    InnerMargins.Bottom = 1
    InnerMargins.Right = 1
    ParentHeaderFont = False
    TabOrder = 0
    ExplicitLeft = -11
    ExplicitWidth = 730
    ExplicitHeight = 263
    FullWidth = 719
    object StepGrid: TNextGrid
      Left = 1
      Top = 37
      Width = 715
      Height = 234
      Align = alClient
      AutoScroll = True
      HeaderStyle = hsOffice2007
      HighlightedTextColor = clBlue
      Options = [goHeader, goSelectFullRow]
      SelectionColor = 11402490
      TabOrder = 0
      TabStop = True
      OnDblClick = StepGridDblClick
      OnSelectCell = StepGridSelectCell
      ExplicitWidth = 708
      ExplicitHeight = 223
      object NxIncrementColumn1: TNxIncrementColumn
        Alignment = taCenter
        DefaultWidth = 38
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Header.Caption = 'No.'
        Header.Alignment = taCenter
        ParentFont = False
        Position = 0
        SortType = stAlphabetic
        Width = 38
      end
      object NxTextColumn1: TNxTextColumn
        DefaultWidth = 150
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Header.Caption = #47928#49436#48264#54840
        Header.Alignment = taCenter
        ParentFont = False
        Position = 1
        SortType = stAlphabetic
        Visible = False
        Width = 150
      end
      object NxTextColumn5: TNxTextColumn
        Alignment = taCenter
        DefaultWidth = 100
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = #47569#51008' '#44256#46357
        Font.Style = []
        Header.Caption = #50644#51652#53440#51077
        Header.Alignment = taCenter
        ParentFont = False
        Position = 2
        SortType = stAlphabetic
        Width = 100
      end
      object NxTextColumn2: TNxTextColumn
        DefaultWidth = 426
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Header.Caption = #47928#49436#51228#47785
        Header.Alignment = taCenter
        Options = [coAutoSize, coCanClick, coCanInput, coCanSort, coPublicUsing, coShowTextFitHint]
        ParentFont = False
        Position = 3
        SortType = stAlphabetic
        Width = 415
      end
      object NxTextColumn3: TNxTextColumn
        Alignment = taCenter
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Header.Caption = #48372#44256#49436#51089#49457#51068
        Header.Alignment = taCenter
        ParentFont = False
        Position = 4
        SortType = stAlphabetic
      end
      object NxTextColumn4: TNxTextColumn
        Alignment = taCenter
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Header.Caption = #47928#49436#49345#53468
        Header.Alignment = taCenter
        ParentFont = False
        Position = 5
        SortType = stAlphabetic
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 274
    Width = 719
    Height = 34
    Align = alBottom
    TabOrder = 1
    ExplicitLeft = -11
    ExplicitTop = 263
    ExplicitWidth = 730
    object Button2: TButton
      AlignWithMargins = True
      Left = 625
      Top = 4
      Width = 90
      Height = 26
      Align = alRight
      Caption = #45803#44592
      ImageIndex = 11
      ImageMargins.Left = 10
      Images = Main_Frm.Imglist16x16
      TabOrder = 0
      OnClick = Button2Click
      ExplicitLeft = 636
    end
    object Button1: TButton
      AlignWithMargins = True
      Left = 500
      Top = 4
      Width = 122
      Height = 26
      Margins.Right = 0
      Align = alRight
      Caption = #48372#44256#49436' '#54869#51064
      ImageIndex = 9
      ImageMargins.Left = 10
      Images = Main_Frm.Imglist16x16
      TabOrder = 1
      OnClick = Button1Click
      ExplicitLeft = 511
    end
  end
  object Statusbar1: TAdvOfficeStatusBar
    Left = 0
    Top = 308
    Width = 719
    Height = 19
    AnchorHint = False
    Panels = <
      item
        AppearanceStyle = psLight
        DateFormat = 'yyyy-MM-dd'
        ImageIndex = 17
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
        Style = psImage
        TimeFormat = 'AMPM h:mm:ss'
        Width = 132
      end
      item
        AppearanceStyle = psLight
        DateFormat = 'yyyy-MM-dd'
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
        Width = 44
      end
      item
        Alignment = taCenter
        AppearanceStyle = psLight
        DateFormat = 'yyyy-MM-dd'
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
        Width = 81
      end
      item
        Alignment = taCenter
        AppearanceStyle = psLight
        DateFormat = 'yyyy-MM-dd'
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
        Style = psImage
        TimeFormat = 'AMPM h:mm:ss'
        Width = 39
      end
      item
        AppearanceStyle = psLight
        DateFormat = 'yyyy-MM-dd'
        ImageIndex = 0
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
        Style = psImage
        TimeFormat = 'AMPM h:mm:ss'
        Width = 98
      end
      item
        AppearanceStyle = psLight
        DateFormat = 'yyyy-MM-dd'
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
        Style = psImage
        TimeFormat = 'AMPM h:mm:ss'
        Width = 180
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
    ShowSplitter = True
    SimplePanel = False
    URLColor = clBlue
    Version = '1.4.1.0'
    ExplicitLeft = -11
    ExplicitTop = 297
    ExplicitWidth = 730
  end
end
