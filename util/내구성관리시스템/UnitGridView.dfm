object GridViewF: TGridViewF
  Left = 0
  Top = 0
  Caption = 'Grid View'
  ClientHeight = 597
  ClientWidth = 621
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inline TFrame11: TFrame1
    Left = 0
    Top = 0
    Width = 621
    Height = 597
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 621
    ExplicitHeight = 597
    inherited Panel1: TPanel
      Width = 621
      ExplicitWidth = 621
    end
    inherited NextGrid1: TNextGrid
      Width = 621
      Height = 466
      Options = [goHeader, goMultiSelect, goSelectFullRow]
      PopupMenu = PopupMenu1
      ExplicitWidth = 621
      ExplicitHeight = 466
    end
    inherited Panel2: TPanel
      Top = 515
      Width = 621
      ExplicitTop = 515
      ExplicitWidth = 621
    end
    inherited StatusBar1: TStatusBar
      Top = 570
      Width = 621
      ExplicitTop = 570
      ExplicitWidth = 621
    end
  end
  object Button1: TButton
    Left = 512
    Top = 18
    Width = 75
    Height = 25
    Caption = 'Excel'
    TabOrder = 1
  end
  object PopupMenu1: TPopupMenu
    Left = 504
    Top = 8
    object Sum1: TMenuItem
      Caption = 'Sum'
      OnClick = Sum1Click
    end
    object Average1: TMenuItem
      Caption = 'Average'
      OnClick = Average1Click
    end
    object Min1: TMenuItem
      Caption = 'Min'
      OnClick = Min1Click
    end
    object Max1: TMenuItem
      Caption = 'Max'
      OnClick = Max1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object SetColumn1: TMenuItem
      Caption = 'Set Calc Column'
      OnClick = SetColumn1Click
    end
  end
end
