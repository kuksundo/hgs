inherited frHslAdjustInlay: TfrHslAdjustInlay
  object Label1: TLabel [0]
    Left = 16
    Top = 32
    Width = 23
    Height = 13
    Caption = 'Hue:'
  end
  object lbHue: TLabel [1]
    Left = 80
    Top = 32
    Width = 28
    Height = 13
    Caption = 'lbHue'
  end
  object Label2: TLabel [2]
    Left = 16
    Top = 72
    Width = 51
    Height = 13
    Caption = 'Saturation:'
  end
  object lbSaturation: TLabel [3]
    Left = 80
    Top = 72
    Width = 56
    Height = 13
    Caption = 'lbSaturation'
  end
  object Label4: TLabel [4]
    Left = 16
    Top = 112
    Width = 48
    Height = 13
    Caption = 'Lightness:'
  end
  object lbLightness: TLabel [5]
    Left = 80
    Top = 112
    Width = 53
    Height = 13
    Caption = 'lbLightness'
  end
  inherited pnlEffectName: TPanel
    Caption = 'HSL Adjustment'
  end
  object trbHue: TTrackBar
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
    OnChange = trbHueChange
  end
  object trbSaturation: TTrackBar
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
    OnChange = trbSaturationChange
  end
  object trbLightness: TTrackBar
    Left = 8
    Top = 128
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
    TabOrder = 3
    ThumbLength = 15
    TickMarks = tmBottomRight
    TickStyle = tsNone
    OnChange = trbLightnessChange
  end
end
