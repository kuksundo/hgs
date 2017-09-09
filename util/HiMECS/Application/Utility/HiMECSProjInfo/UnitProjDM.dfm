object DM1: TDM1
  OldCreateOrder = False
  Height = 190
  Width = 212
  object OraSession1: TOraSession
    Options.Direct = True
    Username = 'KE99'
    Server = '10.100.23.72:1521:EMD'
    Connected = True
    LoginPrompt = False
    Left = 56
    Top = 72
    EncryptedPassword = '94FF9AFFC6FFC6FFCFFFCBFFCEFFCDFFDBFFDBFF'
  end
  object OraTransaction1: TOraTransaction
    DefaultSession = OraSession1
    Left = 56
    Top = 24
  end
  object OraQuery1: TOraQuery
    Session = OraSession1
    SQL.Strings = (
      'select * from EBOM.SVW_TKCBA001 where SHIPNO = '#39'1755'#39)
    Left = 56
    Top = 118
  end
  object OraQuery2: TOraQuery
    Session = OraSession1
    Left = 104
    Top = 118
  end
end
