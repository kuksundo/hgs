inherited frWavyText: TfrWavyText
  object Label13: TLabel [15]
    Left = 56
    Top = 192
    Width = 58
    Height = 13
    Caption = 'Wavelength'
  end
  object Label14: TLabel [16]
    Left = 128
    Top = 192
    Width = 46
    Height = 13
    Caption = 'Amplitude'
  end
  object Label15: TLabel [17]
    Left = 200
    Top = 192
    Width = 21
    Height = 13
    Caption = 'Shift'
  end
  object Label16: TLabel [18]
    Left = 8
    Top = 212
    Width = 50
    Height = 13
    Caption = 'X direction'
  end
  object Label17: TLabel [19]
    Left = 8
    Top = 236
    Width = 50
    Height = 13
    Caption = 'Y direction'
  end
  object edXLen: TEdit
    Left = 64
    Top = 208
    Width = 41
    Height = 21
    TabOrder = 16
    OnExit = edXLenExit
  end
  object edXAmp: TEdit
    Left = 128
    Top = 208
    Width = 41
    Height = 21
    TabOrder = 17
    OnExit = edXAmpExit
  end
  object edXOfs: TEdit
    Left = 192
    Top = 208
    Width = 41
    Height = 21
    TabOrder = 18
    OnChange = edXOfsChange
  end
  object edYLen: TEdit
    Left = 64
    Top = 232
    Width = 41
    Height = 21
    TabOrder = 19
    OnExit = edYLenExit
  end
  object edYAmp: TEdit
    Left = 128
    Top = 232
    Width = 41
    Height = 21
    TabOrder = 20
    OnExit = edYAmpExit
  end
  object edYOfs: TEdit
    Left = 192
    Top = 232
    Width = 41
    Height = 21
    TabOrder = 21
    OnExit = edYOfsExit
  end
end
