object AnsiDeviceDescF: TAnsiDeviceDescF
  Left = 0
  Top = 0
  Caption = 'Display Ansi Device Desc'
  ClientHeight = 440
  ClientWidth = 701
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 701
    Height = 78
    Align = alTop
    TabOrder = 0
    object JvLabel19: TJvLabel
      AlignWithMargins = True
      Left = 23
      Top = 11
      Width = 166
      Height = 25
      Alignment = taCenter
      AutoSize = False
      Caption = 'Ansi Device No'
      Color = 14671839
      FrameColor = clGrayText
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      Layout = tlCenter
      Margin = 5
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
      Left = 23
      Top = 42
      Width = 166
      Height = 25
      Alignment = taCenter
      AutoSize = False
      Caption = 'Ansi Device Name'
      Color = 14671839
      FrameColor = clGrayText
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      Layout = tlCenter
      Margin = 5
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
    object BitBtn1: TBitBtn
      Left = 625
      Top = 1
      Width = 75
      Height = 76
      Align = alRight
      Kind = bkClose
      NumGlyphs = 2
      TabOrder = 0
      ExplicitLeft = 552
      ExplicitTop = 8
      ExplicitHeight = 25
    end
    object DeviceNoEdit: TEdit
      Left = 195
      Top = 9
      Width = 94
      Height = 27
      Alignment = taCenter
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ImeName = 'Microsoft IME 2010'
      ParentFont = False
      TabOrder = 1
    end
    object DeviceNameEdit: TEdit
      Left = 195
      Top = 40
      Width = 424
      Height = 27
      Alignment = taCenter
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ImeName = 'Microsoft IME 2010'
      ParentFont = False
      TabOrder = 2
    end
  end
  object RichEdit1: TRichEdit
    Left = 0
    Top = 78
    Width = 701
    Height = 362
    Align = alClient
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ImeName = 'Microsoft IME 2010'
    ParentFont = False
    TabOrder = 1
    ExplicitTop = 75
    ExplicitHeight = 365
  end
end
