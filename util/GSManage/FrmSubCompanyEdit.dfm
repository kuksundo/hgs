object SubCompanyEditF: TSubCompanyEditF
  Left = 0
  Top = 0
  Caption = 'Sub-Company Edit'
  ClientHeight = 844
  ClientWidth = 937
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 417
    Width = 937
    Height = 5
    Cursor = crVSplit
    Align = alTop
    ExplicitTop = 481
    ExplicitWidth = 615
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 937
    Height = 49
    Align = alTop
    TabOrder = 0
    object AeroButton1: TAeroButton
      AlignWithMargins = True
      Left = 788
      Top = 4
      Width = 75
      Height = 41
      ImagePos = ipTop
      Version = '1.0.0.1'
      Align = alRight
      Caption = #51200#51109
      ModalResult = 1
      TabOrder = 0
    end
    object btn_Close: TAeroButton
      AlignWithMargins = True
      Left = 869
      Top = 4
      Width = 64
      Height = 41
      ImageIndex = 0
      ImagePos = ipTop
      Version = '1.0.0.1'
      Align = alRight
      Caption = #45803#44592
      ModalResult = 8
      TabOrder = 1
      OnClick = btn_CloseClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 422
    Width = 937
    Height = 422
    Align = alClient
    TabOrder = 1
    object Panel4: TPanel
      Left = 1
      Top = 1
      Width = 935
      Height = 41
      Align = alTop
      TabOrder = 0
      object JvLabel61: TJvLabel
        AlignWithMargins = True
        Left = 644
        Top = 9
        Width = 100
        Height = 25
        Alignment = taCenter
        AutoSize = False
        Caption = 'Currency'
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
      object JvLabel59: TJvLabel
        AlignWithMargins = True
        Left = 13
        Top = 8
        Width = 100
        Height = 25
        Alignment = taCenter
        AutoSize = False
        Caption = 'Billing Amount'
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
      object CurrencyKindCB: TComboBox
        Left = 748
        Top = 10
        Width = 179
        Height = 21
        Style = csDropDownList
        ImeName = 'Microsoft IME 2010'
        TabOrder = 0
      end
      object SalesPriceEdit: TJvCalcEdit
        Left = 117
        Top = 9
        Width = 181
        Height = 21
        ImeName = 'Microsoft IME 2010'
        HideSelection = False
        TabOrder = 1
        DecimalPlacesAlwaysShown = False
      end
    end
    object InvoiceGrid: TNextGrid
      Left = 1
      Top = 42
      Width = 935
      Height = 379
      Margins.Left = 40
      Margins.Top = 0
      Touch.InteractiveGestures = [igPan, igPressAndTap]
      Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
      Align = alClient
      Caption = ''
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      HeaderSize = 65
      Options = [goGrid, goHeader, goSelectFullRow]
      RowSize = 20
      ParentFont = False
      SelectionColor = 12615680
      TabOrder = 1
      TabStop = True
      object NxIncrementColumn1: TNxIncrementColumn
        Alignment = taCenter
        DefaultWidth = 32
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
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
        Width = 32
      end
      object ItemType: TNxComboBoxColumn
        DefaultWidth = 250
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        Header.Caption = 'Items'
        Header.Alignment = taCenter
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Options = [coCanClick, coCanInput, coCanSort, coEditing, coPublicUsing, coShowTextFitHint]
        ParentFont = False
        Position = 1
        SortType = stAlphabetic
        Width = 250
        Items.Strings = (
          'Work(Weekday-Normal)'
          'Work(Weekday-OverTime)'
          'Work(Holiday-Normal)'
          'Work(Holiday-OverTime)'
          'Trevelling Hours'
          'Materials'
          'Ex(Airfare)'
          'Ex(Accommodation)'
          'Ex(Transportation)'
          'Ex(Meal)'
          'Ex(Etc)')
      end
      object ItemDesc: TNxTextColumn
        Alignment = taCenter
        DefaultWidth = 150
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        Header.Caption = 'Num of Workers'#13#10'          or'#13#10'    Item Desc'
        Header.Alignment = taCenter
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.MultiLine = True
        Options = [coCanClick, coCanInput, coCanSort, coEditing, coPublicUsing, coShowTextFitHint]
        ParentFont = False
        Position = 2
        SortType = stAlphabetic
        Width = 150
      end
      object Qty: TNxTextColumn
        Alignment = taCenter
        DefaultWidth = 50
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        Header.Caption = 'Qty'
        Header.Alignment = taCenter
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Options = [coCanClick, coCanInput, coCanSort, coEditing, coPublicUsing, coShowTextFitHint]
        ParentFont = False
        Position = 3
        SortType = stAlphabetic
        Width = 50
      end
      object AUnit: TNxTextColumn
        Alignment = taCenter
        DefaultWidth = 50
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        Header.Caption = 'Unit'
        Header.Alignment = taCenter
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Options = [coCanClick, coCanInput, coCanSort, coEditing, coPublicUsing, coShowTextFitHint]
        ParentFont = False
        Position = 4
        SortType = stAlphabetic
        Width = 50
      end
      object UnitPrice: TNxTextColumn
        Alignment = taCenter
        DefaultWidth = 100
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        Header.Caption = 'Unit Price'
        Header.Alignment = taCenter
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Options = [coCanClick, coCanInput, coCanSort, coEditing, coPublicUsing, coShowTextFitHint]
        ParentFont = False
        Position = 5
        SortType = stAlphabetic
        Width = 100
      end
      object ExchangeRate: TNxTextColumn
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        Header.Caption = 'Exch.'#13#10'Rate'
        Header.Alignment = taCenter
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.MultiLine = True
        ParentFont = False
        Position = 6
        SortType = stAlphabetic
      end
      object TotalPrice: TNxButtonColumn
        Alignment = taCenter
        DefaultWidth = 100
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        Header.Caption = 'Total Price'
        Header.Alignment = taCenter
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Options = [coCanClick, coCanInput, coCanSort, coEditing, coPublicUsing, coShowTextFitHint]
        ParentFont = False
        Position = 7
        SortType = stAlphabetic
        Width = 100
        ButtonCaption = '->'
      end
      object Attachments: TNxButtonColumn
        Alignment = taCenter
        DefaultWidth = 110
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        Header.Caption = 'Attachments'
        Header.Alignment = taCenter
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Options = [coCanClick, coCanInput, coCanSort, coEditing, coPublicUsing, coShowTextFitHint]
        ParentFont = False
        Position = 8
        SortType = stAlphabetic
        Width = 110
        OnButtonClick = AttachmentsButtonClick
      end
      object EngineerKind: TNxTextColumn
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
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
      object UniqueItemID: TNxTextColumn
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Position = 10
        SortType = stAlphabetic
        Visible = False
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 49
    Width = 937
    Height = 368
    Align = alTop
    TabOrder = 2
    object JvLabel15: TJvLabel
      AlignWithMargins = True
      Left = 8
      Top = 7
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
      Left = 8
      Top = 38
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
    object JvLabel48: TJvLabel
      AlignWithMargins = True
      Left = 538
      Top = 283
      Width = 100
      Height = 25
      Alignment = taCenter
      AutoSize = False
      Caption = 'Service P.O.'
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
      Left = 8
      Top = 130
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
      Top = 131
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
    object JvLabel19: TJvLabel
      AlignWithMargins = True
      Left = 8
      Top = 161
      Width = 100
      Height = 25
      Alignment = taCenter
      AutoSize = False
      Caption = 'S/E'
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
    object Label1: TLabel
      Left = 496
      Top = 165
      Width = 94
      Height = 13
      Caption = #44396#48516#51088' : '#49464#48120#53084#47200
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object JvLabel35: TJvLabel
      AlignWithMargins = True
      Left = 8
      Top = 189
      Width = 100
      Height = 25
      Alignment = taCenter
      AutoSize = False
      Caption = #48169#49440#51064#50896#49688
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
    object JvLabel54: TJvLabel
      AlignWithMargins = True
      Left = 187
      Top = 190
      Width = 100
      Height = 25
      Alignment = taCenter
      AutoSize = False
      Caption = #44204#51201#44552#50529
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
    object JvLabel53: TJvLabel
      AlignWithMargins = True
      Left = 8
      Top = 221
      Width = 136
      Height = 25
      Alignment = taCenter
      AutoSize = False
      Caption = 'Service Report '#51217#49688#51068
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
    object JvLabel52: TJvLabel
      AlignWithMargins = True
      Left = 266
      Top = 221
      Width = 136
      Height = 25
      Alignment = taCenter
      AutoSize = False
      Caption = #54801#47141#49324' Invoice '#48156#54665#51068
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
      Top = 251
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
    object JvLabel68: TJvLabel
      AlignWithMargins = True
      Left = 281
      Top = 250
      Width = 100
      Height = 25
      Alignment = taCenter
      AutoSize = False
      Caption = #44397#44032
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
      Top = 282
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
    object JvLabel43: TJvLabel
      AlignWithMargins = True
      Left = 283
      Top = 282
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
      Left = 596
      Top = 7
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
    object JvLabel36: TJvLabel
      AlignWithMargins = True
      Left = 10
      Top = 311
      Width = 100
      Height = 25
      Alignment = taCenter
      AutoSize = False
      Caption = #51089#50629#49884#51089#51068
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
    object Label2: TLabel
      Left = 213
      Top = 319
      Width = 8
      Height = 13
      Caption = '~'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object JvLabel37: TJvLabel
      AlignWithMargins = True
      Left = 230
      Top = 312
      Width = 100
      Height = 25
      Alignment = taCenter
      AutoSize = False
      Caption = #51089#50629#51333#47308#51068
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
      Left = 431
      Top = 314
      Width = 122
      Height = 25
      Alignment = taCenter
      AutoSize = False
      Caption = #54801#47141#49324' Invoice No.'
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
    object JvLabel2: TJvLabel
      AlignWithMargins = True
      Left = 266
      Top = 40
      Width = 100
      Height = 25
      Alignment = taCenter
      AutoSize = False
      Caption = #49324#50629#50689#50669
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
    object JvLabel3: TJvLabel
      AlignWithMargins = True
      Left = 8
      Top = 100
      Width = 100
      Height = 25
      Alignment = taCenter
      AutoSize = False
      Caption = #52712#44553#51228#54408
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
    object JvLabel4: TJvLabel
      AlignWithMargins = True
      Left = 8
      Top = 69
      Width = 100
      Height = 25
      Alignment = taCenter
      AutoSize = False
      Caption = #54924#49324#44396#48516
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
    object SubCompanyEdit: TAdvEditBtn
      Left = 114
      Top = 10
      Width = 385
      Height = 21
      EmptyTextStyle = []
      Flat = False
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
      ImeName = 'Microsoft IME 2010'
      ReadOnly = False
      TabOrder = 0
      Text = ''
      Visible = True
      Version = '1.3.5.0'
      ButtonStyle = bsButton
      ButtonWidth = 20
      Etched = False
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        1800000000000003000000000000000000000000000000000000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FF4D74AB234179C5ABA7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFF4173AF008EEC009AF41F4B80FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFF2F6EB22BA7
        F516C0FF00A0F3568BC3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFEFFFF2974BB68C4F86BD4FF279CE66696C8FFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3D8FD5A4E3FEB5EEFF4CAA
        E7669DD2FFFFFFFFFFFFFFFFFFFFFFFFFEFEFEA188898A6A6A93736E866567B0
        9595BAA8B1359EE8BDF5FF77C4EF63A1DAFFFFFFFFFFFFFFFFFFFFFFFFD7CDCD
        7E5857DFD3CBFFFFF7FFFFE7FFFEDBD6BB9E90584D817B8E1794E46BB5E9FFFF
        FFFFFFFFFFFFFFFFFFFFEDE9E9886565FFFFFFFFFFFFFDF8E8FAF2DCF8EDCFFF
        F1CFF6DEBA9F5945C0C7D5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA38889F6EFEA
        FFFFFFFEFBF5FBF7E8F9F4DAF5EBCCE6CEACF3DAB8E2BD99AB8B8EFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFF937674FFFFFFFDFBF1FCF8EEFAF3E1FCF5E3F7F0D7F0
        DFC1E7C9A9F0D1ABA87E75F8F6F6FFFFFFFFFFFFFFFFFFFFFFFF997D7AFFFFFC
        F9F2E1FAF3DEFAF7E5FAF1DCF1DFC0EDD9BAECD8B9EDCAA5AF8679EDE8E9FFFF
        FFFFFFFFFFFFFFFFFFFF9C807BFFFFEBF9EED5FAF1D7F9F2DAF2E3C6FEFBF9FF
        FFF0EFDFC0E9C69EB0857BF5F2F3FFFFFFFFFFFFFFFFFFFFFFFFAF9596F7EAC8
        F9EBCCEFDCBEF4E4C7F0E1C5FDFCECFAF5DDEFDCBCDFB087B59A9AFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFDED4D7BA998CFDECC4EDD4B0E5CAA8EFDBBFF2E3C4F2
        DEBCEABF93BB8E7DE7DFE2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCEBFC5
        BE9A8DE6C7A5EFCBA3ECC8A2E8BE94DCAA86BE9585DFD6D7FFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE9E4E6C9B3B4B99C93C3A097BF9F96CC
        B9B7F1EEEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
      OnClickBtn = SubCompanyEditClickBtn
    end
    object Button4: TButton
      Left = 505
      Top = 7
      Width = 85
      Height = 28
      Caption = 'Save Master'
      TabOrder = 1
      OnClick = Button4Click
    end
    object SubCompanyCodeEdit: TEdit
      Left = 114
      Top = 40
      Width = 146
      Height = 21
      Alignment = taCenter
      ImeName = 'Microsoft IME 2010'
      TabOrder = 2
    end
    object ServicePOEdit: TEdit
      Left = 644
      Top = 284
      Width = 186
      Height = 21
      Alignment = taCenter
      ImeName = 'Microsoft IME 2010'
      TabOrder = 3
    end
    object SubManagerEdit: TEdit
      Left = 114
      Top = 131
      Width = 146
      Height = 21
      Alignment = taCenter
      ImeName = 'Microsoft IME 2010'
      TabOrder = 4
    end
    object PositionEdit: TEdit
      Left = 372
      Top = 131
      Width = 187
      Height = 21
      Alignment = taCenter
      ImeName = 'Microsoft IME 2010'
      TabOrder = 5
    end
    object SEEdit: TEdit
      Left = 114
      Top = 162
      Width = 375
      Height = 21
      Alignment = taCenter
      ImeName = 'Microsoft IME 2010'
      TabOrder = 6
    end
    object SECountEdit: TEdit
      Left = 114
      Top = 190
      Width = 47
      Height = 21
      Alignment = taCenter
      ImeName = 'Microsoft IME 2010'
      TabOrder = 7
    end
    object SubConPriceEdit: TEdit
      Left = 290
      Top = 191
      Width = 199
      Height = 21
      Alignment = taCenter
      ImeName = 'Microsoft IME 2010'
      TabOrder = 8
    end
    object SRRecvDatePicker: TDateTimePicker
      Left = 153
      Top = 221
      Width = 89
      Height = 24
      Date = 42843.827708518520000000
      Time = 42843.827708518520000000
      ImeName = 'Microsoft IME 2010'
      TabOrder = 9
    end
    object SubConInvoiceIssuePicker: TDateTimePicker
      Left = 408
      Top = 221
      Width = 89
      Height = 24
      Date = 42843.827708518520000000
      Time = 42843.827708518520000000
      ImeName = 'Microsoft IME 2010'
      TabOrder = 10
    end
    object SubEmailEdit: TEdit
      Left = 114
      Top = 252
      Width = 163
      Height = 21
      Alignment = taCenter
      ImeName = 'Microsoft IME 2010'
      TabOrder = 11
    end
    object SubConNationEdit: TEdit
      Left = 387
      Top = 251
      Width = 146
      Height = 21
      Alignment = taCenter
      ImeName = 'Microsoft IME 2010'
      TabOrder = 12
    end
    object SubPhonNumEdit: TEdit
      Left = 114
      Top = 283
      Width = 146
      Height = 21
      Alignment = taCenter
      ImeName = 'Microsoft IME 2010'
      TabOrder = 13
    end
    object SubFaxEdit: TEdit
      Left = 386
      Top = 283
      Width = 146
      Height = 21
      Alignment = taCenter
      ImeName = 'Microsoft IME 2010'
      TabOrder = 14
    end
    object SubCompanyAddressMemo: TMemo
      Left = 596
      Top = 41
      Width = 337
      Height = 203
      BevelInner = bvNone
      BevelKind = bkFlat
      ImeMode = imSHanguel
      ImeName = 'Microsoft IME 2010'
      ScrollBars = ssVertical
      TabOrder = 15
    end
    object WorkBeginPicker: TDateTimePicker
      Left = 114
      Top = 313
      Width = 89
      Height = 24
      Date = 42843.827708518520000000
      Time = 42843.827708518520000000
      ImeName = 'Microsoft IME 2010'
      TabOrder = 16
    end
    object WorkEndPicker: TDateTimePicker
      Left = 336
      Top = 312
      Width = 89
      Height = 24
      Date = 42843.827708518520000000
      Time = 42843.827708518520000000
      ImeName = 'Microsoft IME 2010'
      TabOrder = 17
    end
    object SubConInvoiceNoEdit: TEdit
      Left = 559
      Top = 315
      Width = 186
      Height = 21
      Alignment = taCenter
      ImeName = 'Microsoft IME 2010'
      TabOrder = 18
    end
    object UniqueSubConIDEdit: TEdit
      Left = 596
      Top = 250
      Width = 186
      Height = 21
      Alignment = taCenter
      ImeName = 'Microsoft IME 2010'
      TabOrder = 19
      Visible = False
    end
    object BusinessAreaGrp: TAdvOfficeCheckGroup
      Left = 372
      Top = 32
      Width = 189
      Height = 35
      Version = '1.3.8.5'
      ParentBackground = False
      TabOrder = 20
      Columns = 3
      Items.Strings = (
        #51312#49440
        #50644#51652
        #51204#51204)
      Ellipsis = False
    end
    object ProductTypesEdit: TAdvEditBtn
      Left = 114
      Top = 104
      Width = 445
      Height = 21
      EmptyTextStyle = []
      Flat = False
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
      ImeName = 'Microsoft IME 2010'
      ReadOnly = False
      TabOrder = 21
      Text = ''
      Visible = True
      Version = '1.3.5.0'
      ButtonStyle = bsButton
      ButtonWidth = 20
      Etched = False
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        1800000000000003000000000000000000000000000000000000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FF4D74AB234179C5ABA7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFF4173AF008EEC009AF41F4B80FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFF2F6EB22BA7
        F516C0FF00A0F3568BC3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFEFFFF2974BB68C4F86BD4FF279CE66696C8FFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3D8FD5A4E3FEB5EEFF4CAA
        E7669DD2FFFFFFFFFFFFFFFFFFFFFFFFFEFEFEA188898A6A6A93736E866567B0
        9595BAA8B1359EE8BDF5FF77C4EF63A1DAFFFFFFFFFFFFFFFFFFFFFFFFD7CDCD
        7E5857DFD3CBFFFFF7FFFFE7FFFEDBD6BB9E90584D817B8E1794E46BB5E9FFFF
        FFFFFFFFFFFFFFFFFFFFEDE9E9886565FFFFFFFFFFFFFDF8E8FAF2DCF8EDCFFF
        F1CFF6DEBA9F5945C0C7D5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA38889F6EFEA
        FFFFFFFEFBF5FBF7E8F9F4DAF5EBCCE6CEACF3DAB8E2BD99AB8B8EFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFF937674FFFFFFFDFBF1FCF8EEFAF3E1FCF5E3F7F0D7F0
        DFC1E7C9A9F0D1ABA87E75F8F6F6FFFFFFFFFFFFFFFFFFFFFFFF997D7AFFFFFC
        F9F2E1FAF3DEFAF7E5FAF1DCF1DFC0EDD9BAECD8B9EDCAA5AF8679EDE8E9FFFF
        FFFFFFFFFFFFFFFFFFFF9C807BFFFFEBF9EED5FAF1D7F9F2DAF2E3C6FEFBF9FF
        FFF0EFDFC0E9C69EB0857BF5F2F3FFFFFFFFFFFFFFFFFFFFFFFFAF9596F7EAC8
        F9EBCCEFDCBEF4E4C7F0E1C5FDFCECFAF5DDEFDCBCDFB087B59A9AFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFDED4D7BA998CFDECC4EDD4B0E5CAA8EFDBBFF2E3C4F2
        DEBCEABF93BB8E7DE7DFE2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCEBFC5
        BE9A8DE6C7A5EFCBA3ECC8A2E8BE94DCAA86BE9585DFD6D7FFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE9E4E6C9B3B4B99C93C3A097BF9F96CC
        B9B7F1EEEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
      OnClickBtn = ProductTypesEditClickBtn
    end
    object CompanyTypeGrp: TAdvOfficeCheckGroup
      Left = 114
      Top = 66
      Width = 447
      Height = 35
      Version = '1.3.8.5'
      ParentBackground = False
      TabOrder = 22
      Columns = 6
      Ellipsis = False
    end
  end
end
