object frRulerWindow: TfrRulerWindow
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 320
    Height = 24
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
  end
  object pnlLeft: TPanel
    Left = 0
    Top = 24
    Width = 24
    Height = 216
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
  end
  object pnlCenter: TPanel
    Left = 24
    Top = 24
    Width = 296
    Height = 216
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
  end
end
