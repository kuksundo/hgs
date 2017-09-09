inherited frShadowInlay: TfrShadowInlay
  object Width: TLabel [0]
    Left = 8
    Top = 24
    Width = 60
    Height = 13
    Caption = 'Delta X [mm]'
  end
  object Label1: TLabel [1]
    Left = 88
    Top = 24
    Width = 60
    Height = 13
    Caption = 'Delta Y [mm]'
  end
  object Label2: TLabel [2]
    Left = 16
    Top = 72
    Width = 74
    Height = 13
    Caption = 'Blur radius [mm]'
  end
  object lbBlur: TLabel [3]
    Left = 104
    Top = 72
    Width = 26
    Height = 13
    Caption = 'lbBlur'
  end
  object Label3: TLabel [4]
    Left = 16
    Top = 112
    Width = 56
    Height = 13
    Caption = 'Intensity (%)'
  end
  object lbIntensity: TLabel [5]
    Left = 104
    Top = 112
    Width = 47
    Height = 13
    Caption = 'lbIntensity'
  end
  object cpbColor: TColorPickerButton [6]
    Left = 168
    Top = 40
    Width = 81
    Height = 22
    PopupSpacing = 8
    ShowSystemColors = False
    OnChange = cpbColorChange
  end
  object Label5: TLabel [7]
    Left = 168
    Top = 24
    Width = 66
    Height = 13
    Caption = 'Shadow Color'
  end
  inherited pnlEffectName: TPanel
    Caption = 'Shadow'
  end
  object edDeltaX: TEdit
    Left = 8
    Top = 40
    Width = 65
    Height = 21
    TabOrder = 1
    Text = 'edDeltaX'
    OnExit = edDeltaXExit
  end
  object edDeltaY: TEdit
    Left = 88
    Top = 40
    Width = 65
    Height = 21
    TabOrder = 2
    Text = 'edDeltaY'
    OnExit = edDeltaYExit
  end
  object trbBlur: TTrackBar
    Left = 8
    Top = 88
    Width = 249
    Height = 25
    Max = 1000
    Min = 1
    Orientation = trHorizontal
    PageSize = 50
    Frequency = 100
    Position = 200
    SelEnd = 0
    SelStart = 0
    TabOrder = 3
    ThumbLength = 15
    TickMarks = tmBottomRight
    TickStyle = tsNone
    OnChange = trbBlurChange
  end
  object trbIntensity: TTrackBar
    Left = 8
    Top = 128
    Width = 249
    Height = 25
    Max = 1000
    Orientation = trHorizontal
    PageSize = 50
    Frequency = 10
    Position = 700
    SelEnd = 0
    SelStart = 0
    TabOrder = 4
    ThumbLength = 15
    TickMarks = tmBottomRight
    TickStyle = tsNone
    OnChange = trbIntensityChange
  end
end
