object DM1: TDM1
  OldCreateOrder = False
  Height = 134
  Width = 329
  object OraSession1: TOraSession
    Options.Charset = 'KO16KSC5601'
    Options.Direct = True
    Username = 'HITEMS'
    Server = '10.100.23.114:1521:TBACS'
    Connected = True
    LoginPrompt = False
    Schema = 'HITEMS'
    Left = 80
    Top = 16
    EncryptedPassword = 'B7FFB6FFABFFBAFFB2FFACFF'
  end
  object OraQuery1: TOraQuery
    Session = OraSession1
    FetchAll = True
    Options.TemporaryLobUpdate = True
    Left = 144
    Top = 16
  end
  object OraTransaction1: TOraTransaction
    DefaultSession = OraSession1
    Left = 24
    Top = 16
  end
  object OraQuery2: TOraQuery
    Session = OraSession1
    FetchAll = True
    Options.TemporaryLobUpdate = True
    Left = 200
    Top = 24
  end
end
