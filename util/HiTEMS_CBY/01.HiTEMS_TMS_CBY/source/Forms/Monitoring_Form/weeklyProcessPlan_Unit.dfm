object weeklyProcessPlanF: TweeklyProcessPlanF
  Left = 0
  Top = 0
  Caption = #44277#51221' '#54924#51032
  ClientHeight = 638
  ClientWidth = 1259
  Color = clBtnFace
  Font.Charset = HANGEUL_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = #47569#51008' '#44256#46357
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Visible = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 597
    Width = 1259
    Height = 41
    Align = alBottom
    TabOrder = 0
  end
  object AdvSG1: TAdvStringGrid
    Left = 0
    Top = 139
    Width = 1259
    Height = 458
    Cursor = crDefault
    Align = alClient
    DrawingStyle = gdsClassic
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 1
    GridLineColor = 15855083
    GridFixedLineColor = 13745060
    HoverRowCells = [hcNormal, hcSelected]
    OnGetAlignment = AdvSG1GetAlignment
    ActiveCellFont.Charset = DEFAULT_CHARSET
    ActiveCellFont.Color = clWindowText
    ActiveCellFont.Height = -11
    ActiveCellFont.Name = 'Tahoma'
    ActiveCellFont.Style = [fsBold]
    ActiveCellColor = 10344697
    ActiveCellColorTo = 6210033
    ControlLook.FixedGradientFrom = 16513526
    ControlLook.FixedGradientTo = 15260626
    ControlLook.FixedGradientHoverFrom = 15000287
    ControlLook.FixedGradientHoverTo = 14406605
    ControlLook.FixedGradientHoverMirrorFrom = 14406605
    ControlLook.FixedGradientHoverMirrorTo = 13813180
    ControlLook.FixedGradientHoverBorder = 12033927
    ControlLook.FixedGradientDownFrom = 14991773
    ControlLook.FixedGradientDownTo = 14991773
    ControlLook.FixedGradientDownMirrorFrom = 14991773
    ControlLook.FixedGradientDownMirrorTo = 14991773
    ControlLook.FixedGradientDownBorder = 14991773
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
    FilterDropDown.TextChecked = 'Checked'
    FilterDropDown.TextUnChecked = 'Unchecked'
    FilterDropDownClear = '(All)'
    FilterEdit.TypeNames.Strings = (
      'Starts with'
      'Ends with'
      'Contains'
      'Not contains'
      'Equal'
      'Not equal'
      'Clear')
    FixedRowHeight = 22
    FixedFont.Charset = DEFAULT_CHARSET
    FixedFont.Color = clWindowText
    FixedFont.Height = -11
    FixedFont.Name = 'Tahoma'
    FixedFont.Style = [fsBold]
    FloatFormat = '%.2f'
    HoverButtons.Buttons = <>
    HoverButtons.Position = hbLeftFromColumnLeft
    Look = glOffice2007
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
    SearchFooter.Color = 16513526
    SearchFooter.ColorTo = clNone
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
    SelectionColor = 6210033
    SortSettings.DefaultFormat = ssAutomatic
    Version = '7.4.4.1'
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 1259
    Height = 139
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object JvLabel1: TJvLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 1253
      Height = 28
      Align = alTop
      Caption = #44277#51221' '#54924#51032
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      Layout = tlCenter
      Margin = 1
      ParentFont = False
      Transparent = True
      HotTrackFont.Charset = ANSI_CHARSET
      HotTrackFont.Color = clWindowText
      HotTrackFont.Height = -19
      HotTrackFont.Name = #47569#51008' '#44256#46357
      HotTrackFont.Style = []
      Images = taskMain_Frm.imagelist24x24
      ImageIndex = 7
      ExplicitWidth = 115
    end
    object CurvyPanel1: TCurvyPanel
      AlignWithMargins = True
      Left = 3
      Top = 37
      Width = 1253
      Height = 99
      Align = alClient
      Rounding = 4
      TabOrder = 0
      object JvLabel2: TJvLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 80
        Height = 93
        Align = alLeft
        Alignment = taCenter
        AutoSize = False
        Caption = #44160#49353#44592#44036
        Color = 14671839
        FrameColor = clGrayText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #47569#51008' '#44256#46357
        Font.Style = [fsBold]
        Layout = tlCenter
        ParentColor = False
        ParentFont = False
        RoundedFrame = 3
        Transparent = True
        HotTrackFont.Charset = ANSI_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -13
        HotTrackFont.Name = #47569#51008' '#44256#46357
        HotTrackFont.Style = []
        ExplicitHeight = 85
      end
      object JvLabel3: TJvLabel
        AlignWithMargins = True
        Left = 353
        Top = 3
        Width = 80
        Height = 93
        Align = alLeft
        Alignment = taCenter
        AutoSize = False
        Caption = #45812#45817#44284
        Color = 14671839
        FrameColor = clGrayText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #47569#51008' '#44256#46357
        Font.Style = [fsBold]
        Layout = tlCenter
        ParentColor = False
        ParentFont = False
        RoundedFrame = 3
        Transparent = True
        HotTrackFont.Charset = ANSI_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -13
        HotTrackFont.Name = #47569#51008' '#44256#46357
        HotTrackFont.Style = []
        ExplicitHeight = 85
      end
      object JvLabel4: TJvLabel
        AlignWithMargins = True
        Left = 575
        Top = 3
        Width = 63
        Height = 93
        Align = alLeft
        Alignment = taCenter
        AutoSize = False
        Caption = #44396' '#48516
        Color = 14671839
        FrameColor = clGrayText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #47569#51008' '#44256#46357
        Font.Style = [fsBold]
        Layout = tlCenter
        ParentColor = False
        ParentFont = False
        RoundedFrame = 3
        Transparent = True
        HotTrackFont.Charset = ANSI_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -13
        HotTrackFont.Name = #47569#51008' '#44256#46357
        HotTrackFont.Style = []
        ExplicitLeft = 576
      end
      object CurvyPanel3: TCurvyPanel
        AlignWithMargins = True
        Left = 436
        Top = 3
        Width = 133
        Height = 93
        Margins.Left = 0
        Align = alLeft
        Rounding = 4
        TabOrder = 0
        object rg_team: TAdvOfficeCheckGroup
          AlignWithMargins = True
          Left = 0
          Top = 3
          Width = 130
          Height = 87
          Margins.Left = 0
          BorderStyle = bsNone
          CheckBox.Action = caCheckAll
          RoundEdges = True
          Version = '1.3.8.5'
          Align = alClient
          ParentBackground = False
          TabOrder = 0
          Ellipsis = False
        end
      end
      object CurvyPanel4: TCurvyPanel
        AlignWithMargins = True
        Left = 641
        Top = 3
        Width = 117
        Height = 93
        Margins.Left = 0
        Align = alLeft
        Rounding = 4
        TabOrder = 1
        object rg_taskType: TAdvOfficeCheckGroup
          AlignWithMargins = True
          Left = 0
          Top = 3
          Width = 114
          Height = 87
          Margins.Left = 0
          BorderStyle = bsNone
          CheckBox.Action = caCheckAll
          RoundEdges = True
          Version = '1.3.8.5'
          Align = alClient
          ParentBackground = False
          TabOrder = 0
          Items.Strings = (
            #50629#47924#51068#51221
            #49884#54744#51068#51221)
          Ellipsis = False
        end
      end
      object CurvyPanel2: TCurvyPanel
        AlignWithMargins = True
        Left = 86
        Top = 3
        Width = 261
        Height = 93
        Margins.Left = 0
        Align = alLeft
        Rounding = 4
        TabOrder = 2
        object Label4: TLabel
          Left = 124
          Top = 43
          Width = 8
          Height = 13
          Caption = '~'
        end
        object rg_period: TAdvOfficeRadioGroup
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 255
          Height = 35
          BorderStyle = bsNone
          Version = '1.3.8.5'
          Align = alTop
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = []
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
          OnClick = rg_periodClick
          Columns = 4
          ItemIndex = 1
          Items.Strings = (
            #51068#44036
            #51452#44036
            #50900#44036
            #49440#53469)
          ButtonVertAlign = tlCenter
          Ellipsis = False
        end
        object dt_end: TpjhPlannerDatePicker
          Left = 140
          Top = 38
          Width = 115
          Height = 25
          EmptyTextStyle = []
          Flat = False
          LabelFont.Charset = DEFAULT_CHARSET
          LabelFont.Color = clWindowText
          LabelFont.Height = -11
          LabelFont.Name = 'Tahoma'
          LabelFont.Style = []
          Lookup.Font.Charset = DEFAULT_CHARSET
          Lookup.Font.Color = clWindowText
          Lookup.Font.Height = -11
          Lookup.Font.Name = 'Arial'
          Lookup.Font.Style = []
          Lookup.Separator = ';'
          AutoSize = False
          Color = clWindow
          ImeName = 'Microsoft IME 2010'
          ReadOnly = False
          TabOrder = 1
          Text = '2014-07-08'
          Visible = True
          Version = '1.8.3.0'
          ButtonStyle = bsDropDown
          ButtonWidth = 16
          Etched = False
          Glyph.Data = {
            DA020000424DDA0200000000000036000000280000000D0000000D0000000100
            200000000000A402000000000000000000000000000000000000F0F0F000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
            F00000000000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F000000000000000000000000000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
            F0000000000000000000000000000000000000000000F0F0F000F0F0F000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F0000000000000000000000000000000
            0000000000000000000000000000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000}
          Calendar = cal44_.Owner
          HideCalendarAfterSelection = True
          DateTime = 41828.410963842590000000
          object cal44_: TPlannerCalendar
            Left = 0
            Top = 0
            Width = 180
            Height = 180
            EventDayColor = clBlack
            EventFont.Charset = DEFAULT_CHARSET
            EventFont.Color = clWindowText
            EventFont.Height = -11
            EventFont.Name = 'Tahoma'
            EventFont.Style = [fsBold]
            EventMarkerColor = clYellow
            EventMarkerShape = evsNone
            BackgroundPosition = bpTiled
            BevelOuter = bvNone
            BorderWidth = 1
            Look = lookFlat
            DateDownColor = clNone
            DateHoverColor = clNone
            DayFont.Charset = DEFAULT_CHARSET
            DayFont.Color = clWindowText
            DayFont.Height = -11
            DayFont.Name = 'Tahoma'
            DayFont.Style = []
            WeekFont.Charset = DEFAULT_CHARSET
            WeekFont.Color = clWindowText
            WeekFont.Height = -11
            WeekFont.Name = 'Tahoma'
            WeekFont.Style = []
            WeekName = 'Wk'
            TextColor = clBlack
            SelectColor = clTeal
            SelectFontColor = clWhite
            InActiveColor = clGray
            HeaderColor = clNone
            FocusColor = clHighlight
            InversColor = clTeal
            WeekendColor = clRed
            NameOfDays.Monday = #50900
            NameOfDays.Tuesday = #54868
            NameOfDays.Wednesday = #49688
            NameOfDays.Thursday = #47785
            NameOfDays.Friday = #44552
            NameOfDays.Saturday = #53664
            NameOfDays.Sunday = #51068
            NameOfMonths.January = '1'
            NameOfMonths.February = '2'
            NameOfMonths.March = '3'
            NameOfMonths.April = '4'
            NameOfMonths.May = '5'
            NameOfMonths.June = '6'
            NameOfMonths.July = '7'
            NameOfMonths.August = '8'
            NameOfMonths.September = '9'
            NameOfMonths.October = '10'
            NameOfMonths.November = '11'
            NameOfMonths.December = '12'
            NameOfMonths.UseIntlNames = True
            ShowDaysBefore = False
            ShowDaysAfter = False
            ShowGotoToday = True
            StartDay = 7
            TodayFormat = '"'#50724#45720':"  YYYY'#45380' M'#50900' D'#51068
            TodayStyle = tsFlat
            Day = 8
            Month = 7
            Year = 2014
            ShowHint = False
            ParentShowHint = False
            TabOrder = 0
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            CaptionColor = clNone
            CaptionTextColor = clBlack
            LineColor = clGray
            Line3D = True
            GradientStartColor = clWhite
            GradientEndColor = clBtnFace
            GradientDirection = gdVertical
            MonthGradientStartColor = clNone
            MonthGradientEndColor = clNone
            MonthGradientDirection = gdHorizontal
            HintPrevYear = 'Previous Year'
            HintPrevMonth = 'Previous Month'
            HintNextMonth = 'Next Month'
            HintNextYear = 'Next Year'
            Version = '2.1.0.1'
          end
        end
        object dt_begin: TpjhPlannerDatePicker
          Left = 6
          Top = 38
          Width = 115
          Height = 25
          EmptyTextStyle = []
          Flat = False
          LabelFont.Charset = DEFAULT_CHARSET
          LabelFont.Color = clWindowText
          LabelFont.Height = -11
          LabelFont.Name = 'Tahoma'
          LabelFont.Style = []
          Lookup.Font.Charset = DEFAULT_CHARSET
          Lookup.Font.Color = clWindowText
          Lookup.Font.Height = -11
          Lookup.Font.Name = 'Arial'
          Lookup.Font.Style = []
          Lookup.Separator = ';'
          AutoSize = False
          Color = clWindow
          ImeName = 'Microsoft IME 2010'
          ReadOnly = False
          TabOrder = 2
          Text = '2014-07-08'
          Visible = True
          Version = '1.8.3.0'
          ButtonStyle = bsDropDown
          ButtonWidth = 16
          Etched = False
          Glyph.Data = {
            DA020000424DDA0200000000000036000000280000000D0000000D0000000100
            200000000000A402000000000000000000000000000000000000F0F0F000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
            F00000000000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F000000000000000000000000000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
            F0000000000000000000000000000000000000000000F0F0F000F0F0F000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F0000000000000000000000000000000
            0000000000000000000000000000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000}
          Calendar = cal44_.Owner
          HideCalendarAfterSelection = True
          DateTime = 41828.410963842590000000
          object cal44_: TPlannerCalendar
            Left = 0
            Top = 0
            Width = 180
            Height = 180
            EventDayColor = clBlack
            EventFont.Charset = DEFAULT_CHARSET
            EventFont.Color = clWindowText
            EventFont.Height = -11
            EventFont.Name = 'Tahoma'
            EventFont.Style = [fsBold]
            EventMarkerColor = clYellow
            EventMarkerShape = evsNone
            BackgroundPosition = bpTiled
            BevelOuter = bvNone
            BorderWidth = 1
            Look = lookFlat
            DateDownColor = clNone
            DateHoverColor = clNone
            DayFont.Charset = DEFAULT_CHARSET
            DayFont.Color = clWindowText
            DayFont.Height = -11
            DayFont.Name = 'Tahoma'
            DayFont.Style = []
            WeekFont.Charset = DEFAULT_CHARSET
            WeekFont.Color = clWindowText
            WeekFont.Height = -11
            WeekFont.Name = 'Tahoma'
            WeekFont.Style = []
            WeekName = 'Wk'
            TextColor = clBlack
            SelectColor = clTeal
            SelectFontColor = clWhite
            InActiveColor = clGray
            HeaderColor = clNone
            FocusColor = clHighlight
            InversColor = clTeal
            WeekendColor = clRed
            NameOfDays.Monday = #50900
            NameOfDays.Tuesday = #54868
            NameOfDays.Wednesday = #49688
            NameOfDays.Thursday = #47785
            NameOfDays.Friday = #44552
            NameOfDays.Saturday = #53664
            NameOfDays.Sunday = #51068
            NameOfMonths.January = '1'
            NameOfMonths.February = '2'
            NameOfMonths.March = '3'
            NameOfMonths.April = '4'
            NameOfMonths.May = '5'
            NameOfMonths.June = '6'
            NameOfMonths.July = '7'
            NameOfMonths.August = '8'
            NameOfMonths.September = '9'
            NameOfMonths.October = '10'
            NameOfMonths.November = '11'
            NameOfMonths.December = '12'
            NameOfMonths.UseIntlNames = True
            ShowDaysBefore = False
            ShowDaysAfter = False
            ShowGotoToday = True
            StartDay = 7
            TodayFormat = '"'#50724#45720':"  YYYY'#45380' M'#50900' D'#51068
            TodayStyle = tsFlat
            Day = 8
            Month = 7
            Year = 2014
            ShowHint = False
            ParentShowHint = False
            TabOrder = 0
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            CaptionColor = clNone
            CaptionTextColor = clBlack
            LineColor = clGray
            Line3D = True
            GradientStartColor = clWhite
            GradientEndColor = clBtnFace
            GradientDirection = gdVertical
            MonthGradientStartColor = clNone
            MonthGradientEndColor = clNone
            MonthGradientDirection = gdHorizontal
            HintPrevYear = 'Previous Year'
            HintPrevMonth = 'Previous Month'
            HintNextMonth = 'Next Month'
            HintNextYear = 'Next Year'
            Version = '2.1.0.1'
          end
        end
      end
      object AeroButton1: TAeroButton
        AlignWithMargins = True
        Left = 974
        Top = 3
        Width = 90
        Height = 93
        Margins.Right = 0
        ImageIndex = 19
        Images = taskMain_Frm.ImageList32x32
        ImagePos = ipTop
        Version = '1.0.0.1'
        Align = alRight
        Caption = #50641#49472#51200#51109
        TabOrder = 3
      end
      object AeroButton3: TAeroButton
        AlignWithMargins = True
        Left = 1067
        Top = 3
        Width = 90
        Height = 93
        Margins.Right = 0
        ImageIndex = 17
        Images = taskMain_Frm.ImageList32x32
        ImagePos = ipTop
        Version = '1.0.0.1'
        Align = alRight
        Caption = #51312#54924#54616#44592
        TabOrder = 4
      end
      object AeroButton2: TAeroButton
        AlignWithMargins = True
        Left = 1160
        Top = 3
        Width = 90
        Height = 93
        ImageIndex = 20
        Images = taskMain_Frm.ImageList32x32
        ImagePos = ipTop
        Version = '1.0.0.1'
        Align = alRight
        Caption = #45803#44592
        ModalResult = 8
        TabOrder = 5
        OnClick = AeroButton2Click
      end
      object Button3: TButton
        Left = 764
        Top = 56
        Width = 101
        Height = 40
        Caption = #49440#53469' '#44048#52628#44592
        TabOrder = 6
      end
    end
    object Button2: TButton
      Left = 224
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Make Header'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button1: TButton
      Left = 320
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Merge Cells'
      TabOrder = 2
    end
  end
end
