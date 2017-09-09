object DM1: TDM1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 141
  Width = 233
  object OraTransaction1: TOraTransaction
    DefaultSession = OraSession1
    Left = 152
    Top = 16
  end
  object OraSession1: TOraSession
    Options.Charset = 'KO16KSC5601'
    Options.Direct = True
    Username = 'HiTEMS'
    Server = '10.100.23.114:1521:TBACS'
    LoginPrompt = False
    Schema = 'HiTEMS'
    Left = 32
    Top = 16
    EncryptedPassword = 'B7FF96FFABFFBAFFB2FFACFF'
  end
  object OraQuery1: TOraQuery
    Session = OraSession1
    FetchAll = True
    Options.TemporaryLobUpdate = True
    Left = 95
    Top = 16
  end
  object OraTransaction2: TOraTransaction
    DefaultSession = OraSession2
    Left = 152
    Top = 72
  end
  object OraSession2: TOraSession
    Options.Direct = True
    Username = 'ku02'
    Server = '10.100.17.11:1521:sn=HIDB'
    LoginPrompt = False
    Left = 32
    Top = 72
    EncryptedPassword = '94FF8AFFCFFFCDFFCFFFC8FFCEFFC8FF'
  end
  object OraQuery2: TOraQuery
    Session = OraSession2
    SQL.Strings = (
      'select * from kx01.gtaa004')
    FetchAll = True
    Options.TemporaryLobUpdate = True
    Left = 95
    Top = 72
  end
end
