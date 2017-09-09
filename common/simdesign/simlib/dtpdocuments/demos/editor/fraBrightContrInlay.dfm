inherited frBrightContrInlay: TfrBrightContrInlay
  object Label1: TLabel [0]
    Left = 16
    Top = 32
    Width = 52
    Height = 13
    Caption = 'Brightness:'
  end
  object lbBrightness: TLabel [1]
    Left = 80
    Top = 32
    Width = 57
    Height = 13
    Caption = 'lbBrightness'
  end
  object Label2: TLabel [2]
    Left = 16
    Top = 72
    Width = 42
    Height = 13
    Caption = 'Contrast:'
  end
  object lbContrast: TLabel [3]
    Left = 80
    Top = 72
    Width = 47
    Height = 13
    Caption = 'lbContrast'
  end
  inherited pnlEffectName: TPanel
    Caption = 'Brightness / Contrast'
  end
  object trbBrightness: TTrackBar
    Left = 8
    Top = 48
    Width = 249
    Height = 25
    Max = 1000
    Min = -1000
    Orientation = trHorizontal
    PageSize = 50
    Frequency = 10
    Position = 0
    SelEnd = 0
    SelStart = 0
    TabOrder = 1
    ThumbLength = 15
    TickMarks = tmBottomRight
    TickStyle = tsNone
    OnChange = trbBrightnessChange
  end
  object trbContrast: TTrackBar
    Left = 8
    Top = 88
    Width = 249
    Height = 25
    Max = 1000
    Min = -1000
    Orientation = trHorizontal
    PageSize = 50
    Frequency = 10
    Position = 0
    SelEnd = 0
    SelStart = 0
    TabOrder = 2
    ThumbLength = 15
    TickMarks = tmBottomRight
    TickStyle = tsNone
    OnChange = trbContrastChange
  end
end
