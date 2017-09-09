object DM1: TDM1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 279
  Width = 375
  object OraSession1: TOraSession
    Options.Direct = True
    Username = 'K61'
    Server = '10.100.17.11:1521:HIDB1'
    LoginPrompt = False
    Schema = 'K61'
    Left = 56
    Top = 72
    EncryptedPassword = 'B4FFC9FFCEFF'
  end
  object OraTransaction1: TOraTransaction
    DefaultSession = OraSession1
    Left = 56
    Top = 32
  end
  object OraQuery1: TOraQuery
    Session = OraSession1
    Left = 56
    Top = 120
  end
  object OraQuery2: TOraQuery
    Session = OraSession1
    Left = 48
    Top = 168
  end
end
