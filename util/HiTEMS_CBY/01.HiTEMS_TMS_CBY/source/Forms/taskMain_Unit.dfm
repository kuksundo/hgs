object taskMain_Frm: TtaskMain_Frm
  Left = 251
  Top = 107
  Caption = 'HiTEMS_'#50629#47924#44288#47532#49884#49828#53596
  ClientHeight = 675
  ClientWidth = 1016
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIForm
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  WindowMenu = Window1
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object NxSplitter1: TNxSplitter
    Left = 217
    Top = 28
    Width = 6
    Height = 628
    ExplicitLeft = 250
  end
  object AdvDockPanel1: TAdvDockPanel
    Left = 0
    Top = 0
    Width = 1016
    Height = 28
    MinimumSize = 3
    LockHeight = False
    Persistence.Location = plRegistry
    Persistence.Enabled = False
    ToolBarStyler = AdvToolBarOfficeStyler1
    UseRunTimeHeight = True
    Version = '6.0.2.8'
    object AdvToolBar1: TAdvToolBar
      Left = 3
      Top = 1
      Width = 1010
      Height = 26
      AllowFloating = True
      AutoDockOnClose = True
      AutoMDIButtons = True
      AutoOptionMenu = True
      Locked = True
      Caption = 'rsApp'
      CaptionFont.Charset = DEFAULT_CHARSET
      CaptionFont.Color = clWindowText
      CaptionFont.Height = -11
      CaptionFont.Name = 'MS Sans Serif'
      CaptionFont.Style = []
      CompactImageIndex = -1
      ShowClose = False
      FullSize = True
      TextAutoOptionMenu = 'Add or Remove Buttons'
      TextOptionMenu = 'Options'
      ToolBarStyler = AdvToolBarOfficeStyler1
      Menu = AdvMainMenu1
      ParentOptionPicture = True
      ToolBarIndex = -1
    end
  end
  object AdvOfficeStatusBar1: TAdvOfficeStatusBar
    Left = 0
    Top = 656
    Width = 1016
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
        Width = 170
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
        Width = 189
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
  end
  object AdvNavBar1: TAdvNavBar
    Left = 0
    Top = 28
    Width = 217
    Height = 628
    Align = alLeft
    Color = clWhite
    ActiveColor = 9758459
    ActiveColorTo = 1414638
    ActiveTabIndex = 2
    AllowCollaps = True
    BorderColor = 9731196
    CaptionColor = 12428453
    CaptionColorTo = 9794677
    CaptionFont.Charset = DEFAULT_CHARSET
    CaptionFont.Color = clWhite
    CaptionFont.Height = -15
    CaptionFont.Name = 'Tahoma'
    CaptionFont.Style = [fsBold]
    CollapsedCaption = 'Collapsed'
    DefaultGradientDirection = gdVertical
    DefaultTabColor = 15524577
    DefaultTabColorTo = 11769496
    DownTabColor = 557032
    DownTabColorTo = 8182519
    DownTabMirrorColor = clNone
    DownTabMirrorColorTo = clNone
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = #47569#51008' '#44256#46357
    Font.Style = []
    HoverTabColor = 14483455
    HoverTabColorTo = 6013175
    HoverTabMirrorColor = clNone
    HoverTabMirrorColorTo = clNone
    Images = ImageList32x32
    SectionColor = 16249843
    SectionColorTo = 15128792
    SectionFont.Charset = DEFAULT_CHARSET
    SectionFont.Color = clWindowText
    SectionFont.Height = -11
    SectionFont.Name = 'Tahoma'
    SectionFont.Style = []
    ShowHint = True
    SplitterPosition = 3
    SplitterColor = 12560296
    SplitterColorTo = 9731196
    Style = esOffice2003Silver
    Version = '2.0.2.6'
    object AdvNavBarPanel1: TAdvNavBarPanel
      Left = 1
      Top = 27
      Width = 215
      Height = 450
      Caption = '['#50629#47924#44288#47532']'
      CaptionStyle = []
      Color = clWhite
      ImageIndex = 0
      PanelIndex = 0
      Sections = <>
      object CurvyPanel1: TCurvyPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 209
        Height = 444
        Align = alClient
        Color = cl3DDkShadow
        TabOrder = 0
        object Label2: TLabel
          AlignWithMargins = True
          Left = 5
          Top = 5
          Width = 201
          Height = 20
          Margins.Left = 5
          Margins.Top = 5
          Align = alTop
          Font.Charset = ANSI_CHARSET
          Font.Color = clWhite
          Font.Height = -15
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
          ExplicitWidth = 5
        end
        object CurvyPanel2: TCurvyPanel
          AlignWithMargins = True
          Left = 30
          Top = 28
          Width = 176
          Height = 309
          Margins.Left = 30
          Margins.Top = 0
          Align = alTop
          BorderColor = clBlack
          Color = 5066061
          TabOrder = 0
          object AdvGlowButton2: TAdvGlowButton
            AlignWithMargins = True
            Left = 10
            Top = 147
            Width = 156
            Height = 38
            Margins.Left = 10
            Margins.Top = 10
            Margins.Right = 10
            Margins.Bottom = 0
            Align = alTop
            Caption = #50629#47924' '#51068#51221'  '#44288#47532
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = #47569#51008' '#44256#46357
            Font.Style = [fsBold]
            ImageIndex = 7
            Images = ImageList32x32
            FocusType = ftHot
            NotesFont.Charset = DEFAULT_CHARSET
            NotesFont.Color = clWindowText
            NotesFont.Height = -11
            NotesFont.Name = 'Tahoma'
            NotesFont.Style = []
            ParentFont = False
            TabOrder = 0
            OnClick = AdvGlowButton2Click
            Appearance.ColorChecked = 16111818
            Appearance.ColorCheckedTo = 16367008
            Appearance.ColorDisabled = 15921906
            Appearance.ColorDisabledTo = 15921906
            Appearance.ColorDown = 16111818
            Appearance.ColorDownTo = 16367008
            Appearance.ColorHot = 16117985
            Appearance.ColorHotTo = 16372402
            Appearance.ColorMirrorHot = 16107693
            Appearance.ColorMirrorHotTo = 16775412
            Appearance.ColorMirrorDown = 16102556
            Appearance.ColorMirrorDownTo = 16768988
            Appearance.ColorMirrorChecked = 16102556
            Appearance.ColorMirrorCheckedTo = 16768988
            Appearance.ColorMirrorDisabled = 11974326
            Appearance.ColorMirrorDisabledTo = 15921906
            Layout = blGlyphLeftAdjusted
          end
          object AdvGlowButton3: TAdvGlowButton
            AlignWithMargins = True
            Left = 10
            Top = 188
            Width = 156
            Height = 38
            Margins.Left = 10
            Margins.Right = 10
            Margins.Bottom = 0
            Align = alTop
            Caption = #51068#51068' '#50629#47924'  '#48372#44256
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = #47569#51008' '#44256#46357
            Font.Style = [fsBold]
            ImageIndex = 8
            Images = ImageList32x32
            FocusType = ftHot
            NotesFont.Charset = DEFAULT_CHARSET
            NotesFont.Color = clWindowText
            NotesFont.Height = -11
            NotesFont.Name = 'Tahoma'
            NotesFont.Style = []
            ParentFont = False
            TabOrder = 1
            OnClick = AdvGlowButton3Click
            Appearance.ColorChecked = 16111818
            Appearance.ColorCheckedTo = 16367008
            Appearance.ColorDisabled = 15921906
            Appearance.ColorDisabledTo = 15921906
            Appearance.ColorDown = 16111818
            Appearance.ColorDownTo = 16367008
            Appearance.ColorHot = 16117985
            Appearance.ColorHotTo = 16372402
            Appearance.ColorMirrorHot = 16107693
            Appearance.ColorMirrorHotTo = 16775412
            Appearance.ColorMirrorDown = 16102556
            Appearance.ColorMirrorDownTo = 16768988
            Appearance.ColorMirrorChecked = 16102556
            Appearance.ColorMirrorCheckedTo = 16768988
            Appearance.ColorMirrorDisabled = 11974326
            Appearance.ColorMirrorDisabledTo = 15921906
            Layout = blGlyphLeftAdjusted
          end
          object AdvGlowButton4: TAdvGlowButton
            AlignWithMargins = True
            Left = 10
            Top = 58
            Width = 156
            Height = 38
            Margins.Left = 10
            Margins.Top = 10
            Margins.Right = 10
            Margins.Bottom = 0
            Align = alTop
            Caption = #51068#51068#44032#46041#50984#54788#54889
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = #47569#51008' '#44256#46357
            Font.Style = [fsBold]
            ImageIndex = 9
            Images = ImageList32x32
            FocusType = ftHot
            NotesFont.Charset = DEFAULT_CHARSET
            NotesFont.Color = clWindowText
            NotesFont.Height = -11
            NotesFont.Name = 'Tahoma'
            NotesFont.Style = []
            ParentFont = False
            TabOrder = 2
            OnClick = AdvGlowButton4Click
            Appearance.ColorChecked = 16111818
            Appearance.ColorCheckedTo = 16367008
            Appearance.ColorDisabled = 15921906
            Appearance.ColorDisabledTo = 15921906
            Appearance.ColorDown = 16111818
            Appearance.ColorDownTo = 16367008
            Appearance.ColorHot = 16117985
            Appearance.ColorHotTo = 16372402
            Appearance.ColorMirrorHot = 16107693
            Appearance.ColorMirrorHotTo = 16775412
            Appearance.ColorMirrorDown = 16102556
            Appearance.ColorMirrorDownTo = 16768988
            Appearance.ColorMirrorChecked = 16102556
            Appearance.ColorMirrorCheckedTo = 16768988
            Appearance.ColorMirrorDisabled = 11974326
            Appearance.ColorMirrorDisabledTo = 15921906
            Layout = blGlyphLeftAdjusted
          end
          object AdvGlowButton7: TAdvGlowButton
            AlignWithMargins = True
            Left = 10
            Top = 10
            Width = 156
            Height = 38
            Margins.Left = 10
            Margins.Top = 10
            Margins.Right = 10
            Margins.Bottom = 0
            Align = alTop
            Caption = #50629#47924' '#54788#54889' '#50676#46988
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = #47569#51008' '#44256#46357
            Font.Style = [fsBold]
            ImageIndex = 16
            Images = ImageList32x32
            FocusType = ftHot
            NotesFont.Charset = DEFAULT_CHARSET
            NotesFont.Color = clWindowText
            NotesFont.Height = -11
            NotesFont.Name = 'Tahoma'
            NotesFont.Style = []
            ParentFont = False
            TabOrder = 3
            OnClick = AdvGlowButton7Click
            Appearance.ColorChecked = 16111818
            Appearance.ColorCheckedTo = 16367008
            Appearance.ColorDisabled = 15921906
            Appearance.ColorDisabledTo = 15921906
            Appearance.ColorDown = 16111818
            Appearance.ColorDownTo = 16367008
            Appearance.ColorHot = 16117985
            Appearance.ColorHotTo = 16372402
            Appearance.ColorMirrorHot = 16107693
            Appearance.ColorMirrorHotTo = 16775412
            Appearance.ColorMirrorDown = 16102556
            Appearance.ColorMirrorDownTo = 16768988
            Appearance.ColorMirrorChecked = 16102556
            Appearance.ColorMirrorCheckedTo = 16768988
            Appearance.ColorMirrorDisabled = 11974326
            Appearance.ColorMirrorDisabledTo = 15921906
            Layout = blGlyphLeftAdjusted
          end
          object AdvGlowButton5: TAdvGlowButton
            AlignWithMargins = True
            Left = 10
            Top = 229
            Width = 156
            Height = 38
            Margins.Left = 10
            Margins.Right = 10
            Margins.Bottom = 0
            Align = alTop
            Caption = #51068#51068' '#51089#50629' '#44288#47532
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = #47569#51008' '#44256#46357
            Font.Style = [fsBold]
            ImageIndex = 22
            Images = ImageList32x32
            FocusType = ftHot
            NotesFont.Charset = DEFAULT_CHARSET
            NotesFont.Color = clWindowText
            NotesFont.Height = -11
            NotesFont.Name = 'Tahoma'
            NotesFont.Style = []
            ParentFont = False
            TabOrder = 4
            OnClick = AdvGlowButton5Click
            Appearance.ColorChecked = 16111818
            Appearance.ColorCheckedTo = 16367008
            Appearance.ColorDisabled = 15921906
            Appearance.ColorDisabledTo = 15921906
            Appearance.ColorDown = 16111818
            Appearance.ColorDownTo = 16367008
            Appearance.ColorHot = 16117985
            Appearance.ColorHotTo = 16372402
            Appearance.ColorMirrorHot = 16107693
            Appearance.ColorMirrorHotTo = 16775412
            Appearance.ColorMirrorDown = 16102556
            Appearance.ColorMirrorDownTo = 16768988
            Appearance.ColorMirrorChecked = 16102556
            Appearance.ColorMirrorCheckedTo = 16768988
            Appearance.ColorMirrorDisabled = 11974326
            Appearance.ColorMirrorDisabledTo = 15921906
            Layout = blGlyphLeftAdjusted
          end
          object btn_overTime: TAdvGlowButton
            AlignWithMargins = True
            Left = 10
            Top = 99
            Width = 156
            Height = 38
            Margins.Left = 10
            Margins.Right = 10
            Margins.Bottom = 0
            Align = alTop
            Caption = #50672#51109' '#44540#47924' '#54788#54889
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = #47569#51008' '#44256#46357
            Font.Style = [fsBold]
            ImageIndex = 15
            Images = ImageList32x32
            FocusType = ftHot
            NotesFont.Charset = DEFAULT_CHARSET
            NotesFont.Color = clWindowText
            NotesFont.Height = -11
            NotesFont.Name = 'Tahoma'
            NotesFont.Style = []
            ParentFont = False
            TabOrder = 5
            OnClick = btn_overTimeClick
            Appearance.ColorChecked = 16111818
            Appearance.ColorCheckedTo = 16367008
            Appearance.ColorDisabled = 15921906
            Appearance.ColorDisabledTo = 15921906
            Appearance.ColorDown = 16111818
            Appearance.ColorDownTo = 16367008
            Appearance.ColorHot = 16117985
            Appearance.ColorHotTo = 16372402
            Appearance.ColorMirrorHot = 16107693
            Appearance.ColorMirrorHotTo = 16775412
            Appearance.ColorMirrorDown = 16102556
            Appearance.ColorMirrorDownTo = 16768988
            Appearance.ColorMirrorChecked = 16102556
            Appearance.ColorMirrorCheckedTo = 16768988
            Appearance.ColorMirrorDisabled = 11974326
            Appearance.ColorMirrorDisabledTo = 15921906
            Layout = blGlyphLeftAdjusted
          end
        end
      end
    end
    object AdvNavBarPanel3: TAdvNavBarPanel
      Left = 1
      Top = 27
      Width = 215
      Height = 450
      Caption = '['#49884#54744#44288#47532']'
      CaptionStyle = []
      Color = clWhite
      ImageIndex = 1
      PanelIndex = 1
      Sections = <>
      object CurvyPanel5: TCurvyPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 209
        Height = 444
        Align = alClient
        Color = cl3DDkShadow
        TabOrder = 0
        object Label3: TLabel
          AlignWithMargins = True
          Left = 5
          Top = 5
          Width = 201
          Height = 20
          Margins.Left = 5
          Margins.Top = 5
          Align = alTop
          Font.Charset = ANSI_CHARSET
          Font.Color = clWhite
          Font.Height = -15
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
          ExplicitWidth = 5
        end
        object CurvyPanel6: TCurvyPanel
          AlignWithMargins = True
          Left = 30
          Top = 28
          Width = 176
          Height = 285
          Margins.Left = 30
          Margins.Top = 0
          Align = alTop
          BorderColor = clBlack
          Color = 5066061
          TabOrder = 0
          object btn_testStatus: TAdvGlowButton
            AlignWithMargins = True
            Left = 10
            Top = 10
            Width = 156
            Height = 38
            Margins.Left = 10
            Margins.Top = 10
            Margins.Right = 10
            Margins.Bottom = 0
            Align = alTop
            Caption = #49884#54744' '#54788#54889' '#44288#47532
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = #47569#51008' '#44256#46357
            Font.Style = [fsBold]
            ImageIndex = 3
            Images = ImageList32x32
            FocusType = ftHot
            NotesFont.Charset = DEFAULT_CHARSET
            NotesFont.Color = clWindowText
            NotesFont.Height = -11
            NotesFont.Name = 'Tahoma'
            NotesFont.Style = []
            ParentFont = False
            TabOrder = 0
            OnClick = btn_testStatusClick
            Appearance.ColorChecked = 16111818
            Appearance.ColorCheckedTo = 16367008
            Appearance.ColorDisabled = 15921906
            Appearance.ColorDisabledTo = 15921906
            Appearance.ColorDown = 16111818
            Appearance.ColorDownTo = 16367008
            Appearance.ColorHot = 16117985
            Appearance.ColorHotTo = 16372402
            Appearance.ColorMirrorHot = 16107693
            Appearance.ColorMirrorHotTo = 16775412
            Appearance.ColorMirrorDown = 16102556
            Appearance.ColorMirrorDownTo = 16768988
            Appearance.ColorMirrorChecked = 16102556
            Appearance.ColorMirrorCheckedTo = 16768988
            Appearance.ColorMirrorDisabled = 11974326
            Appearance.ColorMirrorDisabledTo = 15921906
            Layout = blGlyphLeftAdjusted
          end
          object btn_testResult: TAdvGlowButton
            AlignWithMargins = True
            Left = 10
            Top = 58
            Width = 156
            Height = 38
            Margins.Left = 10
            Margins.Top = 10
            Margins.Right = 10
            Margins.Bottom = 0
            Align = alTop
            Caption = #49884#54744' '#44208#44284' '#50676#46988
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = #47569#51008' '#44256#46357
            Font.Style = [fsBold]
            ImageIndex = 24
            Images = ImageList32x32
            FocusType = ftHot
            NotesFont.Charset = DEFAULT_CHARSET
            NotesFont.Color = clWindowText
            NotesFont.Height = -11
            NotesFont.Name = 'Tahoma'
            NotesFont.Style = []
            ParentFont = False
            TabOrder = 1
            OnClick = btn_testResultClick
            Appearance.ColorChecked = 16111818
            Appearance.ColorCheckedTo = 16367008
            Appearance.ColorDisabled = 15921906
            Appearance.ColorDisabledTo = 15921906
            Appearance.ColorDown = 16111818
            Appearance.ColorDownTo = 16367008
            Appearance.ColorHot = 16117985
            Appearance.ColorHotTo = 16372402
            Appearance.ColorMirrorHot = 16107693
            Appearance.ColorMirrorHotTo = 16775412
            Appearance.ColorMirrorDown = 16102556
            Appearance.ColorMirrorDownTo = 16768988
            Appearance.ColorMirrorChecked = 16102556
            Appearance.ColorMirrorCheckedTo = 16768988
            Appearance.ColorMirrorDisabled = 11974326
            Appearance.ColorMirrorDisabledTo = 15921906
            Layout = blGlyphLeftAdjusted
          end
        end
      end
    end
    object AdvNavBarPanel2: TAdvNavBarPanel
      Left = 1
      Top = 27
      Width = 215
      Height = 450
      Caption = '['#50629#47924#47784#45768#53552#47553']'
      CaptionStyle = []
      Color = clWhite
      ImageIndex = 2
      PanelIndex = 2
      Sections = <>
      object CurvyPanel3: TCurvyPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 209
        Height = 444
        Align = alClient
        Color = cl3DDkShadow
        TabOrder = 0
        object Label1: TLabel
          AlignWithMargins = True
          Left = 5
          Top = 5
          Width = 201
          Height = 20
          Margins.Left = 5
          Margins.Top = 5
          Align = alTop
          Font.Charset = ANSI_CHARSET
          Font.Color = clWhite
          Font.Height = -15
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
          ExplicitWidth = 5
        end
        object CurvyPanel4: TCurvyPanel
          AlignWithMargins = True
          Left = 30
          Top = 28
          Width = 176
          Height = 285
          Margins.Left = 30
          Margins.Top = 0
          Align = alTop
          BorderColor = clBlack
          Color = 5066061
          TabOrder = 0
          object AdvGlowButton6: TAdvGlowButton
            AlignWithMargins = True
            Left = 10
            Top = 10
            Width = 156
            Height = 38
            Margins.Left = 10
            Margins.Top = 10
            Margins.Right = 10
            Margins.Bottom = 0
            Align = alTop
            Caption = #51648#45212#50629#47924#45236#50857' '#51312#54924
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = #47569#51008' '#44256#46357
            Font.Style = [fsBold]
            ImageIndex = 21
            Images = ImageList32x32
            FocusType = ftHot
            NotesFont.Charset = DEFAULT_CHARSET
            NotesFont.Color = clWindowText
            NotesFont.Height = -11
            NotesFont.Name = 'Tahoma'
            NotesFont.Style = []
            ParentFont = False
            TabOrder = 0
            OnClick = AdvGlowButton6Click
            Appearance.ColorChecked = 16111818
            Appearance.ColorCheckedTo = 16367008
            Appearance.ColorDisabled = 15921906
            Appearance.ColorDisabledTo = 15921906
            Appearance.ColorDown = 16111818
            Appearance.ColorDownTo = 16367008
            Appearance.ColorHot = 16117985
            Appearance.ColorHotTo = 16372402
            Appearance.ColorMirrorHot = 16107693
            Appearance.ColorMirrorHotTo = 16775412
            Appearance.ColorMirrorDown = 16102556
            Appearance.ColorMirrorDownTo = 16768988
            Appearance.ColorMirrorChecked = 16102556
            Appearance.ColorMirrorCheckedTo = 16768988
            Appearance.ColorMirrorDisabled = 11974326
            Appearance.ColorMirrorDisabledTo = 15921906
            Layout = blGlyphLeftAdjusted
          end
          object AdvGlowButton1: TAdvGlowButton
            AlignWithMargins = True
            Left = 10
            Top = 106
            Width = 156
            Height = 38
            Margins.Left = 10
            Margins.Top = 10
            Margins.Right = 10
            Margins.Bottom = 0
            Align = alTop
            Caption = #51452#44036' '#44277#51221' '#54924#51032
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = #47569#51008' '#44256#46357
            Font.Style = [fsBold]
            ImageIndex = 6
            Images = ImageList32x32
            FocusType = ftHot
            NotesFont.Charset = DEFAULT_CHARSET
            NotesFont.Color = clWindowText
            NotesFont.Height = -11
            NotesFont.Name = 'Tahoma'
            NotesFont.Style = []
            ParentFont = False
            TabOrder = 1
            OnClick = AdvGlowButton1Click
            Appearance.ColorChecked = 16111818
            Appearance.ColorCheckedTo = 16367008
            Appearance.ColorDisabled = 15921906
            Appearance.ColorDisabledTo = 15921906
            Appearance.ColorDown = 16111818
            Appearance.ColorDownTo = 16367008
            Appearance.ColorHot = 16117985
            Appearance.ColorHotTo = 16372402
            Appearance.ColorMirrorHot = 16107693
            Appearance.ColorMirrorHotTo = 16775412
            Appearance.ColorMirrorDown = 16102556
            Appearance.ColorMirrorDownTo = 16768988
            Appearance.ColorMirrorChecked = 16102556
            Appearance.ColorMirrorCheckedTo = 16768988
            Appearance.ColorMirrorDisabled = 11974326
            Appearance.ColorMirrorDisabledTo = 15921906
            Layout = blGlyphLeftAdjusted
            ExplicitTop = 58
          end
          object AdvGlowButton8: TAdvGlowButton
            AlignWithMargins = True
            Left = 10
            Top = 58
            Width = 156
            Height = 38
            Margins.Left = 10
            Margins.Top = 10
            Margins.Right = 10
            Margins.Bottom = 0
            Align = alTop
            Caption = #50629#47924#49892#51201#53685#44228' '#51312#54924
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = #47569#51008' '#44256#46357
            Font.Style = [fsBold]
            ImageIndex = 6
            Images = ImageList32x32
            FocusType = ftHot
            NotesFont.Charset = DEFAULT_CHARSET
            NotesFont.Color = clWindowText
            NotesFont.Height = -11
            NotesFont.Name = 'Tahoma'
            NotesFont.Style = []
            ParentFont = False
            TabOrder = 2
            OnClick = AdvGlowButton8Click
            Appearance.ColorChecked = 16111818
            Appearance.ColorCheckedTo = 16367008
            Appearance.ColorDisabled = 15921906
            Appearance.ColorDisabledTo = 15921906
            Appearance.ColorDown = 16111818
            Appearance.ColorDownTo = 16367008
            Appearance.ColorHot = 16117985
            Appearance.ColorHotTo = 16372402
            Appearance.ColorMirrorHot = 16107693
            Appearance.ColorMirrorHotTo = 16775412
            Appearance.ColorMirrorDown = 16102556
            Appearance.ColorMirrorDownTo = 16768988
            Appearance.ColorMirrorChecked = 16102556
            Appearance.ColorMirrorCheckedTo = 16768988
            Appearance.ColorMirrorDisabled = 11974326
            Appearance.ColorMirrorDisabledTo = 15921906
            Layout = blGlyphLeftAdjusted
            ExplicitLeft = 18
            ExplicitTop = 66
          end
        end
      end
    end
  end
  object AdvMainMenu1: TAdvMainMenu
    AutoHotkeys = maManual
    AutoLineReduction = maManual
    MenuStyler = AdvMenuStyler1
    Version = '2.5.5.1'
    Left = 588
    Top = 112
    object Tasks1: TMenuItem
      Caption = '&Tasks'
      object N3: TMenuItem
        Caption = #50629#47924#44288#47532#54856
        OnClick = N3Click
      end
      object AddChild: TMenuItem
        Caption = '&Close'
        OnClick = AddChildClick
      end
    end
    object Application1: TMenuItem
      Caption = 'Application'
      object Photorum1: TMenuItem
        Caption = #54252#53664#47492'(Photorum)'
        OnClick = Photorum1Click
      end
    end
    object Configuration1: TMenuItem
      Caption = 'Configuration'
      object N2: TMenuItem
        Caption = #53076#46300#44288#47532
        OnClick = N2Click
      end
    end
    object Forms1: TMenuItem
      Caption = 'Forms'
      object LDS2: TMenuItem
        Caption = 'LDS'
        OnClick = LDS2Click
      end
    end
    object fuction1: TMenuItem
      Caption = 'Function'
      object SMS1: TMenuItem
        Caption = 'SMS'#48372#45236#44592
        OnClick = SMS1Click
      end
      object LDS1: TMenuItem
        Caption = 'LDS'
      end
    end
    object Window1: TMenuItem
      Caption = '&Window'
      object Cascade1: TMenuItem
        Caption = '&Cascade'
      end
      object N1: TMenuItem
        Caption = '-'
      end
    end
  end
  object AdvToolBarOfficeStyler1: TAdvToolBarOfficeStyler
    AppColor.AppButtonColor = 13005312
    AppColor.AppButtonHoverColor = 16755772
    AppColor.TextColor = clWhite
    AppColor.HoverColor = 16246477
    AppColor.HoverTextColor = clBlack
    AppColor.HoverBorderColor = 15187578
    AppColor.SelectedColor = 15187578
    AppColor.SelectedTextColor = clBlack
    AppColor.SelectedBorderColor = 15187578
    Style = bsOffice2007Luna
    AdvMenuStyler = AdvMenuOfficeStyler1
    BorderColor = 14668485
    BorderColorHot = 14731181
    ButtonAppearance.Color = clBtnFace
    ButtonAppearance.ColorTo = 14986888
    ButtonAppearance.ColorChecked = 9229823
    ButtonAppearance.ColorCheckedTo = 5812223
    ButtonAppearance.ColorDown = 14857624
    ButtonAppearance.ColorDownTo = 9556991
    ButtonAppearance.ColorHot = 13432063
    ButtonAppearance.ColorHotTo = 9556223
    ButtonAppearance.BorderDownColor = clBlack
    ButtonAppearance.BorderHotColor = clBlack
    ButtonAppearance.BorderCheckedColor = clNavy
    ButtonAppearance.CaptionFont.Charset = DEFAULT_CHARSET
    ButtonAppearance.CaptionFont.Color = clWindowText
    ButtonAppearance.CaptionFont.Height = -11
    ButtonAppearance.CaptionFont.Name = 'MS Sans Serif'
    ButtonAppearance.CaptionFont.Style = []
    CaptionAppearance.CaptionColor = 15915714
    CaptionAppearance.CaptionColorTo = 15784385
    CaptionAppearance.CaptionTextColor = 11168318
    CaptionAppearance.CaptionBorderColor = clBlack
    CaptionAppearance.CaptionColorHot = 16769224
    CaptionAppearance.CaptionColorHotTo = 16772566
    CaptionAppearance.CaptionTextColorHot = 11168318
    CaptionFont.Charset = DEFAULT_CHARSET
    CaptionFont.Color = clWindowText
    CaptionFont.Height = -11
    CaptionFont.Name = 'MS Sans Serif'
    CaptionFont.Style = []
    ContainerAppearance.LineColor = clBtnShadow
    ContainerAppearance.Line3D = True
    Color.Color = 15587527
    Color.ColorTo = 16181721
    Color.Direction = gdVertical
    Color.Mirror.Color = 15984090
    Color.Mirror.ColorTo = 15785680
    Color.Mirror.ColorMirror = 15587784
    Color.Mirror.ColorMirrorTo = 16510428
    ColorHot.Color = 16773606
    ColorHot.ColorTo = 16444126
    ColorHot.Direction = gdVertical
    ColorHot.Mirror.Color = 16642021
    ColorHot.Mirror.ColorTo = 16576743
    ColorHot.Mirror.ColorMirror = 16509403
    ColorHot.Mirror.ColorMirrorTo = 16510428
    CompactGlowButtonAppearance.BorderColor = 14727579
    CompactGlowButtonAppearance.BorderColorHot = 15193781
    CompactGlowButtonAppearance.BorderColorDown = 12034958
    CompactGlowButtonAppearance.BorderColorChecked = 12034958
    CompactGlowButtonAppearance.Color = 15653832
    CompactGlowButtonAppearance.ColorTo = 16178633
    CompactGlowButtonAppearance.ColorChecked = 14599853
    CompactGlowButtonAppearance.ColorCheckedTo = 13544844
    CompactGlowButtonAppearance.ColorDisabled = 15921906
    CompactGlowButtonAppearance.ColorDisabledTo = 15921906
    CompactGlowButtonAppearance.ColorDown = 14599853
    CompactGlowButtonAppearance.ColorDownTo = 13544844
    CompactGlowButtonAppearance.ColorHot = 16250863
    CompactGlowButtonAppearance.ColorHotTo = 16246742
    CompactGlowButtonAppearance.ColorMirror = 15586496
    CompactGlowButtonAppearance.ColorMirrorTo = 16245200
    CompactGlowButtonAppearance.ColorMirrorHot = 16247491
    CompactGlowButtonAppearance.ColorMirrorHotTo = 16246742
    CompactGlowButtonAppearance.ColorMirrorDown = 16766645
    CompactGlowButtonAppearance.ColorMirrorDownTo = 13014131
    CompactGlowButtonAppearance.ColorMirrorChecked = 16766645
    CompactGlowButtonAppearance.ColorMirrorCheckedTo = 13014131
    CompactGlowButtonAppearance.ColorMirrorDisabled = 11974326
    CompactGlowButtonAppearance.ColorMirrorDisabledTo = 15921906
    CompactGlowButtonAppearance.GradientHot = ggVertical
    CompactGlowButtonAppearance.GradientMirrorHot = ggVertical
    CompactGlowButtonAppearance.GradientDown = ggVertical
    CompactGlowButtonAppearance.GradientMirrorDown = ggVertical
    CompactGlowButtonAppearance.GradientChecked = ggVertical
    DockColor.Color = 15587527
    DockColor.ColorTo = 16445929
    DockColor.Direction = gdHorizontal
    DockColor.Steps = 128
    DragGripStyle = dsNone
    FloatingWindowBorderColor = 14922381
    FloatingWindowBorderWidth = 1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    GlowButtonAppearance.BorderColor = 14727579
    GlowButtonAppearance.BorderColorHot = 10079963
    GlowButtonAppearance.BorderColorDown = 4548219
    GlowButtonAppearance.BorderColorChecked = 4548219
    GlowButtonAppearance.Color = 15653832
    GlowButtonAppearance.ColorTo = 16178633
    GlowButtonAppearance.ColorChecked = 11918331
    GlowButtonAppearance.ColorCheckedTo = 7915518
    GlowButtonAppearance.ColorDisabled = 15921906
    GlowButtonAppearance.ColorDisabledTo = 15921906
    GlowButtonAppearance.ColorDown = 7778289
    GlowButtonAppearance.ColorDownTo = 4296947
    GlowButtonAppearance.ColorHot = 15465983
    GlowButtonAppearance.ColorHotTo = 11332863
    GlowButtonAppearance.ColorMirror = 15586496
    GlowButtonAppearance.ColorMirrorTo = 16245200
    GlowButtonAppearance.ColorMirrorHot = 5888767
    GlowButtonAppearance.ColorMirrorHotTo = 10807807
    GlowButtonAppearance.ColorMirrorDown = 946929
    GlowButtonAppearance.ColorMirrorDownTo = 5021693
    GlowButtonAppearance.ColorMirrorChecked = 10480637
    GlowButtonAppearance.ColorMirrorCheckedTo = 5682430
    GlowButtonAppearance.ColorMirrorDisabled = 11974326
    GlowButtonAppearance.ColorMirrorDisabledTo = 15921906
    GlowButtonAppearance.GradientHot = ggVertical
    GlowButtonAppearance.GradientMirrorHot = ggVertical
    GlowButtonAppearance.GradientDown = ggVertical
    GlowButtonAppearance.GradientMirrorDown = ggVertical
    GlowButtonAppearance.GradientChecked = ggVertical
    GroupAppearance.Background = clInfoBk
    GroupAppearance.BorderColor = 12763842
    GroupAppearance.Color = 15851212
    GroupAppearance.ColorTo = 14213857
    GroupAppearance.ColorMirror = 14213857
    GroupAppearance.ColorMirrorTo = 10871273
    GroupAppearance.Font.Charset = DEFAULT_CHARSET
    GroupAppearance.Font.Color = clWindowText
    GroupAppearance.Font.Height = -11
    GroupAppearance.Font.Name = 'Tahoma'
    GroupAppearance.Font.Style = []
    GroupAppearance.Gradient = ggVertical
    GroupAppearance.GradientMirror = ggVertical
    GroupAppearance.TextColor = 9126421
    GroupAppearance.CaptionAppearance.CaptionColor = 15915714
    GroupAppearance.CaptionAppearance.CaptionColorTo = 15784385
    GroupAppearance.CaptionAppearance.CaptionTextColor = 11168318
    GroupAppearance.CaptionAppearance.CaptionColorHot = 16769224
    GroupAppearance.CaptionAppearance.CaptionColorHotTo = 16772566
    GroupAppearance.CaptionAppearance.CaptionTextColorHot = 11168318
    GroupAppearance.PageAppearance.BorderColor = 12763842
    GroupAppearance.PageAppearance.Color = 14086910
    GroupAppearance.PageAppearance.ColorTo = 16382457
    GroupAppearance.PageAppearance.ColorMirror = 16382457
    GroupAppearance.PageAppearance.ColorMirrorTo = 16382457
    GroupAppearance.PageAppearance.Gradient = ggVertical
    GroupAppearance.PageAppearance.GradientMirror = ggVertical
    GroupAppearance.PageAppearance.ShadowColor = 12888726
    GroupAppearance.PageAppearance.HighLightColor = 16644558
    GroupAppearance.TabAppearance.BorderColor = 10534860
    GroupAppearance.TabAppearance.BorderColorHot = 10534860
    GroupAppearance.TabAppearance.BorderColorSelected = 10534860
    GroupAppearance.TabAppearance.BorderColorSelectedHot = 10534860
    GroupAppearance.TabAppearance.BorderColorDisabled = clNone
    GroupAppearance.TabAppearance.BorderColorDown = clNone
    GroupAppearance.TabAppearance.Color = clBtnFace
    GroupAppearance.TabAppearance.ColorTo = clWhite
    GroupAppearance.TabAppearance.ColorSelected = 10412027
    GroupAppearance.TabAppearance.ColorSelectedTo = 12249340
    GroupAppearance.TabAppearance.ColorDisabled = clNone
    GroupAppearance.TabAppearance.ColorDisabledTo = clNone
    GroupAppearance.TabAppearance.ColorHot = 14542308
    GroupAppearance.TabAppearance.ColorHotTo = 16768709
    GroupAppearance.TabAppearance.ColorMirror = clWhite
    GroupAppearance.TabAppearance.ColorMirrorTo = clWhite
    GroupAppearance.TabAppearance.ColorMirrorHot = 14016477
    GroupAppearance.TabAppearance.ColorMirrorHotTo = 10736609
    GroupAppearance.TabAppearance.ColorMirrorSelected = 12249340
    GroupAppearance.TabAppearance.ColorMirrorSelectedTo = 13955581
    GroupAppearance.TabAppearance.ColorMirrorDisabled = clNone
    GroupAppearance.TabAppearance.ColorMirrorDisabledTo = clNone
    GroupAppearance.TabAppearance.Font.Charset = DEFAULT_CHARSET
    GroupAppearance.TabAppearance.Font.Color = clWindowText
    GroupAppearance.TabAppearance.Font.Height = -11
    GroupAppearance.TabAppearance.Font.Name = 'Tahoma'
    GroupAppearance.TabAppearance.Font.Style = []
    GroupAppearance.TabAppearance.Gradient = ggRadial
    GroupAppearance.TabAppearance.GradientMirror = ggRadial
    GroupAppearance.TabAppearance.GradientHot = ggVertical
    GroupAppearance.TabAppearance.GradientMirrorHot = ggVertical
    GroupAppearance.TabAppearance.GradientSelected = ggVertical
    GroupAppearance.TabAppearance.GradientMirrorSelected = ggVertical
    GroupAppearance.TabAppearance.GradientDisabled = ggVertical
    GroupAppearance.TabAppearance.GradientMirrorDisabled = ggVertical
    GroupAppearance.TabAppearance.TextColor = 9126421
    GroupAppearance.TabAppearance.TextColorHot = 9126421
    GroupAppearance.TabAppearance.TextColorSelected = 9126421
    GroupAppearance.TabAppearance.TextColorDisabled = clWhite
    GroupAppearance.TabAppearance.ShadowColor = 15255470
    GroupAppearance.TabAppearance.HighLightColor = 16775871
    GroupAppearance.TabAppearance.HighLightColorHot = 16643309
    GroupAppearance.TabAppearance.HighLightColorSelected = 6540536
    GroupAppearance.TabAppearance.HighLightColorSelectedHot = 12451839
    GroupAppearance.TabAppearance.HighLightColorDown = 16776144
    GroupAppearance.ToolBarAppearance.BorderColor = 13423059
    GroupAppearance.ToolBarAppearance.BorderColorHot = 13092807
    GroupAppearance.ToolBarAppearance.Color.Color = 15530237
    GroupAppearance.ToolBarAppearance.Color.ColorTo = 16382457
    GroupAppearance.ToolBarAppearance.Color.Direction = gdHorizontal
    GroupAppearance.ToolBarAppearance.ColorHot.Color = 15660277
    GroupAppearance.ToolBarAppearance.ColorHot.ColorTo = 16645114
    GroupAppearance.ToolBarAppearance.ColorHot.Direction = gdHorizontal
    PageAppearance.BorderColor = 14922381
    PageAppearance.Color = 16445929
    PageAppearance.ColorTo = 15587527
    PageAppearance.ColorMirror = 15587527
    PageAppearance.ColorMirrorTo = 16773863
    PageAppearance.Gradient = ggVertical
    PageAppearance.GradientMirror = ggVertical
    PageAppearance.ShadowColor = 12888726
    PageAppearance.HighLightColor = 16644558
    PagerCaption.BorderColor = 15780526
    PagerCaption.Color = 15525858
    PagerCaption.ColorTo = 15590878
    PagerCaption.ColorMirror = 15524312
    PagerCaption.ColorMirrorTo = 15723487
    PagerCaption.Gradient = ggVertical
    PagerCaption.GradientMirror = ggVertical
    PagerCaption.TextColor = clBlue
    PagerCaption.TextColorExtended = 7958633
    PagerCaption.Font.Charset = DEFAULT_CHARSET
    PagerCaption.Font.Color = clWindowText
    PagerCaption.Font.Height = -11
    PagerCaption.Font.Name = 'Tahoma'
    PagerCaption.Font.Style = []
    QATAppearance.BorderColor = 11708063
    QATAppearance.Color = 16313052
    QATAppearance.ColorTo = 16313052
    QATAppearance.FullSizeBorderColor = 13476222
    QATAppearance.FullSizeColor = 15584690
    QATAppearance.FullSizeColorTo = 15386026
    RightHandleColor = 14668485
    RightHandleColorTo = 14731181
    RightHandleColorHot = 13891839
    RightHandleColorHotTo = 7782911
    RightHandleColorDown = 557032
    RightHandleColorDownTo = 8182519
    TabAppearance.BorderColor = clNone
    TabAppearance.BorderColorHot = 15383705
    TabAppearance.BorderColorSelected = 14922381
    TabAppearance.BorderColorSelectedHot = 6343929
    TabAppearance.BorderColorDisabled = clNone
    TabAppearance.BorderColorDown = clNone
    TabAppearance.Color = clBtnFace
    TabAppearance.ColorTo = clWhite
    TabAppearance.ColorSelected = 16709360
    TabAppearance.ColorSelectedTo = 16445929
    TabAppearance.ColorDisabled = clWhite
    TabAppearance.ColorDisabledTo = clSilver
    TabAppearance.ColorHot = 14542308
    TabAppearance.ColorHotTo = 16768709
    TabAppearance.ColorMirror = clWhite
    TabAppearance.ColorMirrorTo = clWhite
    TabAppearance.ColorMirrorHot = 14016477
    TabAppearance.ColorMirrorHotTo = 10736609
    TabAppearance.ColorMirrorSelected = 16445929
    TabAppearance.ColorMirrorSelectedTo = 16181984
    TabAppearance.ColorMirrorDisabled = clWhite
    TabAppearance.ColorMirrorDisabledTo = clSilver
    TabAppearance.Font.Charset = DEFAULT_CHARSET
    TabAppearance.Font.Color = clWindowText
    TabAppearance.Font.Height = -11
    TabAppearance.Font.Name = 'Tahoma'
    TabAppearance.Font.Style = []
    TabAppearance.Gradient = ggVertical
    TabAppearance.GradientMirror = ggVertical
    TabAppearance.GradientHot = ggRadial
    TabAppearance.GradientMirrorHot = ggVertical
    TabAppearance.GradientSelected = ggVertical
    TabAppearance.GradientMirrorSelected = ggVertical
    TabAppearance.GradientDisabled = ggVertical
    TabAppearance.GradientMirrorDisabled = ggVertical
    TabAppearance.TextColor = 9126421
    TabAppearance.TextColorHot = 9126421
    TabAppearance.TextColorSelected = 9126421
    TabAppearance.TextColorDisabled = clGray
    TabAppearance.ShadowColor = 15255470
    TabAppearance.HighLightColor = 16775871
    TabAppearance.HighLightColorHot = 16643309
    TabAppearance.HighLightColorSelected = 6540536
    TabAppearance.HighLightColorSelectedHot = 12451839
    TabAppearance.HighLightColorDown = 16776144
    TabAppearance.BackGround.Color = 16767935
    TabAppearance.BackGround.ColorTo = clNone
    TabAppearance.BackGround.Direction = gdHorizontal
    Left = 592
    Top = 52
  end
  object AdvMenuStyler1: TAdvMenuStyler
    AntiAlias = aaNone
    Background.Position = bpCenter
    SelectedItem.Font.Charset = DEFAULT_CHARSET
    SelectedItem.Font.Color = clWindowText
    SelectedItem.Font.Height = -11
    SelectedItem.Font.Name = 'Tahoma'
    SelectedItem.Font.Style = []
    SelectedItem.NotesFont.Charset = DEFAULT_CHARSET
    SelectedItem.NotesFont.Color = clWindowText
    SelectedItem.NotesFont.Height = -9
    SelectedItem.NotesFont.Name = 'Segoe UI'
    SelectedItem.NotesFont.Style = []
    RootItem.Font.Charset = DEFAULT_CHARSET
    RootItem.Font.Color = clMenuText
    RootItem.Font.Height = -11
    RootItem.Font.Name = 'Tahoma'
    RootItem.Font.Style = []
    Glyphs.SubMenu.Data = {
      5A000000424D5A000000000000003E0000002800000004000000070000000100
      0100000000001C0000000000000000000000020000000200000000000000FFFF
      FF0070000000300000001000000000000000100000003000000070000000}
    Glyphs.Check.Data = {
      7E000000424D7E000000000000003E0000002800000010000000100000000100
      010000000000400000000000000000000000020000000200000000000000FFFF
      FF00FFFF0000FFFF0000FFFF0000FFFF0000FDFF0000F8FF0000F07F0000F23F
      0000F71F0000FF8F0000FFCF0000FFEF0000FFFF0000FFFF0000FFFF0000FFFF
      0000}
    Glyphs.Radio.Data = {
      7E000000424D7E000000000000003E0000002800000010000000100000000100
      010000000000400000000000000000000000020000000200000000000000FFFF
      FF00FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FC3F0000F81F0000F81F
      0000F81F0000F81F0000FC3F0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000}
    SideBar.Font.Charset = DEFAULT_CHARSET
    SideBar.Font.Color = clWhite
    SideBar.Font.Height = -19
    SideBar.Font.Name = 'Tahoma'
    SideBar.Font.Style = [fsBold, fsItalic]
    SideBar.Image.Position = bpCenter
    SideBar.Background.Position = bpCenter
    SideBar.SplitterColorTo = clBlack
    Separator.GradientType = gtBoth
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMenuText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    NotesFont.Charset = DEFAULT_CHARSET
    NotesFont.Color = clGray
    NotesFont.Height = -9
    NotesFont.Name = 'Segoe UI'
    NotesFont.Style = []
    ButtonAppearance.CaptionFont.Charset = DEFAULT_CHARSET
    ButtonAppearance.CaptionFont.Color = clWindowText
    ButtonAppearance.CaptionFont.Height = -11
    ButtonAppearance.CaptionFont.Name = 'Segoe UI'
    ButtonAppearance.CaptionFont.Style = []
    Left = 636
    Top = 112
  end
  object AdvMenuOfficeStyler1: TAdvMenuOfficeStyler
    AntiAlias = aaNone
    AutoThemeAdapt = False
    Style = osOffice2007Luna
    Background.Position = bpCenter
    Background.Color = 16185078
    Background.ColorTo = 16185078
    ButtonAppearance.DownColor = 13421257
    ButtonAppearance.DownColorTo = 15395047
    ButtonAppearance.HoverColor = 14737117
    ButtonAppearance.HoverColorTo = 16052977
    ButtonAppearance.DownBorderColor = 11906984
    ButtonAppearance.HoverBorderColor = 11906984
    ButtonAppearance.CaptionFont.Charset = DEFAULT_CHARSET
    ButtonAppearance.CaptionFont.Color = clWindowText
    ButtonAppearance.CaptionFont.Height = -11
    ButtonAppearance.CaptionFont.Name = 'Segoe UI'
    ButtonAppearance.CaptionFont.Style = []
    IconBar.Color = 15658729
    IconBar.ColorTo = 15658729
    IconBar.CheckBorder = clNavy
    IconBar.RadioBorder = clNavy
    IconBar.SeparatorColor = 12961221
    SelectedItem.Color = 15465983
    SelectedItem.ColorTo = 11267071
    SelectedItem.ColorMirror = 6936319
    SelectedItem.ColorMirrorTo = 9889023
    SelectedItem.BorderColor = 10079963
    SelectedItem.Font.Charset = DEFAULT_CHARSET
    SelectedItem.Font.Color = clWindowText
    SelectedItem.Font.Height = -11
    SelectedItem.Font.Name = 'Tahoma'
    SelectedItem.Font.Style = []
    SelectedItem.NotesFont.Charset = DEFAULT_CHARSET
    SelectedItem.NotesFont.Color = clWindowText
    SelectedItem.NotesFont.Height = -9
    SelectedItem.NotesFont.Name = 'Segoe UI'
    SelectedItem.NotesFont.Style = []
    SelectedItem.CheckBorder = clNavy
    SelectedItem.RadioBorder = clNavy
    RootItem.Color = 15915714
    RootItem.ColorTo = 15784385
    RootItem.GradientDirection = gdVertical
    RootItem.Font.Charset = DEFAULT_CHARSET
    RootItem.Font.Color = clMenuText
    RootItem.Font.Height = -12
    RootItem.Font.Name = #47569#51008' '#44256#46357
    RootItem.Font.Style = []
    RootItem.SelectedColor = 7778289
    RootItem.SelectedColorTo = 4296947
    RootItem.SelectedColorMirror = 946929
    RootItem.SelectedColorMirrorTo = 5021693
    RootItem.SelectedBorderColor = 4548219
    RootItem.HoverColor = 15465983
    RootItem.HoverColorTo = 11267071
    RootItem.HoverColorMirror = 6936319
    RootItem.HoverColorMirrorTo = 9889023
    RootItem.HoverBorderColor = 10079963
    Glyphs.SubMenu.Data = {
      5A000000424D5A000000000000003E0000002800000004000000070000000100
      0100000000001C0000000000000000000000020000000200000000000000FFFF
      FF0070000000300000001000000000000000100000003000000070000000}
    Glyphs.Check.Data = {
      7E000000424D7E000000000000003E0000002800000010000000100000000100
      010000000000400000000000000000000000020000000200000000000000FFFF
      FF00FFFF0000FFFF0000FFFF0000FFFF0000FDFF0000F8FF0000F07F0000F23F
      0000F71F0000FF8F0000FFCF0000FFEF0000FFFF0000FFFF0000FFFF0000FFFF
      0000}
    Glyphs.Radio.Data = {
      7E000000424D7E000000000000003E0000002800000010000000100000000100
      010000000000400000000000000000000000020000000200000000000000FFFF
      FF00FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FC3F0000F81F0000F81F
      0000F81F0000F81F0000FC3F0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000}
    SideBar.Font.Charset = DEFAULT_CHARSET
    SideBar.Font.Color = clWhite
    SideBar.Font.Height = -19
    SideBar.Font.Name = 'Tahoma'
    SideBar.Font.Style = [fsBold, fsItalic]
    SideBar.Image.Position = bpCenter
    SideBar.Background.Position = bpCenter
    SideBar.SplitterColorTo = clBlack
    Separator.Color = 12961221
    Separator.GradientType = gtBoth
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMenuText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    NotesFont.Charset = DEFAULT_CHARSET
    NotesFont.Color = clGray
    NotesFont.Height = -9
    NotesFont.Name = 'Segoe UI'
    NotesFont.Style = []
    MenuBorderColor = clSilver
    Left = 636
    Top = 56
  end
  object imagelist24x24: TImageList
    ColorDepth = cd32Bit
    DrawingStyle = dsTransparent
    Height = 24
    Width = 24
    Left = 592
    Top = 160
    Bitmap = {
      494C010108007000840218001800FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      000000000000360000002800000060000000480000000100200000000000006C
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
      0000000000000101010101010102010101040101010301010102000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005C43
      009F9C7200CF0000000F00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000010101060101
      011301010123010101310101013A0101013F0101013D010101370101012C0101
      011D0101010E0101010200000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000020000000900000018000000270000002B000000200000000F0000
      0004000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000010000000F00000034000000460000003A0000
      001A000000050000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000005C43009FEEAD
      00FFEEAD00FF9C7200CF0000000F000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000101
      01040101010B010101140101011F0101012901010133010101430101015B0101
      016F0101018B0A0A0ABB181818DF212121ED1D1D1DE7111111CB030303950101
      01590101013B0101011E01010106000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00020000000A04020133724620BFAB6930E64228139E000000360000001E0000
      0009000000010000000000000000000000000000000000000000000000000000
      000000000000000000000000000A5D391BAEB36E33EC7D4D24CF0B06036F0000
      00490000001F0000000600000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000005C43009FEEAD00FFEEAD
      00FFEEAD00FFEEAD00FF9C7200CF0000000F0000000000000000000000000000
      0000000000000000000000000000000000000000000001010102141212532D2A
      297E312D2C88332F2E913732319A3A3634A23C3736A93D3836B6383432C21715
      15D4303030F97A7A7AFEB3B3B3FFC3C3C3FFC1C1C1FF9C9C9CFF535353FD1818
      18DE211F1EA3221F1E8101010116000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000020000
      000A0704023CAF672FEBBB5E11FF892800FFBA5F1DFF311D0D8E000000240000
      000B000000010000000000000000000000000000000000000000000000000000
      0000000000000000000029190C72D08A50FF9F4100FE9C3D09FFB97033F2110A
      04790000004A0000001F00000006000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000005C43009FEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FF9C7200CF0000000F00000000000000000000
      0000000000000000000000000000000000000000000006050528DED0CBFCF0E5
      E1FFF1E8E5FFF2EAE7FFEBDED9FFF0E6E2FFF2E9E6FFEEE7E4FF827B78FF4D4D
      4DFFC2C1C1FFE6E6E6FFE7E7E7FFD4D4D4FFE7E7E7FFE7E7E7FFE0E0E0FF8888
      88FF413F3FFFCBC1BEFF211F1E66000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000020000000A0704
      013CAB652CEBCB741BFFC66600FFC66600FFC16721FF5D3619B60000001E0000
      0009000000010000000000000000000000000000000000000000000000000000
      000000000000000000005D391BA7EECFAEFFC86A06FFB75700FF902F02FFB96D
      30F3110A04790000004A0000001F000000060000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000302001FD19800EFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FF9C7200CF0000000F000000000000
      000000000000000000000000000000000000000000000A090936EBDDD9FFF6F0
      EEFFF9F5F4FFFBFAF9FFEFE7E5FFF7F2F0FFFAF6F5FFD2D1D0FF424242FFC7C7
      C7FFE7E7E7FFE7E7E7FFE7E7E7FFDFDFDFFFE7E7E7FFE7E7E7FFE7E7E7FFE5E5
      E5FF7F7F7FFF686564FF2F2C2B77000000000000000000000000000000000000
      000000000000000000000000000000000000000000020000000A0603013CA760
      2BEBD0873DFED1852FFFCC7517FFC66600FFCE7428FF2415097B000000120000
      0004000000000000000000000000000000000000000000000000000000000000
      0000000000000000000024160A69E2A66CFFE8C299FFC76803FFB75700FF9536
      07FFBA6F32F3110A04790000004A0000001F0000000600000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000805002FD19800EFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FF9C7200CF0000000F0000
      000000000000000000000000000000000000000000000A090936E6D8D3FFEFE6
      E3FFF1EAE8FFF3EEECFFEADEDAFFEFE7E4FFF2EBE9FF71706FFF8C8C8CFFE7E7
      E7FFE7E7E7FFE7E7E7FFE7E7E7FFE7E7E7FFE7E7E7FFE7E7E7FFE7E7E7FFE7E7
      E7FFD8D8D8FF444443FF1E1C1B77000000000000000000000000000000000000
      0000000000000000000000000000000000020000000A0603013CA25B29EBD699
      5CFEDCA25EFFD69447FFD0822BFFC66C1EFF703E1BC700000018000000060000
      0001000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000026C421FB5E2AC77FFE4B786FFC86A05FFBF68
      18FFA24918FFB87034F3110A04790000004A0000001F00000006000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000805002FD19800EFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FF9C7200CF0000
      000F000000000000000000000000000000000000000009090936E4D6D2FFF1EB
      E8FFF4EFEEFFF7F4F3FFE9DFDCFFF2ECEAFFF3EFEDFF403F3FFFC8C8C8FFE7E7
      E7FFE7E7E7FFE7E7E7FFE7E7E7FFE7E7E7FFE7E7E7FFE7E7E7FFE7E7E7FFE7E7
      E7FFE7E7E7FF777777FF0C0B0B7F000000000000000000000000000000000000
      00000000000000000000000000020000000A0603013C9D5526EBD7A16AFEE6BE
      8BFFE1B176FFDA9E57FFC87631FF5C3015BA0000001A00000006000000010000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000003583317A7DDA16AFFE2B27CFFD186
      31FFCA843FFFB05B29FFB46932F3100904790000004A0000001F000000060000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000805002FD198
      00EFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FF9C72
      00CF0000000F0000000000000000000000000000000009090836E2D6D2FFF3ED
      EAFFF7F3F1FFFAF9F8FFEBE3E1FFF4EEECFFE5E2E1FF3E3E3EFFD6D6D6FFD5D5
      D5FFE3E3E3FFE9E9E9FFEDEDEDFFCECED7FFE1E1E9FFEFEFEFFFEBEBEBFFDCDC
      DCFFD6D6D6FF929292FF0C0C0C93000000000000000000000000000000000000
      000000000000000000010000000A0603013C994E21EBD19254FEE4B983FFE8C6
      98FFE2B57BFFC87D40FF592D12BA0000001A0000000600000001000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000003542E14A7D99C65FFE4B8
      86FFDBA15BFFD59E66FFBC6C39FFAD642FF30F0803790000004A0000001F0000
      0006000000000000000000000000000000000E0A003F0E0A003F0E0A003F0E0A
      003F0E0A003F0E0A003F0E0A003F0E0A003F0E0A003F0E0A003F0E0A003F2D20
      006FEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FF9C7200CF0000000F00000000000000000000000009080836DBCDC8FFE8E0
      DDFFEBE5E3FFEEE9E7FFDFD3CFFFE9E1DFFFDDD7D6FF3E3D3DFFDFDFDFFFEDEC
      ECFFF1F1F1FFF5F5F5FFE3E3E3FFDEDEDEFFB6B6C8FFD3D3E7FFDCDCEAFFE1E1
      E9FFEBEBEBFF939393FF0C0C0C90000000000000000000000000000000000000
      000000000001000000060502013993481BEBC97D32FED99C54FFDFAB6CFFE1B1
      76FFC77E45FF552A10BA0000001A000000060000000100000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000034E2911A6D498
      63FFE6BF90FFE3B881FFDFB284FFC7773EFFA65C28F30E0703790000004A0000
      001A00000003000000000000000000000000EEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FF9C7200CF0000000F000000000000000009080836DDD0CDFFF0EB
      E9FFF5F2F0FFFAF9F8FFE7E0DEFFF2ECEBFFF5F2F1FF474747FFD0D0D0FFF8F8
      F8FFF8F8F8FFE7E7E7FFF0F0F0FFF8F8F8FFF6F6F6FFD6D6D6FFF2F2F2FFF4F4
      F6FFF3F3F5FF777777FF0D0C0C7D000000000000000000000000000000000000
      00000000000102010025984619F3BF650DFECF7E25FFD48E3DFFD8994EFFC173
      39FF53260FBC0000001C00000007000000010000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000034A24
      0EA6CF915EFFE6BE8FFFE1B278FFDA9F5FFFCF7D3BFFA85724F8090401700000
      00370000000A000000000000000000000000EEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FF9C7200CF0000000F0000000009080836D9CCC8FFEEE8
      E6FFF3EFEEFFF8F7F6FFE2DAD8FFEFEAE8FFF5F1F0FF828181FF989898FFFAFA
      FAFFFBFBFBFFFAFAFAFFFBFBFBFFFBFBFBFFFBFBFBFFFAFAFAFFE1E1E1FFF4F4
      F4FFE5E5E5FF4F4F4FFF1F1D1C77000000000000000000000000000000000000
      0000000000013B19099EBC6114FFC66600FFC96F0EFFCE7B21FFBA6523FF5224
      0CC10000002F0000001200000004000000010000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000347200CA8C7844FFFDEAA6BFFD8974CFFD48C3BFFD37D34FF54260FC70000
      003E0000000B000000000000000000000000EEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FF9C7200CF0000000009080836C8C1C4FFCACC
      E0FFD1D3E5FFDEE2E8FFD1CCCCFFE4DDDBFFE9E3E2FFD4D0CFFF5F5E5EFFD8D8
      D8FFFCFCFCFFFDFDFDFFFDFDFDFFF2F2F2FFFDFDFDFFFDFDFDFFFDFDFDFFE8E8
      E8FF959595FF7C7877FF29262577000000000000000000000000000000000000
      0000000000014C1E0AB4C36E1DFFC66700FFC66600FFA54803FE9E4112FF0F06
      027100000037000000210000000D000000030000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000707030148A04619FECB8030FED0822BFFCD791DFFCF7725FF65290FD70000
      002A00000007000000000000000000000000EEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FF9C7200CF0000000008080836C9C5C9FFB7B5
      F3FFA2A1FCFFF3F2F7FFD7D8DDFFEEE8E7FFF4F1F0FFFAF9F9FFA29C9BFF7A7A
      7AFFDBDBDBFFFCFCFCFFFEFEFEFFE9E9E9FFFEFEFEFFFDFDFDFFF4F4F4FFADAD
      ADFF727171FFE6E3E2FF29252577000000000000000000000000000000000000
      00000000000010060256A44916FFCB7B24FEC66701FFBB5B00FF943508FF963A
      0DFB1407027B00000037000000200000000D0000000300000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000070A03
      01548E360DF7BF6409FEC96E0CFFC86C08FFC66600FFAD4F14FF200B03880000
      000D00000001000000000000000000000000EEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FF9C7200CF0000000F0000000008080736C1BBBDFFC9CA
      DAFFD2D4E1FFD5D8E5FFCBC6C7FFE0D9D6FFE5E0DEFFE8E3E2FFD3C8C5FFABA5
      A3FF767574FFB2B2B2FFDADADAFFE7E7E7FFE3E3E3FFCACACAFF8E8E8DFF7F7C
      7BFFDAD5D4FFE0D8D6FF28252477000000000000000000000000000000000000
      000000000000000000011F0A027AA64E1BFFCE8434FEC76802FFBD5D02FF9F40
      0FFF94370BFB1306017B00000037000000200000000D00000003000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000070A030054872E
      08F7BC5E01FEC66600FFC66600FFC36500FEA14106FF310F03A6000000100000
      000200000000000000000000000000000000EEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FF9C7200CF0000000F000000000000000008070736CDC2BEFFEAE5
      E3FFF1EEEDFFF9F7F7FFDCD5D2FFECE7E6FFF3F0F0FFFAF9F8FFDBD3D1FFECE8
      E6FFEBE9E8FFB2B1B1FF8D8A89FF8D8C8CFF929191FFA09F9FFFBCB6B4FFEDE9
      E7FFF5F2F2FFEDEAE9FF27242377000000000000000000000000000000000000
      00000000000000000000000000011E09017AA64F20FFD38F47FEC76802FFBF60
      03FFA94B15FF92340AFB1305007B00000037000000200000000D000000030000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000007090200547E2502F7BA5C
      00FEC66600FFC66600FFC36500FE9B3A01FF2E0B01A600000010000000020000
      0000000000000000000000000000000000000E0A003F0E0A003F0E0A003F0E0A
      003F0E0A003F0E0A003F0E0A003F0E0A003F0E0A003F0E0A003F0E0A003F2D20
      006FEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FF9C7200CF0000000F00000000000000000000000008070736CBC0BCFFE7E2
      E0FFEFECEBFFF7F6F5FFDCD6D3FFE9E4E3FFF1EEEDFFF9F8F8FFDAD3D0FFEAE5
      E4FFF2EFEEFFF7F5F5FFDAD2D0FFEAE6E4FFF2EFEEFFF4F2F2FFDCD5D2FFEBE6
      E5FFF3F0EFFFEDEAE9FF26232277000000000000000000000000000000000000
      0000000000000000000000000000000000011D07007AA45125FFD69958FEC768
      03FFC16204FFB3571CFF8F3208FB1204007B00000037000000200000000C0000
      0002000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000508010053781F00F7B95B00FEC666
      00FFC66600FFC36500FE973600FF2D0900A70000001000000002000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000805002FD198
      00EFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FF9C72
      00CF0000000F0000000000000000000000000000000007070736C0B5B2FFC9BF
      BCFFCCC2BFFFCDC4C1FFC2B6B2FFCABFBCFFCCC2C0FFCDC3C0FFC2B6B3FFCAC0
      BDFFCCC3C0FFCBC1BEFFC3B7B4FFCAC0BDFFCCC3C0FFCAC0BDFFC4B9B5FFCAC0
      BDFFCDC3C0FFCAC0BDFF25222277000000000000000000000000000000000000
      000000000000000000000000000000000000000000011B05007AA4532AFFDAA3
      6AFEC76904FFC36406FFBD6222FF8C3006FB1103007C000000340000001A0000
      0007000000010000000000000000000000000000000000000000000000000000
      00000000000000000000000000020701004B781F00F6B95B00FEC66600FFC666
      00FFC36500FE973600FF2D0900A7000000100000000200000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000805002FD19800EFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FF9C7200CF0000
      000F000000000000000000000000000000000000000006060630C0BDBBFEC3BF
      BEFFC3BFBEFFC2BFBEFFD4D1CFFFD4D1CFFFD4D1CFFFD4D1CFFFD4D1CFFFD4D1
      CFFFD4D1CFFFD4D1CFFFD4D1CFFFD4D1CFFFD4D1CFFFD4D1CFFFD4D1CFFFD4D1
      CFFFCCC8C7FFC7C3C2FF201E1E70000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000011B05007AA759
      31FFDEAE7BFEC76904FFC56707FFC76E2AFF8D2F06FE0A020067000000260000
      000C000000010000000000000000000000000000000000000000000000000000
      000000000000000000000100001A761F00F4BB5D00FEC66600FFC66600FFC365
      00FE973600FF2D0900A700000010000000020000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000805002FD19800EFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FF9C7200CF0000000F0000
      00000000000000000000000000000000000000000000010101032B2929805250
      4FA752504FA752504FA7555352A7555352A7555352A7555352A7555352A75553
      52A7555352A7555352A7555352A7555352A7555352A7555352A7555352A75553
      52A7545251A73E3B3B9702020216000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000011B05
      007AAA5F39FFE5BB8EFFC76A05FFC86909FFCA7229FF3C0C00BE000000250000
      000C000000010000000000000000000000000000000000000000000000000000
      000000000000000000002307008BBA6829FFC66600FFC66600FFC36500FE9736
      00FF2D0900A70000001000000002000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000302001FD19800EFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FF9C7200CF0000000F000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00011B05007AAE6641FFEAC8A3FFC96F0EFFCB7C39FF390C00B7000000180000
      0007000000010000000000000000000000000000000000000000000000000000
      0000000000000000000020060084D4A47DFFD7964DFFCA7215FF993A04FF2C09
      00A6000000100000000200000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000005C43009FEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FF9C7200CF0000000F00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000001170400718C3618FECC9977FF852D10FB05010041000000090000
      0002000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000166E250DE7CE9C7BFF90391BFF2908009A0000
      000A000000010000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000005C43009FEEAD00FFEEAD
      00FFEEAD00FFEEAD00FF9C7200CF0000000F0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000020000230F03005D0100001B00000004000000010000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000030D02005602000028000000020000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000005C43009FEEAD
      00FFEEAD00FF9C7200CF0000000F000000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000000000000000000005C43
      009F9C7200CF0000000F00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000020202100404
      0425080808360D0D0D451111114F1515155A1616165B1B1B1B66212121702121
      217021212170212121701B1B1B661616165B1515155A111111510D0D0D450808
      0836040404250202021000000000000000000000000000000000000000000000
      00000000000001010110060101551B06028E2D0E05A7391508B23E1909B7411A
      0ABA411B0ABA411A09BA3C1608B7341006B1230802A20C0201810101014B0101
      0112000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000010101130601
      01661604029B230A06AC2A0E08B42D0F08B72D0F08B7280C07B41D0604AB0D01
      0194010101600101011B00000000000000000000000000000000010101030101
      010A010101120101011A010101220101012B010101332715068A744114D67542
      16D9754215D9754216D8744115D6724015D4714015D2714015D1703F14CF6F3E
      14CD6E3D13CB2A17077C01010102000000000000000001010104141414584040
      409E656565C59B9B9BECA2A2A2F2A6A6A6F5A8A8A8F7ABABABF9ACACACFAACAC
      ACFAACACACFAACACACFAABABABF9A8A8A8F7A6A6A6F5A2A2A2F29B9B9BEC8E8E
      8EE24C4C4CAB1313135601010103000000000000000000000000000000000000
      00000401013D652009C4E36F2CFBFE9444FFFFA550FFFFAE58FFFFB15AFFFFB9
      5AFFFFBB5DFFFFB35DFFFFAF59FFFFA753FFFF9747FFE97631FE91320FEB1303
      019B0101012C0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000002010127481109C3D26B
      35FFEC904AFFFAA155FFFFAA5BFFFFAB5DFFFFA95DFFFDA559FFF0954FFFDC78
      3CFF842C15F20F0101A501010124000000000000000000000000010101070101
      01080101010801010108010101080101010801010108754217CCB77438FFB774
      39FFB87439FFB8753AFFB8753AFFB8753AFFB87439FFB77439FFB77439FFB673
      38FFB57237FF8E5320E200000000000000000000000000000000010101010101
      010E5E5E5EACD9D9D9FEDADADAFEDADADAFEDADADAFEDADADAFEDADADAFEDADA
      DAFEDADADAFEDADADAFEDADADAFEDADADAFEDADADAFEDADADAFEDADADAFED9D9
      D9FE565656A30101010100000000000000000000000000000000000000000301
      0131B64919E2FFAC57FFFFBD68FFFFBB6BFFFFBB70FFFFBD73FFFFC573FFD6A2
      7AFFD29A6EFFFDC471FFFFBF75FFFFBC72FFFFBC6EFFFFBC6AFFFFB35DFFE063
      25FF170501A10101011800000000000000000000000000000000000000000000
      000000000000000000000000000000000000010101094A150BB9FFA559FFFFC1
      6CFFFFC072FFFFC177FFFFC27AFFFFC27CFFFFC17CFFFFC279FFFFC176FFFFC2
      71FFFFB966FFAD4827FD0501017D0000000000000000191513A939302AFF3F37
      31FF473F39FF4F4742FF57504BFF605954FF6A635FFFBC7337FFC88146FFC981
      47FFC98147FFC98147FFC98147FFC98147FFC98147FFC98147FFC88147FFC881
      46FFC78045FFC17435FF2C2824BB000000000000000000000000000000004848
      489BD4D4D4FFD8D5D2FED4C6B9FFD8CCBFFFD6CABEFED6C9BCFFCCBEB1FFD2C9
      C0FFD0C7BFFECBBCAEFFD0C7BFFED2C9C0FFD2C9C0FFD0C7BFFED2C8BFFFD5CE
      C8FF646464AB0000000000000000000000000000000000000000000000004618
      0796FFAC5EFFFFC073FFFFBA75FFFFBE7CFFFFC581FFF7C181FF9273AEFF1915
      EAFF100DB9FF7B5D83FFFABF81FFFFC583FFFFC07FFFFFBF7CFFFFC179FFFFB6
      67FF853413E20101014500000000000000000000000000000000000000000101
      012402010160040301800607019104080294130801AAD87644FBFFC97DFFFFBF
      7FFFFFC486FFFFC88CFFFFCA90FFFFCB92FFFFCA92FFFFCA8FFFFFC58AFFFFC2
      84FFFFC981FFF8A260FF220804AF00000000000000004C4440F2D4D2D1FFDFDE
      DDFFE1E0DFFFE4E2E2FFE5E4E3FFE8E7E6FFE9E6E2FFD78B52FFD5905AFFD590
      5AFFD6905BFFD6915BFFD6915BFFD6915BFFD6915BFFD6905BFFD5905AFFD48F
      5AFFD48F59FFD5894EFF7C6C60FF000000000000000000000000000000005959
      59ABD5D5D5FFD6D1CCFEE4DACEFFEDE6DDFFEAE3DAFEE8E0D6FFC6BCB0FFB6B2
      A6FFB5B1A5FECEC3B8FFDDDDDDFEDFDFDFFFDFDFDFFFDDDDDDFEDFDEDEFFD2C9
      C1FF656565AB000000000000000000000000000000000000000000000000A24C
      22CFFFC07AFFFFC283FFFFC589FFFFC990FFFFD295FFECC595FF665FB9FF181D
      E0FF0A0EE3FF443EB0FFF1C091FFFFD19AFFFFC28BFFFEB77AFFFEBF81FFFFC9
      81FFBC6834F30401015B00000000000000000000000000000000040301661E3D
      13E02E8539FD33A64DFF38B256FF2FBC5AFF5B803CFFF49763FFFFCC8EFFFFCD
      97FFFFD1A0FFFFD3A6FFFFD6AAFFFFD7ACFFFFD7ACFFFFD6A9FFFFD3A4FFFFD0
      9CFFFFCF96FFFFBD80FF34170DB7000000000000000057524DF3DFDEDDFFE1E0
      DFFFE4E2E2FFE7E6E5FFE9E8E8FFEBEAEAFFECDBCFFFE39A64FFE29E6DFFE29E
      6DFFE39F6DFFE39F6EFFE39F6EFFE39F6EFFE39F6EFFE39F6DFFE29E6DFFE19E
      6CFFE19D6CFFE19761FF987D69FF000000000000000000000000000000005858
      58ABD4D4D4FED7D3CEFEDCD2C7FEE4DDD4FEE4DDD4FEE0D8CEFECCC1B7FED0CC
      C5FED0CCC6FECCC0B5FEDCDAD7FEDCDAD7FEDCDAD7FEDCDAD7FEDCD9D6FED1C8
      C0FE666666AB000000000000000000000000000000000000000000000000BE68
      3AE0FDC489FFFECB94FFFFD09DFFFFD2A3FFFFD9ABFFF8D9AAFF978CC5FF3638
      F6FF2426F1FF6C60B5FFFBD8ACFFFFE1B4FFFFCE91FFFEB470FFFEC18AFFFFD0
      93FFC77E4DF60502015C00000000000000000000000003040150308433FA3DD9
      72FF45DE7AFF4DDA7DFF52DB81FF4DE387FF6E9B5BFFF29F71FFFFD19EFFFFDA
      B0FFFFDDB9FFFFE0BFFFFFE3C4FFFFE4C7FFFFE3C7FFFFE2C2FFFFDFBCFFFFDC
      B5FFFFD7A9FFFFC38EFF30180FB0000000000000000057524DF3E1DFDEFFE3E2
      E1FFE6E5E4FFE8E7E7FFECEBEAFFEEEDEDFFF2CFB8FFEFA876FFEEAC7EFFEFAD
      7FFFF0AD7FFFF0AE80FFF0AE80FFF0AE80FFF0AE80FFF0AD80FFEFAD7FFFEEAC
      7EFFEDAB7DFFEDA573FFB78C6FFF000000000000000000000000000000005959
      59ABD7D7D7FFD9D4CFFED5C6B7FFDBCEC0FFD8CBBFFED8CABCFFCBBDB0FFD5CC
      C4FFD3CAC2FEC9BAABFFCDC4BBFEC9C0B4FFC9C0B4FFC7BFB3FED0C7BDFFD4CB
      C2FF676767AB000000000000000000000000000000000000000000000000A45C
      36D0FBCB97FFFDD1A3FFFFDBB3FFFFDDB8FFFFE1C0FFFFEBC4FFA89CBFFF393A
      D9FF383ADFFF857ABCFFFFE8BDFFF8E2B3FFB9C77FFFF6C188FFFECB9DFFFFD2
      A0FFB97B53F00401015100000000000000000000000016330DBA4CDA7BFF5ADB
      86FF64D689FF6CDA90FF72DB95FF72E49DFF75B276FFE39C75FFFED2ABFFFEE3
      C7FFFFEAD2FFFFEEDBFFFFF0E0FFFFF3E6FFFFF2E4FFFFF0E0FFFFECD7FFFFEA
      D1FFFCD8B5FFFCC097FF1C0C0795000000000000000057524DF3E1DFDEFFE4E2
      E2FFE6E5E4FFE9E8E8FFECECEBFFEFEEEEFFF6D0B5FFF1B68CFFEEBE9CFFF2BF
      9CFFF9B88DFFF9B98DFFFAB98EFFFAB98EFFFAB98EFFF9B98DFFF9B88CFFF8B7
      8CFFF7B68BFFF6B081FFDAA07BFF000000000000000000000000000000005959
      59ABD8D8D8FFDAD5D1FEE4DACEFFEDE6DDFFEAE3DAFEE8E0D6FFD5CCC4FFE5E5
      E5FFE3E3E3FED2C7BDFFCCCAC5FEBBB7ADFFBBB7ADFFBAB6ACFED3D1CCFFD5CC
      C4FF676767AB0000000000000000000000000000000000000000000000006333
      1CA2FBD1A7FFF7CFAAFFFFE4C8FFFFE7CDFFFFEAD5FFFFF8DAFFBDB7D5FF4848
      F2FF3D3EEAFFA397C5FFFFF7D5FFFEE9CBFFECE0BAFFFDDAB7FFF8CDA9FFFFDB
      B1FF8F583ADD020101320000000000000000000000002C6C2CE268E193FF77DD
      99FF81E0A0FF89E3A6FF90E4ACFF94E9B2FF8ADAA5FFC99C76FFFCD5BBFFFAE4
      D2FFFFF8EFFFFFF5EFFFFFFDFAFFFFF9EEFFFFFCF8FFFFF8F4FFFFFBF4FFFDF1
      E4FFFDDFC8FFD29B7EF70402014C000000000000000057524DF3E0DEDDFFE3E2
      E1FFE5E4E3FFE8E7E7FFEBEAE9FFEEEEEDFFF1F0F0FFDDBBA1FFDBDBDBFFE0E0
      E0FFEFDBCEFFF4CDB3FFF3CBB1FFF3CBB0FFF3CAAFFFF1C8ADFFEFC6AAFFEDC4
      A7FFEBC1A4FFECB791FFD4A889FF000000000000000000000000000000005858
      58ABD7D7D7FEDBD6D2FECFC0B2FED3C6BAFED3C6BAFED1C3B6FEC9BAABFED1C7
      BDFED1C7BDFEC7B7A7FED1C7BDFED1C7BDFED1C7BDFED1C7BDFED1C6BCFED4CB
      C2FE686868AB000000000000000000000000000000000000000000000000200E
      065BFCCEA9FFF2D0B4FFFBE6D1FFFFF4E5FFFFF6EDFFFFFFF8FFC4C5E0FF4041
      CDFF3837CFFFB4B0D9FFFFFFFCFFFFFAF5FFFFF8EEFFFBEDDCFFF4D2B8FFFFDC
      B7FF341B0EA401010107000000000000000000000000377839E27FE4A2FF94E4
      AFFF9FE7B6FFA8EABDFFAFEBC3FFB3ECC5FFB0F3CFFFB1B890FFF1BCA2FFF2DE
      D9FFFFF7EEFFFFE1C9FFF6D1B7FFE5A771FFEFBF97FFFFD2A9FFFFE8D0FFF2E2
      E0FFFFE2D2FF3B2217A801010105000000000000000057524DF3DDDCDBFFE1DF
      DEFFE3E2E1FFE6E5E4FFE9E8E7FFEBEBEAFFEEEDEDFFDDBDA2FFDFDFDFFFE4E4
      E4FFE9E9E9FFECECECFFEFEFEFFFF2F2F2FFF1F1F1FFECECECFFE5E5E5FFDEDE
      DEFFD7D8D7FFD0AE91FF7A7470FF000000000000000000000000000000005959
      59ABDADADAFFDCD7D3FEE4DACEFFEDE6DDFFEAE3DAFEE8E0D6FFD7CEC6FFE7E7
      E7FFE5E5E5FED3C9BEFFCDCBC5FEBAB6ABFFBAB6ABFFB9B5AAFED4D2CDFFD7CE
      C6FF696969AB0000000000000000000000000000000000000000000000000201
      010F8A573CBDF7E4D5FFEED1C4FFFFFFFEFFFEEDE7FFFFEFDCFFDDD3DDFF2A26
      CCFF1712B8FFC0B4C9FFFFECCDFFFEE4D7FFFFFFFFFFF1D7CDFFFFEBDCFFB37F
      63E60301013900000000000000000000000000000000265023BF91E4ADFFADEB
      C2FFBDEFCEFFC8F1D6FFCFF3DBFFDBFCE0FFDCFDE2FFC9F2DAFFD1B898FFF2B5
      9AFFECBAAAFFBBBAE2FF9992CAFF8A91D2FF8989CAFFA79BC4FFE3A98CFFFFBD
      9EFF744F3DC50101011E00000000000000000000000057514DF3DAD9D8FFDDDC
      DBFFE0DEDDFFE2E1E0FFE5E4E3FFE7E6E5FFEAE9E8FFE2BDA0FFD79C71FFDBA0
      76FFE0A47AFFE2A67DFFE4A880FFE5A980FFE3A77DFFE0A379FFDB9F73FFD69A
      6DFFD29466FFDAAB87FF7B7471FF000000000000000000000000000000005959
      59ABDBDBDBFFDDD9D4FED7CABDFFDDD2C7FFDBD0C5FEDACEC2FFCFC2B5FFDBD4
      CDFFD9D2CBFECDBEB0FFD3CBC3FECFC7BEFFCFC7BEFFCDC5BDFED6CEC6FFD7CF
      C6FF696969AB0000000000000000000000000000000000000000000000000000
      00000D060338CEA087E6EBD7D5FFF2CCC0FFFFECD8FFFED6ABFF957B95FF0224
      CEFF011FD1FF7F6C9CFFFEC485FFFFCD95FFF4C8B6FFEFD5D0FFEFC9B0FA1007
      036600000000000000000000000000000000000000000A20087EA6E2B6FFBBEB
      CBFFE0F9E9FFE9F9EFFFFBFFFAFFCED1EAFFD1D1E7FFFCFFFFFFECF7F2FFDCB3
      98FFA391C5FFA6C0FFFFB7CFFCFFB8CEFCFFABC4FDFF8DAEFFFF8F92E3FF7043
      39DA0201012D0000000000000000000000000000000056504CF2D6D5D3FFD9D7
      D6FFDBD9D8FFDEDCDBFFE0DEDDFFE2E0DFFFE4E2E2FFE9C9B1FFF1BF9BFFF4C3
      9FFFF6C39FFFF7AD7BFFF7AA75FFF7A975FFF4A671FFF0A16AFFEC9C64FFE796
      5CFFE29155FFDFB08BFF7A7470FF000000000000000000000000000000005959
      59ABDCDCDCFFDED9D5FEDDD1C4FFE5DCD0FFE3D9CEFEE1D7CBFFCEC3B7FFCEC8
      C0FFCCC6BFFED0C4B7FFE1DDDAFEE3DFDCFFE3DFDCFFE1DDDAFEE2DEDBFFD8CF
      C7FF6A6A6AAB0000000000000000000000000000000000000000000000000000
      00000000000012090442BE8B6CDCF19E7FFFB5C0C4FF69A9C4FF4493C1FF49A3
      CBFF429FC7FF2C86B8FF4F90ADFFA9A796FFF4986FFFCE9475EB170C07680000
      00000000000000000000000000000000000000000000010301246C9E6DE7CDEC
      D7FFEDF8F2FFE2F6DDFFDCF3C8FF3938E7FF4A43E0FFCFF5B8FFC4FAC8FFACBB
      EEFFB4C9FDFFCCDBF7FFC9D8F7FFC7D7F6FFC4D5F5FFBACDF4FFA7C1FFFF3D4E
      8CE50101024E00000000000000000000000000000000554F4CF2D3D1CFFFD4D2
      D1FFD6D5D3FFD8D7D5FFDAD9D8FFDDDBDAFFDFDDDCFFE0DDDCFFE2DCD7FFE3DD
      D9FFE4DEDAFFE5DFDBFFE6E0DCFFE6E0DCFFE8E1DDFFE8E1DDFFE7E1DCFFE6E0
      DCFFE6DFDAFFE5E2E0FF7B7571FF000000000000000000000000000000005959
      59ABDBDBDBFEDFDAD5FEE1D8CDFEEAE4DCFEEAE4DCFEE6DFD6FECAC0B6FEBCB8
      ADFEBCB8AEFED2C7BDFEE8E8E8FEE8E8E8FEE8E8E8FEE8E8E8FEE8E7E7FED7CE
      C6FE6B6B6BAB0000000000000000000000000000000000000000000000000000
      0000000000000000000006030226555857D463B5E2FF75C4EFFF81CAEFFF7DC4
      EAFF73BEE4FF64B4DDFF44A0D2FF2B90C7FF68747AFB0E060375010101010000
      000000000000000000000000000000000000000000000000000004140463ADD8
      ADFFB1DCABFFB1E5BDFF4A9692FF1454C3FF1652BDFF409D85FF57D68FFF98B3
      E6FFD2DDFFFFC9D9FCFFC9D9FCFFC9D8FCFFC9D8F9FFC7D6F6FFBFD2F6FF97AF
      FCFF090C179601010106000000000000000000000000554F4BF2CDCBC9FFCFCD
      CCFFD1CFCDFFD4D2D1FFD6D4D3FFD8D6D6FFD9D7D6FFDAD9D7FFDCDAD9FFDDDB
      DAFFDEDCDBFFDEDDDCFFDFDDDCFFDFDDDCFFE1DFDEFFE5E3E2FFE5E5E5FFE8E7
      E7FFE7E5E5FFE6E5E4FF7F7975FF000000000000000000000000000000005B5B
      5BABDFDFDFFFE0DBD6FED0C0B0FFD5C6B8FFD3C4B6FED3C4B4FFCBBBACFFD4C9
      BEFFD2C7BDFEC9B8A8FFD2C7BDFED5C9BEFFD5C9BEFFD3C7BDFED4C8BDFFD9D0
      C7FF6B6B6BAB0000000000000000000000000000000000000000000000000000
      000000000000000000000306074855A5CFF297DBFFFF92D4F8FF8FD3F7FF8ED3
      F6FF8BD1F4FF85CBF0FF76BFE5FF5EB0DBFF2D90C7FF01141FB1010101230000
      0000000000000000000000000000000000000000000000000000000000000418
      036439875AF058A6D2FF60B1E0FF6ABEDBFF5AB2D3FF3796C5FF2780B6FFA2BC
      F4FFD8E2FFFFD4E1FDFFD5E1FDFFD0DEFDFFCBD9FDFFC9D8FAFFC9D8F6FFB0C8
      FFFF131B34AD0101010C0000000000000000000000005B5450F2D9D7D6FFD9D7
      D6FFD9D7D6FFD9D7D6FFDCDAD9FFDEDCDBFFDCDBDAFFD7D5D3FFD6D4D3FFD7D5
      D4FFD8D6D5FFD8D7D5FFD9D7D6FFDAD8D7FFDAD8D7FFE0DEDDFFE6E6E5FFE9E8
      E8FFE8E7E6FFE7E7E6FF827D79FF000000000000000000000000000000005D5D
      5DABDFDFDFFEE0DBD7FEE1D7CCFEEAE3DAFEEAE3DAFEE6DED5FED8CFC7FEEAEA
      EAFEEAEAEAFED4C9C0FECDCBC4FEB5B0A4FEB5B0A4FEB5B0A4FED3D1CBFED8CF
      C7FE6B6B6BAB0000000000000000000000000000000000000000000000000000
      000000000000010101051E445AB09ADEFFFF98D8FCFF98D8FDFF98D8FDFF96D8
      FCFF94D5FAFF90D3F7FF8AD0F3FF7BC3E9FF60B6E3FF246588EF0102025C0000
      0000000000000000000000000000000000000000000000000000000000000102
      021F37779AE391D7FEFF8ED3F5FF8BD1F4FF84CBEFFF74C1E4FF4890D0FF9FB4
      F4FFE5EDFFFFE2EAFEFFE3EBFEFFDDE7FEFFD3DFFDFFC9D9FDFFCEDCF9FFB4CA
      FFFF0D13299F010101040000000000000000000000005E5652F2DEDCDCFFE1DF
      DEFFE3E2E0FFE4E2E1FFE2E1E0FFE0DFDEFFDFDDDDFFDFDEDDFFD8D6D4FFD1CF
      CEFFD2D0CFFFD3D1D0FFD4D2D1FFD4D2D1FFD4D2D1FFD6D4D2FFE1E0DEFFEBEB
      EAFFEBEAE9FFEAE9E8FF85817CFF000000000000000000000000000000005E5E
      5EABE2E2E2FFE1DCD7FEDFD5CAFFE8E1D8FFE6DFD6FEE4DCD3FFD7CDC4FFE8E6
      E4FFE6E4E2FED4C8BCFFE1DFDCFEDFDCD8FFDFDCD8FFDDDAD6FEE4E1DEFFDAD1
      C9FF6B6B6BAB0000000000000000000000000000000000000000000000000000
      0000000000000102031B5897BEE8A7E3FFFFA5DFFFFFAAE1FFFFAAE0FFFFA5DF
      FFFF9DDCFFFF97D8FDFF91D5F8FF8CD1F4FF7BC7EEFF479CCBFF03080C810000
      0000000000000000000000000000000000000000000000000000000000000716
      288591D8FFFF9BDBFDFF97D8FCFF96D8FCFF93D6F9FF90D6F6FF6AB2DFFF7B94
      E6FFF3F8FFFFF0F5FFFFF1F5FFFFE8EEFEFFDBE6FEFFCBDAFDFFD8E7FEFF91A5
      F5FF0202085D00000000000000000000000000000000605A56F3E2E0E0FFE4E3
      E2FFE6E4E4FFE8E7E7FFEAE9E8FFEBEBEAFFECEBEAFFE8E7E6FFE4E3E2FFDEDC
      DBFFCFCECDFFCDCBC9FFCECCCBFFCFCDCCFFCFCDCCFFD0CDCCFFD0CECDFFE1DF
      DEFFEDECECFFECEBEAFF898380FF000000000000000000000000000000005F5F
      5FABE3E3E3FFEAE9E9FEDED7D1FFDED6CFFFDBD4CDFEDED6CFFFDED6CFFFDED6
      CFFFDBD4CDFEDED6CFFFDBD4CDFEDED6CFFFDED6CFFFDBD4CDFEDED6D0FFE9E8
      E6FF6B6B6BAB0000000000000000000000000000000000000000000000000000
      000000000000020405266DAED8F2B7E8FFFFBAE6FFFFC0E8FFFFC1E7FFFFBBE6
      FFFFAFE2FFFFA1DDFFFF97D9FCFF91D4F7FF8AD2F5FF5AADDCFF040A0F820000
      0000000000000000000000000000000000000000000000000000010101011F4A
      72BDA8E4FFFFA9E0FFFFAEE1FFFFA8DFFFFF9EDBFEFF95D6FBFF8DD6F2FF5483
      D7FFB8BBF7FFFFFFFFFFFDFEFFFFEDF2FEFFDEE9FFFFDAEBFFFFC2D4FFFF181D
      4CB40101010D00000000000000000000000000000000635D59F4E5E4E3FFE7E6
      E5FFEAE9E8FFECEAEAFFEDEDECFFEFEEEEFFF0EFEFFFF1F1F0FFF2F1F1FFEFEF
      EEFFE9E8E8FFD6D4D3FFC9C6C4FFCAC7C6FFCBC8C7FFCBC9C7FFCBC9C8FFCCCA
      C8FFDAD9D7FFEDECECFF8A8682FF000000000000000000000000000000005E5F
      61ABE2E2E2FEEAEAEAFEEAEAEAFEEAEAEAFEBC9C5AFEB8964FFEE0D8C9FED1C0
      9BFEB8964FFECAB588FEE6E3DDFEB8964FFEB9964FFEE5E3DEFEE8E8E8FEEAEA
      EAFE696969AB0000000000000000000000000000000000000000000000000000
      000000000000010202114D82A7D8CCEFFFFFCEECFFFFD6F1FFFFD7F0FFFFCEED
      FFFFBFE8FFFFAFE2FFFF9EDBFEFF94D6FAFF93DAFDFF519AC7F70104065D0000
      0000000000000000000000000000000000000000000000000000000000002652
      7CC2BEECFFFFC2E9FFFFC8EBFFFFC1E8FFFFB1E3FFFF9EDCFFFF94D7FAFF7DC8
      EAFF2D53C0F99492DAF7EEEFFDFFF0F8FFFFDEE9FFFFA5B2F6FF171B58B60101
      011C000000000000000000000000000000000000000048413BF1C3C2C2FFCBCB
      CBFFCFCFCEFFD2D2D1FFD5D4D4FFD8D7D6FFD9D9D9FFDBDADAFFDCDCDCFFDCDC
      DCFFDDDDDDFFDADADAFFBEBEBDFF8E8D8CFF8A8988FF8B8988FF8A8988FF8A89
      88FF8A8988FF959493FF6F6A66FF000000000000000000000000020508326B7A
      86CAE5E5E5FFEAEAEAFEEDEDEDFFEDEDEDFFD5BB86FED6B981FFE7E1D5FFE1D2
      B5FFD4B87FFEDECBA7FFE8E6E1FED6B981FFC8AE7CFF80807FFE787878FF6464
      64F10808083B0000000000000000000000000000000000000000000000000000
      00000000000000000000102A408BC5EAFAFFE5F8FFFFEAF7FFFFEBF8FFFFDDF3
      FFFFCBECFFFFB7E5FFFFA3DEFFFF9ADAFDFF92DDFFFF1E4663CB0101011C0000
      0000000000000000000000000000000000000000000000000000000000000D25
      3D91C5EAFCFFDEF5FFFFE2F4FFFFD7F0FFFFC2E9FFFFA9DFFFFF98D9FEFF8AD6
      FCFF0A2336B601010A470E0F458D222461AB1517519E01021A62010101080000
      00000000000000000000000000000000000000000000332A26F039302AFF3A31
      2BFF3D342FFF403832FF433B35FF463E38FF49413CFF4D443FFF504843FF534B
      46FF564E49FF59524DFF5C5550FF5F5853FF57504AFF3E352FFF39302AFF3930
      2AFF39302AFF39302AFF39302AFF00000000000000000000000002060932617D
      94D484B3D7FFD8E1E7FEEDEDEDFFEDEDEDFFEAEAEAFEEDEDEDFFEDEDEDFFEDED
      EDFFEAEAEAFEEDEDEDFFEAEAEAFEEDEDEDFFD0D0D0FF6F6F6FFE6B6B6BFF4444
      449E000000000000000000000000000000000000000000000000000000000000
      00000000000000000000010304224C7BA1D7F2FFFFFFFFFFFFFFF8FDFFFFE2F5
      FFFFCEEDFFFFBBE6FFFFACE3FFFFA4E8FFFF519CD1F701040651000000000000
      0000000000000000000000000000000000000000000000000000000000000104
      062F7DA4C5F2FDFFFFFFFCFFFFFFE5F6FFFFCAEBFFFFB2E5FFFFA5E9FFFF5799
      CDFC0102034E0000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000332A26F039302AFF3B32
      2CFF3E352FFF413833FF443C36FF473F39FF4A423DFF4D4540FF504843FF544C
      47FF574F4AFF5A524DFF5D5651FF605954FF635C57FF635C57FF48403AFF312D
      29FF36302CFF302D2CFF382F29FF000000000000000000000000000000005F67
      6DB393BEDDFE8FBEDEFEEAEAEAFEEAEAEAFEEAEAEAFEEAEAEAFEEAEAEAFEEAEA
      EAFEEAEAEAFEEAEAEAFEEAEAEAFEEAEAEAFEC8C8C8FE5D5D5DFEBDBDBDFE5555
      559D000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000001060A37426F98D3D7ECF9FFF5FFFFFFEAFC
      FFFFD7F5FFFFC2EEFFFF9ADDFFFF4182B8EA01060A5C00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000040D176290A9C2F4F3FAFDFFEAFFFFFFD1F5FFFFB2E9FFFF65A0CBF80409
      0F74000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000002B2724B55C5550FF5E56
      51FF67605BFF6E6864FF77706CFF7E7875FF837F7BFF898481FF8E8986FF928D
      8AFF948F8CFF96918DFF948F8CFF938E8BFF908B88FF8E8985FF8A8581FF716B
      67FF5C5651FF524B47FF373330C3000000000000000000000000000000006767
      67ABBDD2E1FFAACCE4FEA8CDE7FFEDEDEDFFEBEBEBFEEDEDEDFFEDEDEDFFEDED
      EDFFEBEBEBFEEDEDEDFFEBEBEBFEEDEDEDFFCCCCCCFFBCBCBCFEE2E2E2FF5656
      569D000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000102031A06192E782E577DC26496
      C2EB5F95C4EC2E5F8DCD06192B880102032B0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000002060941233447AA5E7993E1547591E01C2E42AC020407490000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000010101070101
      0108010101080101010801010108010101080101010801010108010101080101
      0108010101080101010801010108010101080101010801010108010101080101
      0108010101080101010700000000000000000000000000000000000000003A3A
      3A7FD7D7D7F6D8DCDEFA96C0DEFAD6D7D8F7D9D9D9F7D9D9D9F7D9D9D9F7D9D9
      D9F7D9D9D9F7D9D9D9F7D9D9D9F7D9D9D9F7D9D9D9F7D9D9D9F7D5D5D5F62D2D
      2D70000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000005090C3604090C36000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000060000000480000000100010000000000600300000000000000000000
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
      000000000000}
  end
  object ImageList16x16: TImageList
    ColorDepth = cd32Bit
    Left = 592
    Top = 216
    Bitmap = {
      494C010130009800800310001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      000000000000360000002800000040000000D0000000010020000000000000D0
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
      0034020202730000003400000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000001011116F505452F6525654FF525654FF5256
      54FF525654FF525654FF505452F61011116F0000000000000000000000000000
      00000001052D061758AF0A2592E30B2CB3FF082AB2FF041F8CE3011154AF0001
      052D000000000000000000000000000000000000000000000000010101301A1A
      1A91ECECECFF1A1A1A9101010130000000000000000000000000000000000000
      00000000000000000000000000000000000000000001000000060000000C0000
      0013000000180000001A0000001A0000001A0000001A0000001A0000001A0000
      0018000000130000000C00000006000000010000000000000000000000000000
      0000000000000000000000000000515553F6F8F9F8FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFF8F9F8FF515553F60000000000000000000000000919
      5AAF1234BCFF062ABEFF0026BDFF0025BDFF0025BCFF0025BCFF0126B8FF0225
      B0FF001152AF000000000000000000000000000000000101012F1B1B1B8DECEC
      ECFFEBEBEBFFECECECFF1B1B1B8D0101012F0000000000000000000000000000
      000000000000000000000000000000000000000000020000000B000000180000
      00250000002F00000033000000330000003300000033301800A6140A00740000
      003000000025000000180000000B000000020000000000000000000000000000
      0000000000000016307B0058C3F8595D5BFFFFFFFFFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFFFFFFFFF595D5BFF0000000000000008152F9BE30F32
      C0FF0025BFFF0024BBFF0020A2FF001D95FF001D95FF001D95FF001D95FF0020
      A3FF0125B5FF001C8BE3000000080000000000000000030303500505056B0505
      056BEAEAEAFF0505056B0505056B030303500000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000643403CC643403CC0F07
      005C000000000000000000000000000000000000000000000000000000000000
      0000000000000058C3F86BC1FDFF5F6361FFFFFFFFFF969A99FF858A88FF969A
      99FFECEEEEFFECEEEEFFFFFFFFFF5F6361FF000000000D1D5EAF1235C3FF0025
      BFFF0024BAFFADB9E8FFC5CEF3FFE3E7F9FFE1E6F9FFADBAEDFFA6B2DFFF001D
      95FF0024B8FF0125B5FF001152AF000000000000000000000000000000000202
      0273E8E8E8FF0202027300000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000683707CCFFB913FF6837
      07CC150B015C0000000000000000000000000000000000000000000000002021
      208B616563FC005BCEFF7DCAFFFF656967FFFFFFFFFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFFFFFFFFF656967FF010208342042C7FF0025C1FF0024
      BBFF0D2FBAFFE9EDFAFF90A2E7FFE6EAFAFFE4E8F9FF8FA1E7FFE0E5F9FF0C29
      9BFF0022AEFF0024BBFF0225B0FF000107340101012505050564070707730505
      0575E6E6E6FF0505057507070773070707730707077307070773070707730707
      0773070707730707077305050564010101250000000000000000000000000000
      000000000000000000000000000000000000000000006D3C0ACCFFB80FFFFFBB
      1AFF6D3C0ACC160C025C0000000000000000000000000000000000000000686C
      6AFCF6F7F7FF005BCEFF7DCAFFFF6B6F6DFFFFFFFFFF818584FF7C8180FF5256
      54FF525654FF6B6F6DFFFFFFFFFF6B6F6DFF11236CBA0E33C6FF0025BEFF0024
      B8FF3A56C4FFECEFFBFF91A2E8FFE8ECFAFFE7EBFAFF90A1E7FFE3E7F9FF374E
      AEFF0021A7FF0024B8FF0126B8FF01145FBA0A0A0A60929292D5EBEBEBFFEAEA
      EAFFE6E6E6FFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEA
      EAFFEAEAEAFFEBEBEBFF929292D50A0A0A603F25089971410ECC3F2508990000
      00003F25089971410ECC71410ECC71410ECC71410ECC71410ECCF7B422FFF5AB
      0DFFF7B92DFF71410ECC170D025C00000000000000001516156E696C6BF56F74
      72FFFFFFFFFF005BCEFF7DCAFFFF717674FFFFFFFFFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFFFFFFFFF717674FF233DA3E40228C3FF0025BDFF0023
      B6FF687DD1FFEFF1FCFF92A3E8FFEBEEFBFFE9EDFAFF90A2E7FFE6EAFAFF6275
      C1FF0020A3FF0023B6FF0025BCFF04208CE41010106CF1F1F1FFECECECFFECEC
      ECFFECECECFFECECECFFECECECFFECECECFFECECECFFECECECFFECECECFFECEC
      ECFFECECECFFECECECFFF1F1F1FF1010106C764611CCF8CE82FF764611CC0000
      0000764611CCF1C064FFE8B048FFE7AE44FFE6AD42FFE6AB40FFE3A433FFE19E
      28FFE19E28FFEAB348FF764611CC180E035C000000006F7270F5F5F6F5FF767B
      79FFFFFFFFFF005BCEFF7DCAFFFF777C7AFFFFFFFFFFB1B7B4FFB6BDBAFFB6BD
      BAFFA7AEAAFF5D615FFFFFFFFFFF777C7AFF3050CFFF0026C3FF0025BCFF0023
      B6FF8899DBFFF2F4FCFF92A3E8FFEEF1FBFFECEFFBFF91A2E8FFE8ECFAFF8291
      CEFF001F9DFF0023B6FF0025BCFF082AB2FF1212126AF9F9F9FFF6F6F6FFF6F6
      F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6
      F6FFF6F6F6FFF6F6F6FFF9F9F9FF1212126A7C4B15CCF5C87BFF7C4B15CC0000
      00007C4B15CCF4C477FFEAAE5FFFE1A452FFD89B48FFD39643FFD09340FFD093
      40FFD39643FFD89B48FFECBB6BFF7C4B15CC000000007B817EFFFFFFFFFF7D83
      81FFFFFFFFFF005BCEFF7DCAFFFF7D8788FFF9FAFAFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFF9FAFAFF777C7AF63352D1FF0026C3FF0025BDFF0023
      B6FFB8C2EAFFF4F6FDFF93A4E8FFF1F3FCFFEFF1FCFF92A3E8FFEBEEFBFFAFB9
      E1FF001E9CFF0023B6FF0025BDFF0B2CB3FF0E0E0E5BA0A0A0D4FEFEFEFFFEFE
      FEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFF68A6
      64FF368632FF68A664FFA0A0A0D40E0E0E5B815119CCFAD68AFF815119CC0000
      0000815119CCF9D185FFF5C77AFFF5C679FFF5C578FFF4C477FFF2BC6FFFEFB4
      67FFEFB467FFF7CD81FF815119CC1A10055C00000000838886FFFFFFFFFF858A
      88FFFFFFFFFF005BCEFF7DCAFFFF5DA0CBFF848D8EFF848987FF848987FF8489
      87FF848987FF848987FF7D8280F6191A1A6F2943A9E40229C6FF0025BEFF0024
      B8FF91A2E7FF94A5E8FF94A5E8FF93A4E8FF93A4E8FF92A3E8FF92A3E8FF8E9F
      E6FF001D95FF0024B8FF0026BDFF0B2592E4020202220F0F0F5A141414671111
      1166FFFFFFFF1111116614141467141414671414146714141467141414671065
      09E12ADF19FF106509E10F0F0F5A020202224A2F109986561DCC4A2F10990000
      00004A2F109986561DCC86561DCC86561DCC86561DCC86561DCCF8CC80FFF4BE
      71FFFBD78BFF86561DCC1A11055C0000000000000000858A88FFFFFFFFFF858A
      88FFFFFFFFFF0661D0FF6BC1FDFF7DCAFFFF7DCAFFFF7DCAFFFF7DCAFFFF7DCA
      FFFF6BC1FDFF0058C3F8000000000000000017286FBA1338CBFF0025C1FF0024
      BBFFDCE1F5FFFAFAFEFFF8F9FDFFF6F7FDFFF4F6FDFFF2F4FCFFF1F3FCFFD1D7
      EFFF001FA1FF0024BBFF062ABEFF061964BA0000000000000000000000000B0B
      0B66FFFFFFFF0B0B0B660000000000000000000000000F310B99085900CC0859
      00CC3CE22BFF085900CC085900CC043200990000000000000000000000000000
      000000000000000000000000000000000000000000008B5A20CCFCD589FFFEDF
      93FF8B5A20CC1C12065C000000000000000000000000858A88FFFFFFFFFF858A
      88FFFFFFFFFF7BAAE0FF0661D0FF005BCEFF005BCEFF005BCEFF005BCEFF005B
      CEFF0058C3F80016307B0000000000000000020309353151D3FF0026C4FF0025
      BFFF5F76D4FFFCFDFEFFFBFBFEFFF9FAFEFFF7F8FDFFF5F7FDFFF3F5FDFF5A71
      D0FF0024BAFF0025BFFF1234BCFF000208350000000000000000030303445555
      55B3FFFFFFFF555555B30303034400000000000000000A5E00CC51E740FF51E7
      40FF51E740FF51E740FF51E740FF0A5E00CC0000000000000000000000000000
      000000000000000000000000000000000000000000008F5E23CCFFE498FF8F5E
      23CC1C13075C00000000000000000000000000000000858A88FFFFFFFFFF878C
      8AFFF7F8F8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F8F8FF8287
      85FC0000000000000000000000000000000000000000152563AF1F42CFFF0026
      C3FF0025BFFF0024BBFFEDEFFBFF1938B3FF1934A0FFE8EBF6FF0020A2FF0024
      BBFF0025BFFF0F32C0FF09195AAF00000000000000000000000007070761FFFF
      FFFFFFFFFFFFFFFFFFFF070707610000000000000000063800990B6400CC0B64
      00CC65EB54FF0B6400CC0B6400CC063800990000000000000000000000000000
      00000000000000000000000000000000000000000000926226CC926226CC1D14
      075C0000000000000000000000000000000000000000858A88FFFFFFFFFFB7BB
      BAFF878C8AFF858A88FF858A88FF858A88FF858A88FF858A88FF828785FC292A
      2A8B0000000000000000000000000000000000000000000000082842A8E31F42
      CFFF0026C4FF0025C1FF5F77D6FFEEF0FBFFECF0FAFF5D75D5FF0025BEFF0025
      C1FF1235C3FF152F9BE3000000080000000000000000000000000808084E6868
      68B7FFFFFFFF686868B70808084E000000000000000000000000000000000C69
      00CC74EE63FF0C6900CC00000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000543816991E14085C0000
      000000000000000000000000000000000000000000007E8281F5F6F6F6FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6F6F6FF7E8281F5000000000000
      0000000000000000000000000000000000000000000000000000000000001525
      63AF3151D3FF1338CBFF0229C6FF0026C3FF0026C3FF0228C3FF0E33C6FF2042
      C7FF0D1D5EAF00000000000000000000000000000000000000000000000D0B0B
      0B4E111111610B0B0B4E0000000D00000000000000000000000000000000073C
      00990D6C00CC073C009900000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000191A196E7E8281F5858A
      88FF858A88FF858A88FF858A88FF858A88FF7E8281F5191A196E000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000102062E152463AF273FA6E33352D1FF3050CFFF203BA2E310205FAF0001
      062E000000000000000000000000000000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000000000000000000006464
      64FF646464FF646464FF646464FF646464FF646464FF646464FF646464FF6464
      64FF6C6C6DFF0000000000000000000000000000000000000000000000000000
      000000000000646464FF646464FF646464FF646464FF646464FF646464FF0000
      000000000000000000000000000000000000000000000000000000000000170A
      0653AD482FDEE5603EFFE5603EFFE5603EFFE5603EFFE5603EFFAD482FDE170A
      065300000000000000000000000000000000000000000000000000000000170A
      0653AD482FDEE5603EFFE5603EFFE5603EFFE5603EFFE5603EFFAD482FDE170A
      0653000000000000000000000000000000000000000000000000000000006D6D
      6DFF7C7CDDFF6D6DD9FF4545CEFF0707BEFF0000B5FF0000BBFF1414C2FF0505
      B4FF6C6C6DFF0000000000000000000000000000000000000000000000000000
      0000000000005E5E69FF0000B3FF0000ADFF0000ADFF0000A7FF646464FF0000
      0000000000000000000000000000000000000000000000000000000000009F41
      27DEF0C1B7FFFAEBEBFFFAEBEBFFFEF6F6FFFAEBEBFFFAEBEBFFEFC0B6FF9F41
      27DE000000000000000000000000000000000000000000000000000000009F41
      27DEE7C3B9FFE9E9E9FFE8E8E8FFE8E8E8FFE8E8E8FFE9E9E9FFE7C3B9FF9F41
      27DE000000000000000000000000000000000000000000000000000000006464
      64FF646464FF414180FF292991FF3434CAFF0505BAFF292991FF414180FF6464
      64FF6D6D6DFF0000000000000000000000000000000000000000000000000000
      0000000000005E5E69FF0707BEFF0000BCFF0000BCFF0000B2FF646464FF0000
      000000000000000000000000000000000000000000000000000000000000BE4B
      29FFF3EAEAFFF1E5E5FFF1E5E5FFBE4B29FFF1E5E5FFF1E5E5FFF1E5E5FFBE4B
      29FF00000000000000000000000000000000000000000000000000000000BE4B
      29FFECECECFFE4E4E4FFE4E4E4FFE4E4E4FFE4E4E4FFE4E4E4FFECECECFFBE4B
      29FF000000000000000000000000000000000000000000000000000000000000
      000000000000000000005E5E6CFF0707B1FF0A0AA4FF5C5C6BFF000000000000
      0000000000000000000000000000000000000000000000000000000000006060
      6AFF60606AFF434392FF0C0CBFFF0000BCFF0000BCFF0000B6FF3A3A80FF6464
      64FF66668EFF000000000000000000000000000000000000000000000000AF44
      22FFF0EDEDFFF4EFEFFFF4EFEFFFAF4422FFF4EFEFFFF4EFEFFFE6DFDFFFAF44
      22FF00000000000000000000000000000000000000000000000000000000AF44
      22FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFAF44
      22FF000000000000000000000000000000000000000000000000000000000000
      0000000000005D5D71FF2C2C90FF0000B7FF0000B0FF303083FF585870FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      00005A5A74FF68689CFF3939CBFF0C0CBFFF0303BDFF0000BCFF34348CFF5B5B
      7DFF00000000000000000000000000000000000000000000000000000000AB45
      23FFF4F4F4FFAB4523FFAB4523FFAB4523FFAB4523FFAB4523FFDFDADAFFAB45
      23FF00000000000000000000000000000000000000000000000000000000AB45
      23FFFCFCFCFFAB4523FFAB4523FFAB4523FFAB4523FFAB4523FFFCFCFCFFAB45
      23FF000000000000000000000000000000000000000000000000000000000000
      00005E5E80FF34348CFF0000BBFF0000BBFF0000B9FF0000AFFF37377EFF5959
      7BFF000000000000000000000000000000000000000000000000000000000000
      0000000000006E6E79FF6B6BA6FF3535CAFF1212C1FF303096FF5A5A74FF0000
      000000000000000000000000000000000000000000000000000000000000B551
      2FFFF7F7F7FFF2F2F2FFE7E6E6FFB5512FFFD1D0D0FFD1D0D0FFDAD8D8FFB551
      2FFF00000000000000000000000000000000000000000000000000000000B551
      2FFFFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFB551
      2FFF000000000000000000000000000000000000000000000000000000007C7C
      99FF63636AFF575797FF1C1CC4FF0000BCFF0000BCFF0000B9FF343488FF5E5E
      68FF646496FF0000000000000000000000000000000000000000000000000000
      0000000000000000000065656EFF4949C6FF1010B8FF5D5D6BFF000000000000
      000000000000000000000000000000000000000000000000000000000000C863
      41FFFCFCFCFFF8F8F8FFF8F8F8FFC86341FFEEEEEEFFE6E6E6FFEBEBEBFFC863
      41FF00000000000000000000000000000000000000000000000000000000C863
      41FFFCFCFCFFFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFFCFCFCFFC863
      41FF000000000000000000000000000000000000000000000000000000000000
      00000000000065656BFF2D2DC8FF0202BDFF0000BCFF0000B9FF5E5E69FF0000
      0000000000000000000000000000000000000000000000000000000000006464
      64FF646464FF5A5A74FF6B6BA6FF1313C1FF0505B4FF303096FF5A5A74FF6464
      64FF646464FF000000000000000000000000000000000000000000000000A75A
      41DEF6D9CFFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFF6D9CFFFA75A
      41DE00000000000000000000000000000000000000000000000000000000A75A
      41DEF6D9CFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6D9CFFFA75A
      41DE000000000000000000000000000000000000000000000000000000000000
      00000000000065656BFF5D5DD5FF4141CDFF3F3FCDFF1E1EC4FF5E5E69FF0000
      0000000000000000000000000000000000000000000000000000000000006464
      64FF0000B6FF0000B2FF0000BBFF2020C5FF0000BBFF0000ADFF0000A1FF0000
      9CFF646464FF000000000000000000000000000000000000000000000000180D
      0A53B2654BDEEC8663FFEC8663FFEC8663FFEC8663FFEC8663FFB2654BDE180D
      0A5300000000000000000000000000000000000000000000000000000000180D
      0A53B2654BDEEC8663FFEC8663FFEC8663FFEC8663FFEC8663FFB2654BDE180D
      0A53000000000000000000000000000000000000000000000000000000000000
      000000000000646464FF646464FF646464FF646464FF646464FF646464FF0000
      0000000000000000000000000000000000000000000000000000000000006464
      64FF646464FF646464FF646464FF646464FF646464FF646464FF646464FF6464
      64FF646464FF0000000000000000000000000000000000000000000000000000
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
      0000000000010000000200000003000000040000000400000004000000040000
      0003000000020000000100000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000111111821818189A151515981515159815151598000000000000
      00000000000000000000000000000000000000000000010101181B1B1B693232
      328E434343A44B534FB6486E5BCA5B5B5BBF5B5B5BBF5B5B5BBF585858BC5252
      52B5474747A939393997242424780707073500000000000000009A9A9AFF9999
      99FF989898FF979797FF969696FF959595FF949494FF949494FF939393FF9292
      92FF919191FF919191FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000006D6D6DFF424242E22D2D2DD82B2B2BD82F2F2FE3010101260303
      0340000000000000000000000000000000000000000000000000111212518D8D
      8DDF969696E6989A99E938C481FE58A381EC9C9C9CEB9C9C9CEB9B9C9CEA999A
      9AE9979898E7939393E44141419A0000000100000000000000009C9C9CFFDDDD
      DDFFDBDBDBFFD9D9D9FFD8D8D8FFD6D6D6FFD4D4D4FFD2D2D2FFD1D1D1FFCFCF
      CFFFCDCDCDFF919191FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000002200000033000000330000
      0033000000000000000000000000000000000000000000000000000000000000
      000000000000616161FF01010128000000000000000004040448010101282525
      25C80000000000000000000000000000000000000000000000063A6652B850C7
      92FF36C988FF2BC983FF26CA81FF24CA80FF55C594FFBAC0BDFFB9BABAFFBBBC
      BCFFBBBCBCFFBEBEBEFFB5B6B6F90000000000000000686868FF7C7C7CFFC8C8
      C8FFC6C6C6FFC5C5C5FFC3C3C3FFC2C2C2FFC0C0C0FFBFBFBFFFBDBDBDFFBCBC
      BCFFBBBBBBFF767676FF646464FF0000000000000023000000330000002F0000
      000000000000000000000000000000000021184A67BD3094CDFF2F93CDFF3091
      C9FD000000330000001D00000000000000000000000000000000000000000000
      000000000000616161FF01010128000000000000000004040448010101282525
      25C8000000000000000000000000000000000000000A157F52C921CE85FF21CE
      85FF25D088FF24CF87FF21CE85FF21CE85FF23CF86FF8CD3B2FFD6D2CDFFD8D4
      D0FFD8D4D1FFC6C7C7FFBCBCBCFB00000000696969FFA0A0A0FF7D7D7DFF7C7C
      7CFF7B7B7BFF7B7B7BFF7B7B7BFF7A7A7AFF797979FF797979FF787878FF7777
      77FF777777FF777777FF939393FF646464FF1A4E6CC13094CDFF297FB0EE0000
      002D000000000000000000000021174562B92E92CCFF319ED7FF7AD4F7FF3AB3
      E9FF339AD2FF12384DA900000033000000330000000000000000000000000000
      000000000000616161FF010101280C0C0C720000000004040448010101282525
      25C80000000000000000000000000000000006281A711ED289FF33D394FF83CE
      B1FF9DCAB9FFA5D8C3FF24D28CFF29D38FFF83CEA8FFD9D8D4FFD5CDC6FFDCD9
      D6FFD8D2CCFFCBCBCBFFBFBFBFFB00000000696969FFA1A1A1FFA1A1A1FF9F9F
      9FFF9F9F9FFF9D9D9DFF9C9C9CFF9B9B9BFF9A9A9AFF999999FF989898FF9797
      97FF969696FF959595FF949494FF646464FF3094CDFF4DC4F4FF41B1E4FF2777
      A5E90000002B0000001F174560B8339BD4FF80D0F4FF359FD7FF339ED6FF48BE
      EFFF45BBEDFF39A5DBFF2D91CBFF2E91CCFF0000000000000000000000000000
      000000000000616161FF010101280D0D0D780000000004040448010101282525
      25C8000000000000000000000000000000000C583AA41ED58EFF689584D9C8C9
      C9FFC9C9C9FF9FE0C7FF48D69EFFC4DDC9FFDBD0C4FFDFDBD8FFD7CFC8FFDFDB
      D8FFDAD4CEFFCFCFCFFFC2C3C3FB000000006A6A6AFFB8B8B8FFB6B6B6FFB5B5
      B5FFB4B4B4FFB2B2B2FFB1B1B1FFAFAFAFFFAEAEAEFFADADADFFABABABFFAAAA
      AAFFA9A9A9FFA8A8A8FFA6A6A6FF646464FF1B5374C047B3E6FF57C6F4FF47B2
      E5FF226C99E1123B53AD2F95CEFF38A2DAFF8AD8F8FF51C2F1FF51C1F0FF4FC0
      EFFF67C8F3FF63C8F2FF52C3F2FF54C4F2FF0000000000000000000000000000
      000000000000616161FF010101280D0D0D780000000004040448010101282525
      25C800000000000000000000000000000000083826821BD790FF536F64BBCBCB
      CBFFD2D3D3FFBCDCC9FFDCDAD3FFE5DCD1FFDBD0C5FFE1DDDAFFD9D1CAFFE1DD
      DAFFDCD6D0FFD1D2D2FFC5C5C5FB000000006B6B6BFFD6D6D6FFD4D4D4FFD2D2
      D2FFD1D1D1FFCFCFCFFFCDCDCDFFCCCCCCFFCACACAFFC8C8C8FFC6C6C6FF7A7A
      7AFFC3C3C3FF797979FFC0C0C0FF656565FF000000002676A4E54EB5E6FF62CB
      F5FF4EB5E5FF43A9DEFF96DFFBFF3CA2D9FF389FD6FF5BC5F1FF59C3F0FF73CB
      F2FF7BCFF3FF73CCF2FF65C8F1FF5BC4F0FF0000000000000000000000000000
      000000000000616161FF010101280D0D0D780000000004040448010101282525
      25C800000000000000000000000000000000000100141BA876DF85CBB1FBCDCD
      CDFFDDDDDDFFDFD5CAFFE0DAD4FFE2D8CCFFD9CEC1FFE0DBD6FFD8CFC7FFE0DB
      D6FFDCD5CFFFD4D4D4FFC7C7C7FB000000006B6B6BFFD8D8D8FFD7D7D7FFD5D5
      D5FFD3D3D3FFD2D2D2FFD0D0D0FFCECECEFFCDCDCDFFCBCBCBFFC9C9C9FFC7C7
      C7FFC6C6C6FFC4C4C4FFC2C2C2FF666666FF00000000000000002572A0E256B8
      E6FF6FD0F8FF41A6D9FF3EA3D9FF9BDEFAFF66CAF4FF63C8F2FF82D1F4FF8BD5
      F5FF82D1F4FF79CFF4FF72CCF3FF69C9F2FF0000000000000000000000000000
      000000000000616161FF010101280D0D0D780000000004040448010101282525
      25C800000000000000000000000000000000000000000001001768887CCDCFCF
      CFFFE6E6E6FFE2DCD4FFE1DBD5FFE2D8CCFFDACEC2FFE2DDD8FFDAD0C8FFE2DD
      D8FFDDD6D0FFD6D6D6FFC8C8C8FB000000006B6B6BFFDADADAFF838383FF8282
      82FF818181FF818181FF818181FF808080FF7E7E7EFF7E7E7EFF7D7D7DFF7C7C
      7CFF7B7B7BFF7B7B7BFFC5C5C5FF666666FF0000000000000000000000002D91
      CCFF298EC9FF7BD5F9FF44A5DAFF3DA2D7FF6ECDF4FF8FD6F5FF9BDBF6FF91D7
      F6FF8BD5F5FF83D2F5FF7BD0F4FF73CDF3FF0000000000000000000000000000
      0000000000006D6D6DFF01010128111111880000000006060654010101252525
      25C80000000000000000000000000000000000000000000000005151519FD2D2
      D2FFECECECFFE6E0D3FFE5E1DAFFE2DBD2FFDBD0C2FFDED6CAFFDDD5CBFFDDD5
      C9FFE4E0DCFFD7D7D7FFCACACAFB00000000000000006B6B6BFFBDBDBDFFA7A7
      A7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF9E9E9EFFAFAFAFFF676767FF000000000000000000000000000000002F93
      CDFF8EE0FFFF278DC9FF86D9FBFF7ED4F8FFA0DEF9FFAEE2F9FFA4DFF9FF9CDC
      F8FF95DAF8FF8FD7F7FF88D4F7FF80D1F5FF0000000000000000000000000000
      000000000000767676FF01010128383838F3181818A42F2F2FE2000000022525
      25C80000000000000000000000000000000000000000000000005151519FD5D5
      D5FFE5E5E5FFEBEBEBFFECECECFFE6E0D4FFDCCCACFFDBCBA9FFE3D9C6FFBDAD
      8DFF969696FFCDCDCDFFCCCCCCFB000000000000000000000000BFBFBFFFA8A8
      A8FFFFFFFFFFF5F5F5FFF2F2F2FFF0F0F0FFEFEFEFFFEDEDEDFFEBEBEBFFFFFF
      FFFF9F9F9FFFB2B2B2FF00000000000000000000000000000000000000002A83
      B5EF2F93CDFF2C91CCFF4FACDDFF8BD9FBFF96DCFAFF92DBFAFF90DAFAFF8EDA
      FAFF8ED9FAFF8BD7F8FF88D6F8FF84D3F7FF0000000000000000000000000000
      000000000000888888FF02020238000000000000000000000000000000002C2C
      2CD90000000000000000000000000000000000000000000000005252529FD4D4
      D4FFD4D4D4FFD4D4D4FFEAEAEAFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFBBBB
      BBFFB9B9B9FFD4D4D4FFCCCCCCFA000000000000000000000000C0C0C0FFAAAA
      AAFFFFFFFFFFF7F7F7FFF5F5F5FFF3F3F3FFF2F2F2FFF0F0F0FFEEEEEEFFFFFF
      FFFFA1A1A1FFB4B4B4FF00000000000000000000000000000000000000000000
      00000000000000000000143F59A82B91CCFF2990CBFF298FCBFF298FCBFF2990
      CBFF298FCBFF288ECAFF4CAADBFF83D3F7FF0000000000000000000000000000
      000000000000888888F9212121A70000000000000000000000000505054C3C3C
      3CFF00000000000000000000000000000000000000000000000022222267D6D6
      D6FDD9D9D9FFD9D9D9FFD9D9D9FFD9D9D9FFD9D9D9FFD9D9D9FFD9D9D9FFD9D9
      D9FFD9D9D9FFD9D9D9FF787878BE00000000000000000000000000000008ABAB
      ABFFFFFFFFFFF9F9F9FFF7F7F7FFF6F6F6FFF5F5F5FFF2F2F2FFF0F0F0FFFFFF
      FFFFA3A3A3FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000512195B389BD2FF0000000000000000000000000000
      0000000000000000000004040443505050DD646464FF4F4F4FEE080808610000
      0007000000000000000000000000000000000000000000000000000000000000
      0005000000080000000800000008000000080000000800000008000000080000
      000800000008000000080000000000000000000000000000000000000000ACAC
      ACFFFFFFFFFFFCFCFCFFFAFAFAFFF9F9F9FFF7F7F7FFF5F5F5FFF3F3F3FFFFFF
      FFFFA4A4A4FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000F00000001000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000ADAD
      ADFFACACACFFABABABFFABABABFFABABABFFA9A9A9FFA8A8A8FFA8A8A8FFA7A7
      A7FFA6A6A6FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000001E0000
      003300000033000000330000001E0000000000000000000000220000005D0000
      00520000005000000050000000500000005000000050000000500000004E0000
      004E000000510000005D0000001B000000000000002300000033000000330000
      0033000000330000003300000033000000330000003300000033000000330000
      0033000000330000003300000033000000230000000000000000000000000000
      000000000000000000000000000000000000000000120204064A000101200000
      0000000000000000000000000000000000000000002300000033000000330000
      0033000000330000003300000033000000330000003300000033003D26A9009E
      5EFF009D5CFF009E5DFF003F26AC0000001E0000000003030495787778FF6665
      66FF676669FF6E6C6EFF727172FF767375FF7B7A7BFF797779FF716E70FF8581
      83FF9B9799FF9F9D9FFF0000007C0000000060440CC0B67D0EFFB57B09FFB57B
      09FFB57B09FFB57B09FFB57B08FFB57B08FFBB7C09FFCC7D0CFF54933DFF009F
      60FF009D5CFF009F60FF569440FF6E430BC00000000000000000000000000000
      000000000000000000000000000000000000000305734485A0F8152325780000
      00000000000000000000000000000000000062450FC0B88113FFB77E0EFFB77D
      0DFFB77D0DFFB77D0DFFB77D0DFFB97D0DFFC7800EFF50923DFF00A66AFF00BA
      86FF76DFC4FF00BA86FF00A669FF003F26AC0000000000000192E7E6E7FFF0EF
      EFFFE8E8E8FFF5F4F3FFEDEEEDFFE7E7E7FFFFFFFFFFFFFFFFFFFFFFFFFFE2E0
      E1FFF4F0F1FFFFFFFFFF0000007300000000B67D0EFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6FD2B5FF00A567FF00BA
      86FF75DFC5FF00BA87FF00A86DFF569440FF0000000000000001000000260001
      022B00000003000000000000000000000017132A3BCF60AEC0F10508073D0000
      000000000000000000000000000000000000BA851AFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF009956FF00BF8BFF00BB
      82FFFFFFFFFF00BB82FF00C08CFF009E5DFF0000000000000090DADBDAFFE8E8
      E8FFEAEAEAFF444444FFAFAFAFFFDDDDDDFF2F2F2FFF414141FF757674FFE3E3
      E3FFD8D7D8FFE5E2E3FF0000007000000000B57B09FFFFFFFFFFDDB77BFFC783
      1FFFC78422FFC78420FFE0B97CFFD4D7DFFFC3B5BDFF00964FFF00BE89FF00BB
      82FFFFFFFFFF00BB83FF00C18DFF009F60FF0000000000000009111E20B63771
      91DD0002032800000000000000000000015E4182A2FE32575CAB000000070000
      000000000000000000100001012C00000011BC871FFFFFFFFFFFC7C6C7FFFFFF
      FFFFD7C8CAFFFFFFFFFFD7C8CAFFFFFFFFFFE0CDD1FF00964FFF72E4CAFFFFFF
      FFFFFFFFFFFFFFFFFFFF76E5CCFF009C5BFF0000000000000090DEDEDEFFEFEF
      EFFFF4F4F4FF000000FF939393FFFFFFFFFF242424FF000000FF969696FFC6C7
      C7FFFEFEFEFFC0BDC0FF0000007100000000B57B09FFFFFFFFFFC7831FFFFDD8
      A7FFF6D498FFFED9A8FFCB8721FFB5B8C1FFFFFFFFFF00954DFF72E4CAFFFFFF
      FFFFFFFFFFFFFFFFFFFF75E5CCFF009C5CFF00000000000000030D1616A957A9
      CAFD03080D4A000000000000000B0A1823B766B5CAFF2D301FA00100001B0000
      0000000000020104078A3E7790EE13202276BF8B26FFFFFFFFFFC5C2C1FFD3C4
      C5FF00A36EFF00A471FF00A36EFFD8C5C7FFDDC8CCFF00974FFF00CA95FF00C8
      8FFFFFFFFFFF00C88FFF00CC98FF009D5CFF0000000000000090E6E6E6FFFEFE
      FEFFFFFFFFFF050505FF9D9D9DFFFFFFFFFFF1F1F1FF1C1C1CFF505050FFFFFF
      FFFFFFFFFFFFC3C2C3FF0000007500000000B57B09FFFFFFFFFFC78421FFFCD7
      A6FFEFC47DFFFDD8A7FFCC8924FFB6B9C3FFFFFFFFFF00944BFF00CA94FF00C7
      8EFFFFFFFFFF00C88FFF00CC99FF009E5FFF00000000000000000407078355A0
      BBFF09151E6A000000150A050072386880F365AABFFF64686DFE5E512BCC0D0A
      034E0000002E152F41E15EABBDEE06090944C28F2EFFFFFFFFFFC4C0BFFFFFFF
      FFFF00A572FF00DFB5FF00A573FFFFFFFFFFE2C6CAFF81CDA5FF00AB6CFF00D2
      9CFF72ECD3FF00D39EFF00AE71FF003721970000000000000090F1F1F1FFEAEA
      EAFFEAEAEAFF111111FFA2A2A2FFFFFFFFFFFFFFFFFFFFFFFFFF0B0B0BFF7878
      78FFFFFFFFFFD6D4D6FF0000007B00000000B57B09FFFFFFFFFFC78521FFFCD7
      A6FFEBB866FFFDD9A7FFCC8924FFB5B9C2FFFFFEFFFF57B58FFF00A966FF00D2
      9BFF72ECD2FF00D29CFF00AD71FF54913CFF00000000000000000001005D4E91
      A5FF1C3C51C63C2704D0605D44FB65B4CBFF4886BEFF4771B2FF727B73FF716A
      4FEF433618CE498296FF305359A900000008C49336FFFFFFFFFFC0BCB9FFCEBE
      BDFF00A571FF00A673FF00A571FFDFC0C2FF00A673FF00A97AFF00A066FF0096
      51FF009551FF009A59FF00321E90000000000000000000000090FFFEFFFFD8D9
      D9FF090A0BFF000000FFAFAFB0FFFFFFFFFF434343FFFFFFFFFF8C8C8DFF0C0C
      0CFFFFFFFFFFE8E8E9FF0000007F00000000B57B09FFFFFFFFFFC88420FFFDD9
      A7FFFCD8A7FFFEDAA8FFCC8822FFB3B8C0FFFFFEFFFFFFFFFFFF66C4A0FF0097
      4EFF00974FFF00964FFF6ED1B4FFCC7D0CFF00000000000000000000003B3E6F
      7CF34484A6FF50696DFF52A8DAFF6BB1BCFF638790FF5588B1FF4179C0FF4A6D
      9FFF78765EFF828665FF1619127800000000C8983EFFFFFFFFFFB9B6B4FFFFFF
      F4FFCABAB9FFFFFFF8FFCDBBBAFFFFFFFAFF00A674FF00E0B7FF00A777FFFFFF
      FDFFFFFFFFFFE7983EFF00000000000000000000000000000090FEFFFFFFFFFF
      FFFFE0E3ECFF000000FFADB1BCFFFFFFFFFF4B4F59FF0A0D17FF040812FF9BA0
      AAFFFFFFFFFFF3F4FEFF0000008000000000B57B08FFFFFFFFFFD3AB70FFC986
      21FFC98724FFCA8722FFD7AF72FFC8CCD2FFB3B4B7FFB8B5B8FFC0B7BCFFC7B9
      C0FFC8B9C0FFD9CAD2FFFFFFFFFFBB7B09FF00000000000000000000001C243F
      42D672CADEFF61B6DCFF78A59EFF4F6E91FF3874C6FF5F8494FF5B85A1FF4676
      BCFF2761D3FF26488DEC0A0A096500000000CA9B47FFFFFFFFFFB5B3B0FFB8B5
      B1FFBBB6B2FFBBB6B2FFBDB7B3FFC7B7B5FF00A672FF00A774FF00A572FFC4B3
      B3FFFFFFFFFFD29B47FF00000000000000000000000000000190FEFBF5FFFFFF
      FFFFFFFFFFFFE4E3DAFFF4F2EDFFFFFFFFFFFFFFFFFFD4D3CEFFE3E2E2FFFFFF
      FFFFFFFFFFFFF2F0EBFF0101038000000000B57A08FFFFFFFFFFE2E9F3FFE4EE
      FCFFE5EFFFFFE5EFFEFFE5EEFAFFE6ECF5FFE7EBF3FFE7ECF3FFE9ECF4FFEAEC
      F5FFEAEBF3FFE6E7EEFFFFFFFFFFB57A08FF0000000000000000000000000405
      0375535745FF2A63CCFF847E68FF3C67BDFF666B77FF4B70A9FF1E59A9E91440
      84F7478EBEFC0A13166A0000000200000000CD9F4FFFFFFFFEFFAFADAAFFFFFF
      E8FFB3AFABFFFFFFE9FFB4B0ABFFFFFFEAFFC1B0AFFFFFFFEEFFC0B0AEFFFFFF
      E7FFFFFFFDFFCE9F4FFF00000000000000000000000000020790CB950FFFE0B0
      36FFDDB44BFFDEAE33FFCC9000FFC38500FFD5A225FFDAA217FFD29400FFD19D
      19FFD89B06FFC49217FF0204098000000000B57B08FFFFFFFFFFD0A76CFFCA86
      22FFCA8725FFCA8725FFCA8724FFCA8724FFCA8723FFCA8723FFCA8723FFCA87
      23FFCA8620FFD1A76BFFFFFFFFFFB57B08FF0000000000000000000000000D07
      009152565DFF3D74CBFF878975FF3169CDFF7D7D6FFF235FD6FF163962E04181
      A1FA477D86CD000000180000000000000000D2A355FFFFFFFBFFADA9A4FFAFAB
      A5FFB0ACA6FFB0ACA6FFB0ACA6FFB1ACA6FFB3ACA7FFB3ACA7FFB2ABA6FFACA7
      A3FFFFFFFAFFD1A355FF00000000000000000000000001030990CD9718FFEAC0
      58FFDDBB69FFD9B251FFDBB551FFC17E00FFD6A938FFD8A733FFB97800FFD2A1
      28FFE2B137FFC5931CFF03050B8100000000B57B09FFFFFFFFFFC88420FFFEDA
      A8FFF3CD8AFFF3CC8AFFF3CC8AFFF3CC8AFFF3CC8AFFF3CC8AFFF3CC8AFFF3CD
      8AFFFEDAA8FFC88420FFFFFFFFFFB57B09FF0000000000000000000000182E1E
      03D34670A5FF698FA8FF6489A6FF5780ADFF6A8093FF2668CFFD5296AAEB3A67
      6DBA060A0A45000000000000000000000000E3A954FFFFFFF3FFFFFCD2FFFFFE
      D3FFFFFED3FFFFFED3FFFFFED3FFFFFED3FFFFFED3FFFFFED3FFFFFED3FFFFFC
      D2FFFFFFF3FFE3A954FF00000000000000000000000003050D98DFA314FFEAA4
      00FF88671EFFB48511FFE29F00FFD79500FFE3A816FFD79800FF795E1EFFD29E
      1BFFEBA700FFD7A21DFF06080E8700000000B57B09FFFFFFFFFFC88420FFFDD9
      A7FFFCD8A7FFFCD7A6FFFCD7A6FFFCD7A6FFFCD7A6FFFCD7A6FFFCD7A6FFFCD8
      A7FFFDD9A7FFC88420FFFFFFFFFFB57B09FF00000000000000000000004D5444
      21F83E84CEFF8AA191FF458ACDFF869A8EFF4982C4FF0E284AA80203022C0000
      000A00000000000000000000000000000000199BFFFF7CC6FFFF2A9EFFFF2B9F
      FFFF2C9FFFFF2C9FFFFF2C9FFFFF2C9FFFFF2C9FFFFF2C9FFFFF2B9FFFFF2A9E
      FFFF7CC6FFFF199BFFFF00000000000000000000000004050872A07C28FF9B6C
      00FF766C52FF8D794DFF966B00FF976F11FF986E11FF926906FF737271FF9677
      2FFF9A6D00FF9D7C2FFF0506086700000000B57B09FFFFFFFFFFC79E64FFC784
      20FFC78421FFC78421FFC78421FFC78421FFC78421FFC78421FFC78421FFC784
      21FFC78420FFC79E64FFFFFFFFFFB57B09FF00000000000000000000003E3029
      15CA596764FB799086FF4B90CBFF92A690FF2E75C8F501050A47000000000000
      0000000000000000000000000000000000001998FFFFAFDBFFFFADD9FFFFADDA
      FFFFADDAFFFFADDAFFFFADDAFFFFADDAFFFFADDAFFFFADDAFFFFADDAFFFFADD9
      FFFFAFDBFFFF1998FFFF00000000000000000000000000000000000000030000
      0000797C85E01313187B0000000000000000000000000000011C888B93EF0202
      033400000000000000060000000000000000B67D0EFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFB67D0EFF0000000000000000000000000000
      00160A07016B323223CF6B735CFC6C909BFF19487DC800000012000000000000
      00000000000000000000000000000000000073A7C9FF1696FFFF1896FFFF1996
      FFFF1996FFFF1996FFFF1996FFFF1996FFFF1996FFFF1996FFFF1996FFFF1896
      FFFF1696FFFF73A7C9FF00000000000000000000000000000000000000000000
      00006C6C6CAD0808083800000000000000000000000000000000A1A1A1CC0000
      000200000000000000000000000000000000A27315EFB67D0EFFB57B09FFB57B
      09FFB57B09FFB57B09FFB57B09FFB57B09FFB57B09FFB57B09FFB57B09FFB57B
      09FFB57B09FFB57B09FFB67D0EFFA27315EF0000000000000000000000000000
      0000000000000000001E100C03842C312CCA050C146A00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000100000026000000330000
      0033000000330000002600000003000000000000025300000CA60000024E0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000002300000033000000330000
      0033000000330000003300000033000000330000003842403EC96E6A68FF6D6A
      68FF6D6968FF413F3FCA0101013D0000000300000B9BFFFFFFFF383842BF0000
      013A000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007E7E7EFF7E7E
      7EFF7E7E7EFF7E7E7EFF7E7E7EFF7E7E7EFF7E7E7EFF7E7E7EFF7E7E7EFF7E7E
      7EFF0000000000000000000000000000000021364CC03E6793FF3E6693FF3D66
      93FF3D6693FF3D6693FF3B6694FF3E6690FF726E69FFD4CFC6FFFFFFFFFF9C9C
      9AFFFFFFFFFFC8C6C6FF6E6B6AFF010101310000024534343EB6FFFFFFFF3535
      3EB70000024D0000078100000AA200000AA20000078100000137000000010000
      0000000000000000000000000000000000000000000D0000001A0000001A0000
      001A0000001A0000001A0000001A0000001A0000001A0000001A0000001A0000
      001A0000001A0000001A0000001A0000000D000000007E7E7EFFDADADAFFDADA
      DAFFDADADAFFDADADAFFDADADAFFDADADAFFDADADAFFDADADAFFDADADAFFDADA
      DAFF7E7E7EFF0000000000000000000000003E6994FF5187AFFF457DAAFF427C
      A9FF407BA9FF407BA9FF3F7CACFF66737DFFD4CFC3FF0002FFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFC8C7C6FF444342CA000000000000013332323CB1FFFF
      FFFF686871D89A9AA0E5E7E7E8F9E7E7E8F99A9AA0E51B1B25B400000CA40000
      0CA400000CA400000CA400000CA40000067B0606065B0909096B0909096B0909
      096B0909096B0909096B0909096B0909096B0909096B0909096B0909096B0909
      096B0909096B0909096B0909096B0606065B000000007E7E7EFFDADADAFFDADA
      DAFFDADADAFFDADADAFF0000B3FF0000B3FF0000B3FF0000B3FF0000B3FF0000
      B3FF0000B3FF0000B3FF0000B3FF000000003E6895FF5A8EB9FF92A3AFFFBDB7
      AFFFBAB4ADFFBAB5AEFFBDB9B3FF716B66FFFFFFFFFFFFFFFBFF0000FFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF74716FFF0000000000000000000002456161
      6BD0F4F4F0FC646462BC1C1C1C7F1C1C1B7E5E5E5AB8E4E4DCFBD2D2C3FFE9E9
      D9FFF3F3E4FFF3F3E4FFF9F9EAFF00000B960909096BF2F2F2FFF2F2F2FFF2F2
      F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2
      F2FFF2F2F2FFF2F2F2FFF2F2F2FF0909096B000000007E7E7EFFEEEEEEFFEEEE
      EEFFEEEEEEFF0000B3FF296CF3FF296CF3FF296CF3FF296CF3FF296CF3FF296C
      F3FF296CF3FF296CF3FF296CF3FF0000B3FF3D6996FF6398C0FFBBB5ADFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF6D6867FF9B9A99FFFFFFF9FFFFFFFFFF2625
      21FF242423FF1F1F1FFFA2A3A3FF787372FF0000000000000000000005679292
      97DB656563BF242220817C7873B8817C78BB272624845A5A58B9E9E9DEFFDBDB
      CCFFEAEADCFFEAEADCFFF5F5E6FF00000A890909096BF2F2F2FFCBCBCBFFDFDF
      DFFFCBCBCBFFCBCBCBFFE1E1E1FFCBCBCBFFF2F2F2FFF2F2F2FFF2F2F2FFF2F2
      F2FFF2F2F2FFF2F2F2FFF2F2F2FF0909096B00000000000000007E7E7EFF7E7E
      7EFF7E7E7EFF0000B3FF6B8FF1FF6B8FF1FF6B8FF1FF6B8FF1FF6B8FF1FF6B8F
      F1FF6B8FF1FF6B8FF1FF6B8FF1FF0000B3FF3D6A97FF6FA2C9FFB6B1ABFFFFFF
      FFFFADADADFFFFFFFFFFB7B7B7FF6C6867FFFEFDFDFFF7F6F6FFFFFFFDFF2525
      24FFFFFFFFFFFFFFFFFFFFFFFFFF787574FF00000000000000000000087DE5E5
      E7F71A1A1A8A62574CAA817972BA817972BA70665DB318181887F3F3EBFFE1E1
      D4FFEDEDE2FFEDEDE2FFF7F7EBFF000009840A0A0A6BEFEFEFFFEFEFEFFFEFEF
      EFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEF
      EFFFEFEFEFFFEFEFEFFFEFEFEFFF0A0A0A6B000000007E7E7EFFDADADAFFDADA
      DAFFDADADAFFDADADAFF0000B3FF0000B3FF0000B3FF0000B3FF0000B3FF0000
      B3FF0000B3FF0000B3FF0000B3FF000000003C6B97FF7CABD1FFB5B0AAFFFFFF
      FFFFFAF9F9FFFBFAFAFFFFFFFFFF9E9B9AFFBBBAB9FFF5F5F4FFFAFBF9FF2020
      20FFFCFCFBFFF8F9F7FFC1C1C0FF454342BE000000000000000000000879E6E6
      E7F71818188F5B4F43A66F6151B36F6151B364594DAC1616158DF5F5EFFFEAEA
      E0FFF1F1E8FFF1F1E8FFF9F9EFFF000009800A0A0A6BEFEFEFFFDFDFDFFFCBCB
      CBFFCBCBCBFFDFDFDFFFCBCBCBFFDFDFDFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEF
      EFFFEFEFEFFFEFEFEFFFEFEFEFFF0A0A0A6B000000007E7E7EFFDADADAFFDADA
      DAFFDADADAFFDADADAFFDADADAFFDADADAFFDADADAFFDADADAFFDADADAFFDADA
      DAFF7E7E7EFF0000000000000000000000003C6C98FF88B5D8FFB4AFAAFFFFFF
      FFFFAEAEAFFFF5F5F4FFB4B4B4FFB1B1B0FF787574FFBCBAB9FFFAF9F7FFA3A3
      A3FFFBFAF9FFC1BFBEFF7A7776FF0000000D00000000000000000000055E8E8E
      93D75C5C5BC41C19168866605AAB66615AAB1D1A1789555554C1F6F6F1FFF3F3
      ECFFF5F5EFFFF5F5EFFFFBFBF4FF0000087C0A0A0A6BF3F3F3FFF3F3F3FFF3F3
      F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF5F5F5FFBFBFBFFFE1E1E1FFBFBF
      BFFFE1E1E1FFBFBFBFFFF3F3F3FF0A0A0A6B000000007E7E7EFFEEEEEEFFEEEE
      EEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEE
      EEFF7E7E7EFF0000000000000000000000003D6D9AFF95BEDFFFB3AFA9FFFFFF
      FFFFEFEFEEFFF0F0EFFFF3F3F2FFF5F5F4FFFEFEFDFF898682FF7D7671FF837B
      76FF827C78FF454342BC0000000D000000000000000000000000000000271212
      1B8FEDEDE9FB595958C51111119811111197555553C3EBEBE8FAF8F8F3FFF9F9
      F5FFF9F9F5FFF9F9F5FFFDFDF8FF000008780D0D0D6BF5F5F5FFCBCBCBFFE1E1
      E1FFCBCBCBFFCBCBCBFFE1E1E1FFCBCBCBFFF5F5F5FFE1E1E1FFEDEDEDFFEDED
      EDFFEDEDEDFFE1E1E1FFF5F5F5FF0D0D0D6B00000000000000007E7E7EFF7E7E
      7EFF7E7E7EFF7E7E7EFF7E7E7EFF7E7E7EFF7E7E7EFF7E7E7EFF7E7E7EFF7E7E
      7EFF000000000000000000000000000000003D6F9AFFA0C7E6FFB2AEA8FFFFFF
      FFFFAFAFAFFFEBEAE9FFB2B2B2FFB2B2B2FFFFFFFFFFB3B1ACFF9EC8ECFF346D
      9FFF000000000000000000000000000000000000000000000000000000000000
      0874E5E5DEFFF6F6F3FFFDFDFAFFFDFDFBFFFBFBFAFFFBFBF8FFFCFCFAFFFCFC
      FAFFFCFCFAFFFCFCFAFFFEFEFCFF000008740F0F0F6BF9F9F9FFF9F9F9FFF9F9
      F9FFF9F9F9FFF9F9F9FFF9F9F9FFF9F9F9FFF9F9F9FFBFBFBFFFEDEDEDFFEDED
      EDFFEDEDEDFFBFBFBFFFF5F5F5FF0F0F0F6B000000007E7E7EFFDADADAFFDADA
      DAFFDADADAFFDADADAFFDADADAFFDADADAFFDADADAFFDADADAFFDADADAFFDADA
      DAFF7E7E7EFF0000000000000000000000003C6F9BFFACCFEDFFB2AEA8FFFFFF
      FFFFE3E2E1FFE4E3E2FFE5E3E2FFE4E3E2FFFFFFFFFFB2AEA9FFACCFEEFF396F
      9CFF000000000000000000000000000000000000000000000000000000000000
      0771F7F7F5FFF0F0ECFFF3F3EFFFF8F8F5FFFCFCFCFFFFFFFEFFFFFFFEFFFFFF
      FEFFFFFFFEFFFFFFFEFFFFFFFFFF000007710F0F0F6BF9F9F9FFF9F9F9FFF9F9
      F9FFF9F9F9FFF9F9F9FFF9F9F9FFF9F9F9FFF9F9F9FFE1E1E1FFEDEDEDFFEDED
      EDFFEDEDEDFFE1E1E1FFF9F9F9FF0F0F0F6B000000007E7E7EFFDADADAFFDADA
      DAFFDADADAFFDADADAFFDADADAFFDADADAFFDADADAFFDADADAFFDADADAFFDADA
      DAFF7E7E7EFF0000000000000000000000003E719DFFBAD9F4FFB5B0AAFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB5B0AAFFBAD9F4FF3D71
      9DFF000000000000000000000000000000000000000000000000000000000000
      77C56969FAFF3B3BCDFF101088FF3B3BCDFF6060F4FF6060F4FF6060F4FF3B3B
      CDFF101088FF3B3BCDFF6969FAFF000077C51010106BFAFAFAFFFAFAFAFFFAFA
      FAFFFAFAFAFFFAFAFAFFFAFAFAFFFAFAFAFFFCFCFCFFCBCBCBFFE1E1E1FFCBCB
      CBFFE1E1E1FFCBCBCBFFFCFCFCFF1010106B000000007E7E7EFFEEEEEEFFEEEE
      EEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEE
      EEFF7E7E7EFF0000000000000000000000004174A0FF9ECAF0FF93A6B6FF9897
      96FF959595FF959595FF959595FF959595FF989796FF93A6B6FF9ECAF0FF4174
      A0FF000000000000000000000000000000000000000000000000000000000000
      6FB88181FFFF3F3FD7FFB1B1B1FF3F3FD7FF7B7BFEFF7B7BFEFF7B7BFEFF3F3F
      D7FFB1B1B1FF3F3FD7FF8181FFFF00006FB81111116BFCFCFCFFFCFCFCFFFCFC
      FCFFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFCFC
      FCFFFCFCFCFFFCFCFCFFFCFCFCFF1111116B00000000000000007E7E7EFF7E7E
      7EFF7E7E7EFF7E7E7EFF7E7E7EFF7E7E7EFF7E7E7EFF7E7E7EFF7E7E7EFF7E7E
      7EFF0000000000000000000000000000000021394DB03B74A2FFA6A09BFFF0EE
      ECFFE1DFDEFFEEEEEEFFEEEEEEFFDFDDDCFFEEECE9FFA6A09CFF3B74A3FF2139
      4DB0000000000000000000000000000000000000000000000000000000000000
      3B83000068AD00005ECCD6D6D6FF00005ECC000068AD000068AD000068AD0000
      5ECCD6D6D6FF00005ECC000068AD00003B830A0A0A541111116B1111116B1111
      116B1111116B1111116B1111116B1111116B1111116B1111116B1111116B1111
      116B1111116B1111116B1111116B0A0A0A540000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00003C3C3CA88F9090FF909090FF3C3C3CA80000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000370000005F000000370000000000000000000000000000
      00370000005F0000003700000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000010101151004027C37180CB4482311BF4E2713C34C26
      13C3411C0FBE230B06A9030101620101010A0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000042AC52FF42AC52FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000029000000380000
      004803060B84033363FF2E3639FF2E3639FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000101010A451B0EB1EE9A52FFFFB867FFFFBF6FFFFFC272FFFFC0
      71FFFFBB6CFFFAA95DFFA3512AF70601017300000000000000002121215A4B51
      5598464D5498464B5296464B5196464B5196464B5196FFFFFFFFFFFFFFFFFFFF
      FFFF42AC52FF42AC52FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000102
      0440033363FF043E79FFDDE1C0FF2E3639FF0000000000000000000000000000
      00000000000000000000000000000000000000000008D4612AFFD4612AFFD162
      2CFF0000000000000000000000000000000000000000010101180202015B0507
      027C030903831C0F06A6F89F60FFFFD185FFFFC888FFFFCA8FFFFFCC92FFFFCB
      91FFFFCA8DFFFFCF89FFFFC377FF401B0FBF0000000000000000CCCCCCE46793
      CDFF6599D5FF5C91D2FF5990D0FF5990D0FF578ECFFFFFFFFFFF42AC52FF42AC
      52FF42AC52FF42AC52FF42AC52FF42AC52FF0000000000000000000000000000
      000C12110F6F34312ABA433F36D2403C34CF322F28B70F0E0C660103053F003D
      7AFF043E79FF1663A5FF9FD7F4FF125B9CFF00000000000000007E7E7EFF7E7E
      7EFF7E7E7EFF7E7E7EFF7E7E7EFF7E7E7EFFD4652CFFFFD45CFFFFDA62FFFED3
      5BFFD4612FFF00000000000000000000000002020131193E17CD36A951FF3EBF
      61FF35CA68FF79914EFFFFB47FFFFFD5A1FFFFD5AAFFFFD9B2FFFFDBB5FFFFDB
      B4FFFFD7AFFFFFD4A6FFFFD69AFF563421C40000000000000000C7C7C7E16C92
      CBFF79B3EBFF8CCBFCFF78BFFBFF5EAEF7FF51A6F6FFFFFFFFFF42AC52FF42AC
      52FF42AC52FF42AC52FF42AC52FF42AC52FF000000000000000007070648514B
      40E77A6B58FFA98B6CFFC8A27AFFCAA47CFFAB8F6FFF7E6F5BFF595751FF263C
      5BFF033160FFCAF3FDFF125B9CFF00000000000000007E7E7EFFDADADAFFDADA
      DAFFDADADAFFDADADAFFDADADAFFDADADAFFD4632BFFFFD45CFFFFDA62FFFED7
      5FFFD4612BFF000000000000000000000000143112B14DDF7DFF5AE28AFF65DD
      8DFF63E496FF84AC6FFFF8B38AFFFFE2BFFFFFE8CEFFFFECD8FFFFF1E0FFFFF0
      DEFFFFEBD4FFFEE6C7FFFFDAAEFF45291DB50000000000000000141414469595
      96C3B1C2E0FE6592CFFF61A1E1FF6FB6F5FF60AEF4FFFFFFFFFFFFFFFFFFFFFF
      FFFF42AC52FF42AC52FF0000000000000000000000000807074B605A4DFCC09F
      7BFFFDDFABFFFEFADEFFFFFFF3FFFFFFF2FFFEF2DFFFFED4A1FFB99975FF625C
      50FF263C5BFF125B9CFF0002043800000000000000007E7E7EFFDADADAFFDADA
      DAFFDADADAFFDADADAFFDADADAFFDADADAFFD4622AFFFFD45CFFFFDA62FFFFD3
      5AFFD4612BFF000000000000000000000000388644E576E7A0FF84DEA1FF8FE3
      AAFF94E9B4FF93CE9CFFE1B08FFFFEE6D7FFFFFAF0FFFFF8EAFFFFF0D8FFFFF5
      E2FFFFFAEEFFFFF6EDFFFCCFB3FF1009066F0101010701010108010101080101
      01080D0D0D3B878787BABAC9E0FD659ED9FF60A0E1FFA9BCDBFE9C9DA0CDFFFF
      FFFF42AC52FF42AC52FF010101080101010700000012554F44EDC8AA84FFFEEC
      B9FFFFF6C3FFFEEDB4FFFDE9AFFFFEEBB2FFFEF1BDFFFEF0C1FFFEE0AFFFB191
      70FF5A5850FF020305410000000000000000000000007E7E7EFFEEEEEEFFEEEE
      EEFFEEEEEEFFEEEEEEFFEEEEEEFFD4612AFFD4612AFFFFEA71FFFFEA71FFFFEA
      71FFD4612AFFD4612AFF0000000000000000407D46DA9AEBB8FFAEEBC1FFB9ED
      CBFFC7F6D3FFC4F8D5FFC8C3A2FFF3C5B2FFF7DDD2FFD4BDC7FFB8989BFFC5A6
      AAFFEFC7AEFFFFE0CAFF5A4237B801010112100B0557140E0661130D065F120C
      055F120C055F31292388C5D1E7FE68A3DDFF69AAE9FFA7BDDEFF3A3C4E9CFFFF
      FFFFFFFFFFFFFFFFFFFF04061861030513571A18158491846AFFFDDEADFFFCDD
      ADFFFCD69FFFFCD68EFFFCD992FFFCD88FFFFBD7A2FFFCD8A6FFFCD8A6FFFDD8
      A9FF806E5AFF14131075000000000000000000000000000000007E7E7EFF7E7E
      7EFF7E7E7EFF7E7E7EFFCF5D29FDFFF3B6FFFFEA71FFFFEA71FFFFEA71FFFFEA
      71FFFFEA71FFFFF6C8FFD4622AFF00000000214220A6BAEFCCFFD9F7E4FFF0FF
      F0FFDFE4EFFFD9DEEEFFF2FBF1FFE0BBA5FFB3A1C8FFA8BEF6FFA7BCF6FF95AF
      F5FF9F9EDBFF6A463DD10201012100000000957651E2D3B485FFC5A06CFFBD96
      63FFBB9362FFDACCBAFF6394D0FF89C7FAFF7CC0FAFF5B8DCDFFC8CCF3FF626D
      E0FF5E68DFFF5D66DFFF6A72E5FF4452ACE9423F36D0C2A17CFFFBCB9AFFF9BD
      89FFF9C190FFFACC96FFF9CE91FFF8CC90FFF8C593FFF8C391FFFAC491FFFDC8
      96FFC59976FF38342DC00000000000000000000000007E7E7EFFDADADAFFDADA
      DAFFDADADAFFDADADAFFDADADAFFCD5C28FCFEF2B6FFFFEA71FFFFEA71FFFFEA
      71FFFFF3B7FFD46129FF000000000000000003090343A2CEA8FAEDFBEDFFDCF6
      C8FF596CCFFF4651D0FFB4F4AEFFAACCDEFFBBC9FDFFCADBFBFFCADAFAFFC4D6
      F8FFB3CBFFFF3B4876D80101012700000000100B06576D5335C5CCA976FFCBA4
      6DFFB98C50FFDCCFBFFF6697D2FF8CCAF9FF7CC0F9FF578ED0FFC2CAF3FF6069
      EEFF6D73F0FF6C72E9FF4C55B4EA0A0E287D635D4FF9D8B089FFF9BA88FFF4B6
      83FFF1B27DFFEFB382FFF0B583FFEEB280FFEEB07DFFF0B280FFF6BC89FFF9B9
      87FFDEAD85FF514B40E70000000000000000000000007E7E7EFFDADADAFFDADA
      DAFFDADADAFFDADADAFFDADADAFFDADADAFFCA5927FAFEF2B6FFFFEA71FFFFF4
      B7FFD46228FF000000000000000000000000010101010B1E096D68A572EF6CB5
      C1FF4091C6FF3486C2FF2A999BFF84B7DAFFD8E0FFFFCFDDFDFFCDDBFDFFCAD8
      FAFFCDDCFDFF97AEEAFE0204075E00000000010101090101011B110C065B5942
      2AB7C39F6BFBE5D8C8FE6491CEFFA1D7FDFF96D2FDFF5A8ECDFFCDD2F3FE727B
      E8FD2A326DBE090C2172020205360101010D605A4DFCD6AA84FFF8B985FFEFAE
      7AFFECAA77FFECAA77FFECAA77FFECAA77FFECAA77FFECAA77FFEEB07CFFF5B5
      82FFDAA67DFF534D42EA0000000000000000000000007E7E7EFFEEEEEEFFEEEE
      EEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFC85926F9FFF3B6FFD664
      2AFF7E7E7EFF0000000000000000000000000000000001010108265C65CC87CF
      FDFF8DD5F4FF84D1EDFF50A1D8FF86A8E9FFE9EFFFFFE2EBFEFFDDE6FEFFCEDB
      FDFFD2E1FFFFA3B8EFFE02030757000000000000000000000000010101070202
      01279A7B51E4D3BB9DFBB8C8E2FE6495D3FF6398D7FF9DB7DCFF9C9FD0F06E79
      D6F9020309410101010A010101030000000048443BDBBC9877FFF5B583FFF3B4
      81FFEEAC79FFECAA77FFECAA77FFECAA77FFECAA77FFEDAB77FFF0B07CFFF0AF
      7EFFBE9875FF3E3A33CC000000000000000000000000000000007E7E7EFF7E7E
      7EFF7E7E7EFF7E7E7EFF7E7E7EFF7E7E7EFF7E7E7EFF7E7E7EFFD16029FE7E7E
      7EFF00000000000000000000000000000000000000000208104E80BDE5F7A6E2
      FFFF9EDBFEFF9ADAFDFF87CFF1FF7098E0FFE9EAFEFFFBFEFFFFEBF0FEFFD9E5
      FEFFDEEFFFFF4D578BD80101011B0000000000000000000000000101010D3325
      158FCFAB75FECFAB73FF807263C88591A2D88795AFE27B7E94CD7F8AECFE7E89
      F1FF1E2453A7010101100000000000000000201F1A938E7E67FFE9A87AFFF9BC
      88FFF6B884FFF2B37EFFF1B07CFFF1B17DFFF3B380FFF4B682FFF4B784FFE09E
      74FF8F7D65FF1A1815840000000000000000000000007E7E7EFFDADADAFFDADA
      DAFFDADADAFFDADADAFFDADADAFFDADADAFFDADADAFFDADADAFFDADADAFFDADA
      DAFF7E7E7EFF000000000000000000000000000000000614226CAAE1FEFFC1EA
      FFFFBDE7FFFFABDFFFFF9BDCFDFF72B5E7FF7388E1FFE4E1F9FFF7FDFFFFDAE7
      FFFF6872B5E60202064900000000000000000000000001010101020201238B6F
      47D8D3AD6CFFCDA563FF8C6E49DF02020127010102254D5599D87B8AF6FF7481
      F5FF4B54A1DF010103270101010200000000010101246A6555F9AC8465FFEAAA
      7BFFFBCF9EFFFFFCF1FFFFFFFFFFFFFFFFFFFFFBEFFFF8C391FFDD9F73FFA27C
      60FF666152F4000000180000000000000000000000007E7E7EFFDADADAFFDADA
      DAFFDADADAFFDADADAFFDADADAFFDADADAFFDADADAFFDADADAFFDADADAFFDADA
      DAFF7E7E7EFF0000000000000000000000000000000003080E45A8D0E9FBEFFE
      FFFFDEF3FFFFC1E7FFFFA7E1FFFF8AD6F8FF0410249507061C62222352980F10
      37820101042C0000000000000000000000000000000001010102030201279B7C
      51E0D8B46EFFD3AB67FF95764EE20302022C010203295861A7E07D8EF8FF7786
      F6FF515CA8E20102032A01010102000000000000000012110F6F655E50FFAD84
      65FFE7AC81FFF8E0C7FFFFFDFBFFFEFCFBFFF6DCC1FFD8A077FFA77E61FF665E
      51FF0C0B095A000000000000000000000000000000007E7E7EFFEEEEEEFFEEEE
      EEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEE
      EEFF7E7E7EFF000000000000000000000000000000000101010622374DA4EEF3
      F8FFFBFFFFFFD4F7FFFFAEEBFFFF33586ED40101011D00000000000000000000
      00000000000000000000000000000000000000000000000000000101011B4532
      1DA0DCBC82FFDDBE84FF584228B40101011D0101011B22244BA08D9AF0FF8E9C
      F3FF2A3163B40101011D000000000000000000000000000000000C0C0A5B5752
      46F07D6A57FFAC8364FFC5906CFFC38E6AFFA98062FF7C6956FF534D42EA0B0A
      08530000000000000000000000000000000000000000000000007E7E7EFF7E7E
      7EFF7E7E7EFF7E7E7EFF7E7E7EFF7E7E7EFF7E7E7EFF7E7E7EFF7E7E7EFF7E7E
      7EFF0000000000000000000000000000000000000000000000000101010F1621
      2D876B8193D96A8AA1E11929389E010202260000000000000000000000000000
      0000000000000000000000000000000000000000000000000000010101040202
      0124261B0E7B3526158F050302330101010701010104010102241013297B181B
      398F020205330101010700000000000000000000000000000000000000000101
      001B25221D9C534D42EA625C4FFF625C4FFF514B40E721201B96000000150000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000002B12098E79301AF279301AF27930
      1AF22B12098E061F16960E593DFF0E593DFF0E593DFF061F1696070733961212
      90FF121290FF121290FF07073396000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000020101282009
      03A763260EDF7E3C17EC88461DEF8E4D1EF1905020F18B491FF185411AF0712F
      11EA421407D9090201960101011D000000007C331BF2C06A2AFFC06A2AFFC06A
      2AFF7C331BF2135E42FF2E8F67FF2E8F67FF2E8F67FF135E42FF111394FF1431
      C2FF1431C2FF1431C2FF111394FF000000000000000000000000000000000000
      00000104012A061F06820C4D0CCE127712FF127712FF0C4D0CCE061F06820104
      012A000000000000000000000000000000000404046B070707D7080808EA0F0F
      0FE8161616E81C1C1CE8212121E8242424E8242424E8212121E81B1B1BE81414
      14E80F0F0FE8090909EA040404D80101016B0000000006020146A7471BF2FC98
      49FFFFB15CFFFFB966FFFFC46AFFFABF6CFFF7B968FFFFC96CFFFFBD6AFFFFB5
      61FFFFA352FFD0682CFF320D04D9010101267F371DF2C26E2EFFC26E2EFFC26E
      2EFF7F371DF2196548FF37956EFF37956EFF37956EFF196548FF111498FF1A3A
      C8FF1A3AC8FF1A3AC8FF111498FF000000000000000000000000000000000309
      0340166816E6339833FF47AC47FF55BA55FF55BA55FF47AC47FF339833FF186B
      18E7051505650000000000000000000000000F0F0F94101010FF252525FF2929
      29FF2C2C2CFF2E2E2EFF2F2F2FFF2C2C2CFF282828FF262626FF2B2B28FF3132
      31FF2C2C2CFF2A2A2AFF151515F902020289000000008B3914D9FFBB68FFFFC5
      79FFFFC17DFFFFCB7FFFD6A98DFF4E40CCFF2C22B2FFAD8782FFFFCB81FFFFC3
      81FFFFC57FFFFFCA77FFD16E33FF08020193833B21F2C47233FFC47233FFC472
      33FF833B21F21F6C4EFF419C78FF419C78FF419C78FF1F6C4EFF10149EFF2045
      CFFF2045CFFF2045CFFF10149EFF0000000000000000000000000B0704400000
      0000144E14BF87EE87FF64CA64FF64CA64FF64CA64FF64CA64FF64CA64FF53B8
      53FF309530FF0716076500000000000000000E0E0E910D0D0DFD252525FF1A1A
      1AFF1F1F1FFF1E1E1EFF272727FF414141FF656563FF868788FF9E9EB0FFB0AE
      C9FF686868FF2C2C2CFF171717F90202028800000000F48445FBFFCB89FFFFC8
      8DFFFFCC96FFFFDA99FFBAA4A8FF2A2EE5FF060CEBFF7F6CA7FFFFDE9FFFFFCC
      94FFFFB677FFFFCE8EFFF6A867FF1D0A05B5853E24F2C77739FFC77739FFC777
      39FF853E24F2277454FF4DA481FF4DA481FF4DA481FF277454FF1015A3FF2852
      D6FF2852D6FF2852D6FF1015A3FF00000000000000000504022A7E552BE6563A
      1DBF000000001C551CBF87EE87FF79DF79FF79DF79FF79DF79FF79DF79FF79DF
      79FF66CC66FF2C7F2CE70205022A000000000E0E0E910E0E0EFD262626FF1F1F
      1FFF242424FF898989FFCBCBCBFFE8E8E7FFF8F7FEFFDBD4FAFFE2CFEAFFF8F4
      FDFF9C9D9CFF292929FF171717F90202028800000000EF9159FBFDCF9BFFFFD5
      A8FFFFD9B1FFFFE5B9FFDECCBBFF5251DDFF3032E6FFA795B7FFFFEFB9FFDACE
      8DFFF6BC80FFFFD3A0FFF5B47FFF1C0C06AF894328F2CA7C3FFFCA7C3FFFCA7C
      3FFF894328F22E7C5BFF59AC8CFF59AC8CFF59AC8CFF2E7C5BFF0F16A8FF2F5E
      DEFF2F5EDEFF2F5EDEFF0F16A8FF0000000000000000281B0E82AE7C49FFB280
      4DFF563A1DBF00000000225B22BF87EE87FF87EE87FF87EE87FF87EE87FF87EE
      87FF87EE87FF5DC25DFF102B1082000000000E0E0E910E0E0EFD29292AFF2525
      25FF272727FF9F9F9FFFF3F4F4FFECEDEDFFDFD9F4FFF0CCCFFFF7DCD8FFFDF3
      F2FFBEBFBFFF2C2C2DFF191919F90202028800000000C77044E5F9D6B0FFFBDD
      BEFFFFE9D0FFFFF4DCFFEAE7DAFF6463E0FF3F40E2FFC3BBD0FFFFFCDDFFEAE3
      BFFFF9DAB7FFFFDCB6FFE5A87EFF0A04027C8D492CF2CD8145FFCD8145FFCD81
      45FF8D492CF2368363FF66B498FF66B498FF66B498FF368363FF0E16AEFF3569
      E5FF3569E5FF3569E5FF0E16AEFF0000000000000000664524CEC08D5BFFCC98
      66FFB4814FFF583C1FBF00000000266026BF44A944FF44A944FF44A944FF44A9
      44FF44A944FF44A944FF2C6F2CCE000000000E0E0E910E0E0EFD2B2B2CFF2828
      28FF2D2D2DFF818180FFEFEFEFFFE5E5E7FFEFEDF9FFF8C1C0FFEECBCCFFF8F8
      F9FFE3E3E3FF3F3F40FF181819F9020202880000000047200E88F9D0B1FFF3DE
      CEFFFEF9F1FFFFF8EFFFFAF7ECFF635FD2FF2D27C2FFDAD4DCFFFFFBEEFFFFFC
      FCFFF8E8DCFFFFE6CCFF81563DEA01010117914E2EF2D0874CFFD0874CFFD087
      4CFF914E2EF23D8B6AFF72BCA3FF72BCA3FF72BCA3FF3D8B6AFF0E17B2FF3B72
      EBFF3B72EBFF3B72EBFF0E17B2FF0000000000000000A2703DFFD29E6CFFD29E
      6CFFD29E6CFFBA8755FF5B3F23BF000000000000000000000000000000000000
      0000000000000000000000000000000000000E0E0E910E0E0EFD2D2D2EFF2A2A
      2AFF323233FF676767FFEAEAEAFFE5E6E7FFE6D6DFFFEDDFDEFFF8FAFAFFF6F7
      F7FFECECECFF585858FF161616F902020288000000000101010AAD6946D4F2DB
      D2FFFADCD4FFFFECD2FFDDBEA9FF3141BFFF061EC7FFAE989EFFFFD597FFFFD6
      BFFFFFE2D8FFD2A287FA0803015500000000955132F2D48D53FFD48D53FFD48D
      53FF955132F2459370FF7EC4ADFF7EC4ADFF7EC4ADFF459370FF0D18B6FF9FBC
      F7FF9FBCF7FF9FBCF7FF0D18B6FF0000000000000000AA7845FFDBA775FFDBA7
      75FFDBA775FFDBA775FFAA7845FF000000000122CCFF0122CCFF0122CCFF0122
      CCFF0122CCFF0122CCFF0122CCFF000000000E0E0E910E0E0EFD2E2E2EFF2A2A
      2AFF353636FF4E4D4DFFDAD9D8FFD8D8D8FFC0C2C2FFB4B6B6FF9F9E9EFF8787
      86FF777676FF4A4A4AFF181818F902020288000000000000000003020117945A
      37C2D5977CFE95BBCDFF5FA4C9FF4FA0CFFF47A0D0FF3B8BB9FF6A9BA9FFC892
      78FFA86F51EF0A0503500000000000000000985736F2D79359FFD79359FFD793
      59FF985736F24B9A76FF87CBB7FF87CBB7FF87CBB7FF4B9A76FF050941960D18
      B9FF0D18B9FF0D18B9FF050941960000000000000000745432CED9A574FFE5B1
      80FFE5B180FFE5B180FFB1804DFF00000000092AD2FF3355FFFF3355FFFF3355
      FFFF3355FFFF294BF5FF061C8ACE000000000E0E0E910E0E0EFD2D2D2DFF2828
      28FF363636FF3B3A3AFF605F5FFF555555FF464645FF3C3B3BFF343434FF2828
      28FF2F2F2FFF3D3D3DFF1A1A1AF9020202880000000000000000000000000202
      021B5B8497F57BCCF7FF87D1F7FF8AD1F3FF84CCEEFF72BFE7FF48A7DCFF3D87
      AFFF090D10C10000000000000000000000009C5C3AF2DA985FFFDA985FFFDA98
      5FFF9C5C3AF251A17CFF90D1BEFF90D1BEFF90D1BEFF51A17CFF000000000000
      0000000000000000000000000000000000000000000031241682D29E6CFFF0BC
      89FFF0BC89FFF0BC89FFB98654FF000000001436DBFF4C6EFFFF4C6EFFFF4C6E
      FFFF4C6EFFFF2D4FEBFF060F3A82000000000E0E0E910D0D0DFD2D2D2DFF2424
      24FF313131FF353535FF2F2F30FF303031FF323233FF343434FF343434FF2C2C
      2CFF353535FF3C3C3CFF191919F9020202880000000000000000000000000A2E
      44A684D2F7FF9DDDFFFF99D8FDFF97D8FCFF94D6FBFF90D3F7FF84CBEDFF5CB7
      E7FF1A5D81FB010101570000000000000000A0603DF2DD9D65FFDD9D65FFDD9D
      65FFA0603DF256A681FFD2EDE6FFD2EDE6FFD2EDE6FF56A681FF000000000000
      000000000000000000000000000000000000000000000605032AA2784FE7EAB6
      83FFF9C592FFF9C592FFC18E5CFF000000002244E5FF6F90FFFF6F90FFFF6F90
      FFFF5A7CF8FF203CBEE70203072A000000000E0E0E910D0D0DFD303030FF2626
      26FF262626FF2C2C2CFF2E2E2EFF2F2F2FFF2F2F2FFF2F2F2FFF2E2E2EFF2727
      27FF313131FF383838FF181818F9020202880000000000000000000000003F81
      AAE3ABE5FFFFADE2FFFFB2E3FFFFAEE1FFFFA3DEFFFF98D9FDFF92D5F8FF85D0
      F4FF4997C2FF02080C870000000000000000A4633FF2DFA16AFFDFA16AFFDFA1
      6AFFA4633FF21F3C2E965AAA83FF5AAA83FF5AAA83FF1F3C2E96000000000000
      000000000000000000000000000000000000000000000000000020181065D29E
      6CFFF0BC89FFFFCC98FFC89462FF000000003052F0FF87A9FFFF87A9FFFF7091
      FBFF4163F3FF080E266500000000000000000E0E0E910D0D0DFD2D2D2DFF3232
      32FF272727FF262626FF272727FF282828FF282828FF282828FF272727FF2222
      22FF2E2E2FFF363636FF171717F9020202880000000000000000000000003B7A
      A6DCC3ECFEFFCBECFFFFD1EEFFFFCCECFFFFBAE6FFFFA6DFFFFF96D6FBFF95DB
      FEFF539CC7FE0104076B0000000000000000A66742F2E1A56EFFE1A56EFFE1A5
      6EFFA66742F20000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000002119
      1165AB8057E7E2AE7CFFCC9866FF000000003C5EF9FF7697FEFF5D7FFCFF3551
      CDE70A1028650000000000000000000000000D0D0D94090909FF202020FF2626
      26FF252525FF252525FF262626FF262626FF262626FF262626FF262626FF2626
      26FF272727FF272727FF131313F9020202890000000000000000000000000821
      3581B0DCF5FFF4FFFFFFF0FAFFFFE2F5FFFFCBECFFFFB1E3FFFFA4E0FFFF94E1
      FFFF214C69E60101010E0000000000000000A86A44F2F1D4B8FFF1D4B8FFF1D4
      B8FFA86A44F20000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000705042A36281B82866443CE000000004466FFFF2C43A7CE121B43820304
      082A000000000000000000000000000000001010106B232323D71B1B1BEA1F1F
      1FE8232323E8262626E8292929E82A2A2AE82A2A2AE8292929E8252525E82323
      23E81F1F1FE81C1C1CEA121212D80303036B0000000000000000000000000000
      00001F537EC5C8E3F5FFFFFFFFFFF4FEFFFFDAF5FFFFC1EFFFFF9AE2FFFF3874
      9FF3010204460000000000000000000000003B26198EAA6D46F2AA6D46F2AA6D
      46F23B26198E0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000010101060823408F5385B6E88FBCE2FB8AC1EAFD5492C6F3113152BF0102
      0330000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000101011D010101330101011D0000000000000000000000001D1D1D965151
      51FF515151FF515151FF515151FF515151FF515151FF515151FF515151FF5151
      51FF515151FF515151FF515151FF1D1D1D9600000000000000000505398F0909
      55AF010102100000000000000000000000000000000000000000000000000101
      021015155FAF1010438F00000000000000000101015201010152010101520101
      0153010101590101015D0101016001010161010101610101015F0101015B0101
      0156010101520101015201010152010101520101011D010101330101011C0000
      0000000000000000000000000000000000000000000000000000000000000000
      000001014CA50101D1FF01014EA6000000000000000000000000555555FFFFFF
      FFFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFD
      FDFFFDFDFDFFFDFDFDFFFFFFFFFF555555FF000000000606469F0707B7FF0A0A
      BAFF0E0E77CF0101021000000000000000000000000000000000010102101B1B
      83CF3939EEFF4141F7FF1515559F000000001C1C1CF81B1B1BF21B1B1BF21B1B
      1BF21B1B1BF21B1B1BF21B1B1BF21B1B1BF21B1B1BF21B1B1BF21C1C1CF21C1C
      1CF21C1C1CF21C1C1CF21C1C1CF21D1D1DF401014EA60101D1FF01014EA50000
      0000010101240101013301010125000000000000000000000000000000000000
      00000101D1FF0101D1FF0101D1FF00000000276839FF276839FF276839FF2768
      39FF276839FF276839FF276839FF276839FF276839FF276839FFF1F1F1FFF0F0
      F0FFF0F0F0FFEFEFEFFFFDFDFDFF595959FF12123D8F0808B5FF0707B7FF0A0A
      BAFF0D0DBDFF0F0F78CF01010210000000000000000001010210181880CF3030
      E4FF3737ECFF3C3CF2FF3E3EF4FF1010428F232323E95D5D5DFF5D5D5DFF5D5D
      5DFF5D5D5DFF5D5D5DFF5E5E5EFF5E5E5EFF5E5E5EFF5E5E5EFF5E5E5EFF5E5E
      5EFF5E5E5EFF5E5E5EFF5E5E5EFF212121EF0101D1FF0101D2FF0101D9FF0000
      0000704F1FC5BF863FFF6E4E24C8000000000000000000000000000000000101
      01310101D1FF0101D1FF0101418E000000002B6F3DFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2B6F3DFFF0F0F0FFEFEF
      EFFFEFEFEFFFEEEEEEFFFDFDFDFF5F5F5FFF21215DAF5555CEFF0A0AB7FF0909
      B9FF0C0CBCFF0F0FC0FF101079CF010102100101021015157ECF2727DAFF2D2D
      E0FF3232E6FF3636EBFF3737ECFF14145FAF202020F24E4E4EFF474747FF4747
      47FF474747FF474747FF484848FF484848FF484848FF484848FF484848FF4949
      49FF494949FF494949FF4F4F4FFF252525F00101418D0101D2FF0101C6F60000
      0000CD9034FFBF873EFFBF873EFF000000000000000000000000010101310101
      BFF5010164B00000000000000000000000002F7743FF677465FF507B51FF468A
      4AFF487E49FF558156FF719F73FF508152FF537E58FF2F7743FFEFEFEFFFEEEE
      EEFFEEEEEEFFEDEDEDFFFDFDFDFF646464FF010102102E2E82CF5656CFFF0C0C
      B9FF0B0BBBFF0E0EBFFF1212C3FF101079CF13137CCF1F1FD1FF2424D6FF2828
      DBFF2C2CE0FF2F2FE3FF1A1A82CF01010210090909752C2C2CF65F5F5FFF5D5D
      5DFF505050FF4E4E4EFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F
      4FFF5B5B5BFF646464FF383838F70D0D0D8B00000000010110440101D7FF0101
      0131CE9133FFC0873EFFB37E3AF70000000000000000010101310101C3F70101
      6BB60000000000000000000000000000000034814AFFFFFFFFFF3E7A40FF347D
      34FF3A803BFF7CAD7DFF5B9E5EFF346E34FFFFFFFFFF34814AFFEEEEEEFFEDED
      EDFFEDEDEDFFECECECFFFDFDFDFF6B6B6BFF00000000010102102E2E82CF5656
      D0FF0D0DBBFF0D0DBEFF1010C1FF1414C5FF1818C9FF1C1CCEFF2020D2FF2323
      D6FF2626D9FF181880CF01010210000000000000000006060658252525E53333
      33EF565656FE666666FF555555FF555555FF555555FF565656FF666666FF5959
      59FF3E3E3EF32A2A2AEE0B0B0B7601010101000000000000000001019CD6573D
      7DF59E7026DF110C0649C3893CFF010101210101012F0101C4F601016BB60000
      000000000000000000000000000000000000398A51FFFFFFFFFFFFFFFFFF4A87
      4AFF82B37EFF60905AFF3E813DFF67A366FF81A882FF398A51FFEDEDEDFFECEC
      ECFFEBEBEBFFEBEBEBFFFDFDFDFF717171FF0000000000000000010102102F2F
      82CF5757D0FF0F0FBCFF0F0FBFFF1212C3FF1515C6FF1818CAFF1B1BCDFF1F1F
      D1FF14147ECF0101021000000000000000000000000000000000010101030505
      054C1B1B1BB3323232EF585858FF5B5B5BFF5B5B5BFF555555FD333333F01818
      18A7070707560101010B00000000000000000000000001010101140E1174CA8F
      35FF06050E5A00000000AD7A2BEA593F1DB50101BEED01016AB4000000000000
      0000000000000000000000000000000000003D9357FFFFFFFFFFFFFFFFFF8FC1
      95FF5B8660FF3D6940FF477E4CFFFFFFFFFFF3FFF9FF3D9357FFEBEBEBFFEBEB
      EBFFEAEAEAFFEAEAEAFFFDFDFDFF787878FF0000000000000000000000000101
      02102F2F82CF4E4ECFFF0D0DBDFF0F0FC0FF1212C3FF1515C6FF1717C9FF1313
      7BCF010102100000000000000000000000000000000000000000000000000000
      000000000000070707563C3C3CEE616161FF616161FF363636F2020202270000
      0000000000000000000000000000000000000101012502020137CE9133FF3324
      79DE01019EDA010101130E0A075A120DC4FF010167B200000000000000000000
      000000000000010101250101013301010125429D5EFFFFFFFFFF91B994FF478C
      4EFF3B743EFF467A4AFF347737FF3B813FFFFFFFFFFF429D5EFFEAEAEAFFEAEA
      EAFFE9E9E9FFE9E9E9FFFDFDFDFF7E7E7EFF0000000000000000000000000101
      0210191979CF2F2FC4FF1E1EC1FF0F0FBEFF0F0FC0FF1111C2FF1414C5FF1010
      79CF010102100000000000000000000000000000000000000000000000000000
      0000000000001919199C4F4F4FF9626262FF626262FF454545F00B0B0B620000
      0000000000000000000000000000000000006B4C25C7C0873EFFBA832DF30000
      00000101D6FF0101287E0101ADE43525A8FF7D591AC90101010B000000000000
      0000000000006E4E24C8BD8540FF6E4E26C946A564FF86907EFF62855CFF427D
      42FFFFFFFFFFFFFFFFFF4E844BFF3C7839FF4D7750FF46A564FFE9E9E9FFE8E8
      E8FFE8E8E8FFE7E7E7FFFDFDFDFF848484FF0000000000000000010102101A1A
      7ACF3535C4FF3333C5FF3131C5FF3030C6FF2929C5FF2121C4FF2020C5FF2020
      C6FF18187BCF0101021000000000000000000000000000000000000000000000
      0000000000003F3F3FF0676767FF686868FF686868FF636363FF343434D80000
      000000000000000000000000000000000000BD8540FFC0873EFFD09331FF0000
      00000101C2F50101D3FF0101DFFF00000000C58B3AFF0F0B065A000000000000
      000000000000BD8540FFBD8540FFBD8540FF4AAC68FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4AAC68FFFDFDFDFFFDFD
      FDFFFDFDFDFFFDFDFDFFFDFDFDFF8A8A8AFF00000000010102101B1B7ACF3A3A
      C4FF3737C4FF3535C4FF3333C5FF3131C5FF6969D7FF3232C7FF2F2FC7FF2F2F
      C8FF2E2EC9FF18187ACF01010210000000000000000000000000000000000000
      000000000000454545EB6E6E6EFF6E6E6EFF6E6E6EFF6E6E6EFF444444F00000
      000000000000000000000000000000000000674923BBC0873EFF6B4C19B60000
      00000101D3FF0101D3FF0101E0FF000000005B411DAF906631E2010101110000
      000001010123BD8540FFBD8540FF644622B94CB16CFF4CB16CFF4CB16CFF4CB1
      6CFF4CB16CFF4CB16CFF4CB16CFF4CB16CFF4CB16CFF4CB16CFFFDFDFDFFE0E0
      E0FFE5E5E5FFEBEBEBFF909090FF33333396010102101D1D7BCF3F3FC5FF3C3C
      C5FF3A3AC4FF3737C4FF3535C4FF191979CF353584CF7171D9FF3333C6FF3030
      C6FF2F2FC6FF2F2FC7FF18187ACF010102100000000000000000000000000000
      0000000000004E4E4EEF757575FF757575FF757575FF757575FF484848F00101
      010C000000000000000000000000000000000000000000000000000000000000
      0000010170B90101D3FF010177B90000000000000000BD8540FF1E150B770101
      0133624621BFA67638EF00000000000000000000000000000000959595FFFDFD
      FDFFE9E9E9FFE8E8E8FFE8E8E8FFE7E7E7FFE7E7E7FFE6E6E6FFFDFDFDFFE5E5
      E5FFEBEBEBFF959595FF3535359600000000282860AF5555CCFF4242C6FF3F3F
      C5FF3C3CC5FF3A3AC4FF1A1A7ACF0101021001010210363684CF7272D8FF3434
      C5FF3131C5FF3131C5FF3131C5FF121257AF0000000000000000000000000000
      0000000000004E4E4EF07B7B7BFF7B7B7BFF7B7B7BFF7B7B7BFF4A4A4AF40101
      0102000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B47E3DF9BD8540FFBD85
      40FFA57438EE00000000000000000000000000000000000000009A9A9AFFFDFD
      FDFFE8E8E8FFE7E7E7FFE7E7E7FFE6E6E6FFE5E5E5FFE5E5E5FFFDFDFDFFEBEB
      EBFF9A9A9AFF3636369600000000000000002020428F9898E6FF5454CCFF4242
      C6FF3F3FC5FF1B1B7ACF01010210000000000000000001010210363684CF7373
      D8FF3636C5FF3333C4FF3333C4FF0D0D3B8F0000000000000000000000000000
      000000000000383838C27E7E7EFF8E8E8EFF8E8E8EFF797979FF262626A80000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BD8540FFBD8540FFBD85
      40FF0000000000000000000000000000000000000000000000009E9E9EFFFDFD
      FDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFF9E9E
      9EFF37373796000000000000000000000000000000002929539F9898E6FF5555
      CCFF1D1D7BCF0101021000000000000000000000000000000000010102103636
      84CF7575D8FF3939C4FF11114A9F000000000000000000000000000000000000
      0000000000000404042E434343DD656565F8616161F73C3C3CD2020202180000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000654722BABD8540FF6446
      22B900000000000000000000000000000000000000000000000039393996A1A1
      A1FFA1A1A1FFA1A1A1FFA1A1A1FFA1A1A1FFA1A1A1FFA1A1A1FFA1A1A1FF3939
      39960000000000000000000000000000000000000000000000002020428F2828
      60AF010102100000000000000000000000000000000000000000000000000101
      021027275FAF18183E8F00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000101012301010133010101330101
      0133010101330101013301010133010101330101013301010133010101330101
      01330101013301010133010101330101012300000000000000001010106F2B2B
      2BBD4A4A4AFA4E4E4EFF4E4E4EFF4E4E4EFF4E4E4EFF4E4E4EFF4E4E4EFF4A4A
      4AFA2B2B2BBD1010106F0000000000000000000000000000000012131245ADB0
      AEDBEAEFEBFFEAEFEBFFEAEFEBFFEAEFEBFFEAEFEBFFEAEFEBFFEAEFEBFFEAEF
      EBFFEAEFEBFFADB0AEDB12131245000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004D4D4DC08D8D8DFF8A8A8AFF8A8A
      8AFF8A8A8BFF8B8B8CFF8B8C8DFF8B8C8DFF8B8B8CFF8A8A8BFF8A8A8AFF8A8A
      8AFF8A8A8AFF8A8A8AFF8D8D8DFF4D4D4DC000000000242424AB4E4E4EFF4E4E
      4EFF4E4E4EFF4E4E4EFF4E4E4EFF4E4E4EFF4E4E4EFF4E4E4EFF4E4E4EFF4E4E
      4EFF4E4E4EFF4E4E4EFF252525AE000000000000000000000000989B99ED4344
      43FF292A29FF292A29FF272827FF242524FF232423FF232423FF232423FF2324
      23FF242524FF424342FF989B99ED000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008D8D8DFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF8D8D8DFF111111754E4E4EFF5D5D5DFFC4C4
      C4FFFBFBFBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFB
      FBFFC4C4C4FF5F5F5FFF4E4E4EFF111111750000000000000000373737FF2A2B
      2AFF2A2B2AFF2A2B2AFF252625FF1C1D1CFF181818FF181818FF181818FF1818
      18FF1D1D1DFF252625FF373737FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008B8B8BFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFC6A584FF9E6A33FF9E6A33FFC4A482FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF8B8B8BFF2B2B2BBD4E4E4EFFC9C9C9FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFC9C9C9FF4E4E4EFF2B2B2BBD0000000000000000262626FF2C2D
      2CFF2C2D2CFF2C2D2CFF303130FE000000000000000000000000000000000000
      00000303031D262726FF262626FF000000000101012301010133010101330101
      0133010101330101013301010133010101330101013301010133010101330101
      0133010101330101013301010133010101238B8B8BFFFFFFFFFFFFFFFFFF8181
      82FF83878AFFA16B33FFF0D9BBFFE0BC8FFF9D6830FFFFFFFFFF5D5E5EFF9E9E
      9EFF9C9C9CFF9A9A9AFFFFFFFFFF8B8B8BFF4A4A4AFA4E4E4EFFFBFBFBFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFBFBFBFF4E4E4EFF4A4A4AFA0000000000000000272827FF2E2F
      2EFF2E2F2EFF2E2F2EFF313231FE000000000000000000000000000000000000
      00000303031D282928FF272827FF000000004E4E4FC08F9297FF8D9299FF8D93
      9BFF8D939BFF8D929AFF8D9299FF8D929AFF8D9197FF8C8D8FFF8B8B8BFF8A8A
      8AFF8A8A8AFF8B8B8BFF8D8D8DFF4D4D4DC08B8B8BFFFFFFFFFFFEFEFEFF8383
      84FFFFFFFFFFCFB08CFFAD7A42FFAD7A42FFCCAD8AFFFBFEFFFFFBFCFCFFFBFB
      FBFFFAFAFAFFFAFAFAFFFFFFFFFF8B8B8BFF4E4E4EFF4E4E4EFFFFFFFFFFFFFF
      FFFFFFFFFFFF666666FF565656FF565656FF565656FF565656FF666666FFFFFF
      FFFFFFFFFFFFFFFFFFFF4E4E4EFF4E4E4EFF00000000000000002A2B2AFF3132
      31FF313231FF313231FF343534FE000000000000000000000000000000000000
      00000303031D2C2D2CFF2A2B2AFF000000008F9297FFF8C47BFFF2BE77FFDB99
      41FFDB9943FFF1C07AFFF1BF79FFDB9A43FFDC983DFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF8D8D8DFF8B8B8BFFFFFFFFFFFAFAFAFF8383
      83FFFDFFFFFFFAFFFFFFFCFFFFFFFCFFFFFFF9FEFFFFF4F7F9FFF4F4F4FFF3F4
      F4FFF3F3F3FFF4F4F4FFFFFEFEFF8B8B8BFF4E4E4EFF4E4E4EFFFFFFFFFFFFFF
      FFFFFFFFFFFF565656FF565656FF565656FF565656FF565656FF565656FFFFFF
      FFFFFFFFFFFFFFFFFFFF4E4E4EFF4E4E4EFF00000000000000002C2C2CFF3334
      33FF333433FF333433FF373937FE00000000000000002B2C2B6CEAEFEBFFEAEF
      EBFFDFE4E0FF313231FF2C2C2CFF000000008D9197FFE6B26DFFEFC383FFEEC4
      86FFD79C4EFFD79C4EFFEEC486FFEDC283FFDA9F4DFFF6FAFFFFF5F5F6FFF5F4
      F4FFF5F4F4FFF6F5F5FFFFFFFFFF8B8C8CFF8B8B8BFFFFFEFEFFF8F7F6FF8585
      85FFFFFFFFFFC2A281FF9F6B35FF9F6B35FFC0A07FFFF5F7F9FFF6F5F4FFF5F4
      F3FFF5F4F2FFF4F3F2FFFFFEFEFF8C8C8CFF4E4E4EFF4E4E4EFFFFFFFFFFFFFF
      FFFFFFFFFFFF565656FF565656FF565656FF565656FF565656FF565656FFFFFF
      FFFFFFFFFFFFFFFFFFFF4E4E4EFF4E4E4EFF00000000000000002E2F2EFF3637
      36FF363736FF363736FF3F403FFFEAEFEBFFEAEFEBFF9C9F9CFF353635FF3637
      36FF363736FF363736FF2E2F2EFF000000008C9095FFF0C792FFD89E4EFFF1C8
      8EFFF1C98EFFD9A055FFD9A055FFF1C78CFFF0C281FFEBEFF4FFEBEAEBFFEBEA
      E9FFEBEAE9FFEBEAE9FFFCFBFBFF8B8C8CFF8B8C8CFFFEFDFDFFF5F4F3FF8787
      88FF878B8FFFA26D35FFF0DABCFFE1BD90FF9E6A32FFF5F8FBFF606162FFA0A0
      A0FF9E9F9FFF9C9D9DFFFFFEFEFF8C8C8CFF4E4E4EFF4E4E4EFFFFFFFFFFFFFF
      FFFFFFFFFFFF565656FF565656FF565656FF565656FF565656FF565656FFFFFF
      FFFFFFFFFFFFFFFFFFFF4E4E4EFF4E4E4EFF0000000000000000313231FF393A
      39FF393A39FF393A39FF393A39FF393A39FF393A39FF393A39FF393A39FF393A
      39FF393A39FF393A39FF313231FF000000008C8F92FFFFF3D5FFDCA253FFDBA4
      56FFF5CD91FFF5CE91FFDDA65AFFDDA556FFF5CA87FFE2E5E9FFE3E2E2FFE3E2
      E1FFE2E1E0FFE3E2E1FFFCFBFBFF8C8C8CFF8C8C8CFFFDFCFCFFF1F1F0FF8687
      88FFF7FAFCFFCBAB89FFAE7B41FFAD7B41FFC8A885FFEFF1F2FFEFEFEEFFEFEE
      EDFFEFEEECFFEEEDECFFFDFCFCFF8C8C8CFF4E4E4EFF4E4E4EFFFFFFFFFFFFFF
      FFFFFFFFFFFF565656FF565656FF565656FFCBCBCBFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF4E4E4EFF4E4E4EFF0000000000000000333433FF3C3D
      3CFF3C3D3CFF3C3D3CFF3C3D3CFF3C3D3CFF3C3D3CFF3A3B3AFF353635FF3334
      33FF333433FF333433FF2C2D2CFF000000008D8F91FFFFFFEDFFFFF1CFFFF5D4
      A7FFF8DBB2FFFFF0CFFFFFF1D1FFF5D5A8FFF9DBAEFFF4F5F8FFF4F4F4FFF5F3
      F2FFF4F3F2FFF5F4F3FFFFFFFFFF8E8E8EFF8C8C8CFFFEFEFFFFEFEFF2FF858A
      8EFFF1F4FAFFEDF1F7FFECEFF4FFEBEDF2FFEAEAEDFFE8E7E8FFE8E6E6FFE8E5
      E6FFE7E5E5FFE7E5E5FFFCFBFBFF8C8C8CFF4E4E4EFF4E4E4EFFFFFFFFFFFFFF
      FFFFFFFFFFFF565656FF565656FF666666FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF4E4E4EFF4E4E4EFF0000000000000000363736FF3F40
      3FFF3F403FFF3F403FFF3F403FFF3F403FFF3F403FFF383938FF2D2D2DFF2A2B
      2AFF2C2D2CFF2B2C2BFF252625FF00000000818282EF8D8F91FF8C8E92FF8C8F
      93FF8C8F93FF8B8E92FF8B8E92FF8C8F93FF8C8E92FF8C8D8EFF8C8C8DFF8C8C
      8CFF8C8C8CFF8C8C8CFF8E8E8EFF818181EF8C8C8DFFFFFFFFFFBC9C7BFFA36F
      38FFA26E37FFBC9C7CFFE9EAEEFFE9E8E9FFE9E7E7FFE8E6E6FFE6E4E4FFE4E2
      E3FFE3E1E1FFE3E1E1FFFCFBFBFF8C8C8CFF484848F64E4E4EFFF9F9F9FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFF9F9F9FF4E4E4EFF484848F60000000000000000373837FF4142
      41FF414241FF414241FF414241FF414241FF414241FF383938FF0202020FEAEF
      EBFFEAEFEBFFEAEFEBFF3F414084000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008C8D8DFFFFFFFFFF9F6A32FFF0DA
      BCFFE2BE91FFA06B34FFE8E9ECFF636465FFA2A3A3FFA1A1A1FF9E9F9FFFE2E0
      DFFFE0DEDDFFE0DDDCFFFCFDFBFF8C8C8CFF2A2A2ABA4E4E4EFFCBCBCBFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFCBCBCBFF4E4E4EFF2A2A2ABA0000000000000000393A39FF4445
      44FF444544FF444544FF444544FF444544FF444544FF3B3B3BFF0303031D393A
      39FF3D3E3DFF303130FF0A0A0A84000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008C8D8DFFFFFFFFFFC4A480FFAE7B
      42FFAF7C42FFC5A581FFE2E2E3FFE2E0E0FFE2E0DFFFE1DFDEFFE0DEDDFFDEDC
      DBFFDDDBD9FFDCDAD9FFFFFEFEFF8C8C8CFF121212784E4E4EFF616161FFC9C9
      C9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFC9C9C9FF616161FF4E4E4EFF121212780000000000000000363736FF4243
      42FF454645FF464746FF464746FF464746FF464746FF3C3D3CFF0303031D3535
      35FF313231FF0A0B0A8400000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008E8F8FFFFFFFFFFFF7F7FAFFF7F9
      FDFFF7F9FEFFF7F7FAFFF5F4F5FFF5F3F3FFF5F3F3FFF5F3F3FFF5F3F3FFF5F2
      F2FFF4F2F2FFF4F2F2FFFFFFFFFF8E8E8EFF00000000262626B14E4E4EFF4E4E
      4EFF4E4E4EFF4E4E4EFF4E4E4EFF4E4E4EFF4E4E4EFF4E4E4EFFFFFFFFFFFFFF
      FFFF4E4E4EFF4E4E4EFF262626B10000000000000000000000002A2B2BED3737
      37FF3C3D3CFF3D3E3DFF3D3E3DFF3D3E3DFF3D3E3DFF363736FF0303031D2A2B
      2AFF0B0B0B840000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000818181EF8E8F8FFF8D8D8EFF8D8D
      8EFF8D8E8EFF8D8D8EFF8C8D8DFF8C8D8DFF8C8D8DFF8C8D8DFF8C8D8DFF8C8D
      8DFF8C8C8DFF8C8D8DFF8E8E8EFF818181EF0000000000000000111111752E2E
      2EC34E4E4EFF4E4E4EFF4E4E4EFF4E4E4EFF4E4E4EFF4E4E4EFFFFFFFFFFFFFF
      FFFF2E2E2EC311111175000000000000000000000000000000000303033F1718
      17C9282928FF292929FF292929FF292929FF292929FF262726FF0101010F0909
      0981000000000000000000000000000000000000000000000000010101060101
      0110010101190101011A0101011A0101011A0101011A0101011A0101011A0101
      011A0101011A01010119010101150101011000000000000000000203073F070D
      218104071064010101360101013601010136010101360101013601741FF7047B
      1EFF010602500101013601010136010101200000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D4632CFF0000
      0000000000000000000000000000000000000101013301010133010101330000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000101010B0101
      0120020101330403013E0704014306030141321A02A6623203CC623203CC6232
      03CC623203CC623203CC301902A30101011F01010106030303212C4BA4FF355D
      AEFF2142AAFFDCDCDCFFD8D8D8FFD4D4D4FFD2D2D2FFD1D1D1FF0A8532FF43A0
      5FFF158231FFADBFB0FFC7C7C7FF010101360000000000000000808080FF8080
      80FF808080FF808080FF808080FF808080FF808080FFD4632CFFFED761FFD463
      2CFF000000000000000000000000000000003B81ACFF3A81ABFF3B81ACFF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000202
      01190C070243130D034E1A120454100C033F653504CCFDBC29FFFCB81EFFFCB8
      1EFFFDC034FF653504CC150B025C000000000808082EBBBBBBF4C3C5CAFFBFC5
      CCFF2143ABFFFDFDFDFF229652FF1C904AFF168E44FF118A3CFF3A9E5EFF80C0
      95FF46A262FF188834FFD5E9D9FF0101013600000000808080FFDADADAFFDADA
      DAFFDADADAFFDADADAFFDADADAFFDADADAFFD4632CFFFED761FFFED761FFFED7
      61FFD4632CFF0000000000000000000000003980ABFF6CB2D4FF3981ABFF0000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000004030122190F
      035F2E230A6D2E21066D2D21066C110C0440693907CCF8B62BFFF6AC15FFF8BA
      36FF693907CC2D1804850000000000000000010101061A1A1A606379B2FF618E
      BEFF2246ADFFFAFAFAFF299A5BFF8FCAA8FF8CC8A4FF89C5A0FF87C49DFF6AB5
      84FF81C196FF48A466FF158633FF0109035C00000000808080FFDADADAFFDADA
      DAFFDADADAFFDADADAFFDADADAFFD4632CFFFED761FFFED761FFFED761FFFED7
      61FFFED761FFD4632CFF00000000000000003980AAFF6AB0D3FF3980ABFF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000002010110271705784E3C
      16904D380F904B3713912B1C0878080502336C3C0ACCF1B33AFFF3B944FFEEA8
      25FFF1B33AFF62370ABF0302011A000000000808082EBBBBBBF4C3C5CAFFBFC5
      CCFF2249ADFFFAFAFAFF319E63FF93CDACFF6FB98DFF6BB788FF66B584FF61B2
      80FF67B481FF82C197FF3C9F5CFF017D25FD00000000808080FFEEEEEEFFEEEE
      EEFFEEEEEEFFEEEEEEFFD4632CFFFFF3B7FFFFF3B7FFFED761FFFFEA73FFFED7
      61FFFFF3B7FFFFF3B7FFD4632CFF000000003980AAFF6AB0D3FF3881AFFF0000
      0000000000000000000000000000000000000101010F01010132010101330101
      013301010133010101210101010A0000000000000000110A034D573B16A67455
      1FB4705222B2321D0788080502320000000071410ECCF0BD5DFF71410ECCECB1
      49FFE8A83CFFA2712AE32013046C00000000010101061A1A1A60647CB2FF6391
      C0FF234BAEFFF9F9F9FF37A26BFF95CEAFFF93CDACFF90CBA9FF8FCBA7FF74BB
      8FFF89C7A0FF46A468FF0A8736FF010302420000000000000000808080FF8080
      80FF808080FF808080FF808080FFD4632CFFD4632CFFFFEA73FFFFEA73FFFFEA
      73FFD4632CFFD4632CFF00000000000000003980ABFF69B2D6FF3685B6FF0101
      01200101010D0000000000000000000000000B0B0B6D4C4C4CFB4B4B4BFF4444
      44FF444444FF242424B90707075D0101011F000000003821098C936F36CFA177
      37D66C481DBA100A034A0000000000000000754611CC754611CC3E250A949665
      28DCE3A84FFFCF9B4CF54E2E0BA6000000000808082EBBBBBBF4C3C5CAFFBFC5
      CDFF234EB0FFFAFAFAFF3DA46FFF39A36EFF35A168FF319D62FF55AE7CFF90CB
      A9FF4FAA74FF198F46FFC8CECAFF0101013800000000808080FFDADADAFFDADA
      DAFFDADADAFFDADADAFFDADADAFFDADADAFFD4632CFFFFEA73FFFFEA73FFFFEA
      73FFD4632CFF0000000000000000000000003980ABFF67ACCFFF4E4947FF2321
      21B10A0A0A690101013301010133010101334E4E4EFF4D4D4DFF4E4E4EFFFFFF
      FFFFFCFBF9FF737271FF464747FF202020AD000000006E4312C1CEA15BF1CC9D
      58F16E4312C1000000000000000000000000452A0C991910055C000000007A4A
      15CCE5B062FFE7B467FF7A4A15CC00000000010101061A1A1A60657FB4FF6493
      C1FF2451B1FFFAFAFAFFF8F8F8FFE09E73FFDD9C71FFDC996EFF389E63FF5AB2
      81FF289757FFE3E7E5FFECECECFF0101013600000000808080FFDADADAFFDADA
      DAFFDADADAFFDADADAFFDADADAFFDADADAFFD4632CFFFFEA73FFFFEA73FFFFEA
      73FFD4632CFF0000000000000000000000003880ACFF68B5DCFF4E4642FF4543
      42FF4C4C4CFF4B4B4BFF444444FF414141FF434343FF444444FF404040FFFFFF
      FFFFF6F5F3FF6A6968FF7D7C7BFF4B4B4BFF000000007F4F19CCE9B870FFE6B4
      6DFF7F4F19CC000000001B11065C482D0F990000000000000000000000007146
      16C1CDA161F1D0A564F1714616C1000000000808082EBBBBBBF4C3C5CAFFBFC7
      CDFF2552B1FFFBFBFBFFFAFAFAFFF8F8F8FFF8F8F8FFF8F8F8FF3FA570FF319E
      65FFEBEFEDFFF0F0F0FFDADADAF40101013300000000808080FFEEEEEEFFEEEE
      EEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFD4632CFFFFF3B7FFFFF3B7FFFFF3
      B7FFD4632CFF0000000000000000000000003880ACFF67B5DCFF4A423FFF7B78
      76FF3F3E3EFF454443FFF2F1F0FFFFFFFFFFFFFFFFFF777574FF404141FF8E8B
      8AFF7C7A79FFDAD9D8FFB8B7B7FF454545FF00000000573813A6D6A865F5E8B5
      71FFA37436DC462C0F9484541CCC84541CCC0000000000000000120C044A7553
      27BAA48050D6997948CF3F280E8C00000000010101061A1A1A606681B4FF6595
      C2FF2555B3FFFAFAFAFFFAFAFAFFE0A176FFE09F76FFE09F74FFDF9D73FFDC9B
      72FFDC9A6FFFF2F2F2FFF2F2F2FD010101360000000000000000808080FF8080
      80FF808080FF808080FF808080FF808080FF808080FFD4632CFFD4632CFFD463
      2CFF000000000000000000000000000000003880ACFF66B4DBFF443D39FFE2E0
      DDFFACABAAFF908F8EFFEAE9E8FFFFFFFFFFFEFDFDFFC7C6C5FF3E3E3EFF615F
      5CFF52504FFFFBFAF9FFFFFFFFFF414141FF000000002719096CB58747E3EDBC
      77FFF1C67FFF88591FCCF7D38AFF88591FCC00000000090603323D280F88745E
      3AB2765F3BB4614826A6140D054D000000000808082EBBBBBBF4C3C5CAFFBFC7
      CDFF2656B4FFF9F9F9FFF9F9F9FFE1A278FFEABFA2FFEABFA1FFEABEA0FFEABD
      9FFFDF9D71FFF4F4F4FFF7F7F7FF0101013600000000808080FFDADADAFFDADA
      DAFFDADADAFFDADADAFFDADADAFFDADADAFFDADADAFFDADADAFFDADADAFFDADA
      DAFF808080FF0000000000000000000000003880ACFF66B3DAFF423B37FFEAE8
      E5FFEFEEEDFFFEFFFDFF6C696AFF7B7879FF6C6B6AFFF4F3F2FF383838FFE7E6
      E6FFC9C8C6FFD2D1D0FFFFFFFFFF414141FF000000000303021A7D5421BFF7CE
      84FFF2C27BFFF9D48AFFF7CE84FF8C5D22CC0A070333332612784F4128914F3F
      299050442C9032220E780202011000000000010101061A1A1A606782B6FF6698
      C3FF2659B6FFF8F8F8FFF8F8F8FFE1A47AFFE1A278FFE1A277FFE0A176FFE09F
      76FFE09F74FFF4F4F4FFFAFAFAFF0101013600000000808080FFDADADAFFDADA
      DAFFDADADAFFDADADAFFDADADAFFDADADAFFDADADAFFDADADAFFDADADAFFDADA
      DAFF808080FF0000000000000000000000003880ACFF66B3DBFF433C38FFC7C5
      C3FFB6B5B4FFE9E9E8FF6D6B6BFF7B7979FF6C6B6AFFE2E1E0FF353535FFFFFF
      FFFFF0EEECFF5E5D5CFFC5C3C4FF434343FF00000000000000003E2A11859061
      26CCFDD88EFFF9CC82FFFCD58AFF906126CC110E0A402E26196C2F26196D2F28
      1B6D21170A5F0504022200000000000000000808082EBBBBBBF4C3C7CAFFBFC7
      CDFF265BB6FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF5F5F5FFF5F5
      F5FFF5F5F5FFF3F3F3FFFAFAFAFF0101013600000000808080FFEEEEEEFFEEEE
      EEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEE
      EEFF808080FF0000000000000000000000003880ACFF66B4DBFF453D39FFBCBB
      BBFF333233FF3B3A38FFEBEAE8FFFFFFFFFFFBFAFAFFB5B4B4FF383838FFF1F1
      F1FFE8E7E6FFDBDBDAFFDDDDDDFF454545FF000000001F15095C936328CCFFE0
      94FFFED98DFFFED98DFFFFDD91FF936328CC110E0A3F1C170E5417120A4E110C
      054303020219000000000000000000000000010101061A1A1A606786B8FF6799
      C4FF275EB7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF5F5F5FFF4F4F4FFF4F4
      F4FFF4F4F4FFF2F2F2FFFBFBFBFF010101360000000000000000808080FF8080
      80FF808080FF808080FF808080FF808080FF808080FF808080FF808080FF8080
      80FF000000000000000000000000000000003880ACFF67B4DBFF463E3AFFEDEC
      EBFF9C9C9DFF838282FFE8E7E6FFFFFFFFFFF9F8F8FFD8D8D8FF404040FF4C4C
      4CFF6B6B6BFF737373FFD3D3D3FF484848FF00000000553A189995652ACC9565
      2ACC95652ACC95652ACC95652ACC553A18990504022006040225030202190101
      0106000000000000000000000000000000000808082EBBBBBBF4C3C7CAFFC0C7
      CDFF275FB7FFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFCFC
      FCFFFCFCFCFFFCFCFCFFFCFCFCFF010101360000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000003981ACFF69B6DCFF4B423CFF6E6C
      6AFF909090FFB5B4B4FFCDCCCCFFCCCBCBFFCACAC8FFA8A8A8FF474747FF0000
      00000404043109090957282828BC4D4D4DFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000011111148648AC1FF4978
      BDFF2861B9FF0101013601010136010101360101013601010136010101360101
      0136010101360101013601010136010101200000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001D3F54B13983B1FF1A313FA40D0C
      0C66302F2FCD474747FF454545FF434444FF454545FF444444F8171717880000
      0000000000000000000000000000000000000000000000000000000000000000
      0000010101060101011301010109000000000000000000000000000000000000
      00000000000000000000000000000000000000000000337D9FFF337D9FFF337D
      9FFF337D9FFF337D9FFF337D9FFF337D9FFF5D97B2FF8AB4C6FF3F88A9FF2573
      98FF1A8BBAFF1C8CBBFF09709CFF000000000000000000000000000000000000
      00000102012D17370ACD01010101000000000000000000000000000000000000
      0000000000000000000000000000000000000000000001010101010101070303
      03190B0B0B331717174C2020205B2121215C1919194F0D0D0D38734319BD7B58
      15B7694224B40000000000000000000000000000000000000000000000000000
      000001010122070734AB0101066F010101130000000000000000000000000000
      00000101010101010117010101190101010900000000337D9FFFB3ECFFFF95DE
      FBFF8DDDFAFF86DBF8FF81D7F9FFB4E6F7FFF7F9F8FF55A160FF258734FFEBF4
      ECFF1B80ABFF3DC9FFFF1789B9FF000000000000000000000000000000000102
      0221265913F11D550CEB00000000000000000000000000000000000000000000
      00000000000000000000000000000000000001010104030303181818184F4A4A
      4A9C787777D6A09F9FF2A09D9CF99F9B9AF9A2A1A0F3818080DDCE7624FFEEA9
      25FFD18148FF0101010600000000000000000000000001010103010101060101
      01060101024C0505FEFF0404B0F9111119C01313119B151515981B1A1A991A19
      199116161698222121B91010109E0101012F00000000337D9FFF9EE3FAFF7FD7
      F6FF79D5F8FF70D3F7FFA7E3F6FFF7FAF8FF61A86CFF409C4DFF5BB769FF2386
      31FFE0E9E2FF2693C0FF198DBEFF000000000000000000000000010203222359
      1EEC438A41FF1D570EEB184501DA184601DA184701DB184701DB184701DB1847
      01DB184501DA184501DA0D2502A000000000030303172525256C5F5C5CE77671
      6FFFC4C3C2FFDAD8D8FFCACBCAFFCAC9C8FFD7D6D5FFC6C6C6FFCF7924FFEEA9
      25FFD18248FF050505200101010400000000000000000101025B0101047D0101
      047601010A8E0101EAFD0101FFFF3131D8FFA7A7ACFFD7D7CFFFD5D5D5FFFAF9
      F9FFA4A4A4FFCABFBFFF545050C90101010E00000000337D9FFFA9E6FDFF61A4
      C1FF4499BEFF95C7D9FFF7FAF8FF63A96EFF3F9D4DFF60C170FF60C170FF5ABC
      6AFF268834FFA2C4C7FF016797FF000000000000000001030425245619EC4689
      42FF388B3AFF37A23BFD2CA431F226AE2FF221B82DF21CB92AF218B423F211A5
      1BF20D8A14F00E7413F51C570CF00000000013131353777675F2A8A7A6FFA1A1
      9FFF898687FF91908FFF8D8988FF8C8B88FF939290FF8C8B89FFD07823FFEEA9
      25FFD18248FF1E1E1E6B00000000000000000000000002028DE30303DEFF0101
      DCFF0101E2FF0101F0FF0101F4FF0101FAFF2E2ECDFFB2B1B7FFCECFCBFFC6C6
      C6FF8D8E8EFFCABFBFFF494444C40101011000000000337D9FFFB0E7FDFF94DE
      FAFFA1E4FCFFF7FAF8FF60A86BFF3FA04DFF5FC870FF5FC870FF53BB64FF5FC8
      70FF5AC26AFF268835FF3A8299FF0000000000000000194315D548893BFF388E
      3BFF33AC37FF2FC437FF2ED639FF29E138FF24E935FF1BE72CFF11DB21FF07C6
      13FF01A106FF017003FF185D09F8000000003C3C3ABCB7B6B5FF6D6B69FF6F6B
      6AFFCACAC9FFE1E1E0FFCAC9C8FFCF7823FFCF7823FFCF7824FFCF7823FFEEA9
      25FFD18248FFD18248FFD18148FFCC7323FF00000000090994E42F2FEAFF2626
      E7FF1D1DEBFF1616ECFF1111EEFF0909EEFF0505EFFF4647D4FFF2F2F1FFB1B1
      AFFF7D7E7EFFCABFBFFF4A4545C40101011000000000337D9FFFBAEDFEFF61A4
      C1FF70B0CBFFF7F9F8FF54A261FF3FA44EFF5ECE71FF369644FF3E964BFF3FA5
      4FFF5ECE71FF59C86BFF278937FF010201160000000002050835175A17EB0EA3
      11FF29C937FF44D254FB4AC358EA5CCD68EA63CE6FEA58CE61EA45C649E83AB7
      47F02ABF3AFF028F07FF18630AF800000000848281ED9A9897FFA4A3A2FFA6A4
      A3FF8E8D8CFF90918EFF8C8987FF8B8887FFCF7823FFFFC32DFFFFC42DFFEEA9
      25FFDD8F32FFDD9032FFCC7323FF000000000000000012129BEB6A6AEEFF6868
      E9FF6A6AF2FF5B5BEEFF3E3EEBFF4444EDFF3636E9FF7D7CE8FFF2F2F1FF8988
      87FF6A6A6AFFCABFBFFF4A4646C40101011000000000337D9FFFBDECFEFFA3E3
      F9FF9FE2FAFFC5ECF9FFF7F9F8FF5BA766FF2E8F3CFF5BAC7CFFF4F7F5FF489C
      54FF3FA850FF5DD572FF57CE6CFF278635FA0000000002060A3802111E5D2176
      24F04AEB50FF29761CEA123402BA123502BA133502BB133502BB113101B6163F
      05C749D958FF09AB11FF186C0AF800000000A3A1A0FAB1B0AFFF73706FFF6765
      62FFB5B3B0FFC4C3C2FFB2B1B2FFB2B1B0FFC0BFBEFFCF7823FFFFC42DFFEEA9
      24FFDD9032FFCC7222FF000000000000000000000000040458B3141493D01313
      97D0151594D93030DBFE6161ECFF4646E8FF7A7ADDFFF1F1EBFFAAABA9FF6667
      66FF505151FFCABFBFFF4B4747C40101011000000000337D9FFFC6EFFDFFADE4
      FBFFA7E5FBFF9FE2FAFFAAE5FAFFCEEEF8FF89D3DDFF76D1F5FFB6E6F6FFF2F6
      F3FF469B53FF3FAB50FF5CDA73FF3EAE50FF000000000416277104223F801833
      458B378F35F4357B25EA000000000000000000000000000000000B195BBE0B23
      0E842E772FB2096C10C2155807DF000000009D9C99F6908D8BFF888685FFA1A0
      9FFFB1B0AFFFAEACAAFFB9B9B7FFBCBDB9FFB2B1B0FFB2B1B0FFCF7823FFEEA9
      24FFCC7222FFB1B0AFFF00000000000000000000000000000000000000000000
      0000010102282C2CCFFD5859E4FF6767CBFFEDECE8FFF0F0EDFFB6B7B7FFFFFF
      FFFF3B3C3CFFCABFBFFF4C4747C40101011000000000337D9FFFCFF3FFFF61A4
      C1FF58A0C0FF57A0C2FF53A0C1FF4C9BBDFF8CDCF9FF80D5F4FF76D1F5FFB7E6
      F6FFF0F5F2FF449A51FF3EAC50FF5CDD73FF00000000083154AB035197CB2258
      8EBE061226811E4D10C001010101000000000000000000000000233C8DE3284A
      9AF31029166A03180456103B04BC00000000939291F7A19F9EFF9F9E9CFFB2B1
      B1FFBBB9B7FFBFBEBCFFC2C0BDFFC3C2BEFFC3C2BFFFC2C0BEFFBDBCB9FFCF78
      23FF9C9B9BFFAAA8A7FF00000000000000000000000000000000000000000000
      0000010101201616B7F2635FBCFF898987FFEFEFEDFFF2F2F2FFF2F2F1FF3837
      37FF313131FFCABFBFFF4C4747C40101011000000000337D9FFFD2F3FFFFBFED
      FDFFBEEFFFFFB6ECFFFFACEAFFFFA4E6FEFF96DFFBFF8CDCF9FF83D9F8FF7AD5
      F8FFB8E7F6FFEFF5F1FF40994EFF3EA74EFF000000000D4E88DE0178E1FF208D
      F9FF208DF9FF010136A802033AAD01023AAD010239AC010238AB173488E23599
      FFFF0D3682EC0207022E0101010A00000000999897F6959391FFA6A4A2FFA7A6
      A3FFAAA8A7FFACABAAFFAFAEACFFB0AFACFFB0AFACFFAEACACFFABABA9FFAFAE
      ABFF9B9898FFABABA9FE00000000000000000000000000000000000000000000
      0000010101051C1A2EABC2B8BBFF8A8A87FFEAEAEBFFF2F2F1FFF2F2F1FF2626
      26FF1E1F1FFFCABFBFFF4C4848C40101011000000000337D9FFFDCF6FFFF61A4
      C1FF5DA1BFFF5DA3C2FF5BA2C2FF57A0C2FF53A0C1FF509FC1FF4C9DC0FF479B
      BEFF61A4C1FFC8EEFAFFF7F9F8FF479D53FF00000000124D87E10773D7FF0F7C
      E0FF1E77D1ED327CC9E24E8DCCE45A94CCE45390CBE43E83C6E42789ECF90278
      ECFF1772CDFF062954DD0103011B000000008A8887F5ABAAA8FFA7A6A4FFAAA9
      A7FFAEACABFFB0AFAEFFB2B1AFFFB2B2B0FFB2B1AFFFB0B0AEFFAFAEABFFACAB
      A9FFB2B1AEFFA09F9EFE00000000000000000000000000000000000000000000
      0000000000001E1C1998CCC2C0FF7F7F7FFFD6D7D6FFDEDDDEFFDEDDDEFF0909
      09FF090A0AFFCABFBFFF4D4949C40101011000000000337D9FFFDDF6FFFFCEF1
      FEFFCEF5FFFFC7F2FFFFBEEFFFFFB6ECFFFFACEAFFFFA4E6FEFF95DFFBFF8BDB
      F9FF80D7F6FFA2E3FBFF699FB7FF01010104000000002B5A8CE24896ECFF3999
      EDFF33AAFDFF48B7FFFF61C0FFFF61BFFFFF4BB5FFFF29A4FFFF0C8AF3FF1B86
      E0FF2888D8FF1C6BC4FF082041C900000000989695FAC2C0BDFFB6B5B3FFB8B7
      B6FFBBB9B8FFBDBCB9FFBEBDBBFFBEBDBCFFBEBDBBFFBDBCBBFFBCBBB8FFBBB9
      B7FFC4C3BFFFB0AFAEFF00000000000000000000000000000000000000000000
      0000010101011D1C1C9BCDC3C3FF5D5C5CFF666565FF6A6969FF6A6969FF1111
      11FF101010FFCABFBFFF4E4A4AC40101011000000000337D9FFFE5FBFFFF61A4
      C1FF63A3C0FF63A5C3FF61A4C1FF5DA3C2FF5BA2C2FF519CBEFF9FE2FAFF90DA
      F7FF86D8F5FFA8E5FCFF337D9FFF000000000000000039536ED277AAE0FB649F
      D1F45FA4D7F45AA8DBF45BAADFF553A7DFF5479DDBF54292D2F54997DCFD4395
      E0FF438FE0FF153270E90205022F00000000656563C1C8C8C6FFCBCAC9FFC9C6
      C5FFCAC9C8FFCBCAC9FFCBCBCAFFCCCBCAFFCBCBCAFFCBCAC9FFCAC9C8FFCBCA
      CBFFCFCECCFF848483DC00000000000000000000000000000000000000000000
      0000000000002220209BFFFCFCFFF1ECECFFF2EDEDFFF2EEEEFFF0ECECFFF0EA
      EAFFECE6E6FFFAF2F2FF555252C80101010C00000000337D9FFFE5F9FFFFD6F3
      FDFFD5F3FFFFCFF1FEFFC6EFFFFFC0EDFDFFB7EAFEFFB0E8FCFFA1E0F7FF99DD
      F6FF8EDAF6FFAFE8FCFF337D9FFF000000000000000001021365020328920202
      3BB202033CB202033CB202043DB302043EB402043DB301023BB21E2E76E594C1
      FDFF314E80E90104022A00000000000000000707072BA8A8A6EDDEDDDCFFE3E3
      E2FFE0E0DEFFDEDEDDFFE0DDDEFFE0E0DEFFE0DEDEFFE1E0E0FFE4E3E3FFE3E2
      E2FFBABAB9F80F0E0E4100000000000000000000000000000000000000000000
      000001010103020202480A0A0A640A0A0A640A0A0A640A0A0A640A0A0A640A0A
      0A640909096409090964040404570101010C00000000337D9FFFF9FFFFFFEAFA
      FFFFE6F9FFFFE4F9FFFFDEF6FFFFD9F5FFFFD3F3FFFFCEF1FFFFC8EFFEFFC1ED
      FEFFB9EAFDFFD3F6FFFF337D9FFF000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000002A3271E35A63
      99F10103022A0000000000000000000000000000000006060627666665B1E3E3
      E2FDF7F7F7FFFCFCFCFFFDFDFDFFFDFDFDFFFCFCFCFFF8F8F8FFE9E8E8FF7776
      76BF0A0A0A360000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000337D9FFF337D9FFF337D
      9FFF337D9FFF337D9FFF337D9FFF337D9FFF337D9FFF337D9FFF337D9FFF337D
      9FFF337D9FFF337D9FFF337D9FFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000171A36B90202
      0336000000000000000000000000000000000000000000000000000000000808
      082E2D2D2D73656565AA878787C88A8A8ACA6A6A6AAF3434347B0B0B0B370000
      0000000000000000000000000000000000000000000000000000000000000000
      0000010101180101014801010160010101600101016001010160010101480101
      011800000000000000000000000000000000000000000707072E121212521818
      18611F1E1F6C201E1F6D28252779272526782725277828252779201F206E201F
      206E19191962121212530707072F000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000001010120016AC6FF0176DCFF0179DDFF017CDFFF017EE0FF0177D1FF0101
      01200000000000000000000000000000000000000000050505240D0C0D420E0E
      0E482C35308F4F9E6DF335B065FF29B35DFF29B35EFF3CB069FF508765E21D21
      1E70100F104C0D0C0D4205050524000000000000000000000000000000000000
      0000020305230F142F7D293D8CDB3049ABF32C44AAF3223987DB0B132C7D0202
      0423000000000000000000000000000000000000000000000000000000000000
      00000000000001010118010E076B0101010D0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000010101200172DAFF0181F6FF0184F7FF0187F7FF018AF7FF0180E1FF0101
      0120000000000000000000000000000000000000000000000000000000001143
      269829B664FF2DB667FF30B668FF2FB468FF30B568FF30B668FF2CB667FF29B7
      64FF07190F5B000000000000000000000000000000000000000000000000080A
      16533645A1E63C52CCFF757AE8FF8E91EEFF8E91EEFF7178E4FF334DC0FF233C
      94E6050914530000000000000000000000000000000000000000000000000000
      0000010101100C4629B568E9A5FF08301CA00101010800000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000010101200172DAFF0181F6FF0183F6FF0186F7FF0189F7FF017FE1FF0101
      01200000000000000000000000000000000000000000000000001A6A3FBA2EBA
      6EFF2EBA6FFF2EBA6FFF29B86AFF35BC73FF2EB96FFF2CB96DFF2EBA6FFF2EBA
      6FFF2DBA6EFF0A25166B00000000000000000000000000000000090A17534351
      BAF45C65E0FFA0A5F5FF7E85EFFF5B63E9FF595DE7FF7D83EEFF9D9FF4FF515D
      D7FF2744A7F40509145300000000000000000000000000000000000000000101
      010E083B1EAF6AEAA4FFACFED4FF92EDBDFF0528149A01010106000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000010101200170D9FF0180F6FF0182F6FF0185F7FF0188F7FF017DE0FF0101
      012000000000000000000000000000000000000000000A28196F2DBE73FF2DBE
      73FF2DBE73FF29BC70FF46C583FFFFFFFFFFFFFFFFFF1EB96AFF2CBE72FF2DBE
      73FF2DBE73FF2DBF73FF02050325000000000000000002030522434EA7E5616B
      E3FFA0ABF5FF545FECFF505CEAFF4D59E9FF4E59E6FF4C56E6FF5056E6FF9DA1
      F4FF5460D6FF223C94E5020204220000000000000000000000000101010C0634
      1AAA3FDE85FF5EED98FF81F2B4FFADFDD6FF7AE4AAFF04221095010101040000
      0000000000000000000000000000000000000000000001010108010101180101
      012001010138016FD9FF017EF6FF0181F6FF0183F6FF0186F7FF017CDFFF0101
      0138010101200101011801010108000000000000000029C277FB29C077FF29C0
      77FF29C077FF24BF73FF51CD8FFFFFFFFFFFFFFFFFFF20BE72FF28C075FF29C0
      77FF29C077FF29C077FF176B42B800000000000000001618357E4B56DBFFA1AA
      F6FF5664F0FF5266EEFF4D59E9FF4D59E9FF4D59E9FF4D59E9FF4C58E6FF525A
      E6FF9EA2F5FF3450C3FF0B132D7E00000000000000000101010A022C13A522D1
      6EFF16DF68FF36E37BFF62EB9BFF78F0ACFF81F4B4FF53D68AFF031D0C900101
      0103000000000000000000000000000000000000000001010114010101400101
      015C010101680172DFFF017DF6FF017FF6FF0181F6FF0183F6FF017DE4FF0101
      01680101015C010101400101011400000000030E094528C77CFF28C57BFF20C3
      76FF15C06FFF10BF6CFF41CA89FFFFFFFFFFFFFFFFFF0CBE6BFF14BF6FFF15C0
      70FF23C378FF28C57BFF29CB7EFF000000000000000044489FDB818BEEFF7E90
      F7FF5D73F3FF4D59E9FF4D59E9FF4D59E9FF4D59E9FF4D59E9FF4D59E9FF4F5B
      E9FF7B82F0FF757BE2FF223889DB000000000101010A01250FA00EC45CFF06D4
      56FF01D551FF0BDD61FF33E379FF44E686FF40E583FF38E780FF28C869FF0218
      0A8B010101020000000000000000000000000000000001010110015CB3FF0167
      D0FF016DDEFF5FA8F4FF449DF8FF2890F7FF1087F7FF0281F6FF0181F0FF017D
      E4FF0179DBFF016FC6FF01010110000000000A2F1E7A26C97FFF1EC77AFF6AD9
      A5FFF9FDFCFFEEFAF5FFF0FBF7FFFFFFFFFFFFFFFFFFECFAF4FFEFFBF5FFF8FD
      FBFF41CF8FFF21C77CFF26CD81FF0207053100000000585CCBF6A0AAF7FF7085
      F8FF6881F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4D59
      E9FF5C66EAFF959BF1FF2E4AAEF6000000000117088901B646FF01C745FF0ECC
      50FF2BD668FF39DF76FF39E77BFF4CE585FF41E27EFF26DE6CFF14DC64FF10BA
      52FF011406850101010200000000000000000000000001010104041C3490398A
      E4FF73B1F7FF76B4FAFF76B6FAFF70B4F9FF65AFFAFF52A7F9FF3F9FF8FF3198
      F5FF1383E5FF0B28449C01010104000000000C3A258723CC81FF18C97CFF9CE7
      C6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF68DAA7FF1CCA7EFF26CF85FF030B073F000000005D61CCF6AEB8F9FF7F92
      FAFF7084F0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4D59
      E9FF5E6AEEFF959CF1FF3249B0F600000000015219C312C243FF4BCD6DFF71DA
      8EFF7DE39BFF47D275FB095121B154E084FF7FE9A2FF77E49AFF6CE090FF3AD7
      70FF01AE3EFF0116058E0101010200000000000000000000000001010104041C
      3590408EE5FF7FB8F7FF7DB9FAFF7AB8FAFF76B7FAFF71B6FAFF6AB2F7FF3290
      E7FF0A26419A0101010400000000000000000A2B1D7220CE84FF1FCE83FF2FD1
      8BFF81E3B9FF78E1B5FF92E7C3FFFFFFFFFFFFFFFFFF76E0B3FF7AE1B6FF7EE2
      B8FF20CE84FF1FCE83FF2ED58DFF0205042A000000004C4EA4DBA4AEF5FF9CAA
      FAFF778BF0FF545FECFF545FECFF545FECFF545FECFF545FECFF545FECFF6377
      F2FF818DF4FF787FE9FF2B3D8DDB00000000010E03654BC965FF9CE2ACFF99E4
      ACFF5BDB80FF0116086F00000000031D0C7A6AE590FF98E9B1FF93E5ABFF91E2
      A6FF46D170FF019F28FF01120289010101020000000000000000000000000101
      0104041C35904692E5FF87BDF8FF83BCFAFF7FBAFAFF78B7F8FF3890E7FF0823
      3D97010101040000000000000000000000000209063534DA94FF1FD086FF1ED0
      86FF17CE82FF12CD80FF41D799FFFFFFFFFFFFFFFFFF0ECC7FFF16CE82FF18CE
      82FF1FD087FF1ECF86FF36DE97FF00000000000000001B1A387E7D82EAFFCDD4
      FCFF8A9CFAFF7E92F7FF7589EEFF6C83F6FF6C83F6FF6C83F6FF6C83F6FF6379
      F3FFA3AEF8FF3E4FD0FF1015307E00000000000000000314067179D68CFF72DA
      8AFF0118077600000000000000000000000005200D807EE59AFFB3EBC2FFACE6
      BBFFABE5B7FF52C86EFF018D10FF010C01780000000000000000000000000000
      000001010104041C35904993E6FF8DC0F8FF86BDF8FF4092E6FF07213B950101
      0104000000000000000000000000000000000000000039C389EA19D288FF1ED4
      8BFF1ED48BFF19D288FF4BDCA1FFFFFFFFFFFFFFFFFF16D286FF1DD38AFF1ED4
      8BFF1DD48AFF20D38CFF1A5B409E0000000000000000030305225554B5E5A2A6
      F3FFD4DBFDFF8699FAFF7F90F0FF7A8DF1FF7F93F8FF7E91F9FF768BF8FFA7B5
      F8FF636EE3FF3846A1E502020422000000000000000000000000021A0877011C
      087A000000000000000000000000000000000000000006210C8493E5A7FFCEF0
      D5FFC7EACEFFC3E9C8FF5EC66EFF014205C40101010801010118010101200101
      01200101012001010124031E3A9F4B94E3FF4893E3FF05213EA2010101240101
      0120010101200101012001010118010101080000000004140E4843DF9EFF17D4
      8BFF1ED68EFF1CD58CFF21D68EFFC7F4E2FFB5F0D9FF10D386FF1DD68EFF1DD6
      8EFF15D38AFF52E5A6FF0101010C0000000000000000000000000C0C19536060
      CDF4A9ACF2FFD8DCFDFFADB9FAFF90A2FAFF8A9CFAFF9BA8FBFFB9C7FCFF707B
      E9FF4653BBF4080A165300000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000007220C88AAE8
      B4FFE8F7EAFFEAF8EDFF9FDDA4FF021C04850101011801010148010101600101
      016001010160010101600101016403244AB803244BB801010164010101600101
      016001010160010101600101014801010118000000000000000011412E8349E0
      A3FF14D48CFF19D58EFF1BD68EFF0ED488FF0FD488FF1BD68FFF18D58EFF16D5
      8DFF5AE6ABFF030E0A3B00000000000000000000000000000000000000000C0C
      19535656B6E68D92EDFFBDC2F8FFCCD3F9FFC3CBF9FFA9B3F4FF6670E2FF434C
      ABE6090B17530000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000924
      0D8DC6EDCAFFC1E9C3FF0B2B0C9A01010106010101180156B4FF015DCFFF015E
      D0FF015FD0FF0160D1FF0163D5FF0167DEFF0168DEFF0167D7FF0165D3FF0166
      D4FF0167D4FF0167D4FF0160BDFF010101180000000000000000000000000823
      195F5CECAFFF43E1A1FF14D78EFF16D78FFF16D78FFF1BD891FF4FE4A7FF4AC3
      91E60207052A0000000000000000000000000000000000000000000000000000
      0000030305231A1A377D4C4EA4DB595AC8F3575AC6F34549A0DB1618347D0303
      0523000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000101
      01010C31109F0E3910AA0101010400000000010101000156B4FF015DCFFF015D
      CFFF015ECFFF015FD0FF0160D0FF0161D1FF0161D1FF0162D2FF0163D2FF0164
      D3FF0164D3FF0165D3FF015DBAFF010101080000000000000000000000000000
      00000101010208251A66286A4FAD36916BCA338B67C61F5A429F04150E4C0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000D00000000100010000000000800600000000000000000000
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
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
  object ImageList32x32: TImageList
    ColorDepth = cd32Bit
    DrawingStyle = dsTransparent
    Height = 32
    Width = 32
    Left = 520
    Top = 160
    Bitmap = {
      494C01011900C800980320002000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      000000000000360000002800000080000000E0000000010020000000000000C0
      0100000000000000000000000000000000000000000000000000000000000000
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
      000000000000000000040000000D00000015000000150000000D000000040000
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
      0000000000000000000000000000000000000000000000000000000000040000
      000D0000000E000000120000002B0000003F0000003F0000002B000000120000
      000E0000000D0000000400000000000000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000000000002000000090000
      0012000000160000001600000016000000160000001600000016000000160000
      00160000001600000016000000160000001600000016000000160000001E0000
      002F000000320000002F393837C36A6866FF6A6866FF393937C40000002F0000
      00320000002E0000001500000004000000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000000000009000000220000
      003A000000430000004300000043000000430000004300000043000000430000
      0043000000430000004300000043000000430000004300000043000000473A3A
      3CC6605E5DF00000004D6A6866FFECEAE9FFECEAE9FF6A6866FF0000004D605F
      5DF13E3C3BC70000002E0000000D000000000000000000000000000000000000
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
      000000000000000000000000000000000000000000040000001B18110376B37C
      12FCB67D0EFFB67D0CFFB67C0CFFB67C0CFFB67C0CFFB67C0CFFB67C0CFFB67C
      0CFFB67C0CFFB67C0CFFB67C0CFFB67C0CFFB67D0CFFBB8009FF8C754BFF9A9A
      9EFFABA9A7FF6A6866FF959392FFDEDCDBFFDEDCDBFF8D8B8AFF6A6866FFABA9
      A7FF9E9C9CFF3C3A3ABF0000000F000000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000D0201003BB9851AFFE5D3
      A9FFF2EAD6FFF2E9D4FFF1E9D3FFF1E9D3FFF1E9D3FFF1E9D3FFF1E9D3FFF1E9
      D3FFF1E9D3FFF1E9D3FFF1E9D3FFF1E9D3FFF3EAD5FFF9EFD7FF868484FFA6A5
      A5FFDDDAD9FFD3D1CFFFDAD7D6FFD8D5D5FFD9D6D5FFDAD7D7FFD3D1CFFFDEDA
      DAFFABA9A7FF646361ED00000014000000040000000000000000000000000000
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
      00000000000000000000000000000000000000000014593F09BEE2CCA1FFFAF7
      EEFFF8F3E5FFF7F1E3FFF7F1E3FFF7F1E3FFF7F1E3FFF7F1E3FFF7F1E3FFF7F1
      E3FFF7F1E3FFF7F1E3FFF7F1E3FFF7F2E3FFFAF4E5FFFFFCECFFD0C2A7FF6D6A
      69FFCDCBCBFFD2D0D0FFB4B2B1FF878788FF818083FFB5B4B4FFD3D1D1FFCECC
      CBFF726F6DFF0A0A0A6D0000002C0000000D0000000000000000000000000000
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
      00000000000000000000000000000000000000000010AE7810F9FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA9A7A7FF6F6D6CFF8F8C
      8AFFCFCDCBFFB1AFAEFF787678FFC2AA7DFF6A501ED66B6B6DF7B4B2B1FFD0CE
      CCFF918E8CFF797573FF403F3DC1000000150000000000000000000000000000
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
      00000000000000000000000000000000000000000006B98418FFB67E0EFFB57B
      09FFB47907FFB27702FFB07200FFAF7000FFAF7100FFAF7100FFAF7100FFAF71
      00FFAF7100FFAF7100FFAF7100FFB07100FFB67500FF707075FFD4D2D3FFCDCB
      CAFFC8C5C4FF878584FFDDDBD8FFFDF1DAFF9A6700EA050506588D8C8BFFC9C6
      C5FFCDCCCBFFD7D5D5FF7C7A78FF000000150000000000000000000000000000
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
      00020504003BB57B0BFFFFFFFFFFEFE6CCFFF0E7CFFFF0E7CFFFF0E7CFFFF0E7
      CFFFF0E7CFFFF0E7CFFFF0E7CFFFF1E8D0FFF7EDD0FF737376FFEBE9EAFFE8E6
      E5FFC4C2BFFF8A8785FFD9D4C8FFFFFFFDFFBD7D00FF060607668A8887FFC4C3
      C1FFE9E7E6FFEEECEBFF807D7BFF0000000D0000000000000000000000000000
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
      000104030033B57B0AFFFFFFFFFFEFE5CAFFEDE2C7FFEEE2C8FFEEE2C8FFEEE2
      C8FFEEE2C8FFEEE2C8FFEEE2C8FFEFE3C8FFF3E7CAFFA6A096FF777475FF9E9B
      9AFFD1CFCEFFA8A4A3FF828080FFE6EAEFFFAB7D25FF837D79FFAAA8A7FFD2D0
      CFFFA09D9CFF817D7BFF403F3DB4000000040000000000000000000000000000
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
      000000000014B57C0BFFF7F0E3FFF4EDDBFFEEE2C7FFEEE3C8FFEEE3C8FFEEE3
      C8FFEEE3C8FFEEE3C8FFEEE3C8FFEEE3C8FFF1E5CAFFF7EBCEFFEFE2C8FF7C7A
      79FFB8B5B3FFCECCCAFFA6A3A3FF878686FF8D8B8DFFA8A6A7FFCECCCBFFB9B6
      B4FF827E7CFF000000320000000E000000000000000000000000000000000000
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
      0000000000118F620BE6F1E6D0FFF6F1E2FFEFE4C9FFEFE5CBFFEFE5CBFFEFE5
      CBFFEFE5CBFFEFE5CBFFEFE5CBFFEFE5CBFFF0E6CCFFF5EBCFFF948F8CFFB4B2
      B2FFE6E5E5FFE4E3E3FFEEECEBFFBBB9B7FFBBB9B8FFEEECECFFE5E4E4FFE7E6
      E6FFBAB8B6FF787573EE0000000D000000000000000000000000000000000000
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
      00000000000D7D560AD7E2CB9FFFFBFAF4FFF0E5CEFFF0E6CFFFF0E6CFFFF0E6
      CFFFF0E6CFFFF0E6CFFFF0E6CFFFF0E6CFFFF1E6D0FFF5EBD2FFACA79FFFABAA
      AAFFB9B8B7FF817E7DFFA4A1A1FFD7D5D3FFD8D6D4FFA7A3A3FF868482FFBFBD
      BBFFB4B3B1FF444442B600000004000000000000000000000000000000000000
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
      00000000000933240592DBC18BFFFEFDFAFFF1E8D1FFF1E8D2FFF1E8D2FFF1E8
      D2FFF1E8D2FFF1E8D2FFF1E8D2FFF1E8D2FFF1E8D2FFF3EAD4FFF9EFD7FFAFAA
      A1FF989491FFF9EFD7FF848181FFF1F0F0FFF2F2F3FF8B898AFF0000001B7B78
      77EB454443B30000000400000000000000000000000000000000000000000000
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
      000000000005271C0480CCA658FFFFFFFFFFF2EAD4FFF2EAD5FFF2EAD5FFF2EA
      D5FFF2EAD5FFF2EAD5FFF2EAD5FFF2EAD5FFF2EAD5FFF2EAD5FFF4ECD7FFF7EF
      D9FFF8F0DBFFFAF2DCFFB1ACA4FF868383FF88878AFFA0895CFF000000180000
      0001000000000000000000000000000000000000000000000000000000000000
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
      0000000000010A070146C89D46FFFFFFFFFFF3EBD7FFF3EBD7FFF3EBD8FFF3EB
      D8FFF3EBD8FFF3EBD8FFF3EBD8FFF3EBD8FFF3EBD9FFF3EBD9FFF3EBD9FFF4EB
      D9FFF4ECDAFFF5EDDBFFF8F0DCFFFEF8EAFFFFFFFFFFB87A00FF0000001F0000
      0005000000000000000000000000000000000000000000000000000000000000
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
      00000000000000000015B98114FFFFFFFFFFF4EDDCFFF4EDDCFFF4EDDCFFF4ED
      DCFFF4EDDCFFF4EDDCFFF4EDDCFFF4EDDCFFF4EDDCFFF4EDDCFFF4EDDCFFF4ED
      DCFFF4EDDCFFF4EDDCFFF5EDDCFFF5EEDCFFFFFFFFFFC5973AFF0B0801520000
      0009000000000000000000000000000000000000000000000000000000000000
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
      00000000000000000012B47A07FFFFFFFFFFF7F1E2FFF5EFDFFFF5EFDFFFF5EF
      DFFFF5EFDFFFF5EFDFFFF5EFDFFFF5EFDFFFF5EFDFFFF5EFDFFFF5EFDFFFF5EF
      DFFFF5EFDFFFF5EFDFFFF5EFDEFFF5EFDEFFFFFFFFFFCDA85BFF2A1D04890000
      000D000000000000000000000000000000000000000000000000000000000000
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
      0000000000000000000F785206D5F7F1E3FFFAF7EFFFF6F0E2FFF6F0E2FFF6F0
      E2FFF6F0E2FFF6F0E2FFF6F0E2FFF6F0E2FFF6F0E3FFF6F0E3FFF6F0E3FFF6F0
      E3FFF6F0E3FFF6F0E3FFF6F0E3FFF6F0E3FFFFFFFFFFDDC490FF3625049A0000
      0011000000000000000000000000000000000000000000000000000000000000
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
      0000000000000000000B674707C6F1E6D2FFFDFBF5FFF7F2E5FFF7F2E5FFF7F2
      E5FFF7F2E6FFF7F2E6FFF7F2E6FFF7F2E6FFF7F2E6FFF7F2E6FFF7F2E6FFF7F2
      E6FFF7F2E6FFF7F2E6FFF7F2E6FFF7F2E6FFFEFEFCFFEDE0C4FF7E5609DA0000
      0014000000000000000000000000000000000000000000000000000000000000
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
      0000000000000000000734240492E2CC9FFFFFFFFFFFF8F4E9FFF8F4E9FFF8F4
      E9FFF8F4E9FFF8F4E9FFF8F4E9FFF8F4E9FFF8F4E9FFF8F4E9FFF8F4E9FFF8F4
      E9FFF8F4E9FFF8F4E9FFF8F4E9FFF8F4E9FFFDFBF7FFF7F1E5FF906208E70000
      0016000000000000000000000000000000000000000000000000000000000000
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
      00000000000000000004110C015BDCC28DFFFFFFFFFFF9F5EDFFF9F5ECFFF9F5
      ECFFF9F5ECFFF9F5ECFFF9F5ECFFF9F5ECFFF9F5ECFFF9F5ECFFF9F5ECFFF9F5
      ECFFF9F5ECFFF9F5ECFFF9F5ECFFF9F5EBFFFCFAF5FFFFFFFFFFB37805FF0000
      0016000000000000000000000000000000000000000000000000000000000000
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
      000000000000000000010A070148C89E49FFFFFFFFFFFAF8F0FFFAF7EFFFFAF7
      EFFFFAF7F0FFFAF7F0FFFAF7F0FFFAF7F0FFFAF7F0FFFAF7F0FFFAF7F0FFFAF7
      F0FFFAF7F0FFFAF7F0FFFAF7F0FFFAF7F0FFFAF8F2FFFFFFFFFFC39638FF0000
      0027000000160000001600000011000000060000000000000000000000000000
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
      0000000000000000000000000014C89F4BFFFFFFFFFFFCFAF5FFFBF9F3FFFBF9
      F3FFFBF9F3FFFBF9F3FFFBF9F3FFFBF9F3FFFBF9F3FFFBF9F3FFFBF9F3FFFBF9
      F3FFFBF9F3FFFBF9F3FFFBF9F3FFFBF9F3FFFBFAF5FFFFFFFFFFC79C46FF0000
      0048000000430000004300000032000000100000000000000000000000000000
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
      000000000000000000000000000EA77006F7FFFFFFFFFEFEFBFFFCFAF6FFFCFA
      F6FFFCFAF6FFFCFAF6FFFCFBF6FFFCFBF6FFFCFBF6FFFCFBF6FFFCFBF6FFFCFB
      F6FFFCFBF6FFFCFBF6FFFCFBF6FFFCFBF6FFFCFCF7FFFFFFFFFFDCC18BFFBB87
      1EFFC3973CFFC49A40FFB98316FF000000140000000000000000000000000000
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
      0000000000000000000000000006533A06B3E7D6B2FFFFFFFFFFFDFDFBFFFDFC
      F9FFFDFCF9FFFDFCF9FFFDFCF9FFFDFCF9FFFDFCF9FFFDFCF9FFFDFCF9FFFDFC
      F9FFFDFCF9FFFDFCF9FFFDFCF9FFFDFCFAFFFDFCFBFFFFFFFFFFF0E4CDFFC497
      3CFFF3EDDAFFF1E9D2FFAF7912F90000000D0000000000000000000000000000
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
      000000000000000000000000000109060140C9A04DFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBE8B
      26FFFBF7F0FFE8D7B4FF543B09B2000000040000000000000000000000000000
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
      000000000000000000000000000000000004533A06B0D4B26EFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBF9
      F3FFCAA251FFB77E10FF00000015000000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000333230589B57B0AFFB479
      07FFB47906FFB47906FFB47906FFB47906FFB47906FFB47906FFB47906FFB479
      06FFB47906FFB47906FFB47906FFB47906FFB47906FFB47907FFB57B09FFB67D
      0EFFB07C15FA100B024F00000002000000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000000000000000000060000
      0011000000160000001100000006000000000000000000000000000000000000
      00000000000500000093000000F90C0C0CFF0E0E0EFF0E0E0EFF0E0E0EFF0E0E
      0EFF0E0E0EFF0E0E0EFF0E0E0EFF0E0E0EFF0E0E0EFF0E0E0EFF0E0E0EFF0E0E
      0EFF0E0E0EFF0E0E0EFF0E0E0EFF0E0E0EFF0E0E0EFF0B0A0AFF000000F50000
      007A000000020000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000005C43009F9C7200CF0000000F000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000500000010000000160000
      0016000000160000001600000016000000160000001600000016000000160000
      0016000000160000001600000016000000160000001600000016000000160000
      001600000016000000160000001600000016000000100000000A0000001C0000
      003700000043000000370000001C000000060000000000000000000000000000
      00000000008D0F0F0EFFA4A19DFFD8D4CFFFDAD6D1FFDAD6D1FFDAD6D1FFDAD6
      D1FFDAD6D1FFDAD6D1FFDAD6D1FFDAD6D1FFDAD6D1FFDAD6D1FFDAD6D1FFDAD6
      D1FFDAD6D1FFDAD6D1FFDAD6D1FFDAD6D1FFDAD6D1FFD6D3CDFF93918DFF0707
      07FE0000006A0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000005C43009FEEAD00FFEEAD00FF9C7200CF0000000F0000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000030303355F6060E85E6261E35E62
      61E35E6261E35E6261E35E6261E35E6261E35E6261E35E6261E35E6261E35E62
      61E35E6261E35E6261E35E6261E35E6261E35E6261E35E6261E35E6261E35E62
      61E35E6261E35F6161E42122228F000000000000000000000000000000000000
      0000000000000000000000000000000000000000001000000033000000420000
      0043000000430000004300000043000000430000004300000043000000430000
      0043000000430000004300000043000000430000004300000043000000430000
      004300000043000000430000004300000042000000350000002B0000003D4B80
      A8FF4B80A9FF4B82AAFF00000037000000110000000000000000000000000000
      0011000000F5A19F9CFFE8E5E2FFF9F8F7FFFBFAF9FFFBFAF9FFFBFAF9FFFBFA
      F9FFFBFAF9FFFBFAF9FFFBFAF9FFFBFAF9FFFBFAF9FFFBFAF9FFFBFAF9FFFBFA
      F9FFFBFAF9FFFBFAF9FFFBFAF9FFFBFAF9FFFBFAF9FFF8F7F6FFE6E3DFFF8280
      7DFF000000E70000000600000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000005C43009FEEAD00FFEEAD00FFEEAD00FFEEAD00FF9C7200CF0000
      000F000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000A0B0A5ACACCCBFFC6C7C7FFC7C8
      C8FFEBEDEDFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFE9EBEBFF3C3E3EC2000000000000000000000000000000000000
      000000000000000000000000000000000000000000169E9E9CF2AFAFADFFAEAE
      ABFFADADABFFADADABFFADADABFFADADABFFADADABFFADADABFFADADABFFADAD
      ABFFADADABFFADADABFFADADABFFADADABFFADADABFFADADABFFADADABFFADAD
      ABFFADADABFFADADABFFAEAEABFFB2B0ADFF9F9994ED0000004D4B80A8FF1E97
      EAFF28AAFFFF34B8FFFF4892C4FF000000160000000000000000000000000000
      0032070707FFDBD9D5FFF9F8F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6F5F3FFCAC8
      C5FF000000FC0000001A00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00005C43009FEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FF9C72
      00CF0000000F0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFBCBD
      BDFF979898FFB2B3B3FFE0E2E2FFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFE9EBEBFF3C3E3EC2000000000000000000000000000000000000
      00000000000000000000000000000000000000000016B0B0ADFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC1B7ACFF437BA7FF1E96E9FF28A7
      FFFF31B2FFFF4FC6FFFF4692C5FF000000110000000000000000000000000000
      0035090909FFE2E0DDFFFBFBFAFFFFFFFFFFFFFFFFFFFAFAF9FFF4F3F1FFF4F3
      F1FFF4F3F1FFF4F3F1FFF8F8F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9F8
      F8FFF4F3F1FFF4F3F1FFF4F3F1FFF4F3F1FFFAF9F9FFFFFFFFFFF8F8F7FFD2D0
      CDFF010101FD0000001C00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005C43
      009FEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FF9C7200CF0000000F00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFC5C7C7FF909191FF838484FF9A9B9BFFD2D4D4FFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFE9EBEBFF3C3E3EC2000000000000000000000000000000000000
      00000000000000000000000000000000000000000016AEAEABFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3474A6FF1894EAFF26A6FFFF2BAF
      FFFFD3F1FFFF47CBFFFF4493C8FF000000060000000000000000000000000000
      00350A0A09FFE4E3E1FFFCFBFBFFFFFFFFFFFFFFFFFFC4A762FFD6A42CFFD6A4
      2CFFD6A42CFFD6A42CFFC4A14CFFFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFC5A2
      50FFD6A42CFFD6A42CFFD6A42CFFD6A42CFFC4A55CFFFFFFFFFFFAF9F8FFD5D3
      D1FF010101FD0000001C00000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000004A36008FEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FF9C7200CF0000000F000000000000000000000000000000000000
      0000000000000000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFD2D4D4FF7D7E7EFF858585FF7B7B7BFF828383FFB8BABAFFE6E7
      E7FFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFE9EBEBFF3C3E3EC2000000000000000000000000000000000000
      00000000000000000000000000000000000000000016ADADABFFFFFFFFFFFEFE
      FEFFFFFFFFFF959595FFC3C3C3FFC2C2C2FFC0C0C0FFFFFFFFFF969696FFC3C3
      C3FFC3C3C3FFC2C2C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF6F6763FF6993AFFF1BA5FFFF27AEFFFFCCEE
      FFFFD7FAFFFF3E8DC3FF00000008000000000000000000000000000000000000
      00350A0A0AFFE7E6E4FFFCFCFCFFFFFFFFFFFFFFFFFFC7A557FFDFA927FFDFA9
      27FFDFA927FFDFA927FFCAA242FFFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFC9A2
      46FFDFA927FFDFA927FFDFA927FFDFA927FFC8A451FFFFFFFFFFFBFAFAFFD7D6
      D4FF010101FD0000001C00000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000805002FD198
      00EFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FF9C7200CF0000000F0000000000000000000000000000
      0000000000000000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFE1E3E3FF898A8AFF6E6E6EFF7C7C7CFF757575FF7172
      72FFA7A8A8FFD9DADAFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFE9EBEBFF3C3E3EC2000000000000000000000738000000010000
      00000000000000000000000000000000000000000016ADADABFFFFFFFFFFFCFC
      FCFFFDFDFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFCACBCAFF8D8B8BFF625F5FFF636060FF636060FF625F
      5FFF8E8C8CFFD0D1D0FF6E6B69FF9A9692FFADA39BFF80AECBFFC5EEFFFFD3F9
      FFFF388CC3FF0206083800000001000000000000000000000000000000000000
      00350A0A0AFFEAE9E7FFFDFDFCFFFFFFFFFFFFFFFFFFEFEDE8FFE5E0D5FFDBD6
      CBFFD6D1C5FFE5E0D5FFECE9E3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFECEA
      E4FFE5E0D5FFD7D2C6FFDBD6CAFFE5E0D5FFEEECE7FFFFFFFFFFFCFBFBFFDAD9
      D7FF010101FD0000001C00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000805
      002FD19800EFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FF9C7200CF0000000F00000000000000000000
      0000000000000000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFEAECECFFA5A6A6FF696969FF6D6D6DFF7878
      78FF717171FF696969FF868787FFBEBFBFFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFE9EBEBFF3C3E3EC20000000000001A6500009DF9000000060000
      00000000000000000000000000000000000000000016ADADABFFFFFFFFFFFBFB
      FBFFFCFCFCFFFFFFFFFFFFFFFFFFFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFF2F3F3FF848281FF858384FFBABBBFFFE0E4E7FFDFE3E8FFDFE3E8FFE0E3
      E7FFBABBBFFF898789FF767373FFA29F9DFFB3B0ACFFF5EFEBFFF3FCFCFF338B
      C5FF000000060000000000000000000000000000000000000000000000000000
      00350A0A0AFFECEBE9FFFDFDFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBEBE
      BEFFA1A1A1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFA7A7A7FFB9B9B9FFFFFFFFFFFFFFFFFFFFFFFFFFFCFCFBFFDCDB
      D9FF010101FD0000001C00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000805002FD19800EFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FF9C7200CF0000000F000000000000
      0000000000000000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFBEBFBFFF6D6E6EFF6969
      69FF6A6A6AFF6E6E6EFF6A6A6AFF696969FFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFE9EBEBFF3C3E3EC20000165E000095EA00008BE3000000060000
      00000000000000000000000000000000000000000016ADADABFFFFFFFFFFFAFA
      F9FFFCFCFBFF959595FFC1C1C1FFFFFFFEFF979797FFC3C3C3FFC4C4C4FFF3F2
      F3FF6F6D6DFFAFAFB0FFE6E3DCFFF4D0A0FFFFC67CFFFFC375FFFFC374FFFEC4
      7BFFF4CF9FFFE7E4DDFFB2B3B4FF6F6C6CFFEEEEEDFFFFFDFCFFA0938BFF0000
      0006000000000000000000000000000000000000000000000000000000000000
      00350A0A0AFFEDEDECFFFDFDFDFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFBAC2
      D8FFACB6D2FFFDFDFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFCFCFCFFFCFCFCFFFFFFFFFFFFFFFFFFFFFFFFFFFDFDFCFFDDDD
      DCFF010101FD0000001C00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000805002FD19800EFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FF9C7200CF0000000F0000
      0000000000000000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFD1D3D3FF8385
      85FF696969FF696969FF696969FF6A6B6BFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFE9EBEBFF2B2C60D9000095EA0000CBFF00008AE2000000060000
      00000000000000000000000000000000000000000016ADADABFFFFFFFFFFF9F8
      F8FFFAF9F9FFFDFCFCFFFDFBFBFFFBFAFAFFFDFCFCFFFFFEFEFFFFFFFFFF8685
      83FFB9BABCFFE8E1D7FFF8C076FFF1BF76FFEBC681FFEECF8AFFF2D791FFF4D9
      94FFF7CC83FFF7BD74FFE7E0D7FFB1B1B4FFDEDEDEFF9A9693FF0000000D0000
      0000000000000000000000000000000000000000000000000000000000000000
      00350A0A0AFFEFEEEDFFFEFEFDFFFFFFFFFFFFFFFFFFEDEFF2FF6883CBFF2458
      EBFF2358EDFF5B78CCFFE6E8EEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFE6
      ECFFD4DEE7FFD4DEE7FFD4DEE7FFD4DEE7FFEBEEF1FFFFFFFFFFFDFDFDFFDEDD
      DDFF010101FD0000001C00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000805002FD19800EFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FF9C7200CF0000
      000F000000000000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFDCDEDEFFCDCECEFFCACBCBFFE2E4E4FFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFF8789D0FF0505A9FB0000CCFF0000CCFF000091E7000044A20000
      42A0000042A0000042A00000419F0000021F00000016ADADABFFFFFFFFFFF8F7
      F7FFF9F8F8FFFCFBFBFFFBFAFAFFFAF9F9FFFAF9F9FFFEFDFDFFCAC9C8FF8B8A
      8AFFEBE7E0FFEFB971FFEABB75FFEBC27AFFF1CD86FFF6D790FFF8DF98FFFBE6
      9DFFFAE7A0FFF7DB92FFECB56EFFEAE6E1FF908F8FFF100F0F72000000100000
      0000000000000000000000000000000000000000000000000000000000000000
      00350A0A0AFFF0F0EFFFFEFEFEFFFFFFFFFFB5BDD5FF315DDAFF2359F1FF3B6B
      F2FF5F87F5FF2359F1FF2C5BDEFFA4AFD1FFF7F7F7FF929292FFEFEFEFFF308E
      DDFF1D91F3FF1D91F3FF1D91F3FF1D91F3FF5F9CD0FFFFFFFFFFFEFEFDFFDFDF
      DEFF010101FD0000001C00000000000000000E0A003F0E0A003F0E0A003F0E0A
      003F0E0A003F0E0A003F0E0A003F0E0A003F0E0A003F0E0A003F0E0A003F0E0A
      003F0E0A003F0E0A003F0E0A003F2D20006FEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FF9C72
      00CF0000000F0000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFF8C8ED2FF1414B8FF0000CCFF0000CCFF0000CCFF0000CAFF0000C7FF0000
      C7FF0000C7FF0000C7FF0000B6FC00000F5000000016ADADABFFFFFFFFFFF7F6
      F6FFF9F8F8FF969696FFC0BFBFFFFAF9F9FFBEBDBDFFFFFFFFFF929090FFC6C8
      CAFFECC795FFF4C282FFFBCF91FFFFD087FFFFD481FFFFDF88FFFFEB93FFFFF2
      A0FFFFF1A7FFFAE8A0FFEEC67DFFE8C699FFCACCD0FF545252DA000000150000
      0000000000000000000000000000000000000000000000000000000000000000
      00350A0A0AFFF1F1F0FFFEFEFEFFFFFFFFFFC9CFDFFF3C64D4FF2359F0FF2C5F
      F2FF3768F2FF2359F1FF345FD8FFBAC2D9FFFBFBFBFFC5C5C5FFF7F7F7FF3B8E
      D5FF228EE9FF228EE9FF228EE9FF228EE9FF6AA0CDFFFFFFFFFFFEFEFEFFE0E0
      DFFF010101FD0000001C0000000000000000EEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FF9C7200CF0000000F00000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFF9496
      D4FF1213B7FF0000CBFF0000CCFF0000CCFF0000CCFF0000CCFF0000CCFF0000
      CCFF0000CCFF0000CCFF0000B9FC00000F5000000016ADADABFFFFFFFFFFF4F4
      F4FFF6F6F6FFF9F9F9FFF8F8F8FFF7F7F7FFF8F8F8FFFFFFFFFF6E6B6AFFF4F5
      F9FFE5AA5BFF53B2FFFF3CA2FFFF2093FFFF0283FFFF0070FFFF006DFFFF4BA2
      E4FFFFF2A0FFFBE69EFFF5DA94FFDCA864FFF5F8FDFF7B7878FF000000160000
      0000000000000000000000000000000000000000000000000000000000000000
      00350A0A0AFFF2F1F1FFFEFEFEFFFEFEFEFFFEFEFEFFF5F5F7FF8195CCFF2658
      E7FF2458EAFF6F88CAFFF0F1F3FFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFF6F6
      F7FFF0F2F3FFF0F2F3FFF0F2F3FFF0F2F3FFFAFAFAFFFEFEFEFFFEFEFDFFE1E0
      E0FF010101FD0000001C0000000000000000EEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FF9C7200CF0000000F000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFF9495D4FF1213
      B7FF0000CBFF0000CCFF0000CCFF0000CCFF0000CCFF0000CCFF0000CCFF0000
      CCFF0000CCFF0000CCFF0000B9FC00000F5000000016ADADABFFFFFFFFFFF3F3
      F3FFF5F5F5FFF8F8F8FFF8F8F8FFF7F7F7FFF8F8F8FFFEFEFEFF6F6E6CFFF7F9
      FDFFDB9A4AFF9EF6FFFF8FEEFFFF7DEAFFFF6AE7FFFF56E3FFFF3BE2FFFF006D
      FFFFFFEB93FFF9E098FFF5D993FFD29B55FFF8FBFFFF7B7A78FF000000160000
      0000000000000000000000000000000000000000000000000000000000000000
      00350A0A0AFFF2F2F2FFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFCDD2
      DFFFBEC5D7FFFDFDFDFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFE
      FEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFE1E1
      E1FF010101FD0000001C0000000000000000EEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FF9C7200CF0000000F0A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFF8D8FD3FF1414B9FF0000
      CCFF0000CCFF0000CCFF0000CCFF0000CCFF0000CCFF0000CCFF0000CCFF0000
      CCFF0000CCFF0000CCFF0000B9FC00000F5000000016ADADABFFFFFFFFFFF2F2
      F1FFF5F5F4FF979798FFC0C0C0FFBFBFBFFFBFBFBFFFFDFDFCFF726F6FFFFAFD
      FFFFCF9143FFB5F9FFFFA2EFFFFF8FEAFFFF7DE6FFFF6AE3FFFF56E3FFFF0070
      FFFFFFE088FFF7D790FFF2D28DFFC8944FFFFBFFFFFF7D7A7AFF000000150000
      0000000000000000000000000000000000000000000000000000000000000000
      00350A0A0AFFF3F3F2FFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFB7B7
      B7FF9A9A9AFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFE
      FEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFE2E2
      E1FF010101FD0000001C0000000000000000EEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FF9C7200CF0A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFF7173CAFF1010BDFF0000
      CCFF0000CCFF0000CCFF0000CCFF0000CCFF0000CCFF0000CCFF0000CCFF0000
      CCFF0000CCFF0000CCFF0000B9FC00000F5000000016ADADABFFFFFFFFFFF1F1
      F0FFF3F3F2FFF6F6F5FFF6F6F5FFF5F5F4FFF6F6F5FFFBFBFAFF72716FFFFEFF
      FFFFC8904AFFBEFBFFFFB7F5FFFFA2EFFFFF90ECFFFF7DE9FFFF6AEAFFFF0084
      FFFFFFD482FFF2CE87FFECC782FFC49456FFFFFFFFFF807D7CFF000000100000
      0000000000000000000000000000000000000000000000000000000000000000
      00350A0A0AFFF3F3F3FFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFE2E4
      E8FFD8DAE0FFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFD
      FDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFE2E2
      E2FF010101FD0000001C0000000000000000EEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FF9C7200CF0A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFF5C5DC4FF0F0F
      BEFF0000CCFF0000CCFF0000CCFF0000CCFF0000CCFF0000CCFF0000CCFF0000
      CCFF0000CCFF0000CCFF0000B9FC00000F5000000016ADADABFFFFFFFFFFF0F0
      EFFFF2F2F1FFF4F5F3FFF5F5F4FFF4F4F3FFF4F4F3FFF8F8F7FF979594FFD6D7
      D9FFD4B285FFB7C2CBFFB4DEFFFF96CBFFFF78BCFFFF5BAFFFFF3DA2FFFF71AD
      E1FFFAD08CFFEDC57DFFD0A461FFD2B58FFFDADCDFFF595757D6000000080000
      0000000000000000000000000000000000000000000000000000000000000000
      00350A0A0AFFF3F3F3FFFDFDFCFFFDFDFCFFFDFDFCFFFBFAFAFFA8B4D3FF2E5C
      DDFF2A5AE1FF99A7CFFFF9F9F9FFFDFDFCFFFDFDFCFFFDFDFCFFFDFDFCFFF9F9
      F9FFF8F8F7FFF8F8F7FFF8F8F7FFF8F8F7FFFCFCFBFFFDFDFCFFFDFDFDFFE2E2
      E2FF010101FD0000001C0000000000000000EEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FF9C7200CF0000000F0A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFF5C5D
      C4FF0F0FBEFF0000CCFF0000CCFF0000CCFF0000CCFF0000CCFF0000CCFF0000
      CCFF0000CCFF0000CCFF0000B9FC00000F5000000016ADADABFFFFFFFFFFEFEE
      EEFFF2F1F1FF989898FFBFBFC0FFBEBFBFFFBDBEBEFFF5F4F4FFC8C6C5FF9A99
      9AFFFBF7F1FFB98847FFFFEEDDFFFFEED8FFFFE6C6FFFFE0B7FFFFDCABFFFAD6
      A2FFF3D09AFFE0B270FFB2864AFFFCFAF7FFA1A1A2FF1313136A000000020000
      0000000000000000000000000000000000000000000000000000000000000000
      00350A0A0AFFF4F4F4FFFDFDFCFFFCFCFBFFE2E4EAFF5775CBFF2358EEFF275C
      F1FF2C60F2FF2358EFFF4B6DCEFFD8DBE5FFF9F9F8FFD4D4D4FFF1F2F2FF358D
      D7FF2A8EE3FF2A8EE3FF2A8EE3FF2A8EE3FF95B5D0FFFCFCFBFFFDFDFCFFE3E3
      E3FF010101FD0000001C0000000000000000EEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FF9C7200CF0000000F000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFF5C5DC4FF0F0FBEFF0000CCFF0000CCFF0000CCFF0000CCFF0000CCFF0000
      CCFF0000CCFF0000CCFF0000B9FC00000F5000000016ADADABFFFFFFFFFFEEED
      EDFFF0EFEFFFF2F1F1FFF3F2F2FFF2F1F1FFF1F0F0FFF2F1F1FFF6F5F6FF8F8F
      8DFFCBCACCFFF5EEE5FFAE8245FFDDC3A5FFF8E8D5FFFBE9D1FFF9E1C2FFF3D7
      B2FFCFA975FFAB8045FFF6F1EAFFCDCDD0FF8D8B89FF00000016000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00350A0A0AFFF4F4F4FFFCFCFBFFFBFBFAFF909EC4FF2759E5FF2359F1FF3365
      F2FF6189F5FF2359F1FF2558E8FF7C8FC1FFE8E8E7FF767675FFE7E8E9FF228D
      E8FF1D93F7FF1D93F7FF1D93F7FF1D93F7FF7EAACEFFFBFBFAFFFCFCFCFFE3E3
      E3FF010101FD0000001C0000000000000000EEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FF9C7200CF0000000F00000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFF6767C6FF0505AEFB0000CCFF0000CCFF000099EB00006ACA0000
      66C6000066C6000066C6000066C60000032500000016ADADABFFFFFFFFFFEDEC
      EAFFEFEEECFFF1F0EFFFF1F0EFFFF0EFEEFFF1F0EFFFF2F1EFFFF3F2F1FFE7E6
      E5FF827E7EFFD5D7D9FFFFFCF7FFC9AD85FFA97A3DFFA27230FFA37232FFAA7C
      40FFCAAF89FFFFFDFAFFCECED0FF878684FFB0B0AEFF00000016000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00350A0A0AFFF4F4F4FFFBFBFAFFFAFAF9FFFAFAF9FFD3D7E1FF476ACEFF2358
      EFFF2359F0FF3D64D2FFC6CCDBFFFAF9F9FFFAFAF9FFFAFAF9FFF9F9F8FFC5D3
      DEFFBCCEDCFFBCCEDCFFBCCEDCFFBCCEDCFFE6EAECFFFAFAF9FFFCFCFBFFE3E3
      E3FF010101FD0000001C00000000000000000E0A003F0E0A003F0E0A003F0E0A
      003F0E0A003F0E0A003F0E0A003F0E0A003F0E0A003F0E0A003F0E0A003F0E0A
      003F0E0A003F0E0A003F0E0A003F2D20006FEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FF9C72
      00CF0000000F0000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFE9EBEBFF1C1D79E70000A3EE0000CCFF00008DE4000000120000
      00000000000000000000000000000000000000000016ADADABFFFFFFFFFFECEB
      EAFFEFEEECFF999999FFBEBDBDFFF1F0EFFF9B9B9BFFBFBEBEFFBEBCBDFFF2F1
      F0FFE5E4E3FF929090FFA1A0A1FFE1E3E6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFE1E4E6FFA1A0A1FF91908FFFFFFFFFFFB2B2B0FF00000016000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00350A0A0AFFF4F4F4FFFAF9F9FFF9F8F7FFF9F8F7FFF9F8F7FFF4F3F3FF92A0
      CAFF8193C7FFF0F0F0FFF9F8F7FFF9F8F7FFF9F8F7FFF9F8F7FFF9F8F7FFF9F8
      F7FFF9F8F7FFF9F8F7FFF9F8F7FFF9F8F7FFF9F8F7FFF9F8F7FFFBFAFAFFE3E3
      E3FF010101FD0000001C00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000805002FD19800EFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FF9C7200CF0000
      000F000000000000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFE9EBEBFF3C3E3EC200003D9B0000A3EE00008DE4000000120000
      00000000000000000000000000000000000000000016ADADABFFFFFFFFFFE9E9
      E8FFEBECEAFFEEEEEDFFEEEEEDFFEDEDECFFEEEEEDFFEEEEEDFFEDEDECFFEDED
      ECFFEEEEEDFFF2F2F1FFC7C5C4FF9C9A98FF7D7C7AFF7E7C7AFF7D7C7AFF7D7B
      7AFF9B9997FFC6C4C3FFF0F0EFFFFFFFFFFFAFAFADFF00000016000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00350A0A0AFFF4F4F4FFF9F8F7FFF7F6F5FFF7F6F5FFF7F6F5FFF7F6F5FFBEBE
      BCFFA7A6A5FFF7F6F5FFF7F6F5FFF7F6F5FFF7F6F5FFF7F6F5FFF7F6F5FFF7F6
      F5FFF7F6F5FFF7F6F5FFF7F6F5FFF7F6F5FFF7F6F5FFF7F6F5FFFAF9F8FFE3E3
      E3FF010101FD0000001C00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000805002FD19800EFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FF9C7200CF0000000F0000
      0000000000000000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFE9EBEBFF3C3E3EC2000000000000369000009BF5000000120000
      00000000000000000000000000000000000000000016ADADABFFFFFFFFFFE8E8
      E7FFEAEBE9FFEDEDECFFEDEDECFFEDEDEBFFECECEBFFECECEBFFEDEDECFFEDED
      ECFFEDEDECFFEEEEEDFFF0F0EFFFF1F1F0FFF1F1F0FFEFF0EFFFEFEFEEFFEFEF
      EEFFEEEEEDFFEBEBEAFFE9E9E8FFFFFFFFFFADADABFF00000016000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00350A0A0AFFF4F4F4FFF7F6F5FFF5F4F3FFEDECECFFE0DFE4FFE0DFE4FFCFCD
      D3FFC2C0C6FFE0DFE4FFE0DFE4FFEBE9EAFFF5F4F3FFF5F4F3FFF5F4F3FFF5F4
      F3FFF5F4F3FFF5F4F3FFF5F4F3FFF5F4F3FFF5F4F3FFF5F4F3FFF8F8F7FFE3E3
      E3FF010101FD0000001C00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000805002FD19800EFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FF9C7200CF0000000F000000000000
      0000000000000000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFE9EBEBFF3C3E3EC2000000000000000000001861000000050000
      00000000000000000000000000000000000000000016ADAEABFFFFFFFFFFE7E6
      E6FFEAE9E9FF9A9A9AFFBDBDBEFFBCBCBDFFBBBBBCFFEDEBEBFF9C9C9CFFBDBD
      BEFFBDBDBDFFBDBDBDFFBDBDBDFFBCBCBCFFEAE9E9FFF4F3F3FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAEAEABFF00000016000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00350A0A0AFFF4F4F4FFF6F5F2FFF3F2EFFF6561C4FF2921E3FF423CE5FF4943
      E6FF4A44E6FF4842E6FF2F28E4FF514CC7FFF3F2EFFFF3F2EFFFF3F2EFFFF3F2
      EFFFF3F2EFFFF3F2EFFFF3F2EFFFF3F2EFFFF3F2EFFFF3F2EFFFF7F6F5FFE3E3
      E3FF010101FD0000001C00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000805
      002FD19800EFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FF9C7200CF0000000F00000000000000000000
      0000000000000000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFE9EBEBFF3C3E3EC2000000000000000000000000000000000000
      00000000000000000000000000000000000000000016AEAEABFFFFFFFFFFE6E5
      E4FFE8E7E6FFEBEAE9FFEBEAE9FFEBE9E8FFEAE9E8FFEAE9E8FFEBEAE9FFEBEA
      E9FFEBE9E8FFEBEAE8FFEBE9E8FFE9E8E7FFE7E6E4FFFFFFFFFFCBCBCAFFA7A7
      A4FFA7A7A5FFA7A7A4FFA5A5A2FFFFFFFFFFAFAFADFF00000010000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00350A0A0AFFF4F4F4FFF3F2F0FFF0EEECFF615DC3FF2820E7FF4B45EAFF4841
      EAFF413AE9FF4842EAFF2F27E7FF4E48C8FFF0EEECFFF0EEECFFF0EEECFFF0EE
      ECFFF0EEECFFF0EEECFFF0EEECFFF0EEECFFF0EEECFFF0EEECFFF5F4F2FFE3E3
      E3FF010101FD0000001C00000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000805002FD198
      00EFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FF9C7200CF0000000F0000000000000000000000000000
      0000000000000000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFE9EBEBFF3C3E3EC2000000000000000000000000000000000000
      00000000000000000000000000000000000000000016AEAEABFFFFFFFFFFE5E4
      E3FFE7E6E5FFEAE9E7FFEAE9E8FFE9E8E7FFE9E8E7FFEAE9E7FFEAE9E8FFE9E8
      E7FFE9E8E7FFEAE9E8FFEAE9E8FFE8E7E6FFE5E4E3FFFFFFFFFFA7A7A5FFFFFF
      FFFFF9F9F8FFF0EFEFFFFFFFFFFFE9E9E9FF949492EA00000005000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00350A0A0AFFF4F4F4FFF0EFEDFFEDEBE8FFE1DFDFFFCFCDD6FFCFCDD6FFCFCD
      D6FFCFCDD6FFCFCDD6FFCFCDD6FFDEDCDDFFEDEBE8FFEDEBE8FFEDEBE8FFEDEB
      E8FFEDEBE8FFEDEBE8FFEDEBE8FFEDEBE8FFEDEBE8FFEDEBE8FFF3F2EFFFE3E3
      E3FF010101FD0000001C00000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000004A36008FEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FF9C7200CF0000000F000000000000000000000000000000000000
      0000000000000000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFE9EBEBFF3C3E3EC2000000000000000000000000000000000000
      00000000000000000000000000000000000000000016AEAEABFFFFFFFFFFE4E3
      E2FFE7E6E5FF9B9B9BFFBCBBBCFFBBBABAFFE9E8E7FF9C9D9DFFBCBBBCFFBBBA
      BAFFE9E8E7FF9C9D9DFFBCBBBCFFBAB9B9FFE5E4E3FFFFFFFFFFA7A7A5FFF9F9
      F8FFEDECECFFFFFFFFFFE7E7E7FF8B8B89E50000000500000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0033090909FFF2F2F2FFEEECEAFFE9E6E3FFE9E6E3FFE9E6E3FFE9E6E3FFE9E6
      E3FFE9E6E3FFE9E6E3FFE9E6E3FFE9E6E3FFE9E6E3FFE9E6E3FFE9E6E3FFE9E6
      E3FFE9E6E3FFE9E6E3FFE9E6E3FFE9E6E3FFE9E6E3FFE9E6E3FFF1EFEDFFE1E1
      E1FF010101FD0000001B00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005C43
      009FEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FF9C7200CF0000000F00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFE9EBEBFF3C3E3EC2000000000000000000000000000000000000
      00000000000000000000000000000000000000000016AEAEABFFFFFFFFFFE2E1
      E0FFE4E3E2FFE7E6E5FFE7E6E5FFE6E5E4FFE6E5E4FFE7E6E5FFE7E6E5FFE6E5
      E4FFE6E5E4FFE7E6E5FFE7E6E5FFE6E5E4FFE3E1E0FFFFFFFFFFA7A7A4FFF0EF
      EFFFFFFFFFFFE6E6E6FF8C8C89E6000000050000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0016000000F9C4C4C4FFF8F8F7FFE7E5E1FFE6E4DFFFE6E4DFFFE6E4DFFFE6E4
      DFFFE6E4DFFFE6E4DFFFE6E4DFFFE6E4DFFFE6E4DFFFE6E4DFFFE6E4DFFFE6E4
      DFFFE6E4DFFFE6E4DFFFE6E4DFFFE6E4DFFFE6E4DFFFE8E6E2FFFBFAFAFFA4A4
      A4FF000000ED0000000800000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00005C43009FEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FF9C72
      00CF0000000F0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000A0B0A59CBCDCCFEEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFE6E8E8FF3C3D3DC1000000000000000000000000000000000000
      00000000000000000000000000000000000000000015AEAEACFFFFFFFFFFE0DF
      DEFFE1E0DFFFE2E0DFFFE2E0DFFFE1E0DFFFE1E0DFFFE2E0DFFFE2E0DFFFE1E0
      DFFFE1E0DFFFE2E0DFFFE2E0DFFFE1E0DFFFE0DFDEFFFFFFFFFFA5A5A3FFFFFF
      FFFFE7E7E7FF5F5F5DC000000004000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000A31E1E1EFFD6D6D6FFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFE
      FEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFE
      FEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFDFDFDFFC6C6C6FF1010
      10FF000000800000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000005C43009FEEAD00FFEEAD00FFEEAD00FFEEAD00FF9C7200CF0000
      000F000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000016353735B53E4040C63E40
      40C63E4040C63E4040C63E4040C63E4040C63E4040C63E4040C63E4040C63E40
      40C63E4040C63E4040C63E4040C63E4040C63E4040C63E4040C63E4040C63E40
      40C63E4040C63C3F3FC307070744000000000000000000000000000000000000
      0000000000000000000000000000000000000000000DAFAFADFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE9E9
      E9FF4D4D4CAE0000000300000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000A000000B3040404FE222222FF262626FF262626FF262626FF2626
      26FF262626FF262626FF262626FF262626FF262626FF262626FF262626FF2626
      26FF262626FF262626FF262626FF262626FF262626FF1F1F1FFF020202FC0000
      009B000000050000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000005C43009FEEAD00FFEEAD00FF9C7200CF0000000F0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000004575755B4B0B0ADFFAEAE
      ACFFAEAEABFFAEAEABFFAEAEABFFAEAEABFFAEAEABFFAEAEABFFAEAEABFFAEAE
      ABFFAEAEABFFAEAEABFFAEAEABFFAEAEABFFADAEABFFAEAEABFFAFAFADFF5151
      50B0000000040000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000300000051000000AB000000B2000000B2000000B20000
      00B2000000B2000000B2000000B2000000B2000000B2000000B2000000B20000
      00B2000000B2000000B2000000B2000000B2000000B2000000A6000000420000
      0001000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000005C43009F9C7200CF0000000F000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001B1B1B67515151B0797776D97A64
      49F16E4E26F967400FFE643C09FF633B09FF633B09FF633B09FF633B09FF633B
      09FF633B09FF633B09FF633B09FF633B09FF633B09FF633B09FF633B09FF633B
      09FF633B09FF633B09FF633B09FF633B09FF633B09FF643C09FF69410FFE7251
      28F87B664BF17A7877D9515151B01B1B1B6700000000000000000110005D044D
      00C9077400F7077C00FF077C00FF087B01FF097A01FF087B01FF077C00FF077C
      00FF077C00FF077C00FF077C00FF077C00FF077C00FF087B01FF097A01FF087B
      01FF077C00FF077C00FF077C00FF077C00FF077C00FF077C00FF077C00FF0872
      01F7064E01CB0111006100000001000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000004040301314F300AD76D42
      0CFF673D0BFF633B0BFF623A0BFF623A0BFF623A0BFF623A0BFF623A0BFF623A
      0BFF623A0BFF623A0BFF623A0BFF623A0BFF623A0BFF623A0BFF623A0BFF623A
      0BFF623A0BFF623A0BFF623A0BFF623A0BFF623A0BFF623B0BFF653C0BFF6C41
      0CFF70430CFF50310AD7040301310000000400000000032E009C098301FF1EAD
      15FF2BB923FF30B928FF34B92CFF37B92FFF3BB534FF3EB438FF42B63BFF45BC
      3EFF49BE42FF4DBE46FF50BF4AFF54C04EFF54C04EFF50BE4AFF4CB846FF48B7
      42FF46B73FFF42BB3BFF3FBB37FF3BBB34FF38BA30FF34BA2CFF31B928FF2BB8
      23FF20A817FF0C7E05FF052F02A1000000010000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000B000643B2042285E80000
      1490000000090000000000000000000000000000000852320AD675480FFF7548
      0FFF75470FFF75480FFF74480FFF74480FFF74480FFF74480FFF74480FFF7448
      0FFF74480FFF74480FFF74480FFF74480FFF74480FFF74480FFF74480FFF7448
      0FFF74480FFF74480FFF74480FFF74480FFF74480FFF74480FFF75470FFF7548
      0FFF75480FFF75480FFF52320AD6000000080111005F0A8102FF22B518FF29C3
      1FFF32DA26FF3EE632FF49E93EFF54EC4AFF5FEC55FF67E35FFF70E269FF7BE7
      74FF8AF583FF96F990FFA0FB9AFFA7FDA3FFA7FDA3FFA0FB9BFF95F78FFF86E9
      80FF7AE573FF71E46AFF6AEE62FF5FEE56FF54EC4AFF49E93FFF3EE633FF32DA
      26FF29C21FFF23AD1BFF0C7E04FF011100610000000000000000000000000000
      000000000000000000001111118E333333F2333333F2333333F2333333F23333
      33F2333333F2333333F2333333F2333333F2333333F2333333F2333333F23333
      33F2333333F2333333F2333333F2333333F2333333F2333333F2333333F23333
      33F2333333F2333333F2333333F21111118E0000000000000000000000000000
      0000000000020000001300000013000000130000001300000013000000130000
      0013000000130000001300000013000000130000001300000013000000130000
      00130000001300000013000000130000011E000750B70766F0FF1DA2FFFF2275
      DCFF00000C7E0000000000000000000000001E130580784B12FF784B12FF784B
      12FF784B12FF784B12FF784B12FF784B12FF784B12FF784B12FF784B12FF784B
      12FF784B12FF784B12FF784B12FF784B12FF784B12FF784B12FF784B12FF784B
      12FF784B12FF784B12FF784B12FF784B12FF784B12FF784B12FF784B12FF784B
      12FF784B12FF784B12FF784B12FF1E130580044F00CB17A70EFF24BB1BFF26DF
      1AFF31E425FF3CE731FF47E93DFF52EB48FF5DED53FF67EE5FFF6DE066FF75DF
      6FFF80E479FF90F68AFF98FA93FF9EFB98FF9EFB98FF99FA94FF91F88BFF87F4
      80FF77E271FF6DDD66FF64DE5CFF5DEC54FF52EB48FF47E93DFF3DE732FF32E5
      26FF27E11AFF23C119FF18A60FFF065001CD0000000000000000000000000000
      00000000000000000000343434F2E9E9E9FFE9E9E9FFEAEAEAFFE9E9E9FFE9E9
      E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9
      E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9
      E9FFEAEAEAFFEAEAEAFFE9E9E9FF343434F20000000000000000000000000000
      0042101010CD2C2C2CEB2D2D2DEC2D2D2DEC2D2D2DEC2D2D2DEC2D2D2DEC2E2E
      2EEC2E2E2EEC2E2E2EEC2E2E2EEC2E2E2EEC2E2E2EEC2E2E2EEC2E2E2EEC2E2E
      2EEC2D2D2EEC30312FEC252126EB000B71F20667F6FF1A9AFFFF3DCBFFFF52E0
      FFFF050B43C4000000000000000000000000472D0CC17C4E15FF7C4E15FF7C4E
      15FF7C4E15FF7C4E15FF7C4E15FF7C4E15FF7C4E15FF7C4E15FF7C4E15FF7C4E
      15FF7C4E15FF7C4E15FF7C4E15FF7C4E15FF7C4E15FF7C4E15FF7C4E15FF7C4E
      15FF7C4E15FF7C4E15FF7C4E15FF7C4E15FF7C4E15FF7C4E15FF7C4E15FF7C4E
      15FF7C4E15FF7C4E15FF7C4E15FF472D0CC1077400F71EB115FF1DC812FF25D1
      1AFF2FE123FF3AE62FFF45E83AFF4FEB45FF5AED51FF64EF5BFF6DEF66FF72E1
      6BFF79E073FF82E47BFF8FF689FF94F98EFF94F98EFF90F88AFF8AF683FF82F5
      7AFF77F16FFF69DF62FF60DA59FF57DC50FF50E946FF45E93BFF3AE62FFF30E4
      24FF25E118FF1BD30FFF1DB414FF087201F70000000000000000000000000000
      00000000000000000000363636F2E8E8E8FFE8E8E8FFE7E7E7FFE8E8E8FFE8E8
      E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8
      E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8
      E8FFE9E9E9FFE9E9E9FFE8E8E8FF363636F20000000000000000000000002020
      20E9DCDCDCFFF7F7F7FFF5F5F5FFF4F4F4FFF4F4F4FFF3F3F3FFF3F3F3FFF2F2
      F2FFF2F2F2FFF1F1F1FFF1F1F1FFF0F0F0FFF0F0F0FFEFEFEFFFEEEEEEFFEDED
      EEFFF5F5EFFFE3DEE5FF4450C7FF0260F4FF1A9AFFFF3BC8FFFF5AF3FFFF255B
      B8F700000452000000000000000000000000734A16F2815218FF815218FF8152
      18FF815218FF815218FF815218FF815218FF815218FF815218FF815218FF8152
      18FF815218FF815218FF815218FF815218FF815218FF815218FF815218FF8152
      18FF815218FF815218FF815218FF815218FF815218FF815218FF815218FF8152
      18FF815218FF815218FF815218FF724916F1077C00FF1EB315FF17C80CFF22C9
      17FF2DCE23FF36E32BFF41E837FF4CEA42FF55EC4CFF5FEE56FF69F060FF70F0
      68FF74E16DFF78E073FF7EE479FF89F482FF8AF683FF87F680FF82F57AFF7AF3
      72FF72F26AFF68EE60FF5DDC55FF53D84CFF4BD942FF41E637FF37E62CFF2DE3
      21FF20DB15FF16D30AFF1EB415FF077C00FF0000000000000000000000000000
      00000000000000000000383838F2E4E4E4FFBBBBBBFF464646FFB5B5B5FFE4E4
      E4FFDCDCDCFFE4E4E4FFE4E4E4FFDCDCDCFFE4E4E4FFE4E4E4FFDCDCDCFFDCDC
      DCFFE4E4E4FFDCDCDCFFE4E4E4FFE4E4E4FFE4E4E4FFE4E4E4FFE4E4E4FFDCDC
      DCFFE5E5E5FFE5E5E5FFE4E4E4FF383838F20000000000000000000000005151
      51FFF8F8F8FFECECECFFEBEBEBFFEAEAEAFFE9E9E9FFE8E8E8FFE7E7E7FFE7E7
      E7FFE7E7E7FFE8E8E8FFE8E8E8FFE6E6E6FFE3E3E3FFE1E1E1FFE0E0E0FFE6E6
      E1FFD6D1D9FF3541C0FF005AF0FF1A9BFFFF3CC8FFFF5AF3FFFF2356B7F20000
      04510000000000000000000000000000000084551BFF84551BFF84551BFF8455
      1BFF84551BFF84551BFF84551BFF84551BFF84551BFF84551BFF84551BFF8455
      1BFF84551BFF84551BFF84561CFF85561DFF85561DFF84561CFF84551BFF8455
      1BFF84551BFF84551BFF84551BFF84551BFF84551BFF84551BFF84551BFF8455
      1BFF84551BFF84551BFF84551BFF84551BFF077C00FF1DB114FF11C805FF1DC5
      13FF28C51EFF32CE27FF3DE432FF47E93DFF50EB46FF59ED50FF62EF5AFF6AF0
      62FF70F068FF72E16BFF75DF6EFF77E272FF7DF276FF7CF474FF78F370FF72F2
      6AFF6BF063FF62EF5AFF5AEB51FF4FDA47FF46D53EFF3ED634FF33E227FF27DD
      1BFF1CD510FF13CE06FF1EB214FF077C00FF0000000000000000000000000000
      000000000000000000003A3A3AF2E0E0E0FF787878FFBBBBBBFF484848FF8C8C
      8CFFD7D7D7FFA7A7A7FFDFDFDFFFA9A9A9FFB9B9B9FFDFDFDFFFA7A7A7FFA7A7
      A7FFD7D7D7FFADADADFFABABABFFDFDFDFFFB0B0B0FFB0B0B0FFC4C4C4FFB6B6
      B6FFA7A7A7FFDFDFDFFFDFDFDFFF3A3A3AF20000000000000000000000005050
      50FFF4F4F4FFEDEDEDFFECECECFFEBEBEBFFEAEAEAFFE9E9E9FFEDEDEDFFEEEE
      EEFFE4E4E4FFD6D6D6FFD1D1D1FFD4D4D4FFE1E1E1FFEBEBEBFFE9E9E6FFD9D6
      DFFF4658CBFF066FF6FF189AFFFF3CC9FFFF57EFFFFF2159C7FF00000B840000
      00000000000000000000000000000000000088581EFF88581EFF88581EFF8858
      1EFF88581EFF88581EFF88581EFF88581EFF88581EFF88581EFF88581EFF8858
      1EFF88581EFF88581FFF8A5B22FF8B5D25FF8C5E27FF8B5D24FF895A21FF8859
      1FFF88581EFF88581EFF88581EFF88581EFF88581EFF88581EFF88581EFF8858
      1EFF88581EFF88581EFF88581EFF88581EFF077C00FF1DAF13FF0EC402FF17C9
      0BFF23C219FF2DC623FF36D02DFF41E637FF4AEA40FF53EB49FF5BED52FF62EF
      5AFF69F060FF6DEF66FF6DE066FF6EDD67FF6FE068FF71F069FF6EF166FF69F0
      60FF63EF5AFF5BED52FF54EC4AFF4BE841FF42D738FF39D330FF2FCE25FF22D5
      16FF18CF0BFF0FC802FF1DB113FF077C00FF0000000000000000000000000000
      000000000000000000003C3C3CF2DDDDDDFF484848FFDBDBDBFFBABABAFF4F4F
      4FFFABABABFFDBDBDBFFDBDBDBFFDBDBDBFFDBDBDBFFDBDBDBFFDBDBDBFFDBDB
      DBFFDBDBDBFFDBDBDBFFDBDBDBFFDBDBDBFFDBDBDBFFDBDBDBFFDBDBDBFFDBDB
      DBFFDBDBDBFFDBDBDBFFDBDBDBFF3C3C3CF20000000000000000000000005252
      52FFF4F4F4FFEEEEEEFFEDEDEDFFECECECFFEDEDEDFFF1F1F1FFCFCFCFFFA0A0
      A1FF898A8BFF818284FF7B7D7EFF757677FF777879FF939393FFD7D7CFFF9B99
      D0FF6582CDFF92DCE1FF48D6FFFF51EAFFFF356DE0FF473E75FF010100710000
      0000000000000000000000000000000000008C5C21FF8C5C21FF8C5C21FF8C5C
      21FF8C5C21FF8C5C21FF8C5C21FF8C5C21FF8C5C21FF8C5C21FF8C5C21FF8C5C
      21FF8C5D22FF8D5E24FF91642DFF9C7443FF99703DFF976C37FF92652DFF8E5F
      25FF8D5D23FF8C5C21FF8C5C21FF8C5C21FF8C5C21FF8C5C21FF8C5C21FF8C5C
      21FF8C5C21FF8C5C21FF8C5C21FF8C5C21FF077C00FF1CAD13FF0BBE00FF12C4
      06FF1BC910FF99DB95FFE8E9E9FFEBECECFFFCFDFDFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFCFDFDFFEBECECFFE8E9E9FFADE5A9FF64ED5CFFAAF6
      A5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFDFDFFEBECECFF90D98BFF20C2
      16FF15C808FF0BC300FF1CAF13FF077C00FF0000000000000000000000000000
      000000000000000000003E3E3EF2DBDBDBFF4B4B4BFFD7D7D7FFD7D7D7FFBABA
      BAFF545454FFA0A0A0FFD9D9D9FFD8D8D8FFD8D8D8FFD8D8D8FFD0D0D0FFD8D8
      D8FFD8D8D8FFD8D8D8FFD0D0D0FFD8D8D8FFD8D8D8FFD8D8D8FFD8D8D8FFD0D0
      D0FFD8D8D8FFD8D8D8FFD8D8D8FF3E3E3EF20000000000000000000000005454
      54FFF5F5F5FFEFEFEFFFEDEDEDFFF0F0F0FFEBEBEBFFA3A3A3FF868789FF9F9F
      9EFFBAB4AEFFC8BEB3FFC7BDB1FFB6AEA5FF96938EFF717273FF636464FF6161
      6BFFA7A5ACFFE8E0D8FF88E8F9FF205DD7FFA49BD5FFA3A297FF000000740000
      0000000000000000000000000000000000008F5F24FF8F5F24FF8F5F24FF8F5F
      24FF8F5F24FF8F5F24FF8F5F24FF8F5F24FF8F5F24FF8F5F24FF8F5F24FF8F5F
      24FF906026FF92642BFF9A6F3CFFBEA98FFFCFC2B3FFA9895FFF9E7746FF976B
      35FF93642BFF8F6026FF8F6025FF8F5F24FF8F5F24FF8F5F24FF8F5F24FF8F5F
      24FF8F5F24FF8F5F24FF8F5F24FF8F5F24FF077C00FF1BAB12FF0BB800FF0EBF
      02FF0DAB03FF0A9802FFA8D0A7FFE8E9E9FFEBECECFFFCFDFDFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFDFDFF85C182FF0E8E07FF66B562FFFCFD
      FDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA1E09DFF23C619FF1CBC
      11FF14B80AFF0CBD00FF1BAD12FF077C00FF0000000000000000000000000000
      00000000000000000000404040F2D8D8D8FF4E4E4EFFD4D4D4FFD4D4D4FFD4D4
      D4FFBBBBBBFF545454FF787878FFCCCCCCFF949494FF939393FF939393FFCBCB
      CBFFD4D4D4FF949494FF949494FF939393FFCBCBCBFF939393FFD4D4D4FF9E9E
      9EFF939393FFD4D4D4FFD4D4D4FF404040F20000000000000000000000005656
      56FFF6F6F6FFEFEFEFFFF1F1F1FFECECECFF949495FF9A9C9EFFD6CDC2FFF5E2
      CDFFFFEED9FFFFF3DEFFFFF4E0FFFFF2DEFFF7E6D1FFCFBEACFF8C8985FF9496
      95FFD6D5CEFF8386AFFF4C5BD8FF9793CCFFFCFCF0FF989898FF000000740000
      000000000000000000000000000000000000936227FF936227FF936227FF9362
      27FF936227FF936227FF936328FF946329FF94642AFF946329FF946329FF9463
      29FF95652BFF986A32FFA27A4AFFC8B6A0FFE7E7E7FFE0DBD6FFBAA181FFA781
      53FF9C713CFF976830FF95642AFF936328FF936227FF936227FF936227FF9362
      27FF936227FF936227FF936227FF936227FF077C00FF1AA911FF0AB400FF0BBA
      00FF11C105FF0CA502FF149C0CFFC1DAC0FFE8E9E9FFEBECECFFFCFDFDFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF8DCF89FF089700FF5CB058FFE6E8E7FFEBEC
      ECFFFCFDFDFFFFFFFFFFFFFFFFFFFFFFFFFFABE1A8FF25D819FF1ACE0FFF17BA
      0BFF11B107FF0FB104FF1AAA11FF077C00FF1717178E434343F2434343F24343
      43F2434343F2434343F24A4A4AFE515151FF515151FFD2D2D2FFD2D2D2FFD2D2
      D2FFD2D2D2FFBCBCBCFF5D5D5DFF9E9E9EFFD4D4D4FFD4D4D4FFD3D3D3FFD3D3
      D3FFD3D3D3FFD3D3D3FFD3D3D3FFD3D3D3FFD3D3D3FFD3D3D3FFD3D3D3FFD3D3
      D3FFD3D3D3FFD3D3D3FFD3D3D3FF434343F20000000000000000000000005858
      58FFF6F6F6FFF0F0F0FFF6F6F6FFA1A2A2FFA2A3A5FFECDCCCFFFFEBD1FFFFF1
      DCFFFFEFDBFFFFEEDAFFFFEEDAFFFFEFDBFFFFF2DFFFFFF6E1FFE8D3B8FF9992
      8CFF727374FF686770FFE1DFE9FFE9E9E2FFF0F0F0FF989898FF010101740000
      00000000000000000000000000000000000097662AFF97662AFF97662AFF9766
      2AFF97672BFF97672BFF996A30FF9C6D35FF9D6F38FF9E713AFF9E7139FF9E71
      39FF9F723BFFA27843FFAD895BFFD0C1AEFFE9E9E9FFE9E9E9FFE8E6E5FFC9B7
      A0FFAF8C5FFFA37845FF9C6E35FF99692EFF97672BFF97662AFF97662AFF9766
      2AFF97662AFF97662AFF97662AFF97662AFF077C00FF27AC1EFF0AB100FF0BB7
      00FF0CBD00FF12C206FF0AA001FF20A21AFFD5E2D4FFE8E9E9FFEBECECFFFCFD
      FDFFFFFFFFFFFFFFFFFF8DCF89FF079800FF50B64AFFF7FBF7FFEBECECFFE8E9
      E9FFEBECECFFFCFDFDFFFFFFFFFFB6E1B4FF11A308FF85E77EFF62DD59FF0DC2
      01FF10B006FF10AD05FF28A920FF077C00FF464646F2D2D2D2FFD2D2D2FFD2D2
      D2FFD2D2D2FFD2D2D2FFD2D2D2FFD2D2D2FFD2D2D2FFD2D2D2FFD2D2D2FFD2D2
      D2FFD2D2D2FFD2D2D2FFBFBFBFFF626262FF9B9B9BFFD5D5D5FFC9C9C9FFD4D4
      D4FFC8C8C8FFD3D3D3FFD3D3D3FFD3D3D3FFD3D3D3FFC8C8C8FFD3D3D3FFD3D3
      D3FFC8C8C8FFD3D3D3FFD3D3D3FF454545F20000000000000000000000005A5A
      5AFFF7F7F7FFF7F7F7FFCFCFCEFF929496FFE9DDD0FFFFE8CAFFFFEDD7FFFFEB
      D3FFFFEAD2FFFFEAD1FFFFEAD1FFFFEBD2FFFFEBD4FFFFECD6FFFFF5DFFFE1C7
      AAFF7C7977FF595A59FFD6D6D4FFE4E4E4FFF0F0F0FF9A9A9AFF020202740000
      0000000000000000000000000000000000009B692DFF9B692DFF9B692DFF9B69
      2DFF9C6A2FFF9E6D33FFA3763FFFAA8250FFAF8A5BFFB08C5FFFB18D60FFB18D
      60FFB18E61FFB59368FFBC9F7BFFD9CDBFFFEBEBEBFFEBEBEBFFEBEBEBFFEBEA
      EAFFD9CEC0FFB6956CFFA9804EFFA2743CFF9E6D33FF9C6A2FFF9B692DFF9B69
      2DFF9B692DFF9B692DFF9B692DFF9B692DFF077C00FF33AC2CFF0AAC00FF0AB4
      00FF0BBB00FF0DC201FF1AC50FFF099C01FF36AB30FFE0E7E1FFE8E9E9FFEBEC
      ECFFFCFDFDFF8DCF89FF079800FF43B13DFFF9FDF9FFFFFFFFFFFCFDFDFFEBEC
      ECFFE8E9E9FFEBECECFFC1E4BFFF0D9A05FF79C875FFFFFFFFFFECFBEBFF1EC7
      13FF0CB900FF0EAB04FF34AB2CFF087B01FF4A4A4AF2D3D3D3FFD3D3D3FFD3D3
      D3FFD3D3D3FFD3D3D3FFD3D3D3FFD3D3D3FFD3D3D3FFD3D3D3FFD3D3D3FFD3D3
      D3FFD3D3D3FFD3D3D3FFD3D3D3FFC3C3C3FF646464FF9B9B9BFF898989FF9595
      95FFC9C9C9FFB8B8B8FFD4D4D4FF888888FF979797FF9A9A9AFF8E8E8EFFA2A2
      A2FFC8C8C8FFD4D4D4FFD4D4D4FF484848F20000000000000000000000005C5C
      5CFFF7F7F7FFF8F8F8FF9FA0A0FFC3C2C0FFFFE3C3FFFFEAD0FFFFE8CEFFFFE7
      CBFFFFE6CAFFFFE6C9FFFFE6C9FFFFE7CAFFFFE8CCFFFFE9CFFFFFEBD3FFFFEF
      D2FFB39F8BFF545659FF949494FFECECECFFF1F1F1FF9B9B9BFF020202740000
      0000000000000000000000000000000000009E6C30FF9E6C30FF9E6C30FF9E6D
      31FFA06E33FFA3753DFFB28E60FFDDD3C8FFE0D8CFFFE2DBD2FFE1DAD2FFE1DA
      D2FFE2DBD3FFE2DCD4FFE4DED8FFE8E6E3FFECECECFFECECECFFECECECFFECEC
      ECFFEDECECFFE3DED7FFC0A482FFAF8858FFA67942FFA17136FF9F6D32FF9E6C
      30FF9E6C30FF9E6C30FF9E6C30FF9E6C30FF077C00FF40B138FF0DA603FF19B6
      10FF31C427FF44CF3BFF4CD642FF3DCA33FF089900FF52B54CFFE9EBEAFFE8E9
      E9FF85C182FF089700FF3AAD34FFF3FAF3FFFFFFFFFFFFFFFFFFFFFFFFFFFCFD
      FDFFEBECECFFBBD6BAFF189411FF78C674FFFFFFFFFFFFFFFFFFFFFFFFFFAEEA
      AAFF0BB900FF0BB100FF40B039FF097A01FF4E4E4EF2D7D7D7FFD7D7D7FFD7D7
      D7FFD7D7D7FFD7D7D7FFD7D7D7FFD7D7D7FFD7D7D7FFD7D7D7FFD7D7D7FFD7D7
      D7FFD7D7D7FFD7D7D7FFD7D7D7FFD7D7D7FFCACACAFF707070FFA9A9A9FFD7D7
      D7FFD6D6D6FFD6D6D6FFD5D5D5FFD5D5D5FFD5D5D5FFD5D5D5FFD5D5D5FFD5D5
      D5FFD5D5D5FFD5D5D5FFD5D5D5FF4B4B4BF20000000000000000000000005E5E
      5EFFF9F9F9FFEAEAEAFF96989AFFEADCD0FFFFE2BEFFFFE6C9FFFFE2C0FFFFDF
      BBFFFFDDB7FFFFDCB6FFFFDCB6FFFFDEB9FFFFE0BDFFFFE3C3FFFFE6CAFFFFEF
      D5FFDFBE9EFF6C6B6AFF696969FFE9E9E9FFF2F2F2FF9C9C9CFF030303740000
      000000000000000000000000000000000000A27033FFA27033FFA27033FFA271
      34FFA47338FFAA7D46FFBE9F78FFEEEDEDFFEEEDEDFFEEEEEEFFEEEEEEFFEEEE
      EEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEE
      EEFFEEEEEEFFEEEEEEFFEBE9E6FFCCB59AFFB38C5BFFA97B43FFA47337FFA271
      34FFA27033FFA27033FFA27033FFA27033FF077C00FF57BA52FF47B940FF56C0
      50FF58CD50FF57D34FFF57D84EFF56DD4DFF37C42FFF079800FF6FC26AFF85C1
      82FF0E8E07FF329F2DFFEAF5E9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFD3ECD2FF1E9618FF0E8E07FF0D8F06FF089700FF079800FF08A500FF0BBF
      00FF0BB800FF0AB100FF4DBA46FF087B01FF525252F2E4E4E4FFE4E4E4FFE4E4
      E4FFE4E4E4FFE4E4E4FFE4E4E4FFE4E4E4FFE4E4E4FFE4E4E4FFE4E4E4FFE4E4
      E4FFE4E4E4FFE4E4E4FFE4E4E4FFE4E4E4FFE4E4E4FFCFCFCFFF636363FFCCCC
      CCFFD9D9D9FFD8D8D8FFCACACAFFD7D7D7FFD7D7D7FFD7D7D7FFD7D7D7FFD7D7
      D7FFC9C9C9FFD7D7D7FFD7D7D7FF4E4E4EF20000000000000000000000006060
      60FFFCFCFCFFDCDCDCFF9EA2A4FFF8E0CBFFFFDCB5FFFFDDB7FFFFD8ADFFFFD4
      A6FFFFD2A2FFFFD1A0FFFFD1A1FFFFD3A4FFFFD6A9FFFFDAB0FFFFDEBAFFFFE8
      C9FFF2CEAAFF827872FF595B5CFFE0E0E0FFF4F4F4FF9E9E9EFF040404740000
      000000000000000000000000000000000000A67336FFA67336FFA67336FFA674
      37FFA8773BFFAF834CFFC4A783FFF0EFEFFFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
      F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
      F0FFF0F0F0FFF0F0F0FFF0F0F0FFEFEEEEFFD5C2ABFFB0844EFFA8773CFFA673
      37FFA67336FFA67336FFA67336FFA67336FF077C00FF82CD7CFF64C35EFF61C2
      5BFF60C359FF63D45BFF62DA5AFF61DF59FF60E358FF2CB924FF079800FF0897
      00FF279A21FFD4E0D3FFEBECECFFFCFDFDFFFFFFFFFFFFFFFFFFFFFFFFFFE4F5
      E3FF65E55DFF58E64EFF51D648FF48D13FFF24C91AFF0DCC00FF0CC600FF0BBF
      00FF0BB800FF0AB100FF5AC154FF077C00FF565656F2E9E9E9FFE9E9E9FFE9E9
      E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9
      E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFDDDDDDFF767676FFAFAFAFFF8A8A
      8AFF888888FFCCCCCCFF838383FF818181FF7E7E7EFF808080FFCACACAFF8787
      87FF8D8D8DFFD9D9D9FFD9D9D9FF505050F20000000000000000000000006262
      62FFFDFDFDFFD8D8D8FFA3A7AAFFFADCC5FFFFD3A5FFFFD3A3FFFFCD99FFFFCC
      96FFFFCC96FFFFCC97FFFFCC96FFFFCB96FFFFCC97FFFFCF9DFFFFD5A7FFFFDF
      B8FFF5CBA3FF887C74FF57595AFFDDDDDDFFF5F5F5FF9F9F9FFF040404740000
      000000000000000000000000000000000000A97639FFA97639FFA97639FFA977
      3AFFAB7A3EFFB28750FFC7A985FFF2F1F1FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2
      F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2
      F2FFF2F2F2FFF2F2F2FFF2F1F1FFF1F0F0FFD7C4ADFFB28750FFAB7A3FFFA976
      3AFFA97639FFA97639FFA97639FFA97639FF077C00FF92D38EFF71CE6BFF6CC7
      67FF6AC464FF6ACA64FF6DDC66FF6DE265FF6CE664FF6AE961FF22AE19FF1EA2
      17FFE0F1DFFFEBECECFFE8E9E9FFEBECECFFFCFDFDFFFFFFFFFFE8F6E8FF6DE5
      65FF61E957FF5EE855FF5DE654FF58D650FF57D04FFF3EC936FF11C604FF0BC0
      00FF0BB900FF0AB200FF67C661FF077C00FF595959F2EEEEEEFFEEEEEEFFEEEE
      EEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEE
      EEFFEEEEEEFFEEEEEEFFEEEEEEFFE1E1E1FF7C7C7CFFAAAAAAFFE1E1E1FFE0E0
      E0FFDFDFDFFFDEDEDEFFDEDEDEFFDDDDDDFFDCDCDCFFDCDCDCFFDCDCDCFFDCDC
      DCFFDCDCDCFFDCDCDCFFDCDCDCFF535353F20000000000000000000000006464
      64FFFDFDFDFFE1E1E1FFA0A4A7FFF7DBC8FFFFC892FFFFCC97FFFFCD99FFFFD0
      9EFFFFD2A2FFFFD2A4FFFFD2A4FFFFD1A1FFFFCE9CFFFFCC96FFFFCC97FFFFD8
      A8FFECB88EFF817975FF5F6162FFE6E6E6FFF5F5F5FFA0A0A0FF040404740000
      000000000000000000000000000000000000AD7A3CFFAD7A3CFFAD7A3CFFAD7B
      3DFFAF7D41FFB58850FFC7A780FFF4F3F3FFF4F3F3FFF4F3F3FFF4F3F3FFF4F3
      F3FFF4F3F3FFF4F3F3FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4
      F4FFF4F4F4FFF4F3F3FFF0EEECFFD3BCA0FFBB9462FFB3854BFFAF7D40FFAD7B
      3DFFAD7A3CFFAD7A3CFFAD7A3CFFAD7A3CFF077C00FFA1DA9EFF7DD477FF7BD6
      75FF75CA70FF73CC6EFF74D16EFF78E371FF78E870FF77EC6FFF72E26BFFD6EE
      D4FFFFFFFFFFFCFDFDFFEBECECFFE8E9E9FFEBECECFFEAF5E9FF31AA2BFF4ACE
      41FFB0F4ABFFAAF3A4FF69EA60FF67E85FFF63D45BFF60CE59FF52C94AFF17C3
      0CFF0BBA00FF0AB400FF75CC6FFF077C00FF5D5D5DF2F2F2F2FFF2F2F2FFF2F2
      F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2
      F2FFF2F2F2FFF2F2F2FFE3E3E3FF7E7E7EFFB1B1B1FFE4E4E4FFD6D6D6FFE2E2
      E2FFE1E1E1FFD2D2D2FFE0E0E0FFDFDFDFFFDFDFDFFFDEDEDEFFCECECEFFDEDE
      DEFFCECECEFFDEDEDEFFDEDEDEFF565656F20000000000000000000000006666
      66FFFBFBFBFFF3F3F3FF9B9EA0FFE8D9D1FFFFBF8BFFFFD19FFFFFD3A6FFFFD6
      ACFFFFD8B0FFFFD9B2FFFFD9B1FFFFD8AFFFFFD5AAFFFFD2A3FFFFCD9AFFFFD2
      9AFFD19C76FF6F7072FF787979FFF0F0F0FFF4F4F4FFA1A1A1FF050505740000
      000000000000000000000000000000000000B17D3FFFB17D3FFFB17D3FFFB17E
      40FFB28042FFB6874CFFC29C6DFFE8DED2FFEBE3D9FFECE4DBFFECE5DCFFECE5
      DCFFECE5DCFFEDE6DEFFEEE8E1FFF2F0EDFFF6F6F6FFF6F6F6FFF6F6F6FFF6F6
      F6FFF6F5F5FFEEE8E1FFCEB18DFFBF9765FFB78950FFB38245FFB27E40FFB17D
      3FFFB17D3FFFB17D3FFFB17D3FFFB17D3FFF077C00FFB0E0ACFF8AD985FF8ADC
      84FF88DD82FF80D17AFF7DD278FF7ED778FF84E97CFF80E879FFD0EDCEFFFFFF
      FFFFFFFFFFFFFFFFFFFFFCFDFDFFEBECECFFDEE4DEFF3DA438FF089700FF7BC9
      77FFFFFFFFFFFEFFFEFF9FF299FF73EB6BFF71E669FF6CD365FF6ACD64FF62CA
      5BFF1ABF10FF0BB600FF83D37CFF077C00FF2121218E606060F2606060F26060
      60F2606060F2606060F26B6B6BFE727272FF727272FFF6F6F6FFF6F6F6FFF6F6
      F6FFF6F6F6FFE6E6E6FF7D7D7DFFACACACFFE8E8E8FFA0A0A0FFA2A2A2FFA4A4
      A4FFE5E5E5FF8F8F8FFF8B8B8BFFD2D2D2FF868686FF919191FFC7C7C7FF9797
      97FF838383FFE1E1E1FFE1E1E1FF585858F20000000000000000000000006868
      68FFFBFBFBFFFFFFFFFFAFAFAFFFC0C2C4FFFCC3A2FFFFD0A1FFFFDBB4FFFFDD
      B8FFFFDFBDFFFFE0C0FFFFE0BFFFFFDEBCFFFFDBB6FFFFD7AEFFFFD8AAFFFDBD
      87FFA88A79FF5A5F61FFB2B2B1FFEFEFEFFFF5F5F5FFA3A3A3FF060606740000
      000000000000000000000000000000000000B48142FFB48142FFB48142FFB481
      42FFB58243FFB78549FFBA8C53FFC09662FFC49D6DFFC59F70FFC5A071FFC5A0
      71FFC6A173FFC8A579FFCFB18CFFE6DACBFFF7F7F6FFF7F7F7FFF7F7F6FFF7F7
      F6FFE7DBCDFFCAA87DFFC09661FFB98A50FFB68447FFB58243FFB48142FFB481
      42FFB48142FFB48142FFB48142FFB48142FF077C00FFBDE5BAFF96DF91FF95E1
      90FF94E38FFF93E48DFF8AD885FF87D782FF85D980FFC8E8C6FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFF7FBF7FF44A73FFF0E8E07FF73BA70FFFCFD
      FDFFFFFFFFFFFFFFFFFFF9FEF9FF98F093FF7DEB76FF7BE574FF75D36FFF73CD
      6DFF66CA61FF17BD0DFF90D98CFF077C00FF0000000000000000000000000000
      000000000000000000005B5B5BF2F1F1F1FF757575FFF8F8F8FFF8F8F8FFF8F8
      F8FFE8E8E8FF818181FFBEBEBEFFECECECFFEBEBEBFFEAEAEAFFEAEAEAFFE9E9
      E9FFE8E8E8FFE7E7E7FFE7E7E7FFE6E6E6FFE5E5E5FFE5E5E5FFE4E4E4FFE4E4
      E4FFE4E4E4FFE4E4E4FFE4E4E4FF5B5B5BF20000000000000000000000006A6A
      6AFFFBFBFBFFFCFCFCFFE6E6E6FF95999AFFE6D7D1FFFBB58CFFFFDFBCFFFFE6
      CAFFFFE5CBFFFFE7CEFFFFE7CDFFFFE4C9FFFFE1C2FFFFE3C0FFFFD0A1FFC78C
      6CFF828486FF696A6AFFECECECFFE9E9E9FFF6F6F6FFA4A4A4FF060606740000
      000000000000000000000000000000000000B88445FFB88445FFB88445FFB884
      45FFB88446FFB98547FFB9874AFFBB8A4EFFBD8D52FFBD8D53FFBD8D53FFBD8D
      53FFBE8F55FFC0935CFFC8A172FFE4D4C0FFF9F9F8FFF9F9F8FFF7F6F4FFDFCB
      B3FFC9A375FFC0935DFFBC8B50FFB98649FFB88446FFB88445FFB88445FFB884
      45FFB88445FFB88445FFB88445FFB88445FF077C00FFC9EBC7FFA3E49EFFA1E6
      9CFFA0E79BFF9FEA9AFF9DEA98FF92DB8EFFB2D3B0FFEBECECFFFCFDFDFFFFFF
      FFFFFFFFFFFFFFFFFFFFF9FDF9FF50B64AFF089700FF73BA70FFE8E9E9FFEBEC
      ECFFFCFDFDFFFFFFFFFFFFFFFFFFF3FDF3FF97F191FF8AEB83FF86E680FF7ED4
      79FF7CCE77FF6ACD64FF9EDE9AFF077C00FF0000000000000000000000000000
      000000000000000000005E5E5EF2F3F3F3FF797979FFFBFBFBFFFBFBFBFFE9E9
      E9FF818181FFC5C5C5FFEFEFEFFFEEEEEEFFEDEDEDFFEDEDEDFFECECECFFDCDC
      DCFFEAEAEAFFE9E9E9FFE4E4E4FFD2D2D2FFC8C8C8FFC7C7C7FFC6C6C6FFC5C5
      C5FFC5C5C5FFC7C7C7FFD4D4D4FF5D5D5DF20000000000000000000000006C6C
      6CFFFCFCFCFFF9F9F9FFFFFFFFFFC1C1C1FF9FA4A6FFE7CFC5FFF6AD8AFFFFD6
      B8FFFFF2DEFFFFF6E6FFFFF6E5FFFFF3DFFFFFE9CEFFFBC099FFCB8B6DFF9794
      94FF5D5F60FFCECECEFFF0F0F0FFE9E9E9FFF6F6F6FFA5A5A5FF070707740000
      000000000000000000000000000000000000BC8848FFBC8848FFBC8848FFBC88
      48FFBC8848FFBC8848FFBC8849FFBD8949FFBD894AFFBC894AFFBD8A4BFFBD8A
      4BFFBD8A4CFFBF8E52FFC79C67FFE4D0B8FFFAFAFAFFF4EFE9FFD9BD9BFFC9A1
      6FFFC2945BFFBE8D50FFBD8A4BFFBC8849FFBC8848FFBC8848FFBC8848FFBC88
      48FFBC8848FFBC8848FFBC8848FFBC8848FF077C00FFD5EFD3FFAEE9AAFFADEA
      A9FFACECA8FFABEEA7FFA7EDA2FFB4E1B3FFEBECECFFE8E9E9FFEBECECFFFCFD
      FDFFFFFFFFFFFDFEFDFFA7E6A3FF4DC247FF079800FF8ACD86FFEBECECFFE8E9
      E9FFEBECECFFFCFDFDFFFFFFFFFFFFFFFFFFEBFCEAFF9AF094FF94EC8EFF92E7
      8CFF89D584FF89D584FFB8E1B6FF077C00FF0000000000000000000000000000
      00000000000000000000606060F2F6F6F6FF7B7B7BFFFCFCFCFFEBEBEBFF8282
      82FFC4C4C4FFBCBCBCFFF2F2F2FFB2B2B2FFCDCDCDFFCECECEFFEFEFEFFF9F9F
      9FFF9B9B9BFFECECECFFD6D6D6FF6E6E6EFF6E6E6EFF6E6E6EFF6E6E6EFF6E6E
      6EFF6E6E6EFF6E6E6EFF6E6E6EFF878787FF0000000000000000000000006E6E
      6EFFFCFCFCFFFAFAFAFFF9F9F9FFFEFEFEFFB8B8B8FF9BA1A3FFD3C8C4FFE7AD
      98FFEEA78CFFF4B49CFFF5B79EFFEFAB8FFFDC9578FFBB9284FF929496FF686B
      6CFFC3C3C2FFF5F5F5FFEBEBEBFFEAEAEAFFF7F7F7FFA7A7A7FF080808740000
      000000000000000000000000000000000000C08B4BFFC08B4BFFC08B4BFFC08B
      4BFFC08B4BFFC08B4BFFC08B4BFFC08B4BFFC08B4BFFC08B4BFFC08B4BFFC08B
      4BFFC08C4CFFC28F51FFC79960FFE1C9ACFFECDECDFFD2AD81FFCA9E6AFFC494
      59FFC28F51FFC18C4DFFC08B4CFFC08B4BFFC08B4BFFC08B4BFFC08B4BFFC08B
      4BFFC08B4BFFC08B4BFFC08B4BFFC08B4BFF077C00FFDBEFDAFFB8EDB5FFB9EF
      B5FFB8F0B4FFB6F1B2FFB3E2B1FFFFFFFFFFFCFDFDFFEBECECFFE8E9E9FFEBEC
      ECFFFCFDFDFFACE5A9FFADF3A8FFACF3A7FF52C24CFF079800FF8CCD88FFEBEC
      ECFFE8E9E9FFEBECECFFFCFDFDFFFFFFFFFFFFFFFFFFE2FBE1FFA1EF9BFF9EED
      99FF9CE897FF95DB91FFCFE8CDFF087B01FF0000000000000000000000000000
      00000000000000000000636363F2F7F7F7FFA4A4A4FFECECECFF848484FFD1D1
      D1FFF5F5F5FFF4F4F4FFF3F3F3FFF3F3F3FFF2F2F2FFF1F1F1FFF0F0F0FFF0F0
      F0FFEFEFEFFFEEEEEEFFD3D3D3FF848484FFF3F3F3FFECECECFFE4E4E4FFDBDB
      DBFFD2D2D2FFC9C9C9FF878787FF000000060000000000000000000000007070
      70FFFDFDFDFFFBFBFBFFF9F9F9FFF9F9F9FFFFFFFFFFD0D0CFFF9B9E9FFFA7AD
      AFFFBBB4B2FFC1AAA3FFBEA29AFFB19F9AFF9C9C9DFF83898CFF8B8C8CFFDADA
      DAFFF7F7F7FFECECECFFECECECFFEBEBEBFFF7F7F7FFA8A8A8FF090909740000
      000000000000000000000000000000000000C38E4EFFC38E4EFFC38E4EFFC38E
      4EFFC38E4EFFC38E4EFFC38E4EFFC38E4EFFC38E4EFFC38E4EFFC38E4EFFC38E
      4EFFC38E4FFFC49051FFC79558FFCCA06BFFCB9E67FFCA9A61FFC79558FFC491
      52FFC38F4FFFC38E4EFFC38E4EFFC38E4EFFC38E4EFFC38E4EFFC38E4EFFC38E
      4EFFC38E4EFFC38E4EFFC38E4EFFC38E4EFF077C00FFE3F2E2FFBFE9BCFFC4F1
      C1FFC4F4C1FFAFE0ACFFFFFFFFFFFFFFFFFFFFFFFFFFFCFDFDFFEBECECFFE8E9
      E9FFA8D5A6FFB8F3B4FFB9F5B5FFB8F5B4FFB6F5B2FF57C351FF079800FF8CCD
      88FFEBECECFFE8E9E9FFEBECECFFFCFDFDFFFFFFFFFFFFFFFFFFDCFADAFFAAF1
      A5FFA9EFA4FFA7EBA2FFDBEDD9FF097A01FF0000000000000000000000000000
      00000000000000000000656565F2F9F9F9FFD6D6D6FF838383FFD0D0D0FFF7F7
      F7FFF6F6F6FFEBEBEBFFF5F5F5FFF4F4F4FFF4F4F4FFE5E5E5FFF2F2F2FFF2F2
      F2FFE1E1E1FFF0F0F0FFD6D6D6FF848484FFEBEBEBFFE3E3E3FFDADADAFFD1D1
      D1FFC7C7C7FF878787FF00000000000000000000000000000000000000007272
      72FFFEFEFEFFFCFCFCFFFAFAFAFFF9F9F9FFF9F9F9FFFEFEFEFFF5F5F5FFCFCF
      CFFFB2B3B4FFA9ACADFFA7ABADFFA5A7A8FFB1B2B2FFD5D5D5FFF7F7F7FFF4F4
      F4FFEEEEEEFFEEEEEEFFEDEDEDFFECECECFFF8F8F8FFA9A9A9FF090909740000
      000000000000000000000000000000000000C79251FFC79251FFC79251FFC792
      51FFC79251FFC79251FFC79251FFC79251FFC79251FFC79251FFC79251FFC792
      51FFC79251FFC79352FFC89454FFC99657FFC99758FFC99556FFC89353FFC792
      52FFC79251FFC79251FFC79251FFC79251FFC79251FFC79251FFC79251FFC792
      51FFC79251FFC79251FFC79251FFC79251FF077C00FFEBF5EBFFC8EBC7FFC5E8
      C3FF64C35FFF079800FF079800FF079800FF079800FF079800FF089700FF68BC
      63FFB6E2B4FFB7E4B5FFC2F5BFFFC3F7C0FFC3F6BFFFC2F6BEFF5CC356FF0798
      00FF089700FF0D8F06FF0E8E07FF0D8F06FF089700FF53C04DFFB7F5B3FFB6F4
      B2FFB5F2B1FFB3F1AFFFEBF8EAFF087B01FF0000000000000000000000000000
      00000000000000000000676767F2FAFAFAFFFAFAFAFFD4D4D4FFD7D7D7FFCFCF
      CFFFF8F8F8FFC4C4C4FFBFBFBFFFEAEAEAFFF5F5F5FFB1B1B1FFF4F4F4FFA8A8
      A8FFA3A3A3FFF2F2F2FFD8D8D8FF848484FFE2E2E2FFD9D9D9FFD0D0D0FFC7C7
      C7FF878787FF0000000000000000000000000000000000000000000000007474
      74FFFEFEFEFFFDFDFDFFFBFBFBFFFAFAFAFFFAFAFAFFF9F9F9FFF9F9F9FFFDFD
      FDFFFEFEFEFFFAFAFAFFF8F8F8FFFAFAFAFFFBFBFBFFF7F7F7FFF1F1F1FFF0F0
      F0FFEFEFEFFFEFEFEFFFEEEEEEFFECECECFFF9F9F9FFAAAAAAFF090909740000
      000000000000000000000000000000000000CB9554FFCB9554FFCB9554FFCB95
      54FFCB9554FFCB9554FFCB9554FFCB9554FFCB9554FFCB9554FFCB9554FFCB95
      54FFCB9554FFCB9554FFCB9555FFCB9655FFCB9655FFCB9555FFCB9554FFCB95
      54FFCB9554FFCB9554FFCB9554FFCB9554FFCB9554FFCB9554FFCB9554FFCB95
      54FFCB9554FFCB9554FFCB9554FFCB9554FF077C00FFF6FBF5FFD6F0D4FFCEE9
      CDFFCBE7CAFFD8F8D6FFD9FAD7FFD8FAD6FFD7F9D5FFD5F9D3FFD4F9D2FFD2F7
      CFFFC4E6C2FFC0E3BEFFC2E5C0FFCDF6CAFFCEF8CBFFCDF8CAFFCCF8C9FFCBF8
      C8FFC9F7C6FFC6F5C3FFB9E4B7FFB6E2B4FFB7E4B5FFC2F5BFFFC3F6BFFFC2F6
      BEFFC1F6BDFFC0F5BCFFF3FCF3FF077C00FF0000000000000000000000000000
      00000000000000000000696969F2FBFBFBFFFBFBFBFFFAFAFAFFFAFAFAFFFAFA
      FAFFF9F9F9FFF8F8F8FFF8F8F8FFF7F7F7FFF7F7F7FFF6F6F6FFF6F6F6FFF5F5
      F5FFF5F5F5FFF4F4F4FFD9D9D9FF848484FFD7D7D7FFCECECEFFC6C6C6FF8787
      87FF000000000000000000000000000000000000000000000000000000007676
      76FFFFFFFFFFFEFEFEFFFCFCFCFFFBFBFBFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8
      F8FFF7F7F7FFF6F6F6FFF5F5F5FFF5F5F5FFF4F4F4FFF3F3F3FFF2F2F2FFF1F1
      F1FFF0F0F0FFEFEFEFFFEFEFEFFFEDEDEDFFF9F9F9FFACACACFF0A0A0A740000
      000000000000000000000000000000000000B9894FF2CE9857FFCE9857FFCE98
      57FFCE9857FFCE9857FFCE9857FFCE9857FFCE9857FFCE9857FFCE9857FFCE98
      57FFCE9857FFCE9857FFCE9857FFCE9857FFCE9857FFCE9857FFCE9857FFCE98
      57FFCE9857FFCE9857FFCE9857FFCE9857FFCE9857FFCE9857FFCE9857FFCE98
      57FFCE9857FFCE9857FFCE9857FFB8884EF1077C00FFFBFEFBFFE9FBE8FFDBEE
      DAFFD3E6D3FFD5E9D4FFE3F9E1FFE4FBE2FFE3FBE1FFE2FBE0FFE1FBDFFFDFFA
      DDFFDCF8DAFFCDE7CBFFC9E4C8FFCBE7CAFFD8F8D6FFD8FAD6FFD7F9D5FFD6F9
      D4FFD5F9D3FFD4F9D2FFD2F7CFFFC3E6C1FFC0E2BDFFC1E5BFFFCDF6CAFFCEF8
      CBFFCCF8C9FFCCF8CAFFFAFDFAFF077C00FF0000000000000000000000000000
      000000000000000000006B6B6BF2FCFCFCFFFCFCFCFFFBFBFBFFFBFBFBFFFAFA
      FAFFFAFAFAFFF9F9F9FFF9F9F9FFF8F8F8FFF8F8F8FFF7F7F7FFF7F7F7FFF6F6
      F6FFF6F6F6FFF5F5F5FFDBDBDBFF848484FFCDCDCDFFC5C5C5FF878787FF0000
      0000000000000000000000000000000000000000000000000000000000007A7A
      7AFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFFDFDFDFFFCFCFCFFFBFBFBFFFBFB
      FBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4F4FFF3F3
      F3FFF2F2F2FFF1F1F1FFF1F1F1FFEFEFEFFFFDFDFDFFB0B0B0FF0B0B0B780000
      000000000000000000000000000000000000785834C1D29C5AFFD29C5AFFD29C
      5AFFD29C5AFFD29C5AFFD29C5AFFD29C5AFFD29C5AFFD29C5AFFD29C5AFFD29C
      5AFFD29C5AFFD29C5AFFD29C5AFFD29C5AFFD29C5AFFD29C5AFFD29C5AFFD29C
      5AFFD29C5AFFD29C5AFFD29C5AFFD29C5AFFD29C5AFFD29C5AFFD29C5AFFD29C
      5AFFD29C5AFFD29C5AFFD29C5AFF785834C1077400F7F7FCF6FFF7FEF7FFF2FB
      F1FFE0EAE0FFDDE7DCFFDFEADEFFEEFBEDFFEEFDEDFFEDFCECFFECFCEBFFEBFC
      EAFFEAFCE9FFE7FAE6FFD6E9D5FFD2E6D2FFD4E8D3FFE3F9E1FFE4FBE2FFE2FB
      E0FFE1FBDFFFE0FBDEFFDFFADDFFDCF8DAFFCDE7CBFFC8E4C7FFCAE7C9FFD7F8
      D5FFD8FAD6FFE0FADFFFF3FCF2FF077400F70000000000000000000000000000
      000000000000000000006D6D6DF2FDFDFDFFFCFCFCFFFCFCFCFFFCFCFCFFFBFB
      FBFFFBFBFBFFFAFAFAFFFAFAFAFFF9F9F9FFF9F9F9FFF8F8F8FFF8F8F8FFF8F8
      F8FFF7F7F7FFF7F7F7FFDFDFDFFF848484FFC3C3C3FF878787FF000000000000
      0000000000000000000000000000000000000000000000000000000000004040
      40DADDDDDDFFF6F6F6FFF5F5F5FFF5F5F5FFF4F4F4FFF4F4F4FFF3F3F3FFF3F3
      F3FFF2F2F2FFF2F2F2FFF1F1F1FFF1F1F1FFF0F0F0FFF0F0F0FFEFEFEFFFEFEF
      EFFFEFEFEFFFEEEEEEFFEEEEEEFFEDEDEDFFEFEFEFFF7E7E7EFF060606520000
      00000000000000000000000000000000000035281780D69F5DFFD69F5DFFD69F
      5DFFD69F5DFFD69F5DFFD69F5DFFD69F5DFFD69F5DFFD69F5DFFD69F5DFFD69F
      5DFFD69F5DFFD69F5DFFD69F5DFFD69F5DFFD69F5DFFD69F5DFFD69F5DFFD69F
      5DFFD69F5DFFD69F5DFFD69F5DFFD69F5DFFD69F5DFFD69F5DFFD69F5DFFD69F
      5DFFD69F5DFFD69F5DFFD69F5DFF35281780044F00CBC4EBC1FFFFFFFFFFFFFF
      FFFFFCFDFCFFEEF0EFFFEBEEEBFFECF0EDFFF8FCF8FFF9FEF9FFF7FEF7FFF6FE
      F6FFF6FEF5FFF5FEF4FFF2FBF1FFE5EFE4FFE1ECE1FFE2EFE2FFEDFBECFFEEFD
      EDFFEDFCECFFEBFCEAFFEAFCE9FFE9FCE8FFE6FAE5FFDAEED9FFD7EBD7FFD8ED
      D7FFE3F9E1FFF8FEF8FFBDE9BAFF044F00CB0000000000000000000000000000
      000000000000000000006F6F6FF2FDFDFDFFFDFDFDFFFCFCFCFFFCFCFCFFFCFC
      FCFFFBFBFBFFFBFBFBFFFBFBFBFFFAFAFAFFFAFAFAFFF9F9F9FFF9F9F9FFF8F8
      F8FFF8F8F8FFF8F8F8FFE4E4E4FF848484FF878787FF00000004000000000000
      0000000000000000000000000000000000000000000000000000000000000303
      033B383838D35F5F5FF95D5D5DF85D5D5DF85D5D5DF85D5D5DF85D5D5DF85D5D
      5DF85D5D5DF85D5D5DF85D5D5DF85D5D5DF85D5D5DF85D5D5DF85D5D5DF85D5D
      5DF85D5D5DF85E5E5EF85E5E5EF8606060F9545454F316161696000000040000
      00000000000000000000000000000000000000000008987243D6D9A260FFD9A2
      60FFD9A260FFD9A260FFD9A260FFD9A260FFD9A260FFD9A260FFD9A260FFD9A2
      60FFD9A260FFD9A260FFD9A260FFD9A260FFD9A260FFD9A260FFD9A260FFD9A2
      60FFD9A260FFD9A260FFD9A260FFD9A260FFD9A260FFD9A260FFD9A260FFD9A2
      60FFD9A260FFD9A260FF987243D6000000080111005F1E8E16FFF5FDF4FFFFFF
      FFFFFFFFFFFFFEFEFEFFF5F5F5FFF4F4F4FFF5F5F5FFFEFEFEFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFEFDFFF3F5F3FFF1F4F1FFF0F4F1FFF8FD
      F8FFF8FEF8FFF7FEF7FFF6FEF6FFF6FEF5FFF4FDF3FFF2FCF1FFE9F3E8FFE9F2
      E9FFF1F5F2FFF1FBF0FF1D8D15FF0110005D0000000000000000000000000000
      000000000000000000002626268E707070F2707070F2707070F2707070F27070
      70F2707070F2707070F2707070F2707070F2707070F2707070F2707070F27070
      70F2707070F2707070F2848484FF878787FF0000000900000001000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000705032DA17A4BD9E1AC
      6DFFE0AE70FFE0AF71FFE0AF71FFE0AF71FFE0AF71FFE0AF71FFE0AF71FFE0AF
      71FFE0AF71FFE0AF71FFE0AF71FFE0AF71FFE0AF71FFE0AF71FFE0AF71FFE0AF
      71FFE0AF71FFE0AF71FFE0AF71FFE0AF71FFE0AF71FFE0AF71FFE0AF71FFE0AE
      70FFDFAC6CFF9F794AD80605032D0000000000000000032E009C1E8E16FFC7ED
      C5FFFBFEFBFFFFFFFFFFFEFEFEFFFAFAFAFFF9F9F9FFFAFAFAFFFEFEFEFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFFAFAFAFFF9F9F9FFFAFA
      FAFFFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFF6F9
      F5FFC2E7C0FF1F8C17FF032E009C000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000010000000A050504285946
      319E9F7E56D3D6AA73F6E6B57BFFE6B57BFFE6B57BFFE6B57BFFE6B57BFFE6B5
      7BFFE6B57BFFE6B57BFFE6B57BFFE6B57BFFE6B57BFFE6B57BFFE6B57BFFE6B5
      7BFFE6B57BFFE6B57BFFE6B57BFFE6B57BFFE6B57BFFE6B57BFFD6AA73F69C7C
      55D256442F9C04030323000000070000000100000000000000000110005D044D
      00C9077400F7077C00FF077C00FF077C00FF077C00FF077C00FF077C00FF077C
      00FF077C00FF077C00FF077C00FF077C00FF077C00FF077C00FF077C00FF077C
      00FF077C00FF077C00FF077C00FF077C00FF077C00FF077C00FF077C00FF0774
      00F7044D00C90110005D00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00030000000C00000014000000160000001600000016000000140000000C0000
      00030000000000000000000000000000000000000015030303310505053C0606
      063E080808440B0B0B4B0A0A0A4A0A0A0A490909094709090946080808440808
      0844080707440707074307070743070707440808084416431DB621AE20FF1332
      179F0707074207070742070707410606063F0303033400000016000000030000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000140000004C0000004D0000004D0000004D0000004D0000
      004D0000004D0000004D0000004D0000004D0000004D0000004D0000004C0000
      001F000000020000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000001000000080000
      00190000002E0000003D0000004200000043000000420000003D0000002E0000
      0019000000090000000100000000000000000000001E0000003B000000430000
      00400000003E0000003E0000003E0000003D0000003D0000003D0000003D0000
      003D0000003E0000003E0000003E0000003E0E3512AD21B91BFF22F404FF21B9
      1BFF0A260D9800000040000000400000003D000000370000001E000000060000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000100000028FAFAFAFFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7
      F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FF9292
      92E400000027000000020000000000000000000000020000000B000000130000
      0016000000160000001600000016000000160000001600000016000000160000
      0016000000160000001600000016000000160000001600000019000000270000
      003E363634B67A7977FA817D7BFF817D7BFF817D7BFF7A7977FA363634B60000
      003E000000240000000C000000010000000000000005606060BE9D9D9DF29F9F
      9FF39F9F9FF39F9F9FF39F9F9FF39F9F9FF39F9F9FF39F9F9FF39F9F9FF39F9F
      9FF39F9F9FF39F9F9FF39F9F9FF35A9362FA21B91BFF22FE00FF22FF00FF22F0
      05FF21B91BFF69966FF89F9F9FF39F9F9FF35F5F5FBE00000006000000000000
      00000000000000000000000000000000000000000000020C1A78031935A80011
      2FA3001231A6001231A6001331A8001331A8001331A8001232A9001334AA0012
      34A9001337AD001334A8001334A9001235AC001234A9001132A8001233AC0012
      33AC001131AB001033AD00102FAB000F2DA8001B44B600285EC200265CC00026
      5BC100255AC0032D5EC10210238A000000050000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000100000028F8F8F8FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5
      F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFCDCD
      CDFFB5B5B5F60000003200000002000000000000000B000000260000003D0000
      0043000000430000004300000043000000430000004300000043000000430000
      0043000000430000004300000043000000430000004300000044111010798783
      81FFAFAEADFFD1CFCFFFDCDBDCFFDBDBDBFFDCDBDCFFD1CFCFFFAFAEADFF8683
      81FF1111107700000024000000090000000000000009A0A0A0F4D9D9D9FFD8D8
      D8FFD8D8D8FFD8D8D8FFD7D7D7FFD7D7D7FFD7D7D7FFD7D7D7FFD7D7D7FFD7D7
      D7FFD7D7D7FFD7D7D7FF76AD7EFF21B81CFF21F802FF21FC00FF21FC00FF21FC
      00FF21EA07FF21B81CFF8CB692FFD7D7D7FFA9A9A9FB0000000B000000000000
      000000000000000000000000000000000000000001183B8ACBFF0371E0FF006B
      E0FF0076ECFF0281F7FF0C8BF9FF1794F9FF21A0F9FF2DA7F9FF3AAEFAFF45B4
      F9FF52BBFAFF60C1FAFF6DC5FAFF75CBF9FF7BCCF9FF6DC9FBFF6BC7F9FF5DC2
      F9FF50BAFAFF44B3F9FF38AAF9FF28A2F9FF1C95F6FF118BF4FF0780F1FF047C
      EFFF0278EDFF0988F4FF5196CDFF000000180000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000100000028F9F9F9FFF6F6F6FFF6F6F6FFDEDEDEFFF6F6F6FFDEDE
      DEFFF6F6F6FFDEDEDEFFF5F5F5FFDEDEDEFFF5F5F5FFEEEEEEFFF4F4F4FFC8C8
      C8FFFBFBFBFFBEBEBEF90000003900000001000000131B1B1B98646565FF6565
      65FF656565FF646565FF656565FF656565FF656565FF656565FF656565FF6565
      65FF656565FF656565FF656565FF646464FF616162FF6D6C6BFF918E8BFFC8C7
      C5FFC5C3C2FFACA9A6FFA29F9CFFA29E9CFFA29F9CFFACA9A6FFC5C3C2FFC7C7
      C5FF8E8B89FF1111107300000019000000030000000BA1A1A1F5DCDCDCFFDFDF
      DFFFDFDFDFFFDEDEDEFFDEDEDEFFDDDDDDFFDDDDDDFFDDDDDDFFDCDCDCFFDCDC
      DCFFDCDCDCFF7DB285FF21B61CFF20F105FF20F802FF20F802FF20F802FF20F8
      02FF20F802FF20E40AFF21B31EFF93BA98FFABABABFC0000000D000000000000
      0000000000000000000000000000000000000000000C1A69B4F70072EDFF0075
      F2FF007AFBFF0082FFFF028BFFFF0A97FFFF17A1FFFF24AAFFFF34B2FFFF42BA
      FFFF55C7FFFF67CDFFFF71CEFFFF84D7FFFF83D3FFFF7CD3FFFF6CCDFFFF5CC5
      FFFF4CC0FFFF3EB8FFFF2CA9FFFF1DA4FFFF0F9BFFFF0390FFFF018CFFFF018A
      FFFF008AFFFF088FFEFF265B8AE7000000070000000000000000000000000000
      000000000000000000000000000100000004000000070000000B0000000F0000
      0014000000190000003CF9F9F9FFF6F6F6FFF6F6F6FFF5F5F5FFF6F6F6FFF5F5
      F5FFF6F6F6FFF5F5F5FFF6F6F6FFF5F5F5FFF6F6F6FFF6F6F6FFF6F6F6FFB2B2
      B2FFCFCFCFFFD2D2D2FFA4A4A4F40000001E00000016646464FF5B5958FF5654
      54FF565454FF656666FF565454FF575555FF575555FF575555FF575555FF5755
      55FF575555FF575555FF575454FF555353FF5E5F5EFF908D8BFFC5C3C1FFBAB6
      B4FFADABA8FFE7E6E7FFFFFFFFFFFFFFFFFFFFFFFFFFE7E6E7FFADABA8FFBAB6
      B4FFC3C1BFFF8F8C8AFF0000002E0000000C0000000BA1A1A1F5DCDCDCFFE0DB
      D7FFD5AA86FFD9BFA9FFE0E0E0FFDFDFDFFFDFDFDFFFDEDEDEFFDEDEDEFFDDDD
      DDFF81B388FF20B41EFF1EEA08FF1EF305FF1EF305FF1EF305FF1EF305FF1EF3
      05FF1EF305FF1EF305FF1FDE0DFF20B01FFF769E7CFD0000000D000000000000
      0000000000000000000000000000000000000000000000122F990062D4FF0072
      EEFF0075F4FF007EFCFF0084FFFF078DFFFF1196FFFF1D9EFFFF28A5FFFF33A7
      FFFF40ADFFFF4BB6FFFF50B6FFFF4BB6FFFF4BB7FFFF56BCFFFF4EBAFFFF42B4
      FFFF34ACFFFF2EA7FFFF21A0FFFF169AFFFF088DFFFF0589FFFF058AFFFF048A
      FFFF0695FFFF0259BFFF00061377000000000000000000000000000000000000
      0004000000130000002600000037000000480000005800000068000000790000
      0089000000980000009DF9F9F9FFF7F7F7FFF7F7F7FFDEDEDEFFF7F7F7FFDEDE
      DEFFF7F7F7FFDEDEDEFFF7F7F7FFDEDEDEFFF7F7F7FFDEDEDEFFF7F7F7FFFFC1
      E0FFEDEDEDFFECECECFFFAFAFAFF0000002800000016646464FF696767FF5F5D
      5DFF5F5D5DFF646565FF5F5D5DFF605E5EFF605E5EFF605E5EFF616060FF6160
      60FF605E5EFF605E5EFF5F5D5DFF5C5A5AFF7E7C7BFFB2AFAEFFBEBBB9FFACA9
      A8FFFFFEFEFFFFFFFFFFFFFFFFFF4B4B4BFFFFFFFFFFFFFFFFFFFFFEFEFFACA9
      A8FFBEBBB9FFAFACABFF3B3A39AE000000140000000BA1A1A1F5DFDFDFFFDEB4
      8CFFD48945FFCA7731FFDDD0C4FFD0D0D0FFA6A6A6FFAFAFAFFFC7C7C7FF71A1
      78FF1FB21FFF1CE30CFF1CED08FF1CED08FF1CED08FF1ECB15FF20A125FF1ECB
      15FF1CED08FF1CED08FF1CED08FF1DD810FF238830FF04130665000000000000
      00000000000000000000000000000000000000000000000001180249A1FD0178
      EFFF0071F1FF007AF9FF0081FFFF038AFFFF0C91FFFF1598FFFF1E9FFFFF29A5
      FFFF32ADFFFF37B0FFFF26A6FFFF56BCFFFF50BCFFFF2BA9FFFF3EACFFFF37AD
      FFFF2DA8FFFF24A2FFFF199CFFFF0F95FFFF068CFFFF078CFFFF078CFFFF0790
      FFFF0A89F7FF002565EB0000000A000000000000000000000000000000000000
      000000000000000000000000000800000013080401463E2612A17C542ED69A72
      45E8B88E5EF99B784FF8FAFAFAFFF8F8F8FFF8F8F8FFF7F7F7FFF8F8F8FFF7F7
      F7FFF8F8F8FFF7F7F7FFF8F8F8FFF7F7F7FFF8F8F8FFF7F7F7FFF8F8F8FFF8F6
      F7FFF8F8F8FFF8F8F8FFFAFAFAFF0000002800000016626363FF777574FF6664
      63FF676564FF676564FF676564FF676564FF686664FF686666FF5A5B5BFF5A5B
      5BFF686666FF686664FF676564FF62605FFF979492FFC1BEBDFFA8A5A3FFE3E2
      E1FFFEFEFDFFFBFBFAFFFFFFFEFFFFFFFFFFFFFFFEFFFBFCFAFFFEFEFDFFE3E2
      E1FFA8A5A3FFC0BDBCFF908E8DF9000000160000000BA1A1A1F5E1E1E1FFE8C7
      A4FFEAAE6EFFCF833FFFE0D5CBFFB1B1B1FF8F8F8FFFA8A8A8FFADAFAEFF4791
      51FF1EB11FFF1AE60BFF1AE60BFF1AE60BFF1DC319FF2B8B38FFA9C2ACFF499A
      54FF1EB41EFF1AE60BFF1AE60BFF1AE60BFF1CD113FF21842EFC040F05570000
      0000000000000000000000000000000000000000000000000000000F268D2187
      DDFF0783F5FF0074F4FF007CFCFF0085FFFF078CFFFF0E93FFFF179AFFFF1E9F
      FFFF29A5FFFF229DFFFF73CCFFFFFEFDFFFFFAFDFFFF6BC6FFFF24A2FFFF2CA8
      FFFF22A2FFFF1A9DFFFF1297FFFF088EFFFF068EFFFF088EFFFF078EFFFF0C9F
      FFFF085DBCFF00040E6900000000000000000000000000000000000000000000
      000000000000000000000201001B674423C0D2A671FFEDD3A4FFF7EBBFFFEDDC
      AFFFE7D2A3FFC3AF88FFFBFBFBFFF9F9F9FFF9F9F9FFDEDEDEFFF9F9F9FFDEDE
      DEFFF9F9F9FFDEDEDEFFFEFEFEFFDEDEDEFFF8F8F8FFDEDEDEFFF8F8F8FFFFC1
      E0FFF8F8F8FFF8F8F8FFFAFAFAFF0000002800000016616262FF858382FF6B69
      68FF6D6B6AFF6D6B6AFF6D6B6AFF6E6C6BFF6A6968FF656666FF4F4F4FFF4F4F
      4FFF656666FF6A6968FF6D6B6AFF686665FFA3A09EFFC1BFBDFFA19D9BFFFFFF
      FFFFFDFDFCFFFCFCFBFFFFFFFFFF555555FFFFFFFFFFFEFEFDFFFDFDFCFFFFFF
      FFFFA19E9CFFC0BEBCFF9D9A98FF000000160000000BA1A1A1F5E4E4E4FFE8E7
      E5FFE8D2BBFFE1D0C1FFE6E6E6FFE5E5E5FFE5E5E5FFE4E4E4FFE3E3E3FFDEE1
      DFFF69AA72FF1DAC21FF19DB10FF1BC11AFF2C8D39FFB8CDBBFFDFDFDFFFD4DA
      D5FF479952FF1DB21FFF18E00EFF18E00EFF18E00EFF1ACA16FF21842EFC030E
      0554000000000000000000000000000000000000000000000000000000130F52
      9CFA3DA7F7FF158FF5FF007CF8FF0076FEFF0086FFFF078FFFFF0D93FFFF1598
      FFFF1A9DFFFF1799FFFFD9F0FFFFFEFEFFFFFEFEFFFFCCEDFFFF1A9BFFFF1DA0
      FFFF179BFFFF1196FFFF088FFFFF078DFFFF088EFFFF088AFFFF0A94FFFF1192
      F7FF00235BE30000000600000000000000000000000000000000000000000000
      0000000000001B100764B08554EEEDD7A9FFF0DEB1FFDCC190FFCCAA73FFC6A1
      6DFFCCAC85FFAB8F6DFFFBFBFBFFF9F9F9FFF9F9F9FFF8F8F8FFF9F9F9FFF8F8
      F8FFF9F9F9FFF8F8F8FFF9F9F9FFF8F8F8FFF9F9F9FFF8F8F8FFF9F9F9FFF9F7
      F8FFF9F9F9FFF9F9F9FFFBFBFBFF0000002800000012616161FF939190FF7270
      6FFF737170FF747271FF767372FF6E6D6BFF626363FF646464FF404040FF4040
      40FF646464FF626363FF6D6C6BFF706E6DFFA7A4A2FFC0BDBBFF9F9C9AFFFFFF
      FEFF4E4E4EFFFEFEFCFF565656FFA5A5A6FF595959FF7E7E80FFA7A7A8FFD5D4
      D4FFA09D9BFFBFBCBAFFA29E9CFF000000160000000CA1A1A1F5E6E6E6FFEBEB
      EBFFEAEAEAFFE9E9E9FFE9E9E9FFE8E8E8FFE7E7E7FFE7E7E7FFE6E6E6FFE5E5
      E5FFE4E4E4FF7CB385FF1CA923FF288B35FFB5CDB8FFE1E1E1FFE1E1E1FFE0E0
      E0FFD3DAD4FF459950FF1CB021FF16D912FF16D912FF16D912FF19C41AFF2082
      2DF9030D04510000000000000000000000000000000000000000000000000009
      18762F8BD6FF37AAF9FF289BF7FF098BFAFF007CFFFF0085FFFF058BFFFF0A90
      FFFF1094FFFF0D92FFFF7BC9F8FFFEFEFEFFFEFEFDFF71C5F8FF0E93FFFF1297
      FFFF0D92FFFF078EFFFF058AFFFF068CFFFF078DFFFF088DFFFF13A1FFFF095B
      B3FF000208520000000000000000000000000000000000000000000000000000
      00125A3719B4D9B07BFFF8ECC2FFE0C594FFD2B690FFDECEBCFFECE5E0FFF7F5
      F7FFF1F0F1FFC8C7C8FFFBFBFBFFFAFAFAFFFAFAFAFFDEDEDEFFFAFAFAFFDEDE
      DEFFFAFAFAFFDEDEDEFFFAFAFAFFDEDEDEFFFAFAFAFFDEDEDEFFFAFAFAFFFFC1
      E0FFFAFAFAFFFAFAFAFFFCFCFCFF0000002800000009616161FF949291FF8886
      85FF797775FF7B7977FF727170FF616161FF606060FF767676FF6A6A69FF6666
      65FF747474FF616161FF616161FF6D6C6BFFAAA8A6FFCAC7C6FF9E9A98FFFAFA
      F9FFF6F6F5FFF6F6F5FFFEFEFDFF5A5A5AFFFFFFFFFFF8F8F7FFF6F7F6FFFAFA
      F9FF9E9B99FFC9C6C5FFA4A3A1FF000000140000000DABABABFCECECECFFEEEE
      EEFFEDEDEDFFECECECFFEBEBEBFFEBEBEBFFEAEAEAFFE9E9E9FFE8E8E8FFE8E8
      E8FFE7E7E7FFE6E6E6FF95BF9BFFB3CDB6FFE4E4E4FFE4E4E4FFE3E3E3FFE2E2
      E2FFE2E2E2FFD1DAD2FF459950FF1BAD22FF14D215FF14D215FF14D215FF18BE
      1CFF20822DF9020A034800000000000000000000000000000000000000000000
      000309407FED47ACF7FF2C9EF4FF31A5F8FF1E9CFAFF0287FDFF0082FFFF0287
      FFFF068CFFFF098FFFFF0688F9FF2C9EEFFF2B9EEEFF0788FAFF0A91FFFF078D
      FFFF048AFFFF0287FFFF0389FFFF058AFFFF078BFFFF0996FFFF1A8FF5FF001A
      45CB000000000000000000000000000000000000000000000000000000005E38
      18B8DFB682FFF6E6BBFFD4B585FFD9C4B1FFE8E6E8FFF3F1F3FFF4F2F4FFF5F3
      F5FFEAE9EAFFBFBEBFFFFCFCFCFFFBFBFBFFFBFBFBFFFAFAFAFFFBFBFBFFFAFA
      FAFFFBFBFBFFFAFAFAFFFBFBFBFFFAFAFAFFFBFBFBFFFAFAFAFFFBFBFBFFFBF9
      FAFFFBFBFBFFFBFBFBFFFCFCFCFF00000028000000010808084E636464FF9F9D
      9DFF9D9C9BFF868483FF848281FF636363FF5B5B5BFFD0D0CFFF8F8F8EFF9898
      97FFC4C4C2FF5C5C5CFF626363FF807D7CFFA9A7A5FFCFCECBFFA7A4A2FFDAD8
      D7FFF2F1F0FFF0EFEEFFF6F5F4FF7D7D7EFFF6F5F4FFF1F0EFFFF2F1F0FFDAD8
      D7FFA7A4A2FFCDCCC9FF9E9B9AF80000000C0000000DABABABFCEFEFEFFFEEE9
      E5FFDCB28EFFE3C9B3FFEEEEEEFFEDEDEDFFEDEDEDFFECECECFFEBEBEBFFEBEB
      EBFFEAEAEAFFE9E9E9FFE8E8E8FFE8E8E8FFE7E7E7FFE6E6E6FFE5E5E5FFE5E5
      E5FFE4E4E4FFE4E4E4FFD3DCD4FF43984EFF1AAA24FF12CC18FF12CC18FF12CC
      18FF17B71FFF1F7E2CF602090345000000000000000000000000000000000000
      000000040D5A3284C9FF3AA8F9FF299CF4FF2EA0F7FF299FF9FF1295FCFF0084
      FEFF0082FFFF0084FFFF1297FFFF32AAFFFF34ABFFFF1197FFFF0185FFFF0085
      FFFF0082FFFF0084FFFF0287FFFF048AFFFF058AFFFF15A3FFFF0956ACFF0001
      033A0000000000000000000000000000000000000000000000001A0E0563D7A7
      6EFFF9EDC2FFD7BC93FFE6DDD8FFEFECEFFFCECCCEFFF0EEF0FFF2F0F2FFF3F1
      F3FFF2F1F2FFCECCCEFFFDFDFDFFFCFCFCFFFCFCFCFFEEEEEEFFFCFCFCFFDEDE
      DEFFFBFBFBFFDEDEDEFFFBFBFBFFDEDEDEFFFBFBFBFFDEDEDEFFFBFBFBFFFFC1
      E0FFFBFBFBFFFBFBFBFFFCFCFCFF0000002800000000000000010303043E5F5E
      5BFF828284FF727272FF6A6A69FF616161FF616060FFFFFFFFFF5F5E5CFF5C5B
      5AFFFFFFF9FF636260FF616161FF676766FF928F8FFFC6C4C3FFC8C6C4FFA4A2
      A0FFECEBEAFFEFEEEDFFF1F0EFFFA3A3A3FFF1F0EFFFEFEEEDFFECEBEAFFA4A2
      A0FFC8C6C4FFC3C1C1FF3E3D3C9F000000030000000DABABABFCF2F2F2FFE4BA
      92FFD48945FFCA7731FFEBDDD2FFCBCBCBFFC1C1C1FFAFAFAFFFC1C1C1FFAEAE
      AEFFD2D2D2FFBFBFBFFFC7C7C7FFB5B5B5FFCFCFCFFFA3A3A3FFB4B4B4FF9191
      91FFA2A2A2FFC4C4C4FFD4D4D4FFD3DCD4FF388E44FF18A725FF10C61BFF10C6
      1BFF10C61BFF15B221FF1F7E2CF60108023F0000000000000000000000000000
      000000000000052D5FD753AEF2FF2B9CF1FF2C9DF3FF2A9EF6FF2CA0F8FF249C
      F9FF098CFBFF0070FCFF87D4FEFFFEFEFFFFFEFEFFFF77CEFEFF0077FCFF007D
      FBFF007DFCFF0082FFFF0085FFFF0389FFFF0896FFFF1B90EEFF001032B50000
      0000000000000000000000000000000000000000000001000017AA7441ECF2DC
      AEFFDABF8EFFE4DBD8FFECE8ECFFEDEAEDFFEDEAEDFFECEAECFFF0EEF0FFF2EF
      F2FFF2F0F2FFCECCCEFFFDFDFDFFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFBFB
      FBFFFCFCFCFFFBFBFBFFFCFCFCFFFBFBFBFFFCFCFCFFFBFBFBFFFCFCFCFFFCFA
      FBFFFCFCFCFFFCFCFCFFFDFDFDFF00000028000000000000000000000016BF84
      0BFFAAADB5FF535455FF5A5A5AFF5B5959FFBAB6B4FFFFFFFFFF565655FF5553
      53FFF6F7F2FFACA9A5FF5D5C5BFF595959FF565657FFB7B4B2FFD9D8D7FFBEBD
      BBFFA2A09EFFD5D2D2FFF0EFEEFFCAC9C9FFF0EFEEFFD5D2D2FFA2A09EFFBEBD
      BBFFD9D9D9FFAFADABFF00000008000000000000000DABABABFCF4F4F4FFEFCE
      ABFFEAAE6EFFD0843FFFEDE2D8FFBBBBBBFFD6D6D6FFB0B0B0FFC3C3C3FFAFAF
      AFFFAFAFAFFFD4D4D4FFA6A6A6FFA5A5A5FFECECECFFA5A5A5FFBEBEBEFFA4A4
      A4FFB4B4B4FFB4B4B4FFD7D7D7FFE7E7E7FFA2ABA3FF186122DA18A526FF0FC1
      1DFF0FC11DFF0FC11DFF15AE23FF1F7E2CF60000000000000000000000000000
      00000000000000030A4F3684C4FF42ADF7FF2D9AEEFF2D9CF1FF299BF4FF289B
      F6FF269EF8FF0684F7FF91D5FCFFFEFEFFFFFEFEFFFF7DCDFCFF006FF7FF007A
      F8FF007DFBFF0081FEFF0085FFFF0085FFFF17A3FFFF0A53A6FF000002310000
      00000000000000000000000000000000000000000000573110B2E2B984FFEBD9
      AAFFD8C3B0FFE9E5E9FFEAE7EAFFEBE8EBFFEDE9EDFFEEEBEEFFEFECEFFFF0ED
      F0FFF0EEF0FFCCCACCFFFEFEFEFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFD
      FDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFD
      FDFFFDFDFDFFFDFDFDFFFEFEFEFF00000028000000000000000000000016BA7E
      07FFFFFFFFFFEEEEEFFF979695FF55514EFFBCDEEEFF71B1D2FF64A4C6FF508E
      AFFF3B7A9DFF7999A5FF595653FF989796FFEEEEEDFFE2E0DFFFB1AFADFFDEDD
      DEFFD1D0D0FFA7A5A3FF979492FF989592FF979492FFA7A5A3FFD1D1D0FFE0E0
      E2FFB6B6B8FF0F0F0F5400000001000000000000000DABABABFCF6F6F6FFF7F5
      F4FFF2DCC5FFEDDCCCFFF6F6F6FFF5F5F5FFF4F4F4FFF4F4F4FFF3F3F3FFF3F3
      F3FFF2F2F2FFF1F1F1FFF1F1F1FFF0F0F0FFEFEFEFFFEEEEEEFFEEEEEEFFEDED
      EDFFECECECFFEBEBEBFFEBEBEBFFEAEAEAFFABABABFC0103012C186122D817A3
      27FF0EBD1FFF0EBD1FFF15AA25FF1F7E2CF60000000000000000000000000000
      00000000000000000000042552CA5BB0ECFF339AEBFF3097ECFF2D9AEEFF2999
      F0FF2599F4FF0E89F1FFABDEFBFFFEFEFFFFFEFEFFFF78C9F9FF0064EDFF0078
      F6FF007CF9FF0080FEFF0080FFFF0490FFFF1D92EEFF000E2CAA000000000000
      0000000000000000000000000000000000000402002AC98646FFF3DCAEFFD9C0
      9DFFE4E0E4FFC8C5C8FFE5E1E5FFEAE6EAFFEBE7EBFFECE9ECFFEDEAEDFFEEEB
      EEFFEEECEEFFCBC9CBFF008100FF008700FF008D01FF05920AFF0A9814FF0F9E
      1EFF14A427FF17A82DFF19AA30FF19AA30FF17A82DFF14A426FF0F9E1EFF0A98
      14FF05920AFF008D01FF008800FF00000028000000000000000000000016B57A
      07FFFFFFFFFFF6F6F7FFFFFEFCFFB1BFCEFF46759BFF7ABAD9FF6EACCBFF64A0
      C2FF4D85A2FF20496CFFA4B5CAFFFFFFFDFFF7F7F5FFF5F5F4FFDBDAD9FFB6B4
      B1FFD1D0CEFFE9E8E8FFF1F1F1FFF2F1F2FFF1F1F1FFE9E8E7FFD1D1D0FFBABA
      BEFFB98D36FF0000001600000000000000000000000DABABABFCF8F8F8FFF9F9
      F9FFF9F9F9FFF8F8F8FFF7F7F7FFF7F7F7FFF7F7F7FFF6F6F6FFF6F6F6FFF5F5
      F5FFF4F4F4FFF4F4F4FFF3F3F3FFF2F2F2FFF2F2F2FFF1F1F1FFF0F0F0FFF0F0
      F0FFEFEFEFFFEEEEEEFFEDEDEDFFEDEDEDFFABABABFC000000170001001B1864
      23DB17A227FF14A825FF1E7C2BF30107023C0000000000000000000000000000
      000000000000000000000001053A307BB9FF4EB1F5FF3195E7FF3295E9FF2D97
      E9FF2C97EEFF0F80E9FFABDDFAFFFEFEFFFFFEFEFFFF84C8F7FF005AE6FF0076
      F4FF007BF9FF007EFCFF0080FFFF19A4FFFF084FA1FF0000001F000000000000
      0000000000000000000000000000000000002E1A0980D9A266FFFCF2C6FFDFD1
      C3FFECE9ECFFEBE8EBFFE9E5E9FFE9E5E9FFE9E5E9FFEAE7EAFFEBE8EBFFEDE9
      EDFFEDEAEDFFCAC7CAFF008500FF008A00FF039107FF099712FF0F9F1EFF15A6
      2AFF1BAC35FF21B23FFF24B645FF24B645FF21B23FFF1BAC35FF15A62AFF0F9E
      1EFF099712FF039007FF008B00FF00000028000000000000000000000016B479
      07FFFFFFFFFFEFEFEFFFFBF7F3FF8094ADFF5994BEFF86C9E9FF7BBCDDFF75B3
      D4FF6DACCDFF4C88B0FF758BA8FFFCF9F5FFF0F0EEFFEEEEEDFFF0F0EFFFEEEF
      EEFFCFCECCFFBDBBB9FFB7B5B3FFB7B5B3FFB7B5B3FFBDBBB8FFCFCECEFFFFFF
      FFFFB67902FF0000001600000000000000000000000DABABABFCFAFAFAFFFBFB
      FBFFFBFBFBFFFAFAFAFFFAFAFAFFF9F9F9FFF8F8F8FFF8F8F8FFF7F7F7FFF7F7
      F7FFF6F6F6FFF6F6F6FFF5F5F5FFF5F5F5FFF4F4F4FFF4F4F4FFF3F3F3FFF2F2
      F2FFF2F2F2FFF1F1F1FFF0F0F0FFEFEFEFFFABABABFC00000017000000000001
      001B1A6624DE1E782AF001060239000000000000000000000000000000000000
      000000000000000000000000000001183CAF60B0E9FF389DEDFF369AE3FF3298
      E6FF2F98E8FF0E7ADFFFAEDCF7FFFEFEFFFFFEFEFFFFA5DAF7FF006EE8FF0079
      F3FF0078F9FF007CFEFF0793FFFF228CE6FF00081B8A00000000000000000000
      0000000000000000000000000000000000006B3C15C2E1B57BFFEEDBADFFE9E2
      DFFFEEEBEEFFEDEAEDFFECE8ECFFEBE7EBFFE9E6E9FFE9E5E9FFEAE6EAFFEBE7
      EBFFB9B7B9FFB0AFB0FF008700FF008D00FF047D08FF097712FF0F831DFF1AAB
      32FF22B441FF2ABC4FFF2FC259FF2FC259FF2ABC4FFF22B441FF149027FF0E7D
      1BFF097B12FF05930BFF008D00FF00000028000000000000000000000016B47A
      07FFFFFFFFFFEFEDEDFFECE9E8FF234F81FF98DEFEFF8BCDEDFF81C1E1FF78B8
      D8FF71B0D1FF69AACCFF17467AFFEEECEAFFF0EEECFFECEAE9FFECEAE9FFEDEC
      EBFFEEEDECFFEFEEEDFFEFEEEDFFEFEFEEFFEFEEEDFFEEEDECFFEDEDEDFFFFFF
      FFFFB57A06FF0000001600000000000000000000000DABABABFCFBFBFBFFFAF5
      F1FFE2B893FFECD2BCFFFCFCFCFFFBFBFBFFFBFBFBFFFAFAFAFFFAFAFAFFF9F9
      F9FFF8F8F8FFF8F8F8FFF7F7F7FFF7F7F7FFF6F6F6FFF6F6F6FFF5F5F5FFF5F5
      F5FFF4F4F4FFF3F3F3FFF3F3F3FFF2F2F2FFABABABFC00000017000000000000
      00000001001E0105013300000000000000000000000000000000000000000000
      000000000000000000000000000000000225296DAEFF5BB6F2FF3498E6FF379A
      E6FF379AE5FF1078DDFFB8E0F8FFFEFEFFFFFEFEFFFFA8DBF8FF0578EEFF249A
      FAFF058AFEFF0080FFFF1FA8FFFF064491FC0000001000000000000000000000
      0000000000000000000000000000000000008C4F1DDDE4BD87FFE1C89DFFF1EE
      F1FFF0EDF0FFEEECEEFFEDEAEDFFECE9ECFFEBE8EBFFEAE6EAFFE9E5E9FFE9E5
      E9FF9B999BFF949394FF008700FF008701FFC0C3C0FFC5C5C5FFC6C6C6FF18A2
      2EFF25B747FF2EC158FF37CC68FF37CB68FF2EC157FF1FAB3CFFC0C3C0FFC5C5
      C5FFC6C6C6FF058D0AFF008D01FF00000028000000000000000000000016B47A
      07FFFFFFFFFFEEECEBFFACB6C3FF2B6595FF9FE5FFFF91D3F3FF87C8E8FF7DBE
      DEFF77B7D6FF71B2D3FF1A4775FFB0BAC8FFF0EDEAFFE9E7E6FFE8E7E6FFE8E7
      E6FFE8E7E6FFE9E7E6FFE9E8E7FFE9E8E7FFE9E8E7FFE8E7E6FFE7E7E8FFFFFF
      FFFFB47A07FF0000001600000000000000000000000DABABABFCFBFBFBFFE8BE
      96FFD48945FFCA7731FFF5E7DCFFFDFDFDFFFCFCFCFFFCFCFCFFFCFCFCFFFBFB
      FBFFFBFBFBFFFAFAFAFFF9F9F9FFF9F9F9FFF8F8F8FFF8F8F8FFF7F7F7FFF7F7
      F7FFF6F6F6FFF6F6F6FFF5F5F5FFF4F4F4FFABABABFC00000017000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000011299862ADE0FF41A1EBFF3A9A
      E4FF379BE6FF117ADDFFB7E0F8FFFEFEFFFFFEFEFFFFADDDF9FF0375F1FF22A1
      FCFF1C9DFEFF29B0FFFF278DE0FF000511730000000000000000000000000000
      000000000000000000000000000000000000AC6023F2E5BE88FFDEC8A5FFE7E5
      E7FFDCDADCFFEEEBEEFFEFECEFFFEEEBEEFFEDE9EDFFECE8ECFFEAE7EAFFD0CE
      D0FF3D3E3EFF373837FF008C00FF008C00FFF8FCF8FFFFFFFFFFFFFFFFFF68CB
      74FF7ED88EFF92E4A3FF9FEBB1FFA0ECB2FF93E4A4FF80D98FFFFBFEFBFFFFFF
      FFFFFFFFFFFF008D01FF008C00FF00000028000000000000000000000016B47A
      07FFFFFFFFFFEEECEAFF7B92ABFF3374A4FFABF1FFFF9DE1FFFF91D3F3FF87C7
      E7FF7EBEDEFF79BBDBFF1A4570FF8095AEFFF0EEEAFFE7E6E5FFE5E5E4FFE5E5
      E4FFE5E5E4FFE5E5E4FFE5E5E4FFE5E5E4FFE5E5E4FFE5E5E4FFE3E4E5FFFFFF
      FFFFB47A07FF0000001600000000000000000000000DAAAAAAFCF9F9F9FFF2D0
      AEFFEAAE6EFFD0843FFFF3E8DEFFDCDCDCFFC7C7C7FFABABABFFBEBEBEFFD4D4
      D4FFC0C0C0FFC0C0C0FFD3D3D3FFC0C0C0FFB5B5B5FFACACACFFE5E5E5FFF9F9
      F9FFF8F8F8FFF7F7F7FFF7F7F7FFF7F7F7FFABABABFC00000017000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000120266BABFF64B7F1FF3898
      E3FF3E9BE3FF147BD9FFC7E3F5FFFEFEFFFFFEFEFFFFBAE4FAFF047AF5FF229E
      FFFF1F9FFFFF50C4FFFF09438CF70000000D0000000000000000000000000000
      000000000000000000000000000000000000B26525F5E4BE8BFFE0CAA8FFEEEC
      EEFFE9E7E9FFF1EEF1FFF1EEF1FFEFEDEFFFEFECEFFFE2E0E2FFAEAEAFFF898B
      8AFF515453FF464847FFB5B4B5FFC8C5C8FFA6A6A6FFA5A5A5FFA5A5A5FFCAC8
      CAFFCAC8CAFFBBB9BBFFC5C3C5FFA48561FFC0AE86FFA38459F59F9F9FFBA5A5
      A5FFA5A5A5FF00000027000000260000000A000000000000000000000016B47A
      07FFFFFFFFFFEFEBE8FF718FAAFF266392FF3A719DFF3D719BFF65A1C3FF8BCD
      ECFF8ACCEDFF85C8E8FF123A66FF5D7B9DFFF2EDE9FFE5E4E2FFE3E2E1FFE3E2
      E1FFE3E2E1FFE3E2E1FFE3E2E1FFE3E2E1FFE3E2E1FFE3E2E1FFE1E1E1FFFFFF
      FFFFB47A07FF0000001600000000000000000000000DA7A7A7FCEFEFEFFFEEEC
      EBFFEDD8C1FFE8D6C7FFEDEDEDFFA5A5A5FF808080FF9A9A9AFFCACACAFFD2D2
      D2FFA3A3A3FFCBCBCBFFCBCBCBFF8F8F8FFF8F8F8FFFCACACAFFE7E7E7FFFBFB
      FBFFFAFAFAFFFAFAFAFFF9F9F9FFF8F8F8FFACACACFC00000017000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000D238C69ADDDFF50A7
      EBFF3C9BE1FF2086E0FFD3ECF9FFFEFEFFFFFEFEFFFFD9EDFBFF0885F9FF1E9E
      FFFF43C1FFFF3696E0FF00030D64000000000000000000000000000000000000
      0000000000000000000000000000000000008E501DDBE3BB89FFE4CFA4FFF6F4
      F6FFF4F3F4FFF3F1F3FFF0EEF0FFD2D1D2FFB9BABAFFB8B7B9FFDDDCDDFFEFEB
      EFFFB7B6B7FFB1AFB1FFEAE7EAFFEAE7EAFFEBE8EBFFECE9ECFFEDEAEDFFEFEB
      EFFFEEEBEEFFEFECEFFFF0EEF0FFBB8E5BFFE8D5A8FF9D7950DE000000010000
      000100000001000000010000000100000000000000000000000000000016B47A
      07FFFFFFFFFFEFEAE6FF1C4E7EFF216394FF34719DFF40739EFF3C648EFF1E44
      6EFF47779CFF396288FF0F3B6DFF0B3D73FFF3EDE7FFE3E1E0FFE0DFDEFFE0DF
      DEFFE0DFDEFFE0DFDEFFE0DFDEFFE0DFDEFFE0DFDEFFE0DFDEFFDEDDDEFFFFFF
      FFFFB47A07FF0000001600000000000000000000000BA7A7A7FCE0E0E0FFDEDE
      DEFFDDDDDDFFDCDCDCFFDCDCDCFFDBDBDBFFDADADAFFDCDCDCFFE8E8E8FFF7F7
      F7FFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFCFC
      FCFFFCFCFCFFFCFCFCFFFBFBFBFFFBFBFBFFACACACFC00000017000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000011144F90F871BD
      EDFF3D9CE0FF3998E3FF2086E0FF2089DEFF1E8ADBFF0F86EEFF199EFFFF2FAF
      FFFF5AC3FBFF022C68E200000004000000000000000000000000000000000000
      0000000000000000000000000000000000006C3C17BEE2B383FFF4E5B8FFF0E9
      E4FFF0EFF0FFDFDEE0FFD9D8D9FFE8E7E9FFF4F2F4FFF2F1F2FFF2F0F2FFF1EE
      F1FFD8D6D8FFC5C3C5FFEEEBEEFFEDEAEDFFECE9ECFFEDEAEDFFEEEBEEFFEFED
      EFFFEFECEFFFEEEBEEFFE6DFDBFFC39B63FFF4E6BBFF765534C2000000000000
      000000000000000000000000000000000000000000000000000000000016B57A
      07FFFFFFFFFFEEE8E4FF003770FF2974A3FF4185B0FF518BB4FF5F8FB6FF5E87
      AFFF49709CFF325D8BFF154579FF00356DFFF1EBE5FFE0DEDDFFDDDCDBFFDDDC
      DBFFDDDCDBFFDDDCDBFFDDDCDBFFDDDCDBFFDDDCDBFFDCDBDAFFDADADBFFFFFF
      FFFFB57A07FF00000016000000000000000000000006767676D5B5B5B5FFB3B3
      B3FFB6B6B6FFB6B6B6FFBABABAFFB9B9B9FFBCBCBCFFCECECEFFE7E7E7FFF8F8
      F8FFFEFEFEFFFEFEFEFFFEFEFEFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFD
      FDFFFDFDFDFFFDFDFDFFFDFDFDFFFCFCFCFFACACACFC00000017000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000050F614C93
      CAFF5AAEECFF3F9FE5FF3EA2ECFF2BA0F3FF2AA0F9FF2DA6FEFF28A7FFFF61D2
      FFFF227BC7FF0000043D00000000000000000000000000000000000000000000
      0000000000000000000000000000000000002C19097AD5975DFFF6E3BBFFE4D4
      C4FFF6F4F6FFF7F5F7FFF5F4F5FFF6F5F6FFF5F4F5FFF5F3F5FFF4F2F4FFF3F1
      F3FFEAE7EAFFCAC8CAFFF0EEF0FFEFEDEFFFEEECEEFFEEEBEEFFEEEBEEFFEEEB
      EEFFEFECEFFFEDE9EDFFD8C4B5FFD4B682FFEBD1A3FF2E1E0F7B000000000000
      000000000000000000000000000000000000000000000000000000000016B57A
      07FFFFFFFFFFEBE6E0FF002D67FF246E9EFF3C83AFFF4888B2FF5089B2FF4F83
      ADFF4173A0FF2D5E8DFF104175FF02346CFFEEE8E1FFDEDCDAFFDBDAD8FFDBDA
      D8FFDBDAD8FFDBDAD8FFDBDAD8FFDBDAD8FFDBDAD8FFDBD9D7FFD8D8D8FFFFFF
      FFFFB57A07FF000000160000000000000000000000021D1D1D6ECCCCCCFFF5F5
      F5FFEFEFEFFFEFEFEFFFE5E5E5FFE9E9E9FFE2E2E2FFBCBCBCFFDEDEDEFFF8F8
      F8FFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFDFD
      FDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFACACACFC00000017000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000629
      55C675BCEEFF43A3EBFF44A7F0FF43AAF5FF3FAAF9FF30A8FFFF3EBCFFFF60C4
      FCFF000F2DA80000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000004020025C6712BFFEED2AEFFDBC2
      9DFFEFEEEFFFD9D9D9FFF8F8F8FFF8F7F8FFF8F6F8FFF7F5F7FFF6F4F6FFF5F3
      F5FFF4F2F4FFD3D1D3FFF2F0F2FFF2F0F2FFF1EEF1FFF0EDF0FFF0EDF0FFECE9
      ECFFD4D2D4FFE4E0E4FFC29B71FFE8D4A5FFDDB27DFF04020027000000000000
      000000000000000000000000000000000000000000000000000000000016B57A
      07FFFFFFFFFFE3DFDBFF224D7AFF134A7EFF2E7DABFF3B83AFFF4285B0FF3F7D
      A8FF346E9CFF1F5888FF0C3D72FF26507EFFE6E1DBFFDAD8D5FFD7D6D4FFD7D6
      D4FFD7D6D4FFD7D6D4FFD7D6D4FFD7D6D4FFD7D6D4FFD6D5D3FFD5D4D4FFFFFF
      FFFFB57A07FF00000016000000000000000000000000000000022C2C2C85CCCC
      CCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC6C6C6FFD7D7D7FFF9F9
      F9FFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFE
      FEFFFEFEFEFFFEFEFEFFFEFEFEFFFDFDFDFFA9A9A9F901010123000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000001
      063D438CC8FF61C0F8FF45A5F1FF44ADF7FF3DAEFCFF39AFFFFF69D5FFFF1F73
      C1FF000000180000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000005B3414ADDDA773FFEFDA
      B4FFE2CFBAFFFAF9FAFFFBFAFBFFFAF9FAFFF9F8F9FFF8F7F8FFF7F6F7FFF7F5
      F7FFF6F5F6FFE4E2E4FFF5F3F5FFF4F2F4FFF3F1F3FFF2F0F2FFF1EFF1FFF1EE
      F1FFEDE9EDFFCAAF99FFD1B07BFFEED7A9FF5C4025AB00000000000000000000
      000000000000000000000000000000000000000000000000000000000016B57A
      07FFFFFFFFFFD7D5D3FFB8BDC3FF05376CFF0E457AFF236597FF2C76A5FF296F
      9FFF1D5A8DFF0C3F75FF083A6FFFB9BEC4FFD8D6D3FFD2D1CFFFD0D0CFFFD0D0
      CFFFD0D0CFFFD0D0CFFFD0D0CFFFD0D0CFFFD0D0CFFFD0CFCEFFCFCFCFFFFFFF
      FFFFB57A07FF0000001600000000000000000000000000000000000000024242
      42A1CACACAFFFDFDFDFFFFFFFFFFFFFFFFFFFFFFFFFFC6C6C6FFD8D8D8FFF9F9
      F9FFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFE
      FEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFA8A8A8F802020226000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000005264FBF72C1F7FF49AFF7FF48B1F8FF43B2FEFF47BBFFFF5EC3FCFF000E
      289A000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000001000015A85F24EAEBCB
      A5FFEBD9B1FFF0E9E2FFFBFBFBFFFBFBFBFFF8F7F8FFF9F9F9FFF9F8F9FFF9F7
      F9FFF8F7F8FFF2F0F2FFF6F5F6FFF5F4F5FFF3F1F3FFF4F2F4FFF4F2F4FFF1EE
      F1FFE3D9D5FFC19964FFF6E6BBFFBA9262EA0100001400000000000000000000
      000000000000000000000000000000000000000000000000000000000016B57B
      09FFFFFFFFFFFFFFFFFFFFFFFFFFE4EEFCFF5177A5FF002F70FF003373FF0034
      73FF003071FF5178A7FFE4EFFBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFB57B09FF0000001600000000000000000000000000000000000000000000
      0002414141A0C8C8C8FFF6F6F6FFFDFDFDFFFFFFFFFFC6C6C6FFDADADAFFFAFA
      FAFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFE
      FEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFA8A8A8F802020226000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000104313786C8FF66C3FEFF4AB5FCFF4AB7FFFF5FCBFFFF1F71C0FF0000
      0016000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000130B0451CD80
      3EFFF2DFC4FFD4B68DFFF1E9E3FFFCFBFCFFE6E5E6FFFBFAFBFFFAFAFAFFFAF9
      FAFFF8F7F8FFF8F7F8FFF8F7F8FFF7F6F7FFF6F4F6FFE2E1E2FFF3F0F3FFE3DA
      D4FFC5A073FFEEDCAEFFE6BD89FF160D06550000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000016B57D
      0EFFF9E1C1FFE8BC76FFECC382FFF2C886FFF9CD8AFFFFD28DFFFFD38DFFFFD2
      8DFFFFD18CFFF9CD89FFF1C784FFECC281FFE9C07EFFE9C07DFFE9BF7DFFE9BF
      7DFFE9BF7DFFE8BF7CFFE8BF7CFFE8BF7BFFE8BE7BFFE8BE7BFFE7BA72FFF8E0
      BFFFB57D0EFF0000001600000000000000000000000000000000000000000000
      0000000000024141419FC4C4C4FFEDEDEDFFF6F6F6FFC9C9C9FFD9D9D9FFFCFC
      FCFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFE
      FEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFA8A8A8F802020226000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000011838A564BDF7FF54BEFFFF56C0FFFF55B5F8FF000A1B7F0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004F2D
      11A2D38F51FFEDD6B7FFE3CCA4FFDAC4ACFFF3F3F3FFFBFAFBFFFBFAFBFFFBFA
      FBFFEFEEEFFFF4F3F4FFF9F8F9FFF8F6F8FFF5F4F5FFE9E8E9FFD3BBA6FFD5B8
      87FFFAEEC3FFE7C18CFF5C3B1EAA000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000016B680
      11FFF6DEBAFFCF8B14FFD28F1EFFD49222FFD59526FFD89728FFD9982BFFDA9A
      2FFFDA9B30FFD99B33FFD99B34FFD89D37FFD99D3AFFDA9E3CFFDAA13FFFDBA1
      41FFDCA244FFDDA547FFDDA649FFDEA74DFFDFA94EFFDFAA51FFE0AA52FFF4DB
      B4FFB67E11FF0000001600000000000000000000000000000000000000000000
      000000000000000000043F3F3F9DBFBFBFFFE2E2E2FFC4C4C4FFDCDCDCFFFEFE
      FEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFFEFE
      FEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFA8A8A8F802020226000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000011F2879C2FF67CCFFFF66CBFFFF175C9EEE0000000D0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000E573213A9CD803DFFE8C79EFFECD9B9FFD1B58CFFE4D2C2FFF2EBE6FFFAF9
      FAFFECEBECFFF1F0F1FFF6F5F6FFECE3DFFFD8C5B2FFC9A77EFFDEC494FFF2DE
      AFFFE3B37BFF523318A20000000E000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000015B681
      14FFF2D7ACFFC57300FFC77A00FFCA7D00FFCB8202FFCC8508FFCF880FFFD08B
      15FFD28E1BFFD39120FFD49426FFD7982DFFD89A33FFDA9E39FFDCA03FFFDDA3
      45FFDFA74BFFE0A951FFE2AD57FFE3B05DFFE5B363FFE7B669FFE9B86EFFF0D3
      A5FFB68113FF0000001500000000000000000000000000000000000000000000
      00000000000000000000000000013F3F3F9DBBBBBBFFBCBCBCFFD2D2D2FFE7E7
      E7FFE7E7E7FFE7E7E7FFE7E7E7FFE7E7E7FFE7E7E7FFE7E7E7FFE7E7E7FFE7E7
      E7FFE7E7E7FFE7E7E7FFE6E6E6FFEEEEEEFFA8A8A8F802020224000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000B1A716AB4E8FF489BD9FF00040B53000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000150B0453A65E24E9DAA168FFF0D7B6FFF7E7C4FFF2E3BAFFDAC0
      91FFD2B38EFFD3B792FFD8BC8DFFE6D1A1FFFAEFC4FFECD3A2FFE5BB86FFB47F
      4CEA130B04510000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000DB882
      16FFEED09CFFEDCF9BFFEDD09DFFEDD09DFFEDCF9CFFEDCF9CFFECCF9CFFECCE
      9BFFECCE9BFFECCE9AFFECCE9AFFECCD99FFECCD99FFECCD98FFECCC97FFEBCC
      97FFEBCC96FFEBCC96FFEBCC96FFEBCB95FFEBCB94FFEBCB94FFEBCB94FFEECE
      99FFB88216FF0000000D00000000000000000000000000000000000000000000
      0000000000000000000000000000000000011A1A1A67AFAFAFFF6E6E6ECC6E6E
      6ECB6E6E6ECB6E6E6ECB6E6E6ECB6E6E6ECB6E6E6ECB6E6E6ECB6E6E6ECB6E6E
      6ECB6E6E6ECB6E6E6ECB6E6E6ECC888888E0777777D100000007000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000001011A0000001400000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000001000013542F12A6C7712BFFD38F4EFFDEAB73FFE2BA
      85FFDFB881FFE2BC86FFE3BC86FFE2B57DFFDDA66BFFD38F4EFF5B3414AD0100
      0015000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000045A40
      0DB4B88317FFB78215FFB78215FFB78215FFB78215FFB78215FFB78215FFB782
      15FFB78115FFB78115FFB78115FFB78115FFB78115FFB78114FFB78114FFB681
      14FFB68114FFB68114FFB68114FFB68114FFB68114FFB68114FFB78114FFB882
      16FF5A400DB40000000400000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000100000009000000050000
      0006000000060000000600000006000000060000000600000006000000060000
      0006000000060000000600000006000000070000000500000002000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000003020024281608736A3C17BA9052
      1FD9B16527F1B66728F48F511FD86A3C17BA2917097503020023000000000000
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
      001F0000001F0000001F0000001F0000001F0000001F0000001F0000001F0000
      001F0000001F0000001F0000001F0000001F0000001F0000001F0000001F0000
      001F0000001F0000001F0000001F0000001F0000001F0000001F0000001F0000
      001F000000000000000000000000000000000000000000000000000000000000
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
      004C0B0A0BB0191819F6191819F6191819F6191819F6191819F6191819F61918
      19F6191819F6191819F6191819F6191819F6191819F6191819F6191819F61918
      19F6191819F6191819F6191819F6191819F6191819F6191819F60B0A0BB00000
      004C00000000000000000000000000000000000000240000002B000000320000
      0034000000350000003400000034000000340000003400000034000000340000
      00340202023B0101013900000034000000340000003400000034000000340000
      0034000000340000003400000034000000340000003400000035000000330000
      00320000002B000000230000001D000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000191919F2EDEDEDFFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9
      E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9
      E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFEDEDEDFF191919F20000
      00000000000000000000000000000000000000000024414141FF414141FF4141
      41FF414141FF414141FF414141FF414141FF414141FF414141FF414141FF4848
      48FFD0D0D0FFCECECEFF484848FF414141FF414141FF414141FF414141FF4141
      41FF414141FF414141FF414141FF414141FF464646FF696969FF696969FF6969
      69FF696969FF696969FF535353E4000000000000000000000004000000070000
      000C0000000F000000150000001A0000001D0000001E0000001E0000001E0000
      0020000000260000002600000026000000260000002600000026000000260000
      0026000000200000001E0000001E0000001D0000001A00000018000000140000
      000E0000000B0000000600000004000000000000000000000004000000070000
      000C0000000F000000150000001A0000001D0000001E0000001E0000001E0000
      0020000000260000002600000026000000260000002600000026000000260000
      0026000000200000001E0000001E0000001D0000001A00000018000000140000
      000E0000000B0000000600000004000000000000000000000000000000000000
      00001A1A1AF2EEEEEEFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEA
      EAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEA
      EAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEEEEEEFF1A1A1AF20000
      00000000000000000000000000000000000000000000404040FF404040FF4040
      40FF404040FF404040FF404040FF404040FF404040FF404040FF404040FFD0D0
      D0FFFFFFFFFFFFFFFFFFC7C7C7FF404040FF404040FF404040FF404040FF4040
      40FF404040FF404040FF404040FF404040FF454545FF696969FF696969FF6969
      69FF696969FF696969FF525252E10000000000000002000000080000000D0000
      0012000000190000001D00000021000000240000002600000026000000260000
      0026000000260000002600000026000000260000002600000026000000260000
      002600000026000000260000002600000024000000210000001E0000001B0000
      0017000000100000000C000000070000000200000002000000080000000D0000
      0012000000190000001D00000021000000240000002600000026000000260000
      0026000000260000002600000026000000260000002600000026000000260000
      002600000026000000260000002600000024000000210000001E0000001B0000
      0017000000100000000C00000007000000020000000000000000000000000000
      00001A1A1AF2EEEEEEFFEAEAEAFFCCCCCCFFCFCFCFFFEAEAEAFFE8E8E8FF9F9F
      9FFFC4C4C4FF9F9F9FFFC4C4C4FF9F9F9FFFC4C4C4FF9F9F9FFFC4C4C4FF9F9F
      9FFFC4C4C4FF9F9F9FFFC4C4C4FF9F9F9FFFEAEAEAFFEEEEEEFF1A1A1AF20000
      00000000000000000000000000000000000000000000404040FF404040FF4040
      40FF404040FF404040FF404040FF404040FF404040FF404040FF404040FFCECE
      CEFFFFFFFFFFFFFFFFFFB1B1B1FF404040FF404040FF404040FF404040FF4040
      40FF404040FF404040FF404040FF404040FF454545FF696969FF696969FF6969
      69FF696969FF696969FF454545CF000000000000000000000000000000000000
      0000000000000000000000000000000000030000000800000008000000080000
      000800000008000000080000000F0000000F0000000F0000000F000000090000
      0008000000080000000800000008000000070000000300000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000030000000800000008000000080000
      000800000008000000080000000F0000000F0000000F0000000F000000090000
      0008000000080000000800000008000000070000000300000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00001B1B1BF2EFEFEFFFCECECEFF767676FF767676FFD1D1D1FFEBEBEBFFEBEB
      EBFFEBEBEBFFEBEBEBFFEBEBEBFFEBEBEBFFEBEBEBFFEBEBEBFFEBEBEBFFEBEB
      EBFFEBEBEBFFEBEBEBFFEBEBEBFFEBEBEBFFEBEBEBFFEFEFEFFF1B1B1BF20000
      00000000000000000000000000000000000000000000393939F33F3F3FFF3F3F
      3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF8383
      83FFFFFFFFFFFFFFFFFF6C6C6CFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F
      3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF494949FF696969FF696969FF6969
      69FF696969FF696969FF0909094E000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001A11
      09704D341ABF1A11097000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001A1109704D34
      1ABF1A1109700000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00001C1C1CF2F0F0F0FFCCCCCCFF767676FF767676FFD0D0D0FFEAEAEAFF9F9F
      9FFFC5C5C5FF9F9F9FFFC5C5C5FF9F9F9FFFC5C5C5FF9F9F9FFFC5C5C5FF9F9F
      9FFFC5C5C5FF9F9F9FFFC5C5C5FF9F9F9FFFECECECFFF0F0F0FF1C1C1CF20000
      000000000000000000000000000000000000000000000A0A0A693F3F3FFF3F3F
      3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF4646
      46FFF2F2F2FFE9E9E9FF414141FF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F
      3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF5E5E5EFF696969FF696969FF6969
      69FF656565F90F0F0F6000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001A1109704D34
      1ABFF1D990FF4D341ABF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000004D341ABFF1D9
      90FF4D341ABF1A11097000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00001E1E1EF2F0F0F0FFECECECFFD2D2D2FFD3D3D3FFECECECFFECECECFFECEC
      ECFFECECECFFECECECFFECECECFFECECECFFECECECFFECECECFFECECECFFECEC
      ECFFECECECFFECECECFFECECECFFECECECFFECECECFFF0F0F0FF1E1E1EF20000
      0000000000000000000000000000000000000000000000000000090909603C3C
      3CF93E3E3EFF3E3E3EFF3E3E3EFF3E3E3EFF3E3E3EFF3E3E3EFF3E3E3EFF3E3E
      3EFFABABABFFA9A9A9FF3E3E3EFF3E3E3EFF3E3E3EFF3E3E3EFF3E3E3EFF3E3E
      3EFF3E3E3EFF3E3E3EFF3E3E3EFF595959FF696969FF696969FF696969FF4F4F
      4FDE040404330000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000001A1109704D341ABFE9C4
      50FFE9C450FF4D341ABF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000004D341ABFE9C4
      50FFE9C450FF4D341ABF1A110970000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00001F1F1FF2F1F1F1FFEDEDEDFFCECECEFFD1D1D1FFEDEDEDFFEBEBEBFF9F9F
      9FFFC6C6C6FF9F9F9FFFC6C6C6FF9F9F9FFFC6C6C6FF9F9F9FFFC6C6C6FF9F9F
      9FFFC6C6C6FF9F9F9FFFC6C6C6FF9F9F9FFFEDEDEDFFF1F1F1FF1F1F1FF20000
      0000000000000000000000000000000000000000000000000000000000000303
      0339303030E13D3D3DFF3D3D3DFF3D3D3DFF3D3D3DFF3D3D3DFF3D3D3DFF3D3D
      3DFF616161FF666666FF3D3D3DFF3D3D3DFF3D3D3DFF3D3D3DFF3D3D3DFF3D3D
      3DFF3D3D3DFF404040FF5D5D5DFF696969FF696969FF3D3D3DC3161616750000
      0009000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001A1109704D341ABFE9C450FFE1AE
      11FFE7BF40FF4D341ABF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000004D341ABFE7BF
      40FFE1AE11FFE9C450FF4D341ABF1A1109700000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000202020F2F1F1F1FFD1D1D1FF767676FF767676FFD3D3D3FFEEEEEEFFEEEE
      EEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEE
      EEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFF1F1F1FF202020F20000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000121D1D1DB13C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C
      3CFFBBBBBBFFA4A4A4FF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C
      3CFF474747FF646464FF696969FF676767FC0707074500000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000001A1109704D341ABFE9C450FFE1AE11FFDFA9
      01FFE7BF40FF4D341ABF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000004D341ABFE7BF
      40FFDFA901FFE1AE11FFE9C450FF4D341ABF1A11097000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000222222F2F2F2F2FFCFCFCFFF767676FF767676FFD3D3D3FFEDEDEDFF9F9F
      9FFFC7C7C7FF9F9F9FFFC7C7C7FF9F9F9FFFC7C7C7FF9F9F9FFFC7C7C7FF9F9F
      9FFFC7C7C7FF9F9F9FFFC7C7C7FF9F9F9FFFEFEFEFFFF2F2F2FF222222F20000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000004040442222222C03C3C3CFF3C3C3CFF3C3C3CFFB1B1
      B1FFFFFFFFFFFFFFFFFF8D8D8DFF3C3C3CFF3C3C3CFF3C3C3CFF282828CF0909
      0962696969FF696969FF696969FF4A4A4AD50000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000001A1109704D341ABFE9C450FFE1AE11FFDFA901FFDFA9
      01FFE7BF40FF4D341ABF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000004D341ABFE7BF
      40FFDFA901FFDFA901FFE1AE11FFE9C450FF4D341ABF1A110970000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000222222F2F3F3F3FFF0F0F0FFD5D5D5FFD6D6D6FFF0F0F0FFF0F0F0FFF0F0
      F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
      F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF3F3F3FF222222F20000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000F0D0D0D783B3B3BFF8F8F
      8FFFF6F6F6FFF8F8F8FF8A8A8AFF3B3B3BFF0E0E0E7E00000015000000000505
      053C696969FF696969FF696969FF626262F60000000C00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000001A1109704D341ABFE8C253FFDFAC15FFDDA605FFDDA605FFDDA6
      05FFE3B734FF4D341ABF4D341ABF4D341ABF4D341ABF4D341ABF4D341ABF4D34
      1ABF4D341ABF4D341ABF4D341ABF4D341ABF4D341ABF4D341ABF4D341ABF4D34
      1ABF4D341ABF4D341ABF1A11097000000000000000001A1109704D341ABF4D34
      1ABF4D341ABF4D341ABF4D341ABF4D341ABF4D341ABF4D341ABF4D341ABF4D34
      1ABF4D341ABF4D341ABF4D341ABF4D341ABF4D341ABF4D341ABF4D341ABFE3B7
      34FFDDA605FFDDA605FFDDA605FFDFAC15FFE8C253FF4D341ABF1A1109700000
      0000000000000000000000000000000000000000000000000000000000000000
      0000232423F2F4F4F4FFF1F1F1FFC2C2EBFFC6C6ECFFF1F1F1FFEFEFEFFF9F9F
      9FFFC8C8C8FF9F9F9FFFC8C8C8FF9F9F9FFFC8C8C8FF9F9F9FFFC8C8C8FF9F9F
      9FFFC8C8C8FF9F9F9FFFC8C8C8FF9F9F9FFFF1F1F1FFF4F4F4FF232423F20000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000242424C93A3A
      3AFF535353FF5D5D5DFF3A3A3AFF141414990000000000000000000000034141
      41C9696969FF696969FF696969FF696969FF2F2F2FAB00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00001A1109704D341ABFE6BF57FFDCA81AFFDAA20BFFDAA20BFFDAA20BFFDAA2
      0BFFDCA81AFFE1B439FFE3B948FFE3B948FFE3B948FFE3B948FFE3B948FFE3B9
      48FFE3B948FFE3B948FFE3B948FFE3B948FFE3B948FFE3B948FFE3B948FFE3B9
      48FFE3B948FFEACB76FF4D341ABF00000000000000004D341ABFEACB76FFE3B9
      48FFE3B948FFE3B948FFE3B948FFE3B948FFE3B948FFE3B948FFE3B948FFE3B9
      48FFE3B948FFE3B948FFE3B948FFE3B948FFE3B948FFE3B948FFE1B439FFDCA8
      1AFFDAA20BFFDAA20BFFDAA20BFFDAA20BFFDCA81AFFE6BF57FF4D341ABF1A11
      0970000000000000000000000000000000000000000000000000000000000000
      0000252625F2F4F4F4FFC4C4EBFF3A3ADAFF3A3ADAFFC8C8ECFFF1F1F1FFF1F1
      F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1
      F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF4F4F4FF252625F20000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001A1A1AAB3939
      39FF393939FF393939FF393939FF0A0A0A6C00000000000000000E0E0E5D6969
      69FF696969FF696969FF696969FF696969FF696969FF0606063F000000000000
      0000000000000000000000000000000000000000000000000000000000001A11
      09704D341ABFE3BC5BFFD9A320FFD69D11FFD69D11FFD69D11FFD69D11FFD69D
      11FFD69D11FFD69D11FFD69D11FFD69D11FFD69D11FFD69D11FFD69D11FFD69D
      11FFD69D11FFD69D11FFD69D11FFD69D11FFD69D11FFD69D11FFD69D11FFD69D
      11FFD69D11FFE0B64CFF4D341ABF00000000000000004D341ABFE0B64CFFD69D
      11FFD69D11FFD69D11FFD69D11FFD69D11FFD69D11FFD69D11FFD69D11FFD69D
      11FFD69D11FFD69D11FFD69D11FFD69D11FFD69D11FFD69D11FFD69D11FFD69D
      11FFD69D11FFD69D11FFD69D11FFD69D11FFD69D11FFD9A320FFE3BC5BFF4D34
      1ABF1A1109700000000000000000000000000000000000000000000000000000
      0000262726F2F5F5F5FFC0C0ECFF3A3ADAFF3A3ADAFFC7C7ECFFF0F0F0FF9F9F
      9FFFC8C8C8FF9F9F9FFFC8C8C8FF9F9F9FFFC8C8C8FF9F9F9FFFC8C8C8FF9F9F
      9FFFC8C8C8FF9F9F9FFFC8C8C8FF9F9F9FFFF2F2F2FFF5F5F5FF262726F20000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000002B2B2BE13838
      38FF383838FF383838FF383838FF161616A20000000004040436696969FF6969
      69FF696969FF696969FF696969FF696969FF696969FF676767FC000000090000
      00000000000000000000000000000000000000000000000000001A1109704D34
      1ABFE1B961FFD69F27FFD39919FFD39919FFD39919FFD39919FFD39919FFD399
      19FFD39919FFD39919FFD39919FFD39919FFD39919FFD39919FFD39919FFD399
      19FFD39919FFD39919FFD39919FFD39919FFD39919FFD39919FFD39919FFD399
      19FFD39919FFDEB352FF4D341ABF00000000000000004D341ABFDEB352FFD399
      19FFD39919FFD39919FFD39919FFD39919FFD39919FFD39919FFD39919FFD399
      19FFD39919FFD39919FFD39919FFD39919FFD39919FFD39919FFD39919FFD399
      19FFD39919FFD39919FFD39919FFD39919FFD39919FFD39919FFD69F27FFE1B9
      61FF4D341ABF1A11097000000000000000000000000000000000000000000000
      0000282928F2F5F5F5FFF3F3F3FFCACAEDFFCCCCEEFFF3F3F3FFF3F3F3FFF3F3
      F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3
      F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF5F5F5FF282928F20000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000707075D383838FF3838
      38FF383838FF383838FF383838FF363636F90303033C0F0F0F63696969FF6969
      69FF696969FF696969FF696969FF696969FF696969FF696969FF040404330000
      000000000000000000000000000000000000000000001A1109704D341ABFDFB9
      67FFD49F30FFD19922FFD19922FFD19922FFD19922FFD19922FFD19922FFD199
      22FFD19922FFD19922FFD19922FFD19922FFD19922FFD19922FFD19922FFD199
      22FFD19922FFD19922FFD19922FFD19922FFD19922FFD19922FFD19922FFD199
      22FFD19922FFDDB359FF4D341ABF00000000000000004D341ABFDDB359FFD199
      22FFD19922FFD19922FFD19922FFD19922FFD19922FFD19922FFD19922FFD199
      22FFD19922FFD19922FFD19922FFD19922FFD19922FFD19922FFD19922FFD199
      22FFD19922FFD19922FFD19922FFD19922FFD19922FFD19922FFD19922FFD49F
      30FFDFB967FF4D341ABF1A110970000000000000000000000000000000000000
      0000292A29F2F6F6F6FFF4F4F4FFBCD2C3FFC1D5C8FFF4F4F4FFF2F2F2FF9F9F
      9FFFC9C9C9FF9F9F9FFFC9C9C9FF9F9F9FFFC9C9C9FF9F9F9FFFC9C9C9FF9F9F
      9FFFC9C9C9FF9F9F9FFFC9C9C9FF9F9F9FFFF4F4F4FFF6F6F6FF292A29F20000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000001B323232F3373737FF3737
      37FF373737FF373737FF373737FF373737FF2C2C2CE40000000C4F4F4FDE6969
      69FF696969FF696969FF696969FF696969FF696969FF3A3A3ABD000000000000
      000000000000000000000000000000000000000000004D341ABFE9CC97FFD8A6
      48FFD2992EFFD2992EFFD2992EFFD2992EFFD2992EFFD2992EFFD2992EFFD299
      2EFFD2992EFFD2992EFFD2992EFFD2992EFFD2992EFFD2992EFFD2992EFFD299
      2EFFD2992EFFD2992EFFD2992EFFD2992EFFD2992EFFD2992EFFD2992EFFD299
      2EFFD2992EFFDDB362FF4D341ABF00000000000000004D341ABFDDB362FFD299
      2EFFD2992EFFD2992EFFD2992EFFD2992EFFD2992EFFD2992EFFD2992EFFD299
      2EFFD2992EFFD2992EFFD2992EFFD2992EFFD2992EFFD2992EFFD2992EFFD299
      2EFFD2992EFFD2992EFFD2992EFFD2992EFFD2992EFFD2992EFFD2992EFFD299
      2EFFD8A648FFE9CC97FF4D341ABF000000000000000000000000000000000000
      00002A2C2AF2F7F7F7FFBFD4C6FF1B6F36FF1B6F36FFC4D7CBFFF5F5F5FFF5F5
      F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5
      F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF7F7F7FF2A2C2AF20000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001010108D363636FF363636FF3636
      36FF363636FF363636FF363636FF363636FF363636FF0909096C3A3A3ABD6969
      69FF696969FF696969FF696969FF696969FF696969FF2727279C000000000000
      000000000000000000000000000000000000000000001A1109704D341ABFF6DF
      A8FFF3D488FFF2D180FFF2D180FFF2D180FFF2D180FFF2D180FFF2D180FFF2D1
      80FFF2D180FFF2D180FFF2D180FFF2D180FFF2D180FFF2D180FFF2D180FFF2D1
      80FFF2D180FFF2D180FFF2D180FFF2D180FFF2D180FFF2D180FFF2D180FFF2D1
      80FFF2D180FFF5DDA0FF4D341ABF00000000000000004D341ABFF5DDA0FFF2D1
      80FFF2D180FFF2D180FFF2D180FFF2D180FFF2D180FFF2D180FFF2D180FFF2D1
      80FFF2D180FFF2D180FFF2D180FFF2D180FFF2D180FFF2D180FFF2D180FFF2D1
      80FFF2D180FFF2D180FFF2D180FFF2D180FFF2D180FFF2D180FFF2D180FFF3D4
      88FFF6DFA8FF4D341ABF1A110970000000000000000000000000000000000000
      00002C2C2CF2F8F8F8FFBBD2C2FF1B6F36FF1B6F36FFC3D6C9FFF4F4F4FF9F9F
      9FFFCACACAFF9F9F9FFFCACACAFF9F9F9FFFCACACAFF9F9F9FFFCACACAFF9F9F
      9FFFCACACAFF9F9F9FFFCACACAFF9F9F9FFFF6F6F6FFF8F8F8FF2C2C2CF20000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000010101090353535FF353535FF353535FF3535
      35FF353535FF353535FF353535FF353535FF353535FF353535FF1F1F1FA46969
      69FF696969FF696969FF696969FF696969FF696969FF0A0A0A51000000000000
      00000000000000000000000000000000000000000000000000001A1109704D34
      1ABFF7E2ABFFF5D88DFFF4D585FFF4D585FFF4D585FFF4D585FFF4D585FFF4D5
      85FFF4D585FFF4D585FFF4D585FFF4D585FFF4D585FFF4D585FFF4D585FFF4D5
      85FFF4D585FFF4D585FFF4D585FFF4D585FFF4D585FFF4D585FFF4D585FFF4D5
      85FFF4D585FFF7E0A4FF4D341ABF00000000000000004D341ABFF7E0A4FFF4D5
      85FFF4D585FFF4D585FFF4D585FFF4D585FFF4D585FFF4D585FFF4D585FFF4D5
      85FFF4D585FFF4D585FFF4D585FFF4D585FFF4D585FFF4D585FFF4D585FFF4D5
      85FFF4D585FFF4D585FFF4D585FFF4D585FFF4D585FFF4D585FFF5D88DFFF7E2
      ABFF4D341ABF1A11097000000000000000000000000000000000000000000000
      00002C2E2CF2F8F8F8FFF6F6F6FFC5D8CBFFC8DACEFFF6F6F6FFF6F6F6FFF6F6
      F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6
      F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF8F8F8FF2C2E2CF20000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000001D1D1DBD353535FF353535FF353535FF3535
      35FF353535FF353535FF353535FF353535FF353535FF353535FF121212904D4D
      4DDB696969FF696969FF696969FF696969FF3D3D3DC300000003000000000000
      0000000000000000000000000000000000000000000000000000000000001A11
      09704D341ABFF7E2ABFFF5D88DFFF4D585FFF4D585FFF4D585FFF4D585FFF4D5
      85FFF4D585FFF4D585FFF4D585FFF4D585FFF4D585FFF4D585FFF4D585FFF4D5
      85FFF4D585FFF4D585FFF4D585FFF4D585FFF4D585FFF4D585FFF4D585FFF4D5
      85FFF4D585FFF7E0A4FF4D341ABF00000000000000004D341ABFF7E0A4FFF4D5
      85FFF4D585FFF4D585FFF4D585FFF4D585FFF4D585FFF4D585FFF4D585FFF4D5
      85FFF4D585FFF4D585FFF4D585FFF4D585FFF4D585FFF4D585FFF4D585FFF4D5
      85FFF4D585FFF4D585FFF4D585FFF4D585FFF4D585FFF5D88DFFF7E2ABFF4D34
      1ABF1A1109700000000000000000000000000000000000000000000000000000
      00002D2F2DF2F9F9F9FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7
      F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7
      F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF9F9F9FF2D2F2DF20000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000001E1E1EC0343434FF343434FF343434FF3434
      34FF343434FF343434FF343434FF343434FF343434FF343434FF101010900000
      00183F3F3FC6696969FF696969FF333333B10000000C00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00001A1109704D341ABFF7E2ABFFF5D88DFFF4D585FFF4D585FFF4D585FFF4D5
      85FFF5D88DFFF6DD9CFFF7E0A4FFF7E0A4FFF7E0A4FFF7E0A4FFF7E0A4FFF7E0
      A4FFF7E0A4FFF7E0A4FFF7E0A4FFF7E0A4FFF7E0A4FFF7E0A4FFF7E0A4FFF7E0
      A4FFF7E0A4FFF9E7BBFF4D341ABF00000000000000004D341ABFF9E7BBFFF7E0
      A4FFF7E0A4FFF7E0A4FFF7E0A4FFF7E0A4FFF7E0A4FFF7E0A4FFF7E0A4FFF7E0
      A4FFF7E0A4FFF7E0A4FFF7E0A4FFF7E0A4FFF7E0A4FFF7E0A4FFF6DD9CFFF5D8
      8DFFF4D585FFF4D585FFF4D585FFF4D585FFF5D88DFFF7E2ABFF4D341ABF1A11
      0970000000000000000000000000000000000000000000000000000000000000
      00002F302FF2F9F9F9FFF8F8F8FFF8F8F8FFF8F8F8FFF8F8F8FFF8F8F8FFF8F8
      F8FFF8F8F8FFF8F8F8FFF8F8F8FFF8F8F8FFF8F8F8FFF8F8F8FFF8F8F8FFF8F8
      F8FFF8F8F8FFF8F8F8FFF8F8F8FFF8F8F8FFF8F8F8FFF9F9F9FF2F302FF20000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000021333333FF333333FF333333FF3333
      33FF333333FF333333FF333333FF333333FF333333FF333333FF000000030000
      0000000000000101011B00000012000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000001A1109704D341ABFF7E2ABFFF5D88DFFF4D585FFF4D585FFF4D5
      85FFF6DD9CFF4D341ABF4D341ABF4D341ABF4D341ABF4D341ABF4D341ABF4D34
      1ABF4D341ABF4D341ABF4D341ABF4D341ABF4D341ABF4D341ABF4D341ABF4D34
      1ABF4D341ABF4D341ABF1A11097000000000000000001A1109704D341ABF4D34
      1ABF4D341ABF4D341ABF4D341ABF4D341ABF4D341ABF4D341ABF4D341ABF4D34
      1ABF4D341ABF4D341ABF4D341ABF4D341ABF4D341ABF4D341ABF4D341ABFF6DD
      9CFFF4D585FFF4D585FFF4D585FFF5D88DFFF7E2ABFF4D341ABF1A1109700000
      0000000000000000000000000000000000000000000000000000000000000000
      0000303130F2F9F9F9FFF8F8F8FFF8F8F8FFF8F8F8FFF8F8F8FFF8F8F8FFF8F8
      F8FFF8F8F8FFF8F8F8FFF8F8F8FFF8F8F8FFF8F8F8FFF8F8F8FFF8F8F8FFF8F8
      F8FFF8F8F8FFF8F8F8FFF8F8F8FFF8F8F8FFF8F8F8FFF9F9F9FF303130F20000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000062F2F2FF6323232FF323232FF3232
      32FF323232FF323232FF323232FF323232FF323232FF262626DE000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000001A1109704D341ABFF7E2ABFFF5D88DFFF4D585FFF4D5
      85FFF7E0A4FF4D341ABF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000004D341ABFF7E0
      A4FFF4D585FFF4D585FFF5D88DFFF7E2ABFF4D341ABF1A110970000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000313331F2FBFBFBFFFAFAFAFFFAFAFAFFF3F3F3FFE4E4E4FFDEDEDEFFDEDE
      DEFFDEDEDEFFDEDEDEFFDEDEDEFFDEDEDEFFDEDEDEFFDEDEDEFFDEDEDEFFDEDE
      DEFFDEDEDEFFE4E4E4FFF3F3F3FFFAFAFAFFFAFAFAFFFBFBFBFF313331F20000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001A1A1ABA323232FF323232FF3232
      32FF323232FF323232FF323232FF323232FF323232FF12121299000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000001A1109704D341ABFF7E2ABFFF5D88DFFF4D5
      85FFF7E0A4FF4D341ABF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000004D341ABFF7E0
      A4FFF4D585FFF5D88DFFF7E2ABFF4D341ABF1A11097000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000323332F2FDFDFDFFFDFDFDFFFDFDFDFFBABABAFF9A9A9AFF9A9A9AFF9A9A
      9AFF9A9A9AFF9A9A9AFF9A9A9AFF9A9A9AFF9A9A9AFF9A9A9AFF9A9A9AFF9A9A
      9AFF9A9A9AFF9A9A9AFFBABABAFFFDFDFDFFFDFDFDFFFDFDFDFF323332F20000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000202023F313131FF313131FF3131
      31FF313131FF313131FF313131FF313131FF303030FC00000021000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001A1109704D341ABFF7E2ABFFF5D8
      8DFFF7E0A4FF4D341ABF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000004D341ABFF7E0
      A4FFF5D88DFFF7E2ABFF4D341ABF1A1109700000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000333433F25A5A5AFF5A5A5AFF5A5A5AFF979797FFF3F3F3FFF0F0F0FFEFEF
      EFFFEDEDEDFFEDEDEDFFEFEFEFFFF0F0F0FFEFEFEFFFEDEDEDFFEDEDEDFFEFEF
      EFFFF0F0F0FFF3F3F3FF979797FF5A5A5AFF5A5A5AFF5A5A5AFF333433F20000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000181818B1313131FF3131
      31FF313131FF313131FF313131FF313131FF0F0F0F9000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000001A1109704D341ABFF7E2
      ABFFF7E2ABFF4D341ABF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000004D341ABFF7E2
      ABFFF7E2ABFF4D341ABF1A110970000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000333433F25B5B5BFF5B5B5BFF5B5B5BFF9D9D9DFFFAFAFAFFF9F9F9FFF8F8
      F8FFF5F5F5FFF3F3F3FFF5F5F5FFF7F7F7FFF5F5F5FFF3F3F3FFF5F5F5FFF8F8
      F8FFF9F9F9FFFAFAFAFF9D9D9DFF5B5B5BFF5B5B5BFF5B5B5BFF333433F20000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000006161616AB3030
      30FF303030FF303030FF303030FF0F0F0F900000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001A1109704D34
      1ABFFAEDC9FF4D341ABF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000004D341ABFFAED
      C9FF4D341ABF1A11097000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00001112118E333533F2333533F2333533F2717271F9A0A0A0FEA0A0A0FEA0A0
      A0FEFBFBFBFFF9F9F9FFA0A0A0FEA0A0A0FEA0A0A0FEF9F9F9FFFBFBFBFFA0A0
      A0FEA0A0A0FEA0A0A0FE717271F9333533F2333533F2333533F21112118E0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000404
      044E101010960F0F0F9003030342000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001A11
      09704D341ABF1A11097000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001A1109704D34
      1ABF1A1109700000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000003535
      358E9B9B9BF2FDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFF9B9B9BF23535
      358E000000000000000000000000000000000000000000000000000000000000
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
      00003636368E9E9E9EF29E9E9EF29E9E9EF29E9E9EF29E9E9EF23636368E0000
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
      000000000003000000070000000D00000011000000170000001D000000250000
      002F0000003F0000004E000000580000006200000065000000630000005E0000
      005200000044000000360000002B000000240000001D00000017000000110000
      000D000000070000000300000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000020000000A0000000E0000
      00040000000801010152080808A9080808B9080808B9080808AA010101540000
      0008000000040000000E0000000C000000020000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000007000000160000
      001D0000001D0000001D0000001D0000001D0000001D0000001D0000001D0000
      001D0000001D0000001D0000001D0000001D0000001D0000001D0000001D0000
      001D0000001D0000001D0000001D0000001D0000001D0000001D0000001D0000
      001D000000160000000700000000000000000000000000000000000000000000
      0001000000040000000D000000170000002300000030000000420000005C0405
      0581191E20B839444ADF455359EB516369F45B6E75F9506166F4455459ED3844
      48E1181E1FBC03040489000000670000004D0000003B0000002E000000230000
      00170000000D0000000400000001000000000000000000000000000000000000
      00000000000000000000000000000000000A0000002E0101016D0505057F0000
      002E000000171F1F1FAF767676FF757575FF757575FF767676FF202020B10202
      053B1A2243B9405188F3465993F43B4B89F02A397AED1A276CEB131D5DE80A0E
      2EBB0001035D0000001A00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000030000
      000E0100001F030100300501003A00000004000000080401003A030100360200
      0028000000170000000900000002000000000000000000000000000000000000
      0000000000000000000000000000000000002C2C2C8E848484F2848484F28484
      84F2848484F2848484F2848484F2848484F2848484F2848484F2848484F28484
      84F2848484F2848484F2848484F2848484F2848484F2848484F2848484F28484
      84F2848484F2848484F2848484F2848484F2848484F2848484F2848484F28484
      84F2353535A80000001600000000000000000000000000000000000000000000
      000000000003000000070000000E00000019000000320B0E0F7F323C41CD6072
      7BF5758990FA89A3A9FD8FAAB0FD95B1BAFE9ABAC1FF91ADB6FE8AA6ADFE839E
      A5FD6E848AFA5E7278F62F393CC90A0C0C7A000000310000001C000000120000
      000D000000070000000300000000000000000000000000000000000000000000
      00000000000000000000000000170000005C121212BD515151F5656565FA0909
      099D0000003E363636D1848484FF868686FF868686FF848484FF40434CDC5162
      85DB748DBFFF5A6EAAFF43518DFF364077FF2B356BFF1F2A6BFF202B74FF1B22
      63FF141649EF0404109E0000000F000000000000000000000000000000000000
      0000000000000000000000000001020000211D0D07694C2413A47E361CD39D3E
      22EFAA4025FDA43922FF8F2E1EF900000013000000161E0C009C210D00A4200D
      00A21E0C009C1809008E100600730702004C0100002000000004000000000000
      000000000000000000000000000000000000848484F2EDEDEDFFE9E9E9FFE9E9
      E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9
      E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9
      E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFEDED
      EDFF848484F20000001D00000000000000000000000000000000000000000000
      000000000000000000020000000E05050650262E31B5657881F48CA4AAFCA4C0
      C6FFA0BEC4FF9FBDC3FF9EBCC3FF9DBCC2FF9CBBC1FF9BBAC1FF9AB9C0FF99B9
      BFFF98B8BFFF99B8BFFF819A9FFB63747CF521282AA10000001B0000000B0000
      0002000000010000000000000000000000000000000000000000000000000000
      000000000000000000060303035F3F3F3FE8787878FF868686FF878787FF5858
      58F6000000934B4B4BEA8E8E8EFF919191FF919191FF8E8E8EFF585E69F06175
      A4F92D3A7EFF17225BFF3D536BFF5D7E93FF567186FF384350FF263155FF2D3C
      80FF1E266CFF0406128D00000011000000180000000000000000000000000000
      000000000005160B05597B4829C3DA743FFCE05D2BFFD14C22FFC2421EFFB438
      1BFFA52D17FF972313FF811710F900000013000000171E0C009D220D00A6220D
      00A6220D00A6220D00A6220D00A6210D00A51F0D009F1307007D030100370000
      000600000000000000000000000000000000858585F2EEEEEEFFEAEAEAFFEAEA
      EAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEA
      EAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEA
      EAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEEEE
      EEFF858585F20000001D00000000000000000000000000000000000000000000
      0000000000010000000F15191A875D7077F3889FA5FAA8C2C8FFA5C2C8FFA4C1
      C7FFA4C0C6FFA2C0C6FFA1BFC5FFA0BEC4FF9FBEC4FF9EBDC3FF9DBCC3FF9CBB
      C2FF9BBAC1FF9BBBC2FFA6C2C8FFC3D5DAFF6C7D83FA4B4728C90C0B035F0000
      000D000000010000000000000000000000000000000000000000000000000000
      00000000000000000008262626928F8F8FFF8D8D8DFF919191FF939393FF9191
      91FF383838F45C5C5CFC999999FF9D9D9DFF9D9D9DFF9A9A9AFF5C5D5EFC323E
      6BFB2A316BFF8F9091FFA1D3DFFF8FD5F4FF7BB5DDFF8E999EF96A5A53DB3E49
      7FFB080D26970000000F00000008000000160000000000000000000000000703
      0134936A41CEF2BA74FFEE9D5CFFE8773FFFE05927FFD14D22FFC2421FFFB438
      1BFFA52D17FF972313FF811710F90000001300000017592912C8592813CC4C22
      0EC53E1908BD2B1002B0210D00A6210D00A5220D00A6220D00A6210D00A31207
      007B01000020000000000000000000000000858585F2EEEEEEFFB3B3B3FFB3B3
      B3FFB3B3B3FFB3B3B3FFB3B3B3FFB3B3B3FFB3B3B3FFB3B3B3FFB3B3B3FFB3B3
      B3FFB3B3B3FFB3B3B3FFB3B3B3FFB3B3B3FFB3B3B3FFB3B3B3FFB3B3B3FFB3B3
      B3FFB3B3B3FFB3B3B3FFB3B3B3FFB3B3B3FFB3B3B3FFB3B3B3FFB3B3B3FFEEEE
      EEFF858585F20000001D00000000000000000000000000000000000000000000
      00000000000B191F219165777FF4A4BABEFDACC6CCFFAAC5CAFFA9C4CAFFA9C3
      C9FFA7C3C9FFA6C2C8FFA6C1C7FFA4C1C7FFA4C0C6FFA2BFC5FFA2BFC5FFA0BE
      C4FFA1BEC5FFA9C4C9FFC5D6DAFFA4B1B5FE4C503DFCBF9F2AFB94802BF3221D
      09860000000A0000000000000000000000000000000000000000000000000000
      0014000000280000001B020202438F8F8FF8969696FF9B9B9BFF9F9F9FFFA2A2
      A2FF979797FF9D9D9DFFA7A7A7FFA7A7A7FFA7A7A7FFA7A7A7FF9E9E9EFF6771
      94FF777D9EFFD9D7C0FFC7CDC0FF8BB5D0FFA3B6B7FE635543B16A5343AA7876
      91F402061783000000120000001A0000000F0000000000000000120A054DE1C7
      82F5F9DE91FFF4BF77FFEE9D5CFFE8773FFFE05927FFD14D22FFC2421FFFB438
      1BFFA52D17FF972313FF811710F90000001300000017CD4F23F9D55124FFD04F
      25FFCB5027FFC5502AFFAE4625F882371CE4542510CB2A1002AE210D00A5220D
      00A61A0A0092010000260000000000000000868686F2EFEFEFFFB3B3B3FFEBEB
      EBFFEBEBEBFFEBEBEBFFEBEBEBFFEBEBEBFFB3B3B3FFEBEBEBFFEBEBEBFFEBEB
      EBFFEBEBEBFFEBEBEBFFB3B3B3FFEBEBEBFFEBEBEBFFEBEBEBFFEBEBEBFFEBEB
      EBFFB3B3B3FFEBEBEBFFEBEBEBFFEBEBEBFFEBEBEBFFEBEBEBFFB3B3B3FFEFEF
      EFFF868686F20000001D00000000000000000000000000000000000000000000
      00071013157662747DF3ACC3C7FEB0C8CDFFAEC7CDFFADC7CCFFACC6CCFFABC6
      CBFFAAC5CBFFA9C4CAFFABC5CBFFACC7CBFFADC7CCFFABC5CAFFA6C2C8FFA5C2
      C8FFABC6CBFFC3D6DAFFB5C2C4FE485557FEB29A31FEE3BC22FFD5B22AFE927E
      2AF3131105680000000600000000000000000000000000000000000000120303
      0370212121C90404049C0000006B505050D59F9F9FFFA7A7A7FFABABABFFADAD
      ADFFAFAFAFFFB1B1B1FFB2B2B2FFB3B3B3FFB3B3B3FFB3B3B3FFB2B2B2FF7681
      A2FF8A94B9FFE6E6D4FFD3D2C3FFA3ADB9FFA89F89F2544734B2896E57D98D8C
      AAFD070E2CC0000000190000000C0000000B000000000100001CD7BA78EFFDF7
      A5FFF9DD91FFF4BF77FFEE9D5CFFE8773FFFDF5725FFD35429FFCF6A44FFCE7D
      5AFFCF8D69FFCE9672FFBD8E6BF90000001300000017D55927F9DE5726FFD953
      24FFD34F23FFCD4A21FFC74620FFC1421EFFBD411FFFB64726FD79331AE03114
      04B4210D00A5170900890000000C00000000878787F2EFEFEFFFB3B3B3FFEBEB
      EBFFEBEBEBFFEBEBEBFFEBEBEBFFEBEBEBFFB3B3B3FFEBEBEBFFEBEBEBFFEBEB
      EBFFEBEBEBFFEBEBEBFFB3B3B3FFEBEBEBFFEBEBEBFFEBEBEBFFEBEBEBFFEBEB
      EBFFB3B3B3FFEBEBEBFFEBEBEBFFEBEBEBFFEBEBEBFFEBEBEBFFB3B3B3FFEFEF
      EFFF878787F20000001D00000000000000000000000000000000000000030405
      05435B6E74F2A7BBC0FCB4CBD2FFB2CAD0FFB1C9D0FFB0C9CFFFB0C8CFFFB0C8
      CEFFB4CBD1FFBBD0D5FFC4D6DBFFCADBDFFFCCDBE0FFC8D8DDFFC0D3D9FFBBD0
      D5FFC6D7DCFFC3CFD2FE505E62FEA59539FEE4BD25FFE3BC23FFE3BD24FFCAAA
      2EFC8F7C29F20302003200000002000000000000000000000004000000414545
      45E28F8F8FFF737373FD383838EE111111E1A5A5A5FFB1B1B1FFB4B4B4FFB7B7
      B7FFBABABAFFBEBEBEFFC4C3C3FFC9C7C6FFC9C7C7FFC4C3C3FFBEBEBEFF7885
      ACFF6D769BFFECE9DBFFE7E6E8FF9FABBBFF8F8570F5AA987BF8D9BFA2FE8486
      A3FF27305DF3000000450000000600000001000000002B211473FCEB9CFFFDF7
      A5FFF9DD91FFF3BE77FFF1AD6BFFF3BA77FFF8D892FFFCF3A9FFFDF5A6FFFDF3
      A2FFFCF2A1FFFCF1A0FFECE094F9000000190100001ED96B37F9E56731FFE25C
      29FFDE5625FFD85224FFD24E23FFCC4A21FFC64520FFC0411EFFBB3D1CFFB84A
      28FD603017D0200C00A50201003200000000888888F2F0F0F0FFB3B3B3FFB3B3
      B3FFB3B3B3FFB3B3B3FFB3B3B3FFB3B3B3FFB3B3B3FFB3B3B3FFB3B3B3FFB3B3
      B3FFB3B3B3FFB3B3B3FFB3B3B3FFB3B3B3FFB3B3B3FFB3B3B3FFB3B3B3FFB3B3
      B3FFB3B3B3FFB3B3B3FFB3B3B3FFB3B3B3FFB3B3B3FFB3B3B3FFB3B3B3FFF0F0
      F0FF888888F20000001D000000000000000000000000000000000000000D242C
      2EA99BABB0FABBD0D5FFB7CED3FFB5CDD2FFB5CCD2FFB4CCD1FFB5CCD2FFBCD1
      D7FFCDDCE0FFDEE8EBFFDCE4E6FECCD4D6FCAFBABFFBCBD3D6FCDCE4E5FEE2EC
      EEFFD5DFE1FE5A6A6EFE9C9242FEE5BF29FFE4BE27FFE4BD26FFE4BD25FFE5BD
      27FFB79D33FA362F0FA30000000B00000000000000000000001B131313A38F8F
      8FFEA2A2A2FFA7A7A7FFA5A5A5FF9F9F9FFFB6B6B6FFBBBBBBFFC0C0C0FFC6C6
      C6FFD7D7D5FFE2E0DFFFE5E4E3FFE6E5E4FFE6E5E4FFE5E4E3FFE2E1E0FF8896
      BCFF464F7EFFBDB4ACFFF1F2F3FFB3BECBFFD4CCBCFFE8E0C5FFB6A896FF5C65
      8EFF485187FF141414A70000001B00000000000000004236228CFBEA9BFFFDF6
      A5FFFAE398FFFAE59BFFFCF0A1FFFCEE9EFFFCEE9EFFFCED9DFFFBEC9DFFFBEB
      9CFFFBEA9BFFFBE99AFFF2DE93FD480E07C9480E07CAE28248FDE87B40FFE66F
      37FFE4642FFFE25B28FFDD5525FFD75124FFD14D22FFCB4921FFC5451FFFC34B
      24FFDA9650FF71361ADF0502004500000000898989F2F0F0F0FFB3B3B3FFECEC
      ECFFECECECFFECECECFFECECECFFECECECFFB3B3B3FFECECECFFECECECFFECEC
      ECFFECECECFFECECECFFB3B3B3FFECECECFFECECECFFECECECFFECECECFFECEC
      ECFFB3B3B3FFECECECFFECECECFFECECECFFECECECFFECECECFFB3B3B3FFF0F0
      F0FF898989F20000001D000000000000000000000000000000010A0C0D5E7587
      8EF5C3D6DBFFBDD1D7FFBBD0D5FFBBD0D5FFB9CFD4FFB9CFD4FFC4D6DBFFD8E4
      E7FFD2DADDFD7F9094F64A5A60DE384449C220282A94384449C25A6D73F28898
      9BF86C7E80FE999659FEE9C838FFE6C12DFFE5BF2AFFE4BF29FFE4BE28FFE4BD
      27FFE4BF2EFF9A852FF50A09034F00000001000000020101013A6B6B6BEDA4A4
      A4FFACACACFFB2B2B2FFB8B8B8FFBCBCBCFFC2C2C2FFC6C6C6FFD4D4D3FFE2E1
      E0FFE2E2E2FFE1E1E1FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2E2FFE1E1E1FF8C9A
      BFFF36468CFFC0BCBAFFCCC5B7FFC2CCDCFFECEDE4FFC8BBA3FFA7A19DFF556A
      A7FF4D5686FF6B6B6BEE0000003C000000020000000038301F7DFBEA9BFFFCF1
      A4FFFBEA9CFFFBE99AFFFBE899FFFBE798FFFAE698FFFAE597FFFAE496FFFAE3
      95FFFAE295FFFAE194FFF5D98FFF81130EFF81130EFFF8E9B6FFFBEBAAFFFAE1
      A3FFF7D196FFF3B982FFED9B68FFE57142FFDB5424FFD65123FFD04C22FFCD52
      26FFDF9B51FFC5592CFE0B040246000000008A8A8AF2F1F1F1FFB3B3B3FFEDED
      EDFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFB3B3B3FFEDEDEDFFEDEDEDFFEDED
      EDFFEDEDEDFFEDEDEDFFB3B3B3FFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFEDED
      EDFFB3B3B3FFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFB3B3B3FFF1F1
      F1FF8A8A8AF20000001D00000000000000000000000000000008303B3EBBAEBF
      C4FBC2D7DBFFC0D5D9FFBFD4D8FFBED4D8FFBDD3D7FFC5D9DCFFDBE7E9FFA9B5
      B7F95D7076F21014156A00000000000000000000000000000000000000030D0F
      0E5A8B803BF5CFBB5BFBF1D653FFE9C839FFE5C22EFFE5C12CFFE5C02BFFE4C0
      2AFFE4C02BFFC5A837FB423912AF0000000600000000030303339E9E9EEEB1B1
      B1FFB6B6B6FFBBBBBBFFC1C1C1FFC6C6C6FFCCCBCBFFDAD9D7FFE1E0DFFFDDDD
      DDFFDDDDDDFFE3E3E3FFE8E8E8FFE8E8E8FFE9E9E9FFE8E8E8FFE3E3E3FF7983
      ADFF36468BFFD6D5D8FF9697A9FF798BADFFC0B8A6FFC2C1C0FFA8A8B1FF3C51
      98FF5A628DFF8D8D8DEF030303370000000000000000342C1C76FAE59CFFFAE2
      96FFFAE194FFF9E093FFF9DF93FFF9DE92FFF9DD91FFF9DD90FFF9DB8FFFF8DA
      8FFFF8DA8EFFF8D88DFFF4D188FF81130EFF81140FFFF8EAB4FFFCEDA4FFFCED
      A3FFFBECA2FFFBEBA1FFFBEAA0FFFBEBA5FFF8DB9EFFEEA773FFDF6C40FFD962
      35FFE6A45DFFD16437FF2A110A75000000008A8A8AF2F1F1F1FFB3B3B3FFB3B3
      B3FFB3B3B3FFB3B3B3FFB3B3B3FFB3B3B3FFB3B3B3FFB3B3B3FFB3B3B3FFB3B3
      B3FFB3B3B3FFB3B3B3FF4F4FE5FF4F4FE5FF4F4FE5FF4F4FE5FF4F4FE5FF4F4F
      E5FF4F4FE5FFB3B3B3FFB3B3B3FFB3B3B3FFB3B3B3FFB3B3B3FFB3B3B3FFF1F1
      F1FF8A8A8AF20000001D0000000000000000000000000102022D697C83F4CFDE
      E2FFC6D9DDFFC5D8DDFFC3D6DBFFC2D6DBFFC5D8DDFFD8E4E7FF9EABAFF81E25
      2790010202220000000000000000000000000000000000000000000000000000
      0000070602393C34109FC7B253FAEED24CFFE7C535FFE5C230FFE5C22FFFE5C1
      2EFFE5C02DFFE6C538FF94812DF3010100200000000000000006080808459191
      91E2C0C0C0FFC3C3C3FFC9C9C9FFCFCFCFFFDAD9D9FFE1E0DFFFD9D9D9FFDADA
      DAFFE4E4E4FFDEDEDEFE999999DF5C5C5CB45B5B5BB3979797DEDDDDDDFE7683
      ADFF324586FFCECFD3FF818AB0FF608AB5FF9BA4A4FFCBCBCAFFA8ABB6FF3D54
      95FF44507BF507070746000000060000000000000000342C1D76F9DE9EFFF9DF
      9BFFF8DB93FFF8D88EFFF8D78BFFF8D68BFFF7D58AFFF7D489FFF7D388FFF7D2
      87FFF7D187FFF7D086FFF3C981FF9C2815FF9C2816FFF8E4ABFFFAE599FFFAE4
      98FFFAE397FFFAE297FFFAE196FFFAE095FFF9DF94FFF9DE93FFF9DE96FFEFB1
      73FFECA85DFFD96633FF3314097F000000008B8B8BF2F1F1F1FFB4B4B4FFEEEE
      EEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFB4B4B4FFEEEEEEFFEEEEEEFFEEEE
      EEFFEEEEEEFFEEEEEEFF4F4FE5FF9696F8FF9696F8FF9696F8FF9696F8FF9696
      F8FF4F4FE5FFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFB4B4B4FFF1F1
      F1FF8B8B8BF20000001D0000000000000000000000001317197999A8ADF9D0E0
      E2FFCADBDFFFC9DBDEFFC8DADEFFC8DADDFFD0E0E3FFC5CFD2FC354044BD0000
      0011000000000000000000000000000000000000000000000000000000000000
      000000000000030301288F7C29F2E3CB59FDEACB40FFE6C333FFE6C332FFE5C2
      31FFE5C130FFE7C637FFAE993AF81714066C0000000E00000035000000550000
      007A656565E9C6C6C6FFD3D3D3FFD7D7D7FFE3E2E2FFD4D4D4FFD4D4D4FFE0E0
      E0FFAFAFAFEE0B0B0B520000000C00000002000000020000000A0909094F7783
      A9F83A498AFFA9AFBBFF8DADC1FF93CEEDFF84B1D7FF949796FFA8A9AFFF4D60
      9DFC131B41D500000055000000350000000E00000000342D1F76F8D9A3FFF9DC
      A2FFF9DB9DFFF7D493FFF7D18CFFF6CE86FFF6CC83FFF6CA82FFF6CA81FFF5C8
      80FFF5C77EFFF5C67DFFF4C27BFFD96F46FFD96E45FFF9DFA4FFF9DB8FFFF8DA
      8FFFF8D98EFFF8D88DFFF8D78CFFF8D68BFFF8D58AFFF7D48AFFF7D389FFF7D2
      88FFF6CC84FFE3733CFF3614097F000000008C8C8CF2F2F2F2FFB4B4B4FFEFEF
      EFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFB4B4B4FFEFEFEFFFEFEFEFFFEFEF
      EFFFEFEFEFFFEFEFEFFF4F4FE5FF9696F8FF9696F8FF9696F8FF9696F8FF9696
      F8FF4F4FE5FFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFB4B4B4FFF2F2
      F2FF8C8C8CF20000001D0000000000000000000000002C3539B1BAC6CBFCD1E0
      E4FFCEDEE2FFCDDDE1FFCCDCE1FFCCDDE1FFD9E5E9FF849297F60B0D0E580000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000001D19086FAD9A42F6ECD04CFFE5C638FFE5C436FFE5C3
      35FFE4C334FFE5C438FFC6AB42FB3C3310A4010101432A2A2AC9464646EB6262
      62F5868686FCCDCDCDFFD9D9D9FFE2E2E1FFDADADAFFCFCFCFFFD5D5D5FFCBCB
      CBFC080808540000000600000000000000000000000000000000000000042A32
      4DB73E4F8BFF7A93A8FFAEE5F2FF8BCCEBFF79B1D9FF819AB2FF848381FF5866
      91FF39416DFB464646EB2B2B2BCA01010145000000001C181057F9DCAFFFF8D9
      A8FFF8D8A3FFF8D9A0FFF7D498FFF6CB8DFFF5C785FFF4C37EFFF4C07AFFF4BF
      78FFF4BE77FFF3BD76FFF3BC76FFF3BB75FFF3BA75FFF9DB9EFFF7D288FFF7D1
      87FFF7D086FFF7CF86FFF6CE85FFF6CD84FFF6CC83FFF6CB82FFF6CA81FFF5C9
      80FFF5C880FFF3BA75FF38180B7F000000008D8D8DF2F2F2F2FFB4B4B4FFB4B4
      B4FFB4B4B4FFB4B4B4FFB4B4B4FFB4B4B4FFB4B4B4FFB4B4B4FFB4B4B4FFB4B4
      B4FFB4B4B4FFB4B4B4FF4F4FE5FF4F4FE5FF4F4FE5FF4F4FE5FF4F4FE5FF4F4F
      E5FF4F4FE5FFB4B4B4FFB4B4B4FFB4B4B4FFB4B4B4FFB4B4B4FFB4B4B4FFF2F2
      F2FF8D8D8DF20000001D000000000000000000000000414F54D3CDD9DCFDD3E2
      E5FFD1E1E4FFD0E0E3FFCFDFE3FFD1E0E4FFD7E2E4FE5A6D73F2000000030000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000A917E2BF2EBD253FFE7C83DFFE5C639FFE5C6
      38FFE5C537FFE6C539FFD3BB46FC5A4D19C50A0A0A6BBCBCBCFECBCBCBFFD0D0
      D0FFD5D5D5FFDADADAFFDFDFDFFFE9E9E8FFCCCCCCFFC9C9C9FFD5D5D5FF6565
      65D200000016000000000000000000000000000000000000000000000000151B
      2F8F606E9AFFBCCCC8FF99CFE1FF8AC3E0FF85B2D1FF869CADFF938E8BFF6371
      99FF6A719EFFCCCCCCFFBEBEBEFE0B0B0B6E0000000000000009B59E7BDAF9DD
      B4FFF8DAADFFF8D6A7FFF8D4A1FFF8D59EFFF7D196FFF5CA8BFFF4BF78FFF3B8
      72FFF2B470FFF2B26EFFF2B16DFFF1B06DFFF1AF6CFFF7D296FFF5C980FFF5C8
      7EFFF5C77DFFF5C67CFFF5C57BFFF5C47AFFF4C27AFFF4C179FFF4C078FFF4BF
      77FFF4BE76FFF4BD75FF3B29197F000000008F8F8FF2F3F3F3FFB4B4B4FFF0F0
      F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFB4B4B4FFF0F0F0FFF0F0F0FFF0F0
      F0FFF0F0F0FFF0F0F0FFB4B4B4FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
      F0FFB4B4B4FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFB4B4B4FFF3F3
      F3FF8F8F8FF20000001D000000000000000000000000516369E9DBE5E8FED6E4
      E7FFD5E3E6FFD4E3E6FFD3E2E5FFD5E4E6FFC2CED1FC333D41BB000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000005F531ACBDBC252FDE7CA42FFE6C73DFFE6C7
      3CFFE5C63BFFE6C73CFFDEC34BFD716220DB0B0B0B6ECACACAFED5D5D5FFD5D5
      D5FFD7D7D7FFD9D9D9FFDBDBDBFFE6E5E4FFC4C4C4FFC5C5C5FFCBCBCBFF2424
      24A000000008000000000000000000000000000000000000000000000000090D
      1C728791ACFEF1F2DDFFDFE8EEFFC9CBC9FFE3DCC8FFE2D0B7FFE6CEB2FF9393
      ADFF727BA5FFD5D5D5FFCBCBCBFE0C0C0C71000000000000000005040328C1A8
      88E1F9DEBAFFF9DBB3FFF8D7ACFFF7D4A5FFF6CE99FFF4BF7AFFF6C980FFF8D9
      95FFF9DE99FFF8D68FFFF6CE86FFF5C880FFF5C47CFFF5C78BFFF4C184FFF3BA
      7EFFF1B278FFEFA871FFEDA06AFFEC9965FFEB9561FFE9905EFFA86A49DA1714
      124F12100D4512100D450403032200000000909090F2F4F4F4FFB4B4B4FFF1F1
      F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFB4B4B4FFF1F1F1FFF1F1F1FFF1F1
      F1FFF1F1F1FFF1F1F1FFB4B4B4FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1
      F1FFB4B4B4FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFB4B4B4FFF4F4
      F4FF909090F20000001D000000000000000000000000586B72F2E5EEF0FFDAE7
      EAFFD8E5E8FFD7E5E8FFD6E4E7FFD8E5E8FFBDC9CCFC2C3439B0000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000001574B19C2D4BE4EFCE8CA44FFE6C840FFE6C8
      3FFFE6C73FFFE7C740FFE6CC52FE806E24E60B0B0B6BD6D6D6FEE6E6E6FFEAEA
      EAFFEFEFEFFFF4F4F4FFF7F7F6FFEBEBEAFFBEBEBEFFC0C0C0FFBDBDBDFF1616
      1696000000080000000000000000000000000000000000000000000000000408
      1A787C849FFEF3F3E2FFF4F2F1FFDCD7D0FFF5EBD3FFFAEBCFFFFAE7C2FF8984
      9AFF8890B7FFE6E6E6FFD7D7D7FE0C0C0C6E0000000000000000000000000101
      001461523FA0F3D6B2FCF9DCB9FFF7D4AAFFF3BC78FFF3B973FFF6CC91FFF9DB
      A4FFF9DEA2FFF8D89AFFF7D08FFFF5C784FFF3BE78FFF2B570FFF1AE6AFFEFA5
      64FFEE9D5DFFEC9456FFEB8B4FFFEA8248FFE77A42FF7B5C46CD0000000F0000
      000000000000000000000000000000000000919191F2F4F4F4FFB4B4B4FFB4B4
      B4FFB4B4B4FFB4B4B4FFB4B4B4FFB4B4B4FFB4B4B4FFB4B4B4FFB4B4B4FFB4B4
      B4FFB4B4B4FFB4B4B4FFB4B4B4FFB4B4B4FFB4B4B4FFB4B4B4FFB4B4B4FFB4B4
      B4FFB4B4B4FFB4B4B4FFB4B4B4FFB4B4B4FFB4B4B4FFB4B4B4FFB4B4B4FFF4F4
      F4FF919191F20000001D0000000000000000000000004F6067E6E1EAECFEDEE9
      ECFFDCE8EBFFDBE7EAFFDAE7EAFFD9E7EAFFC6D3D6FD374247C4000000040000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000066D5E1ED8DDC553FDE7CA46FFE7C944FFE7C9
      44FFE6C843FFE7CA46FFE1C855FD726120DA09090955E6E6E6FDF7F7F7FFFAFA
      FAFFFBFBFBFFFCFCFCFFFCFCFCFFF1F1F1FFBBBBBBFFBBBBBBFFBBBBBBFF2222
      22B4000000160000000000000000000000000000000000000000000000030F15
      36AB424C80FDCECDC7FFD9DAD9FFCCCCD0FFF4EDE0FFF5EDD7FFC8BAADFF3E48
      7DFF727BAAFFEEEEF1FFE9E9E9FE0A0A0A570000000000000000000000000000
      00000000000014102E898E76B1FFDEAA82FFF4B66EFFF5C793FFF8D8AFFFF9DD
      AFFFF9DFACFFF8DAA4FFF7D29AFFF6CA8FFFF4C184FFF2B676FFF0AB6AFFEEA1
      60FFED9959FFEE8F50FFDC915DFFC4B698FF9BE6E4FF266974AD000000000000
      000000000000000000000000000000000000929292F2F5F5F5FFB4B4B4FFF2F2
      F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFB4B4B4FFF2F2F2FFF2F2F2FFF2F2
      F2FFF2F2F2FFF2F2F2FFB4B4B4FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2
      F2FFB4B4B4FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFB4B4B4FFF5F5
      F5FF929292F20000001D0000000000000000000000003F4C51CFDCE4E6FEE2ED
      EFFFDFEBEDFFDEEAECFFDDE9EBFFDCE9EBFFD8E4E6FE5B6D73F2000000140000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000010101002194822EF3EAD157FFE7CD4BFFE7CB48FFE7CA
      47FFE7CA46FFE9CD4CFFD8C258FC574C19C2000000142929297D595959B18787
      87D8B0B0B0F7F2F2F2FFFAFAFAFFF7F6F6FFBBBABAFFB6B6B6FFB9B9B9FF5555
      55E70000003F0000000600000000000000000000000000000000010205362F3D
      79F03C4983FF444C79FF7B819CFF979AAFFF9291A7FF656790FF1F296FFF2432
      76FF202662FF42445ED72C2C2C80000000160000000000000000000000000000
      00000000000000012D810002CCFF0102DDFF2F23D6FF6954C7FF9880B6FD8F7D
      5FC2C4B186E6EED69FFFF2D099FFF1C992FFECC389FFE3BC81FF926D47CA5639
      2399608EA4F63FB5DDFF3FDAFCFF6AECFDFF64EAFDFF1C6474AD000000000000
      000000000000000000000000000000000000949494F2F5F5F5FFB5B5B5FFF3F3
      F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFB5B5B5FFF3F3F3FFF3F3F3FFF3F3
      F3FFF3F3F3FFF3F3F3FFB5B5B5FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3
      F3FFB5B5B5FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFB5B5B5FFF5F5
      F5FF949494F20000001D000000000000000000000000293135A8CCD4D6FCE7F0
      F2FFE2ECEFFFE1ECEEFFE0EBEEFFDFEBEDFFE0EBEEFF8D9DA3F71216177D0000
      0006000000000000000000000000000000000000000000000000000000000000
      0000000000000000000828230B90B3A043F7E9D159FFE8CE52FFE8CD4FFFE6CC
      4EFFE6CB4BFFEAD155FFC9B556FA37300F9A00000000000000060000002A0000
      0084474747EEE7E7E7FFF8F8F8FFF7F7F7FFCECDCDFFB2B2B2FFB2B2B2FF9D9D
      9DFE0B0B0BA4000000330000000A00000002000000020000000A010104491E25
      4EDD4F6099FF6178AFFF6B84B6FF6A82B6FF5369A2FF293B85FF172472FF1F26
      62FD0E1135D603030C6B00000006000000000000000000000000000000000000
      00000000000000012C800002C7FF0001D7FF0000E4FF0000E7FF0001D6FB0000
      0001040A05415EC777FF6AD590FF73E0A4FF75E5ACFF70E0A4FF040906360000
      0000007CD3EE0AAFFCFF24C6FCFF34D3FDFF33D2FDFF105B74AD000000000000
      000000000000000000000000000000000000959595F2F5F5F5FFB5B5B5FFB5B5
      B5FFB5B5B5FFB5B5B5FFB5B5B5FFB5B5B5FFB5B5B5FFB5B5B5FFB5B5B5FFB5B5
      B5FFB5B5B5FFB5B5B5FFB5B5B5FFB5B5B5FFB5B5B5FFB5B5B5FFB5B5B5FFB5B5
      B5FFB5B5B5FFB5B5B5FFB5B5B5FFB5B5B5FFB5B5B5FFB5B5B5FFB5B5B5FFF5F5
      F5FF959595F20000001D0000000000000000000000000F131468AAB5B7F9ECF3
      F4FFE6EFF1FFE5EEF0FFE4EEEFFFE3EDEFFFE3ECEEFFD1DCDFFE5B6D73F20304
      0544000000070000000000000000000000000000000000000000000000000000
      0001000000080D0B035B917E2CF2E2CC61FEE9D15DFFE8D058FFE8CF55FFE8CE
      54FFE9CE53FFEDD663FFB19F48F7110F055800000000000000230909099D6F6F
      6FF7E3E3E3FFF5F5F5FFF5F5F5FFF5F5F5FFEBEBEAFFB1B1B1FFACACACFFACAC
      ACFF7F7F7FFB141414C200000079000000550000005400000077131313C07D7D
      7DFAACACACFFACACACFFB1B1B1FFEAEAEAFFF5F5F5FFF5F5F5FFF5F5F5FFE4E4
      E4FF6F6F6FF70A0A0AA000000025000000000000000000000000000000000000
      00000000000000012A800003BFFF0002CCFF0001D5FF0001D7FF0002CAFB0000
      0000040A044059BF6AFF62CB7EFF69D38EFF6BD793FF68D38DFF040905360000
      0000006FD3EE009AFCFF08ADFCFF13B8FCFF12B7FCFF044F74AD000000000000
      000000000000000000000000000000000000969696F2F6F6F6FFF4F4F4FFF4F4
      F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4
      F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4
      F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF6F6
      F6FF969696F20000001D000000000000000000000000000101186E7F86F4F2F7
      F8FFEAF2F4FFE7F0F2FFE6EFF2FFE6EFF1FFE5EEF1FFE5EEF1FFB2BFC3FA272F
      32B6050506500000001300000006000000010000000000000001000000060000
      00140F0D04664D4215C4CFBB5CFBEBD568FFEAD364FFE9D261FFE9D05EFFE8D0
      5BFFEBD361FFEFDB73FF94812DF30000000C0000000203030346989898F6E7E7
      E7FFF2F2F2FFF2F2F2FFF2F2F2FFF3F3F3FFF3F3F3FFD5D5D5FFA9A9A9FFA8A8
      A8FFA7A7A7FF979797FF5D5D5DF73A3A3AEB393939EA5C5C5CF6949494FEA7A7
      A7FFA8A8A8FFA9A9A9FFD4D4D4FFF4F3F3FFF3F3F2FFF2F2F2FFF2F2F2FFF2F2
      F2FFE8E8E8FF999999F603030348000000020000000000000000000000000000
      000000000000000128800004B4FF0003BFFF0002C6FF0002C7FF0003BDFB0000
      00000409034052B558FF5EC16EFF6BCA82FF73CF8BFF77CF8CFF050906360000
      00002E7FD4EE3AA1FCFF38ABFCFF35B0FCFF2DADFCFF114B74AD000000000000
      000000000000000000000000000000000000969696F2F7F7F7FFF5F5F5FFF5F5
      F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5
      F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5
      F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF7F7
      F7FF969696F20000001D00000000000000000000000000000000262E31A1D0D7
      D9FCF0F5F7FFEAF2F4FFE9F1F3FFE8F1F3FFE7F0F2FFE6F0F2FFE6F0F2FFB4C1
      C5FA5C6F76F2191E2099010101400000001E000000120000001F020200442B25
      0C9E927F2CF2D1BE61FBECD872FFEBD66FFFEBD66BFFEBD569FFEAD366FFEAD4
      65FFEFDB73FFC9B863F930290D8F00000000000000000000001D979797E2EEEE
      EEFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFF0F0F0FFF1F1F1FFCDCDCDFFA4A4
      A4FFA2A2A2FFA2A2A2FFA2A2A2FFA2A2A2FFA2A2A2FFA2A2A2FFA2A2A2FFA2A2
      A2FFA4A4A4FFCCCCCCFFF1F1F1FFF0F0F0FFEFEFEFFFEFEFEFFFEFEFEFFFEFEF
      EFFFEEEEEEFF9B9B9BE30000001F000000000000000000000000000000000000
      000000000000000126800005A8FF0004B1FF0003B6FF0003B7FF0207AFFB0000
      0000050A04406FBB6CFF7BC580FF83CB8AFF88CE90FF8ACE90FF060906360000
      00004685D4EE59A5FDFF59AAFDFF59ADFDFF58ACFDFF274D74AD000000000000
      000000000000000000000000000000000000979797F2F7F7F7FFF5F5F5FFF5F5
      F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5
      F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5
      F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF7F7
      F7FF979797F20000001D000000000000000000000000000000000406063A7485
      8BF5F4F8F8FFEFF5F6FFECF3F4FFEBF2F4FFEAF2F4FFE9F1F3FFE8F1F3FFE7F0
      F2FFD9E3E6FE98A5AAF863757DF33E4B50D4303227B065581CD6968330F3BAA7
      51F8E3D077FDEDDA7CFFECD979FFECD876FFECD773FFEBD671FFEBD76EFFEED9
      74FFEFDE83FE958230F30403012900000000000000000000000413131368DADA
      DAFDECECECFFEBEBEBFFE4E4E4FFDADADAFFEAEAEAFFECECECFFF0F0F0FFDCDC
      DCFFA9A9A9FF9E9E9EFF9E9E9EFF9E9E9EFF9E9E9EFF9E9E9EFF9E9E9EFFA8A8
      A8FFDBDBDBFFF0F0F0FFECECECFFEAEAEAFFE1E1E1FFE7E7E7FFEBEBEBFFECEC
      ECFFDCDCDCFD1616166D00000004000000000000000000000000000000000000
      0000000000000001238000059AFF0005A2FF060BA9FF181DB1FF2A2EAEFB0000
      0000050A044071B766FF7BBF75FF82C480FF87C786FF8AC787FF060805360000
      00003EA3D4ED4DC5FDFF4DC5FDFF4DC6FDFF4DC5FDFF245B75AE000000000000
      0000000000000000000000000000000000004747B6F91111D4FF1111D4FF1111
      D4FF1111D4FF1111D4FF1111D4FF1111D4FF1111D4FF1111D4FF1111D4FF1111
      D4FF1111D4FF1111D4FF1111D4FF1111D4FF1111D4FF1111D4FF1111D4FF1111
      D4FF1111D4FF1111D4FF1111D4FF1111D4FF1111D4FF1111D4FF1111D4FF1111
      D4FF4747B6F90000001D00000000000000000000000000000000000000001C23
      258CC5CBCEFBF5F9FAFFF0F6F7FFEDF4F5FFECF4F5FFECF3F4FFEBF3F4FFEAF2
      F4FFE9F2F3FFE9F2F3FFE8F0F2FFD6DFE1FD8A948DF8E6D68AFEEFDE8DFFEEDD
      89FFEEDC86FFEEDB84FFEDDA81FFEDDA7DFFECD97AFFECD878FFEEDB7CFFF4E3
      8DFFC0B15FF82A240B8500000000000000000000000000000000000000106767
      67C3D9D9D9FFB6B6B6F6585858C1131313B4CFCFCFFFE8E8E8FFE8E8E8FFEAEA
      EAFFF0F0F0FFDEDEDEFFC6C6C6FFBABABAFFBABABAFFC6C6C6FFDEDEDEFFF0F0
      F0FFEBEBEBFFE8E8E8FFE8E8E8FFCFCFCFFF161616B6646464BFC5C5C5F6E0E0
      E0FF6E6E6EC60000001000000000000000000000000000000000000000000000
      0000000000000001218001098EFF12189BFF2127A5FF2B30A9FF3237A5FB0000
      00000509044072B25FFF7BB96DFF83BF77FF88C27DFF8BC381FF060805360000
      0000020A0D3C020C0F41020C0F41020C0F41020C0F410105072D000000000000
      0000000000000000000000000000000000001515D1FE5151D9FF3838D3FF3838
      D3FF3838D3FF3838D3FF3838D3FF3838D3FF3838D3FF3838D3FF3838D3FF3838
      D3FF3838D3FF3838D3FF3838D3FF3838D3FF3838D3FF3838D3FF3838D3FF3838
      D3FF3838D3FF3838D3FF3838D3FF3838D3FF3838D3FF3838D3FF3838D3FF5151
      D9FF1515D1FE0000001D00000000000000000000000000000000000000000101
      011C5E7077F2E5E9EAFDF6F9FAFFF1F7F8FFEFF5F7FFEEF5F6FFEDF4F6FFECF4
      F5FFECF3F5FFEBF3F5FFEAF3F4FFEFF5F7FF9CA8AAFEF4E6A2FFF0DF94FFEFDF
      91FFEFDE8EFFEEDD8BFFEEDC88FFEDDB85FFEDDB83FFEFDD85FFF4E392FFD8C9
      7CFB403812A50000000B00000000000000000000000000000000000000000101
      011F22222279010101260000003A4D4D4DDEDDDDDDFFE6E6E6FFE6E6E6FFE6E6
      E6FFE6E6E6FFE7E7E7FFEAEAEAFFEDEDEDFFEDEDEDFFEAEAEAFFE7E7E7FFE6E6
      E6FFE6E6E6FFE6E6E6FFE6E6E6FFDDDDDDFF444444DF0000003C010101262A2A
      2A79010101230000000000000000000000000000000000000000000000000000
      00000000000002031F80141C89FF1F2693FF282F9BFF3238A0FF393F9CFB0000
      00000609044073AD58FF7CB466FF84BA70FF8ABD77FF8DBF7BFF060805360000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001F1FD5FE5454DCFF3C3CD7FF3C3C
      D7FF3C3CD7FF3C3CD7FF3C3CD7FF3C3CD7FF3C3CD7FF3C3CD7FF3C3CD7FF3C3C
      D7FF3C3CD7FF3C3CD7FF3C3CD7FF3C3CD7FF3C3CD7FF3C3CD7FF3C3CD7FF3C3C
      D7FF3C3CD7FF3C3CD7FF3C3CD7FF3C3CD7FF3C3CD7FF3C3CD7FF3C3CD7FF5454
      DCFF1F1FD5FE0000001D00000000000000000000000000000000000000000000
      00000B0E0F596D7F85F4EFF1F2FEF7FAFBFFF3F8F9FFF0F7F8FFEFF6F7FFEEF5
      F7FFEEF5F6FFEDF4F6FFECF4F6FFF1F6F8FFA2AEAFFEF4E7A8FFF0E19BFFEFE0
      98FFEFDF95FFEEDF92FFEEDE8FFFEEDD8DFFF0E091FFF4E69CFFE8D991FD9280
      2DF2090802400000000000000000000000000000000000000000000000000000
      0000000000000000000803030365A8A8A8FBE1E1E1FFE1E1E1FFE1E1E1FFE1E1
      E1FFDADADAFFDCDCDCFFE1E1E1FFE2E2E2FFE2E2E2FFE1E1E1FFDCDCDCFFD9D9
      D9FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FF9C9C9CFB0303036A000000080000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000004061E801B247EFF262D89FF2F3691FF394097FF414896FB0000
      00000609044077AF5DFF7EB366FF86B76DFF8CBA74FF90BD7AFF060805360000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000002929D8FE5959E0FF4141DCFF4141
      DCFF4141DCFF4141DCFF4141DCFF4141DCFF4141DCFF4141DCFF4141DCFF4141
      DCFF4141DCFF4141DCFF4141DCFF4141DCFF4141DCFF4141DCFF4141DCFF4141
      DCFF4141DCFF4141DCFF4141DCFF4141DCFF4141DCFF4141DCFF4141DCFF5959
      E0FF2929D8FE0000001D00000000000000000000000000000000000000000000
      0000000000001014156A687880F3E2E6E7FDF9FCFCFFF5F9FAFFF3F8F9FFF1F7
      F8FFF0F6F7FFEFF6F7FFEFF5F7FFF2F8F9FFA8B3B5FEF5E9AFFFF1E4A3FFF0E3
      A0FFF0E29DFFF0E29BFFF1E39BFFF3E59FFFF7EAA7FFDDCF89FC92802DF21512
      055F000000000000000000000000000000000000000000000000000000000000
      0000000000000000000827272793D0D0D0FFDEDEDEFFDEDEDEFFDEDEDEFFD9D9
      D9FF676767D5A9A9A9F4DCDCDCFFDEDEDEFFDEDEDEFFDCDCDCFFADADADF55D5D
      5DD3D5D5D5FFDEDEDEFFDEDEDEFFDEDEDEFFCCCCCCFF22222298000000080000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000005071E80212A7EFF2C3485FF363E8BFF404791FF484F92FB0000
      0000060A064083CC8EFF85CD8FFF86CE90FF87CE92FF88CF92FF060A07380000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000003535DDFE5E5EE5FF4747E1FF4747
      E1FF4747E1FF4747E1FF4747E1FF4747E1FF4747E1FF4747E1FF4747E1FF4747
      E1FF4747E1FF4747E1FF4747E1FF4747E1FF4747E1FF4747E1FF4747E1FF4747
      E1FF4747E1FF4747E1FF4747E1FF4747E1FF4747E1FF4747E1FF4747E1FF5E5E
      E5FF3535DDFE0000001D00000000000000000000000000000000000000000000
      00000000000000000000080A0A4A5B6E74F2C7CDD0FBFAFCFCFFF8FBFCFFF6FA
      FAFFF4F9FAFFF2F8F9FFF1F7F8FFF4F9FAFFAEB8BAFEF6EBB6FFF3E7ACFFF3E7
      ABFFF3E7AAFFF5E8ABFFF7EBAFFFF8EDB2FFCABB74F9403711A40908023F0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000001010121626262BECECECEFDDADADAFFD7D7D7FF9898
      98E50000003C868686DFD9D9D9FFDADADAFFDADADAFFD9D9D9FF898989E10000
      003A878787E3D5D5D5FFD9D9D9FFCDCDCDFD646464C101010125000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000006081F80272F82FF313988FF3C448EFF464D94FF4F5696FB0000
      00000001011C1123166B1123166B1123166B1123166B1123176C000100170000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000003F3FDFFE6262E9FF4C4CE6FF4C4C
      E6FF4C4CE6FF4C4CE6FF4C4CE6FF4C4CE6FF4C4CE6FF4C4CE6FF4C4CE6FF4C4C
      E6FF4C4CE6FF4C4CE6FF4C4CE6FF4C4CE6FF4C4CE6FF4C4CE6FF4C4CE6FF4C4C
      E6FF4C4CE6FF4C4CE6FF4C4CE6FF4C4CE6FF4C4CE6FF4C4CE6FF4C4CE6FF6262
      E9FF3F3FDFFE0000001D00000000000000000000000000000000000000000000
      00000000000000000000000000000101011A1C222489808E93F5D7DCDEFCFAFB
      FCFFFAFCFDFFF8FBFCFFF7FBFBFFF8FBFCFFB6BFC1FFF9F1C3FFF7EEBCFFF8EE
      BCFFFAF0BEFFF7EEB9FEDACD8EFBA08E3EF52B250C8600000011000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000081111115A8E8E8EDCAEAEAEED0808
      0846000000175E5E5EC5D5D5D5FFD5D5D5FFD5D5D5FFD5D5D5FF606060C70000
      001707070745A0A0A0EC8F8F8FDE1111115C0000000800000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000E0F24804B5297FF545B9DFF5E64A2FF676DA7FF6C71A6FB0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004949E3FE7676EFFF6666EDFF6666
      EDFF6666EDFF6666EDFF6666EDFF6666EDFF6666EDFF6666EDFF6666EDFF6666
      EDFF6666EDFF6666EDFF6666EDFF6666EDFF6666EDFF6666EDFF6666EDFF6666
      EDFF6666EDFF6666EDFF6666EDFF6666EDFF6666EDFF6666EDFF6666EDFF7676
      EFFF4949E3FE0000001600000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000004050536242B2E9A6072
      79F29FABAFF8CED4D6FBE7EBEBFDEAECEDFDB1B6B2F9EFE6B6FDECE2B0FDD8CD
      92FBB9A962F7917E2CF2322C0E910504012E0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000200000010020202230000
      0004000000082E2E2E8BCACACAFDC8C8C8FDC8C8C8FDCACACAFD3131318E0000
      0008000000020202022300000010000000020000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000001022E7F0A0CC1FC0B0DC2FC0B0DC2FC0B0EC2FC0C0EBCF80000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000005252E6FE9A9AF4FF9494F4FF9494
      F4FF9494F4FF9494F4FF9494F4FF9494F4FF9494F4FF9494F4FF9494F4FF9494
      F4FF9494F4FF9494F4FF9494F4FF9494F4FF9494F4FF9494F4FF9494F4FF9494
      F4FF9494F4FF9494F4FF9494F4FF9494F4FF9494F4FF9494F4FF9494F4FF9A9A
      F4FF5252E6FE0000000700000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0009080A0A4A1D24268C354045BC384449C22C2D229A5A4E19C2534717B92D27
      0C890C0A03470000000600000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000012060606370606063A0606063A06060637000000120000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000047478BCC5757E8FE5757E8FE5757
      E8FE5757E8FE5757E8FE5757E8FE5757E8FE5757E8FE5757E8FE5757E8FE5757
      E8FE5757E8FE5757E8FE5757E8FE5757E8FE5757E8FE5757E8FE5757E8FE5757
      E8FE5757E8FE5757E8FE5757E8FE5757E8FE5757E8FE5757E8FE5757E8FE5757
      E8FE47478BCC0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000101011A392D21A20504032800000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000101
      01030101010C01010114010101160101011601010116010101140101010C0101
      0103000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000005050544090909591A15119391714FFF826546F11E18116E010101020000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000101
      0105010101100101011601010116010101160101011601010116010101100101
      0105000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000001010101010101080101
      01190101012E0101013D0101014201010143010101420101013D0101012E0101
      0119010101090101010100000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000003000000080000000D010101140101011C020202240303
      032C04040434050505360404043003030329020202210101011A000000120000
      000C000000060000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000101
      01053A3B3BA3868684D6D0CDCAFABBB0A6FF9D8C7CFF8E765CFF433424C70302
      024C010101060101010200000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000101
      0110010101310101014201010143010101430101014301010142010101310101
      0110000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000010101040101010D010101150101
      0116010101160101011601010116010101160101011601010116010101160101
      0116010101160101011601010116010101160101011601010119010101270101
      013E383736B67B7A78FA817F7DFF817F7DFF817F7DFF7B7A78FA383736B60101
      013E010101240101010C01010101000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0002010101310303033B050505440606064C070707560707075E070707670606
      066F040404770101017D03030379060606710707076807070760070707570606
      064E050505450303033B00000009000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000101010A0101
      012D6E6D6DC79A9896E0F0F0EFFFF7F4F2FFF5F7F9FFE4E5E4FFCEC9C2FFADA1
      95FE282420A70202023C0101011D010101120101010B01010105000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000101010201010109010101110101010D01010104000000000101
      0116646260F36B6967FF686664FF787573FF686664FF6B6967FF646260F30101
      011600000000010101040101010D010101110101010901010102000000000000
      0000000000000000000000000000000000000101010D0101012B0101013F0101
      0143010101430101014301010143010101430101014301010143010101430101
      0143010101430101014301010143010101430101014301010144121211798783
      81FFAFAEADFFD1CFCFFFDCDBDCFFDBDBDBFFDCDBDCFFD1CFCFFFAFAEADFF8683
      81FF131212770101012401010109000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00197F8183F0B3B7B8F9B5BABBFAB6B9BCFAB8B9BCFAB9BBBDFAB9BCBDFABCBF
      C0FBBEBFC1FBBFC1C2FBC0C2C3FBC1C3C4FBC1C2C2FAC2C2C3FAAEAEAEFBC5C6
      C6FAC7C7C7FA808082ED00000019000000000000000000000000000000000000
      00000000000000000000000000000000000000000000010101100101012F0101
      013684817ED9D6CEC8FFF4F0EEFFEDE6E1FFF1F0EFFFF4F3F3FFF8FAFAFFFAFB
      FDFFF8F8F7FFB7B7B6EB4E4E4EB51515157C0303034C0101012D0101011B0101
      01130101010B0101010600000000000000000000000000000000000000000000
      0000010101040101011101010127010101380101012E01010114010101030101
      01166C6A68FFE6E6E3FFE0DFDDFFDEDDDDFFE0DFDDFFE6E6E3FF6C6A68FF0101
      011601010103010101140101012E010101380101012701010111010101040000
      0000000000000000000000000000000000000101011523384FC4406993FF4069
      93FF406993FF406993FF406993FF406993FF406993FF406993FF406993FF4069
      93FF406993FF406993FF406993FF3F6993FF3B6794FF527190FF938D89FFC8C7
      C5FFC5C3C2FFACA9A6FFA29F9CFFA29E9CFFA29F9CFFACA9A6FFC5C3C2FFC7C7
      C5FF8E8B89FF1312127301010119010101030000000000000000000000000000
      0000000000000000000000000003000000050000000A0000000E000000130202
      022F9FA1A3F4E6EBEEFFE8ECEFFFE9EDF0FFEBEEF1FFECEFF2FFEEF1F3FFEFF2
      F4FFF1F3F5FFF2F4F6FFF3F5F7FFF5F7F8FFF6F8F9FFF8F9FAFFDCDDDDFFA6A6
      A6FF999999FF9E9F9FEE00000014000000000000000000000000000000000000
      0000000000000000000000000000000000000101011A01010135010101300303
      0344B7B4B3EFC1BBB6FFF3EEECFFEEE8E3FFF0EEEDFFF0EDEBFFF0EDEBFFF0ED
      ECFFF1F0F0FFF7F7F6FFFFFEFEFFFDFDFEFFDBDBDBF7818181D22F2F2F9C0A0A
      0A650101013B0101011300000000000000000000000000000000000000000101
      010401010114010101301717168A716D6BFF3D3B3AC6010101340101011D0101
      01276C6967FFE0DFDEFFDEDCDBFFDCDAD9FFDEDCDBFFE0DFDEFF6C6866FF0101
      01270101011D010101343D3B3AC6716D6BFF1717168A01010130010101140101
      01040000000000000000000000000000000001010116416993FF5185ACFF4D81
      AAFF4C81AAFF4C80AAFF4B80AAFF4B80AAFF4B80AAFF4B80AAFF4B80AAFF4B80
      AAFF4B80AAFF4B80AAFF4B80AAFF497FAAFF487EA9FF928D8AFFC6C2BFFFBAB6
      B4FFADABA8FFE7E6E7FFFFFFFFFFFFFFFFFFFFFFFFFFE7E6E7FFADABA8FFBAB6
      B4FFC3C1BFFF8F8C8AFF0101012E0101010C0000000000000000000000010000
      000A01010117030303250404042F0505053906060642060606490606064F0606
      0664A1A4A6F7E6EAEEFFE7EBEFFFE9EDF0FFEAEEF1FFECEFF2FFEDF0F3FFEFF1
      F4FFF0F3F5FFF1F4F6FFF3F5F6FFF4F6F7FFF5F7F8FFF6F8F9FFDADCDDFFF8F9
      FAFFCFD0D1FF9A9A9AEF00000014000000000000000000000000000000000000
      0000000000000000000001010107010101260101013601010134010101270B0B
      0A6BDAD6D3FFE7E6E3FFF3EDEAFFF0EBE7FFF3F1F1FFF1EEEDFFF0EEECFFF0ED
      ECFFF0ECEBFFF0ECEBFFF0EDECFFF0EDEDFFF4F2F2FFFBFAFAFFFFFFFFFFF6F7
      F8FFAEADADE8545454A60C0C0C39000000000000000000000000010101020101
      011101010130393837C392908EFFC9C8C6FF82817FFF373736C1010101470101
      01486A6866FFDFDEDCFFDAD8D7FFD8D6D5FFDAD8D7FFDEDEDBFF72706EFF0101
      014801010147373635C182817FFFC9C8C6FF92908EFF393837C3010101300101
      01110101010200000000000000000000000001010116406994FF5889B1FF4A80
      AAFF477EAAFF437CA9FF417BA8FF417BA8FF417BA8FF417BA8FF417BA8FF417B
      A8FF417BA8FF417BA8FF417BA9FF3F7BAAFF74899AFFB3ADA9FFBFBBB9FFACA9
      A8FFFFFEFEFFFFFFFFFFFFFFFFFF4D4D4DFFFFFFFFFFFFFFFFFFFFFEFEFFACA9
      A8FFBEBBB9FFAFACABFF3C3B3BAE010101140000000000000000000000080101
      01130202021E04040429050505340606063E0606064806060653070707791313
      12AF929496FBCCD0D3FFCDD0D3FFCED1D4FFCFD2D5FFD0D3D6FFD1D5D6FFD4D7
      D8FFD5D7D9FFD6D8DAFFD7D9DBFFD9DBDDFFDADCDDFFDBDDDEFFC2C3C5FFDCDE
      DFFFDEDFE0FF909091EF00000014000000000000000000000000000000000000
      0000000000000101010F010101300101013601010133010101320101012E544D
      47CDC4BCB4FFD1CAC5FFF4EEEAFFE6E1DEFFE2E0DFFFECEBE8FFEFEEEDFFF5F4
      F2FFF2EFEEFFF0EEECFFF0EDECFFF0EDECFFEFEDECFFF0EDEBFFF0EDEAFFF1EF
      EEFFF7F6F5FFFBFAFAFF31313176000000000000000000000000010101090101
      01273A3838C2989694FFE2E1DFFFDEDCDBFFDADAD8FF8F8D8BFF6C6A67FF6B69
      67FF9C9A98FFDDDBDAFFD7D5D4FFD6D4D3FFD7D5D4FFDDDBDAFF9C9A98FF6A68
      66FF73716FFF979592FFDAD9D7FFDEDCDBFFE2E1DFFF989694FF3A3838C20101
      012701010109000000000000000000000000010101163F6A94FF5E8DB5FF467E
      ABFF93A4AEFFBDB7AEFFB9B3ADFFB8B3ACFFB8B3ACFFB8B3ACFFB8B3ACFFB8B3
      ACFFB8B3ACFFB8B3ACFFB9B3ADFFBBB6B0FF9D9793FFC0BCBAFFA8A5A3FFE3E2
      E1FFFEFEFDFFFBFBFAFFFFFFFEFFFFFFFFFFFFFFFEFFFBFCFAFFFEFEFDFFE3E2
      E1FFA8A5A3FFC0BDBCFF918E8DF9010101160000000000000000000000000000
      00030000000D010101160202021E030303250404042C0A0A0A6294938BFBBDBB
      B1FFAEB2B5FFE7EBEEFFE6EAEEFFE7ECEFFFE9EDF0FFEAEEF1FFEBEFF2FFEDF0
      F2FFEEF1F3FFEFF2F4FFF0F3F5FFF1F4F6FFF2F4F6FFF3F5F7FFD7D9DAFFADAF
      B0FFB2B2B4FF9B9D9DEE00000014000000000000000000000000000000000000
      000001010119010101340101013501010133010101330101012807050470A89A
      8CFFE5E3DFFFF3F2F0FFEFE8E3FFE4E1DDFFDFDCDCFFDDDBD8FFDCD9D7FFC4BF
      BDFFF3F0ECFFF1EEEEFFF0EEEDFFF0EDECFFF0EDECFFF0EDECFFF0EDECFFF0ED
      ECFFF0EDECFFF0EEECFF1515144C000000000000000000000000010101111615
      157F949290FFE2E1E0FFD8D5D4FFD5D4D3FFD8D5D4FFDEDEDDFFE2E1DFFFE1E1
      DEFFDDDBDAFFD7D5D4FFD4D2D1FFD4D2D1FFD4D2D1FFD7D5D4FFDDDBDAFFE1E0
      DEFFE1E1DEFFDEDDDCFFD8D5D4FFD5D4D3FFD8D5D4FFE2E1E0FF949290FF1615
      157F0101011100000000000000000000000001010116406B94FF6593B9FF437E
      ACFFBDB6AEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF979290FFBFBDBBFFA19D9BFFFFFF
      FFFFFDFDFCFFFCFCFBFFFFFFFFFF575757FFFFFFFFFFFEFEFDFFFDFDFCFFFFFF
      FFFFA19E9CFFC0BEBCFF9D9A98FF010101160000000000000000000000000000
      000000000000000000000000000000000001000000050202023CB2B0A7FFBDBB
      B1FFAFB2B5FFE8ECEFFFE5EAEDFFE6EBEEFFE8ECEFFFE9EDF0FFEAEEF1FFEBEF
      F2FFEDF0F2FFEEF1F3FFEFF2F4FFF0F2F4FFF1F3F5FFF1F4F6FFD6D7D9FFDADD
      DEFF9FA0A2FF939496EF00000014000000000000000000000000010101040101
      0124010101370101013401010133010101330101013101010131483827D7B4AA
      9FFFB6AEA5FFEDEBE9FFEFE8E3FFDDD9D7FFDAD6D6FFDEDBD9FFE5E1DFFF969D
      A9FFCAD2D9FFF8F5F1FFF0EDECFFF0EDECFFF0EDECFFF0EEECFFF0EDECFFF0ED
      ECFFF1EEEDFFEFEDECFF11100F4B0000000000000000000000000101010D7674
      72FFCCCBC9FFDAD9D7FFD2D1D0FFD2D0CFFFD2D0CFFFD3D1D0FFD3D1D0FFD3D1
      D0FFD2D0CFFFD2D0CFFFD2D0CFFFD2D0CFFFD2D0CFFFD2D0CFFFD2D0CFFFD3D1
      D0FFD3D1D0FFD3D1D0FFD2D0CFFFD2D0CFFFD3D1D0FFDCDAD9FFCCCBC9FF7674
      72FF0101010D00000000000000000000000001010116406A95FF6A99BEFF447F
      AEFFB8B3ACFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFFFEFFFFFF
      FEFFFFFFFEFFFFFFFEFFFFFFFFFFFFFFFFFF999593FFBEBBB9FF9F9C9AFFFFFF
      FEFF505050FFFEFEFCFF585858FFA5A5A6FF5B5B5BFF808081FFA7A7A8FFD5D4
      D4FFA09D9BFFBFBCBAFFA29E9CFF010101160000000000000000000000000000
      000000000000000000000000000000000000000000000000002BAAA89FFEBAB7
      ADFF9FA2A5FFD6D9DCFFD2D5D9FFCED2D6FFCFD3D6FFD0D4D7FFD1D5D8FFD2D6
      D8FFD3D7D8FFD4D7D9FFD5D8DAFFD6D8DAFFD7D9DBFFD7D9DBFFBEC0C2FFD8DA
      DCFFD8DADCFF8C8D8EEF0000001400000000000000000101010A0101012F0101
      01370101013301010133010101330101013301010126100D0A7D7E6146FFC5C1
      B9FFECEAEBFFF3F3F3FFEEE6E2FFF1F0EFFFF2F0EDFFECE8E8FFE7E2DCFFBBCE
      E1FF82A7CEFFE9E9EBFFF5F2F0FFEFEDECFFF0EDECFFF0EDECFFF0EDECFFF0ED
      ECFFF2F0EFFFE7E1DFFF16110C61000000000000000000000000010101043B39
      39B4878583FFE4E2E1FFD4D2D1FFD0CECDFFD0CECDFFD0CECDFFD0CECDFFD0CE
      CDFFD0CECDFFD0CECDFFD0CECDFFD0CECDFFD0CECDFFD0CECDFFD0CECDFFD0CE
      CDFFD0CECDFFD0CECDFFD0CECDFFD0CECDFFD4D2D1FFDCDAD9FF878583FF3B3A
      39B50101010400000000000000000000000001010116406B95FF719EC2FF4480
      B0FFB8B2ABFFFFFFFFFFFFFFFFFF018040FFFFFFFFFFFFFFFFFFFFFEFEFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9C9A97FFC7C4C3FF9E9A98FFFAFA
      F9FFF6F6F5FFF6F6F5FFFEFEFDFF5C5C5CFFFFFFFFFFF8F8F7FFF6F7F6FFFAFA
      F9FF9E9B99FFC9C6C5FFA4A3A1FF010101140000000000000000000000000000
      00221717169D00000011000000000000000000000011151513A3A29F97FDA5A3
      9AFFAEB2B4FFE8ECEFFFE9EDF0FFE4E9EDFFE5EAEDFFE7EBEEFFE8ECEFFFE9EC
      F0FFEAEDF0FFEBEEF1FFEBEFF2FFECEFF2FFEDF0F3FFEDF0F3FFD2D5D6FFEEF1
      F4FFEFF1F4FF97989AEE000000140000000000000000010101070101011F0101
      0130010101340101013301010133010101300101013669523AE17E654CFFBEB5
      B0FFBCB5ADFFF6F2F2FFEEE7E2FFF2F0F0FFF1F2EFFFF3F1F1FFF7F3EFFFC1CF
      DFFF84A2BDFF989187FFFBF9F8FFEFEDEBFFF0EDECFFF0EDECFFF0EEECFFF0ED
      ECFFF3F0EFFFA9A6A2DC01010109000000000000000000000000000000000101
      0103353333AE9D9A98FFE0E0DFFFCECCCBFFCECCCBFFCECCCBFFCECCCBFFCECC
      CBFFCECCCBFFCECCCBFFCECCCBFFD3D2D0FFCECCCBFFCECCCBFFCECCCBFFCECC
      CBFFCECCCBFFCECCCBFFCECCCBFFCECCCBFFE0DEDDFF9C9A97FF333332AE0101
      01060000000000000000000000000000000001010116406B95FF77A2C7FF4581
      B2FFB9B2ACFFFFFFFFFF01803FFFFFFFFFFF018141FFFFFFFFFFFFFFFFFF9696
      96FFC2C2C2FFC1C1C1FFC0C0C0FFFFFFFFFF9F9D9AFFCBC9C7FFA7A3A1FFDAD8
      D7FFF2F1F0FFF0EFEEFFF6F5F4FF7F7F80FFF6F5F4FFF1F0EFFFF2F1F0FFDAD8
      D7FFA7A4A2FFCDCCC9FF9F9B9AF80101010C0000000000000000000000063837
      34C3CFCCC4FF5E5C57DC0A0A0A700A0A09724A4845D8C5C1B6FFCBC8BDFFB8B5
      ACFFAFB3B4FFE9ECEFFFE9EDF0FFE6EBEEFFE4E9EDFFE5EAEDFFE6EAEEFFE7EB
      EFFFE8ECEFFFE9EDF0FFEAEDF0FFEAEEF1FFEBEEF1FFECEFF2FFD0D3D6FFECEF
      F2FFECF0F2FF959799EE00000014000000000000000000000000010101020101
      01210101012F01010134010101330101012416120D89977754FF75624FFFD7D2
      CCFFE3DFDCFFF4EFEEFFE8E0DBFFEDECEBFFF2EFECFFF5F3F0FFF9F8F8FFC3BB
      AFFF9A7B50FF735833FFF6F5F4FFF2EFF0FFF0EEECFFF0EEECFFF0EEECFFF0EE
      ECFFF2EFEDFF6A6A6AAE00000000000000000101010501010110010101160101
      01160101012773716FFFE5E5E2FFCCCAC9FFCCCAC9FFCCCAC9FFCCCAC9FFCCCA
      C9FFD2D0CFFFDEDDDBFFE6E5E3FFD6D5D3FFE6E5E3FFDEDDDBFFD2D0CFFFCCCA
      C9FFCCCAC9FFCCCAC9FFCCCAC9FFCCCAC9FFE0E0DDFF908E8CFF0707074E0101
      011701010116010101100101010500000000010101163F6C96FF7FA8CAFF4681
      B4FFB8B2ABFFFFFFFFFFFFFCFFFFFFFDFFFFFFFFFFFF01803EFFFFFDFFFFFEFC
      FCFFFDFCFCFFFCFBFBFFFCFAFAFFFEFDFDFFCBCAC9FFBFBDBCFFC7C5C3FFA4A2
      A0FFECEBEAFFEFEEEDFFF1F0EFFFA3A3A3FFF1F0EFFFEFEEEDFFECEBEAFFA4A2
      A0FFC8C6C4FFC3C1C1FF3F3E3E9F01010103000000000000000019191799CDCA
      C2FFDBD9D3FFD8D5CEFF9D9B92FCA5A399FCC6C2B7FFC8C4B9FFC9C6BBFFB6B4
      AAFFADB1B3FFE6E9ECFFE6E9ECFFE6EAEDFFE1E4E8FFDFE3E6FFE0E4E7FFDFE4
      E7FFE0E5E7FFE0E4E8FFE1E5E8FFE1E5E8FFE1E5E8FFE2E5E8FFC6CACDFFE1E5
      E8FFE1E5E8FF909393EF000000140000000000000000000000000101011D0101
      012E0101013501010135010101300202013C7B6047EB896A4AFF8B7865FFC8C1
      BBFFCCC5C0FFF6F3F1FFDED9D5FFD8D9D8FFDDDAD9FFD9D6D6FFE9E7E7FFCAC9
      C8FFA38867FF6D4D27FFD5D0C8FFFBFBFAFFF5F2F0FFF3EFEFFFF2F0EFFFF1EE
      EDFFF3F0EDFF3E3E3D8600000000000000000101011001010131010101420101
      01430101014874716FFFE7E6E4FFCAC8C7FFCAC8C7FFCAC8C7FFC9C8C7FFD4D2
      D1FFE0DFDDFF9F9D9BFF757371FF696765F0757371FF9F9D9BFFDFDFDDFFD4D2
      D1FFC9C7C7FFCAC8C7FFCAC8C7FFCAC8C7FFE5E2E2FF7B7977FF010101480101
      01430101014201010131010101100000000001010116406D96FF83ADCEFF4683
      B6FFB7B2ABFFFFFFFFFFFFFAFCFFFFFBFEFFFFFBFEFFFFFBFEFFFCF9FAFFF8F8
      F8FFF8F8F8FFF8F8F8FFF8F8F8FFF9F9F9FFF8F7F8FFAEACAAFFD8D7D6FFBEBD
      BBFFA2A09EFFD5D2D2FFF0EFEEFFCAC9C9FFF0EFEEFFD5D2D2FFA2A09EFFBEBD
      BBFFDAD9D8FFAFADABFF010101090000000000000000000000000504044E7875
      6FE6D9D7D1FFB3B0A8FFBCB9B0FFD8D6CFFFC6C2B7FFC6C2B7FFC7C4B9FF9D9B
      92FC9EA1A5FEDBDFE1FFDCDFE2FFDCDFE3FFDCDFE2FFD1D6D9FFD0D5D9FFD1D5
      D9FFD2D6D9FFD3D8DAFFD4D8DBFFD5D9DBFFD5D9DCFFD7DADDFFBEC1C3FFD7DA
      DDFFD7DADDFF8A8C8FEF00000014000000000000000001010102010101130101
      011B010101260101012D010101252019139AA4825EFF74573CFF948578FFE4E1
      DEFFF0F0EFFFF2EBE7FFDDD9D7FFE0DEDDFFE4E0E0FFE0DEDCFFE5E2DFFFD2D6
      DBFFA4947FFF846438FF8B7D6AFFE8E9ECFFDFDEDBFFE7E5E3FFE8E6E4FFEBE9
      E8FFF2EFEEFF1E1E1D5E000000000000000001010116716E6CF37B7876FF7976
      73FF7D7B79FFA6A4A2FFDEDDDBFFC8C5C4FFC9C6C5FFC9C5C5FFD0CECCFFE1DF
      DFFF7C7A78FF201F1E84010101030000000001010103201F1E848B8987FFE1DF
      DEFFD0CECCFFC9C5C5FFC9C6C5FFC9C5C4FFDEDDDBFFA6A4A2FF767371FF7976
      74FF7B7876FF716E6CF30101011600000000010101163F6C96FF89B2D2FF4785
      B8FFB8B2ABFFFFFFFFFFFFFCFFFF018142FFFFFCFFFFFFF8FAFFFAF7F7FFF9F8
      F8FFF9F8F8FFF9F8F8FFF9F7F8FFF9F7F8FFFBFAFAFFE1E0DFFFB3B1AEFFDFDE
      DFFFD1D0D0FFA7A5A3FF979492FF989592FF979492FFA7A5A3FFD2D1D0FFE0E0
      E0FFB7B5B2FF1010104F01010101000000000000000000000000000000000303
      034264615BDEA29F95FFD6D4CDFFDBD9D3FFCDCAC1FFA7A399F9242321A70404
      0460A0A3A6F4E9EDF0FFE9EDF0FFE9EDF0FFEAEEF0FFE9EDF0FFE3E7ECFFE2E7
      EBFFE3E8ECFFE3E8ECFFE4E9EDFFE5E9EDFFE5EAEDFFE5EAEEFFCBCED2FFE6EA
      EEFFE6EAEEFF919497EE00000014000000000000000000000000000000000000
      0000000000000000000005040335967655FB9B7B58FF73563CFFACA092FFBBB4
      AEFFE2DDDBFFF1EAE5FFDFDDDCFFDBDCDBFFDEDCDBFFD9D7D6FFE0DFDDFFD2D6
      D6FFA69F9BFF9C8153FF735A39FFEDEDEFFFDFDDDBFFE0DBDAFFDBD8D6FFD4D3
      D3FFECEBE8FF0B0B0B370000000000000000010101167C7A78FFEEEDEDFFE9E9
      E8FFE8E7E7FFDEDDDBFFD1CFCDFFC6C3C1FFC7C4C2FFC6C3C1FFDDDCDAFFA19F
      9DFF2121208A01010103000000000000000000000000010101032121208AA19F
      9DFFDDDCDAFFC6C3C1FFC7C4C2FFC7C4C1FFCFCDCCFFDEDEDBFFE8E8E7FFEAE9
      E8FFEEEEEDFF7C7A78FF010101160000000001010116406D97FF90B7D7FF4986
      BAFFB8B2ABFFFFFFFFFF018140FFFFFEFFFF018243FFFFFBFEFFFDF9F9FF9898
      98FFC1C1C0FFC0C0BFFFC0C0BFFFBFBFBEFFF9F9F8FF9B9B9BFFBEBDBCFFB7B5
      B2FFD1D0CEFFEAE9E8FFF3F2F2FFF4F2F2FFF4F2F2FFEBEAE9FFD4D4D1FFB7B5
      B3FF1010104D0101010100000000000000000000000000000000000000000000
      0000181716A2C3C0B8FFDDDBD6FFDCDAD4FFA19D97F510100F82000000000000
      001AA1A4A7F4EAEDF1FFEAEDF1FFEAEDF0FFEAEDF0FFEAEDF1FFE9EDF0FFE4E9
      ECFFE1E6EAFFE2E7EBFFE2E7EBFFE3E8ECFFE3E8ECFFE3E8ECFFC9CDD0FFE4E9
      EDFFE4E9EDFF909396EE00000014000000000000000000000000000000000000
      00000000000000000000483929A9997B58FF927455FF634C31FFBCB3A7FFE5E1
      E0FFF6F5F4FFEDE4DDFFDCDBD8FFDDDBD6FFE3E0DCFFE1DDDCFFE2E0DEFFDDDA
      DCFFB3B6BAFFA88B68FF644A1EFFCDC7C4FFDEDEE0FFE6E4E3FFF9F7F6FFF8F6
      F3FFE1E0E0F7030303190000000000000000010101167B7876FFEBEAE8FFC3C0
      BEFFC4C1BEFFC4C1BFFFC4C1BFFFC5C2C0FFC5C2C0FFC4C1BEFFEAE9E7FF7977
      75FF010101160000000000000000000000000000000000000000010101167977
      75FFEAE9E7FFC4C0BEFFC5C2C0FFC5C2C0FFC5C1BFFFC4C1BFFFC4C1BEFFC3C0
      BEFFEBEAE8FF7B7977FF010101160000000001010116406E98FF95BBDAFF4A88
      BDFFB7B1AAFFFFFFFFFFFDF5F7FFFFF6F8FFFFF9FDFF018140FFFDF7F8FFF6F6
      F5FFF5F5F4FFF5F5F4FFF4F4F3FFF4F4F3FFF4F4F3FFF6F6F5FFF6F7F6FFF3F2
      F2FFDBD9D8FFBAB6B2FFC2BCB7FFC4BDB7FFC4BEB9FFAAA8A4F1434241990101
      0103000000000000000000000000000000000000000000000000000000000000
      000033312EC7D9D7D1FFDEDCD7FFD2CFC8FF272624AD00000000000000000000
      001D5A6CA0FAA0B1E0FFA0B3E0FFA0B5E0FFA0B6DFFF9EB6DFFF9EB7DEFF9BB7
      DDFF88ABD6FF709DCEFF6B9CCCFF6CA0CCFF6DA3CCFF6FA7CCFF6BA3C3FF72AE
      CCFF73B2CCFF527F8EF700000014000000000000000000000000000000000000
      0000000000000A08063D967857FF997958FF8E7052FF72593DFFC3B8B0FFB2A7
      9DFFF3F0EEFFEEE6E0FFE1DFE0FFDFDDDDFFE0DEDDFFDBD9DBFFDCDBD9FFDDD8
      D7FFB6BCC3FFAA9581FF7C5B2DFF9F8F80FFF9F8F7FFE6E5E0FFE3E2E0FFEFED
      ECFFC5C2C2E5010101060000000000000000010101168A8886FFEBEAE8FFC1BD
      BBFFC2BFBDFFC2BFBDFFC3C0BEFFC3C0BEFFC3C0BEFFC6C4C2FFDBDBDAFF6F6C
      6AF30101011B01010103000000000000000000000000010101030101011B6F6C
      6AF3DBDBDAFFC9C7C5FFC3C0BEFFC3C0BEFFC3C0BEFFC2BFBDFFC2BFBDFFC1BE
      BCFFEBEBE9FF7D7A78FF0101011600000000010101163F6F99FF9BBFDCFF4B89
      BDFFB7B1AAFFFFFFFFFFF8F2F4FFFEF4F7FFFEF4F7FFFDF4F6FFF6F1F3FFF2F1
      F1FFF2F1F1FFF1F0F0FFF1F0F0FFF1F0F0FFF1F0F0FFF2F0F1FFF1F0F1FFF2F1
      F1FFFFFFFFFFB3B0AAFF4386BDFF91BADBFF2D6495FF01010116000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      001167645EEEE1DFDAFFE0DED9FFA19E98F80202013E00000000000000000000
      001E4E68BDFB8EABFBFF8FAEFBFF8FB1FBFF8DB3FBFF8CB5FBFF8BB7FBFF88B8
      FBFF86BAFAFF84BBFAFF6EB5F9FF57ADF8FF50AFF8FF52B5F8FF54BBF9FF56C1
      F9FF59C6F9FF4A90AFF900000014000000000000000000000000000000000000
      0000000000004F3F2EB8977857FF9A7A59FF7E6347FF6D5740FFDAD7D2FFEBE9
      E7FFF7F1F0FFE6DDD6FFDCDADBFFDEDBD9FFE2DFDBFFE4E1E0FFE4E1DFFFEEEB
      E8FFCBCBD2FFB1ADA5FF957449FF755F40FFF8F5F6FFECEBEBFFE8E5E4FFEDE9
      E8FF888686C1000000000000000000000000010101167E7C7AFFEBEBEAFFBEBB
      B9FFBFBBB9FFBFBCBAFFBFBCBAFFC1BEBCFFC1BDBBFFC0BCBAFFECEBEAFF7D7B
      79FF0101012F01010110010101030000000001010103010101100101012F7D7B
      79FFEBEBEAFFBFBCBAFFC0BDBBFFC1BEBCFFC0BCBAFFBFBCBAFFBFBBB9FFBEBB
      B9FFECEBEAFF7E7C7AFF010101160000000001010116406E98FFA2C4E1FF4B8B
      C1FFB7B1AAFFFFFFFFFFFFF4F8FF018343FFFFF6F9FFF8F2F3FFF2F1F0FFF2F2
      F1FFF2F2F1FFF1F1F0FFF0F1EFFFF1F2F0FFF2F2F1FFF1F1F0FFF0F0EFFFEEEE
      EDFFFFFFFFFFB6B0AAFF4A8BC1FFA0C3E1FF3A6B97FF01010116000000000000
      00000000000000000000000000000000000000000000000000170808076D1F1E
      1CB0A7A49BFFE3E1DCFFE1E0DBFF676561E70000000400000000000000000000
      001E516CBFFC94AFFBFF95B2FBFF94B4FBFF91B5FBFF8FB5FBFF8DB7FBFF89B8
      FBFF87BAFAFF85BCFAFF83BEFAFF80BFFAFF73BDF9FF67BCF9FF5DBDF8FF58BE
      F8FF56C1F8FF478DAEF900000014000000000000000000000000000000000000
      00000E0B084A977857FF977857FF997A58FF7C5F45FF846F58FFC1BAB6FFBEB7
      B1FFF9F5F2FFE6DED9FFE2E4E3FFE9E6E5FFE8E7E5FFEBEBEBFFE9E7E5FFF0F0
      EBFFCDCECEFFBEBFC4FFA78A69FF654821FFE0DCD9FFF5F4F4FFE5E1E3FFEDEC
      E9FF5656569C00000000000000000000000001010110817F7DFFF1F0EFFFEDEC
      EBFFEBEBEAFFEAE9E9FFCFCDCDFFBDBAB8FFBEBBB9FFBDBAB8FFDEDCDBFFA7A5
      A3FF292827A10101012F0101011B010101160101011B0101012F292827A1A7A5
      A3FFE0DEDEFFBDBAB8FFBEBBB9FFBDBAB8FFCDCBCAFFDFDFDDFFECEBEAFFEDEC
      EBFFF1F0EFFF817F7DFF0101011000000000010101163F6F99FFA8C8E3FF4C8C
      C2FFB8B1AAFFFFFFFFFF018141FFFFF6FBFF018445FFFFF3F6FFF6F1F1FF9A99
      9AFFBEBEBDFFBDBDBCFFF2F1F0FF9B9B9BFFBEBFBDFFBEBEBDFFBCBCBBFFEEED
      ECFFFFFFFFFFB6B0A9FF4C8CC2FFA8C8E3FF3E6E99FF01010116000000000000
      0000000000000000000000000000000000000B0B0A788A8883F2CCC9C4FFB6B3
      ABFFB6B2A9FFE4E2DFFFE3E1DDFF55534FDC0000000000000000000000000000
      001E536EBFFC97B1FBFF99B4FBFF96B5FBFF93B5FBFF90B6FBFF8DB7FBFF8AB7
      FBFF87B9FAFF84BBFAFF82BDFAFF81BEFAFF7CC0FAFF7AC2FAFF78C4FAFF74C6
      F9FF6DC5F9FF478AAFF900000014000000000000000000000000000000000101
      01025D4935C7977857FF977857FF967757FF684F37FF8D7A68FFF7F2F0FFFCFA
      F8FFFDF8F4FFF2EEECFFEFEEEDFFF1F0EFFFEEEEEAFFEDEDEAFFECEDEBFFEFEE
      EDFFD2D1D0FFBFC5CCFFA9967EFF79582CFFAB9D8FFFF8F7F7FFE3DFDFFFF2EF
      EEFF2B2B2B6F00000000000000000000000001010105757372F083817EFF817E
      7CFF7F7C7AFF9E9C9AFFE3E2E0FFBBB8B6FFBCB9B7FFBCB9B7FFC7C4C2FFE7E6
      E6FF93918FFF2A2929A40101014501010141010101452A2929A4858381FFE7E7
      E6FFC7C4C2FFBCB9B7FFBCB9B7FFBBB8B6FFE0DFDDFFADACAAFF7F7C7AFF817E
      7CFF83817EFF757372F00101010500000000010101163F709AFFAECDE6FF4D8E
      C5FFB7B0AAFFFFFFFFFFF6EDF0FFF9EFF2FFFFF1F6FF018242FFF7EFF1FFF0EE
      EFFFEFEDEEFFEEEDEDFFEEECEDFFEFEDEEFFEFEEEEFFEEEDEDFFEDECECFFEBEA
      EAFFFFFFFFFFB6B0A9FF4D8EC5FFAECDE6FF3F709AFF01010116000000000000
      0000000000000000000000000000000000000C0C0B7DD5D3CEFFEAE9E7FFC8C5
      BEFFA9A69DFFE6E4E1FFE4E3DFFF9B9891F70101003200000000000000000000
      001E415DB1FB6487F0FF668CF0FF668FF0FF6692F0FF6595EFFF6498EFFF649B
      EFFF629EEFFF63A1EFFF63A4EFFF61A8EFFF61AAEFFF60ACEEFF60AFEEFF5EB0
      EEFF5CB2EEFF427DA7F900000014000000000000000000000000000000000907
      063A977857FF977857FF987958FF927455FF6F553BFF9F9081FFCAC4C0FFDEDA
      D6FFFDF6F2FFE9E4E3FFE3E3DFFFEBE8E6FFEBE8E3FFEBE8E7FFEFEDEAFFEBE8
      E8FFE0DCDBFFC0C6C9FFC2BAB3FF94744AFF735C3EFFF0F0F1FFE1E1E2FFF5F2
      F1FF111111450000000000000000000000000000000000000000000000000101
      01040101011D817F7DFFE7E7E6FFBFBCB9FFBAB7B5FFBAB7B5FFB9B6B4FFCCCA
      C8FFE8E7E7FFA9A7A5FF817F7DFF757371F5817F7DFFA9A7A5FFE9E8E7FFCCCA
      C8FFB9B6B4FFBAB7B5FFBAB7B5FFBFBCB9FFE7E6E6FF807E7CFF0101011E0101
      010500000000000000000000000000000000010101163F719AFFB3D2E9FF4F90
      C8FFB6B0A9FFFFFFFFFFF0EBEBFFF6EEEFFFF6EEF0FFF5EDEFFFEFEBEBFFEBEB
      EAFFEAEAE9FFEAEAE9FFEAEAE9FFEAEBE9FFEAEBE9FFEAEAE9FFE9EAE8FFE8E8
      E7FFFFFFFFFFB6B0A9FF4F90C8FFB3D2E9FF3F719AFF01010116000000000000
      00000000000000000000000000000000000002020247ADABA3FED5D3CDFFC5C1
      BAFF98948AFFDEDCD7FFE7E5E2FFCDCBC3FF1816159600000000000000000000
      000504060A7005070C7305070C7305070C7306080C7314171DB572757AFF7A7D
      81FF7B8081FF474B51F306090D7F06090C7306090C7306090C7306090C730609
      0C7306090C7305080A6E00000002000000000000000000000000000000000000
      00000907053951402FBA9A7A58FF856B4DFF604832FFB2A699FFFBF9F9FFFDFB
      FBFFF7EEE9FFE2E2E0FFE6E7E4FFE9E4E3FFE4E5E3FFE6E4E4FFEAE6E5FFEAE6
      E4FFE5E2DFFFBDBBBBFFCFCFD0FFA68A6CFF674824FFDED6D0FFFFFFFFFFF7F4
      F3FD050505220000000000000000000000000000000000000000010101040101
      011501010135726F6EF0D3D1D0FFCECCCAFFB8B5B3FFB9B6B4FFB8B5B3FFB7B4
      B2FFC4C2C0FFE1DFDEFFF1F0EEFFE2E0E0FFF1F0EEFFE1DFDEFFC4C2C0FFB7B4
      B2FFB8B5B3FFB9B6B4FFB8B5B3FFCECDCAFFD3D1D0FF716F6DF0010101370101
      011601010104000000000000000000000000010101163F709BFFB8D5ECFF5091
      CAFFB7B0A9FFFFFFFFFFFAECEFFF018445FFFDEEF1FFF2EAECFFECE9E9FFEBEA
      E9FFEBEAE9FFEAE9E8FFEBEAE9FFEBEAE9FFEBEAE9FFEBEAE9FFEAE9E8FFE8E7
      E5FFFFFFFFFFB5B0A9FF5091CAFFB8D5ECFF3F709BFF01010116000000000000
      000000000000000000000000000000000000000000070B0B0A7E0A0A0A7A0908
      087520201DBFCCC9C3FFE8E7E4FFE6E5E1FF8B8881F006060658000000000000
      00000000000000000000000000000000000001010134595752D8C3C0B5FFC5C1
      B6FFC7C3B8FF343331C400000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000E0B08494C3D2CC16B5235FFB6ACA2FFBBB1A6FFF4F1
      EEFFFBF5EEFFFFFFFEFFFFFEFCFFFDFCFBFFFAF5F7FFF2F0F1FFECE6E5FFE6E4
      E3FFE1DFDDFFB4B3B2FFD5D6DAFFB5A289FF7C5E37FFA0927EFFFFFFFFFFD6D4
      D3EE0202020D00000000000000000000000000000000000000000101010D0101
      012F514E4DCEACAAA8FFE5E3E3FFB8B5B3FFB6B3B1FFB7B4B2FFB7B4B2FFB6B3
      B1FFB5B2B0FFB5B2AFFFB4B1AFFFC3C0BFFFB4B1AFFFB5B2AFFFB5B2B0FFB6B3
      B1FFB7B4B2FFB7B4B2FFB6B3B1FFB4B1AFFFE5E3E2FFBAB8B6FF5F5D5CDD0101
      012F0101010D0000000000000000000000000101011640719CFFBEDAEFFF5093
      CCFFB7B0A9FFFFFFFFFF018343FFFFEEF3FF018647FFF9EBEFFFEFEAEAFF9B9B
      9BFFBBBBBAFFEBE9E8FF9C9C9DFFBCBDBCFFBCBCBBFFBBBBBAFFBABAB9FFE6E5
      E4FFFFFFFFFFB5B0A8FF5093CCFFBEDAEFFF40719CFF01010116000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000002B65635DE9E4E2DFFFE9E8E5FFDFDDD8FF78766FE81312118D0000
      000C0000000000000000000000090908086A64615DDEC2BFB5FFC1BDB2FFC3BF
      B4FFB6B3A8FF595852DD0202023B000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000C0A084EBDBAB8EBF9F8F7FFFFFA
      FAFFF0E9E3FFE4E2E1FFECEBE8FFF1EFEDFFF8F4F4FFFDFBF8FFFFFEFDFFFFFE
      FEFFFFFEFDFFD7D4D5FFDFDFE2FFD8CFC2FF92754FFF7B6342FFF5F2F2FFA3A3
      A3D2000000000000000000000000000000000000000000000000010101114746
      45BF9A9896FFEFEEEDFFB9B6B4FFB3B0AEFFB4B1AFFFB4B1AFFFB4B1AFFFB4B1
      AFFFB4B1AFFFB4B1AFFFB4B1AFFFB4B1AFFFB4B1AFFFB4B1AFFFB4B1AFFFB4B1
      AFFFB4B1AFFFB4B1AFFFB4B1AFFFB3B0AEFFB5B2B0FFEEEEEDFFA8A6A4FF4745
      44BF01010111000000000000000000000000010101163F729BFFC4DDF1FF5194
      CEFFB6B0A9FFFFFFFFFFEDE6E7FFF0E7E9FFF8EBEEFF018545FFF0EAEBFFEAE9
      E8FFE8E8E7FFE7E7E6FFE8E9E8FFE9E9E8FFE8E8E7FFE7E7E6FFE6E6E5FFE3E3
      E2FFFFFFFFFFB5AFA8FF5194CEFFC4DDF1FF3F729BFF01010116000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000011111093ADA9A1FFE9E8E5FFEAE9E6FFE6E5E2FFC7C4BDFF6563
      5EE33C3A36C633322FBB5E5B56DFC1BEB6FFDDDBD5FFDFDDD8FFD3D1C9FFC2BE
      B3FFA7A59BFFC4C1B6FF615F59DC0202023F0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000202020E767676B4736F6EC1FEF9
      F7FFF7EFEBFFF3F1F0FFEEEAEAFFE9E6E3FFE1DEDAFFE7E2E3FFFDFBF9FFFCF9
      F8FFFFFDFCFFDFDCDCFFD7D5D5FFF3F0EEFFA18969FF795E3AFFE0DAD2FF6C6B
      6CAB000000000000000000000000000000000000000000000000010101098986
      84FEDBDAD9FFC8C6C4FFB0ADABFFB2AFADFFB2AFADFFB1AEACFFB0ADABFFB0AD
      ABFFB1AEACFFB2AFADFFB3B0AEFFB4B1AFFFB3B0AEFFB2AFADFFB1AEACFFB0AD
      ABFFB0ADABFFB1AEACFFB2AFADFFB2AFADFFB0ADABFFC8C5C3FFDBD9D8FF8A87
      85FF01010109000000000000000000000000010101163F739CFFCAE0F4FF5296
      CFFFB5B0A8FFFFFFFFFFE2E0DFFFE4E1E1FFEAE5E5FFF2EAEBFFEFEBEAFFECEA
      E9FFEBEAE9FFEBEAE8FFEBEAE9FFEBE9E8FFE8E7E6FFE5E3E2FFE2E0DFFFE0DF
      DEFFFFFFFFFFB5AFA8FF5296CFFFCAE0F4FF3F739CFF01010116000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000050504597C7870FCBDBAB1FFE8E7E4FFEAE9E7FFE9E8E5FFE8E6
      E3FFE3E1DDFFE0DED9FFE4E3DFFFE3E1DDFFE2E0DCFFDEDCD6FFC4C1B9FFA29E
      95FFCFCDC5FFD4D2CBFFCDCAC1FF2D2D2AC10000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000006060626DFDFDFF2F1F1F1F8FDF8
      F6FFFCF9F6FFFFFFFFFFFFFEFFFFFFFEFDFFFFFFFCFFFEFCFAFFFCFAF9FFFCFA
      F8FFFFFDFDFFE7E3E3FFCFCECBFFF8F7F6FFB9A78DFF836841FFB2A38FFF3D3D
      3E81000000000000000000000000000000000000000000000000010101021515
      1467AAA8A6FFEDEBEAFFBBB9B7FFAFACAAFFBBB9B7FFE3E1E0FFF0EFEDFFF4F3
      F2FFE3E1E0FFC9C8C6FFB2AFADFFB3B0AEFFB2AFADFFC9C7C5FFE2E1E0FFEFEF
      EDFFE7E5E4FFEBE9E8FFBBBAB7FFB0ACAAFFBBB9B7FFF0F0EEFFAAA8A6FF1515
      156601010102000000000000000000000000010101163F729DFFCFE5F7FF5497
      D2FFB8B1A9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8B8B8BFF8E8E8EFF8E8E
      8EFF8E8E8EFF8E8E8EFF8E8E8EFF8D8D8EFF8A8A8AFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFB8B1A9FF5497D2FFCFE5F7FF3F729DFF01010116000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000643433FCFDBD9D5FF9D9990FFA09B93FFD0CDC7FFE9E8E6FFEAE8
      E5FFE8E7E4FFE7E6E2FFE6E4E1FFE2E1DCFFD5D3CCFF8F8C84F621201FB91414
      12937E7C77E9D8D7D0FF7F7C76EA0202023A0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000012121247888889BE999A9ACAFDF9
      F5FFFDFBF9FFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFFFEFFFFFFFEFEFFFFFEFE
      FEFFFFFFFFFFF0EEEEFFD0D0CFFFF6F6F6FFD5CBBDFF8E724CFF8C7658FF1C1C
      1C59000000000000000000000000000000000000000000000000000000000101
      010573706FE8B2B0AEFFECEBEBFFC8C6C4FFF0EFEEFFB7B5B3FF908D8BFF8885
      83FFA9A6A4FFE3E2E1FFB1AEACFFB3B0AEFFB1AEACFFE3E1E0FFB5B3B1FF8F8B
      89FFA4A2A0FFB0AEACFFEAE9E8FFCDCBC8FFF0F0EFFFB2B0AEFF41403FB00101
      0104000000000000000000000000000000000101011540749DFFD6E8F8FF579A
      D3FF95AABAFFB5AFA8FFB2AEA8FFB2AFAAFF8C8B8AFFB3B3B1FFB4B4B2FFB5B5
      B3FFB5B5B3FFB5B5B3FFB5B5B3FFB4B4B2FFB3B3B1FF8C8B8AFFB2AFAAFFB2AE
      A8FFB5AFA8FF95AABAFF579AD3FFD6E8F8FF40749DFF01010115000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000E0E0D86D2CFCAFFF5F4F3FFEBEAE8FF737068EF2A2926C357544EE6A8A4
      9BFFC2BFB7FFC6C3BBFFB7B3ABFF9E9A91FF32312DCE04040461000000000000
      000000000028272624B20C0C0B73000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000050505253B3B3B81545454987877
      76B6A2A1A1D0C9C8C8E5EBEBEBF7FDFDFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFF7F7F8FFD2D5D5FFECEBECFFF9F7F6FFAB977EFF8B7D67FF0B0B
      0B43000000000000000000000000000000000000000000000000000000000000
      000001010105757270E8ADAAA9FFEBE9E8FFB3B1AFFF6F6E6CE4010101050101
      01168B8886FFE4E4E3FFB0ADABFFB2AFADFFB0ADABFFE3E2E1FFA4A2A0FF0101
      0117060606313C3B3BAA9F9D9BFFDDDCDCFFAEAAA9FF413F3FAF010101040000
      0000000000000000000000000000000000000101010D4477A0FFAFD2F1FFABCF
      EEFFA8CEEFFFA6CEF0FFA4CDF0FFA1CDF2FFACA9A6FFE7E5E4FFCBC7C6FFCBC7
      C7FFCBC7C7FFCBC8C7FFCBC8C7FFCBC8C7FFE7E6E4FFACA9A6FFA1CDF2FFA4CD
      F0FFA6CEF0FFA8CEEFFFABCFEEFFAFD2F1FF4477A0FF0101010D000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000040404535E5B57DEE7E6E3FF9C9993F40808076B000000000000000D0303
      035C2F2E2BC6A7A39AFFB7B4ADFFBEBAB1FF0707066A00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000010101010101010C0404041D0A0A0A341616164F2A2A2A6C575350A0C7BC
      AFF7C8C4BFECB5B5B6DCC1C1C1F3DBDBDBFDFFFFFFFFE6E6E8FFA3A4A5FF2727
      268B000000000000000000000000000000000000000000000000000000000000
      00000000000001010102141413608D8A88FC7C7978EC01010105000000000101
      01168E8B89FFE5E5E2FFAEABA9FFAFACAAFFAEABA8FFE3E3E1FFA7A4A2FF0101
      01160000000001010104474544B2918E8BFF1514146101010102000000000000
      00000000000000000000000000000000000001010104233D50B44579A1FF4377
      A0FF4277A0FF4277A0FF4076A0FF3A73A1FFB0ACA8FFD5D2D0FFD2D0CEFFCFCD
      CBFFCECCCAFFCDCBCAFFCCCAC9FFCECCCBFFD0CDCBFFB1ACA8FF3A73A1FF4076
      A0FF4277A0FF4277A0FF4377A0FF4579A1FF233D50B401010104000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000001D262422B8090909740000000000000000000000000000
      00000D0D0C7CD6D4CEFFECEBE8FFD3D1CAFF0909087400000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000504
      032A0505042901010102020202140707072D0F0F0F403434337BBCBEBBFF6464
      6CCF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000101
      0110908D8BFFFAF9F9FFF7F6F6FFEEEDECFFF7F6F5FFF9F8F7FFAAA7A6FF0101
      0110000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000101010DA5A5A5FFEBEB
      EBFFE9E9E9FFE9E9E9FFEBEBEBFFA5A6A6FF0101010D00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000002EA8A6A1FAE3E2DEFFC9C6BEFF0A0A097900000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000004B4565B9322B
      4BA4000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000101
      0105838180F0928F8DFF918D8BFF908D8BFF908D8BFF928F8DFF81807EF00101
      0105000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000001010104525353B3A8A8
      A8FFA7A7A7FFA7A7A7FFA8A8A8FF535353B30101010400000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000181716A21C1B199D0D0D0C7F0000001C00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000080000000E00000000100010000000000000E00000000000000000000
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
      000000000000}
  end
end
