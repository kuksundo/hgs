inherited frExposedMetafile: TfrExposedMetafile
  object cpbPenColor: TColorPickerButton [8]
    Left = 32
    Top = 64
    Width = 89
    Height = 22
    PopupSpacing = 8
    ShowSystemColors = False
    OnChange = cpbPenColorChange
  end
  object Label7: TLabel [9]
    Left = 32
    Top = 48
    Width = 24
    Height = 13
    Caption = 'Color'
  end
  object Width: TLabel [10]
    Left = 144
    Top = 48
    Width = 28
    Height = 13
    Caption = 'Width'
  end
  object Label8: TLabel [11]
    Left = 32
    Top = 112
    Width = 24
    Height = 13
    Caption = 'Color'
  end
  object cpbBrushColor: TColorPickerButton [12]
    Left = 32
    Top = 128
    Width = 89
    Height = 22
    PopupSpacing = 8
    ShowSystemColors = False
    OnChange = cpbBrushColorChange
  end
  object Label9: TLabel [13]
    Left = 144
    Top = 112
    Width = 23
    Height = 13
    Caption = 'Style'
  end
  object chbOverridePen: TCheckBox
    Left = 8
    Top = 32
    Width = 129
    Height = 17
    Caption = 'Override Pen'
    TabOrder = 8
    OnClick = chbOverridePenClick
  end
  object edPenWidth: TEdit
    Left = 144
    Top = 64
    Width = 65
    Height = 21
    TabOrder = 9
    Text = 'edPenWidth'
    OnExit = edPenWidthExit
  end
  object chbOverrideBrush: TCheckBox
    Left = 8
    Top = 96
    Width = 129
    Height = 17
    Caption = 'Override Brush'
    TabOrder = 10
    OnClick = chbOverrideBrushClick
  end
  object cbbBrushStyle: TComboBox
    Left = 144
    Top = 128
    Width = 89
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 11
    OnChange = cbbBrushStyleChange
    Items.Strings = (
      'Solid'
      'Clear'
      'Horizontal'
      'Vertical'
      'FDiagonal'
      'BDiagonal'
      'Cross'
      'DiagCross')
  end
  object chbPreserveAspect: TCheckBox
    Left = 8
    Top = 156
    Width = 129
    Height = 17
    Caption = 'Preserve aspect ratio'
    TabOrder = 12
    OnClick = chbPreserveAspectClick
  end
end
