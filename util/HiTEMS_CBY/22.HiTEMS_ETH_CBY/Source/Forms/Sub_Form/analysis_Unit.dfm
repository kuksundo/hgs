object analysis_Frm: Tanalysis_Frm
  Left = 0
  Top = 0
  Caption = 'analysis_Frm'
  ClientHeight = 687
  ClientWidth = 982
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object NxSplitter1: TNxSplitter
    Left = 245
    Top = 0
    Width = 6
    Height = 668
    ExplicitHeight = 700
  end
  object NxHeaderPanel1: TNxHeaderPanel
    Left = 0
    Top = 0
    Height = 668
    Align = alLeft
    Caption = 'Parameter'
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -11
    HeaderFont.Name = 'Tahoma'
    HeaderFont.Style = []
    ParentHeaderFont = False
    TabOrder = 0
    FullWidth = 245
    object CheckListBox1: TCheckListBox
      Left = 0
      Top = 27
      Width = 243
      Height = 639
      OnClickCheck = CheckListBox1ClickCheck
      Align = alClient
      ImeName = 'Microsoft Office IME 2007'
      ItemHeight = 13
      TabOrder = 0
      OnMouseDown = CheckListBox1MouseDown
    end
  end
  object AdvOfficeStatusBar1: TAdvOfficeStatusBar
    Left = 0
    Top = 668
    Width = 982
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
    URLColor = clBlue
    Version = '1.5.0.0'
  end
  object Panel1: TPanel
    Left = 251
    Top = 0
    Width = 731
    Height = 668
    Align = alClient
    TabOrder = 2
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 729
      Height = 27
      Align = alTop
      Color = 5066061
      ParentBackground = False
      TabOrder = 0
      object Label1: TLabel
        AlignWithMargins = True
        Left = 6
        Top = 4
        Width = 48
        Height = 17
        Margins.Left = 5
        Align = alLeft
        Caption = 'X-Axis :'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = #47569#51008' '#44256#46357
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object iPlot1: TiXYPlot
      Left = 1
      Top = 28
      Width = 729
      Height = 639
      OnDragDrop = iPlot1DragDrop
      OnDragOver = iPlot1DragOver
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
      BackGroundColor = clWhite
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
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
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
          LabelsMargin = 0.250000000000000000
          LabelsFont.Charset = ANSI_CHARSET
          LabelsFont.Color = clBlack
          LabelsFont.Height = -11
          LabelsFont.Name = #47569#51008' '#44256#46357
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
          GridLinesVisible = False
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
          LabelsFont.Charset = ANSI_CHARSET
          LabelsFont.Color = clBlack
          LabelsFont.Height = -11
          LabelsFont.Name = #47569#51008' '#44256#46357
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
  object PopupMenu1: TPopupMenu
    Left = 480
    Top = 344
    object AddnewXValue1: TMenuItem
      Caption = 'Add new X-Value'
      OnClick = AddnewXValue1Click
    end
    object AddnewYValue1: TMenuItem
      Caption = 'Add new Y-Value'
      OnClick = AddnewYValue1Click
    end
    object Addexist1: TMenuItem
      Caption = 'Add exist Y-Value'
    end
  end
end
