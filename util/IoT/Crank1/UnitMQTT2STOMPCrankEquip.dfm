object Form8: TForm8
  Left = 0
  Top = 0
  Caption = 'STOMP Publisher'
  ClientHeight = 515
  ClientWidth = 924
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
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 481
    Top = 129
    Height = 357
    ExplicitLeft = 448
    ExplicitTop = 280
    ExplicitHeight = 100
  end
  object Memo1: TMemo
    Left = 0
    Top = 129
    Width = 481
    Height = 357
    Align = alLeft
    ImeName = 'Microsoft IME 2010'
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 924
    Height = 129
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 24
      Top = 48
      Width = 96
      Height = 13
      Caption = 'MQTT Server Port : '
    end
    object Label2: TLabel
      Left = 34
      Top = 21
      Width = 86
      Height = 13
      Caption = 'MQTT Server IP : '
    end
    object Label3: TLabel
      Left = 24
      Top = 75
      Width = 96
      Height = 13
      Caption = 'MQTT Topic Name : '
    end
    object Label4: TLabel
      Left = 376
      Top = 110
      Width = 53
      Height = 13
      Caption = 'MQTT Msg '
    end
    object Label5: TLabel
      Left = 504
      Top = 110
      Width = 59
      Height = 13
      Caption = 'STOMP Msg '
    end
    object Label6: TLabel
      Left = 514
      Top = 21
      Width = 92
      Height = 13
      Caption = 'STOMP Server IP : '
    end
    object Label7: TLabel
      Left = 504
      Top = 48
      Width = 102
      Height = 13
      Caption = 'STOMP Server Port : '
    end
    object Label8: TLabel
      Left = 504
      Top = 75
      Width = 102
      Height = 13
      Caption = 'STOMP Topic Name : '
    end
    object MQServerIPEdit: TEdit
      Left = 119
      Top = 18
      Width = 194
      Height = 21
      ImeName = 'Microsoft IME 2010'
      TabOrder = 0
    end
    object MQServerPortEdit: TEdit
      Left = 119
      Top = 45
      Width = 194
      Height = 21
      ImeName = 'Microsoft IME 2010'
      TabOrder = 1
    end
    object TopicEdit: TEdit
      Left = 119
      Top = 72
      Width = 194
      Height = 21
      ImeName = 'Microsoft IME 2010'
      TabOrder = 2
    end
    object STOMPServerIPEdit: TEdit
      Left = 608
      Top = 18
      Width = 225
      Height = 21
      ImeName = 'Microsoft IME 2010'
      TabOrder = 3
    end
    object STOMPServerPortEdit: TEdit
      Left = 608
      Top = 45
      Width = 225
      Height = 21
      ImeName = 'Microsoft IME 2010'
      TabOrder = 4
    end
    object STOMPServerTopicEdit: TEdit
      Left = 612
      Top = 72
      Width = 221
      Height = 21
      ImeName = 'Microsoft IME 2010'
      TabOrder = 5
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 486
    Width = 924
    Height = 29
    Panels = <>
  end
  object Memo2: TMemo
    Left = 484
    Top = 129
    Width = 440
    Height = 357
    Align = alClient
    ImeName = 'Microsoft IME 2010'
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object MainMenu1: TMainMenu
    Left = 16
    Top = 136
    object File1: TMenuItem
      Caption = 'File'
      object Close1: TMenuItem
        Caption = 'Close'
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
end
