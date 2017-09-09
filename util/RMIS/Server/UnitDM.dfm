object DM1: TDM1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 260
  Width = 328
  object DPMSSession: TOraSession
    Options.Charset = 'KO16KSC5601'
    Options.Direct = True
    Username = 'kx02'
    Server = '10.100.17.11:1521:HIDB1'
    LoginPrompt = False
    Schema = 'kx02'
    Left = 112
    Top = 16
    EncryptedPassword = '94FF87FFCFFFCDFFCEFFCEFFCDFFCFFF'
  end
  object DPMSQuery1: TOraQuery
    Session = DPMSSession
    FetchAll = True
    Options.TemporaryLobUpdate = True
    Left = 168
    Top = 16
  end
  object DPMSTransaction: TOraTransaction
    DefaultSession = DPMSSession
    Left = 40
    Top = 16
  end
  object DPMSQuery2: TOraQuery
    Session = DPMSSession
    FetchAll = True
    Options.TemporaryLobUpdate = True
    Left = 224
    Top = 16
  end
  object ProductSession: TOraSession
    Options.Charset = 'KO16KSC5601'
    Options.Direct = True
    Username = 'KA03'
    Server = '10.100.17.11:1521:HIDB1'
    LoginPrompt = False
    Schema = 'KA03'
    Left = 110
    Top = 72
    EncryptedPassword = 'B4FFBEFFCFFFCCFFAFFFADFFB0FFBBFF'
  end
  object ProductQuery1: TOraQuery
    Session = ProductSession
    FetchAll = True
    Options.TemporaryLobUpdate = True
    Left = 166
    Top = 72
  end
  object ProductTransaction: TOraTransaction
    DefaultSession = ProductSession
    Left = 38
    Top = 72
  end
  object ProductQuery2: TOraQuery
    Session = ProductSession
    FetchAll = True
    Options.TemporaryLobUpdate = True
    Left = 222
    Top = 72
  end
  object ExtraMHTransaction: TOraTransaction
    DefaultSession = ExtraMHSession
    Left = 32
    Top = 128
  end
  object ExtraMHSession: TOraSession
    Options.Charset = 'KO16KSC5601'
    Options.Direct = True
    Username = 'k61'
    Server = '10.100.17.11:1521:HIDB1'
    LoginPrompt = False
    Schema = 'k61'
    Left = 104
    Top = 128
    EncryptedPassword = '94FFC9FFCEFF'
  end
  object ExtraMHQuery: TOraQuery
    Session = ExtraMHSession
    FetchAll = True
    Options.TemporaryLobUpdate = True
    Left = 168
    Top = 128
  end
  object DPMSAppTransaction: TOraTransaction
    DefaultSession = DPMSAppSession
    Left = 32
    Top = 184
  end
  object DPMSAppSession: TOraSession
    Options.Charset = 'KO16KSC5601'
    Options.UseOCI7 = True
    Options.Direct = True
    Username = 'KA03'
    Server = '10.100.17.215:1521:HIDB'
    Connected = True
    LoginPrompt = False
    Schema = 'KA03'
    Left = 104
    Top = 184
    EncryptedPassword = 'B4FFBEFFCFFFCCFF'
  end
  object DPMSAppQuery: TOraQuery
    Session = DPMSAppSession
    Options.TemporaryLobUpdate = True
    Left = 168
    Top = 184
  end
end
