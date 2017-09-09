object ClientFrmMain: TClientFrmMain
  Left = 192
  Top = 217
  Caption = 'MEXA7000 TCP Client'
  ClientHeight = 264
  ClientWidth = 415
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 4
    Top = 28
    Width = 95
    Height = 13
    Caption = 'incoming messages:'
  end
  object Label5: TLabel
    Left = 140
    Top = 18
    Width = 42
    Height = 13
    Caption = 'Local IP:'
  end
  object Label6: TLabel
    Left = 140
    Top = 34
    Width = 38
    Height = 13
    Caption = 'Host IP:'
  end
  object Label7: TLabel
    Left = 188
    Top = 18
    Width = 93
    Height = 13
    Caption = '                               '
  end
  object Label8: TLabel
    Left = 182
    Top = 34
    Width = 93
    Height = 13
    Caption = '                               '
  end
  object Label9: TLabel
    Left = 276
    Top = 34
    Width = 22
    Height = 13
    Caption = 'Port:'
  end
  object Label10: TLabel
    Left = 300
    Top = 35
    Width = 45
    Height = 13
    Caption = '               '
  end
  object CBClientActive: TCheckBox
    Left = 4
    Top = 4
    Width = 65
    Height = 17
    Caption = 'active'
    TabOrder = 0
    OnClick = CBClientActiveClick
  end
  object IncomingMessages: TMemo
    Left = 0
    Top = 76
    Width = 415
    Height = 169
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 245
    Width = 415
    Height = 19
    Panels = <>
  end
  object Button1: TButton
    Left = 332
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Hide'
    TabOrder = 3
    OnClick = Button1Click
  end
  object Client: TIdTCPClient
    MaxLineAction = maException
    ReadTimeout = 10000
    Port = 0
    Left = 96
    Top = 56
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 56
    Top = 56
  end
  object MainMenu1: TMainMenu
    Left = 136
    Top = 56
    object N1: TMenuItem
      Caption = #49444#51221
      object N2: TMenuItem
        Caption = #54252#53944#49444#51221
        OnClick = N2Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object N4: TMenuItem
        Caption = #51333#47308
        OnClick = N4Click
      end
    end
  end
  object TrayIcon1: TCoolTrayIcon
    CycleInterval = 400
    Hint = 'MEXA7000 TCP Client'
    Icon.Data = {
      000001000200101010000000040028010000260000002020100000000400E802
      00004E0100002800000010000000200000000100040000000000800000000000
      0000000000001000000010000000000000000000800000800000008080008000
      00008000800080800000C0C0C000808080000000FF0000FF000000FFFF00FF00
      0000FF00FF00FFFF0000FFFFFF00AAAAAAAAAAAAAAAAA00AAA00A0AAAA0AAA00
      A00AA0AAAA0AAAA000AAA0A00A0AAAA000AAAA0AA0AAAA00A00AAAA00AAAA00A
      AA00AAA00AAAAAAAAAAAAAAAAAAAA0AAAAA0AA00000AA0AAAAA0AA0AAAAAA0AA
      0AA0AA0000AAA0A0A0A0AA0AAAAAA00AAA00AA0AAAAAA0AAAAA0AA00000AAAAA
      AAAAAAAAAAAAAAAAAAAAAAAAAAAA000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000280000002000000040000000010004000000
      0000000200000000000000000000100000001000000000000000000080000080
      000000808000800000008000800080800000C0C0C000808080000000FF0000FF
      000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000000
      0000000000000AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA00AAAAAAAAAAAAAAAAAAA
      AAAAAAAAAAA00AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA00AAAAAAAAAAAAAAAAAAA
      AAAAAAAAAAA00AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA00AAA00AAA0000AAAA000
      AAA00AA00AA00AAA00AA0AAA00AA0AAA0AA00AA00AA00AAA00A00AAAAAA00AAA
      00A00A000AA00AAA00A00AAAAAA00AAA00A00A000AA00AAA00A00AAAAAA00AAA
      00A000A00AA00AAA00A00AAAAAA00AAA00A000A00AA00AAA00AA0AAA00AA0AAA
      0AA00AA00AA00AAA00AAA0000AAAA000AAA00AA00AA00AAAAAAAAAAAAAAAAAAA
      AAAAAAAAAAA00AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA00AAAAAAAAAAAAAAAAAAA
      AAAAAAAAAAA00AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA00A0AAAAA0A0000A00AAA
      A0A00AAA00A00A0AAAAA0A0AAAAA00AA00A00AAA00A00A0AAAAA0A0AAAAAA000
      0AAA00000AA00A0AAAAA0A0AAAAAAA00AAAA00A00AA00A0AAAAA0A0000AAA000
      AAAA00A00AA00A0AA0AA0A0AAAAA00A00AAAA0A0AAA00A0A0A0A0A0AAAA00AAA
      00AAA000AAA00A00AAA00A0AAAA0AAAAA0AAAA0AAAA00A0AAAAA0A0000A0AAAA
      A0AAAA0AAAA00AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA00AAAAAAAAAAAAAAAAAAA
      AAAAAAAAAAA00AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA00AAAAAAAAAAAAAAAAAAA
      AAAAAAAAAAA00000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000}
    IconVisible = True
    IconIndex = 0
    PopupMenu = PopupMenu1
    WantEnterExitEvents = True
    OnDblClick = TrayIcon1DblClick
    Left = 8
    Top = 58
  end
  object PopupMenu1: TPopupMenu
    Left = 168
    Top = 56
    object MenuItem1: TMenuItem
      Caption = #54868#47732#48372#51060#44592'(Show)'
      OnClick = MenuItem1Click
    end
    object MenuItem2: TMenuItem
      Caption = '-'
    end
    object MenuItem3: TMenuItem
      Caption = #51060' '#54532#47196#44536#47016#50640' '#45824#54616#50668'...(About)'
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object MenuItem4: TMenuItem
      Caption = #45149#45236#44592'(Exit)'
      OnClick = MenuItem4Click
    end
  end
end
