object userConditions_Frm: TuserConditions_Frm
  Left = 0
  Top = 0
  Caption = #48372#44256#49436' '#49444#51221' - '#49324#50857#51088#48324' '#44592#48376#44160#49353#51312#44148#49444#51221
  ClientHeight = 227
  ClientWidth = 361
  Color = clCream
  Constraints.MaxWidth = 369
  Constraints.MinWidth = 369
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
  object Statusbar1: TAdvOfficeStatusBar
    Left = 0
    Top = 208
    Width = 361
    Height = 19
    AnchorHint = False
    Images = Main_Frm.Imglist16x16
    Panels = <
      item
        AppearanceStyle = psLight
        DateFormat = 'yyyy-MM-dd'
        ImageIndex = 2
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
        Style = psImage
        TimeFormat = 'AMPM h:mm:ss'
        Width = 132
      end
      item
        AppearanceStyle = psLight
        DateFormat = 'yyyy-MM-dd'
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
        Width = 44
      end>
    ShowSplitter = True
    SimplePanel = False
    URLColor = clBlue
    Version = '1.4.1.0'
  end
  object Panel8: TPanel
    Left = 0
    Top = 0
    Width = 361
    Height = 81
    BevelOuter = bvNone
    TabOrder = 1
    object Panel11: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 78
      Height = 75
      Align = alLeft
      Caption = #48372#44256#49436' '#53440#51077
      Color = clSkyBlue
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
    end
    object grptype: TAdvOfficeRadioGroup
      AlignWithMargins = True
      Left = 84
      Top = 3
      Width = 274
      Height = 75
      Margins.Left = 0
      BorderStyle = bsDouble
      CaptionPosition = cpBottomLeft
      Version = '1.3.4.1'
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 1
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        #51204#52404
        #54408#51656' '#47928#51228
        #49444#48708' '#47928#51228
        #47928#51228' '#50696#49345)
      Alignment = taCenter
      Ellipsis = False
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 81
    Width = 361
    Height = 80
    BevelOuter = bvNone
    TabOrder = 2
    object Panel2: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 78
      Height = 74
      Align = alLeft
      Caption = #44160#49353#44592#51456#51068
      Color = clSkyBlue
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
    end
    object GDate: TAdvOfficeRadioGroup
      AlignWithMargins = True
      Left = 84
      Top = 3
      Width = 274
      Height = 74
      Margins.Left = 0
      BorderStyle = bsDouble
      CaptionPosition = cpBottomLeft
      Version = '1.3.4.1'
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 1
      Columns = 2
      ItemIndex = 2
      Items.Strings = (
        #51204#52404
        #54788#51116#51068
        #54788#51116#50900
        '7'#51068#44036)
      Alignment = taCenter
      Ellipsis = False
    end
  end
  object Panel3: TPanel
    Left = 3
    Top = 164
    Width = 355
    Height = 38
    TabOrder = 3
    object Button1: TButton
      AlignWithMargins = True
      Left = 276
      Top = 4
      Width = 75
      Height = 30
      Align = alRight
      Caption = #45803#44592
      ImageIndex = 11
      ImageMargins.Left = 5
      Images = Main_Frm.Imglist16x16
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      AlignWithMargins = True
      Left = 198
      Top = 4
      Width = 75
      Height = 30
      Margins.Right = 0
      Align = alRight
      Caption = #51200#51109
      ImageIndex = 12
      ImageMargins.Left = 5
      Images = Main_Frm.Imglist16x16
      TabOrder = 1
    end
  end
end
