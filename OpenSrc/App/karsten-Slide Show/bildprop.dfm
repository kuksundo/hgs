object BildEigenschaftenDlg: TBildEigenschaftenDlg
  Left = 559
  Top = 234
  HelpContext = 35
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Properties'
  ClientHeight = 481
  ClientWidth = 393
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    393
    481)
  PixelsPerInch = 96
  TextHeight = 13
  object LName: TLabel
    Left = 8
    Top = 8
    Width = 27
    Height = 13
    Caption = '&Name'
    FocusControl = EFName
  end
  object GBHaeufigkeit: TGroupBox
    Left = 8
    Top = 312
    Width = 377
    Height = 73
    Hint = 'Display frequency relative to the sum of all frequency values'
    HelpContext = 907
    Caption = '&Frequency'
    TabOrder = 5
    object LTBMinHaeufigkeit: TLabel
      Left = 16
      Top = 52
      Width = 6
      Height = 13
      Caption = '1'
    end
    object LTBMaxHaeufigkeit: TLabel
      Left = 169
      Top = 52
      Width = 32
      Height = 13
      Alignment = taRightJustify
      Caption = '10'#39'000'
    end
    object TBHaeufigkeit: TTrackBar
      Left = 8
      Top = 20
      Width = 193
      Height = 33
      LineSize = 10
      Max = 400
      PageSize = 100
      Frequency = 100
      Position = 200
      TabOrder = 0
      OnChange = TBHaeufigkeitChange
    end
    object UDHaeufigkeit: TUpDown
      Left = 289
      Top = 20
      Width = 13
      Height = 21
      Associate = EFHaeufigkeit
      TabOrder = 2
      Thousands = False
    end
    object EFHaeufigkeit: TEdit
      Left = 208
      Top = 20
      Width = 81
      Height = 21
      TabOrder = 1
      Text = '0'
      OnChange = EFHaeufigkeitChange
    end
  end
  object EFName: TEdit
    Left = 8
    Top = 24
    Width = 377
    Height = 21
    Hint = 'Name or Title of the Slide'
    HelpContext = 901
    AutoSize = False
    TabOrder = 0
    Text = 'EFName'
    OnChange = EFNameChange
  end
  object GBDateipfad: TGroupBox
    Left = 8
    Top = 56
    Width = 377
    Height = 49
    Hint = 'File path of the picture file'
    Caption = 'File &Path'
    TabOrder = 1
    object BDateipfad: TBitBtn
      Left = 288
      Top = 16
      Width = 75
      Height = 25
      Hint = 'Browse the file system'
      HelpContext = 9031
      Caption = '&Browse'
      TabOrder = 1
      OnClick = BDateipfadClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        555555FFFFFFFFFF55555000000000055555577777777775FFFF00B8B8B8B8B0
        0000775F5555555777770B0B8B8B8B8B0FF07F75F555555575F70FB0B8B8B8B8
        B0F07F575FFFFFFFF7F70BFB0000000000F07F557777777777570FBFBF0FFFFF
        FFF07F55557F5FFFFFF70BFBFB0F000000F07F55557F777777570FBFBF0FFFFF
        FFF075F5557F5FFFFFF750FBFB0F000000F0575FFF7F777777575700000FFFFF
        FFF05577777F5FF55FF75555550F00FF00005555557F775577775555550FFFFF
        0F055555557F55557F755555550FFFFF00555555557FFFFF7755555555000000
        0555555555777777755555555555555555555555555555555555}
      NumGlyphs = 2
    end
    object EFDateipfad: TEdit
      Left = 16
      Top = 18
      Width = 265
      Height = 21
      Hint = 'File path'
      HelpContext = 9021
      AutoSelect = False
      AutoSize = False
      TabOrder = 0
      Text = 'EFDateipfad'
      OnChange = EFDateipfadChange
    end
  end
  object GBWartezeit: TGroupBox
    Left = 8
    Top = 232
    Width = 377
    Height = 73
    Hint = 'Time to the next slide change'
    HelpContext = 906
    Caption = '&Display Time'
    TabOrder = 4
    object LWartezeitMin: TLabel
      Left = 264
      Top = 20
      Width = 20
      Height = 21
      AutoSize = False
      Caption = 'Min.'
      Layout = tlCenter
    end
    object LWartezeitSek: TLabel
      Left = 344
      Top = 20
      Width = 22
      Height = 21
      AutoSize = False
      Caption = 'Sec.'
      Layout = tlCenter
    end
    object LTBMinWartezeit: TLabel
      Left = 16
      Top = 52
      Width = 11
      Height = 13
      Caption = '1s'
    end
    object LTBMaxWartezeit: TLabel
      Left = 158
      Top = 52
      Width = 43
      Height = 13
      Alignment = taRightJustify
      Caption = '100'#39'000s'
    end
    object TBWartezeit: TTrackBar
      Left = 8
      Top = 20
      Width = 193
      Height = 33
      Ctl3D = True
      LineSize = 10
      Max = 500
      ParentCtl3D = False
      PageSize = 100
      Frequency = 100
      Position = 100
      TabOrder = 0
      OnChange = TBWartezeitChange
    end
    object UDWartezeitMin: TUpDown
      Left = 249
      Top = 20
      Width = 12
      Height = 21
      Associate = EFWartezeitMin
      Max = 1666
      TabOrder = 2
    end
    object EFWartezeitMin: TEdit
      Left = 208
      Top = 20
      Width = 41
      Height = 21
      TabOrder = 1
      Text = '0'
      OnChange = EFWartezeitChange
    end
    object EFWartezeitSek: TEdit
      Left = 288
      Top = 20
      Width = 41
      Height = 21
      TabOrder = 3
      Text = '0'
      OnChange = EFWartezeitChange
    end
    object UDWartezeitSek: TUpDown
      Left = 329
      Top = 20
      Width = 13
      Height = 21
      Associate = EFWartezeitSek
      Max = 60
      TabOrder = 4
      Thousands = False
    end
  end
  object BOk: TBitBtn
    Left = 8
    Top = 448
    Width = 97
    Height = 25
    HelpContext = 908
    Anchors = [akLeft, akBottom]
    Caption = '&OK'
    TabOrder = 7
    Kind = bkOK
    ExplicitTop = 392
  end
  object BAbbrechen: TBitBtn
    Left = 112
    Top = 448
    Width = 97
    Height = 25
    HelpContext = 909
    Anchors = [akLeft, akBottom]
    Caption = '&Cancel'
    TabOrder = 8
    Kind = bkCancel
    ExplicitTop = 392
  end
  object GBHintergrundfarbe: TGroupBox
    Left = 200
    Top = 112
    Width = 185
    Height = 113
    Hint = 'Color of the window background'
    HelpContext = 905
    Caption = '&Background Color'
    TabOrder = 3
    TabStop = True
    DesignSize = (
      185
      113)
    object CBHintergrundfarbe: TColorBox
      Left = 16
      Top = 48
      Width = 153
      Height = 22
      Hint = 'Color of the window background'
      DefaultColorColor = clGray
      NoneColorColor = clBtnFace
      Selected = clDefault
      Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeDefault, cbCustomColor, cbPrettyNames]
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 16
      TabOrder = 0
      OnChange = CBHintergrundfarbeChange
    end
  end
  object BHilfe: TBitBtn
    Left = 288
    Top = 448
    Width = 97
    Height = 25
    Hint = 'Open the help file'
    HelpContext = 35
    Anchors = [akRight, akBottom]
    TabOrder = 9
    Kind = bkHelp
    ExplicitTop = 392
  end
  object GBVergroesserung: TGroupBox
    Left = 8
    Top = 112
    Width = 185
    Height = 113
    Hint = 'Size and aspect of the picture during presentation'
    Caption = '&Zoom Mode'
    TabOrder = 2
    object RBBMNormal: TRadioButton
      Left = 16
      Top = 16
      Width = 161
      Height = 17
      Caption = 'Original Size'
      TabOrder = 0
      OnClick = RBBMClick
    end
    object RBBMIsoStrecken: TRadioButton
      Tag = 1
      Left = 16
      Top = 32
      Width = 161
      Height = 17
      Caption = 'Proportional Zoom'
      TabOrder = 1
      OnClick = RBBMClick
    end
    object RBBMAnisoStrecken: TRadioButton
      Tag = 2
      Left = 16
      Top = 64
      Width = 161
      Height = 17
      Caption = 'Unproportional Stretch'
      TabOrder = 3
      OnClick = RBBMClick
    end
    object RBBMIsoSpeziell: TRadioButton
      Tag = 3
      Left = 16
      Top = 82
      Width = 89
      Height = 17
      Caption = 'Explicit Factor:'
      TabOrder = 4
      OnClick = RBBMClick
    end
    object CBVergroesserung: TComboBox
      Tag = -1
      Left = 112
      Top = 80
      Width = 65
      Height = 21
      ItemHeight = 13
      MaxLength = 10
      TabOrder = 5
      Text = '100%'
      OnChange = CBVergroesserungChange
      Items.Strings = (
        '10%'
        '20%'
        '25%'
        '33%'
        '50%'
        '75%'
        '100%'
        '125%'
        '150%'
        '200%'
        '300%'
        '400%')
    end
    object RBBMIntegerStrecken: TRadioButton
      Tag = 4
      Left = 16
      Top = 48
      Width = 161
      Height = 17
      Caption = 'Integer Zoom Factor'
      TabOrder = 2
      OnClick = RBBMClick
    end
  end
  object GBSequenceNumber: TGroupBox
    Left = 8
    Top = 391
    Width = 377
    Height = 50
    Anchors = [akLeft, akTop, akRight]
    Caption = '&Sequence Number'
    TabOrder = 6
    object EFSequenceNumber: TJvSpinEdit
      Left = 16
      Top = 20
      Width = 94
      Height = 21
      BeepOnError = False
      ButtonKind = bkClassic
      MaxValue = 100000.000000000000000000
      MinValue = -100000.000000000000000000
      AutoSize = False
      TabOrder = 0
    end
  end
  object OpenPictureDialog: TOpenPictureDialog
    DefaultExt = 'bmp'
    Filter = 
      'All Image Files|*.jpg;*.jpeg;*.bmp;*.ico;*.emf;*.wmf;*.gif|Bitma' +
      'ps (*.bmp)|*.bmp|Metafiles (*.wmf;*.emf)|*.wmf;*.emf|JPEG Images' +
      ' (*.jpg;*.jpeg)|*.jpg;*.jpeg|GIF Images (*.gif)|*.gif|Icons (*.i' +
      'co)|*.ico'
    Options = [ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Browse for Picture File'
    Left = 360
  end
end
