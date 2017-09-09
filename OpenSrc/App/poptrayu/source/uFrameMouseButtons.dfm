object frameMouseButtons: TframeMouseButtons
  Left = 0
  Top = 0
  Width = 332
  Height = 230
  TabOrder = 0
  object lblLeft: TLabel
    Left = 72
    Top = 24
    Width = 47
    Height = 13
    Alignment = taRightJustify
    Caption = 'Left Click:'
  end
  object lblRight: TLabel
    Left = 66
    Top = 48
    Width = 53
    Height = 13
    Alignment = taRightJustify
    Caption = 'Right Click:'
  end
  object lblMiddle: TLabel
    Left = 61
    Top = 72
    Width = 58
    Height = 13
    Alignment = taRightJustify
    Caption = 'Middle Click:'
  end
  object lblDouble: TLabel
    Left = 58
    Top = 96
    Width = 61
    Height = 13
    Alignment = taRightJustify
    Caption = 'Double Click:'
  end
  object lblMouseAction: TLabel
    Left = 162
    Top = 4
    Width = 68
    Height = 13
    Alignment = taCenter
    Caption = 'Mouse Action:'
  end
  object lblSLeft: TLabel
    Left = 47
    Top = 120
    Width = 72
    Height = 13
    Alignment = taRightJustify
    Caption = 'Shift Left Click:'
  end
  object lblSRight: TLabel
    Left = 41
    Top = 144
    Width = 78
    Height = 13
    Alignment = taRightJustify
    Caption = 'Shift Right Click:'
  end
  object lblSMiddle: TLabel
    Left = 36
    Top = 168
    Width = 83
    Height = 13
    Alignment = taRightJustify
    Caption = 'Shift Middle Click:'
  end
  object cmbLeftClick: TComboBox
    Left = 124
    Top = 20
    Width = 190
    Height = 21
    Style = csDropDownList
    TabOrder = 0
    OnChange = OptionsChange
  end
  object cmbRightClick: TComboBox
    Left = 124
    Top = 44
    Width = 190
    Height = 21
    Style = csDropDownList
    TabOrder = 1
    OnChange = OptionsChange
  end
  object cmbMiddleClick: TComboBox
    Left = 124
    Top = 68
    Width = 190
    Height = 21
    Style = csDropDownList
    TabOrder = 2
    OnChange = OptionsChange
  end
  object cmbDblClick: TComboBox
    Left = 124
    Top = 92
    Width = 190
    Height = 21
    Style = csDropDownList
    TabOrder = 3
    OnChange = OptionsChange
  end
  object cmbShiftLeftClick: TComboBox
    Left = 124
    Top = 116
    Width = 190
    Height = 21
    Style = csDropDownList
    TabOrder = 4
    OnChange = OptionsChange
  end
  object cmbShiftRightClick: TComboBox
    Left = 124
    Top = 140
    Width = 190
    Height = 21
    Style = csDropDownList
    TabOrder = 5
    OnChange = OptionsChange
  end
  object cmbShiftMiddleClick: TComboBox
    Left = 124
    Top = 164
    Width = 190
    Height = 21
    Style = csDropDownList
    TabOrder = 6
    OnChange = OptionsChange
  end
end
