inherited frTextBaseShape: TfrTextBaseShape
  object Label8: TLabel [8]
    Left = 8
    Top = 72
    Width = 51
    Height = 13
    Caption = 'Font Color:'
  end
  object cpbFontColor: TColorPickerButton [9]
    Left = 72
    Top = 67
    Width = 129
    Height = 22
    PopupSpacing = 8
    ShowSystemColors = False
    OnChange = cpbFontColorChange
  end
  object Label9: TLabel [10]
    Left = 8
    Top = 104
    Width = 58
    Height = 13
    Caption = 'Font Height:'
  end
  object Label10: TLabel [11]
    Left = 136
    Top = 104
    Width = 28
    Height = 13
    Caption = 'mm or'
  end
  object Label7: TLabel [12]
    Left = 8
    Top = 40
    Width = 55
    Height = 13
    Caption = 'Font Name:'
  end
  object Label12: TLabel [13]
    Left = 240
    Top = 104
    Width = 14
    Height = 13
    Caption = 'pts'
  end
  inherited btnAnchors: TButton
    TabOrder = 13
  end
  object cbbFontName: TComboBox
    Left = 72
    Top = 36
    Width = 129
    Height = 21
    ItemHeight = 13
    TabOrder = 7
    OnChange = cbbFontNameChange
    OnDropDown = cbbFontNameDropDown
  end
  object edFontHeight: TEdit
    Left = 72
    Top = 100
    Width = 57
    Height = 21
    TabOrder = 8
    OnExit = edFontHeightExit
  end
  object chbBold: TCheckBox
    Left = 72
    Top = 128
    Width = 49
    Height = 17
    Caption = 'Bold'
    TabOrder = 9
    OnClick = chbBoldClick
  end
  object chbItalic: TCheckBox
    Left = 72
    Top = 144
    Width = 49
    Height = 17
    Caption = 'Italic'
    TabOrder = 10
    OnClick = chbItalicClick
  end
  object chbUnderline: TCheckBox
    Left = 136
    Top = 128
    Width = 65
    Height = 17
    Caption = 'Underline'
    TabOrder = 11
    OnClick = chbUnderlineClick
  end
  object chbStrikeout: TCheckBox
    Left = 136
    Top = 144
    Width = 65
    Height = 17
    Caption = 'Strikeout'
    TabOrder = 12
    OnClick = chbStrikeoutClick
  end
  object edFontHeightPts: TEdit
    Left = 176
    Top = 100
    Width = 57
    Height = 21
    TabOrder = 14
    OnExit = edFontHeightPtsExit
  end
end
