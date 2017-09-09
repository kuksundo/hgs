object WatchF2: TWatchF2
  Left = 549
  Top = 250
  Caption = 'Multi-Watch'
  ClientHeight = 427
  ClientWidth = 578
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inline TFrameIPCMonitorAll1: TFrameIPCMonitorAll
    Left = 0
    Top = 0
    Width = 578
    Height = 427
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 578
    ExplicitHeight = 427
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 578
    Height = 427
    ActivePage = TabSheet5
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object TabSheet5: TTabSheet
      Caption = 'Items'
      ImageIndex = 4
      PopupMenu = PopupMenu1
      object NextGrid1: TNextGrid
        Left = 0
        Top = 0
        Width = 570
        Height = 356
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        Options = [goGrid, goHeader, goIndicator, goMultiSelect, goSelectFullRow]
        ParentFont = False
        TabOrder = 0
        TabStop = True
        OnCustomDrawCell = NextGrid1CustomDrawCell
        OnDblClick = NextGrid1DblClick
        OnKeyDown = NextGrid1KeyDown
        OnMouseDown = NextGrid1MouseDown
        OnRowMove = NextGrid1RowMove
        object NxImageColumn1: TNxImageColumn
          DefaultValue = '0'
          DefaultWidth = 20
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          Header.Caption = 'S'
          Header.Hint = 'Simple Display'
          Header.Alignment = taCenter
          Options = [coCanClick, coCanInput, coPublicUsing]
          ParentFont = False
          Position = 0
          SortType = stNumeric
          Width = 20
          Images = ImageList1
        end
        object NxImageColumn2: TNxImageColumn
          DefaultValue = '0'
          DefaultWidth = 20
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          Header.Caption = 'T'
          Header.Hint = 'Trend Display'
          Header.Alignment = taCenter
          Options = [coCanClick, coCanInput, coPublicUsing]
          ParentFont = False
          Position = 1
          SortType = stNumeric
          Width = 20
          Images = ImageList1
        end
        object ItemName: TNxTextColumn
          DefaultWidth = 200
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          Header.Caption = 'Item Name'
          Options = [coCanClick, coCanInput, coPublicUsing, coShowTextFitHint]
          ParentFont = False
          Position = 2
          SortType = stAlphabetic
          Width = 200
        end
        object Value: TNxTextColumn
          Alignment = taCenter
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          Header.Caption = 'Value'
          Header.Alignment = taCenter
          Options = [coCanClick, coCanInput, coPublicUsing, coShowTextFitHint]
          ParentFont = False
          Position = 3
          SortType = stAlphabetic
        end
        object FUnit: TNxTextColumn
          Alignment = taCenter
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          Header.Caption = 'Unit'
          Header.Alignment = taCenter
          Options = [coCanClick, coCanInput, coPublicUsing, coShowTextFitHint]
          ParentFont = False
          Position = 4
          SortType = stAlphabetic
        end
        object NxImageColumn3: TNxImageColumn
          DefaultValue = '0'
          DefaultWidth = 25
          Header.Caption = 'XY'
          Header.Hint = 'XY Graph Display'
          Options = [coCanClick, coCanInput, coPublicUsing]
          Position = 5
          SortType = stNumeric
          Width = 25
          Images = ImageList1
        end
        object NxImageColumn4: TNxImageColumn
          DefaultValue = '0'
          DefaultWidth = 20
          Header.Caption = 'A'
          Header.Hint = 'Alarm Display'
          Options = [coCanClick, coCanInput, coPublicUsing]
          Position = 6
          SortType = stNumeric
          Width = 20
        end
        object NxCheckBoxColumn2: TNxCheckBoxColumn
          Header.Hint = 'For copy selection on xy graph'
          Options = [coCanClick, coCanInput, coPublicUsing]
          Position = 7
          SortType = stBoolean
          Visible = False
        end
      end
      object JvStatusBar1: TJvStatusBar
        Left = 0
        Top = 356
        Width = 570
        Height = 43
        Panels = <
          item
            Width = 70
            Control = SaveListCB
          end
          item
            Alignment = taCenter
            Width = 100
            Control = AllowUserlevelCB
            MarginLeft = 1
            MarginTop = 12
          end
          item
            Width = 100
            Control = StayOnTopCB
          end
          item
            Width = 50
          end>
        OnClick = JvStatusBar1Click
        object Label4: TLabel
          Left = 310
          Top = 15
          Width = 77
          Height = 16
          Caption = 'AlphaBlend:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object SaveListCB: TCheckBox
          Left = 3
          Top = 3
          Width = 64
          Height = 39
          Caption = 'Save by'
          TabOrder = 0
        end
        object EnableAlphaCB: TCheckBox
          Left = 388
          Top = 14
          Width = 18
          Height = 17
          TabOrder = 1
          OnClick = EnableAlphaCBClick
        end
        object JvTrackBar1: TJvTrackBar
          Left = 403
          Top = 6
          Width = 150
          Height = 27
          Max = 255
          Position = 255
          TabOrder = 2
          OnChange = JvTrackBar1Change
          ShowRange = False
        end
        object StayOnTopCB: TCheckBox
          Left = 173
          Top = 3
          Width = 100
          Height = 39
          Caption = 'Stay On Top'
          TabOrder = 3
          OnClick = StayOnTopCBClick
        end
        object AllowUserlevelCB: TComboBox
          Left = 71
          Top = 12
          Width = 96
          Height = 20
          Hint = 'Allow user level for open the watch list file when start'
          Enabled = False
          ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
          TabOrder = 4
        end
      end
    end
    object SimpleTabSheet: TTabSheet
      Caption = 'Simple'
      PopupMenu = PopupMenu1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object DisplayPanel: TPanel
        Left = 0
        Top = 0
        Width = 570
        Height = 320
        Align = alClient
        Color = clBlack
        ParentBackground = False
        TabOrder = 0
        DesignSize = (
          570
          323)
        object Label1: TLabel
          Left = 8
          Top = 8
          Width = 391
          Height = 33
          Caption = '11111111111111111111111'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWhite
          Font.Height = -27
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object WatchLabel: TLabel
          Left = 409
          Top = 128
          Width = 147
          Height = 112
          Alignment = taRightJustify
          Anchors = [akRight]
          Caption = '0.0'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWhite
          Font.Height = -93
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
          ExplicitLeft = 348
          ExplicitTop = 67
        end
      end
      object AvgPanel: TPanel
        Left = 0
        Top = 323
        Width = 570
        Height = 76
        Align = alBottom
        Color = clBlack
        ParentBackground = False
        TabOrder = 1
        Visible = False
        ExplicitTop = 320
        DesignSize = (
          570
          76)
        object Label2: TLabel
          Left = 16
          Top = 12
          Width = 132
          Height = 39
          Anchors = [akLeft]
          Caption = 'Average'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWhite
          Font.Height = -32
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object AvgLabel: TLabel
          Left = 431
          Top = 2
          Width = 107
          Height = 81
          Alignment = taRightJustify
          Anchors = [akRight]
          Caption = '0.0'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWhite
          Font.Height = -67
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
          ExplicitLeft = 307
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Min/Max'
      ImageIndex = 1
      PopupMenu = PopupMenu1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 570
        Height = 399
        Align = alClient
        Color = clBlack
        ParentBackground = False
        TabOrder = 0
        DesignSize = (
          570
          399)
        object Label3: TLabel
          Left = 8
          Top = 0
          Width = 240
          Height = 39
          Caption = '111111111111'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWhite
          Font.Height = -32
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object CurLabel: TLabel
          Left = 442
          Top = 155
          Width = 107
          Height = 81
          Anchors = [akRight]
          Caption = '0.0'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWhite
          Font.Height = -67
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
          ExplicitLeft = 311
          ExplicitTop = 67
        end
        object Label5: TLabel
          Left = 8
          Top = 87
          Width = 66
          Height = 33
          Anchors = [akLeft]
          Caption = 'Max:'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWhite
          Font.Height = -27
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          ExplicitTop = 59
        end
        object Label6: TLabel
          Left = 8
          Top = 185
          Width = 133
          Height = 39
          Anchors = [akLeft]
          Caption = 'Current:'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWhite
          Font.Height = -32
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          ExplicitTop = 94
        end
        object Label7: TLabel
          Left = 8
          Top = 264
          Width = 59
          Height = 33
          Anchors = [akLeft]
          Caption = 'Min:'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWhite
          Font.Height = -27
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          ExplicitTop = 139
        end
        object MinLabel: TLabel
          Left = 442
          Top = 269
          Width = 63
          Height = 48
          Anchors = [akRight]
          Caption = '0.0'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWhite
          Font.Height = -40
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
          ExplicitLeft = 311
          ExplicitTop = 137
        end
        object MaxLabel: TLabel
          Left = 442
          Top = 74
          Width = 63
          Height = 48
          Anchors = [akRight]
          Caption = '0.0'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWhite
          Font.Height = -40
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
          ExplicitLeft = 364
          ExplicitTop = 48
        end
        object Button1: TButton
          Left = 484
          Top = 362
          Width = 65
          Height = 25
          Anchors = [akRight, akBottom]
          Caption = 'Reset'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = #44404#47548#52404
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = Button1Click
        end
      end
    end
    object TrendTabSheet: TTabSheet
      Caption = 'Trend'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 27
      ExplicitWidth = 0
      ExplicitHeight = 396
      object iPlot1: TiPlot
        Left = 0
        Top = 0
        Width = 570
        Height = 399
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
        EditorFormStyle = ipfsStayOnTop
        CopyToClipBoardFormat = ipefMetaFile
        TitleText = 'Untitled'
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWhite
        TitleFont.Height = -19
        TitleFont.Name = 'Arial'
        TitleFont.Style = [fsBold]
        OnToolBarButtonClick = iPlot1ToolBarButtonClick
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
        DataFileColumnSeparator = ipdfcsComma
        DataFileFormat = ipdffText
        DefaultSaveImageFormat = ipifBitmap
        Align = alClient
        TabOrder = 0
        DataViewZHorz = 1
        DataViewZVert = 1
        ToolBarManager = <
          item
            Name = 'Toolbar 1'
            Horizontal = True
            ZOrder = 3
            StopPercent = 100.000000000000000000
            ShowSaveButton = False
            ShowPrintButton = False
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
        LimitManager = <
          item
            Name = 'Limit 1'
            Color = clRed
            LineStyle = psSolid
            LineWidth = 0
            FillStyle = bsSolid
            XAxisName = 'X-Axis 1'
            YAxisName = 'Y-Axis 1'
            Style = iplsLineY
            Line1Position = 50.000000000000000000
            Line2Position = 50.000000000000000000
            UserCanMove = False
            SelectModeOnlyInteraction = True
            ClipToAxes = False
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
        ExplicitHeight = 396
      end
      object Button2: TButton
        Left = 379
        Top = 10
        Width = 46
        Height = 25
        Caption = 'Start'
        TabOrder = 1
        OnClick = Button2Click
      end
      object Button3: TButton
        Left = 431
        Top = 10
        Width = 50
        Height = 25
        Caption = 'Stop'
        TabOrder = 2
        OnClick = Button3Click
      end
    end
    object XYGraphTabSheet: TTabSheet
      Caption = 'XY Graph'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object iXYPlot1: TiXYPlot
        Left = 0
        Top = 0
        Width = 570
        Height = 399
        DataViewZHorz = 0
        DataViewZVert = 0
        UserCanAddRemoveChannels = True
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
        TitleVisible = False
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
        TabOrder = 0
        DataViewZHorz = 0
        DataViewZVert = 0
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
            ZOrder = 1
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
            Span = 100.000000000000000000
            Title = 'X-Axis 1'
            TitleMargin = 0.250000000000000000
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWhite
            TitleFont.Height = -13
            TitleFont.Name = 'Arial'
            TitleFont.Style = [fsBold]
            TitleShow = True
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
            Span = 100.000000000000000000
            Title = 'Y-Axis 1'
            TitleMargin = 0.250000000000000000
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWhite
            TitleFont.Height = -13
            TitleFont.Name = 'Arial'
            TitleFont.Style = [fsBold]
            TitleShow = True
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
            VisibleInLegend = False
            MarkersTurnOffLimit = 0
            MarkersFont.Charset = DEFAULT_CHARSET
            MarkersFont.Color = clWhite
            MarkersFont.Height = -11
            MarkersFont.Name = 'Tahoma'
            MarkersFont.Style = [fsBold]
            XAxisName = 'X-Axis 1'
            YAxisName = 'Y-Axis 1'
            DataStyle = ipdsStandard
            OPCComputerName = 'Local'
          end
          item
            Name = 'Channel 2'
            TitleText = 'Channel 2'
            VisibleInLegend = False
            Color = clYellow
            MarkersTurnOffLimit = 0
            MarkersFont.Charset = DEFAULT_CHARSET
            MarkersFont.Color = clWhite
            MarkersFont.Height = -11
            MarkersFont.Name = 'Tahoma'
            MarkersFont.Style = [fsBold]
            XAxisName = 'X-Axis 1'
            YAxisName = 'Y-Axis 1'
            DataStyle = ipdsStandard
            OPCComputerName = 'Local'
          end
          item
            Name = 'Channel 3'
            TitleText = 'Channel 3'
            VisibleInLegend = False
            Color = clBlue
            MarkersTurnOffLimit = 0
            MarkersFont.Charset = DEFAULT_CHARSET
            MarkersFont.Color = clWhite
            MarkersFont.Height = -11
            MarkersFont.Name = 'Tahoma'
            MarkersFont.Style = [fsBold]
            XAxisName = 'X-Axis 1'
            YAxisName = 'Y-Axis 1'
            DataStyle = ipdsStandard
            OPCComputerName = 'Local'
          end
          item
            Name = 'Channel 4'
            TitleText = 'Channel 4'
            VisibleInLegend = False
            Color = clFuchsia
            MarkersTurnOffLimit = 0
            MarkersFont.Charset = DEFAULT_CHARSET
            MarkersFont.Color = clWhite
            MarkersFont.Height = -11
            MarkersFont.Name = 'Tahoma'
            MarkersFont.Style = [fsBold]
            XAxisName = 'X-Axis 1'
            YAxisName = 'Y-Axis 1'
            DataStyle = ipdsStandard
            OPCComputerName = 'Local'
          end
          item
            Name = 'Channel 5'
            TitleText = 'Channel 5'
            VisibleInLegend = False
            Color = clAqua
            MarkersTurnOffLimit = 0
            MarkersFont.Charset = DEFAULT_CHARSET
            MarkersFont.Color = clWhite
            MarkersFont.Height = -11
            MarkersFont.Name = 'Tahoma'
            MarkersFont.Style = [fsBold]
            XAxisName = 'X-Axis 1'
            YAxisName = 'Y-Axis 1'
            DataStyle = ipdsStandard
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
            ChannelName = 'Channel 1'
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
            Visible = False
            Horizontal = True
            ZOrder = 1
            StopPercent = 100.000000000000000000
            Caption = 'Untitled'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -19
            Font.Name = 'Arial'
            Font.Style = [fsBold]
          end>
      end
      object ConstantEdit: TEdit
        Left = 488
        Top = 7
        Width = 76
        Height = 21
        Alignment = taCenter
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 1
      end
    end
  end
  object Timer1: TTimer
    Interval = 500
    OnTimer = Timer1Timer
    Left = 16
    Top = 104
  end
  object PopupMenu1: TPopupMenu
    Left = 48
    Top = 104
    object Config1: TMenuItem
      Caption = 'Config'
      OnClick = Config1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Close1: TMenuItem
      Caption = 'Close'
      OnClick = Close1Click
    end
  end
  object DropTextTarget1: TDropTextTarget
    DragTypes = [dtCopy, dtLink]
    OnDrop = DropTextTarget1Drop
    Target = PageControl1
    Left = 80
    Top = 104
  end
  object WatchListPopup: TPopupMenu
    Left = 144
    Top = 104
    object Items1: TMenuItem
      Caption = 'Items'
      object AddtoCalculated1: TMenuItem
        Caption = 'Add to Calculated'
        OnClick = AddtoCalculated1Click
      end
    end
    object AddtoSimple1: TMenuItem
      Caption = 'Simple'
      object AddToSimple3: TMenuItem
        Caption = 'Add To Simple'
        OnClick = AddToSimple3Click
      end
      object AddToSimpleInNewWindow1: TMenuItem
        Caption = 'Add To Simple in New Window'
        OnClick = AddToSimpleInNewWindow1Click
      end
    end
    object AddtoTrend1: TMenuItem
      Caption = 'Trend'
      object AddtoTrend2: TMenuItem
        Caption = 'Add Value to Trend'
        OnClick = AddtoTrend2Click
      end
      object AddtoNewTrendWindow1: TMenuItem
        Caption = 'Add Value to Trend in New Window'
        OnClick = AddtoNewTrendWindow1Click
      end
      object N12: TMenuItem
        Caption = '-'
      end
      object AddAlarmValue1: TMenuItem
        Caption = 'Add Alarm Value to Trend'
        OnClick = AddAlarmValue1Click
      end
      object AddFaultValue1: TMenuItem
        Caption = 'Add Fault Value to Trend'
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object DeleteFromTrend1: TMenuItem
        Caption = 'Delete Value From Trend'
        OnClick = DeleteFromTrend1Click
      end
      object DeleteAlarmValueFromTrend1: TMenuItem
        Caption = 'Delete Alarm Value From Trend'
        OnClick = DeleteAlarmValueFromTrend1Click
      end
      object DeleteFaultValueFromTrend1: TMenuItem
        Caption = 'Delete Fault Value From Trend'
        OnClick = DeleteFaultValueFromTrend1Click
      end
      object N8: TMenuItem
        Caption = '-'
      end
      object LoadDatafromfile1: TMenuItem
        Caption = 'Load Trend From File'
        OnClick = LoadDatafromfile1Click
      end
      object LoadTrendDataFromFileUsingWatchList1: TMenuItem
        Caption = 'Load Trend From File For WatchList'
        OnClick = LoadTrendDataFromFileUsingWatchList1Click
      end
    end
    object AddtoSimple2: TMenuItem
      Caption = 'XY Graph'
      object AddtoXYGraph2: TMenuItem
        Caption = 'Add to XY Graph in Real Time'
        Hint = 'Display realtime data to xy graph'
        OnClick = AddtoXYGraph1Click
      end
      object AddtoXYGraph1: TMenuItem
        Caption = 'Add to XY Graph From TrendData'
        OnClick = AddtoXYGraphFromTrendData1Click
      end
      object AddToXYGraphFromFile1: TMenuItem
        Caption = 'Add To XY Graph From File'
        OnClick = AddToXYGraphFromFile1Click
      end
      object AddtoXYGraphinNewWindow1: TMenuItem
        Caption = 'Add to XY Graph in New Window'
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object AddtoXAxis1: TMenuItem
        Caption = 'Add to X Axis'
      end
      object AddtoXAxis2: TMenuItem
        Caption = 'Add to Y Axis'
      end
      object N11: TMenuItem
        Caption = '-'
      end
      object DeleteFromXYGraph1: TMenuItem
        Caption = 'Delete From XY Graph'
        OnClick = DeleteFromXYGraph1Click
      end
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object DataSave1: TMenuItem
      Caption = 'Move to Data Save'
      OnClick = DataSave1Click
    end
    object NotifyAlarmList1: TMenuItem
      Caption = 'Notify Alarm to AlarmList'
    end
    object N9: TMenuItem
      Caption = '-'
    end
    object LoadWatchListFromFile1: TMenuItem
      Caption = 'Load Watch List From File'
      OnClick = LoadWatchListFromFile1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object DeleteItem1: TMenuItem
      Caption = 'Delete Items'
      OnClick = DeleteItem1Click
    end
    object N10: TMenuItem
      Caption = '-'
    end
    object Properties1: TMenuItem
      Caption = 'Properties'
      OnClick = Properties1Click
    end
  end
  object ImageList1: TImageList
    Left = 176
    Top = 104
    Bitmap = {
      494C010106000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      0000000000000000000000000000000000000000000000000000000000000000
      000040B0C00040C0C00030B0C01030B0C02030B0C01030B0B01030A8B00030A8
      B00030A0B0001098A00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000050D0
      D0102098A04020889090108890E0108080E0208080D0107880A0207880701078
      803030A8C0101098A0001098A00000000000000000000058A0100050A0D00048
      9090004880100000000000000000000000000000000000000000004080100040
      8090004080D00040801000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000D8F00030E0F01010A0
      B09010A0B0FF10A0B0FF10A0C0FF0098C0FF0098C0FF0090C0FF1088A0FF2080
      90FF1078805020A8B01030A8B0001098A000000000000068C0201068A0E01070
      A0FF005080F00048904000000000000000000000000000408040004870F00050
      70FF105070F00040802000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000010E0F01010A8B0B010B8
      C0FF10C8D0FF20D0E0FF10C0D0FF10B8D0FF10B0D0FF10A8D0FF10A0C0FF0090
      C0FF1088A0F01078805020A8B01040B0C00000000000000000001070C0C01098
      C0FF10A0D0FF005080FF005090900048901000408090004060FF0078B0FF0068
      A0FF005070F00000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000C0D00010C0D06020C8D0FF20D0
      E0FF20D8E0FF107070FF103030FF001010FF004850FF006870FF10B8D0FF10A8
      D0FF1098C0FF108890B01078803030B0C00000000000000000001080D0201070
      B0F030C8E0FF20C8E0FF1070A0F0005090F0006090FF00A8D0FF00A0D0FF0038
      60FF105880300000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000040E8F00020C8D0E020D0E0FF20E0
      F0FF205860FF207880FF30B0C0FF30C8D0FF30A0B0FF007080FF005860FF20C0
      D0FF10A0C0FF1090B0FF207880703098A0100000000000000000000000002088
      D0902098C0F040D8F0FF30D0F0FF20B8E0FF10C0E0FF10B8E0FF0068A0FF1058
      80B0000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000060F0FF1020D0E0FF30E8F0FF20B0
      C0FF40A8B0FF50E8F0FF50F0FFFF40F0F0FF20E0F0FF50D8E0FF107880FF20C8
      D0FF10B0D0FF1098C0FF108080B0308080000000000000000000000000003098
      E0702088C0F050E0F0FF40E0F0FF30D8F0FF20D0E0FF10C8E0FF005080FF0050
      9070000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000060F0FF1030D0D0FF60F0FFFF60F0
      FFFF50F0FFFF60F8FFFF60F8FFFF50F0FFFF40F0FFFF20E8F0FF10E0F0FF20D8
      F0FF20C0E0FF10A8D0FF1090A0F0000000000000000050B0F01050A8F0B040A0
      D0F070E0F0FF60E8F0FF50E0F0FF50E0F0FF40D8F0FF30D0F0FF10B8E0FF0058
      90FF0058A0B00050901000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000050F0FF0030D0D0FF80F8FFFF90F8
      FFFF60D0D0FF60D0D0FF70F8FFFF60F8FFFF50F8FFFF30D0E0FF20C8D0FF20E0
      F0FF20C8E0FF10B0D0FF108890C00000000060B8F03060B0E0E070C8E0F090F0
      FFFF90F8FFFF80F0FFFF70E8F0FF60E8F0FF50E0F0FF40D8F0FF30D0F0FF20C8
      E0FF1080B0FF005890F00050A030000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000070F0FF0030D8E0FF70F0F0FFC0F8
      FFFF203030FF101820FF70F8FFFF60F8FFFF50F8FFFF102820FF101820FF20E0
      F0FF20D0E0FF10A8C0FF108090A080D8E00060B8F0FF50B0E0FF50B0E0FF50A8
      E0FF50A8E0FF50B0E0F080F0F0FF80F0F0FF60E8F0FF3088C0E01078C0FF1068
      B0FF0060B0FF0058A0FF0060B0FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080E8FF0030D8E0C050E0F0FFC0F8
      FFFF707070FF303830FF80F8FFFF70F8FFFF50F8FFFF606870FF203830FF10E0
      F0FF10C8E0FF1098B0F01080907080E8F0000000000000000000000000000000
      00000000000070B0E0D080D8F0FF90F8FFFF60C8E0F040A0E0B0000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000020E0E04050D8E0FF80F0
      FFFFE0FFFFFFE0FFFFFFA0F8FFFF90F8FFFF70F8FFFF30F0FFFF20E8F0FF10D8
      F0FF10C8E0FF008890C00090A020D0F8FF000000000000000000000000000000
      00000000000070B8F05060C0F0FFA0F8FFFF60B0D0E050A8F050000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000020C8D0B050E8
      F0FF90F8FFFFC0F8FFFFC0F8FFFFB0F8FFFF80F8FFFF30E8F0FF20E0F0FF20D0
      E0FF10A0B0FF0090A07080F8FF00000000000000000000000000000000000000
      00000000000060B8F00060B0E0F090E8F0FF60B0E0F060B8F000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000020C8
      D0B050E0E0FF50F0F0FF80F0FFFF80F8FFFF30F0F0FF20D8E0FF20C8D0FF10B8
      C0FF0098A06060E8F00000000000000000000000000000000000000000000000
      0000000000000000000070B8E0A060B8E0F060B8F09000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E0F0
      FF0020D0E05020C8D08030D0D0E030C8D0FF20C8D0FF20C8D0F020C8D0B010B8
      C020D0FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000060B8F03060B8F0F060B8F03000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000090F8FF00A0F8FF00A0F0FF0080F0FF00E0F8FF0060F8FF000000
      0000E0E8FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00009070603090706080906850C0806850F0806050F0805840C0705840807050
      4030000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000010A8E050306880FF304860FF40607060000000000000
      000000000000000000000000000000000000000000000000000000000000A078
      6060907060E0907050FF706840FF906840FFB06840FF906040FF805040FF7050
      40E0705040600000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000005088A0D04078
      90E0306880D0306080D0206880E0306890FF305870FF305060F0305060FF3048
      60FF304860FF305060F000000000000000000000000000000000A0806060A078
      60F0C08060FF807830FF607820FF506040FF906040FFC06840FFB06040FF9058
      40FF705040F07050406000000000000000000000000000000000000000000000
      0000000000000000000000000000A0503000A050200000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000657BC8002F4FB10000000000000000000000
      000000000000000000000000000000000000000000000000000060A8C0FFD0FF
      FFFFB0F8FFFF80E8FFFF60E0F0FF50C0E0FF40B0D0FF40A0C0FF3088A0FF3078
      A0FF305870FF305060FF000000000000000000000000B0807030A07860E0D088
      60FFF08860FFD08040FF608820FF308820FF606830FF706840FFB06840FFB060
      40FF905840FF705040E070504030000000000000000000000000000000000000
      00000000000000000000B0603000E0805000D0785000A0502000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000006080F0002048D00000000000000000000000
      000000000000000000000000000000000000000000000000000080A0E04070C8
      E0FFD0F8FFFFB0F8FFFFA0F0FFFF90E8FFFF70D0F0FF50C0E0FF40B8E0FF3080
      A0FF205870FF10305040000000000000000000000000B0807080C08870FFF098
      60FFF09060FFC08860FF508040FF409820FF408830FF707040FFB06840FF8060
      40FF606040FF605840FF70584080000000000000000000000000000000000000
      000000000000B0583000F0A07000F0A07000E0805000D0704000B05830000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000080B0
      C04080C8E0FF80D8F0FF70C0D0FF60B0D0FF50A0C0FF3080A0FF306880FF3050
      70FF1040504000000000000000000000000000000000B08070C0E09870FFFFA0
      70FFE09070FF707850FF50A840FF50A830FF809830FFD07850FF707040FF5068
      40FF307810FF606830FF805840C0000000000000000000000000000000000000
      0000E9B29C00E5A48A00E0907000FFA88000F0885000B0603000A0502000A050
      2000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000070B0C0D0C0F8FFFF90E8F0FF70D8F0FF40C0E0FF30A0C0FF3090B0FF3050
      60F00000000000000000000000000000000000000000B08870F0F0B890FFF0A8
      80FF607860FF609850FF60B040FF90A040FFE08860FFD08050FF507050FF4088
      30FF309010FF408020FF806050F0000000000000000000000000000000000000
      00000000000000000000E0906000FFA88000F0906000B0583000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000004970E5002F5CD80000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000070B8D0E0C0F8FFFFA0F0FFFF90E0F0FF60D0F0FF40C0E0FF30A0C0FF3060
      80F00000000000000000000000000000000000000000B08870F0FFB8A0FFA098
      80FF40A850FF60B850FF909860FFE09870FFE09060FFE08860FF60A030FF40A0
      20FF409820FF408820FF806850F0000000000000000000000000000000000000
      00000000000000000000E0907000FFB09000FF906000A0502000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000003060F0000040FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080C0D0F0C0F8FFFFC0F8FFFFA0F0FFFF90E8F0FF60D0F0FF40B8E0FF3060
      80F00000000000000000000000000000000000000000B08870C0E0B8A0FF90B8
      80FF50C870FF50C870FF80A070FFC0A070FFD09870FFE09060FFA09840FF50A8
      30FF40A020FF508830FF906850C0000000000000000000000000000000000000
      00000000000000000000E0907000FFB89000FF986000A0502000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000006383E5004B78F0000048FF001F50D500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080C0D0F0C0F8FFFFC0F8FFFFC0F8FFFFB0F8FFFF90E0F0FF60C0E0FF4068
      80F00000000000000000000000000000000000000000B0907080B0A080FF90D0
      A0FF70E090FF90E0A0FF80E8A0FFA0D090FFB0A870FFF09870FFE09060FF50A8
      30FF50A830FF708840FF90706080000000000000000000000000000000000000
      00000000000000000000E0987000FFB89000FF987000A0502000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000005078E0006088FF003060FF000038D000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080A0A050A0D8E0FFC0F0F0FFD0FFFFFFD0FFFFFFA0E8F0FF6090A0FF5060
      60500000000000000000000000000000000000000000B0907030B09080E090C8
      A0FFA0E8B0FFD0F0C0FFD0F8D0FFF0F8D0FFB0E8B0FF809860FFD09840FFB090
      40FF609840FF907050E090706030000000000000000000000000000000000000
      00000000000000000000F0A08000FFC0A000FFB89000A0502000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000007088E00090A8FF006088FF002050D000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000080B0B04090D0E0FF80C0D0FF70B0C0FF60A0B0FF608090300000
      0000000000000000000000000000000000000000000000000000B0908070B0A0
      80F0B0D8B0FFD0F0D0FFE0F8D0FF80B070FF80D890FF50B070FF908840FFD088
      60FFA07860F0A078606000000000000000000000000000000000000000000000
      00000000000000000000F0A57800E1A57800E19E7800D2876900000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000788FE100697FE10000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000B090
      8070B09080E0C0C0A0FFD0E0C0FFB0E8B0FF80E0A0FF60B870FFA08850FFA078
      60E0A08060600000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000B0908030B0908080B09080C0B09080F0C09880F0B09080C0B0807080B080
      7030000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF00F003FFFF00000000E00187C300000000
      80008383000000008000C007000000000000C007000000000000E00F00000000
      0000E00F00000000000180030000000000010001000000000000000100000000
      0000F83F000000008000F83F00000000C001F83F00000000E003FC7F00000000
      E007FC7F00000000F817FFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF00F
      FFFFFFFFFC3FE007FFFFFFFFC003C003FE7FFE7FC0038001FC3FFE7FC0038001
      F81FFFFFE0078001F00FFFFFF00F8001FC3FFE7FF00F8001FC3FFE7FF00F8001
      FC3FFC3FF00F8001FC3FFC3FF00F8001FC3FFC3FF81FC003FC3FFE7FFFFFE007
      FFFFFFFFFFFFF00FFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object JvSaveDialog1: TJvSaveDialog
    Height = 0
    Width = 0
    Left = 208
    Top = 104
  end
  object JvOpenDialog1: TJvOpenDialog
    Filter = '*.himecs||*.*'
    Options = [ofHideReadOnly, ofNoTestFileCreate, ofEnableSizing]
    Height = 425
    Width = 656
    Left = 240
    Top = 104
  end
  object EngParamSource2: TDropTextSource
    DragTypes = [dtCopy]
    Left = 80
    Top = 152
  end
  object PopupMenu2: TPopupMenu
    Left = 112
    Top = 104
    object Add1: TMenuItem
      Caption = 'Add Data'
      object Average1: TMenuItem
        Caption = 'Average'
        OnClick = Average1Click
      end
      object MinValue1: TMenuItem
        Caption = 'Min Value'
        OnClick = MinValue1Click
      end
      object MaxValue1: TMenuItem
        Caption = 'Max Value'
        OnClick = MaxValue1Click
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object LoadFromFile1: TMenuItem
        Caption = 'Load From File'
        OnClick = LoadFromFile1Click
      end
    end
  end
  object CalcExpress1: TCalcExpress
    Formula = '0'
    Left = 136
    Top = 152
  end
end
