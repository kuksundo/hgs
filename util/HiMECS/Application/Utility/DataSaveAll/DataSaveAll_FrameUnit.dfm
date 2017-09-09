object DataSaveAllF: TDataSaveAllF
  Left = 0
  Top = 0
  Caption = 'Data Save All'
  ClientHeight = 489
  ClientWidth = 428
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inline TFrameIPCMonitorAll1: TFrameIPCMonitor
    Left = 56
    Top = 122
    Width = 320
    Height = 240
    TabOrder = 2
    ExplicitLeft = 56
    ExplicitTop = 122
  end
  object JvStatusBar1: TJvStatusBar
    Left = 0
    Top = 456
    Width = 428
    Height = 33
    Panels = <
      item
        Width = 100
      end
      item
        Width = 50
      end>
  end
  inline DSA: TFrameDataSaveAll
    Left = 0
    Top = 0
    Width = 428
    Height = 456
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 428
    ExplicitHeight = 456
    inherited Panel1: TPanel
      Width = 428
      ExplicitWidth = 428
    end
    inherited Protocol: TMemo
      Width = 428
      Height = 233
      ExplicitWidth = 428
      ExplicitHeight = 233
    end
    inherited Panel2: TPanel
      Top = 274
      Width = 428
      ExplicitTop = 274
      ExplicitWidth = 428
    end
    inherited MainMenu1: TMainMenu
      inherited HELP1: TMenuItem
        inherited Option1: TMenuItem
          OnClick = TFrameDataSaveAll1Option1Click
        end
      end
    end
    inherited PopupMenu1: TPopupMenu
      inherited ShowEventName1: TMenuItem
        OnClick = TFrameDataSaveAll1ShowEventName1Click
      end
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 320
    Top = 56
  end
end
