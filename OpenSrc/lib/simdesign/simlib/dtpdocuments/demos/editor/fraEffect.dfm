inherited frEffect: TfrEffect
  object Label1: TLabel [0]
    Left = 0
    Top = 32
    Width = 78
    Height = 13
    Caption = 'Installed Effects:'
  end
  object Label2: TLabel [1]
    Left = 160
    Top = 32
    Width = 82
    Height = 13
    Caption = 'Available Effects:'
  end
  object clbInstalled: TCheckListBox
    Left = 0
    Top = 48
    Width = 105
    Height = 105
    OnClickCheck = clbInstalledClickCheck
    ItemHeight = 13
    TabOrder = 3
    OnClick = clbInstalledClick
  end
  object lbAvailable: TListBox
    Left = 160
    Top = 48
    Width = 105
    Height = 105
    ItemHeight = 13
    TabOrder = 4
  end
  object btnAddEffect: TButton
    Left = 112
    Top = 48
    Width = 41
    Height = 25
    Caption = '<'
    TabOrder = 5
    OnClick = btnAddEffectClick
  end
  object btnRemoveEffect: TButton
    Left = 112
    Top = 75
    Width = 41
    Height = 25
    Caption = '>'
    TabOrder = 6
    OnClick = btnRemoveEffectClick
  end
  object btnEffectUp: TButton
    Left = 112
    Top = 101
    Width = 41
    Height = 25
    Caption = 'Up'
    TabOrder = 7
    OnClick = btnEffectUpClick
  end
  object btnEffectDn: TButton
    Left = 112
    Top = 128
    Width = 41
    Height = 25
    Caption = 'Dn'
    TabOrder = 8
    OnClick = btnEffectDnClick
  end
  object pnlEffect: TPanel
    Left = 0
    Top = 160
    Width = 270
    Height = 217
    BevelOuter = bvNone
    TabOrder = 9
  end
end
