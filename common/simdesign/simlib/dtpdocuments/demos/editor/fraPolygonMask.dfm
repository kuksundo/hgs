inherited frPolygonMask: TfrPolygonMask
  object lbStyle: TLabel [1]
    Left = 8
    Top = 196
    Width = 26
    Height = 13
    Caption = 'Style:'
  end
  object lbShape: TLabel [2]
    Left = 144
    Top = 196
    Width = 34
    Height = 13
    Caption = 'Shape:'
  end
  object cbbStyle: TComboBox
    Left = 40
    Top = 192
    Width = 73
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
    Items.Strings = (
      'User-defined'
      'Glyphs'
      'Stretched glyphs'
      'Shape')
  end
  object cbbShape: TComboBox
    Left = 184
    Top = 192
    Width = 81
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 5
    OnClick = cbbShapeClick
    Items.Strings = (
      'Ellipse'
      'Rounded Rect'
      'Star')
  end
end
