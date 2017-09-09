object frameWhiteBlack: TframeWhiteBlack
  Left = 0
  Top = 0
  Width = 375
  Height = 156
  TabOrder = 0
  OnResize = FrameResize
  object spltWhiteBlack: TSplitter
    Left = 0
    Top = 66
    Width = 375
    Height = 8
    Cursor = crVSplit
    Align = alTop
    Beveled = True
  end
  object lblWhiteList: TLabel
    Left = 0
    Top = 0
    Width = 58
    Height = 13
    Align = alTop
    Alignment = taCenter
    Caption = 'White List'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblBlackList: TLabel
    Left = 0
    Top = 74
    Width = 57
    Height = 13
    Align = alTop
    Alignment = taCenter
    Caption = 'Black List'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object memWhiteList: TMemo
    Left = 0
    Top = 13
    Width = 375
    Height = 53
    Hint = 
      'When you receive mail from the following list of e-mail addresse' +
      's,'#13#10'the messages won'#39't be deleted by rules.'
    Align = alTop
    ScrollBars = ssVertical
    TabOrder = 0
    OnChange = memListChange
    OnExit = memWhiteListExit
    OnMouseDown = HelpMouseDown
  end
  object memBlackList: TMemo
    Left = 0
    Top = 87
    Width = 375
    Height = 69
    Hint = 
      'Any mail received from the following e-mail addresses'#13#10'will auto' +
      'matically be deleted.'
    Align = alClient
    ScrollBars = ssVertical
    TabOrder = 1
    OnChange = memListChange
    OnExit = memBlackListExit
    OnMouseDown = HelpMouseDown
  end
end
