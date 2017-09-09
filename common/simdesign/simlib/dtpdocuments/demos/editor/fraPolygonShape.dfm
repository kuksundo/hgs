inherited frPolygonShape: TfrPolygonShape
  object Label8: TLabel [8]
    Left = 24
    Top = 56
    Width = 27
    Height = 13
    Caption = 'Color:'
  end
  object cpbOutlineColor: TColorPickerButton [9]
    Left = 64
    Top = 51
    Width = 73
    Height = 22
    CustomText = 'Custom'
    PopupSpacing = 8
    ShowSystemColors = False
    OnChange = cpbOutlineColorChange
  end
  object Label7: TLabel [10]
    Left = 152
    Top = 56
    Width = 31
    Height = 13
    Caption = 'Width:'
  end
  object Label9: TLabel [11]
    Left = 24
    Top = 112
    Width = 27
    Height = 13
    Caption = 'Color:'
  end
  object cpbFillColor: TColorPickerButton [12]
    Left = 64
    Top = 107
    Width = 73
    Height = 22
    CustomText = 'Custom'
    PopupSpacing = 8
    ShowSystemColors = False
    OnChange = cpbFillColorChange
  end
  object Label10: TLabel [13]
    Left = 152
    Top = 96
    Width = 42
    Height = 13
    Caption = 'Fill Alpha'
  end
  object lbFillAlpha: TLabel [14]
    Left = 208
    Top = 96
    Width = 42
    Height = 13
    Caption = 'Fill Alpha'
  end
  object Bevel3: TBevel [15]
    Left = 8
    Top = 80
    Width = 249
    Height = 9
    Shape = bsTopLine
  end
  object chbPreserveAspect: TCheckBox
    Left = 8
    Top = 236
    Width = 129
    Height = 17
    Caption = 'Preserve aspect ratio'
    TabOrder = 8
    OnClick = chbPreserveAspectClick
  end
  object chbUseOutline: TCheckBox
    Left = 8
    Top = 32
    Width = 97
    Height = 17
    Caption = 'Polygon Outline'
    TabOrder = 9
    OnClick = chbUseOutlineClick
  end
  object edOutlineWidth: TEdit
    Left = 192
    Top = 52
    Width = 65
    Height = 21
    TabOrder = 10
    Text = 'edOutlineWidth'
    OnExit = edOutlineWidthExit
  end
  object chbUseFill: TCheckBox
    Left = 8
    Top = 88
    Width = 97
    Height = 17
    Caption = 'Polygon Fill'
    TabOrder = 11
    OnClick = chbUseFillClick
  end
  object trbFillAlpha: TTrackBar
    Left = 152
    Top = 111
    Width = 113
    Height = 25
    Max = 255
    Orientation = trHorizontal
    Frequency = 1
    Position = 0
    SelEnd = 0
    SelStart = 0
    TabOrder = 12
    ThumbLength = 15
    TickMarks = tmBottomRight
    TickStyle = tsNone
    OnChange = trbFillAlphaChange
  end
end
