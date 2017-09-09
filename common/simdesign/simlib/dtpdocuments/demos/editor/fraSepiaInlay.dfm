inherited frSepiaInlay: TfrSepiaInlay
  object Label1: TLabel [0]
    Left = 16
    Top = 32
    Width = 32
    Height = 13
    Caption = 'Depth:'
  end
  object lbDepth: TLabel [1]
    Left = 80
    Top = 32
    Width = 37
    Height = 13
    Caption = 'lbDepth'
  end
  inherited pnlEffectName: TPanel
    Caption = 'Sepia'
  end
  object trbDepth: TTrackBar
    Left = 8
    Top = 48
    Width = 249
    Height = 25
    Max = 255
    Orientation = trHorizontal
    PageSize = 50
    Frequency = 10
    Position = 0
    SelEnd = 0
    SelStart = 0
    TabOrder = 1
    ThumbLength = 15
    TickMarks = tmBottomRight
    TickStyle = tsNone
    OnChange = trbDepthChange
  end
end
