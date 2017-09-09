object WatchF: TWatchF
  Left = 544
  Top = 320
  Width = 352
  Height = 288
  Caption = 'WatchF'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 344
    Height = 254
    ActivePage = TabSheet1
    Align = alClient
    TabIndex = 0
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Simple'
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 336
        Height = 226
        Align = alClient
        Color = clBlack
        TabOrder = 0
        DesignSize = (
          336
          226)
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
          Left = 173
          Top = 23
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
        end
        object Label10: TLabel
          Left = 96
          Top = 199
          Width = 108
          Height = 16
          Anchors = [akRight, akBottom]
          Caption = 'Average Size'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWhite
          Font.Height = -16
          Font.Name = #44404#47548#52404
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label2: TLabel
          Left = 16
          Top = 136
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
          Left = 189
          Top = 112
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
        end
        object AvgEdit: TEdit
          Left = 208
          Top = 197
          Width = 41
          Height = 21
          Anchors = [akRight, akBottom]
          ImeName = 'Microsoft Office IME 2007'
          TabOrder = 0
          Text = 'AvgEdit'
        end
        object UpDown1: TUpDown
          Left = 250
          Top = 196
          Width = 17
          Height = 25
          Anchors = [akRight, akBottom]
          Min = 0
          Position = 0
          TabOrder = 1
          Wrap = False
        end
        object Button2: TButton
          Left = 272
          Top = 196
          Width = 59
          Height = 25
          Anchors = [akRight, akBottom]
          Caption = 'Apply'
          TabOrder = 2
          OnClick = Button2Click
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Min/Max'
      ImageIndex = 1
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 336
        Height = 226
        Align = alClient
        Color = clBlack
        TabOrder = 0
        DesignSize = (
          336
          226)
        object Label3: TLabel
          Left = 8
          Top = 8
          Width = 102
          Height = 32
          Caption = 'Label1'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWhite
          Font.Height = -32
          Font.Name = #44404#47548#52404
          Font.Style = [fsBold]
          ParentFont = False
        end
        object CurLabel: TLabel
          Left = 120
          Top = 80
          Width = 102
          Height = 67
          Anchors = [akRight]
          Caption = '0.0'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWhite
          Font.Height = -67
          Font.Name = #44404#47548#52404
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
        end
        object Label5: TLabel
          Left = 8
          Top = 56
          Width = 44
          Height = 19
          Anchors = [akLeft]
          Caption = 'Max:'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWhite
          Font.Height = -19
          Font.Name = #44404#47548#52404
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label6: TLabel
          Left = 8
          Top = 104
          Width = 88
          Height = 19
          Anchors = [akLeft]
          Caption = 'Current:'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWhite
          Font.Height = -19
          Font.Name = #44404#47548#52404
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label7: TLabel
          Left = 8
          Top = 152
          Width = 44
          Height = 19
          Anchors = [akLeft]
          Caption = 'Min:'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWhite
          Font.Height = -19
          Font.Name = #44404#47548#52404
          Font.Style = [fsBold]
          ParentFont = False
        end
        object MinLabel: TLabel
          Left = 152
          Top = 48
          Width = 63
          Height = 40
          Anchors = [akRight]
          Caption = '0.0'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWhite
          Font.Height = -40
          Font.Name = #44404#47548#52404
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
        end
        object MaxLabel: TLabel
          Left = 152
          Top = 144
          Width = 63
          Height = 40
          Anchors = [akRight]
          Caption = '0.0'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWhite
          Font.Height = -40
          Font.Name = #44404#47548#52404
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
        end
        object Button1: TButton
          Left = 264
          Top = 176
          Width = 65
          Height = 25
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
        object StatusBar1: TStatusBar
          Left = 1
          Top = 206
          Width = 334
          Height = 19
          Panels = <>
          SimplePanel = False
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Graph'
      ImageIndex = 2
      object iPlot1: TiPlot
        Left = 0
        Top = 0
        Width = 336
        Height = 226
        PopupMenu = PopupMenu2
        DataViewZHorz = 1
        DataViewZVert = 1
        UserCanEditObjects = False
        PrintMarginLeft = 1
        PrintMarginTop = 1
        PrintMarginRight = 1
        PrintMarginBottom = 1
        PrintShowDialog = False
        PrintDocumentName = 'Untitled'
        HintsFont.Charset = DEFAULT_CHARSET
        HintsFont.Color = clWindowText
        HintsFont.Height = -11
        HintsFont.Name = 'MS Sans Serif'
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
        AnnotationDefaultFont.Name = 'MS Sans Serif'
        AnnotationDefaultFont.Style = []
        AnnotationDefaultBrushStlye = bsSolid
        AnnotationDefaultBrushColor = clWhite
        AnnotationDefaultPenStlye = psSolid
        AnnotationDefaultPenColor = clWhite
        AnnotationDefaultPenWidth = 1
        ClipAnnotationsToAxes = True
        BackGroundGradientEnabled = False
        BackGroundGradientDirection = ifdTopBottom
        BackGroundGradientStartColor = clBlue
        BackGroundGradientStopColor = clBlack
        Align = alClient
        TabOrder = 0
        DataViewZHorz = 1
        DataViewZVert = 1
        ToolBarManager = <
          item
            Name = 'Toolbar 1'
            Visible = False
            Enabled = False
            Horizontal = True
            ZOrder = 3
            StopPercent = 100
            ZoomInOutFactor = 2
          end>
        LegendManager = <
          item
            Name = 'Legend 1'
            Horizontal = False
            ZOrder = 2
            StopPercent = 100
            MarginLeft = 1
            MarginTop = 1
            MarginRight = 1
            MarginBottom = 1
            SelectedItemFont.Charset = DEFAULT_CHARSET
            SelectedItemFont.Color = clBlack
            SelectedItemFont.Height = -11
            SelectedItemFont.Name = 'MS Sans Serif'
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
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ColumnSpacing = 0.5
            RowSpacing = 0.25
            WrapColDesiredCount = 1
            WrapColAutoCountEnabled = False
            WrapColAutoCountMax = 100
            WrapColSpacingMin = 2
            WrapColSpacingAuto = True
            WrapRowDesiredCount = 5
            WrapRowAutoCountEnabled = True
            WrapRowAutoCountMax = 100
            WrapRowSpacingMin = 0.25
            WrapRowSpacingAuto = False
            ColumnTitlesFont.Charset = DEFAULT_CHARSET
            ColumnTitlesFont.Color = clAqua
            ColumnTitlesFont.Height = -11
            ColumnTitlesFont.Name = 'MS Sans Serif'
            ColumnTitlesFont.Style = [fsBold]
          end>
        XAxisManager = <
          item
            Name = 'X-Axis 1'
            Horizontal = True
            ZOrder = 0
            StopPercent = 100
            Span = 100
            Title = 'X-Axis 1'
            TitleMargin = 0.25
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWhite
            TitleFont.Height = -13
            TitleFont.Name = 'Arial'
            TitleFont.Style = [fsBold]
            LabelsMargin = 0.25
            LabelsFont.Charset = DEFAULT_CHARSET
            LabelsFont.Color = clWhite
            LabelsFont.Height = -11
            LabelsFont.Name = 'MS Sans Serif'
            LabelsFont.Style = []
            LabelSeparation = 2
            DateTimeFormat = 'hh:nn:ss'
            LabelsMinLength = 5
            ScaleLineShow = True
            StackingEndsMargin = 0.5
            TrackingStyle = iptsScrollSmooth
            TrackingAlignFirstStyle = ipafsAuto
            CursorDateTimeFormat = 'hh:nn:ss'
            CursorPrecision = 3
            CursorMinLength = 5
            LegendDateTimeFormat = 'hh:nn:ss'
            LegendPrecision = 3
            LegendMinLength = 5
            CursorScaler = 1
            ScrollMinMaxEnabled = False
            ScrollMax = 100
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
            StopPercent = 100
            Span = 100
            Title = 'Y-Axis 1'
            TitleMargin = 0.25
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWhite
            TitleFont.Height = -13
            TitleFont.Name = 'Arial'
            TitleFont.Style = [fsBold]
            LabelsMargin = 0.25
            LabelsFont.Charset = DEFAULT_CHARSET
            LabelsFont.Color = clWhite
            LabelsFont.Height = -11
            LabelsFont.Name = 'MS Sans Serif'
            LabelsFont.Style = []
            LabelSeparation = 2
            DateTimeFormat = 'hh:nn:ss'
            LabelsMinLength = 5
            ScaleLineShow = True
            StackingEndsMargin = 0.5
            TrackingStyle = iptsScaleMinMax
            TrackingAlignFirstStyle = ipafsNone
            CursorDateTimeFormat = 'hh:nn:ss'
            CursorPrecision = 3
            CursorMinLength = 5
            LegendDateTimeFormat = 'hh:nn:ss'
            LegendPrecision = 3
            LegendMinLength = 5
            CursorScaler = 1
            ScrollMinMaxEnabled = False
            ScrollMax = 100
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
            MarkersFont.Name = 'MS Sans Serif'
            MarkersFont.Style = [fsBold]
            XAxisName = 'X-Axis 1'
            YAxisName = 'Y-Axis 1'
            DataStyle = ipdsStandard
            OPCComputerName = 'Local'
            DigitalReferenceLow = 10
            DigitalReferenceHigh = 90
            HighLowBarColor = clAqua
            HighLowBarWidth = 0.5
            HighLowOpenColor = clLime
            HighLowOpenWidth = 1
            HighLowOpenHeight = 1
            HighLowCloseWidth = 1
            HighLowCloseHeight = 1
            BarWidth = 5
          end>
        DataViewManager = <
          item
            Name = 'Data View 1'
            Horizontal = False
            ZOrder = 0
            StopPercent = 100
            GridXAxisName = 'X-Axis 1'
            GridYAxisName = 'Y-Axis 1'
            GridLineXMajorWidth = 0
            GridLineXMinorWidth = 0
            GridLineYMajorWidth = 0
            GridLineYMinorWidth = 0
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
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            Color = clYellow
            UseChannelColor = True
            HintShow = True
            HintHideOnRelease = False
            HintOrientationSide = iosBottomRight
            HintPosition = 50
            Pointer1Position = 50
            Pointer2Position = 60
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
            ZOrder = 2
            StopPercent = 100
            Caption = 'Untitled'
            Alignment = iahCenter
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -19
            Font.Name = 'Arial'
            Font.Style = [fsBold]
          end>
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Meter'
      ImageIndex = 3
      object iAngularGauge1: TiAngularGauge
        Left = 48
        Top = 40
        PositionMax = 100
        Label1Font.Charset = DEFAULT_CHARSET
        Label1Font.Color = clWindowText
        Label1Font.Height = -11
        Label1Font.Name = 'MS Sans Serif'
        Label1Font.Style = []
        Label2Font.Charset = DEFAULT_CHARSET
        Label2Font.Color = clWindowText
        Label2Font.Height = -11
        Label2Font.Name = 'MS Sans Serif'
        Label2Font.Style = []
        Label2OffsetY = -20
        PanelFaceStyle = ipfsNone
        PanelFaceOuterColor = clBlack
        PanelFaceInnerColor = clWhite
        PanelFaceSize = 15
        TickLabelFont.Charset = DEFAULT_CHARSET
        TickLabelFont.Color = clWindowText
        TickLabelFont.Height = -11
        TickLabelFont.Name = 'MS Sans Serif'
        TickLabelFont.Style = []
        SectionEnd1 = 50
        SectionEnd2 = 75
        PositionMax_2 = 100
        SectionEnd1_2 = 50
        SectionEnd2_2 = 75
        Pointers = <
          item
            Size = 10
            Margin = 0
            Color = clBlack
            Style = 3
          end>
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Bar'
      ImageIndex = 4
      object iLedBar1: TiLedBar
        Left = 32
        Top = 128
        Width = 265
        Height = 56
        PositionMax = 100
        SectionEnd1 = 50
        SectionEnd2 = 75
        SegmentDirection = idLeft
        PositionMax_2 = 100
        SectionEnd1_2 = 50
        SectionEnd2_2 = 75
      end
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 32
    Top = 24
  end
  object PopupMenu1: TPopupMenu
    Left = 72
    Top = 24
    object Config1: TMenuItem
      Caption = 'Config'
      OnClick = Config1Click
    end
  end
  object PopupMenu2: TPopupMenu
    Left = 72
    Top = 64
    object Add1: TMenuItem
      Caption = 'Add Data'
      object CurrentValue1: TMenuItem
        Caption = 'Current Value'
        OnClick = CurrentValue1Click
      end
      object Average1: TMenuItem
        Caption = 'Average'
      end
      object MinValue1: TMenuItem
        Caption = 'Min Value'
      end
      object MaxValue1: TMenuItem
        Caption = 'Max Value'
      end
    end
  end
end
