inherited frTextureInlay: TfrTextureInlay
  object lbReplace: TLabel [0]
    Left = 8
    Top = 24
    Width = 43
    Height = 13
    Caption = 'Replace:'
  end
  object Label3: TLabel [1]
    Left = 8
    Top = 48
    Width = 103
    Height = 13
    Caption = 'Replacement Source:'
  end
  object Label7: TLabel [2]
    Left = 8
    Top = 96
    Width = 89
    Height = 13
    Caption = 'Texture bitmap file:'
  end
  object lbOffsetX: TLabel [3]
    Left = 8
    Top = 164
    Width = 38
    Height = 13
    Caption = 'Offset X'
  end
  object lbOffsetY: TLabel [4]
    Left = 8
    Top = 188
    Width = 38
    Height = 13
    Caption = 'Offset Y'
  end
  object lbTextureDpi: TLabel [5]
    Left = 144
    Top = 168
    Width = 57
    Height = 13
    Caption = 'Texture DPI'
  end
  inherited pnlEffectName: TPanel
    Caption = 'Texture'
  end
  object cbbSource: TComboBox
    Left = 8
    Top = 64
    Width = 105
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    OnChange = cbbSourceChange
  end
  object edImageName: TEdit
    Left = 8
    Top = 112
    Width = 169
    Height = 21
    TabOrder = 2
  end
  object btnChange: TButton
    Left = 184
    Top = 112
    Width = 49
    Height = 21
    Caption = 'Change'
    TabOrder = 3
    OnClick = btnChangeClick
  end
  object chbTiled: TCheckBox
    Left = 8
    Top = 138
    Width = 49
    Height = 17
    Caption = 'Tiled'
    TabOrder = 4
    OnClick = chbTiledClick
  end
  object edTextureDpi: TEdit
    Left = 144
    Top = 184
    Width = 65
    Height = 21
    TabOrder = 5
    OnExit = edTextureDpiExit
  end
  object edOffsetX: TEdit
    Left = 56
    Top = 160
    Width = 65
    Height = 21
    TabOrder = 6
    OnExit = edOffsetXExit
  end
  object edOffsetY: TEdit
    Left = 56
    Top = 184
    Width = 65
    Height = 21
    TabOrder = 7
    OnExit = edOffsetYExit
  end
  object rbRed: TRadioButton
    Left = 56
    Top = 22
    Width = 33
    Height = 17
    Caption = 'R'
    TabOrder = 8
    OnClick = rbRedClick
  end
  object rbGreen: TRadioButton
    Left = 92
    Top = 22
    Width = 29
    Height = 17
    Caption = 'G'
    TabOrder = 9
    OnClick = rbGreenClick
  end
  object rbBlue: TRadioButton
    Left = 128
    Top = 22
    Width = 41
    Height = 17
    Caption = 'B'
    TabOrder = 10
    OnClick = rbBlueClick
  end
  object rbAlpha: TRadioButton
    Left = 160
    Top = 22
    Width = 49
    Height = 17
    Caption = 'Alpha'
    TabOrder = 11
    OnClick = rbAlphaClick
  end
  object rbAny: TRadioButton
    Left = 216
    Top = 22
    Width = 49
    Height = 17
    Caption = 'Any'
    Checked = True
    TabOrder = 12
    TabStop = True
    OnClick = rbAnyClick
  end
end
