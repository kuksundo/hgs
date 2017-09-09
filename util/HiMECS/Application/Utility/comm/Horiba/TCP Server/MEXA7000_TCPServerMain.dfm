object ServerFrmMain: TServerFrmMain
  Left = 655
  Top = 306
  Caption = 'MEXA7000 TCP-Server'
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
  object IdTCPServer1: TIdTCPServer
    Bindings = <>
    DefaultPort = 0
    Left = 72
    Top = 48
  end
end
