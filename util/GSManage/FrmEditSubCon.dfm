object Form2: TForm2
  Left = 0
  Top = 0
  Caption = #54801#47141#49324' '#44288#47532
  ClientHeight = 580
  ClientWidth = 586
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 290
    Width = 586
    Height = 6
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 291
    ExplicitWidth = 643
  end
  object CurvyPanel1: TCurvyPanel
    AlignWithMargins = True
    Left = 0
    Top = 3
    Width = 586
    Height = 70
    Margins.Left = 0
    Margins.Right = 0
    Align = alTop
    Rounding = 4
    TabOrder = 0
    DesignSize = (
      586
      70)
    object JvLabel5: TJvLabel
      AlignWithMargins = True
      Left = 18
      Top = 9
      Width = 80
      Height = 25
      Alignment = taCenter
      AutoSize = False
      Caption = #54924#49324#51060#47492
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
    end
    object JvLabel6: TJvLabel
      AlignWithMargins = True
      Left = 18
      Top = 39
      Width = 80
      Height = 25
      Alignment = taCenter
      AutoSize = False
      Caption = #54924#49324#53076#46300
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
    end
    object btn_Close: TAeroButton
      AlignWithMargins = True
      Left = 521
      Top = 3
      Width = 62
      Height = 64
      ImageIndex = 0
      ImagePos = ipTop
      Version = '1.0.0.1'
      Align = alRight
      Caption = #45803#44592
      TabOrder = 0
    end
    object btn_Search: TAeroButton
      AlignWithMargins = True
      Left = 456
      Top = 3
      Width = 59
      Height = 64
      ImageIndex = 2
      ImagePos = ipTop
      Version = '1.0.0.1'
      Align = alRight
      Caption = #49325#51228
      TabOrder = 1
    end
    object et_msNumber: TEdit
      Left = 330
      Top = 97
      Width = 0
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      ImeName = 'Microsoft IME 2010'
      TabOrder = 2
    end
    object CompanyNameEdit: TEdit
      Left = 101
      Top = 12
      Width = 212
      Height = 21
      CharCase = ecUpperCase
      ImeName = 'Microsoft IME 2010'
      TabOrder = 3
    end
    object ComapnyCodeEdit: TEdit
      Left = 101
      Top = 39
      Width = 212
      Height = 21
      CharCase = ecUpperCase
      ImeName = 'Microsoft IME 2010'
      TabOrder = 4
    end
    object AeroButton1: TAeroButton
      AlignWithMargins = True
      Left = 326
      Top = 3
      Width = 59
      Height = 64
      ImageIndex = 2
      ImagePos = ipTop
      Version = '1.0.0.1'
      Align = alRight
      Caption = #51312#54924
      TabOrder = 5
      OnClick = AeroButton1Click
    end
    object AeroButton2: TAeroButton
      AlignWithMargins = True
      Left = 391
      Top = 3
      Width = 59
      Height = 64
      ImageIndex = 2
      ImagePos = ipTop
      Version = '1.0.0.1'
      Align = alRight
      Caption = #49688#51221
      TabOrder = 6
    end
  end
  object grid_SubCon: TNextGrid
    Left = 0
    Top = 76
    Width = 586
    Height = 214
    Touch.InteractiveGestures = [igPan, igPressAndTap]
    Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
    Align = alClient
    AppearanceOptions = [ao3DGridLines, aoAlphaBlendedSelection, aoBoldTextSelection, aoHideSelection]
    Caption = ''
    HeaderSize = 23
    HighlightedTextColor = clHotLight
    Options = [goHeader, goSelectFullRow]
    RowSize = 18
    TabOrder = 1
    TabStop = True
    OnCellDblClick = grid_SubConCellDblClick
    object NxIncrementColumn1: TNxIncrementColumn
      Alignment = taCenter
      DefaultWidth = 30
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      Header.Caption = 'No'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 0
      SortType = stAlphabetic
      Width = 30
    end
    object CompanyName: TNxTextColumn
      DefaultWidth = 200
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = #54924#49324#47749
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 1
      SortType = stAlphabetic
      Width = 200
    end
    object CompanyAddress: TNxTextColumn
      DefaultWidth = 200
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = #54924#49324#51452#49548
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 2
      SortType = stAlphabetic
      Width = 200
    end
    object CompanyCode: TNxTextColumn
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = #50629#52404#53076#46300
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 3
      SortType = stAlphabetic
    end
    object Email: TNxTextColumn
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'Email'
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 4
      SortType = stAlphabetic
      Visible = False
    end
    object MobilePhone: TNxTextColumn
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'Mobile'
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 5
      SortType = stAlphabetic
      Visible = False
    end
    object OfficePhone: TNxTextColumn
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'Office'
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 6
      SortType = stAlphabetic
      Visible = False
    end
    object Position: TNxTextColumn
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = #51649#50948
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 7
      SortType = stAlphabetic
      Visible = False
    end
    object ManagerName: TNxTextColumn
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = #45812#45817#51088
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 8
      SortType = stAlphabetic
      Visible = False
    end
    object Nation: TNxTextColumn
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = #44397#51201
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 9
      SortType = stAlphabetic
      Visible = False
    end
    object CompanyType: TNxTextColumn
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = #54924#49324#50976#54805
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 10
      SortType = stAlphabetic
      Visible = False
    end
    object ID: TNxTextColumn
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'ID'
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 11
      SortType = stAlphabetic
      Visible = False
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 296
    Width = 586
    Height = 284
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      586
      284)
    object JvLabel15: TJvLabel
      AlignWithMargins = True
      Left = 11
      Top = 4
      Width = 100
      Height = 25
      Alignment = taCenter
      AutoSize = False
      Caption = #54924#49324#51060#47492
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
    end
    object JvLabel16: TJvLabel
      AlignWithMargins = True
      Left = 11
      Top = 35
      Width = 100
      Height = 25
      Alignment = taCenter
      AutoSize = False
      Caption = #50629#52404#53076#46300
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
    end
    object JvLabel18: TJvLabel
      AlignWithMargins = True
      Left = 11
      Top = 66
      Width = 100
      Height = 25
      Alignment = taCenter
      AutoSize = False
      Caption = #45812#45817#51088
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
    end
    object JvLabel46: TJvLabel
      AlignWithMargins = True
      Left = 266
      Top = 67
      Width = 100
      Height = 25
      Alignment = taCenter
      AutoSize = False
      Caption = #51649#50948
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
    end
    object JvLabel23: TJvLabel
      AlignWithMargins = True
      Left = 8
      Top = 100
      Width = 100
      Height = 25
      Alignment = taCenter
      AutoSize = False
      Caption = #51060#47700#51068#51452#49548
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
    end
    object JvLabel43: TJvLabel
      AlignWithMargins = True
      Left = 266
      Top = 135
      Width = 100
      Height = 25
      Alignment = taCenter
      AutoSize = False
      Caption = 'Mobile(Fax)'
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
    end
    object JvLabel17: TJvLabel
      AlignWithMargins = True
      Left = 8
      Top = 166
      Width = 100
      Height = 25
      Alignment = taCenter
      AutoSize = False
      Caption = #54924#49324#51452#49548
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
    end
    object JvLabel42: TJvLabel
      AlignWithMargins = True
      Left = 8
      Top = 135
      Width = 100
      Height = 25
      Alignment = taCenter
      AutoSize = False
      Caption = #49324#47924#49892#51204#54868
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
    end
    object JvLabel1: TJvLabel
      AlignWithMargins = True
      Left = 266
      Top = 37
      Width = 100
      Height = 25
      Alignment = taCenter
      AutoSize = False
      Caption = #44397#51201
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
    end
    object SubCompanyEdit: TEdit
      Left = 114
      Top = 5
      Width = 444
      Height = 21
      Alignment = taCenter
      ImeName = 'Microsoft IME 2010'
      TabOrder = 0
    end
    object SubCompanyCodeEdit: TEdit
      Left = 114
      Top = 36
      Width = 146
      Height = 21
      Alignment = taCenter
      ImeName = 'Microsoft IME 2010'
      TabOrder = 1
    end
    object SubManagerEdit: TEdit
      Left = 114
      Top = 67
      Width = 146
      Height = 21
      Alignment = taCenter
      ImeName = 'Microsoft IME 2010'
      TabOrder = 2
    end
    object PositionEdit: TEdit
      Left = 371
      Top = 68
      Width = 187
      Height = 21
      Alignment = taCenter
      ImeName = 'Microsoft IME 2010'
      TabOrder = 3
    end
    object SubEmailEdit: TEdit
      Left = 114
      Top = 108
      Width = 375
      Height = 21
      Alignment = taCenter
      ImeName = 'Microsoft IME 2010'
      TabOrder = 4
    end
    object SubPhonNumEdit: TEdit
      Left = 114
      Top = 137
      Width = 146
      Height = 21
      Alignment = taCenter
      ImeName = 'Microsoft IME 2010'
      TabOrder = 5
    end
    object SubFaxEdit: TEdit
      Left = 372
      Top = 135
      Width = 146
      Height = 21
      Alignment = taCenter
      ImeName = 'Microsoft IME 2010'
      TabOrder = 6
    end
    object SubCompanyAddressMemo: TMemo
      Left = 114
      Top = 166
      Width = 463
      Height = 107
      Anchors = [akLeft, akTop, akBottom]
      BevelInner = bvNone
      BevelKind = bkFlat
      ImeMode = imSHanguel
      ImeName = 'Microsoft IME 2010'
      ScrollBars = ssVertical
      TabOrder = 7
    end
    object NationEdit: TEdit
      Left = 372
      Top = 38
      Width = 146
      Height = 21
      Alignment = taCenter
      ImeName = 'Microsoft IME 2010'
      TabOrder = 8
    end
  end
end
