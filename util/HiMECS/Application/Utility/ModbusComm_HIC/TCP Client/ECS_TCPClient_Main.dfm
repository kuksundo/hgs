object ClientFrmMain: TClientFrmMain
  Left = 192
  Top = 217
  Caption = 'ClientFrmMain'
  ClientHeight = 269
  ClientWidth = 398
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
  object Splitter1: TSplitter
    Left = 0
    Top = 73
    Width = 398
    Height = 3
    Cursor = crVSplit
    Align = alTop
    ExplicitWidth = 79
  end
  object IncomingMessages: TMemo
    Left = 0
    Top = 76
    Width = 398
    Height = 174
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 250
    Width = 398
    Height = 19
    Panels = <>
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 398
    Height = 73
    Align = alTop
    TabOrder = 2
    object Label5: TLabel
      Left = 144
      Top = 8
      Width = 42
      Height = 13
      Caption = 'Local IP:'
    end
    object Label7: TLabel
      Left = 192
      Top = 8
      Width = 93
      Height = 13
      Caption = '                               '
    end
    object Label6: TLabel
      Left = 144
      Top = 24
      Width = 38
      Height = 13
      Caption = 'Host IP:'
    end
    object Label8: TLabel
      Left = 186
      Top = 24
      Width = 93
      Height = 13
      Caption = '                               '
    end
    object Label9: TLabel
      Left = 280
      Top = 24
      Width = 22
      Height = 13
      Caption = 'Port:'
    end
    object Label10: TLabel
      Left = 304
      Top = 25
      Width = 45
      Height = 13
      Caption = '               '
    end
    object Label1: TLabel
      Left = 276
      Top = 5
      Width = 70
      Height = 13
      Caption = 'Tot Sim Count:'
    end
    object Label2: TLabel
      Left = 355
      Top = 6
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
    object Button1: TButton
      Left = 315
      Top = 44
      Width = 75
      Height = 25
      Caption = 'Hide'
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button3: TButton
      Left = 105
      Top = 43
      Width = 75
      Height = 25
      Caption = 'Step'
      Enabled = False
      TabOrder = 2
      OnClick = Button3Click
    end
    object Button2: TButton
      Left = 8
      Top = 41
      Width = 75
      Height = 25
      Caption = 'Pause'
      Enabled = False
      TabOrder = 3
      OnClick = Button2Click
    end
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
      object N6: TMenuItem
        Caption = '-'
      end
      object SimulateCommunication1: TMenuItem
        Caption = 'Simulate Communication'
        OnClick = SimulateCommunication1Click
      end
      object SimulateCommunicationwithstep1: TMenuItem
        Caption = 'Simulate Communication with step'
        OnClick = SimulateCommunicationwithstep1Click
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
  object IdTCPClient1: TIdTCPClient
    ConnectTimeout = 0
    IPVersion = Id_IPv4
    Port = 0
    ReadTimeout = -1
    Left = 16
    Top = 56
  end
  object JvOpenDialog1: TJvOpenDialog
    Filter = '*.himecs||*.*'
    Options = [ofHideReadOnly, ofNoTestFileCreate, ofEnableSizing]
    Height = 425
    Width = 656
    Left = 200
    Top = 56
  end
end
