object DM1: TDM1
  OldCreateOrder = False
  Height = 296
  Width = 349
  object OraTransaction1: TOraTransaction
    DefaultSession = OraSession1
    Left = 144
    Top = 72
  end
  object OraSession1: TOraSession
    Options.Charset = 'KO16KSC5601'
    Options.UseOCI7 = True
    Options.Direct = True
    Username = 'KA03'
    Server = '10.100.17.215:1521:HIDB'
    Connected = True
    LoginPrompt = False
    Schema = 'KA03'
    Left = 144
    Top = 120
    EncryptedPassword = 'B4FFBEFFCFFFCCFF'
  end
  object OraQuery1: TOraQuery
    Session = OraSession1
    Options.TemporaryLobUpdate = True
    Left = 144
    Top = 168
  end
end
