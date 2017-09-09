object DM1: TDM1
  OldCreateOrder = False
  Height = 402
  Width = 650
  object OraSession1: TOraSession
    Options.Charset = 'KO16KSC5601'
    Options.Direct = True
    Username = 'HiTEMS'
    Password = 'HiTEMS'
    Server = '10.100.23.114:1521:TBACS'
    Connected = True
    LoginPrompt = False
    Schema = 'HiTEMS'
    Left = 144
    Top = 120
  end
  object OraQuery1: TOraQuery
    Session = OraSession1
    Left = 224
    Top = 120
  end
  object OraTransaction1: TOraTransaction
    DefaultSession = OraSession1
    Left = 48
    Top = 120
  end
end
