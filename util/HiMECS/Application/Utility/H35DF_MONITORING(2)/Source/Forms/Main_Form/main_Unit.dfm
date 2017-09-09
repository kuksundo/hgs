object Form3: TForm3
  Left = 0
  Top = 0
  Caption = '35DF Engine'
  ClientHeight = 746
  ClientWidth = 1028
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 1028
    Height = 727
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 1028
      Height = 36
      Align = alTop
      TabOrder = 0
      object Button1: TButton
        AlignWithMargins = True
        Left = 881
        Top = 4
        Width = 143
        Height = 28
        Align = alRight
        Caption = 'Start Monitoring'
        TabOrder = 0
        OnClick = Button1Click
      end
    end
    object Panel4: TPanel
      Left = 736
      Top = 36
      Width = 292
      Height = 553
      Align = alRight
      TabOrder = 2
      ExplicitHeight = 691
      object Panel11: TPanel
        Left = 1
        Top = 1
        Width = 290
        Height = 254
        Align = alTop
        TabOrder = 0
        object Panel12: TPanel
          Left = 1
          Top = 1
          Width = 288
          Height = 88
          Align = alTop
          Caption = 'Load'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -64
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object LoadPanel: TPanel
          Left = 1
          Top = 89
          Width = 288
          Height = 164
          Align = alTop
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -96
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 1
        end
      end
      object Panel5: TPanel
        Left = 1
        Top = 255
        Width = 290
        Height = 297
        Align = alClient
        TabOrder = 1
        ExplicitHeight = 435
        object Panel10: TPanel
          Left = 1
          Top = 1
          Width = 143
          Height = 295
          Align = alClient
          TabOrder = 0
          ExplicitHeight = 433
          object Label3: TLabel
            Left = 1
            Top = 1
            Width = 141
            Height = 39
            Align = alTop
            Alignment = taCenter
            Caption = 'Diesel'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -32
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            ExplicitWidth = 98
          end
          object DieselLoad: TAdvSmoothProgressBar
            AlignWithMargins = True
            Left = 4
            Top = 43
            Width = 135
            Height = 248
            Step = 10.000000000000000000
            Maximum = 100.000000000000000000
            Position = 100.000000000000000000
            Appearance.BackGroundFill.Color = 16765615
            Appearance.BackGroundFill.ColorTo = 16765615
            Appearance.BackGroundFill.ColorMirror = clNone
            Appearance.BackGroundFill.ColorMirrorTo = clNone
            Appearance.BackGroundFill.GradientType = gtVertical
            Appearance.BackGroundFill.GradientMirrorType = gtSolid
            Appearance.BackGroundFill.BorderColor = clSilver
            Appearance.BackGroundFill.Rounding = 0
            Appearance.BackGroundFill.ShadowOffset = 0
            Appearance.BackGroundFill.Glow = gmNone
            Appearance.ProgressFill.Color = 16737843
            Appearance.ProgressFill.ColorTo = clBlue
            Appearance.ProgressFill.ColorMirror = clBlue
            Appearance.ProgressFill.ColorMirrorTo = 16737843
            Appearance.ProgressFill.GradientType = gtVertical
            Appearance.ProgressFill.GradientMirrorType = gtVertical
            Appearance.ProgressFill.BorderColor = 16765357
            Appearance.ProgressFill.Rounding = 0
            Appearance.ProgressFill.ShadowOffset = 0
            Appearance.ProgressFill.Glow = gmNone
            Appearance.Font.Charset = DEFAULT_CHARSET
            Appearance.Font.Color = clWindowText
            Appearance.Font.Height = -11
            Appearance.Font.Name = 'Tahoma'
            Appearance.Font.Style = []
            Appearance.ProgressFont.Charset = ANSI_CHARSET
            Appearance.ProgressFont.Color = clYellow
            Appearance.ProgressFont.Height = -19
            Appearance.ProgressFont.Name = 'Arial'
            Appearance.ProgressFont.Style = [fsBold]
            Appearance.ValueFormat = '%.0f%%'
            Version = '1.7.0.0'
            MarqueeColor = clBlue
            Direction = pbdVertical
            Align = alClient
            ExplicitLeft = 28
            ExplicitTop = 46
          end
          object DLoadPanel: TPanel
            Left = 24
            Top = 160
            Width = 97
            Height = 33
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -32
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
          end
        end
        object Panel14: TPanel
          Left = 144
          Top = 1
          Width = 145
          Height = 295
          Align = alRight
          TabOrder = 1
          ExplicitHeight = 433
          object Label1: TLabel
            Left = 1
            Top = 1
            Width = 143
            Height = 39
            Align = alTop
            Alignment = taCenter
            Caption = 'Gas'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -32
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            ExplicitWidth = 59
          end
          object GasLoad: TAdvSmoothProgressBar
            AlignWithMargins = True
            Left = 4
            Top = 43
            Width = 137
            Height = 248
            Step = 10.000000000000000000
            Maximum = 100.000000000000000000
            Position = 50.000000000000000000
            Appearance.BackGroundFill.Color = 16765615
            Appearance.BackGroundFill.ColorTo = 16765615
            Appearance.BackGroundFill.ColorMirror = clNone
            Appearance.BackGroundFill.ColorMirrorTo = clNone
            Appearance.BackGroundFill.GradientType = gtVertical
            Appearance.BackGroundFill.GradientMirrorType = gtSolid
            Appearance.BackGroundFill.BorderColor = clSilver
            Appearance.BackGroundFill.Rounding = 0
            Appearance.BackGroundFill.ShadowOffset = 0
            Appearance.BackGroundFill.Glow = gmNone
            Appearance.ProgressFill.Color = clGreen
            Appearance.ProgressFill.ColorTo = clLime
            Appearance.ProgressFill.ColorMirror = clLime
            Appearance.ProgressFill.ColorMirrorTo = clGreen
            Appearance.ProgressFill.GradientType = gtVertical
            Appearance.ProgressFill.GradientMirrorType = gtVertical
            Appearance.ProgressFill.BorderColor = 16765357
            Appearance.ProgressFill.Rounding = 0
            Appearance.ProgressFill.ShadowOffset = 0
            Appearance.ProgressFill.Glow = gmNone
            Appearance.Font.Charset = DEFAULT_CHARSET
            Appearance.Font.Color = clWindowText
            Appearance.Font.Height = -11
            Appearance.Font.Name = 'Tahoma'
            Appearance.Font.Style = []
            Appearance.ProgressFont.Charset = ANSI_CHARSET
            Appearance.ProgressFont.Color = clWindowText
            Appearance.ProgressFont.Height = -19
            Appearance.ProgressFont.Name = 'Arial'
            Appearance.ProgressFont.Style = [fsBold]
            Appearance.ValueFormat = '%.0f%%'
            Version = '1.7.0.0'
            Direction = pbdVertical
            Align = alClient
            ExplicitHeight = 386
          end
          object GLoadPanel: TPanel
            Left = 24
            Top = 160
            Width = 97
            Height = 33
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -32
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
          end
        end
      end
    end
    object Panel7: TPanel
      Left = 0
      Top = 36
      Width = 736
      Height = 553
      Align = alClient
      Caption = 'Panel7'
      TabOrder = 1
      ExplicitHeight = 589
      inline TFrameIPCMonitorAll1: TFrameIPCMonitorAll
        Left = 176
        Top = 128
        Width = 320
        Height = 240
        TabOrder = 7
        ExplicitLeft = 176
        ExplicitTop = 128
      end
      object iPlot1: TiPlot
        Left = 1
        Top = 1
        Width = 734
        Height = 551
        DataViewZHorz = 1
        DataViewZVert = 1
        OuterMarginTop = 80
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
        TitleText = 'H35DF MONITORING'
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clBlack
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
        BackGroundColor = clWhite
        Align = alClient
        TabOrder = 0
        DataViewZHorz = 1
        DataViewZVert = 1
        ToolBarManager = <
          item
            Name = 'Toolbar 1'
            Visible = False
            Horizontal = True
            ZOrder = 4
            StopPercent = 100.000000000000000000
            ZoomInOutFactor = 2.000000000000000000
          end>
        LegendManager = <
          item
            Name = 'Legend 1'
            Visible = False
            Horizontal = True
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
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ColumnSpacing = 0.500000000000000000
            RowSpacing = 0.250000000000000000
            WrapColDesiredCount = 2
            WrapColAutoCountEnabled = True
            WrapColAutoCountMax = 100
            WrapColSpacingMin = 2.000000000000000000
            WrapColSpacingAuto = False
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
            LineColumnWidth = 30
            LineColumnHeight = 5
          end>
        XAxisManager = <
          item
            Name = 'X-Axis 1'
            Horizontal = True
            ZOrder = 0
            StopPercent = 100.000000000000000000
            Min = 41207.621464294000000000
            Span = 0.020833333333333300
            Title = 'X-Axis 1'
            TitleMargin = 0.250000000000000000
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWhite
            TitleFont.Height = -13
            TitleFont.Name = 'Arial'
            TitleFont.Style = [fsBold]
            LabelsMargin = 0.250000000000000000
            LabelsFont.Charset = ANSI_CHARSET
            LabelsFont.Color = clBlack
            LabelsFont.Height = -11
            LabelsFont.Name = 'Arial'
            LabelsFont.Style = [fsBold]
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
            Span = 60.000000000000000000
            Title = 'Load (%)'
            TitleMargin = 0.250000000000000000
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clBlack
            TitleFont.Height = -13
            TitleFont.Name = 'Arial'
            TitleFont.Style = [fsBold]
            TitleShow = True
            LabelsMargin = 0.250000000000000000
            LabelsFont.Charset = ANSI_CHARSET
            LabelsFont.Color = clBlack
            LabelsFont.Height = -11
            LabelsFont.Name = 'Arial'
            LabelsFont.Style = [fsBold]
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
            TitleText = 'DIESEL MODE'
            Color = clBlue
            TraceLineWidth = 4
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
          end
          item
            Name = 'Channel 2'
            TitleText = 'CHANGE-OVER MODE'
            Color = clMaroon
            TraceLineWidth = 4
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
          end
          item
            Name = 'Channel 3'
            TitleText = 'GAS MODE'
            Color = clLime
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
            GridLineColor = clGray
            GridLineShowXMajors = False
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
            ZOrder = 3
            StopPercent = 100.000000000000000000
            Caption = 'H35DF MONITORING'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -19
            Font.Name = 'Arial'
            Font.Style = [fsBold]
          end>
      end
      object Panel9: TPanel
        Left = 14
        Top = 28
        Width = 59
        Height = 41
        Color = clBlue
        ParentBackground = False
        TabOrder = 1
      end
      object iLabel1: TiLabel
        Left = 79
        Top = 34
        Width = 164
        Height = 33
        Caption = 'Diesel Mode'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        WordWrap = False
      end
      object Panel13: TPanel
        Left = 249
        Top = 28
        Width = 59
        Height = 41
        Color = clMaroon
        ParentBackground = False
        TabOrder = 2
      end
      object iLabel2: TiLabel
        Left = 314
        Top = 34
        Width = 178
        Height = 33
        Caption = 'Change-Over'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        WordWrap = False
      end
      object Panel15: TPanel
        Left = 498
        Top = 28
        Width = 59
        Height = 41
        Color = clLime
        ParentBackground = False
        TabOrder = 4
      end
      object iLabel3: TiLabel
        Left = 563
        Top = 34
        Width = 132
        Height = 33
        Caption = 'Gas Mode'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        WordWrap = False
      end
    end
    object Panel1: TPanel
      Left = 0
      Top = 589
      Width = 1028
      Height = 138
      Align = alBottom
      TabOrder = 3
      ExplicitLeft = 1
      ExplicitTop = 552
      ExplicitWidth = 734
      object Panel6: TPanel
        Left = 474
        Top = 1
        Width = 183
        Height = 136
        Align = alLeft
        Caption = ' T/C:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -64
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
      object Panel8: TPanel
        Left = 1
        Top = 1
        Width = 240
        Height = 136
        Align = alLeft
        Caption = '   ENG:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -64
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
      end
      object EngRpmPanel: TPanel
        Left = 241
        Top = 1
        Width = 233
        Height = 136
        Align = alLeft
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -96
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 2
      end
      object TCRpmPanel: TPanel
        Left = 657
        Top = 1
        Width = 336
        Height = 136
        Align = alLeft
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -96
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 3
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 727
    Width = 1028
    Height = 19
    Panels = <>
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 10
    OnTimer = Timer1Timer
    Left = 480
    Top = 16
  end
end
