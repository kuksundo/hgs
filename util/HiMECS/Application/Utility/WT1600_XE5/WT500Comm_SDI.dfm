object WT1600CommSDIF: TWT1600CommSDIF
  Left = 183
  Top = 150
  Caption = 'Power Meter'
  ClientHeight = 533
  ClientWidth = 447
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  PrintScale = poNone
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDeactivate = FormDeactivate
  OnHide = FormHide
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 409
    Width = 447
    Height = 106
    Align = alClient
    PopupMenu = PopupMenu1
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 233
      Top = 1
      Height = 104
      ExplicitLeft = 281
      ExplicitHeight = 125
    end
    object SendComMemo: TMemo
      Left = 1
      Top = 1
      Width = 232
      Height = 104
      Align = alLeft
      Color = 12582143
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object RecvComMemo: TMemo
      Left = 236
      Top = 1
      Width = 210
      Height = 104
      Align = alClient
      Color = 16775404
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
      ScrollBars = ssBoth
      TabOrder = 1
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 447
    Height = 65
    Align = alTop
    Color = clBlack
    ParentBackground = False
    TabOrder = 0
    DesignSize = (
      447
      65)
    object Label10: TLabel
      Left = 83
      Top = 14
      Width = 115
      Height = 16
      Anchors = [akRight, akBottom]
      Caption = #53685#49888' Interval'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = #44404#47548#52404
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 267
      Top = 14
      Width = 36
      Height = 16
      Anchors = [akRight, akBottom]
      Caption = 'mSec'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = #44404#47548#52404
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 92
      Top = 39
      Width = 99
      Height = 16
      Anchors = [akRight, akBottom]
      Caption = 'Stay On Top'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = #44404#47548#52404
      Font.Style = [fsBold]
      ParentFont = False
    end
    object iSwitchLed1: TiSwitchLed
      Left = 1
      Top = 15
      Width = 58
      Height = 44
      OnClick = iSwitchLed1Click
      Caption = 'On'
      CaptionFont.Charset = DEFAULT_CHARSET
      CaptionFont.Color = clWindowText
      CaptionFont.Height = -11
      CaptionFont.Name = 'Tahoma'
      CaptionFont.Style = []
      CaptionMargin = 2
      IndicatorHeight = 20
      BorderSize = 2
      BorderHighlightColor = clBtnHighlight
      BorderShadowColor = clBtnShadow
      TabOrder = 0
      Caption_2 = 'On'
    end
    object BitBtn1: TBitBtn
      Left = 331
      Top = 14
      Width = 111
      Height = 45
      Anchors = [akTop, akRight]
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      Kind = bkClose
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 1
    end
    object IntervalEdit: TEdit
      Left = 197
      Top = 10
      Width = 64
      Height = 21
      Anchors = [akRight, akBottom]
      ImeName = 'Microsoft Office IME 2007'
      TabOrder = 2
    end
    object Button2: TButton
      Left = 197
      Top = 36
      Width = 106
      Height = 27
      Anchors = [akRight, akBottom]
      Caption = 'Interval Apply'
      TabOrder = 3
      OnClick = Button2Click
    end
    object StayOnTopCB: TCheckBox
      Left = 72
      Top = 40
      Width = 14
      Height = 17
      TabOrder = 4
      OnClick = StayOnTopCBClick
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 515
    Width = 447
    Height = 18
    Panels = <>
    OnClick = StatusBar1Click
  end
  object Panel3: TPanel
    Left = 0
    Top = 65
    Width = 447
    Height = 344
    Align = alTop
    TabOrder = 3
    object Splitter2: TSplitter
      Left = 1
      Top = 340
      Width = 445
      Height = 3
      Cursor = crVSplit
      Align = alBottom
      ExplicitLeft = 2
      ExplicitTop = 312
    end
    object Panel4: TPanel
      Left = 1
      Top = 1
      Width = 163
      Height = 339
      Align = alLeft
      TabOrder = 0
      object Panel28: TPanel
        Left = 6
        Top = 9
        Width = 154
        Height = 25
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Caption = #54637' '#47785
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
      end
      object Panel29: TPanel
        Left = 6
        Top = 36
        Width = 154
        Height = 22
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Caption = #8721'P(Active Power)'
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 1
      end
      object Panel30: TPanel
        Left = 6
        Top = 56
        Width = 154
        Height = 22
        Hint = 'URMS 1'
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Caption = #8721'S(Apparent Power)'
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 2
      end
      object Panel31: TPanel
        Left = 6
        Top = 76
        Width = 154
        Height = 22
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Caption = #8721'Q(Reactive Power)'
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 3
      end
      object Panel32: TPanel
        Left = 6
        Top = 96
        Width = 154
        Height = 22
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Caption = 'fU(Frequency)'
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 4
      end
      object Panel33: TPanel
        Left = 6
        Top = 137
        Width = 154
        Height = 22
        Hint = 'IRMS 1'
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Caption = 'Current 1'
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 5
      end
      object Panel36: TPanel
        Left = 6
        Top = 157
        Width = 154
        Height = 22
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Caption = 'Current 2'
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 6
      end
      object Panel23: TPanel
        Left = 6
        Top = 177
        Width = 154
        Height = 22
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Caption = 'Current 3'
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 7
      end
      object Panel5: TPanel
        Left = 6
        Top = 197
        Width = 154
        Height = 22
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Caption = 'Voltage 1'
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 8
      end
      object Panel6: TPanel
        Left = 6
        Top = 217
        Width = 154
        Height = 22
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Caption = 'Voltage 2'
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 9
      end
      object Panel7: TPanel
        Left = 6
        Top = 237
        Width = 154
        Height = 22
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Caption = 'Voltage 3'
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 10
      end
      object Panel34: TPanel
        Left = 6
        Top = 116
        Width = 154
        Height = 22
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Caption = 'Ramda(Power Factor)'
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 11
      end
      object IRMSAVG000: TPanel
        Left = 6
        Top = 263
        Width = 154
        Height = 22
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Caption = 'Current 1,2,3 Avg'
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 12
      end
      object Panel24: TPanel
        Left = 6
        Top = 285
        Width = 154
        Height = 22
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Caption = 'Voltage 1,2,3 Avg'
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 13
      end
      object Panel22: TPanel
        Left = 4
        Top = 311
        Width = 154
        Height = 22
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Caption = 'F1(P'#8721'A+P'#8721'B)'
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 14
      end
    end
    object Panel8: TPanel
      Left = 164
      Top = 1
      Width = 237
      Height = 339
      Align = alClient
      TabOrder = 1
      DesignSize = (
        237
        339)
      object Panel83: TPanel
        Left = 1
        Top = 9
        Width = 232
        Height = 25
        Anchors = [akLeft, akTop, akRight]
        BevelOuter = bvNone
        BorderWidth = 1
        BorderStyle = bsSingle
        Caption = #44050
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
      end
      object PSIGMA: TPanel
        Left = 1
        Top = 36
        Width = 232
        Height = 22
        Anchors = [akLeft, akTop, akRight]
        BevelOuter = bvNone
        BorderWidth = 1
        BorderStyle = bsSingle
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 1
        OnDblClick = PSIGMADblClick
      end
      object SSIGMA: TPanel
        Left = 1
        Top = 56
        Width = 232
        Height = 22
        Anchors = [akLeft, akTop, akRight]
        BevelOuter = bvNone
        BorderWidth = 1
        BorderStyle = bsSingle
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 2
        OnDblClick = SSIGMADblClick
      end
      object QSIGMA: TPanel
        Left = 1
        Top = 76
        Width = 232
        Height = 22
        Anchors = [akLeft, akTop, akRight]
        BevelOuter = bvNone
        BorderWidth = 1
        BorderStyle = bsSingle
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 3
        OnDblClick = QSIGMADblClick
      end
      object FREQUENCY: TPanel
        Left = 1
        Top = 96
        Width = 232
        Height = 22
        Anchors = [akLeft, akTop, akRight]
        BevelOuter = bvNone
        BorderWidth = 1
        BorderStyle = bsSingle
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 4
        OnDblClick = FREQUENCYDblClick
      end
      object RAMDA: TPanel
        Left = 1
        Top = 116
        Width = 232
        Height = 22
        Anchors = [akLeft, akTop, akRight]
        BevelOuter = bvNone
        BorderWidth = 1
        BorderStyle = bsSingle
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 5
        OnDblClick = RAMDADblClick
      end
      object IRMS1: TPanel
        Left = 1
        Top = 136
        Width = 232
        Height = 22
        Anchors = [akLeft, akTop, akRight]
        BevelOuter = bvNone
        BorderWidth = 1
        BorderStyle = bsSingle
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 6
        OnDblClick = IRMS1DblClick
      end
      object IRMS2: TPanel
        Left = 1
        Top = 156
        Width = 232
        Height = 22
        Anchors = [akLeft, akTop, akRight]
        BevelOuter = bvNone
        BorderWidth = 1
        BorderStyle = bsSingle
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 7
        OnDblClick = IRMS2DblClick
      end
      object IRMS3: TPanel
        Left = 1
        Top = 176
        Width = 232
        Height = 22
        Anchors = [akLeft, akTop, akRight]
        BevelOuter = bvNone
        BorderWidth = 1
        BorderStyle = bsSingle
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 8
        OnDblClick = IRMS3DblClick
      end
      object URMS1: TPanel
        Left = 1
        Top = 196
        Width = 232
        Height = 22
        Anchors = [akLeft, akTop, akRight]
        BevelOuter = bvNone
        BorderWidth = 1
        BorderStyle = bsSingle
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 9
        OnDblClick = URMS1DblClick
      end
      object URMS2: TPanel
        Left = 1
        Top = 216
        Width = 232
        Height = 22
        Anchors = [akLeft, akTop, akRight]
        BevelOuter = bvNone
        BorderWidth = 1
        BorderStyle = bsSingle
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 10
        OnDblClick = URMS2DblClick
      end
      object URMS3: TPanel
        Left = 1
        Top = 236
        Width = 232
        Height = 22
        Anchors = [akLeft, akTop, akRight]
        BevelOuter = bvNone
        BorderWidth = 1
        BorderStyle = bsSingle
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 11
        OnDblClick = URMS3DblClick
      end
      object IRMSAVG: TPanel
        Left = 1
        Top = 263
        Width = 232
        Height = 22
        Anchors = [akLeft, akTop, akRight]
        BevelOuter = bvNone
        BorderWidth = 1
        BorderStyle = bsSingle
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 12
        OnDblClick = URMS2DblClick
      end
      object URMSAVG: TPanel
        Left = 1
        Top = 285
        Width = 232
        Height = 22
        Anchors = [akLeft, akTop, akRight]
        BevelOuter = bvNone
        BorderWidth = 1
        BorderStyle = bsSingle
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 13
        OnDblClick = URMS3DblClick
      end
      object F1: TPanel
        Left = 1
        Top = 311
        Width = 232
        Height = 22
        Anchors = [akLeft, akTop, akRight]
        BevelOuter = bvNone
        BorderWidth = 1
        BorderStyle = bsSingle
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 14
        OnDblClick = URMS3DblClick
      end
    end
    object Panel9: TPanel
      Left = 401
      Top = 1
      Width = 45
      Height = 339
      Align = alRight
      TabOrder = 2
      object Panel18: TPanel
        Left = 1
        Top = 9
        Width = 40
        Height = 25
        BevelOuter = bvNone
        BorderWidth = 1
        BorderStyle = bsSingle
        Caption = #45800#50948
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
      end
      object Panel10: TPanel
        Left = 1
        Top = 36
        Width = 40
        Height = 22
        BevelOuter = bvNone
        BorderWidth = 1
        BorderStyle = bsSingle
        Caption = 'kW'
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 1
      end
      object Panel11: TPanel
        Left = 1
        Top = 56
        Width = 40
        Height = 22
        BevelOuter = bvNone
        BorderWidth = 1
        BorderStyle = bsSingle
        Caption = 'kVA'
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 2
      end
      object Panel12: TPanel
        Left = 1
        Top = 76
        Width = 40
        Height = 22
        BevelOuter = bvNone
        BorderWidth = 1
        BorderStyle = bsSingle
        Caption = 'kVAR'
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 3
      end
      object Panel13: TPanel
        Left = 1
        Top = 96
        Width = 40
        Height = 22
        BevelOuter = bvNone
        BorderWidth = 1
        BorderStyle = bsSingle
        Caption = 'Hz'
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 4
      end
      object Panel14: TPanel
        Left = 1
        Top = 116
        Width = 40
        Height = 22
        BevelOuter = bvNone
        BorderWidth = 1
        BorderStyle = bsSingle
        Caption = 'PF'
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 5
      end
      object Panel15: TPanel
        Left = 1
        Top = 136
        Width = 40
        Height = 22
        BevelOuter = bvNone
        BorderWidth = 1
        BorderStyle = bsSingle
        Caption = 'A'
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 6
      end
      object Panel19: TPanel
        Left = 1
        Top = 156
        Width = 40
        Height = 22
        BevelOuter = bvNone
        BorderWidth = 1
        BorderStyle = bsSingle
        Caption = 'A'
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 7
      end
      object Panel16: TPanel
        Left = 1
        Top = 176
        Width = 40
        Height = 22
        BevelOuter = bvNone
        BorderWidth = 1
        BorderStyle = bsSingle
        Caption = 'A'
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 8
      end
      object Panel17: TPanel
        Left = 1
        Top = 196
        Width = 40
        Height = 22
        BevelOuter = bvNone
        BorderWidth = 1
        BorderStyle = bsSingle
        Caption = 'V'
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 9
      end
      object Panel20: TPanel
        Left = 1
        Top = 216
        Width = 40
        Height = 22
        BevelOuter = bvNone
        BorderWidth = 1
        BorderStyle = bsSingle
        Caption = 'V'
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 10
      end
      object Panel21: TPanel
        Left = 1
        Top = 236
        Width = 40
        Height = 22
        BevelOuter = bvNone
        BorderWidth = 1
        BorderStyle = bsSingle
        Caption = 'V'
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 11
      end
      object Panel27: TPanel
        Left = 1
        Top = 263
        Width = 40
        Height = 22
        BevelOuter = bvNone
        BorderWidth = 1
        BorderStyle = bsSingle
        Caption = 'A'
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 12
      end
      object Panel35: TPanel
        Left = 1
        Top = 285
        Width = 40
        Height = 22
        BevelOuter = bvNone
        BorderWidth = 1
        BorderStyle = bsSingle
        Caption = 'V'
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 13
      end
      object Panel26: TPanel
        Left = 2
        Top = 311
        Width = 40
        Height = 22
        BevelOuter = bvNone
        BorderWidth = 1
        BorderStyle = bsSingle
        Caption = 'kW'
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 14
      end
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 56
    Top = 72
  end
  object PopupMenu1: TPopupMenu
    Left = 88
    Top = 72
    object Config1: TMenuItem
      Caption = 'Config'
      OnClick = Config1Click
    end
  end
end
