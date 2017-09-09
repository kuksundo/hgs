inherited frFrameInlay: TfrFrameInlay
  object Label8: TLabel [0]
    Left = 24
    Top = 48
    Width = 27
    Height = 13
    Caption = 'Color:'
  end
  object cpbFrameColor: TColorPickerButton [1]
    Left = 64
    Top = 43
    Width = 73
    Height = 22
    PopupSpacing = 8
    ShowSystemColors = False
    OnChange = cpbFrameColorChange
  end
  object Label7: TLabel [2]
    Left = 152
    Top = 48
    Width = 31
    Height = 13
    Alignment = taRightJustify
    Caption = 'Width:'
  end
  object Bevel3: TBevel [3]
    Left = 8
    Top = 120
    Width = 249
    Height = 9
    Shape = bsTopLine
  end
  object Label9: TLabel [4]
    Left = 24
    Top = 152
    Width = 27
    Height = 13
    Caption = 'Color:'
  end
  object cpbFillColor: TColorPickerButton [5]
    Left = 64
    Top = 147
    Width = 73
    Height = 22
    PopupSpacing = 8
    ShowSystemColors = False
    OnChange = cpbFillColorChange
  end
  object Label10: TLabel [6]
    Left = 152
    Top = 136
    Width = 42
    Height = 13
    Caption = 'Fill Alpha'
  end
  object lbFillAlpha: TLabel [7]
    Left = 208
    Top = 136
    Width = 42
    Height = 13
    Caption = 'Fill Alpha'
  end
  object Label3: TLabel [8]
    Left = 8
    Top = 24
    Width = 78
    Height = 13
    Caption = 'Frame properties'
  end
  object Label4: TLabel [9]
    Left = 8
    Top = 128
    Width = 61
    Height = 13
    Caption = 'Fill properties'
  end
  object Label1: TLabel [10]
    Left = 141
    Top = 72
    Width = 42
    Height = 13
    Alignment = taRightJustify
    Caption = 'Spacing:'
  end
  object Label2: TLabel [11]
    Left = 147
    Top = 96
    Width = 36
    Height = 13
    Alignment = taRightJustify
    Caption = 'Radius:'
  end
  inherited pnlEffectName: TPanel
    Caption = 'Frame'
  end
  object edFrameWidth: TEdit
    Left = 192
    Top = 44
    Width = 65
    Height = 21
    TabOrder = 1
    Text = 'edFrameWidth'
    OnExit = edFrameWidthExit
  end
  object trbFillAlpha: TTrackBar
    Left = 152
    Top = 151
    Width = 113
    Height = 25
    Max = 255
    Orientation = trHorizontal
    Frequency = 1
    Position = 0
    SelEnd = 0
    SelStart = 0
    TabOrder = 2
    ThumbLength = 15
    TickMarks = tmBottomRight
    TickStyle = tsNone
    OnChange = trbFillAlphaChange
  end
  object edFrameSpacing: TEdit
    Left = 192
    Top = 68
    Width = 65
    Height = 21
    TabOrder = 3
    Text = 'edFrameSpacing'
    OnExit = edFrameSpacingExit
  end
  object edFrameRadius: TEdit
    Left = 192
    Top = 92
    Width = 65
    Height = 21
    TabOrder = 4
    Text = 'edFrameRadius'
    OnExit = edFrameRadiusExit
  end
end
