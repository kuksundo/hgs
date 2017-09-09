object DM1: TDM1
  OldCreateOrder = False
  Height = 458
  Width = 714
  object OraSession1: TOraSession
    Options.Charset = 'KO16KSC5601'
    Options.Direct = True
    Username = 'TBACS'
    Server = '10.100.23.114:1521:TBACS'
    Connected = True
    LoginPrompt = False
    Schema = 'TBACS'
    Left = 56
    Top = 296
    EncryptedPassword = 'ABFFBDFFBEFFBCFFACFF'
  end
  object OraQuery1: TOraQuery
    Session = OraSession1
    FetchAll = True
    Options.TemporaryLobUpdate = True
    Left = 128
    Top = 296
  end
  object OraQuery2: TOraQuery
    Session = OraSession1
    FetchAll = True
    Left = 200
    Top = 296
  end
  object OraTransaction1: TOraTransaction
    DefaultSession = OraSession1
    Left = 56
    Top = 248
  end
end
