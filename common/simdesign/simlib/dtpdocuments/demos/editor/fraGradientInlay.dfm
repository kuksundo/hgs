inherited frGradientInlay: TfrGradientInlay
  object lbReplace: TLabel [0]
    Left = 8
    Top = 24
    Width = 43
    Height = 13
    Caption = 'Replace:'
  end
  object Label1: TLabel [1]
    Left = 8
    Top = 136
    Width = 45
    Height = 13
    Caption = 'Direction:'
  end
  object Label2: TLabel [2]
    Left = 8
    Top = 176
    Width = 53
    Height = 13
    Caption = 'Fill method:'
  end
  object Label3: TLabel [3]
    Left = 152
    Top = 136
    Width = 103
    Height = 13
    Caption = 'Replacement Source:'
  end
  inherited pnlEffectName: TPanel
    Caption = 'Gradient'
  end
  object rbRed: TRadioButton
    Left = 56
    Top = 22
    Width = 33
    Height = 17
    Caption = 'R'
    TabOrder = 1
    OnClick = rbRedClick
  end
  object rbGreen: TRadioButton
    Left = 92
    Top = 22
    Width = 29
    Height = 17
    Caption = 'G'
    TabOrder = 2
    OnClick = rbGreenClick
  end
  object rbBlue: TRadioButton
    Left = 128
    Top = 22
    Width = 41
    Height = 17
    Caption = 'B'
    TabOrder = 3
    OnClick = rbBlueClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 40
    Width = 255
    Height = 92
    Caption = 'Colors:'
    TabOrder = 4
    object cpbColor1: TColorPickerButton
      Left = 104
      Top = 16
      Width = 65
      Height = 22
      CustomText = 'Custom'
      PopupSpacing = 8
      ShowSystemColors = False
      OnChange = cpbColor1Change
    end
    object cpbColor2: TColorPickerButton
      Left = 176
      Top = 16
      Width = 65
      Height = 22
      CustomText = 'Custom'
      PopupSpacing = 8
      ShowSystemColors = False
      OnChange = cpbColor2Change
    end
    object Label4: TLabel
      Left = 56
      Top = 40
      Width = 30
      Height = 13
      Caption = 'Alpha:'
    end
    object rbUseColors: TRadioButton
      Left = 8
      Top = 19
      Width = 89
      Height = 17
      Caption = 'Use 2 colors:'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = rbUseColorsClick
    end
    object rbUsePreset: TRadioButton
      Left = 8
      Top = 67
      Width = 89
      Height = 17
      Caption = 'Preset palette'
      TabOrder = 1
      OnClick = rbUsePresetClick
    end
    object cbbPreset: TComboBox
      Left = 104
      Top = 64
      Width = 137
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
      OnChange = cbbPresetChange
      Items.Strings = (
        'bla'
        'bla2')
    end
    object trbAlpha1: TTrackBar
      Left = 100
      Top = 40
      Width = 73
      Height = 17
      Max = 255
      PageSize = 50
      Frequency = 10
      Position = 255
      TabOrder = 3
      ThumbLength = 15
      TickStyle = tsNone
      OnChange = trbAlpha1Change
    end
    object trbAlpha2: TTrackBar
      Left = 172
      Top = 40
      Width = 73
      Height = 17
      Max = 255
      PageSize = 50
      Frequency = 10
      Position = 255
      TabOrder = 4
      ThumbLength = 15
      TickStyle = tsNone
      OnChange = trbAlpha2Change
    end
  end
  object cbbDirection: TComboBox
    Left = 8
    Top = 152
    Width = 129
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 5
    OnChange = cbbDirectionChange
  end
  object cbbFillMethod: TComboBox
    Left = 8
    Top = 192
    Width = 129
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 6
    OnChange = cbbFillMethodChange
  end
  object cbbSource: TComboBox
    Left = 152
    Top = 152
    Width = 113
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 7
    OnChange = cbbSourceChange
  end
  object rbAlpha: TRadioButton
    Left = 160
    Top = 22
    Width = 49
    Height = 17
    Caption = 'Alpha'
    TabOrder = 8
    OnClick = rbAlphaClick
  end
  object rbAny: TRadioButton
    Left = 216
    Top = 22
    Width = 49
    Height = 17
    Caption = 'Any'
    Checked = True
    TabOrder = 9
    TabStop = True
    OnClick = rbAnyClick
  end
end
