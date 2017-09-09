object ServerFrmMain: TServerFrmMain
  Left = 192
  Top = 107
  Width = 454
  Height = 221
  Caption = 'TCP-Server'
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
  DesignSize = (
    446
    175)
  PixelsPerInch = 96
  TextHeight = 13
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
    Top = 10
    Width = 24
    Height = 13
    Caption = 'Port:'
  end
  object Label4: TLabel
    Left = 328
    Top = 10
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
  object Protocol: TMemo
    Left = 4
    Top = 28
    Width = 437
    Height = 142
    Anchors = [akLeft, akTop, akRight, akBottom]
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
    TabOrder = 1
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
    Left = 96
    Top = 4
  end
  object IdThreadMgrDefault1: TIdThreadMgrDefault
    Left = 64
    Top = 4
  end
  object MainMenu1: TMainMenu
    Left = 112
    Top = 32
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
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 144
    Top = 40
  end
end
