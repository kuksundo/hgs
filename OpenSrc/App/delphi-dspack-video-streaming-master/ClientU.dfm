object ClientF: TClientF
  Left = 745
  Top = 376
  Width = 346
  Height = 404
  Caption = 'VideoCoDec Demo Client'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object imgDisplay: TImage
    Left = 8
    Top = 8
    Width = 320
    Height = 240
    Center = True
    Proportional = True
  end
  object Panel1: TPanel
    Left = 0
    Top = 268
    Width = 338
    Height = 98
    Align = alBottom
    BevelInner = bvLowered
    TabOrder = 0
    DesignSize = (
      338
      98)
    object Label1: TLabel
      Left = 8
      Top = 12
      Width = 22
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'Host'
    end
    object Label2: TLabel
      Left = 216
      Top = 12
      Width = 19
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'Port'
    end
    object txtHost: TEdit
      Left = 8
      Top = 30
      Width = 201
      Height = 21
      Anchors = [akLeft, akBottom]
      BevelKind = bkFlat
      BorderStyle = bsNone
      TabOrder = 0
      Text = '192.168.1.31'
    end
    object txtPort: TEdit
      Left = 216
      Top = 30
      Width = 113
      Height = 21
      Anchors = [akLeft, akBottom]
      BevelKind = bkFlat
      BorderStyle = bsNone
      TabOrder = 1
      Text = '33000'
    end
    object btnConnect: TButton
      Left = 8
      Top = 61
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Connect'
      TabOrder = 2
      OnClick = btnConnectClick
    end
    object btnDisconnect: TButton
      Left = 96
      Top = 61
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Disconnect'
      Enabled = False
      TabOrder = 3
      OnClick = btnDisconnectClick
    end
  end
  object TCPClient: TIdTCPClient
    MaxLineAction = maException
    ReadTimeout = 0
    OnDisconnected = TCPClientDisconnected
    OnConnected = TCPClientConnected
    Port = 0
    Left = 16
    Top = 16
  end
  object tmrDisplay: TTimer
    Enabled = False
    OnTimer = tmrDisplayTimer
    Left = 80
    Top = 16
  end
end
