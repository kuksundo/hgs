object RP_Agg: TRP_Agg
  Left = 618
  Top = 165
  Caption = 'RP_Agg'
  ClientHeight = 765
  ClientWidth = 1132
  Color = clBtnFace
  Constraints.MaxWidth = 1148
  Constraints.MinWidth = 1148
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object NxHeaderPanel1: TNxHeaderPanel
    Left = 0
    Top = 0
    Width = 1132
    Height = 765
    Align = alClient
    Caption = ' '#47928#51228#51216' '#48372#44256#49436' '#53685#44228
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #47569#51008' '#44256#46357
    Font.Style = []
    HeaderFont.Charset = ANSI_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -19
    HeaderFont.Name = #47569#51008' '#44256#46357
    HeaderFont.Style = [fsBold]
    HeaderSize = 60
    InnerMargins.Left = 2
    InnerMargins.Top = 2
    InnerMargins.Bottom = 2
    InnerMargins.Right = 2
    ParentFont = False
    ParentHeaderFont = False
    TabOrder = 0
    FullWidth = 1132
    object NxPageControl1: TNxPageControl
      Left = 2
      Top = 62
      Width = 1126
      Height = 699
      ActivePage = NxTabSheet2
      ActivePageIndex = 1
      Align = alClient
      TabOrder = 0
      Margin = 0
      Spacing = 0
      TabHeight = 17
      object NxTabSheet1: TNxTabSheet
        Caption = #45936#51060#53552' '#53685#44228
        PageIndex = 0
        ParentTabFont = False
        TabFont.Charset = ANSI_CHARSET
        TabFont.Color = clWindowText
        TabFont.Height = -13
        TabFont.Name = #47569#51008' '#44256#46357
        TabFont.Style = []
        TabWidth = 200
        object NxSplitter1: TNxSplitter
          Left = 0
          Top = 265
          Width = 1126
          Height = 6
          Cursor = crVSplit
          Align = alTop
          ExplicitWidth = 1134
        end
        object AdvOfficeStatusBar1: TAdvOfficeStatusBar
          Left = 0
          Top = 659
          Width = 1126
          Height = 19
          AnchorHint = False
          Panels = <
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
              Width = 80
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
              Width = 100
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
              Width = 130
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
              Width = 50
            end>
          ShowSplitter = True
          SimplePanel = False
          Version = '1.5.3.0'
        end
        object NxHeaderPanel3: TNxHeaderPanel
          Left = 0
          Top = 271
          Width = 1126
          Height = 388
          Align = alClient
          Caption = #45936#51060#53552' '#46321#47197' '#51648#54364
          Color = clBtnFace
          HeaderFont.Charset = ANSI_CHARSET
          HeaderFont.Color = clWindowText
          HeaderFont.Height = -12
          HeaderFont.Name = #47569#51008' '#44256#46357
          HeaderFont.Style = [fsBold]
          InnerMargins.Top = 3
          InnerMargins.Bottom = 3
          InnerMargins.Right = 3
          ParentHeaderFont = False
          TabOrder = 1
          FullWidth = 1126
          object Chart2: TChart
            Left = 0
            Top = 30
            Width = 1121
            Height = 353
            BackWall.Brush.Style = bsClear
            Title.Text.Strings = (
              'TChart')
            Title.Visible = False
            BottomAxis.LabelsFormat.TextAlignment = taCenter
            DepthAxis.Automatic = False
            DepthAxis.AutomaticMaximum = False
            DepthAxis.AutomaticMinimum = False
            DepthAxis.LabelsFormat.TextAlignment = taCenter
            DepthAxis.Maximum = -0.160000000000000300
            DepthAxis.Minimum = -1.160000000000001000
            DepthTopAxis.Automatic = False
            DepthTopAxis.AutomaticMaximum = False
            DepthTopAxis.AutomaticMinimum = False
            DepthTopAxis.LabelsFormat.TextAlignment = taCenter
            DepthTopAxis.Maximum = -0.160000000000000300
            DepthTopAxis.Minimum = -1.160000000000001000
            LeftAxis.LabelsFormat.TextAlignment = taCenter
            RightAxis.Automatic = False
            RightAxis.AutomaticMaximum = False
            RightAxis.AutomaticMinimum = False
            RightAxis.LabelsFormat.TextAlignment = taCenter
            TopAxis.LabelsFormat.TextAlignment = taCenter
            Zoom.Pen.Mode = pmNotXor
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            DefaultCanvas = 'TGDIPlusCanvas'
            ColorPaletteIndex = 13
            object Series2: TBarSeries
              Marks.Visible = True
              Marks.Style = smsValue
              SeriesColor = clRed
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Bar'
              YValues.Order = loNone
            end
          end
        end
        object NxPanel1: TNxPanel
          Left = 0
          Top = 0
          Width = 1126
          Height = 265
          Align = alTop
          UseDockManager = False
          TabOrder = 2
          object Panel27: TPanel
            Left = 0
            Top = 0
            Width = 776
            Height = 265
            Align = alClient
            TabOrder = 0
            object Panel28: TPanel
              Left = 1
              Top = 1
              Width = 774
              Height = 25
              Align = alTop
              TabOrder = 0
              object Panel29: TPanel
                Left = 1
                Top = 1
                Width = 128
                Height = 23
                Align = alLeft
                Caption = '1. '#44160#49353#51312#44148
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = #47569#51008' '#44256#46357
                Font.Style = []
                ParentFont = False
                TabOrder = 0
              end
              object SearchED1: TNxComboBox
                Left = 129
                Top = 1
                Width = 130
                Height = 23
                Align = alLeft
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = #47569#51008' '#44256#46357
                Font.Style = []
                ParentFont = False
                TabOrder = 1
                ReadOnly = True
                HideFocus = False
                AutoCompleteDelay = 0
                Items.Strings = (
                  ''
                  #44060#51064#48324
                  #50644#51652#48324
                  #44284#48324)
              end
              object Panel30: TPanel
                Left = 259
                Top = 1
                Width = 128
                Height = 23
                Align = alLeft
                Caption = '2. '#49345#49464#51312#44148
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = #47569#51008' '#44256#46357
                Font.Style = []
                ParentFont = False
                TabOrder = 2
              end
              object SearchED2: TNxComboBox
                Left = 387
                Top = 1
                Width = 190
                Height = 23
                Align = alLeft
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = #47569#51008' '#44256#46357
                Font.Style = []
                ParentFont = False
                TabOrder = 3
                ReadOnly = True
                OnButtonDown = SearchED2ButtonDown
                HideFocus = False
                AutoCompleteDelay = 0
              end
              object NxButton1: TNxButton
                Left = 702
                Top = 1
                Width = 71
                Align = alRight
                Caption = #51312#54924
                TabOrder = 4
                OnClick = NxButton1Click
              end
              object NxButton2: TNxButton
                Left = 631
                Top = 1
                Width = 71
                Align = alRight
                Caption = #48372#44256#49436
                TabOrder = 5
                Visible = False
              end
            end
            object Panel31: TPanel
              Left = 1
              Top = 26
              Width = 774
              Height = 25
              Align = alTop
              TabOrder = 1
              object Panel32: TPanel
                Left = 1
                Top = 1
                Width = 128
                Height = 23
                Align = alLeft
                Caption = #46321#47197#44148#49688
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = #47569#51008' '#44256#46357
                Font.Style = []
                ParentFont = False
                TabOrder = 0
              end
              object ACount: TNxEdit
                Left = 129
                Top = 1
                Width = 130
                Height = 23
                Align = alLeft
                Alignment = taCenter
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = #47569#51008' '#44256#46357
                Font.Style = []
                ParentFont = False
                TabOrder = 1
                ReadOnly = True
              end
            end
            object Panel33: TPanel
              Left = 1
              Top = 51
              Width = 774
              Height = 25
              Align = alTop
              BevelOuter = bvNone
              TabOrder = 2
              object Panel34: TPanel
                Left = 0
                Top = 0
                Width = 129
                Height = 25
                Align = alLeft
                Caption = #47928#51228#50976#54805
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = #47569#51008' '#44256#46357
                Font.Style = []
                ParentFont = False
                TabOrder = 0
              end
              object Panel35: TPanel
                Left = 129
                Top = 0
                Width = 67
                Height = 25
                Align = alLeft
                Caption = #54408#51656#47928#51228
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = #47569#51008' '#44256#46357
                Font.Style = []
                ParentFont = False
                TabOrder = 1
              end
              object QED: TNxEdit
                Left = 196
                Top = 0
                Width = 63
                Height = 25
                Align = alLeft
                Alignment = taCenter
                BevelInner = bvSpace
                BevelOuter = bvNone
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = #47569#51008' '#44256#46357
                Font.Style = []
                ParentFont = False
                TabOrder = 2
                ReadOnly = True
                ExplicitHeight = 23
              end
              object Panel36: TPanel
                Left = 259
                Top = 0
                Width = 67
                Height = 25
                Align = alLeft
                Caption = #49444#48708#47928#51228
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = #47569#51008' '#44256#46357
                Font.Style = []
                ParentFont = False
                TabOrder = 3
              end
              object EED: TNxEdit
                Left = 326
                Top = 0
                Width = 63
                Height = 25
                Align = alLeft
                Alignment = taCenter
                BevelInner = bvSpace
                BevelOuter = bvNone
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = #47569#51008' '#44256#46357
                Font.Style = []
                ParentFont = False
                TabOrder = 4
                ReadOnly = True
                ExplicitHeight = 23
              end
              object Panel37: TPanel
                Left = 389
                Top = 0
                Width = 67
                Height = 25
                Align = alLeft
                Caption = #51312#47549#47928#51228
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = #47569#51008' '#44256#46357
                Font.Style = []
                ParentFont = False
                TabOrder = 5
              end
              object AED: TNxEdit
                Left = 456
                Top = 0
                Width = 63
                Height = 25
                Align = alLeft
                Alignment = taCenter
                BevelInner = bvSpace
                BevelOuter = bvNone
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = #47569#51008' '#44256#46357
                Font.Style = []
                ParentFont = False
                TabOrder = 6
                ReadOnly = True
                ExplicitHeight = 23
              end
              object Panel38: TPanel
                Left = 519
                Top = 0
                Width = 67
                Height = 25
                Align = alLeft
                Caption = #49884#50868#51204#47928#51228
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = #47569#51008' '#44256#46357
                Font.Style = []
                ParentFont = False
                TabOrder = 7
              end
              object CED: TNxEdit
                Left = 586
                Top = 0
                Width = 63
                Height = 25
                Align = alLeft
                Alignment = taCenter
                BevelInner = bvSpace
                BevelOuter = bvNone
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = #47569#51008' '#44256#46357
                Font.Style = []
                ParentFont = False
                TabOrder = 8
                ReadOnly = True
                ExplicitHeight = 23
              end
              object Panel39: TPanel
                Left = 649
                Top = 0
                Width = 67
                Height = 25
                Align = alLeft
                Caption = #47928#51228#50696#49345
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = #47569#51008' '#44256#46357
                Font.Style = []
                ParentFont = False
                TabOrder = 9
              end
              object XED: TNxEdit
                Left = 716
                Top = 0
                Width = 58
                Height = 25
                Align = alClient
                Alignment = taCenter
                BevelInner = bvSpace
                BevelOuter = bvNone
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = #47569#51008' '#44256#46357
                Font.Style = []
                ParentFont = False
                TabOrder = 10
                ReadOnly = True
                ExplicitHeight = 23
              end
            end
            object Panel41: TPanel
              Left = 1
              Top = 76
              Width = 774
              Height = 5
              Align = alTop
              BevelOuter = bvNone
              TabOrder = 3
            end
            object NxHeaderPanel2: TNxHeaderPanel
              Left = 1
              Top = 81
              Width = 774
              Height = 183
              Align = alClient
              Caption = #47928#51228' LIST'
              HeaderFont.Charset = ANSI_CHARSET
              HeaderFont.Color = clWindowText
              HeaderFont.Height = -12
              HeaderFont.Name = #47569#51008' '#44256#46357
              HeaderFont.Style = [fsBold]
              InnerMargins.Left = 6
              InnerMargins.Top = 2
              InnerMargins.Bottom = 2
              InnerMargins.Right = 2
              ParentHeaderFont = False
              TabOrder = 4
              FullWidth = 774
              object NextGrid1: TNextGrid
                Left = 6
                Top = 29
                Width = 764
                Height = 150
                Align = alClient
                Caption = ''
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = #47569#51008' '#44256#46357
                Font.Style = []
                HeaderStyle = hsOffice2007
                ParentFont = False
                TabOrder = 0
                TabStop = True
                object NxIncrementColumn1: TNxIncrementColumn
                  DefaultWidth = 37
                  Font.Charset = ANSI_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -12
                  Font.Name = #47569#51008' '#44256#46357
                  Font.Style = []
                  Header.Caption = 'No.'
                  Header.Alignment = taCenter
                  ParentFont = False
                  Position = 0
                  SortType = stAlphabetic
                  Width = 37
                end
                object NxTextColumn1: TNxTextColumn
                  DefaultWidth = 130
                  Font.Charset = ANSI_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -12
                  Font.Name = #47569#51008' '#44256#46357
                  Font.Style = []
                  Header.Caption = #47928#49436#48264#54840
                  Header.Alignment = taCenter
                  ParentFont = False
                  Position = 1
                  SortType = stAlphabetic
                  Width = 130
                end
                object NxTextColumn2: TNxTextColumn
                  Font.Charset = ANSI_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -12
                  Font.Name = #47569#51008' '#44256#46357
                  Font.Style = []
                  Header.Caption = #50976#54805
                  Header.Alignment = taCenter
                  ParentFont = False
                  Position = 2
                  SortType = stAlphabetic
                end
                object NxTextColumn3: TNxTextColumn
                  DefaultWidth = 515
                  Font.Charset = ANSI_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -12
                  Font.Name = #47569#51008' '#44256#46357
                  Font.Style = []
                  Header.Caption = #47928#51228#51216' '#45236#50857
                  Header.Alignment = taCenter
                  Options = [coAutoSize, coCanClick, coCanInput, coCanSort, coPublicUsing, coShowTextFitHint]
                  ParentFont = False
                  Position = 3
                  SortType = stAlphabetic
                  Width = 515
                end
              end
            end
          end
          object NxHeaderPanel4: TNxHeaderPanel
            Left = 776
            Top = 0
            Width = 350
            Height = 265
            Align = alRight
            Caption = #54016#48324' '#46321#47197#54788#54889
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #47569#51008' '#44256#46357
            Font.Style = [fsBold]
            HeaderFont.Charset = ANSI_CHARSET
            HeaderFont.Color = clWindowText
            HeaderFont.Height = -12
            HeaderFont.Name = #47569#51008' '#44256#46357
            HeaderFont.Style = [fsBold]
            InnerMargins.Left = 1
            InnerMargins.Top = 1
            InnerMargins.Bottom = 1
            InnerMargins.Right = 1
            ParentFont = False
            ParentHeaderFont = False
            TabOrder = 1
            FullWidth = 350
            object Chart1: TChart
              Left = 1
              Top = 28
              Width = 346
              Height = 234
              AllowPanning = pmNone
              BackWall.Brush.Style = bsClear
              BackWall.Pen.Visible = False
              Legend.Alignment = laBottom
              Legend.DividingLines.Visible = True
              Legend.LegendStyle = lsValues
              Legend.VertMargin = 1
              MarginTop = 0
              Title.Text.Strings = (
                'TChart')
              Title.Visible = False
              AxisVisible = False
              BottomAxis.LabelsFormat.TextAlignment = taCenter
              ClipPoints = False
              DepthAxis.LabelsFormat.TextAlignment = taCenter
              DepthTopAxis.LabelsFormat.TextAlignment = taCenter
              Frame.Visible = False
              LeftAxis.LabelsFormat.TextAlignment = taCenter
              RightAxis.LabelsFormat.TextAlignment = taCenter
              TopAxis.LabelsFormat.TextAlignment = taCenter
              View3DOptions.Elevation = 315
              View3DOptions.Orthogonal = False
              View3DOptions.Perspective = 0
              View3DOptions.Rotation = 360
              View3DWalls = False
              Zoom.Allow = False
              Zoom.Pen.Mode = pmNotXor
              Align = alClient
              BevelInner = bvLowered
              TabOrder = 0
              DefaultCanvas = 'TGDIPlusCanvas'
              ColorPaletteIndex = 13
              object Series1: TPieSeries
                Marks.Visible = False
                Marks.Style = smsValue
                SeriesColor = clRed
                XValues.Order = loAscending
                YValues.Name = 'Pie'
                YValues.Order = loDescending
                Frame.InnerBrush.BackColor = clRed
                Frame.InnerBrush.Gradient.EndColor = clGray
                Frame.InnerBrush.Gradient.MidColor = clWhite
                Frame.InnerBrush.Gradient.StartColor = 4210752
                Frame.InnerBrush.Gradient.Visible = True
                Frame.MiddleBrush.BackColor = clYellow
                Frame.MiddleBrush.Gradient.EndColor = 8553090
                Frame.MiddleBrush.Gradient.MidColor = clWhite
                Frame.MiddleBrush.Gradient.StartColor = clGray
                Frame.MiddleBrush.Gradient.Visible = True
                Frame.OuterBrush.BackColor = clGreen
                Frame.OuterBrush.Gradient.EndColor = 4210752
                Frame.OuterBrush.Gradient.MidColor = clWhite
                Frame.OuterBrush.Gradient.StartColor = clSilver
                Frame.OuterBrush.Gradient.Visible = True
                Frame.Width = 4
                OtherSlice.Legend.Visible = False
                OtherSlice.Text = 'Other'
                PiePen.Width = 2
                RotationAngle = 10
              end
            end
            object DeptCB: TNxComboBox
              Left = 214
              Top = 2
              Width = 133
              Height = 23
              Alignment = taCenter
              TabOrder = 1
              Text = #50644#51652#49884#54744#44592#49696#48512
              Visible = False
              HideFocus = False
              AutoCompleteDelay = 0
              ItemIndex = 0
              Items.Strings = (
                #50644#51652#49884#54744#44592#49696#48512)
            end
          end
        end
      end
      object NxTabSheet2: TNxTabSheet
        Caption = #47928#51228#51216' '#51312#52824' '#45236#50669
        PageIndex = 1
        ParentTabFont = False
        TabFont.Charset = ANSI_CHARSET
        TabFont.Color = clWindowText
        TabFont.Height = -13
        TabFont.Name = #47569#51008' '#44256#46357
        TabFont.Style = []
        TabWidth = 200
        object Panel3: TPanel
          Left = 0
          Top = 105
          Width = 1126
          Height = 6
          Align = alTop
          TabOrder = 0
        end
        object StatusBar1: TStatusBar
          Left = 0
          Top = 659
          Width = 1126
          Height = 19
          Panels = <>
        end
        object NxHeaderPanel5: TNxHeaderPanel
          Left = 0
          Top = 0
          Width = 1126
          Height = 105
          Align = alTop
          Caption = #48372#44256#49436' '#44160#49353' '#51312#44148
          HeaderFont.Charset = ANSI_CHARSET
          HeaderFont.Color = clWindowText
          HeaderFont.Height = -15
          HeaderFont.Name = #47569#51008' '#44256#46357
          HeaderFont.Style = [fsBold, fsItalic]
          InnerMargins.Left = 2
          InnerMargins.Top = 2
          InnerMargins.Bottom = 2
          InnerMargins.Right = 2
          PanelStyle = ptInverseGradient
          ParentHeaderFont = False
          TabOrder = 2
          FullWidth = 1126
          object NxLabel2: TNxLabel
            Left = 761
            Top = 35
            Width = 108
            Height = 20
            AutoSize = False
            Caption = '3. '#50644#51652#53440#51077' '#49440#53469
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = #47569#51008' '#44256#46357
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = True
            HorizontalPosition = hpLeft
            InnerHorizontal = True
            InnerVertical = False
            InnerMargins.Horizontal = 0
            InnerMargins.Vertical = 2
            VerticalPosition = vpMiddle
          end
          object NxLabel1: TNxLabel
            Left = 8
            Top = 35
            Width = 216
            Height = 20
            AutoSize = False
            Caption = '1. '#48372#44256#49436' '#51333#47448' '#49440#53469
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = #47569#51008' '#44256#46357
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = True
            HorizontalPosition = hpLeft
            InnerHorizontal = True
            InnerVertical = False
            InnerMargins.Horizontal = 0
            InnerMargins.Vertical = 2
            VerticalPosition = vpMiddle
          end
          object NxLabel3: TNxLabel
            Left = 529
            Top = 35
            Width = 134
            Height = 20
            AutoSize = False
            Caption = '2. '#48372#44256#49436' '#51221#47148' '#48169#49885
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = #47569#51008' '#44256#46357
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = True
            HorizontalPosition = hpLeft
            InnerHorizontal = True
            InnerVertical = False
            InnerMargins.Horizontal = 0
            InnerMargins.Vertical = 2
            VerticalPosition = vpMiddle
          end
          object Bevel1: TBevel
            Left = 513
            Top = 32
            Width = 2
            Height = 66
          end
          object Bevel2: TBevel
            Left = 753
            Top = 32
            Width = 2
            Height = 66
          end
          object RP_Type: TAdvOfficeCheckGroup
            Left = 8
            Top = 54
            Width = 489
            Height = 39
            Version = '1.3.8.5'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #47569#51008' '#44256#46357
            Font.Style = []
            ParentBackground = False
            ParentFont = False
            TabOrder = 0
            OnClick = RP_TypeClick
            Columns = 3
            Items.Strings = (
              #54408#51656#47928#51228
              #49444#48708#47928#51228
              #47928#51228#50696#49345)
            Alignment = taCenter
            ButtonVertAlign = tlBottom
            Ellipsis = False
          end
          object EngType: TNxComboBox
            Left = 761
            Top = 56
            Width = 195
            Height = 23
            Align = alCustom
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #47569#51008' '#44256#46357
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            OnButtonDown = EngTypeButtonDown
            HideFocus = False
            AutoCompleteDelay = 0
          end
          object NxButton3: TNxButton
            Left = 1047
            Top = 50
            Width = 75
            Height = 27
            Align = alCustom
            Caption = #51312' '#54924
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #47569#51008' '#44256#46357
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            OnClick = NxButton3Click
          end
          object NxButton4: TNxButton
            Left = 386
            Top = 31
            Width = 56
            Align = alCustom
            Caption = #51204#52404#49440#53469
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #47569#51008' '#44256#46357
            Font.Style = []
            ParentFont = False
            TabOrder = 3
            OnClick = NxButton4Click
          end
          object NxButton5: TNxButton
            Left = 442
            Top = 31
            Width = 56
            Align = alCustom
            Caption = #51204#52404#54644#51228
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #47569#51008' '#44256#46357
            Font.Style = []
            ParentFont = False
            TabOrder = 4
            OnClick = NxButton5Click
          end
          object AlignRP: TAdvOfficeRadioGroup
            Left = 529
            Top = 54
            Width = 212
            Height = 39
            Version = '1.3.8.5'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #47569#51008' '#44256#46357
            Font.Style = []
            ParentBackground = False
            ParentFont = False
            TabOrder = 5
            Columns = 2
            Items.Strings = (
              #47928#51228#50976#54805#49692
              #47928#51228#48156#49373#51068#49692)
            ButtonVertAlign = tlCenter
            Ellipsis = False
          end
        end
        object NxPageControl2: TNxPageControl
          Left = 0
          Top = 111
          Width = 1126
          Height = 507
          ActivePage = NxTabSheet4
          ActivePageIndex = 1
          Align = alClient
          TabOrder = 3
          Margin = 0
          Options = [pgBoldActiveTab]
          Spacing = 0
          TabHeight = 17
          TabPosition = tpBottom
          TabStyle = tsDexter
          object NxTabSheet3: TNxTabSheet
            Caption = 'Trouble List'
            PageIndex = 0
            ParentTabFont = False
            TabFont.Charset = ANSI_CHARSET
            TabFont.Color = clWindowText
            TabFont.Height = -13
            TabFont.Name = #47569#51008' '#44256#46357
            TabFont.Style = []
            TabWidth = 150
            ExplicitHeight = 487
            object SMainTable: TAdvStringGrid
              Left = 0
              Top = 0
              Width = 1126
              Height = 486
              Cursor = crDefault
              Align = alClient
              ColCount = 12
              DrawingStyle = gdsClassic
              FixedCols = 3
              RowCount = 4
              FixedRows = 3
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = #47569#51008' '#44256#46357
              Font.Style = []
              ParentFont = False
              ScrollBars = ssBoth
              TabOrder = 0
              HoverRowCells = [hcNormal, hcSelected]
              OnGetAlignment = SMainTableGetAlignment
              OnCanEditCell = SMainTableCanEditCell
              OnGetEditorType = SMainTableGetEditorType
              ActiveCellFont.Charset = DEFAULT_CHARSET
              ActiveCellFont.Color = clWindowText
              ActiveCellFont.Height = -11
              ActiveCellFont.Name = 'Tahoma'
              ActiveCellFont.Style = [fsBold]
              ColumnSize.Stretch = True
              ColumnSize.StretchColumn = 8
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
              FixedColWidth = 30
              FixedRowHeight = 22
              FixedFont.Charset = DEFAULT_CHARSET
              FixedFont.Color = clWindowText
              FixedFont.Height = -11
              FixedFont.Name = 'Tahoma'
              FixedFont.Style = [fsBold]
              FloatFormat = '%.1f'
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
              VAlignment = vtaCenter
              Version = '7.4.4.1'
              ExplicitWidth = 1134
              ExplicitHeight = 321
              ColWidths = (
                30
                40
                85
                45
                45
                45
                45
                213
                349
                85
                70
                70)
              RowHeights = (
                22
                22
                22
                22)
            end
          end
          object NxTabSheet4: TNxTabSheet
            Caption = 'Description'
            PageIndex = 1
            ParentTabFont = False
            TabFont.Charset = ANSI_CHARSET
            TabFont.Color = clWindowText
            TabFont.Height = -13
            TabFont.Name = #47569#51008' '#44256#46357
            TabFont.Style = []
            TabWidth = 150
            ExplicitHeight = 487
            object DescGrid: TAdvStringGrid
              Left = 0
              Top = 0
              Width = 1126
              Height = 486
              Cursor = crDefault
              Align = alClient
              ColCount = 9
              Ctl3D = True
              DefaultRowHeight = 35
              DrawingStyle = gdsClassic
              RowCount = 3
              FixedRows = 2
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = #47569#51008' '#44256#46357
              Font.Style = []
              ParentCtl3D = False
              ParentFont = False
              ScrollBars = ssBoth
              TabOrder = 0
              HoverRow = True
              HoverRowCells = [hcNormal, hcSelected]
              OnGetAlignment = DescGridGetAlignment
              ActiveCellFont.Charset = DEFAULT_CHARSET
              ActiveCellFont.Color = clWindowText
              ActiveCellFont.Height = -11
              ActiveCellFont.Name = 'Tahoma'
              ActiveCellFont.Style = [fsBold]
              ColumnSize.Stretch = True
              ColumnSize.StretchColumn = 2
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
              FixedColWidth = 35
              FixedRowHeight = 30
              FixedFont.Charset = ANSI_CHARSET
              FixedFont.Color = clWindowText
              FixedFont.Height = -11
              FixedFont.Name = #47569#51008' '#44256#46357
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
              SortSettings.DefaultFormat = ssAutomatic
              VAlignment = vtaCenter
              Version = '7.4.4.1'
              ExplicitWidth = 1134
              ExplicitHeight = 329
              ColWidths = (
                35
                210
                230
                230
                84
                45
                45
                45
                198)
              RowHeights = (
                30
                30
                35)
            end
          end
        end
        object Panel26: TPanel
          Left = 0
          Top = 618
          Width = 1126
          Height = 41
          Align = alBottom
          TabOrder = 4
          object SpeedButton1: TSpeedButton
            Left = 1097
            Top = 5
            Width = 31
            Height = 31
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = #47569#51008' '#44256#46357
            Font.Style = [fsBold]
            Glyph.Data = {
              66090000424D660900000000000036000000280000001C0000001C0000000100
              18000000000030090000120B0000120B00000000000000000000417B57214F39
              214F39214F39214F39214F39214F391A45331A45331A45331A45331A45331A45
              331335291335291335291335291335291335290D281F0D281F0D281F0D281F0D
              281F0A1F190A1F190A1F190A1F19417B575CAA6545A35F45A35F45A35F45A35F
              3F9E5A3F9E5A3F9E5A399755399755399755358C4F358C4F2D87472D87472D87
              47227F40227F40227F401A7A3C1A7A3C1274371274371274370F6C330A6D300A
              1F19417B575CAA656C977E517666517666517666517666517666517666517666
              4B6B604B6B604B6B604B6B604B6B604B6B604B6B60435F59435F59435F59435F
              59435F59435F59435F59435F59435F590F6C330A1F1947815D63B2766C977EE8
              F1E8E8F1E8E6F0E6E4EFE4E2EEE3E2EEE3E0EEE0DFECDFDEEBDEDCEADBDCEADB
              DAE9DAD9E8D9D8E7D8D8E7D8D5E5D5D5E5D5D5E5D5D2E4D2D2E4D2D2E4D2D2E4
              D2435F591274370A1F1947815D63B2766C977EEAF2E9E8F1E8E8F1E8E6F0E6E4
              EFE4E2EEE3E2EEE3E0EEE0DFECDFDEEBDEDCEADBDCEADBDAE9DAD9E8D9D8E7D8
              D8E7D8D5E5D5D5E5D5D5E5D5D2E4D2D2E4D2D2E4D2435F591274370D281F4781
              5D63B2766C977EEBF3EBEAF2E9E8F1E8E8F1E8E6F0E6E4EFE4E2EEE3E2EEE3E0
              EEE0DFECDFDEEBDEDCEADBDCEADBDAE9DAD9E8D9D8E7D8D8E7D8D5E5D5D5E5D5
              D5E5D5D2E4D2D2E4D2435F591274370D281F4D876273BA836C977EEDF5EDEBF3
              EBEAF2E9E8F1E8E8F1E8E6F0E6E4EFE4E2EEE3E2EEE3E0EEE0DFECDFDEEBDEDC
              EADBDCEADBDAE9DAD9E8D9D8E7D8D8E7D8D5E5D5D5E5D5D5E5D5D2E4D2435F59
              1A7A3C0D281F4D876273BA836C977EEDF5EDEDF5EDEBF3EBEAF2E9E8F1E8E8F1
              E8E6F0E6E4EFE4E2EEE3E2EEE3E0EEE0DFECDFAAD6B261996426422D213B2721
              3B27213B27213B27213B27213B27D5E5D5435F591A7A3C0D281F4D87627CC185
              76A086EFF6EF4B964D26422D26422D26422D26422D26422D26422D26422D2642
              2D26422D1A4D2A0F60153287353287351274371C6C3A2C66422C66423A5F5121
              3B27D5E5D5435F59227F400D281F558E6781BC9076A086F1F7F14B964D127437
              1274371C6C3A1C6C3A2C66422C66423A5F513A5F513A5F510469041D781E88C7
              926DB6752D87472D8747227F40227F40046904D8E7D8D5E5D5435F59227F4013
              3529558E6788C79276A086F3F8F3DAE9DA4B964D6DB67573BB7C73BB7C6DB675
              68B06F5CAA6555A45A0469044093479DD0A76DB675409347358C4F2D87472D87
              4704690494C79CD8E7D8D8E7D8435F59227F40133529558E6794C79C76A086F3
              F8F3F3F8F3DAE9DA4B964D6DB67573BB7C73BB7C64AC6955A45A046904409347
              9DD0A768B06F499B54499B54409347358C4F0469041A4D2AA8C2A8D9E8D9D8E7
              D84B6B602D874713352958966B94C79C76A086F5F9F5F3F8F3F3F8F3DAE9DA4B
              964D6DB67568B06F55A45A0469044093479DD0A76DB67555A45A55A45A499B54
              499B540469042D8747227F400F6015DAE9DAD9E8D94B6B602D87471335295896
              6B9DD0A781AA8DF6FAF5F5F9F5F3F8F3F3F8F3DAE9DA4B964D55A45A04690440
              9347AAD6B273BB7C55A45A55A45A55A45A55A45A0469043A734C57825A558E67
              57825ADCEADBDAE9DA4B6B602D87471335295F9B729DD0A781AA8DF6FAF6F6FA
              F5F5F9F5F3F8F3F3F8F3DAE9DA1D781E409347AAD6B27CC1855CAA655CAA6555
              A45A55A45A3A734CA8C2A8E2EEE3E0EEE0DFECDFDEEBDEDCEADBDCEADB4B6B60
              358C4F1335295F9B72AAD6B281AA8DF8FAF8F6FAF6F6FAF5F5F9F5F3F8F394C7
              9C4B964DBADEC088C79264AC6964AC695CAA6555A45A57825A046904CDDACDE2
              EEE3E2EEE3E0EEE0DFECDFDEEBDEDCEADB4B6B60358C4F1A45335F9B72AAD6B2
              81AA8DF9FBFAF8FAF8F6FAF6F6FAF594C79C499B54BADEC094C79C6DB67568B0
              6F64AC695CAA6557825A579A5E57825A046904CDDACDE2EEE3E2EEE3E0EEE0DF
              ECDFDEEBDE4B6B603997551A453366A077AAD6B281AA8DFAFDFAF9FBFAF8FAF8
              94C79C55A45AC4E5CA94C79C73BB7C73BB7C6DB67564AC6957825A68B06F6DB6
              7555A45A57825A046904CDDACDE2EEE3E2EEE3E0EEE0DFECDF5176663997551A
              453366A077BADEC081AA8DFAFDFAFAFDFA94C79C5CAA65C4E5CA88C7927CC185
              7CC18573BB7C68B06F57825A68B06F73BB7C73BB7C6DB67555A45A57825A0469
              04CDDACDE2EEE3E2EEE3E0EEE05176663997551A45336CA67CBADEC08AB795FB
              FEFB94C79C68B06FC4E5CA9DD0A788C7927CC1857CC18573BB7C619964A8C2A8
              6199646DB67573BB7C73BB7C6DB67555A45A57825A046904CDDACDE2EEE3E2EE
              E35176663F9E5A1A45336CA67CBADEC08AB795FDFEFD6DB675C4E5CA9DD0A788
              C79288C79288C79273BA83619964D8E7D8F3F8F3CDDACD6199646DB67573BB7C
              73BB7C6DB67555A45A57825A046904E4EFE4E2EEE35176663F9E5A1A45336CA6
              7CC4E5CA8AB795FEFFFE6DB6756DB67568B06F64AC6964AC69619964619964E3
              EBE3F5F9F5F3F8F3F3F8F3CDDACD619964619964619964558E6757825A57825A
              57825AE6F0E6E4EFE45176663F9E5A214F3971AA81C4E5CA8AB795FFFFFFFEFF
              FEFDFEFDFBFEFBFAFDFAFAFDFAF9FBFAF8FAF8F6FAF6F6FAF5F5F9F5F3F8F3F3
              F8F3F1F7F1EFF6EFEDF5EDEDF5EDEBF3EBEAF2E9E8F1E8E8F1E8E6F0E6517666
              45A35F214F3971AA81C4E5CA8AB795FFFFFFFFFFFFFEFFFEFDFEFDFBFEFBFAFD
              FAFAFDFAF9FBFAF8FAF8F6FAF6F6FAF5F5F9F5F3F8F3F3F8F3F1F7F1EFF6EFED
              F5EDEDF5EDEBF3EBEAF2E9E8F1E8E8F1E851766645A35F214F3971AA81CCE9D2
              8AB795FFFFFFFFFFFFFFFFFFFEFFFEFDFEFDFBFEFBFAFDFAFAFDFAF9FBFAF8FA
              F8F6FAF6F6FAF5F5F9F5F3F8F3F3F8F3F1F7F1EFF6EFEDF5EDEDF5EDEBF3EBEA
              F2E9E8F1E851766645A35F214F3976AF85CCE9D281AA8D8AB7958AB7958AB795
              8AB7958AB7958AB7958AB79581AA8D81AA8D81AA8D81AA8D81AA8D76A08676A0
              8676A08676A08676A08676A0866C977E6C977E6C977E6C977E6C977E45A35F21
              4F3976AF85CCE9D2CCE9D2CCE9D2C4E5CAC4E5CAC4E5CABADEC0BADEC0BADEC0
              AAD6B2AAD6B2AAD6B29DD0A79DD0A794C79C94C79C88C79281BC907CC18573BA
              8373BA8363B27663B27663B2765CAA655CAA65214F3976AF8576AF8576AF8571
              AA8171AA8171AA816CA67C6CA67C6CA67C66A07766A07766A0775F9B725F9B72
              5F9B7258966B558E67558E67558E674D87624D87624D876247815D47815D4781
              5D417B57417B57417B57}
            ParentFont = False
            OnClick = SpeedButton1Click
          end
        end
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 1107
    Top = 4
    object File1: TMenuItem
      Caption = 'File'
      object Close1: TMenuItem
        Caption = 'Close'
        OnClick = Close1Click
      end
    end
  end
  object SaveDialog1: TSaveDialog
    Left = 32
    Top = 232
  end
end
