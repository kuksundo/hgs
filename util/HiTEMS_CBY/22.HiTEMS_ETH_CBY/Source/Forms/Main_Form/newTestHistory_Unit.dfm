object newTestHistory_Frm: TnewTestHistory_Frm
  Left = 0
  Top = 0
  Caption = 'newTestHistory_Frm'
  ClientHeight = 681
  ClientWidth = 1099
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object NxSplitter1: TNxSplitter
    Left = 0
    Top = 269
    Width = 1099
    Height = 6
    Cursor = crVSplit
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 15
    Margins.Bottom = 0
    Align = alBottom
    ExplicitTop = 144
    ExplicitWidth = 977
  end
  object Panel3: TPanel
    AlignWithMargins = True
    Left = 0
    Top = 646
    Width = 1099
    Height = 35
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alBottom
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object Button3: TButton
      AlignWithMargins = True
      Left = 860
      Top = 3
      Width = 110
      Height = 29
      Margins.Right = 10
      Align = alRight
      Caption = #51068#51221#49688#51221
      Enabled = False
      ImageIndex = 4
      ImageMargins.Left = 5
      Images = ImageList1
      TabOrder = 0
      OnClick = Button3Click
    end
    object Button7: TButton
      AlignWithMargins = True
      Left = 744
      Top = 3
      Width = 110
      Height = 29
      Align = alRight
      Caption = #51077#47141#46976#52488#44592#54868
      ImageIndex = 6
      ImageMargins.Left = 5
      Images = ImageList1
      TabOrder = 1
      OnClick = Button7Click
    end
    object Button1: TButton
      AlignWithMargins = True
      Left = 983
      Top = 3
      Width = 110
      Height = 29
      Margins.Right = 6
      Align = alRight
      Caption = #51068#51221#46321#47197
      ImageIndex = 5
      ImageMargins.Left = 5
      Images = ImageList1
      TabOrder = 2
      OnClick = Button1Click
    end
  end
  object NxHeaderPanel1: TNxHeaderPanel
    Left = 0
    Top = 275
    Width = 1099
    Height = 371
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 15
    Margins.Bottom = 0
    Align = alBottom
    Caption = #49884#54744#51068#51221' '#46321#47197
    HeaderFont.Charset = ANSI_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -11
    HeaderFont.Name = #47569#51008' '#44256#46357
    HeaderFont.Style = []
    HeaderSize = 23
    ParentHeaderFont = False
    TabOrder = 1
    DesignSize = (
      1097
      369)
    FullWidth = 1099
    object Label6: TLabel
      Left = 759
      Top = 81
      Width = 141
      Height = 15
      Anchors = [akTop, akRight]
      Caption = #49884#54744' '#49884#51089'/'#51333#47308' '#49884#44036'('#44228#54925')'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label7: TLabel
      Left = 759
      Top = 129
      Width = 141
      Height = 15
      Anchors = [akTop, akRight]
      Caption = #49884#54744' '#49884#51089'/'#51333#47308' '#49884#44036'('#49892#51201')'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label8: TLabel
      Left = 410
      Top = 129
      Width = 48
      Height = 15
      Anchors = [akTop, akRight]
      Caption = #49884#54744#51109#49548
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label9: TLabel
      Left = 591
      Top = 129
      Width = 48
      Height = 15
      Anchors = [akTop, akRight]
      Caption = #49884#54744#44396#48516
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label10: TLabel
      Left = 410
      Top = 177
      Width = 48
      Height = 15
      Anchors = [akTop, akRight]
      Caption = #49884#54744#48169#48277
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label11: TLabel
      Left = 759
      Top = 177
      Width = 48
      Height = 15
      Anchors = [akTop, akRight]
      Caption = #49884#54744#44208#44284
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label12: TLabel
      Left = 410
      Top = 27
      Width = 72
      Height = 15
      Anchors = [akTop, akRight]
      Caption = #49884#54744#51032#47280#48512#49436
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label13: TLabel
      Left = 410
      Top = 81
      Width = 60
      Height = 15
      Anchors = [akTop, akRight]
      Caption = #49884#54744#51032#47280#51088
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label14: TLabel
      Left = 8
      Top = 75
      Width = 36
      Height = 15
      Caption = #49884#54744#47749
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label20: TLabel
      Left = 591
      Top = 27
      Width = 60
      Height = 15
      Anchors = [akTop, akRight]
      Caption = #49884#54744#45812#45817#51088
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label21: TLabel
      Left = 591
      Top = 81
      Width = 60
      Height = 15
      Anchors = [akTop, akRight]
      Caption = #51089#50629#45812#45817#51088
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 8
      Top = 129
      Width = 48
      Height = 15
      Caption = #49884#54744#47785#51201
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 8
      Top = 27
      Width = 48
      Height = 15
      Caption = #50644#51652#53440#51077
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 8
      Top = 177
      Width = 48
      Height = 15
      Caption = #48512#54408#51221#48372
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentFont = False
    end
    object mGrid: TNextGrid
      Left = 410
      Top = 255
      Width = 330
      Height = 66
      Anchors = [akTop, akRight]
      Options = [goHeader, goSelectFullRow]
      TabOrder = 0
      TabStop = True
      object NxIncrementColumn3: TNxIncrementColumn
        DefaultWidth = 36
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = #47569#51008' '#44256#46357
        Font.Style = []
        Header.Caption = 'No.'
        Header.Alignment = taCenter
        ParentFont = False
        Position = 0
        SortType = stAlphabetic
        Width = 36
      end
      object NxTextColumn19: TNxTextColumn
        DefaultWidth = 212
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = #47569#51008' '#44256#46357
        Font.Style = []
        Header.Caption = #49884#54744' '#48169#48277' '#54028#51068#47749
        Header.Alignment = taCenter
        Options = [coAutoSize, coCanClick, coCanInput, coCanSort, coPublicUsing, coShowTextFitHint]
        ParentFont = False
        Position = 1
        SortType = stAlphabetic
        Width = 212
      end
      object NxTextColumn20: TNxTextColumn
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = #47569#51008' '#44256#46357
        Font.Style = []
        Header.Caption = #54028#51068#49324#51060#51592
        Header.Alignment = taCenter
        ParentFont = False
        Position = 2
        SortType = stAlphabetic
      end
      object NxTextColumn21: TNxTextColumn
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = #47569#51008' '#44256#46357
        Font.Style = []
        Header.Caption = #50948#52824
        ParentFont = False
        Position = 3
        SortType = stAlphabetic
        Visible = False
      end
      object NxTextColumn8: TNxTextColumn
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Header.Caption = 'FILE_NO'
        ParentFont = False
        Position = 4
        SortType = stAlphabetic
        Visible = False
      end
    end
    object Button2: TButton
      Left = 665
      Top = 327
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #52628#44032
      ImageIndex = 1
      ImageMargins.Left = 5
      Images = ImageList1
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button6: TButton
      Left = 1014
      Top = 327
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #52628#44032
      ImageIndex = 1
      ImageMargins.Left = 5
      Images = ImageList1
      TabOrder = 2
      OnClick = Button6Click
    end
    object rGrid: TNextGrid
      Left = 759
      Top = 255
      Width = 330
      Height = 66
      Anchors = [akTop, akRight]
      Options = [goHeader, goSelectFullRow]
      TabOrder = 3
      TabStop = True
      object NxIncrementColumn1: TNxIncrementColumn
        DefaultWidth = 35
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = #47569#51008' '#44256#46357
        Font.Style = []
        Header.Caption = 'No.'
        Header.Alignment = taCenter
        ParentFont = False
        Position = 0
        SortType = stAlphabetic
        Width = 35
      end
      object NxTextColumn3: TNxTextColumn
        DefaultWidth = 213
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = #47569#51008' '#44256#46357
        Font.Style = []
        Header.Caption = #49884#54744' '#44208#44284' '#54028#51068#47749
        Header.Alignment = taCenter
        Options = [coAutoSize, coCanClick, coCanInput, coCanSort, coPublicUsing, coShowTextFitHint]
        ParentFont = False
        Position = 1
        SortType = stAlphabetic
        Width = 213
      end
      object NxTextColumn4: TNxTextColumn
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = #47569#51008' '#44256#46357
        Font.Style = []
        Header.Caption = #54028#51068#49324#51060#51592
        Header.Alignment = taCenter
        ParentFont = False
        Position = 2
        SortType = stAlphabetic
      end
      object NxTextColumn5: TNxTextColumn
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = #47569#51008' '#44256#46357
        Font.Style = []
        Header.Caption = #50948#52824
        ParentFont = False
        Position = 3
        SortType = stAlphabetic
        Visible = False
      end
      object NxTextColumn9: TNxTextColumn
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Header.Caption = 'FILE_NO'
        ParentFont = False
        Position = 4
        SortType = stAlphabetic
        Visible = False
      end
    end
    object Button9: TButton
      Left = 314
      Top = 327
      Width = 75
      Height = 24
      Anchors = [akTop, akRight]
      Caption = #52628#44032
      ImageIndex = 1
      ImageMargins.Left = 5
      Images = ImageList1
      TabOrder = 4
      OnClick = Button9Click
    end
    object msGrid: TNextGrid
      Left = 8
      Top = 198
      Width = 381
      Height = 123
      Anchors = [akLeft, akTop, akRight]
      Options = [goHeader, goSelectFullRow]
      TabOrder = 5
      TabStop = True
      object NxIncrementColumn4: TNxIncrementColumn
        DefaultWidth = 36
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = #47569#51008' '#44256#46357
        Font.Style = []
        Header.Caption = 'No.'
        Header.Alignment = taCenter
        ParentFont = False
        Position = 0
        SortType = stAlphabetic
        Width = 36
      end
      object NxTextColumn6: TNxTextColumn
        DefaultWidth = 263
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = #47569#51008' '#44256#46357
        Font.Style = []
        Header.Caption = 'MS-NAME'
        Header.Alignment = taCenter
        Options = [coAutoSize, coCanClick, coCanInput, coCanSort, coPublicUsing, coShowTextFitHint]
        ParentFont = False
        Position = 1
        SortType = stAlphabetic
        Width = 263
      end
      object NxTextColumn7: TNxTextColumn
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = #47569#51008' '#44256#46357
        Font.Style = []
        Header.Caption = 'MS-NUMBER'
        Header.Alignment = taCenter
        ParentFont = False
        Position = 2
        SortType = stAlphabetic
      end
    end
    object Button10: TButton
      Left = 584
      Top = 327
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #49440#53469#49325#51228
      ImageIndex = 0
      ImageMargins.Left = 5
      Images = ImageList1
      TabOrder = 6
      OnClick = Button10Click
    end
    object Button11: TButton
      Left = 933
      Top = 327
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #49440#53469#49325#51228
      ImageIndex = 0
      ImageMargins.Left = 5
      Images = ImageList1
      TabOrder = 7
      OnClick = Button11Click
    end
    object engType: TNxComboBox
      AlignWithMargins = True
      Left = 8
      Top = 48
      Width = 381
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 8
      OnChange = engTypeChange
      OnButtonDown = engTypeButtonDown
      HideFocus = False
      AutoCompleteDelay = 0
    end
    object t_title: TNxEdit
      Left = 8
      Top = 96
      Width = 381
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      MaxLength = 100
      TabOrder = 9
    end
    object T_Purpose: TNxEdit
      Left = 8
      Top = 150
      Width = 381
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      MaxLength = 200
      TabOrder = 10
    end
    object t_req_dept: TNxEdit
      Left = 410
      Top = 48
      Width = 150
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 20
      TabOrder = 11
    end
    object t_req_person: TNxEdit
      Left = 410
      Top = 102
      Width = 150
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 10
      TabOrder = 12
    end
    object Button4: TButton
      Left = 716
      Top = 48
      Width = 24
      Height = 21
      Anchors = [akTop, akRight]
      ImageIndex = 7
      Images = ImageList1
      TabOrder = 13
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 716
      Top = 101
      Width = 24
      Height = 21
      Anchors = [akTop, akRight]
      ImageIndex = 7
      Images = ImageList1
      TabOrder = 14
      OnClick = Button5Click
    end
    object t_plan_begin: TAdvDateTimePicker
      Left = 759
      Top = 102
      Width = 162
      Height = 21
      Anchors = [akTop, akRight]
      Date = 41152.667268518520000000
      Time = 41152.667268518520000000
      DoubleBuffered = True
      ImeName = 'Microsoft Office IME 2007'
      Kind = dkDateTime
      ParentDoubleBuffered = False
      TabOrder = 15
      BorderStyle = bsSingle
      Ctl3D = True
      DateTime = 41152.667268518520000000
      TimeFormat = 'HH:mm'
      Version = '1.2.0.1'
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
    end
    object t_plan_end: TAdvDateTimePicker
      Left = 927
      Top = 102
      Width = 162
      Height = 21
      Anchors = [akTop, akRight]
      Date = 41152.667268518520000000
      Time = 41152.667268518520000000
      DoubleBuffered = True
      ImeName = 'Microsoft Office IME 2007'
      Kind = dkDateTime
      ParentDoubleBuffered = False
      TabOrder = 16
      BorderStyle = bsSingle
      Ctl3D = True
      DateTime = 41152.667268518520000000
      TimeFormat = 'HH:mm'
      Version = '1.2.0.1'
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
    end
    object t_site: TNxComboBox
      Left = 410
      Top = 150
      Width = 150
      Height = 21
      Anchors = [akTop, akRight]
      TabOrder = 17
      ReadOnly = True
      OnButtonDown = t_siteButtonDown
      HideFocus = False
      OnSelect = t_siteSelect
      AutoCompleteDelay = 0
    end
    object t_method: TMemo
      Left = 410
      Top = 198
      Width = 330
      Height = 52
      Anchors = [akTop, akRight]
      ImeName = 'Microsoft Office IME 2007'
      MaxLength = 200
      TabOrder = 18
    end
    object t_result: TMemo
      Left = 759
      Top = 198
      Width = 330
      Height = 52
      Anchors = [akTop, akRight]
      ImeName = 'Microsoft Office IME 2007'
      MaxLength = 200
      TabOrder = 19
    end
    object detailBtn: TButton
      Left = 939
      Top = 27
      Width = 150
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #49464#48512#49324#54637' '#46321#47197#65286#51312#54924
      ImageIndex = 3
      ImageMargins.Left = 5
      Images = ImageList1
      TabOrder = 20
      OnClick = detailBtnClick
    end
    object t_rst_begin: TAdvDateTimePicker
      Left = 759
      Top = 150
      Width = 162
      Height = 21
      Anchors = [akTop, akRight]
      Date = 41152.667268518520000000
      Time = 41152.667268518520000000
      DoubleBuffered = True
      ImeName = 'Microsoft Office IME 2007'
      Kind = dkDateTime
      ParentDoubleBuffered = False
      TabOrder = 21
      BorderStyle = bsSingle
      Ctl3D = True
      DateTime = 41152.667268518520000000
      TimeFormat = 'HH:mm'
      Version = '1.2.0.1'
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
    end
    object t_rst_end: TAdvDateTimePicker
      Left = 927
      Top = 150
      Width = 162
      Height = 21
      Anchors = [akTop, akRight]
      Date = 41152.667268518520000000
      Time = 41152.667268518520000000
      DoubleBuffered = True
      ImeName = 'Microsoft Office IME 2007'
      Kind = dkDateTime
      ParentDoubleBuffered = False
      TabOrder = 22
      BorderStyle = bsSingle
      Ctl3D = True
      DateTime = 41152.667268518520000000
      TimeFormat = 'HH:mm'
      Version = '1.2.0.1'
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
    end
    object t_person: TNxEdit
      Left = 591
      Top = 48
      Width = 120
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 20
      TabOrder = 23
      ReadOnly = True
      OnChange = t_personChange
    end
    object t_op_person: TNxEdit
      Left = 591
      Top = 102
      Width = 120
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 20
      TabOrder = 24
      ReadOnly = True
      OnChange = t_op_personChange
    end
    object t_type: TNxComboBox
      Left = 591
      Top = 150
      Width = 149
      Height = 21
      Anchors = [akTop, akRight]
      TabOrder = 25
      ReadOnly = True
      HideFocus = False
      AutoCompleteDelay = 0
      ItemIndex = 0
      Items.Strings = (
        ''
        #49884#54744#50868#51204
        #49457#45733#49884#54744
        #45236#44396#49884#54744
        'T.A.T(TYPE APPROVAL TEST)'
        'F.A.T(FACTORY ACCEPTANCE TEST)')
    end
  end
  object NxHeaderPanel2: TNxHeaderPanel
    Left = 0
    Top = 0
    Width = 1099
    Height = 269
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 15
    Margins.Bottom = 0
    Align = alClient
    Caption = #49884#54744#47785#47197
    HeaderFont.Charset = ANSI_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -11
    HeaderFont.Name = #47569#51008' '#44256#46357
    HeaderFont.Style = [fsBold]
    HeaderSize = 23
    ParentHeaderFont = False
    TabOrder = 2
    DesignSize = (
      1097
      267)
    FullWidth = 1099
    object listGrid: TNextGrid
      AlignWithMargins = True
      Left = 3
      Top = 26
      Width = 1091
      Height = 238
      Align = alClient
      AppearanceOptions = [aoHighlightSlideCells]
      HeaderStyle = hsOffice2007
      Options = [goHeader, goSelectFullRow]
      TabOrder = 0
      TabStop = True
      OnDblClick = listGridDblClick
      object NxIncrementColumn2: TNxIncrementColumn
        DefaultWidth = 33
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = #47569#51008' '#44256#46357
        Font.Style = []
        Header.Alignment = taCenter
        ParentFont = False
        Position = 0
        SortType = stAlphabetic
        Width = 33
      end
      object NxTextColumn15: TNxTextColumn
        Alignment = taCenter
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = #47569#51008' '#44256#46357
        Font.Style = []
        Header.Caption = 'ProjectNo'
        Header.Alignment = taCenter
        ParentFont = False
        Position = 1
        SortType = stAlphabetic
      end
      object NxTextColumn16: TNxTextColumn
        Alignment = taCenter
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = #47569#51008' '#44256#46357
        Font.Style = []
        Header.Caption = #50644#51652#53440#51077
        Header.Alignment = taCenter
        ParentFont = False
        Position = 2
        SortType = stAlphabetic
      end
      object NxTextColumn1: TNxTextColumn
        DefaultWidth = 336
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = #47569#51008' '#44256#46357
        Font.Style = []
        Header.Caption = #49884#54744#47749
        Header.Alignment = taCenter
        Options = [coAutoSize, coCanClick, coCanInput, coCanSort, coPublicUsing, coShowTextFitHint]
        ParentFont = False
        Position = 3
        SortType = stAlphabetic
        Width = 336
      end
      object NxTextColumn14: TNxTextColumn
        Alignment = taCenter
        DefaultWidth = 140
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = #47569#51008' '#44256#46357
        Font.Style = []
        Header.Caption = #49884#54744#49884#51089#51068
        Header.Alignment = taCenter
        ParentFont = False
        Position = 4
        SortType = stAlphabetic
        Width = 140
      end
      object NxTextColumn2: TNxTextColumn
        Alignment = taCenter
        DefaultWidth = 140
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = #47569#51008' '#44256#46357
        Font.Style = []
        Header.Caption = #49884#54744#51333#47308#51068
        Header.Alignment = taCenter
        ParentFont = False
        Position = 5
        SortType = stAlphabetic
        Width = 140
      end
      object NxTextColumn11: TNxTextColumn
        Alignment = taCenter
        DefaultWidth = 140
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = #47569#51008' '#44256#46357
        Font.Style = []
        Header.Caption = #49884#54744#51109#49548
        Header.Alignment = taCenter
        ParentFont = False
        Position = 6
        SortType = stAlphabetic
        Width = 140
      end
      object NxTextColumn12: TNxTextColumn
        Alignment = taCenter
        DefaultWidth = 140
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = #47569#51008' '#44256#46357
        Font.Style = []
        Header.Caption = #49884#54744#44396#48516
        Header.Alignment = taCenter
        ParentFont = False
        Position = 7
        SortType = stAlphabetic
        Width = 140
      end
      object NxTextColumn13: TNxTextColumn
        Alignment = taCenter
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = #47569#51008' '#44256#46357
        Font.Style = []
        Header.Caption = 'TESTNO'
        ParentFont = False
        Position = 8
        SortType = stAlphabetic
        Visible = False
      end
    end
    object Button12: TButton
      Left = 1006
      Top = 3
      Width = 88
      Height = 20
      Anchors = [akTop, akRight]
      Caption = #49345#49464#51312#54924
      ImageIndex = 2
      ImageMargins.Left = 5
      Images = ImageList1
      TabOrder = 1
      OnClick = Button12Click
    end
    object Button8: TButton
      Left = 912
      Top = 3
      Width = 88
      Height = 20
      Anchors = [akTop, akRight]
      Caption = #49352#47196#44256#52840
      ImageIndex = 8
      ImageMargins.Left = 5
      Images = ImageList1
      TabOrder = 2
      OnClick = Button8Click
    end
  end
  object OpenDialog1: TOpenDialog
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 936
    Top = 16
  end
  object ImageList1: TImageList
    ColorDepth = cd32Bit
    Left = 816
    Top = 8
    Bitmap = {
      494C010109000A00380010001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000101010F020101290603024606030245020101290101010F0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000101
      010506030246391B0BB181431EEBA55C2AF7AC612CF6915226E83E2110A90603
      0241010101050000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000010101031007
      03687C3E1DEEB7662CFECC752FFFD97D32FFE58535FFF18E38FFF0903DFEA160
      2FE8100804600101010300000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000070302437E41
      1FF0B26129FEC06B2BFFC06D2EFEB7672CFCC37031FCE38638FEFB953AFFFB96
      3DFEA96734E90604023D00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000001010105452210BCA458
      28FEB36228FF9F5626FA371A0BA60B05024B0B05024A3B1F0FA0CF7B36F9FC96
      3CFEF89640FE54321AB201010104000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000003020126894A27F3A85A
      26FFA85C29FE2D15099701010104000000000000000001010103311A0D90ED8E
      3CFDFE983CFFBC733AEE03020121000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000A050246A26037FBAE64
      30FF924F27F705030230000000000000000000000000000000000403022BC275
      37F4F59641FEDF8E48F90904023F000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000A050349AB6B40FCB873
      40FF935630F40302012400000000000000000201011F01010103010101051E10
      087225150B7824150B7603020125000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000503022FA16842F6BE7D
      4AFFB27345FC170C067301010104000000002613098B0A050350010101030000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000101010669432BCEC286
      54FEC48653FE8D5C3AE8120A056A02010124422919A995613AE50A05034E0101
      0103000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000011090557B481
      57F8CC935FFFCC925DFEB98154F98D5D3CE39E6B47EBDF9A5AFE9B6A41E30A05
      034C010101030000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000010101032C1C
      1188BE8E63F9D19D68FED69E67FFD99F66FFDDA064FFE1A162FFE4A362FE9D6F
      48E10402022E0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000101
      0103160E0962886445DACB9E6FFAD8A874FEDBA973FEE0A86DFFDFA86FFD593C
      27AF0101010F0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000101010E0B0604441D130C6972553CC7DBB07CFD583E2AAF0201
      0110000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000412F229B57402DAF020101100000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001008045A02010110000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
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
end
