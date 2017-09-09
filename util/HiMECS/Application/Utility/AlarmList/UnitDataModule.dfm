object DataModule1: TDataModule1
  OldCreateOrder = False
  Height = 150
  Width = 215
  object OraSession1: TOraSession
    Options.Charset = 'KO16KSC5601'
    Options.Direct = True
    Username = 'HITEMS'
    Server = '10.100.23.114:1521:TBACS'
    Connected = True
    LoginPrompt = False
    Schema = 'HITEMS'
    Left = 88
    Top = 24
    EncryptedPassword = 'B7FFB6FFABFFBAFFB2FFACFF'
  end
  object OraQuery1: TOraQuery
    Session = OraSession1
    FetchAll = True
    Options.TemporaryLobUpdate = True
    Left = 136
    Top = 24
  end
  object OraTransaction1: TOraTransaction
    DefaultSession = OraSession1
    Left = 40
    Top = 24
  end
end
