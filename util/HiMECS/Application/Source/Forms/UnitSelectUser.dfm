object SelectUserF: TSelectUserF
  Left = 0
  Top = 0
  Caption = 'SelectUserF'
  ClientHeight = 533
  ClientWidth = 594
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object NxHeaderPanel1: TNxHeaderPanel
    AlignWithMargins = True
    Left = 346
    Top = 3
    Height = 482
    Align = alRight
    Caption = #48155#45716#49324#46988' :'
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -11
    HeaderFont.Name = 'Tahoma'
    HeaderFont.Style = []
    HeaderSize = 33
    ParentHeaderFont = False
    TabOrder = 0
    FullWidth = 245
    object UserGrid: TNextGrid
      AlignWithMargins = True
      Left = 3
      Top = 36
      Width = 237
      Height = 441
      Touch.InteractiveGestures = [igPan, igPressAndTap]
      Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
      Align = alClient
      AppearanceOptions = [aoAlphaBlendedSelection, aoHideSelection, aoHighlightSlideCells]
      Caption = ''
      HeaderSize = 23
      HighlightedTextColor = clHotLight
      Options = [goHeader, goSelectFullRow]
      RowSize = 18
      TabOrder = 0
      TabStop = True
      object NxIncrementColumn1: TNxIncrementColumn
        Alignment = taCenter
        DefaultWidth = 33
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Header.Caption = #49692
        Header.Alignment = taCenter
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        ParentFont = False
        Position = 0
        SortType = stAlphabetic
        Width = 33
      end
      object UserId2: TNxTextColumn
        Alignment = taCenter
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Header.Caption = #49324#48264
        Header.Alignment = taCenter
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        ParentFont = False
        Position = 1
        SortType = stAlphabetic
      end
      object UserName2: TNxTextColumn
        Alignment = taCenter
        DefaultWidth = 122
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Header.Caption = #49457#47749
        Header.Alignment = taCenter
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Options = [coAutoSize, coCanClick, coCanInput, coCanSort, coPublicUsing, coShowTextFitHint]
        ParentFont = False
        Position = 2
        SortType = stAlphabetic
        Width = 122
      end
    end
    object AdvGlowButton5: TAdvGlowButton
      Left = 170
      Top = 5
      Width = 70
      Height = 23
      Caption = #49440#53469#49325#51228
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = #45208#45588#44256#46357
      Font.Style = []
      ImageIndex = 1
      Images = ImageList1
      NotesFont.Charset = DEFAULT_CHARSET
      NotesFont.Color = clWindowText
      NotesFont.Height = -11
      NotesFont.Name = 'Tahoma'
      NotesFont.Style = []
      ParentFont = False
      TabOrder = 1
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
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 298
    Height = 488
    Align = alClient
    TabOrder = 1
    object empGrid: TNextGrid
      Left = 1
      Top = 74
      Width = 296
      Height = 413
      Touch.InteractiveGestures = [igPan, igPressAndTap]
      Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
      Align = alClient
      AppearanceOptions = [ao3DGridLines, aoAlphaBlendedSelection, aoHideSelection, aoHighlightSlideCells]
      Caption = ''
      HeaderSize = 23
      HighlightedTextColor = clHotLight
      Options = [goHeader, goSelectFullRow]
      RowSize = 23
      TabOrder = 0
      TabStop = True
      object NxIncrementColumn2: TNxIncrementColumn
        Alignment = taCenter
        DefaultWidth = 42
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = #47569#51008' '#44256#46357
        Font.Style = []
        Header.Caption = #49692
        Header.Alignment = taCenter
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        ParentFont = False
        Position = 0
        SortType = stAlphabetic
        Width = 42
      end
      object Checked: TNxCheckBoxColumn
        Alignment = taCenter
        DefaultWidth = 19
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = #47569#51008' '#44256#46357
        Font.Style = []
        Header.DisplayMode = dmImageOnly
        Header.Glyph.Data = {
          DE000000424DDE0000000000000076000000280000000C0000000D0000000100
          0400000000006800000000000000000000001000000010000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00AAAAAAAAAAAA
          000000000000000000000AAAAAAAAAA000000AAA0AAAAAA000000AA000AAAAA0
          00000A00000AAAA000000A00A000AAA000000A0AAA000AA000000AAAAAA000A0
          00000AAAAAAA00A000000AAAAAAAA0A000000AAAAAAAAAA00000000000000000
          0000}
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Options = [coCanClick, coCanInput, coPublicUsing]
        ParentFont = False
        Position = 1
        SortType = stBoolean
        Width = 19
      end
      object UserId: TNxTextColumn
        Alignment = taCenter
        DefaultWidth = 87
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = #47569#51008' '#44256#46357
        Font.Style = []
        Header.Caption = #49324#48264
        Header.Alignment = taCenter
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        ParentFont = False
        Position = 2
        SortType = stAlphabetic
        Width = 87
      end
      object UserName: TNxTextColumn
        Alignment = taCenter
        DefaultWidth = 78
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = #47569#51008' '#44256#46357
        Font.Style = []
        Header.Caption = #49457#47749
        Header.Alignment = taCenter
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Options = [coAutoSize, coCanClick, coCanInput, coCanSort, coPublicUsing, coShowTextFitHint]
        ParentFont = False
        Position = 3
        SortType = stAlphabetic
      end
      object UserGrade: TNxTextColumn
        Alignment = taCenter
        DefaultWidth = 66
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = #47569#51008' '#44256#46357
        Font.Style = []
        Header.Caption = #51649#44553
        Header.Alignment = taCenter
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        ParentFont = False
        Position = 4
        SortType = stAlphabetic
        Width = 66
      end
    end
    object AdvPanel1: TAdvPanel
      Left = 1
      Top = 1
      Width = 296
      Height = 73
      Align = alTop
      Color = clSilver
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      UseDockManager = True
      Version = '2.3.0.5'
      Caption.Color = clHighlight
      Caption.ColorTo = clNone
      Caption.Font.Charset = DEFAULT_CHARSET
      Caption.Font.Color = clWindowText
      Caption.Font.Height = -11
      Caption.Font.Name = 'Tahoma'
      Caption.Font.Style = []
      ColorTo = clWhite
      StatusBar.Font.Charset = DEFAULT_CHARSET
      StatusBar.Font.Color = clWindowText
      StatusBar.Font.Height = -11
      StatusBar.Font.Name = 'Tahoma'
      StatusBar.Font.Style = []
      Text = ''
      FullHeight = 48
      object Label13: TLabel
        AlignWithMargins = True
        Left = 10
        Top = 8
        Width = 39
        Height = 20
        Margins.Top = 5
        Caption = #48512#49436' :'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = #47569#51008' '#44256#46357
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label1: TLabel
        AlignWithMargins = True
        Left = 25
        Top = 36
        Width = 24
        Height = 20
        Margins.Top = 5
        Caption = #54016' :'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = #47569#51008' '#44256#46357
        Font.Style = [fsBold]
        ParentFont = False
      end
      object AeroButton3: TAeroButton
        AlignWithMargins = True
        Left = 251
        Top = 4
        Width = 44
        Height = 65
        Margins.Right = 0
        ImageIndex = 17
        ImagePos = ipTop
        Version = '1.0.0.1'
        Align = alRight
        Caption = #51312#54924
        TabOrder = 0
        OnClick = AeroButton3Click
      end
      object deptno: TComboBoxInc
        Left = 55
        Top = 9
        Width = 188
        Height = 21
        AutoComplete = False
        ImeName = 'Microsoft IME 2010'
        TabOrder = 1
        OnDropDown = deptnoDropDown
        OnSelect = deptnoSelect
      end
      object teamno: TComboBoxInc
        Left = 55
        Top = 36
        Width = 188
        Height = 21
        AutoComplete = False
        ImeName = 'Microsoft IME 2010'
        TabOrder = 2
        OnDropDown = teamnoDropDown
        OnSelect = teamnoSelect
      end
    end
  end
  object Panel3: TPanel
    Left = 298
    Top = 0
    Width = 45
    Height = 488
    Align = alRight
    TabOrder = 2
    object Button1: TButton
      Left = 3
      Top = 208
      Width = 38
      Height = 57
      Caption = '>>>'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 488
    Width = 594
    Height = 45
    Align = alBottom
    TabOrder = 3
    object AdvGlowButton3: TAdvGlowButton
      AlignWithMargins = True
      Left = 500
      Top = 4
      Width = 90
      Height = 37
      Align = alRight
      Caption = #52712#49548
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #45208#45588#44256#46357
      Font.Style = [fsBold]
      ImageIndex = 2
      ModalResult = 2
      NotesFont.Charset = DEFAULT_CHARSET
      NotesFont.Color = clWindowText
      NotesFont.Height = -11
      NotesFont.Name = 'Tahoma'
      NotesFont.Style = []
      ParentFont = False
      TabOrder = 0
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
    end
    object AdvGlowButton1: TAdvGlowButton
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 90
      Height = 37
      Align = alLeft
      Caption = #51200#51109
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #45208#45588#44256#46357
      Font.Style = [fsBold]
      ImageIndex = 2
      ModalResult = 1
      NotesFont.Charset = DEFAULT_CHARSET
      NotesFont.Color = clWindowText
      NotesFont.Height = -11
      NotesFont.Name = 'Tahoma'
      NotesFont.Style = []
      ParentFont = False
      TabOrder = 1
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
    end
  end
  object ImageList1: TImageList
    ColorDepth = cd32Bit
    Left = 64
    Top = 144
    Bitmap = {
      494C0101030008006C0010001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      000000000000000000000000000000000000000000000505052E101010521717
      17611D1D1D6C1F1D1E6D272425792523257825232578262425791F1E1E6E1E1E
      1E6E18181862111111530505052F000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000060000001300000009000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000030303240B0B0B420D0C
      0D482B332E8F4D9D6CF333B063FF27B35BFF27B35CFF3AB067FF4E8763E21C1F
      1D700F0E0E4C0B0B0B4203030324000000000000000000000000000000000000
      0000010103230D132E7D283B8BDB2F48AAF32A43A9F3213887DB0A122B7D0001
      0323000000000000000000000000000000000000000000000000000000000000
      000000000022060632AB0000046F000000130000000000000000000000000000
      0000000000010000001700000019000000090000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001041
      259827B662FF2BB665FF2EB666FF2DB466FF2EB566FF2EB666FF2AB665FF27B7
      62FF06180D5B0000000000000000000000000000000000000000000000000709
      15533544A0E63A50CCFF7378E8FF8E91EEFF8E91EEFF6F76E4FF314BC0FF223B
      94E6040713530000000000000000000000000000000000000003000000060000
      00060000014C0303FEFF0202B0F90F0F18C01212109B14141498191919991818
      189115151598211F1FB90F0E0E9E0000002F0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000186A3DBA2CBA
      6CFF2CBA6DFF2CBA6DFF27B868FF33BC71FF2CB96DFF2AB96BFF2CBA6DFF2CBA
      6DFF2BBA6CFF0823146B00000000000000000000000000000000080915534150
      B9F45A63E0FFA0A5F5FF7C85EFFF5961E9FF575BE7FF7B83EEFF9D9FF4FF4F5B
      D7FF2642A6F4040713530000000000000000000000000000015B0000037D0000
      02760000088E0000EAFD0000FFFF2F2FD8FFA7A7ACFFD7D7CFFFD5D5D5FFFAF9
      F9FFA4A4A4FFCABFBFFF534F4FC90000000E0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000927176F2BBE71FF2BBE
      71FF2BBE71FF27BC6EFF44C583FFFFFFFFFFFFFFFFFF1CB968FF2ABE70FF2BBE
      71FF2BBE71FF2BBF71FF00040225000000000000000001010322424CA7E55F69
      E3FFA0ABF5FF525DECFF4E5AEAFF4B57E9FF4C57E6FF4A54E6FF4E54E6FF9DA1
      F4FF525ED6FF213B93E500010322000000000000000000008CE30101DEFF0000
      DCFF0000E2FF0000F0FF0000F4FF0000FAFF2C2CCDFFB2B1B7FFCECFCBFFC6C6
      C6FF8D8E8EFFCABFBFFF474343C4000000100000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000028C275FB27C075FF27C0
      75FF27C075FF22BF71FF4FCD8FFFFFFFFFFFFFFFFFFF1EBE70FF26C073FF27C0
      75FF27C075FF27C075FF166B40B800000000000000001517337E4954DBFFA1AA
      F6FF5462F0FF5064EEFF4B57E9FF4B57E9FF4B57E9FF4B57E9FF4A56E6FF5058
      E6FF9EA2F5FF324EC3FF09112C7E0000000000000000080893E42D2DEAFF2424
      E7FF1B1BEBFF1414ECFF0F0FEEFF0707EEFF0303EFFF4445D4FFF2F2F1FFB1B1
      AFFF7B7C7CFFCABFBFFF484444C4000000100000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000020C074526C77AFF26C579FF1EC3
      74FF13C06DFF0EBF6AFF3FCA89FFFFFFFFFFFFFFFFFF0ABE69FF12BF6DFF13C0
      6EFF21C376FF26C579FF27CB7CFF000000000000000042479FDB808BEEFF7C90
      F7FF5B71F3FF4B57E9FF4B57E9FF4B57E9FF4B57E9FF4B57E9FF4B57E9FF4D59
      E9FF7982F0FF7379E2FF213688DB000000000000000011119BEB6868EEFF6666
      E9FF6868F2FF5959EEFF3C3CEBFF4242EDFF3434E9FF7B7AE8FFF2F2F1FF8988
      87FF686868FFCABFBFFF484444C4000000100000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000082D1D7A24C97DFF1CC778FF68D9
      A5FFF9FDFCFFEEFAF5FFF0FBF7FFFFFFFFFFFFFFFFFFECFAF4FFEFFBF5FFF8FD
      FBFF3FCF8FFF1FC77AFF24CD80FF0005033100000000575BCAF6A0AAF7FF6E85
      F8FF6681F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4B57
      E9FF5A64EAFF959BF1FF2D49ADF60000000000000000020256B3121293D01111
      96D0141493D92E2EDBFE5F5FECFF4444E8FF7878DDFFF1F1EBFFAAABA9FF6465
      64FF4E4F4FFFCABFBFFF494545C4000000100000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000A38248721CC81FF16C97AFF9CE7
      C6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF66DAA7FF1ACA7CFF24CF85FF0109063F000000005C60CBF6AEB8F9FF7D92
      FAFF6E84F0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4B57
      E9FF5C68EEFF959CF1FF3148AFF6000000000000000000000000000000000000
      0000000000282B2BCEFD5657E4FF6565CBFFEDECE8FFF0F0EDFFB6B7B7FFFFFF
      FFFF393A3AFFCABFBFFF4B4646C4000000100000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000008291B721ECE84FF1DCE83FF2DD1
      8BFF81E3B9FF76E1B5FF92E7C3FFFFFFFFFFFFFFFFFF74E0B3FF78E1B6FF7CE2
      B8FF1ECE84FF1DCE83FF2CD58DFF0004022A000000004B4CA4DBA4AEF5FF9CAA
      FAFF758BF0FF525DECFF525DECFF525DECFF525DECFF525DECFF525DECFF6175
      F2FF808DF4FF767DE9FF293B8DDB000000000000000000000000000000000000
      0000000000201414B7F2615DBCFF898987FFEFEFEDFFF2F2F2FFF2F2F1FF3635
      35FF2F2F2FFFCABFBFFF4B4646C4000000100000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000107043532DA94FF1DD086FF1CD0
      86FF15CE82FF10CD7EFF3FD799FFFFFFFFFFFFFFFFFF0CCC7DFF14CE82FF16CE
      82FF1DD087FF1CCF86FF34DE97FF00000000000000001919367E7B82EAFFCDD4
      FCFF8A9CFAFF7C92F7FF7389EEFF6A83F6FF6A83F6FF6A83F6FF6A83F6FF6177
      F3FFA3AEF8FF3C4DD0FF0E142E7E000000000000000000000000000000000000
      0000000000051A192DABC2B8BBFF8A8A87FFEAEAEBFFF2F2F1FFF2F2F1FF2424
      24FF1C1D1DFFCABFBFFF4B4747C4000000100000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000037C289EA17D288FF1CD4
      8BFF1CD48BFF17D288FF49DCA1FFFFFFFFFFFFFFFFFF14D286FF1BD38AFF1CD4
      8BFF1BD48AFF1ED38CFF185A3E9E0000000000000000010103225453B4E5A2A6
      F3FFD4DBFDFF8699FAFF7D90F0FF788DF1FF7D93F8FF7C91F9FF748BF8FFA7B5
      F8FF616CE3FF3644A1E501010322000000000000000000000000000000000000
      0000000000001C1A1798CCC2C0FF7D7D7DFFD6D7D6FFDEDDDEFFDEDDDEFF0707
      07FF070808FFCABFBFFF4B4747C4000000100000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000003120C4841DF9EFF15D4
      8BFF1CD68EFF1AD58CFF1FD68EFFC7F4E2FFB5F0D9FF0ED386FF1BD68EFF1BD6
      8EFF13D38AFF50E5A6FF0000000C0000000000000000000000000B0B17535F5F
      CCF4A9ACF2FFD8DCFDFFADB9FAFF90A2FAFF8A9CFAFF9BA8FBFFB9C7FCFF6E79
      E9FF4451BAF40709155300000000000000000000000000000000000000000000
      0000000000011C1B1B9BCDC3C3FF5B5A5AFF646363FF686767FF686767FF0F0F
      0FFF0E0E0EFFCABFBFFF4C4848C4000000100000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000F402D8347E0
      A3FF12D48CFF17D58EFF19D68EFF0CD488FF0DD488FF19D68FFF16D58EFF14D5
      8DFF58E6ABFF020C083B00000000000000000000000000000000000000000B0B
      17535555B5E68D92EDFFBDC2F8FFCCD3F9FFC3CBF9FFA9B3F4FF646EE2FF424B
      AAE6080915530000000000000000000000000000000000000000000000000000
      000000000000201F1F9BFFFCFCFFF1ECECFFF2EDEDFFF2EEEEFFF0ECECFFF0EA
      EAFFECE6E6FFFAF2F2FF535151C80000000C0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000621
      175F5AECAFFF41E1A1FF12D78EFF14D78FFF14D78FFF19D891FF4DE4A7FF48C2
      90E60006042A0000000000000000000000000000000000000000000000000000
      0000020204231918357D4B4CA3DB5859C8F35659C6F343479FDB1517337D0101
      0323000000000000000000000000000000000000000000000000000000000000
      0000000000030101014808080864080808640808086408080864080808640808
      08640807076408070764030303570000000C0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000020623186626694DAD34906ACA328B66C61E59419F02130D4C0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
end
