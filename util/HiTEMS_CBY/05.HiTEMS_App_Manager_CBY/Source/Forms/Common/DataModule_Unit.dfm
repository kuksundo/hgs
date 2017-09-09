object DM1: TDM1
  OldCreateOrder = False
  Height = 357
  Width = 593
  object OraTransaction1: TOraTransaction
    DefaultSession = OraSession1
    Left = 200
    Top = 56
  end
  object OraSession1: TOraSession
    Options.Charset = 'KO16KSC5601'
    Options.UseOCI7 = True
    Options.Direct = True
    Username = 'HITEMS'
    Password = 'HITEMS'
    Server = '10.100.23.114:1521:TBACS'
    Connected = True
    LoginPrompt = False
    Schema = 'HITEMS'
    Left = 200
    Top = 104
  end
  object OraQuery1: TOraQuery
    Session = OraSession1
    Options.TemporaryLobUpdate = True
    Left = 232
    Top = 152
  end
end
