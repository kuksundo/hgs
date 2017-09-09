inherited frShape: TfrShape
  object Label1: TLabel [0]
    Left = 8
    Top = 376
    Width = 62
    Height = 13
    Caption = 'Master Alpha'
  end
  object Label2: TLabel [1]
    Left = 8
    Top = 352
    Width = 70
    Height = 13
    Caption = 'Rotation Angle'
  end
  object lbAlpha: TLabel [2]
    Left = 232
    Top = 376
    Width = 35
    Height = 13
    Caption = 'lbAlpha'
  end
  object Label3: TLabel [3]
    Left = 8
    Top = 296
    Width = 18
    Height = 13
    Caption = 'Left'
  end
  object Label4: TLabel [4]
    Left = 136
    Top = 296
    Width = 19
    Height = 13
    Caption = 'Top'
  end
  object Label5: TLabel [5]
    Left = 8
    Top = 320
    Width = 28
    Height = 13
    Caption = 'Width'
  end
  object Label6: TLabel [6]
    Left = 136
    Top = 320
    Width = 31
    Height = 13
    Caption = 'Height'
  end
  object lbAnchors: TLabel [7]
    Left = 88
    Top = 266
    Width = 47
    Height = 13
    Caption = 'lbAnchors'
  end
  inherited pnlTitle: TPanel
    TabOrder = 6
  end
  object trbAlpha: TTrackBar
    Left = 88
    Top = 374
    Width = 137
    Height = 25
    Max = 255
    Orientation = trHorizontal
    Frequency = 1
    Position = 0
    SelEnd = 0
    SelStart = 0
    TabOrder = 5
    ThumbLength = 15
    TickMarks = tmBottomRight
    TickStyle = tsNone
    OnChange = trbAlphaChange
  end
  object edAngle: TEdit
    Left = 96
    Top = 348
    Width = 97
    Height = 21
    TabOrder = 4
    OnExit = edAngleExit
  end
  object edLeft: TEdit
    Left = 48
    Top = 292
    Width = 73
    Height = 21
    TabOrder = 0
    OnExit = edLeftExit
  end
  object edTop: TEdit
    Left = 176
    Top = 292
    Width = 73
    Height = 21
    TabOrder = 1
    OnExit = edTopExit
  end
  object edWidth: TEdit
    Left = 48
    Top = 316
    Width = 73
    Height = 21
    TabOrder = 2
    OnExit = edWidthExit
  end
  object edHeight: TEdit
    Left = 176
    Top = 316
    Width = 73
    Height = 21
    TabOrder = 3
    OnExit = edHeightExit
  end
  object btnAnchors: TButton
    Left = 8
    Top = 260
    Width = 75
    Height = 25
    Caption = 'Set Anchors'
    TabOrder = 7
    OnClick = btnAnchorsClick
  end
  object btnPermissions: TButton
    Left = 168
    Top = 260
    Width = 83
    Height = 25
    Caption = 'Permissions'
    TabOrder = 8
    OnClick = btnPermissionsClick
  end
end
