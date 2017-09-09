object UserFind_Frm: TUserFind_Frm
  Left = 893
  Top = 385
  Caption = #49324#50857#51088' '#44160#49353
  ClientHeight = 414
  ClientWidth = 309
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = #47569#51008' '#44256#46357
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object NxHeaderPanel1: TNxHeaderPanel
    Left = 0
    Top = 0
    Width = 309
    Height = 380
    Align = alClient
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -11
    HeaderFont.Name = 'MS Sans Serif'
    HeaderFont.Style = []
    HeaderSize = 65
    PanelStyle = ptInverseGradient
    ParentHeaderFont = False
    TabOrder = 0
    ExplicitWidth = 333
    FullWidth = 309
    object Label1: TLabel
      Left = 67
      Top = 38
      Width = 31
      Height = 17
      Caption = #49457' '#47749
      Color = 8404992
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object Label17: TLabel
      Left = 67
      Top = 11
      Width = 31
      Height = 17
      Caption = #48512' '#49436
      Color = 8404992
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object NextGrid1: TNextGrid
      AlignWithMargins = True
      Left = 3
      Top = 68
      Width = 301
      Height = 307
      Align = alClient
      AutoScroll = True
      HeaderStyle = hsOffice2007
      TabOrder = 0
      TabStop = True
      OnDblClick = NextGrid1DblClick
      OnSelectCell = NextGrid1SelectCell
      ExplicitWidth = 265
      object NxIncrementColumn1: TNxIncrementColumn
        Alignment = taCenter
        DefaultWidth = 37
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Header.Caption = 'No.'
        Header.Alignment = taCenter
        ParentFont = False
        Position = 0
        SortType = stAlphabetic
        Width = 37
      end
      object NxTextColumn1: TNxTextColumn
        Alignment = taCenter
        DefaultWidth = 85
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Header.Caption = #49324#48264
        Header.Alignment = taCenter
        ParentFont = False
        Position = 1
        SortType = stAlphabetic
        Width = 85
      end
      object NxTextColumn2: TNxTextColumn
        Alignment = taCenter
        DefaultWidth = 115
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Header.Caption = #49457#47749
        Header.Alignment = taCenter
        Options = [coAutoSize, coCanClick, coCanInput, coCanSort, coPublicUsing, coShowTextFitHint]
        ParentFont = False
        Position = 2
        SortType = stAlphabetic
        Width = 97
      end
      object NxTextColumn4: TNxTextColumn
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Header.Caption = #51649#44553
        Header.Alignment = taCenter
        ParentFont = False
        Position = 3
        SortType = stAlphabetic
      end
    end
    object person: TEdit
      Left = 105
      Top = 36
      Width = 145
      Height = 21
      Alignment = taCenter
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      ImeName = 'Microsoft Office IME 2007'
      ParentFont = False
      TabOrder = 1
    end
    object Button1: TButton
      Left = 253
      Top = 36
      Width = 53
      Height = 21
      Caption = #44160#49353
      ImageIndex = 6
      Images = Trouble_Frm.Imglist16x16
      TabOrder = 2
      OnClick = Button1Click
    end
    object NxComboBox1: TNxComboBox
      Left = 105
      Top = 9
      Width = 145
      Height = 21
      Alignment = taCenter
      TabOrder = 3
      Text = #50644#51652#44592#44228#44060#48156#49884#54744#48512
      OnButtonDown = NxComboBox1ButtonDown
      HideFocus = False
      OnSelect = NxComboBox1Select
      AutoCompleteDelay = 0
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 380
    Width = 309
    Height = 34
    Align = alBottom
    Color = clCream
    ParentBackground = False
    TabOrder = 1
    ExplicitWidth = 333
    object Button2: TButton
      AlignWithMargins = True
      Left = 152
      Top = 4
      Width = 75
      Height = 26
      Margins.Right = 0
      Align = alRight
      Caption = #51201#50857
      ImageIndex = 2
      ImageMargins.Left = 5
      Images = Trouble_Frm.Imglist16x16
      TabOrder = 0
      OnClick = Button2Click
      ExplicitLeft = 176
    end
    object Button3: TButton
      AlignWithMargins = True
      Left = 230
      Top = 4
      Width = 75
      Height = 26
      Align = alRight
      Caption = #45803#44592
      ImageIndex = 9
      ImageMargins.Left = 5
      Images = Trouble_Frm.Imglist16x16
      TabOrder = 1
      OnClick = Button3Click
      ExplicitLeft = 254
    end
  end
end
