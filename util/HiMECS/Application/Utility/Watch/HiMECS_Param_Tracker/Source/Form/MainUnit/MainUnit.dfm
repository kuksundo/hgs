object Main_Frm: TMain_Frm
  Left = 0
  Top = 0
  Caption = 'HiMECS_'
  ClientHeight = 758
  ClientWidth = 1065
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object AdvOfficeStatusBar1: TAdvOfficeStatusBar
    Left = 0
    Top = 739
    Width = 1065
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
    SimplePanel = False
    URLColor = clBlue
    Version = '1.3.0.3'
  end
  object NxHeaderPanel1: TNxHeaderPanel
    Left = 0
    Top = 0
    Width = 1065
    Height = 739
    Align = alClient
    Caption = 'Parameter Tracker'
    HeaderFont.Charset = ANSI_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -16
    HeaderFont.Name = #47569#51008' '#44256#46357
    HeaderFont.Style = [fsBold, fsItalic]
    HeaderSize = 36
    InnerMargins.Left = 2
    InnerMargins.Top = 2
    InnerMargins.Bottom = 2
    InnerMargins.Right = 2
    ParentHeaderFont = False
    TabOrder = 1
    FullWidth = 1065
    object NxSplitter1: TNxSplitter
      Left = 2
      Top = 428
      Width = 1059
      Height = 6
      Cursor = crVSplit
      Align = alBottom
      ExplicitLeft = 9
      ExplicitTop = 441
      ExplicitWidth = 1046
    end
    object NxFlipPanel1: TNxFlipPanel
      Left = 2
      Top = 434
      Width = 1059
      Height = 301
      Align = alBottom
      Caption = 'Parameter Values'
      CollapseGlyph.Data = {
        7A010000424D7A01000000000000360000002800000009000000090000000100
        2000000000004401000000000000000000000000000000000000604830406048
        30FF604830FF604830FF604830FF604830FF604830FF604830FF60483040C0A8
        90FFFFF0E0FFE0D0C0FFE0C8B0FFE0C0B0FFD0B8A0FFD0B8A0FFD0B8A0FF6048
        30FFC0A890FFFFF8F0FFFFF0E0FFF0E0E0FFF0D8D0FFF0D8C0FFF0D0C0FFD0B8
        A0FF604830FFC0A890FFFFF8FFFFFFF8F0FFFFF0E0FFF0E0E0FFF0D8D0FFF0D0
        C0FFD0B8A0FF604830FFC0A8A0FFFFFFFFFF604830FF604830FF604830FF6048
        30FF604830FFE0C0B0FF604830FFC0A8A0FFFFFFFFFFFFFFFFFFFFF8FFFFFFF0
        F0FFFFF0E0FFF0E8E0FFE0C0B0FF604830FFC0B0A0FFFFFFFFFFFFFFFFFFFFFF
        FFFFFFF8FFFFFFF0F0FFFFF0E0FFE0D0C0FF604830FFC0B0A0FFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFF8FFFFFFF0F0FFF0F0E0FF604830FFC0B0A040C0B0
        A0FFC0B0A0FFC0A8A0FFC0A8A0FFC0A8A0FFC0A890FFC0A090FF60483040}
      ExpandGlyph.Data = {
        7A010000424D7A01000000000000360000002800000009000000090000000100
        2000000000004401000000000000000000000000000000000000604830406048
        30FF604830FF604830FF604830FF604830FF604830FF604830FF60483040C0A8
        90FFFFF0E0FFE0D0C0FFE0C8B0FFE0C0B0FFD0B8A0FFD0B8A0FFD0B8A0FF6048
        30FFC0A890FFFFF8F0FFFFF0E0FFF0E0E0FF604830FFF0D8C0FFF0D0C0FFD0B8
        A0FF604830FFC0A890FFFFF8FFFFFFF8F0FFFFF0E0FF604830FFF0D8D0FFF0D0
        C0FFD0B8A0FF604830FFC0A8A0FFFFFFFFFF604830FF604830FF604830FF6048
        30FF604830FFE0C0B0FF604830FFC0A8A0FFFFFFFFFFFFFFFFFFFFF8FFFF6048
        30FFFFF0E0FFF0E8E0FFE0C0B0FF604830FFC0B0A0FFFFFFFFFFFFFFFFFFFFFF
        FFFF604830FFFFF0F0FFFFF0E0FFE0D0C0FF604830FFC0B0A0FFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFF8FFFFFFF0F0FFF0F0E0FF604830FFC0B0A040C0B0
        A0FFC0B0A0FFC0A8A0FFC0A8A0FFC0A8A0FFC0A890FFC0A090FF60483040}
      HeaderFont.Charset = DEFAULT_CHARSET
      HeaderFont.Color = clWindowText
      HeaderFont.Height = -11
      HeaderFont.Name = 'Tahoma'
      HeaderFont.Style = []
      HeaderHeight = 23
      InnerMargins.Left = 3
      InnerMargins.Top = 3
      InnerMargins.Bottom = 3
      InnerMargins.Right = 3
      FullHeight = 0
      object AdvStringGrid1: TAdvStringGrid
        Left = 808
        Top = 26
        Width = 248
        Height = 272
        Cursor = crDefault
        Align = alRight
        DrawingStyle = gdsClassic
        ScrollBars = ssBoth
        TabOrder = 0
        ActiveCellFont.Charset = DEFAULT_CHARSET
        ActiveCellFont.Color = clWindowText
        ActiveCellFont.Height = -11
        ActiveCellFont.Name = 'Tahoma'
        ActiveCellFont.Style = [fsBold]
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
        Filter = <>
        FilterDropDown.Font.Charset = DEFAULT_CHARSET
        FilterDropDown.Font.Color = clWindowText
        FilterDropDown.Font.Height = -11
        FilterDropDown.Font.Name = 'Tahoma'
        FilterDropDown.Font.Style = []
        FilterDropDownClear = '(All)'
        FixedRowHeight = 22
        FixedFont.Charset = DEFAULT_CHARSET
        FixedFont.Color = clWindowText
        FixedFont.Height = -11
        FixedFont.Name = 'Tahoma'
        FixedFont.Style = [fsBold]
        FloatFormat = '%.2f'
        Navigation.AllowClipboardShortCuts = True
        Navigation.AllowClipboardAlways = True
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
        Version = '5.7.0.1'
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
      object NxPanel1: TNxPanel
        Left = 3
        Top = 26
        Width = 805
        Height = 272
        Align = alClient
        Caption = 'NxPanel1'
        UseDockManager = False
        TabOrder = 1
        object NxPanel2: TNxPanel
          Left = 0
          Top = 237
          Width = 805
          Height = 35
          Align = alBottom
          UseDockManager = False
          InnerMargins.Left = 3
          InnerMargins.Top = 3
          InnerMargins.Bottom = 3
          InnerMargins.Right = 3
          TabOrder = 0
          object Button1: TButton
            Left = 725
            Top = 3
            Width = 77
            Height = 29
            Align = alRight
            Caption = 'Button1'
            TabOrder = 0
            OnClick = Button1Click
          end
        end
        object ValuesGrid: TNextGrid
          Left = 0
          Top = 0
          Width = 805
          Height = 237
          Align = alClient
          HeaderSize = 20
          HeaderStyle = hsOffice2007
          TabOrder = 1
          TabStop = True
          OnChange = ValuesGridChange
          object NxIncrementColumn1: TNxIncrementColumn
            DefaultWidth = 39
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            Header.Caption = 'No.'
            ParentFont = False
            Position = 0
            SortType = stAlphabetic
            Width = 39
          end
          object NxCheckBoxColumn1: TNxCheckBoxColumn
            DefaultWidth = 44
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            Header.Caption = 'Check'
            ParentFont = False
            Position = 1
            SortType = stBoolean
            Width = 44
          end
          object NxTextColumn1: TNxTextColumn
            DefaultWidth = 93
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            Header.Caption = 'Name'
            ParentFont = False
            Position = 2
            SortType = stAlphabetic
            Width = 93
          end
          object NxTextColumn2: TNxTextColumn
            DefaultWidth = 447
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            Header.Caption = 'Description'
            Header.Alignment = taCenter
            Options = [coAutoSize, coCanClick, coCanInput, coCanSort, coPublicUsing, coShowTextFitHint]
            ParentFont = False
            Position = 3
            SortType = stAlphabetic
            Width = 447
          end
          object NxNumberColumn1: TNxNumberColumn
            Alignment = taCenter
            DefaultValue = '0'
            DefaultWidth = 90
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            Header.Caption = 'Values'
            ParentFont = False
            Position = 4
            SortType = stNumeric
            Width = 90
            Increment = 1.000000000000000000
            Precision = 0
          end
          object NxTextColumn3: TNxTextColumn
            Alignment = taCenter
            DefaultWidth = 90
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            Header.Caption = 'Current Location'
            ParentFont = False
            Position = 5
            SortType = stAlphabetic
            Width = 90
          end
        end
      end
    end
    object iPlot1: TiPlot
      Left = 2
      Top = 38
      Width = 1059
      Height = 390
      OnClick = iPlot1Click
      DataViewZHorz = 1
      DataViewZVert = 1
      PrintMarginLeft = 1.000000000000000000
      PrintMarginTop = 1.000000000000000000
      PrintMarginRight = 1.000000000000000000
      PrintMarginBottom = 1.000000000000000000
      PrintDocumentName = 'Untitled'
      HintsFont.Charset = DEFAULT_CHARSET
      HintsFont.Color = clWindowText
      HintsFont.Height = -11
      HintsFont.Name = 'Tahoma'
      HintsFont.Style = []
      EditorFormStyle = ipfsModal
      CopyToClipBoardFormat = ipefMetaFile
      TitleText = 'Untitled'
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWhite
      TitleFont.Height = -19
      TitleFont.Name = 'Arial'
      TitleFont.Style = [fsBold]
      AnnotationDefaultFont.Charset = DEFAULT_CHARSET
      AnnotationDefaultFont.Color = clWhite
      AnnotationDefaultFont.Height = -11
      AnnotationDefaultFont.Name = 'Tahoma'
      AnnotationDefaultFont.Style = []
      AnnotationDefaultBrushStlye = bsSolid
      AnnotationDefaultBrushColor = clWhite
      AnnotationDefaultPenStlye = psSolid
      AnnotationDefaultPenColor = clWhite
      AnnotationDefaultPenWidth = 1
      AnnotationDefaultReference = iprtDataView
      AnnotationDefaultReferencePositionX = ipriAuto
      AnnotationDefaultReferencePositionY = ipriAuto
      AnnotationDefaultReferenceSizeX = ipriAuto
      AnnotationDefaultReferenceSizeY = ipriAuto
      ClipAnnotationsToAxes = True
      BackGroundGradientEnabled = False
      BackGroundGradientDirection = ifdTopBottom
      BackGroundGradientStartColor = clBlue
      BackGroundGradientStopColor = clBlack
      DataFileColumnSeparator = ipdfcsTab
      DataFileFormat = ipdffText
      DefaultSaveImageFormat = ipifBitmap
      Align = alClient
      TabOrder = 1
      DataViewZHorz = 1
      DataViewZVert = 1
      ToolBarManager = <
        item
          Name = 'Toolbar 1'
          Horizontal = True
          ZOrder = 3
          StopPercent = 100.000000000000000000
          ZoomInOutFactor = 2.000000000000000000
        end>
      LegendManager = <
        item
          Name = 'Legend 1'
          Horizontal = False
          ZOrder = 2
          StopPercent = 100.000000000000000000
          MarginLeft = 1.000000000000000000
          MarginTop = 1.000000000000000000
          MarginRight = 1.000000000000000000
          MarginBottom = 1.000000000000000000
          SelectedItemFont.Charset = DEFAULT_CHARSET
          SelectedItemFont.Color = clBlack
          SelectedItemFont.Height = -11
          SelectedItemFont.Name = 'Tahoma'
          SelectedItemFont.Style = []
          CaptionColumnTitle = 'Title'
          CaptionColumnXAxisTitle = 'X-Axis'
          CaptionColumnYAxisTitle = 'Y-Axis'
          CaptionColumnXValue = 'X'
          CaptionColumnYValue = 'Y'
          CaptionColumnYMax = 'Y-Max'
          CaptionColumnYMin = 'Y-Min'
          CaptionColumnYMean = 'Y-Mean'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ColumnSpacing = 0.500000000000000000
          RowSpacing = 0.250000000000000000
          WrapColDesiredCount = 1
          WrapColAutoCountEnabled = False
          WrapColAutoCountMax = 100
          WrapColSpacingMin = 2.000000000000000000
          WrapColSpacingAuto = True
          WrapRowDesiredCount = 5
          WrapRowAutoCountEnabled = True
          WrapRowAutoCountMax = 100
          WrapRowSpacingMin = 0.250000000000000000
          WrapRowSpacingAuto = False
          ColumnTitlesFont.Charset = DEFAULT_CHARSET
          ColumnTitlesFont.Color = clAqua
          ColumnTitlesFont.Height = -11
          ColumnTitlesFont.Name = 'Tahoma'
          ColumnTitlesFont.Style = [fsBold]
          LineColumnHeight = 3
        end>
      XAxisManager = <
        item
          Name = 'X-Axis 1'
          Horizontal = True
          ZOrder = 0
          StopPercent = 100.000000000000000000
          Span = 0.000100000000000000
          Title = 'X-Axis 1'
          TitleMargin = 0.250000000000000000
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWhite
          TitleFont.Height = -13
          TitleFont.Name = 'Arial'
          TitleFont.Style = [fsBold]
          LabelsMargin = 0.250000000000000000
          LabelsFont.Charset = DEFAULT_CHARSET
          LabelsFont.Color = clWhite
          LabelsFont.Height = -11
          LabelsFont.Name = 'Tahoma'
          LabelsFont.Style = []
          LabelSeparation = 2.000000000000000000
          LabelsRotation = ira000
          LabelsFormatStyle = iptfDateTime
          DateTimeFormat = 'hh:nn:ss'
          LabelsMinLength = 5.000000000000000000
          ScaleLineShow = True
          StackingEndsMargin = 0.500000000000000000
          TrackingStyle = iptsScrollSmooth
          TrackingIncrementStyle = iptisMinimum
          TrackingAlignFirstStyle = ipafsAuto
          CursorDateTimeFormat = 'hh:nn:ss'
          CursorPrecision = 3
          CursorMinLength = 5.000000000000000000
          LegendDateTimeFormat = 'hh:nn:ss'
          LegendPrecision = 3
          LegendMinLength = 5.000000000000000000
          CursorScaler = 1.000000000000000000
          ScrollMinMaxEnabled = False
          ScrollMax = 100.000000000000000000
          RestoreValuesOnResume = True
          MasterUIInput = False
          CartesianStyle = ipcsNone
          CartesianChildRefAxisName = '<None>'
          AlignRefAxisName = '<None>'
          GridLinesVisible = True
          ForceStacking = False
        end>
      YAxisManager = <
        item
          Name = 'Y-Axis 1'
          Horizontal = False
          ZOrder = 0
          StopPercent = 100.000000000000000000
          Span = 0.100000000000000000
          Title = 'Y-Axis 1'
          TitleMargin = 0.250000000000000000
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWhite
          TitleFont.Height = -13
          TitleFont.Name = 'Arial'
          TitleFont.Style = [fsBold]
          LabelsMargin = 0.250000000000000000
          LabelsFont.Charset = DEFAULT_CHARSET
          LabelsFont.Color = clWhite
          LabelsFont.Height = -11
          LabelsFont.Name = 'Tahoma'
          LabelsFont.Style = []
          LabelSeparation = 2.000000000000000000
          LabelsRotation = ira000
          DateTimeFormat = 'hh:nn:ss'
          LabelsMinLength = 5.000000000000000000
          ScaleLineShow = True
          StackingEndsMargin = 0.500000000000000000
          TrackingStyle = iptsScaleMinMax
          TrackingIncrementStyle = iptisMinimum
          TrackingAlignFirstStyle = ipafsNone
          CursorDateTimeFormat = 'hh:nn:ss'
          CursorPrecision = 3
          CursorMinLength = 5.000000000000000000
          LegendDateTimeFormat = 'hh:nn:ss'
          LegendPrecision = 3
          LegendMinLength = 5.000000000000000000
          CursorScaler = 1.000000000000000000
          ScrollMinMaxEnabled = False
          ScrollMax = 100.000000000000000000
          RestoreValuesOnResume = True
          MasterUIInput = False
          CartesianStyle = ipcsNone
          CartesianChildRefAxisName = '<None>'
          AlignRefAxisName = '<None>'
          GridLinesVisible = True
          ForceStacking = False
        end>
      ChannelManager = <
        item
          Name = 'Channel 1'
          TitleText = 'Channel 1'
          MarkersTurnOffLimit = 0
          MarkersFont.Charset = DEFAULT_CHARSET
          MarkersFont.Color = clWhite
          MarkersFont.Height = -11
          MarkersFont.Name = 'Tahoma'
          MarkersFont.Style = [fsBold]
          YAxisName = 'Y-Axis 1'
          DataStyle = ipdsStandard
          DigitalReferenceLow = 10.000000000000000000
          DigitalReferenceHigh = 90.000000000000000000
          HighLowBarColor = clAqua
          HighLowBarWidth = 0.500000000000000000
          HighLowOpenColor = clLime
          HighLowOpenWidth = 1.000000000000000000
          HighLowOpenHeight = 1.000000000000000000
          HighLowCloseWidth = 1.000000000000000000
          HighLowCloseHeight = 1.000000000000000000
          BarWidth = 5.000000000000000000
          OPCComputerName = 'Local'
        end>
      DataViewManager = <
        item
          Name = 'Data View 1'
          Horizontal = False
          ZOrder = 0
          StopPercent = 100.000000000000000000
          GridXAxisName = 'X-Axis 1'
          GridYAxisName = 'Y-Axis 1'
          AxesControlEnabled = False
          AxesControlMouseStyle = ipacsBoth
          AxesControlWheelStyle = ipacsXAxis
        end>
      DataCursorManager = <
        item
          Name = 'Cursor 1'
          Visible = False
          ChannelName = '<All>'
          ChannelAllowAll = True
          ChannelShowAllInLegend = True
          Style = ipcsValueXY
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Color = clYellow
          UseChannelColor = True
          HintShow = True
          HintHideOnRelease = False
          HintOrientationSide = iosBottomRight
          HintPosition = 50.000000000000000000
          Pointer1Position = 50.000000000000000000
          Pointer2Position = 60.000000000000000000
          PointerPenWidth = 1
          MenuItemVisibleValueXY = True
          MenuItemVisibleValueX = True
          MenuItemVisibleValueY = True
          MenuItemVisibleDeltaX = True
          MenuItemVisibleDeltaY = True
          MenuItemVisibleInverseDeltaX = True
          MenuItemCaptionValueXY = 'Value X-Y'
          MenuItemCaptionValueX = 'Value X'
          MenuItemCaptionValueY = 'Value Y'
          MenuItemCaptionDeltaX = 'Period'
          MenuItemCaptionDeltaY = 'Peak-Peak'
          MenuItemCaptionInverseDeltaX = 'Frequency'
        end>
      LabelManager = <
        item
          Name = 'Title'
          Horizontal = True
          ZOrder = 2
          StopPercent = 100.000000000000000000
          Caption = 'Untitled'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -19
          Font.Name = 'Arial'
          Font.Style = [fsBold]
        end>
    end
  end
  object MainMenu1: TMainMenu
    Left = 824
    Top = 65528
    object File1: TMenuItem
      Caption = 'File'
      object Close1: TMenuItem
        Caption = 'Close'
      end
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer1Timer
    Left = 784
    Top = 65528
  end
end
