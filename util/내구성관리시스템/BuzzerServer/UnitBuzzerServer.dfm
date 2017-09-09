object BuzzerServerF: TBuzzerServerF
  Left = 0
  Top = 0
  Caption = 'Buzzer Server'
  ClientHeight = 427
  ClientWidth = 688
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
  inline TFrameCommServer1: TFrameCommServer
    Left = 0
    Top = 0
    Width = 688
    Height = 427
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 688
    ExplicitHeight = 427
    inherited Splitter1: TSplitter
      Width = 688
      ExplicitWidth = 688
    end
    inherited PageControl1: TPageControl
      Width = 688
      ExplicitWidth = 688
      inherited TabSheet1: TTabSheet
        ExplicitLeft = 4
        ExplicitTop = 24
        ExplicitWidth = 680
        ExplicitHeight = 165
        inherited lvConnections: TListView
          Width = 680
          ExplicitWidth = 680
        end
      end
    end
    inherited PageControl2: TPageControl
      Width = 688
      Height = 79
      ExplicitWidth = 688
      ExplicitHeight = 79
      inherited TabSheet4: TTabSheet
        ExplicitWidth = 680
        ExplicitHeight = 51
        inherited SMUDPSysLog: TSynMemo
          Width = 680
          Height = 51
          ExplicitWidth = 680
          ExplicitHeight = 51
        end
      end
    end
    inherited Panel1: TPanel
      Width = 688
      ExplicitWidth = 688
    end
    inherited Panel2: TPanel
      Width = 688
      ExplicitWidth = 688
    end
    inherited AdvOfficeStatusBar1: TAdvOfficeStatusBar
      Top = 408
      Width = 688
      ExplicitTop = 408
      ExplicitWidth = 688
    end
    inherited MainMenu1: TMainMenu
      inherited rlsmd1: TMenuItem
        inherited StartMonitor1: TMenuItem
          OnClick = TFrameCommServer1StartMonitor1Click
        end
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 16
    Top = 8
    object Etc1: TMenuItem
      Caption = 'Etc'
      object LampTest1: TMenuItem
        Caption = 'Lamp Test'
        OnClick = LampTest1Click
      end
    end
  end
end
