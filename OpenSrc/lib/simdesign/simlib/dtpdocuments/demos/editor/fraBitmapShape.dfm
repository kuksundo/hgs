inherited frBitmapShape: TfrBitmapShape
  object Label7: TLabel [8]
    Left = 8
    Top = 32
    Width = 82
    Height = 13
    Caption = 'Image bitmap file:'
  end
  inherited btnPermissions: TButton
    TabOrder = 14
  end
  object edImageName: TEdit
    Left = 8
    Top = 48
    Width = 145
    Height = 21
    TabOrder = 8
  end
  object btnChange: TButton
    Left = 160
    Top = 48
    Width = 49
    Height = 21
    Caption = 'Change'
    TabOrder = 9
    OnClick = btnChangeClick
  end
  object btnSave: TButton
    Left = 216
    Top = 48
    Width = 49
    Height = 21
    Caption = 'Save as'
    TabOrder = 10
    OnClick = btnSaveClick
  end
  object btnWorkshop: TButton
    Left = 8
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Workshop...'
    TabOrder = 11
    OnClick = btnWorkshopClick
  end
  object chbPreserveAspect: TCheckBox
    Left = 8
    Top = 116
    Width = 129
    Height = 17
    Caption = 'Preserve aspect ratio'
    TabOrder = 12
    OnClick = chbPreserveAspectClick
  end
  object btnClear: TButton
    Left = 160
    Top = 72
    Width = 49
    Height = 21
    Caption = 'Clear'
    TabOrder = 13
    OnClick = btnClearClick
  end
end
