object Form8: TForm8
  Left = 0
  Top = 0
  Caption = 'Form8'
  ClientHeight = 583
  ClientWidth = 730
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
    Width = 730
    Height = 425
    Align = alClient
    ImeName = 'Microsoft IME 2010'
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 730
    Height = 129
    Align = alTop
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
    object Button1: TButton
      Left = 432
      Top = 24
      Width = 89
      Height = 33
      Caption = 'Button1'
      TabOrder = 3
      OnClick = Button1Click
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 554
    Width = 730
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
      end
    end
    object Option1: TMenuItem
      Caption = 'Option'
      object Config1: TMenuItem
        Caption = 'Config'
      end
    end
  end
  object TrayIcon1: TTrayIcon
    PopupMenu = PopupMenu1
    OnDblClick = TrayIcon1DblClick
    Left = 72
    Top = 136
  end
  object ApplicationEvents1: TApplicationEvents
    OnMinimize = ApplicationEvents1Minimize
    Left = 128
    Top = 136
  end
  object PopupMenu1: TPopupMenu
    Left = 176
    Top = 144
    object N1: TMenuItem
      Caption = '-'
    end
    object Close2: TMenuItem
      Caption = 'Close'
    end
  end
end
