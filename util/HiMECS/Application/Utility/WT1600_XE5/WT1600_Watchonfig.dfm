object WT1600WatchConfigF: TWT1600WatchConfigF
  Left = 143
  Top = 244
  Width = 290
  Height = 289
  Caption = #54872#44221#49444#51221' '#54868#47732
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 214
    Width = 282
    Height = 41
    Align = alBottom
    TabOrder = 0
    object BitBtn1: TBitBtn
      Left = 56
      Top = 8
      Width = 75
      Height = 25
      Caption = #54869' '#51064
      TabOrder = 0
      Kind = bkOK
    end
    object BitBtn2: TBitBtn
      Left = 160
      Top = 8
      Width = 75
      Height = 25
      Caption = #52712' '#49548
      TabOrder = 1
      Kind = bkCancel
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 282
    Height = 214
    ActivePage = TabSheet3
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabIndex = 0
    TabOrder = 1
    object TabSheet3: TTabSheet
      Caption = 'Map File'
      ImageIndex = 2
      DesignSize = (
        274
        186)
      object Label1: TLabel
        Left = 11
        Top = 16
        Width = 70
        Height = 13
        Caption = #54028#51068' '#51060#47492':'
      end
      object FilenameEdit: TEdit
        Left = 8
        Top = 32
        Width = 233
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ImeName = 'Microsoft Office IME 2007'
        ParentFont = False
        TabOrder = 0
      end
      object btnSrc: TButton
        Left = 245
        Top = 32
        Width = 21
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '...'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = btnSrcClick
      end
    end
  end
end
