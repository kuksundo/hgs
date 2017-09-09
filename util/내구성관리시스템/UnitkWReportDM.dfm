object DataModule4: TDataModule4
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 150
  Width = 215
  object OraQuery1: TOraQuery
    Session = OraSession1
    FetchAll = True
    Options.TemporaryLobUpdate = True
    Left = 143
    Top = 24
  end
  object OraSession1: TOraSession
    Options.UseUnicode = True
    Options.UnicodeEnvironment = True
    Options.Direct = True
    Username = 'HITEMS'
    Server = '10.100.23.114:1521:TBACS'
    LoginPrompt = False
    Schema = 'HITEMS'
    Left = 31
    Top = 24
    EncryptedPassword = 'B7FFB6FFABFFBAFFB2FFACFF'
  end
  object OraTransaction1: TOraTransaction
    DefaultSession = OraSession1
    Left = 88
    Top = 24
  end
end
