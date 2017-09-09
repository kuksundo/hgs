inherited frPolygonMemoShape: TfrPolygonMemoShape
  object Label11: TLabel [14]
    Left = 8
    Top = 184
    Width = 55
    Height = 13
    Caption = 'Memo text:'
  end
  object lbAlignment: TLabel [15]
    Left = 8
    Top = 168
    Width = 51
    Height = 13
    Caption = 'Alignment:'
  end
  inherited btnPermissions: TButton
    TabOrder = 19
  end
  object chbWordWrap: TCheckBox
    Left = 184
    Top = 176
    Width = 73
    Height = 17
    Caption = 'WordWrap'
    TabOrder = 15
    OnClick = chbWordWrapClick
  end
  object reText: TRichEdit
    Left = 8
    Top = 198
    Width = 254
    Height = 57
    Lines.Strings = (
      'reText')
    ScrollBars = ssBoth
    TabOrder = 16
    WordWrap = False
    OnExit = reTextExit
  end
  object cbbAlignment: TComboBox
    Left = 72
    Top = 164
    Width = 97
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 17
    OnChange = cbbAlignmentChange
    Items.Strings = (
      'LeftJustify'
      'RightJustify'
      'Center')
  end
  object chbAutoSize: TCheckBox
    Left = 184
    Top = 160
    Width = 65
    Height = 17
    Caption = 'AutoSize'
    TabOrder = 18
    OnClick = chbAutoSizeClick
  end
end
