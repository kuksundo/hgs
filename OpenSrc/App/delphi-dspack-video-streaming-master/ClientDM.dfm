object dmClient: TdmClient
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 215
  Top = 123
  Height = 171
  Width = 205
  object TCPClient: TIdTCPClient
    MaxLineAction = maException
    ReadTimeout = 0
    OnDisconnected = TCPClientDisconnected
    OnConnected = TCPClientConnected
    Port = 0
    Left = 44
    Top = 24
  end
  object tmrDisplay: TTimer
    Enabled = False
    OnTimer = tmrDisplayTimer
    Left = 116
    Top = 24
  end
end
