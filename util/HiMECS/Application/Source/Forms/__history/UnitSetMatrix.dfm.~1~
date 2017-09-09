object SetMatrixForm: TSetMatrixForm
  Left = 0
  Top = 0
  Caption = 'Matrix'
  ClientHeight = 474
  ClientWidth = 775
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 775
    Height = 27
    Align = alTop
    TabOrder = 0
    object ToolBar1: TToolBar
      Left = 1
      Top = 1
      Width = 773
      Height = 22
      AutoSize = True
      Caption = 'ToolBar1'
      Color = clBtnFace
      Customizable = True
      Images = ImageList1
      ParentColor = False
      TabOrder = 0
      Transparent = True
      object ToolButton3: TToolButton
        Left = 0
        Top = 0
        Width = 8
        Caption = 'ToolButton3'
        ImageIndex = 6
        Style = tbsSeparator
      end
      object ToolButton8: TToolButton
        Left = 8
        Top = 0
        Hint = 'Move Row Up'
        Caption = 'Download to controller'
        ImageIndex = 23
        ParentShowHint = False
        ShowHint = True
        OnClick = ToolButton8Click
      end
      object ToolButton20: TToolButton
        Left = 31
        Top = 0
        Width = 8
        Caption = 'ToolButton20'
        ImageIndex = 15
        Style = tbsSeparator
      end
      object btnUndo: TToolButton
        Left = 39
        Top = 0
        Hint = 'Undo(Ctrl+z)'
        Caption = 'btnUndo'
        ImageIndex = 2
        ParentShowHint = False
        ShowHint = True
        OnClick = btnUndoClick
      end
      object btnRedo: TToolButton
        Left = 62
        Top = 0
        Hint = 'Redo(Shift+Ctrl+z)'
        Caption = 'btnRedo'
        ImageIndex = 1
        ParentShowHint = False
        ShowHint = True
        OnClick = btnRedoClick
      end
      object ToolButton1: TToolButton
        Left = 85
        Top = 0
        Width = 8
        Caption = 'ToolButton1'
        ImageIndex = 17
        Style = tbsSeparator
      end
      object btnSave: TToolButton
        Left = 93
        Top = 0
        Hint = 'Save Matrix data to file'
        Caption = 'btnSave'
        ImageIndex = 17
        ParentShowHint = False
        ShowHint = True
        Style = tbsCheck
      end
      object btnOpen: TToolButton
        Left = 116
        Top = 0
        Hint = 'Load from Matrix file '
        Caption = 'btnOpen'
        ImageIndex = 18
        ParentShowHint = False
        ShowHint = True
        Style = tbsCheck
        OnClick = btnOpenClick
      end
      object btnConfig: TToolButton
        Left = 139
        Top = 0
        Caption = 'Config'
        ImageIndex = 24
      end
      object ToolButton2: TToolButton
        Left = 162
        Top = 0
        Width = 8
        Caption = 'ToolButton2'
        ImageIndex = 20
        Style = tbsSeparator
      end
      object WriteConfirmCB: TNxCheckBox
        Left = 170
        Top = 0
        Width = 112
        Height = 22
        TabOrder = 3
        Text = 'DataEditCB'
        Caption = 'Use Write Confirm'
        Checked = True
        OnChange = WriteConfirmCBChange
      end
      object DataEditCB: TNxCheckBox
        Left = 282
        Top = 0
        Width = 81
        Height = 22
        TabOrder = 0
        Text = 'DataEditCB'
        Caption = 'Matrix Edit'
        OnChange = DataEditCBChange
      end
      object ToolButton6: TToolButton
        Left = 363
        Top = 0
        Width = 8
        Caption = 'ToolButton6'
        ImageIndex = 5
        Style = tbsSeparator
      end
      object iSwitchLed1: TiSwitchLed
        Left = 371
        Top = 0
        Width = 104
        Height = 22
        Caption = 'Get Online Data'
        CaptionFont.Charset = DEFAULT_CHARSET
        CaptionFont.Color = clWindowText
        CaptionFont.Height = -11
        CaptionFont.Name = 'Tahoma'
        CaptionFont.Style = []
        CaptionMargin = 2
        IndicatorAlignment = isaLeft
        BorderSize = 2
        BorderHighlightColor = clBtnHighlight
        BorderShadowColor = clBtnShadow
        OnChange = iSwitchLed1Change
        TabOrder = 1
        Caption_2 = 'Get Online Data'
      end
      object iSwitchLed2: TiSwitchLed
        Left = 475
        Top = 0
        Width = 104
        Height = 22
        Caption = 'Get Offline Data'
        CaptionFont.Charset = DEFAULT_CHARSET
        CaptionFont.Color = clWindowText
        CaptionFont.Height = -11
        CaptionFont.Name = 'Tahoma'
        CaptionFont.Style = []
        CaptionMargin = 2
        IndicatorAlignment = isaLeft
        BorderSize = 2
        BorderHighlightColor = clBtnHighlight
        BorderShadowColor = clBtnShadow
        OnChange = iSwitchLed2Change
        TabOrder = 2
        Caption_2 = 'Get Offline Data'
      end
      object ToolButton4: TToolButton
        Left = 579
        Top = 0
        Width = 8
        Caption = 'ToolButton4'
        ImageIndex = 6
        Style = tbsSeparator
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 27
    Width = 92
    Height = 416
    Align = alLeft
    TabOrder = 1
    DesignSize = (
      92
      416)
    object Label7: TLabel
      Left = 8
      Top = 24
      Width = 63
      Height = 13
      Caption = 'Actual Value:'
    end
    object BitBtn1: TBitBtn
      Left = 1
      Top = 319
      Width = 88
      Height = 33
      Anchors = [akLeft, akBottom]
      Caption = 'Apply to Controller'
      TabOrder = 0
      OnClick = BitBtn1Click
    end
    object ValuePanel: TPanel
      Left = 6
      Top = 43
      Width = 80
      Height = 25
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 1
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 443
    Width = 775
    Height = 31
    Panels = <>
  end
  object Panel4: TPanel
    Left = 92
    Top = 27
    Width = 683
    Height = 416
    Align = alClient
    TabOrder = 3
    object Panel5: TPanel
      Left = 1
      Top = 121
      Width = 681
      Height = 294
      Align = alClient
      TabOrder = 0
      object YAxisPanel: TPanel
        Left = 1
        Top = 1
        Width = 152
        Height = 292
        Align = alLeft
        TabOrder = 0
        Visible = False
        object Label4: TLabel
          Left = 81
          Top = 247
          Width = 49
          Height = 16
          Caption = 'X - Axis:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object Label6: TLabel
          Left = 39
          Top = 223
          Width = 48
          Height = 16
          Caption = 'Y - Axis:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object YGrid: TAdvStringGrid
          Left = 1
          Top = 1
          Width = 150
          Height = 216
          Cursor = crDefault
          Align = alTop
          Color = 12119529
          ColCount = 2
          Ctl3D = True
          DefaultRowHeight = 26
          DrawingStyle = gdsClassic
          FixedColor = clWindow
          FixedRows = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 0
          OnSelectCell = YGridSelectCell
          HoverRowCells = [hcNormal, hcSelected]
          UndoRedo = YGridUndoRedo
          OnEditCellDone = YGridEditCellDone
          ActiveCellFont.Charset = DEFAULT_CHARSET
          ActiveCellFont.Color = clWindowText
          ActiveCellFont.Height = -11
          ActiveCellFont.Name = 'Tahoma'
          ActiveCellFont.Style = [fsBold]
          ActiveCellColor = 15387318
          ColumnSize.Location = clIniFile
          ControlLook.FixedGradientFrom = clWhite
          ControlLook.FixedGradientTo = clBtnFace
          ControlLook.FixedGradientHoverFrom = 13619409
          ControlLook.FixedGradientHoverTo = 12502728
          ControlLook.FixedGradientHoverMirrorFrom = 12502728
          ControlLook.FixedGradientHoverMirrorTo = 11254975
          ControlLook.FixedGradientDownFrom = 8816520
          ControlLook.FixedGradientDownTo = 7568510
          ControlLook.FixedGradientDownMirrorFrom = 7568510
          ControlLook.FixedGradientDownMirrorTo = 6452086
          ControlLook.FixedGradientDownBorder = 14007466
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
          DefaultAlignment = taCenter
          DragScrollOptions.Active = True
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
          FixedRowHeight = 26
          FixedFont.Charset = DEFAULT_CHARSET
          FixedFont.Color = clWindowText
          FixedFont.Height = -13
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
          ScrollSynch = True
          SearchFooter.ColorTo = 14215660
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
          SortSettings.HeaderColorTo = 16579058
          SortSettings.HeaderMirrorColor = 16380385
          SortSettings.HeaderMirrorColorTo = 16182488
          SyncGrid.Grid = MatrixGrid
          SyncGrid.ScrollVertical = True
          SyncGrid.SelectionRow = True
          Version = '7.4.4.1'
          ExplicitWidth = 134
          RowHeights = (
            26
            26
            26
            26
            26
            26
            26
            26
            26
            26)
        end
      end
      object Panel6: TPanel
        Left = 153
        Top = 1
        Width = 373
        Height = 292
        Align = alClient
        TabOrder = 1
        object MatrixGrid: TAdvStringGrid
          Left = 1
          Top = 1
          Width = 371
          Height = 222
          Cursor = crDefault
          Align = alClient
          ColCount = 10
          Ctl3D = True
          DefaultRowHeight = 26
          DrawingStyle = gdsClassic
          FixedCols = 0
          RowCount = 1
          FixedRows = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          ScrollBars = ssNone
          TabOrder = 0
          OnSelectCell = MatrixGridSelectCell
          HoverRowCells = [hcNormal, hcSelected]
          UndoRedo = MatrixGridUndoRedo
          OnGetCellColor = MatrixGridGetCellColor
          OnEditCellDone = MatrixGridEditCellDone
          ActiveCellFont.Charset = DEFAULT_CHARSET
          ActiveCellFont.Color = clWindowText
          ActiveCellFont.Height = -11
          ActiveCellFont.Name = 'Tahoma'
          ActiveCellFont.Style = [fsBold]
          BackGround.Display = bdFixed
          BackGround.Cells = bcAll
          ColumnSize.Location = clIniFile
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
          DefaultAlignment = taCenter
          EnableHTML = False
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
          FixedRowHeight = 26
          FixedFont.Charset = DEFAULT_CHARSET
          FixedFont.Color = clWindowText
          FixedFont.Height = -13
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
          SyncGrid.Grid = XGrid
          SyncGrid.ScrollHorizontal = True
          SyncGrid.SelectionColumn = True
          Version = '7.4.4.1'
          ExplicitWidth = 365
          ExplicitHeight = 208
        end
        object XGrid: TAdvStringGrid
          Left = 1
          Top = 223
          Width = 371
          Height = 68
          Cursor = crDefault
          Align = alBottom
          Color = 12119529
          ColCount = 10
          Ctl3D = True
          DefaultRowHeight = 26
          DrawingStyle = gdsClassic
          FixedCols = 0
          RowCount = 2
          FixedRows = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          ScrollBars = ssHorizontal
          TabOrder = 1
          OnSelectCell = XGridSelectCell
          HoverRowCells = [hcNormal, hcSelected]
          UndoRedo = XGridUndoRedo
          OnEditCellDone = XGridEditCellDone
          ActiveCellFont.Charset = DEFAULT_CHARSET
          ActiveCellFont.Color = clWindowText
          ActiveCellFont.Height = -11
          ActiveCellFont.Name = 'Tahoma'
          ActiveCellFont.Style = [fsBold]
          ColumnSize.Location = clIniFile
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
          DefaultAlignment = taCenter
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
          FixedFooters = 1
          FixedRowHeight = 26
          FixedFont.Charset = DEFAULT_CHARSET
          FixedFont.Color = clWindowText
          FixedFont.Height = -13
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
          ScrollSynch = True
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
          SyncGrid.Grid = MatrixGrid
          SyncGrid.ScrollHorizontal = True
          SyncGrid.SelectionColumn = True
          Version = '7.4.4.1'
          ExplicitTop = 208
          ExplicitWidth = 399
        end
      end
      object ZAxisPanel: TPanel
        Left = 526
        Top = 1
        Width = 154
        Height = 292
        Align = alRight
        TabOrder = 2
        Visible = False
        object Label5: TLabel
          Left = 48
          Top = 223
          Width = 48
          Height = 16
          Caption = 'Z - Axis:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object ZGrid: TAdvStringGrid
          Left = 1
          Top = 1
          Width = 152
          Height = 216
          Cursor = crDefault
          Align = alTop
          Color = 12119529
          ColCount = 2
          Ctl3D = True
          DefaultRowHeight = 26
          DrawingStyle = gdsClassic
          FixedCols = 0
          FixedRows = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 0
          OnSelectCell = ZGridSelectCell
          HoverRowCells = [hcNormal, hcSelected]
          UndoRedo = ZGridUndoRedo
          OnEditCellDone = ZGridEditCellDone
          ActiveCellFont.Charset = DEFAULT_CHARSET
          ActiveCellFont.Color = clWindowText
          ActiveCellFont.Height = -11
          ActiveCellFont.Name = 'Tahoma'
          ActiveCellFont.Style = [fsBold]
          ColumnSize.Location = clIniFile
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
          DefaultAlignment = taCenter
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
          FixedRightCols = 1
          FixedRowHeight = 26
          FixedFont.Charset = DEFAULT_CHARSET
          FixedFont.Color = clWindowText
          FixedFont.Height = -13
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
          ScrollSynch = True
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
          SyncGrid.ScrollVertical = True
          SyncGrid.SelectionRow = True
          Version = '7.4.4.1'
          ExplicitWidth = 134
        end
      end
    end
    object MatrixInfoPanel: TAdvSmoothExpanderPanel
      Left = 1
      Top = 1
      Width = 681
      Height = 120
      Cursor = crDefault
      Caption.Text = 'Matrix Info.'
      Caption.HTMLFont.Charset = DEFAULT_CHARSET
      Caption.HTMLFont.Color = clWindowText
      Caption.HTMLFont.Height = -11
      Caption.HTMLFont.Name = 'Tahoma'
      Caption.HTMLFont.Style = []
      Caption.Font.Charset = DEFAULT_CHARSET
      Caption.Font.Color = clWindowText
      Caption.Font.Height = -12
      Caption.Font.Name = 'Tahoma'
      Caption.Font.Style = []
      Fill.Color = 16445929
      Fill.ColorTo = 15587527
      Fill.ColorMirror = 15587527
      Fill.ColorMirrorTo = 16773863
      Fill.GradientType = gtVertical
      Fill.GradientMirrorType = gtVertical
      Fill.BorderColor = 14922381
      Fill.Rounding = 10
      Fill.ShadowOffset = 10
      Fill.Glow = gmNone
      Version = '1.0.4.2'
      Align = alTop
      TabOrder = 1
      ExpanderColor = 16445929
      ExpanderDownColor = 15587527
      ExpanderHoverColor = 11196927
      OldHeight = 120.000000000000000000
      object XLabel: TLabel
        Left = 24
        Top = 29
        Width = 49
        Height = 16
        Caption = 'X - Axis:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object YLabel: TLabel
        Left = 25
        Top = 54
        Width = 48
        Height = 16
        Caption = 'Y - Axis:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object ZLabel: TLabel
        Left = 24
        Top = 78
        Width = 48
        Height = 16
        Caption = 'Z - Axis:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object XDescEdit: TAdvEdit
        Left = 79
        Top = 26
        Width = 282
        Height = 24
        EmptyText = '(None)'
        EmptyTextStyle = [fsItalic]
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
        Color = clWindow
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ImeName = 'Microsoft Office IME 2007'
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
        Text = ''
        Transparent = True
        Visible = True
        Version = '3.3.2.4'
      end
      object YDescEdit: TAdvEdit
        Left = 79
        Top = 51
        Width = 282
        Height = 24
        EmptyText = '(None)'
        EmptyTextStyle = [fsItalic]
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
        Color = clWindow
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ImeName = 'Microsoft Office IME 2007'
        ParentFont = False
        ReadOnly = True
        TabOrder = 1
        Text = ''
        Transparent = True
        Visible = True
        Version = '3.3.2.4'
      end
      object ZDescEdit: TAdvEdit
        Left = 79
        Top = 76
        Width = 282
        Height = 24
        EmptyText = '(None)'
        EmptyTextStyle = [fsItalic]
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
        Color = clWindow
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ImeName = 'Microsoft Office IME 2007'
        ParentFont = False
        ReadOnly = True
        TabOrder = 2
        Text = ''
        Transparent = True
        Visible = True
        Version = '3.3.2.4'
      end
      object XCurValueEdit: TAdvEdit
        Left = 367
        Top = 26
        Width = 100
        Height = 24
        EmptyText = '(None)'
        EmptyTextStyle = [fsItalic]
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
        Color = clWindow
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ImeName = 'Microsoft Office IME 2007'
        ParentFont = False
        ReadOnly = True
        TabOrder = 3
        Text = ''
        Transparent = True
        Visible = True
        Version = '3.3.2.4'
      end
      object YCurValueEdit: TAdvEdit
        Left = 367
        Top = 51
        Width = 100
        Height = 24
        EmptyText = '(None)'
        EmptyTextStyle = [fsItalic]
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
        Color = clWindow
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ImeName = 'Microsoft Office IME 2007'
        ParentFont = False
        ReadOnly = True
        TabOrder = 4
        Text = ''
        Transparent = True
        Visible = True
        Version = '3.3.2.4'
      end
      object ZCurValueEdit: TAdvEdit
        Left = 367
        Top = 76
        Width = 100
        Height = 24
        EmptyText = '(None)'
        EmptyTextStyle = [fsItalic]
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
        Color = clWindow
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ImeName = 'Microsoft Office IME 2007'
        ParentFont = False
        ReadOnly = True
        TabOrder = 5
        Text = ''
        Transparent = True
        Visible = True
        Version = '3.3.2.4'
      end
    end
  end
  object ImageList1: TImageList
    Left = 11
    Top = 119
    Bitmap = {
      494C010119002500140010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000007000000001002000000000000070
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      FF00808080000000000000000000800080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF00808080000000000000000000FF00FF000000000000000000000000000000
      0000000000008080800080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF00808080000000000000000000FF00FF000000000000000000000000000000
      0000808080008080800080808000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF00808080000000000000000000FF00FF000000000000000000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      00000000000080808000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000008080800080808000808080008080
      8000000000008080800000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000808000008080000080
      8000000000000000000000000000008080000080800000808000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFF0000FFFF000000000000000000000000000000000000000000008080
      8000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000808080000000000000000000000000000000
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
      0000808080008080800080808000000000000000000000000000000000000000
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
      00000000000000000000C0686000B0586000B0586000B0585000A05050009048
      50009048400080404000703840007038400000000000000000000000000B0000
      002C000000340000003300000033000000330000003300000033000000330000
      0033000000340000002900000009000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B0A0900060483000604830006048
      30006048300060483000C0687000D0888000C06050005048400080808000E0D8
      D000B0B8B00050404000A04840008040400000000000000000010000000B5D53
      53F5443D3DFF3F3A3AFF5B5151FF6A5D5DFF756767FF726565FF766A6AFF8174
      74FF7F7272FF605656F500000009000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B0A09000FFFFFF00B0A09000B0A0
      9000B0A09000B0A09000C0707000E0909000D08880006050400070606000B0B0
      A000D0D0C00060585000A0484000804040000000000000000000000000008274
      74FF4F4646FF766565FF7A6969FF685A5AFF6C5F5FFF716565FF766A6AFF8073
      73FF7F7272FF867979FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B0A09000FFFFFF00FFFFFF00FFF8
      FF00F0F0F000F0E8E000C0788000E098A000E090900060504000605040006050
      40006050400060504000B058500090485000000000000000000000000000AFAB
      ABFFAFABABFFAFABABFFB0ACACFFB3AFAFFFB4B0B0FFB3AFAFFFB0ACACFFAFAB
      ABFFAFABABFFAFABABFF00000000000000000000000000000000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000000008080800000000000000000000000
      000000000000000000000000000000000000B0A09000FFFFFF00FFFFFF00F0E8
      F000A0A0A00070687000D0808000F0A0A000E098A000E0909000D0888000D078
      8000C0707000C0686000B0605000A05050000000000000000000000000009A95
      95FF6D6A6AFFA19C9CFFAAA6A6FF9E9A9AFF999494FF9E9A9AFFAAA6A6FFA19C
      9CFF6D6A6AFF9A9595FF00000000000000000000000000000000000000000000
      0000000000008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B0A09000FFFFFF00F0F0F0009080
      7000A0803000B0582000D0889000F0A8B000D0787000D0606000C0585000B050
      4000B0402000B0483000C0686000A0505000000000000000000000000000A19C
      9CFFA49F9FFFA19C9CFF9D9898FF868282FF797575FF7D7979FF8E8A8AFFA09B
      9BFFA49F9FFFA19C9CFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C0A89000FFFFFF0090909000E098
      400090B8100020B01000D0909000F0B0B000E0707000FFFFFF00FFF8F000F0E8
      E000E0D8D000B0504000C0707000B0585000000000000000000000000000A9A4
      A4FFAEA9A9FFA8A3A3FF989494FF878383FF464343FF716E6EFF969191FFA8A3
      A3FFAEA9A9FFA9A4A4FF00000000000000000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C0A8A000FFFFFF0070686000F0D0
      B00060E8400080C01000E098A000FFB8C000F0888000FFFFFF00FFFFFF00FFF8
      F000F0E8E000C0585000A0606000B0586000000000000000000000000000B2AD
      ADFF969191FFA8A4A4FFB1ACACFF5B5858FF969191FF777272FFA8A3A3FFB0AB
      ABFF979494FFB2ADADFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C0B0A000FFFFFF0080808000D0E0
      D000A0E8A000F0B85000E0A0A000FFC0C000FF909000FFFFFF00FFFFFF00FFFF
      FF00FFF8F000D060600080404000B0586000000000000000000000000000BAB5
      B5FFBAB5B5FFB8B3B3FF6A6767FF9B9595FF938D8DFF938D8DFF797474FFB5B0
      B0FFBCB7B7FFBAB5B5FF00000000000000000000000000000000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D0B0A000FFFFFF00E0E0E0006080
      6000C0E0B000D0D88000E0A8A000E0A0A000E098A000D0909000D0889000D080
      8000C0788000C0707000C0687000C0686000000000000000000000000000C1BC
      BCFFC1BCBCFFC4BFBFFFC5C0C0FF6B6767FF908888FF908888FFBFBBBBFFC0BB
      BBFFC5C0C0FFC1BCBCFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D0B8A000FFFFFF00FFFFFF00D0D0
      D0007078700060805000C0C8C000F0F0F000B0A09000B0A09000604830000000
      000000000000000000000000000000000000000000000000000000000000C8C3
      C3FFCAC5C5FF2C2C2CFF464646FF4C4A4AFF8C8383FF8C8383FFC8C3C3FFC3BE
      BEFFCAC5C5FFC8C3C3FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D0B8B000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00B0A090006048300060483000604830000000
      000000000000000000000000000000000000000000000000000000000000CDC8
      C8FF928E8EFF3D3D3DFF404040FF4E4D4DFF8A8080FF8A8080FFB6B2B2FFC2BD
      BDFF928E8EFFCDC8C8FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D0C0B000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C0A89000D0C8C00060483000D0B0A0000000
      0000000000000000000000000000000000000000000000000000000000000000
      003B0000005F0000005F0000005F403D3DE0796E6EFF796E6EFF0000005F0000
      005F0000005F0000003B00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E0C0B000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C0A8A00060483000D0B0A000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000403E3ECEB0A4A4FFB0A4A4FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E0C0B000E0C0B000E0C0B000E0C0
      B000E0C0B000D0C0B000D0B8B000D0B0A000D0B0A00000000000000000000000
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
      00000000000000000000000000000000000000000000C0C0C000C0686000B058
      5000A0505000A0505000A0505000904850009048400090484000804040008038
      4000803840007038400070383000000000007088900060809000607880005070
      8000506070004058600040485000303840002030300020203000101820001010
      1000101020000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D0687000F0909000E080
      8000B048200040302000C0B8B000C0B8B000D0C0C000D0C8C00050505000A040
      3000A0403000A038300070384000000000007088900090A0B00070B0D0000090
      D0000090D0000090D0000090C0001088C0001080B0001080B0002078A0002070
      9000204860000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000060483000000000006048
      300000000000C0A8A000B0806000B0806000A0786000A0705000A06840009058
      40009050300060483000000000000000000000000000D0707000FF98A000F088
      8000E0808000705850004040300090787000F0E0E000F0E8E00090807000A040
      3000A0404000A040300080384000000000008088900080C0D00090A8B00080E0
      FF0060D0FF0050C8FF0050C8FF0040C0F00030B0F00030A8F00020A0E0001090
      D000206880002028300000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0A8A000FFF0F000D0C0B000D0C0B000D0C0B000D0B0A000C0A8
      9000C0A8900060483000000000000000000000000000D0787000FFA0A000F090
      9000F0888000705850000000000040403000F0D8D000F0E0D00080786000B048
      4000B0484000A040400080404000000000008090A00080D0F00090A8B00090C0
      D00070D8FF0060D0FF0060D0FF0050C8FF0050C0FF0040B8F00030B0F00030A8
      F0001088D0002048600000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000060483000000000000000
      000000000000C0B0A000FFF0F000FFF0F000FFF0F00080000000F0D8D000F0C8
      B000C0A8900060483000000000000000000000000000D0788000FFA8B000FFA0
      A000F0909000705850007058500070585000705850007060500080686000C058
      5000B0505000B048400080404000000000008090A00080D8F00080C8E00090A8
      B00080E0FF0070D0FF0060D8FF0060D0FF0060D0FF0050C8FF0040C0F00040B8
      F00030B0F0002068800010486000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D0B0A000FFF8F000FFF8F000FFF0F0008000000080000000F0D8
      D000C0A8900060483000000000000000000000000000E0808000FFB0B000FFB0
      B000FFA0A000F0909000F0888000E0808000E0788000D0707000D0687000C060
      6000C0585000B050500090484000000000008098A00090E0F00090E0FF0090A8
      B00090B8C00070D8FF0060D8FF0060D8FF0060D8FF0060D0FF0050D0FF0050C8
      FF0040B8F00030A0E00040607000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000060483000000000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000D0B8B00060483000000000000000000000000000E0889000FFB8C000FFB8
      B000D0606000C0605000C0585000C0504000B0503000B0483000A0402000A038
      1000C0606000C058500090484000000000008098A00090E0F000A0E8FF0080C8
      E00090A8B00080E0FF0080E0FF0080E0FF0080E0FF0080E0FF0080E0FF0080E0
      FF0070D8FF0070D8FF0050A8D000506070000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D0B0A000FFFFFF00FFFFFF00FFF8F0008000000080000000FFF0
      F000D0B8B00060483000000000000000000000000000E0909000FFC0C000D068
      6000FFFFFF00FFFFFF00FFF8F000F0F0F000F0E8E000F0D8D000E0D0C000E0C8
      C000A0381000C0606000904850000000000090A0A000A0E8F000A0E8FF00A0E8
      FF0090B0C00090B0C00090A8B00090A8B00080A0B00080A0B0008098A0008098
      A0008090A0008090A00080889000708890000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000060483000000000000000
      000000000000D0B8A000FFFFFF00FFFFFF00FFF8F00080000000FFF8F000FFF0
      F000D0B8B00060483000000000000000000000000000E098A000FFC0C000D070
      7000FFFFFF00FFFFFF00FFFFFF00FFF8F000F0F0F000F0E8E000F0D8D000E0D0
      C000A0402000D0686000A05050000000000090A0B000A0E8F000A0F0FF00A0E8
      FF00A0E8FF0080D8FF0060D8FF0060D8FF0060D8FF0060D8FF0060D8FF0060D8
      FF00708890000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D0B0A000FFFFFF00FFFFFF00FFF8F000FFF8F000FFF8F000FFF0
      F000FFE8E00060483000000000000000000000000000F0A0A000FFC0C000E078
      7000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF8F000F0F0F000F0E8E000F0D8
      D000B0483000D0707000A05050000000000090A0B000A0F0F000B0F0F000A0F0
      FF00A0E8FF00A0E8FF0070D8FF0090A0A0008098A0008098A0008090A0008090
      9000708890000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000060483000000000006048
      300000000000C0B0A000C0B0A000C0B0A000C0B0A000C0B0A000C0B0A000C0A8
      A000C0A89000C0A8A000000000000000000000000000F0A8A000FFC0C000E080
      8000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF8F000F0F0F000F0E8
      E000B0503000E0788000A05050000000000090A8B000A0D0E000B0F0F000B0F0
      F000A0F0FF00A0E8FF0090A0B000000000000000000000000000000000000000
      0000000000009068500090685000906850000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F0B0B000FFC0C000F088
      9000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF8F000F0F0
      F000C050400060303000B0585000000000000000000090A8B00090A8B00090A8
      B00090A8B00090A8B00090A8B000000000000000000000000000000000000000
      0000000000000000000090685000906850000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F0B0B000FFC0C000FF90
      9000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF8
      F000C0585000B0586000B0586000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000090786000000000000000
      000000000000A090800000000000907860000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F0B8B000F0B8B000F0B0
      B000F0B0B000F0A8B000F0A0A000E098A000E0909000E0909000E0889000E080
      8000D0788000D0787000D0707000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A0908000A088
      8000B09880000000000000000000000000000000000000000000000000000000
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
      00000000000000000000000000000000000000000000C0A8A000B0806000B080
      6000A0786000A0705000A0684000905840009050300060483000000000006048
      3000000000006048300000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D0785000C0704000B0684000B0604000A0583000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000A05830000000000000000000000000000000
      00000000000000000000000000000000000000000000C0A8A000FFF0F000D0C0
      B000D0C0B000D0C0B000D0B0A000C0A89000C0A8900060483000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D0785000F0703000F0703000F0703000A0583000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000D0704000D05820009048200000000000000000000000
      00000000000000000000000000000000000000000000C0B0A000FFF0F000FFF0
      F000FFF0F00080000000F0D8D000F0C8B000C0A8900060483000000000000000
      0000000000006048300000000000000000000000000000000000000000000000
      0000000000009080700090706000806850006048300060483000000000000000
      0000000000000000000000000000000000000000000000000000E0885000D080
      5000D0785000D0785000FF804000F0703000F0703000A0583000A05030009050
      3000904820000000000000000000000000000000000000000000000000000000
      000000000000D0784000FF986000F0783000D058200090482000000000000000
      00000000000000000000000000000000000000000000D0B0A000FFF8F000FFF8
      F0008000000080000000FFE8E000F0D8D000C0A8900060483000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000090807000E0906000E0703000E068300060483000000000000000
      000000000000000000000000000000000000000000000000000000000000E088
      6000FFC0A000FF987000FF885000FF804000F0703000F0682000F0682000D068
      3000000000000000000000000000000000000000000000000000000000000000
      0000E0805000FFB89000FFA87000FF986000F0783000D0582000904820000000
      00000000000000000000000000000000000000000000D0B8A000FFF8F0008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000000000006048300000000000000000000000000000000000000000000000
      00000000000090807000F0A07000F0906000E070400060483000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000E0886000FFC0A000FFB08000FFA07000F0885000F0703000D06030000000
      000000000000000000000000000000000000000000000000000000000000E088
      6000FFC0A000FFC0A000FFB89000FFA87000FF986000E0885000D07040009048
      20000000000000000000000000000000000000000000D0B0A000FFFFFF00FFFF
      FF008000000080000000FFF8F000FFF0F000D0B8B00060483000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000090807000F0B09000F0A08000E080500060483000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000E0886000FFC0A000FFB09000FFA06000D0683000000000000000
      0000000000000000000000000000000000000000000000000000E0987000E098
      7000E0987000E0906000FFC0A000FFB89000FFA87000D0582000D0602000E068
      3000E068300000000000000000000000000000000000D0B8A000FFFFFF00FFFF
      FF00FFF8F00080000000FFF8F000FFF0F000D0B8B00060483000000000000000
      0000000000006048300000000000000000000000000000000000000000000000
      00000000000090888000F0B8A000F0B09000E090600060483000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000E0885000FFC0A000E070400000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F0A88000FFC0A000FFC0A000FFB89000E0703000000000000000
      00000000000000000000000000000000000000000000D0B0A000FFFFFF00FFFF
      FF00FFF8F000FFF8F000FFF8F000FFF0F000FFE8E00060483000000000000000
      00000000000000000000000000000000000000000000B0A09000907060007058
      400060483000A0888000FFC8B000F0C0A000E0A0800060483000907060008068
      5000705840006048300000000000000000000000000000000000000000000000
      0000000000000000000000000000E08850000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F0B09000E0A07000E0906000E0805000E0704000000000000000
      00000000000000000000000000000000000000000000C0B0A000C0B0A000C0B0
      A000C0B0A000C0B0A000C0B0A000C0A8A000C0A89000C0A8A000000000006048
      30000000000060483000000000000000000000000000B0A09000FFFFFF00C0C0
      C000C0C0C000A0909000FFD0C000FFC8B000F0A8900060483000FFFFFF00C0C0
      C000C0C0C0006048300000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0A8A000FFFFFF00FFFF
      FF00C0C0C000A0989000FFD8C000FFD0C000F0B8A00060483000FFFFFF00FFFF
      FF00C0C0C0006048300000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0B8B000FFFFFF00FFFF
      FF00FFFFFF00B0A0A000FFD8D000FFD8C000FFD0C00060483000FFFFFF00FFFF
      FF00FFFFFF006048300000000000000000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006048300060483000604830006048
      3000604830006048300000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000070605000F0906000E0805000E070400060483000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFF8F000FFF8F000FFF0E000FFF0
      E000FFE8E0008060500000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000080706000F0A89000E0906000E080500060483000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000807060009078600090706000000000000000000000000000000000000000
      0000000000000000000000000000000000006048300060483000604830006048
      3000604830007058400080685000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFF8FF00FFF8F000FFF0
      F000FFF0E0009078600000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000090887000F0C8B000F0A88000E090600060504000000000000000
      0000000000000000000000000000000000000000000000000000A0807000A088
      7000D0B0A000D0B0A000C0B0A000B09880006048300000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFF8F000FFF8F000FFF0
      E000FFF0E000FFE8E00090786000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFF8
      F000FFF8F000A090800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A0989000FFD8C000F0C0A000F0A8800070504000000000000000
      00000000000000000000000000000000000000000000C0988000E0C0B000D0C0
      B000E0D0C000F0E0E000FFF8F000B0988000A090800060483000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFF8FF00FFF8
      F000FFF0F000FFF0E000A0908000000000000000000000000000000000000000
      000000000000000000000000000000000000D0C0B000C0B8B000C0B0A000C0A8
      A000B0A09000A090800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A0989000FFE0D000FFD0C000F0C0A00080605000000000000000
      00000000000000000000000000000000000000000000D0B0A000F0F0E000F0E8
      E000F0F0F000FFF8FF00FFF8F000FFFFFF00B0988000A0908000604830000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFF8F000FFF8F000B0A09000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000807060006048
      3000604830006048300060483000604830000000000000000000000000000000
      000000000000B0989000A0989000A08880009078700080706000000000000000
      00000000000000000000000000000000000000000000D0A89000FFF8FF00FFFF
      FF00FFFFFF00F0F0F000F0E8E000F0E0E000FFFFFF00B0988000A09080006048
      3000000000000000000000000000000000006048300060483000604830006048
      3000604830006048300060483000604830006048300070584000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000090807000F0C0
      A000F0B09000F0987000F0885000E07840000000000000000000000000000000
      0000000000000000000000000000100810000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D0A89000FFFF
      FF00FFFFFF00FFF8FF00F0F0F000F0E8E000F0E0E000FFFFFF00B0988000A090
      800060483000000000000000000000000000F0C0A000F0B89000F0A88000F0A0
      7000F0987000F0906000F0885000F0885000F088500080605000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A0908000FFD8
      C000FFD0B000F0C0A000F0A88000F09060000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D0A8
      9000FFFFFF00FFFFFF00FFF8FF00F0F0F000F0E8E000F0E0E000FFFFFF00B098
      8000A0908000604830000000000000000000FFE0D000FFD8C000FFC8B000F0C0
      A000F0B8A000F0B09000F0A88000F0A07000F088500080706000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B0989000FFE8
      E000FFE0D000FFD8C000F0C8B000F0B8A0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D0A89000FFFFFF00FFFFFF00FFF8FF00F0F0F000F0E8E000F0E0E000FFFF
      FF00B0988000806050000000000000000000FFF0F000FFE8E000FFE0D000FFD8
      C000FFD0C000F0C8B000F0C0A000F0B09000F0A88000A0908000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B0989000B098
      9000A09080009088800080706000807060000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D0A89000FFFFFF00FFFFFF00FFF8FF00F0F0F000F0E8E000F0E0
      E000FFFFFF00A08070000000000000000000B0A09000B0A09000B0A09000B098
      9000A0989000A0989000A0908000A0908000A0908000A0908000000000000000
      0000000000000000000000000000000000006048300060483000604830006048
      3000604830006048300000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000D0A89000FFFFFF00FFFFFF00FFF8FF00FFF0F000FFF8
      FF00E0D0C000B09080000000000000000000FFFFFF00FFF8F000FFF0F000FFF0
      E000FFE8E000FFE8E000A0807000000000000000000000000000000000000000
      000000000000000000000000000000000000FFF8F000FFF8F000FFF0E000FFF0
      E000FFE8E0008068500000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B0A09000907060007058
      40006048300060483000000000000000000000000000B0A09000907060008068
      5000705840006048300000000000000000000000000000000000000000000000
      0000000000000000000000000000D0A89000FFFFFF00FFFFFF00FFF8FF00E0D0
      D000B0887000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFF8
      F000FFF0F000FFF0E000B0989000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFF8FF00FFF8F000FFF0
      F000FFF0E0009078700000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B0A09000FFF8F000FFF0
      E000FFE0D00060483000000000000000000000000000C0B0A000FFF8F000FFF0
      E000FFE0D0006048300000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D0A89000C0A09000B0907000B090
      800000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFF8F000B0908000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFF8
      F000FFF8F000A090800000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0A8A000FFFFFF00FFF8
      FF00FFF0E00060483000000000000000000000000000D0C0C000FFFFFF00FFF8
      FF00FFF0E0006048300000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C0B8B000C0B0A000C0B0A000C0B0
      A000C0A8A000C0A8A000B0A09000000000000000000000000000000000000000
      000000000000000000000000000000000000D0B8B000C0B0A000C0A8A000C0A8
      A000B0A09000B090800000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0B8B000FFFFFF00FFFF
      FF00FFF8FF0060483000000000000000000000000000D0C8C000FFFFFF00FFFF
      FF00FFF8FF006048300000000000000000000000000000000000000000000000
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
      00000000000000000000000000000000000000000000A0887000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000604830000000000000000000A0887000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000604830000000000000000000A0887000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000060483000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B0A09000A0887000806050006048
      3000604830006048300060483000604830006048300060483000604830006048
      300060483000604830006048300060483000B0A09000A0887000806050006048
      3000604830006048300060483000604830006048300060483000604830006048
      300060483000604830006048300060483000B0A09000A0887000806050006048
      3000604830006048300060483000604830006048300060483000604830006048
      3000604830006048300060483000604830000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B0A09000F0D8D000F0D8
      D000E0D0C000E0C8C000E0C0B000E0C0B000E0B8A000D0B0A000D0A8A000D0A8
      9000D0A08000D0988000604830000000000000000000B0A09000FFF8F000F0D8
      D000E0D8D000E0D0C000E0C8C000E0C8C000E0C0B000E0B8B000E0B8A000D0B0
      A000D0A89000D0A89000604830000000000000000000B0A09000FFF8F000F0D8
      D000E0D8D000E0D0C000E0C8C000E0C8C000E0C0B000E0B8B000E0B8A000D0B0
      A000D0A89000D0A8900060483000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B0A09000FFF8F000FFF0
      F000F0F0F000F0E8E000F0E0E000F0E0D000F0D8D000F0D0C000E0C8C000E0C8
      C000E0C8B000D0A09000604830000000000000000000B0A09000FFFFFF00FFF8
      F000FFF0F000F0F0E000F0E8E000F0E0E000F0E0D000F0D8D000F0D0C000F0D0
      C000E0C8C000D0B0A000604830000000000000000000B0A09000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D0B0A00060483000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B0A09000FFFFFF00FFF8
      F000FFF8F000F0F0F000F0E8E000F0E0E000F0E0D000F0D8D000F0D0C000E0D0
      C000E0C8C000D0A89000604830000000000000000000B0A09000FFFFFF00FFF8
      FF00FFF8F000FFF0F000F0F0F000F0E8E000F0E0E000F0E0D000F0D8D000F0D8
      C000F0D0C000E0B8A000604830000000000000000000B0A09000FFFFFF00FFF8
      FF00FFF8F000FFF0F000F0F0F000F0E8E000F0E0E000F0E0D000F0D8D000F0D8
      C000F0D0C000E0B8A00060483000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B0A09000FFFFFF00FFFF
      FF00FFF8FF00FFF8F000FFF0F000F0E8E000F0E8E000F0E0D000F0D8D000F0D0
      C000E0D0C000D0B0A000604830000000000000000000B0A09000FFFFFF00FFFF
      FF00FFF8FF00FFF8F000FFF0F000F0F0F000F0E8E000F0E8E000F0E0D000F0D8
      D000F0D8D000E0C0B000604830000000000000000000B0A09000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000E0C0B00060483000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0A89000FFFFFF00FFFF
      FF00FFFFFF00FFF8FF00FFF8F000FFF0F000F0E8E000F0E8E000F0E0D000F0D8
      D000F0D8D000E0C0B000604830000000000000000000C0A89000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000E0C8C000604830000000000000000000C0A89000FFFFFF00FFFF
      FF00FFFFFF00FFF8FF00FFF8F000FFF0F000F0F0F000F0E8E000F0E8E000F0E0
      D000F0D8D000E0C8C00060483000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0A8A000FFFFFF00FFFF
      FF00FFFFFF00FFF8FF00FFF8F000FFF0F000F0E8E000F0E8E000F0E8E000F0E0
      E000F0D8D000E0C8C000604830000000000000000000C0A8A000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFF8FF00FFF8F000FFF8F000FFF0F000F0E8E000F0E8
      E000F0E0D000E0D0C000604830000000000000000000C0A8A000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFF8FF00FFF8F000FFF8F000FFF0F000F0E8E000F0E8
      E000F0E0D000E0D0C00060483000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0A8A000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF8F000FFF0F000F0F0F000F0E8
      E000F0E0E000E0D0C000604830000000000000000000C0A8A000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F0D8D000604830000000000000000000C0A8A000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF8F000FFF8F000FFF0F000F0E8
      E000F0E8E000F0D8D00060483000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0B0A000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F0D8D000604830000000000000000000C0B0A000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF8FF00FFF8F000FFF0
      F000F0F0E000F0E0D000604830000000000000000000C0B0A000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF8FF00FFF8F000FFF0
      F000F0F0E000F0E0D00060483000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D0B0A000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF8FF00FFF8
      F000FFF0F000F0E0E000604830000000000000000000D0B0A000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF8FF00FFF8
      F000FFF0F000F0E8E000604830000000000000000000D0B0A000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF8FF00FFF8
      F000FFF0F000F0E8E00060483000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D0B8A000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F0E0E000705850000000000000000000D0B8A000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF8
      FF00FFF8F000F0E8E000705850000000000000000000D0B8A000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF8
      FF00FFF8F000F0E8E00070585000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D0B0A000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00907860000000000000000000D0B0A000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00907860000000000000000000D0B0A000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0090786000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D0B0A000D0B0A000D0B8A000D0B8
      A000D0B0A000C0B0A000C0B0A000C0B0A000C0B0A000C0A8A000C0A8A000C0A8
      9000C0A89000B0A09000A090800090786000D0B0A000D0B0A000D0B8A000D0B8
      A000D0B0A000C0B0A000C0B0A000C0B0A000C0B0A000C0A8A000C0A8A000C0A8
      9000C0A89000B0A09000A090800090786000D0B0A000D0B0A000D0B8A000D0B8
      A000D0B0A000C0B0A000C0B0A000C0B0A000C0B0A000C0A8A000C0A8A000C0A8
      9000C0A89000B0A09000A0908000907860000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D0B0A000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000B0A090000000000000000000D0B0A000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000B0A090000000000000000000D0B0A000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000B0A09000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000AD4A0000C65A0000BD735200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BD735200C65A0000AD4A
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000B552
      1000CE630000C65A0000B55A3100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B55A3100C65A0000CE63
      0000B55210000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B55A2100CE63
      0000C6630000B55A310000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B55A3100C663
      0000CE630000B55A210000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6846300C6630000CE63
      0000B55A21000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000B55A
      2100CE630000C6630000C6846300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B54A0000CE630000AD4A
      00000000000000000000C6846300BD5A0000BD5A0000BD5A0000BD5A0000BD5A
      0000BD5A0000BD5A0000AD4A00000000000000000000AD4A0000BD5A0000BD5A
      0000BD5A0000BD5A0000BD5A0000BD5A0000BD5A0000C6846300000000000000
      0000AD4A0000CE630000B54A0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6846300C6630000C66300000000
      00000000000000000000BD6B4200C6630000CE630000CE630000CE630000CE63
      0000CE6B0000D6730000B55200000000000000000000B5520000D6730000CE6B
      0000CE630000CE630000CE630000CE630000C6630000BD6B4200000000000000
      0000CE9C8400C6630000C6630000C68463000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B5521000CE630000AD4A00000000
      0000000000000000000000000000CE9C8400CE9C8400CE9C8400A5421000CE63
      0000D6730000DE7B0000BD5A00000000000000000000BD5A0000DE7B0000D673
      0000CE630000A5421000CE9C8400CE9C8400CE9C840000000000000000000000
      000000000000AD4A0000CE630000B55210000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B54A0000CE630000C67342000000
      00000000000000000000000000000000000000000000C6846300CE630000DE73
      0000CE630000E7840000C66300000000000000000000C6630000E7840000CE63
      0000DE730000CE630000C6846300000000000000000000000000000000000000
      000000000000C6734200CE630000B54A00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B54A0000CE630000C67342000000
      000000000000000000000000000000000000BD7B5200CE6B0000DE7B0000B552
      0000B5521000F7940000CE6300000000000000000000CE630000F7940000B552
      1000B5520000DE7B0000CE6B0000BD7B52000000000000000000000000000000
      000000000000C6734200CE630000B54A00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B5521000CE630000B54A00000000
      0000000000000000000000000000BD633100CE6B0000E7840000B55200000000
      0000CE844200FF9C0800CE6B08000000000000000000CE6B0800FF9C0800CE84
      420000000000B5520000E7840000CE6B0000BD63310000000000000000000000
      000000000000B54A0000CE630000B55210000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6846300C6630000C6630000B552
      1000C68C7300C67B5200BD520000E77B0000E7840000C6631000000000000000
      0000CE844A00FFAD3100CE7321000000000000000000CE732100FFAD3100CE84
      4A000000000000000000C6631000E7840000E77B0000BD520000C67B5200C68C
      7300B5521000C6630000C6630000C68463000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000AD4A1000C6630000CE6B
      0000D6730000DE7B0000E7840000E77B0000B55A210000000000000000000000
      0000C67B5200FFBD6300CE7B39000000000000000000CE7B3900FFBD6300C67B
      5200000000000000000000000000B55A2100E77B0000E7840000DE7B0000D673
      0000CE6B0000C6630000AD4A1000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000BD6B4200BD5A
      0000CE6B0000CE6B0000C6631000CE9C84000000000000000000000000000000
      000000000000C6845A00CE947B000000000000000000CE947B00C6845A000000
      000000000000000000000000000000000000CE9C8400C6631000CE6B0000CE6B
      0000BD5A0000BD6B420000000000000000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000700000000100010000000000800300000000000000000000
      000000000000000000000000FFFFFF00FFFF000000000000E4FF000000000000
      C4FF000000000000C4C1000000000000C4E0000000000000C4FC000000000000
      E1F60000000000008A00000000000000061E00000000000071CE000000000000
      820E000000000000EFF6000000000000EBE0000000000000F9E0000000000000
      F3FF000000000000FFFF000000000000FFFFFFFFFFFF0000FFFFFFFFFC000000
      FFFFE00F00000000FFFFFFFF00000000E07FF83F00000000F8FFF11F00000000
      F8FFF39F00000000FC7FF39F00000000FC7FF39F00000000FE3FF39F00000000
      FE3FF39F00000000FF1FF39F001F0000FE0FE10F001F0000FFFFFFFF001F0000
      FFFFFFFF003F0000FFFFFFFF007F0000FFFFFFFFFFFFFFFFFFFF80010007FFFF
      FFFF80010007FFFFA80380010003FFFFF80380010003E01FB80380010001F18F
      F80380010001F18FA00380010000F18FF80380010000F01FB80380010007F18F
      F80380010007F18FA803800101F8F18FFFFF800181FCE01FFFFF8001FFBAFFFF
      FFFF8001FFC7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF
      FC7FFFFFFFFFFFFFFEFFFFFFFFFF802BFEFFF83FFEFF803FFEFFF83FFC7F803B
      F83FC007F83F803FF83FE00FF01F800BF83FF01FE00F803FF83FF83FC007803B
      F83FFC7FF83F803F8003FEFFF83F802B8003FFFFFFFFFFFF8003FFFFFFFFFFFF
      8003FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF03FFF83FFFFFFFFF
      03FFF83FF00101FF03FFF83FC07F01FF03FFF83F803F01FF03FFF83F801F01FF
      FFC0F83F800F003FFEC0FEFFC007003BFC00FEFFE0030001FEC0FC7FF003003B
      FFC0FEFFF803003F03FFFFFFFC0301FF03FF8383FE0701FF03FF8383FF0F01FF
      03FF8383FFFF01FF03FF8383FFFFFFFFFFFFFFFFFFFFFFFFFFFFBFFDBFFDBFFD
      FFFF000000000000F003800180018001FFFF8001800180010003800180018001
      FFFF800180018001F003800180018001FFFF8001800180010003800180018001
      FFFF800180018001F003800180018001FFFF8001800180010003800180018001
      FFFF000000000000FFFFBFFDBFFDBFFDFFFFF1FFFF8FFFFFFFFFE1FFFF87FFFF
      FFFFC3FFFFC3FFFF003F87FFFFE1C00FFFFF8C018031FFFF00031C0180300003
      FFFF1E018078FFFF003F1F8181F8C00FFFFF1F0180F8FFFF00031E1188780003
      FFFF00318C00FFFF003F80718E01C00FFFFFC0F99F03FFFF0003FFFFFFFF0003
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object OpenDialog1: TOpenDialog
    Left = 48
    Top = 120
  end
  object MatrixGridUndoRedo: TAdvGridUndoRedo
    MaxLevel = 0
    Left = 264
    Top = 192
  end
  object YGridUndoRedo: TAdvGridUndoRedo
    MaxLevel = 0
    Left = 312
    Top = 192
  end
  object ZGridUndoRedo: TAdvGridUndoRedo
    MaxLevel = 0
    Left = 400
    Top = 192
  end
  object XGridUndoRedo: TAdvGridUndoRedo
    MaxLevel = 0
    Left = 352
    Top = 192
  end
end
