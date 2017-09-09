object LocalSheet_Frm: TLocalSheet_Frm
  Left = 0
  Top = 0
  BorderIcons = [biMinimize, biMaximize]
  Caption = #48372#44256#49436#52636#47141'-'#47196#52972#49884#53944#51077#47141
  ClientHeight = 457
  ClientWidth = 714
  Color = clBtnFace
  Constraints.MaxWidth = 722
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = #47569#51008' '#44256#46357
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object AdvOfficeStatusBar1: TAdvOfficeStatusBar
    Left = 0
    Top = 438
    Width = 714
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
    ExplicitTop = 439
    ExplicitWidth = 769
  end
  object NxHeaderPanel1: TNxHeaderPanel
    Left = 0
    Top = 235
    Width = 714
    Height = 167
    Align = alBottom
    Caption = 'P-MAX'
    HeaderFont.Charset = HANGEUL_CHARSET
    HeaderFont.Color = clInfoText
    HeaderFont.Height = -16
    HeaderFont.Name = #47569#51008' '#44256#46357
    HeaderFont.Style = [fsBold]
    ParentHeaderFont = False
    TabOrder = 1
    ExplicitTop = 236
    FullWidth = 769
    object Panel2: TPanel
      Left = 0
      Top = 25
      Width = 712
      Height = 65
      Align = alTop
      Caption = 'Panel2'
      TabOrder = 0
      object AGrid: TAdvStringGrid
        AlignWithMargins = True
        Left = 111
        Top = 4
        Width = 598
        Height = 57
        Cursor = crDefault
        Margins.Left = 0
        Align = alClient
        ColCount = 9
        DefaultRowHeight = 30
        DrawingStyle = gdsClassic
        FixedCols = 0
        RowCount = 2
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
        OnKeyDown = AGridKeyDown
        OnSelectCell = AGridSelectCell
        HoverRowCells = [hcNormal, hcSelected]
        OnGetAlignment = AGridGetAlignment
        OnCanEditCell = AGridCanEditCell
        ActiveCellFont.Charset = DEFAULT_CHARSET
        ActiveCellFont.Color = clWindowText
        ActiveCellFont.Height = -11
        ActiveCellFont.Name = 'Tahoma'
        ActiveCellFont.Style = [fsBold]
        ColumnHeaders.Strings = (
          'A1'
          'A2'
          'A3'
          'A4'
          'A5'
          'A6'
          'A7'
          'A8'
          'A9')
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
        FilterEdit.TypeNames.Strings = (
          'Starts with'
          'Ends with'
          'Contains'
          'Not contains'
          'Equal'
          'Not equal'
          'Clear')
        FixedRowHeight = 23
        FixedFont.Charset = DEFAULT_CHARSET
        FixedFont.Color = clWindowText
        FixedFont.Height = -11
        FixedFont.Name = 'Tahoma'
        FixedFont.Style = [fsBold]
        FloatFormat = '%.2f'
        HoverButtons.Buttons = <>
        HoverButtons.Position = hbLeftFromColumnLeft
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
        RowHeights = (
          23
          30)
      end
      object Panel3: TPanel
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 104
        Height = 57
        Align = alLeft
        BevelOuter = bvNone
        Caption = 'A-BANK'
        Color = 16763594
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #47569#51008' '#44256#46357
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 1
      end
    end
    object Panel4: TPanel
      Left = 0
      Top = 90
      Width = 712
      Height = 75
      Align = alClient
      Caption = 'Panel2'
      TabOrder = 1
      object BGRID: TAdvStringGrid
        AlignWithMargins = True
        Left = 111
        Top = 4
        Width = 598
        Height = 68
        Cursor = crDefault
        Margins.Left = 0
        Align = alClient
        ColCount = 9
        DefaultRowHeight = 30
        DrawingStyle = gdsClassic
        FixedCols = 0
        RowCount = 2
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
        OnKeyDown = BGRIDKeyDown
        OnSelectCell = BGRIDSelectCell
        HoverRowCells = [hcNormal, hcSelected]
        OnGetAlignment = BGRIDGetAlignment
        OnCanEditCell = BGRIDCanEditCell
        ActiveCellFont.Charset = DEFAULT_CHARSET
        ActiveCellFont.Color = clWindowText
        ActiveCellFont.Height = -11
        ActiveCellFont.Name = 'Tahoma'
        ActiveCellFont.Style = [fsBold]
        ColumnHeaders.Strings = (
          'B1'
          'B2'
          'B3'
          'B4'
          'B5'
          'B6'
          'B7'
          'B8'
          'B9')
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
        FilterEdit.TypeNames.Strings = (
          'Starts with'
          'Ends with'
          'Contains'
          'Not contains'
          'Equal'
          'Not equal'
          'Clear')
        FixedRowHeight = 23
        FixedFont.Charset = DEFAULT_CHARSET
        FixedFont.Color = clWindowText
        FixedFont.Height = -11
        FixedFont.Name = 'Tahoma'
        FixedFont.Style = [fsBold]
        FloatFormat = '%.2f'
        HoverButtons.Buttons = <>
        HoverButtons.Position = hbLeftFromColumnLeft
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
        RowHeights = (
          23
          30)
      end
      object Panel5: TPanel
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 104
        Height = 68
        Align = alLeft
        BevelOuter = bvNone
        Caption = 'B-BANK'
        Color = 16763594
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #47569#51008' '#44256#46357
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 1
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 402
    Width = 714
    Height = 36
    Align = alBottom
    TabOrder = 2
    ExplicitTop = 403
    object Button1: TButton
      AlignWithMargins = True
      Left = 612
      Top = 4
      Width = 98
      Height = 29
      Align = alRight
      Caption = #45803' '#44592
      Enabled = False
      ImageIndex = 2
      ImageMargins.Left = 10
      Images = ImageList1
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      AlignWithMargins = True
      Left = 511
      Top = 4
      Width = 98
      Height = 29
      Margins.Right = 0
      Align = alRight
      Caption = #51201' '#50857
      Enabled = False
      ImageIndex = 1
      ImageMargins.Left = 10
      Images = ImageList1
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      AlignWithMargins = True
      Left = 410
      Top = 4
      Width = 98
      Height = 29
      Margins.Right = 0
      Align = alRight
      Caption = #52488#44592#54868
      ImageIndex = 0
      ImageMargins.Left = 10
      Images = ImageList1
      TabOrder = 2
      OnClick = Button3Click
    end
    object StayOnTopCB: TCheckBox
      Left = 10
      Top = 5
      Width = 88
      Height = 31
      Caption = 'Stay On Top'
      TabOrder = 3
      OnClick = StayOnTopCBClick
    end
  end
  object Panel6: TPanel
    Left = 0
    Top = 0
    Width = 714
    Height = 29
    Margins.Bottom = 0
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 3
    object mTime: TAdvDateTimePicker
      AlignWithMargins = True
      Left = 252
      Top = 3
      Width = 102
      Height = 26
      Margins.Left = 0
      Margins.Bottom = 0
      Align = alLeft
      Date = 40906.567627314810000000
      Format = 'HH:mm'
      Time = 40906.567627314810000000
      DoubleBuffered = True
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      ImeName = 'Microsoft Office IME 2007'
      Kind = dkTime
      ParentDoubleBuffered = False
      ParentFont = False
      TabOrder = 0
      TabStop = True
      BorderStyle = bsSingle
      Ctl3D = True
      DateTime = 40906.567627314810000000
      Version = '1.2.2.0'
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
      ExplicitHeight = 23
    end
    object Panel7: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 246
      Height = 26
      Margins.Bottom = 0
      Align = alLeft
      Caption = #44228#52769#49884#51089#49884#44036
      Color = 12385278
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 1
    end
  end
  object Panel8: TPanel
    Left = 0
    Top = 29
    Width = 714
    Height = 206
    Margins.Top = 0
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 4
    ExplicitHeight = 207
    object Panel9: TPanel
      Left = 0
      Top = 0
      Width = 357
      Height = 206
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitHeight = 207
      object Panel11: TPanel
        Left = 0
        Top = 0
        Width = 357
        Height = 29
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object Panel16: TPanel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 246
          Height = 26
          Margins.Bottom = 0
          Align = alLeft
          Caption = #50644#51652' '#52509' '#50868#51204#49884#44036' (@ECS)'
          Color = 16763594
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
        end
        object runTime: TNxNumberEdit
          AlignWithMargins = True
          Left = 252
          Top = 3
          Width = 102
          Height = 26
          Margins.Left = 0
          Margins.Bottom = 0
          Align = alClient
          Alignment = taCenter
          TabOrder = 1
          Text = '0'
          Precision = 0
          ExplicitHeight = 28
        end
      end
      object Panel12: TPanel
        Left = 0
        Top = 29
        Width = 357
        Height = 177
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        ExplicitHeight = 178
        object Panel13: TPanel
          Left = 0
          Top = 0
          Width = 357
          Height = 87
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object Panel14: TPanel
            Left = 89
            Top = 0
            Width = 268
            Height = 87
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            object Panel18: TPanel
              Left = 0
              Top = 0
              Width = 268
              Height = 29
              Align = alTop
              BevelOuter = bvNone
              TabOrder = 0
              ExplicitWidth = 267
              object Panel21: TPanel
                AlignWithMargins = True
                Left = 0
                Top = 3
                Width = 160
                Height = 26
                Margins.Left = 0
                Margins.Bottom = 0
                Align = alLeft
                Caption = 'Temperature ['#176'C]'
                Color = 16763594
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = #47569#51008' '#44256#46357
                Font.Style = [fsBold]
                ParentBackground = False
                ParentFont = False
                TabOrder = 0
              end
              object ambTemp: TNxNumberEdit
                AlignWithMargins = True
                Left = 163
                Top = 3
                Width = 102
                Height = 26
                Margins.Left = 0
                Margins.Bottom = 0
                Align = alClient
                Alignment = taCenter
                TabOrder = 1
                Text = '0'
                Precision = 0
                ExplicitHeight = 28
              end
            end
            object Panel19: TPanel
              Left = 0
              Top = 29
              Width = 268
              Height = 29
              Align = alTop
              BevelOuter = bvNone
              TabOrder = 1
              ExplicitWidth = 267
              object Panel22: TPanel
                AlignWithMargins = True
                Left = 0
                Top = 3
                Width = 160
                Height = 26
                Margins.Left = 0
                Margins.Bottom = 0
                Align = alLeft
                Caption = 'Pressure [mbar]'
                Color = 16763594
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = #47569#51008' '#44256#46357
                Font.Style = [fsBold]
                ParentBackground = False
                ParentFont = False
                TabOrder = 0
              end
              object ambPress: TNxNumberEdit
                AlignWithMargins = True
                Left = 163
                Top = 3
                Width = 102
                Height = 26
                Margins.Left = 0
                Margins.Bottom = 0
                Align = alClient
                Alignment = taCenter
                TabOrder = 1
                Text = '0'
                Precision = 0
                ExplicitHeight = 28
              end
            end
            object ambHum: TPanel
              Left = 0
              Top = 58
              Width = 268
              Height = 29
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 2
              ExplicitWidth = 267
              object Panel23: TPanel
                AlignWithMargins = True
                Left = 0
                Top = 3
                Width = 160
                Height = 26
                Margins.Left = 0
                Margins.Bottom = 0
                Align = alLeft
                Caption = 'Humidity [%]'
                Color = 16763594
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = #47569#51008' '#44256#46357
                Font.Style = [fsBold]
                ParentBackground = False
                ParentFont = False
                TabOrder = 0
                ExplicitHeight = 27
              end
              object ambHumidity: TNxNumberEdit
                AlignWithMargins = True
                Left = 163
                Top = 3
                Width = 102
                Height = 26
                Margins.Left = 0
                Margins.Bottom = 0
                Align = alClient
                Alignment = taCenter
                TabOrder = 1
                Text = '0'
                Precision = 0
                ExplicitHeight = 29
              end
            end
          end
          object Panel15: TPanel
            Left = 0
            Top = 0
            Width = 89
            Height = 87
            Align = alLeft
            BevelOuter = bvNone
            TabOrder = 1
            object Panel17: TPanel
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 83
              Height = 84
              Margins.Bottom = 0
              Align = alClient
              Caption = #45824#44592
              Color = 16763594
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = #47569#51008' '#44256#46357
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 0
            end
          end
        end
        object Panel24: TPanel
          Left = 0
          Top = 87
          Width = 357
          Height = 58
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          object Panel25: TPanel
            Left = 89
            Top = 0
            Width = 268
            Height = 58
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            object Panel28: TPanel
              Left = 0
              Top = 0
              Width = 268
              Height = 29
              Align = alTop
              BevelOuter = bvNone
              TabOrder = 0
              ExplicitWidth = 267
              object Panel29: TPanel
                AlignWithMargins = True
                Left = 0
                Top = 3
                Width = 160
                Height = 26
                Margins.Left = 0
                Margins.Bottom = 0
                Align = alLeft
                Caption = #50517#47141' [barg]'
                Color = 16763594
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = #47569#51008' '#44256#46357
                Font.Style = [fsBold]
                ParentBackground = False
                ParentFont = False
                TabOrder = 0
              end
              object compPress: TNxNumberEdit
                AlignWithMargins = True
                Left = 163
                Top = 3
                Width = 102
                Height = 26
                Margins.Left = 0
                Margins.Bottom = 0
                Align = alClient
                Alignment = taCenter
                TabOrder = 1
                Text = '0'
                Precision = 0
                ExplicitHeight = 28
              end
            end
            object Panel30: TPanel
              Left = 0
              Top = 29
              Width = 268
              Height = 29
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 1
              ExplicitWidth = 267
              object Panel31: TPanel
                AlignWithMargins = True
                Left = 0
                Top = 3
                Width = 160
                Height = 26
                Margins.Left = 0
                Margins.Bottom = 0
                Align = alLeft
                Caption = #50728#46020' ['#176'C]'
                Color = 16763594
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = #47569#51008' '#44256#46357
                Font.Style = [fsBold]
                ParentBackground = False
                ParentFont = False
                TabOrder = 0
              end
              object compTemp: TNxNumberEdit
                AlignWithMargins = True
                Left = 163
                Top = 3
                Width = 102
                Height = 26
                Margins.Left = 0
                Margins.Bottom = 0
                Align = alClient
                Alignment = taCenter
                TabOrder = 1
                Text = '0'
                Precision = 0
                ExplicitHeight = 28
              end
            end
          end
          object Panel32: TPanel
            Left = 0
            Top = 0
            Width = 89
            Height = 58
            Align = alLeft
            BevelOuter = bvNone
            TabOrder = 1
            object Panel33: TPanel
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 83
              Height = 55
              Margins.Bottom = 0
              Align = alClient
              Caption = #52980#54532#47112#49492' '#51204#45800
              Color = 16763594
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = #47569#51008' '#44256#46357
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 0
            end
          end
        end
        object Panel26: TPanel
          Left = 0
          Top = 145
          Width = 357
          Height = 32
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 2
          ExplicitHeight = 33
          object Panel27: TPanel
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 246
            Height = 26
            Align = alLeft
            Caption = #49468#53944#47092#53224#47084' '#54644#49688#50517#47141' [barg]'
            Color = 16763594
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #47569#51008' '#44256#46357
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 0
            ExplicitHeight = 28
          end
          object seaWater: TNxNumberEdit
            AlignWithMargins = True
            Left = 252
            Top = 3
            Width = 102
            Height = 26
            Margins.Left = 0
            Align = alClient
            Alignment = taCenter
            TabOrder = 1
            Text = '0'
            Precision = 0
            ExplicitHeight = 30
          end
        end
      end
    end
    object Panel34: TPanel
      Left = 357
      Top = 0
      Width = 357
      Height = 206
      Align = alClient
      BevelOuter = bvNone
      BevelWidth = 3
      TabOrder = 1
      ExplicitHeight = 207
      object Panel37: TPanel
        Left = 0
        Top = 0
        Width = 357
        Height = 206
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitWidth = 358
        ExplicitHeight = 207
        object Panel38: TPanel
          Left = 0
          Top = 0
          Width = 357
          Height = 87
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          ExplicitWidth = 358
          object Panel39: TPanel
            Left = 89
            Top = 0
            Width = 268
            Height = 87
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            ExplicitWidth = 269
            object Panel40: TPanel
              Left = 0
              Top = 0
              Width = 268
              Height = 29
              Align = alTop
              BevelOuter = bvNone
              TabOrder = 0
              object Panel41: TPanel
                AlignWithMargins = True
                Left = 0
                Top = 3
                Width = 160
                Height = 26
                Margins.Left = 0
                Margins.Bottom = 0
                Align = alLeft
                Caption = 'GRU inlet press.[barg]'
                Color = 16763594
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = #47569#51008' '#44256#46357
                Font.Style = [fsBold]
                ParentBackground = False
                ParentFont = False
                TabOrder = 0
              end
              object inlet: TNxNumberEdit
                AlignWithMargins = True
                Left = 163
                Top = 3
                Width = 102
                Height = 26
                Margins.Left = 0
                Margins.Bottom = 0
                Align = alClient
                Alignment = taCenter
                TabOrder = 1
                Text = '0'
                Precision = 0
                ExplicitWidth = 103
                ExplicitHeight = 28
              end
            end
            object Panel42: TPanel
              Left = 0
              Top = 29
              Width = 268
              Height = 29
              Align = alTop
              BevelOuter = bvNone
              TabOrder = 1
              object Panel43: TPanel
                AlignWithMargins = True
                Left = 0
                Top = 3
                Width = 160
                Height = 26
                Margins.Left = 0
                Margins.Bottom = 0
                Align = alLeft
                Caption = 'Main chamber [barg]'
                Color = 16763594
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = #47569#51008' '#44256#46357
                Font.Style = [fsBold]
                ParentBackground = False
                ParentFont = False
                TabOrder = 0
              end
              object mChamber: TNxNumberEdit
                AlignWithMargins = True
                Left = 163
                Top = 3
                Width = 102
                Height = 26
                Margins.Left = 0
                Margins.Bottom = 0
                Align = alClient
                Alignment = taCenter
                TabOrder = 1
                Text = '0'
                Precision = 0
                ExplicitWidth = 103
                ExplicitHeight = 28
              end
            end
            object Panel44: TPanel
              Left = 0
              Top = 58
              Width = 268
              Height = 29
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 2
              object Panel45: TPanel
                AlignWithMargins = True
                Left = 0
                Top = 3
                Width = 160
                Height = 26
                Margins.Left = 0
                Margins.Bottom = 0
                Align = alLeft
                Caption = 'Pre-chamber [barg]'
                Color = 16763594
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = #47569#51008' '#44256#46357
                Font.Style = [fsBold]
                ParentBackground = False
                ParentFont = False
                TabOrder = 0
                ExplicitHeight = 27
              end
              object pChamber: TNxNumberEdit
                AlignWithMargins = True
                Left = 163
                Top = 3
                Width = 102
                Height = 26
                Margins.Left = 0
                Margins.Bottom = 0
                Align = alClient
                Alignment = taCenter
                TabOrder = 1
                Text = '0'
                Precision = 0
                ExplicitWidth = 103
                ExplicitHeight = 29
              end
            end
          end
          object Panel46: TPanel
            Left = 0
            Top = 0
            Width = 89
            Height = 87
            Align = alLeft
            BevelOuter = bvNone
            TabOrder = 1
            object Panel47: TPanel
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 83
              Height = 84
              Margins.Bottom = 0
              Align = alClient
              Color = 16763594
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = #47569#51008' '#44256#46357
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 0
              object Label1: TLabel
                Left = 19
                Top = 20
                Width = 48
                Height = 45
                Alignment = taCenter
                Caption = #44032#49828#47112#44516'  '#47112#51060#53552' '#50517#47141
                WordWrap = True
              end
            end
          end
        end
        object Panel48: TPanel
          Left = 0
          Top = 87
          Width = 357
          Height = 58
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          ExplicitWidth = 358
          object Panel49: TPanel
            Left = 89
            Top = 0
            Width = 268
            Height = 58
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            ExplicitWidth = 269
            object Panel50: TPanel
              Left = 0
              Top = 0
              Width = 268
              Height = 29
              Align = alTop
              BevelOuter = bvNone
              TabOrder = 0
              object Panel51: TPanel
                AlignWithMargins = True
                Left = 0
                Top = 3
                Width = 160
                Height = 26
                Margins.Left = 0
                Margins.Bottom = 0
                Align = alLeft
                Caption = 'Volume [Nm'#179']'
                Color = 16763594
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = #47569#51008' '#44256#46357
                Font.Style = [fsBold]
                ParentBackground = False
                ParentFont = False
                TabOrder = 0
              end
              object gVolume: TNxNumberEdit
                AlignWithMargins = True
                Left = 163
                Top = 3
                Width = 102
                Height = 26
                Margins.Left = 0
                Margins.Bottom = 0
                Align = alClient
                Alignment = taCenter
                TabOrder = 1
                Text = '0'
                Precision = 0
                ExplicitWidth = 103
                ExplicitHeight = 28
              end
            end
            object Panel52: TPanel
              Left = 0
              Top = 29
              Width = 268
              Height = 29
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 1
              object Panel53: TPanel
                AlignWithMargins = True
                Left = 0
                Top = 3
                Width = 160
                Height = 26
                Margins.Left = 0
                Margins.Bottom = 0
                Align = alLeft
                Caption = 'time duration [sec]'
                Color = 16763594
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = #47569#51008' '#44256#46357
                Font.Style = [fsBold]
                ParentBackground = False
                ParentFont = False
                TabOrder = 0
              end
              object gDuration: TNxNumberEdit
                AlignWithMargins = True
                Left = 163
                Top = 3
                Width = 102
                Height = 26
                Margins.Left = 0
                Margins.Bottom = 0
                Align = alClient
                Alignment = taCenter
                TabOrder = 1
                Text = '0'
                Precision = 0
                ExplicitWidth = 103
                ExplicitHeight = 28
              end
            end
          end
          object Panel54: TPanel
            Left = 0
            Top = 0
            Width = 89
            Height = 58
            Align = alLeft
            BevelOuter = bvNone
            TabOrder = 1
            object Panel55: TPanel
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 83
              Height = 55
              Margins.Bottom = 0
              Align = alClient
              Color = 16763594
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = #47569#51008' '#44256#46357
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 0
              object Label2: TLabel
                Left = 17
                Top = 11
                Width = 52
                Height = 30
                Alignment = taCenter
                Caption = 'Gas Flow Meas.'
                WordWrap = True
              end
            end
          end
        end
        object Panel56: TPanel
          Left = 0
          Top = 145
          Width = 357
          Height = 32
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 2
          ExplicitWidth = 358
          object Panel57: TPanel
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 246
            Height = 26
            Align = alLeft
            Caption = 'Chamber '#45236#50517
            Color = 16763594
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #47569#51008' '#44256#46357
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 0
            ExplicitHeight = 27
          end
          object chamberIn: TNxNumberEdit
            AlignWithMargins = True
            Left = 252
            Top = 3
            Width = 102
            Height = 26
            Margins.Left = 0
            Align = alClient
            Alignment = taCenter
            TabOrder = 1
            Text = '0'
            Precision = 0
            ExplicitWidth = 103
            ExplicitHeight = 29
          end
        end
        object Panel10: TPanel
          Left = 0
          Top = 177
          Width = 357
          Height = 29
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 3
          ExplicitWidth = 358
          ExplicitHeight = 30
          object Panel35: TPanel
            AlignWithMargins = True
            Left = 3
            Top = 0
            Width = 246
            Height = 26
            Margins.Top = 0
            Align = alLeft
            Caption = 'LO '#47112#48296
            Color = 16763594
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #47569#51008' '#44256#46357
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 0
            ExplicitHeight = 27
          end
          object loLevel: TNxNumberEdit
            AlignWithMargins = True
            Left = 252
            Top = 0
            Width = 102
            Height = 26
            Margins.Left = 0
            Margins.Top = 0
            Align = alClient
            Alignment = taCenter
            TabOrder = 1
            Text = '0'
            Precision = 0
            ExplicitWidth = 103
            ExplicitHeight = 29
          end
        end
      end
    end
  end
  object ImageList1: TImageList
    ColorDepth = cd32Bit
    Left = 8
    Top = 392
    Bitmap = {
      494C010105000A00080010001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000020305230F142F7D293D8CDB3049ABF32C44AAF3223987DB0B132C7D0202
      0423000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000080A
      16533645A1E63C52CCFF757AE8FF8E91EEFF8E91EEFF7178E4FF334DC0FF233C
      94E6050914530000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000090A17534351
      BAF45C65E0FFA0A5F5FF7E85EFFF5B63E9FF595DE7FF7D83EEFF9D9FF4FF515D
      D7FF2744A7F40509145300000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000002030522434EA7E5616B
      E3FFA0ABF5FF545FECFF505CEAFF4D59E9FF4E59E6FF4C56E6FF5056E6FF9DA1
      F4FF5460D6FF223C94E502020422000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000001618357E4B56DBFFA1AA
      F6FF5664F0FF5266EEFF4D59E9FF4D59E9FF4D59E9FF4D59E9FF4C58E6FF525A
      E6FF9EA2F5FF3450C3FF0B132D7E000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000044489FDB818BEEFF7E90
      F7FF5D73F3FF4D59E9FF4D59E9FF4D59E9FF4D59E9FF4D59E9FF4D59E9FF4F5B
      E9FF7B82F0FF757BE2FF223889DB000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000585CCBF6A0AAF7FF7085
      F8FF6881F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4D59
      E9FF5C66EAFF959BF1FF2E4AAEF6000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000005D61CCF6AEB8F9FF7F92
      FAFF7084F0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4D59
      E9FF5E6AEEFF959CF1FF3249B0F6000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004C4EA4DBA4AEF5FF9CAA
      FAFF778BF0FF545FECFF545FECFF545FECFF545FECFF545FECFF545FECFF6377
      F2FF818DF4FF787FE9FF2B3D8DDB000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000001B1A387E7D82EAFFCDD4
      FCFF8A9CFAFF7E92F7FF7589EEFF6C83F6FF6C83F6FF6C83F6FF6C83F6FF6379
      F3FFA3AEF8FF3E4FD0FF1015307E000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000030305225554B5E5A2A6
      F3FFD4DBFDFF8699FAFF7F90F0FF7A8DF1FF7F93F8FF7E91F9FF768BF8FFA7B5
      F8FF636EE3FF3846A1E502020422000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000C0C19536060
      CDF4A9ACF2FFD8DCFDFFADB9FAFF90A2FAFF8A9CFAFF9BA8FBFFB9C7FCFF707B
      E9FF4653BBF4080A165300000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000C0C
      19535656B6E68D92EDFFBDC2F8FFCCD3F9FFC3CBF9FFA9B3F4FF6670E2FF434C
      ABE6090B17530000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000030305231A1A377D4C4EA4DB595AC8F3575AC6F34549A0DB1618347D0303
      0523000000000000000000000000000000000000000000000000000000000000
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
      00000103072D081859AF0C2692E30D2EB3FF0A2CB2FF05218DE3021355AF0102
      072D0000000000000000000000000000000000000000010101020101010C0101
      01160101011A0101011A0101011A0101011A0101011A0101011A0101011A0101
      011A010101170101010C01010102000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000707072E121212521818
      18611F1E1F6C201E1F6D28252779272526782725277828252779201F206E201F
      206E19191962121212530707072F000000000000000000000000000000000B1B
      5BAF1436BCFF082CBEFF0228BDFF0127BDFF0127BCFF0227BCFF0328B8FF0427
      B0FF021254AF0000000000000000000000000000000001010104010101170101
      012B0103014402120180022901AB033801C5033801C5022901AB021201800103
      01440101012D0101011801010104000000000000000000000000000000000000
      0000010102130E0F2868303384C04448BEE73B3EA4D6313488C30F10296A0101
      01070000000000000000000000000000000000000000050505240D0C0D420E0E
      0E482C35308F4F9E6DF335B065FF29B35DFF29B35EFF3CB069FF508765E21D21
      1E70100F104C0D0C0D420505052400000000000000000101010816319BE31134
      C0FF0127BFFF0126BBFF0122A2FF011F95FF011F95FF011F95FF011F95FF0122
      A3FF0327B5FF021D8BE301010108000000000000000000000000000000000209
      014D054202BF107D07E31CB50DF522D212FD22D212FD1CB50DF5107D07E30542
      02BF0209014D0000000000000000000000000000000000000000000000000506
      0D3B474AC5EB5358E8FF5358E8FF5358E8FF5358E8FF5358E8FF5358E8FF4347
      BBE50909174F0000000000000000000000000000000000000000000000001143
      269829B664FF2DB667FF30B668FF2FB468FF30B568FF30B668FF2CB667FF29B7
      64FF07190F5B000000000000000000000000000000000F1E5FAF1437C3FF0127
      BFFF0126BAFFADB9E8FFC5CEF3FFE3E7F9FFE1E6F9FFADBAEDFFA6B2DFFF011F
      95FF0126B8FF0327B5FF021254AF000000000000000000000000020C014D0A58
      03CD20B710F624D113FF23B612FF23D112FF23D112FF23D112FF23D112FF1DB6
      0EF6095803CD020C014D000000000000000000000000000000000808174F474C
      DBF83D41DFFF3D40DAFF4F54E6FF5257E7FF5358E8FF5257E7FF4042DBFF4246
      DFFF4F53DCF805060D3B000000000000000000000000000000001A6A3FBA2EBA
      6EFF2EBA6FFF2EBA6FFF29B86AFF35BC73FF2EB96FFF2CB96DFF2EBA6FFF2EBA
      6FFF2DBA6EFF0A25166B0000000000000000030409342244C7FF0127C1FF0126
      BBFF0F31BAFFE9EDFAFF90A2E7FFE6EAFAFFE4E8F9FF8FA1E7FFE0E5F9FF0E2B
      9BFF0124AEFF0126BBFF0427B0FF01020834000000000102011A094E02BF26B3
      16F624C813FF23B212FFE6E6E6FF23B212FF23C812FF23C812FF23C812FF23C8
      12FF1EAF0EF6084E02BF0102011A0000000000000000010101073539BAE5363A
      DEFF9E9FE9FFD7D7F6FF383BD7FF4A4FE6FF4C51E6FF3B3DD7FFD7D8F6FFA0A1
      E9FF4246DFFF474AC5EB0101021300000000000000000A28196F2DBE73FF2DBE
      73FF2DBE73FF29BC70FF46C583FFFFFFFFFFFFFFFFFF1EB96AFF2CBE72FF2DBE
      73FF2DBE73FF2DBF73FF020503250000000012256DBA1035C6FF0127BEFF0126
      B8FF3C58C4FFECEFFBFF91A2E8FFE8ECFAFFE7EBFAFF90A1E7FFE3E7F9FF3950
      AEFF0123A7FF0126B8FF0328B8FF021560BA000000000419016C1C8610E327C0
      16FF23AD12FFDEDEDEFFE2E2E2FFE6E6E6FF23B312FF23BE12FF23BE12FF23BE
      12FF23BE12FF138108E30419016C00000000000000000B0C296A3B41E6FF3336
      D9FFD4D5F6FFFFFFFFFFD7D7F6FF3639D6FF3739D7FFD7D7F6FFFFFFFFFFD7D7
      F6FF3C40DAFF4F54E7FF0E0F2768000000000000000029C277FB29C077FF29C0
      77FF29C077FF24BF73FF51CD8FFFFFFFFFFFFFFFFFFF20BE72FF28C075FF29C0
      77FF29C077FF29C077FF176B42B800000000253EA4E4042AC3FF0127BDFF0125
      B6FF6A7FD1FFEFF1FCFF92A3E8FFEBEEFBFFE9EDFAFF90A2E7FFE6EAFAFF6477
      C1FF0122A3FF0125B6FF0227BCFF05218DE400000000073D01A638AF28F524AE
      13FFD5D5D5FFDADADAFFDEDEDEFFE2E2E2FFC0D8BDFF23AE12FF23B412FF23B4
      12FF23B412FF20A210F5073D01A600000000000000001D2186C3343AE5FF353C
      E5FF2D30D6FFCECFF5FFFFFFFFFFD6D7F6FFD7D7F6FFFFFFFFFFD7D7F6FF3639
      D6FF454BE6FF484EE7FF2A2D84C000000000030E094528C77CFF28C57BFF20C3
      76FF15C06FFF10BF6CFF41CA89FFFFFFFFFFFFFFFFFF0CBE6BFF14BF6FFF15C0
      70FF23C378FF28C57BFF29CB7EFF000000003252CFFF0128C3FF0127BCFF0125
      B6FF8899DBFFF2F4FCFF92A3E8FFEEF1FBFFECEFFBFF91A2E8FFE8ECFAFF8291
      CEFF01219DFF0125B6FF0127BCFF0A2CB2FF000000000A5701C44FC53FFD9EDC
      96FFD2D2D2FFD5D5D5FF52B645FFDDDEDDFFE2E2E2FFA6CEA0FF25A814FF23AA
      12FF23AA12FF29AC18FD0A5701C400000000000000001E22A2D62D33E5FF2F35
      E5FF3138E5FF2A2DD6FFCACBF4FFFFFFFFFFFFFFFFFFD6D7F6FF3335D6FF3F43
      E5FF3F45E6FF4147E6FF373CBDE7000000000A2F1E7A26C97FFF1EC77AFF6AD9
      A5FFF9FDFCFFEEFAF5FFF0FBF7FFFFFFFFFFFFFFFFFFECFAF4FFEFFBF5FFF8FD
      FBFF41CF8FFF21C77CFF26CD81FF020705313554D1FF0128C3FF0127BDFF0125
      B6FFB8C2EAFFF4F6FDFF93A4E8FFF1F3FCFFEFF1FCFF92A3E8FFEBEEFBFFAFB9
      E1FF01209CFF0125B6FF0127BDFF0D2EB3FF000000000A5901C453C842FD45BB
      34FFFFFFFFFF2FAB1EFF24A213FF52B045FFDEDEDEFFE2E2E2FF87C280FF23A1
      12FF23A112FF2CA81CFD0A5901C400000000000000001E22BCE72B31E5FF3A40
      E6FF4047E6FF373AD7FFDADBF8FFFFFFFFFFFFFFFFFFD7D8F7FF3A3CD7FF4D52
      E7FF494FE8FF3F45E7FF2B2FA2D6000000000C3A258723CC81FF18C97CFF9CE7
      C6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF68DAA7FF1CCA7EFF26CF85FF030B073F2B45A9E4042BC6FF0127BEFF0126
      B8FF91A2E7FF94A5E8FF94A5E8FF93A4E8FF93A4E8FF92A3E8FF92A3E8FF8E9F
      E6FF011F95FF0126B8FF0228BDFF0D2693E400000000084201A64CBC3BF548BE
      37FF48BE37FF48BE37FF43B932FF37AF26FFAACDA5FFDEDEDEFFE2E2E2FF69B5
      5EFF289F17FF31A322F5084201A60000000000000000141883C14D52EAFF4E53
      E9FF3D3FD9FFDADAF7FFFFFFFFFFDBDCF8FFCBCBF3FFFFFFFFFFD8D9F7FF4043
      D8FF5B61E9FF5D62EAFF222689C4000000000A2B1D7220CE84FF1FCE83FF2FD1
      8BFF81E3B9FF78E1B5FF92E7C3FFFFFFFFFFFFFFFFFF76E0B3FF7AE1B6FF7EE2
      B8FF20CE84FF1FCE83FF2ED58DFF0205042A182A70BA153ACBFF0127C1FF0126
      BBFFDCE1F5FFFAFAFEFFF8F9FDFFF6F7FDFFF4F6FDFFF2F4FCFFF1F3FCFFD1D7
      EFFF0121A1FF0126BBFF082CBEFF081A65BA00000000041D016C319924E355CB
      44FF4FC53EFF4FC53EFF4FC53EFF4FC53EFF4FC53EFFD3F1CEFFFFFFFFFFFFFF
      FFFF53C942FF2C921EE3041D016C000000000000000005052768474DE9FF4649
      DCFFD9D9F7FFFFFFFFFFDBDBF7FF4648D9FF4649DBFFCBCCF3FFFFFFFFFFD9D9
      F7FF4D50DEFF575DEAFF090A286A000000000209063534DA94FF1FD086FF1ED0
      86FF17CE82FF12CD80FF41D799FFFFFFFFFFFFFFFFFF0ECC7FFF16CE82FF18CE
      82FF1FD087FF1ECF86FF36DE97FF0000000003050A353353D3FF0128C4FF0127
      BFFF6178D4FFFCFDFEFFFBFBFEFFF9FAFEFFF7F8FDFFF5F7FDFFF3F5FDFF5C73
      D0FF0126BAFF0127BFFF1436BCFF02030935000000000103011A0F5E05BF57C8
      46F65AD049FF58CE47FF58CE47FF58CE47FF58CE47FF58CE47FFFFFFFFFF59CF
      48FF51C441F60F5E04BF0103011A0000000000000000010102131E24C4EC5458
      E3FFA3A3E9FFDADAF7FF4D4FDBFF7377EDFF757AEFFF5052DCFFCCCDF4FFA2A3
      EAFF5C60E4FF2C32BDE701010107000000000000000039C389EA19D288FF1ED4
      8BFF1ED48BFF19D288FF4BDCA1FFFFFFFFFFFFFFFFFF16D286FF1DD38AFF1ED4
      8BFF1DD48AFF20D38CFF1A5B409E0000000000000000172764AF2144CFFF0128
      C3FF0127BFFF0126BBFFEDEFFBFF1B3AB3FF1B36A0FFE8EBF6FF0122A2FF0126
      BBFF0127BFFF1134C0FF0B1B5BAF0000000000000000000000000310014D1772
      0ACD5ACB49F664DA53FF60D64FFF60D64FFF60D64FFF60D64FFF64DA53FF57C9
      46F6167109CD0310014D0000000000000000000000000000000001020D3B2B33
      DCF96468E5FF5C5EE0FF8387F0FF8589F1FF868AF1FF878BF1FF6164E1FF696C
      E4FF393EDEF90404174F00000000000000000000000004140E4843DF9EFF17D4
      8BFF1ED68EFF1CD58CFF21D68EFFC7F4E2FFB5F0D9FF10D386FF1DD68EFF1DD6
      8EFF15D38AFF52E5A6FF0101010C0000000000000000010101082A44A9E32144
      CFFF0128C4FF0127C1FF6179D6FFEEF0FBFFECF0FAFF5F77D5FF0127BEFF0127
      C1FF1437C3FF16319BE301010108000000000000000000000000000000000310
      014D106205BF359F26E358CB49F56ADF59FD6ADF58FD58CB49F5349E25E31062
      05BF0310014D0000000000000000000000000000000000000000000000000102
      174F151BBCE7676CEDFF9296F2FF999CF3FF999CF3FF9598F3FF6D72EEFF1F26
      C4EC02020D3B000000000000000000000000000000000000000011412E8349E0
      A3FF14D48CFF19D58EFF1BD68EFF0ED488FF0FD488FF1BD68FFF18D58EFF16D5
      8DFF5AE6ABFF030E0A3B00000000000000000000000000000000000000001727
      64AF3353D3FF153ACBFF042BC6FF0128C3FF0128C3FF042AC3FF1035C6FF2244
      C7FF0F1E5FAF0000000000000000000000000000000000000000000000000000
      00000103011A051F016C0A4901A70D6501C40D6501C40A4901A7051F016C0103
      011A000000000000000000000000000000000000000000000000000000000000
      0000010101070102286A030785C3181CA8DA1A21BFE9060A81C0030426680101
      0213000000000000000000000000000000000000000000000000000000000823
      195F5CECAFFF43E1A1FF14D78EFF16D78FFF16D78FFF1BD891FF4FE4A7FF4AC3
      91E60207052A0000000000000000000000000000000000000000000000000000
      00000203082E172663AF2841A7E33554D1FF3252CFFF223CA2E3112160AF0203
      072E000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000101010208251A66286A4FAD36916BCA338B67C61F5A429F04150E4C0000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
end
