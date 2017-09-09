object STOMP2IPCClientAllF: TSTOMP2IPCClientAllF
  Left = 0
  Top = 0
  Caption = 'STOPM -> IPCClientAll'
  ClientHeight = 629
  ClientWidth = 789
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object MsgWindowMemo: TMemo
    Left = 0
    Top = 129
    Width = 789
    Height = 471
    Align = alClient
    ImeName = 'Microsoft IME 2010'
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 789
    Height = 129
    Align = alTop
    PopupMenu = PopupMenu1
    TabOrder = 1
    object Label1: TLabel
      Left = 24
      Top = 48
      Width = 84
      Height = 13
      Caption = 'MQ Server Port : '
    end
    object Label2: TLabel
      Left = 34
      Top = 21
      Width = 74
      Height = 13
      Caption = 'MQ Server IP : '
    end
    object Label3: TLabel
      Left = 24
      Top = 72
      Width = 84
      Height = 13
      Caption = 'MQ Topic Name : '
    end
    object MQServerIPEdit: TEdit
      Left = 114
      Top = 18
      Width = 121
      Height = 21
      ImeName = 'Microsoft IME 2010'
      TabOrder = 0
    end
    object MQServerPortEdit: TEdit
      Left = 114
      Top = 45
      Width = 121
      Height = 21
      ImeName = 'Microsoft IME 2010'
      TabOrder = 1
    end
    object TopicEdit: TEdit
      Left = 114
      Top = 72
      Width = 121
      Height = 21
      ImeName = 'Microsoft IME 2010'
      TabOrder = 2
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 600
    Width = 789
    Height = 29
    Panels = <>
  end
  object MainMenu1: TMainMenu
    Left = 16
    Top = 136
    object File1: TMenuItem
      Caption = 'File'
      object Close1: TMenuItem
        Caption = 'Close'
        OnClick = Close1Click
      end
    end
    object Option1: TMenuItem
      Caption = 'Option'
      object Config1: TMenuItem
        Caption = 'Config'
        OnClick = Config1Click
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 64
    Top = 136
    object ShowEventName1: TMenuItem
      Caption = 'Show Event Name'
      OnClick = ShowEventName1Click
    end
  end
end
