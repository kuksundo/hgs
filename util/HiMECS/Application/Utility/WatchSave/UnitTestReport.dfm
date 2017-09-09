object FormTestReport: TFormTestReport
  Left = 0
  Top = 0
  Caption = #48372#44256#49436' '#49373#49457
  ClientHeight = 305
  ClientWidth = 562
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 562
    Height = 286
    Align = alClient
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object Panel2: TPanel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 554
      Height = 32
      Align = alTop
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      object Panel4: TPanel
        AlignWithMargins = True
        Left = 4
        Top = 1
        Width = 117
        Height = 27
        Margins.Top = 0
        Align = alLeft
        Caption = 'CSV '#54028#51068' '#51060#47492
        Color = 16763594
        ParentBackground = False
        TabOrder = 0
      end
      object Button1: TButton
        AlignWithMargins = True
        Left = 465
        Top = 1
        Width = 85
        Height = 27
        Margins.Top = 0
        Align = alRight
        Caption = 'File Open'
        ImageIndex = 0
        TabOrder = 1
        OnClick = Button1Click
      end
      object FileNameEdt: TNxEdit
        AlignWithMargins = True
        Left = 127
        Top = 1
        Width = 332
        Height = 27
        Margins.Top = 0
        Align = alClient
        TabOrder = 2
        ExplicitHeight = 21
      end
    end
    object Panel3: TPanel
      AlignWithMargins = True
      Left = 4
      Top = 39
      Width = 554
      Height = 32
      Margins.Top = 0
      Align = alTop
      Color = clWhite
      ParentBackground = False
      TabOrder = 1
      object Panel6: TPanel
        AlignWithMargins = True
        Left = 465
        Top = 1
        Width = 85
        Height = 27
        Margins.Top = 0
        Align = alRight
        BevelOuter = bvNone
        Color = clWhite
        ParentBackground = False
        TabOrder = 0
      end
      object Panel5: TPanel
        AlignWithMargins = True
        Left = 4
        Top = 1
        Width = 117
        Height = 27
        Margins.Top = 0
        Align = alLeft
        Caption = #48372#44256#49436' '#50577#49885' '#54028#51068' '#51060#47492
        Color = 16763594
        ParentBackground = False
        TabOrder = 1
      end
      object ReportFilenameEdit: TJvFilenameEdit
        Left = 127
        Top = 2
        Width = 332
        Height = 21
        Filter = 'csv file|*.csv|All files (*.*)|*.*'
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 2
        Text = ''
      end
    end
    object Panel7: TPanel
      AlignWithMargins = True
      Left = 4
      Top = 247
      Width = 554
      Height = 35
      Margins.Top = 0
      Align = alBottom
      Color = clWhite
      ParentBackground = False
      TabOrder = 2
      object Button2: TButton
        AlignWithMargins = True
        Left = 4
        Top = 3
        Width = 117
        Height = 30
        Margins.Top = 0
        Caption = #48372#44256#49436#49373#49457
        ImageIndex = 1
        TabOrder = 0
        OnClick = Button2Click
      end
      object Button3: TButton
        Left = 432
        Top = 1
        Width = 108
        Height = 31
        Caption = 'Close'
        TabOrder = 1
        OnClick = Button3Click
      end
      object Button4: TButton
        AlignWithMargins = True
        Left = 156
        Top = 3
        Width = 149
        Height = 30
        Margins.Top = 0
        Caption = #49440#53469#54620' '#44163#47564' '#48372#44256#49436#49373#49457
        ImageIndex = 1
        TabOrder = 2
        OnClick = Button4Click
      end
    end
    object Panel8: TPanel
      AlignWithMargins = True
      Left = 4
      Top = 74
      Width = 554
      Height = 170
      Margins.Top = 0
      Align = alClient
      Color = clWhite
      ParentBackground = False
      TabOrder = 3
      object DataGrid: TAdvStringGrid
        Left = 1
        Top = 1
        Width = 552
        Height = 168
        Cursor = crDefault
        Align = alClient
        Ctl3D = True
        DrawingStyle = gdsClassic
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
        ParentCtl3D = False
        ParentFont = False
        PopupMenu = PopupMenu1
        ScrollBars = ssBoth
        TabOrder = 0
        OnSelectCell = DataGridSelectCell
        HoverRowCells = [hcNormal, hcSelected]
        ActiveCellFont.Charset = DEFAULT_CHARSET
        ActiveCellFont.Color = clWindowText
        ActiveCellFont.Height = -11
        ActiveCellFont.Name = 'Tahoma'
        ActiveCellFont.Style = [fsBold]
        ColumnSize.StretchColumn = 0
        ControlLook.FixedGradientHoverFrom = clGray
        ControlLook.FixedGradientHoverTo = clWhite
        ControlLook.FixedGradientDownFrom = clGray
        ControlLook.FixedGradientDownTo = clSilver
        ControlLook.DropDownHeader.Font.Charset = DEFAULT_CHARSET
        ControlLook.DropDownHeader.Font.Color = clWindowText
        ControlLook.DropDownHeader.Font.Height = -11
        ControlLook.DropDownHeader.Font.Name = 'Tahoma'
        ControlLook.DropDownHeader.Font.Style = []
        ControlLook.DropDownHeader.Visible = True
        ControlLook.DropDownHeader.Buttons = <>
        ControlLook.DropDownFooter.Font.Charset = DEFAULT_CHARSET
        ControlLook.DropDownFooter.Font.Color = clWindowText
        ControlLook.DropDownFooter.Font.Height = -11
        ControlLook.DropDownFooter.Font.Name = 'Tahoma'
        ControlLook.DropDownFooter.Font.Style = []
        ControlLook.DropDownFooter.Visible = True
        ControlLook.DropDownFooter.Buttons = <>
        EnhRowColMove = False
        Filter = <>
        FilterDropDown.Font.Charset = DEFAULT_CHARSET
        FilterDropDown.Font.Color = clWindowText
        FilterDropDown.Font.Height = -11
        FilterDropDown.Font.Name = 'Tahoma'
        FilterDropDown.Font.Style = []
        FilterDropDownClear = '(All)'
        FilterEdit.TypeNames.Strings = (
          'Starts with'
          'Ends with'
          'Contains'
          'Not contains'
          'Equal'
          'Not equal'
          'Clear')
        FixedColWidth = 150
        FixedRowHeight = 22
        FixedFont.Charset = DEFAULT_CHARSET
        FixedFont.Color = clWindowText
        FixedFont.Height = -11
        FixedFont.Name = 'Tahoma'
        FixedFont.Style = [fsBold]
        FloatFormat = '%.2f'
        HoverButtons.Buttons = <>
        HoverButtons.Position = hbLeftFromColumnLeft
        MouseActions.DisjunctRowSelect = True
        PrintSettings.DateFormat = 'dd/mm/yyyy'
        PrintSettings.Font.Charset = DEFAULT_CHARSET
        PrintSettings.Font.Color = clWindowText
        PrintSettings.Font.Height = -11
        PrintSettings.Font.Name = 'Tahoma'
        PrintSettings.Font.Style = []
        PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
        PrintSettings.FixedFont.Color = clWindowText
        PrintSettings.FixedFont.Height = -11
        PrintSettings.FixedFont.Name = 'Tahoma'
        PrintSettings.FixedFont.Style = []
        PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
        PrintSettings.HeaderFont.Color = clWindowText
        PrintSettings.HeaderFont.Height = -11
        PrintSettings.HeaderFont.Name = 'Tahoma'
        PrintSettings.HeaderFont.Style = []
        PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
        PrintSettings.FooterFont.Color = clWindowText
        PrintSettings.FooterFont.Height = -11
        PrintSettings.FooterFont.Name = 'Tahoma'
        PrintSettings.FooterFont.Style = []
        PrintSettings.PageNumSep = '/'
        SearchFooter.FindNextCaption = 'Find &next'
        SearchFooter.FindPrevCaption = 'Find &previous'
        SearchFooter.Font.Charset = DEFAULT_CHARSET
        SearchFooter.Font.Color = clWindowText
        SearchFooter.Font.Height = -11
        SearchFooter.Font.Name = 'Tahoma'
        SearchFooter.Font.Style = []
        SearchFooter.HighLightCaption = 'Highlight'
        SearchFooter.HintClose = 'Close'
        SearchFooter.HintFindNext = 'Find next occurrence'
        SearchFooter.HintFindPrev = 'Find previous occurrence'
        SearchFooter.HintHighlight = 'Highlight occurrences'
        SearchFooter.MatchCaseCaption = 'Match case'
        ShowDesignHelper = False
        SortSettings.DefaultFormat = ssAutomatic
        Version = '7.4.4.1'
        ColWidths = (
          150
          64
          64
          64
          274)
        RowHeights = (
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22)
      end
    end
  end
  object StatusBar1: TAdvOfficeStatusBar
    Left = 0
    Top = 286
    Width = 562
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
    ShowSplitter = True
    SimplePanel = False
    Version = '1.5.3.0'
  end
  object ImageList1: TImageList
    ColorDepth = cd32Bit
    Left = 384
    Top = 88
    Bitmap = {
      494C010102000500140010001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      000000000000000000000000000000000000000000004B677DFFBE9596FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000010101086B69
      69FF4D4B4CC42A292A900505053A131212607A7879F8757173FF666464F63635
      35B0090808440000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006C9CC3FF1F89E8FF4C7BA3FFC896
      93FF000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000404042A6A6868FFA9A6
      A7FF9F9C9DFF908C8EFF848182FF6D6B6BFFCACACBFFD8D9D9FFA4A1A3FF8281
      81FF6F6D6DFF6C6A6AFF0D0C0C4D000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004CB4FEFF52B5FFFF2189E9FF4C7B
      A2FFC69592FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000505052B6A6868FFBBBABAFFD5D4
      D4FFA19F9FFFA3A0A0FF979595FF010101FF282828FF6D6D6DFFC1C1C1FFD1D1
      D1FFCCCBCCFFB0AFAFFF989697FF7E7B7CFB0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000052B7FEFF52B3FFFF1E87
      E6FF4F7BA0FFCA9792FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000006B6969FFC2C1C2FFCFCECEFF8F8B
      8CFF868283FF878384FF818080FF575555FF302E2FFF171717FF010101FF2727
      27FF6D6D6DFFC0C1C1FF959293FF5A5859D40000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000052B7FEFF4FB2
      FFFF2089E6FF4F7CA2FFB99497FF000000000000000000000000000000000000
      0000000000000000000000000000000000006B6969FFC9C9C9FF918F90FFD1CF
      D0FFEFEEEEFFDAD8D8FFC4C2C2FFB1AFAFFFA09C9EFF989596FF8E8A8BFF4C4A
      4BFF1E1D1EFF010101FF8E8A8BFF6C6A6AFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000053B8
      FEFF4CB1FFFF2887D9FF606B77FF060505305E4341C1936A67EFA17270FE9168
      65EF201515720605053000000000000000006B6969FF9A9899FFE2E1E1FFFAFA
      FAFFF8F8F8FFEEEDEDFFF2F0F0FFEDEBEBFFE2E2E2FFC9C9C7FFB7B6B6FFA5A3
      A3FF929090FF7B7879FF999797FF6C6A6AFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000056BDFFFFB5D6EDFF3327258B936A66EFCCB1A2FFF0E8D0FFFDFCE3FFEEE4
      C9FFC2A298FF906764EF0E0A0A4A000000006B6969FFEEEDEDFFFCFBFBFFFBFA
      FAFFF2F0F0FFA7A3A4FF817A7BFF999293FFAFAAABFFD3D4D4FFDCDCDCFFD7D7
      D7FFC2C1C1FFB1AFAFFF8F8C8CFF6C6A6AFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000006050530976E69EFF1DDB3FFFFFFD8FFFFFFDAFFFFFFDBFFFFFF
      E6FFFFFFFBFFE0CECDFF8E6362EF06050530353535A3696767FFBABABAF1CBC7
      C7EF66575BFF776B6DFF9A9697FFADA9ABFFA6A1A1FF918A8BFF938B8CFF9F9A
      9CFFCBCBCBFFCECECEFFB2B1B1FF6B6969FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000020151572B38C82FFFBDCA8FFFEF7D0FFFFFFDBFFFFFFE3FFFFFF
      F8FFFFFFFDFFFFFFFDFFB69189FF20151572000000000808083B696868FF8E81
      81FFBC977CFF866555FF583F3BFF463439FF615255FF837A7EFFA39E9FFFA9A5
      A7FFCCCCCCFFABA9AAFF797677F70505052B0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000936A66EFEFD0A2FFF1C491FFFCF2CAFFFFFFDDFFFFFFE4FFFFFF
      F7FFFFFFF7FFFFFFE9FFE1D2BCFF906765EF000000000000000000000000BE8C
      83F3FFDCB4FFFFD5A6FFFFCF9AFFE7B080FFAF805EFF634640FF605355FFBCBB
      BBFF989697FF4C4B4BC401010109000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A2736FFEFDE3ADFFEEB581FFF7DCAEFFFEFDD8FFFFFFDFFFFFFF
      E3FFFFFFE4FFFFFFE0FFF1E9D0FFA0706FFE000000000000000000000000D7A5
      9AFFFFE0BFFFFFD8B0FFFFD1A1FFFFCC96FFFFC68AFFD9A082FF3632329E2121
      21801312125F0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000916865EFEDD4ABFFF4C791FFF2C994FFF8E5B9FFFEFCD8FFFFFF
      DDFFFFFFDCFFFFFFE0FFD7C2ADFF906563EF00000000000000000B08083BE2BA
      ADFFFFE6C9FFFFDCBAFFFFD5ACFFFFD09FFFFFCB92FFD39683FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000020151572C3A291FFFFFEE5FFF7DCB8FFF2C994FFF5D4A5FFFAE8
      BDFFFDF4C9FFFDFBD6FFAC817EFF2015157200000000000000003C29298FF3DC
      CFFFFFEAD3FFFFE2C4FFFFDAB7FFFFD5AAFFFFD09EFF5F4240B2000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000006050530906764EFDECFCEFFFFFEF2FFF9D8A3FFF4C48CFFF9D4
      9FFFFDEAB8FFC9AA98FF916864EF060505300000000001010109BC8D8DF6FFFA
      F0FFFFF0E0FFFFE9D0FFFFE2C2FFFFDCB6FFE7B599FF1B13135F000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000E0A0A4A8E6362EFB8928AFFE2CEABFFEDDDB1FFDCBF
      A2FFAD817CFF916864EF0E0A0A4A0000000000000000815857D2C99592FFE1C0
      BDFFEED5CEFFFCEAD9FFFFEACFFFFEDDBDFF875F5CD500000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000605053020151572916864EFA0716EFE9066
      63EF20151572060505300000000000000000000000002318186C5E4140B38057
      57D2B07977F6BD8181FFBF8482FFC08784FF0A07073700000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
  object OpenDialog1: TOpenDialog
    Left = 344
    Top = 88
  end
  object SaveDialog1: TSaveDialog
    Left = 416
    Top = 88
  end
  object PopupMenu1: TPopupMenu
    Left = 232
    Top = 80
    object DeleteSelectedRow1: TMenuItem
      Caption = 'Delete Selected Row'
      OnClick = DeleteSelectedRow1Click
    end
  end
end
