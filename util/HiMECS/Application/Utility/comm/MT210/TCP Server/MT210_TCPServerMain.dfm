object ServerFrmMain: TServerFrmMain
  Left = 655
  Top = 306
  Caption = 'MT210 TCP-Server'
  ClientHeight = 349
  ClientWidth = 536
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Protocol: TMemo
    Left = 0
    Top = 33
    Width = 536
    Height = 297
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Lucida Console'
    Font.Pitch = fpFixed
    Font.Style = []
    ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 330
    Width = 536
    Height = 19
    Panels = <>
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 536
    Height = 33
    Align = alTop
    TabOrder = 2
    object Label1: TLabel
      Left = 184
      Top = 8
      Width = 14
      Height = 13
      Caption = 'IP:'
    end
    object Label2: TLabel
      Left = 208
      Top = 8
      Width = 87
      Height = 13
      Caption = '                             '
    end
    object Label3: TLabel
      Left = 304
      Top = 8
      Width = 24
      Height = 13
      Caption = 'Port:'
    end
    object Label4: TLabel
      Left = 328
      Top = 8
      Width = 87
      Height = 13
      Caption = '                             '
    end
    object CBServerActive: TCheckBox
      Left = 4
      Top = 4
      Width = 57
      Height = 17
      Caption = 'active'
      TabOrder = 0
      OnClick = CBServerActiveClick
    end
    object Button1: TButton
      Left = 440
      Top = 4
      Width = 75
      Height = 25
      Caption = 'Hide'
      TabOrder = 1
      OnClick = Button1Click
    end
  end
  object Server: TIdTCPServer
    Bindings = <>
    CommandHandlers = <>
    DefaultPort = 47110
    Greeting.NumericCode = 0
    MaxConnectionReply.NumericCode = 0
    OnConnect = ServerConnect
    OnExecute = ServerExecute
    OnDisconnect = ServerDisconnect
    ReplyExceptionCode = 0
    ReplyTexts = <>
    ReplyUnknownCommand.NumericCode = 0
    ThreadMgr = IdThreadMgrDefault1
    Left = 72
    Top = 36
  end
  object IdThreadMgrDefault1: TIdThreadMgrDefault
    Left = 40
    Top = 36
  end
  object MainMenu1: TMainMenu
    Left = 104
    Top = 40
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
    object rlsmd1: TMenuItem
      Caption = #46041#51089
      object StopMonitor1: TMenuItem
        Caption = 'Stop Monitor'
        OnClick = StopMonitor1Click
      end
      object StartMonitor1: TMenuItem
        Caption = 'Start Monitor'
        OnClick = StartMonitor1Click
      end
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 168
    Top = 40
  end
  object PopupMenu1: TPopupMenu
    Left = 136
    Top = 40
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
  object TrayIcon1: TCoolTrayIcon
    CycleInterval = 400
    Hint = 'MT210 Server'
    Icon.Data = {
      000001000200101010000000040028010000260000002020100000000400E802
      00004E0100002800000010000000200000000100040000000000800000000000
      0000000000001000000010000000000000000000800000800000008080008000
      00008000800080800000C0C0C000808080000000FF0000FF000000FFFF00FF00
      0000FF00FF00FFFF0000FFFFFF00DDDDDDDDDDDD0DDDD00000DD0DD0D0DDD0DD
      DDDD0D0DDD0DD00000DD0D0DDD0DDDDDD0D00DD0D0DDD00000DD0DDD0DDDDDDD
      DDDDDDDDDDDDD0DDDDD0DDDD0DDDD0DDDDD0DDDD0DDDD0DDDDD0DDDD0DDDD0DD
      DDD0DDDD0DDDD0D00DD0DDDD0DDDD00DD0D0DDDD0DDDD0DDDD00DD00000DDDDD
      DDDDDDDDDDDDDDDDDDDDDDDDDDDD000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000280000002000000040000000010004000000
      0000000200000000000000000000100000001000000000000000000080000080
      000000808000800000008000800080800000C0C0C000808080000000FF0000FF
      000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000000
      0000000000000DDDDDDDDDDDDDDDDDDDDDDDDDDDDDD00DDDDDDDDDDDDDDDDDDD
      DDDDDDDDDDD00DDDDDDDDDDDDDDDDDDDDDDDDDDDDDD00DDDDDDDDDDDDDDDDDDD
      DDDDDDDDDDD00DDDDDDDDDDDDDDDDDDDDDDDDDDDDDD00DDD00DDD0000DDDD000
      DDD00DD00DD00DDD00DD0DDD00DD0DDD0DD00DD00DD00DDD00D00DDDDDD00DDD
      00D00D000DD00DDD00D00DDDDDD00DDD00D00D000DD00DDD00D00DDDDDD00DDD
      00D000D00DD00DDD00D00DDDDDD00DDD00D000D00DD00DDD00DD0DDD00DD0DDD
      0DD00DD00DD00DDD00DDD0000DDDD000DDD00DD00DD00DDDDDDDDDDDDDDDDDDD
      DDDDDDDDDDD00DDDDDDDDDDDDDDDDDDDDDDDDDDDDDD00DDDDDDDDDDDDDDDDDDD
      DDDDDDDDDDD00DDDDDDD00DD00DD00DDDD00DDDDDDD00DDDDDDD00DD00DD00DD
      DD00DDDDDDD00DDDDDDD00D0000D00DDDD00DDDDDDD00DDDDDDD00D0000D00DD
      DD00DDDDDDD00DDDDDDD0000DD0000DDDD00DDDDDDD00DDDDDDD0000DD0000DD
      DD00DDDDDDD00DDDDDDD000DDDD000DDDD00DDDDDDD00DDDDDDD000DDDD000DD
      DD00DDDDDDD00DDDDDDD00DDDDDD00DDDD00DDDDDDD00DDDDDDD00DDDDDD00D0
      0000000DDDD00DDDDDDDDDDDDDDDDDDDDDDDDDDDDDD00DDDDDDDDDDDDDDDDDDD
      DDDDDDDDDDD00DDDDDDDDDDDDDDDDDDDDDDDDDDDDDD00DDDDDDDDDDDDDDDDDDD
      DDDDDDDDDDD00000000000000000000000000000000000000000000000000000
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
    Top = 42
  end
end
