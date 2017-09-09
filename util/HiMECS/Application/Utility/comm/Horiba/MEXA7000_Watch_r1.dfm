object WatchF2_: TWatchF2_
  Left = 544
  Top = 320
  Caption = 'WatchF2_'
  ClientHeight = 351
  ClientWidth = 599
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
    Width = 599
    Height = 332
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Simple'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 591
        Height = 304
        Align = alClient
        Color = clBlack
        ParentBackground = False
        TabOrder = 0
        DesignSize = (
          591
          304)
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
          Left = 428
          Top = 50
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
          ExplicitLeft = 173
          ExplicitTop = 23
        end
        object Label10: TLabel
          Left = 347
          Top = 275
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
          ExplicitLeft = 225
          ExplicitTop = 294
        end
        object Label2: TLabel
          Left = 16
          Top = 178
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
          ExplicitTop = 136
        end
        object AvgLabel: TLabel
          Left = 99
          Top = 216
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
          Visible = False
        end
        object AvgLabel2: TLabel
          Left = 461
          Top = 165
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
          Left = 461
          Top = 275
          Width = 41
          Height = 21
          Anchors = [akRight, akBottom]
          ImeName = 'Microsoft Office IME 2007'
          TabOrder = 0
          Text = 'AvgEdit'
        end
        object UpDown1: TUpDown
          Left = 503
          Top = 274
          Width = 17
          Height = 25
          Anchors = [akRight, akBottom]
          TabOrder = 1
        end
        object Button2: TButton
          Left = 525
          Top = 274
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
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 591
        Height = 304
        Align = alClient
        Color = clBlack
        ParentBackground = False
        TabOrder = 0
        DesignSize = (
          591
          304)
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
          Left = 337
          Top = 87
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
          ExplicitLeft = 96
          ExplicitTop = 80
        end
        object Label5: TLabel
          Left = 8
          Top = 62
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
          ExplicitTop = 56
        end
        object Label6: TLabel
          Left = 8
          Top = 114
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
          ExplicitTop = 104
        end
        object Label7: TLabel
          Left = 8
          Top = 166
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
          ExplicitTop = 152
        end
        object MinLabel: TLabel
          Left = 337
          Top = 153
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
          ExplicitLeft = 104
          ExplicitTop = 144
        end
        object MaxLabel: TLabel
          Left = 337
          Top = 50
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
          ExplicitLeft = 104
          ExplicitTop = 46
        end
        object Button1: TButton
          Left = 505
          Top = 254
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
    object TabSheet3: TTabSheet
      Caption = 'Graph'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object iPlot1: TiPlot
        Left = 0
        Top = 0
        Width = 591
        Height = 304
        PopupMenu = PopupMenu2
        DataViewZHorz = 1
        DataViewZVert = 1
        UserCanAddRemoveChannels = True
        PrintMarginLeft = 1.000000000000000000
        PrintMarginTop = 1.000000000000000000
        PrintMarginRight = 1.000000000000000000
        PrintMarginBottom = 1.000000000000000000
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
            ColumnTitlesFont.Name = 'MS Sans Serif'
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
            Span = 100.000000000000000000
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
            XAxisName = 'X-Axis 1'
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
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 332
    Width = 599
    Height = 19
    Panels = <>
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 32
    Top = 24
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
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 72
    Top = 24
    object Config1: TMenuItem
      Caption = 'Config'
      OnClick = Config1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Displayalldatainthischart1: TMenuItem
      Caption = 'Display all data in this chart'
      OnClick = Displayalldatainthischart1Click
    end
  end
end
