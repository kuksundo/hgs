object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 301
  ClientWidth = 467
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ActionToolBar1: TActionToolBar
    Left = 0
    Top = 29
    Width = 467
    Height = 23
    ActionManager = ActionManager1
    Caption = 'ActionToolBar1'
    ColorMap.HighlightColor = 12506296
    ColorMap.BtnSelectedColor = clBtnFace
    ColorMap.UnusedColor = 12506296
    Spacing = 0
    ExplicitLeft = 8
    ExplicitTop = 136
  end
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 467
    Height = 29
    ActionManager = ActionManager1
    Caption = 'ActionMainMenuBar1'
    ColorMap.HighlightColor = 12506296
    ColorMap.BtnSelectedColor = clBtnFace
    ColorMap.UnusedColor = 12506296
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMenuText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    Spacing = 0
    ExplicitLeft = 168
    ExplicitTop = 40
    ExplicitWidth = 150
  end
  object ActionManager1: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Action = RedAction
          end
          item
            Action = GreenAction
          end>
        ActionBar = ActionToolBar1
      end
      item
        Items = <
          item
            Items = <
              item
                Action = GreenAction
              end
              item
                Action = RedAction
              end>
            Caption = '&Color'
          end>
        ActionBar = ActionMainMenuBar1
      end>
    Left = 8
    Top = 72
    StyleName = 'XP Style'
    object GreenAction: TAction
      Category = 'Color'
      Caption = '&Green'
      OnExecute = ColorActionExecute
      OnUpdate = ColorActionUpdate
    end
    object RedAction: TAction
      Category = 'Color'
      Caption = '&Red'
      OnExecute = ColorActionExecute
      OnUpdate = ColorActionUpdate
    end
  end
end
