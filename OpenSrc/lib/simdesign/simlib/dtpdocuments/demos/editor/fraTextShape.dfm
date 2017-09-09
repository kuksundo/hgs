inherited frTextShape: TfrTextShape
  object Label11: TLabel [14]
    Left = 8
    Top = 192
    Width = 26
    Height = 13
    Caption = 'Text:'
  end
  object lbAlignment: TLabel [15]
    Left = 8
    Top = 168
    Width = 51
    Height = 13
    Caption = 'Alignment:'
  end
  inherited btnPermissions: TButton
    TabOrder = 18
  end
  object edText: TEdit
    Left = 8
    Top = 208
    Width = 249
    Height = 21
    TabOrder = 15
    OnExit = edTextExit
  end
  object cbbAlignment: TComboBox
    Left = 72
    Top = 164
    Width = 97
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 16
    OnChange = cbbAlignmentChange
    Items.Strings = (
      'LeftJustify'
      'RightJustify'
      'Center')
  end
  object chbAutoSize: TCheckBox
    Left = 192
    Top = 168
    Width = 65
    Height = 17
    Caption = 'AutoSize'
    TabOrder = 17
    OnClick = chbAutoSizeClick
  end
end
