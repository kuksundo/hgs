object testDetail_Frm: TtestDetail_Frm
  Left = 0
  Top = 0
  Caption = 'testDetail_Frm'
  ClientHeight = 640
  ClientWidth = 999
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = #47569#51008' '#44256#46357
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object NxHeaderPanel1: TNxHeaderPanel
    Left = 0
    Top = 0
    Width = 999
    Height = 621
    Align = alClient
    HeaderFont.Charset = ANSI_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -11
    HeaderFont.Name = #47569#51008' '#44256#46357
    HeaderFont.Style = []
    HeaderSize = 36
    ParentHeaderFont = False
    TabOrder = 0
    FullWidth = 999
    object Label1: TLabel
      Left = 4
      Top = 5
      Width = 88
      Height = 25
      Caption = #50644#51652#53440#51077' :'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentFont = False
    end
    object AdvPageControl1: TAdvPageControl
      Left = 0
      Top = 36
      Width = 997
      Height = 583
      ActivePage = AdvTabSheet3
      ActiveFont.Charset = DEFAULT_CHARSET
      ActiveFont.Color = clWindowText
      ActiveFont.Height = -11
      ActiveFont.Name = 'Tahoma'
      ActiveFont.Style = [fsBold]
      Align = alClient
      DefaultTabColor = clCream
      DefaultTabColorTo = clWhite
      ActiveColor = 12767742
      ActiveColorTo = clCaptionText
      TabBackGroundColor = clWhite
      TabMargin.RightMargin = 0
      TabOverlap = 0
      Version = '2.0.0.3'
      PersistPagesState.Location = plRegistry
      PersistPagesState.Enabled = False
      TabOrder = 0
      TabWidth = 150
      object AdvTabSheet1: TAdvTabSheet
        Caption = #51088#46041#51077#47141' '#45936#51060#53552' '#51312#54924
        Color = clWindow
        ColorTo = clNone
        TabColor = clCream
        TabColorTo = clWhite
        object Panel3: TPanel
          Left = 0
          Top = 0
          Width = 989
          Height = 30
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object Label2: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 7
            Width = 232
            Height = 20
            Margins.Top = 7
            Align = alLeft
            Caption = #49884#54744#44592#44036' : 2012-12-05 ~ 2012-12-07'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = #47569#51008' '#44256#46357
            Font.Style = [fsBold]
            ParentFont = False
            ExplicitHeight = 17
          end
          object Label3: TLabel
            AlignWithMargins = True
            Left = 241
            Top = 7
            Width = 97
            Height = 20
            Margins.Top = 7
            Align = alLeft
            Caption = '/ '#51312#54924#44148#49688' : 0'#44148
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = #47569#51008' '#44256#46357
            Font.Style = [fsBold]
            ParentFont = False
            ExplicitHeight = 17
          end
          object Button4: TButton
            AlignWithMargins = True
            Left = 886
            Top = 3
            Width = 100
            Height = 24
            Align = alRight
            Caption = #49352#47196#44256#52840
            ImageIndex = 8
            ImageMargins.Left = 5
            Images = ImageList1
            TabOrder = 0
          end
          object Button5: TButton
            AlignWithMargins = True
            Left = 780
            Top = 3
            Width = 100
            Height = 24
            Align = alRight
            Caption = 'Analysis'
            ImageIndex = 9
            ImageMargins.Left = 5
            Images = ImageList1
            TabOrder = 1
            OnClick = Button5Click
          end
          object Button2: TButton
            AlignWithMargins = True
            Left = 674
            Top = 3
            Width = 100
            Height = 24
            Align = alRight
            Caption = 'To Excel'
            ImageIndex = 10
            ImageMargins.Left = 5
            Images = ImageList1
            TabOrder = 2
            OnClick = Button2Click
          end
        end
        object DBGrid1: TDBGrid
          Left = 0
          Top = 30
          Width = 989
          Height = 525
          Align = alClient
          DataSource = OraDataSource1
          ImeName = 'Microsoft Office IME 2007'
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
          TabOrder = 1
          TitleFont.Charset = ANSI_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = #47569#51008' '#44256#46357
          TitleFont.Style = []
        end
      end
      object AdvTabSheet2: TAdvTabSheet
        Caption = #49688#44592#51077#47141' '#45936#51060#53552' '#51312#54924
        Color = clWindow
        ColorTo = clNone
        TabColor = clCream
        TabColorTo = clWhite
        object Panel2: TPanel
          Left = 0
          Top = 0
          Width = 989
          Height = 30
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object Button10: TButton
            AlignWithMargins = True
            Left = 886
            Top = 3
            Width = 100
            Height = 24
            Align = alRight
            Caption = #49352#47196#44256#52840
            ImageIndex = 8
            ImageMargins.Left = 5
            Images = ImageList1
            TabOrder = 0
            OnClick = Button10Click
          end
          object Button6: TButton
            AlignWithMargins = True
            Left = 780
            Top = 3
            Width = 100
            Height = 24
            Align = alRight
            Caption = 'To Excel'
            ImageIndex = 10
            ImageMargins.Left = 5
            Images = ImageList1
            TabOrder = 1
            OnClick = Button6Click
          end
        end
        object DBGrid2: TDBGrid
          Left = 0
          Top = 30
          Width = 989
          Height = 525
          Align = alClient
          DataSource = OraDataSource2
          ImeName = 'Microsoft IME 2010'
          Options = [dgEditing, dgAlwaysShowEditor, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
          TabOrder = 1
          TitleFont.Charset = ANSI_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = #47569#51008' '#44256#46357
          TitleFont.Style = []
        end
      end
      object AdvTabSheet3: TAdvTabSheet
        Caption = #49464#48512#49324#50577' '#44288#47532
        Color = clWindow
        ColorTo = clNone
        TabColor = clCream
        TabColorTo = clWhite
        object GradientLabel1: TGradientLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 983
          Height = 13
          Margins.Bottom = 0
          Align = alTop
          AutoSize = False
          Caption = 'Fuel Injection Pump   '
          Color = clHighlight
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          Transparent = True
          EllipsType = etNone
          GradientType = gtCenterLine
          GradientDirection = gdLeftToRight
          Indent = 5
          LineWidth = 3
          Orientation = goHorizontal
          TransparentText = True
          VAlignment = vaTop
          Version = '1.2.0.0'
          ExplicitLeft = 1
          ExplicitTop = 40
          ExplicitWidth = 416
        end
        object GradientLabel2: TGradientLabel
          AlignWithMargins = True
          Left = 3
          Top = 135
          Width = 983
          Height = 13
          Margins.Bottom = 0
          Align = alTop
          AutoSize = False
          Caption = 'Fuel Injection Valve'
          Color = clHighlight
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          Transparent = True
          EllipsType = etNone
          GradientType = gtCenterLine
          GradientDirection = gdLeftToRight
          Indent = 5
          LineWidth = 3
          Orientation = goHorizontal
          TransparentText = True
          VAlignment = vaTop
          Version = '1.2.0.0'
          ExplicitTop = 187
          ExplicitWidth = 923
        end
        object GradientLabel3: TGradientLabel
          AlignWithMargins = True
          Left = 3
          Top = 223
          Width = 983
          Height = 13
          Margins.Bottom = 0
          Align = alTop
          AutoSize = False
          Caption = 'Main Bearing Spec.  '
          Color = clHighlight
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          Transparent = True
          EllipsType = etNone
          GradientType = gtCenterLine
          GradientDirection = gdLeftToRight
          Indent = 5
          LineWidth = 3
          Orientation = goHorizontal
          TransparentText = True
          VAlignment = vaTop
          Version = '1.2.0.0'
          ExplicitLeft = 15
          ExplicitTop = 339
        end
        object GradientLabel4: TGradientLabel
          AlignWithMargins = True
          Left = 3
          Top = 377
          Width = 983
          Height = 13
          Margins.Bottom = 0
          Align = alTop
          AutoSize = False
          Caption = 'Con-rod Bearing Spec.  '
          Color = clHighlight
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          Transparent = True
          EllipsType = etNone
          GradientType = gtCenterLine
          GradientDirection = gdLeftToRight
          Indent = 5
          LineWidth = 3
          Orientation = goHorizontal
          TransparentText = True
          VAlignment = vaTop
          Version = '1.2.0.0'
          ExplicitLeft = -5
          ExplicitTop = 439
        end
        object op_fip: TAdvStringGrid
          AlignWithMargins = True
          Left = 15
          Top = 19
          Width = 971
          Height = 110
          Cursor = crDefault
          Margins.Left = 15
          Align = alTop
          ColCount = 2
          DrawingStyle = gdsClassic
          RowCount = 4
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          ScrollBars = ssHorizontal
          TabOrder = 0
          OnKeyPress = op_fipKeyPress
          OnSelectCell = op_fipSelectCell
          OnGetAlignment = op_fivGetAlignment
          OnCanEditCell = op_fipCanEditCell
          OnGetEditorType = op_fipGetEditorType
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
          FixedColWidth = 150
          FixedRowHeight = 22
          FixedFont.Charset = DEFAULT_CHARSET
          FixedFont.Color = clWindowText
          FixedFont.Height = -11
          FixedFont.Name = 'Tahoma'
          FixedFont.Style = [fsBold]
          FloatFormat = '%.2f'
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
          RowHeaders.Strings = (
            ''
            'Shim Plate,[mm]'
            'Thrust Plate,[mm]'
            'Inj. Timing(bTDC)')
          ScrollBarAlways = saHorz
          ScrollType = ssFlat
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
          Version = '6.1.1.0'
          ColWidths = (
            150
            64)
          RowHeights = (
            22
            22
            22
            22)
        end
        object op_fiv: TAdvStringGrid
          AlignWithMargins = True
          Left = 15
          Top = 151
          Width = 971
          Height = 66
          Cursor = crDefault
          Margins.Left = 15
          Align = alTop
          ColCount = 2
          DrawingStyle = gdsClassic
          RowCount = 2
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          ScrollBars = ssHorizontal
          TabOrder = 1
          OnKeyPress = op_fivKeyPress
          OnSelectCell = op_fivSelectCell
          OnGetAlignment = op_fivGetAlignment
          OnCanEditCell = op_fivCanEditCell
          OnGetEditorType = op_fivGetEditorType
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
          FixedColWidth = 150
          FixedRowHeight = 22
          FixedFont.Charset = DEFAULT_CHARSET
          FixedFont.Color = clWindowText
          FixedFont.Height = -11
          FixedFont.Name = 'Tahoma'
          FixedFont.Style = [fsBold]
          FloatFormat = '%.2f'
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
          RowHeaders.Strings = (
            ''
            'Opening Press. [bar]')
          ScrollBarAlways = saHorz
          ScrollType = ssFlat
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
          Version = '6.1.1.0'
          ColWidths = (
            150
            64)
          RowHeights = (
            22
            22)
        end
        object mbGrid: TAdvStringGrid
          AlignWithMargins = True
          Left = 15
          Top = 239
          Width = 971
          Height = 132
          Cursor = crDefault
          Margins.Left = 15
          Align = alTop
          ColCount = 2
          DrawingStyle = gdsClassic
          RowCount = 5
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          ScrollBars = ssHorizontal
          TabOrder = 2
          OnKeyPress = mbGridKeyPress
          OnSelectCell = mbGridSelectCell
          OnGetAlignment = op_fivGetAlignment
          OnCanEditCell = mbGridCanEditCell
          OnGetEditorType = mbGridGetEditorType
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
          FixedColWidth = 150
          FixedRowHeight = 22
          FixedFont.Charset = DEFAULT_CHARSET
          FixedFont.Color = clWindowText
          FixedFont.Height = -11
          FixedFont.Name = 'Tahoma'
          FixedFont.Style = [fsBold]
          FloatFormat = '%.2f'
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
          RowHeaders.Strings = (
            ''
            'MAKER'
            'TYPE'
            'SERIAL'
            'PART NO.')
          ScrollBarAlways = saHorz
          ScrollType = ssFlat
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
          Version = '6.1.1.0'
          ColWidths = (
            150
            64)
          RowHeights = (
            22
            22
            22
            22
            22)
        end
        object Panel1: TPanel
          Left = 0
          Top = 530
          Width = 989
          Height = 25
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 3
          object Button3: TButton
            AlignWithMargins = True
            Left = 864
            Top = 1
            Width = 120
            Height = 23
            Margins.Top = 1
            Margins.Right = 5
            Margins.Bottom = 1
            Align = alRight
            Caption = #49464#48512#49324#54637' '#51200#51109
            ImageIndex = 0
            ImageMargins.Left = 5
            TabOrder = 0
            OnClick = Button3Click
          end
        end
        object crGrid: TAdvStringGrid
          AlignWithMargins = True
          Left = 15
          Top = 393
          Width = 971
          Height = 132
          Cursor = crDefault
          Margins.Left = 15
          Align = alTop
          ColCount = 2
          DrawingStyle = gdsClassic
          RowCount = 5
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          ScrollBars = ssHorizontal
          TabOrder = 4
          OnKeyPress = crGridKeyPress
          OnSelectCell = crGridSelectCell
          OnGetAlignment = op_fivGetAlignment
          OnCanEditCell = crGridCanEditCell
          OnGetEditorType = crGridGetEditorType
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
          FixedColWidth = 150
          FixedRowHeight = 22
          FixedFont.Charset = DEFAULT_CHARSET
          FixedFont.Color = clWindowText
          FixedFont.Height = -11
          FixedFont.Name = 'Tahoma'
          FixedFont.Style = [fsBold]
          FloatFormat = '%.2f'
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
          RowHeaders.Strings = (
            ''
            'MAKER'
            'TYPE'
            'SERIAL'
            'PART NO.')
          ScrollBarAlways = saHorz
          ScrollType = ssFlat
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
          Version = '6.1.1.0'
          ColWidths = (
            150
            64)
          RowHeights = (
            22
            22
            22
            22
            22)
        end
      end
      object AdvTabSheet4: TAdvTabSheet
        Caption = #50976#47448#51221#48372' '#44288#47532
        Color = clWindow
        ColorTo = clNone
        TabColor = clCream
        TabColorTo = clWhite
        object OILGRID: TAdvStringGrid
          Left = 0
          Top = 0
          Width = 989
          Height = 530
          Cursor = crDefault
          Align = alClient
          Ctl3D = True
          DefaultColWidth = 231
          DrawingStyle = gdsClassic
          RowCount = 12
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 0
          OnKeyPress = OILGRIDKeyPress
          OnSelectCell = OILGRIDSelectCell
          OnGetAlignment = op_fivGetAlignment
          OnCanEditCell = OILGRIDCanEditCell
          OnGetEditorType = OILGRIDGetEditorType
          OnGetEditorProp = OILGRIDGetEditorProp
          ActiveCellFont.Charset = DEFAULT_CHARSET
          ActiveCellFont.Color = clWindowText
          ActiveCellFont.Height = -11
          ActiveCellFont.Name = 'Tahoma'
          ActiveCellFont.Style = [fsBold]
          ColumnHeaders.Strings = (
            '  DESCRIPTION'
            '  FUEL OIL'
            ''
            ''
            '  LUB. OIL'
            '')
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
          ControlLook.DropDownFooter.Font.Name = 'MS Sans Serif'
          ControlLook.DropDownFooter.Font.Style = []
          ControlLook.DropDownFooter.Visible = True
          ControlLook.DropDownFooter.Buttons = <>
          Filter = <>
          FilterDropDown.Font.Charset = DEFAULT_CHARSET
          FilterDropDown.Font.Color = clWindowText
          FilterDropDown.Font.Height = -11
          FilterDropDown.Font.Name = 'MS Sans Serif'
          FilterDropDown.Font.Style = []
          FilterDropDownClear = '(All)'
          FixedColWidth = 231
          FixedRowHeight = 22
          FixedFont.Charset = DEFAULT_CHARSET
          FixedFont.Color = clWindowText
          FixedFont.Height = -11
          FixedFont.Name = 'Tahoma'
          FixedFont.Style = [fsBold]
          FloatFormat = '%.2f'
          PrintSettings.DateFormat = 'dd/mm/yyyy'
          PrintSettings.Font.Charset = DEFAULT_CHARSET
          PrintSettings.Font.Color = clWindowText
          PrintSettings.Font.Height = -11
          PrintSettings.Font.Name = 'MS Sans Serif'
          PrintSettings.Font.Style = []
          PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
          PrintSettings.FixedFont.Color = clWindowText
          PrintSettings.FixedFont.Height = -11
          PrintSettings.FixedFont.Name = 'MS Sans Serif'
          PrintSettings.FixedFont.Style = []
          PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
          PrintSettings.HeaderFont.Color = clWindowText
          PrintSettings.HeaderFont.Height = -11
          PrintSettings.HeaderFont.Name = 'MS Sans Serif'
          PrintSettings.HeaderFont.Style = []
          PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
          PrintSettings.FooterFont.Color = clWindowText
          PrintSettings.FooterFont.Height = -11
          PrintSettings.FooterFont.Name = 'MS Sans Serif'
          PrintSettings.FooterFont.Style = []
          PrintSettings.PageNumSep = '/'
          RowHeaders.Strings = (
            '  DESCRIPTION'
            '  KIND OF OIL'
            '  GRAVITY (15/4%)'
            '  FLASH POINT ('#8451')'
            '  VISCOCITY (cst) at 50 '#8451
            '  VISCOCITY (cst) at 40 '#8451
            '  RE. CARBON (wt '#8451')'
            '  ASH. (wt %)'
            '  WATER (vol %)'
            '  SULFER (wt %)'
            '  LCV (kj / kg)'
            '  NET.CAL.VALUE (kcal/kg)'
            ''
            '')
          ScrollBarAlways = saVert
          ScrollSynch = True
          SearchFooter.FindNextCaption = 'Find &next'
          SearchFooter.FindPrevCaption = 'Find &previous'
          SearchFooter.Font.Charset = DEFAULT_CHARSET
          SearchFooter.Font.Color = clWindowText
          SearchFooter.Font.Height = -11
          SearchFooter.Font.Name = 'MS Sans Serif'
          SearchFooter.Font.Style = []
          SearchFooter.HighLightCaption = 'Highlight'
          SearchFooter.HintClose = 'Close'
          SearchFooter.HintFindNext = 'Find next occurence'
          SearchFooter.HintFindPrev = 'Find previous occurence'
          SearchFooter.HintHighlight = 'Highlight occurences'
          SearchFooter.MatchCaseCaption = 'Match case'
          ShowDesignHelper = False
          Version = '6.1.1.0'
          ColWidths = (
            231
            165
            165
            165
            173)
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
            22
            22
            22)
        end
        object Panel4: TPanel
          Left = 0
          Top = 530
          Width = 989
          Height = 25
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 1
          object Button1: TButton
            AlignWithMargins = True
            Left = 864
            Top = 1
            Width = 120
            Height = 23
            Margins.Top = 1
            Margins.Right = 5
            Margins.Bottom = 1
            Align = alRight
            Caption = #50976#47448#51221#48372' '#51200#51109
            ImageIndex = 0
            ImageMargins.Left = 5
            TabOrder = 0
            OnClick = Button1Click
          end
        end
      end
    end
    object engType: TJvEdit
      Left = 98
      Top = 8
      Width = 295
      Height = 25
      ImeName = 'Microsoft Office IME 2007'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
      Text = 'engType'
    end
  end
  object AdvOfficeStatusBar1: TAdvOfficeStatusBar
    Left = 0
    Top = 621
    Width = 999
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
  object OraDataSource1: TOraDataSource
    DataSet = OraQuery1
    Left = 104
    Top = 224
  end
  object OraQuery1: TOraQuery
    Session = DM1.OraSession1
    Left = 40
    Top = 216
  end
  object OraQuery2: TOraQuery
    Session = DM1.OraSession1
    Left = 40
    Top = 296
  end
  object OraDataSource2: TOraDataSource
    DataSet = OraQuery2
    Left = 104
    Top = 296
  end
  object ImageList1: TImageList
    ColorDepth = cd32Bit
    Left = 816
    Top = 8
    Bitmap = {
      494C01010B000F002C0010001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000101010F020101290603024606030245020101290101010F0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000101011D010101330101011D0000000000000000000000001D1D1D965151
      51FF515151FF515151FF515151FF515151FF515151FF515151FF515151FF5151
      51FF515151FF515151FF515151FF1D1D1D960000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000101
      010506030246391B0BB181431EEBA55C2AF7AC612CF6915226E83E2110A90603
      0241010101050000000000000000000000000101011D010101330101011C0000
      0000000000000000000000000000000000000000000000000000000000000000
      000001014CA50101D1FF01014EA6000000000000000000000000555555FFFFFF
      FFFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFD
      FDFFFDFDFDFFFDFDFDFFFFFFFFFF555555FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000010101031007
      03687C3E1DEEB7662CFECC752FFFD97D32FFE58535FFF18E38FFF0903DFEA160
      2FE81008046001010103000000000000000001014EA60101D1FF01014EA50000
      0000010101240101013301010125000000000000000000000000000000000000
      00000101D1FF0101D1FF0101D1FF00000000276839FF276839FF276839FF2768
      39FF276839FF276839FF276839FF276839FF276839FF276839FFF1F1F1FFF0F0
      F0FFF0F0F0FFEFEFEFFFFDFDFDFF595959FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000070302437E41
      1FF0B26129FEC06B2BFFC06D2EFEB7672CFCC37031FCE38638FEFB953AFFFB96
      3DFEA96734E90604023D00000000000000000101D1FF0101D2FF0101D9FF0000
      0000704F1FC5BF863FFF6E4E24C8000000000000000000000000000000000101
      01310101D1FF0101D1FF0101418E000000002B6F3DFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2B6F3DFFF0F0F0FFEFEF
      EFFFEFEFEFFFEEEEEEFFFDFDFDFF5F5F5FFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000001010105452210BCA458
      28FEB36228FF9F5626FA371A0BA60B05024B0B05024A3B1F0FA0CF7B36F9FC96
      3CFEF89640FE54321AB201010104000000000101418D0101D2FF0101C6F60000
      0000CD9034FFBF873EFFBF873EFF000000000000000000000000010101310101
      BFF5010164B00000000000000000000000002F7743FF677465FF507B51FF468A
      4AFF487E49FF558156FF719F73FF508152FF537E58FF2F7743FFEFEFEFFFEEEE
      EEFFEEEEEEFFEDEDEDFFFDFDFDFF646464FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000003020126894A27F3A85A
      26FFA85C29FE2D15099701010104000000000000000001010103311A0D90ED8E
      3CFDFE983CFFBC733AEE030201210000000000000000010110440101D7FF0101
      0131CE9133FFC0873EFFB37E3AF70000000000000000010101310101C3F70101
      6BB60000000000000000000000000000000034814AFFFFFFFFFF3E7A40FF347D
      34FF3A803BFF7CAD7DFF5B9E5EFF346E34FFFFFFFFFF34814AFFEEEEEEFFEDED
      EDFFEDEDEDFFECECECFFFDFDFDFF6B6B6BFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000A050246A26037FBAE64
      30FF924F27F705030230000000000000000000000000000000000403022BC275
      37F4F59641FEDF8E48F90904023F00000000000000000000000001019CD6573D
      7DF59E7026DF110C0649C3893CFF010101210101012F0101C4F601016BB60000
      000000000000000000000000000000000000398A51FFFFFFFFFFFFFFFFFF4A87
      4AFF82B37EFF60905AFF3E813DFF67A366FF81A882FF398A51FFEDEDEDFFECEC
      ECFFEBEBEBFFEBEBEBFFFDFDFDFF717171FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000A050349AB6B40FCB873
      40FF935630F40302012400000000000000000201011F01010103010101051E10
      087225150B7824150B7603020125000000000000000001010101140E1174CA8F
      35FF06050E5A00000000AD7A2BEA593F1DB50101BEED01016AB4000000000000
      0000000000000000000000000000000000003D9357FFFFFFFFFFFFFFFFFF8FC1
      95FF5B8660FF3D6940FF477E4CFFFFFFFFFFF3FFF9FF3D9357FFEBEBEBFFEBEB
      EBFFEAEAEAFFEAEAEAFFFDFDFDFF787878FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000503022FA16842F6BE7D
      4AFFB27345FC170C067301010104000000002613098B0A050350010101030000
      0000000000000000000000000000000000000101012502020137CE9133FF3324
      79DE01019EDA010101130E0A075A120DC4FF010167B200000000000000000000
      000000000000010101250101013301010125429D5EFFFFFFFFFF91B994FF478C
      4EFF3B743EFF467A4AFF347737FF3B813FFFFFFFFFFF429D5EFFEAEAEAFFEAEA
      EAFFE9E9E9FFE9E9E9FFFDFDFDFF7E7E7EFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000101010669432BCEC286
      54FEC48653FE8D5C3AE8120A056A02010124422919A995613AE50A05034E0101
      0103000000000000000000000000000000006B4C25C7C0873EFFBA832DF30000
      00000101D6FF0101287E0101ADE43525A8FF7D591AC90101010B000000000000
      0000000000006E4E24C8BD8540FF6E4E26C946A564FF86907EFF62855CFF427D
      42FFFFFFFFFFFFFFFFFF4E844BFF3C7839FF4D7750FF46A564FFE9E9E9FFE8E8
      E8FFE8E8E8FFE7E7E7FFFDFDFDFF848484FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000011090557B481
      57F8CC935FFFCC925DFEB98154F98D5D3CE39E6B47EBDF9A5AFE9B6A41E30A05
      034C01010103000000000000000000000000BD8540FFC0873EFFD09331FF0000
      00000101C2F50101D3FF0101DFFF00000000C58B3AFF0F0B065A000000000000
      000000000000BD8540FFBD8540FFBD8540FF4AAC68FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4AAC68FFFDFDFDFFFDFD
      FDFFFDFDFDFFFDFDFDFFFDFDFDFF8A8A8AFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000010101032C1C
      1188BE8E63F9D19D68FED69E67FFD99F66FFDDA064FFE1A162FFE4A362FE9D6F
      48E10402022E000000000000000000000000674923BBC0873EFF6B4C19B60000
      00000101D3FF0101D3FF0101E0FF000000005B411DAF906631E2010101110000
      000001010123BD8540FFBD8540FF644622B94CB16CFF4CB16CFF4CB16CFF4CB1
      6CFF4CB16CFF4CB16CFF4CB16CFF4CB16CFF4CB16CFF4CB16CFFFDFDFDFFE0E0
      E0FFE5E5E5FFEBEBEBFF909090FF333333960000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000101
      0103160E0962886445DACB9E6FFAD8A874FEDBA973FEE0A86DFFDFA86FFD593C
      27AF0101010F0000000000000000000000000000000000000000000000000000
      0000010170B90101D3FF010177B90000000000000000BD8540FF1E150B770101
      0133624621BFA67638EF00000000000000000000000000000000959595FFFDFD
      FDFFE9E9E9FFE8E8E8FFE8E8E8FFE7E7E7FFE7E7E7FFE6E6E6FFFDFDFDFFE5E5
      E5FFEBEBEBFF959595FF35353596000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000101010E0B0604441D130C6972553CC7DBB07CFD583E2AAF0201
      0110000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B47E3DF9BD8540FFBD85
      40FFA57438EE00000000000000000000000000000000000000009A9A9AFFFDFD
      FDFFE8E8E8FFE7E7E7FFE7E7E7FFE6E6E6FFE5E5E5FFE5E5E5FFFDFDFDFFEBEB
      EBFF9A9A9AFF3636369600000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000412F229B57402DAF020101100000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BD8540FFBD8540FFBD85
      40FF0000000000000000000000000000000000000000000000009E9E9EFFFDFD
      FDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFF9E9E
      9EFF373737960000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001008045A02010110000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000654722BABD8540FF6446
      22B900000000000000000000000000000000000000000000000039393996A1A1
      A1FFA1A1A1FFA1A1A1FFA1A1A1FFA1A1A1FFA1A1A1FFA1A1A1FFA1A1A1FF3939
      3996000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000001010101010101070303
      03190B0B0B331717174C2020205B2121215C1919194F0D0D0D38734319BD7B58
      15B7694224B40000000000000000000000000000000000000000000000000000
      0000010101180101014801010160010101600101016001010160010101480101
      0118000000000000000000000000000000000000000000000000000000000000
      00000102012D17370ACD01010101000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000042AC52FF42AC52FF000000000000000001010104030303181818184F4A4A
      4A9C787777D6A09F9FF2A09D9CF99F9B9AF9A2A1A0F3818080DDCE7624FFEEA9
      25FFD18148FF0101010600000000000000000000000000000000000000000000
      000001010120016AC6FF0176DCFF0179DDFF017CDFFF017EE0FF0177D1FF0101
      0120000000000000000000000000000000000000000000000000000000000102
      0221265913F11D550CEB00000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000002121215A4B51
      5598464D5498464B5296464B5196464B5196464B5196FFFFFFFFFFFFFFFFFFFF
      FFFF42AC52FF42AC52FF0000000000000000030303172525256C5F5C5CE77671
      6FFFC4C3C2FFDAD8D8FFCACBCAFFCAC9C8FFD7D6D5FFC6C6C6FFCF7924FFEEA9
      25FFD18248FF0505052001010104000000000000000000000000000000000000
      0000010101200172DAFF0181F6FF0184F7FF0187F7FF018AF7FF0180E1FF0101
      0120000000000000000000000000000000000000000000000000010203222359
      1EEC438A41FF1D570EEB184501DA184601DA184701DB184701DB184701DB1847
      01DB184501DA184501DA0D2502A0000000000000000000000000CCCCCCE46793
      CDFF6599D5FF5C91D2FF5990D0FF5990D0FF578ECFFFFFFFFFFF42AC52FF42AC
      52FF42AC52FF42AC52FF42AC52FF42AC52FF13131353777675F2A8A7A6FFA1A1
      9FFF898687FF91908FFF8D8988FF8C8B88FF939290FF8C8B89FFD07823FFEEA9
      25FFD18248FF1E1E1E6B00000000000000000000000000000000000000000000
      0000010101200172DAFF0181F6FF0183F6FF0186F7FF0189F7FF017FE1FF0101
      0120000000000000000000000000000000000000000001030425245619EC4689
      42FF388B3AFF37A23BFD2CA431F226AE2FF221B82DF21CB92AF218B423F211A5
      1BF20D8A14F00E7413F51C570CF0000000000000000000000000C7C7C7E16C92
      CBFF79B3EBFF8CCBFCFF78BFFBFF5EAEF7FF51A6F6FFFFFFFFFF42AC52FF42AC
      52FF42AC52FF42AC52FF42AC52FF42AC52FF3C3C3ABCB7B6B5FF6D6B69FF6F6B
      6AFFCACAC9FFE1E1E0FFCAC9C8FFCF7823FFCF7823FFCF7824FFCF7823FFEEA9
      25FFD18248FFD18248FFD18148FFCC7323FF0000000000000000000000000000
      0000010101200170D9FF0180F6FF0182F6FF0185F7FF0188F7FF017DE0FF0101
      01200000000000000000000000000000000000000000194315D548893BFF388E
      3BFF33AC37FF2FC437FF2ED639FF29E138FF24E935FF1BE72CFF11DB21FF07C6
      13FF01A106FF017003FF185D09F8000000000000000000000000141414469595
      96C3B1C2E0FE6592CFFF61A1E1FF6FB6F5FF60AEF4FFFFFFFFFFFFFFFFFFFFFF
      FFFF42AC52FF42AC52FF0000000000000000848281ED9A9897FFA4A3A2FFA6A4
      A3FF8E8D8CFF90918EFF8C8987FF8B8887FFCF7823FFFFC32DFFFFC42DFFEEA9
      25FFDD8F32FFDD9032FFCC7323FF000000000000000001010108010101180101
      012001010138016FD9FF017EF6FF0181F6FF0183F6FF0186F7FF017CDFFF0101
      0138010101200101011801010108000000000000000002050835175A17EB0EA3
      11FF29C937FF44D254FB4AC358EA5CCD68EA63CE6FEA58CE61EA45C649E83AB7
      47F02ABF3AFF028F07FF18630AF8000000000101010701010108010101080101
      01080D0D0D3B878787BABAC9E0FD659ED9FF60A0E1FFA9BCDBFE9C9DA0CDFFFF
      FFFF42AC52FF42AC52FF0101010801010107A3A1A0FAB1B0AFFF73706FFF6765
      62FFB5B3B0FFC4C3C2FFB2B1B2FFB2B1B0FFC0BFBEFFCF7823FFFFC42DFFEEA9
      24FFDD9032FFCC7222FF00000000000000000000000001010114010101400101
      015C010101680172DFFF017DF6FF017FF6FF0181F6FF0183F6FF017DE4FF0101
      01680101015C0101014001010114000000000000000002060A3802111E5D2176
      24F04AEB50FF29761CEA123402BA123502BA133502BB133502BB113101B6163F
      05C749D958FF09AB11FF186C0AF800000000100B0557140E0661130D065F120C
      055F120C055F31292388C5D1E7FE68A3DDFF69AAE9FFA7BDDEFF3A3C4E9CFFFF
      FFFFFFFFFFFFFFFFFFFF04061861030513579D9C99F6908D8BFF888685FFA1A0
      9FFFB1B0AFFFAEACAAFFB9B9B7FFBCBDB9FFB2B1B0FFB2B1B0FFCF7823FFEEA9
      24FFCC7222FFB1B0AFFF00000000000000000000000001010110015CB3FF0167
      D0FF016DDEFF5FA8F4FF449DF8FF2890F7FF1087F7FF0281F6FF0181F0FF017D
      E4FF0179DBFF016FC6FF0101011000000000000000000416277104223F801833
      458B378F35F4357B25EA000000000000000000000000000000000B195BBE0B23
      0E842E772FB2096C10C2155807DF00000000957651E2D3B485FFC5A06CFFBD96
      63FFBB9362FFDACCBAFF6394D0FF89C7FAFF7CC0FAFF5B8DCDFFC8CCF3FF626D
      E0FF5E68DFFF5D66DFFF6A72E5FF4452ACE9939291F7A19F9EFF9F9E9CFFB2B1
      B1FFBBB9B7FFBFBEBCFFC2C0BDFFC3C2BEFFC3C2BFFFC2C0BEFFBDBCB9FFCF78
      23FF9C9B9BFFAAA8A7FF00000000000000000000000001010104041C3490398A
      E4FF73B1F7FF76B4FAFF76B6FAFF70B4F9FF65AFFAFF52A7F9FF3F9FF8FF3198
      F5FF1383E5FF0B28449C010101040000000000000000083154AB035197CB2258
      8EBE061226811E4D10C001010101000000000000000000000000233C8DE3284A
      9AF31029166A03180456103B04BC00000000100B06576D5335C5CCA976FFCBA4
      6DFFB98C50FFDCCFBFFF6697D2FF8CCAF9FF7CC0F9FF578ED0FFC2CAF3FF6069
      EEFF6D73F0FF6C72E9FF4C55B4EA0A0E287D999897F6959391FFA6A4A2FFA7A6
      A3FFAAA8A7FFACABAAFFAFAEACFFB0AFACFFB0AFACFFAEACACFFABABA9FFAFAE
      ABFF9B9898FFABABA9FE0000000000000000000000000000000001010104041C
      3590408EE5FF7FB8F7FF7DB9FAFF7AB8FAFF76B7FAFF71B6FAFF6AB2F7FF3290
      E7FF0A26419A010101040000000000000000000000000D4E88DE0178E1FF208D
      F9FF208DF9FF010136A802033AAD01023AAD010239AC010238AB173488E23599
      FFFF0D3682EC0207022E0101010A00000000010101090101011B110C065B5942
      2AB7C39F6BFBE5D8C8FE6491CEFFA1D7FDFF96D2FDFF5A8ECDFFCDD2F3FE727B
      E8FD2A326DBE090C2172020205360101010D8A8887F5ABAAA8FFA7A6A4FFAAA9
      A7FFAEACABFFB0AFAEFFB2B1AFFFB2B2B0FFB2B1AFFFB0B0AEFFAFAEABFFACAB
      A9FFB2B1AEFFA09F9EFE00000000000000000000000000000000000000000101
      0104041C35904692E5FF87BDF8FF83BCFAFF7FBAFAFF78B7F8FF3890E7FF0823
      3D970101010400000000000000000000000000000000124D87E10773D7FF0F7C
      E0FF1E77D1ED327CC9E24E8DCCE45A94CCE45390CBE43E83C6E42789ECF90278
      ECFF1772CDFF062954DD0103011B000000000000000000000000010101070202
      01279A7B51E4D3BB9DFBB8C8E2FE6495D3FF6398D7FF9DB7DCFF9C9FD0F06E79
      D6F9020309410101010A0101010300000000989695FAC2C0BDFFB6B5B3FFB8B7
      B6FFBBB9B8FFBDBCB9FFBEBDBBFFBEBDBCFFBEBDBBFFBDBCBBFFBCBBB8FFBBB9
      B7FFC4C3BFFFB0AFAEFF00000000000000000000000000000000000000000000
      000001010104041C35904993E6FF8DC0F8FF86BDF8FF4092E6FF07213B950101
      010400000000000000000000000000000000000000002B5A8CE24896ECFF3999
      EDFF33AAFDFF48B7FFFF61C0FFFF61BFFFFF4BB5FFFF29A4FFFF0C8AF3FF1B86
      E0FF2888D8FF1C6BC4FF082041C90000000000000000000000000101010D3325
      158FCFAB75FECFAB73FF807263C88591A2D88795AFE27B7E94CD7F8AECFE7E89
      F1FF1E2453A7010101100000000000000000656563C1C8C8C6FFCBCAC9FFC9C6
      C5FFCAC9C8FFCBCAC9FFCBCBCAFFCCCBCAFFCBCBCAFFCBCAC9FFCAC9C8FFCBCA
      CBFFCFCECCFF848483DC00000000000000000101010801010118010101200101
      01200101012001010124031E3A9F4B94E3FF4893E3FF05213EA2010101240101
      0120010101200101012001010118010101080000000039536ED277AAE0FB649F
      D1F45FA4D7F45AA8DBF45BAADFF553A7DFF5479DDBF54292D2F54997DCFD4395
      E0FF438FE0FF153270E90205022F000000000000000001010101020201238B6F
      47D8D3AD6CFFCDA563FF8C6E49DF02020127010102254D5599D87B8AF6FF7481
      F5FF4B54A1DF0101032701010102000000000707072BA8A8A6EDDEDDDCFFE3E3
      E2FFE0E0DEFFDEDEDDFFE0DDDEFFE0E0DEFFE0DEDEFFE1E0E0FFE4E3E3FFE3E2
      E2FFBABAB9F80F0E0E4100000000000000000101011801010148010101600101
      016001010160010101600101016403244AB803244BB801010164010101600101
      0160010101600101016001010148010101180000000001021365020328920202
      3BB202033CB202033CB202043DB302043EB402043DB301023BB21E2E76E594C1
      FDFF314E80E90104022A00000000000000000000000001010102030201279B7C
      51E0D8B46EFFD3AB67FF95764EE20302022C010203295861A7E07D8EF8FF7786
      F6FF515CA8E20102032A01010102000000000000000006060627666665B1E3E3
      E2FDF7F7F7FFFCFCFCFFFDFDFDFFFDFDFDFFFCFCFCFFF8F8F8FFE9E8E8FF7776
      76BF0A0A0A36000000000000000000000000010101180156B4FF015DCFFF015E
      D0FF015FD0FF0160D1FF0163D5FF0167DEFF0168DEFF0167D7FF0165D3FF0166
      D4FF0167D4FF0167D4FF0160BDFF010101180000000000000000000000000000
      00000000000000000000000000000000000000000000000000002A3271E35A63
      99F10103022A00000000000000000000000000000000000000000101011B4532
      1DA0DCBC82FFDDBE84FF584228B40101011D0101011B22244BA08D9AF0FF8E9C
      F3FF2A3163B40101011D00000000000000000000000000000000000000000808
      082E2D2D2D73656565AA878787C88A8A8ACA6A6A6AAF3434347B0B0B0B370000
      000000000000000000000000000000000000010101080156B4FF015DCFFF015D
      CFFF015ECFFF015FD0FF0160D0FF0161D1FF0161D1FF0162D2FF0163D2FF0164
      D3FF0164D3FF0165D3FF015DBAFF010101080000000000000000000000000000
      0000000000000000000000000000000000000000000000000000171A36B90202
      0336000000000000000000000000000000000000000000000000010101040202
      0124261B0E7B3526158F050302330101010701010104010102241013297B181B
      398F020205330101010700000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000001010129010101380101
      014805080D84053565FF30383BFF30383BFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000203
      0540053565FF06407BFFDDE1C0FF30383BFF0000000000000000010101020101
      0114010101140101011401010114010101140101011401010114010101140101
      052F093791DB071831A500000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000018001FF018001FF018001FF018001FF000000000000
      0000000000000000000000000000000000000000000000000000000000000101
      010C1412106F35322BBA444037D2423E36CF34312AB711100E660304073F023F
      7CFF06407BFF1865A5FF9FD7F4FF145D9CFF00000000000000002F2F2FBF7878
      78E8757575E8747474E8757575E8767676E8737373E8787773E8615D6BE80A40
      ADF337C8FFFF1A436DCE00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000018001FF37E289FF37E48BFF018001FF000000000000
      000000000000000000000000000000000000000000000000000009080748524D
      42E77C6D5AFFA98B6EFFC8A27CFFCAA47EFFAB8F71FF80715DFF5B5953FF283E
      5DFF053362FFCAF3FDFF145D9CFF000000000000000000000000B9B9B9FFFFFF
      FFFFFAFAFAFFF9F9F9FFE8E9E9FFDFE0E1FFEFEFEDFFEAE6F1FF4A82EEFF29BA
      FFFF276796E40101012100000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000018001FF48FBADFF48FCADFF018001FF000000000000
      000000000000000000000000000000000000000000000909084B615C4FFCC09F
      7DFFFDDFABFFFEFADEFFFFFFF3FFFFFFF2FFFEF2DFFFFED4A1FFB99977FF645E
      52FF283E5DFF145D9CFF02030638000000000000000000000000B2B2B2FFF8F8
      F8FFE3E3E4FFB0B1B1FFABA8A3FFA4A09BFF93908CFF8D8BA1FF89C0E2FF5CB3
      F4FF2C2939C70000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000018001FF01EF7DFF01EF7DFF018001FF000000000000
      00000000000000000000000000000000000001010112565146EDC8AA84FFFEEC
      B9FFFFF6C3FFFEEDB4FFFDE9AFFFFEEBB2FFFEF1BDFFFEF0C1FFFEE0AFFFB191
      72FF5C5A52FF0305074100000000000000000000000000000000B6B6B6FFF2F2
      F3FFB1B0B0FFDFD2C1FFFFEFDBFFFFF2DEFFE7D9C5FFA19A8EFF8E8FA6FFCFCD
      ECFF4A4A46CA000000000000000000000000000000000101B3FF0101B3FF0101
      B3FF0101B3FF0101B3FF0101B3FF0101B3FF0101B3FF0101B3FF0101B3FF0101
      B3FF0101B3FF0101B3FF0101B3FF000000000000000000000000000000000000
      00000000000000000000018001FF2BE17CFF29E17BFF018001FF000000000000
      0000000000000000000000000000000000001B1A168491846CFFFDDEADFFFCDD
      ADFFFCD69FFFFCD68EFFFCD992FFFCD88FFFFBD7A2FFFCD8A6FFFCD8A6FFFDD8
      A9FF81705CFF1615127500000000000000000000000000000000BCBCBCFFD2D3
      D5FFDDCEBDFFFFF0D5FFFFEAD0FFFFEAD0FFFFF3DAFFEAD4BCFF7F7C76FFEEED
      EAFF494A4ACA000000000000000000000000000000000101CCFF0101CCFF0101
      CCFF0101CCFF0101CCFF0101CCFF0101CCFF0101CCFF0101CCFF0101CCFF0101
      CCFF0101CCFF0101CCFF0101CCFF0000000000000000018001FF018001FF0180
      01FF018001FF018001FF018001FF3DD879FF3AD877FF018001FF018001FF0180
      01FF018001FF018001FF018001FF00000000444037D0C2A17EFFFBCB9AFFF9BD
      89FFF9C190FFFACC96FFF9CE91FFF8CC90FFF8C593FFF8C391FFFAC491FFFDC8
      96FFC59978FF39362EC000000000000000000000000000000000BBBCBCFFCCCB
      CAFFFADEBFFFFFDDB6FFFFD7ABFFFFD7ABFFFFDEB7FFFFE9C9FF908479FFCCCE
      D0FF4E4E4ECA000000000000000000000000000000000101DEFF0101DEFF0101
      E6FF0101E6FF0101E6FF0101E6FF0101E6FF0101E6FF0101E6FF0101E6FF0101
      E6FF0101E6FF0101DEFF0101DEFF0000000000000000289F32FF67D382FF62D4
      82FF60D784FF5CD886FF4CD479FF48D376FF44D273FF4DD47AFF53D580FF50D2
      79FF4ECE72FF4ECA6DFF1B9D26FF00000000645E51F9D8B089FFF9BA88FFF4B6
      83FFF1B27FFFEFB382FFF0B583FFEEB281FFEEB07FFFF0B281FFF6BC89FFF9B9
      87FFDEAD85FF524D42E700000000000000000000000000000000BCBDBDFFCFCD
      CCFFFDD1A6FFFFCE98FFFFCF9BFFFFCF9BFFFFCE9AFFFFD9A9FF978578FFC9CB
      CEFF515151CA000000000000000000000000000000000101D6FF0101D6FF0101
      F0FF0101F0FF0101FFFF0101FFFF0101FFFF0101FFFF0101FFFF0101FFFF0101
      F0FF0101F0FF0101D6FF0101D6FF0000000000000000289D2DFF72D180FF6BD1
      7EFF69D280FF67D882FF5DD37CFF55D077FF52CF74FF56D177FF5AD578FF57CD
      71FF55C96AFF55C665FF1E9B23FF00000000615C4FFCD6AA84FFF8B985FFEFAE
      7CFFECAA79FFECAA79FFECAA79FFECAA79FFECAA79FFECAA79FFEEB07EFFF5B5
      82FFDAA67FFF544F44EA00000000000000000000000000000000C3C3C3FFD3D4
      D7FFEEC3A2FFFFD8A9FFFFDEB9FFFFDCB7FFFFDBAFFFFAC291FF877C75FFE2E4
      E6FF515151CA0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000023C03B0054205B50440
      05B4044207B4043D05B42D873EE869D37EFF65D27CFF2F863EE7043C05B30442
      05B4044205B4044305B5023F03B2000000004A453CDBBC9879FFF5B583FFF3B4
      81FFEEAC7BFFECAA79FFECAA79FFECAA79FFECAA79FFEDAB79FFF0B07EFFF0AF
      80FFBE9877FF403C34CC00000000000000000000000000000000C4C4C4FFEDF0
      F1FFC2B5AFFFFACDADFFFFE9D0FFFFEDD5FFFFD6B2FFB08D79FF9FA1A3FFFCFC
      FCFF515151CA0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000022682BD678D483FF74D381FF24652BD5000000000000
      00000000000000000000000000000000000022201B938E8069FFE9A87CFFF9BC
      88FFF6B884FFF2B380FFF1B07EFFF1B17FFFF3B381FFF4B682FFF4B784FFE09E
      76FF8F7F67FF1B1A168400000000000000000000000000000000C3C3C3FFFFFF
      FFFFDBDEDFFFBEB2AEFFD3AFA1FFD1AA9BFFAD948AFFA3A4A6FFEAEBEBFFF8F8
      F8FF545454CA0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000027692CD886D489FF82D386FF28672DD7000000000000
      000000000000000000000000000000000000030303246B6657F9AC8467FFEAAA
      7DFFFBCF9EFFFFFCF1FFFFFFFFFFFFFFFFFFFFFBEFFFF8C391FFDD9F75FFA27E
      62FF686254F40202021800000000000000000000000000000000C7C7C7FFFFFF
      FFFFFEFEFEFFEDEFF0FFD4D7D9FFCCCFD0FFD8DBDDFFF4F4F4FFF1F1F1FFF8F8
      F8FF565656CA0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000002E6A30D99ADC99FF97DB95FF306732D7000000000000
      000000000000000000000000000000000000000000001412106F676052FFAD84
      67FFE7AC81FFF8E0C7FFFFFDFBFFFEFCFBFFF6DCC1FFD8A079FFA78063FF6860
      53FF0D0D0B5A0000000000000000000000000000000000000000CCCCCCFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9F9F9FFF7F7F7FFFFFF
      FFFF5D5D5DCE0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000225427CC82C686FF81C784FF245229CA000000000000
      00000000000000000000000000000000000000000000000000000E0D0B5B5854
      47F07F6C59FFAC8366FFC5906EFFC38E6CFFA98164FF7E6B58FF544F44EA0C0B
      0A53000000000000000000000000000000000000000000000000575757CDB2B2
      B2FCB1B1B1FCB0B0B0FCB0B0B0FCAFAFAFFCAEAEAEFCAEAEAEFCADADADFCAFAF
      AFFC2626269A0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000043D06B90C5811D20C5811D2043D06B9000000000000
      0000000000000000000000000000000000000000000000000000000000000202
      021B26241F9C544F44EA645E51FF645E51FF524D42E723211D96020202150000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
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
      000000000000}
  end
  object AdvGridExcelIO1: TAdvGridExcelIO
    Options.ExportOverwriteMessage = 'File %s already exists'#13'Ok to overwrite ?'
    Options.ExportRawRTF = False
    Options.ExportCellMargins = True
    UseUnicode = False
    GridStartRow = 0
    GridStartCol = 0
    DateFormat = 'YYYY-MM-DD HH:mm:ss'
    Version = '3.4.1'
    Left = 184
    Top = 272
  end
  object SaveDialog1: TSaveDialog
    Left = 184
    Top = 224
  end
end
