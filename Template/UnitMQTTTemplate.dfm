object Form9: TForm9
  Left = 0
  Top = 0
  Caption = 'Form9'
  ClientHeight = 593
  ClientWidth = 680
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
  object Memo1: TMemo
    Left = 0
    Top = 129
    Width = 680
    Height = 435
    Align = alClient
    ImeName = 'Microsoft IME 2010'
    ScrollBars = ssVertical
    TabOrder = 0
    ExplicitLeft = -50
    ExplicitWidth = 730
    ExplicitHeight = 425
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 680
    Height = 129
    Align = alTop
    TabOrder = 1
    ExplicitLeft = -50
    ExplicitWidth = 730
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
      Top = 75
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
    Top = 564
    Width = 680
    Height = 29
    Panels = <>
    ExplicitLeft = -50
    ExplicitTop = 554
    ExplicitWidth = 730
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
      end
    end
  end
end
