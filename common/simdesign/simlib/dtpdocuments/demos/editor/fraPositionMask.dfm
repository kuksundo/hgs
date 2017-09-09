inherited frPositionMask: TfrPositionMask
  inherited cbbOperation: TComboBox
    TabOrder = 3
  end
  object gbPosition: TGroupBox
    Left = 8
    Top = 56
    Width = 257
    Height = 129
    Caption = 'Position relative to shape'
    TabOrder = 2
    object Label2: TLabel
      Left = 8
      Top = 80
      Width = 43
      Height = 13
      Caption = 'Rotation:'
    end
    object Label3: TLabel
      Left = 8
      Top = 24
      Width = 18
      Height = 13
      Caption = 'Left'
    end
    object Label4: TLabel
      Left = 136
      Top = 24
      Width = 19
      Height = 13
      Caption = 'Top'
    end
    object Label5: TLabel
      Left = 8
      Top = 48
      Width = 28
      Height = 13
      Caption = 'Width'
    end
    object Label6: TLabel
      Left = 136
      Top = 48
      Width = 31
      Height = 13
      Caption = 'Height'
    end
    object edLeft: TEdit
      Left = 48
      Top = 20
      Width = 73
      Height = 21
      TabOrder = 0
    end
    object edTop: TEdit
      Left = 176
      Top = 20
      Width = 73
      Height = 21
      TabOrder = 1
    end
    object edWidth: TEdit
      Left = 48
      Top = 44
      Width = 73
      Height = 21
      TabOrder = 2
    end
    object edHeight: TEdit
      Left = 176
      Top = 44
      Width = 73
      Height = 21
      TabOrder = 3
    end
    object cbbRotation: TComboBox
      Left = 8
      Top = 96
      Width = 89
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 4
      Items.Strings = (
        'No Rotation'
        'Rotate 90'
        'Rotate 180'
        'Rotate 270'
        'Free Rotation')
    end
  end
end
