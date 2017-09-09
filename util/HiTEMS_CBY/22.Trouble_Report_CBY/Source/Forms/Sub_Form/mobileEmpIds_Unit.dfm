object mobileEmpIds_Frm: TmobileEmpIds_Frm
  Left = 0
  Top = 0
  Caption = #45812#45817#51088' '#51648#51221
  ClientHeight = 327
  ClientWidth = 396
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = #47569#51008' '#44256#46357
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label9: TLabel
    Left = 24
    Top = 8
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
  object Label1: TLabel
    Left = 24
    Top = 48
    Width = 34
    Height = 17
    Caption = #49548#49549' :'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #47569#51008' '#44256#46357
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 224
    Top = 48
    Width = 34
    Height = 17
    Caption = #54016#51109' :'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #47569#51008' '#44256#46357
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 11
    Top = 90
    Width = 47
    Height = 17
    Caption = #44396#49457#50896' :'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #47569#51008' '#44256#46357
    Font.Style = [fsBold]
    ParentFont = False
  end
  object dept: TEdit
    Left = 64
    Top = 8
    Width = 120
    Height = 21
    ImeName = 'Microsoft Office IME 2007'
    TabOrder = 0
  end
  object team: TEdit
    Left = 64
    Top = 48
    Width = 120
    Height = 21
    ImeName = 'Microsoft Office IME 2007'
    TabOrder = 1
  end
  object manager: TEdit
    Left = 264
    Top = 48
    Width = 120
    Height = 21
    ImeName = 'Microsoft Office IME 2007'
    TabOrder = 2
  end
  object TeamTable: TAdvStringGrid
    Left = 64
    Top = 115
    Width = 320
    Height = 166
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
    TabOrder = 3
    OnGetAlignment = TeamTableGetAlignment
    OnCanEditCell = TeamTableCanEditCell
    ActiveCellFont.Charset = DEFAULT_CHARSET
    ActiveCellFont.Color = clWindowText
    ActiveCellFont.Height = -11
    ActiveCellFont.Name = 'Tahoma'
    ActiveCellFont.Style = [fsBold]
    ColumnHeaders.Strings = (
      ''
      #49457#47749
      #51649#44553
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
      124
      62
      57
      52)
  end
  object member: TEdit
    Left = 64
    Top = 89
    Width = 120
    Height = 21
    ImeName = 'Microsoft Office IME 2007'
    TabOrder = 4
  end
  object Button2: TButton
    Left = 231
    Top = 294
    Width = 75
    Height = 25
    Caption = #54869#51064
    ImageIndex = 12
    ImageMargins.Left = 5
    Images = Main_Frm.Imglist16x16
    TabOrder = 5
    OnClick = Button2Click
  end
  object Button1: TButton
    Left = 309
    Top = 294
    Width = 75
    Height = 25
    Caption = #45803#44592
    ImageIndex = 11
    ImageMargins.Left = 5
    Images = Main_Frm.Imglist16x16
    TabOrder = 6
    OnClick = Button1Click
  end
  object Button3: TButton
    AlignWithMargins = True
    Left = 187
    Top = 88
    Width = 25
    Height = 23
    Margins.Top = 0
    ImageIndex = 8
    Images = Main_Frm.Imglist16x16
    TabOrder = 7
    OnClick = Button3Click
  end
end
