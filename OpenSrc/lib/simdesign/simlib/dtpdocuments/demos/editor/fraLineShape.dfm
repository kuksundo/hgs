inherited frLineShape: TfrLineShape
  object Label11: TLabel [16]
    Left = 106
    Top = 140
    Width = 76
    Height = 13
    Alignment = taRightJustify
    Caption = 'Line width [mm]:'
  end
  object Label12: TLabel [17]
    Left = 8
    Top = 172
    Width = 36
    Height = 13
    Caption = 'Arrow 1'
  end
  object Label13: TLabel [18]
    Left = 136
    Top = 172
    Width = 36
    Height = 13
    Caption = 'Arrow 2'
  end
  object Label14: TLabel [19]
    Left = 8
    Top = 196
    Width = 28
    Height = 13
    Caption = 'Width'
  end
  object Label15: TLabel [20]
    Left = 8
    Top = 220
    Width = 33
    Height = 13
    Caption = 'Length'
  end
  object Label16: TLabel [21]
    Left = 136
    Top = 196
    Width = 28
    Height = 13
    Caption = 'Width'
  end
  object Label17: TLabel [22]
    Left = 136
    Top = 220
    Width = 33
    Height = 13
    Caption = 'Length'
  end
  inherited chbPreserveAspect: TCheckBox
    Top = 239
  end
  object edLineWidth: TEdit
    Left = 192
    Top = 136
    Width = 65
    Height = 21
    TabOrder = 13
    Text = 'edLineWidth'
    OnExit = edLineWidthExit
  end
  object cbbArrow1Style: TComboBox
    Left = 48
    Top = 168
    Width = 81
    Height = 21
    ItemHeight = 13
    TabOrder = 14
    Text = 'cbbArrow1Style'
    OnChange = cbbArrow1StyleChange
  end
  object cbbArrow2Style: TComboBox
    Left = 176
    Top = 168
    Width = 81
    Height = 21
    ItemHeight = 13
    TabOrder = 15
    Text = 'ComboBox1'
    OnChange = cbbArrow2StyleChange
  end
  object edArrow1Width: TEdit
    Left = 56
    Top = 192
    Width = 65
    Height = 21
    TabOrder = 16
    OnExit = edArrow1WidthExit
  end
  object edArrow1Length: TEdit
    Left = 56
    Top = 216
    Width = 65
    Height = 21
    TabOrder = 17
    Text = 'Edit1'
    OnExit = edArrow1LengthExit
  end
  object edArrow2Width: TEdit
    Left = 184
    Top = 192
    Width = 65
    Height = 21
    TabOrder = 18
    Text = 'Edit1'
    OnExit = edArrow2WidthExit
  end
  object edArrow2Length: TEdit
    Left = 184
    Top = 216
    Width = 65
    Height = 21
    TabOrder = 19
    Text = 'Edit1'
    OnExit = edArrow2LengthExit
  end
end
