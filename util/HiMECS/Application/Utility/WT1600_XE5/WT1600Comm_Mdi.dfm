object WT1600CommMDIF: TWT1600CommMDIF
  Left = 217
  Top = 125
  Caption = 'Power Meter'
  ClientHeight = 482
  ClientWidth = 683
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 337
    Width = 683
    Height = 127
    Align = alClient
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 281
      Top = 1
      Height = 125
    end
    object SendComMemo: TMemo
      Left = 1
      Top = 1
      Width = 280
      Height = 125
      Align = alLeft
      Color = 12582143
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object RecvComMemo: TMemo
      Left = 284
      Top = 1
      Width = 398
      Height = 125
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
    Width = 683
    Height = 65
    Align = alTop
    TabOrder = 0
    object iSwitchLed1: TiSwitchLed
      Left = 40
      Top = 15
      Width = 89
      Height = 44
      Caption = 'On'
      CaptionFont.Charset = DEFAULT_CHARSET
      CaptionFont.Color = clWindowText
      CaptionFont.Height = -11
      CaptionFont.Name = 'Tahoma'
      CaptionFont.Style = []
      CaptionMargin = 2
      BorderSize = 2
      BorderHighlightColor = clBtnHighlight
      BorderShadowColor = clBtnShadow
      TabOrder = 0
      Caption_2 = 'On'
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 464
    Width = 683
    Height = 18
    Panels = <>
  end
  object Panel3: TPanel
    Left = 0
    Top = 65
    Width = 683
    Height = 272
    Align = alTop
    Caption = 'Panel3'
    TabOrder = 3
    object Panel4: TPanel
      Left = 1
      Top = 1
      Width = 163
      Height = 270
      Align = alLeft
      Caption = 'Panel1'
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
        ParentFont = False
        TabOrder = 11
      end
    end
    object Panel8: TPanel
      Left = 164
      Top = 1
      Width = 473
      Height = 270
      Align = alClient
      Caption = 'Panel2'
      TabOrder = 1
      DesignSize = (
        473
        270)
      object Panel83: TPanel
        Left = 1
        Top = 9
        Width = 468
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
        ParentFont = False
        TabOrder = 0
      end
      object PSIGMA: TPanel
        Left = 1
        Top = 36
        Width = 468
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
        ParentFont = False
        TabOrder = 1
      end
      object SSIGMA: TPanel
        Left = 1
        Top = 56
        Width = 468
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
        ParentFont = False
        TabOrder = 2
      end
      object QSIGMA: TPanel
        Left = 1
        Top = 76
        Width = 468
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
        ParentFont = False
        TabOrder = 3
      end
      object FREQUENCY: TPanel
        Left = 1
        Top = 96
        Width = 468
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
        ParentFont = False
        TabOrder = 4
      end
      object RAMDA: TPanel
        Left = 1
        Top = 116
        Width = 468
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
        ParentFont = False
        TabOrder = 5
      end
      object IRMS1: TPanel
        Left = 1
        Top = 136
        Width = 468
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
        ParentFont = False
        TabOrder = 6
      end
      object IRMS2: TPanel
        Left = 1
        Top = 156
        Width = 468
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
        ParentFont = False
        TabOrder = 7
      end
      object IRMS3: TPanel
        Left = 1
        Top = 176
        Width = 468
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
        ParentFont = False
        TabOrder = 8
      end
      object URMS1: TPanel
        Left = 1
        Top = 196
        Width = 468
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
        ParentFont = False
        TabOrder = 9
      end
      object URMS2: TPanel
        Left = 1
        Top = 216
        Width = 468
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
        ParentFont = False
        TabOrder = 10
      end
      object URMS3: TPanel
        Left = 1
        Top = 236
        Width = 468
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
        ParentFont = False
        TabOrder = 11
      end
    end
    object Panel9: TPanel
      Left = 637
      Top = 1
      Width = 45
      Height = 270
      Align = alRight
      Caption = 'Panel3'
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
        Caption = 'KW'
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
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
        Caption = 'KVA'
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
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
        Caption = 'Kvar'
        Color = clInactiveCaptionText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
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
        ParentFont = False
        TabOrder = 11
      end
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 8
    Top = 8
  end
end
