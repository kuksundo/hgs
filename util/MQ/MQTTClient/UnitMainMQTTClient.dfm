object MQTTClientF: TMQTTClientF
  Left = 0
  Top = 0
  Caption = 'MQTT Client'
  ClientHeight = 709
  ClientWidth = 967
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inline FrameMQTTClient: TFrameMQTTClient
    Left = 0
    Top = 0
    Width = 967
    Height = 709
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 967
    ExplicitHeight = 709
    inherited Splitter1: TSplitter
      Width = 967
      ExplicitWidth = 967
    end
    inherited PageControl1: TPageControl
      Width = 967
      ExplicitWidth = 967
      inherited TabSheet1: TTabSheet
        ExplicitWidth = 959
        inherited lvConnections: TListView
          Width = 959
          ExplicitWidth = 959
        end
      end
    end
    inherited PageControl2: TPageControl
      Width = 967
      Height = 361
      ExplicitWidth = 967
      ExplicitHeight = 361
      inherited TabSheet4: TTabSheet
        ExplicitWidth = 959
        ExplicitHeight = 333
        inherited SMSysLog: TMemo
          Width = 959
          Height = 333
          ExplicitWidth = 959
          ExplicitHeight = 333
        end
      end
    end
    inherited Panel1: TPanel
      Width = 967
      ExplicitWidth = 967
    end
    inherited Panel2: TPanel
      Width = 967
      ExplicitWidth = 967
      inherited ServerConnectBtn: TJvXPButton
        OnClick = FrameMQTTClientServerConnectBtnClick
      end
      inherited ServerDisconnectBtn: TJvXPButton
        OnClick = FrameMQTTClientServerDisconnectBtnClick
      end
      inherited ServerPingBtn: TJvXPButton
        OnClick = FrameMQTTClientServerPingBtnClick
      end
      inherited PublishBtn: TJvXPButton
        OnClick = FrameMQTTClientPublishBtnClick
      end
      inherited SubscribeBtn: TJvXPButton
        OnClick = FrameMQTTClientSubscribeBtnClick
      end
    end
    inherited AdvOfficeStatusBar1: TAdvOfficeStatusBar
      Top = 690
      Width = 967
      ExplicitTop = 690
      ExplicitWidth = 967
    end
  end
end
