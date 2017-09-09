inherited frBitmapMask: TfrBitmapMask
  object lbBitmapFile: TLabel [1]
    Left = 8
    Top = 200
    Width = 79
    Height = 13
    Caption = 'Mask bitmap file:'
  end
  inherited cbbOperation: TComboBox
    TabOrder = 7
  end
  object edImageName: TEdit
    Left = 8
    Top = 216
    Width = 201
    Height = 21
    TabOrder = 3
  end
  object btnChange: TButton
    Left = 216
    Top = 216
    Width = 49
    Height = 21
    Caption = 'Change'
    TabOrder = 4
    OnClick = btnChangeClick
  end
  object btnClear: TButton
    Left = 216
    Top = 240
    Width = 49
    Height = 21
    Caption = 'Clear'
    TabOrder = 5
  end
  object chbOutsideIsTransparent: TCheckBox
    Left = 8
    Top = 240
    Width = 201
    Height = 17
    Caption = 'Outside is transparent'
    TabOrder = 6
  end
end
