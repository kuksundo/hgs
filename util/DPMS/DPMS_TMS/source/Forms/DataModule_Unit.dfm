object DM1: TDM1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 585
  Width = 730
  object OraQuery1: TOraQuery
    Session = OraSession1
    FetchAll = True
    Options.TemporaryLobUpdate = True
    Left = 312
    Top = 40
  end
  object OraTransaction1: TOraTransaction
    DefaultSession = OraSession1
    Left = 168
    Top = 40
  end
  object OraDataSource1: TOraDataSource
    DataSet = OraQuery1
    Left = 320
    Top = 120
  end
  object OraQuery2: TOraQuery
    Session = OraSession1
    FetchAll = True
    Options.TemporaryLobUpdate = True
    Left = 360
    Top = 40
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
    Left = 232
    Top = 40
    EncryptedPassword = 'B4FFBEFFCFFFCCFF'
  end
end
