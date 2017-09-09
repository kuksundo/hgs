object TeamChange_Frm: TTeamChange_Frm
  Left = 0
  Top = 0
  Caption = #45812#45817#54016' '#48320#44221
  ClientHeight = 306
  ClientWidth = 357
  Color = clBtnFace
  Constraints.MaxHeight = 340
  Constraints.MaxWidth = 365
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = #47569#51008' '#44256#46357
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label9: TLabel
    Left = 18
    Top = 14
    Width = 91
    Height = 17
    Caption = #54788#51116' '#45812#45817#54016#51109' :'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #47569#51008' '#44256#46357
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Bevel1: TBevel
    Left = 18
    Top = 64
    Width = 343
    Height = 2
  end
  object Label1: TLabel
    Left = 18
    Top = 78
    Width = 83
    Height = 17
    Caption = #48320#44221#45236#50857' '#51077#47141
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #47569#51008' '#44256#46357
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 34
    Top = 102
    Width = 34
    Height = 17
    Caption = #48512#49436' :'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #47569#51008' '#44256#46357
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Chief: TEdit
    Left = 52
    Top = 37
    Width = 100
    Height = 21
    ImeName = 'Microsoft Office IME 2007'
    ReadOnly = True
    TabOrder = 0
  end
  object Dept: TNxComboBox
    Left = 74
    Top = 101
    Width = 165
    Height = 21
    TabOrder = 1
    OnButtonDown = DeptButtonDown
    HideFocus = False
    OnSelect = DeptSelect
    AutoCompleteDelay = 0
  end
  object TeamTable: TAdvStringGrid
    Left = 74
    Top = 128
    Width = 271
    Height = 137
    Cursor = crDefault
    DrawingStyle = gdsClassic
    RowCount = 6
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 2
    OnGetAlignment = TeamTableGetAlignment
    OnCanEditCell = TeamTableCanEditCell
    ActiveCellFont.Charset = DEFAULT_CHARSET
    ActiveCellFont.Color = clWindowText
    ActiveCellFont.Height = -11
    ActiveCellFont.Name = 'Tahoma'
    ActiveCellFont.Style = [fsBold]
    ColumnHeaders.Strings = (
      ''
      #54016
      #54016#51109
      #49440#53469)
    ColumnSize.Stretch = True
    ColumnSize.StretchColumn = 1
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
    FixedColWidth = 20
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
      20
      99
      62
      33
      52)
  end
  object Button1: TButton
    Left = 270
    Top = 271
    Width = 75
    Height = 25
    Caption = #45803#44592
    ImageIndex = 11
    ImageMargins.Left = 5
    Images = Main_Frm.Imglist16x16
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 193
    Top = 271
    Width = 75
    Height = 25
    Caption = #48320#44221
    ImageIndex = 14
    ImageMargins.Left = 5
    Images = Main_Frm.Imglist16x16
    TabOrder = 4
    OnClick = Button2Click
  end
end
